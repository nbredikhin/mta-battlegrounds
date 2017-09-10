addEvent("playerFindMatch", true)
addEventHandler("playerFindMatch", root, function ()
    findMatch({client})
end)

addEvent("clientLeaveMatch", true)
addEventHandler("clientLeaveMatch", resourceRoot, function ()
    removePlayerFromMatch(client, "leave")
end)

addEvent("planeJump", true)
addEventHandler("planeJump", resourceRoot, function ()
    handlePlayerPlaneJump(client)
end)

addEventHandler("onPlayerQuit", root, function ()
    removePlayerFromMatch(source, "disconnect")
end)

addEventHandler("onPlayerWasted", root, function (...)
    local player = source
    if not isElement(player) then
        return
    end
    local match = getPlayerMatch(player)
    if not match then
        return
    end
    if match.state ~= "running" then
        spawnWaitingPlayer(match, player)
        return
    end

    local aliveCount = getMatchAlivePlayersCount(match)
    local rank = aliveCount + 1
    triggerClientEvent(player, "onMatchFinished", resourceRoot, rank, match.totalPlayers, match.totalTime)
    triggerMatchEvent(match, "onMatchPlayerWasted", player, aliveCount, killerPlayer)
end)
