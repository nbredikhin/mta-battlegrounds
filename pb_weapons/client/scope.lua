local screenSize = Vector2(guiGetScreenSize())
local isScopeActive = false
local keyTimer

local hideShaders = {}
local hideTexture = dxCreateTexture("assets/nil.png")

local currentScope = nil--"2x"--"holographic"
local scopeWidth, scopeHeight

local scopeTextures = {}

local movementX = 0
local movementY = 0

local walkingX = 0
local walkingY = 0

local scopeShader
local scopeAnim = 0

local scopeFireLightTime = 0
local scopeFireLightTimeMax = 0.1

local firingMode = 1
local firingModes = {
    {name="auto"  , title = "Full auto"},
    {name="single", title = "Single shot"},
    {name="burst" , title = "Burst"},
}
local burstCount = 0
local firingModeMessageTimer = nil

local disableScopeSlots = {
    [0] = true,
    [1] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
}

local blockedTasks =
{
    "TASK_SIMPLE_IN_AIR", -- We're falling or in a jump.
    "TASK_SIMPLE_JUMP", -- We're beginning a jump
    "TASK_SIMPLE_LAND", -- We're landing from a jump
    "TASK_SIMPLE_GO_TO_POINT", -- In MTA, this is the player probably walking to a car to enter it
    "TASK_SIMPLE_NAMED_ANIM", -- We're performing a setPedAnimation
    "TASK_SIMPLE_CAR_OPEN_DOOR_FROM_OUTSIDE", -- Opening a car door
    "TASK_SIMPLE_CAR_GET_IN", -- Entering a car
    "TASK_SIMPLE_CLIMB", -- We're climbing or holding on to something
    "TASK_SIMPLE_SWIM",
    "TASK_SIMPLE_HIT_HEAD", -- When we try to jump but something hits us on the head
    "TASK_SIMPLE_FALL", -- We fell
    "TASK_SIMPLE_GET_UP" -- We're getting up from a fall
}

function isScopeBlocked()
    if localPlayer.vehicle then
        return true
    end
    -- Usually, getting the simplest task is enough to suffice
    local task = getPedSimplestTask (localPlayer)

    -- Iterate through our list of blocked tasks
    for idx, badTask in ipairs(blockedTasks) do
        -- If the player is performing any unwanted tasks, do not fire an event to reload
        if (task == badTask) then
            return true
        end
    end

    return false
end

local function getScopeTexture(name)
    if scopeTextures[name] then
        return scopeTextures[name]
    end
    scopeTextures[name] = dxCreateTexture(name)
    return scopeTextures[name]
end

function loadScope(name)
    if not name or not Config.scopes[name] then
        return
    end
    currentScope = name
    local texture = getScopeTexture("assets/scopes/"..currentScope..".png")
    scopeWidth, scopeHeight = texture:getSize()
    scopeShader:setValue("MainTexture", texture)
    scopeShader:setValue("NormalTexture", getScopeTexture("assets/scopes/"..currentScope.."_normal.png"))
    if isScopeActive then
        setFirstPersonZoom(Config.scopes[currentScope].zoom)
    end
end

function toggleScope()
    isScopeActive = not isScopeActive
    if not getWeaponCameraOffset() or isScopeBlocked() or not currentScope then
        isScopeActive = false
    end

    setFirstPersonEnabled(isScopeActive)
    toggleControl("aim_weapon", not isScopeActive)
    localPlayer:setControlState("aim_weapon", isScopeActive)

    scopeAnim = 0

    if isScopeActive then
        if currentScope then
            setFirstPersonZoom(Config.scopes[currentScope].zoom)
        end
        hideShaders = {}

        local shader = dxCreateShader("assets/replace.fx", 0, 0, false, "ped")
        dxSetShaderValue(shader, "gTexture", hideTexture)
        engineApplyShaderToWorldTexture(shader, "*", localPlayer)
        table.insert(hideShaders, shader)

        local shader = dxCreateShader("assets/replace.fx")
        dxSetShaderValue(shader, "gTexture", hideTexture)
        engineApplyShaderToWorldTexture(shader, "smokeii_*")
        engineApplyShaderToWorldTexture(shader, "collisionsmoke*")
        table.insert(hideShaders, shader)
    else
        setControlState("fire", false)
        if hideShaders then
            for i, shader in ipairs(hideShaders) do
                destroyElement(shader)
            end
        end
        hideShaders = nil
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    scopeShader = dxCreateShader("assets/shader.fx")
    scopeShader:setValue("AmbientColor", {0.2, 0.2, 0.2})

    showPlayerHudComponent("crosshair", false)
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

    if key == "mouse1" and not isScopeActive and not localPlayer:getControlState("aim_weapon") and not disableScopeSlots[localPlayer.weaponSlot] then
        cancelEvent()
    end

    if key == "mouse1" and not state then
        burstCount = 0
    end

    if key == Config.firingModeKey and state then
        firingMode = firingMode + 1
        if firingMode > 3 then
            firingMode = 1
        end

        if isTimer(firingModeMessageTimer) then
            killTimer(firingModeMessageTimer)
        end
        firingModeMessageTimer = setTimer(function ()
            firingModeMessageTimer = nil
        end, 2500, 1)
    end
end)

addEventHandler("onClientPlayerWeaponSwitch", root, function (_, slot)
    if isScopeActive and not getWeaponCameraOffset() then
        toggleScope()
    end
end)

addEventHandler("onClientRender", root, function ()
    if firingModeMessageTimer then
        local str = "Firing mode changed to: " .. firingModes[firingMode].title
        dxDrawText(str, 0, screenSize.y * 0.8, screenSize.x, screenSize.y, tocolor(255, 255, 255, 255), 1.5, "default-bold", "center", "top")
    end

    if isScopeActive then
        -- dxDrawRectangle(screenSize.x/2-2,screenSize.y/2-2,4,4,tocolor(255, 255, 255, 150))
        local rx, ry = getCameraRecoilVelocity()

        local scope = Config.scopes[currentScope]
        local scale = (screenSize.y / 2) / (scopeHeight - scope.y) - ry * 0.0015
        scale = scale * scope.scale

        local width, height = scopeWidth * scale, scopeHeight * scale
        local ox, oy = scope.x * scale, scope.y * scale

        local moveX, moveY = rx + movementX + walkingX, ry * 0.5 + movementY + walkingY

        local rotation = rx + (1-scopeAnim) * 45
        moveX = moveX + (1-scopeAnim) * height * 0.7
        moveY = moveY + (1-scopeAnim) * height
        dxDrawImage(screenSize.x/2-ox+moveX, screenSize.y/2-oy+moveY, width, height, scopeShader, rotation, ox-width/2, oy-height/2)
        dxDrawImage(screenSize.x/2-ox+moveX*0.5, screenSize.y/2-oy+moveY*0.5, width, height, "assets/scopes/"..currentScope.."_inner.png", rotation, ox-width/2, oy-height/2)

        local lookDirection = getCameraLookDirection()
        scopeShader:setValue("LightDirectionX", lookDirection.y)
        scopeShader:setValue("LightDirectionY", lookDirection.z)
        scopeShader:setValue("LightDirectionZ", math.max(0.5, lookDirection.x))

        local lightMul = scopeFireLightTime / scopeFireLightTimeMax
        local r, g, b = 50 + 205 * lightMul, 50 + 100 * lightMul, 50
        scopeShader:setValue("AmbientColor", {r / 255, g / 255, b / 255})
    elseif getControlState("aim_weapon") and not disableScopeSlots[localPlayer.weaponSlot] then
        local tx, ty, tz = getPedTargetEnd(localPlayer)
        local x, y = getScreenFromWorldPosition(tx, ty, tz)
        if x then
            dxDrawRectangle(x-1,y-1,2,2,tocolor(255, 255, 255, 150))

            local rx, ry = getCameraRecoilVelocity()
            local offset = 5 + (rx * rx + ry * ry) * 0.01
            local w = 15
            local h = 2
            local color2 = tocolor(255, 255, 255, 100)
            dxDrawRectangle(x - offset - w, y - h/2, w, h, color2)
            dxDrawRectangle(x + offset, y - h/2, w, h, color2)
            dxDrawRectangle(x - h/2, y - offset - w, h, w, color2)
            dxDrawRectangle(x - h/2, y + offset, h, w, color2)
        end
    end
end)

addEventHandler("onClientPreRender", root, function (deltaTime)
    if not isScopeActive then
        return
    end
    deltaTime = deltaTime / 1000

    scopeFireLightTime = math.max(0, scopeFireLightTime - deltaTime)

    movementX = movementX * math.exp(deltaTime * -15)
    movementY = movementY * math.exp(deltaTime * -8)

    if getControlState("forwards") or getControlState("backwards") or getControlState("left") or getControlState("right") then
        local velocityMul = 0.9
        if localPlayer.ducked then
            velocityMul = 1.4
        end
        local wx = math.cos(getTickCount() * 0.004 * velocityMul) * 30 * velocityMul
        local wy = math.sin(getTickCount() * 0.008 * velocityMul) * 20 * velocityMul
        if localPlayer.ducked then
            wx = wx + 20
            wy = wy + 50
        end
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
    movementY = movementY - my * 150
end)

addEventHandler("onClientPlayerWeaponFire", localPlayer, function ()
    scopeFireLightTime = scopeFireLightTimeMax

    if firingMode == 3 then
        burstCount = burstCount + 1
        if burstCount >= 3 then
            localPlayer:setControlState("fire", false)
            burstCount = 0
        end
    elseif firingMode == 2 then
        localPlayer:setControlState("fire", false)
    end
end)

addCommandHandler("setscope", function (cmd, name)
    loadScope(name)
end)
