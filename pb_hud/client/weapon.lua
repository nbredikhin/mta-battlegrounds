local screenSize = Vector2(guiGetScreenSize())
local slotsOrder = {"primary1", "primary2", "secondary", "melee"}
local drawSlots = {}
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
    local activeSlotName, activeSlot = exports.pb_inventory:getActiveWeaponSlot()
    offset = offset + (-((activeSlot - 1) * weaponIconWidth + weaponIconWidth / 2) - offset) * 0.2
    size = size + (1.7 - size) * 0.15

    local halfScreen = screenSize.x / 2
    for i, slot in ipairs(slotsOrder) do
        local item = exports.pb_inventory:getWeaponSlot(slot)
        if item then
            local weaponId = exports.pb_inventory:getItemClass(item.name).weaponId
            local icon = weaponIcons[weaponId]
            if icon then
                local s = 1
                local clip = item.clip
                local ammo = item.ammo
                local weaponSlot = getSlotFromWeapon(weaponId)
                if i == activeSlot  then
                    s = size
                    if localPlayer:getWeapon() ~= 0 then
                        clip = localPlayer:getAmmoInClip(weaponSlot)
                        ammo = localPlayer:getTotalAmmo(weaponSlot) - clip
                    end
                end
                local w = math.floor(icon.width * 0.2 * s)
                local h = math.floor(icon.height * 0.2 * s)
                local ix = x + weaponIconWidth / 2
                local alpha = math.max(0, (2 - math.abs(screenSize.x / 2 - ix) / weaponIconWidth) / 2)
                if alpha > 0.1 then
                    local ty = y - 60
                    local r, g, b = 255, 255, 255
                    if clip == 0 then
                        r, g, b = 255, 0, 0
                    end
                    dxDrawText(clip, ix - 10, ty, ix - 10, ty ,tocolor(r, g, b, 255 * alpha),1.2*s,"default-bold","right","bottom")
                    local bs = 10 * s
                    dxDrawImage(ix-bs/2, ty-bs-3*s,bs,bs,bulletTexture,0,0,0,tocolor(255,255,255,255*alpha))
                    dxDrawText(ammo, ix + 10, ty - 2, ix + 10, ty - 2 ,tocolor(255,255,255, 150 * alpha),0.8*s,"default-bold","left","bottom")
                    dxDrawImage(ix - w / 2, y - h / 2, w, h, icon.texture, 0, 0, 0, tocolor(r, g, b, 255 * alpha))
                end
                x = x + weaponIconWidth
            end
        end
    end
end

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
