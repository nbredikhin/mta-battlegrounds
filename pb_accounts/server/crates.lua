addEvent("onPlayerOpenCrate", true)
addEventHandler("onPlayerOpenCrate", root, function (itemName)
    if not itemName then
        return
    end
    local inventory = getPlayerInventory(client)
    if not isInventory(inventory) then
        return
    end
    local item = getPlayerInventoryItem(client, itemName)
    if not isItem(item) then
        return
    end
    local itemClass = getItemClass(item)
    if not itemClass.crateItems then
        return
    end
    takePlayerInventoryItemCount(client, itemName, 1, true)

    math.randomseed(getTickCount())
    local chance = math.random()
    local chanceIndex = 1
    for i, c in ipairs(itemClass.crateChances) do
        if chance < c[1] then
            chanceIndex = i
        end
    end
    local itemIndex = itemClass.crateChances[chanceIndex][2]
    if itemClass.crateChances[chanceIndex][2] ~= itemClass.crateChances[chanceIndex][3] then
        itemIndex = math.random(itemClass.crateChances[chanceIndex][2], itemClass.crateChances[chanceIndex][3])
    end
    -- TODO: Вероятности
    local newItemName = itemClass.crateItems[itemIndex]
    local newItem = createItem(newItemName)
    addPlayerInventoryItem(client, newItem, true)
    triggerClientEvent(client, "onClientCrateOpened", resourceRoot, newItem.name)
    savePlayerAccount(client)
    outputDebugString("[ACCOUNTS] Player " .. tostring(client.name) .. "(acc "..tostring(client:getData("username"))..") opened crate " .. tostring(item.name) .. " and got " .. tostring(newItem.name))
end)

addEvent("onPlayerBuyNextCrate", true)
addEventHandler("onPlayerBuyNextCrate", root, function ()
    local crateLevel = tonumber(client:getData("crate_level"))
    if not crateLevel then
        crateLevel = 1
    end

    local price = getRewardPrice(crateLevel)
    if not price then
        return
    end
    local bPoints = client:getData("battlepoints") or 0
    if bPoints < price then
        return
    end
    local item = createItem(Config.rewardCrates[math.random(1, #Config.rewardCrates)])
    if not isItem(item) then
        return
    end
    if addPlayerInventoryItem(client, item) then
        bPoints = bPoints - price
        client:setData("battlepoints", bPoints)
        triggerClientEvent("onClientCrateReceived", resourceRoot, item.name)
        client:setData("crate_level", math.min(#Config.rewardPrices, crateLevel + 1))
        outputDebugString("[ACCOUNTS] Player " .. tostring(client.name) .. "(acc "..tostring(client:getData("username"))..",money "..tostring(bPoints)..") buy crate " .. tostring(item.name) .. " for " .. tostring(price))
    else
        outputDebugString("[ACCOUNTS] Error adding crate to " .. tostring(client.name) .. "(acc "..tostring(client:getData("username"))..",money "..tostring(bPoints)..") " .. tostring(item.name) .. " for " .. tostring(price))
    end
end)
