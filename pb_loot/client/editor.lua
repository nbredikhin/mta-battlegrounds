local currentSpawnpoints = {}

local function hideSpawnpoints()
    for i, element in ipairs(currentSpawnpoints) do
        if isElement(element) then
            destroyElement(element)
        end
    end

    currentSpawnpoints = {}
end

addEvent("showLootSpawnpoints", true)
addEventHandler("showLootSpawnpoints", resourceRoot, function (spawnpoints)
    hideSpawnpoints()

    for i, spawnpoint in ipairs(spawnpoints) do
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
        table.insert(currentSpawnpoints, object)
        local blip = createBlip(spawnpoint.x, spawnpoint.y, spawnpoint.z, 0, 2, r, g, b, 255, 0, 500)
        table.insert(currentSpawnpoints, blip)
    end
end)
