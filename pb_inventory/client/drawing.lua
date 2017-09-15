local isInventoryVisible = false
local screenSize = Vector2(guiGetScreenSize())

local IconTextures = {}
local inventoryHeight = 800

local borderSpace = 150
local listSpace = 2
local listItemWidth = 215
local listItemHeight = 60
local slotSpace = 15
local equipSlotSize = 135
local weaponSlotSize = (listItemHeight + slotSpace) * 3 - slotSpace
local capacityBarWidth = 15
local capacityBarHeight = weaponSlotSize * 2 + slotSpace
local capacityBarTexture

local isMouseReleased = false
local isMousePressed = false
local isRightMousePressed = false
local prevRightMouseState = false
local prevMouseState = false
local mouseX, mouseY = 0, 0
local isDragging, dragType, dragItem, dragSlot
local dragItemSize = 45

local weightErrorTimer
local currentBarWeight = 0

local separateWindowWidth = 350
local separateWindowHeight = 200
local isSeparateWindowVisible = false
local separateItem
local separateCount = 0

local colors = {
    border    = tocolor(255, 255, 255),
    item      = tocolor(255, 255, 255, 38),
    item_icon = tocolor(255, 255, 255, 39),
    selection = tocolor(255, 255, 255, 20),
}

local itemLists = {}

local testItems = {}
for i = 1, 100 do
    table.insert(testItems, {name="bandage", count=i})
end

function isMouseOver(x, y, w, h)
    return mouseX >= x and mouseX <= x + w and mouseY >= y and mouseY <= y + h
end

function showSeparateWindow(item)
    if isSeparateWindowVisible then
        return
    end
    isSeparateWindowVisible = true
    separateItem = item
    separateCount = math.floor(item.count / 2)
end

function hideSeparateWindow(drop)
    if not isSeparateWindowVisible then
        return
    end
    if drop then
        local count = math.max(1, math.min(separateItem.count, separateCount))
        triggerServerEvent("dropBackpackItem", resourceRoot, separateItem.name, count)
    end
    isSeparateWindowVisible = false
    separateItem = nil
    separateCount = nil
end

function startDragging(slotType, item, slotName)
    if isDragging then
        return
    end
    if isSeparateWindowVisible then
        stopDragging()
        return
    end
    isDragging = true
    dragType = slotType
    dragSlot = slotName
    dragItem = item
    setCursorAlpha(0)
end

local function showWeightError()
    if isTimer(weightErrorTimer) then
        killTimer(weightErrorTimer)
    end
    weightErrorTimer = setTimer(function () end, 2000, 1)
end

function tryPickupLootItem(item)
    if not isItem(item) then
        return
    end
    if getBackpackTotalWeight() + getItemWeight(item) > getBackpackCapacity() then
        showWeightError()
    end
    triggerServerEvent("pickupLootItem", resourceRoot, item.lootElement)
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
        elseif dragType == "weapon" then
            if string.find(dragSlot, "primary") and string.find(slot, "primary") and dragSlot ~= slot then
                triggerServerEvent("switchPrimaryWeapons", resourceRoot)
            end
        elseif dragType == "backpack" then
            triggerServerEvent("putBackpackItemToWeapon", resourceRoot, dragItem.name, slot)
        end
    elseif slotType == "backpack" then
        if dragType == "loot" then
            tryPickupLootItem(dragItem)
        elseif dragType == "weapon" then
            triggerServerEvent("putWeaponToBackpack", resourceRoot, dragSlot)
        end
    elseif slotType == "equipment" then
        if dragType == "loot" then
            triggerServerEvent("pickupLootItem", resourceRoot, dragItem.lootElement)
        end
    elseif slotType == "loot" then
        if dragType == "weapon" then
            triggerServerEvent("dropPlayerWeapon", resourceRoot, dragSlot)
        elseif dragType == "backpack" then
            if getKeyState("lctrl") then
                showSeparateWindow(dragItem)
            else
                triggerServerEvent("dropBackpackItem", resourceRoot, dragItem.name)
            end
        elseif dragType == "equipment" then
            if dragSlot == "backpack" and Config.defaultBackpackCapacity < getBackpackTotalWeight() then
                showWeightError()
                return
            end
            triggerServerEvent("dropPlayerEquipment", resourceRoot, dragSlot)
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
    if getKeyState("lctrl") then
        local offset = 6
        dxDrawRectangle(x - 1 + offset, y - 1 + offset, size + 2 , size + 2, colors.item)
        dxDrawRectangle(x + offset, y + offset, size, size, tocolor(0, 0, 0, 220))
    end
    dxDrawRectangle(x - 1, y - 1, size + 2 , size + 2, colors.item)
    dxDrawRectangle(x, y, size, size, tocolor(0, 0, 0, 220))
    if IconTextures[item.name] then
        dxDrawImage(x, y, size, size, IconTextures[item.name])
    end
end

function createItemsList(title, dragType)
    return {
        title    = title,
        dragType = dragType,
        scroll   = 0,
        x = 0,
        y = 0,
        width = listItemWidth,
        height = inventoryHeight,
        page = math.floor(inventoryHeight / (listItemHeight + listSpace) - listSpace) + 1
    }
end

function drawItemsList(list, items, x, y)
    local title = list.title
    local dragType = list.dragType
    local width = list.width
    local height = list.height
    list.x = x
    list.y = y
    list.scroll = math.min(math.max(0, #items - list.page), list.scroll)

    local cy = y
    if title then
        dxDrawText(title, x + 5, y - 25, x + 5, y - 5, tocolor(255, 255, 255, 200), 1, "default", "left", "bottom")
    end
    local itemIconSize = listItemHeight
    for i = 1 + list.scroll, 1 + list.scroll + list.page do
        local item = items[i]
        if item and item ~= dragItem then
            dxDrawRectangle(x, cy, listItemWidth, listItemHeight, colors.item)
            dxDrawRectangle(x, cy, itemIconSize, itemIconSize, colors.item_icon)
            if IconTextures[item.name] then
                dxDrawImage(x, cy, itemIconSize, itemIconSize, IconTextures[item.name])
            end
            if Items[item.name].readableName then
                dxDrawText(Items[item.name].readableName, x + itemIconSize + 5, cy, x + listItemWidth - 20, cy + listItemHeight, tocolor(255, 255, 255, 200), 1, "default", "left", "center", true)
            end
            if item.count and item.count > 1 then
                dxDrawText(item.count, x, cy, x + listItemWidth - 10, cy + listItemHeight, tocolor(255, 255, 255, 200), 1, "default-bold", "right", "center")
            end
            -- Прогресс использования
            if list.dragType == "backpack" and getUsingItemName() == item.name then
                dxDrawRectangle(x, cy, listItemWidth * getUsingProgress(), listItemHeight, tocolor(0, 0, 0, 150))
            end
            if isMouseOver(x, cy, listItemWidth, listItemHeight) then
                dxDrawRectangle(x, cy, listItemWidth, listItemHeight, colors.selection)
                if isMousePressed then
                    startDragging(dragType, item)
                elseif isRightMousePressed then
                    if list.dragType == "loot" then
                        tryPickupLootItem(item)
                    elseif list.dragType == "backpack" then
                        useItem(item)
                    end
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
    local ammoText = ""
    local ammoName = ""
    local clip, ammo = getWeaponAmmo(item)
    if slot ~= "melee" and clip and ammo then
        ammoText = clip .. " / " .. ammo
        ammoName = Items[Items[item.name].ammo].readableName
    end
    if slot == "grenade" and clip then
        ammoText = clip
    end
    dxDrawText(ammoText, x + 5, y, x + size, y + size - 5, tocolor(255, 255, 255, 200), 1, "default-bold", "left", "bottom", false)
    dxDrawText(ammoName, x + size / 2, y, x + size - 5, y + size - 5, tocolor(255, 255, 255, 100), 1, "default", "right", "bottom", false)
    if isMouseOver(x, y, size, size) then
        dxDrawRectangle(x, y, size, size, colors.selection)
        if isMousePressed then
            startDragging("weapon", item, slot)
        elseif isRightMousePressed then
            triggerServerEvent("dropPlayerWeapon", resourceRoot, slot)
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
    local item = getEquipmentSlot(slot)
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

local function drawBackpackCapacity(x, y, width, height)
    local totalWeight, capacity = getBackpackTotalWeight(), getBackpackCapacity()
    currentBarWeight = currentBarWeight + (totalWeight - currentBarWeight) * 0.1
    dxDrawRectangle(x - 1, y - 1, width + 2 , height + 2, colors.item)
    dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 220))
    local mul = currentBarWeight / capacity--(math.sin(getTickCount()*0.001) + 1) / 2
    dxDrawImageSection(x, y + height * (1-mul), width, height * mul, 0, 128-128*mul, 1, 128*mul, capacityBarTexture)

    if isMouseOver(x, y, width, height) and not isDragging then
        local str = "Носимый вес: " .. tostring(totalWeight) .. "/" .. tostring(capacity)
        local width = dxGetTextWidth(str) + 10
        local height = 20
        local x = mouseX - 5
        local y = mouseY - 25

        dxDrawRectangle(x - 1, y - 1, width + 2 , height + 2, colors.item)
        dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 220))
        dxDrawText(str, mouseX, mouseY - 23)
    end
end

local function drawWeightError()
    local str = "Недостаточно места!"
    dxDrawText(str, 2, screenSize.y*0.5 + 2, screenSize.x + 2, screenSize.y + 2, tocolor(0, 0, 0, 200), 2.5, "default-bold", "center", "center")
    dxDrawText(str, 0, screenSize.y*0.5, screenSize.x, screenSize.y, tocolor(255, 255, 255, 200), 2.5, "default-bold", "center", "center")
end

local function drawButton(text, x, y, width, height, bg, color, scale)
    if not bg then bg = tocolor(250, 250, 250) end
    if not color then color = tocolor(0, 0, 0, 200) end
    if not scale then scale = 1.5 end
    dxDrawRectangle(x, y, width, height, bg)
    dxDrawRectangle(x, y + height - 5, width, 5, tocolor(0, 0, 0, 10))
    dxDrawText(text, x, y, x + width, y + height, color, scale, "default-bold", "center", "center")

    if isMouseOver(x, y, width, height) then
        dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 100))
        if isMousePressed then
            return true
        end
    end
    return false
end

local function drawSeparateWindow(x, y, width, height)
    if not separateItem then
        hideSeparateWindow()
        return
    end
    dxDrawRectangle(x-1, y-1, width+2, height+2, tocolor(255, 255, 255, 50))
    dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 255))
    dxDrawText("Введите количество: #FFFFFF" .. tostring(Items[separateItem.name].readableName), x + 10, y, x + width, y + height * 0.4, tocolor(120, 120, 120), 1.2, "default-bold", "left", "center", true, false, false, true)
    local bw = (width - 25) / 2
    local bh = 50
    local bx = x + 10
    local by = y + height - bh - 10
    if drawButton("БРОСИТЬ", bx, by, bw, bh) then
        hideSeparateWindow(true)
        return
    end
    bx = bx + bw + 5
    if drawButton("ОТМЕНИТЬ", bx, by, bw, bh) then
        hideSeparateWindow()
        return
    end

    bx = x + 10
    bw = width - 20
    by = by - bh - 10
    dxDrawRectangle(bx, by, bw, bh, tocolor(0, 0, 0))
    if drawButton("Min\n1", bx, by, bh, bh, tocolor(88, 88, 88), tocolor(255, 255, 255, 200), 1) then
        separateCount = 1
    end
    if drawButton("Max\n"..tostring(separateItem.count), bx + bw -bh, by, bh, bh, tocolor(88, 88, 88), tocolor(255, 255, 255, 200), 1) then
        separateCount = separateItem.count
    end
    dxDrawText(tostring(separateCount), bx, by, bx + bw, by + bh, tocolor(255, 255, 255), 1.8, "default-bold", "center", "center")
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
    if getKeyState("mouse2") and not prevRightMouseState then
        isRightMousePressed = true
    else
        isRightMousePressed = false
    end
    prevRightMouseState = getKeyState("mouse2")

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
    drawItemsList(itemLists.loot, getLootItems(), x, y)
    x = x + listItemWidth + 15
    dxDrawLine(x, y, x, y + (itemLists.loot.page + 1) * (listItemHeight + listSpace) - listSpace, tocolor(255, 255, 255, 38))
    x = x + 15
    drawItemsList(itemLists.backpack, getBackpackItems(), x, y)

    -- Слоты оружия
    local x = screenSize.x - borderSpace - weaponSlotSize - slotSpace - weaponSlotSize
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
    drawEquipmentSlot("armor", x, y + slotSpace * 2 + equipSlotSize * 2, equipSlotSize)

    -- Заполненность рюкзака
    x = x - slotSpace - capacityBarWidth
    drawBackpackCapacity(x, y, capacityBarWidth, capacityBarHeight)

    -- Рюкзак переполнен
    if isTimer(weightErrorTimer) then
        drawWeightError()
    end

    if not getKeyState("mouse1") and isDragging then
        stopDragging()
    end
    drawDragItem()

    if isSeparateWindowVisible then
        dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 200))
        drawSeparateWindow(
            screenSize.x/2 - separateWindowWidth/2,
            screenSize.y/2 - separateWindowHeight/2,
            separateWindowWidth,
            separateWindowHeight
        )
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for name, item in pairs(Items) do
        local filename = item.icon or name .. ".png"
        local path = "assets/icons/"..filename
        if fileExists(path) then
            IconTextures[name] = dxCreateTexture(path)
        end
    end

    capacityBarTexture = dxCreateTexture("assets/bar.png", "argb", true, "clamp")

    inventoryHeight = math.min(inventoryHeight, screenSize.y - 100)

    if screenSize.x <= 1050 then
        local mul = (screenSize.x - 800) / (1050 - 800)
        local minScale = 0.6
        local scale = minScale + mul * (1 - minScale)
        slotSpace = slotSpace * scale
        listItemWidth = listItemWidth * scale
        listItemHeight = listItemHeight * scale
        weaponSlotSize = weaponSlotSize * scale
        equipSlotSize = equipSlotSize * scale
        capacityBarWidth = capacityBarWidth * scale
        capacityBarHeight = capacityBarHeight * scale

        borderSpace = borderSpace * scale / 2
    elseif screenSize.x < 1250 then
        borderSpace = 1
    elseif screenSize.x < 1400 then
        borderSpace = 15
    end

    itemLists.loot = createItemsList("Земля", "loot")
    itemLists.backpack = createItemsList("Рюкзак", "backpack")

    isInventoryVisible = false
end)

function showInventory(visible)
    isInventoryVisible = visible
    showCursor(visible)
    if visible then
        triggerServerEvent("requireClientBackpack", resourceRoot)
    end
end

function isInventoryShowing()
    return isInventoryVisible
end

addEventHandler("onClientKey", root, function (key, down)
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
    if not isInventoryVisible then
        return
    end
    for name, list in pairs(itemLists) do
        if isMouseOver(list.x, list.y, list.width, list.height) then
            list.scroll = math.max(0, list.scroll + delta)
        end
    end
end)

bindKey("tab", "down", function ()
    showInventory(not isInventoryVisible)
end)

addEventHandler("onClientKey", root, function (button, down)
    if not isSeparateWindowVisible or not down then
        return
    end
    if button == "backspace" then
        separateCount = tonumber(string.sub(tostring(separateCount), 1, -2)) or 0
    end
    if tonumber(button) then
        separateCount = tonumber(tostring(separateCount) .. button)
    end
    cancelEvent()
end)

-- export
function setVisible(visible)
    showInventory(not not visible)
end

function isVisible()
    return not not isInventoryVisible
end
