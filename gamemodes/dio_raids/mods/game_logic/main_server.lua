local Classes = require ("gamemodes/dio_raids/mods/game_logic/classes")
local SpellDefinitions = require ("gamemodes/dio_raids/mods/game_logic/spell_definitions")

--------------------------------------------------
local instance =
{
    isPlaying = false,
    connections = {},
    connectionsCount = 0,
    readyCount = 0,
    roomEntityIds = {},
    roundTimeLeft = 0,
    timePerRound = 60 * 3,
    livesPerPlayer = 5,
    rocketEntityIds = {},
    nextRoundCanBePlayed = true,
}

--------------------------------------------------
local spells = SpellDefinitions.spells

--------------------------------------------------
local generators =
{

}

--------------------------------------------------
local roomSettings =
{

}

-- words: array of words
-- numberWordsIgnored: number of words to ignore from the beginning
local function getRemainingWords (words, numberWordsIgnored)
    local wordsAfterCommand = words [numberWordsIgnored + 1]
    for i = numberWordsIgnored + 2, #words do
        wordsAfterCommand = wordsAfterCommand .. " " .. words [i]
    end
    return wordsAfterCommand
end

--------------------------------------------------
local function getConnectionByName (name)
    for connectionId, connection in pairs(instance.connections) do
        if connection.playerName == name then
            return connection
        end
    end
end

--------------------------------------------------
local function comparer (lhs, rhs)

    if lhs.kills == rhs.kills then
        if lhs.deaths == rhs.deaths then
            return lhs.accountId < rhs.accountId
        else
            return (lhs.deaths < rhs.deaths)
        end
    else
        return (lhs.kills > rhs.kills)
    end
end

--------------------------------------------------
local function broadcastScore (connectionId)

    local scores = {}
    for _, record in pairs (instance.connections) do
        table.insert (scores, record)
    end

    table.sort (scores, comparer)

    local text = ""
    for _, score in ipairs (scores) do

        text = text ..
                score.accountId ..
                ":" ..
                tostring (score.kills) ..
                ":" ..
                tostring (score.deaths) ..
                ":"
    end

    if connectionId then
        dio.network.sendEvent (connectionId, "voxel_arena.SCORE_UPDATE", text)
    else
        for _, connection in pairs (instance.connections) do
            dio.network.sendEvent (connection.connectionId, "voxel_arena.SCORE_UPDATE", text)
        end
    end

    return scores [1]
end

--------------------------------------------------
local function getCurrentRoomFolder ()
    return "world/"--instance.isPlaying and "arena/" or "waiting_room/"
end

--------------------------------------------------
local function createPlayerEntity (connectionId, accountId)

    local roomFolder = getCurrentRoomFolder ()
    local roomEntityId = dio.world.ensureRoomIsLoaded (roomFolder)

    local chunkId = {0, 0, 0}
    local xyz = {0.5, 0, 0.5}

    if instance.isPlaying then
        local chunkRadius = 0
        chunkId = {math.random (-chunkRadius, chunkRadius), 0, math.random (-chunkRadius, chunkRadius)}
        xyz = {math.random (0, 31) + 0.5, chunkRadius * 32 + 24, math.random (0, 31) + 0.5}
    end


    local components = dio.entities.components
    local playerComponents =
    {
            -- [components.AABB_COLLIDER] =        {min = {-0.01, -0.01, -0.01}, size = {0.02, 0.02, 0.02},},
            -- [components.COLLISION_LISTENER] =   {onCollision = onRocketAndSceneryCollision,},
            -- [components.MESH_PLACEHOLDER] =     {blueprintId = "ROCKET",},
            -- [components.RIGID_BODY] =           {acceleration = {0.0, -9.806 * 1.0, 0.0},},

        [components.BASE_NETWORK] =         {},
        [components.CHILD_IDS] =            {},
        [components.FOCUS] =                {connectionId = connectionId, radius = 4},
        [components.GRAVITY_TRANSFORM] =
        {
            chunkId =       chunkId,
            xyz =           xyz,
            ypr =           {0, 0, 0},
            gravityDir =    5,
        },
        [components.NAME] =                 {name = "PLAYER", debug = false}, -- temp for debugging
        [components.PARENT] =               {parentEntityId = roomEntityId},
        [components.SERVER_CHARACTER_CONTROLLER] =
        {
            connectionId = connectionId,
            accountId = accountId,
        },
        [components.TEMP_PLAYER] =          {connectionId = connectionId, accountId = accountId},
    }

    local playerEntityId = dio.entities.create (roomEntityId, playerComponents)

    local eyeComponents =
    {
        [components.BROADCAST_WITH_PARENT] =    {},
        [components.CHILD_IDS] =                {},
        [components.NAME] =                     {name = "PLAYER_EYE_POSITION"},
        [components.PARENT] =                   {parentEntityId = playerEntityId},
        [components.TRANSFORM] =                {},
    }

    local eyeEntityId = dio.entities.create (roomEntityId, eyeComponents)

    return playerEntityId, eyeEntityId
end

--------------------------------------------------
local function calcDistanceSqr (chunkIdA, xyzA, chunkIdB, xyzB)
    local chunkSize = 32
    local x = (chunkIdA [1] * chunkSize + xyzA [1]) - (chunkIdB [1] * 32 + xyzB [1])
    local y = (chunkIdA [2] * chunkSize + xyzA [2]) - (chunkIdB [2] * 32 + xyzB [2])
    local z = (chunkIdA [3] * chunkSize + xyzA [3]) - (chunkIdB [3] * 32 + xyzB [3])
    return x * x + y * y + z * z
end

--------------------------------------------------
local function onRocketAndSceneryCollision (event)

    -- dio.entities.destroy (event.entity)

    --[[local payload =
            tostring (event.roomEntityId) .. ":" ..
            tostring (event.chunkId [1]) .. ":" ..
            tostring (event.chunkId [2]) .. ":" ..
            tostring (event.chunkId [3]) .. ":" ..
            tostring (event.xyz [1]) .. ":" ..
            tostring (event.xyz [2]) .. ":" ..
            tostring (event.xyz [3])

    for _, connection in pairs (instance.connections) do

        dio.network.sendEvent (
                connection.connectionId,
                "voxel_arena.EXPLOSION",
                payload);
    end

    local wasScoreUpdated = false
    local rocketFiredBy = instance.rocketEntityIds [event.entityId]

    if rocketFiredBy then

        for _, connection in pairs (instance.connections) do
            local player = dio.world.getPlayerXyz (connection.accountId)
            local distanceSqr = calcDistanceSqr (event.chunkId, event.xyz, player.chunkId, player.xyz)

            if distanceSqr < (4 * 4) then

                connection.livesLeft = connection.livesLeft - 1

                if connection.livesLeft == 0 then

                    local deathText = connection.accountId .. " was killed by " .. rocketFiredBy.accountId
                    local isSuicide = false

                    if connection == rocketFiredBy then
                        isSuicide = true
                        deathText = connection.accountId .. " killed themself"
                    end

                    for _, connection2 in pairs (instance.connections) do
                        dio.network.sendChat (
                                connection2.connectionId,
                                "SERVER",
                                deathText)
                    end

                    connection.livesLeft = instance.livesPerPlayer
                    dio.entities.destroy (connection.entityId)
                    local entityId, eyeEntityId = createPlayerEntity (connection.connectionId, connection.accountId)
                    connection.entityId = entityId
                    connection.eyeEntityId = eyeEntityId

                    connection.deaths = connection.deaths + 1
                    if not isSuicide then
                        rocketFiredBy.kills = rocketFiredBy.kills + 1
                    end
                    wasScoreUpdated = true

                end

                dio.network.sendEvent (connection.connectionId, "voxel_arena.HEALTH_UPDATE", tostring (connection.livesLeft))

            end
        end
    end

    if wasScoreUpdated then
        broadcastScore ()
    end

    instance.rocketEntityIds [event.entityId] = nil]]
end

--------------------------------------------------
local function createRocketEntity (roomEntityId, chunkId, xyz, ypr)

end

--------------------------------------------------
local function createRandomSeed ()
    local seed = "seed" .. tostring (math.random ())
    return seed
end

--------------------------------------------------
local function modifyRoomSeed ()

end

--------------------------------------------------
local function checkForRoundStart (connectionId)

    --[[if instance.readyCount > instance.connectionsCount / 2 then
    --if instance.readyCount > 1 and instance.readyCount > instance.connectionsCount / 2 then

        dio.file.deleteRoom ("arena/")

        dio.file.copyFolder ("arena/", dio.file.locations.MOD_RESOURCES, "new_saves/default/arena/")
        modifyRoomSeed ()

        instance.isPlaying = true
        instance.readyCount = 0
        instance.roundTimeLeft = instance.timePerRound

        for _, connection in pairs (instance.connections) do

            dio.network.sendEvent (connection.connectionId, "voxel_arena.BEGIN_GAME", tostring (instance.roundTimeLeft))
            dio.network.sendEvent (connection.connectionId, "voxel_arena.HEALTH_UPDATE", tostring (instance.livesPerPlayer))

            dio.entities.destroy (connection.entityId)
            local entityId, eyeEntityId = createPlayerEntity (connection.connectionId, connection.accountId)
            connection.entityId = entityId
            connection.eyeEntityId = eyeEntityId
            connection.isReady = false
            connection.kills = 0
            connection.deaths = 0
        end

        broadcastScore ()

        instance.nextRoundCanBePlayed = false
    end]]
end

--------------------------------------------------
local function doGameOver ()
    --[[instance.roundTimeLeft = 0
    instance.isPlaying = false

    local winning_connection = broadcastScore ()
    local winning_text = "The winner is " .. winning_connection.accountId

    for _, connection in pairs (instance.connections) do

        dio.network.sendEvent (connection.connectionId, "voxel_arena.END_GAME")

        dio.entities.destroy (connection.entityId)
        local entityId, eyeEntityId = createPlayerEntity (connection.connectionId, connection.accountId)
        connection.entityId = entityId
        connection.eyeEntityId = eyeEntityId

        dio.network.sendChat (connection.connectionId, "SERVER", winning_text)
    end

    instance.rocketEntityIds = {}]]
end

--------------------------------------------------
local function onClientConnected (event)

    local entityId, eyeEntityId = createPlayerEntity (event.connectionId, event.accountId)

    local connection =
    {
        connectionId = event.connectionId,
        accountId = event.accountId,
        playerName = nil,
        entityId = entityId,
        eyeEntityId = eyeEntityId,
        kills = 0,
        deaths = 0,
        livesLeft = instance.livesPerPlayer,
        --
        class = nil,
        target = nil,
        buffs = {},
        debuffs = {},
    }

    instance.connections [event.connectionId] = connection
    instance.connectionsCount = instance.connectionsCount + 1

    if instance.isPlaying then
        dio.network.sendEvent (connection.connectionId, "voxel_arena.JOIN_GAME", tostring (instance.roundTimeLeft))
        dio.network.sendEvent (connection.connectionId, "voxel_arena.HEALTH_UPDATE", tostring (instance.livesPerPlayer))
    else
        dio.network.sendEvent (connection.connectionId, "voxel_arena.JOIN_WAITING_ROOM")
    end

    broadcastScore ()
end

--------------------------------------------------
local function onClientDisconnected (event)

    local connection = instance.connections [event.connectionId]
    dio.entities.destroy (connection.entityId)
    instance.connections [event.connectionId] = nil

    instance.connectionsCount = instance.connectionsCount - 1

    if connection.isReady then
        instance.readyCount = instance.readyCount - 1
    end

    -- check if the game now has zero players
    if instance.connectionsCount == 0 then
        instance.isPlaying = false
    end

    --broadcastScore ()

    checkForRoundStart (event.connectionId)
end

--------------------------------------------------
local function fireWeapon (connection)

    --[[local roomEntityId = instance.roomEntityIds [getCurrentRoomFolder ()]

    local avatar = dio.world.getPlayerXyz (connection.accountId)
    local chunkId = avatar.chunkId
    local xyz = avatar.xyz
    local ypr = avatar.ypr

    local eyeTransform = dio.entities.getComponent (connection.eyeEntityId, dio.entities.components.TRANSFORM)
    xyz [2] = xyz [2] + eyeTransform.xyz [2]
    ypr [1] = eyeTransform.ypr [1]

    local rocketEntityId = createRocketEntity (roomEntityId, chunkId, xyz, ypr)
    instance.rocketEntityIds [rocketEntityId] = connection]]
end

--------------------------------------------------
local function onPlayerPrimaryAction (event)

    --[[local connection = instance.connections [event.connectionId]

    if instance.isPlaying then

        fireWeapon (connection)

    else
        if event.isBlockValid and event.pickedBlockId == 18 then -- READY button
            if connection.isReady then

                dio.network.sendChat (connection.connectionId, "SERVER", "You are already READY")

            elseif instance.nextRoundCanBePlayed then

                dio.network.sendChat (connection.connectionId, "SERVER", "You are now READY")

                instance.readyCount = instance.readyCount + 1
                connection.isReady = true
                checkForRoundStart (event.connectionId)

            else

                dio.network.sendChat (connection.connectionId, "SERVER", "You are NOT READY. Please try again in a few seconds!")

            end
        end
    end]]

    event.cancel = true
end

--------------------------------------------------
local function onPlayerSecondaryAction (event)
    -- if event.isBlockValid then
    --     event.replacementBlockId = 10 -- jump pad
    -- end
    event.cancel = true
end

--------------------------------------------------
local function onRoomCreated (event)

    --[[instance.roomEntityIds [event.roomFolder] = event.roomEntityId

    local roomSettings = roomSettings [event.roomFolder]

    local components = dio.entities.components
    local calendarEntity =
    {
        [components.BASE_NETWORK] =
        {
        },
        [components.CALENDAR] =
        {
            time =  roomSettings.time,
            timeMultiplier = roomSettings.timeMultiplier,
        },
        [components.NAME] =
        {
            name = "CALENDAR",
            debug = false,
        },
        [components.PARENT] =
        {
            parentEntityId = event.roomEntityId,
        },
    }

    local calendarEntityId = dio.entities.create (event.roomEntityId, calendarEntity)]]
end

--------------------------------------------------
local function onRoomDestroyed (event)

end

--------------------------------------------------
local function onServerTick (event)

end

--------------------------------------------------
local function castSpell (casterConnection, spellId)
    local spell = spells [spellId]

    if casterConnection.class.role ~= spell.class then
        return
    end


end

--------------------------------------------------
local function onChatReceived (event)

    if event.text:sub (1, 1) ~= "." then
        return
    end

    local words = {}
    for word in string.gmatch(event.text, "[^ ]+") do
        table.insert (words, word)
    end

    local connectionId = event.authorConnectionId
    local connection = instance.connections [connectionId]

    if words [1] == ".init" and #words >= 3 then
        if words [2] == "tank" then
            connection.class = Classes.tank ()
            connection.playerName = getRemainingWords (words, 2)
            dio.network.sendChat (connection.connectionId, "SERVER", "Initialized " .. connection.playerName .. " as a tank.")

        elseif words [2] == "damage" then
            connection.class = Classes.damage ()
            connection.playerName = getRemainingWords (words, 2)
            dio.network.sendChat (connection.connectionId, "SERVER", "Initialized " .. connection.playerName .. " as a damage.")

        elseif words [2] == "healer" then
            connection.class = Classes.healer ()
            connection.playerName = getRemainingWords (words, 2)
            dio.network.sendChat (connection.connectionId, "SERVER", "Initialized " .. connection.playerName .. " as a healer.")

        else
            return
        end

    elseif words [1] == ".target" then
        if #words <= 1 then
            dio.network.sendChat (connection.connectionId, "SERVER", "Your target was cleared.")
            connection.target = nil
        else
            local targetName = getRemainingWords (words, 1)
            local targetConnection = getConnectionByName (targetName)
            connection.target = targetConnection
            dio.network.sendChat (connection.connectionId, "SERVER", "Your target is now " .. targetConnection.playerName)
        end

        event.cancel = true

    elseif words [1] == ".cast" then
        if #words <= 1 then
            dio.network.sendChat (connection.connectionId, "SERVER", "No spell id specified.")
        else
            local spellId = tonumber (getRemainingWords (words, 1))
            local spell = spells [spellId]

            print ("attempting to cast a spell")
            print ("spell id: " .. spellId)
            print ("spell table:")
            for k, v in pairs (spell) do
                print(k, v)
            end
            print ("class id: " .. spell.class)
            print ("conn class id: " .. connection.class.role)
            if spell ~= nil then
                if spell.class == connection.class.role then
                    if spell.type == 1 then -- heal
                        -- TODO: Check if enemy
                        if spell.spreadOverTime == 0.0 then
                            -- TODO: add gear stat modifiers, buffs etc.
                            connection.target.class.health = connection.target.class.health + spell.baseAmount
                            if connection.target.class.health > connection.target.class.maxHealth then
                                connection.target.class.health = connection.target.class.maxHealth
                            end
                        else
                            table.insert (connection.target.buffs, { spell = spell, timeElapsed = 0.0 })
                        end
                    elseif spell.type == 2 then -- damage
                        if spell.spreadOverTime == 0.0 then
                            -- TODO: add gear stat modifiers, buffs etc.
                            connection.target.class.health = connection.target.class.health - spell.baseAmount
                            if connection.target.class.health <= 0 then
                                connection.target.class.health = 0
                                -- TODO: death comes for you
                            end
                        else
                            table.insert (connection.target.debuffs, { spell = spell, timeElapsed = 0.0 })
                        end
                    end

                    dio.network.sendChat (connection.connectionId, "SERVER", connection.target.playerName .. ": " .. connection.target.class.health)
                end
            end
        end

        event.cancel = true

    end
end

--------------------------------------------------
local function onLoad ()

    local types = dio.types.serverEvents
    dio.events.addListener (types.CLIENT_CONNECTED, onClientConnected)
    dio.events.addListener (types.CLIENT_DISCONNECTED, onClientDisconnected)
    dio.events.addListener (types.ENTITY_PLACED, onPlayerPrimaryAction)
    dio.events.addListener (types.ENTITY_DESTROYED, onPlayerSecondaryAction)
    dio.events.addListener (types.ROOM_CREATED, onRoomCreated)
    dio.events.addListener (types.ROOM_DESTROYED, onRoomDestroyed)
    dio.events.addListener (types.TICK, onServerTick)
    dio.events.addListener (types.CHAT_RECEIVED, onChatReceived)

    math.randomseed (os.time ())

end

--------------------------------------------------
local modSettings =
{
    description =
    {
        name = "Raid Characters",
        description = "Are YOU prepared?",
    },

    permissionsRequired =
    {
        entities = true,
        events = true,
        file = true,
        network = true,
        session = true,
        world = true,
    },

    callbacks =
    {
        onLoad = onLoad,
    },
}

--------------------------------------------------
return modSettings
