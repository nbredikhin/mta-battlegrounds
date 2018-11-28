local clientBackpack = {}
-- Отсортированные вещи из инвентаря
local backpackItemsList = {}

function updateBackpackItems()
    backpackItemsList = {}
    for name, item in pairs(clientBackpack) do
        table.insert(backpackItemsList, item)
    end
end

function getBackpackItemCount(name)
    if not clientBackpack then
        return 0
    end
    local item = clientBackpack[name]
    if not item then
        return 0
    else
        return item.count or 0
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
    return math.ceil(amount)
end

function getBackpackItems()
    return backpackItemsList
end

function getBackpackItem(name)
    if not name or not clientBackpack then
        return
    end
    return clientBackpack[name]
end

addEvent("sendPlayerBackpack", true)
addEventHandler("sendPlayerBackpack", resourceRoot, function (backpack)
    clientBackpack = backpack or {}

    updateBackpackItems()
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    triggerServerEvent("requireClientBackpack", resourceRoot)
end)
