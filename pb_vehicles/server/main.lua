-- Все возможные точки спавна лута
local vehicleSpawnpoints = {}

local vehicleModels = {
    [400] = {
        400, 500, 579, 489
    },

    [426] = {
        426, 445, 507, 585, 466, 492, 546, 551, 516, 467, 547, 405, 580, 550, 566
    }
}


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

function createVehicleSpawnpoints(model, position, rotation)
    if not position then
        return
    end
    table.insert(vehicleSpawnpoints, {
        x = position.x,
        y = position.y,
        z = position.z,

        rx = rotation.x,
        ry = rotation.y,
        rz = rotation.z,

        model = model
    })

    saveFile("data/spawnpoints.json", toJSON(vehicleSpawnpoints))
end

addCommandHandler("addcar", function (player)
    if not player.vehicle then
        return
    end
    createVehicleSpawnpoints(player.vehicle.model, player.vehicle.position, player.vehicle.rotation)

    local vehicle = createVehicle(player.vehicle.model, player.vehicle.position, player.vehicle.rotation)
    vehicle.frozen = true
    vehicle:setCollisionsEnabled(false)
    createBlip(player.vehicle.position)

    outputChatBox("Car added")
end)

local function randomChance(chance)
    return math.random() <= chance
end

-- Раскидывает лут в dimension
function generateVehicles(dimension)
    local spawnedVehicles = {}

    for i, spawnpoint in ipairs(vehicleSpawnpoints) do
        if randomChance(0.6) then
            local model = spawnpoint.model
            if vehicleModels[model] then
                model = vehicleModels[model][math.random(1, #vehicleModels[model])]
            end
            local vehicle = createVehicle(model, spawnpoint.x, spawnpoint.y, spawnpoint.z, spawnpoint.rx, spawnpoint.ry, spawnpoint.rz)
            vehicle.dimension = dimension
            table.insert(spawnedVehicles, vehicle)
        end
    end

    return spawnedVehicles
end

addEventHandler("onResourceStart", resourceRoot, function ()
    vehicleSpawnpoints = fromJSON(loadFile("data/spawnpoints.json") or "[[]]") or {}

    for i, s in ipairs(vehicleSpawnpoints) do
        local vehicle = createVehicle(s.model, s.x, s.y, s.z, s.rx, s.ry, s.rz)
        vehicle.frozen = true
        vehicle:setCollisionsEnabled(false)
        createBlip(s.x, s.y, s.z)
    end
end)
