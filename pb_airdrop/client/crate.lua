-- local object = createObject(1861, localPlayer.position + Vector3(0, 245, 200))
-- local pos = localPlayer.position + Vector3(0, 15, 7)
-- local pos = localPlayer.position + Vector3(0, 245, 200)
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

addEventHandler("onClientPreRender", root, function (dt)
    if not isElement(crate) then
        return
    end
    dt = dt / 1000

    if not crateStopped then
        crateZ = crateZ - crateSpeed * dt

        local cx, cy, cz = getCameraMatrix()
        local x, y, z = getElementPosition(crate)
        if getDistanceBetweenPoints3D(x, y, z, cx, cy, cz) > 600 then
            return
        end

        local groundZ = getGroundPosition(crate.position.x, crate.position.y, 200)
        if crateZ < groundZ then
            crateStopped = true
            crate.model = 1860
            crateZ = groundZ

            triggerServerEvent("onPlayerCrateLanded", resourceRoot, x, y, groundZ)
        end
        setElementPosition(crate, startPosition.x, startPosition.y, crateZ)
    end
end)

addEvent("onClientCrateLanded", true)
addEventHandler("onClientCrateLanded", resourceRoot, function (x, y, z)
    if not isElement(crate) then
        return
    end
    crateZ = z
    setElementPosition(crate, x, y, z)
    crateStopped = true
end)

function createCrate(x, y, z)
    if isElement(crate) then
        destroyElement(crate)
    end
    crate = createObject(1861, x, y, z)
    crate.doubleSided = true

    startPosition = Vector3(x, y, z)
    crateZ = z

    crateStopped = false
end
