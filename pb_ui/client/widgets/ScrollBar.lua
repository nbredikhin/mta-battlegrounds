ScrollBar = class("ScrollBar", Widget)

function ScrollBar:initialize(params)
    Widget.initialize(self, params)

    self.colorMain  = params.colorMain  or tocolor(90, 90, 90)
    self.colorHover = params.colorHover or tocolor(120, 120, 120)

    self.borderSize  = params.borderSize  or 3
    self.colorBorder = params.colorBorder or tocolor(15, 15, 15)

    self.value = params.value or 0
    self.step  = params.step  or 0.1
end

function ScrollBar:handleScroll(delta)
    self.value = math.max(0, math.min(1, self.value + delta * self.step))
end

function ScrollBar:draw()
    Graphics.setColor(self.colorBorder)
    Graphics.rectangle(self.x, self.y, self.width, self.height)

    local barHeight = self.height-self.borderSize*2
    local scrollHeight = barHeight/4

    if self.isMouseOver then
        Graphics.setColor(self.colorHover)

        if getKeyState("mouse1") then
            self.value = math.max(0, math.min(1, (self.mouseY - scrollHeight/2) / (barHeight-scrollHeight)))
        end
    else
        Graphics.setColor(self.colorMain)
    end

    local y = self.y + self.borderSize + (barHeight-scrollHeight) * self.value
    Graphics.rectangle(self.x + self.borderSize, y, self.width - 6, scrollHeight)
end
