function isPlayerAdmin(player)
    return hasObjectPermissionTo(player, "command.srun", false)
end

addCommandHandler("wear", function (player, cmd, name)
    if not isPlayerAdmin(player) then
        return
    end
    if not name then
        for i, name in ipairs(layerNames) do
            player:setData("clothes_"..name, false, true)
        end
    else
        addPedClothes(player, name, true)
    end
end)
