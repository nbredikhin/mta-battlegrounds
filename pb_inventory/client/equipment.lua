local clientEquipment = {}

function getEquipmentSlot(slot)
    if not slot then
        return
    end
    return clientEquipment[slot]
end

function getBackpackCapacity()
    if not clientEquipment then
        return 0
    end
    local backpack = clientEquipment.backpack
    if not isItem(backpack) then
        return Config.defaultBackpackCapacity
    end
    return tonumber(Items[backpack.name].capacity)
end

addEvent("sendPlayerEquipment", true)
addEventHandler("sendPlayerEquipment", resourceRoot, function (equipment)
    clientEquipment = equipment or {}
end)

addEvent("updatePlayerEquipment", true)
addEventHandler("updatePlayerEquipment", resourceRoot, function (player)
    updatePlayerWearingItems(player)
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    triggerServerEvent("requireClientEquipment", resourceRoot)
end)
