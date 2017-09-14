local slotsOrder = {"primary1", "primary2", "secondary", "melee", "grenade"}

local clientWeapons = {}

local activeSlotIndex = 1
local isWeaponReloading

addEvent("onClientWeaponsUpdate", true)
addEventHandler("onClientWeaponsUpdate", resourceRoot, function (weapons)
    clientWeapons = weapons or {}
    triggerEvent("onWeaponsUpdate", root)
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    triggerServerEvent("requireClientWeapons", resourceRoot)
end)

function getWeaponAmmo(item)
    if not isItem(item) then
        return
    end
    local itemClass = Items[item.name]
    if itemClass.category == "weapon_primary" or itemClass.category == "weapon_secondary" then
        local ammo = getBackpackItem(itemClass.ammo)
        local count = 0
        if isItem(ammo) then
            count = ammo.count
        end
        return item.clip, count
    elseif itemClass.category == "weapon_grenade" then
        return item.count
    end
end

function getActiveWeaponItem()
    return clientWeapons[slotsOrder[activeSlotIndex]]
end

function showPlayerWeaponSlot(slot)
    toggleControl("next_weapon", false)
    toggleControl("previous_weapon", false)
    local item = clientWeapons[slot]
    if item then
        triggerServerEvent("showPlayerWeaponSlot", resourceRoot, slot)
        triggerEvent("onWeaponSlotChange", root, slot)
    end
end

toggleControl("next_weapon", false)
toggleControl("previous_weapon", false)

bindKey("next_weapon", "down", function ()
    toggleControl("next_weapon", false)
    toggleControl("previous_weapon", false)

    activeSlotIndex = activeSlotIndex + 1
    if activeSlotIndex > #slotsOrder then
        activeSlotIndex = #slotsOrder
    end
    showPlayerWeaponSlot(slotsOrder[activeSlotIndex])
end)

bindKey("previous_weapon", "down", function ()
    toggleControl("next_weapon", false)
    toggleControl("previous_weapon", false)

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
    toggleControl("next_weapon", false)
    toggleControl("previous_weapon", false)

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
