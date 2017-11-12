local pricesTable = {}

pricesTable.tshirt1 = 200
pricesTable.tshirt2 = 250
pricesTable.tshirt4 = 300
pricesTable.tshirt5 = 400
pricesTable.tshirt6 = 500
pricesTable.tshirt7 = 600
pricesTable.tshirt_ccd = 2500

for name, value in pairs(pricesTable) do
    if ClothesTable[name] then
        ClothesTable[name].price = value
    end
end
