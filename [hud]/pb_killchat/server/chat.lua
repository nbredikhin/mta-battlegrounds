addEvent("sendTeamChat", true)
addEventHandler("sendTeamChat", resourceRoot, function (msg)
	local players = client
	if client:getData("matchId") then
	    players = exports.pb_gameplay:getPlayerSquad(client)
	    if not players then
	        players = client
	    end
	else
		local lobbyPlayers = exports.pb_lobby:getPlayerLobbyPlayers(client)
		if lobbyPlayers then
			players = {}
			for i, player in ipairs(lobbyPlayers) do
				if isElement(player) and not player:getData("matchId") then
					table.insert(players, player)
				end
			end
		else
			players = client
		end
	end
    triggerClientEvent(players, "sendTeamChat", resourceRoot, client, msg)
end)
