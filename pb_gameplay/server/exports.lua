function getAliveMatchPlayers(matchId)
    local match = getMatchById(matchId)
    return getMatchAlivePlayers(match)
end

function getAllMatchPlayers(matchId)
    local match = getMatchById(matchId)
    return getMatchPlayers(match)
end
