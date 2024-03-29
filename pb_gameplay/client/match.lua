local squadPlayers = {}
local isMatchRunning = false
local spectatingTimer

local function handleLeavingMatch()
    exports.pb_airdrop:destroyAirDrop()
    stopSpectating()
    squadPlayers = {}
    exports.pb_zones:removeZones()
    showGameHUD(false)
    fadeCamera(false, 0)
    setWeather(0)
    setTime(12, 0)

    isMatchRunning = false
end

addEvent("onExitToLobby", true)
addEventHandler("onExitToLobby", root, function ()
    handleLeavingMatch()
    triggerServerEvent("clientLeaveMatch", resourceRoot)
end)

function getSquadPlayers()
    return squadPlayers
end

function isSquadPlayer(player)
    return player:getData("matchId") == localPlayer:getData("matchId") and player:getData("squadId") == localPlayer:getData("squadId")
end

-- Когда отряд игрока присоединился к матчу
addEvent("onMatchSquadJoined", true)
addEventHandler("onMatchSquadJoined", resourceRoot, function (squadPlayersList)
    if type(squadPlayersList) == "table" then
        squadPlayers = squadPlayersList
    else
        squadPlayers = {}
    end
end)

addEvent("onJoinedMatch", true)
addEventHandler("onJoinedMatch", resourceRoot, function (settings, aliveCount, squadPlayersList)
    resetMatchStats()

    exports.pb_lobby:setVisible(false)
    exports.pb_shop:setVisible(false)
    exports.pb_zones:hideZones()
    exports.pb_airdrop:destroyAirDrop()
    exports.pb_hud:setCounter("alive", aliveCount)

    setTimer(fadeCamera, 50, 1, false, 0)
    setTimer(fadeCamera, 1000, 3, true, 1)
    setTimer(showGameHUD, 1500, 1, true)

    for i, element in ipairs(getResourceFromName("pb_mapping").rootElement:getChildren()) do
        element.dimension = localPlayer.dimension
    end

    localPlayer:setData("map_marker", false)
    localPlayer:setData("spectatingPlayer", false, false)

    local weather = Config.weathers[settings.weather]
    if weather then
        setWeather(weather.id)
    end
    if settings.hour then
        setTime(settings.hour, 0)
        setMinuteDuration(600000)
    end

    -- Выгрузить лишнюю одежду
    exports.pb_clothes:reloadClothes()
end)

addEvent("onLeftMatch", true)
addEventHandler("onLeftMatch", resourceRoot, function ()
    destroyPlane()

    handleLeavingMatch()
    exports.pb_rank_screen:setVisible(false)
    setTimer(function ()
        exports.pb_lobby:setVisible(true)
        fadeCamera(true, 1)
    end, 500, 1)
end)

addEvent("onPlayerJoinedMatch", true)
addEventHandler("onPlayerJoinedMatch", resourceRoot, function (player, aliveCount)
    exports.pb_hud:setCounter("alive", aliveCount)
end)

addEvent("onPlayerLeftMatch", true)
addEventHandler("onPlayerLeftMatch", resourceRoot, function (player, reason)
    --exports.pb_hud:setCounter("alive", aliveCount)
end)

addEvent("onMatchStarted", true)
addEventHandler("onMatchStarted", resourceRoot, function (aliveCount)
    exports.pb_lobby:setVisible(false)
    exports.pb_shop:setVisible(false)

    isMatchRunning = true

    resetMatchStats()
    fadeCamera(true)
    exports.pb_hud:setCounter("alive", aliveCount)

    setWindowFlashing(true, 10)
end)

addEvent("onMatchFinished", true)
addEventHandler("onMatchFinished", resourceRoot, function (rank, totalPlayers, timeAlive, reward)
    if isTimer(spectatingTimer) then
        killTimer(spectatingTimer)
        fadeCamera(true)
    end
    isMatchRunning = false
    stopSpectating(true)
    showGameHUD(false)

    local matchStats = getMatchStats()
    local accuracy = 0
    if matchStats.shots_total > 0 then
        accuracy = math.floor(matchStats.shots_hit / matchStats.shots_total * 100)
    end

    exports.pb_rank_screen:setScreenData({
        nickname      = string.gsub(localPlayer.name, '#%x%x%x%x%x%x', ''),
        rank          = rank,
        players_total = totalPlayers,
        time_alive    = math.floor(timeAlive / 60),

        reward        = reward,
        accuracy      = accuracy,
        kills         = localPlayer:getData("kills")        or 0,
        damage_taken  = localPlayer:getData("damage_taken") or 0,
        hp_healed     = localPlayer:getData("hp_healed")    or 0,
    })
    exports.pb_rank_screen:setVisible(true)
end)

addEvent("onMatchPlayerWasted", true)
addEventHandler("onMatchPlayerWasted", root, function (aliveCount, killer)
    exports.pb_hud:setCounter("alive", aliveCount)

    if isElement(killer) then
        -- TODO: Killchat message
    end
end)

addEvent("onZoneShrink", true)
addEventHandler("onZoneShrink", resourceRoot, function (messageType, params)
    exports.pb_alert:show(localize("alert_shrink_started"), 4000)
end)

addEvent("onMatchAlert", true)
addEventHandler("onMatchAlert", resourceRoot, function (messageType, params)
    if messageType == "need_players" then
        local str = string.format(
            localize("alert_waiting_players"),
            tostring(params.current),
            tostring(params.need))

        exports.pb_alert:show(str, 2000, 0xFFAAFAE1)
    elseif messageType == "waiting_start" then
        local str = string.format(
            localize("alert_match_starts_in"),
            tostring(params.timeLeft))
        exports.pb_alert:show(str, 2000, 0xFFAAFAE1)
    elseif messageType == "waiting_end" then
        local str = string.format(
            localize("alert_match_ends_in"),
            tostring(params.timeLeft))

        exports.pb_alert:show(str, 2000, 0xFFAAFAE1)
    end
end)

addEvent("onMatchWasted", true)
addEventHandler("onMatchWasted", resourceRoot, function ()
    if not isMatchRunning then
        return
    end
    fadeCamera(false, 0.5)
    spectatingTimer = setTimer(startSpectating, 500, 1)
end)
