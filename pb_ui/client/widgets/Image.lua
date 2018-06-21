Image = class("Image", Widget)

function Image:initialize(params)
    Widget.initialize(self, params)

    self.color = params.color or tocolor(200, 200, 200)
    self.texture = params.texture
end

function Image:draw()
    if self.texture then
        Graphics.image(self.x, self.y, self.width, self.height, self.texture)
    end
end
