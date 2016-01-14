--------------------------------------------------
local Mods = require ("mod_loader")

--------------------------------------------------
local function main ()

	local permissions = 
	{
		client = true,
		file = true,
		player = true,
	}

	Mods.loadMod ("chat", permissions)
	-- Mods.loadMod ("diagnostics", permissions)
end

--------------------------------------------------
main ()