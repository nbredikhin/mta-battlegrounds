local playerEquipments = {}
local equipmentSlots = {
    helmet = true,
    armor = true,
    backpack = true
}

function initPlayerEquipment(player)
    if not isElement(player) then
        return
    end

    playerEquipments[player] = {
        helmet   = nil,
        armor    = nil,
        backpack = nil,
    }
end

function getPlayerBackpackCapacity(player)
    if not isElement(player) or not playerEquipments[player] then
        return
    end
    local backpack = playerEquipments[player].backpack
    if not isItem(backpack) then
        return Config.defaultBackpackCapacity
    end
    return tonumber(Items[backpack.name].capacity)
end

function updatePlayerEquipment(player)
    triggerClientEvent(player, "sendPlayerEquipment", resourceRoot, playerEquipments[player])
    for name, item in pairs(playerEquipments[player]) do
        player:setData("wear_"..tostring(name), Items[item.name].model)
    end
    triggerClientEvent("updatePlayerEquipment", resourceRoot, player)
end

function addPlayerEquipment(player, item)
    if not isElement(player) or not playerEquipments[player] or not isItem(item) then
        return
    end
    local itemClass = Items[item.name]
    local slot = itemClass.category
    if equipmentSlots[slot] then
        dropPlayerEquipment(player, itemClass.category)
        playerEquipments[player][slot] = item
        updatePlayerEquipment(player)
    end
end

function dropPlayerEquipment(player, slot)
    if not isElement(player) or not playerEquipments[player] or type(slot) ~= "string" then
        return
    end
    if playerEquipments[player][slot] then
        spawnPlayerLootItem(player, playerEquipments[player][slot])
        playerEquipments[player][slot] = nil
        updatePlayerEquipment(player)
    end
end

addEventHandler("onPlayerJoin", root, function ()
    initPlayerEquipment(source)
end)

addEventHandler("onPlayerQuit", root, function ()
    playerEquipments[source] = nil
end)

addEventHandler("onResourceStart", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        initPlayerEquipment(player)
    end
end)

addEvent("requireClientEquipment", true)
addEventHandler("requireClientEquipment", resourceRoot, function ()
    triggerClientEvent(client, "sendPlayerEquipment", resourceRoot, playerEquipments[client])
end)

setTimer(function ()
    addPlayerEquipment(getRandomPlayer(), createItem("backpack_small"))
end, 1000, 1)
