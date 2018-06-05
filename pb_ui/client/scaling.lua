Scaling = {}

local screenWidth, screenHeight = guiGetScreenSize()
Scaling.screenWidth  = screenWidth
Scaling.screenHeight = screenHeight

Scaling.scale = 1

if Config.scalingMode == "fit_horizontal" then
    Scaling.scale = screenWidth / Config.scalingWidth
elseif Config.scalingMode == "fit_vertical" then
    Scaling.scale = screenHeight / Config.scalingHeight
end

function Scaling.fontSize(size)
    if Config.scalingFontsMode == "scale_text" then
        return size
    elseif Config.scalingFontsMode == "scale_font" then
        return math.ceil(size * Scaling.scale)
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    Graphics.setScale(Scaling.scale)
end)
