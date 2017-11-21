addEvent("finishPlayerHeal", true)
addEventHandler("finishPlayerHeal", resourceRoot, function (itemName)
    local player = client
    local item = getPlayerBackpackItem(player, itemName)
    if not isItem(item) then
        return
    end
    local itemClass = Items[item.name]
    takePlayerBackpackItem(player, item.name, 1)
    local prevHealth = player.health

    player.health = player.health + itemClass.heal
    if itemClass.heal_max and math.ceil(player.health) > itemClass.heal_max then
        player.health = itemClass.heal_max
    end

    local diffHealth = player.health - prevHealth
    local totalHealed = player:getData("hp_healed") or 0
    player:setData("hp_healed", math.floor(totalHealed + diffHealth))

    exports.pb_accounts:addPlayerStatsField(player, "stats_items_used", 1)
end)

addEvent("finishPlayerFillFuel", true)
addEventHandler("finishPlayerFillFuel", resourceRoot, function (itemName)
    if not isResourceRunning("pb_fuel") then
        return
    end
    local player = client
    if not player.vehicle then
        return
    end
    local item = getPlayerBackpackItem(player, itemName)
    if not isItem(item) then
        return
    end
    local itemClass = Items[item.name]
    takePlayerBackpackItem(player, item.name, 1)

    exports.pb_fuel:fillVehicleFuel(player.vehicle, itemClass.fuel_amount)

    exports.pb_accounts:addPlayerStatsField(player, "stats_items_used", 1)
end)

addEvent("finishPlayerBoost", true)
addEventHandler("finishPlayerBoost", resourceRoot, function (itemName)
    local player = client
    local item = getPlayerBackpackItem(player, itemName)
    if not isItem(item) then
        return
    end
    local itemClass = Items[item.name]
    takePlayerBackpackItem(player, item.name, 1)

    local boost = player:getData("boost") or 0
    player:setData("boost", math.min(100, boost + itemClass.boost))

    exports.pb_accounts:addPlayerStatsField(player, "stats_items_used", 1)
end)

addEvent("onPlayerStartReviving", true)
addEventHandler("onPlayerStartReviving", resourceRoot, function (targetPlayer)
    if not isElement(targetPlayer) then
        return
    end
    if getDistanceBetweenPoints3D(client.position, targetPlayer.position) > 2 then
        return
    end
    targetPlayer:setData("reviving", true)
    setTimer(function ()
        targetPlayer:setData("reviving", false)
    end, Config.reviveTime, 1)

    triggerClientEvent(targetPlayer, "onClientStartRevieving", resourceRoot)
    triggerClientEvent(client, "onClientStartRevieving", resourceRoot, targetPlayer)

    client:setAnimation("BOMBER", "BOM_Plant_Loop", -1, true, false, true)
end)

addEvent("onPlayerStopReviving", true)
addEventHandler("onPlayerStopReviving", resourceRoot, function (targetPlayer, isSuccess)
    if isElement(targetPlayer) then
        client:setAnimation()
        targetPlayer:setData("reviving", false)
        triggerClientEvent(targetPlayer, "onClientStopReviving", resourceRoot)

        if isSuccess then
            exports.pb_knockout:reviveKnockedPlayer(targetPlayer)
        end
    end
end)

addEventHandler("onResourceStart", resourceRoot, function ()
    for i, player in pairs(getElementsByType("player")) do
        player:setData("reviving", false)
    end
end)
