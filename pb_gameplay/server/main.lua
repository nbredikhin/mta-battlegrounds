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
    player:setStat("WEAPONTYPE_PISTOL_SKILL",          1000)
    player:setStat("WEAPONTYPE_PISTOL_SILENCED_SKILL", 1000)
    player:setStat("WEAPONTYPE_DESERT_EAGLE_SKILL",    1000)
    player:setStat("WEAPONTYPE_SHOTGUN_SKILL",         1000)
    player:setStat("WEAPONTYPE_SAWNOFF_SHOTGUN_SKILL", 1000)
    player:setStat("WEAPONTYPE_SPAS12_SHOTGUN_SKILL",  1000)
    player:setStat("WEAPONTYPE_MICRO_UZI_SKILL",       1000)
    player:setStat("WEAPONTYPE_MP5_SKILL",             1000)
    player:setStat("WEAPONTYPE_AK47_SKILL",            1000)
    player:setStat("WEAPONTYPE_M4_SKILL",              1000)
    player:setStat("WEAPONTYPE_SNIPERRIFLE_SKILL",     1000)
end
