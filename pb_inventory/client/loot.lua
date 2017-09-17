local lootColshape
local colshapeItems = {}

addEventHandler("onClientPreRender", root, function ()
    colshapeItems = {}

    lootColshape.position = localPlayer.position
    lootColshape.dimension = localPlayer.dimension
    -- Лут вокруг не будет отображаться, если игрок находится в автомобиле
    if localPlayer.vehicle or localPlayer.dead then
        return
    end

    for i, element in ipairs(lootColshape:getElementsWithin("object")) do
        if element.dimension == localPlayer.dimension then
            local item = element:getData("loot_item")
            local name = element:getData("loot_name")
            if item then
                if item.name and Items[item.name] then
                    table.insert(colshapeItems, item)
                end
            else
                local items = element:getData("loot_items")
                if items then
                    if name then
                        table.insert(colshapeItems, name)
                    end
                    for name, item in pairs(items) do
                        if item.name and Items[item.name] then
                            table.insert(colshapeItems, item)
                        end
                    end
                end
            end
        end
    end
end)

function getLootItems()
    return colshapeItems
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    lootColshape = createColSphere(0, 0, 0, Config.minLootDistance)
end)
