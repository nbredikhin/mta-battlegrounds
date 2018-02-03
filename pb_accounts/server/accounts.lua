local dbTableName = "users"
local serverId = 1337
local autosaveInterval = 180

local clothesData = {
    "clothes_hat",
    "clothes_head",
    "clothes_body",
    "clothes_feet",
    "clothes_jacket",
    "clothes_legs",
    "clothes_hair",
    "clothes_gloves",
    "clothes_mask",
    "clothes_glasses",
}

local loadAccountData = {
    "username",
    "battlepoints",
    "donatepoints",
    "crate_level"
}

local saveAccountData = {
    "battlepoints",
    "donatepoints",
    "crate_level"
}

for i, name in ipairs(clothesData) do
    table.insert(loadAccountData, name)
    table.insert(saveAccountData, name)
end

local protectData = {
    ["crate_level"] = true,
    ["battlepoints"] = true,
    ["donatepoints"] = true,
}

local statsFields = {
    "stats_kills",
    "stats_wins_solo",
    "stats_wins_squad",
    "stats_top10_solo",
    "stats_top10_squad",
    "stats_plays_solo",
    "stats_plays_squad",
    "stats_hp_healed",
    "stats_hp_damage",
    "stats_distance_ped",
    "stats_distance_car",
    "stats_items_used",
    "stats_playtime",
    "stats_deaths",
}

local ratingFields = {
    "rating_solo_main",
    "rating_solo_wins",
    "rating_solo_kills",
    "rating_squad_main",
    "rating_squad_wins",
    "rating_squad_kills",
}

local playerSessions = {}

local function setupPlayerSession(player, account)
    if not player or type(account) ~= "table" then
        return false
    end
    local currentTimestamp = getRealTime().timestamp
    playerSessions[player] = {
        username          = account.username,
        loginTimestamp    = currentTimestamp,
        lastSaveTimestamp = currentTimestamp,
        stats             = {},
        rating            = {},
    }
    -- Статистика
    for i, name in ipairs(statsFields) do
        playerSessions[player].stats[name] = account[name]
    end

    -- Рейтинг
    for i, name in ipairs(ratingFields) do
        playerSessions[player].rating[name] = account[name]
    end
end

function getPlayerSession(player)
    if not isElement(player) then
        if playerSessions[player] then
            playerSessions[player] = nil
        end
        return
    end

    return playerSessions[player]
end

function logoutPlayer(player)
    if not isElement(player) then
        return
    end

    savePlayerAccount(player)

    local username = player:getData("username")
    if username then
        exports.mysql:dbExec(dbTableName, [[
            UPDATE ?? SET online_server = 0 WHERE username = ?;
        ]], username)
    end
    playerSessions[player] = nil
    outputDebugString("[ACCOUNTS] Logout player " .. tostring(player.name) .. " (acc " .. tostring(username) .. ")")

    return true
end

function isPlayerLoggedIn(player)
    if not isElement(player) then
        return false
    end
    return not not player:getData("username")
end

-- Сохраняет только поля из даты игрока
function savePlayerAccountData(player)
    if not isElement(player) then
        return
    end
    if not getPlayerSession(player) then
        return
    end
    local username = player:getData("username")
    if type(username) ~= "string" then
        return
    end

    local saveQuery = {}
    local saveArgs = {}

    for i, name in ipairs(saveAccountData) do
        local value = player:getData(name)
        if value then
            table.insert(saveQuery, tostring(name) .. " = ?")
            table.insert(saveArgs, value)
        else
            table.insert(saveQuery, tostring(name) .. " = NULL")
        end
    end

    table.insert(saveArgs, username)

    exports.mysql:dbExec(dbTableName, [[
        UPDATE ?? SET ]]
            .. table.concat(saveQuery, ",\n") ..
        [[ WHERE username = ?;
    ]], unpack(saveArgs))
end

function savePlayerAccount(player)
    local session = getPlayerSession(player)
    if not session then
        return
    end

    if not isElement(player) then
        outputDebugString("[ACCOUNTS] Failed to save player account '" .. tostring(player) .. "'")
        return
    end
    local username = player:getData("username")
    if type(username) ~= "string" then
        return
    end

    local saveQuery = {}
    local saveArgs = {}

    for i, name in ipairs(saveAccountData) do
        local value = player:getData(name)
        if value then
            table.insert(saveQuery, tostring(name) .. " = ?")
            table.insert(saveArgs, value)
        else
            table.insert(saveQuery, tostring(name) .. " = NULL")
        end
    end

    local inventoryString = toJSON(getPlayerInventory(player))
    if inventoryString then
        table.insert(saveQuery, "items = ?")
        table.insert(saveArgs, inventoryString)
    end
    -- Обновить время игры на сервере
    session.stats["stats_playtime"] = tonumber(session.stats["stats_playtime"])
    if not session.stats["stats_playtime"] then
        session.stats["stats_playtime"] = 0
    end
    local currentTimestamp = getRealTime().timestamp
    session.stats["stats_playtime"] = session.stats["stats_playtime"] + (currentTimestamp - session.lastSaveTimestamp)
    session.lastSaveTimestamp = currentTimestamp

    -- Поля статистики
    for i, name in ipairs(statsFields) do
        local value = session.stats[name]
        if value then
            table.insert(saveQuery, tostring(name) .. " = ?")
            table.insert(saveArgs, value)
        end
    end

    -- Поля рейтинга
    for i, name in ipairs(ratingFields) do
        local value = session.rating[name]
        if value then
            table.insert(saveQuery, tostring(name) .. " = ?")
            table.insert(saveArgs, value)
        end
    end

    -- Время последнего входа
    table.insert(saveQuery, "last_seen = ?")
    table.insert(saveArgs, currentTimestamp)

    -- Серийник
    table.insert(saveQuery, "serial = ?")
    table.insert(saveArgs, player.serial)

    -- Юзернейм
    table.insert(saveArgs, username)

    exports.mysql:dbExec(dbTableName, [[
        UPDATE ?? SET ]]
            .. table.concat(saveQuery, ",\n") ..
        [[ WHERE username = ?;
    ]], unpack(saveArgs))

    outputDebugString("[ACCOUNTS] Saved player account '"..player.name.."' ("..username..")")
end

function dbLoginPlayer(result, params)
    if not params or not isElement(params.player) then
        return
    end
    local player = params.player
    if not result or #result == 0 then
        -- Account not found
        triggerClientEvent(player, "onClientLoginError", resourceRoot, "account_not_found")
        return
    end
    result = result[1]
    if result.online_server and result.online_server > 0 then
        -- Already logged in (other server)
        triggerClientEvent(player, "onClientLoginError", resourceRoot, "already_logged")
        return
    end

    passwordVerify(params.password, result.password, function (match)
        if not isElement(player) then
            return
        end
        if not match then
            -- Passwords dont match
            triggerClientEvent(player, "onClientLoginError", resourceRoot, "invalid_password")
            return
        end

        for i, name in ipairs(loadAccountData) do
            player:setData(name, result[name])
        end

        local head = player:getData("clothes_head")
        if not exports.pb_clothes:isValidClothesName(head) then
            player:setData("clothes_head", "head"..math.random(1, 2))
        end

        local hair = player:getData("clothes_hair")
        if not exports.pb_clothes:isValidClothesName(hair) then
            if player:getData("clothes_head") == "head1" then
                player:setData("clothes_hair", "hair"..math.random(2, 8))
            else
                player:setData("clothes_hair", "hair"..math.random(1, 8))
            end
        end

        if not result.last_seen then
            result.last_seen = nil
        end

        -- Сброс уровня сундука раз в неделю
        local lastSeenTime = getRealTime(result.last_seen)
        local lastSeenWeek = math.floor((lastSeenTime.yearday + 1) / 7)
        local currentWeek = math.floor((getRealTime().yearday + 1) / 7)
        if lastSeenWeek ~= currentWeek then
            player:setData("crate_level", 1)
        end

        setupPlayerInventory(player, fromJSON(result.items))
        setupPlayerSession(player, result)

        for i, name in ipairs(clothesData) do
            if name ~= "clothes_head" and name ~= "clothes_hair" then
                local itemName = player:getData(name)
                if itemName and not getPlayerInventoryItem(player, itemName) then
                    player:removeData(name)
                end
            end
        end

        exports.mysql:dbExec(dbTableName, [[
            UPDATE ?? SET online_server = ?, nickname = ? WHERE username = ?;
        ]], serverId, player.name, result.username)

        triggerClientEvent(player, "onClientLoginSuccess", root)
        outputDebugString("[ACCOUNTS] Login player " .. tostring(player.name) .. " (acc " .. tostring(player:getData("username")) .. ")")
    end)
end

function dbRegisterCheckAccount(result, params)
    if result and #result > 0 then
        triggerClientEvent(params.player, "onClientRegisterResult", resourceRoot, false, "account_exists")
        return
    end
    passwordHash(params.password, "bcrypt", { cost = 10 }, function (password)
        exports.mysql:dbQueryAsync("dbRegisterPlayer", { player = params.player }, dbTableName, [[
            INSERT INTO ?? (
                username,
                password,
                items
            ) VALUES (?, ?, ?);
        ]], params.username, password, toJSON(getDefaultInventory()))
    end)
end

function dbRegisterPlayer(result, params)
    if not params or not isElement(params.player) then
        return
    end
    if not result then
        triggerClientEvent(params.player, "onClientRegisterResult", resourceRoot, false)
        return
    end
    triggerClientEvent(params.player, "onClientRegisterResult", resourceRoot, true)
end

function loginPlayer(player, username, password)
    if not isElement(player) or type(username) ~= "string" or type(password) ~= "string" then
        return false
    end
    if isPlayerLoggedIn(player) then
        return
    end
    exports.mysql:dbQueryAsync("dbLoginPlayer", { player = player, password = password }, dbTableName, [[
        SELECT * FROM ?? WHERE username = ?;
    ]], username)
end

function registerPlayer(player, username, password)
    if not isElement(player) or type(username) ~= "string" or type(password) ~= "string" then
        return false
    end
    if not checkUsername(username) or not checkPassword(password) then
        triggerClientEvent(player, "onClientRegisterResult", resourceRoot, false)
        return false
    end
    exports.mysql:dbQueryAsync("dbRegisterCheckAccount", { player = player, username = username, password = password }, dbTableName, [[
        SELECT * FROM ?? WHERE username = ?;
    ]], username)
end

addEventHandler("onPlayerQuit", root, function ()
    logoutPlayer(source)
end, true, "low")

addEventHandler("onResourceStart", resourceRoot, function ()
    local name = getServerName()
    local pos = string.find(name, "#", 1, true)
    if pos then
        serverId = tonumber(name:sub(pos+1, pos+1)) or 1337
    else
        serverId = 1337
    end
    for i, player in ipairs(getElementsByType("player")) do
        for i, name in ipairs(loadAccountData) do
            player:removeData(name)
        end
    end
    exports.mysql:dbExec(dbTableName, [[
        UPDATE ?? SET online_server = 0 WHERE online_server = ?;
    ]], serverId)
end)

addEventHandler("onResourceStop", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        savePlayerAccount(player, true)
    end

    exports.mysql:dbExec(dbTableName, [[
        UPDATE ?? SET online_server = 0 WHERE online_server = ?;
    ]], serverId)
end)

addCommandHandler("pbreg", function (player, cmd, username, password)
    registerPlayer(player, username, password)
end)

addCommandHandler("pblogin", function (player, cmd, username, password)
    loginPlayer(player, username, password)
end)

addEvent("onPlayerRequestLogin", true)
addEventHandler("onPlayerRequestLogin", root, function (username, password)
    loginPlayer(client, username, password)
end)

addEvent("onPlayerRequestRegister", true)
addEventHandler("onPlayerRequestRegister", root, function (username, password)
    registerPlayer(client, username, password)
end)

addEventHandler("onResourceStart", resourceRoot, function ()
    if not isResourceRunning("mysql") then
        return false
    end

    exports.mysql:dbExec(dbTableName, [[
        CREATE TABLE IF NOT EXISTS ?? (
            username      VARCHAR(64)  NOT NULL PRIMARY KEY,
            password      VARCHAR(128)  NOT NULL,
            serial        VARCHAR(128),
            last_seen     INT           UNSIGNED,

            nickname      VARCHAR(64),
            items         LONGTEXT      NOT NULL,

            battlepoints  BIGINT        UNSIGNED NOT NULL DEFAULT 0,
            donatepoints  BIGINT        UNSIGNED NOT NULL DEFAULT 0,
            crate_level   INT           UNSIGNED NOT NULL DEFAULT 1,

            rating_solo_main   BIGINT   UNSIGNED NOT NULL DEFAULT 0,
            rating_solo_wins   BIGINT   UNSIGNED NOT NULL DEFAULT 0,
            rating_solo_kills  BIGINT   UNSIGNED NOT NULL DEFAULT 0,

            rating_squad_main  BIGINT   UNSIGNED NOT NULL DEFAULT 0,
            rating_squad_wins  BIGINT   UNSIGNED NOT NULL DEFAULT 0,
            rating_squad_kills BIGINT   UNSIGNED NOT NULL DEFAULT 0,

            stats_kills        INT    UNSIGNED NOT NULL DEFAULT 0,
            stats_wins_solo    INT    UNSIGNED NOT NULL DEFAULT 0,
            stats_wins_squad   INT    UNSIGNED NOT NULL DEFAULT 0,
            stats_top10_solo   INT    UNSIGNED NOT NULL DEFAULT 0,
            stats_top10_squad  INT    UNSIGNED NOT NULL DEFAULT 0,
            stats_plays_solo   INT    UNSIGNED NOT NULL DEFAULT 0,
            stats_plays_squad  INT    UNSIGNED NOT NULL DEFAULT 0,
            stats_hp_healed    INT    UNSIGNED NOT NULL DEFAULT 0,
            stats_hp_damage    INT    UNSIGNED NOT NULL DEFAULT 0,
            stats_distance_ped INT    UNSIGNED NOT NULL DEFAULT 0,
            stats_distance_car INT    UNSIGNED NOT NULL DEFAULT 0,
            stats_items_used   INT    UNSIGNED NOT NULL DEFAULT 0,
            stats_deaths       INT    UNSIGNED NOT NULL DEFAULT 0,
            stats_playtime     BIGINT UNSIGNED NOT NULL DEFAULT 0,

            online_server INTEGER UNSIGNED NOT NULL DEFAULT 0,

            clothes_hat     VARCHAR(64),
            clothes_head    VARCHAR(64),
            clothes_body    VARCHAR(64),
            clothes_legs    VARCHAR(64),
            clothes_feet    VARCHAR(64),
            clothes_hair    VARCHAR(64),
            clothes_gloves  VARCHAR(64),
            clothes_mask    VARCHAR(64),
            clothes_glasses VARCHAR(64)
        );
    ]])

    exports.mysql:dbExec(dbTableName, [[
        UPDATE ?? SET online_server = 0 WHERE online_server = ?;
    ]], serverId)
end)

addEventHandler("onElementDataChange", root, function(dataName, oldValue)
    if client then
        if protectData[dataName] then
            source:setData(dataName, oldValue)
        end
    end
end)

addEvent("onPlayerConvertDonatepoints", true)
addEventHandler("onPlayerConvertDonatepoints", root, function (amount)
    if type(amount) ~= "number" then
        return
    end
    local battlepoints = client:getData("battlepoints")
    local donatepoints = client:getData("donatepoints")
    if type(battlepoints) ~= "number" or type(donatepoints) ~= "number" then
        return
    end
    if amount > donatepoints then
        return
    end
    battlepoints = battlepoints + convertDonatepoints(amount)
    donatepoints = donatepoints - amount
    client:setData("battlepoints", battlepoints)
    client:setData("donatepoints", donatepoints)
    savePlayerAccount(client)
    triggerClientEvent(client, "onClientDonatepointsConverted", resourceRoot)
end)
