local screenSize = Vector2(guiGetScreenSize())

local buttonText = "НАЧАТЬ ИГРУ"
local logoWidth = 750
local logoHeight = 292

local arrowSize = 100

addEventHandler("onClientRender", root, function ()
    if not isLobbyActive then
        return
    end
    local mx, my = getCursorPosition()
    if not mx then
        mx, my = 0, 0
    end
    mx, my = mx * screenSize.x, my * screenSize.y
    local texture = "assets/corner0.png"
    local isOver = false
    if mx > 0 and mx <= 496 and my > 0 and my <= 250 then
        texture = "assets/corner1.png"
        isOver = true
    end
    dxDrawImage(0, 0, 496, 250, texture)
    dxDrawText(buttonText, 25 + 5, 20 + 5, 0, 0, tocolor(0, 0, 0, 150), 5, "default-bold", "left", "top")
    dxDrawText(buttonText, 25, 20, 0, 0, tocolor(255, 255, 255), 5, "default-bold", "left", "top")

    if isOver and getKeyState("mouse1") then
        buttonText = "ПОИСК МАТЧА"
    end

    local w = logoWidth * 0.3
    local h = logoHeight * 0.3
    dxDrawImage(screenSize.x - w - 10, screenSize.y - h - 40, w, h, "assets/logo.png", 0, 0, 0, tocolor(255, 255, 255, 100))
    dxDrawText("БЕТА-ТЕСТ", screenSize.x - w - 10, 0, screenSize.x - 10, screenSize.y - 30, tocolor(255, 150, 0, 100), 1.3, "default-bold", "center", "bottom")

    local offset = math.sin(getTickCount() * 0.008) * arrowSize * 0.1
    dxDrawImage(screenSize.x * 0.3 - arrowSize / 2 + offset, screenSize.y * 0.55, arrowSize, arrowSize, "assets/arrow.png", 180)
    dxDrawImage(screenSize.x * 0.7 - arrowSize / 2 - offset, screenSize.y * 0.55, arrowSize, arrowSize, "assets/arrow.png")
end)
