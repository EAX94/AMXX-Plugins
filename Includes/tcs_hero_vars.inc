/* ========================================
======== VARIABLES - ENUMS - OFFSETS ======
======================================== */

enum _:Colors {
	DONT_CHANGE,
	TERRORIST,
	CT,
	SPECTATOR
};

enum _:Tasks {
	TASK_SAVE = 10100,
	TASK_MODEL,
	TASK_SPAWN
};

enum _:Menus {
	MENU_REGISTER_LOGIN = 0,
	MENU_MAIN
}

const PDATA_SAFE 				= 2;
const OFFSET_LINUX_WEAPONS 		= 4;
const OFFSET_LINUX 				= 5;
const OFFSET_WEAPONOWNER 		= 41;
const OFFSET_ID 				= 43;
const OFFSET_KNOWN 				= 44;
const OFFSET_PAINSHOCK 			= 108;
const OFFSET_CSTEAMS 			= 114;
const OFFSET_CSMENUCODE 		= 205;
const OFFSET_FLASHLIGHT_BATTERY = 244;
const OFFSET_AWM_AMMO		 	= 377;
const OFFSET_SCOUT_AMMO 		= 378;
const OFFSET_PARA_AMMO 			= 379;
const OFFSET_FAMAS_AMMO 		= 380;
const OFFSET_M3_AMMO 			= 381;
const OFFSET_USP_AMMO 			= 382;
const OFFSET_FIVESEVEN_AMMO 	= 383;
const OFFSET_DEAGLE_AMMO		= 384;
const OFFSET_P228_AMMO 			= 385;
const OFFSET_GLOCK_AMMO 		= 386;
const OFFSET_FLASH_AMMO 		= 387;
const OFFSET_HE_AMMO 			= 388;
const OFFSET_SMOKE_AMMO 		= 389;
const OFFSET_C4_AMMO			= 390;

const HIDE_HUDS 				= (1 << 5) | (1 << 3);
const UNIT_SECOND 				= (1 << 12);

new const REMOVE_ENTS[][] = {
	"func_bomb_target", "info_bomb_target", "info_vip_start", "func_vip_safetyzone", "func_escapezone", "hostage_entity", "monster_scientist", "info_hostage_rescue",
	"func_hostage_rescue", "env_rain", "env_snow", "env_fog", "func_vehicle", "info_map_parameters", "func_buyzone", "armoury_entity", "game_text"
};

new g_player_name[33][32];

new g_forward_spawn;
new g_forward_precsound;

new g_message_radar;
new g_message_scoreinfo;

new g_maxplayers;

new Handle:g_sql_tuple;
new Handle:g_sql_connection;
new g_sql_error[512];