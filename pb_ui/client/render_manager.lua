RenderManager = {}

local renderWidgets = {}

-----------------------
-- Локальные функции --
-----------------------

local function render()
    InputManager.update()
    local mouseX, mouseY = getMousePosition()
    Graphics.origin()
    for i, widget in ipairs(renderWidgets) do
        widget:render(mouseX, mouseY)
    end

    local clickedWidget = InputManager.getClickedWidget()
    -- Если был клик по виджету
    if clickedWidget then
        InputManager.setFocusedWidget(clickedWidget)

        if clickedWidget.id then
            triggerWidgetEvent("onWidgetClick", clickedWidget)
        end
    elseif InputManager.isPressed("mouse1") then
        -- Если не кликнули по виджету, но был клик, убираем фокус с виджета
        InputManager.setFocusedWidget()
    end
end

------------------------
-- Глобальные функции --
------------------------

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

-----------------------
-- Обработка событий --
-----------------------

addEventHandler("onClientRender", root, render, false, "low+100")
