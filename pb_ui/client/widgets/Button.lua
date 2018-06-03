Button = class("Button", Widget)

function Button:initialize(params)
    Widget.initialize(self, params)

    -- Текст кнопки и его выравнивание
    self.text = params.text or ""
    self.textAlignHorizontal = params.textAlignHorizontal or "center"
    self.textAlignVertical = params.textAlignVertical or "center"
    -- Параметры текста
    self.textColorCoded = false
    self.textWordBreak  = true
    self.textClip = true

    -- Цвета фона кнопки в различных состояниях
    self.colorMain  = params.colorMain  or tocolor(50, 50, 50)
    self.colorHover = params.colorHover or tocolor(60, 60, 60)
    self.colorPress = params.colorPress or tocolor(90, 90, 90)

    self.borderSize = 3
    self.colorBorder = params.colorBorder  or tocolor(70, 70, 70)

    -- Цвет текста кнопки
    self.colorText = params.colorText or tocolor(200, 200, 200)
    self.colorTextHover = params.colorTextHover or self.colorText
    self.colorTextPress = params.colorTextPress or self.colorText
    self.colorTextRight = params.colorTextRight or self.colorText
end

function Button:draw()
    if self.borderSize > 0 then
        local bs = self.borderSize
        Graphics.setColor(self.colorBorder)
        Graphics.rectangle(self.x-bs, self.y-bs, self.width+bs*2, self.height+bs*2)
    end

    local colorBackground
    local colorText
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
    Graphics.setColor(colorBackground)
    Graphics.rectangle(self.x, self.y, self.width, self.height)
    Graphics.setColor(colorText)
    Graphics.text(self.x, self.y, self.width, self.height, self.text, self.textAlignHorizontal,
        self.textAlignVertical, self.textClip, self.textWordBreak, self.textColorCoded)
end
