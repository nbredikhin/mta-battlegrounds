local currentStats = {
    killsCount   = 0,
    damageGiven  = 0,
    damageTaken  = 0,
    healedHealth = 0,
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
