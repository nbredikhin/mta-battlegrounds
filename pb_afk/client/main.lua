local afkSeconds = 0
local afkTimer
local afkMaxTime = 300

local function addAFKTime()
    if localPlayer:getData("matchId") then
        return
    end
    afkSeconds = afkSeconds + 1
    if afkSeconds > afkMaxTime then
        triggerServerEvent("afkKickSelf", resourceRoot, "Being AFK for too long")
        afkSeconds = 0
    end
end

local function clearAFKTime()
    afkSeconds = 0
end

afkTimer = setTimer(addAFKTime, 1000, 0)
addEventHandler("onClientCursorMove", root, clearAFKTime)
addEventHandler("onClientKey", root, clearAFKTime)
