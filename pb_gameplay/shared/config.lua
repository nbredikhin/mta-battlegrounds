Config = {}

Config.maxSquadPlayers = 4
Config.maxMatchPlayers = 100

Config.minMatchPlayers = 32

-- В секундах
Config.matchWaitingTime = 60
Config.matchEndedTime = 61

Config.zonesStartTime = 95

Config.zonesTime = {
    -- Нулевая область
    [0] = { wait = 30, shrink = 10 },
    -- Самая маленькая область
    { wait = 30,  shrink = 15 },
    { wait = 40,  shrink = 20 },
    { wait = 60,  shrink = 30 },
    { wait = 80,  shrink = 40 },
    { wait = 100, shrink = 60 },
    { wait = 120, shrink = 80 },
    { wait = 240, shrink = 140 },
    -- Первая область на всю карту
    { wait = 0,   shrink = 0 },
}

Config.redZoneTimeMin = 70
Config.redZoneTimeMax = 120
Config.redZoneMinPlayers = 10

Config.airdropTimeMin = 180
Config.airdropTimeMax = 300

Config.airdropItems = {
    medkit         = {0, 2},
    helmet3        = {0, 1},
    armor3         = {0, 1},
    weapon_grenade = {0, 2},
    backpack3      = {0, 1},
    painkiller     = {0, 3},
    energy_drink   = {0, 1},
    weapon_m4      = {0, 1},
    ammo_556mm     = {15, 60},
    ammo_762mm     = {15, 60},
    mghilie1       = {0, 1},
    mghilie2       = {0, 1},
}

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

Config.overrideWeaponProperties = {
    ["uzi"] = {
        damage = 11,
        weapon_range = 25
    },
    ["mp5"] = {
        damage = 16,
        weapon_range = 38
    },
    ["ak47"] = {
        damage = 32,
    },
}
