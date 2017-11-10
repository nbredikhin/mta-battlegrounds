local pedPosition = Vector3(148.075, -82.624, 1001.805)
local previewPed

local playerClothes = {}
local clothesLayers = {
    "clothes_head",
    "clothes_shirt",
    "clothes_pants",
    "clothes_shoes",
}

function createPreviewPed()
    if isElement(previewPed) then
        return
    end
    previewPed = createPed(235, pedPosition, 150)
    previewPed.frozen = true
    previewPed:setAnimation("CLOTHES", "CLO_Pose_Loop", -1, true, false)
    previewPed.dimension = localPlayer.dimension
    previewPed.interior = localPlayer.interior

    resetClothesPreview()
end

function hasPlayerClothes(name)
    if not name then
        return false
    end
    return not not playerClothes[name]
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
    if isElement(previewPed) then
        destroyElement(previewPed)
    end
end

function getPreviewPed()
    return previewPed
end
