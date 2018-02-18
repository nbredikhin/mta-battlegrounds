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
    showCursor(false)
    setCursorVisible(false)
end)

addEventHandler("onClientResourceStop", resourceRoot, function ()
    setCursorAlpha(255)
end)

addDebugHook("postFunction", function (sourceResource, _, _, _, _, state)
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
