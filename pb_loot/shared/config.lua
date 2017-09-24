Config = {}

Config.mapSize    = 6000
Config.chunkSize  = 75
Config.chunkRow   = Config.mapSize / Config.chunkSize
Config.chunkCount = Config.chunkRow * Config.chunkRow
Config.chunkLifetime = 300

-- Шанс появления вещей на точке
Config.spawnpointChances = {
    0.6,
    0.3,
    0.15
}

Config.lootTags = {
    "equipment",
    "weapon",
    "medicine"
}

Config.itemsCount = {
    3, 2, 2
}
