local screenSize = Vector2(guiGetScreenSize())
local isLobbyVisible = false

local isMousePressed = false
local prevMouseState = false
local mouseX = 0
local mouseY = 0

local startGamePressed = false
local lobbyPlayersCount
local lobbyMatchesCount

local currentMessageBoxText = nil
local currentWindow = nil

function localize(name)
    local res = getResourceFromName("pb_lang")
    if (res) and (getResourceState(res) == "running") then
        return exports.pb_lang:localize(name)
    else
        return name
    end
end

function isMouseOver(x, y, w, h)
    return mouseX >= x     and
           mouseX <= x + w and
           mouseY >= y     and
           mouseY <= y + h
end

function showMessageBox(text)
    currentMessageBoxText = tostring(text)
    setTimer(function() currentMessageBoxText = nil end, 5000, 1)
end

function showInviteWindow(player)
    if currentWindow then
        return
    end

    currentWindow = {
        text = "Игрок " .. tostring(string.gsub(player.name, '#%x%x%x%x%x%x', '')) .. " приглашает вас в игру",
        cancel_text = "ОТМЕНА",
        accept_text = "ПРИНЯТЬ",
        width = 450,
        height = 170
    }
end

function drawStartGameButton()
    local texture = "assets/corner0.png"
    local w, h = 496, 250
    if isMouseOver(0, 0, w, h) then
        texture = "assets/corner1.png"

        if isMousePressed then
            findMatch()
            startGamePressed = true
        end
    end
    dxDrawImage(0, 0, w, h, texture)
    local text = localize("lobby_start_game")
    if startGamePressed then
        text = localize("lobby_searching")
    end
    dxDrawText(text, 25 + 5, 20 + 5, 0, 0, tocolor(0, 0, 0, 150), 5, "default-bold", "left", "top")
    dxDrawText(text, 25, 20, 0, 0, tocolor(255, 255, 255), 5, "default-bold", "left", "top")
end

function drawBetaLogo()
    local logoWidth = 750
    local logoHeight = 292
    local w = logoWidth * 0.3
    local h = logoHeight * 0.3
    dxDrawImage(screenSize.x - w - 10, screenSize.y - h - 40, w, h, "assets/logo.png", 0, 0, 0, tocolor(255, 255, 255, 100))
    dxDrawText(localize("lobby_beta_label"), screenSize.x - w - 10, 0, screenSize.x - 10, screenSize.y - 30, tocolor(255, 150, 0, 100), 1.3, "default-bold", "center", "bottom")
end

function drawArrows()
    -- Стрелки рядом с персонажем
    local arrowSize = 80
    local offset = math.sin(getTickCount() * 0.008) * arrowSize * 0.1

    local x = screenSize.x * 0.3 - arrowSize / 2 + offset
    local y = screenSize.y * 0.55
    local w, h = arrowSize, arrowSize
    dxDrawImage(x, y, w, h, "assets/arrow.png", 180)
    if isMousePressed and isMouseOver(x-20, y-20, w+40, h+40) then
        changeSkin(-1)
    end
    x, y = screenSize.x * 0.7 - arrowSize / 2 - offset, screenSize.y * 0.55
    dxDrawImage(x, y, w, h, "assets/arrow.png")
    if isMousePressed and isMouseOver(x-20, y-20, w+40, h+40) then
        changeSkin(1)
    end
end

function drawMessageBox()
    if not currentMessageBoxText then
        return
    end
    local width = dxGetTextWidth(currentMessageBoxText, 2.5, "default-bold") + 50
    local height = 150
    dxDrawRectangle(screenSize.x / 2 - width / 2 - 1, screenSize.y / 2 - height / 2 - 1, width + 2, height + 2, tocolor(255, 255, 255))
    dxDrawRectangle(screenSize.x / 2 - width / 2, screenSize.y / 2 - height / 2, width, height, tocolor(0, 0, 0))
    dxDrawText(currentMessageBoxText, 0, 0, screenSize.x, screenSize.y, tocolor(255, 255, 255), 2.5, "default-bold", "center", "center")
end

local function drawButton(text, x, y, width, height, bg, color, scale)
    if not bg then bg = tocolor(250, 250, 250) end
    if not color then color = tocolor(0, 0, 0, 200) end
    if not scale then scale = 1.5 end
    dxDrawRectangle(x, y, width, height, bg)
    dxDrawRectangle(x, y + height - 5, width, 5, tocolor(0, 0, 0, 10))
    dxDrawText(text, x, y, x + width, y + height, color, scale, "default-bold", "center", "center")

    if isMouseOver(x, y, width, height) then
        dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 100))
        if isMousePressed then
            return true
        end
    end
    return false
end

function drawWindow()
    if not currentWindow then
        return
    end
    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))

    local x = screenSize.x / 2 - currentWindow.width / 2
    local y = screenSize.y / 2 - currentWindow.height / 2

    dxDrawRectangle(x-1, y-1, currentWindow.width+2, currentWindow.height+2, tocolor(255, 255, 255))
    dxDrawRectangle(x, y, currentWindow.width, currentWindow.height, tocolor(0, 0, 0))
    dxDrawText(currentWindow.text, x + 15, y, x + currentWindow.width - 30, y + currentWindow.height / 2 + 15, tocolor(255, 255, 255), 2, "default-bold", "center", "center", true, true)

    local bw = 140
    local bh = 45
    if drawButton(currentWindow.cancel_text, x + currentWindow.width / 2 - bw - 10, y + currentWindow.height - bh - 15, bw, bh) then
        currentWindow = nil
    end
    if drawButton(currentWindow.accept_text, x + currentWindow.width / 2 + 10, y + currentWindow.height - bh - 15, bw, bh) then
        currentWindow = nil
    end
end

addEventHandler("onClientRender", root, function ()
    if not isLobbyVisible then
        return
    end
    local currentMouseState = getKeyState("mouse1")
    if not prevMouseState and currentMouseState then
        isMousePressed = true
    else
        isMousePressed = false
    end
    prevMouseState = currentMouseState

    local mx, my = getCursorPosition()
    if mx then
        mx = mx * screenSize.x
        my = my * screenSize.y
    else
        mx, my = 0, 0
    end
    mouseX, mouseY = mx, my

    drawStartGameButton()
    drawBetaLogo()
    drawArrows()

    local y = screenSize.y - 65
    if lobbyPlayersCount then
        local lobbyText = localize("lobby_players_in_lobby") .. ": " .. tostring(lobbyPlayersCount)
        dxDrawText(lobbyText, 26, y + 1, 0, 0, tocolor(0, 0, 0, 150), 1, "default-bold", "left", "top")
        dxDrawText(lobbyText, 25, y, 0, 0, tocolor(255, 255, 255), 1, "default-bold", "left", "top")

        y = y + 25
    end
    if lobbyMatchesCount then
        local text = localize("lobby_matches_running") .. ": " .. tostring(lobbyMatchesCount)
        dxDrawText(text, 26, y + 1, 0, 0, tocolor(0, 0, 0, 150), 1, "default-bold", "left", "top")
        dxDrawText(text, 25, y, 0, 0, tocolor(255, 255, 255), 1, "default-bold", "left", "top")
    end

    local x = screenSize.x - 150
    local y = 20
    local alpha = 150
    if isMouseOver(x, y, 120, 120) then
        alpha = 255
        if isMousePressed then
            exports.pb_lang:setLanguage("russian")
            playSoundFrontEnd(1)
        end
    end
    dxDrawImage(x, y, 120, 120, "assets/ru.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

    y = y + 130
    alpha = 150
    if isMouseOver(x, y, 120, 120) then
        alpha = 255
        if isMousePressed then
            exports.pb_lang:setLanguage("english")
            playSoundFrontEnd(1)
        end
    end
    dxDrawImage(x, y, 120, 120, "assets/en.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

    drawMessageBox()
    drawWindow()
end)

function setVisible(visible)
    if isLobbyVisible == not not visible then
        return
    end
    isLobbyVisible = not not visible

    startGamePressed = false
    showCursor(isLobbyVisible)

    if isLobbyVisible then
        startSkinSelect()
    else
        stopSkinSelect()
    end
end

addEvent("updateLobbyPlayersCount", true)
addEventHandler("updateLobbyPlayersCount", root, function (count, matches)
    lobbyPlayersCount = count
    lobbyMatchesCount = matches
end)
