local MOUSE_LOOK_SPEED = 200
local MOUSE_LOOK_VERTICAL_MAX = 85
local MOUSE_LOOK_VERTICAL_MIN = -80

local MOUSE_LOOK_DISTANCE_DELTA = 0.25

local screenSize = Vector2(guiGetScreenSize())

local currentPlane

local isActive = false
local mouseLookActive = false
local mouseScrollEnabled = true
local oldCursorPosition
local skipMouseMoveEvent = false

-- Состояние камеры
local camera = {
    targetPosition = Vector3(0, 0, 0),
    rotationHorizontal = 0,
    rotationVertical = 15,
    distance = Config.planeCameraDistance,
    FOV = 70,
    roll = 0,
    -- Смещение центра камеры вправо, чтобы машины не перекрывалась левой панелью
    centerOffset = 0.8
}

function updatePlaneCamera(deltaTime)
    if not isActive then
        return
    end
    deltaTime = deltaTime / 1000

    -- Прикрепить камеру к автомобилю
    if isElement(currentPlane) then
        camera.targetPosition = currentPlane.position
    else
        camera.targetPosition = localPlayer.position
    end

    local pitch = math.rad(camera.rotationVertical)
    local yaw = math.rad(camera.rotationHorizontal)
    local cameraOffset = Vector3(math.cos(yaw) * math.cos(pitch), math.sin(yaw) * math.cos(pitch), math.sin(pitch))
    local rotationOffset = Vector3(math.cos(yaw - 90), math.sin(yaw - 90), 0) * camera.centerOffset
    setCameraMatrix(
        camera.targetPosition + cameraOffset * camera.distance,
        camera.targetPosition + rotationOffset,
        camera.roll,
        camera.FOV
    )
end

local function mouseMove(x, y)
    if not mouseLookActive or isMTAWindowActive() or isCursorShowing() then
        return
    end
    -- Пропустить первый эвент, чтобы избежать резкого дёргания камеры
    if skipMouseMoveEvent then
        skipMouseMoveEvent = false
        return
    end
    local mx = x - 0.5
    local my = y - 0.5
    camera.rotationHorizontal = camera.rotationHorizontal - mx * MOUSE_LOOK_SPEED
    camera.rotationVertical = camera.rotationVertical + my * MOUSE_LOOK_SPEED

    if camera.rotationVertical > MOUSE_LOOK_VERTICAL_MAX then
        camera.rotationVertical = MOUSE_LOOK_VERTICAL_MAX
    elseif camera.rotationVertical < MOUSE_LOOK_VERTICAL_MIN then
        camera.rotationVertical = MOUSE_LOOK_VERTICAL_MIN
    end
end

function startPlaneCamera(plane)
    if isActive then
        return
    end
    showCursor(true)

    isActive = true
    mouseScrollEnabled = true
    addEventHandler("onClientCursorMove", root, mouseMove)

    -- Сохранить положение курсора
    oldCursorPosition = Vector2(getCursorPosition())
    -- Переместить курсор в центр, чтобы избежать дёргания камеры
    setCursorPosition(screenSize.x / 2, screenSize.y / 2)
    showCursor(false)
    mouseLookActive = true
    skipMouseMoveEvent = true

    currentPlane = plane
end

function stopPlaneCamera()
    if not isActive then
        return
    end
    showCursor(false)

    isActive = false
    removeEventHandler("onClientCursorMove", root, mouseMove)
    setCameraTarget(localPlayer)
end

