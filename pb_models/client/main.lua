

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for name, model in pairs(ReplacedModels) do
        local txd = engineLoadTXD("models/"..name..".txd")
        engineImportTXD(txd, model)
        local dff = engineLoadDFF("models/"..name..".dff")
        engineReplaceModel(dff, model)
    end
end)
