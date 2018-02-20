local texture = dxCreateTexture("assets/smoke.png")
local emitTime = 0.01

local function update(particle, deltaTime)
    particle.x = particle.x + particle.vx * deltaTime
    particle.y = particle.y + particle.vy * deltaTime
    particle.z = particle.z + particle.vz * deltaTime

    -- particle.vx = particle.vx * 0.99
    -- particle.vy = particle.vy * 0.99
    -- particle.vz = particle.vz - 5 * deltaTime
    particle.width = particle.width + deltaTime * 0.1
    particle.height = particle.height + deltaTime * 0.1

    particle.color = tocolor(255, 0, 0, 255 * (particle.lifetime / particle.totalLifetime))
end

local function emitSmoke(x, y, z)
    local size = 0.2 + math.random() * 2
    local particle = createParticle(texture, x, y, z, size, size, size * 8, update)
    particle.totalLifetime = particle.lifetime

    particle.vx = (math.random() - 0.5) * 0.4
    particle.vy = (math.random() - 0.5) * 0.4
    particle.vz = 0.5 + 0.5 * math.random()
end

addEventHandler("onClientPreRender", root, function (deltaTime)
    deltaTime = deltaTime / 1000
    emitTime = emitTime - deltaTime
    if emitTime < 0 then
        emitSmoke(-532.956, -1986.225, 46.650)
        emitTime = 0.1
    end
end)

local object = createObject(1860, -532.956, -1986.225, 45.650)
