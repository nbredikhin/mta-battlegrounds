ItemClasses = {}

local clothesTable = exports.pb_clothes:getClothesTable()
if clothesTable then
    for name, data in pairs(clothesTable) do
        if data.layer ~= "head" then
            ItemClasses["clothes_"..name] = {
                clothes      = name,
                price        = data.price or 0,
                layer        = data.layer,
                readableName = data.readableName
            }
        end
    end
end

ItemClasses["crate_weekly1"] = {
    price = 700,
    crateItems = {
        "clothes_jeans1",
        "clothes_jeans2",
        "clothes_jeans3",
        "clothes_jeans4",
    },
    crateChances = {
        {0.99, 1, 3},
        {0.01, 4, 4},
    },
    readableName = "Random Weekly Crate #1"
}

function isItem(item)
    if type(item) == "table" and item.name and ItemClasses[item.name] then
        return true
    else
        return false
    end
end

function getItemClass(item)
    if type(item) == "string" then
        return ItemClasses[item]
    end
    if isItem(item) then
        return ItemClasses[item.name]
    end
end
