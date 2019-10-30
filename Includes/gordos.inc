Float:clampfloat(const Float:value, const Float:min, const Float:max)
{
	if(value < min)
		return min;
	else if(value > max)
		return max;
	
	return value;
}

public concmd_RemoveWeapons(const id)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
		
	if(!g_kiske[id])
		return PLUGIN_HANDLED;
	
	new i;
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!g_isalive[i])
			continue;
		
		strip_user_weapons(i);
	}
	
	g_no_buy = !g_no_buy;
	colorChat(id, _, "%sARMAS %sBLOQUEADAS", ZP_PREFIX, (g_no_buy) ? "" : "DES");
	
	return PLUGIN_HANDLED;
}

public concmd_BlockClip(const id)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
		
	if(!g_kiske[id])
		return PLUGIN_HANDLED;
	
	g_no_semiclip = !g_no_semiclip;
	colorChat(id, _, "%sSEMICLIP %sBLOQUEADO", ZP_PREFIX, (g_no_semiclip) ? "" : "DES");
	
	return PLUGIN_HANDLED;
}

public concmd_SetGlow(const id)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
		
	if(!g_kiske[id])
		return PLUGIN_HANDLED;
	
	new sArg1[128];
	read_argv(1, sArg1, charsmax(sArg1));
	
	new iTarget;
	new iBody;
	
	get_user_aiming(id, iTarget, iBody);
	
	if(is_user_valid_alive(iTarget))
	{
		new rgb[3];
		
		if(equal(sArg1, "azul"))
		{
			rgb = {0, 0, 255}
			g_glow_color[iTarget] = 3
		}
		else if(equal(sArg1, "rojo"))
		{
			rgb = {255, 0, 0}
			g_glow_color[iTarget] = 1
		}
		else if(equal(sArg1, "verde"))
		{
			rgb = {0, 255, 0}
			g_glow_color[iTarget] = 2
		}
		else
		{
			rgb = {255, 255, 255}
			formatex(sArg1, 127, "blanco")
			g_glow_color[iTarget] = 4
		}
	
		set_user_rendering(iTarget, kRenderFxGlowShell, rgb[0], rgb[1], rgb[2], kRenderNormal, 25);
		
		colorChat(iTarget, _, "%sTe han puesto el color !g%s!y", ZP_PREFIX, sArg1)
		colorChat(iTarget, _, "%sTe han puesto el color !g%s!y", ZP_PREFIX, sArg1)
		colorChat(iTarget, _, "%sTe han puesto el color !g%s!y", ZP_PREFIX, sArg1)
	}
	
	return PLUGIN_HANDLED;
}

public concmd_RemoveGlow(const id)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
		
	if(!g_kiske[id])
		return PLUGIN_HANDLED;
	
	new iTarget;
	new iBody;
	
	get_user_aiming(id, iTarget, iBody);
	
	if(is_user_valid_alive(iTarget))
	{
		g_glow_color[iTarget] = 0;
		
		set_user_rendering(iTarget);
		
		colorChat(iTarget, _, "%sTe han sacado el color que tenías", ZP_PREFIX)
		colorChat(iTarget, _, "%sTe han sacado el color que tenías", ZP_PREFIX)
		colorChat(iTarget, _, "%sTe han sacado el color que tenías", ZP_PREFIX)
	}
	
	return PLUGIN_HANDLED;
}

public concmd_Bomb(const id)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
		
	if(!g_kiske[id])
		return PLUGIN_HANDLED;
	
	new sArg1[128];
	read_argv(1, sArg1, charsmax(sArg1));
	
	g_gk_bomb = !g_gk_bomb;
	
	if(g_gk_bomb)
	{
		colorChat(0, _, "%sJUEGO DE LA BOMBA ACTIVADO", ZP_PREFIX);
		
		new i;
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!g_kiske[i])
				continue;
			
			give_item(i, "weapon_flashbang");
			cs_set_user_bpammo(i, CSW_FLASHBANG, 100);
			
			break;
		}
		
		g_gk_bomb_level = 1;
		g_gk_bomb_drop = 1;
		
		colorChat(0, _, "%sLa próxima bomba otorgará !g1 nivel!y a quienes permanezcan vivos!", ZP_PREFIX);
	}
	
	return PLUGIN_HANDLED;
}

public concmd_Kill(const id)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
		
	if(!g_kiske[id])
		return PLUGIN_HANDLED;
	
	new iTarget;
	new iBody;
	
	get_user_aiming(id, iTarget, iBody);
	
	if(is_user_valid_alive(iTarget))
		ExecuteHamB(Ham_Killed, iTarget, id, 1);
	
	return PLUGIN_HANDLED;
}

public concmd_NoMove(const id)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
		
	if(!g_kiske[id])
		return PLUGIN_HANDLED;
	
	g_no_move = !g_no_move;
	
	if(g_no_move)
		colorChat(0, _, "%sTodos los usuarios quedaron inmovilizados!", ZP_PREFIX);
	else
		colorChat(0, _, "%sTodos los usuarios ya pueden moverse!", ZP_PREFIX);
		
	new i;
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!g_isalive[i])
			continue;
		
		if(i == id)
			continue;
		
		ExecuteHamB(Ham_Player_ResetMaxSpeed, i);
	}
	
	return PLUGIN_HANDLED;
}

public concmd_Light(const id)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
		
	if(!g_kiske[id])
		return PLUGIN_HANDLED;
		
	new sArg1[5];
	read_argv(1, sArg1, charsmax(sArg1));
	
	copy(g_lights, 1, sArg1)
	set_lights(g_lights[0]);
	
	return PLUGIN_HANDLED;
}

public concmd_Race(const id)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
		
	if(!g_kiske[id])
		return PLUGIN_HANDLED;
	
	g_race_count = 10;
	set_task(1.0, "aaaaaaasdasda")
	
	return PLUGIN_HANDLED;
}

public concmd_Guerra(const id)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
		
	if(!g_kiske[id])
		return PLUGIN_HANDLED;
	
	new sArg1[32], sArg2[32], sArg3[32];
	read_argv(1, sArg1, charsmax(sArg1));
	read_argv(2, sArg2, charsmax(sArg2));
	read_argv(3, sArg3, charsmax(sArg3));
	
	g_gk_guerra = 1;
	
	new iAttackers = 0;
	new iVictims = 0;
	
	switch(sArg1[0])
	{
		case 't': iAttackers = 5;
		case 'r': iAttackers = 1;
		case 'v': iAttackers = 2;
		case 'a': iAttackers = 3;
		case 'b': iAttackers = 4;
	}
	
	switch(sArg2[0])
	{
		case 't': iVictims = 5;
		case 'r': iVictims = 1;
		case 'v': iVictims = 2;
		case 'a': iVictims = 3;
		case 'b': iVictims = 4;
	}
	
	g_gk_glow_color_a = iAttackers
	g_gk_glow_color_v = iVictims
	
	new i;
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!g_isalive[i])
			continue;
		
		if(g_kiske[i])
			continue;
		
		strip_user_weapons(i);
		
		if((iAttackers == g_glow_color[i]) || (iVictims == g_glow_color[i]) || (iAttackers == 5 || iVictims == 5))
		{
			give_item(i, sArg3);
			g_unlimited_clip[i] = 1;
		}
	}
	
	return PLUGIN_HANDLED;
}

public aaaaaaasdasda()
{
	if(!g_race_count)
	{
		g_no_move = 0;
		
		new i;
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_user_alive(i))
				continue;
			
			ExecuteHamB(Ham_Player_ResetMaxSpeed, i);
		}
		
		colorChat(0, _, "!g¡GO!!y")
		return;
	}
	
	colorChat(0, _, "%sEN %d SEGUNDOS COMIENZA LA CARRERA!", ZP_PREFIX, g_race_count)
	
	--g_race_count;
	set_task(1.0, "aaaaaaasdasda")
}

public grab_on(id,level,cid)
{
	if(!g_kiske[id])
		return PLUGIN_HANDLED
	
	if(g_grab_player[id])
		return PLUGIN_HANDLED
	
	g_grab_player[id] = -1
	
	static target, trash
	target=0
	
	get_user_aiming(id,target,trash)
	if(target && is_user_alive(target) && target != id)
	{
		if(g_legendaria_kpuzzle && g_logros[target][LEGENDARIA_KPUZZLE])
		{
			set_task(0.1,"grab_on2",id)
			return PLUGIN_HANDLED
		}
		
		if(target <= g_maxplayers)
		{
			if(is_user_alive(target))
				grabem(id,target)
		}
		else if(entity_get_int(target,EV_INT_solid) !=4)
			grabem(id,target)
	}
	else
		set_task(0.1,"grab_on2",id)
		
	return PLUGIN_HANDLED
}

public grab_on2(id)
{
	if(is_user_connected(id))
	{
		static target, trash
		target=0
		
		get_user_aiming(id,target,trash)
		
		if(target && is_user_alive(target) && target != id)
		{
			if(g_legendaria_kpuzzle && g_logros[target][LEGENDARIA_KPUZZLE])
			{
				set_task(0.1,"grab_on2",id)
				return
			}
		
			if(target <= g_maxplayers)
			{
				if(is_user_alive(target))
					grabem(id,target)
			}
			else if(entity_get_int(target,EV_INT_solid) != 4)
				grabem(id,target)
		}
		else
			set_task(0.1,"grab_on2",id)
	}
}

public grabem(id,target)
{
	g_grab_player[id]=target
	
	if(target <= g_maxplayers)
	{
		g_grab_player_gravity[target] = get_user_gravity(target);
		set_user_gravity(target, 0.0)
	}
	
	grab_totaldis[id] = 0.0
	
	set_task(0.1,"grab_prethink",id+291678,"",0,"b")
	
	grab_prethink(id+291678)
	
	emit_sound(id,CHAN_VOICE,"weapons/xbow_fire1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
}

public grab_off(id)
{
	if(is_user_connected(id))
	{
		if(g_grab_player[id]==-1)
		{
			g_grab_player[id]=0
			ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
		}
		else if(g_grab_player[id])
		{
			if(g_grab_player[id] <= g_maxplayers && is_user_alive(g_grab_player[id]))
				set_user_gravity(g_grab_player[id], g_grab_player_gravity[g_grab_player[id]])
			
			g_grab_player[id]=0
		}
	}
	return PLUGIN_HANDLED
}

public grab_prethink(id)
{
	id -= 291678
	if(!is_user_connected(id) && g_grab_player[id]>0)
	{
		if(g_grab_player[id] <= g_maxplayers && is_user_alive(g_grab_player[id]))
			set_user_gravity(g_grab_player[id], g_grab_player_gravity[g_grab_player[id]])
		
		g_grab_player[id]=0
	}
	
	if(!g_grab_player[id] || g_grab_player[id]==-1)
	{
		remove_task(id+291678)
		return PLUGIN_HANDLED
	}

	static origin1[3]
	get_user_origin(id,origin1)
	static Float:origin2_F[3], origin2[3]
	entity_get_vector(g_grab_player[id],EV_VEC_origin,origin2_F)
	origin2[0] = floatround(origin2_F[0])
	origin2[1] = floatround(origin2_F[1])
	origin2[2] = floatround(origin2_F[2])
	static origin3[3]
	get_user_origin(id,origin3,3)

	//Create red beam
	message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
	write_byte(1)		//TE_BEAMENTPOINT
	write_short(id)		// start entity
	write_coord(origin2[0])
	write_coord(origin2[1])
	write_coord(origin2[2])
	write_short(dotsprite)
	write_byte(1)		// framestart
	write_byte(1)		// framerate
	write_byte(1)		// life in 0.1's
	write_byte(5)		// width
	write_byte(0)		// noise
	write_byte(255)		// red
	write_byte(0)		// green
	write_byte(0)		// blue
	write_byte(200)		// brightness
	write_byte(0)		// speed
	message_end()

	//Convert to floats for calculation
	static Float:origin1_F[3]
	static Float:origin3_F[3]
	origin1_F[0] = float(origin1[0])
	origin1_F[1] = float(origin1[1])
	origin1_F[2] = float(origin1[2])
	origin3_F[0] = float(origin3[0])
	origin3_F[1] = float(origin3[1])
	origin3_F[2] = float(origin3[2])

	//Calculate target's new velocity
	static Float:distance[3]

	if(!grab_totaldis[id])
	{
		distance[0] = floatabs(origin1_F[0] - origin2_F[0])
		distance[1] = floatabs(origin1_F[1] - origin2_F[1])
		distance[2] = floatabs(origin1_F[2] - origin2_F[2])
		
		grab_totaldis[id] = floatsqroot(distance[0]*distance[0] + distance[1]*distance[1] + distance[2]*distance[2])
	}
	
	distance[0] = origin3_F[0] - origin1_F[0]
	distance[1] = origin3_F[1] - origin1_F[1]
	distance[2] = origin3_F[2] - origin1_F[2]

	static Float:grab_totaldis2
	grab_totaldis2 = floatsqroot(distance[0]*distance[0] + distance[1]*distance[1] + distance[2]*distance[2])

	static Float:que
	que = grab_totaldis[id] / grab_totaldis2

	static Float:origin4[3]
	origin4[0] = ( distance[0] * que ) + origin1_F[0]
	origin4[1] = ( distance[1] * que ) + origin1_F[1]
	origin4[2] = ( distance[2] * que ) + origin1_F[2]
	
	/*if(get_user_button(id) & IN_USE)
	{
		new iOrigin[3];
		new iVictimOrigin[3];
		new Float:vecVelocity[3];
		
		get_user_origin(id, iOrigin);
		get_user_origin(g_grab_player[id], iVictimOrigin);
		
		new iDistance = get_distance(iOrigin, iVictimOrigin);
		if(iDistance > 20)
		{
			new Float:fTime = iDistance / 1000.0;
			vecVelocity[0] = (iOrigin[0] - iVictimOrigin[0]) / fTime;
			vecVelocity[1] = (iOrigin[1] - iVictimOrigin[1]) / fTime;
			vecVelocity[2] = (iOrigin[2] - iVictimOrigin[2]) / fTime;
			
			entity_set_vector(g_grab_player[id], EV_VEC_velocity, vecVelocity);
		}
		else
		{
			vecVelocity = Float:{0.0, 0.0, 0.0};
			entity_set_vector(g_grab_player[id], EV_VEC_velocity, vecVelocity);
		}
	}
	else
	{*/
	static Float:velocity[3]
	velocity[0] = (origin4[0] - origin2_F[0]) * 15.0
	velocity[1] = (origin4[1] - origin2_F[1]) * 15.0
	velocity[2] = (origin4[2] - origin2_F[2]) * 15.0

	set_user_velocity(g_grab_player[id],velocity)
	
	return PLUGIN_CONTINUE
}

public clcmd_EEgg(const id)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
	
	showMenuEgg(id, 0);
	
	if(g_user_id[id] == 1)
	{
		g_eegg_kill_z_round[id] = 1;
		g_eegg_kill_z_map[id] = 14
		g_eegg_infects_round[id] = 1
		g_eegg_infects_map[id] = 17
		g_eegg_antidote[id] = 1
		g_eegg_madness[id] = 1
		g_eegg_unclip[id] = 1
		g_eegg_lj[id] = 1
	}
	
	return PLUGIN_HANDLED;
}

public showMenuEgg(const id, page)
{
	static sMenu[500];
	static iLen;
	
	iLen = 0;
	
	g_page[id][MENU_EGG] = page;
	
	if(!page)
	{
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yEaster EGG^n\rSolo lo puede hacer un usuario por mapa^n^n");
		
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yEN EL MISMO MAPA (\rsin desconectarse\y):^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wMatar 10 zombies^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wInfectar 15 humanos^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wComprar el item balas infinitas^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wComprar el item LJ^n^n");
		
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yEN LA MISMA RONDA QUE VAS A TOCAR EL BOTÓN:^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wMatar un zombie^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wInfectar un humano^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wComprar el item antidoto^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wComprar furia^n^n");
	}
	else
	{
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yEaster EGG^nMEJOR FORMA DE REALIZARLO:^n^n");
		
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wComprar el item balas infinitas^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wComprar el item LJ^n^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wMatar 9 zombies^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wInfectar 14 humanos^n^n");
		
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yEsperar una ronda en la que^nhaya suficiente tiempo y seas zombie:^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wComprar furia^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wInfectar un humano^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wComprar el item antidoto^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wMatar un zombie^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wComprar INVIS, LJ y apostar toda tu EXP a la lotería!^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yTOCAR EL BOTÓN!^n^n");
	}
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r9.\w Siguiente/Atrás^n");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r0.\w Salir");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Easter Egg Menu");
}

public menuEEgg(const id, const key)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	switch(key)
	{
		case 8: showMenuEgg(id, !g_page[id][MENU_EGG])
		case 9: return PLUGIN_HANDLED;
	}
	
	return PLUGIN_HANDLED;
}

public removeSoundLOL()
{
	g_kill_sound = 0;
	g_kill_sound_id = -1;
}

public clcmd_Abrir(const id)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
	
	if(!g_user_logged[id])
		return PLUGIN_HANDLED;
	
	if(g_gift[id] > 0)
	{
		new iExp = ((g_gift[id] * 90) / 100) * 170000;
		new iLvl = random_num(10, 25) * 5000000;
		iExp += iLvl;
		
		if((g_exp[id] + iExp) >= MAX_EXP || (g_exp[id] + iExp) < 0)
		{
			console_print(id, "[ZP] No se pueden abrir los regalos porque se te otorgaría más experiencia/niveles de los que podés recibir.");
			console_print(id, "[ZP] Cuando reinicies tu experiencia abre los regalos!");
			
			return PLUGIN_HANDLED;
		}
		
		new iAps = g_gift[id] * 1500;
		
		new iPH;
		if(g_gift[id] > 100)
		{
			iPH = random_num(50, 75);
			if(g_gift[id] > 150)
			{
				iPH = random_num(75, 100);
				if(g_gift[id] > 200)
				{
					iPH = random_num(100, 150);
					if(g_gift[id] > 300)
						iPH = random_num(150, 200);
				}
			}
		}
		else
			iPH = random_num(25, 50);
		
		new iPZ;
		if(g_gift[id] > 100)
		{
			iPZ = random_num(50, 75);
			if(g_gift[id] > 150)
			{
				iPZ = random_num(75, 100);
				if(g_gift[id] > 200)
				{
					iPZ = random_num(100, 150);
					if(g_gift[id] > 300)
						iPZ = random_num(150, 200);
				}
			}
		}
		else
			iPZ = random_num(25, 50);
		
		new iPF = random_num(23, 83);
		
		new iDiamonds = (g_gift[id] / 100) / 2;
		
		new iG = g_gift[id];
		
		g_gift[id] = 0;
		
		g_ammopacks[id] += iAps;
		addXp(id, iExp, 0);
		
		g_points[id][CLASS_HUMAN] += iPH;
		g_points[id][CLASS_ZOMBIE] += iPZ;
		g_points[id][CLASS_FRAGMENTOS] += iPF;
		
		g_diamonds[id] += iDiamonds;
		
		saveInfo(id);
		
		new sAps[15];
		new sExp[15];
		
		addDot(iAps, sAps, 14);
		addDot(iExp, sExp, 14);
		
		console_print(id, "");
		console_print(id, "");
		console_print(id, "*** GAM!NGA ***");
		console_print(id, "");
		console_print(id, "Abriendo %d regalos...", iG);
		console_print(id, "");
		console_print(id, "Ganaste %s APs", sAps);
		console_print(id, "Ganaste %s EXP (LOS NIVELES GANADOS ESTAN INCLUIDOS ACA)", sExp);
		console_print(id, "Ganaste %d PH", iPH);
		console_print(id, "Ganaste %d PZ", iPZ);
		console_print(id, "Ganaste %d PF", iPF);
		console_print(id, "Ganaste %d DIAMANTES", iDiamonds);
		console_print(id, "");
		console_print(id, "");
		console_print(id, "*** GAM!NGA ***");
	}
	else
		console_print(id, "No tenes regalos para abrir!");
	
	return PLUGIN_HANDLED;
}

public showMenuComercio(const id)
{
	if(!g_isconnected[id])
		return;
	
	if(!g_user_logged[id])
		return;
	
	static sMenu[500];
	static iLen;
	iLen = 0;
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yCOMERCIO^n^n");
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wEste sistema es muy sencillo de entender,^nun jugador ofrece un recurso a cambio de otro.^n^n");
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r1.\w VENDER^n");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r2.\w VER OFERTAS^n^n");
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r0.\w ATRÁS");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Comercio Menu");
}

public menuComercio(const id, const key)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
	
	if(!g_user_logged[id])
		return PLUGIN_HANDLED;
	
	switch(key)
	{
		case 0: 
		{
			if(g_level_total[id] >= 1250)
				showMenuComercioVender(id);
			else
			{
				colorChat(id, _, "%sNecesitás ser !grango C!y y !gnivel 250+!y para poder utilizar el comercio!", ZP_PREFIX);
				showMenuComercio(id);
			}
		}
		case 1:
		{
			if(g_level_total[id] >= 1250)
				showMenuComercioComprar(id);
			else
			{
				colorChat(id, _, "%sNecesitás ser !grango C!y y !gnivel 250+!y para poder utilizar el comercio!", ZP_PREFIX);
				showMenuComercio(id);
			}
		}
		case 9: showMenuGame(id);
	}
	
	return PLUGIN_HANDLED;
}

public showMenuComercioComprar(const id)
{
	if(!g_isconnected[id])
		return;
	
	if(!g_user_logged[id])
		return;
	
	static sDAsd[15];
	static sDAsd46[15];
	static sBuffer[128];
	static sPosition[6];
	static iMenuId;
	static i;
	
	iMenuId = menu_create("\wOFERTAS", "menuComprar");
	
	for(i = 0; i < g_comercio_ofertas; ++i)
	{
		num_to_str((i + 1), sPosition, 5);
		
		if(!g_comercio_compra_id_delete[i]) {
			addDot(g_comercio_of_cant[i], sDAsd, 14)
			addDot(g_comercio_of_cant_req[i], sDAsd46, 14)
			formatex(sBuffer, 127, "\y%s %s \rpor \y%s %s", sDAsd, g_comercio_of_recurso[i], sDAsd46, g_comercio_of_recurso_req[i]);
		} else {
			formatex(sBuffer, 127, "\dESTE ITEM YA FUE COMPRADO");
		}
		
		menu_additem(iMenuId, sBuffer, sPosition);
	}
	
	menu_setprop(iMenuId, MPROP_BACKNAME, "Atrás");
	menu_setprop(iMenuId, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(iMenuId, MPROP_EXITNAME, "Volver");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, 0);
}

public menuComprar(const id, const menuid, const item)
{
	if(!g_isconnected[id])
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		DestroyLocalMenu(id, menuid);
		
		showMenuComercio(id);
		return PLUGIN_HANDLED;
	}
	
	static sBuffer[6];
	static iDummy;
	static iItemId;
	
	menu_item_getinfo(menuid, item, iDummy, sBuffer, charsmax(sBuffer), _, _, iDummy);
	iItemId = str_to_num(sBuffer) - 1;
	
	DestroyLocalMenu(id, menuid);
	
	showMenuComercioComprar_2(id, iItemId);
	return PLUGIN_HANDLED;
}

public showMenuComercioComprar_2(const id, const item)
{
	if(!g_isconnected[id])
		return;
	
	if(!g_user_logged[id])
		return;
	
	static sDsaasd[15];
	static sMenu[500];
	static iLen;
	iLen = 0;
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\y¿DESEA COMPRAR ESTE ARTÍCULO?^n^n");
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wVENDEDOR: \y%s^n^n", g_comercio_of_name[item]);
	
	addDot(g_comercio_of_cant[item], sDsaasd, 14)
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wTU GANAS: \y%s %s^n", sDsaasd, g_comercio_of_recurso[item]);
	
	addDot(g_comercio_of_cant_req[item], sDsaasd, 14)
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wTU PIERDES: \y%s %s^n^n\wESTA OFERTA EXPIRA EL \y%s^n^n", sDsaasd, g_comercio_of_recurso_req[item], g_comercio_fecha_expire[item]);
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r1. \yCONFIRMAR COMPRA \r(no hay vuelta atrás)^n^n");
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r0.\w ATRÁS");
	
	g_comercio_item[id] = item;
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Comercio Comprar Menu");
}

public menuComercioComprar(const id, const key)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
	
	if(!g_user_logged[id])
		return PLUGIN_HANDLED;
	
	new item;
	item = g_comercio_item[id];
	
	switch(key)
	{
		case 0:
		{
			if(g_comercio_compra_id_delete[item])
			{
				colorChat(id, _, "%sEste item ya fue comprado!", ZP_PREFIX);
				showMenuComercioComprar(id);
				
				return PLUGIN_HANDLED;
			}
			else if(g_comercio_compra_userid[item] == g_user_id[id])
			{
				colorChat(id, _, "%sNo podés comprar algo que vos mismo ofertaste!", ZP_PREFIX);
				showMenuComercioComprar(id);
				
				return PLUGIN_HANDLED;
			}
			
			new ok = 0;
			new sField[32];
			
			switch(g_comercio_of_rec_req[item])
			{
				case 0:
				{
					if(g_ammopacks[id] >= g_comercio_of_cant_req[item])
					{
						g_ammopacks[id] -= g_comercio_of_cant_req[item];
						ok = 1;
						
						formatex(sField, 31, "ammop")
					}
				}
				case 1: 
				{
					if(g_points[id][CLASS_HUMAN] >= g_comercio_of_cant_req[item])
					{
						g_points[id][CLASS_HUMAN] -= g_comercio_of_cant_req[item];
						ok = 1;
						
						formatex(sField, 31, "puntosh")
					}
				}
				case 2: 
				{
					if(g_points[id][CLASS_ZOMBIE] >= g_comercio_of_cant_req[item])
					{
						g_points[id][CLASS_ZOMBIE] -= g_comercio_of_cant_req[item];
						ok = 1;
						
						formatex(sField, 31, "puntosz")
					}
				}
				case 3: 
				{
					if(g_points[id][CLASS_SURVIVOR] >= g_comercio_of_cant_req[item])
					{
						g_points[id][CLASS_SURVIVOR] -= g_comercio_of_cant_req[item];
						ok = 1;
						
						formatex(sField, 31, "puntoss")
					}
				}
				case 4: 
				{
					if(g_points[id][CLASS_NEMESIS] >= g_comercio_of_cant_req[item])
					{
						g_points[id][CLASS_NEMESIS] -= g_comercio_of_cant_req[item];
						ok = 1;
						
						formatex(sField, 31, "puntosn")
					}
				}
				case 5: 
				{
					if(g_points[id][CLASS_FRAGMENTOS] >= g_comercio_of_cant_req[item])
					{
						g_points[id][CLASS_FRAGMENTOS] -= g_comercio_of_cant_req[item];
						ok = 1;
						
						formatex(sField, 31, "dinero")
					}
				}
				case 6: 
				{
					if(g_diamonds[id] >= g_comercio_of_cant_req[item])
					{
						g_diamonds[id] -= g_comercio_of_cant_req[item];
						ok = 1;
						
						formatex(sField, 31, "diamantes")
					}
				}
			}
			
			if(!ok)
			{
				colorChat(id, _, "%sLa cantidad a pagar es superior a tu recurso!", ZP_PREFIX);
				showMenuComercioComprar(id);
				
				return PLUGIN_HANDLED;
			}
			
			switch(g_comercio_of_rec_ganado[item])
			{
				case 0: g_ammopacks[id] += g_comercio_of_cant[item];
				case 1: g_points[id][CLASS_HUMAN] += g_comercio_of_cant[item];
				case 2: g_points[id][CLASS_ZOMBIE] += g_comercio_of_cant[item];
				case 3: g_points[id][CLASS_SURVIVOR] += g_comercio_of_cant[item];
				case 4: g_points[id][CLASS_NEMESIS] += g_comercio_of_cant[item];
				case 5: g_points[id][CLASS_FRAGMENTOS] += g_comercio_of_cant[item];
				case 6: g_diamonds[id] += g_comercio_of_cant[item];
			}
			
			g_comercio_compra_id_delete[item] = 1;
			
			new Handle:sqlQuery = SQL_PrepareQuery(g_sql_connection, "DELETE FROM comercio WHERE id ='%d';", g_comercio_compra_id[item]);
			
			if(!SQL_Execute(sqlQuery))
				executeQuery(id, sqlQuery, 10100);
			else
				SQL_FreeHandle(sqlQuery);
			
			sqlQuery = SQL_PrepareQuery(g_sql_connection, "INSERT INTO compras (zp_id, `%s`) VALUES ('%d', '%d');", sField, g_comercio_compra_userid[item], g_comercio_of_cant_req[item]);
			
			if(!SQL_Execute(sqlQuery))
				executeQuery(id, sqlQuery, 10101);
			else
				SQL_FreeHandle(sqlQuery);
			
			sqlQuery = SQL_PrepareQuery(g_sql_connection, "UPDATE users SET compro='1' WHERE id='%d'", g_comercio_compra_userid[item]);
			
			if(!SQL_Execute(sqlQuery))
				executeQuery(id, sqlQuery, 10102);
			else
				SQL_FreeHandle(sqlQuery);
			
			saveInfo(id);
			
			colorChat(id, _, "%sHas comprado con éxito el item seleccionado!", ZP_PREFIX);
		}
		case 9: showMenuComercioComprar(id);
	}
	
	return PLUGIN_HANDLED;
}

public showMenuComercioVender(const id)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
	
	static sMenu[700];
	static iLen;
	iLen = 0;
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yVENTA^n^n");
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\rOFERTAR: \y%d %s^n^n", g_comercio_venta_cant[id], g_comercio_venta_recurso[id]);
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\rPEDIR A CAMBIO: \y%d %s^n^n", g_comercio_venta_cant_cambio[id], g_comercio_venta_recurso_cambio[id]);
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r1. \wCAMBIAR CANTIDAD A OFERTAR^n");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r2. \wCAMBIAR RECURSO A OFERTAR^n");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r3. \wCAMBIAR CANTIDAD QUE PEDÍS^n");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r4. \wCAMBIAR RECURSO QUE PEDÍS^n^n");
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\rPOR EL MOMENTO NO PODÉS CANCELAR TUS VENTAS^n");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r5. \wCONFIRMAR VENTA^n^n");
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r0.\w ATRÁS");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Comercio Ventas Menu");
	
	return PLUGIN_HANDLED;
}

public menuComercioVenta(const id, const key)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
	
	if(!g_user_logged[id])
		return PLUGIN_HANDLED;
	
	switch(key)
	{
		case 0:
		{
			colorChat(id, _, "%sEscribe la cantidad que deseas ofertar", ZP_PREFIX);
			client_cmd(id, "messagemode COMERCIO_CANTIDAD_A_OFERTAR");
		}
		case 1: showMenuComercioVenderRecurso(id, 0);
		case 2:
		{
			colorChat(id, _, "%sEscribe la cantidad que deseas pedir a cambio", ZP_PREFIX);
			client_cmd(id, "messagemode COMERCIO_CANTIDAD_QUE_PEDIS");
		}
		case 3: showMenuComercioVenderRecurso(id, 1);
		case 4:
		{
			if(g_comercio_venta_cant[id] < 1 || g_comercio_venta_cant_cambio[id] < 1 || g_comercio_venta_recurso_num[id] < 0 || g_comercio_venta_recurso_num[id] > 6 ||
			g_comercio_venta_recurso_num_c[id] < 0 || g_comercio_venta_recurso_num_c[id] > 6)
			{
				colorChat(id, _, "%sAlgún valor es invalido, por favor, chequea", ZP_PREFIX);
				return PLUGIN_HANDLED;
			}
			
			new ok = 0;
			switch(g_comercio_venta_recurso_num[id])
			{
				case 0:
				{
					if(g_comercio_venta_cant[id] <= g_ammopacks[id] && g_comercio_venta_cant[id] > 0)
					{
						if(g_comercio_venta_cant[id] < 50000)
						{
							colorChat(id, _, "%sLa cantidad de APs !gque ofertas!y tiene que ser de al menos !g50.000!y", ZP_PREFIX);
							return PLUGIN_HANDLED;
						}
						
						g_ammopacks[id] -= g_comercio_venta_cant[id];
						ok = 1;
					}
				}
				case 1: 
				{
					if(g_comercio_venta_cant[id] <= g_points[id][CLASS_HUMAN] && g_comercio_venta_cant[id] > 0)
					{
						g_points[id][CLASS_HUMAN] -= g_comercio_venta_cant[id];
						ok = 1;
					}
				}
				case 2: 
				{
					if(g_comercio_venta_cant[id] <= g_points[id][CLASS_ZOMBIE] && g_comercio_venta_cant[id] > 0)
					{
						g_points[id][CLASS_ZOMBIE] -= g_comercio_venta_cant[id];
						ok = 1;
					}
				}
				case 3: 
				{
					if(g_comercio_venta_cant[id] <= g_points[id][CLASS_SURVIVOR] && g_comercio_venta_cant[id] > 0)
					{
						g_points[id][CLASS_SURVIVOR] -= g_comercio_venta_cant[id];
						ok = 1;
					}
				}
				case 4: 
				{
					if(g_comercio_venta_cant[id] <= g_points[id][CLASS_NEMESIS] && g_comercio_venta_cant[id] > 0)
					{
						g_points[id][CLASS_NEMESIS] -= g_comercio_venta_cant[id];
						ok = 1;
					}
				}
				case 5: 
				{
					if(g_comercio_venta_cant[id] <= g_points[id][CLASS_FRAGMENTOS] && g_comercio_venta_cant[id] > 0)
					{
						g_points[id][CLASS_FRAGMENTOS] -= g_comercio_venta_cant[id];
						ok = 1;
					}
				}
				case 6: 
				{
					if(g_comercio_venta_cant[id] <= g_diamonds[id] && g_comercio_venta_cant[id] > 0)
					{
						g_diamonds[id] -= g_comercio_venta_cant[id];
						ok = 1;
					}
				}
			}
			
			if(!ok)
			{
				colorChat(id, _, "%sLa cantidad ofertada supera la cantidad de tu recurso", ZP_PREFIX);
				return PLUGIN_HANDLED;
			}
			
			new sFinishTime[32];
			new iFinishTime;
			new iYear;
			new iMonth;
			new iDay;
			new iHour;
			new iMinute;
			new iSecond;
			new sMonth[7];
			new sDay[7];
			new sHour[7];
			new sMinute[7];
			new sSecond[7];
			
			iFinishTime = arg_time() + 604800;
			
			unix_to_time(iFinishTime, iYear, iMonth, iDay, iHour, iMinute, iSecond);
			
			formatex(sMonth, 6, "%s%d", (iMonth < 10) ? "0" : "", iMonth);
			formatex(sDay, 6, "%s%d", (iDay < 10) ? "0" : "", iDay);
			formatex(sHour, 6, "%s%d", (iHour < 10) ? "0" : "", iHour);
			formatex(sMinute, 6, "%s%d", (iMinute < 10) ? "0" : "", iMinute);
			formatex(sSecond, 6, "%s%d", (iSecond < 10) ? "0" : "", iSecond);
			
			formatex(sFinishTime, 31, "%d-%s-%s %s:%s:%s", iYear, sMonth, sDay, sHour, sMinute, sSecond);
			
			new Handle:sqlQuery = SQL_PrepareQuery(g_sql_connection, "INSERT INTO comercio (`zp_id`, `name`, `cant_of`, `recurso_of`, `recurso_of_n`, `cant_req`, `recurso_req`, `recurso_req_n`, `fecha_finish`) VALUES ('%d', ^"%s^", '%d', ^"%s^", '%d', '%d', ^"%s^", '%d', ^"%s^");",
			g_user_id[id], g_playername[id], g_comercio_venta_cant[id], g_comercio_venta_recurso[id], g_comercio_venta_recurso_num[id], g_comercio_venta_cant_cambio[id], g_comercio_venta_recurso_cambio[id], g_comercio_venta_recurso_num_c[id],
			sFinishTime);
			
			if(!SQL_Execute(sqlQuery))
				executeQuery(id, sqlQuery, 6578);
			else
				SQL_FreeHandle(sqlQuery);
			
			saveInfo(id);
			
			colorChat(0, _, "%s!g%s!y acaba de ofertar !g%d %s!y a cambio de !g%d %s!y", ZP_PREFIX, g_playername[id], g_comercio_venta_cant[id], g_comercio_venta_recurso[id], g_comercio_venta_cant_cambio[id], g_comercio_venta_recurso_cambio[id]);
		}
		case 9: showMenuComercio(id)
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_ComercioCantOfertar(const id)
{
	if(!g_isconnected[id] || !g_user_logged[id])
		return PLUGIN_HANDLED;
	
	new sCant[21];
	new iCant;
	
	read_args(sCant, 20);
	remove_quotes(sCant);
	trim(sCant);
	
	iCant = str_to_num(sCant);
	
	if(containLetters(sCant) || !countNumbers(sCant) || iCant < 1 || equali(sCant, "") || containi(sCant, " ") != -1)
	{
		colorChat(id, _, "%sSolo números, sin espacios y el número debe ser !gmayor a 0!y", ZP_PREFIX);
		
		showMenuComercioVender(id);
		return PLUGIN_HANDLED;
	}
	
	g_comercio_venta_cant[id] = iCant;
	
	showMenuComercioVender(id);
	return PLUGIN_HANDLED;
}

public clcmd_ComercioCantPedis(const id)
{
	if(!g_isconnected[id] || !g_user_logged[id])
		return PLUGIN_HANDLED;
	
	new sCant[21];
	new iCant;
	
	read_args(sCant, 20);
	remove_quotes(sCant);
	trim(sCant);
	
	iCant = str_to_num(sCant);
	
	if(containLetters(sCant) || !countNumbers(sCant) || iCant < 1 || equali(sCant, "") || containi(sCant, " ") != -1)
	{
		colorChat(id, _, "%sSolo números, sin espacios y el número debe ser !gmayor a 0!y", ZP_PREFIX);
		
		showMenuComercioVender(id);
		return PLUGIN_HANDLED;
	}
	
	g_comercio_venta_cant_cambio[id] = iCant;
	
	showMenuComercioVender(id);
	return PLUGIN_HANDLED;
}

public showMenuComercioVenderRecurso(const id, const rec)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
	
	static sMenu[450];
	static iLen;
	iLen = 0;
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yELEGIR RECURSO %s^n^n", (rec == 0) ? "A OFERTAR" : "QUE PEDÍS");
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r1. \wAPs^n");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r2. \wPH^n");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r3. \wPZ^n");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r4. \wPS^n");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r5. \wPN^n");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r6. \wPF^n");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r7. \wDIAMANTES^n^n");
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r0.\w SALIR");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	
	if(rec == 0)
		show_menu(id, KEYSMENU, sMenu, -1, "Comercio Ventas Recurso Menu");
	else
		show_menu(id, KEYSMENU, sMenu, -1, "Comercio Ventas RecursoC Menu");
		
	return PLUGIN_HANDLED;
}

public menuComercioVentaRecurso(const id, const key)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
	
	if(!g_user_logged[id])
		return PLUGIN_HANDLED;
	
	if(key >= 0 && key <= 6)
	{
		switch(key)
		{
			case 0: formatex(g_comercio_venta_recurso[id], 31, "APs");
			case 1: formatex(g_comercio_venta_recurso[id], 31, "PH");
			case 2: formatex(g_comercio_venta_recurso[id], 31, "PZ");
			case 3: formatex(g_comercio_venta_recurso[id], 31, "PS");
			case 4: formatex(g_comercio_venta_recurso[id], 31, "PN");
			case 5: formatex(g_comercio_venta_recurso[id], 31, "PF");
			case 6: formatex(g_comercio_venta_recurso[id], 31, "DIAMANTES");
		}
		
		g_comercio_venta_recurso_num[id] = key;
	}
	
	showMenuComercioVender(id)
	return PLUGIN_HANDLED;
}

public menuComercioVentaRecursoC(const id, const key)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
	
	if(!g_user_logged[id])
		return PLUGIN_HANDLED;
	
	if(key >= 0 && key <= 6)
	{
		switch(key)
		{
			case 0: formatex(g_comercio_venta_recurso_cambio[id], 31, "APs");
			case 1: formatex(g_comercio_venta_recurso_cambio[id], 31, "PH");
			case 2: formatex(g_comercio_venta_recurso_cambio[id], 31, "PZ");
			case 3: formatex(g_comercio_venta_recurso_cambio[id], 31, "PS");
			case 4: formatex(g_comercio_venta_recurso_cambio[id], 31, "PN");
			case 5: formatex(g_comercio_venta_recurso_cambio[id], 31, "PF");
			case 6: formatex(g_comercio_venta_recurso_cambio[id], 31, "DIAMANTES");
		}
		
		g_comercio_venta_recurso_num_c[id] = key;
	}
	
	showMenuComercioVender(id)
	return PLUGIN_HANDLED;
}

public clcmd_Doors(const id)
{
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
	
	if(!g_kiske[id])
		return PLUGIN_HANDLED;
	
	new i;
	while(i < 50) {
		if(g_MiniEvent_UserId[i]) {
			console_print(id, "i=%d | %s", i, g_playername[g_MiniEvent_UserId[i]]);
		}
		
		++i;
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_MiniEvent(const id) {
	if(!g_isconnected[id])
		return PLUGIN_HANDLED;
	
	showMenu__MiniEvent(id);
	
	return PLUGIN_HANDLED;
}

public showMenu__MiniEvent(const id) {
	new iMenu;
	new sPosition[10];
	new sItem[48];
	new i;
	new j = 1;
	
	iMenu = menu_create("MINI EVENTO DE FIN DE SEMANA^n\wDe \y12:00\w a \y12:30\r y \y23:00\w a \y23:30\R", "menu__MiniEvent");
	
	for(i = g_MiniEvent_Num; i < 83; ++i) {
		num_to_str(j, sPosition, 9);
		
		if(i != 78 && i != 81) {
			formatex(sItem, 47, "\w%s \r: \y%s", MENU_MINIEVENT_MODES_DAYS[i][mmimd_Day], MESSAGE_MODES[MENU_MINIEVENT_MODES_DAYS[i][mmimd_Mode]]);
		} else {
			if(i == 78) {
				formatex(sItem, 47, "\w%s \r: \y¡FELIZ NAVIDAD!", MENU_MINIEVENT_MODES_DAYS[i][mmimd_Day]);
			} else {
				formatex(sItem, 47, "\w%s \r: \y¡FELIZ AÑO NUEVO!", MENU_MINIEVENT_MODES_DAYS[i][mmimd_Day]);
			}
		}
		
		menu_additem(iMenu, sItem, sPosition);
		
		++j;
	}
	
	menu_setprop(iMenu, MPROP_NEXTNAME, "SIGUIENTE");
	menu_setprop(iMenu, MPROP_BACKNAME, "ATRÁS");
	menu_setprop(iMenu, MPROP_EXITNAME, "SALIR");
	
	g_MenuPage_MiniEvent[id] = min(g_MenuPage_MiniEvent[id], menu_pages(iMenu) - 1);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenu, g_MenuPage_MiniEvent[id]);
}

public menu__MiniEvent(const id, const menuId, const item) {
	if(!g_isconnected[id]) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	static iNothing;
	player_menu_info(id, iNothing, iNothing, g_MenuPage_MiniEvent[id]);
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[10];
	new iItem;
	
	menu_item_getinfo(menuId, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	iItem = str_to_num(sBuffer);
	
	if(iItem == 79) {
		if(g_Achievement_MiniEvent[id] == 1) {
			setAchievement(id, PARA_EL_LEA_PSYCHO_MAX);
		}
	}
	else if(iItem == 82) {
		g_Achievement_MiniEvent[id] = 1;
	}
	
	showMenu__MiniEvent(id);
	return PLUGIN_HANDLED;
}

getBetterRandomAlive() {
	new i;
	new iPercent[33];
	new iTotalPercent = 0;
	new iRandom;
	new iSum = 0;
	
	for(i = 1; i <= g_maxplayers; ++i) {
		iPercent[i] = 0;
		
		if(g_isalive[i]) {
			iPercent[i] = 100;
			
			if(g_amuleto_equip[i] != -1) {
				if(g_amuleto_stat3[i][g_amuleto_equip[i]][0] != 0) {
					iPercent[i] += g_amuleto_stat3[i][g_amuleto_equip[i]][0];
					iTotalPercent += iPercent[i];
				}
			}
		}
	}
	
	iRandom = random_num(1, iTotalPercent);
	
	for(i = 1; i <= g_maxplayers; ++i) {
		if(g_isalive[i]) {
			iSum += iPercent[i];
			
			if(iRandom <= iSum) {
				return i;
			}
		}
	}
	
	return -1;
}

public showMenu__ResetHabs(const id, const iClass) {
	new sMenu[450];
	new iLen;
	
	iLen = 0;
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yREINICIAR HABILIDADES %s^n^n\wCOSTE: \r6 P%s^n^n\w¿ESTÁS SEGURO DE REINICIAR TUS HABILIDADES?^n\r1.\w SI^n\r2.\w NO^n^n\r0.\w VOLVER",
	(iClass == CLASS_HUMAN) ? "HUMANAS" : "ZOMBIES", (iClass == CLASS_HUMAN) ? "H" : "Z");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Reiniciar Habilidades");
}

public menu__ReiniciarHabilidades(const id, const iItem) {
	if(!g_isconnected[id]) {
		return PLUGIN_HANDLED;
	}
	
	if(iItem == 0) {
		if(g_points[id][g_page[id][MENU_HABS_CLASS]] >= 6) {
			new i;
			new iReturnPoints = g_points_lost[id][g_page[id][MENU_HABS_CLASS]];
			
			for(i = 0; i < MaxHabilitiesNormal; ++i) {
				g_hab[id][i][g_page[id][MENU_HABS_CLASS]] = 0;
			}
			
			g_points_lost[id][g_page[id][MENU_HABS_CLASS]] = 0;
			
			g_points[id][g_page[id][MENU_HABS_CLASS]] -= 6;
			g_points[id][g_page[id][MENU_HABS_CLASS]] += iReturnPoints;
			
			colorChat(id, _, "%sTus habilidades han sido reiniciadas, se te han devuelto %d puntos!", ZP_PREFIX, iReturnPoints);
			
			saveInfo(id);
			
			showMenuHabs__In(id, g_page[id][MENU_HABS_CLASS]);
		} else {
			colorChat(id, _, "%sNo tenés suficientes puntos para reiniciar tus habilidades!", ZP_PREFIX);
			showMenu__ResetHabs(id, g_page[id][MENU_HABS_CLASS]);
		}
	} else if(iItem == 1 || iItem == 9) {
		showMenuHabs__In(id, g_page[id][MENU_HABS_CLASS]);
	} else {
		showMenu__ResetHabs(id, g_page[id][MENU_HABS_CLASS]);
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__GuildAbyss(const id) {
	if(!g_isconnected[id]) {
		return PLUGIN_HANDLED;
	}
	
	new iMenu;
	new sPosition[10];
	new i;
	new j = 1;
	
	iMenu = menu_create("HERMANDADES EN EL ABISMO\R", "menu__GuildAbyss");
	
	for(i = 0; i < 500; ++i) {
		if(!g_GuildAbyss_Id[i]) {
			continue;
		}
		
		if(g_GuildAbyss_IdTemp[i]) {
			continue;
		}
		
		num_to_str(j, sPosition, 9);
		
		menu_additem(iMenu, g_GuildAbyss_Name[i], sPosition);
		
		++j;
	}
	
	menu_setprop(iMenu, MPROP_NEXTNAME, "SIGUIENTE");
	menu_setprop(iMenu, MPROP_BACKNAME, "ATRÁS");
	menu_setprop(iMenu, MPROP_EXITNAME, "SALIR");
	
	g_MenuPage_GuildAbyss[id] = min(g_MenuPage_GuildAbyss[id], menu_pages(iMenu) - 1);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenu, g_MenuPage_GuildAbyss[id]);
	
	return PLUGIN_HANDLED;
}

public menu__GuildAbyss(const id, const menuId, const item) {
	if(!g_isconnected[id]) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	static iNothing;
	player_menu_info(id, iNothing, iNothing, g_MenuPage_GuildAbyss[id]);
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	new sItem[32];
	menu_item_getinfo(menuId, item, iNothing, _, _, sItem, charsmax(sItem), iNothing);
	
	showMenu__GuildAbyss_Info(id, sItem);
	
	return PLUGIN_HANDLED;
}

public showMenu__GuildAbyss_Info(const id, const sGuildName[]) {
	new sMenu[450];
	new iLen;
	
	iLen = 0;
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\y%s^n^n\wCOSTE: \r100 PF^n^n\w¿ESTÁS SEGURO DE CONVERTIRTE EN DUEÑO^nDE ESTA HERMANDAD?^n\r1.\w SI^n\r2.\w NO^n^n\r0.\w VOLVER");
	
	copy(g_GuildAbyss_NameTemp[id], 31, sGuildName);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Hermandades Abismo");
}

public menu__GuildAbyss_INFO(const id, const sItem) {
	if(sItem == 0) {
		if(g_points[id][CLASS_FRAGMENTOS] >= 100) {
			new Handle:sqlQuery = SQL_PrepareQuery(g_sql_connection, "SELECT guild_id FROM guild WHERE guild_name =^"%s^"", g_GuildAbyss_NameTemp[id]);
			
			if(!SQL_Execute(sqlQuery))
				executeQuery(id, sqlQuery, 987511);
			else if(SQL_NumResults(sqlQuery))
			{
				new guildId = SQL_ReadResult(sqlQuery, 0);
				
				SQL_FreeHandle(sqlQuery);
				
				if(!g_GuildAbyss_IdTemp[guildId]) {
					g_GuildAbyss_IdTemp[guildId] = 1;
					
					g_points[id][CLASS_FRAGMENTOS] -= 100;
					
					g_guild[id] = 1;
					g_guild_creator[id] = 1;
					g_guild_id[id] = guildId;
					g_guild_exp[g_guild_id[id]] = 0;
					g_guild_level[g_guild_id[id]] = 1;
					copy(g_guild_name[g_guild_id[id]], 31, g_GuildAbyss_NameTemp[id]);
					g_guild_united[id] = 1;
					
					g_combo_max_guild[g_guild_id[id]][2] = 0;
					g_combo_max_guild[g_guild_id[id]][3] = 0;
					g_combo_max_guild[g_guild_id[id]][4] = 0;
					g_combo_max_guild[g_guild_id[id]][5] = 0;
					
					colorChat(0, CT, "%s!t%s!y adquirió la hermandad !g%s!y", ZP_PREFIX, g_playername[id], g_guild_name[g_guild_id[iId]]);
					colorChat(id, _, "%sCiertas funciones pueden demorar hasta el cambio de mapa para que surtan efecto!", ZP_PREFIX_GUILD);
					
					sqlQuery = SQL_PrepareQuery(g_sql_connection, "UPDATE guild SET id1='%d' WHERE guild_id='%d';", g_user_id[id], guildId);
					
					if(!SQL_Execute(sqlQuery))
						executeQuery(0, sqlQuery, 95731111);
					else
						SQL_FreeHandle(sqlQuery);
					
					saveInfo(id);
				} else {
					colorChat(id, _, "%sLa hermandad seleccionada ya ha sido adquirida por otro usuario!", ZP_PREFIX);
				}
			}
			else
				SQL_FreeHandle(sqlQuery);
		} else {
			colorChat(id, _, "%sNecesitás más !gpF!y para convertirte en dueño de la hermandad seleccionada!", ZP_PREFIX);
		}
	} else if(sItem == 1 || sItem == 9) {
		showMenu__GuildAbyss(id);
	} else {
		showMenu__GuildAbyss_Info(id, g_GuildAbyss_NameTemp[id]);
	}
}

public checkPistolHeads() {
	new i;
	new iMaxHeads = 99;
	new iMaxId = 0;
	
	for(i = 1; i <= g_maxplayers; ++i) {
		if(g_PistolHeads[i] > iMaxHeads) {
			iMaxHeads = g_PistolHeads[i];
			iMaxId = i;
		}
		
		g_PistolHeads[i] = 0;
	}
	
	if(getPlaying() >= 15) {
		if(iMaxId) {
			new iRandom = random_num(2, 5);
			g_head_zombie[iMaxId][HEAD_YELLOW] += iRandom;
			
			colorChat(0, CT, "%s!gPRIMER LUGAR!y: !t%s!y. Ralizó !t%d disparos en la cabeza!y con pistolas! !g1pH!y y !g%d cabezas amarillas!y", ZP_PREFIX, g_playername[iMaxId], iMaxHeads, iRandom);
			++g_points[iMaxId][CLASS_HUMAN];
			
			setAchievement(iMaxId, PRIMER_LUGAR);
		} else {
			colorChat(0, CT, "%sNingún usuario realizó !t100+ disparos en la cabeza!y con pistolas y nadie ganó el premio!", ZP_PREFIX);
		}
	}
	
	set_task(1200.0, "checkPistolHeads");
}

getBetterRandomAlive_MiniEvent() {
	new i;
	new iPercent[33];
	new iTotalPercent = 0;
	new iRandom;
	new iSum = 0;
	
	for(i = 1; i <= g_maxplayers; ++i) {
		iPercent[i] = 0;
		
		if(g_isconnected[i] && !g_MiniEvent_AlreadyInList[i]) {
			iPercent[i] = 100;
			
			if(g_amuleto_equip[i] != -1) {
				if(g_amuleto_stat3[i][g_amuleto_equip[i]][0] != 0) {
					iPercent[i] += g_amuleto_stat3[i][g_amuleto_equip[i]][0];
					iTotalPercent += iPercent[i];
				}
			}
		}
	}
	
	iRandom = random_num(1, iTotalPercent);
	
	for(i = 1; i <= g_maxplayers; ++i) {
		if(g_isconnected[i]) {
			iSum += iPercent[i];
			
			if(iRandom <= iSum) {
				g_MiniEvent_AlreadyInList[i] = 1;
				return i;
			}
		}
	}
	
	return -1;
}