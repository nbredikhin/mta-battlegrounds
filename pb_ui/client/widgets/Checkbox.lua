Checkbox = class("Checkbox", Widget)

function Checkbox:initialize(params)
    Widget.initialize(self, params)

    -- Текст и его выравнивание
    self.text = params.text or ""
    self.textAlignHorizontal = params.textAlignHorizontal or "left"
    self.textAlignVertical   = params.textAlignVertical   or "center"
    -- Параметры текста
    self.textColorCoded = false
    self.textWordBreak  = true
    self.textClip       = true

    -- Цвета фона в различных состояниях
    self.colorMain     = params.colorMain  or tocolor(50, 50, 50)
    self.colorDisabled = params.colorMain  or tocolor(35, 35, 35)
    self.colorHover    = params.colorHover or tocolor(60, 60, 60)
    self.colorPress    = params.colorPress or tocolor(90, 90, 90)
    -- Цвет внутреннего квадрата
    self.colorChecked  = params.colorChecked or tocolor(200, 200, 200)

    self.borderSize          = params.borderSize or 3
    self.colorBorder         = params.colorBorder         or tocolor(70, 70, 70)
    self.colorBorderDisabled = params.colorBorderDisabled or tocolor(50, 50, 50)

    -- Цвет текста
    self.colorText         = params.colorText         or tocolor(200, 200, 200)
    self.colorTextDisabled = params.colorTextDisabled or tocolor(100, 100, 100)
    self.colorTextHover    = params.colorTextHover    or self.colorText
    self.colorTextPress    = params.colorTextPress    or self.colorText
    self.colorTextRight    = params.colorTextRight    or self.colorText

    self.state = false
end

function Checkbox:handleClick()
    self.state = not self.state
end

function Checkbox:draw()
    local colorBackground
    local colorText
    local colorBorder
    if self.enabled then
        colorBorder = self.colorBorder
        if self.isMouseOver then
            if getKeyState("mouse1") then
                colorBackground = self.colorPress
                colorText = self.colorTextPress
            else
                colorBackground = self.colorHover
                colorText = self.colorTextHover
            end
        else
            colorBackground = self.colorMain
        end
    else
        colorBorder = self.colorBorderDisabled
        colorText = self.colorTextDisabled
        colorBackground = self.colorDisabled
    end

    local size = self.height

    if self.borderSize > 0 then
        local bs = self.borderSize
        Graphics.setColor(colorBorder)
        Graphics.rectangle(self.x-bs, self.y-bs, size+bs*2, size+bs*2)
    end

    Graphics.setColor(colorBackground)
    Graphics.rectangle(self.x, self.y, size, size)

    if self.state then
        local innerSize = size * 0.5
        Graphics.setColor(self.colorChecked)
        Graphics.rectangle(self.x+innerSize/2, self.y+innerSize/2, innerSize, innerSize)
    end

    Graphics.setColor(colorText)
    Graphics.text(self.x + size + 10, self.y, self.width, self.height, self.text, self.textAlignHorizontal,
        self.textAlignVertical, self.textClip, self.textWordBreak, self.textColorCoded)
end
