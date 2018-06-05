if not Config.testModeEnabled then
    return
end

local ui = {}

addEventHandler("onClientResourceStart", resourceRoot, function ()
    local function widget(...)
        return exports.pb_ui:create(...)
    end

    ui.window1 = widget("Window", { x = 200, width = 250, height = 175, text = "Окно 1" })
    exports.pb_ui:alignWidget(ui.window1, "vertical", "center")
    ui.button1 = widget("Button", { x = 15, y = 15, width = 100, height = 30, text = "Кнопка 1", parent = ui.window1 })
    ui.button2 = widget("Button", { x = 15, y = 65, width = 100, height = 30, text = "Кнопка 2", parent = ui.window1, enabled = false})
    ui.button3 = widget("Button", { y = 115, width = 150, height = 40, text = "Кнопка 3", parent = ui.window1 })
    exports.pb_ui:alignWidget(ui.button3, "horizontal", "center")
    exports.pb_ui:setParams(ui.button3, {
        colorMain   = tocolor(200, 130, 0),
        colorHover  = tocolor(220, 150, 0),
        colorPress  = tocolor(255, 190, 0),
        colorBorder = tocolor(240, 170, 0),
        colorText   = tocolor(235, 235, 235),
        colorTextHover = tocolor(255, 255, 255),
        colorTextPress = tocolor(255, 210, 150),
        font = "bold-lg"
    })

    ui.window = widget("Window", { x = 500, width = 350, height = 185, text = "Большой заголовок", font = "bold-lg", headerHeight = 50 })
    exports.pb_ui:alignWidget(ui.window, "vertical", "center")
    local labelText = "Lorem ipsum eros ultricies elementum: nulla metus nibh massa sem sagittis. Cursus sodales curabitur non gravida non ut gravida enim arcu, porttitor, tellus rutrum. "
    widget("Label", { x = 15, y = 15, width = 350 - 30, height = 90, text = labelText, parent = ui.window, textAlignVertical = "top", color = tocolor(150, 150, 150)})
    widget("Label", { x = 15, y = 120, width = 350 - 30, height = 20, text = "Поле ввода", parent = ui.window, textAlignVertical = "top", font = "bold"})
    ui.input = widget("Input", { x = 15, y = 145, width = 200, height = 25, placeholder = "Введите текст...", text = "Test", parent = ui.window})
    ui.buttonAccept = widget("Button", { x = 230, y = 145, width = 105, height = 25, text = "Принять", parent = ui.window })

    ui.window3 = widget("Window", { x = 900, width = 350, height = 265, text = "Двойной заголовок", textRight = "Какой-то текст" })
    exports.pb_ui:alignWidget(ui.window3, "vertical", "center")

    ui.scrollBar = widget("ScrollBar", { width = 15 , parent = ui.window3 })
    exports.pb_ui:fillSize(ui.scrollBar, nil, 0)
    exports.pb_ui:alignWidget(ui.scrollBar, "horizontal", "right", 0)

    widget("Checkbox", { x = 15, y = 15, width = 300, height = 15, text = "Тестовый checkbox", parent = ui.window3})
    widget("Checkbox", { x = 15, y = 45, width = 300, height = 15, text = "Ещё один checkbox", parent = ui.window3})
    local progress = math.random()
    ui.progressLabel = widget("Label", { x = 15, y = 100, width = 320, height = 20, text = "Прогресс: "..math.floor(progress*100).."%", parent = ui.window3, textAlignVertical = "top", font = "bold"})
    ui.progressBar = widget("ProgressBar", { x = 15, y = 130, width = 300, height = 15, text = "Ещё один checkbox", parent = ui.window3, progress = progress})

    widget("Label", { x = 15, y = 160, width = 320, height = 20, text = "Полоса прокрутки:", parent = ui.window3, textAlignVertical = "top", font = "bold"})
    ui.scrollBar2 = widget("ScrollBar", { x = 15, y = 190, width = 300, height = 15, parent = ui.window3, progress = progress, isHorizontal = true, scrollSize = 0.4})

    ui.window4 = widget("Window", { x = 1300, width = 350, height = 185, text = "Заголовки", font = "bold-lg", headerHeight = 50 })
    exports.pb_ui:setParams(ui.window4, {
        colorHeaderRight = tocolor(200, 130, 0),
        colorHeader  = tocolor(220, 150, 0),
        colorText = tocolor(255, 255, 255),
        colorTextRight = tocolor(255, 255, 255, 100),
        textRight = "Заголовок окна"
    })
    exports.pb_ui:alignWidget(ui.window4, "vertical", "center")

    ui.caption1 = widget("Caption", { x = 0, y = 5, width = 350, height = 30, text = "Кастомный заголовок 1", parent = ui.window4} )
    exports.pb_ui:setParams(ui.caption1, {
        color = tocolor(170, 100, 0),
        colorRight = tocolor(150, 80, 0),
        colorText = tocolor(255, 255, 255),
        colorTextRight = tocolor(255, 255, 255, 100),
    })
    ui.caption2 = widget("Caption", { x = 0, y = 40, width = 350, height = 30, text = "Кастомный заголовок 2", parent = ui.window4} )

    showCursor(true)
end)

addEvent("onWidgetClick", true)
addEventHandler("onWidgetClick", resourceRoot, function (widget)
    if widget == ui.button1 then
        exports.pb_ui:destroy(ui.button1)
    elseif widget == ui.button3 then
        exports.pb_ui:setParams(ui.window1, { visible = false })
    elseif widget == ui.buttonAccept then
        exports.pb_ui:setParams(ui.window3, { textRight = exports.pb_ui:getParam(ui.input, "text") })
    end
end)

addEvent("onWidgetScroll", true)
addEventHandler("onWidgetScroll", resourceRoot, function (widget, delta)
    if widget == ui.scrollBar2 then
        local value = exports.pb_ui:getParam(ui.scrollBar2, "value")

        exports.pb_ui:setParams(ui.progressLabel, { text = "Прогресс: "..math.floor(value*100).."%" })
        exports.pb_ui:setParams(ui.progressBar, { progress = value })
    elseif widget == ui.window3  then
        local value = exports.pb_ui:getParam(ui.scrollBar, "value")
        local step = exports.pb_ui:getParam(ui.scrollBar, "step")

        value = value + delta * step
        exports.pb_ui:setParams(ui.scrollBar, { value = value })
    end
end)
