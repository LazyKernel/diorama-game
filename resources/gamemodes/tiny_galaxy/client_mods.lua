--------------------------------------------------
local modsToLoad =
{
    {
        gameMode = "tiny_galaxy",
        modFolder = "world_logic",
    },  
    {
        gameMode = "tiny_galaxy",
        modFolder = "blocks",
    },
    {
        gameMode = "tiny_galaxy",
        modFolder = "osd",
    },
    {
        gameMode = "default",
        modFolder = "spawn",
    },
    {
        gameMode = "tiny_galaxy",
        modFolder = "dialogs",
    },
    {
        gameMode = "default",
        modFolder = "diagnostics",
    },

}

local mods = {}

--------------------------------------------------
local function main ()

    local permissions =
    {
        blocks = true,
        clientChat = true,
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