local position = localPlayer.position

position = Vector3(position.x - 100, position.y - 900, 180)
-- position = Vector3(position.x - 10, position.y + 20, 20)

local plane = createVehicle(592, position)
plane.frozen = true
-- plane.alpha = 0

local texture1 = dxCreateTexture("assets/plane.png")
local texture2 = dxCreateTexture("assets/plane_side.png")
local texture3 = dxCreateTexture("assets/tail.png")

addEventHandler("onClientPreRender", root, function (dt)
    dt = dt / 1000
    local speed = 100
    plane.position = plane.matrix:transformPosition(0, speed * dt, 0)
end)

addEventHandler("onClientRender", root, function ()
    if plane.streamedIn then
        return
    end
    local color = tocolor(255, 255, 255, 200)
    local pos1 = plane.matrix:transformPosition(0, -32, 2)
    local pos2 = plane.matrix:transformPosition(0, 15, 2)
    dxDrawMaterialLine3D(pos1, pos2, texture1, 45, color, plane.matrix:transformPosition(0, 0, -1))
    local pos1 = plane.matrix:transformPosition(0, -20, 2)
    local pos2 = plane.matrix:transformPosition(0, 15, 2)
    dxDrawMaterialLine3D(pos1, pos2, texture2, 5, color)
    local pos1 = plane.matrix:transformPosition(0, -30, 5)
    local pos2 = plane.matrix:transformPosition(0, -20, 5)
    dxDrawMaterialLine3D(pos1, pos2, texture3, -7, color, plane.matrix:transformPosition(100, 0, 0))
end)
