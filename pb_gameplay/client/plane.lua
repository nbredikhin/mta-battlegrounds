local currentPlane
local isClientInPlane = false

local velocityX = 0
local velocityY = 0

local startTime = 0
local startX, startY = 0, 0

addEvent("createPlane", true)
addEventHandler("createPlane", resourceRoot, function (x, y, angle, vx, vy)
    if isElement(currentPlane) then
        destroyElement(currentPlane)
    end
    currentPlane = createVehicle(592, x, y, Config.planeZ, 0, 0, angle)
    currentPlane.frozen = true
    currentPlane.dimension = localPlayer.dimension

    local ped = createPed(0, currentPlane.position)
    setTimer(function ()
        ped.vehicle = currentPlane
        ped:setControlState("accelerate", true)
    end, 1000, 1)

    velocityX = vx or 0
    velocityY = vy or 0

    startX = x
    startY = y

    startTime = getTickCount()
    isClientInPlane = true
    startPlaneCamera(currentPlane)
end)

addEventHandler("onClientPreRender", root, function (deltaTime)
    if not isElement(currentPlane) then
        return
    end
    updatePlaneCamera(deltaTime / 1000)
    local passedTime = (getTickCount() - startTime) / 1000
    currentPlane.position = Vector3(startX + velocityX * passedTime, startY + velocityY * passedTime, Config.planeZ - 10)

    if isClientInPlane then
        setElementPosition(localPlayer, currentPlane.position, false)
    end
end)

bindKey("f", "down", function ()
    triggerServerEvent("planeJump", resourceRoot)
end)

addEvent("planeJump", true)
addEventHandler("planeJump", resourceRoot, function ()
    isClientInPlane = false
    stopPlaneCamera()
end)
