ScrollBar = class("ScrollBar", Widget)

function ScrollBar:initialize(params)
    Widget.initialize(self, params)

    -- Цвет фона
    self.colorMain   = params.colorMain  or tocolor(90, 90, 90)
    self.colorHover  = params.colorHover or tocolor(120, 120, 120)
    -- Размер и цвет рамки
    self.borderSize  = params.borderSize  or 3
    self.colorBorder = params.colorBorder or tocolor(15, 15, 15)

    -- Положение скролла (от 0 до 1)
    self.value       = tonumber(params.value)      or 0
    -- Шаг при прокрутке колесом мыши
    self.step        = tonumber(params.step)       or 0.1
    -- Размер полосы прокрутки относительно скролл бара
    self.scrollSize  = tonumber(params.scrollSize) or 0.4
    -- Горизонтальный или вертикальный скролл бар
    self.isHorizontal = not not params.isHorizontal

    -- Фокус снимается при отпускании ЛКМ, чтобы не происходил лишний скролл
    self.loseFocusOnMouseUp = true
end

function ScrollBar:handleScroll(delta)
    self.value = math.max(0, math.min(1, self.value + delta * self.step))
    return delta * self.step
end

function ScrollBar:handleParamChange(name, oldValue)
    if name == "value" then
        self.value = math.max(0, math.min(1, self.value))
        triggerWidgetEvent("onWidgetScroll", self, self.value - oldValue)
    end
end

function ScrollBar:draw()
    Graphics.setColor(self.colorBorder)
    Graphics.rectangle(self.x, self.y, self.width, self.height)


    local barSize
    local scrollSize
    local x, y
    local width, height
    local mousePos
    if self.isHorizontal then
        barSize = self.width-self.borderSize*2
        scrollSize = barSize * self.scrollSize/2
        mousePos = self.mouseX

        x = self.x + self.borderSize + (barSize-scrollSize) * self.value
        y = self.y + self.borderSize
        width = scrollSize
        height = self.height - self.borderSize * 2
    else
        barSize = self.height-self.borderSize*2
        scrollSize = barSize * self.scrollSize/2
        mousePos = self.mouseY

        x = self.x + self.borderSize
        y = self.y + self.borderSize + (barSize-scrollSize) * self.value
        width = self.width - self.borderSize * 2
        height = scrollSize
    end

    if self.isFocused then
        Graphics.setColor(self.colorHover)

        if getKeyState("mouse1") then
            local value = math.max(0, math.min(1, (mousePos - scrollSize/2) / (barSize-scrollSize)))
            if value ~= self.value then
                local delta = value - self.value
                self.value = value
                triggerWidgetEvent("onWidgetScroll", self, delta)
            end
        end
    else
        Graphics.setColor(self.colorMain)
    end

    Graphics.rectangle(x, y, width, height)
end
