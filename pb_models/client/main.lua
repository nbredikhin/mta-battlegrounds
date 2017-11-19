local function getPath(name, ext)
    if name and OverwriteFiles[name] then
        if OverwriteFiles[name][ext] then
            return "models/"..OverwriteFiles[name][ext].."."..ext
        end
    end
    return "models/"..name.."."..ext
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for name, model in pairs(ReplacedModels) do
        local pathTXD = getPath(name, "txd")
        if ModelPaths[pathTXD] then
            local txd = engineLoadTXD(getFile(pathTXD))
            engineImportTXD(txd, model)
        end
        local pathDFF = getPath(name, "dff")
        if ModelPaths[pathDFF] then
            local dff = engineLoadDFF(getFile(pathDFF))
            engineReplaceModel(dff, model)
        end
        local pathCOL = getPath(name, "col")
        if ModelPaths[pathCOL] then
            local col = engineLoadCOL(getFile(pathCOL))
            engineReplaceCOL(col, model)
        end
    end
end)
