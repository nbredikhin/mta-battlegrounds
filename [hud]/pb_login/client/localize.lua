local localizedElements = {}

function localize(name)
    local res = getResourceFromName("pb_lang")
    if (res) and (getResourceState(res) == "running") then
        return exports.pb_lang:localize(name)
    else
        return name
    end
end

function bindElementToLocale(element, field, name, customHandler)
    if isElement(element) then
        element[field] = localize(name)
        localizedElements[element] = {field = field, name = name, customHandler = customHandler}
    end
end

function reloadLocale()
    for element, data in pairs(localizedElements) do
        if data.customHandler then
            data.customHandler(element, data.field, data.name)
        else
            element[data.field] = localize(data.name)
        end
    end
end
