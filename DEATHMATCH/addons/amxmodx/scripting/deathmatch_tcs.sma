#include <amxmodx> 
#include <amxmisc>
#include <cstrike>
#include <fun>
#include <fakemeta_util> 
#include <engine_const>
#include <hamsandwich>
#include <csdm>
#pragma library csdm_main

new pCVAR_HitsReward, pCVAR_HitHead, pCVAR_HitChest, pCVAR_HitStomach, pCVAR_HitLeftArm, pCVAR_HitRightArm, pCVAR_HitLeftLeg, pCVAR_HitRightLeg
new gHealthSum[33];
new g_spec[33];

new const g_objective_ents[][] = 
{
	"func_bomb_target",
	"info_bomb_target",
	"hostage_entity",
	"monster_scientist",
	"func_hostage_rescue",
	"info_hostage_rescue",
	"info_vip_start",
	"func_vip_safetyzone",
	"func_escapezone"
}

#define OBJTYPE_AS (1<<0)
#define OBJTYPE_CS (1<<2)
#define OBJTYPE_DE (1<<3)
#define OBJTYPE_ES (1<<4)
#define OBJTYPE_ALL (OBJTYPE_AS | OBJTYPE_CS | OBJTYPE_DE | OBJTYPE_ES)

#define CVAR_NAME "no_objectives"
#define CVAR_DEFAULT OBJTYPE_ALL

new const g_objective_type[] =
{
	OBJTYPE_DE,
	OBJTYPE_DE,
	OBJTYPE_CS,
	OBJTYPE_CS,
	OBJTYPE_CS,
	OBJTYPE_CS,
	OBJTYPE_AS,
	OBJTYPE_AS,
	OBJTYPE_ES
}

new const bool:g_objective_prim[] = 
{
	true,
	true,
	true,
	false,
	false,
	false,
	false,
	true,
	true
}

#define HIDE_ROUND_TIMER (1<<4)

new g_msgid_hideweapon
new g_pcvar_no_objectives
new g_no_objectives = CVAR_DEFAULT & OBJTYPE_ALL

new D_ACCESS = ADMIN_MAP

#define CSDM_OPTIONS_TOTAL		2

new bool:g_StripWeapons = true
new bool:g_RemoveBomb = true
new g_StayTime
new g_drop_fwd
new g_options[CSDM_OPTIONS_TOTAL]
new g_MainMenu = -1

#define MAPSTRIP_BOMB		(1<<0)
#define MAPSTRIP_VIP		(1<<1)
#define MAPSTRIP_HOSTAGE	(1<<2)
#define MAPSTRIP_BUY		(1<<3)

new bool:g_BlockBuy = true
new bool:g_AmmoRefill = true
new bool:g_RadioMsg = false

#define MAXMENUPOS 34

new g_Aliases[MAXMENUPOS][] = {"usp","glock","deagle","p228","elites","fn57","m3","xm1014","mp5","tmp","p90","mac10","ump45","ak47","galil","famas","sg552","m4a1","aug","scout","awp","g3sg1","sg550","m249","vest","vesthelm","flash","hegren","sgren","defuser","nvgs","shield","primammo","secammo"} 
new g_Aliases2[MAXMENUPOS][] = {"km45","9x19mm","nighthawk","228compact","elites","fiveseven","12gauge","autoshotgun","smg","mp","c90","mac10","ump45","cv47","defender","clarion","krieg552","m4a1","bullpup","scout","magnum","d3au1","krieg550","m249","vest","vesthelm","flash","hegren","sgren","defuser","nvgs","shield","primammo","secammo"}

new g_MapStripFlags = 0
new bool:g_MainPlugin = true

#define	MAX_SPAWNS	60
new Float:g_SpawnVecs[MAX_SPAWNS][3];
new Float:g_SpawnAngles[MAX_SPAWNS][3];
new Float:g_SpawnVAngles[MAX_SPAWNS][3];
new g_TotalSpawns = 0;

new g_ProtColors[3][3] = {{0,0,0},{255,0,0},{0,0,255}}
new g_GlowAlpha[3]
new g_Protected[33]
new bool:g_Enabled = false
new Float:g_ProtTime = 2.0

new _HS_ONLY

public plugin_natives()
{
	register_native("csdm_main_menu", "native_main_menu")
	register_native("csdm_set_mainoption", "__csdm_allow_option")
	register_native("csdm_fwd_drop", "__csdm_fwd_drop")
	register_library("csdm_main")
	set_module_filter("module_filter")
	set_native_filter("native_filter")
}

public module_filter(const module[])
{
	if (equali(module, "csdm_main"))
		return PLUGIN_HANDLED
	
	return PLUGIN_CONTINUE
}

public native_filter(const name[], index, trap)
{
	if (!trap)
		return PLUGIN_HANDLED
		
	return PLUGIN_CONTINUE
}

public native_main_menu(id, num)
{
	return g_MainMenu
}

public __csdm_allow_option(id, num)
{
	new option = get_param(1)
	
	if (option <= 0 || option >= CSDM_OPTIONS_TOTAL)
	{
		log_error(AMX_ERR_NATIVE, "Invalid option number: %d", option)
		return 0
	}
	
	g_options[option] = get_param(2)
	
	return 1
}

public __csdm_fwd_drop(id, num)
{
	new id = get_param(1)
	new wp = get_param(2)
	new name[32]
	
	get_string(3, name, 31)
	
	return run_drop(id, wp, name)	
}

public csdm_Init(const version[])
{
	if (version[0] == 0)
	{
		set_fail_state("CSDM failed to load.")
		return
	}
	
	csdm_addstyle("preset", "spawn_Preset")
}

public csdm_CfgInit()
{	
	csdm_reg_cfg("settings", "read_cfg")
	csdm_reg_cfg("misc", "read_cfg_misc")
	csdm_reg_cfg("ffa", "read_cfg_ffa")
	csdm_reg_cfg("settings", "read_cfg_settings")
	csdm_reg_cfg("protection", "read_cfg_protection")
}

public plugin_precache() 
{
	if ((g_pcvar_no_objectives = get_cvar_pointer(CVAR_NAME))) 
	{
		new cvar_val[8]
		get_pcvar_string(g_pcvar_no_objectives, cvar_val, sizeof cvar_val - 1)
		g_no_objectives = read_flags(cvar_val) & OBJTYPE_ALL
	}

	if( g_no_objectives )
		register_forward(FM_Spawn, "forward_spawn")
	
	precache_sound("radio/locknload.wav")
	precache_sound("radio/letsgo.wav")
	
	register_forward(FM_Spawn, "OnEntSpawn")
}

public plugin_init() 
{     
	register_plugin("DeathMatch", "0.1", "Taringa! CS")
	
	_HS_ONLY = register_cvar( "csdm_hs_only", "0" )
	
	register_clcmd("say /spec", "clcmd_Spec")
	
	register_clcmd("say respawn", "say_respawn")
	register_clcmd("say /respawn", "say_respawn")
	
	register_forward(FM_SetModel, "fw_SetModel")
	
	register_concmd("csdm_enable", "csdm_enable", D_ACCESS, "Enables CSDM")
	register_concmd("csdm_disable", "csdm_disable", D_ACCESS, "Disables CSDM")
	register_concmd("csdm_ctrl", "csdm_ctrl", D_ACCESS, "")
	register_concmd("csdm_reload", "csdm_reload", D_ACCESS, "Reloads CSDM Config")
	register_clcmd("csdm_menu", "csdm_menu", ADMIN_MENU, "CSDM Menu")
	register_clcmd("drop", "hook_drop")
	
	register_concmd("csdm_cache", "cacheInfo", ADMIN_MAP, "Shows cache information")
	
	AddMenuItem("CSDM Menu", "csdm_menu", D_ACCESS, "CSDM Main")
	g_MainMenu = menu_create("CSDM Menu", "use_csdm_menu")
	
	new callback = menu_makecallback("hook_item_display")
	menu_additem(g_MainMenu, "Activar/Desactivar", "csdm_ctrl", D_ACCESS, callback)
	menu_additem(g_MainMenu, "Recargar configuracion", "csdm_reload", D_ACCESS)
	
	g_drop_fwd = CreateMultiForward("csdm_HandleDrop", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL)
	
	register_event("CurWeapon", "hook_CurWeapon", "be", "1=1")
	register_forward(FM_PlayerPreThink, "On_ClientPreThink", 1);
	
	register_clcmd("buy", "generic_block")
	register_clcmd("buyammo1", "generic_block")
	register_clcmd("buyammo2", "generic_block")
	register_clcmd("buyequip", "generic_block")
	register_clcmd("cl_autobuy", "generic_block")
	register_clcmd("cl_rebuy", "generic_block")
	register_clcmd("cl_setautobuy", "generic_block")
	register_clcmd("cl_setrebuy", "generic_block")
	
	register_concmd("csdm_pvlist", "pvlist")
	
	set_task(2.0, "DoMapStrips")
	
	register_concmd("csdm_ffa_enable", "csdm_ffa_enable", ADMIN_MAP, "Enables FFA Mode")
	register_concmd("csdm_ffa_disable", "csdm_ffa_disable", ADMIN_MAP, "Disables FFA Mode")
	register_concmd("csdm_ffa_ctrl", "csdm_ffa_ctrl", ADMIN_MAP, "FFA Toggling")
	
	g_MainPlugin = module_exists("csdm_main") ? true : false
	
	if (g_MainPlugin)
	{
		new menu = csdm_main_menu()
		
		new callback = menu_makecallback("hook_item_display2")
		menu_additem(menu, "Enable/Disable FFA", "csdm_ffa_ctrl", ADMIN_MAP, callback)
	}
	
	set_task(4.0, "enforce_ffa")
	
	register_event("StatusIcon", "GotBomb", "be", "1=1", "1=2", "2=c4")
	
	pCVAR_HitsReward = register_cvar( "tcs_hit_reward", "1" )
	pCVAR_HitHead = register_cvar( "tcs_hit_head", "25" )
	pCVAR_HitChest = register_cvar( "tcs_hit_chest", "15" )
	pCVAR_HitStomach = register_cvar( "tcs_hit_stomach", "5" )
	pCVAR_HitLeftArm = register_cvar( "tcs_hit_leftarm", "5" )
	pCVAR_HitRightArm = register_cvar( "tcs_hit_rightarm", "5" )
	pCVAR_HitLeftLeg = register_cvar( "tcs_hit_leftleg", "5" )
	pCVAR_HitRightLeg = register_cvar( "tcs_hit_rightleg", "5" )
	
	RegisterHam(Ham_TakeDamage, "player", "FORWARD_TakeDamage")
	RegisterHam(Ham_Killed, "player", "fw_PlayerKilled")
	
	register_forward(FM_EmitSound, "FwdEmitSound")
	
	register_message(get_user_msgid("TextMsg"), "Message_TextMsg")
	set_msg_block( get_user_msgid( "Radar" ) , BLOCK_SET )
	
	new szBlockRadio[][] =
	{
		"radio1", "radio2", "radio3", "coverme", "takepoint", "holdpos", "regroup", "followme", "takingfire", "go", "fallback", "sticktog", "getinpos",
		"stormfront", "report", "roger", "enemyspot", "needbackup", "sectorclear", "inposition", "reportingin", "getout", "negative", "enemydown"
	}
	
	for(new i; i<sizeof(szBlockRadio); i++)
		register_clcmd(szBlockRadio[i], "ClientCommand_Radio")
	
	if (!g_pcvar_no_objectives) 
	{
		new cvar_defval[8]
		get_flags(CVAR_DEFAULT, cvar_defval, sizeof cvar_defval - 1)
		register_cvar(CVAR_NAME, cvar_defval)
	}

	if (is_objective_map())
		return;

	g_msgid_hideweapon = get_user_msgid("HideWeapon")
	register_message(g_msgid_hideweapon, "message_hide_weapon")
	register_event("ResetHUD", "event_hud_reset", "b")
	set_msg_block(get_user_msgid("RoundTime"), BLOCK_SET)
}

public fw_SetModel(entity, const model[])
{
	if (strlen(model) < 8)
		return;
	
	// Get entity's classname
	static classname[10]
	pev(entity, pev_classname, classname, charsmax(classname))
	
	// Check if it's a weapon box
	if (equal(classname, "weaponbox"))
	{
		// They get automatically removed when thinking
		set_pev(entity, pev_nextthink, get_gametime() + 5.0)
		return;
	}
}

public client_connect(id)
{
	g_Protected[id] = 0
}

public client_disconnect(id)
{
	if (g_Protected[id])
	{
		remove_task(g_Protected[id])
		g_Protected[id] = 0
	}
}

public cacheInfo(id, level, cid)
{
	if (!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED
		
	new ar[6]
	csdm_cache(ar)
	
	console_print(id, "[CSDM] Free tasks: respawn=%d, findweapon=%d", ar[0], ar[5])
	console_print(id, "[CSDM] Weapon removal cache: %d total, %d live", ar[4], ar[3])
	console_print(id, "[CSDM] Live tasks: %d (%d free)", ar[2], ar[1])
	
	return PLUGIN_HANDLED
}

public hook_drop(id)
{
	if (!csdm_active())
	{
		return
	}
	
	if (!is_user_connected(id))
	{
		return
	}
	
	new wp, c, a, name[24]
	if (cs_get_user_shield(id))
	{
		//entirely different...
		wp = -1
		copy(name, 23, "weapon_shield")
	} else {
		if (read_argc() <= 1)
		{
			wp = get_user_weapon(id, c, a)
		} else {
			read_argv(1, name, 23)
			wp = getWepId(name)
		}
	}

	run_drop(id, wp, name)
}

run_drop(id, wp, const name[])
{
	new ret
	ExecuteForward(g_drop_fwd, ret, id, wp, 0)
	
	if (ret == CSDM_DROP_REMOVE)
	{
		new _name[24]
		if (name[0] == 0)
		{
			get_weaponname(wp, _name, 23)
		}
		csdm_remove_weapon(id, _name, 0, 1)
		return 1
	} else if (ret == CSDM_DROP_IGNORE) {
		return 0
	}
	
	if (g_StayTime > 20 || g_StayTime < 0)
	{
		return 0
	}
	
	if (wp)
	{
		remove_weapon(id, wp)
		return 1
	}
	
	return 0
}

public csdm_PostDeath(killer, victim, headshot, const weapon[])
{
	if (g_StayTime > 0 && g_StayTime < 20)
	{
		new weapons[MAX_WEAPONS], num, name[24]
		new wp, slot, ret

		get_user_weapons(victim, weapons, num)

		for (new i=0; i<num; i++)
		{
			wp = weapons[i]
			slot = g_WeaponSlots[wp]

			ExecuteForward(g_drop_fwd, ret, victim, wp, 1)

			if (ret == CSDM_DROP_REMOVE)
			{
				get_weaponname(wp, name, 23)
				csdm_remove_weapon(victim, name, 0, 1)
			} else if (ret == CSDM_DROP_IGNORE) {
				continue
			} else {
				if (slot == SLOT_PRIMARY || slot == SLOT_SECONDARY || slot == SLOT_C4)
				{
					remove_weapon(victim, wp)
				}
			}
		}
		
		if (cs_get_user_shield(victim))
		{
			ExecuteForward(g_drop_fwd, ret, victim, -1, 1)
			if (ret == CSDM_DROP_REMOVE)
			{
				csdm_remove_weapon(victim, "weapon_shield", 0, 1)
			} else if (ret == CSDM_DROP_IGNORE) {
				/* do nothing */
			} else {
				remove_weapon(victim, -1)
			}
		}
	}
	
	if (!g_Enabled)
		return
		
	RemoveProtection(victim)
}

public csdm_PreSpawn(player, bool:fake)
{
	//we'll just have to back out for now
	if (cs_get_user_shield(player))
	{
		return
	}
	new team = get_user_team(player)
	if (g_StripWeapons)
	{
		if (team == _TEAM_T)
		{
			if (cs_get_user_shield(player))
			{
				drop_with_shield(player, CSW_GLOCK18)
			} else {
				csdm_force_drop(player, "weapon_glock18")
			}
		} else if (team == _TEAM_CT) {
			if (cs_get_user_shield(player))
			{
				drop_with_shield(player, CSW_USP)
			} else {
				csdm_force_drop(player, "weapon_usp")
			}
		}
	}
	if (team == _TEAM_T)
	{
		if (g_RemoveBomb)
		{
			new weapons[MAX_WEAPONS], num
			get_user_weapons(player, weapons, num)
			for (new i=0; i<num; i++)
			{
				if (weapons[i] == CSW_C4)
				{
					if (cs_get_user_shield(player))
					{
						drop_with_shield(player, CSW_C4)
					} else {
						csdm_force_drop(player, "weapon_c4")
					}
					break
				}
			}
		}
	}
}

public csdm_PostSpawn(player, bool:fake)
{
	if (g_RadioMsg && !is_user_bot(player))
	{
		if (get_user_team(player) == _TEAM_T)
		{
			client_cmd(player, "spk radio/letsgo")
		} else {
			client_cmd(player, "spk radio/locknload")
		}
	}
	
	SetProtection(player)
}

remove_weapon(id, wp)
{
	new name[24]
	
	if (wp == -1)
	{
		copy(name, 23, "weapon_shield")
	} else {
		get_weaponname(wp, name, 23)
	}

	if ((wp == CSW_C4) && g_RemoveBomb)
	{	
		csdm_remove_weapon(id, name, 0, 1)
	} else {
		if (wp != CSW_C4)
		{
			csdm_remove_weapon(id, name, g_StayTime, 1)
		}
	}
}

public hook_item_display(player, menu, item)
{
	new paccess, command[24], call
	
	menu_item_getinfo(menu, item, paccess, command, 23, _, 0, call)
	
	if (equali(command, "csdm_ctrl"))
	{
		if (!csdm_active())
		{
			menu_item_setname(menu, item, "Activar")
		} else {
			menu_item_setname(menu, item, "Desactivar")
		}
	}
}

public read_cfg(readAction, line[], section[])
{
	if (readAction == CFG_READ)
	{
		new setting[24], sign[3], value[32];

		parse(line, setting, 23, sign, 2, value, 31);
		
		if (equali(setting, "strip_weapons"))
		{
			g_StripWeapons = str_to_num(value) ? true : false
		} else if (equali(setting, "weapons_stay")) {
			g_StayTime = str_to_num(value)
		} else if (equali(setting, "spawnmode")) {
			new var = csdm_setstyle(value)
			if (var)
			{
				log_amx("CSDM spawn mode set to %s", value)
			} else {
				log_amx("CSDM spawn mode %s not found", value)
			}
		} else if (equali(setting, "remove_bomb")) {
			g_RemoveBomb = str_to_num(value) ? true : false
		} else if (equali(setting, "enabled")) {
			csdm_set_active(str_to_num(value))
		} else if (equali(setting, "spawn_wait_time")) {
			csdm_set_spawnwait(str_to_float(value))
		}
	}
}

public read_cfg_misc(readAction, line[], section[])
{
	if (!csdm_active())
		return
		
	if (readAction == CFG_READ)
	{
		new setting[24], sign[3], value[32];

		parse(line, setting, 23, sign, 2, value, 31);
		
		if (equali(setting, "remove_objectives"))
		{
			new mapname[24]
			get_mapname(mapname, 23)
			
			if (containi(mapname, "de_") != -1 && containi(value, "d") != -1)
			{
				g_MapStripFlags |= MAPSTRIP_BOMB
			}
			if (containi(mapname, "as_") != -1 && containi(value, "a") != -1)
			{
				g_MapStripFlags |= MAPSTRIP_VIP
			}
			if (containi(mapname, "cs_") != -1 && containi(value, "c") != -1)
			{
				g_MapStripFlags |= MAPSTRIP_HOSTAGE
			}
			if (containi(value, "b") != -1)
			{
				g_MapStripFlags |= MAPSTRIP_BUY
			}
		} else if (equali(setting, "block_buy")) {
			g_BlockBuy = str_to_num(value) ? true : false
		} else if (equali(setting, "ammo_refill")) {
			g_AmmoRefill = str_to_num(value) ? true : false
		} else if (equali(setting, "spawn_radio_msg")) {
			g_RadioMsg = str_to_num(value) ? true : false
		}
	} else if (readAction == CFG_RELOAD) {
		g_MapStripFlags = 0
		g_BlockBuy = true
		g_AmmoRefill = true
		g_RadioMsg = false
	}
}

public csdm_reload(id, level, cid)
{
	if (!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED
		
	new file[33] = ""
	if (read_argc() >= 2)
	{
		read_argv(1, file, 32)
	}
		
	if (csdm_reload_cfg(file))
	{
		client_print(id, print_chat, "[CSDM] Configuracion recargada.")
	} else {
		client_print(id, print_chat, "[CSDM] No se encuentra ninguna configuracion.")
	}
		
	return PLUGIN_HANDLED
}

public csdm_menu(id, level, cid)
{
	if (!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED
	
	menu_display(id, g_MainMenu, 0)
	
	return PLUGIN_HANDLED
}

public csdm_ctrl(id, level, cid)
{
	if (!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED
	
	csdm_set_active( csdm_active() ? 0 : 1 )
	client_print(id, print_chat, "Se activo el cambio CSDM.")
	
	return PLUGIN_HANDLED
}

public use_csdm_menu(id, menu, item)
{
	if (item < 0)
		return PLUGIN_CONTINUE
	
	new command[24], paccess, call
	if (!menu_item_getinfo(g_MainMenu, item, paccess, command, 23, _, 0, call))
	{
		log_amx("Error: csdm_menu_item() failed (menu %d) (page %d) (item %d)", g_MainMenu, 0, item)
		return PLUGIN_HANDLED
	}
	if (paccess && !(get_user_flags(id) & paccess))
	{
		client_print(id, print_chat, "No tenes acceso a esta opcion.")
		return PLUGIN_HANDLED
	}
	
	client_cmd(id, command)
	
	return PLUGIN_HANDLED
}

public csdm_enable(id, level, cid)
{
	if (!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED

	csdm_set_active(1)
	client_print(id, print_chat, "CSDM activado.")
	
	return PLUGIN_HANDLED	
}

public csdm_disable(id, level, cid)
{
	if (!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED

	csdm_set_active(0)
	client_print(id, print_chat, "CSDM desactivado.")
	
	return PLUGIN_HANDLED	
}

public say_respawn(id)
{
	if (g_options[CSDM_OPTION_SAYRESPAWN] == CSDM_SET_DISABLED)
	{
		client_print(id, print_chat, "[CSDM] Este comando esta deshabilitado.")
		return PLUGIN_HANDLED
	}
	
	if (!is_user_alive(id) && csdm_active())
	{
		new team = get_user_team(id)
		if (team == _TEAM_T || team == _TEAM_CT)
		{
			csdm_respawn(id)
		}
	}
	
	return PLUGIN_CONTINUE
}

public OnEntSpawn(ent)
{
	if (g_MapStripFlags & MAPSTRIP_HOSTAGE)
	{
		new classname[32]
		
		pev(ent, pev_classname, classname, 31)
		
		if (equal(classname, "hostage_entity"))
		{
			engfunc(EngFunc_RemoveEntity, ent)
			return FMRES_SUPERCEDE
		}
	}
	
	return FMRES_IGNORED
}

public pvlist(id, level, cid)
{
	new players[32], num, pv, name[32]
	get_players(players, num)
	
	for (new i=0; i<num; i++)
	{
		pv = players[i]
		get_user_name(pv, name, 31)
		console_print(id, "[CSDM] Player %s flags: %d deadflags: %d", name, pev(pv, pev_flags), pev(pv, pev_deadflag))
	}
	
	return PLUGIN_HANDLED
}

public generic_block(id, level, cid)
{
	if (csdm_active())
		return PLUGIN_HANDLED
		
	return PLUGIN_CONTINUE
}

public GotBomb(id) fm_strip_user_gun(id, CSW_C4)

public FORWARD_TakeDamage(victim, inflictor, attacker, Float:damage, damage_type)
{
	if (victim == attacker || !is_user_connected(attacker))
		return HAM_IGNORED;
	
	if(inflictor == attacker && is_user_alive(attacker) && get_user_weapon(attacker) == CSW_KNIFE)
		return HAM_SUPERCEDE;
		
	if( get_pcvar_num( pCVAR_HitsReward ) )
	{
		gHealthSum[attacker] = 0
		switch( get_pdata_int( victim, 75 ) )
		{
			case HIT_HEAD: if( get_pcvar_num( pCVAR_HitHead ) > 0 ) gHealthSum[attacker] = get_pcvar_num( pCVAR_HitHead )
			case HIT_CHEST: if( get_pcvar_num( pCVAR_HitChest ) > 0 ) gHealthSum[attacker] = get_pcvar_num( pCVAR_HitChest )
			case HIT_STOMACH: if( get_pcvar_num( pCVAR_HitStomach ) > 0 ) gHealthSum[attacker] = get_pcvar_num( pCVAR_HitStomach )
			case HIT_LEFTARM: if( get_pcvar_num( pCVAR_HitLeftArm ) > 0 ) gHealthSum[attacker] = get_pcvar_num( pCVAR_HitLeftArm )
			case HIT_RIGHTARM: if( get_pcvar_num( pCVAR_HitRightArm ) > 0 ) gHealthSum[attacker] = get_pcvar_num( pCVAR_HitRightArm )
			case HIT_LEFTLEG: if( get_pcvar_num( pCVAR_HitLeftLeg ) > 0 ) gHealthSum[attacker] = get_pcvar_num( pCVAR_HitLeftLeg )
			case HIT_RIGHTLEG: if( get_pcvar_num( pCVAR_HitRightLeg ) > 0 ) gHealthSum[attacker] = get_pcvar_num( pCVAR_HitRightLeg )
		}
	}

	return HAM_IGNORED;
}
public fw_PlayerKilled( victim, attacker, shouldgib )
{
	if(is_user_connected(attacker)) {
		if( ( get_user_health( attacker ) + gHealthSum[attacker] ) >= 101 ) set_user_health( attacker, 100 )
		else if( gHealthSum[attacker] > 0 ) set_user_health( attacker, get_user_health( attacker ) + gHealthSum[attacker] )
	}
	
	if(g_spec[victim])
		cs_set_user_team(victim, CS_TEAM_SPECTATOR);
}

public FwdEmitSound(const iEntity, const iChannel, const szSound[ ]) return equal( szSound, "items/gunpickup2.wav" ) ? FMRES_SUPERCEDE : FMRES_IGNORED;

public Message_TextMsg(iMsgId, MSG_DEST, id)
{
	if( id )
		return PLUGIN_CONTINUE

	if( get_msg_args() != 2 )
		return PLUGIN_CONTINUE

	if(get_msg_arg_int(1) != print_console)
		return PLUGIN_CONTINUE

	static szText[15]
	get_msg_arg_string(2, szText, 14)
	if( equal(szText,"#Game_scoring") )
		return PLUGIN_HANDLED

	return PLUGIN_CONTINUE
}

public ClientCommand_Radio(id) return PLUGIN_HANDLED;

public forward_spawn(ent)
 {
	if (!pev_valid(ent))
		return FMRES_IGNORED

	static classname[32], i
	pev(ent, pev_classname, classname, sizeof classname - 1)
	for (i = 0; i < sizeof g_objective_ents; ++i) 
	{
		if (equal(classname, g_objective_ents[i])) 
		{
			if (!(g_no_objectives & g_objective_type[i]))
				return FMRES_IGNORED

			engfunc(EngFunc_RemoveEntity, ent)
			return FMRES_SUPERCEDE
		}
	}

	return FMRES_IGNORED
}

public message_hide_weapon() set_msg_arg_int(1, ARG_BYTE, get_msg_arg_int(1) | HIDE_ROUND_TIMER)

public event_hud_reset(id) 
{
	message_begin(MSG_ONE, g_msgid_hideweapon, _, id)
	write_byte(HIDE_ROUND_TIMER)
	message_end()
}

bool:is_objective_map() 
{
	new const classname[] = "classname"
	for (new i = 0; i < sizeof g_objective_ents; ++i) 
	{
		if(g_objective_prim[i] && engfunc(EngFunc_FindEntityByString, FM_NULLENT, classname, g_objective_ents[i]))
			return true
	}

	return false
}

public client_command(id)
{
	if (csdm_active() && g_BlockBuy)
	{
		new arg[13]
		if (read_argv(0, arg, 12) > 11)
		{
			return PLUGIN_CONTINUE 
		}
		new a = 0 
		do {
			if (equali(g_Aliases[a], arg) || equali(g_Aliases2[a], arg))
			{ 
				return PLUGIN_HANDLED 
			}
		} while(++a < MAXMENUPOS)
	}
	
	return PLUGIN_CONTINUE 
} 

public hook_CurWeapon(id)
{
	if (!g_AmmoRefill || !csdm_active())
	{
		return
	}
	
	new wp = read_data(2)
	
	if (g_WeaponSlots[wp] == SLOT_PRIMARY || g_WeaponSlots[wp] == SLOT_SECONDARY)
	{
		new ammo = cs_get_user_bpammo(id, wp)
		
		if (ammo < g_MaxBPAmmo[wp])
		{
			cs_set_user_bpammo(id, wp, g_MaxBPAmmo[wp])
		}
	}
}

public DoMapStrips()
{
	if (g_MapStripFlags & MAPSTRIP_BOMB)
	{
		RemoveEntityAll("func_bomb_target")
		RemoveEntityAll("info_bomb_target")
	}
	if (g_MapStripFlags & MAPSTRIP_VIP)
	{
		RemoveEntityAll("func_vip_safetyzone")
		RemoveEntityAll("info_vip_start")
	}
	if (g_MapStripFlags & MAPSTRIP_HOSTAGE)
	{
		RemoveEntityAll("func_hostage_rescue")
		RemoveEntityAll("info_hostage_rescue")
	}
	if (g_MapStripFlags & MAPSTRIP_BUY)
	{
		RemoveEntityAll("func_buyzone")
	}
}

stock RemoveEntityAll(name[])
{
	new ent = engfunc(EngFunc_FindEntityByString, 0, "classname", name)
	new temp
	while (ent)
	{
		temp = engfunc(EngFunc_FindEntityByString, ent, "classname", name)
		engfunc(EngFunc_RemoveEntity, ent)
		ent = temp
	}
}

public enforce_ffa()
{
	//enforce this
	if (csdm_get_ffa())
	{
		set_cvar_num("mp_friendlyfire", 1)
	}
}

public csdm_ffa_ctrl(id, level, cid)
{
	if (!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED
	
	csdm_set_ffa( csdm_get_ffa() ? 0 : 1 )
	client_print(id, print_chat, "[CSDM] CSDM FFA mode changed.")
	
	return PLUGIN_HANDLED
}

public hook_item_display2(player, menu, item)
{
	new paccess, command[24], call
	
	menu_item_getinfo(menu, item, paccess, command, 23, _, 0, call)
	
	if (equali(command, "csdm_ffa_ctrl"))
	{
		if (!csdm_get_ffa())
		{
			menu_item_setname(menu, item, "Enable FFA")
		} else {
			menu_item_setname(menu, item, "Disable FFA")
		}
	}
}

public csdm_ffa_enable(id, level, cid)
{
	if (!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED

	csdm_set_ffa(1)
	client_print(id, print_chat, "CSDM FFA enabled.")
	
	return PLUGIN_HANDLED	
}

public csdm_ffa_disable(id, level, cid)
{
	if (!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED

	csdm_set_ffa(0)
	client_print(id, print_chat, "CSDM FFA disabled.")
	
	return PLUGIN_HANDLED	
}

public read_cfg_ffa(readAction, line[], section[])
{
	if (readAction == CFG_READ)
	{
		new setting[24], sign[3], value[32];

		parse(line, setting, 23, sign, 2, value, 31);
	
		if (equali(setting, "enabled"))
		{
			csdm_set_ffa(str_to_num(value))
		}
	}
}

public read_cfg_settings(action, line[], section[])
{
	if (action == CFG_RELOAD)
	{
		readSpawns()
	}
}

readSpawns()
{
	//-617 2648 179 16 -22 0 0 -5 -22 0
	// Origin (x,y,z), Angles (x,y,z), vAngles(x,y,z), Team (0 = ALL) - ignore
	// :TODO: Implement team specific spawns
	
	new Map[32], config[32],  MapFile[64]
	
	get_mapname(Map, 31)
	get_configsdir(config, 31)
	format(MapFile, 63, "%s\csdm\%s.spawns.cfg", config, Map)
	g_TotalSpawns = 0;
	
	if (file_exists(MapFile)) 
	{
		new Data[124], len
		new line = 0
		new pos[12][8]
    		
		while(g_TotalSpawns < MAX_SPAWNS && (line = read_file(MapFile , line , Data , 123 , len) ) != 0 ) 
		{
			if (strlen(Data)<2 || Data[0] == '[')
				continue;

			parse(Data, pos[1], 7, pos[2], 7, pos[3], 7, pos[4], 7, pos[5], 7, pos[6], 7, pos[7], 7, pos[8], 7, pos[9], 7, pos[10], 7);
			
			// Origin
			g_SpawnVecs[g_TotalSpawns][0] = str_to_float(pos[1])
			g_SpawnVecs[g_TotalSpawns][1] = str_to_float(pos[2])
			g_SpawnVecs[g_TotalSpawns][2] = str_to_float(pos[3])
			
			//Angles
			g_SpawnAngles[g_TotalSpawns][0] = str_to_float(pos[4])
			g_SpawnAngles[g_TotalSpawns][1] = str_to_float(pos[5])
			g_SpawnAngles[g_TotalSpawns][2] = str_to_float(pos[6])
			
			//v-Angles
			g_SpawnVAngles[g_TotalSpawns][0] = str_to_float(pos[8])
			g_SpawnVAngles[g_TotalSpawns][1] = str_to_float(pos[9])
			g_SpawnVAngles[g_TotalSpawns][2] = str_to_float(pos[10])
			
			//Team - ignore - 7
			
			g_TotalSpawns++;
		}
		
		log_amx("Loaded %d spawn points for map %s.", g_TotalSpawns, Map)
	} else {
		log_amx("No spawn points file found (%s)", MapFile)
	}
	
	return 1;
}
	
public spawn_Preset(id, num)
{
	if (g_TotalSpawns < 2)
		return PLUGIN_CONTINUE
	
	new list[MAX_SPAWNS]
	new num = 0
	new final = -1
	new total=0
	new players[32], n, x = 0
	new Float:loc[32][3], locnum
	
	//cache locations
	get_players(players, num)
	for (new i=0; i<num; i++)
	{
		if (is_user_alive(players[i]) && players[i] != id)
		{
			pev(players[i], pev_origin, loc[locnum])
			locnum++
		}
	}
	
	num = 0
	while (num <= g_TotalSpawns)
	{
		//have we visited all the spawns yet?
		if (num == g_TotalSpawns)
			break;
		//get a random spawn
		n = random_num(0, g_TotalSpawns-1)
		//have we visited this spawn yet?
		if (!list[n])
		{
			//yes, set the flag to true, and inc the number of spawns we've visited
			list[n] = 1
			num++
		} 
		else 
		{
	        //this was a useless loop, so add to the infinite loop prevention counter
			total++;
			if (total > 100) // don't search forever
				break;
			continue;   //don't check again
		}

		new trace  = csdm_trace_hull(g_SpawnVecs[n], 1)
							 
		if (trace)
			continue;
		
		if (locnum < 1)
		{
			final = n
			break
		}
		
		final = n
		for (x = 0; x < locnum; x++)
		{
			new Float:distance = get_distance_f(g_SpawnVecs[n], loc[x]);
			if (distance < 250.0)
			{
				//invalidate
				final = -1
				break;
			}
		}
		
		if (final != -1)
			break
	}
	
	if (final != -1)
	{
		new Float:mins[3], Float:maxs[3]
		pev(id, pev_mins, mins)
		pev(id, pev_maxs, maxs)
		engfunc(EngFunc_SetSize, id, mins, maxs)
		engfunc(EngFunc_SetOrigin, id, g_SpawnVecs[final])
		set_pev(id, pev_fixangle, 1)
		set_pev(id, pev_angles, g_SpawnAngles[final])
		set_pev(id, pev_v_angle, g_SpawnVAngles[final])
		set_pev(id, pev_fixangle, 1)
		
		return PLUGIN_HANDLED
	}

	return PLUGIN_CONTINUE
}

SetProtection(id)
{
	if (g_Protected[id])
		remove_task(g_Protected[id])
		
	if (!is_user_connected(id))
		return
		
	new team = get_user_team(id)
	
	if (!IsValidTeam(team))
	{
		return
	}

	set_task(g_ProtTime, "ProtectionOver", id)
	g_Protected[id] = id
	
	set_rendering(id, kRenderFxGlowShell, g_ProtColors[team][0], g_ProtColors[team][1], g_ProtColors[team][2], kRenderNormal, g_GlowAlpha[team])
	set_pev(id, pev_takedamage, 0.0)
}

RemoveProtection(id)
{
	if (g_Protected[id])
		remove_task(g_Protected[id])
		
	ProtectionOver(id)
}

public ProtectionOver(id)
{
	g_Protected[id] = 0
	
	if (!is_user_connected(id))
		return
	
	set_rendering(id, kRenderFxNone, 0, 0, 0, kRenderNormal, 0)
	set_pev(id, pev_takedamage, 2.0)
}

public On_ClientPreThink(id)
{
	if (!g_Enabled || !g_Protected[id] || !is_user_connected(id))
		return
	
	new buttons = pev(id,pev_button);
     
	if ( (buttons & IN_ATTACK) || (buttons & IN_ATTACK2) )
	{
		RemoveProtection(id)
	}
}

public read_cfg_protection(readAction, line[], section[])
{
	if (!csdm_active())
		return
		
	if (readAction == CFG_READ)
	{
		new setting[24], sign[3], value[32];

		parse(line, setting, 23, sign, 2, value, 31);
		
		if (equali(setting, "colorst"))
		{
			new red[10], green[10], blue[10], alpha[10]
			parse(value, red, 9, green, 9, blue, 9, alpha, 9)
			
			g_ProtColors[_TEAM_T][0] = str_to_num(red)
			g_ProtColors[_TEAM_T][1] = str_to_num(green)
			g_ProtColors[_TEAM_T][2] = str_to_num(blue)
			g_GlowAlpha[_TEAM_T] = str_to_num(alpha)
		}
		else if (equali(setting, "colorsct"))
		{
			new red[10], green[10], blue[10], alpha[10]
			parse(value, red, 9, green, 9, blue, 9, alpha, 9)
			
			g_ProtColors[_TEAM_CT][0] = str_to_num(red)
			g_ProtColors[_TEAM_CT][1] = str_to_num(green)
			g_ProtColors[_TEAM_CT][2] = str_to_num(blue)
			g_GlowAlpha[_TEAM_CT] = str_to_num(alpha)
		} 
		else if (equali(setting, "enabled")) 
		{
			g_Enabled = str_to_num(value) ? true : false
		} 
		else if (equali(setting, "time")) 
		{
			g_ProtTime = str_to_float(value)
		}
	}
}

stock set_rendering(index, fx=kRenderFxNone, r=255, g=255, b=255, render=kRenderNormal, amount=16)
{
	set_pev(index, pev_renderfx, fx)
	new Float:RenderColor[3]
	RenderColor[0] = float(r)
	RenderColor[1] = float(g)
	RenderColor[2] = float(b)
	set_pev(index, pev_rendercolor, RenderColor)
	set_pev(index, pev_rendermode, render)
	set_pev(index, pev_renderamt, float(amount))

	return 1
}

public client_putinserver( Index )
{
	if( get_pcvar_num( _HS_ONLY ) )
		set_user_hitzones( Index, 0, 2 )
	
	g_spec[Index] = 0;

	return PLUGIN_CONTINUE;
}

public clcmd_Spec(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!(get_user_flags(id) & ADMIN_KICK))
		return PLUGIN_HANDLED;
	
	if(get_user_team(id) == 0)
		return PLUGIN_HANDLED;
	
	g_spec[id] = !g_spec[id];
	
	if(g_spec[id])
		client_print(id, print_chat, "* Cuando mueras serás transferido a ESPECTADOR!");
	else
	{
		if(get_user_team(id) == 3)
		{
			cs_set_user_team(id, CS_TEAM_T, CS_T_LEET);
			ExecuteHamB(Ham_CS_RoundRespawn, id);
		}
	}
	
	return PLUGIN_HANDLED;
}