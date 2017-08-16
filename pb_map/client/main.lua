local isMapVisible = false
local screenSize = Vector2(guiGetScreenSize())
local textures = {}
local mapTextureSize
local mapSize = screenSize.y

local lineColor = tocolor(255, 255, 150, 150)

local sectionNames = {
    x = {"A", "B", "C", "D", "E", "F", "G", "H"},
    y = {"I", "J", "K", "L", "M", "N", "O", "P"}
}

local function worldToMap(x, y)
    x = (x + 3000) / 6000 * mapSize
    y = mapSize - (y + 3000) / 6000 * mapSize
    return x, y
end

function dxDrawCircle(x, y, radius, ...)
    if not segments then
        segments = math.floor(radius / 6.5)
    end

    local px, py
    for i = 0, segments do
        local angle = i / segments * math.pi * 2
        local ax, ay = math.cos(angle), math.sin(angle)
        ax = ax * radius + x
        ay = ay * radius + y
        if px then
            dxDrawLine(px, py, ax, ay, ...)
        end
        px = ax
        py = ay
    end
end

addEventHandler("onClientRender", root, function ()
    if not isMapVisible then
        return false
    end
    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))
    local x = screenSize.x / 2 - mapSize / 2
    local y = 0
    dxDrawImage(x, y, mapSize, mapSize, textures.map)

    -- Игрок
    local camera = getCamera()
    local psize = 32
    local prot = 180-camera.rotation.z
    local px, py = worldToMap(localPlayer.position.x, localPlayer.position.y)
    px = px - psize / 2 + x
    py = py - psize / 2 + y
    dxDrawImage(px, py, psize, psize, textures.p_circle)
    dxDrawImage(px, py, psize, psize, textures.p_location, prot, 0, 0)

    -- Сетка
    for i = 1, 7 do
        local offset = i * mapSize / 8
        dxDrawLine(x, y + offset, x + mapSize, y + offset, lineColor, 2)
        dxDrawText(sectionNames.y[i + 1], x + 7, y + offset + 12, x + 7, y + offset + 12, tocolor(255, 255, 255, 200), 1, "default-bold")
        dxDrawLine(x + offset, y, x + offset, y + mapSize, lineColor, 2)
        dxDrawText(sectionNames.x[i + 1], x + offset + 12, y + 7, x + offset + 12, y + 7, tocolor(255, 255, 255, 200), 1, "default-bold")
    end

    dxDrawCircle(900, 500, 250, tocolor(0, 0, 200, 150), 2)
    dxDrawCircle(850, 490, 150, tocolor(255, 255, 255, 150), 2)
end)

bindKey("m", "down", function ()
    isMapVisible = not isMapVisible

    exports.pb_radar:setVisible(not isMapVisible)
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    textures.map = dxCreateTexture("assets/map.png", "argb", true, "clamp")
    mapTextureSize = dxGetMaterialSize(textures.map)

    textures.p_circle = dxCreateTexture("assets/p_circle.png", "argb", true, "clamp")
    textures.p_location = dxCreateTexture("assets/p_location.png", "argb", true, "clamp")

    -- test
    isMapVisible = true
end)
