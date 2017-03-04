local Classes = require ("gamemodes/dio_raids/mods/raid_characters/classes")

--------------------------------------------------
local instance = nil

--------------------------------------------------
local function onServerEventReceived (event)
    if event.name == "PLAYER_EYE_POSITION" then

        local c = dio.entities.components

        local parentEntityId = dio.entities.getComponent (event.entityId, c.PARENT).parentEntityId
        local player = dio.entities.getComponent (parentEntityId, c.TEMP_PLAYER)

        if player.connectionId == instance.myConnectionId then

            local camera =
            {
                [c.CAMERA] =
                {
                    fov = 90,
                    attachTo = event.entityId,
                    isMainCamera = true,
                },
                [c.PARENT] =                {parentEntityId = event.roomEntityId},
                [c.TRANSFORM] =             {},
            }

            local cameraEntityId = dio.entities.create (event.roomEntityId, camera)
            dio.drawing.setMainCamera (cameraEntityId)
        end
    end
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

    dio.resources.loadTexture ("CHUNKS_DIFFUSE",    "textures/chunks_diffuse_00.png")
    dio.resources.loadTexture ("LIQUIDS_DIFFUSE",   "textures/liquids_diffuse_00.png")
    dio.resources.loadTexture ("SKY_COLOUR",        "textures/sky_colour_00.png", {isNearest = false})

    dio.resources.loadExtrudedTexture ("CHUNKS_EXTRUDED",    "textures/chunks_extruded_00.png")

    instance = {}

    local types = dio.types.clientEvents
    dio.events.addListener (types.SERVER_EVENT_RECEIVED, onServerEventReceived)
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.NAMED_ENTITY_CREATED, onNamedEntityCreated)

end

--------------------------------------------------
local function onUnload ()
    dio.resources.destroyExtrudedTexture ("CHUNKS_EXTRUDED")

    dio.resources.destroyTexture ("CHUNKS_DIFFUSE")
    dio.resources.destroyTexture ("LIQUIDS_DIFFUSE")
    dio.resources.destroyTexture ("SKY_COLOUR")
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
