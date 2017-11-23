local knockoutPeds = {}

local progressMin = 0.11
local progressMax = 0.24
local animationSpeed = 0.2

function resetPedAnimation(ped)
    if not isElement(ped) then
        return
    end
    ped:setAnimation("ped", "idle_stance")
    setTimer(function ()
        ped:setAnimation()
    end, 50, 1)
end

function updatePedKnockoutState(ped)
    if not isElement(ped) then
        return
    end
    if ped:getData("knockout") then
        knockoutPeds[ped] = { progress = 0, direction = 1, update = 0 }
    else
        knockoutPeds[ped] = nil
        ped.frozen = false
        resetPedAnimation(ped)
    end
end

addEventHandler("onClientElementStreamIn", root, function ()
    if source.type ~= "player" and source.type ~= "ped" then
        return
    end
    updatePedKnockoutState(source)
end)

addEventHandler("onClientElementStreamOut", root, function ()
    if source.type ~= "player" and source.type ~= "ped" then
        return
    end
    knockoutPeds[source] = nil
    source.frozen = false
    resetPedAnimation(source)
end)

addEventHandler("onClientElementDataChange", root, function (dataName)
    if dataName ~= "knockout" then
        return
    end
    if source.type ~= "player" and source.type ~= "ped" then
        return
    end
    if source ~= localPlayer and not isElementStreamedIn(source) then
        return
    end
    updatePedKnockoutState(source)
end)

addEventHandler("onClientPreRender", root, function (deltaTime)
    deltaTime = deltaTime / 1000
    for ped, anim in pairs(knockoutPeds) do
        if not isElement(ped) or ped.dead then
            ped.frozen = false
            knockoutPeds[ped] = nil
            break
        end
        if ped ~= localPlayer then
            ped.frozen = true
        end
        anim.update = anim.update - deltaTime
        if ped:getData("knockout_moving") then
            anim.progress = anim.progress + animationSpeed * anim.direction * deltaTime
        end
        if anim.progress > progressMax then
            anim.progress = progressMax
            anim.direction = -anim.direction
        elseif anim.progress < progressMin then
            anim.progress = progressMin
            anim.direction = -anim.direction
        end
        if anim.update < 0 then
            ped:setAnimation("ped", "car_crawloutrhs", 200, true, true, true, true)
            anim.update = 0.5
        end
        ped:setAnimationProgress("car_crawloutrhs", anim.progress)
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player", root, true)) do
        updatePedKnockoutState(player)
    end

    for i, ped in ipairs(getElementsByType("ped", root, true)) do
        updatePedKnockoutState(ped)
    end
end)
