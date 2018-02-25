-- outputConsole("---")
for name, item in pairs(ClothesTable) do
    if item.rarity then
        if not item.price then
            item.price = Config.rarityPrices[item.rarity]
        end
        -- outputConsole(item.name .. " - " .. item.price .. " BP")
    end
end
