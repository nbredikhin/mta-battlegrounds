Config = {}

Config.rewardCrates = {
    "crate_weekly1",
    "crate_weekly2",
}

Config.rewardPrices = {
    100,
    200,
    300,
    400,
    500
}

function getRewardPrice(level)
    if type(level) ~= "number" then
        return
    end
    level = math.min(#Config.rewardPrices, level)
    level = math.max(1, level)
    return Config.rewardPrices[level]
end
