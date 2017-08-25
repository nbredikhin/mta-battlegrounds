addEvent("finishPlayerHeal", true)
addEventHandler("finishPlayerHeal", resourceRoot, function (itemName)
    local player = client
    local item = getPlayerBackpackItem(player, itemName)
    if not isItem(item) then
        return
    end
    local itemClass = Items[item.name]
    takePlayerBackpackItem(player, item.name, 1)
    player.health = player.health + itemClass.heal
    if itemClass.heal_max and math.ceil(player.health) > itemClass.heal_max then
        player.health = itemClass.heal_max
    end
end)
