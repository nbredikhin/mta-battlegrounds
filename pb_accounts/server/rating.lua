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

    exports.mysql:dbQueryAsync("dbPlayerRatingQueued", { player = client, matchType = matchType }, "users", [[
        SELECT *
        FROM (SELECT username,
                     stats_playtime,
                     rating_]]..matchType..[[_main,
                     rating_]]..matchType..[[_wins,
                     rating_]]..matchType..[[_kills,
                     @rownum := @rownum + 1 AS rank
                  FROM ??
                  JOIN (SELECT @rownum := 0) r
              ORDER BY rating_]]..matchType..[[_main) x
        WHERE x.username = ?
    ]], username)
end)

setTimer(function ()
    ratingCache = {}
    playerRatingCache = {}
end, 60000, 1)

addEventHandler("onPlayerQuit", root, function ()
    playerRatingCache[source] = nil
end)

function updatePlayerRating(player, matchType, rank, kills, totalSquads)
    if not matchType or not rank or not kills or not totalSquads then
        return
    end
    -- Неверный тип матча
    if matchType ~= "solo" and matchType ~= "squad" then
        return
    end
    -- Проверка количества игроков
    if matchType == "squad" and totalSquads < 3 then
        return
    end
    if matchType == "solo" and totalSquads < 3 then
        return
    end

    local session = getPlayerSession(player)
    if not session then
        return
    end
    local winRating = tonumber(session["rating_"..matchType.."_wins"]) or 0
    local killRating = tonumber(session["rating_"..matchType.."_kills"]) or 0

    local battlepoints = 0

    if rank <= totalSquads * 0.3 then
        battlepoints = battlepoints + 100
        winRating = winRating + (totalSquads * 0.3 - rank + 1) * 2 + totalSquads * 0.5

        if rank <= totalSquads * 0.1 then
            if rank == 1 then
                winRating = winRating + 100 + totalSquads * 2
                killRating = killRating + kills * 3 + totalSquads * 2
                battlepoints = battlepoints + 500 + kills * 70 + totalSquads * 2
            else
                killRating = killRating + kills * 2 + totalSquads
                battlepoints = battlepoints + 1000 + kills * 100 + totalSquads * 1.5
            end
        else
            killRating = killRating + kills + totalSquads * 0.5
            battlepoints = battlepoints + kills * 50
        end
    else
        if rank <= totalSquads * 0.6 then
            winRating = winRating - rank / 2
            killRating = killRating + kills / 2
            battlepoints = battlepoints + kills * 50
        else
            winRating = winRating - rank
            battlepoints = battlepoints + kills * 20
            if kills == 0 then
                killRating = killRating - rank / 3
            end
        end
    end

    if kills == 0 then
        winRating = winRating / 2
        battlepoints = battlepoints / 2
    end

    winRating = math.max(0, math.floor(winRating))
    killRating = math.max(0, math.floor(killRating))
    battlepoints = math.floor(battlepoints)

    session.rating["rating_"..matchType.."_wins"] = winRating
    session.rating["rating_"..matchType.."_kills"] = killRating
    session.rating["rating_"..matchType.."_main"] = math.floor(winRating + (killRating * 0.2))

    iprint("rating", tostring(player.name), "("..tostring(rank).."/"..tostring(totalSquads)..")", matchType, "win="..tostring(winRating), "kill="..tostring(killRating), battlepoints)

    local currentBattlepoints = tonumber(player:getData("battlepoints"))
    if currentBattlepoints then
        player:setData("battlepoints", currentBattlepoints + battlepoints)
        triggerClientEvent(player, "onClientRewardReceived", resourceRoot, battlepoints)
    end

    savePlayerAccount(player)
end
