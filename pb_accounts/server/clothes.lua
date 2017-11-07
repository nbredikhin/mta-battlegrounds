addEvent("onPlayerSelectClothes", true)
addEventHandler("onPlayerSelectClothes", root, function (itemIndex)
    if not itemIndex then
        return
    end
    local inventory = getPlayerInventory(client)
    if not isInventory(inventory) then
        return
    end
    local item = inventory[itemIndex]
    if not isItem(item) then
        return
    end
    local itemClass = getItemClass(item)
    client:setData("clothes_" .. itemClass.layer, itemClass.clothes)
end)

addEvent("onPlayerSellClothes", true)
addEventHandler("onPlayerSellClothes", root, function (itemIndex)
    if not itemIndex then
        return
    end
    local inventory = getPlayerInventory(client)
    if not isInventory(inventory) then
        return
    end
    local item = inventory[itemIndex]
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
    takePlayerInventoryItemCount(client, item.name, 1)
end)

function giveMissingPlayerClothes(player)
    for layer, name in pairs(DefaultClothes) do
        if not player:getData("clothes_"..layer) then
            player:setData("clothes_"..layer, name)
        end
    end
end
