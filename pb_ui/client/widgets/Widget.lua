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

        visible = true
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
        self.isMouseOver = true

        -- TODO: Click
    else
        self.isMouseOver = false
    end

    Graphics.setColor(self.color)
    Graphics.setFont(self.font)
    self:draw()
    Graphics.setColor()
    Graphics.setFont()

    Graphics.translate(self.x, self.y)
    for i, child in ipairs(self.children) do
        child:render(mouseX, mouseY)
    end
    Graphics.translate(-self.x, -self.y)
end

function Widget:draw()

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
