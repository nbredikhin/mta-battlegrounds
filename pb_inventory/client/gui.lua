local UI = exports.pb_ui
local ui = {}
local leftSlots = {
    "helmet",
    "armor",
    "backpack"
}

local rightSlots = {
    "hat",
    "glasses",
    "mask",
    "jacket",
    "shirt",
    "pants",
    "shoes"
}

addEventHandler("onClientResourceStart", resourceRoot, function ()
    local screenWidth, screenHeight = UI:getRenderResolution()

    local blockSpacing = 10
    local screenSpacing = 60
    local itemsListWidth = 300
    local titleLabelHeight = 25

    local defaultBlockColor = tocolor(0, 0, 0, 200)
    local slotBorderColor = tocolor(50, 50, 50)
    local weaponBlockHeight = (screenHeight - screenSpacing * 2 - blockSpacing * 3) / 4
    local weaponBlockWidth = weaponBlockHeight * 2 + blockSpacing

    -- Полупрозрачный фон
    UI:create("Rectangle", { width = screenWidth, height = screenHeight, color = tocolor(0, 0, 0, 200) })

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

    local slotSize = weaponBlockHeight / 2 - blockSpacing / 2
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
        local slot = UI:create("Rectangle", {
            x = screenSpacing + itemsListWidth * 2 + blockSpacing * 2,
            y = screenSpacing + blockSpacing * (i-1) + slotSize * (i-1),
            width = slotSize,
            height = slotSize,
            color = defaultBlockColor,
            borderColor = slotBorderColor,
            borderSize = 1,
        })

        UI:setParams(slot, {blockType = "slot", slotName = name})
        ui.slots[name] = slo
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
    UI:create("Rectangle", {
        x = screenWidth - screenSpacing - weaponBlockWidth,
        y = screenSpacing,
        width = weaponBlockWidth,
        height = weaponBlockHeight,
        color = defaultBlockColor
    })
    UI:create("Rectangle", {
        x = screenWidth - screenSpacing - weaponBlockWidth,
        y = screenSpacing + blockSpacing + weaponBlockHeight,
        width = weaponBlockWidth,
        height = weaponBlockHeight,
        color = defaultBlockColor
    })
    UI:create("Rectangle", {
        x = screenWidth - screenSpacing - weaponBlockWidth,
        y = screenSpacing + blockSpacing*2 + weaponBlockHeight*2,
        width = weaponBlockWidth,
        height = weaponBlockHeight,
        color = defaultBlockColor
    })
    UI:create("Rectangle", {
        x = screenWidth - screenSpacing - weaponBlockWidth,
        y = screenSpacing + blockSpacing*3 + weaponBlockHeight*3,
        width = weaponBlockWidth/2 - blockSpacing/2,
        height = weaponBlockHeight,
        color = defaultBlockColor
    })
    UI:create("Rectangle", {
        x = screenWidth - screenSpacing - weaponBlockWidth + weaponBlockWidth/2 + blockSpacing/2,
        y = screenSpacing + blockSpacing*3 + weaponBlockHeight*3,
        width = weaponBlockWidth/2 - blockSpacing/2,
        height = weaponBlockHeight,
        color = defaultBlockColor
    })

    -- Слоты справа
    UI:create("Label", {
        x = screenWidth - screenSpacing - weaponBlockWidth - slotSize - blockSpacing,
        y = screenSpacing - titleLabelHeight,
        width = itemsListWidth,
        height = titleLabelHeight,
        text = "Одежда"
    })
    for i, name in ipairs(rightSlots) do
        local slot = UI:create("Rectangle", {
            x = screenWidth - screenSpacing - weaponBlockWidth - slotSize - blockSpacing,
            y = screenSpacing + blockSpacing * (i-1) + slotSize * (i-1),
            width = slotSize,
            height = slotSize,
            color = defaultBlockColor,
            borderColor = slotBorderColor,
            borderSize = 1,
        })

        UI:setParams(slot, {blockType = "slot", slotName = name})
        ui.slots[name] = slo
    end

    showCursor(true)
end)

addEvent("onWidgetMouseOver", false)
addEvent("onWidgetMouseOut", false)
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
