WeaponsTable = {}

--------------------
-- Assault Rifles --
--------------------

WeaponsTable.weapon_akm = {
    baseWeapon = 30,
    propsGroup = 1,

    magazine = 30,
    ammo = "ammo_762mm",
    damage = 49,

    slot = "primary",

    attachments = {
        scope = {
            holographic = true,
            x2 = true,
        }
    },

    model = 1004,

    offset = {
        x    = -0.02,
        y    =  0.045,
        z    =  0.05,
        rx   = -84,
        ry   =  150,
        rz   = -30,
    }
}

WeaponsTable.weapon_aug = {
    baseWeapon = 30,
    propsGroup = 1,

    magazine = 30,
    ammo = "ammo_556mm",
    damage = 43,

    slot = "primary",

    attachments = {
        scope = {
            reddot = true,
            holographic = true,
            x2 = true,
            x3 = true,
            x4 = true,
            x6 = true,
        }
    },

    model = 1005,

    offset = {
        x  = -0.07,
        y  = 0,
        z  = 0.2,
        rx = 10,
        ry = -90,
        rz = -90,
    }
}

WeaponsTable.weapon_groza = {
    baseWeapon = 30,
    propsGroup = 1,

    magazine = 30,
    ammo = "ammo_762mm",
    damage = 49,

    slot = "primary",

    attachments = {
        scope = {
            holographic = true,
            x2 = true,
        }
    },

    model = 1006,

    offset = {
        x  = -0.05,
        y  = 0.05,
        z  = 0.2,
        rx = -10,
        ry = -95,
        rz = 90,
    }
}

WeaponsTable.weapon_m16a4 = {
    baseWeapon = 30,
    propsGroup = 1,

    magazine = 30,
    ammo = "ammo_556mm",
    damage = 43,

    slot = "primary",

    attachments = {
        scope = {
            holographic = true,
            x2 = true,
        }
    },

    model = 1011,

    offset = {
        bone = 12,
        x    = -0.02,
        y    =  0.07,
        z    =  0.02,
        rx   = -84,
        ry   =  150,
        rz   = -30,
    }
}

WeaponsTable.weapon_m416 = {
    baseWeapon = 30,
    propsGroup = 1,

    magazine = 30,
    ammo = "ammo_556mm",
    damage = 43,

    slot = "primary",

    attachments = {
        scope = {
            holographic = true,
            x2 = true,
        }
    },

    model = 1012,

    offset = {
        x    = -0.035,
        y    = 0,
        z    = 0.22,
        rx   = -85,
        ry   = -20,
        rz   = -20,
    }
}

WeaponsTable.weapon_scar = {
    baseWeapon = 30,
    propsGroup = 1,

    magazine = 30,
    ammo = "ammo_556mm",
    damage = 43,

    slot = "primary",

    attachments = {
        scope = {
            holographic = true,
            x2 = true,
        }
    },

    model = 1013,

    offset = {
        x    = -0.015,
        y    =  0.05,
        z    =  0.02,
        rx   = -84,
        ry   =  150,
        rz   = -30,
    }
}

-------------------
-- Sniper Rifles --
-------------------

WeaponsTable.weapon_awm = {
    baseWeapon = 33,
    propsGroup = 1,

    magazine = 5,
    ammo = "ammo_300",
    damage = 120,
    singleShot = true,
    shotDelay = 1,

    slot = "primary",

    attachments = {
        scope = {
            holographic = true,
            x2 = true,
        }
    },

    model = 1026,

    offset = {
        x  = -0.05,
        y  =  0.08,
        z  =  0.11,
        rx = -90,
        ry = 180,
        rz = 0,
    }
}

WeaponsTable.weapon_kar98k = {
    baseWeapon = 33,
    propsGroup = 1,

    magazine = 5,
    ammo = "ammo_762mm",
    damage = 75,
    singleShot = true,
    shotDelay = 0.8,

    slot = "primary",

    attachments = {
        scope = {
            holographic = true,
            x2 = true,
        }
    },

    model = 1027,

    offset = {
        x  = -0.05,
        y  =  0.08,
        z  =  0.07,
        rx = -90,
        ry = 180,
        rz = 0,
    }
}

WeaponsTable.weapon_m24 = {
    baseWeapon = 33,
    propsGroup = 1,

    magazine = 5,
    ammo = "ammo_762mm",
    damage = 75,
    singleShot = true,
    shotDelay = 1.5,

    slot = "primary",

    attachments = {
        scope = {
            holographic = true,
            x2 = true,
        }
    },

    model = 1030,

    offset = {
        x  = -0.035,
        y  =  0.07,
        z  =  0.02,
        rx = -90,
        ry = 180,
        rz = 0,
    }
}

---------------------------

WeaponsTable.weapon_pistol = {
    baseWeapon = 30,
    propsGroup = 3,

    magazine = 90,
    ammo = "ammo_9mm",
    damage = 12,

    slot = "secondary",

    recoilX = 7,
    recoilY = 7,

    attachments = {}
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
