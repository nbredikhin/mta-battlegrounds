ClothesTable = {}

function getClothesTable()
    return ClothesTable
end

local function addNumberedClothes(baseName, count, basePath, layer, material, hideElbow)
    for i = 1, count do
        ClothesTable[baseName..i] = {
            layer = layer,
            material = material or baseName,
            hideElbow = hideElbow,
            path = basePath .. baseName..i..".png",
            price = 10
        }
    end
end

function addPedClothes(ped, name, sync)
    if not isElement(ped) or type(name) ~= "string" then
        return
    end
    if not ClothesTable[name] then
        return
    end
    ped:setData("clothes_"..tostring(ClothesTable[name].layer), name, not not sync)
end

-- Если не указан путь, будет путь по умолчанию
-- Если не указан материал, он будет браться из названия

-- ГОЛОВЫ

addNumberedClothes("head", 15, "assets/clothes/head/", "head", "head")

ClothesTable.head_test = { layer = "head", material = "head", price = 0, path = "assets/clothes/head/head_test.png" }

-- ВЕРХ

addNumberedClothes("blouse", 5, "assets/clothes/shirt/blouse/", "shirt", "blouse", true)
addNumberedClothes("bomber", 7, "assets/clothes/shirt/bomber/", "shirt", "bomber", true)
addNumberedClothes("bubblegoose", 4, "assets/clothes/shirt/bubblegoose/", "shirt", "bubblegoose", true)
addNumberedClothes("firefighter", 2, "assets/clothes/shirt/firefighter/", "shirt", "firefighter", true)
addNumberedClothes("gorka", 4, "assets/clothes/shirt/gorka/", "shirt", "gorka", true)
addNumberedClothes("hoodie", 7, "assets/clothes/shirt/hoodie/", "shirt", "hoodie", true)
addNumberedClothes("hunting", 5, "assets/clothes/shirt/hunting/", "shirt", "hunting", true)
addNumberedClothes("labcoat", 1, "assets/clothes/shirt/labcoat/", "shirt", "labcoat", true)
addNumberedClothes("medic", 3, "assets/clothes/shirt/medic/", "shirt", "medic", true)
addNumberedClothes("mjacket", 5, "assets/clothes/shirt/mjacket/", "shirt", "mjacket", true)
addNumberedClothes("nbc", 1, "assets/clothes/shirt/nbc/", "shirt", "nbc", true)
addNumberedClothes("pcu", 8, "assets/clothes/shirt/pcu/", "shirt", "pcu", true)
addNumberedClothes("police", 2, "assets/clothes/shirt/police/", "shirt", "police", true)
addNumberedClothes("quilted", 8, "assets/clothes/shirt/quilted/", "shirt", "quilted", true)
addNumberedClothes("raincoat", 7, "assets/clothes/shirt/raincoat/", "shirt", "raincoat", true)
addNumberedClothes("riders", 1, "assets/clothes/shirt/riders/", "shirt", "riders", true)
addNumberedClothes("shirt", 10, "assets/clothes/shirt/shirt/", "shirt", "shirt", true)
addNumberedClothes("sweater", 4, "assets/clothes/shirt/sweater/", "shirt", "sweater", true)
addNumberedClothes("tracksuit", 6, "assets/clothes/shirt/tracksuit/", "shirt", "tracksuit", true)
addNumberedClothes("tshirt", 9, "assets/clothes/shirt/tshirt/", "shirt", "tshirt", false)
addNumberedClothes("woolcoat", 10, "assets/clothes/shirt/woolcoat/", "shirt", "woolcoat", true)

ClothesTable.tshirt_ccd = { layer = "shirt", material = "tshirt", price = 0 }

-- ШТАНЫ

addNumberedClothes("cargopnts", 6, "assets/clothes/pants/cargopnts/", "pants")
addNumberedClothes("firefightpnts", 2, "assets/clothes/pants/firefightpnts/", "pants")
addNumberedClothes("hunterpnts", 5, "assets/clothes/pants/hunterpnts/", "pants")
addNumberedClothes("jeans", 6, "assets/clothes/pants/jeans/", "pants")
addNumberedClothes("medcpnts", 4, "assets/clothes/pants/medcpnts/", "pants")
addNumberedClothes("policpnts", 1, "assets/clothes/pants/policpnts/", "pants")
addNumberedClothes("slacks", 8, "assets/clothes/pants/slacks/", "pants")
addNumberedClothes("tracksuitpnts", 5, "assets/clothes/pants/tracksuitpnts/", "pants")

-- ОБУВЬ

addNumberedClothes("athletics", 6, "assets/clothes/shoes/athletics/", "shoes", "athletics")
addNumberedClothes("combat", 5, "assets/clothes/shoes/combat/", "shoes", "combat")
addNumberedClothes("hiking", 5, "assets/clothes/shoes/hiking/", "shoes", "hiking")
addNumberedClothes("hikingbh", 2, "assets/clothes/shoes/hikingbh/", "shoes", "hikingbh")
addNumberedClothes("joggings", 5, "assets/clothes/shoes/joggings/", "shoes", "joggings")
addNumberedClothes("jungleb", 4, "assets/clothes/shoes/jungleb/", "shoes", "jungleb")
addNumberedClothes("militaryb", 5, "assets/clothes/shoes/militaryb/", "shoes", "militaryb")
addNumberedClothes("sneakers", 5, "assets/clothes/shoes/sneakers/", "shoes", "sneakers")
addNumberedClothes("wellies", 5, "assets/clothes/shoes/wellies/", "shoes", "wellies")
addNumberedClothes("workingb", 5, "assets/clothes/shoes/workingb/", "shoes", "workingb")

-- Мета
-- local f = fileCreate("out.xml")
-- for name, c in pairs(ClothesTable) do
--     f:write('\t<file src="'..c.path..'.png"/>\n')
-- end
-- f:close()
