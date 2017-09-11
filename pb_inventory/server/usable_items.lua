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
end)
