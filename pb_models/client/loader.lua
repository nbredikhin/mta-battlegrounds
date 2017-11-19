local function saveFile(path, data)
    if not path then
        return false
    end
    if fileExists(path) then
        fileDelete(path)
    end
    local file = fileCreate(path)
    fileWrite(file, data)
    fileClose(file)
    return true
end

function getFile(path)
    if not path or not ModelPaths[path] then
        return
    end
    local file = fileOpen("data/"..ModelPaths[path].filename)
    if not file then
        return
    end
    file.pos = ModelPaths[path].pos
    local fdata = file:read(ModelPaths[path].len)
    file:close()
    return fdata
end
