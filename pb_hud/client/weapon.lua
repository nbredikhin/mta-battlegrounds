local screenSize = Vector2(guiGetScreenSize())
local weaponIcons = {}

local slotsOrder = {"primary1", "primary2", "secondary", "melee", "grenade"}
local clientSlots = {}

local weaponIconWidth = 200
local weaponIconHeight = 40

local scrollOffset = 0
local iconSize = 1

local iconAlpha = 1
local isFading = false

local bulletTexture
local fadingTimer

local activeSlotName, activeSlotIndex = "primary1", 1

local function drawWeaponSlot(slot, x, y)
    local item = exports.pb_inventory:getWeaponSlot(slot)
    if not item then
        return
    end
    local weaponId = exports.pb_inventory:getItemClass(item.name).weaponId
    if not weaponId then
        return
    end
    local icon = weaponIcons[weaponId]
    if not icon then
        return
    end
    local weaponSlot = getSlotFromWeapon(weaponId)
    local size = 1
    local clip = item.clip
    local ammo = item.ammo
    if slot == activeSlotName then
        size = iconSize
        if localPlayer:getWeapon() ~= 0 then
            clip = localPlayer:getAmmoInClip(weaponSlot)
            ammo = localPlayer:getTotalAmmo(weaponSlot) - clip
        end
    end
    local w = math.floor(icon.width * 0.2 * size)
    local h = math.floor(icon.height * 0.2 * size)
    local ix = x + weaponIconWidth / 2
    local alpha = math.max(0, (2 - math.abs(screenSize.x / 2 - ix) / weaponIconWidth) / 2)
    if slot ~= activeSlotName then
        alpha = alpha * iconAlpha
    end
    if alpha < 0.1 then
        return
    end

    local ty = y - 60
    local weaponColor = tocolor(255, 255, 255, 255 * alpha)
    if clip == 0 then
        weaponColor = tocolor(255, 0, 0, 255 * alpha)
    end

    local ammoColor = tocolor(255, 255, 255, 200 * alpha)
    if ammo == 0 then
        ammoColor = tocolor(255, 0, 0, 0 * alpha)
    end

    if ammo > 0 and (slot == "primary1" or slot == "primary2" or slot == "secondary") then
        dxDrawText(clip, ix - 10, ty, ix - 10, ty ,weaponColor,1.2*size,"default-bold","right","bottom")
        local bs = 10 * size
        dxDrawImage(ix-bs/2, ty-bs-3*size,bs,bs,bulletTexture,0,0,0,ammoColor)
        dxDrawText(ammo, ix + 10, ty - 2, ix + 10, ty - 2 ,ammoColor,0.8*size,"default-bold","left","bottom")
    elseif slot == "grenade" or ammo == 0 then
        dxDrawText(clip, ix - 10, ty, ix + 10, ty ,weaponColor,1.2*size,"default-bold","center","bottom")
    end
    dxDrawImage(ix - w / 2, y - h / 2, w, h, icon.texture, 0, 0, 0, weaponColor)
end

function drawWeapon()
    if not isResourceRunning("pb_inventory") then
        return
    end
    scrollOffset = scrollOffset + (-((activeSlotIndex - 1) * weaponIconWidth + weaponIconWidth / 2) - scrollOffset) * 0.2

    local x = screenSize.x / 2 + scrollOffset
    local y = screenSize.y - 130

    iconSize = iconSize + (1.7 - iconSize) * 0.15
    if isFading then
        iconAlpha = iconAlpha + (0 - iconAlpha) * 0.1
    end

    local halfScreen = screenSize.x / 2

    for i, slot in ipairs(clientSlots) do
        drawWeaponSlot(slot, x, y)
        x = x + weaponIconWidth
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
    globalAlpha = 0
end)

addEvent("onWeaponsUpdate", false)
addEventHandler("onWeaponsUpdate", root, function ()
    clientSlots = {}
    local clientWeapons = exports.pb_inventory:getClientWeapons() or {}
    for i, slot in ipairs(slotsOrder) do
        if clientWeapons[slot] then
            table.insert(clientSlots, slot)
        end
    end
end)

addEvent("onWeaponSlotChange", false)
addEventHandler("onWeaponSlotChange", root, function ()
    if isTimer(fadingTimer) then
        killTimer(fadingTimer)
    end

    local newSlot = exports.pb_inventory:getActiveWeaponSlot()
    if activeSlotName == newSlot then
        return
    end
    activeSlotName = newSlot
    for i, slot in ipairs(clientSlots) do
        if slot == activeSlotName then
            activeSlotIndex = i
        end
    end

    iconSize = 1
    iconAlpha = 1

    isFading = false
    fadingTimer = setTimer(function ()
        isFading = true
    end, 700, 1)
end)
