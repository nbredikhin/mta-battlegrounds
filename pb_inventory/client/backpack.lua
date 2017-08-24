local clientBackpack = {}
-- Отсортированные вещи из инвентаря
local backpackItemsList = {}

function updateBackpackItems()
    backpackItemsList = {}
    for name, item in pairs(clientBackpack) do
        table.insert(backpackItemsList, item)
    end
end

function getBackpackTotalWeight()
    if not clientBackpack then
        return 0
    end
    local amount = 0
    for name, item in pairs(clientBackpack) do
        amount = amount + getItemWeight(item)
    end
    return amount
end

function getBackpackItems()
    return backpackItemsList
end

addEvent("sendPlayerBackpack", true)
addEventHandler("sendPlayerBackpack", resourceRoot, function (backpack)
    clientBackpack = backpack or {}

    updateBackpackItems()
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    triggerServerEvent("requireClientBackpack", resourceRoot)
end)
