function addPedClothes(ped, name, sync)
    if not isElement(ped) or type(name) ~= "string" then
        return
    end
    if not ClothesTable[name] then
        return
    end
    ped:setData("clothes_"..tostring(ClothesTable[name].layer), name, not not sync)
end

function isValidClothesName(name)
    return not not (name and ClothesTable[name])
end

function getClothesTable()
    return ClothesTable
end
