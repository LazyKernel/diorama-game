--------------------------------------------------
local instance = nil

local model =
{
    id = "display",
    filename = "models/display.vox",
    options = {},
}

--------------------------------------------------
local function onLoad ()

    instance =
    {

    }

    dio.resources.loadMediumModel (model.id, model.filename, model.options)

end

--------------------------------------------------
local function onUnload ()

    dio.resources.destroyMediumModel (model.id)

end

--------------------------------------------------
local function onServerEventReceived (event)

    if event.id == "display" then

        if event.payload == "PAINT_OPEN" then

            -- TODO: Open paint

        end

    end

end



--------------------------------------------------
local modSettings =
{
    name = "Display",

    description = "Adds a display block with modifiable image.",

    permissionsRequired =
    {
        blocks = true,
        drawing = true,
        inputs = true,
        resources = true,
        world = true,
    },

    callbacks =
    {
        onLoad = onLoad,
        onUnload = onUnload,
    },
}

--------------------------------------------------
return modSettings
