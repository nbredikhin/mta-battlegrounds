local screenSize = Vector2(guiGetScreenSize())

local itemWidth = 300
local itemHeight = 60
local itemSpace = 4

local animOffset = 0

local tagIcons = {}

local visibleItemsCount = math.min(10, math.floor((screenSize.y - 200) / (itemHeight + itemSpace)))
local visibleItemsOffset = 1
local maxVisibleItemsCount = visibleItemsCount

local itemsHeight = visibleItemsCount * (itemHeight + itemSpace) - itemSpace

local itemsX = screenSize.x - itemWidth - 50
local itemsY = screenSize.y / 2 - itemsHeight / 2

local tagNames = {
    "hat",
    "body",
    "jacket",
    "legs",
    "feet",
}

local currentTag = nil
local inventoryItems = {}

local clothesIcons = {}

local function draw()
    drawBattlepoints()

    local x = itemsX + animOffset
    local y = itemsY
    local tagName = localize("clothes_all")
    if currentTag then
        tagName = localize("clothes_" .. currentTag)
    end
    dxDrawText(tagName, x, 0, 0, y - 8, tocolor(255, 255, 255), 2, "default-bold", "left", "bottom")
    dxDrawLine(x, y - 6, x + itemWidth - 1, y - 6, tocolor(255, 255, 255, 150))

    if not inventoryItems then
        return
    end
    local i = 1
    for index = visibleItemsOffset, visibleItemsOffset + visibleItemsCount - 1 do
        local item = inventoryItems[index]
        if item then
            local itemClass = item.itemClass
            dxDrawRectangle(x, y, itemWidth, itemHeight, tocolor(0, 0, 0, 200))
            if not clothesIcons[itemClass.clothes] then
                clothesIcons[itemClass.clothes] = exports.pb_clothes:getClothesIcon(itemClass.clothes)
            end
            local isClothesOnPlayer = localPlayer:getData("clothes_"..itemClass.layer) == itemClass.clothes
            if isClothesOnPlayer then
                dxDrawRectangle(x, y, itemHeight, itemHeight, tocolor(0, 255, 0, 50))
            end
            if clothesIcons[itemClass.clothes] then
                dxDrawImage(x + 5, y + 5, itemHeight - 10, itemHeight - 10, clothesIcons[itemClass.clothes])
            end

            local clothesName = itemClass.readableName or itemClass.clothes:gsub("^%l", string.upper)
            dxDrawText(clothesName, x + itemHeight + 10, y, 0, y + itemHeight, tocolor(255, 255, 255), 1, "default", "left", "center")
            dxDrawText("x" .. item.count, 0, y, x + itemWidth - 10, y + itemHeight, tocolor(255, 255, 255, 150), 1, "default", "right", "center")
            if isMouseOver(x, y, itemWidth, itemHeight) then
                dxDrawRectangle(x, y, itemWidth, itemHeight, tocolor(0, 0, 0, 200))
                local isSellDisabled = item.count == 1 and exports.pb_accounts:getDefaultClothes(itemClass.layer) == itemClass.clothes
                local bx = x
                local bw = itemWidth - itemHeight * 1.5
                if isSellDisabled then
                    bw = itemWidth
                end
                local alpha1 = 100
                if isMouseOver(bx, y, bw, itemHeight) then
                    alpha1 = 200
                    if isMousePressed then
                        if isClothesOnPlayer then
                            triggerServerEvent("onPlayerUnequipClothes", resourceRoot, item.itemClass.layer)
                        else
                            triggerServerEvent("onPlayerSelectClothes", resourceRoot, item.name)
                        end
                    end
                end
                dxDrawRectangle(bx, y, bw, itemHeight, tocolor(255, 255, 255, alpha1))
                if not isClothesOnPlayer then
                    dxDrawText(localize("lobby_clothes_takeon"), bx, y, bx + bw, y + itemHeight, tocolor(0, 0, 0, alpha1), 1.4, "default-bold", "center", "center")
                else
                    dxDrawText(localize("lobby_clothes_takeoff"), bx, y, bx + bw, y + itemHeight, tocolor(0, 0, 0, alpha1), 1.4, "default-bold", "center", "center")
                end

                if not isSellDisabled then
                    bx = bx + bw
                    bw = itemHeight * 1.5
                    local alpha2 = 100
                    if isMouseOver(bx, y, bw, itemHeight) then
                        alpha2 = 200
                        if isMousePressed then
                            triggerServerEvent("onPlayerSellClothes", resourceRoot, item.name)
                        end
                    end
                    dxDrawRectangle(bx, y, bw, itemHeight, tocolor(255, 0, 0, alpha2))
                    dxDrawText(localize("lobby_clothes_sell").."\n("..tostring(item.sellPrice).." BP)", bx, y, bx + bw, y + itemHeight, tocolor(255, 255, 255, alpha2), 1, "default", "center", "center")
                end
            end
            y = y + itemHeight + itemSpace
        end
        i = i + 1
    end

    x = itemsX - itemHeight - 20 + animOffset
    y = itemsY
    for i = 1, #tagNames do
        dxDrawRectangle(x, y, itemHeight, itemHeight, tocolor(0, 0, 0, 200))
        local color = tocolor(255, 255, 255, 100)
        if isMouseOver(x, y, itemHeight, itemHeight) then
            color = tocolor(255, 255, 255, 255)

            if isMousePressed then
                if currentTag ~= tagNames[i] then
                    currentTag = tagNames[i]
                else
                    currentTag = nil
                end
                updateInventory()
                visibleItemsOffset = 1
            end
        end
        if currentTag and tagNames[i] == currentTag then
            color = tocolor(254, 181, 0)
        end
        dxDrawImage(x + 10, y + 10, itemHeight - 20, itemHeight - 20, tagIcons[tagNames[i]], 0, 0, 0, color)
        y = y + itemHeight + itemSpace
    end

    if #inventoryItems > visibleItemsCount then
        x = itemsX + itemWidth + 10 + animOffset
        y = itemsY

        dxDrawRectangle(x, y, 5, itemsHeight, tocolor(0, 0, 0, 50))
        local barHeight = itemHeight * 1.5
        local barY = y + barHeight / 2+ (itemsHeight - barHeight) * (visibleItemsOffset - 1) / (maxVisibleItemsCount - 1)
        dxDrawRectangle(x - 2.5, barY - barHeight / 2, 10, barHeight, tocolor(255, 255, 255, 150))
    end

    animOffset = animOffset - animOffset * 0.1
end

Tabs.character = {
    title = localize("lobby_tab_character"),

    load = function ()
        setClothesCamera(true)
        animOffset = itemWidth + itemHeight * 2
        updateInventory()
    end,

    unload = function ()
        setClothesCamera()
        clothesIcons = {}
    end,

    draw = draw
}

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for i, name in ipairs(tagNames) do
        tagIcons[name] = dxCreateTexture("assets/icons/tags/"..tostring(name)..".png")
    end
end)

function updateInventory()
    local localInventory = exports.pb_accounts:getInventory()
    inventoryItems = {}
    for name, item in pairs(localInventory) do
        local itemClass = exports.pb_accounts:getItemClass(item.name)
        if itemClass and itemClass.clothes then
            item.itemClass = itemClass
            item.sellPrice = exports.pb_accounts:calculateClothesSellPrice(itemClass.price)
            if currentTag then
                if itemClass.layer == currentTag then
                    table.insert(inventoryItems, item)
                end
            else
                table.insert(inventoryItems, item)
            end
        end
    end
    -- table.sort(inventoryItems, function (a, b)
    --     return a.itemClass.readableName < b.itemClass.readableName
    -- end)

    maxVisibleItemsCount = #inventoryItems - visibleItemsCount + 1

    if visibleItemsOffset > maxVisibleItemsCount then
        visibleItemsOffset = maxVisibleItemsCount
    end
    if visibleItemsOffset < 1 then
        visibleItemsOffset = 1
    end
end

addEvent("onClientInventoryUpdated", true)
addEventHandler("onClientInventoryUpdated", root, function ()
    if not isVisible() then
        return
    end
    updateInventory()
end)

addEventHandler("onClientKey", root, function (key, down)
    if not isVisible() then
        return
    end
    if not down then
        return
    end
    local delta
    if key == "mouse_wheel_up" then
        delta = -1
    elseif key == "mouse_wheel_down" then
        delta = 1
    else
        return
    end
    if isMouseOver(itemsX, itemsY, itemWidth, itemsHeight) then
        visibleItemsOffset = visibleItemsOffset + delta

        if visibleItemsOffset > maxVisibleItemsCount then
            visibleItemsOffset = maxVisibleItemsCount
        end
        if visibleItemsOffset < 1 then
            visibleItemsOffset = 1
        end
    end
end)
