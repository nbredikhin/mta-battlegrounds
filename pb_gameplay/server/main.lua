addEventHandler("onResourceStart", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        player:removeData("matchId")
        player.dimension = 0
        player.nametagShowing = false
    end
end)

addEventHandler("onResourceStop", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        player.dimension = 0
        player.nametagShowing = true
    end
end)

addEventHandler("onPlayerJoin", root, function ()
    source.nametagShowing = false
end)
