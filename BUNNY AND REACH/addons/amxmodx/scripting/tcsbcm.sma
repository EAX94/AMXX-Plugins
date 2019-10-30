#include < amxmodx >
#include < amxmisc >
#include < cstrike >
#include < fakemeta_util >
#include < fun >
#include < hamsandwich >
#include < chr_engine >
#include < engine >
#include < cc >

/*
	ARREGLAR TP QUE NO PODES AGARRAR
*/

new gNumConfigActual;
new gLoadCFG = 0;
new g_CheckBHops = 0;
new gUnitsMove[33]

new g_CP_Ok[33];
new Float:g_CP_Pos[33][3];

new g_pCVAR_Access;

const KeysMenu = ( 1 << 0 ) | ( 1 << 1 ) | ( 1 << 2 ) | ( 1 << 3 ) | ( 1 << 4 ) | ( 1 << 5 ) | ( 1 << 6 ) | ( 1 << 7 ) | ( 1 << 8 ) | ( 1 << 9 )

//#define BLOCKS_TOUCH

#if defined BLOCKS_TOUCH
	new gLastEnt[33];
	new Float:gfLastTouchEnt[33];

	#define TASK_TOUCH1 706128
	#define TASK_TOUCH2 943316
#endif

#define TASK_UNSOLID 303000
#define TASK_SOLID 404000

#define TASK_FIX_USER		95172319
#define ID_FIX_USER			(taskid - TASK_FIX_USER)

#define TSK_BHOP 564246
#define TSK_CLEAR_FAIL 256796789

const PDATA_SAFE = 2;
const OFFSET_LINUX = 5;
const OFFSET_CSTEAMS = 114;

enum _:Teams{
	FM_CS_TEAM_UNASSIGNED = 0,
	FM_CS_TEAM_T,
	FM_CS_TEAM_CT,
	FM_CS_TEAM_SPECTATOR
};

new g_count_bcm = 0;

new bhop_failid[32], bool:bhop_fail[32]

new const BCM_PREFIX[] = "!g[BnR]!y ";

// new g_Ent_Touch[33];

new g_LJ_Distance[33];
new g_LJ_Axis[33];

new g_God[33];
new gszViewModel[33][32];
new g_CreateTeleport[33];

new const gszTeleportSpriteStart[] = "sprites/flare6.spr";				//from HL
new const gszTeleportSpriteEnd[] = "sprites/bnr/teleport_end.spr";		//custom
new const Float:gfTeleportSizeMin[3] = {-16.0,-16.0,-16.0};
new const Float:gfTeleportSizeMax[3] = { 16.0, 16.0, 16.0};
new const gTeleportStartFrames = 20;
new const gTeleportEndFrames = 5;
const TASK_SPRITE = 6000;

enum
{
	OBJECT_BHOP = 1,
	OBJECT_BLOCK,
	OBJECT_BOOSTBLOCK,
	OBJECT_ICEBHOP,
	OBJECT_DELAYEDBHOP,
	OBJECT_FALLBLOCK,
	OBJECT_TELEPORT,
	OBJECT_FATALISBLOCK,
	OBJECT_TINKBLOCK,
	OBJECT_SPEEDBLOCK,
	OBJECT_WINDOWBLOCK
	// Edit here for adding new blocks
};

enum
{
	MODEL_NORMAL = 1,
	MODEL_BIG,
	MODEL_TINY,
	MODEL_OTHER
};

#define TASK_ID_LOAD 			202000
#define TASK_ID_SHOWXYZ 		808000
#define DEFAULT_ACCESS 			"m" // ADMIN_LEVEL_A
#define ACCESS_CREATOR			"r" // ADMIN_LEVEL_F

new const gOBJECTSAVENAMES[][] =
{
	"", // NULL
	"bhop", // BHOP
	"block", // BLOCK
	"boost", // BOOSTBLOCK
	"ice", // ICEBHOP
	"delay", // DELAYEDBHOP
	"fall", // FALLBLOCK
	"", // TELEPORT
	"fatalis", // FATALISBLOCK
	"tink", // TINKBLOCK
	"speed", // SPEEDBLOCK
	"window" // WINDOWBLOCK
	// Edit here for adding new blocks
};

new const gMODELTYPESAVENAMES[][] =
{
	"", // NULL
	"norm", // NORMAL
	"big", // GRANDE
	"tiny", // CHICO
	"other"
};

new const gOBJECTNAMES[][] =
{
	"",
	"Bhop - Bhop común",
	"Bloque - Bloque sólido",
	"Bloque de impulso - Te impulsa hacia arriba",
	"Bhop de hielo - No te frena cuando lo tocás",
	"Bhop con retardo - Desaparece más lento de lo normal",
	"Bloque de aterrizaje - No te haces daño al caer sobre él",
	"Teletransporte - Te teletransporta a otra posición",
	"Bloque de daño - Te hace daño",
	"Bloque de curación - Te cura",
	"Bloque de velocidad - Te impulsa con velocidad",
	"Bloque de ventana - Es una ventana"
};

new const gPROPERTYNAME1[][] =
{
	"", // NULL
	"", // BHOP
	"", // BLOCK
	"Velocidad de impulso", // BOOSTBLOCK
	"", // ICEBHOP
	"Retardo antes de desaparecer", // DELAYEDBHOP
	"", // FALLBLOCK
	"Nombre", // TELEPORT
	"Daño", // FATALISBLOCK
	"Cura", // TINKBLOCK
	"Velocidad", // SPEEDBLOCK
	"Transparencia" // WINDOWBLOCK
	// Edit here for adding new blocks
};

new const gDEFAULTPROPERTY1[][] =
{
	"", // NULL
	"", // BHOP
	"", // BLOCK
	"500.0", // BOOSTBLOCK
	"", // ICEBHOP
	"1.0", // DELAYEDBHOP
	"", // FALLBLOCK
	"", // TELEPORT
	"125.0", // FATALISBLOCK
	"2.0", // TINKBLOCK
	"1200.0", // SPEEDBLOCK
	"128.0" // WINDOWBLOCK
	// Edit here for adding new blocks
};

new const gPROPERTYNAME2[][] =
{
	"", // NULL
	"", // BHOP
	"", // BLOCK
	"", // BOOSTBLOCK
	"", // ICEBHOP
	"", // DELAYEDBHOP
	"", // FALLBLOCK
	"Destino", // TELEPORT
	"Daño cada", // FATALISBLOCK
	"Cura cada", // TINKBLOCK
	"Velocidad hacia arriba", // SPEEDBLOCK
	"" // WINDOWBLOCK
	// Edit here for adding new blocks
};

new const gDEFAULTPROPERTY2[][] =
{
	"", // NULL
	"", // BHOP
	"", // BLOCK
	"", // BOOSTBLOCK
	"", // ICEBHOP
	"", // DELAYEDBHOP
	"", // FALLBLOCK
	"", // TELEPORT
	"1.0", // FATALISBLOCK
	"1.0", // TINKBLOCK
	"0.0", // SPEEDBLOCK
	"" // WINDOWBLOCK
	// Edit here for adding new blocks
};

new const gPROPERTYNAME3[][] =
{
	"", // NULL
	"", // BHOP
	"", // BLOCK
	"", // BOOSTBLOCK
	"", // ICEBHOP
	"", // DELAYEDBHOP
	"", // FALLBLOCK
	"", // TELEPORT
	"", // FATALISBLOCK
	"", // TINKBLOCK
	"Dirección del impulso", // SPEEDBLOCK
	"" // WINDOWBLOCK
	// Edit here for adding new blocks
};

new const gDEFAULTPROPERTY3[][] =
{
	"", // NULL
	"", // BHOP
	"", // BLOCK
	"", // BOOSTBLOCK
	"", // ICEBHOP
	"", // DELAYEDBHOP
	"", // FALLBLOCK
	"", // TELEPORT
	"", // FATALISBLOCK
	"", // TINKBLOCK
	"1", // SPEEDBLOCK
	"" // WINDOWBLOCK
	// Edit here for adding new blocks
};

new const gNORMALMODELS[][] =
{
	"",
	"models/obnr/normal_bhop.mdl",
	"models/obnr/normal_block.mdl",
	"models/obnr/normal_boost.mdl",
	"models/obnr/normal_ice.mdl",
	"models/obnr/normal_delayedbhop.mdl",
	"models/obnr/normal_fall.mdl",
	"", // TELEPORT
	"models/obnr/normal_fatalis.mdl",
	"models/obnr/normal_tink.mdl",
	"models/obnr/normal_speed.mdl",
	"models/obnr/normal_block.mdl"
	// Edit here for adding new blocks
};

new const gBIGMODELS[][] =
{
	"",
	"models/obnr/wall_bhop.mdl",
	"models/obnr/wall_block.mdl",
	"models/obnr/wall_boost.mdl",
	"models/obnr/wall_ice.mdl",
	"models/obnr/wall_delayedbhop.mdl",
	"models/obnr/wall_fall.mdl",
	"", // TELEPORT
	"models/obnr/wall_fatalis.mdl",
	"models/obnr/wall_tink.mdl",
	"models/obnr/wall_speed.mdl",
	"models/obnr/wall_block.mdl"
	// Edit here for adding new blocks
};

new const gTINYMODELS[][] = 
{
	"",
	"models/obnr/tiny_bhop.mdl",
	"models/obnr/tiny_block.mdl",
	"models/obnr/tiny_boost.mdl",
	"models/obnr/tiny_ice.mdl",
	"models/obnr/tiny_delayedbhop.mdl",
	"models/obnr/tiny_fall.mdl",
	"", // TELEPORT
	"models/obnr/tiny_fatalis.mdl",
	"models/obnr/tiny_tink.mdl",
	"models/obnr/tiny_speed.mdl",
	"" // WINDOWBLOCK
	// Edit here for adding new blocks
};

new const gOTHERMODELS[][] =
{
	"", // NULL
	"", // BHOP
	"", // BLOCK
	"", // BOOSTBLOCK
	"", // ICEBHOP
	"", // DELAYEDBHOP
	"", // FALLBLOCK
	"sprites/bnr/teleport_end.spr", // TELEPORT
	"", // FATALISBLOCK
	"", // TINKBLOCK
	"", // SPEEDBLOCK
	"" // WINDOWBLOCK
	// Edit here for adding new blocks
};

new const Float:gDEFAULTMINS[][] =
{
	{-1.0, -1.0, -1.0}, // NULL
	{-32.0, -32.0, -4.0}, // Normal
	{-64.0, -64.0, -4.0}, // Big
	{-8.0, -8.0, -4.0}, // Tiny
	{-8.0, -8.0, -8.0} // Other
};

new const Float:gDEFAULTMAXS[][] =
{
	{-1.0, -1.0, -1.0}, // NULL
	{32.0, 32.0, 4.0}, // Normal
	{64.0, 64.0, 4.0}, // Big
	{8.0, 8.0, 4.0}, // Tiny
	{8.0, 8.0, 8.0} // Other
};

new const gLOGFILE[] = "bcm5_deletecfg.log";

new gMainMenu;

new gBuildMenu;
new gModifyMenu;
new gSaveLoadMenu;

new gMaxPlayers;
new g_hStringInfoTarget;

new gCvarLimit;

new gCvarAccessDeleteConfig;
new gCvarAccessBuild;
new gCvarAccessMove;
new gCvarAccessDelete;
// new gCvarAccessNoclip;
new gCvarAccessLoad;
new gCvarAccessNewConfig;
new gCvarAccessSave;
new gCvarAccessSetProperties;

// Used for set properties
new gSetPropertyInfo[33][2];

// Used to set velocity when we can't
new Float:gSetVelocity[33][3];

// Used in the build menu
new gChoseType[33];

// new gBeamSprite;

// Used for grab
new Float:gGrabLength[33];
new Float:gGrabOffset[33][3];
new gGrabbedEnt[33];

// Used for config vote
new gLoadConfigOnNewRound[33];

new gCurConfig[33];
new gDir[129];

new gStartLoadAtIndex;

public fw_SysError(const error[])
{
	new sMapName[64];
	get_mapname(sMapName, 63);
	
	new sError[512];
	formatex(sError, 511, "FORWARD: FM_Sys_Error | Error: %s | MAPA: %s", (error[0]) ? error : "Ninguno", sMapName);
	
	log_to_file("errores.log", sError);
}

public plugin_precache()
{
	register_forward(FM_Sys_Error, "fw_SysError");
	
	precache_model(gszTeleportSpriteStart);
	
	for ( new i = 1; i < sizeof(gNORMALMODELS); i++ )
	{
		if ( strlen(gNORMALMODELS[i]) )
		{
			precache_model(gNORMALMODELS[i]);
		}
	}
	
	for ( new i = 1; i < sizeof(gTINYMODELS); i++ )
	{
		if ( strlen(gTINYMODELS[i]) )
		{
			precache_model(gTINYMODELS[i]);
		}
	}
	
	for ( new i = 1; i < sizeof(gBIGMODELS); i++ )
	{
		if ( strlen(gBIGMODELS[i]) )
		{
			precache_model(gBIGMODELS[i]);
		}
	}
	
	for ( new i = 1; i < sizeof(gOTHERMODELS); i++ )
	{
		if ( strlen(gOTHERMODELS[i]) )
		{
			precache_model(gOTHERMODELS[i]);
		}
	}
	
	// gBeamSprite = precache_model("sprites/zbeam4.spr");
	
	return PLUGIN_CONTINUE;
}

new g_CVAR_DelayBhop;
new g_CVAR_DelayIceBhop;

public plugin_init()
{
	register_plugin("BCM", "1.0", "DaFox & Fatalis");
	
	g_CVAR_DelayBhop = register_cvar("bcm_delay_bhop", "0.6");
	g_CVAR_DelayIceBhop = register_cvar("bcm_delay_icebhop", "0.7");
	
	gCvarLimit = register_cvar("bcm_bnr_limit", "400", 0, 0.0);
	
	gCvarAccessDeleteConfig = register_cvar("bcm_access_deleteconfig", "k", FCVAR_SPONLY, 0.0);
	gCvarAccessBuild = register_cvar("bcm_access_build", ACCESS_CREATOR, FCVAR_SPONLY, 0.0);
	gCvarAccessMove = register_cvar("bcm_access_move", ACCESS_CREATOR, FCVAR_SPONLY, 0.0);
	gCvarAccessDelete = register_cvar("bcm_access_delete", ACCESS_CREATOR, FCVAR_SPONLY, 0.0);
	// gCvarAccessNoclip = register_cvar("bcm_access_noclip", DEFAULT_ACCESS, FCVAR_SPONLY, 0.0);
	gCvarAccessLoad = register_cvar("bcm_access_load", DEFAULT_ACCESS, FCVAR_SPONLY, 0.0);
	gCvarAccessNewConfig = register_cvar("bcm_access_newconfig", DEFAULT_ACCESS, FCVAR_SPONLY, 0.0);
	gCvarAccessSave = register_cvar("bcm_access_save", DEFAULT_ACCESS, FCVAR_SPONLY, 0.0);
	gCvarAccessSetProperties = register_cvar("bcm_access_setproperties", ACCESS_CREATOR, FCVAR_SPONLY, 0.0);
	
	register_forward(FM_Touch, "fwdTouch", 0);
	register_forward(FM_CmdStart, "fw_CmdStart");

	register_event("HLTV", "msgNewRound", "a", "1=0", "2=0");
	
	register_forward(FM_PlayerPreThink, "fwdPlayerPreThink", 0);
	
	RegisterHam(Ham_Spawn, "player", "fw_PlayerSpawn__Post", 1);
	
	#if defined BLOCKS_TOUCH
		RegisterHam(Ham_Killed, "player", "fw_PlayerKilled")
		register_forward( FM_PlayerPostThink, "FwdPlayerPostThink", 0 )
	#endif
	
	//register_forward(FM_AddToFullPack, "fw_AddToFullPack_Post", 1);
	
	gMaxPlayers = get_maxplayers();
	
	g_hStringInfoTarget = engfunc(EngFunc_AllocString, "info_target");
	
	register_clcmd("say /cp", "clcmd__CheckPoint");
	register_clcmd("say /tp", "clcmd__GoCheck");
	register_clcmd("say /gc", "clcmd__GoCheck");
	
	register_clcmd("bcm_acc", "clcmd__Access");
	register_clcmd("bcmcopy", "clcmd__Copy");
	register_clcmd("bcmdelete", "clcmd__Delete");
	
	register_clcmd("chooseteam", "clcmd__JoinTeam");
	register_clcmd("jointeam", "clcmd__JoinTeam");
	
	register_clcmd("DISTANCIA_LJ", "clcmd__DistanciaLJ");
	
	g_pCVAR_Access = register_cvar("bnr_access", "0");
	
	register_clcmd("say /bhopmenu", "cmdBhopMenu");
	register_clcmd("say /bcm", "cmdBhopMenu");
	register_clcmd("say /bm", "cmdBhopMenu");
	register_clcmd("amx_bcm", "cmdBhopMenu");
	register_clcmd("bcm", "cmdBhopMenu");
	
	register_clcmd("say /cbhop", "clcmd__CheckBHop");
	
	register_menu("ShowMenuGameAA", KeysMenu, "MenuGame")
	
	// I hate cmdaccess.ini
	register_clcmd("bcm_newconfig", "cmdNewConfig", -1, " <configName>");
	register_clcmd("bcm_setproperty", "cmdSetProperty", -1, " <propertyValue>");
	register_concmd("bcm_deleteconfig", "cmdDeleteConfig", -1, " <configName>");
	
	register_clcmd("+bcmgrab", "cmdGrabOn", -1, "");
	register_clcmd("-bcmgrab", "cmdGrabOff", -1, "");
	register_clcmd("+bmgrab", "cmdGrabOn", -1, "");
	register_clcmd("-bmgrab", "cmdGrabOff", -1, "");
	
	get_datadir(gDir, 128);
	add(gDir, 128, "/bcm", 0);
	if ( !dir_exists(gDir) )
	{
		mkdir(gDir);
	}
	
	new szMap33[33];
	get_mapname(szMap33, 32);
	
	strtolower( szMap33 )
	format(gDir, 128, "%s/%s", gDir, szMap33);
	
	if ( !dir_exists(gDir) )
	{
		mkdir(gDir);
	}
	
	new CantConfigs = GetNumConfigs();
	new num = random(CantConfigs);
	new NombreConfig[33];
	GetConfigByNum(num,NombreConfig);
	Load(NombreConfig);
	gNumConfigActual = num;
	
	set_task(1.0, "InitAfterCvars", 0, "", 0, "", 0);
	
	return PLUGIN_CONTINUE;
}

#if defined BLOCKS_TOUCH
	public client_connect(id)
	{
		gLastEnt[id] = 0
		gfLastTouchEnt[id] = 0.0
		gUnitsMove[id] = 0
		
		remove_task(id + TASK_TOUCH1)
		remove_task(id + TASK_TOUCH2)
	}
#endif

public client_disconnect(id) {
	if(g_CreateTeleport[id]) {
		remove_entity(g_CreateTeleport[id]);
	}
	
	#if defined BLOCKS_TOUCH
		gLastEnt[id] = 0
		gfLastTouchEnt[id] = 0.0
		
		remove_task(id + TASK_TOUCH1)
		remove_task(id + TASK_TOUCH2)
	#endif
}

public InitAfterCvars()
{
	new szAccessFlag[2];
	
	get_pcvar_string(gCvarAccessBuild, szAccessFlag, 1);
	new accessBuild = read_flags(szAccessFlag);
	
	get_pcvar_string(gCvarAccessMove, szAccessFlag, 1);
	new accessMove = read_flags(szAccessFlag);
	
	get_pcvar_string(gCvarAccessDelete, szAccessFlag, 1);
	new accessDelete = read_flags(szAccessFlag);
	
	// get_pcvar_string(gCvarAccessNoclip, szAccessFlag, 1);
	// new accessNoclip = read_flags(szAccessFlag);
	
	get_pcvar_string(gCvarAccessNewConfig, szAccessFlag, 1);
	new accessNewConfig = read_flags(szAccessFlag);
	
	get_pcvar_string(gCvarAccessSave, szAccessFlag, 1);
	new accessSave = read_flags(szAccessFlag);
	
	gMainMenu = menu_create("Only BnR - BCM", "mnuMain", 0);
	menu_additem(gMainMenu, "Crear Bloques", "1", 0, -1);
	menu_additem(gMainMenu, "Modificar Bloques", "2", 0, -1);
	menu_additem(gMainMenu, "Noclip", "3", 0, -1);
	menu_additem(gMainMenu, "Configuración^n", "4", 0, -1);
	menu_additem(gMainMenu, "Checkpoint", "5", 0, -1);
	menu_additem(gMainMenu, "Gocheck", "6", 0, -1);
	menu_additem(gMainMenu, "GodMode", "7", 0, -1);
	
	gBuildMenu = menu_create("Crear Bloques", "mnuBuild", 0);
	menu_additem(gBuildMenu, "Bhop", "1", accessBuild, -1);
	menu_additem(gBuildMenu, "Bloque", "2", accessBuild, -1);
	menu_additem(gBuildMenu, "Bloque de impulso", "3", accessBuild, -1);
	menu_additem(gBuildMenu, "Bhop de hielo", "4", accessBuild, -1);
	menu_additem(gBuildMenu, "Bhop con retardo", "5", accessBuild, -1);
	menu_additem(gBuildMenu, "Bloque de aterrizaje", "6", accessBuild, -1);
	menu_additem(gBuildMenu, "Teletransportación", "7", accessBuild, -1);
	menu_additem(gBuildMenu, "Bloque de daño", "8", accessBuild, -1);
	menu_additem(gBuildMenu, "Bloque de curación", "9", accessBuild, -1);
	menu_additem(gBuildMenu, "Bloque de velocidad", "10", accessBuild, -1);
	menu_additem(gBuildMenu, "Bloque con transparencia", "11", accessBuild, -1);
	menu_additem(gBuildMenu, "Crear LJ", "12", accessBuild, -1);
	menu_setprop(gBuildMenu, MPROP_EXITNAME, "Menú Principal");
	
	gModifyMenu = menu_create("Modificar Bloques", "mnuModify", 0);
	menu_additem(gModifyMenu, "Mover Bloque", "1", 0, -1);
	menu_additem(gModifyMenu, "Eliminar Bloque", "2", accessDelete, -1);
	menu_additem(gModifyMenu, "Ajustar Propiedades", "3", 0, -1);
	menu_additem(gModifyMenu, "Rotar Bloque", "4", accessMove, -1);
	menu_setprop(gModifyMenu, MPROP_EXITNAME, "Menú Principal");
	
	gSaveLoadMenu = menu_create("Configuración", "mnuSaveLoad", 0);
	menu_additem(gSaveLoadMenu, "Guardar config actual", "1", accessSave, -1);
	menu_additem(gSaveLoadMenu, "Cargar config", "2", 0, -1);
	menu_additem(gSaveLoadMenu, "Crear config", "3", accessNewConfig, -1);
	menu_setprop(gSaveLoadMenu, MPROP_EXITNAME, "Menú Principal");
	
	/*gMoveMenu = menu_create("Mover Bloque", "mnuMove", 0);
	menu_additem(gMoveMenu, "Z+ Verde", "1", accessMove, -1);
	menu_additem(gMoveMenu, "Z-", "2", accessMove, -1);
	menu_additem(gMoveMenu, "X+ Rojo", "3", accessMove, -1);
	menu_additem(gMoveMenu, "X-", "4", accessMove, -1);
	menu_additem(gMoveMenu, "Y+ Azul", "5", accessMove, -1);
	menu_additem(gMoveMenu, "Y-", "6", accessMove, -1);
	menu_setprop(gMoveMenu, MPROP_EXITNAME, "Modificar Bloque");*/
	
	return PLUGIN_CONTINUE;
}

public mnuModify(id, menu, item)
{
	if ( item == MENU_EXIT )
	{
		menu_display(id, gMainMenu, 0);
		return PLUGIN_CONTINUE;
	}
	
	new szCmd[3],  _access, callback;
	menu_item_getinfo(menu, item, _access, szCmd, 2, "", 0, callback);
	
	new cmd = str_to_num(szCmd);
	switch ( cmd )
	{
		case 1: // Mover
		{
			show_menu_move(id)
			// set_task(0.1, "tskShowXYZ", TASK_ID_SHOWXYZ + id, "", 0, "b", 0);
			return PLUGIN_CONTINUE;
		}
		case 2: // Borrar
		{
			new ent = GetAimEnt(id);
			
			if(isTeleport(ent)) {
				if(task_exists(TASK_SPRITE + ent))
					remove_task(TASK_SPRITE + ent);
				
				remove_entity(ent);
			} else {
				new type = GetObjectType(ent);
				
				if ( type )
				{
					engfunc(EngFunc_RemoveEntity, ent);
				}
			}
		}
		case 3: // Ajustar Propiedades
		{
			new ent = GetAimEnt(id);
			
			new type = GetObjectType(ent);
			if ( type )
			{		
				new setPropertiesMenu = menu_create("Ajustar Propiedades", "mnuSetProperties", 0);
				
				new szAccessFlag[2];
				get_pcvar_string(gCvarAccessSetProperties, szAccessFlag, 1);
				new accessSetProperties = read_flags(szAccessFlag);
			
				new szInfo[65], szProperty[33];
				if ( strlen(gPROPERTYNAME1[type]) || type == OBJECT_BHOP || type == OBJECT_ICEBHOP )
				{
					if(type != OBJECT_BHOP && type != OBJECT_ICEBHOP) {
						GetObjectProperty(ent, 1, szProperty);
						formatex(szInfo, 64, "%s : '%s'", gPROPERTYNAME1[type], szProperty);
						menu_additem(setPropertiesMenu, szInfo, "1", accessSetProperties, -1);
					} else {
						static Float:vecOldOrigin[3];
						static sItem[200];
						
						entity_get_vector(ent, EV_VEC_oldorigin, vecOldOrigin);
						
						formatex(sItem, 199, "BHop Fail : {%0.2f %0.2f %0.2f}^n^n\rNOTA:\w Ponte en el lugar donde quieres que^nte devuelva el bloque en caso de que falles el bhop^ny luego dale al 1", vecOldOrigin[0], vecOldOrigin[1], vecOldOrigin[2]);
						menu_additem(setPropertiesMenu, sItem, "1", accessSetProperties, -1);
					}
				}
				if ( strlen(gPROPERTYNAME2[type]) )
				{
					GetObjectProperty(ent, 2, szProperty);
					if( type == OBJECT_TINKBLOCK ) formatex(szInfo, 64, "%s : '%s'^nSolo cura a los Terroristas", gPROPERTYNAME2[type], szProperty);
					else formatex(szInfo, 64, "%s : '%s'", gPROPERTYNAME2[type], szProperty);
					menu_additem(setPropertiesMenu, szInfo, "2", accessSetProperties, -1);
				}
				if ( strlen(gPROPERTYNAME3[type]) )
				{
					GetObjectProperty(ent, 3, szProperty);
					formatex(szInfo, 64, "%s : '%s'", gPROPERTYNAME3[type], szProperty);
					menu_additem(setPropertiesMenu, szInfo, "3", accessSetProperties, -1);
				}
				
				menu_setprop(setPropertiesMenu, MPROP_EXITNAME, "Modificar Bloque");
				gSetPropertyInfo[id][1] = ent;
				menu_display(id, setPropertiesMenu, 0);
				
				return PLUGIN_CONTINUE;
			}
		}
		case 4: // Rotar
		{
			new ent = GetAimEnt(id);
			
			new type = GetObjectType(ent);
			if ( type )
				RotateObject(ent);
		}
	}
	
	menu_display(id, menu, floatround(float(cmd) / 7, floatround_ceil)-1);
	
	return PLUGIN_CONTINUE;
}

RotateObject(ent)
{
	new model = GetObjectModelType(ent);
	if ( !model ) return 0;
	
	static Float:vAngles[3];
	pev(ent, pev_angles, vAngles);
	
	static Float:vOrigin[3];
	pev(ent, pev_origin, vOrigin);
	
	static Float:vMins[3], Float:vMaxs[3];
	
	if ( model == MODEL_BIG ) // TODO: Make code better. For some reason the wall model is positioned wrong in-game
	{
		if ( vAngles[2] == 90.0 && !vAngles[0] )
		{
			vAngles[0] = 90.0;
			vAngles[1] = 0.0;
			vAngles[2] = 90.0;
			
			vMins[0] = gDEFAULTMINS[model][2];
			vMins[1] = gDEFAULTMINS[model][0];
			vMins[2] = gDEFAULTMINS[model][1];
			
			vMaxs[0] = gDEFAULTMAXS[model][2];
			vMaxs[1] = gDEFAULTMAXS[model][0];
			vMaxs[2] = gDEFAULTMAXS[model][1];
		}
		else if ( vAngles[0] == 90.0 && vAngles[2] == 90.0 )
		{
			vAngles[0] = 90.0;
			vAngles[1] = 0.0;
			vAngles[2] = 0.0;
			
			vMins[0] = gDEFAULTMINS[model][1];
			vMins[1] = gDEFAULTMINS[model][2];
			vMins[2] = gDEFAULTMINS[model][0];
			
			vMaxs[0] = gDEFAULTMAXS[model][1];
			vMaxs[1] = gDEFAULTMAXS[model][2];
			vMaxs[2] = gDEFAULTMAXS[model][0];
		}
		else
		{
			vAngles[0] = 0.0;
			vAngles[1] = 0.0;
			vAngles[2] = 90.0;
			
			vMins[0] = gDEFAULTMINS[model][0];
			vMins[1] = gDEFAULTMINS[model][1];
			vMins[2] = gDEFAULTMINS[model][2];
			
			vMaxs[0] = gDEFAULTMAXS[model][0];
			vMaxs[1] = gDEFAULTMAXS[model][1];
			vMaxs[2] = gDEFAULTMAXS[model][2];
		}
	}
	else
	{
		if ( !vAngles[0] && !vAngles[2] )
		{
			vAngles[0] = 90.0;
			vAngles[1] = 0.0;
			vAngles[2] = 0.0;
			
			vMins[0] = gDEFAULTMINS[model][2];
			vMins[1] = gDEFAULTMINS[model][0];
			vMins[2] = gDEFAULTMINS[model][1];
			
			vMaxs[0] = gDEFAULTMAXS[model][2];
			vMaxs[1] = gDEFAULTMAXS[model][0];
			vMaxs[2] = gDEFAULTMAXS[model][1];
		}
		else if ( vAngles[0] == 90.0 && !vAngles[2] )
		{
			vAngles[0] = 90.0;
			vAngles[1] = 0.0;
			vAngles[2] = 90.0;
			
			vMins[0] = gDEFAULTMINS[model][1];
			vMins[1] = gDEFAULTMINS[model][2];
			vMins[2] = gDEFAULTMINS[model][0];
			
			vMaxs[0] = gDEFAULTMAXS[model][1];
			vMaxs[1] = gDEFAULTMAXS[model][2];
			vMaxs[2] = gDEFAULTMAXS[model][0];
		}
		else
		{
			vAngles[0] = 0.0;
			vAngles[1] = 0.0;
			vAngles[2] = 0.0;
			
			vMins[0] = gDEFAULTMINS[model][0];
			vMins[1] = gDEFAULTMINS[model][1];
			vMins[2] = gDEFAULTMINS[model][2];
			
			vMaxs[0] = gDEFAULTMAXS[model][0];
			vMaxs[1] = gDEFAULTMAXS[model][1];
			vMaxs[2] = gDEFAULTMAXS[model][2];
		}
	}
	
	if ( !IsOriginVacant(vMins, vMaxs, vOrigin) ) return 0;
	
	engfunc(EngFunc_SetSize, ent, vMins, vMaxs);
	set_pev(ent, pev_angles, vAngles);
	
	return 1;
}

GetObjectSizeByAngles(model, Float:vAngles[3], Float:vMins[3], Float:vMaxs[3])
{
	if ( model == MODEL_BIG ) // TODO: Make code better. For some reason the wall model is positioned wrong in-game
	{
		if ( vAngles[2] == 90.0 && !vAngles[0] )
		{
			vMins[0] = gDEFAULTMINS[model][0];
			vMins[1] = gDEFAULTMINS[model][1];
			vMins[2] = gDEFAULTMINS[model][2];
			
			vMaxs[0] = gDEFAULTMAXS[model][0];
			vMaxs[1] = gDEFAULTMAXS[model][1];
			vMaxs[2] = gDEFAULTMAXS[model][2];
		}
		else if ( vAngles[0] == 90.0 && vAngles[2] == 90.0 )
		{
			vMins[0] = gDEFAULTMINS[model][2];
			vMins[1] = gDEFAULTMINS[model][0];
			vMins[2] = gDEFAULTMINS[model][1];
			
			vMaxs[0] = gDEFAULTMAXS[model][2];
			vMaxs[1] = gDEFAULTMAXS[model][0];
			vMaxs[2] = gDEFAULTMAXS[model][1];
		}
		else
		{
			vMins[0] = gDEFAULTMINS[model][1];
			vMins[1] = gDEFAULTMINS[model][2];
			vMins[2] = gDEFAULTMINS[model][0];
			
			vMaxs[0] = gDEFAULTMAXS[model][1];
			vMaxs[1] = gDEFAULTMAXS[model][2];
			vMaxs[2] = gDEFAULTMAXS[model][0];
		}
	}
	else
	{
		if ( !vAngles[0] && !vAngles[2] )
		{
			vMins[0] = gDEFAULTMINS[model][0];
			vMins[1] = gDEFAULTMINS[model][1];
			vMins[2] = gDEFAULTMINS[model][2];
			
			vMaxs[0] = gDEFAULTMAXS[model][0];
			vMaxs[1] = gDEFAULTMAXS[model][1];
			vMaxs[2] = gDEFAULTMAXS[model][2];
		}
		else if ( vAngles[0] == 90.0 && !vAngles[2] )
		{
			vMins[0] = gDEFAULTMINS[model][2];
			vMins[1] = gDEFAULTMINS[model][0];
			vMins[2] = gDEFAULTMINS[model][1];
			
			vMaxs[0] = gDEFAULTMAXS[model][2];
			vMaxs[1] = gDEFAULTMAXS[model][0];
			vMaxs[2] = gDEFAULTMAXS[model][1];
		}
		else
		{
			vMins[0] = gDEFAULTMINS[model][1];
			vMins[1] = gDEFAULTMINS[model][2];
			vMins[2] = gDEFAULTMINS[model][0];
			
			vMaxs[0] = gDEFAULTMAXS[model][1];
			vMaxs[1] = gDEFAULTMAXS[model][2];
			vMaxs[2] = gDEFAULTMAXS[model][0];
		}
	}
	
	return 1;
}

public cmdDeleteConfig(id, level, cid)
{
	new szAccessFlag[2];
	get_pcvar_string(gCvarAccessDeleteConfig, szAccessFlag, 1);
	if ( !access(id, read_flags(szAccessFlag)) )
	{
		return PLUGIN_HANDLED;
	}
	
	new szArg[33];
	read_argv(1, szArg, 32);
	
	new szPath[129];
	format(szPath, 128, "%s/%s.txt", gDir, szArg);
	
	if ( file_exists(szPath) )
	{
		delete_file(szPath);
		
		new szName[32];
		get_user_name(id, szName, 31);
		
		log_to_file(gLOGFILE, "%s borro la CFG: %s", szName, szArg);
	}
	
	return PLUGIN_HANDLED;
}

public cmdNewConfig(id)
{
	new szAccessFlag[2];
	get_pcvar_string(gCvarAccessNewConfig, szAccessFlag, 1);
	if ( !access(id, read_flags(szAccessFlag)) )
	{
		return PLUGIN_HANDLED;
	}
	
	new szArg[33];
	read_argv(1, szArg, 32);
	
	if ( !strlen(szArg) ) return PLUGIN_HANDLED;
	else if ( !IsStringAlphaNumeric(szArg) )
	{
		colorChat(id, _, "%sEl nombre de la config debe ser alfanumérico.", BCM_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	new szPath[129];
	format(szPath, 128, "%s/%s.txt", gDir, szArg);
	
	if ( !file_exists(szPath) )
	{
		new szMapName[64];
		get_mapname(szMapName, 63);
		
		new f = fopen(szPath, "wt");
		fclose(f);
		
		new sName[32];
		get_user_name(id, sName, 31);
		
		colorChat(0, CT, "%s!t%s!y creó la CFG: !g%s!y", BCM_PREFIX, sName, szArg);
	}
	else colorChat(id, _, "%sEsa CFG ya existe.", BCM_PREFIX);
	
	return PLUGIN_HANDLED;
}

public cmdSetProperty(id, level, cid)
{
	new szAccessFlag[2];
	get_pcvar_string(gCvarAccessSetProperties, szAccessFlag, 1);
	if ( !access(id, read_flags(szAccessFlag)) ) return PLUGIN_HANDLED;
	
	new szArg[33];
	read_argv(1, szArg, 32);
	
	new ent = gSetPropertyInfo[id][1];
	if ( is_valid_ent(ent) )
	{
		new property = gSetPropertyInfo[id][0];
		switch ( property )
		{
			case 1 .. 3: // TODO: Remove?
			{
				new type = GetObjectType(ent);
				if ( type == OBJECT_TELEPORT && property == 1 )
				{
					if ( GetObjectByProperty(1, szArg) )
					{
						colorChat(id, _, "%sYa existe un teletransportador con ese nombre.", BCM_PREFIX);
						return PLUGIN_HANDLED;
					}
				}
				else if ( type == OBJECT_WINDOWBLOCK && property == 1 ) set_pev(ent, pev_renderamt, str_to_float(szArg));
				
				SetObjectProperty(ent, property, szArg);
				colorChat(id, _, "%sSe ajustó el valor de la propiedad.", BCM_PREFIX);
			}
		}
	}
	else colorChat(id, _, "%sEl objeto fue borrado.", BCM_PREFIX);

	return PLUGIN_HANDLED;
}

public cmdGrabOn(id) 
{
	new szAccessFlag[2];
	get_pcvar_string(gCvarAccessMove, szAccessFlag, 1);
	if ( !access(id, read_flags(szAccessFlag)) )
	{
		return PLUGIN_HANDLED;
	}
	
	new ent, body;
	get_user_aiming(id, ent, body);
	
	if(isTeleport(ent)) {
		new Float:vPlayerOrigin[3], Float:vEntOrigin[3];
		pev(id, pev_origin, vPlayerOrigin);
		pev(ent, pev_origin, vEntOrigin);
		
		new ent2, body;
		gGrabLength[id] = get_user_aiming(id, ent2, body, 9999);
		
		if( ent != ent2 )
		{
			gGrabLength[id] = get_distance_f(vPlayerOrigin, vEntOrigin);
		}
		
		GrabTeleport(id, ent);
		return PLUGIN_HANDLED;
	}
	
	ent = GetAimEnt(id);
	new type = GetObjectType(ent);
	
	if ( type )
	{
		Grab(id, ent);
	}
	
	return PLUGIN_HANDLED_MAIN;
}

isTeleport(ent)
{
	if (is_valid_ent(ent))
	{
		//get classname of entity
		new szClassname[12];
		entity_get_string(ent, EV_SZ_classname, szClassname, 11);
		
		//compare classnames
		if (equal(szClassname, "tele_start") || equal(szClassname, "tele_end"))
		{
			//entity is a teleport
			return true;
		}
	}
	
	//entity is not a teleport
	return false;
}

GrabTeleport(id, ent)
{
	new Float:fpOrigin[3];
	new Float:fbOrigin[3];
	new Float:fAiming[3];
	new iAiming[3];
	new bOrigin[3];
	
	//get players current view model then clear it
	entity_get_string(id, EV_SZ_viewmodel, gszViewModel[id], 32);
	entity_set_string(id, EV_SZ_viewmodel, "");
	
	get_user_origin(id, bOrigin, 1);			//position from eyes (weapon aiming)
	get_user_origin(id, iAiming, 3);			//end position from eyes (hit point for weapon)
	entity_get_vector(id, EV_VEC_origin, fpOrigin);		//get player position
	entity_get_vector(ent, EV_VEC_origin, fbOrigin);	//get block position
	IVecFVec(iAiming, fAiming);
	FVecIVec(fbOrigin, bOrigin);
	
	gGrabbedEnt[id] = ent + 1000000;
	gGrabOffset[id][0] = fbOrigin[0] - iAiming[0];
	gGrabOffset[id][1] = fbOrigin[1] - iAiming[1];
	gGrabOffset[id][2] = fbOrigin[2] - iAiming[2];
}

public cmdGrabOff(id) 
{
	new szAccessFlag[2];
	get_pcvar_string(gCvarAccessMove, szAccessFlag, 1);
	if ( !access(id, read_flags(szAccessFlag)) )
	{
		return PLUGIN_HANDLED;
	}
	
	UnGrab(id);
	
	return PLUGIN_HANDLED_MAIN;
}

public cmdBhopMenu(id) 
{
	if(get_user_flags(id) & ADMIN_LEVEL_A || get_pcvar_num(g_pCVAR_Access))
		menu_display(id, gMainMenu, 0);
	else
	{
		colorChat(id, _, "%sNo tenés acceso a este comando!", BCM_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_HANDLED;
}

public mnuSaveLoad(id, menu, item)
{
	if ( item == MENU_EXIT )
	{
		menu_display(id, gMainMenu, 0);
		return PLUGIN_CONTINUE;
	}
	
	new szCmd[3],  _access, callback;
	menu_item_getinfo(menu, item, _access, szCmd, 2, "", 0, callback);
	
	new cmd = str_to_num(szCmd);
	
	switch ( cmd )
	{
		case 1:
		{
			if( gLoadCFG ) colorChat(0, _, "%sNo podes guardar la config mientras se está cargando otra.", BCM_PREFIX);
			else
			{
				new szName[32];
				get_user_name(id, szName, 31);
				
				new iBlocks = Save();
				new iEnts = entity_count();
				
				colorChat(0, _, "%s!g%s!y guardó la CFG !g%s!y", BCM_PREFIX, szName, gCurConfig);
				colorChat(0, TERRORIST, "%sBloques: !g%d!y  -  Entidades del mapa: !g%d!y  -  Total: %s%d!y / !g512!y", BCM_PREFIX, iBlocks, iEnts - iBlocks, (iEnts < 512) ? "!g" : "!t", iEnts);
			}
		}
		case 2: // Load Config
		{
			if(!gLoadCFG) {
				new szTitle[49];
				format(szTitle, 48, "Menú de carga - Actual: %s", gCurConfig);
				
				new loadMenu = menu_create(szTitle, "mnuLoad", 0);
				
				new szAccessFlag[2];
				get_pcvar_string(gCvarAccessLoad, szAccessFlag, 1);
				new accessLoad = read_flags(szAccessFlag);
				
				new dir = open_dir(gDir, "", 0); // First file is always '.', right?
				
				new szFileName[33], bool:display;
				while ( next_file(dir, szFileName, 32) )
				{
					if ( szFileName[0] == '.' )
					{
						continue;
					}
					
					replace(szFileName, 32, ".txt", "");
					display = true;
					menu_additem(loadMenu, szFileName, "", accessLoad, -1);
				}
				close_dir(dir);
				
				menu_setprop(loadMenu, MPROP_EXITNAME, "Guardar/Cargar config");
				
				if ( display )
				{
					menu_display(id, loadMenu, 0);
					return PLUGIN_CONTINUE;
				}
				else
				{
					colorChat(id, _, "%sNo hay CFG para cargar!", BCM_PREFIX);
				}
			} else {
				colorChat(id, _, "%sNo podes cargar una CFG mientras se está cargando otra!", BCM_PREFIX);
			}
		}
		case 3: // Create Config
		{
			colorChat(id, _, "%sEscribí un nombre para la nueva CFG.", BCM_PREFIX);
			client_cmd(id, "messagemode bcm_newconfig");
		}
	}
	
	menu_display(id, menu, floatround(float(cmd) / 7, floatround_ceil)-1);
	
	return PLUGIN_CONTINUE;
}

public mnuMain(id, menu, item)
{
	if ( item == MENU_EXIT )
	{
		return PLUGIN_CONTINUE;
	}
	
	new szCmd[3],  _access, callback;
	menu_item_getinfo(menu, item, _access, szCmd, 2, "", 0, callback);
	
	new cmd = str_to_num(szCmd);
	
	new szPassword[64];
	get_cvar_string("sv_password", szPassword, charsmax(szPassword))
	
	if(cmd >= 5 && cmd <= 7 && !szPassword[0]) {
		colorChat(id, _, "%sEsta opción solo está habilitada mientras el servidor tenga contraseña", BCM_PREFIX);
		
		menu_display(id, gMainMenu, floatround(float(cmd) / 7, floatround_ceil)-1);
		
		return PLUGIN_HANDLED;
	}
	
	switch ( cmd )
	{
		case 1: // Build
		{
			menu_display(id, gBuildMenu, 0);
			return PLUGIN_CONTINUE;
		}
		case 2: // Modify
		{
			menu_display(id, gModifyMenu, 0);
			return PLUGIN_CONTINUE;
		}
		case 3: // Noclip
		{
			//set_pev(id, pev_movetype, pev(id, pev_movetype) == MOVETYPE_WALK ? MOVETYPE_NOCLIP : MOVETYPE_WALK);
			
			if( !szPassword[0] )
			{
				new szName[32]; get_user_name(id, szName, 31)
				
				if( get_user_noclip( id ) ) colorChat(0, CT, "%s!t%s dejó de usar el noclip.!y", BCM_PREFIX, szName);
				else colorChat(0, TERRORIST, "%s!t%s está usando el noclip.!y", BCM_PREFIX, szName);
			}
			
			set_user_noclip( id, get_user_noclip( id ) ? 0 : 1 )
		}
		case 4:
		{
			menu_display(id, gSaveLoadMenu, 0);
			return PLUGIN_CONTINUE;
		}
		case 5: {
			g_CP_Ok[id] = 1;
			
			entity_get_vector(id, EV_VEC_origin, g_CP_Pos[id]);
		} case 6: {
			if(g_CP_Ok[id]) {
				entity_set_vector(id, EV_VEC_velocity, Float:{0.0, 0.0, 0.0});
				entity_set_vector(id, EV_VEC_origin, g_CP_Pos[id]);
			}
		} case 7: {
			g_God[id] = !g_God[id];
			
			if(g_God[id]) {
				set_user_godmode(id, 1)
				colorChat(id, _, "%sAhora tenes godmode!", BCM_PREFIX);
			} else {
				set_user_godmode(id, 0)
				colorChat(id, _, "%sAhora no tenes godmode!", BCM_PREFIX);
			}
		}
	}
	
	menu_display(id, gMainMenu, floatround(float(cmd) / 7, floatround_ceil)-1);
	
	return PLUGIN_CONTINUE;
}

public mnuSetProperties(id, menu, item)
{
	if ( item == MENU_EXIT )
	{
		menu_destroy(menu);
		menu_display(id, gModifyMenu, 0);
		return PLUGIN_CONTINUE;
	}
	
	new ent = gSetPropertyInfo[id][1];
	new type = GetObjectType(ent);
	
	if(type == OBJECT_BHOP || type == OBJECT_ICEBHOP) {
		new Float:vecOrigin[3];
		
		entity_get_vector(id, EV_VEC_origin, vecOrigin);
		entity_set_vector(ent, EV_VEC_oldorigin, vecOrigin);
		
		menu_destroy(menu);
		menu_display(id, gModifyMenu, 0);
		
		return PLUGIN_HANDLED;
	}
	
	new szCmd[2], szItem[33], _access, callback;
	menu_item_getinfo(menu, item, _access, szCmd, 1, szItem, 32, callback);
	
	new property = str_to_num(szCmd);
	
	gSetPropertyInfo[id][0] = property;

	colorChat(id, _, "%sEscribí el nuevo valor de la propiedad.", BCM_PREFIX);
	client_cmd(id, "messagemode bcm_setproperty");
	
	if ( type == OBJECT_SPEEDBLOCK && property == 3 )
	{
		colorChat(id, CT, "%s!t1:!y Impuslsa en dirección a donde el jugador mira. !t2:!y Impulsa en dirección a donde el jugador se mueve.", BCM_PREFIX);
	}

	menu_display(id, gModifyMenu, 0);

	return PLUGIN_CONTINUE;
}

public mnuLoad(id, menu, item)
{
	if ( item == MENU_EXIT )
	{
		menu_destroy(menu);
		menu_display(id, gSaveLoadMenu, 0);
		return PLUGIN_CONTINUE;
	}
	
	new szItem[33], _access, callback;
	menu_item_getinfo(menu, item, _access, "", 0, szItem, 32, callback);
	
	Load(szItem);
	
	new enc = 0;
	new sConfig[33];
	new i = 0;
	while (!enc) 
	{
		GetConfigByNum(i,sConfig);
		if ( equal(sConfig,szItem,0))
		{
			enc = 1;
			gNumConfigActual = i;
		}
		i++;
	}
	
	new szName[32];
	get_user_name(id, szName, 32);
	
	colorChat(0, CT, "%s!t%s!y cargo la CFG !g%s!y", BCM_PREFIX, szName, szItem);
	
	menu_destroy(menu);
	menu_display(id, gSaveLoadMenu, 0);
	
	return PLUGIN_CONTINUE;
}

public mnuBuild(id, menu, item)
{
	if ( item == MENU_EXIT )
	{
		menu_display(id, gMainMenu, 0);
		return PLUGIN_CONTINUE;
	}
	
	new szCmd[3],  _access, callback;
	menu_item_getinfo(menu, item, _access, szCmd, 2, "", 0, callback);
	new type = str_to_num(szCmd);
	
	if(type == 12) {
		showMenu__CreateLongJump(id);
		return PLUGIN_HANDLED;
	}
	
	gChoseType[id] = type;
	
	ShowModelMenu(id, type);
	
	return PLUGIN_CONTINUE;
}

ShowModelMenu(id, type)
{
	new menu = menu_create("Modelos", "mnuModel", 0);
	menu_setprop(menu, MPROP_EXITNAME, "Crear Bloques");
	
	if(type != 7) {
		if ( strlen(gNORMALMODELS[type]) )
		{
			menu_additem(menu, "Normal", "1", 0, -1);
		}
		if ( strlen(gBIGMODELS[type]) )
		{
			menu_additem(menu, "Grande", "2", 0, -1);
		}
		if ( strlen(gTINYMODELS[type]) )
		{
			menu_additem(menu, "Chico", "3", 0, -1);
		}
		if ( strlen(gOTHERMODELS[type]) )
		{
			menu_additem(menu, "Otro", "4", 0, -1); // TODO: Might break shit
		}
	} else {
		menu_additem(menu, "TP INICIO", "1", 0, -1);
		menu_additem(menu, "TP DESTINO", "2", 0, -1);
	}

	menu_display(id, menu, 0);
}



public mnuModel(id, menu, item)
{
	if ( item == MENU_EXIT )
	{
		menu_destroy(menu);
		menu_display(id, gBuildMenu, 0);
		
		return PLUGIN_CONTINUE;
	}
	
	new szCmd[3],  _access, callback;
	new sItemName[32];
	menu_item_getinfo(menu, item, _access, szCmd, 2, sItemName, 31, callback);
	menu_destroy(menu);
	
	new Float:vOrigin[3];
	GetAimOrigin(id, vOrigin);
	vOrigin[2] += gUnitsMove[id];
	
	if(equal(sItemName, "TP INICIO") || equal(sItemName, "TP DESTINO")) {
		if(equal(sItemName, "TP INICIO")) {
			if(g_CreateTeleport[id]) {
				remove_entity(g_CreateTeleport[id]);
			}
			
			new ent = create_entity("info_target");
			
			entity_set_string(ent, EV_SZ_classname, "tele_start");
			entity_set_int(ent, EV_INT_solid, SOLID_BBOX);
			entity_set_int(ent, EV_INT_movetype, MOVETYPE_NONE);
			entity_set_model(ent, gszTeleportSpriteStart);
			entity_set_size(ent, gfTeleportSizeMin, gfTeleportSizeMax);
			entity_set_origin(ent, vOrigin);
			
			//set the rendermode and transparency
			entity_set_int(ent, EV_INT_rendermode, 5);	//rendermode
			entity_set_float(ent, EV_FL_renderamt, 255.0);	//visable 
			
			//set task for animating sprite
			new params[2];
			params[0] = ent;
			params[1] = gTeleportStartFrames;
			set_task(0.1, "taskSpriteNextFrame", TASK_SPRITE + ent, params, 2, "b");
			
			g_CreateTeleport[id] = ent;
		} else {
			if(g_CreateTeleport[id]) {
				new ent = create_entity("info_target");
				
				entity_set_string(ent, EV_SZ_classname, "tele_end");
				entity_set_int(ent, EV_INT_solid, SOLID_BBOX);
				entity_set_int(ent, EV_INT_movetype, MOVETYPE_NONE);
				entity_set_model(ent, gszTeleportSpriteEnd);
				entity_set_size(ent, gfTeleportSizeMin, gfTeleportSizeMax);
				entity_set_origin(ent, vOrigin);
				
				//set the rendermode and transparency
				entity_set_int(ent, EV_INT_rendermode, 5);	//rendermode
				entity_set_float(ent, EV_FL_renderamt, 255.0);	//visable 
				
				//link up teleport start and end entities
				entity_set_int(ent, EV_INT_iuser4, g_CreateTeleport[id]);
				entity_set_int(g_CreateTeleport[id], EV_INT_iuser4, ent);
				
				//set task for animating sprite
				new params[2];
				params[0] = ent;
				params[1] = gTeleportEndFrames;
				set_task(0.1, "taskSpriteNextFrame", TASK_SPRITE + ent, params, 2, "b");
			}
			
			g_CreateTeleport[id] = 0;
		}
		
		ShowModelMenu(id, gChoseType[id]);
		return PLUGIN_HANDLED;
	}
	
	new model = str_to_num(szCmd);
	
	if((gChoseType[id] == OBJECT_BHOP || gChoseType[id] == OBJECT_ICEBHOP) && model == MODEL_BIG) {
		ShowModelMenu(id, gChoseType[id]);
		return PLUGIN_HANDLED;
	}
	
	MakeObject(gChoseType[id], model, vOrigin,
		gDEFAULTPROPERTY1[gChoseType[id]],
		gDEFAULTPROPERTY2[gChoseType[id]],
		gDEFAULTPROPERTY3[gChoseType[id]],
		model == MODEL_BIG ? (Float:{0.0, 0.0, 90.0}) : (Float:{0.0, 0.0, 0.0}) );
	
	ShowModelMenu(id, gChoseType[id]);
	
	return PLUGIN_CONTINUE;
}

new const _UNITS[] = { 8, 9, 10, 15, 30, 50, 1, 2, 3, 4, 5, 6, 7 }

public show_menu_move(id)
{
	new szAccessFlag[2];
	get_pcvar_string(gCvarAccessMove, szAccessFlag, 1);
	new accessMove = read_flags(szAccessFlag);
	
	if( get_user_flags(id) & accessMove )
	{
		new Menue[900]
		new Longitud = 0
		
		Longitud += formatex( Menue[Longitud], 899 - Longitud, "\yMover^n^n" )
		
		Longitud += formatex( Menue[Longitud], 899 - Longitud, "\r1. \wZ+ Verde^n" )
		Longitud += formatex( Menue[Longitud], 899 - Longitud, "\r2. \wZ-^n" )
		Longitud += formatex( Menue[Longitud], 899 - Longitud, "\r3. \wX+ Rojo^n" )
		Longitud += formatex( Menue[Longitud], 899 - Longitud, "\r4. \wX-^n" )
		Longitud += formatex( Menue[Longitud], 899 - Longitud, "\r5. \wY+ Azul^n" )
		Longitud += formatex( Menue[Longitud], 899 - Longitud, "\r6. \wY-^n^n" )
		
		Longitud += formatex( Menue[Longitud], 899 - Longitud, "\r7. \wAumentar Unidades^n" )
		Longitud += formatex( Menue[Longitud], 899 - Longitud, "\r8. \wDisminuir Unidades^nUnidades a mover: \y%d", _UNITS[gUnitsMove[id]] )
		
		Longitud += formatex( Menue[Longitud], 899 - Longitud, "^n^n\r0. \wModificar" )
		
		show_menu( id, KeysMenu, Menue, -1, "ShowMenuGameAA" )
	}
}

public MenuGame(id, key)
{
	if( key == 6 )
	{
		if( gUnitsMove[id] >= 12 ) gUnitsMove[id] = 0
		else gUnitsMove[id]++
		
		show_menu_move(id)
		return PLUGIN_HANDLED;
	}
	else if( key == 7 )
	{
		if( gUnitsMove[id] <= 0 ) gUnitsMove[id] = 12
		else gUnitsMove[id]--
		
		show_menu_move(id)
		return PLUGIN_HANDLED;
	}
	else if( key == 9 )
	{
		menu_display(id, gModifyMenu, 0);
		remove_task(TASK_ID_SHOWXYZ + id, 0);
		
		return PLUGIN_HANDLED;
	}
	new ent = GetAimEnt(id);
	
	if ( !GetObjectType(ent) )
	{
		show_menu_move(id)
		return PLUGIN_HANDLED;
	}
	
	new Float:vOrigin[3];
	pev(ent, pev_origin, vOrigin);
	
	switch ( key )
	{
		case 0:
		{
			vOrigin[2] += float(_UNITS[gUnitsMove[id]]);
		}
		case 1:
		{
			vOrigin[2] -= float(_UNITS[gUnitsMove[id]]);
		}
		case 2:
		{
			vOrigin[0] += float(_UNITS[gUnitsMove[id]]);
		}
		case 3:
		{
			vOrigin[0] -= float(_UNITS[gUnitsMove[id]]);
		}
		case 4:
		{
			vOrigin[1] += float(_UNITS[gUnitsMove[id]]);
		}
		case 5:
		{
			vOrigin[1] -= float(_UNITS[gUnitsMove[id]]);
		}
	}
	
	SetOriginSnap(ent, vOrigin);
	
	show_menu_move(id)
	return PLUGIN_HANDLED;
}

public fwdTouch(ent, id)
{
	if ( !is_valid_ent(id) || !is_valid_ent(ent) )
		return FMRES_IGNORED;
	
	static szEntClass[6];
	pev(ent, pev_classname, szEntClass, 5);

	static szProperty1[33], szProperty2[33];
	
	if ( equal(szEntClass, "bcm_3", 0) )
	{
		new type = GetObjectType(ent);
		
		if ( is_user_alive(id) )
		{
			switch ( type )
			{
				/*case OBJECT_BHOP:
				{					
					#if defined BLOCKS_TOUCH
						if(gLastEnt[id] != ent)
						{
							remove_task(id+TASK_TOUCH1)
							
							set_task(1.0, "remove_lastent", id+TASK_TOUCH1)
							set_task(1.0, "set_slidebox", ent+TASK_TOUCH2)
							
							gLastEnt[id] = ent
							gfLastTouchEnt[id] = get_gametime()
						}
					#else
						if ( !task_exists(TASK_UNSOLID + ent, 0) && !task_exists(TASK_SOLID + ent, 0) )
						{
							set_task(0.1, "tskUnsolid", TASK_UNSOLID + ent, "", 0, "", 0);
						}
					#endif
					
					new iParams[1];
					iParams[0] = ent;
					
					set_task(0.1, "__setSolidNOT", id, iParams, 1);
					
					if(!task_exists(TASK_FIX_USER + id))
						set_task(1.1, "__checkWhereIsUser", TASK_FIX_USER + id);
				}*/
				case OBJECT_BOOSTBLOCK:
				{
					GetObjectProperty(ent, 1, szProperty1);
					new Float:fBoost = str_to_float(szProperty1);
					
					pev(id, pev_velocity, gSetVelocity[id]);
					
					gSetVelocity[id][2] = fBoost;
					
					set_pev(id, pev_watertype, CONTENTS_WATER);
				}
				case OBJECT_DELAYEDBHOP:
				{
					GetObjectProperty(ent, 1, szProperty1);
					new Float:fDelay = str_to_float(szProperty1);
					if ( !task_exists(TASK_UNSOLID + ent, 0)
					&& !task_exists(TASK_SOLID + ent, 0) )
					{
						set_task(fDelay, "tskUnsolid", TASK_UNSOLID + ent, "", 0, "", 0);
					}
				}
				case OBJECT_ICEBHOP:
				{
					set_pev(id, pev_fuser2, 0.0);
					
					/*#if defined BLOCKS_TOUCH
						if(gLastEnt[id] != ent)
						{
							remove_task(id+TASK_TOUCH1)
							
							set_task(1.0, "remove_lastent", id+TASK_TOUCH1)
							set_task(1.0, "set_slidebox", ent+TASK_TOUCH2)
							
							gLastEnt[id] = ent
							gfLastTouchEnt[id] = get_gametime()
						}
					#else
						if ( !task_exists(TASK_UNSOLID + ent, 0)
						&& !task_exists(TASK_SOLID + ent, 0) )
						{
							set_task(0.1, "tskUnsolid", TASK_UNSOLID + ent, "", 0, "", 0);
						}
					#endif*/
				}
				case OBJECT_FALLBLOCK:
				{
					set_pev(id, pev_watertype, CONTENTS_WATER);
				}
				case OBJECT_TELEPORT:
				{
					static Float:lastTouched[33];
					static lastDest[33];
					
					if ( lastDest[id] == ent )
					{ 
						if ( get_gametime() - lastTouched[id] > 1.0 ) lastDest[id] = 0;
						else lastTouched[id] = get_gametime();
					}
					else
					{
						GetObjectProperty(ent, 2, szProperty2);
						if ( strlen(szProperty2) )
						{
							new dest = GetObjectByProperty(1, szProperty2);
							if ( dest )
							{
								new Float:vOrigin[3];
								pev(dest, pev_origin, vOrigin);
								vOrigin[2] += 48.0;
								gSetVelocity[id] = Float:{0.0, 0.0, 0.000001};
								engfunc(EngFunc_SetOrigin, id, vOrigin);
			
								lastDest[id] = dest;
								lastTouched[id] = get_gametime();
							}
						}
					}
				}
				case OBJECT_FATALISBLOCK: // I have my own block
				{
					static Float:lastTouched[33];
		
					GetObjectProperty(ent, 1, szProperty1);
					GetObjectProperty(ent, 2, szProperty2);
					new Float:fDamage = str_to_float(szProperty1);
					new Float:fInterval = str_to_float(szProperty2); // TODO: Change new to static and use fuser1, fuser2 instead of strings, if possible
					
					if ( get_gametime() - lastTouched[id] > fInterval )
					{
						new Float:health;
						pev(id, pev_health, health);
						
						if ( health > fDamage )
						{
							if ( pev(id, pev_takedamage) ) set_pev(id, pev_health, health - fDamage);
						}
						else user_kill(id, 0);
						
						lastTouched[id] = get_gametime();
					}
				}
				case OBJECT_TINKBLOCK: // Tink is my girlfriend's internet alias
				{
					if( cs_get_user_team( id ) == CS_TEAM_T )
					{
						static Float:lastTouched[33];
			
						GetObjectProperty(ent, 1, szProperty1);
						GetObjectProperty(ent, 2, szProperty2);
						new iHeal = str_to_num(szProperty1);
						new Float:fInterval = str_to_float(szProperty2);
						
						if ( get_gametime() - lastTouched[id] > fInterval )
						{
							new health = get_user_health(id);
							if(health < 100)
							{
								if(health + iHeal >= 100) set_user_health(id, 100)
								else set_user_health(id, get_user_health(id) + iHeal)
							}
							
							lastTouched[id] = get_gametime();
						}
					}
				}
				case OBJECT_SPEEDBLOCK:
				{
					GetObjectProperty(ent, 1, szProperty1);
					GetObjectProperty(ent, 2, szProperty2);
					new szProperty3[33];
					GetObjectProperty(ent, 3, szProperty3);
					
					new dir = str_to_num(szProperty3);
					new speed = floatround(str_to_float(szProperty1));
					new Float:fBoost = str_to_float(szProperty2);
					
					if ( dir == 1 )
					{
						velocity_by_aim(id, speed, gSetVelocity[id]);
						gSetVelocity[id][2] = fBoost;
					}
					else if ( dir == 2)
					{
						set_speed(id, float(speed), 0, _);
						gSetVelocity[id][2] += fBoost;
					}
				}
				/*case OBJECT_YOURNEWBLOCK:
				{
					Edit here for adding new blocks
				}*/
			}
		}
		else
		{
			if ( type == OBJECT_TELEPORT )
			{
				new szClass[33];
				pev(id, pev_classname, szClass, 32);
				
				if ( equal(szClass, "grenade", 0) )
				{
					GetObjectProperty(ent, 2, szProperty2);
	      				if ( strlen(szProperty2) )
	      				{
	      					new dest = GetObjectByProperty(1, szProperty2);
	      					if ( dest )
	      					{
	      						new Float:vOrigin[3];
	      						pev(dest, pev_origin, vOrigin);
	      						vOrigin[2] += 48.0;
	      						engfunc(EngFunc_SetOrigin, id, vOrigin);
	      					}
	      				}
				}
			}
		}
	}
	
	return FMRES_IGNORED;
}

#if defined BLOCKS_TOUCH
	public fw_PlayerKilled(victim, attacker, shouldgib)
	{
		gLastEnt[victim] = 0
		gfLastTouchEnt[victim] = 0.0
		
		remove_task(victim + TASK_TOUCH1)
		remove_task(victim + TASK_TOUCH2)
	}
#endif

#if defined BLOCKS_TOUCH
	public remove_lastent(id)
	{
		id -= TASK_TOUCH1
		gLastEnt[id] = 0
	}
	public set_slidebox(ent)
	{
		ent -= TASK_TOUCH2
		
		if(is_valid_ent(ent))
		{
			set_pev(ent, pev_solid, SOLID_SLIDEBOX)
			set_pev(ent, pev_rendermode, kRenderNormal);
		}
	}
#endif


public tskUnsolid(ent)
{
	ent -= TASK_UNSOLID;
	
	if ( pev_valid(ent) )
	{
		set_pev(ent, pev_solid, SOLID_NOT);
		set_pev(ent, pev_rendermode, kRenderTransAdd);
		set_pev(ent, pev_renderamt, 100.0);
		
		set_task(1.0, "tskSolid", TASK_SOLID + ent, "", 0, "", 0);
	}
}
public tskSolid(ent)
{
	ent -= TASK_SOLID;
	
	if ( pev_valid(ent) )
	{
		set_pev(ent, pev_solid, SOLID_BBOX);
		set_pev(ent, pev_rendermode, kRenderNormal);
	}
}

public msgNewRound()
{
	static numRounds;
	numRounds++;
	if ( numRounds == 2 && GetNumConfigs() > 1 )
	{
		numRounds = 0;
		gLoadConfigOnNewRound[0] = '*';
		CargarSiguienteConfig()
	}
	
	if ( strlen(gLoadConfigOnNewRound) && gLoadConfigOnNewRound[0] != '*' )
	{
		Load(gLoadConfigOnNewRound);
		copy(gLoadConfigOnNewRound, 32, "");
	}
}

CargarSiguienteConfig()
{ 
	new szConfig[33];
	new CantCfg = GetNumConfigs();
	if ( ( CantCfg - 1 ) == gNumConfigActual )
	{
		GetConfigByNum(0,szConfig);
		gNumConfigActual = 0;
	}
	else
	{
		GetConfigByNum(gNumConfigActual+1,szConfig);
		gNumConfigActual++;
	}	
	Load(szConfig);
	copy(gCurConfig, 32, szConfig);
	return 1;
}

MakeObject(object, model, Float:vOrigin[3], const szProperty1[], const szProperty2[], const szProperty3[], Float:vAngles[3])
{
	new Float:vMins[3], Float:vMaxs[3];

	if ( (vOrigin[0] == 0.0
	&& vOrigin[1] == 0.0
	&& vOrigin[2] == 0.0)
	|| IsOriginNearSpawn(vMaxs, vOrigin) )
	{
		return 0;
	}
	else if ( GetObjectCount() >= get_pcvar_num(gCvarLimit) )
	{
		colorChat(0, _, "%sEl límite de %d bloques ha sido alcanzado.", BCM_PREFIX, get_pcvar_num(gCvarLimit));
		return PLUGIN_HANDLED;
	}
	
	GetObjectSizeByAngles(model, vAngles, vMins, vMaxs);
	
	if ( !IsOriginVacant(vMins, vMaxs, vOrigin) )
	{
		return 0;
	}
	
	new ent = engfunc(EngFunc_CreateNamedEntity, g_hStringInfoTarget);
	
	if ( !pev_valid(ent) )
	{
		return 0;
	}
	
	set_pev(ent, pev_classname, "bcm_3");
	set_pev(ent, pev_solid, (object == OBJECT_BHOP || object == OBJECT_ICEBHOP) ? SOLID_BBOX : SOLID_SLIDEBOX);
	set_pev(ent, pev_movetype, MOVETYPE_NONE);
	set_pev(ent, pev_iuser1, object);
	set_pev(ent, pev_iuser2, model);
	
	entity_set_int(ent, EV_INT_iuser3, 0);
	entity_set_int(ent, EV_INT_team, 0);
	
	switch ( model )
	{
		case MODEL_NORMAL: engfunc(EngFunc_SetModel, ent, gNORMALMODELS[object]); // Potential crash
		case MODEL_BIG: engfunc(EngFunc_SetModel, ent, gBIGMODELS[object]);
		case MODEL_TINY: engfunc(EngFunc_SetModel, ent, gTINYMODELS[object]);
		case MODEL_OTHER: engfunc(EngFunc_SetModel, ent, gOTHERMODELS[object]);
	}
	
	set_pev(ent, pev_angles, vAngles);
	
	engfunc(EngFunc_SetSize, ent, vMins, vMaxs);
	
	SetOriginSnap(ent, vOrigin);
	
	if ( object == OBJECT_TELEPORT )
	{
		set_pev(ent, pev_rendermode, kRenderTransAdd);
		set_pev(ent, pev_renderamt, 255.0);
		
		SetObjectProperty(ent, 1, szProperty1);
	}
	else if (object == OBJECT_WINDOWBLOCK )
	{
		set_pev(ent, pev_rendermode, kRenderTransTexture);
		set_pev(ent, pev_renderamt, str_to_float(szProperty1));
		
		SetObjectProperty(ent, 1, szProperty1);
	}
	else if(object == OBJECT_BHOP || object == OBJECT_ICEBHOP) {
		entity_set_int(ent, EV_INT_iuser4, 1337);
		
		entity_set_int(ent, EV_INT_team, 1);
		
		if(gLoadCFG && !g_CheckBHops) {
			static sX[10], sY[10], sZ[10], Float:vecOrigin[3];
			parse(szProperty1, sX, 9, sY, 9, sZ, 9);
			
			vecOrigin[0] = str_to_float(sX);
			vecOrigin[1] = str_to_float(sY);
			vecOrigin[2] = str_to_float(sZ);
			
			entity_set_vector(ent, EV_VEC_oldorigin, vecOrigin);
			
			if(vecOrigin[0] == 0.0 && vecOrigin[1] == 0.0 && vecOrigin[2] == 0.0) {
				colorChat(0, _, "%sEl bloque #%d no tiene bhop fail, se marco con contorno blanco para arreglarlo!", BCM_PREFIX, ent);
				fm_set_rendering(ent, kRenderFxGlowShell, 255, 255, 255, kRenderNormal, 4);
			}
		} else {
			checkDoors(ent, model);
		}
	} else {
		SetObjectProperty(ent, 1, szProperty1);
	}
	
	SetObjectProperty(ent, 2, szProperty2);
	SetObjectProperty(ent, 3, szProperty3);
	
	return ent;
}

GetAimOrigin(id, Float:vOrigin[3])
{
	new Float:vStart[3], Float:vViewOfs[3], Float:vDest[3];
	
	pev(id, pev_origin, vStart);
	pev(id, pev_view_ofs, vViewOfs);
	
	vStart[0] += vViewOfs[0];
	vStart[1] += vViewOfs[1];
	vStart[2] += vViewOfs[2];
	
	pev(id, pev_v_angle, vDest);
	engfunc(EngFunc_MakeVectors, vDest);
	global_get(glb_v_forward, vDest);
	
	vDest[0] *= 9999.0;
	vDest[1] *= 9999.0;
	vDest[2] *= 9999.0;
	
	vDest[0] += vStart[0];
	vDest[1] += vStart[1];
	vDest[2] += vStart[2];

	engfunc(EngFunc_TraceLine, vStart, vDest, 0, id, 0);
	get_tr2(0, TR_vecEndPos, vOrigin);

	return 1;
}

GetAimEnt(id)
{
	new Float:vStart[3], Float:vViewOfs[3], Float:vDest[3];
	
	pev(id, pev_origin, vStart);
	pev(id, pev_view_ofs, vViewOfs);
	
	vStart[0] += vViewOfs[0];
	vStart[1] += vViewOfs[1];
	vStart[2] += vViewOfs[2];
	
	pev(id, pev_v_angle, vDest);
	engfunc(EngFunc_MakeVectors, vDest);
	global_get(glb_v_forward, vDest);
	
	vDest[0] *= 9999.0;
	vDest[1] *= 9999.0;
	vDest[2] *= 9999.0;
	
	vDest[0] += vStart[0];
	vDest[1] += vStart[1];
	vDest[2] += vStart[2];

	engfunc(EngFunc_TraceLine, vStart, vDest, DONT_IGNORE_MONSTERS, id, 0);
	
	new ent = get_tr2(0, TR_pHit);
	
	if ( !pev_valid(ent) )
	{
		new Float:vOrigin[3];
		GetAimOrigin(id, vOrigin);
		
		new szClass[12];
		ent = gMaxPlayers;
		
		while ( (ent = engfunc(EngFunc_FindEntityInSphere, ent, vOrigin, 8.0)) )
		{
			pev(ent, pev_classname, szClass, 11);
			if ( equal(szClass, "bcm_3") || equal(szClass, "tele_start") || equal(szClass, "tele_end") )
			{				
				if(equal(szClass, "tele_start") || equal(szClass, "tele_end"))
					return ent + 1000000;
				
				return ent;
			}
		}
		
		return 0;
	}
	
	return ent;
}

SetOriginSnap(ent, Float:vOrigin[3])
{
	new id = entity_get_edict( ent, EV_ENT_owner )
	
	vOrigin[0] = vOrigin[0] / float(_UNITS[gUnitsMove[id]]) * float(_UNITS[gUnitsMove[id]]);
	vOrigin[1] = vOrigin[1] / float(_UNITS[gUnitsMove[id]]) * float(_UNITS[gUnitsMove[id]]);
	vOrigin[2] = vOrigin[2] / float(_UNITS[gUnitsMove[id]]) * float(_UNITS[gUnitsMove[id]]);
	
	new model = GetObjectModelType(ent);
	if ( !model )
	{
		return 0;
	}
	
	static Float:vMins[3], Float:vMaxs[3];
	pev(ent, pev_mins, vMins);
	pev(ent, pev_maxs, vMaxs);
	
	if ( !IsOriginNearSpawn(vMaxs, vOrigin)	&& IsOriginVacant(vMins, vMaxs, vOrigin) )
	{		
		// TODO: Make all of this better
		engfunc(EngFunc_SetOrigin, ent, vOrigin);
		
		// TODO: This was broken after changing model way, fix it
		new type = GetObjectType(ent);
		if ( !type )
		{
			return 0;
		}
		
		set_pev(ent, pev_renderfx, kRenderFxNone);
	}
	else
	{
		return 0;
	}
	
	return 1;
}

bool:IsOriginNearSpawn(Float:vMaxs[3], Float:vOrigin[3])
{
	new ent;
	new szClass[23];
	
	new Float:fDistance = floatsqroot(floatpower(vMaxs[0], 2.0) * floatpower(vMaxs[1], 2.0));
	fDistance = floatsqroot(floatpower(fDistance, 2.0) * floatpower(vMaxs[2], 2.0));
	
	new Float:vTemp[3], Float:vCorner1[3], Float:vCorner2[3];
	
	new Float:vTrace[3];
	for(new i = 0; i < 8; i++)
	{
		switch(i)
		{
		case 0, 4: { vTrace[0] = vOrigin[0] - 36.0; vTrace[1] = vOrigin[1] - 36.0; }
		case 1, 5: { vTrace[0] = vOrigin[0] + 36.0; vTrace[1] = vOrigin[1] - 36.0; }
		case 2, 6: { vTrace[0] = vOrigin[0] - 36.0; vTrace[1] = vOrigin[1] + 36.0; }
		case 3, 7: { vTrace[0] = vOrigin[0] + 36.0; vTrace[1] = vOrigin[1] + 36.0; }
		}
		
		vTrace[2] = i > 3 ? vOrigin[2] + 1.0 : vOrigin[2] - 1.0;
		
		while ( (ent = engfunc(EngFunc_FindEntityInSphere, ent, vTrace, fDistance)) )
		{
			pev(ent, pev_classname, szClass, 22);
			
			if ( equal(szClass, "info_player_start", 0)	|| equal(szClass,"info_player_deathmatch", 0) )
			{
				pev(ent, pev_origin, vTemp);
				
				vCorner1[0] = vTemp[0] - 16.0;
				vCorner1[1] = vTemp[1] - 16.0;
				vCorner1[2] = vTemp[2] - 36.0;
				
				vCorner2[0] = vTemp[0] + 16.0;
				vCorner2[1] = vTemp[1] + 16.0;
				vCorner2[2] = vTemp[2] + 48.0;
				
				if((vCorner1[0] <= vTrace[0] <= vCorner2[0])
				&& (vCorner1[1] <= vTrace[1] <= vCorner2[1])
				&& (vCorner1[2] <= vTrace[2] <= vCorner2[2]))
				{
					return true;
				}
			}
		}
	}
	
	return false;
}

GetObjectType(ent)
{
	new szClass[6];
	pev(ent, pev_classname, szClass, 5);
	
	if ( !equal(szClass, "bcm_3", 0) )
	{
		return 0;
	}

	return pev(ent, pev_iuser1);
}

GetObjectModelType(ent)
{
	if ( !GetObjectType(ent) ) { return 0; } // TODO: Change this and above
	
	return pev(ent, pev_iuser2);
}

Save() // save_f
{
	new ent = gMaxPlayers, type, szData[512], Float:vOrigin[3], count, modelType;
	new szPath[129];
	new Float:vecOldOrigin[3];
	
	formatex(szPath, 128, "%s/%s.txt", gDir, gCurConfig);
	
	delete_file(szPath);
	
	new f = fopen(szPath, "at");
	
	new szProperty1[33], szProperty2[33], szProperty3[33], Float:vAngles[3];
	while ( (ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "bcm_3")) )
	{
		count++;
		
		type = GetObjectType(ent);
		pev(ent, pev_origin, vOrigin);
		pev(ent, pev_angles, vAngles);
		
		modelType = GetObjectModelType(ent);
		GetObjectProperty(ent, 1, szProperty1);
		GetObjectProperty(ent, 2, szProperty2);
		GetObjectProperty(ent, 3, szProperty3);
		
		if(type == OBJECT_BHOP || type == OBJECT_ICEBHOP) {
			entity_get_vector(ent, EV_VEC_oldorigin, vecOldOrigin);
			
			formatex(szData, 511, "^"%s^" %i %i %i ^"GAM!NGA^" ^"%s^" ^"%f %f %f^" ^"%s^" ^"%s^" ^"^" ^"^" %i %i^n",
				gOBJECTSAVENAMES[type], floatround(vOrigin[0]), floatround(vOrigin[1]), floatround(vOrigin[2]), 
				gMODELTYPESAVENAMES[modelType], vecOldOrigin[0], vecOldOrigin[1], vecOldOrigin[2], szProperty2, szProperty3,
				floatround(vAngles[0]), floatround(vAngles[2]));
		} else {
			formatex(szData, 511, "^"%s^" %i %i %i ^"GAM!NGA^" ^"%s^" ^"%s^" ^"%s^" ^"%s^" ^"^" ^"^" %i %i^n",
				gOBJECTSAVENAMES[type], floatround(vOrigin[0]), floatround(vOrigin[1]), floatround(vOrigin[2]), 
				gMODELTYPESAVENAMES[modelType], szProperty1, szProperty2, szProperty3,
				floatround(vAngles[0]), floatround(vAngles[2]));
		}
		
		fputs(f, szData);
	}
	
	new ent2 = gMaxPlayers;
	
	ent = gMaxPlayers
	while ( (ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "tele_start")) )
	{
		entity_get_vector(ent, EV_VEC_origin, vOrigin);
		pev(ent, pev_angles, vAngles);
		
		formatex(szData, 511, "^"tele_start^" %i %i %i ^"other^" ^"^" ^"^" ^"^" %i %i^n",
			floatround(vOrigin[0]), floatround(vOrigin[1]), floatround(vOrigin[2]), 
			floatround(vAngles[0]), floatround(vAngles[2]));
		
		count++
		
		while ( (ent2 = engfunc(EngFunc_FindEntityByString, ent2, "classname", "tele_end")) )
		{
			fputs(f, szData);
			
			entity_get_vector(ent2, EV_VEC_origin, vOrigin);
			pev(ent2, pev_angles, vAngles);
			
			formatex(szData, 511, "^"tele_end^" %i %i %i ^"other^" ^"^" ^"^" ^"^" %i %i^n",
				floatround(vOrigin[0]), floatround(vOrigin[1]), floatround(vOrigin[2]), 
				floatround(vAngles[0]), floatround(vAngles[2]));
			
			fputs(f, szData);
			
			count++
			
			break;
		}
	}
	
	fclose(f);
	
	return count;
}

Load(const szConfigName[])
{
	DeleteAll();
	
	g_count_bcm = 0;
	
	gLoadCFG = 1;
	gStartLoadAtIndex = 0;
	set_task(1.5, "tskLoad", TASK_ID_LOAD, szConfigName, 32, "b", 0);
	
	return 1;
}

public DeleteAll()
{
	new ent = gMaxPlayers, count;
	while ( (ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "bcm_3")) )
	{
		if ( count++ >= 100 )
		{
			set_task(0.2, "DeleteAll");
			return;
		}
		
		remove_entity(ent);
		//set_pev(ent, pev_flags, FL_KILLME);
	}
	
	ent = gMaxPlayers
	while ( (ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "tele_start")) )
	{
		if(task_exists(TASK_SPRITE + ent))
			remove_task(TASK_SPRITE + ent);
		
		remove_entity(ent);
		//set_pev(ent, pev_flags, FL_KILLME);
	}
	
	ent = gMaxPlayers
	while ( (ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "tele_end")) )
	{
		if(task_exists(TASK_SPRITE + ent))
			remove_task(TASK_SPRITE + ent);
		
		remove_entity(ent);
		//set_pev(ent, pev_flags, FL_KILLME);
	}
}

public tskLoad(const szConfigName[]) // load_f
{
	remove_task(TASK_ID_LOAD, 0);
	
	new szData[512], szType[33], szX[6], szY[6], szZ[6], szModelType[11], sCreator[64];
	new szProperty1[64], szProperty2[33], szProperty3[33], szProperty4[33], szProperty5[33], szAngleX[5], szAngleZ[5];
	new Float:vOrigin[3], Float:vAngles[3];
	new type, modelType;
	
	new szPath[129];
	format(szPath, 128, "%s/%s.txt", gDir, szConfigName);
	
	if ( !file_exists(szPath) )
	{
		return 0;
	}
	
	copy(gCurConfig, 32, szConfigName);
	
	new allCount, lineCount;
	new f = fopen(szPath, "rt");
	new ent;
	new ent_end;
	new params[2];
	
	while ( !feof(f) )
	{
		if ( allCount < gStartLoadAtIndex )
		{
			fgets(f, "", 0);
			allCount++;
			continue;
		}
		
		if ( lineCount >= 24 )
		{
			gStartLoadAtIndex = allCount;
			set_task(0.5, "tskLoad", TASK_ID_LOAD, szConfigName, 32, "", 0);
			fclose(f);
			return PLUGIN_CONTINUE;
		}
		
		allCount++;
		lineCount++;
		
		fgets(f, szData, 511);
		
		if ( !strlen(szData) )
		{
			continue;
		}
		
		parse(szData, szType, 32);
		
		if(equal(szType, "tele_start")) {
			parse(szData, "", 0, szX, 5, szY, 5, szZ, 5, sCreator, 63, szModelType, 10, szProperty1, 63, szProperty2, 32, szProperty3, 32, szProperty4, 32, szProperty5, 32, szAngleX, 4, szAngleZ, 4);
			vOrigin[0] = str_to_float(szX);
			vOrigin[1] = str_to_float(szY);
			vOrigin[2] = str_to_float(szZ);
			
			ent = create_entity("info_target");
			
			entity_set_string(ent, EV_SZ_classname, "tele_start");
			entity_set_int(ent, EV_INT_solid, SOLID_BBOX);
			entity_set_int(ent, EV_INT_movetype, MOVETYPE_NONE);
			entity_set_model(ent, gszTeleportSpriteStart);
			entity_set_size(ent, gfTeleportSizeMin, gfTeleportSizeMax);
			entity_set_origin(ent, vOrigin);
			
			//set the rendermode and transparency
			entity_set_int(ent, EV_INT_rendermode, 5);	//rendermode
			entity_set_float(ent, EV_FL_renderamt, 255.0);	//visable 
			
			//set task for animating sprite
			params[0] = ent;
			params[1] = gTeleportStartFrames;
			set_task(0.1, "taskSpriteNextFrame", TASK_SPRITE + ent, params, 2, "b");
			
			ent_end = ent;
			
			g_count_bcm++;
		} else if(equal(szType, "tele_end")) {
			parse(szData, "", 0, szX, 5, szY, 5, szZ, 5, sCreator, 63, szModelType, 10, szProperty1, 63, szProperty2, 32, szProperty3, 32, szProperty4, 32, szProperty5, 32, szAngleX, 4, szAngleZ, 4);
			vOrigin[0] = str_to_float(szX);
			vOrigin[1] = str_to_float(szY);
			vOrigin[2] = str_to_float(szZ);
			
			if(ent_end) {
				ent = create_entity("info_target");
				
				entity_set_string(ent, EV_SZ_classname, "tele_end");
				entity_set_int(ent, EV_INT_solid, SOLID_BBOX);
				entity_set_int(ent, EV_INT_movetype, MOVETYPE_NONE);
				entity_set_model(ent, gszTeleportSpriteEnd);
				entity_set_size(ent, gfTeleportSizeMin, gfTeleportSizeMax);
				entity_set_origin(ent, vOrigin);
				
				//set the rendermode and transparency
				entity_set_int(ent, EV_INT_rendermode, 5);	//rendermode
				entity_set_float(ent, EV_FL_renderamt, 255.0);	//visable 
				
				//link up teleport start and end entities
				entity_set_int(ent, EV_INT_iuser4, ent_end);
				entity_set_int(ent_end, EV_INT_iuser4, ent);
				
				//set task for animating sprite
				params[0] = ent;
				params[1] = gTeleportEndFrames;
				set_task(0.1, "taskSpriteNextFrame", TASK_SPRITE + ent, params, 2, "b");
				
				g_count_bcm++;
				
				ent_end = 0;
			}
		} else {
			type = GetTypeBySaveName(szType);
			if ( type )
			{
				parse(szData, "", 0, szX, 5, szY, 5, szZ, 5, sCreator, 63, szModelType, 10, szProperty1, 63, szProperty2, 32, szProperty3, 32, szProperty4, 32, szProperty5, 32, szAngleX, 4, szAngleZ, 4);
				vOrigin[0] = str_to_float(szX);
				vOrigin[1] = str_to_float(szY);
				vOrigin[2] = str_to_float(szZ);
				vAngles[0] = str_to_float(szAngleX);
				vAngles[2] = str_to_float(szAngleZ);
				
				modelType = GetModelTypeBySaveName(szModelType);
				g_count_bcm++;
				
				MakeObject(type, modelType, vOrigin, szProperty1, szProperty2, szProperty3, vAngles); // TODO: Add
			}
		}
	}
	
	colorChat(0, _, "%sSe cargó exitosamente la CFG !g%s!y con !g%d bloques!y.", BCM_PREFIX, szConfigName, g_count_bcm);
	gLoadCFG = 0;

	fclose(f);
	
	return PLUGIN_CONTINUE;
}

GetObjectCount()
{
	new ent = gMaxPlayers, i;
	while ( (ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "bcm_3")) )
	{
		i++;
	}
	
	while ( (ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "tele_start")) )
	{
		i++;
	}
	
	while ( (ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "tele_end")) )
	{
		i++;
	}
	
	return i;
}

public fwdPlayerPreThink(id)
{
	if(!is_user_alive(id))
		return;
	
	// emp
	if ( (gSetVelocity[id][0] != 0.0
	|| gSetVelocity[id][1] != 0.0
	|| gSetVelocity[id][2] != 0.0)
	&& is_user_alive(id) )
	{
		set_pev(id, pev_velocity, gSetVelocity[id]);
		gSetVelocity[id][0] = 0.0;
		gSetVelocity[id][1] = 0.0;
		gSetVelocity[id][2] = 0.0;
	}
	
	static ent;
	
	if( ( pev( id, pev_flags  ) & FL_ONGROUND ) && !pev( id, pev_solid ) )
	{
		static Float:orig[3]
		entity_get_vector( id, EV_VEC_origin, orig )
		
		//do a hull trace 1 unit below their origin
		orig[2] -= 1
		engfunc( EngFunc_TraceHull, orig, orig, DONT_IGNORE_MONSTERS, HULL_HUMAN, id, 0 )
		ent = get_tr2( 0, TR_pHit )
		
		//if all we hit is world or another player, who cares, exit
		if( ent > gMaxPlayers ) {
			//if we hit a door in the array, send it to the handler then exit
			if(entity_get_int(ent, EV_INT_team)) {
				if(pev(id, pev_groundentity) == ent) {
					bhop_check_fail( id, ent )
				}
			}
		}
	}
	
	ent = gGrabbedEnt[id];
	if(ent >= 1000000) {
		moveGrabbedEntity(id);
	}
	else if ( ent ) {
		new iBlock = entity_get_int(ent, EV_INT_iuser3);
		
		if(!iBlock) {
			MoveGrabbedEnt(id, ent, _);
		} else {
			new Float:vMoveTo[3];
			new Float:vOffset[3];
			new Float:vOrigin[3];
			
			MoveGrabbedEnt(id, ent, vMoveTo);
			
			entity_get_vector(iBlock, EV_VEC_vuser1, vOffset);
			
			vOrigin[0] = vMoveTo[0] - vOffset[0];
			vOrigin[1] = vMoveTo[1] - vOffset[1];
			vOrigin[2] = vMoveTo[2] - vOffset[2];
			
			//move grouped block
			entity_set_origin(iBlock, vOrigin);
		}
	}
	
	#if defined BLOCKS_TOUCH
		if( is_user_alive(id) )
		{
			if( is_valid_ent(gLastEnt[id]) && gLastEnt[id] )
			{		
				if(get_gametime() > gfLastTouchEnt[id]+0.1)
				{
					set_pev(gLastEnt[id], pev_solid, SOLID_NOT)
				}
				else
				{
					set_pev(gLastEnt[id], pev_solid, SOLID_SLIDEBOX)
					set_pev(gLastEnt[id], pev_rendermode, kRenderNormal);
				}
			}
		}
	#endif
	
	static Float:vOrigin[3];
	new bool:entNear = false;
	static tele;
	static entinsphere;
	static szClassname[32];
	
	//find all teleport start entities in map and if a player is close to one, teleport the player
	ent = 0;
	while ((ent = find_ent_by_class(ent, "tele_start")))
	{
		if(entity_get_int(ent, EV_INT_iuser4)) {
			entity_get_vector(ent, EV_VEC_origin, vOrigin);
			
			//teleport players and grenades within a sphere around the teleport start entity
			entinsphere = -1;
			while ((entinsphere = find_ent_in_sphere(entinsphere, vOrigin, 32.0)))
			{
				//get classname of entity
				entity_get_string(entinsphere, EV_SZ_classname, szClassname, 32);
				
				//if entity is a player
				if (entinsphere > 0 && entinsphere <= 32)
				{
					//only teleport player if they're alive
					if (is_user_alive(entinsphere))
					{
						//teleport the player
						actionTeleport(entinsphere, ent);
					}
				}
				//or if entity is a grenade
				else if (equal(szClassname, "grenade"))
				{
					//get the end of the teleport
					tele = entity_get_int(ent, EV_INT_iuser4);
					
					//if the end of the teleport exists
					if (tele)
					{
						//set the end of the teleport to be not solid
						entity_set_int(tele, EV_INT_solid, SOLID_NOT);	//can't be grabbed or deleted
						
						//teleport the grenade
						actionTeleport(entinsphere, ent);
						
						//set a time in the teleport it will become solid after 2 seconds
						entity_set_float(tele, EV_FL_ltime, halflife_time() + 2.0);
					}
				}
			}
		}
	}
	
	//make teleporters SOLID_NOT when players are near them
	while ((ent = find_ent_by_class(ent, "tele_end")))
	{
		//get the origin of the teleport end entity
		entity_get_vector(ent, EV_VEC_origin, vOrigin);
		
		//compare this origin with all player and grenade origins
		entinsphere = -1;
		while ((entinsphere = find_ent_in_sphere(entinsphere, vOrigin, 64.0)))
		{
			//get classname of entity
			entity_get_string(entinsphere, EV_SZ_classname, szClassname, 32);
			
			//if entity is a player
			if (entinsphere > 0 && entinsphere <= 32)
			{
				//make sure player is alive
				if (is_user_alive(entinsphere))
				{
					entNear = true;
					
					break;
				}
			}
			//or if entity is a grenade
			else if (equal(szClassname, "grenade"))
			{
				entNear = true;
				
				break;
			}
		}
		
		//set the solid type of the teleport end entity depending on whether or not a player is near
		if (entNear)
		{
			//only do this if it is not being grabbed
			entity_set_int(ent, EV_INT_solid, SOLID_NOT);	//can't be grabbed or deleted
		}
		else
		{
			//get time from teleport end entity to check if it can go solid
			new Float:fTime = entity_get_float(ent, EV_FL_ltime);
			
			//only set teleport end entity to solid if its 'solid not' time has elapsed
			if (halflife_time() >= fTime)
			{
				entity_set_int(ent, EV_INT_solid, SOLID_BBOX);	//CAN be grabbed and deleted
			}
		}
	}
	
	return;
}

#if defined BLOCKS_TOUCH
	public FwdPlayerPostThink(id)
	{
		if(is_user_alive(id) && is_valid_ent(gLastEnt[id]) && gLastEnt[id])
		{
			static Float:gravity
			pev(gLastEnt[id], pev_gravity, gravity);
			set_pev(gLastEnt[id], pev_solid, SOLID_SLIDEBOX)
			set_pev(gLastEnt[id], pev_rendermode, kRenderNormal);
			set_pev(gLastEnt[id], pev_gravity, gravity)
		}
		return FMRES_IGNORED
	}

	stock is_number_into(value, num1, num2)
	{
		if( value >= num1 && value <= num2 )
			return true;
			
		return false;
	}
#endif

MoveGrabbedEnt(id, ent, Float:vNewOrigin[3] = {0.0, 0.0, 0.0})
{
	if ( !pev_valid(ent) )
	{
		colorChat(id, _, "%sEl objeto que estaba seleccionado no existe más.", BCM_PREFIX);
		UnGrab(id);
	} else {
		static button, oldButtons;
		button = pev(id, pev_button);
		oldButtons = pev(id, pev_oldbuttons);
		if ( button&IN_JUMP && !(oldButtons&IN_JUMP) )
		{
			if ( gGrabLength[id] > 96.0 )
				gGrabLength[id] -= 32.0;
		}
		else if ( button&IN_DUCK && !(oldButtons&IN_DUCK) )
			gGrabLength[id] += 32.0;
		
		new iOrigin[3], iLook[3];
		get_user_origin(id, iOrigin, 1);
		get_user_origin(id, iLook, 3);
		
		new Float:vOrigin[3], Float:vLook[3];
		IVecFVec(iOrigin, vOrigin);
		IVecFVec(iLook, vLook);
		
		new Float:vDirection[3], Float:fLength;
		vDirection[0] = vLook[0] - vOrigin[0];
		vDirection[1] = vLook[1] - vOrigin[1];
		vDirection[2] = vLook[2] - vOrigin[2];
		fLength = get_distance_f(vLook, vOrigin);
		
		vNewOrigin[0] = (vOrigin[0] + vDirection[0] * gGrabLength[id] / fLength) + gGrabOffset[id][0];
		vNewOrigin[1] = (vOrigin[1] + vDirection[1] * gGrabLength[id] / fLength) + gGrabOffset[id][1];
		vNewOrigin[2] = (vOrigin[2] + vDirection[2] * gGrabLength[id] / fLength) + gGrabOffset[id][2];
		vNewOrigin[2] = float(floatround(vNewOrigin[2], floatround_floor));
		
		static Float:vOldOrigin[3];
		pev(ent, pev_origin, vOldOrigin);
		
		static Float:vOffset[3];
		vOffset[0] = vNewOrigin[0] - vOldOrigin[0];
		vOffset[1] = vNewOrigin[1] - vOldOrigin[1];
		vOffset[2] = vNewOrigin[2] - vOldOrigin[2];
		
		SetOriginSnap(ent, vNewOrigin);
	}
}

Grab(id, ent)
{
	new Float:vPlayerOrigin[3], Float:vEntOrigin[3];
	pev(id, pev_origin, vPlayerOrigin);
	pev(ent, pev_origin, vEntOrigin);
	
	new ent2, body;
	gGrabLength[id] = get_user_aiming(id, ent2, body, 9999);
	
	if( ent != ent2 )
	{
		gGrabLength[id] = get_distance_f(vPlayerOrigin, vEntOrigin);
	}
	
	gGrabbedEnt[id] = ent;
	
	new Float:fAiming[3];
	new iAiming[3];
	new bOrigin[3];
	
	get_user_origin(id, bOrigin, 1);
	get_user_origin(id, iAiming, 3);
	IVecFVec(iAiming, fAiming);
	FVecIVec(vEntOrigin, bOrigin);
	
	gGrabOffset[id][0] = vEntOrigin[0] - iAiming[0];
	gGrabOffset[id][1] = vEntOrigin[1] - iAiming[1];
	gGrabOffset[id][2] = vEntOrigin[2] - iAiming[2];
	
	new iBlock = entity_get_int(ent, EV_INT_iuser3);
	if(iBlock) {
		new Float:vGrabbedOrigin[3];
		new Float:vOrigin[3];
		new Float:vOffset[3];
		
		entity_get_vector(ent, EV_VEC_origin, vGrabbedOrigin);
		entity_get_vector(iBlock, EV_VEC_origin, vOrigin);
		
		//calculate offset from grabbed block
		vOffset[0] = vGrabbedOrigin[0] - vOrigin[0];
		vOffset[1] = vGrabbedOrigin[1] - vOrigin[1];
		vOffset[2] = vGrabbedOrigin[2] - vOrigin[2];
		
		entity_set_vector(iBlock, EV_VEC_vuser1, vOffset);
	}
}

UnGrab(id)
{
	if(gGrabbedEnt[id] < 1000000) {
		static object;
		object = GetObjectType(gGrabbedEnt[id]);
		
		if(object == OBJECT_BHOP || object == OBJECT_ICEBHOP) {
			checkDoors(gGrabbedEnt[id], GetObjectModelType(gGrabbedEnt[id]));
		}
	}
	
	gGrabbedEnt[id] = 0;
	
	if(gszViewModel[id][0])
		entity_set_string(id, EV_SZ_viewmodel, gszViewModel[id]);
}

// public tskShowXYZ(id)
// {
	// id -= TASK_ID_SHOWXYZ;
	
	// if ( !is_user_connected(id) )
	// {
		// remove_task(TASK_ID_SHOWXYZ + id, 0);
		
		// return PLUGIN_CONTINUE;
	// }
	
	// static Float:vAim[3];
	// velocity_by_aim(id, 64, vAim);
	
	// static Float:vOrigin[3];
	// pev(id, pev_origin, vOrigin);
	
	// vOrigin[0] += vAim[0];
	// vOrigin[1] += vAim[1];
	// vOrigin[2] += vAim[2];
	
	// vOrigin[2] += 16.0;
	
	// static origin[3], origin2[3];
	// FVecIVec(vOrigin, origin);
	
	// origin2 = origin;
	
	// origin[0] += 16;
	// MakeSprite(id, origin, origin2, {255, 0, 0});
	
	// origin[0] -= 16;
	// origin[1] += 16;
	// MakeSprite(id, origin, origin2, {0, 0, 255});
	
	// origin[1] -= 16;
	// origin[2] += 16;
	// MakeSprite(id, origin, origin2, {0, 255, 0});
	
	// return PLUGIN_CONTINUE;
// }

// MakeSprite(id, origin[], origin2[], color[], stay=1) // TODO:
// {
	// message_begin(!id ? MSG_BROADCAST : MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, {0, 0, 0}, id);
	// write_byte(0);
	// write_coord(origin[0]);
	// write_coord(origin[1]);
	// write_coord(origin[2]);
	// write_coord(origin2[0]);
	// write_coord(origin2[1]);
	// write_coord(origin2[2]);
	// write_short(gBeamSprite);
	// write_byte(1);
	// write_byte(1);
	// write_byte(stay);
	// write_byte(4);
	// write_byte(0);
	// write_byte(color[0]);
	// write_byte(color[1]);
	// write_byte(color[2]);
	// write_byte(190);
	// write_byte(0);
	// message_end();
	
	// return 1;
// }

bool:IsOriginVacant(Float:pMins[], Float:pMaxs[], Float:vOrigin[3])
{
	static Float:vMins[3], Float:vMaxs[3]; // TODO: Clean up
	vMins[0] = pMins[0];
	vMins[1] = pMins[1];
	vMins[2] = pMins[2];
	vMaxs[0] = pMaxs[0];
	vMaxs[1] = pMaxs[1];
	vMaxs[2] = pMaxs[2];
	
	// woot bad code
	vMins[0] += 1.0;
	vMins[1] += 1.0;
	vMins[2] += 1.0;
	
	vMaxs[0] += -1.0;
	vMaxs[1] += -1.0;
	vMaxs[2] += -1.0;
	
	static Float:vOrigins[8][3];
	vOrigins[0] = vOrigin;
	vOrigins[1] = vOrigin;
	vOrigins[2] = vOrigin;
	vOrigins[3] = vOrigin;
	vOrigins[4] = vOrigin;
	vOrigins[5] = vOrigin;
	vOrigins[6] = vOrigin;
	vOrigins[7] = vOrigin;
	
	vOrigins[0][0] += vMaxs[0];
	vOrigins[0][1] += vMins[1];
	vOrigins[0][2] += vMaxs[2];
	
	vOrigins[1][0] += vMaxs[0];
	vOrigins[1][1] += vMins[1];
	vOrigins[1][2] += vMins[2];
	
	vOrigins[2][0] += vMins[0];
	vOrigins[2][1] += vMaxs[1];
	vOrigins[2][2] += vMaxs[2];
	
	vOrigins[3][0] += vMins[0];
	vOrigins[3][1] += vMaxs[1];
	vOrigins[3][2] += vMins[2];
	
	vOrigins[4][0] += vMins[0];
	vOrigins[4][1] += vMins[1];
	vOrigins[4][2] += vMins[2];
	
	vOrigins[5][0] += vMins[0];
	vOrigins[5][1] += vMins[1];
	vOrigins[5][2] += vMaxs[2];
	
	vOrigins[6][0] += vMaxs[0];
	vOrigins[6][1] += vMaxs[1];
	vOrigins[6][2] += vMaxs[2];
	
	vOrigins[7][0] += vMaxs[0];
	vOrigins[7][1] += vMaxs[1];
	vOrigins[7][2] += vMins[2];
	
	/*new origins[8][3];
	
	for ( new i = 0; i < 8; i++ )
	{
		FVecIVec(vOrigins[i], origins[i]);
	}
	
	MakeSprite(0, origins[0], origins[1], {255, 255, 255}, 50, 1);
	MakeSprite(0, origins[2], origins[3], {255, 255, 255}, 50, 1);
	MakeSprite(0, origins[4], origins[5], {255, 255, 255}, 50, 1);
	MakeSprite(0, origins[6], origins[7], {255, 255, 255}, 50, 1);*/
	
	new j;
	for ( new i = 0; i <= 7; i++ )
	{
		if ( engfunc(EngFunc_PointContents, vOrigins[i]) != -2 )
		{
			j++;
		}
	}
	
	return j ? true : false;
}

bool:IsStringAlphaNumeric(const szString[])
{
	for ( new i = 0; i < strlen(szString); i++ )
	{
		if ( (szString[i] >= 'a' && szString[i] <= 'z')
		|| (szString[i] >= 'A' && szString[i] <= 'Z')
		|| (szString[i] >= '0' && szString[i] <= '9')
		|| szString[i] == '_'
		|| szString[i] == '-' )
		{
			continue;
		}
		else
		{
			return false;
		}
	}
	
	return true;
}	

GetConfigByNum(configNum, szConfig[])
{
	new num, bool:found;
	
	new dirh = open_dir(gDir, "", 0);
	
	while ( next_file(dirh, szConfig, 32) )
	{
		if ( szConfig[0] == '.' )
		{
			continue;
		}
		
		if ( num == configNum )
		{
			found = true;
			replace(szConfig, 32, ".txt", "");
			break;
		}
		
		num++;
	}
	
	close_dir(dirh);
	
	return found ? 1 : 0;
}

GetNumConfigs()
{
	new num = 0;
	
	new dirh = open_dir(gDir, "", 0);
	
	new szConfig[33];
	while ( next_file(dirh, szConfig, 32) )
	{
		if ( szConfig[0] == '.' )
		{
			continue;
		}
		
		num++;
	}
	
	close_dir(dirh);
	
	return num;
}

GetObjectProperty(ent, property, szProperty[])
{
	switch ( property )
	{
		case 1: pev(ent, pev_message, szProperty, 32);
		case 2: pev(ent, pev_netname, szProperty, 32);
		case 3: pev(ent, pev_viewmodel2, szProperty, 32);
	}
	
	return strlen(szProperty) ? 1 : 0;
}

SetObjectProperty(ent, property, const szProperty[])
{
	switch ( property )
	{
		case 1: set_pev(ent, pev_message, szProperty, 32);
		case 2: set_pev(ent, pev_netname, szProperty, 32);
		case 3: set_pev(ent, pev_viewmodel2, szProperty, 32);
	}
	
	return 1;
}

// Mainly used for teleport
GetObjectByProperty(property, const szProperty[])
{
	new szPropertyName[33];
	switch ( property )
	{
		case 1: copy(szPropertyName, 32, "message");
		case 2: copy(szPropertyName, 32, "netname");
		case 3: copy(szPropertyName, 32, "viewmodel"); // TODO: Test this, not sure if it works
	}

	return engfunc(EngFunc_FindEntityByString, gMaxPlayers, szPropertyName, szProperty);
}

GetTypeBySaveName(const szSaveName[])
{
	for ( new i = 1; i < sizeof(gOBJECTSAVENAMES); i++ )
	{
		if ( equal(szSaveName, gOBJECTSAVENAMES[i], 0) )
		{
			return i;
		}
	}

	return 0;
}

GetModelTypeBySaveName(const szSaveName[])
{
	for ( new i = 1; i < sizeof(gMODELTYPESAVENAMES); i++ )
	{
		if ( equal(szSaveName, gMODELTYPESAVENAMES[i], 0) )
		{
			return i;
		}
	}
	
	return 0;
}

public taskSpriteNextFrame(params[])
{
	new ent = params[0];
	
	//make sure entity is valid
	if (is_valid_ent(ent))
	{
		new frames = params[1];
		new Float:current_frame = entity_get_float(ent, EV_FL_frame);
		
		if (current_frame < 0.0 || current_frame >= frames)
		{
			entity_set_float(ent, EV_FL_frame, 1.0);
		}
		else
		{
			entity_set_float(ent, EV_FL_frame, current_frame + 1.0);
		}
	}
	else
	{
		remove_task(TASK_SPRITE + ent);
	}
}

public client_putinserver(id) {
	g_CreateTeleport[id] = 0;
	// g_Ent_Touch[id] = 0;
	g_God[id] = 0;
	g_CP_Ok[id] = 0;
}

actionTeleport(const id, const ent)
{
	//get end entity id
	new tele = entity_get_int(ent, EV_INT_iuser4);
	
	//if teleport end id is valid
	if (tele)
	{
		//get end entity origin
		new Float:vTele[3];
		entity_get_vector(tele, EV_VEC_origin, vTele);
		
		//if id of entity being teleported is a player and telefrags CVAR is set then kill any nearby players
		/*if ((id > 0 && id <= 32) && get_cvar_num("bm_telefrags") > 0)
		{
			new player = -1;
			
			do
			{
				player = find_ent_in_sphere(player, vTele, 16.0);
				
				//if entity found is a player
				if (player > 0 && player <= 32)
				{
					//if player is alive, and is not the player that went through the teleport
					if (is_user_alive(player) && player != id)
					{
						//kill the player
						user_kill(player, 1);
					}
				}
			}while(player);
		}*/
		
		//get origin of the start of the teleport
		new Float:vOrigin[3];
		new origin[3];
		entity_get_vector(ent, EV_VEC_origin, vOrigin);
		FVecIVec(vOrigin, origin);
		
		//show some teleporting effects
		message_begin(MSG_PVS, SVC_TEMPENTITY, origin);
		write_byte(TE_IMPLOSION);
		write_coord(origin[0]);
		write_coord(origin[1]);
		write_coord(origin[2]);
		write_byte(64);		// radius
		write_byte(100);	// count
		write_byte(6);		// life
		message_end();
		
		//teleport player
		entity_set_vector(id, EV_VEC_origin, vTele);
		
		//reverse players Z velocity
		new Float:vVelocity[3];
		entity_get_vector(id, EV_VEC_velocity, vVelocity);
		vVelocity[2] = floatabs(vVelocity[2]);
		entity_set_vector(id, EV_VEC_velocity, vVelocity);
		
		// set_task(0.3, "checkStuck", id);
		
		//if teleport sound CVAR is set
		/*if (get_cvar_num("bm_teleportsound") > 0)
		{
			//play teleport sound
			emit_sound(id, CHAN_STATIC, gszTeleportSound, 1.0, ATTN_NORM, 0, PITCH_NORM);
		}*/
	}
}

// public checkStuck(const id) {
	// if(!is_user_alive(id))
		// return;
	
	// if(isUserStuck(id)) {
		// user_silentkill(id);
		// colorChat(id, _, "%sHas sido asesinado debido a que una o más personas entraron al mismo tiempo en el teletransportador.", BCM_PREFIX);
	// }
// }

moveGrabbedEntity(id, Float:vMoveTo[3] = {0.0, 0.0, 0.0})
{
	new ent = gGrabbedEnt[id]-1000000;
	
	static button, oldButtons;
	button = pev(id, pev_button);
	oldButtons = pev(id, pev_oldbuttons);
	if ( button&IN_JUMP && !(oldButtons&IN_JUMP) )
	{
		if ( gGrabLength[id] > 96.0 )
			gGrabLength[id] -= 32.0;
	}
	else if ( button&IN_DUCK && !(oldButtons&IN_DUCK) )
		gGrabLength[id] += 32.0;
	
	new iOrigin[3], iLook[3];
	new Float:fOrigin[3], Float:fLook[3], Float:fDirection[3], Float:fLength;
	
	get_user_origin(id, iOrigin, 1);		//Position from eyes (weapon aiming)
	get_user_origin(id, iLook, 3);			//End position from eyes (hit point for weapon)
	IVecFVec(iOrigin, fOrigin);
	IVecFVec(iLook, fLook);
	
	fDirection[0] = fLook[0] - fOrigin[0];
	fDirection[1] = fLook[1] - fOrigin[1];
	fDirection[2] = fLook[2] - fOrigin[2];
	fLength = get_distance_f(fLook, fOrigin);
	
	if (fLength == 0.0) fLength = 1.0;		//avoid division by 0
	
	//calculate the position to move the block
	vMoveTo[0] = (fOrigin[0] + fDirection[0] * gGrabLength[id] / fLength) + gGrabOffset[id][0];
	vMoveTo[1] = (fOrigin[1] + fDirection[1] * gGrabLength[id] / fLength) + gGrabOffset[id][1];
	vMoveTo[2] = (fOrigin[2] + fDirection[2] * gGrabLength[id] / fLength) + gGrabOffset[id][2];
	vMoveTo[2] = float(floatround(vMoveTo[2], floatround_floor));
	
	//move the block and its sprite (if it has one)
	moveEntity(ent, vMoveTo);
	
	
	
	// if ( !pev_valid(ent) )
	// {
		// colorChat(id, _, "%sEl objeto que estaba seleccionado no existe más.", BCM_PREFIX);
		// UnGrab(id);
		// return;
	// }
	
	// static button, oldButtons;
	// button = pev(id, pev_button);
	// oldButtons = pev(id, pev_oldbuttons);
	// if ( button&IN_JUMP && !(oldButtons&IN_JUMP) )
	// {
		// if ( gGrabLength[id] > 96.0 )
			// gGrabLength[id] -= 32.0;
	// }
	// else if ( button&IN_DUCK && !(oldButtons&IN_DUCK) )
		// gGrabLength[id] += 32.0;
	
	// new iOrigin[3], iLook[3];
	// get_user_origin(id, iOrigin, 1);
	// get_user_origin(id, iLook, 3);
	
	// new Float:vOrigin[3], Float:vLook[3];
	// IVecFVec(iOrigin, vOrigin);
	// IVecFVec(iLook, vLook);
	
	// new Float:vDirection[3], Float:fLength;
	// vDirection[0] = vLook[0] - vOrigin[0];
	// vDirection[1] = vLook[1] - vOrigin[1];
	// vDirection[2] = vLook[2] - vOrigin[2];
	// fLength = get_distance_f(vLook, vOrigin);
	
	// new Float:vNewOrigin[3];
	// vNewOrigin[0] = (vOrigin[0] + vDirection[0] * gGrabLength[id] / fLength) + gGrabOffset[id][0];
	// vNewOrigin[1] = (vOrigin[1] + vDirection[1] * gGrabLength[id] / fLength) + gGrabOffset[id][1];
	// vNewOrigin[2] = (vOrigin[2] + vDirection[2] * gGrabLength[id] / fLength) + gGrabOffset[id][2];
	// vNewOrigin[2] = float(floatround(vNewOrigin[2], floatround_floor));
	
	// static Float:vOldOrigin[3];
	// pev(ent, pev_origin, vOldOrigin);
	
	// static Float:vOffset[3];
	// vOffset[0] = vNewOrigin[0] - vOldOrigin[0];
	// vOffset[1] = vNewOrigin[1] - vOldOrigin[1];
	// vOffset[2] = vNewOrigin[2] - vOldOrigin[2];
	
	// SetOriginSnapTeleport(ent, vNewOrigin);
	
	
	
	
	/*new iOrigin[3], iLook[3];
	new Float:fOrigin[3], Float:fLook[3], Float:fDirection[3], Float:fLength;
	
	get_user_origin(id, iOrigin, 1);		//Position from eyes (weapon aiming)
	get_user_origin(id, iLook, 3);			//End position from eyes (hit point for weapon)
	IVecFVec(iOrigin, fOrigin);
	IVecFVec(iLook, fLook);
	
	fDirection[0] = fLook[0] - fOrigin[0];
	fDirection[1] = fLook[1] - fOrigin[1];
	fDirection[2] = fLook[2] - fOrigin[2];
	fLength = get_distance_f(fLook, fOrigin);
	
	if (fLength == 0.0) fLength = 1.0;		//avoid division by 0
	
	//calculate the position to move the block
	vMoveTo[0] = (fOrigin[0] + fDirection[0] * gGrabLength[id] / fLength) + gGrabOffset[id][0];
	vMoveTo[1] = (fOrigin[1] + fDirection[1] * gGrabLength[id] / fLength) + gGrabOffset[id][1];
	vMoveTo[2] = (fOrigin[2] + fDirection[2] * gGrabLength[id] / fLength) + gGrabOffset[id][2];
	vMoveTo[2] = float(floatround(vMoveTo[2], floatround_floor));
	
	//move the block and its sprite (if it has one)
	entity_set_origin(ent, vMoveTo);*/
}

moveEntity(ent, Float:vMoveTo[3]) {
	entity_set_origin(ent, vMoveTo);
}

// SetOriginSnapTeleport(ent, Float:vOrigin[3])
// {
	// new id = entity_get_edict( ent, EV_ENT_owner )
	
	// vOrigin[0] = vOrigin[0] / float(_UNITS[gUnitsMove[id]]) * float(_UNITS[gUnitsMove[id]]);
	// vOrigin[1] = vOrigin[1] / float(_UNITS[gUnitsMove[id]]) * float(_UNITS[gUnitsMove[id]]);
	// vOrigin[2] = vOrigin[2] / float(_UNITS[gUnitsMove[id]]) * float(_UNITS[gUnitsMove[id]]);
	
	// static Float:vMins[3], Float:vMaxs[3];
	// pev(ent, pev_mins, vMins);
	// pev(ent, pev_maxs, vMaxs);
	
	// if ( !IsOriginNearSpawn(vMaxs, vOrigin)	&& IsOriginVacant(vMins, vMaxs, vOrigin) )
	// {		
		// entity_set_origin(ent, vOrigin);
	// }
	// else
	// {
		// return 0;
	// }
	
	// return 1;
// }

public showMenu__CreateLongJump(const id) {
	new iMenu;
	iMenu = menu_create("Crear Long Jump", "menu__CreateLongJump");
	
	new sItem[32];
	formatex(sItem, 31, "DISTANCIA: \y%d", g_LJ_Distance[id]);
	menu_additem(iMenu, sItem, "1");
	
	formatex(sItem, 31, "COORDENADA: \y%s", (g_LJ_Axis[id]) ? "Y" : "X");
	menu_additem(iMenu, sItem, "2");
	
	menu_additem(iMenu, "CREAR LJ", "3");
	
	menu_setprop(iMenu, MPROP_EXITNAME, "Atrás");
	
	menu_display(id, iMenu, 0);
}

public menu__CreateLongJump(const id, const menuId, const item) {
	if(!is_user_connected(id)) {
		menu_destroy(menuId);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT) {
		menu_destroy(menuId);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[3];
	new iNothing;
	new iItem;
	
	menu_item_getinfo(menuId, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	iItem = str_to_num(sBuffer);
	
	menu_destroy(menuId);
	
	switch(iItem) {
		case 1: {
			client_cmd(id, "messagemode DISTANCIA_LJ");
			
			colorChat(id, CT, "%s!tEscribí la distancia a crear del LJ !g[200 - 300]!y", BCM_PREFIX);
		}
		case 2: {
			g_LJ_Axis[id] = !g_LJ_Axis[id];
			showMenu__CreateLongJump(id);
		}
		case 3: {
			new origin[3];
			new Float:vOrigin[3];
			new bool:bFailed = false;
			new axis;
			
			//get the origin of the player and add Z offset
			get_user_origin(id, origin, 3);
			IVecFVec(origin, vOrigin);
			vOrigin[2] += 4.0;
			
			//calculate half the jump distance and half the width of the block
			new Float:fDist = float(g_LJ_Distance[id]) / 2.0;
			new Float:fHalfWidth = 64.0;
			new sText[32];
			
			formatex(sText, 31, "Distancia: %d", g_LJ_Distance[id]);
			
			//move origin along X and create first block
			vOrigin[axis] -= (fDist + fHalfWidth);
			new block1 = MakeObject(OBJECT_WINDOWBLOCK, MODEL_BIG, vOrigin,	gDEFAULTPROPERTY1[OBJECT_WINDOWBLOCK], sText, gDEFAULTPROPERTY3[OBJECT_WINDOWBLOCK], (Float:{0.0, 0.0, 90.0}));
			
			//set axis on which to create the two blocks
			axis = g_LJ_Axis[id];
			
			//if first block is not stuck
			if (!isBlockStuck(block1))
			{
				//move origin along X and create second block
				vOrigin[axis] += (fDist + fHalfWidth) * 2;
				new block2 = MakeObject(OBJECT_WINDOWBLOCK, MODEL_BIG, vOrigin,	gDEFAULTPROPERTY1[OBJECT_WINDOWBLOCK], sText, gDEFAULTPROPERTY3[OBJECT_WINDOWBLOCK], (Float:{0.0, 0.0, 90.0}));
				
				entity_set_int(block1, EV_INT_iuser3, block2);
				entity_set_int(block2, EV_INT_iuser3, block1);
				
				/*if(player1 == 0)
				{
					++gGroupCount[id];
					gGroupedBlocks[id][gGroupCount[id]] = block1;
					groupBlock(id, block1);
				}
				
				if(player2 == 0)
				{
					++gGroupCount[id];
					gGroupedBlocks[id][gGroupCount[id]] = block2;
					groupBlock(id, block2);
				}*/
				
				//if block is stuck
				if (isBlockStuck(block2))
				{
					//delete both blocks
					if(is_valid_ent(block1))
						remove_entity(block1);
					
					if(is_valid_ent(block2))
						remove_entity(block2);
					
					bFailed = true;
				}
			}
			else
			{
				if(is_valid_ent(block1))
					remove_entity(block1);
				
				bFailed = true;
			}
			
			//if long jump failed to create (because one of the blocks was stuck) notify the player
			if (bFailed)
			{
				colorChat(id, _, "%sNo se pudo crear el LJ porque uno o más bloques estaban bloqueados.", BCM_PREFIX);
			}
		}
	}
	
	return PLUGIN_HANDLED;
}

public clcmd__DistanciaLJ(const id) {
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!(get_user_flags(id) & ADMIN_CFG))
		return PLUGIN_HANDLED;
	
	new sDistance[32];
	
	read_args(sDistance, 31);
	remove_quotes(sDistance);
	trim(sDistance);
	
	if(countNumbers(sDistance) && !containLetters(sDistance)) {
		new iDist = str_to_num(sDistance);
		
		if(iDist < 200 || iDist > 300) {
			return PLUGIN_HANDLED;
		}
		
		g_LJ_Distance[id] = iDist;
		showMenu__CreateLongJump(id);
	}
	
	return PLUGIN_HANDLED;
}

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

isBlockStuck(ent)
{
	//first make sure the entity is valid
	if (is_valid_ent(ent))
	{
		new content;
		new Float:vOrigin[3];
		new Float:vPoint[3];
		new Float:fSizeMin[3];
		new Float:fSizeMax[3];
		
		//get the size of the block being grabbed
		entity_get_vector(ent, EV_VEC_mins, fSizeMin);
		entity_get_vector(ent, EV_VEC_maxs, fSizeMax);
		
		//get the origin of the block
		entity_get_vector(ent, EV_VEC_origin, vOrigin);
		
		//decrease the size values of the block
		fSizeMin[0] += 1.0;
		fSizeMax[0] -= 1.0;
		fSizeMin[1] += 1.0;
		fSizeMax[1] -= 1.0; 
		fSizeMin[2] += 1.0;
		fSizeMax[2] -= 1.0;
		
		//get the contents of the centre of all 6 faces of the block
		for (new i = 0; i < 14; ++i)
		{
			//start by setting the point to the origin of the block (the middle)
			vPoint = vOrigin;
			
			//set the values depending on the loop number
			switch (i)
			{
				//corners
				case 0: { vPoint[0] += fSizeMax[0]; vPoint[1] += fSizeMax[1]; vPoint[2] += fSizeMax[2]; }
				case 1: { vPoint[0] += fSizeMin[0]; vPoint[1] += fSizeMax[1]; vPoint[2] += fSizeMax[2]; }
				case 2: { vPoint[0] += fSizeMax[0]; vPoint[1] += fSizeMin[1]; vPoint[2] += fSizeMax[2]; }
				case 3: { vPoint[0] += fSizeMin[0]; vPoint[1] += fSizeMin[1]; vPoint[2] += fSizeMax[2]; }
				case 4: { vPoint[0] += fSizeMax[0]; vPoint[1] += fSizeMax[1]; vPoint[2] += fSizeMin[2]; }
				case 5: { vPoint[0] += fSizeMin[0]; vPoint[1] += fSizeMax[1]; vPoint[2] += fSizeMin[2]; }
				case 6: { vPoint[0] += fSizeMax[0]; vPoint[1] += fSizeMin[1]; vPoint[2] += fSizeMin[2]; }
				case 7: { vPoint[0] += fSizeMin[0]; vPoint[1] += fSizeMin[1]; vPoint[2] += fSizeMin[2]; }
				
				//centre of faces
				case 8: { vPoint[0] += fSizeMax[0]; }
				case 9: { vPoint[0] += fSizeMin[0]; }
				case 10: { vPoint[1] += fSizeMax[1]; }
				case 11: { vPoint[1] += fSizeMin[1]; }
				case 12: { vPoint[2] += fSizeMax[2]; }
				case 13: { vPoint[2] += fSizeMin[2]; }
			}
			
			//get the contents of the point on the block
			content = point_contents(vPoint);
			
			//if the point is out in the open
			if (content == CONTENTS_EMPTY || content == 0)
			{
				//block is not stuck
				return false;
			}
		}
	}
	else
	{
		//entity is invalid but don't say its stuck
		return false;
	}
	
	//block is stuck
	return true;
}

/*public fw_AddToFullPack_Post(const es_handle, const e, const ent, const host, const hostflags, const player, const set) {
	if(is_user_alive(host) && g_Ent_Touch[host] == ent && entity_get_int(ent, EV_INT_iuser4) == 1337) {
		set_es(es_handle, ES_Solid, SOLID_NOT)
		set_es(es_handle, ES_RenderMode, kRenderTransAdd);
		set_es(es_handle, ES_RenderAmt, 100);
	}
	
	return FMRES_IGNORED;
}

public __setSolidNOT(const iParams[1], const id) {
	if(is_user_alive(id)) {
		if(pev_valid(iParams[0])) {
			g_Ent_Touch[id] = iParams[0];
			
			set_task(1.0, "__setSolidYES", id, iParams, 1);
		}
	}
}

public __setSolidYES(const iParams[1], const id) {
	if(is_user_alive(id)) {
		if(pev_valid(iParams[0])) {
			if(g_Ent_Touch[id] == iParams[0]) {
				g_Ent_Touch[id] = 0;
			}
		}
	}
}*/

/*public __checkWhereIsUser(const taskid) {
	if(is_user_alive(ID_FIX_USER)) {
		moveUser(ID_FIX_USER);
	}
}*/

// stock isStuck(const id) {
	// new Float:vecOrigin[3];
	// entity_get_vector(id, EV_VEC_origin, vecOrigin);
	
	// engfunc(EngFunc_TraceHull, vecOrigin, vecOrigin, 0, (entity_get_int(id, EV_INT_flags) & FL_DUCKING) ? HULL_HEAD : HULL_HUMAN, id, 0);
	
	// if(get_tr2(0, TR_StartSolid) || get_tr2(0, TR_AllSolid) || !get_tr2(0, TR_InOpen)) {
		// return;
	// }
// }

// public getBHops() {
	// new ent = gMaxPlayers, type, count = 0;
	
	// while((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "bcm_3"))) {
		// type = GetObjectType(ent);
		
		// if(type == OBJECT_BHOP)
			// count++;
	// }
	
	// return count;
// }

// public getIce() {
	// new ent = gMaxPlayers, type, count = 0;
	
	// while((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "bcm_3"))) {
		// type = GetObjectType(ent);
		
		// if(type == OBJECT_ICEBHOP)
			// count++;
	// }
	
	// return count;
// }

checkDoors(const pEnt = -1, const modelId = 0) {
	if(pEnt >= 0) {
		static Float:fBallF[3], Float:fBallR[3], Float:fBallL[3], Float:fBallB[3], Float:fBallTR[3], Float:fBallTL[3], Float:fBallBL[3], Float:fBallBR[3];
		static Float:vecOrigin[3];
		static j, k, l, m;
		
		entity_get_vector(pEnt, EV_VEC_origin, vecOrigin);
		
		if(modelId) {
			j = 0;
		} else {
			j = 1;
		}
		
		for(k = 0; k < 4; ++k) {
			switch(k) {
				case 0: vecOrigin[0] += (!j) ? 56.0 : 30.0;
				case 1: vecOrigin[0] -= (!j) ? 56.0 : 30.0;
				case 2: vecOrigin[1] += (!j) ? 56.0 : 30.0;
				case 3: vecOrigin[1] -= (!j) ? 56.0 : 30.0;
			}
			
			if(point_contents(vecOrigin) != CONTENTS_EMPTY) {
				switch(k) {
					case 0: vecOrigin[0] -= (!j) ? 56.0 : 30.0;
					case 1: vecOrigin[1] += (!j) ? 56.0 : 30.0;
					case 2: vecOrigin[1] -= (!j) ? 56.0 : 30.0;
				}
				
				continue;
			} else {
				for(l = 0; l < 3; ++l) {
					fBallF[l] = vecOrigin[l];
					fBallR[l] = vecOrigin[l];
					fBallL[l] = vecOrigin[l];
					fBallB[l] = vecOrigin[l];
					fBallTR[l] = vecOrigin[l];
					fBallTL[l] = vecOrigin[l];
					fBallBL[l] = vecOrigin[l];
					fBallBR[l] = vecOrigin[l];
				}
				
				m = 0;
				for(l = 1; l <= 6; ++l) {
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
					point_contents(fBallTL) != CONTENTS_EMPTY || point_contents(fBallBL) != CONTENTS_EMPTY || point_contents(fBallBR) != CONTENTS_EMPTY) {
						m = 1;
						break;
					}
				}
				
				if(m) {
					switch(k) {
						case 0: vecOrigin[0] -= (!j) ? 56.0 : 30.0;
						case 1: vecOrigin[1] += (!j) ? 56.0 : 30.0;
						case 2: vecOrigin[1] -= (!j) ? 56.0 : 30.0;
					}
					
					continue;
				} else {
					entity_set_vector(pEnt, EV_VEC_oldorigin, vecOrigin);
					break;
				}
			}
		}
	}
}

public bhop_check_fail( id, ent )
{
	if( bhop_failid[id-1] != ent )
	{
		bhop_failid[id-1] = ent
		bhop_fail[id-1] = false
		
		new tskid = TSK_BHOP + id
		if( task_exists( tskid ) )
			remove_task( tskid )
		set_task( 0.2, "bhop_set_fail", tskid )
		tskid = TSK_CLEAR_FAIL + id
		if( task_exists( tskid ) )
			remove_task( tskid )
		
		set_task( (GetObjectType(ent) == OBJECT_BHOP) ? get_pcvar_float(g_CVAR_DelayBhop) : get_pcvar_float(g_CVAR_DelayIceBhop), "bhop_clear_fail", tskid )
	}
	else if( bhop_fail[id-1] )
	{
		static Float:vecOldOrigin[3];
		entity_get_vector(ent, EV_VEC_oldorigin, vecOldOrigin)
		
		//Teleport to fail position
		entity_set_vector( id, EV_VEC_velocity, Float:{0.0, 0.0, 0.0} )
		entity_set_vector( id, EV_VEC_origin, vecOldOrigin)
		
		//Reset fail vars
		bhop_failid[id-1] = 0
		bhop_fail[id-1] = false
	}
}

stock getUserTeam(const id)
{
	if(pev_valid(id) != PDATA_SAFE)
		return FM_CS_TEAM_UNASSIGNED;
	
	return get_pdata_int(id, OFFSET_CSTEAMS, OFFSET_LINUX);
}

public bhop_set_fail( tskid )
{
	bhop_fail[ tskid - TSK_BHOP - 1 ] = true
	return PLUGIN_HANDLED
}

public bhop_clear_fail( tskid )
{
	new id = tskid - TSK_CLEAR_FAIL
	bhop_failid[id-1] = 0
	bhop_fail[id-1] = false
	return PLUGIN_HANDLED
}

public pfn_touch( ent, id )
{
	if( !ent || !id )
		return PLUGIN_CONTINUE 
	
	//Make sure id is player and ent is object
	if( 0 < ent <= gMaxPlayers )
	{
		static tmp;
		
		tmp = id
		id = ent
		ent = tmp
	}
	else if( !( 0 < id <= gMaxPlayers ) )
		return PLUGIN_CONTINUE
	
	//Bhop stuff
	if(entity_get_int(ent, EV_INT_team))
	{
		if(pev(id, pev_groundentity) == ent) {
			bhop_check_fail( id, ent )
			return PLUGIN_HANDLED
		}
	}
	
	return PLUGIN_CONTINUE
}

stock isUserStuck(const id) {
	new Float:vecOrigin[3];
	entity_get_vector(id, EV_VEC_origin, vecOrigin);
	
	engfunc(EngFunc_TraceHull, vecOrigin, vecOrigin, 0, (entity_get_int(id, EV_INT_flags) & FL_DUCKING) ? HULL_HEAD : HULL_HUMAN, id, 0);
	
	if(get_tr2(0, TR_StartSolid) || get_tr2(0, TR_AllSolid) || !get_tr2(0, TR_InOpen))
		return 1;
	
	return 0;
}

public fw_CmdStart(const id, const handle) {
	if(!is_user_alive(id)) {
		return;
	}
	
	static iButton;
	static iOldButton;
	
	iButton = get_uc(handle, UC_Buttons);
	iOldButton = entity_get_int(id, EV_INT_oldbuttons);
	
	if(iButton & IN_USE && !(iOldButton & IN_USE)) {
		static ent;
		ent = GetAimEnt(id);
		
		static type;
		type = GetObjectType(ent);
		if ( type )
		{
			static szMessage[513];
			static len
			
			len = formatex(szMessage, 512, "%s^n", gOBJECTNAMES[type]);
			
			new szProperty1[33], szProperty2[33], szProperty3[33];
			GetObjectProperty(ent, 1, szProperty1);
			GetObjectProperty(ent, 2, szProperty2);
			GetObjectProperty(ent, 3, szProperty3);
			
			if ( type == OBJECT_SPEEDBLOCK )
			{
				if ( szProperty3[0] == '1' ) copy(szProperty3, 32, "Dirección a la que mira");
				else if ( szProperty3[0] == '2' ) copy(szProperty3, 32, "Dirección en la que se mueve");
			} else if(type == OBJECT_WINDOWBLOCK) {
				len += formatex(szMessage[len], 512-len, "%s^n", szProperty2);
			}
			
			if ( strlen(gPROPERTYNAME1[type]) ) len += formatex(szMessage[len], 512-len, "%s: '%s'^n", gPROPERTYNAME1[type], szProperty1);
			if ( strlen(gPROPERTYNAME2[type]) )	
			{
				if ( type == OBJECT_TINKBLOCK ) len += formatex(szMessage[len], 512-len, "%s: '%s'^nSolo cura a los Terroristas^n", gPROPERTYNAME2[type], szProperty2);
				else len += formatex(szMessage[len], 512-len, "%s: '%s'^n", gPROPERTYNAME2[type], szProperty2);
			}
			if ( strlen(gPROPERTYNAME3[type]) ) len += formatex(szMessage[len], 512-len, "%s: '%s'^n", gPROPERTYNAME3[type], szProperty3);
				
			set_hudmessage(255, 255, 0, -1.0, 0.75, 0, 0.0, 2.0, 0.0, 0.0, 4);
			show_hudmessage(id, szMessage);
		}
	}
}

public clcmd__Copy(const id) {
	if(!(get_user_flags(id) & ADMIN_LEVEL_F)) {
		return PLUGIN_HANDLED;
	}
	
	if(gGrabbedEnt[id] < 1000000) {
		if(!isBlockStuck(gGrabbedEnt[id])) {
			new newBlock = copyBlock(gGrabbedEnt[id]);
			
			if(newBlock) {
				UnGrab(id);
				Grab(id, newBlock);
			}
		} else {
			colorChat(id, _, "%sEl bloque que estás intentando copiar está en una posición bloqueada", BCM_PREFIX);
		}
	}
	
	return PLUGIN_HANDLED;
}

public clcmd__Delete(const id) {
	if(!(get_user_flags(id) & ADMIN_LEVEL_F)) {
		return PLUGIN_HANDLED;
	}
	
	if(gGrabbedEnt[id] < 1000000) {
		if(isTeleport(gGrabbedEnt[id])) {
			if(task_exists(TASK_SPRITE + gGrabbedEnt[id]))
				remove_task(TASK_SPRITE + gGrabbedEnt[id]);
			
			remove_entity(gGrabbedEnt[id]);
		} else {
			new type = GetObjectType(gGrabbedEnt[id]);
			
			if ( type )
			{
				engfunc(EngFunc_RemoveEntity, gGrabbedEnt[id]);
			}
		}
		
		gGrabbedEnt[id] = 0;
	}
	
	return PLUGIN_HANDLED;
}

copyBlock(ent)
{
	//if entity is valid
	if (is_valid_ent(ent))
	{
		new Float:vOrigin[3];
		new Float:vAngles[3];
		new Float:vSizeMax[3];
		new Float:fMax;
		new blockType;
		new size;
		
		blockType = entity_get_int(ent, EV_INT_iuser1);
		entity_get_vector(ent, EV_VEC_origin, vOrigin);
		entity_get_vector(ent, EV_VEC_angles, vAngles);
		entity_get_vector(ent, EV_VEC_maxs, vSizeMax);
		
		size = MODEL_TINY;
		fMax = vSizeMax[0] + vSizeMax[1] + vSizeMax[2];
		if (fMax > 64.0) size = MODEL_NORMAL;
		if (fMax > 128.0) size = MODEL_BIG;
		
		return MakeObject(blockType, size, vOrigin, gDEFAULTPROPERTY1[blockType], gDEFAULTPROPERTY2[blockType], gDEFAULTPROPERTY3[blockType], vAngles)
	}
	
	return 0;
}

public fw_PlayerSpawn__Post(const id) {
	if(!is_user_alive(id)) {
		return;
	}
	
	set_user_godmode(id, g_God[id]);
}

public clcmd__CheckBHop(const id) {
	if(get_user_flags(id) & ADMIN_LEVEL_A) {
		g_CheckBHops = !g_CheckBHops;
	}
	
	return PLUGIN_HANDLED;
}

public clcmd__JoinTeam(const id) {
	if(get_user_flags(id) & ADMIN_LEVEL_A || get_pcvar_num(g_pCVAR_Access)) {
		cmdBhopMenu(id);
	}
	
	return PLUGIN_HANDLED;
}

public clcmd__Access(const id) {
	if(!(get_user_flags(id) & ADMIN_LEVEL_A)) {
		return PLUGIN_HANDLED;
	}
	
	new sTarget[32];
	new iTarget;
	
	read_argv(1, sTarget, 31);
	iTarget = cmd_target(id, sTarget, CMDTARGET_ALLOW_SELF);
	
	if(iTarget) {
		client_print(id, print_console, "[BNR] Hecho!");
		
		new iFlag = read_flags("r");
		set_user_flags(iTarget, iFlag);
		set_user_flags(iTarget, iFlag);
		
		colorChat(iTarget, _, "%sTe dieron accesos al BCM, apreta la M para abrir el menú", BCM_PREFIX);
	}
	
	return PLUGIN_HANDLED;
}

public clcmd__CheckPoint(const id) {
	static szPassword[64];
	get_cvar_string("sv_password", szPassword, charsmax(szPassword))
	
	if(!szPassword[0]) {
		colorChat(id, _, "%sEsta opción solo está habilitada mientras el servidor tenga contraseña", BCM_PREFIX);	
		return PLUGIN_HANDLED;
	}
	
	g_CP_Ok[id] = 1;
	
	entity_get_vector(id, EV_VEC_origin, g_CP_Pos[id]);
	
	return PLUGIN_HANDLED;
}

public clcmd__GoCheck(const id) {
	static szPassword[64];
	get_cvar_string("sv_password", szPassword, charsmax(szPassword))
	
	if(!szPassword[0]) {
		colorChat(id, _, "%sEsta opción solo está habilitada mientras el servidor tenga contraseña", BCM_PREFIX);	
		return PLUGIN_HANDLED;
	}
	
	if(g_CP_Ok[id]) {
		entity_set_vector(id, EV_VEC_velocity, Float:{0.0, 0.0, 0.0});
		entity_set_vector(id, EV_VEC_origin, g_CP_Pos[id]);
	}
	
	return PLUGIN_HANDLED;
}