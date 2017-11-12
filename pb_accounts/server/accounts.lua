local dbTableName = "users"
local serverId = 0

local clothesData = {
    "clothes_head",
    "clothes_shirt",
    "clothes_pants",
    "clothes_shoes"
}

local loadAccountData = {
    "username",
    "battlepoints",
    "donatepoints",
    "rating_wins",
    "rating_kills",
    "clothes_head",
    "clothes_shirt",
    "clothes_pants",
    "clothes_shoes",
}

local saveAccountData = {
    "battlepoints",
    "donatepoints",
    "rating_wins",
    "rating_kills",
    "clothes_head",
    "clothes_shirt",
    "clothes_pants",
    "clothes_shoes"
}

local loggedPlayers = {}

addEventHandler("onResourceStart", resourceRoot, function ()
    if not isResourceRunning("mysql") then
        return false
    end

    exports.mysql:dbExec(dbTableName, [[
        CREATE TABLE IF NOT EXISTS ?? (
            username      VARCHAR(255)  NOT NULL PRIMARY KEY,
            password      VARCHAR(255)  NOT NULL,

            items         LONGTEXT      NOT NULL,

            battlepoints  BIGINT        UNSIGNED NOT NULL DEFAULT 0,
            donatepoints  BIGINT        UNSIGNED NOT NULL DEFAULT 0,

            rating_wins   BIGINT        UNSIGNED NOT NULL DEFAULT 0,
            rating_kills  BIGINT        UNSIGNED NOT NULL DEFAULT 0,

            online_server INTEGER       UNSIGNED NOT NULL DEFAULT 0,

            clothes_head  VARCHAR(255),
            clothes_shirt VARCHAR(255),
            clothes_pants VARCHAR(255),
            clothes_shoes VARCHAR(255)
        );
    ]])
end)

function isPlayerLoggedIn(player)
    if not isElement(player) then
        return false
    end
    return not not player:getData("username")
end

function savePlayerAccount(player, isLogout)
    if not isPlayerLoggedIn(player) then
        return
    end

    local saveQuery = {}
    local saveArgs = {}

    for i, name in ipairs(saveAccountData) do
        local value = player:getData(name)
        table.insert(saveQuery, tostring(name) .. " = ?")
        table.insert(saveArgs, value)
    end

    table.insert(saveQuery, "items = ?")
    table.insert(saveArgs, toJSON(getPlayerInventory(player)))

    if isLogout then
        table.insert(saveQuery, "online_server = ?")
        table.insert(saveArgs, 0)
    end

    table.insert(saveArgs, player:getData("username"))

    exports.mysql:dbExec(dbTableName, [[
        UPDATE ?? SET ]]
            .. table.concat(saveQuery, ",") ..
        [[ WHERE username = ?;
    ]], unpack(saveArgs))
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
            player:setData("clothes_head", "head1")
        end
        setupPlayerInventory(player, fromJSON(result.items))
        giveMissingPlayerClothes(player)
        loggedPlayers[player] = true

        exports.mysql:dbExec(dbTableName, [[
            UPDATE ?? SET online_server = ? WHERE username = ?;
        ]], serverId, result.username)

        triggerClientEvent("onClientLoginSuccess", root)
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
    savePlayerAccount(source, true)
end)

setTimer(function ()
    for player in pairs(loggedPlayers) do
        if not isElement(player) then
            savePlayerAccount(player, true)
            loggedPlayers[player] = nil
        end
    end
end, 15000, 0)

addEventHandler("onResourceStart", resourceRoot, function ()
    --serverId =
    for i, player in ipairs(getElementsByType("player")) do
        for i, name in ipairs(loadAccountData) do
            player:removeData(name)
        end
    end
end)

addEventHandler("onResourceStop", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        savePlayerAccount(player, true)
    end
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
