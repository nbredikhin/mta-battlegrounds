local isGameMenuVisible = false

bindKey("f1", "down", function ()
    isGameMenuVisible = not isGameMenuVisible
    Component("Menu").setState({
        visible = isGameMenuVisible
    })
    Component("Settings").setState({
        visible = isGameMenuVisible and Component("Settings").state.visible
    })
end)

Component("Settings").setState({
    visible = true
})
