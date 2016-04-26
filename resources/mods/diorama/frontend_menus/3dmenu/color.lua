math.randomseed (os.time ())

--------------------------------------------------
local c = {}

--------------------------------------------------
function c.getColor (red, green, blue)
    return bit32.lshift (red, 16) + bit32.lshift (green, 8) + blue
end

--------------------------------------------------
function c.getComponents (color)
    local red = c.getRed (color)
    local green = c.getGreen (color)
    local blue = c.getBlue (color)

    return red, green, blue
end

--------------------------------------------------
function c.setRed (color, value)
    return color + bit32.lshift (value, 16)
end

--------------------------------------------------
function c.setGreen (color, value)
    return color + bit32.lshift (value, 8)
end

--------------------------------------------------
function c.setBlue (color, value)
    return color + value
end

--------------------------------------------------
function c.getRed (color)
    return bit32.band (bit32.rshift (color, 16), 255)
end

--------------------------------------------------
function c.getGreen (color)
    return bit32.band (bit32.rshift (color, 8), 255)
end

--------------------------------------------------
function c.getBlue (color)
    return bit32.band (color, 255)
end

--------------------------------------------------
function c.add (color1, color2)
    return c.getColor (c.getRed (color1) / 255 + c.getRed (color2) / 255, c.getGreen (color1) / 255 + c.getGreen (color2) / 255, c.getBlue (color1) / 255 + c.getBlue (color2) / 255)
end

--------------------------------------------------
function c.sub (color1, color2)
    return c.getColor (c.getRed (color1) / 255 - c.getRed (color2) / 255, c.getGreen (color1) / 255 - c.getGreen (color2) / 255, c.getBlue (color1) / 255 - c.getBlue (color2) / 255)
end

--------------------------------------------------
function c.scalarMul (color, scalar)
    return c.getColor (c.getRed (color) / 255 * scalar, c.getGreen (color) / 255 * scalar, c.getBlue (color) / 255 * scalar)
end

--------------------------------------------------
function c.generateRandomColor (mix)
    local mr, mg, mb = c.getComponents (mix)
    local rr = (math.random(0, 255) + mr) / 2
    local rg = (math.random(0, 255) + mg) / 2
    local rb = (math.random(0, 255) + mb) / 2
    return c.getColor (rr, rg, rb)
end

--------------------------------------------------
return c
