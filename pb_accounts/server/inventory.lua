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

function addPlayerInventoryItem(player, item, omitSave)
    if not player or not isItem(item) then
        iprint("Bad player or item")
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
    -- Выдача дефолтной одежды, если её нет
    for layer, name in pairs(DefaultClothes) do
        local found = false
        for i, item in ipairs(validItems) do
            if getItemClass(item).clothes == name then
                found = true
                break
            end
        end
        if not found then
            table.insert(validItems, createItem("clothes_"..tostring(name)))
        end
    end
    local playerInventory = {}
    for i, item in ipairs(validItems) do
        playerInventory[item.name] = item
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

addCommandHandler("accgive", function (player, cmd, name)
    local item = createItem(name)
    if not isItem(item) then
        iprint("Item does not exist", name)
    end
    if addPlayerInventoryItem(player, item) then
        iprint("Added item", name)
    else
        iprint("Failed to add", name)
    end
end)
