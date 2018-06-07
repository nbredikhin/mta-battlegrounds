local isGameMenuVisible = false

function toggleGameMenu()
    isGameMenuVisible = not isGameMenuVisible
    Component("Menu").setState({
        visible = isGameMenuVisible
    })
    Component("Settings").setState({
        visible = isGameMenuVisible and Component("Settings").state.visible
    })
end

function toggleSettingsWindow()
    if isGameMenuVisible then
        return
    end
    Component("Settings").setState({
        visible = not Component("Settings").state.visible
    })
end

bindKey("f1", "down", toggleGameMenu)
