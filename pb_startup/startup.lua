-- Start or stop resource by name
local function setResourceRunning(resourceName, startOrStop)
    local resource = Resource.getFromName(resourceName)
    if not resource then
        return false, "Resource not found"
    end
    if startOrStop then
        resource:start()
        if resource.state == "running" then
            return true
        else
            return false, "Failed to start"
        end
    else
        return resource:stop()
    end
end

function isResourceRunning(resourceName)
    local resource = getResourceFromName(resourceName)
    return resource and resource.state == "running"
end

local function outputStartupMessage(...)
    if not Config.verboseMode and not force then
        return
    end
    local message = string.format(...)
    outputDebugString("[STARTUP] " .. message)
    outputConsole("[STARTUP] " .. message)
end

addEventHandler("onResourceStart", resourceRoot, function ()
    local startedCount = 0

    outputStartupMessage("Starting gamemode...")
    for i, resourceName in ipairs(Config.resourceList) do
        local status, message = setResourceRunning(resourceName, true)
        if status then
            startedCount = startedCount + 1
        else
            if message then
                outputStartupMessage("Failed to start resource \"%s\" (%s)", resourceName, message)
            else
                outputStartupMessage("Failed to start resource \"%s\"", resourceName)
            end
        end
    end
    outputStartupMessage("Startup completed. Started %s/%s resource(s)",
        tostring(startedCount),
        tostring(#Config.resourceList))

    if startedCount < #Config.resourceList then
        outputDebugString("[STARTUP] Failed to start some resources", 1)
    end

    outputChatBox(Config.welcomeMessage, root, 0, 255, 0, true)

    if isResourceRunning("rs_discord") then
        exports.rs_discord:outputDiscordMessage("Server is running")
    end
end)

addEventHandler("onResourceStop", resourceRoot, function ()
    if isResourceRunning("rs_discord") then
        exports.rs_discord:outputDiscordMessage("Server is stopping")
    end

    for i, resourceName in ipairs(Config.resourceList) do
        setResourceRunning(resourceName, false)
    end
end)
