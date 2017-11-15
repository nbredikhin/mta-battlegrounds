local isActive = false

local pedPosition = Vector3(5157.4, -944, 37.5)

local playerPed

local localPlayerClothes = {}

local cameraLookAt = Vector3()
local targetLookAt = Vector3()

local function createLobbyPed(position)
    local ped = createPed(235, position, 150)
    ped.frozen = true
    ped.dimension = localPlayer.dimension
    setPedAnimation(ped, "ped", "IDLE_HBHB", -1, true, false)
    updatePedClothes(ped, localPlayer)
    return ped
end

function updatePedClothes(ped, player)
    if isElement(ped) and isElement(player) then
        ped:setData("clothes_head", player:getData("clothes_head"))
        ped:setData("clothes_shirt", player:getData("clothes_shirt"))
        ped:setData("clothes_pants", player:getData("clothes_pants"))
        ped:setData("clothes_shoes", player:getData("clothes_shoes"))
    end
end

setTimer(function ()
    if isElement(playerPed) then
        setPedLookAt(playerPed, playerPed.matrix:transformPosition(-2, 4, 1), -1, 1000)
    end
end, 1000, 0)

addEventHandler("onClientPreRender", root, function (dt)
    if not isVisible() then
        return
    end
    setCameraMatrix(Vector3(5155.76, -945.65, 38.2), cameraLookAt, 0, 90)

    cameraLookAt = cameraLookAt + (targetLookAt - cameraLookAt) * dt * 0.0035
end)

function resetCamera()
    cameraLookAt = playerPed.position + Vector3(0, 0, 0.3)
    targetLookAt = playerPed.position + Vector3(0, 0, 0.3)
end

function getLocalPlayerPed()
    return playerPed
end

function setClothesCamera(active)
    if not active then
        targetLookAt = playerPed.position + Vector3(0, 0, 0.3)
    else
        targetLookAt = playerPed.position + Vector3(2, 0, 0)
    end
end

function startSkinSelect()
    if isActive then
        return
    end
    isActive = true

    localPlayer.alpha = 0
    localPlayer.frozen = true
    localPlayer.position = pedPosition - Vector3(0, 0, 10)

    playerPed = createLobbyPed(pedPosition)
    localPlayer:setData("skin", 235)

    resetCamera()
end

function stopSkinSelect()
    if not isActive then
        return
    end
    isActive = false

    if isElement(playerPed) then
        destroyElement(playerPed)
    end

    localPlayer.alpha = 255
    localPlayer.frozen = false

    setCameraTarget(localPlayer)
end
