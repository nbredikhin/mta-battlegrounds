local savePlayersQueue = {}

addEvent("onPlayerSelectClothes", true)
addEventHandler("onPlayerSelectClothes", root, function (itemName)
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
    client:setData("clothes_" .. itemClass.layer, itemClass.clothes)

    savePlayersQueue[client] = true
end)

setTimer(function ()
    for player in pairs(savePlayersQueue) do
        savePlayerAccountData(player)
    end
end, 3000, 0)

addEvent("onPlayerSellClothes", true)
addEventHandler("onPlayerSellClothes", root, function (itemName)
    local inventory = getPlayerInventory(client)
    if not isInventory(inventory) then
        return
    end
    local item = getPlayerInventoryItem(client, itemName)
    if not isItem(item) then
        return
    end
    local itemClass = getItemClass(item)

    if item.count == 1 and getDefaultClothes(itemClass.layer) == itemClass.clothes then
        return
    end

    if item.count == 1 and client:getData("clothes_"..itemClass.layer) == itemClass.clothes then
        client:setData("clothes_"..itemClass.layer, false)
        giveMissingPlayerClothes(client)
    end
    takePlayerInventoryItemCount(client, itemName, 1, true)

    local sellPrice = calculateClothesSellPrice(itemClass.price)
    local bPoints = client:getData("battlepoints") or 0
    bPoints = bPoints + sellPrice
    client:setData("battlepoints", bPoints)

    savePlayerAccount(client)
    outputDebugString("[ACCOUNTS] Player " .. tostring(client.name) .. "(acc "..tostring(client:getData("username"))..",money "..tostring(bPoints)..") sell " .. tostring(itemName) .. " for " .. tostring(sellPrice))
end)

addEvent("onPlayerBuyClothes", true)
addEventHandler("onPlayerBuyClothes", root, function (itemName)
    local inventory = getPlayerInventory(client)
    if not isInventory(inventory) then
        return
    end
    local item = createItem(itemName)
    if not isItem(item) then
        return
    end
    local itemClass = getItemClass(item)
    local bPoints = client:getData("battlepoints") or 0
    if not itemClass.price or bPoints < itemClass.price then
        return
    end
    bPoints = bPoints - itemClass.price
    client:setData("battlepoints", bPoints)
    addPlayerInventoryItem(client, item, true)
    client:setData("clothes_"..itemClass.layer, itemClass.clothes)
    giveMissingPlayerClothes(client)
    savePlayerAccount(client)

    outputDebugString("[ACCOUNTS] Player " .. tostring(client.name) .. "(acc "..tostring(client:getData("username"))..",money "..tostring(bPoints)..") buy " .. tostring(item.name) .. " for " .. tostring(itemClass.price))
end)

-- Выдает одежду по умолчанию на те слои, которые не имеют одежды
function giveMissingPlayerClothes(player)
    for layer, defaultClothesName in pairs(DefaultClothes) do
        local clothesName = player:getData("clothes_"..layer)
        if not clothesName or not isItem(getPlayerInventoryItem(player, "clothes_"..clothesName)) then
            player:setData("clothes_"..layer, defaultClothesName)
        end
    end
end
