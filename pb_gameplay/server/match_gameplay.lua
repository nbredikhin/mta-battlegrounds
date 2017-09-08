local zoneProperties = {
    {  },
}

function getMatchAlivePlayersCount(match)
    if not isMatch(match) then
        return false
    end
    local count = 0
    for i, player in ipairs(match.players) do
        if not player.dead then
            count = count + 1
        end
    end
    return count
end

function updateMatchZones(match)
    if not isMatch(match) then
        return false
    end

    if not match.zoneTimer then
        match.zoneTimer = 0
    end
    if not match.shrinkTimer then
        match.shrinkTimer = 0
    end

    if match.zoneTimer > 0 then
        match.zoneTimer = match.zoneTimer - 1
    else
        if match.shrinkTimer > 0 then
            if match.zoneTimer == 0 then
                exports.pb_alert:show(match.players, "ОГРАНИЧЕНИЕ ИГРОВОЙ ОБЛАСТИ!", 4000)
                triggerMatchEvent(match, "onZoneShrink", resourceRoot, match.shrinkTimer)
                match.zoneTimer = -1
            end
            match.shrinkTimer = match.shrinkTimer - 1
        else
            if match.currentZone > 1 then
                local zone = exports.pb_zones:getZone(match.currentZone)
                match.zoneTimer = zone.time
                match.shrinkTimer = zone.shrink
                if match.zoneTimer > 0 then
                    triggerMatchEvent(match, "onWhiteZoneUpdate", resourceRoot, match.zones[match.currentZone - 1], match.zoneTimer)
                end

                match.currentZone = match.currentZone - 1
            elseif match.currentZone == 1 then
                local zone = exports.pb_zones:getZone(match.currentZone)
                match.zoneTimer = zone.time
                match.shrinkTimer = zone.shrink
                triggerMatchEvent(match, "onWhiteZoneUpdate", resourceRoot, {match.zones[1][1], match.zones[1][2], 0}, match.zoneTimer)

                match.currentZone = 0
            end
        end
    end
end

function updateMatch(match)
    if not isMatch(match) then
        return false
    end

    if match.state == "waiting" then
        local timeLeft = Config.matchWaitingTime - match.stateTime
        if timeLeft > 0 then
            exports.pb_alert:show(match.players, "МАТЧ НАЧИНАЕТСЯ ЧЕРЕЗ\n"..tostring(timeLeft), 2000, 0xFFAAFAE1)
        end
        if match.stateTime >= Config.matchWaitingTime then
            setMatchState(match, "running")
        end
    elseif match.state == "running" then
        updateMatchZones(match)
        -- if getMatchAlivePlayersCount(match) <= 1 then
        --     setMatchState(match, "ended")
        -- end
    elseif match.state == "ended" then
        if match.stateTime >= Config.matchEndedTime then
            destroyMatch(match)
        end
    end
end

function playerFinishMatch(match, player)
    if not isMatch(match) then
        return false
    end
    if not isElement(player) then
        return
    end
    local rank = getMatchAlivePlayersCount(match)
    triggerMatchEvent(match, "onPlayerFinishMatch", resourceRoot, rank)
    triggerClientEvent(player, "onFinishMatch", resourceRoot, rank)
end

function setMatchState(match, state)
    if not isMatch(match) then
        outputDebugString("setMatchState: invalid match")
        return false
    end
    if state == match.state then
        return false
    end
    match.state = state
    match.stateTime = 0

    if state == "running" then
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

        match.planeVelocity = Vector2(velocityX, velocityY)
        match.planeStartTime = getTickCount()
        match.planeStartPosition = Vector2(x, y)
        triggerMatchEvent(match, "createPlane", resourceRoot, x, y, angle, velocityX, velocityY)

        for i, player in ipairs(match.players) do
            player:setData("isInPlane", true)
            player.alpha = 0
            player.frozen = true
            player:removeData("match_waiting")
        end

        if isResourceRunning("pb_zones") then
            match.zones = exports.pb_zones:generateZones()
            match.currentZone = #match.zones
            triggerMatchEvent(match, "onZonesInit", resourceRoot, match.zones[match.currentZone])
            match.zoneTimer = 90
        end

        triggerMatchEvent(match, "onMatchStarted", resourceRoot, getMatchAlivePlayersCount(match))
    end
end

function triggerMatchEvent(match, ...)
    if not isMatch(match) then
        return
    end
    triggerClientEvent(match.players, ...)
end

-- До входа любого игрока
function initMatch(match)

    -- TODO: Spawn loot
    -- TODO: Выбор времени, погоды и т д (match.settings)
end

function handlePlayerJoinMatch(match, player)
    player.dimension = match.dimension

    spawnPlayer(player, Config.waitingPosition + Vector3(math.random()-0.5, math.random()-0.5, 0) * 20)
    player.model = player:getData("skin") or 0
    player.dimension = match.dimension

    player:setData("match_waiting", true)

    local aliveCount = getMatchAlivePlayersCount(match)
    triggerMatchEvent(match, "onPlayerJoinedMatch", root, player, aliveCount)
    triggerClientEvent(player, "onJoinedMatch", resourceRoot, match.settings)
end

function handlePlayerLeaveMatch(match, player, reason)
    player.dimension = 0

    player:removeData("match_waiting")
    local aliveCount = getMatchAlivePlayersCount(match)
    triggerMatchEvent(match, "onPlayerLeftMatch", root, player, reason, aliveCount)
    triggerClientEvent(player, "onLeftMatch", resourceRoot, reason)
end

function handlePlayerPlaneJump(player)
    if not isElement(player) then
        return
    end
    local match = getPlayerMatch(player)
    if not match then
        return
    end
    if not player:getData("isInPlane") then
        return
    end

    local timePassed = (getTickCount() - match.planeStartTime) / 1000
    local x = match.planeStartPosition.x + match.planeVelocity.x * timePassed
    local y = match.planeStartPosition.y + match.planeVelocity.y * timePassed
    local z = Config.planeZ - 10

    spawnPlayer(player, Vector3(x, y, z))
    player.model = player:getData("skin") or 0
    player.dimension = match.dimension

    triggerClientEvent(player, "planeJump", resourceRoot)
    player:removeData("isInPlane")
    player.frozen = false
    player.alpha = 255

    if isResourceRunning("pb_inventory") then
        exports.pb_inventory:takeAllItems(player)
        exports.pb_inventory:givePlayerParachute(player)
    end
end

addEvent("planeJump", true)
addEventHandler("planeJump", resourceRoot, function ()
    handlePlayerPlaneJump(client)
end)
