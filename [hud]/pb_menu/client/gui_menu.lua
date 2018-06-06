local UI = exports.pb_ui

local view = View(function (ui, component)
    local buttonMargin = 15
    local buttonHeight = 30
    local buttonsList  = {
        { name = "buttonContinue",   text = "Продолжить игру" },
        { name = "buttonToLobby",    text = "Покинуть матч" },
        { name = "buttonSettigns",   text = "Настройки" },
        { name = "buttonDisconnect", text = "Выйти из игры" },
    }

    -- Окно главного меню
    ui.window = UI:create("Window", {
        width = 300,
        height = #buttonsList * (buttonMargin + buttonHeight) + buttonMargin,
        text = "Меню игры",
        textRight = "F1 - закрыть"
    })
    UI:alignWidget(ui.window, "x", "center")
    UI:alignWidget(ui.window, "y", "center")

    component.on("visible", "window.visible")

    -- Кнопки меню
    for i, params in ipairs(buttonsList) do
        local button = UI:create("Button", {
            y      = buttonMargin + (i-1)*(buttonHeight+buttonMargin),
            height = buttonHeight,
            text   = params.text,
            parent = ui.window
        })
        UI:fillSize(button, buttonMargin)
        ui[params.name] = button
    end
end)

Component("Menu", view, function (component)
    component.setState({
        visible = false
    })
end)
