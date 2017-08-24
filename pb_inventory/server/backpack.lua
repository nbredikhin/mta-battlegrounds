local playerBackpacks = {}

function initPlayerBackpack(player, omitSend)
    if not isElement(player) then
        return
    end

    playerBackpacks[player] = {}
end

function sendPlayerBackpack(player)
    triggerClientEvent(player, "sendPlayerBackpack", resourceRoot, playerBackpacks[player])
end

function addBackpackItem(player, item)
    if not isElement(player) then
        return
    end
    local backpack = playerBackpacks[player]
    if type(backpack) ~= "table" or type(item) ~= "table" then
        return
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

setTimer(function ()
    local item = createItem("bandage", 5)
    addBackpackItem(getRandomPlayer(), item)
end, 1000, 1)
