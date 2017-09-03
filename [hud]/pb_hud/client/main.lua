local screenSize = Vector2(guiGetScreenSize())

DEBUG_DRAW = false

local isHealthbarVisible = true
local healthbarWidth = 400
local healthbarHeight = 28
local healthbarBorder = 1

function isResourceRunning(resName)
    local res = getResourceFromName(resName)
    return (res) and (getResourceState(res) == "running")
end

local function dxDrawBorderRect(x, y, width, height, color, borderWidth)
    dxDrawLine(x, y, x + width, y, color, borderWidth)
    dxDrawLine(x + width, y, x + width, y + height, color, borderWidth)
    dxDrawLine(x + width, y + height, x, y + height, color, borderWidth)
    dxDrawLine(x, y + height, x, y, color, borderWidth)
end

local function drawHealthbar()
    local x = screenSize.x / 2 - healthbarWidth / 2
    local y = screenSize.y - 35 - healthbarHeight

    dxDrawRectangle(x - 1, y - 1, healthbarWidth + 2, healthbarHeight + 2, tocolor(0, 0, 0, 150))

    local hpMul = localPlayer.health / 100
    local color = tocolor(255, 255, 255)
    local borderColor = tocolor(255, 255, 255, 150)
    if localPlayer.health < 75 then
        color = tocolor(255, 150, 150)
    elseif localPlayer.health > 99.5 then
        color = tocolor(255, 255, 255, 100)
        borderColor = tocolor(255, 255, 255, 120)
    end
    dxDrawBorderRect(x - 1, y - 1, healthbarWidth + 2, healthbarHeight + 2, borderColor, 2)
    dxDrawRectangle(x, y, healthbarWidth * hpMul, healthbarHeight, color)

    local healthbarText = string.gsub(localPlayer.name, '#%x%x%x%x%x%x', '') .. " - " .. tostring(getVersion().sortable)
    dxDrawText(healthbarText, x + 1, screenSize.y - 34, x + healthbarWidth + 1, screenSize.y + 1, tocolor(0, 0, 0, 150), 1, "default", "center", "center")
    dxDrawText(healthbarText, x, screenSize.y - 35, x + healthbarWidth, screenSize.y, tocolor(255, 255, 255, 150), 1, "default", "center", "center")

    if DEBUG_DRAW then
        dxDrawText("[health="..tostring(localPlayer.health).."]", x, y - 20, x + healthbarWidth, y,tocolor(0,255,0),1,"default","center","center")
    end
end

local function drawCounter(x, y, count, label)
    local countWidth = dxGetTextWidth(count, 2.8, "default-bold")
    local labelWidth = dxGetTextWidth(label, 2.5, "default")
    x = x - countWidth - labelWidth
    dxDrawRectangle(x, y, countWidth + 10, 42, tocolor(0, 0, 0, 150))
    dxDrawText(count, x + 6, y + 1, x + 5, y, tocolor(0, 0, 0), 2.8, "default-bold")
    dxDrawText(count, x + 5, y, x + 5, y, tocolor(255, 255, 255), 2.8, "default-bold")
    x = x + countWidth + 10
    dxDrawRectangle(x, y, labelWidth + 10, 42, tocolor(255, 255, 255, 150))
    dxDrawText(label, x + 5, y + 1, x + 5, y, tocolor(0, 0, 0, 150), 2.5, "default")
    return countWidth + labelWidth
end

addEventHandler("onClientRender", root, function ()
    drawHealthbar()

    local y = 30
    local x = screenSize.x - 36
    x = x - drawCounter(x, y, "1", "В ЖИВЫХ") - 45
    if (isResourceRunning("pb_map") and exports.pb_map:isVisible()) or
       (isResourceRunning("pb_inventory") and exports.pb_inventory:isVisible())
    then
        drawCounter(x, y, "0", "УБИТО")
    end
end, false, "low-1")

addEventHandler("onClientResourceStart", resourceRoot, function ()
    showPlayerHudComponent("all", false)
    showPlayerHudComponent("crosshair", true)
end)
