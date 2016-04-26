--------------------------------------------------
local Color = require ("resources/mods/diorama/frontend_menus/3dmenu/color")
local Vec = require ("resources/mods/diorama/frontend_menus/3dmenu/vec")
local OBJLoader = require ("resources/mods/diorama/frontend_menus/3dmenu/objloader")

--------------------------------------------------
local s = {}

--------------------------------------------------
s.screenBuffer = {}
s.width = 495
s.height = 200
s.xOff = 10
s.yOff = 50

--------------------------------------------------
s.models = {}

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
-- vec2, vec2
-- returns vec3
local function barycentric (tPoints, point)
    local vecu = Vec.cross (Vec.new (tPoints [3].x - tPoints [1].x, tPoints [2].x - tPoints [1].x, tPoints [1].x - point.x), Vec.new (tPoints [3].y - tPoints [1].y, tPoints [2].y - tPoints [1].y, tPoints [1].y - point.y))
    if math.abs(vecu.z) < 1 then return Vec.new (-1, 1, 1) end
    return Vec.new (1.0 - (vecu.x + vecu.y) / vecu.z, vecu.y / vecu.z, vecu.x / vecu.z)
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
function s.loadModel (fileName)
    local obj = OBJLoader.load (fileName)

    if not obj then return end

    s.models [#s.models + 1] = { pos = { x = 0.0, y = 0.0, z = 0.0 }, scale = { x = 1.0, y = 1.0, z = 1.0 }, rot = { x = 0.0, y = 0.0, z = 0.0, w = 1.0 }, obj = obj }
end

--------------------------------------------------
-- TODO: OPTIMIZE
function s.drawModels ()
    for i = 1, #s.models do
        local mdl = s.models [i]

        for j = 1, #mdl.obj.f do
            local verts = mdl.obj.f [j]
            local screenCoords = {}
            for k = 1, 3 do
                local worldCoords = mdl.obj.v [verts [k].v]
                -- TODO: / 2 not / 20
                screenCoords [k] = Vec.new ((worldCoords.x + 1) * s.width / 20 + 100, (worldCoords.y + 1) * s.height / 20 + 100)
            end
            s.drawTriangle ( { screenCoords [1], screenCoords [2] , screenCoords [3] }, Color.generateRandomColor (0xffffff) + 0xff)
        end
    end
end

--------------------------------------------------
function s.drawTriangle (tPoints, color)
    local bboxMin = Vec.new (s.width, s.height)
    local bboxMax = Vec.new (1, 1)
    local clamp = Vec.new (s.width, s.height)

    for i = 1, 3 do
        bboxMin.x = math.max (0, math.min (bboxMin.x, tPoints [i].x))
        bboxMax.x = math.min (clamp.x, math.max (bboxMax.x, tPoints [i].x))
        bboxMin.y = math.max (0, math.min (bboxMin.y, tPoints [i].y))
        bboxMax.y = math.min (clamp.y, math.max (bboxMax.y, tPoints [i].y))
    end

    for px = bboxMin.x, bboxMax.x do
        for py = bboxMin.y, bboxMax.y do
            local bcscreen = barycentric (tPoints, Vec.new (px, py))
            if bcscreen.x > 0 and bcscreen.y > 0 and bcscreen.z > 0 then
                s.setPixel (px, py, color)
            end
        end
    end
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
