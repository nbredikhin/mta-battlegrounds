Tabs = {}
local screenSize = Vector2(guiGetScreenSize())
local tabsOrder = {
    "home", "character", "shop", "rewards", "statistics"
}

local currentTabName = "home"
local currentTab = Tabs.home

local tabsY = 30
local tabsHeight = 45
local tabsX = 100
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

Tabs.home = {
    title = localize("lobby_tab_home"),

    draw = function ()
        local username = localPlayer:getData("username")
        local y = tabsY
        if username then
            dxDrawText(string.upper(username), 0, y, screenSize.x - 200, y, tocolor(255, 255, 255, 150), 2, "default-bold", "right", "top")

            dxDrawImage(screenSize.x - 180, y - 0, 30, 30, "assets/bp.png")
            local bPoints = tostring(localPlayer:getData("battlepoints"))
            dxDrawText(bPoints, screenSize.x - 145, y, screenSize.x, y, tocolor(255, 255, 255), 2, "default-bold", "left", "top")

            -- y = y + 40
            -- dxDrawImage(screenSize.x - 180, y - 0, 30, 30, "assets/dp.png", 0, 0, 0, tocolor(255, 255, 255))
            -- local dPoints = tostring(localPlayer:getData("donatepoints"))
            -- dxDrawText(dPoints, screenSize.x - 145, y, screenSize.x, y, tocolor(255, 255, 255), 2, "default-bold", "left", "top")
        end
    end
}

Tabs.shop = {
    title = localize("lobby_tab_shop"),

    load = function ()
        localPlayer:setData("lobbyReady", false)
        fadeCamera(false, 0)
        setVisible(false)
        exports.pb_shop:setVisible(true)
    end
}

function getCurrentTabName()
    return currentTabName
end

function resetTab()
    currentTabName = "home"
    currentTab = Tabs.home
end

function drawTabs()
    local x = tabsX
    local y = tabsY
    dxDrawImage(0, -2, screenSize.x, screenSize.y * 0.3, "assets/gradient.png", 0, 0, 0, tocolor(0, 0, 0, 200))

    if currentTab and currentTab.draw then
        currentTab.draw()
    end

    for i = 1, #tabsOrder do
        local tab = Tabs[tabsOrder[i]]
        local str = localize(tab.title)
        local width = dxGetTextWidth(str, tabsTextScale, "default-bold")
        local color = tocolor(255, 255, 255, 150)
        if isMouseOver(x, y, width, tabsHeight) and not tab.disabled then
            color = tocolor(255, 255, 255, 255)
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
            color = tocolor(254, 181, 0)
            dxDrawRectangle(x, y + 15 * tabsTextScale + 2, width, 1.5 * tabsTextScale, tocolor(254, 181, 0))
        end
        if tab.disabled then
            color = tocolor(150, 150, 150)
        end
        dxDrawText(str, x, y, x, y + tabsHeight, color, tabsTextScale, "default-bold", "left", "top")
        x = x + width + tabsSpace
    end
end
