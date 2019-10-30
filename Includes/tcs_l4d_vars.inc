/* ========================================
======== VARIABLES - ENUMS - OFFSETS ======
======================================== */

const PDATA_SAFE = 2;
const OFFSET_LINUX_WEAPONS = 4;
const OFFSET_LINUX = 5;
const OFFSET_WEAPONOWNER = 41;
const OFFSET_ID = 43;
const OFFSET_KNOWN = 44;
const OFFSET_PAINSHOCK = 108;
const OFFSET_CSTEAMS = 114;
const OFFSET_CSMENUCODE = 205;
const OFFSET_FLASHLIGHT_BATTERY = 244;
const OFFSET_AWM_AMMO = 377;
const OFFSET_SCOUT_AMMO = 378;
const OFFSET_PARA_AMMO = 379;
const OFFSET_FAMAS_AMMO = 380;
const OFFSET_M3_AMMO = 381;
const OFFSET_USP_AMMO = 382;
const OFFSET_FIVESEVEN_AMMO = 383;
const OFFSET_DEAGLE_AMMO = 384;
const OFFSET_P228_AMMO = 385;
const OFFSET_GLOCK_AMMO = 386;
const OFFSET_FLASH_AMMO = 387;
const OFFSET_HE_AMMO = 388;
const OFFSET_SMOKE_AMMO = 389;
const OFFSET_C4_AMMO = 390;

const HIDE_HUDS = (1 << 5) | (1 << 3);
const UNIT_SECOND = (1 << 12);

const NADE_TYPE_PIPE = 78910;

const SECONDARY_WEAPONS_BITSUM = (1 << CSW_P228) | (1 << CSW_ELITE) | (1 << CSW_FIVESEVEN) | (1 << CSW_USP) | (1 << CSW_GLOCK18) | (1 << CSW_DEAGLE);
const ZOMBIE_ALLOWED_WEAPONS_BITSUM = (1 << CSW_KNIFE) | (1 << CSW_HEGRENADE) | (1 << CSW_FLASHBANG) | (1 << CSW_SMOKEGRENADE) | (1 << CSW_C4);

new const AMMOOFFSET[] = {-1, OFFSET_P228_AMMO, -1, OFFSET_SCOUT_AMMO, OFFSET_HE_AMMO, OFFSET_M3_AMMO, OFFSET_C4_AMMO, OFFSET_USP_AMMO, OFFSET_FAMAS_AMMO,
OFFSET_SMOKE_AMMO, OFFSET_GLOCK_AMMO, OFFSET_FIVESEVEN_AMMO, OFFSET_USP_AMMO, OFFSET_FAMAS_AMMO, OFFSET_FAMAS_AMMO, OFFSET_FAMAS_AMMO, OFFSET_USP_AMMO,
OFFSET_GLOCK_AMMO, OFFSET_AWM_AMMO, OFFSET_GLOCK_AMMO, OFFSET_PARA_AMMO, OFFSET_M3_AMMO, OFFSET_FAMAS_AMMO, OFFSET_GLOCK_AMMO, OFFSET_SCOUT_AMMO, OFFSET_FLASH_AMMO,
OFFSET_DEAGLE_AMMO, OFFSET_FAMAS_AMMO, OFFSET_SCOUT_AMMO, -1, OFFSET_FIVESEVEN_AMMO};

new OrpheuStruct:g_ppmove;

new const g_models_humans[][] = { "zp_tcs_l4d_francis", "zp_tcs_l4d_louis", "zp_tcs_l4d_bill", "zp_tcs_l4d_zoei" };
new const g_models_zombies[][] = { "zombie_source", "tcs_zombie_1", "tcs_zombie_12", "tcs_zombie_6", "tcs_zombie_7", "tcs_zombie_3", "tcs_zombie_13", "tcs_zombie_17", "tcs_zombie_16" };
new const g_models_zombiesT[][] = { "tcs_zombie_6", "tcs_zombie_7", "zp_tcs_l4d_smoker" };
new const g_models_knife_zombies[][] = { "v_knife_zombie", "tcs_garras_1", "tcs_garras_2", "tcs_garras_3", "tcs_garras_4", "tcs_garras_5", "tcs_garras_9", "tcs_garras_10", "tcs_garras_16" };

new const g_models_special_zombies[][] = { "zp_tcs_l4d_boomer", "zp_tcs_l4d_smoker", "zp_tcs_l4d_hunter", "zp_tcs_l4d_jockey", "zp_tcs_l4d_tank", "zp_tcs_l4d_witch" };
new const g_models_knife_sz[][] = { "v_knife_boomer", "v_knife_smoker", "v_knife_hunter", "v_knife_jockey", "v_knife_tank", "v_knife_witch" };

new const g_sound_pain[][] = { "zombie_plague/zombie_pain1.wav", "zombie_plague/zombie_pain2.wav", "zombie_plague/zombie_pain3.wav", "zombie_plague/zombie_pain4.wav", "zombie_plague/zombie_pain5.wav" };
new const g_sound_slash[][] = { "zombie_plague/tcs_claw_slash_1.wav", "zombie_plague/tcs_claw_slash_2.wav" };
new const g_sound_knife_attack[] = "zombie_plague/tcs_claw_attack_2.wav";

new const g_sound_horror[] = "zombie_plague/vassalation_01.wav";
new const g_sound_horde[] = "sound/zombie_plague/hordedanger_01_f.mp3";
new const g_sound_coold[] = "sound/zombie_plague/iamsocold_f.mp3";

new const Float:g_pos_safe[][] = {
	{-913.220397, -1277.029418, -90.053756},
	{-792.134338, -1275.539184, -90.053756},
	{-663.906188, -1275.465087, -90.053756},
	{-544.670471, -1272.675170, -90.053756}
};

// Pipe
new const g_model_vgrenade_pipe[] = "models/zp_tcs/v_pipe.mdl";
new const g_model_wgrenade_pipe[] = "models/zp_tcs/w_pipe.mdl";

new const g_sound_pipebeep[] = "zombie_plague/pipet_beep2.wav";

new g_sprite_laserbeam;
new g_sprite_explosion;

// Adrenalina
new g_adrenalina[33];

new const g_model_vadrenalina[] = "models/zombie_plague/v_adrenalina.mdl";
new const g_model_wmedkit[] = "models/zp_tcs/w_medkit_new.mdl";

// Pildoras
new const g_model_vpildoras[] = "models/zp_tcs/v_pills.mdl";
new const g_model_wpildoras[] = "models/zp_tcs/w_pills.mdl";

// Boomer
new Float:g_boomer_last_vomit[33];
new g_boomer_vomit_humans[33];
new g_boomer_vomit_zombies[33];

new g_boomer_vomit_spr;
new const g_boomer_vomit_spr_dir[] = "sprites/poison.spr";
new const g_boomer_vomit_sounds[3][] = { "zombie_plague/male_boomer_vomit_01.wav", "zombie_plague/male_boomer_vomit_03.wav", "zombie_plague/male_boomer_vomit_04.wav" };
new const g_boomer_explode_sounds[3][] = { "zombie_plague/explo_medium_09.wav", "zombie_plague/explo_medium_10.wav", "zombie_plague/explo_medium_14.wav" };
new const g_boomer_idle[3][] = { "zombie_plague/male_boomer_lurk_03.wav", "zombie_plague/male_boomer_lurk_08.wav", "zombie_plague/male_boomer_lurk_15.wav" };

// Smoker
new g_smoker_tongued[33];
new g_smoker_victim[33];
new Float:g_smoker_last_tong[33];

new g_smoker_tongue_spr;
new g_smoker_dead_spr;
new const g_smoker_hit_sound[] = "zombie_plague/smoker_tonguehit.wav";
new const g_smoker_miss_sound[] = "zombie_plague/smoker_tonguemiss.wav";
new const g_smoker_idle[3][] = { "zombie_plague/smoker_lurk_08.wav", "zombie_plague/smoker_lurk_13.wav", "zombie_plague/smoker_spotprey_07.wav" };

// Hunter
new g_hunter_longjump[33];
new Float:g_hunter_lj_last_time[33];

new const g_hunter_idle[3][] = { "zombie_plague/hunter_stalk_04.wav", "zombie_plague/hunter_stalk_05.wav", "zombie_plague/hunter_stalk_09.wav" };
new const g_hunter_jump[] = "zombie_plague/hunter_jump_01.wav";

// Tank
new Float:g_tank_last_rock[33];

new g_tank_trail_spr;
new g_tank_rockgibs;
new const g_tank_trail[] = "sprites/xbeam3.spr";
new const g_tank_rock_mdl[] = "models/rocktank.mdl";
new const g_tank_rockgibs_mdl_dir[] = "models/rockgibs.mdl";
new const g_tank_rocklaunch_sound[] = "zombie_plague/tank_rocklaunch.wav";
new const g_tank_sound[] = "sound/zombie_plague/tank_sound_f.mp3";

// Witch
new g_witch_angry[33];

new const g_witch_idle[5][] = { "zombie_plague/female_cry_2.wav", "zombie_plague/female_cry_4.wav", "zombie_plague/walking_cry_10.wav", "zombie_plague/lost_little_witch_01a.wav", "zombie_plague/lost_little_witch_03b.wav" };
new const g_witch_sound_angry[] = "sound/zombie_plague/psycho_witch.mp3";


new const CS_TEAM_NAMES[][] = { "UNASSIGNED", "TERRORIST", "CT", "SPECTATOR" };

new const WEAPON_SEC_NAMES[][] = { "", "P228 Compact", "", "", "", "", "", "", "", "", "Dual Elite Berettas", "FiveseveN", "", "", "", "", "USP .45 ACP Tactical", "Glock 18C", "", "", "", "", "", "", "", "", "Desert Eagle .50 AE", "", "", "", ""};
new const WEAPON_SEC_ENT_NAMES[][] = { "weapon_p228", "weapon_elite", "weapon_fiveseven", "weapon_usp", "weapon_glock18", "weapon_deagle" };

new const WEAPON_ENT_NAMES[][] = { "", "weapon_p228", "", "weapon_scout", "weapon_hegrenade", "weapon_xm1014", "weapon_c4", "weapon_mac10",
"weapon_aug", "weapon_smokegrenade", "weapon_elite", "weapon_fiveseven", "weapon_ump45", "weapon_sg550", "weapon_galil", "weapon_famas", "weapon_usp", "weapon_glock18",
"weapon_awp", "weapon_mp5navy", "weapon_m249", "weapon_m3", "weapon_m4a1", "weapon_tmp", "weapon_g3sg1", "weapon_flashbang", "weapon_deagle", "weapon_sg552",
"weapon_ak47", "weapon_knife", "weapon_p90" };

enum {
	MENU_REGISTER_LOGIN = 0,
	MENU_CHOOSE_ZS,
	MENU_CHOOSE_PLAYER_ZS,
	MENU_CHOOSE_WEAPONS
};

enum(+= 100) {
	TASK_SAVE = 999,
	TASK_MODEL,
	TASK_SPAWN,
	TASK_TEAM,
	TASK_SMOKER,
	TASK_AURA,
	TASK_SOUND,
	TASK_ADRENALINA,
	TASK_REPEAT_SOUND
};

enum {
	FM_CS_TEAM_UNASSIGNED = 0,
	FM_CS_TEAM_T,
	FM_CS_TEAM_CT,
	FM_CS_TEAM_SPECTATOR
};

enum {
	ZOMBIE_BOOMER = 1,
	ZOMBIE_SMOKER,
	ZOMBIE_HUNTER,
	ZOMBIE_JOCKEY,
	ZOMBIE_TANK,
	ZOMBIE_WITCH,
	
	TOTAL_ZOMBIES
};

enum _:Colors 
{
	DONT_CHANGE,
	TERRORIST,
	CT,
	SPECTATOR
};

new Ham:Ham_Player_ResetMaxSpeed = Ham_Item_PreFrame;

new g_zp_id[33];
new g_logged[33];
new g_register[33];
new g_boomer[33];
new g_smoker[33];
new g_hunter[33];
new g_tank[33];
new g_witch[33];
new g_zombie[33];
new g_view[33];
new g_currentweapon[33];
new g_zombie_model[33];
new g_nomove[33];
new g_count_zs[33][TOTAL_ZOMBIES];
new g_zs_need[33];
new g_allowed_human[33];
new g_respawn_as_zombie[33];
new g_count_zs_total[33];
new g_human_coold[33];
new g_human_weaps[33];
new g_insert_stats[33];

new g_playername[33][32];
new g_password[33][32];
new g_playermodel[33][32];

new g_maxplayers;
new g_fwSetModel;
new g_fwSpawn;
new g_fwPrecacheSound;
new g_message_scoreinfo;
new g_message_hideweapon;
new g_message_crosshair;
new g_message_teaminfo;
new g_message_flashlight;
new g_message_screenfade;
new g_message_screenshake;
new g_message_roundtime;
new g_switchingteam;
new g_count_zombies_specials[TOTAL_ZOMBIES];
new g_allowed_respawn = 1;
new g_admin_choose_zs;
new g_admin_choose_zs_page;
new g_origin_horde_count[2];
new g_origin_zs_count[2];
new g_human_unq;
new g_torneo_partido = 0;
new g_torneo_partido_fix = 0;

new g_pCVAR_human[4];

new Float:g_models_targettime;
new Float:g_teams_targettime;
new Float:g_origin_horde[128][3];
new Float:g_origin_zs[128][3];
new Float:g_origin_tw[3];

new Handle:g_sql_tuple;
new Handle:g_sql_connection;
new g_sql_error[512];


// Equipo Humano
new g_zombies_kill = 0;
new g_zombies_specials_kill = 0;
new g_zombies_specials_kill2[TOTAL_ZOMBIES] = {0, 0, 0, 0, 0, 0};
new g_damage_knife = 0;
new g_kill_knife = 0;
new g_bullets = 0;
new g_damage = 0;
new g_in_refuge = 0;
new g_zombies_kill_secondary = 0;
new g_zombies_kill_secondary_head = 0;
new g_kill_pipe_group = 0;
new g_kill_zombies_head = 0;


// Humanos
new g_kill_zombies[33];
new g_damage_zombies[33];
new g_damage_tank[33];
new g_kill_pipe[33];


// Zombies
new g_kill_humans[33];
new g_damage_humans[33];
new g_smoker_humans[33];
new g_damage_hunter_humans[33];
new g_damage_tank_humans[33];
new g_damage_witch_humans[33];