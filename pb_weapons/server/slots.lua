local weaponSlots = {
    primary1  = true,
    primary2  = true,
    secondary = true,
    melee     = true,
    grenade   = true
}
local playerWeaponSlots = {}

addEventHandler("onPlayerJoin", root, function ()
    playerWeaponSlots[source] = {}
end)

addEventHandler("onPlayerQuit", root, function ()
    playerWeaponSlots[source] = nil
end)

addEventHandler("onResourceStart", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        playerWeaponSlots[player] = {}
    end
end)

function setPlayerSlotWeapon(player, slot, weapon, clip)
    if not isElement(player) or not slot or not weaponSlots[slot] then
        return
    end
    if weapon and not playerWeaponSlots[player] then
        return
    end

    if type(weapon) == "string" then
        if type(clip) ~= "number" then
            clip = 0
        end

        playerWeaponSlots[player][slot] = { weapon = weapon, clip = clip }
    else
        if slot == player:getData("weaponSlot") then
            unequipPlayerWeapon(player)
            player:setData("weaponSlot", false)
        end
        playerWeaponSlots[player][slot] = nil
    end
end

function equipPlayerSlot(player, slot)
    if not isElement(player) or not slot or not weaponSlots[slot] then
        return
    end
    if not playerWeaponSlots[player][slot] then
        return
    end
    player:setData("weaponSlot", slot)

    equipPlayerWeapon(player, playerWeaponSlots[player][slot].weapon, playerWeaponSlots[player][slot].clip)
end

addEvent("onPlayerEquipWeaponSlot", true)
addEventHandler("onPlayerEquipWeaponSlot", resourceRoot, function (slot)
    if slot then
        equipPlayerSlot(client, slot)
    else
        unequipPlayerWeapon(client)
        player:setData("weaponSlot", false)
    end
end)

addCommandHandler("weapon", function (player, cmd, slot, name)
    setPlayerSlotWeapon(player, slot, name, 30)
end)
