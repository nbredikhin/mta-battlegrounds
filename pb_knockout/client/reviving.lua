local screenSize = Vector2(guiGetScreenSize())

local isReviving = false
local revivingTimer = nil
local revivingPosition = nil
local cooldownTimer = nil

local REVIVING_TIME = 10000
local REVIVING_DISTANCE = 0.05

local cancelButtons = {
    f = true,
    lshift = true,
    rshift = true,
}

function localize(name)
    local res = getResourceFromName("pb_lang")
    if (res) and (getResourceState(res) == "running") then
        return exports.pb_lang:localize(name)
    else
        return name
    end
end

local function draw()
    if not isReviving then
        return
    end

    -- Отображение времени
    if isTimer(revivingTimer) then
        local time = tostring(math.floor(getTimerDetails(revivingTimer) / 100 ) / 10)
        if string.len(time) == 1 then
            time = time .. ".0"
        end
        str = localize("action_reviving") .. " - " .. time
        if revivingTarget then
            str = str .. "\n" .. localize("inventory_using_cancel")
        end
        dxDrawText(str, 1, 1, screenSize.x + 1, screenSize.y * 0.6 + 1, tocolor(0, 0, 0, 150), 1.5, "default-bold", "center", "bottom")
        dxDrawText(str, 0, 0, screenSize.x, screenSize.y * 0.6, tocolor(255, 255, 255), 1.5, "default-bold", "center", "bottom")
    end

    -- Проверка расстояния между игроками
    if revivingPosition then
        if getDistanceBetweenPoints3D(localPlayer.position, revivingPosition) > REVIVING_DISTANCE then
            cancelReviving()
        end
    end
end

function revivePlayer(player)
    if not isElement(player) then
        return
    end
    if isTimer(cooldownTimer) then
        return
    end
    if getElementType(player) ~= "player" then
        return
    end
    if not player:getData("knockout") then
        return
    end
    if player == localPlayer then
        return
    end
    if player.vehicle or localPlayer.vehicle then
        return
    end
    -- TODO: Проверить, находится ли игрок в скваде
    triggerServerEvent("onPlayerStartReviving", resourceRoot, player)
end

function cancelReviving()
    if not isReviving then
        return
    end
    triggerServerEvent("onPlayerCancelReviving", resourceRoot)

    cooldownTimer = setTimer(function () end, 1000, 1)
end

function finishReviving()
    if not isReviving then
        return
    end
    if not revivingTarget then
        return
    end

    triggerServerEvent("onPlayerFinishReviving", resourceRoot)
    cooldownTimer = setTimer(function () end, 1000, 1)
end

function startReviving(targetPlayer)
    if isReviving then
        return
    end
    isReviving = true

    if not isElement(targetPlayer) then
        revivingTarget = nil
    else
        revivingTarget = targetPlayer
    end

    revivingTimer = setTimer(finishReviving, REVIVING_TIME, 1)
    revivingPosition = localPlayer.position
    addEventHandler("onClientRender", root, draw)

    localPlayer:setData("reviving", true, false)
end

function stopReviving()
    if not isReviving then
        return
    end
    isReviving = false
    if isTimer(revivingTimer) then
        killTimer(revivingTimer)
    end
    revivingTimer = nil
    removeEventHandler("onClientRender", root, draw)

    localPlayer:setData("reviving", false, false)
end

addEventHandler("onClientKey", root, function (button, down)
    if cancelButtons[button] and down then
        if isTimer(revivingTimer) then
            if revivingTarget then
                cancelReviving()
            end
        end
    end
end)

addEvent("onClientRevivingStart", true)
addEvent("onClientRevivingStop", true)

addEventHandler("onClientRevivingStart", resourceRoot, startReviving)
addEventHandler("onClientRevivingStop", resourceRoot, stopReviving)
