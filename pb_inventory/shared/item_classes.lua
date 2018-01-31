Items = {
    jerrycan = {
        level        = 1,
        tag          = "equipment",
        spawnCount   = 1,
        spawnStacks  = 1,

        icon         = "jerrycan.png",
        readableName = "item_jerrycan",
        stackable    = true,
        use_time     = 6000,
        fuel_amount  = 250,
        weight       = 20,
        category     = "vehicles",
    },

    bandage = {
        level        = 1,
        tag          = "medicine",
        spawnCount   = 5,
        spawnStacks  = 1,

        icon         = "bandage.png",
        readableName = "item_bandage",
        stackable    = true,
        heal         = 10,
        heal_max     = 75,
        use_time     = 4000,
        weight       = 2,
        category     = "medicine",
    },

    medkit = {
        level        = 3,
        tag          = "medicine",

        icon         = "medkit.png",
        readableName = "item_medkit",
        stackable    = true,
        heal         = 100,
        heal_max     = 100,
        use_time     = 8000,
        weight       = 15,
        category     = "medicine",
    },

    first_aid = {
        level        = 2,
        tag          = "medicine",
        spawnStacks  = 1,

        icon         = "first_aid.png",
        readableName = "item_first_aid",
        stackable    = true,
        heal         = 75,
        heal_max     = 75,
        use_time     = 6000,
        weight       = 10,
        category     = "medicine",
    },

    energy_drink = {
        level        = 2,
        tag          = "medicine",
        spawnCount   = 1,
        spawnStacks  = 2,

        icon         = "energy_drink.png",
        readableName = "item_energy_drink",
        stackable    = true,
        boost        = 15,
        use_time     = 4000,
        weight       = 4,
        category     = "boost",
    },

    painkiller = {
        level        = 3,
        tag          = "medicine",
        spawnCount   = 1,
        spawnStacks  = 1,

        icon         = "painkiller.png",
        readableName = "item_painkiller",
        stackable    = true,
        boost        = 35,
        use_time     = 6000,
        weight       = 10,
        category     = "boost",

        -- sound = "painkiller.wav",
    },

    adrenaline_syringe = {
        level        = 3,
        tag          = "medicine",
        nospawn      = true,

        icon         = "adrenaline_syringe.png",
        readableName = "item_adrenaline",
        stackable    = true,
        boost        = 100,
        use_time     = 8000,
        weight       = 20,
        category     = "boost",
    },

    weapon_m4 = {
        level        = 3,
        tag          = "weapon",

        icon         = "m4.png",
        readableName = "M16A4",
        category     = "weapon_primary",
        weaponId     = 31,
        clip         = 30,
        stackable    = false,
        ammo         = "ammo_556mm",
        vars = {
            clip = 0,
        }
    },

    weapon_ak47 = {
        level        = 3,
        tag          = "weapon",

        icon         = "ak47.png",
        readableName = "AK-47",
        category     = "weapon_primary",
        weaponId     = 30,
        clip         = 30,
        stackable    = false,
        ammo         = "ammo_762mm",
        vars = {
            clip = 0,
        }
    },

    weapon_kar98k = {
        level        = 3,
        tag          = "weapon",

        icon         = "kar98k.png",
        readableName = "Kar98k",
        category     = "weapon_primary",
        weaponId     = 33,
        clip         = 5,
        stackable    = false,
        ammo         = "ammo_762mm",
        vars = {
            clip = 0,
        }
    },

    weapon_awm = {
        level        = 3,
        tag          = "weapon",

        icon         = "awm.png",
        readableName = "AWM",
        category     = "weapon_primary",
        weaponId     = 34,
        clip         = 5,
        stackable    = false,
        ammo         = "ammo_556mm",
        vars = {
            clip = 0,
        }
    },

    weapon_colt45 = {
        level        = 1,
        tag          = "weapon",

        icon         = "colt45.png",
        readableName = "Colt 45",
        category     = "weapon_secondary",
        weaponId     = 22,
        clip         = 15,
        stackable    = false,
        ammo         = "ammo_9mm",
        vars = {
            clip = 0,
        }
    },

    weapon_shotgun = {
        level        = 2,
        tag          = "weapon",

        icon         = "shotgun.png",
        readableName = "item_shotgun",
        category     = "weapon_primary",
        weaponId     = 25,
        clip         = 5,
        stackable    = false,
        ammo         = "ammo_12gauge",
        vars = {
            clip = 0,
        }
    },

    weapon_uzi = {
        level        = 1,
        tag          = "weapon",

        icon         = "uzi.png",
        readableName = "Uzi",
        category     = "weapon_primary",
        weaponId     = 28,
        clip         = 30,
        stackable    = false,
        ammo         = "ammo_9mm",
        vars = {
            clip = 0,
        }
    },

    weapon_mp5 = {
        level        = 2,
        tag          = "weapon",

        icon         = "mp5.png",
        readableName = "MP5",
        category     = "weapon_primary",
        weaponId     = 29,
        clip         = 30,
        stackable    = false,
        ammo         = "ammo_9mm",
        vars = {
            clip = 0,
        }
    },

    weapon_crowbar = {
        level        = 1,
        tag          = "weapon",

        icon         = "crowbar.png",
        readableName = "item_crowbar",
        category     = "weapon_melee",
        weaponId     = 2,
        stackable    = false,
        vars = {
            clip = 1
        }
    },

    weapon_pan = {
        level        = 1,
        tag          = "weapon",

        icon         = "pan.png",
        readableName = "item_pan",
        category     = "weapon_melee",
        weaponId     = 10,
        stackable    = false,
        vars = {
            clip = 1
        }
    },

    weapon_machete = {
        level        = 1,
        tag          = "weapon",

        icon         = "machete.png",
        readableName = "item_machete",
        category     = "weapon_melee",
        weaponId     = 8,
        stackable    = false,
        vars = {
            clip = 1
        }
    },

    weapon_grenade = {
        level        = 2,
        tag          = "weapon",

        icon         = "grenade.png",
        readableName = "item_grenade",
        category     = "weapon_grenade",
        weaponId     = 16,
        stackable    = true,
        weight       = 12
    },

    weapon_molotov = {
        level        = 3,
        tag          = "weapon",

        icon         = "molotov.png",
        readableName = "item_molotov",
        category     = "weapon_grenade",
        weaponId     = 18,
        stackable    = true,
        weight       = 8
    },

    backpack1 = {
        level        = 1,
        tag          = "equipment",

        icon         = "backpack1.png",
        readableName = "item_backpack1",
        category     = "backpack",
        capacity     = 220,
    },

    backpack2 = {
        level        = 2,
        tag          = "equipment",

        icon         = "backpack2.png",
        readableName = "item_backpack2",
        category     = "backpack",
        capacity     = 270,
    },

    backpack3 = {
        level        = 3,
        tag          = "equipment",

        icon         = "backpack3.png",
        readableName = "item_backpack3",
        category     = "backpack",
        capacity     = 320,
    },

    helmet1 = {
        level             = 1,
        tag               = "equipment",

        icon              = "helmet1.png",
        readableName      = "item_helmet1",
        category          = "helmet",
        penetration_ratio = 0.7,
        vars = {
            health        = 9
        }
    },

    helmet2 = {
        level             = 2,
        tag               = "equipment",

        icon              = "helmet2.png",
        readableName      = "item_helmet2",
        category          = "helmet",
        penetration_ratio = 0.6,
        vars = {
            health = 16
        }
    },

    helmet3 = {
        level             = 3,
        tag               = "equipment",

        icon              = "helmet3.png",
        readableName      = "item_helmet3",
        category          = "helmet",
        penetration_ratio = 0.45,
        vars = {
            health = 25
        }
    },

    armor1 = {
        level             = 1,
        tag               = "equipment",

        icon              = "armor1.png",
        readableName      = "item_armor1",
        category          = "armor",
        penetration_ratio = 0.7,
        vars = {
            health        = 15
        }
    },

    armor2 = {
        level             = 2,
        tag               = "equipment",

        icon              = "armor2.png",
        readableName      = "item_armor2",
        category          = "armor",
        penetration_ratio = 0.6,
        vars = {
            health        = 25
        }
    },

    armor3 = {
        level             = 3,
        tag               = "equipment",

        icon              = "armor3.png",
        readableName      = "item_armor3",
        category          = "armor",
        penetration_ratio = 0.45,
        vars = {
            health        = 45
        }
    },

    ammo_9mm = {
        level        = 1,
        tag          = "ammo",
        spawnCount   = 15,
        spawnStacks  = 3,

        icon         = "ammo_9mm.png",
        readableName = "item_9mm",
        category     = "ammo",
        stackable    = true,
        weight       = 0.375,
    },

    ammo_762mm = {
        level        = 2,
        tag          = "ammo",
        spawnCount   = 30,
        spawnStacks  = 2,

        icon         = "ammo_762mm.png",
        readableName = "item_762mm",
        category     = "ammo",
        stackable    = true,
        weight       = 0.7,
    },

    ammo_556mm = {
        level        = 2,
        tag          = "ammo",
        spawnCount   = 30,
        spawnStacks  = 2,

        icon         = "ammo_556mm.png",
        readableName = "item_556mm",
        category     = "ammo",
        stackable    = true,
        weight       = 0.5,
    },

    ammo_12gauge = {
        level        = 2,
        tag          = "ammo",
        spawnCount   = 10,
        spawnStacks  = 3,

        icon         = "ammo_12gauge.png",
        readableName = "item_12gauge",
        category     = "ammo",
        stackable    = true,
        weight       = 1.25,
    }
}

for name, itemClass in pairs(Items) do
    itemClass.name = name
end

function getItemClass(name)
    if not name then
        return
    end
    return Items[name]
end

function getLootClasses(tag, level, all)
    local classes = {}

    for name, itemClass in pairs(Items) do
        if ((tag and itemClass.tag == tag) or (not tag)) or ((level and itemClass.level <= level) or (not level)) then
            if not itemClass.nospawn then
                table.insert(classes, itemClass)
            end
        end
    end

    return classes
end
