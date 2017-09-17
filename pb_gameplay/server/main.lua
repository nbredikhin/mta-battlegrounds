addEventHandler("onResourceStart", resourceRoot, function ()
    setGameType("Battle Royale")

    for i, player in ipairs(getElementsByType("player")) do
        player:removeData("matchId")
        player.dimension = 0
        player.nametagShowing = false

        initPlayerSkillStats(player)
    end
end)

addEventHandler("onResourceStop", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        player.dimension = 0
        player.nametagShowing = true
    end
end)

addEventHandler("onPlayerJoin", root, function ()
    initPlayerSkillStats(source)

    source.nametagShowing = false
end)

function initPlayerSkillStats(player)
    if not isElement(player) then
        return
    end
    for i = 69, 79 do
        player:setStat(i, 1000)
    end
end