addEvent("onPlayerStartReviving", true)
addEventHandler("onPlayerStartReviving", resourceRoot, function (targetPlayer)
    if not isElement(targetPlayer) then
        return
    end
    if targetPlayer == client then
        return
    end
    if getDistanceBetweenPoints3D(client.position, targetPlayer.position) > 2 then
        return
    end
    if targetPlayer:getData("revivingBy") then
        return
    end

    client:setData("revivingTarget", targetPlayer, false)
    targetPlayer:setData("revivingBy", client, false)
    targetPlayer:removeData("revivingTarget", client, false)
    triggerClientEvent(client, "onClientRevivingStart", resourceRoot, targetPlayer)
    triggerClientEvent(targetPlayer, "onClientRevivingStart", resourceRoot)

    local vector = client.position - targetPlayer.position
    client.rotation = Vector3(0, 0, math.deg(math.atan2(vector.y, vector.x)) - 270)

    client:setAnimation("BOMBER", "BOM_Plant_Loop", -1, true, false, true)
end)

local function stopReviving(player, targetPlayer)
    if isElement(player) then
        triggerClientEvent(player, "onClientRevivingStop", resourceRoot)
        player:removeData("revivingTarget")
        player:setAnimation()
    end
    if isElement(targetPlayer) then
        triggerClientEvent(targetPlayer, "onClientRevivingStop", resourceRoot)
        targetPlayer:removeData("revivingBy")
    end
end

addEvent("onPlayerCancelReviving", true)
addEventHandler("onPlayerCancelReviving", resourceRoot, function ()
    cancelPlayerReviving(client)
end)

addEvent("onPlayerFinishReviving", true)
addEventHandler("onPlayerFinishReviving", resourceRoot, function ()
    local targetPlayer = client:getData("revivingTarget")
    if not isElement(targetPlayer) then
        return
    end
    stopReviving(client, targetPlayer)
    -- Поднятие игрока
    reviveKnockedPlayer(targetPlayer)
end)

addEventHandler("onResourceStart", resourceRoot, function ()
    for i, player in pairs(getElementsByType("player")) do
        player:removeData("reviving")
        player:removeData("revivingTarget")
        player:removeData("revivingBy")
    end
end)

addEventHandler("onPlayerQuit", root, function ()
    cancelPlayerReviving(source)
end)

function cancelPlayerReviving(player)
    if player:getData("revivingBy") then
        stopReviving(player:getData("revivingBy"), player)
    else
        stopReviving(player, player:getData("revivingTarget"))
    end
end
