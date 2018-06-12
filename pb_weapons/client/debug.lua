if not Config.debugDrawEnabled then
    return
end

addEventHandler("onClientRender", root, function ()
    local x = 100
    local y = 300

    dxDrawText("weaponSlot: "..tostring(localPlayer:getData("weaponSlot")), x, y)
    y = y + 25
    dxDrawText("clip: "..getWeaponClip(), x, y)
    y = y + 25
    dxDrawText("isFireAllowed: "..tostring(getFireAllowed()), x, y)
    y = y + 25
    dxDrawText("isReloading: "..tostring(getReloading()), x, y)
    y = y + 25
    dxDrawText("Slots state: "..inspect(getLocalSlots()), x, y)
end)
