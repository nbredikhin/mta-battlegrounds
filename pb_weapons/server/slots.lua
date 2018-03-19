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

-- Помещает оружие в слот
function givePlayerWeapon(player, slot, item)
    if not isElement(player) or type(item) ~= "table" or not slot then
        return false
    end
    -- Несуществующий слот
    if not playerWeaponSlots[player] or not weaponSlots[slot] or playerWeaponSlots[player][slot] then
        return false
    end
    -- Несуществующее оружие
    local weapon = WeaponsTable[item.name]
    if not weapon then
        return false
    end
    local _slot = slot
    if _slot == "primary1" or _slot == "primary2" then
        _slot = "primary"
    end
    -- Попытка положить в неподходящий слот
    if weapon.slot ~= _slot then
        return
    end
    if not item.clip then
        item.clip = 0
    end
    playerWeaponSlots[player][slot] = item
    triggerClientEvent(player, "onClientWeaponSlotChange", resourceRoot, slot, playerWeaponSlots[player][slot])
end

function takePlayerWeapon(player, slot)
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

function equipPlayerWeaponSlot(player, slot)
    if not isElement(player) or not slot or not weaponSlots[slot] then
        return
    end
    if not playerWeaponSlots[player] or not playerWeaponSlots[player][slot] then
        return
    end
    player:setData("weaponSlot", slot)
    equipPlayerWeapon(player, playerWeaponSlots[player][slot].name, playerWeaponSlots[player][slot].clip)
end

addEvent("onPlayerEquipWeaponSlot", true)
addEventHandler("onPlayerEquipWeaponSlot", resourceRoot, function (slot)
    if slot then
        equipPlayerWeaponSlot(client, slot)
    else
        unequipPlayerWeapon(client)
        player:setData("weaponSlot", false)
    end
end)

addCommandHandler("weapon", function (player, cmd, slot, name)
    givePlayerWeapon(player, slot, {name=name,clip=30})
end)
