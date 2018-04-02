--------------------------------------------
-- Добавление и удаление оружия из слотов --
--------------------------------------------

local weaponSlotsOrder = {
    "primary1",
    "primary2",
    "secondary",
    "melee",
    "grenade"
}

local localSlots = {}
local currentWeaponSlot = 1

function equipWeaponSlot(name)
    local currentClip = getCurrentClip()
    if not localSlots[name] then
        name = nil
    end
    triggerServerEvent("onPlayerEquipWeaponSlot", resourceRoot, name, currentClip)
end

addEvent("onClientWeaponSlotChange", true)
addEventHandler("onClientWeaponSlotChange", resourceRoot, function (slot, item)
    if not slot or type(item) ~= "table" then
        return
    end
    localSlots[slot] = item
end)

bindKey("next_weapon", "down", function ()
    cancelReload()
    localPlayer.weaponSlot = 0
    currentWeaponSlot = currentWeaponSlot + 1
    if currentWeaponSlot > #weaponSlotsOrder then
        currentWeaponSlot = 1
    end
    equipWeaponSlot(weaponSlotsOrder[currentWeaponSlot])
end)

bindKey("previous_weapon", "down", function ()
    cancelReload()
    localPlayer.weaponSlot = 0
    currentWeaponSlot = currentWeaponSlot - 1
    if currentWeaponSlot < 1 then
        currentWeaponSlot = #weaponSlotsOrder
    end
    equipWeaponSlot(weaponSlotsOrder[currentWeaponSlot])
end)

bindKey("x", "down", function ()
    if localPlayer.weaponSlot == 0 then
        tequipWeaponSlot(weaponSlotsOrder[currentWeaponSlot])
    else
        localPlayer.weaponSlot = 0
        cancelReload()
        equipWeaponSlot()
    end
end)

for i = 1, #weaponSlotsOrder do
    bindKey(tostring(i), "down", function ()
        currentWeaponSlot = i
        equipWeaponSlot(weaponSlotsOrder[i])
    end)
end
