local screenSize = Vector2(guiGetScreenSize())
local MIN_SHOW_DISTANCE = 60
local pickupItem = nil

function drawPickupMessage(item)
    if not isItem(item) then
        return
    end

    local str = localize("inventory_pick_up") .. " " .. utf8.upper(localize(tostring(Items[item.name].readableName))) .. " (" .. tostring(item.count) .. ")"
    
    drawActionMessage(str)
    
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
