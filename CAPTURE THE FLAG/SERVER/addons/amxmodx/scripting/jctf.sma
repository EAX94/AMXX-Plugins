new const MOD_TITLE[] =			"Capture the Flag"
new const MOD_AUTHOR[] =		""
new const MOD_VERSION[] =		"1.1.1"

#define MAX_MAP_VALID		12

new const g_MAPS_VALID_NAME[][] = {
	"de_dust2",
	"cs_italy",
	"de_tuscan",
	"de_inferno",
	"de_train",
	"de_industro",
	"de_nuke",
	"de_aztec",
	"de_westwood",
	"cs_assault",
	"de_rats",
	"de_mirage",
	"de_dust"
	// "de_forge"
	// "ctf_mideast"
};

new g_nextmap[64];

// new const MAPS_NAME_ONE_FLAG[][] = {
	// "as_oirlig"
	// "de_dust2",
	// "de_cbble",
	// "de_cpl_mill",
	// "de_dust",
	// "de_inferno",
	// "de_nuke"
// }
new const Float:MAPS_ONE_FLAG[][] = {
	{-1980.651611, 2742.145996, 68.031249},
	{976.442260, -1015.720947, -91.968749},
	{-1413.136108, 1886.253784, -11.276754},
	{-1046.452392, 1837.674682, -155.968749},
	{742.996704, 550.418518, 132.031249},
	{542.520080, -1996.462280, -379.968749}
}
new g_iMap;

new g_RespawnProtection_Count[33];



#define FEATURE_ADRENALINE		true

new g_hud1, g_hud2, g_hud3, g_hud4;

#define sub(%1,%2) 				(%2 |= (1<<(%1&31)))
#define cub(%1,%2) 				(%2 &= ~(1 <<(%1&31)))
#define hub(%1,%2) 				(%2 & (1<<(%1&31)))

new g_bSuperJump;

new g_team_balance[33];

new g_restart_map_ob;
new g_restart_map;

#define TASK_SLOWDOWN			894166
#define ID_SLOWDOWN				(taskid - TASK_SLOWDOWN)
#define ID_TASK_TOXIC 			(taskid - 672158)

/*#define TASK_INVIS				9357184
#define ID_INVIS				(taskid - TASK_INVIS)*/

#define TASK_FLAG_RED	9313
#define TASK_FLAG_BLUE	93601

enum _:MaxModes {
	MODE_NORMAL = 0,
	MODE_ONE_FLAG
};
new g_mode;

#if FEATURE_ADRENALINE == true

enum {
	ADRENALINE_SPEED = 1,
	ADRENALINE_BERSERK, 
	ADRENALINE_BALAS_INFI_PREC_PERF,
	ADRENALINE_LONGJUMP,
	ADRENALINE_INVISIBILITY,
	ADRENALINE_HEALTH,
	ADRENALINE_IMPOSTOR,
	ADRENALINE_ICE_BOMB,
	ADRENALINE_TOXIC_BOMB,
	
	ADRENALINE_MAX
}

#endif // FEATURE_ADRENALINE

enum _:maxClass {
	CLASS_NOCLASS = 0,
	CLASS_ATTACKER,
	CLASS_DEFENSOR,
	CLASS_NORMAL
}

enum _:classStruct {
	className[32],
	classInfo[128],
	classHealth,
	classArmor,
	classRegen
}
new const CLASES[][classStruct] = {
	{"NO CLASS", "", 100, 0, 1},
	{"ATACANTE", "100 HP - 75 AP^n\r -\w No puede comprar \yINVISIBILIDAD\w ni \yDAÑO", 100, 75, 1},
	{"DEFENSOR", "100 HP - 100 AP^n\r -\w No puede comprar \yVIDA\w, \yVELOCIDAD\w ni \yLJ", 100, 100, 1},
	{"PRO", "100 HP^n\r -\w Puede comprar todos los poderes a un \yprecio elevado\w", 100, 0, 1}
}

new g_class[33];
new g_class_next[33];
new g_class_time[33];

new g_flag_time[2];
new g_toxic_sprite[2]

enum (+= 93525) {
	GRENADE_ICE = 98751,
	TOXIC_BOMB
}

new g_grenade_ice[33];
new g_toxic_bomb[33];

new g_StatusText;


new const MAXBPAMMO[] = { -1, 52, -1, 90, 1, 32, 1, 100, 90, 1, 120, 100, 100, 90, 90, 90, 100, 120, 30, 120, 200, 32, 90, 120, 90, 2, 35, 90, 90, -1, 100 };
new const MAXCLIP[] = { -1, 13, -1, 10, -1, 7, -1, 30, 30, -1, 30, 20, 25, 30, 35, 25, 12, 20, 10, 30, 100, 8, 30, 30, 20, -1, 7, 30, 30, -1, 50 };

/*
	Below you can enable/disable each individual feature of this plugin
	NOTE: Remember to compile the plugin again after you modify anything in this file!

	-----------------------------------

	Description: This uses Orpheu module to make infinite round end and trigger round end on flag captures
	If set to false, ophreu will not be used anymore and rounds could end if all players from one team are dead and round can't end upon flag capture.
*/
#define FEATURE_ORPHEU			true


/*
	Description: This hooks the buy system of the game and changes it, allowing everybody to buy all weapons.
	If set to false, it will disable all buy related stuff like: buy menu, spawn weaopns, special weapons, even C4!
	Disable this if you want to use another plugin that manages buy or doesn't use buy at all (like GunGame)
*/
#define FEATURE_BUY			true


/*
	Description: This allows players to buy and use C4 as a weapon, not an objective, it can be defused tough but the defuser gets a usable C4 back. C4 kills everything in it's radius, including teammates.
	If set to false, C4 usage will be completly disabled so it can't be bought.

	Requirements: FEATURE_BUY must be true
*/
#define FEATURE_BUYC4			true




/* --------------------------------------------------------------------------------------------
	Skip this, advanced configuration more below
*/
#if FEATURE_BUY == true && FEATURE_BUYC4 == true 
#define FEATURE_C4 true
#else
#define FEATURE_C4 false
#endif

#include <amxmodx>
#include <amxmisc>
#include <hamsandwich>

#if FEATURE_ORPHEU == true
#include <orpheu_memory>
#include <orpheu>
#endif

#include <fakemeta_util>
#include <cstrike>
#include <engine>
#include <fun>

// #include <global_natives>

/* --------------------------------------------------------------------------------------------

	CVars for .cfg files:

		ctf_flagreturn (default 120) - flag auto-return time
		ctf_weaponstay (default 30) - how long do weapons and items stay on ground
		ctf_itempercent (default 30) - chance that items spawn when a player is killed, values from 0 to 100
		ctf_sound_taken (default 1) - toggles if the "flag taken" sounds can be heard
		ctf_sound_dropped (default 1) - toggles if the "flag dropped" sounds can be heard
		ctf_sound_returned (default 1) - toggles if the "flag returned" sounds can be heard
		ctf_sound_score (default 1) - toggles if the "X team scores" sounds can be heard
		ctf_respawntime (default 10) - players respawn time (use -1 to disable respawn)
		ctf_spawnmoney (default 1000) - money bonus when spawning (unless it's a suicide)
		ctf_protection (default 5) - players spawn protection time (use -1 to disable protection)
		ctf_dynamiclights (default 1) - set the default dynamic lights setting, players will still be able to toggle individually using /lights
		ctf_glows (default 1) - set if entities can glow, like when players have flag or an adrenaline combo, weapons start to fade, etc.
		ctf_nospam_flash (default 20) - delay of rebuying two flashbangs in a life
		ctf_nospam_he (default 20) - delay of rebuying a HE grenade in a life
		ctf_nospam_smoke (default 20) - delay of rebuying a smoke grenade in a life
		ctf_spawn_prim (default "m3") - spawning primary weapon, set to "" to disable
		ctf_spawn_sec (default "glock") - spawning secondary weapon, set to "" to disable
		ctf_spawn_knife (default 1) - toggle if players spawn with knife or not
		ctf_sound_taken (default 1) - toggles if the "flag taken" sounds can be heard
		ctf_sound_dropped (default 1) - toggles if the "flag dropped" sounds can be heard
		ctf_sound_returned (default 1) - toggles if the "flag returned" sounds can be heard
		ctf_sound_score (default 1) - toggles if the "X team scores" sounds can be heard

	Primary weapons: m3,xm1014,tmp,mac10,mp5,ump45,p90,galil,ak47,famas,m4a1,aug,sg552,awp,scout,sg550,g3sg1,m249,shield
	Secondary weapons: glock,usp,p228,deagle,elites,fiveseven

		mp_c4timer (recommended 20) - time before the C4 devices explode
		mp_winlimit - first team who reaches this number wins
		mp_timelimit - time limit for the map (displayed in the round timer)
		mp_startmoney (recommended 3000) - for first spawn money and minimum amount of money
		mp_forcecamera - (0/1 - spectate enemies or not) mod fades to black if this is on and player is in free look (no teammates alive)
		mp_forcechasecam - (0/1/2 - force chase cammera all/team/firstperson) same as above
		mp_autoteambalance - enable/disable auto-team balance (checks at every player death)

	Map configurations are made with;

		ctf_moveflag red/blue at your position (even if dead/spec)
		ctf_save to save flag origins in maps/<mapname>.ctf

	Reward configuration, 0 on all values disables reward/penalty.

	[REWARD FOR]				[MONEY]	[FRAGS]	[ADRENALINE]
*/
#define REWARD_RETURN				500,		0,		10
#define REWARD_RETURN_ASSIST			500,		0,		10

#define REWARD_CAPTURE				3000,		3,		25
#define REWARD_CAPTURE_ASSIST			3000,		3,		25
#define REWARD_CAPTURE_TEAM			1000,		0,		10

#define REWARD_STEAL				1000,		1,		10
#define REWARD_PICKUP				500,		1,		5
#define PENALTY_DROP				-1500,	-1,		-10

#define REWARD_KILL				0,		0,		5
#define REWARD_KILLCARRIER			500,		1,		10

#define PENALTY_SUICIDE				0,		0,		-20
#define PENALTY_TEAMKILL			0,		0,		-20

/*
	Advanced configuration
*/

const ADMIN_RETURN =				ADMIN_LEVEL_A	// access required for admins to return flags (full list in includes/amxconst.inc)
const ADMIN_RETURNWAIT =			15		// time the flag needs to stay dropped before it can be returned by command

const ITEM_MEDKIT_GIVE =			25		// medkit award health for picking up

new const bool:ITEM_DROP_AMMO =		true		// toggle if killed players drop ammo items
new const bool:ITEM_DROP_MEDKIT =		true		// toggle if killed players drop medkit items

#if FEATURE_ADRENALINE == true
new const bool:ITEM_DROP_ADRENALINE =	true		// toggle if killed players drop adrenaline items
const ITEM_ADRENALINE_GIVE =			5		// adrenaline reaward for picking up adrenaline

const Float:SPEED_ADRENALINE =		1.3		// speed while using "speed" adrenaline combo (this and SPEED_FLAG are cumulative)

const Float:BERSERKER_SPEED1 =		0.7		// primary weapon shooting speed percent while in berserk
const Float:BERSERKER_SPEED2 =		0.3		// secondary weapon shooting speed percent while in berserk
const Float:BERSERKER_DAMAGE =		2.0		// weapon damage percent while in berserk

const INSTANTSPAWN_COST =			50		// instant spawn (/spawn) adrenaline cost

#endif // FEATURE_ADRENALINE

const REGENERATE_EXTRAHP =			50		// extra max HP for regeneration and flag healing

const Float:SPEED_FLAG =			0.9		// speed while carying the enemy flag

new const Float:BASE_HEAL_DISTANCE =	96.0		// healing distance for flag

#if FEATURE_C4 == true

new const C4_RADIUS[] =				"600"		// c4 explosion radius (must be string!)
//new const C4_DEFUSETIME =			3		// c4 defuse time

#endif // FEATURE_C4

new const FLAG_SAVELOCATION[] =		"maps/%s.ctf" // you can change where .ctf files are saved/loaded from

#define FLAG_IGNORE_BOTS			true		// set to true if you don't want bots to pick up flags

new const INFO_TARGET[] =			"info_target"
new const ITEM_CLASSNAME[] =			"ctf_item"
new const WEAPONBOX[] =				"weaponbox"

#if FEATURE_C4 == true

new const GRENADE[] =				"grenade"

#endif // FEATURE_C4

new const Float:ITEM_HULL_MIN[3] =		{-1.0, -1.0, 0.0}
new const Float:ITEM_HULL_MAX[3] =		{1.0, 1.0, 10.0}

const ITEM_AMMO =					0
const ITEM_MEDKIT =				1

#if FEATURE_ADRENALINE == true

const ITEM_ADRENALINE =				2

#endif // FEATURE_ADRENALINE

new const ITEM_MODEL_AMMO[] =			"models/w_chainammo.mdl"
new const ITEM_MODEL_MEDKIT[] =		"models/w_medkit.mdl"

#if FEATURE_ADRENALINE == true

new const ITEM_MODEL_ADRENALINE[] =		"models/can.mdl"

#endif // FEATURE_ADRENALINE

new const BASE_CLASSNAME[] =			"ctf_flagbase"
new const Float:BASE_THINK =			0.25

new const FLAG_CLASSNAME[] =			"ctf_flag"
new const FLAG_MODEL[] =			"models/th_jctf.mdl"

new const FLAG_CLASSNAME_ONE_FLAG[] = "ctf_flag_one_flag"
// new const FLAG_MODEL_ONE_FLAG[] = "models/th_jctf_one_flag.mdl"

new const Float:FLAG_THINK =			0.1
const FLAG_SKIPTHINK =				10 /* FLAG_THINK * FLAG_SKIPTHINK = 2.0 seconds ! */

new const Float:FLAG_HULL_MIN[3] =		{-2.0, -2.0, 0.0}
new const Float:FLAG_HULL_MAX[3] =		{2.0, 2.0, 16.0}

new const Float:FLAG_SPAWN_VELOCITY[3] =	{0.0, 0.0, -500.0}
new const Float:FLAG_SPAWN_ANGLES[3] =	{0.0, 0.0, 0.0}

new const Float:FLAG_DROP_VELOCITY[3] =	{0.0, 0.0, 50.0}

new const Float:FLAG_PICKUPDISTANCE =	80.0

const FLAG_LIGHT_RANGE =			12
const FLAG_LIGHT_LIFE =				5
const FLAG_LIGHT_DECAY =			1

const FLAG_ANI_DROPPED =			0
const FLAG_ANI_STAND =				1
const FLAG_ANI_BASE =				2

const FLAG_HOLD_BASE =				33
const FLAG_HOLD_DROPPED =			34

#if FEATURE_BUY == true

new const WHITESPACE[] =			" "
new const MENU_BUY[] =				"menu_buy"
new const MENU_KEYS_BUY =			(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)|(1<<9)

new const BUY_ITEM_DISABLED[] =		"d"
new const BUY_ITEM_AVAILABLE[] =		"w"

#if FEATURE_ADRENALINE == true

new const BUY_ITEM_AVAILABLE2[] =		"y"

#endif // FEATURE_ADRENALINE

#endif // FEATURE_BUY

new const SND_GETAMMO[] =			"items/9mmclip1.wav"
new const SND_GETMEDKIT[] =			"items/smallmedkit1.wav"

#if FEATURE_ADRENALINE == true

new const SND_GETADRENALINE[] =		"items/medshot4.wav"
new const SND_ADRENALINE[] =			"ambience/des_wind3.wav"

#endif // FEATURE_ADRENALINE

#if FEATURE_C4 == true

new const SND_C4DISARMED[] =			"weapons/c4_disarmed.wav"

#endif // FEATURE_C4

new const CHAT_PREFIX[] =			"!t[!gCTF!t]!y "
new const CONSOLE_PREFIX[] =			"[CTF] "

const FADE_OUT =					0x0000
const FADE_IN =					0x0001
const FADE_MODULATE =				0x0002
const FADE_STAY =					0x0004

const m_iUserPrefs =				510
const m_flNextPrimaryAttack =			46
const m_flNextSecondaryAttack =		47

new const PLAYER[] =				"player"
#define NULL					""

#define HUD_HINT					255, 255, 255, 0.15, -0.3, 0, 0.0, 10.0, 2.0, 10.0, 4
#define HUD_HELP					255, 255, 0, -1.0, 0.2, 2, 0.1, 2.0, 0.01, 2.0, 2
#define HUD_HELP_ONE_FLAG		255, 255, 0, -1.0, 0.2, 2, 0.1, 1.0, 0.01, 1.0, 2
#define HUD_HELP2					255, 255, 0, -1.0, 0.25, 2, 0.1, 2.0, 0.01, 2.0, 3
#define HUD_ANNOUNCE				-1.0, 0.3, 0, 0.0, 3.0, 0.1, 1.0, 4
#define HUD_RESPAWN				0, 255, 0, -1.0, 0.6, 2, 0.5, 0.1, 0.0, 1.0, 1
#define HUD_PROTECTION				255, 255, 0, -1.0, 0.6, 2, 0.5, 0.1, 0.0, 1.0, 1
#define HUD_ADRENALINE				255, 255, 255, -1.0, -0.1, 0, 0.0, 600.0, 0.0, 0.0, 1

#define entity_create(%1) 			create_entity(%1)
#define entity_spawn(%1)			DispatchSpawn(%1)
#define entity_think(%1)			call_think(%1)
#define entity_remove(%1)			remove_entity(%1)
#define weapon_remove(%1)			call_think(%1)

#define player_hasFlag(%1)			(g_iFlagHolder[0] == %1 || g_iFlagHolder[TEAM_RED] == %1 || g_iFlagHolder[TEAM_BLUE] == %1)

#define player_allowChangeTeam(%1)		set_pdata_int(%1, 125, get_pdata_int(%1, 125) & ~(1<<8))

#define gen_color(%1,%2)			%1 == TEAM_RED ? %2 : 0, 0, %1 == TEAM_RED ? 0 : %2

#define get_opTeam(%1)				(%1 == TEAM_BLUE ? TEAM_RED : (%1 == TEAM_RED ? TEAM_BLUE : 0))










enum
{
	x,
	y,
	z
}

enum
{
	pitch,
	yaw,
	roll
}

enum (+= 64)
{
	TASK_RESPAWN = 64,
	TASK_PROTECTION,
	TASK_DAMAGEPROTECTION,
	TASK_EQUIPAMENT,
	TASK_PUTINSERVER,
	TASK_TEAMBALANCE,
	TASK_ADRENALINE,
	TASK_DEFUSE
}

enum
{
	TEAM_NONE = 0,
	TEAM_RED,
	TEAM_BLUE,
	TEAM_SPEC
}

new const g_szCSTeams[][] =
{
	NULL,
	"TERRORIST",
	"CT",
	"SPECTATOR"
}

new const g_szTeamName[][] =
{
	NULL,
	"Red",
	"Blue",
	"Spectator"
}

new const g_szMLTeamName[][] =
{
	NULL,
	"TEAM_RED",
	"TEAM_BLUE",
	"TEAM_SPEC"
}

new const WEAPONENTNAMES[][] = { "", "weapon_p228", "", "weapon_scout", "weapon_hegrenade", "weapon_xm1014", "weapon_c4", "weapon_mac10",
"weapon_aug", "weapon_smokegrenade", "weapon_elite", "weapon_fiveseven", "weapon_ump45", "weapon_sg550", "weapon_galil", "weapon_famas", "weapon_usp", "weapon_glock18",
"weapon_awp", "weapon_mp5navy", "weapon_m249", "weapon_m3", "weapon_m4a1", "weapon_tmp", "weapon_g3sg1", "weapon_flashbang", "weapon_deagle", "weapon_sg552",
"weapon_ak47", "weapon_knife", "weapon_p90" };

new const g_szMLFlagTeam[][] =
{
	NULL,
	"FLAG_RED",
	"FLAG_BLUE",
	NULL
}

enum
{
	FLAG_STOLEN = 0,
	FLAG_PICKED,
	FLAG_DROPPED,
	FLAG_MANUALDROP,
	FLAG_RETURNED,
	FLAG_CAPTURED,
	FLAG_AUTORETURN,
	FLAG_ADMINRETURN
}

enum
{
	EVENT_TAKEN = 0,
	EVENT_DROPPED,
	EVENT_RETURNED,
	EVENT_SCORE,
}

new const g_szSounds[][][] =
{
	{NULL, "red_flag_taken", "blue_flag_taken"},
	{NULL, "red_flag_dropped", "blue_flag_dropped"},
	{NULL, "red_flag_returned", "blue_flag_returned"},
	{NULL, "red_team_scores", "blue_team_scores"}
}

#if FEATURE_BUY == true

enum
{
	no_weapon,
	primary,
	secondary,
	he,
	flash,
	smoke,
	armor,
	nvg
}

new const g_szRebuyCommands[][] =
{
	NULL,
	"PrimaryWeapon",
	"SecondaryWeapon",
	"HEGrenade",
	"Flashbang",
	"SmokeGrenade",
	"Armor",
	"NightVision"
}

#endif // FEATURE_BUY

new const g_szRemoveEntities[][] =
{
	"func_buyzone",
	"armoury_entity",
	"func_bomb_target",
	"info_bomb_target",
	"hostage_entity",
	"monster_scientist",
	"func_hostage_rescue",
	"info_hostage_rescue",
	"info_vip_start",
	"func_vip_safetyzone",
	"func_escapezone",
	"info_map_parameters",
	"player_weaponstrip",
	"game_player_equip"
}

enum
{
	ZERO = 0,
	W_P228,
	W_SHIELD,
	W_SCOUT,
	W_HEGRENADE,
	W_XM1014,
	W_C4,
	W_MAC10,
	W_AUG,
	W_SMOKEGRENADE,
	W_ELITE,
	W_FIVESEVEN,
	W_UMP45,
	W_SG550,
	W_GALIL,
	W_FAMAS,
	W_USP,
	W_GLOCK18,
	W_AWP,
	W_MP5NAVY,
	W_M249,
	W_M3,
	W_M4A1,
	W_TMP,
	W_G3SG1,
	W_FLASHBANG,
	W_DEAGLE,
	W_SG552,
	W_AK47,
	W_KNIFE,
	W_P90,
	W_VEST,
	W_VESTHELM,
	W_NVG
}

new const g_iClip[] =
{
	0,		// (unknown)
	13,		// P228
	0,		// SHIELD (not used)
	10,		// SCOUT
	0,   		// HEGRENADE (not used)
	7,   		// XM1014
	0,   		// C4 (not used)
	30,  		// MAC10
	30,  		// AUG
	0,   		// SMOKEGRENADE (not used)
	30,  		// ELITE
	20,  		// FIVESEVEN
	25,  		// UMP45
	30,  		// SG550
	35,  		// GALIL
	25,  		// FAMAS
	12,  		// USP
	20,  		// GLOCK18
	10,  		// AWP
	30,  		// MP5NAVY
	100, 		// M249
	8,   		// M3
	30,  		// M4A1
	30,  		// TMP
	20,  		// G3SG1
	0,   		// FLASHBANG (not used)
	7,   		// DEAGLE
	30,  		// SG552
	30,  		// AK47
	0,   		// KNIFE (not used)
	50,  		// P90
	0,		// Kevlar (not used)
	0,		// Kevlar + Helm (not used)
	0		// NVG (not used)
}

new const g_iBPAmmo[] =
{
	0,		// (unknown)
	52,		// P228
	0,		// SHIELD
	90,		// SCOUT
	0,		// HEGRENADE (not used)
	32,		// XM1014
	0,		// C4 (not used)
	100,		// MAC10
	90,		// AUG
	0,		// SMOKEGRENADE (not used)
	120,		// ELITE
	100,		// FIVESEVEN
	100,		// UMP45
	90,		// SG550
	90,		// GALIL
	90,		// FAMAS
	100,		// USP
	120,		// GLOCK18
	30,		// AWP
	120,		// MP5NAVY
	200,		// M249
	32,		// M3
	90,		// M4A1
	120,		// TMP
	90,		// G3SG1
	0,		// FLASHBANG (not used)
	35,		// DEAGLE
	90,		// SG552
	90,		// AK47
	0,		// KNIFE (not used)
	100,		// P90
	0,		// Kevlar (not used)
	0,		// Kevlar + Helm (not used)
	0		// NVG (not used)
}

#if FEATURE_BUY == true

new const g_iWeaponPrice[] =
{
	0,		// (unknown)
	600,		// P228
	10000,	// SHIELD
	6000,		// SCOUT
	300,		// HEGRENADE
	3000,		// XM1014
	12000,	// C4
	1400,		// MAC10
	3500,		// AUG
	100,		// SMOKEGRENADE
	1000,		// ELITE
	750,		// FIVESEVEN
	1700,		// UMP45
	6000,		// SG550
	2000,		// GALIL
	2250,		// FAMAS
	500,		// USP
	400,		// GLOCK18
	8000,		// AWP
	1500,		// MP5NAVY
	5000,		// M249
	1700,		// M3
	3100,		// M4A1
	1250,		// TMP
	7000,		// G3SG1
	200,		// FLASHBANG
	650,		// DEAGLE
	3500,		// SG552
	2500,		// AK47
	0,		// KNIFE (not used)
	2350,		// P90
	650,		// Kevlar
	1000,		// Kevlar + Helm
	1250		// NVG
}

#endif // FEATURE_BUY

#if FEATURE_BUY == true && FEATURE_ADRENALINE == true

new const g_iWeaponAdrenaline[] =
{
	0,		// (unknown)
	0,		// P228
	50,		// SHIELD
	50,		// SCOUT
	0,		// HEGRENADE
	0,		// XM1014
	200,		// C4
	0,		// MAC10
	0,		// AUG
	0,		// SMOKEGRENADE
	0,		// ELITE
	0,		// FIVESEVEN
	0,		// UMP45
	30,		// SG550
	0,		// GALIL
	0,		// FAMAS
	0,		// USP
	0,		// GLOCK18
	50,		// AWP
	0,		// MP5NAVY
	10,		// M249
	0,		// M3
	0,		// M4A1
	0,		// TMP
	30,		// G3SG1
	0,		// FLASHBANG
	0,		// DEAGLE
	0,		// SG552
	0,		// AK47
	0,		// KNIFE (not used)
	0,		// P90
	0,		// Kevlar
	0,		// Kevlar + Helm
	0		// NVG
}

#endif // FEATURE_ADRENALINE

new const Float:g_fWeaponRunSpeed[] = // CONFIGURABLE - weapon running speed (edit the numbers in the list)
{
	150.0,	// Zoomed speed with any weapon
	250.0,	// P228
	0.0,		// SHIELD (not used) 
	260.0,	// SCOUT
	250.0,	// HEGRENADE
	240.0,	// XM1014
	250.0,	// C4
	250.0,	// MAC10
	240.0,	// AUG
	250.0,	// SMOKEGRENADE
	250.0,	// ELITE
	250.0,	// FIVESEVEN
	250.0,	// UMP45
	210.0,	// SG550
	240.0,	// GALIL
	240.0,	// FAMAS
	250.0,	// USP
	250.0,	// GLOCK18
	210.0,	// AWP
	250.0,	// MP5NAVY
	220.0,	// M249
	230.0,	// M3
	230.0,	// M4A1
	250.0,	// TMP
	210.0,	// G3SG1
	250.0,	// FLASHBANG
	250.0,	// DEAGLE
	235.0,	// SG552
	221.0,	// AK47
	250.0,	// KNIFE
	245.0,	// P90
	0.0,		// Kevlar (not used)
	0.0,		// Kevlar + Helm (not used)
	0.0		// NVG (not used)
}

#if FEATURE_BUY == true

new const g_iWeaponSlot[] =
{
	0,		// none
	2,		// P228
	1,		// SHIELD
	1,		// SCOUT
	4,		// HEGRENADE
	1,		// XM1014
	5,		// C4
	1,		// MAC10
	1,		// AUG
	4,		// SMOKEGRENADE
	2,		// ELITE
	2,		// FIVESEVEN
	1,		// UMP45
	1,		// SG550
	1,		// GALIL
	1,		// FAMAS
	2,		// USP
	2,		// GLOCK18
	1,		// AWP
	1,		// MP5NAVY
	1,		// M249
	1,		// M3
	1,		// M4A1
	1,		// TMP
	1,		// G3SG1
	4,		// FLASHBANG
	2,		// DEAGLE
	1,		// SG552
	1,		// AK47
	3,		// KNIFE (not used)
	1,		// P90
	0,		// Kevlar
	0,		// Kevlar + Helm
	0		// NVG
}

#endif // FEATURE_BUY

new const g_szWeaponEntity[][24] =
{
	NULL,
	"weapon_p228",
	"weapon_shield",
	"weapon_scout",
	"weapon_hegrenade",
	"weapon_xm1014",
	"weapon_c4",
	"weapon_mac10",
	"weapon_aug",
	"weapon_smokegrenade",
	"weapon_elite",
	"weapon_fiveseven",
	"weapon_ump45",
	"weapon_sg550",
	"weapon_galil",
	"weapon_famas",
	"weapon_usp",
	"weapon_glock18",
	"weapon_awp",
	"weapon_mp5navy",
	"weapon_m249",
	"weapon_m3",
	"weapon_m4a1",
	"weapon_tmp",
	"weapon_g3sg1",
	"weapon_flashbang",
	"weapon_deagle",
	"weapon_sg552",
	"weapon_ak47",
	"weapon_knife",
	"weapon_p90",
	"item_kevlar",
	"item_assaultsuit",
	NULL
}

#if FEATURE_BUY == true

new const g_szWeaponCommands[][] =
{
	{NULL,		NULL},
	{"p228",		"228compact"},
	{"shield",		NULL},
	{"scout",		NULL},
	{"hegren",		NULL},
	{"xm1014",		"autoshotgun"},
	{NULL,		NULL},
	{"mac10",		NULL},
	{"aug",		"bullpup"},
	{"sgren",		NULL},
	{"elites",		NULL},
	{"fiveseven",	"fn57"},
	{"ump45",		"sm"},
	{"sg550",		"krieg550"},
	{"galil",		"defender"},
	{"famas",		"clarion"},
	{"usp",		"km45"},
	{"glock",		"9x19mm"},
	{"awp",		"magnum"},
	{"mp5",		"mp"},
	{"m249",		NULL},
	{"m3",		"12gauge"},
	{"m4a1",		NULL},
	{"tmp",		NULL},
	{"g3sg1",		"d3au1"},
	{"flash",		NULL},
	{"deagle",		"nighthawk"},
	{"sg552",		"krieg552"},
	{"ak47",		"cv47"},
	{NULL,		NULL},
	{"p90",		"c90"},
	{"vest",		NULL},
	{"vesthelm",	NULL},
	{"nvgs",		NULL}
}

#endif // FEATURE_BUY






new g_iMaxPlayers
new g_szMap[32]
new g_szGame[16]
new g_iTeam[33]
new g_iScore[3]
new g_iFlagHolder[3]
new g_iFlagEntity[3]
new g_iBaseEntity[3]
new Float:g_fFlagDropped[3]

#if FEATURE_BUY == true

new g_iMenu[33]
new g_iRebuy[33][8]
new g_iAutobuy[33][64]
new g_iRebuyWeapons[33][8]

new pCvar_ctf_nospam_flash
new pCvar_ctf_nospam_he
new pCvar_ctf_nospam_smoke
new pCvar_ctf_spawn_prim
new pCvar_ctf_spawn_sec
new pCvar_ctf_spawn_knife

new gMsg_BuyClose

#endif // FEATURE_BUY

new g_iMaxHealth[33]
new g_iAdrenaline[33]
new g_iAdrenalineUse[33][ADRENALINE_MAX+1]
new bool:g_bRestarting
new bool:g_bBot[33]
new bool:g_bAlive[33]
new bool:g_bDefuse[33]
new bool:g_bLights[33]
new bool:g_bBuyZone[33]
new bool:g_bSuicide[33]
new bool:g_bFreeLook[33]
new bool:g_bAssisted[33][3]
new bool:g_bProtected[33]
new bool:g_bRestarted[33]
new bool:g_bFirstSpawn[33]
new g_caca;

new Float:g_fFlagBase[3][3]
new Float:g_fFlagLocation[3][3]
new Float:g_fWeaponSpeed[33]
new Float:g_fLastDrop[33]
new Float:g_fLastBuy[33][4]

new pCvar_ctf_flagcaptureslay
new pCvar_ctf_flagheal
new pCvar_ctf_flagreturn
new pCvar_ctf_respawntime
new pCvar_ctf_protection
new pCvar_ctf_dynamiclights
new pCvar_ctf_glows
new pCvar_ctf_weaponstay
new pCvar_ctf_spawnmoney
new pCvar_ctf_itempercent

new pCvar_ctf_sound[4]
new pCvar_mp_startmoney
new pCvar_mp_fadetoblack
new pCvar_mp_forcecamera
new pCvar_mp_forcechasecam

#if FEATURE_C4 == true

new pCvar_mp_c4timer

new gMsg_BarTime
new gMsg_DeathMsg
new gMsg_SendAudio

#endif // FEATURE_C4

new gMsg_SayText
new gMsg_RoundTime
new gMsg_ScreenFade
new gMsg_HostageK
new gMsg_HostagePos
new gMsg_ScoreInfo
new gMsg_ScoreAttrib
new gMsg_TextMsg
new gMsg_TeamScore

new gHook_EntSpawn

#if FEATURE_ADRENALINE == true

new gSpr_trail
new gSpr_blood1
new gSpr_blood2

#endif // FEATURE_ADRENALINE

new gSpr_regeneration

new g_iForwardReturn
new g_iFW_flag


#if FEATURE_ORPHEU == true

new pCvar_ctf_infiniteround
new pCvar_ctf_flagendround

new g_pGameRules
new bool:g_bLinux
new OrpheuHook:g_oMapConditions
new OrpheuHook:g_oWinConditions
new OrpheuHook:g_oRoundTimeExpired
new MEMORY_ROUNDTIME[] = "roundTimeCheck"

#endif // FEATURE_ORPHEU

#define is_user_valid_connected(%1) 	(1 <= %1 <= g_iMaxPlayers && is_user_connected(%1))
#define is_user_valid_alive(%1)		(1 <= %1 <= g_iMaxPlayers && is_user_alive(%1))

public plugin_precache()
{
	precache_model(FLAG_MODEL)
	precache_model(ITEM_MODEL_AMMO)
	precache_model(ITEM_MODEL_MEDKIT)
	// precache_model(FLAG_MODEL_ONE_FLAG)

	precache_sound("warcraft3/frostnova.wav")
	
#if FEATURE_ADRENALINE == true

	precache_model(ITEM_MODEL_ADRENALINE)

	precache_sound(SND_GETADRENALINE)
	precache_sound(SND_ADRENALINE)

	gSpr_trail = precache_model("sprites/zbeam5.spr")
	gSpr_blood1 = precache_model("sprites/blood.spr")
	gSpr_blood2 = precache_model("sprites/bloodspray.spr")

#endif // FEATURE_ADRENALINE

	precache_sound(SND_GETAMMO)
	precache_sound(SND_GETMEDKIT)
	
	precache_sound("player/pl_pain6.wav");
	precache_sound("player/pl_pain7.wav");
	
	precache_sound("zp5/gk_toxic_bomb.wav")
	
	g_toxic_sprite[0] = precache_model("sprites/ctf/gas_red_1.spr");
	g_toxic_sprite[1] = precache_model("sprites/ctf/gas_blue_1.spr");
	
	gSpr_regeneration = precache_model("sprites/th_jctf_heal.spr")

	for(new szSound[64], i = 0; i < sizeof g_szSounds; i++)
	{
		for(new t = 1; t <= 2; t++)
		{
			formatex(szSound, charsmax(szSound), "sound/ctf/%s.mp3", g_szSounds[i][t])

			precache_generic(szSound)
		}
	}

#if FEATURE_C4 == true
	precache_sound(SND_C4DISARMED)

	new ent = entity_create(g_szRemoveEntities[11])

	if(ent)
	{
		DispatchKeyValue(ent, "buying", "0")
		DispatchKeyValue(ent, "bombradius", C4_RADIUS)
		DispatchSpawn(ent)
	}
#endif // FEATURE_C4

	gHook_EntSpawn = register_forward(FM_Spawn, "ent_spawn")


#if FEATURE_ORPHEU == true

	OrpheuRegisterHook(OrpheuGetFunction("InstallGameRules"), "game_onInstallGameRules", OrpheuHookPost)

#endif // FEATURE_ORPHEU
}

public ent_spawn(ent)
{
	if(!is_valid_ent(ent))
		return FMRES_IGNORED

	static szClass[32]

	entity_get_string(ent, EV_SZ_classname, szClass, charsmax(szClass))

	for(new i = 0; i < sizeof g_szRemoveEntities; i++)
	{
		if(equal(szClass, g_szRemoveEntities[i]))
		{
			entity_remove(ent)

			return FMRES_SUPERCEDE
		}
	}

	return FMRES_IGNORED
}

new g_message_teaminfo;

new g_player_solid[33];
new g_player_restore[33];

new g_ipsz_armoury_entity;
public plugin_init()
{
	register_plugin(MOD_TITLE, MOD_VERSION, MOD_AUTHOR)
	register_cvar("HideNSeek", "4.1", FCVAR_SERVER|FCVAR_SPONLY);
	// set_pcvar_string(register_cvar("jctf_version", MOD_VERSION, FCVAR_SERVER|FCVAR_SPONLY), MOD_VERSION)
	
	g_ipsz_armoury_entity = engfunc(EngFunc_AllocString, "armoury_entity")

	g_message_teaminfo = get_user_msgid("TeamInfo");
	
	register_dictionary("jctf.txt")
	register_dictionary("common.txt")
	
	g_restart_map = 1;
	g_restart_map_ob = 1;

	// new const SEPARATOR_TEMP[] = " - - - - - - - - - - - - - - - - -"

	// server_print(SEPARATOR_TEMP)
	// server_print("    %s - v%s", MOD_TITLE, MOD_VERSION)
	// server_print("    Mod by %s", MOD_AUTHOR)
	
	g_hud1 = CreateHudSyncObj();
	g_hud2 = CreateHudSyncObj();
	g_hud3 = CreateHudSyncObj();
	g_hud4 = CreateHudSyncObj();
	
	new sMap[64];
	get_mapname(sMap, 63);
	
	// register_forward(FM_Voice_SetClientListening, "fw_Voice_SetClientListening");
	
	if(equal(sMap, "de_rats"))
	{
		register_forward(FM_PlayerPreThink, "fw_PlayerPreThink");
		RegisterHam(Ham_Player_PostThink, "player", "fw_PlayerPostThink");
		register_forward(FM_AddToFullPack, "fw_AddToFullPack_Post", 1);
	}
	
// #if FEATURE_ORPHEU == false
	// server_print("[!] Orpheu module usage is disabled! (FEATURE_ORPHEU = false)")
// #endif

// #if FEATURE_BUY == false
	// server_print("[!] Custom buy feature is disabled! (FEATURE_BUY = false)")
// #endif

// #if FEATURE_C4 == false
	// server_print("[!] C4 feature is disabled! (FEATURE_BUYC4 = false)")
// #endif

// #if FEATURE_ADRENALINE == false
	// server_print("[!] Adrenaline feature is disabled! (FEATURE_ADRENALINE = false)")
// #endif

	// server_print(SEPARATOR_TEMP)

	// Forwards, hooks, events, etc

	unregister_forward(FM_Spawn, gHook_EntSpawn)
	register_forward(FM_ClientKill, "fw_ClientKill");

	// register_forward(FM_GetGameDescription, "game_description")

	register_touch(FLAG_CLASSNAME, PLAYER, "flag_touch")
	register_touch(FLAG_CLASSNAME_ONE_FLAG, PLAYER, "one_flag_touch")
	
	register_forward(FM_SetModel, "fw_SetModel");
	RegisterHam(Ham_Think, "grenade", "fw_ThinkGrenade");
	
	register_forward(FM_Touch, "forward_touch")
	
	new i;
	for(i = 1; i < sizeof WEAPONENTNAMES; i++)
	{
		if(WEAPONENTNAMES[i][0])
		{
			if(i == CSW_HEGRENADE || i == CSW_FLASHBANG || i == CSW_SMOKEGRENADE || i == CSW_C4 || i == CSW_KNIFE)
				continue;
			
			RegisterHam(Ham_Weapon_PrimaryAttack, WEAPONENTNAMES[i], "fw_Weapon_PrimaryAttack_Post", 1);
		}
	}

	register_think(FLAG_CLASSNAME, "flag_think")
	register_think(BASE_CLASSNAME, "base_think")
	
	register_think(FLAG_CLASSNAME_ONE_FLAG, "one_flag_think")
	
	g_StatusText = get_user_msgid("StatusText");

	register_event("30","event_intermission","a");
	register_logevent("event_restartGame", 2, "1&Restart_Round", "1&Game_Commencing")
	register_event("HLTV", "event_roundStart", "a", "1=0", "2=0")
	register_event( "StatusValue", "EventStatusValue", "b", "1>0", "2>0" );

	register_clcmd("fullupdate", "msg_block")

	register_event("TeamInfo", "player_joinTeam", "a")

	RegisterHam(Ham_Spawn, PLAYER, "player_spawn", 1)
	RegisterHam(Ham_Killed, PLAYER, "player_killed", 1)
	RegisterHam(Ham_TakeDamage, PLAYER, "player_damage")
	RegisterHam(Ham_Player_Jump, "player", "fw_PlayerJump");
	RegisterHam(Ham_Player_Duck, "player", "fw_PlayerDuck");

	register_clcmd("say", "player_cmd_say")
	register_clcmd("say_team", "player_cmd_sayTeam")
	
	register_concmd("ctf_adren", "cmd_adrenaline");
	register_concmd("ctf_money", "cmd_money");
	register_concmd("ctf_mode", "cmd_mode");
	
#if FEATURE_ADRENALINE == true

	register_clcmd("shop", "player_cmd_adrenaline")
	register_clcmd("chooseteam", "player_cmd_adrenaline2");
	register_clcmd("jointeam", "player_cmd_adrenaline2");
	
	register_clcmd("say /class", "clcmd_Class")
	
	register_clcmd("say /pos", "clcmd_Position")
	
	register_clcmd("say /maplist", "clcmd_Maps");
	register_clcmd("say_team /maplist", "clcmd_Maps");
	
	
#endif // FEATURE_ADRENALINE

#if FEATURE_BUY == true

	register_menucmd(register_menuid(MENU_BUY), MENU_KEYS_BUY, "player_key_buy")

	register_event("StatusIcon", "player_inBuyZone", "be", "2=buyzone")

	register_clcmd("buy", "player_cmd_buy_main")
	register_clcmd("buyammo1", "player_fillAmmo")
	register_clcmd("buyammo2", "player_fillAmmo")
	register_clcmd("primammo", "player_fillAmmo")
	register_clcmd("secammo", "player_fillAmmo")
	register_clcmd("client_buy_open", "player_cmd_buyVGUI")

	register_clcmd("autobuy", "player_cmd_autobuy")
	register_clcmd("cl_autobuy", "player_cmd_autobuy")
	register_clcmd("cl_setautobuy", "player_cmd_setAutobuy")

	register_clcmd("rebuy", "player_cmd_rebuy")
	register_clcmd("cl_rebuy", "player_cmd_rebuy")
	register_clcmd("cl_setrebuy", "player_cmd_setRebuy")

	register_clcmd("buyequip", "player_cmd_buy_equipament")

#endif // FEATURE_BUY

	for(new w = W_P228; w <= W_NVG; w++)
	{
#if FEATURE_BUY == true
		for(new i = 0; i < 2; i++)
		{
			if(strlen(g_szWeaponCommands[w][i]))
				register_clcmd(g_szWeaponCommands[w][i], "player_cmd_buyWeapon")
		}
#endif // FEATURE_BUY

		if(w != W_SHIELD && w <= W_P90)
			RegisterHam(Ham_Weapon_PrimaryAttack, g_szWeaponEntity[w], "player_useWeapon", 1)
	}

	register_clcmd("ctf_moveflag", "admin_cmd_moveFlag")
	register_clcmd("ctf_save", "admin_cmd_saveFlags")
	register_clcmd("ctf_return", "admin_cmd_returnFlag")

	//register_clcmd("soltarbandera", "player_cmd_dropFlag")

#if FEATURE_C4 == true

	//RegisterHam(Ham_Use, GRENADE, "c4_defuse", 1)
	register_logevent("c4_planted", 3, "2=Planted_The_Bomb")
	//register_logevent("c4_defused", 3, "2=Defused_The_Bomb")

	register_touch(WEAPONBOX, PLAYER, "c4_pickup")

#endif // FEATURE_C4

	register_touch(ITEM_CLASSNAME, PLAYER, "item_touch")

	register_event("CurWeapon", "player_currentWeapon", "be", "1=1")
	register_event("SetFOV", "player_currentWeapon", "be", "1>1")
	
	register_message(get_user_msgid("CurWeapon"), "message_cur_weapon");

	RegisterHam(Ham_Spawn, WEAPONBOX, "weapon_spawn", 1)

	RegisterHam(Ham_Weapon_SecondaryAttack, g_szWeaponEntity[W_KNIFE], "player_useWeapon", 1) // not a typo

#if FEATURE_ADRENALINE == true

	RegisterHam(Ham_Weapon_SecondaryAttack, g_szWeaponEntity[W_USP], "player_useWeaponSec", 1)
	RegisterHam(Ham_Weapon_SecondaryAttack, g_szWeaponEntity[W_FAMAS], "player_useWeaponSec", 1)
	RegisterHam(Ham_Weapon_SecondaryAttack, g_szWeaponEntity[W_M4A1], "player_useWeaponSec", 1)

#endif // FEATURE_ADRENALINE


#if FEATURE_C4 == true

	gMsg_BarTime = get_user_msgid("BarTime")
	gMsg_DeathMsg = get_user_msgid("DeathMsg")
	gMsg_SendAudio = get_user_msgid("SendAudio")

	register_message(gMsg_BarTime, "c4_used")
	register_message(gMsg_SendAudio, "msg_sendAudio")

#endif // FEATURE_C4

	register_message(get_user_msgid("Health"), "message_health");

	gMsg_HostagePos = get_user_msgid("HostagePos")
	gMsg_HostageK = get_user_msgid("HostageK")
	gMsg_RoundTime = get_user_msgid("RoundTime")
	gMsg_SayText = get_user_msgid("SayText")
	gMsg_ScoreInfo = get_user_msgid("ScoreInfo")
	gMsg_ScoreAttrib = get_user_msgid("ScoreAttrib")
	gMsg_ScreenFade = get_user_msgid("ScreenFade")
	gMsg_TextMsg = get_user_msgid("TextMsg")
	gMsg_TeamScore = get_user_msgid("TeamScore")

	register_message(gMsg_TextMsg, "msg_textMsg")
	register_message(get_user_msgid("BombDrop"), "msg_block")
	register_message(get_user_msgid("ClCorpse"), "msg_block")
	register_message(gMsg_HostageK, "msg_block")
	register_message(gMsg_HostagePos, "msg_block")
	register_message(gMsg_RoundTime, "msg_roundTime")
	register_message(gMsg_ScreenFade, "msg_screenFade")
	register_message(gMsg_ScoreAttrib, "msg_scoreAttrib")
	register_message(gMsg_TeamScore, "msg_teamScore")
	register_message(gMsg_SayText, "msg_sayText")

	// CVARS

	pCvar_ctf_flagcaptureslay = register_cvar("ctf_flagcaptureslay", "0")
	pCvar_ctf_flagheal = register_cvar("ctf_flagheal", "1")
	pCvar_ctf_flagreturn = register_cvar("ctf_flagreturn", "120")
	pCvar_ctf_respawntime = register_cvar("ctf_respawntime", "10")
	pCvar_ctf_protection = register_cvar("ctf_protection", "5")
	pCvar_ctf_dynamiclights = register_cvar("ctf_dynamiclights", "1")
	pCvar_ctf_glows = register_cvar("ctf_glows", "1")
	pCvar_ctf_weaponstay = register_cvar("ctf_weaponstay", "15")
	pCvar_ctf_spawnmoney = register_cvar("ctf_spawnmoney", "1000")
	pCvar_ctf_itempercent = register_cvar("ctf_itempercent", "25")

#if FEATURE_ORPHEU == true

	register_srvcmd("ctf_infiniteround", "server_cmd_infiniteround")

	pCvar_ctf_infiniteround = register_cvar("_ctf_infiniteround_memory", "1")
	pCvar_ctf_flagendround = register_cvar("ctf_flagendround", "0")

#endif // FEATURE_ORPHEU


#if FEATURE_BUY == true

	pCvar_ctf_nospam_flash = register_cvar("ctf_nospam_flash", "20")
	pCvar_ctf_nospam_he = register_cvar("ctf_nospam_he", "20")
	pCvar_ctf_nospam_smoke = register_cvar("ctf_nospam_smoke", "20")
	pCvar_ctf_spawn_prim = register_cvar("ctf_spawn_prim", "")
	pCvar_ctf_spawn_sec = register_cvar("ctf_spawn_sec", "glock")
	pCvar_ctf_spawn_knife = register_cvar("ctf_spawn_knife", "1")

	gMsg_BuyClose = get_user_msgid("BuyClose")

#endif // FEATURE_BUY

	pCvar_ctf_sound[EVENT_TAKEN] = register_cvar("ctf_sound_taken", "1")
	pCvar_ctf_sound[EVENT_DROPPED] = register_cvar("ctf_sound_dropped", "1")
	pCvar_ctf_sound[EVENT_RETURNED] = register_cvar("ctf_sound_returned", "1")
	pCvar_ctf_sound[EVENT_SCORE] = register_cvar("ctf_sound_score", "1")

#if FEATURE_C4 == true

	pCvar_mp_c4timer = get_cvar_pointer("mp_c4timer")

#endif // FEATURE_C4

	pCvar_mp_startmoney = get_cvar_pointer("mp_startmoney")
	pCvar_mp_fadetoblack = get_cvar_pointer("mp_fadetoblack")
	pCvar_mp_forcecamera = get_cvar_pointer("mp_forcecamera")
	pCvar_mp_forcechasecam = get_cvar_pointer("mp_forcechasecam")

	// Plugin's forwards

	g_iFW_flag = CreateMultiForward("jctf_flag", ET_IGNORE, FP_CELL, FP_CELL, FP_CELL, FP_CELL)


	// Variables

	new szGame[3]

	get_modname(szGame, charsmax(szGame))

	if(szGame[0] == 'c')
	{
		switch(szGame[1])
		{
			case 's': copy(g_szGame, charsmax(g_szGame), "CS 1.6 ") // leave the space at the end
			case 'z': copy(g_szGame, charsmax(g_szGame), "CS:CZ ")
		}
	}

	get_mapname(g_szMap, charsmax(g_szMap))

	g_iMaxPlayers = get_maxplayers()


#if FEATURE_C4 == true
	// fake bomb target

	new ent = entity_create(g_szRemoveEntities[2])

	if(ent)
	{
		entity_spawn(ent)
		entity_set_size(ent, Float:{-8192.0, -8192.0, -8192.0}, Float:{8192.0, 8192.0, 8192.0})
	}
#endif // FEATURE_C4

#if FEATURE_ORPHEU == true
	g_bLinux = bool:is_linux_server()

	state disabled

	game_enableForwards()
#endif // FEATURE_ORPHEU

	set_task(15.0, "checkTeams", _, _, _, "b");
	
	// for(i = 0; i < sizeof(MAPS_NAME_ONE_FLAG); ++i)
	// {
		// if(equali(sMap, MAPS_NAME_ONE_FLAG[i]))
		// {
			// set_task(10.0, "voteWarn");
			// set_task(15.0, "voteMode");
			// set_task(28.0, "voteModeEnd");
			
			// g_iMap = i;
			
			// break;
		// }
	// }
	
	set_task(30.0, "restartMap");
	
	loadMaps();
}

new g_vote_mode = 0;
new g_vote_mode_count[2];

public voteWarn()
{
	fn_CC(0, _, "!yEn 5s comenzará la votación, vota con cuidado");
	fn_CC(0, _, "!yEn 5s comenzará la votación, vota con cuidado");
	fn_CC(0, _, "!yEn 5s comenzará la votación, vota con cuidado");
	fn_CC(0, _, "!yEn 5s comenzará la votación, vota con cuidado");
}

public voteMode()
{
	static iMenuId;
	
	iMenuId = menu_create("ELIGE EL MODO", "menuMode");
	
	menu_additem(iMenuId, "MODO NORMAL^n", "1");
	menu_additem(iMenuId, "MODO UNA BANDERA", "2");
	
	menu_setprop(iMenuId, MPROP_EXITNAME, "No votar");
	
	new i;
	for(i = 1; i <= g_iMaxPlayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
			
		menu_display(i, iMenuId, 0);
	}
	
	g_vote_mode_count = {0, 0};
	
	g_vote_mode = 1;
}

public menuMode(const id, const menuid, const item)
{
	if(!is_user_connected(id))
	{
		menu_destroy(menuid);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid);
		return PLUGIN_HANDLED;
	}
	
	if(!g_vote_mode)
	{
		menu_destroy(menuid);
		return PLUGIN_HANDLED;
	}
	
	static sBuffer[3];
	static iDummy;
	
	menu_item_getinfo(menuid, item, iDummy, sBuffer, charsmax(sBuffer), _, _, iDummy);
	
	menu_destroy(menuid);
	
	switch(str_to_num(sBuffer))
	{
		case 1: ++g_vote_mode_count[0]
		case 2: ++g_vote_mode_count[1]
	}
	
	return PLUGIN_HANDLED;
}

public voteModeEnd()
{
	g_vote_mode = 0;
	
	if(g_vote_mode_count[0] > g_vote_mode_count[1])
	{
		fn_CC(0, _, "!yEl modo ganador es el modo !gNORMAL!y con %d votos, empezando partida...", g_vote_mode_count[0]);
	}
	else if(g_vote_mode_count[1] > g_vote_mode_count[0])
	{
		fn_CC(0, _, "!yEl modo ganador es el modo !gUNA BANDERA!y con %d votos, empezando partida...", g_vote_mode_count[1]);
		set_task(6.0, "startMode")
	}
	else
	{
		new iMode = random_num(0, 1);
		
		fn_CC(0, _, "!yHubo un empate (%d votos), el modo al azar es !g%s!y, empezando partida...", g_vote_mode_count[0], (iMode == 1) ? "UNA BANDERA" : "NORMAL");
		
		if(iMode == 1)
			set_task(6.0, "startMode")
	}
}

public startMode()
	startModeOneFlag();

public restartMap()
{
	g_restart_map = 0;
	
	set_hudmessage(0, 100, 200, 0.05, 0.65, 2, 0.02, 6.0, 0.01, 0.1, 2)
	show_hudmessage(0, "Comiencen a jugar!")
	
	set_cvar_float("sv_restart", 2.0)
}

enum
{
	FM_CS_TEAM_UNASSIGNED = 0,
	FM_CS_TEAM_T,
	FM_CS_TEAM_CT,
	FM_CS_TEAM_SPECTATOR
};

new const CS_TEAM_NAMES[][] = { "UNASSIGNED", "TERRORIST", "CT", "SPECTATOR" };
public checkTeams()
{
	new i;
	new iTs = 0;
	new iCTs = 0;
	new iTeam;
	
	for(i = 1; i <= g_iMaxPlayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		iTeam = getTeam(i);
		
		if(iTeam == FM_CS_TEAM_T)
			++iTs;
		else if(iTeam == FM_CS_TEAM_CT)
			++iCTs;
	}
	
	while(iTs != iCTs && (iTs != (iCTs+1)) && (iCTs != (iTs+1)))
	{
		if(iTs > iCTs)
		{
			if((iTs - 1) != iCTs)
			{
				new id;
				id = getUser(1);
				
				if(id == -1)
					break;
				
				if(!is_user_connected(id))
					break;
					
				--iTs;
				++iCTs;
				
				// set_pdata_int(id, 125, (get_pdata_int(id, 125, 5) & ~(1<<8)), 5);
				
				// g_team_balance[id] = 1;
				
				// engclient_cmd(id, "jointeam", "2");
				// engclient_cmd(id, "joinclass", "5");
				
				// set_user_frags(id, get_user_frags(id) + 1);
				
				cs_set_user_team(id, CS_TEAM_CT);
				set_pdata_int(id, 114, 2, 5);
				
				emessage_begin(MSG_ALL, g_message_teaminfo);
				ewrite_byte(id);
				ewrite_string(CS_TEAM_NAMES[getTeam(id)]);
				emessage_end();
				
				g_iTeam[id] = TEAM_BLUE;
				
				dllfunc(DLLFunc_Spawn, id);
				
				cs_reset_user_model(id);
				
				// message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("ShowMenu"), .player=id);
				// write_short(0);
				// write_char(0);
				// write_byte(0);
				// write_string("");
				// message_end();
				
				new sName[32];
				get_user_name(id, sName, 31);
				
				fn_CC(0, _, "!ySe ha transferido a !g%s!y al equipo !gCT!y", sName);
			}
		}
		else if(iCTs > iTs)
		{
			if((iCTs - 1) != iTs)
			{
				new id;
				id = getUser(2);
				
				if(id == -1)
					break;
				
				if(!is_user_connected(id))
					break;
				
				--iCTs;
				++iTs;
				
				// set_pdata_int(id, 125, (get_pdata_int(id, 125, 5) & ~(1<<8)), 5);
				
				// g_team_balance[id] = 1;
				
				// engclient_cmd(id, "jointeam", "1");
				// engclient_cmd(id, "joinclass", "5");
				
				// set_user_frags(id, get_user_frags(id) + 1);
				
				set_pdata_int(id, 114, 1, 5);
				cs_set_user_team(id, CS_TEAM_T);
				
				emessage_begin(MSG_ALL, g_message_teaminfo);
				ewrite_byte(id);
				ewrite_string(CS_TEAM_NAMES[getTeam(id)]);
				emessage_end();
				
				g_iTeam[id] = TEAM_RED;
				
				dllfunc(DLLFunc_Spawn, id);
				
				cs_reset_user_model(id);
				
				// message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("ShowMenu"), .player=id);
				// write_short(0);
				// write_char(0);
				// write_byte(0);
				// write_string("");
				// message_end();
				
				new sName[32];
				get_user_name(id, sName, 31);
				
				fn_CC(0, _, "!ySe ha transferido a !g%s!y al equipo !gT!y", sName);
			}
		}
	}
}

getUser(team)
{
	new iNoob = -1;
	new id;
	new iFirst = 0;

	for(id = 1; id <= g_iMaxPlayers; ++id)
	{
		if(!is_user_connected(id))
			continue;
		
		if(id == g_iFlagHolder[TEAM_RED] || id == g_iFlagHolder[TEAM_BLUE])
			continue;
		
		if(team == 1 && getTeam(id) != FM_CS_TEAM_T)
			continue;
		else if(team == 2 && getTeam(id) != FM_CS_TEAM_CT)
			continue;
		
		if(!iFirst)
		{
			iNoob = id;
			iFirst = 1;
			
			continue;
		}
		
		if(get_user_frags(id) >= get_user_frags(iNoob))
			continue;
		
		iNoob = id;
	}
	
	return iNoob;
}

stock getTeam(id)
{
	if(pev_valid(id) != 2)
		return FM_CS_TEAM_UNASSIGNED;
	
	return get_pdata_int(id, 114, 5);
}

#if FEATURE_ORPHEU == true

public game_onInstallGameRules()
	g_pGameRules = OrpheuGetReturn();

public game_enableForwards() <> {}
public game_enableForwards() <disabled>
{
	g_oMapConditions = OrpheuRegisterHook(OrpheuGetFunction("CheckMapConditions", "CHalfLifeMultiplay"), "game_blockConditions")
	g_oWinConditions = OrpheuRegisterHook(OrpheuGetFunction("CheckWinConditions", "CHalfLifeMultiplay"), "game_blockConditions")

	if(g_bLinux)
		g_oRoundTimeExpired = OrpheuRegisterHook(OrpheuGetFunction("HasRoundTimeExpired", "CHalfLifeMultiplay"), "game_blockConditions")
	else
		game_memoryReplace(MEMORY_ROUNDTIME, {0x90, 0x90, 0x90})

	state enabled
}

public game_disableForwards() <> {}
public game_disableForwards() <enabled>
{
	OrpheuUnregisterHook(g_oMapConditions)
	OrpheuUnregisterHook(g_oWinConditions)

	if(g_bLinux)
		OrpheuUnregisterHook(g_oRoundTimeExpired)
	else
		game_memoryReplace(MEMORY_ROUNDTIME, {0xF6, 0xC4, 0x41})

	state disabled
}

public OrpheuHookReturn:game_blockConditions() <>
	return OrpheuIgnored

public OrpheuHookReturn:game_blockConditions() <enabled>
{
	OrpheuSetReturn(false)

	return OrpheuSupercede
}

game_memoryReplace(szID[], const iBytes[], const iLen = sizeof iBytes)
{
	new iAddress

	OrpheuMemoryGet(szID, iAddress)

	for(new i; i < iLen; i++)
	{
		OrpheuMemorySetAtAddress(iAddress, "roundTimeCheck|dummy", 1, iBytes[i], iAddress)

		iAddress++
	}

	server_cmd("sv_restart 1")
}

public server_cmd_infiniteround()
{
	if(read_argc() == 2)
	{
		new szArg[2]

		read_argv(1, szArg, charsmax(szArg))

		new iSet = clamp(str_to_num(szArg), 0, 1)

		set_pcvar_num(pCvar_ctf_infiniteround, iSet)

		switch(iSet)
		{
			case 0: game_disableForwards()
			case 1: game_enableForwards()
		}
	}
	else
		server_print("^"ctf_infiniteround^" is ^"%d^"", get_pcvar_num(pCvar_ctf_infiniteround))
}

#endif // FEATURE_ORPHEU

// public game_description()
// {
	// new szFormat[32]

	// formatex(szFormat, charsmax(szFormat), "%sjCTF v%s", g_szGame, MOD_VERSION)
	// forward_return(FMV_STRING, szFormat)

	// return FMRES_SUPERCEDE
// }

public plugin_cfg()
{
	new szFile[64]

	formatex(szFile, charsmax(szFile), FLAG_SAVELOCATION, g_szMap)

	new hFile = fopen(szFile, "rt")

	if(hFile)
	{
		new iFlagTeam = TEAM_RED
		new szData[24]
		new szOrigin[3][6]

		while(fgets(hFile, szData, charsmax(szData)))
		{
			if(iFlagTeam > TEAM_BLUE)
				break

			trim(szData)
			parse(szData, szOrigin[x], charsmax(szOrigin[]), szOrigin[y], charsmax(szOrigin[]), szOrigin[z], charsmax(szOrigin[]))

			g_fFlagBase[iFlagTeam][x] = str_to_float(szOrigin[x])
			g_fFlagBase[iFlagTeam][y] = str_to_float(szOrigin[y])
			g_fFlagBase[iFlagTeam][z] = str_to_float(szOrigin[z])

			iFlagTeam++
		}

		fclose(hFile)
	}

	flag_spawn(TEAM_RED)
	flag_spawn(TEAM_BLUE)

	set_task(6.5, "plugin_postCfg")
}

public plugin_postCfg()
{
	set_cvar_num("mp_freezetime", 0)
	set_cvar_num("mp_limitteams", 0)
	set_cvar_num("mp_buytime", 99999999)
	server_cmd("sv_restart 1")
}

public plugin_natives()
{
	register_library("jctf")

	register_native("jctf_get_team", "native_get_team")
	register_native("jctf_get_flagcarrier", "native_get_flagcarrier")
	register_native("jctf_get_adrenaline", "native_get_adrenaline")
	register_native("jctf_add_adrenaline", "native_add_adrenaline")
}

public plugin_end()
{
#if FEATURE_ORPHEU == true

	game_disableForwards()

#endif // FEATURE_ORPHEU

	DestroyForward(g_iFW_flag)
}








public native_get_team(iPlugin, iParams)
{
	/* jctf_get_team(id) */

	return g_iTeam[get_param(1)]
}

public native_get_flagcarrier(iPlugin, iParams)
{
	/* jctf_get_flagcarrier(id) */

	new id = get_param(1)

	return g_iFlagHolder[get_opTeam(g_iTeam[id])] == id
}

public native_get_adrenaline(iPlugin, iParams)
{
#if FEATURE_ADRENALINE == true

	/* jctf_get_adrenaline(id) */

	return g_iAdrenaline[get_param(1)]

#else // FEATURE_ADRENALINE

	log_error(AMX_ERR_NATIVE, "jctf_get_adrenaline() does not work ! main jCTF plugin has FEATURE_ADRENALINE = false") 

	return 0

#endif // FEATURE_ADRENALINE
}

public native_add_adrenaline(iPlugin, iParams)
{
#if FEATURE_ADRENALINE == true

	/* jctf_add_adrenaline(id, iAdd, szReason[]) */

	new id = get_param(1)
	new iAdd = get_param(2)
	new szReason[64]

	get_string(3, szReason, charsmax(szReason))

	if(strlen(szReason))
		player_award(id, 0, 0, 0, iAdd, szReason)

	else
	{
		g_iAdrenaline[id] = clamp(g_iAdrenaline[id] + iAdd, 0, 200)

		player_hudAdrenaline(id)
	}

	return g_iAdrenaline[id]

#else // FEATURE_ADRENALINE

	log_error(AMX_ERR_NATIVE, "jctf_add_adrenaline() does not work ! main jCTF plugin has FEATURE_ADRENALINE = false") 

	return 0

#endif // FEATURE_ADRENALINE
}











public flag_spawn(iFlagTeam)
{
	if(g_fFlagBase[iFlagTeam][x] == 0.0 && g_fFlagBase[iFlagTeam][y] == 0.0 && g_fFlagBase[iFlagTeam][z] == 0.0)
	{
		new iFindSpawn = find_ent_by_class(g_iMaxPlayers, iFlagTeam == TEAM_BLUE ? "info_player_start" : "info_player_deathmatch")

		if(iFindSpawn)
		{
			entity_get_vector(iFindSpawn, EV_VEC_origin, g_fFlagBase[iFlagTeam])

			server_print("[CTF] %s flag origin not defined, set on player spawn.", g_szTeamName[iFlagTeam])
			log_error(AMX_ERR_NOTFOUND, "[CTF] %s flag origin not defined, set on player spawn.", g_szTeamName[iFlagTeam])
		}
		else
		{
			server_print("[CTF] WARNING: player spawn for ^"%s^" team does not exist !", g_szTeamName[iFlagTeam])
			log_error(AMX_ERR_NOTFOUND, "[CTF] WARNING: player spawn for ^"%s^" team does not exist !", g_szTeamName[iFlagTeam])
			set_fail_state("Player spawn unexistent!")

			return PLUGIN_CONTINUE
		}
	}
	else
		server_print("[CTF] %s flag and base spawned at: %.1f %.1f %.1f", g_szTeamName[iFlagTeam], g_fFlagBase[iFlagTeam][x], g_fFlagBase[iFlagTeam][y], g_fFlagBase[iFlagTeam][z])

	new ent
	new Float:fGameTime = get_gametime()

	// the FLAG

	ent = entity_create(INFO_TARGET)

	if(!ent)
		return flag_spawn(iFlagTeam)

	entity_set_model(ent, FLAG_MODEL)
	entity_set_string(ent, EV_SZ_classname, FLAG_CLASSNAME)
	entity_set_int(ent, EV_INT_body, iFlagTeam)
	entity_set_int(ent, EV_INT_sequence, FLAG_ANI_STAND)
	entity_spawn(ent)
	entity_set_origin(ent, g_fFlagBase[iFlagTeam])
	entity_set_size(ent, FLAG_HULL_MIN, FLAG_HULL_MAX)
	entity_set_vector(ent, EV_VEC_velocity, FLAG_SPAWN_VELOCITY)
	entity_set_vector(ent, EV_VEC_angles, FLAG_SPAWN_ANGLES)
	entity_set_edict(ent, EV_ENT_aiment, 0)
	entity_set_int(ent, EV_INT_movetype, MOVETYPE_TOSS)
	entity_set_int(ent, EV_INT_solid, SOLID_TRIGGER)
	entity_set_float(ent, EV_FL_gravity, 2.0)
	entity_set_float(ent, EV_FL_nextthink, fGameTime + FLAG_THINK)
	
	/*if(iFlagTeam == TEAM_RED)
		fm_set_rendering(ent, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 16);
	else
		fm_set_rendering(ent, kRenderFxGlowShell, 0, 0, 255, kRenderNormal, 16);*/
	
	g_iFlagEntity[iFlagTeam] = ent
	g_iFlagHolder[iFlagTeam] = FLAG_HOLD_BASE

	// flag BASE

	ent = entity_create(INFO_TARGET)

	if(!ent)
		return flag_spawn(iFlagTeam)

	entity_set_string(ent, EV_SZ_classname, BASE_CLASSNAME)
	entity_set_model(ent, FLAG_MODEL)
	entity_set_int(ent, EV_INT_body, 0)
	entity_set_int(ent, EV_INT_sequence, FLAG_ANI_BASE)
	entity_spawn(ent)
	entity_set_origin(ent, g_fFlagBase[iFlagTeam])
	entity_set_vector(ent, EV_VEC_velocity, FLAG_SPAWN_VELOCITY)
	entity_set_int(ent, EV_INT_movetype, MOVETYPE_TOSS)

	if(get_pcvar_num(pCvar_ctf_glows))
		entity_set_int(ent, EV_INT_renderfx, kRenderFxGlowShell)

	entity_set_float(ent, EV_FL_renderamt, 100.0)
	entity_set_float(ent, EV_FL_nextthink, fGameTime + BASE_THINK)

	if(iFlagTeam == TEAM_RED)
		entity_set_vector(ent, EV_VEC_rendercolor, Float:{255.0, 0.0, 0.0})
	else
		entity_set_vector(ent, EV_VEC_rendercolor, Float:{0.0, 0.0, 255.0})

	g_iBaseEntity[iFlagTeam] = ent

	return PLUGIN_CONTINUE
}

public flag_think(ent)
{
	if(!is_valid_ent(ent))
		return
	
	if(g_mode == MODE_ONE_FLAG)
		return;

	entity_set_float(ent, EV_FL_nextthink, get_gametime() + FLAG_THINK)

	static id
	static iStatus
	static iFlagTeam
	static iSkip[3]
	static Float:fOrigin[3]
	static Float:fPlayerOrigin[3]

	iFlagTeam = (ent == g_iFlagEntity[TEAM_BLUE] ? TEAM_BLUE : TEAM_RED)

	if(g_iFlagHolder[iFlagTeam] == FLAG_HOLD_BASE)
		fOrigin = g_fFlagBase[iFlagTeam]
	else
		entity_get_vector(ent, EV_VEC_origin, fOrigin)

	g_fFlagLocation[iFlagTeam] = fOrigin

	iStatus = 0

	if(++iSkip[iFlagTeam] >= FLAG_SKIPTHINK)
	{
		iSkip[iFlagTeam] = 0

		if(1 <= g_iFlagHolder[iFlagTeam] <= g_iMaxPlayers)
		{
			id = g_iFlagHolder[iFlagTeam]

			set_hudmessage(HUD_HELP_ONE_FLAG)
			ShowSyncHudMsg(id, g_hud1, "%L", id, "HUD_YOUHAVEFLAG")

			iStatus = 1
		}
		else if(g_iFlagHolder[iFlagTeam] == FLAG_HOLD_DROPPED)
			iStatus = 2

		message_begin(MSG_BROADCAST, gMsg_HostagePos)
		write_byte(0)
		write_byte(iFlagTeam)
		engfunc(EngFunc_WriteCoord, fOrigin[x])
		engfunc(EngFunc_WriteCoord, fOrigin[y])
		engfunc(EngFunc_WriteCoord, fOrigin[z])
		message_end()

		message_begin(MSG_BROADCAST, gMsg_HostageK)
		write_byte(iFlagTeam)
		message_end()

		static iStuck[3]

		if(g_iFlagHolder[iFlagTeam] >= FLAG_HOLD_BASE && !(entity_get_int(ent, EV_INT_flags) & FL_ONGROUND))
		{
			if(++iStuck[iFlagTeam] > 4)
			{
				flag_autoReturn(ent)

				log_message("^"%s^" flag is outside world, auto-returned.", g_szTeamName[iFlagTeam])

				return
			}
		}
		else
			iStuck[iFlagTeam] = 0
	}

	for(id = 1; id <= g_iMaxPlayers; id++)
	{
		if(g_iTeam[id] == TEAM_NONE || g_bBot[id])
			continue

		/* Check flag proximity for pickup */
		if(g_iFlagHolder[iFlagTeam] >= FLAG_HOLD_BASE)
		{
			entity_get_vector(id, EV_VEC_origin, fPlayerOrigin)

			if(get_distance_f(fOrigin, fPlayerOrigin) <= FLAG_PICKUPDISTANCE)
				flag_touch(ent, id)
		}

		/* Send dynamic lights to players that have them enabled */
		if(g_iFlagHolder[iFlagTeam] != FLAG_HOLD_BASE && g_bLights[id])
		{
			message_begin(MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, _, id)
			write_byte(TE_DLIGHT)
			engfunc(EngFunc_WriteCoord, fOrigin[x])
			engfunc(EngFunc_WriteCoord, fOrigin[y])
			engfunc(EngFunc_WriteCoord, fOrigin[z] + (g_iFlagHolder[iFlagTeam] == FLAG_HOLD_DROPPED ? 32 : -16))
			write_byte(FLAG_LIGHT_RANGE)
			write_byte(iFlagTeam == TEAM_RED ? 100 : 0)
			write_byte(0)
			write_byte(iFlagTeam == TEAM_BLUE ? 155 : 0)
			write_byte(FLAG_LIGHT_LIFE)
			write_byte(FLAG_LIGHT_DECAY)
			message_end()
		}

		/* If iFlagTeam's flag is stolen or dropped, constantly warn team players */
		if(iStatus && g_iTeam[id] == iFlagTeam)
		{
			set_hudmessage(HUD_HELP2)
			ShowSyncHudMsg(id, g_hud2, "%L", id, (iStatus == 1 ? "HUD_ENEMYHASFLAG" : "HUD_RETURNYOURFLAG"))
		}
	}
}

public one_flag_think(ent)
{
	if(!is_valid_ent(ent))
		return
	
	if(g_mode != MODE_ONE_FLAG)
		return;

	entity_set_float(ent, EV_FL_nextthink, get_gametime() + FLAG_THINK)

	static id
	static iStatus
	static iFlagTeam
	static iSkip[3]
	static Float:fOrigin[3]
	static Float:fPlayerOrigin[3]
	static whoIsFlag;
	
	iFlagTeam = 0;

	entity_get_vector(ent, EV_VEC_origin, fOrigin)
	g_fFlagLocation[iFlagTeam] = fOrigin

	iStatus = 0

	if(++iSkip[iFlagTeam] >= FLAG_SKIPTHINK)
	{
		iSkip[iFlagTeam] = 0

		if(1 <= g_iFlagHolder[iFlagTeam] <= g_iMaxPlayers)
		{
			id = g_iFlagHolder[iFlagTeam]
			whoIsFlag = id;

			set_hudmessage(HUD_HELP_ONE_FLAG)
			ShowSyncHudMsg(id, g_hud1, "%L", id, "HUD_YOUHAVEFLAG")

			iStatus = 1
		}
		else if(g_iFlagHolder[iFlagTeam] == FLAG_HOLD_DROPPED)
			iStatus = 2

		message_begin(MSG_BROADCAST, gMsg_HostagePos)
		write_byte(0)
		write_byte(iFlagTeam)
		engfunc(EngFunc_WriteCoord, fOrigin[x])
		engfunc(EngFunc_WriteCoord, fOrigin[y])
		engfunc(EngFunc_WriteCoord, fOrigin[z])
		message_end()

		message_begin(MSG_BROADCAST, gMsg_HostageK)
		write_byte(iFlagTeam)
		message_end()

		static iStuck[3]

		if(g_iFlagHolder[iFlagTeam] >= FLAG_HOLD_BASE && !(entity_get_int(ent, EV_INT_flags) & FL_ONGROUND))
		{
			if(++iStuck[iFlagTeam] > 4)
			{
				flag_autoReturn(ent)

				log_message("^"%s^" flag is outside world, auto-returned.", g_szTeamName[iFlagTeam])

				return
			}
		}
		else
			iStuck[iFlagTeam] = 0
	}

	for(id = 1; id <= g_iMaxPlayers; id++)
	{
		if(g_iTeam[id] == TEAM_NONE || g_bBot[id])
			continue

		/* Check flag proximity for pickup */
		if(g_iFlagHolder[iFlagTeam] >= FLAG_HOLD_BASE)
		{
			entity_get_vector(id, EV_VEC_origin, fPlayerOrigin)

			if(get_distance_f(fOrigin, fPlayerOrigin) <= FLAG_PICKUPDISTANCE)
				one_flag_touch(ent, id)
		}

		/* Send dynamic lights to players that have them enabled */
		if(g_iFlagHolder[iFlagTeam] != FLAG_HOLD_BASE && g_bLights[id])
		{
			message_begin(MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, _, id)
			write_byte(TE_DLIGHT)
			engfunc(EngFunc_WriteCoord, fOrigin[x])
			engfunc(EngFunc_WriteCoord, fOrigin[y])
			engfunc(EngFunc_WriteCoord, fOrigin[z] + (g_iFlagHolder[iFlagTeam] == FLAG_HOLD_DROPPED ? 32 : -16))
			write_byte(FLAG_LIGHT_RANGE)
			write_byte(255)
			write_byte(255)
			write_byte(255)
			write_byte(FLAG_LIGHT_LIFE)
			write_byte(FLAG_LIGHT_DECAY)
			message_end()
		}

		/* If iFlagTeam's flag is stolen or dropped, constantly warn team players */
		if(iStatus && g_iTeam[id] != g_iTeam[whoIsFlag])
		{
			set_hudmessage(HUD_HELP2)
			ShowSyncHudMsg(id, g_hud2, "%L", id, (iStatus == 1 ? "HUD_ENEMYHASFLAG_ONE_FLAG" : "HUD_RETURNYOURFLAG_ONE_FLAG"))
		}
	}
}

flag_sendHome(iFlagTeam)
{
	new ent = g_iFlagEntity[iFlagTeam]

	entity_set_edict(ent, EV_ENT_aiment, 0)
	
	if(g_mode != MODE_ONE_FLAG)
		entity_set_origin(ent, g_fFlagBase[iFlagTeam])
	else
	{
		set_pev(ent, pev_origin, MAPS_ONE_FLAG[g_iMap]);
	}
	
	entity_set_int(ent, EV_INT_sequence, FLAG_ANI_STAND)
	entity_set_int(ent, EV_INT_movetype, MOVETYPE_TOSS)
	entity_set_int(ent, EV_INT_solid, SOLID_TRIGGER)
	entity_set_vector(ent, EV_VEC_velocity, FLAG_SPAWN_VELOCITY)
	entity_set_vector(ent, EV_VEC_angles, FLAG_SPAWN_ANGLES)

	g_iFlagHolder[iFlagTeam] = FLAG_HOLD_BASE
}

flag_take(iFlagTeam, id)
{
	if(g_bProtected[id])
		player_removeProtection(id, "PROTECTION_TOUCHFLAG")

	new ent = g_iFlagEntity[iFlagTeam]

	entity_set_edict(ent, EV_ENT_aiment, id)
	entity_set_int(ent, EV_INT_movetype, MOVETYPE_FOLLOW)
	entity_set_int(ent, EV_INT_solid, SOLID_NOT)

	g_iFlagHolder[iFlagTeam] = id

	message_begin(MSG_BROADCAST, gMsg_ScoreAttrib)
	write_byte(id)
	write_byte(g_iTeam[id] == TEAM_BLUE ? 4 : 2)
	message_end()

	player_updateSpeed(id)
}

public flag_touch(ent, id)
{
#if FLAG_IGNORE_BOTS == true

	if(!g_bAlive[id] || g_bBot[id])
		return

#else // FLAG_IGNORE_BOTS

	if(!g_bAlive[id])
		return

#endif // FLAG_IGNORE_BOTS
	
	if(g_restart_map_ob)
		return;

	if(g_mode == MODE_ONE_FLAG)
	{
		if(!is_user_alive(g_iFlagHolder[0]))
			return;
		
		new iFlag;
		iFlag = entity_get_int(ent, EV_INT_body);
		
		new Float:fGameTime = get_gametime()
		
		if(iFlag == TEAM_RED)
		{
			if(g_iTeam[id] == TEAM_RED && g_iFlagHolder[0] == id)
			{
				new szName[32];
				get_user_name(id, szName, 31);
				
				message_begin(MSG_BROADCAST, gMsg_ScoreAttrib)
				write_byte(id)
				write_byte(0)
				message_end()

				player_award(id, 0, REWARD_CAPTURE, "%L", id, "REWARD_CAPTURE_ONE_FLAG")
				
				ExecuteForward(g_iFW_flag, g_iForwardReturn, FLAG_CAPTURED, id, 0, false)

				new iAssists = 0

				for(new i = 1; i <= g_iMaxPlayers; i++)
				{
					if(i != id && g_iTeam[i] > 0 && g_iTeam[i] == g_iTeam[id])
					{
						if(g_bAssisted[i][0])
						{
							player_award(i, 0, REWARD_CAPTURE_ASSIST, "%L", i, "REWARD_CAPTURE_ASSIST_ONE_FLAG")

							ExecuteForward(g_iFW_flag, g_iForwardReturn, FLAG_CAPTURED, i, 0, true)

							iAssists++
						}
						else
							player_award(i, 0, REWARD_CAPTURE_TEAM, "%L", i, "REWARD_CAPTURE_TEAM_ONE_FLAG")
					}

					g_bAssisted[i][0] = false
				}

				set_hudmessage(HUD_HELP)
				ShowSyncHudMsg(id, g_hud1, "%L", id, "HUD_CAPTUREDFLAG_ONE")

				if(iAssists)
				{
					new szFormat[64]

					format(szFormat, charsmax(szFormat), "%s + %d asistencia", szName, iAssists)

					game_announce(EVENT_SCORE, 0, szFormat, TEAM_RED)
				}
				else
					game_announce(EVENT_SCORE, 0, szName, TEAM_RED)

				emessage_begin(MSG_BROADCAST, gMsg_TeamScore)
				ewrite_string(g_szCSTeams[TEAM_RED])
				ewrite_short(++g_iScore[TEAM_RED])
				emessage_end()

				flag_sendHome(0)

				player_updateSpeed(id)

				g_fLastDrop[id] = fGameTime + 3.0

				if(g_bProtected[id])
					player_removeProtection(id, "PROTECTION_TOUCHFLAG")
				else
					player_updateRender(id)
				
				new iDif = 0;
				if(g_iScore[TEAM_RED] > g_iScore[TEAM_BLUE])
				{
					iDif = g_iScore[TEAM_RED] - g_iScore[TEAM_BLUE];
				}
				else if(g_iScore[TEAM_RED] < g_iScore[TEAM_BLUE])
				{
					iDif = g_iScore[TEAM_BLUE] - g_iScore[TEAM_RED];
				}
				
				if(iDif >= 10)
				{
					emessage_begin(MSG_ALL, SVC_INTERMISSION);
					emessage_end();
					
					//server_cmd("changelevel %s", g_nextmap);

					return
				}
			}
		}
		else if(iFlag == TEAM_BLUE)
		{
			if(g_iTeam[id] == TEAM_BLUE && g_iFlagHolder[0] == id)
			{
				new szName[32];
				get_user_name(id, szName, 31);
				
				message_begin(MSG_BROADCAST, gMsg_ScoreAttrib)
				write_byte(id)
				write_byte(0)
				message_end()

				player_award(id, 0, REWARD_CAPTURE, "%L", id, "REWARD_CAPTURE_ONE_FLAG")
				
				ExecuteForward(g_iFW_flag, g_iForwardReturn, FLAG_CAPTURED, id, 0, false)

				new iAssists = 0

				for(new i = 1; i <= g_iMaxPlayers; i++)
				{
					if(i != id && g_iTeam[i] > 0 && g_iTeam[i] == g_iTeam[id])
					{
						if(g_bAssisted[i][0])
						{
							player_award(i, 0, REWARD_CAPTURE_ASSIST, "%L", i, "REWARD_CAPTURE_ASSIST_ONE_FLAG")

							ExecuteForward(g_iFW_flag, g_iForwardReturn, FLAG_CAPTURED, i, 0, true)

							iAssists++
						}
						else
							player_award(i, 0, REWARD_CAPTURE_TEAM, "%L", i, "REWARD_CAPTURE_TEAM_ONE_FLAG")
					}

					g_bAssisted[i][0] = false
				}

				set_hudmessage(HUD_HELP)
				ShowSyncHudMsg(id, g_hud1, "%L", id, "HUD_CAPTUREDFLAG_ONE")

				if(iAssists)
				{
					new szFormat[64]

					format(szFormat, charsmax(szFormat), "%s + %d asistencia", szName, iAssists)

					game_announce(EVENT_SCORE, 0, szFormat, TEAM_BLUE)
				}
				else
					game_announce(EVENT_SCORE, 0, szName, TEAM_BLUE)

				emessage_begin(MSG_BROADCAST, gMsg_TeamScore)
				ewrite_string(g_szCSTeams[TEAM_BLUE])
				ewrite_short(++g_iScore[TEAM_BLUE])
				emessage_end()

				flag_sendHome(0)

				player_updateSpeed(id)

				g_fLastDrop[id] = fGameTime + 3.0

				if(g_bProtected[id])
					player_removeProtection(id, "PROTECTION_TOUCHFLAG")
				else
					player_updateRender(id)
				
				new iDif = 0;
				if(g_iScore[TEAM_RED] > g_iScore[TEAM_BLUE])
				{
					iDif = g_iScore[TEAM_RED] - g_iScore[TEAM_BLUE];
				}
				else if(g_iScore[TEAM_RED] < g_iScore[TEAM_BLUE])
				{
					iDif = g_iScore[TEAM_BLUE] - g_iScore[TEAM_RED];
				}
				
				if(iDif >= 10)
				{
					emessage_begin(MSG_ALL, SVC_INTERMISSION);
					emessage_end();

					//server_cmd("changelevel %s", g_nextmap);
					
					return
				}
			}
		}
		
		return
	}

	new iFlagTeam = (g_iFlagEntity[TEAM_BLUE] == ent ? TEAM_BLUE : TEAM_RED)

	if(1 <= g_iFlagHolder[iFlagTeam] <= g_iMaxPlayers) // if flag is carried we don't care
		return

	new Float:fGameTime = get_gametime()

	if(g_fLastDrop[id] > fGameTime)
		return

	new iTeam = g_iTeam[id]

	if(!(TEAM_RED <= g_iTeam[id] <= TEAM_BLUE))
		return

	new iFlagTeamOp = get_opTeam(iFlagTeam)
	new szName[32]

	get_user_name(id, szName, charsmax(szName))

	if(iTeam == iFlagTeam) // If the PLAYER is on the same team as the FLAG
	{
		if(g_iFlagHolder[iFlagTeam] == FLAG_HOLD_DROPPED) // if the team's flag is dropped, return it to base
		{
			flag_sendHome(iFlagTeam)

			remove_task(ent)

			player_award(id, 0, REWARD_RETURN, "%L", id, "REWARD_RETURN")

			ExecuteForward(g_iFW_flag, g_iForwardReturn, FLAG_RETURNED, id, iFlagTeam, false)

			new iAssists = 0

			for(new i = 1; i <= g_iMaxPlayers; i++)
			{
				if(i != id && g_bAssisted[i][iFlagTeam] && g_iTeam[i] == iFlagTeam)
				{
					player_award(i, 0, REWARD_RETURN_ASSIST, "%L", i, "REWARD_RETURN_ASSIST")

					ExecuteForward(g_iFW_flag, g_iForwardReturn, FLAG_RETURNED, i, iFlagTeam, true)

					iAssists++
				}

				g_bAssisted[i][iFlagTeam] = false
			}

			if(1 <= g_iFlagHolder[iFlagTeamOp] <= g_iMaxPlayers)
				g_bAssisted[id][iFlagTeamOp] = true

			if(iAssists)
			{
				new szFormat[64]

				format(szFormat, charsmax(szFormat), "%s + %d asistencia", szName, iAssists)

				game_announce(EVENT_RETURNED, iFlagTeam, szFormat)
			}
			else
				game_announce(EVENT_RETURNED, iFlagTeam, szName)

			log_message("<%s>%s returned the ^"%s^" flag.", g_szTeamName[iTeam], szName, g_szTeamName[iFlagTeam])

			set_hudmessage(HUD_HELP)
			ShowSyncHudMsg(id, g_hud1, "%L", id, "HUD_RETURNEDFLAG")

			if(g_bProtected[id])
				player_removeProtection(id, "PROTECTION_TOUCHFLAG")
		}
		else if(g_iFlagHolder[iFlagTeam] == FLAG_HOLD_BASE && g_iFlagHolder[iFlagTeamOp] == id) // if the PLAYER has the ENEMY FLAG and the FLAG is in the BASE make SCORE
		{
			message_begin(MSG_BROADCAST, gMsg_ScoreAttrib)
			write_byte(id)
			write_byte(0)
			message_end()

			player_award(id, 0, REWARD_CAPTURE, "%L", id, "REWARD_CAPTURE")
			
			ExecuteForward(g_iFW_flag, g_iForwardReturn, FLAG_CAPTURED, id, iFlagTeamOp, false)

			new iAssists = 0

			for(new i = 1; i <= g_iMaxPlayers; i++)
			{
				if(i != id && g_iTeam[i] > 0 && g_iTeam[i] == iTeam)
				{
					if(g_bAssisted[i][iFlagTeamOp])
					{
						player_award(i, 0, REWARD_CAPTURE_ASSIST, "%L", i, "REWARD_CAPTURE_ASSIST")

						ExecuteForward(g_iFW_flag, g_iForwardReturn, FLAG_CAPTURED, i, iFlagTeamOp, true)

						iAssists++
					}
					else
						player_award(i, 0, REWARD_CAPTURE_TEAM, "%L", i, "REWARD_CAPTURE_TEAM")
				}

				g_bAssisted[i][iFlagTeamOp] = false
			}

			set_hudmessage(HUD_HELP)
			ShowSyncHudMsg(id, g_hud1, "%L", id, "HUD_CAPTUREDFLAG")

			if(iAssists)
			{
				new szFormat[64]

				format(szFormat, charsmax(szFormat), "%s + %d asistencia", szName, iAssists)

				game_announce(EVENT_SCORE, iFlagTeam, szFormat)
			}
			else
				game_announce(EVENT_SCORE, iFlagTeam, szName)

			log_message("<%s>%s captured the ^"%s^" flag. (%d asistencia)", g_szTeamName[iTeam], szName, g_szTeamName[iFlagTeamOp], iAssists)

			emessage_begin(MSG_BROADCAST, gMsg_TeamScore)
			ewrite_string(g_szCSTeams[iFlagTeam])
			ewrite_short(++g_iScore[iFlagTeam])
			emessage_end()

			flag_sendHome(iFlagTeamOp)

			player_updateSpeed(id)

			g_fLastDrop[id] = fGameTime + 3.0

			if(g_bProtected[id])
				player_removeProtection(id, "PROTECTION_TOUCHFLAG")
			else
				player_updateRender(id)
			
			new iDif = 0;
			if(g_iScore[TEAM_RED] > g_iScore[TEAM_BLUE])
			{
				iDif = g_iScore[TEAM_RED] - g_iScore[TEAM_BLUE];
			}
			else if(g_iScore[TEAM_RED] < g_iScore[TEAM_BLUE])
			{
				iDif = g_iScore[TEAM_BLUE] - g_iScore[TEAM_RED];
			}
			
			if(iDif >= 10)
			{
				emessage_begin(MSG_ALL, SVC_INTERMISSION);
				emessage_end();
				
				//server_cmd("changelevel %s", g_nextmap);

				return
			}

#if FEATURE_ORPHEU == true

			new iFlagRoundEnd = get_pcvar_num(pCvar_ctf_flagendround)

			if(iFlagRoundEnd)
			{
				static OrpheuFunction:ofEndRoundMsg
				static OrpheuFunction:ofUpdateTeamScores
				static OrpheuFunction:ofCheckWinConditions

				if(!ofEndRoundMsg)
					ofEndRoundMsg = OrpheuGetFunction("EndRoundMessage")

				if(!ofUpdateTeamScores)
					ofUpdateTeamScores = OrpheuGetFunction("UpdateTeamScores", "CHalfLifeMultiplay")

				if(!ofCheckWinConditions)
					ofCheckWinConditions = OrpheuGetFunction("CheckWinConditions", "CHalfLifeMultiplay")

				new iEvent
				new iWinStatus
				new szWinOffset[20]
				new szWinMessage[16]

				switch(iFlagTeam)
				{
					case TEAM_RED:
					{
						iEvent = 9
						iWinStatus = 2
						copy(szWinOffset, charsmax(szWinOffset), "m_iNumTerroristWins")
						copy(szWinMessage, charsmax(szWinMessage), "#Terrorists_Win")
					}

					case TEAM_BLUE:
					{
						iEvent = 8
						iWinStatus = 1
						copy(szWinOffset, charsmax(szWinOffset), "m_iNumCTWins")
						copy(szWinMessage, charsmax(szWinMessage), "#CTs_Win")
					}
				}

				OrpheuCallSuper(ofUpdateTeamScores, g_pGameRules)
				OrpheuCallSuper(ofEndRoundMsg, szWinMessage, iEvent)

				OrpheuMemorySetAtAddress(g_pGameRules, "m_iRoundWinStatus", 1, iWinStatus)
				OrpheuMemorySetAtAddress(g_pGameRules, "m_fTeamCount", 1, get_gametime() + 3.0)
				OrpheuMemorySetAtAddress(g_pGameRules, "m_bRoundTerminating", 1, true)
				OrpheuMemorySetAtAddress(g_pGameRules, szWinOffset, 1, g_iScore[iFlagTeam])

				OrpheuCallSuper(ofCheckWinConditions, g_pGameRules)
			}

#else
			new iFlagRoundEnd = 1

#endif // FEATURE_ORPHEU

			if(iFlagRoundEnd && get_pcvar_num(pCvar_ctf_flagcaptureslay))
			{
				for(new i = 1; i <= g_iMaxPlayers; i++)
				{
					if(g_iTeam[i] == iFlagTeamOp)
					{
						user_kill(i)
						player_print(i, i, "%L", i, "DEATH_FLAGCAPTURED")
					}
				}
			}
		}
	}
	else
	{
		if(g_iFlagHolder[iFlagTeam] == FLAG_HOLD_BASE)
		{
			player_award(id, 0, REWARD_STEAL, "%L", id, "REWARD_STEAL")

			ExecuteForward(g_iFW_flag, g_iForwardReturn, FLAG_STOLEN, id, iFlagTeam, false)

			log_message("<%s>%s stole the ^"%s^" flag.", g_szTeamName[iTeam], szName, g_szTeamName[iFlagTeam])
		}
		else
		{
			player_award(id, 0, REWARD_PICKUP, "%L", id, "REWARD_PICKUP")

			ExecuteForward(g_iFW_flag, g_iForwardReturn, FLAG_PICKED, id, iFlagTeam, false)

			log_message("<%s>%s picked up the ^"%s^" flag.", g_szTeamName[iTeam], szName, g_szTeamName[iFlagTeam])
		}

		set_hudmessage(HUD_HELP)
		ShowSyncHudMsg(id, g_hud1, "%L", id, "HUD_YOUHAVEFLAG")

		flag_take(iFlagTeam, id)

		g_bAssisted[id][iFlagTeam] = true

		remove_task(ent)

		if(g_bProtected[id])
			player_removeProtection(id, "PROTECTION_TOUCHFLAG")
		else
			player_updateRender(id)
		
		game_announce(EVENT_TAKEN, iFlagTeam, szName)
	}
}

public one_flag_touch(ent, id)
{
#if FLAG_IGNORE_BOTS == true

	if(!g_bAlive[id] || g_bBot[id])
		return

#else // FLAG_IGNORE_BOTS

	if(!g_bAlive[id])
		return

#endif // FLAG_IGNORE_BOTS

	if(g_mode != MODE_ONE_FLAG)
		return
	
	if(g_restart_map_ob)
		return;
	
	new iFlagTeam = 0

	if(1 <= g_iFlagHolder[iFlagTeam] <= g_iMaxPlayers) // if flag is carried we don't care
		return

	new Float:fGameTime = get_gametime()

	if(g_fLastDrop[id] > fGameTime)
		return
	
	new iTeam = g_iTeam[id]

	if(!(TEAM_RED <= g_iTeam[id] <= TEAM_BLUE))
		return

	new szName[32]

	get_user_name(id, szName, charsmax(szName))
	
	if(g_iFlagHolder[iFlagTeam] == FLAG_HOLD_BASE)
	{
		player_award(id, 0, REWARD_STEAL, "%L", id, "REWARD_STEAL")

		ExecuteForward(g_iFW_flag, g_iForwardReturn, FLAG_STOLEN, id, iFlagTeam, false)

		log_message("<%s>%s stole the ^"%s^" flag.", g_szTeamName[iTeam], szName, g_szTeamName[iFlagTeam])
	}
	else
	{
		player_award(id, 0, REWARD_PICKUP, "%L", id, "REWARD_PICKUP")

		ExecuteForward(g_iFW_flag, g_iForwardReturn, FLAG_PICKED, id, iFlagTeam, false)

		log_message("<%s>%s picked up the ^"%s^" flag.", g_szTeamName[iTeam], szName, g_szTeamName[iFlagTeam])
	}

	set_hudmessage(HUD_HELP)
	ShowSyncHudMsg(id, g_hud1, "%L", id, "HUD_YOUHAVEFLAG")

	flag_take(iFlagTeam, id)

	g_bAssisted[id][0] = true

	remove_task(ent)

	if(g_bProtected[id])
		player_removeProtection(id, "PROTECTION_TOUCHFLAG")
	else
		player_updateRender(id)
	
	game_announce(EVENT_TAKEN, iFlagTeam, szName)
}

public flag_autoReturn(ent)
{
	remove_task(ent)

	new iFlagTeam = (g_iFlagEntity[TEAM_BLUE] == ent ? TEAM_BLUE : (g_iFlagEntity[TEAM_RED] == ent ? TEAM_RED : 0))
	
	if(g_mode != MODE_ONE_FLAG)
	{
		if(!iFlagTeam)
			return
	}
	else
		iFlagTeam = 0;
	
	flag_sendHome(iFlagTeam)

	ExecuteForward(g_iFW_flag, g_iForwardReturn, FLAG_AUTORETURN, 0, iFlagTeam, false)

	game_announce(EVENT_RETURNED, iFlagTeam, NULL)

	log_message("^"%s^" flag returned automatically", g_szTeamName[iFlagTeam])
}









public base_think(ent)
{
	if(!is_valid_ent(ent))
		return

	if(!get_pcvar_num(pCvar_ctf_flagheal))
	{
		entity_set_float(ent, EV_FL_nextthink, get_gametime() + 10.0) /* recheck each 10s seconds */

		return
	}

	entity_set_float(ent, EV_FL_nextthink, get_gametime() + BASE_THINK)

	new iFlagTeam = (g_iBaseEntity[TEAM_BLUE] == ent ? TEAM_BLUE : TEAM_RED)

	if(g_iFlagHolder[iFlagTeam] != FLAG_HOLD_BASE)
		return

	static id
	static iHealth

	id = -1

	while((id = find_ent_in_sphere(id, g_fFlagBase[iFlagTeam], BASE_HEAL_DISTANCE)) != 0)
	{
		if(1 <= id <= g_iMaxPlayers && g_bAlive[id] && g_iTeam[id] == iFlagTeam)
		{
			iHealth = get_user_health(id)

			if(iHealth < g_iMaxHealth[id])
			{
				// if(g_class[id] != CLASS_DEFENSOR) set_user_health(id, iHealth + 2)	
				// else set_user_health(id, iHealth + 1)
				
				set_user_health(id, iHealth + 1)

				player_healingEffect(id)
			}
		}

		if(id >= g_iMaxPlayers)
			break
	}
}











public client_putinserver(id)
{
	g_bBot[id] = (is_user_bot(id) ? true : false)

	g_iTeam[id] = TEAM_SPEC
	g_bFirstSpawn[id] = true
	g_bSuicide[id] = false
	g_bRestarted[id] = false
	g_bLights[id] = (g_bBot[id] ? false : (get_pcvar_num(pCvar_ctf_dynamiclights) ? true : false));
	
	g_team_balance[id] = 0;
	
	g_class[id] = CLASS_NOCLASS;
	g_class_next[id] = CLASS_NOCLASS;
	g_class_time[id] = 0;
	
	g_iMaxHealth[id] = 100;
}

public client_disconnect(id)
{
	player_dropFlag(id)
	remove_task(id)
	
	remove_task(id + TASK_SLOWDOWN)
	//remove_task(id + TASK_INVIS);

	g_iTeam[id] = TEAM_NONE
	g_iAdrenaline[id] = 0
	
	new i;
	for(i = 0; i <= ADRENALINE_MAX; ++i)
		g_iAdrenalineUse[id][i] = 0

	g_bAlive[id] = false
	g_bLights[id] = false
	g_bFreeLook[id] = false
	g_bAssisted[id][TEAM_RED] = false
	g_bAssisted[id][TEAM_BLUE] = false
	
	g_grenade_ice[id] = 0
	g_toxic_bomb[id] = 0
}

public player_joinTeam()
{
	new id = read_data(1)

	if(g_bAlive[id])
		return

	new szTeam[2]

	read_data(2, szTeam, charsmax(szTeam))

	switch(szTeam[0])
	{
		case 'T':
		{
			if(g_iTeam[id] == TEAM_RED && g_bFirstSpawn[id])
			{
				new iRespawn = get_pcvar_num(pCvar_ctf_respawntime)

				if(iRespawn > 0)
					player_respawn(id - TASK_RESPAWN, iRespawn + 1)

				/*remove_task(id - TASK_TEAMBALANCE)
				set_task(1.0, "player_checkTeam", id - TASK_TEAMBALANCE)*/
			}

			g_iTeam[id] = TEAM_RED
		}

		case 'C':
		{
			if(g_iTeam[id] == TEAM_BLUE && g_bFirstSpawn[id])
			{
				new iRespawn = get_pcvar_num(pCvar_ctf_respawntime)

				if(iRespawn > 0)
					player_respawn(id - TASK_RESPAWN, iRespawn + 1)

				/*remove_task(id - TASK_TEAMBALANCE)
				set_task(1.0, "player_checkTeam", id - TASK_TEAMBALANCE)*/
			}

			g_iTeam[id] = TEAM_BLUE
		}

		case 'U':
		{
			g_iTeam[id] = TEAM_NONE
			g_bFirstSpawn[id] = true
		}

		default:
		{
			player_screenFade(id, {0,0,0,0}, 0.0, 0.0, FADE_OUT, false)
			player_allowChangeTeam(id)

			g_iTeam[id] = TEAM_SPEC
			g_bFirstSpawn[id] = true
		}
	}
}

public player_spawn(id)
{
	if(!is_user_alive(id) || (!g_bRestarted[id] && g_bAlive[id]))
		return

	/* make sure we have team right */

	switch(getTeam(id))
	{
		case FM_CS_TEAM_T: g_iTeam[id] = TEAM_RED
		case FM_CS_TEAM_CT: g_iTeam[id] = TEAM_BLUE
		default: return
	}

	g_bAlive[id] = true
	g_bDefuse[id] = false
	g_bBuyZone[id] = true
	g_bFreeLook[id] = false
	g_fLastBuy[id] = Float:{0.0, 0.0, 0.0, 0.0}
	
	g_fWeaponSpeed[id] = 250.0

	remove_task(id - TASK_PROTECTION)
	remove_task(id - TASK_EQUIPAMENT)
	remove_task(id - TASK_DAMAGEPROTECTION)
	remove_task(id - TASK_TEAMBALANCE)
	remove_task(id - TASK_ADRENALINE)
	remove_task(id - TASK_DEFUSE)

#if FEATURE_BUY == true

	set_task(0.1, "player_spawnEquipament", id - TASK_EQUIPAMENT)

#endif // FEATURE_BUY

	if(g_class[id] != g_class_next[id])
		g_class_time[id] = 1;
	
	g_class[id] = g_class_next[id];
	
	set_user_health(id, CLASES[g_class[id]][classHealth]);
	set_user_armor(id, CLASES[g_class[id]][classArmor]);
	
	g_iMaxHealth[id] = clamp(get_user_health(id), 100, 150);

#if FEATURE_ADRENALINE == true

	player_hudAdrenaline(id)

#endif // FEATURE_ADRENALINE

	new iProtection = get_pcvar_num(pCvar_ctf_protection)

	if(iProtection > 0) {
		g_RespawnProtection_Count[id] = iProtection;
		player_protection(id - TASK_PROTECTION, 1)
	}
	
	message_begin(MSG_BROADCAST, gMsg_ScoreAttrib)
	write_byte(id)
	write_byte(0)
	message_end()

	if(g_caca)
	{
		cs_set_user_money(id, get_pcvar_num(pCvar_mp_startmoney));
		g_caca = 0;
	}
	else if(g_bFirstSpawn[id] || g_bRestarted[id])
	{
		g_bRestarted[id] = false
		g_bFirstSpawn[id] = false

		cs_set_user_money(id, get_pcvar_num(pCvar_mp_startmoney))
	}
	else if(g_bSuicide[id])
	{
		g_bSuicide[id] = false

		player_print(id, id, "%L", id, "SPAWN_NOMONEY")
	}
	else
		cs_set_user_money(id, clamp((cs_get_user_money(id) + get_pcvar_num(pCvar_ctf_spawnmoney)), get_pcvar_num(pCvar_mp_startmoney), 16000))
}

#if FEATURE_BUY == true

public player_spawnEquipament(id)
{
	id += TASK_EQUIPAMENT

	if(!g_bAlive[id])
		return

	strip_user_weapons(id)

	if(get_pcvar_num(pCvar_ctf_spawn_knife))
		give_item(id, g_szWeaponEntity[W_KNIFE])

	new szWeapon[3][24]

	get_pcvar_string(pCvar_ctf_spawn_prim, szWeapon[1], charsmax(szWeapon[]))
	get_pcvar_string(pCvar_ctf_spawn_sec, szWeapon[2], charsmax(szWeapon[]))

	for(new iWeapon, i = 2; i >= 1; i--)
	{
		iWeapon = 0

		if(strlen(szWeapon[i]))
		{
			for(new w = 1; w < sizeof g_szWeaponCommands; w++)
			{
				if(g_iWeaponSlot[w] == i && equali(szWeapon[i], g_szWeaponCommands[w][0]))
				{
					iWeapon = w
					break
				}
			}

			if(iWeapon)
			{
				give_item(id, g_szWeaponEntity[iWeapon])
				cs_set_user_bpammo(id, iWeapon, g_iBPAmmo[iWeapon])
			}
			else
				log_error(AMX_ERR_NOTFOUND, "Invalid %s weapon: ^"%s^", please fix ctf_spawn_%s cvar", (i == 1 ? "primary" : "secondary"), szWeapon[i], (i == 1 ? "prim" : "sec"))
		}
	}
}

#endif // FEATURE_BUY

public player_protection(id, iStart)
{
	id += TASK_PROTECTION

	if(!(TEAM_RED <= g_iTeam[id] <= TEAM_BLUE))
		return
	
	if(iStart)
	{
		g_bProtected[id] = true

		player_updateRender(id)
	}

	if(g_RespawnProtection_Count[id] > 0)
	{
		set_hudmessage(HUD_RESPAWN)
		ShowSyncHudMsg(id, g_hud3, "%L", id, "PROTECTION_LEFT", g_RespawnProtection_Count[id])
		
		--g_RespawnProtection_Count[id];

		set_task(1.0, "player_protection", id - TASK_PROTECTION)
	}
	else
		player_removeProtection(id, "PROTECTION_EXPIRED")
}

public player_removeProtection(id, szLang[])
{
	if(!(TEAM_RED <= g_iTeam[id] <= TEAM_BLUE))
		return

	g_bProtected[id] = false

	remove_task(id - TASK_PROTECTION)
	remove_task(id - TASK_DAMAGEPROTECTION)

	set_hudmessage(HUD_PROTECTION)
	ShowSyncHudMsg(id, g_hud3, "%L", id, szLang)

	player_updateRender(id)
}

public player_currentWeapon(id)
{
	if(!g_bAlive[id])
		return

	new bool:bZoom[33]

	new iZoom = read_data(1)

	if(1 < iZoom <= 90) /* setFOV event */
		bZoom[id] = bool:(iZoom <= 40)

	else /* CurWeapon event */
	{
		if(!bZoom[id]) /* if not zooming, get weapon speed */
			g_fWeaponSpeed[id] = g_fWeaponRunSpeed[read_data(2)]

		else /* if zooming, set zoom speed */
			g_fWeaponSpeed[id] = g_fWeaponRunSpeed[0]

		player_updateSpeed(id)
	}
}

public client_PostThink(id)
{
	if(!g_bAlive[id])
		return

	static iOffset
	static iShield[33]

	iOffset = get_pdata_int(id, m_iUserPrefs)

	if(iOffset & (1<<24)) /* Shield available */
	{
		if(iOffset & (1<<16)) /* Uses shield */
		{
			if(iShield[id] < 2) /* Trigger only once */
			{
				iShield[id] = 2

				g_fWeaponSpeed[id] = 180.0

				player_updateSpeed(id)
			}
		}
		else if(iShield[id] == 2) /* Doesn't use the shield anymore */
		{
			iShield[id] = 1

			g_fWeaponSpeed[id] = 250.0

			player_updateSpeed(id)
		}
	}
	else if(iShield[id]) /* Shield not available anymore */
		iShield[id] = 0
}

public player_useWeapon(ent)
{
	if(!is_valid_ent(ent))
		return

	static id

	id = entity_get_edict(ent, EV_ENT_owner)

	if(1 <= id <= g_iMaxPlayers && g_bAlive[id])
	{
		if(g_bProtected[id])
			player_removeProtection(id, "PROTECTION_WEAPONUSE")

#if FEATURE_ADRENALINE == true
		else if(g_iAdrenalineUse[id][ADRENALINE_BERSERK])
		{
			set_pdata_float(ent, m_flNextPrimaryAttack, get_pdata_float(ent, m_flNextPrimaryAttack, 4) * BERSERKER_SPEED1)
			set_pdata_float(ent, m_flNextSecondaryAttack, get_pdata_float(ent, m_flNextSecondaryAttack, 4) * BERSERKER_SPEED2)
		}
#endif // FEATURE_ADRENALINE
	}
}

#if FEATURE_ADRENALINE == true

public player_useWeaponSec(ent)
{
	if(!is_valid_ent(ent))
		return

	static id

	id = entity_get_edict(ent, EV_ENT_owner)

	if(1 <= id <= g_iMaxPlayers && g_bAlive[id] && g_iAdrenalineUse[id][ADRENALINE_BERSERK])
	{
		set_pdata_float(ent, m_flNextPrimaryAttack, get_pdata_float(ent, m_flNextPrimaryAttack, 4) * BERSERKER_SPEED1)
		set_pdata_float(ent, m_flNextSecondaryAttack, get_pdata_float(ent, m_flNextSecondaryAttack, 4) * BERSERKER_SPEED2)
	}
}

#endif // FEATURE_ADRENALINE


public player_damage(id, iWeapon, iAttacker, Float:fDamage, iType)
{
	if(id == iAttacker || !is_user_valid_connected(iAttacker))
		return HAM_IGNORED;
	
	if(g_restart_map_ob)
		return HAM_SUPERCEDE
	
	if(g_bProtected[id])
	{
		player_updateRender(id, fDamage)

		remove_task(id - TASK_DAMAGEPROTECTION)
		set_task(0.1, "player_damageProtection", id - TASK_DAMAGEPROTECTION)

		entity_set_vector(id, EV_VEC_punchangle, FLAG_SPAWN_ANGLES)

		return HAM_SUPERCEDE
	}

#if FEATURE_ADRENALINE == true

	else if(1 <= iAttacker <= g_iMaxPlayers && g_iAdrenalineUse[iAttacker][ADRENALINE_BERSERK] && g_iTeam[iAttacker] != g_iTeam[id])
	{
		SetHamParamFloat(4, fDamage * BERSERKER_DAMAGE)

		new iOrigin[3]

		get_user_origin(id, iOrigin)

		message_begin(MSG_PVS, SVC_TEMPENTITY, iOrigin)
		write_byte(TE_BLOODSPRITE)
		write_coord(iOrigin[x] + random_num(-15, 15))
		write_coord(iOrigin[y] + random_num(-15, 15))
		write_coord(iOrigin[z] + random_num(-15, 15))
		write_short(gSpr_blood2)
		write_short(gSpr_blood1)
		write_byte(248)
		write_byte(18)
		message_end()

		return HAM_OVERRIDE
	}

#endif // FEATURE_ADRENALINE

	return HAM_IGNORED
}

public player_damageProtection(id)
{
	id += TASK_DAMAGEPROTECTION

	if(g_bAlive[id])
		player_updateRender(id)
}

new const NADE_WEAPON_ID[3] = {CSW_HEGRENADE, CSW_FLASHBANG, CSW_SMOKEGRENADE} // nade weapon id
new const NADE_ITEM_ID[3][] = {"15", "14", "18"} // nade armoury item id

#define OFFSET_AMMO_HE_32BIT 388
#define OFFSET_AMMO_FB_32BIT 387
#define OFFSET_AMMO_SG_32BIT 389

// player nades ammo private data 64bit offsets
#define OFFSET_AMMO_HE_64BIT 437
#define OFFSET_AMMO_FB_64BIT 436
#define OFFSET_AMMO_SG_64BIT 438

// player nades ammo linux offset difference
#define OFFSET_AMMO_LINUXDIFF 5

// determination of actual offsets
#if !defined PROCESSOR_TYPE // is automatic 32/64bit processor detection?
	#if cellbits == 32 // is the size of a cell are 32 bits?
		// then considering processor as 32bit
		new NADE_OFFSET_AMMO[3] = {OFFSET_AMMO_HE_32BIT, OFFSET_AMMO_FB_32BIT, OFFSET_AMMO_SG_32BIT}
	#else // in other case considering the size of a cell as 64 bits
		// and then considering processor as 64bit
		new NADE_OFFSET_AMMO[3] = {OFFSET_AMMO_HE_64BIT, OFFSET_AMMO_FB_64BIT, OFFSET_AMMO_SG_64BIT}
	#endif
#else // processor type specified by PROCESSOR_TYPE define
	#if PROCESSOR_TYPE == 0 // 32bit processor defined
		new NADE_OFFSET_AMMO[3] = {OFFSET_AMMO_HE_32BIT, OFFSET_AMMO_FB_32BIT, OFFSET_AMMO_SG_32BIT}
	#else // considering that 64bit processor defined
		new NADE_OFFSET_AMMO[3] = {OFFSET_AMMO_HE_64BIT, OFFSET_AMMO_FB_64BIT, OFFSET_AMMO_SG_64BIT}
	#endif
#endif

new const NADE_DIFF_DIST[3] = {14, 0, -14} // nades distance difference
new const NADE_PLR_DIFF_ANGLE[3] = {45, 45, 45} // player/nade angle difference in degrees
new const NADE_PLR_DIFF_DIST[3] = {8, 8, 8} // player/nade distance difference

public player_killed(id, killer)
{	
	g_bAlive[id] = false
	g_bBuyZone[id] = false

	remove_task(id - TASK_RESPAWN)
	remove_task(id - TASK_PROTECTION)
	remove_task(id - TASK_EQUIPAMENT)
	remove_task(id - TASK_DAMAGEPROTECTION)
	remove_task(id - TASK_TEAMBALANCE)
	remove_task(id - TASK_ADRENALINE)
	remove_task(id - TASK_DEFUSE)
	remove_task(id + TASK_SLOWDOWN)
	
	g_player_solid[id] = 0;
	g_player_restore[id] = 0;
	
	new ammo_fix[3]
	if(pev(id, pev_button) & IN_ATTACK)
	{
		new clip, ammo, weapon = get_user_weapon(id, clip, ammo)

		for (new i = 0; i < 3; ++i)
		{
			if (weapon == NADE_WEAPON_ID[i])
			{
				ammo_fix[i] = -1
				break
			}
		}
	}

	for (new i = 0; i < 3; ++i)
	{
		new ammo = get_pdata_int(id, NADE_OFFSET_AMMO[i], OFFSET_AMMO_LINUXDIFF)
		ammo += ammo_fix[i]
		if (ammo < 1)
			continue

		new nade = engfunc(EngFunc_CreateNamedEntity, g_ipsz_armoury_entity)
		if (!nade)
			continue

		set_nade_kvd(nade, "item", NADE_ITEM_ID[i])

		new count[4]
		num_to_str(ammo, count, 3)
		set_nade_kvd(nade, "count", count)

		set_pev(nade, pev_classname, "real_nade")

		new Float:origin[3]
		pev(id, pev_origin, origin)
		new Float:angles[3]
		pev(id, pev_angles, angles)
		origin[0] += floatcos(angles[1], degrees) * NADE_PLR_DIFF_DIST[i] + floatcos(angles[1] + 90, degrees) * NADE_DIFF_DIST[i]
		origin[1] += floatsin(angles[1], degrees) * NADE_PLR_DIFF_DIST[i] + floatsin(angles[1] + 90, degrees) * NADE_DIFF_DIST[i]
		engfunc(EngFunc_SetOrigin, nade, origin)
		angles[0] = 0.0
		angles[1] += NADE_PLR_DIFF_ANGLE[i]
		set_pev(nade, pev_angles, angles)

		// setup nade velocity
		new Float:velocity[3]
		pev(id, pev_velocity, velocity)
		set_pev(nade, pev_velocity, velocity)

		dllfunc(DLLFunc_Spawn, nade)
	}
	
	if(g_iAdrenalineUse[id][ADRENALINE_IMPOSTOR])
		cs_reset_user_model(id);

	new szHint[10]

#if FEATURE_C4 == true && FEATURE_ADRENALINE == true

	formatex(szHint, charsmax(szHint), "HINT_%d", random_num(1, 12))

#else

	new iHint

	while((iHint = random_num(1, 12)))
	{
#if FEATURE_ADRENALINE == false
		if(iHint == 1 || iHint == 7 || iHint == 9)
			continue
#endif // FEATURE_ADRENALINE


#if FEATURE_C4 == false
		if(iHint == 4 || iHint == 8 || iHint == 10)
			continue
#endif // FEATURE_C4

		break
	}

	formatex(szHint, charsmax(szHint), "HINT_%d", iHint)

#endif // FEATURE_C4 || FEATURE_ADRENALINE

#if FEATURE_C4 == true

	new iWeapon = entity_get_edict(id, EV_ENT_dmg_inflictor)
	new szWeapon[10]
	new bool:bC4 = false

	if(iWeapon > g_iMaxPlayers && is_valid_ent(iWeapon))
	{
		entity_get_string(iWeapon, EV_SZ_classname, szWeapon, charsmax(szWeapon))

		if(equal(szWeapon, GRENADE) && get_pdata_int(iWeapon, 96) & (1<<8))
		{
			message_begin(MSG_ALL, gMsg_DeathMsg)
			write_byte(killer)
			write_byte(id)
			write_byte(0)
			write_string("c4")
			message_end()

			bC4 = true
		}
	}

#endif // FEATURE_C4

	if(id == killer || !(1 <= killer <= g_iMaxPlayers))
	{
		if(!g_team_balance[id])
		{
			g_bSuicide[id] = true

			// player_award(id, 0, PENALTY_SUICIDE, "%L", id, "PENALTY_SUICIDE")
		}
		
		g_team_balance[id] = 0;
#if FEATURE_C4 == true

		if(bC4)
			player_setScore(id, -1, 1)

#endif // FEATURE_C4

	}
	else if(1 <= killer <= g_iMaxPlayers)
	{
		if(g_iTeam[id] == g_iTeam[killer])
		{

#if FEATURE_C4 == true

			if(bC4)
			{
				player_setScore(killer, -1, 0)
				cs_set_user_money(killer, clamp(cs_get_user_money(killer) - 3300, 0, 16000), 1)
			}

#endif // FEATURE_C4

			// player_award(killer, 0, PENALTY_TEAMKILL, "%L", killer, "PENALTY_TEAMKILL")
		}
		else
		{

#if FEATURE_C4 == true

			if(bC4)
			{
				player_setScore(killer, -1, 0)
				player_setScore(id, 0, 1)

				cs_set_user_money(killer, clamp(cs_get_user_money(killer) + 300, 0, 16000), 1)
			}

#endif // FEATURE_C4

			if(id == g_iFlagHolder[g_iTeam[killer]])
			{
				g_bAssisted[killer][g_iTeam[killer]] = true

				player_award(killer, 0, REWARD_KILLCARRIER, "%L", killer, "REWARD_KILLCARRIER")

				message_begin(MSG_BROADCAST, gMsg_ScoreAttrib)
				write_byte(id)
				write_byte(0)
				message_end()
			}
			else
			{
				player_spawnItem(id)
				player_award(killer, id, REWARD_KILL, "%L", killer, "REWARD_KILL")
			}
		}
	}

#if FEATURE_ADRENALINE == true

	new i;
	for(i = 0; i <= ADRENALINE_MAX; ++i)
	{
		if(g_iAdrenalineUse[id][i])
		{
			if(g_iAdrenalineUse[id][ADRENALINE_SPEED])
			{
				message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
				write_byte(TE_KILLBEAM)
				write_short(id)
				message_end()
			}
			
			new j;
			for(j = 0; j <= ADRENALINE_MAX; ++j)
			{
				/*if(j == ADRENALINE_INVISIBILITY)
					continue;*/
				
				g_iAdrenalineUse[id][j] = 0
			}
			
			player_updateRender(id)
			player_hudAdrenaline(id)
			
			break;
		}
	}
	
#endif // FEATURE_ADRENALINE

	new iRespawn = get_pcvar_num(pCvar_ctf_respawntime)

	if(iRespawn > 0)
		player_respawn(id - TASK_RESPAWN, iRespawn)

	player_dropFlag(id)
	player_allowChangeTeam(id)

	//set_task(1.0, "player_checkTeam", id - TASK_TEAMBALANCE)
}

set_nade_kvd(nade, const key[], const value[])
{
	set_kvd(0, KV_ClassName, "armoury_entity")
	set_kvd(0, KV_KeyName, key)
	set_kvd(0, KV_Value, value)
	set_kvd(0, KV_fHandled, 0)

	return dllfunc(DLLFunc_KeyValue, nade, 0)
}

/*public player_checkTeam(id)
{
	id += TASK_TEAMBALANCE

	if(!(TEAM_RED <= g_iTeam[id] <= TEAM_BLUE) || g_bAlive[id])
		return

	new iPlayers[3]
	new iTeam = g_iTeam[id]
	new iOpTeam = get_opTeam(iTeam)

	for(new i = 1; i <= g_iMaxPlayers; i++)
	{
		if(TEAM_RED <= g_iTeam[i] <= TEAM_BLUE)
			iPlayers[g_iTeam[i]]++
	}

	if((iPlayers[iTeam] > 1 && !iPlayers[iOpTeam]) || iPlayers[iTeam] > (iPlayers[iOpTeam] + 1))
	{
		player_allowChangeTeam(id)

		engclient_cmd(id, "jointeam", (iOpTeam == TEAM_BLUE ? "2" : "1"))

		set_task(0.5, "player_forceJoinClass", id)

		player_print(id, id, "Fuiste transferido al equipo contrario debido a un auto balance de equipos")
	}
}*/

/*public player_forceJoinClass(id)
{
	engclient_cmd(id, "joinclass", "5")
}*/

public player_respawn(id, iStart)
{
	id += TASK_RESPAWN

	if(!(TEAM_RED <= g_iTeam[id] <= TEAM_BLUE) || g_bAlive[id])
		return

	static iCount[33]

	if(iStart)
		iCount[id] = iStart + 1

	set_hudmessage(HUD_RESPAWN)

	if(--iCount[id] > 0)
	{
		ShowSyncHudMsg(id, g_hud3, "%L", id, "RESPAWNING_IN", iCount[id])
		client_print(id, print_console, "%L", id, "RESPAWNING_IN", iCount[id])

		set_task(1.0, "player_respawn", id - TASK_RESPAWN)
	}
	else
	{
		ShowSyncHudMsg(id, g_hud3, "%L", id, "RESPAWNING")
		client_print(id, print_console, "%L", id, "RESPAWNING")
		
		ExecuteHamB(Ham_CS_RoundRespawn, id);

		/*entity_set_int(id, EV_INT_deadflag, DEAD_RESPAWNABLE)
		entity_set_int(id, EV_INT_iuser1, 0)
		entity_think(id)
		entity_spawn(id)
		set_user_health(id, 100)*/
	}
}

#if FEATURE_ADRENALINE == true

public player_cmd_buySpawn(id)
{
	if(g_bAlive[id] || !(TEAM_RED <= g_iTeam[id] <= TEAM_BLUE))
		player_print(id, id, "%L", id, "INSTANTSPAWN_NOTEAM")

	else if(g_iAdrenaline[id] < INSTANTSPAWN_COST)
		player_print(id, id, "%L", id, "INSTANTSPAWN_NOADRENALINE", INSTANTSPAWN_COST)

	else
	{
		g_iAdrenaline[id] -= INSTANTSPAWN_COST

		player_print(id, id, "%L", id, "INSTANTSPAWN_BOUGHT", INSTANTSPAWN_COST)

		remove_task(id)
		player_respawn(id - TASK_RESPAWN, -1)
	}

	return PLUGIN_HANDLED
}

#endif // FEATURE_ADRENALINE

/*public player_cmd_dropFlag(id)
{
	if(!g_bAlive[id] || id != g_iFlagHolder[get_opTeam(g_iTeam[id])])
		player_print(id, id, "%L", id, "DROPFLAG_NOFLAG")

	else
	{
		new iOpTeam = get_opTeam(g_iTeam[id])

		player_dropFlag(id)

		ExecuteForward(g_iFW_flag, g_iForwardReturn, FLAG_MANUALDROP, id, iOpTeam, false)

		g_bAssisted[id][iOpTeam] = false
	}

	return PLUGIN_HANDLED
}*/

public player_dropFlag(id)
{
	new iOpTeam = get_opTeam(g_iTeam[id])
	new ent
	
	if(g_mode != MODE_ONE_FLAG)
	{
		ent = g_iFlagEntity[iOpTeam]
		
		if(id != g_iFlagHolder[iOpTeam])
			return
		
		if(!is_valid_ent(ent))
			return

		g_fLastDrop[id] = get_gametime() + 2.0
		g_iFlagHolder[iOpTeam] = FLAG_HOLD_DROPPED

		entity_set_edict(ent, EV_ENT_aiment, -1)
		entity_set_int(ent, EV_INT_movetype, MOVETYPE_TOSS)
		entity_set_int(ent, EV_INT_sequence, FLAG_ANI_DROPPED)
		entity_set_int(ent, EV_INT_solid, SOLID_TRIGGER)
		entity_set_origin(ent, g_fFlagLocation[iOpTeam])

		new Float:fReturn = get_pcvar_float(pCvar_ctf_flagreturn)

		if(fReturn > 0)
			set_task(fReturn, "flag_autoReturn", ent)

		if(g_bAlive[id])
		{
			new Float:fVelocity[3]

			velocity_by_aim(id, 200, fVelocity)

			fVelocity[z] = 0.0

			entity_set_vector(ent, EV_VEC_velocity, fVelocity)

			player_updateSpeed(id)
			player_updateRender(id)

			message_begin(MSG_BROADCAST, gMsg_ScoreAttrib)
			write_byte(id)
			write_byte(0)
			message_end()
		}
		else
			entity_set_vector(ent, EV_VEC_velocity, FLAG_DROP_VELOCITY)

		new szName[32]

		get_user_name(id, szName, charsmax(szName))

		game_announce(EVENT_DROPPED, iOpTeam, szName)

		ExecuteForward(g_iFW_flag, g_iForwardReturn, FLAG_DROPPED, id, iOpTeam, false)

		g_fFlagDropped[iOpTeam] = get_gametime()

		log_message("<%s>%s dropped the ^"%s^" flag.", g_szTeamName[g_iTeam[id]], szName, g_szTeamName[iOpTeam])
	}
	else
	{
		ent = g_iFlagEntity[0]
		
		if(id != g_iFlagHolder[0])
			return
		
		if(!is_valid_ent(ent))
			return

		g_fLastDrop[id] = get_gametime() + 2.0
		g_iFlagHolder[0] = FLAG_HOLD_DROPPED

		entity_set_edict(ent, EV_ENT_aiment, -1)
		entity_set_int(ent, EV_INT_movetype, MOVETYPE_TOSS)
		entity_set_int(ent, EV_INT_sequence, FLAG_ANI_DROPPED)
		entity_set_int(ent, EV_INT_solid, SOLID_TRIGGER)
		entity_set_origin(ent, g_fFlagLocation[0])

		new Float:fReturn = get_pcvar_float(pCvar_ctf_flagreturn)

		if(fReturn > 0)
			set_task(fReturn, "flag_autoReturn", ent)

		if(g_bAlive[id])
		{
			new Float:fVelocity[3]

			velocity_by_aim(id, 200, fVelocity)

			fVelocity[z] = 0.0

			entity_set_vector(ent, EV_VEC_velocity, fVelocity)

			player_updateSpeed(id)
			player_updateRender(id)

			message_begin(MSG_BROADCAST, gMsg_ScoreAttrib)
			write_byte(id)
			write_byte(0)
			message_end()
		}
		else
			entity_set_vector(ent, EV_VEC_velocity, FLAG_DROP_VELOCITY)

		new szName[32]

		get_user_name(id, szName, charsmax(szName))

		game_announce(EVENT_DROPPED, 0, szName)

		ExecuteForward(g_iFW_flag, g_iForwardReturn, FLAG_DROPPED, id, 0, false)

		g_fFlagDropped[0] = get_gametime()
	}
}

public player_cmd_say(id)
{
	static Float:fLastUsage[33]

	new Float:fGameTime = get_gametime()

	if((fLastUsage[id] + 0.5) > fGameTime)
		return PLUGIN_HANDLED

	fLastUsage[id] = fGameTime

	new szMsg[128]

	read_args(szMsg, charsmax(szMsg))
	remove_quotes(szMsg)
	trim(szMsg)
	
	replace_all(szMsg, charsmax(szMsg), "%", "");

	if(equal(szMsg, NULL))
		return PLUGIN_HANDLED

	if(equal(szMsg[0], "@"))
		return PLUGIN_CONTINUE

	new szFormat[192]
	new szName[32]

	get_user_name(id, szName, charsmax(szName))

	switch(g_iTeam[id])
	{
		case TEAM_RED, TEAM_BLUE: formatex(szFormat, charsmax(szFormat), "^x01%s^x03%s ^x01:  %s", (g_bAlive[id] ? NULL : "^x01*DEAD* "), szName, szMsg)
		case TEAM_NONE, TEAM_SPEC: formatex(szFormat, charsmax(szFormat), "^x01*SPEC* ^x03%s ^x01:  %s", szName, szMsg)
	}

	for(new i = 1; i <= g_iMaxPlayers; i++)
	{
		if(i == id || g_iTeam[i] == TEAM_NONE || g_bAlive[i] == g_bAlive[id] || g_bBot[id])
			continue

		message_begin(MSG_ONE, gMsg_SayText, _, i)
		write_byte(id)
		write_string(szFormat)
		message_end()
	}

#if FEATURE_BUY == true

	if(equali(szMsg, "/buy"))
	{
		player_menu_buy(id, 0)

		return PLUGIN_HANDLED
	}

#endif // FEATURE_BUY

#if FEATURE_ADRENALINE == true

	if(equali(szMsg, "/spawn"))
	{
		player_cmd_buySpawn(id)

		return PLUGIN_HANDLED
	}

	if(equali(szMsg, "/shop"))
	{
		player_cmd_adrenaline(id)

		return PLUGIN_HANDLED
	}

#endif // FEATURE_ADRENALINE

	/*if(equali(szMsg, "/soltarbandera"))
	{
		player_cmd_dropFlag(id)

		return PLUGIN_HANDLED
	}*/

	return PLUGIN_CONTINUE
}

public player_cmd_sayTeam(id)
{
	static Float:fLastUsage[33]

	new Float:fGameTime = get_gametime()

	if((fLastUsage[id] + 0.5) > fGameTime)
		return PLUGIN_HANDLED

	fLastUsage[id] = fGameTime

	new szMsg[128]

	read_args(szMsg, charsmax(szMsg))
	remove_quotes(szMsg)
	trim(szMsg)
	
	replace_all(szMsg, charsmax(szMsg), "%", "");

	if(equal(szMsg, NULL))
		return PLUGIN_HANDLED

	if(equal(szMsg[0], "@"))
		return PLUGIN_CONTINUE

	new szFormat[192]
	new szName[32]

	get_user_name(id, szName, charsmax(szName))

	switch(g_iTeam[id])
	{
		case TEAM_RED, TEAM_BLUE: formatex(szFormat, charsmax(szFormat), "^x01%s(%L) ^x03%s ^x01:  %s", (g_bAlive[id] ? NULL : "*DEAD* "), LANG_PLAYER, g_szMLTeamName[g_iTeam[id]], szName, szMsg)
		case TEAM_NONE, TEAM_SPEC: formatex(szFormat, charsmax(szFormat), "^x01*SPEC*(%L) ^x03%s ^x01:  %s", LANG_PLAYER, g_szMLTeamName[TEAM_SPEC], szName, szMsg)
	}

	for(new i = 1; i <= g_iMaxPlayers; i++)
	{
		if(i == id || g_iTeam[i] == TEAM_NONE || g_iTeam[i] != g_iTeam[id] || g_bAlive[i] == g_bAlive[id] || g_bBot[id])
			continue

		message_begin(MSG_ONE, gMsg_SayText, _, i)
		write_byte(id)
		write_string(szFormat)
		message_end()
	}

#if FEATURE_BUY == true

	if(equali(szMsg, "/buy"))
	{
		player_menu_buy(id, 0)

		return PLUGIN_HANDLED
	}

#endif // FEATURE_BUY

#if FEATURE_ADRENALINE == true

	if(equali(szMsg, "/spawn"))
	{
		player_cmd_buySpawn(id)

		return PLUGIN_HANDLED
	}

	if(equali(szMsg, "/shop"))
	{
		player_cmd_adrenaline(id)

		return PLUGIN_HANDLED
	}

#endif // FEATURE_ADRENALINE

	/*if(equali(szMsg, "/soltarbandera"))
	{
		player_cmd_dropFlag(id)

		return PLUGIN_HANDLED
	}*/

	return PLUGIN_CONTINUE
}











#if FEATURE_ADRENALINE == true

public player_cmd_adrenaline(id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(g_class[id] == CLASS_NOCLASS)
	{
		fn_CC(id, _, "!yNo podés comprar poderes si no eliges una clase. Escribe !g/class!y en el chat para elegir.");
		return PLUGIN_HANDLED;
	}
	
	if(!is_user_alive(id))
	{
		fn_CC(id, _, "!yNo podés comprar estando muerto.");
		return PLUGIN_HANDLED;
	}
	
	player_hudAdrenaline(id)

	if(!(TEAM_RED <= g_iTeam[id] <= TEAM_BLUE) || !g_bAlive[id])
		return player_print(id, id, "%L", id, "ADR_ALIVE")
	
	static menuid
	
	// Title
	menuid = menu_create("\yShop | Adrenalina^n\rTodos los items comprados duran hasta que mueras\R", "menu_adrenaline")
	
	if(g_class[id] == CLASS_NORMAL)
	{
		menu_additem(menuid, "Velocidad \y[190 AD]", "1")
		menu_additem(menuid, "Daño x2 \y[190 AD]", "2")
		menu_additem(menuid, "Balas infinitas + precision perfecta \y[190 AD]", "3")
		menu_additem(menuid, "Long Jump (sin bandera) \y[190 AD]", "4")
		menu_additem(menuid, "Invisible (90%) \y[190 AD]", "5")
		menu_additem(menuid, "1.000 de vida \y[190 AD]", "6")
		menu_additem(menuid, "Espía + 300 de vida \y[190 AD]", "7")
	}
	else
	{
		if(g_class[id] != CLASS_DEFENSOR) menu_additem(menuid, "Velocidad \y[80 AD]", "1")
		else menu_additem(menuid, "\dVelocidad [80 AD]", "1")
		
		if(g_class[id] != CLASS_ATTACKER) menu_additem(menuid, "Daño x2 \y[100 AD]", "2")
		else menu_additem(menuid, "\dDaño x2 [100 AD]", "2")
		
		menu_additem(menuid, "Balas infinitas + precision perfecta \y[160 AD]", "3")
		
		if(g_class[id] != CLASS_DEFENSOR) menu_additem(menuid, "Long Jump (sin bandera) \y[70 AD]", "4")
		else menu_additem(menuid, "\dLong Jump (sin bandera) [70 AD]", "4")
		
		if(g_class[id] != CLASS_ATTACKER) menu_additem(menuid, "Invisible (90%) \y[160 AD]", "5")
		else menu_additem(menuid, "\dInvisible (90%) [160 AD]", "5")
		
		if(g_class[id] != CLASS_DEFENSOR) menu_additem(menuid, "1.000 de vida \y[150 AD]", "6")
		else menu_additem(menuid, "\d1.000 de vida [150 AD]", "6")
		
		menu_additem(menuid, "Espía + 300 de vida \y[180 AD]", "7")
	}
	
	menu_additem(menuid, "Bomba de hielo (reduce velocidad a los afectados) \y[$500]", "8")
	menu_additem(menuid, "Bomba tóxica (bloquea tu visión y saca daño en área) \y[$2.000]", "9")
	
	// Exit
	menu_setprop(menuid, MPROP_BACKNAME, "Atras")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Salir")
	
	// Fix for AMXX custom menus
	menu_display(id, menuid, 0)

	return PLUGIN_HANDLED
}

new const ADRENALINE_COST_ITEM[] = {
	NULL, 80, 100, 160, 70, 160, 150, 180, 0, 0
}

new const ADRENALINE_COST_ITEM_NORMAL[] = {
	NULL, 190, 190, 190, 190, 190, 190, 190, 0, 0
}

new const ADRENALINE_COST2_ITEM[] = {
	NULL, 0, 0, 0, 0, 0, 0, 0, 500, 2000
}

public menu_adrenaline(id, menuid, item)
{
	// Player disconnected?
	if(!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	if(g_class[id] == CLASS_NOCLASS)
	{
		fn_CC(id, _, "!yNo podés comprar poderes si no eliges una clase. Escribe !g/class!y en el chat para elegir.");
		
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve class id
	static buffer[2], dummy, ritem
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	ritem = str_to_num(buffer[0])
	
	if(g_class[id] == CLASS_ATTACKER && (ritem == ADRENALINE_BERSERK || ritem == ADRENALINE_INVISIBILITY))
	{
		fn_CC(id, _, "!yNo podés comprar este poder si sos ATACANTE");
		return PLUGIN_HANDLED;
	}
	else if(g_class[id] == CLASS_DEFENSOR && (ritem == ADRENALINE_HEALTH || ritem == ADRENALINE_SPEED || ritem == ADRENALINE_LONGJUMP))
	{
		fn_CC(id, _, "!yNo podés comprar este poder si sos DEFENSOR");
		return PLUGIN_HANDLED;
	}
	
	if(g_class[id] == CLASS_NORMAL)
	{
		if(g_iAdrenaline[id] < ADRENALINE_COST_ITEM_NORMAL[ritem])
		{
			player_print(id, id, "Te falta %d de adrenalina para comprar este poder", (ADRENALINE_COST_ITEM_NORMAL[ritem] - g_iAdrenaline[id]))
			return PLUGIN_HANDLED;
		}
	}
	else
	{
		if(g_iAdrenaline[id] < ADRENALINE_COST_ITEM[ritem])
		{
			player_print(id, id, "Te falta %d de adrenalina para comprar este poder", (ADRENALINE_COST_ITEM[ritem] - g_iAdrenaline[id]))
			return PLUGIN_HANDLED;
		}
	}
	
	if(cs_get_user_money(id) < ADRENALINE_COST2_ITEM[ritem])
	{
		player_print(id, id, "Te falta %d para comprar este poder", (ADRENALINE_COST2_ITEM[ritem] - cs_get_user_money(id)))
		return PLUGIN_HANDLED;
	}
	
	if(g_class[id] == CLASS_NORMAL)
		g_iAdrenaline[id] -= ADRENALINE_COST_ITEM_NORMAL[ritem];
	else
		g_iAdrenaline[id] -= ADRENALINE_COST_ITEM[ritem];
	
	cs_set_user_money(id, cs_get_user_money(id) - ADRENALINE_COST2_ITEM[ritem])
	
	g_iAdrenalineUse[id][ritem] = 1;
	
	switch(ritem)
	{
		case ADRENALINE_SPEED:
		{
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_BEAMFOLLOW)
			write_short(id)
			write_short(gSpr_trail)
			write_byte(8) // life in 0.1's
			write_byte(6) // line width in 0.1's
			write_byte(255)
			write_byte(255)
			write_byte(0)
			write_byte(255) // brightness
			message_end()
			
			player_updateSpeed(id)
			player_updateRender(id)
		}
		case ADRENALINE_LONGJUMP: give_item(id, "item_longjump")
		case ADRENALINE_HEALTH: set_user_health(id, 1000);
		case ADRENALINE_IMPOSTOR:
		{
			if(g_iTeam[id] == TEAM_BLUE)
				cs_set_user_model(id, "leet");
			else
				cs_set_user_model(id, "gign");
			
			set_user_health(id, get_user_health(id) + 300);
		}
		/*case ADRENALINE_INVISIBILITY:
		{
			remove_task(id + TASK_INVIS);
			
			set_task(170.0, "removeInvis10", id + TASK_INVIS);
			set_task(180.0, "removeInvis", id + TASK_INVIS);
		}*/
		case ADRENALINE_ICE_BOMB:
		{
			++g_grenade_ice[id];
			
			if(user_has_weapon(id, CSW_HEGRENADE))
				cs_set_user_bpammo(id, CSW_HEGRENADE, cs_get_user_bpammo(id, CSW_HEGRENADE) + 1);
			else
				give_item(id, "weapon_hegrenade");
		}
		case ADRENALINE_TOXIC_BOMB:
		{
			++g_toxic_bomb[id];
			
			if(user_has_weapon(id, CSW_SMOKEGRENADE))
				cs_set_user_bpammo(id, CSW_SMOKEGRENADE, cs_get_user_bpammo(id, CSW_SMOKEGRENADE) + 1);
			else
				give_item(id, "weapon_smokegrenade");
		}
	}
	
	if(g_bProtected[id])
		player_removeProtection(id, "PROTECTION_ADRENALINE")
	
	player_updateRender(id)

	new iOrigin[3]
	get_user_origin(id, iOrigin)

	message_begin(MSG_PVS, SVC_TEMPENTITY, iOrigin)
	write_byte(TE_IMPLOSION)
	write_coord(iOrigin[x])
	write_coord(iOrigin[y])
	write_coord(iOrigin[z])
	write_byte(128) // radius
	write_byte(32) // count
	write_byte(4) // life in 0.1's
	message_end()
	
	emit_sound(id, CHAN_ITEM, SND_ADRENALINE, VOL_NORM, ATTN_NORM, 0, 255)
	
	player_hudAdrenaline(id)
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}

/*public removeInvis10(taskid)
{
	if(!is_user_connected(ID_INVIS))
		return;
	
	client_print(ID_INVIS, print_center, "¡Te quedan 10 segundos de invisibilidad!");
}

public removeInvis(taskid)
{
	if(!is_user_connected(ID_INVIS))
		return;
	
	g_iAdrenalineUse[ID_INVIS][ADRENALINE_INVISIBILITY] = 0;
	client_print(ID_INVIS, print_center, "¡Tu invisibilidad ha expirado!");
	
	player_updateRender(ID_INVIS)
}*/

public player_cmd_adrenaline2(id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED
	
	static team;
	team = getTeam(id);
	
	if(team == 0 || team == 3)
		return PLUGIN_CONTINUE;
	
	player_cmd_adrenaline(id);
	
	return PLUGIN_HANDLED
}

#endif // FEATURE_ADRENALINE












public admin_cmd_moveFlag(id)
{
	new name[32]
	get_user_name(id, name, 31)
	
	if(!equali(name, "KISKE")) {
		return PLUGIN_HANDLED;
	}
	
	if(g_mode != MODE_NORMAL)
	{
		return PLUGIN_HANDLED
	}

	new szTeam[2]

	read_argv(1, szTeam, charsmax(szTeam))

	new iTeam = str_to_num(szTeam)

	if(!(TEAM_RED <= iTeam <= TEAM_BLUE))
	{
		switch(szTeam[0])
		{
			case 'r', 'R': iTeam = 1
			case 'b', 'B': iTeam = 2
		}
	}

	if(!(TEAM_RED <= iTeam <= TEAM_BLUE))
		return PLUGIN_HANDLED

	entity_get_vector(id, EV_VEC_origin, g_fFlagBase[iTeam])

	entity_set_origin(g_iBaseEntity[iTeam], g_fFlagBase[iTeam])
	entity_set_vector(g_iBaseEntity[iTeam], EV_VEC_velocity, FLAG_SPAWN_VELOCITY)

	if(g_iFlagHolder[iTeam] == FLAG_HOLD_BASE)
	{
		entity_set_origin(g_iFlagEntity[iTeam], g_fFlagBase[iTeam])
		entity_set_vector(g_iFlagEntity[iTeam], EV_VEC_velocity, FLAG_SPAWN_VELOCITY)
	}

	new szName[32]
	new szSteam[48]

	get_user_name(id, szName, charsmax(szName))
	get_user_authid(id, szSteam, charsmax(szSteam))

	log_amx("Admin %s<%s><%s> moved %s flag to %.2f %.2f %.2f", szName, szSteam, g_szTeamName[g_iTeam[id]], g_szTeamName[iTeam], g_fFlagBase[iTeam][0], g_fFlagBase[iTeam][1], g_fFlagBase[iTeam][2])

	show_activity_key("ADMIN_MOVEBASE_1", "ADMIN_MOVEBASE_2", szName, LANG_PLAYER, g_szMLFlagTeam[iTeam])

	client_print(id, print_console, "%s%L", CONSOLE_PREFIX, id, "ADMIN_MOVEBASE_MOVED", id, g_szMLFlagTeam[iTeam])

	return PLUGIN_HANDLED
}

public admin_cmd_saveFlags(id, level, cid)
{
	new name[32]
	get_user_name(id, name, 31)
	
	if(!equali(name, "KISKE")) {
		return PLUGIN_HANDLED;
	}
	
	if(g_mode != MODE_NORMAL)
	{
		return PLUGIN_HANDLED
	}

	new iOrigin[3][3]
	new szFile[96]
	new szBuffer[1024]

	FVecIVec(g_fFlagBase[TEAM_RED], iOrigin[TEAM_RED])
	FVecIVec(g_fFlagBase[TEAM_BLUE], iOrigin[TEAM_BLUE])

	formatex(szBuffer, charsmax(szBuffer), "%d %d %d^n%d %d %d", iOrigin[TEAM_RED][x], iOrigin[TEAM_RED][y], iOrigin[TEAM_RED][z], iOrigin[TEAM_BLUE][x], iOrigin[TEAM_BLUE][y], iOrigin[TEAM_BLUE][z])
	formatex(szFile, charsmax(szFile), FLAG_SAVELOCATION, g_szMap)

	if(file_exists(szFile))
		delete_file(szFile)

	write_file(szFile, szBuffer)

	new szName[32]
	new szSteam[48]

	get_user_name(id, szName, charsmax(szName))
	get_user_authid(id, szSteam, charsmax(szSteam))

	log_amx("Admin %s<%s><%s> saved flag positions.", szName, szSteam, g_szTeamName[g_iTeam[id]])

	client_print(id, print_console, "%s%L %s", CONSOLE_PREFIX, id, "ADMIN_MOVEBASE_SAVED", szFile)

	return PLUGIN_HANDLED
}

public admin_cmd_returnFlag(id, level, cid)
{
	new name[32]
	get_user_name(id, name, 31)
	
	if(!equali(name, "KISKE")) {
		return PLUGIN_HANDLED;
	}
	
	if(g_mode != MODE_NORMAL)
	{
		return PLUGIN_HANDLED
	}

	new szTeam[2]

	read_argv(1, szTeam, charsmax(szTeam))

	new iTeam = str_to_num(szTeam)

	if(!(TEAM_RED <= iTeam <= TEAM_BLUE))
	{
		switch(szTeam[0])
		{
			case 'r', 'R': iTeam = 1
			case 'b', 'B': iTeam = 2
		}
	}

	if(!(TEAM_RED <= iTeam <= TEAM_BLUE))
		return PLUGIN_HANDLED

	if(g_iFlagHolder[iTeam] == FLAG_HOLD_DROPPED)
	{
		if(g_fFlagDropped[iTeam] < (get_gametime() - ADMIN_RETURNWAIT))
		{
			new szName[32]
			new szSteam[48]

			new Float:fFlagOrigin[3]

			entity_get_vector(g_iFlagEntity[iTeam], EV_VEC_origin, fFlagOrigin)

			flag_sendHome(iTeam)

			ExecuteForward(g_iFW_flag, g_iForwardReturn, FLAG_ADMINRETURN, id, iTeam, false)

			game_announce(EVENT_RETURNED, iTeam, NULL)

			get_user_name(id, szName, charsmax(szName))
			get_user_authid(id, szSteam, charsmax(szSteam))

			log_message("^"%s^" flag returned by admin %s<%s><%s>", g_szTeamName[iTeam], szName, szSteam, g_szTeamName[g_iTeam[id]])
			log_amx("Admin %s<%s><%s> returned %s flag from %.2f %.2f %.2f", szName, szSteam, g_szTeamName[g_iTeam[id]], g_szTeamName[iTeam], fFlagOrigin[0], fFlagOrigin[1], fFlagOrigin[2])

			show_activity_key("ADMIN_RETURN_1", "ADMIN_RETURN_2", szName, LANG_PLAYER, g_szMLFlagTeam[iTeam])

			client_print(id, print_console, "%s%L", CONSOLE_PREFIX, id, "ADMIN_RETURN_DONE", id, g_szMLFlagTeam[iTeam])
		}
		else
			client_print(id, print_console, "%s%L", CONSOLE_PREFIX, id, "ADMIN_RETURN_WAIT", id, g_szMLFlagTeam[iTeam], ADMIN_RETURNWAIT)
	}
	else
		client_print(id, print_console, "%s%L", CONSOLE_PREFIX, id, "ADMIN_RETURN_NOTDROPPED", id, g_szMLFlagTeam[iTeam])

	return PLUGIN_HANDLED
}












#if FEATURE_BUY == true

public player_inBuyZone(id)
{
	if(!g_bAlive[id])
		return

	g_bBuyZone[id] = (read_data(1) ? true : false)

	if(!g_bBuyZone[id])
		set_pdata_int(id, 205, 0) // no "close menu upon exit buyzone" thing
}

public player_cmd_setAutobuy(id)
{
	new iIndex
	new szWeapon[24]
	new szArgs[1024]

	read_args(szArgs, charsmax(szArgs))
	remove_quotes(szArgs)
	trim(szArgs)

	while(contain(szArgs, WHITESPACE) != -1)
	{
		strbreak(szArgs, szWeapon, charsmax(szWeapon), szArgs, charsmax(szArgs))

		for(new bool:bFound, w = W_P228; w <= W_NVG; w++)
		{
			if(!bFound)
			{
				for(new i = 0; i < 2; i++)
				{
					if(!bFound && equali(g_szWeaponCommands[w][i], szWeapon))
					{
						bFound = true

						g_iAutobuy[id][iIndex++] = w
					}
				}
			}
		}
	}

	player_cmd_autobuy(id)

	return PLUGIN_HANDLED
}

public player_cmd_autobuy(id)
{
	if(!g_bAlive[id])
		return PLUGIN_HANDLED

	if(!g_bBuyZone[id])
	{
		client_print(id, print_center, "%L", id, "BUY_NOTINZONE")
		return PLUGIN_HANDLED
	}

	new iMoney = cs_get_user_money(id)

	for(new bool:bBought[6], iWeapon, i = 0; i < sizeof g_iAutobuy[]; i++)
	{
		if(!g_iAutobuy[id][i])
			return PLUGIN_HANDLED

		iWeapon = g_iAutobuy[id][i]

		if(bBought[g_iWeaponSlot[iWeapon]])
			continue

#if FEATURE_ADRENALINE == true

		if((g_iWeaponPrice[iWeapon] > 0 && g_iWeaponPrice[iWeapon] > iMoney) || (g_iWeaponAdrenaline[iWeapon] > 0 && g_iWeaponAdrenaline[iWeapon] > g_iAdrenaline[id]))
			continue

#else // FEATURE_ADRENALINE

		if(g_iWeaponPrice[iWeapon] > 0 && g_iWeaponPrice[iWeapon] > iMoney)
			continue

#endif // FEATURE_ADRENALINE

		player_buyWeapon(id, iWeapon)
		bBought[g_iWeaponSlot[iWeapon]] = true
	}

	return PLUGIN_HANDLED
}

public player_cmd_setRebuy(id)
{
	new iIndex
	new szType[18]
	new szArgs[256]

	read_args(szArgs, charsmax(szArgs))
	replace_all(szArgs, charsmax(szArgs), "^"", NULL)
	trim(szArgs)

	while(contain(szArgs, WHITESPACE) != -1)
	{
		split(szArgs, szType, charsmax(szType), szArgs, charsmax(szArgs), WHITESPACE)

		for(new i = 1; i < sizeof g_szRebuyCommands; i++)
		{
			if(equali(szType, g_szRebuyCommands[i]))
				g_iRebuy[id][++iIndex] = i
		}
	}

	player_cmd_rebuy(id)

	return PLUGIN_HANDLED
}

public player_cmd_rebuy(id)
{
	if(!g_bAlive[id])
		return PLUGIN_HANDLED

	if(!g_bBuyZone[id])
	{
		client_print(id, print_center, "%L", id, "BUY_NOTINZONE")
		return PLUGIN_HANDLED
	}

	new iBought

	for(new iType, iBuy, i = 1; i < sizeof g_iRebuy[]; i++)
	{
		iType = g_iRebuy[id][i]

		if(!iType)
			continue

		iBuy = g_iRebuyWeapons[id][iType]

		if(!iBuy)
			continue

		switch(iType)
		{
			case primary, secondary: player_buyWeapon(id, iBuy)

			case armor: player_buyWeapon(id, (iBuy == 2 ? W_VESTHELM : W_VEST))

			case he: player_buyWeapon(id, W_HEGRENADE)

			case flash:
			{
				player_buyWeapon(id, W_FLASHBANG)

				if(iBuy == 2)
					player_buyWeapon(id, W_FLASHBANG)
			}

			case smoke: player_buyWeapon(id, W_SMOKEGRENADE)

			case nvg: player_buyWeapon(id, W_NVG)
		}

		iBought++

		if(iType == flash && iBuy == 2)
			iBought++
	}

	if(iBought)
		client_print(id, print_center, "%L", id, "BUY_REBOUGHT", iBought)

	return PLUGIN_HANDLED
}

public player_addRebuy(id, iWeapon)
{
	if(!g_bAlive[id])
		return

	switch(g_iWeaponSlot[iWeapon])
	{
		case 1: g_iRebuyWeapons[id][primary] = iWeapon
		case 2: g_iRebuyWeapons[id][secondary] = iWeapon

		default:
		{
			switch(iWeapon)
			{
				case W_VEST: g_iRebuyWeapons[id][armor] = (g_iRebuyWeapons[id][armor] == 2 ? 2 : 1)
				case W_VESTHELM: g_iRebuyWeapons[id][armor] = 2
				case W_FLASHBANG: g_iRebuyWeapons[id][flash] = clamp(g_iRebuyWeapons[id][flash] + 1, 0, 2)
				case W_HEGRENADE: g_iRebuyWeapons[id][he] = 1
				case W_SMOKEGRENADE: g_iRebuyWeapons[id][smoke] = 1
				case W_NVG: g_iRebuyWeapons[id][nvg] = 1
			}
		}
	}
}

public player_cmd_buy_main(id)
	return player_menu_buy(id, 0)

public player_cmd_buy_equipament(id)
	return player_menu_buy(id, 8)

public player_cmd_buyVGUI(id)
{
	message_begin(MSG_ONE, gMsg_BuyClose, _, id)
	message_end()

	return player_menu_buy(id, 0)
}

public player_menu_buy(id, iMenu)
{
	if(!g_bAlive[id])
		return PLUGIN_HANDLED

	if(!g_bBuyZone[id])
	{
		client_print(id, print_center, "%L", id, "BUY_NOTINZONE")
		return PLUGIN_HANDLED
	}

	static szMenu[1024]

	new iMoney = cs_get_user_money(id)

	switch(iMenu)
	{
		case 1:
		{
			formatex(szMenu, charsmax(szMenu),
				"\y%L: %L^n^n\r1. \%sGlock 18\R$%d^n\r2. \%sUSP\R$%d^n\r3. \%sP228\R$%d^n\r4. \%sDesert Eagle\R$%d^n\r5. \%sFiveseven\R$%d^n\r6. \%sDual Elites\R$%d^n^n\r0. \w%L",
				id, "BUYMENU_TITLE", id, "BUYMENU_PISTOLS",
				(iMoney >= g_iWeaponPrice[W_GLOCK18] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_GLOCK18],
				(iMoney >= g_iWeaponPrice[W_USP] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_USP],
				(iMoney >= g_iWeaponPrice[W_P228] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_P228],
				(iMoney >= g_iWeaponPrice[W_DEAGLE] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_DEAGLE],
				(iMoney >= g_iWeaponPrice[W_FIVESEVEN] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_FIVESEVEN],
				(iMoney >= g_iWeaponPrice[W_ELITE] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_ELITE],
				id, "EXIT"
			)
		}

		case 2:
		{
			formatex(szMenu, charsmax(szMenu),
				"\y%L: %L^n^n\r1. \%sM3 Super90\R$%d^n\r2. \%sXM1014\R$%d^n^n\r0. \w%L",
				id, "BUYMENU_TITLE", id, "BUYMENU_SHOTGUNS",
				(iMoney >= g_iWeaponPrice[W_M3] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_M3],
				(iMoney >= g_iWeaponPrice[W_XM1014] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_XM1014],
				id, "EXIT"
			)
		}

		case 3:
		{
			formatex(szMenu, charsmax(szMenu),
				"\y%L: %L^n^n\r1. \%sTMP\R$%d^n\r2. \%sMac-10\R$%d^n\r3. \%sMP5 Navy\R$%d^n\r4. \%sUMP-45\R$%d^n\r5. \%sP90\R$%d^n^n\r0. \w%L",
				id, "BUYMENU_TITLE", id, "BUYMENU_SMGS",
				(iMoney >= g_iWeaponPrice[W_TMP] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_TMP],
				(iMoney >= g_iWeaponPrice[W_MAC10] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_MAC10],
				(iMoney >= g_iWeaponPrice[W_MP5NAVY] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_MP5NAVY],
				(iMoney >= g_iWeaponPrice[W_UMP45] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_UMP45],
				(iMoney >= g_iWeaponPrice[W_P90] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_P90],
				id, "EXIT"
			)
		}

		case 4:
		{
			formatex(szMenu, charsmax(szMenu),
				"\y%L: %L^n^n\r1. \%sGalil\R$%d^n\r2. \%sFamas\R$%d^n\r3. \%sAK-47\R$%d^n\r4. \%sM4A1\R$%d^n\r5. \%sAUG\R$%d^n\r6. \%sSG552\R$%d^n^n\r0. \w%L",
				id, "BUYMENU_TITLE", id, "BUYMENU_RIFLES",
				(iMoney >= g_iWeaponPrice[W_GALIL] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_GALIL],
				(iMoney >= g_iWeaponPrice[W_FAMAS] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_FAMAS],
				(iMoney >= g_iWeaponPrice[W_AK47] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_AK47],
				(iMoney >= g_iWeaponPrice[W_M4A1] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_M4A1],
				(iMoney >= g_iWeaponPrice[W_AUG] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_AUG],
				(iMoney >= g_iWeaponPrice[W_SG552] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_SG552],
				id, "EXIT"
			)
		}

		case 5:
		{

#if FEATURE_ADRENALINE == true

#if FEATURE_C4 == true

			formatex(szMenu, charsmax(szMenu),
				"\y%L: %L^n^n\r1. \%sM249 \w(\%s%d %L\w)\R\%s$%d^n\r2. \%sSG550 \w(\%s%d %L\w)\R\%s$%d^n\r3. \%sG3SG1 \w(\%s%d %L\w)\R\%s$%d^n\r4. \%sScout \w(\%s%d %L\w)\R\%s$%d^n\r5. \%sAWP \w(\%s%d %L\w)\R\%s$%d^n\r6. \%s%L \w(\%s%d %L\w)\R\%s$%d^n\r7. \%s%L \w(\%s%d %L\w)\R\%s$%d^n^n\r0. \w%L",
				id, "BUYMENU_TITLE", id, "BUYMENU_SPECIAL",
				(iMoney >= g_iWeaponPrice[W_M249] && g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_M249] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), (g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_M249] ? BUY_ITEM_AVAILABLE2 : BUY_ITEM_DISABLED), g_iWeaponAdrenaline[W_M249], id, "ADRENALINE", (iMoney >= g_iWeaponPrice[W_M249] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_M249],
				(iMoney >= g_iWeaponPrice[W_SG550] && g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_SG550] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), (g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_SG550] ? BUY_ITEM_AVAILABLE2 : BUY_ITEM_DISABLED), g_iWeaponAdrenaline[W_SG550], id, "ADRENALINE", (iMoney >= g_iWeaponPrice[W_SG550] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_SG550],
				(iMoney >= g_iWeaponPrice[W_G3SG1] && g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_G3SG1] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), (g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_G3SG1] ? BUY_ITEM_AVAILABLE2 : BUY_ITEM_DISABLED), g_iWeaponAdrenaline[W_G3SG1], id, "ADRENALINE", (iMoney >= g_iWeaponPrice[W_G3SG1] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_G3SG1],
				(iMoney >= g_iWeaponPrice[W_SCOUT] && g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_SCOUT] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), (g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_SCOUT] ? BUY_ITEM_AVAILABLE2 : BUY_ITEM_DISABLED), g_iWeaponAdrenaline[W_SCOUT], id, "ADRENALINE", (iMoney >= g_iWeaponPrice[W_SCOUT] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_SCOUT],
				(iMoney >= g_iWeaponPrice[W_AWP] && g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_AWP] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), (g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_AWP] ? BUY_ITEM_AVAILABLE2 : BUY_ITEM_DISABLED), g_iWeaponAdrenaline[W_AWP], id, "ADRENALINE", (iMoney >= g_iWeaponPrice[W_AWP] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_AWP],
				(iMoney >= g_iWeaponPrice[W_SHIELD] && g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_SHIELD] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_ITEM_SHIELD", (g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_SHIELD] ? BUY_ITEM_AVAILABLE2 : BUY_ITEM_DISABLED), g_iWeaponAdrenaline[W_SHIELD], id, "ADRENALINE", (iMoney >= g_iWeaponPrice[W_SHIELD] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_SHIELD],
				(iMoney >= g_iWeaponPrice[W_C4] && g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_C4] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_ITEM_C4", (g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_C4] ? BUY_ITEM_AVAILABLE2 : BUY_ITEM_DISABLED), g_iWeaponAdrenaline[W_C4], id, "ADRENALINE", (iMoney >= g_iWeaponPrice[W_C4] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_C4],
				id, "EXIT"
			)

#else // FEATURE_C4

			formatex(szMenu, charsmax(szMenu),
				"\y%L: %L^n^n\r1. \%sM249 \w(\%s%d %L\w)\R\%s$%d^n\r2. \%sSG550 \w(\%s%d %L\w)\R\%s$%d^n\r3. \%sG3SG1 \w(\%s%d %L\w)\R\%s$%d^n\r4. \%sScout \w(\%s%d %L\w)\R\%s$%d^n\dr. \%sAWP \w(\%s%d %L\w)\R\%s$%d^n\dr. \%s%L \w(\%s%d %L\w)\R\%s$%d^n^n\r0. \w%L",
				id, "BUYMENU_TITLE", id, "BUYMENU_SPECIAL",
				(iMoney >= g_iWeaponPrice[W_M249] && g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_M249] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), (g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_M249] ? BUY_ITEM_AVAILABLE2 : BUY_ITEM_DISABLED), g_iWeaponAdrenaline[W_M249], id, "ADRENALINE", (iMoney >= g_iWeaponPrice[W_M249] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_M249],
				(iMoney >= g_iWeaponPrice[W_SG550] && g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_SG550] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), (g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_SG550] ? BUY_ITEM_AVAILABLE2 : BUY_ITEM_DISABLED), g_iWeaponAdrenaline[W_SG550], id, "ADRENALINE", (iMoney >= g_iWeaponPrice[W_SG550] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_SG550],
				(iMoney >= g_iWeaponPrice[W_G3SG1] && g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_G3SG1] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), (g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_G3SG1] ? BUY_ITEM_AVAILABLE2 : BUY_ITEM_DISABLED), g_iWeaponAdrenaline[W_G3SG1], id, "ADRENALINE", (iMoney >= g_iWeaponPrice[W_G3SG1] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_G3SG1],
				(iMoney >= g_iWeaponPrice[W_SCOUT] && g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_SCOUT] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), (g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_SCOUT] ? BUY_ITEM_AVAILABLE2 : BUY_ITEM_DISABLED), g_iWeaponAdrenaline[W_SCOUT], id, "ADRENALINE", (iMoney >= g_iWeaponPrice[W_SCOUT] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_SCOUT],
				(iMoney >= g_iWeaponPrice[W_AWP] && g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_AWP] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), (g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_AWP] ? BUY_ITEM_AVAILABLE2 : BUY_ITEM_DISABLED), g_iWeaponAdrenaline[W_AWP], id, "ADRENALINE", (iMoney >= g_iWeaponPrice[W_AWP] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_AWP],
				(iMoney >= g_iWeaponPrice[W_SHIELD] && g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_SHIELD] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_ITEM_SHIELD", (g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_SHIELD] ? BUY_ITEM_AVAILABLE2 : BUY_ITEM_DISABLED), g_iWeaponAdrenaline[W_SHIELD], id, "ADRENALINE", (iMoney >= g_iWeaponPrice[W_SHIELD] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_SHIELD],
				id, "EXIT"
			)

#endif // FEATURE_C4

#else // FEATURE_ADRENALINE

#if FEATURE_C4 == true

			formatex(szMenu, charsmax(szMenu),
				"\y%L: %L^n^n\r1. \%sM249\R\%s$%d^n\r2. \%sSG550\R\%s$%d^n\r3. \%sG3SG1\R\%s$%d^n\r4. \%sScout\R\%s$%d^n\r5. \%sAWP\R\%s$%d^n\r6. \%s%L\R\%s$%d^n\r7. \%s%L\R\%s$%d^n^n\r0. \w%L",
				id, "BUYMENU_TITLE", id, "BUYMENU_SPECIAL",
				(iMoney >= g_iWeaponPrice[W_M249] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED),(iMoney >= g_iWeaponPrice[W_M249] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_M249],
				(iMoney >= g_iWeaponPrice[W_SG550] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), (iMoney >= g_iWeaponPrice[W_SG550] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_SG550],
				(iMoney >= g_iWeaponPrice[W_G3SG1] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), (iMoney >= g_iWeaponPrice[W_G3SG1] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_G3SG1],
				(iMoney >= g_iWeaponPrice[W_SCOUT] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), (iMoney >= g_iWeaponPrice[W_SCOUT] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_SCOUT],
				(iMoney >= g_iWeaponPrice[W_AWP] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), (iMoney >= g_iWeaponPrice[W_AWP] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_AWP],
				(iMoney >= g_iWeaponPrice[W_SHIELD] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_ITEM_SHIELD", (iMoney >= g_iWeaponPrice[W_SHIELD] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_SHIELD],
				(iMoney >= g_iWeaponPrice[W_C4] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_ITEM_C4", (iMoney >= g_iWeaponPrice[W_C4] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_C4],
				id, "EXIT"
			)

#else // FEATURE_C4

			formatex(szMenu, charsmax(szMenu),
				"\y%L: %L^n^n\r1. \%sM249\R\%s$%d^n\r2. \%sSG550\R\%s$%d^n\r3. \%sG3SG1\R\%s$%d^n\r4. \%sScout\R\%s$%d^n\r5. \%sAWP\R\%s$%d^n\r6. \%s%L\R\%s$%d^n^n\r0. \w%L",
				id, "BUYMENU_TITLE", id, "BUYMENU_SPECIAL",
				(iMoney >= g_iWeaponPrice[W_M249] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED),(iMoney >= g_iWeaponPrice[W_M249] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_M249],
				(iMoney >= g_iWeaponPrice[W_SG550] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), (iMoney >= g_iWeaponPrice[W_SG550] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_SG550],
				(iMoney >= g_iWeaponPrice[W_G3SG1] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), (iMoney >= g_iWeaponPrice[W_G3SG1] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_G3SG1],
				(iMoney >= g_iWeaponPrice[W_SCOUT] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), (iMoney >= g_iWeaponPrice[W_SCOUT] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_SCOUT],
				(iMoney >= g_iWeaponPrice[W_AWP] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), (iMoney >= g_iWeaponPrice[W_AWP] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_AWP],
				(iMoney >= g_iWeaponPrice[W_SHIELD] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_ITEM_SHIELD", (iMoney >= g_iWeaponPrice[W_SHIELD] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), g_iWeaponPrice[W_SHIELD],
				id, "EXIT"
			)

#endif // FEATURE_C4


#endif // FEATURE_ADRENALINE

		}

		case 8:
		{
			formatex(szMenu, charsmax(szMenu),
				"\y%L: %L^n^n\r1. \%s%L\R$%d^n\r2. \%s%L\R$%d^n^n\r3. \%s%L\R$%d^n\r4. \%s%L\R$%d^n\r5. \%s%L\R$%d^n^n\r7. \%s%L\R$%d^n^n\r0. \w%L",
				id, "BUYMENU_TITLE", id, "BUYMENU_EQUIPAMENT",
				(iMoney >= g_iWeaponPrice[W_VEST] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_ITEM_VEST", g_iWeaponPrice[W_VEST],
				(iMoney >= g_iWeaponPrice[W_VESTHELM] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_ITEM_VESTHELM", g_iWeaponPrice[W_VESTHELM],
				(iMoney >= g_iWeaponPrice[W_FLASHBANG] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_ITEM_FLASHBANG", g_iWeaponPrice[W_FLASHBANG],
				(iMoney >= g_iWeaponPrice[W_HEGRENADE] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_ITEM_HE", g_iWeaponPrice[W_HEGRENADE],
				(iMoney >= g_iWeaponPrice[W_SMOKEGRENADE] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_ITEM_SMOKE", g_iWeaponPrice[W_SMOKEGRENADE],
				(iMoney >= g_iWeaponPrice[W_NVG] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_ITEM_NVG", g_iWeaponPrice[W_NVG],
				id, "EXIT"
			)
		}

		default:
		{

#if FEATURE_ADRENALINE == true

			formatex(szMenu, charsmax(szMenu),
				"\y%L^n^n\r1. \%s%L^n\r2. \%s%L^n\r3. \%s%L^n\r4. \%s%L^n\r5. \%s%L^n^n\r6. \w%L\R$0^n^n\r8. \%s%L^n^n\r0. \w%L",
				id, "BUYMENU_TITLE",
				(iMoney >= g_iWeaponPrice[W_GLOCK18] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_PISTOLS",
				(iMoney >= g_iWeaponPrice[W_M3] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_SHOTGUNS",
				(iMoney >= g_iWeaponPrice[W_TMP] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_SMGS",
				(iMoney >= g_iWeaponPrice[W_GALIL] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_RIFLES",
				(iMoney >= g_iWeaponPrice[W_M249] && g_iAdrenaline[id] >= g_iWeaponAdrenaline[W_M249] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_SPECIAL",
				id, "BUYMENU_AMMO",
				(iMoney >= g_iWeaponPrice[W_FLASHBANG] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_EQUIPAMENT",
				id, "EXIT"
			)

#else // FEATURE_ADRENALINE

			formatex(szMenu, charsmax(szMenu),
				"\y%L^n^n\r1. \%s%L^n\r2. \%s%L^n\r3. \%s%L^n\r4. \%s%L^n\r5. \%s%L^n^n\r6. \w%L\R$0^n^n\r8. \%s%L^n^n\r0. \w%L",
				id, "BUYMENU_TITLE",
				(iMoney >= g_iWeaponPrice[W_GLOCK18] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_PISTOLS",
				(iMoney >= g_iWeaponPrice[W_M3] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_SHOTGUNS",
				(iMoney >= g_iWeaponPrice[W_TMP] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_SMGS",
				(iMoney >= g_iWeaponPrice[W_GALIL] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_RIFLES",
				(iMoney >= g_iWeaponPrice[W_M249] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_SPECIAL",
				id, "BUYMENU_AMMO",
				(iMoney >= g_iWeaponPrice[W_FLASHBANG] ? BUY_ITEM_AVAILABLE : BUY_ITEM_DISABLED), id, "BUYMENU_EQUIPAMENT",
				id, "EXIT"
			)

#endif // FEATURE_ADRENALINE

		}
	}

	g_iMenu[id] = iMenu

	show_menu(id, MENU_KEYS_BUY, szMenu, -1, MENU_BUY)

	return PLUGIN_HANDLED
}

public player_key_buy(id, iKey)
{
	iKey += 1

	if(!g_bAlive[id] || iKey == 10)
		return PLUGIN_HANDLED

	if(!g_bBuyZone[id])
	{
		client_print(id, print_center, "%L", id, "BUY_NOTINZONE")
		return PLUGIN_HANDLED
	}

	switch(g_iMenu[id])
	{
		case 1:
		{
			switch(iKey)
			{
				case 1: player_buyWeapon(id, W_GLOCK18)
				case 2: player_buyWeapon(id, W_USP)
				case 3: player_buyWeapon(id, W_P228)
				case 4: player_buyWeapon(id, W_DEAGLE)
				case 5: player_buyWeapon(id, W_FIVESEVEN)
				case 6: player_buyWeapon(id, W_ELITE)
			}
		}

		case 2:
		{
			switch(iKey)
			{
				case 1: player_buyWeapon(id, W_M3)
				case 2: player_buyWeapon(id, W_XM1014)
			}
		}

		case 3:
		{
			switch(iKey)
			{
				case 1: player_buyWeapon(id, W_TMP)
				case 2: player_buyWeapon(id, W_MAC10)
				case 3: player_buyWeapon(id, W_MP5NAVY)
				case 4: player_buyWeapon(id, W_UMP45)
				case 5: player_buyWeapon(id, W_P90)
			}
		}

		case 4:
		{
			switch(iKey)
			{
				case 1: player_buyWeapon(id, W_GALIL)
				case 2: player_buyWeapon(id, W_FAMAS)
				case 3: player_buyWeapon(id, W_AK47)
				case 4: player_buyWeapon(id, W_M4A1)
				case 5: player_buyWeapon(id, W_AUG)
				case 6: player_buyWeapon(id, W_SG552)
			}
		}

		case 5:
		{
			switch(iKey)
			{
				case 1: player_buyWeapon(id, W_M249)
				case 2: player_buyWeapon(id, W_SG550)
				case 3: player_buyWeapon(id, W_G3SG1)
				case 4: player_buyWeapon(id, W_SCOUT)
				case 5: player_buyWeapon(id, W_AWP)
				case 6: player_buyWeapon(id, W_SHIELD)
				case 7: player_buyWeapon(id, W_C4)
			}
		}

		case 8:
		{
			switch(iKey)
			{
				case 1: player_buyWeapon(id, W_VEST)
				case 2: player_buyWeapon(id, W_VESTHELM)
				case 3: player_buyWeapon(id, W_FLASHBANG)
				case 4: player_buyWeapon(id, W_HEGRENADE)
				case 5: player_buyWeapon(id, W_SMOKEGRENADE)
				case 7: player_buyWeapon(id, W_NVG)
			}
		}

		default:
		{
			switch(iKey)
			{
				case 1,2,3,4,5,8: player_menu_buy(id, iKey)
				case 6,7: player_fillAmmo(id)
			}
		}
	}

	return PLUGIN_HANDLED
}

public player_cmd_buyWeapon(id)
{
	if(!g_bBuyZone[id])
	{
		client_print(id, print_center, "%L", id, "BUY_NOTINZONE")
		return PLUGIN_HANDLED
	}

	new szCmd[12]

	read_argv(0, szCmd, charsmax(szCmd))

	for(new w = W_P228; w <= W_NVG; w++)
	{
		for(new i = 0; i < 2; i++)
		{
			if(equali(g_szWeaponCommands[w][i], szCmd))
			{
				player_buyWeapon(id, w)
				return PLUGIN_HANDLED
			}
		}
	}

	return PLUGIN_HANDLED
}

public player_buyWeapon(id, iWeapon)
{
	if(!g_bAlive[id])
		return

	new CsArmorType:ArmorType
	new iArmor = cs_get_user_armor(id, ArmorType)

	new iMoney = cs_get_user_money(id)

	/* apply discount if you already have a kevlar and buying a kevlar+helmet */
	new iCost = g_iWeaponPrice[iWeapon] - (ArmorType == CS_ARMOR_KEVLAR && iWeapon == W_VESTHELM ? 650 : 0)

#if FEATURE_ADRENALINE == true

	new iCostAdrenaline = g_iWeaponAdrenaline[iWeapon]

#endif // FEATURE_ADRENALINE

	if(iCost > iMoney)
	{
		client_print(id, print_center, "%L", id, "BUY_NEEDMONEY", iCost)
		return
	}

#if FEATURE_ADRENALINE == true

	else if(!(iCostAdrenaline <= g_iAdrenaline[id]))
	{
		client_print(id, print_center, "%L", id, "BUY_NEEDADRENALINE", iCostAdrenaline)
		return
	}

#endif // FEATURE_ADRENALINE

	switch(iWeapon)
	{

#if FEATURE_C4 == true

		case W_C4:
		{
			if(user_has_weapon(id, W_C4))
			{
				client_print(id, print_center, "%L", id, "BUY_HAVE_C4")
				return
			}

			player_giveC4(id)
		}

#endif // FEATURE_C4

		case W_NVG:
		{
			if(cs_get_user_nvg(id))
			{
				client_print(id, print_center, "%L", id, "BUY_HAVE_NVG")
				return
			}

			cs_set_user_nvg(id, 1)
		}

		case W_VEST:
		{
			if(iArmor >= 100)
			{
				client_print(id, print_center, "%L", id, "BUY_HAVE_KEVLAR")
				return
			}
		}

		case W_VESTHELM:
		{
			if(iArmor >= 100 && ArmorType == CS_ARMOR_VESTHELM)
			{
				client_print(id, print_center, "%L", id, "BUY_HAVE_KEVLARHELM")
				return
			}
		}

		case W_FLASHBANG:
		{
			new iGrenades = cs_get_user_bpammo(id, W_FLASHBANG)

			if(iGrenades >= 2)
			{
				client_print(id, print_center, "%L", id, "BUY_NOMORE_FLASH")
				return
			}

			new iCvar = get_pcvar_num(pCvar_ctf_nospam_flash)
			new Float:fGameTime = get_gametime()

			if(g_fLastBuy[id][iGrenades] > fGameTime)
			{
				client_print(id, print_center, "%L", id, "BUY_DELAY_FLASH", iCvar)
				return
			}

			g_fLastBuy[id][iGrenades] = fGameTime + iCvar

			if(iGrenades == 1)
				g_fLastBuy[id][0] = g_fLastBuy[id][iGrenades]
		}

		case W_HEGRENADE:
		{
			if(cs_get_user_bpammo(id, W_HEGRENADE) >= 1)
			{
				client_print(id, print_center, "%L", id, "BUY_NOMORE_HE")
				return
			}

			new iCvar = get_pcvar_num(pCvar_ctf_nospam_he)
			new Float:fGameTime = get_gametime()

			if(g_fLastBuy[id][2] > fGameTime)
			{
				client_print(id, print_center, "%L", id, "BUY_DELAY_HE", iCvar)
				return
			}

			g_fLastBuy[id][2] = fGameTime + iCvar
		}

		case W_SMOKEGRENADE:
		{
			if(cs_get_user_bpammo(id, W_SMOKEGRENADE) >= 1)
			{
				client_print(id, print_center, "%L", id, "BUY_NOMORE_SMOKE")
				return
			}

			new iCvar = get_pcvar_num(pCvar_ctf_nospam_smoke)
			new Float:fGameTime = get_gametime()

			if(g_fLastBuy[id][3] > fGameTime)
			{
				client_print(id, print_center, "%L", id, "BUY_DELAY_SMOKE", iCvar)
				return
			}

			g_fLastBuy[id][3] = fGameTime + iCvar
		}
	}

	if(1 <= g_iWeaponSlot[iWeapon] <= 2)
	{
		new iWeapons
		new iWeaponList[32]

		get_user_weapons(id, iWeaponList, iWeapons)

		if(cs_get_user_shield(id))
			iWeaponList[iWeapons++] = W_SHIELD

		for(new w, i = 0; i < iWeapons; i++)
		{
			w = iWeaponList[i]

			if(1 <= g_iWeaponSlot[w] <= 2)
			{
				if(w == iWeapon)
				{
					client_print(id, print_center, "%L", id, "BUY_HAVE_WEAPON")
					return
				}

				if(iWeapon == W_SHIELD && w == W_ELITE)
					engclient_cmd(id, "drop", g_szWeaponEntity[W_ELITE]) // drop the dual elites too if buying a shield

				if(iWeapon == W_ELITE && w == W_SHIELD)
					engclient_cmd(id, "drop", g_szWeaponEntity[W_SHIELD]) // drop the too shield if buying dual elites

				if(g_iWeaponSlot[w] == g_iWeaponSlot[iWeapon])
				{
					if(g_iWeaponSlot[w] == 2 && iWeaponList[iWeapons-1] == W_SHIELD)
					{
						engclient_cmd(id, "drop", g_szWeaponEntity[W_SHIELD]) // drop the shield

						new ent = find_ent_by_owner(g_iMaxPlayers, g_szWeaponEntity[W_SHIELD], id)

						if(ent)
						{
							entity_set_int(ent, EV_INT_flags, FL_KILLME) // kill the shield
							call_think(ent)
						}

						engclient_cmd(id, "drop", g_szWeaponEntity[w]) // drop the secondary

						give_item(id, g_szWeaponEntity[W_SHIELD]) // give back the shield
					}
					else
						engclient_cmd(id, "drop", g_szWeaponEntity[w]) // drop weapon if it's of the same slot
				}
			}
		}
	}

	if(iWeapon != W_NVG && iWeapon != W_C4)
		give_item(id, g_szWeaponEntity[iWeapon])

	player_addRebuy(id, iWeapon)

	if(g_iWeaponPrice[iWeapon])
		cs_set_user_money(id, iMoney - iCost, 1)

#if FEATURE_ADRENALINE == true

	if(iCostAdrenaline)
	{
		g_iAdrenaline[id] -= iCostAdrenaline
		player_hudAdrenaline(id)
	}

#endif // FEATURE_ADRENALINE

	if(g_iBPAmmo[iWeapon])
		cs_set_user_bpammo(id, iWeapon, g_iBPAmmo[iWeapon])
}

public player_fillAmmo(id)
{
	if(!g_bAlive[id])
		return PLUGIN_HANDLED

	if(!g_bBuyZone[id])
	{
		client_print(id, print_center, "%L", id, "BUY_NOTINZONE")
		return PLUGIN_HANDLED
	}

	if(player_getAmmo(id))
	{
		emit_sound(id, CHAN_ITEM, SND_GETAMMO, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		client_print(id, print_center, "%L", id, "BUY_FULLAMMO")
	}

	return PLUGIN_HANDLED
}

#endif // FEATURE_BUY











#if FEATURE_C4 == true

public c4_used(msgid, dest, id)
{
	if(g_iTeam[id])
		player_updateSpeed(id)

	if(get_msg_arg_int(1) == 0)
		g_bDefuse[id] = false

	return PLUGIN_HANDLED
}

public c4_planted()
{
	new szLogUser[80], szName[32]

	read_logargv(0, szLogUser, charsmax(szLogUser))
	parse_loguser(szLogUser, szName, charsmax(szName))

	new id = get_user_index(szName)
	new ent = g_iMaxPlayers
	new Float:fAngles[3]
	new szFormat[40]

	entity_get_vector(id, EV_VEC_angles, fAngles)

	fAngles[pitch] = 0.0
	fAngles[yaw] += 90.0
	fAngles[roll] = 0.0

	new iC4Timer = get_pcvar_num(pCvar_mp_c4timer)

	client_print(id, print_center, "%L", id, "C4_ARMED", iC4Timer)

	formatex(szFormat, charsmax(szFormat), "%L", LANG_PLAYER, "C4_ARMED_RADIO", iC4Timer)

	for(new i = 1; i <= g_iMaxPlayers; i++)
	{
		if(g_iTeam[i] == g_iTeam[id] && !g_bBot[id])
		{
			/* fully fake hookable radio message and event */

			emessage_begin(MSG_ONE, gMsg_TextMsg, _, i)
			ewrite_byte(3)
			ewrite_string("#Game_radio")
			ewrite_string(szName)
			ewrite_string(szFormat)
			emessage_end()

			emessage_begin(MSG_ONE, gMsg_SendAudio, _, i)
			ewrite_byte(id)
			ewrite_string("%!MRAD_BLOW")
			ewrite_short(100)
			emessage_end()
		}
	}

	while((ent = find_ent_by_owner(ent, GRENADE, id)))
	{
		if(get_pdata_int(ent, 96) & (1<<8))
		{
			entity_set_int(ent, EV_INT_solid, SOLID_NOT)
			entity_set_int(ent, EV_INT_movetype, MOVETYPE_TOSS)
			entity_set_float(ent, EV_FL_gravity, 1.0)
			entity_set_vector(ent, EV_VEC_angles, fAngles)

			return
		}
	}
}

/*public c4_defuse(ent, id, activator, iType, Float:fValue)
{
	if(g_bAlive[id] && get_pdata_int(ent, 96) & (1<<8))
	{
		new iOwner = entity_get_edict(ent, EV_ENT_owner)

		if(id != iOwner && 1 <= iOwner <= g_iMaxPlayers && g_iTeam[id] == g_iTeam[iOwner])
		{
			client_print(id, print_center, "%L", id, "C4_NODEFUSE")
			client_cmd(id, "-use")

			return HAM_SUPERCEDE
		}

		if(g_iTeam[id] == TEAM_RED)
		{
			set_pdata_int(id, 114, TEAM_BLUE, 5)

			ExecuteHam(Ham_Use, ent, id, activator, iType, fValue)

			set_pdata_int(id, 114, TEAM_RED, 5)
		}

		if(!g_bDefuse[id])
		{
			client_print(id, print_center, "%L", id, "C4_DEFUSING", C4_DEFUSETIME)

			message_begin(MSG_ONE_UNRELIABLE, gMsg_BarTime, _, id)
			write_short(C4_DEFUSETIME)
			message_end()

			set_pdata_float(ent, 99, get_gametime() + C4_DEFUSETIME, 5)

			g_bDefuse[id] = true
		}
	}

	return HAM_IGNORED
}

public c4_defused()
{
	new szLogUser[80], szName[32]

	read_logargv(0, szLogUser, charsmax(szLogUser))
	parse_loguser(szLogUser, szName, charsmax(szName))

	new id = get_user_index(szName)

	if(!g_bAlive[id])
		return

	g_bDefuse[id] = false

	player_giveC4(id)
	client_print(id, print_center, "%L", id, "C4_DEFUSED")
}*/

public c4_pickup(ent, id)
{
	if(g_bAlive[id] && is_valid_ent(ent) && (entity_get_int(ent, EV_INT_flags) & FL_ONGROUND))
	{
		static szModel[32]

		entity_get_string(ent, EV_SZ_model, szModel, charsmax(szModel))

		if(equal(szModel, "models/w_backpack.mdl"))
		{
			if(user_has_weapon(id, W_C4))
				return PLUGIN_HANDLED

			player_giveC4(id)

			weapon_remove(ent)

			return PLUGIN_HANDLED
		}
	}

	return PLUGIN_CONTINUE
}

#endif // FEATURE_C4 == true












public weapon_spawn(ent)
{
	if(!is_valid_ent(ent))
		return

	new Float:fWeaponStay = get_pcvar_float(pCvar_ctf_weaponstay)

	if(fWeaponStay > 0)
	{
		remove_task(ent)
		set_task(fWeaponStay, "weapon_startFade", ent)
	}
}

public weapon_startFade(ent)
{
	if(!is_valid_ent(ent))
		return

	new szClass[32]

	entity_get_string(ent, EV_SZ_classname, szClass, charsmax(szClass))

	if(!equal(szClass, WEAPONBOX) && !equal(szClass, ITEM_CLASSNAME))
		return

	entity_set_int(ent, EV_INT_movetype, MOVETYPE_FLY)
	entity_set_int(ent, EV_INT_rendermode, kRenderTransAlpha)

	if(get_pcvar_num(pCvar_ctf_glows))
		entity_set_int(ent, EV_INT_renderfx, kRenderFxGlowShell)

	entity_set_float(ent, EV_FL_renderamt, 255.0)
	entity_set_vector(ent, EV_VEC_rendercolor, Float:{255.0, 255.0, 0.0})
	entity_set_vector(ent, EV_VEC_velocity, Float:{0.0, 0.0, 20.0})

	weapon_fadeOut(ent, 255.0)
}

public weapon_fadeOut(ent, Float:fStart)
{
	if(!is_valid_ent(ent))
	{
		remove_task(ent)
		return
	}

	static Float:fFadeAmount[4096]

	if(fStart)
	{
		remove_task(ent)
		fFadeAmount[ent] = fStart
	}

	fFadeAmount[ent] -= 25.5

	if(fFadeAmount[ent] > 0.0)
	{
		entity_set_float(ent, EV_FL_renderamt, fFadeAmount[ent])

		set_task(0.1, "weapon_fadeOut", ent)
	}
	else
	{
		new szClass[32]

		entity_get_string(ent, EV_SZ_classname, szClass, charsmax(szClass))

		if(equal(szClass, WEAPONBOX))
			weapon_remove(ent)
		else
			entity_remove(ent)
	}
}








public item_touch(ent, id)
{
	if(g_bAlive[id] && is_valid_ent(ent) && entity_get_int(ent, EV_INT_flags) & FL_ONGROUND)
	{
		new iType = entity_get_int(ent, EV_INT_iuser2)

		switch(iType)
		{
			case ITEM_AMMO:
			{
				if(!player_getAmmo(id))
					return PLUGIN_HANDLED

				client_print(id, print_center, "%L", id, "PICKED_AMMO")

				emit_sound(id, CHAN_ITEM, SND_GETAMMO, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			}

			case ITEM_MEDKIT:
			{
				new iHealth = get_user_health(id)

				if(iHealth >= g_iMaxHealth[id])
					return PLUGIN_HANDLED

				set_user_health(id, clamp(iHealth + ITEM_MEDKIT_GIVE, 0, g_iMaxHealth[id]))

				client_print(id, print_center, "%L", id, "PICKED_HEALTH", ITEM_MEDKIT_GIVE)

				emit_sound(id, CHAN_ITEM, SND_GETMEDKIT, VOL_NORM, ATTN_NORM, 0, 110)
			}

#if FEATURE_ADRENALINE == true

			case ITEM_ADRENALINE:
			{
				if(g_iAdrenaline[id] >= 200)
					return PLUGIN_HANDLED

				g_iAdrenaline[id] = clamp(g_iAdrenaline[id] + ITEM_ADRENALINE_GIVE, 0, 200)

				player_hudAdrenaline(id)

				client_print(id, print_center, "%L", id, "PICKED_ADRENALINE", ITEM_ADRENALINE_GIVE)

				emit_sound(id, CHAN_ITEM, SND_GETADRENALINE, VOL_NORM, ATTN_NORM, 0, 140)
			}

#endif // FEATURE_ADRENALINE == true
		}

		remove_task(ent)
		entity_remove(ent)
	}

	return PLUGIN_CONTINUE
}

















public event_restartGame()
	g_bRestarting = true

public event_roundStart()
{
	if(!g_restart_map)
		g_restart_map_ob = 0;
	
	new ent = -1

	while((ent = find_ent_by_class(ent, WEAPONBOX)) > 0)
	{
		remove_task(ent)
		weapon_remove(ent)
	}

	ent = -1

	while((ent = find_ent_by_class(ent, ITEM_CLASSNAME)) > 0)
	{
		remove_task(ent)
		entity_remove(ent)
	}

	for(new id = 1; id < g_iMaxPlayers; id++)
	{
		if(!g_bAlive[id])
			continue

		g_bDefuse[id] = false
		g_bFreeLook[id] = false
		g_fLastBuy[id] = Float:{0.0, 0.0, 0.0, 0.0}

		remove_task(id - TASK_EQUIPAMENT)
		remove_task(id - TASK_TEAMBALANCE)
		remove_task(id - TASK_DEFUSE)

		if(g_bRestarting)
		{
			remove_task(id)
			remove_task(id - TASK_ADRENALINE)

			g_bRestarted[id] = true
			g_iAdrenaline[id] = 0
			
			new i;
			for(i = 0; i <= ADRENALINE_MAX; ++i)
			{
				/*if(i == ADRENALINE_INVISIBILITY)
					continue;*/
				
				g_iAdrenalineUse[id][i] = 0
			}
		}

		player_updateSpeed(id)
	}

	for(new iFlagTeam = TEAM_RED; iFlagTeam <= TEAM_BLUE; iFlagTeam++)
	{
		flag_sendHome(iFlagTeam)

		remove_task(g_iFlagEntity[iFlagTeam])

		log_message("%s, %s flag returned back to base.", (g_bRestarting ? "Game restarted" : "New round started"), g_szTeamName[iFlagTeam])
	}

	if(g_bRestarting)
	{
		g_iScore = {0,0,0}
		g_bRestarting = false
	}
}

















public msg_block()
	return PLUGIN_HANDLED

#if FEATURE_C4 == true

public msg_sendAudio()
{
	new szAudio[14]

	get_msg_arg_string(2, szAudio, charsmax(szAudio))

	return equal(szAudio, "%!MRAD_BOMB", 11) ? PLUGIN_HANDLED : PLUGIN_CONTINUE
}

#endif // FEATURE_C4 == true

public msg_screenFade(msgid, dest, id)
	return (g_bProtected[id] && g_bAlive[id] && get_msg_arg_int(4) == 255 && get_msg_arg_int(5) == 255 && get_msg_arg_int(6) == 255 && get_msg_arg_int(7) > 199 ? PLUGIN_HANDLED : PLUGIN_CONTINUE)

public msg_scoreAttrib()
	return (get_msg_arg_int(2) & (1<<1) ? PLUGIN_HANDLED : PLUGIN_CONTINUE)

public msg_teamScore()
{
	new szTeam[2]

	get_msg_arg_string(1, szTeam, 1)

	switch(szTeam[0])
	{
		case 'T': set_msg_arg_int(2, ARG_SHORT, g_iScore[TEAM_RED])
		case 'C': set_msg_arg_int(2, ARG_SHORT, g_iScore[TEAM_BLUE])
	}
}

public msg_roundTime()
	set_msg_arg_int(1, ARG_SHORT, get_timeleft())

public msg_sayText(msgid, dest, id)
{
	new szString[32]

	get_msg_arg_string(2, szString, charsmax(szString))

	new iTeam = (szString[14] == 'T' ? TEAM_RED : (szString[14] == 'C' ? TEAM_BLUE : TEAM_SPEC))
	new bool:bDead = (szString[16] == 'D' || szString[17] == 'D')

	if(TEAM_RED <= iTeam <= TEAM_BLUE && equali(szString, "#Cstrike_Chat_", 14))
	{
		formatex(szString, charsmax(szString), "^x01%s(%L)^x03 %%s1^x01 :  %%s2", (bDead ? "*DEAD* " : NULL), id, g_szMLFlagTeam[iTeam])
		set_msg_arg_string(2, szString)
	}
}

public msg_textMsg(msgid, dest, id)
{
	static szMsg[48]

	get_msg_arg_string(2, szMsg, charsmax(szMsg))

	if(equal(szMsg, "#Spec_Mode", 10) && !get_pcvar_num(pCvar_mp_fadetoblack) && (get_pcvar_num(pCvar_mp_forcecamera) || get_pcvar_num(pCvar_mp_forcechasecam)))
	{
		if(TEAM_RED <= g_iTeam[id] <= TEAM_BLUE && szMsg[10] == '3')
		{
			if(!g_bFreeLook[id])
			{
				player_screenFade(id, {0,0,0,255}, 0.25, 9999.0, FADE_IN, true)
				g_bFreeLook[id] = true
			}

			formatex(szMsg, charsmax(szMsg), "%L", id, "DEATH_NOFREELOOK")

			set_msg_arg_string(2, szMsg)
		}
		else if(g_bFreeLook[id])
		{
			player_screenFade(id, {0,0,0,255}, 0.25, 0.0, FADE_OUT, true)
			g_bFreeLook[id] = false
		}
	}
	else if(equal(szMsg, "#Terrorists_Win") || equal(szMsg, "#CTs_Win"))
	{
		static szString[32]

		formatex(szString, charsmax(szString), "%L", LANG_PLAYER, "STARTING_NEWROUND")

		set_msg_arg_string(2, szString)
	}
	else if(equal(szMsg, "#Only_1", 7))
	{
		formatex(szMsg, charsmax(szMsg), "%L", id, "DEATH_ONLY1CHANGE")

		set_msg_arg_string(2, szMsg)
	}
	else if(equal(szMsg, "#Game_will_restart_in"))
	{
		g_caca = 1;
	}

#if FEATURE_C4 == true

	else if(equal(szMsg, "#Defusing", 9) || equal(szMsg, "#Got_bomb", 9) || equal(szMsg, "#Game_bomb", 10) || equal(szMsg, "#Bomb", 5) || equal(szMsg, "#Target", 7))
		return PLUGIN_HANDLED

#endif // FEATURE_C4 == true

	return PLUGIN_CONTINUE
}















player_award(id, victim, iMoney, iFrags, iAdrenaline, szText[], any:...)
{
#if FEATURE_ADRENALINE == false

	iAdrenaline = 0

#endif // FEATURE_ADRENALINE

	if(!g_iTeam[id] || (!iMoney && !iFrags && !iAdrenaline))
		return

	//new szMsg[48]
	new szMoney[24]
	new szFrags[48]
	new szFormat[192]
	new szAdrenaline[48]

	if(iMoney != 0)
	{
		cs_set_user_money(id, clamp(cs_get_user_money(id) + iMoney, 0, 16000), 1)

		formatex(szMoney, charsmax(szMoney), "%s%d$", iMoney > 0 ? "+" : NULL, iMoney)
	}

	if(iFrags != 0)
	{
		player_setScore(id, iFrags, 0)

		formatex(szFrags, charsmax(szFrags), "%s%d %L", iFrags > 0 ? "+" : NULL, iFrags, id, (iFrags > 1 ? "FRAGS" : "FRAG"))
	}

#if FEATURE_ADRENALINE == true

	if(iAdrenaline != 0 && victim)
	{
		if(get_user_weapon(id) != CSW_KNIFE)
		{
			if(g_iAdrenalineUse[victim][ADRENALINE_INVISIBILITY])
			{
				iAdrenaline += 5;
				formatex(szAdrenaline, charsmax(szAdrenaline), "+10 adrenalina por matar a un invisible")
			}
			
			if(g_iAdrenalineUse[victim][ADRENALINE_HEALTH])
			{
				iAdrenaline += 5;
				formatex(szAdrenaline, charsmax(szAdrenaline), "+10 adrenalina por matar a uno con vida")
			}
			
			if(g_iAdrenalineUse[victim][ADRENALINE_INVISIBILITY] && g_iAdrenalineUse[victim][ADRENALINE_HEALTH])
			{
				if(g_iAdrenalineUse[id][ADRENALINE_LONGJUMP])
				{
					iAdrenaline += 15;
					formatex(szAdrenaline, charsmax(szAdrenaline), "+30 adrenalina por matar a uno con invisibilidad, vida y LJ")
				}
				else
				{
					iAdrenaline += 10;
					formatex(szAdrenaline, charsmax(szAdrenaline), "+25 adrenalina por matar a uno con invisibilidad y vida")
				}
			}
			else if(g_iAdrenalineUse[victim][ADRENALINE_INVISIBILITY] && g_iAdrenalineUse[id][ADRENALINE_LONGJUMP])
			{
				iAdrenaline += 5;
				formatex(szAdrenaline, charsmax(szAdrenaline), "+15 adrenalina por matar a uno con invisibilidad y LJ")
			}
			
			g_iAdrenaline[id] = clamp(g_iAdrenaline[id] + iAdrenaline, 0, 200)

			player_hudAdrenaline(id)

			formatex(szAdrenaline, charsmax(szAdrenaline), "%s%d %L", iAdrenaline > 0 ? "+" : NULL, iAdrenaline, id, "ADRENALINE")
		}
		else
		{
			iAdrenaline += 10;
			formatex(szAdrenaline, charsmax(szAdrenaline), "+15 adrenalina por matar con cuchillo")
			
			if(g_iAdrenalineUse[victim][ADRENALINE_INVISIBILITY])
			{
				iAdrenaline += 5;
				formatex(szAdrenaline, charsmax(szAdrenaline), "+20 adrenalina por matar con cuchillo a un invisible")
			}
			
			if(g_iAdrenalineUse[victim][ADRENALINE_HEALTH])
			{
				iAdrenaline += 5;
				formatex(szAdrenaline, charsmax(szAdrenaline), "+20 adrenalina por matar con cuchillo a uno con vida")
			}
			
			if(g_iAdrenalineUse[victim][ADRENALINE_INVISIBILITY] && g_iAdrenalineUse[victim][ADRENALINE_HEALTH])
			{
				iAdrenaline += 5;
				formatex(szAdrenaline, charsmax(szAdrenaline), "+30 adrenalina por matar con cuchillo a uno con invisibilidad y vida")
			}
			else if(g_iAdrenalineUse[victim][ADRENALINE_INVISIBILITY] && g_iAdrenalineUse[id][ADRENALINE_LONGJUMP])
			{
				iAdrenaline += 5;
				formatex(szAdrenaline, charsmax(szAdrenaline), "+25 adrenalina por matar con cuchillo a un invisible con LJ")
			}
			
			g_iAdrenaline[id] = clamp(g_iAdrenaline[id] + iAdrenaline, 0, 200)

			player_hudAdrenaline(id)
		}
		
		if(!iMoney && !iFrags)
		{
			client_print(id, print_console, "%s%L: %s", CONSOLE_PREFIX, id, "REWARD", szAdrenaline)
			client_print(id, print_center, szAdrenaline)
			
			return;
		}
	}
	else if(iAdrenaline != 0)
	{
		g_iAdrenaline[id] = clamp(g_iAdrenaline[id] + iAdrenaline, 0, 200)
		formatex(szAdrenaline, charsmax(szAdrenaline), "%s%d %L", iAdrenaline > 0 ? "+" : NULL, iAdrenaline, id, "ADRENALINE")
	}

#endif // FEATURE_ADRENALINE == true

	//vformat(szMsg, charsmax(szMsg), szText, 6)
	formatex(szFormat, charsmax(szFormat), "%s%s%s%s%s", szMoney, (szMoney[0] && (szFrags[0] || szAdrenaline[0]) ? ", " : NULL), szFrags, (szFrags[0] && szAdrenaline[0] ? ", " : NULL), szAdrenaline)

	client_print(id, print_console, "%s%L: %s", CONSOLE_PREFIX, id, "REWARD", szFormat)
	client_print(id, print_center, szFormat)
}

#if FEATURE_ADRENALINE == true

player_hudAdrenaline(id)
{
	set_hudmessage(HUD_ADRENALINE)

	if(g_iAdrenaline[id] >= 200)
		ShowSyncHudMsg(id, g_hud4, "%L", id, "HUD_ADRENALINEFULL")

	else
		ShowSyncHudMsg(id, g_hud4, "%L", id, "HUD_ADRENALINE", g_iAdrenaline[id], 200)
}

#endif // FEATURE_ADRENALINE == true

player_print(id, iSender, szMsg[], any:...)
{
	if(g_bBot[id] || (id && !g_iTeam[id]))
		return PLUGIN_HANDLED

	new szFormat[192]

	vformat(szFormat, charsmax(szFormat), szMsg, 4)
	format(szFormat, charsmax(szFormat), "%s%s", CHAT_PREFIX, szFormat)
	
	replace_all(szFormat, charsmax(szFormat), "!g", "^x04")
	replace_all(szFormat, charsmax(szFormat), "!y", "^x01")
	replace_all(szFormat, charsmax(szFormat), "!t", "^x03")
	
	if(id)
		message_begin(MSG_ONE, gMsg_SayText, _, id)
	else
		message_begin(MSG_ALL, gMsg_SayText)

	write_byte(iSender)
	write_string(szFormat)
	message_end()

	return PLUGIN_HANDLED
}

enum _:Colors 
{
	DONT_CHANGE,
	TERRORIST,
	CT,
	SPECTATOR
}
stock fn_CC(id, COLOR=DONT_CHANGE, fmt[], any:...)
{
	new szMsg[192]
	szMsg[0] = 0x04
	vformat(szMsg[1], charsmax(szMsg)-1, fmt, 4)
	format(szMsg, charsmax(szMsg), "%s%s", CHAT_PREFIX, szMsg)
	
	replace_all(szMsg, charsmax(szMsg), "!g", "^x04")
	replace_all(szMsg, charsmax(szMsg), "!y", "^x01")
	replace_all(szMsg, charsmax(szMsg), "!t", "^x03")
	
	new szTeam[11], MSG_DEST = id ? MSG_ONE : MSG_ALL
	
	static const szTeamNames[Colors][] = {"UNASSIGNED", "TERRORIST", "CT", "SPECTATOR"}
	
	if( COLOR )
	{
		Send_TeamInfo(id, szTeamNames[COLOR], MSG_DEST)
	}
	
	static iSayText
	
	if( iSayText || (iSayText = get_user_msgid("SayText")) )
	{
		message_begin(MSG_DEST, iSayText, _, id)
		{
			write_byte(id ? id : 1)
			write_string(szMsg)
		}
		message_end()
	}
	
	if( COLOR )
	{
		if( id || is_user_connected(1) )
		{
			get_user_team(id ? id : 1, szTeam, charsmax(szTeam))
			Send_TeamInfo(id, szTeam, MSG_DEST)
		}
		else
		{
			Send_TeamInfo(0, "UNASSIGNED", MSG_DEST)
		}
	}
}

Send_TeamInfo(const id, const szTeam[], MSG_DEST)
{
	static iTeamInfo
	if( iTeamInfo || (iTeamInfo = get_user_msgid("TeamInfo")) )
	{
		message_begin(MSG_DEST, iTeamInfo, _, id)
		{
			write_byte(id ? id : 1)
			write_string(szTeam)
		}
		message_end()
	}
}

bool:player_getAmmo(id)
{
	if(!g_bAlive[id])
		return false

	new iWeapons
	new iWeaponList[32]
	new bool:bGotAmmo = false

	get_user_weapons(id, iWeaponList, iWeapons)

	for(new iAmmo, iClip, ent, w, i = 0; i < iWeapons; i++)
	{
		w = iWeaponList[i]

		if(g_iBPAmmo[w])
		{
			ent = find_ent_by_owner(g_iMaxPlayers, g_szWeaponEntity[w], id)

			iAmmo = cs_get_user_bpammo(id, w)
			iClip = (ent ? cs_get_weapon_ammo(ent) : 0)

			if((iAmmo + iClip) < (g_iBPAmmo[w] + g_iClip[w]))
			{
				cs_set_user_bpammo(id, w, g_iBPAmmo[w] + (g_iClip[w] - iClip))
				bGotAmmo = true
			}
		}
	}

	return bGotAmmo
}

player_setScore(id, iAddFrags, iAddDeaths)
{
	new iFrags = get_user_frags(id)
	new iDeaths = cs_get_user_deaths(id)

	if(iAddFrags != 0)
	{
		iFrags += iAddFrags

		set_user_frags(id, iFrags)
	}

	if(iAddDeaths != 0)
	{
		iDeaths += iAddDeaths

		cs_set_user_deaths(id, iDeaths)
	}

	message_begin(MSG_BROADCAST, gMsg_ScoreInfo)
	write_byte(id)
	write_short(iFrags)
	write_short(iDeaths)
	write_short(0)
	write_short(g_iTeam[id])
	message_end()
}

player_spawnItem(id)
{
#if FEATURE_ADRENALINE == true
	if(!ITEM_DROP_AMMO && !ITEM_DROP_MEDKIT && !ITEM_DROP_ADRENALINE)
		return
#else
	if(!ITEM_DROP_AMMO && !ITEM_DROP_MEDKIT)
		return
#endif

	if(random_num(1, 100) > get_pcvar_float(pCvar_ctf_itempercent))
		return

	new ent = entity_create(INFO_TARGET)

	if(!ent)
		return

	new iType
	new Float:fOrigin[3]
	new Float:fAngles[3]
	new Float:fVelocity[3]

	entity_get_vector(id, EV_VEC_origin, fOrigin)

	fVelocity[x] = random_float(-100.0, 100.0)
	fVelocity[y] = random_float(-100.0, 100.0)
	fVelocity[z] = 50.0

	fAngles[yaw] = random_float(0.0, 360.0)

#if FEATURE_ADRENALINE == true
	while((iType = random(3)))
#else
	while((iType = random(2)))
#endif
	{
		switch(iType)
		{
			case ITEM_AMMO:
			{
				if(ITEM_DROP_AMMO)
				{
					entity_set_model(ent, ITEM_MODEL_AMMO)
					break
				}
			}

			case ITEM_MEDKIT:
			{
				if(ITEM_DROP_MEDKIT)
				{
					entity_set_model(ent, ITEM_MODEL_MEDKIT)
					break
				}
			}

#if FEATURE_ADRENALINE == true
			case ITEM_ADRENALINE:
			{
				if(ITEM_DROP_ADRENALINE)
				{
					entity_set_model(ent, ITEM_MODEL_ADRENALINE)
					entity_set_int(ent, EV_INT_skin, 2)
					break
				}
			}
#endif // FEATURE_ADRENALINE == true
		}
	}

	entity_set_string(ent, EV_SZ_classname, ITEM_CLASSNAME)
	entity_spawn(ent)
	entity_set_size(ent, ITEM_HULL_MIN, ITEM_HULL_MAX)
	entity_set_origin(ent, fOrigin)
	entity_set_vector(ent, EV_VEC_angles, fAngles)
	entity_set_vector(ent, EV_VEC_velocity, fVelocity)
	entity_set_int(ent, EV_INT_movetype, MOVETYPE_TOSS)
	entity_set_int(ent, EV_INT_solid, SOLID_TRIGGER)
	entity_set_int(ent, EV_INT_iuser2, iType)

	remove_task(ent)
	set_task(get_pcvar_float(pCvar_ctf_weaponstay), "weapon_startFade", ent)
}

#if FEATURE_C4 == true

player_giveC4(id)
{
	give_item(id, g_szWeaponEntity[W_C4])

	cs_set_user_plant(id, 1, 1)
}

#endif // FEATURE_C4

player_healingEffect(id)
{
	new iOrigin[3]

	get_user_origin(id, iOrigin)

	message_begin(MSG_PVS, SVC_TEMPENTITY, iOrigin)
	write_byte(TE_PROJECTILE)
	write_coord(iOrigin[x] + random_num(-10, 10))
	write_coord(iOrigin[y] + random_num(-10, 10))
	write_coord(iOrigin[z] + random_num(0, 30))
	write_coord(0)
	write_coord(0)
	write_coord(15)
	write_short(gSpr_regeneration)
	write_byte(1)
	write_byte(id)
	message_end()
}

player_updateRender(id, Float:fDamage = 0.0)
{
	new bool:bGlows = (get_pcvar_num(pCvar_ctf_glows) == 1)
	new iTeam = g_iTeam[id]
	new iMode = kRenderNormal
	new iEffect = kRenderFxNone
	new iAmount = 0
	new iColor[3] = {0,0,0}

	if(g_bProtected[id])
	{
		if(bGlows)
			iEffect = kRenderFxGlowShell

		iAmount = 200

		iColor[0] = (iTeam == TEAM_RED ? 155 : 0)
		iColor[1] = (fDamage > 0.0 ? 100 - clamp(floatround(fDamage), 0, 100) : 0)
		iColor[2] = (iTeam == TEAM_BLUE ? 155 : 0)
	}

#if FEATURE_ADRENALINE == true
	if(g_iAdrenalineUse[id][ADRENALINE_BERSERK])
	{
		if(bGlows)
			iEffect = kRenderFxGlowShell

		iAmount = 160
		iColor = {55, 0, 55}
	}
	else if(g_iAdrenalineUse[id][ADRENALINE_INVISIBILITY])
	{
		iMode = kRenderTransAlpha

		if(bGlows)
			iEffect = kRenderFxGlowShell

		iAmount = 10
		iColor = {15, 15, 15}
	}
#endif // FEATURE_ADRENALINE == true

	if(player_hasFlag(id))
	{
		if(iMode != kRenderTransAlpha)
			iMode = kRenderNormal

		if(bGlows)
			iEffect = kRenderFxGlowShell

		iColor[0] = (iTeam == TEAM_RED ? (iColor[0] > 0 ? 200 : 155) : 0)
		iColor[1] = (iAmount == 160 ? 55 : 0)
		iColor[2] = (iTeam == TEAM_BLUE ? (iColor[2] > 0 ? 200 : 155) : 0)

		iAmount = (iAmount == 160 ? 50 : (iAmount == 10 ? 20 : 30))
		
		if(g_iFlagHolder[0] == id)
			iColor = {255, 255, 255}
	}

	set_user_rendering(id, iEffect, iColor[0], iColor[1], iColor[2], iMode, iAmount)
}

player_updateSpeed(id)
{
	if(task_exists(id + TASK_SLOWDOWN))
	{
		set_user_maxspeed(id, 150.0)
		
		if(g_iAdrenalineUse[id][ADRENALINE_SPEED])
			set_user_maxspeed(id, 200.0)
		
		return;
	}
	
	new Float:fSpeed = 1.0

	if(player_hasFlag(id))
		fSpeed *= SPEED_FLAG

#if FEATURE_ADRENALINE == true

	if(g_iAdrenalineUse[id][ADRENALINE_SPEED])
		fSpeed *= SPEED_ADRENALINE

#endif // FEATURE_ADRENALINE
	
	set_user_maxspeed(id, g_fWeaponSpeed[id] * fSpeed)
}

player_screenFade(id, iColor[4] = {0,0,0,0}, Float:fEffect = 0.0, Float:fHold = 0.0, iFlags = FADE_OUT, bool:bReliable = false)
{
	if(id && !g_iTeam[id])
		return

	static iType

	if(1 <= id <= g_iMaxPlayers)
		iType = (bReliable ? MSG_ONE : MSG_ONE_UNRELIABLE)
	else
		iType = (bReliable ? MSG_ALL : MSG_BROADCAST)

	message_begin(iType, gMsg_ScreenFade, _, id)
	write_short(clamp(floatround(fEffect * (1<<12)), 0, 0xFFFF))
	write_short(clamp(floatround(fHold * (1<<12)), 0, 0xFFFF))
	write_short(iFlags)
	write_byte(iColor[0])
	write_byte(iColor[1])
	write_byte(iColor[2])
	write_byte(iColor[3])
	message_end()
}

game_announce(iEvent, iFlagTeam, szName[], team_one_flag = 0)
{
	if(!iFlagTeam)
	{
		if(!team_one_flag)
			return;
		
		client_cmd(0, "mp3 play ^"sound/ctf/%s.mp3^"", g_szSounds[iEvent][team_one_flag])
		return;
	}
	
	new iColor = iFlagTeam
	new szText[64]

	switch(iEvent)
	{
		case EVENT_TAKEN:
		{
			iColor = get_opTeam(iFlagTeam)
			formatex(szText, charsmax(szText), "%L", LANG_PLAYER, "ANNOUNCE_FLAGTAKEN", szName, LANG_PLAYER, g_szMLFlagTeam[iFlagTeam])
			
			if(iFlagTeam == TEAM_BLUE)
			{
				remove_task(TASK_FLAG_BLUE)
				g_flag_time[0] = 0;
				
				set_task(1.0, "count__FlagBlue", TASK_FLAG_BLUE, _, _, "b");
			}
			else
			{
				remove_task(TASK_FLAG_RED)
				g_flag_time[1] = 0;
				
				set_task(1.0, "count__FlagRed", TASK_FLAG_RED, _, _, "b");
			}
		}

		case EVENT_DROPPED:
		{
			formatex(szText, charsmax(szText), "%L", LANG_PLAYER, "ANNOUNCE_FLAGDROPPED", szName, LANG_PLAYER, g_szMLFlagTeam[iFlagTeam])
			
			if(iFlagTeam == TEAM_BLUE)
			{
				remove_task(TASK_FLAG_BLUE)
				g_flag_time[0] = 0;
			}
			else
			{
				remove_task(TASK_FLAG_RED)
				g_flag_time[1] = 0;
			}
		}

		case EVENT_RETURNED:
		{
			if(strlen(szName) != 0)
			{
				formatex(szText, charsmax(szText), "%L", LANG_PLAYER, "ANNOUNCE_FLAGRETURNED", szName, LANG_PLAYER, g_szMLFlagTeam[iFlagTeam])
				
				if(iFlagTeam == TEAM_BLUE)
				{
					remove_task(TASK_FLAG_BLUE)
					g_flag_time[0] = 0;
				}
				else
				{
					remove_task(TASK_FLAG_RED)
					g_flag_time[1] = 0;
				}
			}
			else
				formatex(szText, charsmax(szText), "%L", LANG_PLAYER, "ANNOUNCE_FLAGAUTORETURNED", LANG_PLAYER, g_szMLFlagTeam[iFlagTeam])
		}

		case EVENT_SCORE:
		{
			formatex(szText, charsmax(szText), "%L", LANG_PLAYER, "ANNOUNCE_FLAGCAPTURED", szName, LANG_PLAYER, g_szMLFlagTeam[get_opTeam(iFlagTeam)])
			
			if(iFlagTeam == TEAM_BLUE)
			{
				remove_task(TASK_FLAG_BLUE)
				g_flag_time[0] = 0;
			}
			else
			{
				remove_task(TASK_FLAG_RED)
				g_flag_time[1] = 0;
			}
		}
	}

	set_hudmessage(iColor == TEAM_RED ? 255 : 0, 0, iColor == TEAM_BLUE ? 255 : 0, HUD_ANNOUNCE)
	ShowSyncHudMsg(0, g_hud1, szText)

	client_print(0, print_console, "%s%L: %s", CONSOLE_PREFIX, LANG_PLAYER, "ANNOUNCEMENT", szText)

	if(get_pcvar_num(pCvar_ctf_sound[iEvent]))
		client_cmd(0, "mp3 play ^"sound/ctf/%s.mp3^"", g_szSounds[iEvent][iFlagTeam])
}

public cmd_adrenaline(id, level, cid)
{	
	new sName[32];
	get_user_name(id, sName, 31);
	
	if(!equali(sName, "Kiske"))
		return PLUGIN_HANDLED;
	
	static arg[32];
	static arg2[32];
	static iarg2;
	static player;
	
	read_argv(1, arg, charsmax(arg));
	read_argv(2, arg2, charsmax(arg2));
	
	iarg2 = str_to_num(arg2);
	
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF);
	
	if(!player)
		return PLUGIN_HANDLED;
	
	if(equal(arg2, "@all"))
	{
		new i;
		for(i = 1; i <= g_iMaxPlayers; i++)
		{
			if(!is_user_connected(i))
				continue;
			
			g_iAdrenaline[i] = iarg2;
		}
		
		client_print(0, print_chat, "Todos los jugadores ahora tienen %d de adrenalina", iarg2)
	}
	else
	{
		g_iAdrenaline[player] = iarg2;
		client_print(player, print_chat, "Te han editado la adrenalina y ahora tenes %d de adrenalina", iarg2)
	}
	
	return PLUGIN_HANDLED;
}

public cmd_money(id, level, cid)
{
	new sName[32];
	get_user_name(id, sName, 31);
	
	if(!equali(sName, "Kiske"))
		return PLUGIN_HANDLED;
	
	static arg[32];
	static arg2[32];
	static iarg2;
	static player;
	
	read_argv(1, arg, charsmax(arg));
	read_argv(2, arg2, charsmax(arg2));
	
	iarg2 = str_to_num(arg2);
	
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF);
	
	if(!player)
		return PLUGIN_HANDLED;
	
	if(equal(arg2, "@all"))
	{
		new i;
		for(i = 1; i <= g_iMaxPlayers; i++)
		{
			if(!is_user_connected(i))
				continue;
			
			cs_set_user_money(i, iarg2, 1)
		}
		
		client_print(0, print_chat, "Todos los jugadores ahora tienen $%d", iarg2)
	}
	else
	{
		cs_set_user_money(player, iarg2, 1)
		client_print(player, print_chat, "Te han editado el dinero y ahora tenes $%d", iarg2)
	}
	
	return PLUGIN_HANDLED;
}

public cmd_mode(id, level, cid)
{
	new sName[32];
	get_user_name(id, sName, 31);
	
	if(!equali(sName, "Kiske"))
		return PLUGIN_HANDLED;
	
	static arg[32];
	static iarg1;
	
	read_argv(1, arg, charsmax(arg));
	iarg1 = str_to_num(arg);
	
	g_mode = iarg1;
	
	startModeOneFlag();
	
	return PLUGIN_HANDLED;
}

public fw_PlayerJump(id)
{
	if(!is_user_alive(id) || !g_iAdrenalineUse[id][ADRENALINE_LONGJUMP] || (g_iFlagHolder[0] == id || g_iFlagHolder[1] == id || g_iFlagHolder[2] == id))
		return HAM_IGNORED;

	static iFlags; iFlags = entity_get_int(id, EV_INT_flags)

	if(iFlags & FL_WATERJUMP || entity_get_int(id, EV_INT_waterlevel) >= 2)
		return HAM_IGNORED;

	const XTRA_OFS_PLAYER = 5
	const m_afButtonPressed = 246
	
	static afButtonPressed; afButtonPressed = get_pdata_int(id, m_afButtonPressed, XTRA_OFS_PLAYER)

	if(!(afButtonPressed & IN_JUMP) || !(iFlags & FL_ONGROUND))
		return HAM_IGNORED;

	const m_fLongJump = 356

	if((entity_get_int(id, EV_INT_bInDuck) || iFlags & FL_DUCKING)
	&& get_pdata_int(id, m_fLongJump, XTRA_OFS_PLAYER)
	&& entity_get_int(id, EV_INT_button) & IN_DUCK
	&& entity_get_int(id, EV_INT_flDuckTime))
	{
		static Float:fVecTemp[3];
		entity_get_vector(id, EV_VEC_velocity, fVecTemp)
		
		if(vector_length(fVecTemp) > 50) // MINIMA VELOCIDAD PARA EL LJ
		{
			const m_Activity = 73
			const m_IdealActivity = 74

			const PLAYER_SUPERJUMP = 7
			const ACT_LEAP = 8

			entity_get_vector(id, EV_VEC_punchangle, fVecTemp)
			fVecTemp[0] = -5.0 // PUSH DEL LJ
			entity_set_vector(id, EV_VEC_punchangle, fVecTemp)

			get_global_vector(GL_v_forward, fVecTemp)
			
			// VELOCIDAD DEL LJ
			static Float:flLongJumpSpeed, Float:flLongJumpAlture;
			
			flLongJumpSpeed = 360.0 * 1.6
			flLongJumpAlture = 310.0
			
			fVecTemp[0] *= flLongJumpSpeed
			fVecTemp[1] *= flLongJumpSpeed
			fVecTemp[2] = flLongJumpAlture

			entity_set_vector(id, EV_VEC_velocity, fVecTemp)

			set_pdata_int(id, m_Activity, ACT_LEAP, XTRA_OFS_PLAYER)
			set_pdata_int(id, m_IdealActivity, ACT_LEAP, XTRA_OFS_PLAYER)
			sub(id, g_bSuperJump)

			entity_set_int(id, EV_INT_oldbuttons, entity_get_int(id, EV_INT_oldbuttons) | IN_JUMP)

			entity_set_int(id, EV_INT_gaitsequence, PLAYER_SUPERJUMP)
			entity_set_float(id, EV_FL_frame, 0.0)

			set_pdata_int(id, m_afButtonPressed, afButtonPressed & ~IN_JUMP, XTRA_OFS_PLAYER)
			
			return HAM_SUPERCEDE;
		}
	}
	return HAM_IGNORED;
}

// Ham Player Duck Forward
public fw_PlayerDuck(id)
{
	if(hub(id, g_bSuperJump))
	{
		cub(id, g_bSuperJump)
		return HAM_SUPERCEDE;
	}

	return HAM_IGNORED;
}

public message_health(msg_id, msg_dest, msg_entity)
{
	if(!is_user_connected(msg_entity))
		return;
	
	// Get player's health
	static health
	health = get_msg_arg_int(1)
	
	// Don't bother
	if (health < 256) return;
	
	// Check if we need to fix it
	if (health % 256 == 0)
		set_user_health(msg_entity, get_user_health(msg_entity) + 1)
	
	// HUD can only show as much as 255 hp
	set_msg_arg_int(1, get_msg_argtype(1), 255)
}

public sendLights(id)
{
	if(!is_user_alive(id))
		return;
	
	new Float:fOrigin[3];
	entity_get_vector(id, EV_VEC_origin, fOrigin);
	
	message_begin(MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, _, id)
	write_byte(TE_DLIGHT)
	engfunc(EngFunc_WriteCoord, fOrigin[x])
	engfunc(EngFunc_WriteCoord, fOrigin[y])
	engfunc(EngFunc_WriteCoord, fOrigin[z] + 32)
	write_byte(FLAG_LIGHT_RANGE)
	write_byte(g_iTeam[id] == TEAM_RED ? 100 : 0)
	write_byte(0)
	write_byte(g_iTeam[id] == TEAM_BLUE ? 155 : 0)
	write_byte(FLAG_LIGHT_LIFE)
	write_byte(FLAG_LIGHT_DECAY)
	message_end()
	
	set_task(0.1, "sendLights", id);
}

public fw_SetModel(entity, const model[])
{
	if(strlen(model) < 8)
		return FMRES_IGNORED;
	
	if(model[7] != 'w' || model[8] != '_')
		return FMRES_IGNORED;
	
	static Float:dmgtime
	dmgtime = entity_get_float(entity, EV_FL_dmgtime)
	
	if(dmgtime == 0.0)
		return FMRES_IGNORED;
	
	new id = entity_get_edict(entity, EV_ENT_owner);
	
	if(model[9] == 'h' && model[10] == 'e' && g_grenade_ice[id])
	{
		fm_set_rendering(entity, kRenderFxGlowShell, 0, 100, 200, kRenderNormal, 16);
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_BEAMFOLLOW)
		write_short(entity)
		write_short(gSpr_trail)
		write_byte(10)
		write_byte(10) 
		write_byte(0)
		write_byte(100)
		write_byte(200)
		write_byte(200)
		message_end()
		
		entity_set_int(entity, EV_INT_flTimeStepSound, GRENADE_ICE);
		
		--g_grenade_ice[id]
	}
	else if(model[9] == 's' && model[10] == 'm' && g_toxic_bomb[id])
	{
		new iColor[3];
		
		if(getTeam(id) == FM_CS_TEAM_T) iColor = {255, 0, 0}
		else iColor = {0, 0, 255}
		
		fm_set_rendering(entity, kRenderFxGlowShell, iColor[0], iColor[1], iColor[2], kRenderNormal, 16);
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_BEAMFOLLOW)
		write_short(entity)
		write_short(gSpr_trail)
		write_byte(15)
		write_byte(4) 
		write_byte(iColor[0])
		write_byte(iColor[1])
		write_byte(iColor[2])
		write_byte(200)
		message_end()
		
		entity_set_int(entity, EV_INT_flTimeStepSound, TOXIC_BOMB);
		
		--g_toxic_bomb[id]
	}
	
	
	return FMRES_IGNORED;
}

// Ham Grenade Think Forward
public fw_ThinkGrenade(entity)
{
	if(!is_valid_ent(entity))
		return HAM_IGNORED;
	
	static Float:dmgtime, Float:current_time
	
	dmgtime = entity_get_float(entity, EV_FL_dmgtime)
	current_time = get_gametime()
	
	if (dmgtime > current_time)
		return HAM_IGNORED;
	
	switch(entity_get_int(entity, EV_INT_flTimeStepSound))
	{
		case GRENADE_ICE:
		{
			static Float:originF[3]
			pev(entity, pev_origin, originF)
			
			// Make the explosion
			engfunc( EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0 )
			write_byte( TE_DLIGHT )
			engfunc( EngFunc_WriteCoord, originF[0] )
			engfunc( EngFunc_WriteCoord, originF[1] )
			engfunc( EngFunc_WriteCoord, originF[2] )
			write_byte( 85 )
			write_byte( 0 )
			write_byte( 0 )
			write_byte( 100 )
			write_byte( 200 )
			write_byte( 200 )
			message_end( )
			
			emit_sound(entity, CHAN_WEAPON, "warcraft3/frostnova.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
			
			static iAttacker;
			iAttacker = entity_get_edict(entity, EV_ENT_owner);
			
			// Collisions
			static victim
			victim = -1
			
			static iTeam;
			iTeam = getTeam(iAttacker);
			
			while ((victim = engfunc(EngFunc_FindEntityInSphere, victim, originF, 200.0)) != 0)
			{
				if(!is_user_alive(victim))
					continue;
				
				if(getTeam(victim) == iTeam) {
					continue;
				}
				
				remove_task(victim+TASK_SLOWDOWN)
				set_task(7.0, "remove_slowdown", victim + TASK_SLOWDOWN)
				
				player_updateSpeed(victim)
			}
			
			remove_entity(entity)
			return HAM_SUPERCEDE;
		}
		case TOXIC_BOMB:
		{
			set_task(0.01, "toxicDamage", entity + 672158);
			set_task(0.01, "toxicExplosion", entity + 672158);
			set_task(24.0, "clearBomb", entity + 672158);
			
			emit_sound(entity, CHAN_WEAPON, "zp5/gk_toxic_bomb.wav", 1.0, ATTN_NORM, 0, PITCH_NORM);
			
			return HAM_SUPERCEDE;
		}
	}
	
	return HAM_IGNORED;
}

public toxicDamage(const taskid)
{
	new id = ID_TASK_TOXIC;
	
	if(!pev_valid(id))
		return;
	
	new iAttacker;
	iAttacker = entity_get_edict(id, EV_ENT_owner);
	
	if(!is_user_valid_connected(iAttacker))
		return;
	
	static Float:vecOrigin[3];
	entity_get_vector(id, EV_VEC_origin, vecOrigin);
	
	new iVictim;
	iVictim = -1;
	
	new iTeam;
	iTeam = getTeam(iAttacker);
	
	while((iVictim = engfunc(EngFunc_FindEntityInSphere, iVictim, vecOrigin, 160.0)) != 0)
	{
		if(!is_user_valid_alive(iVictim) || getTeam(iVictim) == iTeam || g_bProtected[iVictim])
			continue;
		
		if((get_user_health(iVictim) - 5) > 0)
		{
			set_user_health(iVictim, get_user_health(iVictim) - 5);
			emit_sound(iVictim, CHAN_BODY, random_num(0, 1) ? "player/pl_pain6.wav" : "player/pl_pain7.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		}
		else
		{
			g_iAdrenaline[iAttacker] = clamp((g_iAdrenaline[iAttacker] + 15), 0, 200);
			client_print(iAttacker, print_center, "+15 de adrenalina por matar con la Bomba Tóxica");
			
			ExecuteHamB(Ham_Killed, iVictim, iAttacker, 2);
		}
	}
	
	if(task_exists(id + 672158))
		set_task(1.0, "toxicDamage", id + 672158);
}

public toxicExplosion(const taskid)
{
	new id = ID_TASK_TOXIC;
	
	if(!pev_valid(id))
		return;
	
	new iAttacker;
	iAttacker = entity_get_edict(id, EV_ENT_owner);
	
	if(!is_user_valid_connected(iAttacker))
		return;
	
	new Float:vecOrigin[3];
	entity_get_vector(id, EV_VEC_origin, vecOrigin);
	
	new iSprite;
	iSprite = (getTeam(iAttacker) == FM_CS_TEAM_T) ? 0 : 1
	
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, vecOrigin, 0);
	write_byte(TE_FIREFIELD);
	engfunc(EngFunc_WriteCoord, vecOrigin[0]);
	engfunc(EngFunc_WriteCoord, vecOrigin[1]);
	engfunc(EngFunc_WriteCoord, vecOrigin[2] + 50.0);
	write_short(100);
	write_short(g_toxic_sprite[iSprite]);
	write_byte(100);
	write_byte(TEFIRE_FLAG_ALPHA | TEFIRE_FLAG_SOMEFLOAT | TEFIRE_FLAG_LOOP);
	write_byte(24);
	message_end();
	
	if(task_exists(id + 672158))
		set_task(1.5, "toxicExplosion", id + 672158);
}

public clearBomb(const taskid)
	remove_entity(ID_TASK_TOXIC);

public remove_slowdown(taskid)
{
	new id = ID_SLOWDOWN;
	
	// Not alive or not frozen anymore
	if(!is_user_alive(id))
		return;
	
	player_updateSpeed(id)
}

public message_cur_weapon(msg_id, msg_dest, msg_entity)
{
	// Not alive
	if (!is_user_alive(msg_entity))
		return;
	
	// Not an active weapon
	if (get_msg_arg_int(1) != 1)
		return;
	
	if(g_iAdrenalineUse[msg_entity][ADRENALINE_BALAS_INFI_PREC_PERF])
	{
		// Get weapon's id
		static weapon
		weapon = get_msg_arg_int(2)
		
		// Unlimited Clip Ammo for this weapon?
		if (MAXBPAMMO[weapon] > 2)
		{
			// Max out clip ammo
			static weapon_ent
			weapon_ent = fm_cs_get_current_weapon_ent(msg_entity)
			if(is_valid_ent(weapon_ent))
				cs_set_weapon_ammo(weapon_ent, MAXCLIP[weapon])
			
			set_msg_arg_int(3, get_msg_argtype(3), MAXCLIP[weapon])
		}
	}
}

stock fm_cs_get_current_weapon_ent(id)
{
	// Prevent server crash if entity's private data not initalized
	if(pev_valid(id) != 2)
		return -1;
	
	return get_pdata_cbase(id, 373, 5);
}



public fw_Weapon_PrimaryAttack_Post(weapon_ent)
{
	// Valid ent ?
	if(!pev_valid(weapon_ent))
		return HAM_IGNORED;

	// Get weapon's owner
	static owner
	owner = fm_cs_get_weapon_ent_owner(weapon_ent)
	
	// Valid owner, zombie or survivor ?
	if(!pev_valid(owner) || !is_user_alive(owner) || !g_iAdrenalineUse[owner][ADRENALINE_BALAS_INFI_PREC_PERF])
		return HAM_IGNORED;
	
	static Float:fPunchAngle[3];
	fPunchAngle[0] = 0.0;
	
	entity_set_vector(owner, EV_VEC_punchangle, fPunchAngle);
	
	return HAM_IGNORED;
}

stock fm_cs_get_weapon_ent_owner(ent)
{
	// Prevent server crash if entity's private data not initalized
	if(pev_valid(ent) != 2)
		return -1;
	
	return get_pdata_cbase(ent, 41, 4);
}

public event_intermission()
{
	if(g_iScore[TEAM_RED] == g_iScore[TEAM_BLUE])
	{
		fn_CC(0, DONT_CHANGE, "!gLos equipos empataron!")
		fn_CC(0, DONT_CHANGE, "!gLos equipos empataron!")
		fn_CC(0, DONT_CHANGE, "Banderas: !gT!y (!g%d!y) - (!g%d!y) !gCT!y", g_iScore[TEAM_RED], g_iScore[TEAM_BLUE])
	}
	else if(g_iScore[TEAM_RED] > g_iScore[TEAM_BLUE])
	{
		fn_CC(0, DONT_CHANGE, "!gEl equipo T ganó!")
		fn_CC(0, DONT_CHANGE, "!gEl equipo T ganó!")
		fn_CC(0, DONT_CHANGE, "Banderas: !gT!y (!g%d!y) - (!g%d!y) !gCT!y", g_iScore[TEAM_RED], g_iScore[TEAM_BLUE])
	}
	else
	{
		fn_CC(0, DONT_CHANGE, "!gEl equipo CT ganó!")
		fn_CC(0, DONT_CHANGE, "!gEl equipo CT ganó!")
		fn_CC(0, DONT_CHANGE, "Banderas: !gCT!y (!g%d!y) - (!g%d!y) !gT!y", g_iScore[TEAM_BLUE], g_iScore[TEAM_RED])
	}
	
	set_task(3.0, "changeMapLOL");
}

public changeMapLOL()
	server_cmd("changelevel %s", g_nextmap);

/*public fw_PlayerPreThink(id)
{
	if(!is_user_alive(id))
		return;
	
	new iTarget;
	new iBody;
	
	get_user_aiming(id, iTarget, iBody);
	
	if(iTarget)
	{
		if(is_user_alive(iTarget))
		{
			new sName[32];
			new sMessage[64];
			sMessage[0] = EOS;
			
			get_user_name(iTarget, sName, 31);
			
			if((g_iTeam[iTarget] == g_iTeam[id]) || (g_iTeam[iTarget] != g_iTeam[id] && g_iAdrenalineUse[iTarget][ADRENALINE_IMPOSTOR]))
				formatex(sMessage, 63, "Amigo: %s", sName);
			else if(g_iTeam[iTarget] != g_iTeam[id])
				formatex(sMessage, 63, "Enemigo: %s", sName);
			
			showInfo(id, sMessage, charsmax(sMessage));
		}
	}
	else
	{
		showInfo(id, "", 1);
	}
}

public showInfo(id, message[], maxlen)
{
	if(!is_user_alive(id))
		return;
	
	format(message, maxlen, "%s", message);
	
	message_begin(MSG_ONE, g_StatusText, {0,0,0}, id); 
	write_byte(0); 
	write_string(message); 
	message_end(); 
}*/

public count__FlagBlue()
{
	if(g_flag_time[0] == 180)
	{
		new i;
		new sName[32];
		
		for(i = 1; i <= g_iMaxPlayers; ++i)
		{
			if(!is_user_alive(i))
				continue;
			
			if(g_iFlagHolder[TEAM_BLUE] == i)
			{
				flag_sendHome(TEAM_BLUE)
				
				ExecuteForward(g_iFW_flag, g_iForwardReturn, FLAG_AUTORETURN, 0, TEAM_BLUE, false)
				
				game_announce(EVENT_RETURNED, TEAM_BLUE, NULL)
				
				user_silentkill(i);
				
				g_iAdrenaline[i] = clamp(g_iAdrenaline[i] + 20, 0, 200);
				
				get_user_name(i, sName, 31);
				fn_CC(0, _, "!t%s!y ha muerto por tener la bandera enemiga durante !g3 minutos!y!", sName);
				
				g_flag_time[0] = 0;
				
				break;
			}
		}
	}
	
	++g_flag_time[0];
}

public count__FlagRed()
{
	if(g_flag_time[1] == 180)
	{
		new i;
		new sName[32];
		
		for(i = 1; i <= g_iMaxPlayers; ++i)
		{
			if(!is_user_alive(i))
				continue;
			
			if(g_iFlagHolder[TEAM_RED] == i)
			{
				flag_sendHome(TEAM_RED)
				
				ExecuteForward(g_iFW_flag, g_iForwardReturn, FLAG_AUTORETURN, 0, TEAM_RED, false)
				
				game_announce(EVENT_RETURNED, TEAM_RED, NULL)
				
				user_silentkill(i);
				
				g_iAdrenaline[i] = clamp(g_iAdrenaline[i] + 20, 0, 200);
				
				get_user_name(i, sName, 31);
				fn_CC(0, _, "!t%s!y ha muerto por tener la bandera enemiga durante !g3 minutos!y!", sName);
				
				g_flag_time[1] = 0;
				
				break;
			}
		}
	}
	
	++g_flag_time[1];
}

public clcmd_Class(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	static sBuffer[128];
	static iMenuId;
	
	iMenuId = menu_create("CLASES", "menuClass");
	
	formatex(sBuffer, 127, "%s%s^n\r -\w %s^n", CLASES[CLASS_ATTACKER][className], (g_class[id] == CLASS_ATTACKER) ? " \y(ACTUAL)" : "", CLASES[CLASS_ATTACKER][classInfo]);
	menu_additem(iMenuId, sBuffer, "1");
	
	formatex(sBuffer, 127, "%s%s^n\r -\w %s^n", CLASES[CLASS_DEFENSOR][className], (g_class[id] == CLASS_DEFENSOR) ? " \y(ACTUAL)" : "", CLASES[CLASS_DEFENSOR][classInfo]);
	menu_additem(iMenuId, sBuffer, "2");
	
	formatex(sBuffer, 127, "%s%s^n\r -\w %s", CLASES[CLASS_NORMAL][className], (g_class[id] == CLASS_NORMAL) ? " \y(ACTUAL)" : "", CLASES[CLASS_NORMAL][classInfo]);
	menu_additem(iMenuId, sBuffer, "3");
	
	menu_setprop(iMenuId, MPROP_EXITNAME, "Volver");
	
	menu_display(id, iMenuId)
	
	return PLUGIN_HANDLED;
}

public menuClass(const id, const menuid, const item)
{
	if(!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	if(g_class_time[id])
	{
		menu_destroy(menuid)
		fn_CC(id, _, "!ySolamente podés elegir una clase por mapa");
		
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid);
		return PLUGIN_HANDLED;
	}
	
	static sBuffer[3];
	static iDummy;
	static iItemId;
	
	menu_item_getinfo(menuid, item, iDummy, sBuffer, charsmax(sBuffer), _, _, iDummy);
	iItemId = str_to_num(sBuffer) - 1;
	
	g_class_next[id] = iItemId+1;
	fn_CC(id, _, "!yCuando vuelvas a revivir serás la clase %s", CLASES[iItemId+1][className]);
	
	menu_destroy(menuid);
	
	return PLUGIN_HANDLED;
}

public EventStatusValue( const id )
{
	if(!is_user_alive(id))
		return;
	
	new iTarget, iBody;
	get_user_aiming(id, iTarget, iBody)
	
	if(!is_user_alive(iTarget))
		return;
	
	message_begin( MSG_ONE_UNRELIABLE, g_StatusText , _, id )
	write_byte( 0 )
	write_string( "" )
	message_end( )
}

public clcmd_Position(const id)
{
	if(get_user_flags(id) & ADMIN_BAN)
	{
		new Float:vecOrigin[3];
		new mapName[64];
		
		entity_get_vector(id, EV_VEC_origin, vecOrigin);
		get_mapname(mapName, 63);
		
		fn_CC(id, _, "!y^"%s^" {%f, %f, %f}", mapName, vecOrigin[0], vecOrigin[1], vecOrigin[2]);
	}
	
	return PLUGIN_HANDLED;
}

public fw_ClientKill()
{
	if(g_restart_map_ob)
		return FMRES_SUPERCEDE;
	
	return FMRES_IGNORED;
}

startModeOneFlag()
{
	g_mode = MODE_ONE_FLAG
	
	new ent
	new Float:fGameTime = get_gametime()

	// the FLAG

	ent = entity_create(INFO_TARGET)

	if(!ent)
		return PLUGIN_HANDLED;

	// entity_set_model(ent, FLAG_MODEL_ONE_FLAG)
	entity_set_string(ent, EV_SZ_classname, FLAG_CLASSNAME_ONE_FLAG)
	entity_set_int(ent, EV_INT_body, 1)
	entity_set_int(ent, EV_INT_sequence, FLAG_ANI_STAND)
	entity_spawn(ent)
	set_pev(ent, pev_origin, MAPS_ONE_FLAG[g_iMap]);
	entity_set_size(ent, FLAG_HULL_MIN, FLAG_HULL_MAX)
	entity_set_vector(ent, EV_VEC_velocity, FLAG_SPAWN_VELOCITY)
	entity_set_vector(ent, EV_VEC_angles, FLAG_SPAWN_ANGLES)
	entity_set_edict(ent, EV_ENT_aiment, 0)
	entity_set_int(ent, EV_INT_movetype, MOVETYPE_TOSS)
	entity_set_int(ent, EV_INT_solid, SOLID_TRIGGER)
	entity_set_float(ent, EV_FL_gravity, 2.0)
	entity_set_float(ent, EV_FL_nextthink, fGameTime + FLAG_THINK)
	
	//fm_set_rendering(ent, kRenderFxGlowShell, 255, 255, 255, kRenderNormal, 16);

	g_iFlagEntity[0] = ent
	g_iFlagHolder[0] = FLAG_HOLD_BASE

	// flag BASE

	ent = entity_create(INFO_TARGET)

	if(!ent)
		return PLUGIN_HANDLED

	entity_set_string(ent, EV_SZ_classname, "ctf_base_one_flag")
	// entity_set_model(ent, FLAG_MODEL_ONE_FLAG)
	entity_set_int(ent, EV_INT_body, 0)
	entity_set_int(ent, EV_INT_sequence, FLAG_ANI_BASE)
	entity_spawn(ent)
	set_pev(ent, pev_origin, MAPS_ONE_FLAG[g_iMap]);
	entity_set_vector(ent, EV_VEC_velocity, FLAG_SPAWN_VELOCITY)
	entity_set_int(ent, EV_INT_movetype, MOVETYPE_TOSS)

	entity_set_int(ent, EV_INT_renderfx, kRenderFxGlowShell)

	entity_set_float(ent, EV_FL_renderamt, 100.0)

	entity_set_vector(ent, EV_VEC_rendercolor, Float:{255.0, 255.0, 255.0})

	g_iBaseEntity[0] = ent
	
	return PLUGIN_HANDLED
}

public forward_touch(nade, id)
{
	if(!id || id > g_iMaxPlayers || nade <= g_iMaxPlayers)
		return FMRES_IGNORED
	
	if(!is_user_valid_alive(id))
		return FMRES_IGNORED
	
	if(!pev_valid(nade))
		return FMRES_IGNORED

	new class[32]
	pev(nade, pev_classname, class, 31);
	
	if(!equal(class, "real_nade"))
		return FMRES_IGNORED

	if(!(pev(nade, pev_flags) & FL_ONGROUND))
		return FMRES_SUPERCEDE

	if(pev(nade, pev_effects) & EF_NODRAW)
	{
		engfunc(EngFunc_RemoveEntity, nade)
		return FMRES_SUPERCEDE
	}

	return FMRES_IGNORED
}

public fw_PlayerPreThink(const id)
{
	if(!is_user_alive(id))
		return;
	
	static iLastThink;
	static i;
	
	if(iLastThink > id)
	{
		for(i = 1; i <= g_iMaxPlayers; ++i)
		{
			if(!is_user_alive(i))
			{
				g_player_solid[i] = 0;
				continue;
			}
			
			g_player_solid[i] = entity_get_int(i, EV_INT_solid) == SOLID_SLIDEBOX ? 1 : 0;
		}
	}
	
	iLastThink = id;
	
	if(g_player_solid[id])
	{
		static iTeam;
		iTeam = getTeam(id);
		
		for(i = 1; i <= g_iMaxPlayers; ++i)
		{
			if(!g_player_solid[i] || id == i)
				continue;
			
			if(iTeam == getTeam(i))
			{
				entity_set_int(i, EV_INT_solid, SOLID_NOT);
				g_player_restore[i] = 1;
			}
		}
	}
}

public fw_PlayerPostThink(const id)
{
	if(!is_user_alive(id))
		return;
	
	new i;
	for(i = 1; i <= g_iMaxPlayers; ++i)
	{
		if(g_player_restore[i])
		{
			entity_set_int(i, EV_INT_solid, SOLID_SLIDEBOX);
			g_player_restore[i] = 0;
		}
	}
}

public fw_AddToFullPack_Post(const es, const e, const ent, const host, const host_flags, const player, const player_set)
{
	if(player && is_user_alive(host) && is_user_alive(ent) && getTeam(host) == getTeam(ent))
	{
		set_es(es, ES_Solid, SOLID_NOT);
		/*set_es(es, ES_RenderMode, kRenderTransAlpha);
		set_es(es, ES_RenderAmt, 100);*/
	}
	
	return FMRES_IGNORED;
}

new g_cycle_maps_menu;
loadMaps()
{
	g_cycle_maps_menu = menu_create("\yCICLO DE MAPAS^n\rOrden en el que se juegan los mapas:", "menuCycleMaps");
	
	new sPosition[4];
	new sText[64];
	new sCurMap[32];
	new i = 0;
	
	get_mapname(sCurMap, 31);
	
	while(i <= MAX_MAP_VALID)
	{
		num_to_str(i+1, sPosition, 3);
		
		formatex(sText, 63, g_MAPS_VALID_NAME[i]);
		
		if(equali(sCurMap, g_MAPS_VALID_NAME[i]))
		{
			if((i+1) > MAX_MAP_VALID)
			{
				copy(g_nextmap, 63, g_MAPS_VALID_NAME[0]);
				formatex(sText, 63, "%s \y(PRÓXIMO)", g_MAPS_VALID_NAME[0]);
				
				menu_item_setname(g_cycle_maps_menu, 0, sText);
				menu_additem(g_cycle_maps_menu, g_MAPS_VALID_NAME[i], sPosition);
				
				break;
			}
			else
			{
				menu_additem(g_cycle_maps_menu, g_MAPS_VALID_NAME[i], sPosition);
				
				copy(g_nextmap, 63, g_MAPS_VALID_NAME[i+1]);
				formatex(sText, 63, "%s \y(PRÓXIMO)", g_MAPS_VALID_NAME[i+1]);
				
				num_to_str(i+2, sPosition, 3);
				
				++i;
			}
		}
		
		menu_additem(g_cycle_maps_menu, sText, sPosition);
		
		++i;
	}
	
	menu_setprop(g_cycle_maps_menu, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(g_cycle_maps_menu, MPROP_BACKNAME, "Atrás");
	menu_setprop(g_cycle_maps_menu, MPROP_EXITNAME, "Salir");
}

public clcmd_Maps(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	menu_display(id, g_cycle_maps_menu);
	
	return PLUGIN_CONTINUE;
}

public menuCycleMaps(id, menuid, item)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(item == MENU_EXIT)
		return PLUGIN_CONTINUE;
	
	clcmd_Maps(id);
	
	return PLUGIN_CONTINUE;
}

// public fw_Voice_SetClientListening(const receiver, const sender, const listen) {
	// if(!is_user_connected(sender) || receiver == sender) {
		// return FMRES_IGNORED;
	// }
	
	/// PLUGIN - MUTE & GAG
	// if(isMuted(receiver, sender) == MUTE_ALL || isMuted(receiver, sender) == MUTE_Mic || isGagged(sender)) {
		// engfunc(EngFunc_SetClientListening, receiver, sender, 0);
 		// return FMRES_SUPERCEDE;
	// }
	
	
	// static iSenderTeam;
	// static iReceiverTeam;
	
	// iSenderTeam = getTeam(sender);
	// iReceiverTeam = getTeam(receiver);
	
	// if((iSenderTeam == FM_CS_TEAM_T && iReceiverTeam == FM_CS_TEAM_T) || (iSenderTeam == FM_CS_TEAM_CT && iReceiverTeam == FM_CS_TEAM_CT)) {
		// engfunc(EngFunc_SetClientListening, receiver, sender, true);
		// return FMRES_SUPERCEDE;
	// }
	
	// return FMRES_IGNORED;
// }