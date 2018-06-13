local screenSize = Vector2(guiGetScreenSize())

local firstPersonEnabled = false
local firstPersonX = 0
local firstPersonY = 0
local firstPersonZ = 0

local lookSensitivity = Config.defaultSensitivity
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
    FOV = Config.defaultFOV
}

local recoilVelocityX = 0
local recoilVelocityY = 0

local recoilX = 0
local recoilY = 0

local cameraLookDirection = Vector3()

function setCustomCameraEnabled(enabled)
    camera.enabled = not not enabled
end

function getCameraRecoilVelocity()
    return recoilVelocityX, recoilVelocityY
end

function getCameraLookDirection()
    return cameraLookDirection
end

function getWeaponCameraOffset()
    local weapon = localPlayer:getWeapon()
    if not Config.weaponCameraOffsets[weapon] then
        return false
    else
        return Config.weaponCameraOffsets[weapon]
    end
end

local function updateFirstPersonCamera()
    local pitch = math.rad(-camera.rotationVertical)
    local yaw = math.rad(camera.rotationHorizontal)
    local lookDirection = Vector3(
        math.cos(yaw) * math.cos(pitch),
        math.sin(yaw) * math.cos(pitch),
        math.sin(pitch))

    cameraLookDirection = lookDirection

    local offset = getWeaponCameraOffset()
    if not offset then
        return
    end
    local x = offset.x
    local y = offset.y
    local z = offset.z
    if localPlayer.ducked and offset.ducked then
        x = offset.ducked.x
        y = offset.ducked.y
        z = offset.ducked.z
    end
    firstPersonX = firstPersonX + (x - firstPersonX) * 0.1
    firstPersonY = firstPersonY + (y - firstPersonY) * 0.1
    firstPersonZ = firstPersonZ + (z - firstPersonZ) * 0.1
    local targetPosition = localPlayer.matrix:transformPosition(firstPersonX, firstPersonY, firstPersonZ)
    setCameraMatrix(
        targetPosition,
        targetPosition + lookDirection,
        camera.roll,
        camera.FOV
    )

    -- Вращение оружия игрока
    if not offset.keepTarget then
        setCameraTarget(targetPosition + lookDirection)
    else
        setCameraTarget(localPlayer.matrix:transformPosition(0, 1, 0))
    end

    -- Вращение игрока за камерой
    localPlayer.rotation = Vector3(camera.rotationVertical, 0, camera.rotationHorizontal - 90)

    -- Управление ходьбой
    local canWalk = camera.rotationVertical < 50 and camera.rotationVertical > -50
    toggleControl("forwards", canWalk)
    toggleControl("left", canWalk)
    toggleControl("right", canWalk)
    toggleControl("backwards", canWalk)
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
    cameraLookDirection = lookDirection
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
        camera.rotationVertical = camera.rotationVertical + 33.5
        localPlayer.alpha = 0
    else
        setFirstPersonZoom(1)
        setCameraTarget(localPlayer)
        if previousState.rotationHorizontal then
            camera.rotationHorizontal = previousState.rotationHorizontal
        else
            camera.rotationHorizontal = localPlayer.rotation.z - 90
        end
        camera.rotationVertical = previousState.rotationVertical
        localPlayer.alpha = 255
        toggleControl("forwards", true)
        toggleControl("left", true)
        toggleControl("right", true)
        toggleControl("backwards", true)
    end
end

function setFirstPersonZoom(value)
    if type(value) ~= "number" or value < 1 then
        value = 1
    end
    camera.FOV = Config.defaultFOV / tonumber(value)
    lookSensitivity = Config.defaultSensitivity / tonumber(value)
end

function setWeaponRecoil(x, y)
    recoilX = x or Config.defaultRecoilX
    recoilY = y or Config.defaultRecoilY
end

addEventHandler("onClientPreRender", root, function (deltaTime)
    if not camera.enabled then
        return
    end
    deltaTime = deltaTime / 1000

    recoilVelocityX = recoilVelocityX * math.exp(deltaTime * -15)
    recoilVelocityY = recoilVelocityY * math.exp(deltaTime * -20)
    camera.rotationHorizontal = camera.rotationHorizontal + recoilVelocityX * deltaTime
    camera.rotationVertical = camera.rotationVertical + recoilVelocityY * deltaTime
    -- Ограничение угла обзора камеры по вертикали
    if camera.rotationVertical > maxVerticalLookAngle then
        camera.rotationVertical = maxVerticalLookAngle
    elseif camera.rotationVertical < minVerticalLookAngle then
        camera.rotationVertical = minVerticalLookAngle
    end

    -- Камера от первого лица
    if firstPersonEnabled then
        updateFirstPersonCamera()
    else
        update3rdPersonCamera()
    end
end)

local function handleMouseInput(x, y)
    if not camera.enabled or isCursorVisible()then
        return
    end

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

addEventHandler("onClientPlayerWeaponFire", localPlayer, function ()
    local x = recoilX
    recoilVelocityX = recoilVelocityX + math.random()*x - x/2
    recoilVelocityY = math.max(-recoilY/2, recoilVelocityY - recoilY/2)
end)
