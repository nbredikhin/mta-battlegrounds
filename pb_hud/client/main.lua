local screenSize = Vector2(guiGetScreenSize())

local isHealthbarVisible = true
local healthbarWidth = 400
local healthbarHeight = 28
local healthbarBorder = 1

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
    dxDrawBorderRect(x - 1, y - 1, healthbarWidth + 2, healthbarHeight + 2, tocolor(255, 255, 255, 150), 2)

    local hpMul = localPlayer.health / 100
    local color = tocolor(255, 255, 255)
    if localPlayer.health < 75 then
        color = tocolor(255, 150, 150)
    end
    dxDrawRectangle(x, y, healthbarWidth * hpMul, healthbarHeight, color)

    local healthbarText = string.gsub(localPlayer.name, '#%x%x%x%x%x%x', '') .. " - " .. tostring(getVersion().sortable)
    dxDrawText(healthbarText, x + 1, screenSize.y - 34, x + healthbarWidth + 1, screenSize.y + 1, tocolor(0, 0, 0, 150), 1, "default", "center", "center")
    dxDrawText(healthbarText, x, screenSize.y - 35, x + healthbarWidth, screenSize.y, tocolor(255, 255, 255, 150), 1, "default", "center", "center")
end

addEventHandler("onClientRender", root, function ()
    drawHealthbar()
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    showPlayerHudComponent("all", false)
end)
