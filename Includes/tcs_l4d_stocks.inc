/* ========================================
======== STOCKS ===========================
======================================== */

stock fn_CC(const id, const input[], any:...)
{
	static iCount;
	static iUser[32];
	static sMessage[191];
	static iFirstTime;
	static iMessageId_SayText;
	static i;
	
	iCount = 1;
	vformat(sMessage, 190, input, 3);
	
	replace_all(sMessage, 190, "!y", "^1");
	replace_all(sMessage, 190, "!t", "^3");
	replace_all(sMessage, 190, "!g", "^4");
	
	if(id)
		iUser[0] = id;
	else
		get_players(iUser, iCount, "ch");
	
	if(!iFirstTime)
	{
		iMessageId_SayText = get_user_msgid("SayText");
		iFirstTime = 1;
	}
	
	for(i = 0; i < iCount; ++i)
	{
		if(is_user_connected(iUser[i]))
		{
			message_begin(MSG_ONE_UNRELIABLE, iMessageId_SayText, _, iUser[i]);
			write_byte(iUser[i]);
			write_string(sMessage);
			message_end();
		}
	}
}

stock fn_AddDot(const num, output[], len)
{
	static sTemp[15];
	static iOutput_Position;
	static iNum_Position;
	static iNum_Len;
	
	iOutput_Position = 0;
	iNum_Position = 0;
	
	iNum_Len = num_to_str(num, sTemp, 14);

	while((iNum_Position < iNum_Len) && (iOutput_Position < len)) 
	{
		output[++iOutput_Position] = sTemp[++iNum_Position];

		if((iNum_Len - iNum_Position) && !((iNum_Len - iNum_Position) % 3))
			output[++iOutput_Position] = '.';
	}

	output[iOutput_Position] = EOS;

	return iOutput_Position;
}

stock fn_GetModel(id, model[], len)
	get_user_model(id, model, len);

stock fn_GetTeam(id)
{
	if(pev_valid(id) != PDATA_SAFE)
		return FM_CS_TEAM_UNASSIGNED;
	
	return get_pdata_int(id, OFFSET_CSTEAMS, OFFSET_LINUX);
}

stock fn_SetTeam(id, team)
{
	if(pev_valid(id) != PDATA_SAFE)
		return;
	
	set_pdata_int(id, OFFSET_CSTEAMS, team, OFFSET_LINUX);
}

stock fn_SetBatteries(id, value)
{
	if(pev_valid(id) != PDATA_SAFE)
		return;
	
	set_pdata_int(id, OFFSET_FLASHLIGHT_BATTERY, value, OFFSET_LINUX);
}

stock fn_TeamUpdate(id)
{
	static Float:fGameTime;
	fGameTime = get_gametime();
	
	if(fGameTime - g_teams_targettime >= 0.1)
	{
		set_task(0.1, "fn_SetTeamMessage", id + TASK_TEAM);
		g_teams_targettime = fGameTime + 0.1;
	}
	else
	{
		set_task((g_teams_targettime + 0.1) - fGameTime, "fn_SetTeamMessage", id+TASK_TEAM);
		g_teams_targettime = g_teams_targettime + 0.1;
	}
}

stock fn_GetWeaponId(ent)
{
	if(pev_valid(ent) != PDATA_SAFE)
		return -1;
	
	return get_pdata_cbase(ent, OFFSET_WEAPONOWNER, OFFSET_LINUX_WEAPONS);
}

stock fn_GetCount_ZombieSpecials()
{
	static i;
	static iZombieSpecials;
	
	iZombieSpecials = 0;
	
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_alive(i))
			continue;
		
		if(!g_zombie[i])
			continue;
		
		if(g_boomer[i] || g_smoker[i] || g_hunter[i])
			++iZombieSpecials;
	}
	
	return iZombieSpecials;
}

stock fn_SQRT(iNum)
{
	new iDiv = iNum;
	new iResult = 1;
	
	while(iDiv > iResult)
	{
		iDiv = (iDiv + iResult) / 2;
		iResult = iNum / iDiv;
	}
	
	return iDiv;
}

stock fn_CreateSpriteL4D(const Float:XYZ_position[3], sprite_index, brightness, scale)
{
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_SPRITE);
	engfunc(EngFunc_WriteCoord, XYZ_position[0]);
	engfunc(EngFunc_WriteCoord, XYZ_position[1]);
	engfunc(EngFunc_WriteCoord, XYZ_position[2]);
	write_short(sprite_index);
	write_byte(scale);
	write_byte(brightness);
	message_end();
}

stock ham_strip_weapons(id, weapon[])
{
	if(!equal(weapon, "weapon_", 7))
		return 0;
	
	static weaponId;
	weaponId = get_weaponid(weapon);
	
	if(!weaponId)
		return 0;
	
	static weaponEnt;
	weaponEnt = -1;
	
	while((weaponEnt = engfunc(EngFunc_FindEntityByString, weaponEnt, "classname", weapon)) && entity_get_edict(weaponEnt, EV_ENT_owner) != id)
	{
		// null
	}
	
	if(!weaponEnt)
		return 0;
	
	if(g_currentweapon[id] == weaponId) 
		ExecuteHamB(Ham_Weapon_RetireWeapon, weaponEnt);
	
	if(!ExecuteHamB(Ham_RemovePlayerItem, id, weaponEnt)) 
		return 0;
	
	ExecuteHamB(Ham_Item_Kill, weaponEnt);
	
	set_pev(id, pev_weapons, pev(id, pev_weapons) & ~(1 << weaponId));
	
	return 1;
}

stock fn_CC_Best(id, COLOR=DONT_CHANGE, fmt[], any:...)
{
	new szMsg[192];
	szMsg[0] = 0x04;
	
	vformat(szMsg[1], charsmax(szMsg)-1, fmt, 4);
	
	new szTeam[11];
	new MSG_DEST = id ? MSG_ONE : MSG_ALL;
	
	static const szTeamNames[Colors][] = {"UNASSIGNED", "TERRORIST", "CT", "SPECTATOR"};
	
	if( COLOR )
	{
		Send_TeamInfo(id, szTeamNames[COLOR], MSG_DEST);
	}
	
	static iSayText;
	
	if( iSayText || (iSayText = get_user_msgid("SayText")) )
	{
		message_begin(MSG_DEST, iSayText, _, id);
		{
			write_byte(id ? id : 1);
			write_string(szMsg);
		}
		message_end();
	}
	
	if( COLOR )
	{
		if( id || is_user_connected(1) )
		{
			get_user_team(id ? id : 1, szTeam, charsmax(szTeam));
			Send_TeamInfo(id, szTeam, MSG_DEST);
		}
		else
		{
			Send_TeamInfo(0, "UNASSIGNED", MSG_DEST);
		}
	}
}

Send_TeamInfo(const id, const szTeam[], MSG_DEST)
{
	static iTeamInfo;
	if( iTeamInfo || (iTeamInfo = get_user_msgid("TeamInfo")) )
	{
		message_begin(MSG_DEST, iTeamInfo, _, id);
		{
			write_byte(id ? id : 1);
			write_string(szTeam);
		}
		message_end();
	}
}

stock is_hull_vacant(const Float:origin[3], hull)
{
	engfunc(EngFunc_TraceHull, origin, origin, 0, hull, 0, 0);
	
	if(!get_tr2(0, TR_StartSolid) && !get_tr2(0, TR_AllSolid) && get_tr2(0, TR_InOpen))
		return 1;
	
	return 0;
}