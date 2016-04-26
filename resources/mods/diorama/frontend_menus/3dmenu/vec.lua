--------------------------------------------------
local v = {}

--------------------------------------------------
function v.new (x, y, z)
    if not z then
        return { x = x, y = y }
    else
        return { x = x, y = y, z = z }
    end
end

--------------------------------------------------
function v.cross (v1, v2)
    cx = (v1.y * v2.z) - (v2.y * v1.z)
    cy = (v1.z * v2.x) - (v2.z * v1.x)
    cz = (v1.x * v2.y) - (v2.x * v1.y)

    return { x = cx, y = cy, z = cz }
end

--------------------------------------------------
return v
