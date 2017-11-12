Tabs = {}
local screenSize = Vector2(guiGetScreenSize())

Tabs.home = {
    title = localize("lobby_tab_home"),

    draw = function ()
        local username = localPlayer:getData("username")
        local y = 110
        if username then
            dxDrawText(string.upper(username), 2, y + 2, screenSize.x - 200 + 2, y + 2, tocolor(0, 0, 0), 2, "default-bold", "right", "top")
            dxDrawText(string.upper(username), 0, y, screenSize.x - 200, y, tocolor(255, 255, 255), 2, "default-bold", "right", "top")

            dxDrawImage(screenSize.x - 180 + 2, y - 0 + 2, 30, 30, "assets/bp.png", 0, 0, 0, tocolor(0, 0, 0))
            dxDrawImage(screenSize.x - 180, y - 0, 30, 30, "assets/bp.png")
            local bPoints = tostring(localPlayer:getData("battlepoints"))
            dxDrawText(bPoints, screenSize.x - 145 + 2, y + 2, screenSize.x + 2, y + 2, tocolor(0, 0, 0), 2, "default-bold", "left", "top")
            dxDrawText(bPoints, screenSize.x - 145, y, screenSize.x, y, tocolor(255, 255, 255), 2, "default-bold", "left", "top")

            y = y + 40
            dxDrawImage(screenSize.x - 180 + 2, y - 0 + 2, 30, 30, "assets/dp.png", 0, 0, 0, tocolor(0, 0, 0))
            dxDrawImage(screenSize.x - 180, y - 0, 30, 30, "assets/dp.png", 0, 0, 0, tocolor(255, 255, 255))
            local dPoints = tostring(localPlayer:getData("donatepoints"))
            dxDrawText(dPoints, screenSize.x - 145 + 2, y + 2, screenSize.x + 2, y + 2, tocolor(0, 0, 0), 2, "default-bold", "left", "top")
            dxDrawText(dPoints, screenSize.x - 145, y, screenSize.x, y, tocolor(51, 151, 198), 2, "default-bold", "left", "top")
        end
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
local tabsHorizontalOffset = 10
local tabsSpace = 20
local tabsTextScale = 1.5

if screenSize.x >= 1600 then
    tabsTextScale = 2
    tabsHeight = 60
    tabsSpace = 35
    tabsHorizontalOffset = 20
end
if screenSize.x < 1024 then
    tabsTextScale = 1
    tabsHeight = 40
    tabsHorizontalOffset = 5
    tabsSpace = 15
    tabsY = 10
end

function getCurrentTabName()
    return currentTabName
end

function resetTab()
    currentTabName = "home"
    currentTab = Tabs.home
end

function drawTabs()
    local x = screenSize.x - 0
    local y = tabsY
    dxDrawRectangle(tabsX - 20, tabsY, screenSize.x - tabsX + 20, tabsHeight, tocolor(0, 0, 0, 150))
    for i = #tabsOrder, 1, -1 do
        local tab = Tabs[tabsOrder[i]]
        local str = localize(tab.title)
        local width = dxGetTextWidth(str, tabsTextScale, "default-bold")
        x = x - width - tabsSpace
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
