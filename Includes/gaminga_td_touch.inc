public td_kmid(const monster, const ent) {
	if(!isMonster(monster) || !is_valid_ent(ent))
		return FMRES_IGNORED;
	
	if(isEggMonster(monster))
		return FMRES_IGNORED;
	
	static sText[18];	
	entity_get_string(ent, EV_SZ_classname, sText, charsmax(sText));
	
	if(sText[0] == 'f' && sText[5] == 'w') {
		static iTrack;
		iTrack = entity_get_int(monster, MONSTER_TRACK);
		
		static Float:vecOrigin[3];
		static Float:vecMonsterOrigin[3];
		static iTarget;
		static Float:fVelocity;
		
		fVelocity = entity_get_float(monster, MONSTER_SPEED);
		
		formatex(sText, charsmax(sText), "track%d", (iTrack + 1));
		
		iTarget = find_ent_by_tname(-1, sText);
		
		if(!is_valid_ent(iTarget))
			iTarget = find_ent_by_tname(-1, "end");
		
		entity_get_vector(iTarget, EV_VEC_origin, vecOrigin);
		entity_get_vector(monster, EV_VEC_origin, vecMonsterOrigin);
		
		if(iTrack == 5) {
			vecMonsterOrigin[2] += 10.0;
			entity_set_vector(monster, EV_VEC_origin, vecMonsterOrigin);
		}
		
		entitySetAim(monster, vecMonsterOrigin, vecOrigin, fVelocity);
		
		entity_set_int(monster, MONSTER_TRACK, (iTrack + 1));
	} else if(isMonster(ent)) {
		__damageTower(monster, ent);
	} else {
		__touchSomething(sText, monster, ent);
	}
	
	return FMRES_IGNORED;
}

public td_orange(const monster, const ent) {
	if(!isMonster(monster) || !is_valid_ent(ent))
		return FMRES_IGNORED;
	
	if(isEggMonster(monster))
		return FMRES_IGNORED;
	
	static sText[18];	
	entity_get_string(ent, EV_SZ_classname, sText, charsmax(sText));
	
	if(sText[0] == 'f' && sText[5] == 'w') {
		static iTrack;
		iTrack = entity_get_int(monster, MONSTER_TRACK);
		
		static Float:vecOrigin[3];
		static Float:vecMonsterOrigin[3];
		static iTarget;
		static Float:fVelocity;
		
		fVelocity = entity_get_float(monster, MONSTER_SPEED);
		
		formatex(sText, charsmax(sText), "track%d", (iTrack + 1));
		
		iTarget = find_ent_by_tname(-1, sText);
		
		if(!is_valid_ent(iTarget))
			iTarget = find_ent_by_tname(-1, "end");
		
		entity_get_vector(iTarget, EV_VEC_origin, vecOrigin);
		entity_get_vector(monster, EV_VEC_origin, vecMonsterOrigin);
		
		switch(iTrack) {
			case 1: {
				vecMonsterOrigin[1] -= 50.0;
				vecMonsterOrigin[2] += 10.0;
				entity_set_vector(monster, EV_VEC_origin, vecMonsterOrigin);
			}
			case 2: {
				vecMonsterOrigin[2] -= 5.0;
				entity_set_vector(monster, EV_VEC_origin, vecMonsterOrigin);
			}
			case 3: {
				vecMonsterOrigin[1] += 65.0;
				vecMonsterOrigin[2] += 25.0;
				entity_set_vector(monster, EV_VEC_origin, vecMonsterOrigin);
			}
			case 4: {
				vecMonsterOrigin[1] += 90.0;
				vecMonsterOrigin[2] -= 17.0;
				entity_set_vector(monster, EV_VEC_origin, vecMonsterOrigin);
			}
		}
		
		entitySetAim(monster, vecMonsterOrigin, vecOrigin, fVelocity);
		
		entity_set_int(monster, MONSTER_TRACK, (iTrack + 1));
	} else if(isMonster(ent)) {
		__damageTower(monster, ent);
	} else {
		__touchSomething(sText, monster, ent);
	}
	
	return FMRES_IGNORED;
}

public fw_TouchMonster_Post(const monster, const ent) {
	if(!isMonster(monster) || !is_valid_ent(ent))
		return FMRES_IGNORED;
	
	if(isEggMonster(monster))
		return FMRES_IGNORED;
	
	static sText[18];	
	entity_get_string(ent, EV_SZ_classname, sText, charsmax(sText));
	
	if(sText[0] == 'f' && sText[5] == 'w') {
		static iTrack;
		iTrack = entity_get_int(monster, MONSTER_TRACK);
		
		static Float:vecOrigin[3];
		static Float:vecMonsterOrigin[3];
		static iTarget;
		
		formatex(sText, charsmax(sText), "track%d", (iTrack + 1));
		
		iTarget = find_ent_by_tname(-1, sText);
		
		if(!is_valid_ent(iTarget)) {
			iTarget = find_ent_by_tname(-1, (iTrack < 100) ? "end" : "end1");
		}
		
		entity_get_vector(iTarget, EV_VEC_origin, vecOrigin);
		entity_get_vector(monster, EV_VEC_origin, vecMonsterOrigin);
		
		static Float:fVelocity;
		fVelocity = entity_get_float(monster, MONSTER_SPEED);
		
		entitySetAim(monster, vecMonsterOrigin, vecOrigin, fVelocity);
		
		entity_set_int(monster, MONSTER_TRACK, (iTrack + 1));
	} else if(isMonster(ent)) {
		__damageTower(monster, ent);
	} else {
		__touchSomething(sText, monster, ent);
	}
	
	return FMRES_IGNORED;
}

public __damageTower(const monster, const ent) {
	static iMonster;
	iMonster = (entity_get_int(monster, EV_INT_sequence) == 76) ? ent : monster;
	
	if(entity_get_int(iMonster, MONSTER_TRACK) == 1) {
		return;
	}
	
	if(isSpecialMonster(monster)) {
		__explodeBoomer(monster);
		return;
	}
	
	static iTeam;
	iTeam = entity_get_int(iMonster, EV_INT_team);
	
	entity_set_vector(iMonster, EV_VEC_origin, g_VecMonsterTowerOrigin[iTeam]);
	
	entity_set_int(iMonster, MONSTER_TRACK, 1);
	
	entity_set_int(iMonster, EV_INT_sequence, 76);
	entity_set_float(iMonster, EV_FL_animtime, 2.0);
	
	entity_set_int(iMonster, EV_INT_gamestate, 1);
	
	entity_set_vector(iMonster, EV_VEC_velocity, Float:{0.0, 0.0, 0.0});
	
	emit_sound(iMonster, CHAN_BODY, MONSTER_SOUNDS_CLAW[random_num(0, charsmax(MONSTER_SOUNDS_CLAW))], 1.0, ATTN_NORM, 0, PITCH_NORM);
	
	entity_set_int(iMonster, MONSTER_TARGET, 1337);
	
	static iDamage;
	iDamage = 5;
	
	if(DIFFICULTIES_VALUES[g_Difficulty][difficultyDamageTower])
		iDamage = iDamage + ((iDamage * DIFFICULTIES_VALUES[g_Difficulty][difficultyDamageTower]) / 100);
	
	g_TowerHealth -= iDamage;
	
	set_task(1.0, "damageTower", TASK_DAMAGE_TOWER + iMonster);
}

public __touchSomething(const sText[], const monster, const ent) {
	if(sText[0] == 'e' && sText[1] == 'n' && sText[2] == 't' && sText[3] == 'W' && sText[4] == 'G' && sText[5] == 'M') {
		zoneTouch(monster, ent);
	} else if((sText[0] == ENT_SENTRY_CLASSNAME[0] && sText[1] == ENT_SENTRY_CLASSNAME[1] && sText[2] == ENT_SENTRY_CLASSNAME[2] && sText[3] == ENT_SENTRY_CLASSNAME[3] && sText[4] == ENT_SENTRY_CLASSNAME[4] && sText[5] == ENT_SENTRY_CLASSNAME[5] &&
	sText[6] == ENT_SENTRY_CLASSNAME[6] && sText[7] == ENT_SENTRY_CLASSNAME[7] && sText[8] == ENT_SENTRY_CLASSNAME[8]) ||
	(sText[0] == ENT_SENTRY_BASE_CLASSNAME[0] && sText[1] == ENT_SENTRY_BASE_CLASSNAME[1] && sText[2] == ENT_SENTRY_BASE_CLASSNAME[2] && sText[3] == ENT_SENTRY_BASE_CLASSNAME[3] && sText[4] == ENT_SENTRY_BASE_CLASSNAME[4] &&
	sText[5] == ENT_SENTRY_BASE_CLASSNAME[5] && sText[6] == ENT_SENTRY_BASE_CLASSNAME[6] && sText[7] == ENT_SENTRY_BASE_CLASSNAME[7] && sText[8] == ENT_SENTRY_BASE_CLASSNAME[8] && sText[9] == ENT_SENTRY_BASE_CLASSNAME[9] &&
	sText[10] == ENT_SENTRY_BASE_CLASSNAME[10] && sText[11] == ENT_SENTRY_BASE_CLASSNAME[11] && sText[12] == ENT_SENTRY_BASE_CLASSNAME[12] && sText[13] == ENT_SENTRY_BASE_CLASSNAME[13] && sText[14] == ENT_SENTRY_BASE_CLASSNAME[14] &&
	sText[15] == ENT_SENTRY_BASE_CLASSNAME[15] && sText[16] == ENT_SENTRY_BASE_CLASSNAME[16])) {
		static iEnt;
		iEnt = entity_get_edict(ent, SENTRY_ENT_BASE);
		
		if(iEnt) {
			remove_entity(iEnt);
		} else {
			iEnt = entity_get_edict(ent, BASE_ENT_SENTRY);
			
			if(iEnt) {
				remove_entity(iEnt);
			}
		}
		
		remove_entity(ent);
		
		--g_SentryCount;
		
		set_task(0.1, "backToTrack", monster);
	}
}