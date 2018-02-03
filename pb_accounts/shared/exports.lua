function convertDonatepoints(amount)
    if type(amount) ~= "number" then
        return 0
    end
    return amount * Config.donatepointsToBattlepoints
end
