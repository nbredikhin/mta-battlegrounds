local showTimer

bindKey("mouse2", "down", function ()
    if localPlayer:getWeapon() == 34 then
        if isTimer(showTimer) then
            killTimer(showTimer)
        end
        local object = getLocalPlayerHat()
        if object then
            object.scale = 0
        end
    end
end)

bindKey("mouse2", "up", function ()
    showTimer = setTimer(function ()
        local object = getLocalPlayerHat()
        if object then
            object.scale = 1
        end
    end, 50, 1)
end)
