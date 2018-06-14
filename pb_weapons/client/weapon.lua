------------------------------------------
-- Отображение оружия в руках персонажа --
------------------------------------------

local isFireAllowed = false
local isReloading = false

local currentSlot = nil
local currentClip = 0

local reloadCheckDelay = 100

local disableReloadSlots = {
    [0] = true,
    [1] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
}

-----------------------
-- Локальные функции --
-----------------------

local function checkReload()
    if isReloading and getPedAmmoInClip(localPlayer) < 500 then
        triggerServerEvent("onPlayerWeaponReload", resourceRoot, "finish", currentSlot, currentClip)
    end
end

local function checkFireAllowed()
    isFireAllowed = currentClip > 0
end

------------------------
-- Глобальные функции --
------------------------

function saveCurrentSlotClip()
    if not currentSlot then
        return
    end
    local item = getWeaponSlot(currentSlot)
    if item then
        item.clip = currentClip
    end
    triggerServerEvent("onPlayerWeaponSlotSave", resourceRoot, currentSlot, currentClip)
end

function getFireAllowed()
    return isFireAllowed
end

function getReloading()
    return isReloading
end

function reloadWeapon()
    if isScopeBlocked() or disableReloadSlots[localPlayer.weaponSlot] then
        return
    end
    cancelReload()
    isReloading = true
    triggerServerEvent("onPlayerWeaponReload", resourceRoot, "start", currentSlot, currentClip)
end

function cancelReload()
    isReloading = false
end

function getWeaponClip()
    return currentClip
end

function handleSlotSwitch()
    setWeaponModelVisible(false)
    -- Сохранить патроны
    saveCurrentSlotClip()
    -- Убрать текущее оружие из рук
    cancelReload()
    localPlayer.weaponSlot = 0
    currentSlot = nil
    setControlState("fire", false)
end

-----------------------
-- Обработка событий --
-----------------------

addEventHandler("onClientResourceStart", resourceRoot, function ()
    bindKey("r", "down", reloadWeapon)

    setTimer(checkReload, reloadCheckDelay, 0)
end)

-- Обработка смены оружия в руках
addEvent("onClientWeaponSwitch", true)
addEventHandler("onClientWeaponSwitch", resourceRoot, function (slot)
    cancelReload()

    local item = getWeaponSlot(slot)
    currentSlot = slot
    hiddenWeaponSlot = nil

    setWeaponScope()
    setWeaponRecoil()

    if item then
        if item.attachments and item.attachments.scope then
            setWeaponScope(item.attachments.scope)
        end

        local weapon = WeaponsTable[item.name]
        if weapon then
            setWeaponRecoil(weapon.recoilX, weapon.recoilY)
        end

        currentClip = item.clip or 0
        checkFireAllowed()
        setWeaponModelVisible(true)
    else
        currentClip = 0
        isFireAllowed = false
    end
    setControlState("fire", false)
end)

-- Обработка завершения перезарядки
addEvent("onClientWeaponReloadFinish", true)
addEventHandler("onClientWeaponReloadFinish", resourceRoot, function (slot, clip)
    if slot == "grenade" then
        isReloading = true
    end
    if slot ~= currentSlot or not isReloading then
        return
    end
    isReloading = false
    currentClip = clip
    checkFireAllowed()
    saveCurrentSlotClip()
end)

addEventHandler("onClientPlayerWeaponFire", localPlayer, function ()
    if not isFireAllowed then
        outputDebugString("onClientPlayerWeaponFire when fire allowed")
    end
    currentClip = currentClip - 1
    if currentClip <= 0 then
        currentClip = 0
        isFireAllowed = false
        saveCurrentSlotClip()
    end
end)

addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function (_, weaponSlot)
    if weaponSlot == 0 then
        currentSlot = nil
    end
end)

-- Обработка состояний клавиш
addEventHandler("onClientPreRender", root, function ()
    local isReloading = localPlayer:getData("isReloading")
    local isKnockout = localPlayer:getData("knockout")
    if isReloading then
        isFireAllowed = false
    end
    local fireState = isFireAllowed
    -- if isInventoryShowing() or isKnockout then
    --     fireState = false
    -- end

    toggleControl("forwards",        not isKnockout)
    toggleControl("backwards",       not isKnockout)
    toggleControl("right",           not isKnockout)
    toggleControl("next_weapon",     false)
    toggleControl("previous_weapon", false)
    toggleControl("action",          false)
    toggleControl("fire",            fireState)
    toggleControl("vehicle_fire",    fireState)

    if not fireState then
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
