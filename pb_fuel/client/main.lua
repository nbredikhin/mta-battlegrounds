local isNitroEnabled = false

setTimer(function ()
    local vehicle = localPlayer.vehicle
    if not vehicle or vehicle.controller ~= localPlayer then
        return
    end
    if not vehicle.engineState then
        return
    end
    local fuelAmount = vehicle:getData("fuel")
    if not fuelAmount then
        fuelAmount = 0
        vehicle.engineState = false
        vehicle:setData("fuel", 0)
        return
    end

    local consumedFuel = 0
    local isAccelerating = false
    if getControlState("accelerate") then
        consumedFuel = consumedFuel + 3
        isAccelerating = true
    end
    if getControlState("brake_reverse") then
        consumedFuel = consumedFuel + 1.5
        isAccelerating = true
    end

    if isAccelerating and getControlState("vehicle_left") or getControlState("vehicle_right") then
        consumedFuel = consumedFuel + 0.5
    end

    if isAccelerating and getControlState("handbrake ") then
        consumedFuel = consumedFuel + 0.5
    end
    if getVehicleType(vehicle) ~= "Boat" and not vehicle.onGround then
        consumedFuel = math.min(consumedFuel, 0.5)
    end
    if isNitroEnabled then
        consumedFuel = consumedFuel * 1.4
    end

    fuelAmount = fuelAmount - consumedFuel
    if fuelAmount < 0 then
        fuelAmount = 0
        vehicle.engineState = false
    else
        vehicle.engineState = true
    end
    vehicle:setData("fuel", fuelAmount)
end, 2000, 0)

addEventHandler("onClientPlayerVehicleEnter", localPlayer, function (vehicle)
    local fuelAmount = vehicle:getData("fuel")
    if not fuelAmount or fuelAmount == 0 then
        vehicle.engineState = false
    end
end)

addEventHandler("onClientKey", root, function (key, down)
    if key ~= "lshift" then
        return
    end
    local vehicle = localPlayer.vehicle
    if vehicle and vehicle.controller == localPlayer then
        if not down then
            removeVehicleUpgrade(vehicle, 1010)
            localPlayer:setControlState("vehicle_fire", false)
        else
            addVehicleUpgrade(vehicle, 1010)
            localPlayer:setControlState("vehicle_fire", true)
        end
        isNitroEnabled = down
    end
end)
