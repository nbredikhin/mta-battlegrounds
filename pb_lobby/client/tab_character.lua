local screenSize = Vector2(guiGetScreenSize())

local itemWidth = 300
local itemHeight = 60
local itemSpace = 4

local animOffset = 0

local tagIcons = {}

local visibleItemsCount = math.min(10, math.floor((screenSize.y - 200) / (itemHeight + itemSpace)))
local visibleItemsOffset = 1

local tagNames = {
    "hat",
    "shirt",
    "pants",
    "shoes"
}

local currentTag = nil
local inventoryItems = {}

local function scrollTEST()
    if visibleItemsOffset > #inventoryItems - visibleItemsCount + 1 then
        visibleItemsOffset = #inventoryItems - visibleItemsCount + 1
    end
    if visibleItemsOffset < 1 then
        visibleItemsOffset = 1
    end
end

local function draw()
    local height = visibleItemsCount * (itemHeight + itemSpace) - itemSpace
    local x = screenSize.x - itemWidth - 50 + animOffset
    local y = screenSize.y / 2 - height / 2
    local tagName = "all"
    if currentTag then
        tagName = currentTag
    end
    dxDrawText(tagName, x, 0, 0, y - 8, tocolor(255, 255, 255), 2, "default-bold", "left", "bottom")
    dxDrawLine(x, y - 6, x + itemWidth - 1, y - 6, tocolor(255, 255, 255, 150))
    inventoryItems = exports.pb_accounts:getInventory()
    local i = 1
    for index = visibleItemsOffset, visibleItemsOffset + visibleItemsCount - 1 do
        if inventoryItems[index] and ((currentTag and exports.pb_accounts:getItemClass(inventoryItems[index].name).layer == currentTag) or not currentTag) then
            dxDrawRectangle(x, y, itemWidth, itemHeight, tocolor(0, 0, 0, 200))
            dxDrawImage(x + 5, y + 5, itemHeight - 10, itemHeight - 10, "assets/icons/jacket1.png")
            dxDrawText(inventoryItems[index].name, x + itemHeight + 10, y, 0, y + itemHeight, tocolor(255, 255, 255), 1, "default", "left", "center")
            dxDrawText("x" .. inventoryItems[index].count, 0, y, x + itemWidth - 10, y + itemHeight, tocolor(255, 255, 255, 150), 1, "default", "right", "center")
            if isMouseOver(x, y, itemWidth, itemHeight) then
                dxDrawRectangle(x, y, itemWidth, itemHeight, tocolor(255, 255, 255, 50))
                if isMousePressed then
                    addPedClothes(inventoryItems[index])
                end
            end
            y = y + itemHeight + itemSpace
        end
        i = i + 1
    end

    y = screenSize.y / 2 - height / 2
    x = x - itemHeight - 20
    for i = 1, #tagNames do
        dxDrawRectangle(x, y, itemHeight, itemHeight, tocolor(0, 0, 0, 200))
        local alpha = 100
        if isMouseOver(x, y, itemHeight, itemHeight) then
            alpha = 200

            if isMousePressed then
                currentTag = tagNames[i]
            end
        end
        if currentTag and tagNames[i] == currentTag then
            alpha = 255
        end
        dxDrawImage(x + 10, y + 10, itemHeight - 20, itemHeight - 20, tagIcons[tagNames[i]], 0, 0, 0, tocolor(255, 255, 255, alpha))
        y = y + itemHeight + itemSpace
    end

    animOffset = animOffset - animOffset * 0.1
end

Tabs.character = {
    title = "CHARACTER",

    load = function ()
        setClothesCamera(true)
        animOffset = itemWidth + itemHeight * 2
    end,

    unload = function ()
        setClothesCamera()
    end,

    draw = draw
}

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for i, name in ipairs(tagNames) do
        tagIcons[name] = dxCreateTexture("assets/icons/tags/"..tostring(name)..".png")
    end
end)
