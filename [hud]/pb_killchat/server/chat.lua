addEvent("sendTeamChat", true)
addEventHandler("sendTeamChat", resourceRoot, function (msg)
    local players = exports.pb_gameplay:getPlayerSquad(client)
    if not players then
        players = client
    end
    triggerClientEvent(players, "sendTeamChat", resourceRoot, client, msg)
end)
