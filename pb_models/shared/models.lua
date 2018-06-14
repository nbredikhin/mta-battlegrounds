-- 1004,1005,1006,1051,1011,1012,1026,1027,1030,1031,1032,1033,1035,1036,1038,1039,1040,1041,1042,1043,1044,1047,1048,1062,1052,1053,1054,1055,1056,1057,1061,
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

    -- awm   = 358,
    -- m16a4 = 356,
    -- pan   = 321,
    -- crowbar = 333,
    -- machete = 339,

    lobby = 2288,

    box = 1860,
    box_parachute = 1861,

    playermodel = 235,

    loot_backpack1 = 1862,
    loot_backpack2 = 1863,
    loot_backpack3 = 1864,

    loot_armor1 = 1865,
    loot_armor2 = 1866,
    loot_armor3 = 1867,

    loot_mghilie1 = 1868,
    loot_mghilie2 = 1869,

    loot_painkiller = 1870,
    loot_medkit = 1871,
    loot_energy_drink = 1872,
    loot_bandage = 1013,
    loot_adrenaline_syringe = 1017,
    loot_first_aid = 1024,

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

    loot_ammo_9mm     = 1904,
    loot_ammo_12gauge = 1905,
    loot_ammo_45acp   = 1906,
    loot_ammo_556mm   = 1907,
    loot_ammo_762mm   = 1908,
    loot_ammo300      = 1909,

    -- Маски
    mask1 = 1910,
    mask2 = 1911,
    mask3 = 1912,
    mask4 = 1913,
    mask5 = 1914,

    -- Очки
    glasses1 = 1915,
    glasses2 = 1916,
    glasses3 = 1917,
    glasses4 = 1918,
    glasses5 = 1919,
    glasses6 = 1920,
}

OverwriteFiles = {
    swburbhaus02_open = { txd = "swburbhaus01_open" },
    swburbhaus03_open = { txd = "swburbhaus01_open" },
    swburbhaus04_open = { txd = "swburbhaus01_open" },
    hair2 = { txd = "hair1" },
    hair3 = { txd = "hair1" },
    hair4 = { txd = "hair1" },
    hair5 = { txd = "hair1" },
    hair6 = { txd = "hair1" },
    hair7 = { txd = "hair1" },
    hair8 = { txd = "hair1" },
    loot_mghilie2 = { dff = "loot_mghilie1" },
}

function getReplacedModel(name)
    if not name then
        return
    end
    return ReplacedModels[name]
end
