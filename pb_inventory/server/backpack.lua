local playerBackpacks = {}

function initPlayerBackpack(player, omitSend)
    if not isElement(player) then
        return
    end

    playerBackpacks[player] = {}
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
    triggerClientEvent(client, "sendPlayerBackpack", resourceRoot, playerBackpacks[client])
end)
