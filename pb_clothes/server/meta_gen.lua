addCommandHandler("cmeta", function ()
    local f = fileCreate("clothes.xml")
    for name, item in pairs(ClothesTable) do
        if item.texture then
            local path = "assets/textures/"..item.texture
            if fileExists(path) then
                f:write("\t<file src=\""..path.."\"/>\n")
            else
                outputDebugString("Warning: Missing texture file " .. path)
            end
        end

        if item.icon then
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
