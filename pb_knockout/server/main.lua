function knockoutPlayer(player)
    if not isElement(player) then
        return
    end
    player:setData("knockout", true)
    local knockoutCount = player:getData("knockoutCount") or 0
    player:setData("knockoutCount", knockoutCount + 1)
end

function resetPlayerKnockout(player)
    player:setData("knockout", false)
    player:setData("knockoutCount", 0)
end
