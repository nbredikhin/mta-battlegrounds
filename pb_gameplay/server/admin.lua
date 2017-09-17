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
            players_total = match.totalPlayers,
            players_count = #match.players,
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

addCommandHandler("skipzone", function (player, cmd, id)
    if not isPlayerAdmin(player) then
        return
    end
    local id = tonumber(id)

    if id then
        local match = getMatchById(id)
        if not match then
            return
        end

        -- match.shrinkTimer = 0
        match.zoneTimer = 0
    end
end)
