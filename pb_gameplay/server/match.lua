local matchTypes = {
    ["solo"]   = 1,
    ["duo"]    = 2,
    ["triple"] = 3
}
local maxMatchPlayers = 3
local matchCounter = 0
local matchesList = {}

function getMatchTypeFromPlayersCount(count)
    if not count then
        return
    end
    local t = {
        [1] = "solo",
        [2] = "duo",
        [3] = "triple",
    }
    return t[count]
end

function getPlayersCountFromMatchType(matchType)
    if not matchType then
        return
    end
    return matchTypes[matchType]
end

-- Поиск матча для игроков
function findMatch(players)
    if type(players) ~= "table" then
        outputDebugString("[Matchmaking] findMatch: bad 'players' value (expected list of players)")
        return false
    end
    for i, player in ipairs(players) do
        if player:getData("matchId") then
            outputDebugString("[Matchmaking] findMatch: one of players is already in match")
            return false
        end
    end
    local matchType = getMatchTypeFromPlayersCount(#players)
    if not matchType or not matchTypes[matchType] then
        outputDebugString("[Matchmaking] findMatch: invalid match type '" .. tostring(matchType) .. "'")
        return false
    end

    -- Выбор свободного матча
    for i, match in ipairs(matchesList) do
        iprint(#match.players, #players, match.maxPlayers)
        if match.state == "waiting" and #match.players + #players <= match.maxPlayers then
            return addMatchPlayers(match, players)
        end
    end

    -- Создание нового пустого матча
    local match = createMatch(matchType)
    if not match then
        return false
    end
    return addMatchPlayers(match, players)
end

-- Создание нового матча типа matchType
function createMatch(matchType)
    if not matchType or not matchTypes[matchType] then
        outputDebugString("[Matchmaking] createMatch: invalid match type '" .. tostring(matchType) .. "'")
        return false
    end

    matchCounter = matchCounter + 1
    local matchId = matchCounter

    local match = {
        id          = matchId,

        players     = {},
        elements    = {},
        dimension   = matchId,

        maxPlayers  = maxMatchPlayers,
        matchType   = matchType,
        state       = "waiting",
        stateTime   = 0,
        totalTime   = 0,
        runningTime = 0,

        settings    = {}
    }

    table.insert(matchesList, match)
    initMatch(match)
    outputDebugString("[Matchmaking] Created new match (" .. tostring(match.id) .. ")")
    return match
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

function addMatchPlayers(match, players)
    if not isMatch(match) then
        outputDebugString("[Matchmaking] addMatchPlayers: bad match '" .. tostring(match) .. "'")
        return false
    end
    if type(players) ~= "table" then
        outputDebugString("[Matchmaking] addMatchPlayers: bad 'players' value (expected list of players)")
        return false
    end
    for i, player in ipairs(players) do
        addMatchPlayer(match, player)
    end
    return true
end

function addMatchPlayer(match, player)
    if not isMatch(match) then
        outputDebugString("[Matchmaking] addMatchPlayer: bad match '" .. tostring(match) .. "'")
        return false
    end
    if not isElement(player) then
        outputDebugString("[Matchmaking] addMatchPlayer: bad player '" .. tostring(player) .. "'")
        return false
    end
    if player:getData("matchId") then
        outputDebugString("[Matchmaking] addMatchPlayer: player is already in match")
        return false
    end
    player:setData("matchId", match.id)
    table.insert(match.players, player)

    handlePlayerJoinMatch(match, player)
    outputDebugString("[Matchmaking] Player "..tostring(player.name).." joined match " .. tostring(match.id))
    return true
end

function removePlayerFromMatch(player, reason)
    if not isElement(player) then
        outputDebugString("[Matchmaking] removePlayerFromMatch: bad player '" .. tostring(player) .. "'")
        return false
    end
    local matchId = player:getData("matchId")
    if not matchId then
        outputDebugString("[Matchmaking] removePlayerFromMatch: player is not in match")
        return false
    end
    player:removeData("matchId")
    local match = getMatchById(matchId)
    if match then
        handlePlayerLeaveMatch(match, player, reason)
        for i, p in ipairs(match.players) do
            if p == player then
                table.remove(match.players, i)
                break
            end
        end
    end
    outputDebugString("[Matchmaking] Player "..tostring(player.name).." left match " .. tostring(match.id))
    return true
end

function isMatch(match)
    return type(match) == "table" and match.id and match.players and match.matchType
end

function destroyMatch(match)
    if not isMatch(match) then
        outputDebugString("[Matchmaking] destroyMatch: bad match '" .. tostring(match) .. "'")
        return false
    end
    -- Удаление игроков из матча
    for i, player in ipairs(match.players) do
        removePlayerFromMatch(player, "match_destroyed")
    end
    -- Удаление элементов
    for i, element in ipairs(match.elements) do
        if isElement(element) then
            destroyElement(element)
        end
    end
    -- Удалить матч из списка матчей
    for i, m in ipairs(matchesList) do
        if m == match then
            table.remove(matchesList, i)
            break
        end
    end
    outputDebugString("[Matchmaking] Match " .. tostring(match.id) .. " destroyed")
    return true
end

addEventHandler("onPlayerQuit", root, function ()
    removePlayerFromMatch(player, "disconnect")
end)

setTimer(function ()
    for i, match in ipairs(matchesList) do
        match.stateTime = match.stateTime + 1
        match.totalTime = match.totalTime + 1
        updateMatch(match)
    end
end, 1000, 0)

addEventHandler("onResourceStart", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        player:removeData("matchId")
    end
end)

setTimer(function ()
    findMatch({getRandomPlayer()})
end, 500, 1)
