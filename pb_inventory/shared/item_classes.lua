Items = {
    bandage = {
        icon = "bandage.png",
        readableName = "Бинт",
        stackable    = true,
        heal         = 10,
        heal_max     = 75,
        use_time     = 3000,
        weight       = 5,
        category     = "medicine",
    },

    first_aid = {
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
        icon = "m4.png",
        readableName = "M4",
        category = "weapon_primary",
        weaponId = 31,
        clip = 50,
        stackable = false,
        ammo = "ammo_test",
        vars = {
            clip = 0,
        }
    },

    weapon_ak47 = {
        icon = "ak47.png",
        readableName = "AK-47",
        category = "weapon_primary",
        weaponId = 30,
        clip = 30,
        stackable = false,
        ammo = "ammo_test",
        vars = {
            clip = 0,
        }
    },

    weapon_colt45 = {
        icon = "colt45.png",
        readableName = "Colt 45",
        category = "weapon_secondary",
        weaponId = 22,
        clip = 17,
        stackable = false,
        ammo = "ammo_test",
        vars = {
            clip = 0,
        }
    },

    weapon_bat = {
        icon = "cowbar.png",
        readableName = "Монтировка",
        category = "weapon_melee",
        weaponId = 2,
        stackable = false
    },

    weapon_grenade = {
        icon = "grenade.png",
        readableName = "Осколочная граната",
        category = "weapon_grenade",
        weaponId = 16,
        stackable = false,
        weight = 12
    },

    backpack_small = {
        icon = "backpack_small.png",
        readableName = "Рюкзак (ур.1)",
        category = "backpack",
        capacity = 150,
    },

    backpack_medium = {
        icon = "backpack_medium.png",
        readableName = "Рюкзак (ур.2)",
        category = "backpack",
        capacity = 200,
    },

    backpack_large = {
        icon = "backpack_large.png",
        readableName = "Рюкзак (ур.3)",
        category = "backpack",
        capacity = 250,
    },

    helmet1 = {
        icon = "helmet1.png",
        readableName = "Мотоциклетный шлем (ур.1)",
        category = "helmet",
        penetration_ratio = 0.8,
        vars = {
            health = 5
        }
    },

    helmet2 = {
        icon = "helmet2.png",
        readableName = "Шлем (ур.2)",
        category = "helmet",
        penetration_ratio = 0.9,
        vars = {
            health = 10
        }
    },

    helmet3 = {
        icon = "helmet3.png",
        readableName = "Шлем спецназа (ур.3)",
        category = "helmet",
        penetration_ratio = 1,
        vars = {
            health = 15
        }
    },

    ammo_test = {
        icon         = "ammo_9mm.png",
        readableName = "9 мм",
        category     = "ammo",
        stackable    = true,
        capacity     = 200,
        weight       = 0.375,
    }
}

function getItemClass(name)
    if not name then
        return
    end
    return Items[name]
end
