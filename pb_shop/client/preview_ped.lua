local pedPosition = Vector3(148.075, -82.624, 1001.805)
local previewPed

local playerClothes = {}
local clothesLayers = {
    "clothes_head",
    "clothes_body",
    "clothes_jacket",
    "clothes_legs",
    "clothes_feet",
    "clothes_hat",
}

local playerInventory = {}

addEvent("onClientInventoryUpdated", true)
local function handleInventoryUpdated()
    playerInventory = exports.pb_accounts:getInventory()
end

function createPreviewPed()
    if isElement(previewPed) then
        return
    end
    previewPed = createPed(235, pedPosition, 250)
    previewPed.frozen = true
    previewPed:setAnimation("CLOTHES", "CLO_Pose_Loop", -1, true, false)
    previewPed.dimension = localPlayer.dimension
    previewPed.interior = localPlayer.interior

    resetClothesPreview()
    playerInventory = exports.pb_accounts:getInventory()

    addEventHandler("onClientInventoryUpdated", root, handleInventoryUpdated)
end

function hasPlayerClothes(name)
    if not name then
        return false
    end
    return not not playerInventory[name]
end

function resetClothesPreview()
    playerClothes = {}
    for i, name in ipairs(clothesLayers) do
        local clothes = localPlayer:getData(name)
        if clothes then
            playerClothes[clothes] = true
        end
        previewPed:setData(name, clothes)
    end
end

function previewClothes(name)
    exports.pb_clothes:addPedClothes(previewPed, name)
end

function destroyPreviewPed()
    removeEventHandler("onClientInventoryUpdated", root, handleInventoryUpdated)
    if isElement(previewPed) then
        destroyElement(previewPed)
    end
end

function getPreviewPed()
    return previewPed
end
