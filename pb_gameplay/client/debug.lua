local isVisible = false
local list = {}

addEventHandler("onClientRender", root, function ()
    if not isVisible then
        return
    end

    local x = 50
    local y = 500
    dxDrawText("Running matches ("..tostring(#list) .."):", x, y)
    y = y + 18
    dxDrawLine(x, y, x + 125, y)
    y = y + 5
    for i, match in ipairs(list) do
        local str = "Match ("
            .. tostring(match.id) .. ") [ "
            .. "dimension="..tostring(match.dimension) .. ", "
            .. "players_total="..tostring(match.players_total) .. ", "
            .. "players_count="..tostring(match.players_count) .. ", "
            .. "players_max="..tostring(match.players_max) .. ", "
            .. "state="..tostring(match.state) .. ", "
            .. "squads_total="..tostring(match.squads_total) .. ", "
            .. "squads_count="..tostring(match.squads_count) .. ", "
            .. "time="..tostring(match.totalTime) .. " ]"
        dxDrawText(str, x, y)
        y = y + 25
    end
end)

addEvent("requireMatchesList", true)
addEventHandler("requireMatchesList", resourceRoot, function (t)
    if type(t) == "table" then
        list = t
    end
end)

addCommandHandler("matchdebug", function ()
    isVisible = not isVisible
    triggerServerEvent("requireMatchesList", resourceRoot)
end)

setTimer(function ()
    if isVisible then
        triggerServerEvent("requireMatchesList", resourceRoot)
    end
end, 1000, 0)
