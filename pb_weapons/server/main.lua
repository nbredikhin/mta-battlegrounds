local weaponIds = {
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    32,
    30,
    31,
    33,
    34,
    38
}

local skills = {"pro", "std", "poor"}

addEventHandler("onResourceStart", resourceRoot, function ()
    for i, id in ipairs(weaponIds) do
        for _, skill in ipairs(skills) do
            setWeaponProperty(id, skill, "weapon_range", 0)
            setWeaponProperty(id, skill, "damage", 0)
            setWeaponProperty(id, skill, "maximum_clip_ammo", 99999)
        end
    end
end)
