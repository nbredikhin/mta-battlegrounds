ZONES_COUNT = 9
local SMALL_ZONE_RADIUS = 30
local GAME_MAP_SIZE = 6000

local radiusMultipliers = {
    0.5,
    0.5,
    0.53,
    0.5,
    0.55,
    0.6,
    0.7,
}

local function generateFirstZone()
    local x, y = unpack(ZonePoints[math.random(1, #ZonePoints)])
    local radius = SMALL_ZONE_RADIUS / GAME_MAP_SIZE

    return x, y, radius
end

local function getRandomPoint(radius)
    local a = math.random()
    local b = math.random()
    return b*radius*math.cos(2*math.pi*a/b), b*radius*math.sin(2*math.pi*a/b)
end

function generateZones()
    local zones = {}
    -- Самая маленькая зона
    local zx, zy, zradius = generateFirstZone()
    table.insert(zones, {zx, zy, zradius})

    for i = 1, ZONES_COUNT - 2 do
        local pradius = zradius
        zradius = zradius / radiusMultipliers[i]
        local ox, oy = getRandomPoint(zradius - pradius)
        zx = zx + ox
        zy = zy + oy

        table.insert(zones, {zx, zy, zradius})
    end
    -- Начальная зона вокруг всей карты
    table.insert(zones, {0.5, 0.5, 0.8})

    -- Переход в абсолютные координаты
    for i, zone in ipairs(zones) do
        zone[1] = zone[1] * GAME_MAP_SIZE - GAME_MAP_SIZE / 2
        zone[2] = (GAME_MAP_SIZE - zone[2] * GAME_MAP_SIZE) - GAME_MAP_SIZE / 2
        zone[3] = zone[3] * GAME_MAP_SIZE
    end
    return zones
end
