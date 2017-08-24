function isResourceRunning(resName)
    local res = getResourceFromName(resName)
    return (res) and (getResourceState(res) == "running")
end

function isItem(item)
    return not not (type(item) == "table" and Items[item.name])
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

function getItemWeight(item)
    if not isItem(item) then
        return 0
    end
    local itemWeight = Items[item.name].weight or 0
    local itemCount = item.count or 0
    return itemWeight * itemCount
end
