local playerInventories = {}

function isItem(item)
    if type(item) == "table" and item.name and ItemClasses[item.name] then
        return true
    else
        return false
    end
end

function createItem(name)
    if not name then
        return
    end
    local itemClass = ItemClasses[name]
    if not itemClass then
        return
    end
    local instance = {
        name  = name,
        count = 1
    }
    return instance
end

function getDefaultInventory()
    local items = {}
    -- Дефолтная одежда
    --table.insert(items, createItem("clothes_jeans"))
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
end

function getPlayerInventory(player)
    if not player then
        return
    end
    return playerInventories[player]
end
