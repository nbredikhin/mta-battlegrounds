local clientItems = {}

------------------------
-- Глобальные функции --
------------------------

-----------------------
-- Обработка событий --
-----------------------

addEvent("onClientInventoryUpdate", true)
addEventHandler("onClientInventoryUpdate", resourceRoot, function (items)
    if type(items) == "table" then
        clientItems = items
    else
        clientItems = {}
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    triggerServerEvent("onPlayerRequireInventory", resourceRoot)
end)
