local slotsOrder = {"primary1", "primary2", "secondary", "melee", "grenade"}

local clientWeapons = {}
local clientSlots = {}

local activeSlotIndex = 1
local isWeaponReloading

addEvent("onClientWeaponsUpdate", true)
addEventHandler("onClientWeaponsUpdate", resourceRoot, function (weapons)
    clientWeapons = weapons or {}
    clientSlots = {}
    for i, slot in ipairs(slotsOrder) do
        if clientWeapons[slot] then
            table.insert(clientSlots, slot)
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    triggerServerEvent("requireClientWeapons", resourceRoot)
end)

function getActiveWeaponItem()
    return clientWeapons[clientSlots[activeSlotIndex]]
end

function showPlayerWeaponSlot(slot)
    local item = clientWeapons[slot]
    if item then
        triggerServerEvent("showPlayerWeaponSlot", resourceRoot, slot)
        triggerEvent("onWeaponSlotChange", root, slot)
    end
end

toggleControl("next_weapon", false)
toggleControl("previous_weapon", false)

bindKey("next_weapon", "down", function ()
    activeSlotIndex = activeSlotIndex + 1
    if activeSlotIndex > #clientSlots then
        activeSlotIndex = #clientSlots
    end
    showPlayerWeaponSlot(clientSlots[activeSlotIndex])
end)

bindKey("previous_weapon", "down", function ()
    activeSlotIndex = activeSlotIndex - 1
    if activeSlotIndex < 1 then
        activeSlotIndex = 1
    end
    showPlayerWeaponSlot(clientSlots[activeSlotIndex])
end)

for i = 1, #slotsOrder do
    bindKey(tostring(i), "down", function ()
        activeSlotIndex = i
        showPlayerWeaponSlot(clientSlots[i])
    end)
end

bindKey("g", "down", function ()
    showPlayerWeaponSlot("grenade")
end)

bindKey("x", "down", function ()
    if localPlayer.weaponSlot ~= 0 then
        triggerServerEvent("hidePlayerWeapon", resourceRoot)
    else
        showPlayerWeaponSlot(clientSlots[activeSlotIndex])
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
    return clientSlots[activeSlotIndex], activeSlotIndex
end
