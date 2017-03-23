--------------------------------------------------
local modsToLoad =
{
    {
        gameMode = "default",
        modFolder = "blocks",
        versionRequired = {major = 1, minor = 0},
    },
    {
        gameMode = "dio_raids",
        modFolder = "game_logic",
        versionRequired = {major = 1, minor = 0},
    },
    {
        gameMode = "default",
        modFolder = "motd",
    },
}

--------------------------------------------------
local mods = {}

--------------------------------------------------
local function main ()

    local regularPermissions =
    {
        blocks = true,
        drawing = true,
        entities = true,
        file = true,
        network = true,
        session = true,
        world = true,
    }

    for _, modData in ipairs (modsToLoad) do
        local mod, error = dio.mods.loadMod (modData, regularPermissions)
    end
end

--------------------------------------------------
main ()
