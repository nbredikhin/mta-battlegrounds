local textures = {}

function getClothesIcon(name)
    if name and ClothesTable[name] then
        if not textures[name] then
            textures[name] = dxCreateTexture("assets/textures/icons/"..ClothesTable[name].icon)
        end
        return textures[name]
    end
end
