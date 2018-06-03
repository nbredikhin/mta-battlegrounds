Window = class("Window", Widget)

function Window:initialize(params)
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
    -- Размер шапки
    self.headerHeight = params.headerHeight or 35
    -- Отображается ли шапка
    if params.isHeaderVisible == nil then
        self.isHeaderVisible = true
    else
        self.isHeaderVisible = not not params.isHeaderVisible
    end

    -- Цвет фона
    self.colorMain        = params.colorMain or tocolor(20, 20, 20)
    self.colorHeader      = params.colorMain or tocolor(40, 40, 40)
    self.colorHeaderRight = params.colorMain or tocolor(30, 30, 30)
    -- Цвет заголовка
    self.colorText      = params.colorText      or tocolor(200, 200, 200)
    self.colorTextRight = params.colorTextRight or tocolor(150, 150, 150)
end

function Window:draw()
    if self.isHeaderVisible then
        -- Шапка
        local textOffset = 0
        if self.textAlignHorizontal == "left" then
            textOffset = 10
            local textWidth = dxGetTextWidth(self.text, 1, Assets.getFont(self.font)) + textOffset
            if textWidth > self.width - self.headerHeight then
                textWidth = self.width - self.headerHeight
            end
            Graphics.setColor(self.colorHeaderRight)
            Graphics.rectangle(self.x + textWidth, self.y - self.headerHeight, self.width - textWidth, self.headerHeight)
            Graphics.setColor(self.colorHeader)
            Graphics.rectangle(self.x, self.y - self.headerHeight, textWidth, self.headerHeight)
            Graphics.image(self.x + textWidth - 5, self.y - self.headerHeight, self.headerHeight, self.headerHeight, Assets.getImage("caption-separator"))
        else
            Graphics.setColor(self.colorHeader)
            Graphics.rectangle(self.x, self.y - self.headerHeight, self.width, self.headerHeight)
        end

        -- Текст шапки
        Graphics.setFont(self.font)
        Graphics.setColor(self.colorText)
        Graphics.text(self.x + textOffset, self.y - self.headerHeight, self.width-textOffset, self.headerHeight, self.text, self.textAlignHorizontal,
            self.textAlignVertical, self.textClip, self.textWordBreak, self.textColorCoded)

        if self.textRight then
            local textOffset = 10
            Graphics.setFont(self.fontRight)
            Graphics.setColor(self.colorTextRight)
            Graphics.text(self.x, self.y - self.headerHeight, self.width-textOffset, self.headerHeight, self.textRight, "right",
                self.textAlignVertical, self.textClip, self.textWordBreak, self.textColorCoded)
        end
    end
    -- Основная часть окна
    Graphics.setColor(self.colorMain)
    Graphics.rectangle(self.x, self.y, self.width, self.height)
end
