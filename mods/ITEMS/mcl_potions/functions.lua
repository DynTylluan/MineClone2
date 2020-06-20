local is_invisible = {}
local is_poisoned = {}
local is_regenerating = {}
local is_strong = {}
local is_weak = {}

local timer = 0
minetest.register_globalstep(function(dtime)

	-- Check for invisible players
	for player, bool in pairs(is_invisible) do
		if is_invisible[player] then
			mcl_potions._add_spawner(player, "#B0B0B0")
		end
	end

	-- Check for poisoned players
	for player, bool in pairs(is_poisoned) do

		if is_poisoned[player] then

			player = player or player:get_luaentity()

			is_poisoned[player].timer = is_poisoned[player].timer + dtime
			is_poisoned[player].hit_timer = (is_poisoned[player].hit_timer or 0) + dtime

			mcl_potions._add_spawner(player, "#225533")

			if is_poisoned[player].hit_timer >= is_poisoned[player].step then
				player:set_hp( math.max(player:get_hp() - 1, 1) )
				is_poisoned[player].hit_timer = 0
			end

			if is_poisoned[player].timer >= is_poisoned[player].dur then
				is_poisoned[player] = nil
			end

		end
	end

end )

-- reset player is_invisible/poison if they go offline
minetest.register_on_leaveplayer(function(player)

	local name = player:get_player_name()

	if is_invisible[name] then
		is_invisible[name] = nil
	end

	if is_poisoned[name] then
		is_poisoned[name] = nil
	end

	if is_regenerating[name] then
		is_regenerating[name] = nil
	end

	if is_strong[name] then
		is_strong[name] = nil
	end

	if is_weak[name] then
		is_weak[name] = nil
	end

end)

function mcl_potions.invisible(player, toggle)

	if not player then return false end

	is_invisible[player:get_player_name()] = toggle

	if toggle then -- hide player
		player:set_properties({visual_size = {x = 0, y = 0}})
		player:set_nametag_attributes({color = {a = 0}})
	else -- show player
		player:set_properties({visual_size = {x = 1, y = 1}})
		player:set_nametag_attributes({color = {a = 255}})
	end

end

function mcl_potions.poison(player, toggle)

	if not player then return false end
	is_poisoned[player:get_player_name()] = toggle

end

function mcl_potions.regenerate(player, toggle)

	if not player then return false end
	is_regenerating[player:get_player_name()] = toggle

end

function mcl_potions._use_potion(item, obj, color)
	local d = 0.1
	local pos = obj:get_pos()
	item:replace("mcl_potions:glass_bottle")
	minetest.sound_play("mcl_potions_drinking")
	minetest.add_particlespawner({
									amount = 25,
									time = 1,
									minpos = {x=pos.x-d, y=pos.y+1, z=pos.z-d},
									maxpos = {x=pos.x+d, y=pos.y+2, z=pos.z+d},
									minvel = {x=-0.1, y=0, z=-0.1},
									maxvel = {x=0.1, y=0.1, z=0.1},
									minacc = {x=-0.1, y=0, z=-0.1},
									maxacc = {x=0.1, y=.1, z=0.1},
									minexptime = 1,
									maxexptime = 5,
									minsize = 0.5,
									maxsize = 1,
									collisiondetection = true,
									vertical = false,
									texture = "mcl_potions_sprite.png^[colorize:"..color..":127",
								})
end


function mcl_potions._add_spawner(obj, color)
	local d = 0.2
	local pos = obj:get_pos()
	minetest.add_particlespawner({
									amount = 2,
									time = 1,
									minpos = {x=pos.x-d, y=pos.y+1, z=pos.z-d},
									maxpos = {x=pos.x+d, y=pos.y+2, z=pos.z+d},
									minvel = {x=-0.1, y=0, z=-0.1},
									maxvel = {x=0.1, y=0.1, z=0.1},
									minacc = {x=-0.1, y=0, z=-0.1},
									maxacc = {x=0.1, y=.1, z=0.1},
									minexptime = 0.5,
									maxexptime = 1,
									minsize = 0.5,
									maxsize = 1,
									collisiondetection = false,
									vertical = false,
									texture = "mcl_potions_sprite.png^[colorize:"..color..":127",
								})
end


local is_zombie = {}

for i, zombie in ipairs({"husk","zombie","pigman"}) do
	is_zombie["mobs_mc:"..zombie] = true
	is_zombie["mobs_mc:baby_"..zombie] = true
end

function mcl_potions.healing_func(player, hp)

	if is_zombie[player:get_entity_name()] then hp = -hp end

	if hp > 0 then
		player:set_hp(math.min(player:get_hp() + hp, player:get_properties().hp_max))
	else
		player:set_hp(math.max(player:get_hp() + hp, 1))
	end

end

function mcl_potions.swiftness_func(player, factor, duration)
	if not player:get_meta() then return false end
	playerphysics.add_physics_factor(player, "speed", "swiftness", factor)
	minetest.after(duration, function() playerphysics.remove_physics_factor(player, "speed", "swiftness") end )
	for i=1,math.floor(duration) do
		minetest.after(i, function() mcl_potions._add_spawner(player, "#009999") end)
	end
end

function mcl_potions.leaping_func(player, factor, duration)
	if player:get_meta() then return false end
	playerphysics.add_physics_factor(player, "jump", "leaping", factor)
	minetest.after(duration, function() playerphysics.remove_physics_factor(player, "jump", "leaping") end )
	for i=1,math.floor(duration) do
		minetest.after(i, function() mcl_potions._add_spawner(player, "#00CC33") end)
	end
end

function mcl_potions.weakness_func(player, factor, duration)
	player:set_attribute("weakness", tostring(factor))
	-- print(player:get_player_name().." ".."weakness = "..player:get_attribute("weakness"))
	minetest.after(duration, function() player:set_attribute("weakness", tostring(0)) end )
	for i=1,math.floor(duration) do
		minetest.after(i, function() mcl_potions._add_spawner(player, "#6600AA") end)
	end
end

function mcl_potions.poison_func(player, factor, duration)

	if not is_poisoned[player] then

		is_poisoned[player] = {step = factor, dur = duration, timer = 0}

	else

		local victim = is_poisoned[player]

		victim.step = math.min(victim.step, factor)
		victim.dur = math.max(duration, victim.dur - victim.timer)
		victim.timer = 0

	end
end

function mcl_potions.regeneration_func(player, factor, duration)
	if not is_regenerating[player:get_player_name()] then
		mcl_potions.regenerate(player, true)
		for i=1,math.floor(duration/factor) do
			minetest.after(i*factor, function()
							if player:get_hp() < 20 then
								player:set_hp(player:get_hp() + 1)
							end
						end  )
		end
		for i=1,math.floor(duration) do
			minetest.after(i, function() mcl_potions._add_spawner(player, "#A52BB2") end)
		end
		minetest.after(duration, function() mcl_potions.regenerate(player, false) end)
	end
end


function mcl_potions.invisiblility_func(player, duration)
	mcl_potions.invisible(player, true)
	minetest.after(duration, function() mcl_potions.invisible(player, false) end )
end

function mcl_potions.water_breathing_func(player, duration)
	if minetest.is_player(player) then

		for i=1,math.floor(duration) do
			minetest.after(i, function()
							if player:get_breath() < 10 then
								player:set_breath(10)
							end
							mcl_potions._add_spawner(player, "#0000AA")
						end  )
		end

	end

end
