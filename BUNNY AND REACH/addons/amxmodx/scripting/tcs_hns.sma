#include <amxmodx>
#include <fakemeta_util>
#include <hamsandwich>
#include <engine>
#include <cstrike>
#include <cc>
#include <safemenu>
#include <fun>
#include <cstrike_pdatas>

#define TASK_COUNTDOWN	891249
#define TASK_FROZEN	57163

/*
	
*/

new const PLUGIN_VERSION[] = "v1.0";
new const BNR_PREFIX[] = "!g[BnR]!y ";

new g_MaxUsers;
new g_Message_ScreenFade;
new g_Message_TeamInfo;
new g_Message_StatusText;
new g_CountDown;
new g_fwSpawn;
new g_fwPrecacheSound;
new g_PollVotes[2];
new g_FlasherId;
new g_SPRITE_Trail;
new g_SPRITE_Glass;
new g_SlowDown[33];
new g_CurrentWeapon[33];
new g_Steps[33];
new g_FreezeTime;
new g_EndRound;
new g_FT[33];
new g_Frozen[33];
new Float:g_FrozenGravity[33];
new Float:g_FallDamage;

new const COUNTDOWN_SOUNDS[][] = {"one", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"};

const PDATA_SAFE = 2;
const OFFSET_LINUX_WEAPONS = 4;
const OFFSET_LINUX = 5;
const OFFSET_WEAPONOWNER = 41;
const OFFSET_ID = 43;
const OFFSET_NEXT_PRIMARY_ATTACK = 46;
const OFFSET_NEXT_SECONDARY_ATTACK = 47;
const OFFSET_CSTEAMS = 114;
const OFFSET_PRIMARY_WEAPON = 116;
const OFFSET_CSMENUCODE = 205;

const UNIT_SECOND = (1<<12);
const FFADE_IN = 0x0000;
const FFADE_STAYOUT = 0x0004;

new Ham:Ham_Player_ResetMaxSpeed = Ham_Item_PreFrame;

new const g_SOUND_Grenade_Frost[] = "warcraft3/frostnova.wav";
new const g_SOUND_Grenade_Frost_Break[] = "warcraft3/impalelaunch1.wav";
new const g_SOUND_Grenade_Frost_Player[] = "warcraft3/impalehit.wav";

enum _:teamIds {
	FM_CS_TEAM_UNASSIGNED = 0,
	FM_CS_TEAM_T,
	FM_CS_TEAM_CT,
	FM_CS_TEAM_SPECTATOR
};

new const CS_TEAM_NAMES[][] = {"UNASSIGNED", "TERRORIST", "CT", "SPECTATOR"};

public plugin_precache() {
	new sFile[32];
	new i;
	
	for(i = 0; i < sizeof(COUNTDOWN_SOUNDS); ++i) {
		formatex(sFile, 31, "fvox/%s.wav", COUNTDOWN_SOUNDS[i]);
		precache_sound(sFile);
	}
	
	g_SPRITE_Trail = precache_model("sprites/laserbeam.spr");
	g_SPRITE_Glass = precache_model("models/glassgibs.mdl");
	
	precache_sound(g_SOUND_Grenade_Frost);
	precache_sound(g_SOUND_Grenade_Frost_Break);
	precache_sound(g_SOUND_Grenade_Frost_Player);
	
	g_fwSpawn = register_forward(FM_Spawn, "fw_Spawn");
	g_fwPrecacheSound = register_forward(FM_PrecacheSound, "fw_PrecacheSound");
	
	new iEnt;
	iEnt = create_entity("hostage_entity");
	
	if(is_valid_ent(iEnt)) {
		entity_set_origin(iEnt, Float:{8192.0, 8192.0, 8192.0});
		dllfunc(DLLFunc_Spawn, iEnt);
	}
}

public fw_Spawn(const entity) {
	if(!pev_valid(entity)) {
		return FMRES_IGNORED;
	}
	
	new const REMOVE_ENTS[][] = {
		"func_bomb_target", "info_bomb_target", "info_vip_start", "func_vip_safetyzone", "func_escapezone", "hostage_entity", "monster_scientist", "info_hostage_rescue", "func_hostage_rescue", "env_rain", "env_snow", "env_fog", "func_vehicle", "info_map_parameters", "func_buyzone", "armoury_entity",
		"game_text", "func_tank", "func_tankcontrols", "func_door", "func_door_rotating", "func_breakable"
	};
	
	new i;
	new sClassName[32];
	
	entity_get_string(entity, EV_SZ_classname, sClassName, 31);
	
	for(i = 0; i < 22; ++i) {
		if(equal(sClassName, REMOVE_ENTS[i])) {
			remove_entity(entity);
			return FMRES_SUPERCEDE;
		}
	}
	
	return FMRES_IGNORED;
}

public fw_PrecacheSound(const sound[]) {
	if(equal(sound, "hostage", 7)) {
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}

public plugin_init() {
	new sMapName[64];
	get_mapname(sMapName, 63);
	
	strtolower(sMapName);
	
	if(equal(sMapName, "bnr_taringacs_city") || equal(sMapName, "de_rats")) {
		g_FallDamage = 0.5;
		
		RegisterHam(Ham_TakeDamage, "player", "fw_TakeDamage");
	}
	
	register_plugin("HNS", PLUGIN_VERSION, "KISKE");
	register_cvar("HideNSeek", "4.1", FCVAR_SERVER|FCVAR_SPONLY);
	
	register_event("HLTV", "event__HLTV", "a", "1=0", "2=0");
	register_event("StatusValue", "event__StatusValue", "b", "1>0", "2>0");
	
	register_logevent("logevent__RoundEnd", 2, "1=Round_End");
	
	RegisterHam(Ham_Spawn, "player", "fw_PlayerSpawn__Post", 1);
	RegisterHam(Ham_Killed, "player", "fw_PlayerKilled");
	RegisterHam(Ham_Player_ResetMaxSpeed, "player", "fw_ResetMaxSpeed__Post", 1);
	
	RegisterHam(Ham_Item_Deploy, "weapon_knife", "fw_Item_Deploy_Post", 1);
	RegisterHam(Ham_Item_Deploy, "weapon_deagle", "fw_Item_Deploy_Post", 1);
	RegisterHam(Ham_Item_Deploy, "weapon_hegrenade", "fw_Item_Deploy_Post", 1);
	RegisterHam(Ham_Item_Deploy, "weapon_smokegrenade", "fw_Item_Deploy_Post", 1);
	RegisterHam(Ham_Item_Deploy, "weapon_flashbang", "fw_Item_Deploy_Post", 1);
	RegisterHam(Ham_Item_Deploy, "weapon_scout", "fw_Item_Deploy_Post", 1);
	RegisterHam(Ham_Item_Deploy, "weapon_awp", "fw_Item_Deploy_Post", 1);
	
	register_forward(FM_CmdStart, "fw_CmdStart");
	register_forward(FM_SetModel, "fw_SetModel");
	
	RegisterHam(Ham_Think, "grenade", "fw_ThinkGrenade");
	
	unregister_forward(FM_Spawn, g_fwSpawn);
	unregister_forward(FM_PrecacheSound, g_fwPrecacheSound);
	
	new const BLOCK_COMMANDS[][] = {
		"buy", "buyammo1", "buyammo2", "buyequip", "cl_autobuy", "cl_rebuy", "cl_setautobuy", "cl_setrebuy", "usp", "glock", "deagle", "p228", "elites", "fn57", "m3", "xm1014", "mp5", "tmp", "p90", "mac10", "ump45", "ak47", "galil", "famas", "sg552", "m4a1", "aug", "scout", "awp", "g3sg1",
		"sg550", "m249", "vest", "vesthelm", "flash", "hegren", "sgren", "defuser", "nvgs", "shield", "primammo", "secammo", "km45", "9x19mm", "nighthawk", "228compact", "fiveseven", "12gauge", "autoshotgun", "mp", "c90", "cv47", "defender", "clarion", "krieg552", "bullpup", "magnum",
		"d3au1", "krieg550", "smg", "radio1", "radio2", "coverme", "takepoint", "holdpos", "regroup", "followme", "takingfire", "go", "fallback", "sticktog", "getinpos", "stormfront", "report", "roger", "enemyspot", "needbackup", "sectorclear", "inposition", "reportingin", "getout", "negative",
		"enemydown"
	};
	
	new i;
	for(i = 0; i < sizeof(BLOCK_COMMANDS); ++i) {
		register_clcmd(BLOCK_COMMANDS[i], "clcmd__BlockCommand");
	}
	
	g_Message_ScreenFade = get_user_msgid("ScreenFade");
	g_Message_TeamInfo = get_user_msgid("TeamInfo");
	g_Message_StatusText = get_user_msgid("StatusText");
	
	register_message(g_Message_ScreenFade, "message__ScreenFade");
	register_message(get_user_msgid("Money"), "message__Money");
	
	register_menucmd(register_menuid("#Buy", 1), 511, "menu__CSBuy");
	register_menucmd(register_menuid("BuyPistol", 1), 511, "menu__CSBuy");
	register_menucmd(register_menuid("BuyShotgun", 1), 511, "menu__CSBuy");
	register_menucmd(register_menuid("BuySub", 1), 511, "menu__CSBuy");
	register_menucmd(register_menuid("BuyRifle", 1), 511, "menu__CSBuy");
	register_menucmd(register_menuid("BuyMachine", 1), 511, "menu__CSBuy");
	register_menucmd(register_menuid("BuyItem", 1), 511, "menu__CSBuy");
	register_menucmd(register_menuid("BuyEquip", 1), 511, "menu__CSBuy");
	register_menucmd(-28, 511, "menu__CSBuy");
	register_menucmd(-29, 511, "menu__CSBuy");
	register_menucmd(-30, 511, "menu__CSBuy");
	register_menucmd(-32, 511, "menu__CSBuy");
	register_menucmd(-31, 511, "menu__CSBuy");
	register_menucmd(-33, 511, "menu__CSBuy");
	register_menucmd(-34, 511, "menu__CSBuy");
	
	g_MaxUsers = get_maxplayers();
	
	set_task(60.0, "task__AlltalkPoll");
}

public client_disconnect(id) {
	remove_task(id + TASK_FROZEN);
	
	g_SlowDown[id] = 0;
	g_FT[id] = 0;
	g_Frozen[id] = 0;
}

public client_PreThink(id) {
	if(!is_user_alive(id)) {
		return;
	}
	
	if(g_Steps[id]) {
		entity_set_int(id, EV_INT_flTimeStepSound, 999);
	}
}

public fw_PlayerSpawn__Post(const id) {
	if(!is_user_alive(id) || !getUserTeam(id)) {
		return;
	}
	
	strip_user_weapons(id); // COMPLETAR|PELIGRO - SI SE CAE EL SERVIDOR PONER ESTO EN UN TASK DE 0.2
	set_pdata_int(id, OFFSET_PRIMARY_WEAPON, OFFSET_LINUX);
	
	give_item(id, "weapon_knife");
	
	new iTeam;	
	iTeam = getUserTeam(id);
	
	switch(iTeam) {
		case FM_CS_TEAM_T: {
			g_Steps[id] = 1;
		} case FM_CS_TEAM_CT: {
			g_Steps[id] = 0;
			
			if(g_CountDown) {
				g_FT[id] = 1;
				set_user_velocity(id, Float:{0.0, 0.0, 0.0});
				
				message_begin(MSG_ONE, g_Message_ScreenFade, _, id);
				write_short(UNIT_SECOND);
				write_short(0);
				write_short(FFADE_STAYOUT);
				write_byte(0);
				write_byte(0);
				write_byte(0);
				write_byte(255);
				message_end();
			}
		}
	}
	
	cs_set_user_armor(id, 100, CS_ARMOR_VESTHELM);
	
	ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
}

public fw_TakeDamage(const victim, const inflictor, const attacker, Float:damage, const damage_type) {
	if(damage_type & DMG_FALL) {
		damage *= g_FallDamage
		SetHamParamFloat(4, damage);
	}
	
	return HAM_IGNORED;
}

public fw_PlayerKilled(const victim, const killer, const shouldgib) {
	remove_task(victim + TASK_FROZEN);
	
	set_user_rendering(victim);
	
	g_SlowDown[victim] = 0;
	g_Frozen[victim] = 0;
}

public event__HLTV() {
	g_CountDown = 10;
	g_FreezeTime = 1;
	g_EndRound = 0;
	
	remove_task(TASK_COUNTDOWN);
	set_task(5.0, "task__RemoveFreezeTime", TASK_COUNTDOWN);
}

public task__RemoveFreezeTime() {
	g_FreezeTime = 0;
	
	new i;
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(is_user_alive(i) && getUserTeam(i) == FM_CS_TEAM_T) {
			ExecuteHamB(Ham_Player_ResetMaxSpeed, i);
		}
	}
	
	client_cmd(0, "spk ^"fvox/%s^"", COUNTDOWN_SOUNDS[g_CountDown]);
	
	set_task(1.0, "task__CountDownStart", TASK_COUNTDOWN);
}

public task__CountDownStart() {
	--g_CountDown;
	
	if(!g_CountDown) {
		new i;
		new iRandom;
		
		for(i = 1; i <= g_MaxUsers; ++i) {
			if(!is_user_alive(i)) {
				continue;
			}
			
			if(getUserTeam(i) != FM_CS_TEAM_CT) {
				give_item(i, "weapon_flashbang");
				give_item(i, "weapon_smokegrenade");
				
				iRandom = random_num(1, 100);
				if(iRandom <= 5) {
					give_item(i, "weapon_hegrenade");
					
					colorChat(i, _, "%sRecibiste una !gHE!y con 5%% de chance", BNR_PREFIX);
				}
				
				iRandom = random_num(1, 100);
				if(iRandom <= 5) {
					give_item(i, "weapon_scout");
					
					cs_set_user_bpammo(i, CSW_SCOUT, 0);
					cs_set_weapon_ammo(fm_find_ent_by_owner(-1, "weapon_scout", i), 0);
					
					colorChat(i, _, "%sRecibiste una !gScout!y con 5%% de chance", BNR_PREFIX);
				}
				
				iRandom = random_num(1, 100);
				if(iRandom <= 10) {
					set_user_health(i, 125);
					
					colorChat(i, _, "%sRecibiste !g+25 de vida!y con 10%% de chance", BNR_PREFIX);
				}
				
				continue;
			}
			
			iRandom = random_num(1, 100);
			if(iRandom == 1) {
				give_item(i, "weapon_awp");
				
				cs_set_user_bpammo(i, CSW_AWP, 0);
				cs_set_weapon_ammo(fm_find_ent_by_owner(-1, "weapon_awp", i), 1);
				
				colorChat(i, _, "%sRecibiste una !gAWP!y con 1%% de chance", BNR_PREFIX);
			}
			
			iRandom = random_num(1, 100);
			if(iRandom <= 3) {
				give_item(i, "weapon_deagle");
				
				cs_set_user_bpammo(i, CSW_DEAGLE, 0);
				cs_set_weapon_ammo(fm_find_ent_by_owner(-1, "weapon_deagle", i), 1);
				
				colorChat(i, _, "%sRecibiste una !gDeagle!y con 3%% de chance", BNR_PREFIX);
			}
			
			iRandom = random_num(1, 100);
			if(iRandom <= 5) {
				give_item(i, "weapon_hegrenade");
				
				colorChat(i, _, "%sRecibiste una !gHE!y con 5%% de chance", BNR_PREFIX);
			}
			
			iRandom = random_num(1, 100);
			if(iRandom <= 5) {
				give_item(i, "weapon_smokegrenade");
				
				colorChat(i, _, "%sRecibiste una !gFrost!y con 5%% de chance", BNR_PREFIX);
			}
			
			iRandom = random_num(1, 100);
			if(iRandom <= 5) {
				give_item(i, "weapon_scout");
				
				cs_set_user_bpammo(i, CSW_SCOUT, 0);
				cs_set_weapon_ammo(fm_find_ent_by_owner(-1, "weapon_scout", i), 0);
				
				colorChat(i, _, "%sRecibiste una !gScout!y con 5%% de chance", BNR_PREFIX);
			}
			
			g_FT[i] = 0;
			
			message_begin(MSG_ONE, g_Message_ScreenFade, _, i);
			write_short(UNIT_SECOND);
			write_short(0);
			write_short(FFADE_IN);
			write_byte(0);
			write_byte(0);
			write_byte(0);
			write_byte(255);
			message_end();
			
			ExecuteHamB(Ham_Player_ResetMaxSpeed, i);
		}
		
		return;
	}
	
	client_cmd(0, "spk ^"fvox/%s^"", COUNTDOWN_SOUNDS[g_CountDown]);
	
	set_task(1.0, "task__CountDownStart", TASK_COUNTDOWN);
}

public getUserTeam(const id) {
	if(pev_valid(id) != PDATA_SAFE) {
		return FM_CS_TEAM_UNASSIGNED;
	}
	
	return get_pdata_int(id, OFFSET_CSTEAMS, OFFSET_LINUX);
}

public setUserTeam(const id, const team) {
	if(pev_valid(id) != PDATA_SAFE) {
		return;
	}
	
	set_pdata_int(id, OFFSET_CSTEAMS, team, OFFSET_LINUX);
	
	emessage_begin(MSG_ALL, g_Message_TeamInfo, _, 0);
	ewrite_byte(id);
	ewrite_string(CS_TEAM_NAMES[team]);
	emessage_end();
}

public clcmd__BlockCommand(const id) {
	return PLUGIN_HANDLED;
}

public task__AlltalkPoll() {
	new iMenuId;
	new i;
	
	g_PollVotes[0] = 0;
	g_PollVotes[1] = 0;
	
	iMenuId = menu_create("¿ ACTIVAR ALLTALK ?", "menu__AlltalkPoll");
	
	menu_additem(iMenuId, "Si", "1");
	menu_additem(iMenuId, "No", "2");
	
	menu_setprop(iMenuId, MPROP_EXITNAME, "Me da lo mismo");
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(is_user_connected(i)) {
			ShowLocalMenu(i, iMenuId);
		}
	}
	
	set_task(15.0, "task__EndPoll");
}

public menu__AlltalkPoll(const id, const menuId, const item) {
	if(!is_user_connected(id)) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	static sItemId[3];
	static iValue;
	static iItemId;
	
	menu_item_getinfo(menuId, item, iValue, sItemId, 2, _, _, iValue);
	
	iItemId = str_to_num(sItemId) - 1;
	
	++g_PollVotes[iItemId];
	
	DestroyLocalMenu(id, menuId);
	return PLUGIN_HANDLED;
}

public task__EndPoll() {
	if(g_PollVotes[0] > g_PollVotes[1]) {
		colorChat(0, _, "%sLa votación ha finalizado, el alltalk se ha activado con %d voto%s!", BNR_PREFIX, g_PollVotes[0], (g_PollVotes[0] != 1) ? "s" : "");
		
		set_cvar_num("sv_alltalk", 1);
	} else {
		colorChat(0, _, "%sLa votación ha finalizado, el alltalk seguirá desactivado!", BNR_PREFIX);
	}
}

public fw_CmdStart(const id, const handle) {
	if(!is_user_alive(id)) {
		return FMRES_IGNORED;
	}
	
	if(g_CurrentWeapon[id] != CSW_KNIFE) {
		return FMRES_IGNORED;
	}
	
	static iTeam;
	iTeam = getUserTeam(id);
	
	static iButton;
	iButton = get_uc(handle, UC_Buttons);
	
	if(iTeam == FM_CS_TEAM_T) {
		if(iButton & IN_ATTACK) {
			iButton &= ~IN_ATTACK;
		}
		
		if(iButton & IN_ATTACK2) {
			iButton &= ~IN_ATTACK2;
		}
		
		set_uc(handle, UC_Buttons, iButton);
		
		return FMRES_SUPERCEDE;
	} else if(iTeam == FM_CS_TEAM_CT) {		
		if(iButton & IN_ATTACK) {
			iButton &= ~IN_ATTACK;
			iButton |= IN_ATTACK2;
		}
		
		set_uc(handle, UC_Buttons, iButton);
		
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}

public fw_SetModel(const entity, const model[]) {
	if(strlen(model) < 8) {
		return FMRES_IGNORED;
	}
	
	static sClassName[10];
	entity_get_string(entity, EV_SZ_classname, sClassName, 9);
	
	if(equal(sClassName, "weaponbox")) {
		entity_set_float(entity, EV_FL_nextthink, get_gametime() + 0.01);
		return FMRES_IGNORED;
	}
	
	if(model[7] != 'w' || model[8] != '_') {
		return FMRES_IGNORED;
	}
	
	static Float:fDamageTime;
	fDamageTime = entity_get_float(entity, EV_FL_dmgtime);
	
	if(fDamageTime == 0.0) {
		return FMRES_IGNORED;
	}
	
	switch(model[9]) {
		case 's': {
			new Float:vecColor[3];
			
			vecColor[0] = 0.0;
			vecColor[1] = 100.0;
			vecColor[2] = 200.0;
			
			entity_set_int(entity, EV_INT_renderfx, kRenderFxGlowShell);
			entity_set_vector(entity, EV_VEC_rendercolor, vecColor);
			entity_set_int(entity, EV_INT_rendermode, kRenderNormal);
			entity_set_float(entity, EV_FL_renderamt, 1.0);
			
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
			write_byte(TE_BEAMFOLLOW);
			write_short(entity);
			write_short(g_SPRITE_Trail);
			write_byte(10);
			write_byte(3);
			write_byte(0);
			write_byte(100);
			write_byte(200);
			write_byte(200);
			message_end();
			
			entity_set_int(entity, EV_INT_flTimeStepSound, 913761);
		}
	}
	
	return FMRES_IGNORED;
}

public fw_ThinkGrenade(const entity) {
	if(!pev_valid(entity)) {
		return HAM_IGNORED;
	}
	
	static Float:fDamageTime;
	static Float:fCurrentTime;
	
	fDamageTime = entity_get_float(entity, EV_FL_dmgtime);
	fCurrentTime = get_gametime();
	
	if(fDamageTime > fCurrentTime) {
		return HAM_IGNORED;
	}
	
	if(!get_pdata_short(entity, m_usEvent_Grenade)) {
		g_FlasherId = entity_get_edict(entity, EV_ENT_owner);
	}
	
	switch(entity_get_int(entity, EV_INT_flTimeStepSound)) {
		case 913761: {
			frostExplode(entity);
			return HAM_SUPERCEDE;
		}
	}
	
	return HAM_IGNORED;
}

public message__ScreenFade(const msgId, const destId, const id) {	
	if(get_msg_arg_int(4) == 255 && get_msg_arg_int(5) == 255 && get_msg_arg_int(6) == 255) {
		if(getUserTeam(id) == getUserTeam(g_FlasherId)) {
			return PLUGIN_HANDLED;
		}
	}
	
	return PLUGIN_CONTINUE;
}

public frostExplode(const entity) {
	if(g_EndRound) {
		remove_entity(entity);
		return;
	}
	
	new iAttacker;
	iAttacker = entity_get_edict(entity, EV_ENT_owner);
	
	if(!is_user_connected(iAttacker)) {
		remove_entity(entity);
		return;
	}
	
	new Float:vecOrigin[3];
	entity_get_vector(entity, EV_VEC_origin, vecOrigin);
	
	engfunc(EngFunc_MessageBegin, MSG_BROADCAST, SVC_TEMPENTITY, vecOrigin, 0);
	write_byte(TE_DLIGHT);
	engfunc(EngFunc_WriteCoord, vecOrigin[0]);
	engfunc(EngFunc_WriteCoord, vecOrigin[1]);
	engfunc(EngFunc_WriteCoord, vecOrigin[2]);
	write_byte(30);
	write_byte(0);
	write_byte(100);
	write_byte(200);
	write_byte(3);
	write_byte(2);
	message_end();
	
	emit_sound(entity, CHAN_WEAPON, g_SOUND_Grenade_Frost, 1.0, ATTN_NORM, 0, PITCH_NORM);
	
	new iVictim;
	iVictim = -1;
	
	new iTeam;
	iTeam = getUserTeam(iAttacker);
	
	while((iVictim = engfunc(EngFunc_FindEntityInSphere, iVictim, vecOrigin, 220.0)) != 0) {
		if(!is_user_alive(iVictim) || (iTeam == getUserTeam(iVictim) && iAttacker != iVictim)) {
			continue;
		}
		
		if(g_Frozen[iVictim]) {
			continue;
		}
		
		set_user_rendering(iVictim, kRenderFxGlowShell, 0, 100, 200, kRenderNormal, 4);
		
		message_begin(MSG_ONE_UNRELIABLE, g_Message_ScreenFade, _, iVictim);
		write_short(0);
		write_short(0);
		write_short(FFADE_STAYOUT);
		write_byte(0);
		write_byte(100);
		write_byte(200);
		write_byte(150);
		message_end();
		
		g_Frozen[iVictim] = 1;
		g_SlowDown[iVictim] = 0;
		g_FrozenGravity[iVictim] = get_user_gravity(iVictim);
		
		if(get_entity_flags(iVictim) & FL_ONGROUND) {
			set_user_gravity(iVictim, 999999.9);
		} else {
			set_user_gravity(iVictim, 0.000001);
		}
		
		set_user_velocity(iVictim, Float:{0.0, 0.0, 0.0});
		
		ExecuteHamB(Ham_Player_ResetMaxSpeed, iVictim);		
		
		remove_task(iVictim + TASK_FROZEN);
		set_task(4.0, "task__RemoveFreeze", iVictim + TASK_FROZEN);
		
		emit_sound(iVictim, CHAN_BODY, g_SOUND_Grenade_Frost_Player, 1.0, ATTN_NORM, 0, PITCH_NORM);
	}
	
	remove_entity(entity);
}

public task__RemoveFreeze(const taskid) {
	new id = taskid - TASK_FROZEN;
	
	if(!is_user_alive(id)) {
		return;
	} else if(!g_Frozen[id]) {
		return;
	}
	
	g_Frozen[id] = 0;
	
	set_user_gravity(id, g_FrozenGravity[id]);
	
	set_user_rendering(id);
	
	client_cmd(id, "spk ^"%s^"", g_SOUND_Grenade_Frost_Break);
	
	message_begin(MSG_ONE, g_Message_ScreenFade, _, id);
	write_short(UNIT_SECOND);
	write_short(0);
	write_short(FFADE_IN);
	write_byte(0);
	write_byte(100);
	write_byte(200);
	write_byte(150);
	message_end();
	
	new vecOrigin[3];
	get_user_origin(id, vecOrigin);
	
	message_begin(MSG_PVS, SVC_TEMPENTITY, vecOrigin);
	write_byte(TE_BREAKMODEL);
	write_coord(vecOrigin[0]);
	write_coord(vecOrigin[1]);
	write_coord(vecOrigin[2] + 24);
	write_coord(16);
	write_coord(16);
	write_coord(16);
	write_coord(random_num(-50, 50));
	write_coord(random_num(-50, 50));
	write_coord(25);
	write_byte(10);
	write_short(g_SPRITE_Glass);
	write_byte(10);
	write_byte(25);
	write_byte(0x01);
	message_end();
	
	g_SlowDown[id] = 1;
	
	ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
	
	set_task(2.0, "task__RemoveSlowDown", id + TASK_FROZEN);
}

public task__RemoveSlowDown(const taskid) {
	new id = taskid - TASK_FROZEN;
	
	if(!is_user_alive(id)) {
		return;
	} else if(!g_SlowDown[id]) {
		return;
	}
	
	g_SlowDown[id] = 0;
	
	ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
}

public fw_ResetMaxSpeed__Post(const id) {
	if(!is_user_alive(id)) {
		return;
	}
	
	if(g_SlowDown[id]) {
		set_user_maxspeed(id, 150.0);
	} else if(g_FreezeTime || g_FT[id] || g_Frozen[id]) {
		set_user_maxspeed(id, 1.0);
	} else {
		static Float:fMaxSpeed;
		
		switch(g_CurrentWeapon[id]) {
			case CSW_SG550, CSW_AWP, CSW_G3SG1: {
				fMaxSpeed = 210.0;
			} case CSW_M249: {
				fMaxSpeed = 220.0;
			} case CSW_AK47: {
				fMaxSpeed = 221.0;
			} case CSW_M3, CSW_M4A1: {
				fMaxSpeed = 230.0;
			} case CSW_SG552: {
				fMaxSpeed = 235.0;
			} case CSW_XM1014, CSW_AUG, CSW_GALIL, CSW_FAMAS: {
				fMaxSpeed = 240.0;
			} case CSW_P90: {
				fMaxSpeed = 245.0;
			} case CSW_SCOUT: {
				fMaxSpeed = 260.0;
			} default: {
				fMaxSpeed = 250.0;
			}
		}
		
		set_user_maxspeed(id, fMaxSpeed);
	}
}

public message__Money(const msg_id, const msg_dest, const msg_entity) {
	if(is_user_connected(msg_entity)) {
		cs_set_user_money(msg_entity, 0);
	}
	
	return PLUGIN_HANDLED;
}

public menu__CSBuy(const id, const key) {
	return PLUGIN_HANDLED;
}

stock getWeaponEntId(const ent) {
	if(pev_valid(ent) != PDATA_SAFE)
		return -1;
	
	return get_pdata_cbase(ent, OFFSET_WEAPONOWNER, OFFSET_LINUX_WEAPONS);
}

public fw_Item_Deploy_Post(const weapon_ent) {
	static iId;
	iId = getWeaponEntId(weapon_ent);
	
	if(!pev_valid(iId)) {
		return;
	}
	
	static iWeaponId;
	iWeaponId = get_pdata_int(weapon_ent, OFFSET_ID, OFFSET_LINUX_WEAPONS);
	
	g_CurrentWeapon[iId] = iWeaponId;
	
	if(g_CurrentWeapon[iId] == CSW_KNIFE) {
		if(getUserTeam(iId) == FM_CS_TEAM_T) {
			set_pdata_float(weapon_ent, OFFSET_NEXT_PRIMARY_ATTACK, 99999.0, OFFSET_LINUX_WEAPONS);
			set_pdata_float(weapon_ent, OFFSET_NEXT_SECONDARY_ATTACK, 99999.0, OFFSET_LINUX_WEAPONS);
		}
	}
}

public logevent__RoundEnd() {	
	new i;
	new j = 0;
	
	g_EndRound = 1;
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(!is_user_alive(i)) {
			continue;
		}
		
		if(getUserTeam(i) == FM_CS_TEAM_T) {
			j = 1;
		}
	}
	
	if(!j) {
		for(i = 1; i <= g_MaxUsers; ++i) {
			if(!is_user_connected(i)) {
				continue;
			}
			
			if(getUserTeam(i) == FM_CS_TEAM_T) {
				setUserTeam(i, FM_CS_TEAM_CT);
			} else if(getUserTeam(i) == FM_CS_TEAM_CT) {
				setUserTeam(i, FM_CS_TEAM_T);
			}
		}
	}
}

public event__StatusValue(const id) {
	static sText[48];
	formatex(sText, 47, "1 Jugador: %%p2");
	
	message_begin(MSG_ONE_UNRELIABLE, g_Message_StatusText, _, id);
	write_byte(0);
	write_string(sText);
	message_end();
}