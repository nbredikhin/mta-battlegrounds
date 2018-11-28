for name, item in pairs(ClothesTable) do
    if item.rarity then
        item.price = Config.rarityPrices[item.rarity]

        if item.priceMul then
            if item.price > 1000 then
                item.price = math.max(5, math.ceil(math.floor(item.price * item.priceMul) / 100) * 100)
            else
                item.price = math.max(5, math.ceil(math.floor(item.price * item.priceMul) / 5) * 5)
            end
        end
    end
end
