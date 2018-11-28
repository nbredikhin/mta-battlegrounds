function takeAllItems(player)
    if not isElement(player) then
        return
    end
    clearPlayerBackpack(player)
    clearPlayerWeapons(player)
    clearPlayerEquipment(player)
end
