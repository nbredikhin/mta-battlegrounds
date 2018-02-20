local skills = {"pro", "std", "poor"}
local properties = {
    weapon_range = 350,
    target_range = 350,
    accuracy     = 350,
}

local function updateGlobalProperty(name, k, v)
    for i, skill in ipairs(skills) do
        if v then
            setWeaponProperty(name, skill, k, v)
        end
    end
end

local function updateProperties(name)
    for k, v in pairs(properties) do
        updateGlobalProperty(name, k, v)
    end
end

updateProperties("ak-47")
updateProperties("m4")
updateGlobalProperty("sniper", "flags", 0x000004)
