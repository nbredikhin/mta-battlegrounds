addEvent("onPlayerStatsFieldAdd", true)
addEventHandler("onPlayerStatsFieldAdd", resourceRoot, function (name, count)
    addPlayerStatsField(client, name, count)
end)

-- Обновление статистики
function addPlayerStatsField(player, name, count)
    if not player or not name then
        return
    end
    if not count then
        count = 1
    end
    local session = getPlayerSession(player)
    if not session or not session[name] then
        return
    end
    session[name] = (tonumber(session[name]) or 0) + count
    return true
end

addEvent("onPlayerRequestStats", true)
addEventHandler("onPlayerRequestStats", root, function ()
    triggerClientEvent(client, "onClientStatsUpdated", resourceRoot, getPlayerSession(client))
end)
