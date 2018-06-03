InputManager = {}

local keysState = {}
local keysPressed = {}

local checkKeys = {
    "mouse1"
}

local clickedWidget = nil
local focusedWidget = nil

local inputActionWaitTimer = nil
local inputActionRepeatTimer = nil

-----------------------
-- Локальные функции --
-----------------------

local function stopTextInputAction()
    if isTimer(inputActionWaitTimer) then
        killTimer(inputActionWaitTimer)
    end
    if isTimer(inputActionRepeatTimer) then
        killTimer(inputActionRepeatTimer)
    end
end

local function processTextInputAction(action)
    if isTimer(inputActionRepeatTimer) and (not getKeyState(action) or not focusedWidget) then
        stopTextInputAction()
        return
    end
    if action == "backspace" then
        focusedWidget.text = utf8.sub(focusedWidget.text, 1, -2)
    end
end

local function repeatTextInputAction(action)
    if not getKeyState(action) then
        return
    end
    processTextInputAction(action)
    inputActionRepeatTimer = setTimer(processTextInputAction, Config.textInputRepeatDelay, 0, action)
end

local function startTextInputAction(action)
    processTextInputAction(action)

    if isTimer(inputActionWaitTimer) then
        killTimer(inputActionWaitTimer)
    end
    inputActionWaitTimer = setTimer(repeatTextInputAction, Config.textInputRepeatWait, 1, action)
end

------------------------
-- Глобальные функции --
------------------------

function InputManager.update()
    clickedWidget = nil

    for i, name in ipairs(checkKeys) do
        keysPressed[name] = false
    end
    for i, name in ipairs(checkKeys) do
        local state = getKeyState(name)
        if state and not keysState[name] then
            keysPressed[name] = true
        end
        keysState[name] = state
    end
end

-- Была ли нажата клавиша "name" в текущем кадре
function InputManager.isPressed(name)
    return keysPressed[name]
end

function InputManager.getClickedWidget()
    return clickedWidget
end

function InputManager.setClickedWidget(widget)
    clickedWidget = widget
end

function InputManager.getFocusedWidget()
    return focusedWidget
end

-- Если ничего не передано в качестве аргумента, убирает фокус с виджетов
function InputManager.setFocusedWidget(widget)
    guiSetInputEnabled(false)
    -- Убрать фокус с предыдущего виджета, если он есть
    if focusedWidget then
        focusedWidget.isFocused = false
    end
    focusedWidget = widget
    -- Установить фокус на новый виджет, если он есть
    if focusedWidget then
        focusedWidget.isFocused = true

        if focusedWidget.receiveTextInput then
            guiSetInputEnabled(true)
        end
    end

    stopTextInputAction()
end

-----------------------
-- Обработка событий --
-----------------------

addEventHandler("onClientCharacter", root, function (character)
    if not focusedWidget then
        return
    end

    if focusedWidget and focusedWidget.receiveTextInput then
        focusedWidget.text = focusedWidget.text..character
    end
end)

addEventHandler("onClientKey", root, function (key, state)
    if not focusedWidget or not state then
        return
    end

    if focusedWidget and focusedWidget.receiveTextInput then
        if key == "backspace" then
            startTextInputAction("backspace")
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    guiSetInputMode("no_binds_when_editing")
end)
