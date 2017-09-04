local screenSize = Vector2(guiGetScreenSize())
local defaultColor = tocolor(250, 250, 150)
local shadowColor = tocolor(0, 0, 0, 100)

local currentText
local currentColor

local hideTimer

function show(text, time, color)
    currentText = tostring(text)
    currentColor = tonumber(color) or defaultColor

    if isTimer(hideTimer) then
        killTimer(hideTimer)
    end
    hideTimer = setTimer(function ()
        currentText = nil
    end, time, 1)
end

addEventHandler("onClientRender", root, function ()
    if not currentText then
        return
    end
    dxDrawText(currentText, 1, 1, screenSize.x + 1, screenSize.y * 0.75 + 1, shadowColor, 2.5, "default-bold", "center", "bottom")
    dxDrawText(currentText, 2, 2, screenSize.x + 2, screenSize.y * 0.75 + 2, shadowColor, 2.5, "default-bold", "center", "bottom")
    dxDrawText(currentText, 3, 3, screenSize.x + 3, screenSize.y * 0.75 + 3, shadowColor, 2.5, "default-bold", "center", "bottom")
    dxDrawText(currentText, 0, 0, screenSize.x, screenSize.y * 0.75, currentColor, 2.5, "default-bold", "center", "bottom")
end)

-- show("МАТЧ НАЧИНАЕТСЯ ЧЕРЕЗ\n30", 5000)
addEvent("pbShowAlert", true)
addEventHandler("pbShowAlert", resourceRoot, function (text, time, color)
    show(text, time, color)
end)
