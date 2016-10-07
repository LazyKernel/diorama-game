local DialogElement = require ("resources/mods/diorama/frontend_menus/paint/dialog_element")
local IconDrawer = require ("resources/mods/diorama/frontend_menus/paint/here_we_go")

--------------------------------------------------
local d = {}

--------------------------------------------------
local dialogProperties = {
    x,
    y,
    sizeX,
    sizeY,
    color,
    text,
    mouseOver,
}

--------------------------------------------------
local dialogElements = {}

--------------------------------------------------
function d.addButton (x, y, sizeX, sizeY, text, onClicked)
    local dialogElement = DialogElement (x, y, sizeX, sizeY, text, onClicked, 1)
    table.insert (dialogElements, dialogElement)
end

--------------------------------------------------
function d.addTextField (x, y, sizeX, sizeY, defaultValue)
    local dialogElement = DialogElement (x, y, sizeX, sizeY, defaultValue, nil, 2)
    table.insert (dialogElements, dialogElement)
end

--------------------------------------------------
function d.getElement (idx)
    return dialogElements [idx]
end

--------------------------------------------------
-- LazyKernel is lazy and takes shortcuts
function d.getFirstElementofType (type)
    for elIdx = 1, #dialogElements do
        if dialogElements [elIdx].type == type then
            return dialogElements [elIdx]
        end
    end
end

--------------------------------------------------
function d.update (x, y, was_left_clicked)
    for elIdx = 1, #dialogElements do
        dialogElements [elIdx]:update (x, y, was_left_clicked)
    end

    dialogProperties.mouseOver = false
    if x >= dialogProperties.x + dialogProperties.sizeX - 16 and y >= dialogProperties.y
    and x <= dialogProperties.x + dialogProperties.sizeX and y <= dialogProperties.y + 16 then

        dialogProperties.mouseOver = true

        if was_left_clicked then
            return true
        end

    end

    return false
end

--------------------------------------------------
function d.onKeyClicked (keyCode, keyCharacter, keyModifiers, menus)
    for elIdx = 1, #dialogElements do
        dialogElements [elIdx]:onKeyClicked (keyCode, keyCharacter, keyModifiers, menus)
    end
end

--------------------------------------------------
function d.drawAllElements ()
    for elIdx = 1, #dialogElements do
        dialogElements [elIdx]:render ()
    end
end

--------------------------------------------------
function d.drawCustomButton (x, y, scale, text, isMouseOver)
    if isMouseOver then
        dio.drawing.font.drawBox (x, y, scale * 4, scale * 3, 0xddddddff)
        dio.drawing.font.drawBox (x + 2, y + 2, scale * 3.5, scale * 2.5, 0x444444ff)
        dio.drawing.font.drawString (x + 5, y + 6, text, 0xeeeeeeff)
    else
        dio.drawing.font.drawBox (x, y, scale * 4, scale * 3, 0xeeeeeeff)
        dio.drawing.font.drawBox (x + 2, y + 2, scale * 3.5, scale * 2.5, 0x555555ff)
        dio.drawing.font.drawString (x + 5, y + 6, text, 0xffffffff)
    end
end

--------------------------------------------------
function d.drawCustomInputField (x, y, scale, text, isMouseOver, isFocused)
    if isMouseOver then
        dio.drawing.font.drawBox (x, y, scale * 4, scale * 2, 0x444444ff)
        dio.drawing.font.drawString (x + 4, y + 5, text, 0xeeeeeeff)

        if isFocused then
            local strLen = dio.drawing.font.measureString (text)
            dio.drawing.font.drawString (x + 4 + strLen, y + 5, "_", 0xdd0000ff)
        end

    else
        dio.drawing.font.drawBox (x, y, scale * 4, scale * 2, 0x555555ff)
        dio.drawing.font.drawString (x + 4, y + 5, text, 0xffffffff)

        if isFocused then
            local strLen = dio.drawing.font.measureString (text)
            dio.drawing.font.drawString (x + 4 + strLen, y + 5, "_", 0xee0000ff)
        end

    end
end

--------------------------------------------------
function d.drawPen (x, y, scale, isMouseOver, isCurrentTool)
    IconDrawer.drawPen (x, y, scale, isMouseOver, isCurrentTool)
end

--------------------------------------------------
function d.drawFill (x, y, scale, isMouseOver, isCurrentTool)
    IconDrawer.drawFill (x, y, scale, isMouseOver, isCurrentTool)
end

--------------------------------------------------
function d.drawEraser (x, y, scale, isMouseOver, isCurrentTool)
    IconDrawer.drawEraser (x, y, scale, isMouseOver, isCurrentTool)
end

--------------------------------------------------
function d.drawPicker (x, y, scale, isMouseOver, isCurrentTool)
    IconDrawer.drawPicker (x, y, scale, isMouseOver, isCurrentTool)
end

--------------------------------------------------
function d.drawUndo (x, y, scale, isMouseOver)
    IconDrawer.drawUndo (x, y, scale, isMouseOver)
end

--------------------------------------------------
function d.drawRedo (x, y, scale, isMouseOver)
    IconDrawer.drawRedo (x, y, scale, isMouseOver)
end

--------------------------------------------------
function d.drawErrorMessage (x, y, text)
    dio.drawing.font.drawString (x, y, text, 0xc80815ff)
end

--------------------------------------------------
function d.drawDialog (x, y, sizeX, sizeY, color, title)
    dialogProperties.x = x
    dialogProperties.y = y
    dialogProperties.sizeX = sizeX
    dialogProperties.sizeY = sizeY
    dialogProperties.color = color
    dialogProperties.text = text

    -- dialog background
    dio.drawing.font.drawBox (x, y, sizeX, sizeY, color)

    local xColor = 0xeeeeeeff
    local rColor = 0xc80815ff

    if dialogProperties.mouseOver then
        xColor = 0xddddddff
        rColor = 0xb70704ff
    end

    -- red X background
    dio.drawing.font.drawBox (x + sizeX - 16,  y, 16, 16, rColor)

    -- white X
    dio.drawing.font.drawBox (x + sizeX - 10,  y + 6, 4, 4, xColor)
    dio.drawing.font.drawBox (x + sizeX - 12,  y + 4, 2, 2, xColor)
    dio.drawing.font.drawBox (x + sizeX - 14,  y + 2, 2, 2, xColor)
    dio.drawing.font.drawBox (x + sizeX - 6,  y + 4, 2, 2, xColor)
    dio.drawing.font.drawBox (x + sizeX - 4,  y + 2, 2, 2, xColor)
    dio.drawing.font.drawBox (x + sizeX - 12,  y + 10, 2, 2, xColor)
    dio.drawing.font.drawBox (x + sizeX - 14,  y + 12, 2, 2, xColor)
    dio.drawing.font.drawBox (x + sizeX - 6,  y + 10, 2, 2, xColor)
    dio.drawing.font.drawBox (x + sizeX - 4,  y + 12, 2, 2, xColor)

    -- title, measureString would be better but I'm too lazy
    dio.drawing.font.drawString (x + sizeX / 2 - ((string.len (title) / 2) * 8), y + 5, title, 0xffffffff)
end

return d
