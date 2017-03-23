--------------------------------------------------
local s = {}

--------------------------------------------------
s.role = {
    unassigned = 0,
    tank = 1,
    healer = 2,
    damage = 3
}

--[[
--------------------------------------------------
s.character = {
    health = 1000,
    healthMultiplier = 1.0,

    takenDamageMultiplier = 1.0,

    energy = 100,
    energyMultiplier = 1.0,

    spellPowerMultiplier = 1.0,

    role = s.role.unassigned,
}

--------------------------------------------------
s.tank = {
    character = s.character,
    character.health = 4000,
    character.takenDamageMultiplier = 0.5,
    character.role = s.role.tank,
}

--------------------------------------------------
s.damage = {
    character = s.character,
    character.spellPowerMultiplier = 1.25,
    character.role = s.role.damage,
}

--------------------------------------------------
s.healer = {
    character = s.character,
    character.health = 900,
    character.spellPowerMultiplier = 1.1,
    character.energy = 200,
    character.role = s.role.healer,
}
]]

--------------------------------------------------
function s.tank ()
    local character = {
        health = 4000,
        healthMultiplier = 1.0,

        takenDamageMultiplier = 0.5,

        energy = 100,
        energyMultiplier = 1.0,

        spellPowerMultiplier = 1.0,

        role = s.role.tank,
    }
    return character
end

--------------------------------------------------
function s.damage ()
    local character = {
        health = 1000,
        healthMultiplier = 1.0,

        takenDamageMultiplier = 1.0,

        energy = 100,
        energyMultiplier = 1.0,

        spellPowerMultiplier = 1.25,

        role = s.role.damage,
    }
    return character
end

--------------------------------------------------
function s.healer ()
    local character = {
        health = 900,
        healthMultiplier = 1.0,

        takenDamageMultiplier = 1.0,

        energy = 200,
        energyMultiplier = 1.0,

        spellPowerMultiplier = 1.1,

        role = s.role.healer,
    }
    return character
end


return s
