local zoneX, zoneY
local zoneRadius = 200
local zoneTime = 60000
local zoneStartTime = 20000
local zoneTimer
local zoneActive = false

local maxExplosionsCount = 12
local explosionId = 0

local disableDamage = false

function stopRedZone()
    if isTimer(zoneTimer) then
        killTimer(zoneTimer)
    end
    if isTimer(zoneExplosionTimer) then
        killTimer(zoneExplosionTimer)
    end
end

function getRedZone()
    if not isTimer(zoneTimer) then
        return
    end
    return zoneX, zoneY, zoneRadius
end

local function createNextExplosion()
    explosionId = explosionId + 1
    math.randomseed(zoneSeed + explosionId)

    local explosionsCount = math.random(1, maxExplosionsCount)
    local nextExplosionTime = math.random(500, 3000)

    if zoneActive then
        for i = 1, explosionsCount do
            local x, y = getRandomPoint(zoneRadius)
            x = x + zoneX
            y = y + zoneY
            if not disableDamage then
                createExplosion(x, y, getGroundPosition(x, y, 30), 10)
            else
                createExplosion(x, y, getGroundPosition(x, y, 30), 10, true, 0, false)
            end
        end
    end

    if isTimer(zoneTimer) then
        zoneExplosionTimer = setTimer(createNextExplosion, nextExplosionTime, 1)
    end
end

addEvent("onRedZoneCreated", true)
addEventHandler("onRedZoneCreated", resourceRoot, function (x, y, seed)
    zoneX, zoneY = x, y
    zoneSeed = seed or math.random()
    explosionId = 0
    zoneActive = false
    setTimer(function ()
        zoneActive = true
    end, zoneStartTime, 1)
    zoneTimer = setTimer(function ()
        zoneTimer = nil
        if isTimer(zoneExplosionTimer) then
            killTimer(zoneExplosionTimer)
        end
    end, zoneTime, 1)

    exports.pb_alert:show(localize("alert_red_zone"), 6000)
    createNextExplosion()
end)
