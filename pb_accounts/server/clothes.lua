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

addEvent("onPlayerUnequipClothes", true)
addEventHandler("onPlayerUnequipClothes", root, function (layer)
    if not layer then
        return
    end
    client:removeData("clothes_"..layer)
end)

setTimer(function ()
    for player in pairs(savePlayersQueue) do
        savePlayerAccountData(player)
    end
    savePlayersQueue = {}
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
    local dPonts = client:getData("donatepoints") or 0
    if not itemClass.price or dPonts < itemClass.price then
        return
    end
    dPonts = dPonts - itemClass.price
    client:setData("donatepoints", dPonts)
    addPlayerInventoryItem(client, item, true)
    client:setData("clothes_"..itemClass.layer, itemClass.clothes)
    savePlayerAccount(client)

    outputDebugString("[ACCOUNTS] Player " .. tostring(client.name) .. "(acc "..tostring(client:getData("username"))..",donatepoints "..tostring(dPoints)..") buy " .. tostring(item.name) .. " for " .. tostring(itemClass.price))
end)

addEvent("onPlayerBuyAppearance", true)
addEventHandler("onPlayerBuyAppearance", root, function ()
    local price = 500
    if not client:getData("username") then
        return
    end

    local bPoints = client:getData("battlepoints")
    if type(bPoints) ~= "number" then
        return
    end
    if bPoints < price then
        return
    end

    client:setData("clothes_head", "head"..math.random(1, 2))
    if client:getData("clothes_head") == "head1" then
        client:setData("clothes_hair", "hair"..math.random(2, 8))
    else
        client:setData("clothes_hair", "hair"..math.random(1, 8))
    end

    bPoints = bPoints - price
    client:setData("battlepoints", bPoints)
end)
