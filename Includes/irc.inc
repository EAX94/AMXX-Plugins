new g_plugin_id = -1
new g_func_id = -1
new g_msgbuff[10][256]

stock init_irc(plugin_name[])
{
	g_plugin_id = is_plugin_loaded("chanbot")
	g_func_id = get_func_id("frame_input", g_plugin_id)
	irc_addstr(plugin_name, 1)
	set_task(2.0, "buffer_out")
}
public irc_outmessage(irc_outmsg[])
{
	server_print("writing message: %s", irc_outmsg)
	addtobuff(irc_outmsg)
}

public addtobuff(msg[])
{
	for (new i=0; i<10; i++)
	{
		if (strlen(g_msgbuff[i]) == 0)
		{
			copy(g_msgbuff[i], 255, msg)
			return PLUGIN_CONTINUE
		}
	}
	return PLUGIN_CONTINUE
}

public buffer_out()
{
	set_task(0.3, "buffer_out")
	for (new i=0; i<10; i++)
	{
		if (strlen(g_msgbuff[i]) != 0)
		{
			irc_addstr(g_msgbuff[i], 2)
			copy(g_msgbuff[i], 255, "")
			return PLUGIN_CONTINUE
		}
	}
	return PLUGIN_CONTINUE
}

public irc_addstr(str_out[], flagg)
{
	if (g_plugin_id == -1)
	{
		server_print(">> chanbot plugin not loaded")
	}
	else
	{
		callfunc_begin_i(g_func_id, g_plugin_id)
		callfunc_push_str(str_out)
		callfunc_push_int(flagg)
		callfunc_end()
	}
}
