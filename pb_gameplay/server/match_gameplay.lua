function initMatch(match)
    match.createdTimestamp = getRealTime().timestamp

    if isResourceRunning("pb_vehicles") then
        local vehicles = exports.pb_vehicles:generateVehicles(match.dimension)
        for i, element in ipairs(vehicle) do
            addMatchElement(match, element)
        end
    end
    -- Погода
    match.settings.weather = 1
    if math.random() > 0.85 then
        match.settings.weather = 2
    end
    -- Время суток
    match.settings.hour = math.random(8, 16)
    if match.random() > 0.8 then
        match.settings.hour = math.random(0, 3)
    end
end

function updateMatch(match)
    local currentTimestamp = getRealTime().timestamp
    local matchTimePassed = currentTimestamp - match.createdTimestamp
    local stateTimePassed = currentTimestamp - match.stateTimestamp
end

function spawnMatchPlayer(match, player, position)
    if not isMatch(match) or not isElement(player) then
        return false
    end
    if match.state == "waiting" or not position then
        position = Config.waitingPosition + Vector3(math.random()-0.5, math.random()-0.5, 0) * 20
    end
    spawnPlayer(player, position)
    player.model = player:getData("skin") or 0
    player.dimension = match.dimension
end

local function setMatchRunning(match)

end

local function setMatchEnded(match)

end

function changeMatchState(match, newState)
    if not isMatch(match) then
        return false
    end
    if type(state) ~= "string" or state == match.state then
        return false
    end
    match.state = state
    match.stateTimestamp = getRealTime().timestamp

    if state == "running" then
        setMatchRunning(match)
    elseif state == "ended" then
        setMatchEnded(match)
    end
end

function handlePlayerJoinMatch(match, player)
    if not isMatch(match) or not isElement(player) then
        return
    end
    spawnMatchPlayer(match, player)
end

function handlePlayerLeaveMatch(match, player)
    if not isMatch(match) or not isElement(player) then
        return
    end
end

function handlePlayerMatchDeath(match, player, killer)
    if not isMatch(match) or not isElement(player) then
        return
    end
    if match.state == "waiting" then
        spawnMatchPlayer(match, player)
        return
    end
end
