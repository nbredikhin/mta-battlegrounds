setTimer(function ()
    local player = getElementsByType("player")[1]

    -- Оружие
    local weapon = createItem("weapon_m4")
    weapon.clip = 10
    addPlayerWeapon(player, weapon)

    -- local weapon = createItem("weapon_ak47")
    -- addPlayerWeapon(player, weapon)

    local weapon = createItem("weapon_crowbar")
    addPlayerWeapon(player, weapon)

    local weapon = createItem("weapon_colt45")
    weapon.clip = 5
    addPlayerWeapon(player, weapon)

    local weapon = createItem("weapon_shotgun")
    weapon.clip = 5
    addPlayerWeapon(player, weapon)

    local weapon = createItem("weapon_grenade", 5)
    addPlayerWeapon(player, weapon)


    -- Снаряжение
    addPlayerEquipment(player, createItem("backpack_large"))
    addPlayerEquipment(player, createItem("helmet3"))

    -- Вещи
    local item = createItem("bandage", 5)
    addBackpackItem(player, item)

    addBackpackItem(player, createItem("ammo_556mm", 30))
    addBackpackItem(player, createItem("ammo_12gauge", 30))

    -- Лут
    -- spawnPlayerLootBox(player)
    -- setTimer(spawnPlayerLootBox, 500, 1, player)
end, 500, 1)
