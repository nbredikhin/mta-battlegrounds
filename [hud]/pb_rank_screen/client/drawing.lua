local screenSize = Vector2(guiGetScreenSize())

local isScreenVisible = false

local fonts = {}
local colors = {
    white = tocolor(255, 255, 255, 255),
    orange = tocolor(235, 196, 15, 255),
    grey  = tocolor(180, 180, 180, 100),
}

local scale = 1

local isMousePressed = false
local prevMouseState = false
local mouseX = 0
local mouseY = 0

function isMouseOver(x, y, w, h)
    return mouseX >= x and mouseX <= x + w and mouseY >= y and mouseY <= y + h
end

local function drawButton(text, x, y, width, height, bg, color, scale)
    if not bg then bg = tocolor(250, 250, 250) end
    if not color then color = tocolor(0, 0, 0, 200) end
    if not scale then scale = 1 end
    dxDrawRectangle(x, y, width, height, bg)
    dxDrawRectangle(x, y + height - 5, width, 5, tocolor(0, 0, 0, 10))
    dxDrawText(text, x, y, x + width, y + height, color, scale, fonts.normal, "center", "center")

    if isMouseOver(x, y, width, height) then
        dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 100))
        if isMousePressed then
            return true
        end
    end
    return false
end

addEventHandler("onClientRender", root, function ()
    if not isScreenVisible then
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

    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 230))
    dxDrawText("Wherry", 50, 50, 51, 51, colors.white, 1, fonts.big, "left", "top")
    dxDrawText("ВЫ ПОПАЛИ В ТОП-999!", 50, 120, 51, 121, colors.orange, 1, fonts.medium, "left", "top")
    dxDrawText("№ 99", 0, 50, screenSize.x - 50 - 130, 51, colors.orange, scale, fonts.bigger_bold, "right", "top")
    dxDrawText("/99", screenSize.x - 50 - 125, 50, screenSize.x, 51, colors.grey, scale, fonts.bigger, "left", "top")

    local ry = 240
    local rx = 50
    local rtext = "РАНГ № 999"
    local rw = dxGetTextWidth(rtext, 1, fonts.medium)
    local rh = dxGetFontHeight(1, fonts.medium)
    dxDrawText(rtext, rx, ry, rx + rw, ry + 1, colors.white, 1, fonts.medium, "left", "top")
    dxDrawLine(rx, ry + rh + 15, rx + rw, ry + rh + 15, colors.grey)

    ry = ry + rh + 30
    dxDrawText("ВРЕМЯ ЖИЗНИ", rx, ry, rx + rw, ry + 1, colors.grey, 1, fonts.small, "left", "top")
    dxDrawText("999 МИН", rx, ry, rx + rw, ry + 1, colors.grey, 1, fonts.small, "right", "top")
    ry = ry + 25
    dxDrawText("ОЧКИ УБИЙСТВ", rx, ry, rx + rw, ry + 1, colors.grey, 1, fonts.small, "left", "top")
    dxDrawText("9999", rx, ry, rx + rw, ry + 1, colors.grey, 1, fonts.small, "right", "top")
    ry = ry + 25
    dxDrawText("ОЧКИ ЧЕГО-ТО ЕЩЁ", rx, ry, rx + rw, ry + 1, colors.grey, 1, fonts.small, "left", "top")
    dxDrawText("9999", rx, ry, rx + rw, ry + 1, colors.grey, 1, fonts.small, "right", "top")

    if scale > 0.9 then
        ry = 240
        rx = rx + rw + 40
        rtext = "УБИЙСТВ 999"
        rw = dxGetTextWidth(rtext, 1, fonts.medium)
        dxDrawText(rtext, rx, ry, rx + rw, ry + 1, colors.white, 1, fonts.medium, "left", "top")
        dxDrawLine(rx, ry + rh + 15, rx + rw, ry + rh + 15, colors.grey)

        ry = ry + rh + 30
        dxDrawText("НАНЕСЕНО УРОНА", rx, ry, rx + rw, ry + 1, colors.grey, 1, fonts.small, "left", "top")
        dxDrawText("9999", rx, ry, rx + rw, ry + 1, colors.grey, 1, fonts.small, "right", "top")
        ry = ry + 25
        dxDrawText("ПОЛУЧЕНО УРОНА", rx, ry, rx + rw, ry + 1, colors.grey, 1, fonts.small, "left", "top")
        dxDrawText("9999", rx, ry, rx + rw, ry + 1, colors.grey, 1, fonts.small, "right", "top")
        ry = ry + 25
        dxDrawText("ВЫЛЕЧЕНО HP", rx, ry, rx + rw, ry + 1, colors.grey, 1, fonts.small, "left", "top")
        dxDrawText("9999", rx, ry, rx + rw, ry + 1, colors.grey, 1, fonts.small, "right", "top")

    end

    ry = 240
    rx = rx + rw + 40
    rtext = "НАГРАДА 9999"
    rw = dxGetTextWidth(rtext, 1, fonts.medium)
    dxDrawText(rtext, rx, ry, rx + rw, ry + 1, colors.white, 1, fonts.medium, "left", "top")
    dxDrawLine(rx, ry + rh + 15, rx + rw, ry + rh + 15, colors.grey)

    ry = ry + rh + 30
    dxDrawText("ОЧКИ РАНГА", rx, ry, rx + rw, ry + 1, colors.grey, 1, fonts.small, "left", "top")
    dxDrawText("9999", rx, ry, rx + rw, ry + 1, colors.grey, 1, fonts.small, "right", "top")
    ry = ry + 25
    dxDrawText("ОЧКИ УБИЙСТВ", rx, ry, rx + rw, ry + 1, colors.grey, 1, fonts.small, "left", "top")
    dxDrawText("9999", rx, ry, rx + rw, ry + 1, colors.grey, 1, fonts.small, "right", "top")
    ry = ry + 25
    dxDrawText("ОЧКИ ЧЕГО-ТО ЕЩЁ", rx, ry, rx + rw, ry + 1, colors.grey, 1, fonts.small, "left", "top")
    dxDrawText("9999", rx, ry, rx + rw, ry + 1, colors.grey, 1, fonts.small, "right", "top")

    local bw = 200
    local bh = 50
    if drawButton("Выйти в лобби", screenSize.x / 2 - bw / 2, screenSize.y - bh - 50, bw, bh) then
        setVisible(false)
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    fonts.bigger_bold = dxCreateFont("assets/Roboto-Bold.ttf", 54)
    fonts.bigger = dxCreateFont("assets/Roboto-Regular.ttf", 54)
    fonts.big    = dxCreateFont("assets/Roboto-Regular.ttf", 35)
    fonts.medium = dxCreateFont("assets/Roboto-Regular.ttf", 28)
    fonts.small  = dxCreateFont("assets/Roboto-Regular.ttf", 12)
    fonts.normal  = dxCreateFont("assets/Roboto-Bold.ttf", 14)

    if screenSize.x < 1024 then
        scale = 0.5
    end

    setVisible(false)
end)

function setVisible(visible)
    if isScreenVisible == not not visible then
        return
    end

    isScreenVisible = not not visible

    showCursor(isScreenVisible)
    if isScreenVisible then

    else

    end
end

function isVisible()
    return isScreenVisible
end
