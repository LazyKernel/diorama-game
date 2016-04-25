--------------------------------------------------
local Color = require ("resources/mods/diorama/frontend_menus/3dmenu/color")

--------------------------------------------------
local s = {}

--------------------------------------------------
s.screenBuffer = {}
s.width = 495
s.height = 200
s.xOff = 10
s.yOff = 50

--------------------------------------------------
local function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    else
      print(formatting .. v)
    end
  end
end

--------------------------------------------------
local function createNewRow (self, rowIdx)
	local row = {}
	for colIdx = 1, self.width do
		local cell = 0x00000000
		table.insert (row, cell)
	end

	return row
end

--------------------------------------------------
local function createCanvas (self)
	local canvas = {}

	for rowIdx = 1, self.height do
		local row = createNewRow (self, rowIdx)
		table.insert (canvas, row)
	end
	return canvas
end

--------------------------------------------------
function s.init()
    s.screenBuffer = createCanvas (s)
end

--------------------------------------------------
function s.setPixel (x, y, color)
	local xf = math.floor (x)
	local yf = math.floor (y)

    if xf > s.width or yf > s.height or xf < 1 or yf < 1 then
        return
    end

    s.screenBuffer [yf][xf] = color
end

--------------------------------------------------
function s.drawLine (x1, y1, x2, y2, color)
    local xDiff = x2 - x1
    local yDiff = y2 - y1

    if xDiff == 0 and yDiff == 0 then
        s.setPixel (x1, y1, color1)
        return
    end

    if math.abs (xDiff) > math.abs(yDiff) then
        local xMin, xMax

        if x1 < x2 then
            xMin = x1
            xMax = x2
        else
            xMin = x2
            xMax = x1
        end

        local slope = yDiff / xDiff

        for x = xMin, xMax do
            local y = y1 + ((x - x1) * slope)
            s.setPixel (x, y, color)
        end
    else
        local yMin, yMax

        if y1 < y2 then
            yMin = y1
            yMax = y2
        else
            yMin = y2
            yMax = y1
        end

        local slope = xDiff / yDiff

        for y = yMin, yMax do
            local x = x1 + ((y - y1) * slope)
            s.setPixel (x, y, color)
        end
    end
end

--------------------------------------------------
function s.resetBuffer ()
    for y = 1, s.height do
        for x = 1, s.width do
            s.screenBuffer [y][x] = 0
        end
    end
end

--------------------------------------------------
function s.renderScene ()
    dio.drawing.font.drawBox (s.xOff, s.yOff, s.width, s.height, 0x000000ff)

    for y = 1, s.height do
        for x = 1, s.width do
            local pixel = s.screenBuffer [y][x]

            if pixel ~= 0 then
                dio.drawing.font.drawBox (x + s.xOff, y + s.yOff, 1, 1, pixel)
            end
        end
    end
end

--------------------------------------------------
return s
