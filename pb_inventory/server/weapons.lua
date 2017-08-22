local playerWeapons = {}
local PRIMARY_SLOTS_COUNT = 2

function initPlayerWeapons(player)
    if not isElement(player) then
        return
    end

    playerWeapons[player] = {
        primary1  = nil,
        primary2  = nil,
        secondary = nil,
        melee     = nil,
        grenade   = nil,
    }

    updatePlayerWeapons(player, true)
end

function addPlayerWeapon(player, item, primarySlot)
    if not isElement(player) or not playerWeapons[player] or not isItem(item) then
        return
    end
    local itemClass = Items[item.name]
    if itemClass.category == "weapon_primary" then
        primarySlot = tonumber(primarySlot)
        if primarySlot and primarySlot >= 1 and primarySlot <= PRIMARY_SLOTS_COUNT then
            local slot = "primary" .. tostring(primarySlot)
            dropPlayerWeapon(player, slot)
            playerWeapons[player][slot] = item
            return
        else
            local freeSlot
            for i = 1, PRIMARY_SLOTS_COUNT do
                if not playerWeapons[player]["primary"..i] then
                    freeSlot = "primary" .. i
                    break
                end
            end
            if freeSlot then
                playerWeapons[player][freeSlot] = item
            else
                dropPlayerWeapon(player, "primary2")
                playerWeapons[player]["primary2"] = item
            end
        end
    elseif itemClass.category == "weapon_secondary" then
        dropPlayerWeapon(player, "secondary")
        playerWeapons[player]["secondary"] = item
    elseif itemClass.category == "weapon_melee" then
        dropPlayerWeapon(player, "melee")
        playerWeapons[player]["melee"] = item
    elseif itemClass.category == "weapon_grenade" then
        -- TODO: Move to backpack
        playerWeapons[player]["grenade"] = item
    end

    updatePlayerWeapons(player)
end

function dropPlayerWeapon(player, slot)
    if not isElement(player) or not playerWeapons[player] or type(slot) ~= "string" then
        return
    end
    if playerWeapons[player][slot] then
        spawnPlayerLootItem(player, playerWeapons[player][slot])
        playerWeapons[player][slot] = nil

        updatePlayerWeapons(player)
    end
end

addEventHandler("onPlayerJoin", resourceRoot, function ()
    initPlayerWeapons(source)
end)

addEventHandler("onPlayerQuit", resourceRoot, function ()
    playerWeapons[source] = nil
end)

addEventHandler("onResourceStart", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        initPlayerWeapons(player)
        local weapon = createItem("weapon_m4")
        weapon.ammo = 0
        addPlayerWeapon(player, weapon)

        local weapon = createItem("weapon_m4")
        weapon.ammo = 1
        addPlayerWeapon(player, weapon)

        local weapon = createItem("weapon_bat")
        addPlayerWeapon(player, weapon)
    end
end)

addEvent("requireClientWeapons", true)
addEventHandler("requireClientWeapons", resourceRoot, function ()
    updatePlayerWeapons(client)
end)

function updatePlayerWeapons(player, omitEvent)
    if not isElement(player) or not playerWeapons[player] then
        return
    end

    if not omitEvent then
        triggerClientEvent(player, "onClientWeaponsUpdate", resourceRoot, playerWeapons[player])
    end
end

function showPlayerWeaponSlot(player, slot)
    if not isElement(player) or not slot then
        return
    end
    takeAllWeapons(player)
    local item = playerWeapons[player][slot]
    if item then
        local ammo = item.ammo
        if item.ammo == 0 then
            ammo = 1
        end
        giveWeapon(player, Items[item.name].weaponId, ammo, true)
    end
end

addEvent("showPlayerWeaponSlot", true)
addEventHandler("showPlayerWeaponSlot", resourceRoot, function (slot)
    showPlayerWeaponSlot(client, slot)
end)

addEvent("hidePlayerWeapon", true)
addEventHandler("hidePlayerWeapon", resourceRoot, function ()
    takeAllWeapons(client)
end)

addEventHandler("onPlayerWeaponFire", root, function (weaponId)
    local slot = source:getData("activeSlot")
    if type(slot) ~= "string" then
        return
    end
    local item = playerWeapons[source][slot]
    if Items[item.name].category == "weapon_melee" then
        return
    end
    local weaponSlot = getSlotFromWeapon(weaponId)
    item.ammo = getPedTotalAmmo(source, weaponSlot) - 1
    iprint("fire", slot, item.ammo)
    if item.ammo <= 0 then
        item.ammo = 0
        updatePlayerWeapons(source)
    end
end)
