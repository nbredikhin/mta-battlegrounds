local isLobbyActive = false
local lobbyPosition = Vector3(-2048.503, 304.355, 46.258)
local lobbyCamera = {-2048.503, 304.355, 46.258}

local function setupLobbyPed(ped)
    ped.frozen = true

    local lookAt = ped.matrix:transformPosition(-2, 4, 1)
    setPedLookAt(ped, lookAt, -1)

    setPedAnimation(ped, "ped", "IDLE_HBHB", -1, true, false)
end

function showLobby(enabled)
    if isLobbyActive == not not enabled then
        return
    end
    isLobbyActive = enabled


    if isLobbyActive then
        localPlayer.position = lobbyPosition
        localPlayer.rotation = Vector3(0, 0, 150)

        local cameraPosition = localPlayer.matrix:transformPosition(0, 4, 1)
        setCameraMatrix(cameraPosition, localPlayer.position + Vector3(0, 0, 0.3), 0, 70)

        setupLobbyPed(localPlayer)
    else
        localPlayer.frozen = false
        toggleAllControls(true)
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    showLobby(true)
end)

addEventHandler("onCLientResourceStop", resourceRoot, showLobby)
