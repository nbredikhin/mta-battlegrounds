function getRandomPoint(radius)
    local a = math.random()
    local b = math.random()
    return b*radius*math.cos(2*math.pi*a/b), b*radius*math.sin(2*math.pi*a/b)
end
