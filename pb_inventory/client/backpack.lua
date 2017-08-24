local clientInventory = {}
-- Отсортированные вещи из инвентаря
local backpackItemsList = {}

function updateBackpackItems()
    backpackItemsList = {}
    for name, item in pairs(clientInventory) do
        table.insert(backpackItemsList, item)
    end
end

function getBackpackItems()
    return backpackItemsList
end

addEvent("sendPlayerBackpack", true)
addEventHandler("sendPlayerBackpack", resourceRoot, function (inventory)
    clientInventory = inventory or {}

    updateBackpackItems()
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    triggerServerEvent("requireClientBackpack", resourceRoot)
end)
