------------------------------------------
-- Отображение оружия в руках персонажа --
------------------------------------------

local isFireAllowed = false
local currentClip = 0
local isReloading = false

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
    currentClip = math.max(0, currentClip - 1)
    if currentClip == 0 then
        isFireAllowed = false
    end
end)

bindKey("r", "down", function ()
    if isScopeBlocked() or localPlayer.weaponSlot == 0 then
        return
    end
    isReloading = true
    triggerServerEvent("onPlayerRequestReload", resourceRoot)
end)

addEvent("onClientReloadWeapon", true)
addEventHandler("onClientReloadWeapon", resourceRoot, function (clip)
    currentClip = clip
    if currentClip > 0 then
        isFireAllowed = true
    end
end)

function cancelReload()
    isReloading = false
end

-- bindKey("x", "down", function ()
--     localPlayer.weaponSlot = 0
--     triggerServerEvent("onPlayerUnequipWeapon", resourceRoot)
--     isReloading = false
-- end)

setTimer(function ()
    if isReloading and getPedAmmoInClip(localPlayer) < 500 then
        isReloading = false
        triggerServerEvent("onPlayerReloadWeapon", resourceRoot, currentClip)
    end
end, 250, 0)

addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function ()
    isReloading = false
    currentClip = 0
    isFireAllowed = false
end)
