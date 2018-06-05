Caption = class("Caption", Widget)

function Caption:initialize(params)
    Widget.initialize(self, params)

    -- Текст заголовка и его выравнивание
    self.text = params.text or ""
    self.textAlignHorizontal = params.textAlignHorizontal or "left"
    self.textAlignVertical   = params.textAlignVertical   or "center"
    -- Параметры текста заголовка
    self.textColorCoded = false
    self.textWordBreak  = true
    self.textClip       = true
    self.font = params.font or "bold"
    -- Параметры дополнительного текста заголовка
    self.textRight = params.textRight
    self.fontRight = params.fontRight or self.font

    -- Цвет фона
    self.color      = params.colorMain or tocolor(40, 40, 40)
    self.colorRight = params.colorMain or tocolor(30, 30, 30)
    -- Цвет заголовка
    self.colorText      = params.colorText      or tocolor(200, 200, 200)
    self.colorTextRight = params.colorTextRight or tocolor(150, 150, 150)
end

function Caption:draw()
    -- Фон заголовка
    local textOffset = 0
    if self.textAlignHorizontal == "left" then
        textOffset = 10
        local textWidth = Graphics.getTextWidth(self.text, self.font) + textOffset
        if textWidth > self.width - self.height then
            textWidth = self.width - self.height
        end
        Graphics.setColor(self.colorRight)
        Graphics.rectangle(self.x + textWidth, self.y, self.width - textWidth, self.height)
        Graphics.setColor(self.color)
        Graphics.rectangle(self.x, self.y, textWidth, self.height)
        Graphics.image(self.x + textWidth - 5, self.y, self.height, self.height, Assets.getImage("caption-separator"))
    else
        Graphics.setColor(self.color)
        Graphics.rectangle(self.x, self.y, self.width, self.height)
    end

    -- Текст заголовка
    Graphics.setFont(self.font)
    Graphics.setColor(self.colorText)
    Graphics.text(self.x + textOffset, self.y, self.width-textOffset, self.height, self.text, self.textAlignHorizontal,
        self.textAlignVertical, self.textClip, self.textWordBreak, self.textColorCoded)

    -- Текст в правой части заголовка
    if self.textRight then
        local textOffset = 10
        Graphics.setFont(self.fontRight)
        Graphics.setColor(self.colorTextRight)
        Graphics.text(self.x, self.y, self.width-textOffset, self.height, self.textRight, "right",
            self.textAlignVertical, self.textClip, self.textWordBreak, self.textColorCoded)
    end
end
