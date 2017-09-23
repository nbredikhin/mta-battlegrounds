local isVisible = false
local screenSize = Vector2(guiGetScreenSize())

local offsetX = 37
local offsetY = 30

local barWidth = 160
local barHeight = 12

local function dxDrawBorderRect(x, y, width, height, color, borderWidth)
    dxDrawLine(x, y, x + width, y, color, borderWidth)
    dxDrawLine(x + width, y, x + width, y + height, color, borderWidth)
    dxDrawLine(x + width, y + height, x, y + height, color, borderWidth)
    dxDrawLine(x, y + height, x, y, color, borderWidth)
end

local function drawHealthbar(x, y)
    dxDrawRectangle(x - 1, y - 1, barWidth + 2, barHeight + 2, tocolor(0, 0, 0, 150))

    local health = localPlayer.vehicle.health
    local hpMul = health / 1000
    local color = tocolor(255, 255, 255)
    local borderColor = tocolor(255, 255, 255, 150)
    if health < 750 then
        color = tocolor(255, 150, 150)
    elseif health > 998 then
        color = tocolor(255, 255, 255, 100)
        borderColor = tocolor(255, 255, 255, 120)
    end
    dxDrawBorderRect(x - 1, y - 1, barWidth + 2, barHeight + 2, borderColor, 1)
    dxDrawRectangle(x, y, barWidth * hpMul + 1, barHeight + 1, color)
end

local function drawFuelBar(x, y)
    -- dxDrawRectangle(x - 1, y - 1, barWidth + 2, barHeight + 2, tocolor(0, 0, 0, 150))
    for i = 0, 20 do
        local lx = x + barWidth * (i / 20)
        if i % 5 == 0 then
            dxDrawLine(lx, y, lx, y + barHeight)
            dxDrawLine(lx + 1, y, lx + 1, y + barHeight, tocolor(0, 0, 0, 50))
        else
            dxDrawLine(lx, y + barHeight / 2, lx, y + barHeight)
            dxDrawLine(lx + 1, y + barHeight / 2, lx + 1, y + barHeight, tocolor(0, 0, 0, 50))
        end
    end
    dxDrawLine(x, y + barHeight, x + barWidth, y + barHeight)
    dxDrawLine(x, y + barHeight + 1, x + barWidth, y + barHeight + 1, tocolor(0, 0, 0, 50))

    local maxFuel = exports.pb_fuel:getVehicleMaxFuel(localPlayer.vehicle) or 100
    local fuel = localPlayer.vehicle:getData("fuel") or 0

    local fuelMul = fuel / maxFuel
    dxDrawRectangle(x, y, barWidth * fuelMul + 1, barHeight + 1, tocolor(255, 255, 255, 100))
    dxDrawText("E", x, y - 18, 0, 0, tocolor(200, 0, 0))
    dxDrawText("E", x + 1, y - 17, 0, 0, tocolor(0, 0, 0, 100))

    dxDrawText("F", barWidth - 3 + x, y - 18, 0, 0, tocolor(200, 200, 200))
    dxDrawText("F", barWidth - 3 + x + 1, y - 17, 0, 0, tocolor(0, 0, 0, 100))

    dxDrawImage(x + barWidth * fuelMul - 8, y - 5, 16, barHeight + 7, "assets/arrow.png",0 ,0, 0, tocolor(255, 170, 0))
end

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

addEventHandler("onClientRender", root, function ()
    if not localPlayer.vehicle or not isVisible then
        return
    end
    local x = offsetX
    local y = screenSize.y - offsetY

    y = y - barHeight
    drawHealthbar(x, y)
    y = y - barHeight - 10
    drawFuelBar(x, y)
    y = y - barHeight - 50
    local speed = tostring(math.floor(getElementSpeed(localPlayer.vehicle, "km/h")))
    dxDrawText(speed.." км/ч", x+2, y+2, 0, 0, tocolor(0, 0, 0, 80), 2.5, "default-bold", "left", "top")
    dxDrawText(speed.." км/ч", x, y, 0, 0, tocolor(255, 255, 255), 2.5, "default-bold", "left", "top")
end)

function setVisible(visible)
    isVisible = not not visible
end
