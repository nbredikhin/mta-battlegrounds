local itemsAttach = {
    backpack = {
        bone = 4,
        x = 0,
        y = -0.15,
        z = -0.15,
        rx = -5,
        ry = 0,
        rz = 0
    }
}

local attachedObjects = {}

function updatePlayerWearingItems(player)
    if not isResourceRunning("bone_attach") then
        return
    end
    if not attachedObjects[player] then
        attachedObjects[player] = {}
    end

    for name, attach in pairs(itemsAttach) do
        local object = attachedObjects[player][name]
        local model = player:getData("wear_"..tostring(name))
        iprint(model)
        if model and not isElement(object) then
            object = createObject(model, player.position)
            attachedObjects[player][name] = object
            object:setCollisionsEnabled(false)
            exports.bone_attach:attachElementToBone(object, player, 3,
                attach.x, attach.y, attach.z,
                attach.rx, attach.ry, attach.rz)
        end
    end
end
