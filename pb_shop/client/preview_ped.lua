local pedPosition = Vector3(148.075, -82.624, 1001.805)
local previewPed

function createPreviewPed()
    if isElement(previewPed) then
        return
    end
    previewPed = createPed(0, pedPosition, 150)
    previewPed.frozen = true
    previewPed:setAnimation("CLOTHES", "CLO_Pose_Loop", -1, true, false)
    previewPed.dimension = localPlayer.dimension
    previewPed.interior = localPlayer.interior

    previewPed:setData("clothes_head",  localPlayer:getData("clothes_head"))
    previewPed:setData("clothes_shirt", localPlayer:getData("clothes_shirt"))
    previewPed:setData("clothes_pants", localPlayer:getData("clothes_pants"))
    previewPed:setData("clothes_shoes", localPlayer:getData("clothes_shoes"))
end

function destroyPreviewPed()
    if isElement(previewPed) then
        destroyElement(previewPed)
    end
end

function getPreviewPed()
    return previewPed
end
