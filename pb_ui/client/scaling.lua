Scaling = {}

-- Реальные размеры экрана
local screenWidth, screenHeight = guiGetScreenSize()
-- Исходное разрешение до масштабирования
Scaling.screenWidth  = screenWidth
Scaling.screenHeight = screenHeight

-- Глобальное масштабирование
Scaling.scale = 1

if Config.scalingMode == "fit_horizontal" then
    Scaling.scale = screenWidth / Config.scalingWidth
    Scaling.screenWidth  = Config.scalingWidth
    Scaling.screenHeight = Config.scalingHeight
elseif Config.scalingMode == "fit_vertical" then
    Scaling.scale = screenHeight / Config.scalingHeight
    Scaling.screenWidth  = Config.scalingWidth
    Scaling.screenHeight = Config.scalingHeight
end

-- Масштабирует размер шрифта в зависимости от параметров конфига
function Scaling.fontSize(size)
    if Config.scalingFontsMode == "scale_text" then
        return size
    elseif Config.scalingFontsMode == "scale_font" then
        return math.ceil(size * Scaling.scale)
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    -- Установка масштаба отрисовки
    Graphics.setScale(Scaling.scale)
end)
