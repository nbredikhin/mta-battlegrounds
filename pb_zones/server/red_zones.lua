function createRedZone(players, x, y)
    triggerClientEvent(players, "onRedZoneCreated", resourceRoot, x, y, getTickCount())
end

-- local pos = getRandomPlayer().position
-- setTimer(createRedZone, 1000, 1, root, pos.x, pos.y)
