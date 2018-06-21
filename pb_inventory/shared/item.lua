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

function cloneItem(item)
    if not isItem(item) then
        return
    end
    return table.copy(item)
end

function getItemClass(itemOrName)
    if not itemOrName then
        return
    end
    local name
    if type(itemOrName) == "table" then
        name = itemOrName.name
    else
        name = itemOrName
    end
    if name then
        return Items[itemOrName]
    else
        return
    end
end

function isItem(item)
    return not not (type(item) == "table" and Items[item.name])
end

function getItemWeight(item)
    if not isItem(item) then
        return 0
    end
    local itemWeight = Items[item.name].weight or 0
    local itemCount = item.count or 0
    return itemWeight * itemCount
end
