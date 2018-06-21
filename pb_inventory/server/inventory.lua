-- Таблица инвентарей, привязанных к элементам
local inventories = {}

------------------------
-- Глобальные функции --
------------------------

function createInventory(element)
    if not isElement(element) then
        return false
    end

    local inventory = {
        element = element,
        items   = {},
        slots   = {},
    }

    inventories[element] = inventory

    handleInventoryItemsChange(inventory)
    return true
end

function isInventory(inventory)
    return type(inventory) == "table" and isElement(inventory.element)
end

function getInventory(element)
    if not element then
        return false
    end
    return inventories[element]
end

function destroyInventory(inventoryOrElement)
    local element
    if isInventory(inventoryOrElement) then
        element = inventoryOrElement.element
    elseif isElement(inventoryOrElement) then
        element = inventoryOrElement
    else
        return false
    end

    inventories[element] = nil

    return true
end

function addInventoryItem(inventory, itemOrName)
    if not isInventory(inventory) or not itemOrName then
        return false
    end
    local item
    if isItem(itemOrName) then
        item = itemOrName
    elseif type(itemOrName) == "string" then
        item = createItem(itemOrName)
    else
        return false
    end
    if not item then
        return false
    end

    if inventory.items[item.name] then
        if getItemClass(item).stackable then
            inventory.items[item.name].count = inventory.items[item.name].count + 1
        else
            return false
        end
    else
        inventory.items[item.name] = table.copy(item)
    end

    handleInventoryItemsChange(inventory)

    return true
end

-- По умолчанию забирает всё, можно указать count
function takeInventoryItem(inventory, name, count)
    if not isInventory(inventory) or not name then
        return false
    end

    if not inventory.items[name] then
        return false
    end

    count = math.floor(tonumber(count))
    if not count then
        count = inventory.items[name].count
    elseif count <= 0 then
        return false
    end

    inventory.items[name].count = inventory.items[name].count - count
    if inventory.items[name].count <= 0 then
        inventory.items[name] = nil
    end

    handleInventoryItemsChange(inventory)

    return true
end

function handleInventoryItemsChange(inventory)
    if getElementType(inventory.element) == "player" then
        triggerClientEvent(inventory.element, "onClientInventoryUpdate", resourceRoot, inventory.items)
    end
end

-----------------------
-- Обработка событий --
-----------------------

addEvent("onPlayerRequireInventory", true)
addEventHandler("onPlayerRequireInventory", resourceRoot, function ()
    local inventory = getInventory(client)
    if isInventory(inventory) then
        triggerClientEvent(client, "onClientInventoryUpdate", resourceRoot, inventory.items)
    else
        createInventory(client)
    end
end)
