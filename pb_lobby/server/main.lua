local playerLobbies = {}

function createLobby(owner)
    if not isElement(owner) then
        return
    end
    removeLobbyPlayer(owner, true)
    local lobby = {
        players = { [owner] = true },
        owner = owner
    }
    owner:setData("lobbyOwner", owner)
    playerLobbies[owner] = lobby
    updateLobby(owner)
    return lobby
end

function destroyLobby(owner)
    if not owner then
        return false
    end
    -- iprint("destroyLobby", owner)
    if playerLobbies[owner] then
        for player in pairs(playerLobbies[owner].players) do
            player:removeData("lobbyOwner")
            createLobby(player)
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

function removeLobbyPlayer(player, preventCreatingLobby, isDestroying)
    if not isElement(player) then
        return false
    end
    local owner = player:getData("lobbyOwner")
    player:removeData("lobbyOwner")
    if not owner or not playerLobbies[owner] then
        return
    end
    -- iprint("removeLobbyPlayer", player, preventCreatingLobby)
    playerLobbies[owner].players[player] = nil
    if not isDestroying then
        if owner == player then
            destroyLobby(player)
        else
            updateLobby(owner)
        end
    end
    if not preventCreatingLobby then
        createLobby(player)
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

function getPlayerLobbyPlayers(player)
    if not isElement(player) then
        return false
    end
    return getLobbyPlayers(player:getData("lobbyOwner"))
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
    -- iprint("updateLobby", owner)
    for player in pairs(playerLobbies[owner].players) do
        if isElement(player) then
            triggerClientEvent(player, "onLobbyUpdated", resourceRoot, owner, getLobbyPlayers(owner))
        end
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
    for i, player in ipairs(getElementsByType("player")) do
        player:removeData("lobbyOwner")
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
    if #getLobbyPlayers(targetPlayer:getData("lobbyOwner")) > 1 then
        triggerClientEvent(client, "onClientInviteDeclined", resourceRoot, targetPlayer, "another_lobby")
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
        triggerClientEvent(client, "onLobbyUpdated", resourceRoot, lobby.owner, getLobbyPlayers(lobby.owner))
    end
end)

addEvent("onPlayerLobbyKick", true)
addEventHandler("onPlayerLobbyKick", resourceRoot, function (targetPlayer)
    local lobby = getPlayerLobby(client)
    if lobby and lobby.owner == client then
        removeLobbyPlayer(targetPlayer)
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
