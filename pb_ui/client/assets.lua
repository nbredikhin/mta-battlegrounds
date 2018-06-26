Assets = {}

local assetTables = {
    font   = {},
    image  = {},
    shader = {}
}

-----------------------
-- Локальные функции --
-----------------------

-- Загрузка ассета из файла для последующего использование
-- Вызывается в Assets.reload
local function loadAsset(assetType, assetName, path, ...)
    if not assetType or not assetName or not path then
        return false
    end
    if not assetTables[assetType] then
        outputDebugString("[UI][ASSETS] Invalid asset type '"..tostring(assetType).."'")
        return false
    end
    local assets = assetTables[assetType]

    if assets[assetName] then
        outputDebugString("[UI][ASSETS] Asset '"..tostring(assetName).."' already exists")
        return false
    end

    local element
    if assetType == "font" then
        element = dxCreateFont(path, ...)
    elseif assetType == "image" then
        element = dxCreateTexture(path, ...)
    end

    assets[assetName] = element

    printDebug("Loaded "..tostring(assetType).." asset: '"..tostring(assetName).."'")
end

------------------------
-- Глобальные функции --
------------------------

-- Получение шрифта по названию
function Assets.getFont(name)
    return assetTables.font[name]
end

-- Получение изображения по названию
function Assets.getImage(name)
    return assetTables.image[name]
end

-- Удаляет старые загруженные ассеты и загружает их заново
-- Необходимо для динамического изменения масштаба шрифтов
function Assets.reload()
    for assetType, assets in pairs(assetTables) do
        for name, asset in pairs(assets) do
            if isElement(asset) then
                destroyElement(asset)
            end
        end
        assetTables[assetType] = {}
    end

    -- Шрифты
    loadAsset("font", "regular", "assets/fonts/OpenSans-Regular.ttf", Scaling.fontSize(Config.fontSizeDefault))
    loadAsset("font", "bold",    "assets/fonts/OpenSans-Bold.ttf",    Scaling.fontSize(Config.fontSizeDefault))
    loadAsset("font", "bold-lg", "assets/fonts/OpenSans-Bold.ttf",    Scaling.fontSize(Config.fontSizeLarge))
    loadAsset("font", "italic",  "assets/fonts/OpenSans-Italic.ttf",  Scaling.fontSize(Config.fontSizeDefault))
    loadAsset("font", "debug",   "assets/fonts/OpenSans-Regular.ttf", Scaling.fontSize(8))

    -- Изображения
    loadAsset("image", "caption-separator", "assets/images/caption-separator.png")
end

-----------------------
-- Обработка событий --
-----------------------

addEventHandler("onClientResourceStart", resourceRoot, function ()
    Assets.reload()
end)
