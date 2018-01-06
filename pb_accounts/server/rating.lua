local ratingCache = {}
local playerRatingCache = {}

function dbRatingQueued(result, params)
    if not isElement(params.player) then
        return
    end
    ratingCache[params.matchType] = result
    triggerClientEvent(params.player, "onClientRatingUpdated", resourceRoot, params.matchType, result)
end

function dbPlayerRatingQueued(result, params)
    if not isElement(params.player) then
        return
    end
    local session = getPlayerSession(params.player)
    if not session then
        return
    end
    if not result or #result == 0 then
        return
    end

    result[1].username = params.player:getData("username")
    result[1].nickname = params.player.name
    result[1].stats_playtime = session.stats.stats_playtime
    result[1]["rating_"..params.matchType.."_main"] = session.rating["rating_"..params.matchType.."_main"]
    result[1]["rating_"..params.matchType.."_kills"] = session.rating["rating_"..params.matchType.."_kills"]
    result[1]["rating_"..params.matchType.."_wins"] = session.rating["rating_"..params.matchType.."_wins"]

    if not playerRatingCache[params.player] then
        playerRatingCache[params.player] = {}
    end
    playerRatingCache[params.player][params.matchType] = result

    triggerClientEvent(params.player, "onClientOwnRatingUpdated", resourceRoot, params.matchType, result)
end

addEvent("onPlayerRequireRating", true)
addEventHandler("onPlayerRequireRating", root, function (matchType)
    if not matchType or (matchType ~= "solo" and matchType ~= "squad") then
        return
    end

    if ratingCache[matchType] then
        triggerClientEvent(client, "onClientRatingUpdated", resourceRoot, matchType, ratingCache[matchType])
        return
    end
    exports.mysql:dbQueryAsync("dbRatingQueued", { player = client, matchType = matchType }, "users", [[
        SELECT
            username,
            nickname,
            rating_]]..matchType..[[_main,
            rating_]]..matchType..[[_wins,
            rating_]]..matchType..[[_kills,
            stats_playtime
        FROM ??
        ORDER BY rating_]]..matchType..[[_main DESC
        LIMIT 10;
    ]])
end)

addEvent("onPlayerRequireOwnRating", true)
addEventHandler("onPlayerRequireOwnRating", root, function (matchType)
    if not matchType or (matchType ~= "solo" and matchType ~= "squad") then
        return
    end
    if playerRatingCache[client] and playerRatingCache[client][matchType] then
        triggerClientEvent(client, "onClientOwnRatingUpdated", resourceRoot, matchType, playerRatingCache[client][matchType])
        return
    end

    local username = client:getData("username")
    if not username then
        return
    end

    exports.mysql:dbQueryAsync("dbPlayerRatingQueued", { player = client, matchType = matchType }, "users", [[
        SELECT COUNT(*) as rank
        FROM ??
        WHERE rating_]]..matchType..[[_main >= (SELECT rating_]]..matchType..[[_main FROM pb_accounts_users WHERE username = ?)
    ]], username)
end)

setTimer(function ()
    ratingCache = {}
    playerRatingCache = {}
end, 60000, 1)

addEventHandler("onPlayerQuit", root, function ()
    playerRatingCache[source] = nil
end)

local function getTopPlayersCount(squads, matchType)
    if matchType == "solo" then
        if squads >= 64 then
            return 10
        elseif squads >= 32 then
            return 6
        elseif squads >= 20 then
            return 5
        elseif squads >= 16 then
            return 3
        else
            return 1
        end
    elseif matchType == "squad" then
        if squads >= 20 then
            return 10
        elseif squads >= 10 then
            return 4
        elseif squads >= 6 then
            return 2
        else
            return 1
        end
    else
        return math.floor(squads * 0.1)
    end
end

function updatePlayerRating(player, matchType, rank, totalSquads)
    if not matchType or not rank or not totalSquads then
        return
    end
    local session = getPlayerSession(player)
    if not session then
        return
    end
    -- Неверный тип матча
    if matchType ~= "solo" and matchType ~= "squad" then
        return
    end
    local playerCountMultiplier = 1
    -- Проверка количества игроков
    if matchType == "squad" and totalSquads < 6 then
        playerCountMultiplier = 0.05
    end
    if matchType == "solo" and totalSquads < 16 then
        playerCountMultiplier = 0.1
    end
    if totalSquads <= 3 then
        return 0
    end

    local kills = tonumber(player:getData("kills")) or 0
    local damageTaken = tonumber(player:getData("damage_taken")) or 0

    local ratingWins = 0
    local ratingKills = 0
    local battlepoints = 0

    local maxTopRank = getTopPlayersCount(totalSquads, matchType)
    local maxGoodRank = math.max(math.floor(totalSquads * 0.5), maxTopRank + 1)
    local maxRank = totalSquads
    local rankMultiplier = 1

    local damageTakenMultiplier = math.min(damageTaken, 300) / 300

    if rank == 1 then
        rankMultiplier = 2
        -- Win rating
        ratingWins = 100 + math.min(kills * math.min(kills, 3), 125)
        ratingWins = ratingWins + 75 * damageTakenMultiplier
        -- Kill rating
        if kills > 0 then
            ratingKills = kills * 10
            if kills > 5 then
                ratingKills = ratingKills + math.min(100, kills * 5)
            end

            ratingKills = ratingKills * 0.8 + ratingKills * damageTakenMultiplier * 0.2
        end
        -- Battlepoints
        battlepoints = 125 + kills * 5 + damageTakenMultiplier * 75
    elseif rank <= maxTopRank then
        rankMultiplier = 1.5 - 0.5 * (1 - (rank - 1)/maxTopRank)
        -- Win rating
        ratingWins = 50 + math.min(kills * 2, 100)
        ratingWins = ratingWins + 50 * damageTakenMultiplier
        -- Kill rating
        if kills > 0 then
            ratingKills = kills * 5
        else
            ratingKills = -20 + 10 * rankMultiplier
        end
        ratingKills = ratingKills * 0.6 + ratingKills * damageTakenMultiplier * 0.4
        -- Battlepoints
        battlepoints = 75 + kills * 2.5 + damageTakenMultiplier * 45
    elseif rank <= maxGoodRank then
        -- Win rating
        ratingWins = kills + 25 * damageTakenMultiplier
        -- Kill rating
        if kills > 0 then
            ratingKills = kills * 2
        else
            ratingKills = -50
        end
        ratingKills = ratingKills * 0.5 + ratingKills * damageTakenMultiplier * 0.5
        -- Battlepoints
        battlepoints = 10 + math.random(1, 6) + kills * 1 + damageTakenMultiplier * 30
    else
        -- Win rating
        ratingWins = -(rank - maxGoodRank) / (maxRank - maxGoodRank) * 125
        ratingWins = ratingWins + kills * math.min(kills, 8)
        ratingWins = ratingWins + 15 * damageTakenMultiplier
        -- Kill rating
        ratingKills = math.max(0, -150 + kills * 5 + 50 * damageTakenMultiplier)
        -- Battlepoints
        battlepoints = math.random(3, 6) + kills * 1 + damageTakenMultiplier * 20
    end

    ratingWins = ratingWins * rankMultiplier * playerCountMultiplier
    ratingKills = ratingKills * rankMultiplier * playerCountMultiplier
    battlepoints = battlepoints * rankMultiplier * playerCountMultiplier

    ratingWins = math.floor(ratingWins)
    ratingKills = math.floor(ratingKills)
    battlepoints = math.floor(battlepoints)

    local currentRatingWins = tonumber(session.rating["rating_"..matchType.."_wins"]) or 0
    local currentRatingKills = tonumber(session.rating["rating_"..matchType.."_kills"]) or 0

    currentRatingWins = math.max(0, currentRatingWins + ratingWins)
    currentRatingKills = math.max(0, currentRatingKills + ratingKills)

    session.rating["rating_"..matchType.."_wins"] = currentRatingWins
    session.rating["rating_"..matchType.."_kills"] = currentRatingKills
    local ratingMain = math.floor(ratingWins + (ratingKills * 0.2))
    session.rating["rating_"..matchType.."_main"] = ratingMain

    outputDebugString("[RATING] "
        ..tostring(player.name) .. " "
        ..matchType .. " rank: "..tostring(rank).."/"..tostring(totalSquads)
        ..", wr="..tostring(ratingWins)
        ..", kr="..tostring(ratingKills)
        ..", mr="..tostring(ratingMain)
        ..", bp="..tostring(battlepoints))

    local currentBattlepoints = tonumber(player:getData("battlepoints"))
    if currentBattlepoints then
        player:setData("battlepoints", currentBattlepoints + battlepoints)
    end
    savePlayerAccount(player)
    return battlepoints
end
