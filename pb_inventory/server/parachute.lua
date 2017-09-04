function givePlayerParachute(player)
    if not isElement(player) then
        return
    end

    hidePlayerWeapon(player)
    player:setData("has_parachute", true)
    giveWeapon(player, 46, 1, true)
end

function takePlayerParachute(player)
    if not isElement(player) then
        return
    end
    if not player:getData("has_parachute") then
        return
    end
    player:removeData("has_parachute")
    hidePlayerWeapon(player)
end

function hasPlayerParachute(player)
    return isElement(player) and player:getData("has_parachute")
end

addEvent("onPlayerUsedParachute", false)
addEventHandler("onPlayerUsedParachute", root, function ()
    takePlayerParachute(source)
end)

addEventHandler("onResourceStart", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        player:removeData("has_parachute")
    end
end)
