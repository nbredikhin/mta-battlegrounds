Tabs = {}
local screenSize = Vector2(guiGetScreenSize())

Tabs.home = {
    title = localize("lobby_tab_home"),

    draw = function ()

    end
}

Tabs.shop = {
    title = localize("lobby_tab_shop"),

    load = function ()
        fadeCamera(false, 0)
        setVisible(false)
        exports.pb_shop:setVisible(true)
    end
}

Tabs.rewards = {
    title = localize("lobby_tab_rewards"),
}

Tabs.statistics = {
    title = localize("lobby_tab_stats"),
}

local tabsOrder = {
    "home", "character", "shop", "rewards", "statistics"
}

local currentTabName = "home"
local currentTab = Tabs.home

local tabsY = 20
local tabsHeight = 45
local tabsX = 0
local tabsTextScale = 1.5

if screenSize.x >= 1600 then
    tabsTextScale = 2
    tabsHeight = 60
end

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
        local width = dxGetTextWidth(str, tabsTextScale, "default-bold")
        x = x - width - 35
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
        dxDrawText(str, x, y, x, y + tabsHeight, tocolor(255, 255, 255, alpha), tabsTextScale, "default-bold", "left", "center")
        tabsX = x
    end

    if currentTab and currentTab.draw then
        currentTab.draw()
    end
end
