local slotsOrder = {"primary1", "primary2", "secondary", "melee", "grenade"}

local clientWeapons = {}

local activeSlotIndex = 1
local isWeaponReloading

addEvent("onClientWeaponsUpdate", true)
addEventHandler("onClientWeaponsUpdate", resourceRoot, function (weapons)
    clientWeapons = weapons or {}
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    triggerServerEvent("requireClientWeapons", resourceRoot)
end)

function getActiveWeaponItem()
    return clientWeapons[slotsOrder[activeSlotIndex]]
end

function showPlayerWeaponSlot(slot)
    local item = clientWeapons[slot]
    if item then
        triggerServerEvent("showPlayerWeaponSlot", resourceRoot, slot)
        triggerEvent("onWeaponSlotChange", root, slot)
    else
        triggerServerEvent("hidePlayerWeapon", resourceRoot)
    end
end

toggleControl("next_weapon", false)
toggleControl("previous_weapon", false)

bindKey("next_weapon", "down", function ()
    activeSlotIndex = activeSlotIndex + 1
    if activeSlotIndex > #slotsOrder then
        activeSlotIndex = #slotsOrder
    end
    showPlayerWeaponSlot(slotsOrder[activeSlotIndex])
end)

bindKey("previous_weapon", "down", function ()
    activeSlotIndex = activeSlotIndex - 1
    if activeSlotIndex < 1 then
        activeSlotIndex = 1
    end
    showPlayerWeaponSlot(slotsOrder[activeSlotIndex])
end)

for i = 1, #slotsOrder do
    bindKey(tostring(i), "down", function ()
        activeSlotIndex = i
        showPlayerWeaponSlot(slotsOrder[i])
    end)
end

bindKey("g", "down", function ()
    showPlayerWeaponSlot("grenade")
end)

bindKey("x", "down", function ()
    if localPlayer.weaponSlot ~= 0 then
        triggerServerEvent("hidePlayerWeapon", resourceRoot)
    else
        showPlayerWeaponSlot(slotsOrder[activeSlotIndex])
    end
end)

bindKey("r", "down", function ()
    local item = getActiveWeaponItem()
    if item then
        triggerServerEvent("reloadPlayerWeapon", resourceRoot)
        isWeaponReloading = true
    end
end)

addEvent("onWeaponReloadFinished", true)
addEventHandler("onWeaponReloadFinished", resourceRoot, function (successs)
    isWeaponReloading = false
end)

function getClientWeapons()
    return clientWeapons
end

function getWeaponSlot(slot)
    if not slot then
        return
    end
    return clientWeapons[slot]
end

function getActiveWeaponSlot()
    return slotsOrder[activeSlotIndex], activeSlotIndex
end
