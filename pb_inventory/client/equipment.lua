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

addEventHandler("onClientResourceStart", resourceRoot, function ()
    triggerServerEvent("requireClientEquipment", resourceRoot)
end)

local localDamage = 0

addEventHandler("onClientPlayerDamage", localPlayer, function (attacker, weaponId, bodypart, baseLoss)
    if not isElement(attacker) then
        return
    end
    if localPlayer.vehicle == attacker then
        return
    end
    if attacker == localPlayer then
        return
    end
    local loss = baseLoss
    local custom
    -- Голова
    if bodypart == 9 then
        loss = 110
        local item = getEquipmentSlot("helmet")
        if isItem(item) and item.health > 0 then
            item.health = math.max(0, item.health - baseLoss)
            loss = loss * Items[item.name].penetration_ratio
            triggerServerEvent("updateEquipmentHealth", resourceRoot, Items[item.name].category, item.health)
        end
    -- Тело
    elseif bodypart == 3 then
        loss = loss * 3
        local item = getEquipmentSlot("armor")
        if isItem(item) and item.health > 0 then
            item.health = math.max(0, item.health - loss)
            loss = loss * Items[item.name].penetration_ratio
            triggerServerEvent("updateEquipmentHealth", resourceRoot, Items[item.name].category, item.health)
        end
    elseif bodypart == 4 then
        loss = loss * 2
    end
    if loss > 0 then
        localDamage = localDamage + loss
    end
    local newHealth = math.max(0, math.min(100, localPlayer.health + baseLoss - loss))
    localPlayer.health = newHealth

    if newHealth > 0 then
        cancelEvent()
    end
end)

setTimer(function ()
    if localDamage > 0 then
        local total = localPlayer:getData("damage_taken") or 0
        localPlayer:setData("damage_taken", math.floor(total + localDamage))
    end
    localDamage = 0
end, 1000, 0)
