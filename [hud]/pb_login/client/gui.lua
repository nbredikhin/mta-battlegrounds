local screenSize = Vector2(guiGetScreenSize())
local isVisible = false

local editWidth = 200
local editHeight = 40
local editSpace = 15

local buttonWidth = 150
local buttonHeight = 40

local ui = {
    login = {},
    register = {}
}

local childElements = {}

local totalHeight = 210

local function createCustomEdit(x, y, width, height, text)
    local image = GuiStaticImage(x, y, width, height, "assets/edit.png", false)
    image.alpha = 0.8
    local label = GuiLabel(x, y, width, height - 2, text, false)
    label.alpha = 0.5
    label:setData("origText", text)
    label:setHorizontalAlign("center")
    label:setVerticalAlign("center")
    local edit = GuiEdit(x, y, width, height, "", false)
    edit:setData("editLabel", label)
    edit.alpha = 0

    childElements[edit] = {label, image}
    return edit
end

local function createCustomButton(x, y, width, height, label)
    -- local image = GuiStaticImage(x, y, width, height, "assets/button.png", false)
    -- image.alpha = 1
    -- local label = GuiLabel(x, y, width, height - 2, label, false)
    -- label:setHorizontalAlign("center")
    -- label:setVerticalAlign("center")
    return GuiButton(x, y, width, height, label, false)
end

addEventHandler("onClientRender", root, function ()
    if not isVisible then
        return
    end
    local bw = 1920 * screenSize.y / 1080
    local bh = screenSize.y
    dxDrawImage(0, screenSize.y - bh, bw, bh, "assets/bg.jpg")

    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(255, 100, 0, 50))
    local logoWidth = 750 * 0.8
    local logoHeight = 292 * 0.8
    dxDrawImage(screenSize.x / 2 - logoWidth / 2, screenSize.y * 0.4 - logoHeight - 10, logoWidth, logoHeight, "assets/logo.png")

    local bw = 235
    local bh = totalHeight
    dxDrawRectangle(screenSize.x/2 - bw/2, screenSize.y * 0.4 - 10, bw, bh, tocolor(0, 0, 0, 200))
end)

-- addEventHandler("onClientPreRender", root, function (dt)
--     dt = dt / 1000
-- end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    local x = screenSize.x / 2 - editWidth / 2
    local y = screenSize.y * 0.4 + 10

    ui.login.username = createCustomEdit(x, y, editWidth, editHeight, "Логин")
    y = y + editSpace + editHeight
    ui.login.password = createCustomEdit(x, y, editWidth, editHeight, "Пароль")
    ui.login.password.masked = true
    ui.login.password:setData("masked", true)
    y = y +  editHeight + 5
    ui.login.remember = GuiCheckBox(x, y, editWidth, 25, "Автоматический вход", false, false)
    y = y + 25 + 5
    x = screenSize.x / 2 - buttonWidth / 2
    ui.login.loginButton = createCustomButton(x, y, buttonWidth, buttonHeight, "Войти")
    y = y + buttonHeight + 10
    local label = GuiLabel(x, y, buttonWidth, buttonHeight, "Регистрация", false)
    label:setHorizontalAlign("center")
    ui.login.registerButton = GuiButton(x, y, buttonWidth, buttonHeight, "", false)
    ui.login.registerButton.alpha = 0
    childElements[ui.login.registerButton] = {label}

    local x = screenSize.x / 2 - editWidth / 2
    local y = screenSize.y * 0.4 + 10
    ui.register.username = createCustomEdit(x, y, editWidth, editHeight, "Логин")
    y = y + editSpace + editHeight
    ui.register.password = createCustomEdit(x, y, editWidth, editHeight, "Пароль")
    ui.register.password.masked = true
    ui.register.password:setData("masked", true)
    y = y + editSpace + editHeight
    ui.register.passwordConfirm = createCustomEdit(x, y, editWidth, editHeight, "Пароль еще раз")
    ui.register.passwordConfirm.masked = true
    ui.register.passwordConfirm:setData("masked", true)
    y = y + editSpace + editHeight
    x = screenSize.x / 2 - buttonWidth / 2
    ui.register.registerButton = createCustomButton(x, y, buttonWidth, buttonHeight, "Регистрация")
    y = y + buttonHeight + 10
    local label = GuiLabel(x, y, buttonWidth, buttonHeight, "Вход в аккаунт", false)
    label:setHorizontalAlign("center")
    ui.register.loginButton = GuiButton(x, y, buttonWidth, buttonHeight, "", false)
    ui.register.loginButton.alpha = 0
    childElements[ui.register.loginButton] = {label}

    -- showCursor(true)

    showUI("login", false)
    showUI("register", false)

    setVisible(false)
end)

function showUI(name, visible)
    for name, element in pairs(ui[name]) do
        element.visible = visible
        if childElements[element] then
            for i, e in ipairs(childElements[element]) do
                e.visible = visible
            end
        end
    end
end

function setVisible(visible)
    if visible then
        isVisible = true
        showCursor(true)
        showUI("login", true)
        showUI("register", false)
        totalHeight = 230
    else
        isVisible = false
        showCursor(false)
        showUI("login", false)
        showUI("register", false)
    end
end

addEventHandler("onClientGUIClick", resourceRoot, function ()
    if source == ui.login.registerButton then
        showUI("login", false)
        showUI("register", true)
        totalHeight = 265
    elseif source == ui.register.loginButton then
        showUI("login", true)
        showUI("register", false)
        totalHeight = 230
    elseif source == ui.login.loginButton then
        iprint("Login pls")
    elseif source == ui.register.registerButton then
        iprint("Register pls")
    end
end)

addEventHandler("onClientGUIFocus", resourceRoot, function ()
    local editLabel = source:getData("editLabel")
    if isElement(editLabel) then
        source.alpha = 1
        editLabel.visible = false
    end
end)

addEventHandler("onClientGUIBlur", resourceRoot, function ()
    local editLabel = source:getData("editLabel")
    if isElement(editLabel) then
        source.alpha = 0
        editLabel.visible = true
        if utf8.len(source.text) > 0 then
            if source:getData("masked") then
                editLabel.text = ""
                for i = 1, utf8.len(source.text) do
                    editLabel.text = editLabel.text .. "*"
                end
            else
                editLabel.text = source.text
            end
            editLabel.alpha = 1
        else
            editLabel.alpha = 0.5
            editLabel.text = editLabel:getData("origText")
        end
    end
end)
