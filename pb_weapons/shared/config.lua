Config = {}

--------------------------------------------
-- Настройки камеры для всех видов оружия --
--------------------------------------------

Config.weaponCameraOffsets = {}

-- MP5
Config.weaponCameraOffsets[29] = {
    x = 0.142, y = 0, z = 0.3,
    ducked = { x = 0.2, y = 0, z = 0 },
    keepTarget = true,
}

-- AK-47
Config.weaponCameraOffsets[30] = {
    x = 0.142, y = 0, z = 0.46,
    ducked = { x = 0.2, y = 0, z = 0.23 }
}

-- M4
Config.weaponCameraOffsets[31] = Config.weaponCameraOffsets[30]

-- Tec-9
Config.weaponCameraOffsets[32] = {
    x = 0.142, y = -0.5, z = 0.7,
    ducked = { x = 0.2, y = -0.2, z = 0.23 }
}

-- Rifle
Config.weaponCameraOffsets[33] = {
    x = 0.17, y = -0.4, z = 0.8,
    ducked = { x = 0.2, y = -0.4, z = 0.23 },
}

-- Sniper
Config.weaponCameraOffsets[34] = {
    x = 0.17, y = -0.4, z = 0.8,
    ducked = { x = 0.2, y = -0.4, z = 0.23 },
}