DefaultClothes = {}

DefaultClothes.shirt = "tshirt1"
DefaultClothes.pants = "jeans1"
DefaultClothes.shoes = "sneakers1"

function getDefaultClothes(name)
    if name then
        return DefaultClothes[name]
    end
end

function calculateClothesSellPrice(price)
    if type(price) ~= "number" then
        return 0
    end
    return math.min(200, math.floor(price * 0.05))
end