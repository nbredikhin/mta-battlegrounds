local playerWeapons = {}
local PRIMARY_SLOTS_COUNT = 2

function initPlayerWeapons(player)
    if not isElement(player) then
        return
    end

    takeAllWeapons(player)

    player:setData("isReloadingWeapon", false, false)
    player:removeData("activeWeaponSlot")

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
        savePlayerCurrentWeapon(player)
        spawnPlayerLootItem(player, playerWeapons[player][slot])
        playerWeapons[player][slot] = nil

        hidePlayerWeapon(player)
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
end

function isPlayerReloading(player)
    return not not player:getData("isReloadingWeapon")
end

function savePlayerCurrentWeapon(player)
    if not isElement(player) then
        return
    end
    local slot = player:getData("activeWeaponSlot")
    if type(slot) ~= "string" then
        return
    end
    local item = playerWeapons[player][slot]
    if isItem(item) then
        local weaponId = Items[item.name].weaponId
        local weaponSlot = getSlotFromWeapon(weaponId)
        item.clip = math.max(0, getPedAmmoInClip(player, weaponSlot))
        item.ammo = getPedTotalAmmo(player, weaponSlot) - item.clip
        updatePlayerWeapons(player)
    end
end

function showPlayerWeaponSlot(player, slot)
    if not isElement(player) or not slot then
        return
    end
    if isPlayerReloading(player) then
        return
    end
    savePlayerCurrentWeapon(player)
    takeAllWeapons(player)
    local item = playerWeapons[player][slot]
    if isItem(item) then
        local weaponId = Items[item.name].weaponId
        giveWeapon(player, weaponId, 0, true)
        local totalAmmo = item.ammo + item.clip
        setWeaponAmmo(player, weaponId, totalAmmo, item.clip)
        player:setData("activeWeaponSlot", slot, false)
    else
        hidePlayerWeapon(player)
    end
end

addEvent("showPlayerWeaponSlot", true)
addEventHandler("showPlayerWeaponSlot", resourceRoot, function (slot)
    showPlayerWeaponSlot(client, slot)
end)

function hidePlayerWeapon(player)
    savePlayerCurrentWeapon(player)
    player:setData("activeWeaponSlot", false, false)
    takeAllWeapons(player)
end

addEvent("hidePlayerWeapon", true)
addEventHandler("hidePlayerWeapon", resourceRoot, function ()
    hidePlayerWeapon(client)
end)

addEvent("reloadPlayerWeapon", true)
addEventHandler("reloadPlayerWeapon", resourceRoot, function ()
    local player = client
    local slot = player:getData("activeWeaponSlot")
    if type(slot) ~= "string" then
        return
    end
    if isPlayerReloading(player) then
        return
    end
    player:setData("isReloadingWeapon", true, false)
    player:reloadWeapon()

    setTimer(function ()
        if not isElement(player) then return end
        player:setData("isReloadingWeapon", false, false)
        savePlayerCurrentWeapon(player)
    end, 1800, 1)
end)

addEventHandler("onPlayerWeaponFire", root, function (weaponId)
    if source:getData("activeWeaponSlot") == "melee" then
        return
    end
    local weaponSlot = getSlotFromWeapon(weaponId)
    if getPedAmmoInClip(source, weaponSlot) == 1 then
        local player = source
        setTimer(savePlayerCurrentWeapon, 500, 1, player)
    end
end)

addCommandHandler("weapons", function ()
    outputConsole(inspect(playerWeapons[getRandomPlayer()]))
end)
