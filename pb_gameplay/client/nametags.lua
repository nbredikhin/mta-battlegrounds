local nametagsVisible = true

local NAMETAG_OFFSET = 1.1
local NAMETAG_WIDTH = 100
local NAMETAG_HEIGHT = 20
local NAMETAG_MAX_DISTANCE = 25
local NAMETAG_SCALE = 1

local streamedPlayers = {}

local nametagFont = "default"
local icons = {}

function setNametagsVisible(visible)
    nametagsVisible = not not visible
end

local function dxDrawNametagText(text, x1, y1, x2, y2, color, scale)
    dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 100), scale, nametagFont, "center", "center")
    dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 100), scale, nametagFont, "center", "center")
    dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 100), scale, nametagFont, "center", "center")
    dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 100), scale, nametagFont, "center", "center")
    dxDrawText(text, x1, y1, x2, y2, color, scale, nametagFont, "center", "center")
end

addEventHandler("onClientRender", root, function ()
    if not nametagsVisible then
        return
    end
    local tr, tg, tb = 49, 177, 178
    local cx, cy, cz = getCameraMatrix()
    local plane = getPlane()
    if not isElement(plane) then
        plane = nil
    end
    for player, info in pairs(streamedPlayers) do
        if not isElement(player) or player:getData("dead") or player.dimension ~= localPlayer.dimension then
            streamedPlayers[player] = nil
            return
        end
        local px, py, pz = getElementPosition(player)
        if player:getData("isInPlane") and plane then
            px, py, pz = getElementPosition(plane)
        end
        local x, y = getScreenFromWorldPosition(px, py, pz + NAMETAG_OFFSET)
        if x then
            local a = 255
            local name = info.name
            local scale = 1 * NAMETAG_SCALE
            local width = NAMETAG_WIDTH * scale
            local height = NAMETAG_HEIGHT * scale
            local nx, ny = x - width / 2, y - height / 2
            local r, g, b = tr, tg, tb
            dxDrawNametagText(name, nx, ny, nx + width, ny + height, tocolor(r, g, b, a), scale)

            if getElementType(player) == "player" then
                if not isSquadPlayer(player) then
                    streamedPlayers[player] = nil
                end
                local icon = "default"
                local playerHealth = 0
                if isElement(player) and player:getData("matchId") == localPlayer:getData("matchId") then
                    playerName = player.name or ""
                    playerHealth = player.health
                    if player.vehicle or player:getData("isInPlane") then
                        icon = "driving"
                    end
                    if player:getData("parachuting") then
                        icon = "parachute"
                    end
                end
                if playerHealth <= 0 then
                    icon = "dead"
                end
                local isize = 25
                if icon then
                    dxDrawImage(x - isize / 2, y + height / 2, isize, isize, icons[icon])
                end
            end
        end
    end
end)

function addElementNametag(element, text)
    streamedPlayers[element] = {
        name = tostring(text)
    }
end

-- local ped = createPed(0, Vector3{ x = -1294.118, y = -124.183, z = 13.548 })
-- addElementNametag(ped, "TEST NAMETAG")

local function showPlayer(player)
    if not isElement(player) then
        return false
    end
    setPlayerNametagShowing(player, false)
    if player == localPlayer or not isSquadPlayer(player) then
        streamedPlayers[player] = nil
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

-- addEventHandler("onClientElementStreamOut", root, function ()
--     streamedPlayers[source] = nil
-- end)

addEventHandler("onClientPlayerQuit", root, function ()
    streamedPlayers[source] = nil
end)

addEventHandler("onClientPlayerJoin", root, function ()
    if isElementStreamedIn(source) then
        showPlayer(source)
    end
end)


addEventHandler("onClientResourceStart", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        if isElementStreamedIn(player) then
            showPlayer(player)
        end
        setPlayerNametagShowing(player, false)
    end

    icons.dead = dxCreateTexture(":pb_hud/assets/dead.png")
    icons.driving = dxCreateTexture(":pb_hud/assets/driving.png")
    icons.parachute = dxCreateTexture(":pb_hud/assets/parachute.png")
    icons.default = dxCreateTexture(":pb_hud/assets/default.png")

    -- local ped = createPed(0, Vector3{ x = 1739.240, y = -1440.502, z = 13.366 })
    -- streamedPlayers[ped] = {name = "TESTPLAYER123", premium = true}
    -- ped.health = 76

    -- nametagFont = dxCreateFont("assets/font.ttf", 50)
    -- crownTexture = exports.dpAssets:createTexture("crown.png")
end)
