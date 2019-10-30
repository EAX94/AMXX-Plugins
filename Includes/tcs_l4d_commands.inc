/* ========================================
======== COMMANDS - MENUES - MESSAGES =====
======================================== */


/* ========================================
======== COMMAND ==========================
======================================== */
public clcmd_JoinTeam(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!g_logged[id])
	{
		fn_ShowMenu(id, MENU_REGISTER_LOGIN);
		return PLUGIN_HANDLED;
	}
	
	new iTeam;
	iTeam = fn_GetTeam(id);
	
	if(iTeam != FM_CS_TEAM_UNASSIGNED)
	{
		if(g_zp_id[id] == 1)
			fn_ShowMenu(id, MENU_CHOOSE_ZS);
		
		return PLUGIN_HANDLED;
	}
	
	new sParam[2];
	new iParam;
	
	read_argv(1, sParam, 1);
	iParam = str_to_num(sParam);
	
	switch(iParam)
	{
		case 1: // T
		{
			if(iTeam == FM_CS_TEAM_UNASSIGNED && (fn_CheckAccess(id, true) && !fn_CheckAccess(id, false)))
			{
				client_print(id, print_center, MESSAGE_BO);
				
				client_cmd(id, "chooseteam");
				return PLUGIN_HANDLED;
			}
		}
		case 5: // AUTO - SELECT
		{
			if(iTeam == FM_CS_TEAM_UNASSIGNED)
			{
				client_print(id, print_center, MESSAGE_AK);
				
				client_cmd(id, "chooseteam");
				return PLUGIN_HANDLED;
			}
		}
		case 6: // ESPECTADOR
		{
			if(iTeam == FM_CS_TEAM_UNASSIGNED && !fn_CheckAccess(id, false))
			{
				client_print(id, print_center, MESSAGE_AL);
				
				client_cmd(id, "chooseteam");
				return PLUGIN_HANDLED;
			}
		}
	}
	
	return PLUGIN_CONTINUE;
}

public clcmd_SelectModel(id)
{
	if(is_user_connected(id))
	{
		g_zombie[id] = 1;
		
		set_task(1.0, "fn_RespawnPlayer", id + TASK_SPAWN);
	}
}

public clcmd_CreatePassword(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(g_register[id])
		return PLUGIN_HANDLED;
	
	new sPassword[191];
	
	read_args(sPassword, 190);
	remove_quotes(sPassword);
	trim(sPassword);
	
	new iLen = strlen(sPassword);
	new iLen_Name = strlen(g_playername[id]);
	
	if(iLen_Name < 3)
	{
		client_print(id, print_center, MESSAGE_AM);
		
		fn_ShowMenu(id, MENU_REGISTER_LOGIN);
		return PLUGIN_HANDLED;
	}
	if(iLen < 4)
	{
		client_print(id, print_center, MESSAGE_AN);
		
		fn_ShowMenu(id, MENU_REGISTER_LOGIN);
		return PLUGIN_HANDLED;
	}
	else if(iLen > 31)
	{
		client_print(id, print_center, MESSAGE_AO);
		
		fn_ShowMenu(id, MENU_REGISTER_LOGIN);
		return PLUGIN_HANDLED;
	}
	
	copy(g_password[id], 31, sPassword);
	
	client_cmd(id, "messagemode repeat_password");
	client_print(id, print_center, MESSAGE_AP);
	
	return PLUGIN_HANDLED;
}

public clcmd_RepeatPassword(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(g_register[id])
		return PLUGIN_HANDLED;
	
	new sPassword[191];
	
	read_args(sPassword, 190);
	remove_quotes(sPassword);
	trim(sPassword);
	
	if(!equal(g_password[id], sPassword))
	{
		g_password[id][0] = EOS;
		client_print(id, print_center, MESSAGE_AQ);
	
		fn_ShowMenu(id, MENU_REGISTER_LOGIN);
		return PLUGIN_HANDLED;
	}
	
	g_register[id] = 1;
	g_logged[id] = 1;
	
	client_cmd(id, "chooseteam");
	
	client_print(id, print_center, MESSAGE_AR);
	
	new sIp[21];
	new sMD5_Password[34];
	
	get_user_ip(id, sIp, 20, 1);
	md5(sPassword, sMD5_Password);
	sMD5_Password[6] = EOS; // 6 caracteres de contraseña
	
	new Handle:iSqlQuery;
	
	iSqlQuery = SQL_PrepareQuery(g_sql_connection, "INSERT INTO users (`name`, `pass`, `ip`, `register`, `last_connect`) VALUES (^"%s^", '%s', '%s', now(), now());",
	g_playername[id], sMD5_Password, sIp);
	if(!SQL_Execute(iSqlQuery))
		fn_ExecuteQuery(id, iSqlQuery, "03");
	else
	{
		SQL_FreeHandle(iSqlQuery);
		
		iSqlQuery = SQL_PrepareQuery(g_sql_connection, "SELECT id FROM users WHERE name=^"%s^";", g_playername[id]);
		if(!SQL_Execute(iSqlQuery))
		{
			fn_ExecuteQuery(id, iSqlQuery, "04");
			return PLUGIN_HANDLED;
		}
		else if(SQL_NumResults(iSqlQuery))
		{
			g_zp_id[id] = SQL_ReadResult(iSqlQuery, 0);
			
			SQL_FreeHandle(iSqlQuery);
			
			iSqlQuery = SQL_PrepareQuery(g_sql_connection, "INSERT INTO rewards (`zp_id`) VALUES ('%d');", g_zp_id[id]);
			if(!SQL_Execute(iSqlQuery))
			{
				fn_ExecuteQuery(id, iSqlQuery, "05");
				return PLUGIN_HANDLED;
			}
			else
			{
				SQL_FreeHandle(iSqlQuery);
				
				iSqlQuery = SQL_PrepareQuery(g_sql_connection, "INSERT INTO events (`zp_id`) VALUES ('%d');", g_zp_id[id]);
				if(!SQL_Execute(iSqlQuery))
				{
					fn_ExecuteQuery(id, iSqlQuery, "06");
					return PLUGIN_HANDLED;
				}
				else
				{
					SQL_FreeHandle(iSqlQuery);
					
					new sAccountCount[6];
					fn_AddDot(g_zp_id[id], sAccountCount, 5);
					
					g_insert_stats[id] = 1;
					
					fn_CC(id, MESSAGE_AH, g_playername[id], sAccountCount);
				}
			}
		}
		else
		{
			SQL_FreeHandle(iSqlQuery);
			return PLUGIN_HANDLED;
		}
		
		g_register[id] = 1;
		g_logged[id] = 1;
		
		remove_task(id + TASK_SAVE);
		set_task(random_float(300.0, 600.0), "fn_SaveTask", id + TASK_SAVE, _, _, "b");
		
		fn_ResetInfo(id);
		client_cmd(id, "setinfo zp4 ^"%s^"", sMD5_Password);
		
		client_cmd(id, "chooseteam");
		
		client_print(id, print_center, MESSAGE_AR);
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_EnterPassword(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!g_register[id])
		return PLUGIN_HANDLED;
	
	if(g_logged[id])
		return PLUGIN_HANDLED;
	
	new sPassword[191];
	new sMD5_Password[34];
	
	read_args(sPassword, 190);
	remove_quotes(sPassword);
	trim(sPassword);
	
	md5(sPassword, sMD5_Password);
	sMD5_Password[6] = EOS; // 6 caracteres de contraseña
	
	if(!equal(g_password[id], sMD5_Password))
	{
		client_print(id, print_center, MESSAGE_AS);
		
		fn_ShowMenu(id, MENU_REGISTER_LOGIN);
		return PLUGIN_HANDLED;
	}
	
	g_logged[id] = 1;
	client_print(id, print_center, MESSAGE_AT, g_playername[id]);
	
	set_task(random_float(300.0, 600.0), "fn_SaveTask", id + TASK_SAVE, _, _, "b");
	
	fn_ResetInfo(id);
	client_cmd(id, "setinfo zp4 ^"%s^"", sMD5_Password);
	
	client_cmd(id, "chooseteam");
	
	return PLUGIN_HANDLED;
}

public clcmd_AngryWitch(id)
{
	if(g_zp_id[id] != 1)
		return PLUGIN_HANDLED;
	
	new i;
	new iUser = 0;
	
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_alive(i))
			continue;
		
		if(g_witch[i])
		{
			iUser = i;
			break;
		}
	}
	
	if(!iUser)
		return PLUGIN_HANDLED;
	
	g_witch_angry[iUser] = 1;
	ExecuteHamB(Ham_Player_ResetMaxSpeed, iUser);
	
	fn_EmitSound(0, g_witch_sound_angry, 0.0, 0);
	
	remove_task(TASK_REPEAT_SOUND);
	set_task(30.5, "fn_RepeatWitchSound", TASK_REPEAT_SOUND);
	
	return PLUGIN_HANDLED;
}

public clcmd_OriginHorde(id)
{
	if(g_zp_id[id] != 1)
		return PLUGIN_HANDLED;
	
	if(g_origin_horde_count[0] == 128)
	{
		client_print(id, print_center, "Origin Horde Reiniciado!");
		
		g_origin_horde_count[0] = 0;
	}
	
	client_print(id, print_center, "Origin Horde: %d", g_origin_horde_count[0]);
	
	entity_get_vector(id, EV_VEC_origin, g_origin_horde[g_origin_horde_count[0]]);
	
	++g_origin_horde_count[0];
	
	return PLUGIN_HANDLED;
}

public clcmd_OriginZS(id)
{
	if(g_zp_id[id] != 1)
		return PLUGIN_HANDLED;
	
	if(g_origin_zs_count[0] == 128)
	{
		client_print(id, print_center, "Origin ZS Reiniciado!");
		
		g_origin_zs_count[0] = 0;
	}
	
	client_print(id, print_center, "Origin ZS: %d", g_origin_zs_count[0]);
	
	entity_get_vector(id, EV_VEC_origin, g_origin_zs[g_origin_zs_count[0]]);
	
	++g_origin_zs_count[0];
	
	return PLUGIN_HANDLED;
}

public clcmd_OriginTW(id)
{
	if(g_zp_id[id] != 1)
		return PLUGIN_HANDLED;
	
	entity_get_vector(id, EV_VEC_origin, g_origin_tw);
	
	return PLUGIN_HANDLED;
}

public clcmd_Drop(id)
{
	if(!g_human_weaps[id])
		return PLUGIN_CONTINUE;
	
	return PLUGIN_HANDLED;
}

public clcmd_Radio(id)
{
	if(g_allowed_human[id])
		return PLUGIN_CONTINUE;
	
	return PLUGIN_HANDLED;
}

public clcmd_ZS(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!g_zombie[id])
		return PLUGIN_HANDLED;
	
	if(g_zs_need[id])
		return PLUGIN_HANDLED;
	
	g_zs_need[id] = 1;
	
	fn_CC(id, MESSAGE_BD);
	
	return PLUGIN_HANDLED;
}

public clcmd_Weap(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(g_zombie[id])
		return PLUGIN_HANDLED;
	
	if(g_human_weaps[id])
		return PLUGIN_HANDLED;
	
	fn_ShowMenu(id, MENU_CHOOSE_WEAPONS);
	
	return PLUGIN_HANDLED;
}

public clcmd_Say(id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	static sMessage[191];
	
	read_args(sMessage, charsmax(sMessage));
	remove_quotes(sMessage);
	
	if(equal(sMessage, ""))
		return PLUGIN_HANDLED;
	
	if(g_zp_id[id] == 1)
	{
		if(sMessage[0] == '/')
		{
			if(sMessage[1] == 'a')
			{
				new i;
				for(i = 1; i <= g_maxplayers; ++i)
				{
					if(!is_user_connected(i))
						continue;
					
					if(g_allowed_human[i] || g_zp_id[i] == 1)
					{
						fn_CC(i, MESSAGE_BM);
						fn_CC(i, MESSAGE_BN);
					}
				}
			}
			else if(sMessage[1] == 'b')
			{
				new i;
				for(i = 1; i <= g_maxplayers; ++i)
				{
					if(!is_user_connected(i))
						continue;
					
					if(g_allowed_human[i] || g_zp_id[i] == 1)
						fn_CC(i, MESSAGE_BP);
				}
				
				set_task(58.0, "fn_BlockSecWeapons");
			}
			else if(sMessage[1] == 'c')
			{
				g_view[id] = !g_view[id];
				set_view(id, g_view[id] ? CAMERA_3RDPERSON : CAMERA_NONE);
			}
			else if(sMessage[1] == 'd')
			{
				g_origin_horde_count = {0, 0};
				client_print(id, print_center, "Origin Horde: Reiniciado");
			}
			else if(sMessage[1] == 'e')
			{
				g_origin_zs_count = {0, 0};
				client_print(id, print_center, "Origin ZS: Reiniciado");
			}
			else if(equal(sMessage, "/puerta1"))
			{
				new iEnt;
				new sTargetName[64];
				
				while((iEnt = find_ent_by_class(iEnt, "func_door")) != 0)
				{
					entity_get_string(iEnt, EV_SZ_targetname, sTargetName, charsmax(sTargetName));
					
					if(!equal(sTargetName, "entrada-s"))
						dllfunc(DLLFunc_Use, iEnt);
				}
			}
			else if(equal(sMessage, "/puerta2"))
			{
				new iEnt;
				new sTargetName[64];
				
				while((iEnt = find_ent_by_class(iEnt, "func_door_rotating")) != 0)
				{
					entity_get_string(iEnt, EV_SZ_targetname, sTargetName, charsmax(sTargetName));
					
					if(equal(sTargetName, "puerta_final"))
						dllfunc(DLLFunc_Use, iEnt);
				}
				
				fn_CC(0, MESSAGE_BQ);
				fn_CC(0, MESSAGE_BQ);
				fn_CC(0, MESSAGE_BQ);
			}
			else if(equal(sMessage, "/guardar"))
			{
				fn_CC(0, "!g[TORNEO L4D]!y Guardando estadisticas del equipo");
				
				fn_SaveAll();
				fn_SaveTeam(id);
				
				new i;
				new iGetHealth = 0;
				
				for(i = 1; i <= g_maxplayers; ++i)
				{
					if(!is_user_connected(i))
						continue;
					
					if(!is_user_alive(i))
						continue;
					
					if(g_allowed_human[i])
						iGetHealth += get_user_health(i);
				}
				
				fn_CC(id, "%d", iGetHealth);
			}
			
			return PLUGIN_HANDLED;
		}
		
		fn_CC(0, "!g%s!y : %s", g_playername[id], sMessage);
	}
	else
	{
		replace_all(sMessage, charsmax(sMessage), "%s", "% s");
		replace_all(sMessage, charsmax(sMessage), "!y", "");
		replace_all(sMessage, charsmax(sMessage), "!t", "");
		replace_all(sMessage, charsmax(sMessage), "!g", "");
		
		new iAlive;
		new idTeam;
		new iTeam;
		new iColor = DONT_CHANGE;
		
		iAlive = is_user_alive(id);
		idTeam = fn_GetTeam(id);
		
		if(idTeam == FM_CS_TEAM_UNASSIGNED || idTeam == FM_CS_TEAM_SPECTATOR)
		{
			format(sMessage, charsmax(sMessage), "!y(ESPECTADOR) !t%s!y : %s", g_playername[id], sMessage);
			iColor = SPECTATOR;
		}
		else
		{
			static sClass[32];
			formatex(sClass, 31, "%s", g_boomer[id] ? "!gBOOMER!y" : g_smoker[id] ? "!gSMOKER!y" : g_hunter[id] ? "!gHUNTER!y" : g_tank[id] ? "!gTANK!y" : g_witch[id] ? "!gWITCH!y" : "Zombie");
	
			format(sMessage, charsmax(sMessage), "!y%s(%s) !t%s!y : %s", (iAlive) ? "" : "*DEAD* ", (!g_allowed_human[id]) ? sClass : "Humano", g_playername[id], sMessage);
			
			if(idTeam == FM_CS_TEAM_T)
				iColor = TERRORIST;
			else
				iColor = CT;
		}
		
		replace_all(sMessage, charsmax(sMessage), "!y", "^x01");
		replace_all(sMessage, charsmax(sMessage), "!t", "^x03");
		replace_all(sMessage, charsmax(sMessage), "!g", "^x04");
		
		new i;
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_user_connected(i))
				continue;
			
			if(g_zp_id[i] == 1)
			{
				fn_CC_Best(i, iColor, sMessage);
				continue;
			}
			
			iTeam = fn_GetTeam(i);
			
			if(iAlive)
			{
				if(is_user_alive(i) && iTeam == idTeam)
					fn_CC_Best(i, iColor, sMessage);
			}
			else
			{
				if(!is_user_alive(i) && iTeam == idTeam)
					fn_CC_Best(i, iColor, sMessage);
			}
		}
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_SayTeam(id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	static sMessage[191];
	
	read_args(sMessage, charsmax(sMessage));
	remove_quotes(sMessage);
	
	replace_all(sMessage, charsmax(sMessage), "%s", "% s");
	replace_all(sMessage, charsmax(sMessage), "!y", "");
	replace_all(sMessage, charsmax(sMessage), "!t", "");
	replace_all(sMessage, charsmax(sMessage), "!g", "");
	
	if(equal(sMessage, ""))
		return PLUGIN_HANDLED;
	
	new iAlive;
	new idTeam;
	new iTeam;
	new iColor = DONT_CHANGE;
	
	iAlive = is_user_alive(id);
	idTeam = fn_GetTeam(id);
	
	if(idTeam == FM_CS_TEAM_UNASSIGNED || idTeam == FM_CS_TEAM_SPECTATOR)
	{
		format(sMessage, charsmax(sMessage), "!y(ESPECTADOR) !t%s!y : %s", g_playername[id], sMessage);
		iColor = SPECTATOR;
	}
	else
	{
		static sClass[32];
		formatex(sClass, 31, "%s", g_boomer[id] ? "!gBOOMER!y" : g_smoker[id] ? "!gSMOKER!y" : g_hunter[id] ? "!gHUNTER!y" : g_tank[id] ? "!gTANK!y" : g_witch[id] ? "!gWITCH!y" : "Zombie");
		
		format(sMessage, charsmax(sMessage), "!y%s(%s) !t%s!y : %s", (iAlive) ? "" : "*DEAD* ", (!g_allowed_human[id]) ? sClass : "Humano", g_playername[id], sMessage);
		
		if(idTeam == FM_CS_TEAM_T)
			iColor = TERRORIST;
		else
			iColor = CT;
	}
	
	replace_all(sMessage, charsmax(sMessage), "!y", "^x01");
	replace_all(sMessage, charsmax(sMessage), "!t", "^x03");
	replace_all(sMessage, charsmax(sMessage), "!g", "^x04");
	
	new i;
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		if(g_zp_id[i] == 1)
		{
			fn_CC_Best(i, iColor, sMessage);
			continue;
		}
		
		iTeam = fn_GetTeam(i);
		
		if(iAlive)
		{
			if(is_user_alive(i) && iTeam == idTeam)
				fn_CC_Best(i, iColor, sMessage);
		}
		else
		{
			if(!is_user_alive(i) && iTeam == idTeam)
				fn_CC_Best(i, iColor, sMessage);
		}
	}
	
	return PLUGIN_HANDLED;
}

public impulse_FlashLight(id)
	return PLUGIN_HANDLED;

public impulse_Spray(id)
	return PLUGIN_HANDLED;

/* ========================================
======== MENUES ===========================
======================================== */
public menucmd_TeamSelect(const id, const key)
{ 
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!g_logged[id])
	{
		fn_ShowMenu(id, MENU_REGISTER_LOGIN);
		return PLUGIN_HANDLED;
	}
	
	new iTeam;
	iTeam = fn_GetTeam(id);
	
	if(iTeam != FM_CS_TEAM_UNASSIGNED)
		return PLUGIN_HANDLED;
	
	switch(key)
	{
		case 0:
		{
			if(iTeam == FM_CS_TEAM_UNASSIGNED && (fn_CheckAccess(id, true) && !fn_CheckAccess(id, false)))
			{
				client_print(id, print_center, MESSAGE_BO);
				
				client_cmd(id, "chooseteam");
				return PLUGIN_HANDLED;
			}
		}
		case 4: // AUTO - SELECT
		{
			if(iTeam == FM_CS_TEAM_UNASSIGNED)
			{
				client_print(id, print_center, MESSAGE_AK);
				
				client_cmd(id, "chooseteam");
				return PLUGIN_HANDLED;
			}
		}
		case 5: // ESPECTADOR
		{
			if(iTeam == FM_CS_TEAM_UNASSIGNED && !fn_CheckAccess(id, false))
			{
				client_print(id, print_center, MESSAGE_AL);
				
				client_cmd(id, "chooseteam");
				return PLUGIN_HANDLED;
			}
		}
	}
	
	return PLUGIN_CONTINUE;
}

public menu_RegisterLogin(const id, const key)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(g_logged[id])
		return PLUGIN_HANDLED;
	
	switch(key)
	{
		case 0:
		{
			if(g_register[id])
			{
				client_print(id, print_center, MESSAGE_AU);
				
				fn_ShowMenu(id, MENU_REGISTER_LOGIN);
				return PLUGIN_HANDLED;
			}
			
			client_cmd(id, "messagemode create_password");
			client_print(id, print_center, MESSAGE_AV);
		}
		case 1:
		{
			if(!g_register[id])
			{
				client_print(id, print_center, MESSAGE_AW);
				
				fn_ShowMenu(id, MENU_REGISTER_LOGIN);
				return PLUGIN_HANDLED;
			}
			
			client_cmd(id, "messagemode enter_password");
			client_print(id, print_center, MESSAGE_AX);
		}
		default: fn_ShowMenu(id, MENU_REGISTER_LOGIN);
	}
	
	return PLUGIN_HANDLED;
}

public menu_Admin(const id, const key)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(g_zp_id[id] != 1)
		return PLUGIN_HANDLED;
	
	if(key >= 0 && key <= 5)
	{
		g_admin_choose_zs = key + 1;
		
		fn_ShowMenu(id, MENU_CHOOSE_PLAYER_ZS);
		return PLUGIN_HANDLED;
	}
	
	switch(key)
	{
		case 6:
		{
			g_allowed_respawn = !g_allowed_respawn;
			fn_CC(id, MESSAGE_BE, g_allowed_respawn ? "Habilitado" : "Deshabilitado");
			
			if(g_allowed_respawn)
			{
				new i;
				for(i = 1; i <= g_maxplayers; ++i)
				{
					if(is_user_connected(i) && g_zombie[i] && !is_user_alive(i))
						set_task(1.0, "fn_RespawnPlayer", i + TASK_SPAWN);
				}
			}
		}
		case 7: // ¡ Ataque Inminente !
		{
			new iCountDead = 0;
			new i;
			
			for(i = 1; i <= g_maxplayers; ++i)
			{
				if(is_user_connected(i) && !is_user_alive(i))
					++iCountDead;
			}
			
			if(iCountDead >= 7)
			{
				g_allowed_respawn = 1;
				
				for(i = 1; i <= g_maxplayers; ++i)
				{
					if(is_user_connected(i) && g_zombie[i] && !is_user_alive(i))
						set_task(2.1, "fn_RespawnPlayer", i + TASK_SPAWN);
				}
				
				fn_CC(0, MESSAGE_BF);
				
				fn_EmitSound(id, g_sound_horde, 0.0, 0); // ggg
			}
		}
		case 9:	return PLUGIN_HANDLED;
	}
	
	fn_ShowMenu(id, MENU_CHOOSE_ZS);
	return PLUGIN_HANDLED;
}

public menu_ChoosePlayerZS(const id, const menuid, const item)
{
	if(!is_user_connected(id))
	{
		menu_destroy(menuid);
		return PLUGIN_HANDLED;
	}
	
	static menudummy;
	player_menu_info(id, menudummy, menudummy, g_admin_choose_zs_page);
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid);
		
		fn_ShowMenu(id, MENU_CHOOSE_ZS);
		return PLUGIN_HANDLED;
	}
	
	static iBuffer[2];
	static iDummy;
	static iId;
	
	menu_item_getinfo(menuid, item, iDummy, iBuffer, charsmax(iBuffer), _, _, iDummy);
	iId = iBuffer[0];
	
	if(is_user_connected(iId))
	{
		if(g_admin_choose_zs != ZOMBIE_JOCKEY)
		{
			g_respawn_as_zombie[iId] = g_admin_choose_zs;
			
			if(g_admin_choose_zs == ZOMBIE_WITCH || g_admin_choose_zs == ZOMBIE_TANK)
			{
				user_silentkill(iId);
				ExecuteHamB(Ham_CS_RoundRespawn, iId);
			}
		}
		else
		{
			g_allowed_human[iId] = 1;
			
			user_silentkill(iId);
			
			new i;
			for(i = 1; i <= g_maxplayers; ++i)
			{
				if(is_user_alive(i))
					strip_user_weapons(i);
			}
		}
	}
	
	menu_destroy(menuid);
	
	fn_ShowMenu(id, MENU_CHOOSE_PLAYER_ZS);
	return PLUGIN_HANDLED;
}

public menu_BuySecWeapons(const id, const key)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(g_human_weaps[id])
		return PLUGIN_HANDLED;
	
	if(key >= 9)
		return PLUGIN_HANDLED;
	
	give_item(id, WEAPON_SEC_ENT_NAMES[key]);
	
	g_human_weaps[id] = 1;
	
	return PLUGIN_HANDLED;
}


/* ========================================
======== MESSAGES =========================
======================================== */
public message_TeamInfo(msg_id, msg_dest)
{
	if(msg_dest != MSG_ALL && msg_dest != MSG_BROADCAST)
		return;
	
	if(g_switchingteam)
		return;
	
	static id;
	id = get_msg_arg_int(1);
	
	if(!(1 <= id <= g_maxplayers))
		return;
	
	static sTeam[2];
	get_msg_arg_string(2, sTeam, 1);
	
	switch(sTeam[0])
	{
		case 'C': // CT
		{
			remove_task(id + TASK_TEAM);
			
			if(g_allowed_human[id])
			{
				fn_SetTeam(id, FM_CS_TEAM_CT);
				set_msg_arg_string(2, "CT");
			}
			else
			{
				fn_SetTeam(id, FM_CS_TEAM_T);
				set_msg_arg_string(2, "TERRORIST");
			}
		}
		case 'T': // Terrorist
		{
			remove_task(id + TASK_TEAM);
			
			fn_SetTeam(id, FM_CS_TEAM_T);
			set_msg_arg_string(2, "TERRORIST");
		}
	}
}

public message_Money(msg_id, msg_dest, msg_entity)
{
	if(!is_user_connected(msg_entity))
		return PLUGIN_HANDLED;
	
	cs_set_user_money(msg_entity, 0, 0);
	return PLUGIN_HANDLED;
}

public message_Health(msg_id, msg_dest, msg_entity)
{
	if(!is_user_connected(msg_entity))
		return;
	
	static iHealth;
	iHealth = get_msg_arg_int(1);
	
	if(iHealth < 256)
		return;
	
	if(iHealth % 256 == 0)
		set_user_health(msg_entity, get_user_health(msg_entity) + 1);
	
	set_msg_arg_int(1, get_msg_argtype(1), 255);
}

public message_FlashBat(msg_id, msg_dest, msg_entity)
{
	if(get_msg_arg_int(1) < 100)
	{
		set_msg_arg_int(1, ARG_BYTE, 100);
		fn_SetBatteries(msg_entity, 100);
	}
}

public message_Flashlight(msg_id, msg_dest, msg_entity)
	set_msg_arg_int(2, ARG_BYTE, 100);

public message_RoundTime()
	set_msg_arg_int(1, ARG_SHORT, (get_timeleft() - 480));