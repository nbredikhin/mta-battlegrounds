local lootColors = {
    white = 1575,
    orange = 1576,
    yellow = 1577,
    green = 1578,
    blue = 1579,
    red = 1580,
}

function spawnPlayerLootItem(player, item)
    local offsetX = math.random() * 0.4 - 0.2
    local offsetY = math.random() * 0.4 - 0.2
    local color = "white"
    if isItemWeapon(item) then
        color = "red"
    elseif Items[item.name].category == "medicine" then
        color = "green"
    end
    local object = createObject(lootColors[color], player.position - Vector3(offsetX, offsetY, 0.9))
    object.rotation = Vector3(0, 0, math.random(360))
    object:setCollisionsEnabled(false)

    item.lootElement = object
    object:setData("loot_item", item)
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
    destroyElement(element)
    if not isItem(item) then
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
    elseif isItemEquipment(item) then

    else
        addBackpackItem(client, item)
    end
end)
