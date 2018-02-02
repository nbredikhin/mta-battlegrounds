local skills = {
    "std",
    "pro",
    "poor"
}

function setupWeaponProps()
    for name, props in pairs(Config.overrideWeaponProperties) do
        for k, v in pairs(props) do
            for i, skill in ipairs(skills) do
                setWeaponProperty(name, skill, k, v)
            end
        end
    end
end

addEventHandler("onResourceStart", resourceRoot, function ()
    if string.find(string.lower(getServerName()), "squad") or string.find(string.lower(getServerName()), "test") then
        setServerMatchType("squad")
    else
        setServerMatchType("solo")
    end
    setupWeaponProps()

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
    source.dimension = 1000 + math.random(1, 1000)
    source.position = Vector3(-4000, 4000, 1000)
    source.frozen = true
end)

local overrideStat = {
    [69] = 0,
    [75] = 0
}

function initPlayerSkillStats(player)
    if not isElement(player) then
        return
    end
    -- Владение оружием
    for i = 69, 79 do
        local stat = overrideStat[i] or 1000
        player:setStat(i, stat)
    end
    -- Навыки вождения
    player:setStat(160, 1000)
    player:setStat(229, 1000)
    player:setStat(230, 1000)
end

addCommandHandler("kill", function (player)
    if not player:getData("matchId") or player.dead then
        return
    end
    killPed(player)
end)
