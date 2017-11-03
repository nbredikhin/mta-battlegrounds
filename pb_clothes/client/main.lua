local skinId = 235
local layerNames = {
    "head",
    "shirt",
    "pants",
    "shoes"
}

local loadedClothes = {}
local loadedTextures = {}
local placeholderTexture = dxCreateTexture("assets/placeholder.png")

local function unloadPedClothes(ped)
    if not ped or not loadedClothes[ped] then
        return
    end
    for i, element in ipairs(loadedClothes[ped]) do
        if isElement(element) then
            destroyElement(element)
        end
    end
    loadedClothes[ped] = nil
end

local function getTexture(path)
    if not fileExists(path) then
        return placeholderTexture
    end
    local texture = loadedTextures[path]
    if not texture then
        texture = dxCreateTexture(path)
        loadedTextures[path] = texture
    end
    return texture
end

local function createClothesShader(ped, material, texture)
    local shader = dxCreateShader("assets/shaders/replace.fx", 0, 0, false, "ped")
    shader:setValue("gTexture", texture)
    engineApplyShaderToWorldTexture(shader, material, ped)
    return shader
end

function loadPedClothes(ped)
    if not ped then
        return
    end
    unloadPedClothes(ped)
    loadedClothes[ped] = {}
    local hideElbow = false
    for i, layer in ipairs(layerNames) do
        local name = ped:getData("clothes_" .. tostring(layer))
        if name and ClothesTable[name] and ClothesTable[name].layer == layer then
            if ClothesTable[name].hideElbow then
                hideElbow = true
            end
            local path = ClothesTable[name].path or "assets/clothes/"..layer.."/"..ClothesTable[name].material.."/"..name..".png"
            local texture = getTexture(path)
            local shader = createClothesShader(ped, ClothesTable[name].material or name, texture)
            table.insert(loadedClothes[ped], shader)
        end
    end
    if not hideElbow then
        table.insert(loadedClothes[ped], createClothesShader(ped, "elbow", getTexture("assets/elbow.png")))
    end
    -- createClothesShader(ped, "wrist", getTexture("assets/wrist.png"))
end

addEventHandler("onClientElementDataChange", root, function (dataName)
    if not isElementStreamedIn(source) then
        return
    end
    if string.find(dataName, "clothes_") then
        loadPedClothes(source)
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    local txd = engineLoadTXD("assets/models/playermodel.txd")
    engineImportTXD(txd, 235)
    local dff = engineLoadDFF("assets/models/playermodel.dff")
    engineReplaceModel(dff, 235)

    setElementDoubleSided(localPlayer, true)

    for i, player in ipairs(getElementsByType("player")) do
        loadPedClothes(player)
    end

    for i, ped in ipairs(getElementsByType("ped")) do
        loadPedClothes(ped)
    end
end)

function addPedClothes(ped, name, sync)
    if not isElement(ped) or type(name) ~= "string" then
        return
    end
    if not ClothesTable[name] then
        return
    end
    ped:setData("clothes_"..tostring(ClothesTable[name].layer), name, not not sync)
end

addCommandHandler("addclothes", function (cmd, name)
    addPedClothes(localPlayer, name, true)
end)

--srun for i = 1, 100 do     local ped = createPed(235, p.position + Vector3(i * 1, 0, 0)) mped(ped) end
--srun function mped() ped:setData("clothes_head", "head1") ped:setData("clothes_shirt", "mjacket") ped:setData("clothes_pants", "jeans") ped:setData("clothes_shoes", "sneakers") end
