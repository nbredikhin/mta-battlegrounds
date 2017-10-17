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
    hideInviteSendWindow()
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

function hideInviteSendWindow()
    ui.window.visible = false
    exports.pb_killchat:setVisible(true)
end

function updatePlayersList()
    if not ui.window.visible then
        return
    end

    ui.playersList:clear()
    local searchText = string.lower(ui.searchEdit.text)
    for i, player in ipairs(getElementsByType("player")) do
        if player ~= localPlayer and not player:getData("matchId") then
            if string.find(string.lower(player.name), searchText) then
                local name = string.gsub(player.name, '#%x%x%x%x%x%x', '')
                local rowIndex = ui.playersList:addRow(name)
                ui.playersList:setItemData(rowIndex, 1, player.name)
                if player:getData("lobbyOwner") ~= player then
                    guiGridListSetItemColor(ui.playersList, rowIndex, 1, 100, 100, 100)
                end
            end
        end
    end

    handleSelectionChange()
end

function showInviteSendWindow()
    if ui.window.visible then
        hideInviteSendWindow()
        return
    end

    ui.window.visible = true
    exports.pb_killchat:setVisible(false)
    updatePlayersList()
    ui.searchEdit.text = ""
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    local width = 350
    local height = 310
    ui.window = GuiWindow((screenSize.x - width) / 2, (screenSize.y - height) / 2, width, height, "Invite player", false)
    ui.searchEdit = GuiEdit(5, 25, width - 10, 25, "", false, ui.window)
    addEventHandler("onClientGUIChanged", ui.searchEdit, updatePlayersList)

    ui.playersList = GuiGridList(5, 55, width - 10, height - 30 - 40 - 30, false, ui.window)
    ui.playersList:setSortingEnabled(false)
    ui.playersList:addColumn("Name", 0.9)
    addEventHandler("onClientGUIClick", ui.playersList, handleSelectionChange, false)

    local buttonWidth = 140
    ui.cancelButton = GuiButton(width / 2 - 5 - buttonWidth, height - 40, buttonWidth, 30, "Cancel", false, ui.window)
    ui.inviteButton = GuiButton(width / 2 + 5, height - 40, buttonWidth, 30, "Invite", false, ui.window)
    addEventHandler("onClientGUIClick", ui.inviteButton, inviteSelectedPlayer, false)
    addEventHandler("onClientGUIClick", ui.cancelButton, function ()
        hideInviteSendWindow()
    end, false)

    ui.window.visible = false
end)
