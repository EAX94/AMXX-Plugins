#define TASK_START_MIX		93512821

new g_fade[33];
// new g_fade_user = 0;
// new g_fade_ip[64][21];
// new g_fade_ignore[33];

#define WALKGUARD
#if defined WALKGUARD
#include <xs>
enum ZONEMODE {
	ZM_NOTHING,
	ZM_CAMPING,
	ZM_CAMPING_T1,	// Team 1 -> e.g. Terrorist
	ZM_CAMPING_T2,	// Team 2 -> e.g. Counter-Terroris
	ZM_BLOCK_ALL,
	ZM_KILL,
	ZM_KILL_T1,	// DoD-Unterstützung
	ZM_KILL_T2
}

new zonemode[ZONEMODE][] = { "no function", "camper-zone", "camper-zone for team 1 (e.g. terrorist)", "camper-zone for team 2 (e.g. counter-terrorist)",
"block all player",  "cheater-zone, kill",  "cheater-zone (team 1 [e.g. terrorist]), kill",  "cheater-zone (team 2 [e.g. counter-terrorist]), kill" }
new zonename[ZONEMODE][] = { "wgz_none", "wgz_camper", "wgz_camper_t1", "wgz_camper_t2", "wgz_block_all", "wgz_kill", "wgz_kill_t1", "wgz_kill_t2" }
new solidtyp[ZONEMODE] = { SOLID_NOT, SOLID_TRIGGER, SOLID_TRIGGER, SOLID_TRIGGER, SOLID_BBOX, SOLID_TRIGGER, SOLID_TRIGGER, SOLID_TRIGGER }
new zonecolor[ZONEMODE][3] = {
	{ 255, 0, 255 },		// nichts
	{ 0, 255, 0 },		// Camperzone
	{ 0, 255, 128 },		// Camperzone T1
	{ 128, 255, 0 },		// Camperzone T2
	{ 0, 255, 255 },	// alle Blockieren
	{ 255, 255, 255 },	// Kill
	{ 255, 0, 128 },	// Kill - T1
	{ 255, 128, 0 }	// Kill - T2
}

#define ZONEID pev_iuser1
#define CAMPERTIME pev_iuser2

new zone_color_aktiv[3] = { 0, 0, 255 }
new zone_color_red[3] = { 255, 0, 0 }
new zone_color_green[3] = { 255, 255, 0 }

// alle Zonen
#define MAXZONES 100
new zone[MAXZONES]
new maxzones		// soviele existieren
new index		// die aktuelle Zone

// Editier-Funktionen
new setupunits = 10	// Änderungen an der Größe um diese Einheiten
new direction = 0	// 0 -> X-Koorinaten / 1 -> Y-Koords / 2 -> Z-Koords
new koordinaten[3][] = { "x-coordinates", "y-coordinates", "z-coordinates" }

new spr_dot		// benötigt für die Lininen

new editor = 0		// dieser Spieler ist gerade am erstellen .. Menü verkraftet nur einen Editor

#define TASK_BASIS_CAMPER 2000
#define TASK_BASIS_SHOWZONES 1000
#endif

#define MIN_PLAYERS		10
#define MIN_PLAYERS_HALF	MIN_PLAYERS / 2
#define MAX_ROUND_FOR_WIN	16
#define ROUND_DRAW			30
#define ROUND_HALF			15

new const g_plugin_name[] = "AutoMix";
new const g_plugin_version[] = "v1.2";
new const g_plugin_author[] = "KISKE";

enum()
{
	TEAM_NONE = 0,
	TEAM_T,
	TEAM_CT,
	TEAM_SPEC,
	
	MAX_TEAMS
};
enum(+= 19993)
{
	TASK_HUD = 199933,
	TASK_READY_REPEAT,
	TASK_HUD_REST_FOR_MIX,
	TASK_MENU_READY,
	TASK_MENU_CHOOSE,
	TASK_MENU_CHOOSE_TEAM_NAME,
	TASK_HUD_SPEC,
	TASK_PLAY_TIME
};
enum _:Colors 
{
	DONT_CHANGE,
	TERRORIST,
	CT,
	SPECTATOR
}
#define ID_HUD					(taskid - TASK_HUD)
#define ID_READY_REPEAT			(taskid - TASK_READY_REPEAT)
#define ID_HUD_REST_FOR_MIX 		(taskid - TASK_HUD_REST_FOR_MIX)
#define ID_MENU_READY 				(taskid - TASK_MENU_READY)
#define ID_MENU_CHOOSE 			(taskid - TASK_MENU_CHOOSE)
#define ID_MENU_CHOOSE_TEAM_NAME 	(taskid - TASK_MENU_CHOOSE_TEAM_NAME)
#define ID_HUD_SPEC 				(taskid - TASK_HUD_SPEC)
#define ID_PLAY_TIME			(taskid - TASK_PLAY_TIME)

new g_pos[33];
new g_menu_page[33];
new g_play_time[33];
new g_round_echoe[33];
new g_stats[33][7];
new g_health_dif[33];
new g_health[33];
new g_dmg_ta[33];
new g_frags[33];
new g_deaths[33];
new g_teamid[33];
new g_turn[33];
new g_team[33];
new g_captain[33];
new g_playername[33][32];
new g_choosen_no[33];
new g_seconds[33];
new g_ready[33];
new g_local_ip[33][21];
new Float:g_stats_cd[33];
new g_stats_page[33];
new Float:g_Flooding[33] = {0.0, ...};
new g_Flood[33] = {0, ...};
new g_iUsed[33];
//new g_view_team[33][4];

new g_chosing_team;
new g_captain_winner;
new g_ab[2];
new g_votes[2];
new g_win_cts;
new g_win_ts;
new g_score[2];
new g_cmode[2];
new g_cname[2][32];
new g_count_mode;
new g_mix_valid;
new g_mode = 1;
new g_captains_choosen;
new g_chosing;
new g_duel;
new g_players[MAX_TEAMS]
new g_captain_choosen[2];
new g_mix;
new g_hud1, g_hud2, g_hud3;
new g_maxplayers;
new g_count_ready;
new g_messageid_saytext;
new g_messageid_teaminfo;
new g_ip[10][21];
new g_nextmap[64];


new const g_sTeamNums[MAX_TEAMS][] = {"0", "1", "2", "6"};
new const g_sClassNums[MAX_TEAMS][] = {"1", "2", "3", "4"};
new const g_cTeamChars[MAX_TEAMS] = {'U', 'T', 'C', 'S'};
const iMaxLen = 21;

const KEYSMENU = MENU_KEY_1|MENU_KEY_2|MENU_KEY_3|MENU_KEY_4|MENU_KEY_5|MENU_KEY_6|MENU_KEY_7|MENU_KEY_8|MENU_KEY_9|MENU_KEY_0;

#define MAX_MAP_VALID 5

new const g_MAPS_VALID_NAME[][] = {
	"de_dust2",
	"de_inferno",
	"de_nuke",
	"de_train",
	"de_tuscan",
	//"de_forge",
	"de_mirage"
};
new const g_MAPS_NAME[][] = {
	"de_inferno",
	"de_train",
	"de_nuke",
	"de_cpl_mill",
	"de_cpl_strike",
	"de_cbble",
	"de_aztec",
	"de_dust2",
	"de_tuscan",
	"de_forge",
	"de_mirage"
};
new const Float:g_fPOSITION_MAPS_TT[][] = {
	{ 111.183029, 572.347717, 132.031249 }, // INFERNO
	{ 284.024902, 27.816091, -187.968749 }, // TRAIN
	{ 659.916992, -1947.879882, -379.968749 }, // NUKE
	{ -802.550170, 2507.484619, 36.031249 }, // CPL MILL
	{ -478.465637, -794.111022, 36.031249 }, // CPL STRIKE
	{ -2331.539794, 1959.727783, 36.031249 }, // CBBLE
	{ -156.625106, -376.184600, -187.968749 }, // AZTEC
	{ 1451.223266, 1260.739501, 36.031249 }, // DUST 2
	{ 998.680297, -525.559387, 228.031249 }, // TUSCAN
	{ 128.913467, 1186.271972, -155.968749 }, // FORGE
	{ -401.181488, -774.095703, 36.031249 } // MIRAGE
};
new const Float:g_fPOSITION_MAPS_CT[][] = {
	{ 818.583923, 582.875793, 132.031249 }, // INFERNO
	{ 762.217407, 26.430614, -187.968749 }, // TRAIN
	{ 1283.274414, -1935.856689, -379.968749 }, // NUKE
	{ -314.270935, 2510.453369, 36.031249 }, // CPL MILL
	{ -996.077819, -804.120422, 36.031249 }, // CPL STRIKE
	{ -2325.385986, 1367.260986, 36.031249 }, // CBBLE
	{ -800.235412, -379.146606, -187.968749 }, // AZTEC
	{ 1451.223266, 2019.671142, 36.031249 }, // DUST 2
	{ 380.338623, -538.604858, 228.031249 }, // TUSCAN
	{ 551.178710, 1187.568237, -155.968749 }, // FORGE
	{ -907.803405, -776.713378, 36.031249 } // MIRAGE
};