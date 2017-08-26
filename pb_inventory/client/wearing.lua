local itemsAttach = {
    backpack = {
        bone = 4,
        x = 0,
        y = -0.05,
        z = 0.1,
        rx = -5,
        ry = 0,
        rz = 180
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

        if model then
            if not isElement(object) then
                object = createObject(model, player.position)
            end
            attachedObjects[player][name] = object
            object:setCollisionsEnabled(false)
            object.scale = 1
            exports.bone_attach:attachElementToBone(object, player, 3,
                attach.x, attach.y, attach.z,
                attach.rx, attach.ry, attach.rz)
        elseif isElement(object) then
            destroyElement(object)
        end
    end
end
