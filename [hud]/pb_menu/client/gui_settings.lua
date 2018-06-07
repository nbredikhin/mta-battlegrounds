local view = View(function (ui, component)
    UI:defineStyle("settings-tab-selected", {
        colorMain  = tocolor(200, 130, 0),
        colorHover = tocolor(220, 150, 20),
        colorPress = tocolor(240, 170, 40),

        colorText = tocolor(255, 255, 255),
        colorTextHover = tocolor(255, 255, 255, 200),
        colorTextPress = tocolor(255, 255, 255, 150),
    })

    local sectionsList = {
        { name = "gameplay", text = "game_settings_gameplay" },
        { name = "graphics", text = "game_settings_graphics" },
        { name = "controls", text = "game_settings_controls", disabled = true },
        { name = "account",  text = "game_settings_account",  disabled = true},
    }
    local windowWidth  = 450
    local windowHeight = 440
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
            borderSize = 0
        })
        if params.disabled then
            UI:setParams(button, { enabled = false })
        end
        ui["button_"..params.name] = button

        local container = UI:create("Widget", {
            x = 0, y = buttonHeight,
            width  = windowWidth,
            height = windowHeight - buttonHeight*2 - 20,
            parent = ui.window
        })
        ui["section_"..params.name] = container

        component.bind(button, "activeSection", params.name)
        component.on("activeSection", function (name)
            local isActive = name == params.name
            UI:toggleStyle(button, "settings-tab-selected", isActive)
            UI:setParams(container, { visible = isActive })
        end)
        localizeWidget(button, params.text)
    end

    ui.buttonClose = UI:create("Button", { width = 150, height = buttonHeight, parent = ui.window })
    UI:alignWidget(ui.buttonClose, "x", "center", 0)
    UI:alignWidget(ui.buttonClose, "y", "bottom", 10)
    localizeWidget(ui.buttonClose, "game_settings_close")

    local widget
    local y = 0
    -- Содержимое разделов
    -- Gameplay
    y = y + 10
    widget = UI:create("Label", { y = y, height = 25, parent = ui.section_gameplay, font = "bold" })
    UI:fillSize(widget, 10)
    localizeWidget(widget, "game_settings_gameplay_language")
    y = y + 25 + 10
    local languages = {"english", "russian"}
    for i, name in ipairs(languages) do
        local spacing = 15
        local buttonsTotalWidth = windowWidth * 0.5 --windowWidth-20
        local width = (buttonsTotalWidth - spacing * (#languages-1)) / #languages
        widget = UI:create("Button", {
            x = 10 + (width + spacing) * (i-1),
            y = y,
            height = 25,
            width = width,
            text = utf8.gsub(name, "^%l", utf8.upper),
            parent = ui.section_gameplay
        })
    end
    y = y + 25 + 10
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
    component.bind(ui.buttonClose, "closeSettings")
end)

Component("Settings", view, function (component)
    component.setState({
        visible = false,
        activeSection = "gameplay",

        closeSettings = function ()
            component.setState({ visible = false })
            if component.state.returnToMenu then
                Component("Menu").setState({ visible = true })
            end
        end
    })
end)
