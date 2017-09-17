local screenSize = Vector2(guiGetScreenSize())
local isKillChatVisible = false
local chatX = 25
local chatY = screenSize.y - 190

local messagesList = {}

local messageLifetime = 8
local messageFadeTime = 1.5

local messageScale = 1.5

function outputMessage(text, info, isHighlight)
    table.insert(messagesList, 1, {
        text = text,
        info = info,
        time = messageLifetime,
        isHighlight = isHighlight
    })
end

addEvent("onMatchPlayerWasted", true)
addEventHandler("onMatchPlayerWasted", root, function (aliveCount, killerPlayer, weaponId)
    if not isElement(killerPlayer) then
        return
    end
    local weaponName = exports.pb_inventory:getWeaponNameFromId(weaponId)
    local killerName = string.gsub(killerPlayer.name, '#%x%x%x%x%x%x', '')
    local wastedName = string.gsub(source.name, '#%x%x%x%x%x%x', '')
    local message = "Игрок "..killerName.." убивает игрока "..wastedName
    if weaponName then
        message = message .. ", используя "..weaponName
    end
    local aliveText = " - " .. tostring(aliveCount) .. " в живых"
    if aliveCount == 1 then
        aliveText = "МАТЧ ЗАВЕРШЕН"
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

    if isKillChatVisible then
        messagesList = {}
    end
end