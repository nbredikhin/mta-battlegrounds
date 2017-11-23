local px, py, pz = 0, 0, 0
local damageDelay = 0

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
        if not localPlayer:getData("reviving") then
            damageDelay = damageDelay - deltaTime
        end
        if damageDelay < 0 then
            damageDelay = 1
            -- localPlayer.health = localPlayer.health - 2
        end
        local x, y, z = getElementPosition(localPlayer)
        if not getKeyState("w") and getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 0.1 then
            setElementVelocity(localPlayer, 0, 0, 0)
            setElementPosition(localPlayer, px, py, z, false)
            localPlayer:setData("knockout_moving", false)
        else
            localPlayer:setData("knockout_moving", true)
        end
        localPlayer:setControlState("left", getKeyState("w"))
        px, py, pz = getElementPosition(localPlayer)
    end
end)

addEventHandler("onClientKey", root, function (button)
    local state = localPlayer:getData("knockout")
    if state and button == "lshift" then
        cancelEvent()
    end
end)
