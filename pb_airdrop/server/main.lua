local planeDistance = 3200
local planeZ = 200
local planeSpeed = 85

local landedAirdrops = {}

function createAirDrop(matchId, x, y)
    if not matchId or not x or not y then
        return
    end
    local players = exports.pb_gameplay:getAllMatchPlayers(matchId)
    if type(players) ~= "table" or #players == 0 then
        return
    end
    -- Запуск самолёта
    local sx, sy = math.random(-3000, 3000), math.random(-3000, 3000)
    local side = math.random(1, 4)
    if side == 1 then
        sy = planeDistance
    elseif side == 2 then
        sx = planeDistance
    elseif side == 3 then
        sy = -planeDistance
    elseif side == 4 then
        sx = -planeDistance
    end
    local vectorX = x - sx
    local vectorY = y - sy

    local len = getDistanceBetweenPoints2D(0, 0, vectorX, vectorY)
    local velocityX = vectorX / len * planeSpeed
    local velocityY = vectorY / len * planeSpeed

    local dropTime = vectorX / velocityX

    local angle = math.deg(math.atan2(vectorY, vectorX)) - 90
    outputDebugString("[AIRDROP] Airdrop created in match " .. tostring(matchId) .. " (" .. tostring(#players) .. " players)")
    landedAirdrops[matchId] = nil
    triggerClientEvent(players, "createAirDrop", resourceRoot, matchId, sx, sy, planeZ, angle, velocityX, velocityY, dropTime, x, y)
end

function createAirDropWithinZone(matchId, zoneX, zoneY, zoneRadius)
    if not zoneX or not zoneY or not zoneRadius then
        return
    end
    local zonePoints = {}
    for i, point in ipairs(DropPoints) do
        if getDistanceBetweenPoints2D(zoneX, zoneY, point[1], point[2]) < zoneRadius then
            table.insert(zonePoints, point)
        end
    end
    if #zonePoints == 0 then
        return false
    end
    local point
    if #zonePoints > 1 then
        point = zonePoints[math.random(1, #zonePoints)]
    else
        point = zonePoints[1]
    end
    return createAirDrop(matchId, point[1], point[2])
end

addEvent("onPlayerCrateLanded", true)
addEventHandler("onPlayerCrateLanded", resourceRoot, function (x, y, z)
    local matchId = client:getData("matchId")
    if not matchId then
        return
    end
    if landedAirdrops[matchId] then
        return
    end
    landedAirdrops[matchId] = true
    local players = exports.pb_gameplay:getAllMatchPlayers(matchId)
    if type(players) ~= "table" or #players == 0 then
        return
    end
    for i, player in ipairs(players) do
        if isElement(player) and player:getData("matchId") == matchId then
            triggerClientEvent(player, "onClientCrateLanded", resourceRoot, x, y, z)
        end
    end
    outputDebugString("[AIRDROP] Airdrop landed in match " .. tostring(matchId) .. " (" .. tostring(#players) .. " players)")
    triggerEvent("onAirdropLanded", resourceRoot, matchId, x, y, z)
end)
