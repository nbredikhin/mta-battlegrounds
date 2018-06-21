Rectangle = class("Rectangle", Widget)

function Rectangle:initialize(params)
    Widget.initialize(self, params)

    self.color = params.color or tocolor(200, 200, 200)
end

function Rectangle:draw()
    Graphics.rectangle(self.x, self.y, self.width, self.height, self.color)
end
