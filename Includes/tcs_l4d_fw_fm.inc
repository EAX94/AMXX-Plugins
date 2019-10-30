/* ========================================
======== FORWARDS - FAKEMETA ==============
======================================== */

public fw_SetModel_Pre(entity, const model[])
{
	if(equal(model, "models/w_hegrenade.mdl"))
	{
		entity_set_model(entity, g_model_wgrenade_pipe);
		return FMRES_SUPERCEDE;
	}
	
	if(equal(model, "models/w_flashbang.mdl"))
	{
		entity_set_model(entity, g_model_wmedkit);
		return FMRES_SUPERCEDE;
	}
	
	if(equal(model, "models/w_smokegrenade.mdl"))
	{
		entity_set_model(entity, g_model_wpildoras);
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}

public fw_Spawn(entity)
{
	if(!is_valid_ent(entity))
		return FMRES_IGNORED;
	
	new const ENTITIES_REMOVED[][] = { "func_bomb_target", "info_bomb_target", "info_vip_start", "func_vip_safetyzone", "func_escapezone", "hostage_entity", "monster_scientist",
	"info_hostage_rescue", "func_hostage_rescue", "env_rain", "env_snow", "env_fog", "func_vehicle", "info_map_parameters", "func_buyzone", "game_text" };
	new sClassName[32];
	new i;
	
	entity_get_string(entity, EV_SZ_classname, sClassName, 31);
	
	for(i = 0; i < sizeof(ENTITIES_REMOVED); ++i)
	{
		if(equal(sClassName, ENTITIES_REMOVED[i]))
		{
			remove_entity(entity);
			return FMRES_SUPERCEDE;
		}
	}
	
	return FMRES_IGNORED;
}

public fw_PrecacheSound(const sound[])
{
	if(equal(sound, "hostage", 7))
		return FMRES_SUPERCEDE;
	
	return FMRES_IGNORED;
}

public fw_ClientKill()
	return FMRES_SUPERCEDE;

public fw_SetClientKeyValue(id, const infobuffer[], const key[])
{
	if(key[0] == 'm' && key[1] == 'o' && key[2] == 'd' && key[3] == 'e' && key[4] == 'l')
		return FMRES_SUPERCEDE;
	
	if(key[0] == 'n' && key[1] == 'a' && key[2] == 'm' && key[3] == 'e')
		return FMRES_SUPERCEDE;
	
	return FMRES_IGNORED;
}

public fw_ClientUserInfoChanged(id, buffer)
{
	if(!is_user_connected(id))
		return FMRES_IGNORED;
	
	static sCurrentModel[32];
	fn_GetModel(id, sCurrentModel, charsmax(sCurrentModel));
	
	if(!equal(sCurrentModel, g_playermodel[id]) && !task_exists(id + TASK_MODEL))
		fn_SetModel(id + TASK_MODEL);
	
	static sNewName[32];
	engfunc(EngFunc_InfoKeyValue, buffer, "name", sNewName, charsmax(sNewName));
	
	if(equal(sNewName, g_playername[id]))
		return FMRES_IGNORED;
	
	engfunc(EngFunc_SetClientKeyValue, id, buffer, "name", g_playername[id]);
	client_cmd(id, "name ^"%s^"; setinfo name ^"%s^"", g_playername[id], g_playername[id]);
	
	console_print(id, MESSAGE_AI);
	
	return FMRES_SUPERCEDE;
}

/*public fw_Voice_SetClientListening(receiver, sender, listen)
{
	if(!is_user_connected(sender) || receiver == sender)
		return FMRES_IGNORED;
	
	new iBlock;
	iBlock = 0;
	
	if(g_zombie[sender] && !g_zombie[receiver])
		iBlock = 1;
	
	if(!g_zombie[sender])
	{
		if(g_zombie[receiver])
			iBlock = 1;
		
		if(!is_user_alive(receiver))
			iBlock = 1;
		
		if(!is_user_alive(sender) && is_user_alive(receiver))
			iBlock = 1;
	}
	
	if(g_zp_id[receiver] == 1 || g_zp_id[sender] == 1)
		iBlock = 0;
	
	if(iBlock)
	{
		engfunc(EngFunc_SetClientListening, receiver, sender, 0);
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}*/

public fw_CmdStart(id, handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED;
	
	static iButton;
	static iOldButton;
	
	iButton = get_uc(handle, UC_Buttons);
	iOldButton = entity_get_int(id, EV_INT_oldbuttons);
	
	if(!g_zombie[id] && (g_currentweapon[id] == CSW_FLASHBANG || g_currentweapon[id] == CSW_SMOKEGRENADE))
	{
		if(iButton & IN_ATTACK)
		{
			iButton &= ~IN_ATTACK;
			
			set_uc(handle, UC_Buttons, iButton);
			
			return FMRES_SUPERCEDE;
		}
		else if((iButton & IN_ATTACK2) && !(iOldButton & IN_ATTACK2))
		{
			if(g_currentweapon[id] == CSW_FLASHBANG) // Adrenalina
			{
				if(g_adrenalina[id])
					return FMRES_IGNORED;
				
				ham_strip_weapons(id, "weapon_flashbang");
				
				emit_sound(id, CHAN_BODY, "buttons/bell1.wav", 1.0, ATTN_NORM, 0, PITCH_HIGH);
				
				g_adrenalina[id] = 1;
				
				ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
				
				remove_task(id + TASK_ADRENALINA);
				set_task(0.1, "fn_EffectAdrenalin", id + TASK_ADRENALINA, _, _, "b");
				set_task(15.0, "fn_FinishAdrenalin", id + TASK_ADRENALINA);
			}
			else // Pildoras
			{
				ham_strip_weapons(id, "weapon_smokegrenade");
				ham_strip_weapons(id, "weapon_smokegrenade");
				
				if(g_human_coold[id])
				{
					g_human_coold[id] = 0;
					set_user_rendering(id);
				}
				
				set_user_health(id, get_user_health(id) + 4000);
				
				emit_sound(id, CHAN_BODY, "buttons/blip1.wav", 1.0, ATTN_NORM, 0, PITCH_HIGH);
				
				message_begin(MSG_ONE_UNRELIABLE, g_message_screenfade, _, id);
				write_short((1<<12) * 2);
				write_short((1<<12) * 2);
				write_short(0x0000);
				write_byte(25);
				write_byte(100);
				write_byte(25);
				write_byte(150);
				message_end();
			}
		}
	}
	else if(!g_zombie[id] && g_nomove[id] && ((iButton & IN_ATTACK) || (iButton & IN_ATTACK2)))
	{
		if((iButton & IN_ATTACK))
		{
			iButton &= ~IN_ATTACK;
			set_uc(handle, UC_Buttons, iButton);
		}
		else
		{
			iButton &= ~IN_ATTACK2;
			set_uc(handle, UC_Buttons, iButton);
		}
		
		return FMRES_SUPERCEDE;
	}
	
	if(!g_boomer[id] && !g_hunter[id] && !g_smoker[id] && !g_tank[id])
		return FMRES_IGNORED;
	
	if((iButton & IN_USE) && !(iOldButton & IN_USE))
	{
		if(g_boomer[id])
		{
			if((get_gametime() - g_boomer_last_vomit[id]) < 20.0)
				return FMRES_IGNORED;
			
			g_boomer_last_vomit[id] = get_gametime();
			
			new iTarget;
			new iBody;
			new const iDistance = 500;
			new iOrigin[3];
			new iAimOrigin[3];
			new iVelocityVector[3];
			
			get_user_aiming(id, iTarget, iBody, iDistance);
			
			get_user_origin(id, iOrigin);
			get_user_origin(id, iAimOrigin, 2);
			
			iVelocityVector[0] = iAimOrigin[0] - iOrigin[0];
			iVelocityVector[1] = iAimOrigin[1] - iOrigin[1];
			iVelocityVector[2] = iAimOrigin[2] - iOrigin[2];
			
			new const iLenght = fn_SQRT(iVelocityVector[0] * iVelocityVector[0] + iVelocityVector[1] * iVelocityVector[1] + iVelocityVector[2] * iVelocityVector[2]);
			
			iVelocityVector[0] = (iVelocityVector[0] * 10) / iLenght;
			iVelocityVector[1] = (iVelocityVector[1] * 10) / iLenght;
			iVelocityVector[2] = (iVelocityVector[2] * 10) / iLenght;
			
			new iArgs[8];
			
			iArgs[0] = iOrigin[0];
			iArgs[1] = iOrigin[1];
			iArgs[2] = iOrigin[2];
			iArgs[3] = iVelocityVector[0];
			iArgs[4] = iVelocityVector[1];
			iArgs[5] = iVelocityVector[2];
			
			set_task(0.1, "fn_CreateSprite", 0, iArgs, 8, "a", 3);
			
			emit_sound(id, CHAN_STREAM, g_boomer_vomit_sounds[random_num(0, 2)], 1.0, ATTN_NORM, 0, PITCH_HIGH);
			
			message_begin(MSG_ONE_UNRELIABLE, g_message_screenshake, _, id);
			write_short(UNIT_SECOND * 14);
			write_short(UNIT_SECOND * 4);
			write_short(UNIT_SECOND * 14);
			message_end();
			
			g_nomove[id] = 1;
			
			set_task(0.7, "fn_MoveOn", id);
			
			ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
			
			if(is_valid_ent(iTarget) && is_user_alive(iTarget) && get_entity_distance(id, iTarget) <= iDistance)
			{
				if(!g_zombie[iTarget])
				{
					message_begin(MSG_ONE_UNRELIABLE, g_message_screenfade, _, iTarget);
					write_short(UNIT_SECOND * 6);
					write_short(UNIT_SECOND * 6);
					write_short(0x0000);
					write_byte(79);
					write_byte(180);
					write_byte(61);
					write_byte(255);
					message_end();
					
					message_begin(MSG_ONE_UNRELIABLE, g_message_screenshake, _, iTarget);
					write_short(UNIT_SECOND * 14);
					write_short(UNIT_SECOND * 4);
					write_short(UNIT_SECOND * 14);
					message_end();
					
					set_user_rendering(iTarget, kRenderFxGlowShell, 128, 0, 128, kRenderNormal, 25);
					
					fn_EmitSound(iTarget, g_sound_horror, 800.0, 1); // ggg
					
					set_task(6.0, "fn_VictimRemoveGlow", iTarget);
					
					fn_CC(id, MESSAGE_AD);
					set_user_health(id, get_user_health(id) + 100);
					
					++g_boomer_vomit_humans[id];
				}
				else
					++g_boomer_vomit_zombies[id];
			}
			
			fn_CC(id, MESSAGE_AE);
		}
		else if(g_smoker[id])
		{
			if((get_gametime() - g_smoker_last_tong[id]) < 20.0)
				return FMRES_IGNORED;
			
			g_smoker_last_tong[id] = get_gametime();
			
			new iTarget;
			new iBody;
			
			get_user_aiming(id, iTarget, iBody);
			
			if(is_user_alive(iTarget)) 
			{
				if(g_zombie[iTarget])
				{
					g_smoker_tongued[id] = 0;
					g_nomove[id] = 1;
					
					fn_NoTarget(id);
					
					set_task(0.7, "fn_MoveOn", id);
					
					emit_sound(id, CHAN_BODY, g_smoker_miss_sound, 1.0, ATTN_NORM, 0, PITCH_HIGH);
				
					return FMRES_IGNORED;
				}
				
				g_smoker_tongued[id] = iTarget;
				
				++g_smoker_humans[id];
				
				emit_sound(iTarget, CHAN_BODY, g_smoker_hit_sound, 1.0, ATTN_NORM, 0, PITCH_HIGH);
				
				new iArgs[2];
				
				iArgs[0] = id;
				iArgs[1] = iTarget;
				
				g_smoker_victim[iTarget] = 1 + id;
				
				set_task(0.1, "fn_SmokerReelin", id, iArgs, 2, "b");
				fn_DragTarget(iArgs);
				
				fn_EmitSound(iTarget, g_sound_horror, 800.0, 1); // ggg
				
				set_user_rendering(iTarget, kRenderFxGlowShell, 255, 255, 0, kRenderNormal, 25);
				
				g_nomove[iTarget] = 1;
				g_nomove[id] = 1;
				
				ExecuteHamB(Ham_Player_ResetMaxSpeed, iTarget);
			}
			else
			{
				g_smoker_tongued[id] = 0;
				g_nomove[id] = 1;
				
				fn_NoTarget(id);
				
				set_task(0.7, "fn_MoveOn", id);
				
				emit_sound(id, CHAN_BODY, g_smoker_miss_sound, 1.0, ATTN_NORM, 0, PITCH_HIGH);
			}
			
			ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
			
			fn_CC(id, MESSAGE_AF);
		}
		else if(g_tank[id])
		{
			if((get_gametime() - g_tank_last_rock[id]) < 7.0)
				return FMRES_IGNORED;
			
			g_tank_last_rock[id] = get_gametime();
		
			emit_sound(id, CHAN_STREAM, g_tank_rocklaunch_sound, VOL_NORM, ATTN_NORM, 0, PITCH_NORM);
			
			new Float:vecOrigin[3];
			new Float:vecVelocity[3];
			new Float:vecAngle[3];
			
			entity_get_vector(id, EV_VEC_origin, vecOrigin);
			entity_get_vector(id, EV_VEC_v_angle, vecAngle);
			
			new iEnt = create_entity("info_target");
			
			entity_set_string(iEnt, EV_SZ_classname, "rock_ent");
			entity_set_model(iEnt, g_tank_rock_mdl);
			entity_set_size(iEnt, Float:{-3.5, -3.5, -3.5}, Float:{3.5, 3.5, 3.5});
			
			entity_set_origin(iEnt, vecOrigin);
			entity_set_vector(iEnt, EV_VEC_angles, vecAngle);
			entity_set_int(iEnt, EV_INT_solid, 2);
			
			entity_set_int(iEnt, EV_INT_rendermode, 5);
			entity_set_float(iEnt, EV_FL_renderamt, 200.0);
			entity_set_float(iEnt, EV_FL_scale, 1.00);
			
			entity_set_int(iEnt, EV_INT_movetype, 5);
			entity_set_edict(iEnt, EV_ENT_owner, id);
			
			velocity_by_aim(id, 2500, vecVelocity);
			entity_set_vector(iEnt, EV_VEC_velocity, vecVelocity);
			
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
			write_byte(TE_BEAMFOLLOW);
			write_short(iEnt);
			write_short(g_tank_trail_spr);
			write_byte(10);
			write_byte(10);
			write_byte(255);
			write_byte(0);
			write_byte(0);
			write_byte(200);
			message_end();
			
			if(g_zp_id[id] == 1)
			{
				new i;
				for(i = 1; i < 10; ++i)
				{
					iEnt = create_entity("info_target");
					
					entity_set_string(iEnt, EV_SZ_classname, "rock_ent");
					entity_set_model(iEnt, g_tank_rock_mdl);
					entity_set_size(iEnt, Float:{-3.5, -3.5, -3.5}, Float:{3.5, 3.5, 3.5});
					
					entity_set_origin(iEnt, vecOrigin);
					entity_set_vector(iEnt, EV_VEC_angles, vecAngle);
					entity_set_int(iEnt, EV_INT_solid, 2);
					
					entity_set_int(iEnt, EV_INT_rendermode, 5);
					entity_set_float(iEnt, EV_FL_renderamt, 200.0);
					entity_set_float(iEnt, EV_FL_scale, 1.00);
					
					entity_set_int(iEnt, EV_INT_movetype, 5);
					entity_set_edict(iEnt, EV_ENT_owner, id);
					
					velocity_by_aim(id, 2500, vecVelocity);
					
					vecVelocity[0] += random_num(5, 15) * i;
					
					entity_set_vector(iEnt, EV_VEC_velocity, vecVelocity);
					
					message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
					write_byte(TE_BEAMFOLLOW);
					write_short(iEnt);
					write_short(g_tank_trail_spr);
					write_byte(10);
					write_byte(10);
					write_byte(255);
					write_byte(0);
					write_byte(0);
					write_byte(200);
					message_end();
				}
			}
		}
	}
	else if(g_hunter[id] && (iButton & IN_DUCK) && (iButton & IN_JUMP))
	{
		if((get_gametime() - g_hunter_lj_last_time[id]) < 7.0)
			return FMRES_IGNORED;
		
		if(!(entity_get_int(id, EV_INT_flags) & FL_ONGROUND))
			return FMRES_IGNORED;
		
		g_hunter_lj_last_time[id] = get_gametime();
		
		emit_sound(id, CHAN_BODY, g_hunter_jump, 1.0, ATTN_NORM, 0, PITCH_HIGH);
		
		new Float:vecVelocity[3];
		
		velocity_by_aim(id, 1500, vecVelocity);
		vecVelocity[2] = 200.0;
		entity_set_vector(id, EV_VEC_velocity, vecVelocity);
	}
	else if(g_tank[id] && (iButton & IN_ATTACK))
	{
		iButton &= ~IN_ATTACK;
		iButton |= IN_ATTACK2;
		
		set_uc(handle, UC_Buttons, iButton);
		
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}

public fw_EmitSound(id, channel, const sample[], Float:volume, Float:attn, flags, pitch)
{
	if(equal(sample[0], "hostage", 7) || !is_user_valid_connected(id) || equal(sample[10], "fall", 4))
		return FMRES_SUPERCEDE;
	
	if(!g_zombie[id])
		return FMRES_IGNORED;
	
	if(equal(sample[7], "bhit", 4))
	{
		emit_sound(id, channel, g_sound_pain[random_num(0, charsmax(g_sound_pain))], volume, attn, flags, pitch);
		return FMRES_SUPERCEDE;
	}
	
	if(equal(sample[8], "kni", 3))
	{
		if(equal(sample[14], "sla", 3))
		{
			emit_sound(id, channel, g_sound_slash[random_num(0, charsmax(g_sound_slash))], volume, attn, flags, pitch);
			return FMRES_SUPERCEDE;
		}
		
		if(equal(sample[14], "hit", 3)) // hit
		{
			if(equal(sample[17], "w", 1)) emit_sound(id, channel, g_sound_slash[random_num(0, charsmax(g_sound_slash))], volume, attn, flags, pitch);
			else emit_sound(id, channel, g_sound_knife_attack, volume, attn, flags, pitch);
			
			return FMRES_SUPERCEDE;
		}
		
		if(equal(sample[14], "sta", 3)) // stab
		{
			emit_sound(id, channel, g_sound_slash[random_num(0, charsmax(g_sound_slash))], volume, attn, flags, pitch);
			return FMRES_SUPERCEDE;
		}
	}
	
	if(equal(sample[7], "die", 3) || equal(sample[7], "dea", 3))
		return FMRES_SUPERCEDE;
	
	return FMRES_IGNORED;
}

public fw_SetModel(entity, const model[])
{
	if(strlen(model) < 8)
		return FMRES_IGNORED;
	
	if(model[7] != 'w' || model[8] != '_')
		return FMRES_IGNORED;
	
	static Float:fDamageTime;
	fDamageTime = entity_get_float(entity, EV_FL_dmgtime);
	
	if(fDamageTime == 0.0)
		return FMRES_IGNORED;
	
	if(model[9] == 'h' && model[10] == 'e')
	{
		fm_set_rendering(entity, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 16);
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
		write_byte(TE_BEAMFOLLOW);
		write_short(entity);
		write_short(g_sprite_laserbeam);
		write_byte(5);
		write_byte(1);
		write_byte(255);
		write_byte(0);
		write_byte(0);
		write_byte(255);
		message_end();
		
		set_task(1.0, "fn_EffectPipeSound", entity, _, _, "b");
		
		entity_set_int(entity, EV_INT_flTimeStepSound, NADE_TYPE_PIPE);
		
		engfunc(EngFunc_SetModel, entity, g_model_wgrenade_pipe);
		
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}

public fw_Think(entity)
{
	if(!is_valid_ent(entity))
		return HAM_IGNORED;
	
	static sClassName[32];
	entity_get_string(entity, EV_SZ_classname, sClassName, charsmax(sClassName));
	
	if(equal(sClassName, "grenade_pipe"))
	{
		static i;
		static Float:vecVelocity[3];
		static Float:vecEntOrigin[3];
		static Float:fDistance;
		static Float:vecOrigin[3];
		
		entity_get_vector(entity, EV_VEC_origin, vecEntOrigin);
		
		for(i = 1; i <= g_maxplayers; ++i) 
		{
			if(is_user_valid_alive(i) && g_zombie[i] && !g_boomer[i] && !g_smoker[i] && !g_hunter[i] && !g_tank[i] && !g_witch[i])
			{
				entity_get_vector(i, EV_VEC_origin, vecOrigin);
				
				fDistance = get_distance_f(vecEntOrigin, vecOrigin);

				if(fDistance >= 400.0)
					continue;

				if(fDistance > 1)
				{
					static Float:fTime;
					fTime = fDistance / 400.0;

					vecVelocity[0] = (vecEntOrigin[0] - vecOrigin[0]) / fTime;
					vecVelocity[1] = (vecEntOrigin[1] - vecOrigin[1]) / fTime;
					vecVelocity[2] = (vecEntOrigin[2] - vecOrigin[2]) / fTime;
				}
				else
				{
					vecVelocity[0] = 0.0;
					vecVelocity[1] = 0.0;
					vecVelocity[2] = 0.0;
				}

				entity_set_vector(i, EV_VEC_velocity, vecVelocity);
			}
		}
		
		entity_set_float(entity, EV_FL_nextthink, get_gametime() + 0.1);
	}
	
	return HAM_IGNORED;
}

public fw_Touch(zone, id)
{
	if(!pev_valid(zone) || !is_user_connected(id))
		return FMRES_IGNORED;

	static sClassName[33];
	pev(id, pev_classname, sClassName, 32);
	
	if(!equal(sClassName, "player"))
		return FMRES_IGNORED;
	
	pev(zone, pev_classname, sClassName, 32);
	if(!equal(sClassName, "block_zombie"))
		return FMRES_IGNORED;
	
	if(!g_allowed_human[id])
		return FMRES_IGNORED;
	
	static iHull;
	iHull = (get_entity_flags(id) & FL_DUCKING) ? HULL_HEAD : HULL_HUMAN;
	
	new i;
	for(i = 1; i <= 10; ++i)
	{
		++g_human_unq;
		
		if(g_human_unq >= 4)
			g_human_unq = 0;
		
		new Float:fStupidCompiler[3];
		
		switch(g_human_unq)
		{
			case 0: fStupidCompiler = Float:{-913.220397, -1277.029418, -90.053756};
			case 1: fStupidCompiler = Float:{-792.134338, -1275.539184, -90.053756};
			case 2: fStupidCompiler = Float:{-663.906188, -1275.465087, -90.053756};
			case 3: fStupidCompiler = Float:{-544.670471, -1272.675170, -90.053756};
		}
		
		if(is_hull_vacant(fStupidCompiler, iHull))
		{
			entity_set_vector(id, EV_VEC_velocity, Float:{0.0, 0.0, 0.0});
			set_pev(id, pev_origin, g_pos_safe[g_human_unq]);
			
			strip_user_weapons(id);
			
			fn_CC(0, MESSAGE_BS, g_playername[id]);
			fn_CC(id, MESSAGE_BR);
			
			++g_in_refuge;
			
			break;
		}
	}
	
	new iHumansAlive = 0;
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		if(g_allowed_human[i] && is_user_alive(i))
			++iHumansAlive;
	}
	
	if(g_in_refuge == iHumansAlive)
	{
		client_cmd(0, "spk zombie_plague/tcs_win_zombies_4.wav");
		
		fn_CC(0, "!g[TORNEO L4D]!y Guardando estadisticas del equipo");
		
		fn_SaveAll();
		fn_SaveTeam(id);
	}
	
	return FMRES_IGNORED;
}