WeaponsTable = {}

-- WeaponsTable.weapon_sample = {
--     baseWeapon = 30,
--     propsGroup = 1,

--     magazine = 30,
--     ammo = "ammo_762mm",
--     damage = 48,

--     slot = "primary",

--     attachments = {
--         scope_2 = true,
--         scope_holographic = true,
--     }
-- }

WeaponsTable.weapon_akm = {
    baseWeapon = 30,
    propsGroup = 1,

    magazine = 30,
    ammo = "ammo_762mm",
    damage = 48,

    slot = "primary",

    attachments = {
        scope_2 = true,
        scope_holographic = true,
    }
}

WeaponsTable.weapon_pistol = {
    baseWeapon = 30,
    propsGroup = 3,

    magazine = 15,
    ammo = "ammo_9mm",
    damage = 12,

    slot = "secondary",

    attachments = {
        scope_holographic = true,
    }
}

WeaponsTable.weapon_grenade = {
    baseWeapon = 16,
    propsGroup = 1,

    magazine = 1,
    damage = 12,

    slot = "grenade",
}

WeaponsTable.weapon_shovel = {
    baseWeapon = 6,
    propsGroup = 1,

    damage = 12,

    slot = "melee",
}
