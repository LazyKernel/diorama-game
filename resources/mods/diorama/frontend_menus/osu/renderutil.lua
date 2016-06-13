--------------------------------------------------
local s = {}

s.circleBitmap = {}

--------------------------------------------------
function s.renderCircle (x, y, cs)
    local r = cs

    for i = 1, 360 do
        local angle = i * math.pi / 180
        local x, y = x + r * math.cos (angle), y + r * math.sin (angle)
        dio.drawing.font.drawBox (x, y, 1, 1, 0xffffffff)
    end
end

--------------------------------------------------
return s
