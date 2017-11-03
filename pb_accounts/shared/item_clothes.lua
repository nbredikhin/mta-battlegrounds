addEventHandler("onResourceStart", resourceRoot, function ()
    --local clothesTable = exports.pb_clothes:getClothesTable()
    if not clothesTable then
        return
    end

    for name, data in pairs(clothesTable) do
        ItemClasses["clothes_"..name] = {
            clothes = name,
            price   = data.price or 0
        }
    end
end)
