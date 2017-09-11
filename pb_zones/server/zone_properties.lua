local zoneProperties = {
    -- { time = 2,  shrink = 2 }, -- Нулевая зона
    -- { time = 1,  shrink = 1 },
    -- { time = 1,  shrink = 1 },
    -- { time = 1,  shrink = 1 },
    -- { time = 1,  shrink = 1 },
    -- { time = 1,  shrink = 1 },
    -- { time = 1,  shrink = 1 },
    -- { time = 1,  shrink = 1 },
    -- { time = 1,  shrink = 1 },
    { time = 60,  shrink = 5 },
    { time = 70,  shrink = 15 },
    { time = 80,  shrink = 20 },
    { time = 90,  shrink = 30 },
    { time = 100, shrink = 35 },
    { time = 120, shrink = 40 },
    { time = 140, shrink = 50 },
    { time = 180, shrink = 60 },
    { time = 300, shrink = 120 },
}

function getZone(index)
    if index >= 1 and index <= ZONES_COUNT then
        return zoneProperties[index]
    else
        return {time = 999, shrink = 999}
    end
end
