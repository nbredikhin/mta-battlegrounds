addEvent("afkKickSelf", true)
addEventHandler("afkKickSelf", root, function ()
    kickPlayer(client, "You are AFK too long")
end)
