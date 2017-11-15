function playItemSound(item)
    if not isItem(item) then
        return
    end
    local itemClass = getItemClass(item.name)
    if itemClass.sound then
        playSound("assets/sounds/"..tostring(itemClass.sound))
    end
end
