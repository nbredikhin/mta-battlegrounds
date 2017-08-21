local dxScale = 1
local dxOffsetX = 0
local dxOffsetY = 0

-- dx functions
local _dxDrawImage = dxDrawImage
local _dxDrawImageSection = dxDrawImageSection
local _dxDrawLine = dxDrawLine
local _dxDrawRectangle = dxDrawRectangle
local _dxDrawText = dxDrawText
-- local _dxGetFontHeight = dxGetFontHeight

function dxDrawImage(posX, posY, width, height, ...)
    _dxDrawImage(posX * dxScale + dxOffsetX, posY * dxScale + dxOffsetY, width * dxScale, height * dxScale, ...)
end

function dxDrawImageSection(posX, posY, width, height, ...)
    _dxDrawImageSection(posX * dxScale + dxOffsetX, posY * dxScale + dxOffsetY, width * dxScale, height * dxScale, ...)
end

function dxDrawLine(startX, startY, endX, endY, color, width, ...)
    if not width then
        width = 1
    end
    _dxDrawLine(startX * dxScale + dxOffsetX, startY * dxScale + dxOffsetY, endX * dxScale + dxOffsetX, endY * dxScale + dxOffsetY, color, width * dxScale, ...)
end

function dxDrawRectangle(x, y, width, height, ...)
    _dxDrawRectangle(x * dxScale + dxOffsetX, y * dxScale + dxOffsetY, width * dxScale, height * dxScale, ...)
end

function dxDrawText(text, left, top, right, bottom, color, scale, ...)
    if not right then right = left end
    if not bottom then bottom = top end
    _dxDrawText(text, left * dxScale + dxOffsetX, top * dxScale + dxOffsetY, right * dxScale + dxOffsetX, bottom * dxScale + dxOffsetY, color, scale * dxScale, ...)
end

-- function dxGetFontHeight(scale, ...)
--     return _dxGetFontHeight(scale * dxScale, ...)
-- end

function dxSetScale(scale)
    if type(scale) == "number" then
        dxScale = scale
    else
        dxScale = 1
    end
end

function dxTranslate(x, y)
    if not x then
        dxOffsetX = 0
        dxOffsetY = 0
    else
        dxOffsetX = x
        dxOffsetY = y
    end
end
