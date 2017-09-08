local zoneTexture

function dxDraw3DCircle(x, y, radius, ...)
    if not segments then
        segments = 175
    end
    local z = getCamera().position.z + math.sin(getTickCount() * 0.0005)
    local px, py
    for i = 0, segments do
        local angle = i / segments * math.pi * 2
        local ax, ay = math.cos(angle), math.sin(angle)
        ax = ax * radius + x
        ay = ay * radius + y
        if px then
            dxDrawMaterialLine3D(ax, ay, z  + 100, ax, ay, z - 50, zoneTexture, radius * 0.03591, tocolor(255, 255, 255, 150 + math.sin(getTickCount() * angle * 0.0029) * 50), x, y, 0)
        end
        px = ax
        py = ay
    end
end


addEventHandler("onClientRender", root, function ()
    if isZonesVisible() then
        dxDraw3DCircle(getBlueZone())
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    zoneTexture = dxCreateTexture("assets/wall.png")
end)
