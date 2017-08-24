Items = {
    bandage = {
        icon = "bandage.png",
        readableName = "Бинт",
        storage = "backpack",
        stackable = true,
        heal = 10,
        heal_max = 75,

        category = "medicine",
    },

    first_aid = {
        icon = "first_aid.png",
        readableName = "Малая аптечка",
        storage = "backpack",
        stackable = true,
        heal = 50,
        heal_max = 75,

        category = "medicine",
    },

    weapon_m4 = {
        icon = "m4.png",
        readableName = "M4",
        storage = "weapons",
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
        storage = "weapons",
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
        storage = "weapons",
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
        icon = "bat.png",
        readableName = "Бита",
        storage = "weapons",
        category = "weapon_melee",
        weaponId = 5,
        stackable = false,
        vars = {
            ammo = 1,
            clip = 1,
        }
    }
}

function getItemClass(name)
    if not name then
        return
    end
    return Items[name]
end
