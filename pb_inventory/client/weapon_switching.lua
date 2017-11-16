local slotsOrder = {"primary1", "primary2", "secondary", "melee", "grenade"}
local activeSlotIndex = 1
local reloadableWeapons = {
    primary1  = true,
    primary2  = true,
    secondary = true
}

local isFireAllowed = false

addEventHandler("onClientPreRender", root, function ()
    local isReloading = localPlayer:getData("isReloadingWeapon")
    if isReloading then
        isFireAllowed = false
    end
    local enableFire = isFireAllowed
    if isInventoryShowing() then
        enableFire = false
    end

    toggleControl("next_weapon", false)
    toggleControl("previous_weapon", false)
    toggleControl("action", false)

    toggleControl("fire", enableFire)
    toggleControl("vehicle_fire", enableFire)
    if not enableFire then
        setPedControlState(localPlayer, "fire", false)
        setPedControlState(localPlayer, "vehicle_fire", false)
    end

    if not isInventoryShowing() then
        toggleControl("aim_weapon", not isReloading)
    else
        toggleControl("aim_weapon", false)
    end
    if isReloading then
        setPedControlState(localPlayer, "aim_weapon", false)
    end
    toggleControl("jump", not isReloading)
    toggleControl("sprint", not isReloading)
    toggleControl("enter_exit", not isReloading)
    toggleControl("crouch", not isReloading)
    if localPlayer.ducked then
        toggleControl("forwards", not isReloading)
        toggleControl("backwards", not isReloading)
        toggleControl("left", not isReloading)
        toggleControl("right", not isReloading)

        if isReloading then
            setPedControlState(localPlayer, "forwards", false)
            setPedControlState(localPlayer, "backwards", false)
            setPedControlState(localPlayer, "left", false)
            setPedControlState(localPlayer, "right", false)
        end
    end
end)

function getActiveWeaponItem()
    local slotName = localPlayer:getData("activeWeaponSlot")
    if not slotName then
        return
    end
    return getWeaponSlot(slotName)
end

addEventHandler("onClientPlayerWeaponFire", localPlayer, function ()
    local item = getActiveWeaponItem()
    if isItem(item) then
        if not item.clip then
            setTimer(saveActiveWeaponClip, 100, 1)
        else
            item.clip = math.max(0, item.clip - 1)
            isFireAllowed = item.clip > 0
        end
    else
        isFireAllowed = false
    end

    if localPlayer:getData("isReloading") then
        isFireAllowed = false
    end
end)

bindKey("r", "down", function ()
    if localPlayer:getData("isReloadingWeapon") then
        return
    end
    local slotName = localPlayer:getData("activeWeaponSlot")
    if not slotName or not reloadableWeapons[slotName] then
        return
    end
    local item = getActiveWeaponItem()
    local clip, ammo = getWeaponAmmo(item)
    local itemClass = getItemClass(item.name)
    if itemClass and itemClass.clip <= item.clip or ammo and ammo == 0 then
        return
    end
    saveActiveWeaponClip()
    isFireAllowed = false

    localPlayer:setData("isReloadingWeapon", true, false)
    --:setAnimation("uzi", "uzi_reload", -1, false, false, false, true)
    triggerServerEvent("onPlayerReloadWeapon", resourceRoot)
end)

bindKey("x", "down", function ()
    if isInventoryShowing() then
        return
    end
    setActiveWeaponSlot()
end)

local function updateFireAllowed()
    local item = getActiveWeaponItem()
    if isItem(item) and item.clip then
        isFireAllowed = item.clip > 0
    else
        isFireAllowed = true
    end
end

addEvent("onClientSwitchWeaponSlot", true)
addEventHandler("onClientSwitchWeaponSlot", resourceRoot, function ()
    updateFireAllowed()
end)

function setActiveWeaponSlot(slotName)
    if isInventoryShowing() then
        return
    end
    if localPlayer:getData("isReloadingWeapon") then
        return
    end
    if localPlayer.vehicle and localPlayer.vehicle.controller == localPlayer then
        slotName = ""
    end
    saveActiveWeaponClip()
    triggerServerEvent("onPlayerSwitchWeaponSlot", resourceRoot, slotName)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for i = 1, #slotsOrder do
        bindKey(tostring(i), "down", function ()
            activeSlotIndex = i
            setActiveWeaponSlot(slotsOrder[i])
        end)
    end
end)

function saveActiveWeaponClip()
    local item = getActiveWeaponItem()
    local slotName = localPlayer:getData("activeWeaponSlot")
    if isItem(item) then
        triggerServerEvent("onPlayerSaveWeapon", resourceRoot, slotName, item.clip)
    end
end

function resetMyAnimation()
    localPlayer:setAnimation("ped", "idle_stance")
    setTimer(function ()
        localPlayer:setAnimation()
    end, 50, 1)
end

addEvent("onClientReloadFinished", true)
addEventHandler("onClientReloadFinished", resourceRoot, function ()
    updateFireAllowed()
    resetMyAnimation()
end)

localPlayer:setData("isReloadingWeapon", false)

bindKey("next_weapon", "down", function ()
    if isInventoryShowing() then
        return
    end
    if getControlState("aim_weapon") then
        return
    end
    activeSlotIndex = activeSlotIndex + 1
    if activeSlotIndex > #slotsOrder then
        activeSlotIndex = #slotsOrder
    end
    setActiveWeaponSlot(slotsOrder[activeSlotIndex])
end)

bindKey("previous_weapon", "down", function ()
    if isInventoryShowing() then
        return
    end
    if getControlState("aim_weapon") then
        return
    end
    activeSlotIndex = activeSlotIndex - 1
    if activeSlotIndex < 1 then
        activeSlotIndex = 1
    end
    setActiveWeaponSlot(slotsOrder[activeSlotIndex])
end)
