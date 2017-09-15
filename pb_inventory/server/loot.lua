local lootColors = {
    white  = 1575,
    orange = 1576,
    yellow = 1577,
    green  = 1578,
    blue   = 1579,
    red    = 1580,
}

function spawnLootItem(item, position, dimension)
    if not isItem(item) or not position then
        return
    end
    local color = "white"
    if isItemWeapon(item) then
        color = "red"
    elseif Items[item.name].category == "medicine" then
        color = "green"
    elseif Items[item.name].category == "ammo" then
        color = "blue"
    elseif Items[item.name].category == "backpack" then
        color = "orange"
    end
    local object = createObject(lootColors[color], position)
    object.rotation = Vector3(0, 0, math.random(360))
    object:setCollisionsEnabled(false)

    item.lootElement = object
    if dimension then
        object.dimension = dimension
    end
    object:setData("loot_item", item)

    return object
end

function spawnPlayerLootItem(player, item)
    if not isElement(player) or not item then
        return
    end
    local offsetX = math.random() * 0.4 - 0.2
    local offsetY = math.random() * 0.4 - 0.2
    local position = player.position - Vector3(offsetX, offsetY, 1)
    local color = "white"
    return spawnLootItem(item, position, player.dimension)
end

function spawnPlayerLootBox(player)
    if not isElement(player) then
        return
    end
    local items = {}
    -- Взять все вещи из рюкзака
    local backpack = getPlayerBackpack(player)
    if backpack then
        for name, item in pairs(backpack) do
            table.insert(items, item)
        end
    end
    -- Взять все снаряжение
    local equipment = getPlayerEquipment(player)
    if equipment then
        for name, item in pairs(equipment) do
            table.insert(items, item)
        end
    end
    -- Взять все оружие
    local weapons = getPlayerWeapons(player)
    if weapons then
        for name, item in pairs(weapons) do
            table.insert(items, item)
        end
    end

    if #items == 0 then
        takeAllItems(player)
        return
    end

    local object = createObject(2358, player.position - Vector3(0, 0, 0.8))
    object:setCollisionsEnabled(false)
    object.scale = 1.3
    object.dimension = player.dimension
    -- Закинуть вещи в коробку
    takeAllItems(player)
    object:setData("loot_items", items)
end

addEvent("pickupLootItem", true)
addEventHandler("pickupLootItem", resourceRoot, function (element, weaponSlot)
    if not isElement(element) then
        return
    end
    if client.vehicle then
        return
    end
    if getDistanceBetweenPoints3D(client.position, element.position) > Config.minLootDistance + 2 then
        return
    end
    local item = element:getData("loot_item")
    if not isItem(item) then
        destroyElement(element)
        return
    end
    item.lootElement = nil
    if isItemWeapon(item) then
        local primarySlot
        if weaponSlot == "primary1" then
            primarySlot = 1
        elseif weaponSlot == "primary2" then
            primarySlot = 2
        end
        addPlayerWeapon(client, item, primarySlot)
        destroyElement(element)
    elseif isItemEquipment(item) then
        addPlayerEquipment(client, item)
        destroyElement(element)
    else
        if addBackpackItem(client, item) then
            destroyElement(element)
        end
    end

    animatePlayerPickup(client)
end)

function animatePlayerPickup(player)
    if not isElement(player) then
        return
    end
    if player:getData("pickup_animation") then
        return
    end
    player:setData("pickup_animation", true)

    player:setAnimation("BOMBER", "BOM_Plant")
    setTimer(function ()
        if isElement(player) then
            player:setAnimation("BOMBER", "BOM_Plant_2Idle", -1, false, false, true, true)
        end
    end, 500, 1)

    setTimer(function ()
        if isElement(player) then
            player:setAnimation()
            player:removeData("pickup_animation")
        end
    end, 1500, 1)
end
