-- Команда /spectateself для тестирования наблюдения
local DEBUG_SPECTATING = false

local isActive = false
local spectatingPlayerIndex = 1
local spectatingPlayer

local mouseX = 0
local mouseY = 0

local screenSize = Vector2(guiGetScreenSize())

local cameraRotation = 0
local cameraVertical = 15

local autoSwitchTimer

function startSpectating()
    if isActive then
        return
    end
    isActive = true

    localPlayer.frozen = true

    fadeCamera(true)
    showCursor(true)

    spectatingPlayerIndex = 1
    updateSpectatingPlayer()

    showGameHUD(false)
    setComponentVisible("pb_hud", true)
    setComponentVisible("pb_killchat", true)
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
    if DEBUG_SPECTATING then
        return {localPlayer}
    end
    local players = {}
    for i, p in ipairs(getSquadPlayers()) do
        if isElement(p) and p ~= localPlayer and p:getData("matchId") == localPlayer:getData("matchId") and not p:getData("dead") then
            table.insert(players, p)
        end
    end
    return players
end

function stopSpectating(keepCamera)
    if not isActive then
        return
    end

    setComponentVisible("pb_hud", false)
    setComponentVisible("pb_killchat", false)

    isActive = false
    localPlayer.frozen = false
    showCursor(false)
    if not keepCamera then
        setCameraTarget(localPlayer)
    end
    localPlayer:setData("spectatingPlayer", false, false)
end

function updateSpectatingPlayer()
    local players = getPlayersList()
    if not isElement(players[spectatingPlayerIndex]) then
        return
    end
    spectatingPlayer = players[spectatingPlayerIndex]
    localPlayer:setData("spectatingPlayer", spectatingPlayer, false)
end

local function switchSpectatingPlayer(delta)
    if not isActive then
        return
    end
    if not delta then
        delta = 1
    end
    if isTimer(autoSwitchTimer) then
        killTimer(autoSwitchTimer)
    end

    local players = getPlayersList()
    if #players == 0 then
        return
    end
    spectatingPlayerIndex = spectatingPlayerIndex + 1
    if spectatingPlayerIndex > #players then
        spectatingPlayerIndex = 1
    elseif spectatingPlayerIndex < 1 then
        spectatingPlayerIndex = #players
    end
    updateSpectatingPlayer()
end

bindKey("arrow_r", "down", function ()
    switchSpectatingPlayer(1)
end)

bindKey("arrow_l", "down", function ()
    switchSpectatingPlayer(-1)
end)

addEventHandler("onClientPreRender", root, function (dt)
    dt = dt / 1000
    if not isActive or not isElement(spectatingPlayer) then
        return
    end
    if spectatingPlayer:getData("dead") then
        spectatingPlayer = nil
        autoSwitchTimer = setTimer(switchSpectatingPlayer, 1500, 1)
        return
    end

    local targetVertical = 15
    if spectatingPlayer.ducked then
        targetVertical = 5
    end
    cameraRotation = cameraRotation + (smallestAngleDiff(360 - spectatingPlayer:getCameraRotation(), cameraRotation)) * 7 * dt
    cameraVertical = cameraVertical + (targetVertical - cameraVertical) * 3 * dt
    if cameraRotation == cameraRotation then
        local plane = getPlane()
        if spectatingPlayer:getData("isInPlane") and isElement(plane) then
            setCameraMatrix(
                plane.position + Vector3(40, 40, 40),
                plane.position,
                0,
                70
            )
        else
            local distance = 3
            local camPosition = spectatingPlayer.position
            if spectatingPlayer.vehicle then
                distance = 8
                camPosition = spectatingPlayer.vehicle.position
            end
            local pitch = math.rad(cameraVertical)
            local yaw = math.rad(cameraRotation - 90)
            local cameraOffset = Vector3(math.cos(yaw) * math.cos(pitch), math.sin(yaw) * math.cos(pitch), math.sin(pitch))
            setCameraMatrix(
                camPosition + cameraOffset * distance,
                camPosition + Vector3(0, 0, 0.2),
                0,
                70
            )
        end
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

    local mx, my = getCursorPosition()
    if mx then
        mx = mx * screenSize.x
        my = my * screenSize.y
    else
        mx, my = 0, 0
    end
    mouseX, mouseY = mx, my

    local bw = 200
    local bh = 50
    if drawButton(localize("rank_exit_to_lobby"), screenSize.x / 2 - bw / 2, screenSize.y - bh - 100, bw, bh) then
        stopSpectating()
        triggerEvent("onExitToLobby", resourceRoot)
    end
end)

if DEBUG_SPECTATING then
    addCommandHandler("selfspectate", startSpectating)
end