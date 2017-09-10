local isMapVisible = false
local screenSize = Vector2(guiGetScreenSize())
local textures = {}
local mapTextureSize
local mapSize = screenSize.y
local mapX, mapY = screenSize.x / 2 - mapSize / 2, 0
local viewX, viewY = 0, 0

local lineColor = tocolor(255, 255, 150, 150)
local markerSize = 20
local markerAnim = 0

local renderTarget = dxCreateRenderTarget(mapSize, mapSize)

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
        segments = math.max(12, math.floor(radius / 4))
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

function drawZone(x, y, radius, color)
    local x, y = worldToMap(x, y)
    radius = radius / 6000 * mapSize
    dxDrawCircle(viewX + x, viewY + y, radius, color, 2)
end

addEventHandler("onClientRender", root, function ()
    if not isMapVisible then
        return false
    end
    dxSetRenderTarget(renderTarget)
    local x = viewX
    local y = viewY
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

    if exports.pb_zones:isZonesVisible() then
        local x, y, radius = exports.pb_zones:getWhiteZone()
        if x then
            drawZone(x, y, radius, tocolor(255, 255, 255, 180))
        end

        local x, y, radius = exports.pb_zones:getBlueZone()
        if x then
            drawZone(x, y, radius,tocolor(0, 0, 200, 150))
        end
    end

    local marker = localPlayer:getData("map_marker")
    if marker then
        markerAnim = math.min(1, markerAnim + 0.1)
        local x, y = worldToMap(unpack(marker))
        local offset = 10 * markerAnim - 10
        dxDrawImage(x + viewX - markerSize / 2, y + viewY - markerSize + offset, markerSize, markerSize, textures.marker, 0, 0, 0, tocolor(255, 255, 255, 255 * markerAnim))
    end
    dxSetRenderTarget()

    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))
    dxDrawImage(mapX, mapY, mapSize, mapSize, renderTarget)
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    textures.map = dxCreateTexture("assets/map.png", "argb", true, "clamp")
    mapTextureSize = dxGetMaterialSize(textures.map)

    textures.p_circle = dxCreateTexture("assets/p_circle.png", "argb", true, "clamp")
    textures.p_location = dxCreateTexture("assets/p_location.png", "argb", true, "clamp")
    textures.marker = dxCreateTexture("assets/marker.png", "argb", true, "clamp")
end)

addEventHandler("onClientClick", root, function (button, state, x, y)
    if isMapVisible and button == "left" and state == "down" then
        local marker = localPlayer:getData("map_marker")
        x = x - mapX
        y = y - mapY
        x = x / mapSize
        y = y / mapSize
        x = x * 6000 - 3000
        y = (6000 - y * 6000) - 3000
        if marker and (Vector2(unpack(marker)) - Vector2(x, y)).length < 50 then
            localPlayer:setData("map_marker", false, false)
        else
            localPlayer:setData("map_marker", {x, y}, false)
            markerAnim = 0
        end
    end
end)

function setVisible(visible)
    isMapVisible = not not visible
    showCursor(visible, false)
    toggleControl("fire", not visible)
    toggleControl("radar", false)
end

function isVisible(visible)
    return isMapVisible
end

toggleControl("radar", false)
