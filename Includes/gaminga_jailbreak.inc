#include <amxmodx>
#include <amxmisc>
#include <fakemeta_util>
#include <hamsandwich>
#include <engine>
#include <cstrike>
#include <fun>
#include <cc> // El colorChat
#include <dhudmessage>
#include <sqlx>
#include <orpheu>
#include <orpheu_stocks>
#include <safemenu>
#include <xs>
#include <unixtime>

#pragma semicolon 1

#define MAX_ZONES	 	20

new g_PlayerName[33][32];
new g_UserModel[33][32];
new g_AccountPassword[33][32];
new g_AccountHID[33][64];
new g_AccountBan_Start[33][32];
new g_AccountBan_Finish[33][32];
new g_AccountBan_Admin[33][32];
new g_AccountBan_Reason[33][128];

new g_Simon[33];
new g_AccountLogged[33];
new g_AccountRegister[33];
new g_UserId[33];
new g_AccountBan[33];
new g_Ira[33];
new g_SimonVoice[33];
new g_ChangeTeam[33];
new g_GlowColorSelected[33];
new g_MenuUsersMode[33];
new g_UserFree[33];
new g_GlowColor[33];
new g_UltimaVoluntad[33];
new g_CurrentWeapon[33];
new g_InDuelo[33];
new g_FreeDayNextRound[33];
new g_PoliceModel[33];
new g_PrissonerModel[33];
new g_ModelPolice[33][2];
new g_ModelPrissoner[33][3];
new g_EST_Cagar[33];
new g_EST_Pillar[33];
new g_BarraMetalica[33];
new g_NightVision[33];
//new g_PissPuddleCount[33];
new g_BarraMetalicaDay[33];
//new g_BlockPickup[33];
new g_BlockDrop[33];
//new g_Guard[33];
new g_GuardKills[33];
new g_SimonKills[33];
new g_Rango[33];
new g_Invis[33];
new g_Mic[33];
new g_NextRound_UserFree[33];
new g_Vinc[33];
new g_WhoIsT[33];
new g_WhoIsCT[33];
new g_IsMancha[33];

new Float:g_EST_CagarDone[33];
new Float:g_EST_PillarDone[33];
//new Float:g_AimLastPiss[33][3];
new Float:g_SimonDone[33];
new Float:g_Camping[33];
new Float:g_CampingTime[33];
new Float:g_GameTime_Tops[33];

new g_SqlError[512];
new g_MessageHID[64];
new g_Zone[MAX_ZONES];
new g_MapName[32];
new g_BallFile[128];
new g_ArcFile[128];
new g_Buttons[10];
new g_WeaponFloating[1024];

new g_SimonId;
new g_FreeDay;
new g_MaxPlayers;
new g_Bots;
new g_BoxeoGeneral;
new g_Boxeo;
new g_BoxGlowColors;
new g_BoxeoCountDown;
new g_BlockSimon;
new g_Duelo;
new g_HudGeneral;
new g_HudNotif;
new g_MN_Use;
new g_MN_Motin;
new g_MN_MotinCountDown;
new g_IraBlock;
new g_Message_HideWeapon;
new g_Message_Crosshair;
new g_Day;
new g_DayTotal;
new g_Month;
new g_Year;
new g_Sprite_Dot;
new g_MaxZones;
new g_ZoneId;
new g_SetUnits = 10;
new g_Direction = 0;
new g_EditorId = 0;
new g_Ball;
new g_Sprite_Trail;
//new g_Message_AmmoPickup;
//new g_Message_WeapPickup;
new g_EndRound;
new g_UltimaVoluntadSpent;
new g_HudNotifSec;
new g_ArcBall_First;
new g_Ball_KickId;
new g_Sprite_Goal;
new g_Sprite_Fire;
new g_Sprite_Smoke;
new g_MN_Invis;
new g_Escondidas;
new g_EscondidasPlay;
new g_EscondidasWin_CT;
new g_EscondidasWin_T;
new g_MotinPlay;
new g_MotinWin_CT;
new g_MotinWin_T;
new g_KillGuards;
new g_EscondidasCoolDown;
new g_Message_Screenfade;
new g_FreezeTime;
new g_BallInRespawn;
new g_WeaponFloatingNum;
new g_FirstRoundInMap;
new g_PrissonersAlive;
new g_TeleportSpawnCount;
new g_SpawnCount;
new g_Mancha;

new Float:g_SpawnsCT[128][3];
new Float:g_MN_Gametime_HLTV;
new Float:g_ModelsTargetTime;
new Float:g_BallOrigin[3];
new Float:g_ArcBall_Box[4][3];
new Float:g_Ball_KickOrigin[3];
new Float:g_Ball_LastGoal;
new Float:g_ZoneBox[2][3];
new Float:g_LastEscondidas;

new Handle:g_SqlTuple;
new Handle:g_SqlConnection;

new Ham:Ham_Player_ResetMaxSpeed = Ham_Item_PreFrame;
new HamHook:g_HamObjectCaps;
new HamHook:g_HamPlayerTouch;

new OrpheuHook:g_RoundTimeExpired;

new Trie:g_CellsManager;

#define is_user_valid(%1)			(1 <= %1 <= g_MaxPlayers)
#define is_user_valid_connected(%1) 	(1 <= %1 <= g_MaxPlayers && is_user_connected(%1))
#define is_user_valid_alive(%1) 		(1 <= %1 <= g_MaxPlayers && is_user_alive(%1))

#define SQL_HOST				"127.0.0.1"
#define SQL_USER				""
#define SQL_PASS					""
#define SQL_TABLE				""

new const JB_PREFIX[] = "!g[JB]!y ";

new const MODELOS_PRISIONEROS[][] = {"gk_priss", "hero_none_00", "hero_none_02", "gk_fnormal"};
new const MODELOS_GUARDIAS[][] = {"gk_police", "sas", "gk_fbi", "gk_lajefa"};
new const MODELO_MANOS[] = "models/hero_hands.mdl";
new const MODELO_BARRA_METALICA[][] = {"models/gk_v_cbar.mdl", "models/gk_p_cbar.mdl", "models/gk_w_cbar.mdl"};
new const MODELO_MIERDA[] = "models/gk_mierda.mdl";
new const MODELO_PISS[] = "models/gk_piss.mdl"; /*{"models/gk_piss.mdl", "models/gk_piss_p1.mdl", "models/gk_piss_p2.mdl", "models/gk_piss_p3.mdl", "models/gk_piss_p4.mdl", "models/gk_piss_p5.mdl"};*/
new const MODELO_SKULL[] = "models/gib_skull.mdl";
new const MODELO_BALL[] = "models/kickball/ball.mdl";

new const SPRITE_DOT[] = "sprites/dot.spr";
new const SPRITE_TRAIL[] = "sprites/laserbeam.spr";
new const SPRITE_GOAL[] = "sprites/sj_pro/sprite_06.spr";
new const SPRITE_FIRE[] = "sprites/sj_pro/sprite_02.spr";
new const SPRITE_SMOKE[] = "sprites/sj_pro/sprite_03.spr";

new const SOUND_BOX_HIT_WALL[][] = {"hero/box_hand_wall_00.wav", "hero/box_hand_wall_01.wav", "hero/box_hand_wall_02.wav"};
new const SOUND_BOX_HIT[][] = {"hero/box_hand_hit_00.wav", "hero/box_hand_hit_01.wav", "hero/box_hand_hit_02.wav", "hero/box_hand_hit_03.wav", "hero/box_hand_hit_04.wav", "hero/box_hand_hit_05.wav"};
new const SOUND_BOX_SLASH[] = "hero/box_hand_slash.wav";

new const SOUND_CBAR_HIT_WALL[][] = {"weapons/cbar_hit1.wav", "gk_jb/gk_cbar_hitwall.wav"};
new const SOUND_CBAR_HIT[][] = {"gk_jb/gk_cbar_hit1.wav", "gk_jb/gk_cbar_hit2.wav", "gk_jb/gk_cbar_hit3.wav", "gk_jb/gk_cbar_hit4.wav"};
new const SOUND_CBAR_SLASH[][] = {"weapons/cbar_miss1.wav", "gk_jb/gk_cbar_slash.wav"};

new const SOUND_LIGHTS_OFF[] = "gk_jb/gk_light_off.wav";
new const SOUND_MIERDA[][] = {"gk_jb/gk_mierda1.wav", "gk_jb/gk_mierda2.wav"};
new const SOUND_PISS[] = "gk_jb/gk_piss.wav";
new const SOUND_BALL[] = "kickball/bounce.wav";
new const SOUND_BALL_GOT[] = "kickball/gotball.wav";
new const SOUND_BALL_KICK[] = "kickball/kicked.wav";
new const SOUND_FIGHT[] = "gk_jb/gk_fight.wav";
//new const SOUND_BALL_GOAL[] = "kickball/distress.wav";

new const WEAPON_NAMES[][] = {"", "weapon_p228", "", "weapon_scout", "weapon_hegrenade", "weapon_xm1014", "weapon_c4", "weapon_mac10", "weapon_aug", "weapon_smokegrenade", "weapon_elite", "weapon_fiveseven", "weapon_ump45", "weapon_sg550", "weapon_galil", "weapon_famas",
"weapon_usp", "weapon_glock18", "weapon_awp", "weapon_mp5navy", "weapon_m249", "weapon_m3", "weapon_m4a1", "weapon_tmp", "weapon_g3sg1", "weapon_flashbang", "weapon_deagle", "weapon_sg552", "weapon_ak47", "weapon_knife", "weapon_p90"};

enum _:Tasks (+= 236877) {
	TASK_MODEL = 54276,
	TASK_SPAWN,
	TASK_SAVE,
	TASK_CHECK_GUARDS,
	TASK_BOX_COUNTDOWN,
	TASK_NVISION,
	TASK_PISS,
	TASK_SHOWZONE,
	TASK_USERFREE,
	TASK_NOSIMON,
	TASK_CAMPING,
	TASK_ESCONDIDAS,
	TASK_LAST_REQUEST,
	TASK_ULTIMA_VOLUNTAD,
	TASK_REWARD
};

#define ZONE_ID						EV_INT_iuser1
#define CAMPER_TIME 				EV_INT_iuser3

#define NEXTTHINK_THINK_HUD		get_gametime() + 1.5
#define NEXTTHINK_THINK_DENUN		get_gametime() + 180.0

#define ID_MODEL 						(taskid - TASK_MODEL)
#define ID_SPAWN 						(taskid - TASK_SPAWN)
#define ID_SAVE 						(taskid - TASK_SAVE)
#define ID_NVISION 					(taskid - TASK_NVISION)
#define ID_PISS						(taskid - TASK_PISS)
#define ID_CAMPING						(taskid - TASK_CAMPING)
#define ID_LAST_REQUEST				(taskid - TASK_LAST_REQUEST)
#define ID_ULTIMA_VOLUNTAD				(taskid - TASK_ULTIMA_VOLUNTAD)
#define ID_REWARD						(taskid - TASK_REWARD)

const DAMAGE_HEGRENADE				= (1 << 24);
const FFADE_IN 						= 0x0000;
const FFADE_STAYOUT 				= 0x0004;
const UNIT_SECOND 					= (1 << 12);

const PDATA_SAFE 					= 2;
const OFFSET_LINUX_WEAPONS 			= 4;
const OFFSET_LINUX 					= 5;
const OFFSET_WEAPONOWNER 			= 41;
const OFFSET_ID						= 43;
const OFFSET_KNOWN 					= 44;
const OFFSET_NEXT_PRIMARY_ATTACK	= 46;
const OFFSET_NEXT_SECONDARY_ATTACK 	= 47;
const OFFSET_PRIMARY_AMMO_TYPE 		= 49;
const OFFSET_CLIPAMMO 				= 51;
const OFFSET_IN_RELOAD 				= 54;
const OFFSET_NEXT_ATTACK 			= 83;
const OFFSET_FLASHLIGHT				= 100;
const OFFSET_CSTEAMS		 		= 114;
const OFFSET_PRIMARY_WEAPON			= 116;
const OFFSET_CSMENUCODE 			= 205;
const OFFSET_FLASHLIGHT_BATTERY 	= 244;
const OFFSET_BUTTON_PRESSED 		= 246;
const OFFSET_ACTIVE_ITEM 			= 373;
const OFFSET_AMMO_PLAYER_SLOT0	 	= 376;

new const CLASSNAME_BALL[] = "entBall";

const KEYSMENU = MENU_KEY_1 | MENU_KEY_2 | MENU_KEY_3 | MENU_KEY_4 | MENU_KEY_5 | MENU_KEY_6 | MENU_KEY_7 | MENU_KEY_8 | MENU_KEY_9 | MENU_KEY_0;

new g_FwSpawn;
new g_FwPrecacheSound;
new g_FwKeyValue;

enum _:structMonth {
	monthName[32],
	monthDays
};

new const MONTH_NAME_DAYS[13][structMonth] = {
	{"-", 0},
	{"Enero", 31},
	{"Febrero", 28},
	{"Marzo", 31},
	{"Abril", 30},
	{"Mayo", 31},
	{"Junio", 30},
	{"Julio", 31},
	{"Agosto", 31},
	{"Septiembre", 30},
	{"Octubre", 31},
	{"Noviembre", 30},
	{"Diciembre", 31}
};

enum _:tiendaItems {
	BARRA_METALICA = 0,
	GRANADA_HE,
	GRANADA_FB,
	HP_100,
	HP_150,
	AP_100,
	AP_200,
	DEAGLE_CON_UNA_BALA
};

new g_Tienda_ItemCount[tiendaItems];

#define MAX_COLORS		5

enum _:menuGlow {
	glowName[32],
	glowColorR,
	glowColorG,
	glowColorB
};

new const GLOW_COLORS[MAX_COLORS][menuGlow] = {
	{"BLANCO", 255, 255, 255},
	{"AMARILLO", 255, 255, 0},
	{"VIOLETA", 255, 0, 255},
	{"CELESTE", 0, 255, 255},
	{"\yREMOVER BRILLO", 0, 0, 0}
};

enum _:menuTienda {
	itemName[32],
	itemCost,
	itemPerRound
};

enum _:menuMercadoNegro {
	itemName[32],
	itemCost,
	itemDesc[256]
};

enum _:menuEstetica {
	itemName[32],
	itemCost
};

enum _:menuDuelos {
	DUELO_BOX = 0,
	DUELO_DEAGLE,
	DUELO_AWP,
	DUELO_SCOUT,
	DUELO_GRANADAS
};

enum _:menuUsers {
	DIA_LIBRE_PERSONAL = 0,
	BRILLO,
	ULTIMA_VOLUNTAD,
	MIC
};

enum _:menuPages {
	MENU_USERS = 0,
	MENU_GAME,
	MENU_RANGOS
};

enum _:rangosStruct {
	rangoName[32],
	rangoGuards,
	rangoSimon
};

new g_MenuPage[33][menuPages];

enum _:colorNames {
	C_BLANCO = 0,
	C_AMARILLO,
	C_VIOLETA,
	C_CELESTE
};

new g_BoxColors[colorNames];

enum _:Teams {
	FM_CS_TEAM_UNASSIGNED = 0,
	FM_CS_TEAM_T,
	FM_CS_TEAM_CT,
	FM_CS_TEAM_SPECTATOR
};

enum _:zoneMode {
	ZM_NOTHING,
	ZM_BLOCK_ALL,
	ZM_KILL,
	ZM_KILL_T1,
	ZM_KILL_T2
};

enum _:top15Struct {
	top15Name[32],
	top15URL[256]
};

new const TOPS_15[][top15Struct] = {
	{"GUARDIAS MATADOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27032/top15_guardias_matados.php^"></head><body><p>Cargando...</p></body></html>"},
	{"SIMONES MATADOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27032/top15_simones_matados.php^"></head><body><p>Cargando...</p></body></html>"},
	{"MOTINES", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27032/top15_motines.php^"></head><body><p>Cargando...</p></body></html>"}
};

new ZONE_MODE[zoneMode][] = {"Sin funcion", "NO DEJAR PASAR A NADIE", "MATA A QUIEN LO TOCA", "MATA SI SOS T", "MATA SI SOS CT"};
new ZONE_NAME[zoneMode][] = {"wgz_none", "wgz_block_all", "wgz_kill", "wgz_kill_t1", "wgz_kill_t2"};
new ZONE_SOLID_TYPE[zoneMode] = {SOLID_NOT, SOLID_BBOX, SOLID_TRIGGER, SOLID_TRIGGER, SOLID_TRIGGER};
new NAME_COORD[3][] = {"Coordenada X", "Coordenada Y", "Coordenada Z"};

public fw_Spawn(const entity)
{
	if(!pev_valid(entity))
		return FMRES_IGNORED;
	
	new const REMOVE_ENTS[][] =	{
		"func_bomb_target", "info_bomb_target", "info_vip_start", "func_vip_safetyzone", "func_escapezone", "hostage_entity", "monster_scientist", "info_hostage_rescue",
		"func_hostage_rescue", "env_rain", "env_snow", "env_fog", "info_map_parameters", "func_buyzone", "game_text", "func_pushable"
	};
	
	new sMapName[32];
	get_mapname(sMapName, charsmax(sMapName));
	
	new i;
	new sClassName[32];
	
	entity_get_string(entity, EV_SZ_classname, sClassName, 31);
	
	for(i = 0; i < sizeof(REMOVE_ENTS); ++i) {
		if(equal(sClassName, REMOVE_ENTS[i])) {
			remove_entity(entity);
			return FMRES_SUPERCEDE;
		}
	}
	
	if(equali(sMapName, "jail_revolution")) {
		if(equal(sClassName, "func_train")) {
			remove_entity(entity);
			return FMRES_SUPERCEDE;
		}
	}
	
	return FMRES_IGNORED;
}

public fw_PrecacheSound(const sound[])
{
	if(equal(sound, "hostage", 7))
		return FMRES_SUPERCEDE;
	
	return FMRES_IGNORED;
}

public fw_KeyValue_Post(const ent, const kvd_handle)
{
	new sInfo[32];
	
	if(!is_valid_ent(ent))
		return FMRES_IGNORED;
	
	get_kvd(kvd_handle, KV_ClassName, sInfo, charsmax(sInfo));
	
	if(!equal(sInfo, "multi_manager"))
		return FMRES_IGNORED;
	
	get_kvd(kvd_handle, KV_KeyName, sInfo, charsmax(sInfo));
	
	TrieSetCell(g_CellsManager, sInfo, ent);
	
	return FMRES_IGNORED;
}

public fw_SetClientKeyValue(const id, const infobuffer[], const key[])
{
	if(key[0] == 'm' && key[1] == 'o' && key[2] == 'd' && key[3] == 'e' && key[4] == 'l')
		return FMRES_SUPERCEDE;
	
	if(key[0] == 'n' && key[1] == 'a' && key[2] == 'm' && key[3] == 'e')
		return FMRES_SUPERCEDE;
	
	return FMRES_IGNORED;
}

public fw_ClientUserInfoChanged(const id, const buffer)
{
	if(!is_user_connected(id))
		return FMRES_IGNORED;
	
	get_user_name(id, g_PlayerName[id], 31);
	
	static sCurrentModel[32];
	getUserModel(id, sCurrentModel, 31);
	
	if(!equal(sCurrentModel, g_UserModel[id]) && !task_exists(id + TASK_MODEL))
		setUserModel(id + TASK_MODEL);
	
	static sNewName[32];
	engfunc(EngFunc_InfoKeyValue, buffer, "name", sNewName, 31);
	
	if(equal(sNewName, g_PlayerName[id]))
		return FMRES_IGNORED;
	
	engfunc(EngFunc_SetClientKeyValue, id, buffer, "name", g_PlayerName[id]);
	client_cmd(id, "name ^"%s^"; setinfo name ^"%s^"", g_PlayerName[id], g_PlayerName[id]);
	
	console_print(id, "[JB] No podes cambiarte el nombre dentro del servidor");
	
	return FMRES_SUPERCEDE;
}

public fw_ClientKill()
{
	return FMRES_SUPERCEDE;
}

public fw_EmitSound(const id, const channel, const sample[], const Float:volume, const Float:attn, const flags, const pitch)
{
	if(equal(sample[0], "hostage", 7) || !is_user_valid_connected(id) || equal(sample[10], "fall", 4))
		return FMRES_SUPERCEDE;
	
	if(equal(sample[8], "kni", 3))
	{
		if(equal(sample[14], "sla", 3))
		{
			emit_sound(id, channel, (!g_BarraMetalica[id]) ? SOUND_BOX_SLASH : SOUND_CBAR_SLASH[random_num(0, charsmax(SOUND_CBAR_SLASH))], volume, attn, flags, pitch);	
			return FMRES_SUPERCEDE;
		}
		
		if(equal(sample[14], "hit", 3))
		{
			if(equal(sample[17], "w", 1)) emit_sound(id, channel, (!g_BarraMetalica[id]) ? SOUND_BOX_HIT_WALL[random_num(0, charsmax(SOUND_BOX_HIT_WALL))] : SOUND_CBAR_HIT_WALL[random_num(0, charsmax(SOUND_CBAR_HIT_WALL))], volume, attn, flags, pitch);
			else emit_sound(id, channel, (!g_BarraMetalica[id]) ? SOUND_BOX_HIT[random_num(0, charsmax(SOUND_BOX_HIT))] : SOUND_CBAR_HIT[random_num(0, charsmax(SOUND_CBAR_HIT))], volume, attn, flags, pitch);
			
			return FMRES_SUPERCEDE;
		}
		
		if(equal(sample[14], "sta", 3) && !g_BarraMetalica[id])
		{
			emit_sound(id, channel, "hero/box_hand_hit_02.wav", volume, attn, flags, pitch);
			return FMRES_SUPERCEDE;
		}
	}
	
	return FMRES_IGNORED;
}

public fw_Voice_SetClientListening(const receiver, const sender, const listen)
{
	if(!is_user_connected(sender) || receiver == sender) {
		return FMRES_IGNORED;
	}
	
	static iTeam;
	iTeam = getUserTeam(sender);
	
	if(iTeam != FM_CS_TEAM_T && iTeam != FM_CS_TEAM_CT) {
		engfunc(EngFunc_SetClientListening, receiver, sender, false);
		return FMRES_SUPERCEDE;
	}
	
	if(iTeam == FM_CS_TEAM_T && !g_Mic[sender] && !(get_user_flags(sender) & ADMIN_KICK))
	{
		engfunc(EngFunc_SetClientListening, receiver, sender, false);
		return FMRES_SUPERCEDE;
	}
	
	if(iTeam == FM_CS_TEAM_CT && !(get_user_flags(sender) & ADMIN_KICK) && !is_user_alive(sender)) {
		engfunc(EngFunc_SetClientListening, receiver, sender, false);
		return FMRES_SUPERCEDE;
	}
	
	if(g_UserId[sender] == 1)
	{
		engfunc(EngFunc_SetClientListening, receiver, sender, true);
		return FMRES_SUPERCEDE;
	}
	
	if(sender != g_SimonId && g_SimonVoice[g_SimonId])
	{
		engfunc(EngFunc_SetClientListening, receiver, sender, false);
		return FMRES_SUPERCEDE;
	}
	
	if(sender == g_SimonId || g_Mic[sender])
	{
		engfunc(EngFunc_SetClientListening, receiver, sender, true);
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}

public fw_Touch(const ent, const id)
{
	static sClassName[32];
	entity_get_string(ent, EV_SZ_classname, sClassName, 31);
	
	if(equal(sClassName, "entArc"))
	{
		entity_get_string(id, EV_SZ_classname, sClassName, 31);
		if(equal(sClassName, CLASSNAME_BALL))
		{
			static Float:fGameTime;
			fGameTime = get_gametime();
			
			if((fGameTime - g_Ball_LastGoal) > 0.1)
			{
				soccerGoal(id, ent);
				g_Ball_LastGoal = fGameTime;
			}
		}
		
		return FMRES_IGNORED;
	}
	
	if(g_EditorId)
		return FMRES_IGNORED;
	
	if(!is_user_alive(id))
		return FMRES_IGNORED;
	
	if(!equal(sClassName, "entWGM"))
		return FMRES_IGNORED;
	
	// entity_get_string(id, EV_SZ_classname, sClassName, 31);
	// if(!equal(sClassName, "player"))
		// return FMRES_IGNORED;
	
	zoneTouch(id, ent);
	
	return FMRES_IGNORED;
}

public fw_SetModel(const entity, const model[])
{
	if(strlen(model) < 8)
		return FMRES_IGNORED;
	
	static sClassName[10];
	entity_get_string(entity, EV_SZ_classname, sClassName, charsmax(sClassName));
	
	if(equal(sClassName, "weaponbox"))
	{
		static iWeaponIds[sizeof(WEAPON_NAMES)]; 
		new i;
		
		for(i = 0; i < sizeof(WEAPON_NAMES); ++i)
		{
			iWeaponIds[i] = find_ent_by_owner(-1, WEAPON_NAMES[i], entity);
			
			if(is_valid_ent(iWeaponIds[i]))
				entity_set_int(iWeaponIds[i], EV_INT_impulse, entity + 133890);
		}
		
		return FMRES_IGNORED;
	}
	
	return FMRES_IGNORED;	
}

public message_TextMsg()
{
	static sMsg[22];
	get_msg_arg_string(2, sMsg, charsmax(sMsg));
	
	if(get_msg_args() == 5 && (get_msg_argtype(5) == ARG_STRING))
	{
		get_msg_arg_string(5, sMsg, charsmax(sMsg));
		
		if(equal(sMsg, "#Fire_in_the_hole"))
			return PLUGIN_HANDLED;
	}
	else if(get_msg_args() == 6 && (get_msg_argtype(6) == ARG_STRING))
	{
		get_msg_arg_string(6, sMsg, charsmax(sMsg));
		
		if(equal(sMsg, "#Fire_in_the_hole"))
			return PLUGIN_HANDLED;
	}
	
	if(equal(sMsg, "#Game_teammate_attack"))
		return PLUGIN_HANDLED;
	
	if(equal(sMsg, "#Game_Commencing"))
		g_FirstRoundInMap = 1;
	
	return PLUGIN_CONTINUE;
}

/*public message_WeapPickup(const msg_id, const msg_dest, const msg_entity)
{
	if(g_BlockPickup[msg_entity])
		return PLUGIN_HANDLED;
	
	return PLUGIN_CONTINUE;
}*/

/*public message_AmmoPickup(const msg_id, const msg_dest, const msg_entity)
{
	if(g_BlockPickup[msg_entity])
		return PLUGIN_HANDLED;
	
	return PLUGIN_CONTINUE;
}*/

clearDHUDs(const id)
{
	new i;
	if(id == 0)
	{
		new j;
		for(j = 1; j <= g_MaxPlayers; ++j)
		{
			if(!is_user_connected(j))
				continue;
			
			if(g_AccountLogged[j])
			{
				for(i = 0; i < 8; ++i)
				{
					set_dhudmessage(0, 0, 0, -1.0, 0.2, 0, 0.0, 0.1, 0.1, 0.1);
					show_dhudmessage(j, "");
				}
			}
		}
	}
	else
	{
		for(i = 0; i < 8; ++i)
		{
			set_dhudmessage(0, 0, 0, -1.0, 0.2, 0, 0.0, 0.1, 0.1, 0.1);
			show_dhudmessage(id, "");
		}
	}
}

public executeQuery(const id, const Handle:query, const query_num)
{
	SQL_QueryError(query, g_SqlError, 511);
	
	log_to_file("jb_sql.log", "- LOG: %d - %s", query_num, g_SqlError);
	
	if(is_user_valid_connected(id))
		server_cmd("kick #%d ^"Hubo un error al guardar/cargar tus datos. Intente mas tarde^"", get_user_userid(id));
	
	SQL_FreeHandle(query);
}

public resetInfo(const id)
{
	if(!is_user_connected(id))
		return;
	
	client_cmd(id, "setinfo bottomcolor ^"^"");
	client_cmd(id, "setinfo cl_lc ^"^"");
	client_cmd(id, "setinfo model ^"^"");
	client_cmd(id, "setinfo topcolor ^"^"");
	client_cmd(id, "setinfo _9387 ^"^"");
	client_cmd(id, "setinfo _iv ^"^"");
	client_cmd(id, "setinfo _ah ^"^"");
	client_cmd(id, "setinfo _puqz ^"^"");
	client_cmd(id, "setinfo _ndmh ^"^"");
	client_cmd(id, "setinfo _ndmf ^"^"");
	client_cmd(id, "setinfo _ndms ^"^"");
	client_cmd(id, "setinfo zpt ^"^"");
}

public OrpheuHookReturn:Con_Printf(const a[], const message[])
{
	copy(g_MessageHID, 63, message);
	return OrpheuSupercede;
}

public getUsers()
{
	new iUsers = 0;
	new iTeam;
	new i;
	
	for(i = 1; i <= g_MaxPlayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		if(!g_AccountLogged[i])
			continue;
		
		iTeam = getUserTeam(i);
		
		if(iTeam == FM_CS_TEAM_CT || iTeam == FM_CS_TEAM_T)
			++iUsers;
	}
	
	return iUsers;
}

public getGuards()
{
	new iGuards = 0;
	new i;
	
	for(i = 1; i <= g_MaxPlayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		if(!g_AccountLogged[i])
			continue;
		
		if(getUserTeam(i) == FM_CS_TEAM_CT)
			++iGuards;
	}
	
	return iGuards;
}

public openJails()
{
	new i;
	for(i = 0; i < sizeof(g_Buttons); ++i)
	{
		if(g_Buttons[i])
		{
			ExecuteHamB(Ham_Use, g_Buttons[i], 0, 0, 1, 1.0);
			entity_set_float(g_Buttons[i], EV_FL_frame, 0.0);
		}
	}
	
	/*new iEnt;
	
	while((iEnt = find_ent_by_class(iEnt, "func_door_rotating")) != 0)
		dllfunc(DLLFunc_Use, iEnt, 0);
	
	while((iEnt = find_ent_by_class(iEnt, "func_door")) != 0)
		dllfunc(DLLFunc_Use, iEnt, 0);*/
}

public loadPlugins()
{
	// FLOAT WEAPONS
	new iEnt;
	new sClassName[8];
	
	iEnt = engfunc(EngFunc_FindEntityInSphere, g_MaxPlayers, Float:{0.0, 0.0, 0.0}, 4800.0);
	while(iEnt)
	{
		if(pev_valid(iEnt))
		{
			entity_get_string(iEnt, EV_SZ_classname, sClassName, 7);
			if(containi(sClassName, "armoury") != -1)
			{
				floatWeapon(iEnt);
				spinWeapon(iEnt);
			}
		}
		
		iEnt = engfunc(EngFunc_FindEntityInSphere, iEnt, Float:{0.0, 0.0, 0.0}, 4800.0);
	}
	
	// WGM
	new sZoneFile[100];
	formatex(sZoneFile, 99, "addons/amxmodx/configs/walkguard/%s.wgz", g_MapName);
	
	if(!file_exists(sZoneFile))
		return;
	
	new sText[256];
	new iLine = 0;
	new iLenght;
	new sData[20];
	new iZoneMode = -1;
	new Float:vecMins[3];
	new Float:vecMaxs[3];
	new Float:vecPos[3];
	new i;
	
	while((iLine = read_file(sZoneFile, iLine, sText, charsmax(sText), iLenght)) != 0)
	{
		if(!strlen(sText) || (sText[0] == ';'))
			continue;
		
		strbreak(sText, sData, charsmax(sData), sText, charsmax(sText));
		
		iZoneMode = -1;
		
		for(i = 0; i < zoneMode; ++i)
		{
			if(equal(sData, ZONE_NAME[i]))
			{
				iZoneMode = i;
				break;
			}
		}
		
		if(iZoneMode == -1)
			continue;
		
		strbreak(sText, sData, charsmax(sData), sText, charsmax(sText));
		vecPos[0] = str_to_float(sData);
		strbreak(sText, sData, charsmax(sData), sText, charsmax(sText));
		vecPos[1] = str_to_float(sData);
		strbreak(sText, sData, charsmax(sData), sText, charsmax(sText));
		vecPos[2] = str_to_float(sData);
		
		strbreak(sText, sData, charsmax(sData), sText, charsmax(sText));
		vecMins[0] = str_to_float(sData);
		strbreak(sText, sData, charsmax(sData), sText, charsmax(sText));
		vecMins[1] = str_to_float(sData);
		strbreak(sText, sData, charsmax(sData), sText, charsmax(sText));
		vecMins[2] = str_to_float(sData);
		
		strbreak(sText, sData, charsmax(sData), sText, charsmax(sText));
		vecMaxs[0] = str_to_float(sData);
		strbreak(sText, sData, charsmax(sData), sText, charsmax(sText));
		vecMaxs[1] = str_to_float(sData);
		strbreak(sText, sData, charsmax(sData), sText, charsmax(sText));
		vecMaxs[2] = str_to_float(sData);
		
		for(i = 0; i < 3; ++i)
		{
			if(vecMins[i] > 0)
				vecMins[i] *= -1.0;
			
			if(vecMaxs[i] < 0)
				vecMaxs[i] *= -1.0;
		}
		
		createZone(vecPos, vecMins, vecMaxs, iZoneMode);
	}
	
	findAllZones();
	hideAllZones();
}

public floatWeapon(const ent)
{
	if(pev_valid(ent))
	{
		if(g_WeaponFloatingNum < 1023)
		{
			g_WeaponFloating[g_WeaponFloatingNum] = ent;
			++g_WeaponFloatingNum;
		}
		
		fm_set_rendering(ent, kRenderFxGlowShell, random_num(0, 255), random_num(0, 255), random_num(0, 255), kRenderNormal, 16);
		
		static Float:vecOrigin[3];
		
		entity_get_vector(ent, EV_VEC_origin, vecOrigin);
		vecOrigin[2] += 30.0;
		entity_set_vector(ent, EV_VEC_origin, vecOrigin);
		
		entity_get_vector(ent, EV_VEC_angles, vecOrigin);
		vecOrigin[0] -= 90.0;
		vecOrigin[1] += 45.0;
		entity_set_vector(ent, EV_VEC_angles, vecOrigin);
		
		entity_set_int(ent, EV_INT_movetype, MOVETYPE_NOCLIP);
		entity_set_int(ent, EV_INT_solid, SOLID_TRIGGER);
		
		entity_set_vector(ent, EV_VEC_velocity, Float:{0.0, 0.0, 0.0});
	}
}

public spinWeapon(const ent)
{
	if(pev_valid(ent))
	{
		static Float:vecOrigin[3];
	
		vecOrigin[0] = 0.0;
		vecOrigin[1] = 50.0;
		vecOrigin[2] = 0.0;
		
		entity_set_vector(ent, EV_VEC_avelocity, vecOrigin);
	}
}

public touch__WeaponBox_WorldSpawn(const weaponbox, const worldspawn)
{
	if(pev_valid(weaponbox))
	{
		new sData[4];
		new Float:vecOrigin[3];
		
		entity_get_vector(weaponbox, EV_VEC_origin, vecOrigin);
		
		sData[0] = floatround(vecOrigin[0]);
		sData[1] = floatround(vecOrigin[1]);
		sData[2] = floatround(vecOrigin[2]);
		
		set_task(0.1, "checkOrigin__Again", weaponbox, sData, 3);
	}
}

public checkOrigin__Again(const vecOrigin[4], const weaponbox)
{
	if(pev_valid(weaponbox))
	{
		new Float:vecNewOrigin[3];
		entity_get_vector(weaponbox, EV_VEC_origin, vecNewOrigin);
		
		new i;
		for(i = 0; i < g_WeaponFloatingNum; ++i)
		{
			if(g_WeaponFloating[i] == weaponbox)
				return;
		}
		
		if(vecOrigin[0] == floatround(vecNewOrigin[0]) && vecOrigin[1] == floatround(vecNewOrigin[1]) && vecOrigin[2] == floatround(vecNewOrigin[2]))
		{
			floatWeapon(weaponbox);
			set_task(0.1, "spinWeapon", weaponbox);
			
			return;
		}
		
		new sData[4];
		sData[0] = floatround(vecNewOrigin[0]);
		sData[1] = floatround(vecNewOrigin[1]);
		sData[2] = floatround(vecNewOrigin[2]);
		
		set_task(0.1, "checkOrigin__Again", weaponbox, sData, 3);
	}
}

public touch__Ball_Player(const ball, const id)
{
	new iOwner = entity_get_int(ball, EV_INT_iuser4);
	
	if(iOwner == 0)
	{
		entity_set_int(ball, EV_INT_iuser4, id);
		emit_sound(id, CHAN_BODY, SOUND_BALL_GOT, 1.0, ATTN_NORM, 0, PITCH_NORM);
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
		write_byte(TE_KILLBEAM);
		write_short(g_Ball);
		message_end();
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
		write_byte(TE_BEAMFOLLOW);
		write_short(g_Ball);
		write_short(g_Sprite_Trail);
		write_byte(20);
		write_byte(5);
		write_byte(0);
		write_byte(50);
		write_byte(255);
		write_byte(200);
		message_end();
	}
}

public soccerGoal(const ball, const arc)
{
	if(pev_valid(g_Ball))
	{
		if(getUserTeam(g_Ball_KickId) == FM_CS_TEAM_CT && g_UserId[g_Ball_KickId] != 1)
			return;
		
		entity_set_int(g_Ball, EV_INT_iuser4, 0);
		
		g_BallInRespawn = 1;
		
		new Float:vecBallOrigin[3];
		entity_get_vector(g_Ball, EV_VEC_origin, vecBallOrigin);
		
		new Float:fDistance;
		fDistance = get_distance_f(g_Ball_KickOrigin, vecBallOrigin) / 20.0;
		fDistance *= 0.304800;
		
		new iBallOrigin[3];
		iBallOrigin[0] = floatround(vecBallOrigin[0]);
		iBallOrigin[1] = floatround(vecBallOrigin[1]);
		iBallOrigin[2] = floatround(vecBallOrigin[2]);
		
		//emit_sound(g_Ball, CHAN_BODY, SOUND_BALL_GOAL, 0.5, ATTN_NORM, 0, PITCH_NORM);
		
		new Float:vecOrigin[3];
		
		vecOrigin[0] = -9999.9;
		vecOrigin[1] = -9999.9;
		vecOrigin[2] = -9999.9;
		
		entity_set_origin(g_Ball, vecOrigin);
		
		if(is_user_connected(g_Ball_KickId))
		{
			colorChat(0, TERRORIST, "%s!t%s!y hizo un gol desde !g%0.2f!y metros.", JB_PREFIX, g_PlayerName[g_Ball_KickId], fDistance);
			
			if(is_user_alive(g_Ball_KickId))
			{
				message_begin(MSG_ALL, SVC_TEMPENTITY);
				write_byte(TE_PLAYERATTACHMENT);
				write_byte(g_Ball_KickId);
				write_coord(65);
				write_short(g_Sprite_Goal);
				write_short(30);
				message_end();
			}
		}
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
		write_byte(TE_EXPLOSION2);
		write_coord(iBallOrigin[0]);
		write_coord(iBallOrigin[1]);
		write_coord(iBallOrigin[2]);
		write_byte(40);
		write_byte(10);
		message_end();

		message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
		write_byte(TE_EXPLOSION);
		write_coord(iBallOrigin[0]);
		write_coord(iBallOrigin[1]);
		write_coord(iBallOrigin[2]);
		write_short(g_Sprite_Fire);
		write_byte(25);
		write_byte(10);
		write_byte(0);
		message_end();
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY, iBallOrigin);
		write_byte(TE_SMOKE);
		write_coord(iBallOrigin[0]);
		write_coord(iBallOrigin[1]);
		write_coord(iBallOrigin[2]);
		write_short(g_Sprite_Smoke);
		write_byte(35);
		write_byte(10);
		message_end();
		
		set_task(4.0, "spawnBall");
	}
}

public spawnBall()
{
	if(pev_valid(g_Ball) && g_BallInRespawn)
	{
		g_BallOrigin[2] += 55.0;
		entity_set_int(g_Ball, EV_INT_solid, SOLID_BBOX);
		entity_set_vector(g_Ball, EV_VEC_velocity, Float:{0.0, 0.0, 0.0});
		entity_set_origin(g_Ball, g_BallOrigin);
		
		entity_set_int(g_Ball, EV_INT_movetype, MOVETYPE_BOUNCE);
		entity_set_size(g_Ball, Float:{-15.0, -15.0, 0.0}, Float:{15.0, 15.0, 12.0});
		entity_set_int(g_Ball, EV_INT_iuser4, 0);
		g_BallOrigin[2] -= 55.0;
		
		g_BallInRespawn = 0;
	}
}

public touch__Ball_Ents(const ball, const world)
{
	new Float:vecVelocity[3];
	entity_get_vector(ball, EV_VEC_velocity, vecVelocity);
	
	if(floatround(vector_length(vecVelocity)) > 10)
	{
		vecVelocity[0] *= 0.85;
		vecVelocity[1] *= 0.85;
		vecVelocity[2] *= 0.85;
		
		entity_set_vector(ball, EV_VEC_velocity, vecVelocity);
		
		emit_sound(ball, CHAN_ITEM, SOUND_BALL, 1.0, ATTN_NORM, 0, PITCH_NORM);
	}
	
	return PLUGIN_CONTINUE;
}

public think__Ball(const ent)
{
	if(!pev_valid(g_Ball))
		return PLUGIN_HANDLED;
	
	entity_set_float(ent, EV_FL_nextthink, halflife_time() + 0.05);
	
	new Float:vecOrigin[3];
	new Float:vecVelocity[3];
	new iOwner;
	new iSolid;
	
	entity_get_vector(ent, EV_VEC_origin, vecOrigin);
	entity_get_vector(ent, EV_VEC_velocity, vecVelocity);
	
	iOwner = entity_get_int(ent, EV_INT_iuser4);
	iSolid = entity_get_int(ent, EV_INT_solid);
	
	if(iOwner > 0)
	{
		new Float:vecOwnerOrigin[3];
		new const Float:vecEntVelocity[3] = {1.0, 1.0, 0.0};
		
		entity_get_vector(iOwner, EV_VEC_origin, vecOwnerOrigin);
		
		if(!is_user_alive(iOwner))
		{
			entity_set_int(ent, EV_INT_iuser4, 0);
			
			vecOwnerOrigin[2] += 10.0;
			
			entity_set_origin(ent, vecOwnerOrigin);
			entity_set_vector(ent, EV_VEC_velocity, vecEntVelocity);
			
			return PLUGIN_CONTINUE;
		}
		
		if(iSolid != SOLID_NOT)
			entity_set_int(ent, EV_INT_solid, SOLID_NOT);
		
		new Float:vecAngles[3];
		new Float:vecReturn[3];
		
		entity_get_vector( iOwner, EV_VEC_v_angle, vecAngles );
		
		vecReturn[0] = (floatcos(vecAngles[1], degrees) * 55.0) + vecOwnerOrigin[0];
		vecReturn[1] = (floatsin(vecAngles[1], degrees) * 55.0) + vecOwnerOrigin[1];
		vecReturn[2] = vecOwnerOrigin[2];
		vecReturn[2] -= (entity_get_int(iOwner, EV_INT_flags) & FL_DUCKING) ? 10 : 30;
		
		entity_set_vector(ent, EV_VEC_velocity, vecEntVelocity);
		entity_set_origin(ent, vecReturn);
	}
	else
	{
		if(iSolid != SOLID_BBOX)
			entity_set_int(ent, EV_INT_solid, SOLID_BBOX);
		
		/*new Float:fLastVerticalOrigin;
		if(vecVelocity[2] == 0.0)
		{
			static iCounts;
			
			if(fLastVerticalOrigin > vecOrigin[2])
			{
				++iCounts;
				
				if(iCounts > 10)
				{
					iCounts = 0;
					updateBall(0);
				}
			}
			else
			{
				iCounts = 0;
				
				if(PointContents(vecOrigin) != CONTENTS_EMPTY)
					updateBall(0);
			}
			
			fLastVerticalOrigin = vecOrigin[2];
		}*/
	}
	
	return PLUGIN_CONTINUE;
}

public think__Denuncias(const ent)
{
	colorChat(0, TERRORIST, "%sUn guardia no cumple las !treglas!y? Denuncialo en: !gwww.gaminga.com/denuncias!y y gana !tIra!y!", JB_PREFIX);
	entity_set_float(ent, EV_FL_nextthink, NEXTTHINK_THINK_DENUN);
}

public getUserPlaying()
{
	new i;
	new iUsers = 0;
	
	for(i = 1; i <= g_MaxPlayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		++iUsers;
	}
	
	return iUsers;
}

public getUserAliveCTs()
{
	new i;
	new iCTs = 0;
	
	for(i = 1; i <= g_MaxPlayers; ++i)
	{
		if(!is_user_alive(i))
			continue;
		
		if(getUserTeam(i) != FM_CS_TEAM_CT)
			continue;
		
		++iCTs;
	}
	
	return iCTs;
}

public getUserAliveTs()
{
	new i;
	new iTs = 0;
	
	for(i = 1; i <= g_MaxPlayers; ++i)
	{
		if(!is_user_alive(i))
			continue;
		
		if(getUserTeam(i) != FM_CS_TEAM_T)
			continue;
		
		++iTs;
	}
	
	return iTs;
}

public hideHUDs(const taskid)
{
	if(!is_user_alive(ID_SPAWN))
		return;
	
	message_begin(MSG_ONE, g_Message_HideWeapon, _, ID_SPAWN);
	write_byte((1 << 5));
	message_end();
	
	message_begin(MSG_ONE, g_Message_Crosshair, _, ID_SPAWN);
	write_byte(0);
	message_end();
}

public zoneTouch(const id, const ent)
{	
	if(g_UserId[id] == 1 || g_Duelo || g_Escondidas || g_Mancha)
		return;
	
	new iZoneMode;
	new iUserTeam;
	
	iZoneMode = entity_get_int(ent, ZONE_ID);
	iUserTeam = getUserTeam(id);
	
	if((iZoneMode == ZM_KILL) || ((iZoneMode == ZM_KILL_T2) && (iUserTeam == FM_CS_TEAM_CT)))
	{
		user_silentkill(id);
		colorChat(id, TERRORIST, "%sHas entrado a una !tzona prohibida!y para los guardias!", JB_PREFIX);
	}
	
	if((iZoneMode == ZM_KILL_T1) && (iUserTeam == FM_CS_TEAM_T))
	{
		if(!g_Camping[id])
		{
			g_CampingTime[id] = get_gametime();
			g_Camping[id] = get_gametime();
			
			set_task(1.0, "zoneTouch__Camping", id + TASK_CAMPING, _, _, "b");
		}
		else
		{
			g_Camping[id] = get_gametime();
		}
	}
}

public zoneTouch__Camping(const taskid)
{	
	new Float:fGameTime = get_gametime();
	
	if((fGameTime - g_Camping[ID_CAMPING]) > 1.0)
	{
		g_CampingTime[ID_CAMPING] = 0.0;
		g_Camping[ID_CAMPING] = 0.0;
		
		remove_task(ID_CAMPING);
		return;
	}

	new iLeft;
	iLeft = 45 - floatround(fGameTime - g_CampingTime[ID_CAMPING]);
	
	client_print(ID_CAMPING, print_center, "Campeando en ducto: %d", clamp(iLeft, 0, 45));
	
	if(iLeft < 1)
		fm_fakedamage(ID_CAMPING, "campear en ducto", 5.0, DMG_CRUSH);
}

public createZone(const Float:vecPos[3], const Float:vecMins[3], const Float:vecMaxs[3], const iZoneMode)
{
	new iEnt = create_entity("info_target");
	
	if(is_valid_ent(iEnt))
	{
		entity_set_string(iEnt, EV_SZ_classname, "entWGM");
		entity_set_model(iEnt, MODELO_SKULL);
		entity_set_origin(iEnt, vecPos);
		
		entity_set_int(iEnt, EV_INT_movetype, MOVETYPE_FLY);
		
		if(g_EditorId)
			entity_set_int(iEnt, EV_INT_solid, SOLID_NOT);
		else
			entity_set_int(iEnt, EV_INT_solid, ZONE_SOLID_TYPE[iZoneMode]);
		
		entity_set_size(iEnt, vecMins, vecMaxs);
		
		entity_set_int(iEnt, EV_INT_effects, entity_get_int(iEnt, EV_INT_effects) | EF_NODRAW);
		
		entity_set_int(iEnt, ZONE_ID, iZoneMode);
	}
	
	return iEnt;
}

drawLine(const Float:x1, const Float:y1, const Float:z1, const Float:x2, const Float:y2, const Float:z2, green = 0)
{
	new vecStart[3];
	new vecStop[3];
	
	vecStart[0] = floatround(x1);
	vecStart[1] = floatround(y1);
	vecStart[2] = floatround(z1);
	
	vecStop[0] = floatround(x2);
	vecStop[1] = floatround(y2);
	vecStop[2] = floatround(z2);
	
	message_begin(MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, _, g_EditorId);
	write_byte(TE_BEAMPOINTS);
	write_coord(vecStart[0]);
	write_coord(vecStart[1]);
	write_coord(vecStart[2]);
	write_coord(vecStop[0]);
	write_coord(vecStop[1]);
	write_coord(vecStop[2]);
	write_short(g_Sprite_Dot);
	write_byte(1);
	write_byte(1);
	write_byte(4);
	write_byte(5);
	write_byte(0);
	if(!green)
	{
		write_byte(255);
		write_byte(255);
		write_byte(255);
	}
	else
	{
		write_byte(0);
		write_byte(255);
		write_byte(0);
	}
	write_byte(200);
	write_byte(0);
	message_end();
}

public showAllZones()
{
	findAllZones();
	
	new i;
	new iZone;
	
	for(i = 0; i < g_MaxZones; ++i)
	{
		iZone = g_Zone[i];
		
		remove_task(TASK_SHOWZONE + iZone);
		entity_set_int(iZone, EV_INT_solid, SOLID_NOT);
		
		set_task(0.2, "showZoneBox", TASK_SHOWZONE + iZone, _, _, "b");
	}
}

public showZoneBox(entity)
{
	entity -= TASK_SHOWZONE;
	
	if((!is_valid_ent(entity)) || !g_EditorId)
		return;
	
	new Float:vecOrigin[3];
	entity_get_vector(entity, EV_VEC_origin, vecOrigin);
	
	/*if(!fm_is_in_viewcone(g_EditorId, vecOrigin) && (entity != g_Zone[g_ZoneId]))
		return;*/
	
	new Float:vecEditorOrigin[3];
	new Float:vecHitPoint[3];
	
	entity_get_vector(g_EditorId, EV_VEC_origin, vecEditorOrigin);
	
	fm_trace_line(-1, vecEditorOrigin, vecOrigin, vecHitPoint);
	
	if(entity == g_Zone[g_ZoneId])
		drawLine(vecEditorOrigin[0], vecEditorOrigin[1], vecEditorOrigin[2] - 16.0, vecOrigin[0], vecOrigin[1], vecOrigin[2], 1);
	
	new Float:fDistanceHead = vector_distance(vecEditorOrigin, vecOrigin) - vector_distance(vecEditorOrigin, vecHitPoint);
	if((floatabs(fDistanceHead) > 128.0) && (entity != g_Zone[g_ZoneId]))
		return;
	
	new Float:vecMins[3];
	new Float:vecMax[3];
	
	entity_get_vector(entity, EV_VEC_mins, vecMins);
	entity_get_vector(entity, EV_VEC_maxs, vecMax);
	
	vecMins[0] += vecOrigin[0];
	vecMins[1] += vecOrigin[1];
	vecMins[2] += vecOrigin[2];
	
	vecMax[0] += vecOrigin[0];
	vecMax[1] += vecOrigin[1];
	vecMax[2] += vecOrigin[2];
	
	if(entity != g_Zone[g_ZoneId])
	{
		drawLine(vecMax[0], vecMax[1], vecMax[2], vecMins[0], vecMax[1], vecMax[2]);
		drawLine(vecMax[0], vecMax[1], vecMax[2], vecMax[0], vecMins[1], vecMax[2]);
		drawLine(vecMax[0], vecMax[1], vecMax[2], vecMax[0], vecMax[1], vecMins[2]);
		drawLine(vecMins[0], vecMins[1], vecMins[2], vecMax[0], vecMins[1], vecMins[2]);
		drawLine(vecMins[0], vecMins[1], vecMins[2], vecMins[0], vecMax[1], vecMins[2]);
		drawLine(vecMins[0], vecMins[1], vecMins[2], vecMins[0], vecMins[1], vecMax[2]);
		drawLine(vecMins[0], vecMax[1], vecMax[2], vecMins[0], vecMax[1], vecMins[2]);
		drawLine(vecMins[0], vecMax[1], vecMins[2], vecMax[0], vecMax[1], vecMins[2]);
		drawLine(vecMax[0], vecMax[1], vecMins[2], vecMax[0], vecMins[1], vecMins[2]);
		drawLine(vecMax[0], vecMins[1], vecMins[2], vecMax[0], vecMins[1], vecMax[2]);
		drawLine(vecMax[0], vecMins[1], vecMax[2], vecMins[0], vecMins[1], vecMax[2]);
		drawLine(vecMins[0], vecMins[1], vecMax[2], vecMins[0], vecMax[1], vecMax[2]);
	}
	else
	{
		drawLine(vecMax[0], vecMax[1], vecMax[2], vecMins[0], vecMax[1], vecMax[2], 1);
		drawLine(vecMax[0], vecMax[1], vecMax[2], vecMax[0], vecMins[1], vecMax[2], 1);
		drawLine(vecMax[0], vecMax[1], vecMax[2], vecMax[0], vecMax[1], vecMins[2], 1);
		drawLine(vecMins[0], vecMins[1], vecMins[2], vecMax[0], vecMins[1], vecMins[2], 1);
		drawLine(vecMins[0], vecMins[1], vecMins[2], vecMins[0], vecMax[1], vecMins[2], 1);
		drawLine(vecMins[0], vecMins[1], vecMins[2], vecMins[0], vecMins[1], vecMax[2], 1);
		drawLine(vecMins[0], vecMax[1], vecMax[2], vecMins[0], vecMax[1], vecMins[2], 1);
		drawLine(vecMins[0], vecMax[1], vecMins[2], vecMax[0], vecMax[1], vecMins[2], 1);
		drawLine(vecMax[0], vecMax[1], vecMins[2], vecMax[0], vecMins[1], vecMins[2], 1);
		drawLine(vecMax[0], vecMins[1], vecMins[2], vecMax[0], vecMins[1], vecMax[2], 1);
		drawLine(vecMax[0], vecMins[1], vecMax[2], vecMins[0], vecMins[1], vecMax[2], 1);
		drawLine(vecMins[0], vecMins[1], vecMax[2], vecMins[0], vecMax[1], vecMax[2], 1);
	}
	
	if(entity != g_Zone[g_ZoneId])
		return;
	
	if(g_Direction == 0)
	{
		drawLine(vecMax[0], vecMax[1], vecMax[2], vecMax[0], vecMins[1], vecMins[2], 1);
		drawLine(vecMax[0], vecMax[1], vecMins[2], vecMax[0], vecMins[1], vecMax[2], 1);
		drawLine(vecMins[0], vecMax[1], vecMax[2], vecMins[0], vecMins[1], vecMins[2], 1);
		drawLine(vecMins[0], vecMax[1], vecMins[2], vecMins[0], vecMins[1], vecMax[2], 1);
	}
	
	if(g_Direction == 1)
	{
		drawLine(vecMins[0], vecMins[1], vecMins[2], vecMax[0], vecMins[1], vecMax[2], 1);
		drawLine(vecMax[0], vecMins[1], vecMins[2], vecMins[0], vecMins[1], vecMax[2], 1);
		drawLine(vecMins[0], vecMax[1], vecMins[2], vecMax[0], vecMax[1], vecMax[2], 1);
		drawLine(vecMax[0], vecMax[1], vecMins[2], vecMins[0], vecMax[1], vecMax[2], 1);
	}
	
	if (g_Direction == 2)
	{
		drawLine(vecMax[0], vecMax[1], vecMax[2], vecMins[0], vecMins[1], vecMax[2], 1);
		drawLine(vecMax[0], vecMins[1], vecMax[2], vecMins[0], vecMax[1], vecMax[2], 1);
		drawLine(vecMax[0], vecMax[1], vecMins[2], vecMins[0], vecMins[1], vecMins[2], 1);
		drawLine(vecMax[0], vecMins[1], vecMins[2], vecMins[0], vecMax[1], vecMins[2], 1);
	}
}

public hideAllZones()
{
	g_EditorId = 0;
	
	new i;
	new iId;
	for(i = 0; i < g_MaxZones; ++i)
	{
		iId = entity_get_int(g_Zone[i], ZONE_ID);
		entity_set_int(g_Zone[i], EV_INT_solid, ZONE_SOLID_TYPE[iId]);
		
		remove_task(TASK_SHOWZONE + g_Zone[i]);
	}
}

public findAllZones()
{
	new iEnt = -1;
	g_MaxZones = 0;
	
	while((iEnt = fm_find_ent_by_class(iEnt, "entWGM")))
	{
		g_Zone[g_MaxZones] = iEnt;
		++g_MaxZones;
	}
}

public openWGM(const id)
{
	new sMenu[512];
	new iZoneMode = -1;
	
	if(is_valid_ent(g_Zone[g_ZoneId]))
		iZoneMode = entity_get_int(g_Zone[g_ZoneId], ZONE_ID);
	
	format(sMenu, charsmax(sMenu), "\yWGM^n^n\y%d\w zonas encontradas^n", g_MaxZones);
	
	if(iZoneMode != -1)
		format(sMenu, charsmax(sMenu), "%s (Actual: \y%i\r --> \w%s)^n^n\r1.\w Editar zona actual^n\r2.\w Ver zona anterior^n\r3.\w Ver zona siguiente", sMenu, g_ZoneId + 1, ZONE_MODE[zoneMode:iZoneMode]);
	
	format(sMenu, charsmax(sMenu), "%s^n^n\r4.\w Crear nueva zona", sMenu);
	
	if(iZoneMode != -1)
		format(sMenu, charsmax(sMenu), "%s^n^n\r6. \yBORRAR\w zona actual", sMenu);
	
	format(sMenu, charsmax(sMenu), "%s^n^n\r9.\w Guardar todos los cambios^n\r0.\w Salir", sMenu);
	
	show_menu(id, KEYSMENU, sMenu, -1, "WGM Main");
}

public menu__WGM_Main(const id, const key)
{
	switch(key)
	{
		case 0:
		{
			if(is_valid_ent(g_Zone[g_ZoneId]))
				openEditMenu(id);
			else
				openWGM(id);
		}
		case 1:
		{
			g_ZoneId = (g_ZoneId > 0) ? g_ZoneId - 1 : g_ZoneId;
			openWGM(id);
		}
		case 2:
		{
			g_ZoneId = (g_ZoneId < g_MaxZones - 1) ? g_ZoneId + 1 : g_ZoneId;
			openWGM(id);
		}
		case 3: openWGM__CreateNewZone(id);
		case 5: show_menu(id, KEYSMENU, "\rATENCION!^n\yBORRAR ZONA ACTUAL ?^n^n\r1.\w NO^n\r0.\w SI", -1, "WGM Kill");
		case 8:
		{
			new sZoneFile[200];
			
			if(!dir_exists(sZoneFile))
				mkdir(sZoneFile);
			
			formatex(sZoneFile, 199, "addons/amxmodx/configs/walkguard/%s.wgz", g_MapName);
			
			delete_file(sZoneFile);
			
			findAllZones();
			
			new i;
			new iZone;
			new iZoneMode;
			new Float:vecOrigin[3];
			new Float:vecMins[3];
			new Float:vecMaxs[3];
			new sText[128];
			
			for(i = 0; i < g_MaxZones; ++i)
			{
				iZone = g_Zone[i];
				iZoneMode = entity_get_int(iZone, ZONE_ID);
				
				entity_get_vector(iZone, EV_VEC_origin, vecOrigin);
				
				entity_get_vector(iZone, EV_VEC_mins, vecMins);
				entity_get_vector(iZone, EV_VEC_mins, vecMaxs);
				
				formatex(sText, 127, "%s %.1f %.1f %.1f %.0f %.0f %.0f %.0f %.0f %.0f", ZONE_NAME[iZoneMode], vecOrigin[0], vecOrigin[1], vecOrigin[2], vecMins[0], vecMins[1], vecMins[2], vecMaxs[0], vecMaxs[1], vecMaxs[2]);
				
				write_file(sZoneFile, sText);
			}
			
			colorChat(id, _, "%sSe guardo correctamente el archivo: !g%s!y.", JB_PREFIX, sZoneFile);
			openWGM(id);
		}
		case 9:
		{
			g_EditorId = 0;
			hideAllZones();
		}
	}
}

public openWGM__CreateNewZone(const id)
{
	show_menu(id, KEYSMENU, "\r1.\w Crear nueva zona^n^n\r2.\w Apunta arriba a la derecha^n\r3.\w Apunta abajo a la izquierda^n\r4.\w Crear zona predefinida^n^n\r0.\w Salir", -1, "WGM Create New Zone");
}

public menu__WGM_CreateNewZone(const id, const key)
{
	switch(key)
	{
		case 0:
		{
			if(g_MaxZones < MAX_ZONES - 1)
			{
				new Float:vecOrigin[3];
				entity_get_vector(id, EV_VEC_origin, vecOrigin);
				
				new Float:vecMins[3] = {-32.0, -32.0, -32.0};
				new Float:vecMaxs[3] = {32.0, 32.0, 32.0};
				
				new iEnt = createZone(vecOrigin, vecMins, vecMaxs, 0);
				
				findAllZones();
				
				new i;
				for(i = 0; i < g_MaxZones; i++)
				{
					if(g_Zone[i] == iEnt)
						g_ZoneId = i;
				}
				
				showAllZones();
				menu__WGM_Main(id, 0);
			}
			else
			{
				colorChat(id, _, "%sSolo se pueden crear hasta veinte zonas.", JB_PREFIX);
				openWGM__CreateNewZone(id);
			}
		}
		case 1:
		{
			new Float:vecOrigin[3];
			new vecOriginId[3];
			
			get_user_origin(id, vecOriginId, 3);
			
			IVecFVec(vecOriginId, vecOrigin);
			
			g_ZoneBox[0] = vecOrigin;
			
			openWGM__CreateNewZone(id);
		}
		case 2:
		{
			new Float:vecOrigin[3];
			new vecOriginId[3];
			
			get_user_origin(id, vecOriginId, 3);
			
			IVecFVec(vecOriginId, vecOrigin);
			
			g_ZoneBox[1] = vecOrigin;
			
			openWGM__CreateNewZone(id);
		}
		case 3:
		{
			if((g_ZoneBox[0][0] == 0.0 && g_ZoneBox[0][1] == 0.0 && g_ZoneBox[0][2] == 0.0) || (g_ZoneBox[1][0] == 0.0 && g_ZoneBox[1][1] == 0.0 && g_ZoneBox[1][2] == 0.0))
			{
				colorChat(id, _, "%sFalta indicar una de las posiciones para crear la zona predefinida.", JB_PREFIX);
				openWGM__CreateNewZone(id);
				
				return;
			}
			
			if(g_MaxZones < MAX_ZONES - 1)
			{
				new iEnt;
				new Float:vecCenter[3];
				new Float:vecSize[3];
				new Float:vecMins[3];
				new Float:vecMaxs[3];
				
				for(new i = 0; i < 3; ++i)
				{
					vecCenter[i] = (g_ZoneBox[0][i] + g_ZoneBox[1][i]) / 2.0;
					
					vecSize[i] = getFloatDistance(g_ZoneBox[0][i], g_ZoneBox[1][i]);
					
					vecMins[i] = vecSize[i] / -2.0;
					vecMaxs[i] = vecSize[i] / 2.0;
					
					g_ZoneBox[0][i] = 0.0;
					g_ZoneBox[1][i] = 0.0;
				}
				
				iEnt = createZone(vecCenter, vecMins, vecMaxs, ZM_KILL_T2);
				
				findAllZones();
				
				new i;
				for(i = 0; i < g_MaxZones; i++)
				{
					if(g_Zone[i] == iEnt)
						g_ZoneId = i;
				}
				
				showAllZones();
				menu__WGM_Main(id, 0);
			}
			else
			{
				colorChat(id, _, "%sSolo se pueden crear hasta veinte zonas.", JB_PREFIX);
				openWGM(id);
			}
		}
		case 9:
		{
			openWGM(id);
			return;
		}
	}
}

public openEditMenu(const id)
{
	new sMenu[256];
	new iZoneMode = -1;
	
	format(sMenu, charsmax(sMenu), "\yEDITAR ZONA^n^n");
	
	if(is_valid_ent(g_Zone[g_ZoneId]))
		iZoneMode = entity_get_int(g_Zone[g_ZoneId], ZONE_ID);
	
	if(iZoneMode != -1)
		format(sMenu, charsmax(sMenu), "%s\r1.\w Editar funcion: \y%s\w^n", sMenu, ZONE_MODE[zoneMode:iZoneMode]);
	
	format(sMenu, charsmax(sMenu), "%s^n\r4.\w Cambiar coordenada^n\y%s^n^n\r5.\w Acortar^n\r6.\w Alargar^n\r7.\w Acortar^n\r8.\w Alargar^n^n\r9.\w Incrementar en \y%d\w unidades^n^n\r0.\w Salir", sMenu, NAME_COORD[g_Direction], g_SetUnits);
	
	show_menu(id, KEYSMENU, sMenu, -1, "WGM Edit");
}

public menu__WGM_Edit(const id, const key)
{
	switch(key)
	{
		case 0:
		{
			new iZoneMode = -1;
			iZoneMode = entity_get_int(g_Zone[g_ZoneId], ZONE_ID);
			
			if(iZoneMode == ZM_KILL_T2)
				iZoneMode = 0;
			else
				++iZoneMode;
			
			entity_set_int(g_Zone[g_ZoneId], ZONE_ID, iZoneMode);
		}
		case 3: g_Direction = (g_Direction < 2) ? g_Direction + 1 : 0;
		case 4: zUrotAddieren();
		case 5: vOnRotAbziehen();
		case 6: vOnGelAbziehen();
		case 7: zUgelAddieren();
		case 8: g_SetUnits = (g_SetUnits < 100) ? g_SetUnits * 10 : 1;
		case 9:
		{
			openWGM(id);
			return PLUGIN_HANDLED;
		}
	}
	
	openEditMenu(id);
	
	return PLUGIN_HANDLED;
}

public menu__WGM_Kill(const id, const key)
{
	if(key == 9)
	{
		remove_entity(g_Zone[g_ZoneId]);
		
		--g_ZoneId;
		
		if (g_ZoneId < 0)
			g_ZoneId = 0;
		
		colorChat(id, _, "%sZona borrada.", JB_PREFIX);
		findAllZones();
	}
	
	openWGM(id);
}

public vOnRotAbziehen()
{
	new iEnt = g_Zone[g_ZoneId];
	
	new Float:vecOrigin[3];
	entity_get_vector(iEnt, EV_VEC_origin, vecOrigin);
	
	new Float:vecMins[3];
	new Float:vecMaxs[3];
	
	entity_get_vector(iEnt, EV_VEC_mins, vecMins);
	entity_get_vector(iEnt, EV_VEC_maxs, vecMaxs);
	
	vecMins[g_Direction] -= float(g_SetUnits) / 2.0;
	vecMaxs[g_Direction] += float(g_SetUnits) / 2.0;
	vecOrigin[g_Direction] -= float(g_SetUnits) / 2.0;
	
	entity_set_vector(iEnt, EV_VEC_origin, vecOrigin);
	entity_set_size(iEnt, vecMins, vecMaxs);
}

public zUrotAddieren()
{
	new iEnt = g_Zone[g_ZoneId];
	
	new Float:vecOrigin[3];
	entity_get_vector(iEnt, EV_VEC_origin, vecOrigin);
	
	new Float:vecMins[3];
	new Float:vecMaxs[3];
	
	entity_get_vector(iEnt, EV_VEC_mins, vecMins);
	entity_get_vector(iEnt, EV_VEC_maxs, vecMaxs);
	
	if((floatabs(vecMins[g_Direction]) + vecMaxs[g_Direction]) < g_SetUnits + 1)
		return;
	
	vecMins[g_Direction] += float(g_SetUnits) / 2.0;
	vecMaxs[g_Direction] -= float(g_SetUnits) / 2.0;
	vecOrigin[g_Direction] += float(g_SetUnits) / 2.0;
	
	entity_set_vector(iEnt, EV_VEC_origin, vecOrigin);
	entity_set_size(iEnt, vecMins, vecMaxs);
}

public vOnGelAbziehen()
{
	new iEnt = g_Zone[g_ZoneId];
	
	new Float:vecOrigin[3];
	entity_get_vector(iEnt, EV_VEC_origin, vecOrigin);
	
	new Float:vecMins[3];
	new Float:vecMaxs[3];
	
	entity_get_vector(iEnt, EV_VEC_mins, vecMins);
	entity_get_vector(iEnt, EV_VEC_maxs, vecMaxs);
	
	if((floatabs(vecMins[g_Direction]) + vecMaxs[g_Direction]) < g_SetUnits + 1)
		return;
	
	vecMins[g_Direction] += float(g_SetUnits) / 2.0;
	vecMaxs[g_Direction] -= float(g_SetUnits) / 2.0;
	vecOrigin[g_Direction] -= float(g_SetUnits) / 2.0;
	
	entity_set_vector(iEnt, EV_VEC_origin, vecOrigin);
	entity_set_size(iEnt, vecMins, vecMaxs);
}

public zUgelAddieren()
{
	new iEnt = g_Zone[g_ZoneId];
	
	new Float:vecOrigin[3];
	entity_get_vector(iEnt, EV_VEC_origin, vecOrigin);
	
	new Float:vecMins[3];
	new Float:vecMaxs[3];
	
	entity_get_vector(iEnt, EV_VEC_mins, vecMins);
	entity_get_vector(iEnt, EV_VEC_maxs, vecMaxs);
	
	vecMins[g_Direction] -= float(g_SetUnits) / 2.0;
	vecMaxs[g_Direction] += float(g_SetUnits) / 2.0;
	vecOrigin[g_Direction] += float(g_SetUnits) / 2.0;
	
	entity_set_vector(iEnt, EV_VEC_origin, vecOrigin);
	entity_set_size(iEnt, vecMins, vecMaxs);
}

public updateBall(const id)
{
	if(is_user_connected(id) && g_Simon[id])
	{
		if(pev_valid(g_Ball))
		{
			entity_set_int(g_Ball, EV_INT_solid, SOLID_BBOX);
			entity_set_vector(g_Ball, EV_VEC_velocity, Float:{0.0, 0.0, 0.0});
			entity_set_origin(g_Ball, g_BallOrigin);
			
			entity_set_int(g_Ball, EV_INT_movetype, MOVETYPE_BOUNCE);
			entity_set_size(g_Ball, Float:{-15.0, -15.0, 0.0}, Float:{15.0, 15.0, 12.0});
			entity_set_int(g_Ball, EV_INT_iuser4, 0);
		}
	}
	
	return PLUGIN_HANDLED;
}

public loadBall()
{
	formatex(g_BallFile, charsmax(g_BallFile), "addons/amxmodx/configs/ball.ini");
	if(!file_exists(g_BallFile))
	{
		write_file(g_BallFile, "; MAPA X Y Z", -1);
		return;
	}
	
	new sLine[256];
	new sMap[32];
	new sOrigin[12][16];
	
	new iFile = fopen(g_BallFile, "rt");
	
	while(!feof(iFile))
	{
		fgets(iFile, sLine, charsmax(sLine));
		
		if(!sLine[0] || sLine[0] == ';' || sLine[0] == ' ' || ( sLine[0] == '/' && sLine[1] == '/'))
			continue;
		
		parse(sLine, sMap, 31, sOrigin[0], 15, sOrigin[1], 15, sOrigin[2], 15);
		
		if(equal(sMap, g_MapName))
		{
			new Float:vecOrigin[3];
			
			vecOrigin[0] = str_to_float(sOrigin[0]);
			vecOrigin[1] = str_to_float(sOrigin[1]);
			vecOrigin[2] = str_to_float(sOrigin[2]);
			
			createBall(0, vecOrigin);
			
			g_BallOrigin = vecOrigin;
			
			break;
		}
	}
	
	fclose(iFile);
	
	
	formatex(g_ArcFile, charsmax(g_ArcFile), "addons/amxmodx/configs/arcos.ini");
	if(!file_exists(g_ArcFile))
	{
		write_file(g_ArcFile, "; MAPA <ARCO 1: MinX MinY MinZ MaxX MaxY MaxZ> <ARCO 2: MinX MinY MinZ MaxX MaxY MaxZ>", -1);
		return;
	}
	
	iFile = fopen(g_ArcFile, "rt");
	
	while(!feof(iFile))
	{
		fgets(iFile, sLine, charsmax(sLine));
		
		if(!sLine[0] || sLine[0] == ';' || sLine[0] == ' ' || ( sLine[0] == '/' && sLine[1] == '/'))
			continue;
		
		parse(sLine, sMap, 31, sOrigin[0], 15, sOrigin[1], 15, sOrigin[2], 15, sOrigin[3], 15, sOrigin[4], 15, sOrigin[5], 15, sOrigin[6], 15, sOrigin[7], 15, sOrigin[8], 15, sOrigin[9], 15, sOrigin[10], 15, sOrigin[11], 15);
		
		if(equal(sMap, g_MapName))
		{
			g_ArcBall_Box[0][0] = str_to_float(sOrigin[0]);
			g_ArcBall_Box[0][1] = str_to_float(sOrigin[1]);
			g_ArcBall_Box[0][2] = str_to_float(sOrigin[2]);
			
			g_ArcBall_Box[1][0] = str_to_float(sOrigin[3]);
			g_ArcBall_Box[1][1] = str_to_float(sOrigin[4]);
			g_ArcBall_Box[1][2] = str_to_float(sOrigin[5]);
			
			g_ArcBall_Box[2][0] = str_to_float(sOrigin[6]);
			g_ArcBall_Box[2][1] = str_to_float(sOrigin[7]);
			g_ArcBall_Box[2][2] = str_to_float(sOrigin[8]);
			
			g_ArcBall_Box[3][0] = str_to_float(sOrigin[9]);
			g_ArcBall_Box[3][1] = str_to_float(sOrigin[10]);
			g_ArcBall_Box[3][2] = str_to_float(sOrigin[11]);
			
			createArc(0, g_ArcBall_Box[0], g_ArcBall_Box[1]);
			createArc(0, g_ArcBall_Box[2], g_ArcBall_Box[3]);
			
			break;
		}
	}
	
	fclose(iFile);
}

public kickBall(const id)
{
	static Float:vecOrigin[3];
	new Float:vecOriginId[3];
	new Float:vecReturn[3];
	new Float:fDistance;
	new iTraceLine;
	
	entity_get_vector(g_Ball, EV_VEC_origin, vecOrigin);
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_KILLBEAM);
	write_short(g_Ball);
	message_end();
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_BEAMFOLLOW);
	write_short(g_Ball);
	write_short(g_Sprite_Trail);
	write_byte(20);
	write_byte(5);
	write_byte(0);
	write_byte(50);
	write_byte(255);
	write_byte(200);
	message_end();
	
	vecOrigin[2] += 10.0;
	
	entity_get_vector(id, EV_VEC_origin, vecOriginId);
	iTraceLine = trace_line(id, vecOriginId, vecOrigin, vecReturn);

	fDistance = get_distance_f(vecOrigin, vecReturn);
	
	if(point_contents(vecOrigin) != CONTENTS_EMPTY || (!is_user_connected(iTraceLine) && fDistance))
		return PLUGIN_HANDLED;
	else
	{
		new Float:fBallF[3];
		new Float:fBallR[3];
		new Float:fBallL[3];
		new Float:fBallB[3];
		new Float:fBallTR[3];
		new Float:fBallTL[3];
		new Float:fBallBL[3];
		new Float:fBallBR[3];
		
		new i;
		for(i = 0; i < 3; ++i)
		{
			fBallF[i] = vecOrigin[i];
			fBallR[i] = vecOrigin[i];
			fBallL[i] = vecOrigin[i];
			fBallB[i] = vecOrigin[i];
			fBallTR[i] = vecOrigin[i];
			fBallTL[i] = vecOrigin[i];
			fBallBL[i] = vecOrigin[i];
			fBallBR[i] = vecOrigin[i];
		}
		
		for(i = 1; i <= 6; ++i)
		{
			fBallF[1] += 3.0;
			fBallB[1] -= 3.0;
			fBallR[0] += 3.0;
			fBallL[0] -= 3.0;
			fBallTL[0] -= 3.0;
			fBallTL[1] += 3.0;
			fBallTR[0] += 3.0;
			fBallTR[1] += 3.0;
			fBallBL[0] -= 3.0;
			fBallBL[1] -= 3.0;
			fBallBR[0] += 3.0;
			fBallBR[1] -= 3.0;
			
			if(point_contents(fBallF) != CONTENTS_EMPTY || point_contents(fBallR) != CONTENTS_EMPTY || point_contents(fBallL) != CONTENTS_EMPTY || point_contents(fBallB) != CONTENTS_EMPTY || point_contents(fBallTR) != CONTENTS_EMPTY ||
			point_contents(fBallTL) != CONTENTS_EMPTY || point_contents(fBallBL) != CONTENTS_EMPTY || point_contents(fBallBR) != CONTENTS_EMPTY)
				return PLUGIN_HANDLED;
		}
		
		new sClassName[32];
		new iEnt = -1;
		
		vecOrigin[2] += 35.0;
		
		while((iEnt = find_ent_in_sphere(iEnt, vecOrigin, 35.0)) != 0)
		{
			if(iEnt > g_MaxPlayers)
			{
				entity_get_string(iEnt, EV_SZ_classname, sClassName, 31);
				
				if(equal(sClassName, "func_door")/*(contain(sClassName, "func_") != -1) && !equal(sClassName, "func_water") && !equal(sClassName, "func_illusionary")*/)
					return PLUGIN_HANDLED;
			}
		}
		
		vecOrigin[2] -= 35.0;
	}
	
	emit_sound(id, CHAN_BODY, SOUND_BALL_KICK, 1.0, ATTN_NORM, 0, PITCH_NORM);
	
	new Float:vecVelocity[3];
	velocity_by_aim(id, 800, vecVelocity);
	
	entity_set_int(g_Ball, EV_INT_solid, SOLID_BBOX);
	entity_set_size(g_Ball, Float:{-15.0, -15.0, 0.0}, Float:{15.0, 15.0, 12.0});
	entity_set_int(g_Ball, EV_INT_iuser4, 0);
	entity_set_vector(g_Ball, EV_VEC_origin, vecOrigin);
	
	g_Ball_KickOrigin[0] = vecOrigin[0];
	g_Ball_KickOrigin[1] = vecOrigin[1];
	g_Ball_KickOrigin[2] = vecOrigin[2];
	
	entity_set_vector(g_Ball, EV_VEC_velocity, vecVelocity);
	
	g_Ball_KickId = id;
	
	return PLUGIN_CONTINUE;
}

createBall(const id, Float:vecOrigin[3] = {0.0, 0.0, 0.0})
{
	if(!id && vecOrigin[0] == 0.0 && vecOrigin[1] == 0.0 && vecOrigin[2] == 0.0)
		return 0;
	
	g_Ball = create_entity("info_target");
	
	if(pev_valid(g_Ball))
	{
		entity_set_string(g_Ball, EV_SZ_classname, CLASSNAME_BALL);
		entity_set_int(g_Ball, EV_INT_solid, SOLID_BBOX);
		entity_set_int(g_Ball, EV_INT_movetype, MOVETYPE_BOUNCE);
		entity_set_model(g_Ball, MODELO_BALL);
		entity_set_size(g_Ball, Float:{-15.0, -15.0, 0.0}, Float:{15.0, 15.0, 12.0});
		
		entity_set_float(g_Ball, EV_FL_framerate, 0.0);
		entity_set_int(g_Ball, EV_INT_sequence, 0);
		
		entity_set_int(g_Ball, EV_INT_iuser4, 0);
		
		entity_set_float(g_Ball, EV_FL_nextthink, get_gametime() + 0.05);
		
		if(id > 0)
		{
			new iOrigin[3];
			get_user_origin(id, iOrigin, 3);
			
			IVecFVec(iOrigin, vecOrigin);
			
			vecOrigin[2] += 10.0;
			
			entity_set_origin(g_Ball, vecOrigin);
		}
		else
			entity_set_origin(g_Ball, vecOrigin);
		
		g_BallOrigin = vecOrigin;
		
		return g_Ball;
	}
	
	return -1;
}

public orpheuEnableForwards() <> {}
public orpheuEnableForwards() <disabled>
{
	g_RoundTimeExpired = OrpheuRegisterHook(OrpheuGetFunction("HasRoundTimeExpired", "CHalfLifeMultiplay"), "orpheu__BlockConditions");
	state enabled;
}

public orpheuDisableForwards() <> {}
public orpheuDisableForwards() <enabled>
{
	OrpheuUnregisterHook(g_RoundTimeExpired);
	state disabled;
}

public OrpheuHookReturn:orpheu__BlockConditions() <>
	return OrpheuIgnored;

public OrpheuHookReturn:orpheu__BlockConditions() <enabled>
{
	OrpheuSetReturn(false);
	return OrpheuSupercede;
}

// STOCKS
stock getUserTeam(const id)
{
	if(pev_valid(id) != PDATA_SAFE)
		return FM_CS_TEAM_UNASSIGNED;
	
	return get_pdata_int(id, OFFSET_CSTEAMS, OFFSET_LINUX);
}

stock setUserTeam(const id, const team)
{
	if(pev_valid(id) != PDATA_SAFE)
		return;
	
	set_pdata_int(id, OFFSET_CSTEAMS, team, OFFSET_LINUX);
}

public userModelUpdate(taskid)
{
	static Float:fCurrentTime;
	fCurrentTime = get_gametime();
	
	if(fCurrentTime - g_ModelsTargetTime >= 1.3)
	{
		setUserModel(taskid);
		g_ModelsTargetTime = fCurrentTime;
	}
	else
	{
		set_task((g_ModelsTargetTime + 1.3) - fCurrentTime, "setUserModel", taskid);
		g_ModelsTargetTime = g_ModelsTargetTime + 1.3;
	}
}

public setUserModel(const taskid)
	set_user_info(ID_MODEL, "model", g_UserModel[ID_MODEL]);

stock getUserModel(const id, model[], const len)
	get_user_info(id, "model", model, len);

stock getCurrentWeaponEnt(id)
{
	if(pev_valid(id) != PDATA_SAFE)
		return -1;
	
	return get_pdata_cbase(id, OFFSET_ACTIVE_ITEM, OFFSET_LINUX);
}

stock getWeaponEntId(ent)
{
	if(pev_valid(ent) != PDATA_SAFE)
		return -1;
	
	return get_pdata_cbase(ent, OFFSET_WEAPONOWNER, OFFSET_LINUX_WEAPONS);
}

stock addDot(const number, sOutPut[], const len)
{
	new sTemp[15];
	new iOutputPos;
	new iNumPos;
	new iNumLen = num_to_str(number, sTemp, 14);
	
	while((iNumPos < iNumLen) && (iOutputPos < len)) 
	{
		sOutPut[iOutputPos++] = sTemp[iNumPos++];
		
		if((iNumLen - iNumPos) && !((iNumLen - iNumPos) % 3))
			sOutPut[iOutputPos++] = '.';
	}
	
	sOutPut[iOutputPos] = EOS;
	
	return iOutputPos;
}

/*stock hamStripWeapons(const id, const weapon[])
{
	if(!equal(weapon, "weapon_", 7))
		return 0;
	
	static iWeaponId;
	iWeaponId = get_weaponid(weapon);
	
	if(!iWeaponId)
		return 0;
	
	static iWeaponEnt;
	iWeaponEnt = -1;
	
	while((iWeaponEnt = engfunc(EngFunc_FindEntityByString, iWeaponEnt, "classname", weapon)) && entity_get_edict(iWeaponEnt, EV_ENT_owner) != id) { }
	
	if(!iWeaponEnt)
		return 0;
	
	if(g_CurrentWeapon[id] == iWeaponId)
		ExecuteHamB(Ham_Weapon_RetireWeapon, iWeaponEnt);
	
	if(!ExecuteHamB(Ham_RemovePlayerItem, id, iWeaponEnt))
		return 0;
	
	ExecuteHamB(Ham_Item_Kill, iWeaponEnt);
	
	entity_set_int(id, EV_INT_weapons, entity_get_int(id, EV_INT_weapons) & ~(1 << iWeaponId));
	//set_pev(id, pev_weapons, pev(id, pev_weapons) & ~(1 << iWeaponId));
	
	return 1;
}*/

stock containLetters(const String[])
{
	new iLen = strlen(String);
	new i;
	
	for(i = 0; i < iLen; ++i)
	{
		if(isalpha(String[i]))
			return 1;
	}
	
	return 0;
}

stock countNumbers(const String[], const iLen = sizeof(String))
{
	new iCount = 0;
	new i;
	
	for(i = 0; i < iLen; ++i)
	{
		if(isdigit(String[i]))
			++iCount;
	}
	
	return iCount;
}

stock clearWeapons(const id)
{
	if(!is_user_alive(id))
		return;
	
	removeWeapons(id);
	give_item(id, "weapon_knife");
	
	g_BlockDrop[id] = 0;
}

stock inArray(const needle, const data[], const size)
{
	new i;
	for(i = 0; i < size; ++i)
	{
		if(data[i] == needle)
			return i;
	}
	
	return -1;
}

stock Float:getFloatDistance(Float:num1, Float:num2)
{ 
	if(num1 > num2)
		return (num1 - num2);
	else if(num2 > num1) 
		return (num2 - num1);
	
	return 0.0;
}

stock setUserBatteries(const id, const value)
{
	if(pev_valid(id) != PDATA_SAFE)
		return;
	
	set_pdata_int(id, OFFSET_FLASHLIGHT_BATTERY, value, OFFSET_LINUX);
}

stock setAnimation(const id, const animation)
{
	entity_set_int(id, EV_INT_weaponanim, animation);
	
	message_begin(MSG_ONE, SVC_WEAPONANIM, _, id);
	write_byte(animation);
	write_byte(entity_get_int(id, EV_INT_body));
	message_end();
}