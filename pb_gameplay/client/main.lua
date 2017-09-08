addEventHandler("onClientResourceStart", resourceRoot, function ()
    -- Отключение фоновых звуков стрельбы
    setWorldSoundEnabled(5, false)
    -- Отключение скрытия объектов
    -- setOcclusionsEnabled(false)
    -- Отключение размытия при движении
    setBlurLevel(0)

    showGameHUD(false)
    fadeCamera(false, 0)
    exports.pb_lobby:setVisible(true)
    fadeCamera(true, 1)
end)

addEvent("onJoinedMatch", true)
addEventHandler("onJoinedMatch", resourceRoot, function (settings)
    exports.pb_lobby:setVisible(false)
    exports.pb_hud:setCounter("alive", 0)

    setTimer(fadeCamera, 50, 1, false, 0)
    setTimer(fadeCamera, 1000, 1, true, 1)
    setTimer(showGameHUD, 1500, 1, true)
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
    exports.pb_hud:setCounter("alive", aliveCount)
end)
