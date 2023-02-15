--local deepslate_mod = minetest.get_modpath("mcl_deepslate")

--[[
local stairs = {
	{"stair", "exposed", "_inner", "cut_inner"},
	{"stair", "weathered", "_inner", "exposed_cut_inner"},
	{"stair", "exposed", "_outer", "cut_outer"},
	{"stair", "weathered", "_outer", "exposed_cut_outer"},
	{"stair", "oxidized", "_outer", "weathered_cut_outer"},
	{"stair", "oxidized", "_inner", "weathered_cut_inner"},
	{"slab", "exposed", "","cut"},
	{"slab", "oxidized", "","weathered_cut"},
	{"slab", "weathered", "","exposed_cut"},
	{"slab", "exposed", "_top","cut_top"},
	{"slab", "oxidized", "_top", "weathered_cut_top"},
	{"slab", "weathered", "_top","exposed_cut_top"},
	{"slab", "exposed", "_double","cut_double"},
	{"slab", "oxidized", "_double","weathered_cut_double"},
	{"slab", "weathered", "_double","exposed_cut_double"},
	{"stair", "exposed", "","cut"},
	{"stair", "oxidized", "", "weathered_cut"},
	{"stair", "weathered", "", "exposed_cut"},
}]]

local block_oxidation = {
	{ "", "_exposed" },
	{ "_cut", "_exposed_cut" },
	{ "_exposed", "_weathered" },
	{ "_exposed_cut", "_weathered_cut" },
	{ "_weathered", "_oxidized" },
	{ "_weathered_cut", "_oxidized_cut" }
}

local stair_oxidation = {
	{ "stair", "cut", "exposed_cut" },
	{ "stair", "cut_inner", "exposed_cut_inner" },
	{ "stair", "cut_outer", "exposed_cut_outer" },
	{ "stair", "exposed_cut", "weathered_cut" },
	{ "stair", "exposed_cut_inner", "weathered_cut_inner" },
	{ "stair", "exposed_cut_outer", "weathered_cut_outer" },
	{ "stair", "weathered_cut", "oxidized_cut" },
	{ "stair", "weathered_cut_inner", "oxidized_cut_inner" },
	{ "stair", "weathered_cut_outer", "oxidized_cut_outer" }
}

local slab_oxidization = {
	{ "slab", "cut", "exposed_cut" },
	{ "slab", "cut_top", "exposed_cut_top" },
	{ "slab", "cut_double", "exposed_cut_double" },
	{ "slab", "exposed_cut", "weathered_cut" },
	{ "slab", "exposed_cut_top", "weathered_cut_top" },
	{ "slab", "exposed_cut_double", "weathered_cut_double" },
	{ "slab", "weathered_cut", "oxidized_cut" },
	{ "slab", "weathered_cut_top", "oxidized_cut_double" },
	{ "slab", "weathered_cut_double", "oxidized_cut_double" },
}

for _, b in pairs(block_oxidation) do
	register_oxidation_abm("mcl_copper:block" .. b[1])
end

local def
local def_variant_oxidized
local def_variant_waxed
-- local def_variant_scraped

for _, s in pairs(stair_oxidation) do
	register_oxidation_abm("Copper oxidation", "mcl_stairs:" .. s[1] .. "_copper_" .. s[2])
	def = "mcl_stairs:" .. s[1] .. "_copper_" .. s[2]
	def_variant_oxidized = "mcl_stairs:" .. s[1] .. "_copper_" .. s[3]
	minetest.override_item(def, { _mcl_oxidized_variant = def_variant_oxidized })

	def_variant_waxed = "mcl_stairs:" .. s[1] .. "_copper_" .. s[2] .. "_waxed"
	minetest.override_item(def, { _mcl_copper_waxed_variant = def_variant_waxed })
end
for _, s in pairs(slab_oxidization) do
	register_oxidation_abm("Copper oxidation", "mcl_stairs:" .. s[1] .. "_copper_" .. s[2])
	def = "mcl_stairs:" .. s[1] .. "_copper_" .. s[2]
	def_variant_oxidized = "mcl_stairs:" .. s[1] .. "_copper_" .. s[3]
	minetest.override_item(def, { _mcl_oxidized_variant = def_variant_oxidized })

	def_variant_waxed = "mcl_stairs:" .. s[1] .. "_copper_" .. s[2] .. "_waxed"
	minetest.override_item(def, { _mcl_copper_waxed_variant = def_variant_waxed })
end
-- TODO: Do Scraped (mcl_stripped_variant) for stairs and slabs.

