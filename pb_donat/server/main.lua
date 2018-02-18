local ENABLE_X2 = false

local dbTableName = "payments"

local trademcItems = {
    ["278413"] = 100,
    ["278414"] = 250,
    ["278416"] = 500,
    ["278417"] = 1000,
    ["278418"] = 2500,
    ["278419"] = 5000,
    ["278420"] = 10000,
    ["278421"] = 25000,
    ["278423"] = 50000,
}
local paymentsCheckInterval = 60000

addEventHandler("onResourceStart", resourceRoot, function ()
    if not isResourceRunning("mysql") then
        return false
    end

    exports.mysql:dbExec(dbTableName, [[
        CREATE TABLE IF NOT EXISTS ?? (
            id            MEDIUMINT     NOT NULL AUTO_INCREMENT,
            username      VARCHAR(64)   NOT NULL,
            trademc_item  VARCHAR(128),
            status        VARCHAR(64),
            timestamp     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

            PRIMARY KEY (id)
        );
    ]])

    setTimer(checkPendingPayments, paymentsCheckInterval, 0)
end)

function dbPaymentsReceived(result, params)
    if type(result) ~= "table" or #result == 0 then
        return
    end

    local accountPlayers = {}
    for i, player in ipairs(getElementsByType("player")) do
        local username = player:getData("username")
        if username then
            accountPlayers[utf8.lower(username)] = player
        end
    end

    outputDebugString("[DONAT] Checking payments...")

    for i, payment in ipairs(result) do
        local username = utf8.lower(tostring(payment.username))
        local itemId = tostring(payment.trademc_item)
        if isElement(accountPlayers[username]) and trademcItems[itemId] then
            local donatepoints = tonumber(accountPlayers[username]:getData("donatepoints"))
            if donatepoints then
                local giveAmount = trademcItems[itemId]
                if ENABLE_X2 then
                    giveAmount = giveAmount * 2
                end
                donatepoints = donatepoints + giveAmount
                accountPlayers[username]:setData("donatepoints", donatepoints)
                exports.mysql:dbExec(dbTableName, [[
                    UPDATE ?? SET status = 'ok' WHERE id = ?;
                ]], payment.id)
            end

            outputDebugString("[DONAT][PAYMENT] Processed payment: id="..tostring(payment.id).." username='"..tostring(payment.username).."'")
        elseif not trademcItems[itemId] then
            exports.mysql:dbExec(dbTableName, [[
                UPDATE ?? SET status = 'no_item' WHERE id = ?;
            ]], payment.id)
        end
    end
end

function checkPendingPayments()
    exports.mysql:dbQueryAsync("dbPaymentsReceived", { }, dbTableName, [[
        SELECT * FROM ?? WHERE status = 'pending';
    ]])
end
