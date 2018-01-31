-- 1004,1005,1006,1051,1011,1012,1013,1017,1024,1026,1027,1030,1031,1032,1033,1035,1036,1038,1039,1040,1041,1042,1043,1044,1047,1048,1062,1052,1053,1054,1055,1056,1057,1061,
-- 1063,1067,1068,1088,

ReplacedModels = {
    backpack1 = 1851,
    backpack2 = 1852,
    backpack3 = 1853,

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

    -- loot_backpack1 = 1063,
    -- loot_backpack2 = 1067,
    -- loot_backpack3 = 1068,

    -- loot_armor1 = 1051,
    -- loot_armor2 = 1011,
    -- loot_armor3 = 1012,

    -- ammo_9mm = 1013,
    -- ammo_762mm = 1017,
    -- ammo_556mm = 1024,
    -- ammo_12gauge = 1026,
    -- ammo_45 = 1027,

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
    loot_backpack1 =  { txd = "backpack_small" },
    loot_backpack2 = { txd = "backpack_medium" },
    loot_backpack3 =  { txd = "backpack_large" },
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
