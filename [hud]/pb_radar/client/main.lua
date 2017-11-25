local isRadarVisible = false

local screenSize = Vector2(guiGetScreenSize())
local viewportWidth  = 256
local viewportHeight = 256
local viewportX = screenSize.x - viewportWidth - 37
local viewportY = screenSize.y - viewportHeight - 30
local viewport

local radarBorderSize = 2
local radarTextureSize = 3000

local radarBorderColor = tocolor(255, 255, 255, 100)
local radarLinesColor = tocolor(255, 255, 255, 40)
local radarTextColor = tocolor(255, 255, 255, 140)

local runnerBackgroundColor = tocolor(0, 0, 0, 25)
local runnerLeftColor = tocolor(0, 109, 221, 255)
local runnerRightColor = tocolor(255, 255, 255, 255)
local zoneProgressColor = tocolor(7, 95, 192, 255)

local runnerIconSize = 42

local airdropSize = 40

local markerSize = 20
local markerColors = {
    { 253, 218, 14  },
    { 46,  198, 2   },
    { 0,   170, 240 },
    { 237, 5,   3   },
}

local textures = {}

local sectionNames = {
    x = {"A", "B", "C", "D", "E", "F", "G", "H"},
    y = {"I", "J", "K", "L", "M", "N", "O", "P"}
}

local function worldToRadar(x, y)
    if not x then
        return 0, 0
    end
    x = (x + 3000) / 6000 * radarTextureSize
    y = radarTextureSize - (y + 3000) / 6000 * radarTextureSize
    return x, y
end

local function getSectionName(x, y)
    x = math.floor(x / radarTextureSize * #sectionNames.x) + 1
    y = math.floor(y / radarTextureSize * #sectionNames.y) + 1
    return sectionNames.x[x] or "", sectionNames.y[y] or ""
end

function dxDrawCircle(x, y, radius, ...)
    if not segments then
        segments = math.max(12, math.floor(radius / 5))
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

function dxDrawLineDotted(x1, y1, x2, y2, ...)
    local len = getDistanceBetweenPoints2D(x1, y1, x2, y2)
    local vx = (x2 - x1) / len
    local vy = (y2 - y1) / len

    local cx = x1
    local cy = y1
    for i = 1, len / 10 do
        cx = cx + vx * 10
        cy = cy + vy * 10
        dxDrawLine(cx, cy, cx + vx * 5, cy + vy * 5, ...)
    end
end

function drawZone(x, y, radius, localX, localY, color)
    local x, y = worldToRadar(x, y)
    radius = radius / 6000 * radarTextureSize
    dxDrawCircle(-localX+x, -localY+y, radius, color, 2)
end

function drawRedZone(x, y, radius, localX, localY, color)
    local x, y = worldToRadar(x, y)
    radius = radius / 6000 * radarTextureSize
    dxDrawImage(-localX+x-radius, -localY+y-radius, radius*2,radius*2, textures.circle, 0, 0, 0, tocolor(255, 0, 0, 80))
end

local function drawRadar()
    if not viewport then
        return
    end
    dxSetRenderTarget(viewport)
    local localX, localY = worldToRadar(localPlayer.position.x, localPlayer.position.y)
    local localWidth, localHeight = viewportWidth, viewportHeight
    dxDrawImageSection(
        0,
        0,
        viewportWidth,
        viewportHeight,
        localX - localWidth / 2,
        localY - localHeight / 2,
        localWidth,
        localHeight,
        textures.map
    )
    -- Сетка
    local gridSize = 40

    local g1 = math.max(1, math.floor((localX) / radarTextureSize * gridSize) + 1)
    local g2 = math.min(40, math.floor((localX + localWidth) / radarTextureSize * gridSize) + 1)
    for i = g1, g2 do
        local lx = (i - 1) * radarTextureSize / gridSize - localX
        local ly = (i - 1) * radarTextureSize / gridSize - localY
        local ix = i - math.floor((i - 1) / 5) * 5
        local sx, sy = getSectionName(lx + localX, ly + localY)
        dxDrawLine(lx, 0, lx, 0 + radarTextureSize, radarLinesColor, 2)
        dxDrawText(sx..ix, lx + 5, 8, lx + 5, 8, radarTextColor)
    end

    g1 = math.max(1, math.floor((localY) / radarTextureSize * gridSize) + 1)
    g2 = math.min(40, math.floor((localY + localHeight) / radarTextureSize * gridSize) + 1)
    for i = g1, g2 do
        local lx = (i - 1) * radarTextureSize / gridSize - localX
        local ly = (i - 1) * radarTextureSize / gridSize - localY

        local iy = i - math.floor((i - 1) / 5) * 5
        local sx, sy = getSectionName(lx + localX, ly + localY)
        dxDrawLine(0, ly, 0 + radarTextureSize, ly, radarLinesColor, 2)
        dxDrawText(sy..iy, 8, ly + 3, 8, ly + 3, radarTextColor)
    end

    -- Зоны
    if exports.pb_zones:isZonesVisible() then
        local x, y, radius = exports.pb_zones:getWhiteZone()
        if x then
            drawZone(x, y, radius, localX - localWidth / 2, localY - localHeight / 2, tocolor(255, 255, 255, 180))
        end

        -- Линия к белой зоне
        local wx, wy, wrad = x, y, radius
        local lx = -(localX - localWidth / 2)
        local ly = -(localY - localHeight / 2)
        local x, y = worldToRadar(localPlayer.position.x, localPlayer.position.y)
        if (Vector2(localPlayer.position.x, localPlayer.position.y) - Vector2(wx, wy)).length > wrad then
            local wx, wy = worldToRadar(wx, wy)
            dxDrawLineDotted(lx + wx, ly + wy, lx + x, ly + y, tocolor(255, 255, 255, 200), 2)
        end

        local x, y, radius = exports.pb_zones:getBlueZone()
        if x then
            drawZone(x, y, radius, localX - localWidth / 2, localY - localHeight / 2, tocolor(0, 0, 200, 150))
        end

        local x, y, radius = exports.pb_zones:getRedZone()
        if x then
            drawRedZone(x, y, radius, localX - localWidth / 2, localY - localHeight / 2)
        end
    end


    -- Маркеры отряда
    local squadPlayers = exports.pb_gameplay:getSquadPlayers()
    if #squadPlayers > 0 then
        for i, player in ipairs(squadPlayers) do
            if isElement(player) then
                local marker = player:getData("map_marker")
                if marker then
                    local x, y = worldToRadar(unpack(marker))
                    x = -(localX - localWidth / 2) + x
                    y = -(localY - localHeight / 2) + y
                    dxDrawImage(x - markerSize / 2, y - markerSize, markerSize, markerSize, textures.marker, 0, 0, 0, tocolor(markerColors[i][1], markerColors[i][2], markerColors[i][3], 255))
                end
            end
        end
    end

    -- Airdrop
    local airdropX, airdropY = exports.pb_airdrop:getAirDropPosition()
    if airdropX then
        local x, y = worldToRadar(airdropX, airdropY)
        x = -(localX - localWidth / 2) + x
        y = -(localY - localHeight / 2) + y
        dxDrawImage(x - airdropSize / 2, y - airdropSize / 2, airdropSize, airdropSize, textures.airdrop)
    end

    -- Сквад
    local squadPlayers = exports.pb_gameplay:getSquadPlayers()
    local squadColor = tocolor(49, 177, 178)
    for i, player in ipairs(squadPlayers) do
        if isElement(player) and player:getData("matchId") == localPlayer:getData("matchId") and not player:getData("dead") and player ~= localPlayer then
            local markerSize = 20
            local x, y = worldToRadar(getElementPosition(player))
            x = -(localX - localWidth / 2) + x
            y = -(localY - localHeight / 2) + y

            local psize = 32
            local prot = 180-player.rotation.z
            local px = x - psize / 2
            local py = y - psize / 2
            dxDrawImage(px, py, psize, psize, textures.p_circle, 0, 0, 0, squadColor)
            dxDrawImage(px, py, psize, psize, textures.p_location, prot, 0, 0, squadColor)
        end
    end

    -- Игрок
    local camera = getCamera()
    local psize = 32
    local prot = 180-camera.rotation.z
    local px = viewportWidth / 2 - psize / 2
    local py = viewportHeight / 2 - psize / 2
    dxDrawImage(px, py, psize, psize, textures.p_circle)
    dxDrawImage(px, py, psize, psize, textures.p_location, prot, 0, 0)

    dxSetRenderTarget()
end

local function drawRunnerBar(x, y, width, height)
    if not exports.pb_zones:isZonesVisible() then
        return
    end
    dxDrawRectangle(x, y, width, height - 1, runnerBackgroundColor)

    dxDrawRectangle(x, y, height, height, runnerLeftColor)
    dxDrawLine(x, y + height, x + height, y + height, tocolor(0, 0, 0, 70))
    dxDrawRectangle(x + width - height, y, height, height, runnerRightColor)
    dxDrawLine(x + width - height, y + height, x + width, y + height, tocolor(0, 0, 0, 70))

    local barX = x + height
    local barWidth = width - height * 2
    local bx, by, br, bp = exports.pb_zones:getBlueZone()
    local zoneProgress = bp
    dxDrawRectangle(barX, y, barWidth * zoneProgress, height - 1, zoneProgressColor)
    dxDrawLine(barX, y + height - 1, barX + barWidth * zoneProgress, y + height - 1, tocolor(0, 0, 0, 70))

    local br = exports.pb_zones:getBlueZoneRadius()
    local wx, wy, wr = exports.pb_zones:getWhiteZone()
    local runnerAlpha = 255
    local pr = getDistanceBetweenPoints2D(localPlayer.position.x, localPlayer.position.y, bx, by)
    local pr2 = getDistanceBetweenPoints2D(localPlayer.position.x, localPlayer.position.y, wx, wy)
    local runnerProgress = (1 - (2 - pr2 / wr)) / br * pr
    runnerProgress = 1 - math.min(1, math.max(0, runnerProgress))

    if runnerProgress == 1 then
        runnerAlpha = 100
    end
    local rsize = runnerIconSize
    dxDrawImage(barX + barWidth * runnerProgress - rsize / 2, y - rsize + height, rsize, rsize, textures.runner, 0, 0, 0, tocolor(255, 255, 255, runnerAlpha))

    local zoneTime = exports.pb_zones:getZoneTime()
    local text = "!"
    if zoneTime then
        local mins = math.floor(zoneTime / 60)
        text = string.format("%02d:%02d", mins, zoneTime % 60)
    end
    dxDrawText(text, x, y + height + 3, x, y + height + 3)
end

function setVisible(visible)
    isRadarVisible = not not visible
end

addEventHandler("onClientRender", root, function ()
    if not isRadarVisible then
        return
    end
    drawRadar()

    dxDrawRectangle(
        viewportX - radarBorderSize,
        viewportY - radarBorderSize,
        viewportWidth + radarBorderSize * 2,
        viewportHeight + radarBorderSize * 2,
        radarBorderColor
    )
    dxDrawImage(
        viewportX,
        viewportY,
        viewportWidth,
        viewportHeight,
        viewport
    )

    drawRunnerBar(viewportX - radarBorderSize, viewportY - 40, viewportWidth + radarBorderSize * 2, 10)
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    textures.map = dxCreateTexture(":pb_map/assets/map.jpg", "argb", true, "clamp")
    radarTextureSize = dxGetMaterialSize(textures.map)

    textures.p_circle = dxCreateTexture(":pb_map/assets/p_circle.png", "argb", true, "clamp")
    textures.circle = dxCreateTexture(":pb_map/assets/circle.png", "argb", true, "clamp")
    textures.p_location = dxCreateTexture(":pb_map/assets/p_location.png", "argb", true, "clamp")
    textures.marker = dxCreateTexture(":pb_map/assets/marker.png", "argb", true, "clamp")
    textures.airdrop = dxCreateTexture(":pb_map/assets/airdrop.png", "argb", true, "clamp")

    textures.runner = dxCreateTexture("assets/runner.png")

    viewport = dxCreateRenderTarget(viewportWidth, viewportHeight, false)
end)
