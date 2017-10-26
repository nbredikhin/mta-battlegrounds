local isHudVisible = false

function setComponentVisible(name, visible)
    if isResourceRunning(name) then
        exports[name]:setVisible(visible)
    end
end

-- Скрывает все элементы игрового интерфейса
local function hideGameHUD()
    setComponentVisible("pb_map",         false)
    setComponentVisible("pb_hud",         false)
    setComponentVisible("pb_radar",       false)
    setComponentVisible("pb_compass",     false)
    -- setComponentVisible("pb_killchat",    false)
    setComponentVisible("pb_inventory",   false)
    setComponentVisible("pb_hud_weapon",  false)
    setComponentVisible("pb_hud_vehicle", false)
end

-- Включает/выключает интерфейс игры
function showGameHUD(visible)
    showPlayerHudComponent("all", false)
    showPlayerHudComponent("crosshair", true)
    showPlayerHudComponent("radio", true)
    setComponentVisible("pb_killchat", true)

    isHudVisible = not not visible
    hideGameHUD()
    if visible then
        setNametagsVisible(true)
        setComponentVisible("pb_hud",         true)
        setComponentVisible("pb_radar",       true)
        setComponentVisible("pb_compass",     true)
        -- setComponentVisible("pb_killchat",    true)
        setComponentVisible("pb_hud_weapon",  true)
        setComponentVisible("pb_hud_vehicle", true)
    end
end

function toggleMap()
    if not isHudVisible then
        return
    end
    if not isResourceRunning("pb_map") then
        return
    end
    local visible = not exports.pb_map:isVisible()
    setComponentVisible("pb_map", visible)
    setComponentVisible("pb_radar", not visible)
    setComponentVisible("pb_compass", not visible)
    setComponentVisible("pb_killchat", not visible)
    setComponentVisible("pb_hud_weapon", not visible)
    setComponentVisible("pb_hud_vehicle", not visible)
    setNametagsVisible(not visible)
    if visible then
        setComponentVisible("pb_inventory", false)
    end
end

function toggleInventory()
    if not isHudVisible then
        return
    end
    if not isResourceRunning("pb_inventory") then
        return
    end
    local visible = not exports.pb_inventory:isVisible()
    setComponentVisible("pb_inventory", visible)
    setComponentVisible("pb_radar", not visible)
    setComponentVisible("pb_compass", not visible)
    setComponentVisible("pb_killchat", not visible)
    setComponentVisible("pb_hud_weapon", not visible)
    setComponentVisible("pb_hud_vehicle", not visible)
    setNametagsVisible(not visible)
    if visible then
        setComponentVisible("pb_map", false)
    end
end

addCommandHandler("map", toggleMap, false, false)
addCommandHandler("inventory", toggleInventory, false, false)

-- Бинды
bindKey("m", "down", "map")
bindKey("f11", "down", "map")
bindKey("tab", "down", "inventory")

showGameHUD(true)
