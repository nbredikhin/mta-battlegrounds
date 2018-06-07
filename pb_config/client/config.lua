local config = {}
local configPath = "userconfig.json"

local function loadFile(path, count)
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

function setProperty(name, value)
    config[name] = value
    saveFile(configPath, toJSON(config))

    triggerEvent("onConfigChanged", resourceRoot, name, value)
end

function getProperty(name)
    if name then
        return config[name]
    end
end

function getDefaultConfig()
    return {
        -- ui_language = "english",

        ui_hud_visible        = true,
        ui_radar_grid_visible = true,
        ui_chat_visible       = true,
        ui_killchat_visible   = true,
        ui_ping_visible       = false,
        ui_fps_visible        = false
    }
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    if not fileExists(configPath) then
        config = getDefaultConfig()
        saveFile(configPath, toJSON(config))
    else
        config = fromJSON(loadFile(configPath))
    end

    for name, value in pairs(config) do
        triggerEvent("onConfigChanged", resourceRoot, name, value)
    end
end)
