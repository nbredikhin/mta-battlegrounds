addCommandHandler("addloot", function (player, cmd, level, tag)
    createLootSpawnpoint(player.position - Vector3(0, 0, 1), level, tag)
    local spawnpoints = getLootSpawnpoints()
    triggerClientEvent(root, "showLootSpawnpoints", resourceRoot, spawnpoints)
    outputChatBox("Spawnpoint added ("..tostring(#spawnpoints) .. ")")
end)

addCommandHandler("removeloot", function (player)
    local spawnpoints = getLootSpawnpoints()
    local x, y, z = getElementPosition(player)
    for i, spawnpoint in ipairs(spawnpoints) do
        if getDistanceBetweenPoints3D(x, y, z, spawnpoint.x, spawnpoint.y, spawnpoint.z) < 3 then
            removeLootSpawnpoint(i)
            triggerClientEvent(root, "showLootSpawnpoints", resourceRoot, spawnpoints)
            outputChatBox("Spawnpoint removed")
            break
        end
    end
end)

addCommandHandler("showloot", function (player)
    triggerClientEvent(player, "showLootSpawnpoints", resourceRoot, getLootSpawnpoints())
    outputChatBox("Spawnpoints showing")
end)
