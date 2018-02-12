addEvent("dbCallback", false)
addEventHandler("dbCallback", resourceRoot, function(queryResult, callbackFunctionName, callbackArguments)
    if type(_G[callbackFunctionName]) == "function" then
        _G[callbackFunctionName](queryResult, callbackArguments)
    end
end)

function isResourceRunning(resourceName)
    local resource = getResourceFromName(resourceName)
    return resource and resource.state == "running"
end

function isPlayerAdmin(player)
    return hasObjectPermissionTo(player, "command.srun", false)
end
