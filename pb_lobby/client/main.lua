-- function guiGetScreenSize()
--     return 800, 600
-- end

local pedPositions = {
    { pos = Vector3(131.7, 28.5, 1.289), rot = -30 },
    { pos = Vector3(133, 26.5, 1.289), rot = -50 },
    { pos = Vector3(133.3, 25.2, 1.289), rot = -60 },
}

-- [player] = ped
local lobbyPeds = {}
local currentLobbyOwner = localPlayer
local lobbyPlayersList = {}

function isOwnLobby()
    return currentLobbyOwner == localPlayer
end

function getLobbyType()
    if #lobbyPlayersList > 1 then
        return "squad"
    else
        return "solo"
    end
end

addEventHandler("onClientClick", root, function (button, state, _, _, _, _, _, element)
    if button ~= "left" or state ~= "down" or isLobbyWindowVisible() then
        return
    end
    if not isOwnLobby() then
        return
    end
    if getCurrentTabName() ~= "home" then
        return
    end
    if isElement(element) and getElementType(element) == "ped" then
        local player = element:getData("lobbyPlayer")
        if player then
            showKickWindow(player)
        end
    end
end)

local function updatePlayerReadyState(player)
    if player and lobbyPeds[player] then
        local state = "[not ready]"
        if player:getData("lobbyReady") then
            state = "[ready]"
        end
        lobbyPeds[player].alpha = 255
        if player:getData("matchId") then
            state = "[in match]"
            lobbyPeds[player].alpha = 150
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
        ped.dimension = localPlayer.dimension
        lobbyPeds[player] = ped
        updatePlayerReadyState(player)
        updatePedClothes(ped, player)
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

    triggerServerEvent("updateLobby", resourceRoot)
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
    elseif dataName == "matchId" then
        if lobbyPeds[source] then
            updatePlayerReadyState(source)
        end
    elseif string.find(dataName, "clothes_") then
        if lobbyPeds[source] then
            updatePedClothes(lobbyPeds[source], source)
        elseif source == localPlayer then
            updatePedClothes(getLocalPlayerPed(), localPlayer)
        end
    end
end)

addEvent("onClientInviteDeclined", true)
addEventHandler("onClientInviteDeclined", resourceRoot, function (player, reason)
    showMessageBox(localize("lobby_invite_declined") .. "\n[" .. tostring(reason) .. "]")
end)

addEvent("onMatchSearchFailed", true)
addEventHandler("onMatchSearchFailed", resourceRoot, function ()
    localPlayer:setData("lobbyReady", false)

    showMessageBox(localize("lobby_search_failed"))
end)

setTimer(function ()
    if not isVisible() or not isOwnLobby() then
        return
    end

    for i, player in ipairs(getLobbyPlayers()) do
        if isElement(player) and not player:getData("lobbyReady") then
            return
        end
    end

    triggerServerEvent("onLobbyStartSearch", resourceRoot)
end, 3000, 0)
