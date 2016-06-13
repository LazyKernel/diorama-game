--------------------------------------------------
local Menus = require ("resources/mods/diorama/frontend_menus/menu_construction")
local MenuClass = require ("resources/mods/diorama/frontend_menus/menu_class")
local Mixin = require ("resources/mods/diorama/frontend_menus/mixin")
local RenderUtil = require ("resources/mods/diorama/frontend_menus/osu/renderutil")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onEnter ()

end

--------------------------------------------------
function c:onExit ()

end

--------------------------------------------------
function c:onUpdate (x, y, was_left_clicked)

end

--------------------------------------------------
function c:onKeyClicked (keyCode, keyCharacter, keyModifiers, menus)

end

--------------------------------------------------
function c:onRender ()
	RenderUtil.renderCircle (50, 50, 4)
end

--------------------------------------------------
function c:recordAppClose ()

end

--------------------------------------------------
return function ()
	local instance = MenuClass ("Osu!")

	local properties =
	{
	}

	Mixin.CopyTo (instance, properties)
	Mixin.CopyToAndBackupParents (instance, c)

	return instance
end
