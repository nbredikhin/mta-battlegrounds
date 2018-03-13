-- Взять оружие в руки
function equipPlayerWeapon(player, name)
    if not isElement(player) then
        return
    end
    if not WeaponsTable[name] then
        return
    end

    unequipPlayerWeapon(player)

    local weaponId = WeaponsTable[name].baseWeapon
    giveWeapon(player, weaponId, 999, true)
    if Config.skillFromWeapon[weaponId] then
        local weaponStat = (WeaponsTable[name].propsGroup or 1) * 500 - 500
        setPedStat(player, Config.skillFromWeapon[weaponId], weaponStat)
    end
end

-- Убрать оружие из рук
function unequipPlayerWeapon(player)
    if not isElement(player) then
        return
    end

    takeAllWeapons(player)
end

addEventHandler("onPlayerWeaponFire", root, function (weaponId)
    setWeaponAmmo(source, weaponId, 999, 999)
end)

addCommandHandler("weapon", function (player, cmd, name)
    equipPlayerWeapon(player, name)
end)
