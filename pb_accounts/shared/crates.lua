ItemClasses["crate_weekly1"] = {
    crateItems = {
        "pants_combat1",        -- 15% 1
        "pants_combat2",        -- 15% 2
        "pants_combat_black",   -- 15% 3
        "pants_combat3",        -- 10% 4
        "hat_baseball1",        -- 10% 5
        "pants_combat4",        -- 10% 6
        "hat_baseball2",        -- 10% 7
        "boots_working2",       -- 5% 8
        "trainers_hitop4",      -- 5% 9
        "hat_beanie1",          -- 4.5% 10
        "hat_baseball3",        -- 4.5% 11
        "shirt_grey_matched",   -- 1.2% 12
        "shirt_white_tie",      -- 0.4% 13
        "shirt_checked_white",  -- 0.25% 14
        "shirt_checked_red",    -- 0.25% 15
        "pants_slacks1",        -- 0.05% 16
        "coat_gray",            -- 0.05% 17
        "coat_camel",           -- 0.05% 18
        "purple_jacket",        -- 0.03% 19
        "coat",                 -- 0.02% 20
    },
    crateChances = {
        {0.15, 1, 3},
        {0.10, 4, 7},
        {0.05, 8, 9},
        {0.045, 10, 11},
        {0.012, 12, 12},
        {0.004, 13, 13},
        {0.0025, 14, 15},
        {0.0005, 16, 18},
        {0.0003, 19, 19},
        {0.0002, 20, 20},
    },
    readableName = "Wanderer Crate"
}

ItemClasses["crate_weekly2"] = {
    crateItems = {
        -- 1
        "boots_working1",
        -- 2, 3
        "tshirt_ls_grey",
        "tshirt_ls_red",
        -- 4, 5
        "shirt_top_white",
        "shirt_top_grey",
        -- 6, 7, 8
        "pants_cargo2",
        "pants_cargo3",
        "pants_combat5",
        -- 9
        "trainers_hitop3",
        -- 10
        "boots_leather2",
        -- 11
        "shirt_floral_white",
        -- 12, 13, 14
        "shirt_school",
        "pants_slacks2",
        "mandarin_jacket2",
        -- 15, 16
        "shorts_jeans",
        "skirt3",
        "coat_red",             -- 0.01% 21
        "skirt2",               -- 0.01% 22
    },
    crateChances = {
        {0.40, 1, 1},
        {0.30, 2, 3},
        {0.19185, 4, 5},
        {0.09, 6, 8},
        {0.01, 9, 9},
        {0.005, 10, 10},
        {0.0025, 11, 11},
        {0.0005, 12, 14},
        {0.00015, 15, 18},
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
