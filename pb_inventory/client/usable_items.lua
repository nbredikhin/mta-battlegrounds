local screenSize = Vector2(guiGetScreenSize())
local usageTimer
local usingItem
local usingTime
local usingPosition
local usingItemName

local function endUsing()
    if isTimer(usageTimer) then
        killTimer(usageTimer)
    end
    usingItem = nil
    usingTime = nil
    usingPosition = nil
    localPlayer:setAnimation()
end

bindKey("f", "down", endUsing)

local function healSelf(item)
    endUsing()
    triggerServerEvent("finishPlayerHeal", resourceRoot, item.name)
end

local function fillFuel(item)
    endUsing()
    triggerServerEvent("finishPlayerFillFuel", resourceRoot, item.name)
end

local function startBoost(item)
    endUsing()
    triggerServerEvent("finishPlayerBoost", resourceRoot, item.name)
end

function getUsingItemName()
    if usingItem then
        return usingItem.name
    end
end

function getUsingProgress()
    if not isTimer(usageTimer) then
        return 0
    end
    local left = getTimerDetails(usageTimer)
    return 1 - left / usingTime
end

function useItem(item)
    if not isItem(item) then
        return
    end
    if isTimer(usageTimer) then
        return
    end
    local itemClass = Items[item.name]
    if itemClass.category == "medicine" then
        if not itemClass.use_time then
            return
        end
        if itemClass.heal_max and math.ceil(localPlayer.health) >= itemClass.heal_max then
            return
        end
        usingItem = item
        usingTime = itemClass.use_time
        usageTimer = setTimer(healSelf, usingTime, 1, item)
        usingPosition = localPlayer.position

        usingItemName = itemClass.readableName
        localPlayer:setAnimation("FOOD", "EAT_Pizza", -1, true, false, true, true)
    elseif itemClass.category == "vehicles" then
        if not itemClass.use_time then
            return
        end
        if not localPlayer.vehicle then
            return
        end
        usingItem = item
        usingTime = itemClass.use_time
        usageTimer = setTimer(fillFuel, usingTime, 1, item)
        usingPosition = localPlayer.position

        usingItemName = itemClass.readableName
    elseif itemClass.category == "boost" then
        if not itemClass.use_time then
            return
        end
        usingItem = item
        usingTime = itemClass.use_time
        usageTimer = setTimer(startBoost, usingTime, 1, item)
        usingPosition = localPlayer.position

        usingItemName = itemClass.readableName
    end
end

addEventHandler("onClientRender", root, function ()
    if usingPosition and usingItem then
        local time = tostring(math.floor(getTimerDetails(usageTimer) / 100 ) / 10)
        if string.len(time) == 1 then
            time = time .. ".0"
        end
        str = localize("inventory_using") .. " " ..tostring(usingItemName) .. " - " .. time .. "\n" .. localize("inventory_using_cancel")
        dxDrawText(str, 1, 1, screenSize.x + 1, screenSize.y * 0.6 + 1, tocolor(0, 0, 0, 150), 1.5, "default-bold", "center", "bottom")
        dxDrawText(str, 0, 0, screenSize.x, screenSize.y * 0.6, tocolor(255, 255, 255), 1.5, "default-bold", "center", "bottom")
        if getDistanceBetweenPoints3D(localPlayer.position, usingPosition) > 1 then
            endUsing()
        end
    end
end)

setTimer(function ()
    local boost = localPlayer:getData("boost")
    if not boost or boost == 0 then
        return
    end
    if boost > 0 and boost <= 20 then
        localPlayer.health = localPlayer.health + 1
    elseif boost > 20 and boost <= 60 then
        localPlayer.health = localPlayer.health + 2
    elseif boost > 60 and boost <= 90 then
        localPlayer.health = localPlayer.health + 3
    elseif boost > 90 then
        localPlayer.health = localPlayer.health + 4
    end

    boost = boost - 1
    if boost < 0 then
        boost = 0
    end
    localPlayer:setData("boost", boost)
end, 1000, 0)
