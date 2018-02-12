local dbTableName = "payments"
-- local trademcShopId = 71772
-- local trademcItems = nil
-- local trademcAPI = "https://api.trademc.org/"
-- local trademcRetryDelay = 30000

local trademcItems = {
    ["278413"] = { donatepoints = 100 },
    ["278414"] = { donatepoints = 250 },
    ["278416"] = { donatepoints = 500 },
    ["278417"] = { donatepoints = 1000 },
    ["278418"] = { donatepoints = 2500 },
    ["278419"] = { donatepoints = 5000 },
    ["278420"] = { donatepoints = 10000 },
    ["278421"] = { donatepoints = 25000 },
    ["278423"] = { donatepoints = 50000 },
}
local paymentsCheckInterval = 60000

local function requireShopItems()
    -- outputDebugString("[DONAT] Require TradeMC shop items...")
    -- local paramsString = "params[shop]="..tostring(trademcShopId)
    -- fetchRemote(trademcAPI.."shop.getItems?"..paramsString, function (response, errno)
    --     if errno ~= 0 then
    --         outputDebugString("[DONAT][ERROR] Failed to get shop items (code "..tostring(errno).."). Waiting for retry...")
    --         setTimer(requireShopItems, trademcRetryDelay, 1)
    --         return
    --     end
    --     local data = fromJSON(response)
    --     if not data or not data.response or not data.response.categories then
    --         outputDebugString("[DONAT][ERROR] Failed to parse shop items. Waiting for retry...")
    --         setTimer(requireShopItems, trademcRetryDelay, 1)
    --         return
    --     end
    --     if data.error then
    --         outputDebugString("[DONAT][ERROR] Failed to get items. Error: " .. tostring(data.error))
    --         setTimer(requireShopItems, trademcRetryDelay, 1)
    --         return
    --     end

    --     trademcItems = {}
    --     local count = 0
    --     local totalCount = 0
    --     for i, category in ipairs(data.response.categories) do
    --         for j, item in ipairs(category.items) do
    --             totalCount = totalCount + 1
    --             if item.id and type(item.name) == "string" then
    --                 local pos = utf8.find(item.name, " ")
    --                 if pos then
    --                     local amount = tonumber(utf8.sub(item.name, 1, pos - 1))
    --                     if amount then
    --                         trademcItems[tostring(item.id)] = {
    --                             name = item.name,
    --                             price = item.cost,
    --                             donatepoints = amount,
    --                         }
    --                         count = count + 1
    --                     end
    --                 end
    --             end
    --         end
    --     end
    --     if next(trademcItems) then
    --         outputDebugString("[DONAT] Loaded "..count.."/"..totalCount.." item(s)")
    --     else
    --         if totalCount > 0 then
    --             outputDebugString("[DONAT][WARNING] No valid items in shop. Total items count: "..tostring(totalCount))
    --         else
    --             outputDebugString("[DONAT][WARNING] No valid items in shop")
    --         end
    --         trademcItems = nil
    --     end
    -- end)
end

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

    requireShopItems()
    setTimer(checkPendingPayments, paymentsCheckInterval, 0)
end)

addCommandHandler("updateshop", function (player, cmd)
    if not isPlayerAdmin(player) then
        return
    end
    requireShopItems()
end)

function dbPaymentsReceived(result, params)
    if type(result) ~= "table" or #result == 0 then
        return
    end
    if not trademcItems then
        return
    end

    local accountPlayers = {}
    for i, player in ipairs(getElementsByType("player")) do
        local username = player:getData("username")
        if username then
            accountPlayers[username] = player
        end
    end

    for i, payment in ipairs(result) do
        local username = tostring(payment.username)
        local itemId = tostring(payment.trademc_item)
        if isElement(accountPlayers[username]) and trademcItems[itemId] then
            if type(trademcItems[itemId].donatepoints) == "number" then
                local donatepoints = tonumber(accountPlayers[username]:getData("donatepoints"))
                if donatepoints then
                    donatepoints = donatepoints + trademcItems[itemId].donatepoints
                    accountPlayers[username]:setData("donatepoints", donatepoints)
                    exports.mysql:dbExec(dbTableName, [[
                        UPDATE ?? SET status = 'ok' WHERE id = ?;
                    ]], payment.id)
                end
            end

            outputDebugString("[DONAT][PAYMENT] Processed payment: id="..tostring(payment.id).." username='"..tostring(payment.username).."'")
        end
    end
end

function checkPendingPayments()
    if not trademcItems then
        return
    end

    exports.mysql:dbQueryAsync("dbPaymentsReceived", { }, dbTableName, [[
        SELECT * FROM ?? WHERE status = 'pending';
    ]])
end
