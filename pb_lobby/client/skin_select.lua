local isActive = false

local pedPosition = Vector3(-2048.503, 304.355, 46.258)

local skins = {10, 46, 62, 72, 142, 154, 170, 182, 217, 68, 70, 213, 206, 243, 204, 49, 39, 312, 309, 295, 129}
local skinIndex = 1
local playerPed

local function createLobbyPed(position)
    local ped = createPed(skins[1], position, 150)
    ped.frozen = true
    ped.dimension = localPlayer.dimension
    setPedAnimation(ped, "ped", "IDLE_HBHB", -1, true, false)
    return ped
end

local function updateSkin()
    skinIndex = math.max(1, math.min(#skins, skinIndex))
    playerPed.model = skins[skinIndex]

    setPedLookAt(playerPed, playerPed.matrix:transformPosition(-2, 4, 1), -1, 0)
end

function changeSkin(delta)
    skinIndex = skinIndex + delta
    if skinIndex < 1 then
        skinIndex = #skins
    elseif skinIndex > #skins then
        skinIndex = 1
    end

    updateSkin()
    localPlayer:setData("skin", playerPed.model)
end

local function handleKey(key, isDown)
    if not isActive or not isDown then
        return
    end

    if key == "arrow_l" then
        changeSkin(-1)
    elseif key == "arrow_r" then
        changeSkin(1)
    elseif key == "mouse_wheel_up" then
        playerPed.rotation = playerPed.rotation + Vector3(0, 0, 360 * 0.035)
    elseif key == "mouse_wheel_down" then
        playerPed.rotation = playerPed.rotation - Vector3(0, 0, 360 * 0.035)
    end
end

function startSkinSelect()
    if isActive then
        return
    end
    isActive = true

    localPlayer.alpha = 0
    localPlayer.frozen = true

    playerPed = createLobbyPed(pedPosition)

    addEventHandler("onClientKey", root, handleKey)

    local cameraPosition = playerPed.matrix:transformPosition(0, 4, 1)
    setCameraMatrix(cameraPosition, playerPed.position + Vector3(0, 0, 0.3), 0, 70)

    setTime(12, 0)
    setWeather(12)
end

function stopSkinSelect()
    if not isActive then
        return
    end
    isActive = false

    if isElement(playerPed) then
        destroyElement(playerPed)
    end

    localPlayer.alpha = 255
    localPlayer.frozen = false

    removeEventHandler("onClientKey", root, handleKey)

    setCameraTarget(localPlayer)
end
