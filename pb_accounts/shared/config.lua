Config = {}

Config.rewardCrate = "crate_weekly1"
Config.rewardPrices = {
    100,
    200,
    300,
    400,
    500
}

function getRewardCrateName()
    return Config.rewardCrate
end

function getRewardPrice(level)
    if type(level) ~= "number" then
        return
    end
    level = math.min(#Config.rewardPrices, level)
    level = math.max(1, level)
    return Config.rewardPrices[level]
end
