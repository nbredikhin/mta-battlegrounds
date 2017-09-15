setTimer(function ()
    local player = getElementsByType("player")[1]

--     -- Оружие
    local weapon = createItem("weapon_m4")
    weapon.clip = 10
    addPlayerWeapon(player, weapon)

    local weapon = createItem("weapon_ak47")
    addPlayerWeapon(player, weapon)

    local weapon = createItem("weapon_crowbar")
    addPlayerWeapon(player, weapon)

    local weapon = createItem("weapon_colt45")
    weapon.clip = 5
    addPlayerWeapon(player, weapon)

    local weapon = createItem("weapon_grenade", 3)
    addPlayerWeapon(player, weapon)

    -- Снаряжение
    addPlayerEquipment(player, createItem("backpack_large"))
    addPlayerEquipment(player, createItem("helmet3"))

    -- Вещи
    local item = createItem("bandage", 5)
    addBackpackItem(player, item)

    addBackpackItem(player, createItem("ammo_562mm", 30))

    -- Лут
    spawnPlayerLootItem(player, createItem("bandage", 5))
    spawnPlayerLootItem(player, createItem("first_aid", 1))
    spawnPlayerLootItem(player, createItem("backpack_medium"))
    spawnPlayerLootItem(player, createItem("backpack_large"))

    spawnPlayerLootItem(player, createItem("helmet1"))
    spawnPlayerLootItem(player, createItem("helmet2"))
    spawnPlayerLootItem(player, createItem("helmet3"))
    spawnPlayerLootItem(player, createItem("weapon_grenade", 1))
end, 500, 1)
