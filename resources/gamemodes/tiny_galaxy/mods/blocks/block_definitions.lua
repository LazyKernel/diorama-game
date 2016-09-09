--------------------------------------------------
local tiles =
{
}

--------------------------------------------------
local entities =
{
}

--------------------------------------------------
local blocks =
{
    -- 0 = air
    -- 1
    {name = "ship tile",                uvs = {4, 1}},
    {name = "ship base",                uvs = {3, 1}},
    {name = "metal pillar",             uvs = {6, 0}, shape = "pole"},
    {name = "computer",                 uvs = {3, 0, 3, 0, 2, 0, 3, 0, 3, 0, 3,0 }, tag ="computer"},
    {name = "grass",                    uvs = {10, 0, 9, 0, 11, 0}},
    {name = "mud",                      uvs = {11, 0}},
    {name = "tree trunk big",           uvs = {1, 1, 2, 1, 2, 1}, tag = "bigAxe"},
    {name = "tree trunk small",         uvs = {5, 0, 2, 1, 2, 1}, shape = "pole", tag = "smallAxe"},
    {name = "leaves",                   uvs = {7, 0}},

    -- 10    
    {name = "thin grass",               uvs = {8, 0}, shape = "cross", isSolid = false},
    {name = "concrete",                 uvs = {1, 0}},
    {name = "concrete breakable",       uvs = {9, 3}, tag = "belt"},
    {name = "vector tile",              uvs = {1, 6}},
    {name = "vector brick",             uvs = {2, 6, 1, 6, 1, 6}},
    {name = "vector breakable brick",   uvs = {3, 6}, tag = "belt"},
    {name = "vector pole",              uvs = {5, 6, 1, 6, 1, 6}, shape = "pole"},
    {name = "vector grass",             uvs = {6, 6}, shape = "cross", isSolid = false},
    {name = "vector glass",             uvs = {4, 6}, isTransparent = true},
    {name = "vector circle",            uvs = {7, 6}},

    -- 20
    {name = "ice rock",                 uvs = {2, 3}},
    {name = "ice layer 1",              uvs = {3, 3, 1, 3, 2, 3}},
    {name = "ice layer 2",              uvs = {4, 3, 1, 3, 2, 3}},
    {name = "ice breakable",            uvs = {8, 3}, tag = "belt"},
    {name = "ice tree",                 uvs = {7, 3, 6, 3, 6, 3}},
    {name = "ice trunk thin",           uvs = {5, 3, 6, 3, 6, 3}, shape = "pole", tag = "smallAxe"},
    {name = "sand brick",               uvs = {1, 2, 4, 2, 4, 2}},
    {name = "sand breakable brick",     uvs = {5, 2}, tag = "belt"},
    {name = "sand",                     uvs = {0, 2}},
    {name = "sand column",              uvs = {3, 2}},

    -- 30
    {name = "sand column ridged",       uvs = {2, 2}},
    {name = "cactus",                   uvs = {9, 2}, shape = "cross", isSolid = false},
    {name = "sand jump pad",            uvs = {0, 2, 6, 2, 0, 2}, isJumpPad = true},
    {name = "sand teleporter",          uvs = {0, 2, 7, 2, 0, 2}, tag = "teleporter"},
    {name = "sand pole",                uvs = {8, 2, 0, 2, 0, 2}, shape = "pole"},
    {name = "sun bright 1",             uvs = {0, 7}},
    {name = "sun bright 2",             uvs = {1, 7}},
    {name = "sun bright 3",             uvs = {2, 7}},
    {name = "sun bright 4",             uvs = {3, 7}},
    {name = "rot brick clean",          uvs = {1, 4}},

    -- 40
    {name = "rot brick roots",          uvs = {2, 4}},
    {name = "rot vines X",              uvs = {4, 4},        shape = "cross", isSolid = false},
    {name = "rot vines []",             uvs = {4, 4}, isTransparent = true, isSolid = false},
    {name = "rot trunk",                uvs = {12, 4}, tag = "bigAxe"},
    {name = "rot trunk thin",           uvs = {11, 4, 12, 4, 12, 4}, shape = "pole", tag = "smallAxe"},
    {name = "rot leaves clean",         uvs = {13, 4}},
    {name = "rot leaves vinish",        uvs = {15, 4, 13, 4, 15, 4}},
    {name = "rot leaves vines",         uvs = {14, 4}},
    {name = "castle brics",             uvs = {5, 4}},
    {name = "castle brics vinish",      uvs = {6, 4, 5, 4, 6, 4}},

    -- 50
    {name = "castle roof",              uvs = {8, 4, 7, 4, 5, 4}},
    {name = "castle door",              uvs = {10, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4}},
    {name = "castle clock",             uvs = {5, 4, 5, 4, 9, 4, 5, 4, 5, 4, 5, 4}},
    {name = "nuke brick",               uvs = {0, 5}},
    {name = "nuke scaffold",            uvs = {1, 5}, isTransparent = true},
    {name = "nuke pole",                uvs = {2, 5}, shape = "pole"},
    {name = "nuke waste",               uvs = {6, 5, 5, 5, 7, 5}},
    {name = "nuke bean",                uvs = {0, 5, 3, 5, 0, 5}, tag = "bean"},
    {name = "nuke jumppad",             uvs = {0, 5, 4, 5, 0, 5}, isJumpPad = true},
    {name = "nuke teleporter",          uvs = {0, 5, 8, 5, 0, 5}, tag = "teleporter"},

    -- 60
    {name = "DO NOT USE (item)",        uvs = {15, 15, 0, 8, 15, 15}},
    {name = "DO NOT USE (art)",         uvs = {15, 15, 0, 9, 15, 15}},
    {name = "small rocks",              uvs = {9, 5}},
    {name = "rock teleporter",          uvs = {1, 0, 6, 1, 1, 0}, tag = "teleporter"},
    {name = "rock pole",                uvs = {10, 6, 1, 0, 1, 0}, shape = "pole"},
    {name = "DO NOT USE (empty)",       uvs = {15, 15, 5, 8, 15, 15}},
    {name = "ship teleporter",          uvs = {4, 1, 8, 6, 4, 1}, tag = "teleporter"},
    {name = "item chest N",             uvs = {2, 8, 3, 8, 4, 8, 3, 8, 0, 8, 1, 8}, tag = "itemChest"}, -- 67
    {name = "item chest E",             uvs = {3, 8, 2, 8, 3, 8, 4, 8, 0, 8, 1, 8}, tag = "itemChest"},
    {name = "item chest S",             uvs = {4, 8, 3, 8, 2, 8, 3, 8, 0, 8, 1, 8}, tag = "itemChest"},

    -- 70
    {name = "item chest W",             uvs = {3, 8, 4, 8, 3, 8, 2, 8, 0, 8, 1, 8}, tag = "itemChest"},
    {name = "artefact chest N",         uvs = {2, 9, 3, 9, 4, 9, 3, 9, 0, 9, 1, 9}, tag = "artifactChest"}, -- 71
    {name = "artefact chest E",         uvs = {3, 9, 2, 9, 3, 9, 4, 9, 0, 9, 1, 9}, tag = "artifactChest"},
    {name = "artefact chest S",         uvs = {4, 9, 3, 9, 2, 9, 3, 9, 0, 9, 1, 9}, tag = "artifactChest"},
    {name = "artefact chest W",         uvs = {3, 9, 4, 9, 3, 9, 2, 9, 0, 9, 1, 9}, tag = "artifactChest"},
    {name = "empty chest N",            uvs = {7, 8, 8, 8, 9, 8, 8, 8, 5, 8, 6, 8}}, -- 75
    {name = "empty chest E",            uvs = {8, 8, 7, 8, 8, 8, 9, 8, 5, 8, 6, 8}},
    {name = "empty chest S",            uvs = {9, 8, 8, 8, 7, 8, 8, 8, 5, 8, 6, 8}},
    {name = "empty chest W",            uvs = {8, 8, 9, 8, 8, 8, 7, 8, 5, 8, 6, 8}},
    {name = "grass jump",               uvs = {10, 0, 10, 5, 11, 0}, isJumpPad = true},
    
    -- 80
    {name = "highlight block A",        uvs = {9, 6}},
    {name = "highlight block B",        uvs = {0, 6}},
}

return {blocks = blocks, tiles = tiles, entities = entities}