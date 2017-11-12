ShopClothes = {
    hat = {},
    bomber = {},
    woolcoat = {},
    pants = {},
    shoes = {},
    tshirt = {}
}

local clothesTable = exports.pb_clothes:getClothesTable()
if not clothesTable then
    return
end
local function addClothesToShop(name, category)
    if clothesTable[name] then
        table.insert(ShopClothes[category], { clothes = name, name = clothesTable[name].readableName, price = clothesTable[name].price })
    end
end

for name, item in pairs(clothesTable) do
    if ShopClothes[item.material] then
        addClothesToShop(name, item.material)
    elseif ShopClothes[item.layer] then
        addClothesToShop(name, item.layer)
    end
end

for name, clothes in pairs(ShopClothes) do
    table.sort(clothes, function (a, b)
        return a.name < b.name
    end)
end
