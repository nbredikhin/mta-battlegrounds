if Config.debugCommandsEnabled then
    addCommandHandler("debugui", function (cmd, mode)
        mode = tonumber(mode)
        if not mode or mode > 3 or mode < 0 or mode - math.floor(mode) ~= 0 then
            outputChatBox("debugui: Syntax is 'debugui <mode>'")
            return
        end

        Config.debugDrawBoxes      = mode >= 1
        Config.debugDrawNames      = mode >= 2
        Config.debugDrawRenderTime = mode >= 3

        outputChatBox("debugui: Your debug mode was set to "..tostring(mode))
    end)
end

if Config.debugDrawCalls then
    local functionNames = {
        "dxDrawImage",
        "dxDrawImageSection",
        "dxDrawLine",
        "dxDrawRectangle",
        "dxDrawText",
    }

    local drawCalls = 0

    addEventHandler("onClientRender", root, function ()
        dxDrawText("Draw Calls: "..drawCalls, 20, 400, 0, 0, tocolor(255, 0, 0))
        drawCalls = 0
    end)

    for i, name in ipairs(functionNames) do
        local oldFunc = _G[name]
        _G[name] = function (...)
            drawCalls = drawCalls + 1
            return oldFunc(...)
        end
    end
end
