DefaultClothes = {}

DefaultClothes.shirt = "tshirt1"
DefaultClothes.pants = "jeans1"
DefaultClothes.shoes = "sneakers1"

function getDefaultClothes(name)
    if name then
        return DefaultClothes[name]
    end
end
