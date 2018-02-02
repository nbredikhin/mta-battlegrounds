function isPlayerAdmin(thePlayer)
     local accName=getAccountName(getPlayerAccount(thePlayer))
     if isObjectInACLGroup("user." ..accName, aclGetGroup("Admin")) then
          return true
     end
end

addEvent("requireMatchesList", true)
addEventHandler("requireMatchesList", resourceRoot, function ()
    local list = {}

    for i, match in ipairs(getAllMatches()) do
        table.insert(list, {
            id            = match.id,
            dimension     = match.dimension,
            players_total = match.totalPlayersCount,
            squads_total  = match.totalSquadsCount,
            players_count = #getMatchAlivePlayers(match),
            squads_count  = #getMatchAliveSquads(match),
            players_max   = match.maxPlayers,
            state         = match.state,
            totalTime     = match.totalTime,
        })
    end

    triggerClientEvent(client, "requireMatchesList", resourceRoot, list)
end)

addCommandHandler("startmatch", function (player, cmd, id)
    if not isPlayerAdmin(player) then
        return
    end
    local id = tonumber(id)

    if id then
        local match = getMatchById(id)
        if not match then
            return
        end

        match.forceStart = true
    end
end)

addCommandHandler("matchdrop", function (player, cmd, id)
    if not isPlayerAdmin(player) then
        return
    end
    local id = tonumber(id)

    if id then
        local match = getMatchById(id)
        if not match then
            return
        end

        match.aidropTimestamp = getRealTime().timestamp - match.airdropTime - 1
    end
end)

addCommandHandler("matchredzone", function (player, cmd, id)
    if not isPlayerAdmin(player) then
        return
    end
    local id = tonumber(id)

    if id then
        local match = getMatchById(id)
        if not match then
            return
        end

        match.redZoneTimestamp = getRealTime().timestamp - match.redZoneTime - 1
    end
end)

addCommandHandler("servermode", function (player, cmd, matchType)
    if not isPlayerAdmin(player) then
        return
    end
    if setServerMatchType(matchType) then
        outputConsole("Server gamemode changed to: "..matchType)
    end
end)
