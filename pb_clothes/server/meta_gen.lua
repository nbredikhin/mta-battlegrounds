addCommandHandler("cmeta", function (player)
    if not isPlayerAdmin(player) then
        return
    end
    local usedPaths = {}
    local f = fileCreate("clothes.xml")
    for name, item in pairs(ClothesTable) do
        if item.texture and not usedPaths[item.texture] then
            usedPaths[item.texture] = true
            local path = "assets/textures/"..item.texture
            if fileExists(path) then
                f:write("\t<file src=\""..path.."\"/>\n")
            else
                outputDebugString("Warning: Missing texture file " .. path)
            end
        end

        if item.icon and not usedPaths[item.icon] then
            usedPaths[item.icon] = true
            local path = "assets/textures/icons/"..item.icon
            if fileExists(path) then
                f:write("\t<file src=\""..path.."\"/>\n")
            else
                outputDebugString("Warning: Missing icon file " .. path)
            end
        end
    end
    f:close()
    outputDebugString("Meta generated")
end)

addCommandHandler("clist", function (player)
    if not isPlayerAdmin(player) then
        return
    end
    local usedPaths = {}
    local f = fileCreate("clothes.txt")
    local clothesByLayers = {}
    for name, item in pairs(ClothesTable) do
        if item.layer then
            if not clothesByLayers[item.layer] then
                clothesByLayers[item.layer] = {}
            end
            table.insert(clothesByLayers[item.layer], {item, name})
        else
            table.insert(clothesByLayers["без слоя"], {item, name})
        end
    end

    f:write("*** Список одежды ***\n")
    for layer, items in pairs(clothesByLayers) do
        table.sort(items, function (a, b)
            return a[2] < b[2]
        end)
        f:write("\n* Слой "..layer.." (вещей: "..#items..")\n")
        for i, item in pairs(items) do
            local name = tostring(item[2])
            local item = item[1]
            if item.name then
                f:write("\t"..name.." - "..item.name.."\n")
            else
                f:write("\t"..name.."\n")
            end
        end
    end
    f:close()
    outputDebugString("Clothes list generated")
end)
