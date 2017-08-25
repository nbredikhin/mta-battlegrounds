setTimer(function ()
    local player = getRandomPlayer()

    -- Оружие
    local weapon = createItem("weapon_m4")
    weapon.ammo = 0--10
    weapon.clip = 10
    addPlayerWeapon(player, weapon)

    local weapon = createItem("weapon_ak47")
    weapon.ammo = 300
    addPlayerWeapon(player, weapon)

    local weapon = createItem("weapon_bat")
    addPlayerWeapon(player, weapon)

    local weapon = createItem("weapon_colt45")
    weapon.ammo = 5
    addPlayerWeapon(player, weapon)

    local weapon = createItem("weapon_grenade")
    weapon.ammo = 0
    weapon.clip = 1
    addPlayerWeapon(player, weapon)

    -- Снаряжение
    addPlayerEquipment(player, createItem("backpack_small"))

    -- Вещи
    local item = createItem("bandage", 5)
    addBackpackItem(player, item)

    -- Лут
    spawnPlayerLootItem(player, createItem("bandage", 1000))
    spawnPlayerLootItem(player, createItem("first_aid", 1))
end, 500, 1)
