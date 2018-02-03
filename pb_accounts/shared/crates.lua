ItemClasses["crate_weekly1"] = {
    crateItems = {
        "boots_working1",     -- 1
        "tshirt_ls_grey",     -- 2
        "tshirt_ls_red",      -- 3
        "shirt_top_white",    -- 4
        "shirt_top_grey",     -- 5
        "pants_cargo2",       -- 6
        "pants_cargo3",       -- 7
        "pants_combat5",      -- 8
        "trainers_hitop3",    -- 9
        "boots_leather2",     -- 10
        "shirt_floral_white", -- 11
        "shirt_school",       -- 12
        "pants_slacks2",      -- 13
        "mandarin_jacket2",   -- 14
        "shorts_jeans",       -- 15
        "skirt3",             -- 16
        "coat_red",           -- 17
        "skirt2",             -- 18
    },
    crateChances = {
        {0.355, 1,  3},
        {0.25,  4,  7},
        {0.12,  8,  9},
        {0.10,  10, 11},
        {0.08,  12, 12},
        {0.05,  13, 13},
        {0.03,  14, 15},
        {0.01,  16, 18},
        {0.005, 19, 20},
    },
    readableName = "Wanderer Crate"
}

ItemClasses["crate_weekly2"] = {
    crateItems = {
        "pants_combat1",      -- 1
        "pants_combat2",      -- 2
        "pants_combat_black", -- 3
        "pants_combat3",      -- 4
        "hat_baseball1",      -- 5
        "pants_combat4",      -- 6
        "hat_baseball2",      -- 7
        "boots_working2",     -- 8
        "trainers_hitop4",    -- 9
        "hat_beanie1",        -- 10
        "hat_baseball3",      -- 11
        "shirt_grey_matched", -- 12
        "shirt_white_tie",    -- 13
        "shirt_checked_white",-- 14
        "shirt_checked_red",  -- 15
        "pants_slacks1",      -- 16
        "coat_gray",          -- 17
        "coat_camel",         -- 18
        "purple_jacket",      -- 19
        "coat",               -- 20
    },
    crateChances = {
        {0.355, 1,  1},
        {0.25,  2,  3},
        {0.12,  4,  5},
        {0.10,  6,  8},
        {0.08,  9,  9},
        {0.05,  10, 10},
        {0.03,  11, 11},
        {0.01,  12, 14},
        {0.005, 15, 18},
    },
    readableName = "Survivor Crate"
}

local crateClothes = {}
for name, itemClass in pairs(ItemClasses) do
    if itemClass.crateItems then
        for i, name in ipairs(itemClass.crateItems) do
            crateClothes[name] = true
        end
    end
end

function isCrateClothes(name)
    return not not (name and crateClothes[name])
end
