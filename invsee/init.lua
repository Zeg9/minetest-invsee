
minetest.register_privilege("invsee","See other's inventories")

minetest.create_detached_inventory("invsee", {
	allow_move = function() return 0 end,
	allow_put = function() return 0 end,
	allow_take = function() return 0 end,
})

local function generate_formspec(player, target, list, start_item)
	formspec = "size[8,7.5]"
		.. "button[0,0;2,.5;main;Back]"
		.. "field[0.33,1.33;2,.5;invsee_inv;Target:;"..(target or "").."]"
		.. "field[2.33,1.33;2,.5;invsee_list;List:;"..(list or "").."]"
		.. "field[4.33,1.33;2,.5;invsee_start_item;Starting at:;"..(start_item or '0').."]"
		.. "button[6,1;2,.5;invsee;Open]"
	if target and list and start_item then
		local target_player = minetest.env:get_player_by_name(target)
		if target_player then
			inv = minetest.get_inventory({type="detached",name="invsee"})
			inv:set_list(player:get_player_name(), target_player:get_inventory():get_list(list))
			formspec = formspec .. "list[detached:invsee;"..player:get_player_name()..";0,2;8,4;"..start_item.."]"
		else
			formspec = formspec .. "label[0,2;Couldn't find target !]"
		end
	end
	inventory_plus.set_inventory_formspec(player, formspec)
end

minetest.register_on_joinplayer(function(player)
	if minetest.get_player_privs(player:get_player_name()).invsee then
		inventory_plus.register_button(player,"invsee","Invsee")
	end
end)

minetest.register_on_player_receive_fields(function(player,formname,fields)
	if fields.invsee and minetest.get_player_privs(player:get_player_name()).invsee then
		generate_formspec(player, fields.invsee_inv, fields.invsee_list, fields.invsee_start_item)
	end
end)

