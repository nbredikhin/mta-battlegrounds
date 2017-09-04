function findMatch()
    setTimer(function ()
        triggerServerEvent("playerFindMatch", resourceRoot)
    end, 1000, 1)
end


addEventHandler("onClientResourceStart", resourceRoot, function ()
    setVisible(true)
end)
