local dbTableName = "users"

local loadAccountData = {
    "username",
    "battlepoints",
    "donatpoints",
    "winrating",
    "killrating"
}

local saveAccountData = {
    "battlepoints",
    "donatpoints",
    "winrating",
    "killrating"
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

            online_server INTEGER       UNSIGNED NOT NULL DEFAULT 0
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

    if isLogout then
        table.insert(saveQuery, "online_server = ?")
        table.insert(saveArgs, 0)
    end

    exports.mysql:dbExec(dbTableName, [[
        UPDATE ?? SET ]]
            .. table.concat(saveQuery, ",") ..
        [[;
    ]], unpack(saveArgs))
end

function dbLoginPlayer(result, params)
    if not params or not isElement(params.player) then
        return
    end
    if not result or #result == 0 then
        -- Account not found
        return
    end
    result = result[1]
    local player = params.player

    passwordVerify(params.password, result.password, function (match)
        if not isElement(player) then
            return
        end
        if not match then
            -- Passwords dont match
            return
        end

        for i, name in ipairs(loadAccountData) do
            player:setData(name, result[name])
        end

        setupPlayerInventory(player, result.items)
        loggedPlayers[player] = true

        iprint("Login succ", result.username)
    end)
end

function dbRegisterPlayer(result, params)
    if not params or not isElement(params.player) then
        return
    end
    if not result then
        -- Failed to register
        return
    end
    iprint("Register", result)
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
        return false
    end
    passwordHash(password, "bcrypt", { cost = 10 }, function (password)
        exports.mysql:dbQueryAsync("dbRegisterPlayer", { player = player }, dbTableName, [[
            INSERT INTO ?? (
                username,
                password,
                items
            ) VALUES (?, ?, ?);
        ]], username, password, toJSON(getDefaultInventory()))
    end)
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
    for i, player in ipairs(getElementsByType("player")) do
        for i, name in ipairs(loadAccountData) do
            player:removeData(name)
        end
    end
end)

addCommandHandler("pbreg", function (player, cmd, username, password)
    registerPlayer(player, username, password)
end)

addCommandHandler("pblogin", function (player, cmd, username, password)
    loginPlayer(player, username, password)
end)
