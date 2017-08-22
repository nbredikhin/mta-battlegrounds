local clientInventory = {}
-- Отсортированные вещи из инвентаря
local inventoryItems = {}
local specialSlots = {}
local weaponSlots = {}

function updateInventory()
    inventoryItems = {}
    for name, item in pairs(clientInventory) do
        local itemClass = Items[name]
        if itemClass.specialSlot then
            specialSlots[item.specialSlot] = item
        else
            table.insert(inventoryItems, item)
        end
    end
end

function sortInventoryItems(by)

end

function getInventoryItems()
    return inventoryItems
end

function getInventorySpecialSlot(name)
    return specialSlots[name]
end

addEvent("sendPlayerInventory", true)
addEventHandler("sendPlayerInventory", resourceRoot, function (inventory)
    clientInventory = inventory or {}

    updateInventory()
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    triggerServerEvent("requirePlayerInventory", resourceRoot)
end)
