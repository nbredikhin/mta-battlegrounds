local resourceWidgets = {}
local widgetInstances = {}

function getWidgetById(id)
    return widgetInstances[id]
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
    return widget.id
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

    for key, value in pairs(params) do
        widgetInstances[id][key] = value
    end

    return true
end

function centerWidget(id, centerHorizontal, centerVertical)
    if not id then
        return false
    end
    local widget = widgetInstances[id]
    if not widget then
        return false
    end
    if centerHorizontal == nil then
        centerHorizontal = true
    end
    if centerVertical == nil then
        centerVertical = true
    end

    local parentWidth, parentHeight
    if widget.parent then
        parentWidth, parentHeight = widget.parent.width, widget.parent.height
    else
        parentWidth, parentHeight = guiGetScreenSize()
    end

    if centerHorizontal then
        widget.x = parentWidth/2  - widget.width/2
    end
    if centerVertical then
        widget.y = parentHeight/2 - widget.height/2
    end

    return true
end
