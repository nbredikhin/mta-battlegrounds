Config = {}

-- Курс донат очков к БП
Config.donatepointsToBattlepoints = 10

Config.rewardCrates = {
    "crate_weekly1",
    "crate_weekly2",
}

Config.rewardPrices = {
    450,
    900,
    1800,
    2700,
    3600
}

function getRewardPrice(level)
    if type(level) ~= "number" then
        return
    end
    level = math.min(#Config.rewardPrices, level)
    level = math.max(1, level)
    return Config.rewardPrices[level]
end
