local screenSize = Vector2(guiGetScreenSize())
local drawSlots = {5, 6, 3, 4, 1, 2, 8}
local activeSlot = 1
local weaponIconWidth = 200
local weaponIconHeight = 40
local weaponIcons = {}
local offset = 0
local size = 1

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
            local w = math.floor(icon.width * 0.6 * s)
            local h = math.floor(icon.height * 0.6 * s)
            local ix = x + weaponIconWidth / 2
            --local alpha = --math.max(1, math.min(1, 1 - math.abs(ix - screenSize.x / 2) / weaponIconWidth))
            local alpha = math.max(0, (2 - math.abs(screenSize.x / 2 - ix) / weaponIconWidth) / 2)
            if alpha > 0.1 then
                if DEBUG_DRAW then
                    dxDrawText("[slot="..tostring(slot).."; weapon="..tostring(weapon).."]", ix - w, y - 100, ix+w, y-100,tocolor(0,255,0),1,"default","center","center")
                end
                dxDrawImage(ix - w / 2, y - h / 2, w, h, icon.texture, 0, 0, 0, tocolor(255, 255, 255, 255 * alpha))
            end
            x = x + weaponIconWidth
        end
    end
end

addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function (prevSlot, curSlot)
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
end)

toggleControl("next_weapon", false)
toggleControl("previous_weapon", false)

bindKey("next_weapon", "down", function ()
    activeSlot = activeSlot + 1
    if activeSlot > #drawSlots then
        activeSlot = 1
    end
    localPlayer.weaponSlot = drawSlots[activeSlot]
end)

bindKey("previous_weapon", "down", function ()
    activeSlot = activeSlot - 1
    if activeSlot < 1 then
        activeSlot = #drawSlots
    end
    localPlayer.weaponSlot = drawSlots[activeSlot]
end)

bindKey("x", "down", function ()
    if localPlayer.weaponSlot > 0 then
        localPlayer.weaponSlot = 0
    else
        localPlayer.weaponSlot = drawSlots[activeSlot]
    end
end)

for i = 1, #drawSlots do
    bindKey(tostring(i), "down", function ()
        localPlayer.weaponSlot = drawSlots[i]
    end)
end
