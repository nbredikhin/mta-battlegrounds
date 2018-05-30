local function renderComponent(id, mouseX, mouseY)
    local component = ComponentManager.getComponent(id)
    if not component or not component.visible then
        return
    end

    mouseX = mouseX - component.x
    mouseY = mouseY - component.y

    component.mouseX = mouseX
    component.mouseY = mouseY

    if isPointInRect(mouseX, mouseY, 0, 0, component.width, component.height) then
        component.isMouseOver = true
    else
        component.isMouseOver = false
    end

    Graphics.setColor(component.color)
    Graphics.setFont(component.color)
    component:render()
    Graphics.setColor()
    Graphics.setFont()

    Graphics.translate(component.x, component.y)
    for i, child in ipairs(component.children) do
        renderComponent(childId, mouseX, mouseY)
    end
    Graphics.translate(-component.x, -component.y)
end

local function render()
    for resource, canvas in pairs(ComponentManager.getCanvases()) do
        renderComponent(canvas, 0, 0)
    end
end

addEventHandler("onClientRender", root, render, false, "low+100")
