local rotationZ = 0
local speed = 0

local function wrapAngle(value)
    if not value then
        return 0
    end
    value = math.mod(value, 360)
    if value < 0 then
        value = value + 360
    end
    return value
end

local function differenceBetweenAngles(firstAngle, secondAngle)
    local difference = secondAngle - firstAngle
    if difference > 180 then
        difference = difference - 360
    elseif difference < -180 then
        difference = difference + 360
    end
    return difference
end

function math.clamp(x, min, max)
    return math.min(max, math.max(min, x))
end

addEventHandler("onClientPreRender", root, function (deltaTime)
    deltaTime = deltaTime / 1000

    local state = localPlayer:getData("knockout")
    if state then
        local rx, ry, rz = getElementRotation(localPlayer)
        local trz = -getCamera().rotation.z-90
        if getKeyState("w") then
            speed = speed + (1 - speed) * deltaTime * 5
            localPlayer:setData("knockout_moving", true)
        elseif getKeyState("s") then
            speed = speed + (-1 - speed) * deltaTime * 5
            localPlayer:setData("knockout_moving", true)
            trz = -getCamera().rotation.z-90+180
        else
            speed = speed + (0 - speed) * deltaTime * 10
            localPlayer:setData("knockout_moving", false)
        end

        local angle = differenceBetweenAngles(wrapAngle(rotationZ), wrapAngle(trz)) * 0.1 * speed
        rotationZ = rotationZ + math.clamp(angle, -1.3, 1.3)

        local rotationRad = math.rad(-rotationZ)

        local x, y, z = getElementPosition(localPlayer)
        local vx, vy = math.cos(rotationRad), math.sin(rotationRad)
        if speed > 0 and not isLineOfSightClear(x, y, z - 0.6, x + vx * 0.3, y + vy * 0.3, z - 0.6) then
            speed = 0
        elseif speed < 0 and not isLineOfSightClear(x, y, z - 0.6, x - vx * 2, y - vy * 2, z - 0.6) then
            speed = 0
        end
        -- dxDrawLine3D(x, y, z - 0.6, x + vx * 0.5, y + vy * 0.5, z - 0.6)
        -- dxDrawLine3D(x, y, z - 0.6, x - vx * 2, y - vy * 2, z - 0.6)
        setElementRotation(localPlayer, 0, 0, rotationZ)
        setElementPosition(localPlayer, localPlayer.matrix:transformPosition(speed * deltaTime, 0, 0), false)
    end
end)

addEventHandler("onClientKey", root, function (button)
    local state = localPlayer:getData("knockout")
    if state and button == "lshift" then
        cancelEvent()
    end
end)
