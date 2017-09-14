local w = 750
local h = 292
local sw, sh = guiGetScreenSize()

addEventHandler("onClientRender", root, function ()
    dxDrawRectangle(0,0,sw,sh,tocolor(0,0,0))
    dxDrawImage(sw/2-w/2, sh/2-h/2, w,h, "logo.png")
end)

showChat(true)
