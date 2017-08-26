local lootColors = {
    white  = 1575,
    orange = 1576,
    yellow = 1577,
    green  = 1578,
    blue   = 1579,
    red    = 1580,
}

function spawnLootItem(item, position)
    if not isItem(item) or not position then
        return
    end
    if isItemWeapon(item) then
        color = "red"
    elseif Items[item.name].category == "medicine" then
        color = "green"
    elseif Items[item.name].category == "ammo" then
        color = "blue"
    end
    local object = createObject(lootColors[color], position)
    object.rotation = Vector3(0, 0, math.random(360))
    object:setCollisionsEnabled(false)

    item.lootElement = object
    object:setData("loot_item", item)
end

function spawnPlayerLootItem(player, item)
    if not isElement(player) or not item then
        return
    end
    local offsetX = math.random() * 0.4 - 0.2
    local offsetY = math.random() * 0.4 - 0.2
    local position = player.position - Vector3(offsetX, offsetY, 1)
    local color = "white"
    return spawnLootItem(item, position)
end

function spawnPlayerLootBackpack(backpack, position)
    local items = {}
    local object = createObject(2358, position - Vector3(0, 0, 0.8))
    object:setCollisionsEnabled(false)
    object.scale = 1.3

    for name, item in pairs(backpack) do
        table.insert(items, item)
    end

    object:setData("loot_items", items)
end

addEvent("pickupLootItem", true)
addEventHandler("pickupLootItem", resourceRoot, function (element, weaponSlot)
    if not isElement(element) then
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
end)

