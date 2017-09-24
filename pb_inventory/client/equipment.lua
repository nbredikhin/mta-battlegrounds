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

addEventHandler("onClientPlayerDamage", localPlayer, function (attacker, weaponId, bodypart, oldLoss)
    if not isElement(attacker) then
        return
    end

    local loss = oldLoss
    local custom
    if bodypart == 9 then
        loss = 50
        local item = getEquipmentSlot("helmet")
        if isItem(item) then
            item.health = math.max(0, item.health - loss)
            if item.health > 0 then
                loss = loss * (1 - Items[item.name].penetration_ratio)
            end
            triggerServerEvent("updateEquipmentHealth", resourceRoot, Items[item.name].category, item.health)
        end
    elseif bodypart == 3 then
        local item = getEquipmentSlot("armor")
        if isItem(item) then
            item.health = math.max(0, item.health - loss)
            if item.health > 0 then
                loss = loss * (1 - Items[item.name].penetration_ratio)
            end
            triggerServerEvent("updateEquipmentHealth", resourceRoot, Items[item.name].category, item.health)
        end
    end
    if loss > 0 then
        localDamage = localDamage + loss
    end
    local newHealth = math.min(100, localPlayer.health + oldLoss - loss)
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
