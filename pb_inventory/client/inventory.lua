local clientInventory = {}

------------------------
-- Глобальные функции --
------------------------

-----------------------
-- Обработка событий --
-----------------------

addEvent("onClientInventoryUpdate", true)
addEventHandler("onClientInventoryUpdate", resourceRoot, function (items)
    if type(items) == "table" then
        clientInventory = items
    else
        clientInventory = {}
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    triggerServerEvent("onPlayerRequireInventory", resourceRoot)
end)
