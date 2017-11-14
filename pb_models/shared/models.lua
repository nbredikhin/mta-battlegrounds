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
    pan   = 321,
    crowbar = 333,
    machete = 339,

    lobby = 2288,

    box = 1860,
    box_parachute = 1861,
}

function getItemModel(name)
    if not name then
        return
    end
    return ReplacedModels[name]
end
