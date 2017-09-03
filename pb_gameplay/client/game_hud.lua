local isHudHidden = false

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
    setComponentVisible("pb_inventory",  false)
    setComponentVisible("pb_hud_weapon", false)
end

-- Включает/выключает интерфейс игры
function showGameHUD(visible)
    if visible == isHudHidden then
        return
    end
    isHudHidden = not not visible
    hideGameHUD()
    if visible then
        setComponentVisible("pb_hud",        true)
        setComponentVisible("pb_radar",      true)
        setComponentVisible("pb_compass",    true)
        setComponentVisible("pb_hud_weapon", true)
    end
end

-- Карта
bindKey("m", "down", function ()
    if isHudHidden then
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
    if visible then
        setComponentVisible("pb_inventory", false)
    end
end)

-- Инвентарь
bindKey("tab", "down", function ()
    if isHudHidden then
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
    if visible then
        setComponentVisible("pb_map", false)
    end
end)
