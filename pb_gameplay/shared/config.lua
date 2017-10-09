Config = {}

Config.maxSquadPlayers = 4
Config.maxMatchPlayers = 100

Config.minMatchSquads = 25

-- В секундах
Config.matchWaitingTime = 60
Config.matchEndedTime = 61

Config.zonesStartTime = 95

Config.zonesTime = {
    -- Нулевая область
    [0] = { wait = 30, shrink = 20 },
    -- Самая маленькая область
    { wait = 30,  shrink = 20 },
    { wait = 40,  shrink = 30 },
    { wait = 60,  shrink = 40 },
    { wait = 80,  shrink = 50 },
    { wait = 100, shrink = 70 },
    { wait = 120, shrink = 100 },
    { wait = 240, shrink = 200 },
    -- Первая область на всю карту
    { wait = 0,   shrink = 0 },
}

Config.redZoneTimeMin = 70
Config.redZoneTimeMax = 120
Config.redZoneMinPlayers = 10

Config.planeSpeed = 100
Config.planeZ = 650
Config.planeDistance = 3500
Config.planeCameraDistance = 50
Config.autoParachuteDistance = 2650

Config.waitingPosition = Vector3({ x = 761.044, y = -3262.803, z = 4.160})

Config.weathers = {
    { name = "sunny",  id = 1 },
    { name = "fog",    id = 9 },
}
