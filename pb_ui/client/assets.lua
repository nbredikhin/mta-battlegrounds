Assets = {}

local assetTables = {
    font = {},
    image = {},
    shader = {}
}

-----------------------
-- Локальные функции --
-----------------------

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

function Assets.getFont(name)
    return assetTables.font[name]
end

function Assets.getImage(name)
    return assetTables.image[name]
end

-----------------------
-- Обработка событий --
-----------------------

addEventHandler("onClientResourceStart", resourceRoot, function ()
    -- Шрифты
    loadAsset("font", "regular", "assets/fonts/OpenSans-Regular.ttf", Config.fontSizeDefault)
    loadAsset("font", "bold",    "assets/fonts/OpenSans-Bold.ttf",    Config.fontSizeDefault)
    loadAsset("font", "bold-lg", "assets/fonts/OpenSans-Bold.ttf",    Config.fontSizeLarge)
    loadAsset("font", "italic",  "assets/fonts/OpenSans-Italic.ttf",  Config.fontSizeDefault)
    loadAsset("font", "debug",   "assets/fonts/OpenSans-Regular.ttf", 8)

    -- Изображения
    loadAsset("image", "caption-separator", "assets/images/caption-separator.png")
end)
