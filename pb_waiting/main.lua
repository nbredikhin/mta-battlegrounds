local w = 750
local h = 292
local sw, sh = guiGetScreenSize()

addEventHandler("onClientRender", root, function ()
    dxDrawRectangle(0,0,sw,sh,tocolor(0,0,0))
    dxDrawImage(sw/2-w/2, sh/2-h/2, w,h, "logo.png")

    dxDrawText(root:getData("announce_msg") or "Скоро всё запустим, не отключайтесь", 0, 0, sw, sh * 0.75, currentColor, 2.5, "default-bold", "center", "bottom")
end)

showChat(true)
