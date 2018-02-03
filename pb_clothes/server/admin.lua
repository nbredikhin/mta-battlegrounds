function isPlayerAdmin(player)
    return hasObjectPermissionTo(player, "command.srun", false)
end

addCommandHandler("wear", function (player, cmd, name)
    if not isPlayerAdmin(player) then
        return
    end
    if name then
        addPedClothes(player, name, true)
    end
end)

addCommandHandler("unwear", function (player, cmd, name)
    if not isPlayerAdmin(player) then
        return
    end
    if name then
        player:setData("clothes_"..name, false, true)
    end
end)
