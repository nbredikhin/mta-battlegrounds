local screenSize = Vector2(guiGetScreenSize())
isLobbyVisible = false

isMousePressed = false
local prevMouseState = false
local mouseX = 0
local mouseY = 0

local lobbyPlayersCount
local lobbyMatchesCount

local currentMessageBoxText = nil
local currentWindow = nil

function localize(name)
    local res = getResourceFromName("pb_lang")
    if (res) and (getResourceState(res) == "running") then
        return exports.pb_lang:localize(name)
    else
        return name
    end
end

function getMousePos()
    return mouseX, mouseY
end

function isMouseOver(x, y, w, h)
    return mouseX >= x     and
           mouseX <= x + w and
           mouseY >= y     and
           mouseY <= y + h
end

function showMessageBox(text)
    currentMessageBoxText = tostring(text)
    setTimer(function() currentMessageBoxText = nil end, 5000, 1)
end

function isLobbyWindowVisible()
    return not not currentWindow
end

function showInviteWindow(player)
    if currentWindow then
        return
    end

    currentWindow = {
        text = string.format(localize("lobby_invite_text"), tostring(string.gsub(player.name, '#%x%x%x%x%x%x', ''))),
        cancel_text = localize("lobby_invite_decline"),
        accept_text = localize("lobby_invite_accept"),
        width = 450,
        height = 170,
        acceptCallback = function ()
            triggerServerEvent("onPlayerAcceptLobbyInvite", resourceRoot)
        end,
        declineCallback = function ()
            triggerServerEvent("onPlayerDeclineLobbyInvite", resourceRoot)
        end
    }
end

function showKickWindow(player)
    if currentWindow then
        return
    end

    currentWindow = {
        text = string.format(localize("lobby_kick_text"), tostring(string.gsub(player.name, '#%x%x%x%x%x%x', ''))),
        cancel_text = localize("lobby_kick_decline"),
        accept_text = localize("lobby_kick_accept"),
        width = 450,
        height = 170,
        acceptCallback = function ()
            triggerServerEvent("onPlayerLobbyKick", resourceRoot, player)
        end,
    }
end

function drawStartGameButton()
    local width = 300
    local height = 70
    local x = 30
    local y = screenSize.y - height - 10

    local buttonText = localize("lobby_start_game")
    local lobbyPlayers = getLobbyPlayers()
    if localPlayer:getData("lobbyReady") then
        buttonText = localize("lobby_ready")

        local allReady = true
        for i, player in ipairs(lobbyPlayers) do
            if isElement(player) and not player:getData("lobbyReady") then
                allReady = false
                break
            end
        end
        if allReady then
            buttonText = localize("lobby_searching")
        end
    end
    dxDrawImage(x, y, width, height, "assets/button.png")
    local textScale = 3
    if isMouseOver(x, y, width, height) then
        dxDrawRectangle(x, y, width, height, tocolor(254, 181, 0, 100))
        textScale = 3.1

        if isMousePressed then
            localPlayer:setData("lobbyReady", not localPlayer:getData("lobbyReady"))
        end
    end
    dxDrawText(buttonText, x+2, y+2, x + width+2, y + height+2, tocolor(0, 0, 0, 150), textScale, "default-bold", "center", "center")
    dxDrawText(buttonText, x, y, x + width, y + height, tocolor(255, 255, 255), textScale, "default-bold", "center", "center")

    local infoText = localize("lobby_match_type")..": "
    if getLobbyType() == "solo" then
        infoText = infoText..localize("lobby_type_solo")
    else
        if #lobbyPlayers == 1 then
            infoText = infoText..localize("lobby_type_1m_squad")
        elseif #lobbyPlayers == 2 then
            infoText = infoText..localize("lobby_type_2m_squad")
        else
            infoText = infoText..localize("lobby_type_squad")
        end
    end
    y = y - 15
    local textWidth = dxGetTextWidth(infoText, 2, "default-bold")
    local scale = 2
    if width < textWidth then
        scale = scale * width / textWidth
    end
    dxDrawText(infoText, x, y + 11, x + width, y + 10, tocolor(255, 255, 255, 150), scale, "default-bold", "left", "bottom")
end

function drawMessageBox()
    if not currentMessageBoxText then
        return
    end
    local width = dxGetTextWidth(currentMessageBoxText, 2.5, "default-bold") + 50
    local height = 150
    dxDrawRectangle(screenSize.x / 2 - width / 2 - 1, screenSize.y / 2 - height / 2 - 1, width + 2, height + 2, tocolor(255, 255, 255))
    dxDrawRectangle(screenSize.x / 2 - width / 2, screenSize.y / 2 - height / 2, width, height, tocolor(0, 0, 0))
    dxDrawText(currentMessageBoxText, 0, 0, screenSize.x, screenSize.y, tocolor(255, 255, 255), 2.5, "default-bold", "center", "center")
end

function drawButton(text, x, y, width, height, bg, color, scale)
    if not bg then bg = tocolor(250, 250, 250) end
    if not color then color = tocolor(0, 0, 0, 200) end
    if not scale then scale = 1.5 end
    dxDrawRectangle(x, y, width, height, bg)
    dxDrawRectangle(x, y + height - 5, width, 5, tocolor(0, 0, 0, 10))
    dxDrawText(text, x, y, x + width, y + height, color, scale, "default-bold", "center", "center", true, true)

    if isMouseOver(x, y, width, height) then
        dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 100))
        if isMousePressed then
            return true
        end
    end
    return false
end

function drawWindow()
    if not currentWindow then
        return
    end
    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150))

    local x = screenSize.x / 2 - currentWindow.width / 2
    local y = screenSize.y / 2 - currentWindow.height / 2

    dxDrawRectangle(x-1, y-1, currentWindow.width+2, currentWindow.height+2, tocolor(255, 255, 255))
    dxDrawRectangle(x, y, currentWindow.width, currentWindow.height, tocolor(0, 0, 0))
    dxDrawText(currentWindow.text, x + 15, y, x + currentWindow.width - 30, y + currentWindow.height / 2 + 15, tocolor(255, 255, 255), 2, "default-bold", "center", "center", true, true)

    local bw = 140
    local bh = 45
    if drawButton(currentWindow.cancel_text, x + currentWindow.width / 2 - bw - 10, y + currentWindow.height - bh - 15, bw, bh) then
        if type(currentWindow.declineCallback) == "function" then
            currentWindow.declineCallback()
        end
        currentWindow = nil
        return
    end
    if drawButton(currentWindow.accept_text, x + currentWindow.width / 2 + 10, y + currentWindow.height - bh - 15, bw, bh) then
        if type(currentWindow.acceptCallback) == "function" then
            currentWindow.acceptCallback()
        end
        currentWindow = nil
        return
    end
end

function drawInvitePanel()
    local w = 440
    local h = 45
    local x = screenSize.x - w - 10
    local y = screenSize.y - h - 10
    dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 200))
    local iconSize = 32
    x = x + 10
    dxDrawImage(x, y+h/2-iconSize/2, iconSize, iconSize, "assets/invite.png")
    x = x + iconSize
    local playersCount = #getLobbyPlayers()
    dxDrawText(localize("lobby_counter_text") .. ": "..tostring(playersCount).."/4", x, y, x + 150, y + h, tocolor(255, 255, 255), 1, "default-bold", "center", "center", true, true)
    x = x + 150
    local bh = 30
    local bw = 240
    if isOwnLobby() then
        if playersCount >= 4 then
            drawButton(localize("lobby_button_full"), x, y + h/2-bh/2,bw,bh)
        else
            if drawButton(localize("lobby_button_invite"), x, y + h/2-bh/2,bw,bh) then
                showInviteSendWindow()
            end
        end
    else
        if drawButton(localize("lobby_button_leave"), x, y + h/2-bh/2,bw,bh) then
            triggerServerEvent("onPlayerLeaveLobby", resourceRoot)
        end
    end
end

function drawBattlepoints()
    local offset = 200
    local textScale = 2
    if screenSize.x < 1024 then
        textScale = 1
        offset = 100
    elseif screenSize.x < 1600 then
        textScale = 1.5
        offset = 150
    end
    local fontHeight = dxGetFontHeight(textScale, "default-bold")
    local tabsX, tabsY = getTabsPosition()
    local username = localPlayer:getData("username")
    if username then
        local iconSize = fontHeight * 1.2
        local x = screenSize.x - offset
        local y = tabsY
        dxDrawText(string.upper(username), 0, y, x, y, tocolor(255, 255, 255, 150), textScale, "default-bold", "right", "top")
        x = x + iconSize * 0.25
        dxDrawImage(x, y, iconSize, iconSize, "assets/bp.png")
        x = x + iconSize * 1.2
        local bPoints = tostring(localPlayer:getData("battlepoints"))
        dxDrawText(bPoints, x, y, screenSize.x, y, tocolor(255, 255, 255), textScale, "default-bold", "left", "top")

        local donatepoints = localPlayer:getData("donatepoints")
        if donatepoints and donatepoints > 0 then
            x = screenSize.x - offset + iconSize * 0.25
            y = y + iconSize * 1.25
            dxDrawImage(x, y - 0, iconSize, iconSize, "assets/dp.png", 0, 0, 0, tocolor(255, 255, 255))
            x = x + iconSize * 1.2
            local dPoints = tostring(donatepoints)
            dxDrawText(dPoints, x, y, screenSize.x, y, tocolor(255, 255, 255), textScale, "default-bold", "left", "top")
            -- y = y + iconSize * 1.2
            -- x = x - iconSize * 1.2
            -- local textWidth = dxGetTextWidth(dPoints, textScale, "default-bold")
            -- local bw = math.max(85, textWidth + iconSize * 1.2)
            -- local bh = 20

            -- if isMouseOver(x, y, bw, bh) then
            --     dxDrawRectangle(x, y, bw, bh, tocolor(254, 181, 0, 255))
            --     if isMousePressed then

            --     end
            -- else
            --     dxDrawRectangle(x, y, bw, bh, tocolor(0, 0, 0, 150))
            -- end
            -- dxDrawText("Convert to BP", x, y, x + bw, y + bh, tocolor(255, 255, 255), 1, "default", "center", "center")
        end
    end
end

addEventHandler("onClientRender", root, function ()
    if not isLobbyVisible then
        return
    end
    local currentMouseState = getKeyState("mouse1")
    if not prevMouseState and currentMouseState then
        isMousePressed = true
    else
        isMousePressed = false
    end
    prevMouseState = currentMouseState
    if isMTAWindowActive() then
        isMousePressed = false
    end

    local mx, my = getCursorPosition()
    if mx then
        mx = mx * screenSize.x
        my = my * screenSize.y
    else
        mx, my = 0, 0
    end
    mouseX, mouseY = mx, my

    drawTabs()
    drawStartGameButton()

    if getLobbyType() == "solo" then
        local y = screenSize.y - 65
        if lobbyPlayersCount then
            local lobbyText = localize("lobby_players_in_lobby") .. ": " .. tostring(lobbyPlayersCount)
            dxDrawText(lobbyText, 26, y + 1, 0, 0, tocolor(0, 0, 0, 150), 1, "default-bold", "left", "top")
            dxDrawText(lobbyText, 25, y, 0, 0, tocolor(255, 255, 255), 1, "default-bold", "left", "top")

            y = y + 25
        end
        if lobbyMatchesCount then
            local text = localize("lobby_matches_running") .. ": " .. tostring(lobbyMatchesCount)
            dxDrawText(text, 26, y + 1, 0, 0, tocolor(0, 0, 0, 150), 1, "default-bold", "left", "top")
            dxDrawText(text, 25, y, 0, 0, tocolor(255, 255, 255), 1, "default-bold", "left", "top")
        end
    end

    drawMessageBox()
    drawWindow()

    if getLobbyType() == "squad" then
        drawInvitePanel()
    end
end)

addEvent("updateLobbyPlayersCount", true)
addEventHandler("updateLobbyPlayersCount", root, function (count, matches)
    lobbyPlayersCount = count
    lobbyMatchesCount = matches
end)

addEventHandler("onClientResourceStop", resourceRoot, function ()
    resetFarClipDistance()
    resetFogDistance()
end)
