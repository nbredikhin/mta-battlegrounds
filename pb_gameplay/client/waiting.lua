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
