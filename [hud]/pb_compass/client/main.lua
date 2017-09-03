local isCompassVisible = true

local screenSize = Vector2(guiGetScreenSize())
local textures = {}
local width, height

local compassWidth
local compassHeight

local viewWidth
local viewHeight

local arrowSize = 32

addEventHandler("onClientResourceStart", resourceRoot, function ()
    textures.arrow = dxCreateTexture("assets/pubg_arrow.png", "dxt3", true)
    textures.compass = dxCreateTexture("assets/pubg_compass.png", "dxt3", true)
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
    local offset = compassWidth / 2 - viewWidth / 2 - (getCamera().rotation.z) / 720 * compassWidth * 2

    local x = screenSize.x / 2 - width / 2
    local y = screenSize.y * 0.04

    dxDrawImageSection(x, y, width, height, offset, 0, viewWidth, viewHeight, textures.compass, 0, 0, 0, tocolor(255, 255, 255, 200))
    dxDrawImage(x + width / 2 - arrowSize / 2, y - arrowSize, arrowSize, arrowSize, textures.arrow, 0, 0, 0, tocolor(255, 255, 255, 200))
end)

function setVisible(visible)
    isCompassVisible = not not visible
end
