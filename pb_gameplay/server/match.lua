local matchesList = {}
local matchCounter = 0

function getAllMatches()
    return matchesList
end

function findMatch(players)
    if type(players) ~= "table" or #players == 0 then
        return false
    end
    if #players > Config.maxSquadPlayers then
        return false
    end
    -- Проверка нахождения игроков в других матчах
    for i, player in ipairs(players) do
        if isPlayerInMatch(player) then
            outputDebugString("Failed to find match, player is in another match")
            return false
        end
    end
    -- Выбор типа матча
    local matchType = "solo"
    if #players > 1 then
        matchType = "squad"
    end
    -- Поиск подходящего матча
    for i, match in ipairs(matchesList) do
        if match.state == "waiting" and match.matchType == matchType and #getMatchAlivePlayers(match) + #players <= match.maxPlayers then
            return addMatchSquad(match, players)
        end
    end

    -- Матч не найден - создаём новый
    local match = createMatch(matchType)
    return addMatchSquad(match, players)
end

function createMatch(matchType)
    if type(matchType) ~= "string" then
        return false
    end
    matchCounter = matchCounter + 1

    local match = {
        id = matchCounter,
        maxPlayers = Config.maxMatchPlayers,
        matchType = matchType,

        state = "none",
        tickCount = 0,

        dimension = matchCounter,
        allPlayers = {},
        players  = {},
        squads   = {},
        elements = {},
        settings = {},
    }

    table.insert(matchesList, match)
    initMatch(match)
    outputDebugString("[MATCH] Created new "..tostring(match.matchType).." match (" .. tostring(match.id) .. ")")
    return match
end

function isMatch(match)
    return type(match) == "table" and match.id and match.players and match.matchType
end

function getMatchById(id)
    if not id then
        return false
    end
    for i, match in ipairs(matchesList) do
        if match.id == id then
            return match
        end
    end
    return false
end

function getPlayerMatch(player)
    if not isElement(player) then
        return false
    end
    return getMatchById(player:getData("matchId"))
end

function isPlayerInMatch(player, match)
    if not isElement(player) then
        return false
    end
    local playerMatchId = player:getData("matchId")
    if match ~= nil then
        if not isMatch(match) then
            return false
        end
        return not not (playerMatchId == match.id)
    else
        return not not playerMatchId
    end
end

-- Возвращает список игроков
function getPlayerSquad(player)
    if not isElement(player) then
        return false
    end
    local playerMatchId = player:getData("matchId")
    local match = getMatchById(playerMatchId)
    local squad = getMatchSquad(match, player:getData("squadId"))
    if squad then
        return squad.players
    else
        return false
    end
end

function getMatchSquad(match, squadId)
    if not isMatch(match) or type(squadId) ~= "number" then
        return false
    end
    return match.squads[squadId]
end

function addMatchSquad(match, players)
    if not isMatch(match) then
        return false
    end
    if type(players) ~= "table" or #players == 0 then
        return false
    end
    local newSquad = {
        players = players,
    }
    table.insert(match.squads, newSquad)
    local squadId = #match.squads
    newSquad.id = squadId
    for i, player in ipairs(players) do
        player:setOnFire(false)

        player:setData("matchId", match.id)
        player:setData("squadId", squadId)

        table.insert(match.allPlayers, player)
        match.players[player] = squadId

        handlePlayerJoinMatch(match, player)
    end
    triggerClientEvent(players, "onMatchSquadJoined", resourceRoot, players)
end

function removePlayerFromMatch(player)
    if not isElement(player) then
        return false
    end
    player:setOnFire(false)
    local matchId = player:getData("matchId")
    if not matchId then
        return false
    end
    local match = getMatchById(matchId)
    if match then
        handlePlayerLeaveMatch(match, player)
        match.players[player] = nil
        handlePlayerLeftMatch(match, player)
    end
    player:removeData("matchId")
    triggerClientEvent(player, "onLeftMatch", resourceRoot)
    return true
end

function destroyMatch(match)
    if not isMatch(match) then
        return false
    end

    for player in pairs(match.players) do
        removePlayerFromMatch(player)
    end
    -- Удаление элементов
    for i, object in ipairs(getElementsByType("object")) do
        if object.dimension == match.dimension then
            table.insert(match.elements, object)
        end
    end
    Async:setPriority("low")
    Async:foreach(match.elements, function(element)
        if isElement(element) then
            destroyElement(element)
        end
    end)
    if isResourceRunning("pb_loot") then
        exports.pb_loot:unloadDimension(match.dimension)
    end

    -- Удалить матч
    for i, m in ipairs(matchesList) do
        if m == match then
            table.remove(matchesList, i)
            break
        end
    end
    outputDebugString("[MATCH] Match " .. tostring(match.id) .. " destroyed")
    return true
end

function addMatchElement(match, element)
    if not isMatch(match) then
        return false
    end
    if not isElement(element) then
        return false
    end

    table.insert(match.elements, element)
end

function triggerMatchEvent(match, ...)
    if not isMatch(match) then
        return false
    end
    for player in pairs(match.players) do
        triggerClientEvent(player, ...)
    end
    return true
end

setTimer(function ()
    for i, match in ipairs(matchesList) do
        updateMatch(match)
    end
end, 1000, 0)

addEvent("clientLeaveMatch", true)
addEventHandler("clientLeaveMatch", resourceRoot, function ()
    removePlayerFromMatch(client)
end)

addCommandHandler("leavematch", function (player)
    removePlayerFromMatch(player)
end)

addEventHandler("onPlayerQuit", root, function ()
    removePlayerFromMatch(source)
end)
