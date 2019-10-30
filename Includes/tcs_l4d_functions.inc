/* ========================================
======== EVENTS - FUNCTIONS - OTHERS ======
======================================== */


/* ========================================
======== EVENTS ===========================
======================================== */
public event_TeamInfo()
{
	new id;
	id = read_data(1);
	
	if(is_user_connected(id) && !is_user_alive(id))
	{
		new pTeam;
		pTeam = get_pdata_int(id, OFFSET_CSTEAMS, OFFSET_LINUX);
		
		if(pTeam != get_user_team(id))
		{
			emessage_begin(MSG_BROADCAST, g_message_scoreinfo);
			ewrite_byte(id);
			ewrite_short(get_user_frags(id));
			ewrite_short(get_pdata_int(id, 444, OFFSET_LINUX));
			ewrite_short(0);
			ewrite_short(pTeam);
			emessage_end();
		}
	}
}

/* ========================================
======== FUNCTIONS ========================
======================================== */

public fn_PluginSQL()
{
	set_cvar_num("sv_alltalk", 1);
	set_cvar_num("sv_voicequality", 5);
	set_cvar_num("sv_maxspeed", 9999);
	set_cvar_num("sv_airaccelerate", 100);
	set_cvar_num("mp_playerid", 1);
	set_cvar_num("mp_flashlight", 0);
	set_cvar_num("mp_footsteps", 1);
	set_cvar_num("mp_freezetime", 0);
	set_cvar_num("mp_autoteambalance", 0);
	set_cvar_num("mp_limitteams", 0);
	set_cvar_num("pbk_afk_time", 9999);
	
	set_cvar_string("sv_voicecodec", "voice_speex");
	
	g_sql_tuple = SQL_MakeDbTuple(SQL_HOST, SQL_USER, SQL_PASS, SQL_TABLE);
	if(g_sql_tuple == Empty_Handle)
	{
		log_to_file("l4d_sql_tuple.log", "%s", g_sql_error);
		set_fail_state(g_sql_error);
	}
	
	new iSql_ErrorNum;
	
	g_sql_connection = SQL_Connect(g_sql_tuple, iSql_ErrorNum, g_sql_error, 511);
	if(g_sql_connection == Empty_Handle)
	{
		log_to_file("l4d_sql_connect.log", "%s", g_sql_error);
		set_fail_state(g_sql_error);
	}
}

public fn_CheckAccess(const id, const team_ct)
{
	if(team_ct)
	{
		new allowed_ids[4];
		new i;
		
		allowed_ids[0] = get_pcvar_num(g_pCVAR_human[0]);
		allowed_ids[1] = get_pcvar_num(g_pCVAR_human[1]);
		allowed_ids[2] = get_pcvar_num(g_pCVAR_human[2]);
		allowed_ids[3] = get_pcvar_num(g_pCVAR_human[3]);
		
		for(i = 0; i < 4; ++i)
		{
			if(g_zp_id[id] == allowed_ids[i])
				return 1;
		}
	}
	
	if(g_zp_id[id] == 1)
		return 1;
	
	return 0;
}

public fn_ResetVars(const id, const mode)
{
	if(mode)
	{
		g_logged[id] = g_register[id] = g_boomer_vomit_humans[id] = g_boomer_vomit_zombies[id] = g_zs_need[id] = g_allowed_human[id] = g_respawn_as_zombie[id] = g_adrenalina[id] = g_count_zs_total[id] = g_human_coold[id] = g_human_weaps[id] = 0;
		g_kill_zombies[id] = g_damage_zombies[id] = g_damage_tank[id] = g_kill_pipe[id] = g_kill_humans[id] = g_damage_humans[id] = g_smoker_humans[id] = g_damage_hunter_humans[id] = g_damage_tank_humans[id] = g_damage_witch_humans[id] = 0;
		
		g_zp_id[id] = -1;
		
		g_insert_stats[id] = 1;
		
		g_count_zs[id] = {0, 0, 0, 0, 0, 0, 0};
	}
	
	g_boomer[id] = g_smoker[id] = g_hunter[id] = g_tank[id] = g_witch[id] = g_zombie[id] = g_view[id] = g_smoker_tongued[id] = g_nomove[id] = g_hunter_longjump[id] = g_witch_angry[id] = g_smoker_victim[id] = 0;
	
	g_boomer_last_vomit[id] = g_smoker_last_tong[id] = g_hunter_lj_last_time[id] = g_tank_last_rock[id] = 0.00;
}

public fn_LoadIds(const id)
{
	if(!is_user_connected(id))
		return;
	
	set_lights("j"); // j
	
	new Handle:iSqlQuery;
	
	iSqlQuery = SQL_PrepareQuery(g_sql_connection, "SELECT id, pass, ip FROM users WHERE name = ^"%s^";", g_playername[id]);
	if(!SQL_Execute(iSqlQuery))
		fn_ExecuteQuery(id, iSqlQuery, "01");
	else if(SQL_NumResults(iSqlQuery)) // Registrado
	{
		new sIp[21];
		new sSql_Ip[21];
		new sPassword[32];
		
		g_zp_id[id] = SQL_ReadResult(iSqlQuery, 0);
		SQL_ReadResult(iSqlQuery, 1, g_password[id], 31);
		SQL_ReadResult(iSqlQuery, 2, sSql_Ip, 20);
		
		get_user_info(id, "zp4", sPassword, 31);
		get_user_ip(id, sIp, 20, 1);
		
		g_register[id] = 1;
		
		if(g_zp_id[id] == get_pcvar_num(g_pCVAR_human[0]) || g_zp_id[id] == get_pcvar_num(g_pCVAR_human[1]) || g_zp_id[id] == get_pcvar_num(g_pCVAR_human[2]) || g_zp_id[id] == get_pcvar_num(g_pCVAR_human[3]))
			g_allowed_human[id] = 1;
		
		SQL_FreeHandle(iSqlQuery);
		
		iSqlQuery = SQL_PrepareQuery(g_sql_connection, "SELECT zp_id FROM bans WHERE zp_id = %d;", g_zp_id[id]);
		if(!SQL_Execute(iSqlQuery))
			fn_ExecuteQuery(id, iSqlQuery, "02");
		else if(SQL_NumResults(iSqlQuery)) // Baneado
		{
			SQL_FreeHandle(iSqlQuery);
			
			if(is_user_valid_connected(id))
				server_cmd("kick #%d ^"Tu cuenta está baneada. No puedes jugar el torneo^"", get_user_userid(id));
		}
		else
		{
			SQL_FreeHandle(iSqlQuery);
			
			iSqlQuery = SQL_PrepareQuery(g_sql_connection, "SELECT zp_id FROM torneo_users WHERE partido = %d;", g_torneo_partido);
			if(!SQL_Execute(iSqlQuery))
				fn_ExecuteQuery(id, iSqlQuery, "08");
			else if(SQL_NumResults(iSqlQuery))
				g_insert_stats[id] = 0;
			
			SQL_FreeHandle(iSqlQuery);
			
			if(equal(sSql_Ip, sIp) && equal(g_password[id], sPassword)) // Logeado automáticamente
			{
				g_logged[id] = 1;
				
				remove_task(id + TASK_SAVE);
				set_task(random_float(300.0, 600.0), "fn_SaveTask", id + TASK_SAVE, _, _, "b");
			}
			else clcmd_JoinTeam(id);
		}
	}
	else
	{
		SQL_FreeHandle(iSqlQuery);
		clcmd_JoinTeam(id);
	}
}

public fn_ExecuteQuery(const id, const Handle:query, const query_num[])
{
	SQL_QueryError(query, g_sql_error, 511);
	
	log_to_file("l4d_sql.log", "- LOG: %s - %s", query_num, g_sql_error);
	
	if(is_user_valid_connected(id))
		server_cmd("kick #%d ^"Hubo un error al guardar/cargar tus datos. Intente mas tarde^"", get_user_userid(id));
	
	SQL_FreeHandle(query);
}

public fn_ShowMenu(const id, const menu)
{
	if(!is_user_connected(id))
		return;
	
	switch(menu)
	{
		case MENU_REGISTER_LOGIN:
		{
			static sMenu[250];
			static iLen;
			
			iLen = 0;
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yBienvenido al \rTorneo de ZP^n\wLEFT 4 DEAD^n^n\
			\r1.%s REGISTRARSE^n\
			\r2.%s IDENTIFICARSE", (g_register[id]) ? "\d" : "\w", (g_register[id]) ? "\w" : "\d");
			
			set_pdata_int(id, OFFSET_CSMENUCODE, 0);
			show_menu(id, KEYS_MENU, sMenu, -1, "Register Login Menu");
		}
		case MENU_CHOOSE_ZS:
		{
			if(g_zp_id[id] != 1)
				return;
			
			static sMenu[300];
			static iLen;
			static iCant;
			static i;
			
			iLen = 0;
			iCant = 0;
			
			for(i = 1; i <= g_maxplayers; ++i)
			{
				if(!is_user_connected(i))
					continue;
				
				if(g_zs_need[i])
					++iCant;
			}
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yADMINISTRACION:^n^n\
			\wQuieren ser zombies: \y%d^n^n\
			\r1.\w Boomer [%d]^n\
			\r2.\w Smoker [%d]^n\
			\r3.\w Hunter [%d]^n\
			\r4.\w Jockey [%d]^n^n\
			\r5.\w Tank^n\
			\r6.\w Witch^n^n\
			\r7.\w Zombies reviven: %s^n\
			\r8.\w Ataque inminente\
			^n^n\r0.\w Salir", iCant, g_count_zombies_specials[ZOMBIE_BOOMER], g_count_zombies_specials[ZOMBIE_SMOKER],
			g_count_zombies_specials[ZOMBIE_HUNTER], g_count_zombies_specials[ZOMBIE_JOCKEY], g_allowed_respawn ? "Habilitado" : "Deshabilitado");
			
			set_pdata_int(id, OFFSET_CSMENUCODE, 0);
			show_menu(id, KEYS_MENU, sMenu, -1, "Admin Menu");
		}
		case MENU_CHOOSE_PLAYER_ZS:
		{
			if(g_zp_id[id] != 1)
				return;
			
			static iMenu;
			static sMenu[128];
			static iBuffer[2];
			static i;
			
			switch(g_admin_choose_zs)
			{
				case ZOMBIE_BOOMER: formatex(sMenu, charsmax(sMenu), "\yBOOMER\R");
				case ZOMBIE_SMOKER: formatex(sMenu, charsmax(sMenu), "\ySMOKER\R");
				case ZOMBIE_HUNTER: formatex(sMenu, charsmax(sMenu), "\yHUNTER\R");
				case ZOMBIE_JOCKEY: formatex(sMenu, charsmax(sMenu), "\yJOCKEY\R");
				case ZOMBIE_TANK: formatex(sMenu, charsmax(sMenu), "\yTANK\R");
				case ZOMBIE_WITCH: formatex(sMenu, charsmax(sMenu), "\yWITCH\R");
			}
			
			iMenu = menu_create(sMenu, "menu_ChoosePlayerZS");
			
			new iTeam;
			for(i = 1; i <= g_maxplayers; ++i)
			{
				if(!is_user_connected(i))
					continue;
					
				iTeam = fn_GetTeam(i);
				
				if(g_allowed_human[i] || iTeam == FM_CS_TEAM_UNASSIGNED || iTeam == FM_CS_TEAM_SPECTATOR)
					continue;
				
				formatex(sMenu, charsmax(sMenu), "%s \r[\y%d\r][ZE: \y%d\r]", g_playername[i], g_count_zs[i][g_admin_choose_zs], g_count_zs_total[i]);
				
				iBuffer[0] = i;
				iBuffer[1] = 0;
				
				menu_additem(iMenu, sMenu, iBuffer);
			}
			
			menu_setprop(iMenu, MPROP_BACKNAME, "Atras");
			menu_setprop(iMenu, MPROP_NEXTNAME, "Siguiente");
			menu_setprop(iMenu, MPROP_EXITNAME, "Volver");
			
			g_admin_choose_zs_page = min(g_admin_choose_zs_page, menu_pages(iMenu) - 1);
			
			if(pev_valid(id) == PDATA_SAFE)
				set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
			
			menu_display(id, iMenu, g_admin_choose_zs_page);
		}
		case MENU_CHOOSE_WEAPONS:
		{
			static sMenu[500];
			static iLen;
			static iWeapon;
			static iPos;
			
			iLen = 0;
			iPos = 1;
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yARMAS SECUNDARIAS^n^n");
			
			for(iWeapon = 1; iWeapon < sizeof(WEAPON_SEC_NAMES); ++iWeapon)
			{
				if(!WEAPON_SEC_NAMES[iWeapon][0])
					continue;
				
				iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\w %s^n", iPos, WEAPON_SEC_NAMES[iWeapon]);
				
				++iPos;
			}
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n^n\r0.\w Salir");
			
			if(pev_valid(id) == PDATA_SAFE)
				set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
			
			show_menu(id, KEYS_MENU, sMenu, -1, "Buy Sec Weapons");
		}
	}
}

public fn_SaveTask(taskid)
{
	fn_Save(ID_SAVE);
}

public fn_ResetInfo(const id)
{
	if(!is_user_connected(id))
		return;
	
	client_cmd(id, "setinfo bottomcolor ^"^"");
	client_cmd(id, "setinfo cl_lc ^"^"");
	client_cmd(id, "setinfo model ^"^"");
	client_cmd(id, "setinfo topcolor ^"^"");
	client_cmd(id, "setinfo _9387 ^"^"");
	client_cmd(id, "setinfo _iv ^"^"");
	client_cmd(id, "setinfo _ah ^"^"");
	client_cmd(id, "setinfo _puqz ^"^"");
	client_cmd(id, "setinfo _ndmh ^"^"");
	client_cmd(id, "setinfo _ndmf ^"^"");
	client_cmd(id, "setinfo _ndms ^"^"");
	client_cmd(id, "setinfo zpt ^"^"");
}

public fn_Save(id)
{
	if(!is_user_connected(id))
		return;
	
	if(!g_torneo_partido)
		return;
	
	new Handle:iSqlQuery;
	
	if(g_insert_stats[id])
	{
		g_insert_stats[id] = 0;
		
		iSqlQuery = SQL_PrepareQuery(g_sql_connection, "INSERT INTO torneo_users (zp_id, partido, objh1, objh2, objh3, objh4, objz1, objz2, objz3, objz4, objz5, objz6, objz7, objc1) VALUES ('%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d')",
		g_zp_id[id], g_torneo_partido, g_kill_zombies[id], g_damage_zombies[id], g_damage_tank[id], g_kill_pipe[id], g_kill_humans[id], g_damage_humans[id], g_boomer_vomit_humans[id], g_smoker_humans[id], g_damage_hunter_humans[id], g_damage_tank_humans[id], g_damage_witch_humans[id],
		g_boomer_vomit_zombies[id]);
		
		g_kill_zombies[id] = g_damage_zombies[id] = g_damage_tank[id] = g_kill_pipe[id] = g_kill_humans[id] = g_damage_humans[id] = g_boomer_vomit_humans[id] = g_smoker_humans[id] = g_damage_hunter_humans[id] = g_damage_tank_humans[id] = g_damage_witch_humans[id] = 0;
		g_boomer_vomit_zombies[id] = 0;
		
		if(!SQL_Execute(iSqlQuery))
			fn_ExecuteQuery(id, iSqlQuery, "09");
	}
	else
	{
		iSqlQuery = SQL_PrepareQuery(g_sql_connection, "UPDATE torneo_users SET objh1=objh1+'%d', objh2=objh2+'%d', objh3=objh3+'%d', objh4=objh4+'%d', objz1=objz1+'%d', objz2=objz2+'%d', objz3=objz3+'%d', objz4=objz4+'%d', objz5=objz5+'%d', objz6=objz6+'%d', objz7=objz7+'%d',\
		objc1=objc1+'%d' WHERE zp_id='%d' AND partido='%d'", g_kill_zombies[id], g_damage_zombies[id], g_damage_tank[id], g_kill_pipe[id], g_kill_humans[id], g_damage_humans[id], g_boomer_vomit_humans[id], g_smoker_humans[id],
		g_damage_hunter_humans[id], g_damage_tank_humans[id], g_damage_witch_humans[id], g_boomer_vomit_zombies[id], g_zp_id[id], g_torneo_partido);
		
		g_kill_zombies[id] = g_damage_zombies[id] = g_damage_tank[id] = g_kill_pipe[id] = g_kill_humans[id] = g_damage_humans[id] = g_boomer_vomit_humans[id] = g_smoker_humans[id] = g_damage_hunter_humans[id] = g_damage_tank_humans[id] = g_damage_witch_humans[id] = 0;
		g_boomer_vomit_zombies[id] = 0;
		
		if(!SQL_Execute(iSqlQuery))
			fn_ExecuteQuery(id, iSqlQuery, "10");
	}
	
	SQL_FreeHandle(iSqlQuery);
}

public fn_SaveTeam(id)
{
	new Handle:iSqlQuery;
	
	iSqlQuery = SQL_PrepareQuery(g_sql_connection, "UPDATE torneo_equipos SET obj1='%d', obj2='%d', obj3='%d', obj4='%d', obj5='%d', obj6='%d', obj7='%d', obj8='%d', obj9='%d', obj10='%d', obj11='%d', obj12='%d', obj13='%d', obj14='%d',\
	obj15='%d', obj16='%d', obj17='%d', obj18='%d' WHERE partido = '%d'", (g_in_refuge) ? 1 : 0, (get_timeleft() - 480), g_in_refuge, g_zombies_kill, g_zombies_specials_kill, g_zombies_specials_kill2[ZOMBIE_BOOMER], g_zombies_specials_kill2[ZOMBIE_SMOKER],
	g_zombies_specials_kill2[ZOMBIE_HUNTER], g_zombies_specials_kill2[ZOMBIE_TANK], g_zombies_specials_kill2[ZOMBIE_WITCH], g_damage_knife, g_kill_knife, g_bullets, g_damage, g_zombies_kill_secondary, g_zombies_kill_secondary_head, g_kill_pipe_group,
	g_kill_zombies_head, g_torneo_partido_fix);
	
	if(!SQL_Execute(iSqlQuery))
		fn_ExecuteQuery(id, iSqlQuery, "07");
	
	SQL_FreeHandle(iSqlQuery);
	
	fn_CC(0, "!g[TORNEO L4D]!y Estadisticas del equipo guardadas correctamente");
}

public fn_SaveAll()
{
	new i;
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		fn_Save(i);
	}
	
	g_torneo_partido = 0;
}

public fn_SetModel(taskid)
	set_user_model(ID_MODEL, g_playermodel[ID_MODEL]);

public fn_ModelUpdate(taskid)
{
	static Float:fGameTime;
	
	fGameTime = get_gametime();
	
	if(fGameTime - g_models_targettime >= MODELS_DELAY)
	{
		fn_SetModel(taskid);
		g_models_targettime = fGameTime;
	}
	else
	{
		set_task((g_models_targettime + MODELS_DELAY) - fGameTime, "fn_SetModel", taskid);
		g_models_targettime = g_models_targettime + MODELS_DELAY;
	}
}

public fn_HideHUDs_ClearWeapons(taskid)
{
	if(!is_user_alive(ID_SPAWN))
		return;
	
	message_begin(MSG_ONE, g_message_hideweapon, _, ID_SPAWN);
	write_byte(HIDE_HUDS);
	message_end();
	
	message_begin(MSG_ONE, g_message_crosshair, _, ID_SPAWN);
	write_byte(0);
	message_end();
	
	strip_user_weapons(ID_SPAWN);
	give_item(ID_SPAWN, "weapon_knife");
}

public fn_SetSpeed(id)
{
	if(!is_user_connected(id))
		return;
	
	static Float:fSpeed;
	
	if(g_zombie[id])
	{
		if(g_boomer[id]) fSpeed = 200.0;
		else if(g_smoker[id]) fSpeed = 215.0;
		else if(g_hunter[id] || g_tank[id]) fSpeed = 255.0;
		else if(g_witch[id]) fSpeed = g_witch_angry[id] ? 400.0 : 50.0;
		else fSpeed = 240.0; // Zombie y Jockey
	}
	else fSpeed = !g_adrenalina[id] ? 240.0 : 350.0; // Humano
	
	if(g_nomove[id])
		fSpeed = 1.0;
	
	set_user_maxspeed(id, fSpeed);
}

public fn_TurnLightOff(id)
{
	entity_set_int(id, EV_INT_effects, entity_get_int(id, EV_INT_effects) & ~EF_DIMLIGHT);
	
	message_begin(MSG_ONE_UNRELIABLE, g_message_flashlight, _, id);
	write_byte(0);
	write_byte(100);
	message_end();
	
	entity_set_int(id, EV_INT_impulse, 0);
}

public fn_SetTeamMessage(taskid)
{
	g_switchingteam = 1;
	
	emessage_begin(MSG_ALL, g_message_teaminfo);
	ewrite_byte(ID_TEAM);
	ewrite_string(CS_TEAM_NAMES[fn_GetTeam(ID_TEAM)]);
	emessage_end();
	
	g_switchingteam = 0;
}

public fn_ReplaceWeaponModels(id, weaponid)
{
	switch(weaponid)
	{
		case CSW_KNIFE:
		{
			if(g_zombie[id])
			{
				static sClawModel[100];
				
				if(g_boomer[id]) formatex(sClawModel, charsmax(sClawModel), "models/zombie_plague/%s.mdl", g_models_knife_sz[0]);
				else if(g_smoker[id]) formatex(sClawModel, charsmax(sClawModel), "models/zombie_plague/%s.mdl", g_models_knife_sz[1]);
				else if(g_hunter[id]) formatex(sClawModel, charsmax(sClawModel), "models/zombie_plague/%s.mdl", g_models_knife_sz[2]);
				else if(g_tank[id]) formatex(sClawModel, charsmax(sClawModel), "models/zombie_plague/%s.mdl", g_models_knife_sz[4]);
				else if(g_witch[id]) formatex(sClawModel, charsmax(sClawModel), "models/zombie_plague/%s.mdl", g_models_knife_sz[5]);
				else formatex(sClawModel, charsmax(sClawModel), "models/zombie_plague/%s.mdl", g_models_knife_zombies[g_zombie_model[id]]);
				
				entity_set_string(id, EV_SZ_viewmodel, sClawModel);
				entity_set_string(id, EV_SZ_weaponmodel, "");
			}
			else
			{
				entity_set_string(id, EV_SZ_viewmodel, "models/v_knife.mdl");
				entity_set_string(id, EV_SZ_weaponmodel, "models/p_knife.mdl");
			}
		}
		case CSW_HEGRENADE: entity_set_string(id, EV_SZ_viewmodel, g_model_vgrenade_pipe);
		case CSW_FLASHBANG: entity_set_string(id, EV_SZ_viewmodel, g_model_vadrenalina);
		case CSW_SMOKEGRENADE: entity_set_string(id, EV_SZ_viewmodel, g_model_vpildoras);
	}
}

public fn_SetSpecialZombie(id, zombie)
{
	switch(zombie)
	{
		case ZOMBIE_BOOMER: g_boomer[id] = 1;
		case ZOMBIE_SMOKER: g_smoker[id] = 1;
		case ZOMBIE_HUNTER: g_hunter[id] = 1;
		case ZOMBIE_JOCKEY: g_hunter[id] = 1;
		case ZOMBIE_TANK: g_tank[id] = 1;
		case ZOMBIE_WITCH: g_witch[id] = 1;
	}
	
	static iHealth;
	static Float:fGravity;
	static iArmor;
	static sModel[32];
	
	fGravity = 1.0;
	iArmor = 0;
	
	g_zs_need[id] = 0;
	
	if(g_boomer[id])
	{
		iHealth = 50;
		
		formatex(sModel, charsmax(sModel), "%s", g_models_special_zombies[0]);
		
		set_dhudmessage(0, 255, 0, -1.0, 0.3, 0, 0.0, 4.9, 1.0, 1.0);
		show_dhudmessage(id, "Eres un Boomer");
		
		fn_CC(id, MESSAGE_AA);
		
		++g_count_zombies_specials[ZOMBIE_BOOMER];
		++g_count_zs[id][ZOMBIE_BOOMER];
	}
	else if(g_smoker[id])
	{
		iHealth = 300;
		iArmor = 5;
		
		formatex(sModel, charsmax(sModel), "%s", g_models_special_zombies[1]);
		
		set_dhudmessage(255, 255, 255, -1.0, 0.3, 0, 0.0, 4.9, 1.0, 1.0);
		show_dhudmessage(id, "Eres un Smoker");
		
		fn_CC(id, MESSAGE_AB);
		
		++g_count_zombies_specials[ZOMBIE_SMOKER];
		++g_count_zs[id][ZOMBIE_SMOKER];
	}
	else if(g_hunter[id])
	{
		iHealth = 300;
		fGravity = 0.75;
		iArmor = 10;
		
		formatex(sModel, charsmax(sModel), "%s", g_models_special_zombies[2]);
		
		set_dhudmessage(255, 0, 0, -1.0, 0.3, 0, 0.0, 4.9, 1.0, 1.0);
		show_dhudmessage(id, "Eres un Hunter");
		
		fn_CC(id, MESSAGE_AC);
		fn_CC(id, MESSAGE_AG);
		
		++g_count_zombies_specials[ZOMBIE_HUNTER];
		++g_count_zs[id][ZOMBIE_HUNTER];
	}
	else if(g_tank[id])
	{
		iHealth = 10000;
		iArmor = 200;
		
		formatex(sModel, charsmax(sModel), "%s", g_models_special_zombies[4]);
		
		set_dhudmessage(255, 0, 0, -1.0, 0.3, 0, 0.0, 4.9, 1.0, 1.0);
		show_dhudmessage(0, "%s es un Tank", g_playername[id]);
		
		fn_CC(id, MESSAGE_BG);
		
		++g_count_zombies_specials[ZOMBIE_TANK];
		++g_count_zs[id][ZOMBIE_TANK];
		
		fn_EmitSound(id, g_tank_sound, 0.0, 0); // ggg
		
		remove_task(TASK_REPEAT_SOUND);
		set_task(51.5, "fn_RepeatTankSound", TASK_REPEAT_SOUND);
	}
	else if(g_witch[id])
	{
		iHealth = 1000;
		fGravity = 0.75;
		iArmor = 0;
		
		formatex(sModel, charsmax(sModel), "%s", g_models_special_zombies[5]);
		
		set_dhudmessage(255, 0, 0, -1.0, 0.3, 0, 0.0, 4.9, 1.0, 1.0);
		show_dhudmessage(id, "Eres una Witch");
		
		fn_CC(id, MESSAGE_BH);
		
		++g_count_zombies_specials[ZOMBIE_WITCH];
		++g_count_zs[id][ZOMBIE_WITCH];
		
		remove_task(id + TASK_AURA);
		set_task(0.1, "fn_EffectAura", id + TASK_AURA, _, _, "b");
	}
	
	++g_count_zs_total[id];
	
	set_user_health(id, iHealth);
	set_user_gravity(id, fGravity);
	set_user_armor(id, iArmor);
	
	copy(g_playermodel[id], 31, sModel);
}

public fn_CreateSprite(iArgs[])
{
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_SPRAY);
	write_coord(iArgs[0]);
	write_coord(iArgs[1]);
	write_coord(iArgs[2]);
	write_coord(iArgs[3]);
	write_coord(iArgs[4]);
	write_coord(iArgs[5]);
	write_short(g_boomer_vomit_spr);
	write_byte(8);
	write_byte(70);
	write_byte(100);
	write_byte(5);
	message_end();
}

public fn_VictimRemoveGlow(id)
{
	if(!is_user_connected(id))
		return;
	
	set_user_rendering(id);
}

public fn_SmokerReelin(iArgs[])
{
	new iSmoker = iArgs[0];
	new iVictim = iArgs[1];
	
	if(!g_smoker_tongued[iSmoker] || !is_user_alive(iVictim))
	{
		fn_TongEnd(iSmoker);
		return;
	}
	
	new Float:vecVelocity[3];
	new iSmokerOrigin[3];
	new iVictimOrigin[3];
	
	get_user_origin(iSmoker, iSmokerOrigin);
	get_user_origin(iVictim, iVictimOrigin);
	
	ExecuteHam(Ham_TakeDamage, iVictim, iSmoker, iSmoker, 1.0, DMG_CRUSH);
	
	new iDistance = get_distance(iSmokerOrigin, iVictimOrigin);
	
	if(iDistance > 5)
	{
		new Float:fTime = iDistance / 850.0;
		
		vecVelocity[0] = (iSmokerOrigin[0] - iVictimOrigin[0]) / fTime;
		vecVelocity[1] = (iSmokerOrigin[1] - iVictimOrigin[1]) / fTime;
		vecVelocity[2] = (iSmokerOrigin[2] - iVictimOrigin[2]) / fTime;
	}
	else
	{
		vecVelocity[0] = 0.0;
		vecVelocity[1] = 0.0;
		vecVelocity[2] = 0.0;
	}

	entity_set_vector(iVictim, EV_VEC_velocity, vecVelocity);
}

public fn_TongEnd(id)
{
	g_smoker_tongued[id] = 0;
	
	fn_SmokerBeamRemove(id);
	
	g_nomove[id] = 0;
	
	ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
}

public fn_DragTarget(iArgs[])
{
	new iSmoker = iArgs[0];
	new iTarget = iArgs[1];
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_BEAMENTS);
	write_short(iSmoker);
	write_short(iTarget);
	write_short(g_smoker_tongue_spr);
	write_byte(0);
	write_byte(0);
	write_byte(200);
	write_byte(8);
	write_byte(1);
	write_byte(155);
	write_byte(155);
	write_byte(55);
	write_byte(90);
	write_byte(10);
	message_end();
}

public fn_NoTarget(id)
{
	new iEndOrigin[3];
	get_user_origin(id, iEndOrigin, 3);

	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_BEAMENTPOINT);
	write_short(id);
	write_coord(iEndOrigin[0]);
	write_coord(iEndOrigin[1]);
	write_coord(iEndOrigin[2]);
	write_short(g_smoker_tongue_spr);
	write_byte(0);
	write_byte(0);
	write_byte(6);
	write_byte(8);
	write_byte(1);
	write_byte(155);
	write_byte(155);
	write_byte(55);
	write_byte(75);
	write_byte(0);
	message_end();
}

public fn_SmokerBeamRemove(id)
{
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_KILLBEAM);
	write_short(id);
	message_end();
}

public fn_SmokySmoker(id)
{
	if(!is_user_alive(id))
		return PLUGIN_HANDLED;
	
	if(g_smoker[id])
	{
		new i;
		for(i = 1; i <= get_maxplayers(); ++i)
		{
			if(!is_user_alive(i))
				continue;
			
			if(get_entity_distance(id, i) > 150)
				continue;
			
			message_begin(MSG_ONE_UNRELIABLE, g_message_screenfade, _, i);
			write_short(5);
			write_short(5);
			write_short(0x0004);
			write_byte(255);
			write_byte(255);
			write_byte(255);
			write_byte(135);
			message_end();
			
			new Float:vecOrigin[3];
			new iScale = random_num(40, 30);
			
			entity_get_vector(i, EV_VEC_origin, vecOrigin);
			
			fn_CreateSpriteL4D(vecOrigin, g_smoker_dead_spr, 150, iScale);
			
			iScale = random_num(180, 150);
			fn_CreateSpriteL4D(vecOrigin, g_smoker_dead_spr, 150, iScale);
			
			set_task(5.0, "fn_SmokySmokeRemove", i + TASK_SMOKER);
		}
	}
	
	return PLUGIN_HANDLED;
}

public fn_SmokySmokeRemove(taskid)
{
	message_begin(MSG_ONE_UNRELIABLE, g_message_screenfade, _, ID_SMOKER);
	write_short(1<<12);
	write_short(0);
	write_short(0x0004);
	write_byte(0);
	write_byte(0);
	write_byte(0);
	write_byte(1);
	message_end();
	
	new Float:vecOrigin[3];
	new iScale = random_num(40, 30);
	
	entity_get_vector(ID_SMOKER, EV_VEC_origin, vecOrigin);
	
	fn_CreateSpriteL4D(vecOrigin, g_smoker_dead_spr, 130, iScale);
}

public fn_MoveOn(id)
{
	if(!is_user_connected(id))
		return;
	
	if(!g_nomove[id])
		return;
	
	g_nomove[id] = 0;
	
	ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
}

public fn_VictimBadAim(id)
{
	if(!is_user_connected(id))
		return;
	
	new const Float:vecAim[3] = {-100.0, -100.0, -100.0};
	entity_set_vector(id, EV_VEC_punchangle, vecAim);
}

public fn_RespawnPlayer(taskid)
{
	if(is_user_alive(ID_SPAWN))
		return;
	
	if(!g_allowed_respawn)
		return;
	
	new idTeam = fn_GetTeam(ID_SPAWN);
	
	if(idTeam == FM_CS_TEAM_UNASSIGNED || idTeam == FM_CS_TEAM_SPECTATOR)
		return;
	
	ExecuteHamB(Ham_CS_RoundRespawn, ID_SPAWN);
	
	static iHull;
	iHull = (get_entity_flags(ID_SPAWN) & FL_DUCKING) ? HULL_HEAD : HULL_HUMAN;
	
	new i;
	for(i = 1; i <= 20; ++i)
	{
		if(g_origin_horde_count[1] + (i - 1) >= 128)
			break;
		
		if(g_origin_horde[g_origin_horde_count[1] + (i - 1)][0])
		{
			if(is_hull_vacant(g_origin_horde[g_origin_horde_count[1] + (i - 1)], iHull))
			{
				entity_set_vector(ID_SPAWN, EV_VEC_velocity, Float:{0.0, 0.0, 0.0});
				entity_set_vector(ID_SPAWN, EV_VEC_origin, g_origin_horde[g_origin_horde_count[1] + (i - 1)]);
				
				g_origin_horde[g_origin_horde_count[1] + (i - 1)] = Float:{0.0, 0.0, 0.0};
				
				++g_origin_horde_count[1];
				
				break;
			}
		}
	}
}

public fn_EffectAura(taskid)
{
	if(!g_witch[ID_AURA])
	{
		remove_task(taskid);
		return;
	}
	
	static vecOrigin[3];
	get_user_origin(ID_AURA, vecOrigin);
	
	message_begin(MSG_PVS, SVC_TEMPENTITY, vecOrigin);
	write_byte(TE_DLIGHT);
	write_coord(vecOrigin[0]);
	write_coord(vecOrigin[1]);
	write_coord(vecOrigin[2]);
	write_byte(10);
	if(g_witch_angry[ID_AURA])
	{
		write_byte(255);
		write_byte(0);
		write_byte(0);
	}
	else
	{
		write_byte(255);
		write_byte(255);
		write_byte(255);
	}
	write_byte(2);
	write_byte(0);
	message_end();
}

public fn_PlayIdleSoundBOOMER(taskid) emit_sound(ID_SOUND, CHAN_VOICE, g_boomer_idle[random_num(0, charsmax(g_boomer_idle))], 1.0, ATTN_NORM, 0, PITCH_NORM);
public fn_PlayIdleSoundSMOKER(taskid) emit_sound(ID_SOUND, CHAN_VOICE, g_smoker_idle[random_num(0, charsmax(g_smoker_idle))], 1.0, ATTN_NORM, 0, PITCH_NORM);
public fn_PlayIdleSoundHUNTER(taskid) emit_sound(ID_SOUND, CHAN_VOICE, g_hunter_idle[random_num(0, charsmax(g_hunter_idle))], 1.0, ATTN_NORM, 0, PITCH_NORM);
public fn_PlayIdleSoundWITCH(taskid) emit_sound(ID_SOUND, CHAN_VOICE, g_witch_idle[random_num(0, charsmax(g_witch_idle))], 1.0, ATTN_NORM, 0, PITCH_NORM);

public fn_EffectPipeSound(ent)
{
	if(!is_valid_ent(ent))
	{
		remove_task(ent);
		return;
	}
	
	emit_sound(ent, CHAN_WEAPON, g_sound_pipebeep, VOL_NORM, ATTN_NORM, 0, PITCH_HIGH);
}

public fn_EffectAdrenalin(taskid)
{
	if(!g_adrenalina[ID_ADRENALINA])
	{
		remove_task(taskid);
		return;
	}
	
	static vecOrigin[3];
	get_user_origin(ID_ADRENALINA, vecOrigin);
	
	message_begin(MSG_PVS, SVC_TEMPENTITY, vecOrigin);
	write_byte(TE_DLIGHT);
	write_coord(vecOrigin[0]);
	write_coord(vecOrigin[1]);
	write_coord(vecOrigin[2]);
	write_byte(50);
	write_byte(0);
	write_byte(0);
	write_byte(200);
	write_byte(2);
	write_byte(0);
	message_end();
	
	message_begin(MSG_PVS, SVC_TEMPENTITY, vecOrigin);
	write_byte(TE_IMPLOSION);
	write_coord(vecOrigin[0]);
	write_coord(vecOrigin[1]);
	write_coord(vecOrigin[2]);
	write_byte(128);
	write_byte(20);
	write_byte(3);
	message_end();
}

public fn_FinishAdrenalin(taskid)
{
	if(!g_adrenalina[ID_ADRENALINA])
	{
		remove_task(taskid);
		return;
	}
	
	g_adrenalina[ID_ADRENALINA] = 0;
	
	ExecuteHamB(Ham_Player_ResetMaxSpeed, ID_ADRENALINA);
	
	remove_task(taskid);
}

public fn_EmitSound(id, const sound[], Float:radius, info) // ggg
{
	new i;
	
	if(radius)
	{
		new Float:vecOriginId[3];
		new Float:vecOriginI[3];
		
		entity_get_vector(id, EV_VEC_origin, vecOriginId);
		
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_user_connected(i))
				continue;
			
			entity_get_vector(i, EV_VEC_origin, vecOriginI);
			
			if(get_distance_f(vecOriginId, vecOriginI) <= radius)
				client_cmd(i, "spk ^"%s^"", sound);
		}
		
		if(info)
		{
			for(i = 1; i <= g_maxplayers; ++i)
			{
				if(!is_user_connected(i))
					continue;
				
				if(!g_allowed_human[i])
					continue;
				
				fn_CC(i, MESSAGE_BI);
			}
		}
	}
	else
	{
		client_cmd(0, "MP3Volume 0.35");
		client_cmd(0, "mp3 play ^"%s^"", sound);
	}
}

public fn_RepeatTankSound()
{
	new i;
	new iTank = 0;
	
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_alive(i))
			continue;
		
		if(!g_tank[i])
			continue;
		
		iTank = 1;
	}
	
	if(iTank)
	{
		fn_EmitSound(0, g_tank_sound, 0.0, 0); // ggg
		set_task(51.5, "fn_RepeatTankSound", TASK_REPEAT_SOUND);
	}
}

public fn_RepeatWitchSound()
{
	new i;
	new iWitch = 0;
	
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_alive(i))
			continue;
		
		if(!g_witch[i])
			continue;
		
		iWitch = 1;
	}
	
	if(iWitch)
	{
		fn_EmitSound(0, g_witch_sound_angry, 0.0, 0); // ggg
		set_task(30.5, "fn_RepeatWitchSound", TASK_REPEAT_SOUND);
	}
}

public fn_BlockSecWeapons()
{
	new i;
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_alive(i))
			continue;
		
		if(g_zombie[i])
			continue;
		
		g_human_weaps[i] = 1;
	}
	
	fn_CC(0, MESSAGE_BL);
}

public fn_LoadBlockZones()
{
	new entity = create_entity("info_target");
	
	entity_set_model(entity, "models/gib_skull.mdl");
	set_pev(entity, pev_classname, "block_zombie");
	
	new Float:mins[3] = { -62.0, -47.0, -32.0 };
	new Float:maxs[3] = { 62.0, 47.0, 32.0 };
	
	entity_set_origin(entity, Float:{-596.1, -520.3, -273.1});
	
	set_pev(entity, pev_movetype, MOVETYPE_FLY);
	
	set_pev(entity, pev_solid, SOLID_TRIGGER);
	
	entity_set_size(entity, mins, maxs);
	
	set_entity_visibility(entity, 0);
}

/* ========================================
======== OTHERS ===========================
======================================== */
public touch_RockEnt(ent, toucher)
{
	if(!is_valid_ent(ent))
		return;
	
	if((toucher > 0) && is_valid_ent(toucher))
	{
		static sClassName[32];
		entity_get_string(toucher, EV_SZ_classname, sClassName, charsmax(sClassName));
		
		if(equal(sClassName, "player") && is_user_alive(toucher))
		{
			if(!g_zombie[toucher])
			{
				new iTank = entity_get_edict(ent, EV_ENT_owner);
				new iHealth = get_user_health(toucher);
				
				if(iHealth <= 140)
					ExecuteHamB(Ham_Killed, toucher, iTank, 0);
				else
					set_user_health(toucher, (iHealth - 140));
			}
			
			new const Float:vecAim[3] = {100.0, 100.0, 100.0};
			entity_set_vector(toucher, EV_VEC_punchangle, vecAim);
			
			set_task(1.50, "fn_VictimBadAim", toucher);
		}
		
		if(equal(sClassName, "func_breakable") && entity_get_int(toucher, EV_INT_solid) != SOLID_NOT)
			force_use(ent, toucher);
	}
	
	static Float:vecOrigin[3];
	entity_get_vector(ent, EV_VEC_origin, vecOrigin);
	
	engfunc(EngFunc_MessageBegin, MSG_BROADCAST, SVC_TEMPENTITY, vecOrigin, 0);
	write_byte(TE_BREAKMODEL); 
	engfunc(EngFunc_WriteCoord, vecOrigin[0]);  
	engfunc(EngFunc_WriteCoord, vecOrigin[1]);
	engfunc(EngFunc_WriteCoord, vecOrigin[2] + 24); 
	write_coord(16); 
	write_coord(16); 
	write_coord(16); 
	write_coord(random_num(-50, 50)); 
	write_coord(random_num(-50, 50)); 
	write_coord(25);
	write_byte(10); 
	write_short(g_tank_rockgibs); 
	write_byte(10); 
	write_byte(25);
	write_byte(0x08); 
	message_end();
	
	remove_entity(ent);
}