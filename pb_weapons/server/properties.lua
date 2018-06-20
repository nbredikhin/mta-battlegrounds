local skills = {"poor", "std", "pro"}
local properties = {
    weapon_range = 350,
    target_range = 350,
    accuracy     = 350,
}

local resetProperties = {
    "anim_loop_start",
    "anim_loop_stop",
    "anim_loop_bullet_fire",
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

addEventHandler("onResourceStart", resourceRoot, function ()
    for name in pairs(PropsGroups) do
        for i, skill in ipairs(skills) do
            for _, property in ipairs(resetProperties) do
                local value = getOriginalWeaponProperty(name, skill, property)
                setWeaponProperty(name, skill, property, value)
            end
        end
    end

    updateProperties("ak-47")
    updateProperties("m4")
    updateGlobalProperty("sniper", "flags", 0x000004)

    for name, groups in pairs(PropsGroups) do
        for id, props in pairs(groups) do
            local skill = skills[id]
            for k, v in pairs(props) do
                setWeaponProperty(name, skill, k, v)
            end
        end
    end
end)

addCommandHandler("origprops", function ()
    for name in pairs(PropsGroups) do
        for i, skill in ipairs(skills) do
            for _, property in ipairs(resetProperties) do
                local value = getOriginalWeaponProperty(name, skill, property)
                iprint(name, skill, property, value)
            end
        end
    end
end)
