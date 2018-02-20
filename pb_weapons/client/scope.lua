local screenSize = Vector2(guiGetScreenSize())
local isScopeActive = false
local keyTimer

local hideShader
local hideTexture = dxCreateTexture("assets/nil.png")

local currentScope = "holographic"

local movementX = 0
local movementY = 0

local walkingX = 0
local walkingY = 0

local scopeShader
local scopeAnim = 0

function toggleScope()
    isScopeActive = not isScopeActive
    if not getWeaponCameraOffset() then
        isScopeActive = false
    end

    setFirstPersonEnabled(isScopeActive)
    toggleControl("aim_weapon", not isScopeActive)
    localPlayer:setControlState("aim_weapon", isScopeActive)

    scopeAnim = 0

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

addEventHandler("onClientResourceStart", resourceRoot, function ()
    scopeShader = dxCreateShader("assets/shader.fx")
    scopeShader:setValue("MainTexture", dxCreateTexture("assets/scopes/holographic.png"))
    scopeShader:setValue("NormalTexture", dxCreateTexture("assets/scopes/holographic_normal.png"))
    scopeShader:setValue("AmbientColor", {0.2, 0.2, 0.2})
end)

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
    if isScopeActive and not getWeaponCameraOffset() then
        toggleScope()
    end
end)

addEventHandler("onClientRender", root, function ()
    if isScopeActive then
        -- dxDrawRectangle(screenSize.x/2-2,screenSize.y/2-2,4,4,tocolor(255, 255, 255, 150))
        local offset = Config.scopeOffsets[currentScope]
        local scale = 1.8

        local width, height = 423 * scale, 498 * scale
        local ox, oy = offset.x * scale, offset.y * scale

        local rx, ry = getCameraRecoilVelocity()
        local moveX, moveY = rx + movementX + walkingX, ry * 0.5 + movementY + walkingY

        local rotation = rx + (1-scopeAnim) * 45
        moveX = moveX + (1-scopeAnim) * height * 0.7
        moveY = moveY + (1-scopeAnim) * height
        dxDrawImage(screenSize.x/2-ox+moveX, screenSize.y/2-oy+moveY, width, height, scopeShader, rotation, ox-width/2, oy-height/2)
        dxDrawImage(screenSize.x/2-ox+moveX*0.5, screenSize.y/2-oy+moveY*0.5, width, height, "assets/scopes/"..currentScope.."_inner.png", rotation, ox-width/2, oy-height/2)

        local lookDirection = getCameraLookDirection()
        scopeShader:setValue("LightDirectionX", lookDirection.y)
        scopeShader:setValue("LightDirectionY", lookDirection.z)
        scopeShader:setValue("LightDirectionZ", math.max(0.5, lookDirection.x))--math.sin(time))
    end
end)

addEventHandler("onClientPreRender", root, function (deltaTime)
    if not isScopeActive then
        return
    end
    deltaTime = deltaTime / 1000

    movementX = movementX * math.exp(deltaTime * -15)
    movementY = movementY * math.exp(deltaTime * -8)

    if getControlState("forwards") or getControlState("backwards") or getControlState("left") or getControlState("right") then
        local velocityMul = 0.9
        if localPlayer.ducked then
            velocityMul = 1.4
        end
        local wx = math.cos(getTickCount() * 0.004 * velocityMul) * 30 * velocityMul
        local wy = math.sin(getTickCount() * 0.008 * velocityMul) * 20 * velocityMul
        walkingX = walkingX + (wx - walkingX) * 0.2
        walkingY = walkingY + (wy - walkingY) * 0.2
    else
        walkingX = walkingX - walkingX * 0.2
        walkingY = walkingY - walkingY * 0.2
    end

    scopeAnim = scopeAnim + (1 - scopeAnim) * math.exp(deltaTime * -120)
end)

addEventHandler("onClientCursorMove", root, function (x, y)
    if not isScopeActive then
        return
    end
    local mx = x - 0.5
    local my = y - 0.5
    movementX = movementX - mx * 250
    movementY = movementY - my * 250
end)
