local screenSize = Vector2(guiGetScreenSize())

local panelWidth, panelHeight = math.min(screenSize.x - 100, 1000), math.min(screenSize.y - 300, 600)
local currentSection = "my_rewards"
local currentCrateIndex = 1
local currentCrateItems = {}

local inventoryCrates = {}
local clothesIcons = {}

local openCrateItem
local openCrateAnim = 0

local newCrateName

local crateWaitingTimer

local function drawGetReward(x, y, width, height)
    local price = exports.pb_accounts:getRewardPrice(localPlayer:getData("crate_level"))
    local hasEnoughPoints = price and (localPlayer:getData("battlepoints") or 0) >= price
    if not price then
        price = "..."
    end
    local mainColor
    local crateAlpha
    if hasEnoughPoints then
        mainColor = tocolor(254, 181, 0)
        crateAlpha = 1
    else
        mainColor = tocolor(100, 100, 100)
        crateAlpha = 0.2
    end
    dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 150))
    local iconSize = height * 0.6
    local cx = x + width / 2 - iconSize / 2
    local cy = y + height / 2 - iconSize / 2
    dxDrawRectangle(cx - 2, cy - 2, iconSize + 4, iconSize + 4, mainColor)
    dxDrawRectangle(cx, cy, iconSize, iconSize, tocolor(0, 0, 0))
    local iconOffset = iconSize * 0.2
    if hasEnoughPoints then
        iconOffset = iconOffset + math.sin(getTickCount() * 0.008) * 5
    end
    dxDrawImage(cx + iconOffset, cy + iconOffset, iconSize - iconOffset * 2, iconSize - iconOffset * 2, "assets/icons/crates/crate_random.png", 0, 0, 0, tocolor(255, 255, 255, 255 * crateAlpha))

    local cmiddle = y + (cy - y) / 2

    dxDrawText(localize("lobby_random_crate"), x, y, x + width, cmiddle, tocolor(255, 255, 255), 2, "default-bold", "center", "bottom", true, false, false, false)

    dxDrawText(price.." BP", x, cmiddle, x + width, cy, mainColor, 2, "default-bold", "center", "top", true, false, false, false)

    local buttonWidth = width * 0.5
    if drawButton(localize("lobby_get_reward"), x + width / 2 - buttonWidth / 2, y + height - ((y + height) - (cy + iconSize)) / 2 - 25, buttonWidth, 50, mainColor) and hasEnoughPoints then
        currentSection = "my_rewards"
        triggerServerEvent("onPlayerBuyNextCrate", resourceRoot)
    end
end

local function drawMyCrates(x, y, width, height)
    if not inventoryCrates then
        return
    end
    local rows
    if height < 400 then
        rows = 2
    else
        rows = 3
    end
    local itemSize = height / rows
    local columns = math.floor(width / itemSize)
    local itemIndex = 1
    for i = 1, rows do
        for j = 1, columns do
            local ix = x + itemSize * (j - 1)
            local iy = y + itemSize * (i - 1)
            local isize = itemSize - 10
            local border = isize * 0.1
            local mouseOver = isMouseOver(ix, iy, itemSize, itemSize)
            dxDrawRectangle(ix, iy, isize, isize, tocolor(0, 0, 0, 150))
            local item = inventoryCrates[itemIndex]
            if item then
                local itemClass = item.itemClass
                if mouseOver then
                    border = isize * 0.05
                end
                dxDrawImage(ix + border, iy + border, isize - border * 2, isize - border * 2, "assets/icons/crates/"..item.name..".png")
                if mouseOver then
                    dxDrawRectangle(ix, iy, isize, isize, tocolor(0, 0, 0, 150))
                    dxDrawText(itemClass.readableName .. " (x"..item.count..")", ix + 10, iy + 10, ix + isize - 20, iy + isize - 20, tocolor(255, 255, 255), 2, "default-bold", "left", "top", true, true, false, false)
                    border = isize * 0.05

                    drawButton(localize("lobby_open_crate"), ix, iy + isize - 40, isize, 40)
                    if isMousePressed then
                        currentSection = "show_crate"
                        newCrateName = nil
                        currentCrateIndex = itemIndex
                        currentCrateItems = {}
                        for i, name in ipairs(itemClass.crateItems) do
                            local itemClass = exports.pb_accounts:getItemClass(name)
                            itemClass.name = name
                            table.insert(currentCrateItems, itemClass)
                        end
                    end
                else
                    if newCrateName == item.name then
                        dxDrawText(localize("lobby_crate_new"), ix + 10, iy + 10, ix + isize - 20, iy + isize - 20, tocolor(254, 181, 0), 2, "default-bold", "left", "top", true, true, false, false)
                    end
                    dxDrawText("x"..item.count, ix + 10, iy + 10, ix + isize - 20, iy + isize - 20, tocolor(255, 255, 255), 2, "default-bold", "right", "bottom", true, true, false, false)
                end
            end
            itemIndex = itemIndex + 1
        end
    end
end

local function drawCrate(x, y, width, height)
    local iconSize = height / 3
    local titleScale = 1.8
    if height < 400 then
        iconSize = height / 2
        titleScale = 1
    end
    local crateItem = inventoryCrates[currentCrateIndex]
    if not crateItem then
        currentSection = "my_rewards"
        return
    end
    dxDrawRectangle(x, y, iconSize, height - 10, tocolor(0, 0, 0, 150))
    dxDrawImage(x + 10, y + 10, iconSize - 20, iconSize - 20, "assets/icons/crates/"..crateItem.name..".png")
    dxDrawText(crateItem.itemClass.readableName, x + 10, y + iconSize, x + iconSize - 10, y + iconSize + 10, tocolor(255, 255, 255), titleScale, "default-bold", "left", "top", false, true, false, false)
    if drawButton(localize("lobby_open_crate"), x, y + height - 10 - 40 * 2, iconSize, 40, tocolor(254, 181, 0)) then
        triggerServerEvent("onPlayerOpenCrate", resourceRoot, crateItem.name)
        openCrateItem = nil
        currentSection = "open_crate"
        crateWaitingTimer = setTimer(function () end, 2500, 1)
    end
    if drawButton(localize("lobby_crate_cancel"), x, y + height - 10 - 40, iconSize, 40) then
        currentSection = "my_rewards"
    end

    x = x + iconSize + 10
    width = width - iconSize - 10
    local rows
    if height < 400 then
        rows = 4
    else
        rows = 6
    end
    local itemSize = height / rows
    local columns = math.floor(width / itemSize)
    local itemIndex = 1
    for i = 1, rows do
        for j = 1, columns do
            local ix = x + itemSize * (j - 1)
            local iy = y + itemSize * (i - 1)
            local isize = itemSize - 10
            local border = isize * 0.1
            local mouseOver = isMouseOver(ix, iy, itemSize, itemSize)
            dxDrawRectangle(ix, iy, isize, isize, tocolor(0, 0, 0, 150))
            local itemClass = currentCrateItems[itemIndex]
            if itemClass then
                if mouseOver then
                    border = isize * 0.05
                end
                if not clothesIcons[itemClass.name] then
                    clothesIcons[itemClass.name] = exports.pb_clothes:getClothesIcon(itemClass.clothes)
                end
                dxDrawImage(ix + border, iy + border, isize - border * 2, isize - border * 2, clothesIcons[itemClass.name])
                if mouseOver then
                    dxDrawRectangle(ix, iy, isize, isize, tocolor(0, 0, 0, 150))
                    dxDrawText(itemClass.readableName, ix + 10, iy + 10, ix + isize - 20, iy + isize, tocolor(255, 255, 255), 1, "default-bold", "left", "top", true, true, false, false)
                    border = isize * 0.05
                end
            end
            itemIndex = itemIndex + 1
        end
    end
end

local function drawOpenCrate(x, y, width, height)
    dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 150))
    if not openCrateItem or isTimer(crateWaitingTimer) then
        dxDrawText(localize("lobby_crate_opening"), x, y, x + width, y + height, tocolor(255, 255, 255, 200 + 55 * math.sin(getTickCount() * 0.004)), 2, "default-bold", "center", "center", true, false, false, false)
        return
    end

    openCrateAnim = math.min(openCrateAnim + 0.008)
    local logoAlpha = 255 * math.min(1, openCrateAnim / 0.3)
    local iconAlpha = 0
    local iconScale = 0.25
    if openCrateAnim > 0.3 then
        local mul = math.min(1, (openCrateAnim - 0.3) / 0.3)
        iconAlpha = 255 * mul
        iconScale = 0.25 + 0.75 * getEasingValue(mul, "OutBack")
    end

    if not clothesIcons[openCrateItem.name] then
        clothesIcons[openCrateItem.name] = exports.pb_clothes:getClothesIcon(openCrateItem.clothes)
    end

    local iconSize = math.min(150, height * 0.6)
    local cx = x + width / 2 - iconSize / 2
    local cy = y
    cy = cy + height / 2 - iconSize / 2
    dxDrawText(localize("lobby_crate_received").."\n"..openCrateItem.capitalizedName.."!", x, y, x + width, cy, tocolor(254, 181, 0, logoAlpha), 2, "default-bold", "center", "center", true, true, false, false)

    dxDrawImage(x + width / 2 - iconSize * iconScale / 2, y + height / 2 - iconSize * iconScale / 2, iconSize * iconScale, iconSize * iconScale, clothesIcons[openCrateItem.name], math.sin(getTickCount() * 0.005) * 5, 0, 0, tocolor(255, 255, 255, iconAlpha))
    local buttonHeight = math.min(50, height / 10)
    cy = y + height - (height - iconSize) / 2 + (height - iconSize) / 4 - buttonHeight / 2
    local buttonWidth = math.min(200, width * 0.8)

    if openCrateAnim > 0.6 then
        if drawButton(localize("lobby_crate_take_item"), x + width / 2 - buttonWidth / 2, cy, buttonWidth, buttonHeight, mainColor) then
            openCrateItem = nil
            currentSection = "my_rewards"
        end
    end
end

function drawDonations(x, y, width, height)
    dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 150))
    dxDrawText(localize("lobby_donate_disabled"), x, y, x + width, y + height, tocolor(255, 255, 255), 2, "default-bold", "center", "center", true, false, false, false)
end

local function draw()
    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))
    local x, y = screenSize.x / 2 - panelWidth / 2, screenSize.y / 2 - panelHeight / 2

    local bgColor = tocolor(254, 181, 0)
    local bg
    if currentSection == "get_reward" then
        bg = bgColor
    end
    if drawButton(localize("lobby_button_get_crates"), x, y, 150, 40, bg) then
        currentSection = "get_reward"
    end
    bg = nil
    if currentSection == "my_rewards" then
        bg = bgColor
    end
    if drawButton(localize("lobby_button_my_crates"), x, y + 50, 150, 40, bg) then
        currentSection = "my_rewards"
    end
    bg = nil
    if currentSection == "donate" then
        bg = bgColor
    end
    if drawButton(localize("lobby_button_donate"), x, y + 100, 150, 40, bg) then
        currentSection = "donate"
    end

    x = x + 160
    if currentSection == "get_reward" then
        drawGetReward(x, y, math.min(panelHeight, panelWidth - 160), panelHeight)
    elseif currentSection == "my_rewards" then
        drawMyCrates(x, y, panelWidth - 160, panelHeight)
    elseif currentSection == "show_crate" then
        drawCrate(x, y, panelWidth - 160, panelHeight)
    elseif currentSection == "open_crate" then
        drawOpenCrate(x, y, math.min(panelHeight, panelWidth - 160), panelHeight)
    elseif currentSection == "donate" then
        drawDonations(x, y, math.min(panelHeight, panelWidth - 160), panelHeight)
    end

    drawBattlepoints()
end

local function handleInventoryChange()
    local localInventory = exports.pb_accounts:getInventory()
    inventoryCrates = {}
    for name, item in pairs(localInventory) do
        local itemClass = exports.pb_accounts:getItemClass(item.name)
        if itemClass.crateItems then
            item.itemClass = itemClass
            table.insert(inventoryCrates, item)
        end
    end
    table.sort(inventoryCrates, function (a, b)
        return a.itemClass.readableName < b.itemClass.readableName
    end)
end

addEvent("onClientInventoryUpdated", true)
addEventHandler("onClientInventoryUpdated", root, function ()
    if not isVisible() then
        return
    end
    handleInventoryChange()
end)

addEvent("onClientCrateReceived", true)
addEventHandler("onClientCrateReceived", root, function (itemName)
    newCrateName = itemName
end)

addEvent("onClientCrateOpened", true)
addEventHandler("onClientCrateOpened", root, function (itemName)
    if not isVisible() then
        return
    end
    local itemClass = exports.pb_accounts:getItemClass(itemName)
    openCrateItem = {
        name = itemName,
        capitalizedName = utf8.upper(itemClass.readableName),
        itemClass = itemClass
    }
end)

Tabs.rewards = {
    title = localize("lobby_tab_rewards"),
    load = function ()
        currentSection = "my_rewards"
        openCrateItem = nil
        handleInventoryChange()
        newCrateName = nil
    end,
    draw = draw
}
