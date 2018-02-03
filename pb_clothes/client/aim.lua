local showTimer

bindKey("mouse2", "down", function ()
    if localPlayer:getWeapon() == 34 then
        if isTimer(showTimer) then
            killTimer(showTimer)
        end
        local objects = getPlayerAttachedObjects(localPlayer)
        if objects then
            for layer, object in pairs(objects) do
                object.scale = 0
            end
        end
    end
end)

bindKey("mouse2", "up", function ()
    showTimer = setTimer(function ()
        local objects = getPlayerAttachedObjects(localPlayer)
        if objects then
            for layer, object in pairs(objects) do
                object.scale = 1
            end
        end
    end, 50, 1)
end)
