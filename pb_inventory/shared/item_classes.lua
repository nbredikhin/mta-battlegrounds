Items = {
    bandage = {
        icon = "bandage.png",
        readableName = "Бинт",
        stackable = true,
        heal = 10,
        heal_max = 75,
        weight = 10,
        category = "medicine",
    },

    first_aid = {
        icon = "first_aid.png",
        readableName = "Малая аптечка",
        stackable = true,
        heal = 50,
        heal_max = 75,
        weight = 15,
        category = "medicine",
    },

    weapon_m4 = {
        icon = "m4.png",
        readableName = "M4",
        category = "weapon_primary",
        weaponId = 31,
        clip = 50,
        stackable = false,
        vars = {
            ammo = 0,
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
        vars = {
            ammo = 0,
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
        vars = {
            ammo = 0,
            clip = 0,
        }
    },

    weapon_bat = {
        icon = "cowbar.png",
        readableName = "Монтировка",
        category = "weapon_melee",
        weaponId = 2,
        stackable = false,
        vars = {
            ammo = 1,
            clip = 1,
        }
    },

    weapon_grenade = {
        icon = "grenade.png",
        readableName = "Осколочная граната",
        category = "weapon_grenade",
        weaponId = 16,
        stackable = false,
        vars = {
            clip = 1,
            ammo = 0,
        }
    },

    backpack_small = {
        icon = "backpack_small.png",
        readableName = "Рюкзак (ур.1)",
        category = "backpack",
        capacity = 200,
        model = 1310
    }
}

function getItemClass(name)
    if not name then
        return
    end
    return Items[name]
end
