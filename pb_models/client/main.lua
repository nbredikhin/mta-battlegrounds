

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for name, model in pairs(ReplacedModels) do
        if fileExists("models/"..name..".txd") then
            local txd = engineLoadTXD("models/"..name..".txd")
            engineImportTXD(txd, model)
        end
        if fileExists("models/"..name..".dff") then
            local dff = engineLoadDFF("models/"..name..".dff")
            engineReplaceModel(dff, model)
        end
        if fileExists("models/"..name..".col") then
            local col = engineLoadCOL("models/"..name..".col")
            engineReplaceCOL(col, model)
        end
    end
end)
