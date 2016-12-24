
--[[
-- Candles mod by darkrose
-- Copyright (C) Lisa Milne 2013 <lisa@ltmnet.com>
-- Code: GPL version 2
-- http://www.gnu.org/licenses/>
--]]

screwdriver = screwdriver or {}

local candles = {};

candles.collect = function(pos, node, puncher)
	local meta = minetest.env:get_meta(pos)
	local angry = meta:get_string('angry')
	local comb = meta:get_int('comb')
	if ( angry and angry == 'true' ) or comb < 1 then
		local health = puncher:get_hp()
		puncher:set_hp(health-2)
	else
		comb = comb-1
		meta:set_int('comb',comb)
		puncher:get_inventory():add_item('main', 'candles:comb')
	end
	if comb < 1 then
		meta:set_string('angry','true')
	end
	if node.name == 'candles:hive' then
		if comb < 1 then
			meta:set_string('infotext','Bee Hive: Angry')
		else
			meta:set_string('infotext','Bee Hive: Busy');
		end
	end
	local tmr = minetest.env:get_node_timer(pos)
	tmr:start(300)
end

minetest.register_node("candles:hive_wild", {
	description = "Wild Bee Hive",
	tile_images = {"candles_hive_wild.png"},
	drawtype = "plantlike",
	paramtype = "light",
	paramtype2 = 'wallmounted',
	groups = {attached_node=1},
	on_punch = candles.collect,
	can_dig = function(pos,player)
		return false
	end,
	on_place = function(itemstack, placer, pointed_thing)
		minetest.env:add_node(pointed_thing.above, {name = itemstack:get_name(), param2 = 0})
		itemstack:take_item()
		return itemstack
	end,
	after_place_node = function(pos, placer, itemstack)
    if minetest.get_modpath( "mobs") then
         if math.random(1, 4) == 1 then
          minetest.add_entity(pos, "mobs_animal:bee")
        end
    else
   end
	end,
	on_timer = function(pos,elapsed)
		local meta = minetest.env:get_meta(pos)
		local angry = meta:get_string('angry')
		if angry and angry == 'true' then
			meta:set_string('angry','')
			meta:set_int('comb',1)
		else
			local c = meta:get_int('comb')
			if c == 3 then
				minetest.env:add_node(pos,{name='default:apple'})
				return false
			elseif c == 0 then
				meta:set_string('angry','true')
			else
				meta:set_int('comb',c+1)
			end
		end
		return true
	end,
	on_construct = function(pos)
		local tmr = minetest.env:get_node_timer(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string('angry','true')
		tmr:start(300)
	end
})

minetest.register_node("candles:hive", {
	description = "Bee Hive",
	tile_images = {"candles_hive_top.png", "candles_hive_bottom.png",
	"candles_hive.png", "candles_hive.png",
	"candles_hive.png", "candles_hive_front.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	place_param2 = 0,
	on_rotate = screwdriver.rotate_simple,
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1},
	sounds = default.node_sound_wood_defaults(),
	on_punch = candles.collect,
	node_box = {
		type = "fixed",
		fixed = {
                {-0.375, 0, -0.375, 0.375, 0.5, 0.375},
                {-0.4375, 0.375, -0.4375, 0.4375, 0.4375, 0.4375},
                {-0.4375, -0.0625, -0.4375, 0.4375, 0, 0.4375},
                {-0.4375, -0.5, 0.375, -0.375, 0.4375, 0.4375},
                {0.375, -0.5, 0.375, 0.4375, 0.4375, 0.4375},
                {-0.4375, -0.5, -0.375, 0.4375, -0.0625, 0.4375},
                {-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.4375},
                {-0.4375, -0.5, -0.4375, -0.375, 0.375, -0.375},
                {0.375, -0.5, -0.4375, 0.4375, 0.4375, -0.375},
                {-0.125, -0.3125, -0.4375, 0.125, -0.1875, -0.3125},--knob
            },
		},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	},
	after_place_node = function(pos, placer, itemstack)
    if minetest.get_modpath( "mobs") then
         if math.random(1, 4) == 1 then
          minetest.add_entity(pos, "mobs_animal:bee")
        end
    else
   end
	end,
	on_timer = function(pos,elapsed)
		local meta = minetest.env:get_meta(pos)
		local angry = meta:get_string('angry')
		if angry and angry == 'true' then
			meta:set_string('angry','')
			meta:set_string('infotext','Bee Hive: Busy');
			meta:set_int('comb',1)
		else
			local c = meta:get_int('comb')
			if c == 0 then
				meta:set_string('angry','true')
				meta:set_string('infotext','Bee Hive: Angry');
			else
				meta:set_int('comb',c+2)
				meta:set_string('infotext','Bee Hive: Busy');
			end
		end
		return true
	end,
	on_construct = function(pos)
		local tmr = minetest.env:get_node_timer(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string('angry','true')
		meta:set_string('infotext','Bee Hive: Angry');
		tmr:start(300)
	end
})

minetest.register_node("candles:hive_empty", {
	description = "Bee Hive",
 tile_images = {"candles_hive_empty_top.png",
 "candles_hive_empty_bottom.png",
 "candles_hive_empty.png", "candles_hive_empty.png",
 "candles_hive_empty.png", "candles_hive_empty_front.png"},
 drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	place_param2 = 0,
	on_rotate = screwdriver.rotate_simple,
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1},
	sounds = default.node_sound_wood_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
                {-0.375, 0, -0.375, 0.375, 0.5, 0.375},
                {-0.4375, 0.375, -0.4375, 0.4375, 0.4375, 0.4375},
                {-0.4375, -0.0625, -0.4375, 0.4375, 0, 0.4375},
                {-0.4375, -0.5, 0.375, -0.375, 0.4375, 0.4375},
                {0.375, -0.5, 0.375, 0.4375, 0.4375, 0.4375},
                {-0.4375, -0.5, -0.375, 0.4375, -0.0625, 0.4375},
                {-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.4375},
                {-0.4375, -0.5, -0.4375, -0.375, 0.375, -0.375},
                {0.375, -0.5, -0.4375, 0.4375, 0.4375, -0.375},
                {-0.125, -0.3125, -0.4375, 0.125, -0.1875, -0.3125},--knob
            },
		},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	},
	after_place_node = function(pos, placer, itemstack)
    if minetest.get_modpath( "mobs") then
         if math.random(1, 4) == 1 then
          minetest.add_entity(pos, "mobs_animal:bee")
        end
    else
   end
	end,
	on_timer = function(pos,elapsed)
		minetest.env:add_node(pos,{name='candles:hive'})
		return false
	end,
	on_construct = function(pos)
		local tmr = minetest.env:get_node_timer(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string('infotext','Bee Hive: Empty');
		tmr:start(300)
	end
})
--Honeycomb Block
minetest.register_node("candles:honeycomb_block", {
	description = "Honey Block",
	inventory_image = "candles_honeycomb_block.png",
	tiles = {"candles_honeycomb_block.png"},
	groups = {snappy = 3, flammable = 2},
	sounds = default.node_sound_dirt_defaults(),
})
--Bottled Honey
minetest.register_node("candles:honey_bottled", {
	description = "Bottled Honey",
	inventory_image = "candles_honey_bottled.png",
	drawtype = "plantlike",
	tiles = {"candles_honey_bottled.png"},
	wield_image = "candles_honey_bottled.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.4, 0.25}
	},
	groups = {vessel=1,dig_immediate=3,attached_node=1},
	sounds = default.node_sound_glass_defaults(),
	on_use = minetest.item_eat(8),
})
---------------
--Craft Items
---------------
minetest.register_craftitem("candles:wax", {
	description = "Beeswax",
	inventory_image = "candles_wax.png",
})

minetest.register_craftitem("candles:honey", {
	description = "Honey",
	inventory_image = "candles_honey.png",
	on_use = minetest.item_eat(4),
})

minetest.register_craftitem("candles:comb", {
	description = "Honey Comb",
	inventory_image = "candles_comb.png",
	on_use = minetest.item_eat(6),
})
----------------
--Craft Recipes
-----------------
minetest.register_craft({
	output = 'candles:candle',
	recipe = {
		{'candles:wax','farming:cotton','candles:wax'},
	}
})

minetest.register_craft({
	output = 'candles:honey 2',
	recipe = {
		{'candles:comb'},
	}
})

minetest.register_craft({
	type = 'cooking',
	output = 'candles:wax 2',
	recipe = 'candles:comb'
})

minetest.register_craft({
	output = 'candles:comb 9',
	recipe = {
		{'candles:honeycomb_block'},
	}
})

minetest.register_craft({
	output = "candles:honeycomb_block",
	recipe = {
		{"candles:comb", "candles:comb", "candles:comb"},
		{"candles:comb", "candles:comb", "candles:comb"},
		{"candles:comb", "candles:comb", "candles:comb"},
	}
})

minetest.register_craft({
	output = "candles:honey_bottled 1",
	recipe = {
        {"candles:honey"},
		{"candles:honey"},
		{"vessels:glass_bottle"},
	}
})

minetest.register_craft({
	output = 'candles:hive',
	recipe = {
		{'default:wood','default:wood','default:wood'},
		{'default:stick','candles:hive_wild','default:stick'},
		{'default:stick','default:wood','default:stick'},
	}
})

minetest.register_craft({
	output = 'candles:hive_empty',
	recipe = {
		{'default:wood','default:wood','default:wood'},
		{'default:stick','default:paper','default:stick'},
		{'default:stick','default:wood','default:stick'},
	}
})
------------
-- ABMs
------------
minetest.register_abm({
	nodenames = 'default:apple',
	neighbors = 'default:leaves',
	interval = 1200,
	chance = 30,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local abv = minetest.env:get_node({x=pos.x,y=pos.y+1,z=pos.z})
		if not abv or abv.name ~= 'default:leaves' then
			return nil
		end
		minetest.env:add_node(pos,{name='candles:hive_wild', param2 = 0})
	end
})