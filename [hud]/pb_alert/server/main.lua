function show(player, text, time, color)
    return triggerClientEvent(player, "pbShowAlert", resourceRoot, text, time, color)
end
