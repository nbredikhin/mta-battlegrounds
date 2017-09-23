-- Все возможные точки спавна лута
local lootSpawnpoints = {}
-- Точки спавна в чанках
local chunkSpawnpoints = {}

function createLootSpawnpoint(position, level, tag)
    if not position then
        return
    end
    level = tonumber(level)
    if not level then
        level = 1
    end
    if type(tag) ~= "string" then
        tag = nil
    end
    table.insert(lootSpawnpoints, {
        x = position.x,
        y = position.y,
        z = position.z,

        level = level,
        tag   = tag
    })

    saveFile("data/spawnpoints.json", toJSON(lootSpawnpoints))
end

function removeLootSpawnpoint(index)
    table.remove(lootSpawnpoints, index)
    saveFile("data/spawnpoints.json", toJSON(lootSpawnpoints))
end

local function randomChance(chance)
    return math.random() <= chance
end

local function spawnRandomItem(position, tag, level)
    local classes = exports.pb_inventory:getItemClasses(tag, level)
    local itemClass = classes[math.random(1, #classes)]

    local stacks = math.random(1, itemClass.spawnStacks or 1)
    local items = {}
    for i = 1, stacks do
        local item = exports.pb_inventory:createItem(itemClass.name, math.floor(itemClass.spawnCount or 1))

        local offsetX = math.random() * 0.6 - 0.3
        local offsetY = math.random() * 0.6 - 0.3

        table.insert(items, exports.pb_inventory:spawnLootItem(item, position + Vector3(offsetX, offsetY, 0)))
    end

    if itemClass.tag == "weapon" and itemClass.ammo then
        local ammoClass = exports.pb_inventory:getItemClass(itemClass.ammo)
        local ammoItem = exports.pb_inventory:createItem(ammoClass.name, math.floor(ammoClass.spawnCount or 1))
        table.insert(items, exports.pb_inventory:spawnLootItem(ammoItem, position + Vector3(offsetX, offsetY, 0)))
    end

    return items
end

-- Создает (или не создает) случайный item
local function generateSpawnpointItems(spawnpoint)
    if not randomChance(Config.spawnpointChance) then
        return {}
    end

    local items = {}
    local count = Config.itemsCount[math.random(1, Config.itemsCount[spawnpoint.level])]
    local tags = table.copy(Config.lootTags)
    local tag = spawnpoint.tag
    for i = 1, count do
        if not tag then
            local index = math.random(1, #tags)
            tag = tags[index]
            if tag == "equipment" then
                table.remove(tags, index)
            end
        end
        local spawnItems = spawnRandomItem(Vector3(spawnpoint.x, spawnpoint.y, spawnpoint.z), tag, spawnpoint.level)
        if spawnItems and #spawnItems > 0 then
            for i, item in ipairs(spawnItems) do
                table.insert(items, item)
            end
        end
        tag = nil
    end

    return items
end

function getLootSpawnpoints()
    return lootSpawnpoints
end

-- Раскидывает лут в dimension
function generateChunkLoot(chunk, dimension)
    if not chunk then
        return {}
    end
    if not chunkSpawnpoints[chunk.id] then
        return {}
    end

    local spawnedItems = {}
    local spawnpoints = chunkSpawnpoints[chunk.id]
    Async:setPriority("medium")
    Async:foreach(spawnpoints, function(spawnpoint)
        -- Если чанк выгрузился до того, как успели заспавниться все объекты
        if not chunk.loaded then
            return
        end

        local items = generateSpawnpointItems(spawnpoint)
        if items and #items > 0 then
            for i, item in ipairs(items) do
                item.dimension = dimension
                table.insert(spawnedItems, item)
            end
        end
    end)

    return spawnedItems
end

addEventHandler("onResourceStart", resourceRoot, function ()
    lootSpawnpoints = fromJSON(loadFile("data/spawnpoints.json") or "[[]]") or {}

    chunkSpawnpoints = {}
    for i, spawnpoint in ipairs(lootSpawnpoints) do
        local cx, cy = getChunkFromWorldPosition(spawnpoint.x, spawnpoint.y)
        local chunkId = getChunkId(cx, cy)

        if not chunkSpawnpoints[chunkId] then
            chunkSpawnpoints[chunkId] = {}
        end

        table.insert(chunkSpawnpoints[chunkId], spawnpoint)
    end

    math.randomseed(getTickCount())
end)
