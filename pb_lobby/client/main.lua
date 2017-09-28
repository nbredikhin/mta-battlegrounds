function findMatch()
    setTimer(function ()
        triggerServerEvent("playerFindMatch", resourceRoot)
    end, 1000, 1)
end

function addLobbyPlayer(player)

end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    setVisible(true)
end)
