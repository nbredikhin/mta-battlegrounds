local isActive = false

local pedPosition = Vector3(132.785, 27.811, 1.289)

local playerPed

local localPlayerClothes = {}

local cameraLookAt = Vector3()
local targetLookAt = Vector3()
local cameraFOV = 70
local targetFOV = 70

local function createLobbyPed(position)
    local ped = createPed(235, position, -40)
    ped.frozen = true
    ped.dimension = localPlayer.dimension
    setPedAnimation(ped, "ped", "IDLE_HBHB", -1, true, false)
    updatePedClothes(ped, localPlayer)
    return ped
end

function updatePedClothes(ped, player)
    if isElement(ped) and isElement(player) then
        for i, name in ipairs(exports.pb_clothes:getClothesLayers() or {}) do
            ped:setData("clothes_"..name, player:getData("clothes_"..name))
        end
    end
end

addEventHandler("onClientPreRender", root, function (dt)
    if not isVisible() then
        return
    end
    setCameraMatrix(playerPed.matrix:transformPosition(0.5, 3.7, 0.2), cameraLookAt, 0, cameraFOV)

    cameraLookAt = cameraLookAt + (targetLookAt - cameraLookAt) * dt * 0.0035
    cameraFOV = cameraFOV + (targetFOV - cameraFOV) * dt * 0.003
end)

function resetCamera()
    cameraLookAt = playerPed.position + Vector3(0, 0, 0.2)
    targetLookAt = playerPed.position + Vector3(0, 0, 0.2)
    cameraFOV = 70
    targetFOV = 70
end

function getLocalPlayerPed()
    return playerPed
end

function setClothesCamera(active)
    if not active then
        targetLookAt = playerPed.position + Vector3(0, 0, 0.3)
        targetFOV = 70
    else
        targetLookAt = playerPed.matrix:transformPosition(-1.5, -2, -0.05)
        targetFOV = 58
    end
end

function startSkinSelect()
    if isActive then
        return
    end
    isActive = true

    localPlayer.alpha = 0
    -- localPlayer.frozen = true
    -- localPlayer.position = pedPosition - Vector3(0, 0, 10)

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
