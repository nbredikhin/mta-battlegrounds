local texture = dxCreateTexture("assets/blood.png")

local function update(particle, deltaTime)
    particle.x = particle.x + particle.vx * deltaTime
    particle.y = particle.y + particle.vy * deltaTime
    particle.z = particle.z + particle.vz * deltaTime

    particle.vx = particle.vx * 0.99
    particle.vy = particle.vy * 0.99
    particle.vz = particle.vz - 5 * deltaTime

    particle.color = tocolor(255, 255, 255, 255 * (particle.lifetime / particle.totalLifetime))
end

local function emitBlood(x, y, z)
    for i = 1, 15 do
        local size = 0.2 + math.random() * 0.4
        local particle = createParticle(texture, x, y, z, size, size, size * 0.5, update)
        particle.totalLifetime = particle.lifetime

        particle.vx = (math.random() - 0.5) * 4
        particle.vy = (math.random() - 0.5) * 4
        particle.vz = (math.random() - 0.5) * 2
    end
end

addEventHandler("onClientPlayerWeaponFire", localPlayer, function (_, _, _, x, y, z, element)
    if not element then
        return
    end
    if isElement(element) and element.type == "ped" or element.type == "player" then
        emitBlood(x, y, z + 0.18)
        element.health = 100
    end
end)
