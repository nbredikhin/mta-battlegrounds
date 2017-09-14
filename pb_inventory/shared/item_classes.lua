Items = {
    bandage = {
        level        = 1,
        tag          = "medicine",
        spawnCount   = 5,
        spawnStacks  = 3,

        icon         = "bandage.png",
        readableName = "Бинт",
        stackable    = true,
        heal         = 10,
        heal_max     = 75,
        use_time     = 3000,
        weight       = 5,
        category     = "medicine",
    },

    first_aid = {
        level        = 2,
        tag          = "medicine",
        spawnStacks  = 2,

        icon         = "first_aid.png",
        readableName = "Малая аптечка",
        stackable    = true,
        heal         = 75,
        heal_max     = 75,
        use_time     = 5000,
        weight       = 10,
        category     = "medicine",
    },

    weapon_m4 = {
        level        = 3,
        tag          = "weapon",

        icon         = "m4.png",
        readableName = "M4",
        category     = "weapon_primary",
        weaponId     = 31,
        clip         = 50,
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

    weapon_colt45 = {
        level        = 1,
        tag          = "weapon",

        icon         = "colt45.png",
        readableName = "Colt 45",
        category     = "weapon_secondary",
        weaponId     = 22,
        clip         = 17,
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
        readableName = "Дробовик",
        category     = "weapon_primary",
        weaponId     = 27,
        clip         = 7,
        stackable    = false,
        ammo         = "ammo_12gauge",
        vars = {
            clip = 0,
        }
    },

    weapon_crowbar = {
        level        = 1,
        tag          = "weapon",

        icon         = "crowbar.png",
        readableName = "Монтировка",
        category     = "weapon_melee",
        weaponId     = 2,
        stackable    = false,
        vars = {
            clip = 1
        }
    },

    weapon_grenade = {
        level        = 2,
        tag          = "weapon",

        icon         = "grenade.png",
        readableName = "Осколочная граната",
        category     = "weapon_grenade",
        weaponId     = 16,
        stackable    = false,
        weight       = 12
    },

    backpack_small = {
        level        = 1,
        tag          = "equipment",

        icon         = "backpack_small.png",
        readableName = "Рюкзак (ур.1)",
        category     = "backpack",
        capacity     = 150,
    },

    backpack_medium = {
        level        = 2,
        tag          = "equipment",

        icon         = "backpack_medium.png",
        readableName = "Рюкзак (ур.2)",
        category     = "backpack",
        capacity     = 200,
    },

    backpack_large = {
        level        = 3,
        tag          = "equipment",

        icon         = "backpack_large.png",
        readableName = "Рюкзак (ур.3)",
        category     = "backpack",
        capacity     = 250,
    },

    helmet1 = {
        level             = 1,
        tag               = "equipment",

        icon              = "helmet1.png",
        readableName      = "Мотоциклетный шлем (ур.1)",
        category          = "helmet",
        penetration_ratio = 0.8,
        vars = {
            health        = 5
        }
    },

    helmet2 = {
        level             = 2,
        tag               = "equipment",

        icon              = "helmet2.png",
        readableName      = "Шлем (ур.2)",
        category          = "helmet",
        penetration_ratio = 0.9,
        vars = {
            health = 10
        }
    },

    helmet3 = {
        level             = 3,
        tag               = "equipment",

        icon              = "helmet3.png",
        readableName      = "Шлем спецназа (ур.3)",
        category          = "helmet",
        penetration_ratio = 1,
        vars = {
            health = 15
        }
    },

    ammo_9mm = {
        level        = 1,
        tag          = "ammo",
        spawnCount   = 15,
        spawnStacks  = 6,

        icon         = "ammo_9mm.png",
        readableName = "9 мм",
        category     = "ammo",
        stackable    = true,
        weight       = 0.375,
    },

    ammo_762mm = {
        level        = 2,
        tag          = "ammo",
        spawnCount   = 30,
        spawnStacks  = 3,

        icon         = "ammo_762mm.png",
        readableName = "7.62мм",
        category     = "ammo",
        stackable    = true,
        weight       = 0.7,
    },

    ammo_556mm = {
        level        = 2,
        tag          = "ammo",
        spawnCount   = 30,
        spawnStacks  = 3,

        icon         = "ammo_556mm.png",
        readableName = "5.56мм",
        category     = "ammo",
        stackable    = true,
        weight       = 0.5,
    },

    ammo_12gauge = {
        level        = 2,
        tag          = "ammo",
        spawnCount   = 10,
        spawnStacks  = 2,

        icon         = "ammo_12gauge.png",
        readableName = "12 калибр",
        category     = "ammo",
        stackable    = true,
        weight       = 0.5,
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

function getItemClasses(tag, level)
    local classes = {}

    for name, itemClass in pairs(Items) do
        if ((tag and itemClass.tag == tag) or (not tag)) or ((level and itemClass.level <= level) or (not level)) then
            table.insert(classes, itemClass)
        end
    end

    return classes
end
