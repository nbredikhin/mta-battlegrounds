UI = exports.pb_ui
local widgetBindings = {}
local widgetEvents = {
    "onWidgetClick",
    "onWidgetInput",
    "onWidgetScroll",
}
local componentsRegistry = {}
local localizedWidgets = {}

---------------------
-- Local functions --
---------------------

local function isResourceRunning(resName)
    local res = getResourceFromName(resName)
    return (res) and (getResourceState(res) == "running")
end

local function equals(o1, o2, ignore_mt)
    if o1 == o2 then return true end
    local o1Type = type(o1)
    local o2Type = type(o2)
    if o1Type ~= o2Type then return false end
    if o1Type ~= 'table' then return false end

    if not ignore_mt then
        local mt1 = getmetatable(o1)
        if mt1 and mt1.__eq then
            --compare using built in method
            return o1 == o2
        end
    end

    local keySet = {}

    for key1, value1 in pairs(o1) do
        local value2 = o2[key1]
        if value2 == nil or equals(value1, value2, ignore_mt) == false then
            return false
        end
        keySet[key1] = true
    end

    for key2, _ in pairs(o2) do
        if not keySet[key2] then return false end
    end
    return true
end

local function setState(component, state)
    if type(component) ~= "table" or type(state) ~= "table" then
        return
    end
    for key, value in pairs(state) do
        local isChanged = component.state[key] ~= value
        if type(component.state[key]) == "table" and type(value) == "table" then
            isChanged = not equals(component.state[key], value, false)
        end

        if isChanged then
            if type(value) == "table" then
                component.state[key] = table.copy(value)
            else
                component.state[key] = value
            end

            if component.stateHandlers[key] then
                for i, callback in ipairs(component.stateHandlers[key]) do
                    callback(value)
                end
            end
        end
    end
end

local function registerStateHandler(target, key, arg1, arg2)
    if type(target) ~= "table" or not key then
        return false
    end
    if not target.stateHandlers[key] then
        target.stateHandlers[key] = {}
    end
    observers = target.stateHandlers[key]

    if type(arg1) == "string" then
        local keys = split(arg1, ".")
        if #keys < 1 then
            return false
        end
        local widget = target.view.ui[keys[1]]
        if not UI:isWidget(widget) then
            return false
        end
        local key = keys[2]

        if type(arg2) == "string" then
            table.insert(observers, function (value)
                UI:setParams(widget, { [key] = string.format(arg2, value) })
            end)
        else
            table.insert(observers, function (value)
                UI:setParams(widget, { [key] = value })
            end)
        end
    elseif type(arg1) == "function" then
        table.insert(observers, arg1)
    end

    return true
end

local function addWidgetBinding(eventName, widget, callback)
    if not widgetBindings[eventName][widget] then
        widgetBindings[eventName][widget] = {}
    end

    table.insert(widgetBindings[eventName][widget], callback)
end

local function bindWidgetToState(component, widget, arg1, ...)
    if type(component) ~= "table" or not UI:isWidget(widget) then
        return false
    end

    local widgetType = UI:getWidgetType(widget)
    local args = {...}

    if widgetType == "Button" then
        if type(arg1) == "function" then
            addWidgetBinding("onWidgetClick", widget, function ()
                arg1(unpack(args))
            end)
        elseif type(arg1) == "string" then
            addWidgetBinding("onWidgetClick", widget, function ()
                if type(component.state[arg1]) == "function" then
                    component.state[arg1](unpack(args))
                else
                    component.setState({[arg1] = args[1]})
                end
            end)
        end
    elseif widgetType == "Input" then
        if type(arg1) == "function" then
            addWidgetBinding("onWidgetInput", widget, function ()
                arg1(UI:getParam(widget, "text"))
            end, false)
        elseif type(arg1) == "string" then
            addWidgetBinding("onWidgetInput", widget, function ()
                component.setState({[arg1] = UI:getParam(widget, "text")})
            end, false)
        end
    else
        if type(arg1) == "function" then
            addWidgetBinding("onWidgetClick", widget, function ()
                arg1(unpack(args))
            end)
        end
    end
end

local function updateLocalizedWidget(params)
    if not params or not params.widget then
        return
    end

    local text
    if isResourceRunning("pb_lang") then
        text = exports.pb_lang:localize(params.locale)
    else
        text = params.locale
    end

    if type(params.callback) == "function" then
        UI:setParams(params.widget, { [params.propertyName] = params.callback(text) })
    else
        UI:setParams(params.widget, { [params.propertyName] = text })
    end
end

----------------------
-- Global functions --
----------------------

function table.copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.copy(orig_key)] = table.copy(orig_value)
        end
        setmetatable(copy, table.copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function View(constructor)
    if type(constructor) ~= "function" then
        return false
    end
    local view = {
        ui = {},
        constructor = constructor,
        component = nil
    }
    return view
end

function Component(name, view, constructor)
    if type(name) ~= "string" then
        return false
    end
    if componentsRegistry[name] then
        return componentsRegistry[name]
    end

    local component = {
        view  = view,
        state = {},
        stateHandlers = {},
    }
    component.setState = function (...) setState(component, ...) end
    component.getState = function () return table.copy(component.state) end
    component.on       = function (...) registerStateHandler(component, ...) end
    component.bind     = function (...) bindWidgetToState(component, ...) end

    view.component = component
    view.constructor(view.ui, component)

    if type(constructor) == "function" then
        constructor(component)
    end

    componentsRegistry[name] = component
    return true
end

function localizeWidget(widget, locale, propertyName, callback)
    if not UI:isWidget(widget) then
        return
    end
    if not propertyName then
        propertyName = "text"
    end

    local params = {
        widget       = widget,
        locale       = locale,
        propertyName = propertyName,
        callback     = callback
    }
    table.insert(localizedWidgets, params)
    updateLocalizedWidget(params)
end

--------------------
-- Event handlers --
--------------------

for i, eventName in ipairs(widgetEvents) do
    widgetBindings[eventName] = {}

    addEvent(eventName, false)
    addEventHandler(eventName, resourceRoot, function (widget)
        if widgetBindings[eventName][widget] then
            for i, callback in ipairs(widgetBindings[eventName][widget]) do
                callback()
            end
        end
    end)
end

addEvent("onLanguageChanged", false)
addEventHandler("onLanguageChanged", root, function ()
    for i, params in pairs(localizedWidgets) do
        updateLocalizedWidget(params)
    end
end)
