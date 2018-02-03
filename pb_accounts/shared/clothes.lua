DefaultClothes = {}

DefaultClothes.body = "tshirt_ls_dirty"
DefaultClothes.legs = "pants_combat5"
DefaultClothes.feet = "trainers_hitop1"

function getDefaultClothes(name)
    if name then
        return DefaultClothes[name]
    end
end

function calculateClothesSellPrice(price)
    if type(price) ~= "number" then
        return 0
    end
    price = price * Config.donatepointsToBattlepoints
    return math.min(200, math.floor(price * 0.02))
end
