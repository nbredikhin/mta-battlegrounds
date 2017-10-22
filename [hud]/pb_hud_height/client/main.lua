local screenSize = Vector2(guiGetScreenSize())

local barX = 25
local barOffset = 15

local barWidth = 10
local barHeight = 150

local barMaxHeight = 650
local barGroundHeight = 20

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
	if not localPlayer:getData("has_parachute") then
		return
	end
	dxDrawRectangle(barX, barOffset - barHeight, barWidth, barHeight, tocolor(255, 255, 255, 100))
	local groundBarHeight = barGroundHeight / barMaxHeight * barHeight
	dxDrawRectangle(barX, barOffset - groundBarHeight, barWidth, groundBarHeight, tocolor(255, 255, 255))

    local speed = tostring(math.floor(getElementSpeed(localPlayer.vehicle, "km/h"))) .. " " .. exports.pb_lang:localize("hud_kmh")
    local x = barX + barWidth + 10
    local y = screenSize.y - barOffset - barHeight * localPlayer.position.z / barMaxHeight
    dxDrawText(speed, x+2, y+2, 0, 0, tocolor(0, 0, 0, 80), 2.5, "default-bold", "left", "top")
    dxDrawText(speed, x, y, 0, 0, tocolor(255, 255, 255), 2.5, "default-bold", "left", "top")	
end)