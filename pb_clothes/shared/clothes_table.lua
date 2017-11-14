ClothesTable = {}

function getClothesTable()
    return ClothesTable
end

function isValidClothesName(name)
    if name and ClothesTable[name] then
        return true
    else
        return false
    end
end

local function addNumberedClothes(baseName, count, basePath, layer, material, hideElbow)
    for i = 1, count do
        ClothesTable[baseName..i] = {
            layer = layer,
            material = material or baseName,
            hideElbow = hideElbow,
            path = basePath .. baseName..i..".png",
            readableName = baseName:gsub("^%l", string.upper) .. " " .. i,
            price = 999999
        }
    end
end

local function renameClothes(name, newName)
    if name and ClothesTable[name] then
        ClothesTable[name].readableName = newName
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

addNumberedClothes("head", 15, "head/", "head", "head")

ClothesTable.head_test = { layer = "head", material = "head", price = 0, path = "head/head_test.png" }

-- ВЕРХ

addNumberedClothes("blouse", 4, "shirt/blouse/", "shirt", "blouse", true)
addNumberedClothes("bomber", 7, "shirt/bomber/", "shirt", "bomber", true)
addNumberedClothes("bubblegoose", 4, "shirt/bubblegoose/", "shirt", "bubblegoose", true)
addNumberedClothes("firefighter", 2, "shirt/firefighter/", "shirt", "firefighter", true)
addNumberedClothes("gorka", 4, "shirt/gorka/", "shirt", "gorka", true)
addNumberedClothes("hoodie", 7, "shirt/hoodie/", "shirt", "hoodie", true)
addNumberedClothes("hunting", 5, "shirt/hunting/", "shirt", "hunting", true)
addNumberedClothes("labcoat", 1, "shirt/labcoat/", "shirt", "labcoat", true)
addNumberedClothes("medic", 3, "shirt/medic/", "shirt", "medic", true)
addNumberedClothes("mjacket", 5, "shirt/mjacket/", "shirt", "mjacket", true)
addNumberedClothes("nbc", 1, "shirt/nbc/", "shirt", "nbc", true)
addNumberedClothes("pcu", 8, "shirt/pcu/", "shirt", "pcu", true)
for i = 1, 11 do
    renameClothes("pcu" .. i, "Sport Jacket " .. i)
end
addNumberedClothes("police", 2, "shirt/police/", "shirt", "police", true)
addNumberedClothes("quilted", 8, "shirt/quilted/", "shirt", "quilted", true)
addNumberedClothes("raincoat", 7, "shirt/raincoat/", "shirt", "raincoat", true)
addNumberedClothes("riders", 1, "shirt/riders/", "shirt", "riders", true)
addNumberedClothes("shirt", 10, "shirt/shirt/", "shirt", "shirt", true)
addNumberedClothes("sweater", 4, "shirt/sweater/", "shirt", "sweater", true)
addNumberedClothes("tracksuit", 6, "shirt/tracksuit/", "shirt", "tracksuit", true)
addNumberedClothes("tshirt", 11, "shirt/tshirt/", "shirt", "tshirt", false)
for i = 1, 11 do
    renameClothes("tshirt" .. i, "T-shirt " .. i)
end
addNumberedClothes("woolcoat", 10, "shirt/woolcoat/", "shirt", "woolcoat", true)

ClothesTable.tshirt_ccd = { layer = "shirt", material = "tshirt", price = 0, readableName = "CCD TShirt", path = "shirt/tshirt/tshirt_ccd.png" }

-- ШТАНЫ

addNumberedClothes("cargopnts", 6, "pants/cargopnts/", "pants")
addNumberedClothes("firefightpnts", 2, "pants/firefightpnts/", "pants")
addNumberedClothes("hunterpnts", 5, "pants/hunterpnts/", "pants")
addNumberedClothes("jeans", 6, "pants/jeans/", "pants")
addNumberedClothes("medcpnts", 4, "pants/medcpnts/", "pants")
addNumberedClothes("policpnts", 1, "pants/policpnts/", "pants")
addNumberedClothes("slacks", 8, "pants/slacks/", "pants")
addNumberedClothes("tracksuitpnts", 5, "pants/tracksuitpnts/", "pants")

-- ОБУВЬ

addNumberedClothes("athletics", 6, "shoes/athletics/", "shoes", "athletics")
addNumberedClothes("combat", 5, "shoes/combat/", "shoes", "combat")
for i = 1, 5 do
    renameClothes("combat" .. i, "Combat Boots " .. i)
end
addNumberedClothes("hiking", 5, "shoes/hiking/", "shoes", "hiking")
for i = 1, 5 do
    renameClothes("hiking" .. i, "Hiking Boots " .. i)
end
addNumberedClothes("hikingbh", 2, "shoes/hikingbh/", "shoes", "hikingbh")
for i = 1, 2 do
    renameClothes("hikingbh" .. i, "Hiking Boots High " .. i)
end
addNumberedClothes("joggings", 5, "shoes/joggings/", "shoes", "joggings")
addNumberedClothes("jungleb", 4, "shoes/jungleb/", "shoes", "jungleb")
for i = 1, 4 do
    renameClothes("jungleb" .. i, "Jungle Boots " .. i)
end
addNumberedClothes("militaryb", 5, "shoes/militaryb/", "shoes", "militaryb")
for i = 1, 5 do
    renameClothes("militaryb" .. i, "Military Boots " .. i)
end
addNumberedClothes("sneakers", 5, "shoes/sneakers/", "shoes", "sneakers")
addNumberedClothes("wellies", 5, "shoes/wellies/", "shoes", "wellies")
addNumberedClothes("workingb", 5, "shoes/workingb/", "shoes", "workingb")
for i = 1, 5 do
    renameClothes("workingb" .. i, "Working Boots " .. i)
end

-- Мета
-- local f = fileCreate("out.xml")
-- for name, c in pairs(ClothesTable) do
--     f:write('\t<file src="'..c.path..'.png"/>\n')
-- end
-- f:close()

renameClothes("tshirt1", "Dirty T-shirt")
renameClothes("tshirt2", "Black T-shirt")
renameClothes("tshirt3", "Blue T-shirt")
renameClothes("tshirt4", "Green T-shirt")
renameClothes("tshirt5", "Grey T-shirt")
renameClothes("tshirt6", "Striped Orange T-shirt")
renameClothes("tshirt7", "Red T-shirt")
renameClothes("tshirt8", "Striped Red T-shirt")
renameClothes("tshirt9", "White T-shirt")
renameClothes("tshirt10", "White Russian T-shirt")
renameClothes("tshirt11", "GUCCI T-shirt")

renameClothes("woolcoat1", "Brown Coat")
renameClothes("woolcoat2", "Checkered Black Coat")
renameClothes("woolcoat3", "Black Coat")
renameClothes("woolcoat4", "Checkered Blue Coat")
renameClothes("woolcoat5", "Blue Coat")
renameClothes("woolcoat6", "Checkered Brown Coat")
renameClothes("woolcoat7", "Green Coat")
renameClothes("woolcoat8", "Checkered Grey Coat")
renameClothes("woolcoat9", "Checkered Red Coat")

renameClothes("bomber1", "Black Bomber")
renameClothes("bomber2", "Dark Blue Bomber")
renameClothes("bomber3", "Brown Bomber")
renameClothes("bomber4", "Grey Bomber")
renameClothes("bomber5", "Red Bomber")
renameClothes("bomber6", "Green Bomber")
renameClothes("bomber7", "Blue Bomber")
