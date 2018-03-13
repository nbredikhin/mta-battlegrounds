local filepath = "logindata"
local key = "25LLuEp5"

function autologinRemember(username, password)
    local f
    if not fileExists(filepath) then
        f = fileCreate(filepath)
    else
        f = fileOpen(filepath)
    end
    if not f then
        return
    end

    local fields = {
        username = username,
        password = password
    }

    local jsonData = toJSON(fields)
    if not jsonData then
        return
    end
    fileWrite(f, base64Encode(teaEncode(jsonData, key)))
    fileClose(f)
end

function autologinClear()
    if fileExists(filepath) then
        fileDelete(filepath)
    end
end

function autologinLoad()
    if not fileExists(filepath) then
        return
    end
    local f = fileOpen(filepath)
    if not f then
        return
    end
    local jsonData = teaDecode(base64Decode(fileRead(f, fileGetSize(f)), key))
    fileClose(f)

    if not jsonData then
        return
    end
    local fields = fromJSON(jsonData)
    if not fields then
        return
    end
    return fields
end
