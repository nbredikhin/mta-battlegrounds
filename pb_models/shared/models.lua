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

    -- loot_backpack_small = 1862,
    -- loot_backpack_medium = 1863,
    -- loot_backpack_large = 1864,

    -- loot_armor1 = 1865,
    -- loot_armor2 = 1866,
    -- loot_armor3 = 1867,

    -- ammo_9mm = 1868,
    -- ammo_762mm = 1869,
    -- ammo_556mm = 1870,
    -- ammo_12gauge = 1871,
    -- ammo_45 = 1872,

    swburbhaus01_open = 3307,
    swburbhaus02_open = 3306,
    swburbhaus03_open = 3308,
    swburbhaus04_open = 3309,

    -- Шапки
    mheadbr01 = 1873,
    mheadbr02 = 1874,
    mheadc    = 1875,
    mheadd01  = 1876,
    mheadd02  = 1877,
    mheadh    = 1878,
    uganda    = 1879,
    -- Волосы
    hair1    = 1880,
    hair2    = 1881,
    hair3    = 1882,
    hair4    = 1899,
    hair5    = 1900,
    hair6    = 1901,
    hair7    = 1902,
    hair8    = 1903,
}

OverwriteFiles = {
    loot_backpack_small =  { txd = "backpack_small" },
    loot_backpack_medium = { txd = "backpack_medium" },
    loot_backpack_large =  { txd = "backpack_large" },
    loot_armor1 = { txd = "armor1" },
    loot_armor2 = { txd = "armor2" },
    loot_armor3 = { txd = "armor3" },
    swburbhaus02_open = { txd = "swburbhaus01_open" },
    swburbhaus03_open = { txd = "swburbhaus01_open" },
    swburbhaus04_open = { txd = "swburbhaus01_open" },
    ammo_762mm = { txd = "ammo_9mm" },
    ammo_556mm = { txd = "ammo_9mm" },
    ammo_12gauge = { txd = "ammo_9mm" },
    ammo_45 = { txd = "ammo_9mm" },
    hair2 = { txd = "hair1" },
    hair3 = { txd = "hair1" },
    hair4 = { txd = "hair1" },
    hair5 = { txd = "hair1" },
    hair6 = { txd = "hair1" },
    hair7 = { txd = "hair1" },
    hair8 = { txd = "hair1" },
}

function getReplacedModel(name)
    if not name then
        return
    end
    return ReplacedModels[name]
end
