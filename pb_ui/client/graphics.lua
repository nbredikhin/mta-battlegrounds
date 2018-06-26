Graphics = {}

-- Цвет отрисовки по умолчанию
local defaultDrawColor = tocolor(255, 255, 255)
-- Шрифт по-умолчанию
local defaultDrawFont = Config.defaultFont
-- Текущий цвет
local drawColor = defaultDrawColor
-- Текущий шрифт
local drawFont = defaultDrawFont
-- Текущий центр координат
local drawX = 0
local drawY = 0
-- Текущий масштаб отрисовки
local drawScale = 1
-- Масштаб текста
local drawTextScale = 1

local drawPostGUI = false

function Graphics.setDrawPostGUI(v)
    drawPostGUI = not not v
end

function Graphics.setScale(scale)
    if not scale then
        scale = 1
    end
    drawScale = scale
    if Config.scalingFontsMode == "scale_text" then
        drawTextScale = scale
    elseif Config.scalingFontsMode == "scale_font" then
        drawTextScale = 1
    end
end

function Graphics.getScale()
    return drawScale
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
    dxDrawRectangle(x*drawScale, y*drawScale, width*drawScale, height*drawScale, drawColor, drawPostGUI, false)
end

function Graphics.line(x1, y1, x2, y2, width)
    x1 = x1 + drawX
    y1 = y1 + drawY
    x2 = x2 + drawX
    y2 = y2 + drawY
    dxDrawLine(x1*drawScale, y1*drawScale, x2*drawScale, y2*drawScale, drawColor, math.max(1, width*drawScale), drawPostGUI)
end

function Graphics.text(x, y, width, height, text, alignX, alignY, clip, wordBreak, colorCoded)
    x = x + drawX
    y = y + drawY
    dxDrawText(text, x*drawScale, y*drawScale, x*drawScale + width*drawScale, y*drawScale + height*drawScale, drawColor, drawTextScale, Assets.getFont(drawFont), alignX, alignY, clip, wordBreak, drawPostGUI, false, colorCoded)
end

function Graphics.getTextWidth(text, font)
    return dxGetTextWidth(text, 1, Assets.getFont(font)) / Graphics.getScale()
end

function Graphics.image(x, y, width, height, image)
    x = x + drawX
    y = y + drawY
    dxDrawImage(x*drawScale, y*drawScale, width*drawScale, height*drawScale, image, 0, 0, 0, drawColor, drawPostGUI)
end
