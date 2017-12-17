local screenSize = Vector2(guiGetScreenSize())

local panelWidth, panelHeight = math.min(screenSize.x - 100, 1000), math.min(screenSize.y - 300, 600)
local currentSection = "get_reward"

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

                if drawButton("Open crate", ix, iy + isize - 40, isize, 40, mainColor) then
                end
            end
        end
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
    else
        drawMyCrates(x, y, panelWidth - 160, panelHeight)
    end
end

Tabs.rewards = {
    title = localize("lobby_tab_rewards"),

    draw = draw
}
