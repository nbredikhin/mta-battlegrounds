local screenSize = Vector2(guiGetScreenSize())

local panelWidth, panelHeight = math.min(screenSize.x - 30, 1000), math.min(screenSize.y - 300, 600)

local currentPanel = "statistics"

local function drawStatsBlock(x, y, width, height, title, value, label, fields)
    dxDrawText(title, x+4, y+4, x + width+4, y + 60 +4 , tocolor(0, 0, 0, 150), 3.5, "default-bold", "center", "center")
    dxDrawText(title, x, y, x + width, y + 60, tocolor(255, 255, 255), 3.5, "default-bold", "center", "center")
    y = y + 60
    dxDrawText(value, x+5, y+5, x + width+5, y + 50 +5 , tocolor(0, 0, 0, 150), 4, "default-bold", "center", "center")
    dxDrawText(value, x, y, x + width, y + 50, tocolor(255, 255, 255), 4, "default-bold", "center", "center")
    y = y + 50
    dxDrawText(label, x+2, y+2, x + width+2, y + 35 +2 , tocolor(0, 0, 0, 150), 2, "default-bold", "center", "center")
    dxDrawText(label, x, y, x + width, y + 35, tocolor(255, 255, 255), 2, "default-bold", "center", "center")
    if not fields or #fields == 0 then
        return
    end
    y = y + 50
    local count = math.min(#fields, 2)
    local h = 30 * count + 20
    dxDrawRectangle(x, y, width, h, tocolor(0, 0, 0, 200))
    dxDrawLine(x, y, x + width - 1, y, tocolor(255, 255, 255, 150))
    dxDrawLine(x, y + h, x + width - 1, y + h, tocolor(255, 255, 255, 150))
    y = y + 10
    for i = 1, count do
        local name, value = unpack(fields[i])
        dxDrawText(name, x + 10, y, x + width, y + 30, tocolor(255, 255, 255), 1.5, "default-bold", "left", "center")
        dxDrawText(value, x, y, x + width - 10, y + 30, tocolor(255, 255, 255), 1.5, "default-bold", "right", "center")
        y = y + 30
    end
    if #fields <= 2 then
        return
    end
    y = y + 20
    for i = 3, #fields do
        local name, value = unpack(fields[i])
        if not name then
            name = ""
        end
        if not value then
            value = ""
        end
        dxDrawText(name, x + 10, y, x + width, y + 30, tocolor(200, 200, 200), 1, "default-bold", "left", "center")
        dxDrawText(value, x, y, x + width - 10, y + 30, tocolor(200, 200, 200), 1, "default-bold", "right", "center")
        y = y + 30
    end
end

local function drawStatisticsPanel(x, y)
    local width = (panelWidth - 20) / 3
    drawStatsBlock(x, y, width, panelHeight, "PLAY", 10, "rounds", {
        {"Time Played", "03h 033m"},
        {"Days Played", "2"},
        {"AVG Distance Travelled", "3.42km"},
        {"Total Distance Travelled", "34km"},
    })

    drawStatsBlock(x + 10 + width, y, width, panelHeight, "WINS", 0, "rounds", {
        {"Top 10", "5"},
        {"Win Rating", "0.125"},
        {"Win Ratio", "0%"},
        {"Top 10 Ratio", "50%"},
        {},
        {"AVG Time Survived", "21m 23s"},
        {"Longest Time Survived", "32m 02s"},
    })

    drawStatsBlock(x + 20 + width * 2, y, width, panelHeight, "KILLS", 30, "players", {
        {"Assists", "0"},
        {"Kill Rating", "1.25"},
        {"Headshots", "4"},
        {"Longest kill", "139m"},
    })
end

local function draw()
    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))

    local x, y = screenSize.x/2 - panelWidth/2, screenSize.y/2 - panelHeight/2
    if currentPanel == "statistics" then
        if drawButton("Таблица лидеров", x + panelWidth - 180, y - 50, 180, 40) then
            currentPanel = "ranks"
        end
        drawStatisticsPanel(x, y)
    else
        if drawButton("Моя статистика", x + panelWidth - 180, y - 50, 180, 40) then
            currentPanel = "statistics"
        end
    end
end

Tabs.statistics = {
    title = localize("lobby_tab_stats"),

    draw = draw
}
