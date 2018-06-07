local view = View(function (ui, component)
    local sectionsList = {
        { name = "gameplay", text = "game_settings_gameplay" },
        { name = "graphics", text = "game_settings_graphics" },
        { name = "controls", text = "game_settings_controls", disabled = true },
        { name = "account",  text = "game_settings_account",  disabled = true},
    }
    local windowWidth  = 450
    local windowHeight = 400
    local buttonHeight = 30
    -- Окно настроек
    ui.window = UI:create("Window", {
        width  = windowWidth,
        height = windowHeight,
    })
    UI:alignWidget(ui.window, "x", "center")
    UI:alignWidget(ui.window, "y", "center")
    localizeWidget(ui.window, "game_menu_settings")

    -- Кнопки разделов
    for i, params in ipairs(sectionsList) do
        local width = windowWidth / #sectionsList
        local button = UI:create("Button", {
            x      = (i-1)*width,
            width  = width,
            height = buttonHeight,
            parent = ui.window,

            borderSize = 0,
        })
        if params.disabled then
            UI:setParams(button, { enabled = false })
        end
        ui["button_"..params.name] = button

        local container = UI:create("Widget", {
            x = 0, y = buttonHeight,
            width  = windowWidth,
            height = windowHeight - buttonHeight*2,
            parent = ui.window
        })
        ui["section_"..params.name] = container

        component.bind(button, "activeSection", params.name)
        component.on("activeSection", function (name)
            if name == params.name then
                UI:setParams(container, { visible = true })
                UI:setParams(button, {
                    colorMain  = tocolor(200, 130, 0),
                    colorHover = tocolor(220, 150, 20),
                    colorPress = tocolor(240, 170, 40)
                })
            else
                UI:setParams(container, { visible = false })
                UI:setParams(button, {
                    colorMain  = tocolor(50, 50, 50),
                    colorHover = tocolor(60, 60, 60),
                    colorPress = tocolor(90, 90, 90)
                })
            end
        end)
        localizeWidget(button, params.text)
    end

    local widget
    local y = 0
    -- Содержимое разделов
    -- Gameplay
    y = y + 10
    widget = UI:create("Label", { y = y, height = 25, parent = ui.section_gameplay, font = "bold" })
    UI:fillSize(widget, 10)
    localizeWidget(widget, "game_settings_gameplay_ui")
    y = y + 25 + 10
    widget = UI:create("Checkbox", { y = y, height = 25, parent = ui.section_gameplay})
    UI:fillSize(widget, 10)
    localizeWidget(widget, "game_settings_show_hud")
    y = y + 25 + 10
    widget = UI:create("Checkbox", { y = y, height = 25, parent = ui.section_gameplay})
    UI:fillSize(widget, 10)
    localizeWidget(widget, "game_settings_show_radar_grid")
    y = y + 25 + 10
    widget = UI:create("Checkbox", { y = y, height = 25, parent = ui.section_gameplay})
    UI:fillSize(widget, 10)
    localizeWidget(widget, "game_settings_show_chat")
    y = y + 25 + 10
    widget = UI:create("Checkbox", { y = y, height = 25, parent = ui.section_gameplay})
    UI:fillSize(widget, 10)
    localizeWidget(widget, "game_settings_show_kills")
    y = y + 25 + 10
    widget = UI:create("Label", { y = y, height = 25, parent = ui.section_gameplay, font = "bold" })
    UI:fillSize(widget, 10)
    localizeWidget(widget, "game_settings_gameplay_stats")
    y = y + 25 + 10
    widget = UI:create("Checkbox", { y = y, height = 25, parent = ui.section_gameplay})
    UI:fillSize(widget, 10)
    localizeWidget(widget, "game_settings_show_ping")
    y = y + 25 + 10
    widget = UI:create("Checkbox", { y = y, height = 25, parent = ui.section_gameplay})
    UI:fillSize(widget, 10)
    localizeWidget(widget, "game_settings_show_fps")
    -- Graphics
    y = 0

    -- Controls
    y = 0

    component.on("visible", "window.visible")
    component.on("visible", showCursor)
end)

Component("Settings", view, function (component)
    component.setState({
        visible = false,
        activeSection = "gameplay"
    })
end)
