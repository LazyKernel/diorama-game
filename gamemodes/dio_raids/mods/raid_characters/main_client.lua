local Classes = require ("gamemodes/dio_raids/mods/raid_characters/classes")

--------------------------------------------------
local instance = nil

--------------------------------------------------
local function onServerEventReceived (event)

end

--------------------------------------------------
local function onClientConnected (event)
    local self = instance
    if event.isMe then
        self.myConnectionId = event.connectionId
        self.myAccountId = event.accountId
    end
end

--------------------------------------------------
local function onNamedEntityCreated (event)

end

--------------------------------------------------
local function onLoad ()

    --dio.drawing.addRenderPassAfter (1, function () onLateRender (instance) end)

    instance = {}

    local types = dio.types.clientEvents
    dio.events.addListener (types.SERVER_EVENT_RECEIVED, onServerEventReceived)
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.NAMED_ENTITY_CREATED, onNamedEntityCreated)

end

--------------------------------------------------
local function onUnload ()

end

--------------------------------------------------
local modSettings =
{
    description =
    {
        name = "Raid Characters",
        description = "You can guess where this is going.",
        help =
        {
        },
    },

    permissionsRequired =
    {
        drawing = true,
        entities = true,
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
