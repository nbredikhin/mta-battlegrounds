addEventHandler("onClientResourceStart", resourceRoot, function ()

    local ui = {}
    local function widget(...)
        return exports.pb_ui:create(...)
    end

    -- ui.window = widget("window", { width = 100, height = 100, text = "Window" })
    -- exports.pb_ui:center(ui.window)
    ui.button1 = widget("Button", { x = 5, y = 5, width = 100, height = 30, text = "Hello", parent = ui.window })
    ui.button2 = widget("Button", { x = 5, y = 45, width = 100, height = 30, text = "Hello", parent = ui.window })

    showCursor(true)
end)
