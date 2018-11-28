function isPlayerAdmin(thePlayer)
     local accName=getAccountName(getPlayerAccount(thePlayer))
     if isObjectInACLGroup("user." ..accName, aclGetGroup("Admin")) then
          return true
     end
end

setTimer(function ()
    local player = getElementsByType("player")[1]

    -- Оружие
    -- local weapon = createItem("weapon_m4")
    -- weapon.clip = 10
    -- addPlayerWeapon(player, weapon)

    -- local weapon = createItem("weapon_ak47")
    -- addPlayerWeapon(player, weapon)

    -- local weapon = createItem("weapon_crowbar")
    -- addPlayerWeapon(player, weapon)

    -- local weapon = createItem("weapon_awm")
    -- weapon.clip = 5
    -- addPlayerWeapon(player, weapon)

    -- local weapon = createItem("weapon_shotgun")
    -- weapon.clip = 5
    -- addPlayerWeapon(player, weapon)

    -- local weapon = createItem("weapon_molotov", 5)
    -- addPlayerWeapon(player, weapon)

    -- Снаряжение
    -- addPlayerEquipment(player, createItem("helmet2"))
    -- addPlayerEquipment(player, createItem("backpack1"))
    -- addPlayerEquipment(player, createItem("helmet3",1,{health=5}))

    -- Вещи
    -- local item = createItem("painkiller", 1)
    -- addBackpackItem(player, item)

    -- spawnPlayerLootItem(player, createItem("weapon_machete", 1))
    -- addBackpackItem(player, createItem("ammo_556mm", 999))
    -- addBackpackItem(player, createItem("ammo_762mm", 60))

    -- Лут
    -- spawnPlayerLootBox(player)
    -- setTimer(spawnPlayerLootBox, 500, 1, player)
end, 500, 1)

addCommandHandler("give", function (player, cmd, name, count)
    if not isPlayerAdmin(player) then
        return
    end
    spawnPlayerLootItem(player, createItem(name, tonumber(count) or 1))
end)
