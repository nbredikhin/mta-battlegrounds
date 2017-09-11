local currentStats = {
    shots_hit = 0,
    shots_total = 0,
}

function resetMatchStats()
    for name, value in pairs(currentStats) do
        currentStats[name] = 0
    end
end

function getMatchStats()
    return table.copy(currentStats)
end

function setMatchStats(name, value)
    if name then
        currentStats[name] = tonumber(value) or 0
    end
end

function addMatchStats(name, value)
    if name then
        currentStats[name] = currentStats[name] + (tonumber(value) or 0)
    end
end

addEventHandler("onClientPlayerWeaponFire", localPlayer, function (weapon, _, _, x, y, z, element)
    addMatchStats("shots_total", 1)

    if isElement(element) then
        if element.type == "player" or element.type == "vehicle" then
            addMatchStats("shots_hit", 1)
        end
    end
end)
