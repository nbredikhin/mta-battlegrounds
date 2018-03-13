local isFireAllowed = false

addEventHandler("onClientPreRender", root, function ()
    local isReloading = localPlayer:getData("isReloading")
    local isKnockout = localPlayer:getData("knockout")
    if isReloading then
        isFireAllowed = false
    end
    local enableFire = isFireAllowed
    -- if isInventoryShowing() or isKnockout then
    --     enableFire = false
    -- end

    toggleControl("forwards",        not isKnockout)
    toggleControl("backwards",       not isKnockout)
    toggleControl("right",           not isKnockout)
    toggleControl("next_weapon",     false)
    toggleControl("previous_weapon", false)
    toggleControl("action",          false)
    toggleControl("fire",            enableFire)
    toggleControl("vehicle_fire",    enableFire)

    if not enableFire then
        localPlayer:setControlState("fire",         false)
        localPlayer:setControlState("vehicle_fire", false)
    end

    if isReloading then
        localPlayer:setControlState("aim_weapon", false)
    end

    toggleControl("aim_weapon", not isReloading and not isKnockout)
    toggleControl("jump",       not isReloading and not isKnockout)
    toggleControl("sprint",     not isReloading and not isKnockout)
    toggleControl("enter_exit", not isReloading and not isKnockout)
    toggleControl("crouch",     not isReloading and not isKnockout)

    if localPlayer.ducked then
        toggleControl("forwards",  not isReloading and not isKnockout)
        toggleControl("backwards", not isReloading and not isKnockout)
        toggleControl("left",      not isReloading and not isKnockout)
        toggleControl("right",     not isReloading and not isKnockout)

        if isReloading then
            localPlayer:setControlState("forwards",  false)
            localPlayer:setControlState("backwards", false)
            localPlayer:setControlState("left",      false)
            localPlayer:setControlState("right",     false)
        end
    end
end)


addEventHandler("onClientPlayerWeaponFire", localPlayer, function ()
    -- TODO: Забирать патроны из обоймы
end)

bindKey("r", "down", function ()
    if isScopeBlocked() then
        return
    end
    -- TODO: Перезарядка
end)

bindKey("x", "down", function ()
    -- TODO: Убрать оружие из рук
end)

bindKey("next_weapon", "down", function ()

end)

bindKey("previous_weapon", "down", function ()

end)
