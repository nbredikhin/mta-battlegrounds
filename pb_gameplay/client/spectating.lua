local isActive = false
local spectatingPlayerIndex = 1
local spectatingPlayer

local screenSize = Vector2(guiGetScreenSize())

local cameraRotation = 0

function startSpectating()
    if isActive then
        return
    end
    isActive = true

    fadeCamera(true)
    showCursor(true)

    spectatingPlayerIndex = 1
    updateSpectatingPlayer()
end

local function smallestAngleDiff( target, source )
   local a = target - source

   if (a > 180) then
      a = a - 360
   elseif (a < -180) then
      a = a + 360
   end

   return a
end

local function getPlayersList()
    local players = {}
    for i, p in ipairs(getSquadPlayers()) do
        if isElement(p) and p ~= localPlayer and p:getData("matchId") == localPlayer:getData("matchId") then
            table.insert(players, p)
        end
    end
    return players
end

function stopSpectating()
    if not isActive then
        return
    end
    isActive = false
    showCursor(false)
end

function updateSpectatingPlayer()
    local players = getPlayersList()
    if not isElement(players[spectatingPlayerIndex]) then
        return
    end
    spectatingPlayer = players[spectatingPlayerIndex]
    setCameraTarget(spectatingPlayer)
end

bindKey("arrow_r", "down", function ()
    if not isActive then
        return
    end

    local players = getPlayersList()
    if #players <= 1 then
        return
    end
    spectatingPlayerIndex = spectatingPlayerIndex - 1
    if spectatingPlayerIndex < 1 then
        spectatingPlayerIndex = #players
    end
    updateSpectatingPlayer()
end)

bindKey("arrow_l", "down", function ()
    if not isActive then
        return
    end

    local players = getPlayersList()
    if #players <= 1 then
        return
    end
    spectatingPlayerIndex = spectatingPlayerIndex + 1
    if spectatingPlayerIndex > #players then
        spectatingPlayerIndex = 1
    end
    updateSpectatingPlayer()
end)

addEventHandler("onClientPreRender", root, function (dt)
    if not isActive or not isElement(spectatingPlayer) then
        return
    end
    cameraRotation = cameraRotation + (smallestAngleDiff(360 - spectatingPlayer:getCameraRotation(), cameraRotation)) * 0.15
    if cameraRotation == cameraRotation then
        localPlayer:setCameraRotation(cameraRotation)
    end
end)

local function isMouseOver(x, y, w, h)
    return mouseX >= x and mouseX <= x + w and mouseY >= y and mouseY <= y + h
end

local function drawButton(text, x, y, width, height, bg, color, scale)
    if not bg then bg = tocolor(250, 250, 250) end
    if not color then color = tocolor(0, 0, 0, 200) end
    if not scale then scale = 1.25 end
    dxDrawRectangle(x, y, width, height, bg)
    dxDrawRectangle(x, y + height - 5, width, 5, tocolor(0, 0, 0, 10))
    dxDrawText(text, x, y, x + width, y + height, color, scale, "default-bold", "center", "center")

    if isMouseOver(x, y, width, height) then
        dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 100))
        if getKeyState("mouse1") then
            return true
        end
    end
    return false
end

addEventHandler("onClientRender", root, function ()
    if not isActive then
        return
    end
    local bw = 200
    local bh = 50
    if drawButton(localize("rank_exit_to_lobby"), screenSize.x / 2 - bw / 2, screenSize.y - bh - 50, bw, bh) then
        stopSpectating()
        triggerEvent("onExitToLobby", resourceRoot)
    end
end)
