for name, item in pairs(ClothesTable) do
    if item.price == "default" and item.rarity then
        item.price = Config.rarityPrices[item.rarity]
    end
end
