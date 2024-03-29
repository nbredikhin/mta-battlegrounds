local crate

engineSetModelLODDistance(1860, 300)
engineSetModelLODDistance(1861, 300)

local spritesLOD = {
    side = dxCreateTexture("assets/box_sprite.png", "argb", false),
    bottom   = dxCreateTexture("assets/parachute_sprite.png"),
    box   = dxCreateTexture("assets/box_bottom.png"),
}
local crateLODColor = tocolor(255, 255, 255, 255)

local startPosition = Vector3()
local crateZ = 0
local crateSpeed = 5
local crateStopped = false

local crateMatchId

local spawnedCrates = {}

addEventHandler("onClientRender", root, function ()
    if not isElement(crate) then
        return
    end
    local cx, cy, cz = getCameraMatrix()
    local x, y, z = getElementPosition(crate)
    if getDistanceBetweenPoints3D(x, y, z, cx, cy, cz) < 300 then
        return
    end
    if not crateStopped then
        -- Низ парашюта
        local pos1 = crate.matrix:transformPosition(0, -7, 17)
        local pos2 = crate.matrix:transformPosition(0, 7, 17)
        dxDrawMaterialLine3D(pos1, pos2, spritesLOD.bottom, 14, crateLODColor, crate.matrix:transformPosition(0, 0, -10))
        -- Низ коробки
        local pos1 = crate.matrix:transformPosition(0, -0.75, 0)
        local pos2 = crate.matrix:transformPosition(0, 0.7, 0)
        dxDrawMaterialLine3D(pos1, pos2, spritesLOD.box, 1.5, crateLODColor, crate.matrix:transformPosition(0, 0, -10))
    end
    -- Боковая сторона
    pos1 = crate.matrix:transformPosition(0, 0, 20)
    pos2 = crate.matrix:transformPosition(0, 0, -0.2)
    dxDrawMaterialLine3D(pos1, pos2, spritesLOD.side, 15, crateLODColor)
end)

local function getGroundHeight(x, y)
    local hit, x, y, z, element = processLineOfSight(
        x, y, 200,
        x, y, -50,
        true,
        false,
        false,
        true,
        false,
        false,
        false,
        false,
        crate)
    if hit then
        return z
    else
        return false
    end
end

addEventHandler("onClientPreRender", root, function (dt)
    if not isElement(crate) then
        return
    end
    dt = dt / 1000

    if not crateStopped then
        crateZ = crateZ - crateSpeed * dt
        if crateZ < -100 then
            crateZ = -100
        end

        local cx, cy, cz = getCameraMatrix()
        local x, y, z = getElementPosition(crate)
        if getDistanceBetweenPoints3D(x, y, z, cx, cy, cz) > 600 then
            return
        end

        local groundZ = getGroundHeight(x, y)
        if groundZ and crateZ < groundZ then
            crateStopped = true
            crateZ = groundZ
            if crateMatchId and crateMatchId == localPlayer:getData("matchId") then
                triggerServerEvent("onPlayerCrateLanded", resourceRoot, x, y, groundZ)
            end
        end
        setElementPosition(crate, startPosition.x, startPosition.y, crateZ)
    end
end)

addEvent("onClientCrateLanded", true)
addEventHandler("onClientCrateLanded", resourceRoot, function (x, y, z)
    if isElement(crate) then
        destroyElement(crate)
    end
    local object = createObject(1860, x, y, z)
    object.dimension = localPlayer.dimension
    table.insert(spawnedCrates, object)
    crateZ = z
    crateStopped = true
end)

function createCrate(matchId, x, y, z)
    if isElement(crate) then
        destroyElement(crate)
    end
    crateMatchId = matchId

    crate = createObject(1861, x, y, z)
    crate.doubleSided = true
    crate.dimension = localPlayer.dimension

    startPosition = Vector3(x, y, z)
    crateZ = z

    crateStopped = false
end

function destroyCrates()
    if isElement(crate) then
        destroyElement(crate)
    end
    for i, element in ipairs(spawnedCrates) do
        if isElement(element) then
            destroyElement(element)
        end
    end
    crateMatchId = nil
    spawnedCrates = {}
end

function getCrateHeight()
    return crateZ
end
