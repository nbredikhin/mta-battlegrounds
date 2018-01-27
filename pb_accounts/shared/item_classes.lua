ItemClasses = {}

local clothesTable = exports.pb_clothes:getClothesTable()
if clothesTable then
    for name, data in pairs(clothesTable) do
        if data.layer ~= "head" then
            ItemClasses["clothes_"..name] = {
                clothes      = name,
                price        = data.price or 0,
                layer        = data.layer,
                readableName = data.name
            }
        end
    end
end

ItemClasses["crate_weekly1"] = {
    crateItems = {
        "clothes_jeans1",
        "clothes_jeans2",
        "clothes_jeans3",
        "clothes_jeans4",
    },
    crateChances = {
        {0.4, 1, 1},
        {0.3, 2, 2},
        {0.2, 3, 3},
        {0.1, 4, 4},
    },
    readableName = "Wanderer Crate"
}

ItemClasses["crate_weekly2"] = {
    crateItems = {
        "clothes_tshirt1",
        "clothes_tshirt2",
        "clothes_tshirt3",
        "clothes_tshirt4",
    },
    crateChances = {
        {0.4, 1, 1},
        {0.3, 2, 2},
        {0.2, 3, 3},
        {0.1, 4, 4},
    },
    readableName = "Survivor Crate"
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
