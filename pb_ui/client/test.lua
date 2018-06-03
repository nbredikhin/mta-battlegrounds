if not Config.testModeEnabled then
    return
end

local ui = {}

addEventHandler("onClientResourceStart", resourceRoot, function ()
    local function widget(...)
        return exports.pb_ui:create(...)
    end

    ui.window = widget("Window", { x = 200, width = 250, height = 175, text = "Окно 1" })
    exports.pb_ui:alignWidget(ui.window, "vertical", "center")
    ui.button1 = widget("Button", { x = 15, y = 15, width = 100, height = 30, text = "Кнопка 1", parent = ui.window })
    ui.button2 = widget("Button", { x = 15, y = 65, width = 100, height = 30, text = "Кнопка 2", parent = ui.window, enabled = false})
    ui.button3 = widget("Button", { y = 115, width = 150, height = 40, text = "Кнопка 3", parent = ui.window })
    exports.pb_ui:alignWidget(ui.button3, "horizontal", "center")
    exports.pb_ui:setParams(ui.button3, {
        colorMain   = tocolor(200, 130, 0),
        colorHover  = tocolor(220, 150, 0),
        colorPress  = tocolor(255, 190, 0),
        colorBorder = tocolor(240, 170, 0),
        colorText   = tocolor(255, 255, 255),
        font = "bold-lg"
    })

    ui.window = widget("Window", { x = 500, width = 350, height = 185, text = "Большой заголовок", font = "bold-lg", headerHeight = 50 })
    exports.pb_ui:alignWidget(ui.window, "vertical", "center")
    local labelText = "Lorem ipsum eros ultricies elementum: nulla metus nibh massa sem sagittis. Cursus sodales curabitur non gravida non ut gravida enim arcu, porttitor, tellus rutrum. "
    widget("Label", { x = 15, y = 15, width = 350 - 30, height = 90, text = labelText, parent = ui.window, textAlignVertical = "top", color = tocolor(150, 150, 150)})
    widget("Label", { x = 15, y = 120, width = 350 - 30, height = 20, text = "Поле ввода", parent = ui.window, textAlignVertical = "top", font = "bold"})
    ui.input = widget("Input", { x = 15, y = 145, width = 200, height = 25, placeholder = "Введите текст...", text = "Test", parent = ui.window})
    exports.pb_ui:fillSize(ui.input, 15)

    ui.window = widget("Window", { x = 900, width = 350, height = 250, text = "Двойной заголовок", textRight = "Какой-то текст", font = "bold" })
    exports.pb_ui:alignWidget(ui.window, "vertical", "center")

    ui.scrollBar = widget("ScrollBar", { width = 15 , parent = ui.window })
    exports.pb_ui:fillSize(ui.scrollBar, nil, 5)
    exports.pb_ui:alignWidget(ui.scrollBar, "horizontal", "right", 5)

    showCursor(true)
end)

addEvent("onWidgetClick", true)
addEventHandler("onWidgetClick", resourceRoot, function (widget)
    if widget == ui.button1 then
        exports.pb_ui:destroy(ui.button1)
    end
end)
