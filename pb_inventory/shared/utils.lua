weaponModels = {
    [1] = 331,
    [2] = 333,
    [3] = 334,
    [4] = 335,
    [5] = 336,
    [6] = 337,
    [7] = 338,
    [8] = 339,
    [9] = 341,
    [22] = 346,
    [23] = 347,
    [24] = 348,
    [25] = 349,
    [26] = 350,
    [27] = 351,
    [28] = 352,
    [29] = 353,
    [32] = 372,
    [30] = 355,
    [31] = 356,
    [33] = 357,
    [34] = 358,
    [35] = 359,
    [36] = 360,
    [37] = 361,
    [38] = 362,
    [16] = 342,
    [17] = 343,
    [18] = 344,
    [39] = 363,
    [41] = 365,
    [42] = 366,
    [43] = 367,
    [10] = 321,
    [11] = 322,
    [12] = 323,
    [14] = 325,
    [15] = 326,
    [44] = 368,
    [45] = 369,
    [46] = 371,
    [40] = 364
}

FirearmsWeapons = {
    [30] = true
}

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
    if not isItem(item) then
        return
    end
    local itemClass = Items[item.name]
    return itemClass.category == "helmet" or itemClass.category == "armor" or itemClass.category == "backpack"
end

function getItemWeight(item)
    if not isItem(item) then
        return 0
    end
    local itemWeight = Items[item.name].weight or 0
    local itemCount = item.count or 0
    return itemWeight * itemCount
end

function table.copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.copy(orig_key)] = table.copy(orig_value)
        end
        setmetatable(copy, table.copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function getWeaponNameFromId(id)
    for name, itemClass in pairs(Items) do
        if itemClass.weaponId == id then
            return itemClass.readableName
        end
    end
end
