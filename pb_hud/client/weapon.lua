local screenSize = Vector2(guiGetScreenSize())
local drawSlots = {}
local slotsOrder = {5, 6, 3, 4, 2, 1, 8}
local activeSlot = 1
local weaponIconWidth = 200
local weaponIconHeight = 40
local weaponIcons = {}
local offset = 0
local size = 1
local bulletTexture

function drawWeapon()
    local x = screenSize.x / 2
    local y = screenSize.y - 130
    x = x + offset
    offset = offset + (-((activeSlot - 1) * weaponIconWidth + weaponIconWidth / 2) - offset) * 0.2
    size = size + (1.7 - size) * 0.15
    local halfScreen = screenSize.x / 2
    for i, slot in ipairs(drawSlots) do
        local weapon = localPlayer:getWeapon(slot)
        local icon = weaponIcons[weapon]
        if icon and weapon > 0 then
            local s = 1
            if i == activeSlot then
                s = size
            end
            local w = math.floor(icon.width * 0.2 * s)
            local h = math.floor(icon.height * 0.2 * s)
            local ix = x + weaponIconWidth / 2
            local alpha = math.max(0, (2 - math.abs(screenSize.x / 2 - ix) / weaponIconWidth) / 2)
            if alpha > 0.1 then
                if DEBUG_DRAW then
                    dxDrawText("[slot="..tostring(slot).."; weapon="..tostring(weapon).."]", ix - w, y - 100, ix+w, y-100,tocolor(0,255,0),1,"default","center","center")
                end
                local ty = y - 60
                dxDrawText(localPlayer:getAmmoInClip(slot), ix - 10, ty, ix - 10, ty ,tocolor(255, 255, 255, 255 * alpha),1.2*s,"default-bold","right","bottom")
                local bs = 10 * s
                dxDrawImage(ix-bs/2, ty-bs-3*s,bs,bs,bulletTexture,0,0,0,tocolor(255,255,255,255*alpha))
                dxDrawText(localPlayer:getTotalAmmo(slot), ix + 10, ty - 2, ix + 10, ty - 2 ,tocolor(255, 255, 255, 150 * alpha),0.8*s,"default-bold","left","bottom")
                dxDrawImage(ix - w / 2, y - h / 2, w, h, icon.texture, 0, 0, 0, tocolor(255, 255, 255, 255 * alpha))
            end
            x = x + weaponIconWidth
        end
    end
end

function updateSlots()
    drawSlots = {}
    for i, slot in ipairs(slotsOrder) do
        if localPlayer:getWeapon(slot) > 0 then
            table.insert(drawSlots, slot)
        end
    end
end

addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function (prevSlot, curSlot)
    updateSlots()

    for i, slot in ipairs(drawSlots) do
        if curSlot == slot then
            activeSlot = i
            size = 1
            return
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for i = 0, 50 do
        if fileExists("assets/"..i..".png") then
            local texture = dxCreateTexture("assets/"..i..".png")
            local width, height = dxGetMaterialSize(texture)
            weaponIcons[i] = {texture = texture, width = width, height = height}
        end
    end

    bulletTexture = dxCreateTexture("assets/bullet.png")
end)

updateSlots()
