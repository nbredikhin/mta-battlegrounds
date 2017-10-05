local pedPositions = {
    { pos = Vector3 { x = 5157.101, y = -942.891, z = 37.566 }, rot = 130 },
    { pos = Vector3 { x = 5158.386, y = -944.354, z = 37.566 }, rot = 145 },
    { pos = Vector3 { x = 5159.381, y = -944.628, z = 37.566 }, rot = 155 },
}

-- [player] = ped
local lobbyPeds = {}
local currentLobbyOwner = localPlayer
local lobbyPlayersList = {}

local currentLobbyType = "solo"

function getLobbyType()
    return currentLobbyType
end

-- for i, p in ipairs(pedPositions) do
--     local ped = createPed(46+i, p.pos, p.rot)
--     setPedAnimation(ped, "ped", "IDLE_HBHB", -1, true, false)
--     lobbyPeds[ped] = ped
-- end

function isOwnLobby()
    return currentLobbyOwner == localPlayer
end

function respawnPeds(playersList)
    clearPeds()
    for i, player in ipairs(playersList) do
        if player ~= localPlayer then
            local ped = createPed(player:getData("skin") or player.model, pedPositions[i].pos, pedPositions[i].rot)
            ped:setData("lobbyPlayer", player, false)
            lobbyPeds[player] = ped
            exports.pb_gameplay:addElementNametag(ped, string.gsub(player.name, '#%x%x%x%x%x%x', ''))
        end
    end
end

function clearPeds()
    for player, ped in pairs(lobbyPeds) do
        if isElement(ped) then
            destroyElement(ped)
        end
    end
    lobbyPeds = {}
end

setTimer(function ()
    if not isVisible() then
        return
    end
    for player, ped in pairs(lobbyPeds) do
        if isElement(ped) then
            setPedLookAt(ped, ped.position + Vector3(0, 0, 10), 3000, 500)
        end
    end
end, 500, 0)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    setVisible(true)
end)

addEvent("onClientReceiveLobbyInvite", true)
addEventHandler("onClientReceiveLobbyInvite", resourceRoot, function (fromPlayer)
    showInviteWindow(fromPlayer)
end)

addEvent("onLobbyUpdated", true)
addEventHandler("onLobbyUpdated", resourceRoot, function (lobbyOwner, playersList, lobbyType)
    if not isVisible() then
        return
    end
    currentLobbyType = lobbyType
    currentLobbyOwner = lobbyOwner
    respawnPeds(playersList)
    lobbyPlayersList = playersList
end)

function getLobbyPlayers()
    return lobbyPlayersList or {}
end

addEventHandler("onClientElementDataChange", root, function (dataName)
    if not isVisible() then
        return
    end
    if dataName ~= "skin" then
        return
    end
    if lobbyPeds[source] then
        lobbyPeds[source].model = source:getData("skin")
    end
end)

addEvent("onClientInviteDeclined", true)
addEventHandler("onClientInviteDeclined", resourceRoot, function (player, reason)
    showMessageBox("Invite declined\nReason: " .. tostring(reason))
end)

setTimer(function ()
    if not isVisible() or not isOwnLobby() then
        return
    end

    for i, player in ipairs(getLobbyPlayers()) do
        if not player:getData("lobbyReady") then
            return
        end
    end

    triggerServerEvent("onLobbyStartSearch", resourceRoot)
end, 3000, 0)
