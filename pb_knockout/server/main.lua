function knockoutPlayer(player)
    if not isElement(player) then
        return
    end
    player.vehicle = nil
    player:setData("knockout", true)
    local knockoutCount = player:getData("knockoutCount") or 0
    player:setData("knockoutCount", knockoutCount + 1)
    player.health = 100
end

function resetPlayerKnockout(player)
    if not isElement(player) then
        return
    end
    player:setData("knockout", false)
    player:setData("knockoutCount", 0)
end

function reviveKnockedPlayer(player)
    if not isElement(player) then
        return
    end
    player:setData("knockout", false)
    player.health = 10
end

addCommandHandler("knockout", function (player)
    knockoutPlayer(player)
end)
