function getChunkFromWorldPosition(worldX, worldY)
    local x = math.floor((worldX + 3000) / Config.chunkSize)
    local y = math.floor((worldY + 3000) / Config.chunkSize)

    x = math.max(1, math.min(Config.chunkRow, x))
    y = math.max(1, math.min(Config.chunkRow, y))
    return x, y
end

function getChunkId(x, y)
    x = math.max(1, math.min(Config.chunkRow, x))
    y = math.max(1, math.min(Config.chunkRow, y))
    return x + Config.chunkRow * (y - 1)
end

function getChunkPosition(id)
    local x = (id - 1) % Config.chunkRow + 1
    local y = math.floor(id / Config.chunkRow) + 1
    return x, y
end
