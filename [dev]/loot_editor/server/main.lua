-- Все возможные точки спавна лута
local lootSpawnpoints = {}
local elements = {}

function loadFile(path, count)
    if not fileExists(path) then
        return false
    end
    local file = fileOpen(path)
    if not file then
        return false
    end
    if not count then
        count = fileGetSize(file)
    end
    local data = fileRead(file, count)
    fileClose(file)
    return data
end

function saveFile(path, data)
    if not path then
        return false
    end
    if fileExists(path) then
        fileDelete(path)
    end
    local file = fileCreate(path)
    fileWrite(file, data)
    fileClose(file)
    return true
end

function table.copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.copy(orig_key)] = table.copy(orig_value)
        end
        setmetatable(copy, table.copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function createLootSpawnpoint(position, level)
    if not position then
        return
    end
    level = tonumber(level)
    if not level then
        level = 1
    end
    local spawnpoint = {
        x = position.x,
        y = position.y,
        z = position.z,

        level = level
    }
    table.insert(lootSpawnpoints, spawnpoint)
    instantiateSpawnpoint(spawnpoint)
    saveFile("data/spawnpoints.json", toJSON(lootSpawnpoints))
end

function removeLootSpawnpoint(index)
    table.remove(lootSpawnpoints, index)
    saveFile("data/spawnpoints.json", toJSON(lootSpawnpoints))
end

function instantiateSpawnpoint(spawnpoint)
    local model = 1575
    local r, g, b = 255, 255, 255
    if spawnpoint.level == 2 then
        model = 1576
        r, g, b = 255, 150, 0
    elseif spawnpoint.level == 3 then
        model = 1580
        r, g, b = 255, 0, 0
    end
    local object = createObject(model, spawnpoint.x, spawnpoint.y, spawnpoint.z)
    object:setCollisionsEnabled(false)
    local blip = createBlip(spawnpoint.x, spawnpoint.y, spawnpoint.z, 0, 2, r, g, b, 255, 0, 500)
    elements[spawnpoint] = {
        object, blip
    }
end

addEventHandler("onResourceStart", resourceRoot, function ()
    lootSpawnpoints = fromJSON(loadFile("data/spawnpoints.json") or "[[]]") or {}

    for i, spawnpoint in ipairs(lootSpawnpoints) do
        instantiateSpawnpoint(spawnpoint)
    end

    outputChatBox("Loaded spawnpoints (" .. tostring(#lootSpawnpoints) .. ")")
end)

addCommandHandler("addloot", function (player, cmd, level)
    createLootSpawnpoint(player.position - Vector3(0, 0, 1), level)
    outputChatBox("Spawnpoint added ("..tostring(#lootSpawnpoints) .. ")")
end)

addCommandHandler("removeloot", function (player)
    local spawnpoints = lootSpawnpoints
    local x, y, z = getElementPosition(player)
    for i, spawnpoint in ipairs(spawnpoints) do
        if getDistanceBetweenPoints3D(x, y, z, spawnpoint.x, spawnpoint.y, spawnpoint.z) < 3 then
            if elements[spawnpoint] then
                for i, e in ipairs(elements[spawnpoint]) do
                    destroyElement(e)
                end
            end
            removeLootSpawnpoint(i)
            outputChatBox("Spawnpoint removed")
            break
        end
    end
end)
