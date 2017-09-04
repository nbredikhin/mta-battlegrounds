local screenSize = Vector2(guiGetScreenSize())
local isLobbyVisible = false

local isMousePressed = false
local prevMouseState = false
local mouseX = 0
local mouseY = 0

local startGamePressed = false

function isMouseOver(x, y, w, h)
    return mouseX >= x     and
           mouseX <= x + w and
           mouseY >= y     and
           mouseY <= y + h
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
    local text = "НАЧАТЬ ИГРУ"
    if startGamePressed then
        text = "ПОИСК МАТЧА"
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
    dxDrawText("БЕТА-ТЕСТ", screenSize.x - w - 10, 0, screenSize.x - 10, screenSize.y - 30, tocolor(255, 150, 0, 100), 1.3, "default-bold", "center", "bottom")
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
