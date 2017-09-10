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
