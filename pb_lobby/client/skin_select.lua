local isActive = false

local pedPosition = Vector3(5157.4, -944, 37.5)

local skins = {46, 10, 62, 72, 142, 154, 170, 182, 217, 68, 70, 213, 206, 243, 204, 49, 39, 312, 309, 295, 129}
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
end

setTimer(function ()
    if isElement(playerPed) then
        setPedLookAt(playerPed, playerPed.matrix:transformPosition(-2, 4, 1), -1, 1000)
    end
end, 1000, 0)

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
    localPlayer.position = pedPosition - Vector3(0, 0, 10)

    playerPed = createLobbyPed(pedPosition)

    addEventHandler("onClientKey", root, handleKey)

    local cameraPosition = Vector3(5155.76, -945.65, 38.2)
    setCameraMatrix(cameraPosition, playerPed.position + Vector3(0, 0, 0.3), 0, 90)

    changeSkin(0)
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
