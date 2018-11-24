local screenWidth, screenHeight = guiGetScreenSize()
local bullets = {}
local bulletSpeed = 200

addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function (_, slot)
    toggleControl("fire", slot == 0 or slot == 1 or slot == 10)
end)

addEventHandler("onClientRender", root, function ()
    local x, y = screenWidth * 0.53, screenHeight * 0.4
    dxDrawRectangle(x-2, y-2, 4, 4, tocolor(255, 0, 255, 150))
end)

addEventHandler("onClientPreRender", root, function (deltaTime)
    deltaTime = deltaTime / 1000
    for i, b in ipairs(bullets) do
        local p = b.dist / b.len
        local sx, sy, sz = b.x + b.vx * p * b.len, b.y + b.vy * p * b.len, b.z + b.vz * p * b.len
        local tx, ty, tz = sx + b.vx*2, sy + b.vy*2, sz + b.vz*2
        dxDrawLine3D(sx, sy, sz, tx, ty, tz, tocolor(255, 150, 0), 2)
        dxDrawLine3D(b.x, b.y, b.z, b.tx, b.ty, b.tz, tocolor(255, 0, 255, 50), 1)
        if b.dist >= b.len - 2 then
            b.dist = b.len - 2
            -- table.remove(bullets, i)
            fxAddBulletImpact(b.tx, b.ty, b.tz, 0, 0, 1)
        else
            b.dist = b.dist + deltaTime * bulletSpeed
        end
    end
end)

function fireWeapon()
    if not getKeyState("mouse2") then
        return
    end
    local x1, y1, z1 = getPedWeaponMuzzlePosition(localPlayer)

    local hit, hx, hy, hz = processLineOfSight(getCamera().position, getCamera().matrix:transformPosition(0, 1000, 0), true, false, false)
    local len = 1000
    if hit then
        len = getDistanceBetweenPoints3D(getCamera().position.x, getCamera().position.y, getCamera().position.z, hx, hy, hz)
    end
    local x2, y2, z2 = getWorldFromScreenPosition(screenWidth * 0.53, screenHeight * 0.4, len * 2)

    dxDrawLine3D(x1, y1, z1, x2, y2, z2)

    local hit, x, y, z = processLineOfSight(x1, y1, z1, x2, y2, z2)
    if not hit then
        return
    end

    -- dxDrawLine3D(x1, y1, z1, x, y, z)
    local len = getDistanceBetweenPoints3D(x1, y1, z1, x, y, z)
    local vx, vy, vz = (x - x1)/len, (y - y1)/len, (z - z1)/len
    table.insert(bullets, {
        vx = vx,
        vy = vy,
        vz = vz,
        x = x1,
        y = y1,
        z = z1,
        tx = x,
        ty = y,
        tz = z,
        len = len,
        dist = 0,
    })
end

bindKey("mouse1", "down", fireWeapon)
