ShopClothes = {
    hat = {},
    -- Торс
    tshirt = {},
    shirt = {},
    sweater = {},
    hoodie = {},
    jacket = {},
    woolcoat = {},
    sport_jacket = {},
    shirt_other = {},
    -- Штаны
    cargopnts = {},
    hunterpnts = {},
    jeans = {},
    slacks = {},
    tracksuitpnts = {},
    pants_other = {},
    -- Обувь
    boots = {},
    sport_shoes = {},
    shoes_other = {},
}

local materialSections = {
    blouse      = "shirt",
    gorka       = "jacket",
    mjacket     = "jacket",
    nbc         = "jacket",
    bubblegoose = "jacket",
    hunting     = "jacket",
    bomber      = "jacket",
    raincoat    = "jacket",
    riders      = "jacket",
    quilted     = "sport_jacket",
    tracksuit   = "sport_jacket",
    pcu         = "sport_jacket",
    athletics   = "sport_shoes",
    joggings    = "sport_shoes",
    sneakers    = "sport_shoes",
    combat      = "boots",
    hiking      = "boots",
    hikingbh    = "boots",
    jungleb     = "boots",
    militaryb   = "boots",
    wellies     = "boots",
    workingb    = "boots",
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
    local targetMaterial = item.material
    if materialSections[item.material] then
        targetMaterial = materialSections[item.material]
    end
    if ShopClothes[targetMaterial] then
        addClothesToShop(name, targetMaterial)
    elseif ShopClothes[item.layer .. "_other"] then
        addClothesToShop(name, item.layer .. "_other")
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
