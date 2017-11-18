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

    playermodel = 235,

    loot_backpack_small = 1862,
    loot_backpack_medium = 1863,
    loot_backpack_large = 1864,

    loot_armor1 = 1865,
    loot_armor2 = 1866,
    loot_armor3 = 1867,

    ammo_9mm = 1868,
    ammo_762mm = 1869,
    ammo_556mm = 1870,
    ammo_12gauge = 1871,
    ammo_45 = 1872,
}

OverwriteFiles = {
    loot_backpack_small =  { txd = "backpack_small" },
    loot_backpack_medium = { txd = "backpack_medium" },
    loot_backpack_large =  { txd = "backpack_large" },
    loot_armor1 = { txd = "armor1" },
    loot_armor2 = { txd = "armor2" },
    loot_armor3 = { txd = "armor3" },
}

function getItemModel(name)
    if not name then
        return
    end
    return ReplacedModels[name]
end
