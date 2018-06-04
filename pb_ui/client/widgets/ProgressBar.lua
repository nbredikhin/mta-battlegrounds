ProgressBar = class("ProgressBar", Widget)

function ProgressBar:initialize(params)
    Widget.initialize(self, params)

    -- Цвета фона в различных состояниях
    self.colorBackground = params.colorBackground or tocolor(50, 50, 50)
    self.colorProgress   = params.colorProgress   or tocolor(180, 180, 180)
    self.borderSize      = params.borderSize      or 3
    self.colorBorder     = params.colorBorder     or tocolor(70, 70, 70)
    self.progress        = params.progress        or 0
end

function ProgressBar:draw()
    if self.borderSize > 0 then
        local bs = self.borderSize
        Graphics.setColor(self.colorBorder)
        Graphics.rectangle(self.x-bs, self.y-bs, self.width+bs*2, self.height+bs*2)
    end

    Graphics.setColor(self.colorBackground)
    Graphics.rectangle(self.x, self.y, self.width, self.height)

    if self.progress > 0 then
        Graphics.setColor(self.colorProgress)
        Graphics.rectangle(self.x, self.y, self.width  * self.progress, self.height)
    end
end
