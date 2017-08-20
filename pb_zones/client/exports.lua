local zoneProgress = 0
local blueX = 1800
local blueY = -1600
local blueSize = 900

local whiteX = 1931.36
local whiteY = -1869.88
local whiteSize = 500

local blueZone = {0, 0, 0}


function getWhiteZone()
    return whiteX, whiteY, whiteSize
end

function getBlueZone()
    return blueZone[1], blueZone[2], blueZone[3], zoneProgress
end

function getBlueZoneRadius()
    return blueSize
end

addEventHandler("onClientPreRender", root, function (dt)
    dt = dt / 1000

    zoneProgress = zoneProgress + dt / 15
    if zoneProgress >= 1 then
        zoneProgress = 0
    end

    local mul = 1 - zoneProgress

    local x = whiteX + (blueX - whiteX) * mul
    local y = whiteY + (blueY - whiteY) * mul
    local size = whiteSize + (blueSize - whiteSize) * mul

    blueZone = {x, y, size}
end)
