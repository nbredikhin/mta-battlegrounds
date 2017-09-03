isLobbyActive = false
local lobbyPosition = Vector3(-2048.503, 304.355, 46.258)
local lobbyCamera = {-2048.503, 304.355, 46.258}

local skins = {10, 46, 62, 72, 142, 154, 170, 182, 217, 68, 70, 213, 206, 243, 204, 49, 39, 312, 309, 295, 129}
local currentSkin = 1

local function setupLobbyPed(ped)
    ped.frozen = true
    ped.model = 46

    setPedAnimation(ped, "ped", "IDLE_HBHB", -1, true, false)
end

function showLobby(enabled)
    if isLobbyActive == not not enabled then
        return
    end
    isLobbyActive = enabled
    toggleAllControls(not enabled)
    showCursor(enabled)
    showPlayerHudComponent("all", false)
    showChat(false)

    if isLobbyActive then
        localPlayer.position = lobbyPosition
        localPlayer.rotation = Vector3(0, 0, 150)

        local cameraPosition = localPlayer.matrix:transformPosition(0, 4, 1)
        setCameraMatrix(cameraPosition, localPlayer.position + Vector3(0, 0, 0.3), 0, 70)
        setTime(12, 0)
        setWeather(12)

        buttonState = false

        setupLobbyPed(localPlayer)

        -- localPlayer.rotation = localPlayer.rotation + Vector3(0, 0, 180)
        updatePlayerSkin()
    else
        localPlayer.frozen = false
    end
end

-- addEventHandler("onClientResourceStart", resourceRoot, function ()
--     showLobby(true)
-- end)

addEventHandler("onCLientResourceStop", resourceRoot, showLobby)

function updatePlayerSkin()
    currentSkin = math.max(1, math.min(#skins, currentSkin))
    localPlayer.model = skins[currentSkin]

    setPedLookAt(localPlayer, localPlayer.matrix:transformPosition(-2, 4, 1), -1, 0)
end

bindKey("arrow_r", "down", function ()
    if not isLobbyActive then
        return
    end

    currentSkin = currentSkin + 1
    if currentSkin > #skins then
        currentSkin = 1
    end

    updatePlayerSkin()
end)

bindKey("arrow_l", "down", function ()
    if not isLobbyActive then
        return
    end

    currentSkin = currentSkin - 1
    if currentSkin < 1 then
        currentSkin = #skins
    end

    updatePlayerSkin()
end)

addEventHandler("onClientKey", root, function (key, down)
    if not isLobbyActive or not down then
        return
    end
    if key == "mouse_wheel_up" then
        localPlayer.rotation = localPlayer.rotation + Vector3(0, 0, 360 * 0.035)
    elseif key == "mouse_wheel_down" then
        localPlayer.rotation = localPlayer.rotation - Vector3(0, 0, 360 * 0.035)
    end
end)
