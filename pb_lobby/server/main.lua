local lobbyTable = {}

function updateLobby(player, triggerTo)
    if not player or not lobbyTable[player] then
        return
    end
    local playersList = getLobbyPlayers(player)
    for i, player in ipairs(playersList) do
        player:setData("lobbyReady", false)
    end
    if not triggerTo then
        triggerTo = playersList
    end
    local lobbyType = "solo"
    if string.find(string.lower(getServerName()), "squad") or string.find(string.lower(getServerName()), "test") then
        lobbyType = "squad"
    end
    triggerClientEvent(triggerTo, "onLobbyUpdated", resourceRoot, player, playersList, lobbyType)
end

function getLobbyPlayers(lobbyOwner)
    if not lobbyOwner or not lobbyTable[lobbyOwner] then
        return
    end
    local playersList = {}

    for player in pairs(lobbyTable[lobbyOwner]) do
        if not isElement(player) then
            lobbyTable[lobbyOwner][player] = nil
        else
            table.insert(playersList, player)
        end
    end
    table.insert(playersList, lobbyOwner)
    return playersList
end

function isPlayerInOwnLobby(player)
    if not player then
        return false
    end
    local lobbyOwner = player:getData("lobbyOwner")
    if lobbyOwner and lobbyTable[lobbyOwner] then
        return false
    end
    return true
end

function resetPlayerLobby(player, omitEvent)
    if not player then
        return
    end
    local lobbyOwner = player:getData("lobbyOwner")
    if lobbyOwner and lobbyTable[lobbyOwner] then
        lobbyTable[lobbyOwner][player] = nil
        updateLobby(lobbyOwner)
    end
    player:removeData("lobbyOwner")
    player:removeData("lobbyInvite")
    lobbyTable[player] = {}
    if not omitEvent then
        updateLobby(player)
    end
end

function setPlayerLobby(player, lobbyOwner)
    if not player or not lobbyOwner then
        return
    end
    local targetLobby = lobbyTable[lobbyOwner]
    if targetLobby[player] then
        return
    end

    targetLobby[player] = true
    lobbyTable[player] = {}
    player:setData("lobbyOwner", lobbyOwner)
    updateLobby(lobbyOwner)
end

addEventHandler("onPlayerJoin", root, function ()
    resetPlayerLobby(source)
end)

addEventHandler("onPlayerQuit", root, function ()
    resetPlayerLobby(source)
    lobbyTable[source] = nil
end)

addEventHandler("onResourceStart", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        resetPlayerLobby(player, true)
    end
end)

addEvent("onPlayerSendLobbyInvite", true)
addEventHandler("onPlayerSendLobbyInvite", resourceRoot, function (targetPlayer)
    if not isElement(targetPlayer) then
        triggerClientEvent(client, "onClientInviteDeclined", resourceRoot, targetPlayer, "invalid_player")
        return
    end
    if not isPlayerInOwnLobby(targetPlayer) or #getLobbyPlayers(targetPlayer) > 1 then
        triggerClientEvent(client, "onClientInviteDeclined", resourceRoot, targetPlayer, "in_other_lobby")
        return
    end
    if targetPlayer:getData("lobbyInvite") then
        triggerClientEvent(client, "onClientInviteDeclined", resourceRoot, targetPlayer, "already_invited")
        return
    end
    if targetPlayer:getData("matchId") then
        triggerClientEvent(client, "onClientInviteDeclined", resourceRoot, targetPlayer, "playing_match")
        return
    end
    targetPlayer:setData("lobbyInvite", client)
    triggerClientEvent(targetPlayer, "onClientReceiveLobbyInvite", resourceRoot, client)
end)

addEvent("onPlayerAcceptLobbyInvite", true)
addEventHandler("onPlayerAcceptLobbyInvite", resourceRoot, function ()
    local lobbyOwner = client:getData("lobbyInvite")
    if not isElement(lobbyOwner) then
        return
    end
    client:removeData("lobbyInvite")
    setPlayerLobby(client, lobbyOwner)
end)

addEvent("onPlayerDeclineLobbyInvite", true)
addEventHandler("onPlayerDeclineLobbyInvite", resourceRoot, function ()
    local lobbyOwner = client:getData("lobbyInvite")
    if isElement(lobbyOwner) then
        triggerClientEvent(lobbyOwner, "onClientInviteDeclined", resourceRoot, client, "declined_by_player")
    end
    client:removeData("lobbyInvite")
end)

addEvent("onPlayerLeaveLobby", true)
addEventHandler("onPlayerLeaveLobby", resourceRoot, function ()
    resetPlayerLobby(client)
end)

addEvent("updateLobby", true)
addEventHandler("updateLobby", resourceRoot, function ()
    updateLobby(client, client)
end)

addCommandHandler("updatelobby", function (player)
    updateLobby(player, player)
end)

addEvent("onLobbyStartSearch", true)
addEventHandler("onLobbyStartSearch", resourceRoot, function ()
    if not isPlayerInOwnLobby(client) then
        return
    end
    local players = getLobbyPlayers(client)
    exports.pb_gameplay:findMatch(players)
end)
