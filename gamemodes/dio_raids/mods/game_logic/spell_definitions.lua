--------------------------------------------------
-- class: 1 tank, 2 healer, 3 damage
-- name: string
-- icon: {x, y}
-- cooldown: seconds
-- globalCooldown:
-- type: 1 heal, 2 damage
local spells = {
    { class = 2, name = "Heal over time", icon = {0, 0}, cooldown = 0, globalCooldown = true, castTime = 0, type = 1, spreadOverTime = 15.0, baseAmount = 2000.0 },
    { class = 2, name = "Burst heal", icon = {1, 0}, cooldown = 5.0, globalCooldown = true, castTime = 0, type = 1, spreadOverTime = 0.0, baseAmount = 200.0 },
    { class = 2, name = "Burst damage", icon = {2, 0}, cooldown = 2.5, globalCooldown = true, castTime = 0, type = 2, spreadOverTime = 0.0, baseAmount = 150.0 },
    { class = 2, name = "Damage over time", icon = {3, 0}, cooldown = 0, globalCooldown = true, castTime = 0, type = 2, spreadOverTime = 20.0, baseAmount = 3000.0 },
}

return { spells = spells }
