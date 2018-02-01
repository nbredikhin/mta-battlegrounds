local skinId = 235
local layerNames = {
    "head",
    "body",
    "jacket",
    "legs",
    "feet",
    "gloves",
    "hat",
    "hair"
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

local loadedClothes = {}
local loadedTextures = {}
local localHat = nil

function getLocalPlayerHat()
    return localHat
end

function reloadClothes()
    local startTime = getTickCount()
    local elementsCount = 0
    local pedsCount = 0
    for ped in pairs(loadedClothes) do
        pedsCount = pedsCount + 1
        for i, element in ipairs(loadedClothes[ped]) do
            if isElement(element) then
                destroyElement(element)
                elementsCount = elementsCount + 1
            end
        end
    end
    loadedClothes = {}

    local texturesCount = 0
    for i, texture in ipairs(loadedTextures) do
        if isElement(texture) then
            destroyElement(texture)
            texturesCount = texturesCount + 1
        end
    end
    loadedTextures = {}
    outputDebugString("[CLOTHES] Reload clothes. Destroyed "..texturesCount.." texture(s); "..elementsCount.." element(s) on "..pedsCount.." ped(s).")

    local loadedElements = 0
    for i, player in ipairs(getElementsByType("player")) do
        loadPedClothes(player, true)
    end

    for i, ped in ipairs(getElementsByType("ped")) do
        loadPedClothes(ped, true)
    end
    outputDebugString("[CLOTHES] Reload total time: "..(getTickCount()-startTime).."ms")
end

local function unloadPedClothes(ped, omitLog)
    if not ped or not loadedClothes[ped] then
        return
    end
    for i, element in ipairs(loadedClothes[ped]) do
        if isElement(element) then
            destroyElement(element)
        end
    end
    loadedClothes[ped] = nil

    if not omitLog then
        outputDebugString("[CLOTHES] Unloaded ped clothes "..tostring(ped))
    end
end

local function getTexture(path)
    if not fileExists(path) then
        return placeholderTexture
    end
    local texture = loadedTextures[path]
    if not texture then
        texture = dxCreateTexture(path, "dxt5", false)
        loadedTextures[path] = texture
    end

    return texture
end

local function createClothesShader(ped, material, texture)
    if not isElement(texture) then
        outputDebugString("Failed to load " .. material)
    end
    local elementType = "ped"
    if ped.type == "object" then
        elementType = "object"
    end
    local shader = dxCreateShader("assets/shaders/replace.fx", 0, 0, false, elementType)
    shader:setValue("gTexture", texture)
    if material then
        engineApplyShaderToWorldTexture(shader, material, ped)
    end
    return shader
end

function loadPedClothes(ped, omitLog)
    if not isElement(ped) or not ped.streamedIn or (ped.type ~= "ped" and ped.type ~= "player") then
        return
    end

    local startTime = getTickCount()
    unloadPedClothes(ped, true)
    loadedClothes[ped] = {}
    -- Наличие слоев одежды
    local hasJacket = ped:getData("clothes_jacket")
    hasJacket = not not ClothesTable[hasJacket]
    local hasShirt  = ped:getData("clothes_body")
    hasShirt = not not ClothesTable[hasShirt]
    local hasPants  = ped:getData("clothes_legs")
    hasPants = not not ClothesTable[hasPants]
    local hasShoes  = ped:getData("clothes_feet")
    hasShoes = not not ClothesTable[hasShoes]
    local hasHat  = ped:getData("clothes_hat")
    hasHat = not not ClothesTable[hasHat]
    local tmpHat = ped:getData("tmp_clothes_hat")
    if tmpHat and ClothesTable[tmpHat] then
        hasHat = true
    end
    -- Части тела, которые должны быть скрыты
    local hideParts = {}
    -- Части тела, для которых игнорируется скрытие
    local showParts = {}
    -- Цвет кожи, определяется головой
    local bodyTextureName = "whitebody"
    local head = ped:getData("clothes_head")
    if head and ClothesTable[head] and ClothesTable[head].body then
        bodyTextureName = ClothesTable[head].body
    end
    ped.doubleSided = false
    -- Текстура тела
    local bodyTexture = getTexture("assets/textures/skin/"..bodyTextureName..".png")
    local bodyShader = createClothesShader(ped, nil, bodyTexture)
    table.insert(loadedClothes[ped], bodyShader)
    if ped == localPlayer then
        localHat = nil
    end
    for i, layer in ipairs(layerNames) do
        local tmpName = ped:getData("tmp_clothes_"..layer)
        if tmpName then
            name = tmpName
        else
            name = ped:getData("clothes_"..layer)
        end
        if name and ClothesTable[name] then
            local texture
            if ClothesTable[name].texture then
                texture = getTexture("assets/textures/" .. ClothesTable[name].texture)
            end
            -- Если указана модель, то необходимо создать и прикрепить аттач
            if ClothesTable[name].model and (layer ~= "hair" or (layer == "hair" and not hasHat)) then
                local model = exports.pb_models:getReplacedModel(ClothesTable[name].model)
                local object = createObject(model, ped.position)
                object:setCollisionsEnabled(false)
                object.dimension = ped.dimension
                object.interior = ped.interior
                local attach = ClothesTable[name].attach or Config.attachOffsets[layer]
                object.scale = attach.scale or 1
                -- Прикрепление объекта через bone_attach
                exports.bone_attach:attachElementToBone(object, ped, attach.bone,
                    attach.x, attach.y, attach.z,
                    attach.rx, attach.ry, attach.rz)
                table.insert(loadedClothes[ped], object)

                -- Если есть материал, то наложить текстуру
                if ClothesTable[name].material then
                    local shader = createClothesShader(object, ClothesTable[name].material, texture)
                    table.insert(loadedClothes[ped], shader)
                end

                if ped == localPlayer and layer == "hat" then
                    localHat = object
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

            -- Если указан только материал, то наложить шейдер
            elseif ClothesTable[name].material then
                if layer == "body" then
                    for i = 1, 3 do
                        local useTexture = texture
                        if i == 1 then
                            useTexture = bodyTexture
                        end
                        if not (i == 2 and hasJacket) then
                            local material = ClothesTable[name].material .. "p"..i
                            if useTexture == bodyTexture then
                                engineApplyShaderToWorldTexture(bodyShader, material, ped)
                            else
                                local shader = createClothesShader(ped, material, useTexture)
                                table.insert(loadedClothes[ped], shader)
                            end
                        end
                    end
                else
                    local shader = createClothesShader(ped, ClothesTable[name].material, texture)
                    table.insert(loadedClothes[ped], shader)
                end
            end

            if ClothesTable[name].hide then
                for name in pairs(ClothesTable[name].hide) do
                    hideParts[name] = true
                end
            end

            if ClothesTable[name].show then
                for name in pairs(ClothesTable[name].show) do
                    showParts[name] = true
                end
            end
        end
    end
    if hasShirt then
        hideParts.body2 = true
    end
    if hasShirt or hasJacket then
        hideParts.body1 = true
    end
    if hasPants then
        hideParts.legsbody1 = true
        hideParts.legsbody2 = true
    end
    if hasShoes then
        hideParts.legsbody3 = true
    end

    for name in pairs(showParts) do
        hideParts[name] = nil
    end

    for i, name in ipairs(bodyParts) do
        if not hideParts[name] then
            engineApplyShaderToWorldTexture(bodyShader, name, ped)
        end
    end

    if not omitLog then
        outputDebugString("[CLOTHES] Loaded ped clothes "..tostring(ped)..". Elements: "..tostring(#loadedClothes[ped]).."; Time: "..(getTickCount() - startTime).."ms")
    end
end

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
        if loadedClothes[source] then
            local hide = false
            if source:getData("isInPlane") then
                hide = true
            end
            for i, element in ipairs(loadedClothes[source]) do
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

addEventHandler("onClientElementStreamIn", root, function ()
    loadPedClothes(source)
end)

addEventHandler("onClientElementStreamOut", root, function ()
    unloadPedClothes(source)
end)

addEventHandler("onClientElementDestroy", root, function ()
    unloadPedClothes(source)
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    setElementDoubleSided(localPlayer, true)

    for i, player in ipairs(getElementsByType("player")) do
        loadPedClothes(player)
    end

    for i, ped in ipairs(getElementsByType("ped")) do
        loadPedClothes(ped)
    end
end)

-- addCommandHandler("cl", function (cmd, name)
--     if not name then
--         for i, name in ipairs(layerNames) do
--             localPlayer:setData("clothes_"..name, false, true)
--         end
--     else
--         addPedClothes(localPlayer, name, true)
--     end
-- end)
