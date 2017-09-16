function updatePlayerActiveWeapon(player)
    if not isElement(player) then
        return false
    end

    local slotName = player:getData("activeWeaponSlot")
    takeAllWeapons(player)
    if type(slotName) == "string" then
        local item = getPlayerWeaponSlot(player, slotName)
        if not isItem(item) then
            return
        end
        local itemClass = getItemClass(item.name)
        local weaponId = itemClass.weaponId
        if not weaponId then
            return
        end

        if itemClass.category == "weapon_grenade" then
            giveWeapon(player, weaponId, item.count, true)
        else
            giveWeapon(player, weaponId, 2, true)
        end
    end
end

function setPlayerActiveWeaponSlot(player, slotName)
    local item = getPlayerWeaponSlot(player, slotName)
    if not isItem(item) then
        slotName = nil
    end
    player:setData("activeWeaponSlot", slotName)
    updatePlayerActiveWeapon(player)
    updatePlayerWeapons(player)
    triggerClientEvent(player, "onClientSwitchWeaponSlot", resourceRoot)
end

function getPlayerActiveWeaponItem(player)
    local slotName = player:getData("activeWeaponSlot")
    if not slotName then
        return
    end
    return getPlayerWeaponSlot(player, slotName)
end

addEvent("onPlayerSwitchWeaponSlot", true)
addEventHandler("onPlayerSwitchWeaponSlot", resourceRoot, function (slotName)
    setPlayerActiveWeaponSlot(client, slotName)
end)

addEventHandler("onPlayerWeaponFire", root, function (weaponId)
    setWeaponAmmo(source, weaponId, 2, 2)
end)

addEvent("onPlayerReloadWeapon", true)
addEventHandler("onPlayerReloadWeapon", resourceRoot, function ()
    local player = client
    if player:getData("isReloadingWeapon") then
        return
    end

    player:setData("isReloadingWeapon", true)
    player:setAnimation("COLT45", "colt45_reload", -1, false)

    local item = getPlayerActiveWeaponItem(player)
    if isItem(item) then
        local itemClass = getItemClass(item.name)
        local ammo = getPlayerBackpackItemCount(player, itemClass.ammo)
        if ammo > 0 then
            local takeAmmo = math.min(ammo, itemClass.clip - item.clip)
            item.clip = item.clip + takeAmmo
            setPlayerBackpackItemCount(player, itemClass.ammo, ammo - takeAmmo)
        end
    end

    setTimer(function ()
        if isElement(player) then
            player:setAnimation()
            player:setData("isReloadingWeapon", false)
            updatePlayerWeapons(player)
            triggerClientEvent(player, "onClientReloadFinished", resourceRoot)
        end
    end, 1200, 1)
end)

addEvent("onPlayerSaveWeapon", true)
addEventHandler("onPlayerSaveWeapon", resourceRoot, function(slotName, clip)
    local player = client
    local item = getPlayerWeaponSlot(player, slotName)
    if not isItem(item) then
        return
    end
    local itemClass = getItemClass(item.name)
    local weaponId = itemClass.weaponId
    if not weaponId then
        return
    end
    if itemClass.category == "weapon_grenade" then
        local weaponSlot = getSlotFromWeapon(weaponId)
        local count = getPedTotalAmmo(player, weaponSlot)
        item.count = count
        if item.count <= 0 then
            takePlayerWeapon(player, slotName)
        end
    else
        item.clip = clip
    end
    updatePlayerWeapons(player)
end)
