local isHudVisible = false

local function setComponentVisible(name, visible)
    if isResourceRunning(name) then
        exports[name]:setVisible(visible)
    end
end

-- Скрывает все элементы игрового интерфейса
local function hideGameHUD()
    setComponentVisible("pb_map",        false)
    setComponentVisible("pb_hud",        false)
    setComponentVisible("pb_radar",      false)
    setComponentVisible("pb_compass",    false)
    setComponentVisible("pb_killchat",   false)
    setComponentVisible("pb_inventory",  false)
    setComponentVisible("pb_hud_weapon", false)
end

-- Включает/выключает интерфейс игры
function showGameHUD(visible)
    if visible == isHudVisible then
        return
    end
    showPlayerHudComponent("all", false)
    showPlayerHudComponent("crosshair", true)
    showChat(false)

    isHudVisible = not not visible
    hideGameHUD()
    if visible then
        setComponentVisible("pb_hud",        true)
        setComponentVisible("pb_radar",      true)
        setComponentVisible("pb_compass",    true)
        setComponentVisible("pb_killchat",   true)
        setComponentVisible("pb_hud_weapon", true)
    end
end

function toggleMap()
    if not isHudVisible then
        hideGameHUD()
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
    if visible then
        setComponentVisible("pb_inventory", false)
    end
end

-- Карта
bindKey("m", "down", toggleMap)
bindKey("f11", "down", toggleMap)

-- Инвентарь
bindKey("tab", "down", function ()
    if not isHudVisible then
        hideGameHUD()
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
    if visible then
        setComponentVisible("pb_map", false)
    end
end)

showGameHUD(true)
