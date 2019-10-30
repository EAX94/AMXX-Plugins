#include <gaminga_jailbreak>

#define PLUGIN_NAME		"Jail Break"

#define PLUGIN_VERSION	"v1.7"
#define PLUGIN_AUTHOR	"KISKE"

// #define HATS_DEBUG

/*
	CAMBIOS:
	
[INDENT][B]v1.8 [13 / 01 / 2015][/B][/INDENT]
[LIST]
	[*]Se agregó un minijuego nuevo: La Mancha, comparte tiempo de reutilización con los otros minijuegos.
	
	[*]Se volvieron a activar los gorros, los conjuntos aún no, estaremos monitoreando el servidor a posibles caídas por esto.
	
	[*]Se modificó el logro FREE KILL, ahora requiere participar en tres mini juegos y no en tres escondidas.
	[*]Se redujeron los usuarios conectados que requerían todos los logros.
	
	[*]Se arregló un error en los rangos que marcaba incorrectamente los guardias/simones requeridos.
	[*]Se arregló un error en el que a veces la deagle en motín tenía 7 balas.
[/LIST]
*/

enum _:LogrosInt {
	VINCULADO,
	FUERZA_INDOMABLE,
	ASESINO,
	FREE_KILL,
	DELATADO,
	FUERZA_IMPARABLE,
	NO_ME_ENCONTRARON,
	MAKE_THE_PINIA,
	EXPERTO_EN_EXPLOSIVOS,
	LAXANTE,
	AVENGING_ANGEL,
	PIECE_INITIATIVE,
	WAR_OF_ATTRITION,
	NEW_WORLD_ORDER,
	BANCO_DE_GUERRA,
	COMMAND_AND_CONTROL,
	SOY_DORADO
};

enum _:LogrosStruct {
    logroName[64],
    logroDesc[256],
    logroHat,
	logroCostume,
	logroUsersNeed
};

enum _:HatsInt {
	HAT_NONE = 0, HAT_AFRO, HAT_DEVIL, HAT_MASTER_CHIEF, HAT_HELM, HAT_JACK_JACK, HAT_HEADPHONES, HAT_YODA, HAT_SPARTAN, HAT_JAIME, HAT_SASHA, HAT_MAX
};

enum _:CostumesInt {
	C_NONE = 0, C_PREMIUM, C_CAT, C_PANDA, C_POLAR
};

new const LOGROS[][LogrosStruct] = {
	{"VINCULADO", "Vincula tu cuenta del JB con la del foro GAM!NGA", 												HAT_AFRO, 			0, 					0},
	{"FUERZA INDOMABLE", "Mata a 50 Simones", 																HAT_DEVIL, 			0, 					0},
	{"ASESINO", "Mata a 50 guardias", 																		HAT_MASTER_CHIEF, 	0, 					0},
	{"FREE KILL", "Participa de tres mini juegos en un mismo mapa sin desconectarse", 								HAT_HELM, 			0, 					10},
	{"DELATADO", "Compra un ítem en el mercado negro", 														HAT_JACK_JACK, 		0, 					0},
	{"FUERZA IMPARABLE", "Mata a tres guardias en un mismo MOTÍN", 												HAT_HEADPHONES, 	0, 					10},
	{"NO ME ENCONTRARON", "Sobrevive a las escondidas siendo el último prisionero", 									0, 					C_CAT,				10},
	{"MAKE THE PIÑA", "Gana un duelo de boxeo como prisionero", 												HAT_SPARTAN, 		0, 					10},
	{"EXPERTO EN EXPLOSIVOS", "Mata a tres guardias con una misma bomba HE", 									0, 					C_POLAR, 			10}, // COMPLETAR
	{"LAXANTE", "Utiliza /cagar diez veces en un mismo mapa sin desconectarse", 										HAT_YODA, 			0, 					0},
	{"AVENGING ANGEL", "Mata a un prisionero rebelde", 														0, 					0, 					0},
	{"PIECE INITIATIVE", "Gana un duelo de deagle como prisionero", 												HAT_JAIME, 			0, 					10},
	{"WAR OF ATTRITION", "Consigue ser el último prisionero vivo", 												HAT_SASHA, 			0, 					10},
	{"NEW WORLD ORDER", "Sobrevive a diez rondas consecutivas siendo prisionero sin desconectarse", 					0, 					C_PANDA, 			10},
	{"BANCO DE GUERRA", "Junta 10.000 de Ira", 																HAT_MAX, 			0, 					0},
	{"COMMAND AND CONTROL", "Gana las escondidas como guardia", 												0, 					0, 					10},
	{"SOY DORADO", "Ser usuario Premium", 																	0, 					C_PREMIUM, 			0}
};

new Float:g_AchievementLink[33];

new g_Achievement[33][LogrosInt];
new g_AchievementInId[33];
new g_AchievementUnlock[33][LogrosInt][32];
new g_AchievementMenuPage[33];
new g_AchievementCount[33];

new g_Achievement_FreeKill[33];
new g_Achievement_GuardsMotin[33];
new g_Achievement_CountCagar[33];
new g_Achievement_Rebel[33];
new g_Achievement_NWO[33];

enum _:HatsStruct {
	hatId,
	hatName[32],
	hatModel[32]
};

new const HATS[HatsInt][HatsStruct] = {
	{0, "NINGUNO", ""},
	{1, "AFRO", "afro"},
	{2, "DEVIL", "devil"},
	{3, "MASTER CHIEF", "masterchief"},
	{4, "HELM", "helm"},
	{5, "JACK JACK", "jackjack"},
	{6, "HEADPHONES", "hp"},
	{7, "YODA", "yoda"},
	{8, "SPARTAN", "spartan"},
	{9, "JAIME", "jamie"},
	{10, "SASHA", "sasha"},
	{11, "MAX", "max"}
};

enum _:CostumesStruct {
	costumeId,
	costumeName[32],
	costumeModel[32],
	costumeModel_Head,
	costumeModel_Face,
	costumeModel_Back,
	costumeModel_Pelvis
};

new const COSTUMES[CostumesInt][CostumesStruct] = { // _Head , _Face , _Back , _Pelvis
	{0, "NINGUNO", "", 0, 0, 0, 0},
	{4, "PREMIUM", "gold", 1, 0, 1, 0},
	{1, "CAT", "cat", 1, 1, 1, 1},
	{2, "PANDA", "panda", 1, 1, 1, 1},
	{3, "POLAR", "polar", 1, 0, 1, 0}
};

new g_Hat[33];
new g_Hat_Unlock[33][HatsInt];
new g_Hat_NextRound[33];
new g_Hat_MenuPage[33];
new g_Hat_Choosen[33];

new g_Costume[33];
new g_Costume_Parts[33][4];
new g_Costume_Unlock[33][CostumesInt];
new g_Costume_NextRound[33];
new g_Costume_MenuPage[33];
new g_Costume_Choosen[33];

#define MAX_ITEMS					8
#define MAX_ITEMS_MN				2
#define MAX_ITEMS_EST				9

#define MAX_HE_PER_ROUND			3
#define MAX_FB_PER_ROUND			3
#define MAX_DEAGLE_PER_ROUND		2

new const TIENDA_ITEMS[MAX_ITEMS][menuTienda] = {
	{"Barra metálica (dura 3 rondas)", 50, 0},
	{"Granada HE", 35, MAX_HE_PER_ROUND},
	{"Granada FB", 35, MAX_FB_PER_ROUND},
	{"+100 HP", 80, 0},
	{"+150 HP", 125, 0},
	{"+100 AP", 40, 0},
	{"+200 AP", 70, 0},
	{"Deagle con una bala", 80, MAX_DEAGLE_PER_ROUND}
};

new const MERCADO_NEGRO_ITEMS[MAX_ITEMS_MN][menuMercadoNegro] = {
	{"MOTÍN", 100, "Apaga las luces de toda la prisión, abre las celdas.^nOtorga barra metálica y una deagle con dos balas a todos los prisioneros.^n^n\rNOTA:\w Los guardias pueden matar a cualquier prisionero cuando se activa."},
	{"INVISIBILIDAD", 80, "Otorga barra metálica e invisibilidad a vos y a dos prisioneros al azar.^nLos guardias pueden ver tu nombre si te apuntan aunque seas invisible.^n^n\rNOTA:\w Los guardias pueden matar a cualquier prisionero invisible."}
};

new const ESTETICA_ITEMS[MAX_ITEMS_EST][menuEstetica] = {
	{"T: NORMAL", 0},
	{"T: TOGA", 500},
	{"T: MM", 500},
	{"CT: NORMAL", 0},
	{"CT: FBI", 500},
	{"CAGAR", 200},
	{"MEAR", 250},
	{"T: MUJER", 3000},
	{"CT: LA JEFA", 3000}
};

new const NAME_DAYS[][] = {
	"Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"
};

new const RANGOS[][rangosStruct] = {
	{"Fan de Justin", 5, 0},
	{"Wachiturro", 10, 0},
	{"Punga", 20, 0},
	{"Traficante", 30, 2},
	{"Motochorro", 50, 5},
	{"Asesino", 100, 10},
	{"Narco", 200, 25},
	{"Terrorista", 350, 50},
	{"El Capo", 500, 100},
	{"Giuseppa Sansone", 2000, 250},
	{"Joe Bananas", 5000, 500},
	{"Frank Costello", 6000, 700},
	{"Al Capone", 7000, 900},
	{"John Gotti", 8000, 1100},
	{"Capomafia Bonanno", 9000, 1300},
	{"NED FLANDERS", 9999999, 9999999}
};

public pfn_keyvalue(ent)
{
	if(!is_valid_ent(ent))
		return PLUGIN_CONTINUE;
	
	new sMapName[32];
	
	get_mapname(sMapName, 31);
	strtolower(sMapName);
	
	new iMap = 0;
	
	if(equal(sMapName, "jail_buix"))
		iMap = 1;
	
	if(!iMap)
		return PLUGIN_CONTINUE;
	
	new sClassName[32];
	new sKeyName[32];
	new sValue[32];
	
	copy_keyvalue(sClassName, charsmax(sClassName), sKeyName, charsmax(sKeyName), sValue, charsmax(sValue));
	
	if(iMap == 1 && equal(sClassName, "func_door") && equal(sValue, "t"))
		DispatchKeyValue(ent, "speed", 500);
	
	return PLUGIN_CONTINUE;
}

public plugin_precache()
{
	get_mapname(g_MapName, 31);
	strtolower(g_MapName);
	
	new iEnt;
	
	iEnt = create_entity("hostage_entity");
	if(is_valid_ent(iEnt))
	{
		entity_set_origin(iEnt, Float:{8192.0, 8192.0, 8192.0});
		dllfunc(DLLFunc_Spawn, iEnt);
	}
	
	iEnt = create_entity("func_buyzone");
	if(is_valid_ent(iEnt))
	{
		entity_set_origin(iEnt, Float:{8192.0, 8192.0, 8192.0});
		dllfunc(DLLFunc_Spawn, iEnt);
	}
	
	g_CellsManager = TrieCreate();
	
	g_FwSpawn = register_forward(FM_Spawn, "fw_Spawn");
	g_FwPrecacheSound = register_forward(FM_PrecacheSound, "fw_PrecacheSound");
	g_FwKeyValue = register_forward(FM_KeyValue, "fw_KeyValue_Post", 1);
	
	new sBuffer[64];
	for(iEnt = 0; iEnt < sizeof(MODELOS_PRISIONEROS); ++iEnt)
	{
		formatex(sBuffer, 63, "models/player/%s/%s.mdl", MODELOS_PRISIONEROS[iEnt], MODELOS_PRISIONEROS[iEnt]);
		precache_model(sBuffer);
	}
	
	for(iEnt = 0; iEnt < sizeof(MODELOS_GUARDIAS); ++iEnt)
	{
		formatex(sBuffer, 63, "models/player/%s/%s.mdl", MODELOS_GUARDIAS[iEnt], MODELOS_GUARDIAS[iEnt]);
		precache_model(sBuffer);
	}
	
	for(iEnt = 1; iEnt < HatsInt; ++iEnt) {
		formatex(sBuffer, 63, "models/jb_hats/%s.mdl", HATS[iEnt][hatModel]);
		precache_model(sBuffer);
	}
	
	for(iEnt = 1; iEnt < CostumesInt; ++iEnt) {
		if(COSTUMES[iEnt][costumeModel_Head]) {
			formatex(sBuffer, 63, "models/jb_hats/%s_head.mdl", COSTUMES[iEnt][costumeModel]);
			precache_model(sBuffer);
		}
		
		if(COSTUMES[iEnt][costumeModel_Face]) {
			formatex(sBuffer, 63, "models/jb_hats/%s_face.mdl", COSTUMES[iEnt][costumeModel]);
			precache_model(sBuffer);
		}
		
		if(COSTUMES[iEnt][costumeModel_Back]) {
			formatex(sBuffer, 63, "models/jb_hats/%s_back.mdl", COSTUMES[iEnt][costumeModel]);
			precache_model(sBuffer);
		}
		
		if(COSTUMES[iEnt][costumeModel_Pelvis]) {
			formatex(sBuffer, 63, "models/jb_hats/%s_pelvis.mdl", COSTUMES[iEnt][costumeModel]);
			precache_model(sBuffer);
		}
	}
	
	/*for(iEnt = 0; iEnt < sizeof(MODELO_PISS); ++iEnt)
		precache_model(MODELO_PISS[iEnt]);*/
	
	for(iEnt = 0; iEnt < sizeof(MODELO_BARRA_METALICA); ++iEnt)
		precache_model(MODELO_BARRA_METALICA[iEnt]);
	
	for(iEnt = 0; iEnt < sizeof(SOUND_BOX_HIT_WALL); ++iEnt)
		precache_sound(SOUND_BOX_HIT_WALL[iEnt]);
	
	for(iEnt = 0; iEnt < sizeof(SOUND_BOX_HIT); ++iEnt)
		precache_sound(SOUND_BOX_HIT[iEnt]);
	
	for(iEnt = 0; iEnt < sizeof(SOUND_CBAR_HIT_WALL); ++iEnt)
		precache_sound(SOUND_CBAR_HIT_WALL[iEnt]);
	
	for(iEnt = 0; iEnt < sizeof(SOUND_CBAR_HIT); ++iEnt)
		precache_sound(SOUND_CBAR_HIT[iEnt]);
	
	for(iEnt = 0; iEnt < sizeof(SOUND_CBAR_SLASH); ++iEnt)
		precache_sound(SOUND_CBAR_SLASH[iEnt]);
	
	for(iEnt = 0; iEnt < sizeof(SOUND_MIERDA); ++iEnt)
		precache_sound(SOUND_MIERDA[iEnt]);
	
	precache_model(MODELO_MANOS);
	precache_model(MODELO_MIERDA);
	precache_model(MODELO_PISS);
	precache_model(MODELO_SKULL);
	precache_model(MODELO_BALL);
	
	precache_sound(SOUND_BOX_SLASH);
	precache_sound(SOUND_LIGHTS_OFF);
	precache_sound(SOUND_PISS);
	precache_sound(SOUND_BALL);
	precache_sound(SOUND_BALL_GOT);
	precache_sound(SOUND_BALL_KICK);
	precache_sound(SOUND_FIGHT);
	
	g_Sprite_Dot = precache_model(SPRITE_DOT);
	g_Sprite_Trail = precache_model(SPRITE_TRAIL);
	g_Sprite_Goal = precache_model(SPRITE_GOAL);
	g_Sprite_Fire = precache_model(SPRITE_FIRE);
	g_Sprite_Smoke = precache_model(SPRITE_SMOKE);
	
	loadBall();
}

public plugin_init()
{
	register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR);
	register_cvar("HideNSeek", "4.1", FCVAR_SERVER|FCVAR_SPONLY);
	
	set_task(0.4, "pluginSQL");
	
	register_event("HLTV", "event_HLTV", "a", "1=0", "2=0");
	
	register_logevent("logevent_RoundStart", 2, "1=Round_Start");
	register_logevent("logevent_RoundEnd", 2, "1=Round_End");
	
	register_forward(FM_SetClientKeyValue, "fw_SetClientKeyValue");
	register_forward(FM_ClientUserInfoChanged, "fw_ClientUserInfoChanged");
	register_forward(FM_ClientKill, "fw_ClientKill");
	register_forward(FM_EmitSound, "fw_EmitSound");
	register_forward(FM_Voice_SetClientListening, "fw_Voice_SetClientListening");
	register_forward(FM_Touch, "fw_Touch");
	register_forward(FM_SetModel, "fw_SetModel");
	
	unregister_forward(FM_Spawn, g_FwSpawn);
	unregister_forward(FM_PrecacheSound, g_FwPrecacheSound);
	unregister_forward(FM_KeyValue, g_FwKeyValue);
	
	DisableHamForward(g_HamObjectCaps = RegisterHam(Ham_ObjectCaps, "player", "fw_ObjectCaps_Pre"));
	DisableHamForward(g_HamPlayerTouch = RegisterHam(Ham_Touch, "player", "fw_TouchPlayer_Post", 1));
	
	RegisterHam(Ham_Spawn, "player", "fw_PlayerSpawn_Post", 1);
	RegisterHam(Ham_TakeDamage, "player", "fw_TakeDamage");
	RegisterHam(Ham_ObjectCaps, "player", "fw_ObjectCaps_Post", 1);
	RegisterHam(Ham_Player_PostThink, "player", "fw_PlayerPostThink");
	RegisterHam(Ham_Killed, "player", "fw_PlayerKilled");
	RegisterHam(Ham_Player_ResetMaxSpeed, "player", "fw_ResetMaxSpeed_Post", 1);
	
	new i;
	for(i = 1; i < sizeof(WEAPON_NAMES); ++i)
	{
		if(WEAPON_NAMES[i][0])
		{
			RegisterHam(Ham_Item_Deploy, WEAPON_NAMES[i], "fw_ItemDeploy_Post", 1);
			
			RegisterHam(Ham_Item_AddToPlayer, WEAPON_NAMES[i], "fw_Item_AddToPlayer");
			
			if(i == CSW_DEAGLE || i == CSW_SCOUT || i == CSW_AWP)
			{
				RegisterHam(Ham_Item_AttachToPlayer, WEAPON_NAMES[i], "fw_Item_AttachToPlayer");
				RegisterHam(Ham_Item_PostFrame, WEAPON_NAMES[i], "fw_Item_PostFrame");
			}
		}
	}
	
	g_Message_HideWeapon = get_user_msgid("HideWeapon");
	g_Message_Crosshair = get_user_msgid("Crosshair");
	//g_Message_AmmoPickup = get_user_msgid("AmmoPickup");
	//g_Message_WeapPickup = get_user_msgid("WeapPickup");
	
	//register_message(get_user_msgid("DeathMsg"), "message_DeathMsg");
	register_message(get_user_msgid("TextMsg"), "message_TextMsg");
	register_message(get_user_msgid("FlashBat"), "message_FlashBat");
	register_message(get_user_msgid("Flashlight"), "message_Flashlight");
	//register_message(g_Message_AmmoPickup, "message_AmmoPickup");
	//register_message(g_Message_WeapPickup, "message_WeapPickup");
	g_Message_Screenfade = get_user_msgid("ScreenFade");
	register_message(g_Message_Screenfade, "message_ScreenFade");
	register_message(get_user_msgid("SendAudio"), "message__SendAudio");
	
	new const WEAPON_COMMANDS[][] =	{
		"buy", "buyammo1", "buyammo2", "buyequip", "cl_autobuy", "cl_rebuy", "cl_setautobuy", "cl_setrebuy", "usp", "glock", "deagle", "p228", "elites", "fn57", "m3", "xm1014", "mp5", "tmp", "p90", "mac10", "ump45", "ak47", "galil", "famas", "sg552", "m4a1", "aug", "scout", "awp", "g3sg1",
		"sg550", "m249", "vest", "vesthelm", "flash", "hegren", "sgren", "defuser", "nvgs", "shield", "primammo", "secammo", "km45", "9x19mm", "nighthawk", "228compact", "fiveseven", "12gauge", "autoshotgun", "mp", "c90", "cv47", "defender", "clarion", "krieg552", "bullpup", "magnum",
		"d3au1", "krieg550", "smg", "radio3", "coverme", "takepoint", "holdpos", "regroup", "followme", "takingfire", "go", "fallback", "sticktog", "getinpos", "stormfront", "report", "roger", "enemyspot", "needbackup", "sectorclear", "inposition", "reportingin", "getout", "negative", "enemydown"
	};
	
	register_clcmd("chooseteam", "clcmd_ChangeTeam");
	register_clcmd("jointeam", "clcmd_ChangeTeam");
	register_clcmd("nightvision", "clcmd_NightVision");
	register_clcmd("CREAR_CONTRASENIA", "clcmd_CreatePassword");
	register_clcmd("REPETIR_CONTRASENIA", "clcmd_RepeatPassword");
	register_clcmd("INGRESAR_CONTRASENIA", "clcmd_EnterPassword");
	register_clcmd("say /simon", "clcmd_Simon");
	register_clcmd("radio1", "clcmd_Simon");
	register_clcmd("say /nosimon", "clcmd_NoSimon");
	register_clcmd("say /fd", "clcmd_FreeDay");
	register_clcmd("say /celdas", "clcmd_OpenJails");
	register_clcmd("say /open", "clcmd_OpenJails");
	register_clcmd("say /abrir", "clcmd_OpenJails");
	register_clcmd("radio2", "clcmd_OpenJails");
	register_clcmd("say /voluntad", "clcmd_UltimaVoluntad");
	register_clcmd("say /uv", "clcmd_UltimaVoluntad");
	register_clcmd("say /tienda", "clcmd_Shop");
	register_clcmd("say /shop", "clcmd_Shop");
	register_clcmd("say /box", "clcmd_Box");
	register_clcmd("say /nobox", "clcmd_NoBox");
	register_clcmd("say /cagar", "clcmd_Cagar");
	register_clcmd("say /mear", "clcmd_Mear");
	register_clcmd("say /pillar", "clcmd_Mear");
	register_clcmd("say /ball", "clcmd_Ball");
	register_clcmd("say /bocha", "clcmd_Ball");
	register_clcmd("say /pelota", "clcmd_Ball");
	register_clcmd("say /reset", "updateBall");
	register_clcmd("say /rb", "updateBall");
	register_clcmd("say /top15", "clcmd_Tops");
	register_clcmd("say /top10", "clcmd_Tops");
	register_clcmd("say /top", "clcmd_Tops");
	register_clcmd("say /tops", "clcmd_Tops");
	register_clcmd("say /juegos", "clcmd_Juegos");
	for(i = 0; i < sizeof(WEAPON_COMMANDS); ++i)
		register_clcmd(WEAPON_COMMANDS[i], "clcmd_BlockCommand");
	register_clcmd("drop", "clcmd_Drop");
	register_clcmd("+simonvoice", "clcmd_SimonVoiceOn");
	register_clcmd("-simonvoice", "clcmd_SimonVoiceOff");
	register_clcmd("say", "clcmd_Say");
	register_clcmd("say_team", "clcmd_SayTeam");
	
	register_concmd("jb_bot", "concmd_Bot");
	register_concmd("walkguardmenu", "concmd_WalkGuardMenu");
	register_concmd("jb_team", "concmd_Team");
	register_concmd("jb_ira", "concmd_Ira");
	register_concmd("jb_ban", "concmd_BanAccount");
	register_concmd("jb_unban", "concmd_UnbanAccount");
	
	register_menu("Register Login Menu", KEYSMENU, "menu__RegisterLogin");
	register_menu("Game Menu", KEYSMENU, "menu__Game");
	register_menu("Glow Menu", KEYSMENU, "menu__Glow");
	register_menu("Count Down Menu", KEYSMENU, "menu__CountDown");
	register_menu("Box Colors Menu", KEYSMENU, "menu__BoxColors");
	register_menu("WGM Main", KEYSMENU, "menu__WGM_Main");
	register_menu("WGM Edit", KEYSMENU, "menu__WGM_Edit");
	register_menu("WGM Kill", KEYSMENU, "menu__WGM_Kill");
	register_menu("WGM Create New Zone", KEYSMENU, "menu__WGM_CreateNewZone");
	
	register_menucmd(register_menuid("Team_Select", 1), (1<<0)|(1<<1)|(1<<4)|(1<<5), "menucmd_TeamSelect");
	register_menucmd(register_menuid("#Buy", 1), 511, "menucmd_CsBuy");
	register_menucmd(register_menuid("BuyPistol", 1), 511, "menucmd_CsBuy");
	register_menucmd(register_menuid("BuyShotgun", 1), 511, "menucmd_CsBuy");
	register_menucmd(register_menuid("BuySub", 1), 511, "menucmd_CsBuy");
	register_menucmd(register_menuid("BuyRifle", 1), 511, "menucmd_CsBuy");
	register_menucmd(register_menuid("BuyMachine", 1), 511, "menucmd_CsBuy");
	register_menucmd(register_menuid("BuyItem", 1), 511, "menucmd_CsBuy");
	register_menucmd(register_menuid("BuyEquip", 1), 511, "menucmd_CsBuy");
	register_menucmd(-28, 511, "menucmd_CsBuy");
	register_menucmd(-29, 511, "menucmd_CsBuy");
	register_menucmd(-30, 511, "menucmd_CsBuy");
	register_menucmd(-32, 511, "menucmd_CsBuy");
	register_menucmd(-31, 511, "menucmd_CsBuy");
	register_menucmd(-33, 511, "menucmd_CsBuy");
	register_menucmd(-34, 511, "menucmd_CsBuy");
	
	register_impulse(OFFSET_FLASHLIGHT, "impulse_Flashlight");
	
	new const sEnt[][] = {"worldspawn", "func_wall", "func_door", "func_door_rotating", "func_wall_toggle", "func_breakable", "func_pushable", "func_train", "func_illusionary", "func_button", "func_rot_button", "func_rotating"};
	
	register_touch("weaponbox", "worldspawn", "touch__WeaponBox_WorldSpawn");
	register_touch(CLASSNAME_BALL, "player", "touch__Ball_Player");
	
	for(i = 0; i < sizeof sEnt; ++i)
		register_touch(CLASSNAME_BALL, sEnt[i], "touch__Ball_Ents");
	
	register_think(CLASSNAME_BALL, "think__Ball");
	
	g_MaxPlayers = get_maxplayers();
	
	g_HudGeneral = CreateHudSyncObj();
	g_HudNotif = CreateHudSyncObj();
	g_HudNotifSec = CreateHudSyncObj();
	
	new iThinkHUD;
	iThinkHUD = create_entity("info_target");
	
	if(is_valid_ent(iThinkHUD))
	{
		entity_set_string(iThinkHUD, EV_SZ_classname, "entThink__HUD");
		entity_set_float(iThinkHUD, EV_FL_nextthink, NEXTTHINK_THINK_HUD);
		
		register_think("entThink__HUD", "think__HUD");
	}
	
	new iThinkDenuncias;
	iThinkDenuncias = create_entity("info_target");
	
	if(is_valid_ent(iThinkDenuncias))
	{
		entity_set_string(iThinkDenuncias, EV_SZ_classname, "entThink__Denuncias");
		entity_set_float(iThinkDenuncias, EV_FL_nextthink, NEXTTHINK_THINK_DENUN);
		
		register_think("entThink__Denuncias", "think__Denuncias");
	}
	
	formatex(g_PlayerName[0], 31, "-");
	
	set_task(1.0, "loadPlugins");
	
	state disabled;
	orpheuEnableForwards();
	
	saveButtons();
	loadCTSpawns();
	
	g_FirstRoundInMap = 0;
}

public plugin_end()
{
	new Handle:sqlQuery;
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE fechas SET day='%d', month_day='%d', month='%d', year='%d' WHERE id = '1';", g_Day, g_DayTotal, g_Month, g_Year);
	
	if(!SQL_Execute(sqlQuery))
		executeQuery(0, sqlQuery, 16);
	else
		SQL_FreeHandle(sqlQuery);
		
	
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE fechas SET day='%d', month_day='%d', month='%d' WHERE id = '2';", g_MotinPlay, g_MotinWin_T, g_MotinWin_CT);
	
	if(!SQL_Execute(sqlQuery))
		executeQuery(0, sqlQuery, 119);
	else
		SQL_FreeHandle(sqlQuery);
	
	
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE fechas SET day='%d', month_day='%d', month='%d' WHERE id = '3';", g_EscondidasPlay, g_EscondidasWin_T, g_EscondidasWin_CT);
	
	if(!SQL_Execute(sqlQuery))
		executeQuery(0, sqlQuery, 344);
	else
		SQL_FreeHandle(sqlQuery);
	
	SQL_FreeHandle(g_SqlConnection);
	SQL_FreeHandle(g_SqlTuple);
}

public pluginSQL()
{
	set_cvar_num("sv_alltalk", 1);
	set_cvar_num("sv_voicequality", 5);
	set_cvar_num("sv_airaccelerate", 100);
	set_cvar_num("mp_flashlight", 0);
	set_cvar_num("mp_footsteps", 1);
	set_cvar_num("mp_freezetime", 3);
	set_cvar_num("mp_friendlyfire", 0);
	set_cvar_num("mp_limitteams", 32);
	set_cvar_num("mp_autoteambalance", 0);
	set_cvar_num("sv_restart", 1);
	set_cvar_num("pbk_afk_min_players", 33);
	
	set_cvar_string("sv_voicecodec", "voice_speex");
	
	g_SqlTuple = SQL_MakeDbTuple(SQL_HOST, SQL_USER, SQL_PASS, SQL_TABLE);
	if(g_SqlTuple == Empty_Handle)
	{
		log_to_file("jb_sql_tuple.log", "%s", g_SqlError);
		set_fail_state(g_SqlError);
	}
	
	new iSql_ErrorNum;
	
	g_SqlConnection = SQL_Connect(g_SqlTuple, iSql_ErrorNum, g_SqlError, 511);
	if(g_SqlConnection == Empty_Handle)
	{
		log_to_file("jb_sql_connect.log", "%s", g_SqlError);
		set_fail_state(g_SqlError);
	}
	
	new Handle:sqlQuery;
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT day, month_day, month, year FROM fechas WHERE id = '1';");
	
	if(!SQL_Execute(sqlQuery))
		executeQuery(0, sqlQuery, 15);
	else if(SQL_NumResults(sqlQuery))
	{
		g_Day = SQL_ReadResult(sqlQuery, 0);
		g_DayTotal = SQL_ReadResult(sqlQuery, 1);
		g_Month = SQL_ReadResult(sqlQuery, 2);
		g_Year = SQL_ReadResult(sqlQuery, 3);
		
		SQL_FreeHandle(sqlQuery);
	}
	else
		SQL_FreeHandle(sqlQuery);
	
	
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT day, month_day, month FROM fechas WHERE id = '2';");
	
	if(!SQL_Execute(sqlQuery))
		executeQuery(0, sqlQuery, 63);
	else if(SQL_NumResults(sqlQuery))
	{
		g_MotinPlay = SQL_ReadResult(sqlQuery, 0);
		g_MotinWin_T = SQL_ReadResult(sqlQuery, 1);
		g_MotinWin_CT = SQL_ReadResult(sqlQuery, 2);
		
		SQL_FreeHandle(sqlQuery);
	}
	else
		SQL_FreeHandle(sqlQuery);
	
	
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT day, month_day, month FROM fechas WHERE id = '3';");
	
	if(!SQL_Execute(sqlQuery))
		executeQuery(0, sqlQuery, 118);
	else if(SQL_NumResults(sqlQuery))
	{
		g_EscondidasPlay = SQL_ReadResult(sqlQuery, 0);
		g_EscondidasWin_T = SQL_ReadResult(sqlQuery, 1);
		g_EscondidasWin_CT = SQL_ReadResult(sqlQuery, 2);
		
		SQL_FreeHandle(sqlQuery);
	}
	else
		SQL_FreeHandle(sqlQuery);
}

public client_putinserver(id)
{
	get_user_name(id, g_PlayerName[id], 31);
	
	if(containi(g_PlayerName[id], "DROP TABLE") != -1 || containi(g_PlayerName[id], "TRUNCATE") != -1 || containi(g_PlayerName[id], "INSERT") != -1 || containi(g_PlayerName[id], "UPDATE") != -1 || containi(g_PlayerName[id], "DELETE") != -1 || 
	containi(g_PlayerName[id], "\") != -1)
	{
		server_cmd("kick #%d ^"Tu nombre tiene un caracter invalido^"", get_user_userid(id));
		return;
	}
	
	g_AccountPassword[id][0] = EOS;
	g_AccountHID[id][0] = '!';
	
	resetVars(id);
	
	g_AccountLogged[id] = 0;
	g_AccountRegister[id] = 0;
	g_UserId[id] = 0;
	g_AccountBan[id] = 0;
	g_Ira[id] = 0;
	g_ChangeTeam[id] = 0;
	g_GlowColor[id] = -1;
	g_PoliceModel[id] = 1;
	g_PrissonerModel[id] = 0;
	g_ModelPolice[id] = {0, 0};
	g_ModelPrissoner[id] = {0, 0, 0};
	g_EST_Cagar[id] = 0;
	g_EST_Pillar[id] = 0;
	g_BarraMetalica[id] = 0;
	g_BarraMetalicaDay[id] = 0;
	//g_Guard[id] = 0;
	g_GuardKills[id] = 0;
	g_SimonKills[id] = 0;
	g_SimonVoice[id] = 0;
	g_Camping[id] = 0.0;
	g_CampingTime[id] = 0.0;
	g_Rango[id] = 0;
	g_NextRound_UserFree[id] = 0;
	g_Vinc[id] = 0;
	g_AchievementLink[id] = 0.0;
	g_AchievementCount[id] = 0;
	g_Hat[id] = HAT_NONE;
	g_Hat_NextRound[id] = HAT_NONE;
	g_Costume[id] = C_NONE;
	g_Costume_NextRound[id] = C_NONE;
	g_Achievement_FreeKill[id] = 0;
	g_Achievement_GuardsMotin[id] = 0;
	g_Achievement_CountCagar[id] = 0;
	g_Achievement_NWO[id] = 0;
	
	new i;
	for(i = 0; i < LogrosInt; ++i) {
		g_Achievement[id][i] = 0;
		g_AchievementUnlock[id][i][0] = EOS;
	}
	
	for(i = 0; i < HatsInt; ++i) {
		g_Hat_Unlock[id][i] = 0;
	}
	
	for(i = 0; i < CostumesInt; ++i) {
		g_Costume_Unlock[id][i] = 0;
	}
	
	for(i = 0; i < 4; ++i) {
		g_Costume_Parts[id][i] = 0;
	}
	
	g_Hat_Unlock[id][0] = 1;
	g_Costume_Unlock[id][0] = 1;
	
	set_task(0.3, "checkAccount", id);
	set_task(3.0, "modifCommands", id);
}

public client_disconnect(id) {
	remove_task(id + TASK_MODEL);
	remove_task(id + TASK_SPAWN);
	remove_task(id + TASK_SAVE);
	remove_task(id + TASK_NVISION);
	remove_task(id + TASK_PISS);
	remove_task(id + TASK_CAMPING);
	remove_task(id + TASK_LAST_REQUEST);
	remove_task(id + TASK_ULTIMA_VOLUNTAD);
	remove_task(id + TASK_REWARD);
	
	#if defined HATS_DEBUG
		log_to_file("hats_debug.txt", "client_disconnect(id) - 1");
	#endif
	
	if(is_valid_ent(g_Hat[id])) {
		#if defined HATS_DEBUG
			log_to_file("hats_debug.txt", "client_disconnect(id) - 2");
		#endif
		remove_entity(g_Hat[id]);
		#if defined HATS_DEBUG
			log_to_file("hats_debug.txt", "client_disconnect(id) - 3");
		#endif
	}
	
	
	if(g_Costume[id]) {
		new i;
		for(i = 0; i < 4; ++i) {
			if(is_valid_ent(g_Costume_Parts[id][i])) {
				remove_entity(g_Costume_Parts[id][i]);
			}
		}
	}
	
	#if defined HATS_DEBUG
		log_to_file("hats_debug.txt", "client_disconnect(id) - 4");
	#endif
	
	if(is_user_alive(id) && getUserTeam(id) == FM_CS_TEAM_T) {
		--g_PrissonersAlive;
		
		if(g_PrissonersAlive == 1) {
			new i;
			for(i = 1; i <= g_MaxPlayers; ++i) {
				if(i == id) {
					continue;
				}
				
				if(getUserTeam(i) == FM_CS_TEAM_T) {
					setAchievement(i, WAR_OF_ATTRITION);
					
					break;
				}
			}
		}
	}
	
	if(g_Simon[id]) {
		clcmd_NoSimon(id);
	}
	
	saveInfo(id);
	
	if(id == g_EditorId) {
		hideAllZones();
	}
}

public event_HLTV()
{
	set_cvar_num("mp_flashlight", 0);
	
	DisableHamForward(g_HamObjectCaps);
	DisableHamForward(g_HamPlayerTouch);
	
	remove_task(TASK_USERFREE);
	remove_task(TASK_NOSIMON);
	remove_task(TASK_ESCONDIDAS);
	
	set_task(30.0, "freeDayGeneral__NoSimon", TASK_NOSIMON);
	
	++g_Day;
	++g_DayTotal;
	
	if(g_Day == 7)
	{
		g_Day = 0;
		set_task(1.0, "freeDayGeneral");
		
		colorChat(0, TERRORIST, "%sEs domingo y es !gdía libre general!y. Las celdas se abrirán en !t15 segundos!y!", JB_PREFIX);
		
		clearDHUDs(0);
		
		set_dhudmessage(255, 255, 0, -1.0, 0.6, 0, 6.0, 6.0, 1.0, 1.0);
		show_dhudmessage(0, "HOY ES DÍA LIBRE GENERAL");
	}
	else if(g_FirstRoundInMap)
	{
		g_FirstRoundInMap = 0;
		set_task(1.0, "freeDayGeneral");
		
		colorChat(0, TERRORIST, "%sEs !gdía libre general!y. Las celdas se abrirán en !t15 segundos!y!", JB_PREFIX);
		
		clearDHUDs(0);
		
		set_dhudmessage(255, 255, 0, -1.0, 0.6, 0, 6.0, 6.0, 1.0, 1.0);
		show_dhudmessage(0, "HOY ES DÍA LIBRE GENERAL");
	}
	
	if(g_DayTotal > MONTH_NAME_DAYS[g_Month][monthDays])
	{
		g_DayTotal = 1;
		++g_Month;
		
		if(g_Month == 13)
		{
			g_Month = 1;
			++g_Year;
		}
	}
	
	new i;
	for(i = 0; i < g_WeaponFloatingNum; ++i)
		g_WeaponFloating[i] = 0;
	
	new sEntNames[] = "entMierda";
	new iEnt;
	
	iEnt = find_ent_by_class(-1, sEntNames);
	while(iEnt > 0)
	{
		remove_entity(iEnt);
		iEnt = find_ent_by_class(-1, sEntNames);
	}
	
	set_lights("#OFF");
	
	g_SimonId = 0;
	g_FreeDay = 0;
	g_Boxeo = 0;
	g_BoxeoGeneral = 0;
	g_BoxeoCountDown = 0;
	g_BlockSimon = 0;
	g_Duelo = 0;
	g_MN_Motin = 0;
	g_EndRound = 0;
	g_UltimaVoluntadSpent = 0;
	g_Escondidas = 0;
	g_Mancha = 0;
	g_MN_Invis = 0;
	g_KillGuards = 0;
	g_FreezeTime = 1;
	g_PrissonersAlive = 0;
	
	g_MN_Gametime_HLTV = get_gametime();
	
	remove_task(TASK_BOX_COUNTDOWN);
	
	for(i = 0; i < tiendaItems; ++i)
		g_Tienda_ItemCount[i] = 0;
	
	g_IraBlock = 0;
	
	// if(getUserPlaying() < 5)
	// {
		// colorChat(0, TERRORIST, "%sLa ganancia de !tIra!y y !trangos!y fue bloqueada debido a que hay pocos jugadores.", JB_PREFIX);
		// g_IraBlock = 1;
	// }
	
	if(!pev_valid(g_Ball))
		createBall(0, g_BallOrigin);
	else
	{
		entity_set_int(g_Ball, EV_INT_solid, SOLID_BBOX);
		entity_set_vector(g_Ball, EV_VEC_velocity, Float:{0.0, 0.0, 0.0});
		entity_set_origin(g_Ball, g_BallOrigin);
		
		entity_set_int(g_Ball, EV_INT_movetype, MOVETYPE_BOUNCE);
		entity_set_size(g_Ball, Float:{-15.0, -15.0, 0.0}, Float:{15.0, 15.0, 12.0});
		entity_set_int(g_Ball, EV_INT_iuser4, 0);
	}
	
	/*remove_task(TASK_CHECK_GUARDS);
	set_task(1.0, "checkGuards", TASK_CHECK_GUARDS);*/
}

public logevent_RoundStart()
{
	g_FreezeTime = 0;
	
	new i;
	for(i = 1; i <= g_MaxPlayers; ++i)
	{
		if(!is_user_alive(i))
			continue;
		
		ExecuteHamB(Ham_Player_ResetMaxSpeed, i);
	}
}

public logevent_RoundEnd()
{
	static Float:fLastEndTime;
	static Float:fCurrentTime;
	
	fCurrentTime = get_gametime();
	
	if((fCurrentTime - fLastEndTime) < 0.5)
		return;
	
	fLastEndTime = fCurrentTime;
	
	remove_task(TASK_ESCONDIDAS);
	
	set_cvar_num("mp_flashlight", 0);
	
	if(!g_Escondidas)
		EnableHamForward(g_HamObjectCaps);
	
	g_EndRound = 1;
	g_KillGuards = 0;
	
	if(g_MN_Motin && !getUserAliveCTs())
	{
		new i;
		for(i = 1; i <= g_MaxPlayers; ++i)
		{
			if(!is_user_alive(i))
				continue;
			
			if(getUserTeam(i) != FM_CS_TEAM_T)
				continue;
			
			g_Ira[i] += 25;
		}
		
		colorChat(0, _, "%sTodos los prisioneros vivos ganaron !g+25 Ira!y por amotinarse con éxito.", JB_PREFIX);
	}
	
	if(!getUserAliveCTs() || !getUserAliveTs())
	{
		new i;
		new iTeam;
		new iCTs = getUserAliveCTs();
		
		for(i = 1; i <= g_MaxPlayers; ++i) {
			if(!is_user_connected(i))
				continue;
			
			iTeam = getUserTeam(i);
			
			g_BlockDrop[i] = 1;
			
			if(iTeam == FM_CS_TEAM_T) {
				if(!is_user_alive(i)) {
					g_Achievement_NWO[i] = 0;
				} else {
					if(!iCTs) {
						++g_Achievement_NWO[i];
						
						if(g_Achievement_NWO[i] == 10) {
							setAchievement(i, NEW_WORLD_ORDER);
						}
					}
				}
			}
		}
	}
}

/*public checkGuards()
{
	new iCTsId[10];
	new iTsId[21];
	
	new iUsers = 0;
	new iBanned = 0;
	new iCTs = 0;
	new iTs = 0;
	new iHowCTs;
	new iTotal;
	new i;
	
	for(i = 1; i <= g_MaxPlayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		if(!g_AccountLogged[i])
			continue;
			
		++iUsers;
		
		if(g_AccountBan[i] == 1)
		{
			++iBanned;
			continue;
		}
		
		if(getUserTeam(i) == FM_CS_TEAM_CT)
		{
			iCTsId[iCTs] = i;
			++iCTs;
		}
		else if(getUserTeam(i) == FM_CS_TEAM_T)
		{
			iTsId[iTs] = i;
			++iTs;
		}
	}
	
	if((iCTs + iTs) == 0 && !iBanned)
	{
		remove_task(TASK_CHECK_GUARDS);
		set_task(10.0, "checkGuards", TASK_CHECK_GUARDS);
		
		return;
	}
	
	if(iBanned == iUsers)
	{
		iCTs = 0;
		iTs = 0;
		
		for(i = 1; i <= g_MaxPlayers; ++i)
		{
			if(!is_user_connected(i))
				continue;
			
			if(!g_AccountLogged[i])
				continue;
			
			if(getUserTeam(i) == FM_CS_TEAM_CT)
			{
				iCTsId[iCTs] = i;
				++iCTs;
			}
			else if(getUserTeam(i) == FM_CS_TEAM_T)
			{
				iTsId[iTs] = i;
				++iTs;
			}
		}
		
		if((iCTs + iTs) == 0)
		{
			remove_task(TASK_CHECK_GUARDS);
			set_task(10.0, "checkGuards", TASK_CHECK_GUARDS);
			
			return;
		}
		
		colorChat(0, _, "%sTodos los usuarios conectados !gtienen prohibido!y ser guardia, sin embargo, para no interrumpir el juego, igual se hará", JB_PREFIX);
		colorChat(0, _, "!yguardia a alguien, pero !gestén advertidos!y, puede que !geste usuario VUELVA a incumplir las reglas!y!", JB_PREFIX);
	}
	
	iTotal = iCTs + iTs;
	
	switch(iTotal)
	{
		case 9: iHowCTs = 2;
		case 13: iHowCTs = 3;
		case 16: iHowCTs = 4;
	}
	
	if(iTotal < 4)
		iHowCTs = 1;
	
	if(iCTs == iHowCTs)
		return;
	
	new id;
	
	while(iCTs > iHowCTs) // PASAR CT a T
	{
		id = iCTsId[random_num(0, (iCTs - 1))]
		
		if(g_Simon[id])
			clcmd_NoSimon(id);
		
		setUserTeam(id, FM_CS_TEAM_T);
		
		if(is_user_alive(id))
			dllfunc(DLLFunc_Spawn, id);
		else
			ExecuteHamB(Ham_CS_RoundRespawn, id);
		
		--iCTs;
	}
	
	while(iCTs < iHowCTs) // PASAR T a CT
	{
		id = iTsId[random_num(0, (iTs - 1))]
		
		setUserTeam(id, FM_CS_TEAM_CT);
		
		if(is_user_alive(id))
			dllfunc(DLLFunc_Spawn, id);
		else
			ExecuteHamB(Ham_CS_RoundRespawn, id);
		
		++iCTs;
	}
}*/

public fw_PlayerSpawn_Post(id)
{
	if(!is_user_alive(id))
		return;
	
	if(g_KillGuards)
		return;
	
	remove_task(id + TASK_SPAWN);
	remove_task(id + TASK_MODEL);
	remove_task(id + TASK_LAST_REQUEST);
	remove_task(id + TASK_ULTIMA_VOLUNTAD);
	
	clearWeapons(id);
	
	if(!g_AccountLogged[id])
	{
		user_silentkill(id);
		colorChat(id, _, "%sDebes !gREGISTRARTE!y/!gIDENTIFICARTE!y para poder jugar. Presiona la !gtecla M!y si no aparece ningún menú.", JB_PREFIX);
		
		return;
	} else if(g_Mancha) {
		user_silentkill(id);
		colorChat(id, _, "%sNo podés aparecer vivo mientras está la mancha en juego.", JB_PREFIX);
		
		return;
	}
	
	if(getUserTeam(id) == FM_CS_TEAM_T)
		++g_PrissonersAlive;
	else
		g_GlowColor[id] = -5;
	
	set_task(0.4, "hideHUDs", id + TASK_SPAWN);
	set_task(2.0, "respawnUserCheck", id + TASK_SPAWN);
	
	set_user_rendering(id);
	cs_set_user_money(id, 0, 0);
	
	// if(getUserTeam(id) == FM_CS_TEAM_T) {
		// if(g_Hat_NextRound[id]) {
			// setHat(id, g_Hat_NextRound[id]);
		// }
		// else if(g_Costume_NextRound[id]) {
			// setCostume(id, g_Costume_NextRound[id]);
		// }
	// } else if(getUserTeam(id) == FM_CS_TEAM_CT) {
		// #if defined HATS_DEBUG
			// log_to_file("hats_debug.txt", "fw_PlayerSpawn_Post(id) - 1");
		// #endif
		// if(is_valid_ent(g_Hat[id])) {
			// #if defined HATS_DEBUG
				// log_to_file("hats_debug.txt", "fw_PlayerSpawn_Post(id) - 2");
			// #endif
			// remove_entity(g_Hat[id]);
			// #if defined HATS_DEBUG
				// log_to_file("hats_debug.txt", "fw_PlayerSpawn_Post(id) - 3");
			// #endif
		// }
		
		// if(g_Costume[id]) {
			// new i;
			// for(i = 0; i < 4; ++i) {
				// if(is_valid_ent(g_Costume_Parts[id][i])) {
					// remove_entity(g_Costume_Parts[id][i]);
				// }
			// }
		// }
	// }
	
	if(g_FreeDayNextRound[id])
	{
		g_UserFree[id] = 1;
		
		colorChat(0, TERRORIST, "%sEl prisionero !t%s!y tiene !gdía libre!y ya que fue su !gúltima voluntad!y.", JB_PREFIX, g_PlayerName[id]);
		
		set_user_rendering(id, kRenderFxGlowShell, 0, 255, 0, kRenderNormal, 25);
		
		remove_task(TASK_USERFREE);
		set_task(300.0, "removeUserFree", TASK_USERFREE);
	} else if(g_NextRound_UserFree[id]) {
		g_NextRound_UserFree[id] = 0;
		g_UserFree[id] = 1;
		
		colorChat(0, TERRORIST, "%sEl prisionero !t%s!y tiene !gdía libre!y ya que se lo dieron en la ronda pasada estando muerto!", JB_PREFIX, g_PlayerName[id]);
		
		set_user_rendering(id, kRenderFxGlowShell, 0, 255, 0, kRenderNormal, 25);
		
		remove_task(TASK_USERFREE);
		set_task(300.0, "removeUserFree", TASK_USERFREE);
	}
	
	if(g_Escondidas)
	{
		removeWeapons(id);
		
		set_user_rendering(id);

		if(g_Escondidas == 2 && getUserTeam(id) == FM_CS_TEAM_T)
		{
			set_user_velocity(id, Float:{0.0, 0.0, 0.0});
			ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
			
			if(get_entity_flags(id) & FL_ONGROUND)
				set_user_gravity(id, 999999.9);
			else
				set_user_gravity(id, 0.000001);
		}
	}
	
	resetVars(id);
	
	if(g_BarraMetalicaDay[id])
	{
		--g_BarraMetalicaDay[id];
		
		if(!g_BarraMetalicaDay[id])
			g_BarraMetalica[id] = 0;
	}
	
	static iWeaponEnt;
	iWeaponEnt = getCurrentWeaponEnt(id);
	
	if(is_valid_ent(iWeaponEnt))
		replaceWeaponModels(id, cs_get_weapon_id(iWeaponEnt));
	
	static sCurrentModel[32];
	static sTempModel[32];
	static iAlreadyHasModel;
	
	iAlreadyHasModel = 0;
	
	getUserModel(id, sCurrentModel, charsmax(sCurrentModel));
	
	formatex(sTempModel, charsmax(sTempModel), "%s", (getUserTeam(id) == FM_CS_TEAM_T) ? MODELOS_PRISIONEROS[g_PrissonerModel[id]] : MODELOS_GUARDIAS[g_PoliceModel[id]]);
	
	if(equal(sCurrentModel, sTempModel))
		iAlreadyHasModel = 1;
	
	if(!iAlreadyHasModel)
	{
		formatex(g_UserModel[id], 31, sTempModel);
		userModelUpdate(id + TASK_MODEL);
	}
}

public respawnUserCheck(const taskid)
{
	if(is_user_alive(ID_SPAWN) || g_EndRound)
		return;
	
	static iTeam;
	iTeam = getUserTeam(ID_SPAWN);
	
	if(iTeam == FM_CS_TEAM_SPECTATOR || iTeam == FM_CS_TEAM_UNASSIGNED)
		return;
	
	ExecuteHamB(Ham_CS_RoundRespawn, ID_SPAWN);
}

public removeWeapons(const id)
{
	strip_user_weapons(id);
	set_pdata_int(id, OFFSET_PRIMARY_WEAPON, OFFSET_LINUX);
}

public fw_TakeDamage(const victim, const inflictor, const attacker, Float:damage, const damage_type)
{
	if((g_UltimaVoluntad[victim] || g_Duelo) && damage_type & DMG_FALL)
		return HAM_SUPERCEDE;
	
	if(victim == attacker || !is_user_valid_connected(attacker))
		return HAM_IGNORED;
	
	if(g_Escondidas == 1 || g_Mancha)
		return HAM_SUPERCEDE;
	else if(g_Escondidas == 2)
	{
		if(getUserTeam(attacker) == FM_CS_TEAM_T)
			return HAM_SUPERCEDE;
		
		return HAM_IGNORED;
	}
	
	if(g_Duelo == 2)
		return HAM_SUPERCEDE;
	else if(g_Duelo == 1)
	{
		if(g_InDuelo[attacker] && g_InDuelo[victim])
		{
			if((g_InDuelo[attacker] == (DUELO_BOX + 1)) && g_CurrentWeapon[attacker] == CSW_KNIFE)
				return HAM_IGNORED;
			else if((g_InDuelo[attacker] == (DUELO_DEAGLE + 1)) && g_CurrentWeapon[attacker] == CSW_DEAGLE)
				return HAM_IGNORED;
			else if((g_InDuelo[attacker] == (DUELO_AWP + 1)) && g_CurrentWeapon[attacker] == CSW_AWP)
				return HAM_IGNORED;
			else if((g_InDuelo[attacker] == (DUELO_SCOUT + 1)) && g_CurrentWeapon[attacker] == CSW_SCOUT)
				return HAM_IGNORED;
			else if(g_InDuelo[attacker] == (DUELO_GRANADAS + 1))
			{
				if(damage_type & DAMAGE_HEGRENADE)
					return HAM_IGNORED;
			}
		}
		else
		{
			if(damage_type & DAMAGE_HEGRENADE)
				return HAM_SUPERCEDE;
		}
		
		return HAM_SUPERCEDE;
	}
	
	static iVictimTeam;
	static iAttackerTeam;
	
	iVictimTeam = getUserTeam(victim);
	iAttackerTeam = getUserTeam(attacker);
	
	if(g_Boxeo)
	{
		if(g_BoxeoGeneral)
		{
			if(iVictimTeam == iAttackerTeam && iVictimTeam == FM_CS_TEAM_T)
			{
				setUserTeam(victim, FM_CS_TEAM_CT);
				
				// if(g_BarraMetalica[attacker])
					// damage *= 2.0;
				
				if((get_user_health(victim) - floatround(damage)) < 1)
				{
					setUserTeam(victim, FM_CS_TEAM_T);
					
					ExecuteHamB(Ham_Killed, victim, attacker, 1);
					return HAM_SUPERCEDE;
				}
				else
					damage /= 2.0;
				
				ExecuteHamB(Ham_TakeDamage, victim, inflictor, attacker, damage, damage_type);
				
				setUserTeam(victim, FM_CS_TEAM_T);
				
				return HAM_SUPERCEDE;
			}
		}
		else
		{
			new iOk = 0;
			
			// 2 = blanco c amarillo
			// 4 = blanco c violeta
			// 8 = blanco c celeste
			// 16 = amarillo c violeta
			// 32 = amarillo c celeste
			// 64 = violeta c celeste
			// 128 = blanco c amarillo c violeta
			// 256 = blanco c amarillo c celeste
			// 512 = blanco c violeta c celeste
			// 1024 = amarillo c violeta c celeste
			// 2048 = todos c todos
			
			if(g_GlowColor[attacker] == g_GlowColor[victim])
				return HAM_IGNORED;
			
			if(g_BoxGlowColors != 2048)
			{
				switch(g_BoxGlowColors)
				{
					case 2:
					{
						if((g_GlowColor[attacker] == C_BLANCO || g_GlowColor[attacker] == C_AMARILLO) && ((g_GlowColor[victim] == C_BLANCO || g_GlowColor[victim] == C_AMARILLO)))
							iOk = 1;
					}
					case 4:
					{
						if((g_GlowColor[attacker] == C_BLANCO || g_GlowColor[attacker] == C_VIOLETA) && ((g_GlowColor[victim] == C_BLANCO || g_GlowColor[victim] == C_VIOLETA)))
							iOk = 1;
					}
					case 8:
					{
						if((g_GlowColor[attacker] == C_BLANCO || g_GlowColor[attacker] == C_CELESTE) && ((g_GlowColor[victim] == C_BLANCO || g_GlowColor[victim] == C_CELESTE)))
							iOk = 1;
					}
					case 16:
					{
						if((g_GlowColor[attacker] == C_AMARILLO || g_GlowColor[attacker] == C_VIOLETA) && ((g_GlowColor[victim] == C_AMARILLO || g_GlowColor[victim] == C_VIOLETA)))
							iOk = 1;
					}
					case 32:
					{
						if((g_GlowColor[attacker] == C_AMARILLO || g_GlowColor[attacker] == C_CELESTE) && ((g_GlowColor[victim] == C_AMARILLO || g_GlowColor[victim] == C_CELESTE)))
							iOk = 1;
					}
					case 64:
					{
						if((g_GlowColor[attacker] == C_VIOLETA || g_GlowColor[attacker] == C_CELESTE) && ((g_GlowColor[victim] == C_VIOLETA || g_GlowColor[victim] == C_CELESTE)))
							iOk = 1;
					}
					case 128:
					{
						if((g_GlowColor[attacker] == C_BLANCO || g_GlowColor[attacker] == C_AMARILLO || g_GlowColor[attacker] == C_VIOLETA) && ((g_GlowColor[victim] == C_BLANCO || g_GlowColor[victim] == C_AMARILLO || g_GlowColor[victim] == C_VIOLETA)))
							iOk = 1;
					}
					case 256:
					{
						if((g_GlowColor[attacker] == C_BLANCO || g_GlowColor[attacker] == C_AMARILLO || g_GlowColor[attacker] == C_CELESTE) && ((g_GlowColor[victim] == C_BLANCO || g_GlowColor[victim] == C_AMARILLO || g_GlowColor[victim] == C_CELESTE)))
							iOk = 1;
					}
					case 512:
					{
						if((g_GlowColor[attacker] == C_BLANCO || g_GlowColor[attacker] == C_VIOLETA || g_GlowColor[attacker] == C_CELESTE) && ((g_GlowColor[victim] == C_BLANCO || g_GlowColor[victim] == C_VIOLETA || g_GlowColor[victim] == C_CELESTE)))
							iOk = 1;
					}
					case 1024:
					{
						if((g_GlowColor[attacker] == C_AMARILLO || g_GlowColor[attacker] == C_VIOLETA || g_GlowColor[attacker] == C_CELESTE) && ((g_GlowColor[victim] == C_AMARILLO || g_GlowColor[victim] == C_VIOLETA || g_GlowColor[victim] == C_CELESTE)))
							iOk = 1;
					}
				}
			}
			else
				iOk = 1;
			
			if(iOk)
			{
				if(iVictimTeam == iAttackerTeam && iVictimTeam == FM_CS_TEAM_T)
				{
					setUserTeam(victim, FM_CS_TEAM_CT);
					
					// if(g_BarraMetalica[attacker])
						// damage *= 2.0;
					
					if((get_user_health(victim) - floatround(damage)) < 1)
					{
						setUserTeam(victim, FM_CS_TEAM_T);
						
						ExecuteHamB(Ham_Killed, victim, attacker, 1);
						return HAM_SUPERCEDE;
					}
					else
						damage /= 2.0;
					
					ExecuteHamB(Ham_TakeDamage, victim, inflictor, attacker, damage, damage_type);
					
					setUserTeam(victim, FM_CS_TEAM_T);
					
					return HAM_SUPERCEDE;
				}
			}
		}
	}
	
	if(iVictimTeam == FM_CS_TEAM_T && (damage_type & DAMAGE_HEGRENADE))
		return HAM_SUPERCEDE;
	
	// if(!g_IraBlock && getUserTeam(attacker) == FM_CS_TEAM_T && getUserTeam(victim) == FM_CS_TEAM_CT)
		// g_Ira[attacker] += random_num(1, 2);
	
	if(g_BarraMetalica[attacker])
	{
		damage *= 2.0;
		SetHamParamFloat(4, damage);
	}
	
	return HAM_IGNORED;
}

public fw_ObjectCaps_Pre(const id)
{
	if(is_user_alive(id) && (((getUserTeam(id) == FM_CS_TEAM_CT && g_Escondidas == 1) || (getUserTeam(id) == FM_CS_TEAM_T && g_Escondidas == 2)) || g_Duelo))
	{
		new iButton;
		iButton = entity_get_int(id, EV_INT_button);
		
		if(iButton & IN_USE)
			entity_set_int(id, EV_INT_button, iButton & ~IN_USE);
		
		iButton = get_pdata_int(id, OFFSET_BUTTON_PRESSED);
		
		if(iButton & IN_USE)
			set_pdata_int(id, OFFSET_BUTTON_PRESSED, iButton & ~IN_USE);
		
		return HAM_HANDLED;
	}
	
	return HAM_IGNORED;
}

public fw_ObjectCaps_Post(const id)
{
	if(pev_valid(g_Ball) && is_user_alive(id))
	{
		static iOwner;
		iOwner = entity_get_int(g_Ball, EV_INT_iuser4);
		
		if(iOwner == id)
			kickBall(id);
	}
}

public fw_PlayerPostThink(const id)
{
	if(!g_Simon[id] || !(entity_get_int(id, EV_INT_flags) & FL_ONGROUND) || entity_get_int(id, EV_ENT_groundentity))
		return;
	
	static Float:vecOrigin[3];
	static Float:vecLast[3];
	
	entity_get_vector(id, EV_VEC_origin, vecOrigin);
	
	if(get_distance_f(vecOrigin, vecLast) < 32.0)
		return;
	
	vecLast[0] = vecOrigin[0];
	vecLast[1] = vecOrigin[1];
	vecLast[2] = vecOrigin[2];
	
	if(entity_get_int(id, EV_INT_bInDuck))
		vecOrigin[2] -= 18.0;
	else
		vecOrigin[2] -= 36.0;
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY, {0, 0, 0}, 0);
	write_byte(TE_WORLDDECAL);
	write_coord(floatround(vecOrigin[0]));
	write_coord(floatround(vecOrigin[1]));
	write_coord(floatround(vecOrigin[2]));
	write_byte(105);
	message_end();
}

public fw_PlayerKilled(const victim, const killer, const shouldgib)
{
	remove_task(victim + TASK_PISS);
	remove_task(victim + TASK_CAMPING);
	remove_task(victim + TASK_LAST_REQUEST);
	remove_task(victim + TASK_ULTIMA_VOLUNTAD);
	
	if((g_MN_Motin && !g_MN_MotinCountDown) || g_Escondidas == 2) {
		g_NightVision[victim] = 1;
		
		remove_task(victim + TASK_NVISION);
		set_task(0.3, "setUserNightvision", victim + TASK_NVISION, _, _, "b");
	}
	
	if(getUserTeam(victim) == FM_CS_TEAM_T) {
		--g_PrissonersAlive;
		
		if(g_PrissonersAlive == 1) {
			new i;
			for(i = 1; i <= g_MaxPlayers; ++i) {
				if(i == victim) {
					continue;
				}
				
				if(getUserTeam(i) == FM_CS_TEAM_T) {
					setAchievement(i, WAR_OF_ATTRITION);
					
					break;
				}
			}
		}
	}
	
	if(g_InDuelo[victim]) {
		g_InDuelo[victim] = 0;
		
		new i;
		for(i = 1; i <= g_MaxPlayers; ++i)
		{
			if(!is_user_alive(i))
				continue;
			
			if(!g_InDuelo[i])
				continue;
			
			if(getUserTeam(i) == FM_CS_TEAM_T) {
				if(g_InDuelo[i] == 1) {
					setAchievement(i, MAKE_THE_PINIA);
				} else if(g_InDuelo[i] == 2) {
					setAchievement(i, PIECE_INITIATIVE);
				}
			}
			
			g_InDuelo[i] = 0;
			g_BlockDrop[i] = 0;
			
			if(getUserAliveCTs() >= 1 && getUserTeam(i) == FM_CS_TEAM_T) {
				showMenu__DueloUsers(i, g_MenuUsersMode[i]);
				
				remove_task(i + TASK_ULTIMA_VOLUNTAD);
				set_task(15.0, "__removeUltimaVoluntad", i + TASK_ULTIMA_VOLUNTAD);
			}
			
			break;
		}
	}
	
	if(victim == killer || !is_user_valid_connected(killer))
	{
		if(g_Simon[victim])
			clcmd_NoSimon(victim);
		
		if(getUserTeam(victim) == FM_CS_TEAM_CT && !g_ChangeTeam[victim] && !g_Escondidas && !g_Mancha)
		{
			colorChat(victim, TERRORIST, "%sPerdiste !t25 Ira!y por suicidarte.", JB_PREFIX);
			g_Ira[victim] -= 25;
		}
		
		return HAM_IGNORED;
	}
	
	if(g_Escondidas == 2)
	{
		if(getUserTeam(victim) == FM_CS_TEAM_T)
		{
			new i;
			if(getUserAliveTs() > 0)
			{
				new iIra;
				for(i = 1; i <= g_MaxPlayers; ++i)
				{
					if(!is_user_alive(i))
						continue;
					
					if(getUserTeam(i) == FM_CS_TEAM_T)
					{
						iIra = random_num(1, 3);
						
						g_Ira[i] += iIra;
						colorChat(i, _, "%sGanaste !g+%d Ira!y por sobrevivir a un asesinato.", JB_PREFIX, iIra);
					}
				}
			}
			else
			{
				for(i = 1; i <= g_MaxPlayers; ++i)
				{
					if(!is_user_alive(i))
						continue;
					
					if(getUserTeam(i) == FM_CS_TEAM_CT) {
						g_Ira[i] += 25;
						
						setAchievement(i, COMMAND_AND_CONTROL);
					}
				}
				
				colorChat(0, _, "%sLos guardias ganaron !g+25 Ira!y por ganar las escondidas.", JB_PREFIX);
				
				++g_EscondidasWin_CT;
			}
		}
		
		return HAM_IGNORED;
	}
	
	if(!g_IraBlock)
	{
		if(getUserTeam(killer) == FM_CS_TEAM_T) {
			if(get_pdata_int(victim, 75) != HIT_HEAD) {
				g_Ira[killer] += random_num(5, 10);
			} else {
				g_Ira[killer] += random_num(10, 15);
			}
		} else if(getUserTeam(killer) == FM_CS_TEAM_CT && g_Achievement_Rebel[victim]) {
			setAchievement(killer, AVENGING_ANGEL);
		}
		
		if(getUserTeam(victim) == FM_CS_TEAM_CT) {
			++g_GuardKills[killer];
			
			if(g_GuardKills[killer] == 50) {
				setAchievement(killer, ASESINO);
			}
			
			if(g_Simon[victim]) {
				++g_SimonKills[killer];
				
				if(g_SimonKills[killer] == 50) {
					setAchievement(killer, FUERZA_INDOMABLE);
				}
			}
			
			if(getUserAliveTs() == 1 && !g_Duelo && !g_KillGuards) {
				g_UltimaVoluntad[killer] = 0;
				g_UltimaVoluntadSpent = 1;
				
				colorChat(0, TERRORIST, "%sEl prisionero ha asesinado a un !gguardia!y y ahora no puede obtener su última voluntad. Los guardias pueden matarlo!", JB_PREFIX);
			}
			
			while(g_GuardKills[killer] >= RANGOS[g_Rango[killer]][rangoGuards] && g_SimonKills[killer] >= RANGOS[g_Rango[killer]][rangoSimon])
			{
				++g_Rango[killer];
				colorChat(killer, TERRORIST, "%sFelicidades! Subiste al rango !g%s!y", JB_PREFIX, RANGOS[g_Rango[killer]][rangoName]);
			}
			
			if(!g_MN_Motin && !g_Invis[killer] && !g_Duelo) {
				g_Achievement_Rebel[killer] = 1;
				set_user_rendering(killer, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 25);
			} else if(g_MN_Motin) {
				++g_Achievement_GuardsMotin[killer];
				
				if(g_Achievement_GuardsMotin[killer] == 3) {
					setAchievement(killer, FUERZA_IMPARABLE);
				}
			}
		}
	}
	
	if(g_Simon[victim])
		clcmd_NoSimon(victim);
	
	return HAM_IGNORED;
}

public fw_ResetMaxSpeed_Post(const id)
{
	if(!is_user_alive(id))
		return;
	
	setUserMaxspeed(id);
}

public fw_ItemDeploy_Post(const weapon_ent)
{
	static iId;
	iId = getWeaponEntId(weapon_ent);
	
	if(!pev_valid(iId))
		return HAM_IGNORED;
	
	static iWeaponId;
	iWeaponId = cs_get_weapon_id(weapon_ent);
	
	if(iWeaponId == CSW_HEGRENADE || iWeaponId == CSW_FLASHBANG || iWeaponId == CSW_SMOKEGRENADE) {
		if((getUserTeam(iId) == FM_CS_TEAM_CT && !g_Duelo) || (g_InDuelo[iId] && g_InDuelo[iId] != 5)) {
			set_pdata_float(weapon_ent, OFFSET_NEXT_PRIMARY_ATTACK, 9999.0, OFFSET_LINUX_WEAPONS);
			return HAM_SUPERCEDE;
		}
	}
	
	g_CurrentWeapon[iId] = iWeaponId;
	
	if(iWeaponId == CSW_KNIFE)
		replaceWeaponModels(iId, iWeaponId);
	
	return HAM_IGNORED;
}

public fw_Item_AddToPlayer(const ent, const id)
{
	if(is_valid_ent(ent) && is_user_valid_connected(id))
	{
		new iEnt = entity_get_int(ent, EV_INT_impulse) - 133890;
		
		new i;
		for(i = 0; i < g_WeaponFloatingNum; ++i)
		{
			if(g_WeaponFloating[i] == iEnt)
				g_WeaponFloating[i] = 0;
		}
	}
	
	return HAM_IGNORED;
}

public fw_Item_AttachToPlayer(const iEnt, const id)
{
	if(!pev_valid(iEnt))
		return;
	
	if(!g_InDuelo[id])
		return;
	
	if(get_pdata_int(iEnt, OFFSET_KNOWN, OFFSET_LINUX_WEAPONS))
		return;
	
	set_pdata_int(iEnt, OFFSET_CLIPAMMO, 1, OFFSET_LINUX_WEAPONS);
}

public fw_Item_PostFrame(const iEnt)
{
	if(!pev_valid(iEnt))
		return;
	
	static id;
	id = get_pdata_cbase(iEnt, OFFSET_WEAPONOWNER, OFFSET_LINUX_WEAPONS);
	
	if(!is_user_valid_alive(id))
		return;
	
	if(!g_InDuelo[id])
		return;
	
	//static iWeapon;
	//iWeapon = get_pdata_int(iEnt, OFFSET_ID, OFFSET_LINUX_WEAPONS);
	
	//static iMaxClip;
	static iReload;
	static Float:fNextAttack;
	static iAmmoType;
	//static iBPAmmo;
	static iClip;
	static iButton;
	
	//iMaxClip = DEFAULT_MAXCLIP[iWeapon] + (2 * g_skill_weapons[id][iWeapon][3]);
	iReload = get_pdata_int(iEnt, OFFSET_IN_RELOAD, OFFSET_LINUX_WEAPONS);
	fNextAttack = get_pdata_float(id, OFFSET_NEXT_ATTACK, OFFSET_LINUX);
	iAmmoType = OFFSET_AMMO_PLAYER_SLOT0 + get_pdata_int(iEnt, OFFSET_PRIMARY_AMMO_TYPE, OFFSET_LINUX_WEAPONS);
	//iBPAmmo = get_pdata_int(id, iAmmoType, OFFSET_LINUX);
	iClip = get_pdata_int(iEnt, OFFSET_CLIPAMMO, OFFSET_LINUX_WEAPONS);
	iButton = entity_get_int(id, EV_INT_button);
	
	if(iReload && fNextAttack <= 0.0)
	{
		set_pdata_int(iEnt, OFFSET_CLIPAMMO, 1, OFFSET_LINUX_WEAPONS);
		set_pdata_int(id, iAmmoType, 200, OFFSET_LINUX);
		set_pdata_int(iEnt, OFFSET_IN_RELOAD, 0, OFFSET_LINUX_WEAPONS);
		
		iReload = 0;
	}
	
	if((iButton & IN_ATTACK && get_pdata_float(iEnt, OFFSET_NEXT_PRIMARY_ATTACK, OFFSET_LINUX_WEAPONS) <= 0.0) || (iButton & IN_ATTACK2 && get_pdata_float(iEnt, OFFSET_NEXT_SECONDARY_ATTACK, OFFSET_LINUX_WEAPONS) <= 0.0))
		return;
	
	if((iButton & IN_RELOAD) && !iReload)
	{
		if(iClip >= 1)
		{
			entity_set_int(id, EV_INT_button, iButton & ~IN_RELOAD);
			
			/*if(((1<<iWeapon) & WEAPONS_SILENT_BIT_SUM) && !get_pdata_int(iEnt, OFFSET_SILENT, OFFSET_LINUX_WEAPONS))
				setAnimation(id, (iWeapon == CSW_USP) ? 8 : 7);
			else*/
			
			setAnimation(id, 0);
		}
		/*else if(iClip == DEFAULT_MAXCLIP[iWeapon])
		{
			if(iBPAmmo)
			{
				set_pdata_float(id, OFFSET_NEXT_ATTACK, DEFAULT_DELAY[iWeapon], OFFSET_LINUX);

				if(((1<<iWeapon) & WEAPONS_SILENT_BIT_SUM) && get_pdata_int(iEnt, OFFSET_SILENT, OFFSET_LINUX_WEAPONS))
					setAnimation(id, (iWeapon == CSW_USP) ? 5 : 4);
				else
					setAnimation(id, DEFAULT_ANIMS[iWeapon]);
				
				set_pdata_int(iEnt, OFFSET_IN_RELOAD, 1, OFFSET_LINUX_WEAPONS);
				set_pdata_float(iEnt, OFFSET_TIME_WEAPON_IDLE, DEFAULT_DELAY[iWeapon] + 0.5, OFFSET_LINUX_WEAPONS);
			}
		}*/
	}
}

/*public message_DeathMsg()
{
	new iKiller = get_msg_arg_int(1);
	new iVictim = get_msg_arg_int(2);
	
	if(is_user_valid_connected(iKiller) && getUserTeam(iKiller) == FM_CS_TEAM_T && g_Guard[iVictim])
		set_msg_arg_int(1, ARG_BYTE, iVictim);
}*/

public message_FlashBat(const msg_id, const msg_dest, const msg_entity)
{
	if(get_msg_arg_int(1) < 100)
	{
		set_msg_arg_int(1, ARG_BYTE, 100);
		setUserBatteries(msg_entity, 100);
	}
}

public message_Flashlight()
	set_msg_arg_int(2, ARG_BYTE, 100);

public message_ScreenFade(const msg_id, const msg_dest, const msg_entity) {
	if(get_msg_arg_int(4) != 255 || get_msg_arg_int(5) != 255 || get_msg_arg_int(6) != 255 || get_msg_arg_int(7) < 200)
		return PLUGIN_CONTINUE;
	
	if(getUserTeam(msg_entity) != FM_CS_TEAM_T)
		return PLUGIN_CONTINUE;
	
	return PLUGIN_HANDLED;
}

public clcmd_ChangeTeam(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!g_AccountRegister[id] || !g_AccountLogged[id])
	{
		showMenu__RegisterLogin(id);
		return PLUGIN_HANDLED;
	}
	
	new iTeam;
	iTeam = getUserTeam(id);
	
	if(!g_ChangeTeam[id])
	{
		if(iTeam == FM_CS_TEAM_T || iTeam == FM_CS_TEAM_CT)
		{
			if(!g_UltimaVoluntad[id])
				showMenu__Game(id);
			else if(getUserAliveCTs() >= 1 && !g_InDuelo[id])
			{
				if(g_Duelo == 1)
					showMenu__DueloUsers(id, g_MenuUsersMode[id]);
				else
					showMenu__UltimaVoluntad(id);
			}
			
			return PLUGIN_HANDLED;
		}
	}
	
	new sParam[2];
	new iParam;
	
	read_argv(1, sParam, 1);
	iParam = str_to_num(sParam);
	
	switch(iParam)
	{
		case 2:
		{
			if(g_AccountBan[id])
			{
				client_print(id, print_center, "Tu cuenta está baneada y no podés ser guardia (CT).");
				
				client_cmd(id, "chooseteam");
				return PLUGIN_HANDLED;
			} else if(g_GuardKills[id] < 20) {
				client_print(id, print_center, "Necesitas matar 20+ guardias para ser guardia (CT). Te faltan %d", 20 - g_GuardKills[id]);
				
				client_cmd(id, "chooseteam");
				return PLUGIN_HANDLED;
			}
			
			if(iTeam == FM_CS_TEAM_UNASSIGNED && iTeam != FM_CS_TEAM_CT)
			{
				if(g_ChangeTeam[id] != 2)
				{
					new iUsers = getUsers();
					new iGuards = getGuards();
					
					if((iUsers < 9 && iGuards >= 1) || (iUsers < 13 && iGuards >= 2) || (iUsers < 16 && iGuards >= 3) || (iUsers < 22 && iGuards >= 4) || (iUsers >= 22 && iGuards >= 5))
					{
						client_print(id, print_center, "Hay demasiados guardias (CTs).");
						
						client_cmd(id, "chooseteam");
						return PLUGIN_HANDLED;
					}
				}
				
				//g_Guard[id] = 1;
			}
		}
		case 5:
		{
			client_print(id, print_center, "Esta opción está bloqueada");
			
			client_cmd(id, "chooseteam");
			return PLUGIN_HANDLED;
		}
		case 6:
		{
			if(!(get_user_flags(id) & ADMIN_KICK))
			{
				client_print(id, print_center, "Solo los administradores pueden ser espectadores");
				
				client_cmd(id, "chooseteam");
				return PLUGIN_HANDLED;
			}
		}
	}
	
	return PLUGIN_CONTINUE;
}

public clcmd_NightVision(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(g_NightVision[id])
	{
		if(task_exists(id + TASK_NVISION))
			remove_task(id + TASK_NVISION);
		else
			set_task(0.3, "setUserNightvision", id + TASK_NVISION, _, _, "b");
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_CreatePassword(const id)
{
	if(!is_user_connected(id) || g_AccountRegister[id])
		return PLUGIN_HANDLED;
	
	new sPassword[32];
	
	read_args(sPassword, 31);
	remove_quotes(sPassword);
	trim(sPassword);
	
	if(contain(sPassword, "%") != -1)
	{
		client_print(id, print_center, "Tu contraseña no puede contener el simbolo %%");
		
		clearDHUDs(id);
		
		showMenu__RegisterLogin(id);
		return PLUGIN_HANDLED;
	}
	
	new iLenPassword = strlen(sPassword);
	new iLenName = strlen(g_PlayerName[id]);
	
	if(iLenName < 3)
	{
		client_print(id, print_center, "Tu nombre debe tener al menos tres caracteres");
		
		clearDHUDs(id);
		
		showMenu__RegisterLogin(id);
		return PLUGIN_HANDLED;
	}
	
	if(iLenPassword < 4)
	{
		client_print(id, print_center, "La contraseña debe tener al menos 4 caracteres");
		
		clearDHUDs(id);
		
		showMenu__RegisterLogin(id);
		return PLUGIN_HANDLED;
	}
	else if(iLenPassword > 30)
	{
		client_print(id, print_center, "La contraseña no puede superar los treinta caracteres");
		
		clearDHUDs(id);
		
		showMenu__RegisterLogin(id);
		return PLUGIN_HANDLED;
	}
	
	copy(g_AccountPassword[id], 31, sPassword);
	
	client_cmd(id, "messagemode REPETIR_CONTRASENIA");
	
	clearDHUDs(id);
	
	set_dhudmessage(200, 0, 200, -1.0, 0.2, 0, 0.0, 500.0, 1.0, 1.0);
	show_dhudmessage(id, "REPITA LA CONTRASEÑA^nPARA SU CONFIRMACIÓN");
	
	return PLUGIN_HANDLED;
}

public clcmd_RepeatPassword(const id)
{
	if(!is_user_connected(id) || g_AccountRegister[id])
		return PLUGIN_HANDLED;
	
	new sPassword[32];
	
	read_args(sPassword, 31);
	remove_quotes(sPassword);
	trim(sPassword);
	
	if(!equal(g_AccountPassword[id], sPassword))
	{
		g_AccountPassword[id][0] = EOS;
	
		showMenu__RegisterLogin(id);
		
		set_dhudmessage(255, 0, 0, -1.0, 0.2, 0, 0.0, 5.0, 1.0, 1.0);
		show_dhudmessage(id, "LA CONTRASEÑA INGRESADA^nNO COINCIDE CON LA ANTERIOR");
		
		return PLUGIN_HANDLED;
	}
	
	clearDHUDs(id);
	
	new sIP[21];
	new sMD5_Password[34];
	
	get_user_ip(id, sIP, 20, 1);
	
	md5(sPassword, sMD5_Password);
	sMD5_Password[6] = EOS;
	
	if(g_AccountHID[id][0] == '!')
	{
		new OrpheuHook:handlePrintF;
		handlePrintF = OrpheuRegisterHook(OrpheuGetFunction("Con_Printf"), "Con_Printf");
		
		server_cmd("sxe_userhid #%d", get_user_userid(id));
		server_exec();
		
		OrpheuUnregisterHook(handlePrintF);
		
		copy(g_AccountHID[id], 63, g_MessageHID);
		
		replace_all(g_AccountHID[id], 63, "sxei_userhid: ", "");
		replace_all(g_AccountHID[id], 63, "[", "");
		replace_all(g_AccountHID[id], 63, "]", "");
		replace_all(g_AccountHID[id], 63, "^n", "");
		
		if(g_AccountHID[id][0] == '!' || equali(g_AccountHID[id], "no HID present, try again.") || equali(g_AccountHID[id], "") || containi(g_AccountHID[id], " ") != -1)
		{
			server_cmd("kick #%d ^"No se pudo obtener tu HID. Error sXe-I^"", get_user_userid(id));
			return PLUGIN_HANDLED;
		}
	}
	
	new Handle:sqlQuery;
	new iResults = 0;
	
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT jb_id, name, start, finish, name_admin, reason, mode FROM bans WHERE hid = ^"%s^" AND mode > '0' ORDER BY mode DESC LIMIT 1;", g_AccountHID[id]);
	
	if(!SQL_Execute(sqlQuery))
		executeQuery(id, sqlQuery, 6);
	else if(SQL_NumResults(sqlQuery)) // Baneado
	{
		iResults = SQL_NumResults(sqlQuery);
		
		g_AccountBan[id] = SQL_ReadResult(sqlQuery, 6);
		
		if(g_AccountBan[id] == 2)
		{
			new iId;
			new sAccountName[32];
			new sStart[32];
			new sFinish[32];
			new sAdmin[32];
			new sReason[128];
			
			iId = SQL_ReadResult(sqlQuery, 0);
			SQL_ReadResult(sqlQuery, 1, sAccountName, 31);
			SQL_ReadResult(sqlQuery, 2, sStart, 31);
			SQL_ReadResult(sqlQuery, 3, sFinish, 31);
			SQL_ReadResult(sqlQuery, 4, sAdmin, 31);
			SQL_ReadResult(sqlQuery, 5, sReason, 127);
			
			console_print(id, "");
			console_print(id, "");
			console_print(id, "****** GAM!NGA ******");
			console_print(id, "");
			console_print(id, "OTRA DE TUS CUENTAS ESTÁ BANEADA, POR LO TANTO, NO PODÉS CREAR NUEVAS CUENTAS");
			console_print(id, "");
			console_print(id, "Tu otra cuenta baneada: %s", sAccountName);
			console_print(id, "Administrador que la baneo: %s", sAdmin);
			console_print(id, "Razón: %s", sReason);
			console_print(id, "El ban fue realizado en la fecha: %s", sStart);
			console_print(id, "El ban expira en la fecha: %s", sFinish);
			console_print(id, "Cuenta #%d", iId);
			console_print(id, "");
			console_print(id, "****** GAM!NGA ******");
			console_print(id, "");
			console_print(id, "");
			
			server_cmd("kick #%d ^"Tu cuenta está baneada! - Mira tu consola^"", get_user_userid(id));
			
			SQL_FreeHandle(sqlQuery);
			
			return PLUGIN_HANDLED;
		}
		
		SQL_FreeHandle(sqlQuery);
	}
	else
		SQL_FreeHandle(sqlQuery);
	
	if(g_AccountBan[id] == 2)
		return PLUGIN_HANDLED;
	
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "INSERT INTO users (`name`, `password`, `ip`, `register`, `last_connect`, `hid`) VALUES (^"%s^", '%s', '%s', now(), now(), ^"%s^");", g_PlayerName[id], sMD5_Password, sIP, g_AccountHID[id]);
	if(!SQL_Execute(sqlQuery))
	{
		executeQuery(id, sqlQuery, 1);
		log_to_file("jb_query.log", "^"%s^", ^"%s^", ^"%s^", ^"%s^"", g_PlayerName[id], sMD5_Password, sIP, g_AccountHID[id]);
	}
	else
	{
		SQL_FreeHandle(sqlQuery);
		
		sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT id FROM users WHERE name=^"%s^";", g_PlayerName[id]);
		if(!SQL_Execute(sqlQuery))
			executeQuery(id, sqlQuery, 2);
		else if(SQL_NumResults(sqlQuery))
		{
			g_UserId[id] = SQL_ReadResult(sqlQuery, 0);
			
			new sRegisterCount[15];
			addDot(g_UserId[id], sRegisterCount, 14);
			
			colorChat(0, _, "%sBienvenido !g%s!y, eres la cuenta registrada !g#%s!y.", JB_PREFIX, g_PlayerName[id], sRegisterCount);
			
			g_AccountRegister[id] = 1;
			g_AccountLogged[id] = 1;
			
			SQL_FreeHandle(sqlQuery);
			
			if(g_AccountBan[id])
				colorChat(0, _, "%sCoincidencias encontradas con otras cuentas baneadas de !g%s!y para ser guardia: !g%d!y. Baneando ésta también...", JB_PREFIX, g_PlayerName[id], iResults);
		}
		else
			SQL_FreeHandle(sqlQuery);
		
		remove_task(id + TASK_SAVE);
		set_task(random_float(300.0, 600.0), "saveTask", id + TASK_SAVE, _, _, "b");
		
		resetInfo(id);
		client_cmd(id, "setinfo jb1 ^"%s^"", sMD5_Password);
		
		set_dhudmessage(255, 255, 0, -1.0, 0.2, 0, 0.0, 5.0, 1.0, 1.0);
		show_dhudmessage(id, "¡SE HA REGISTRADO EXITOSAMENTE!");
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_EnterPassword(const id)
{
	if(!is_user_connected(id) || !g_AccountRegister[id] || g_AccountLogged[id])
		return PLUGIN_HANDLED;
	
	new sPassword[32];
	new sMD5_Password[34];
	
	read_args(sPassword, 31);
	remove_quotes(sPassword);
	trim(sPassword);
	
	md5(sPassword, sMD5_Password);
	sMD5_Password[6] = EOS;
	
	if(!equal(g_AccountPassword[id], sMD5_Password))
	{
		showMenu__RegisterLogin(id);
		
		set_dhudmessage(255, 0, 0, -1.0, 0.2, 0, 0.0, 5.0, 1.0, 1.0);
		show_dhudmessage(id, "LA CONTRASEÑA INGRESADA^nNO COINCIDE CON LA DE ESTA CUENTA");
		
		return PLUGIN_HANDLED;
	}
	
	g_AccountLogged[id] = 1;
	
	resetInfo(id);
	client_cmd(id, "setinfo jb1 ^"%s^"", sMD5_Password);
	
	loadInfo(id);
	
	remove_task(id + TASK_SAVE);
	set_task(random_float(300.0, 600.0), "saveTask", id + TASK_SAVE, _, _, "b");
	
	clearDHUDs(id);
	
	client_cmd(id, "chooseteam");
	return PLUGIN_HANDLED;
}

public clcmd_Simon(const id)
{
	if(getUserTeam(id) != FM_CS_TEAM_CT)
	{
		colorChat(id, _, "%sSolo los guardias pueden utilizar este comando.", JB_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(g_SimonId)
	{
		colorChat(id, _, "%sYa hay !gSimón!y y es !g%s!y.", JB_PREFIX, g_PlayerName[g_SimonId]);
		return PLUGIN_HANDLED;
	}
	else if(g_FreeDay || g_Day == 0)
	{
		colorChat(id, _, "%sNo se puede ser !gSimón!y cuando es !gdía libre!y.", JB_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(g_BlockSimon)
	{
		colorChat(id, _, "%sNo se puede ser !gSimón!y cuando ya has ofrecido la !gúltima voluntad!y.", JB_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(g_SimonDone[id] > get_gametime())
	{
		colorChat(id, _, "%sFuiste !gSimón!y hace unos segundos, espera cinco segundos para volver a ser !gSimón!y.", JB_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(g_UltimaVoluntadSpent || g_Escondidas || g_Mancha)
	{
		colorChat(id, _, "%sNo podés ser !gSimón!y ahora.", JB_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(!is_user_alive(id))
	{
		colorChat(id, _, "%sNo podés ser !gSimón!y estando meurto.", JB_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	remove_task(TASK_NOSIMON);
	
	g_SimonDone[id] = get_gametime() + 5.0;
	
	g_Simon[id] = 1;
	g_SimonId = id;
	
	set_user_rendering(id, kRenderFxGlowShell, 0, 0, 255, kRenderNormal, 25);
	
	clearDHUDs(0);
	
	/*set_hudmessage(0, 0, 255, -1.0, 0.2, 0, 5.0, 5.0, 1.0, 1.0, -1);
	ShowSyncHudMsg(id, g_HudNotif, "%s ES SIMÓN", g_PlayerName[id]);*/
	
	set_dhudmessage(0, 0, 255, -1.0, 0.2, 0, 5.0, 5.0, 1.0, 1.0);
	show_dhudmessage(0, "%s ES SIMÓN", g_PlayerName[id]);
	
	formatex(g_UserModel[id], 31, MODELOS_GUARDIAS[0]);
	userModelUpdate(id + TASK_MODEL);
	
	return PLUGIN_HANDLED;
}

public clcmd_NoSimon(const id)
{	
	if(!g_Simon[id])
	{
		colorChat(id, _, "%sNo eres !gSimón!y.", JB_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	new i;
	for(i = 1; i <= g_MaxPlayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		g_Mic[i] = 0;
	}
	
	remove_task(TASK_NOSIMON);
	
	if(!g_UltimaVoluntadSpent && !g_MN_Motin && !g_Escondidas && !g_Mancha)
		set_task(30.0, "freeDayGeneral__NoSimon", TASK_NOSIMON);
	
	/*set_hudmessage(255, 0, 0, -1.0, 0.2, 0, 5.0, 5.0, 1.0, 1.0, -1);
	ShowSyncHudMsg(id, g_HudNotif, "%s NO ES MÁS SIMÓN", g_PlayerName[g_SimonId]);*/
	
	clearDHUDs(0);
	
	set_dhudmessage(255, 0, 0, -1.0, 0.2, 0, 5.0, 5.0, 1.0, 1.0);
	show_dhudmessage(0, "%s NO ES MÁS SIMÓN", g_PlayerName[g_SimonId]);
	
	if(is_user_connected(id))
		set_user_rendering(id);
	
	g_Simon[g_SimonId] = 0;
	g_SimonId = 0;
	
	if(g_Boxeo || g_BoxeoCountDown > 0)
	{
		colorChat(0, _, "%sEl !gboxeo!y se ha deshabilitado porque no hay !gSimón!y.", JB_PREFIX);
		
		for(i = 1; i <= g_MaxPlayers; ++i)
		{
			if(!is_user_connected(i))
				continue;
			
			if(!is_user_alive(i))
				continue;
			
			if(getUserTeam(i) != FM_CS_TEAM_T)
				continue;
			
			set_user_health(i, 100);
		}
		
		g_BoxeoGeneral = 0;
		g_Boxeo = 0;
		
		g_BoxColors[C_BLANCO] = 0;
		g_BoxColors[C_AMARILLO] = 0;
		g_BoxColors[C_VIOLETA] = 0;
		g_BoxColors[C_CELESTE] = 0;
		
		g_BoxeoCountDown = 0;
		
		remove_task(TASK_BOX_COUNTDOWN);
	}
	
	formatex(g_UserModel[id], 31, MODELOS_GUARDIAS[g_PoliceModel[id]]);
	userModelUpdate(id + TASK_MODEL);
	
	return PLUGIN_HANDLED;
}

public clcmd_FreeDay(const id)
{
	if(!g_Simon[id] && !(get_user_flags(id) & ADMIN_BAN))
	{
		colorChat(id, _, "%sNo eres !gSimón!y.", JB_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	if(g_MN_Motin || g_Escondidas || g_Mancha)
		return PLUGIN_HANDLED;
	
	showMenu__DiaLibre(id);
	return PLUGIN_HANDLED;
}

public clcmd_OpenJails(const id)
{
	if(!g_Simon[id] && !(get_user_flags(id) & ADMIN_BAN))
	{
		colorChat(id, _, "%sNo eres !gSimón!y.", JB_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(g_MN_Motin)
		return PLUGIN_HANDLED;
	
	if(g_Simon[id])
		colorChat(0, _, "%sLas celdas fueron abiertas por !gSimón!y.", JB_PREFIX);
	else if(g_UserId[id] != 1)
		colorChat(0, TERRORIST, "%sLas celdas fueron abiertas por !t%s!y.", JB_PREFIX, g_PlayerName[id]);
	
	openJails();
	return PLUGIN_HANDLED;
}

public clcmd_UltimaVoluntad(const id)
{
	if(!g_Simon[id])
	{
		if(getUserTeam(id) == FM_CS_TEAM_T)
		{
			if(g_UltimaVoluntad[id])
				showMenu__UltimaVoluntad(id);
			else
				colorChat(id, _, "%sNo tenés !gúltima voluntad!y.", JB_PREFIX);
		}
		else
			colorChat(id, _, "%sNo eres !gSimón!y.", JB_PREFIX);
		
		return PLUGIN_HANDLED;
	}
	else if(g_MN_Motin)
		return PLUGIN_HANDLED;
	
	showMenu__Users(id, ULTIMA_VOLUNTAD);
	return PLUGIN_HANDLED;
}

public clcmd_Shop(const id)
{
	showMenu__Tienda(id);
	return PLUGIN_HANDLED;
}

public clcmd_Box(const id)
{
	if(!g_Simon[id])
	{
		colorChat(id, _, "%sNo eres !gSimón!y.", JB_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(g_MN_Motin)
		return PLUGIN_HANDLED;
	
	showMenu__Boxeo(id);
	return PLUGIN_HANDLED;
}

public clcmd_NoBox(const id)
{
	if(!g_Simon[id])
	{
		colorChat(id, _, "%sNo eres !gSimón!y.", JB_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(g_MN_Motin)
		return PLUGIN_HANDLED;
	
	if(g_Boxeo)
	{
		colorChat(0, _, "%sEl !gboxeo!y ha sido deshabilitado por !gSimón!y.", JB_PREFIX);
		
		new i;
		for(i = 1; i <= g_MaxPlayers; ++i)
		{
			if(!is_user_connected(i))
				continue;
			
			if(!is_user_alive(i))
				continue;
			
			if(getUserTeam(i) != FM_CS_TEAM_T)
				continue;
			
			set_user_health(i, 100);
		}
	}
	
	g_BoxeoGeneral = 0;
	g_Boxeo = 0;
	
	g_BoxColors[C_BLANCO] = 0;
	g_BoxColors[C_AMARILLO] = 0;
	g_BoxColors[C_VIOLETA] = 0;
	g_BoxColors[C_CELESTE] = 0;
	
	g_BoxeoCountDown = 0;
	
	remove_task(TASK_BOX_COUNTDOWN);
	
	return PLUGIN_HANDLED;
}

public clcmd_Cagar(const id)
{
	if(!is_user_alive(id))
		return PLUGIN_HANDLED;
	
	if(!g_EST_Cagar[id])
		return PLUGIN_HANDLED;
	
	if(getUserTeam(id) != FM_CS_TEAM_T)
		return PLUGIN_HANDLED;
	
	if(g_EST_CagarDone[id] > get_gametime())
	{
		colorChat(id, _, "%sPodés cagar cada tres minutos.", JB_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	g_EST_CagarDone[id] = get_gametime() + ((g_UserId[id] != 1) ? 180.0 : 0.1);
	
	new Float:vecOrigin[3];
	entity_get_vector(id, EV_VEC_origin, vecOrigin);
	
	new iEnt;
	iEnt = create_entity("info_target");
	
	if(is_valid_ent(iEnt)) {
		entity_set_string(iEnt, EV_SZ_classname, "entMierda");
		
		entity_set_model(iEnt, MODELO_MIERDA);
		entity_set_int(iEnt, EV_INT_movetype, MOVETYPE_TOSS);
		entity_set_origin(iEnt, vecOrigin);
		
		emit_sound(iEnt, CHAN_BODY, SOUND_MIERDA[random_num(0, 1)], 1.0, ATTN_NORM, 0, PITCH_NORM);
		
		++g_Achievement_CountCagar[id];
		
		if(g_Achievement_CountCagar[id] == 10) {
			setAchievement(id, LAXANTE);
		}
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_Mear(const id)
{
	if(!is_user_alive(id))
		return PLUGIN_HANDLED;
	
	if(!g_EST_Pillar[id])
		return PLUGIN_HANDLED;
	
	if(getUserTeam(id) != FM_CS_TEAM_T)
		return PLUGIN_HANDLED;
	
	if(g_EST_PillarDone[id] > get_gametime())
	{
		colorChat(id, _, "%sPodés mear cada cinco minutos.", JB_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	g_EST_PillarDone[id] = get_gametime() + ((g_UserId[id] != 1) ? 300.0 : 5.0);
	
	//g_PissPuddleCount[id] = 1;
	
	emit_sound(id, CHAN_VOICE, SOUND_PISS, 1.0, ATTN_NORM, 0, PITCH_NORM);
	
	set_task(0.1, "makePiss", TASK_PISS + id, _, _,"a", 100);
	//set_task(2.2, "placePuddle", TASK_PISS + id, _, _, "a", 4);
	
	return PLUGIN_HANDLED;
}

public clcmd_Ball(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!g_Simon[id] && g_UserId[id] != 1)
	{
		colorChat(id, _, "%sSolo !gSimón!y tiene acceso a este comando.", JB_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	showMenu__Ball(id);
	
	return PLUGIN_HANDLED;
}

public clcmd_Tops(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	new sPosition[3];
	new iMenuId;
	new i;
	
	iMenuId = menu_create("TOPS 15", "menu__Tops");
	
	for(i = 0; i < sizeof(TOPS_15); ++i)
	{
		num_to_str((i + 1), sPosition, 2);
		menu_additem(iMenuId, TOPS_15[i][top15Name], sPosition);
	}
	
	menu_setprop(iMenuId, MPROP_EXITNAME, "SALIR");
	menu_setprop(iMenuId, MPROP_NEXTNAME, "SIGUIENTE");
	menu_setprop(iMenuId, MPROP_BACKNAME, "ATRÁS");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, 0);
	
	return PLUGIN_HANDLED;
}

public menu__Tops(const id, const menuid, const item)
{
	if(!is_user_connected(id))
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[3];
	new iNothing;
	
	menu_item_getinfo(menuid, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	DestroyLocalMenu(id, menuid);
	
	if(g_GameTime_Tops[id] > get_gametime())
	{
		colorChat(id, TERRORIST, "%sTenés que esperar !t5 segundos!y para ver otro !gTOP!y.", JB_PREFIX);
		
		clcmd_Tops(id);
		return PLUGIN_HANDLED;
	}
	
	g_GameTime_Tops[id] = get_gametime() + 5.0;
	
	new iItem = str_to_num(sBuffer) - 1;
	
	show_motd(id, TOPS_15[iItem][top15URL], TOPS_15[iItem][top15Name]);
	
	clcmd_Tops(id);
	return PLUGIN_HANDLED;
}

public clcmd_Juegos(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!g_Simon[id] && g_UserId[id] != 1)
	{
		colorChat(id, _, "%sSolo !gSimón!y tiene acceso a este comando.", JB_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	showMenu__MiniJuegos(id);
	
	return PLUGIN_HANDLED;
}

public showMenu__Ball(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!g_Simon[id] && g_UserId[id] != 1)
	{
		colorChat(id, _, "%sSolo !gSimón!y tiene acceso a este comando.", JB_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	new iMenuId;
	iMenuId = menu_create("OPCIONES DE LA PELOTA", "menu__Ball");
	
	menu_additem(iMenuId, "Crear pelota", "1");
	menu_additem(iMenuId, "Poner pelota en su lugar de origen^n", "2");
	//menu_additem(iMenuId, "Eliminar pelota", "3");
	
	if(get_user_flags(id) & ADMIN_PASSWORD)
	{
		menu_additem(iMenuId, "Crear arcos", "3");
		menu_additem(iMenuId, "Guardar posición de la pelota", "4");
	}
	
	menu_setprop(iMenuId, MPROP_EXITNAME, "SALIR");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, 0);
	
	return PLUGIN_HANDLED;
}

public menu__Ball(const id, const menuid, const item)
{
	if(!is_user_connected(id))
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[3];
	new iNothing;
	new iItem;
	
	menu_item_getinfo(menuid, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	iItem = str_to_num(sBuffer);
	
	if(iItem >= 1 && iItem <= 2 && !g_Simon[id] && g_UserId[id] != 1)
	{
		colorChat(id, _, "%sSolo !gSimón!y tiene acceso a este comando.", JB_PREFIX);
		
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	else if(iItem >= 3 && !(get_user_flags(id) & ADMIN_PASSWORD))
	{
		colorChat(id, _, "%sSolo los capitanes tienen acceso a este comando.", JB_PREFIX);
		
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	DestroyLocalMenu(id, menuid);
	
	switch(iItem)
	{
		case 1:
		{
			if(pev_valid(g_Ball))
				return PLUGIN_HANDLED;
			
			createBall(id);
		}
		case 2:
		{
			if(pev_valid(g_Ball) && !g_BallInRespawn)
			{
				entity_set_int(g_Ball, EV_INT_solid, SOLID_BBOX);
				entity_set_vector(g_Ball, EV_VEC_velocity, Float:{0.0, 0.0, 0.0});
				entity_set_origin(g_Ball, g_BallOrigin);
				
				entity_set_int(g_Ball, EV_INT_movetype, MOVETYPE_BOUNCE);
				entity_set_size(g_Ball, Float:{-15.0, -15.0, 0.0}, Float:{15.0, 15.0, 12.0});
				entity_set_int(g_Ball, EV_INT_iuser4, 0);
			}
		}
		/*case 3:
		{
			new iEnt;
			while((iEnt = find_ent_by_class(iEnt, CLASSNAME_BALL)) > 0)
				remove_entity(iEnt);
		}*/
		case 3:
		{
			new Float:vecOrigin[3];
			new vecOriginId[3];
			
			get_user_origin(id, vecOriginId, 3);
			
			IVecFVec(vecOriginId, vecOrigin);
			
			if(!g_ArcBall_First || g_ArcBall_First == 2)
			{
				g_ArcBall_Box[g_ArcBall_First] = vecOrigin;
				++g_ArcBall_First;
			}
			else
			{
				g_ArcBall_Box[g_ArcBall_First] = vecOrigin;
				++g_ArcBall_First;
				
				if(g_ArcBall_First == 2)
					createArc(id, g_ArcBall_Box[0], g_ArcBall_Box[1]);
				else
				{
					createArc(id, g_ArcBall_Box[2], g_ArcBall_Box[3]);
				
					new iFound;
					new iPos;
					new sData[32];
					new iFile = fopen(g_ArcFile, "r+");
					
					if(iFile)
					{
						while(!feof(iFile))
						{
							fgets(iFile, sData, 31);
							parse(sData, sData, 31);
							
							++iPos;
							
							if(equal(sData, g_MapName))
							{
								iFound = 1;
								
								new sText[256];
								formatex(sText, 255, "%s %f %f %f %f %f %f %f %f %f %f %f %f", g_MapName, g_ArcBall_Box[0][0], g_ArcBall_Box[0][1], g_ArcBall_Box[0][2], g_ArcBall_Box[1][0], g_ArcBall_Box[1][1], g_ArcBall_Box[1][2],
								g_ArcBall_Box[2][0], g_ArcBall_Box[2][1], g_ArcBall_Box[2][2], g_ArcBall_Box[3][0], g_ArcBall_Box[3][1], g_ArcBall_Box[3][2]);
								
								write_file(g_ArcFile, sText, iPos - 1);
								
								break;
							}
						}
						
						if(!iFound)
							fprintf(iFile, "%s %f %f %f %f %f %f %f %f %f %f %f %f^n", g_MapName, g_ArcBall_Box[0][0], g_ArcBall_Box[0][1], g_ArcBall_Box[0][2], g_ArcBall_Box[1][0], g_ArcBall_Box[1][1], g_ArcBall_Box[1][2],
							g_ArcBall_Box[2][0], g_ArcBall_Box[2][1], g_ArcBall_Box[2][2], g_ArcBall_Box[3][0], g_ArcBall_Box[3][1], g_ArcBall_Box[3][2]);
						
						fclose(iFile);
						
						colorChat(id, _, "%sEl archivo !g%s!y ha sido guardado exitosamente!", JB_PREFIX, g_ArcFile);
					}
				}
			}
			
			showMenu__Ball(id);
			return PLUGIN_HANDLED;
		}
		case 4:
		{
			new iBall;
			new iEntity;
			new Float:vecOrigin[3];
			
			while((iEntity = find_ent_by_class(iEntity, CLASSNAME_BALL)) > 0)
				iBall = iEntity;
			
			if(iBall > 0)
				entity_get_vector(iBall, EV_VEC_origin, vecOrigin);
			else
				return PLUGIN_HANDLED;
			
			new iFound;
			new iPos;
			new sData[32];
			new iFile = fopen(g_BallFile, "r+");
			
			if(!iFile)
				return PLUGIN_HANDLED;
			
			while(!feof(iFile))
			{
				fgets(iFile, sData, 31);
				parse(sData, sData, 31);
				
				++iPos;
				
				if(equal(sData, g_MapName))
				{
					iFound = 1;
					
					new sText[256];
					formatex(sText, 255, "%s %f %f %f", g_MapName, vecOrigin[0], vecOrigin[1], vecOrigin[2]);
					
					write_file(g_BallFile, sText, iPos - 1);
					
					break;
				}
			}
			
			if(!iFound)
				fprintf(iFile, "%s %f %f %f^n", g_MapName, vecOrigin[0], vecOrigin[1], vecOrigin[2]);
			
			fclose(iFile);
			
			showMenu__Ball(id);
			colorChat(id, _, "%sEl archivo !g%s!y ha sido guardado exitosamente!", JB_PREFIX, g_BallFile);
		}
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_BlockCommand(const id)
	return PLUGIN_HANDLED;

public clcmd_Drop(const id)
{
	if(g_BlockDrop[id])
		return PLUGIN_HANDLED;
	
	return PLUGIN_CONTINUE;
}

public clcmd_SimonVoiceOn(const id)
{
	g_SimonVoice[id] = 1;
	
	client_cmd(id, "+voicerecord");

	return PLUGIN_HANDLED;
}

public clcmd_SimonVoiceOff(const id)
{
	g_SimonVoice[id] = 0;
	
	client_cmd(id, "-voicerecord");

	return PLUGIN_HANDLED;
}

public clcmd_Say(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	static sMessage[191];
	
	read_args(sMessage, 190);
	remove_quotes(sMessage);
	
	replace_all(sMessage, 190, "%", "");
	replace_all(sMessage, 190, "!y", "");
	replace_all(sMessage, 190, "!t", "");
	replace_all(sMessage, 190, "!g", "");
	
	if(equal(sMessage, "") || sMessage[0] == '/' || sMessage[0] == '@')
		return PLUGIN_HANDLED;
	
	if(g_Escondidas)
	{
		colorChat(id, _, "%sEl chat general está bloqueado durante el mini juego escondidas, escribí por say_team.", JB_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	static iTeam;
	iTeam = getUserTeam(id);
	
	static iAlive;
	iAlive = is_user_alive(id);
	
	if(iTeam == FM_CS_TEAM_T)
		format(sMessage, 190, "%s!t%s !g[!y%s!g]!y : %s", (iAlive) ? "" : "!y*DEAD* ", g_PlayerName[id], RANGOS[g_Rango[id]], sMessage);
	else if(iTeam == FM_CS_TEAM_CT)
		format(sMessage, 190, "%s!t%s!y : %s", (iAlive) ? "" : "!y*DEAD* ", g_PlayerName[id], sMessage);
	else
	{
		if(g_AccountLogged[id])
			format(sMessage, 190, "!y(ESPECTADOR)!t %s !y: %s", g_PlayerName[id], sMessage);
		else if(g_AccountRegister[id])
			format(sMessage, 190, "!y(SIN LOGUEARSE)!t %s !y: %s", g_PlayerName[id], sMessage);
		else
			format(sMessage, 190, "!y(SIN REGISTRARSE)!t %s !y: %s", g_PlayerName[id], sMessage);
		
		iTeam = 3;
	}
	
	if(iAlive) {
		colorChat(0, iTeam, sMessage);
	} else if(get_user_flags(id) & ADMIN_BAN) {
		colorChat(0, iTeam, sMessage);
	} else {
		new i;
		for(i = 1; i <= g_MaxPlayers; ++i) {
			if(!is_user_connected(i))
				continue;
			
			if(!(get_user_flags(i) & ADMIN_BAN)) {
				if(is_user_alive(i) && getUserTeam(i) == FM_CS_TEAM_T)
					continue;
			}
			
			colorChat(i, iTeam, sMessage);
		}
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_SayTeam(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	static iTeam;
	iTeam = getUserTeam(id);
	
	if(iTeam != FM_CS_TEAM_T && iTeam != FM_CS_TEAM_CT)
		return PLUGIN_HANDLED;
	
	static sMessage[191];
	
	read_args(sMessage, 190);
	remove_quotes(sMessage);
	
	replace_all(sMessage, 190, "%", "");
	replace_all(sMessage, 190, "!y", "");
	replace_all(sMessage, 190, "!t", "");
	replace_all(sMessage, 190, "!g", "");
	
	if(equal(sMessage, "") || sMessage[0] == '/' || sMessage[0] == '@')
		return PLUGIN_HANDLED;
	
	static iAlive;
	iAlive = is_user_alive(id);
	
	if(iTeam == FM_CS_TEAM_T)
		format(sMessage, 190, "%s!y(%s) !t%s !g[!y%s!g]!y : %s", (iAlive) ? "" : "!y*DEAD* ", (iTeam == FM_CS_TEAM_T) ? "PRISIONERO" : "GUARDIA", g_PlayerName[id], RANGOS[g_Rango[id]], sMessage);
	else
		format(sMessage, 190, "%s!y(%s) !t%s!y : %s", (iAlive) ? "" : "!y*DEAD* ", (iTeam == FM_CS_TEAM_T) ? "PRISIONERO" : "GUARDIA", g_PlayerName[id], sMessage);
		
	new i;
	for(i = 1; i <= g_MaxPlayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		if(!(get_user_flags(i) & ADMIN_BAN)) {
			if(iAlive && !is_user_alive(i))
				continue;
			
			if(!iAlive && is_user_alive(i))
				continue;
		}
		
		if(getUserTeam(i) == iTeam)
			colorChat(i, iTeam, sMessage);
	}
	
	return PLUGIN_HANDLED;
}

public concmd_Bot(const id)
{
	if(g_UserId[id] != 1)
		return PLUGIN_HANDLED;
	
	new sName[32];
	new id;
	
	++g_Bots;
	
	formatex(sName, 31, "BOT #%s%d", (g_Bots < 10) ? "0" : "", g_Bots);
	
	id = engfunc(EngFunc_CreateFakeClient, sName);
	if(pev_valid(id))
	{
		engfunc(EngFunc_FreeEntPrivateData, id);
		dllfunc(MetaFunc_CallGameEntity, "player", id);
		
		set_user_info(id, "rate", "3500");
		set_user_info(id, "cl_updaterate", "25");
		set_user_info(id, "cl_lw", "1");
		set_user_info(id, "cl_lc", "1");
		set_user_info(id, "cl_dlmax", "128");
		set_user_info(id, "cl_righthand", "1");
		set_user_info(id, "_vgui_menus", "0");
		set_user_info(id, "_ah", "0");
		set_user_info(id, "dm", "0");
		
		//set_pev(id, pev_colormap, id);
		
		new szMsg[128];
		dllfunc(DLLFunc_ClientConnect, id, sName, "127.0.0.1", szMsg);
		dllfunc(DLLFunc_ClientPutInServer, id);
		
		cs_set_user_team(id, CS_TEAM_T);
	}
	
	return PLUGIN_HANDLED;
}

public concmd_WalkGuardMenu(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!(get_user_flags(id) & ADMIN_PASSWORD))
		return PLUGIN_HANDLED;
	
	g_EditorId = id;
	
	findAllZones();
	showAllZones();
	
	openWGM(id);

	return PLUGIN_HANDLED;
}

public concmd_Team(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!(get_user_flags(id) & ADMIN_KICK))
		return PLUGIN_HANDLED;
	
	if(g_Mancha) {
		return PLUGIN_HANDLED;
	}
	
	new sArg1[32];
	new iTarget;
	
	read_argv(1, sArg1, 31);
	iTarget = cmd_target(id, sArg1, CMDTARGET_ALLOW_SELF);
	
	if(!iTarget)
		return PLUGIN_HANDLED;
	
	new sArg2[4];
	new iArg2;
	
	read_argv(2, sArg2, 3);
	iArg2 = str_to_num(sArg2);
	
	if(read_argc() < 3)
	{
		client_print(id, print_console, "[JB] Uso: jb_team <nombre o #id> <1 = T o 2 = CT>");
		return PLUGIN_HANDLED;
	}
	else if(g_MN_Motin)
	{
		client_print(id, print_console, "[JB] No se puede transferir jugadores cuando el MOTIN esta habilitado.");
		return PLUGIN_HANDLED;
	}
	else if(g_AccountBan[iTarget] && iArg2 == 2)
	{
		colorChat(id, _, "%sLa cuenta del usuario estaa baneada, no puede ser guardia.", JB_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(iArg2 < 1 || iArg2 > 2)
	{
		client_print(id, print_console, "[JB] El equipo destino esta mal (1 = T o 2 = CT).");
		return PLUGIN_HANDLED;
	}
	
	new iTeam;
	iTeam = getUserTeam(iTarget);
	
	if(iTeam != FM_CS_TEAM_T && iTeam != FM_CS_TEAM_CT)
	{
		client_print(id, print_console, "[JB] El usuario indicado tiene que ser CT o T para poder transferirlo");
		return PLUGIN_HANDLED;
	}
	else if((iTeam == FM_CS_TEAM_T && iArg2 == 1) || (iTeam == FM_CS_TEAM_CT && iArg2 == 2))
	{
		client_print(id, print_console, "[JB] No podes transferir a un usuario al mismo equipo en el que ya se encuentra");
		return PLUGIN_HANDLED;
	}
	
	g_ChangeTeam[iTarget] = 2;
	
	if(g_Simon[iTarget])
		clcmd_NoSimon(iTarget);
	
	set_pdata_int(iTarget, 125, (get_pdata_int(iTarget, 125, OFFSET_LINUX) & ~(1<<8)), OFFSET_LINUX);
	
	if(iArg2 == 1)
	{
		engclient_cmd(iTarget, "jointeam", "1");
		colorChat(0, TERRORIST, "%sEl administrador !t%s!y transfirió a !t%s!y a !gprisionero!y.", JB_PREFIX, g_PlayerName[id], g_PlayerName[iTarget]);
	}
	else
	{
		engclient_cmd(iTarget, "jointeam", "2");
		colorChat(0, TERRORIST, "%sEl administrador !t%s!y transfirió a !t%s!y a !gguardia!y.", JB_PREFIX, g_PlayerName[id], g_PlayerName[iTarget]);
	}
	
	engclient_cmd(iTarget, "joinclass", "5");
	
	//g_Guard[iTarget] = (iArg2 == 1) ? 0 : 1;
	
	g_ChangeTeam[iTarget] = 0;
	
	return PLUGIN_HANDLED;
}

public concmd_Ira(const id)
{
	if(g_UserId[id] != 1)
		return PLUGIN_HANDLED;
	
	new sArg1[32];
	new iTarget;
	
	read_argv(1, sArg1, 31);
	iTarget = cmd_target(id, sArg1, CMDTARGET_ALLOW_SELF);
	
	if(!iTarget)
		return PLUGIN_HANDLED;
	
	new sArg2[21];
	read_argv(2, sArg2, 20);
	
	if(read_argc() < 3)
	{
		client_print(id, print_console, "[JB] Uso: jb_ira <nombre o #id> <factor (+ , -) o nada para igualar> <cantidad>");
		return PLUGIN_HANDLED;
	}
	
	new iIra;
	new iLastIra;
	
	iIra = str_to_num(sArg2);
	iLastIra = g_Ira[iTarget];
	
	switch(sArg2[0])
	{
		case '+', '-':
		{
			g_Ira[iTarget] += iIra;
			
			colorChat(id, _, "%sLe has %s !g%d Ira!y a !g%s!y (Antes: !g%d!y)", JB_PREFIX, (sArg2[0] == '+') ? "dado" : "sacado", iIra, g_PlayerName[iTarget], iLastIra);
			colorChat(iTarget, TERRORIST, "%s!t%s!y te ha %s !g%d Ira!y (Antes: !g%d!y)", JB_PREFIX, g_PlayerName[id], (sArg2[0] == '+') ? "dado" : "sacado", iIra, iLastIra);
		}
		default:
		{
			g_Ira[iTarget] = iIra;
			
			colorChat(id, _, "%sLe has editado la !gIra!y a !g%s!y u ahora tiene !g%d Ira!y (Antes: !g%d!y)", JB_PREFIX, g_PlayerName[iTarget], iIra, iLastIra);
			colorChat(iTarget, TERRORIST, "%s!t%s!y te ha editado tu !gIra!y, ahora tenés !g%d Ira!y (Antes: !g%d!y)", JB_PREFIX, g_PlayerName[id], iIra, iLastIra);
		}
	}
	
	client_print(id, print_console, "[JB] %s tenia %d Ira y ahora tiene %d Ira", g_PlayerName[iTarget], iLastIra, g_Ira[iTarget]);
	
	return PLUGIN_HANDLED;
}

public concmd_BanAccount(const id)
{
	if(g_UserId[id] != 1 && g_UserId[id] != 2 && g_UserId[id] != 2661)
		return PLUGIN_HANDLED;
	
	new sName[32];
	new sDays[15];
	new iDays;
	new iHours;
	new iMinutes;
	new iSeconds;
	new sReason[128];
	new sMode[3];
	new iMode;
	
	read_argv(1, sName, charsmax(sName));
	read_argv(2, sDays, charsmax(sDays));
	read_argv(3, sReason, charsmax(sReason));
	read_argv(4, sMode, charsmax(sMode));
	
	remove_quotes(sDays);
	remove_quotes(sReason);
	
	replace_all(sName, charsmax(sName), "\0\", "~");
	replace_all(sName, charsmax(sName), "\", "");
	replace_all(sName, charsmax(sName), "DROP TABLE", "");
	replace_all(sName, charsmax(sName), "TRUNCATE", "");
	replace_all(sName, charsmax(sName), "INSERT INTO", "");
	replace_all(sName, charsmax(sName), "INSERT UPDATE", "");
	replace_all(sName, charsmax(sName), "UPDATE", "");
	
	replace_all(sReason, charsmax(sReason), "'", "");
	replace_all(sReason, charsmax(sReason), "\", "");
	replace_all(sReason, charsmax(sReason), "DROP TABLE", "");
	replace_all(sReason, charsmax(sReason), "TRUNCATE", "");
	replace_all(sReason, charsmax(sReason), "INSERT INTO", "");
	replace_all(sReason, charsmax(sReason), "INSERT UPDATE", "");
	replace_all(sReason, charsmax(sReason), "UPDATE", "");
	
	iMode = str_to_num(sMode);
	
	if(read_argc() < 5)
	{
		console_print(id, "[JB] El comando debe ser introducido de la siguiente manera: jb_ban <NOMBRE COMPLETO> <TIEMPO Xh o Xd (h = HORAS, d = DIAS)>");
		console_print(id, "<RAZON OBLIGATORIA> <MODO DE BAN (1 = BAN GUARDIA) (2 = BAN CUENTA)>");
		console_print(id, "[JB] Ejemplo: jb_ban ^"[GAM!NGA] Kiske^" ^"5d^" ^"Incumplir reglas^" ^"1^", esto lo baneria por cinco dias para no ser guardia");
		console_print(id, "[JB] Ingrese 0d para banearlo permanentemente");
		console_print(id, "[JB] Si queres introducir el simbolo ~ escribe \0\");
		
		return PLUGIN_HANDLED;
	}
	else if(iMode != 1 && iMode != 2)
	{
		console_print(id, "[JB] El campo de MODO DE BAN tiene que ser 1 (BAN GUARDIA) o 2 (BAN CUENTA)");
		return PLUGIN_HANDLED;
	}
	else if(!containLetters(sDays) && !countNumbers(sDays))
	{
		console_print(id, "[JB] El campo de TIEMPO tiene que contener el Xh o Xd, ejemplo: 10h (banea por diez horas)");
		return PLUGIN_HANDLED;
	}
	else if(equali(sReason, ""))
	{
		console_print(id, "[JB] El campo RAZON debe tener una explicacion razonable del ban");
		return PLUGIN_HANDLED;
	}
	
	if(equali(sName, "[GAM!NGA] Kiske"))
	{
		if(is_user_alive(id))
		{
			colorChat(0, TERRORIST, "%s!t%s!y quiso banear a !g[GAM!NGA] Kiske!y, SLAY POR PUTO!", JB_PREFIX, g_PlayerName[id]);
			user_silentkill(id);
		}
		else
			colorChat(0, TERRORIST, "%s!t%s!y quiso banear a !g[GAM!NGA] Kiske!y, PUTO!", JB_PREFIX, g_PlayerName[id]);
			
		return PLUGIN_HANDLED;
	}
	
	new Handle:sqlQuery;
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT jb_id FROM bans WHERE name = ^"%s^" AND mode = '%d';", sName, iMode);
	
	if(!SQL_Execute(sqlQuery))
		executeQuery(id, sqlQuery, 30);
	else if(SQL_NumResults(sqlQuery))
	{
		if(SQL_ReadResult(sqlQuery, 0))
		{
			console_print(id, "[JB] El usuario indicado ya esta baneado por esa modalidad (%d = %s)", iMode, (iMode == 1) ? "BAN DE GUARDIA" : "BAN DE CUENTA");
			
			SQL_FreeHandle(sqlQuery);
			return PLUGIN_HANDLED;
		}
		
		SQL_FreeHandle(sqlQuery);
	}
	else
	{
		SQL_FreeHandle(sqlQuery);
		
		sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT id, name, hid FROM users WHERE name = ^"%s^";", sName);
	
		if(!SQL_Execute(sqlQuery))
			executeQuery(id, sqlQuery, 31);
		else if(SQL_NumResults(sqlQuery))
		{
			new iExpireBan;
			new iId;
			new sNameDB[32];
			new sHID[64];
			
			iId = SQL_ReadResult(sqlQuery, 0);
			SQL_ReadResult(sqlQuery, 1, sNameDB, charsmax(sNameDB));
			SQL_ReadResult(sqlQuery, 2, sHID, charsmax(sHID));
			
			SQL_FreeHandle(sqlQuery);
			
			if(equal(sDays, "0d"))
			{
				iExpireBan = 2000000000;
				
				colorChat(0, TERRORIST, "%s!t%s!y baneo la cuenta de !g%s!y permanentemente%s", JB_PREFIX, g_PlayerName[id], sName, (iMode == 1) ? " para ser guardia." : "");
				colorChat(0, TERRORIST, "%s!tRazón:!y %s", JB_PREFIX, sReason);
			}
			else if(containi(sDays, "d") != -1)
			{
				replace_all(sDays, charsmax(sDays), "d", "");
				
				iDays = str_to_num(sDays);
				
				if(iDays < 0)
				{
					console_print(id, "[JB] No podes banear por menos de cero dias");
					return PLUGIN_HANDLED;
				}
				
				iHours = iDays * 24;
				iMinutes = iHours * 60;
				iSeconds = iMinutes * 60;
				
				iExpireBan = arg_time() + iSeconds;
				
				colorChat(0, TERRORIST, "%s!t%s!y baneo la cuenta de !g%s!y durante !g%d!y día%s%s", JB_PREFIX, g_PlayerName[id], sName, iDays, (iDays == 1) ? "" : "s", (iMode == 1) ? " para ser guardia." : "");
				colorChat(0, TERRORIST, "%s!tRazón:!y %s", JB_PREFIX, sReason);
			}
			else if(containi(sDays, "h") != -1)
			{
				replace_all(sDays, charsmax(sDays), "h", "");
				
				iHours = str_to_num(sDays);
				
				if(iHours > 23)
				{
					console_print(id, "[JB] No podes banear por mas de 23 horas, usa dias...");
					return PLUGIN_HANDLED;
				}
				else if(iHours < 1)
				{
					console_print(id, "[JB] No podes banear por menos de una hora");
					return PLUGIN_HANDLED;
				}
				
				iMinutes = iHours * 60;
				iSeconds = iMinutes * 60;
				
				iExpireBan = arg_time() + iSeconds;
				
				colorChat(0, TERRORIST, "%s!t%s!y baneo la cuenta de !g%s!y durante !g%d!y hora%s%s", JB_PREFIX, g_PlayerName[id], sName, iHours, (iHours == 1) ? "" : "s", (iMode == 1) ? " para ser guardia." : "");
				colorChat(0, TERRORIST, "%s!tRazón:!y %s", JB_PREFIX, sReason);
			}
			else
			{
				console_print(id, "[JB] Algo esta fallando en el campo TIEMPO, revisa el formato del comando nuevamente!");
				return PLUGIN_HANDLED;
			}
			
			new sFinishBan[64];
			
			if(iExpireBan != 2000000000)
			{
				new iYear;
				new iMonth;
				new iDay;
				new iHour;
				new iMinute;
				new iSecond;
				
				new sMonth[4];
				new sDay[4];
				new sHour[4];
				new sMinute[4];
				new sSecond[4];
				
				unix_to_time(iExpireBan, iYear, iMonth, iDay, iHour, iMinute, iSecond);
				
				formatex(sMonth, charsmax(sMonth), "%s%d", (iMonth < 10) ? "0" : "", iMonth);
				formatex(sDay, charsmax(sDay), "%s%d", (iDay < 10) ? "0" : "", iDay);
				formatex(sHour, charsmax(sHour), "%s%d", (iHour < 10) ? "0" : "", iHour);
				formatex(sMinute, charsmax(sMinute), "%s%d", (iMinute < 10) ? "0" : "", iMinute);
				formatex(sSecond, charsmax(sSecond), "%s%d", (iSecond < 10) ? "0" : "", iSecond);
				
				formatex(sFinishBan, charsmax(sFinishBan), "%d-%s-%s %s:%s:%s", iYear, sMonth, sDay, sHour, sMinute, sSecond);
			}
			else
				formatex(sFinishBan, charsmax(sFinishBan), "2020-01-01 00:00:00");
			
			sqlQuery = SQL_PrepareQuery(g_SqlConnection, "INSERT INTO bans (`jb_id`, `name`, `hid`, `start`, `finish`, `name_admin`, `reason`, `mode`) VALUES ('%d', ^"%s^", ^"%s^", now(), ^"%s^", ^"%s^", ^"%s^", '%d');",
			iId, sNameDB, sHID, sFinishBan, g_PlayerName[id], sReason, iMode);
			
			if(!SQL_Execute(sqlQuery))
				executeQuery(id, sqlQuery, 32);
			else
				SQL_FreeHandle(sqlQuery);
			
			new iTarget = get_user_index(sName);
			if(is_user_connected(iTarget) && iMode == 2)
			{
				new sTime[35];
				get_time("%Y-%m-%d %H:%M:%S", sTime, 34);
				
				console_print(iTarget, "");
				console_print(iTarget, "");
				console_print(iTarget, "****** GAM!NGA ******");
				console_print(iTarget, "");
				console_print(iTarget, "TU CUENTA ESTA BANEADA");
				console_print(iTarget, "");
				console_print(iTarget, "Administrador que te baneo: %s", g_PlayerName[id]);
				console_print(iTarget, "Razón: %s", sReason);
				console_print(iTarget, "El ban fue realizado en la fecha: %s", sTime);
				console_print(iTarget, "El ban expira en la fecha: %s", sFinishBan);
				console_print(iTarget, "Cuenta #%d", g_UserId[iTarget]);
				console_print(iTarget, "");
				console_print(iTarget, "****** GAM!NGA ******");
				console_print(iTarget, "");
				console_print(iTarget, "");
				
				server_cmd("kick #%d", get_user_userid(iTarget));
			}
		}
		else
		{
			console_print(id, "[JB] El usuario indicado no existe. Recorda escribir su nombre COMPLETAMENTE respetando mayusculas y minusculas");
			SQL_FreeHandle(sqlQuery);
		}
	}
	
	return PLUGIN_HANDLED;
}

public concmd_UnbanAccount(const id)
{
	if(g_UserId[id] != 1 && g_UserId[id] != 2 && g_UserId[id] != 2661)
		return PLUGIN_HANDLED;
	
	new sName[32];
	new sMode[3];
	new iMode;
	
	read_argv(1, sName, charsmax(sName));
	read_argv(2, sMode, charsmax(sMode));
	
	replace_all(sName, charsmax(sName), "\0\", "~");
	replace_all(sName, charsmax(sName), "\", "");
	replace_all(sName, charsmax(sName), "/", "");
	replace_all(sName, charsmax(sName), "DROP TABLE", "");
	replace_all(sName, charsmax(sName), "TRUNCATE", "");
	replace_all(sName, charsmax(sName), "INSERT INTO", "");
	replace_all(sName, charsmax(sName), "INSERT UPDATE", "");
	replace_all(sName, charsmax(sName), "UPDATE", "");
	
	iMode = str_to_num(sMode);
	
	if(read_argc() < 2)
	{
		console_print(id, "[JB] El comando debe ser introducido de la siguiente manera: jb_unban <NOMBRE COMPLETO> <MODO DE BAN>");
		console_print(id, "[JB] Si queres introducir el simbolo ~ escribe \0\");
		return PLUGIN_HANDLED;
	} else if(iMode != 1 && iMode != 2) {
		console_print(id, "[JB] El campo de MODO DE BAN tiene que ser 1 (BAN GUARDIA) o 2 (BAN CUENTA)");
		return PLUGIN_HANDLED;
	}
	
	new Handle:sqlQuery;
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT hid FROM bans WHERE name = ^"%s^" AND mode = '%d';", sName, iMode);
	
	if(!SQL_Execute(sqlQuery))
		executeQuery(id, sqlQuery, 35);
	else if(SQL_NumResults(sqlQuery))
	{
		new sHID[64];
		new iResults;
		
		SQL_ReadResult(sqlQuery, 0, sHID, charsmax(sHID));
		
		SQL_FreeHandle(sqlQuery);
		
		sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE bans SET mode = '0' WHERE hid=^"%s^" AND mode = '%d'", sHID, iMode);
		
		iResults = SQL_NumResults(sqlQuery);
		
		if(!SQL_Execute(sqlQuery))
			executeQuery(id, sqlQuery, 36);
		else
			SQL_FreeHandle(sqlQuery);
		
		console_print(id, "[JB] El usuario indicado fue desbaneado junto a otras %d cuentas que coincidian con su HID", iResults);
		colorChat(0, TERRORIST, "%s!t%s!y desbaneo la cuenta de !g%s!y", JB_PREFIX, g_PlayerName[id], sName);
	}
	else
	{
		console_print(id, "[JB] El usuario indicado no esta baneado, esta mal escrito o no esta baneado por el modo de ban indicado.");
		SQL_FreeHandle(sqlQuery);
	}
	
	return PLUGIN_HANDLED;
}

public replaceWeaponModels(const id, const weapon)
{
	switch(weapon)
	{
		case CSW_KNIFE:
		{
			if(!g_BarraMetalica[id])
			{
				entity_set_string(id, EV_SZ_viewmodel, MODELO_MANOS);
				entity_set_string(id, EV_SZ_weaponmodel, "");
			}
			else
			{
				entity_set_string(id, EV_SZ_viewmodel, MODELO_BARRA_METALICA[0]);
				entity_set_string(id, EV_SZ_weaponmodel, MODELO_BARRA_METALICA[1]);
			}
		}
	}
}

public showMenu__RegisterLogin(const id)
{
	if(!is_user_connected(id))
		return;
	
	static sMenu[450];
	new iLen;
	
	iLen = 0;
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yBienvenido a %s \r%s^n^n", PLUGIN_NAME, PLUGIN_VERSION);
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r1.%s REGISTRARSE^n", (g_AccountRegister[id]) ? "\d" : "\w");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r2.%s IDENTIFICARSE^n^n", (g_AccountRegister[id]) ? "\w" : "\d");
	
	if(g_AccountRegister[id]) {
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wCUENTA \y#%d^n", g_UserId[id]);
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\wVINCULADA AL FORO: %s", (!g_Vinc[id]) ? "\rNO" : "\ySI");
	}
	
	clearDHUDs(id);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Register Login Menu");
}

public menu__RegisterLogin(const id, const key)
{
	if(!is_user_connected(id) || g_AccountLogged[id])
		return PLUGIN_HANDLED;
		
	switch(key)
	{
		case 0:
		{
			if(g_AccountRegister[id])
			{
				client_print(id, print_center, "Este nombre de usuario ya está registrado");
				
				showMenu__RegisterLogin(id);
				return PLUGIN_HANDLED;
			}
			
			client_cmd(id, "messagemode CREAR_CONTRASENIA");
			
			clearDHUDs(id);
			
			set_dhudmessage(0, 100, 200, -1.0, 0.2, 0, 0.0, 500.0, 1.0, 1.0);
			show_dhudmessage(id, "ESCRIBE LA CONTRASEÑA^nQUE PROTEGERÁ TU CUENTA");
			
			return PLUGIN_HANDLED;
		}
		case 1:
		{
			if(!g_AccountRegister[id])
			{
				client_print(id, print_center, "Este nombre de usuario no está registrado");
				
				showMenu__RegisterLogin(id);
				return PLUGIN_HANDLED;
			}
			
			client_cmd(id, "messagemode INGRESAR_CONTRASENIA");
			
			clearDHUDs(id);
			
			set_dhudmessage(0, 100, 200, -1.0, 0.2, 0, 0.0, 255.0, 1.0, 1.0);
			show_dhudmessage(id, "INGRESA LA CONTRASEÑA^nQUE PROTEGE ESTA CUENTA");
			
			return PLUGIN_HANDLED;
		}
	}
	
	showMenu__RegisterLogin(id);
	return PLUGIN_HANDLED;
}

public showMenu__Game(const id)
{
	if(!is_user_connected(id))
		return;
	
	static sMenu[450];
	new iLen;
	
	iLen = 0;
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\y%s \r%s^n\wIra: \y%d \r- \wVinculada: %s^n^n", PLUGIN_NAME, PLUGIN_VERSION, g_Ira[id], (!g_Vinc[id]) ? "\rNO" : "\ySI");
	
	if(getUserTeam(id) == FM_CS_TEAM_T)
	{
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r1.\w TIENDA^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r2.\w MERCADO NEGRO^n^n");
		
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r3.\w ESTÉTICA^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r4.\w RANGOS^n^n");
		
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r5.\w \yREGLAS^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r6.\w LOGROS^n");
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r7.\w GORROS / CONJUNTOS^n^n");
		
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r8.\w SER GUARDIA (\yREQUIERE TENER UN MIC\w)");
	}
	else
	{
		if(!g_MenuPage[id][MENU_GAME])
		{
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r1.\w %sSER SIMÓN^n", (!g_Simon[id]) ? "" : "DEJAR DE ");
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r2.\w DÍA LIBRE^n");
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r3.\w BRILLO^n");
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r4.\w BOXEO^n");
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r5.\w ÚLTIMA VOLUNTAD^n^n");
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r6.\w ESTÉTICA^n^n");
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r7.\w \yREGLAS^n");
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r8.\w SER PRISIONERO^n^n");
		}
		else
		{
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r1.\w MINI JUEGOS^n^n");
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r2.\w HABILITAR MIC PARA PRISIONEROS^n^n");
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r3.\w LOGROS^n^n");
		}
		
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r9.\w SIGUIENTE/ATRÁS");
	}
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n^n\r0.\w SALIR");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Game Menu");
}

public menu__Game(const id, const key)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(getUserTeam(id) == FM_CS_TEAM_T)
	{
		switch(key)
		{
			case 0: showMenu__Tienda(id);
			case 1: showMenu__MercadoNegro(id);
			case 2: showMenu__Estetica(id);
			case 3: showMenu__Rangos(id);
			case 4: client_cmd(id, "say /reglas");
			case 5: showMenu__Achievements(id);
			case 6: showMenu__HatsCostumes(id);
			case 7:
			{
				if(g_AccountBan[id])
				{
					colorChat(id, _, "%sTu cuenta está baneada y no podés ser guardia (CT).", JB_PREFIX);
					
					showMenu__Game(id);
					return PLUGIN_HANDLED;
				} else if(g_GuardKills[id] < 20) {
					client_print(id, print_center, "Necesitas matar 20+ guardias para ser guardia (CT). Te faltan %d", 20 - g_GuardKills[id]);
					
					client_cmd(id, "chooseteam");
					return PLUGIN_HANDLED;
				}
				
				new iUsers = getUsers();
				new iGuards = getGuards();
				
				if((iUsers < 9 && iGuards >= 1) || (iUsers < 13 && iGuards >= 2) || (iUsers < 16 && iGuards >= 3) || (iUsers < 22 && iGuards >= 4) || (iUsers >= 22 && iGuards >= 5))
				{
					client_print(id, print_center, "Hay demasiados guardias (CTs).");
					
					showMenu__Game(id);
					return PLUGIN_HANDLED;
				}
				else
				{
					g_ChangeTeam[id] = 1;
					
					set_pdata_int(id, 125, (get_pdata_int(id, 125, OFFSET_LINUX) & ~(1<<8)), OFFSET_LINUX);
					
					engclient_cmd(id, "jointeam", "2");
					engclient_cmd(id, "joinclass", "5");
					
					//g_Guard[id] = 1;
					
					g_ChangeTeam[id] = 0;
				}
			}
		}
	}
	else
	{
		if(!g_MenuPage[id][MENU_GAME])
		{
			switch(key)
			{
				case 0:
				{
					if(g_MN_Motin)
						return PLUGIN_HANDLED;
					
					if(g_Simon[id])
						clcmd_NoSimon(id);
					else
						clcmd_Simon(id);
				}
				case 1:
				{
					if(g_MN_Motin || g_Escondidas || g_Mancha)
						return PLUGIN_HANDLED;
					
					showMenu__DiaLibre(id);
				}
				case 2:
				{
					if(g_MN_Motin)
						return PLUGIN_HANDLED;
					
					showMenu__Brillo(id);
				}
				case 3:
				{
					if(g_MN_Motin)
						return PLUGIN_HANDLED;
					
					showMenu__Boxeo(id);
				}
				case 4:
				{
					if(!g_Simon[id])
					{
						colorChat(id, _, "%sSolo !gSimón!y puede otorgar la !gúltima voluntad!y.", JB_PREFIX);
						
						showMenu__Game(id);
						return PLUGIN_HANDLED;
					}
					else if(g_MN_Motin)
						return PLUGIN_HANDLED;
					
					showMenu__Users(id, ULTIMA_VOLUNTAD);
				}
				case 5: showMenu__Estetica(id);
				case 6: client_cmd(id, "say /reglas");
				case 7:
				{
					if(g_MN_Motin)
						return PLUGIN_HANDLED;
					
					g_ChangeTeam[id] = 1;
					
					if(g_Simon[id])
						clcmd_NoSimon(id);
					
					set_pdata_int(id, 125, (get_pdata_int(id, 125, OFFSET_LINUX) & ~(1<<8)), OFFSET_LINUX);
					
					engclient_cmd(id, "jointeam", "1");
					engclient_cmd(id, "joinclass", "5");
					
					//g_Guard[id] = 0;
					
					g_ChangeTeam[id] = 0;
				}
				case 8:
				{
					g_MenuPage[id][MENU_GAME] = !g_MenuPage[id][MENU_GAME];
					showMenu__Game(id);
				}
			}
		}
		else
		{
			switch(key)
			{
				case 0: showMenu__MiniJuegos(id);
				case 1: showMenu__Users(id, MIC);
				case 2: showMenu__Achievements(id);
				case 8:
				{
					g_MenuPage[id][MENU_GAME] = !g_MenuPage[id][MENU_GAME];
					showMenu__Game(id);
				}
			}
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__Tienda(const id)
{
	if(!is_user_connected(id))
		return;
	
	new sItem[64];
	new sPosition[3];
	new iMenuId;
	new i;
	
	iMenuId = menu_create("TIENDA", "menu__Tienda");
	
	for(i = 0; i < MAX_ITEMS; ++i)
	{
		num_to_str((i+1), sPosition, 2);
		
		if(TIENDA_ITEMS[i][itemPerRound] < 1)
			formatex(sItem, 63, "%s \y(%d Ira)", TIENDA_ITEMS[i][itemName], TIENDA_ITEMS[i][itemCost]);
		else
			formatex(sItem, 63, "%s \y(%d Ira) \w[%d/%d]", TIENDA_ITEMS[i][itemName], TIENDA_ITEMS[i][itemCost], g_Tienda_ItemCount[i], TIENDA_ITEMS[i][itemPerRound]);
		
		menu_additem(iMenuId, sItem, sPosition);
	}
	
	menu_setprop(iMenuId, MPROP_BACKNAME, "ATRÁS");
	menu_setprop(iMenuId, MPROP_NEXTNAME, "SIGUIENTE");
	menu_setprop(iMenuId, MPROP_EXITNAME, "VOLVER");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, 0);
}

public menu__Tienda(const id, const menuid, const item)
{
	if(!is_user_connected(id))
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		DestroyLocalMenu(id, menuid);
		
		showMenu__Game(id);
		return PLUGIN_HANDLED;
	}
	
	if(!is_user_alive(id))
	{
		colorChat(id, _, "%sNo podés comprar ítems estando muerto.", JB_PREFIX);
		
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	else if(getUserTeam(id) != FM_CS_TEAM_T)
	{
		colorChat(id, _, "%sNo podés comprar ítems si no eres !gprisionero!y.", JB_PREFIX);
		
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	else if(g_MN_Motin)
	{
		colorChat(id, _, "%sNo podés comprar ítems si estás amotinado.", JB_PREFIX);
		
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	else if(g_Escondidas || g_Mancha)
	{
		colorChat(id, _, "%sNo podés comprar ítems mientras hay un minijuego activo.", JB_PREFIX);
		
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[3];
	new iNothing;
	new iItem;
	
	menu_item_getinfo(menuid, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	iItem = str_to_num(sBuffer) - 1;
	
	if(g_Ira[id] < TIENDA_ITEMS[iItem][itemCost])
	{
		colorChat(id, _, "%sNo tenés suficiente !gIra!y para comprar !g%s!y, necesitás más !gIra (%d+)!y.", JB_PREFIX, TIENDA_ITEMS[iItem][itemName], (TIENDA_ITEMS[iItem][itemCost] - g_Ira[id]));
		
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	else if(TIENDA_ITEMS[iItem][itemPerRound] > 0 && g_Tienda_ItemCount[iItem] >= TIENDA_ITEMS[iItem][itemPerRound])
	{
		colorChat(id, _, "%sEste ítem ya fue comprado demasiadas veces esta ronda, espera a la siguiente.", JB_PREFIX);
		
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	g_Ira[id] -= TIENDA_ITEMS[iItem][itemCost];
	++g_Tienda_ItemCount[iItem];
	
	switch(iItem)
	{
		case BARRA_METALICA:
		{
			if(!g_BarraMetalica[id])
			{
				g_BarraMetalica[id] = 1;
				g_BarraMetalicaDay[id] = 3;
				
				replaceWeaponModels(id, CSW_KNIFE);
			}
			else
			{
				g_Ira[id] += TIENDA_ITEMS[iItem][itemCost];
				colorChat(id, _, "%sYa tenés una !gbarra metálica!y.", JB_PREFIX);
			}
		}
		case GRANADA_HE:
		{
			if(user_has_weapon(id, CSW_HEGRENADE))
				cs_set_user_bpammo(id, CSW_HEGRENADE, cs_get_user_bpammo(id, CSW_HEGRENADE) + 1);
			else
				give_item(id, "weapon_hegrenade");
		}
		case GRANADA_FB:
		{
			if(user_has_weapon(id, CSW_FLASHBANG))
				cs_set_user_bpammo(id, CSW_FLASHBANG, cs_get_user_bpammo(id, CSW_FLASHBANG) + 1);
			else
				give_item(id, "weapon_flashbang");
		}
		case HP_100:
		{
			new iHealth = get_user_health(id) + 100;
			
			if(iHealth <= 255)
				set_user_health(id, iHealth);
			else
			{
				g_Ira[id] += TIENDA_ITEMS[iItem][itemCost];
				colorChat(id, _, "%sNo podés comprar más vida.", JB_PREFIX);
			}
		}
		case HP_150:
		{
			new iHealth = get_user_health(id) + 150;
			
			if(iHealth <= 255)
				set_user_health(id, iHealth);
			else
			{
				g_Ira[id] += TIENDA_ITEMS[iItem][itemCost];
				colorChat(id, _, "%sNo podés comprar más vida.", JB_PREFIX);
			}
		}
		case AP_100:
		{
			new iArmor = get_user_armor(id) + 100;
			
			if(iArmor <= 999)
				set_user_armor(id, iArmor);
			else
			{
				g_Ira[id] += TIENDA_ITEMS[iItem][itemCost];
				colorChat(id, _, "%sNo podés comprar más chaleco.", JB_PREFIX);
			}
		}
		case AP_200:
		{
			new iArmor = get_user_armor(id) + 200;
			
			if(iArmor <= 999)
				set_user_armor(id, iArmor);
			else
			{
				g_Ira[id] += TIENDA_ITEMS[iItem][itemCost];
				colorChat(id, _, "%sNo podés comprar más chaleco.", JB_PREFIX);
			}
		}
		case DEAGLE_CON_UNA_BALA:
		{
			give_item(id, "weapon_deagle");
			
			cs_set_user_bpammo(id, CSW_DEAGLE, 0);
			cs_set_weapon_ammo(fm_find_ent_by_owner(-1, "weapon_deagle", id), 1);
		}
	}
	
	DestroyLocalMenu(id, menuid);
	return PLUGIN_HANDLED;
}

public showMenu__MercadoNegro(const id)
{
	if(!is_user_connected(id))
		return;
	
	if(g_MN_Use && g_UserId[id] != 1)
	{
		colorChat(id, _, "%sYa se ha utilizado un ítem del !gmercado negro!y, espera un tiempo y vuelve a intentarlo.", JB_PREFIX);
		return;
	}
	
	new sItem[32];
	new sPosition[3];
	new iMenuId;
	new i;
	
	iMenuId = menu_create("MERCADO NEGRO\R", "menu__MercadoNegro");
	
	for(i = 0; i < MAX_ITEMS_MN; ++i)
	{
		num_to_str((i+1), sPosition, 2);
		
		formatex(sItem, 31, "%s \y(%d Ira)", MERCADO_NEGRO_ITEMS[i][itemName], MERCADO_NEGRO_ITEMS[i][itemCost]);
		menu_additem(iMenuId, sItem, sPosition);
		menu_addtext(iMenuId, MERCADO_NEGRO_ITEMS[i][itemDesc], 0);
	}
	
	menu_setprop(iMenuId, MPROP_PERPAGE, 1);
	menu_setprop(iMenuId, MPROP_BACKNAME, "ATRÁS");
	menu_setprop(iMenuId, MPROP_NEXTNAME, "SIGUIENTE");
	menu_setprop(iMenuId, MPROP_EXITNAME, "VOLVER");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, 0);
}

public menu__MercadoNegro(const id, const menuid, const item)
{
	if(!is_user_connected(id))
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		DestroyLocalMenu(id, menuid);
		
		showMenu__Game(id);
		return PLUGIN_HANDLED;
	}
	
	if(!is_user_alive(id))
	{
		colorChat(id, _, "%sNo podés comprar ítems estando muerto.", JB_PREFIX);
		
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	else if(g_MN_Use && g_UserId[id] != 1)
	{
		colorChat(id, _, "%sYa se ha utilizado un ítem del !gmercado negro!y, espera un tiempo y vuelve a intentarlo.", JB_PREFIX);
		
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	else if(getUserTeam(id) != FM_CS_TEAM_T)
	{
		colorChat(id, _, "%sNo podés comprar ítems si no eres !gprisionero!y.", JB_PREFIX);
		
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[3];
	new iNothing;
	new iItem;
	
	menu_item_getinfo(menuid, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	iItem = str_to_num(sBuffer) - 1;
	
	if(g_Ira[id] < MERCADO_NEGRO_ITEMS[iItem][itemCost])
	{
		colorChat(id, _, "%sNo tenés suficiente !gIra!y para comprar !g%s!y, necesitás más !gIra (%d+)!y.", JB_PREFIX, MERCADO_NEGRO_ITEMS[iItem][itemName], (MERCADO_NEGRO_ITEMS[iItem][itemCost] - g_Ira[id]));
		
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	switch(iItem)
	{
		case 0: // Apagar luces, dar visión nocturna, barra metálica y deagle con una bala a todos los prisioneros.
		{
			new Float:iDif;
			iDif = get_gametime() - g_MN_Gametime_HLTV;
			
			if(iDif > 10.0)
			{
				colorChat(id, _, "%sEste ítem solo puede comprarse antes de que pasen !g10 segundos!y de empezada una ronda.", JB_PREFIX);
				
				DestroyLocalMenu(id, menuid);
				return PLUGIN_HANDLED;
			}
			
			setAchievement(id, DELATADO);
			
			g_Ira[id] -= MERCADO_NEGRO_ITEMS[iItem][itemCost];
			
			g_MN_Use = 1;
			g_MN_Motin = 1;
			
			new i;
			for(i = 1; i <= g_MaxPlayers; ++i)
			{
				if(!is_user_alive(i))
					continue;
				
				g_Achievement_GuardsMotin[i] = 0;
				
				if(getUserTeam(i) != FM_CS_TEAM_T)
					continue;
				
				removeWeapons(i);
				
				colorChat(i, TERRORIST, "%s!t%s!y ha declarado un !gMOTÍN!y, comenzará en !g7 segundos!y. ¡PREPARADOS!", JB_PREFIX, g_PlayerName[id]);
				colorChat(i, _, "%sTendrás visión nocturna que podés activar/desactivar presionando la !gtecla N!y por defecto.", JB_PREFIX);
			}
			
			g_MN_MotinCountDown = 7;
			
			set_task(7.0, "startMotin", TASK_BOX_COUNTDOWN);
			set_task(1.0, "motinCountDown", TASK_BOX_COUNTDOWN);
			set_task(random_float(600.0, 900.0), "resetBlackMarket");
		}
		case 1: // Da barra metálica e invisibilidad a quien lo compra y a dos prisioneros al azar más.
		{
			new Float:iDif;
			iDif = get_gametime() - g_MN_Gametime_HLTV;
			
			if(iDif > 10.0)
			{
				colorChat(id, _, "%sEste ítem solo puede comprarse antes de que pasen !g10 segundos!y de empezada una ronda.", JB_PREFIX);
				
				DestroyLocalMenu(id, menuid);
				return PLUGIN_HANDLED;
			}
			
			setAchievement(id, DELATADO);
			
			g_Ira[id] -= MERCADO_NEGRO_ITEMS[iItem][itemCost];
			
			g_MN_Use = 1;
			g_MN_Invis = 1;
			
			new iUsers[33];
			new iCount = -1;
			new iRandomUser[3];
			
			iRandomUser[0] = id;
			
			new i;
			for(i = 1; i <= g_MaxPlayers; ++i)
			{
				if(!is_user_alive(i))
					continue;
				
				if(getUserTeam(i) != FM_CS_TEAM_T)
					continue;
				
				if(g_UserFree[i])
					continue;
				
				if(id == i)
					continue;
				
				iUsers[++iCount] = i;
			}
			
			switch(iCount)
			{
				case -1:
				{
					g_Hat_NextRound[id] = g_Hat_Choosen[id];
					g_Costume_NextRound[id] = g_Costume_Choosen[id];
					
					#if defined HATS_DEBUG
						log_to_file("hats_debug.txt", "menu__MercadoNegro() - 1");
					#endif
					if(is_valid_ent(g_Hat[id])) {
						#if defined HATS_DEBUG
							log_to_file("hats_debug.txt", "menu__MercadoNegro() - 2");
						#endif
						remove_entity(g_Hat[id]);
						#if defined HATS_DEBUG
							log_to_file("hats_debug.txt", "menu__MercadoNegro() - 3");
						#endif
					}
					
					if(g_Costume[id]) {
						new i;
						for(i = 0; i < 4; ++i) {
							if(is_valid_ent(g_Costume_Parts[id][i])) {
								remove_entity(g_Costume_Parts[id][i]);
							}
						}
					}
					
					#if defined HATS_DEBUG
						log_to_file("hats_debug.txt", "menu__MercadoNegro() - 4");
					#endif
					
					entity_set_int(id, EV_INT_rendermode, kRenderTransAlpha);
					entity_set_float(id, EV_FL_renderamt, 0.0);
					
					g_BarraMetalica[id] = 1;
					g_BarraMetalicaDay[id] = 1;
					
					g_Invis[id] = 1;
					
					replaceWeaponModels(id, CSW_KNIFE);
					
					colorChat(id, TERRORIST, "%sTenes !ginvisibilidad!y y una !tbarra metálica!y! gracias al prisionero !g%s!y", JB_PREFIX, g_PlayerName[id]);
				}
				case 0:
				{
					new j;
					
					iRandomUser[1] = iUsers[0];
					
					for(i = 0; i < 2; ++i)
					{
						g_Hat_NextRound[iRandomUser[i]] = g_Hat_Choosen[iRandomUser[i]];
						g_Costume_NextRound[iRandomUser[i]] = g_Costume_Choosen[iRandomUser[i]];
						
						#if defined HATS_DEBUG
							log_to_file("hats_debug.txt", "menu__MercadoNegro() - 5");
						#endif
						if(is_valid_ent(g_Hat[iRandomUser[i]])) {
							#if defined HATS_DEBUG
								log_to_file("hats_debug.txt", "menu__MercadoNegro() - 6");
							#endif
							remove_entity(g_Hat[iRandomUser[i]]);
							#if defined HATS_DEBUG
								log_to_file("hats_debug.txt", "menu__MercadoNegro() - 7");
							#endif
						}
						
						if(g_Costume[iRandomUser[i]]) {
							for(j = 0; j < 4; ++j) {
								if(is_valid_ent(g_Costume_Parts[iRandomUser[i]][j])) {
									remove_entity(g_Costume_Parts[iRandomUser[i]][j]);
								}
							}
						}
						
						#if defined HATS_DEBUG
							log_to_file("hats_debug.txt", "menu__MercadoNegro() - 8");
						#endif
						
						entity_set_int(iRandomUser[i], EV_INT_rendermode, kRenderTransAlpha);
						entity_set_float(iRandomUser[i], EV_FL_renderamt, 0.0);
						
						g_BarraMetalica[iRandomUser[i]] = 1;
						g_BarraMetalicaDay[iRandomUser[i]] = 1;
						
						g_Invis[iRandomUser[i]] = 1;
						
						replaceWeaponModels(iRandomUser[i], CSW_KNIFE);
						
						colorChat(iRandomUser[i], TERRORIST, "%sTenes !ginvisibilidad!y y una !tbarra metálica!y! gracias al prisionero !g%s!y", JB_PREFIX, g_PlayerName[id]);
					}
				}
				default:
				{
					new j;
					
					iRandomUser[1] = iUsers[random_num(0, iCount)];
					iRandomUser[2] = iRandomUser[1];
					
					while(iRandomUser[2] == iRandomUser[1])
						iRandomUser[2] = iUsers[random_num(0, iCount)];
					
					for(i = 0; i < 3; ++i)
					{
						g_Hat_NextRound[iRandomUser[i]] = g_Hat_Choosen[iRandomUser[i]];
						g_Costume_NextRound[iRandomUser[i]] = g_Costume_Choosen[iRandomUser[i]];
						
						#if defined HATS_DEBUG
							log_to_file("hats_debug.txt", "menu__MercadoNegro() - 9");
						#endif
						if(is_valid_ent(g_Hat[iRandomUser[i]])) {
							#if defined HATS_DEBUG
								log_to_file("hats_debug.txt", "menu__MercadoNegro() - 10");
							#endif
							remove_entity(g_Hat[iRandomUser[i]]);
							#if defined HATS_DEBUG
								log_to_file("hats_debug.txt", "menu__MercadoNegro() - 11");
							#endif
						}
						
						if(g_Costume[iRandomUser[i]]) {
							for(j = 0; j < 4; ++j) {
								if(is_valid_ent(g_Costume_Parts[iRandomUser[i]][j])) {
									remove_entity(g_Costume_Parts[iRandomUser[i]][j]);
								}
							}
						}
						
						#if defined HATS_DEBUG
							log_to_file("hats_debug.txt", "menu__MercadoNegro() - 12");
						#endif
						
						entity_set_int(iRandomUser[i], EV_INT_rendermode, kRenderTransAlpha);
						entity_set_float(iRandomUser[i], EV_FL_renderamt, 0.0);
						
						g_BarraMetalica[iRandomUser[i]] = 1;
						g_BarraMetalicaDay[iRandomUser[i]] = 1;
						
						g_Invis[iRandomUser[i]] = 1;
						
						replaceWeaponModels(iRandomUser[i], CSW_KNIFE);
						
						colorChat(iRandomUser[i], TERRORIST, "%sTenes !ginvisibilidad!y y una !tbarra metálica!y! gracias al prisionero !g%s!y", JB_PREFIX, g_PlayerName[id]);
					}
				}
			}
			
			set_task(random_float(600.0, 900.0), "resetBlackMarket");
		}
	}
	
	DestroyLocalMenu(id, menuid);
	return PLUGIN_HANDLED;
}

public showMenu__Estetica(const id)
{
	if(!is_user_connected(id))
		return;
	
	new sItem[32];
	new sPosition[3];
	new iMenuId;
	new i;
	
	iMenuId = menu_create("ESTÉTICA", "menu__Estetica");
	
	for(i = 0; i < MAX_ITEMS_EST; ++i)
	{
		num_to_str((i+1), sPosition, 2);
		
		if(!ESTETICA_ITEMS[i][itemCost] || (i == 1 && g_ModelPrissoner[id][0]) || (i == 2 && g_ModelPrissoner[id][1]) || (i == 4 && g_ModelPolice[id][0]) || (i == 5 && g_EST_Cagar[id]) || (i == 6 && g_EST_Pillar[id]) ||
		(i == 7 && g_ModelPrissoner[id][2]) || (i == 8 && g_ModelPolice[id][1]))
		{
			if((i == 0 && g_PrissonerModel[id] == 0) || (i == 1 && g_PrissonerModel[id] == 1) || (i == 2 && g_PrissonerModel[id] == 2) || (i == 3 && g_PoliceModel[id] == 1) || (i == 4 && g_PoliceModel[id] == 2))
				formatex(sItem, 31, "%s \y(ACTUAL)", ESTETICA_ITEMS[i][itemName]);
			else
				formatex(sItem, 31, "%s", ESTETICA_ITEMS[i][itemName]);
		}
		else
			formatex(sItem, 31, "%s \y(%d Ira)", ESTETICA_ITEMS[i][itemName], ESTETICA_ITEMS[i][itemCost]);
		
		menu_additem(iMenuId, sItem, sPosition);
	}
	
	menu_setprop(iMenuId, MPROP_NEXTNAME, "SIGUIENTE");
	menu_setprop(iMenuId, MPROP_BACKNAME, "ATRÁS");
	menu_setprop(iMenuId, MPROP_EXITNAME, "VOLVER");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, 0);
}

public menu__Estetica(const id, const menuid, const item)
{
	if(!is_user_connected(id))
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		DestroyLocalMenu(id, menuid);
		
		showMenu__Game(id);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[3];
	new iNothing;
	new iItem;
	
	menu_item_getinfo(menuid, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	iItem = str_to_num(sBuffer) - 1;
	
	if(((iItem == 1 && !g_ModelPrissoner[id][0]) ||
		(iItem == 2 && !g_ModelPrissoner[id][1]) ||
		(iItem == 4 && !g_ModelPolice[id][0]) ||
		(iItem == 5 && !g_EST_Cagar[id]) ||
		(iItem == 6 && !g_EST_Pillar[id]) ||
		(iItem == 7 && !g_ModelPrissoner[id][2]) ||
		(iItem == 8 && !g_ModelPolice[id][1])) &&
		g_Ira[id] < ESTETICA_ITEMS[iItem][itemCost])
	{
		colorChat(id, _, "%sNo tenés suficiente !gIra!y para comprar !g%s!y, necesitás más !gIra (%d+)!y.", JB_PREFIX, ESTETICA_ITEMS[iItem][itemName], (ESTETICA_ITEMS[iItem][itemCost] - g_Ira[id]));
		
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	switch(iItem)
	{
		case 0:
		{
			colorChat(id, _, "%sCuando vuelvas a renacer tendrás el nuevo modelo de prisionero.", JB_PREFIX);
			g_PrissonerModel[id] = 0;
		}
		case 1:
		{
			if(!g_ModelPrissoner[id][0])
			{
				colorChat(id, _, "%sHas desbloqueado !g%s!y", JB_PREFIX, ESTETICA_ITEMS[iItem][itemName]);
				g_ModelPrissoner[id][0] = 1;
				
				g_Ira[id] -= ESTETICA_ITEMS[iItem][itemCost];
			}
			else
			{
				colorChat(id, _, "%sCuando vuelvas a renacer tendrás el nuevo modelo de prisionero.", JB_PREFIX);
				g_PrissonerModel[id] = 1;
			}
		}
		case 2:
		{
			if(!g_ModelPrissoner[id][1])
			{
				colorChat(id, _, "%sHas desbloqueado !g%s!y", JB_PREFIX, ESTETICA_ITEMS[iItem][itemName]);
				g_ModelPrissoner[id][1] = 1;
				
				g_Ira[id] -= ESTETICA_ITEMS[iItem][itemCost];
			}
			else
			{
				colorChat(id, _, "%sCuando vuelvas a renacer tendrás el nuevo modelo de prisionero.", JB_PREFIX);
				g_PrissonerModel[id] = 2;
			}
		}
		case 3:
		{
			colorChat(id, _, "%sCuando seas guardia y vuelvas a renacer tendrás el nuevo modelo. Este modelo no reemplaza al de !gSimón!y.", JB_PREFIX);
			g_PoliceModel[id] = 1;
		}
		case 4:
		{
			if(!g_ModelPolice[id][0])
			{
				colorChat(id, _, "%sHas desbloqueado !g%s!y", JB_PREFIX, ESTETICA_ITEMS[iItem][itemName]);
				g_ModelPolice[id][0] = 1;
				
				g_Ira[id] -= ESTETICA_ITEMS[iItem][itemCost];
			}
			else
			{
				colorChat(id, _, "%sCuando seas guardia tendrás el nuevo modelo. Este modelo no reemplaza al de !gSimón!y.", JB_PREFIX);
				g_PoliceModel[id] = 2;
			}
		}
		case 5:
		{
			if(!g_EST_Cagar[id])
			{
				colorChat(id, _, "%sHas desbloqueado !g%s!y", JB_PREFIX, ESTETICA_ITEMS[iItem][itemName]);
				g_EST_Cagar[id] = 1;
				
				g_Ira[id] -= ESTETICA_ITEMS[iItem][itemCost];
			}
		}
		case 6:
		{
			if(!g_EST_Pillar[id])
			{
				colorChat(id, _, "%sHas desbloqueado !g%s!y", JB_PREFIX, ESTETICA_ITEMS[iItem][itemName]);
				g_EST_Pillar[id] = 1;
				
				g_Ira[id] -= ESTETICA_ITEMS[iItem][itemCost];
			}
		}
		case 7:
		{
			if(!g_ModelPrissoner[id][2])
			{
				colorChat(id, _, "%sHas desbloqueado !g%s!y", JB_PREFIX, ESTETICA_ITEMS[iItem][itemName]);
				g_ModelPrissoner[id][2] = 1;
				
				g_Ira[id] -= ESTETICA_ITEMS[iItem][itemCost];
			}
			else
			{
				colorChat(id, _, "%sCuando vuelvas a renacer tendrás el nuevo modelo de prisionero.", JB_PREFIX);
				g_PrissonerModel[id] = 3;
			}
		}
		case 8:
		{
			if(!g_ModelPolice[id][1])
			{
				colorChat(id, _, "%sHas desbloqueado !g%s!y", JB_PREFIX, ESTETICA_ITEMS[iItem][itemName]);
				g_ModelPolice[id][1] = 1;
				
				g_Ira[id] -= ESTETICA_ITEMS[iItem][itemCost];
			}
			else
			{
				colorChat(id, _, "%sCuando seas guardia tendrás el nuevo modelo. Este modelo no reemplaza al de !gSimón!y.", JB_PREFIX);
				g_PoliceModel[id] = 3;
			}
		}
	}
	
	DestroyLocalMenu(id, menuid);
	return PLUGIN_HANDLED;
}

public showMenu__MiniJuegos(const id)
{
	if(!is_user_connected(id))
		return;
	
	if(!g_Simon[id] && g_UserId[id] != 1)
	{
		colorChat(id, _, "%sSolo !gSimón!y tiene acceso a este comando.", JB_PREFIX);
		return;
	}
	
	new iMenuId;
	iMenuId = menu_create("MINI JUEGOS", "menu__MiniJuegos");
	
	menu_additem(iMenuId, "ESCONDIDAS", "1");
	// menu_additem(iMenuId, "LA MANCHA", "2");
	
	menu_setprop(iMenuId, MPROP_EXITNAME, "ATRÁS");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, 0);
}

public menu__MiniJuegos(const id, const menuid, const item)
{
	if(!is_user_connected(id))
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		DestroyLocalMenu(id, menuid);
		
		showMenu__Game(id);
		return PLUGIN_HANDLED;
	}
	else if(!g_Simon[id] && g_UserId[id] != 1)
	{
		colorChat(id, _, "%sSolo !gSimón!y tiene acceso a este comando.", JB_PREFIX);
		
		showMenu__Game(id);
		return PLUGIN_HANDLED;
	}
	else if(g_Escondidas || g_MN_Motin || g_MN_Invis || g_Mancha)
	{
		DestroyLocalMenu(id, menuid);
		
		showMenu__MiniJuegos(id);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[3];
	new iNothing;
	new iItem;
	
	menu_item_getinfo(menuid, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	iItem = str_to_num(sBuffer) - 1;
	
	switch(iItem)
	{
		case 0:
		{
			new Float:iDif;
			iDif = get_gametime() - g_MN_Gametime_HLTV;
			
			if(iDif > 10.0 || g_UltimaVoluntadSpent)
			{
				colorChat(id, _, "%sLas escondidas solo pueden ser activadas antes de que pasen !g10 segundos!y de empezada una ronda.", JB_PREFIX);
				
				DestroyLocalMenu(id, menuid);
				return PLUGIN_HANDLED;
			}
			else if(g_LastEscondidas > get_gametime() && g_UserId[id] != 1)
			{
				new Float:iRest = g_LastEscondidas - get_gametime();
				
				new Float:iMinutes = (iRest / 60.0);
				new Float:iSeconds = (iRest - (iMinutes * 60.0));
				colorChat(id, _, "%sTodavía debes esperar !g%0.0f:%0.0f!y para volver a jugar a las escondidas!", JB_PREFIX, iMinutes, iSeconds);
				
				DestroyLocalMenu(id, menuid);
				return PLUGIN_HANDLED;
			}
			
			g_LastEscondidas = get_gametime() + 900.0;
			
			if(g_Simon[id])
				colorChat(0, _, "%s!gSimón!y ha declarado !gESCONDIDAS!y.", JB_PREFIX);
			else
				colorChat(0, TERRORIST, "%s!t%s!y ha declarado !gESCONDIDAS!y.", JB_PREFIX, g_PlayerName[id]);
			
			colorChat(0, TERRORIST, "%sLos prisioneros tienen !t40 segundos!y para esconderse en cualquier lugar del mapa.", JB_PREFIX);
			
			openJails();
			
			g_Escondidas = 1;
			
			if(g_SimonId != 0)
				clcmd_NoSimon(g_SimonId);
			
			EnableHamForward(g_HamObjectCaps);
			
			new i;
			for(i = 1; i <= g_MaxPlayers; ++i)
			{
				if(!is_user_alive(i))
					continue;
				
				++g_Achievement_FreeKill[i];
				
				if(g_Achievement_FreeKill[i] == 3) {
					setAchievement(i, FREE_KILL);
				}
				
				if(getUserTeam(i) != FM_CS_TEAM_CT)
					continue;
				
				removeWeapons(i);
				
				set_user_velocity(i, Float:{0.0, 0.0, 0.0});
				ExecuteHamB(Ham_Player_ResetMaxSpeed, i);
				
				message_begin(MSG_ONE, g_Message_Screenfade, _, i);
				write_short(0);
				write_short(0);
				write_short(FFADE_STAYOUT);
				write_byte(0);
				write_byte(0);
				write_byte(0);
				write_byte(255);
				message_end();
			}
			
			g_EscondidasCoolDown = 39;
			
			set_task(1.0, "escondidasCoolDown", TASK_ESCONDIDAS);
			set_task(40.0, "startEscondidas", TASK_ESCONDIDAS);
		}
		// case 1: {
			// new Float:iDif;
			// iDif = get_gametime() - g_MN_Gametime_HLTV;
			
			// if(iDif > 10.0 || g_UltimaVoluntadSpent)
			// {
				// colorChat(id, _, "%sLa mancha solo puede ser activada antes de que pasen !g10 segundos!y de empezada una ronda.", JB_PREFIX);
				
				// DestroyLocalMenu(id, menuid);
				// return PLUGIN_HANDLED;
			// }
			// else if(g_LastEscondidas > get_gametime() && g_UserId[id] != 1)
			// {
				// new Float:iRest = g_LastEscondidas - get_gametime();
				
				// new Float:iMinutes = (iRest / 60.0);
				// new Float:iSeconds = (iRest - (iMinutes * 60.0));
				// colorChat(id, _, "%sTodavía debes esperar !g%0.0f:%0.0f!y para volver a jugar a la mancha!", JB_PREFIX, iMinutes, iSeconds);
				
				// DestroyLocalMenu(id, menuid);
				// return PLUGIN_HANDLED;
			// }
			
			// g_LastEscondidas = get_gametime() + 900.0;
			
			// if(g_Simon[id])
				// colorChat(0, _, "%s!gSimón!y ha declarado !gLA MANCHA!y.", JB_PREFIX);
			// else
				// colorChat(0, TERRORIST, "%s!t%s!y ha declarado !gLA MANCHA!y.", JB_PREFIX, g_PlayerName[id]);
			
			// colorChat(0, TERRORIST, "%sLos jugadores deben evitar que los toquen los que son la mancha (usuarios con !tcontorno rojo!y)", JB_PREFIX);
			
			// openJails();
			
			// g_Mancha = 2;
			
			// if(g_SimonId != 0)
				// clcmd_NoSimon(g_SimonId);
			
			// new i;
			// new j[33];
			// new k = 0;
			
			// for(i = 1; i <= g_MaxPlayers; ++i)
			// {
				// if(!is_user_alive(i))
					// continue;
				
				// j[k] = i;
				
				// ++k;
			// }
			
			// new iRandom = random_num(0, (k - 1));
			
			// colorChat(j[iRandom], _, "%sEres !gla mancha!y, toca a otros usuarios para que sean la mancha y te ayuden a ganar!", JB_PREFIX);
			
			// set_user_rendering(j[iRandom], kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 4);
			
			// set_user_velocity(j[iRandom], Float:{0.0, 0.0, 0.0});
			// ExecuteHamB(Ham_Player_ResetMaxSpeed, j[iRandom]);
			
			// g_IsMancha[j[iRandom]] = 1;
			
			// for(i = 1; i <= g_MaxPlayers; ++i)
			// {
				// if(!is_user_alive(i))
					// continue;
				
				// ++g_Achievement_FreeKill[i];
				
				// if(g_Achievement_FreeKill[i] == 3) {
					// setAchievement(i, FREE_KILL);
				// }
				
				// removeWeapons(i);
				
				// if(getUserTeam(i) == FM_CS_TEAM_T) {
					// g_WhoIsT[i] = 1;
					
					// if(i != j[iRandom]) {
						// setUserTeam(i, FM_CS_TEAM_CT);
					// }
				// } else {
					// g_WhoIsCT[i] = 1;
					
					// if(i == j[iRandom]) {
						// setUserTeam(i, FM_CS_TEAM_T);
					// }
				// }
			// }
			
			// g_EscondidasCoolDown = 9;
			
			// set_task(1.0, "manchaCoolDown", TASK_ESCONDIDAS);
			// set_task(10.0, "startMancha", TASK_ESCONDIDAS);
		// }
	}
	
	DestroyLocalMenu(id, menuid);
	return PLUGIN_HANDLED;
}

public escondidasCoolDown()
{
	--g_EscondidasCoolDown;
	
	if(g_EscondidasCoolDown == -2)
		return;
	
	if(g_Escondidas == 2)
	{
		new iMinutes;
		new iSeconds;
		
		iMinutes = g_EscondidasCoolDown / 60;
		iSeconds = g_EscondidasCoolDown - (iMinutes * 60);
		
		if(iMinutes)
		{
			if(iSeconds)
			{
				set_hudmessage(255, 255, 0, -1.0, 0.8, 0, 6.0, 1.1, 0.0, 0.0, -1);
				ShowSyncHudMsg(0, g_HudNotif, "%d MINUTO%s %d SEGUNDO%s^nPARA QUE FINALICEN LAS ESCONDIDAS", iMinutes, (iMinutes == 1) ? "" : "S", iSeconds, (iSeconds != 1) ? "S" : "");
			}
			else if(iMinutes == 2)
			{
				set_hudmessage(255, 255, 0, -1.0, 0.8, 0, 6.0, 1.1, 0.0, 0.0, -1);
				ShowSyncHudMsg(0, g_HudNotif, "1 MINUTO 59 SEGUNDOS^nPARA QUE FINALICEN LAS ESCONDIDAS");
				
				--g_EscondidasCoolDown;
			}
			else
			{
				set_hudmessage(255, 255, 0, -1.0, 0.8, 0, 6.0, 1.1, 0.0, 0.0, -1);
				ShowSyncHudMsg(0, g_HudNotif, "59 SEGUNDOS^nPARA QUE FINALICEN LAS ESCONDIDAS");
				
				--g_EscondidasCoolDown;
			}
		}
		else
		{
			set_hudmessage(255, 255, 0, -1.0, 0.8, 0, 6.0, 1.1, 0.0, 0.0, -1);
			ShowSyncHudMsg(0, g_HudNotif, "%d SEGUNDO%s^nPARA QUE FINALICEN LAS ESCONDIDAS", iSeconds, (iSeconds != 1) ? "S" : "");
		}
	}
	else
	{
		set_hudmessage(255, 255, 0, -1.0, 0.8, 0, 6.0, 1.1, 0.0, 0.0, -1);
		ShowSyncHudMsg(0, g_HudNotif, "%d SEGUNDOS PARA ESCONDERSE", g_EscondidasCoolDown);
	}
	
	set_task(1.0, "escondidasCoolDown", TASK_ESCONDIDAS);
}

public startEscondidas()
{
	g_Escondidas = 2;
	g_EscondidasCoolDown = 148;
	
	set_cvar_num("mp_flashlight", 1);
	
	client_cmd(0, "spk ^"%s^"", SOUND_LIGHTS_OFF);
	
	set_lights("a");
	
	colorChat(0, TERRORIST, "%sLas escondidas finalizarán en !t02:30 minutos!y.", JB_PREFIX);
	
	++g_EscondidasPlay;
	
	new i;
	new iTeam;
	for(i = 1; i <= g_MaxPlayers; ++i)
	{
		if(!is_user_alive(i))
			continue;
		
		iTeam = getUserTeam(i);
		
		if(iTeam == FM_CS_TEAM_T)
		{
			set_user_rendering(i);
			
			removeWeapons(i);
			
			set_user_velocity(i, Float:{0.0, 0.0, 0.0});
			ExecuteHamB(Ham_Player_ResetMaxSpeed, i);
			
			if(get_entity_flags(i) & FL_ONGROUND)
				set_user_gravity(i, 999999.9);
		}
		else if(iTeam == FM_CS_TEAM_CT)
		{
			give_item(i, "weapon_knife");
			give_item(i, "weapon_m4a1");
			give_item(i, "weapon_ak47");
			give_item(i, "weapon_deagle");
			
			cs_set_user_bpammo(i, CSW_M4A1, 200);
			cs_set_user_bpammo(i, CSW_AK47, 200);
			cs_set_user_bpammo(i, CSW_DEAGLE, 200);
			
			ExecuteHamB(Ham_Player_ResetMaxSpeed, i);
			
			message_begin(MSG_ONE, g_Message_Screenfade, _, i);
			
			write_short(UNIT_SECOND);
			write_short(0);
			write_short(FFADE_IN);
			write_byte(0);
			write_byte(0);
			write_byte(0);
			write_byte(255);
			message_end();
		}
	}
	
	set_task(150.0, "endEscondidas", TASK_ESCONDIDAS);
}

public endEscondidas()
{
	new i;
	new iTeam;
	new iCountT = 0;
	new iT_Id;
	
	for(i = 1; i <= g_MaxPlayers; ++i)
	{
		if(!is_user_alive(i))
			continue;
		
		iTeam = getUserTeam(i);
		
		if(iTeam == FM_CS_TEAM_T) {
			g_Ira[i] += 25;
			
			++iCountT;
			iT_Id = i;
		} else if(iTeam == FM_CS_TEAM_CT) {
			user_silentkill(i);
		}
	}
	
	colorChat(0, _, "%sTodos los prisioneros vivos ganaron !g+25 Ira!y por ganar las escondidas.", JB_PREFIX);
	
	if(iCountT == 1) {
		setAchievement(iT_Id, NO_ME_ENCONTRARON);
	}
	
	++g_EscondidasWin_T;
	
	g_EscondidasCoolDown = -1;
	remove_task(TASK_ESCONDIDAS);
}

public manchaCoolDown()
{
	--g_EscondidasCoolDown;
	
	if(g_EscondidasCoolDown == -2)
		return;
	
	if(g_Mancha == 1)
	{
		new iMinutes;
		new iSeconds;
		
		iMinutes = g_EscondidasCoolDown / 60;
		iSeconds = g_EscondidasCoolDown - (iMinutes * 60);
		
		if(iMinutes)
		{
			if(iSeconds)
			{
				set_hudmessage(255, 255, 0, -1.0, 0.8, 0, 6.0, 1.1, 0.0, 0.0, -1);
				ShowSyncHudMsg(0, g_HudNotif, "%d MINUTO%s %d SEGUNDO%s^nPARA QUE FINALICE LA MANCHA", iMinutes, (iMinutes == 1) ? "" : "S", iSeconds, (iSeconds != 1) ? "S" : "");
			}
			else if(iMinutes == 2)
			{
				set_hudmessage(255, 255, 0, -1.0, 0.8, 0, 6.0, 1.1, 0.0, 0.0, -1);
				ShowSyncHudMsg(0, g_HudNotif, "1 MINUTO 59 SEGUNDOS^nPARA QUE FINALICE LA MANCHA");
				
				--g_EscondidasCoolDown;
			}
			else
			{
				set_hudmessage(255, 255, 0, -1.0, 0.8, 0, 6.0, 1.1, 0.0, 0.0, -1);
				ShowSyncHudMsg(0, g_HudNotif, "59 SEGUNDOS^nPARA QUE FINALICE LA MANCHA");
				
				--g_EscondidasCoolDown;
			}
		}
		else
		{
			set_hudmessage(255, 255, 0, -1.0, 0.8, 0, 6.0, 1.1, 0.0, 0.0, -1);
			ShowSyncHudMsg(0, g_HudNotif, "%d SEGUNDO%s^nPARA QUE FINALICE LA MANCHA", iSeconds, (iSeconds != 1) ? "S" : "");
		}
	}
	else
	{
		set_hudmessage(255, 255, 0, -1.0, 0.8, 0, 6.0, 1.1, 0.0, 0.0, -1);
		ShowSyncHudMsg(0, g_HudNotif, "%d SEGUNDOS PARA CORRER", g_EscondidasCoolDown);
	}
	
	set_task(1.0, "manchaCoolDown", TASK_ESCONDIDAS);
}

public startMancha()
{
	g_Mancha = 1;
	g_EscondidasCoolDown = 148;
	
	colorChat(0, TERRORIST, "%sLa mancha finalizará en !t02:30 minutos!y.", JB_PREFIX);
	
	new i;
	for(i = 1; i <= g_MaxPlayers; ++i)
	{
		if(!is_user_alive(i))
			continue;
		
		if(g_IsMancha[i]) {
			ExecuteHamB(Ham_Player_ResetMaxSpeed, i);
		}
	}
	
	EnableHamForward(g_HamPlayerTouch);
	
	set_task(150.0, "endMancha", TASK_ESCONDIDAS);
}

public endMancha()
{
	new i;
	new iTeam;
	
	DisableHamForward(g_HamPlayerTouch);
	
	for(i = 1; i <= g_MaxPlayers; ++i)
	{
		if(!is_user_alive(i))
			continue;
		
		iTeam = getUserTeam(i);
		
		if(!g_IsMancha[i]) {
			g_Ira[i] += 80;
		}
		
		if(g_WhoIsT[i] && iTeam == FM_CS_TEAM_CT) {
			setUserTeam(i, FM_CS_TEAM_T);
		} else if(g_WhoIsCT[i] && iTeam == FM_CS_TEAM_T) {
			setUserTeam(i, FM_CS_TEAM_CT);
			
			user_silentkill(i);
			
			continue;
		}
		
		if(iTeam == FM_CS_TEAM_CT) {
			user_silentkill(i);
		}
	}
	
	colorChat(0, _, "%sTodos los jugadores que no fueron tocados ganaron !g+80 Ira!y por ganar la mancha.", JB_PREFIX);
	
	g_EscondidasCoolDown = -1;
	remove_task(TASK_ESCONDIDAS);
}

public showMenu__Rangos(const id)
{
	if(!is_user_connected(id))
		return;
	
	new sTittle[128];
	new sText[64];
	new sItem[64];
	new sPosition[3];
	new iMenuId;
	new iGuardKills = g_GuardKills[id];
	new iSimonKills = g_SimonKills[id];
	new i;
	
	formatex(sTittle, 127, "RANGOS^n\wG \r= \yGUARDIAS^t\wS \r= \ySIMONES^n^n\wGuardias matados: \y%d^n\wSimones matados: \y%d\R", iGuardKills, iSimonKills);
	iMenuId = menu_create(sTittle, "menu__Rangos");
	
	for(i = 0; i < sizeof(RANGOS) - 1; ++i)
	{
		num_to_str((i+1), sPosition, 2);
		
		if(i <= g_Rango[id])
			formatex(sItem, 63, "%s%s", RANGOS[i][rangoName], (g_Rango[id] != i) ? "" : " \y(ACTUAL)");
		else
		{
			formatex(sText, 63, "\w[%s%d G \r- %s%d S\w]", (iGuardKills < RANGOS[i - 1][rangoGuards]) ? "\d" : "\y", RANGOS[i - 1][rangoGuards], (iSimonKills < RANGOS[i - 1][rangoSimon]) ? "\d" : "\y", RANGOS[i - 1][rangoSimon]);
			formatex(sItem, 63, "%s %s", RANGOS[i][rangoName], sText);
		}
		
		menu_additem(iMenuId, sItem, sPosition);
	}
	
	// menu_setprop(iMenuId, MPROP_PERPAGE, 4);
	menu_setprop(iMenuId, MPROP_NEXTNAME, "SIGUIENTE");
	menu_setprop(iMenuId, MPROP_BACKNAME, "ATRÁS");
	menu_setprop(iMenuId, MPROP_EXITNAME, "VOLVER");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, 0);
}

public menu__Rangos(const id, const menuid, const item)
{
	if(!is_user_connected(id))
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		DestroyLocalMenu(id, menuid);
		
		showMenu__Game(id);
		return PLUGIN_HANDLED;
	}
	
	DestroyLocalMenu(id, menuid);
	
	showMenu__Rangos(id);
	return PLUGIN_HANDLED;
}

public showMenu__DiaLibre(const id)
{
	if(!is_user_connected(id))
		return;
	
	if(!g_Simon[id] && !(get_user_flags(id) & ADMIN_BAN))
	{
		colorChat(id, _, "%sSolo !gSimón!y puede otorgar !gDía Libre!y.", JB_PREFIX);
		
		showMenu__Game(id);
		return;
	}
	
	new iMenuId;
	iMenuId = menu_create("DÍA LIBRE", "menu__DiaLibre");
	
	menu_additem(iMenuId, "DÍA LIBRE PERSONAL", "1");
	menu_additem(iMenuId, "DÍA LIBRE GENERAL", "2");
	
	menu_setprop(iMenuId, MPROP_EXITNAME, "ATRÁS");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, 0);
}

public menu__DiaLibre(const id, const menuid, const item)
{
	if(!is_user_connected(id))
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(!g_Simon[id] && !(get_user_flags(id) & ADMIN_BAN))
	{
		colorChat(id, _, "%sSolo !gSimón!y puede otorgar !gDía Libre!y.", JB_PREFIX);
		
		DestroyLocalMenu(id, menuid);
		
		showMenu__Game(id);
		return PLUGIN_HANDLED;
	}
	
	if(g_MN_Motin || g_Escondidas || g_Mancha)
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		DestroyLocalMenu(id, menuid);
		
		showMenu__Game(id);
		return PLUGIN_HANDLED;
	}
	
	new sItem[3];
	new iNothing;
	new iItem;
	
	menu_item_getinfo(menuid, item, iNothing, sItem, charsmax(sItem), _, _, iNothing);
	iItem = str_to_num(sItem);
	
	DestroyLocalMenu(id, menuid);
	
	if(iItem == 1) showMenu__Users(id, DIA_LIBRE_PERSONAL);
	else
	{
		if(g_FreeDay)
			return PLUGIN_HANDLED;
		
		if(g_Simon[id])
		{
			colorChat(0, _, "%sEl !gSimón!y ha declarado !gDía Libre General!y.", JB_PREFIX);
			clcmd_NoSimon(id);
		}
		else
			colorChat(0, TERRORIST, "%sEl administrador !t%s!y ha declarado !gDía Libre General!y.", JB_PREFIX, g_PlayerName[id]);
		
		clearDHUDs(0);
		
		set_dhudmessage(255, 255, 0, -1.0, 0.6, 0, 6.0, 6.0, 1.0, 1.0);
		show_dhudmessage(0, "HOY ES DÍA LIBRE GENERAL");
		
		g_FreeDay = 1;
		
		new i;
		for(i = 1; i <= g_MaxPlayers; ++i)
		{
			if(!is_user_connected(i))
				continue;
			
			if(!is_user_alive(i))
				continue;
			
			if(getUserTeam(i) != FM_CS_TEAM_T)
				continue;
			
			set_user_rendering(i, kRenderFxGlowShell, 0, 255, 0, kRenderNormal, 25);
		}
		
		openJails();
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__Brillo(const id)
{
	if(!is_user_connected(id))
		return;
	
	if(!g_Simon[id])
	{
		colorChat(id, _, "%sSolo !gSimón!y puede otorgarle !gbrillo!y a los prisioneros.", JB_PREFIX);
		
		showMenu__Game(id);
		return;
	}
	
	static sMenu[450];
	new iLen;
	new i;
	
	iLen = 0;
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yBRILLO^n^n", (i+1), GLOW_COLORS[i][glowName]);
	
	for(i = 0; i < MAX_COLORS; ++i)
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\w %s^n", (i+1), GLOW_COLORS[i][glowName]);
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\r0.\w ATRÁS");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Glow Menu");
}

public menu__Glow(const id, const key)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!g_Simon[id])
	{
		colorChat(id, _, "%sSolo !gSimón!y puede otorgarle !gbrillo!y a los prisioneros.", JB_PREFIX);
		
		showMenu__Game(id);
		return PLUGIN_HANDLED;
	}
	else if(g_MN_Motin)
		return PLUGIN_HANDLED;
	
	if(key == 9)
	{
		showMenu__Game(id);
		return PLUGIN_HANDLED;
	}
	
	if(key >= 0 && key < MAX_COLORS)
	{
		g_GlowColorSelected[id] = key;
		showMenu__Users(id, BRILLO);
	}
	else
		showMenu__Brillo(id);
	
	return PLUGIN_HANDLED;
}

public showMenu__Boxeo(const id)
{
	if(!is_user_connected(id))
		return;
	
	if(!g_Simon[id])
	{
		colorChat(id, _, "%sSolo !gSimón!y tiene acceso a este menú.", JB_PREFIX);
		
		showMenu__Game(id);
		return;
	}
	
	new iMenuId;
	iMenuId = menu_create("BOXEO", "menu__Boxeo");
	
	menu_additem(iMenuId, "BOXEO GENERAL", "1");
	menu_additem(iMenuId, "BOXEO POR COLORES^n", "2");
	
	menu_additem(iMenuId, "DESHABILITAR BOXEO", "3");
	
	menu_setprop(iMenuId, MPROP_EXITNAME, "ATRÁS");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, 0);
}

public menu__Boxeo(const id, const menuid, const item)
{
	if(!is_user_connected(id))
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(!g_Simon[id])
	{
		colorChat(id, _, "%sSolo !gSimón!y tiene acceso a este menú.", JB_PREFIX);
		
		DestroyLocalMenu(id, menuid);
		
		showMenu__Game(id);
		return PLUGIN_HANDLED;
	}
	else if(g_MN_Motin)
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		DestroyLocalMenu(id, menuid);
		
		showMenu__Game(id);
		return PLUGIN_HANDLED;
	}
	
	new sItem[3];
	new iNothing;
	new iItem;
	
	menu_item_getinfo(menuid, item, iNothing, sItem, charsmax(sItem), _, _, iNothing);
	iItem = str_to_num(sItem);
	
	DestroyLocalMenu(id, menuid);
	
	switch(iItem)
	{
		case 1:
		{
			if(g_Boxeo)
			{
				colorChat(id, _, "%sYa hay un !gboxeo!y en curso.", JB_PREFIX);
				
				showMenu__Boxeo(id);
				return PLUGIN_HANDLED;
			}
			else if(g_BoxeoCountDown > 0)
			{
				colorChat(id, _, "%sYa hay un !gtemporizador para boxear!y en curso y el !gboxeo!y comenzará en breve.", JB_PREFIX);
				
				showMenu__Boxeo(id);
				return PLUGIN_HANDLED;
			}
			
			g_BoxeoGeneral = 1;
			
			showMenu__BoxeoCountDown(id);
		}
		case 2:
		{
			if(g_Boxeo)
			{
				colorChat(id, _, "%sYa hay un !gboxeo!y en curso.", JB_PREFIX);
				
				showMenu__Boxeo(id);
				return PLUGIN_HANDLED;
			}
			else if(g_BoxeoCountDown > 0)
			{
				colorChat(id, _, "%sYa hay un !gtemporizador para boxear!y en curso y el !gboxeo!y comenzará en breve.", JB_PREFIX);
				
				showMenu__Boxeo(id);
				return PLUGIN_HANDLED;
			}
			
			g_BoxeoGeneral = 0;
			showMenu__BoxeoColores(id);
		}
		case 3:
		{
			if(g_Boxeo)
			{
				colorChat(0, _, "%sEl !gboxeo!y ha sido deshabilitado por !gSimón!y.", JB_PREFIX);
				
				new i;
				for(i = 1; i <= g_MaxPlayers; ++i)
				{
					if(!is_user_connected(i))
						continue;
					
					if(!is_user_alive(i))
						continue;
					
					if(getUserTeam(i) != FM_CS_TEAM_T)
						continue;
					
					set_user_health(i, 100);
				}
			}
			
			g_BoxeoGeneral = 0;
			g_Boxeo = 0;
			
			g_BoxColors[C_BLANCO] = 0;
			g_BoxColors[C_AMARILLO] = 0;
			g_BoxColors[C_VIOLETA] = 0;
			g_BoxColors[C_CELESTE] = 0;
			
			g_BoxeoCountDown = 0;
			
			remove_task(TASK_BOX_COUNTDOWN);
			
			showMenu__Boxeo(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__BoxeoColores(const id)
{
	if(!is_user_connected(id))
		return;
	
	if(!g_Simon[id])
	{
		colorChat(id, _, "%sSolo !gSimón!y tiene acceso a este menú.", JB_PREFIX);
		
		showMenu__Game(id);
		return;
	}
	
	static sMenu[450];
	new iLen;
	
	iLen = 0;
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yBOXEO POR COLORES^n^n");
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r1.%s", (g_BoxColors[C_BLANCO]) ? "\y BLANCO \rvs." : "\w BLANCO");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\r2.%s", (g_BoxColors[C_AMARILLO]) ? "\y AMARILLO \rvs." : "\w AMARILLO");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\r3.%s", (g_BoxColors[C_VIOLETA]) ? "\y VIOLETA \rvs." : "\w VIOLETA");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\r4.%s", (g_BoxColors[C_CELESTE]) ? "\y CELESTE \rvs." : "\w CELESTE");
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n^n\r6.\w TODO LISTO^n^n\r0.\w ATRÁS");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Box Colors Menu");
}

public menu__BoxColors(const id, const key)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!g_Simon[id])
	{
		colorChat(id, _, "%sSolo !gSimón!y tiene acceso a este menú.", JB_PREFIX);
		
		showMenu__Game(id);
		return PLUGIN_HANDLED;
	}
	else if(g_MN_Motin)
		return PLUGIN_HANDLED;
	
	switch(key)
	{
		case 0: g_BoxColors[C_BLANCO] = (g_BoxColors[C_BLANCO] - 1) * (-1);
		case 1: g_BoxColors[C_AMARILLO] = (g_BoxColors[C_AMARILLO] - 1) * (-1);
		case 2: g_BoxColors[C_VIOLETA] = (g_BoxColors[C_VIOLETA] - 1) * (-1);
		case 3: g_BoxColors[C_CELESTE] = (g_BoxColors[C_CELESTE] - 1) * (-1);
		case 5:
		{
			new iColors = 0;
			new i;
			
			for(i = C_BLANCO; i <= C_CELESTE; ++i)
			{
				if(g_BoxColors[i])
					++iColors;
			}
			
			if(iColors >= 2)
			{
				// 2 = blanco c amarillo
				// 4 = blanco c violeta
				// 8 = blanco c celeste
				// 16 = amarillo c violeta
				// 32 = amarillo c celeste
				// 64 = violeta c celeste
				// 128 = blanco c amarillo c violeta
				// 256 = blanco c amarillo c celeste
				// 512 = blanco c violeta c celeste
				// 1024 = amarillo c violeta c celeste
				
				if(!g_BoxColors[C_VIOLETA] && !g_BoxColors[C_CELESTE]) g_BoxGlowColors = 2;
				else if(!g_BoxColors[C_AMARILLO] && !g_BoxColors[C_CELESTE]) g_BoxGlowColors = 4;
				else if(!g_BoxColors[C_AMARILLO] && !g_BoxColors[C_VIOLETA]) g_BoxGlowColors = 8;
				else if(!g_BoxColors[C_BLANCO] && !g_BoxColors[C_CELESTE]) g_BoxGlowColors = 16;
				else if(!g_BoxColors[C_BLANCO] && !g_BoxColors[C_VIOLETA]) g_BoxGlowColors = 32;
				else if(!g_BoxColors[C_BLANCO] && !g_BoxColors[C_AMARILLO]) g_BoxGlowColors = 64;
				else if(!g_BoxColors[C_CELESTE]) g_BoxGlowColors = 128;
				else if(!g_BoxColors[C_VIOLETA]) g_BoxGlowColors = 256;
				else if(!g_BoxColors[C_AMARILLO]) g_BoxGlowColors = 512;
				else if(!g_BoxColors[C_BLANCO]) g_BoxGlowColors = 1024;
				else g_BoxGlowColors = 2048;
				
				showMenu__BoxeoCountDown(id);
				return PLUGIN_HANDLED;
			}
			else
				colorChat(id, _, "%sTenés que elegir !gdos!y o !gmás colores!y para que puedan boxear.", JB_PREFIX);
		}
		case 9:
		{
			showMenu__Boxeo(id);
			return PLUGIN_HANDLED;
		}
	}
	
	showMenu__BoxeoColores(id);
	return PLUGIN_HANDLED;
}

public showMenu__BoxeoCountDown(const id)
{
	if(!is_user_connected(id))
		return;
	
	if(!g_Simon[id])
	{
		colorChat(id, _, "%sSolo !gSimón!y tiene acceso a este menú.", JB_PREFIX);
		
		showMenu__Game(id);
		return;
	}
	
	static sMenu[450];
	new iLen;
	
	iLen = 0;
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yTEMPORIZADOR PARA BOXEAR^n^n");
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r1.\w YA^n");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r2.\w Tres segundos^n");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r3.\w Cinco segundos^n");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r4.\w Siete segundos^n");
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r5.\w Diez segundos");
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n^n\r0.\w ATRÁS");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Count Down Menu");
}

public menu__CountDown(const id, const key)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!g_Simon[id])
	{
		colorChat(id, _, "%sSolo !gSimón!y tiene acceso a este menú.", JB_PREFIX);
		
		showMenu__Game(id);
		return PLUGIN_HANDLED;
	}
	else if(g_MN_Motin)
		return PLUGIN_HANDLED;
	
	switch(key)
	{
		case 0: g_BoxeoCountDown = 1;
		case 1: g_BoxeoCountDown = 3;
		case 2: g_BoxeoCountDown = 5;
		case 3: g_BoxeoCountDown = 7;
		case 4: g_BoxeoCountDown = 10;
		case 9:
		{
			showMenu__Boxeo(id);
			return PLUGIN_HANDLED;
		}
	}
	
	if(g_BoxeoGeneral)
	{
		colorChat(0, _, "%sEl boxeo !ggeneral!y comenzará en !g%d!y segundo%s.", JB_PREFIX, g_BoxeoCountDown, (g_BoxeoCountDown != 1) ? "s" : "");
		
		set_task(float(g_BoxeoCountDown), "startBoxeo", TASK_BOX_COUNTDOWN);
		
		if(g_BoxeoCountDown != 1)
			set_task(1.0, "boxeoCountDown", TASK_BOX_COUNTDOWN);
		else
			client_cmd(0, "spk ^"%s^"", SOUND_FIGHT);
	}
	else
	{
		new sText[75];
		
		if(g_BoxGlowColors != 2048)
		{
			// 2 = blanco c amarillo
			// 4 = blanco c violeta
			// 8 = blanco c celeste
			// 16 = amarillo c violeta
			// 32 = amarillo c celeste
			// 64 = violeta c celeste
			// 128 = blanco c amarillo c violeta
			// 256 = blanco c amarillo c celeste
			// 512 = blanco c violeta c celeste
			// 1024 = amarillo c violeta c celeste
			
			switch(g_BoxGlowColors)
			{
				case 2: formatex(sText, 74, "!gBLANCO!y !tvs!y. !gAMARILLO!y");
				case 4: formatex(sText, 74, "!gBLANCO!y !tvs!y. !gVIOLETA!y");
				case 8: formatex(sText, 74, "!gBLANCO!y !tvs!y. !gCELESTE!y");
				case 16: formatex(sText, 74, "!gAMARILLO!y !tvs!y. !gVIOLETA!y");
				case 32: formatex(sText, 74, "!gAMARILLO!y !tvs!y. !gCELESTE!y");
				case 64: formatex(sText, 74, "!gVIOLETA!y !tvs!y. !gCELESTE!y");
				case 128: formatex(sText, 74, "!gBLANCO!y !tvs!y. !gAMARILLO!y !tvs!y. !gVIOLETA!y");
				case 256: formatex(sText, 74, "!gBLANCO!y !tvs!y. !gAMARILLO!y !tvs!y. !gCELESTE!y");
				case 512: formatex(sText, 74, "!gBLANCO!y !tvs!y. !gVIOLETA!y !tvs!y. !gCELESTE!y");
				case 1024: formatex(sText, 74, "!gAMARILLO!y !tvs!y. !gVIOLETA!y !tvs!y. !gCELESTE!y");
			}
		}
		else
			formatex(sText, 74, "!gBLANCO!y !tvs!y. !gAMARILLO!y !tvs!y. !gVIOLETA!y !tvs!y. !gCELESTE!y");
		
		colorChat(0, _, "%sEl boxeo !gpor colores!y comenzará en !g%d!y segundo%s.", JB_PREFIX, g_BoxeoCountDown, (g_BoxeoCountDown != 1) ? "s" : "");
		colorChat(0, TERRORIST, "%sEl boxeo es %s", JB_PREFIX, sText);
		
		set_task(float(g_BoxeoCountDown), "startBoxeo", TASK_BOX_COUNTDOWN);
		
		if(g_BoxeoCountDown != 1)
			set_task(1.0, "boxeoCountDown", TASK_BOX_COUNTDOWN);
		else
			client_cmd(0, "spk ^"%s^"", SOUND_FIGHT);
	}
	
	return PLUGIN_HANDLED;
}

public startBoxeo()
{
	colorChat(0, TERRORIST, "%s!t¡FIGHT!!y", JB_PREFIX);
	g_Boxeo = 1;
	
	new i;
	for(i = 1; i <= g_MaxPlayers; ++i)
	{
		if(!is_user_alive(i))
			continue;
		
		if(g_UserFree[i]) {
			continue;
		}
		
		if(getUserTeam(i) != FM_CS_TEAM_T)
			continue;
		
		if(get_user_health(i) < 100)
			set_user_health(i, 100);
	}
}

public boxeoCountDown()
{
	--g_BoxeoCountDown;
	
	if(g_BoxeoCountDown == 1)
		client_cmd(0, "spk ^"%s^"", SOUND_FIGHT);
	
	if(g_BoxeoCountDown <= 0)
		return;
	
	colorChat(0, _, "%s!g%d...!y", JB_PREFIX, g_BoxeoCountDown);
	
	set_task(1.0, "boxeoCountDown", TASK_BOX_COUNTDOWN);
}

public showMenu__UltimaVoluntad(const id)
{
	if(!is_user_connected(id))
		return;
	
	if(!g_UltimaVoluntad[id])
		return;
	
	if((getUserAliveCTs() >= 1 && g_Duelo && !g_InDuelo[id]))
	{
		showMenu__DueloUsers(id, g_MenuUsersMode[id]);
		return;
	}
	else if(g_InDuelo[id])
		return;
	
	new iMenuId;
	iMenuId = menu_create("ÚLTIMA VOLUNTAD", "menu__UltimaVoluntad");
	
	menu_additem(iMenuId, "DÍA LIBRE PERSONAL", "1");
	menu_additem(iMenuId, "MATAR A LOS GUARDIAS", "2");
	menu_additem(iMenuId, "BOXEO", "3");
	menu_additem(iMenuId, "DUELO DE DEAGLE", "4");
	menu_additem(iMenuId, "DUELO DE AWP", "5");
	menu_additem(iMenuId, "DUELO DE SCOUT", "6");
	menu_additem(iMenuId, "DUELO DE GRANADAS", "7");
	menu_additem(iMenuId, "+30 IRA", "8");
	
	menu_setprop(iMenuId, MPROP_BACKNAME, "ATRÁS");
	menu_setprop(iMenuId, MPROP_NEXTNAME, "SIGUIENTE");
	menu_setprop(iMenuId, MPROP_EXITNAME, "SALIR");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, 0);
}

public menu__UltimaVoluntad(const id, const menuid, const item)
{
	if(!is_user_connected(id))
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(!g_UltimaVoluntad[id])
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	new sItem[3];
	new iNothing;
	new iItem;
	
	menu_item_getinfo(menuid, item, iNothing, sItem, charsmax(sItem), _, _, iNothing);
	iItem = str_to_num(sItem);
	
	DestroyLocalMenu(id, menuid);
	
	switch(iItem)
	{
		case 1:
		{
			colorChat(0, _, "%sEl prisionero ha elegido tener !gdía libre!y la siguiente ronda.", JB_PREFIX);
			g_FreeDayNextRound[id] = 1;
			
			user_silentkill(id);
			
			g_UltimaVoluntad[id] = 0;
		}
		case 2:
		{
			g_KillGuards = 1;
			
			colorChat(0, TERRORIST, "%sEl prisionero ha elegido !gmatar a los guardias!y. Tenés !t20 segundos!y para matarlos.", JB_PREFIX);
			
			give_item(id, "weapon_m4a1");
			give_item(id, "weapon_ak47");
			give_item(id, "weapon_deagle");
			
			g_TeleportSpawnCount = 0;
			
			new i;
			for(i = 1; i <= g_MaxPlayers; ++i) {
				if(!is_user_alive(i))
					continue;
				
				if(getUserTeam(i) != FM_CS_TEAM_CT) {
					entity_set_vector(i, EV_VEC_origin, g_SpawnsCT[g_TeleportSpawnCount]);
					
					++g_TeleportSpawnCount;
					continue;
				}
				
				ExecuteHamB(Ham_Player_ResetMaxSpeed, i);
				
				removeWeapons(i);
				
				entity_set_vector(i, EV_VEC_origin, g_SpawnsCT[g_TeleportSpawnCount]);
				++g_TeleportSpawnCount;
			}
			
			remove_task(id + TASK_ULTIMA_VOLUNTAD);
			remove_task(id + TASK_LAST_REQUEST);
			
			set_task(20.0, "killPrissoner", id + TASK_LAST_REQUEST);
			
			g_UltimaVoluntad[id] = 0;
		}
		case 3: showMenu__DueloUsers(id, DUELO_BOX);
		case 4: showMenu__DueloUsers(id, DUELO_DEAGLE);
		case 5: showMenu__DueloUsers(id, DUELO_AWP);
		case 6: showMenu__DueloUsers(id, DUELO_SCOUT);
		case 7: showMenu__DueloUsers(id, DUELO_GRANADAS);
		case 8:
		{
			if(g_IraBlock)
			{
				colorChat(id, TERRORIST, "%sLa ganancia de !tira!y y !trangos!y está bloqueada, elige otra opción.", JB_PREFIX);
				
				showMenu__UltimaVoluntad(id);
				return PLUGIN_HANDLED;
			}
			
			colorChat(0, _, "%sEl prisionero ha elegido !g+30!y de !gIra!y.", JB_PREFIX);
			
			g_Ira[id] += 30;
			g_UltimaVoluntad[id] = 0;
			
			user_silentkill(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

/*public changeTeam(const id)
{
	if(is_user_connected(id))
	{
		setUserTeam(id, FM_CS_TEAM_T);
		
		emessage_begin(MSG_ALL, get_user_msgid("TeamInfo"));
		ewrite_byte(id);
		ewrite_string("TERRORIST");
		emessage_end();
		
		ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
	}
}*/

/*public removeSpeed(const id)
{
	if(!is_user_connected(id))
		return;
	
	removeWeapons(id);
	
	set_user_velocity(id, Float:{0.0, 0.0, 0.0});
	ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
}*/

public killPrissoner(const taskid)
{
	user_silentkill(ID_LAST_REQUEST);
	colorChat(0, _, "%sEl prisionero fue asesinado por demorar demasiado en matar a los guardias!", JB_PREFIX);
}

public showMenu__DueloUsers(const id, const duelo)
{
	if(!is_user_connected(id))
		return;
	
	if(!g_UltimaVoluntad[id])
		return;
	
	g_MenuUsersMode[id] = duelo;
	
	new sItem[2];
	new iMenuId;
	new i;
	
	switch(duelo)
	{
		case DUELO_BOX: iMenuId = menu_create("BOXEO", "menu__DueloUsers");
		case DUELO_DEAGLE: iMenuId = menu_create("DUELO DE DEAGLE", "menu__DueloUsers");
		case DUELO_AWP: iMenuId = menu_create("DUELO DE AWP", "menu__DueloUsers");
		case DUELO_SCOUT: iMenuId = menu_create("DUELO DE SCOUT", "menu__DueloUsers");
		case DUELO_GRANADAS: iMenuId = menu_create("DUELO DE GRANADAS", "menu__DueloUsers");
	}
	
	for(i = 1; i <= g_MaxPlayers; ++i)
	{
		if(!is_user_alive(i))
			continue;
		
		if(getUserTeam(i) != FM_CS_TEAM_CT)
			continue;
		
		sItem[0] = i;
		sItem[1] = 0;
		
		menu_additem(iMenuId, g_PlayerName[i], sItem);
	}
	
	if(menu_items(iMenuId) <= 0)
	{
		colorChat(id, _, "%sNo hay usuarios disponibles para mostrar en el menú.", JB_PREFIX);
		
		DestroyLocalMenu(id, iMenuId);
		return;
	}
	
	menu_setprop(iMenuId, MPROP_EXITNAME, "ATRÁS");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, 0);
}

public menu__DueloUsers(const id, const menuid, const item)
{
	if(!is_user_alive(id))
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(!g_UltimaVoluntad[id])
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		DestroyLocalMenu(id, menuid);
		
		showMenu__UltimaVoluntad(id);
		return PLUGIN_HANDLED;
	}
	
	new sItem[2];
	new iNothing;
	new iUser;
	
	menu_item_getinfo(menuid, item, iNothing, sItem, charsmax(sItem), _, _, iNothing);
	iUser = sItem[0];
	
	if(is_user_connected(iUser))
	{
		if(is_user_alive(iUser))
		{
			switch(g_MenuUsersMode[id])
			{
				case DUELO_BOX:
				{
					prepareDuel(id, iUser);
					
					g_InDuelo[id] = 1;
					g_InDuelo[iUser] = 1;
					
					colorChat(0, CT, "%sEl prisionero ha elegido un !gboxeo!y contra !t%s!y", JB_PREFIX, g_PlayerName[iUser]);
					
					remove_task(id + TASK_ULTIMA_VOLUNTAD);
				}
				case DUELO_DEAGLE:
				{
					prepareDuel(id, iUser);
					
					g_InDuelo[id] = 2;
					g_InDuelo[iUser] = 2;
					
					colorChat(0, CT, "%sEl prisionero ha elegido un !gduelo de deagle!y contra !t%s!y", JB_PREFIX, g_PlayerName[iUser]);
					
					removeWeapons(id);
					removeWeapons(iUser);
					
					give_item(id, "weapon_deagle");
					give_item(iUser, "weapon_deagle");
					
					cs_set_weapon_ammo(fm_find_ent_by_owner(-1, "weapon_deagle", id), 1);
					cs_set_weapon_ammo(fm_find_ent_by_owner(-1, "weapon_deagle", iUser), 1);
					
					cs_set_user_bpammo(id, CSW_DEAGLE, 200);
					cs_set_user_bpammo(iUser, CSW_DEAGLE, 200);
					
					remove_task(id + TASK_ULTIMA_VOLUNTAD);
				}
				case DUELO_AWP:
				{
					prepareDuel(id, iUser);
					
					g_InDuelo[id] = 3;
					g_InDuelo[iUser] = 3;
					
					colorChat(0, CT, "%sEl prisionero ha elegido un !gduelo de awp!y contra !t%s!y", JB_PREFIX, g_PlayerName[iUser]);
					
					removeWeapons(id);
					removeWeapons(iUser);
					
					give_item(id, "weapon_awp");
					give_item(iUser, "weapon_awp");
					
					cs_set_user_bpammo(id, CSW_AWP, 200);
					cs_set_user_bpammo(iUser, CSW_AWP, 200);
					
					remove_task(id + TASK_ULTIMA_VOLUNTAD);
				}
				case DUELO_SCOUT:
				{
					prepareDuel(id, iUser);
					
					g_InDuelo[id] = 4;
					g_InDuelo[iUser] = 4;
					
					colorChat(0, CT, "%sEl prisionero ha elegido un !gduelo de scout!y contra !t%s!y", JB_PREFIX, g_PlayerName[iUser]);
					
					removeWeapons(id);
					removeWeapons(iUser);
					
					give_item(id, "weapon_scout");
					give_item(iUser, "weapon_scout");
					
					cs_set_user_bpammo(id, CSW_SCOUT, 200);
					cs_set_user_bpammo(iUser, CSW_SCOUT, 200);
					
					remove_task(id + TASK_ULTIMA_VOLUNTAD);
				}
				case DUELO_GRANADAS:
				{
					prepareDuel(id, iUser);
					
					g_InDuelo[id] = 5;
					g_InDuelo[iUser] = 5;
					
					colorChat(0, CT, "%sEl prisionero ha elegido un !gduelo de granadas!y contra !t%s!y", JB_PREFIX, g_PlayerName[iUser]);
					
					removeWeapons(id);
					removeWeapons(iUser);
					
					give_item(id, "weapon_hegrenade");
					give_item(iUser, "weapon_hegrenade");
					
					cs_set_user_bpammo(id, CSW_HEGRENADE, 200);
					cs_set_user_bpammo(iUser, CSW_HEGRENADE, 200);
					
					remove_task(id + TASK_ULTIMA_VOLUNTAD);
				}
			}
		}
		else
			colorChat(id, _, "%sEl usuario seleccionado está muerto.", JB_PREFIX);
	}
	else
		colorChat(id, _, "%sEl usuario seleccionado se ha desconectado.", JB_PREFIX);
	
	DestroyLocalMenu(id, menuid);
	return PLUGIN_HANDLED;
}

public prepareDuel(const id, const iUser)
{
	g_Duelo = 2;
	
	g_BlockDrop[id] = 1;
	g_BlockDrop[iUser] = 1;
	
	EnableHamForward(g_HamObjectCaps);
	
	if(get_user_health(id) < 100)
		set_user_health(id, 100);
	
	if(get_user_health(iUser) < 100)
		set_user_health(iUser, 100);
	
	set_user_armor(iUser, 0);
	
	set_user_rendering(id, kRenderFxGlowShell, 0, 0, 255, kRenderNormal, 25);
	set_user_rendering(iUser, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 25);
	
	g_BoxeoCountDown = 6;
	
	set_task(float(g_BoxeoCountDown), "startDuelo", TASK_BOX_COUNTDOWN);
	set_task(1.0, "boxeoCountDown", TASK_BOX_COUNTDOWN);
}

public startDuelo()
{
	g_Duelo = 1;
	colorChat(0, TERRORIST, "%s!t¡FIGHT!!y", JB_PREFIX);
}

public showMenu__Users(const id, const mode)
{
	if(!is_user_connected(id))
		return;
	
	if(!g_Simon[id] && !(get_user_flags(id) & ADMIN_BAN))
	{
		colorChat(id, _, "%sSolo !gSimón!y tiene acceso a este menú.", JB_PREFIX);
		
		showMenu__Game(id);
		return;
	}
	else if(g_MN_Motin)
		return;
	
	g_MenuUsersMode[id] = mode;
	
	new sItem[2];
	new iMenuId;
	new i;
	
	switch(mode)
	{
		case DIA_LIBRE_PERSONAL: {
			iMenuId = menu_create("DÍA LIBRE PERSONAL", "menu__Users");
			
			new sText[32];
			new sBuffer[64];
			
			for(i = 1; i <= g_MaxPlayers; ++i) {
				if(!is_user_connected(i))
					continue;
				
				if(getUserTeam(i) != FM_CS_TEAM_T)
					continue;
				
				if(g_Invis[i])
					continue;
				
				if(g_UserFree[i])
					continue;
				
				if(g_NextRound_UserFree[i])
					continue;
				
				if(is_user_alive(i)) {
					sText[0] = EOS;
				} else {
					formatex(sText, 31, " \r(MUERTO)");
				}
				
				formatex(sBuffer, 63, "%s%s", g_PlayerName[i], sText);
				
				sItem[0] = i;
				sItem[1] = 0;
				
				menu_additem(iMenuId, sBuffer, sItem);
			}
		}
		case BRILLO:
		{
			iMenuId = menu_create("BRILLO", "menu__Users");
			
			new sText[32];
			new sBuffer[64];
			
			for(i = 1; i <= g_MaxPlayers; ++i)
			{
				if(!is_user_alive(i))
					continue;
				
				if(getUserTeam(i) != FM_CS_TEAM_T)
					continue;
				
				if(g_UserFree[i])
					continue;
				
				if(g_Invis[i])
					continue;
				
				if((g_GlowColor[i] <= -1))
					sText[0] = EOS;
				else
					formatex(sText, 31, "\w[\y%s\w]", GLOW_COLORS[g_GlowColor[i]][glowName]);
				
				formatex(sBuffer, 63, "%s %s", g_PlayerName[i], sText);
				
				sItem[0] = i;
				sItem[1] = 0;
				
				menu_additem(iMenuId, sBuffer, sItem);
			}
		}
		case ULTIMA_VOLUNTAD:
		{
			if(g_UltimaVoluntadSpent)
			{
				colorChat(id, _, "%sYa le has otorgado la !gúltima voluntad!y a un prisionero en esta ronda.", JB_PREFIX);
				
				showMenu__Game(id);
				return;
			}
			
			iMenuId = menu_create("ÚLTIMA VOLUNTAD", "menu__Users");
			
			for(i = 1; i <= g_MaxPlayers; ++i)
			{
				if(!is_user_alive(i))
					continue;
				
				if(getUserTeam(i) != FM_CS_TEAM_T)
					continue;
				
				sItem[0] = i;
				sItem[1] = 0;
				
				menu_additem(iMenuId, g_PlayerName[i], sItem);
			}
		}
		case MIC:
		{
			iMenuId = menu_create("HABILITAR MICRÓFONO PARA", "menu__Users");
			
			new sText[32];
			new sBuffer[64];
			
			for(i = 1; i <= g_MaxPlayers; ++i)
			{
				if(!is_user_alive(i))
					continue;
				
				if(getUserTeam(i) != FM_CS_TEAM_T)
					continue;
					
				if(!g_Mic[i])
					sText[0] = EOS;
				else
					formatex(sText, 31, "\w[\yHABILITADO\w]");
				
				formatex(sBuffer, 63, "%s %s", g_PlayerName[i], sText);
				
				sItem[0] = i;
				sItem[1] = 0;
				
				menu_additem(iMenuId, sBuffer, sItem);
			}
		}
	}
	
	if(menu_items(iMenuId) <= 0)
	{
		colorChat(id, _, "%sNo hay usuarios disponibles para mostrar en el menú.", JB_PREFIX);
		
		DestroyLocalMenu(id, iMenuId);
		return;
	}
	
	menu_setprop(iMenuId, MPROP_EXITNAME, "ATRÁS");
	
	g_MenuPage[id][MENU_USERS] = min(g_MenuPage[id][MENU_USERS], menu_pages(iMenuId) - 1);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, 0);
}

public menu__Users(const id, const menuid, const item)
{
	if(!is_user_connected(id))
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(!g_Simon[id] && !(get_user_flags(id) & ADMIN_BAN))
	{
		colorChat(id, _, "%sSolo !gSimón!y tiene acceso a este menú.", JB_PREFIX);
		
		DestroyLocalMenu(id, menuid);
		
		showMenu__Game(id);
		return PLUGIN_HANDLED;
	}
	else if(g_MN_Motin)
	{
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	new iNothing;
	player_menu_info(id, iNothing, iNothing, g_MenuPage[id][MENU_USERS]);
	
	if(item == MENU_EXIT)
	{
		DestroyLocalMenu(id, menuid);
		
		switch(g_MenuUsersMode[id])
		{
			case DIA_LIBRE_PERSONAL: showMenu__DiaLibre(id);
			case BRILLO: showMenu__Brillo(id);
			case ULTIMA_VOLUNTAD: showMenu__Game(id);
		}
		
		return PLUGIN_HANDLED;
	}
	
	new sItem[2];
	new iUser;
	
	menu_item_getinfo(menuid, item, iNothing, sItem, charsmax(sItem), _, _, iNothing);
	iUser = sItem[0];
	
	if(is_user_connected(iUser))
	{
		if(is_user_alive(iUser))
		{
			switch(g_MenuUsersMode[id])
			{
				case DIA_LIBRE_PERSONAL:
				{
					g_UserFree[iUser] = 1;
					
					if(g_Simon[id])
						colorChat(0, TERRORIST, "%sEl !gSimón!y le ha otorgado !gDía Libre!y a !t%s!y.", JB_PREFIX, g_PlayerName[iUser]);
					else
						colorChat(0, TERRORIST, "%sEl administrador !t%s!y le ha otorgado !gDía Libre!y a !t%s!y.", JB_PREFIX, g_PlayerName[id], g_PlayerName[iUser]);
					
					colorChat(iUser, _, "%sTe han otorgado !gDía Libre!y.", JB_PREFIX);
					
					set_user_rendering(iUser, kRenderFxGlowShell, 0, 255, 0, kRenderNormal, 25);
					
					remove_task(TASK_USERFREE);
					set_task(300.0, "removeUserFree", TASK_USERFREE);
				}
				case BRILLO:
				{
					if(!GLOW_COLORS[g_GlowColorSelected[id]][glowColorR] && !GLOW_COLORS[g_GlowColorSelected[id]][glowColorG] && !GLOW_COLORS[g_GlowColorSelected[id]][glowColorB])
					{
						g_GlowColor[iUser] = -1;
						
						colorChat(iUser, _, "%sTe han sacado el brillo que tenías puesto.", JB_PREFIX);
						set_user_rendering(iUser);
					}
					else
					{
						g_GlowColor[iUser] = g_GlowColorSelected[id];
						
						colorChat(iUser, _, "%sTe han marcado con brillo !g%s!y", JB_PREFIX, GLOW_COLORS[g_GlowColorSelected[id]][glowName]);
						set_user_rendering(iUser, kRenderFxGlowShell, GLOW_COLORS[g_GlowColorSelected[id]][glowColorR], GLOW_COLORS[g_GlowColorSelected[id]][glowColorG], GLOW_COLORS[g_GlowColorSelected[id]][glowColorB], kRenderNormal, 25);
					}
				}
				case ULTIMA_VOLUNTAD:
				{
					g_BlockSimon = 1;
					g_UltimaVoluntadSpent = 1;
					
					clcmd_NoSimon(id);
					
					colorChat(0, TERRORIST, "%sEl !gSimón!y le ha otorgado la !gúltima voluntad!y a !t%s!y.", JB_PREFIX, g_PlayerName[iUser]);
					
					remove_task(iUser + TASK_ULTIMA_VOLUNTAD);
					set_task(15.0, "__removeUltimaVoluntad", iUser + TASK_ULTIMA_VOLUNTAD);
					
					g_UltimaVoluntad[iUser] = 1;
					showMenu__UltimaVoluntad(iUser);
					
					DestroyLocalMenu(id, menuid);
					return PLUGIN_HANDLED;
				}
				case MIC:
				{
					colorChat(0, TERRORIST, "%sEl !gSimón!y le ha %shabilitado el micrófono a !t%s!y", JB_PREFIX, (g_Mic[iUser]) ? "des" : "", g_PlayerName[iUser]);
					g_Mic[iUser] = !g_Mic[iUser];
				}
			}
		} else if(g_MenuUsersMode[id] == DIA_LIBRE_PERSONAL) {
			g_NextRound_UserFree[iUser] = 1;
			
			if(g_Simon[id])
				colorChat(0, TERRORIST, "%sEl !gSimón!y le ha otorgado !gDía Libre!y a !t%s!y en la próxima ronda!", JB_PREFIX, g_PlayerName[iUser]);
			else
				colorChat(0, TERRORIST, "%sEl administrador !t%s!y le ha otorgado !gDía Libre!y a !t%s!y en la próxima ronda!", JB_PREFIX, g_PlayerName[id], g_PlayerName[iUser]);
			
			colorChat(iUser, _, "%sTendrás !gDía Libre!y en la próxima ronda!", JB_PREFIX);
		} else {
			colorChat(id, _, "%sEl usuario seleccionado está muerto.", JB_PREFIX);
		}
	}
	else
		colorChat(id, _, "%sEl usuario seleccionado se ha desconectado.", JB_PREFIX);
	
	DestroyLocalMenu(id, menuid);
	
	showMenu__Users(id, g_MenuUsersMode[id]);
	return PLUGIN_HANDLED;
}

public menucmd_TeamSelect(id, key) 
{ 
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	new iTeam;
	iTeam = getUserTeam(id);
	
	switch(key)
	{
		case 1:
		{
			if(g_AccountBan[id])
			{
				client_print(id, print_center, "Tu cuenta está baneada y no podés ser guardia (CT).");
				
				client_cmd(id, "chooseteam");
				return PLUGIN_HANDLED;
			} else if(g_GuardKills[id] < 20) {
				client_print(id, print_center, "Necesitas matar 20+ guardias para ser guardia (CT). Te faltan %d", 20 - g_GuardKills[id]);
				
				client_cmd(id, "chooseteam");
				return PLUGIN_HANDLED;
			}
			
			if(iTeam == FM_CS_TEAM_UNASSIGNED && iTeam != FM_CS_TEAM_CT)
			{
				if(g_ChangeTeam[id] != 2)
				{
					new iUsers = getUsers();
					new iGuards = getGuards();
					
					if((iUsers < 9 && iGuards >= 1) || (iUsers < 13 && iGuards >= 2) || (iUsers < 16 && iGuards >= 3) || (iUsers >= 16 && iGuards >= 4) || (iUsers >= 23 && iGuards >= 5))
					{
						client_print(id, print_center, "Hay demasiados guardias (CTs).");
						
						client_cmd(id, "chooseteam");
						return PLUGIN_HANDLED;
					}
				}
				
				//g_Guard[id] = 1;
			}
		}
		case 4:
		{
			client_print(id, print_center, "Esta opción está bloqueada");
			
			client_cmd(id, "chooseteam");
			return PLUGIN_HANDLED;
		}
		case 5:
		{
			if(!(get_user_flags(id) & ADMIN_KICK))
			{
				client_print(id, print_center, "Solo los administradores pueden ser espectadores");
				
				client_cmd(id, "chooseteam");
				return PLUGIN_HANDLED;
			}
		}
	}
	
	return PLUGIN_CONTINUE;
}

public menucmd_CsBuy(const id, const key)
	return PLUGIN_HANDLED;

public impulse_Flashlight(const id)
{
	if(getUserTeam(id) != FM_CS_TEAM_CT)
		return PLUGIN_HANDLED;
	
	if(!g_MN_Motin && g_Escondidas != 2)
		return PLUGIN_HANDLED;
	
	return PLUGIN_CONTINUE;
}

public modifCommands(const id)
{
	if(!is_user_connected(id))
		return;
	
	client_cmd(id, "cl_minmodels 0");
	
	if((g_MN_Motin && !g_MN_MotinCountDown) || g_Escondidas == 2) {
		set_lights("a");
		
		g_NightVision[id] = 1;
		
		remove_task(id + TASK_NVISION);
		set_task(0.3, "setUserNightvision", id + TASK_NVISION, _, _, "b");
	}
}

public checkAccount(const id)
{
	if(!is_user_connected(id))
		return;
	
	new Handle:sqlQuery;
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT id, password, ip, hid, vinc FROM users WHERE name = ^"%s^";", g_PlayerName[id]);
	
	if(!SQL_Execute(sqlQuery))
		executeQuery(id, sqlQuery, 3);
	else if(SQL_NumResults(sqlQuery)) // Registrado
	{
		new sIP[21];
		new sIPdb[21];
		new sPassword[32];
		
		g_UserId[id] = SQL_ReadResult(sqlQuery, 0);
		// 1 = name
		SQL_ReadResult(sqlQuery, 1, g_AccountPassword[id], 31);
		SQL_ReadResult(sqlQuery, 2, sIPdb, 20);
		SQL_ReadResult(sqlQuery, 3, g_AccountHID[id], 31);
		g_Vinc[id] = SQL_ReadResult(sqlQuery, 4);
		
		if(!g_Vinc[id]) {
			set_task(180.0, "rememberVinc", id);
		}
		
		SQL_FreeHandle(sqlQuery);
		
		sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT start, finish, name_admin, reason, mode FROM bans WHERE (hid = ^"%s^" OR jb_id = '%d') AND mode > '0' ORDER BY mode DESC LIMIT 1;", g_AccountHID[id], g_UserId[id]);
		if(!SQL_Execute(sqlQuery))
			executeQuery(id, sqlQuery, 5);
		else if(SQL_NumResults(sqlQuery)) // Baneado
		{
			SQL_ReadResult(sqlQuery, 0, g_AccountBan_Start[id], 31);
			SQL_ReadResult(sqlQuery, 1, g_AccountBan_Finish[id], 31);
			SQL_ReadResult(sqlQuery, 2, g_AccountBan_Admin[id], 31);
			SQL_ReadResult(sqlQuery, 3, g_AccountBan_Reason[id], 127);
			g_AccountBan[id] = SQL_ReadResult(sqlQuery, 4);
			
			new sDate[16];
			new sTime[16];
			
			new sYear[5];
			new sMonth[3];
			new sDay[3];
			new sHour[3];
			new sMin[3];
			new sSec[3];
			
			new iYear;
			new iMonth;
			new iDay;
			new iHour;
			new iMin;
			new iSec;
			
			new iActualTime;
			new iBannedTo;
			
			iActualTime = arg_time();
			
			parse(g_AccountBan_Finish[id], sDate, charsmax(sDate), sTime, charsmax(sTime));
			
			replace_all(sDate, charsmax(sDate), "-", " ");
			replace_all(sTime, charsmax(sTime), ":", " ");
			
			parse(sDate, sYear, 4, sMonth, 2, sDay, 2);
			parse(sTime, sHour, 2, sMin, 2, sSec, 2);
			
			iYear = str_to_num(sYear);
			iMonth = str_to_num(sMonth);
			iDay = str_to_num(sDay);
			iHour = str_to_num(sHour);
			iMin = str_to_num(sMin);
			iSec = str_to_num(sSec);
			
			iBannedTo = time_to_unix(iYear, iMonth, iDay, iHour, iMin, iSec);
			
			if(iActualTime < iBannedTo && g_AccountBan[id] == 2)
			{
				set_task(2.0, "kickReasonBan", id);
				
				SQL_FreeHandle(sqlQuery);
				
				return;
			}
			else if(iActualTime >= iBannedTo)
			{
				if(g_AccountBan[id] == 2)
					colorChat(0, TERRORIST, "%sEl usuario !t%s!y tenía !gban de cuenta!y pero ya puede volver a jugar.", JB_PREFIX, g_PlayerName[id]);
				else if(g_AccountBan[id] == 1)
					colorChat(0, TERRORIST, "%sEl usuario !t%s!y tenía !gban de guardia!y pero ya puede volver a ser !gguardia!y.", JB_PREFIX, g_PlayerName[id]);
					
				SQL_FreeHandle(sqlQuery);
				
				sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE bans SET mode = '0' WHERE (hid = ^"%s^" OR jb_id = '%d') AND mode = '%d';", g_AccountHID[id], g_UserId[id], g_AccountBan[id]);
				if(!SQL_Execute(sqlQuery))
					executeQuery(id, sqlQuery, 25);
				else
					SQL_FreeHandle(sqlQuery);
			}
			else
				SQL_FreeHandle(sqlQuery);
		}
		else
			SQL_FreeHandle(sqlQuery);
		
		get_user_info(id, "jb1", sPassword, 31);
		get_user_ip(id, sIP, 20, 1);
		
		g_AccountRegister[id] = 1;
		
		if(equal(sIPdb, sIP) && equal(g_AccountPassword[id], sPassword)) // Logeado automáticamente
		{
			g_AccountLogged[id] = 1;
			
			loadInfo(id);
			
			remove_task(id + TASK_SAVE);
			set_task(random_float(300.0, 600.0), "saveTask", id + TASK_SAVE, _, _, "b");
		}
		
		clcmd_ChangeTeam(id);
	}
	else
	{
		SQL_FreeHandle(sqlQuery);
		clcmd_ChangeTeam(id);
	}
}

public loadInfo(const id)
{
	if(!is_user_connected(id))
		return;
	
	if(g_AccountHID[id][0] == '!')
	{
		new OrpheuHook:handlePrintF;
		handlePrintF = OrpheuRegisterHook(OrpheuGetFunction("Con_Printf"), "Con_Printf");
		
		server_cmd("sxe_userhid #%d", get_user_userid(id));
		server_exec();
		
		OrpheuUnregisterHook(handlePrintF);
		
		copy(g_AccountHID[id], 63, g_MessageHID);
		
		replace_all(g_AccountHID[id], 63, "sxei_userhid: ", "");
		replace_all(g_AccountHID[id], 63, "[", "");
		replace_all(g_AccountHID[id], 63, "]", "");
		replace_all(g_AccountHID[id], 63, "^n", "");
		
		if(g_AccountHID[id][0] == '!' || equali(g_AccountHID[id], "no HID present, try again.") || equali(g_AccountHID[id], "") || containi(g_AccountHID[id], " ") != -1)
		{
			server_cmd("kick #%d ^"No se pudo obtener tu HID. Error sXe-I^"", get_user_userid(id));
			return;
		}
	}
	
	new Handle:sqlQuery;
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT ira, mdl_t1, mdl_t2, mdl_ct1, mdl_t, mdl_ct, cagar, mear, kill_ct, kill_sim, rango, mdl_t3, mdl_ct2, ach_count, hatC, costumeC FROM users WHERE id = '%d';", g_UserId[id]);
	
	if(!SQL_Execute(sqlQuery))
		executeQuery(id, sqlQuery, 4);
	else
	{
		g_Ira[id] = SQL_ReadResult(sqlQuery, 0);
		g_ModelPrissoner[id][0] = SQL_ReadResult(sqlQuery, 1);
		g_ModelPrissoner[id][1] = SQL_ReadResult(sqlQuery, 2);
		g_ModelPolice[id][0] = SQL_ReadResult(sqlQuery, 3);
		g_PrissonerModel[id] = SQL_ReadResult(sqlQuery, 4);
		g_PoliceModel[id] = SQL_ReadResult(sqlQuery, 5);
		g_EST_Cagar[id] = SQL_ReadResult(sqlQuery, 6);
		g_EST_Pillar[id] = SQL_ReadResult(sqlQuery, 7);
		g_GuardKills[id] = SQL_ReadResult(sqlQuery, 8);
		g_SimonKills[id] = SQL_ReadResult(sqlQuery, 9);
		g_Rango[id] = SQL_ReadResult(sqlQuery, 10);
		g_ModelPrissoner[id][2] = SQL_ReadResult(sqlQuery, 11);
		g_ModelPolice[id][1] = SQL_ReadResult(sqlQuery, 12);
		g_AchievementCount[id] = SQL_ReadResult(sqlQuery, 13);
		g_Hat_Choosen[id] = SQL_ReadResult(sqlQuery, 14);
		g_Costume_Choosen[id] = SQL_ReadResult(sqlQuery, 15);
		
		g_Hat_NextRound[id] = g_Hat_Choosen[id];
		g_Costume_NextRound[id] = g_Costume_Choosen[id];
		
		SQL_FreeHandle(sqlQuery);
	}
	
	if(g_AchievementCount[id]) {
		sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT achievement_id, achievement_date, hat_id, costume_id FROM jb_achievements WHERE jb_id = '%d';", g_UserId[id]);
		
		if(!SQL_Execute(sqlQuery)) {
			executeQuery(id, sqlQuery, 91364);
		} else if(SQL_NumResults(sqlQuery)) {
			new iAchievement;
			
			while(SQL_MoreResults(sqlQuery)) {
				iAchievement = SQL_ReadResult(sqlQuery, 0);
				
				g_Achievement[id][iAchievement] = 1;
				SQL_ReadResult(sqlQuery, 1, g_AchievementUnlock[id][iAchievement], 31);
				
				g_Hat_Unlock[id][SQL_ReadResult(sqlQuery, 2)] = 1;
				g_Costume_Unlock[id][SQL_ReadResult(sqlQuery, 3)] = 1;
				
				SQL_NextRow(sqlQuery);
			}
			
			SQL_FreeHandle(sqlQuery);
		} else {
			SQL_FreeHandle(sqlQuery);
		}
	}
	
	remove_task(id + TASK_REWARD);
	set_task(10.0, "checkReward", id + TASK_REWARD);
}

public checkReward(const taskid)
{
	new id = ID_REWARD;
	
	if(!is_user_connected(id))
		return;
	
	if(!g_AccountLogged[id])
		return;
	
	new Handle:sqlQuery;
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT ira FROM rewards WHERE jb_id = '%d' AND entregado = '0';", g_UserId[id]);
	
	if(!SQL_Execute(sqlQuery))
		executeQuery(id, sqlQuery, 40);
	else if(SQL_NumResults(sqlQuery))
	{
		new iUsers = 0;
		new iIra = 0;
		
		while(SQL_MoreResults(sqlQuery))
		{
			++iUsers;
			iIra += SQL_ReadResult(sqlQuery, 0);
			
			SQL_NextRow(sqlQuery);
		}
		
		SQL_FreeHandle(sqlQuery);
		
		g_Ira[id] += iIra;
		colorChat(id, TERRORIST, "%sGracias por denunciar a !g%d!y usuario%s, has ganado !t%d Ira!y", JB_PREFIX, iUsers, (iUsers == 1) ? "" : "s", iIra);
		
		sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE rewards SET entregado = '1' WHERE jb_id = '%d';", g_UserId[id]);
		if(!SQL_Execute(sqlQuery))
			executeQuery(id, sqlQuery, 41);
		else
			SQL_FreeHandle(sqlQuery);
		
		saveInfo(id);
	}
	else
		SQL_FreeHandle(sqlQuery);
	
	
	if(g_Vinc[id]) {
		setAchievement(id, VINCULADO);
	}
	
	if(g_SimonKills[id] >= 50) {
		setAchievement(id, FUERZA_INDOMABLE);
	}
	
	if(g_GuardKills[id] >= 50) {
		setAchievement(id, ASESINO);
	}
	
	if(g_Ira[id] >= 10000) {
		setAchievement(id, BANCO_DE_GUERRA);
	}
	
	if(get_user_flags(id) & ADMIN_RESERVATION) {
		setAchievement(id, SOY_DORADO);
	}
}

public saveInfo(const id)
{
	if(!is_user_connected(id))
		return;
	
	if(!g_AccountLogged[id])
		return;
	
	new sIP[21];
	get_user_ip(id, sIP, 20, 1);
	
	new iV[10];
	iV[0] = g_ModelPrissoner[id][0];
	iV[1] = g_ModelPrissoner[id][1];
	iV[2] = g_ModelPolice[id][0];
	iV[3] = g_PrissonerModel[id];
	iV[4] = g_PoliceModel[id];
	iV[5] = g_EST_Cagar[id];
	iV[6] = g_EST_Pillar[id];
	iV[7] = g_GuardKills[id];
	iV[8] = g_SimonKills[id];
	iV[9] = g_Rango[id];
	
	new Handle:sqlQuery;
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE users SET ip=^"%s^", ira='%d', mdl_t1='%d', mdl_t2='%d',  mdl_ct1='%d', mdl_t='%d', mdl_ct='%d', cagar='%d', mear='%d',\
	kill_ct='%d', kill_sim='%d', rango='%d', mdl_t3='%d', mdl_ct2='%d', ach_count='%d', hatC='%d', costumeC='%d' WHERE id = '%d';", sIP, g_Ira[id], iV[0], iV[1], iV[2], iV[3], iV[4],
	iV[5], iV[6], iV[7], iV[8], iV[9], g_ModelPrissoner[id][2], g_ModelPolice[id][1], g_AchievementCount[id], g_Hat_Choosen[id], g_Costume_Choosen[id], g_UserId[id]);
	
	if(!SQL_Execute(sqlQuery))
		executeQuery(id, sqlQuery, 5);
	else
		SQL_FreeHandle(sqlQuery);
}

public saveTask(const taskid)
{
	if(!is_user_connected(ID_SAVE))
		return;
	
	saveInfo(ID_SAVE);
}

public resetVars(const id)
{
	remove_task(id + TASK_NVISION);
	
	g_Simon[id] = 0;
	g_UserFree[id] = 0;
	g_GlowColor[id] = -1;
	g_UltimaVoluntad[id] = 0;
	g_InDuelo[id] = 0;
	g_FreeDayNextRound[id] = 0;
	g_NightVision[id] = 0;
	g_EST_CagarDone[id] = 0.0;
	g_EST_PillarDone[id] = 0.0;
	g_SimonDone[id] = 0.0;
	//g_BlockPickup[id] = 0;
	g_Invis[id] = 0;
	g_Mic[id] = 0;
	g_Achievement_Rebel[id] = 0;
	g_WhoIsT[id] = 0;
	g_WhoIsCT[id] = 0;
	g_IsMancha[id] = 0;
}

public kickReasonBan(const id)
{
	if(is_user_connected(id))
	{
		console_print(id, "");
		console_print(id, "");
		console_print(id, "****** GAM!NGA ******");
		console_print(id, "");
		console_print(id, "TU CUENTA ESTA BANEADA");
		console_print(id, "");
		console_print(id, "Administrador que te baneo: %s", g_AccountBan_Admin[id]);
		console_print(id, "Razón: %s", g_AccountBan_Reason[id]);
		console_print(id, "El ban fue realizado en la fecha: %s", g_AccountBan_Start[id]);
		console_print(id, "El ban expira en la fecha: %s", g_AccountBan_Finish[id]);
		console_print(id, "Cuenta #%d", g_UserId[id]);
		console_print(id, "");
		console_print(id, "****** GAM!NGA ******");
		console_print(id, "");
		console_print(id, "");
		
		set_task(1.0, "kickUser", id);
	}
}

public kickUser(const id)
{
	if(is_user_connected(id))
		server_cmd("kick #%d ^"Tu cuenta está baneada! - Mira tu consola^"", get_user_userid(id));	
}

public startMotin()
{
	g_MN_MotinCountDown = 0;
	
	client_cmd(0, "spk ^"%s^"", SOUND_LIGHTS_OFF);
	
	set_cvar_num("mp_flashlight", 1);
	
	colorChat(0, TERRORIST, "%s!t¡MOTÍN!!y", JB_PREFIX);
	
	set_lights("a");
	
	new i;
	for(i = 1; i <= g_MaxPlayers; ++i)
	{
		if(!is_user_alive(i))
			continue;
		
		if(getUserTeam(i) != FM_CS_TEAM_T)
		{
			if(g_Simon[i])
				clcmd_NoSimon(i);
			
			continue;
		}
		
		set_user_rendering(i);
		
		g_BarraMetalica[i] = 1;
		g_BarraMetalicaDay[i] = 1;
		
		give_item(i, "weapon_knife");
		give_item(i, "weapon_deagle");
		
		g_NightVision[i] = 1;
		set_task(0.3, "setUserNightvision", i + TASK_NVISION, _, _, "b");
		
		cs_set_user_bpammo(i, CSW_DEAGLE, 0);
		cs_set_weapon_ammo(fm_find_ent_by_owner(-1, "weapon_deagle", i), 2);
	}
	
	openJails();
}

public motinCountDown()
{
	--g_MN_MotinCountDown;
	
	if(g_MN_MotinCountDown <= 0)
		return;
	
	new i;
	for(i = 1; i <= g_MaxPlayers; ++i)
	{
		if(!is_user_alive(i))
			continue;
		
		if(getUserTeam(i) != FM_CS_TEAM_T)
			continue;
		
		colorChat(i, _, "%s!g%d...!y", JB_PREFIX, g_MN_MotinCountDown);
	}
	
	set_task(1.0, "motinCountDown", TASK_BOX_COUNTDOWN);
}

public setUserNightvision(const taskid)
{
	static vecOrigin[3];
	get_user_origin(ID_NVISION, vecOrigin);
	
	message_begin(MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, _, ID_NVISION);
	write_byte(TE_DLIGHT);
	write_coord(vecOrigin[0]);
	write_coord(vecOrigin[1]);
	write_coord(vecOrigin[2]);
	write_byte(70);
	write_byte(255);
	write_byte(255);
	write_byte(255);
	write_byte(7);
	write_byte(7);
	message_end();
}

public makePiss(const taskid) 
{
	new vecOrigin[3];
	new vecAim[3];
	new vecVelocity[3];
	new iLenght;
	new iDistance;
	new iSpeed;
	
	get_user_origin(ID_PISS, vecOrigin);
	get_user_origin(ID_PISS, vecAim, 3);
	
	iDistance = get_distance(vecOrigin, vecAim);
	iSpeed = floatround(iDistance * 1.9);
	
	vecVelocity[0] = vecAim[0] - vecOrigin[0];
	vecVelocity[1] = vecAim[1] - vecOrigin[1];
	vecVelocity[2] = vecAim[2] - vecOrigin[2];
	
	iLenght = squareRoot((vecVelocity[0] * vecVelocity[0]) + (vecVelocity[1] * vecVelocity[1]) + (vecVelocity[2] * vecVelocity[2]));
	
	if(iLenght != 0) {
		vecVelocity[0] = (vecVelocity[0] * iSpeed) / iLenght;
		vecVelocity[1] = (vecVelocity[1] * iSpeed) / iLenght;
		vecVelocity[2] = (vecVelocity[2] * iSpeed) / iLenght;
	} else {
		vecVelocity[0] = vecVelocity[0] * iSpeed;
		vecVelocity[1] = vecVelocity[1] * iSpeed;
		vecVelocity[2] = vecVelocity[2] * iSpeed;
	}
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_BLOODSTREAM);
	write_coord(vecOrigin[0]);
	write_coord(vecOrigin[1]);
	write_coord(vecOrigin[2]);
	write_coord(vecVelocity[0]);
	write_coord(vecVelocity[1]);
	write_coord(vecVelocity[2]);
	write_byte(102);
	write_byte(random_num(200, 250));
	message_end();
}

public squareRoot(const num)
{ 
	new iDiv = num;
	new iResult = 1;
	
	while(iDiv > iResult)
	{
		iDiv = (iDiv + iResult) / 2;
		iResult = num / iDiv;
	}
	
	return iDiv;
} 

/*public placePuddle(taskid)
{
	new vecAim[3];
	new Float:vecAimOrigin[3];
	new Float:vecOrigin[3];
	new iCloseEnough = 0;
	new Float:fDistance;
	
	entity_get_vector(ID_PISS, EV_VEC_origin, vecOrigin);
	get_user_origin(ID_PISS, vecAim, 3);
	
	vecAimOrigin[0] = float(vecAim[0]);
	vecAimOrigin[1] = float(vecAim[1]);
	vecAimOrigin[2] = float(vecAim[2]);
	
	fDistance = get_distance_f(vecOrigin, vecAimOrigin);
	if(fDistance > 200.0)
		return;
	
	if(g_PissPuddleCount[ID_PISS] > 1)
	{
		fDistance = get_distance_f(g_AimLastPiss[ID_PISS], vecAimOrigin);
		
		if(fDistance < 80.0)
			iCloseEnough = 1;
	}
	else
	{
		g_AimLastPiss[ID_PISS][0] = vecAimOrigin[0];
		g_AimLastPiss[ID_PISS][1] = vecAimOrigin[1];
		g_AimLastPiss[ID_PISS][2] = vecAimOrigin[2];
	}
	
	new iEnt;
	iEnt = create_entity("info_target");
	
	if(is_valid_ent(iEnt))
	{
		new Float:vecMin[3];
		new Float:vecMax[3];

		vecMin[0] = -1.0;
		vecMin[1] = -1.0;
		vecMin[2] = -1.0;
		
		vecMax[0] = 1.0;
		vecMax[1] = 1.0;
		vecMax[2] = 1.0;
		
		entity_set_vector(iEnt, EV_VEC_mins, vecMin);
		entity_set_vector(iEnt, EV_VEC_maxs, vecMax);
		
		if(iCloseEnough)
		{
			new sText[20];
			formatex(sText, 19, "entPissPuddle_0%d", g_PissPuddleCount[ID_PISS]);
			
			entity_set_string(iEnt, EV_SZ_classname, sText);
			entity_set_model(iEnt, MODELO_PISS[g_PissPuddleCount[ID_PISS]+1]);
		}
		else
		{
			entity_set_string(iEnt, EV_SZ_classname, "entPissPuddle_01");
			entity_set_model(iEnt, MODELO_PISS[1]);
		}
		
		entity_set_origin(iEnt, vecAimOrigin);
		entity_set_int(iEnt, EV_INT_solid, SOLID_SLIDEBOX);
		entity_set_int(iEnt, EV_INT_movetype, MOVETYPE_TOSS);
		entity_set_edict(iEnt, EV_ENT_owner, ID_PISS);
		
		++g_PissPuddleCount[ID_PISS];
	}
}*/

public think__HUD(const ent)
{
	static iUser;
	static id;
	
	for(id = 1; id <= g_MaxPlayers; ++id)
	{
		if(!is_user_connected(id))
			continue;
		
		iUser = id;
		
		if(!is_user_alive(id))
		{
			iUser = entity_get_int(id, EV_INT_iuser2);
			
			if(!is_user_alive(iUser))
			{
				set_hudmessage(0, 255, 0, -1.0, 0.15, 0, 6.0, 1.51, 0.0, 0.0, -1);
				ShowSyncHudMsg(id, g_HudGeneral, "%s %d de %s de %d^nSimón: %s^nPrisioneros vivos: %d", NAME_DAYS[g_Day], g_DayTotal, MONTH_NAME_DAYS[g_Month], g_Year, g_PlayerName[g_SimonId], g_PrissonersAlive);
				
				continue;
			}
		}
		
		if(id == iUser)
		{
			set_hudmessage(0, 255, 0, -1.0, 0.02, 0, 6.0, 1.51, 0.0, 0.0, -1);
			ShowSyncHudMsg(id, g_HudGeneral, "%s %d de %s de %d^nIra: %d - Simón: %s^nPrisioneros vivos: %d", NAME_DAYS[g_Day], g_DayTotal, MONTH_NAME_DAYS[g_Month], g_Year, g_Ira[id], g_PlayerName[g_SimonId], g_PrissonersAlive);
		}
		else
		{
			set_hudmessage(0, 255, 0, -1.0, 0.15, 0, 6.0, 1.51, 0.0, 0.0, -1);
			ShowSyncHudMsg(id, g_HudGeneral, "%s %d de %s de %d^nIra: %d - Simón: %s^nPrisioneros vivos: %d", NAME_DAYS[g_Day], g_DayTotal, MONTH_NAME_DAYS[g_Month], g_Year, g_Ira[iUser], g_PlayerName[g_SimonId], g_PrissonersAlive);
		}
	}
	
	entity_set_float(ent, EV_FL_nextthink, NEXTTHINK_THINK_HUD);
}

public freeDayGeneral()
{
	if(g_FreeDay)
		return;
	
	g_FreeDay = 1;
	
	new i;
	for(i = 1; i <= g_MaxPlayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		if(!is_user_alive(i))
			continue;
		
		if(getUserTeam(i) != FM_CS_TEAM_T)
			continue;
		
		set_user_rendering(i, kRenderFxGlowShell, 0, 255, 0, kRenderNormal, 25);
	}
	
	set_task(18.0, "openJails__Fix");
}

public freeDayGeneral__NoSimon()
{
	if(g_FreeDay || g_MN_Motin || g_Escondidas || g_Mancha)
		return;
	
	colorChat(0, TERRORIST, "%sNadie se hizo !gSimón!y durante !t30 segundos!y. Día libre general!", JB_PREFIX);
	
	g_FreeDay = 1;
	
	new i;
	for(i = 1; i <= g_MaxPlayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		if(!is_user_alive(i))
			continue;
		
		if(getUserTeam(i) != FM_CS_TEAM_T)
			continue;
		
		set_user_rendering(i, kRenderFxGlowShell, 0, 255, 0, kRenderNormal, 25);
	}
	
	openJails__Fix();
}

public openJails__Fix()
	openJails();

public removeUserFree()
{
	set_hudmessage(255, 255, 0, -1.0, 0.23, 0, 13.0, 13.0, 1.0, 1.0, -1);
	ShowSyncHudMsg(0, g_HudNotifSec, "El día libre ha finalizado^nSimón decide si hay que matarlo/s o que jueguen");
}

public saveButtons()
{
	new iEnt[3];
	new Float:vecOrigin[3];
	new sInfo[32];
	new iPos;
	
	while((iPos <= sizeof(g_Buttons)) && (iEnt[0] = engfunc(EngFunc_FindEntityByString, iEnt[0], "classname", "info_player_deathmatch")))
	{
		entity_get_vector(iEnt[0], EV_VEC_origin, vecOrigin);
		
		while((iEnt[1] = engfunc(EngFunc_FindEntityInSphere, iEnt[1], vecOrigin, 200.0)))
		{
			if(!is_valid_ent(iEnt[1]))
				continue;
			
			entity_get_string(iEnt[1], EV_SZ_classname, sInfo, charsmax(sInfo));
			
			if(!equal(sInfo, "func_door"))
				continue;
			
			entity_get_string(iEnt[1], EV_SZ_targetname, sInfo, charsmax(sInfo));
			
			if(!sInfo[0])
				continue;
			
			if(TrieKeyExists(g_CellsManager, sInfo))
				TrieGetCell(g_CellsManager, sInfo, iEnt[2]);
			else
				iEnt[2] = engfunc(EngFunc_FindEntityByString, 0, "target", sInfo);
			
			if(is_valid_ent(iEnt[2]) && (inArray(iEnt[2], g_Buttons, sizeof(g_Buttons)) < 0))
			{
				g_Buttons[iPos] = iEnt[2];
				
				++iPos;
				break;
			}
		}
	}
	
	TrieDestroy(g_CellsManager);
}

public createArc(const id, const Float:vecOrigin1[3], const Float:vecOrigin2[3])
{
	new iEnt;
	new Float:vecCenter[3];
	new Float:vecSize[3];
	new Float:vecMins[3];
	new Float:vecMaxs[3];
	
	for(new i = 0; i < 3; ++i)
	{
		vecCenter[i] = (vecOrigin1[i] + vecOrigin2[i]) / 2.0;
		
		vecSize[i] = getFloatDistance(vecOrigin1[i], vecOrigin2[i]);
		
		vecMins[i] = vecSize[i] / -2.0;
		vecMaxs[i] = vecSize[i] / 2.0;
    }
	
	iEnt = create_entity("info_target");
	
	if(is_valid_ent(iEnt))
	{
		if(id > 0)
			colorChat(id, _, "%sArco creado exitosamente!", JB_PREFIX);
		
		entity_set_origin(iEnt, vecCenter);
		
		entity_set_string(iEnt, EV_SZ_classname, "entArc");
		
		dllfunc(DLLFunc_Spawn, iEnt);
		
		entity_set_int(iEnt, EV_INT_movetype, MOVETYPE_FLY);
		entity_set_int(iEnt, EV_INT_solid, SOLID_TRIGGER);
		
		entity_set_size(iEnt, vecMins, vecMaxs);
	}
}

setUserMaxspeed(const id)
{
	if(!is_user_alive(id))
		return;
	
	if(g_FreezeTime)
	{
		set_user_maxspeed(id, 1.0);
		return;
	}
	
	if(g_Escondidas || g_Mancha)
	{
		if(g_Mancha) {
			if(g_IsMancha[id]) {
				set_user_maxspeed(id, 245.0);
			} else if(g_Mancha == 2) {
				set_user_maxspeed(id, 1.0);
			}
		} else {
			if(g_Escondidas == 2) {
				if(getUserTeam(id) == FM_CS_TEAM_T) {
					set_user_maxspeed(id, 1.0);
				}
			} else if(getUserTeam(id) == FM_CS_TEAM_CT) {
				set_user_maxspeed(id, 1.0);
			}
		}
	}
	else if(g_KillGuards && getUserTeam(id) == FM_CS_TEAM_CT)
		set_user_maxspeed(id, 1.0);
	else
		set_user_maxspeed(id, 240.0);
}

public loadCTSpawns() {
	new Float:vecOrigin[3];
	new iEnt;
	iEnt = -1;
	
	while((iEnt = engfunc(EngFunc_FindEntityByString, iEnt, "classname", "info_player_start")) != 0) {
		entity_get_vector(iEnt, EV_VEC_origin, vecOrigin);
		
		g_SpawnsCT[g_SpawnCount][0] = vecOrigin[0];
		g_SpawnsCT[g_SpawnCount][1] = vecOrigin[1];
		g_SpawnsCT[g_SpawnCount][2] = vecOrigin[2];
		
		++g_SpawnCount;
		
		if(g_SpawnCount >= 128)
			break;
	}
}

public __removeUltimaVoluntad(const taskid) {
	g_UltimaVoluntad[ID_ULTIMA_VOLUNTAD] = 0;
	g_UltimaVoluntadSpent = 1;
	
	colorChat(0, _, "%sEl prisionero ha demorado demasiado en elegir su última voluntad!", JB_PREFIX);
	
	user_silentkill(ID_ULTIMA_VOLUNTAD);
}

public rememberVinc(const id) {
	if(is_user_connected(id) && !g_Vinc[id]) {
		colorChat(id, _, "%sTu cuenta no está vinculada al foro, recordá vincularla lo más pronto posible.", JB_PREFIX);
		colorChat(id, _, "%sVincular tu cuenta ofrece varias opciones/funciones, entre ellas, recuperar/cambiar tu contraseña!", JB_PREFIX);
		
		set_task(180.0, "rememberVinc", id);
	}
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
		sAudio[16] == 'E') {
			return PLUGIN_HANDLED;
	}
	
	return PLUGIN_CONTINUE;
}

public resetBlackMarket() {
	g_MN_Use = 0;
	
	new i;
	for(i = 1; i <= g_MaxPlayers; ++i) {
		if(!is_user_connected(i)) {
			continue;
		}
		
		if(getUserTeam(i) != FM_CS_TEAM_T) {
			continue;
		}
		
		colorChat(i, TERRORIST, "%s!t[PRISIONEROS]!y Psst! Ya podés volver a comprar un ítem en el !gmercado negro!y", JB_PREFIX);
	}
}

public showMenu__Achievements(const id) {
	new sItem[64];
	new sPosition[4];
	new iMenuId;
	new i;
	
	iMenuId = menu_create("LOGROS", "menu__Achievements");
	
	for(i = 0; i < LogrosInt; ++i) {
		num_to_str((i + 1), sPosition, 3);
		
		formatex(sItem, charsmax(sItem), "%s%s", (!g_Achievement[id][i]) ? "\d" : "\w", LOGROS[i][logroName]);
		menu_additem(iMenuId, sItem, sPosition);
	}
	
	menu_setprop(iMenuId, MPROP_BACKNAME, "ATRÁS");
	menu_setprop(iMenuId, MPROP_NEXTNAME, "SIGUIENTE");
	menu_setprop(iMenuId, MPROP_EXITNAME, "VOLVER");
	
	g_AchievementMenuPage[id] = min(g_AchievementMenuPage[id], menu_pages(iMenuId) - 1);
	
	ShowLocalMenu(id, iMenuId, g_AchievementMenuPage[id]);
}

public menu__Achievements(const id, const menuId, const item) {
	if(!is_user_connected(id)) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	new iNothing;
	player_menu_info(id, iNothing, iNothing, g_AchievementMenuPage[id]);
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		
		showMenu__Game(id);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[4];
	menu_item_getinfo(menuId, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	
	DestroyLocalMenu(id, menuId);
	
	showMenu__AchievementDesc(id, (str_to_num(sBuffer) - 1));
	return PLUGIN_HANDLED;
}

public showMenu__AchievementDesc(const id, const achievementId) {
	new sItem[320];
	new sAchievementUnlock[60];
	new sUsersNeed[52];
	new iMenuId;
	new sReward[96];
	new iHat = LOGROS[achievementId][logroHat];
	new iCostume = LOGROS[achievementId][logroCostume];
	
	if(g_Achievement[id][achievementId]) {
		formatex(sAchievementUnlock, 59, "^n^n\wLOGRO DESBLOQUEADO EL^n\y%s", g_AchievementUnlock[id][achievementId]);
	}
	
	if(LOGROS[achievementId][logroUsersNeed]) {
		formatex(sUsersNeed, 51, "\rREQUISITOS EXTRAS:\w %d usuarios conectados^n", LOGROS[achievementId][logroUsersNeed]);
    }
	
	if(iHat || iCostume) {
		if(iHat) {
			formatex(sReward, 95, "^n\yRECOMPENSA:^n\r    - \yGORRO\w %s", HATS[iHat][hatName]);
		} else {
			formatex(sReward, 95, "^n\yRECOMPENSA:^n\r    - \yCONJUNTO\w %s", COSTUMES[iCostume][costumeName]);
		}
	} else {
		sReward[0] = EOS;
	}
	
	formatex(sItem, charsmax(sItem), "%s %s^n^n\yDESCRIPCIÓN:^n\w%s^n%s%s", LOGROS[achievementId][logroName], (!g_Achievement[id][achievementId]) ? "\r(BLOQUEADO)" : "\y(DESBLOQUEADO)", LOGROS[achievementId][logroDesc],
	(!LOGROS[achievementId][logroUsersNeed]) ? "" : sUsersNeed, sReward);
	
	iMenuId = menu_create(sItem, "menu__AchievementDesc");
	
	if(g_Achievement[id][achievementId]) {
		menu_additem(iMenuId, "MOSTRAR EN EL CHAT", "1");
		menu_addtext(iMenuId, sAchievementUnlock, 1);
	} else {
		menu_additem(iMenuId, "\dMOSTRAR EN EL CHAT", "1");
	}
	
	menu_setprop(iMenuId, MPROP_EXITNAME, "VOLVER");
	
	g_AchievementInId[id] = achievementId;
	
	ShowLocalMenu(id, iMenuId);
}

public menu__AchievementDesc(const id, const menuId, const item) {
	if(!is_user_connected(id)) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		
		showMenu__Achievements(id);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[4];
	new iNothing;
	new iItemId;
	
	menu_item_getinfo(menuId, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	DestroyLocalMenu(id, menuId);
	
	iItemId = str_to_num(sBuffer);
	
	if(iItemId == 1 && g_Achievement[id][g_AchievementInId[id]]) {
		if(g_AchievementLink[id] > get_gametime()) {
			showMenu__AchievementDesc(id, g_AchievementInId[id]);
			return PLUGIN_HANDLED;
		}
		
		g_AchievementLink[id] = get_gametime() + 15.0;
		colorChat(0, CT, "%s!t%s!y está mostrando que ganó el logro !g%s!y el !t%s!y", JB_PREFIX, g_PlayerName[id], LOGROS[g_AchievementInId[id]][logroName], g_AchievementUnlock[id][g_AchievementInId[id]]);
	}
	
	showMenu__AchievementDesc(id, g_AchievementInId[id]);
	return PLUGIN_HANDLED;
}

setAchievement(const id, const achievement) { // s_ach
	if(g_Achievement[id][achievement]) {
		return;
	}
	
	if(LOGROS[achievement][logroUsersNeed]) {
		if(getUserPlaying() < LOGROS[achievement][logroUsersNeed]) {
			return;
		}
	}
	
	g_Achievement[id][achievement] = 1;
	
	new sTime[32];
	
	get_time("%d/%m/%Y - %H:%M", sTime, 31);
	formatex(g_AchievementUnlock[id][achievement], 31, sTime);
	
	new Handle:sqlQuery;
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "INSERT INTO jb_achievements (`jb_id`, `username`, `achievement_id`, `achievement_name`, `achievement_date`, `hat_id`, `costume_id`) VALUES ('%d', ^"%s^", '%d', ^"%s^", ^"%s^", '%d', '%d');", g_UserId[id], g_PlayerName[id], achievement,
	LOGROS[achievement][logroName], g_AchievementUnlock[id][achievement], LOGROS[achievement][logroHat], LOGROS[achievement][logroCostume]);
	
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(id, sqlQuery, 32174);
	} else {
		SQL_FreeHandle(sqlQuery);
	}
	
	colorChat(0, CT, "%s!t%s!y ganó el logro !g%s!y", JB_PREFIX, g_PlayerName[id], LOGROS[achievement][logroName]);
	
	if(LOGROS[achievement][logroHat] || LOGROS[achievement][logroCostume]) {
		if(LOGROS[achievement][logroHat]) {
			g_Hat_Unlock[id][LOGROS[achievement][logroHat]] = 1;
			
			colorChat(id, _, "%sHas desbloqueado el gorro: !g%s!y", JB_PREFIX, LOGROS[achievement][logroHat]);
		} else {
			g_Costume_Unlock[id][LOGROS[achievement][logroCostume]] = 1;
			
			colorChat(id, _, "%sHas desbloqueado el conjunto: !g%s!y", JB_PREFIX, LOGROS[achievement][logroCostume]);
		}
	}
	
	++g_AchievementCount[id];
	
	saveInfo(id);
}

public showMenu__HatsCostumes(const id) {
	new iMenuId;
	iMenuId = menu_create("GORROS Y CONJUNTOS", "menu__HatsCostumes");
	
	menu_additem(iMenuId, "GORROS", "1");
	menu_additem(iMenuId, "CONJUNTOS^n^n\rTEMPORALMENTE DESHABILITADOS", "2");
	
	menu_setprop(iMenuId, MPROP_EXITNAME, "VOLVER");
	
	ShowLocalMenu(id, iMenuId);
}

public menu__HatsCostumes(const id, const menuId, const item) {
	if(!is_user_connected(id)) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		
		showMenu__Game(id);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[4];
	new iNothing;
	
	menu_item_getinfo(menuId, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	
	DestroyLocalMenu(id, menuId);
	
	iNothing = str_to_num(sBuffer);
	
	switch(iNothing) {
		case 1: showMenu__Hats(id);
		case 2: showMenu__Costumes(id);
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__Hats(const id) {
	new sItem[64];
	new sPosition[3];
	new iMenuId;
	new i;
	
	iMenuId = menu_create("GORROS", "menu__Hats");
	
	for(i = 0; i < HatsInt; ++i) {
		num_to_str((i + 1), sPosition, 2);
		
		formatex(sItem, charsmax(sItem), "%s%s", (!g_Hat_Unlock[id][i]) ? "\d" : "\w", HATS[i][hatName]);
		menu_additem(iMenuId, sItem, sPosition);
	}
	
	menu_setprop(iMenuId, MPROP_BACKNAME, "ATRÁS");
	menu_setprop(iMenuId, MPROP_NEXTNAME, "SIGUIENTE");
	menu_setprop(iMenuId, MPROP_EXITNAME, "VOLVER");
	
	g_Hat_MenuPage[id] = min(g_Hat_MenuPage[id], menu_pages(iMenuId) - 1);
	
	ShowLocalMenu(id, iMenuId, g_Hat_MenuPage[id]);
}

public menu__Hats(const id, const menuId, const item) {
	if(!is_user_connected(id)) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	new iNothing;
	player_menu_info(id, iNothing, iNothing, g_Hat_MenuPage[id]);
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		
		showMenu__HatsCostumes(id);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[4];
	menu_item_getinfo(menuId, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	
	DestroyLocalMenu(id, menuId);
	
	iNothing = str_to_num(sBuffer) - 1;
	
	if(iNothing == 0) {
		#if defined HATS_DEBUG
			log_to_file("hats_debug.txt", "menu__Hats() - 1");
		#endif
		if(is_valid_ent(g_Hat[id])) {
			#if defined HATS_DEBUG
				log_to_file("hats_debug.txt", "menu__Hats() - 2");
			#endif
			remove_entity(g_Hat[id]);
			
			#if defined HATS_DEBUG
				log_to_file("hats_debug.txt", "menu__Hats() - 3");
			#endif
			
			g_Hat_NextRound[id] = 0;
			g_Hat_Choosen[id] = 0;
			
			colorChat(id, _, "%sSe ha quitado el gorro que tenías", JB_PREFIX);
		} else {
			colorChat(id, _, "%sNo tenés ningún gorro", JB_PREFIX);
		}
	} else {
		if(g_Hat_Unlock[id][iNothing]) {
			g_Hat_NextRound[id] = iNothing;
			g_Hat_Choosen[id] = g_Hat_NextRound[id];
			
			g_Costume_NextRound[id] = 0;
			g_Costume_Choosen[id] = 0;
			
			colorChat(id, _, "%sEn la próxima ronda, tu gorro será !g%s!y. Si tenés un conjunto, se reemplazara por el gorro", JB_PREFIX, HATS[iNothing][hatName]);
		} else {
			colorChat(id, _, "%sNo podés elegir un gorro que no posees", JB_PREFIX);
			
			showMenu__Hats(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

public setHat(const id, const idHat) {
	if(!is_user_connected(id)) {
		return;
	}
	
	#if defined HATS_DEBUG
		log_to_file("hats_debug.txt", "setHat() - 1");
	#endif
	
	if(is_valid_ent(g_Hat[id])) {
		#if defined HATS_DEBUG
			log_to_file("hats_debug.txt", "setHat() - 2");
		#endif
		remove_entity(g_Hat[id]);
		#if defined HATS_DEBUG
			log_to_file("hats_debug.txt", "setHat() - 3");
		#endif
	}
	
	if(idHat == 0) {
		#if defined HATS_DEBUG
			log_to_file("hats_debug.txt", "setHat() - RETURN");
		#endif
		return;
	}
	
	#if defined HATS_DEBUG
		log_to_file("hats_debug.txt", "setHat() - 4");
	#endif
	if(!is_valid_ent(g_Hat[id])) {
		#if defined HATS_DEBUG
			log_to_file("hats_debug.txt", "setHat() - 5");
		#endif
		
		g_Hat_NextRound[id] = HAT_NONE;
		
		if(g_Costume[id]) {
			g_Costume[id] = 0;
			
			new i;
			for(i = 0; i < 4; ++i) {
				if(is_valid_ent(g_Costume_Parts[id][i])) {
					remove_entity(g_Costume_Parts[id][i]);
				}
			}
		}
		
		#if defined HATS_DEBUG
			log_to_file("hats_debug.txt", "setHat() - 6");
		#endif
		
		g_Hat[id] = create_entity("info_target");
		
		entity_set_string(g_Hat[id], EV_SZ_classname, "jbHat");
		entity_set_int(g_Hat[id], EV_INT_solid, SOLID_NOT);
		entity_set_int(g_Hat[id], EV_INT_movetype, MOVETYPE_FOLLOW);
		entity_set_edict(g_Hat[id], EV_ENT_aiment, id);
		entity_set_edict(g_Hat[id], EV_ENT_owner, id);
		
		new sModel[64];
		formatex(sModel, 63, "models/jb_hats/%s.mdl", HATS[idHat][hatModel]);
		
		entity_set_model(g_Hat[id], sModel);
		
		#if defined HATS_DEBUG
			log_to_file("hats_debug.txt", "setHat() - 7");
		#endif
	}
}

public showMenu__Costumes(const id) {
	new sItem[64];
	new sPosition[3];
	new iMenuId;
	new i;
	
	iMenuId = menu_create("CONJUNTOS", "menu__Costumes");
	
	for(i = 0; i < CostumesInt; ++i) {
		num_to_str((i + 1), sPosition, 2);
		
		formatex(sItem, charsmax(sItem), "%s%s", (!g_Costume_Unlock[id][i]) ? "\d" : "\w", COSTUMES[i][costumeName]);
		menu_additem(iMenuId, sItem, sPosition);
	}
	
	menu_setprop(iMenuId, MPROP_BACKNAME, "ATRÁS");
	menu_setprop(iMenuId, MPROP_NEXTNAME, "SIGUIENTE");
	menu_setprop(iMenuId, MPROP_EXITNAME, "VOLVER");
	
	g_Costume_MenuPage[id] = min(g_Costume_MenuPage[id], menu_pages(iMenuId) - 1);
	
	ShowLocalMenu(id, iMenuId, g_Costume_MenuPage[id]);
}

public menu__Costumes(const id, const menuId, const item) {
	if(!is_user_connected(id)) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	new iNothing;
	player_menu_info(id, iNothing, iNothing, g_Costume_MenuPage[id]);
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		
		showMenu__HatsCostumes(id);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[4];
	menu_item_getinfo(menuId, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	
	DestroyLocalMenu(id, menuId);
	
	iNothing = str_to_num(sBuffer) - 1;
	
	if(iNothing == 0) {
		if(g_Costume[id]) {
			new i;
			for(i = 0; i < 4; ++i) {
				if(is_valid_ent(g_Costume_Parts[id][i])) {
					remove_entity(g_Costume_Parts[id][i]);
				}
			}
			
			g_Costume_NextRound[id] = 0;
			g_Costume_Choosen[id] = 0;
			
			colorChat(id, _, "%sSe ha quitado el conjunto que tenías", JB_PREFIX);
		} else {
			colorChat(id, _, "%sNo tenés ningún conjunto", JB_PREFIX);
		}
	} else {
			if(g_Costume_Unlock[id][iNothing]) {
				g_Costume_NextRound[id] = iNothing;
				g_Costume_Choosen[id] = g_Costume_NextRound[id];
				
				g_Hat_NextRound[id] = 0;
				g_Hat_Choosen[id] = 0;
				
				colorChat(id, _, "%sEn la próxima ronda, tu conjunto será !g%s!y. Si tenés un gorro, se reemplazará por el conjunto", JB_PREFIX, COSTUMES[iNothing][costumeName]);
			} else {
				colorChat(id, _, "%sNo podés elegir un conjunto que no posees", JB_PREFIX);
				
				showMenu__Costumes(id);
			}
	}
	
	return PLUGIN_HANDLED;
}

public setCostume(const id, const idCostume) {
	if(!is_user_connected(id)) {
		return;
	}
	
	if(g_Costume[id]) {
		new i;
		for(i = 0; i < 4; ++i) {
			if(is_valid_ent(g_Costume_Parts[id][i])) {
				remove_entity(g_Costume_Parts[id][i]);
			}
		}
	}
	
	if(idCostume == 0) {
		return;
	}
	
	if(is_valid_ent(g_Hat[id])) {
		remove_entity(g_Hat[id]);
	}
	
	g_Costume[id] = 1;
	
	if(COSTUMES[idCostume][costumeModel_Head]) {
		setCostume_Parts(id, idCostume, 0);
	}
	
	if(COSTUMES[idCostume][costumeModel_Face]) {
		setCostume_Parts(id, idCostume, 1);
	}
	
	if(COSTUMES[idCostume][costumeModel_Back]) {
		setCostume_Parts(id, idCostume, 2);
	}
	
	if(COSTUMES[idCostume][costumeModel_Pelvis]) {
		setCostume_Parts(id, idCostume, 3);
	}
}

public setCostume_Parts(const id, const idCostume, const costumePart) {
	new iEnt;
	g_Costume_Parts[id][costumePart] = iEnt = create_entity("info_target");
	
	if(is_valid_ent(iEnt)) {
		new Float:vecOrigin[3];
		
		entity_get_vector(id, EV_VEC_origin, vecOrigin);
		entity_set_vector(iEnt, EV_VEC_origin, vecOrigin);
		
		entity_set_float(iEnt, EV_FL_dmg_take, DAMAGE_NO);
		entity_set_float(iEnt, EV_FL_health, 100.0);
		
		entity_set_string(iEnt, EV_SZ_classname, "jbCostume");
		
		new sModel[64];
		switch(costumePart) {
			case 0: formatex(sModel, 63, "models/jb_hats/%s_head.mdl", COSTUMES[idCostume][costumeModel]);
			case 1: formatex(sModel, 63, "models/jb_hats/%s_face.mdl", COSTUMES[idCostume][costumeModel]);
			case 2: formatex(sModel, 63, "models/jb_hats/%s_back.mdl", COSTUMES[idCostume][costumeModel]);
			case 3: formatex(sModel, 63, "models/jb_hats/%s_pelvis.mdl", COSTUMES[idCostume][costumeModel]);
		}
		
		entity_set_model(iEnt, sModel);
		
		entity_set_int(iEnt, EV_INT_solid, SOLID_NOT);
		entity_set_int(iEnt, EV_INT_movetype, MOVETYPE_FOLLOW);
		
		entity_set_edict(iEnt, EV_ENT_aiment, id);
		entity_set_edict(iEnt, EV_ENT_owner, id);
		
		entity_set_float(iEnt, EV_FL_animtime, get_gametime());
		entity_set_float(iEnt, EV_FL_framerate, 1.0);
		entity_set_int(iEnt, EV_INT_sequence, 0);
	}
}

public fw_TouchPlayer_Post(const touched, const toucher) {
	if(!is_user_valid_alive(touched) || !is_user_valid_alive(toucher)) {
		return HAM_IGNORED;
	}
	
	if(g_IsMancha[touched] && g_IsMancha[toucher]) {
		return HAM_IGNORED;
	}
	
	if(g_IsMancha[touched] && !g_IsMancha[toucher]) {
		set_user_rendering(toucher, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 4);
		
		g_IsMancha[toucher] = 1;
		
		colorChat(toucher, _, "%sTe tocaron, eres la mancha, toca a otros para convertirlos en mancha!", JB_PREFIX);
		
		ExecuteHamB(Ham_Player_ResetMaxSpeed, toucher);
	} else if(!g_IsMancha[touched] && g_IsMancha[toucher]) {
		set_user_rendering(touched, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 4);
		
		g_IsMancha[touched] = 1;
		
		colorChat(touched, _, "%sTe tocaron, eres la mancha, toca a otros para convertirlos en mancha!", JB_PREFIX);
		
		ExecuteHamB(Ham_Player_ResetMaxSpeed, touched);
	}
	
	static i;
	static j;
	
	j = 1;
	
	for(i = 1; i <= g_MaxPlayers; ++i) {
		if(!is_user_alive(i)) {
			continue;
		}
		
		if(!g_IsMancha[i]) {
			j = 0;
		}
	}
	
	if(j) { // Todos en mancha
		new iTeam;
		
		DisableHamForward(g_HamPlayerTouch);
		
		for(i = 1; i <= g_MaxPlayers; ++i)
		{
			if(!is_user_alive(i))
				continue;
			
			iTeam = getUserTeam(i);
			
			g_Ira[i] += 15;
			
			if(g_WhoIsT[i] && iTeam == FM_CS_TEAM_CT) {
				setUserTeam(i, FM_CS_TEAM_T);
			} else if(g_WhoIsCT[i] && iTeam == FM_CS_TEAM_T) {
				setUserTeam(i, FM_CS_TEAM_CT);
				
				user_silentkill(i);
				
				continue;
			}
			
			if(iTeam == FM_CS_TEAM_CT) {
				user_silentkill(i);
			}
		}
		
		colorChat(0, _, "%sTodos los jugadores ganaron !g+15 Ira!y por participar de la mancha.", JB_PREFIX);
		
		remove_task(TASK_ESCONDIDAS);
	}
	
	return HAM_IGNORED;
}