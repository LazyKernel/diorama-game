local SpellDefinitions = require ("gamemodes/dio_raids/mods/game_logic/spell_definitions")
local Window = require ("resources/scripts/utils/window")

--------------------------------------------------
local s = {}

--------------------------------------------------
local spells = nil

--------------------------------------------------
local instance = nil

--------------------------------------------------
local function testIdBounds (self)
    if self.currentBlockId > self.highestBlockId then
        self.currentBlockId = self.highestBlockId
    end

    if self.currentBlockId < self.lowestBlockId then
        self.currentBlockId = self.lowestBlockId
    end
end

--------------------------------------------------
local function renderBg (self)
    dio.drawing.font.drawBox (0, 0, self.w, self.rowHeight, 0x000000b0)
end

--------------------------------------------------
local function renderSelectedBlock (self, idx, x, y)

    dio.drawing.font.drawBox (x - 1, y - 1, self.iconScale * 16 + 2, self.iconScale * 16 + 2, 0xffffffff)

    local block = spells [self.currentBlockId]
    local width = dio.drawing.font.measureString (block.name)
    x = (idx * (16 * self.iconScale + 1) - (8 * self.iconScale)) - (width * 0.5)
    x = x < 1 and 1 or x
    x = x + width >= self.w and self.w - width or x

    dio.drawing.font.drawBox (x - 1, self.rowHeight, width + 1, self.h - self.rowHeight, 0x000000b0)
    dio.drawing.font.drawString (x, self.rowHeight, block.name, 0xffffffff)
end

--------------------------------------------------
local function getSpellUV (spell_id)
    local spell = spells [spell_id]

    if spell ~= nil then
        return spell.icon [1], spell.icon [2]
    end

    return nil, nil
end

--------------------------------------------------
local function renderBlocks (self)

    local x = 1
    local y = 1
    for idx = 1, self.blocksPerPage do
        local block_id = idx + self.currentPage * self.blocksPerPage

        if spells [block_id] ~= nil then
            local u, v = getSpellUV (block_id)

            if u ~= nil then
                if block_id == self.currentBlockId then
                    renderSelectedBlock (self, idx, x, y)
                end

                dio.drawing.drawTextureRegion2 (self.blockTexture, x, y, 16 * self.iconScale, 16 * self.iconScale, u * 16, v * 16, 16, 16)

            end

            x = x + self.iconScale * 16 + 1;
        end
    end
end

--------------------------------------------------
local function setInventoryItem (id)
    --local block = spells [id]
    --local entity = entities [block.entity]

    --if entity then
    --    dio.inputs.setPlayerEntityId (1, id, entity.text)
    --else
    --    dio.inputs.setPlayerBlockId (1, id)
    --end

end

--------------------------------------------------
local function onUpdate (self)

end

--------------------------------------------------
local function onEarlyRender (self)
    -- Not the most ideal way to call onUpdate
    onUpdate (self)

    if self.isDirty then
        dio.drawing.setRenderToTexture (self.renderToTexture)
        renderBg (self)
        renderBlocks (self)
        dio.drawing.setRenderToTexture (nil)
        self.isDirty = false
    end

end

--------------------------------------------------
local function onLateRender (self)

    local scale = Window.calcBestFitScale (self.w * 2, self.h)
    scale = scale >= 3 and 3 or scale
    local windowW, windowH = dio.drawing.getWindowSize ()
    local x = (windowW - (self.w * scale)) * 0.5
    local y = self.y
    dio.drawing.drawTexture (self.renderToTexture, x, y, self.w * scale, self.h * scale, 0xffffffff)

    local params = dio.resources.getTextureParams (self.crosshairTexture)
    params.width = params.width * 3
    params.height = params.height * 3
    dio.drawing.drawTexture2 (
            self.crosshairTexture,
            (windowW - params.width) * 0.5,
            (windowH - params.height) * 0.5,
            params.width,
            params.height)
end

--------------------------------------------------
local function onKeyClicked (keyCode, keyModifiers, keyCharacter)

    local keyCodes = dio.inputs.keyCodes

    local self = instance

    

    return false
end

--------------------------------------------------
local function onChatMessagePreSent (text)


end

--------------------------------------------------
function s.onLoad (playerInfo)

    local iconScale = 1
    local blocksPerPage = 9
    local rowHeight = iconScale * 16 + 2

    if playerInfo.class == "tank" then
        spells = SpellDefinitions.tank
    elseif playerInfo.class == "damage" then
        spells = SpellDefinitions.damage
    elseif playerInfo.class == "healer" then
        spells = SpellDefinitions.healer
    end

    instance =
    {
        lowestBlockId = 1,
        highestBlockId = #spells,
        currentBlockId = 7,
        currentPage = 0,
        blocksPerPage = blocksPerPage,
        pages = 0, -- 0 indexed
        isDirty = true,

        y = 0,
        w = ((iconScale * 16) + 1) * blocksPerPage + 1,
        h = rowHeight + 10,
        rowHeight = rowHeight,
        iconScale = iconScale,

        crosshairTexture =  dio.resources.loadTexture ("CROSSHAIR", "textures/crosshair_00.png"),
        blockTexture =      dio.resources.getTexture ("SPELL_ICONS"),
    }

    instance.renderToTexture = dio.drawing.createRenderToTexture (instance.w, instance.h)
    instance.pages = math.ceil (instance.highestBlockId / instance.blocksPerPage) - 1

    dio.drawing.addRenderPassBefore (1, function () onEarlyRender (instance) end)
    dio.drawing.addRenderPassAfter (1, function () onLateRender (instance) end)

    local types = dio.types.clientEvents
    dio.events.addListener (types.KEY_CLICKED, onKeyClicked)
    dio.events.addListener (types.CHAT_MESSAGE_PRE_SENT, onChatMessagePreSent)

    setInventoryItem (instance.currentBlockId)

end

--------------------------------------------------
return s
