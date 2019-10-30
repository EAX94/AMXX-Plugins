#include <amxmodx>
#include <amxmisc>
#include <engine>
#include <fakemeta_util>
#include <cstrike>
#include <hamsandwich>
#include <fun>
#include <orpheu>
#include <orpheu_memory>
#include <orpheu_stocks>
#include <safemenu>
#include <cc>
#include <sqlx>
#include <dhudmessage>

#define PLUGIN_NAME		"GAM!NGA TORNEO L4D2 ZP"
#define PLUGIN_VERSION	"v1.0.0"
#define PLUGIN_AUTHOR	"Kiske"

#define SQL_HOST		"127.0.0.1"
#define SQL_USER		"zombiep"
#define SQL_PASS			"t4zpcs27025go"
#define SQL_TABLE		"zombiep"

#define THINK_ROUNDTIME	get_gametime() + 1.0

/*
	CREAR COMANDO PARA GUARDAR TODOS LOS DATOS
*/

new g_Team_Id;
new g_Team_Damage;
new g_Team_ZombiesKill;
new g_Team_ZombiesSpecialKill;
new g_Team_DamageReceive;
new g_Team_DamageWithPistol;
new g_Team_DamageWithChainsaw;
new g_Team_Shoots;
new g_Team_ShootsHS;
new g_Team_HuntersKill;
new g_Team_BoomersKill;
new g_Team_SmokersKill;
new g_Team_ChargersKill;
new g_Team_SpittersKill;
new g_Team_WitchsKill;
new g_Team_TanksKill;

new g_Human_Damage[33];
new g_Human_ZombiesKill[33];
new g_Human_ZombiesSpecialKill[33];
new g_Human_DamageWithPistol[33];
new g_Human_DamageWithChainsaw[33];
new g_Human_Shoots[33];
new g_Human_ShootsHS[33];
new g_Human_HuntersKill[33];
new g_Human_BoomersKill[33];
new g_Human_SmokersKill[33];
new g_Human_ChargersKill[33];
new g_Human_SpittersKill[33];
new g_Human_WitchsKill[33];
new g_Human_TanksKill[33];
new g_Human_DamageToTank[33];

new g_Zombie_Damage[33];
new g_Zombie_HumansKill[33];
new g_Zombie_HunterDamage[33];
new g_Zombie_BoomerDamage[33];
new g_Zombie_SmokerDamage[33];
new g_Zombie_ChargerDamage[33];
new g_Zombie_SpitterDamage[33];
new g_Zombie_WitchDamage[33];
new g_Zombie_TankDamage[33];
new g_Zombie_BoomerVomitInH[33];
new g_Zombie_BoomerVomitInZ[33];
new g_Zombie_SmokerHumans[33]; // Mayor cantidad de humanos agarrados como Smoker.
new g_Zombie_ChargerImpacts[33]; // Mayor cantidad de impactos hacia humanos como Charger.
new g_Zombie_SpitterImpacts[33]; // Mayor cantidad de impactos como Spitter (a través de su charco de ácido).
new g_Zombie_TankRock[33]; // Mayor cantidad de rocas acertadas como Tank.

new const g_SOUND_AMBIENT[][] = {"zombie_plague/hunterbacterias.wav", "zombie_plague/spitterbacteria.wav", "zombie_plague/spitterbacterias.wav"};
new const g_SOUND_LOWHP[] = "sound/zombie_plague/iamsocold_f.mp3";

new const g_SOUND_CLAW_ATTACK[] = "zombie_plague/tcs_claw_attack_1.wav";
new const g_SOUND_CLAW_STAB[] = "zombie_plague/tcs_claw_attack_2.wav";
new const g_SOUND_CLAW_SLASH[][] = {"zombie_plague/tcs_claw_slash_1.wav", "zombie_plague/tcs_claw_slash_2.wav"};
new const g_SOUND_CLAW_WALL[][] = {"zombie_plague/zombie_claw_wall_1.wav", "zombie_plague/zombie_claw_wall_2.wav"};
new const g_SOUND_ZOMBIE_DIE[][] = {"zombie_plague/tcs_zombie_die_1.wav", "zombie_plague/zombie_die1.wav", "zombie_plague/zombie_die2.wav", "zombie_plague/tcs_zombie_die_2.wav", "zombie_plague/zombie_die3.wav", "zombie_plague/zombie_die4.wav", "zombie_plague/zombie_die5.wav", "zp5/zombie_death_00.wav"};

new const g_SOUND_SCARE[] = "zombie_plague/vassalation_01.wav";

new const g_SOUND_TANK_ROCK[] = "zombie_plague/tank_rocklaunch.wav";
new const g_SOUND_TANK[] = "sound/zombie_plague/tank_f.mp3";

new const g_SOUND_HORDE[] = "sound/zombie_plague/hordedanger_01_f.mp3";

new const g_SOUND_PAIN[][] = {"zombie_plague/zombie_pain1.wav", "zombie_plague/zombie_pain2.wav", "zombie_plague/zombie_pain3.wav", "zombie_plague/zombie_pain4.wav", "zombie_plague/zombie_pain5.wav"};

new const g_SOUND_SPITTER_ALERT[][] = {"zombie_plague/spitter_alert_01.wav", "zombie_plague/spitter_alert_02.wav"};
new const g_SOUND_SPITTER_ACID_INIT[] = "zombie_plague/spitter_spit_01.wav";

new const g_SOUND_SMOKER_RESPAWN[] = "zombie_plague/smoker_spotprey_07.wav";
new const g_SOUND_SMOKER_ALERT[][] = {"zombie_plague/smoker_lurk_08.wav", "zombie_plague/smoker_lurk_13.wav"};
new const g_SOUND_SMOKER_TONGUE_HIT[] = "zombie_plague/smoker_tonguehit.wav";
new const g_SOUND_SMOKER_TONGUE_MISS[] = "zombie_plague/smoker_tonguemiss.wav";

new const g_SOUND_WITCH[] = "sound/zombie_plague/psychowitch_f.mp3";
new const g_SOUND_WITCH_ALERT[][] = {"zombie_plague/female_cry_2.wav", "zombie_plague/female_cry_4.wav", "zombie_plague/lost_little_witch_01a.wav", "zombie_plague/lost_little_witch_03b.wav", "zombie_plague/walking_cry_10.wav"};

new const g_SOUND_HUNTER_JUMP[] = "zombie_plague/hunter_jump_01.wav";
new const g_SOUND_HUNTER_ALERT[][] = {"zombie_plague/hunter_stalk_04.wav", "zombie_plague/hunter_stalk_05.wav", "zombie_plague/hunter_stalk_09.wav"};

new const g_SOUND_BOOMER_VOMIT[][] = {"zombie_plague/male_boomer_vomit_01.wav", "zombie_plague/male_boomer_vomit_03.wav", "zombie_plague/male_boomer_vomit_04.wav"};
new const g_SOUND_BOOMER_ALERT[][] = {"zombie_plague/male_boomer_lurk_03.wav", "zombie_plague/male_boomer_lurk_08.wav", "zombie_plague/male_boomer_lurk_15.wav"};
new const g_SOUND_BOOMER_EXPLODE[][] = {"zombie_plague/explo_medium_09.wav", "zombie_plague/explo_medium_10.wav", "zombie_plague/explo_medium_14.wav"};

new const g_SOUND_CHARGER_IMPACT[][] = {"zombie_plague/loud_chargerimpact_01.wav", "zombie_plague/loud_chargerimpact_04.wav"};
new const g_SOUND_CHARGER_RESPAWN[][] = {"zombie_plague/charger_alert_01.wav", "zombie_plague/charger_alert_02.wav"};
new const g_SOUND_CHARGER_CHARGE[][] = {"zombie_plague/charger_charge_01.wav", "zombie_plague/charger_charge_02.wav"};
new const g_SOUND_CHARGER_ALERT[][] = {"zombie_plague/charger_lurk_15.wav", "zombie_plague/charger_lurk_17.wav"};

new const g_SOUND_KNIFE_WITH_WALL[][] = {"zombie_plague/charger_smash_01.wav", "zombie_plague/charger_smash_02.wav"};

new const g_SOUND_BHITS[][] = {"player/bhit_flesh-1.wav", "player/bhit_helmet-1.wav", "player/bhit_flesh-2.wav", "player/bhit_flesh-3.wav"};

new const g_SOUND_CHAINSAW[][] = {"zombie_plague/tcs_cs_deploy.wav", "zombie_plague/tcs_cs_hit1.wav", "zombie_plague/tcs_cs_hit2.wav", "zombie_plague/tcs_cs_hit1.wav",
"zombie_plague/tcs_cs_hit2.wav", "zombie_plague/tcs_cs_hitwall.wav", "zombie_plague/tcs_cs_miss.wav", "zombie_plague/tcs_cs_miss.wav", "zombie_plague/tcs_cs_stab.wav"};

new const g_SOUND_KNIFE[][] = {"weapons/knife_deploy1.wav", "weapons/knife_hit1.wav", "weapons/knife_hit2.wav", "weapons/knife_hit3.wav", "weapons/knife_hit4.wav", "weapons/knife_hitwall1.wav", "weapons/knife_slash1.wav", "weapons/knife_slash2.wav", "weapons/knife_stab.wav"};

new const g_SOUND_PIPE[] = "zp5/gk_pipe.wav";

new g_SPRITE_BOOMER;
new const g_SPRITE_BOOMER_DIR[] = "sprites/zp5/gas_puff_01g.spr";

new g_SPRITE_PIPE;
new const g_SPRITE_PIPE_DIR[] = "sprites/zp_tcs/molotov_explosion.spr";

new g_SPRITE_SMOKER_TONGUE;
new g_SPRITE_TRAIL;

new const g_MODELS_HUMANS[][] = {"zp_tcs_l4d_bill", "zp_tcs_l4d_francis", "zp_tcs_l4d_louis", "zp_tcs_l4d_zoei"};
new const g_MODEL_HUNTER[] = "zp_tcs_l4d_hunter";
new const g_MODEL_BOOMER[] = "zp_tcs_l4d_boomer";
new const g_MODEL_SMOKER[] = "zp_tcs_l4d_smoker";
new const g_MODEL_SPITTER[] = "zp_tcs_l4d_spitter";
new const g_MODEL_CHARGER[] = "zp_tcs_l4d_charger";
new const g_MODEL_WITCH[] = "zp_tcs_l4d_witch";
new const g_MODEL_TANK[] = "zp_tcs_l4d_tank";

new const g_MODELS_ZOMBIES[][] = {"tcs_zombie_1", "tcs_zombie_2", "tcs_zombie_3", "tcs_zombie_5", "tcs_zombie_9", "tcs_zombie_12", "tcs_zombie_13"};

new const g_MODELS_ZOMBIE_CLAWS[][] = {"models/zp5/v_zombie_claw_01.mdl", "models/zp5/v_zombie_claw_02.mdl", "models/zp5/v_zombie_claw_03.mdl", "models/zp5/v_zombie_claw_04.mdl", "models/zp5/v_zombie_claw_07.mdl", "models/zp5/v_zombie_claw_08.mdl"};

new const g_MODEL_ADRENALINA[] = "models/zombie_plague/v_adrenalina.mdl";
new const g_MODEL_CLAW_HUNTER[] = "models/zombie_plague/v_knife_hunter.mdl";
new const g_MODEL_CLAW_BOOMER[] = "models/zombie_plague/v_knife_boomer.mdl";
new const g_MODEL_CLAW_SMOKER[] = "models/zombie_plague/v_knife_smoker.mdl";
new const g_MODEL_CLAW_SPITTER[] = "models/zombie_plague/v_knife_spitter.mdl";
new const g_MODEL_CLAW_CHARGER[] = "models/zombie_plague/v_knife_charger.mdl";
new const g_MODEL_CLAW_WITCH[] = "models/zombie_plague/v_knife_witch.mdl";
new const g_MODEL_CLAW_TANK[] = "models/zombie_plague/v_knife_tank.mdl";

new const g_MODEL_V_CHAINSAW[] = "models/zp5/v_chainsaw.mdl";
new const g_MODEL_P_CHAINSAW[] = "models/zp5/p_chainsaw.mdl";

new const g_MODEL_V_PIPE[] = "models/zp_tcs/v_pipe.mdl";
new const g_MODEL_W_PIPE[] = "models/zp_tcs/w_pipe.mdl";

new const g_MODEL_V_PILLS[] = "models/zp_tcs/v_pills.mdl";

new const g_MODEL_TANK_ROCK[] = "models/rocktankx2.mdl";
new g_MODEL_TANK_ROCK_GIBS;
new const g_MODEL_TANK_ROCK_GIBS_DIR[] = "models/rockgibs.mdl";

new Handle:g_SqlTuple;
new Handle:g_SqlConnection;

new Float:g_ModelsTargetTime;

new OrpheuStruct:g_UserMove;
new OrpheuHook:g_oMapConditions;
new OrpheuHook:g_oWinConditions;
new OrpheuHook:g_oRoundTimeExpired;

new Ham:Ham_Player_ResetMaxSpeed = Ham_Item_PreFrame;

new g_SqlError[512];

new g_FwSpawn;
new g_FwPrecacheSound;
new g_ZombiesRespawn = 1;
new g_MaxUsers;
new g_MenuUsersMode;
new g_MenuPage_Users;
new g_ExtraHealth;
new g_TankAlive;
new g_HumanModel = 0;
new g_Message_HideWeapon;
new g_Message_Crosshair;
new g_Message_ScreenShake;
new g_Message_ScreenFade;
new g_WitchAlive;
new g_ModelIndex_Tank;
new g_RoundStart;
new g_WeaponsChoosen[6];
new g_Message_AmmoPickup;
new g_RoundTime = 0;
new g_RespawnCount = 0;
// new g_SetRespawnCount = 0;
// new Float:g_RespawnOrigin[512][3];
new Float:g_SpecialRespawnOrigin[3];
new g_Message_RoundTime;
new g_Message_ShowMenu;
new g_Message_VGUIMenu;
new g_Message_TextMsg;
new g_Message_SendAudio;
new g_Hud_Perm;
new g_RESPAWN_PHASE = 0;
new g_PHASE = 0;
new g_PhaseMinutes;
new g_PhaseSeconds;
new g_HunterCount = 0;
new g_BoomerCount = 0;
new g_SmokerCount = 0;
new g_SpitterCount = 0;
new g_ChargerCount = 0;

new g_UserName[33][32];
new g_Kiske[33];
new g_UserId[33];
new g_AccountPassword[33][32];
new g_AccountLogged[33];
new g_AllowChangeTeam[33];
new g_Zombie[33];
new g_NextZombie[33];
new g_UserModel[33][32];
new Float:g_Options_Volume[33];
new g_ZombiesCount[33];
new g_Hunter[33];
new g_Boomer[33];
new g_Smoker[33];
new g_Spitter[33];
new g_Charger[33];
new g_Witch[33];
new g_Tank[33];
new g_CurrentWeapon[33];
new g_InLongJump[33];
new Float:g_HunterJump[33];
new Float:g_Speed[33];
new Float:g_BoomerVomit[33];
new g_AngryWitch[33];
new g_Smoker_Tongue[33];
new g_Smoker_Victim[33];
new Float:g_SmokerTongue[33];
new Float:g_TankRock[33];
new Float:g_SpitterAcid[33];
new Float:g_Spitter_LastDamage[33];
new g_ChargerEnt[33];
new g_SteamId[33][64];
new g_ChargerInCamera[33];
new Float:g_ChargerAngles[33][3];
new g_ChargerCountFix[33];
new Float:g_ChargerCharge[33];
new g_Chainsaw[33];
new g_AlreadyBuy[33][4];
new g_InAdrenaline[33];
new g_PrimaryWeapon[33];

new const TORNEO_PREFIX[] = "!g[L4D2]!y ";

const UNIT_SECOND = (1 << 12);

const PDATA_SAFE = 2;
const OFFSET_LINUX_WEAPONS = 4;
const OFFSET_LINUX = 5;
const OFFSET_WEAPONOWNER = 41;
const OFFSET_NEXT_PRIMARY_ATTACK = 46;
const OFFSET_NEXT_SECONDARY_ATTACK = 47;
const OFFSET_TIME_WEAPON_IDLE = 48;
const OFFSET_CLIPAMMO = 51;
const OFFSET_CLIENT_CLIPAMMO = 52;
const OFFSET_PAINSHOCK = 108;
const OFFSET_CSTEAMS = 114;
const OFFSET_PRIMARY_WEAPON	= 116;
const OFFSET_CSMENUCODE = 205;
const OFFSET_BUTTONPRESSED = 246;
const OFFSET_ACTIVE_ITEM = 373;
const OFFSET_MODELINDEX = 491;

new const FIRST_JOIN_MSG[] = "#Team_Select";
new const FIRST_JOIN_MSG_SPEC[] = "#Team_Select_Spect";

new const MAX_BPAMMO[] = {-1, 200, -1, 200, 1, 200, 1, 200, 200, 1, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 2, 200, 200, 200, -1, 200};
new const AMMO_TYPE[][] = {"", "357sig", "", "762nato", "", "buckshot", "", "45acp", "556nato", "", "9mm", "57mm", "45acp", "556nato", "556nato", "556nato", "45acp", "9mm", "338magnum", "9mm", "556natobox", "buckshot", "556nato", "9mm", "762nato", "", "50ae", "556nato", "762nato", "", "57mm"};
new const AMMO_WEAPON[] = {0, CSW_AWP, CSW_SCOUT, CSW_M249, CSW_AUG, CSW_XM1014, CSW_MAC10, CSW_FIVESEVEN, CSW_DEAGLE, CSW_P228, CSW_ELITE, CSW_FLASHBANG, CSW_HEGRENADE, CSW_SMOKEGRENADE, CSW_C4};

const PRIMARY_WEAPONS_BIT_SUM = (1 << CSW_SCOUT)|(1 << CSW_XM1014)|(1 << CSW_MAC10)|(1 << CSW_AUG)|(1 << CSW_UMP45)|(1 << CSW_SG550)|(1 << CSW_GALIL)|(1 << CSW_FAMAS)|
(1 << CSW_AWP)|(1 << CSW_MP5NAVY)|(1 << CSW_M249)|(1 << CSW_M3)|(1 << CSW_M4A1)|(1 << CSW_TMP)|(1 << CSW_G3SG1)|(1 << CSW_SG552)|(1 << CSW_AK47)|(1 << CSW_P90);
const SECONDARY_WEAPONS_BIT_SUM = (1 << CSW_P228)|(1 << CSW_ELITE)|(1 << CSW_FIVESEVEN)|(1 << CSW_USP)|(1 << CSW_GLOCK18)|(1 << CSW_DEAGLE);

const HIDE_HUDS	= (1 << 5) | (1 << 3);

enum {
    CurWeapon_IsActive = 1,
    CurWeapon_WeaponID,
    CurWeapon_ClipAmmo
};

enum _:ZombieTypes {
	ZOMBIE_HUNTER = 1,
	ZOMBIE_BOOMER,
	ZOMBIE_SMOKER,
	ZOMBIE_SPITTER,
	ZOMBIE_CHARGER,
	ZOMBIE_WITCH,
	ZOMBIE_TANK
};

new g_ZombiesCountSpecial[8];

enum _:Tasks (+= 236877) {
	TASK_SPAWN = 54272,
	TASK_REPEAT_SOUND_TANK,
	TASK_AURA,
	TASK_SOUND,
	TASK_MODEL,
	TASK_REPEAT_SOUND_WITCH,
	TASK_TEST_SOUND,
	TASK_CHARGER_CAMERA,
	TASK_ADRENALINA
};

#define ID_SPAWN					(taskid - TASK_SPAWN)
#define ID_AURA						(taskid - TASK_AURA)
#define ID_SOUND						(taskid - TASK_SOUND)
#define ID_MODEL					(taskid - TASK_MODEL)
#define ID_TEST_SOUND				(taskid - TASK_TEST_SOUND)
#define ID_CHARGER_CAMERA			(taskid - TASK_CHARGER_CAMERA)
#define ID_ADRENALINA				(taskid - TASK_ADRENALINA)

enum _:Teams {
	FM_CS_TEAM_UNASSIGNED = 0,
	FM_CS_TEAM_T,
	FM_CS_TEAM_CT,
	FM_CS_TEAM_SPECTATOR
};

const KEYSMENU = MENU_KEY_1 | MENU_KEY_2 | MENU_KEY_3 | MENU_KEY_4 | MENU_KEY_5 | MENU_KEY_6 | MENU_KEY_7 | MENU_KEY_8 | MENU_KEY_9 | MENU_KEY_0;

new const Float:g_RESPAWN_ORIGIN[5][47][3] = {
	{
		{2138.939941 , -1331.935668 , 1080.055786}, {2138.082031 , -1180.818481 , 1079.634399}, {2136.944824 , -980.552368 , 1079.075805}, {2251.360107 , -979.316223 , 1079.075805}, {2375.240234 , -978.103454 , 1079.075805},
		{2487.255859 , -977.006835 , 1079.075805}, {2487.720458 , -1100.766601 , 1079.075805}, {2488.507568 , -1212.932128 , 1079.075805}, {2489.545654 , -1360.856201 , 1079.075805}, {2490.575683 , -1487.421020 , 1079.075805},
		{2491.704589 , -1613.985839 , 1079.075805}, {2492.832031 , -1735.750854 , 1079.075805}, {2356.667480 , -1735.395141 , 1079.075805}, {2239.738037 , -1738.458862 , 1079.075805}, {2115.611083 , -1741.711181 , 1079.075805}, 
		{1979.488159 , -1745.277709 , 1079.075805}, {1845.764282 , -1748.781494 , 1079.075805}, {1704.109374 , -1738.205078 , 1349.843627}, {1593.404785 , -1740.945800 , 1382.689453}, {1585.689331 , -1588.762329 , 1382.689453}, 
		{1582.797729 , -1471.827026 , 1382.689453}, {1740.134765 , -1461.994506 , 1319.388671}, {1864.053344 , -1460.235839 , 1319.388671}, {2002.038696 , -1459.227905 , 1271.427612}, {2154.599365 , -1457.062622 , 1271.427612}, 
		{2281.001464 , -1455.268554 , 1271.427612}, {2397.804931 , -1453.610717 , 1271.427612}, {2208.593017 , -1612.085693 , 1397.921874}, {2053.639648 , -1619.312499 , 1397.921874}, {1951.168579 , -1624.191040 , 1397.921874}, 
		{1822.496215 , -1627.702026 , 1397.921874}, {1703.130371 , -1627.373413 , 1397.921874}, {2586.436279 , -1756.850097 , 1269.482299}, {2583.915039 , -1644.707641 , 1269.482299}, {2580.266357 , -1482.417480 , 1269.482299}, 
		{2680.021484 , -1488.482177 , 1269.482299}, {2686.039306 , -1619.988281 , 1269.482299}, {2695.279052 , -1743.775756 , 1269.482299}, {747.829650 , -58.956871 , 992.899108}, {745.335693 , 62.392330 , 992.899108}, 
		{740.662292 , 203.044372 , 992.899108}, {748.865173 , 381.648193 , 992.899108}, {960.505065 , 361.076416 , 992.899108}, {981.763244 , 142.361785 , 992.899108}, {985.444274 , -12.724399 , 992.899108}, 
		{967.119506 , -165.539993 , 992.899108}, {805.424865 , -277.064666 , 992.899108}
	},
	{
		{-246.563262 , 429.222808 , 1445.028930}, {-244.613479 , 290.907165 , 1445.028930}, {-241.988388 , 104.685600 , 1445.028930}, {-239.292251 , -86.575462 , 1445.028930}, {-236.498016 , -284.795867 , 1445.028930}, 
		{-236.556335 , -466.442810 , 1445.028930}, {-241.296890 , -631.011901 , 1445.028930}, {-242.794036 , -810.280639 , 1445.028930}, {-242.641052 , -1037.322753 , 1445.028930}, {-242.382415 , -1237.964843 , 1445.028930}, 
		{-241.427078 , -1414.602905 , 1445.028930}, {-238.487731 , -1617.624267 , 1445.028930}, {-235.892349 , -1796.887817 , 1445.028930}, {-6.757249 , -1855.274047 , 1431.865722}, {-11.881302 , -1683.660156 , 1431.865722}, 
		{-15.867594 , -1530.832885 , 1431.865722}, {-18.645412 , -1387.585327 , 1431.865722}, {-18.492437 , -1196.303344 , 1431.865722}, {-18.861484 , -1019.661621 , 1431.865722}, {-19.446413 , -859.104003 , 1431.865722}, 
		{-20.104188 , -680.066711 , 1431.865722}, {-21.278640 , -474.629821 , 1431.865722}, {-22.344247 , -295.352539 , 1431.865722}, {-23.408428 , -116.315330 , 1431.865722}, {-24.529668 , 72.321250 , 1431.865722}, 
		{-25.779294 , 282.557861 , 1431.865722}, {-656.607604 , -790.941955 , 1021.727416}, {-675.133789 , -576.897033 , 1021.727416}, {-675.135559 , -300.224914 , 1021.727416}, {-678.058532 , -23.389953 , 1021.727416}, 
		{-680.616455 , 174.832107 , 1021.727416}, {-574.780395 , 359.393920 , 1021.727416}, {-423.655059 , 276.085601 , 1021.727416}, {-387.751525 , 31.307455 , 1021.727416}, {-371.291992 , -192.672821 , 1021.727416}, 
		{-363.564208 , -400.362854 , 1021.727416}, {-363.441070 , -615.388427 , 1021.727416}, {-1196.076171 , -503.091918 , 1146.508178}, {-1389.182983 , -509.398223 , 1146.508178}, {-1592.092773 , -511.769104 , 1146.508178}, 
		{-1744.371826 , -591.729125 , 1146.508178}, {-1785.311035 , -773.725952 , 1146.508178}, {-1701.304443 , -958.526428 , 1146.508178}, {-1538.994506 , -1031.993530 , 1146.508178}, {-1322.452880 , -986.482482 , 1146.508178}, 
		{-1205.410278 , -28.836294 , 1064.490600}, {-1531.667724 , -49.169853 , 1064.490600}
	},
	{
		{-2230.262451 , 850.936096 , 2221.669921}, {-2151.463623 , 852.250854 , 2221.669921}, {-2058.351806 , 853.199401 , 2221.669921}, {-1948.431152 , 853.489562 , 2221.669921}, {-1845.710083 , 853.685546 , 2221.669921}, 
		{-1719.228759 , 853.926879 , 2221.669921}, {-1590.107421 , 854.173217 , 2221.669921}, {-1456.426025 , 854.436706 , 2221.669921}, {-1341.704833 , 854.780761 , 2221.669921}, {-1227.232055 , 853.578613 , 2221.669921}, 
		{-1112.519897 , 852.235473 , 2221.669921}, {-997.799438 , 851.783325 , 2221.669921}, {-885.481140 , 851.340637 , 2221.669921}, {-850.224426 , 732.020446 , 2221.669921}, {-917.026611 , 730.982299 , 2221.669921}, 
		{-1036.292358 , 729.128845 , 2221.669921}, {-1143.804199 , 728.204772 , 2221.669921}, {-1232.099609 , 730.097778 , 2221.669921}, {-1330.233032 , 731.943176 , 2221.669921}, {-1425.749511 , 731.298706 , 2221.669921}, 
		{-1519.105712 , 730.647338 , 2221.669921}, {-1614.621826 , 730.032836 , 2221.669921}, {-1729.342041 , 730.056152 , 2221.669921}, {-1846.463256 , 730.607116 , 2221.669921}, {-1956.143066 , 731.155639 , 2221.669921}, 
		{-2137.815673 , 732.131530 , 2221.669921}, {-2252.141113 , 731.614562 , 2221.669921}, {-2251.622070 , 631.605163 , 2200.422119}, {-2172.817138 , 630.943603 , 2200.422119}, {-2053.541992 , 632.082763 , 2200.422119}, 
		{-1931.626953 , 633.264099 , 2200.422119}, {-1800.112304 , 634.538452 , 2200.422119}, {-1671.237548 , 635.787231 , 2200.422119}, {-1544.522705 , 636.896057 , 2200.422119}, {-1408.449951 , 637.087524 , 2200.422119}, 
		{-1284.152343 , 634.729797 , 2200.422119}, {-1136.073486 , 634.384643 , 2200.422119}, {-1007.197509 , 635.109008 , 2200.422119}, {-870.879577 , 635.892578 , 2200.422119}, {-857.763916 , 531.481140 , 2219.229492}, 
		{-945.670288 , 524.666870 , 2219.229492}, {-1079.369628 , 517.309631 , 2219.229492}, {-1229.826293 , 514.709655 , 2219.229492}, {-1344.294433 , 513.102111 , 2219.229492}, {-1487.793945 , 510.623413 , 2219.229492}, 
		{-1635.874511 , 510.655273 , 2219.229492}, {-1889.137207 , 511.723663 , 2219.229492}
	},
	{
		{585.280090 , 1460.163208 , 2251.717285}, {721.180419 , 1462.928710 , 2251.717285}, {895.650817 , 1464.240234 , 2251.717285}, {1077.092529 , 1464.637207 , 2251.717285}, {1258.774414 , 1465.034667 , 2251.717285}, 
		{1435.416259 , 1465.421142 , 2251.717285}, {1626.458251 , 1465.839111 , 2251.717285}, {1791.339965 , 1466.199829 , 2251.717285}, {1956.221679 , 1466.560546 , 2251.717285}, {2128.299316 , 1466.937011 , 2251.717285}, 
		{2246.634277 , 1606.618774 , 2251.717285}, {2238.153808 , 1773.565063 , 2251.717285}, {2237.584716 , 1943.006835 , 2251.717285}, {2236.945068 , 2134.284423 , 2251.717285}, {2236.348876 , 2315.717041 , 2251.717285}, 
		{2235.374755 , 2494.989746 , 2251.717285}, {2234.692626 , 2650.263183 , 2251.717285}, {2233.798828 , 2824.496093 , 2251.717285}, {2230.414550 , 2991.730468 , 2251.717285}, {2169.155517 , 3115.890380 , 2251.717285}, 
		{1996.791870 , 3157.616455 , 2251.717285}, {1817.576416 , 3154.446289 , 2251.717285}, {1638.546142 , 3154.653564 , 2251.717285}, {1464.106079 , 3151.024658 , 2251.717285}, {1287.448852 , 2951.624755 , 2251.717285}, 
		{1141.610229 , 2946.802734 , 2251.717285}, {1014.867309 , 2877.532714 , 2251.717285}, {1020.606079 , 2703.739501 , 2251.717285}, {1055.554321 , 2476.553955 , 2251.717285}, {1053.352172 , 2278.389892 , 2251.717285}, 
		{1038.481079 , 2114.894775 , 2251.717285}, {981.208190 , 1938.680908 , 2251.717285}, {1018.627136 , 1774.791503 , 2251.717285}, {1156.392211 , 1663.299926 , 2251.717285}, {1314.189697 , 1699.563842 , 2251.717285}, 
		{1404.880859 , 1842.067626 , 2251.717285}, {1395.900146 , 2017.589843 , 2251.717285}, {1378.362426 , 2207.584472 , 2251.717285}, {1439.349975 , 2352.128906 , 2251.717285}, {1587.941040 , 2431.227050 , 2251.717285}, 
		{1766.758178 , 2439.057617 , 2251.717285}, {1919.367919 , 2474.338623 , 2251.717285}, {1890.507446 , 2663.608154 , 2251.717285}, {1628.725708 , 2679.240966 , 2251.717285},{2044.822509 , 2151.033447 , 1584.977661}, 
		{2048.053955 , 1775.824218 , 1613.098388}, {1551.012817 , 1782.836425 , 1594.169555}
	},
	{
		{248.557189 , 2726.700439 , 2000.953002}, {247.552124 , 2616.934814 , 2000.953002}, {246.099838 , 2471.260742 , 2000.953002}, {244.791107 , 2339.986083 , 2000.953002}, {243.432128 , 2203.671630 , 2000.953002}, 
		{241.457366 , 2005.589599 , 2000.953002}, {478.410064 , 2713.940673 , 2012.058227}, {477.097686 , 2616.181152 , 2012.058227}, {474.722076 , 2487.079589 , 2012.058227}, {472.640472 , 2357.015380 , 2012.058227}, 
		{471.338104 , 2237.740234 , 2012.058227}, {470.203399 , 2111.025390 , 2012.058227}, {468.644683 , 1934.392578 , 2012.058227}, {580.860534 , 1798.829589 , 2225.924072}, {585.433837 , 1932.256469 , 2225.924072}, 
		{586.623352 , 2073.130859 , 2225.924072}, {587.754089 , 2207.045410 , 2225.924072}, {589.024658 , 2357.519287 , 2225.924072}, {590.993469 , 2498.384765 , 2225.924072}, {593.808227 , 2651.242919 , 2225.924072}, 
		{596.237426 , 2799.301757 , 2225.924072}, {598.835998 , 2976.156738 , 2225.924072}, {772.857971 , 2703.581054 , 2156.131103}, {825.944152 , 2555.330078 , 2156.131103}, {845.671813 , 2403.876953 , 2156.131103}, 
		{842.665832 , 2251.111083 , 2156.131103}, {819.866394 , 2100.226074 , 2156.131103}, {768.075317 , 1946.255004 , 2156.131103}, {-181.107666 , 1924.805908 , 2146.495117}, {-179.293518 , 2039.358886 , 2146.495117}, 
		{-180.142852 , 2168.219726 , 2146.495117}, {-183.278259 , 2318.902832 , 2146.495117}, {-186.453613 , 2471.505371 , 2146.495117}, {-189.683883 , 2626.747314 , 2146.495117}, {599.487670 , 1660.876831 , 2170.562988}, 
		{595.947509 , 1546.362792 , 2170.562988}, {668.246337 , 1448.283935 , 2170.562988}, {787.353759 , 1445.959960 , 2170.562988}, {918.815551 , 1449.865478 , 2170.562988},{754.157409 , 3137.093505 , 2226.545898}, 
		{825.749938 , 3138.652587 , 2226.545898}, {942.601440 , 3141.197265 , 2226.545898}, {1062.095947 , 3143.596923 , 2226.545898}, {1184.000244 , 3141.629150 , 2226.545898}, {1305.665649 , 3139.740478 , 2226.545898}, 
		{1439.583618 , 3140.417724 , 2226.545898}, {1618.616333 , 3142.250732 , 2226.545898}
	}
};

public plugin_precache() {
	new sItem[64];
	new i;
	
	g_FwSpawn = register_forward(FM_Spawn, "fw_Spawn");
	g_FwPrecacheSound = register_forward(FM_PrecacheSound, "fw_PrecacheSound");
	
	precache_generic(g_SOUND_HORDE);
	precache_generic(g_SOUND_LOWHP);
	precache_generic(g_SOUND_TANK);
	precache_generic(g_SOUND_WITCH);
	
	for(i = 0; i < sizeof(g_SOUND_AMBIENT); ++i) {
		precache_sound(g_SOUND_AMBIENT[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_CLAW_SLASH); ++i) {
		precache_sound(g_SOUND_CLAW_SLASH[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_CLAW_WALL); ++i) {
		precache_sound(g_SOUND_CLAW_WALL[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_ZOMBIE_DIE); ++i) {
		precache_sound(g_SOUND_ZOMBIE_DIE[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_PAIN); ++i) {
		precache_sound(g_SOUND_PAIN[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_SPITTER_ALERT); ++i) {
		precache_sound(g_SOUND_SPITTER_ALERT[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_SMOKER_ALERT); ++i) {
		precache_sound(g_SOUND_SMOKER_ALERT[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_WITCH_ALERT); ++i) {
		precache_sound(g_SOUND_WITCH_ALERT[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_HUNTER_ALERT); ++i) {
		precache_sound(g_SOUND_HUNTER_ALERT[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_BOOMER_VOMIT); ++i) {
		precache_sound(g_SOUND_BOOMER_VOMIT[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_BOOMER_ALERT); ++i) {
		precache_sound(g_SOUND_BOOMER_ALERT[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_BOOMER_EXPLODE); ++i) {
		precache_sound(g_SOUND_BOOMER_EXPLODE[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_CHARGER_IMPACT); ++i) {
		precache_sound(g_SOUND_CHARGER_IMPACT[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_CHARGER_RESPAWN); ++i) {
		precache_sound(g_SOUND_CHARGER_RESPAWN[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_CHARGER_CHARGE); ++i) {
		precache_sound(g_SOUND_CHARGER_CHARGE[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_CHARGER_ALERT); ++i) {
		precache_sound(g_SOUND_CHARGER_ALERT[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_KNIFE_WITH_WALL); ++i) {
		precache_sound(g_SOUND_KNIFE_WITH_WALL[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_BHITS); ++i) {
		precache_sound(g_SOUND_BHITS[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_CHAINSAW); ++i) {
		precache_sound(g_SOUND_CHAINSAW[i]);
	}
	
	precache_sound(g_SOUND_CLAW_ATTACK);
	precache_sound(g_SOUND_CLAW_STAB);
	precache_sound(g_SOUND_SCARE);
	precache_sound(g_SOUND_TANK_ROCK);
	precache_sound(g_SOUND_SPITTER_ACID_INIT);
	precache_sound(g_SOUND_SMOKER_RESPAWN);
	precache_sound(g_SOUND_SMOKER_TONGUE_HIT);
	precache_sound(g_SOUND_SMOKER_TONGUE_MISS)
	precache_sound(g_SOUND_HUNTER_JUMP);
	precache_sound(g_SOUND_PIPE);
	
	g_SPRITE_BOOMER = precache_model(g_SPRITE_BOOMER_DIR);
	g_SPRITE_SMOKER_TONGUE = precache_model("sprites/zbeam4.spr");
	g_SPRITE_TRAIL = precache_model("sprites/xbeam3.spr");
	g_SPRITE_PIPE = precache_model(g_SPRITE_PIPE_DIR);
	
	for(i = 0; i < 3; ++i) {
		formatex(sItem, 63, "models/player/%s/%s.mdl", g_MODELS_HUMANS[i], g_MODELS_HUMANS[i]);
		precache_model(sItem);
	}
	
	for(i = 0; i < sizeof(g_MODELS_ZOMBIES); ++i) {
		formatex(sItem, 63, "models/player/%s/%s.mdl", g_MODELS_ZOMBIES[i], g_MODELS_ZOMBIES[i]);
		precache_model(sItem);
	}
	
	for(i = 0; i < sizeof(g_MODELS_ZOMBIE_CLAWS); ++i) {
		precache_model(g_MODELS_ZOMBIE_CLAWS[i]);
	}
	
	formatex(sItem, 63, "models/player/%s/%s.mdl", g_MODEL_HUNTER, g_MODEL_HUNTER);
	precache_model(sItem);
	
	formatex(sItem, 63, "models/player/%s/%s.mdl", g_MODEL_BOOMER, g_MODEL_BOOMER);
	precache_model(sItem);
	
	formatex(sItem, 63, "models/player/%s/%s.mdl", g_MODEL_SMOKER, g_MODEL_SMOKER);
	precache_model(sItem);
	
	formatex(sItem, 63, "models/player/%s/%sT.mdl", g_MODEL_SMOKER, g_MODEL_SMOKER);
	precache_model(sItem);
	
	formatex(sItem, 63, "models/player/%s/%s.mdl", g_MODEL_SPITTER, g_MODEL_SPITTER);
	precache_model(sItem);
	
	formatex(sItem, 63, "models/player/%s/%s.mdl", g_MODEL_CHARGER, g_MODEL_CHARGER);
	precache_model(sItem);
	
	formatex(sItem, 63, "models/player/%s/%s.mdl", g_MODEL_WITCH, g_MODEL_WITCH);
	precache_model(sItem);
	
	formatex(sItem, 63, "models/player/%s/%s.mdl", g_MODEL_TANK, g_MODEL_TANK);
	g_ModelIndex_Tank = precache_model(sItem);
	
	precache_model(g_MODEL_ADRENALINA);
	precache_model(g_MODEL_CLAW_HUNTER);
	precache_model(g_MODEL_CLAW_BOOMER);
	precache_model(g_MODEL_CLAW_SMOKER);
	precache_model(g_MODEL_CLAW_SPITTER);
	precache_model(g_MODEL_CLAW_CHARGER);
	precache_model(g_MODEL_CLAW_WITCH);
	precache_model(g_MODEL_CLAW_TANK);
	precache_model(g_MODEL_V_PIPE);
	precache_model(g_MODEL_W_PIPE);
	precache_model(g_MODEL_V_PILLS);
	precache_model(g_MODEL_TANK_ROCK);
	precache_model(g_MODEL_V_CHAINSAW);
	precache_model(g_MODEL_P_CHAINSAW);
	g_MODEL_TANK_ROCK_GIBS = precache_model(g_MODEL_TANK_ROCK_GIBS_DIR);
	precache_model("models/zp5/gk_ranks.mdl");
	
	precache_model("sprites/animglow01.spr");
}

new const WEAPON_ENT_NAMES[][] = {"", "weapon_p228", "", "weapon_scout", "weapon_hegrenade", "weapon_xm1014", "weapon_c4", "weapon_mac10", "weapon_aug", "weapon_smokegrenade", "weapon_elite", "weapon_fiveseven", "weapon_ump45", "weapon_sg550", "weapon_galil", "weapon_famas",
"weapon_usp", "weapon_glock18", "weapon_awp", "weapon_mp5navy", "weapon_m249", "weapon_m3", "weapon_m4a1", "weapon_tmp", "weapon_g3sg1", "weapon_flashbang", "weapon_deagle", "weapon_sg552", "weapon_ak47", "weapon_knife", "weapon_p90"};

public plugin_init() {
	new i;
	
	register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR);
	
	set_task(0.4, "pluginSQL");
	
	register_event("AmmoX", "event_AmmoX", "be");
	
	OrpheuRegisterHook(OrpheuGetDLLFunction("pfnPM_Move", "PM_Move"), "OnPM_Move");
	OrpheuRegisterHook(OrpheuGetFunction("PM_Jump"), "OnPM_Jump");
	OrpheuRegisterHook(OrpheuGetFunction("PM_Duck"), "OnPM_Duck");
	
	unregister_forward(FM_Spawn, g_FwSpawn);
	unregister_forward(FM_PrecacheSound, g_FwPrecacheSound);
	
	register_forward(FM_SetClientKeyValue, "fw_SetClientKeyValue");
	register_forward(FM_ClientUserInfoChanged, "fw_ClientUserInfoChanged");
	register_forward(FM_ClientKill, "fw_ClientKill");
	register_forward(FM_EmitSound, "fw_EmitSound");
	register_forward(FM_CmdStart, "fw_CmdStart");
	register_forward(FM_SetModel, "fw_SetModel");
	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", 1);
	
	RegisterHam(Ham_Spawn, "player", "fw_PlayerSpawn_Post", 1);
	RegisterHam(Ham_TakeDamage, "player", "fw_TakeDamage");
	RegisterHam(Ham_TakeDamage, "player", "fw_TakeDamage_Post", 1);
	RegisterHam(Ham_Use, "func_tank", "fw_UseStationary");
	RegisterHam(Ham_Use, "func_tankmortar", "fw_UseStationary");
	RegisterHam(Ham_Use, "func_tankrocket", "fw_UseStationary");
	RegisterHam(Ham_Use, "func_tanklaser", "fw_UseStationary");
	RegisterHam(Ham_Use, "func_tank", "fw_UseStationary_Post", 1);
	RegisterHam(Ham_Use, "func_tankmortar", "fw_UseStationary_Post", 1);
	RegisterHam(Ham_Use, "func_tankrocket", "fw_UseStationary_Post", 1);
	RegisterHam(Ham_Use, "func_tanklaser", "fw_UseStationary_Post", 1);
	RegisterHam(Ham_Player_Jump, "player", "fw_PlayerJump");
	RegisterHam(Ham_Player_Duck, "player", "fw_PlayerDuck");
	RegisterHam(Ham_Killed, "player", "fw_PlayerKilled");
	RegisterHam(Ham_Killed, "player", "fw_PlayerKilled_Post", 1);
	RegisterHam(Ham_Player_ResetMaxSpeed, "player", "fw_ResetMaxSpeed_Post", 1);
	RegisterHam(Ham_Think, "trigger_camera", "fw_Think_TriggerCamera");
	RegisterHam(Ham_Think, "grenade", "fw_Think_Grenade");
	RegisterHam(Ham_Touch, "weaponbox", "fw_TouchWeapon");
	RegisterHam(Ham_Touch, "armoury_entity", "fw_TouchWeapon");
	RegisterHam(Ham_Touch, "weapon_shield", "fw_TouchWeapon");
	
	register_touch("entRockTank", "*", "touch__RockTank");
	register_touch("player", "*", "touch__PlayerAll");
	
	for(i = 1; i < sizeof(WEAPON_ENT_NAMES); ++i) {
		if(WEAPON_ENT_NAMES[i][0]) {
			RegisterHam(Ham_Item_Deploy, WEAPON_ENT_NAMES[i], "fw_Item_Deploy_Post", 1);
		}
	}
	
	RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_knife", "fw_Weapon_PrimaryAttack_Post", 1);
	
	new const WEAPON_COMMANDS[][] =	{
		"buy", "buyammo1", "buyammo2", "cl_autobuy", "cl_rebuy", "cl_setautobuy", "cl_setrebuy", "usp", "glock", "deagle", "p228", "elites", "fn57", "m3", "xm1014", "mp5", "tmp", "p90", "mac10", "ump45", "ak47", "galil", "famas", "sg552", "m4a1", "aug", "scout", "awp", "g3sg1",
		"sg550", "m249", "vest", "vesthelm", "flash", "hegren", "sgren", "defuser", "nvgs", "shield", "primammo", "secammo", "km45", "9x19mm", "nighthawk", "228compact", "fiveseven", "12gauge", "autoshotgun", "mp", "c90", "cv47", "defender", "clarion", "krieg552", "bullpup", "magnum",
		"d3au1", "krieg550", "smg", "radio1", "radio2", "radio3", "coverme", "takepoint", "holdpos", "regroup", "followme", "takingfire", "go", "fallback", "sticktog", "getinpos", "stormfront", "report", "roger", "enemyspot", "needbackup", "sectorclear", "inposition", "reportingin", "getout", "negative", "enemydown"
	};
	
	for(i = 0; i < sizeof(WEAPON_COMMANDS); ++i) {
		register_clcmd(WEAPON_COMMANDS[i], "clcmd_BlockCommand");
	}
	
	register_concmd("/c", "clcmd_CTest");
	register_clcmd("say /w", "clcmd_Weapons");
	register_clcmd("say /noclip", "clcmd_Noclip");
	
	register_clcmd("chooseteam", "clcmd_Changeteam");
	register_clcmd("jointeam", "clcmd_Changeteam");
	
	register_clcmd("buyequip", "clcmd_SetSpecialRespawn");
	register_clcmd("nightvision", "clcmd_Nightvision");
	
	register_clcmd("INGRESAR_CONTRASENIA", "clcmd_EnterPassword");
	
	register_clcmd("say", "clcmd_Say");
	register_clcmd("say_team", "clcmd_SayTeam");
	
	register_concmd("l4d2_menu", "concmd_L4D2Menu");
	register_concmd("l4d2_break", "concmd_Break");
	register_concmd("l4d2_angry", "concmd_Angry");
	register_concmd("l4d2_teams", "concmd_Teams");
	register_concmd("l4d2_human", "concmd_Human");
	register_concmd("l4d2_start", "concmd_Start");
	// register_concmd("l4d2_reset", "concmd_Reset");
	register_concmd("l4d2_kill", "concmd_Kill");
	register_concmd("l4d2_respawn", "concmd_Respawn");
	
	register_menu("Menu Join", KEYSMENU, "menu__Join");
	register_menu("Login Menu", KEYSMENU, "menu__Login");
	register_menu("Game Menu", KEYSMENU, "menu__Game");
	
	g_Message_HideWeapon = get_user_msgid("HideWeapon");
	g_Message_Crosshair = get_user_msgid("Crosshair");
	g_Message_ScreenShake = get_user_msgid("ScreenShake");
	g_Message_ScreenFade = get_user_msgid("ScreenFade");
	g_Message_AmmoPickup = get_user_msgid("AmmoPickup");
	g_Message_RoundTime = get_user_msgid("RoundTime");
	g_Message_TextMsg = get_user_msgid("TextMsg");
	g_Message_SendAudio = get_user_msgid("SendAudio");
	g_Message_ShowMenu = get_user_msgid("ShowMenu");
	g_Message_VGUIMenu = get_user_msgid("VGUIMenu");
	
	set_msg_block(get_user_msgid("ClCorpse"), BLOCK_SET);
	register_message(get_user_msgid("CurWeapon"), "message__CurWeapon");
	register_message(get_user_msgid("WeapPickup"), "message__WeapPickup");
	register_message(g_Message_AmmoPickup, "message__AmmoPickup");
	register_message(g_Message_ShowMenu, "message__ShowMenu");
	register_message(g_Message_VGUIMenu, "message__VGUIMenu");
	register_message(g_Message_TextMsg, "message__TextMsg");
	register_message(g_Message_SendAudio, "message__SendAudio");
	register_message(get_user_msgid("Health"), "message__Health");
	
	register_impulse(100, "impulse_Flashlight");
	register_impulse(201, "impulse_Spray");
	
	g_MaxUsers = get_maxplayers();
	
	g_WeaponsChoosen[4] = 2;
	g_WeaponsChoosen[5] = 2;
	
	g_Hud_Perm = CreateHudSyncObj();
	
	state disabled;
	game_enableForwards();
}

public game_enableForwards() <> {}
public game_enableForwards() <disabled> {
	g_oMapConditions = OrpheuRegisterHook(OrpheuGetFunction("CheckMapConditions", "CHalfLifeMultiplay"), "game_blockConditions");
	g_oWinConditions = OrpheuRegisterHook(OrpheuGetFunction("CheckWinConditions", "CHalfLifeMultiplay"), "game_blockConditions");

	g_oRoundTimeExpired = OrpheuRegisterHook(OrpheuGetFunction("HasRoundTimeExpired", "CHalfLifeMultiplay"), "game_blockConditions");

	state enabled;
}

public game_disableForwards() <> {}
public game_disableForwards() <enabled> {
	OrpheuUnregisterHook(g_oMapConditions);
	OrpheuUnregisterHook(g_oWinConditions);

	OrpheuUnregisterHook(g_oRoundTimeExpired);

	state disabled;
}

public OrpheuHookReturn:game_blockConditions() <> {
	return OrpheuIgnored;
}

public OrpheuHookReturn:game_blockConditions() <enabled> {
	OrpheuSetReturn(false);
	return OrpheuSupercede;
}

public pluginSQL() {
	set_cvar_num("sv_alltalk", 0);
	set_cvar_num("sv_voicequality", 5);
	set_cvar_num("sv_airaccelerate", 100);
	set_cvar_num("mp_flashlight", 0);
	set_cvar_num("mp_footsteps", 0);
	set_cvar_num("mp_freezetime", 0);
	set_cvar_num("mp_friendlyfire", 0);
	set_cvar_num("mp_limitteams", 0);
	set_cvar_num("mp_autoteambalance", 0);
	set_cvar_num("mp_timelimit", 9999);
	set_cvar_num("sv_restart", 1);
	set_cvar_num("sv_maxspeed", 500);
	set_cvar_num("pbk_afk_min_players", 33);
	
	set_cvar_string("hostname", "- [GAM!NGA] #11 [TORNEO ZP] - by LocalStrike");
	
	set_cvar_string("sv_voicecodec", "voice_speex");
	
	g_SqlTuple = SQL_MakeDbTuple(SQL_HOST, SQL_USER, SQL_PASS, SQL_TABLE);
	if(g_SqlTuple == Empty_Handle) {
		log_to_file("torneo_sql_tuple.log", "%s", g_SqlError);
		set_fail_state(g_SqlError);
	}
	
	new iSql_ErrorNum;
	
	g_SqlConnection = SQL_Connect(g_SqlTuple, iSql_ErrorNum, g_SqlError, 511);
	if(g_SqlConnection == Empty_Handle) {
		log_to_file("torneo_sql_connect.log", "%s", g_SqlError);
		set_fail_state(g_SqlError);
	}
}

public plugin_end() {
	SQL_FreeHandle(g_SqlConnection);
	SQL_FreeHandle(g_SqlTuple);
	
	game_disableForwards();
}

public fw_Spawn(const entity) {
	if(!pev_valid(entity)) {
		return FMRES_IGNORED;
	}
	
	new const REMOVE_ENTS[][] =	{
		"func_bomb_target", "info_bomb_target", "func_vip_safetyzone", "func_escapezone", "hostage_entity", "monster_scientist", "info_hostage_rescue",
		"func_hostage_rescue", "env_rain", "env_snow", "env_fog", "func_vehicle", "info_map_parameters", "func_buyzone", "armoury_entity", "game_text", "func_ladder"
	};
	
	new i;
	new sClassName[32];
	
	entity_get_string(entity, EV_SZ_classname, sClassName, 31);
	
	for(i = 0; i < sizeof(REMOVE_ENTS); ++i) {
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

public client_putinserver(id) {
	get_user_name(id, g_UserName[id], 31);
	get_user_authid(id, g_SteamId[id], 63);
	
	g_Kiske[id] = 0;
	g_UserId[id] = 0;
	g_AccountPassword[id][0] = EOS;
	g_AccountLogged[id] = 0;
	g_AllowChangeTeam[id] = 0;
	g_Zombie[id] = 0;
	g_NextZombie[id] = 0;
	g_Options_Volume[id] = 0.25;
	g_ZombiesCount[id] = 0;
	g_Hunter[id] = 0;
	g_Boomer[id] = 0;
	g_Smoker[id] = 0;
	g_Spitter[id] = 0;
	g_Charger[id] = 0;
	g_Witch[id] = 0;
	g_Tank[id] = 0;
	g_CurrentWeapon[id] = 0;
	g_InLongJump[id] = 0;
	g_HunterJump[id] = 0.0;
	g_BoomerVomit[id] = 0.0;
	g_AngryWitch[id] = 0;
	g_Smoker_Tongue[id] = 0;
	g_Smoker_Victim[id] = 0;
	g_SmokerTongue[id] = 0.0;
	g_TankRock[id] = 0.0;
	g_SpitterAcid[id] = 0.0;
	g_Spitter_LastDamage[id] = 0.0;
	g_ChargerEnt[id] = 0;
	g_ChargerInCamera[id] = 0;
	g_ChargerCountFix[id] = 0;
	g_ChargerCharge[id] = 0.0;
	g_Chainsaw[id] = 0;
	g_AlreadyBuy[id] = {0, 0, 0, 0};
	g_InAdrenaline[id] = 0;
	g_PrimaryWeapon[id] = -1;
	
	g_Human_Damage[id] = 0;
	g_Human_ZombiesKill[id] = 0;
	g_Human_ZombiesSpecialKill[id] = 0;
	g_Human_DamageWithPistol[id] = 0;
	g_Human_DamageWithChainsaw[id] = 0;
	g_Human_Shoots[id] = 0;
	g_Human_ShootsHS[id] = 0;
	g_Human_HuntersKill[id] = 0;
	g_Human_BoomersKill[id] = 0;
	g_Human_SmokersKill[id] = 0;
	g_Human_ChargersKill[id] = 0;
	g_Human_SpittersKill[id] = 0;
	g_Human_WitchsKill[id] = 0;
	g_Human_TanksKill[id] = 0;
	g_Human_DamageToTank[id] = 0;

	g_Zombie_Damage[id] = 0;
	g_Zombie_HumansKill[id] = 0;
	g_Zombie_HunterDamage[id] = 0;
	g_Zombie_BoomerDamage[id] = 0;
	g_Zombie_SmokerDamage[id] = 0;
	g_Zombie_ChargerDamage[id] = 0;
	g_Zombie_SpitterDamage[id] = 0;
	g_Zombie_WitchDamage[id] = 0;
	g_Zombie_TankDamage[id] = 0;
	g_Zombie_BoomerVomitInH[id] = 0;
	g_Zombie_BoomerVomitInZ[id] = 0;
	g_Zombie_SmokerHumans[id] = 0;
	g_Zombie_ChargerImpacts[id] = 0;
	g_Zombie_SpitterImpacts[id] = 0;
	g_Zombie_TankRock[id] = 0;
	
	if(containi(g_UserName[id], "DROP TABLE") != -1 || containi(g_UserName[id], "TRUNCATE") != -1 || containi(g_UserName[id], "INSERT") != -1 || containi(g_UserName[id], "UPDATE") != -1 || containi(g_UserName[id], "DELETE") != -1 ||
	containi(g_UserName[id], "\") != -1)
	{
		server_cmd("kick #%d ^"Tu nombre tiene algun caracter invalido^"", get_user_userid(id));
		return;
	}
	
	if(equali(g_UserName[id], "[GAM!NGA] KISKE")) {
		g_Kiske[id] = 1;
	}
	
	set_task(0.2, "checkAccount", id);
	set_task(3.0, "modifCommands", id);
}

public client_disconnect(id) {
	remove_task(id + TASK_AURA);
	remove_task(id + TASK_SOUND);
	remove_task(id + TASK_CHARGER_CAMERA);
	remove_task(id + TASK_ADRENALINA);
	
	if(g_Hunter[id] || g_NextZombie[id] == ZOMBIE_HUNTER) {
		--g_HunterCount;
	} else if(g_Boomer[id] || g_NextZombie[id] == ZOMBIE_BOOMER) {
		--g_BoomerCount;
	} else if(g_Smoker[id] || g_NextZombie[id] == ZOMBIE_SMOKER) {
		--g_SmokerCount;
	} else if(g_Spitter[id] || g_NextZombie[id] == ZOMBIE_SPITTER) {
		--g_SpitterCount;
	} else if(g_Charger[id] || g_NextZombie[id] == ZOMBIE_CHARGER) {
		--g_ChargerCount;
		if(g_NextZombie[id] != ZOMBIE_CHARGER) {
			if(is_valid_ent(g_ChargerEnt[id])) {
				remove_entity(g_ChargerEnt[id]);
				g_ChargerEnt[id] = 0;
			}
		}
	} else if(g_Tank[id]) {
		--g_TankAlive;
		
		if(!g_TankAlive) {
			client_cmd(0, "mp3 stop");
			remove_task(TASK_REPEAT_SOUND_TANK);
		}
	} else if(g_Witch[id]) {
		--g_WitchAlive;
		
		if(!g_WitchAlive) {
			client_cmd(0, "mp3 stop");
			remove_task(TASK_REPEAT_SOUND_WITCH);
		}
	}
	
	if(!g_Zombie[id]) {
		new i;
		if(g_Smoker_Victim[id]) {
			for(i = 1; i <= g_MaxUsers; ++i) {
				if(!is_user_alive(i)) {
					continue;
				}
				
				if(g_Smoker[i]) {
					if(g_Smoker_Tongue[i] == id) {
						smokerTongueEnd(i);
						
						break;
					}
				}
			}
		}
		
		new iHumans = 0;
		for(i = 1; i <= g_MaxUsers; ++i) {
			if(!is_user_alive(i)) {
				continue;
			}
			
			if(i == id) {
				continue;
			}
			
			if(!g_Zombie[i]) {
				++iHumans;
			}
		}
		
		if(!iHumans && g_Team_Id > 0 && g_RoundTime > 5) {
			colorChat(0, _, "%sEl equipo actual resistió !g%d segundos!!y", TORNEO_PREFIX, g_RoundTime);
			
			new sQuery[512];
			formatex(sQuery, 511, "INSERT INTO torneozp_team (team_id, team_time, team_dmg_done, team_zk, team_zsk, team_dmg_taken, team_dmg_pistol, team_dmg_chainsaw, team_shoots, team_shootshs, team_hk, team_bk, team_sk, team_ck, team_spk, team_wk, team_tk)");
			
			new Handle:sqlQuery;
			sqlQuery = SQL_PrepareQuery(g_SqlConnection, "%s VALUES ('%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d')", sQuery, g_Team_Id, g_RoundTime, g_Team_Damage, g_Team_ZombiesKill, g_Team_ZombiesSpecialKill, g_Team_DamageReceive,
			g_Team_DamageWithPistol, g_Team_DamageWithChainsaw, g_Team_Shoots, g_Team_ShootsHS, g_Team_HuntersKill, g_Team_BoomersKill, g_Team_SmokersKill, g_Team_ChargersKill, g_Team_SpittersKill, g_Team_WitchsKill, g_Team_TanksKill);
			
			if(!SQL_Execute(sqlQuery)) {
				executeQuery(0, sqlQuery, 54);
			} else {
				SQL_FreeHandle(sqlQuery);
			}
			
			g_Team_Id = 0;
		}
	} else if(g_Smoker[id]) {
		new i;
		for(i = 1; i <= g_MaxUsers; ++i) {
			if(!is_user_alive(i)) {
				continue;
			}
			
			if(g_Zombie[i]) {
				continue;
			}
			
			if(g_Smoker_Tongue[id] == i) {
				smokerTongueEnd(id);
				
				set_user_gravity(i, 1.0);
				g_Smoker_Victim[i] = 0;
				g_Speed[i] = (!g_InAdrenaline[i]) ? 240.0 : 320.0;
				
				set_user_rendering(i);
				
				ExecuteHamB(Ham_Player_ResetMaxSpeed, i);
				
				break;
			}
		}
	}
	
	new sQuery[350];
	new vH[15];
	new vZ[15];
	
	vH[0] = g_Human_Damage[id];
	vH[1] = g_Human_ZombiesKill[id];
	vH[2] = g_Human_ZombiesSpecialKill[id];
	vH[3] = g_Human_DamageWithPistol[id];
	vH[4] = g_Human_DamageWithChainsaw[id];
	vH[5] = g_Human_Shoots[id];
	vH[6] = g_Human_ShootsHS[id];
	vH[7] = g_Human_HuntersKill[id];
	vH[8] = g_Human_BoomersKill[id];
	vH[9] = g_Human_SmokersKill[id];
	vH[10] = g_Human_ChargersKill[id];
	vH[11] = g_Human_SpittersKill[id];
	vH[12] = g_Human_WitchsKill[id];
	vH[13] = g_Human_TanksKill[id];
	vH[14] = g_Human_DamageToTank[id];
	
	vZ[0] = g_Zombie_Damage[id];
	vZ[1] = g_Zombie_HumansKill[id];
	vZ[2] = g_Zombie_HunterDamage[id];
	vZ[3] = g_Zombie_BoomerDamage[id];
	vZ[4] = g_Zombie_SmokerDamage[id];
	vZ[5] = g_Zombie_ChargerDamage[id];
	vZ[6] = g_Zombie_SpitterDamage[id];
	vZ[7] = g_Zombie_WitchDamage[id];
	vZ[8] = g_Zombie_TankDamage[id];
	vZ[9] = g_Zombie_BoomerVomitInH[id];
	vZ[10] = g_Zombie_BoomerVomitInZ[id];
	vZ[11] = g_Zombie_SmokerHumans[id]; // Mayor cantidad de humanos agarrados como Smoker.
	vZ[12] = g_Zombie_ChargerImpacts[id]; // Mayor cantidad de impactos hacia humanos como Charger.
	vZ[13] = g_Zombie_SpitterImpacts[id]; // Mayor cantidad de impactos como Spitter (a través de su charco de ácido).
	vZ[14] = g_Zombie_TankRock[id]; // Mayor cantidad de rocas acertadas como Tank.
	
	formatex(sQuery, 349, "UPDATE torneozp_users SET `hd`=`hd`+'%d', `hzk`=`hzk`+'%d', `hzsk`=`hzsk`+'%d', `hdwp`=`hdwp`+'%d', `hdwc`=`hdwc`+'%d', `hs`=`hs`+'%d', `hshs`=`hshs`+'%d', `hhk`=`hhk`+'%d', `hbk`=`hbk`+'%d', `hsk`=`hsk`+'%d', `hck`=`hck`+'%d',`hspk`=`hspk`+'%d',\
	`hwk`=`hwk`+'%d', `htk`=`htk`+'%d', `hdtt`=`hdtt`+'%d'", vH[0], vH[1], vH[2], vH[3], vH[4], vH[5], vH[6], vH[7], vH[8], vH[9], vH[10], vH[11], vH[12], vH[13], vH[14]);
	
	new Handle:sqlQuery;
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "%s,`zd`=`zd`+'%d', `zhk`=`zhk`+'%d', `zhd`=`zhd`+'%d', `zbd`=`zbd`+'%d', `zsd`=`zsd`+'%d', `zcd`=`zcd`+'%d', `zspd`=`zspd`+'%d', `zwd`=`zwd`+'%d', `ztd`=`ztd`+'%d', `zbvh`=`zbvh`+'%d', `zbvz`=`zbvz`+'%d', `zsh`=`zsh`+'%d',\
	`zci`=`zci`+'%d', `zsi`=`zsi`+'%d', `ztr`=`ztr`+'%d' WHERE zp_id='%d';", sQuery, vZ[0], vZ[1], vZ[2], vZ[3], vZ[4], vZ[5], vZ[6], vZ[7], vZ[8], vZ[9], vZ[10], vZ[11], vZ[12], vZ[13], vZ[14], g_UserId[id]);
	
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(id, sqlQuery, 52);
	} else {
		SQL_FreeHandle(sqlQuery);
	}
}

public modifCommands(const id) {
	if(!is_user_connected(id)) {
		return;
	}
	
	client_cmd(id, "cl_minmodels 0");
	
	set_lights("d");
}

public checkAccount(const id) {
	if(!is_user_connected(id)) {
		return;
	}
	
	new Handle:sqlQuery;
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT id, password, ip FROM users WHERE name = ^"%s^";", g_UserName[id]);
	
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(id, sqlQuery, 1);
	} else if(SQL_NumResults(sqlQuery)) {
		new sIP[21];
		new sDB_IP[21];
		new sPassword[32];
		
		g_UserId[id] = SQL_ReadResult(sqlQuery, 0);
		// 1 = name
		SQL_ReadResult(sqlQuery, 1, g_AccountPassword[id], 31);
		SQL_ReadResult(sqlQuery, 2, sDB_IP, 20);
		
		get_user_info(id, "zp5", sPassword, 31);
		get_user_ip(id, sIP, 20, 1);
		
		SQL_FreeHandle(sqlQuery);
		
		if(equal(sDB_IP, sIP) && equal(g_AccountPassword[id], sPassword)) {
			g_AccountLogged[id] = 1;
			showMenu__Join(id);
		} else {
			showMenu__Login(id);
		}
	} else {
		SQL_FreeHandle(sqlQuery);
		
		server_cmd("kick #%d ^"Tu cuenta no está registrada en el ZP!^"", get_user_userid(id));
		
		return;
	}
	
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT id FROM torneozp_users WHERE zp_id = '%d';", g_UserId[id]);
	
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(id, sqlQuery, 50);
	} else if(!SQL_NumResults(sqlQuery)) {
		SQL_FreeHandle(sqlQuery);
		
		sqlQuery = SQL_PrepareQuery(g_SqlConnection, "INSERT INTO torneozp_users (zp_id) VALUES ('%d')", g_UserId[id]);
	
		if(!SQL_Execute(sqlQuery)) {
			executeQuery(id, sqlQuery, 51);
		} else {
			SQL_FreeHandle(sqlQuery);
		}
	}
}

public executeQuery(const id, const Handle:query, const query_num) {
	SQL_QueryError(query, g_SqlError, 511);
	
	log_to_file("td_sql.log", "- LOG: %d - %s", query_num, g_SqlError);
	
	if(is_user_connected(id)) {
		server_cmd("kick #%d ^"Hubo un error al guardar/cargar tus datos. Intente mas tarde^"", get_user_userid(id));
	}
	
	SQL_FreeHandle(query);
}

public showMenu__Join(const id) {
	new sMenu[500];
	
	formatex(sMenu, charsmax(sMenu), "\yBienvenido al \rTORNEO ZP \y-\r L4D2^n^n\r1.\w ¡ENTRAR A JUGAR!");
	
	show_menu(id, KEYSMENU, sMenu, -1, "Menu Join");
}

public menu__Join(const id, const key) {
	if(key == 0) {
		g_AllowChangeTeam[id] = 1;
		
		g_Zombie[id] = 1;
		
		set_pdata_int(id, 125, (get_pdata_int(id, 125, OFFSET_LINUX) & ~(1<<8)), OFFSET_LINUX);
		
		engclient_cmd(id, "jointeam", "1");
		engclient_cmd(id, "joinclass", "5");
		
		g_AllowChangeTeam[id] = 0;
		
		set_task(0.5, "respawnUser", id + TASK_SPAWN);
	} else {
		showMenu__Join(id);
	}
	
	return PLUGIN_HANDLED;
}

public respawnUser(const taskid) {
	if(!is_user_connected(ID_SPAWN)) {
		return;
	}
	
	if(is_user_alive(ID_SPAWN)) {
		return;
	}
	
	if(getUserTeam(ID_SPAWN) != FM_CS_TEAM_CT && getUserTeam(ID_SPAWN) != FM_CS_TEAM_T) {
		return;
	}
	
	if(!g_ZombiesRespawn) {
		return;
	}
	
	ExecuteHamB(Ham_CS_RoundRespawn, ID_SPAWN);
}

public clcmd_Changeteam(const id) {
	if(!is_user_connected(id)) {
		return PLUGIN_HANDLED;
	}
	
	if(g_AllowChangeTeam[id]) {
		return PLUGIN_CONTINUE;
	}
	
	if(!g_AccountLogged[id]) {
		showMenu__Login(id);
		return PLUGIN_HANDLED;
	}
	
	static iTeam;
	iTeam = getUserTeam(id);
	
	if(iTeam == FM_CS_TEAM_SPECTATOR || iTeam == FM_CS_TEAM_UNASSIGNED) {
		showMenu__Join(id);
		return PLUGIN_HANDLED;
	}
	
	showMenu__Game(id);
	
	return PLUGIN_HANDLED;
}

public showMenu__Game(const id) {
	if(!is_user_connected(id))
		return;
	
	new sMenu[450];
	formatex(sMenu, 449, "\rTORNEO ZP \y- \rL4D2^n\yEstos sonidos son de prueba y duran 3 o 4 segundos!^n^n\wVOLUMEN DE SONIDOS ESPECIALES\r : \y%0.2f^n^n\r1. \wAUMENTAR VOLUMEN^n\r2. \wREDUCIR VOLUMEN^n^n\
	\r3. \wPROBAR SONIDO WITCH^n\r4. \wPROBAR SONIDO TANK^n\r5. \wPROBAR SONIDO AI^n\r6. \wPROBAR SONIDO HBV^n^n\r7. \ySI JUGÁS DESDE STEAM, PRESIONA ACÁ^n^n\r0. \wSALIR", g_Options_Volume[id]);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Game Menu");
}

public menu__Game(const id, const key) {
	if(!is_user_connected(id)) {
		return PLUGIN_HANDLED;
	}
	
	switch(key) {
		case 0: {
			g_Options_Volume[id] += 0.05;
			
			if(g_Options_Volume[id] > 1.0) {
				g_Options_Volume[id] = 1.0;
				colorChat(id, _, "%sEl volumen está al máximo, si aún escuchas bajo, prueba subir el volumen de tu !gPC!y (NO DEL CS).", TORNEO_PREFIX);
			}
		}
		case 1: {
			g_Options_Volume[id] -= 0.05;
			
			if(g_Options_Volume[id] < 0.0) {
				g_Options_Volume[id] = 0.0;
				colorChat(id, _, "%sEl volumen está al mínimo, no deberías escuchar nada (!gNO RECOMENDADO!y).", TORNEO_PREFIX);
			}
		}
		case 2: {
			if(g_TankAlive || g_WitchAlive) {
				colorChat(id, _, "%sNo podés probar estos sonidos mientras haya un !gTANK!y y/o !gWITCH!y viva.", TORNEO_PREFIX);
			} else {
				playSound(id, g_SOUND_WITCH, 1);
				
				remove_task(TASK_TEST_SOUND);
				set_task(4.0, "stopSound", id + TASK_TEST_SOUND);
			}
		}
		case 3: {
			if(g_TankAlive || g_WitchAlive) {
				colorChat(id, _, "%sNo podés probar estos sonidos mientras haya un !gTANK!y y/o !gWITCH!y viva.", TORNEO_PREFIX);
			} else {
				playSound(id, g_SOUND_TANK, 1);
				
				remove_task(TASK_TEST_SOUND);
				set_task(4.0, "stopSound", id + TASK_TEST_SOUND);
			}
		}
		case 4: {
			if(g_TankAlive || g_WitchAlive) {
				colorChat(id, _, "%sNo podés probar estos sonidos mientras haya un !gTANK!y y/o !gWITCH!y viva.", TORNEO_PREFIX);
			} else {
				playSound(id, g_SOUND_HORDE, 1);
				
				remove_task(TASK_TEST_SOUND);
				set_task(3.0, "stopSound", id + TASK_TEST_SOUND);
			}
		}
		case 5: {
			if(g_TankAlive || g_WitchAlive) {
				colorChat(id, _, "%sNo podés probar estos sonidos mientras haya un !gTANK!y y/o !gWITCH!y viva.", TORNEO_PREFIX);
			} else {
				playSound(id, g_SOUND_LOWHP, 1);
				
				remove_task(TASK_TEST_SOUND);
				set_task(4.0, "stopSound", id + TASK_TEST_SOUND);
			}
		}
		case 6: {
			if(g_SteamId[id][0] == 'S' && g_SteamId[id][1] == 'T' && g_SteamId[id][2] == 'E' && g_SteamId[id][3] == 'A' && g_SteamId[id][4] == 'M' && g_SteamId[id][5] == '_' && g_SteamId[id][6] == 'I' && g_SteamId[id][7] == 'D' && g_SteamId[id][8] == '_' && 
			g_SteamId[id][9] == 'L' && g_SteamId[id][10] == 'A' && g_SteamId[id][11] == 'N') {
				colorChat(id, _, "%sNo estás jugando desde !gSteam!y, no es necesario que hagas esto.", TORNEO_PREFIX);
			} else {
				colorChat(id, _, "%sEscribe el siguiente comando en tu consola: !gcl_filterstuffcmd 0!y", TORNEO_PREFIX);
				colorChat(id, _, "%sEste comando al desactivarlo permite que el servidor modifique tu volumen de los sonidos especiales!", TORNEO_PREFIX);
			}
		}
		case 9: {
			return PLUGIN_HANDLED;
		}
	}
	
	showMenu__Game(id);
	return PLUGIN_HANDLED;
}

public stopSound(const taskid) {
	if(is_user_connected(ID_TEST_SOUND)) {
		client_cmd(ID_TEST_SOUND, "mp3 stop");
	}
}

public showMenu__Login(const id) {
	if(!is_user_connected(id))
		return;
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, "\yBienvenido al \rTORNEO ZP \y- \rL4D2^n^n\r1. \wIDENTIFICARSE", -1, "Login Menu");
}

stock getUserTeam(const id) {
	if(pev_valid(id) != PDATA_SAFE)
		return FM_CS_TEAM_UNASSIGNED;
	
	return get_pdata_int(id, OFFSET_CSTEAMS, OFFSET_LINUX);
}

public menu__Login(const id, const key) {
	if(!is_user_connected(id) || g_AccountLogged[id]) {
		return PLUGIN_HANDLED;
	}
	
	switch(key) {
		case 0: {
			client_cmd(id, "messagemode INGRESAR_CONTRASENIA");
			
			colorChat(id, CT, "%s!tEscribe la contraseña que protege a esta cuenta!", TORNEO_PREFIX);
			return PLUGIN_HANDLED;
		}
	}
	
	showMenu__Login(id);
	return PLUGIN_HANDLED;
}

public clcmd_EnterPassword(const id) {
	if(!is_user_connected(id) || g_AccountLogged[id]) {
		return PLUGIN_HANDLED;
	}
	
	new sPassword[32];
	new sMD5_Password[34];
	
	read_args(sPassword, 31);
	remove_quotes(sPassword);
	trim(sPassword);
	
	md5(sPassword, sMD5_Password);
	sMD5_Password[6] = EOS;
	
	if(!equal(g_AccountPassword[id], sMD5_Password)) {
		showMenu__Login(id);
		
		colorChat(id, TERRORIST, "%s!tLa contraseña ingresada no coincide con la de esta cuenta!", TORNEO_PREFIX);		
		return PLUGIN_HANDLED;
	}
	
	g_AccountLogged[id] = 1;
	
	client_cmd(id, "setinfo zp5 ^"%s^"", sMD5_Password);
	
	showMenu__Join(id);
	return PLUGIN_HANDLED;
}

public concmd_L4D2Menu(const id) {
	if(!g_Kiske[id]) {
		return PLUGIN_HANDLED;
	}
	
	showMenu__L4D2Menu(id);
	
	return PLUGIN_HANDLED;
}

public showMenu__L4D2Menu(const id) {
	new sItem[32];
	new iMenu;
	
	iMenu = menu_create("L4D2 ADMINISTRACIÓN", "menu__L4D2");
	
	formatex(sItem, 31, "HUNTER \r: \y%d", g_HunterCount);
	menu_additem(iMenu, sItem, "1");
	
	formatex(sItem, 31, "BOOMER \r: \y%d", g_BoomerCount);
	menu_additem(iMenu, sItem, "2");
	
	formatex(sItem, 31, "SMOKER \r: \y%d", g_SmokerCount);
	menu_additem(iMenu, sItem, "3");
	
	formatex(sItem, 31, "SPITTER \r: \y%d", g_SpitterCount);
	menu_additem(iMenu, sItem, "4");
	
	formatex(sItem, 31, "CHARGER \r: \y%d^n", g_ChargerCount);
	menu_additem(iMenu, sItem, "5");
	
	menu_additem(iMenu, "WITCH", "6");
	menu_additem(iMenu, "TANK^n", "7");
	
	formatex(sItem, 31, "ZOMBIES REVIVEN: %s", (g_ZombiesRespawn) ? "\ySI" : "\rNO");
	menu_additem(iMenu, sItem, "8");
	
	menu_additem(iMenu, "ATAQUE INMINENTE^n", "9");
	
	menu_additem(iMenu, "SALIR", "0");
	
	menu_setprop(iMenu, MPROP_PERPAGE, 0);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenu, 0);
}

public menu__L4D2(const id, const menuId, const item) {
	if(!is_user_connected(id)) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[3];
	new iNothing;
	new iItem;
	
	menu_item_getinfo(menuId, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	iItem = str_to_num(sBuffer);
	
	DestroyLocalMenu(id, menuId);
	
	if(iItem >= 1 && iItem <= 5) {
		new iUsers[33];
		new iCount = -1;
		new iRandomUser;
		new i;
		
		for(i = 1; i <= g_MaxUsers; ++i) {
			if(!is_user_connected(i)) {
				continue;
			}
			
			if(!g_Zombie[i]) {
				continue;
			}
			
			if(g_NextZombie[i]) {
				continue;
			}
			
			if(g_Hunter[i] || g_Boomer[i] || g_Smoker[i] || g_Charger[i] || g_Spitter[i] || g_Witch[i] || g_Tank[i]) {
				continue;
			}
			
			iUsers[++iCount] = i;
		}
		
		iRandomUser = iUsers[random_num(0, iCount)];
		
		switch(iItem) {
			case 1: ++g_HunterCount;
			case 2: ++g_BoomerCount;
			case 3: ++g_SmokerCount;
			case 4: ++g_SpitterCount;
			case 5: ++g_ChargerCount;
		}
		
		g_NextZombie[iRandomUser] = iItem;
		
		showMenu__L4D2Menu(id);
		return PLUGIN_HANDLED;
	}
	
	switch(iItem) {
		case 0: return PLUGIN_HANDLED;
		// case 1: showMenu__ChooseUser(id, ZOMBIE_HUNTER);
		// case 2: showMenu__ChooseUser(id, ZOMBIE_BOOMER);
		// case 3: showMenu__ChooseUser(id, ZOMBIE_SMOKER);
		// case 4: showMenu__ChooseUser(id, ZOMBIE_SPITTER);
		// case 5: showMenu__ChooseUser(id, ZOMBIE_CHARGER);
		case 6: showMenu__ChooseUser(id, ZOMBIE_WITCH);
		case 7: showMenu__ChooseUser(id, ZOMBIE_TANK);
		case 8: {
			g_ZombiesRespawn = !g_ZombiesRespawn;
			
			if(g_ZombiesRespawn) {
				new i;
				for(i = 1; i <= g_MaxUsers; ++i) {
					if(is_user_connected(i) && !is_user_alive(i) && g_Zombie[i]) {
						set_task(1.0, "respawnUser", i + TASK_SPAWN);
					}
				}
			}
			
			showMenu__L4D2Menu(id);
		}
		case 9: {
			new iCountDead = 0;
			new i;
			
			for(i = 1; i <= g_MaxUsers; ++i) {
				if(is_user_connected(i) && !is_user_alive(i)) {
					++iCountDead;
				}
			}
			
			if(iCountDead >= 1) {
				g_ZombiesRespawn = 1;
				
				for(i = 1; i <= g_MaxUsers; ++i) {
					if(is_user_connected(i) && !is_user_alive(i) && g_Zombie[i]) {
						set_task(2.8, "respawnUser", i + TASK_SPAWN);
					}
				}
				
				colorChat(0, TERRORIST, "!g[!yAtaque Inminente!g]!y");
				
				playSound(0, g_SOUND_HORDE, 1);
			}
		}
	}
	
	return PLUGIN_HANDLED;
}

public playSound(const id, const sSound[], const iMp3) {
	if(iMp3) {
		if(!id) {
			new i;
			for(i = 1; i <= g_MaxUsers; ++i) {
				if(is_user_connected(i)) {
					client_cmd(i, "MP3Volume %f", g_Options_Volume[i]);
				}
			}
		} else {
			client_cmd(id, "MP3Volume %f", g_Options_Volume[id]);
		}
		
		client_cmd(id, "mp3 play %s", sSound);
	} else {
		client_cmd(id, "spk %s", sSound);
	}
}

public showMenu__ChooseUser(const id, const iMode) {
	if(!is_user_connected(id)) {
		return;
	}
	
	g_MenuUsersMode = iMode;
	
	new sItem[64];
	new sPosition[2];
	new iMenuId;
	new i;
	
	switch(iMode) {
		case ZOMBIE_HUNTER: iMenuId = menu_create("HUNTER", "menu__ChooseUsers");
		case ZOMBIE_BOOMER: iMenuId = menu_create("BOOMER", "menu__ChooseUsers");
		case ZOMBIE_SMOKER: iMenuId = menu_create("SMOKER", "menu__ChooseUsers");
		case ZOMBIE_SPITTER: iMenuId = menu_create("SPITTER", "menu__ChooseUsers");
		case ZOMBIE_CHARGER: iMenuId = menu_create("CHARGER", "menu__ChooseUsers");
		case ZOMBIE_WITCH: iMenuId = menu_create("WITCH", "menu__ChooseUsers");
		case ZOMBIE_TANK: iMenuId = menu_create("TANK", "menu__ChooseUsers");
	}
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(!is_user_connected(i)) {
			continue;
		}
		
		if(!g_Zombie[i]) {
			continue;
		}
		
		formatex(sItem, 63, "%s \y[%d]", g_UserName[i], g_ZombiesCount[i]);
		
		sPosition[0] = i;
		sPosition[1] = 0;
		
		menu_additem(iMenuId, sItem, sPosition);
	}
	
	if(menu_items(iMenuId) <= 0) {
		colorChat(id, _, "%sNo hay usuarios disponibles para mostrar en el menú.", TORNEO_PREFIX);
		
		DestroyLocalMenu(id, iMenuId);
		return;
	}
	
	menu_setprop(iMenuId, MPROP_NEXTNAME, "SIGUIENTE");
	menu_setprop(iMenuId, MPROP_BACKNAME, "ATRÁS");
	menu_setprop(iMenuId, MPROP_EXITNAME, "SALIR");
	
	g_MenuPage_Users = min(g_MenuPage_Users, menu_pages(iMenuId) - 1);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, g_MenuPage_Users);
}

public menu__ChooseUsers(const id, const menuid, const item) {
	if(!is_user_connected(id)) {
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	new iNothing;
	player_menu_info(id, iNothing, iNothing, g_MenuPage_Users);
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuid);
		
		showMenu__L4D2Menu(id);
		return PLUGIN_HANDLED;
	}
	
	new sItem[2];
	new iUser;
	
	menu_item_getinfo(menuid, item, iNothing, sItem, charsmax(sItem), _, _, iNothing);
	iUser = sItem[0];
	
	if(is_user_connected(iUser)) {
		g_NextZombie[iUser] = g_MenuUsersMode;
	} else {
		colorChat(id, _, "%sEl usuario seleccionado se ha desconectado.", TORNEO_PREFIX);
	}
	
	DestroyLocalMenu(id, menuid);
	
	showMenu__ChooseUser(id, g_MenuUsersMode);
	return PLUGIN_HANDLED;
}

public fw_PlayerSpawn_Post(const id) {
	if(!is_user_alive(id)) {
		return;
	}
	
	remove_task(id + TASK_SPAWN);
	remove_task(id + TASK_MODEL);
	remove_task(id + TASK_SOUND);
	
	clearWeapons(id);
	
	if(!g_AccountLogged[id]) {
		user_silentkill(id);
		colorChat(id, _, "%sDebes !gIDENTIFICARTE!y para poder jugar. Presiona la !gtecla M!y si no aparece ningún menú.", TORNEO_PREFIX);
		
		return;
	}
	
	set_task(0.4, "hideHUDs", id + TASK_SPAWN);
	
	set_user_rendering(id);
	cs_set_user_money(id, 0, 0);
	
	new iTeam;
	iTeam = getUserTeam(id);
	
	resetVars(id);
	
	if(g_Zombie[id]) {
		if(iTeam != FM_CS_TEAM_T) {
			setUserTeam(id, FM_CS_TEAM_T);
		}
		
		// if(g_RoundStart && g_NextZombie[id] < ZOMBIE_WITCH && g_SetRespawnCount > 0) {
			// new iHull;
			// new iOk = 0;
			// new i;
			
			// iHull = (get_entity_flags(id) & FL_DUCKING) ? HULL_HEAD : HULL_HUMAN;
			
			// for(i = g_RespawnCount; i < g_SetRespawnCount; ++i) {
				// if(isHullVacant(g_RespawnOrigin[i], iHull)) {
					// entity_set_vector(id, EV_VEC_velocity, Float:{0.0, 0.0, 0.0});
					// entity_set_vector(id, EV_VEC_origin, g_RespawnOrigin[i]);
					
					// if(!isUserStuck(id, g_RespawnOrigin[i])) {
						// ++g_RespawnCount;
						
						// if(g_RespawnCount == 512) {
							// g_RespawnCount = 0;
						// }
						
						// iOk = 1;
						
						// break;
					// }
				// }
			// }
			
			// if(!iOk) {
				// g_ZombiesRespawn = 0;
				
				// set_task(0.3, "delayKill", id);
				
				// return;
			// }
		// }
		
		if(g_RESPAWN_PHASE >= 0) {
			if(g_NextZombie[id] < ZOMBIE_WITCH) {
				new iHull;
				new i;
				
				iHull = (get_entity_flags(id) & FL_DUCKING) ? HULL_HEAD : HULL_HUMAN;
				
				for(i = g_RespawnCount; i < 47; ++i) {
					if(isHullVacant(g_RESPAWN_ORIGIN[g_RESPAWN_PHASE][i], iHull)) {
						entity_set_vector(id, EV_VEC_velocity, Float:{0.0, 0.0, 0.0});
						entity_set_vector(id, EV_VEC_origin, g_RESPAWN_ORIGIN[g_RESPAWN_PHASE][i]);
						
						if(!isUserStuck(id, g_RESPAWN_ORIGIN[g_RESPAWN_PHASE][i])) {							
							++g_RespawnCount;
							
							if(g_RespawnCount == 47) {
								g_RespawnCount = 0;
							}
							
							break;
						}
					}
				}
			} else {
				entity_set_vector(id, EV_VEC_velocity, Float:{0.0, 0.0, 0.0});
				entity_set_vector(id, EV_VEC_origin, g_SpecialRespawnOrigin);
			}
		}
		
		if(g_NextZombie[id]) {
			new iHealth;
			new Float:flGravity;
			new iArmor;
			new sModel[32];
			
			flGravity = 1.0;
			iArmor = 0;
			
			++g_ZombiesCountSpecial[g_NextZombie[id]];
			++g_ZombiesCount[id];
			
			switch(g_NextZombie[id]) {
				case ZOMBIE_HUNTER: {
					g_Hunter[id] = 1;
					
					iHealth = 500 + g_ExtraHealth;
					flGravity = 0.75;
					iArmor = 10;
					g_Speed[id] = 260.0;
					
					formatex(sModel, 31, "%s", g_MODEL_HUNTER);
					
					set_dhudmessage(255, 0, 0, -1.0, 0.3, 0, 0.0, 4.9, 1.0, 1.0);
					show_dhudmessage(id, "¡ SOS UN HUNTER !");
					
					set_task(0.3, "giveLongJump", id);
					
					colorChat(id, _, "%sUtiliza la combinación !g+DUCK!y + !g+JUMP!y para realizar tu salto largo!", TORNEO_PREFIX);
					
					set_task(random_float(4.0, 5.0), "playSoundHunter", id + TASK_SOUND, _, _, "b");
				}
				case ZOMBIE_BOOMER: {
					g_Boomer[id] = 1;
					
					iHealth = 50 + g_ExtraHealth;
					g_Speed[id] = 210.0;
					
					formatex(sModel, 31, "%s", g_MODEL_BOOMER);
					
					set_dhudmessage(0, 255, 0, -1.0, 0.3, 0, 0.0, 4.9, 1.0, 1.0);
					show_dhudmessage(id, "¡ SOS UN BOOMER !");
					
					colorChat(id, _, "%sPresioná la !gtecla F!y para vomitar!", TORNEO_PREFIX);
					
					set_task(random_float(4.0, 5.0), "playSoundBoomer", id + TASK_SOUND, _, _, "b");
				}
				case ZOMBIE_SMOKER: {
					emit_sound(id, CHAN_VOICE, g_SOUND_SMOKER_RESPAWN, 1.0, ATTN_NORM, 0, PITCH_NORM);
					
					g_Smoker[id] = 1;
					
					iHealth = 200 + g_ExtraHealth;
					iArmor = 5;
					g_Speed[id] = 225.0;
					
					formatex(sModel, 31, "%s", g_MODEL_SMOKER);
					
					set_dhudmessage(255, 255, 255, -1.0, 0.3, 0, 0.0, 4.9, 1.0, 1.0);
					show_dhudmessage(id, "¡ SOS UN SMOKER !");
					
					colorChat(id, _, "%sPresioná la !gtecla F!y para lanzar tu lengua y atrapar a un humano!", TORNEO_PREFIX);
					
					set_task(random_float(4.0, 5.0), "playSoundSmoker", id + TASK_SOUND, _, _, "b");
				}
				case ZOMBIE_SPITTER: {
					g_Spitter[id] = 1;
					
					iHealth = 200 + g_ExtraHealth;
					g_Speed[id] = 250.0;
					
					formatex(sModel, 31, "%s", g_MODEL_SPITTER);
					
					set_dhudmessage(0, 255, 0, -1.0, 0.3, 0, 0.0, 4.9, 1.0, 1.0);
					show_dhudmessage(id, "¡ SOS UNA SPITTER !");
					
					colorChat(id, _, "%sPresioná la !gtecla F!y para escupir ácido!", TORNEO_PREFIX);
					
					set_task(random_float(4.0, 5.0), "playSoundSpitter", id + TASK_SOUND, _, _, "b");
				}
				case ZOMBIE_CHARGER: {
					emit_sound(id, CHAN_VOICE, g_SOUND_CHARGER_RESPAWN[random_num(0, charsmax(g_SOUND_CHARGER_RESPAWN))], 1.0, ATTN_NORM, 0, PITCH_NORM);
					
					g_Charger[id] = 1;
					
					iHealth = 400 + g_ExtraHealth;
					g_Speed[id] = 250.0;
					
					formatex(sModel, 31, "%s", g_MODEL_CHARGER);
					
					set_dhudmessage(255, 0, 0, -1.0, 0.3, 0, 0.0, 4.9, 1.0, 1.0);
					show_dhudmessage(id, "¡ SOS UN CHARGER !");
					
					colorChat(id, _, "%sPresioná la !gtecla F!y para cargar contra un humano, o zombie!", TORNEO_PREFIX);
					
					set_task(random_float(8.0, 10.0), "playSoundCharger", id + TASK_SOUND, _, _, "b");
				}
				case ZOMBIE_WITCH: {
					g_Witch[id] = 1;
					g_AngryWitch[id] = 0;
					
					++g_WitchAlive;
					
					iHealth = 2500 + g_ExtraHealth;
					flGravity = 0.75;
					iArmor = 0;
					g_Speed[id] = 50.0;
					
					formatex(sModel, 31, "%s", g_MODEL_WITCH);
					
					set_dhudmessage(255, 0, 0, -1.0, 0.3, 0, 0.0, 4.9, 1.0, 1.0);
					show_dhudmessage(id, "¡ SOS UNA WITCH !");
					
					set_user_rendering(id, kRenderFxGlowShell, 255, 255, 255, kRenderNormal, 4);
					
					colorChat(id, _, "%sLa furia de la !gWITCH!y se activa cuando alguien se acerca mucho o recibes daño!", TORNEO_PREFIX);
					colorChat(id, _, "%sSi nadie te realiza daño durante un tiempo prolongado, se activará automáticamente!", TORNEO_PREFIX);
					
					remove_task(id + TASK_AURA);
					set_task(0.1, "witchAura", id + TASK_AURA, _, _, "b");
					
					set_task(random_float(4.0, 5.0), "playSoundWitch", id + TASK_SOUND, _, _, "b");
				}
				case ZOMBIE_TANK: {
					g_Tank[id] = 1;
					
					++g_TankAlive;
					
					iHealth = 10000 + g_ExtraHealth;
					iArmor = 200;
					g_Speed[id] = 300.0;
					flGravity = 0.85;
					
					formatex(sModel, 31, "%s", g_MODEL_TANK);
					
					entity_set_int(id, EV_INT_skin, 1);
					
					setModelIndex(id, g_ModelIndex_Tank);
					
					if(g_TankAlive > 1) {
						new i;
						for(i = 0; i < 8; ++i) {
							set_dhudmessage(0, 0, 0, -1.0, 0.2, 0, 0.0, 0.1, 0.1, 0.1);
							show_dhudmessage(0, "");
						}
					}
					
					set_dhudmessage(255, 0, 0, -1.0, 0.3, 0, 0.0, 4.9, 1.0, 1.0);
					show_dhudmessage(0, "¡ %s ES TANK !", g_UserName[id]);
					
					colorChat(id, _, "%sPresioná la !gtecla F!y para lanzar tu roca e intenta noquear a un humano!", TORNEO_PREFIX);
					
					playSound(0, g_SOUND_TANK, 1);
					
					remove_task(TASK_REPEAT_SOUND_TANK);
					set_task(51.5, "repeatTankSound", TASK_REPEAT_SOUND_TANK);
				}
			}
			
			set_user_health(id, iHealth);
			set_user_gravity(id, flGravity);
			set_user_armor(id, iArmor);
			
			copy(g_UserModel[id], 31, sModel);
			
			g_NextZombie[id] = 0;
		} else {
			set_user_health(id, 100 + g_ExtraHealth);
			set_user_gravity(id, 1.0);
			set_user_armor(id, 0);
			
			g_Speed[id] = 240.0;
			
			copy(g_UserModel[id], 31, g_MODELS_ZOMBIES[random_num(0, charsmax(g_MODELS_ZOMBIES))]);
		}
		
		set_task(random_float(0.5, 1.0), "modelUpdate", id + TASK_MODEL);
	} else {
		set_user_health(id, 30000);
		set_user_gravity(id, 1.0);
		
		g_Speed[id] = 240.0;
		
		if(iTeam != FM_CS_TEAM_CT) {
			setUserTeam(id, FM_CS_TEAM_CT);
		}
		
		if(g_HumanModel >= 4) {
			g_HumanModel = 0;
		}
		
		copy(g_UserModel[id], 31, g_MODELS_HUMANS[g_HumanModel]);
		
		++g_HumanModel;
		
		set_task(5.0, "modelUpdate", id + TASK_MODEL);
	}
	
	ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
	
	new iWeaponEnt;
	iWeaponEnt = getCurrentWeaponEnt(id);
	
	if(is_valid_ent(iWeaponEnt)) {
		replaceWeaponModels(id, cs_get_weapon_id(iWeaponEnt));
	}
}

public witchAura(const taskid) {
	if(!g_Witch[ID_AURA]) {
		remove_task(taskid);
		return;
	}
	
	static vecOrigin[3];
	get_user_origin(ID_AURA, vecOrigin);
	
	message_begin(MSG_PVS, SVC_TEMPENTITY, vecOrigin);
	write_byte(TE_DLIGHT);
	write_coord(vecOrigin[0]);
	write_coord(vecOrigin[1]);
	write_coord(vecOrigin[2]);
	write_byte(20);
	write_byte(255);
	write_byte(255);
	write_byte(255);
	write_byte(2);
	write_byte(0);
	message_end();
}

public witchAngryAura(const taskid) {
	if(!g_AngryWitch[ID_AURA]) {
		remove_task(taskid);
		return;
	}
	
	static vecOrigin[3];
	get_user_origin(ID_AURA, vecOrigin);
	
	message_begin(MSG_PVS, SVC_TEMPENTITY, vecOrigin);
	write_byte(TE_DLIGHT);
	write_coord(vecOrigin[0]);
	write_coord(vecOrigin[1]);
	write_coord(vecOrigin[2]);
	write_byte(20);
	write_byte(255);
	write_byte(0);
	write_byte(0);
	write_byte(2);
	write_byte(0);
	message_end();
}

public repeatTankSound() {
	if(g_TankAlive) {
		playSound(0, g_SOUND_TANK, 1);
		
		remove_task(TASK_REPEAT_SOUND_TANK);
		set_task(51.5, "repeatTankSound", TASK_REPEAT_SOUND_TANK);
	}
}

public repeatWitchSound() {
	if(g_WitchAlive && !g_TankAlive) {
		playSound(0, g_SOUND_WITCH, 1);
		
		remove_task(TASK_REPEAT_SOUND_WITCH);
		set_task(30.5, "repeatWitchSound", TASK_REPEAT_SOUND_WITCH);
	}
}

stock clearWeapons(const id) {
	if(!is_user_alive(id)) {
		return;
	}
	
	strip_user_weapons(id);
	set_pdata_int(id, OFFSET_PRIMARY_WEAPON, OFFSET_LINUX);
	
	give_item(id, "weapon_knife");
}

stock setUserTeam(const id, const team) {
	if(pev_valid(id) != PDATA_SAFE)
		return;
	
	set_pdata_int(id, OFFSET_CSTEAMS, team, OFFSET_LINUX);
}

public resetVars(const id) {
	g_Hunter[id] = 0;
	g_Boomer[id] = 0;
	g_Smoker[id] = 0;
	g_Spitter[id] = 0;
	g_Charger[id] = 0;
	g_Witch[id] = 0;
	g_Tank[id] = 0;
}

public playSoundHunter(taskid) {
	emit_sound(ID_SOUND, CHAN_VOICE, g_SOUND_HUNTER_ALERT[random_num(0, charsmax(g_SOUND_HUNTER_ALERT))], 1.0, ATTN_NORM, 0, PITCH_NORM);
}

public playSoundBoomer(taskid) {
	emit_sound(ID_SOUND, CHAN_VOICE, g_SOUND_BOOMER_ALERT[random_num(0, charsmax(g_SOUND_BOOMER_ALERT))], 1.0, ATTN_NORM, 0, PITCH_NORM);
}

public playSoundSmoker(taskid) {
	emit_sound(ID_SOUND, CHAN_VOICE, g_SOUND_SMOKER_ALERT[random_num(0, charsmax(g_SOUND_SMOKER_ALERT))], 1.0, ATTN_NORM, 0, PITCH_NORM);
}

public playSoundSpitter(taskid) {
	emit_sound(ID_SOUND, CHAN_VOICE, g_SOUND_SPITTER_ALERT[random_num(0, charsmax(g_SOUND_SPITTER_ALERT))], 1.0, ATTN_NORM, 0, PITCH_NORM);
}

public playSoundCharger(taskid) {
	emit_sound(ID_SOUND, CHAN_VOICE, g_SOUND_CHARGER_ALERT[random_num(0, charsmax(g_SOUND_CHARGER_ALERT))], 1.0, ATTN_NORM, 0, PITCH_NORM);
}

public playSoundWitch(taskid) {
	emit_sound(ID_SOUND, CHAN_VOICE, g_SOUND_WITCH_ALERT[random_num(0, charsmax(g_SOUND_WITCH_ALERT))], 1.0, ATTN_NORM, 0, PITCH_NORM);
}

public impulse_Flashlight(const id) {
	// if(!is_user_alive(id)) {
		// if(g_Kiske[id]) {
			// entity_get_vector(id, EV_VEC_origin, g_RespawnOrigin[g_SetRespawnCount]);
			
			// client_print(id, print_center, "RESPAWN #%d", g_SetRespawnCount);
			
			// ++g_SetRespawnCount;
			
			// if(g_SetRespawnCount == 512) {
				// g_SetRespawnCount = 0;
			// }
		// }
		
		// return PLUGIN_HANDLED;
	// }
	
	if(g_Boomer[id]) {
		new Float:flGameTime;
		flGameTime = get_gametime()
		
		if(g_BoomerVomit[id] > flGameTime) {
			colorChat(id, _, "%sTenés que esperar !g%0.2f!y segundos para volver a vomitar!", TORNEO_PREFIX, (g_BoomerVomit[id] - flGameTime));
			return PLUGIN_HANDLED;
		}
		
		g_BoomerVomit[id] = flGameTime + 15.0;
		
		new iTarget;
		new iBody;
		new iOrigin[3];
		new iAimOrigin[3];
		new iVelocityVector[3];
		
		get_user_aiming(id, iTarget, iBody, 500);
		
		get_user_origin(id, iOrigin);
		get_user_origin(id, iAimOrigin, 2);
		
		iVelocityVector[0] = iAimOrigin[0] - iOrigin[0];
		iVelocityVector[1] = iAimOrigin[1] - iOrigin[1];
		iVelocityVector[2] = iAimOrigin[2] - iOrigin[2];
		
		new iNum = ((iVelocityVector[0] * iVelocityVector[0]) + (iVelocityVector[1] * iVelocityVector[1]) + (iVelocityVector[2] * iVelocityVector[2]));
		new iDiv = iNum;
		new iResult = 1;
		
		while(iDiv > iResult) {
			iDiv = (iDiv + iResult) / 2;
			iResult = iNum / iDiv;
		}
		
		new const iLenght = iDiv;
		
		iVelocityVector[0] = (iVelocityVector[0] * 10) / iLenght;
		iVelocityVector[1] = (iVelocityVector[1] * 10) / iLenght;
		iVelocityVector[2] = (iVelocityVector[2] * 10) / iLenght;
		
		new iArgs[6];
		
		iArgs[0] = iOrigin[0];
		iArgs[1] = iOrigin[1];
		iArgs[2] = iOrigin[2];
		iArgs[3] = iVelocityVector[0];
		iArgs[4] = iVelocityVector[1];
		iArgs[5] = iVelocityVector[2];

		set_task(0.1, "createBoomerSprite", 0, iArgs, 6, "a", 4);
		
		emit_sound(id, CHAN_BODY, g_SOUND_BOOMER_VOMIT[random_num(0, 2)], 1.0, ATTN_NORM, 0, PITCH_HIGH);
		
		message_begin(MSG_ONE_UNRELIABLE, g_Message_ScreenShake, _, id);
		write_short(UNIT_SECOND * 14);
		write_short(UNIT_SECOND * 4);
		write_short(UNIT_SECOND * 14);
		message_end();
		
		g_Speed[id] = 1.0;
		ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
		
		set_task(0.7, "moveBoomerAgain", id);
		
		if(is_user_alive(iTarget)) {
			if(!g_Zombie[iTarget]) {
				message_begin(MSG_ONE_UNRELIABLE, g_Message_ScreenFade, _, iTarget);
				write_short(UNIT_SECOND * 6);
				write_short(UNIT_SECOND * 6);
				write_short(0x0000);
				write_byte(79);
				write_byte(180);
				write_byte(61);
				write_byte(255);
				message_end();
				
				message_begin(MSG_ONE_UNRELIABLE, g_Message_ScreenShake, _, iTarget);
				write_short(UNIT_SECOND * 14);
				write_short(UNIT_SECOND * 4);
				write_short(UNIT_SECOND * 14);
				message_end();
				
				set_user_rendering(iTarget, kRenderFxGlowShell, 79, 180, 61, kRenderNormal, 4);
				
				emit_sound(id, CHAN_STREAM, g_SOUND_SCARE, 0.6, ATTN_NORM, 0, PITCH_NORM);
				
				set_task(6.0, "removeGlow", iTarget);
				
				set_user_health(id, get_user_health(id) + 100);
				
				++g_Zombie_BoomerVomitInH[id];
			} else {
				++g_Zombie_BoomerVomitInZ[id];
			}
		}
	} else if(g_Smoker[id]) {
		new Float:flGameTime;
		flGameTime = get_gametime()
		
		if(g_SmokerTongue[id] > flGameTime) {
			colorChat(id, _, "%sTenés que esperar !g%0.2f!y segundos para volver a lanzar tu lengua!", TORNEO_PREFIX, (g_SmokerTongue[id] - flGameTime));
			return PLUGIN_HANDLED;
		}
		
		g_SmokerTongue[id] = flGameTime + 15.0;
		
		new iTarget;
		new iBody;
		
		get_user_aiming(id, iTarget, iBody, 800);
		
		if(is_user_alive(iTarget)) {
			if(g_Zombie[iTarget] || g_Smoker_Victim[iTarget] || g_InAdrenaline[iTarget]) {
				g_Speed[id] = 1.0;
				ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
				
				g_Smoker_Tongue[id] = 0;
				
				smokerNoTarget(id);
				
				set_task(0.7, "moveSmokerAgain", id);
				
				emit_sound(id, CHAN_BODY, g_SOUND_SMOKER_TONGUE_MISS, 1.0, ATTN_NORM, 0, PITCH_HIGH);
			
				return PLUGIN_HANDLED;
			}
			
			emit_sound(iTarget, CHAN_BODY, g_SOUND_SMOKER_TONGUE_HIT, 1.0, ATTN_NORM, 0, PITCH_HIGH);
			
			g_Smoker_Tongue[id] = iTarget;
			g_Smoker_Victim[iTarget] = 1;
			++g_Zombie_SmokerHumans[id];
			
			new iArgs[2];
			
			iArgs[0] = id;
			iArgs[1] = iTarget;
			
			set_task(0.1, "smokerAttract", id, iArgs, 2, "b");
			dragTarget(iArgs);
			
			set_user_gravity(iTarget, 9999.9);
			
			emit_sound(iTarget, CHAN_STREAM, g_SOUND_SCARE, 0.6, ATTN_NORM, 0, PITCH_NORM);
			
			set_user_rendering(iTarget, kRenderFxGlowShell, 255, 255, 0, kRenderNormal, 4);
			
			g_Speed[iTarget] = 1.0;
			g_Speed[id] = 1.0;
			
			ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
			ExecuteHamB(Ham_Player_ResetMaxSpeed, iTarget);
		} else {
			g_Smoker_Tongue[id] = 0;
			
			g_Speed[id] = 1.0;
			ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
			
			smokerNoTarget(id);
			
			set_task(0.7, "moveSmokerAgain", id);
			
			emit_sound(id, CHAN_BODY, g_SOUND_SMOKER_TONGUE_MISS, 1.0, ATTN_NORM, 0, PITCH_HIGH);
		}
	} else if(g_Spitter[id]) {
		new Float:flGameTime;
		flGameTime = get_gametime()
		
		if(g_SpitterAcid[id] > flGameTime) {
			colorChat(id, _, "%sTenés que esperar !g%0.2f!y segundos para volver a escupir ácido!", TORNEO_PREFIX, (g_SpitterAcid[id] - flGameTime));
			return PLUGIN_HANDLED;
		}
		
		g_SpitterAcid[id] = flGameTime + 15.0;
		
		g_Speed[id] = 1.0;
		ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
		
		emit_sound(id, CHAN_BODY, g_SOUND_SPITTER_ACID_INIT, 1.0, ATTN_NORM, 0, PITCH_NORM);
		
		new Float:vecViewOffset[3];
		new Float:vecVelocity[3];
		new sArgs[6];
		
		entity_get_vector(id, EV_VEC_view_ofs, vecViewOffset);
		velocity_by_aim(id, 1200, vecVelocity);
		
		sArgs[0] = floatround(vecViewOffset[0]);
		sArgs[1] = floatround(vecViewOffset[1]);
		sArgs[2] = floatround(vecViewOffset[2]);
		
		sArgs[3] = floatround(vecVelocity[0]);
		sArgs[4] = floatround(vecVelocity[1]);
		sArgs[5] = floatround(vecVelocity[2]);
		
		set_task(0.5, "spitterBall", id, sArgs, 6);
	} else if(g_Charger[id]) {
		new iFlags = entity_get_int(id, EV_INT_flags);
		if((iFlags & (FL_ONGROUND | FL_PARTIALGROUND | FL_INWATER | FL_CONVEYOR | FL_FLOAT)) && !(entity_get_int(id, EV_INT_bInDuck)) && !(iFlags & FL_DUCKING)) {
			new Float:flGameTime;
			flGameTime = get_gametime()
			
			if(g_ChargerCharge[id] > flGameTime) {
				colorChat(id, _, "!g[ZP]!y You need to wait !g%0.2f!y seconds!", (g_ChargerCharge[id] - flGameTime));
				return PLUGIN_HANDLED;
			}
			
			g_ChargerCharge[id] = flGameTime + 15.0;
			
			remove_task(id + TASK_SOUND);
			
			g_ChargerCountFix[id] = 0;
			
			set_user_gravity(id, 100.0);
			
			entity_get_vector(id, EV_VEC_v_angle, g_ChargerAngles[id]);
			g_ChargerAngles[id][0] = 0.0;
			
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
			write_byte(TE_BEAMFOLLOW);
			write_short(id);
			write_short(g_SPRITE_TRAIL);
			write_byte(25);
			write_byte(4);
			write_byte(255);
			write_byte(0);
			write_byte(0);
			write_byte(255);
			message_end();
			
			g_ChargerEnt[id] = create_entity("trigger_camera");
			
			if(is_valid_ent(g_ChargerEnt[id])) {
				emit_sound(id, CHAN_BODY, g_SOUND_CHARGER_CHARGE[random_num(0, charsmax(g_SOUND_CHARGER_CHARGE))], 1.0, ATTN_NORM, 0, PITCH_NORM);
				
				set_kvd(0, KV_ClassName, "trigger_camera");
				set_kvd(0, KV_fHandled, 0);
				set_kvd(0, KV_KeyName, "wait");
				set_kvd(0, KV_Value, "999999");
				dllfunc(DLLFunc_KeyValue, g_ChargerEnt[id], 0);
				
				entity_set_int(g_ChargerEnt[id], EV_INT_spawnflags, SF_CAMERA_PLAYER_TARGET|SF_CAMERA_PLAYER_POSITION);
				entity_set_int(g_ChargerEnt[id], EV_INT_flags, entity_get_int(g_ChargerEnt[id], EV_INT_flags) | FL_ALWAYSTHINK);
				
				DispatchSpawn(g_ChargerEnt[id]);
				
				g_ChargerInCamera[id] = 1;
				
				ExecuteHam(Ham_Use, g_ChargerEnt[id], id, id, 3, 1.0);
			}
		} else {
			colorChat(id, _, "!g[ZP]!y You have to stand on the ground!");
		}
	} else if(g_Tank[id]) {
		new Float:flGameTime;
		flGameTime = get_gametime()
		
		if(g_TankRock[id] > flGameTime) {
			colorChat(id, _, "%sTenés que esperar !g%0.2f!y segundos para volver a lanzar una roca!", TORNEO_PREFIX, (g_TankRock[id] - flGameTime));
			return PLUGIN_HANDLED;
		}
		
		g_TankRock[id] = flGameTime + 8.0;
		
		emit_sound(id, CHAN_BODY, g_SOUND_TANK_ROCK, 1.0, ATTN_NORM, 0, PITCH_NORM);
		
		new Float:vecOrigin[3];
		new Float:vecVelocity[3];
		new Float:vecAngle[3];
		
		entity_get_vector(id, EV_VEC_origin, vecOrigin);
		entity_get_vector(id, EV_VEC_v_angle, vecAngle);
		
		new iEnt = create_entity("info_target");
		
		if(is_valid_ent(iEnt)) {
			entity_set_string(iEnt, EV_SZ_classname, "entRockTank");
			entity_set_model(iEnt, g_MODEL_TANK_ROCK);
			entity_set_size(iEnt, Float:{-25.0, -20.0, -15.0}, Float:{25.0, 20.0, 15.0});
			
			entity_set_origin(iEnt, vecOrigin);
			entity_set_vector(iEnt, EV_VEC_angles, vecAngle);
			
			entity_set_int(iEnt, EV_INT_solid, SOLID_BBOX);
			entity_set_int(iEnt, EV_INT_movetype, MOVETYPE_TOSS);
			
			entity_set_edict(iEnt, EV_ENT_owner, id);
			
			velocity_by_aim(id, 2000, vecVelocity);
			entity_set_vector(iEnt, EV_VEC_velocity, vecVelocity);
			
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
			write_byte(TE_BEAMFOLLOW);
			write_short(iEnt);
			write_short(g_SPRITE_TRAIL);
			write_byte(17);
			write_byte(15);
			write_byte(255);
			write_byte(0);
			write_byte(0);
			write_byte(255);
			message_end();
		}
	}
	
	return PLUGIN_HANDLED;
}

public impulse_Spray() {
	return PLUGIN_HANDLED;
}

public modelUpdate(const taskid) {
	static Float:flCurrentTime;
	flCurrentTime = get_gametime();
	
	if((flCurrentTime - g_ModelsTargetTime) >= 0.5) {
		setUserModel(taskid);
		g_ModelsTargetTime = flCurrentTime;
	} else {
		set_task((g_ModelsTargetTime + 0.5) - flCurrentTime, "setUserModel", taskid);
		g_ModelsTargetTime += 0.5;
	}
}

public setUserModel(const taskid) {
	set_user_info(ID_MODEL, "model", g_UserModel[ID_MODEL]);
}

replaceWeaponModels(const id, const weaponid) {
	switch(weaponid) {
		case CSW_KNIFE: {
			if(g_Zombie[id]) {
				if(!g_Hunter[id] && !g_Boomer[id] && !g_Smoker[id] && !g_Spitter[id] && !g_Charger[id] && !g_Witch[id] && !g_Tank[id]) {
					entity_set_string(id, EV_SZ_viewmodel, g_MODELS_ZOMBIE_CLAWS[random_num(0, charsmax(g_MODELS_ZOMBIE_CLAWS))]);
				} else if(g_Hunter[id]) {
					entity_set_string(id, EV_SZ_viewmodel, g_MODEL_CLAW_HUNTER);
				} else if(g_Boomer[id]) {
					entity_set_string(id, EV_SZ_viewmodel, g_MODEL_CLAW_BOOMER);
				} else if(g_Smoker[id]) {
					entity_set_string(id, EV_SZ_viewmodel, g_MODEL_CLAW_SMOKER);
				} else if(g_Spitter[id]) {
					entity_set_string(id, EV_SZ_viewmodel, g_MODEL_CLAW_SPITTER);
				} else if(g_Charger[id]) {
					entity_set_string(id, EV_SZ_viewmodel, g_MODEL_CLAW_CHARGER);
				} else if(g_Witch[id]) {
					entity_set_string(id, EV_SZ_viewmodel, g_MODEL_CLAW_WITCH);
				} else if(g_Tank[id]) {
					entity_set_string(id, EV_SZ_viewmodel, g_MODEL_CLAW_TANK);
				}
				
				entity_set_string(id, EV_SZ_weaponmodel, "");
			} else {
				if(g_Chainsaw[id]) {
					entity_set_string(id, EV_SZ_viewmodel, g_MODEL_V_CHAINSAW);
					entity_set_string(id, EV_SZ_weaponmodel, g_MODEL_P_CHAINSAW);
				}
			}
		}
		case CSW_HEGRENADE: {
			entity_set_string(id, EV_SZ_viewmodel, g_MODEL_V_PIPE);
			entity_set_string(id, EV_SZ_weaponmodel, "");
		}
		case CSW_FLASHBANG: {
			entity_set_string(id, EV_SZ_viewmodel, g_MODEL_V_PILLS);
			entity_set_string(id, EV_SZ_weaponmodel, "");
		}
		case CSW_SMOKEGRENADE: {
			entity_set_string(id, EV_SZ_viewmodel, g_MODEL_ADRENALINA);
			entity_set_string(id, EV_SZ_weaponmodel, "");
		}
	}
}

public hideHUDs(const taskid) {
	if(!is_user_alive(ID_SPAWN))
		return;
	
	message_begin(MSG_ONE, g_Message_HideWeapon, _, ID_SPAWN);
	write_byte(HIDE_HUDS);
	message_end();
	
	message_begin(MSG_ONE, g_Message_Crosshair, _, ID_SPAWN);
	write_byte(0);
	message_end();
}

stock getCurrentWeaponEnt(const id) {
	if(pev_valid(id) != PDATA_SAFE)
		return -1;
	
	return get_pdata_cbase(id, OFFSET_ACTIVE_ITEM, OFFSET_LINUX);
}

public fw_SetClientKeyValue(id, const infobuffer[], const key[]) {
	if (key[0] == 'm' && key[1] == 'o' && key[2] == 'd' && key[3] == 'e' && key[4] == 'l') {
		return FMRES_SUPERCEDE;
	}
	
	if(key[0] == 'n' && key[1] == 'a' && key[2] == 'm' && key[3] == 'e') {
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}

public fw_ClientUserInfoChanged(const id, const buffer) {
	if(!is_user_connected(id)) {
		return FMRES_IGNORED;
	}
	
	get_user_name(id, g_UserName[id], 31);
	
	static sCurrentModel[32];
	getUserModel(id, sCurrentModel, 31);
	
	if(!equal(sCurrentModel, g_UserModel[id]) && !task_exists(id + TASK_MODEL)) {
		setUserModel(id + TASK_MODEL);
	}
	
	static sNewName[32];
	engfunc(EngFunc_InfoKeyValue, buffer, "name", sNewName, 31);
	
	if(equal(sNewName, g_UserName[id])) {
		return FMRES_IGNORED;
	}
	
	engfunc(EngFunc_SetClientKeyValue, id, buffer, "name", g_UserName[id]);
	client_cmd(id, "name ^"%s^"; setinfo name ^"%s^"", g_UserName[id], g_UserName[id]);
	
	console_print(id, "[L4D2] No podes cambiarte el nombre dentro del servidor!");
	
	return FMRES_SUPERCEDE;
}

stock getUserModel(const id, model[], const len) {
	get_user_info(id, "model", model, len);
}
new Float:gVECVEL[3];

public fw_TakeDamage(const victim, const inflictor, const attacker, Float:damage, const damage_type) {
	if(damage_type & DMG_FALL) {
		return HAM_SUPERCEDE;
	}
	
	if(victim == attacker || !is_user_connected(attacker)) {
		return HAM_IGNORED;
	}
	
	if(g_Zombie[attacker] && g_Zombie[victim] && !g_Tank[attacker]) {
		return HAM_IGNORED;
	}
	
	if(!g_Zombie[victim] && !g_Zombie[attacker]) {
		return HAM_IGNORED;
	}
	
	static iDamage;
	iDamage = floatround(damage);
	
	if(g_Zombie[attacker]) {
		g_Zombie_Damage[attacker] += iDamage;
		
		if(g_RoundTime < 600) {
			g_Team_DamageReceive += iDamage;
		}
		
		if(g_Hunter[attacker] || g_Boomer[attacker]) {
			iDamage *= 3;
			SetHamParamFloat(4, float(iDamage));
			
			if(g_Hunter[attacker]) {
				g_Zombie_HunterDamage[attacker] += iDamage;
			} else {
				g_Zombie_BoomerDamage[attacker] += iDamage;
			}
		} else if(g_Tank[attacker]) {
			iDamage *= 6;
			SetHamParamFloat(4, float(iDamage));
			
			g_Zombie_TankDamage[attacker] += iDamage;
			
			if(g_Smoker_Victim[victim]) {
				new i;
				for(i = 1; i <= g_MaxUsers; ++i) {
					if(!is_user_alive(i)) {
						continue;
					}
					
					if(!g_Zombie[i]) {
						continue;
					}
					
					if(g_Smoker_Tongue[i] == victim) {
						smokerTongueEnd(i);
						
						set_user_gravity(victim, 1.0);
						g_Smoker_Victim[victim] = 0;
						g_Speed[victim] = (!g_InAdrenaline[victim]) ? 240.0 : 320.0;
						
						set_user_rendering(victim);
						
						ExecuteHamB(Ham_Player_ResetMaxSpeed, victim);
						
						break;
					}
				}
			} else if(g_Smoker[victim]) {
				if(g_Smoker_Tongue[victim]) {
					set_user_gravity(g_Smoker_Tongue[victim], 1.0);
					
					g_Smoker_Victim[g_Smoker_Tongue[victim]] = 0;
					g_Speed[g_Smoker_Tongue[victim]] = (!g_InAdrenaline[g_Smoker_Tongue[victim]]) ? 240.0 : 320.0;
					
					set_user_rendering(g_Smoker_Tongue[victim]);
					
					ExecuteHamB(Ham_Player_ResetMaxSpeed, g_Smoker_Tongue[victim]);
					
					smokerTongueEnd(victim);
				}
			}
			
			if(!g_Tank[victim] && !g_Charger[victim] && !g_Witch[victim]) {
				new Float:vecOrigin[3];
				new Float:vecVictimOrigin[3];
				new Float:vecSub[3];
				
				entity_get_vector(attacker, EV_VEC_origin, vecOrigin);
				entity_get_vector(victim, EV_VEC_origin, vecVictimOrigin);
				
				if((entity_get_int(victim, EV_INT_bInDuck)) || (entity_get_int(victim, EV_INT_flags) & FL_DUCKING)) {
					vecVictimOrigin[2] += 18.0;
				}
				
				xs_vec_sub(vecVictimOrigin, vecOrigin, vecSub);
				
				vecSub[2] += 5.0;
				
				xs_vec_mul_scalar(vecSub, 38.5, vecSub);
				
				entity_set_vector(victim, EV_VEC_velocity, vecSub);
			}
		} else if(g_Smoker[attacker]) {
			g_Zombie_SmokerDamage[attacker] += iDamage;
		} else if(g_Charger[attacker]) {
			g_Zombie_ChargerDamage[attacker] += iDamage;
		} else if(g_Spitter[attacker]) {
			g_Zombie_SpitterDamage[attacker] += iDamage;
		} else if(g_Witch[attacker]) {
			g_Zombie_WitchDamage[attacker] += iDamage;
		}
	} else {	
		g_Team_Damage += iDamage;
		g_Human_Damage[attacker] += iDamage;
		
		++g_Team_Shoots;
		++g_Human_Shoots[attacker];
		
		if(get_pdata_int(victim, 75) == HIT_HEAD) {
			++g_Team_ShootsHS;
			++g_Human_ShootsHS[attacker];
		}
		
		if(g_PrimaryWeapon[attacker] == 0) {
			g_Team_DamageWithPistol += iDamage;
			g_Human_DamageWithPistol[attacker] += iDamage;
		} else if(g_CurrentWeapon[attacker] == CSW_KNIFE && g_Chainsaw[attacker]) {
			g_Team_DamageWithChainsaw += iDamage;
			g_Human_DamageWithChainsaw[attacker] += iDamage;
		}
		
		if(g_Witch[victim] && !g_AngryWitch[victim]) {
			remove_task(victim + TASK_SOUND);
			
			g_AngryWitch[victim] = 1;
			g_Speed[victim] = 500.0;
			
			set_user_rendering(victim, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 4);
			
			remove_task(victim + TASK_AURA);
			set_task(0.1, "witchAngryAura", victim + TASK_AURA, _, _, "b");
			
			ExecuteHamB(Ham_Player_ResetMaxSpeed, victim);
			
			playSound(0, g_SOUND_WITCH, 1);
			
			remove_task(TASK_REPEAT_SOUND_WITCH);
			set_task(30.5, "repeatWitchSound", TASK_REPEAT_SOUND_WITCH);
		} else if(g_Tank[victim]) {
			g_Human_DamageToTank[attacker] += iDamage;
		}
	}
	
	entity_get_vector(victim, EV_VEC_velocity, gVECVEL);
	
	return HAM_IGNORED;
}

public fw_TakeDamage_Post(const victim, const inflictor, const attacker) {
	if(g_InAdrenaline[victim] || g_Tank[victim] || g_Witch[victim] || g_Smoker_Victim[victim] || (g_Tank[attacker] && !g_Zombie[victim])) {
		if(pev_valid(victim) != PDATA_SAFE) {
			return;
		}
		
		if(g_Tank[victim]) {
			entity_set_vector(victim, EV_VEC_velocity, gVECVEL);
		}
		
		set_pdata_float(victim, OFFSET_PAINSHOCK, 1.0, OFFSET_LINUX);
	}
}

public fw_PlayerKilled(const victim, const killer, const shouldgib) {
	remove_task(victim + TASK_AURA);
	remove_task(victim + TASK_SOUND);
	remove_task(victim + TASK_CHARGER_CAMERA);
	remove_task(victim + TASK_ADRENALINA);
	
	g_InAdrenaline[victim] = 0;
	
	set_user_rendering(victim);
	
	if(g_Zombie[victim]) {
		if(g_Hunter[victim]) {
			--g_HunterCount;
		} else if(g_Boomer[victim]) {
			--g_BoomerCount;
		} else if(g_Smoker[victim]) {
			--g_SmokerCount;
			
			if(g_Smoker_Tongue[victim]) {
				set_user_gravity(g_Smoker_Tongue[victim], 1.0);
				
				g_Smoker_Victim[g_Smoker_Tongue[victim]] = 0;
				g_Speed[g_Smoker_Tongue[victim]] = (!g_InAdrenaline[g_Smoker_Tongue[victim]]) ? 240.0 : 320.0;
				
				set_user_rendering(g_Smoker_Tongue[victim]);
				
				ExecuteHamB(Ham_Player_ResetMaxSpeed, g_Smoker_Tongue[victim]);
				
				smokerTongueEnd(victim);
			}
		} else if(g_Spitter[victim]) {
			--g_SpitterCount;
		} else if(g_Charger[victim]) {
			--g_ChargerCount;
			
			if(is_valid_ent(g_ChargerEnt[victim])) {
				smokerBeamRemove(victim);
				
				remove_entity(g_ChargerEnt[victim]);
				g_ChargerEnt[victim] = 0;
			}
		} else if(g_Tank[victim]) {
			--g_TankAlive;
			
			if(!g_TankAlive) {
				client_cmd(0, "mp3 stop");
				remove_task(TASK_REPEAT_SOUND_TANK);
			}
		} else if(g_Witch[victim]) {
			--g_WitchAlive;
			
			if(!g_WitchAlive) {
				client_cmd(0, "mp3 stop");
				remove_task(TASK_REPEAT_SOUND_WITCH);
			}
		}
	} else {
		new i;
		new iHumans = 0;
		
		for(i = 1; i <= g_MaxUsers; ++i) {
			if(!is_user_alive(i)) {
				continue;
			}
			
			if(i == victim) {
				continue;
			}
			
			if(!g_Zombie[i]) {
				++iHumans;
			}
		}
		
		if(!iHumans && g_Team_Id > 0 && g_RoundTime > 5) {
			colorChat(0, _, "%sEl equipo actual resistió !g%d segundos!!y", TORNEO_PREFIX, g_RoundTime);
			
			new sQuery[512];
			formatex(sQuery, 511, "INSERT INTO torneozp_team (team_id, team_time, team_dmg_done, team_zk, team_zsk, team_dmg_taken, team_dmg_pistol, team_dmg_chainsaw, team_shoots, team_shootshs, team_hk, team_bk, team_sk, team_ck, team_spk, team_wk, team_tk)");
			
			new Handle:sqlQuery;
			sqlQuery = SQL_PrepareQuery(g_SqlConnection, "%s VALUES ('%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d')", sQuery, g_Team_Id, g_RoundTime, g_Team_Damage, g_Team_ZombiesKill, g_Team_ZombiesSpecialKill, g_Team_DamageReceive,
			g_Team_DamageWithPistol, g_Team_DamageWithChainsaw, g_Team_Shoots, g_Team_ShootsHS, g_Team_HuntersKill, g_Team_BoomersKill, g_Team_SmokersKill, g_Team_ChargersKill, g_Team_SpittersKill, g_Team_WitchsKill, g_Team_TanksKill);
			
			if(!SQL_Execute(sqlQuery)) {
				executeQuery(0, sqlQuery, 54);
			} else {
				SQL_FreeHandle(sqlQuery);
			}
			
			g_Team_Id = 0;
		}
	}
	
	if(victim == killer || !is_user_connected(killer)) {
		return;
	}
	
	if(!g_Zombie[victim]) {
		++g_Zombie_HumansKill[killer];
		
		if(g_Smoker_Victim[victim]) {
			new i;
			for(i = 1; i <= g_MaxUsers; ++i) {
				if(!is_user_alive(i)) {
					continue;
				}
				
				if(g_Smoker[i]) {
					if(g_Smoker_Tongue[i] == victim) {
						moveSmokerAgain(i);
						break;
					}
				}
			}
		}
	} else {
		++g_Team_ZombiesKill;
		++g_Human_ZombiesKill[killer];
		
		if(g_Boomer[victim] || g_Smoker[victim] || g_Spitter[victim] || g_Charger[victim] || g_Hunter[victim] || g_Tank[victim] || g_Witch[victim]) {
			++g_Team_ZombiesSpecialKill;
			++g_Human_ZombiesSpecialKill[killer];
			
			if(g_Boomer[victim]) {
				++g_Team_BoomersKill;
				++g_Human_BoomersKill[killer];
				
				new i;
				
				emit_sound(victim, CHAN_BODY, g_SOUND_BOOMER_EXPLODE[random_num(0, 2)], 1.0, ATTN_NORM, 0, PITCH_HIGH);
				
				for(i = 1; i <= g_MaxUsers; ++i) {
					if(!is_user_alive(i)) {
						continue;
					}
					
					if(get_entity_distance(victim, i) > 215) {
						continue;
					}
					
					if(!g_Zombie[i]) {
						message_begin(MSG_ONE_UNRELIABLE, g_Message_ScreenFade, _, i);
						write_short(UNIT_SECOND * 4);
						write_short(UNIT_SECOND * 4);
						write_short(0x0000);
						write_byte(79);
						write_byte(180);
						write_byte(61);
						write_byte(255);
						message_end();
						
						set_user_rendering(i, kRenderFxGlowShell, 79, 180, 61, kRenderNormal, 4);
						
						set_task(4.0, "removeGlow", i);
						
						++g_Zombie_BoomerVomitInH[victim];
					} else {
						++g_Zombie_BoomerVomitInZ[victim];
					}
				}
			} else if(g_Hunter[victim]) {
				++g_Team_HuntersKill;
				++g_Human_HuntersKill[killer];
			} else if(g_Spitter[victim]) {
				++g_Team_SpittersKill;
				++g_Human_SpittersKill[killer];
			} else if(g_Charger[victim]) {
				++g_Team_ChargersKill;
				++g_Human_ChargersKill[killer];
			} else if(g_Tank[victim]) {
				++g_Team_TanksKill;
				++g_Human_TanksKill[killer];
			} else if(g_Witch[victim]) {
				++g_Team_WitchsKill;
				++g_Human_WitchsKill[killer];
			} else if(g_Smoker[victim]) {
				++g_Team_SmokersKill;
				++g_Human_SmokersKill[killer];
				
				new i;
				for(i = 1; i <= g_MaxUsers; ++i) {
					if(!is_user_alive(i)) {
						continue;
					}
					
					if(g_Zombie[i]) {
						continue;
					}
					
					if(get_entity_distance(victim, i) > 250) {
						continue;
					}
					
					message_begin(MSG_ONE_UNRELIABLE, g_Message_ScreenFade, _, i);
					write_short(UNIT_SECOND * 3);
					write_short(UNIT_SECOND * 3);
					write_short(0x0000);
					write_byte(128);
					write_byte(128);
					write_byte(128);
					write_byte(128);
					message_end();
				}
				
				if(g_Smoker_Tongue[victim]) {
					set_user_gravity(g_Smoker_Tongue[victim], 1.0);
					
					g_Smoker_Victim[g_Smoker_Tongue[victim]] = 0;
					g_Speed[g_Smoker_Tongue[victim]] = (!g_InAdrenaline[g_Smoker_Tongue[victim]]) ? 240.0 : 320.0;
					
					set_user_rendering(g_Smoker_Tongue[victim]);
					
					ExecuteHamB(Ham_Player_ResetMaxSpeed, g_Smoker_Tongue[victim]);
					
					smokerTongueEnd(victim);
				}
			}
		}
	}
}

public fw_PlayerKilled_Post(const victim, const killer, const shouldgib) {
	if(g_Zombie[victim]) {
		set_task(random_float(0.7, 1.2), "respawnUser", victim + TASK_SPAWN);
	}
}

public fw_UseStationary(const entity, const caller, const activator, const use_type) {
	if(use_type == 2 && is_user_connected(caller) && g_Zombie[caller]) {
		return HAM_SUPERCEDE;
	}
	
	hideHUDs(caller + TASK_SPAWN);
	
	return HAM_IGNORED;
}

public fw_UseStationary_Post(const entity, const caller, const activator, const use_type) {
	if(use_type == 0 && is_user_connected(caller)) {
		replaceWeaponModels(caller, g_CurrentWeapon[caller]);
		
		hideHUDs(caller + TASK_SPAWN);
	}
}

public fw_Item_Deploy_Post(const weaponEnt) {
	static iId;
	iId = getWeaponEntId(weaponEnt);
	
	if(!pev_valid(iId)) {
		return HAM_IGNORED;
	}
	
	static iWeaponId;
	iWeaponId = cs_get_weapon_id(weaponEnt);
	
	g_CurrentWeapon[iId] = iWeaponId;
	
	g_PrimaryWeapon[iId] = ((1 << iWeaponId) & PRIMARY_WEAPONS_BIT_SUM) ? 1 : ((1 << iWeaponId) & SECONDARY_WEAPONS_BIT_SUM) ? 0 : -1;
	
	if(g_CurrentWeapon[iId] == CSW_KNIFE || g_CurrentWeapon[iId] == CSW_HEGRENADE || g_CurrentWeapon[iId] == CSW_FLASHBANG || g_CurrentWeapon[iId] == CSW_SMOKEGRENADE) {
		replaceWeaponModels(iId, g_CurrentWeapon[iId]);
	}
	
	if(iWeaponId == CSW_FLASHBANG || iWeaponId == CSW_SMOKEGRENADE) {
		set_pdata_float(weaponEnt, OFFSET_NEXT_PRIMARY_ATTACK, 9999.0, OFFSET_LINUX_WEAPONS);		
		return HAM_SUPERCEDE;
	}
	
	return HAM_IGNORED;
}

public fw_Weapon_PrimaryAttack_Post(const weapon) {
	if(!pev_valid(weapon)) {
		return HAM_IGNORED;
	}
	
	static id;
	id = get_pdata_cbase(weapon, OFFSET_WEAPONOWNER, OFFSET_LINUX_WEAPONS);
	
	if(!is_user_alive(id)) {
		return HAM_IGNORED;
	}
	
	if(g_Zombie[id]) {
		if(g_Witch[id]) {
			static Float:vecPunchangle[3];
			static Float:flSpeed;
			
			flSpeed = 0.1;
			vecPunchangle[0] = 0.0;
			
			set_pdata_float(weapon, OFFSET_NEXT_PRIMARY_ATTACK, flSpeed, OFFSET_LINUX_WEAPONS);
			set_pdata_float(weapon, OFFSET_NEXT_SECONDARY_ATTACK, flSpeed, OFFSET_LINUX_WEAPONS);
			set_pdata_float(weapon, OFFSET_TIME_WEAPON_IDLE, flSpeed, OFFSET_LINUX_WEAPONS);
			
			entity_set_vector(id, EV_VEC_punchangle, vecPunchangle);
		}
	} else if(g_Chainsaw[id]) {
		static Float:vecPunchangle[3];
		static Float:flSpeed;
		
		flSpeed = 0.15;
		vecPunchangle[0] = 0.0;
		
		set_pdata_float(weapon, OFFSET_NEXT_PRIMARY_ATTACK, flSpeed, OFFSET_LINUX_WEAPONS);
		set_pdata_float(weapon, OFFSET_NEXT_SECONDARY_ATTACK, flSpeed, OFFSET_LINUX_WEAPONS);
		set_pdata_float(weapon, OFFSET_TIME_WEAPON_IDLE, flSpeed, OFFSET_LINUX_WEAPONS);
		
		entity_set_vector(id, EV_VEC_punchangle, vecPunchangle);
	}
	
	return HAM_IGNORED;
}

stock getWeaponEntId(const ent) {
	if(pev_valid(ent) != PDATA_SAFE)
		return -1;
	
	return get_pdata_cbase(ent, OFFSET_WEAPONOWNER, OFFSET_LINUX_WEAPONS);
}

public fw_PlayerJump(const id) {
	if(!is_user_alive(id)) {
		return HAM_IGNORED;
	}
	
	if(!g_Hunter[id]) {
		return HAM_IGNORED;
	}
	
	static iFlags;
	static iButtonPressed;
	
	iFlags = entity_get_int(id, EV_INT_flags);
	iButtonPressed = get_pdata_int(id, OFFSET_BUTTONPRESSED, OFFSET_LINUX);
	
	if(!(iButtonPressed & IN_JUMP) || !(iFlags & FL_ONGROUND)) {
		return HAM_IGNORED;
	}
	
	if((entity_get_int(id, EV_INT_bInDuck) || iFlags & FL_DUCKING) && entity_get_int(id, EV_INT_button) & IN_DUCK && entity_get_int(id, EV_INT_flDuckTime)) {
		static Float:flGameTime;
		flGameTime = get_gametime();
		
		if(g_HunterJump[id] > flGameTime) {
			colorChat(id, _, "%sTenés que esperar !g%0.2f!y segundos para volver a usar tu poder!", TORNEO_PREFIX, (g_HunterJump[id] - flGameTime));
			return HAM_IGNORED;
		}
		
		g_HunterJump[id] = flGameTime + 5.0;
		
		emit_sound(id, CHAN_BODY, g_SOUND_HUNTER_JUMP, 0.5, ATTN_NORM, 0, PITCH_NORM);
		
		static Float:vecVelocity[3];
		entity_get_vector(id, EV_VEC_velocity, vecVelocity);
		
		entity_get_vector(id, EV_VEC_punchangle, vecVelocity);
		vecVelocity[0] = -5.0;
		entity_set_vector(id, EV_VEC_punchangle, vecVelocity);
		
		get_global_vector(GL_v_forward, vecVelocity);
		
		static Float:fSpeed;
		static Float:fHeight;
		
		fSpeed = 1024.0;
		fHeight = 700.0;
		
		vecVelocity[0] *= fSpeed;
		vecVelocity[1] *= fSpeed;
		vecVelocity[2] = fHeight;
		
		entity_set_vector(id, EV_VEC_velocity, vecVelocity);
		
		set_pdata_int(id, 73, 8, OFFSET_LINUX);
		set_pdata_int(id, 74, 8, OFFSET_LINUX);
		
		g_InLongJump[id] = 1;
		
		entity_set_int(id, EV_INT_oldbuttons, entity_get_int(id, EV_INT_oldbuttons) | IN_JUMP);
		
		entity_set_int(id, EV_INT_gaitsequence, 7);
		entity_set_float(id, EV_FL_frame, 0.0);
		
		set_pdata_int(id, OFFSET_BUTTONPRESSED, iButtonPressed & ~IN_JUMP, OFFSET_LINUX);
		
		return HAM_SUPERCEDE;
	}
	
	return HAM_IGNORED;
}

public fw_PlayerDuck(const id) {
	if(g_InLongJump[id]) {
		g_InLongJump[id] = 0;
		return HAM_SUPERCEDE;
	}
	
	return HAM_IGNORED;
}

public concmd_Break(const id) {
	if(g_Kiske[id]) {
		new iEnt = -1;
		new Float:vecOrigin[3];
		new sClassName[15];
		
		entity_get_vector(id, EV_VEC_origin, vecOrigin);
		while((iEnt = find_ent_in_sphere(iEnt, vecOrigin, 200.0)) != 0) {
			if(!is_user_alive(iEnt)) {
				entity_get_string(iEnt, EV_SZ_classname, sClassName, 14);
			
				if(equal(sClassName, "func_breakable")) {
					force_use(id, iEnt);
					
					break;
				}
				
				continue;
			}
		}
	}
	
	return PLUGIN_HANDLED;
}

public giveLongJump(const id) {
	if(is_user_alive(id)) {
		give_item(id, "item_longjump");
	}
}

public fw_ResetMaxSpeed_Post(const id) {
	if(!is_user_alive(id))
		return;
	
	set_user_maxspeed(id, g_Speed[id]);
}

public createBoomerSprite(const iArgs[]) {
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_SPRAY);
	write_coord(iArgs[0]);
	write_coord(iArgs[1]);
	write_coord(iArgs[2]);
	write_coord(iArgs[3]);
	write_coord(iArgs[4]);
	write_coord(iArgs[5]);
	write_short(g_SPRITE_BOOMER);
	write_byte(1);
	write_byte(100);
	write_byte(1);
	write_byte(5);
	message_end();
}

public moveBoomerAgain(const id) {
	if(is_user_alive(id) && g_Boomer[id]) {
		g_Speed[id] = 210.0;
		ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
	}
}

public moveSmokerAgain(const id) {
	if(is_user_alive(id) && g_Smoker[id]) {
		g_Speed[id] = 225.0;
		ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
	}
}

public removeGlow(const id) {
	if(is_user_alive(id)) {
		set_user_rendering(id);
	}
}

public concmd_Angry(const id) {
	if(g_Kiske[id]) {
		new i;
		for(i = 1; i <= g_MaxUsers; ++i) {
			if(g_Witch[i] && !g_AngryWitch[i]) {
				remove_task(i + TASK_SOUND);
				
				g_AngryWitch[i] = 1;
				g_Speed[i] = 500.0;
				
				set_user_rendering(i, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 4);
				
				remove_task(i + TASK_AURA);
				set_task(0.1, "witchAngryAura", i + TASK_AURA, _, _, "b");
				
				ExecuteHamB(Ham_Player_ResetMaxSpeed, i);
				
				playSound(0, g_SOUND_WITCH, 1);
				
				remove_task(TASK_REPEAT_SOUND_WITCH);
				set_task(30.5, "repeatWitchSound", TASK_REPEAT_SOUND_WITCH);
			}
		}
	}
	
	return PLUGIN_HANDLED;
}

public concmd_Teams(const id) {
	if(g_Kiske[id]) {
		console_print(id, "1) Assassins of Death | 4601 | 7467 | 631 | 7198 | (0)");
		console_print(id, "2) bananero left 4 dead | 510 | 36 | 8470 | 9114 | (0)");
		console_print(id, "3) Pinguinitos | 6466 | 9416 | 216 | 7289 | (0)");
		console_print(id, "4) Leo y su Pandilla!!! | 7 | 5063 | 2413 | 3192 | (0)");
		console_print(id, "5) Deca Kill 2.0 | 154 | 6909 | 7522 | 1450 | (0)");
		console_print(id, "6) [S]tile K,zix | 1139 | 3634 | 519 | 3516 | (6686)");
		console_print(id, "7) nachtstrom krieger | 1938 | 285 | 6728 | 476 | (0)");
		console_print(id, "8) Ola k ase | 2607 | 4167 | 7952 | 67 | (0)");
		console_print(id, "9) Monstruitos | 3265 | 9715 | 1404 | 7068 | (0)");
		console_print(id, "10) gRupo NaVi | 3867 | 6064 | 9 | 7435 | (0)");
		console_print(id, "11) Team Seep | 272 | 1254 | 68 | 10 | (8223)");
		console_print(id, "12) Los FisuRaDooS | 35 | 180 | 31 | 8243 | (580)");
		console_print(id, "13) Los pibes de la D.. | 7780 | 3506 | 8543 | 6703 | (0)");
		console_print(id, "14) Game of Thrones(? | 153 | 2849 | 882 | 207 | (24)");
		console_print(id, "15) Los matazombies v5 :P | 106 | 44 | 626 | 4365 | (0)");
		console_print(id, "16) Los Cuarteteros.Es | 8272 | 9369 | 4881 | 5669 | (4173)");
		
		new i;
		for(i = 1; i <= g_MaxUsers; ++i) {
			if(!is_user_connected(i)) {
				continue;
			}
			
			console_print(id, "%d = %s", g_UserId[i], g_UserName[i]);
		}
	}
	
	return PLUGIN_HANDLED;
}

public concmd_Human(const id) {
	if(g_Kiske[id]) {
		new sArgs[5][5];
		new iArgs[4];
		
		new i;
		new j;
		
		read_argv(1, sArgs[0], 4);
		read_argv(2, sArgs[1], 4);
		read_argv(3, sArgs[2], 4);
		read_argv(4, sArgs[3], 4);
		read_argv(5, sArgs[4], 4);
		
		g_Team_Id = str_to_num(sArgs[4]);
		
		for(i = 0; i < 4; ++i) {
			iArgs[i] = str_to_num(sArgs[i]);
		}
		
		for(i = 1; i <= g_MaxUsers; ++i) {
			for(j = 0; j < 4; ++j) {
				if(iArgs[j] == g_UserId[i]) {
					g_AllowChangeTeam[i] = 1;
					
					g_Zombie[i] = 0;
					
					set_pdata_int(i, 125, (get_pdata_int(i, 125, OFFSET_LINUX) & ~(1<<8)), OFFSET_LINUX);
					
					engclient_cmd(i, "jointeam", "2");
					engclient_cmd(i, "joinclass", "5");
					
					g_AllowChangeTeam[i] = 0;
					
					set_task(0.5, "respawnUser", i + TASK_SPAWN);
					
					break;
				}
			}
		}
	}
	
	return PLUGIN_HANDLED;
}

public OrpheuHookReturn:OnPM_Move(const OrpheuStruct:pmove, const server) {
	g_UserMove = pmove;
}

public OrpheuHookReturn:OnPM_Jump() {
	new id;
	id = OrpheuGetStructMember(g_UserMove, "player_index") + 1;
	
	if(is_user_alive(id) && ((g_Witch[id] && !g_AngryWitch[id]) || (g_Smoker_Tongue[id] || g_Smoker_Victim[id]) || (g_Charger[id] && g_ChargerInCamera[id]))) {
		OrpheuSetStructMember(g_UserMove, "oldbuttons", OrpheuGetStructMember(g_UserMove, "oldbuttons") | IN_JUMP);
	}
}

public OrpheuHookReturn:OnPM_Duck() {
	new id;
	id = OrpheuGetStructMember(g_UserMove, "player_index") + 1;
	
	if(is_user_alive(id) && ((g_Witch[id] && !g_AngryWitch[id]) || (g_Smoker_Tongue[id] || g_Smoker_Victim[id]) || (g_Charger[id] && g_ChargerInCamera[id]))) {
		new OrpheuStruct:cmd = OrpheuStruct:OrpheuGetStructMember(g_UserMove, "cmd");
		OrpheuSetStructMember(cmd, "buttons", OrpheuGetStructMember(cmd, "buttons" ) & ~IN_DUCK);
	}
}

public smokerNoTarget(const id) {
	new iEndOrigin[3];
	get_user_origin(id, iEndOrigin, 3);
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_BEAMENTPOINT);
	write_short(id);
	write_coord(iEndOrigin[0]);
	write_coord(iEndOrigin[1]);
	write_coord(iEndOrigin[2]);
	write_short(g_SPRITE_SMOKER_TONGUE);
	write_byte(0);
	write_byte(0);
	write_byte(6);
	write_byte(8);
	write_byte(1);
	write_byte(155);
	write_byte(155);
	write_byte(55);
	write_byte(75);
	write_byte(0);
	message_end();
}

public smokerAttract(const iArgs[]) {
	new iSmoker = iArgs[0];
	new iVictim = iArgs[1];
	
	if(!g_Smoker_Tongue[iSmoker] || !is_user_alive(iVictim)) {
		smokerTongueEnd(iSmoker);
		return;
	}
	
	new Float:vecVelocity[3];
	new Float:vecSmokerOrigin[3];
	new Float:vecVictimOrigin[3];
	new Float:flDistance;
	
	entity_get_vector(iSmoker, EV_VEC_origin, vecSmokerOrigin);
	entity_get_vector(iVictim, EV_VEC_origin, vecVictimOrigin);
	
	ExecuteHam(Ham_TakeDamage, iVictim, iSmoker, iSmoker, 1.0, DMG_CRUSH);
	
	if(!is_user_alive(iVictim)) {
		return;
	}
	
	flDistance = get_distance_f(vecSmokerOrigin, vecVictimOrigin);
	
	if(flDistance > 5) {
		new Float:flTime;
		flTime = flDistance / 800.0;
		
		vecVelocity[0] = (vecSmokerOrigin[0] - vecVictimOrigin[0]) / flTime;
		vecVelocity[1] = (vecSmokerOrigin[1] - vecVictimOrigin[1]) / flTime;
		vecVelocity[2] = 0.0;
	} else {
		vecVelocity[0] = 0.0;
		vecVelocity[1] = 0.0;
		vecVelocity[2] = 0.0;
	}
	
	entity_set_vector(iVictim, EV_VEC_velocity, vecVelocity);
}

public dragTarget(const iArgs[]) {
	new iSmoker = iArgs[0];
	new iTarget = iArgs[1];
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_BEAMENTS);
	write_short(iSmoker);
	write_short(iTarget);
	write_short(g_SPRITE_SMOKER_TONGUE);
	write_byte(0);
	write_byte(0);
	write_byte(200);
	write_byte(8);
	write_byte(1);
	write_byte(155);
	write_byte(155);
	write_byte(55);
	write_byte(90);
	write_byte(10);
	message_end();
}

public smokerTongueEnd(const id) {
	g_Smoker_Tongue[id] = 0;
	
	smokerBeamRemove(id);
	moveSmokerAgain(id);
}

public smokerBeamRemove(const id) {
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_KILLBEAM);
	write_short(id);
	message_end();
}

stock createSprite(const Float:XYZ_position[3], const sprite_index, const brightness, const scale) {
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_SPRITE);
	engfunc(EngFunc_WriteCoord, XYZ_position[0]);
	engfunc(EngFunc_WriteCoord, XYZ_position[1]);
	engfunc(EngFunc_WriteCoord, XYZ_position[2]);
	write_short(sprite_index);
	write_byte(scale);
	write_byte(brightness);
	message_end();
}

public fw_EmitSound(const id, const channel, const sample[], const Float:volume, const Float:attn, const flags, const pitch) {
	if(sample[7] == 'b' && sample[8] == 'o' && sample[9] == 'd' && sample[10] == 'y' && sample[11] == 's' && sample[12] == 'p' && sample[13] == 'l' && sample[14] == 'a' && sample[15] == 't') { // BODYSPLAT
		return FMRES_SUPERCEDE;
	}
	
	if(sample[0] == 'h' && sample[1] == 'o' && sample[2] == 's' && sample[3] == 't' && sample[4] == 'a' && sample[5] == 'g' && sample[6] == 'e') { // HOSTAGE
		return FMRES_SUPERCEDE;
	}
	
	if(sample[10] == 'f' && sample[11] == 'a' && sample[12] == 'l' && sample[13] == 'l') { // FALL
		return FMRES_SUPERCEDE;
	}
	
	if(!is_user_connected(id)) {
		return FMRES_IGNORED;
	}
	
	if(g_Chainsaw[id]) {
		new i;
		for(i = 0; i < sizeof(g_SOUND_CHAINSAW); ++i) {
			if(equal(sample, g_SOUND_KNIFE[i])) {
				emit_sound(id, channel, g_SOUND_CHAINSAW[i], 1.0, ATTN_NORM, 0, PITCH_NORM);
				return FMRES_SUPERCEDE;
			}
		}
	}
	
	if(!g_Zombie[id]) {
		return FMRES_IGNORED;
	}
	
	if(sample[7] == 'b' && sample[8] == 'h' && sample[9] == 'i' && sample[10] == 't') { // BHIT
		emit_sound(id, channel, g_SOUND_PAIN[random_num(0, charsmax(g_SOUND_PAIN))], volume, attn, flags, pitch);
		return FMRES_SUPERCEDE;
	}
	
	if(sample[8] == 'k' && sample[9] == 'n' && sample[10] == 'i') { // KNI (FE)
		if(sample[14] == 's' && sample[15] == 'l' && sample[16] == 'a') { // SLA (SH)
			emit_sound(id, channel, g_SOUND_CLAW_SLASH[random_num(0, charsmax(g_SOUND_CLAW_SLASH))], volume, attn, flags, pitch);
			return FMRES_SUPERCEDE;
		}
		
		if(sample[14] == 'h' && sample[15] == 'i' && sample[16] == 't') { // HIT
			if(sample[17] == 'w') { // W (ALL)
				if(!g_Charger[id] && !g_Tank[id]) {
					emit_sound(id, channel, g_SOUND_CLAW_WALL[random_num(0, charsmax(g_SOUND_CLAW_WALL))], volume, attn, flags, pitch);
				} else {
					emit_sound(id, channel, g_SOUND_KNIFE_WITH_WALL[random_num(0, charsmax(g_SOUND_KNIFE_WITH_WALL))], volume, attn, flags, pitch);
				}
				
				return FMRES_SUPERCEDE;
			} else {
				if(!g_Charger[id] && !g_Tank[id]) {
					emit_sound(id, channel, g_SOUND_CLAW_ATTACK, volume, attn, flags, pitch);
				} else {
					emit_sound(id, channel, g_SOUND_KNIFE_WITH_WALL[random_num(0, charsmax(g_SOUND_KNIFE_WITH_WALL))], volume, attn, flags, pitch);
				}
				
				return FMRES_SUPERCEDE;
			}
		}
		
		if(sample[14] == 's' && sample[15] == 't' && sample[16] == 'a') { // STA (B)
			if(!g_Charger[id] && !g_Tank[id]) {
				emit_sound(id, channel, g_SOUND_CLAW_STAB, volume, attn, flags, pitch);
			} else {
				emit_sound(id, channel, g_SOUND_KNIFE_WITH_WALL[random_num(0, charsmax(g_SOUND_KNIFE_WITH_WALL))], volume, attn, flags, pitch);
			}
			
			return FMRES_SUPERCEDE;
		}
	}
	
	if(sample[7] == 'd' && ((sample[8] == 'i' && sample[9] == 'e') || (sample[8] == 'e' && sample[9] == 'a'))) { // DIE / DEA (D)
		emit_sound(id, channel, g_SOUND_ZOMBIE_DIE[random_num(0, charsmax(g_SOUND_ZOMBIE_DIE))], volume, attn, flags, pitch);
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}

public fw_CmdStart(const id, const handle) {
	if(!is_user_alive(id)) {
		return FMRES_IGNORED;
	}
	
	static iButton;
	iButton = get_uc(handle, UC_Buttons);
	
	static iOldButton;
	iOldButton = entity_get_int(id, EV_INT_oldbuttons);
	
	if(!g_Zombie[id]) {
		if((g_CurrentWeapon[id] == CSW_FLASHBANG || g_CurrentWeapon[id] == CSW_SMOKEGRENADE)) {
			if((iButton & IN_ATTACK2) && !(iOldButton & IN_ATTACK2)) {
				if(g_CurrentWeapon[id] == CSW_FLASHBANG) {
					new iAmmo;
					iAmmo = cs_get_user_bpammo(id, CSW_FLASHBANG) - 1;
					
					if(!iAmmo) {
						hamStripWeapons(id, "weapon_flashbang", CSW_FLASHBANG);
					} else {
						cs_set_user_bpammo(id, CSW_FLASHBANG, iAmmo);
					}
					
					set_user_health(id, get_user_health(id) + 5000);
					
					emit_sound(id, CHAN_BODY, "buttons/blip1.wav", 1.0, ATTN_NORM, 0, PITCH_HIGH);
					
					message_begin(MSG_ONE_UNRELIABLE, g_Message_ScreenFade, _, id);
					write_short(UNIT_SECOND * 2);
					write_short(UNIT_SECOND * 2);
					write_short(0x0000);
					write_byte(25);
					write_byte(100);
					write_byte(25);
					write_byte(150);
					message_end();
				} else {
					if(g_Smoker_Victim[id]) {
						client_print(id, print_center, "Un Smoker te tiene atrapado, no podés utilizar la adrenalina ahora");
						return FMRES_IGNORED;
					} else if(g_InAdrenaline[id]) {
						client_print(id, print_center, "Ya estás bajo los efectos de la adrenalina");
						return FMRES_IGNORED;
					}
					
					new iAmmo;
					iAmmo = cs_get_user_bpammo(id, CSW_SMOKEGRENADE) - 1;
					
					if(!iAmmo) {
						hamStripWeapons(id, "weapon_smokegrenade", CSW_SMOKEGRENADE);
					} else {
						cs_set_user_bpammo(id, CSW_SMOKEGRENADE, iAmmo);
					}
					
					g_InAdrenaline[id] = 1;
					
					emit_sound(id, CHAN_BODY, "buttons/bell1.wav", 1.0, ATTN_NORM, 0, PITCH_HIGH);
					
					g_Speed[id] = 320.0;
					ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
					
					remove_task(id + TASK_ADRENALINA);
					set_task(0.1, "effectAdrenalineStart", id + TASK_ADRENALINA, _, _, "a", 150);
					set_task(15.0, "effectAdrenalineEnd", id + TASK_ADRENALINA);
				}
			}
		} else if(g_Speed[id] == 1.0 && ((iButton & IN_ATTACK) || (iButton & IN_ATTACK2))) {
			if((iButton & IN_ATTACK)) {
				iButton &= ~IN_ATTACK;
				set_uc(handle, UC_Buttons, iButton);
			} else {
				iButton &= ~IN_ATTACK2;
				set_uc(handle, UC_Buttons, iButton);
			}
			
			return FMRES_SUPERCEDE;
		}
	} else if(g_Charger[id] && g_ChargerInCamera[id]) {
		if((iButton & IN_ATTACK) || (iButton & IN_ATTACK2)) {
			if((iButton & IN_ATTACK)) {
				iButton &= ~IN_ATTACK;
				set_uc(handle, UC_Buttons, iButton);
			} else {
				iButton &= ~IN_ATTACK2;
				set_uc(handle, UC_Buttons, iButton);
			}
			
			return FMRES_SUPERCEDE;
		}
	} else if(!g_Witch[id] && (iButton & IN_ATTACK)) {		
		iButton &= ~IN_ATTACK;
		iButton |= IN_ATTACK2;
		
		set_uc(handle, UC_Buttons, iButton);
		
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}

public touch__RockTank(const ent, const toucher) {
	if(!is_valid_ent(ent)) {
		return;
	}
	
	if(is_user_alive(toucher)) {
		if(!g_Zombie[toucher]) {
			new iTank = entity_get_edict(ent, EV_ENT_owner);
			new iHealth = get_user_health(toucher);
			
			if(iHealth <= 140) {
				ExecuteHamB(Ham_Killed, toucher, iTank, 0);
			} else {
				set_user_health(toucher, (iHealth - 140));
			}
			
			++g_Zombie_TankRock[iTank];
		}
		
		new Float:vecAim[3];
		vecAim[0] = random_float(50.0, 100.0);
		vecAim[1] = random_float(50.0, 100.0);
		vecAim[2] = random_float(50.0, 100.0);
		
		entity_set_vector(toucher, EV_VEC_punchangle, vecAim);
	}
	
	new Float:vecOrigin[3];
	entity_get_vector(ent, EV_VEC_origin, vecOrigin);
	
	engfunc(EngFunc_MessageBegin, MSG_BROADCAST, SVC_TEMPENTITY, vecOrigin, 0);
	write_byte(TE_BREAKMODEL);
	engfunc(EngFunc_WriteCoord, vecOrigin[0]); 
	engfunc(EngFunc_WriteCoord, vecOrigin[1]);
	engfunc(EngFunc_WriteCoord, vecOrigin[2] + 24);
	write_coord(128);
	write_coord(128);
	write_coord(128);
	write_coord(random_num(-50, 50));
	write_coord(random_num(-50, 50));
	write_coord(25);
	write_byte(10);
	write_short(g_MODEL_TANK_ROCK_GIBS);
	write_byte(100);
	write_byte(60);
	write_byte(0x03);
	message_end();
	
	remove_entity(ent);
}

public spitterBall(const iArgs[], const id) {
	if(is_user_connected(id)) {
		if(is_user_alive(id)) {
			g_Speed[id] = 250.0;
			ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
		}
		
		new iEnt;
		iEnt = create_entity("info_target");
		
		if(is_valid_ent(iEnt)) {
			new Float:vecOrigin[3];
			new Float:vecVelocity[3];
			new Float:vecViewOffset[3];
			
			vecViewOffset[0] = float(iArgs[0]);
			vecViewOffset[1] = float(iArgs[1]);
			vecViewOffset[2] = float(iArgs[2]);
			
			entity_get_vector(id, EV_VEC_origin, vecOrigin);
			
			xs_vec_add(vecOrigin, vecViewOffset, vecOrigin);
			
			entity_set_string(iEnt, EV_SZ_classname, "entSpitterBall");
			entity_set_model(iEnt, g_MODEL_TANK_ROCK_GIBS_DIR);
			
			entity_set_float(iEnt, EV_FL_scale, 0.1);
			
			set_size(iEnt, Float:{-2.0, -2.0, -2.0}, Float:{2.0, 2.0, 2.0});
			entity_set_vector(iEnt, EV_VEC_mins, Float:{-2.0, -2.0, -2.0});
			entity_set_vector(iEnt, EV_VEC_maxs, Float:{2.0, 2.0, 2.0});
			
			entity_set_origin(iEnt, vecOrigin);
			
			entity_set_int(iEnt, EV_INT_solid, SOLID_NOT);
			entity_set_int(iEnt, EV_INT_movetype, MOVETYPE_TOSS);
			entity_set_edict(iEnt, EV_ENT_owner, id);
			
			vecVelocity[0] = float(iArgs[3]);
			vecVelocity[1] = float(iArgs[4]);
			vecVelocity[2] = float(iArgs[5]);
			
			entity_set_vector(iEnt, EV_VEC_velocity, vecVelocity);
			
			set_rendering(iEnt, kRenderFxGlowShell, 0, 255, 0, kRenderNormal, 4);
			entity_set_edict(iEnt, EV_ENT_euser3, createFlare(iEnt));
			
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
			write_byte(TE_BEAMFOLLOW);
			write_short(iEnt);
			write_short(g_SPRITE_TRAIL);
			write_byte(25);
			write_byte(3);
			write_byte(0);
			write_byte(255);
			write_byte(0);
			write_byte(255);
			message_end();
			
			set_task(0.1, "checkOnGround", iEnt);
		}
	}
}

createFlare(const spBall) {
	new iEnt = create_entity("env_sprite");
	
	if(!is_valid_ent(iEnt)) {
		return 0;
	}
	
	entity_set_model(iEnt, "sprites/animglow01.spr");
	
	entity_set_float(iEnt, EV_FL_scale, 0.7);
	entity_set_int(iEnt, EV_INT_spawnflags, SF_SPRITE_STARTON);
	entity_set_int(iEnt, EV_INT_solid, SOLID_NOT);
	entity_set_int(iEnt, EV_INT_movetype, MOVETYPE_FOLLOW);
	entity_set_edict(iEnt, EV_ENT_aiment, spBall);
	entity_set_edict(iEnt, EV_ENT_owner, spBall);
	entity_set_float(iEnt, EV_FL_framerate, 25.0);
	
	set_rendering(iEnt, kRenderFxNone, 0, 255, 0, kRenderTransAdd, 255);
	
	DispatchSpawn(iEnt);
	
	return iEnt;
}

public setAura(const iEnt) {
	if(is_valid_ent(iEnt)) {
		static Float:vecOrigin[3];
		static iVictim;
		static iAttacker;
		
		entity_get_vector(iEnt, EV_VEC_origin, vecOrigin);
		
		iAttacker = entity_get_edict(iEnt, EV_ENT_owner);
		iVictim = -1;
		
		if(!is_user_connected(iAttacker)) {
			iAttacker = -1;
		}
		
		while((iVictim = find_ent_in_sphere(iVictim, vecOrigin, 240.0)) != 0) {
			if(!is_user_alive(iVictim)) {
				continue;
			}
			
			if(g_Zombie[iVictim]) {
				continue;
			}
			
			if(iAttacker == -1) {
				iAttacker = iVictim;
			}
			
			emit_sound(iVictim, CHAN_BODY, g_SOUND_BHITS[random_num(0, charsmax(g_SOUND_BHITS))], 1.0, ATTN_NORM, 0, PITCH_NORM);
			
			new iHealth = get_user_health(iVictim);
			
			if(iHealth <= 15) {
				ExecuteHamB(Ham_Killed, iVictim, iAttacker, 0);
			} else {
				set_user_health(iVictim, (iHealth - 15));
			}
			
			++g_Zombie_SpitterImpacts[iAttacker];
		}
		
		engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, vecOrigin, 0);
		write_byte(TE_DLIGHT);
		engfunc(EngFunc_WriteCoord, vecOrigin[0]);
		engfunc(EngFunc_WriteCoord, vecOrigin[1]);
		engfunc(EngFunc_WriteCoord, vecOrigin[2]);
		write_byte(25);
		write_byte(0);
		write_byte(255);
		write_byte(0);
		write_byte(2);
		write_byte(0);
		message_end();
		
		set_task(0.1, "setAura", iEnt);
	}
}

public checkOnGround(const iEnt) {
	if(is_valid_ent(iEnt)) {
		if((get_entity_flags(iEnt) & FL_ONGROUND) && fm_get_speed(iEnt) < 10) {
			entity_set_int(iEnt, EV_INT_solid, SOLID_BBOX);
			
			new iFlareEnt = entity_get_edict(iEnt, EV_ENT_euser3);
			
			if(is_valid_ent(iFlareEnt)) {
				remove_entity(iFlareEnt);
			}
			
			makeAcid(iEnt);
			set_task(0.1, "setAura", iEnt);
			
			return;
		}
		
		set_task(0.1, "checkOnGround", iEnt);
	}
}

public makeAcid(const iEnt) {
	new Float:vecOrigin[3];
	entity_get_vector(iEnt, EV_VEC_origin, vecOrigin);
	
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, vecOrigin, 0);
	write_byte(TE_FIREFIELD);
	engfunc(EngFunc_WriteCoord, vecOrigin[0]);
	engfunc(EngFunc_WriteCoord, vecOrigin[1]);
	engfunc(EngFunc_WriteCoord, vecOrigin[2] - 10.0);
	write_short(150);
	write_short(g_SPRITE_BOOMER);
	write_byte(80);
	write_byte(TEFIRE_FLAG_ALPHA | TEFIRE_FLAG_PLANAR | TEFIRE_FLAG_SOMEFLOAT | TEFIRE_FLAG_LOOP);
	write_byte(71);
	message_end();
	
	set_task(7.16, "removeAcid", iEnt);
}

public removeAcid(const iEnt) {
	if(is_valid_ent(iEnt)) {
		remove_entity(iEnt);
	}
}

public fw_Think_TriggerCamera(const iEnt) {
	static id;
	id = getCamOwner(iEnt);
	
	if(!id) {
		return;
	}
	
	static Float:vecUserOrigin[3];
	static Float:vecCameraOrigin[3];
	static Float:vecForward[3];
	static Float:vecVelocity[3];
	
	entity_get_vector(id, EV_VEC_origin, vecUserOrigin);
	
	vecUserOrigin[2] += 45.0;
	
	angle_vector(g_ChargerAngles[id], ANGLEVECTOR_FORWARD, vecForward);
	
	vecCameraOrigin[0] = vecUserOrigin[0] + (-vecForward[0] * 150.0);
	vecCameraOrigin[1] = vecUserOrigin[1] + (-vecForward[1] * 150.0);
	vecCameraOrigin[2] = vecUserOrigin[2] + (-vecForward[2] * 150.0);
	
	engfunc(EngFunc_TraceLine, vecUserOrigin, vecCameraOrigin, IGNORE_MONSTERS, id, 0);
	
	static Float:flFraction;
	get_tr2(0, TR_flFraction, flFraction);
	
	if(flFraction != 1.0) {
		flFraction *= 150.0;
		
		vecCameraOrigin[0] = vecUserOrigin[0] + (-vecForward[0] * flFraction);
		vecCameraOrigin[1] = vecUserOrigin[1] + (-vecForward[1] * flFraction);
		vecCameraOrigin[2] = vecUserOrigin[2] + (-vecForward[2] * flFraction);
	}
	
	entity_set_vector(iEnt, EV_VEC_angles, g_ChargerAngles[id]);
	entity_set_vector(iEnt, EV_VEC_origin, vecCameraOrigin);
	
	entity_set_vector(id, EV_VEC_angles, g_ChargerAngles[id]);
	entity_set_vector(id, EV_VEC_v_angle, g_ChargerAngles[id]);
	
	entity_set_int(id, EV_INT_fixangle, 1);
	
	velocity_by_aim(id, 1000, vecVelocity);
	vecVelocity[2] = 0.0;
	entity_set_vector(id, EV_VEC_velocity, vecVelocity);
}

getCamOwner(const iEnt) {
    static id;
    for(id = 1; id <= g_MaxUsers; ++id) {
        if(g_ChargerEnt[id] == iEnt) {
            return id;
        }
    }
	
    return 0;
}

public clcmd_CTest(const id) {
	if(g_Kiske[id]) {
		new Float:vecAngles[3];
		entity_get_vector(id, EV_VEC_origin, vecAngles);
		
		client_print(id, print_console, "{%f , %f , %f}, ", vecAngles[0], vecAngles[1], vecAngles[2]);
	}
	
	return PLUGIN_HANDLED;
}

public touch__PlayerAll(const id, const ent) {
	if(is_user_alive(id)) {
		if(g_Charger[id] && g_ChargerInCamera[id]) {
			++g_ChargerCountFix[id];
			
			if(g_ChargerCountFix[id] >= 2) {
				new Float:vecOrigin[3];
				entity_get_vector(id, EV_VEC_origin, vecOrigin);
				
				if(g_ChargerCountFix[id] < 1337) {
					new sClassName[32];
					if(!is_user_alive(ent)) {
						entity_get_string(ent, EV_SZ_classname, sClassName, 31);
					
						if(sClassName[4] == '_' && sClassName[5] == 'b' && sClassName[9] == 'k' && sClassName[13] == 'e') {
							set_user_gravity(id, 1.0);
							
							vecOrigin[2] += 15.0;
							entity_set_vector(id, EV_VEC_origin, vecOrigin);
							
							g_ChargerCountFix[id] = 1337;
							
							return;
						}
					}
				}
				
				if(is_user_alive(ent)) {
					if(!g_Tank[ent] && !g_Witch[ent] && !g_Charger[ent]) {
						if(g_Smoker_Victim[ent]) {
							new i;
							for(i = 1; i <= g_MaxUsers; ++i) {
								if(!is_user_alive(i)) {
									continue;
								}
								
								if(!g_Zombie[i]) {
									continue;
								}
								
								if(g_Smoker_Tongue[i] == ent) {
									smokerTongueEnd(i);
									
									set_user_gravity(ent, 1.0);
									g_Smoker_Victim[ent] = 0;
									g_Speed[ent] = (!g_InAdrenaline[ent]) ? 240.0 : 320.0;
									
									set_user_rendering(ent);
									
									ExecuteHamB(Ham_Player_ResetMaxSpeed, ent);
									
									break;
								}
							}
						} else if(g_Smoker[ent]) {
							if(g_Smoker_Tongue[ent]) {
								set_user_gravity(g_Smoker_Tongue[ent], 1.0);
								
								g_Smoker_Victim[g_Smoker_Tongue[ent]] = 0;
								g_Speed[g_Smoker_Tongue[ent]] = (!g_InAdrenaline[g_Smoker_Tongue[ent]]) ? 240.0 : 320.0;
								
								set_user_rendering(g_Smoker_Tongue[ent]);
								
								ExecuteHamB(Ham_Player_ResetMaxSpeed, g_Smoker_Tongue[ent]);
								
								smokerTongueEnd(ent);
							}
						}
						
						new Float:vecVictimOrigin[3];
						new Float:vecSub[3];
						new Float:flMult;
						
						entity_get_vector(ent, EV_VEC_origin, vecVictimOrigin);
						
						if((entity_get_int(ent, EV_INT_bInDuck)) || (entity_get_int(ent, EV_INT_flags) & FL_DUCKING)) {
							vecVictimOrigin[2] += 18.0;
						}
						
						xs_vec_sub(vecVictimOrigin, vecOrigin, vecSub);
						
						flMult = (600.0 - vector_length(vecSub));
						
						vecSub[2] += 1.5;
						
						xs_vec_mul_scalar(vecSub, flMult, vecSub);
						
						entity_set_vector(ent, EV_VEC_velocity, vecSub);
						
						if(!g_Zombie[ent]) {
							ExecuteHam(Ham_TakeDamage, ent, id, id, 100.0, DMG_CRUSH);
							
							++g_Zombie_ChargerImpacts[id];
						}
						
						return;
					}
				}
				
				set_user_gravity(id, 1.0);
				
				g_ChargerInCamera[id] = 0;
				
				if(is_valid_ent(g_ChargerEnt[id])) {
					remove_entity(g_ChargerEnt[id]);
					g_ChargerEnt[id] = 0;
				}
				
				remove_task(id + TASK_CHARGER_CAMERA);
				set_task(0.35, "backCamera", id + TASK_CHARGER_CAMERA);
				
				engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, vecOrigin, 0);
				write_byte(TE_DLIGHT);
				engfunc(EngFunc_WriteCoord, vecOrigin[0]);
				engfunc(EngFunc_WriteCoord, vecOrigin[1]);
				engfunc(EngFunc_WriteCoord, vecOrigin[2]);
				write_byte(25);
				write_byte(128);
				write_byte(128);
				write_byte(128);
				write_byte(30);
				write_byte(20);
				message_end();
				
				engfunc(EngFunc_MessageBegin, MSG_BROADCAST, SVC_TEMPENTITY, vecOrigin, 0);
				write_byte(TE_BREAKMODEL);
				engfunc(EngFunc_WriteCoord, vecOrigin[0]); 
				engfunc(EngFunc_WriteCoord, vecOrigin[1]);
				engfunc(EngFunc_WriteCoord, vecOrigin[2] + 24);
				write_coord(22);
				write_coord(22);
				write_coord(22);
				write_coord(random_num(-50, 100));
				write_coord(random_num(-50, 100));
				write_coord(30);
				write_byte(10);
				write_short(g_MODEL_TANK_ROCK_GIBS);
				write_byte(15);
				write_byte(40);
				write_byte(0x03);
				message_end();
				
				emit_sound(id, CHAN_BODY, g_SOUND_CHARGER_IMPACT[random_num(0, charsmax(g_SOUND_CHARGER_IMPACT))], 1.0, ATTN_NORM, 0, PITCH_NORM);
			}
		}
	}
}

public backCamera(const taskid) {
	smokerBeamRemove(ID_CHARGER_CAMERA);
	
	attach_view(ID_CHARGER_CAMERA, ID_CHARGER_CAMERA);
	
	g_Speed[ID_CHARGER_CAMERA] = 250.0;
	ExecuteHamB(Ham_Player_ResetMaxSpeed, ID_CHARGER_CAMERA);
	
	set_task(random_float(8.0, 10.0), "playSoundCharger", ID_CHARGER_CAMERA + TASK_SOUND, _, _, "b");
}

stock setModelIndex(const id, const value) {
	if (pev_valid(id) != PDATA_SAFE) {
		return;
	}
	
	set_pdata_int(id, OFFSET_MODELINDEX, value, OFFSET_LINUX);
}

public showMenu__ChooseWeapons(const id) {
	if(g_RoundStart) {
		return PLUGIN_HANDLED;
	}
	
	new iMenu;
	iMenu = menu_create("ELIGE TU ARMA", "menu__ChooseWeapons");
	
	if(!g_WeaponsChoosen[0]) {
		menu_additem(iMenu, "M4A1 Carbine", "1");
	} else {
		menu_additem(iMenu, "\dM4A1 Carbine", "1");
	}
	
	if(!g_WeaponsChoosen[1]) {
		menu_additem(iMenu, "AK-47 Kalashnikov", "2");
	} else {
		menu_additem(iMenu, "\dAK-47 Kalashnikov", "2");
	}
	
	if(!g_WeaponsChoosen[2]) {
		menu_additem(iMenu, "IMI Galil", "3");
	} else {
		menu_additem(iMenu, "\dIMI Galil", "3");
	}
	
	if(!g_WeaponsChoosen[3]) {
		menu_additem(iMenu, "Famas", "4");
	} else {
		menu_additem(iMenu, "\dFamas", "4");
	}
	
	menu_setprop(iMenu, MPROP_EXIT, MEXIT_NEVER);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenu, 0);
	
	return PLUGIN_HANDLED;
}

public menu__ChooseWeapons(const id, const menuId, const item) {
	if(!is_user_connected(id)) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	if(g_RoundStart) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[3];
	new iNothing;
	new iItem;
	
	menu_item_getinfo(menuId, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	iItem = str_to_num(sBuffer) - 1;
	
	DestroyLocalMenu(id, menuId);
	
	if(g_WeaponsChoosen[iItem]) {
		colorChat(id, _, "%sEl arma seleccionada ya la eligió un compañero tuyo, elige otra!", TORNEO_PREFIX);
		
		showMenu__ChooseWeapons(id);
		return PLUGIN_HANDLED;
	}
	
	g_WeaponsChoosen[iItem] = 1;
	
	switch(iItem) {
		case 0: giveWeapon(id, "weapon_m4a1", CSW_M4A1);
		case 1: giveWeapon(id, "weapon_ak47", CSW_AK47);
		case 2: giveWeapon(id, "weapon_galil", CSW_GALIL);
		case 3: giveWeapon(id, "weapon_famas", CSW_FAMAS);
	}
	
	return PLUGIN_HANDLED;
}

public giveWeapon(const id, const weaponName[], const weaponId) {
	g_AlreadyBuy[id][0] = 1;
	
	give_item(id, weaponName);
	cs_set_user_bpammo(id, weaponId, 200);
	
	showMenu__ChoosePistol(id);
}

public showMenu__ChoosePistol(const id) {
	if(g_RoundStart) {
		return PLUGIN_HANDLED;
	}
	
	new iMenu;
	iMenu = menu_create("ELIGE TU ARMA", "menu__ChoosePistol");
	
	menu_additem(iMenu, "Desert Eagle .50 AE", "1");
	menu_additem(iMenu, "USP .45 ACP Tactical", "2");
	menu_additem(iMenu, "Dual Elite Berettas", "3");
	
	menu_setprop(iMenu, MPROP_EXIT, MEXIT_NEVER);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenu, 0);
	
	return PLUGIN_HANDLED;
}

public menu__ChoosePistol(const id, const menuId, const item) {
	if(!is_user_connected(id)) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	if(g_RoundStart) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[3];
	new iNothing;
	new iItem;
	
	menu_item_getinfo(menuId, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	iItem = str_to_num(sBuffer);
	
	DestroyLocalMenu(id, menuId);
	
	switch(iItem) {
		case 1: {
			give_item(id, "weapon_deagle");
			cs_set_user_bpammo(id, CSW_DEAGLE, 200);
		}
		case 2: {
			give_item(id, "weapon_usp");
			cs_set_user_bpammo(id, CSW_USP, 200);
		}
		case 3: {
			give_item(id, "weapon_elite");
			cs_set_user_bpammo(id, CSW_ELITE, 200);
		}
	}
	
	g_AlreadyBuy[id][1] = 1;
	
	showMenu__ChooseChainsaw(id);
	
	return PLUGIN_HANDLED;
}

public showMenu__ChooseChainsaw(const id) {
	if(g_RoundStart) {
		return PLUGIN_HANDLED;
	}
	
	new iMenu;
	new sItem[32];
	
	iMenu = menu_create("ELIGE TU ARMA", "menu__ChooseChainsaw");
	
	formatex(sItem, 31, "%sMotosierra [%d]", (g_WeaponsChoosen[4]) ? "\w" : "\d", g_WeaponsChoosen[4]);
	menu_additem(iMenu, sItem, "1");
	
	formatex(sItem, 31, "%sCuchillo [%d]", (g_WeaponsChoosen[5]) ? "\w" : "\d", g_WeaponsChoosen[5]);
	menu_additem(iMenu, sItem, "2");
	
	menu_setprop(iMenu, MPROP_EXIT, MEXIT_NEVER);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenu, 0);
	
	return PLUGIN_HANDLED;
}

public menu__ChooseChainsaw(const id, const menuId, const item) {
	if(!is_user_connected(id)) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	if(g_RoundStart) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[3];
	new iNothing;
	new iItem;
	
	menu_item_getinfo(menuId, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	iItem = str_to_num(sBuffer);
	
	DestroyLocalMenu(id, menuId);
	
	switch(iItem) {
		case 1: {
			if(!g_WeaponsChoosen[4]) {
				colorChat(id, _, "%sNo quedan más motosierras, ya las eligieron otros dos compañeros!", TORNEO_PREFIX);
				
				showMenu__ChooseChainsaw(id);
				return PLUGIN_HANDLED;
			}
			
			--g_WeaponsChoosen[4];
			
			g_Chainsaw[id] = 1;
		}
		case 2: {
			if(!g_WeaponsChoosen[5]) {
				colorChat(id, _, "%sNo quedan más motosierras, ya las eligieron otros dos compañeros!", TORNEO_PREFIX);
				
				showMenu__ChooseChainsaw(id);
				return PLUGIN_HANDLED;
			}
			
			--g_WeaponsChoosen[5];
		}
	}
	
	g_AlreadyBuy[id][2] = 1;
	showMenu__ChoosePacks(id);
	
	return PLUGIN_HANDLED;
}

public showMenu__ChoosePacks(const id) {
	if(g_RoundStart) {
		return PLUGIN_HANDLED;
	}
	
	new iMenu;
	iMenu = menu_create("ELIGE TU EQUIPAMIENTO", "menu__ChoosePacks");
	
	menu_additem(iMenu, "PIPE \yx2 \r-\w PÍLDORA \yx1 \r-\w ADRENALINA \yx1", "1");
	menu_additem(iMenu, "PIPE \yx4 \r-\w ADRENALINA \yx1", "2");
	menu_additem(iMenu, "PÍLDORA \yx2 \r-\w ADRENALINA \yx2", "3");
	menu_additem(iMenu, "PÍLDORA \yx3", "4");
	
	menu_setprop(iMenu, MPROP_EXIT, MEXIT_NEVER);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenu, 0);
	
	return PLUGIN_HANDLED;
}

public menu__ChoosePacks(const id, const menuId, const item) {
	if(!is_user_connected(id)) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	if(g_RoundStart) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[3];
	new iNothing;
	new iItem;
	
	menu_item_getinfo(menuId, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	iItem = str_to_num(sBuffer);
	
	DestroyLocalMenu(id, menuId);
	
	switch(iItem) {
		case 1: {
			give_item(id, "weapon_hegrenade");
			cs_set_user_bpammo(id, CSW_HEGRENADE, 2);
			
			give_item(id, "weapon_flashbang");
			give_item(id, "weapon_smokegrenade");
		}
		case 2: {
			give_item(id, "weapon_hegrenade");
			cs_set_user_bpammo(id, CSW_HEGRENADE, 4);
			
			give_item(id, "weapon_smokegrenade");
		}
		case 3: {
			give_item(id, "weapon_flashbang");
			cs_set_user_bpammo(id, CSW_FLASHBANG, 2);
			
			give_item(id, "weapon_smokegrenade");
			cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 2);
		}
		case 4: {
			give_item(id, "weapon_flashbang");
			cs_set_user_bpammo(id, CSW_FLASHBANG, 3);
		}
	}
	
	g_AlreadyBuy[id][3] = 1;
	
	colorChat(0, CT, "%s!t%s!y está listo para jugar!", TORNEO_PREFIX, g_UserName[id]);
	return PLUGIN_HANDLED;
}

public clcmd_Weapons(const id) {
	if(g_Zombie[id]) {
		return PLUGIN_HANDLED;
	}
	
	if(g_AlreadyBuy[id][3]) {
		colorChat(id, _, "%sYa compraste todo lo necesario para jugar!", TORNEO_PREFIX);
	} else if(g_AlreadyBuy[id][2]) {
		showMenu__ChoosePacks(id);
	} else if(g_AlreadyBuy[id][1]) {
		showMenu__ChooseChainsaw(id);
	} else if(g_AlreadyBuy[id][0]) {
		showMenu__ChoosePistol(id);
	} else {
		showMenu__ChooseWeapons(id);
	}
	
	return PLUGIN_HANDLED;
}

stock hamStripWeapons(const id, const weaponName[], const weaponId) {
	if(!equal(weaponName, "weapon_", 7)) {
		return 0;
	}
	
	if(!weaponId) {
		return 0;
	}
	
	static iWeaponEnt;
	iWeaponEnt = -1;
	
	while((iWeaponEnt = engfunc(EngFunc_FindEntityByString, iWeaponEnt, "classname", weaponName)) && entity_get_edict(iWeaponEnt, EV_ENT_owner) != id) { }
	
	if(!iWeaponEnt) {
		return 0;
	}
	
	if(g_CurrentWeapon[id] == weaponId) {
		ExecuteHamB(Ham_Weapon_RetireWeapon, iWeaponEnt);
	}
	
	if(!ExecuteHamB(Ham_RemovePlayerItem, id, iWeaponEnt)) {
		return 0;
	}
	
	ExecuteHamB(Ham_Item_Kill, iWeaponEnt);
	
	set_pev(id, pev_weapons, pev(id, pev_weapons) & ~(1 << weaponId));
	
	return 1;
}

public effectAdrenalineStart(const taskid) {
	if(!g_InAdrenaline[ID_ADRENALINA]) {
		remove_task(taskid);
		return;
	}
	
	static vecOrigin[3];
	get_user_origin(ID_ADRENALINA, vecOrigin);
	
	message_begin(MSG_PVS, SVC_TEMPENTITY, vecOrigin);
	write_byte(TE_DLIGHT);
	write_coord(vecOrigin[0]);
	write_coord(vecOrigin[1]);
	write_coord(vecOrigin[2]);
	write_byte(50);
	write_byte(0);
	write_byte(0);
	write_byte(200);
	write_byte(2);
	write_byte(0);
	message_end();
	
	message_begin(MSG_PVS, SVC_TEMPENTITY, vecOrigin);
	write_byte(TE_IMPLOSION);
	write_coord(vecOrigin[0]);
	write_coord(vecOrigin[1]);
	write_coord(vecOrigin[2]);
	write_byte(64);
	write_byte(20);
	write_byte(1);
	message_end();
}

new const g_ADRENALINE_WEAPONS[][] = {"weapon_m4a1", "weapon_ak47", "weapon_galil", "weapon_famas", "weapon_deagle", "weapon_usp", "weapon_elite"};
new const g_ADRENALINE_WEAPONS_ID[] = {CSW_M4A1, CSW_AK47, CSW_GALIL, CSW_FAMAS, CSW_DEAGLE, CSW_USP, CSW_ELITE};
new const g_ADRENALINE_AMMO[] = {30, 30, 35, 25, 7, 12, 30};

public effectAdrenalineEnd(const taskid) {	
	g_InAdrenaline[ID_ADRENALINA] = 0;
	
	new i;
	new iWeaponId;
	
	for(i = 0; i < 7; ++i) {
		if(user_has_weapon(ID_ADRENALINA, g_ADRENALINE_WEAPONS_ID[i])) {
			iWeaponId = fm_find_ent_by_owner(-1, g_ADRENALINE_WEAPONS[i], ID_ADRENALINA);
			
			cs_set_weapon_ammo(iWeaponId, g_ADRENALINE_AMMO[i]);
			cs_set_user_bpammo(ID_ADRENALINA, g_ADRENALINE_WEAPONS_ID[i], 200);
		}
	}
	
	g_Speed[ID_ADRENALINA] = 240.0;
	ExecuteHamB(Ham_Player_ResetMaxSpeed, ID_ADRENALINA);
}

public event_AmmoX(const id) {
	static iType;
	iType = read_data(1);
	
	if(iType >= sizeof(AMMO_WEAPON)) {
		return;
	}
	
	static iWeapon;
	iWeapon = AMMO_WEAPON[iType];
	
	if(MAX_BPAMMO[iWeapon] <= 2) {
		return;
	}
	
	static iAmount;
	iAmount = read_data(2);
	
	if(iAmount < 200) {
		static sArgs[1];
		sArgs[0] = iWeapon;
		
		set_task(0.1, "refillBPAmmo", id, sArgs, 1);
	}
}

public refillBPAmmo(const args[], const id) {
	if(!is_user_alive(id)) {
		return;
	}
	
	set_msg_block(g_Message_AmmoPickup, BLOCK_ONCE);
	ExecuteHamB(Ham_GiveAmmo, id, MAX_BPAMMO[args[0]], AMMO_TYPE[args[0]], MAX_BPAMMO[args[0]]);
}


public message__CurWeapon(const msgId, const msgDest, const id) {
	if(get_msg_arg_int(CurWeapon_IsActive) && g_InAdrenaline[id]) {
		new iMaxClip;
		iMaxClip = MAX_BPAMMO[get_msg_arg_int(CurWeapon_WeaponID)];
		
		if(iMaxClip > 2 && get_msg_arg_int(CurWeapon_ClipAmmo) < iMaxClip) {
			new iWeapon;
			iWeapon = get_pdata_cbase(id, OFFSET_ACTIVE_ITEM);
			
			if(iWeapon > 0) {
				set_pdata_int(iWeapon, OFFSET_CLIPAMMO, iMaxClip, OFFSET_LINUX_WEAPONS);
				set_pdata_int(iWeapon, OFFSET_CLIENT_CLIPAMMO, iMaxClip, OFFSET_LINUX_WEAPONS);
				
				set_msg_arg_int(CurWeapon_ClipAmmo, ARG_BYTE, iMaxClip);
			}
		}
	}
}

public fw_SetModel(const entity, const model[]) {
	if(strlen(model) < 8) {
		return FMRES_IGNORED;
	}
	
	if(model[7] != 'w' || model[8] != '_') {
		return FMRES_IGNORED;
	}
	
	static Float:flDamageTime;
	flDamageTime = entity_get_float(entity, EV_FL_dmgtime);
	
	if(flDamageTime == 0.0) {
		return FMRES_IGNORED;
	}
	
	static id;
	id = entity_get_edict(entity, EV_ENT_owner);
	
	if(model[9] == 'h') {
		fm_set_rendering(entity, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 4);
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
		write_byte(TE_BEAMFOLLOW);
		write_short(entity);
		write_short(g_SPRITE_TRAIL);
		write_byte(10);
		write_byte(4);
		write_byte(255);
		write_byte(0);
		write_byte(0);
		write_byte(200);
		message_end();
		
		replaceWeaponModels(id, CSW_HEGRENADE);
		
		entity_set_int(entity, EV_INT_flTimeStepSound, 1337);
		
		entity_set_model(entity, g_MODEL_W_PIPE);
		
		entity_set_int(entity, EV_INT_solid, SOLID_NOT);
		
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}

public fw_Think_Grenade(const entity) {
	if(!pev_valid(entity)) {
		return HAM_IGNORED;
	}
	
	static Float:flDamageTime;
	static Float:flCurrentTime;
	
	flDamageTime = entity_get_float(entity, EV_FL_dmgtime);
	flCurrentTime = get_gametime();
	
	if(flDamageTime > flCurrentTime) {
		return HAM_IGNORED;
	}
	
	switch(entity_get_int(entity, EV_INT_flTimeStepSound)) {
		case 1337: {
			if(get_entity_flags(entity) & FL_ONGROUND) {
				entity_set_int(entity, EV_INT_solid, SOLID_BBOX);
			}
			
			static iDuration;
			iDuration = entity_get_int(entity, EV_INT_flSwimTime);
			
			if(iDuration > 0) {
				static Float:vecEntOrigin[3];
				entity_get_vector(entity, EV_VEC_origin, vecEntOrigin);
				
				static Float:vecOrigin[3];
				static Float:flDistance;
				
				if(iDuration == 1) {
					new id;
					id = entity_get_edict(entity, EV_ENT_owner);
					
					if(!is_user_connected(id)) {
						id = 0;
					}
					
					emit_sound(entity, CHAN_WEAPON, g_SOUND_BOOMER_EXPLODE[1], 1.0, ATTN_NORM, 0, PITCH_HIGH);
					
					engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, vecEntOrigin, 0);
					write_byte(TE_DLIGHT);
					engfunc(EngFunc_WriteCoord, vecEntOrigin[0]);
					engfunc(EngFunc_WriteCoord, vecEntOrigin[1]);
					engfunc(EngFunc_WriteCoord, vecEntOrigin[2]);
					write_byte(50);
					write_byte(255);
					write_byte(0);
					write_byte(0);
					write_byte(5);
					write_byte(5);
					message_end();
					
					engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, vecEntOrigin, 0);
					write_byte(TE_EXPLOSION);
					engfunc(EngFunc_WriteCoord, vecEntOrigin[0]);
					engfunc(EngFunc_WriteCoord, vecEntOrigin[1]);
					engfunc(EngFunc_WriteCoord, vecEntOrigin[2] + 5.0);
					write_short(g_SPRITE_PIPE);
					write_byte(50);
					write_byte(35);
					write_byte(0);
					message_end();
					
					new i;
					for(i = 1; i <= g_MaxUsers; ++i) {
						if(!is_user_alive(i)) {
							continue;
						}
						
						if(!g_Zombie[i]) {
							continue;
						}
						
						if(g_Charger[i] || g_Tank[i] || g_Witch[i]) {
							continue;
						}
						
						if(g_Kiske[i]) {
							continue;
						}
						
						entity_get_vector(i, EV_VEC_origin, vecOrigin);
						
						flDistance = get_distance_f(vecEntOrigin, vecOrigin);
						
						if(flDistance >= 1000.0) {
							continue;
						}
						
						if(!id) {
							id = i;
						}
						
						ExecuteHamB(Ham_Killed, i, id, 0);
					}
					
					remove_entity(entity);
					return HAM_SUPERCEDE;
				}
				
				static Float:vecDirection[3];
				static i;
				
				engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, vecEntOrigin, 0);
				write_byte(TE_DLIGHT);
				engfunc(EngFunc_WriteCoord, vecEntOrigin[0]);
				engfunc(EngFunc_WriteCoord, vecEntOrigin[1]);
				engfunc(EngFunc_WriteCoord, vecEntOrigin[2]);
				write_byte(50);
				write_byte(255);
				write_byte(0);
				write_byte(0);
				write_byte(2);
				write_byte(0);
				message_end();
				
				for(i = 1; i <= g_MaxUsers; ++i) {
					if(!is_user_alive(i)) {
						continue;
					}
					
					if(!g_Zombie[i]) {
						continue;
					}
					
					if(g_Boomer[i] || g_Smoker[i] || g_Spitter[i] || g_Charger[i] || g_Hunter[i] || g_Tank[i] || g_Witch[i]) {
						continue;
					}
					
					if(g_Kiske[i]) {
						continue;
					}
					
					entity_get_vector(i, EV_VEC_origin, vecOrigin);
					
					flDistance = get_distance_f(vecEntOrigin, vecOrigin);
					
					if(flDistance >= 1000.0) {
						continue;
					}
					
					xs_vec_sub(vecOrigin, vecEntOrigin, vecDirection);
					xs_vec_mul_scalar(vecDirection, -5.0, vecDirection);
					
					entity_set_vector(i, EV_VEC_velocity, vecDirection);
				}
				
				entity_set_int(entity, EV_INT_flSwimTime, --iDuration);
				entity_set_float(entity, EV_FL_dmgtime, flCurrentTime + 0.1);
			} else {
				emit_sound(entity, CHAN_WEAPON, g_SOUND_PIPE, 1.0, ATTN_NORM, 0, PITCH_NORM);
				
				entity_set_int(entity, EV_INT_flSwimTime, 72);
				entity_set_float(entity, EV_FL_dmgtime, flCurrentTime + 0.1);
			}
		}
	}
	
	return HAM_IGNORED;
}

public clcmd_BlockCommand(const id) {
	return PLUGIN_HANDLED;
}

stock entitySetAim(const ent1, const ent2, anglefix = 0) {
	new Float:vecOffset[3];
	new Float:vecEnt1Origin[3];
	new Float:vecEnt2Origin[3];
	new Float:vecEnt1Angles[3];
	new Float:vecEnt2Angles[3];
	new Float:fHipotenusa;
	new x;
	new y;
	new z;
	
	vecOffset = Float:{0.0, 0.0, 0.0};
	
	entity_get_vector(ent1, EV_VEC_origin, vecEnt1Origin);
	entity_get_vector(ent2, EV_VEC_origin, vecEnt2Origin);
	
	entity_get_vector(ent2, EV_VEC_v_angle, vecEnt2Angles);
	
	vecEnt2Origin[0] += vecOffset[0] * (((floatabs(vecEnt2Angles[1]) - 90) / 90) * -1);
	vecEnt2Origin[1] += vecOffset[1] * (1 - (floatabs(90 - floatabs(vecEnt2Angles[1])) / 90));
	vecEnt2Origin[2] += vecOffset[2];
	
	vecEnt2Origin[0] -= vecEnt1Origin[0];
	vecEnt2Origin[1] -= vecEnt1Origin[1];
	vecEnt2Origin[2] -= vecEnt1Origin[2];
	
	fHipotenusa = floatsqroot((vecEnt2Origin[0] * vecEnt2Origin[0]) + (vecEnt2Origin[1] * vecEnt2Origin[1]));
	
	x = 0;
	y = 0;
	z = 0;
	
	if(vecEnt2Origin[0] >= 0.0) 
		x = 1;
	
	if(vecEnt2Origin[1] >= 0.0) 
		y = 1;
	
	if(vecEnt2Origin[2] >= 0.0)
		z = 1;
	
	if(vecEnt2Origin[0] == 0.0) 
		vecEnt2Origin[0] = 0.000001;
		
	if(vecEnt2Origin[1] == 0.0) 
		vecEnt2Origin[1] = 0.000001;
		
	if(vecEnt2Origin[2] == 0.0) 
		vecEnt2Origin[2] = 0.000001;
	
	vecEnt2Origin[0] = floatabs(vecEnt2Origin[0]);
	vecEnt2Origin[1] = floatabs(vecEnt2Origin[1]);
	vecEnt2Origin[2] = floatabs(vecEnt2Origin[2]);
	
	vecEnt1Angles[1] = floatatan2(vecEnt2Origin[1], vecEnt2Origin[0], degrees);
	
	if(x && !y)
		vecEnt1Angles[1] = -1 * (180 - vecEnt1Angles[1]);
	
	if(!x && !y)
		vecEnt1Angles[1] = (180 - vecEnt1Angles[1]);
	if(!x && y)
		vecEnt1Angles[1] = vecEnt1Angles[1] = 180 + floatabs(180 - vecEnt1Angles[1]);
	
	if(x && !y)
		vecEnt1Angles[1] = vecEnt1Angles[1] = 0 - floatabs(-180 - vecEnt1Angles[1]);
	
	if(!x && !y)
		vecEnt1Angles[1] *= -1;
	
	while(vecEnt1Angles[1] > 180.0)
		vecEnt1Angles[1] -= 180;
	
	while(vecEnt1Angles[1] < -180.0)
		vecEnt1Angles[1] += 180;
	
	if(vecEnt1Angles[1] == 180.0 || vecEnt1Angles[1] == -180.0)
		vecEnt1Angles[1] = -179.999999;
	
	vecEnt1Angles[0] = floatasin(vecEnt2Origin[2] / fHipotenusa, degrees);
	
	if(anglefix == 3 && z) {
		vecEnt1Angles[0] *= -1;
	}
	
	entity_set_int(ent1, EV_INT_fixangle, 1);
	
	if(anglefix == 1) {
		vecEnt1Angles[0] = 0.0;
	}
	
	entity_set_vector(ent1, EV_VEC_v_angle, vecEnt1Angles);
	entity_set_vector(ent1, EV_VEC_angles, vecEnt1Angles);
	
	entity_set_int(ent1, EV_INT_fixangle, 1);
	
	return 1;
}

public message__RoundTime() {
	message_begin(MSG_BROADCAST, g_Message_RoundTime);
	write_short(g_RoundTime);
	message_end();
}

new g_CountDown;

public concmd_Start(const id) {
	if(g_Kiske[id]) {
		g_CountDown = 10;
		countDownMatch();
	}
	
	return PLUGIN_HANDLED;
}

public countDownMatch() {
	if(!g_CountDown) {
		startMatch();
		return;
	}
	
	new sNum[15];
	num_to_word(g_CountDown, sNum, 14);
	
	client_cmd(0, "spk ^"vox/%s^"", sNum);
	
	client_print(0, print_center, "%d", g_CountDown);
	
	--g_CountDown;
	
	set_task(1.0, "countDownMatch");
}

public startMatch() {
	g_Team_Damage = 0;
	g_Team_ZombiesKill = 0;
	g_Team_ZombiesSpecialKill = 0;
	g_Team_DamageReceive = 0;
	g_Team_DamageWithPistol = 0;
	g_Team_DamageWithChainsaw = 0;
	g_Team_Shoots = 0;
	g_Team_ShootsHS = 0;
	g_Team_HuntersKill = 0;
	g_Team_BoomersKill = 0;
	g_Team_SmokersKill = 0;
	g_Team_ChargersKill = 0;
	g_Team_SpittersKill = 0;
	g_Team_WitchsKill = 0;
	g_Team_TanksKill = 0;
	
	g_PhaseMinutes = 7;
	g_PhaseSeconds = 0;
	
	client_print(0, print_center, "GL & HF");
	
	new const Float:vecOrigin[4][3] = {
		{-133.267700, -1933.640869, 1206.251953},
		{-143.442230, -1554.667846, 1206.251953},
		{-145.224151, -1186.959716, 1206.251953},
		{-146.947631, -871.750732, 1206.251953}
	}
	
	new i;
	new j = 0;
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(!is_user_alive(i)) {
			continue;
		}
		
		if(g_Zombie[i]) {
			continue;
		}
		
		entity_set_vector(i, EV_VEC_velocity, Float:{0.0, 0.0, 0.0});
		entity_set_vector(i, EV_VEC_origin, vecOrigin[j]);
		
		++j;
		
		if(j == 4) {
			break;
		}
	}
	
	g_RoundStart = 1;
	g_RoundTime = 1;
	
	new iEnt;
	iEnt = create_entity("info_target");
	
	if(is_valid_ent(iEnt)) {
		entity_set_string(iEnt, EV_SZ_classname, "entRoundTimeCount");
		entity_set_float(iEnt, EV_FL_nextthink, THINK_ROUNDTIME);
		
		register_think("entRoundTimeCount", "think__RoundTime");
	}
}

public think__RoundTime(const ent) {
	static i;
	static sHealth[15];
	static sSeconds[6];
	static sMinutes[6];
	
	formatex(sSeconds, 5, "%s%d", (g_PhaseSeconds >= 10) ? "" : "0", g_PhaseSeconds);
	formatex(sMinutes, 5, "%s%d", (g_PhaseMinutes < 10) ? "0" : "", g_PhaseMinutes);
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(is_user_alive(i)) {
			addDot(get_user_health(i), sHealth, 14)
			
			set_hudmessage(255, 255, 255, -1.0, 0.02, 0, 6.0, 1.1, 0.0, 0.0, -1);
			ShowSyncHudMsg(i, g_Hud_Perm, "FASE %d: %s:%s^nHP: %s", g_PHASE, sMinutes, sSeconds, sHealth);
		}
	}
	
	--g_PhaseSeconds;
	
	if(g_PhaseSeconds == -1) {
		--g_PhaseMinutes;
		
		if(g_PhaseMinutes >= 0) {
			g_PhaseSeconds = 59;
		} else {
			++g_PHASE;
			
			if(g_PHASE != 4) {
				g_PhaseMinutes = 6;
				g_PhaseSeconds = 59;
			} else {
				g_PhaseMinutes = 38;
				g_PhaseSeconds = 59;
			}
		}
	} else if(g_PhaseSeconds == 15 && !g_PhaseMinutes) {
		for(i = 1; i <= g_MaxUsers; ++i) {
			if(g_Kiske[i]) {
				colorChat(i, _, "%s!gEN 15 SEGUNDOS HAY QUE ROMPER LA PARED", TORNEO_PREFIX);
				colorChat(i, _, "%s!gEN 15 SEGUNDOS HAY QUE ROMPER LA PARED", TORNEO_PREFIX);
				colorChat(i, _, "%s!gEN 15 SEGUNDOS HAY QUE ROMPER LA PARED", TORNEO_PREFIX);
				colorChat(i, _, "%s!gEN 15 SEGUNDOS HAY QUE ROMPER LA PARED", TORNEO_PREFIX);
				
				break;
			}
		}
	}
	
	++g_RoundTime;
	
	message__RoundTime();
	
	if(!(g_RoundTime % 60)) {
		g_ExtraHealth += 10;
	}
	
	entity_set_float(ent, EV_FL_nextthink, THINK_ROUNDTIME);
}

stock addDot(const number, sOutPut[], const len) {
	new sTemp[15];
	new iOutputPos;
	new iNumPos;
	new iNumLen = num_to_str(number, sTemp, 14);
	
	while((iNumPos < iNumLen) && (iOutputPos < len)) {
		sOutPut[iOutputPos++] = sTemp[iNumPos++];
		
		if((iNumLen - iNumPos) && !((iNumLen - iNumPos) % 3))
			sOutPut[iOutputPos++] = '.';
	}
	
	sOutPut[iOutputPos] = EOS;
	
	return iOutputPos;
}

stock isHullVacant(const Float:origin[3], const hull) {
	engfunc(EngFunc_TraceHull, origin, origin, 0, hull, 0, 0);
	
	if(!get_tr2(0, TR_StartSolid) && !get_tr2(0, TR_AllSolid) && get_tr2(0, TR_InOpen)) {
		return 1;
	}
	
	return 0;
}

stock isUserStuck(const id, const Float:origin[3]) {
	engfunc(EngFunc_TraceHull, origin, origin, 0, (entity_get_int(id, EV_INT_flags) & FL_DUCKING) ? HULL_HEAD : HULL_HUMAN, id, 0);
	
	if(get_tr2(0, TR_StartSolid) || get_tr2(0, TR_AllSolid) || !get_tr2(0, TR_InOpen)) {
		return 1;
	}
	
	return 0;
}

public clcmd_SetSpecialRespawn(const id) {
	if(g_Kiske[id]) {
		entity_get_vector(id, EV_VEC_origin, g_SpecialRespawnOrigin);
		
		client_print(id, print_center, "RESPAWN ESPECIAL");
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_Nightvision(const id) {
	if(g_Kiske[id]) {
		showMenu__ReviveUsers(id);
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__ReviveUsers(const id) {
	new sPosition[2];
	new iMenuId;
	new i;
	
	iMenuId = menu_create("REVIVIR USUARIO", "menu__ReviveUsers");
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(!is_user_connected(i)) {
			continue;
		}
		
		if(g_NextZombie[i] < ZOMBIE_WITCH) {
			continue;
		}
		
		sPosition[0] = i;
		sPosition[1] = 0;
		
		menu_additem(iMenuId, g_UserName[i], sPosition);
	}
	
	if(menu_items(iMenuId) <= 0) {
		colorChat(id, _, "%sNo hay usuarios disponibles para mostrar en el menú.", TORNEO_PREFIX);
		
		DestroyLocalMenu(id, iMenuId);
		return;
	}
	
	menu_setprop(iMenuId, MPROP_NEXTNAME, "SIGUIENTE");
	menu_setprop(iMenuId, MPROP_BACKNAME, "ATRÁS");
	menu_setprop(iMenuId, MPROP_EXITNAME, "SALIR");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, 0);
}

public menu__ReviveUsers(const id, const menuid, const item) {
	if(!is_user_connected(id)) {
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	new iNothing;
	new sItem[2];
	new iUser;
	
	menu_item_getinfo(menuid, item, iNothing, sItem, charsmax(sItem), _, _, iNothing);
	iUser = sItem[0];
	
	if(is_user_connected(iUser)) {
		if(!is_user_alive(iUser)) {
			ExecuteHamB(Ham_CS_RoundRespawn, iUser);
		} else {
			colorChat(id, _, "%sEl usuario seleccionado se está vivo.", TORNEO_PREFIX);
		}
	} else {
		colorChat(id, _, "%sEl usuario seleccionado se ha desconectado.", TORNEO_PREFIX);
	}
	
	DestroyLocalMenu(id, menuid);
	
	showMenu__ReviveUsers(id);
	return PLUGIN_HANDLED;
}

// public concmd_Reset(const id) {
	// if(g_Kiske[id]) {
		// g_RespawnCount = 0;
		// g_SetRespawnCount = 0;
		
		// client_print(id, print_center, "SE REINICIARON LOS RESPAWNS");
	// }
	
	// return PLUGIN_HANDLED;
// }

public concmd_Kill(const id) {
	if(g_Kiske[id]) {
		g_ZombiesRespawn = 0;
		
		new i;
		for(i = 1; i <= g_MaxUsers; ++i) {
			if(!is_user_alive(i)) {
				continue;
			}
			
			if(g_Zombie[i] && !g_Kiske[i]) {
				user_silentkill(i);
			}
		}
	}
	
	return PLUGIN_HANDLED;
}

public delayKill(const id) {
	if(is_user_alive(id)) {
		user_silentkill(id);
		
		colorChat(id, _, "%sHas sido asesinado debido a que renaciste demasiado lejos de los humanos!", TORNEO_PREFIX);
	}
	
	new i;
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(g_Kiske[i]) {
			colorChat(i, TERRORIST, "%s!tUn usuario fue asesinado debido a que no hay más lugar para renacer!", TORNEO_PREFIX);
			colorChat(i, TERRORIST, "%s!tUn usuario fue asesinado debido a que no hay más lugar para renacer!", TORNEO_PREFIX);
			colorChat(i, TERRORIST, "%s!tUn usuario fue asesinado debido a que no hay más lugar para renacer!", TORNEO_PREFIX);
			colorChat(i, TERRORIST, "%s!tUn usuario fue asesinado debido a que no hay más lugar para renacer!", TORNEO_PREFIX);
			
			break;
		}
	}
}

public message__WeapPickup(const msg_id, const msg_dest, const msg_entity) {
	if(g_Zombie[msg_entity]) {
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_CONTINUE;
}

public message__AmmoPickup(const msg_id, const msg_dest, const msg_entity) {
	if(g_Zombie[msg_entity]) {
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_CONTINUE;
}

public UpdateClientData_Post(const id, const sendWeapon, const cdHandle) {
	if(!is_user_alive(id)) {
		return FMRES_IGNORED;
	}
	
	if(!g_Smoker_Victim[id]) {
		return FMRES_IGNORED;
	}
	
	set_cd(cdHandle, CD_ID, 0);
	
	return FMRES_HANDLED;
}

public clcmd_Noclip(const id) {
	if(g_Kiske[id]) {
		if(!get_user_noclip(id)) {
			set_user_noclip(id, 1);
			set_user_godmode(id, 1);
			
			strip_user_weapons(id);
			
			entity_set_int(id, EV_INT_rendermode, kRenderTransAlpha);
			entity_set_float(id, EV_FL_renderamt, 0.0);
			
			entity_set_int(id, EV_INT_solid, SOLID_NOT);
		} else {
			set_user_noclip(id, 0);
			set_user_godmode(id, 0);
			set_user_rendering(id);
			
			entity_set_int(id, EV_INT_solid, SOLID_BBOX);
		}
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_Say(const id) {
	if(!is_user_connected(id)) {
		return PLUGIN_HANDLED;
	}
	
	static sMessage[191];
	
	read_args(sMessage, 190);
	remove_quotes(sMessage);
	
	replace_all(sMessage, 190, "%", "");
	replace_all(sMessage, 190, "!y", "");
	replace_all(sMessage, 190, "!t", "");
	replace_all(sMessage, 190, "!g", "");
	
	if(equal(sMessage, "") || sMessage[0] == '/' || sMessage[0] == '@' || sMessage[0] == '!') {
		return PLUGIN_HANDLED;
	}
	
	static iTeam;
	iTeam = getUserTeam(id);
	
	if(!g_Kiske[id]) {
		if(iTeam != FM_CS_TEAM_T && iTeam != FM_CS_TEAM_CT) {
			if(g_AccountLogged[id]) {
				format(sMessage, 190, "!y(ESPECTADOR)!t %s !y: %s", g_UserName[id], sMessage);
			} else {
				format(sMessage, 190, "!y(SIN IDENTIFICARSE)!t %s !y: %s", g_UserName[id], sMessage);
			}
			
			iTeam = 3;
		} else {
			format(sMessage, 190, "%s!t%s!y : %s", (is_user_alive(id)) ? "" : "!y*DEAD* ", g_UserName[id], sMessage);
		}
	} else {
		format(sMessage, 190, "%s!g%s!y : %s", (is_user_alive(id)) ? "" : "!y*DEAD* ", g_UserName[id], sMessage);
	}
	
	colorChat(0, iTeam, sMessage);
	
	return PLUGIN_HANDLED;
}

public clcmd_SayTeam(const id) {
	if(!is_user_connected(id)) {
		return PLUGIN_HANDLED;
	}
	
	static sMessage[191];
	
	read_args(sMessage, 190);
	remove_quotes(sMessage);
	
	replace_all(sMessage, 190, "%", "");
	replace_all(sMessage, 190, "!y", "");
	replace_all(sMessage, 190, "!t", "");
	replace_all(sMessage, 190, "!g", "");
	
	if(equal(sMessage, "") || sMessage[0] == '/' || sMessage[0] == '@' || sMessage[0] == '!') {
		return PLUGIN_HANDLED;
	}
	
	static iTeam;
	iTeam = getUserTeam(id);
	
	if(iTeam != FM_CS_TEAM_T && iTeam != FM_CS_TEAM_CT) {
		if(g_AccountLogged[id]) {
			format(sMessage, 190, "!y(ESPECTADOR)!t %s !y: %s", g_UserName[id], sMessage);
		} else {
			format(sMessage, 190, "!y(SIN IDENTIFICARSE)!t %s !y: %s", g_UserName[id], sMessage);
		}
		
		iTeam = 3;
	} else {
		format(sMessage, 190, "%s!t%s %s!y : %s", (is_user_alive(id)) ? "" : "!y*DEAD* ", (g_Zombie[id]) ? "[ZOMBIE]" : "[HUMANO]", g_UserName[id], sMessage);
	}
	
	new i;
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(!is_user_connected(i)) {
			continue;
		}
		
		if(g_Kiske[i]) {
			colorChat(i, iTeam, sMessage);
			continue;
		}
		
		if(iTeam == getUserTeam(i)) {
			colorChat(i, iTeam, sMessage);
		}
	}
	
	return PLUGIN_HANDLED;
}

public fw_ClientKill(const id) {
	if(!g_Kiske[id]) {
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}

public message__ShowMenu(const msgId, const destId, const id) {
	static sMenuCode[21];
	get_msg_arg_string(4, sMenuCode, charsmax(sMenuCode));
	
	if(equal(sMenuCode, FIRST_JOIN_MSG) || equal(sMenuCode, FIRST_JOIN_MSG_SPEC)) {
		if(getUserTeam(id) == FM_CS_TEAM_UNASSIGNED) {
			new sArgs[1];
			sArgs[0] = msgId;
			
			set_task(0.1, "__AutoJoinToSpec", id, sArgs, sizeof(sArgs));
			
			return PLUGIN_HANDLED;
		}
	}
	
	return PLUGIN_CONTINUE;
}

public message__VGUIMenu(const msgId, const destId, const id) {
	if(get_msg_arg_int(1) != 2) {
		return PLUGIN_CONTINUE;
	}
	
	if(getUserTeam(id) == FM_CS_TEAM_UNASSIGNED) {
		new sArgs[1];
		sArgs[0] = msgId;
		
		set_task(0.1, "__AutoJoinToSpec", id, sArgs, sizeof(sArgs));
	}
	
	return PLUGIN_HANDLED;
}

public __AutoJoinToSpec(const sArgs[1], const id) {
	if(!is_user_connected(id)) {
		return;
	}
	
	new iMsgBlock = get_msg_block(sArgs[0]);
	set_msg_block(sArgs[0], BLOCK_SET);
	
	g_AllowChangeTeam[id] = 1;
	
	set_pdata_int(id, 125, (get_pdata_int(id, 125, OFFSET_LINUX) & ~(1<<8)), OFFSET_LINUX);
	engclient_cmd(id, "jointeam", "6");
	
	g_AllowChangeTeam[id] = 0;
	
	set_msg_block(sArgs[0], iMsgBlock);
}

public message__TextMsg() {
	static sMsg[22];
	get_msg_arg_string(2, sMsg, charsmax(sMsg));
	
	if(get_msg_args() == 5 && (get_msg_argtype(5) == ARG_STRING)) {
		get_msg_arg_string(5, sMsg, charsmax(sMsg));
		
		if(equal(sMsg, "#Fire_in_the_hole")) {
			return PLUGIN_HANDLED;
		}
	} else if(get_msg_args() == 6 && (get_msg_argtype(6) == ARG_STRING)) {
		get_msg_arg_string(6, sMsg, charsmax(sMsg));
		
		if(equal(sMsg, "#Fire_in_the_hole")) {
			return PLUGIN_HANDLED;
		}
	}
	
	return PLUGIN_CONTINUE;
}

public message__SendAudio() {
	static sAudio[32];
	get_msg_arg_string(2, sAudio, charsmax(sAudio));
	
	if(	sAudio[0] == '%' &&
		sAudio[1] == '!' &&
		sAudio[2] == 'M' &&
		sAudio[3] == 'R' &&
		sAudio[4] == 'A' &&
		sAudio[5] == 'D' &&
		sAudio[6] == '_' &&
		sAudio[7] == 'F' &&
		sAudio[8] == 'I' &&
		sAudio[9] == 'R' &&
		sAudio[10] == 'E' &&
		sAudio[11] == 'I' &&
		sAudio[12] == 'N' &&
		sAudio[13] == 'H' &&
		sAudio[14] == 'O' &&
		sAudio[15] == 'L' &&
		sAudio[16] == 'E')
		return PLUGIN_HANDLED;
	
	return PLUGIN_CONTINUE;
}

public message__Health(const msg_id, const msg_dest, const msg_entity) {
	static iHealth;
	iHealth = get_msg_arg_int(1);
	
	if(iHealth < 256) {
		return;
	}
	
	if((iHealth % 256 == 0) && is_user_alive(msg_entity)) {
		set_user_health(msg_entity, get_user_health(msg_entity) + 1);
	}
	
	set_msg_arg_int(1, get_msg_argtype(1), 255);
}

public concmd_Respawn(const id) {
	if(g_Kiske[id]) {
		new sArg1[15];
		read_argv(1, sArg1, 14);
		
		g_RespawnCount = 0;
		g_RESPAWN_PHASE = str_to_num(sArg1);
		
		client_print(id, print_center, "RESPAWN EN FASE %d", g_RESPAWN_PHASE);
	}
	
	return PLUGIN_HANDLED;
}

public fw_TouchWeapon(const weapon, const id) {
	if(!is_user_alive(id)) {
		return HAM_IGNORED;
	}
	
	if(g_Zombie[id]) {
		return HAM_SUPERCEDE;
	}
	
	return HAM_IGNORED;
}