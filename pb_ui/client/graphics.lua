Graphics = {}

local defaultDrawColor = tocolor(255, 255, 255)
local defaultDrawFont = Config.defaultFont

local drawColor = defaultDrawColor
local drawFont = defaultDrawFont
local drawX = 0
local drawY = 0

local drawPostGUI = false

function Graphics.setDrawPostGUI(v)
    drawPostGUI = not not v
end

function Graphics.getGlobalPosition(x, y)
    return x + drawX, y + drawY
end

function Graphics.origin()
    drawX = 0
    drawY = 0
end

function Graphics.translate(x, y)
    drawX = drawX + x
    drawY = drawY + y
end

function Graphics.setColor(color)
    drawColor = color or defaultDrawColor
end

function Graphics.setFont(font)
    drawFont = font or defaultDrawFont
end

function Graphics.rectangle(x, y, width, height)
    x = x + drawX
    y = y + drawY
    dxDrawRectangle(x, y, width, height, drawColor, drawPostGUI, false)
end

function Graphics.line(x1, y1, x2, y2, width)
    x1 = x1 + drawX
    y1 = y1 + drawY
    x2 = x2 + drawX
    y2 = y2 + drawY
    dxDrawLine(x1, y1, x2, y2, drawColor, width, drawPostGUI)
end

function Graphics.text(x, y, width, height, text, alignX, alignY, clip, wordBreak, colorCoded)
    x = x + drawX
    y = y + drawY
    dxDrawText(text, x, y, x + width, y + height, drawColor, 1, Assets.getFont(drawFont), alignX, alignY, clip, wordBreak, drawPostGUI, false, colorCoded)
end

function Graphics.image(x, y, width, height, image)
    x = x + drawX
    y = y + drawY
    dxDrawImage(x, y, width, height, image, 0, 0, 0, drawColor, drawPostGUI)
end
