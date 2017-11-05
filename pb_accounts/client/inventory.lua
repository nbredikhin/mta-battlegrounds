local localInventory = {}

function getInventory()
    return localInventory
end

addEvent("onClientInventoryUpdated", true)
addEventHandler("onClientInventoryUpdated", resourceRoot, function (inventory)
    localInventory = inventory
end)
