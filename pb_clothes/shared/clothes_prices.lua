local pricesTable = {}

pricesTable.tshirt1 = 20
pricesTable.tshirt2 = 25
pricesTable.tshirt4 = 30
pricesTable.tshirt5 = 40
pricesTable.tshirt6 = 50
pricesTable.tshirt7 = 60
pricesTable.tshirt_ccd = 250

for name, value in pairs(pricesTable) do
    if ClothesTable[name] then
        ClothesTable[name].price = value
    end
end
