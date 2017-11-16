addEvent("afkKickSelf", true)
addEventHandler("afkKickSelf", root, function (reason)
    kickPlayer(client, reason)
end)
