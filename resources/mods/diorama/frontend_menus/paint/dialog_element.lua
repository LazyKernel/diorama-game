local Mixin = require ("resources/mods/diorama/frontend_menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:update (x, y, was_left_clicked)
    self.mouseOver = false

    if x >= self.x and y >= self.y and x <= self.x + self.sizeX * 4 and y <= self.y + self.sizeY * 3 then
        self.mouseOver = true

        if was_left_clicked then
            if self.type == 1 then
                self.onClicked ()
            elseif self.type == 2 then
                self.isFocused = true
            end
        end
    end
end

--------------------------------------------------
function c:onKeyClicked (keyCode, keyCharacter, keyModifiers, menus)
    -- textbox typing
    if self.type == 2 and keyCharacter and self.isFocused then
        self.text = self.text .. string.char (keyCharacter)

    -- textbox backspace
    elseif keyCode == dio.inputs.keyCodes.BACKSPACE and self.type == 2 and self.isFocused then
        local stringLen = self.text:len ()
        if stringLen > 0 then
            self.text = self.text:sub (1, -2)
        end
    -- textbox loses focus on enter
    elseif keyCode == dio.inputs.keyCodes.ENTER and self.type == 2 and self.isFocused then
        self.isFocused = false
    end
end

--------------------------------------------------
function c:render ()
    -- button
    if self.type == 1 then
        dio.drawing.font.drawBox (self.x, self.y, self.sizeX * 4, self.sizeY * 3, self.mouseOver and 0xddddddff or 0xeeeeeeff)
        dio.drawing.font.drawBox (self.x + 2, self.y + 2, self.sizeX * 4 - 4, self.sizeY * 3 - 4, self.mouseOver and 0x444444ff or 0x555555ff)
        dio.drawing.font.drawString (self.x + 5, self.y + 6, self.text, self.mouseOver and 0xeeeeeeff or 0xffffffff)

    -- textbox
    elseif self.type == 2 then
        dio.drawing.font.drawBox (self.x, self.y, self.sizeX * 4, self.sizeY * 3, self.mouseOver and 0xddddddff or 0xeeeeeeff)
        dio.drawing.font.drawString (self.x + 5, self.y + 6, self.text, self.mouseOver and 0x000000ff or 0x111111ff)

        if self.isFocused then
            local textWidth = dio.drawing.font.measureString (self.text)
            dio.drawing.font.drawString (self.x + 5 + textWidth, self.y + 6, "_", 0xff0000ff)
        end
    -- wrong type
    else
        dio.drawing.font.drawString (self.x + 5, self.y + 6, "Error: Wrong element type " .. self.type, 0xff0000ff)
    end
end

--------------------------------------------------
-- type: 1 = button, 2 = textfield
return function (x, y, sizeX, sizeY, text, onClicked, type)
    local instance =
    {
        x = x,
        y = y,
        sizeX = sizeX,
        sizeY = sizeY,
        text = text,
        onClicked = onClicked,
        type = type,
        isFocused = false,
        mouseOver = false,
    }

    Mixin.CopyTo (instance, c)

    return instance
end
