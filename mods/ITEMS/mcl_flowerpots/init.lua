local S = minetest.get_translator("mcl_flowerpots")
local has_doc = minetest.get_modpath("doc")

mcl_flowerpots = {}
mcl_flowerpots.registered_pots = {}

local flowers = {
	{"dandelion", "mcl_flowers:dandelion", S("Dandelion Flower Pot")},
	{"poppy", "mcl_flowers:poppy", S("Poppy Flower Pot")},
	{"blue_orchid", "mcl_flowers:blue_orchid", S("Blue Orchid Flower Pot")},
	{"allium", "mcl_flowers:allium", S("Allium Flower Pot")},
	{"azure_bluet", "mcl_flowers:azure_bluet", S("Azure Bluet Flower Pot")},
	{"tulip_red", "mcl_flowers:tulip_red", S("Red Tulip Flower Pot")},
	{"tulip_pink", "mcl_flowers:tulip_pink", S("Pink Tulip Flower Pot")},
	{"tulip_white", "mcl_flowers:tulip_white", S("White Tulip Flower Pot")},
	{"tulip_orange", "mcl_flowers:tulip_orange", S("Orange Tulip Flower Pot")},
	{"oxeye_daisy", "mcl_flowers:oxeye_daisy", S("Oxeye Daisy Flower Pot")},
	{"mushroom_brown", "mcl_mushrooms:mushroom_brown", S("Brown Mushroom Flower Pot")},
	{"mushroom_red", "mcl_mushrooms:mushroom_red", S("Red Mushroom Flower Pot")},
	{"sapling", "mcl_core:sapling", S("Oak Sapling Flower Pot")},
	{"acaciasapling", "mcl_core:acaciasapling", S("Acacia Sapling Flower Pot")},
	{"junglesapling", "mcl_core:junglesapling", S("Jungle Sapling Flower Pot")},
	{"darksapling", "mcl_core:darksapling", S("Dark Oak Sapling Flower Pot")},
	{"sprucesapling", "mcl_core:sprucesapling", S("Spruce Sapling Flower Pot")},
	{"birchsapling", "mcl_core:birchsapling", S("Birch Sapling Flower Pot")},
	{"deadbush", "mcl_core:deadbush", S("Dead Bush Flower Pot")},
	{"fern", "mcl_flowers:fern", S("Fern Flower Pot"), {"mcl_flowers_fern_inv.png"}},
}

minetest.register_node("mcl_flowerpots:flower_pot", {
	description = S("Flower Pot"),
	_tt_help = S("Can hold a small flower or plant"),
	_doc_items_longdesc = S("Flower pots are decorative blocks in which flowers and other small plants can be placed."),
	_doc_items_usagehelp = S("Just place a plant on the flower pot. Flower pots can hold small flowers (not higher than 1 block), saplings, ferns, dead bushes, mushrooms and cacti. Rightclick a potted plant to retrieve the plant."),
	drawtype = "mesh",
	mesh = "flowerpot.obj",
	tiles = {
		"mcl_flowerpots_flowerpot.png",
	},
	use_texture_alpha = minetest.features.use_texture_alpha_string_modes and "clip" or true,
	visual_scale = 0.5,
	wield_image = "mcl_flowerpots_flowerpot_inventory.png",
	wield_scale = {x=1.0, y=1.0, z=1.0},
	paramtype = "light",
	sunlight_propagates = true,
	selection_box = {
		type = "fixed",
		fixed = {-0.2, -0.5, -0.2, 0.2, -0.1, 0.2}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.2, -0.5, -0.2, 0.2, -0.1, 0.2}
	},
	is_ground_content = false,
	inventory_image = "mcl_flowerpots_flowerpot_inventory.png",
	groups = {dig_immediate=3, deco_block=1, attached_node=1, dig_by_piston=1, flower_pot=1},
	sounds = mcl_sounds.node_sound_stone_defaults(),
	on_rightclick = function(pos, node, clicker, itemstack)
		local name = clicker:get_player_name()
		if minetest.is_protected(pos, name) then
			minetest.record_protection_violation(pos, name)
			return
		end
		local item = clicker:get_wielded_item():get_name()
		if mcl_flowerpots.registered_pots[item] then
			minetest.swap_node(pos, {name="mcl_flowerpots:flower_pot_"..mcl_flowerpots.registered_pots[item]})
			if not minetest.is_creative_enabled(clicker:get_player_name()) then
				itemstack:take_item()
			end
		end
	end,
})

minetest.register_craft({
	output = 'mcl_flowerpots:flower_pot',
	recipe = {
		{'mcl_core:brick', '', 'mcl_core:brick'},
		{'', 'mcl_core:brick', ''},
		{'', '', ''},
	}
})

function mcl_flowerpots.register_potted_flower(name, def)
	mcl_flowerpots.registered_pots[name] = def.name
	minetest.register_node(":mcl_flowerpots:flower_pot_"..def.name, {
		description = def.desc.." "..S("Flower Pot"),
		_doc_items_create_entry = false,
		drawtype = "mesh",
		mesh = "flowerpot.obj",
		tiles = {
			"[combine:32x32:0,0=mcl_flowerpots_flowerpot.png:0,0="..def.image,
		},
		use_texture_alpha = minetest.features.use_texture_alpha_string_modes and "clip" or true,
		visual_scale = 0.5,
		wield_scale = {x=1.0, y=1.0, z=1.0},
		paramtype = "light",
		sunlight_propagates = true,
		selection_box = {
			type = "fixed",
			fixed = {-0.2, -0.5, -0.2, 0.2, -0.1, 0.2}
		},
		collision_box = {
			type = "fixed",
			fixed = {-0.2, -0.5, -0.2, 0.2, -0.1, 0.2}
		},
		is_ground_content = false,
		groups = {dig_immediate=3, attached_node=1, dig_by_piston=1, not_in_creative_inventory=1, flower_pot=2},
		sounds = mcl_sounds.node_sound_stone_defaults(),
		on_rightclick = function(pos, item, clicker)
			local player_name = clicker:get_player_name()
			if minetest.is_protected(pos, player_name) then
				minetest.record_protection_violation(pos, player_name)
				return
			end
			minetest.add_item({x=pos.x, y=pos.y+0.5, z=pos.z}, name)
			minetest.set_node(pos, {name="mcl_flowerpots:flower_pot"})
		end,
		drop = {
			items = {
				{ items = { "mcl_flowerpots:flower_pot", name } }
			}
		},
	})
	-- Add entry alias for the Help
	if has_doc then
		doc.add_entry_alias("nodes", "mcl_flowerpots:flower_pot", "nodes", "mcl_flowerpots:flower_pot_"..name)
	end
end

function mcl_flowerpots.register_potted_cube(name, def)
	mcl_flowerpots.registered_pots[name] = def.name
	minetest.register_node(":mcl_flowerpots:flower_pot_"..def.name, {
		description = def.desc.." "..S("Flower Pot"),
		_doc_items_create_entry = false,
		drawtype = "mesh",
		mesh = "flowerpot_with_long_cube.obj",
		tiles = {
			def.image,
		},
		use_texture_alpha = minetest.features.use_texture_alpha_string_modes and "clip" or true,
		visual_scale = 0.5,
		wield_scale = {x=1.0, y=1.0, z=1.0},
		paramtype = "light",
		sunlight_propagates = true,
		selection_box = {
			type = "fixed",
			fixed = {-0.2, -0.5, -0.2, 0.2, -0.1, 0.2}
		},
		collision_box = {
			type = "fixed",
			fixed = {-0.2, -0.5, -0.2, 0.2, -0.1, 0.2}
		},
		is_ground_content = false,
		groups = {dig_immediate=3, attached_node=1, dig_by_piston=1, not_in_creative_inventory=1, flower_pot=2},
		sounds = mcl_sounds.node_sound_stone_defaults(),
		on_rightclick = function(pos, item, clicker)
			local player_name = ""
			if clicker:is_player() then
				player_name = clicker:get_player_name()
			end
			if minetest.is_protected(pos, player_name) then
				minetest.record_protection_violation(pos, player_name)
				return
			end
			minetest.add_item({x=pos.x, y=pos.y+0.5, z=pos.z}, name)
			minetest.set_node(pos, {name="mcl_flowerpots:flower_pot"})
		end,
		drop = {
			items = {
				{ items = { "mcl_flowerpots:flower_pot", name } }
			}
		},
	})
	-- Add entry alias for the Help
	if has_doc then
		doc.add_entry_alias("nodes", "mcl_flowerpots:flower_pot", "nodes", "mcl_flowerpots:flower_pot_"..def.name)
	end
end

--forced because hard dependency to mcl_core
mcl_flowerpots.register_potted_cube("mcl_core:cactus", {
	name = "cactus",
	desc = S("Cactus"),
	image = "mcl_flowerpots_cactus.png",
})

mcl_flowerpots.register_potted_flower("mcl_mushrooms:mushroom_brown", {
	name = "mushroom_brown",
	desc = S("Brown Mushroom"),
	image = "farming_mushroom_brown.png",
})

mcl_flowerpots.register_potted_flower("mcl_mushrooms:mushroom_red", {
	name = "mushroom_red",
	desc = S("Red Mushroom"),
	image = "farming_mushroom_red.png",
})

mcl_flowerpots.register_potted_flower("mcl_core:sapling", {
	name = "sapling",
	desc = S("Oak Sapling"),
	image = "default_sapling.png",
})

mcl_flowerpots.register_potted_flower("mcl_core:acaciasapling", {
	name = "acaciasapling",
	desc = S("Acacia Sapling"),
	image = "default_acacia_sapling.png",
})

mcl_flowerpots.register_potted_flower("mcl_core:junglesapling", {
	name = "junglesapling",
	desc = S("Jungle Sapling"),
	image = "default_junglesapling.png",
})

mcl_flowerpots.register_potted_flower("mcl_core:darksapling", {
	name = "darksapling",
	desc = S("Dark Oak Sapling"),
	image = "mcl_core_sapling_big_oak.png",
})

mcl_flowerpots.register_potted_flower("mcl_core:sprucesapling", {
	name = "sprucesapling",
	desc = S("Spruce Sapling"),
	image = "mcl_core_sapling_spruce.png",
})

mcl_flowerpots.register_potted_flower("mcl_core:birchsapling", {
	name = "birchsapling",
	desc = S("Birch Sapling"),
	image = "mcl_core_sapling_birch.png",
})

mcl_flowerpots.register_potted_flower("mcl_core:deadbush", {
	name = "deadbush",
	desc = S("Dead Bush"),
	image = "default_dry_shrub.png",
})
