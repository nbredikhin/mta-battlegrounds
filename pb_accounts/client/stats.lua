function addStatsField(name, count)
    if type(name) ~= "string" then
        return
    end
    if not count then
        count = 1
    end

    triggerServerEvent("onPlayerStatsFieldAdd", resourceRoot, name, count)
end

local previousPosition = localPlayer.position
local distancePed = 0
local distanceCar = 0

setTimer(function ()
    if not localPlayer:getData("matchId") then
        return
    end

    local distance = (previousPosition - localPlayer.position).length
    previousPosition = localPlayer.position
    if distance > 80 then
        return
    end
    local mul = 1.25
    if localPlayer.vehicle or localPlayer:getData("isInPlane") then
        distanceCar = distanceCar + distance * mul
    else
        distancePed = distancePed + distance * mul
    end

    if distanceCar > 1000 then
        addStatsField("stats_distance_car", 1)
        distanceCar = 0
    end

    if distancePed > 1000 then
        addStatsField("stats_distance_ped", 1)
        distancePed = 0
    end
end, 1000, 0)
