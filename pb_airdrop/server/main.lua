local planeDistance = 3200
local planeZ = 200
local planeSpeed = 85

local groupCounter = 1
local playerGroups = {}
local eventGroups = {}

function createAirDrop(players, x, y)
    if not players or not x or not y then
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
    triggerClientEvent(players, "createAirDrop", resourceRoot, sx, sy, planeZ, angle, velocityX, velocityY, dropTime, x, y)

    eventGroups[groupCounter] = players
    for i, player in ipairs(players) do
        playerGroups[player] = groupCounter
    end
    groupCounter = groupCounter + 1
end

function createAirDropWithinZone(players, zoneX, zoneY, zoneRadius)
    if not players or not zoneX or not zoneY or not zoneRadius then
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
    return createAirDrop(players, point[1], point[2])
end

addEvent("onPlayerCrateLanded", true)
addEventHandler("onPlayerCrateLanded", resourceRoot, function (x, y, z)
    local matchId = client:getData("matchId")
    if not matchId then
        return
    end
    if not playerGroups[client] then
        return
    end
    local group = playerGroups[client]
    if not eventGroups[group] then
        return
    end
    for i, player in ipairs(eventGroups[group]) do
        if isElement(player) and player:getData("matchId") == matchId then
            triggerClientEvent(player, "onClientCrateLanded", resourceRoot, x, y, z)
            playerGroups[player] = nil
        end
    end
    eventGroups[group] = nil
    triggerEvent("onAirdropLanded", resourceRoot, matchId, x, y, z)
end)
