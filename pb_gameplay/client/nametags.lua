local NAMETAG_OFFSET = 1.1
local NAMETAG_WIDTH = 100
local NAMETAG_HEIGHT = 20
local NAMETAG_MAX_DISTANCE = 25
local NAMETAG_SCALE = 10

local streamedPlayers = {}

local nametagFont = "default-bold"
local icons = {}

local function dxDrawNametagText(text, x1, y1, x2, y2, color, scale)
    dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, nametagFont, "center", "center")
    dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, nametagFont, "center", "center")
    dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, nametagFont, "center", "center")
    dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, nametagFont, "center", "center")
    dxDrawText(text, x1, y1, x2, y2, color, scale, nametagFont, "center", "center")
end

addEventHandler("onClientRender", root, function ()
    local tr, tg, tb = 49, 177, 178
    local cx, cy, cz = getCameraMatrix()
    for player, info in pairs(streamedPlayers) do
        local px, py, pz = getElementPosition(player)
        local x, y = getScreenFromWorldPosition(px, py, pz + NAMETAG_OFFSET)
        if x then
            local distance = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz)
            if distance < NAMETAG_MAX_DISTANCE then
                local a = 255
                local name = info.name
                local scale = 1 / distance * NAMETAG_SCALE
                local width = NAMETAG_WIDTH * scale
                local height = NAMETAG_HEIGHT * scale
                local nx, ny = x - width / 2, y - height / 2
                local r, g, b = tr, tg, tb
                dxDrawNametagText(name, nx, ny, nx + width, ny + height, tocolor(r, g, b, a), scale)
            end
        end
    end
end)

local function showPlayer(player)
    if not isElement(player) then
        return false
    end
    setPlayerNametagShowing(player, false)
    if player == localPlayer or not isSquadPlayer(player) then
        return
    end
    streamedPlayers[player] = {
        name = string.gsub(player.name, '#%x%x%x%x%x%x', '')
    }
    return true
end

addEventHandler("onClientElementStreamIn", root, function ()
    if source.type == "player" then
        showPlayer(source)
    end
end)

addEventHandler("onClientElementStreamOut", root, function ()
    if source.type == "player" then
        streamedPlayers[source] = nil
    end
end)

addEventHandler("onClientPlayerQuit", root, function ()
    streamedPlayers[source] = nil
end)

addEventHandler("onClientPlayerJoin", root, function ()
    if isElementStreamedIn(source) then
        showPlayer(source)
    end
    setPlayerNametagShowing(source, false)
end)


addEventHandler("onClientResourceStart", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        if isElementStreamedIn(player) then
            showPlayer(player)
        end
        setPlayerNametagShowing(player, false)
    end

    -- local ped = createPed(0, Vector3{ x = 1739.240, y = -1440.502, z = 13.366 })
    -- streamedPlayers[ped] = {name = "TESTPLAYER123", premium = true}
    -- ped.health = 76

    -- nametagFont = dxCreateFont("assets/font.ttf", 50)
    -- crownTexture = exports.dpAssets:createTexture("crown.png")
end)
