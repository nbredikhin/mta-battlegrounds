if not Config.debugCommandsEnabled then
    return
end

addCommandHandler("debugui", function (cmd, mode)
    mode = tonumber(mode)
    if not mode or mode > 2 or mode < 0 or mode - math.floor(mode) ~= 0 then
        outputChatBox("debugui: Syntax is 'debugui <mode>'")
        return
    end

    Config.debugDrawBoxes = mode >= 1
    Config.debugDrawNames = mode >= 2

    outputChatBox("debugui: Your debug mode was set to "..tostring(mode))
end)
