
addEvent("onExitToLobby", true)
addEventHandler("onExitToLobby", root, function ()
    showGameHUD(false)
    fadeCamera(false, 0)
    triggerServerEvent("clientLeaveMatch", resourceRoot)
end)

addEvent("onJoinedMatch", true)
addEventHandler("onJoinedMatch", resourceRoot, function (settings, aliveCount)
    resetMatchStats()

    exports.pb_lobby:setVisible(false)
    exports.pb_zones:hideZones()
    exports.pb_hud:setCounter("alive", aliveCount)

    setTimer(fadeCamera, 50, 1, false, 0)
    setTimer(fadeCamera, 1000, 1, true, 1)
    setTimer(showGameHUD, 1500, 1, true)
end)

addEvent("onLeftMatch", true)
addEventHandler("onLeftMatch", resourceRoot, function ()
    showGameHUD(false)
    fadeCamera(false, 0)
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
addEventHandler("onPlayerLeftMatch", resourceRoot, function (player, reason, aliveCount)
    exports.pb_hud:setCounter("alive", aliveCount)
end)

addEvent("onMatchStarted", true)
addEventHandler("onMatchStarted", resourceRoot, function (aliveCount)
    resetMatchStats()

    exports.pb_hud:setCounter("alive", aliveCount)
end)

addEvent("onMatchFinished", true)
addEventHandler("onMatchFinished", resourceRoot, function (rank, totalPlayers, timeAlive)
    showGameHUD(false)

    local matchStats = getMatchStats()

    exports.pb_rank_screen:setScreenData({
        nickname      = string.gsub(localPlayer.name, '#%x%x%x%x%x%x', ''),
        rank          = rank,
        players_total = totalPlayers,
        time_alive    = math.floor(timeAlive / 60),

        reward = 0,
        kills  = matchStats.killsCount or 0,
    })
    exports.pb_rank_screen:setVisible(true)
end)

addEvent("onMatchPlayerWasted", true)
addEventHandler("onMatchPlayerWasted", resourceRoot, function (aliveCount, killer)
    exports.pb_hud:setCounter("alive", aliveCount)

    if isElement(killer) then
        -- TODO: Killchat message
    end
end)
