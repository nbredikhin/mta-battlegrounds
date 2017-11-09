local screenSize = Vector2(guiGetScreenSize())
local panelWidth = 380
local bannerHeight = 95
local itemHeight = 30
local arrowsSize = 20

-- local categories = {
--     {name = "Шапки"},
--     {name = "Футболки"},
--     {name = "Куртки"},
--     {name = "Штаны"},
--     {name = "Обувь"}
-- }

local categories = {
}
for i = 1, 10 do
    table.insert(categories, {name = "Тестовая шмотка", price = math.random(1, 15) * 100})
end

local selectedItem = 4


function drawGUI()
    local x = screenSize.x - panelWidth - 50
    local y = 50
    dxDrawImage(x, y, panelWidth, bannerHeight, "assets/banner.png")
    y = y + bannerHeight
    dxDrawRectangle(x, y, panelWidth, itemHeight, tocolor(0, 0, 0))
    dxDrawText("КАТЕГОРИИ", x + 10, y, x + panelWidth, y + itemHeight, tocolor(255, 255, 255), 1.5, "default", "left", "center")
    dxDrawText(selectedItem.."/"..#categories, x, y, x + panelWidth - 10, y + itemHeight, tocolor(255, 255, 255), 1.5, "default", "right", "center")
    y = y + itemHeight
    local itemsCount = #categories
    local gradientWidth = itemHeight * itemsCount
    local graidentHeight = panelWidth
    dxDrawImage(x, y + gradientWidth, gradientWidth, graidentHeight, "assets/gradient.png", 270, -gradientWidth / 2, -graidentHeight / 2, tocolor(0, 0, 0, 150))
    for i, item in ipairs(categories) do
        local selected = false
        if i == selectedItem then
            selected = true
        end

        local backgroundColor
        local textColor

        if selected then
            backgroundColor = tocolor(255, 255, 255)
            textColor = tocolor(0, 0, 0)
        else
            backgroundColor = tocolor(0, 0, 0, 150)
            textColor = tocolor(255, 255, 255)
        end
        dxDrawRectangle(x, y, panelWidth, itemHeight, backgroundColor)
        if selected then
            dxDrawImage(x, y, panelWidth, itemHeight, "assets/gradient.png", 0, 0, 0, tocolor(0, 0, 0, 80))
        end
        dxDrawText(item.name, x + 10, y, x + panelWidth, y + itemHeight, textColor, 1, "default-bold", "left", "center")
        if item.price then
            dxDrawText(tostring(item.price) .. " BP", x, y, x + panelWidth - 10, y + itemHeight, textColor, 1, "default-bold", "right", "center")
        end
        y = y + itemHeight
    end
    dxDrawRectangle(x, y, panelWidth, 1, tocolor(0, 0, 0, 100))
    y = y + 1
    dxDrawRectangle(x, y, panelWidth, itemHeight, tocolor(0, 0, 0, 200))
    dxDrawImage(x + panelWidth / 2 - arrowsSize / 2, y + itemHeight / 2 - arrowsSize / 2, arrowsSize, arrowsSize, "assets/arrows.png")
end
