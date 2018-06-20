local clientWeapons = {}

addEvent("onClientWeaponsUpdate", false)
addEventHandler("onClientWeaponsUpdate", root, function (weapons)
    clientWeapons = weapons or {}
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    if isResourceRunning("pb_weapons") then
        clientWeapons = exports.pb_weapons:getWeaponSlots()
    end
end)

function getWeaponAmmo(item)
    if not isItem(item) then
        return 0
    end
    local itemClass = Items[item.name]
    if itemClass.category == "weapon_primary" or itemClass.category == "weapon_secondary" then
        local ammo = getBackpackItem(itemClass.ammo)
        local count = 0
        if isItem(ammo) then
            count = ammo.count
        end
        return item.clip, count
    elseif itemClass.category == "weapon_grenade" then
        return item.count
    end
end

function getClientWeapons()
    return clientWeapons
end

function getWeaponSlot(slot)
    if not slot then
        return
    end
    return clientWeapons[slot]
end
