local UI = exports.pb_ui
local screenWidth, screenHeight = UI:getRenderResolution()

-- Таблица, в которой лежат элементы интерфейса
local ui = {}

-- Слоты, расположенные слева
local leftSlots = {
    "helmet",
    "armor",
    "backpack"
}

-- Слоты, расположенные справа
local rightSlots = {
    "hat",
    "glasses",
    "mask",
    "jacket",
    "shirt",
    "pants",
    "shoes"
}

-- Размеры элементов интерфейса
local blockSpacing     = 10 -- Расстояние между блоками
local screenSpacing    = 60 -- Расстояние от краев экрана
local itemsListWidth   = 300 -- Ширина списков
local titleLabelHeight = 25 -- Высота заголовков
-- Размеры блоков оружия
local weaponBlockHeight = (screenHeight - screenSpacing * 2 - blockSpacing * 3) / 4
local weaponBlockWidth = weaponBlockHeight * 2 + blockSpacing
-- Размер слота в два раза меньше блока оружия
local slotSize = weaponBlockHeight / 2 - blockSpacing / 2

-- Цвета элементов интерфейса
local backgroundColor   = tocolor(10, 10, 10, 200)
local defaultBlockColor = tocolor(0, 0, 0, 200)
local slotBorderColor   = tocolor(50, 50, 50)

-----------------------
-- Локальные функции --
-----------------------

local function createInventorySlot(name, x, y)
    local slot = UI:create("Rectangle", {
        x = x,
        y = y,
        width = slotSize,
        height = slotSize,
        color = defaultBlockColor,
        borderColor = slotBorderColor,
        borderSize = 1,
    })

    UI:setParams(slot, {
        blockType = "slot",
        slotName = name
    })
    ui.slots[name] = slot

    return slot
end

local function createBigWeaponSlot(name, x, y)
    local slot = UI:create("Rectangle", {
        x = x,
        y = y,
        width  = weaponBlockWidth,
        height = weaponBlockHeight,
        color  = defaultBlockColor
    })

   UI:setParams(slot, {
       blockType = "slot",
       slotName = name
   })

   ui.slots[name] = slot

   return slot
end

local function createSmallWeaponSlot(name, x, y)
    UI:create("Rectangle", {
        x = x,
        y = y,
        width  = weaponBlockWidth/2 - blockSpacing/2,
        height = weaponBlockHeight,
        color  = defaultBlockColor
    })


    UI:setParams(slot, {
        blockType = "slot",
        slotName = name
    })

    ui.slots[name] = slot

    return slot
end

-----------------------
-- Обработка событий --
-----------------------

addEvent("onWidgetMouseOver")
addEvent("onWidgetMouseOut")
addEvent("onWidgetClick")

addEventHandler("onWidgetMouseOver", resourceRoot, function (widget)
    if UI:getParam(widget, "blockType") == "slot" then
        UI:setParams(widget, { color = tocolor(20, 20, 20, 230)})
    end
end)

addEventHandler("onWidgetMouseOut", resourceRoot, function (widget)
    if UI:getParam(widget, "blockType") == "slot" then
        UI:setParams(widget, { color = tocolor(0, 0, 0, 200)})
    end
end)

addEventHandler("onWidgetClick", resourceRoot, function (widget)

end)

-- Создание интерфейса
addEventHandler("onClientResourceStart", resourceRoot, function ()
    -- Полупрозрачный фон
    UI:create("Rectangle", { width = screenWidth, height = screenHeight, color = backgroundColor })

    -- Блок лута
    UI:create("Label", {
        x = screenSpacing,
        y = screenSpacing - titleLabelHeight,
        width = itemsListWidth,
        height = titleLabelHeight,
        text = "Вещи на земле"
    })
    UI:create("Rectangle", {
        x = screenSpacing,
        y = screenSpacing,
        width = itemsListWidth,
        height = screenHeight - screenSpacing*2,
        color = defaultBlockColor
    })

    -- Блок рюкзака
    UI:create("Label", {
        x = screenSpacing + itemsListWidth + blockSpacing,
        y = screenSpacing - titleLabelHeight,
        width = itemsListWidth,
        height = titleLabelHeight,
        text = "Рюкзак"
    })
    UI:create("Rectangle", {
        x = screenSpacing + itemsListWidth + blockSpacing,
        y = screenSpacing,
        width = itemsListWidth,
        height = screenHeight - screenSpacing*2,
        color = defaultBlockColor
    })

    ui.slots = {}
    -- Слоты слева
    UI:create("Label", {
        x = screenSpacing + itemsListWidth * 2 + blockSpacing * 2,
        y = screenSpacing - titleLabelHeight,
        width = itemsListWidth,
        height = titleLabelHeight,
        text = "Снаряжение"
    })
    for i, name in ipairs(leftSlots) do
        createInventorySlot(
            name,
            screenSpacing + itemsListWidth * 2 + blockSpacing * 2,
            screenSpacing + blockSpacing * (i-1) + slotSize * (i-1))
    end

    -- Блоки оружия
    -- Большие слоты
    UI:create("Label", {
        x = screenWidth - screenSpacing - weaponBlockWidth,
        y = screenSpacing - titleLabelHeight,
        width = itemsListWidth,
        height = titleLabelHeight,
        text = "Оружие"
    })
    -- Большие слоты оружия с поддержкой обвесов
    createBigWeaponSlot(
        "primary1",
        screenWidth - screenSpacing - weaponBlockWidth,
        screenSpacing + blockSpacing + weaponBlockHeight)
    createBigWeaponSlot(
        "primary2",
        screenWidth - screenSpacing - weaponBlockWidth,
        screenSpacing)
    createBigWeaponSlot(
        "secondary",
        screenWidth - screenSpacing - weaponBlockWidth,
        screenSpacing + blockSpacing*2 + weaponBlockHeight*2)
    -- Маленькие квадратные слоты оружия
    createSmallWeaponSlot(
        "melee",
        screenWidth - screenSpacing - weaponBlockWidth,
        screenSpacing + blockSpacing*3 + weaponBlockHeight*3)
    createSmallWeaponSlot(
        "grenade",
        screenWidth - screenSpacing - weaponBlockWidth + weaponBlockWidth/2 + blockSpacing/2,
        screenSpacing + blockSpacing*3 + weaponBlockHeight*3)

    -- Слоты справа
    UI:create("Label", {
        x = screenWidth   - screenSpacing - weaponBlockWidth - slotSize - blockSpacing,
        y = screenSpacing - titleLabelHeight,
        width  = itemsListWidth,
        height = titleLabelHeight,
        text   = "Одежда"
    })
    for i, name in ipairs(rightSlots) do
        createInventorySlot(
            name,
            screenWidth   - screenSpacing - weaponBlockWidth - slotSize - blockSpacing,
            screenSpacing + blockSpacing  * (i-1) + slotSize * (i-1))
    end

    showCursor(true)
end)
