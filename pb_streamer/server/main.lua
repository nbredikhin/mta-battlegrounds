local chunkMap = {}

local objectsTable = {}

local function getEmptyChunk(id)
    return {
        id      = id,
        players = {},
        objects = {}
    }
end

-- getChunk(dimension, id)
function getChunk(dimension, x, y)
    local id = x
    if y then
        id = getChunkId(x, y)
    end

    if not chunkMap[dimension] then
        chunkMap[dimension] = {}
    end
    if not chunkMap[dimension][id] then
        chunkMap[dimension][id] = getEmptyChunk(id)
    end
    return chunkMap[dimension][id]
end

function addChunkPlayer(chunk, player)
    if not chunk or not isElement(player) then
        return
    end

    chunk.players[player] = true
    triggerClientEvent(player, "onClientChunkStreamIn", resourceRoot, chunk.id, chunk.objects)
end

function removeChunkPlayer(chunk, player)
    if not chunk or not player then
        return
    end

    triggerClientEvent(player, "onClientChunkStreamOut", resourceRoot, chunk.id)
    chunk.players[player] = nil
end

function triggerChunkEvent(chunk, ...)
    if not chunk then
        return false
    end

    for player in pairs(chunk.players) do
        triggerClientEvent(player, ...)
    end

    return true
end

addEvent("onPlayerLoadChunk", true)
addEventHandler("onPlayerLoadChunk", resourceRoot, function (id)
    local chunk = getChunk(client.dimension, id)
    if chunk then
        addChunkPlayer(chunk, client)
    end
end)

addEvent("onPlayerUnloadChunk", true)
addEventHandler("onPlayerUnloadChunk", resourceRoot, function (id)
    for dimension in pairs(chunkMap) do
        if client.dimension ~= dimension then
            local chunk = getChunk(dimension, id)
            if chunk then
                removeChunkPlayer(chunk, client)
            end
        end
    end
end)

function createStaticObject(model, dimension, x, y, z, rx, ry, rz)
    local id = 1
    while objectsTable[id] do
        id = id + 1
    end

    local cx, cy = getChunkFromWorldPosition(x, y)
    local chunk = getChunk(dimension, cx, cy)
    objectsTable[id] = {
        chunkId = chunk.id,
        id = id,
        model = model,
        dimension = dimension,
        x = x,
        y = y,
        z = z,
        rx = rx or 0,
        ry = ry or 0,
        rz = rz or 0,
        props = {},
        data = {}
    }

    chunk.objects[id] = objectsTable[id]

    triggerChunkEvent(chunk, "onChunkObjectCreate", resourceRoot, objectsTable[id])
    return id
end

function destroyStaticObject(id)
    if not id or not objectsTable[id] then
        return false
    end

    local object = objectsTable[id]
    local chunk = getChunk(object.dimension, object.chunkId)
    if chunk then
        chunk.objects[id] = nil

        triggerChunkEvent(chunk, "onChunkObjectDestroy", resourceRoot, chunk.id, id)
    end
    objectsTable[id] = nil
end

function setObjectProperty(id, key, value)
    if not id or not objectsTable[id] then
        return false
    end
    local object = objectsTable[id]
    object.props[key] = value

    triggerChunkEvent(chunk, "onChunkObjectPropertyChange", resourceRoot, object.chunkId, object.id, key, value)
    return true
end

function setObjectData(id, key, value)
    if not id or not objectsTable[id] then
        return false
    end
    local object = objectsTable[id]
    object.data[key] = value

    triggerChunkEvent(chunk, "onChunkObjectDataChange", resourceRoot, object.chunkId, object.id, key, value)
end

function getObjectData(id, key)
    if not id or not objectsTable[id] then
        return false
    end
    local object = objectsTable[id]
    return object.data[key]
end
