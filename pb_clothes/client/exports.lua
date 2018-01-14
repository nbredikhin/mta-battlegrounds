function getClothesIcon(name)
    if name and ClothesTable[name] then
        return ClothesTable[name].icon
    end
end
