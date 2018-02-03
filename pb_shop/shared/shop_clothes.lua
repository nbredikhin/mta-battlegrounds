ShopClothes = {
    hat = {},
    body = {},
    jacket = {},
    legs = {},
    feet = {},
    gloves = {},
    mask = {},
    glasses = {},
}

local clothesTable = exports.pb_clothes:getClothesTable()
if not clothesTable then
    return
end
local function addClothesToShop(name, category)
    if not ShopClothes[category] then
        return
    end
    if clothesTable[name] then
        table.insert(ShopClothes[category], { clothes = name, name = clothesTable[name].readableName, price = clothesTable[name].price })
    end
end

for name, item in pairs(clothesTable) do
    if item.layer and type(item.price) == "number" and ShopClothes[item.layer] then
        table.insert(ShopClothes[item.layer], {
            clothes = name,
            name = item.name,
            price = item.price
        })
    end
end


for name, clothes in pairs(ShopClothes) do
    table.sort(clothes, function (a, b)
        -- Сортировка по цене или по алфавиту
        if not a.price or not b.price or a.price == b.price then
            return a.name < b.name
        else
            return a.price < b.price
        end
    end)
end
