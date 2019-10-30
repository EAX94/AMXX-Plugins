#if defined _dg_amxx_base_v3_included
	#endinput
#endif
#define _dg_amxx_base_v3_included

// Includes Main
#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <hamsandwich>
#include <safemenu>
#include <unixtime>
#include <cstrike>
#include <engine>
#include <fun>
#include <cc>

// Parameters
#pragma dynamic 8144
#pragma semicolon 1

// Data Plugin
new const PLUGIN_NAME[] = "Amx Mod X";
new const PLUGIN_VERSION[] = "v1.0.1 BETA";
new const PLUGIN_AUTHOR[] = "Rubio.-";
new const PLUGIN_COMMUNITY_NAME[] = "Drunk Gaming";
new const PLUGIN_FORUM_NAME[] = "www.drunk-gaming.com";
new const PLUGIN_PROVIDER_NAME[] = "Advanced Company - Game Servers";
new const PLUGIN_PROVIDER_WEB[] = "www.advcom.org";

// Prefix (ColorChat)
new const AMXX_PREFIX[] = "!g[DRUNK GAMING]!y ";
new const AMXX_CONSOLE_PREFIX[] = "[DRUNK GAMING] ";

// Resources
new const SOUND_MAPCHOOSER[] = "gman/gman_choose1";
new const SOUND_INTRO[] = "intro/dg_intro4.wav";

// Files
new const LOGFILE_MAPS[] = "amxx_maps.log";
new const LOGFILE_BAN[] = "amxx_bans.log";

// Others
new const CS_TEAMS_MENU[][] = {
	"UNA", "T", "CT", "SPECTATOR"
};

new const BLOCK_CVARS[][] = {
	"hostname", "rcon_password", "sv_allowdownload", "mp_kickpercent", "mp_roundtime", "sv_lan", "sv_visiblemaxplayers", "amx_gg_nextmap", "amx_extendmap_max",
	"mapchangecfgfile", "sv_airaccelerate", "sv_gravity"
};

new const BLOCK_CVARS_ZP[][] = {
	"sv_restartround", "mp_freezetime", "mp_timelimit", "mp_roundtime", "zp_delay"
};

// Offsets
const PDATA_SAFE = 2;
const OFFSET_LINUX = 5;
const OFFSET_CSTEAMS = 114;
const OFFSET_CSMENUCODE = 205;

// Others consts
const MAX_USERS = 33;
const MAX_VOTEMAP = 9;
const MAX_VOTES = 4;

const KEYSMENU = MENU_KEY_1|MENU_KEY_2|MENU_KEY_3|MENU_KEY_4|MENU_KEY_5|MENU_KEY_6|MENU_KEY_7|MENU_KEY_8|MENU_KEY_9|MENU_KEY_0;

// Enums
enum _:structIdTasks (+= 1958365) {
	TASK_ADMINCHAT = 71100,
	TASK_MAPCHOOSER,
	TASK_CHECK_MAPCHOOSER,
	TASK_END_MAPCHOOSER,
	TASK_VOTE,
	TASK_PREMIUM,
	TASK_HELP,
	TASK_SOUNDINTRO,
	TASK_GAG
};

enum _:structIdTeams {
	TEAM_NONE = 0,
	TEAM_T,
	TEAM_CT,
	TEAM_SPECTATOR
};

// Defines
#define isUserValid(%0) (1 <= %0 <= g_MaxUsers)
#define isUserValidAlive(%0) (isUserValid(%0) && is_user_alive(%0))
#define isUserValidConnected(%0) (isUserValid(%0) && is_user_connected(%0))

// Stocks
stock getUserTeam(const id) {
	if(pev_valid(id) != PDATA_SAFE) {
		return TEAM_NONE;
	}
	
	return get_pdata_int(id, OFFSET_CSTEAMS, OFFSET_LINUX);
}

stock setUserTeam(const id, const team) {
	if(pev_valid(id) != PDATA_SAFE) {
		return;
	}
	
	set_pdata_int(id, OFFSET_CSTEAMS, team, OFFSET_LINUX);
}