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

local markerColors = {
    { 253, 218, 14  },
    { 46,  198, 2   },
    { 0,   170, 240 },
    { 237, 5,   3   },
}

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

function drawRedZone(x, y, radius)
    local x, y = worldToMap(x, y)
    radius = radius / 6000 * mapSize
    dxDrawImage(viewX + x - radius, viewY + y - radius, radius * 2, radius * 2, textures.circle, 0, 0, 0, tocolor(255, 0, 0, 80))
end


addEventHandler("onClientRender", root, function ()
    if not isMapVisible then
        return false
    end
    dxSetRenderTarget(renderTarget)
    local x = viewX
    local y = viewY
    dxDrawImage(x, y, mapSize, mapSize, textures.map)

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
        local x, y, radius = exports.pb_zones:getRedZone()
        if x then
            drawRedZone(x, y, radius,tocolor(255, 0, 0, 180))
        end
    end

    local squadPlayers = exports.pb_gameplay:getSquadPlayers()
    if #squadPlayers > 0 then
        for i, player in ipairs(squadPlayers) do
            if isElement(player) then
                local marker = player:getData("map_marker")
                if marker then
                    local x, y = worldToMap(unpack(marker))
                    local anim = 1
                    if player == localPlayer then
                        anim = markerAnim
                    end
                    local offset = 10 * anim - 10
                    dxDrawImage(x + viewX - markerSize / 2, y + viewY - markerSize + offset, markerSize, markerSize, textures.marker, 0, 0, 0, tocolor(markerColors[i][1], markerColors[i][2], markerColors[i][3], 255 * anim))
                end
            end
        end
    else
        local marker = localPlayer:getData("map_marker")
        if marker then
            local x, y = worldToMap(unpack(marker))
            local offset = 10 * markerAnim - 10
            dxDrawImage(x + viewX - markerSize / 2, y + viewY - markerSize + offset, markerSize, markerSize, textures.marker, 0, 0, 0, tocolor(markerColors[1][1], markerColors[1][2], markerColors[1][3], 255 * markerAnim))
        end
    end
    markerAnim = math.min(1, markerAnim + 0.1)

    -- Сквад
    local squadPlayers = exports.pb_gameplay:getSquadPlayers()
    local squadColor = tocolor(49, 177, 178)
    for i, player in ipairs(squadPlayers) do
        if isElement(player) and player:getData("matchId") == localPlayer:getData("matchId") and player ~= localPlayer and not player:getData("dead") then
            local markerSize = 20
            local x, y = worldToMap(getElementPosition(player))
            x = x + viewX
            y = y + viewY

            local psize = 32
            local prot = 180-player.rotation.z
            local px = x - psize / 2
            local py = y - psize / 2
            dxDrawImage(px, py, psize, psize, textures.p_circle, 0, 0, 0, squadColor)
            dxDrawImage(px, py, psize, psize, textures.p_location, prot, 0, 0, squadColor)

            dxDrawRectangle(x - 50, y + psize / 2 + 3, 100, 15, tocolor(0, 0, 0, 150))
            dxDrawText(player.name, x - 50, y + psize / 2 + 3, x + 50, y + psize / 2 + 18, tocolor(255, 255, 255), 1, "default", "center", "center", true, false)
        end
    end

    -- Игрок
    local camera = getCamera()
    local psize = 32
    local prot = 180-camera.rotation.z
    local px, py = worldToMap(localPlayer.position.x, localPlayer.position.y)
    px = px - psize / 2 + x
    py = py - psize / 2 + y
    dxDrawImage(px, py, psize, psize, textures.p_circle)
    dxDrawImage(px, py, psize, psize, textures.p_location, prot, 0, 0)

    dxSetRenderTarget()

    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))
    dxDrawImage(mapX, mapY, mapSize, mapSize, renderTarget)
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    textures.map = dxCreateTexture("assets/map.png", "argb", true, "clamp")
    mapTextureSize = dxGetMaterialSize(textures.map)

    textures.p_circle = dxCreateTexture("assets/p_circle.png", "argb", true, "clamp")
    textures.circle = dxCreateTexture("assets/circle.png", "argb", true, "clamp")
    textures.p_location = dxCreateTexture("assets/p_location.png", "argb", true, "clamp")
    textures.marker = dxCreateTexture("assets/marker.png", "argb", true, "clamp")
end)

addEventHandler("onClientKey", root, function (key, down)
    if not isMapVisible or not down then
        return
    end

    if key == "mouse1" then
        local mx, my = getCursorPosition()
        if not mx then
            return
        end
        local x, y = mx * screenSize.x, my * screenSize.y
        local marker = localPlayer:getData("map_marker")
        x = x - mapX
        y = y - mapY
        x = x / mapSize
        y = y / mapSize
        x = x * 6000 - 3000
        y = (6000 - y * 6000) - 3000
        if marker and (Vector2(unpack(marker)) - Vector2(x, y)).length < 50 then
            localPlayer:setData("map_marker", false, true)
        else
            localPlayer:setData("map_marker", {x, y}, true)
            markerAnim = 0
        end

        cancelEvent()
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
