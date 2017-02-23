--------------------------------------------------
local modsToLoad =
{
    {
        gameMode = "default",
        modFolder = "blocks",
        versionRequired = {major = 1, minor = 0},
    },
    {
        gameMode = "default",
        modFolder = "diagnostics",
        versionRequired = {major = 1, minor = 0},
    },
    {
        gameMode = "dio_raids",
        modFolder = "raid_characters",
        versionRequired = {major = 1, minor = 0},
    },
    {
        gameMode = "default",
        modFolder = "chat",
        versionRequired = {major = 1, minor = 0},
    },
    {
        gameMode = "default",
        modFolder = "diagnostics",
        versionRequired = {major = 1, minor = 0},
    },
}

local mods = {}

--------------------------------------------------
local function main ()

    local permissions =
    {
        blocks = true,
        drawing = true,
        diagnostics = true,
        entities = true,
        file = true,
        inputs = true,
        resources = true,
        world = true,
    }

    for _, modData in ipairs (modsToLoad) do
        local mod, error = dio.mods.loadMod (modData, permissions)
    end
end

--------------------------------------------------
main ()
