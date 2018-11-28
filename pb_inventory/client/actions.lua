local screenSize = Vector2(guiGetScreenSize())
local MIN_SHOW_DISTANCE = 60
local pickupItem = nil

local revivingTimer
local revivingTarget
local revivingPosition

function drawPickupMessage(item)
    if not isItem(item) then
        return
    end

    local str = localize("inventory_pick_up") .. " " .. utf8.upper(localize(tostring(Items[item.name].readableName))) .. " (" .. tostring(item.count) .. ")"

    drawActionMessage(str)

    pickupItem = item
end

local function isSquadPlayer(player)
    return player:getData("matchId") == localPlayer:getData("matchId") and player:getData("squadId") == localPlayer:getData("squadId")
end

addEventHandler("onClientRender", root, function()
    pickupItem = nil
    if isInventoryShowing() then
        return
    end

    if localPlayer:getData("isInPlane") then
        if exports.pb_gameplay:canJumpFromPlane() then
            drawActionMessage(localize("action_jump_plane"))
        end
        return
    elseif localPlayer:getData("has_parachute") then
        drawActionMessage(localize("action_open_parachute"))
        return
    end

    local actionElement = getActionElement()
    if isElement(actionElement) then
        if actionElement.type == "player" then
            if actionElement:getData("knockout")
                and not localPlayer:getData("knockout")
                and not getUsingItemName()
                and not localPlayer:getData("reviving")
                and not localPlayer.dead
                and not actionElement.dead
                and isSquadPlayer(actionElement)
            then
                drawActionMessage(localize("action_revive_player"))
            end
        end
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
end, true, "high")

addEventHandler("onClientKey", root, function (button, down)
    if button == "f" and down then
        local actionElement = getActionElement()
        if isElement(actionElement) then
            if getElementType(actionElement) == "player" then
                exports.pb_knockout:revivePlayer(actionElement)
                cancelEvent()
                return
            end
        end
        if isItem(pickupItem) then
            tryPickupLootItem(pickupItem)
            pickupItem = nil
            cancelEvent()
        end
    end
end)
