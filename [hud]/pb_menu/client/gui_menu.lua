local view = View(function (ui, component)
    local buttonMargin = 15
    local buttonHeight = 30
    local buttonsList  = {
        { name = "continue",   text = "game_menu_continue" },
        { name = "lobby",      text = "game_menu_lobby" },
        { name = "settings",   text = "game_menu_settings" },
        { name = "disconnect", text = "game_menu_exit" },
    }

    -- Окно главного меню
    ui.window = UI:create("Window", {
        width = 300,
        height = #buttonsList * (buttonMargin + buttonHeight) + buttonMargin,
    })
    UI:alignWidget(ui.window, "x", "center")
    UI:alignWidget(ui.window, "y", "center")
    localizeWidget(ui.window, "game_menu_title")

    -- Кнопки меню
    for i, params in ipairs(buttonsList) do
        local button = UI:create("Button", {
            y      = buttonMargin + (i-1)*(buttonHeight+buttonMargin),
            height = buttonHeight,
            parent = ui.window
        })
        UI:fillSize(button, buttonMargin)
        ui["button_"..params.name] = button

        component.bind(button, "menuAction", params.name)
        localizeWidget(button, params.text)
    end

    component.on("visible", "window.visible")
    component.on("visible", showCursor)
end)

Component("Menu", view, function (component)
    component.setState({
        visible = false,

        menuAction = function (name)
            iprint(name, name == "settings")
            if name == "continue" then
                component.setState({ visible = false })
            elseif name == "settings" then
                Component("Menu").setState({ visible = false })
                Component("Settings").setState({ visible = true })
            end
        end
    })
end)
