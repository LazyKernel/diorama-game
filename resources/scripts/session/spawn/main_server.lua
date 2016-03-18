--------------------------------------------------
local connections = {}

--------------------------------------------------
local function onPlayerLoad (event)

    local filename = "player_" .. event.playerName .. ".lua"
    local settings = dio.file.loadLua (filename)

    local isPasswordCorrect = true
    if settings then
        isPasswordCorrect = (settings.password == event.password)
    end

    local connection =
    {
        connectionId = event.connectionId,
        groupId = event.isSinglePlayer and "builder" or "tourist",
        isPasswordCorrect = isPasswordCorrect,
    }

    if settings and isPasswordCorrect then
        connection.homeLocation = settings.homeLocation
        connection.needsSaving = true
    end

    connections [event.connectionId] = connection
end

--------------------------------------------------
local function onPlayerSave (event)

    local connection = connections [event.connectionId]

    if connection.needsSaving and connection.homeLocation then

        local filename = "player_" .. event.playerName .. ".lua"
        local settings = dio.file.loadLua (filename)
        if settings then
            settings.homeLocation = connection.homeLocation
            dio.file.saveLua (filename, settings, "settings")
        end
    end

    connections [event.connectionId] = nil
end

--------------------------------------------------
local function onChatReceived (event)

    if event.text:sub (1, 1) ~= "." then
        return
    end

    if event.text == ".home" then

        local connection = connections [event.authorConnectionId]

        if connection.homeLocation then
            local t = connection.homeLocation
            event.author = ".home"
            event.text = 
                tostring (t.chunkId.x * 16 + t.xyz.x) .. " " .. 
                tostring (t.xyz.y) .. " " .. 
                tostring (t.chunkId.z * 16 + t.xyz.z)
        else
            event.author = "SERVER"
            event.text = "No home position set."
        end

        event.targetConnectionId = event.authorConnectionId

    elseif event.text == ".setHome" then

        homeLocation = dio.world.getPlayerXyz (event.author)
        if homeLocation then
            local connection = connections [event.authorConnectionId]
            connection.homeLocation = homeLocation
    
            event.text = "Home successfully set."

        else
            event.text = "Home NOT successfully set."
        end

        event.author = "SERVER"
        event.targetConnectionId = event.authorConnectionId
    end
end

--------------------------------------------------
local function onLoadSuccessful ()

    local types = dio.events.types
    dio.events.addListener (types.SERVER_PLAYER_LOAD, onPlayerLoad)
    dio.events.addListener (types.SERVER_PLAYER_SAVE, onPlayerSave)
    dio.events.addListener (types.SERVER_CHAT_RECEIVED, onChatReceived)
end

--------------------------------------------------
local modSettings = 
{
    description =
    {
        name = "Spawn",
        description = "Coordinate related shenanigans",
    },

    permissionsRequired = 
    {
        player = true,
        file = true,
    },
}

--------------------------------------------------
return modSettings, onLoadSuccessful