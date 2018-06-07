bindKey("f1", "down", function ()
    local isMenuVisible = not Component("Menu").getState().visible
    Component("Menu").setState({
        visible = isMenuVisible
    })
end)

Component("Settings").setState({
    visible = true
})
