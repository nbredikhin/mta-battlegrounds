local itemsAttach = {
    backpack = {
        bone = 3,
        x = 0,
        y = -0.07,
        z = 0.1,
        rx = -5,
        ry = 0,
        rz = 180
    },

    helmet = {
        bone = 1,
        x = 0,
        y = 0.05,
        z = 0.08,
        rx = 10,
        ry = 0,
        rz = 180
    },

    primary1 = {
        bone = 3,
        x = -0.15,
        y = -0.2,
        z = 0.2,
        rx = 10,
        ry = 90,
        rz = 60
    },

    primary2 = {
        bone = 3,
        x = 0.17,
        y = -0.2,
        z = 0.22,
        rx = -5,
        ry = 90,
        rz = 120
    },

    secondary = {
        bone = 4,
        x = 0.2,
        y = 0.1,
        z = 0.05,
        rx = 0,
        ry = 180,
        rz = 100
    }
}

local attachedObjects = {}

function removePlayerWearingItems(player)
    if not attachedObjects[player] then
        return
    end
    for name, attach in pairs(itemsAttach) do
        local object = attachedObjects[player][name]
        if isElement(object) then
            if isResourceRunning("bone_attach") then
                exports.bone_attach:detachElementFromBone(object)
            end
            destroyElement(object)
        end
    end
    attachedObjects[player] = nil
end

function updatePlayerWearingItems(player)
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
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
                object:setCollisionsEnabled(false)
                object.doubleSided = true
                exports.bone_attach:attachElementToBone(object, player, attach.bone,
                    attach.x, attach.y, attach.z,
                    attach.rx, attach.ry, attach.rz)
                attachedObjects[player][name] = object
            end
        else
            if isElement(object) then
                exports.bone_attach:detachElementFromBone(object)
                destroyElement(object)
                attachedObjects[player][name] = nil
            end
        end
    end
end

addEventHandler("onClientElementStreamIn", root, function ()
    updatePlayerWearingItems(source)
end)

addEventHandler("onClientElementStreamOut", root, function ()
    removePlayerWearingItems(source)
end)

addEventHandler("onClientElementDestroy", root, function ()
    removePlayerWearingItems(source)
end)

addEvent("updateWearableItems", true)
addEventHandler("updateWearableItems", resourceRoot, function (player)
    updatePlayerWearingItems(player)
end)

-- local testPlayer = createPed(46, Vector3 { x = 1739.095, y = -2506.986, z = 13.555 })
-- testPlayer:setData("wear_backpack", 1853)
-- testPlayer:setData("wear_helmet", 1856)
-- updatePlayerWearingItems(testPlayer)
-- setTimer(function ()
--     destroyElement(testPlayer)
-- end, 5000, 1)
