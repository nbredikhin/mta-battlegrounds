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

    if isTimer(revivingTimer) then
        local time = tostring(math.floor(getTimerDetails(revivingTimer) / 100 ) / 10)
        if string.len(time) == 1 then
            time = time .. ".0"
        end
        str = localize("action_reviving") .. " - " .. time
        if revivingTarget then
            str = str .. "\n" .. localize("inventory_using_cancel")
        end
        drawUsingText(str)

        if getDistanceBetweenPoints3D(localPlayer.position, revivingPosition) > 1 then
            cancelReviving()
        end
    end

    local actionElement = getActionElement()
    if isElement(actionElement) then
        if actionElement.type == "player" then
            if actionElement:getData("knockout") and not localPlayer:getData("knockout") and not getUsingItemName() then
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

function cancelReviving(omitEvent)
    if not isTimer(revivingTimer) then
        return
    end
    killTimer(revivingTimer)
    if not revivingTarget then
        localPlayer:setData("reviving", false)
    end
    if not omitEvent then
        triggerServerEvent("onPlayerStopReviving", resourceRoot, revivingTarget)
    end
end

local function startRevivingPlayer(player)
    if not isElement(player) then
        return
    end
    if localPlayer:getData("knockout") then
        return
    end
    if getUsingItemName() then
        return
    end
    if isTimer(revivingTimer) then
        return
    end
    triggerServerEvent("onPlayerStartReviving", resourceRoot, player)
end

local function finishRevivingPlayer()
    iprint("FINISHED IDD")
    triggerServerEvent("onPlayerStopReviving", resourceRoot, revivingTarget, true)
end

addEvent("onClientStopReviving", true)
addEventHandler("onClientStopReviving", resourceRoot, function ()
    iprint("STOP REVIVING")
    cancelReviving(true)
end)

addEvent("onClientStartRevieving", true)
addEventHandler("onClientStartRevieving", resourceRoot, function (targetPlayer)
    revivingTarget = targetPlayer
    revivingTimer = setTimer(finishRevivingPlayer, Config.reviveTime, 1, targetPlayer)
    revivingPosition = localPlayer.position
end)

addEventHandler("onClientKey", root, function (button, down)
    if button == "f" and down then
        if isTimer(revivingTimer) then
            if revivingTarget then
                cancelReviving()
            end
        end
        local actionElement = getActionElement()
        if isElement(actionElement) then
            if getElementType(actionElement) == "player" then
                startRevivingPlayer(actionElement)
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

addEventHandler("onClientElementDataChange", root, function (dataName)
    if dataName == "reviving" then
        if source == revivingTarget and not revivingTarget:getData("reviving") then
            iprint("WAT")
            cancelReviving()
        end
    elseif dataName == "knockout" and source == localPlayer then
        if localPlayer:getData("knockout") then
            cancelReviving()
        end
    end
end)
