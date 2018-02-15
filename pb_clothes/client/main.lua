local clothesModel = 235
local layerNames = {
    "head",
    "body",
    "jacket",
    "legs",
    "feet",
    "gloves",
    "hat",
    "hair",
    "mask",
    "glasses"
}

local bodyParts = {
    "body1",
    "body2",
    "wrist",
    "elbow",
    "forearm",
    "legsbody1",
    "legsbody2",
    "legsbody3",
}

function getClothesLayers()
    return layerNames
end

-- Загруженные части одежды
local loadedMaterials = {}
local attachedObjects = {}
local attachedShaders = {}

function getPlayerAttachedObjects(player)
    return attachedObjects[player]
end

function unloadPedClothes(ped, omitLog)
    if not isElement(ped) or (ped.type ~= "player" and ped.type ~= "ped") then
        return false
    end

    if attachedShaders[ped] then
        for i, data in ipairs(attachedShaders[ped]) do
            if isElement(data[1]) then
                engineRemoveShaderFromWorldTexture(data[1], data[2], data[3] or ped)
            end
        end
    end
    if ped and attachedObjects[ped] then
        for layer, object in pairs(attachedObjects[ped]) do
            if isElement(object) then
                object.scale = 0
            end
        end
    end
    attachedShaders[ped] = nil

    if not omitLog then
        outputDebugString("[CLOTHES] Unloaded ped clothes "..tostring(ped))
    end
end

function destroyPedAttaches(ped)
    if ped and attachedObjects[ped] then
        for layer, object in pairs(attachedObjects[ped]) do
            if isElement(object) then
                destroyElement(object)
            end
        end
    end
end

function reloadClothes()
    local startTime = getTickCount()
    local elementsCount = 0
    local pedsCount = 0
    for ped in pairs(attachedObjects) do
        pedsCount = pedsCount + 1
        unloadPedClothes(ped, true)
    end
    attachedObjects = {}

    local materialsCount = 0
    for i, material in ipairs(loadedMaterials) do
        if isElement(material.shader) then
            destroyElement(material.shader)
        end
        if isElement(material.texture) then
            destroyElement(material.texture)
        end
        materialsCount = materialsCount + 1
    end
    loadedMaterials = {}
    outputDebugString("[CLOTHES] Reload clothes. Destroyed "..materialsCount.." material(s) on "..pedsCount.." ped(s).")

    local loadedElements = 0
    for i, player in ipairs(getElementsByType("player")) do
        loadPedClothes(player, true)
    end

    for i, ped in ipairs(getElementsByType("ped")) do
        loadPedClothes(ped, true)
    end
    outputDebugString("[CLOTHES] Reload total time: "..(getTickCount()-startTime).."ms")
end

local function replaceElementMaterial(element, material, texturePath)
    if not loadedMaterials[texturePath] then
        local elementType = element.type
        if element.type == "player" then
            elementType = "ped"
        end
        loadedMaterials[texturePath] = {
            texture = dxCreateTexture(texturePath, "argb", false),
            shader  = dxCreateShader("assets/shaders/replace.fx", 0, 0, false, elementType)
        }
        loadedMaterials[texturePath].shader:setValue("gTexture", loadedMaterials[texturePath].texture)
    end

    local shader = loadedMaterials[texturePath].shader
    engineApplyShaderToWorldTexture(shader, material, element)
    return shader
end

local function getTexturePath(texture)
    return "assets/textures/"..texture
end

function loadPedClothes(ped)
    if not isElement(ped) or not ped.streamedIn or (ped.type ~= "ped" and ped.type ~= "player") then
        return false
    end

    local loadStartTime = getTickCount()

    unloadPedClothes(ped, true)
    if not attachedObjects[ped] then
        attachedObjects[ped] = {}
    end
    attachedShaders[ped] = {}

    -- Проверка валидности одежды
    local pedClothes = {}
    for i, layer in ipairs(layerNames) do
        local name = ped:getData("clothes_"..layer)
        if name and ClothesTable[name] then
            pedClothes[layer] = name
        end

        local tmp = ped:getData("tmp_clothes_"..layer)
        if tmp and ClothesTable[tmp] then
            pedClothes[layer] = tmp
        end
    end
    -- Части тела, которые должны быть скрыты
    local hideParts = {}
    -- Части тела, для которых игнорируется скрытие
    local showParts = {}
    -- Цвет кожи, определяется головой
    local bodyTextureName = "whitebody"
    if pedClothes.head and ClothesTable[pedClothes.head].body then
        bodyTextureName = ClothesTable[pedClothes.head].body
    end

    bodyTextureName = "assets/textures/skin/"..bodyTextureName..".png"
    for layer, name in pairs(pedClothes) do
        local clothesTable = ClothesTable[name]
        if clothesTable.model then
            local model = exports.pb_models:getReplacedModel(clothesTable.model)

            -- Создание и настройка объекта
            local attach = clothesTable.attach or Config.attachOffsets[layer]
            local object
            if attachedObjects[ped][layer] then
                object = attachedObjects[ped][layer]
                object.model = model
            else
                object = createObject(model, ped.position)
                object:setCollisionsEnabled(false)
            end
            object.dimension = ped.dimension
            object.interior = ped.interior
            object.scale = attach.scale or 1

            -- Прикрепление объекта через bone_attach
            exports.bone_attach:attachElementToBone(object, ped, attach.bone,
                attach.x, attach.y, attach.z,
                attach.rx, attach.ry, attach.rz)
            attachedObjects[ped][layer] = object

            -- Если есть материал, то наложить текстуру
            if clothesTable.material then
                local shader = replaceElementMaterial(object, clothesTable.material, getTexturePath(clothesTable.texture))
                table.insert(attachedShaders[ped], {shader, clothesTable.material, object})
            end

            if layer == "hair" and (pedClothes.hat or (pedClothes.mask and ClothesTable[pedClothes.mask].model == "mask1")) then
                object.scale = 0
            end
            object:setData("scale", object.scale)
            if ped:getData("isInPlane") then
                object.scale = 0
            end

            setTimer(function ()
                if isElement(object) then
                    object.doubleSided = true
                end
            end, 50, 1)
        elseif clothesTable.material then
            if layer == "body" then
                for i = 1, 4 do
                    local texture = getTexturePath(clothesTable.texture)
                    if i == 1 or i == 4 then
                        texture = bodyTextureName
                    end
                    if not (i == 2 and pedClothes.jacket) and not (i == 1 and pedClothes.jacket and clothesTable.material == "mbodyc") then
                        local material = ClothesTable[name].material .. "p"..i
                        local shader = replaceElementMaterial(ped, material, texture)
                        table.insert(attachedShaders[ped], {shader, material})
                    end
                end
            else
                local shader = replaceElementMaterial(ped, clothesTable.material, getTexturePath(clothesTable.texture))
                table.insert(attachedShaders[ped], {shader, clothesTable.material})
            end
        end

        if clothesTable.hide then
            for name in pairs(clothesTable.hide) do
                hideParts[name] = true
            end
        end

        if clothesTable.show then
            for name in pairs(clothesTable.show) do
                showParts[name] = true
            end
        end
    end
    -- Скрываем части тела в зависимости от надетой одежды
    if pedClothes.body then
        hideParts.body2 = true
    end
    if pedClothes.body or pedClothes.jacket then
        hideParts.body1 = true
    end
    if pedClothes.legs then
        hideParts.legsbody1 = true
        hideParts.legsbody2 = true
    end
    if pedClothes.feet then
        hideParts.legsbody3 = true
    end

    for name in pairs(showParts) do
        hideParts[name] = nil
    end

    for i, name in ipairs(bodyParts) do
        if not hideParts[name] then
            local shader = replaceElementMaterial(ped, name, bodyTextureName)
            table.insert(attachedShaders[ped], {shader, name})
        end
    end

    if not omitLog then
        outputDebugString("[CLOTHES] Loaded ped clothes "..tostring(ped).."; Time: "..(getTickCount() - loadStartTime).."ms")
    end
end

addEventHandler("onClientElementStreamIn", root, function ()
    loadPedClothes(source)
end)

addEventHandler("onClientElementStreamOut", root, function ()
    unloadPedClothes(source)
end)

addEventHandler("onClientElementDestroy", root, function ()
    unloadPedClothes(source)
    destroyPedAttaches(source)
end)

addEventHandler("onClientPlayerQuit", root, function ()
    unloadPedClothes(source)
    destroyPedAttaches(source)
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        loadPedClothes(player)
    end

    for i, ped in ipairs(getElementsByType("ped")) do
        loadPedClothes(ped)
    end
end)

addEventHandler("onClientElementDataChange", root, function (dataName)
    if source.type ~= "player" and source.type ~= "ped" then
        return
    end
    if source ~= localPlayer and not isElementStreamedIn(source) then
        return
    end
    if string.find(dataName, "clothes_") then
        loadPedClothes(source)
    elseif dataName == "isInPlane" then
        if attachedObjects[source] then
            local hide = false
            if source:getData("isInPlane") then
                hide = true
            end
            for layer, element in pairs(attachedObjects[source]) do
                if element.type == "object" then
                    if hide then
                        element.scale = 0
                    else
                        element.scale = element:getData("scale")
                    end
                end
            end
        end
    end
end)
