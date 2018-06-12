------------------------------------------
-- Отображение оружия в руках персонажа --
------------------------------------------

-- id скилла для оружия
local weaponSkillId = {
    [22] = 69,
    [23] = 70,
    [24] = 71,
    [25] = 72,
    [26] = 73,
    [27] = 74,
    [28] = 75,
    [29] = 76,
    [30] = 77,
    [31] = 78,
    [34] = 79,
}

-----------------------
-- Локальные функции --
-----------------------

------------------------
-- Глобальные функции --
------------------------

-- Взять оружие в руки
function equipPlayerWeaponSlot(player, slot)
    if not isElement(player) then
        return
    end
    if slot == nil then
        slot = false
    end
    -- Убрать текущее оружие из рук
    takeAllWeapons(player)
    player:setData("weaponSlot", false)
    if not isValidWeaponSlot(slot) then
        triggerClientEvent(player, "onClientWeaponSwitch", resourceRoot, false)
        return
    end

    local item = getPlayerWeaponSlot(player, slot)
    if not item then
        return
    end
    local weapon = WeaponsTable[item.name]

    -- Выдача оружия в руки
    local weaponId = weapon.baseWeapon
    giveWeapon(player, weaponId, 999, true)
    setWeaponAmmo(player, weaponId, 999, 999)

    -- Установка навыка влаления оружием
    if weaponSkillId[weaponId] then
        local weaponStat = (weapon.propsGroup or 1) * 500 - 500
        setPedStat(player, weaponSkillId[weaponId], weaponStat)
    end

    player:setData("weaponSlot", slot)
    triggerClientEvent(player, "onClientWeaponSwitch", resourceRoot, slot)
end

-----------------------
-- Обработка событий --
-----------------------

-- Выбор слота игроком
addEvent("onPlayerEquipWeaponSlot", true)
addEventHandler("onPlayerEquipWeaponSlot", resourceRoot, function (slot)
    equipPlayerWeaponSlot(client, slot)
end)

-- Обработка перезарядки
addEvent("onPlayerWeaponReload", true)
addEventHandler("onPlayerWeaponReload", resourceRoot, function (state, currentSlot, currentClip)
    -- Клиент запрашивает начало перезарядки
    if state == "start" then
        reloadPedWeapon(client)
    -- Клиент завершил анимацию перезарядки и ожидает получения количества патронов после перезарядки
    elseif state == "finish" then
        setWeaponAmmo(client, client:getWeapon(), 999, 999)

        local clip = 30
        triggerClientEvent(client, "onClientWeaponReloadFinish", resourceRoot, currentSlot, clip)
    end
end)

addEvent("onPlayerWeaponSlotSave", true)
addEventHandler("onPlayerWeaponSlotSave", resourceRoot, function (slot, clip)
    if not slot or not clip then
        return
    end
    local item = getPlayerWeaponSlot(client, slot)
    if not item then
        return
    end
    item.clip = clip

    if slot == "grenade" and clip == 0 then
        removePlayerWeaponSlot(client, slot)
    end
end)
