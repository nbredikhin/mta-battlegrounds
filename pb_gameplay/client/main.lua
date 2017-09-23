addEventHandler("onClientResourceStart", resourceRoot, function ()
    -- Отключение фоновых звуков стрельбы - ломает стандартные звуки стрельбы
    -- setWorldSoundEnabled(5, false)
    -- Отключение скрытия объектов
    -- setOcclusionsEnabled(false)
    -- Отключение размытия при движении
    setBlurLevel(0)
    -- Маркер над педами при нажатии ПКМ
    setPedTargetingMarkerEnabled(false)

    showGameHUD(false)
    fadeCamera(false, 0)
    exports.pb_lobby:setVisible(true)
    fadeCamera(true, 1)

    showChat(false)
end)
