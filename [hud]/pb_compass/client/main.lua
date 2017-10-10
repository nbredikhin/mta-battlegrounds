local isCompassVisible = true

local screenSize = Vector2(guiGetScreenSize())
local textures = {}
local width, height

local compassWidth
local compassHeight

local viewWidth
local viewHeight

local arrowSize = 32
local compassAngle = 360 * 0.55

local markerColors = {
    { 253, 218, 14  },
    { 46,  198, 2   },
    { 0,   170, 240 },
    { 237, 5,   3   },
}


addEventHandler("onClientResourceStart", resourceRoot, function ()
    textures.arrow = dxCreateTexture("assets/pubg_arrow.png", "dxt3", true)
    textures.compass = dxCreateTexture("assets/pubg_compass.png", "dxt3", true)
    textures.marker = dxCreateTexture("assets/marker.png", "dxt3", true)
    compassWidth, compassHeight = dxGetMaterialSize(textures.compass)

    viewWidth = compassWidth * 0.55
    viewHeight = compassHeight

    width = math.floor(math.min(1200, math.max(500, screenSize.x * 0.4)))
    height = math.floor(compassHeight * width / viewWidth)

    arrowSize = math.floor(arrowSize * width / viewWidth)
end)

addEventHandler("onClientRender", root, function ()
    if not isCompassVisible then
        return
    end
    local camera = getCamera()
    local offset = compassWidth / 2 - viewWidth / 2 - (camera.rotation.z) / 720 * compassWidth * 2

    local x = screenSize.x / 2 - width / 2
    local y = screenSize.y * 0.04

    dxDrawImageSection(x, y, width, height, offset, 0, viewWidth, viewHeight, textures.compass, 0, 0, 0, tocolor(255, 255, 255, 200))

    -- Маркер
    local squadPlayers = exports.pb_gameplay:getSquadPlayers()
    if #squadPlayers > 0 then
        for i, player in ipairs(squadPlayers) do
            if isElement(player) then
                local marker = player:getData("map_marker")
                if marker then
                    local mx, my = unpack(marker)
                    local angle = math.deg(math.atan2(my - localPlayer.position.y, mx - localPlayer.position.x))
                    local offset = camera.rotation.z - angle + 180
                    if offset > 360 then
                        offset = offset - 360
                    end
                    if offset < compassAngle then
                        offset = x + offset / (compassAngle) * width
                        dxDrawImage(offset - arrowSize / 2, y - arrowSize, arrowSize, arrowSize, textures.marker, 0, 0, 0, tocolor(markerColors[i][1], markerColors[i][2], markerColors[i][3]))
                    end
                end
            end
        end
    end

    dxDrawImage(x + width / 2 - arrowSize / 2, y - arrowSize, arrowSize, arrowSize, textures.arrow, 0, 0, 0, tocolor(255, 255, 255, 200))
end)

function setVisible(visible)
    isCompassVisible = not not visible
end
