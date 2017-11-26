function initMatch(match)
    match.createdTimestamp = getRealTime().timestamp
    match.waitingTimestamp = match.createdTimestamp

    if isResourceRunning("pb_vehicles") then
        local vehicles = exports.pb_vehicles:generateVehicles(match.dimension)
        for i, element in ipairs(vehicles) do
            addMatchElement(match, element)
        end
    end
    -- Погода
    match.settings.weather = 1
    if math.random() > 0.85 then
        match.settings.weather = 2
    end
    -- Время суток
    match.settings.hour = 12

    changeMatchState(match, "waiting")
end

function getMatchPlayers(match)
    if not isMatch(match) then
        return {}
    end
    local players = {}
    for player in pairs(match.players) do
        if isElement(player) then
            table.insert(players, player)
        end
    end
    return players
end

function getMatchAlivePlayers(match)
    if not isMatch(match) then
        return {}
    end
    local players = {}
    for player in pairs(match.players) do
        if not player:getData("dead") then
            table.insert(players, player)
        end
    end
    return players
end

function getMatchAliveSquads(match)
    if not isMatch(match) then
        return {}
    end
    local squads = {}
    for i, squad in ipairs(match.squads) do
        local hasAlivePlayers = false
        for i, player in ipairs(squad.players) do
            if isElement(player) and match.players[player] and not player:getData("dead") then
                hasAlivePlayers = true
            end
        end
        if hasAlivePlayers then
            table.insert(squads, squad)
        end
    end
    return squads
end

function updateMatch(match)
    local currentTimestamp = getRealTime().timestamp
    local matchTimePassed = currentTimestamp - match.createdTimestamp
    local stateTimePassed = currentTimestamp - match.stateTimestamp

    if match.state == "waiting" then
        if match.forceStart then
            changeMatchState(match, "running")
            return
        end
        local needPlayersCount = math.min(math.max(1, math.floor(#getElementsByType("player") * 0.25)), Config.minMatchPlayers)
        local alivePlayers = getMatchAlivePlayers(match)
        local waitingTimePassed = currentTimestamp - match.waitingTimestamp
        -- Если зашло слишком мало игроков
        if #alivePlayers < needPlayersCount then
            match.waitingTimestamp = currentTimestamp
            triggerMatchEvent(match, "onMatchAlert", resourceRoot, "need_players", { current = #alivePlayers, need = needPlayersCount })
        else
            -- Иначе ждём начала матча
            local timeLeft = Config.matchWaitingTime - waitingTimePassed
            if timeLeft > 0 then
                triggerMatchEvent(match, "onMatchAlert", resourceRoot, "waiting_start", { timeLeft = timeLeft})
            else
                changeMatchState(match, "running")
                return
            end
        end
    elseif match.state == "running" then
        -- Красные зоны
        if not match.redZoneTimestamp then
            match.redZoneTimestamp = currentTimestamp
        end

        if currentTimestamp - match.redZoneTimestamp > match.redZoneTime then
            local alivePlayers = getMatchAlivePlayers(match)
            if #alivePlayers > Config.redZoneMinPlayers and match.currentZone > 2 then
                local randomPlayer = alivePlayers[math.random(1, #alivePlayers)]
                local zoneX = randomPlayer.position.x + math.random(-50, 50)
                local zoneY = randomPlayer.position.y + math.random(-50, 50)
                exports.pb_zones:createRedZone(alivePlayers, zoneX, zoneY)

                match.redZoneTimestamp = currentTimestamp
                match.redZoneTime = math.random(Config.redZoneTimeMin, Config.redZoneTimeMax)
            end
        end

        -- Airdrops
        if isResourceRunning("pb_airdrop") then
            if not match.aidropTimestamp then
                match.aidropTimestamp = currentTimestamp
            end

            if currentTimestamp - match.aidropTimestamp > match.airdropTime then
                if match.currentZone > 0 then
                    local players = getMatchPlayers(match)
                    if #players > 0 then
                        local zoneX, zoneY, zoneRadius = unpack(match.zones[match.currentZone])
                        exports.pb_airdrop:createAirDropWithinZone(match.id, zoneX, zoneY, zoneRadius)
                        match.aidropTimestamp = currentTimestamp
                        match.airdropTime = math.random(Config.airdropTimeMin, Config.airdropTimeMax)
                    end
                end
            end
        end

        -- Синие и белые зоны
        if stateTimePassed < Config.zonesStartTime then
            return
        end

        if match.zoneState == "wait" then
            local zoneTimePassed = currentTimestamp - match.zoneTimestamp
            -- Ожидание закончилось
            if zoneTimePassed >= match.zoneTime then
                match.zoneState = "shrink"
                match.shrinkTimestamp = currentTimestamp

                triggerMatchEvent(match, "onZoneShrink", resourceRoot, match.shrinkTime)
            end
        elseif match.zoneState == "shrink" then
            -- Если уже на последней зоне
            if match.currentZone == 0 then
                return
            end
            local shrinkTimePassed = currentTimestamp - match.shrinkTimestamp
            -- Закончилось сужение зоны
            if shrinkTimePassed >= match.shrinkTime then
                -- Выбираем следующую зону
                match.currentZone = match.currentZone - 1

                match.zoneTime = Config.zonesTime[match.currentZone].wait
                match.shrinkTime = Config.zonesTime[match.currentZone].shrink
                match.zoneTimestamp = currentTimestamp

                if match.currentZone > 0 then
                    triggerMatchEvent(match, "onWhiteZoneUpdate", resourceRoot, match.zones[match.currentZone], match.zoneTime)
                else
                    -- Нулевая зона
                    triggerMatchEvent(match, "onWhiteZoneUpdate", resourceRoot, {match.zones[1][1], match.zones[1][2], 0}, match.zoneTime)
                end

                match.zoneState = "wait"
            end
        end
    elseif match.state == "ended" then
        if stateTimePassed >= Config.matchEndedTime then
            destroyMatch(match)
        end

        local timeLeft = Config.matchEndedTime - stateTimePassed
        if timeLeft > 0 then
            triggerMatchEvent(match, "onMatchAlert", resourceRoot, "waiting_end", { timeLeft = timeLeft - 1})
        end
    end
end

function spawnMatchPlayer(match, player, position)
    if not isMatch(match) or not isElement(player) then
        return false
    end
    if match.state == "waiting" or not position then
        position = Config.waitingPosition + Vector3(math.random()-0.5, math.random()-0.5, 0) * 20
    end
    spawnPlayer(player, position)
    player.model = player:getData("skin") or 0
    player.dimension = match.dimension
    player:setData("dead", false)
end

local function setMatchRunning(match)
    -- Запуск самолёта
    local angle = 0
    local x, y = math.random(-3000, 3000), math.random(-3000, 3000)
    local side = math.random(1, 4)
    local sideSize = Config.planeDistance
    if side == 1 then
        y = sideSize
    elseif side == 2 then
        x = sideSize
    elseif side == 3 then
        y = -sideSize
    elseif side == 4 then
        x = -sideSize
    end
    local angle = math.deg(math.atan2(y, x)) + 90

    local len = Vector2(x, y).length
    local velocityX = -x / len * Config.planeSpeed
    local velocityY = -y / len * Config.planeSpeed

    local randomOffset = (math.random() - 0.5) * 1800
    if side == 1 or side == 3 then
        x = x + randomOffset
        x = math.max(-3000, math.min(3000, x))
    elseif side == 2 or side == 4 then
        y = y + randomOffset
        y = math.max(-3000, math.min(3000, y))
    end

    match.planeVelocity = Vector2(velocityX, velocityY)
    match.planeStartTime = getTickCount()
    match.planeStartPosition = Vector2(x, y)
    triggerMatchEvent(match, "createPlane", resourceRoot, x, y, angle, velocityX, velocityY)

    for player in pairs(match.players) do
        player:setOnFire(false)
        player:setData("isInPlane", true)
        player.alpha = 0
        player.frozen = true
        player:removeData("match_waiting")
        player:setData("kills", 0)
        player:setData("damage_taken", 0)
        player:setData("hp_healed", 0)
        player:setData("boost", 0)

        if isResourceRunning("pb_knockout") then
            exports.pb_knockout:cancelPlayerReviving(player)
            exports.pb_knockout:resetPlayerKnockout(player)
        end

        if isResourceRunning("pb_inventory") then
            exports.pb_inventory:takeAllItems(player)
        end
    end

    -- Зоны
    if isResourceRunning("pb_zones") then
        match.zones = exports.pb_zones:generateZones()
        match.currentZone = #match.zones
        triggerMatchEvent(match, "onZonesInit", resourceRoot, match.zones[match.currentZone])
        match.zoneTime = Config.zonesTime[match.currentZone].wait
        match.shrinkTime = Config.zonesTime[match.currentZone].shrink
        match.redZoneTime = Config.zonesStartTime + math.random(30, 60)
        match.shrinkTimestamp = getRealTime().timestamp
        match.zoneTimestamp = getRealTime().timestamp
        match.zoneState = "shrink"
    end

    if isResourceRunning("pb_airdrop") then
        match.airdropTime = Config.zonesStartTime + math.random(20, 120)
    else
        match.airdropTime = 999999
    end

    triggerMatchEvent(match, "onMatchStarted", resourceRoot, match.totalPlayersCount)
end

function changeMatchState(match, state)
    if not isMatch(match) then
        return false
    end
    if type(state) ~= "string" or state == match.state then
        return false
    end
    match.state = state
    match.stateTimestamp = getRealTime().timestamp

    if state == "running" then
        match.totalSquadsCount = #getMatchAliveSquads(match)
        match.totalPlayersCount = #getMatchAlivePlayers(match)
        match.startTimestamp = match.stateTimestamp
        setMatchRunning(match)
    end
end

function handlePlayerJoinMatch(match, player)
    if not isMatch(match) or not isElement(player) then
        return
    end
    spawnMatchPlayer(match, player)

    player:setData("kills", 0)
    player:setData("match_waiting", true)
    player:setData("isInPlane", false)
    player:setData("dead", false)
    player.alpha = 255

    initPlayerSkillStats(player)

    if isResourceRunning("pb_inventory") then
        exports.pb_inventory:takeAllItems(player)
    end

    local alivePlayers = getMatchAlivePlayers(match)
    triggerMatchEvent(match, "onPlayerJoinedMatch", root, player, #alivePlayers)
    triggerClientEvent(player, "onJoinedMatch", resourceRoot, match.settings, #alivePlayers)
end

function handlePlayerLeaveMatch(match, player)
    if not isMatch(match) or not isElement(player) then
        return
    end

    if match.state ~= "waiting" and not player.dead then
        handlePlayerMatchDeath(match, player, nil)
    end

    if isResourceRunning("pb_accounts") then
        exports.pb_accounts:addPlayerStatsField(player, "stats_hp_healed", player:getData("hp_healed"))
        exports.pb_accounts:addPlayerStatsField(player, "stats_hp_damage", player:getData("damage_taken"))
        exports.pb_accounts:addPlayerStatsField(player, "stats_kills", player:getData("kills"))
    end

    player:removeData("match_waiting")
    player:removeData("kills")
    player:removeData("damage_taken")
    player:removeData("hp_healed")
    player:setData("isInPlane", false)
    if isResourceRunning("pb_knockout") then
        exports.pb_knockout:cancelPlayerReviving(player)
        exports.pb_knockout:resetPlayerKnockout(player)
    end

    player.dimension = 0

    triggerMatchEvent(match, "onPlayerLeftMatch", root, player, reason)
    triggerClientEvent(player, "onLeftMatch", resourceRoot, reason)
end

function handlePlayerLeftMatch(match, player)
    if not isMatch(match) or not isElement(player) then
        return
    end
    if match.state == "waiting" or match.state == "ended" then
        if #getMatchPlayers(match) == 0 then
            destroyMatch(match)
        end
    end
end

local function showSquadFinishScreen(match, squad, rank)
    if not isMatch(match) or type(squad) ~= "table" then
        return false
    end
    local timePassed = getRealTime().timestamp - match.startTimestamp
    local matchType = match.matchType or "solo"

    local ratingAvailable = isResourceRunning("pb_accounts")

    for i, player in ipairs(squad.players) do
        if isElement(player) and isPlayerInMatch(player, match) then
            triggerClientEvent(player, "onMatchFinished", resourceRoot, rank, match.totalSquadsCount, timePassed)

            if ratingAvailable then
                -- Рейтинг
                exports.pb_accounts:updatePlayerRating(player, matchType, rank, player:getData("kills"), match.totalSquadsCount)
                -- Статистика
                exports.pb_accounts:addPlayerStatsField(player, "stats_plays_"..matchType, 1)
                if rank <= 10 then
                    exports.pb_accounts:addPlayerStatsField(player, "stats_top10_"..matchType, 1)
                    if rank == 1 then
                        exports.pb_accounts:addPlayerStatsField(player, "stats_wins_"..matchType, 1)
                    end
                end
            end
        end
    end
    return false
end

local function hasSquadAlivePlayers(match, squad)
    if not isMatch(match) or type(squad) ~= "table" then
        return false
    end
    for i, player in ipairs(squad.players) do
        if isElement(player) and isPlayerInMatch(player, match) and not player:getData("dead") then
            return true
        end
    end
    return false
end

function handlePlayerMatchDeath(match, player, killer, weaponId)
    if not isMatch(match) or not isElement(player) then
        return
    end
    if player:getData("dead") then
        return
    end
    if match.state == "waiting" then
        spawnMatchPlayer(match, player)
        return
    elseif match.state == "running" then
        -- Убийца
        local killerPlayer
        if isElement(killer) then
            if killer.type == "player" then
                killerPlayer = killer
            elseif killer.type == "vehicle" then
                killerPlayer = killer.controller
            end
        end

        -- Нокаут
        if isResourceRunning("pb_knockout") then
            exports.pb_knockout:cancelPlayerReviving(player)

            -- TODO: Только для squad-матчей
            if not player:getData("knockout") then
                local squad = getMatchSquad(match, player:getData("squadId"))

                local squadKnockedOut = true

                for i, p in ipairs(squad.players) do
                    if isElement(p) and not p.dead and p ~= player and not p:getData("knockout") then
                        squadKnockedOut = false
                        break
                    end
                end
                if squadKnockedOut then
                    for i, p in ipairs(squad.players) do
                        if isElement(p) and p ~= player then
                            p:kill()
                        end
                    end
                else
                    for i, p in ipairs(squad.players) do
                        if isElement(p) and not p:getData("dead") and p ~= player and not p:getData("knockout") then
                            break
                        end
                    end
                    spawnMatchPlayer(match, player, player.position)
                    exports.pb_knockout:knockoutPlayer(player, killer)
                    return
                end
            end

            exports.pb_knockout:cancelPlayerReviving(player)
            exports.pb_knockout:resetPlayerKnockout(player)
        end

        if isResourceRunning("pb_inventory") then
            exports.pb_inventory:spawnPlayerLootBox(player)
        end

        player:setData("dead", true)

        -- Обновление счётчика у убийцы
        local knockedBy = player:getData("knockedBy")
        if isElement(knockedBy) then
            -- Засчитать убийство тому, кто уронил игрока
            local kills = knockedBy:getData("kills") or 0
            knockedBy:setData("kills", kills + 1)
            killerPlayer = knockedBy
        elseif isElement(killerPlayer) then
            -- Засчитывать килл убийце
            local kills = killerPlayer:getData("kills") or 0
            killerPlayer:setData("kills", kills + 1)
        end


        -- Статистика
        if isResourceRunning("pb_accounts") then
            exports.pb_accounts:addPlayerStatsField(player, "stats_deaths", 1)
        end

        -- События
        local alivePlayers = getMatchAlivePlayers(match)
        triggerMatchEvent(match, "onMatchPlayerWasted", player, #alivePlayers, killerPlayer, weaponId, not not knockedBy)
        triggerClientEvent(player, "onMatchWasted", resourceRoot)

        -- Проверка оставшихся отрядов
        if match.totalSquadsCount > 1 then
            local aliveSquads = getMatchAliveSquads(match)
            local squad = getMatchSquad(match, player:getData("squadId"))
            if not hasSquadAlivePlayers(match, squad) then
                showSquadFinishScreen(match, squad, #aliveSquads + 1)
            end

            if #aliveSquads <= 1 then
                showSquadFinishScreen(match, aliveSquads[1], 1)
                changeMatchState(match, "ended")
            end
        else
            local aliveSquads = getMatchAliveSquads(match)
            if #aliveSquads == 0 then
                changeMatchState(match, "ended")
            end
        end
    end
end

addEvent("planeJump", true)
addEventHandler("planeJump", resourceRoot, function ()
    local match = getPlayerMatch(client)
    if not isMatch(match) then
        return
    end
    if not client:getData("isInPlane") then
        return
    end

    local timePassed = (getTickCount() - match.planeStartTime) / 1000
    local x = match.planeStartPosition.x + match.planeVelocity.x * timePassed
    local y = match.planeStartPosition.y + match.planeVelocity.y * timePassed
    local z = Config.planeZ - 10

    spawnMatchPlayer(client, Vector3(x, y, z))

    triggerClientEvent(client, "planeJump", resourceRoot)
    client:removeData("isInPlane")
    client.frozen = false
    client.alpha = 255

    if isResourceRunning("pb_inventory") then
        exports.pb_inventory:givePlayerParachute(client)
    end
end)

addEventHandler("onPlayerWasted", root, function (ammo, killer, weaponId)
    local match = getPlayerMatch(source)
    if not isMatch(match) then
        return
    end
    handlePlayerMatchDeath(match, source, killer, weaponId)
end)

addEvent("onMatchElementCreated", false)
addEventHandler("onMatchElementCreated", root, function (matchId)
    local match = getMatchById(matchId)
    if not isMatch(match) then
        destroyElement(source)
        return
    end
    table.insert(match.elements, source)
end)

addEvent("onAirdropLanded", false)
addEventHandler("onAirdropLanded", root, function (matchId, x, y, z)
    if not isResourceRunning("pb_inventory") then
        return
    end
    local match = getMatchById(matchId)
    if not isMatch(match) then
        return
    end
    for name, range in pairs(Config.airdropItems) do
        local count = math.random(range[1], range[2])
        if count > 0 then
            local item = exports.pb_inventory:createItem(name, count)
            exports.pb_inventory:spawnLootItem(item, Vector3(x, y, z), match.dimension)
        end
    end
end)
