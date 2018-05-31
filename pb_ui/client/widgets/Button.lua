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

    -- Цвета фона кнопки в различных состояниях
    self.colorMain    = params.colorMain    or tocolor(0, 0, 0)
    self.colorHover   = params.colorHover   or tocolor(150, 150, 150)
    self.colorPressed = params.colorPressed or tocolor(255, 255, 255)

    -- Цвет текста кнопки
    self.colorText = params.colorText or tocolor(200, 200, 200)
end

function Button:draw()
    if self.isMouseOver then
        if getKeyState("mouse1") then
            self.color = self.colorPressed
        else
            self.color = self.colorHover
        end
    else
        self.color = self.colorMain
    end

    Graphics.rectangle(self.x, self.y, self.width, self.height)
    Graphics.setColor(self.colorText)
    Graphics.text(self.x, self.y, self.width, self.height, self.text, self.textAlignHorizontal,
        self.textAlignVertical, self.textWordBreak, self.textColorCoded)
end
