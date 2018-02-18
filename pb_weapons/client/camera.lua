local screenSize = Vector2(guiGetScreenSize())

local firstPersonEnabled = false

local lookSensitivity = 150
local maxVerticalLookAngle = 85
local minVerticalLookAngle = -80

local previousState = {
    rotationVertical   = 0,
    rotationHorizontal = 0,
}

-- Состояние камеры
local camera = {
    enabled = true,

    -- Поворот камеры
    rotationVertical   = 0,
    rotationHorizontal = 0,

    roll = 0,
    FOV = 70
}

function setCustomCameraEnabled(enabled)
    camera.enabled = not not enabled
end

local function updateFirstPersonCamera()
    local pitch = math.rad(-camera.rotationVertical)
    local yaw = math.rad(camera.rotationHorizontal)
    local lookDirection = Vector3(
        math.cos(yaw) * math.cos(pitch),
        math.sin(yaw) * math.cos(pitch),
        math.sin(pitch))

    -- Vector3(getPedBonePosition(localPlayer, 8))
    local targetPosition = localPlayer.matrix:transformPosition(0.15, 0, 0.46)
    setCameraMatrix(
        targetPosition,
        targetPosition + lookDirection,
        camera.roll,
        camera.FOV
    )
    setCameraTarget(localPlayer.position - lookDirection)

    localPlayer.rotation = Vector3(camera.rotationVertical, 0, camera.rotationHorizontal - 90)
end

local function update3rdPersonCamera()
    local targetElement = getCameraTarget()
    if not isElement(targetElement) then
        return
    end

    local pitch = math.rad(camera.rotationVertical)
    local yaw = math.rad(camera.rotationHorizontal)
    local lookDirection = Vector3(
        math.cos(yaw) * math.cos(pitch),
        math.sin(yaw) * math.cos(pitch),
        math.sin(pitch))

    setCameraTarget(targetElement.position - lookDirection)
end

function setFirstPersonEnabled(enabled)
    if firstPersonEnabled == not not enabled then
        return
    end
    firstPersonEnabled = not not enabled
    if firstPersonEnabled then
        previousState = {
            rotationHorizontal = camera.rotationHorizontal,
            rotationVertical = camera.rotationVertical,
        }
        camera.rotationHorizontal = localPlayer.rotation.z + 90
        camera.rotationVertical = 0
        localPlayer.alpha = 0
    else
        setCameraTarget(localPlayer)
        if previousState.rotationHorizontal then
            camera.rotationHorizontal = previousState.rotationHorizontal
        else
            camera.rotationHorizontal = localPlayer.rotation.z - 90
        end
        camera.rotationVertical = previousState.rotationVertical
        localPlayer.alpha = 255
    end
end

addEventHandler("onClientPreRender", root, function (deltaTime)
    deltaTime = deltaTime / 1000
    -- TODO: Recoil

    -- Камера от первого лица
    if firstPersonEnabled then
        updateFirstPersonCamera()
    else
        update3rdPersonCamera()
    end
end)

local function handleMouseInput(x, y)
    if not camera.enabled or isCursorVisible() then
        return
    end
    setCursorPosition(screenSize.x/2, screenSize.y/2)
    local mx = x - 0.5
    local my = y - 0.5
    camera.rotationHorizontal = camera.rotationHorizontal - mx * lookSensitivity
    camera.rotationVertical   = camera.rotationVertical   + my * lookSensitivity

    -- Ограничение угла обзора камеры по вертикали
    if camera.rotationVertical > maxVerticalLookAngle then
        camera.rotationVertical = maxVerticalLookAngle
    elseif camera.rotationVertical < minVerticalLookAngle then
        camera.rotationVertical = minVerticalLookAngle
    end
    setCursorPosition(screenSize.x/2, screenSize.y/2)
end

addEventHandler("onClientKey", root, function ()
    if not firstPersonEnabled then
        return
    end
    if getControlState("forwards") or getControlState("forwards") or getControlState("forwards") or getControlState("forwards") then
        previousState.rotationHorizontal = false
    end
end)

addEventHandler("onClientCursorMove", root, handleMouseInput)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    setCameraTarget(localPlayer)
    update3rdPersonCamera()
end)

addEventHandler("onClientResourceStop", root, function ()
    setFirstPersonEnabled(false)
end)
