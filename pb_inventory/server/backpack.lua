local playerBackpacks = {}

function initPlayerBackpack(player)
    if not isElement(player) then
        return
    end

    playerBackpacks[player] = {}
end

function sendPlayerBackpack(player)
    triggerClientEvent(player, "sendPlayerBackpack", resourceRoot, playerBackpacks[player])
end

function getPlayerBackpackItem(player, name)
    if not isElement(player) or not playerBackpacks[player] then
        return
    end
    return playerBackpacks[player][name]
end

-- Забирает вещь из инвентаря
function takePlayerBackpackItem(player, name, count)
    if not isElement(player) or not playerBackpacks[player] then
        return
    end
    if not count then
        count = 1
    end
    local item = playerBackpacks[player][name]
    if not isItem(item) then
        return
    end
    if not item.count then
        playerBackpacks[player][name] = nil
        return
    end
    item.count = item.count - count
    if item.count <= 0 then
        playerBackpacks[player][name] = nil
    end
    sendPlayerBackpack(player)
end

function getPlayerBackpackTotalWeight(player)
    if not isElement(player) or not playerBackpacks[player] then
        return
    end
    local amount = 0
    for name, item in pairs(playerBackpacks[player]) do
        amount = amount + getItemWeight(item)
    end
    return amount
end

function addBackpackItem(player, item)
    if not isElement(player) then
        return false
    end
    local backpack = playerBackpacks[player]
    if type(backpack) ~= "table" or type(item) ~= "table" then
        return false
    end

    if getPlayerBackpackTotalWeight(player) + getItemWeight(item) > getPlayerBackpackCapacity(player) then
        return false
    end

    local itemClass = Items[item.name]
    local currentItem = backpack[item.name]

    if currentItem then
        if itemClass.stackable then
            currentItem.count = currentItem.count + item.count
        else
            dropBackpackItem(currentItem.name)
            backpack[item.name] = item
        end
    else
        backpack[item.name] = item
    end
    sendPlayerBackpack(player)
    return true
end

function dropBackpackItem(player, name)
    if not isElement(player) then
        return
    end
    if not playerBackpacks[player] or not name then
        return
    end

    local item = playerBackpacks[player][name]
    playerBackpacks[player][name] = nil

    if item then
        spawnPlayerLootItem(player, item)
    end
    sendPlayerBackpack(player)
end

addEvent("dropBackpackItem", true)
addEventHandler("dropBackpackItem", resourceRoot, function (name)
    dropBackpackItem(client, name)
end)

function dropPlayerBackpack(player)
    if not isElement(player) then
        return
    end
    local backpack = playerBackpacks[player]
    if type(backpack) ~= "table" then
        return
    end
    playerBackpacks[player] = nil
    spawnPlayerLootBackpack(backpack, player.position)
    sendPlayerBackpack(player)
end

addEventHandler("onPlayerJoin", resourceRoot, function ()
    initPlayerBackpack(source)
end)

addEventHandler("onPlayerQuit", resourceRoot, function ()
    playerBackpacks[source] = nil
end)

addEventHandler("onResourceStart", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        initPlayerBackpack(player)
    end
end)

addEvent("requireClientBackpack", true)
addEventHandler("requireClientBackpack", resourceRoot, function ()
    savePlayerCurrentWeapon(client)
    sendPlayerBackpack(client)
end)
