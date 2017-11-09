isShopVisible = false

function setVisible(visible)
    visible = not not visible
    if isShopVisible == visible then
        return
    end

    if visible then
        localPlayer.interior = 18
        createPreviewPed()
        local ped = getPreviewPed()
        setCameraMatrix(ped.matrix:transformPosition(-2, 0, 0.5), ped.matrix:transformPosition(0, -0.7, -0.05), 0, 90)
        addEventHandler("onClientRender", root, drawGUI)
    else
        destroyPreviewPed()
        removeEventHandler("onClientRender", root, drawGUI)
        localPlayer.interior = 0
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    setVisible(true)
end)
