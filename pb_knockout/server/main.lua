function knockoutPlayer(player, killer)
    if not isElement(player) then
        return
    end
    player.vehicle = nil
    player:setData("knockout", true)
    local knockoutCount = player:getData("knockoutCount") or 0
    player:setData("knockoutCount", knockoutCount + 1)
    player.health = 100
    if isElement(killer) then
        player:setData("knockedBy", killer)
    end
end

function resetPlayerKnockout(player)
    if not isElement(player) then
        return
    end
    player:setData("knockout", false)
    player:setData("knockoutCount", 0)
    player:removeData("knockedBy")
end

function reviveKnockedPlayer(player)
    if not isElement(player) then
        return
    end
    player:setData("knockout", false)
    player:removeData("knockedBy")
    player.health = 10
end

addEventHandler("onVehicleStartEnter", root, function (player)
    if player:getData("knockout") then
        cancelEvent()
    end
end)

-- addCommandHandler("knockout", function (player)
--     if player:getData("knockout") then
--         reviveKnockedPlayer(player)
--     else
--         knockoutPlayer(player)
--     end
-- end)
