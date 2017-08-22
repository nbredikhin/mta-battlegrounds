local slotsOrder = {"primary1", "primary2", "secondary", "melee"}

local clientWeapons = {}
local clientSlots = {}

local activeSlotIndex = 1

addEvent("onClientWeaponsUpdate", true)
addEventHandler("onClientWeaponsUpdate", resourceRoot, function (weapons)
    clientWeapons = weapons
    clientSlots = {}
    for i, slot in ipairs(slotsOrder) do
        if clientWeapons[slot] then
            table.insert(clientSlots, slot)
        end
    end
    activeSlotIndex = math.max(1, math.min(#clientSlots, activeSlotIndex))
    showPlayerWeaponSlot(clientSlots[activeSlotIndex])
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    triggerServerEvent("requireClientWeapons", resourceRoot)
end)

function getActiveWeaponItem()
    return clientWeapons[clientSlots[activeSlotIndex]]
end

addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function (weaponSlot)
    local item = getActiveWeaponItem()
    if item and item.ammo == 0 then
        toggleControl("fire", false)
    else
        toggleControl("fire", true)
    end
end)

function showPlayerWeaponSlot(slot)
    local item = clientWeapons[slot]
    if item then
        toggleControl("fire", item.ammo > 0)
        localPlayer:setData("activeSlot", slot)
        triggerServerEvent("showPlayerWeaponSlot", resourceRoot, slot)
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
