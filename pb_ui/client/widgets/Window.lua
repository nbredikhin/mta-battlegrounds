Window = class("Window", Widget)

function Window:initialize(params)
    Widget.initialize(self, params)

    -- Текст заголовка и его выравнивание
    self.text = params.text or ""
    self.textAlignHorizontal = params.textAlignHorizontal or "center"
    self.textAlignVertical = params.textAlignVertical or "center"
    -- Параметры текста заголовка
    self.textColorCoded = false
    self.textWordBreak  = true
    -- Размер шапки
    self.headerHeight = 25

    -- Цвет фона
    self.colorMain = params.colorMain or tocolor(0, 0, 0)
    -- Цвет заголовка
    self.colorText = params.colorText or tocolor(200, 200, 200)
end

function Window:draw()
    Graphics.rectangle(self.x, self.y, self.width, self.height)
    Graphics.setColor(self.colorText)
    Graphics.text(self.x, self.y, self.width, self.height, self.text, self.textAlignHorizontal,
        self.textAlignVertical, self.textWordBreak, self.textColorCoded)
end
