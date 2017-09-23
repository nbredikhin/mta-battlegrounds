function setVehicleRandomFuel(vehicle)
    if not isElement(vehicle) then
        return
    end
    local maxAmount = getVehicleMaxFuel(vehicle)
    local amount = math.floor(math.random(maxAmount * Config.minFuelAmount, maxAmount * Config.maxFuelAmount))
    vehicle:setData("fuel", amount)
    return amount
end

function fillVehicleFuel(vehicle, amount)
    if not isElement(vehicle) or not amount then
        return
    end
    local maxAmount = getVehicleMaxFuel(vehicle)
    local fuel = vehicle:getData("fuel") or 0
    local newFuelAmount = math.min(fuel + amount, maxAmount)
    vehicle:setData("fuel", newFuelAmount)
    return newFuelAmount
end
