local playerWeapons = {}
local PRIMARY_SLOTS_COUNT = 2

local wearableSlots = {
    primary1 = true,
    primary2 = true,
    secondary = true,
    melee = true,
    grenade = true,
}

function initPlayerWeapons(player)
    if not isElement(player) then
        return
    end

    takeAllWeapons(player)

    player:setData("isReloadingWeapon", false, false)
    player:removeData("activeWeaponSlot")

    for slot in pairs(wearableSlots) do
        player:removeData("wear_"..tostring(slot))
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

function getPlayerWeapons(player)
    if not player then
        return
    end
    return playerWeapons[player]
end

function clearPlayerWeapons(player)
    if not isElement(player) then
        return
    end
    initPlayerWeapons(player)
    updatePlayerWeapons(player)
end

function getWeaponAmmoName(item)
    if not isItem(item) then
        return
    end
    return Items[item.name].ammo
end

function updateWearableWeapons(player)
    if not isElement(player) then
        return
    end
    local activeSlot = player:getData("activeWeaponSlot")
    for slot in pairs(wearableSlots) do
        local item = playerWeapons[player][slot]
        if item and slot ~= activeSlot then
            player:setData("wear_"..tostring(slot), weaponModels[Items[item.name].weaponId])
        else
            player:removeData("wear_"..tostring(slot))
        end
    end
    triggerClientEvent("updateWearableItems", resourceRoot, player)
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
            updatePlayerWeapons(player)
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
        local currentItem = playerWeapons[player]["grenade"]
        if currentItem and currentItem.name == item.name then
            item.count = item.count + currentItem.count
            playerWeapons[player]["grenade"] = item
        else
            putPlayerWeaponToBackpack(player, "grenade")
            playerWeapons[player]["grenade"] = item
        end
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

        if player:getData("activeWeaponSlot") == slot then
            setPlayerActiveWeaponSlot(player)
        end
        updatePlayerWeapons(player)
    end
end

function takePlayerWeapon(player, slot)
    if not isElement(player) or not playerWeapons[player] or type(slot) ~= "string" then
        return
    end
    if playerWeapons[player][slot] then
        playerWeapons[player][slot] = nil
        if player:getData("activeWeaponSlot") == slot then
            setPlayerActiveWeaponSlot(player)
        end
        updatePlayerWeapons(player)
    end
end

addEvent("dropPlayerWeapon", true)
addEventHandler("dropPlayerWeapon", resourceRoot, function (slot)
    dropPlayerWeapon(client, slot)
end)

addEvent("switchPrimaryWeapons", true)
addEventHandler("switchPrimaryWeapons", resourceRoot, function ()
    local player = client
    if not isElement(player) or not playerWeapons[player] then
        return
    end
    local primary1 = playerWeapons[player]["primary1"]
    playerWeapons[player]["primary1"] = playerWeapons[player]["primary2"]
    playerWeapons[player]["primary2"] = primary1
    updatePlayerWeapons(player)
end)

function getPlayerWeaponSlot(player, slot)
    if not player or not slot or not playerWeapons[player] then
        return false
    end
    return playerWeapons[player][slot]
end

function putPlayerWeaponToBackpack(player, slot)
    if not isElement(player) or not playerWeapons[player] or type(slot) ~= "string" then
        return
    end
    if slot ~= "grenade" then
        return
    end
    local item = playerWeapons[player][slot]
    if not isItem(item) then
        return
    end
    takePlayerWeapon(player, slot)
    addBackpackItem(player, item)
end

addEvent("putWeaponToBackpack", true)
addEventHandler("putWeaponToBackpack", resourceRoot, function (slot)
    putPlayerWeaponToBackpack(client, slot)
end)

addEvent("putBackpackItemToWeapon", true)
addEventHandler("putBackpackItemToWeapon", resourceRoot, function (name, slot)
    local player = client
    if not isElement(player) or not playerWeapons[player] or type(slot) ~= "string" then
        return
    end
    if slot ~= "grenade" then
        return
    end
    local item = getPlayerBackpackItem(player, name)
    if not isItem(item) then
        return
    end
    removePlayerBackpackItem(player, item.name)
    addPlayerWeapon(player, item)
end)

addEventHandler("onPlayerJoin", root, function ()
    initPlayerWeapons(source)
end)

addEventHandler("onPlayerQuit", root, function ()
    playerWeapons[source] = nil
end)

addEventHandler("onResourceStart", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        initPlayerWeapons(player)
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

    updateWearableWeapons(player)
end
