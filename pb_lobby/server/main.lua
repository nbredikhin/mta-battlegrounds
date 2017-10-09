local playerLobbies = {}
local serverLobbyType = "squad"

function createLobby(owner)
    if not isElement(owner) then
        return
    end
    destroyLobby(owner)
    local lobby = {
        players = {},
        owner = owner
    }
    playerLobbies[owner] = lobby
    addLobbyPlayer(owner, owner)
    return lobby
end

function destroyLobby(owner)
    if not owner then
        return false
    end
    if playerLobbies[owner] then
        for player in pairs(playerLobbies[owner].players) do
            removeLobbyPlayer(player)
        end
    end
    playerLobbies[owner] = nil
end

function addLobbyPlayer(owner, player)
    if not isElement(owner) or not isElement(player) or not playerLobbies[owner] then
        return false
    end
    removeLobbyPlayer(player, true)
    playerLobbies[owner].players[player] = true
    player:setData("lobbyOwner", owner)
    updateLobby(owner)
end

function removeLobbyPlayer(player, preventCreatingLobby)
    if not isElement(player) then
        return false
    end
    local owner = player:getData("lobbyOwner")
    if not owner or not playerLobbies[owner] then
        return
    end
    player:removeData("lobbyOwner")
    if owner and playerLobbies[owner] then
        playerLobbies[owner].players[player] = nil
        if owner == player or not next(playerLobbies[owner].players) then
            destroyLobby(owner)
        else
            updateLobby(owner)
        end
    end
    if not preventCreatingLobby then
        createLobby(player)
    end
end

function getPlayerLobby(player)
    if not isElement(player) then
        return false
    end
    local owner = player:getData("lobbyOwner")
    if owner then
        return playerLobbies[owner]
    end
end

function getLobbyPlayers(owner)
    if not owner or not playerLobbies[owner] then
        return
    end
    local playersList = {}
    for player in pairs(playerLobbies[owner].players) do
        table.insert(playersList, player)
    end
    return playersList
end

function updateLobby(owner)
    if not owner or not playerLobbies[owner] then
        return
    end
    if not next(playerLobbies[owner].players) then
        return destroyLobby(owner)
    end
    for player in pairs(playerLobbies[owner].players) do
        triggerClientEvent(player, "onLobbyUpdated", resourceRoot, owner, getLobbyPlayers(owner), serverLobbyType)
    end
end

addEventHandler("onPlayerJoin", root, function ()
    createLobby(source)
end)

addEventHandler("onPlayerQuit", root, function ()
    removeLobbyPlayer(source)
    destroyLobby(source)
end)

addEventHandler("onResourceStart", resourceRoot, function ()
    serverLobbyType = "solo"
    if string.find(string.lower(getServerName()), "squad") or string.find(string.lower(getServerName()), "test") then
        serverLobbyType = "squad"
    end
    for i, player in ipairs(getElementsByType("player")) do
        createLobby(player)
    end
end)

addEvent("onPlayerSendLobbyInvite", true)
addEventHandler("onPlayerSendLobbyInvite", resourceRoot, function (targetPlayer)
    if not isElement(targetPlayer) then
        triggerClientEvent(client, "onClientInviteDeclined", resourceRoot, targetPlayer, "disconnected")
        return
    end
    if not getPlayerLobby(targetPlayer) then
        triggerClientEvent(client, "onClientInviteDeclined", resourceRoot, targetPlayer, "joining")
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
    local owner = client:getData("lobbyInvite")
    if not isElement(owner) then
        return
    end
    client:removeData("lobbyInvite")
    addLobbyPlayer(owner, client)
end)

addEvent("onPlayerDeclineLobbyInvite", true)
addEventHandler("onPlayerDeclineLobbyInvite", resourceRoot, function ()
    local owner = client:getData("lobbyInvite")
    if isElement(owner) then
        triggerClientEvent(owner, "onClientInviteDeclined", resourceRoot, client, "declined")
    end
    client:removeData("lobbyInvite")
end)

addEvent("onPlayerLeaveLobby", true)
addEventHandler("onPlayerLeaveLobby", resourceRoot, function ()
    removeLobbyPlayer(client)
end)

addEvent("updateLobby", true)
addEventHandler("updateLobby", resourceRoot, function ()
    local lobby = getPlayerLobby(client)
    if lobby then
        triggerClientEvent(client, "onLobbyUpdated", resourceRoot, lobby.owner, getLobbyPlayers(lobby.owner), serverLobbyType)
    end
end)

addCommandHandler("updatelobby", function (player)
    updateLobby(player)
end)

addCommandHandler("lobby", function (player)
    outputConsole(inspect(playerLobbies))
end)

addEvent("onLobbyStartSearch", true)
addEventHandler("onLobbyStartSearch", resourceRoot, function ()
    local lobby = getPlayerLobby(client)
    if not lobby or lobby.owner ~= client then
        return
    end
    local players = getLobbyPlayers(client)
    for i, player in ipairs(players) do
        if player:getData("matchId") then
            triggerClientEvent(players, "onMatchSearchFailed", resourceRoot)
            return
        end
    end
    exports.pb_gameplay:findMatch(players)
end)
