addEventHandler("onClientPlayerDamage", localPlayer, function ()
    if localPlayer:getData("match_waiting") then
        cancelEvent()
    end
end)

addEventHandler("onClientPreRender", root, function ()
    if localPlayer:getData("match_waiting") then
        localPlayer.health = 100
    end
end)

setTimer(function ()
    if localPlayer:getData("match_waiting") then
    	if #(Config.waitingPosition - localPlayer.position) > 400 then
    		localPlayer.position = Config.waitingPosition
    	end
    end
end, 1000, 0)