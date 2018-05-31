RenderManager = {}

local renderWidgets = {}

local function render()
    local mouseX, mouseY = getMousePosition()
    Graphics.origin()
    for i, widget in ipairs(renderWidgets) do
        widget:render(mouseX, mouseY)
    end
end

function RenderManager.addWidget(widget)
    if table.indexOf(renderWidgets, widget) then
        return false
    end
    table.insert(renderWidgets, widget)
    return true
end

function RenderManager.removeWidget(widget)
    local index = table.indexOf(renderWidgets, widget)
    if not index then
        return false
    end
    table.remove(renderWidgets, widget)
    return true
end

addEventHandler("onClientRender", root, render, false, "low+100")
