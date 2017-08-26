local playerWeapons = {}
local PRIMARY_SLOTS_COUNT = 2

local wearableSlots = {
    primary1 = true,
    primary2 = true,
    secondary = true,
}

local weaponModels = {
    [1] = 331,
    [2] = 333,
    [3] = 334,
    [4] = 335,
    [5] = 336,
    [6] = 337,
    [7] = 338,
    [8] = 339,
    [9] = 341,
    [22] = 346,
    [23] = 347,
    [24] = 348,
    [25] = 349,
    [26] = 350,
    [27] = 351,
    [28] = 352,
    [29] = 353,
    [32] = 372,
    [30] = 355,
    [31] = 356,
    [33] = 357,
    [34] = 358,
    [35] = 359,
    [36] = 360,
    [37] = 361,
    [38] = 362,
    [16] = 342,
    [17] = 343,
    [18] = 344,
    [39] = 363,
    [41] = 365,
    [42] = 366,
    [43] = 367,
    [10] = 321,
    [11] = 322,
    [12] = 323,
    [14] = 325,
    [15] = 326,
    [44] = 368,
    [45] = 369,
    [46] = 371,
    [40] = 364
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
        savePlayerCurrentWeapon(player)
        spawnPlayerLootItem(player, playerWeapons[player][slot])
        playerWeapons[player][slot] = nil

        hidePlayerWeapon(player)
        updatePlayerWeapons(player)
    end
end

function takePlayerWeapon(player, slot)
    if not isElement(player) or not playerWeapons[player] or type(slot) ~= "string" then
        return
    end
    if playerWeapons[player][slot] then
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
        if Items[item.name].category == "weapon_grenade" then
            local count = getPedTotalAmmo(player, weaponSlot)
            item.count = count
            if item.count <= 0 then
                takePlayerWeapon(player, slot)
            end
        else
            item.clip = math.max(0, getPedAmmoInClip(player, weaponSlot))
            local ammo = getPedTotalAmmo(player, weaponSlot) - item.clip
            setPlayerBackpackItemCount(
                player,
                getWeaponAmmoName(item),
                ammo
            )
            updatePlayerWeapons(player)
        end
    end
end

function updatePlayerWeaponAmmo(player)
    if not isElement(player) then
        return
    end
    local slot = player:getData("activeWeaponSlot")
    if type(slot) ~= "string" then
        return
    end
    takeAllWeapons(player)
    local item = playerWeapons[player][slot]
    if isItem(item) then
        local weaponId = Items[item.name].weaponId
        local clip = 0
        local ammo = 0
        if Items[item.name].category == "weapon_grenade" then
            ammo = item.count
            clip = ammo
        else
            clip = item.clip
            ammo = getPlayerBackpackItemCount(player, getWeaponAmmoName(item)) + (clip or 0)

            if not clip then
                clip = ammo
            end
        end
        if ammo + clip == 0 then
            hidePlayerWeapon(player)
        else
            giveWeapon(player, weaponId, 0, true)
            setWeaponAmmo(player, weaponId, ammo, clip)
        end
    else
        hidePlayerWeapon(player)
    end
end

addEvent("onPlayerBackpackUpdate", false)
addEventHandler("onPlayerBackpackUpdate", root, function ()
    updatePlayerWeaponAmmo(source)
end)

function showPlayerWeaponSlot(player, slot)
    if not isElement(player) or not slot then
        return
    end
    if isPlayerReloading(player) then
        return
    end
    savePlayerCurrentWeapon(player)
    takeAllWeapons(player)
    player:setData("activeWeaponSlot", slot, false)
    updatePlayerWeaponAmmo(player)
    -- local item = playerWeapons[player][slot]
    -- if isItem(item) then
    --     local weaponId = Items[item.name].weaponId
    --     local clip = 0
    --     local ammo = 0
    --     if Items[item.name].category == "weapon_grenade" then
    --         ammo = item.count
    --         clip = ammo
    --     else
    --         clip = item.clip
    --         ammo = getPlayerBackpackItemCount(player, getWeaponAmmoName(item)) + (clip or 0)

    --         if not clip then
    --             clip = ammo
    --         end
    --     end
    --     if ammo + clip == 0 then
    --         hidePlayerWeapon(player)
    --     else

    --         setWeaponAmmo(player, weaponId, ammo, clip)

    --     end
    -- else
    --     hidePlayerWeapon(player)
    -- end
    updateWearableWeapons(player)
end

addEvent("showPlayerWeaponSlot", true)
addEventHandler("showPlayerWeaponSlot", resourceRoot, function (slot)
    showPlayerWeaponSlot(client, slot)
end)

function hidePlayerWeapon(player)
    savePlayerCurrentWeapon(player)
    player:setData("activeWeaponSlot", false, false)
    takeAllWeapons(player)
    updateWearableWeapons(player)
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
