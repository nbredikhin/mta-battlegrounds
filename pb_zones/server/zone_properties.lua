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
    { time = 20,  shrink = 5 },
    { time = 30,  shrink = 10 },
    { time = 40,  shrink = 20 },
    { time = 50,  shrink = 30 },
    { time = 60,  shrink = 40 },
    { time = 90,  shrink = 50 },
    { time = 120, shrink = 60 },
    { time = 150, shrink = 70 },
    { time = 180, shrink = 80 },
}

function getZone(index)
    if index >= 1 and index <= ZONES_COUNT then
        return zoneProperties[index]
    else
        return {time = 999, shrink = 999}
    end
end
