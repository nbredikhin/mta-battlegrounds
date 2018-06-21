Rectangle = class("Rectangle", Widget)

function Rectangle:initialize(params)
    Widget.initialize(self, params)

    self.borderSize = params.borderSize or 0
    self.borderColor = params.borderColor or tocolor(255, 255, 255)
    self.color = params.color or tocolor(255, 255, 255)
end

function Rectangle:draw()
    Graphics.rectangle(self.x, self.y, self.width, self.height, self.color)
    if self.borderSize > 0 then
        Graphics.setColor(self.borderColor)
        Graphics.line(self.x, self.y, self.x + self.width, self.y, self.borderSize)
        Graphics.line(self.x + self.width, self.y, self.x + self.width, self.y + self.height, self.borderSize)
        Graphics.line(self.x + self.width, self.y + self.height, self.x, self.y + self.height, self.borderSize)
        Graphics.line(self.x, self.y + self.height, self.x, self.y, self.borderSize)
    end
end
