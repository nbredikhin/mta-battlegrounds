local isScopeActive = false
local keyTimer

local scopeSlots = {
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
}

function toggleScope()
    isScopeActive = not isScopeActive
    if not scopeSlots[localPlayer.weaponSlot] then
        isScopeActive = false
    end

    setFirstPersonEnabled(isScopeActive)
    toggleControl("aim_weapon", not isScopeActive)
    localPlayer:setControlState("aim_weapon", isScopeActive)
end

addEventHandler("onClientKey", root, function (key, state)
    if key == "mouse2" then
        if isScopeActive then
            if state then
                toggleScope()
                cancelEvent()
            end
        else
            if state then
                keyTimer = setTimer(function () end, 100, 1)
            elseif isTimer(keyTimer) then
                toggleScope()
                cancelEvent()
            end
        end
    end
end)

addEventHandler("onClientPlayerWeaponSwitch", root, function (_, slot)
    if isScopeActive and not scopeSlots[localPlayer.weaponSlot] then
        toggleScope()
    end
end)
