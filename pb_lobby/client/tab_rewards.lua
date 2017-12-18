local screenSize = Vector2(guiGetScreenSize())

local panelWidth, panelHeight = math.min(screenSize.x - 100, 1000), math.min(screenSize.y - 300, 600)
local currentSection = "open_crate"

local function drawGetReward(x, y, width, height)
    local hasEnoughPoints = true--(localPlayer:getData("battlepoints") or 0) >= 700

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
    dxDrawImage(cx + iconOffset, cy + iconOffset, iconSize - iconOffset * 2, iconSize - iconOffset * 2, "assets/icons/crates/crate.png", 0, 0, 0, tocolor(255, 255, 255, 255 * crateAlpha))

    local cmiddle = y + (cy - y) / 2
    dxDrawText("Random Weekly Crate #1", x, y, x + width, cmiddle, tocolor(255, 255, 255), 2, "default-bold", "center", "bottom", true, false, false, false)
    dxDrawText("700 BP", x, cmiddle, x + width, cy, mainColor, 2, "default-bold", "center", "top", true, false, false, false)

    local buttonWidth = width * 0.5
    if drawButton("GET REWARD", x + width / 2 - buttonWidth / 2, y + height - ((y + height) - (cy + iconSize)) / 2 - 25, buttonWidth, 50, mainColor) then

    end
end

local function drawMyCrates(x, y, width, height)
    local rows
    if height < 400 then
        rows = 2
    else
        rows = 3
    end
    local itemSize = height / rows
    local columns = math.floor(width / itemSize)
    for i = 1, rows do
        for j = 1, columns do
            local ix = x + itemSize * (j - 1)
            local iy = y + itemSize * (i - 1)
            local isize = itemSize - 10
            local border = isize * 0.1
            local mouseOver = isMouseOver(ix, iy, itemSize, itemSize)
            dxDrawRectangle(ix, iy, isize, isize, tocolor(0, 0, 0, 150))
            if mouseOver then
                border = isize * 0.05
            end
            dxDrawImage(ix + border, iy + border, isize - border * 2, isize - border * 2, "assets/icons/crates/crate.png")
            if mouseOver then
                dxDrawRectangle(ix, iy, isize, isize, tocolor(0, 0, 0, 150))
                dxDrawText("Random Weekly Crate #1", ix + 10, iy + 10, ix + isize - 20, iy + isize - 20, tocolor(255, 255, 255), 2, "default-bold", "left", "top", true, true, false, false)
                border = isize * 0.05

                drawButton("Open crate", ix, iy + isize - 40, isize, 40)
                if isMousePressed then
                    currentSection = "show_crate"
                end
            end
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
    dxDrawRectangle(x, y, iconSize, height - 10, tocolor(0, 0, 0, 150))
    dxDrawImage(x + 10, y + 10, iconSize - 20, iconSize - 20, "assets/icons/crates/crate.png")
    dxDrawText("Random Weekly Crate #1", x + 10, y + iconSize, x + iconSize - 10, y + iconSize + 10, tocolor(255, 255, 255), titleScale, "default-bold", "left", "top", false, true, false, false)
    if drawButton("Open crate", x, y + height - 10 - 40 * 2, iconSize, 40, tocolor(254, 181, 0)) then
        currentSection = "my_rewards"
    end
    if drawButton("Cancel", x, y + height - 10 - 40, iconSize, 40) then
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
    for i = 1, rows do
        for j = 1, columns do
            local ix = x + itemSize * (j - 1)
            local iy = y + itemSize * (i - 1)
            local isize = itemSize - 10
            local border = isize * 0.1
            local mouseOver = isMouseOver(ix, iy, itemSize, itemSize)
            dxDrawRectangle(ix, iy, isize, isize, tocolor(0, 0, 0, 150))
            if mouseOver then
                border = isize * 0.05
            end
            dxDrawImage(ix + border, iy + border, isize - border * 2, isize - border * 2, ":pb_clothes/assets/icons/pants/jeans/jeans"..(i%5+1)..".png")
            if mouseOver then
                dxDrawRectangle(ix, iy, isize, isize, tocolor(0, 0, 0, 150))
                dxDrawText("ШМОТКА ЕПТУ", ix + 10, iy + 10, ix + isize - 20, iy + isize, tocolor(255, 255, 255), 1, "default-bold", "left", "top", true, true, false, false)
                border = isize * 0.05
            end
        end
    end
end

local function drawOpenCrate(x, y, width, height)
    dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 150))

    local iconSize = width / 8

    for i = 1, 8 do
        local path = ":pb_clothes/assets/icons/pants/jeans/jeans"..(i%5+1)..".png"
        local ix = x + (i - 1) * iconSize + iconSize / 2
        local distance = 1 - math.abs((ix - x - width/2) / (width/2))
        dxDrawImage(x + (i - 1) * iconSize, y + height / 2 - iconSize / 2, iconSize, iconSize , path, 0, 0, 0, tocolor(255, 255, 255, 255 * distance))
    end
end

local function draw()
    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))
    local x, y = screenSize.x / 2 - panelWidth / 2, screenSize.y / 2 - panelHeight / 2

    local bgColor = tocolor(254, 181, 0)
    local bg
    if currentSection == "get_reward" then
        bg = bgColor
    end
    if drawButton("GET CRATES", x, y, 150, 40, bg) then
        currentSection = "get_reward"
    end
    bg = nil
    if currentSection == "my_rewards" then
        bg = bgColor
    end
    if drawButton("MY CRATES", x, y + 50, 150, 40, bg) then
        currentSection = "my_rewards"
    end

    x = x + 160
    if currentSection == "get_reward" then
        drawGetReward(x, y, math.min(panelHeight, panelWidth - 160), panelHeight)
    elseif currentSection == "my_rewards" then
        drawMyCrates(x, y, panelWidth - 160, panelHeight)
    elseif currentSection == "show_crate" then
        drawCrate(x, y, panelWidth - 160, panelHeight)
    elseif currentSection == "open_crate" then
        drawOpenCrate(x, y, panelWidth, panelHeight)
    end
end

Tabs.rewards = {
    title = localize("lobby_tab_rewards"),

    draw = draw
}
