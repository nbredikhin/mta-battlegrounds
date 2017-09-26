local zoneProgress = 0
local shrinkTime = 15
local zoneTime = false
local zonesHidden = true

local blueX = 1800
local blueY = -1600
local blueSize = 900

local whiteX = 1931.36
local whiteY = -1869.88
local whiteSize = 500

local blueZone = {0, 0, 0}

local ZONE_DAMAGE_TIME = 800

local zoneTimeMessages = {
    [60] = "shrink_in_1_minute",
    [30] = "shrink_in_30_seconds",
    [10] = "shrink_in_10_seconds",
}

function localize(name)
    local res = getResourceFromName("pb_lang")
    if (res) and (getResourceState(res) == "running") then
        return exports.pb_lang:localize(name)
    else
        return name
    end
end

function removeZones()
    zoneProgress = 0
    zoneTime = false
    zonesHidden = true
    stopRedZone()
end

addEvent("onZonesInit", true)
addEventHandler("onZonesInit", root, function (zone)
    blueX, blueY, blueSize = unpack(zone)
    zoneProgress = 0
    blueZone = {blueX, blueY, blueSize}
    whiteX, whiteY, whiteSize = blueX, blueY, blueSize
    zonesHidden = true
    zoneTime = false
end)

addEvent("onWhiteZoneUpdate", true)
addEventHandler("onWhiteZoneUpdate", root, function (zone, time)
    zonesHidden = false

    blueX = whiteX
    blueY = whiteY
    blueSize = whiteSize

    zoneProgress = 0
    whiteX = zone[1] or 0
    whiteY = zone[2] or 0
    whiteSize = zone[3] or 0

    shrinkTime = false

    zoneTime = time

    local text = zoneTime .. " СЕК"
    if zoneTime >= 60 then
        local mins = math.floor(zoneTime / 60)
        local secs = zoneTime % 60
        if secs == 0 then
            text = string.format("%d "..localize("alert_min"), mins)
        else
            text = string.format("%d "..localize("alert_min").." %d "..localize("alert_sec"), mins, zoneTime % 60)
        end
    end
    exports.pb_alert:show(localize("alert_new_zone").." "..tostring(text) .. "!", 4000)
end)

addEvent("onZoneShrink", true)
addEventHandler("onZoneShrink", root, function (time)
    shrinkTime = time
    zoneTime = false
    zoneProgress = 0
end)

function getWhiteZone()
    return whiteX, whiteY, whiteSize
end

function getBlueZone()
    return blueZone[1], blueZone[2], blueZone[3], zoneProgress
end

function getBlueZoneRadius()
    return blueSize
end

function isZonesVisible()
    return not zonesHidden
end

function hideZones()
    zonesHidden = true
end

function getZoneTime()
    return zoneTime
end

addEventHandler("onClientPreRender", root, function (dt)
    dt = dt / 1000
    if zoneTime then
        zoneTime = zoneTime - dt
        if zoneTimeMessages[math.floor(zoneTime)] then
            exports.pb_alert:show(localize("alert_shrink_after") .. " "..localize(tostring(zoneTimeMessages[math.floor(zoneTime)])) .. "!", 3000)
        end
        if zoneTime < 0 then
            zoneTime = 0
        end
    end
    if zonesHidden or not shrinkTime then
        return
    end
    zoneProgress = zoneProgress + dt / shrinkTime
    if zoneProgress >= 1 then
        zoneProgress = 1
    end

    local mul = 1 - zoneProgress

    local x = whiteX + (blueX - whiteX) * mul
    local y = whiteY + (blueY - whiteY) * mul
    local size = whiteSize + (blueSize - whiteSize) * mul

    blueZone = {x, y, size}
end)

function isPlayerWithinZone()
    local x, y = blueZone[1], blueZone[2]
    local size = blueZone[3]
    if not x or not y then
        return true
    end
    local radius1 = (Vector2(localPlayer.position.x, localPlayer.position.y) - Vector2(x, y)).length
    return radius1 < size
end

setTimer(function ()
    if zonesHidden then
        return
    end
    if not localPlayer:getData("matchId") then
        return
    end

    if not isPlayerWithinZone() then
        local damageMul = 1 - math.max(0, math.min(1, blueSize / 1000))
        local damage = 14 * damageMul + 1
        localPlayer.health = localPlayer.health - damage
        triggerEvent("onClientCustomDamage", localPlayer)
    end
end, ZONE_DAMAGE_TIME, 0)
