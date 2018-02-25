local particles = {}

function createParticle(material, x, y, z, width, height, lifetime, update)
    local particle = {
        x = x,
        y = y,
        z = z,
        width = width,
        height = height,
        -- vx = 0,
        -- vy = 0,
        -- vz = 0,
        material = material,
        lifetime = lifetime,
        update = update,
        color = tocolor(255, 255, 255),
    }
    table.insert(particles, particle)
    return particle
end

local function updateParticle(particle, deltaTime)
    particle.update(particle, deltaTime)
    local h2 = particle.height/2
    dxDrawMaterialLine3D(particle.x, particle.y, particle.z+h2, particle.x, particle.y, particle.z-h2, particle.material, particle.width, particle.color)
end

addEventHandler("onClientPreRender", root, function (deltaTime)
    deltaTime = deltaTime / 1000
    for i = #particles, 1, -1 do
        local particle = particles[i]
        updateParticle(particle, deltaTime)
        particle.lifetime = particle.lifetime - deltaTime
        if particle.lifetime <= 0 then
            table.remove(particles, i)
        end
    end

    -- dxDrawText(#particles, 100, 500)
end)
