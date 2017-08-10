local screenSize = Vector2(guiGetScreenSize())
local width = 640
local lineHeight = 10
local arrowSize = 16
local x = screenSize.x / 2 - width / 2
local y = 40

local fadeOffset = 50

local labels = {
    [0] = "N",
    [180] = "S",
    [90] = "E",
    [270] = "W"
}

addEventHandler("onClientRender", root, function ()
    local camera = getCamera()
    local prot = camera.rotation.z
    for i = 0, 360, 15 do
        local lx = (i + prot) / 360 * width

        lx = lx + x + width / 2
        while lx > x + width do
            lx = lx - width
        end
        local alpha = 1
        if lx < x + fadeOffset then
            alpha = 1 - math.max(0, (x + fadeOffset - lx) / fadeOffset)
        elseif lx > x + width - fadeOffset then
            alpha = 1 - math.max(0, (lx - (x + width - fadeOffset)) / fadeOffset)
        end
        if i % 45 == 0 then
            dxDrawRectangle(lx - 1.5, y, 3, 10, tocolor(255, 255, 255, 255 * alpha))
            if labels[i] then
                dxDrawText(labels[i], lx - 5, y + 10, lx + 8, y + 10, tocolor(255, 255, 255, 180 * alpha), 1, "default-bold", "center", "top")
            end
        else
            dxDrawRectangle(lx, y, 1, 7, tocolor(255, 255, 255, 150 * alpha))
        end
    end

    dxDrawImage(x + width / 2 - arrowSize / 2, y - arrowSize - 1, arrowSize, arrowSize, "assets/arrow.png")
end)
