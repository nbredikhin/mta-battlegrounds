bindKey("f1", "down", function ()
    local isVisible = not Component("Menu").getState().visible
    Component("Menu").setState({
        visible = isVisible
    })
    showCursor(isVisible)
end)
