local slotsOrder = {"primary1", "primary2", "secondary", "melee", "grenade"}
local activeSlotIndex = 1
local reloadableWeapons = {
    primary1  = true,
    primary2  = true,
    secondary = true
}

local isFireAllowed = false

addEventHandler("onClientPreRender", root, function ()
    toggleControl("next_weapon", false)
    toggleControl("previous_weapon", false)

    toggleControl("fire", isFireAllowed)
    toggleControl("aim_weapon", true)
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
    triggerServerEvent("onPlayerReloadWeapon", resourceRoot)
end)

bindKey("x", "down", function ()
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
    if localPlayer:getData("isReloadingWeapon") then
        return
    end
    if localPlayer.vehicle then
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

addEvent("onClientReloadFinished", true)
addEventHandler("onClientReloadFinished", resourceRoot, function ()
    updateFireAllowed()
end)

localPlayer:setData("isReloadingWeapon", false)

bindKey("next_weapon", "down", function ()
    activeSlotIndex = activeSlotIndex + 1
    if activeSlotIndex > #slotsOrder then
        activeSlotIndex = #slotsOrder
    end
    setActiveWeaponSlot(slotsOrder[activeSlotIndex])
end)

bindKey("previous_weapon", "down", function ()
    activeSlotIndex = activeSlotIndex - 1
    if activeSlotIndex < 1 then
        activeSlotIndex = 1
    end
    setActiveWeaponSlot(slotsOrder[activeSlotIndex])
end)
