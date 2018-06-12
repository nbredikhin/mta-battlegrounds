--------------------------------------------
-- Добавление и удаление оружия из слотов --
--------------------------------------------

local weaponSlots = {
    primary1  = true,
    primary2  = true,
    secondary = true,
    melee     = true,
    grenade   = true
}
-- Оружие игроков
local playerWeaponSlots = {}

-----------------------
-- Локальные функции --
-----------------------

-- Можно ли положить оружие weapon в слот slot
local function isWeaponSlotMatching(weapon, slot)
    if slot == "primary1" or slot == "primary2" then
        slot = "primary"
    end
    return weapon.slot == slot
end

------------------------
-- Глобальные функции --
------------------------

function isValidWeaponSlot(slot)
    return slot and weaponSlots[slot]
end

-- Помещает оружие в слот
function setPlayerWeaponSlot(player, slot, item)
    if not isElement(player) or type(item) ~= "table" or not slot then
        return false
    end
    -- Несуществующий слот
    if not playerWeaponSlots[player] or not weaponSlots[slot] or playerWeaponSlots[player][slot] then
        return false
    end
    -- TODO: Проверка наличия другого оружия в слоте

    -- Несуществующее оружие
    local weapon = WeaponsTable[item.name]
    if not weapon then
        outputDebugString("givePlayerWeapon: invalid weapon")
        return false
    end
    -- Попытка положить в неподходящий слот
    if not isWeaponSlotMatching(weapon, slot) then
        return false
    end
    if not item.clip then
        item.clip = 0
    end
    playerWeaponSlots[player][slot] = item
    triggerClientEvent(player, "onClientWeaponSlotUpdate", resourceRoot, slot, playerWeaponSlots[player][slot])
end

function removePlayerWeaponSlot(player, slot)
    if not isElement(player) or not slot then
        return false
    end
    if not playerWeaponSlots[player] or not playerWeaponSlots[player][slot] then
        return
    end
    local item = playerWeaponSlots[player][slot]
    playerWeaponSlots[player][slot] = nil
    return item
end

function getPlayerWeaponSlot(player, slot)
    if not isElement(player) or not slot then
        return false
    end
    if not playerWeaponSlots[player] or not playerWeaponSlots[player][slot] then
        return
    end
    return playerWeaponSlots[player][slot]
end

-----------------------
-- Обработка событий --
-----------------------

addEventHandler("onPlayerJoin", root, function ()
    playerWeaponSlots[source] = {}
end)

addEventHandler("onPlayerQuit", root, function ()
    playerWeaponSlots[source] = nil
end)

addEventHandler("onResourceStart", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        takeAllWeapons(player)
        player:setData("weaponSlot", false)
        playerWeaponSlots[player] = {}
    end
end)

addCommandHandler("weapon", function (player, cmd, slot, name)
    setPlayerWeaponSlot(player, slot, {name=name,clip=30})
end)

setTimer(function ()
    setPlayerWeaponSlot(getRandomPlayer(), "primary1", {name="weapon_akm",clip=30})

    setPlayerWeaponSlot(getRandomPlayer(), "secondary", {name="weapon_pistol",clip=15})
end, 150, 1)
