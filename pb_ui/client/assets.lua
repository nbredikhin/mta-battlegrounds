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
