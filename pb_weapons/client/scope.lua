local screenSize = Vector2(guiGetScreenSize())
local isScopeActive = false
local keyTimer

local hideShader
local hideTexture = dxCreateTexture("assets/nil.png")

function toggleScope()
    isScopeActive = not isScopeActive
    if not getWeaponCameraOffset() then
        isScopeActive = false
    end

    setFirstPersonEnabled(isScopeActive)
    toggleControl("aim_weapon", not isScopeActive)
    localPlayer:setControlState("aim_weapon", isScopeActive)

    if isScopeActive then
        hideShader = dxCreateShader("assets/replace.fx", 0, 0, false, "ped")
        dxSetShaderValue(hideShader, "gTexture", hideTexture)
        engineApplyShaderToWorldTexture(hideShader, "*", localPlayer)
    else
        if isElement(hideShader) then
            destroyElement(hideShader)
        end
    end
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

    if key == "mouse1" and not isScopeActive and not localPlayer:getControlState("aim_weapon") then
        cancelEvent()
    end
end)

addEventHandler("onClientPlayerWeaponSwitch", root, function (_, slot)
    if isScopeActive and not scopeSlots[localPlayer.weaponSlot] then
        toggleScope()
    end
end)

addEventHandler("onClientRender", root, function ()
    if isScopeActive then
        dxDrawRectangle(screenSize.x/2-2,screenSize.y/2-2,4,4,tocolor(255, 255, 255, 150))
    end
end)
