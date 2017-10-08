local screenSize = Vector2(guiGetScreenSize())
local ui = {}

local function inviteSelectedPlayer()
    local row, column = ui.playersList:getSelectedItem()
    if not row then
        return
    end
    local name = ui.playersList:getItemData(row, column)
    if not name then
        return
    end
    local player = getPlayerFromName(name)
    if not isElement(player) then
        return
    end
    triggerServerEvent("onPlayerSendLobbyInvite", resourceRoot, player)
    ui.window.visible = false
end

local function handleSelectionChange()
    local row, column = ui.playersList:getSelectedItem()
    if not row then
        ui.inviteButton.enabled = false
        return
    end
    local name = ui.playersList:getItemData(row, column)
    if not name then
        ui.inviteButton.enabled = false
        return
    end
    local player = getPlayerFromName(name)
    if not isElement(player) then
        ui.inviteButton.enabled = false
        return
    end

    ui.inviteButton.enabled = true
end

function showInviteSendWindow()
    if ui.window.visible then
        ui.window.visible = false
        return
    end

    ui.window.visible = true

    ui.playersList:clear()
    for i, player in ipairs(getElementsByType("player")) do
        if player ~= localPlayer and not player:getData("matchId") then
            local name = string.gsub(player.name, '#%x%x%x%x%x%x', '')
            local rowIndex = ui.playersList:addRow(name)
            ui.playersList:setItemData(rowIndex, 1, player.name)
        end
    end

    handleSelectionChange()
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    local width = 350
    local height = 310
    ui.window = GuiWindow((screenSize.x - width) / 2, (screenSize.y - height) / 2, width, height, "Пригласить игрока", false)
    ui.playersList = GuiGridList(5, 25, width - 10, height - 30 - 40, false, ui.window)
    ui.playersList:setSortingEnabled(false)
    ui.playersList:addColumn("Имя игрока", 0.9)
    addEventHandler("onClientGUIClick", ui.playersList, handleSelectionChange, false)

    local buttonWidth = 140
    ui.cancelButton = GuiButton(width / 2 - 5 - buttonWidth, height - 40, buttonWidth, 30, "Отмена", false, ui.window)
    ui.inviteButton = GuiButton(width / 2 + 5, height - 40, buttonWidth, 30, "Пригласить", false, ui.window)
    addEventHandler("onClientGUIClick", ui.inviteButton, inviteSelectedPlayer, false)
    addEventHandler("onClientGUIClick", ui.cancelButton, function ()
        ui.window.visible = false
    end, false)

    ui.window.visible = false
end)
