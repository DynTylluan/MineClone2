local S = minetest.get_translator(minetest.get_current_modname())

local seed = minetest.get_mapgen_setting("seed")

minetest.register_chatcommand("seed", {
	description = S("Displays the world seed"),
	params = "",
	privs = {},
	func = function(name)
		minetest.chat_send_player(name, "Seed: "..seed)
	end
})