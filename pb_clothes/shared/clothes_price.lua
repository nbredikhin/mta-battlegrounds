for name, item in pairs(ClothesTable) do
    if item.rarity then
        item.price = Config.rarityPrices[item.rarity]
    end
end
