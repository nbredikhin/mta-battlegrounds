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
    -- TODO: Вероятности
    local newItemName = itemClass.crateItems[math.random(1, #itemClass.crateItems)]
    local newItem = createItem(newItemName)
    addPlayerInventoryItem(client, newItem, true)
    triggerClientEvent(client, "onClientCrateOpened", resourceRoot, newItem.name)

    outputDebugString("[ACCOUNTS] Player " .. tostring(client.name) .. "(acc "..tostring(client:getData("username"))..") opened crate " .. tostring(item.name) .. " and got " .. tostring(newItem.name))
end)
