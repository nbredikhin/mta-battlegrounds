ComponentManager = {}

local componentRegistry  = {}
local componentInstances = {}

local canvases = {}

-----------------------
-- Локальные функции --
-----------------------

local function componentToString(component)
    if not component then
        return false
    end
    return component.name.."("..component.id..")"
end

local function getChildIndex(component, child)
    if not component or not child then
        return false
    end
    for i, c in ipairs(component.children) do
        if c == child then
            return i
        end
    end
    return false
end

local function addChild(component, child)
    if not component or not child then
        return false
    end
    if child.parent then
        outputDebugString("[UI][COMPONENT_MANAGER][ERROR] Child "..componentToString(child).." already has parent")
        return false
    end
    if getChildIndex(component, child) then
        outputDebugString("[UI][COMPONENT_MANAGER][ERROR] Component "..componentToString(component).." already has child "..componentToString(component))
        return false
    end
    table.insert(component.children, child)
    child.parent = component
    return true
end

local function removeChild(component, child)
    if not component or not child then
        return false
    end
    local index = getChildIndex(component, child)
    if not index then
        return false
    end
    table.remove(component.children, index)
    child.parent = nil
    return true
end

------------------------
-- Глобальные функции --
------------------------

function ComponentManager.register(name, component)
    if type(name) ~= "string" then
        outputDebugString("[UI][COMPONENT_MANAGER][ERROR] Invalid component name '"..tostring(name).."'")
        return false
    end
    if type(component) ~= "table" then
        outputDebugString("[UI][COMPONENT_MANAGER][ERROR] Invalid component table for '"..tostring(name).."'")
        return false
    end
    if componentRegistry[name] then
        outputDebugString("[UI][COMPONENT_MANAGER][ERROR] Component '"..tostring(name).."' is already registered")
        return false
    end
    componentRegistry[name] = component
    return true
end

function ComponentManager.instantiateComponent(name, params, parent)
    if not name then
        return false
    end
    if not componentRegistry[name] then
        outputDebugString("[UI][COMPONENT_MANAGER][ERROR] Failed to instantiate component '"..tostring(name).."'")
        return false
    end
    if type(params) ~= "table" then
        params = {}
    end
    local component = {}
    component.x       = params.x or 0
    component.y       = params.y or 0
    component.width   = params.width  or 0
    component.height  = params.height or 0
    component.color   = params.color  or 0
    component.visible = not not params.visible

    component.parent = nil
    component.children = {}

    table.insert(componentInstances, component)
    component.id = #componentInstances

    setmetatable(component, { __index = componentRegistry[name] })
    component:create()

    if parent then
        addChild(parent, component)
    end

    return component.id
end
