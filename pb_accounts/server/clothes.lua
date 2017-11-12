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
end)

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
    takePlayerInventoryItemCount(client, itemName, 1)
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
    outputDebugString("Buy " .. tostring(item.name) .. " for " .. tostring(itemClass.price))
    addPlayerInventoryItem(client, item, true)
    client:setData("clothes_"..itemClass.layer, itemClass.clothes)
    giveMissingPlayerClothes(client)
    savePlayerAccount(client)
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
