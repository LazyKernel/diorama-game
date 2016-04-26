--------------------------------------------------
local ButtonMenuItem = require ("resources/mods/diorama/frontend_menus/menu_items/button_menu_item")
local Menus = require ("resources/mods/diorama/frontend_menus/menu_construction")
local MenuClass = require ("resources/mods/diorama/frontend_menus/menu_class")
local Mixin = require ("resources/mods/diorama/frontend_menus/mixin")
local Renderer = require ("resources/mods/diorama/frontend_menus/3dmenu/render")
local Color = require ("resources/mods/diorama/frontend_menus/3dmenu/color")
local Vec = require ("resources/mods/diorama/frontend_menus/3dmenu/vec")

--------------------------------------------------
local c = {}

local time = 0
local r = 0
local M_PI = 3.14159265359

--------------------------------------------------
local function onMainMenuClicked()
    return "main_menu"
end

--------------------------------------------------
function c:onEnter ()

end

--------------------------------------------------
function c:onExit ()

end

--------------------------------------------------
function c:onUpdate (x, y, was_left_clicked)
    time = time + 0.016
    r = r + M_PI / 2.0 * time
    return self.parent.onUpdate (self, x, y, was_left_clicked)
end

--------------------------------------------------
function c:onKeyClicked (keyCode, keyCharacter, keyModifiers, menus)

end

--------------------------------------------------
function c:onRender ()
    self.parent.onRender (self)

    Renderer.resetBuffer ()

    local size = 20;
	local x1 = (Renderer.width / 2) + math.cos(r + 0.25 - M_PI / 6.0) * size * 0.727 + 50 + math.sin (r) * 7.27;
	local y1 = (Renderer.height / 2) + math.sin(r + 0.25 - M_PI / 6.0) * size * 0.727 + math.sin (r) * 7.27;
	local x2 = (Renderer.width / 2) + math.cos(r + 0.25 + M_PI / 2.0) * size * 0.727 + 50 + math.sin (r) * 7.27;
	local y2 = (Renderer.height / 2) + math.sin(r + 0.25 + M_PI / 2.0) * size * 0.727 + math.sin (r) * 7.27;
	local x3 = (Renderer.width / 2) + math.cos(r + 0.25 + M_PI + M_PI / 6.0) * size * 0.727 + 50 + math.sin (r) * 7.27;
	local y3 = (Renderer.height / 2) + math.sin(r + 0.25 + M_PI + M_PI / 6.0) * size * 0.727 + math.sin (r) * 7.27;

    local x11 = (Renderer.width / 2) + math.cos(r - M_PI / 6.0) * size - 50;
	local y11 = (Renderer.height / 2) + math.sin(r - M_PI / 6.0) * size + 50;
	local x12 = (Renderer.width / 2) + math.cos(r + M_PI / 2.0) * size - 50;
	local y12 = (Renderer.height / 2) + math.sin(r + M_PI / 2.0) * size + 50;
	local x13 = (Renderer.width / 2) + math.cos(r + M_PI + M_PI / 6.0) * size - 50;
	local y13 = (Renderer.height / 2) + math.sin(r + M_PI + M_PI / 6.0) * size  + 50;

    Renderer.drawLine (x1, y1, x2, y2, 0x546454ff)
    Renderer.drawLine (x2, y2, x3, y3, 0xdeadbeef)
    Renderer.drawLine (x3, y3, x1, y1, 0x00ee00ff)

    --Renderer.drawLine (x11, y11, x12, y12, 0x555599ff)
    Renderer.drawTriangle ({ Vec.new (x11, y11), Vec.new (x12, y12), Vec.new (x13, y13) }, 0xee00eeff)
    --Renderer.drawLine (x13, y13, x11, y11, 0xee00eeff)
    Renderer.renderScene ()
end

--------------------------------------------------
function c:recordAppClose ()

end

--------------------------------------------------
return function()
	local instance = MenuClass ("3D Menu Example")

	local properties =
	{
	}

	Mixin.CopyTo (instance, properties)
	Mixin.CopyToAndBackupParents (instance, c)

    instance:addMenuItem (ButtonMenuItem ("Return To Main Menu", onMainMenuClicked))

    Renderer.init ()

	return instance
end
