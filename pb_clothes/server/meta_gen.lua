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
