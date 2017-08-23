local slotsOrder = {"primary1", "primary2", "secondary", "melee"}

local clientWeapons = {}
local clientSlots = {}

local activeSlotIndex = 1
local reloadTimer

addEvent("onClientWeaponsUpdate", true)
addEventHandler("onClientWeaponsUpdate", resourceRoot, function (weapons)
    clientWeapons = weapons or {}
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

addEvent("onPlayerWeaponSlotUpdate", true)
addEventHandler("onPlayerWeaponSlotUpdate", resourceRoot, function ()
    local item = getActiveWeaponItem()
    if item then
        toggleControl("fire", item.clip > 0 or Items[item.name].category == "weapon_melee")
    end
end)

function showPlayerWeaponSlot(slot)
    if isTimer(reloadTimer) then
        return
    end
    local item = clientWeapons[slot]
    if item then
        toggleControl("fire", false)
        localPlayer:setData("activeSlot", slot)
        triggerServerEvent("showPlayerWeaponSlot", resourceRoot, slot)
    end
end

toggleControl("next_weapon", false)
toggleControl("previous_weapon", false)

bindKey("next_weapon", "down", function ()
    if isTimer(reloadTimer) then
        return
    end
    activeSlotIndex = activeSlotIndex + 1
    if activeSlotIndex > #clientSlots then
        activeSlotIndex = #clientSlots
    end
    showPlayerWeaponSlot(clientSlots[activeSlotIndex])
end)

bindKey("previous_weapon", "down", function ()
    if isTimer(reloadTimer) then
        return
    end
    activeSlotIndex = activeSlotIndex - 1
    if activeSlotIndex < 1 then
        activeSlotIndex = 1
    end
    showPlayerWeaponSlot(clientSlots[activeSlotIndex])
end)

for i = 1, #slotsOrder do
    bindKey(tostring(i), "down", function ()
        if isTimer(reloadTimer) then
            return
        end
        activeSlotIndex = i
        showPlayerWeaponSlot(clientSlots[i])
    end)
end

bindKey("g", "down", function ()
    showPlayerWeaponSlot("grenade")
end)

bindKey("x", "down", function ()
    if isTimer(reloadTimer) then
        return
    end
    if localPlayer.weaponSlot ~= 0 then
        triggerServerEvent("hidePlayerWeapon", resourceRoot)
    else
        showPlayerWeaponSlot(clientSlots[activeSlotIndex])
    end
end)

bindKey("r", "down", function ()
    if isTimer(reloadTimer) then
        return
    end
    if localPlayer.weaponSlot ~= 0 then
        triggerServerEvent("reloadPlayerWeapon", resourceRoot)
        reloadTimer = setTimer(function () end, 2000, 1)
    end
end)

addEvent("cancelReload", true)
addEventHandler("cancelReload", resourceRoot, function ()
    if isTimer(reloadTimer) then
        killTimer(reloadTimer)
    end
end)
