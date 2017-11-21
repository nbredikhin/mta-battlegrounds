local screenSize = Vector2(guiGetScreenSize())

local panelWidth, panelHeight = math.min(screenSize.x - 30, 1000), math.min(screenSize.y - 300, 600)

local currentPanel = "statistics"
local currentRatingMode = "solo"

local ratingTable = {
    { name = "rank",         size = 0.1  },
    { name = "username",     size = 0.25 },
    { name = "rating",       size = 0.15 },
    { name = "playtime",     size = 0.2  },
    { name = "rating_wins",  size = 0.15 },
    { name = "rating_kills", size = 0.15 },
}

local updateFloodTimers = {}

local localPlayerStats = {}
local localPlayerRating = {}
local topPlayersRating = {}

local function requireRating()
    if isTimer(updateFloodTimers[currentRatingMode]) then
        return
    end
    topPlayersRating = {}
    localPlayerRating = {}
    triggerServerEvent("onPlayerRequireRating", resourceRoot, currentRatingMode)
    triggerServerEvent("onPlayerRequireOwnRating", resourceRoot, currentRatingMode)
    updateFloodTimers[currentRatingMode] = setTimer(function () end, 10000, 1)
end

local function playtimeToString(playtime)
    if not playtime then
        return
    end

    local seconds = tonumber(playtime) or 0
    if seconds < 60 then
        playtime = tostring(seconds) .. "s"
    else
        local minutes = math.floor(seconds / 60)
        seconds = seconds - 60 * minutes
        if minutes < 60 then
            playtime = tostring(minutes) .. "m " ..tostring(seconds) .. "s"
        else
            local hours = math.floor(minutes / 60)
            minutes = minutes - hours * 60
            playtime = tostring(hours) .. "h " ..tostring(minutes) .. "m"
        end
    end
    return playtime
end

local function drawStatsBlock(x, y, width, height, title, label, fields)
    local localizedTitle = localize(title)
    local localizedLabel = localize(label)
    dxDrawText(localizedTitle, x+4, y+4, x + width+4, y + 60 +4 , tocolor(0, 0, 0, 150), 3.5, "default-bold", "center", "center")
    dxDrawText(localizedTitle, x, y, x + width, y + 60, tocolor(255, 255, 255), 3.5, "default-bold", "center", "center")
    y = y + 60
    local value = localPlayerStats[title] or 0
    dxDrawText(value, x+4, y+4, x + width+4, y + 50 +4 , tocolor(0, 0, 0, 150), 4, "default-bold", "center", "center")
    dxDrawText(value, x, y, x + width, y + 50, tocolor(255, 255, 255), 4, "default-bold", "center", "center")
    y = y + 50
    dxDrawText(localizedLabel, x+2, y+2, x + width+2, y + 35 +2 , tocolor(0, 0, 0, 150), 2, "default-bold", "center", "center")
    dxDrawText(localizedLabel, x, y, x + width, y + 35, tocolor(255, 255, 255), 2, "default-bold", "center", "center")
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
        local name = fields[i]
        dxDrawText(localize(name), x + 10, y, x + width, y + 30, tocolor(255, 255, 255), 1.5, "default-bold", "left", "center")
        dxDrawText(localPlayerStats[name] or 0, x, y, x + width - 10, y + 30, tocolor(255, 255, 255), 1.5, "default-bold", "right", "center")
        y = y + 30
    end
    if #fields <= 2 then
        return
    end
    y = y + 20
    for i = 3, #fields do
        local name = fields[i]
        if name then
            dxDrawText(localize(name), x + 10, y, x + width, y + 30, tocolor(200, 200, 200), 1, "default-bold", "left", "center")
            dxDrawText(localPlayerStats[name] or 0, x, y, x + width - 10, y + 30, tocolor(200, 200, 200), 1, "default-bold", "right", "center")
        end
        y = y + 30
    end
end

local function drawRankingsPanel(x, y)
    local bg = nil
    local bgColor = tocolor(254, 181, 0)
    if currentRatingMode == "solo" then
        bg = bgColor
    end
    if drawButton("SOLO", x, y, 90, 40, bg) then
        currentRatingMode = "solo"
        requireRating()
    end
    bg = nil
    if currentRatingMode == "squad" then
        bg = bgColor
    end
    if drawButton("SQUAD", x, y + 50, 90, 40, bg) then
        currentRatingMode = "squad"
        requireRating()
    end

    local headerSize = 35
    local playerRankSize = 60
    local itemSize = 40

    x = x + 100
    local width = panelWidth - 100
    local cx = x

    dxDrawRectangle(x, y, width, headerSize, tocolor(0, 0, 0, 150))
    dxDrawLine(x, y, x + width - 1, y, tocolor(254, 181, 0))
    for i, column in ipairs(ratingTable) do
        dxDrawText(localize("ranktable_"..column.name), cx, y, cx + width * column.size, y + headerSize, tocolor(255, 255, 255), 1, "default-bold", "center", "center")
        cx = cx + width * column.size
    end
    y = y + headerSize

    dxDrawRectangle(x, y, width, playerRankSize, tocolor(150, 150, 150, 100))
    dxDrawLine(x, y, x + width - 1, y, tocolor(150, 150, 150))
    cx = x
    for i, column in ipairs(ratingTable) do
        local text = "..."
        if localPlayerRating[column.name] then
            text = localPlayerRating[column.name]
        end
        dxDrawText(text, cx, y, cx + width * column.size, y + playerRankSize, tocolor(255, 255, 255), 1.5, "default-bold", "center", "center")
        cx = cx + width * column.size
    end
    y = y + playerRankSize

    for i = 1, math.min(#topPlayersRating, 10) do
        dxDrawRectangle(x, y, width, itemSize, tocolor(0, 0, 0, 150))
        if i <= 3 then
            dxDrawRectangle(x, y, width, itemSize, tocolor(254, 181, 0, 150 / i))
            dxDrawLine(x, y, x + width - 1, y, tocolor(0, 0, 0, 100))
        else
            dxDrawLine(x, y, x + width - 1, y, tocolor(150, 150, 150, 50))
        end
        cx = x
        local rowData = topPlayersRating[i]
        for _, column in ipairs(ratingTable) do
            local text = "..."
            if column.name == "rank" then
                text = i
            elseif rowData[column.name] then
                text = rowData[column.name]
            end
            dxDrawText(text, cx, y, cx + width * column.size, y + itemSize, tocolor(255, 255, 255), 1, "default-bold", "center", "center")
            cx = cx + width * column.size
        end
        y = y + itemSize
    end
end

local function drawStatisticsPanel(x, y)
    local width = (panelWidth - 20) / 3
    drawStatsBlock(x, y, width, panelHeight, "stats_plays", "stats_rounds", { -- stats_plays
        "stats_plays_solo",
        "stats_plays_squad",
        "stats_playtime",
        nil,
        "stats_distance",
        "stats_distance_ped",
        "stats_distance_car",
    })

    drawStatsBlock(x + 10 + width, y, width, panelHeight, "stats_wins", "stats_rounds", { -- stats_wins_solo + stats_wins_squad
        "stats_wins_solo",
        "stats_wins_squad",
        "stats_top10",
        "stats_top10_solo",
        "stats_top10_squad",
    })

    drawStatsBlock(x + 20 + width * 2, y, width, panelHeight, "stats_kills", "stats_players", { -- stats_kills
        "stats_deaths",
        "stats_kd_ratio",
        "stats_hp_damage",
        "stats_hp_healed",
        "stats_items_used",
    })
end

local function draw()
    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))

    local x, y = screenSize.x/2 - panelWidth/2, screenSize.y/2 - panelHeight/2
    if currentPanel == "statistics" then
        if drawButton(localize("lobby_rating"), x + panelWidth - 180, y - 50, 180, 40) then
            currentPanel = "rating"
        end
        drawStatisticsPanel(x, y)
    else
        if drawButton(localize("lobby_statistics"), x + panelWidth - 180, y - 50, 180, 40) then
            currentPanel = "statistics"
        end
        drawRankingsPanel(x, y)
    end
end

addEvent("onClientStatsUpdated", true)
addEventHandler("onClientStatsUpdated", root, function (stats)
    localPlayerStats = stats or {}
    localPlayerStats.stats_plays = (tonumber(localPlayerStats.stats_plays_squad) or 0) + (tonumber(localPlayerStats.stats_plays_solo) or 0)
    localPlayerStats.stats_wins = (tonumber(localPlayerStats.stats_wins_squad) or 0) + (tonumber(localPlayerStats.stats_wins_solo) or 0)
    localPlayerStats.stats_distance = (tonumber(localPlayerStats.stats_distance_ped) or 0) + (tonumber(localPlayerStats.stats_distance_car) or 0)

    localPlayerStats.stats_distance = tostring(localPlayerStats.stats_distance) .. "km"
    localPlayerStats.stats_distance_ped = tostring(localPlayerStats.stats_distance_ped) .. "km"
    localPlayerStats.stats_distance_car = tostring(localPlayerStats.stats_distance_car) .. "km"

    localPlayerStats.stats_playtime = playtimeToString(localPlayerStats.stats_playtime)

    local kills = tonumber(localPlayerStats.stats_kills) or 0
    local deaths = tonumber(localPlayerStats.stats_deaths) or 0
    if deaths == 0 then
        localPlayerStats.stats_kd_ratio = "0.0"
    else
        localPlayerStats.stats_kd_ratio = math.floor(kills / deaths * 1000) / 1000
    end
end)

local function getPlayerRatingTable(data, matchType)
    return {
        rank = data.rank,
        username = data.username,
        playtime = playtimeToString(data.stats_playtime),
        rating = data["rating_"..matchType.."_main"],
        rating_kills = data["rating_"..matchType.."_kills"],
        rating_wins = data["rating_"..matchType.."_wins"],
    }
end

addEvent("onClientRatingUpdated", true)
addEventHandler("onClientRatingUpdated", root, function (matchType, rating)
    topPlayersRating = {}
    for i, data in ipairs(rating) do
        table.insert(topPlayersRating, getPlayerRatingTable(data, matchType))
    end
end)

addEvent("onClientOwnRatingUpdated", true)
addEventHandler("onClientOwnRatingUpdated", root, function (matchType, data)
    localPlayerRating = getPlayerRatingTable(data[1], matchType)
end)

Tabs.statistics = {
    title = localize("lobby_tab_stats"),

    load = function ()
        triggerServerEvent("onPlayerRequestStats", resourceRoot)

        requireRating()
    end,

    draw = draw
}
