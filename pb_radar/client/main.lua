local isRadarVisible = true

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

local textures = {}

local sectionNames = {
    x = {"A", "B", "C", "D", "E", "F", "G", "H"},
    y = {"I", "J", "K", "L", "M", "N", "O", "P"}
}

local function worldToRadar(x, y)
    x = (x + 3000) / 6000 * radarTextureSize
    y = radarTextureSize - (y + 3000) / 6000 * radarTextureSize
    return x, y
end

local function getSectionName(x, y)
    x = math.floor(x / radarTextureSize * #sectionNames.x) + 1
    y = math.floor(y / radarTextureSize * #sectionNames.y) + 1
    return sectionNames.x[x] or "", sectionNames.y[y] or ""
end

local function drawRadar()
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
    for i = 1, gridSize do
        local lx = (i - 1) * radarTextureSize / gridSize - localX
        local ix = i - math.floor((i - 1) / 5) * 5
        local ly = (i - 1) * radarTextureSize / gridSize - localY
        local iy = i - math.floor((i - 1) / 5) * 5

        local sx, sy = getSectionName(lx + localX, ly + localY)
        dxDrawLine(lx, 0, lx, 0 + radarTextureSize, radarLinesColor, 2)
        dxDrawText(sx..ix, lx + 5, 8, lx + 5, 8, radarTextColor)
        dxDrawLine(0, ly, 0 + radarTextureSize, ly, radarLinesColor, 2)
        dxDrawText(sy..iy, 8, ly + 3, 8, ly + 3, radarTextColor)
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
    dxDrawRectangle(x, y, width, height - 1, runnerBackgroundColor)

    dxDrawRectangle(x, y, height, height, runnerLeftColor)
    dxDrawLine(x, y + height, x + height, y + height, tocolor(0, 0, 0, 70))
    dxDrawRectangle(x + width - height, y, height, height, runnerRightColor)
    dxDrawLine(x + width - height, y + height, x + width, y + height, tocolor(0, 0, 0, 70))

    local barX = x + height
    local barWidth = width - height * 2
    local zoneProgress = 0.4
    dxDrawRectangle(barX, y, barWidth * zoneProgress, height - 1, zoneProgressColor)
    dxDrawLine(barX, y + height - 1, barX + barWidth * zoneProgress, y + height - 1, tocolor(0, 0, 0, 70))

    local runnerProgress = 0.6
    local rsize = runnerIconSize
    dxDrawImage(barX + barWidth * runnerProgress - rsize / 2, y - rsize + height, rsize, rsize, textures.runner)

    dxDrawText("4:20", x, y + height + 3, x, y + height + 3)
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
    textures.map = dxCreateTexture(":pb_map/assets/map.png", "argb", true, "clamp")
    radarTextureSize = dxGetMaterialSize(textures.map)

    textures.p_circle = dxCreateTexture(":pb_map/assets/p_circle.png", "argb", true, "clamp")
    textures.p_location = dxCreateTexture(":pb_map/assets/p_location.png", "argb", true, "clamp")

    textures.runner = dxCreateTexture("assets/runner.png")

    viewport = dxCreateRenderTarget(viewportWidth, viewportHeight, false)
end)
