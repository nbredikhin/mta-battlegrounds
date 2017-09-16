local loadedChunks = {}
local streamedObjects = {}

local prevDimension = 0

function loadChunk(id)
    loadedChunks[id] = true
    triggerServerEvent("onPlayerLoadChunk", resourceRoot, id)
    streamedObjects[id] = {}
end

function unloadChunk(id)
    if not loadedChunks[id] then
        return
    end
    if streamedObjects[id] then
        for objectId, object in pairs(streamedObjects[id]) do
            if isElement(object) then
                destroyElement(object)
            end
        end
    end
    streamedObjects[id] = nil
    triggerServerEvent("onPlayerUnloadChunk", resourceRoot, id)
    loadedChunks[id] = nil
end

function updateChunks()
    local cx, cy = getChunkFromWorldPosition(localPlayer.position.x, localPlayer.position.y)
    local currentChunks = {}
    if prevDimension ~= localPlayer.dimension then
        for id in pairs(loadedChunks) do
            unloadChunk(id)
        end
    elseif prevDimension == localPlayer.dimension then
        currentChunks = {
            [getChunkId(cx, cy)] = true,
            [getChunkId(cx, cy + 1)]     = true,
            [getChunkId(cx + 1, cy + 1)] = true,
            [getChunkId(cx + 1, cy)]     = true,
            [getChunkId(cx + 1, cy - 1)] = true,
            [getChunkId(cx, cy - 1)]     = true,
            [getChunkId(cx - 1, cy - 1)] = true,
            [getChunkId(cx - 1, cy)]     = true,
            [getChunkId(cx - 1, cy + 1)] = true,
        }
    end
    prevDimension = localPlayer.dimension

    for id in pairs(loadedChunks) do
        if not currentChunks[id] then
            unloadChunk(id)
        end
    end

    for id in pairs(currentChunks) do
        if not loadedChunks[id] then
            loadChunk(id)
        end
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    updateChunks()

    setTimer(updateChunks, Config.chunkUpdateInterval, 0)
end)

local function instantiateObject(object)
    if not streamedObjects[object.chunkId] then
        return
    end
    local element = createObject(object.model, object.x, object.y, object.z, object.rx, object.ry, object.rz)

    for name, value in pairs(object.data) do
        element:setData(name, value, false)
    end

    for name, value in pairs(object.props) do
        element[name] = value
    end

    element.dimension = object.dimension

    element:setData("streamed_object_chunk", object.chunkId, false)
    element:setData("streamed_object_id", object.id, false)

    streamedObjects[object.chunkId][object.id] = element
    return element
end

addEvent("onClientChunkStreamIn", true)
addEventHandler("onClientChunkStreamIn", resourceRoot, function (chunkId, objects)
    for id, object in pairs(objects) do
        instantiateObject(object)
    end
end)

addEvent("onClientChunkStreamOut", true)

addEvent("onChunkObjectCreate", true)
addEventHandler("onChunkObjectCreate", resourceRoot, function (object)
    instantiateObject(object)
end)

addEvent("onChunkObjectDestroy", true)
addEventHandler("onChunkObjectDestroy", resourceRoot, function (chunkId, objectId)
    if streamedObjects[chunkId] then
        if isElement(streamedObjects[chunkId][objectId]) then
            destroyElement(streamedObjects[chunkId][objectId])
        end
    end
end)

addEvent("onChunkObjectPropertyChange", true)
addEventHandler("onChunkObjectPropertyChange", resourceRoot, function (chunkId, objectId, key, value)
    if streamedObjects[chunkId] then
        if isElement(streamedObjects[chunkId][objectId]) then
            local element = streamedObjects[chunkId][objectId]
            element[key] = value
        end
    end
end)

addEvent("onChunkObjectDataChange", true)
addEventHandler("onChunkObjectDataChange", resourceRoot, function (chunkId, objectId, key, value)
    if streamedObjects[chunkId] then
        if isElement(streamedObjects[chunkId][objectId]) then
            local element = streamedObjects[chunkId][objectId]
            element:setData(key, value)
        end
    end
end)
