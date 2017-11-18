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
        if fileExists(pathTXD) then
            local txd = engineLoadTXD(pathTXD)
            engineImportTXD(txd, model)
        end
        local pathDFF = getPath(name, "dff")
        if fileExists(pathDFF) then
            local dff = engineLoadDFF(pathDFF)
            engineReplaceModel(dff, model)
        end
        local pathCOL = getPath(name, "col")
        if fileExists(pathCOL) then
            local col = engineLoadCOL(pathCOL)
            engineReplaceCOL(col, model)
        end
    end
end)
