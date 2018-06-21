------------------------------------
-- Действия игрока над инвентарём --
------------------------------------

local actionHandlers = {}

-----------------------
-- Локальные функции --
-----------------------

--------------------------
-- Обработчики действий --
--------------------------

-- Поднять вещь, лежащую рядом в виде лута
actionHandlers["pickup_item"] = function (inventory, name)

end

-- Выбросить вещь из рюкзака на землю
actionHandlers["drop_item"] = function (inventory, name)

end

-- Перемещение вещи между рюкзаком и слотами (одежды, оружия и т. д.)
actionHandlers["move_item"] = function (inventory, moveType, name)

end

------------------------
-- Глобальные функции --
------------------------

-----------------------
-- Обработка событий --
-----------------------

addEvent("onPlayerInventoryAction", true)
addEventHandler("onPlayerInventoryAction", resourceRoot, function (actionName, ...)
    if not actionName then
        return
    end

    local inventory = getInventory(client)
    if not inventory then
        return
    end

    if actionHandlers[actionName] then
        actionHandlers[actionName](inventory, ...)
    end
end)
