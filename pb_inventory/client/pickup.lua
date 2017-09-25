local screenSize = Vector2(guiGetScreenSize())
local MIN_SHOW_DISTANCE = 60
local pickupItem = nil

function drawPickupMessage(item)
    if not isItem(item) then
        return
    end

    local x = screenSize.x * 0.62
    local y = screenSize.y * 0.55
    local str = localize("inventory_pick_up") .. " " .. utf8.upper(tostring(Items[item.name].readableName)) .. " (" .. tostring(item.count) .. ")"
    local width = dxGetTextWidth(str, 1.5, "default") + 20
    local height = 30
    dxDrawRectangle(x-1, y-1, height+2, height+2, tocolor(255, 255, 255, 38))
    dxDrawRectangle(x, y, height, height, tocolor(0, 0, 0, 220))
    dxDrawText("F", x, y, x+height,y+height, tocolor(255, 255, 255, 255), 1.5, "default-bold", "center", "center")

    x = x + height + 5
    dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 100))
    dxDrawText(str, x+2, y+2, x+width+2,y+height+2, tocolor(0, 0, 0, 255), 1.5, "default", "center", "center")
    dxDrawText(str, x, y, x+width,y+height, tocolor(255, 255, 255, 255), 1.5, "default", "center", "center")

    pickupItem = item
end

addEventHandler("onClientRender", root, function()
    pickupItem = nil
    if isInventoryShowing() then
        return
    end
    local centerX, centerY = screenSize.x / 2, screenSize.y / 2
    local minDistance = screenSize.x
    local minItem
    for i, item in ipairs(getLootItems()) do
        if isElement(item.lootElement) then
            local x, y = getScreenFromWorldPosition(item.lootElement.position, 0, false)
            if x then
                local distance = getDistanceBetweenPoints2D(x, y, centerX, centerY)
                if distance < minDistance then
                    minDistance = distance
                    minItem = item
                end
            end
        end
    end

    if minDistance < MIN_SHOW_DISTANCE and minItem then
        drawPickupMessage(minItem)
    end
end)

addEventHandler("onClientKey", root, function (button, down)
    if button == "f" and down then
        if isItem(pickupItem) then
            tryPickupLootItem(pickupItem)
            pickupItem = nil
            cancelEvent()
        end
    end
end)
