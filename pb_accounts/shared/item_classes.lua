ItemClasses = {}

local clothesTable = exports.pb_clothes:getClothesTable()
if clothesTable then
    for name, data in pairs(clothesTable) do
        if data.layer ~= "head" then
            ItemClasses["clothes_"..name] = {
                clothes      = name,
                price        = data.price or 0,
                layer        = data.layer,
                readableName = data.name
            }
        end
    end
end

ItemClasses["crate_weekly1"] = {
    crateItems = {
        "clothes_pants_combat1",        -- 15% 1
        "clothes_pants_combat2",        -- 15% 2
        "clothes_pants_combat_black",   -- 15% 3
        "clothes_pants_combat3",        -- 10% 4
        "clothes_hat_baseball1",        -- 10% 5
        "clothes_pants_combat4",        -- 10% 6
        "clothes_hat_baseball2",        -- 10% 7
        "clothes_boots_working2",       -- 5% 8
        "clothes_trainers_hitop4",      -- 5% 9
        "clothes_hat_beanie1",          -- 4.5% 10
        "clothes_hat_baseball3",        -- 4.5% 11
        "clothes_shirt_grey_matched",   -- 1.2% 12
        "clothes_shirt_white_tie",      -- 0.4% 13
        "clothes_shirt_checked_white",  -- 0.25% 14
        "clothes_shirt_checked_red",    -- 0.25% 15
        "clothes_pants_slacks1",        -- 0.05% 16
        "clothes_coat_gray",            -- 0.05% 17
        "clothes_coat_camel",           -- 0.05% 18
        "clothes_purple_jacket",        -- 0.03% 19
        "clothes_coat",                 -- 0.02% 20
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
        "clothes_boots_working1",
        -- 2, 3
        "clothes_tshirt_ls_grey",
        "clothes_tshirt_ls_red",
        -- 4, 5
        "clothes_shirt_top_white",
        "clothes_shirt_top_grey",
        -- 6, 7, 8
        "clothes_pants_cargo2",
        "clothes_pants_cargo3",
        "clothes_pants_combat5",
        -- 9
        "clothes_trainers_hitop3",
        -- 10
        "clothes_boots_leather2",
        -- 11
        "clothes_shirt_floral_white",
        -- 12, 13, 14
        "clothes_shirt_school",
        "clothes_pants_slacks2",
        "clothes_mandarin_jacket2",
        -- 15, 16
        "clothes_shorts_jeans",
        "clothes_skirt3",
        "clothes_coat_red",             -- 0.01% 21
        "clothes_skirt2",               -- 0.01% 22
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

function isItem(item)
    if type(item) == "table" and item.name and ItemClasses[item.name] then
        return true
    else
        return false
    end
end

function getItemClass(item)
    if type(item) == "string" then
        return ItemClasses[item]
    end
    if isItem(item) then
        return ItemClasses[item.name]
    end
end
