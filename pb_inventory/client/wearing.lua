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

    armor = {
        bone = 3,
        x = 0,
        y = 0.05,
        z = 0.06,
        rx = -5,
        ry = 0,
        rz = 180
    },

    helmet = {
        bone = 1,
        x = 0,
        y = 0.065,
        z = 0.055,
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
        x = 0.21,
        y = 0.1,
        z = 0.05,
        rx = 0,
        ry = 180,
        rz = 100
    },

    melee = {
        bone = 4,
        x = 0.1,
        y = 0.15, --z
        z = 0.15, --y
        rx = 90,
        ry = -60,
        rz = 0
    },

    grenade = {
        bone = 4,
        x = 0.18,
        y = -0.02,
        z = 0.07,
        rx = 90,
        ry = 90,
        rz = 80
    }
}

local overrideOffsets = {
    -- Helmet 1
    [1854] = {
        bone = 1,
        x = 0,
        y = 0.055,
        z = 0.08,
        rx = 10,
        ry = 0,
        rz = 180
    },
    -- Helmet 2
    [1855] = {
        bone = 1,
        x = 0,
        y = 0.055,
        z = 0.08,
        rx = 5,
        ry = 0,
        rz = 180
    },
    -- Armor 2
    [1858] = {
        bone = 3,
        x = 0,
        y = 0.055,
        z = 0.06,
        rx = 0,
        ry = 0,
        rz = 180
    },
    -- UZI
    [352] = {
        bone = 4,
        x = -0.2,
        y = 0.1,
        z = 0.05,
        rx = 0,
        ry = 180,
        rz = 80
    },
    --crowbar
    [333] = {
        bone = 4,
        x = 0.05,
        y = 0.15, --z
        z = 0.12, --y
        rx = 90,
        ry = -75,
        rz = -10
    }
}

local attachedObjects = {}

function getPlayerAttachedObject(player, name)
    if player and name then
        if attachedObjects[player] then
            return attachedObjects[player][name]
        end
    end
end

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
    if player.dimension ~= localPlayer.dimension then
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
                if name == "helmet" then
                    object.scale = 1.02
                elseif name == "armor" then
                    object.scale = 1.02
                end
                object:setCollisionsEnabled(false)
                object.doubleSided = true
                object.dimension = player.dimension
                if overrideOffsets[model] then
                    attach = overrideOffsets[model]
                end
                exports.bone_attach:attachElementToBone(object, player, attach.bone,
                    attach.x, attach.y, attach.z,
                    attach.rx, attach.ry, attach.rz)
                attachedObjects[player][name] = object
            else
                object.model = model
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
    if isElementStreamedIn(player) then
        updatePlayerWearingItems(player)
    end
end)

bindKey("mouse2", "down", function ()
    if localPlayer:getWeapon() == 34 then
        for name in pairs(itemsAttach) do
            local object = getPlayerAttachedObject(localPlayer, name)
            if isElement(object) then
                object.scale = 0
            end
        end
    end
end)

bindKey("mouse2", "up", function ()
    local object = getPlayerAttachedObject(localPlayer, "helmet")
    if isElement(object) then
        for name in pairs(itemsAttach) do
            local object = getPlayerAttachedObject(localPlayer, name)
            if isElement(object) then
                object.scale = 1
            end
        end
    end
end)
