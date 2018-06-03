Label = class("Label", Widget)

function Label:initialize(params)
    Widget.initialize(self, params)

    -- Текст кнопки и его выравнивание
    self.text = params.text or ""
    self.textAlignHorizontal = params.textAlignHorizontal or "left"
    self.textAlignVertical = params.textAlignVertical or "center"
    -- Параметры текста
    self.textColorCoded = false
    self.textWordBreak  = true
    self.textClip = true

    self.color = params.color or tocolor(200, 200, 200)
end

function Label:draw()
    Graphics.text(self.x, self.y, self.width, self.height, self.text, self.textAlignHorizontal,
        self.textAlignVertical, self.textClip, self.textWordBreak, self.textColorCoded)
end
