/* ========================================
======== FORWARDS - HAMSANDWICH ===========
======================================== */

public fw_PlayerSpawn_Post(id)
{
	if(!is_user_alive(id))
		return;
	
	if(!fn_GetTeam(id))
		return;
	
	remove_task(id + TASK_SPAWN);
	remove_task(id + TASK_MODEL);
	remove_task(id + TASK_AURA);
	remove_task(id + TASK_SOUND);
	remove_task(id + TASK_ADRENALINA);
	
	set_task(0.4, "fn_HideHUDs_ClearWeapons", id + TASK_SPAWN);
	
	set_user_rendering(id);
	
	new iTeam;
	iTeam = fn_GetTeam(id);
	
	fn_ResetVars(id, 0);
	
	if(g_zp_id[id] == get_pcvar_num(g_pCVAR_human[0]) || g_zp_id[id] == get_pcvar_num(g_pCVAR_human[1]) || g_zp_id[id] == get_pcvar_num(g_pCVAR_human[2]) || g_zp_id[id] == get_pcvar_num(g_pCVAR_human[3]) || (g_zp_id[id] == 1 && iTeam == FM_CS_TEAM_CT))
		g_allowed_human[id] = 1;
	
	if(!g_allowed_human[id]) // Zombies
	{
		set_user_health(id, 200);
		set_user_gravity(id, 1.0);
		set_user_armor(id, 0);
		
		g_zombie[id] = 1;
		
		if(iTeam != FM_CS_TEAM_T)
			fn_SetTeam(id, FM_CS_TEAM_T);
		
		if(g_respawn_as_zombie[id])
		{
			fn_SetSpecialZombie(id, g_respawn_as_zombie[id]);
			
			remove_task(id + TASK_SOUND);
			switch(g_respawn_as_zombie[id])
			{
				case ZOMBIE_BOOMER: set_task(random_float(4.0, 5.0), "fn_PlayIdleSoundBOOMER", id + TASK_SOUND, _, _, "b");
				case ZOMBIE_SMOKER: set_task(random_float(4.0, 5.0), "fn_PlayIdleSoundSMOKER", id + TASK_SOUND, _, _, "b");
				case ZOMBIE_HUNTER: set_task(random_float(4.0, 5.0), "fn_PlayIdleSoundHUNTER", id + TASK_SOUND, _, _, "b");
				case ZOMBIE_WITCH: set_task(random_float(4.0, 5.0), "fn_PlayIdleSoundWITCH", id + TASK_SOUND, _, _, "b");
			}
			
			static iHull;
			iHull = (get_entity_flags(id) & FL_DUCKING) ? HULL_HEAD : HULL_HUMAN;
			
			if(g_respawn_as_zombie[id] != ZOMBIE_TANK && g_respawn_as_zombie[id] != ZOMBIE_WITCH)
			{
				new i;
				for(i = 1; i <= 20; ++i)
				{
					if(g_origin_zs_count[1] + (i - 1) >= 128)
						break;
					
					if(g_origin_zs[g_origin_zs_count[1] + (i - 1)][0])
					{
						if(is_hull_vacant(g_origin_zs[g_origin_zs_count[1] + (i - 1)], iHull))
						{
							entity_set_vector(id, EV_VEC_velocity, Float:{0.0, 0.0, 0.0});
							entity_set_vector(id, EV_VEC_origin, g_origin_zs[g_origin_zs_count[1] + (i - 1)]);
							
							g_origin_zs[g_origin_zs_count[1] + (i - 1)] = Float:{0.0, 0.0, 0.0};
							
							++g_origin_zs_count[1];
							
							if(!is_player_stuck(id))
								break;
						}
					}
				}
			}
			else
			{
				if(g_origin_tw[0] && is_hull_vacant(g_origin_tw, iHull))
				{
					entity_set_vector(id, EV_VEC_velocity, Float:{0.0, 0.0, 0.0});
					entity_set_vector(id, EV_VEC_origin, g_origin_tw);
					
					g_origin_tw = Float:{0.0, 0.0, 0.0};
				}
			}
			
			g_respawn_as_zombie[id] = 0;
		}
		else
		{
			g_zombie_model[id] = random_num(0, MAX_MODELS_ZOMBIES);
			copy(g_playermodel[id], 31, g_models_zombies[g_zombie_model[id]]);
		}
		
		set_task(5.0 * MODELS_DELAY, "fn_ModelUpdate", id + TASK_MODEL);
		
		fn_TurnLightOff(id);
	}
	else // Humanos
	{
		set_user_health(id, 15000);
		set_user_gravity(id, 1.0);
		
		if(iTeam != FM_CS_TEAM_CT)
			fn_SetTeam(id, FM_CS_TEAM_CT);
		
		++g_human_unq;
		
		if(g_human_unq >= 4)
			g_human_unq = 0;
		
		copy(g_playermodel[id], 31, g_models_humans[g_human_unq]);
		
		set_task(5.0 * MODELS_DELAY, "fn_ModelUpdate", id + TASK_MODEL);
	}
	
	if(g_smoker_tongued[id])
		fn_TongEnd(id);
	
	ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
}

public fw_ResetMaxSpeed_Post(id)
{
	if(!is_user_alive(id))
		return;
	
	fn_SetSpeed(id);
}

public fw_PlayerKilled(victim, attacker, shouldgib)
{
	remove_task(victim + TASK_AURA);
	remove_task(victim + TASK_SOUND);
	
	if(g_zombie[victim])
	{
		if(is_user_valid_alive(attacker))
		{
			++g_zombies_kill;
			
			if(g_boomer[victim] || g_smoker[victim] || g_hunter[victim] || g_tank[victim] || g_witch[victim])
				++g_zombies_specials_kill;
			
			if((1 << g_currentweapon[attacker]) & SECONDARY_WEAPONS_BITSUM)
			{
				++g_zombies_kill_secondary;
				
				if(get_pdata_int(victim, 75) == HIT_HEAD)
					++g_zombies_kill_secondary_head;
			}
			
			if(get_pdata_int(victim, 75) == HIT_HEAD)
				++g_kill_zombies_head;
		}
	}
	
	if(g_boomer[victim])
	{
		new i;
		
		emit_sound(victim, CHAN_STREAM, g_boomer_explode_sounds[random_num(0, 2)], 1.0, ATTN_NORM, 0, PITCH_HIGH);
		
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_valid_ent(i) || !is_user_alive(i) || get_entity_distance(victim, i) > 200)
				continue;
			
			if(!g_zombie[i])
			{
				message_begin(MSG_ONE_UNRELIABLE, g_message_screenfade, _, i);
				write_short(UNIT_SECOND * 4);
				write_short(UNIT_SECOND * 4);
				write_short(0x0000);
				write_byte(79);
				write_byte(180);
				write_byte(61);
				write_byte(255);
				message_end();
				
				set_user_rendering(i, kRenderFxGlowShell, 79, 180, 61, kRenderNormal, 25);
				
				set_task(4.0, "fn_VictimRemoveGlow", i);
				
				++g_boomer_vomit_humans[victim];
			}
			else
				++g_boomer_vomit_zombies[victim];
		}
		
		++g_zombies_specials_kill2[ZOMBIE_BOOMER];
	}
	else if(g_smoker[victim])
	{
		fn_SmokerBeamRemove(victim);
		
		if(g_smoker_tongued[victim])
			fn_TongEnd(victim);
		
		fn_SmokySmoker(victim);
		
		new i;
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_user_connected(i))
				continue;
			
			if(g_zombie[i])
				continue;
			
			if(g_smoker_victim[i] - victim == 1)
			{
				g_nomove[i] = 0;
				
				set_user_rendering(i);
				
				ExecuteHamB(Ham_Player_ResetMaxSpeed, i);
			}
		}
		
		++g_zombies_specials_kill2[ZOMBIE_SMOKER];
	}
	else if(g_witch[victim])
	{
		remove_task(victim + TASK_AURA);
		remove_task(TASK_REPEAT_SOUND);
		
		client_cmd(0, "mp3 stop; stopsound");
		
		++g_zombies_specials_kill2[ZOMBIE_WITCH];
	}
	else if(g_tank[victim])
	{
		remove_task(TASK_REPEAT_SOUND);
		
		client_cmd(0, "mp3 stop; stopsound");
		
		++g_zombies_specials_kill2[ZOMBIE_TANK];
	}
	else if(g_hunter[victim])
		++g_zombies_specials_kill2[ZOMBIE_HUNTER];
	
	if(victim == attacker || !is_user_valid_connected(attacker))
		return;
	
	if(g_zombie[victim])
		++g_kill_zombies[attacker];
	else
		++g_kill_humans[attacker];
	
	if(!g_zombie[attacker] && g_currentweapon[attacker] == CSW_KNIFE)
		++g_kill_knife;
	
	if(!g_zombie[victim])
	{
		new i;
		new iHumansDead = 0;
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_user_connected(i))
				continue;
			
			if(g_allowed_human[i] && is_user_alive(i))
				iHumansDead = 1;
			
			if(g_smoker[i] && g_smoker_tongued[i])
			{
				g_smoker_tongued[i] = 0;
				
				set_task(0.2, "fn_MoveOn", i);
			}
		}
		
		if(!iHumansDead)
		{
			client_cmd(0, "spk zombie_plague/tcs_win_humans_4.wav");
			fn_SaveAll();
		}
	}
}

public fw_PlayerKilled_Post(victim, attacker, shouldgib)
{
	if(g_zombie[victim] && g_allowed_respawn) // Humanos no reviven!
		set_task(1.0, "fn_RespawnPlayer", victim + TASK_SPAWN);
}

public fw_TakeDamage(victim, inflictor, attacker, Float:damage, damage_type)
{
	if(victim == attacker || !is_user_valid_connected(attacker))
		return HAM_IGNORED;
	
	if(g_zombie[attacker] && g_zombie[victim])
		return HAM_IGNORED;
	
	static iDamage;
	iDamage = floatround(damage);
	
	if(!g_zombie[attacker])
	{
		g_damage_zombies[attacker] += iDamage;
		
		if(g_tank[victim])
			g_damage_tank[attacker] += iDamage;
		
		g_damage += iDamage;
		
		if(g_currentweapon[attacker] == CSW_KNIFE)
			g_damage_knife += iDamage;
	}
	else if(g_zombie[attacker] && !g_boomer[attacker] && !g_smoker[attacker])
	{
		g_damage_humans[attacker] += iDamage;
		
		if(g_hunter[attacker])
			g_damage_hunter_humans[attacker] += iDamage;
		else if(g_witch[attacker])
			g_damage_witch_humans[attacker] += iDamage;
		else if(g_tank[attacker])
			g_damage_tank_humans[attacker] += iDamage;
	}
	
	if(g_hunter[attacker])
	{
		damage *= 2.0;
		SetHamParamFloat(4, damage);
		
		return HAM_IGNORED;
	}
	else if(g_tank[attacker])
	{
		damage *= 3.0;
		SetHamParamFloat(4, damage);
		
		static Float:vecAttackerOrigin[3];
		static Float:vecVictimOrigin[3];
		static Float:vecVelocity[3];
		
		entity_get_vector(attacker, EV_VEC_origin, vecAttackerOrigin);
		entity_get_vector(victim, EV_VEC_origin, vecVictimOrigin);
		
		xs_vec_sub(vecVictimOrigin, vecAttackerOrigin, vecVictimOrigin);
		xs_vec_normalize(vecVictimOrigin, vecVictimOrigin);
		
		get_user_velocity(victim, vecVelocity);
		
		xs_vec_mul_scalar(vecVictimOrigin, 1600.0, vecVictimOrigin);
		xs_vec_add(vecVelocity, vecVictimOrigin, vecVelocity);
		
		set_user_velocity(victim, vecVelocity);
		
		return HAM_IGNORED;
	}
	else if(g_witch[attacker])
	{
		damage = 25.0;
		SetHamParamFloat(4, damage);
		
		return HAM_IGNORED;
	}
	else if(g_witch[victim] && !g_witch_angry[victim])
	{
		g_witch_angry[victim] = 1;
		ExecuteHamB(Ham_Player_ResetMaxSpeed, victim);
		
		fn_EmitSound(0, g_witch_sound_angry, 0.0, 0);
		
		remove_task(TASK_REPEAT_SOUND);
		set_task(30.5, "fn_RepeatWitchSound", TASK_REPEAT_SOUND);
	}
	
	if(g_allowed_human[victim] && g_human_coold[victim] != 2)
	{
		static iHealth;
		iHealth = get_user_health(victim);
		
		if(iHealth < 2000)
		{
			if(!g_human_coold[victim])
			{
				g_human_coold[victim] = 1;
				set_user_rendering(victim, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 25);
			}
			else if(iHealth < 1000 && g_human_coold[victim] == 1)
			{
				g_human_coold[victim] = 2;
				
				client_cmd(victim, "MP3Volume 0.3");
				client_cmd(victim, "mp3 play ^"%s^"", g_sound_coold);
			}
		}
	}
	
	return HAM_IGNORED;
}

public fw_TakeDamage_Post(victim)
{
	if((!g_zombie[victim] && g_adrenalina[victim]) || (g_boomer[victim] || g_hunter[victim] || g_tank[victim] || g_witch[victim]))
	{
		if(pev_valid(victim) != PDATA_SAFE)
			return;
		
		set_pdata_float(victim, OFFSET_PAINSHOCK, 1.0, OFFSET_LINUX);
	}
}

public fw_ThinkGrenade(entity)
{
	if(!is_valid_ent(entity))
		return HAM_IGNORED;
	
	static Float:fDamageTime;
	static Float:fCurrentTime;
	
	fDamageTime = entity_get_float(entity, EV_FL_dmgtime);
	fCurrentTime = get_gametime();
	
	if(fDamageTime > fCurrentTime)
		return HAM_IGNORED;
	
	if(entity_get_int(entity, EV_INT_flTimeStepSound) == NADE_TYPE_PIPE)
	{
		static iDuration;
		iDuration = entity_get_int(entity, EV_INT_flSwimTime);
		
		if(iDuration > 0)
		{
			static Float:vecOrigin[3];
			entity_get_vector(entity, EV_VEC_origin, vecOrigin);
			
			if(iDuration == 1)
			{
				static iAttacker;
				iAttacker = entity_get_edict(entity, EV_ENT_owner);
				
				if(!is_user_valid_connected(iAttacker))
				{
					engfunc(EngFunc_RemoveEntity, entity);
					return HAM_SUPERCEDE;
				}
				
				// Sprite
				engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, vecOrigin, 0);
				write_byte(TE_EXPLOSION);
				engfunc(EngFunc_WriteCoord, vecOrigin[0]);
				engfunc(EngFunc_WriteCoord, vecOrigin[1]);
				engfunc(EngFunc_WriteCoord, vecOrigin[2] + 5.0);
				write_short(g_sprite_explosion);
				write_byte(50);
				write_byte(35);
				write_byte(0);
				message_end();
				
				emit_sound(entity, CHAN_WEAPON, "misc/molotov_explosion.wav", 1.0, ATTN_NORM, 0, PITCH_NORM);
				
				static iVictim;
				static iCountVictims;
				
				iVictim = -1;
				iCountVictims = 0;
				
				while((iVictim = engfunc(EngFunc_FindEntityInSphere, iVictim, vecOrigin, 200.0)) != 0)
				{
					if(!is_user_valid_alive(iVictim) || !g_zombie[iVictim])
						continue;
					
					if(g_boomer[iVictim] || g_smoker[iVictim] || g_hunter[iVictim] || g_tank[iVictim] || g_witch[iVictim])	
						continue;
					
					ExecuteHam(Ham_TakeDamage, iVictim, iAttacker, iAttacker, 500.0, DMG_BURN);
					
					++iCountVictims;
				}
				
				g_kill_pipe[iAttacker] += iCountVictims;
				g_kill_pipe_group += iCountVictims;
				
				engfunc(EngFunc_RemoveEntity, entity);
				return HAM_SUPERCEDE;
			}
			
			engfunc(EngFunc_MessageBegin, MSG_PAS, SVC_TEMPENTITY, vecOrigin, 0);
			write_byte(TE_DLIGHT);
			engfunc(EngFunc_WriteCoord, vecOrigin[0]);
			engfunc(EngFunc_WriteCoord, vecOrigin[1]);
			engfunc(EngFunc_WriteCoord, vecOrigin[2]);
			write_byte(12);
			write_byte(255);
			write_byte(255);
			write_byte(255);
			write_byte(21);
			write_byte((iDuration < 3) ? 7 : 0);
			message_end();
			
			entity_set_int(entity, EV_INT_flSwimTime, --iDuration);
			entity_set_float(entity, EV_FL_dmgtime, fCurrentTime + 2.0);
		}
		else if((get_entity_flags(entity) & FL_ONGROUND) && fm_get_speed(entity) < 5)
		{
			entity_set_string(entity, EV_SZ_classname, "grenade_pipe");
			
			remove_task(entity);
			
			set_task(0.1, "fn_EffectPipeSound", entity);
			set_task(1.0, "fn_EffectPipeSound", entity);
			
			entity_set_int(entity, EV_INT_flSwimTime, 4);
			
			entity_set_float(entity, EV_FL_dmgtime, fCurrentTime + 0.1);
			entity_set_float(entity, EV_FL_nextthink, fCurrentTime + 0.1);
		}
		else
			entity_set_float(entity, EV_FL_dmgtime, fCurrentTime + 0.5);
	}
	
	return HAM_IGNORED;
}

public fw_TouchWeapon(weapon, id)
{
	if(!is_user_valid_connected(id))
		return HAM_IGNORED;
	
	if(g_zombie[id])
		return HAM_SUPERCEDE;
	
	return HAM_IGNORED;
}

public fw_UseButton(ent, id)
	return HAM_SUPERCEDE;

public fw_Item_Deploy_Post(weapon_ent)
{
	if(!pev_valid(weapon_ent))
		return;
	
	static id;
	id = fn_GetWeaponId(weapon_ent);
	
	if(!pev_valid(id))
		return;
	
	static iWeaponId;
	iWeaponId = cs_get_weapon_id(weapon_ent);
	
	g_currentweapon[id] = iWeaponId;
	
	fn_ReplaceWeaponModels(id, iWeaponId);
	
	if((g_zombie[id] && !((1 << iWeaponId) & ZOMBIE_ALLOWED_WEAPONS_BITSUM)))
	{
		g_currentweapon[id] = CSW_KNIFE;
		engclient_cmd(id, "weapon_knife");
	}
}

public fw_Item_AttachToPlayer(weapon_ent, id)
{
	if(!pev_valid(weapon_ent))
		return;
	
	if(g_zombie[id])
		return;
	
	if(get_pdata_int(weapon_ent, OFFSET_KNOWN, OFFSET_LINUX_WEAPONS)) // Está recargando ?
		return;
	
	set_pdata_int(id, AMMOOFFSET[get_pdata_int(weapon_ent, OFFSET_ID, OFFSET_LINUX_WEAPONS)], 2500, OFFSET_LINUX);
}

public fw_Weapon_Attack_Post(weapon_ent)
{
	if(!pev_valid(weapon_ent))
		return HAM_IGNORED;

	if(pev_valid(weapon_ent) != PDATA_SAFE)
		return -1;
	
	static id;
	id = get_pdata_cbase(weapon_ent, OFFSET_WEAPONOWNER, OFFSET_LINUX_WEAPONS);
	
	if(!pev_valid(id) || !is_user_valid_alive(id) || g_zombie[id])
		return HAM_IGNORED;
	
	++g_bullets;
	
	return HAM_IGNORED;
}

stock is_player_stuck(id)
{
	new Float:origin[3];
	pev( id, pev_origin, origin );

	engfunc( EngFunc_TraceHull, origin, origin, IGNORE_MONSTERS, pev( id, pev_flags ) & FL_DUCKING ? HULL_HEAD : HULL_HUMAN, id, 0 );
	return get_tr2( 0, TR_StartSolid );
}