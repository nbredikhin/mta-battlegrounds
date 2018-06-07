local definedStyles = {}
local widgetProperties = {}

-----------------------
-- Локальные функции --
-----------------------

local function toggleWidgetProperty(widget, property, styleName)
    if not widgetProperties[widget] then
        widgetProperties[widget] = {}
    end

    if styleName then
        widgetProperties[widget][property] = getParam(widget, property)
        setParams(widget, { [property] = definedStyles[styleName][property] })
    else
        setParams(widget, { [property] = widgetProperties[widget][property] })
        widgetProperties[widget][property] = nil
    end
end

------------------------
-- Глобальные функции --
------------------------

function defineStyle(name, params)
    if not name or not params then
        return
    end
    definedStyles[name] = params
    printDebug("Added style '"..tostring(name).."'")
end

function toggleStyle(widget, name, state)
    if not widget or not name then
        return false
    end
    if not definedStyles[name] then
        outputDebugString("[UI] Style '"..tostring(name).."' is not defined")
        return false
    end

    for key in pairs(definedStyles[name]) do
        if state then
            toggleWidgetProperty(widget, key, name)
        else
            toggleWidgetProperty(widget, key)
        end
    end

    return true
end

