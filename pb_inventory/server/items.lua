function isItem(item)
    return type(item) == "table" and Items[item.name]
end

function createItem(name, count, vars)
    local itemClass = Items[name]
    if not itemClass then
        outputDebugString("Could not create weapon '" .. tostring(name) .. "'. No such class")
        return
    end
    count = tonumber(count) or 1
    if not itemClass.stackable then
        count = 1
    end
    local instance = {
        name  = name,
        count = count
    }
    if itemClass.vars then
        for name, value in pairs(itemClass.vars) do
            instance[name] = value
        end
    end
    if vars then
        for name, value in pairs(vars) do
            instance[name] = value
        end
    end
    return instance
end

function isItemWeapon(item)
    if not isItem(item) then
        return
    end
    local itemClass = Items[item.name]
    return not not string.find(itemClass.category, "weapon")
end

function isItemEquipment(item)
    return false
end
