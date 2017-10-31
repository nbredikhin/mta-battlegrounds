Tabs = {}
local screenSize = Vector2(guiGetScreenSize())

Tabs.home = {
    title = "HOME",

    draw = function ()
        drawArrows()
    end
}

Tabs.shop = {
    title = "SHOP",

    load = function ()
        fadeCamera(false, 1)
        setTimer(function ()
            -- setVisible(false)
            fadeCamera(true)
        end, 1000, 1)
    end
}

Tabs.rewards = {
    title = "REWARDS",
}

Tabs.statistics = {
    title = "STATISTICS",
}

local tabsOrder = {
    "home", "character", "shop", "rewards", "statistics"
}

local currentTab = Tabs.home
local currentTabName = "home"

local tabsY = 20
local tabsHeight = 60
local tabsX = 0

function getCurrentTabName()
    return currentTabName
end

function drawTabs()

    local x = screenSize.x - 0
    local y = tabsY
    dxDrawRectangle(tabsX - 20, tabsY, screenSize.x - tabsX + 20, tabsHeight, tocolor(0, 0, 0, 150))
    for i = #tabsOrder, 1, -1 do
        local tab = Tabs[tabsOrder[i]]
        local str = localize(tab.title)
        local width = dxGetTextWidth(str, 2, "default-bold")
        x = x - width - 40
        local alpha = 150
        if isMouseOver(x, y, width, tabsHeight) then
            alpha = 200
            if isMousePressed and currentTab ~= tab then
                if currentTab and currentTab.unload then
                    currentTab.unload()
                end
                currentTab = tab
                currentTabName = tabsOrder[i]
                if currentTab.load then
                    currentTab.load()
                end
            end
        end
        if tab == currentTab then
            alpha = 255
        end
        dxDrawText(str, x, y, x, y + tabsHeight, tocolor(255, 255, 255, alpha), 2, "default-bold", "left", "center")
        tabsX = x
    end

    if currentTab and currentTab.draw then
        currentTab.draw()
    end
end
