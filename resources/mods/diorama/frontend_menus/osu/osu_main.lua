--------------------------------------------------
local BreakMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/break_menu_item")
local ButtonMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/button_menu_item")
local LabelMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/label_menu_item")
local Menus = require ("resources/mods/diorama/frontend_menus/menu_construction")
local MenuClass = require ("resources/mods/diorama/frontend_menus/menu_class")
local Mixin = require ("resources/mods/diorama/frontend_menus/mixin")
local Paint = require ("resources/mods/diorama/frontend_menus/paint/paint_app")

--------------------------------------------------
local function onUsePaintClicked(menuItem, menu)
    menu.app = Paint (menu)
    menu.app:startApp ()
end

--------------------------------------------------
local function onMainMenuClicked()
    return "main_menu"
end

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onEnter ()
end

--------------------------------------------------
function c:onExit ()
    self.app = nil
end

--------------------------------------------------
function c:onUpdate (x, y, was_left_clicked)
    if self.app then
		self.app:update (x, y, was_left_clicked)
	else
		return self.parent.onUpdate (self, x, y, was_left_clicked)
	end
end

--------------------------------------------------
function c:onKeyClicked (keyCode, keyCharacter, keyModifiers, menus)
	if self.app then
		self.app:onKeyClicked (keyCode, keyCharacter, keyModifiers, menus)
	end
end

--------------------------------------------------
function c:onRender ()
    if self.app then
        self.app:render ()
    else
        return self.parent.onRender (self)
    end
end

--------------------------------------------------
function c:recordAppClose ()
    self.app = nil
end

--------------------------------------------------
return function()
	local instance = MenuClass ("Paint Menu")

	local properties =
	{
        app = nil,
	}

	Mixin.CopyTo (instance, properties)
	Mixin.CopyToAndBackupParents (instance, c)

	instance:addMenuItem (ButtonMenuItem ("Circle slamming", onUsePaintClicked))
	instance:addMenuItem (BreakMenuItem ())
	instance:addMenuItem (ButtonMenuItem ("Return To Main Menu", onMainMenuClicked))
	instance:addMenuItem (BreakMenuItem ())

	return instance
end
