local copyKeys = {
    "readableName",
    "level",
    "tag",
    "clip",
    "stackable",
    "ammo",
    "category"
}

local function createWeaponsItems(weapons)
    for name, weapon in pairs(weapons) do
        Items[name] = {
            vars = {
                tag = "weapon",
                clip = 0,
            },
            icon = name..".png",
            stackable = false
        }

        for i, key in ipairs(copyKeys) do
            if weapon[key] ~= nil then
                Items[name][key] = weapon[key]
            end
        end
    end
end


if isResourceRunning("pb_weapons") then
    createWeaponsItems(exports.pb_weapons:getWeaponsTable())
end


-- weapon_m4 = {
--     level        = 3,
--     tag          = "weapon",

--     icon         = "m4.png",
--     readableName = "M16A4",
--     category     = "weapon_primary",
--     weaponId     = 31,
--     clip         = 30,
--     stackable    = false,
--     ammo         = "ammo_556mm",
--     vars = {
--         clip = 0,
--     }
-- },

-- weapon_ak47 = {
--     level        = 3,
--     tag          = "weapon",

--     icon         = "ak47.png",
--     readableName = "AK-47",
--     category     = "weapon_primary",
--     weaponId     = 30,
--     clip         = 30,
--     stackable    = false,
--     ammo         = "ammo_762mm",
--     vars = {
--         clip = 0,
--     }
-- },

-- weapon_kar98k = {
--     level        = 3,
--     tag          = "weapon",

--     icon         = "kar98k.png",
--     readableName = "Kar98k",
--     category     = "weapon_primary",
--     weaponId     = 33,
--     clip         = 5,
--     stackable    = false,
--     ammo         = "ammo_762mm",
--     vars = {
--         clip = 0,
--     }
-- },

-- weapon_awm = {
--     level        = 3,
--     tag          = "weapon",

--     icon         = "awm.png",
--     readableName = "AWM",
--     category     = "weapon_primary",
--     weaponId     = 34,
--     clip         = 5,
--     stackable    = false,
--     ammo         = "ammo_556mm",
--     vars = {
--         clip = 0,
--     }
-- },

-- weapon_colt45 = {
--     level        = 1,
--     tag          = "weapon",

--     icon         = "colt45.png",
--     readableName = "Colt 45",
--     category     = "weapon_secondary",
--     weaponId     = 22,
--     clip         = 15,
--     stackable    = false,
--     ammo         = "ammo_9mm",
--     vars = {
--         clip = 0,
--     }
-- },

-- weapon_shotgun = {
--     level        = 2,
--     tag          = "weapon",

--     icon         = "shotgun.png",
--     readableName = "item_shotgun",
--     category     = "weapon_primary",
--     weaponId     = 25,
--     clip         = 5,
--     stackable    = false,
--     ammo         = "ammo_12gauge",
--     vars = {
--         clip = 0,
--     }
-- },

-- weapon_uzi = {
--     level        = 1,
--     tag          = "weapon",

--     icon         = "uzi.png",
--     readableName = "Uzi",
--     category     = "weapon_primary",
--     weaponId     = 28,
--     clip         = 30,
--     stackable    = false,
--     ammo         = "ammo_9mm",
--     vars = {
--         clip = 0,
--     }
-- },

-- weapon_mp5 = {
--     level        = 2,
--     tag          = "weapon",

--     icon         = "mp5.png",
--     readableName = "MP5",
--     category     = "weapon_primary",
--     weaponId     = 29,
--     clip         = 30,
--     stackable    = false,
--     ammo         = "ammo_9mm",
--     vars = {
--         clip = 0,
--     }
-- },

-- weapon_crowbar = {
--     level        = 1,
--     tag          = "weapon",

--     icon         = "crowbar.png",
--     readableName = "item_crowbar",
--     category     = "weapon_melee",
--     weaponId     = 2,
--     stackable    = false,
--     vars = {
--         clip = 1
--     }
-- },

-- weapon_pan = {
--     level        = 1,
--     tag          = "weapon",

--     icon         = "pan.png",
--     readableName = "item_pan",
--     category     = "weapon_melee",
--     weaponId     = 10,
--     stackable    = false,
--     vars = {
--         clip = 1
--     }
-- },

-- weapon_machete = {
--     level        = 1,
--     tag          = "weapon",

--     icon         = "machete.png",
--     readableName = "item_machete",
--     category     = "weapon_melee",
--     weaponId     = 8,
--     stackable    = false,
--     vars = {
--         clip = 1
--     }
-- },

-- weapon_smoke = {
--     level        = 1,
--     tag          = "weapon",

--     icon         = "smoke.png",
--     readableName = "item_smoke",
--     category     = "weapon_grenade",
--     weaponId     = 17,
--     stackable    = true,
--     weight       = 16
-- },

-- weapon_grenade = {
--     level        = 2,
--     tag          = "weapon",

--     icon         = "grenade.png",
--     readableName = "item_grenade",
--     category     = "weapon_grenade",
--     weaponId     = 16,
--     stackable    = true,
--     weight       = 12
-- },

-- weapon_molotov = {
--     level        = 3,
--     tag          = "weapon",

--     icon         = "molotov.png",
--     readableName = "item_molotov",
--     category     = "weapon_grenade",
--     weaponId     = 18,
--     stackable    = true,
--     weight       = 8
-- },
