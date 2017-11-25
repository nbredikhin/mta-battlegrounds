local screenSize = Vector2(guiGetScreenSize())
local isKillChatVisible = true
local chatX = 25
local chatY = screenSize.y - 190

local messagesList = {}

local messageLifetime = 15
local messageFadeTime = 1.5

local messageScale = 1.5

local isTextInputActive = false
local inputText = ""

local skipCharacter = false

local messageTimer

function outputMessage(text, info, isHighlight)
    table.insert(messagesList, 1, {
        text = text,
        info = info,
        time = messageLifetime,
        isHighlight = isHighlight
    })
end

function localize(name)
    local res = getResourceFromName("pb_lang")
    if (res) and (getResourceState(res) == "running") then
        return exports.pb_lang:localize(name)
    else
        return name
    end
end

addEvent("onMatchPlayerWasted", true)
addEventHandler("onMatchPlayerWasted", root, function (aliveCount, killerPlayer, weaponId, knockedFinished)
    local wastedName = string.gsub(source.name, '#%x%x%x%x%x%x', '')
    local message = string.format(localize("killchat_death"), tostring(wastedName))

    if isElement(killerPlayer) then
        if knockedFinished then
            message = string.format(localize("killchat_kill_finished"), tostring(killerName), tostring(wastedName))
        else
            local weaponName = exports.pb_inventory:getWeaponNameFromId(weaponId)
            local killerName = string.gsub(killerPlayer.name, '#%x%x%x%x%x%x', '')
            message = string.format(localize("killchat_kill"), tostring(killerName), tostring(wastedName))
            if weaponName then
                message = message .. string.format(localize("killchat_weapon"), localize(tostring(weaponName)))
            end
        end
    end

    local aliveText = " - " .. tostring(aliveCount) .. " " .. localize("killchat_alive_count")
    if aliveCount == 1 then
        aliveText = " - " .. localize("killchat_match_ended")
    end
    outputMessage(message, aliveText, aliveCount <= 10)
end)

addEventHandler("onClientRender", root, function ()
    if not isKillChatVisible then
        return
    end

    local x = chatX
    local y = chatY
    local h = 17 * messageScale

    if isTextInputActive then
        local chatName = "Lobby"
        if localPlayer:getData("matchId") then
            chatName = "Team"
        end
        local str = chatName .. ": " .. inputText
        dxDrawText(str, x+1, y+1, x+1, y+1, tocolor(0, 0, 0, 150), messageScale)
        dxDrawText(str, x, y, x, y, tocolor(49, 177, 178, 255), messageScale)
    end

    y = y - h - 5

    for i = 1, 5 do
        local message = messagesList[i]
        if message then
            local str1 = messagesList[i].text
            local str2 = messagesList[i].info
            local w = dxGetTextWidth(str1, messageScale)
            local w1 = w
            local w2
            if str2 then
                w2 = dxGetTextWidth(str2, messageScale, "default-bold")
                w = w + w2
            end
            local alpha = 1
            if message.time < messageFadeTime then
                alpha = message.time / messageFadeTime
            end
            dxDrawRectangle(x - 3, y, w + 6, h, tocolor(0, 0, 0, 80 * alpha))
            dxDrawText(str1, x, y, x, y, tocolor(180, 180, 180, 255 * alpha), messageScale)
            if str2 then
                if alpha == 1 then
                    dxDrawText(str2, x+1+w1, y+1, x+1+w1, y+1, tocolor(0, 0, 0, 200), messageScale, "default-bold")
                end
                local color = tocolor(255, 255, 255, 255 * alpha)
                if message.isHighlight then
                    color = tocolor(250, 250, 150, 255 * alpha)
                end
                dxDrawText(str2, x+w1,y,x+w1,y, color, messageScale, "default-bold")
            end
        end
        y = y - h - 5
    end
end)

addEventHandler("onClientPreRender", root, function (dt)
    if not isKillChatVisible then
        return
    end
    dt = dt / 1000
    for i, message in ipairs(messagesList) do
        message.time = message.time - dt
        if message.time <= 0 then
            table.remove(messagesList, i)
        end
    end
end)

function setVisible(visible)
    if not not visible == not not isKillChatVisible then
        return
    end

    isKillChatVisible = not not visible
end

addEventHandler("onClientCharacter", root, function (character)
    if skipCharacter then
        skipCharacter = false
        return
    end
    if isTextInputActive then
        inputText = inputText .. character
        if utf8.len(inputText) > 100 then
            inputText = utf8.sub(inputText, 1, 100)
        end
    end
end)

addEventHandler("onClientKey", root, function (key, down)
    if not down then
        return
    end
    if key == "enter" then
        isTextInputActive = false
        guiSetInputEnabled(false)
        if inputText == "" or inputText == " " then
            return
        end
        if not isTimer(messageTimer) then
            triggerServerEvent("sendTeamChat", resourceRoot, inputText)
            inputText = ""
            messageTimer = setTimer(function () end, 500, 1)
        end
    elseif key == "backspace" then
        inputText = utf8.sub(inputText, 1, -2)
    elseif key == "t" then
        if isTextInputActive or guiGetInputEnabled() then
            return
        end
        guiSetInputMode("no_binds")
        if not isKillChatVisible then
            isTextInputActive = false
            guiSetInputEnabled(false)
            return
        end
        inputText = ""
        isTextInputActive = true
        skipCharacter = true
        guiSetInputEnabled(true)
    end
end)

addEvent("sendTeamChat", true)
addEventHandler("sendTeamChat", resourceRoot, function (player, msg)
    if not isElement(player) then
        return
    end
    outputMessage(string.gsub(player.name, '#%x%x%x%x%x%x', '') .. ": " .. msg)
end)

addEventHandler("onClientResourceStop", resourceRoot, function ()
    guiSetInputEnabled(false)
end)
