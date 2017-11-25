local plane
local spritesLOD = {
    bottom = dxCreateTexture("assets/plane_bottom.png"),
    side   = dxCreateTexture("assets/plane_side.png"),
    tail   = dxCreateTexture("assets/plane_tail.png")
}
local planeLODColor = tocolor(255, 255, 255, 255)
local startTime = 0
local velocityX = 0
local velocityY = 0
local startX = 0
local startY = 0

local dropTime = 0
local dropX = 0
local dropY = 0

local crateEjected = false

local planeSound
local maxSoundDistance = 2000
local middleSoundDistance = 1100
local minSoundDistance = 300

local function getFlightDistance()
    return ((getTickCount() - startTime) / 1000) * Config.planeSpeed
end

local function drawPlaneLOD()
    -- Низ
    local pos1 = plane.matrix:transformPosition(0, -32, 2)
    local pos2 = plane.matrix:transformPosition(0, 15, 2)
    dxDrawMaterialLine3D(pos1, pos2, spritesLOD.bottom, 45, planeLODColor, plane.matrix:transformPosition(0, 0, -1))
    -- Боковая сторона
    pos1 = plane.matrix:transformPosition(0, -20, 2)
    pos2 = plane.matrix:transformPosition(0, 15, 2)
    dxDrawMaterialLine3D(pos1, pos2, spritesLOD.side, 5, planeLODColor)
    -- Хвост
    pos1 = plane.matrix:transformPosition(0, -30, 5)
    pos2 = plane.matrix:transformPosition(0, -20, 5)
    dxDrawMaterialLine3D(pos1, pos2, spritesLOD.tail, -7, planeLODColor, plane.matrix:transformPosition(100, 0, 0))
end

addEventHandler("onClientPreRender", root, function ()
    if not isElement(plane) then
        return
    end
    local passedTime = (getTickCount() - startTime) / 1000
    local x, y, z = getElementPosition(plane)
    if not crateEjected and passedTime > dropTime then
        crateEjected = true
        createCrate(dropX, dropY, z - 20)
    end
    setElementPosition(plane, startX + velocityX * passedTime, startY + velocityY * passedTime, plane.position.z)
    setElementPosition(planeSound, x, y, z)
    local cx, cy, cz = getCameraMatrix()
    local distance = getDistanceBetweenPoints3D(cx, cy, cz, x, y, z)
    local volume = 0
    if distance < maxSoundDistance then
        if distance > 1100 then
            volume = math.max(0, math.min(1, 1 - (distance - middleSoundDistance) / (maxSoundDistance - middleSoundDistance)))
        else
            volume = 1
        end
    end
    setSoundVolume(planeSound, volume)
    if math.abs(x) > 3300 or math.abs(y) > 3300 then
        destroyElement(plane)
        if isElement(planeSound) then
            destroyElement(planeSound)
        end
        return
    end
end)

addEventHandler("onClientRender", root, function ()
    if not isElement(plane) then
        return
    end
    if plane.streamedIn then
        return
    end
    drawPlaneLOD()
end)

addEvent("createAirDrop", true)
addEventHandler("createAirDrop", resourceRoot, function (x, y, z, angle, vx, vy, dtime, dx, dy)
    if isElement(plane) then
        destroyElement(plane)
    end

    plane = createVehicle(592, x, y, z, 0, 0, angle)
    plane.frozen = true
    plane:setCollisionsEnabled(false)
    plane.dimension = localPlayer.dimension

    planeSound = playSound3D("assets/plane_sound.mp3", localPlayer.position, true)
    planeSound.dimension = localPlayer.dimension
    setSoundMaxDistance(planeSound, maxSoundDistance)
    setSoundMinDistance(planeSound, minSoundDistance)

    startTime = getTickCount()

    startX = x
    startY = y
    velocityX = vx
    velocityY = vy

    dropTime = dtime
    dropX = dx
    dropY = dy

    crateEjected = false
end)

-- addCommandHandler("adwrp", function ()
--     localPlayer.position = Vector3(dropX, dropY, 150)
-- end)

function destroyAirDrop()
    if isElement(plane) then
        destroyElement(plane)
    end
    if isElement(planeSound) then
        destroyElement(planeSound)
    end
    plane = nil
end

function getAirDropPosition()
    if crateEjected then
        return dropX, dropY, getCrateHeight()
    end
end
