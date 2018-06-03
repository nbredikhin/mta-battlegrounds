Input = class("Input", Widget)

function Input:initialize(params)
    Widget.initialize(self, params)

    -- Текст и его выравнивание
    self.text = params.text or ""
    self.textAlignHorizontal = params.textAlignHorizontal or "left"
    self.textAlignVertical   = params.textAlignVertical   or "center"
    self.textOffset          = params.textOffset          or 5
    -- Текст, когда поле ввода пустое
    self.placeholder = params.placeholder or ""
    -- Параметры текста
    self.textColorCoded = false
    self.textWordBreak  = false
    self.textClip       = true

    self.borderSize = params.borderSize or 2

    self.colorText            = params.colorText            or tocolor(20, 20, 20)
    self.colorTextPlaceholder = params.colorTextPlaceholder or tocolor(100, 100, 100)
    self.colorMain            = params.colorMain            or tocolor(200, 200, 200)
    self.colorMainHover       = params.colorMainHover       or tocolor(210, 210, 210)
    self.colorMainFocused     = params.colorMainFocused     or tocolor(220, 220, 220)
    self.colorBorder          = params.colorBorder          or tocolor(100, 100, 100)
    self.colorBorderFocused   = params.colorBorderFocused   or tocolor(150, 150, 150)

    self.font = params.font or "regular"

    self.receiveTextInput = true
end

function Input:draw()
    local colorMain
    local colorBorder

    if self.isFocused then
        colorMain = self.colorMainFocused
        colorBorder = self.colorBorderFocused
    else
        colorMain = self.colorMain
        colorBorder = self.colorBorder

        if self.isMouseOver then
            colorMain = self.colorMainHover
        end
    end

    if self.borderSize > 0 then
        local bs = self.borderSize
        Graphics.setColor(colorBorder)
        Graphics.rectangle(self.x-bs, self.y-bs, self.width+bs*2, self.height+bs*2)
    end
    Graphics.setColor(colorMain)
    Graphics.rectangle(self.x, self.y, self.width, self.height)

    local text
    local colorText
    if utf8.len(self.text) > 0 then
        text = self.text
        colorText = self.colorText
    elseif self.placeholder then
        text = self.placeholder
        colorText = self.colorTextPlaceholder
    end

    Graphics.setColor(colorText)
    Graphics.text(self.x + self.textOffset, self.y, self.width-self.textOffset-2, self.height, text, self.textAlignHorizontal,
        self.textAlignVertical, self.textClip, self.textWordBreak, self.textColorCoded)
end
