isShopVisible = false

function setVisible(visible)
    visible = not not visible
    if isShopVisible == visible then
        return
    end
    isShopVisible = visible

    showCursor(visible)
    if visible then
        localPlayer.interior = 18
        localPlayer.position = Vector3(0, 3500, 10)
        localPlayer.frozen = true
        createPreviewPed()
        setTimer(function ()
            local ped = getPreviewPed()
            setCameraMatrix(ped.matrix:transformPosition(0, 2, 0.5), ped.matrix:transformPosition(-0.7, 0, -0.05), 0, 90)
            loadGUI()
            fadeCamera(true)
        end, 500, 1)
    else
        localPlayer.frozen = false
        destroyPreviewPed()
        unloadGUI()
        localPlayer.interior = 0
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    -- setVisible(true)
end)

function buyClothes(name)
    if not name then
        return
    end
    triggerServerEvent("onPlayerBuyClothes", resourceRoot, "clothes_" .. name)
end
