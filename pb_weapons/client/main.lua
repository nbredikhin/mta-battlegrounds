local screenWidth, screenHeight = guiGetScreenSize()
local bullets = {}

local projectileSize = 10

local crosshairX = screenWidth * 0.53
local crosshairY = screenHeight * 0.4

local lines = {}

function dxAddLine3D(...)
    table.insert(lines, {...})
end

setPlayerHudComponentVisible("crosshair", false)

addEventHandler("onClientRender", root, function ()
    local x, y = crosshairX, crosshairY
    dxDrawRectangle(x-2, y-2, 4, 4, tocolor(255, 0, 255, 150))

    dxDrawText(#bullets, 20, 400)
end)

local function dxAddCube(x, y, z, s, c, w)
    dxAddLine3D(x-s, y+s, z+s, x+s, y+s, z+s, c, w)
    dxAddLine3D(x-s, y-s, z+s, x+s, y-s, z+s, c, w)
    dxAddLine3D(x-s, y-s, z+s, x-s, y+s, z+s, c, w)
    dxAddLine3D(x+s, y-s, z+s, x+s, y+s, z+s, c, w)

    dxAddLine3D(x-s, y+s, z-s, x+s, y+s, z-s, c, w)
    dxAddLine3D(x-s, y-s, z-s, x+s, y-s, z-s, c, w)
    dxAddLine3D(x-s, y-s, z-s, x-s, y+s, z-s, c, w)
    dxAddLine3D(x+s, y-s, z-s, x+s, y+s, z-s, c, w)

    dxAddLine3D(x-s, y+s, z+s, x-s, y+s, z-s, c, w)
    dxAddLine3D(x-s, y-s, z+s, x-s, y-s, z-s, c, w)
    dxAddLine3D(x-s, y-s, z+s, x-s, y-s, z-s, c, w)
    dxAddLine3D(x+s, y-s, z+s, x+s, y-s, z-s, c, w)
end

local function updateBullet(bullet, deltaTime)
    local x, y, z = bullet.x, bullet.y, bullet.z
    local vx, vy, vz = bullet.vx, bullet.vy, bullet.vz
    dxDrawLine3D(x, y, z, x+vx*projectileSize, y+vy*projectileSize, z+vz*projectileSize, tocolor(255, 150, 0), 2)

    bullet.vz = bullet.vz - bullet.gravity * deltaTime
    bullet.lifetime = bullet.lifetime + deltaTime
    local dx = bullet.x + vx * bullet.speed * deltaTime
    local dy = bullet.y + vy * bullet.speed * deltaTime
    local dz = bullet.z + vz * bullet.speed * deltaTime

    local hit, hx, hy, hz = processLineOfSight(
        x, y, z, dx, dy, dz, true, true, true, true, true, false, false, false, localPlayer, false, true)

    if hit or bullet.lifetime > 2 then
        if hit then
            fxAddBulletImpact(hx, hy, hz, 0, 0, 1, 2, 20, 2)
            -- dxAddCube(hx, hy, hz, 0.1, tocolor(math.random()*255, math.random()*255, math.random()*255), 8)
        end
        bullet.isDestroyed = true
    end

    bullet.x = dx
    bullet.y = dy
    bullet.z = dz
end

addEventHandler("onClientPreRender", root, function (deltaTime)
    deltaTime = deltaTime / 1000
    for i, b in ipairs(bullets) do
        updateBullet(b, deltaTime)
    end

    for i = #bullets, 1, -1 do
        if bullets[i].isDestroyed then
            table.remove(bullets, i)
        end
    end

    for i, l in ipairs(lines) do
        dxDrawLine3D(unpack(l))
    end
end)

local function getAimPosition()
    local x1, y1, z1 = getWorldFromScreenPosition(crosshairX, crosshairY, 0)
    local x2, y2, z2 = getWorldFromScreenPosition(crosshairX, crosshairY, 1)
    local lx = x1 + (x2 - x1) * 1000
    local ly = y1 + (y2 - y1) * 1000
    local lz = z1 + (z2 - z1) * 1000
    local hit, x, y, z = processLineOfSight(x1, y1, z1, lx, ly, lz,
        true, true, true, true, true, false, false, false, localPlayer, false, true)
    if hit then
        return x, y, z
    else
        return getWorldFromScreenPosition(crosshairX, crosshairY, 1000)
    end
end

addEventHandler("onClientPlayerWeaponFire", localPlayer, function (_, _, _, _, _, _, _, x, y, z)
    local x1, y1, z1 = getPedWeaponMuzzlePosition(localPlayer)
    local x2, y2, z2 = getAimPosition()
    if not x2 then
        return
    end

    local len = getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)
    local bx, by, bz = (x2-x1)/len, (y2-y1)/len, (z2-z1)/len

    local pSpeed = 1000
    local pGravity = 0.02
    -- local x, y, z = x1, y1, z1
    -- local isHit = false
    -- local steps = 0
    -- while not isHit do
    --     local dx = x + bx*pSpeed
    --     local dy = y + by*pSpeed
    --     local dz = z + bz*pSpeed - pGravity * steps

    --     local hit, hx, hy, hz = processLineOfSight(x, y, z, dx, dy, dz,
    --         true, true, true, true, true, false, false, false, localPlayer, false, true)
    --     if hit then
    --         x2, y2, z2 = hx, hy, hz
    --         isHit = true
    --         dxAddLine3D(x, y, z, x2, y2, z2)
    --         break
    --     else
    --         dxAddLine3D(x, y, z, dx, dy, dz)
    --     end
    --     x, y, z = dx, dy, dz
    --     steps = steps + 1
    --     if steps > 1000 / pSpeed then
    --         return
    --     end
    -- end
    -- if not isHit then
    --     x2, y2, z2 = x, y, z
    -- end

    table.insert(bullets, {
        -- Стартовая позиция пули
        x = x1, y = y1, z = z1,
        -- Вектор скорости
        vx = bx, vy = by, vz = bz,

        speed = pSpeed,
        gravity = pGravity,

        lifetime = 0
    })
end)
