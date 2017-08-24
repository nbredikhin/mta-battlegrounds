local isInventoryVisible = false

IconTextures = {}

local viewportSize = Vector2(1920, 1080)
local screenSize = Vector2(guiGetScreenSize())
local screenScale = math.min(1, screenSize.x / viewportSize.x)

local inventoryColor = tocolor(255, 255, 255, 38)

local inventoryX = 75
local inventoryY = 136

local slotSize = 60
local specialSlots = {
    armor_head = {
        x = 660,
        y = inventoryY
    },

    backpack = {
        x = 660,
        y = 340,
    },

    armor_body = {
        x = 660,
        y = 340 + slotSize + 5
    },

    belt = {
        x = 660,
        y = 340 + slotSize * 2 + 10
    },

    head_glasses = {
        x = 1170,
        y = inventoryY
    },

    head_mask = {
        x = 1170,
        y = inventoryY + slotSize + 5
    },

    clothes_shirt = {
        x = 1170,
        y = 340,
    },

    clothes_jacket = {
        x = 1170,
        y = 340 + slotSize + 5
    },

    clothes_hands = {
        x = 1170,
        y = 340 + slotSize * 2 + 10
    },

    clothes_pants = {
        x = 1170,
        y = 665
    },

    clothes_feet = {
        x = 1170,
        y = 665 + slotSize * 2
    },
}

local itemWidth = 216
local itemHeight = 60
local itemSpace = 2

local itemsListHeight = 800

local weaponWidth = 475
local weaponAdditionalWidth = weaponWidth / 2 - 10
local weaponHeight = 200

function drawItemsList(items, x, y, title)
    local itemY = y
    local skipTitle = false
    if type(items[1]) == "string" then
        title = items[1]
        skipTitle = true
    end
    if title then
        dxDrawText(title, x + 5, y - itemHeight / 2, x + itemWidth, y, tocolor(255, 255, 255, 200), 1, "default", "left", "center")
    end
    for i, item in ipairs(items) do
        if type(item) == "table" then
            dxDrawRectangle(x, itemY, itemWidth, itemHeight, inventoryColor)
            dxDrawRectangle(x, itemY, itemHeight, itemHeight, tocolor(255, 255, 255, 51 - 38))

            dxDrawImage(x, itemY, itemHeight, itemHeight, IconTextures[item.name])
            dxDrawText(Items[item.name].readableName, x  +itemHeight + 5, itemY, x + itemWidth, itemY + itemHeight, tocolor(255, 255, 255, 200), 1, "default", "left", "center")
            dxDrawText(item.count, x, itemY, x + itemWidth - 10, itemY + itemHeight, tocolor(255, 255, 255, 200), 1, "default-bold", "right", "center")
            itemY = itemY + itemHeight + itemSpace
        else
            if i ~= 1 or not skipTitle then
                dxDrawText(tostring(item), x + 5, itemY, x + itemWidth, itemY + itemHeight / 2, tocolor(255, 255, 255, 200), 1, "default", "left", "center")
                itemY = itemY + itemHeight / 2 + itemSpace
            end
        end
    end
end

function drawSpecialSlot(slot)
    dxDrawRectangle(slot.x - 1, slot.y - 1, slotSize + 2 , slotSize + 2, inventoryColor)
    dxDrawRectangle(slot.x, slot.y, slotSize, slotSize, tocolor(0, 0, 0, 220))
end

function drawSpecialItem(name)
    local slot = specialSlots[name]
    if not slot then
        return
    end
    dxDrawRectangle(slot.x, slot.y, slotSize, slotSize)
    -- local item = getInventorySpecialSlot(name)
    -- if not item then
    --     return
    -- end
end

function drawWeaponSlot(slotName, x, y, width, height, slotIndex)
    local rx = x
    local ry = y + 10
    local rs = 30
    dxDrawLine(x, y + height, x + width, y + height, inventoryColor)
    local item = getWeaponSlot(slotName)
    if not item then
        return
    end
    if slotIndex then
        dxDrawRectangle(rx - 1, ry - 1, rs + 2, rs + 2)
        dxDrawRectangle(rx, ry, rs, rs, tocolor(0, 0, 0, 255))
        dxDrawText(slotIndex, rx, ry, rx + rs, ry + rs, tocolor(255, 255, 255, 255), 1.5, "default-bold", "center", "center")
    end
    if IconTextures[item.name] then
        dxDrawImage(x, y, width, height, IconTextures[item.name])
    end
end

addEventHandler("onClientRender", root, function ()
    if not isInventoryVisible then
        return
    end
    dxSetScale()
    dxTranslate()
    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 200))
    dxTranslate(screenSize.x / 2 - viewportSize.x *  screenScale / 2, screenSize.y / 2 - viewportSize.y *  screenScale / 2)
    dxSetScale(screenScale)

    dxDrawText(string.gsub(localPlayer.name, '#%x%x%x%x%x%x', ''), 0, 0, viewportSize.x, inventoryY, tocolor(255, 255, 255, 255), 2.5, "default-bold", "center", "center")

    for name, slot in pairs(specialSlots) do
        drawSpecialSlot(slot)
    end

    local x = inventoryX
    local y = inventoryY
    drawItemsList(getLootItems(), x, y, "Ground")
    x = x + itemWidth + 15
    dxDrawLine(x, y, x, y + itemsListHeight, tocolor(255, 255, 255, 38))
    x = x + 15
    drawItemsList(getBackpackItems(), x, y, "Backpack")

    local wx = 1312
    local wy = y
    for i = 1, 3 do
        local name = "primary"..i
        if i == 3 then
            name = "secondary"
        end
        drawWeaponSlot(name, wx, wy, weaponWidth, weaponHeight, i)
        wy = wy + weaponHeight
    end
    drawWeaponSlot("melee", wx, wy, weaponAdditionalWidth, weaponHeight)
    drawWeaponSlot("grenade", wx + weaponAdditionalWidth + 20, wy, weaponAdditionalWidth, weaponHeight)
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    isInventoryVisible = true
    for name, item in pairs(Items) do
        local filename = item.texture or name .. ".png"
        local path = "assets/icons/"..filename
        if fileExists(path) then
            IconTextures[name] = dxCreateTexture(path)
        end
    end
end)

bindKey("tab", "down", function ()
    isInventoryVisible = not isInventoryVisible
end)
