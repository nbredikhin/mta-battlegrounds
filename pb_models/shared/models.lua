ReplacedModels = {
    backpack_small = 1851,
    backpack_medium = 1852,
    backpack_large = 1853,

    helmet1 = 1854,
    helmet2 = 1855,
    helmet3 = 1856,

    armor1 = 1857,
    armor2 = 1858,
    armor3 = 1859,

    awm   = 358,
    m16a4 = 356,
}

function getItemModel(name)
    if not name then
        return
    end
    return ReplacedModels[name]
end
