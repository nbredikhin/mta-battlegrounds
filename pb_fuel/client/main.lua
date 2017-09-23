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
        consumedFuel = consumedFuel + 2.5
        isAccelerating = true
    end
    if getControlState("brake_reverse") then
        consumedFuel = consumedFuel + 1
        isAccelerating = true
    end

    if isAccelerating and getControlState("vehicle_left") or getControlState("vehicle_right") then
        consumedFuel = consumedFuel + 0.5
    end

    if isAccelerating and getControlState("handbrake ") then
        consumedFuel = consumedFuel + 0.5
    end
    if not vehicle.onGround then
        consumedFuel = math.min(consumedFuel, 0.5)
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
