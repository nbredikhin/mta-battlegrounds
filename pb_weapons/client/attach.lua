local hideModels = {
    355,
    356,
    357,
    358,
}

local defaultAttachOffset = {
    x = -0.02,
    y = 0.045,
    z = 0.05,
    rx = -84,
    ry = 150,
    rz = -30,

    bone = 12
}

local attachedWeapons = {}

local function updatePlayerAttachedWeapon(player)
    if not isElement(player) then
        return
    end

    setPlayerAttachedWeapon(player, player:getData("weaponName"))
end

function setWeaponModelVisible(visible)
    if attachedWeapons[localPlayer] then
        if visible then
            attachedWeapons[localPlayer].scale = 1
        else
            attachedWeapons[localPlayer].scale = 0
        end
    end
end

function setPlayerAttachedWeapon(player, name)
    if not isElement(player) then
        return
    end
    if isElement(attachedWeapons[player]) then
        exports.bone_attach:detachElementFromBone(attachedWeapons[player])
        destroyElement(attachedWeapons[player])
    end
    attachedWeapons[player] = nil
    if not name or not WeaponsTable[name] then
        return
    end
    local weapon = WeaponsTable[name]
    if not weapon.model then
        return
    end
    local attach = weapon.offset

    if not attach then
        attach = defaultAttachOffset
    else
        if not attach.bone then attach.bone = defaultAttachOffset.bone end
    end

    local object = createObject(weapon.model, player.position)
    exports.bone_attach:attachElementToBone(object, player, attach.bone,
        attach.x, attach.y, attach.z,
        attach.rx, attach.ry, attach.rz)
    attachedWeapons[player] = object
end

addEventHandler("onClientElementStreamIn", root, function ()
    if source.type == "player" then
        updatePlayerAttachedWeapon(source)
    end
end)

addEventHandler("onClientElementStreamOut", root, function ()
    if source.type == "player" then
        setPlayerAttachedWeapon(source, nil)
    end
end)

addEventHandler("onClientElementDestroy", root, function ()
    if source.type == "player" then
        setPlayerAttachedWeapon(source, nil)
    end
end)

addEvent("updatePlayerAttachedWeapon", true)
addEventHandler("updatePlayerAttachedWeapon", root, function (player)
    if isElementStreamedIn(player) then
        updatePlayerAttachedWeapon(player)
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    local txd = engineLoadTXD("assets/models/box.txd")
    local dff = engineLoadDFF("assets/models/box.dff")
    for i, model in ipairs(hideModels) do
        engineImportTXD(txd, model)
        engineReplaceModel(dff, model)
    end
end)
