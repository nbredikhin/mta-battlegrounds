local usageTimer
local usingItem
local usingTime
local usingPosition

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
        localPlayer:setAnimation("FOOD", "EAT_Pizza", -1, true, false, true, true)
    end
end

addEventHandler("onClientRender", root, function ()
    if usingPosition and getDistanceBetweenPoints3D(localPlayer.position, usingPosition) > 1 then
        endUsing()
    end
end)
