function instantiateLootItem(item, position)
    local object = createObject(1575, position - Vector3(0, 0, 0.8))
    object:setCollisionsEnabled(false)

    object:setData("loot_item", item)
end

function instantiateLootInventory(inventory, name, position)
    local items = {}
    local object = createObject(2358, position - Vector3(0, 0, 0.8))
    object:setCollisionsEnabled(false)
    object.scale = 1.3

    for name, item in pairs(inventory) do
        table.insert(items, item)
    end

    object:setData("loot_items", items)
    object:setData("loot_name", name)
end
