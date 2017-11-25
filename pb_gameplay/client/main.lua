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
    exports.pb_login:setVisible(true)
    fadeCamera(true, 1)

    localPlayer:setData("spectatingPlayer", false, false)
end)

addEvent("onClientLoginSuccess", true)
addEventHandler("onClientLoginSuccess", root, function ()
    exports.pb_login:setVisible(false)
    exports.pb_lobby:setVisible(true)
end)

addEventHandler("onClientPlayerVehicleEnter", localPlayer, function ()
    setRadioChannel(0)
end)

addEventHandler("onClientVehicleDamage", root, function (attacker, weapon, loss)
    if source ~= localPlayer.vehicle or localPlayer.dead then
        return
    end
    if attacker then
        return
    end
    if not loss then
        return
    end
    loss = loss / 1000 * 100
    if loss < 10 then
        return
    end
    localPlayer.health = localPlayer.health - loss
    triggerEvent("onClientCustomDamage", localPlayer)
end)

function localize(name)
    local res = getResourceFromName("pb_lang")
    if (res) and (getResourceState(res) == "running") then
        return exports.pb_lang:localize(name)
    else
        return name
    end
end
