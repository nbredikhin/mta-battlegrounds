local cursorState = false

function isCursorVisible()
    return cursorState or isMTAWindowActive()
end

function setCursorVisible(visible)
    if visible then
        setCursorAlpha(255)
    else
        setCursorAlpha(0)
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    showCursor(true, false)
    setCursorVisible(false)

    if localPlayer.vehicle then
        showCursor(false)
        setCustomCameraEnabled(false)
    end
end)

addEventHandler("onClientResourceStop", resourceRoot, function ()
    setCursorAlpha(255)
end)

addDebugHook("postFunction", function (sourceResource, _, _, _, _, state)
    if sourceResource == resource then
        return
    end
    cursorState = not not state

    if cursorState then
        setCursorVisible(true)
    else
        setCursorVisible(false)
        local sx, sy = guiGetScreenSize()
        setCursorPosition(sx/2, sy/2)
        showCursor(false)
        showCursor(true, false)
    end
end, {"showCursor"})

addEventHandler("onClientPlayerVehicleEnter", localPlayer, function ()
    showCursor(false)
    setCustomCameraEnabled(false)
end)

addEventHandler("onClientPlayerVehicleExit", localPlayer, function ()
    showCursor(true, false)
    setCustomCameraEnabled(true)
end)
