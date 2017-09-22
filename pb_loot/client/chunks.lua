local loadedChunks = {}
local prevDimension = 0

function loadChunk(id)
    loadedChunks[id] = true
    iprint("load", id)
    triggerServerEvent("onPlayerRequireChunk", resourceRoot, id)
end

function unloadChunk(id)
    if not loadedChunks[id] then
        return
    end
    loadedChunks[id] = nil
end

function updateChunks()
    if localPlayer.dimension == 0 then
        for id in pairs(loadedChunks) do
            unloadChunk(id)
        end
        return
    end
    if localPlayer.vehicle and localPlayer.vehicle.velocity.length > 0.81 then
        return
    end
    local cx, cy = getChunkFromWorldPosition(localPlayer.position.x, localPlayer.position.y)
    local currentChunks = {}
    if prevDimension ~= localPlayer.dimension then
        for id in pairs(loadedChunks) do
            unloadChunk(id)
        end
    elseif prevDimension == localPlayer.dimension then
        currentChunks = {
            [getChunkId(cx,     cy)]     = true,
            [getChunkId(cx,     cy + 1)] = true,
            [getChunkId(cx + 1, cy + 1)] = true,
            [getChunkId(cx + 1, cy)]     = true,
            [getChunkId(cx + 1, cy - 1)] = true,
            [getChunkId(cx,     cy - 1)] = true,
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

setTimer(updateChunks, 500, 0)
