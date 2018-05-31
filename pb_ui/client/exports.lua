local resourceWidgets = {}
local widgetInstances = {}

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
            resourceWidgets[sourceResourceRoot] = Widget:new()
            RenderManager.addWidget(resourceWidgets[sourceResourceRoot])
        end
        params.parent = resourceWidgets[sourceResourceRoot]
    end

    local widget = _G[name]:new(params)

    table.insert(widgetInstances, widget)
    widget.id = #widgetInstances

    printDebug("Created widget "..tostring(name).."("..widget.id..") by resource '"..sourceResource.name.."'")
    return widget.id
end
