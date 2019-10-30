new bool:mute[33][33]

new saytext[192]
new SayText

new maxplayers

public say_handle(id)
{
	read_args(saytext, 191)
	remove_quotes(saytext)
	custom_say(id, saytext)
	
	return PLUGIN_HANDLED
}

public custom_say(sender, text[192])
{
	static i, name[32], buffer[256], bufferlen
	
	get_user_name(sender, name, 31)
	
	buffer[0] = 0x03
	
	bufferlen = format(buffer[1], 254, "%s", name)
	
	buffer[bufferlen+1] = 0x01
	
	format(buffer[bufferlen+2], 200, " : %s", text)
	
	
	for(i = 1; i < maxplayers; i++)
	{
		if(!is_user_connected(i))
			continue
		
		if(mute[i][sender])
		{
			continue
		}
		else
		{
			message_begin(MSG_ONE, SayText, _, i)
			write_byte(get_id_on_this_team(get_user_team(sender)))
			write_string(buffer)
			message_end()
		}
	}
}

stock get_id_on_this_team(team)
{
	static i
	
	for(i = 1; i < maxplayers; i++)
	{
		if(team == get_user_team(i))
		{
			return i
		}
	}
	
	return 0
}

public cmd_chatmute(id)
{
	new arg1[32]
	
	read_argv(1, arg1, 31)
	
	new player = cmd_target(id, arg1, 0)

	if(player)
	{
		if(access(player, ADMIN_KICK))
		{
			client_print(id, print_console, "You cannot mute an admin.")
			return PLUGIN_HANDLED
		}
		
		mute[id][player] = !mute[id][player]
		
		new name[32]
		
		get_user_name(player, name, 31)
		
		ColorChat(id,GREEN, "%L", id, "MUTE_CHAT", name, (mute[id][player] ? "" : "MUTE_UNMUTE"));
	}
	
	return PLUGIN_HANDLED
}

public menu_chatmute(id)
{
	new menu = menu_create("[BC] Chat Mute", "menu_chatmute_handler")
	
	new item_name[48], str_i[2]
	
	for(new i = 1; i < maxplayers; i++)
	{
		if(!is_user_connected(i))
			continue
			
		get_user_name(i, item_name, 47)
		format(item_name, 47, "%20s (%smuted)", item_name, (mute[id][i] ? "" : "not "))
		num_to_str(i, str_i, 1)
		
		menu_additem(menu, item_name, str_i)
	}
	
	menu_setprop(menu, MPROP_EXIT, MEXIT_NORMAL)
	
	menu_display(id, menu, 0)
}

public menu_chatmute_handler(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	
	new str_key[3], dummy[2], dummy2
	menu_item_getinfo(menu, item, dummy2, str_key, 2, dummy, 1, dummy2)
	
	new key = str_to_num(str_key)
	
	if(access(key, ADMIN_KICK))
	{
		ColorChat(id,GREEN, "%L", id, "MUTE_ADMIN")
		menu_chatmute(id)
		return PLUGIN_HANDLED
	}
	
	mute[id][key] = !mute[id][key]
	
	menu_chatmute(id)
	
	return PLUGIN_HANDLED
}