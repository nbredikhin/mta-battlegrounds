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

local function savePlayerCurrentWeapon(player)
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
        local weaponId =  Items[item.name].weaponId
        giveWeapon(player, weaponId, 0, true)
        local totalAmmo = item.ammo + item.clip
        setWeaponAmmo(player, weaponId, totalAmmo, item.clip)
        player:setData("activeWeaponSlot", slot, false)
    end
end

addEvent("showPlayerWeaponSlot", true)
addEventHandler("showPlayerWeaponSlot", resourceRoot, function (slot)
    showPlayerWeaponSlot(client, slot)
end)

addEvent("hidePlayerWeapon", true)
addEventHandler("hidePlayerWeapon", resourceRoot, function ()
    savePlayerCurrentWeapon(client)
    client:setData("activeWeaponSlot", false, false)
    takeAllWeapons(client)
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

setTimer(function ()
    local player = getRandomPlayer()

    local weapon = createItem("weapon_m4")
    weapon.ammo = 10
    weapon.clip = 0
    addPlayerWeapon(player, weapon)

    local weapon = createItem("weapon_ak47")
    weapon.ammo = 300
    addPlayerWeapon(player, weapon)

    local weapon = createItem("weapon_bat")
    addPlayerWeapon(player, weapon)

    local weapon = createItem("weapon_colt45")
    weapon.ammo = 5
    addPlayerWeapon(player, weapon)

    local weapon = createItem("weapon_grenade")
    weapon.ammo = 0
    weapon.clip = 1
    addPlayerWeapon(player, weapon)
end, 500, 1)
