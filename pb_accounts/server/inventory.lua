local playerInventories = {}

function createItem(name)
    if not name then
        return
    end
    local itemClass = ItemClasses[name]
    if not itemClass then
        outputDebugString("[ACCOUNTS] Failed to create item '" .. tostring(name) .. "'")
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

function addPlayerInventoryItem(player, item, omitSave)
    if not player or not isItem(item) then
        return
    end
    local inventory = getPlayerInventory(player)
    if not isInventory(inventory) then
        return false
    end
    if inventory[item.name] then
        if inventory[item.name].count then
            inventory[item.name].count = inventory[item.name].count + item.count
        end
    else
        inventory[item.name] = item
    end
    if not omitSave then
        savePlayerAccount(player)
    end
    sendPlayerInventory(player)
    return true
end

function getPlayerInventoryItem(player, name)
    if not player or not name then
        return
    end
    local inventory = getPlayerInventory(player)
    if not isInventory(inventory) then
        return false
    end
    return inventory[name]
end

function takePlayerInventoryItemCount(player, name, count, omitSave)
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
    local item = inventory[name]
    if not isItem(item) then
        return
    end
    if item.count then
        item.count = item.count - count
        if item.count <= 0 then
            inventory[name] = nil
        end
    else
        inventory[name] = nil
    end
    if not omitSave then
        savePlayerAccount(player)
    end
    sendPlayerInventory(player)
end

function getDefaultInventory()
    local items = {}
    -- Дефолтная одежда
    return items
end

function setupPlayerInventory(player, playerInventory)
    if not isElement(player) then
        return false
    end
    if type(playerInventory) ~= "table" then
        playerInventory = {}
    end
    for name, item in pairs(playerInventory) do
        if not isItem(item) then
            playerInventory[name] = nil
        end
    end
    -- Выдача дефолтной одежды, если её нет
    for layer, itemName in pairs(DefaultClothes) do
        if not isItem(playerInventory[itemName]) then
            playerInventory[itemName] = createItem(itemName)
        end
    end
    playerInventories[player] = playerInventory
    savePlayerAccount(player)
    sendPlayerInventory(player)
end

function sendPlayerInventory(player)
    if player and playerInventories[player] then
        triggerClientEvent(player, "onClientInventoryUpdated", resourceRoot, playerInventories[player])
    end
end
