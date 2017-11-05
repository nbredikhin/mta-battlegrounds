local isActive = false

local pedPosition = Vector3(5157.4, -944, 37.5)

local skins = {235}
local skinIndex = 1
local playerPed

local cameraLookAt = Vector3()
local targetLookAt = Vector3()

local function createLobbyPed(position)
    local ped = createPed(skins[1], position, 150)
    ped:setData("clothes_head", localPlayer:getData("clothes_head"))
    ped:setData("clothes_shirt", localPlayer:getData("clothes_shirt"))
    ped:setData("clothes_pants", localPlayer:getData("clothes_pants"))
    ped:setData("clothes_shoes", localPlayer:getData("clothes_pants"))
    ped.frozen = true
    ped.dimension = localPlayer.dimension
    setPedAnimation(ped, "ped", "IDLE_HBHB", -1, true, false)
    return ped
end

local function updateSkin()
    playerPed.model = 235
end

setTimer(function ()
    if isElement(playerPed) then
        setPedLookAt(playerPed, playerPed.matrix:transformPosition(-2, 4, 1), -1, 1000)
    end
end, 1000, 0)

function changeSkin(delta)
    updateSkin()
    localPlayer:setData("skin", playerPed.model)
end

local function handleKey(key, isDown)
    if not isActive or not isDown then
        return
    end
end

addEventHandler("onClientPreRender", root, function (dt)
    setCameraMatrix(Vector3(5155.76, -945.65, 38.2), cameraLookAt, 0, 90)

    cameraLookAt = cameraLookAt + (targetLookAt - cameraLookAt) * dt * 0.0035
end)

function resetCamera()
    cameraLookAt = playerPed.position + Vector3(0, 0, 0.3)
    targetLookAt = playerPed.position + Vector3(0, 0, 0.3)
end

function addPedClothes(item)
    local itemClass = exports.pb_accounts:getItemClass(item.name)
    if not itemClass then
        return
    end
    exports.pb_clothes:addPedClothes(playerPed, itemClass.clothes)
    exports.pb_clothes:addPedClothes(localPlayer, itemClass.clothes, true)
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

    addEventHandler("onClientKey", root, handleKey)
    resetCamera()
    changeSkin(0)
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

    removeEventHandler("onClientKey", root, handleKey)

    setCameraTarget(localPlayer)
end
