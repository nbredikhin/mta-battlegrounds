local loadedChunks = {}

local function loadChunk(dimension, cx, cy)
    local chunk = {
        id        = getChunkId(cx, cy),
        dimension = dimension,
        x         = x,
        y         = y,
        ticks     = 0,
        loaded    = true
    }
    chunk.elements = generateChunkLoot(chunk, dimension)
    return chunk
end

local function unloadChunk(chunk, keepElements)
    if not chunk then
        return false
    end

    chunk.loaded = false

    if not keepElements and #chunk.elements > 0 then
        Async:setPriority("low")
        Async:foreach(chunk.elements, function(element)
            if isElement(element) then
                destroyElement(element)
            end
        end)
    end

    loadedChunks[chunk.dimension][chunk.id] = nil
end

-- Спавн нового лута в чанке с координатами cx, cy
function requireLootAt(dimension, cx, cy)
    if not dimension or dimension == 0 then
        return
    end
    if not loadedChunks[dimension] then
        loadedChunks[dimension] = {}
    end
    local id = getChunkId(cx, cy)
    if not loadedChunks[dimension][id] then
        loadedChunks[dimension][id] = loadChunk(dimension, cx, cy)
    end
    local chunk = loadedChunks[dimension][id]

    chunk.ticks = Config.chunkLifetime
end

function unloadDimension(dimension)
    if not dimension or not loadedChunks[dimension] then
        return false
    end
    local elementsToDestroy = {}
    for id, chunk in pairs(loadedChunks[dimension]) do
        unloadChunk(chunk, true)
        for i, element in ipairs(chunk.elements) do
            table.insert(elementsToDestroy, element)
        end
    end
    loadedChunks[dimension] = {}

    -- Удаление всех элементов в одном потоке
    Async:setPriority("low")
    Async:foreach(elementsToDestroy, function(element)
        if isElement(element) then
            destroyElement(element)
        end
    end)
end

setTimer(function ()
    for dimension, chunks in pairs(loadedChunks) do
        for id, chunk in pairs(chunks) do
            chunk.ticks = chunk.ticks - 1
            if chunk.ticks <= 0 then
                unloadChunk(chunk)
            end
        end
    end
end, 1000, 0)

setTimer(function ()
    for i, player in ipairs(getElementsByType("player")) do
        if player.dimension ~= 0 then
            local cx, cy = getChunkFromWorldPosition(player.position.x, player.position.y)
            local dimension = player.dimension
            requireLootAt(dimension, cx,     cy)
            requireLootAt(dimension, cx,     cy + 1)
            requireLootAt(dimension, cx + 1, cy + 1)
            requireLootAt(dimension, cx + 1, cy)
            requireLootAt(dimension, cx + 1, cy - 1)
            requireLootAt(dimension, cx,     cy - 1)
            requireLootAt(dimension, cx - 1, cy - 1)
            requireLootAt(dimension, cx - 1, cy)
            requireLootAt(dimension, cx - 1, cy + 1)
        end
    end
end, math.floor(Config.chunkLifetime * 1000 / 2), 0)

addEvent("onPlayerRequireChunk", true)
addEventHandler("onPlayerRequireChunk", resourceRoot, function (id)
    -- iprint(client, "require", client.dimension, id)
    requireLootAt(client.dimension, getChunkPosition(id))
end)
