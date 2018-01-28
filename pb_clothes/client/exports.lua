local textures = {}
local placeholderTexture = dxCreateTexture("assets/textures/placeholder.png")

function getClothesIcon(name)
    if name and ClothesTable[name] and ClothesTable[name].icon then
        if not textures[name] then
            textures[name] = dxCreateTexture("assets/textures/icons/"..ClothesTable[name].icon)
        end
        return textures[name]
    else
        return placeholderTexture
    end
end
