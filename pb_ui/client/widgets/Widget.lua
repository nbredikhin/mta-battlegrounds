Widget = class("Widget")

function Widget:initialize(params)
    if type(params) ~= "table" then
        params = {}
    end

    -- Позиция и размер виджета
    defaultValues(params, self, {
        x = 0,
        y = 0,

        width  = 0,
        height = 0,

        visible = true,
        enabled = true
    })

    -- Положение мыши относительно виджета
    self.mouseX = 0
    self.mouseY = 0
    -- Находится ли мышь над виджетом
    self.isMouseOver = false

    -- Дети и родитель
    self.parent = nil
    self.children = {}

    -- Добавление родителя по умолчанию
    if params.parent then
        params.parent:addChild(self)
    end

    self.receiveTextInput = false
    self.bringToFrontOnClick = false
end

function Widget:render(mouseX, mouseY)
    if not self.visible then
        return
    end

    mouseX = mouseX - self.x
    mouseY = mouseY - self.y

    self.mouseX = mouseX
    self.mouseY = mouseY

    if isPointInRect(mouseX, mouseY, 0, 0, self.width, self.height) then
        if not self.isMouseOver then
            triggerWidgetEvent("onWidgetMouseOver", self)
        end
        self.isMouseOver = true
        InputManager.setHoveredWidget(self)
        if self.enabled and InputManager.isPressed("mouse1") then
            if self.bringToFrontOnClick then
                RenderManager.bringWidgetToFront(self)
            end
            InputManager.setClickedWidget(self)
        end
    else
        if self.isMouseOver then
            triggerWidgetEvent("onWidgetMouseOut", self)
        end
        self.isMouseOver = false
    end

    Graphics.setColor(self.color)
    Graphics.setFont(self.font)
    self:draw()

    if Config.debugDrawBoxes then
        local lineWidth
        if self.isFocused then
            lineWidth = 3
        else
            lineWidth = 1
        end
        Graphics.setColor(tocolor(255, 0, 0, 200))

        Graphics.line(self.x, self.y, self.x + self.width, self.y, lineWidth)
        Graphics.line(self.x + self.width, self.y, self.x + self.width, self.y + self.height, lineWidth)
        Graphics.line(self.x + self.width, self.y + self.height, self.x, self.y + self.height, lineWidth)
        Graphics.line(self.x, self.y + self.height, self.x, self.y, lineWidth)
    end
    if Config.debugDrawNames then
        Graphics.setColor(tocolor(255, 0, 0))
        Graphics.setFont("debug")
        Graphics.text(self.x + 3, self.y, 1, 1, self.class.name .. " [ID="..(self.id or "<none>").."]")
    end

    Graphics.translate(self.x, self.y)
    for i, child in ipairs(self.children) do
        child:render(mouseX, mouseY)
    end
    Graphics.translate(-self.x, -self.y)
end

function Widget:draw()

end

function Widget:handleScroll(delta)

end

function Widget:handleClick()

end

function Widget:handleParamChange(name, value)

end

function Widget:__tostring()
    local str = self.class.name
    if self.id then
        str = str.."("..self.id..")"
    end
    return str
end

-- Добавление дочернего виджета
function Widget:addChild(widget)
    if not widget or widget.parent or self:getChildIndex(widget) then
        return false
    end

    table.insert(self.children, widget)
    widget.parent = self

    return true
end

-- Удаление дочернего виджета
function Widget:removeChild(widget)
    if not widget then
        return false
    end
    local index = self:getChildIndex(widget)
    if not index then
        return false
    end

    table.remove(self.children, index)
    widget.parent = nil

    return true
end

-- Получение индекса дочернего виджета
function Widget:getChildIndex(widget)
    if not widget or widget.parent ~= self then
        return false
    end

    for i, child in ipairs(self.children) do
        if child == widget then
            return i
        end
    end

    return false
end

-- Перемещает виджет наверх относительно других детей его родителя
function Widget:bringToFront()
    if not self.parent then
        return false
    end
    local parent = self.parent
    parent:removeChild(self)
    parent:addChild(self)
    return true
end
