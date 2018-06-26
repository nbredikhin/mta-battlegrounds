Container = class("Container", Widget)

function Container:initialize(params)
    Widget.initialize(self, params)

    self.bringToFrontOnClick = true
end
