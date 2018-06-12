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
local activeSlotIndex = 1

-----------------------
-- Локальные функции --
-----------------------

local function nextWeaponSlot()
    activeSlotIndex = activeSlotIndex + 1
    if activeSlotIndex > #weaponSlotsOrder then
        activeSlotIndex = 1
    end
    equipWeaponSlot(weaponSlotsOrder[activeSlotIndex])
end

local function prevWeaponSlot()
    activeSlotIndex = activeSlotIndex - 1
    if activeSlotIndex < 1 then
        activeSlotIndex = #weaponSlotsOrder
    end
    equipWeaponSlot(weaponSlotsOrder[activeSlotIndex])
end

local function toggleWeaponSlot()
    if localPlayer:getData("weaponSlot") then
        equipWeaponSlot()
    else
        equipWeaponSlot(weaponSlotsOrder[activeSlotIndex])
    end
end

------------------------
-- Глобальные функции --
------------------------

function equipWeaponSlot(name)
    if not name or not localSlots[name] then
        name = nil
    end
    if name == localPlayer:getData("weaponSlot") then
        return
    end
    handleSlotSwitch()
    -- Запросить новое оружие
    triggerServerEvent("onPlayerEquipWeaponSlot", resourceRoot, name)
end

function getWeaponSlot(slot)
    if slot then
        return localSlots[slot]
    end
end

function getLocalSlots()
    return localSlots
end

-----------------------
-- Обработка событий --
-----------------------

addEvent("onClientWeaponSlotUpdate", true)
addEventHandler("onClientWeaponSlotUpdate", resourceRoot, function (slot, item)
    if not slot then
        return
    end
    localSlots[slot] = item
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    bindKey("next_weapon",     "down", nextWeaponSlot)
    bindKey("previous_weapon", "down", prevWeaponSlot)
    bindKey("x", "down", toggleWeaponSlot)

    for i = 1, #weaponSlotsOrder do
        bindKey(tostring(i), "down", function ()
            activeSlotIndex = i
            equipWeaponSlot(weaponSlotsOrder[i])
        end)
    end
end)
