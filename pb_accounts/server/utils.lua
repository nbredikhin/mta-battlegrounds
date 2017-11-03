addEvent("dbCallback", false)
addEventHandler("dbCallback", resourceRoot, function(queryResult, callbackFunctionName, callbackArguments)
    if type(_G[callbackFunctionName]) == "function" then
        _G[callbackFunctionName](queryResult, callbackArguments)
    end
end)

function isResourceRunning(resName)
    local res = getResourceFromName(resName)
    return (res) and (getResourceState(res) == "running")
end
