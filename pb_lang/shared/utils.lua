function loadFile(path, count)
    if not fileExists(path) then
        return false
    end
    local file = fileOpen(path)
    if not file then
        return false
    end
    if not count then
        count = fileGetSize(file)
    end
    local data = fileRead(file, count)
    fileClose(file)
    return data
end

function saveFile(path, data)
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
