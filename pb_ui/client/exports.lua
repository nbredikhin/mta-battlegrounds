local resourceWidgets = {}
local widgetInstances = {}

function getWidgetById(id)
    return widgetInstances[id]
end

function triggerWidgetEvent(eventName, widget, ...)
    if widget.id then
        triggerEvent(eventName, widget.sourceResourceRoot or resourceRoot, widget.id, ...)
    end
end

function create(name, params)
    if type(name) ~= "string" then
        return false
    end

    if not sourceResourceRoot then
        sourceResourceRoot = resourceRoot
    end
    if not sourceResource then
        sourceResource = resource
    end

    if params.parent then
        if widgetInstances[params.parent] then
            params.parent = widgetInstances[params.parent]
        else
            params.parent = nil
        end
    end

    if not params.parent then
        if not resourceWidgets[sourceResourceRoot] then
            local screenWidth, screenHeight = guiGetScreenSize()
            resourceWidgets[sourceResourceRoot] = Widget:new({
                width  = screenWidth,
                height = screenHeight,
                enabled = false
            })
            RenderManager.addWidget(resourceWidgets[sourceResourceRoot])
        end
        params.parent = resourceWidgets[sourceResourceRoot]
    end

    local widget = _G[name]:new(params)

    table.insert(widgetInstances, widget)
    widget.id = #widgetInstances
    widget.sourceResourceRoot = sourceResourceRoot

    printDebug("Created widget "..tostring(name).."("..widget.id..") by resource '"..sourceResource.name.."'")
    triggerWidgetEvent("onWidgetCreate", widget)
    return widget.id
end

function destroy(id)
    if not id then
        return false
    end
    local widget = widgetInstances[id]
    if not widget then
        return false
    end
    if widget.parent then
        widget.parent:removeChild(widget)
    end
    widgetInstances[id] = nil
    return true
end

function setParams(id, params)
    if not id or type(params) ~= "table" then
        return false
    end
    if not widgetInstances[id] then
        return false
    end
    params.parent = nil
    params.children = nil
    params.id = nil
    params.sourceResourceRoot = nil

    for key, value in pairs(params) do
        widgetInstances[id][key] = value
    end

    return true
end

function getParam(id, key)
    if not id then
        return false
    end
    if not widgetInstances[id] then
        return false
    end
    return widgetInstances[id][key]
end

function alignWidget(id, alignAxis, align, offset)
    if not id then
        return false
    end
    local widget = widgetInstances[id]
    if not widget then
        return false
    end

    if not offset then
        offset = 0
    end

    if alignAxis == "horizontal" or alignAxis == "x" then
        local parentWidth
        if widget.parent then
            parentWidth = widget.parent.width
        else
            parentWidth = guiGetScreenSize()
        end

        if align == "left" then
            widget.x = offset
        elseif align == "center" then
            widget.x = parentWidth/2 - widget.width/2
        elseif align == "right" then
            widget.x = parentWidth - widget.width - offset
        end
    elseif alignAxis == "vertical" or alignAxis == "y" then
        local parentHeight
        if widget.parent then
            parentHeight = widget.parent.height
        else
            parentHeight = guiGetScreenSize()
        end

        if align == "top" then
            widget.y = offset
        elseif align == "center" then
            widget.y = parentHeight/2 - widget.height/2
        elseif align == "bottom" then
            widget.y = parentHeight - widget.height - offset
        end
    end
    return true
end

function fillSize(id, marginHorizontal, marginVertical)
    if not id then
        return false
    end
    local widget = widgetInstances[id]
    if not widget then
        return false
    end

    local parentWidth, parentHeight
    if widget.parent then
        parentWidth, parentHeight = widget.parent.width, widget.parent.height
    else
        parentWidth, parentHeight = guiGetScreenSize()
    end

    if marginHorizontal then
        widget.x = marginHorizontal
        widget.width = parentWidth - marginHorizontal * 2
    end
    if marginVertical then
        widget.y = marginVertical
        widget.height = parentHeight - marginVertical * 2
    end
    return true
end

addEventHandler("onClientResourceStop", root, function ()
    if resourceWidgets[source] then
        RenderManager.removeWidget(resourceWidgets[source])
        resourceWidgets[source] = nil
    end
end)
