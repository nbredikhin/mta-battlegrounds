RenderManager = {}

local renderWidgets = {}

-----------------------
-- Локальные функции --
-----------------------

local function render()
    local renderStartTime = getTickCount()

    InputManager.update()
    local mouseX, mouseY = getMousePosition()
    Graphics.origin()
    for i, widget in ipairs(renderWidgets) do
        widget:render(mouseX, mouseY)
    end

    -- Потеря фокуса при отпускании мыши
    local focusedWidget = InputManager.getFocusedWidget()
    if focusedWidget and focusedWidget.loseFocusOnMouseUp and InputManager.isReleased("mouse1") then
        InputManager.setFocusedWidget()
    end

    local clickedWidget = InputManager.getClickedWidget()
    -- Если был клик по виджету
    if clickedWidget then
        InputManager.setFocusedWidget(clickedWidget)

        clickedWidget:handleClick()

        if clickedWidget.id then
            triggerWidgetEvent("onWidgetClick", clickedWidget)
        end
    elseif InputManager.isPressed("mouse1") then
        -- Если не кликнули по виджету, но был клик, убираем фокус с виджета
        InputManager.setFocusedWidget()
    end

    if Config.debugDrawRenderTime then
        local renderTime = getTickCount() - renderStartTime
        dxDrawText("Render time: "..renderTime.."ms", 20, 420, 0, 0, tocolor(255, 0, 0))
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
    table.remove(renderWidgets, index)
    return true
end

-----------------------
-- Обработка событий --
-----------------------

addEventHandler("onClientRender", root, render, false, "low+100")
