-- Quartz mod by Jack William

local SPAWN_ATTEMPTS = 30 -- How many times to attempt spawning per chunk
local SPAWN_PROBABILITY = 20 -- Probability of each spawn attempt


-- Node

minetest.register_node("quartz:quartz_ore", {
	description = "Quartz Ore",
	tiles = { "quartz_quartz_ore.png" },
	drop = "quartz:quartz_quartz_fragment",
	groups = { cracky=3, stone=1 },
	sounds = default.node_sound_stone_defaults(),
	
})

minetest.register_node("quartz:polish_quartz", {
	description = "Polish Quartz",
	tiles = { "quartz_polishquartz_bottom.png",
			  "quartz_polishquartz_bottom.png",
			  "quartz_polishquartz_side.png",
			  "quartz_polishquartz_side.png",
			  "quartz_polishquartz_side.png",
			  "quartz_polishquartz_side.png"},
    paramtype2 = "facedir",
	groups = { cracky=3, stone=1 },
	sounds = default.node_sound_stone_defaults(),
	on_place = minetest.rotate_node
})

minetest.register_node("quartz:quartzbrick", {
	description = "Quartz Brick",
	tiles = {"quartz_quartzbrick_bottom.png",
			 "quartz_quartzbrick_bottom.png",
			 "quartz_quartzbrick_side.png",
			 "quartz_quartzbrick_side.png",
			 "quartz_quartzbrick_side.png",
			 "quartz_quartzbrick_side.png"},
	paramtype2 = "facedir",
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
	on_place = minetest.rotate_node
})

minetest.register_craftitem("quartz:quartz_quartz_fragment", {
	description = "Quartz Fragment",
	inventory_image = "quartz_quartz_fragment.png"
})

minetest.register_node("quartz:quartzblock", {
	tiles = {"quartz_quartzblock.png"},
	description = "Quartz Block",
	is_ground_content = false,
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
	
})

-- Craft

minetest.register_craft({
	output = 'quartz:quartzblock',
	recipe = {
		{'quartz:quartz_quartz_fragment', 'quartz:quartz_quartz_fragment', 'quartz:quartz_quartz_fragment'},
		{'quartz:quartz_quartz_fragment', 'quartz:quartz_quartz_fragment', 'quartz:quartz_quartz_fragment'},
		{'quartz:quartz_quartz_fragment', 'quartz:quartz_quartz_fragment', 'quartz:quartz_quartz_fragment'},
	}
})

minetest.register_craft({
	output = 'quartz:quartzbrick',
	recipe = {
		{'', '','' },
		{'', 'quartz:quartzblock',''},
		{'', 'quartz:quartzblock',''},
	}
})

minetest.register_craft({
	output = 'quartz:polish_quartz',
	recipe = {
		{'', '','' },
		{'', 'quartz:quartzbrick',''},
		{'', 'quartz:quartzbrick',''},
	}
})

-- slab

stairs.register_stair_and_slab("quartzblock", "quartz:quartzblock",
		{cracky = 1},
		{"quartz_quartzblock.png"},
		"Quartz Block Stair",
		"Quartz Block Slab",
		default.node_sound_stone_defaults())

set_quartz_ore = function (pos)

		minetest.env:add_node(pos, { name = "quartz:quartz_ore" })
	
	end


-- Spawn

minetest.register_on_generated(function(minp, maxp, seed)
for attempts = 0, SPAWN_ATTEMPTS do
	-- choose a random location on the X and Z axes
	local coords_x = math.random(minp.x, maxp.x)
	local coords_z = math.random(minp.z, maxp.z)

	-- now scan upward until we find a suitable spot on the Y axis, if none is found this attempt is failed
	for coords_y = minp.y, maxp.y do
		local pos_here = { x = coords_x, y = coords_y, z = coords_z }
		local node_here = minetest.env:get_node(pos_here)
		local pos_top = { x = coords_x, y = coords_y + 1, z = coords_z }
		local node_top = minetest.env:get_node(pos_top)

		if (node_here.name == "nether:rack") and (node_top.name == "air") then
			if (math.random() <= SPAWN_PROBABILITY) then
				set_quartz_ore (pos_top)
			end
			break
		end
	end
end
end)
