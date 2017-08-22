local playerInventories = {}

function getItem(name)
    return Items[name]
end

function instantiateItem(name, count, vars)
    local item = getItem(name)
    if not item then
        return
    end
    local instance = {
        name = name,
        count = tonumber(count) or 1
    }
    if item.vars then
        for name, value in pairs(item.vars) do
            instance[name] = value
        end
    end
    if vars then
        for name, value in pairs(vars) do
            instance[name] = value
        end
    end
    return instance
end

function addPlayerItem(player, item)
    if not isElement(player) then
        return
    end
    local inventory = playerInventories[player]
    if type(inventory) ~= "table" or type(item) ~= "table" then
        return
    end

    local itemClass = Items[item.name]
    local currentItem = inventory[item.name]

    if currentItem then
        if itemClass.stackable then
            currentItem.count = currentItem.count + item.count
        else
            dropPlayerItem(currentItem.name)
            inventory[item.name] = item
        end
    else
        if itemClass.specialSlot then
            dropPlayerWeaponItem(player, specialSlot)
        end
        inventory[item.name] = item
    end
    sendPlayerInventory(player)
end

function dropPlayerItem(player, name)
    if not isElement(player) then
        return
    end
    local inventory = playerInventories[player]
    if type(inventory) ~= "table" or type(name) ~= "string" then
        return
    end

    local item = inventory[name]
    inventory[name] = nil

    if item then
        instantiateLootItem(item, player.position)
    end
    sendPlayerInventory(player)
end

function dropPlayerSpecialItem(player, slotName)
    if not isElement(player) then
        return
    end
    local inventory = playerInventories[player]
    if type(inventory) ~= "table" or type(slotName) ~= "string" then
        return
    end

    for name, item in pairs(inventory) do
        if Items[name].specialSlot == slotName then
            dropPlayerItem(player, name)
            return
        end
    end
end

function dropPlayerInventory(player)
    if not isElement(player) then
        return
    end
    local inventory = playerInventories[player]
    if type(inventory) ~= "table" then
        return
    end
    playerInventories[player] = nil
    instantiateLootInventory(inventory, string.gsub(player.name, '#%x%x%x%x%x%x', '') .. "'s loot", player.position)
    sendPlayerInventory(player)
end

function createPlayerInventory(player, omitSend)
    if not isElement(player) then
        return
    end

    playerInventories[player] = {}

    addPlayerItem(player, instantiateItem("bandage", 5))
    addPlayerItem(player, instantiateItem("first_aid", 3))

    if not omitSend then
        sendPlayerInventory(player)
    end
end

function sendPlayerInventory(player)
    triggerClientEvent(player, "sendPlayerInventory", resourceRoot, playerInventories[player])
end

addEventHandler("onPlayerJoin", resourceRoot, function ()
    createPlayerInventory(source)
end)

addEventHandler("onPlayerQuit", resourceRoot, function ()
    playerInventories[source] = nil
end)

addEventHandler("onResourceStart", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        createPlayerInventory(player, true)
    end
end)

addEvent("requirePlayerInventory", true)
addEventHandler("requirePlayerInventory", resourceRoot, function ()
    sendPlayerInventory(client)
end)
