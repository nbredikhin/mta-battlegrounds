local screenSize = Vector2(guiGetScreenSize())
local panelWidth = 380
local bannerHeight = 95
local itemHeight = 30
local arrowsSize = 20
local panelX = screenSize.x - panelWidth - 50

isMousePressed = false
local prevMouseState = false
local mouseX = 0
local mouseY = 0

local categoriesList = {name = "Категории", subcategories = {
    {name = "Шапки",           category = "hat"},
    {name = "Верхняя одежда",  subcategories = {
        {name = "Куртки",  category = "bomber"},
        {name = "Пиджаки", category = "woolcoat"},
        {name = "Назад", back = true }
    }},
    {name = "Футболки",        category = "tshirt"},
    {name = "Обувь",           category = "shoes"},
    {name = "Выход", back = true }
}}

local categoryPath = {}
local currentItemsList
local currentCategoryName

local visibleItemsCount = 1
local visibleItemsOffset = 1

local selectedItemIndex = 1

local previewTimer
local previewName

local blinkPriceItem
local blinkPriceTimer

function localize(name)
    local res = getResourceFromName("pb_lang")
    if (res) and (getResourceState(res) == "running") then
        return exports.pb_lang:localize(name)
    else
        return name
    end
end

local function delayClothesPreview(name)
    if previewName and previewName == name then
        return
    end
    previewName = name
    if isTimer(previewTimer) then
        killTimer(previewTimer)
    end
    previewTimer = setTimer(previewClothes, 500, 1, name)
end

local function handleSelectionChange()
    selectedItemIndex = math.max(1, math.min(selectedItemIndex, #currentItemsList))
    visibleItemsOffset = math.max(1, math.min(visibleItemsOffset, #currentItemsList - visibleItemsCount + 1))
    if selectedItemIndex > visibleItemsOffset + visibleItemsCount - 1 then
        visibleItemsOffset = selectedItemIndex - visibleItemsCount + 1
    end
    if selectedItemIndex < visibleItemsOffset then
        visibleItemsOffset = selectedItemIndex
    end
    if #currentItemsList <= visibleItemsCount then
        visibleItemsOffset = 1
    end

    local item = currentItemsList[selectedItemIndex]
    if item and item.clothes then
        delayClothesPreview(item.clothes)
    end
end

local function getCurrentItems()
    local items = categoriesList.subcategories
    local name = categoriesList.name
    for i, index in ipairs(categoryPath) do
        name  = items[index].name
        if items[index].category then
            local clothesList = ShopClothes[items[index].category]
            items = {}
            if clothesList then
                for i, item in ipairs(clothesList) do
                    table.insert(items, item)
                end
            end
            table.insert(items, {name = "Назад", back = true})
            break
        else
            items = items[index].subcategories
        end
    end
    return items, name
end

local function updateCategory()
    local items, name = getCurrentItems()
    currentItemsList = items or {}
    currentCategoryName = utf8.upper(localize(tostring(name)))
    visibleItemsCount = math.min(#items, math.floor((600 - bannerHeight - 20) / itemHeight))
end

local function handleGoBack()
    if #categoryPath > 0 then
        selectedItemIndex = table.remove(categoryPath, #categoryPath)
        updateCategory()
        resetClothesPreview()
        handleSelectionChange()
        resetClothesPreview()
    else
        fadeCamera(false)
        setTimer(function ()
            setVisible(false)
            exports.pb_lobby:setVisible(true)
        end, 1000, 1)
    end
end

local function handleItemSelect(index)
    if type(index) ~= "number" then
        index = selectedItemIndex
    end
    local item = currentItemsList[index]
    if not item then
        return
    end

    if item.subcategories or item.category then
        table.insert(categoryPath, index)
        updateCategory()
        selectedItemIndex = 1
        handleSelectionChange()
        return
    end
    if item.back then
        handleGoBack()
        return
    end
    if item.clothes then
        local bPoints = localPlayer:getData("battlepoints") or 0
        if not item.price or item.price > bPoints then
            blinkPriceItem = item
            if isTimer(blinkPriceTimer) then
                killTimer(blinkPriceTimer)
            end
            blinkPriceTimer = setTimer(function ()
                blinkPriceItem = nil
            end, 2000, 1)
            return
        end
        buyClothes(item.clothes)
    end
end

function isMouseOver(x, y, w, h)
    return mouseX >= x     and
           mouseX <= x + w and
           mouseY >= y     and
           mouseY <= y + h
end

function drawGUI()
    local currentMouseState = getKeyState("mouse1")
    if not prevMouseState and currentMouseState then
        isMousePressed = true
    else
        isMousePressed = false
    end
    prevMouseState = currentMouseState
    if isMTAWindowActive() then
        isMousePressed = false
    end

    local mx, my = getCursorPosition()
    if mx then
        mx = mx * screenSize.x
        my = my * screenSize.y
    else
        mx, my = 0, 0
    end
    mouseX, mouseY = mx, my

    local x = panelX
    local y = 50
    dxDrawImage(x, y, panelWidth, bannerHeight, "assets/banner.png")
    y = y + bannerHeight
    dxDrawRectangle(x, y, panelWidth, itemHeight, tocolor(0, 0, 0))
    dxDrawText(currentCategoryName, x + 10, y, x + panelWidth, y + itemHeight, tocolor(255, 255, 255), 1.5, "default", "left", "center")
    dxDrawText(selectedItemIndex.."/"..#currentItemsList, x, y, x + panelWidth - 10, y + itemHeight, tocolor(255, 255, 255), 1.5, "default", "right", "center")
    y = y + itemHeight
    local gradientWidth = itemHeight * visibleItemsCount
    local graidentHeight = panelWidth
    dxDrawImage(x, y + gradientWidth, gradientWidth, graidentHeight, "assets/gradient.png", 270, -gradientWidth / 2, -graidentHeight / 2, tocolor(0, 0, 0, 200))
    local isMouseOverItems = isMouseOver(x, y, panelWidth, itemHeight * visibleItemsCount)

    local bPoints = localPlayer:getData("battlepoints") or 0
    for index = visibleItemsOffset, visibleItemsOffset + visibleItemsCount - 1 do
        local item = currentItemsList[index]
        if not item then
            break
        end

        local mouseOver = isMouseOver(x, y, panelWidth, itemHeight)
        if isMouseOverItems then
            if mouseOver and selectedItemIndex ~= index then
                selectedItemIndex = index
                handleSelectionChange()
            end
        end
        local selected = index == selectedItemIndex
        local backgroundColor
        local textColor

        if selected then
            backgroundColor = tocolor(255, 255, 255)
            textColor = tocolor(0, 0, 0)

            if mouseOver and item.clothes then
                delayClothesPreview(item.clothes)
            end
        -- elseif mouseOver then
        --     backgroundColor = tocolor(150, 150, 150, 200)
        --     textColor = tocolor(255, 255, 255)
        else
            backgroundColor = tocolor(0, 0, 0, 150)
            textColor = tocolor(200, 200, 200)
        end

        if mouseOver and isMousePressed then
            handleItemSelect(index)
        end
        dxDrawRectangle(x, y, panelWidth, itemHeight, backgroundColor)
        if selected then
            dxDrawImage(x, y, panelWidth, itemHeight, "assets/gradient.png", 0, 0, 0, tocolor(0, 0, 0, 80))
        end
        local nameText = item.name
        local nameColor = textColor
        if hasPlayerClothes(item.clothes) then
            nameText = "✓ " .. nameText
            if not selected then
                nameColor = tocolor(255, 255, 255, 100)
            end
        end
        dxDrawText(nameText, x + 10, y, x + panelWidth, y + itemHeight, nameColor, 1, "default-bold", "left", "center")
        if item.price then
            local priceColor = textColor
            local priceText = tostring(item.price) .. " BP"
            -- if hasPlayerClothes(item.clothes) then
            --     priceText = priceText
            -- end
            if bPoints < item.price then
                if blinkPriceItem == item and math.floor(getTickCount() / 250) % 2 == 0 then
                    priceColor = tocolor(0, 0, 0, 0)
                else
                    priceColor = tocolor(255, 0, 0, 150)
                end
            end
            dxDrawText(priceText, x, y, x + panelWidth - 10, y + itemHeight, priceColor, 1, "default-bold", "right", "center")
        end
        y = y + itemHeight
    end
    dxDrawRectangle(x, y, panelWidth, 1, tocolor(0, 0, 0, 100))
    y = y + 1
    dxDrawRectangle(x, y, panelWidth, itemHeight, tocolor(0, 0, 0, 200))
    dxDrawImage(x + panelWidth / 2 - arrowsSize / 2, y + itemHeight / 2 - arrowsSize / 2, arrowsSize, arrowsSize, "assets/arrows.png")
    y = y + itemHeight + 10
    dxDrawRectangle(x, y, panelWidth, 45, tocolor(0, 0, 0, 200))
    y = y + 10
    dxDrawImage(x + 10, y, 25, 25, ":pb_lobby/assets/bp.png")
    dxDrawText(bPoints, x + 45, y, x + panelWidth, y + 25, tocolor(255, 255, 255), 1.5, "default-bold", "left", "center")
end

local function selectPrevItem()
    selectedItemIndex = selectedItemIndex - 1
    handleSelectionChange()
end

local function selectNextItem()
    selectedItemIndex = selectedItemIndex + 1
    handleSelectionChange()
end

local function handleKey(key, down)
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
    if mouseX > panelX then
        visibleItemsOffset = visibleItemsOffset + delta
        if delta > 0 then
            selectedItemIndex = selectedItemIndex + delta
        end
        handleSelectionChange()
    end
end

function loadGUI()
    addEventHandler("onClientRender", root, drawGUI)
    addEventHandler("onClientKey", root, handleKey)

    updateCategory()
    categoryPath = {}
    selectedItemIndex = 1

    bindKey("arrow_u", "down", selectPrevItem)
    bindKey("arrow_d", "down", selectNextItem)
    bindKey("enter", "down", handleItemSelect)
    bindKey("backspace", "down", handleGoBack)
end

function unloadGUI()
    removeEventHandler("onClientRender", root, drawGUI)
    removeEventHandler("onClientKey", root, handleKey)

    unbindKey("arrow_u", "down", selectPrevItem)
    unbindKey("arrow_d", "down", selectNextItem)
    unbindKey("enter", "down", handleItemSelect)
    unbindKey("backspace", "down", handleGoBack)
end
