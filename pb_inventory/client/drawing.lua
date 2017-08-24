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

local isMouseReleased = false
local isMousePressed = false
local prevMouseState = false
local mouseX, mouseY = 0, 0
local isDragging, dragType, dragItem, dragSlot
local dragItemSize = 45


local colors = {
    border    = tocolor(255, 255, 255),
    item      = tocolor(255, 255, 255, 38),
    item_icon = tocolor(255, 255, 255, 39),
    selection = tocolor(255, 255, 255, 20),
}

function isMouseOver(x, y, w, h)
    return mouseX >= x and mouseX <= x + w and mouseY >= y and mouseY <= y + h
end

function startDragging(slotType, item, slotName)
    if isDragging then
        return
    end
    isDragging = true
    dragType = slotType
    dragSlot = slotName
    dragItem = item
    setCursorAlpha(0)
end

function stopDragging(slotType, slot)
    if not isDragging then
        return
    end
    -- slotType - куда
    -- dragType - откуда
    if slotType == "weapon" then
        if dragType == "loot" then
            triggerServerEvent("pickupLootItem", resourceRoot, dragItem.lootElement, slot)
        end
    elseif slotType == "backpack" then
        if dragType == "loot" then
            triggerServerEvent("pickupLootItem", resourceRoot, dragItem.lootElement)
        end
    elseif slotType == "equipment" then

    elseif slotType == "loot" then
        if dragType == "weapon" then
            triggerServerEvent("dropPlayerWeapon", resourceRoot, dragSlot)
        elseif dragType == "backpack" then
            triggerServerEvent("dropBackpackItem", resourceRoot, dragItem.name)
        end
    end

    isDragging = false
    dragType = nil
    dragItem = nil
    dragSlot = nil
    setCursorAlpha(255)
end

local function drawDragItem()
    if not isDragging or not dragItem then
        return
    end
    local size = dragItemSize
    local x, y = mouseX - size / 2, mouseY - size / 2
    local item = dragItem
    dxDrawRectangle(x - 1, y - 1, size + 2 , size + 2, colors.item)
    dxDrawRectangle(x, y, size, size, tocolor(0, 0, 0, 220))
    if IconTextures[item.name] then
        dxDrawImage(x, y, size, size, IconTextures[item.name])
    end
end

local function drawItemsList(title, items, x, y, width, height, dragType)
    local cy = y

    if title then
        dxDrawText(title, x + 5, y - 25, x + 5, y - 5, tocolor(255, 255, 255, 200), 1, "default", "left", "bottom")
    end
    local itemIconSize = listItemHeight
    for i, item in ipairs(items) do
        if item ~= dragItem then
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
            if isMouseOver(x, cy, listItemWidth, listItemHeight) then
                dxDrawRectangle(x, cy, listItemWidth, listItemHeight, colors.selection)
                if isMousePressed then
                    startDragging(dragType, item)
                end
            end
        end
        cy = cy + listItemHeight + listSpace
    end

    if isMouseOver(x, y, width, height) then
        if isMouseReleased and isDragging then
            stopDragging(dragType)
        end
    end
end

local function drawWeaponSlot(slot, x, y, size, hotkey)
    if isMouseOver(x, y, size, size) then
        if isMouseReleased and isDragging then
            stopDragging("weapon", slot)
        end
    end

    dxDrawRectangle(x - 1, y - 1, size + 2 , size + 2, colors.item)
    dxDrawRectangle(x, y, size, size, tocolor(0, 0, 0, 220))
    local item = getWeaponSlot(slot)
    if not item or item == dragItem then
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
    if isMouseOver(x, y, size, size) then
        dxDrawRectangle(x, y, size, size, colors.selection)
        if isMousePressed then
            startDragging("weapon", item, slot)
        end
    end
end

local function drawEquipmentSlot(slot, x, y, size)
    if isMouseOver(x, y, size, size) then
        if isMouseReleased and isDragging then
            stopDragging("equipment", slot)
        end
    end

    dxDrawRectangle(x - 1, y - 1, size + 2 , size + 2, colors.item)
    dxDrawRectangle(x, y, size, size, tocolor(0, 0, 0, 220))
    local item = false--getWeaponSlot(slot)
    if not item or item == dragItem  then
        return
    end
    if IconTextures[item.name] then
        dxDrawImage(x, y, size, size, IconTextures[item.name])
    end
    if isMouseOver(x, y, size, size) then
        dxDrawRectangle(x, y, size, size, colors.selection)
        if isMousePressed then
            startDragging("equipment", item, slot)
        end
    end
end

addEventHandler("onClientRender", root, function ()
    if not isInventoryVisible then
        return
    end
    local currentMouseState = getKeyState("mouse1")
    if not prevMouseState and currentMouseState then
        isMousePressed = true
    else
        isMousePressed = false
    end
    if prevMouseState and not currentMouseState then
        isMouseReleased = true
    else
        isMouseReleased = false
    end
    prevMouseState = currentMouseState
    local mx, my = getCursorPosition()
    if mx then
        mx = mx * screenSize.x
        my = my * screenSize.y
    else
        mx, my = 0, 0
    end
    mouseX, mouseY = mx, my

    local x = borderSpace
    local y = screenSize.y / 2 - inventoryHeight / 2

    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 200))

    -- Содержимое рюкзака и лут
    drawItemsList("Земля", getLootItems(), x, y, listItemWidth, inventoryHeight, "loot")
    x = x + listItemWidth + 15
    dxDrawLine(x, y, x, y + inventoryHeight, tocolor(255, 255, 255, 38))
    x = x + 15
    drawItemsList("Рюкзак", getBackpackItems(), x, y, listItemWidth, inventoryHeight, "backpack")

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

    if not getKeyState("mouse1") and isDragging then
        stopDragging()
    end
    drawDragItem()
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

    isInventoryVisible = false
end)

function showInventory(visible)
    isInventoryVisible = visible
    showCursor(visible)
    if visible then
        triggerServerEvent("requireClientBackpack", resourceRoot)
    end
end

bindKey("tab", "down", function ()
    showInventory(not isInventoryVisible)
end)
