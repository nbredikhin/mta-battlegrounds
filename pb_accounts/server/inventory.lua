local playerInventories = {}

function createItem(name)
    if not name then
        return
    end
    local itemClass = ItemClasses[name]
    if not itemClass then
        iprint("Invalid item class", name)
        return
    end
    local instance = {
        name  = name,
        count = 1
    }
    return instance
end

function getPlayerInventory(player)
    if not isElement(player) then
        return
    end
    return playerInventories[player]
end

function isInventory(inventory)
    if type(inventory) ~= "table" then
        return false
    end
    return true
end

function addPlayerInventoryItem(player, item)
    if not player or not isItem(item) then
        return
    end
    local inventory = getPlayerInventory(player)
    if not isInventory(inventory) then
        return false
    end
    for i, inventoryItem in ipairs(inventory) do
        if inventoryItem.name == item.name then
            inventoryItem.count = inventoryItem.count + 1
            savePlayerAccount(player)
            sendPlayerInventory(player)
            return
        end
    end
    table.insert(inventory, item)
    savePlayerAccount(player)
    sendPlayerInventory(player)
end

function takePlayerInventoryItemCount(player, name, count)
    if not player or not name then
        return
    end
    local inventory = getPlayerInventory(player)
    if not isInventory(inventory) then
        return false
    end
    if type(count) ~= "number" then
        count = 1
    end
    for i, inventoryItem in ipairs(inventory) do
        if inventoryItem.name == name then
            inventoryItem.count = inventoryItem.count - count
            if inventoryItem.count <= 0 then
                table.remove(inventory, i)
            end
            savePlayerAccount(player)
            sendPlayerInventory(player)
            return
        end
    end
end

function getDefaultInventory()
    local items = {}
    -- Дефолтная одежда
    table.insert(items, createItem("clothes_jeans1"))
    return items
end

function setupPlayerInventory(player, items)
    if not isElement(player) then
        return false
    end
    if not items then
        items = getDefaultInventory()
    end
    local validItems = {}
    for i, item in ipairs(items) do
        if isItem(item) then
            table.insert(validItems, item)
        end
    end
    playerInventories[player] = validItems

    sendPlayerInventory(player)
end

function sendPlayerInventory(player)
    if player and playerInventories[player] then
        triggerClientEvent(player, "onClientInventoryUpdated", resourceRoot, playerInventories[player])
    end
end

addCommandHandler("accgive", function (player, cmd, name)
    addPlayerInventoryItem(player, createItem(name))
end)
