local isInventoryVisible = false
local screenSize = Vector2(guiGetScreenSize())

local IconTextures = {}
local inventoryHeight = 800

local borderSpace = 150
local listSpace = 2
local listItemWidth = 215
local listItemHeight = 60
local slotSpace = 15
local equipSlotSize = 118
local weaponSlotSize = (listItemHeight + listSpace) * 3 - listSpace

local colors = {
    border    = tocolor(255, 255, 255),
    item      = tocolor(255, 255, 255, 38),
    item_icon = tocolor(255, 255, 255, 39)
}

local testItems = {
    { name = "bandage", count = math.random(1, 50) },
    { name = "bandage", count = math.random(1, 50) },
    { name = "bandage", count = math.random(1, 50) },
    { name = "bandage", count = math.random(1, 50) },
    { name = "bandage", count = math.random(1, 50) },
}

local function drawItemsList(title, items, x, y, width, height)
    local cy = y

    if title then
        dxDrawText(title, x + 5, y, x + 5, y + 20, tocolor(255, 255, 255, 200), 1, "default", "left", "bottom")
    end
    cy = cy + 25
    local itemIconSize = listItemHeight
    for i, item in ipairs(items) do
        dxDrawRectangle(x, cy, listItemWidth, listItemHeight, colors.item)
        dxDrawRectangle(x, cy, itemIconSize, itemIconSize, colors.item_icon)
        if IconTextures[item.name] then
            dxDrawImage(x, cy, itemIconSize, itemIconSize, IconTextures[item.name])
        end
        if Items[item.name].readableName then
            dxDrawText(Items[item.name].readableName, x + itemIconSize + 5, cy, x + 5, cy + listItemHeight, tocolor(255, 255, 255, 200), 1, "default", "left", "center")
        end
        if item.count and item.count > 1 then
            dxDrawText(item.count, x, cy, x + listItemWidth - 10, cy + listItemHeight, tocolor(255, 255, 255, 200), 1, "default-bold", "right", "center")
        end
        cy = cy + listItemHeight + listSpace
    end
end

local function drawWeaponSlot(slot, x, y, size, hotkey)
    dxDrawRectangle(x - 1, y - 1, size + 2 , size + 2, colors.item)
    dxDrawRectangle(x, y, size, size, tocolor(0, 0, 0, 220))
    local item = getWeaponSlot(slot)
    if not item then
        return
    end
    if IconTextures[item.name] then
        dxDrawImage(x, y, size, size, IconTextures[item.name])
    end
    local nameX = 10
    if hotkey then
        local rx = x
        local ry = y
        local rs = 30
        nameX = nameX + 30
        dxDrawRectangle(rx - 1, ry - 1, rs + 2, rs + 2)
        dxDrawRectangle(rx, ry, rs, rs, tocolor(0, 0, 0, 255))
        dxDrawText(hotkey, rx, ry, rx + rs, ry + rs, tocolor(255, 255, 255, 255), 1.5, "default-bold", "center", "center")
    end
    if Items[item.name].readableName then
        dxDrawText(Items[item.name].readableName, x + nameX, y, x + size - 3, y + 30, tocolor(255, 255, 255, 200), 1.5, "default-bold", "left", "center", true)
    end
    if slot ~= "melee" and item.ammo and item.clip then
        dxDrawText(item.clip .. " / " .. item.ammo, x + 5, y, x + size, y + size - 5, tocolor(255, 255, 255, 200), 1, "default", "left", "bottom", false)
    end
end

local function drawEquipmentSlot(slot, x, y, size)
    dxDrawRectangle(x - 1, y - 1, size + 2 , size + 2, colors.item)
    dxDrawRectangle(x, y, size, size, tocolor(0, 0, 0, 220))
    local item = false--getWeaponSlot(slot)
    if not item then
        return
    end
    if IconTextures[item.name] then
        dxDrawImage(x, y, size, size, IconTextures[item.name])
    end
end

addEventHandler("onClientRender", root, function ()
    if not isInventoryVisible then
        return
    end
    local x = borderSpace
    local y = screenSize.y / 2 - inventoryHeight / 2

    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 200))

    -- Содержимое рюкзака и лут
    drawItemsList("Земля", testItems, x, y, listItemWidth, inventoryHeight)
    x = x + listItemWidth + 15
    dxDrawLine(x, y + 25, x, y + inventoryHeight, tocolor(255, 255, 255, 38))
    x = x + 15
    drawItemsList("Рюкзак", testItems, x, y, listItemWidth, inventoryHeight)

    -- Слоты оружия
    x = screenSize.x - borderSpace - weaponSlotSize - slotSpace - weaponSlotSize
    dxDrawText("Оружие", x + 5, y - 25, x + weaponSlotSize, y - 5, tocolor(255, 255, 255, 200), 1, "default", "left", "bottom")
    drawWeaponSlot("primary1", x, y, weaponSlotSize, "1")
    drawWeaponSlot("primary2", x + slotSpace + weaponSlotSize, y, weaponSlotSize, "2")
    drawWeaponSlot("secondary", x, y + slotSpace + weaponSlotSize, weaponSlotSize, "3")
    drawWeaponSlot("melee", x + slotSpace + weaponSlotSize, y + slotSpace + weaponSlotSize, weaponSlotSize, "4")
    drawWeaponSlot("grenade", x + slotSpace + weaponSlotSize, y + slotSpace * 2 + weaponSlotSize * 2, weaponSlotSize, "5")

    -- Слоты снаряжения
    x = x - slotSpace - equipSlotSize
    dxDrawText("Снаряжение", x + 5, y - 25, x + equipSlotSize, y - 5, tocolor(255, 255, 255, 200), 1, "default", "left", "bottom")
    drawEquipmentSlot("helmet", x, y, equipSlotSize)
    drawEquipmentSlot("backpack", x, y + slotSpace + equipSlotSize, equipSlotSize)
    drawEquipmentSlot("armor", x, y + slotSpace * 2 + equipSlotSize * 2 - 1, equipSlotSize)
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for name, item in pairs(Items) do
        local filename = item.icon or name .. ".png"
        local path = "assets/icons/"..filename
        if fileExists(path) then
            IconTextures[name] = dxCreateTexture(path)
        end
    end

    inventoryHeight = math.min(inventoryHeight, screenSize.y - 100)

    if screenSize.x <= 1000 then
        local mul = (screenSize.x - 800) / (1280 - 800)
        local minScale = 0.68
        local scale = minScale + mul * (1 - minScale)
        slotSpace = slotSpace * scale
        listItemWidth = listItemWidth * scale
        listItemHeight = listItemHeight * scale
        weaponSlotSize = weaponSlotSize * scale
        equipSlotSize = equipSlotSize * scale

        borderSpace = borderSpace * scale / 2
    elseif screenSize.x < 1050 then
        borderSpace = 1
    elseif screenSize.x < 1280 then
        borderSpace = 15
    end

    isInventoryVisible = true
end)
