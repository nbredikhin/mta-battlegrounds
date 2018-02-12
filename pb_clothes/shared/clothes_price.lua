for name, item in pairs(ClothesTable) do
    if item.rarity then
        item.price = Config.rarityPrices[item.rarity]
    end
end

ClothesTable.mask_bandana1.price = 18000 -- Леопард
ClothesTable.mask_bandana2.price = 20000 -- Красная
ClothesTable.mask_bandana3.price = 16000 -- Обычная

ClothesTable.skirt3.price = 16000 -- Синяя юбка
ClothesTable.skirt4.price = 20000 -- Чёрная юбка

ClothesTable.shirt_top_pricess.price = 3500
