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
    local label = GuiLabel(x, y, width, height - 2, localize(text), false)
    bindElementToLocale(label, "text", text, function (element, field, name)
        if utf8.len(element:getData("edit").text) == 0 then
            element.text = localize(name)
        end
    end)
    label.alpha = 0.5
    label:setData("origText", text)
    label:setHorizontalAlign("center")
    label:setVerticalAlign("center")
    local edit = GuiEdit(x, y, width, height, "", false)
    edit:setData("editLabel", label)
    edit.alpha = 0

    label:setData("edit", edit)

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

    ui.login.username = createCustomEdit(x, y, editWidth, editHeight, "login_label_username")
    addEventHandler("onClientGUIChanged", ui.login.username, function ()
        ui.login.loginButton.enabled = utf8.len(ui.login.username.text) > 0 and utf8.len(ui.login.password.text) > 0
    end, false)
    y = y + editSpace + editHeight
    ui.login.password = createCustomEdit(x, y, editWidth, editHeight, "login_label_password")
    addEventHandler("onClientGUIChanged", ui.login.password, function ()
        ui.login.loginButton.enabled = utf8.len(ui.login.username.text) > 0 and utf8.len(ui.login.password.text) > 0
    end, false)
    ui.login.password.masked = true
    ui.login.password:setData("masked", true)
    y = y +  editHeight + 5
    ui.login.remember = GuiCheckBox(x, y, editWidth, 25, "Запомнить логин и пароль", false, false)
    bindElementToLocale(ui.login.remember, "text", "login_remember_checkbox")
    y = y + 25 + 5
    x = screenSize.x / 2 - buttonWidth / 2
    ui.login.loginButton = createCustomButton(x, y, buttonWidth, buttonHeight, "Войти")
    bindElementToLocale(ui.login.loginButton, "text", "login_button_login")
    ui.login.loginButton.enabled = false
    y = y + buttonHeight + 10
    local label = GuiLabel(x, y, buttonWidth, buttonHeight, "Регистрация", false)
    bindElementToLocale(label, "text", "login_show_register_panel")
    label:setHorizontalAlign("center")
    ui.login.registerButton = GuiButton(x, y, buttonWidth, buttonHeight, "", false)
    ui.login.registerButton.alpha = 0
    childElements[ui.login.registerButton] = {label}

    y = y + buttonHeight
    x = screenSize.x / 2 - editWidth / 2
    ui.login.messageLabel = GuiLabel(0, y, screenSize.x, 25, "", false)
    ui.login.messageLabel:setHorizontalAlign("center")
    ui.login.messageLabel:setColor(255, 0, 0)

    local x = screenSize.x / 2 - editWidth / 2
    local y = screenSize.y * 0.4 + 10
    ui.register.username = createCustomEdit(x, y, editWidth, editHeight, "login_label_username")
    addEventHandler("onClientGUIChanged", ui.register.username, function ()
        ui.register.registerButton.enabled = exports.pb_accounts:checkUsername(ui.register.username.text)
    end, false)
    y = y + editSpace + editHeight
    ui.register.password = createCustomEdit(x, y, editWidth, editHeight, "login_label_password")
    ui.register.password.masked = true
    ui.register.password:setData("masked", true)
    y = y + editSpace + editHeight
    ui.register.passwordConfirm = createCustomEdit(x, y, editWidth, editHeight, "login_label_password_repeat")
    ui.register.passwordConfirm.masked = true
    ui.register.passwordConfirm:setData("masked", true)
    y = y + editSpace + editHeight
    x = screenSize.x / 2 - buttonWidth / 2
    ui.register.registerButton = createCustomButton(x, y, buttonWidth, buttonHeight, "Регистрация")
    bindElementToLocale(ui.register.registerButton, "text", "login_button_register")
    ui.register.registerButton.enabled = false
    y = y + buttonHeight + 10
    local label = GuiLabel(x, y, buttonWidth, buttonHeight, "Вход в аккаунт", false)
    bindElementToLocale(label, "text", "login_show_login_panel")
    label:setHorizontalAlign("center")
    ui.register.loginButton = GuiButton(x, y, buttonWidth, buttonHeight, "", false)
    ui.register.loginButton.alpha = 0
    childElements[ui.register.loginButton] = {label}

    y = y + buttonHeight
    ui.register.messageLabel = GuiLabel(0, y, screenSize.x, 25, "", false)
    ui.register.messageLabel:setHorizontalAlign("center")
    ui.register.messageLabel:setColor(255, 0, 0)

    ui.language = {}
    local size = 70
    ui.language.russian = GuiStaticImage(screenSize.x - 10 - size, 10, size, size, "assets/ru.png", false)
    ui.language.russian.alpha = 0.5
    ui.language.english = GuiStaticImage(screenSize.x - 10 - size * 2, 10, size, size, "assets/en.png", false)
    ui.language.english.alpha = 0.5

    showUI("login", false)
    showUI("register", false)

    setVisible(true)
    if not localPlayer:getData("username") then
        setVisible(true)
    end
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
    if ui[name].messageLabel then
        ui[name].messageLabel.text = ""
    end
    if visible then
        reloadLocale()
    end
end

local function showLoginUI()
    showUI("login", true)
    showUI("register", false)
    totalHeight = 230
end

function setVisible(visible)
    if visible then
        isVisible = true
        showCursor(true)
        showLoginUI()
        ui.register.messageLabel.text = ""
        ui.login.messageLabel.text = ""

        local autologin = autologinLoad()
        if autologin then
            ui.login.remember.selected = true
            ui.login.username.text = autologin.username
            ui.login.password.text = autologin.password
            updateEditLabel(ui.login.username)
            updateEditLabel(ui.login.password)
        end

        local lang = exports.pb_lang:getLanguage()
        if lang and ui.language[lang] then
            ui.language[lang].alpha = 1
        end
        showUI("language", true)
    else
        isVisible = false
        showCursor(false)
        showUI("login", false)
        showUI("register", false)
        showUI("language", false)

        if ui.login.remember.selected then
            autologinRemember(ui.login.username.text, ui.login.password.text)
        end
    end
end

addEventHandler("onClientGUIClick", resourceRoot, function ()
    if source == ui.login.registerButton then
        showUI("login", false)
        showUI("register", true)
        totalHeight = 265
    elseif source == ui.register.loginButton then
        showLoginUI()
    elseif source == ui.login.loginButton then
        triggerServerEvent("onPlayerRequestLogin", resourceRoot, ui.login.username.text, ui.login.password.text)
    elseif source == ui.register.registerButton then
        if utf8.len(ui.register.password.text) == 0 then
            ui.register.messageLabel.text = "Введите пароль!"
            return
        end
        if ui.register.password.text ~= ui.register.passwordConfirm.text then
            ui.register.messageLabel.text = "Пароли не совпадают"
            return
        end
        triggerServerEvent("onPlayerRequestRegister", resourceRoot, ui.register.username.text, ui.register.password.text)
    elseif source == ui.login.remember then
        if not ui.login.remember.selected then
            autologinClear()
        end
    elseif source == ui.language.russian then
        exports.pb_lang:setLanguage("russian")
        ui.language.russian.alpha = 1
        ui.language.english.alpha = 0.5
    elseif source == ui.language.english then
        exports.pb_lang:setLanguage("english")
        ui.language.russian.alpha = 0.5
        ui.language.english.alpha = 1
    end
end)

addEventHandler("onClientGUIFocus", resourceRoot, function ()
    local editLabel = source:getData("editLabel")
    if isElement(editLabel) then
        source.alpha = 1
        editLabel.visible = false
    end
end)

function updateEditLabel(edit)
    local editLabel = edit:getData("editLabel")
    if isElement(editLabel) then
        edit.alpha = 0
        editLabel.visible = true
        if utf8.len(edit.text) > 0 then
            if edit:getData("masked") then
                editLabel.text = ""
                for i = 1, utf8.len(edit.text) do
                    editLabel.text = editLabel.text .. "*"
                end
            else
                editLabel.text = edit.text
            end
            editLabel.alpha = 1
        else
            editLabel.alpha = 0.5
            editLabel.text = localize(editLabel:getData("origText"))
        end
    end
end

addEventHandler("onClientGUIBlur", resourceRoot, function ()
    updateEditLabel(source)
end)

-- account_not_found
-- already_logged
-- invalid_password
addEvent("onClientLoginError", true)
addEventHandler("onClientLoginError", root, function (reason)
    if reason then
        ui.login.messageLabel.text = localize("login_error_"..tostring(reason))
    else
        ui.login.messageLabel.text = localize("login_error_default_login")
    end
end)

-- account_exists
addEvent("onClientRegisterResult", true)
addEventHandler("onClientRegisterResult", root, function (success, reason)
    if success then
        showLoginUI()
        ui.login.username.text = ui.register.username.text
        ui.login.password.text = ui.register.password.text
    else
        if reason then
            ui.register.messageLabel.text = localize("login_error_"..tostring(reason))
        else
            ui.register.messageLabel.text = localize("login_error_default_register")
        end
    end
end)

addEvent("onLanguageChanged", false)
addEventHandler("onLanguageChanged", root, reloadLocale)
