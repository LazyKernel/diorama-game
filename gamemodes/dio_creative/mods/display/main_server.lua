--------------------------------------------------
local instance =
{
    const =
    {
        blockTag = "display",
        regularItemReach = 2.1,
    },

    owner = nil,
}

--------------------------------------------------
local connections = {}


--------------------------------------------------
local function onBlockRightClick (event, connection)

    if event.distance <= instance.const.regularItemReach then

        if owner ~= nil and owner == connection.accountId then

            dio.network.sendEvent (event.connectionId, "display", "PAINT_OPEN")

        end

        return false
    end

    return true
end


--------------------------------------------------
local function onLoad ()

    local types = dio.types.serverEvents
    --dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    --dio.events.addListener (types.ROOM_DESTROYED, onRoomDestroyed)
    dio.events.addListener (types.ENTITY_PLACED, onEntityPlaced)
    dio.events.addListener (types.ENTITY_DESTROYED, onEntityDestroyed)
    dio.events.addListener (types.CHAT_RECEIVED, onChatReceived)
    dio.events.addListener (types.NAMED_ENTITY_CREATED, onNamedEntityCreated)

end

--------------------------------------------------
local function onClientConnected (event)

    local connection =
    {
        connectionId    = event.connectionId,
        accountId       = event.accountId,
    }

    connections [event.connectionId] = connection

end

--------------------------------------------------
local function onClientDisconnected (event)

    local connection = connections [event.connectionId]
    connections [event.connectionId] = nil

end

--------------------------------------------------
local function onChatReceived (event)

    if event.text == "DIALOG_CLOSED" then

        event.cancel = true
    end
end

--------------------------------------------------
local function onEntityPlaced (event)

    if event.isBlockValid and event.pickedBlockId ~= thisblockid then

        if event.tag == blockTag then
            local connection = connections [event.connectionId]
            event.isReplacing = true
            event.cancel = onBlockRightClick (event, connection)
            return
        end
    end

    event.cancel = true
end

--------------------------------------------------
local function onEntityDestroyed (event)
    onEntityPlaced (event)
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
