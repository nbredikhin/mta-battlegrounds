function isPlayerAdmin(player)
    return hasObjectPermissionTo(player, "command.srun", false)
end

addCommandHandler("usergive", function (player, cmd, targetName, name)
    if not isPlayerAdmin(player) then
        return
    end
    local targetPlayer = getPlayerFromPartialName(targetName)
    if not isElement(targetPlayer) then
        return
    end
    local item = createItem(name)
    if not isItem(item) then
        outputDebugString("Item does not exist", name)
    end
    if addPlayerInventoryItem(targetPlayer, item) then
        outputConsole("You gave "..item.name.." to "..targetPlayer.name)
        outputDebugString("[ACCOUNTS] Admin " .. tostring(player.name) .. "(acc "..tostring(player:getData("username"))..") gave item "..tostring(item.name).." to "..targetPlayer.name)
    end
end)

addCommandHandler("userinfo", function (player, cmd, targetName)
    if not isPlayerAdmin(player) then
        return
    end
    local targetPlayer = getPlayerFromPartialName(targetName)
    if not isElement(targetPlayer) then
        outputConsole("Player not found")
        return
    end
    outputConsole("Name: "..targetPlayer.name)
    outputConsole("Username: "..targetPlayer:getData("username"))
    outputConsole("BP: "..targetPlayer:getData("battlepoints"))
    outputConsole("DP: "..targetPlayer:getData("donatepoints"))
end)

addCommandHandler("userpoints", function (player, cmd, targetName, count)
    if not isPlayerAdmin(player) then
        return
    end
    if not tonumber(count) then
        return false
    end
    local targetPlayer = getPlayerFromPartialName(targetName)
    if not isElement(targetPlayer) then
        return
    end
    local bp = targetPlayer:getData("battlepoints")
    bp = bp + tonumber(count)
    targetPlayer:setdata("battlepoints", bp)
    outputConsole("Player "..targetPlayer.name.." now has "..bp.." BP")
end)
