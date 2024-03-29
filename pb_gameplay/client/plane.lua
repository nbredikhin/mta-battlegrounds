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
    currentPlane:setCollisionsEnabled(false)

    local ped = createPed(0, currentPlane.position)
    ped.dimension = localPlayer.dimension
    ped.vehicle = currentPlane
    ped.alpha = 0
    setTimer(function ()
        ped.alpha = 255
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

function getFlightDistance()
    return ((getTickCount() - startTime) / 1000) * Config.planeSpeed
end

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
    if math.abs(currentPlane.position.x) > Config.planeDistance + 50 or
       math.abs(currentPlane.position.y) > Config.planeDistance + 50
    then
        destroyElement(currentPlane)
        return
    end

    local flightDistance = getFlightDistance()
    if isClientInPlane and flightDistance > 3000 and
      (math.abs(currentPlane.position.x) > Config.autoParachuteDistance or
       math.abs(currentPlane.position.y) > Config.autoParachuteDistance)
    then
        jumpFromPlane()
    end
end)

function canJumpFromPlane()
    if not isClientInPlane then
        return false
    end
    if getFlightDistance() < 800 then
        return false
    end
    return true
end

function jumpFromPlane()
    if isClientInPlane then
        if localPlayer:getData("dead") then
            return
        end
        if getFlightDistance() < 800 then
            return
        end
        isClientInPlane = false
        localPlayer:setData("isInPlane", false, false)
        triggerServerEvent("planeJump", resourceRoot)
        fadeCamera(false, 0)
    end
end

function destroyPlane()
    if isElement(currentPlane) then
        destroyElement(currentPlane)
    end
end

function getPlane()
    return currentPlane
end

bindKey("f", "down", function ()
    jumpFromPlane()
end)

addEvent("planeJump", true)
addEventHandler("planeJump", resourceRoot, function ()
    isClientInPlane = false
    stopPlaneCamera()
    fadeCamera(true, 1)
end)
