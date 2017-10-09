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

local function updatePlayerReadyState(player)
    if player and lobbyPeds[player] then
        local state = "[not ready]"
        if player:getData("lobbyReady") then
            state = "[ready]"
        end
        exports.pb_gameplay:addElementNametag(lobbyPeds[player], string.gsub(player.name, '#%x%x%x%x%x%x', '') .. "\n" .. state)
    end
end

function respawnPeds(playersList)
    clearPeds()

    local pedPlayers = {}
    for i, player in ipairs(playersList) do
        if isElement(player) and player ~= localPlayer then
            table.insert(pedPlayers, player)
        end
    end

    for i, player in ipairs(pedPlayers) do
        local ped = createPed(player:getData("skin") or player.model, pedPositions[i].pos, pedPositions[i].rot)
        ped:setData("lobbyPlayer", player, false)
        lobbyPeds[player] = ped
        updatePlayerReadyState(player)
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
    localPlayer:setData("lobbyReady", false)
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

    localPlayer:setData("lobbyReady", false)
end)

function getLobbyPlayers()
    return lobbyPlayersList or {}
end

addEventHandler("onClientElementDataChange", root, function (dataName)
    if not isVisible() then
        return
    end
    if dataName == "skin" then
        if lobbyPeds[source] then
            lobbyPeds[source].model = source:getData("skin")
        end
    elseif dataName == "lobbyReady" then
        if lobbyPeds[source] then
            updatePlayerReadyState(source)
        end
    end
end)

addEvent("onClientInviteDeclined", true)
addEventHandler("onClientInviteDeclined", resourceRoot, function (player, reason)
    showMessageBox("Invite declined\nReason: " .. tostring(reason))
end)

addEvent("onMatchSearchFailed", true)
addEventHandler("onMatchSearchFailed", resourceRoot, function ()
    localPlayer:setData("lobbyReady", false)

    showMessageBox("Не удалось найти матч\nодин из игроков уже в игре")
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
