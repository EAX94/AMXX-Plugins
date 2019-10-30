#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <hamsandwich>
#include <servidores_tcs>
#include <sjpool>
#include <zpnatives>
#include <ggnatives>
#include <engine>
#include <cstrike>
#include <cc>
#include <safemenu>
#include <closemenu>
// #include <unixtime>

#pragma semicolon	1

#define PLUGIN_NAME	"GAM!NGA AMXX"
#define VERSION		"v1.0"
#define AUTHOR		"KISKE"

/*
	PLUGINS:
	
	- ADMIN
	- ADMIN CHAT
	- ADMIN CMD
	- ADMIN HELP
	- ADMIN SLOTS
	- ADMIN VOTE
	- ANTI FLOOD
	- MAP CHOOSER
	- NEXT MAP
	- PAUSE CFG
	- STATS
	- TIMELEFT
	- PASSWORD MIX
	- SPECIAL VOTE MAP
	- ADMIN VOTE MAP MENU
*/

/// GLOBALES
#define KEYS_MENU	MENU_KEY_1 | MENU_KEY_2 | MENU_KEY_3 | MENU_KEY_4 | MENU_KEY_5 | MENU_KEY_6 | MENU_KEY_7 | MENU_KEY_8 | MENU_KEY_9 | MENU_KEY_0

new const AMXX_PREFIX[] = "!g[GAM!NGA]!y ";
new const AMXX_CONSOLE_PREFIX[] = "[GAM!NGA] ";

new g_kiske[33];

new g_player_name[33][32];

new g_currentmap_name[64];

new g_forward_map;
new g_maxplayers;
new g_CheckMaps_UniqueTime;


/// PLUGIN - ADMIN
new g_case_sens_name[33];

enum {
	DIRECTOR,
	STAFF,
	ADMIN,
	PREMIUM,
	USER
};
new g_level_user[33][5];



/// PLUGIN - ADMIN CHAT
#define TASK_CHAT	50000

new g_flood[33] = {0, ...};
new Float:g_flooding[33] = {0.0, ...};

new g_msg_hud[4][226];
new g_msg_hud_total[905];

new g_hud_next = 0;
new g_hud_00;



/// PLUGIN - ADMIN CMD
new const g_cvars_block[][] = {"hostname", "rcon_password", "sv_allowdownload", "mp_kickpercent", "mp_roundtime", "sv_lan", "sv_visiblemaxplayers", "amx_extendmap_max", "__sxei_required", "__sxei_srv_upg", "__sxei_antispeed", "__sxei_antiwall", "__sxei_16bpp",
"__sxei_screen_save","__sxei_screen_path", "mapchangecfgfile", "amx_block_cvar_zp", "sv_airaccelerate", "sv_gravity"};
new const g_cvars_block_zp[][] = {"sv_restartround", "mp_freezetime", "mp_timelimit", "mp_roundtime", "zp_delay"};

enum {
	DISCONNECT_IP,
	DISCONNECT_NAME,
	
	DISCONNECT_MAX
};
new g_players_disconnect_count;
new g_players_disconnect[512][DISCONNECT_MAX][64];

new g_pCVAR_admincmd_on;

new g_team_menu_type[33];
new g_slay_menu[33][33];
new g_team_menu[33][33];
new g_kick_menu[33][33];



/// PLUGIN - ADMIN SLOTS
new g_pCVAR_adminslots_reservation;



/// PLUGIN - ADMIN VOTE
new g_vote_last[33][33];

new g_already_vote[33];
new g_vote[33];

new Float:g_next_vote[33];

new g_vote_in_progress = 0;
new g_vote_votemap_end_round = 0;
new g_vote_votemap_win;
new g_vote_options_max;
new g_vote_id;

new g_vote_question[64];

new g_vote_options[10][64];
new g_vote_votes[10];



/// PLUGIN - MAP CHOOSER
#define SELECT_MAPS			8
#define TASK_TIME_LIMIT		71100
#define TASK_COUNTDOWN	1958365

new g_SELECT_MAPS = SELECT_MAPS;

new const COUNTDOWN_SOUNDS[][] = {"one", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"};

new Array:g_Array_mapname;

new g_last_last_lastmap[64];
new g_last_lastmap[64];
new g_lastmap[64];

new g_nextmap_name[SELECT_MAPS];
new g_votemap_count[SELECT_MAPS + 2];
new g_team_score[2];

new g_mapnums;
new g_map_vote_num;

new g_countdown_map;



/// PLUGIN - NEXT MAP
new g_next_round_change_map = 0;
new g_nextmap_name_all[64];



/// PLUGIN - PAUSE CFG
new g_system[32];
new g_system_num;
new g_amx_status = 1;



/// PLUGIN - SPECIAL VOTE MAP
new g_SVM_MapPercent[9];
new g_SVM_Delay[33];
new g_SVM_AlreadyVote[33];
new g_SVM_MapInMenu[9];
new g_SVM_Votes[9];
new g_SVM_MaxVotes;
new g_SVM_Vote[33];
new g_SVM_AlreadyExtend;
new g_RTV_Already[33];
new g_RTV_Votes;
new g_SVM_Init;
new g_SVM_Nominations;
new g_SVM_Nominate[33];
new g_SVM_MyNominate[33];
new g_SVM_MapName[9][32];
new g_SVM_MapInMenu__FuckingFIX[2];
new g_RTV_Init;
new g_RTV_Allowed;
new Float:g_RTV_SysTime;
new g_SVM_EndVote;



/// PLUGIN - ADMIN VOTE MAP MENU
new g_MenuChooseMaps_Page[33];
new g_MenuChooseMaps_MapsId[33][9];


public plugin_precache()
{
	new sBuffer[32];
	new i;
	
	for(i = 0; i < sizeof(COUNTDOWN_SOUNDS); ++i)
	{
		formatex(sBuffer, 31, "fvox/%s.wav", COUNTDOWN_SOUNDS[i]);
		precache_sound(sBuffer);
	}
}

public plugin_init()
{
	register_plugin(PLUGIN_NAME, VERSION, AUTHOR);
	
	get_mapname(g_currentmap_name, 63);
	strtolower(g_currentmap_name);
	
	/// PLUGIN - ADMIN
	remove_user_flags(0, read_flags("z"));
	
	loadAdmins("addons/amxmodx/configs/users.ini");
	
	/// PLUGIN - ADMIN CHAT
	if(!g_Server[KZ] && !g_Server[SURF] && !g_Server[DR]) {
		register_clcmd("say", "clcmd_Say", ADMIN_CHAT);
	} else {
		/// PLUGIN - SPECIAL VOTE MAP
		register_clcmd("say rtv", "clcmd_RockTheVote");
		register_clcmd("say rockthevote", "clcmd_RockTheVote");
		
		register_clcmd("say", "clcmd_SaySVM");
	}
	
	register_clcmd("say_team", "clcmd_SayTeam");
	
	register_concmd("amx_psay", "concmd_PSay", ADMIN_CHAT, "<nombre o #id> <mensaje> - envia un mensaje privado al usuario");
	
	g_msg_hud[0][0] = EOS;
	g_msg_hud[1][0] = EOS;
	g_msg_hud[2][0] = EOS;
	g_msg_hud[3][0] = EOS;
	
	g_hud_00 = CreateHudSyncObj();
	
	
	/// PLUGIN - ADMIN CMD
	g_pCVAR_admincmd_on = register_cvar("amx_block_cvar_zp", "0");
	
	register_concmd("amx_kick", "concmd_Kick", ADMIN_KICK, "<nombre o #id> <razon (OPCIONAL)>");
	
	register_concmd("amx_ban", "concmd_Ban", ADMIN_BAN, "<nombre o #id> <minutos> <razon (OPCIONAL)>");
	register_concmd("amx_banip", "concmd_Ban", ADMIN_BAN, "<nombre o #id> <minutos> <razon (OPCIONAL)>");
	register_concmd("amx_addban", "concmd_Ban", ADMIN_BAN, "<nombre o #id> <minutos> <razon (OPCIONAL)>");
	
	register_concmd("amx_kickmenu", "concmd_KickMenu", ADMIN_KICK);
	
	register_concmd("amx_unban", "concmd_UnBan", ADMIN_LEVEL_H, "<ip o steamid>");
	register_concmd("amx_who", "concmd_Who", ADMIN_BAN, "- muestra informacion sobre todos los jugadores conectados");
	register_concmd("amx_last", "concmd_Last", ADMIN_BAN, "- muestra informacion sobre los ultimos 15 jugadores desconectados");
	
	if(!g_Server[TD] /*&& !g_Server[ZP] SOLO EN EL TORNEO DE ZP*/) {
		register_concmd("amx_slay", "concmd_Slay", ADMIN_SLAY, "<nombre o #id>");
		register_concmd("amx_slaymenu", "concmd_SlayMenu", ADMIN_SLAY);
		
		if(!g_Server[DR]) {
			register_concmd("amx_slap", "concmd_Slap", ADMIN_SLAY, "<nombre o #id> <danio (OPCIONAL)> <cantidad (OPCIONAL)>");
		}
	}
	
	register_concmd("amx_nick", "concmd_Nick", ADMIN_SLAY, "<nombre o #id> <nuevo nombre>");
	
	if(!g_Server[AUTOMIX] && !g_Server[AUTOMIX2] && !g_Server[JAILBREAK] && !g_Server[TD]) {
		register_concmd("amx_teammenu", "concmd_TeamMenu", ADMIN_KICK);
	}
	
	register_concmd("amx_leave", "concmd_Leave", ADMIN_IMMUNITY, "<nombre (OBLIGATORIO)> - expulsa a los que no tengan en su nombre parte de lo especificado en el comando");
	
	register_concmd("amx_cvar", "concmd_Cvar", ADMIN_CVAR, "<cvar> <valor> - cambia el valor de la cvar especificada");
	
	register_concmd("amx_map", "concmd_Map", ADMIN_MAP, "<nombre del mapa> - cambia el mapa del servidor al especificado");
	
	register_concmd("amx_cfg", "concmd_CFG", ADMIN_CFG, "<nombre de la CFG> - carga la CFG especificada");
	
	
	/// PLUGIN - ADMIN SLOTS
	g_pCVAR_adminslots_reservation = register_cvar("amx_reservation", "0");
	
	
	/// PLUGIN - ADMIN VOTE
	register_clcmd("vote", "clcmd_Vote");
	
	if(g_Server[KZ]) {
		register_clcmd("votemap", "clcmd_VoteMap");
	}
	
	register_concmd("amx_votemap", "concmd_Votemap", ADMIN_VOTE, "<mapa x9> - inicia una votación con los mapas especificados, acepta hasta 9 mapas");
	register_concmd("amx_vote", "concmd_Vote", ADMIN_VOTE, "<pregunta> <respuesta x9 (MINIMO 2)> - inicia una votación con las respuestas especificadas, hasta 9 respuestas");
	
	register_menu("Votemap Menu", KEYS_MENU, "menuVotemap");
	register_menu("Vote Menu", KEYS_MENU, "menuVote");
	
	
	/// PLUGIN - MAP CHOOSER
	register_cvar("amx_gg_nextmap", "");
	
	g_Array_mapname = ArrayCreate(64);
	
	new sMapCycleFile[64];
	register_menucmd(register_menuid("VoteMap Menu DEFAULT"), /*KEYS_MENU*/(-1 ^ (-1 << (g_SELECT_MAPS + 2))), "menuCountVote");
	
	register_event("TeamScore", "event_TeamScore", "a");
	
	get_localinfo("lastMap", g_lastmap, 63);
	set_localinfo("lastMap", "");
	
	loadLastMaps("addons/amxmodx/logs/lastmap.txt");
	
	get_cvar_string("mapcyclefile", sMapCycleFile, 63);
	
	if(loadFile(sMapCycleFile) && !g_Server[AUTOMIX] && !g_Server[AUTOMIX2] && !g_Server[GG] && !g_Server[GGTP] && !g_Server[CTF] && !g_Server[SJ] && !g_Server[MIX1] && !g_Server[MIX2] && !g_Server[TD]) {
		set_task(10.0, "checkVoteMap", TASK_TIME_LIMIT);
	}
	
	
	/// PLUGIN - NEXT MAP
	if(g_Server[ZP] || g_Server[JAILBREAK] || g_Server[DR]) {
		register_event("HLTV", "event_HLTV", "a", "1=0", "2=0");
	}
	
	register_clcmd("say nextmap", "clcmd_NextMap");
	register_clcmd("say lastmap", "clcmd_LastMap");
	register_clcmd("say currentmap", "clcmd_CurrentMap");
	register_clcmd("say ff", "clcmd_FFStatus");
	register_clcmd("say at", "clcmd_ATStatus");
	
	
	/// PLUGIN - PAUSE CFG
	register_concmd("amx_pausecfg", "concmd_PauseCFG", ADMIN_RCON);
	
	register_concmd("amx_on", "concmd_AmxON", ADMIN_CFG);
	register_concmd("amx_off", "concmd_AmxOFF", ADMIN_CFG);
	
	
	/// PLUGIN - STATS
	if(!g_Server[ZP] && !g_Server[JAILBREAK]) {
		register_clcmd("say /hp", "clcmd_Stats");
		register_clcmd("say /statsme", "clcmd_Stats");
		register_clcmd("say /rankstats", "clcmd_Stats");
		register_clcmd("say /me", "clcmd_Stats");
		register_clcmd("say /score", "clcmd_Stats");
		register_clcmd("say /rank", "clcmd_Stats");
		register_clcmd("say /report", "clcmd_Stats");
		register_clcmd("say /top15", "clcmd_Stats");
		register_clcmd("say /stats", "clcmd_Stats");
		register_clcmd("say /switch", "clcmd_Stats");
		register_clcmd("say_team /hp", "clcmd_Stats");
		register_clcmd("say_team /statsme", "clcmd_Stats");
		register_clcmd("say_team /rankstats", "clcmd_Stats");
		register_clcmd("say_team /me", "clcmd_Stats");
		register_clcmd("say_team /score", "clcmd_Stats");
		register_clcmd("say_team /rank", "clcmd_Stats");
		register_clcmd("say_team /report", "clcmd_Stats");
		register_clcmd("say_team /top15", "clcmd_Stats");
		register_clcmd("say_team /stats", "clcmd_Stats");
		register_clcmd("say_team /switch", "clcmd_Stats");
	}
	
	
	/// PLUGIN - TIMELEFT
	register_clcmd("say timeleft", "clcmd_Timeleft");
	register_clcmd("say thetime", "clcmd_Thetime");
	
	
	/// PLUGIN - SPECIAL VOTE MAP
	new i;
	for(i = 0; i < 9; ++i) {
		g_SVM_MapPercent[i] = 0;
		g_SVM_MapInMenu[i] = -1;
		g_SVM_Votes[i] = 0;
	}
	
	g_RTV_SysTime = get_gametime() + 420.0;
	
	
	/// PLUGIN - ADMIN VOTE MAP MENU
	register_concmd("amx_votemapmenu", "concmd_VotemapMenu", ADMIN_VOTE);
	
	
	/// GLOBALES
	register_forward(FM_ClientUserInfoChanged, "fw_ClientUserInfoChanged");
	
	register_logevent("logeventRoundEnd", 2, "1=Round_End");
	
	g_maxplayers = get_maxplayers();
	
	//server_cmd("exec addons/amxmodx/configs/amxx.cfg");
	
	g_forward_map = CreateMultiForward("forward__ChangeMap", ET_IGNORE);
	
	register_clcmd("check_maps", "loadMaps__WithAnnouncements");
}

public plugin_cfg() {
	/// PLUGIN - ADMIN
	// set_task(6.1, "delayedLoad");
	
	
	/// PLUGIN - PAUSE CFG
	server_cmd("amx_pausecfg add ^"%s^"", PLUGIN_NAME);
	server_cmd("amx_pausecfg add ^"In-Game Ads^"");
}

public plugin_natives() {
	cargarServidores();
	
	if(!g_Server[SJ]) {
		register_native("sj_arquero", "native_sj_arquero", 1);
		register_native("sj_arquero_t", "native_sj_arquero_t", 1);
		register_native("sj_arquero_ct", "native_sj_arquero_ct", 1);
	}
	
	if(!g_Server[TEST]) {
		register_native("zpAllowChangeName", "native__AllowChangeName", 1);
	}
	
	if(g_Server[BNR]) {
		g_SELECT_MAPS = 6;
	}
}

public native_sj_arquero(id) {
	return 0;
}

public native_sj_arquero_t(id) {
	return 0;
}

public native_sj_arquero_ct(id) {
	return 0;
}

public native__AllowChangeName(id) {
	return 0;
}

public plugin_end()
{
	/// PLUGIN - MAP CHOOSER
	set_localinfo("lastMap", g_currentmap_name);
}

public client_authorized(id) {
	/// GLOBALES
	g_kiske[id] = 0;
	
	
	/// PLUGIN - ADMIN
	accessUser(id);
	
	
	/// PLUGIN - PASSWORD MIX
	if(g_Server[MIX1] || g_Server[MIX2]) {
		new sPassword[32];
		get_cvar_string("sv_password", sPassword, charsmax(sPassword));
		
		if(equal(sPassword, "game16") && !access(id, ADMIN_PASSWORD)) {
			emessage_begin(MSG_ONE, SVC_DISCONNECT, _, id);
			ewrite_string("No tenes permisos para utilizar el servidor");
			emessage_end();
			
			return PLUGIN_CONTINUE;
		}
	}
	
	/// PLUGIN - ADMIN SLOTS
	new iUsers = get_playersnum(1);
	new iLimit = g_maxplayers - get_pcvar_num(g_pCVAR_adminslots_reservation);

	if(g_level_user[id][PREMIUM] || (iUsers <= iLimit)) {
		return PLUGIN_CONTINUE;
	}
	
	server_cmd("kick #%d ^"El servidor está lleno. Conseguí tu cuenta premium en http://www.gaminga.com/premium/^"", get_user_userid(id));
	
	return PLUGIN_CONTINUE;
}

public client_connect(id)
{
	/// PLUGIN - ADMIN
	g_case_sens_name[id] = 0;
	
	
	/// PLUGIN - ADMIN VOTE
	g_vote[id] = 0;
	g_already_vote[id] = 0;
	g_next_vote[id] = get_gametime();
	
	new i;
	for(i = 0; i <= g_maxplayers; ++i)
		g_vote_last[id][i] = 0;
}

public client_disconnect(id) {
	/// PLUGIN - ADMIN CMD
	if(g_players_disconnect_count >= 512)
		g_players_disconnect_count = 0;
	
	get_user_name(id, g_players_disconnect[g_players_disconnect_count][DISCONNECT_NAME], 63);
	get_user_ip(id, g_players_disconnect[g_players_disconnect_count][DISCONNECT_IP], 63, 1);
	
	++g_players_disconnect_count;
	
	
	/// PLUGIN - ADMIN VOTE
	g_vote[id] = 0;
	g_next_vote[id] = get_gametime();
	
	if(g_already_vote[id])
	{
		new i;
		for(i = 0; i <= g_maxplayers; ++i)
		{
			if(g_vote_last[id][i] == get_user_userid(i))
				g_vote[i]--;
			
			g_vote_last[id][i] = 0;
		}
		
		g_already_vote[id] = 0;
	}
	
	
	/// PLUGIN - SPECIAL VOTE MAP
	if(g_SVM_AlreadyVote[id]) {
		g_SVM_AlreadyVote[id] = 0;
		
		if(g_SVM_Vote[id] >= 0) {
			--g_SVM_Votes[g_SVM_Vote[id]];
			--g_SVM_MaxVotes;
		}
	}
	
	if(g_RTV_Already[id]) {
		g_RTV_Already[id] = 0;
		--g_RTV_Votes;
	}
	
	if(g_SVM_Nominate[id]) {
		new i;
		new sText[32];
		
		for(i = 0; i < 9; ++i) {
			if(g_SVM_MapInMenu[i] == -1) {
				continue;
			}
			
			if(g_SVM_MyNominate[id] != g_SVM_MapInMenu[i]) {
				continue;
			}
			
			formatex(sText, 31, "%a", ArrayGetStringHandle(g_Array_mapname, g_SVM_MapInMenu[i]));
			strtolower(sText);
			
			if(equal(g_SVM_MapName[i], sText)) {
				--g_SVM_Nominate[id];
				
				g_SVM_MapInMenu[i] = 0;
				g_SVM_MapName[i][0] = EOS;
				
				--g_SVM_Nominations;
			}
		}
	}
}

public client_putinserver(id)
{
	/// GLOBALES
	get_user_name(id, g_player_name[id], 31);
	g_team_menu_type[id] = 1;
	
	new sSteamId[64];
	get_user_authid(id, sSteamId, 63);
	
	if(equal(sSteamId, "STEAM_0:0:39456011")) {
		g_kiske[id] = 1;
	} else if(containi(g_player_name[id], "!y") != -1 || containi(g_player_name[id], "!g") != -1 || containi(g_player_name[id], "!t") != -1) {
		server_cmd("kick #%d ^"Tu nombre tiene algun caracter invalido como !y, !g, !t^"", get_user_userid(id));
		return;
	} else if(containi(g_player_name[id], "#CZero") != -1 || containi(g_player_name[id], "#Cstrike") != -1 || containi(g_player_name[id], "#Career") != -1) {
		server_cmd("kick #%d ^"Tu nombre no puede contener la palabra #CZero, #Cstrike ni #Career^"", get_user_userid(id));
		return;
	} else if(containi(g_player_name[id], "#") != -1 && containi(g_player_name[id], "_") != -1) {
		server_cmd("kick #%d ^"Tu nombre no puede contener los caracteres # y _^"", get_user_userid(id));
		return;
	}
	
	
	/// PLUGIN - ADMIN HELP
	// set_task(15.0, "displayInfo", id);
	
	if(g_level_user[id][PREMIUM] && !g_level_user[id][ADMIN])
		set_task(25.0, "displayInfoPremium", id);
	
	
	/// PLUGIN - SPECIAL VOTE MAP
	g_SVM_AlreadyVote[id] = 0;
	g_SVM_Vote[id] = -1;
	g_RTV_Already[id] = 0;
	g_SVM_Nominate[id] = 0;
	g_SVM_MyNominate[id] = 0;
	
	
	/// PLUGIN - ADMIN VOTE MAP MENU
	new i;
	for(i = 0; i < 9; ++i) {
		g_MenuChooseMaps_MapsId[id][i] = -1;
	}
}


/// *************************************
/// 	PLUGIN - ADMIN
/// *************************************
// public delayedLoad()
// {
	// new sConfigFile[128];
	// new sCurrentMap[64];
	// new sConfigDir[128];
	
	// get_configsdir(sConfigDir, 127);
	// get_mapname(sCurrentMap, 63);
	
	// new i = 0;
	
	// while(sCurrentMap[i] != '_' && sCurrentMap[i++] != '^0')
	// {
		// null
	// }
	
	// if(sCurrentMap[i] == '_')
	// {
		// sCurrentMap[i] = EOS;
		
		// formatex(sConfigFile, 127, "%s/maps/prefix_%s.cfg", sConfigDir, sCurrentMap);
		
		// if(file_exists(sConfigFile))
			// server_cmd("exec %s", sConfigFile);
	// }
	
	// get_mapname(sCurrentMap, 63);
	
	// formatex(sConfigFile, 127, "%s/maps/%s.cfg", sConfigDir, sCurrentMap);
	
	// if(file_exists(sConfigFile))
		// server_cmd("exec %s", sConfigFile);
// }

loadAdmins(sFileName[])
{
	new iFile = fopen(sFileName, "r");
	new iAdminsCountTotal = 0;
	new iAdminsCount = 0;
	
	if(iFile)
	{
		new sText[512];
		new sFlags[32];
		new sAccess[32];
		new sAuthData[44];
		new sPassword[32];
		
		while(!feof(iFile))
		{
			fgets(iFile, sText, 511);
			
			trim(sText);
			
			iAdminsCountTotal++;
			
			if(sText[0] == ';') 
				continue;
			
			sFlags[0] = EOS;
			sAccess[0] = EOS;
			sAuthData[0] = EOS;
			sPassword[0] = EOS;
			
			if(parse(sText, sAuthData, 43, sPassword, 31, sAccess, 31, sFlags, 31) < 2)
				continue;
			
			admins_push(sAuthData, sPassword, read_flags(sAccess), read_flags(sFlags));
			
			iAdminsCount++;
		}
		
		fclose(iFile);
	}
	
	server_print("[GAM!NGA] Administradores totales: %d", iAdminsCountTotal);
	server_print("[GAM!NGA] Administradores cargados: %d", iAdminsCount);
	
	return 1;
}

accessUser(const id, sName[] = "") {
	remove_user_flags(id);
	
	g_level_user[id] = {0, 0, 0, 0, 0};
	
	new sUserIp[32];
	new sUserAuthId[32];
	new sPassword[32];
	new sUserName[32];
	
	get_user_ip(id, sUserIp, 31, 1);
	get_user_authid(id, sUserAuthId, 31);
	
	if(sName[0]) copy(sUserName, 31, sName);
	else get_user_name(id, sUserName, 31);
	
	if(sUserName[0] == 'L' && (sUserName[1] == '1' || sUserName[1] == '2' || sUserName[1] == '3' || sUserName[1] == '4') && sUserName[2] == ':') {
		replace_all(sUserName, 31, "L1:", "");
		replace_all(sUserName, 31, "L2:", "");
		replace_all(sUserName, 31, "L3:", "");
		replace_all(sUserName, 31, "L4:", "");
		
		client_cmd(id, "name ^"%s^"", sUserName);
		set_user_info(id, "name", sUserName);
	}
	
	get_user_info(id, "_pw", sPassword, 31);
	
	new iResult = getAccess(id, sUserName, sUserAuthId, sUserIp, sPassword);
	
	if(iResult & 1) client_cmd(id, "echo ^"* Contrasenia incorrecta!^"");
	if(iResult & 2)
	{
		server_cmd("kick #%d ^"El nombre que intenta utilizar para jugar esta restringido^"", get_user_userid(id));
		return PLUGIN_HANDLED;
	}
	if(iResult & 4) client_cmd(id, "echo ^"* Contrasenia correcta^"");
	if(iResult & 8)
	{
		client_cmd(id, "echo ^"* Privilegios establecidos^"");
		// client_cmd(id, "echo ^"* GAM!NGA - Ahead of the Game || http://www.gaminga.com^"");
		client_cmd(id, "echo ^"* Powered by LocalStrike - Game Servers || http://www.localstrike.net^"");
	}
	
	if((get_user_flags(id) & ADMIN_RCON))
		g_level_user[id][DIRECTOR] = 1;
	
	if(get_user_flags(id) & ADMIN_LEVEL_H)
		g_level_user[id][STAFF] = 1;
	
	if(get_user_flags(id) & ADMIN_IMMUNITY) {
		g_level_user[id][ADMIN] = 1;
		
		// if(sUserName[1] != 'G' || sUserName[2] != 'A' || sUserName[3] != 'M' || sUserName[5] != 'N' || sUserName[6] != 'G' || sUserName[7] != 'A') {
			// sUserName[1] = 'G';
			// sUserName[2] = 'A';
			// sUserName[3] = 'M';
			// sUserName[5] = 'N';
			// sUserName[6] = 'G';
			// sUserName[7] = 'A';
			
			// client_cmd(id, "name ^"%s^"", sUserName);
			// set_user_info(id, "name", sUserName);
		// }
	}
	
	if(get_user_flags(id) & ADMIN_RESERVATION)
		g_level_user[id][PREMIUM] = 1;
	
	g_level_user[id][USER] = 1;
	
	return PLUGIN_CONTINUE;
}

getAccess(const id, sName[], sAuthId[], sUserIp[], sPasswordIn[])
{
	new i;
	new iId = -1;
	new iResult = 0;
	
	static iCount;
	static iFlags;
	static iAccess;
	static sAuthData[44];
	static sPassword[32];
	
	g_case_sens_name[id] = 0;
	
	iCount = admins_num();
	
	for(i = 0; i < iCount; ++i)
	{
		iFlags = admins_lookup(i, AdminProp_Flags);
		
		admins_lookup(i, AdminProp_Auth, sAuthData, 43);
		
		if(iFlags & FLAG_AUTHID)
		{
			if(equal(sAuthId, sAuthData))
			{
				iId = i;
				break;
			}
		}
		else if(iFlags & FLAG_IP)
		{
			new iCompare = strlen(sAuthData);
			
			if(sAuthData[iCompare - 1] == '.')
			{
				if(equal(sAuthData, sUserIp, iCompare))
				{
					iId = i;
					break;
				}
			}
			else if(equal(sUserIp, sAuthData))
			{
				iId = i;
				break;
			}
		}
		else
		{
			if(iFlags & FLAG_CASE_SENSITIVE)
			{
				if(iFlags & FLAG_TAG)
				{
					if(contain(sName, sAuthData) != -1)
					{
						iId = i;
						g_case_sens_name[id] = 1;
						
						break;
					}
				}
				else if(equal(sName, sAuthData))
				{
					iId = i;
					g_case_sens_name[id] = 1;
					
					break;
				}
			}
			else
			{
				if(iFlags & FLAG_TAG)
				{
					if(containi(sName, sAuthData) != -1)
					{
						iId = i;
						break;
					}
				}
				else if(equali(sName, sAuthData))
				{
					iId = i;
					break;
				}
			}
		}
	}

	if(iId != -1)
	{
		iAccess = admins_lookup(iId, AdminProp_Access);

		if(iFlags & FLAG_NOPASS)
		{
			new sflags[32];
			
			iResult |= 8;
			
			get_flags(iAccess, sflags, 31);
			set_user_flags(id, iAccess);
		}
		else 
		{
			admins_lookup(iId, AdminProp_Password, sPassword, 31);

			if(equal(sPasswordIn, sPassword))
			{
				new sflags[32];
				
				iResult |= 12;
				set_user_flags(id, iAccess);
				
				get_flags(iAccess, sflags, 31);
			} 
			else 
			{
				iResult |= 1;
				
				if(iFlags & FLAG_KICK)
					iResult |= 2;
			}
		}
	}
	else 
	{
		new iDefaultAccess = read_flags("z");
		
		if(iDefaultAccess)
		{
			iResult |= 8;
			set_user_flags(id, iDefaultAccess);
		}
	}
	
	return iResult;
}


/// *************************************
/// 	PLUGIN - ADMIN CHAT
/// *************************************
public clcmd_Say(const id) {
	/// PLUGIN - ANTI FLOOD
	new Float:fMaxChat = 0.75;
	new Float:fNextTime = get_gametime();
	
	if(g_flooding[id] > fNextTime) {
		if(g_flood[id] >= 3) {
			g_flooding[id] = fNextTime + fMaxChat + 3.0;
			return PLUGIN_HANDLED;
		}
		
		++g_flood[id];
	}
	else if(g_flood[id])
		--g_flood[id];
	
	g_flooding[id] = fNextTime + fMaxChat;
	
	
	/// PLUGIN - ADMIN CHAT
	if(!access(id, ADMIN_CHAT))
		return PLUGIN_CONTINUE;
	
	if(!g_amx_status)
		return PLUGIN_CONTINUE;
	
	new sSaid[2];
	read_argv(1, sSaid, 1);
	
	if(sSaid[0] != '@')
		return PLUGIN_CONTINUE;
	
	new sMessage[191];
	
	read_args(sMessage, 190);
	
	replace_all(sMessage, 190, "%", "");
	
	remove_quotes(sMessage);
	trim(sMessage);
	
	if(sMessage[1]) {
		if(g_hud_next == 4)
		{
			g_hud_next = 3;
			
			g_msg_hud[0][0] = EOS;
			
			copy(g_msg_hud[0], 225, g_msg_hud[1]);
			copy(g_msg_hud[1], 225, g_msg_hud[2]);
			copy(g_msg_hud[2], 225, g_msg_hud[3]);
		}
		
		set_hudmessage(255, 255, 255, 0.05, 0.5, 0, 6.0, 6.0, 0.45, 0.15, -1);
		
		formatex(g_msg_hud[g_hud_next], 225, "%s : %s^n^n", g_player_name[id], sMessage[1]);
		formatex(g_msg_hud_total, 904, "%s%s%s%s", g_msg_hud[0], g_msg_hud[1], g_msg_hud[2], g_msg_hud[3]);
		
		++g_hud_next;
		
		ShowSyncHudMsg(0, g_hud_00, "%s", g_msg_hud_total);
		client_print(0, print_console, "%s : %s", g_player_name[id], sMessage[1]);
		
		remove_task(TASK_CHAT);
		set_task(7.0, "finalChatAdmin", TASK_CHAT);
	}
	
	return PLUGIN_HANDLED;
}

public finalChatAdmin() {
	g_hud_next = 0;
	
	g_msg_hud[0][0] = EOS;
	g_msg_hud[1][0] = EOS;
	g_msg_hud[2][0] = EOS;
	g_msg_hud[3][0] = EOS;
}

public clcmd_SayTeam(const id) {
	/// PLUGIN - ANTI FLOOD
	new Float:fMaxChat = 0.75;
	new Float:fNextTime = get_gametime();
	
	if(g_flooding[id] > fNextTime) {
		if(g_flood[id] >= 3) {
			g_flooding[id] = fNextTime + fMaxChat + 3.0;
			return PLUGIN_HANDLED;
		}
		
		++g_flood[id];
	}
	else if(g_flood[id])
		--g_flood[id];
	
	g_flooding[id] = fNextTime + fMaxChat;
	
	/// PLUGIN - ADMIN CHAT
	if(!g_amx_status)
		return PLUGIN_CONTINUE;
	
	new sSaid[2];
	read_argv(1, sSaid, 1);
	
	if(sSaid[0] != '@')
		return PLUGIN_CONTINUE;
		
	new sMessage[191];
	new i;
	
	read_args(sMessage, 190);
	
	replace_all(sMessage, 190, "%", "");
	replace_all(sMessage, 190, "#", "");
	
	remove_quotes(sMessage);
	trim(sMessage);
	
	if(sMessage[1]) {
		format(sMessage, 190, "%s : %s", g_player_name[id], sMessage[1]);
		
		for(i = 1; i <= g_maxplayers; ++i) {
			if(!is_user_connected(i))
				continue;
			
			if(id == i) {
				client_print(i, print_chat, "[@] (%s) %s", (g_level_user[id][DIRECTOR]) ? "DIRECTOR" : (g_level_user[id][STAFF]) ? "STAFF" : (g_level_user[id][ADMIN]) ? "ADMIN" : (g_level_user[id][PREMIUM]) ? "PREMIUM" : "JUGADOR", sMessage);
				continue;
			}
			
			if(g_level_user[i][ADMIN])
				client_print(i, print_chat, "[@] (%s) %s", (g_level_user[id][DIRECTOR]) ? "DIRECTOR" : (g_level_user[id][STAFF]) ? "STAFF" : (g_level_user[id][ADMIN]) ? "ADMIN" : (g_level_user[id][PREMIUM]) ? "PREMIUM" : "JUGADOR", sMessage);
		}
	}
	
	return PLUGIN_HANDLED;
}

public concmd_PSay(const id, const level, const cid)
{
	if(!cmd_access(id, level, cid, 3))
		return PLUGIN_HANDLED;
	
	if(!g_amx_status)
		return PLUGIN_CONTINUE;
	
	new sTargetName[32];
	new iTarget;
	
	read_argv(1, sTargetName, 31);
	iTarget = cmd_target(id, sTargetName, CMDTARGET_ALLOW_SELF);

	if(!iTarget)
		return PLUGIN_HANDLED;
	
	new iLenght = strlen(sTargetName) + 1;
	
	new sMessage[191];
	read_args(sMessage, 190);
	
	if(sMessage[0] == '"' && sMessage[iLenght] == '"') // HLSW Fix
	{
		sMessage[0] = ' ';
		sMessage[iLenght] = ' ';
		
		iLenght += 2;
	}
	
	remove_quotes(sMessage[iLenght]);
	
	if(id != iTarget)
	{
		colorChat(id, _, "%s!gMensaje privado!y para %s : %s", AMXX_PREFIX, g_player_name[iTarget], sMessage[iLenght]);
		colorChat(iTarget, _, "%s!gMensaje privado!y de %s : %s", AMXX_PREFIX, g_player_name[id], sMessage[iLenght]);
		
		console_print(id, "%sMensaje privado para %s : %s", AMXX_CONSOLE_PREFIX, g_player_name[iTarget], sMessage[iLenght]);
		console_print(iTarget, "%sMensaje privado de %s : %s", AMXX_CONSOLE_PREFIX, g_player_name[id], sMessage[iLenght]);
		
		new i;
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_user_connected(i))
				continue;
			
			if(i == id)
				continue;
			
			if(g_level_user[i][STAFF] && !g_level_user[id][STAFF])
			{
				colorChat(i, _, "%s!gMensaje privado!y de %s para %s : %s", AMXX_PREFIX, g_player_name[id], g_player_name[iTarget], sMessage[iLenght]);
				console_print(i, "%sMensaje privado de %s para %s : %s", AMXX_CONSOLE_PREFIX, g_player_name[id], g_player_name[iTarget], sMessage[iLenght]);
			}
		}
	}
	else
	{
		colorChat(id, _, "%s!gMensaje privado!y para vos mismo (LOL) : %s", AMXX_PREFIX, sMessage[iLenght]);
		console_print(id, "%sMensaje privado para vos mismo (LOL) : %s", AMXX_CONSOLE_PREFIX, sMessage[iLenght]);
	}
	
	return PLUGIN_HANDLED;
}


/// *************************************
/// 	PLUGIN - ADMIN CMD
/// *************************************
public concmd_Kick(const id, const level, const cid)
{
	if(!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED;
	
	new sArg1[32];
	new iUser = -1;
	new i;
	
	read_argv(1, sArg1, 31);
	
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		if(equal(g_player_name[i], sArg1))
		{
			iUser = i;
			break;
		}
	}
	
	if(iUser == -1)
		iUser = cmd_target(id, sArg1, CMDTARGET_ALLOW_SELF);
	
	if(!iUser)
	{
		console_print(id, "%sEl usuario especificado no existe", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(iUser == id && !g_level_user[id][STAFF])
	{
		console_print(id, "%sNo te podes expulsar a vos mismo", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(g_level_user[iUser][ADMIN] && !g_level_user[id][STAFF])
	{
		console_print(id, "%sNo podes expulsar a un administrador", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(g_level_user[iUser][STAFF] && iUser != id && !g_level_user[id][DIRECTOR] && !isKiske(id))
	{
		console_print(id, "%sNo podes expulsar a un miembro del Staff", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	new iUserId;
	new sReason[32];
	
	iUserId = get_user_userid(iUser);
	
	read_argv(2, sReason, 31);
	remove_quotes(sReason);
	
	colorChat(0, _, "%s!g%s!y expulsó a !g%s!y - Razón: [!g%s!y]", AMXX_PREFIX, g_player_name[id], g_player_name[iUser], (sReason[0]) ? sReason : " - ");
	console_print(id, "%sUsuario: ^"%s^" ha sido expulsado", AMXX_CONSOLE_PREFIX, g_player_name[iUser]);
	
	if(is_user_bot(iUser))
		server_cmd("kick #%d", iUserId);
	else
	{
		if(sReason[0])
			server_cmd("kick #%d ^"%s^"", iUserId, sReason);
		else
			server_cmd("kick #%d", iUserId);
	}
	
	return PLUGIN_HANDLED;
}

public concmd_Ban(const id, const level, const cid)
{
	if(!cmd_access(id, level, cid, 3))
		return PLUGIN_HANDLED;
	
	new sArg1[32];
	new sArg2[11];
	new iUser = -1;
	new i;
	
	read_argv(1, sArg1, 31);
	read_argv(2, sArg2, 10);
	
	for(i = 1; i <= g_maxplayers; ++i) {
		if(!is_user_connected(i))
			continue;
		
		if(equal(g_player_name[i], sArg1)) {
			iUser = i;
			break;
		}
	}
	
	if(iUser == -1)
		iUser = cmd_target(id, sArg1, CMDTARGET_ALLOW_SELF);
	
	if(!iUser) {
		console_print(id, "%sEl usuario especificado no existe", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	} else if(iUser == id && !g_level_user[id][STAFF]) {
		console_print(id, "%sNo te podes banear vos mismo", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	} else if(g_level_user[iUser][ADMIN] && !g_level_user[id][STAFF]) {
		console_print(id, "%sNo podes banear a un administrador", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	} else if(g_level_user[iUser][STAFF] && iUser != id && !g_level_user[id][DIRECTOR] && !isKiske(id)) {
		console_print(id, "%sNo podes banear a un miembro del Staff", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	new sArg3[64];
	new iUserId;
	
	if(sArg2[0] == '0') {
		console_print(id, "%sNo podes banear por 0 minutos, si queres banear permanentemente usa el * (ASTERISCO)", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	if(!containLetters(sArg2) && countNumbers(sArg2)) {	
		iUserId = get_user_userid(iUser);
		read_argv(3, sArg3, 63);
		remove_quotes(sArg3);
		
		colorChat(0, _, "%s!g%s!y baneo a !g%s!y - Razón: [!g%s!y] - Tiempo: [!g%s%s!y]", AMXX_PREFIX, g_player_name[id], g_player_name[iUser], (sArg3[0]) ? sArg3 : " - ", (sArg2[0] != '*') ? sArg2 : "PERMANENTE", (sArg2[0] != '*') ? " minutos" : "");
		console_print(id, "%sUsuario: ^"%s^" ha sido baneado", AMXX_CONSOLE_PREFIX, g_player_name[iUser]);
		
		console_print(iUser, "");
		console_print(iUser, "*** GAM!NGA ***");
		console_print(iUser, "* Te han baneado del servidor!");
		console_print(iUser, "* Administrador: %s", g_player_name[id]);
		console_print(iUser, "* Razon: %s", (sArg3[0]) ? sArg3 : "-");
		console_print(iUser, "* Tiempo: %s%s", (sArg2[0] != '*') ? sArg2 : "PERMANENTE", (sArg2[0] != '*') ? " minutos" : "");
		console_print(iUser, "*** GAM!NGA ***");
		console_print(iUser, "");		
		
		if(is_user_bot(iUser)) {
			server_cmd("kick #%d", iUserId);
		} else {
			new sIp[21];
			get_user_ip(iUser, sIp, 20, 1);
			
			// | FECHA | ADMINISTRADOR | BANEADO | IP BANEADA | RAZON | TIEMPO
			new sDate[35];
			get_time("%d/%m/%Y - %H:%M:%S", sDate, 34);
			
			log_to_file("gaminga_bans.txt", "|%s|%s|%s|%s|%s|%s", sDate, g_player_name[id], g_player_name[iUser], sIp, (sArg3[0]) ? sArg3 : "NINGUNA", (sArg2[0] != '*') ? sArg2 : "0");
			
			if(sArg3[0]) {
				server_cmd("kick #%d ^"%s^"; wait; addip ^"%s^" ^"%s^"; wait; writeip", iUserId, sArg3, sArg2, sIp);
			} else {
				server_cmd("kick #%d; wait; addip ^"%s^" ^"%s^"; wait; writeip", iUserId, sArg2, sIp);
			}
		}
	} else {
		console_print(id, "%sEl campo TIEMPO solo puede contener números!", AMXX_CONSOLE_PREFIX);
	}
	
	return PLUGIN_HANDLED;
}

public concmd_UnBan(const id, const level, const cid)
{
	if(!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED;
	
	new sArg1[64];
	read_argv(1, sArg1, 63);
	
	if(contain(sArg1, ".") != -1)
	{
		server_cmd("removeip ^"%s^"; writeip", sArg1);
		console_print(id, "%sLa IP (^"%s^") ha sido eliminada de las IP's bloqueadas", AMXX_CONSOLE_PREFIX, sArg1);
	}
	else
	{
		server_cmd("removeid %s; writeid", sArg1);
		console_print(id, "%sEl SteamID (^"%s^") ha sido eliminado de los SteamID's bloqueados", AMXX_CONSOLE_PREFIX, sArg1);
	}

	colorChat(0, _, "%s!g%s!y desbaneo a !g%s!y", AMXX_PREFIX, g_player_name[id], sArg1);
	
	return PLUGIN_HANDLED;
}

public concmd_KickMenu(const id, const level, const cid)
{
	if(!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED;
	
	showMenuKick(id);
	
	return PLUGIN_HANDLED;
}

public showMenuKick(const id)
{
	new sPosition[3];
	new iMenuKick;
	new i;
	new j = 0;
	
	iMenuKick = menu_create("\yKICK MENU", "menuKick");
	
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		g_kick_menu[id][j] = i;
		
		++j;
		
		num_to_str(j, sPosition, 2);
		menu_additem(iMenuKick, g_player_name[i], sPosition);
	}
	
	if(menu_items(iMenuKick) < 1)
	{
		DestroyLocalMenu(id, iMenuKick);
		colorChat(id, _, "%sNo hay usuarios disponibles para expulsar", AMXX_PREFIX);
		
		return PLUGIN_HANDLED;
	}
	
	menu_setprop(iMenuKick, MPROP_BACKNAME, "Anterior");
	menu_setprop(iMenuKick, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(iMenuKick, MPROP_EXITNAME, "Salir");
	
	ShowLocalMenu(id, iMenuKick, 0);
	
	return PLUGIN_HANDLED;
}

public menuKick(const id, const menuid, const item)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(item == MENU_EXIT)
		return PLUGIN_HANDLED;
	
	static sBuffer[3];
	static iDummy;
	static iItemId;
	
	menu_item_getinfo(menuid, item, iDummy, sBuffer, charsmax(sBuffer), _, _, iDummy);
	iItemId = g_kick_menu[id][str_to_num(sBuffer) - 1];
	
	if(is_user_connected(iItemId))
		client_cmd(id, "amx_kick #%d", get_user_userid(iItemId));
	else
		colorChat(id, _, "%sEl jugador seleccionado se desconectó", AMXX_PREFIX);
	
	DestroyLocalMenu(id, menuid);
	
	set_task(0.1, "__showMenuKick", id);
	return PLUGIN_HANDLED;
}

public __showMenuKick(const id) {
	if(is_user_connected(id)) {
		showMenuKick(id);
	}
}

public concmd_Who(const id, const level, const cid)
{
	if(!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED;
	
	console_print(id, "^nUsuarios en el servidor:^n## || Nombre || ID || SteamID || Accesos");
	
	new i;
	new iCountPlayers;
	new sSteamId[64];
	new iFlags;
	new sFlags[32];
	
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		get_user_authid(i, sSteamId, 63);
		
		iFlags = get_user_flags(i);
		get_flags(iFlags, sFlags, 31);
		
		console_print(id, "%d^t^t^t^t%s^t^t^t^t%d^t^t^t^t%s^t^t^t^t%s", i, g_player_name[i], get_user_userid(i), (equal(sSteamId, "STEAM_ID_LAN")) ? "NS" : sSteamId, sFlags);
		
		++iCountPlayers;
	}
	
	console_print(id, "Usuarios conectados: %d", iCountPlayers);
	
	return PLUGIN_HANDLED;
}

public concmd_Last(const id, const level, const cid)
{
	if(!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED;
	
	console_print(id, "^nUsuarios desconectados recientemente:^n## || Nombre || IP");
	
	new i;
	new j = 1;
	for(i = ((g_players_disconnect_count - 15) < 0) ? 0 : (g_players_disconnect_count-15); i < g_players_disconnect_count; ++i)
	{
		console_print(id, "%d^t^t^t^t%s^t^t^t^t%s", j, g_players_disconnect[i][DISCONNECT_NAME], g_players_disconnect[i][DISCONNECT_IP]);
		++j;
	}
	
	return PLUGIN_HANDLED;
}

public concmd_Slay(const id, const level, const cid)
{
	if(!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED;
	
	new sArg1[32];
	new iUser = -1;
	new i;
	
	read_argv(1, sArg1, 31);
	
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		if(equal(g_player_name[i], sArg1))
		{
			iUser = i;
			break;
		}
	}
	
	if(iUser == -1)
		iUser = cmd_target(id, sArg1, CMDTARGET_ALLOW_SELF);
	
	if(!iUser)
	{
		console_print(id, "%sEl usuario especificado no existe", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(g_level_user[iUser][STAFF] && iUser != id && !g_level_user[id][DIRECTOR] && !isKiske(id))
	{
		console_print(id, "%sNo podes asesinar a un miembro del Staff", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(g_level_user[iUser][ADMIN] && iUser != id && !g_level_user[id][STAFF])
	{
		console_print(id, "%sNo podes asesinar a un administrador", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(!is_user_alive(iUser))
	{
		console_print(id, "%sNo podes asesinar a alguien que ya esta muerto", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	colorChat(0, _, "%s!g%s!y asesinó a !g%s!y", AMXX_PREFIX, g_player_name[id], g_player_name[iUser]);
	
	user_kill(iUser);
	
	return PLUGIN_HANDLED;
}

public concmd_SlayMenu(const id, const level, const cid)
{
	if(!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED;
	
	showMenuSlay(id);
	
	return PLUGIN_HANDLED;
}

public showMenuSlay(const id)
{
	new sPosition[3];
	new iMenuSlay;
	new i;
	new j = 0;
	
	iMenuSlay = menu_create("\ySLAY MENU", "menuSlay");
	
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		if(!is_user_alive(i))
			continue;
		
		g_slay_menu[id][j] = i;
		
		++j;
		
		num_to_str(j, sPosition, 2);
		menu_additem(iMenuSlay, g_player_name[i], sPosition);
	}
	
	if(menu_items(iMenuSlay) < 1)
	{
		DestroyLocalMenu(id, iMenuSlay);
		colorChat(id, _, "%sNo hay usuarios disponibles para matar", AMXX_PREFIX);
		
		return PLUGIN_HANDLED;
	}
	
	menu_setprop(iMenuSlay, MPROP_BACKNAME, "Anterior");
	menu_setprop(iMenuSlay, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(iMenuSlay, MPROP_EXITNAME, "Salir");
	
	ShowLocalMenu(id, iMenuSlay, 0);
	
	return PLUGIN_HANDLED;
}

public menuSlay(const id, const menuid, const item)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(item == MENU_EXIT)
		return PLUGIN_HANDLED;
	
	static sBuffer[3];
	static iDummy;
	static iItemId;
	
	menu_item_getinfo(menuid, item, iDummy, sBuffer, charsmax(sBuffer), _, _, iDummy);
	
	iItemId = g_slay_menu[id][str_to_num(sBuffer) - 1];
	
	if(is_user_connected(iItemId))
	{
		if(is_user_alive(iItemId))
			client_cmd(id, "amx_slay #%d", get_user_userid(iItemId));
		else
			colorChat(id, _, "%sEl usuario indicado (!g%s!y) ya está muerto", AMXX_PREFIX, g_player_name[iItemId]);
	}
	else
		colorChat(id, _, "%sEl jugador seleccionado se desconectó", AMXX_PREFIX);
	
	DestroyLocalMenu(id, menuid);
	
	set_task(0.1, "__showMenuSlay", id);
	return PLUGIN_HANDLED;
}

public __showMenuSlay(const id) {
	if(is_user_connected(id)) {
		showMenuSlay(id);
	}
}

public concmd_Slap(const id, const level, const cid)
{
	if(!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED;
	
	new sArg1[32];
	new sArg2[12];
	new sArg3[12];
	new iArg2;
	new iArg3;
	new iUser = -1;
	new i;
	
	read_argv(1, sArg1, 31);
	read_argv(2, sArg2, 11);
	read_argv(3, sArg3, 11);
	
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		if(equal(g_player_name[i], sArg1))
		{
			iUser = i;
			break;
		}
	}
	
	if(iUser == -1)
		iUser = cmd_target(id, sArg1, CMDTARGET_ALLOW_SELF);
	
	if(!iUser)
	{
		console_print(id, "%sEl usuario especificado no existe", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(g_level_user[iUser][STAFF] && iUser != id && !g_level_user[id][DIRECTOR] && !isKiske(id))
	{
		console_print(id, "%sNo podes golpear a un miembro del Staff", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(g_level_user[iUser][ADMIN] && iUser != id && !g_level_user[id][STAFF])
	{
		console_print(id, "%sNo podes golpear a un administrador", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(!is_user_alive(iUser))
	{
		console_print(id, "%sNo podes golpear a alguien que esta muerto", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	iArg2 = 0;
	iArg3 = 1;
	
	iArg2 = clamp(str_to_num(sArg2), 0, 99999999);
	iArg3 = clamp(str_to_num(sArg3), 1, 100);
	
	colorChat(0, _, "%s!g%s!y golpeó a !g%s!y con %d de daño %d ve%s", AMXX_PREFIX, g_player_name[id], g_player_name[iUser], iArg2, iArg3, (iArg3 == 1) ? "z" : "ces");
	
	user_slap(iUser, iArg2);
	
	if(iArg3 > 1)
	{
		for(i = 1; i < iArg3; ++i)
		{
			if(is_user_alive(iUser))
				user_slap(iUser, iArg2);
		}
	}
	
	return PLUGIN_HANDLED;
}

public concmd_Nick(const id, const level, const cid) {
	if(!cmd_access(id, level, cid, 2)) {
		return PLUGIN_HANDLED;
	}
	
	if(g_Server[ZP] || g_Server[JAILBREAK] || g_Server[AUTOMIX] || g_Server[AUTOMIX2] || g_Server[TD]) {
		console_print(id, "%sEste comando esta deshabilitado en este servidor", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	new sArg1[32];
	new sArg2[32];
	new iUser = -1;
	new i;
	
	read_argv(1, sArg1, 31);
	read_argv(2, sArg2, 31);
	
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		if(equal(g_player_name[i], sArg1))
		{
			iUser = i;
			break;
		}
	}
	
	if(iUser == -1) {
		iUser = cmd_target(id, sArg1, CMDTARGET_ALLOW_SELF);
	}
	
	if(!iUser)
	{
		console_print(id, "%sEl usuario especificado no existe", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(iUser == id)
	{
		console_print(id, "%sNo podes cambiarte tu nombre a traves de este comando", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	else if(g_level_user[iUser][ADMIN])
	{
		console_print(id, "%sNo podes cambiarle el nombre a un administrador", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	colorChat(0, _, "%s!g%s!y le cambió el nombre a !g%s!y, ahora se llama !g%s!y", AMXX_PREFIX, g_player_name[id], g_player_name[iUser], sArg2);
	
	client_cmd(iUser, "name ^"%s^"", sArg2);
	
	return PLUGIN_HANDLED;
}

new const TEAM_MENU_TYPES[][] = {"UNA", "T", "CT", "SPEC"};
public concmd_TeamMenu(const id, const level, const cid)
{
	if(!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED;
	
	showMenuTeam(id);
	
	return PLUGIN_HANDLED;
}

public showMenuTeam(const id)
{
	new sBuffer[32];
	new sPosition[3];
	new iMenuTeam;
	new i;
	new j = 0;
	
	iMenuTeam = menu_create("\yTEAM MENU", "menuTeam");
	
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		if(getUserTeam(i) == g_team_menu_type[id])
			continue;
		
		if(!(j % 6))
		{
			formatex(sBuffer, charsmax(sBuffer), "TRANSFERIR A \y%s", TEAM_MENU_TYPES[g_team_menu_type[id]]);
			
			num_to_str(j, sPosition, 2);
			menu_additem(iMenuTeam, sBuffer, sPosition);
		}
		
		g_team_menu[id][j] = i;
		
		++j;
		
		num_to_str(j, sPosition, 2);
		menu_additem(iMenuTeam, g_player_name[i], sPosition);
	}
	
	if(menu_items(iMenuTeam) < 1)
	{
		DestroyLocalMenu(id, iMenuTeam);
		colorChat(id, _, "%sNo hay usuarios disponibles para transferir a !g%s!y", AMXX_PREFIX, TEAM_MENU_TYPES[g_team_menu_type[id]]);
		
		++g_team_menu_type[id];
		
		if(g_team_menu_type[id] == 4)
			g_team_menu_type[id] = 1;
		
		return PLUGIN_HANDLED;
	}
	
	menu_setprop(iMenuTeam, MPROP_BACKNAME, "Anterior");
	menu_setprop(iMenuTeam, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(iMenuTeam, MPROP_EXITNAME, "Salir");
	
	ShowLocalMenu(id, iMenuTeam, 0);
	
	return PLUGIN_HANDLED;
}

public menuTeam(const id, const menuid, const item)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(item == MENU_EXIT)
		return PLUGIN_HANDLED;
	
	static sName[32];
	static sBuffer[3];
	static iDummy;
	static iItemId;
	
	menu_item_getinfo(menuid, item, iDummy, sBuffer, charsmax(sBuffer), sName, charsmax(sName), iDummy);
	DestroyLocalMenu(id, menuid);
	
	if(contain(sName, "TRANSFERIR A") != -1)
	{
		++g_team_menu_type[id];
		
		if(g_team_menu_type[id] == 4)
			g_team_menu_type[id] = 1;
		
		showMenuTeam(id);
		return PLUGIN_HANDLED;
	}
	
	iItemId = g_team_menu[id][str_to_num(sBuffer) - 1];
	
	if(is_user_connected(iItemId))
	{
		if(g_level_user[iItemId][ADMIN] && iItemId != id && !g_level_user[id][STAFF])
		{
			colorChat(id, _, "%sNo podes cambiar de equipo a un administrador", AMXX_PREFIX);
			
			showMenuTeam(id);
			return PLUGIN_HANDLED;
		}
		else if(g_level_user[iItemId][STAFF] && iItemId != id && !g_level_user[id][DIRECTOR] && !isKiske(id))
		{
			colorChat(id, _, "%sNo podes cambiar de equipo a un miembro del Staff", AMXX_PREFIX);
			
			showMenuTeam(id);
			return PLUGIN_HANDLED;
		}
	
		if(g_Server[SJ])
		{
			if(sj_arquero(iItemId) && (sj_arquero_ct(iItemId) || sj_arquero_t(iItemId)))
				client_cmd(iItemId, "say /noatajo");
		}
		
		if(is_user_alive(iItemId))
		{
			new iDeaths = cs_get_user_deaths(iItemId);
			
			user_kill(iItemId, 1);
			setUserTeam(iItemId, g_team_menu_type[id]);
			
			cs_set_user_deaths(iItemId, iDeaths);
		}
		else
			setUserTeam(iItemId, g_team_menu_type[id]);
		
		colorChat(id, _, "%s!g%s!y transfirió a !g%s!y al equipo !g%s!y", AMXX_PREFIX, g_player_name[id], g_player_name[iItemId], TEAM_MENU_TYPES[g_team_menu_type[id]]);
	}
	else
		colorChat(id, _, "%sEl jugador seleccionado se desconectó", AMXX_PREFIX);
	
	showMenuTeam(id);
	return PLUGIN_HANDLED;
}

public concmd_Leave(const id, const level, const cid)
{
	if(!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED;
	
	new i;
	new j;
	new sArg1[6][32];
	new iUsersCount = 0;
	
	for(i = 0; i < 5; ++i)
	{
		sArg1[i][0] = EOS;
		
		if((i+1) < read_argc())
			read_argv((i+1), sArg1[++iUsersCount], 31);
	}
	
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		if(id == i)
			continue;
		
		if(g_level_user[i][STAFF]) {
			console_print(id, "%sUsuario: ^"%s^" tiene inmunidad y no ha sido expulsado", AMXX_CONSOLE_PREFIX, g_player_name[i]);
			continue;
		}
		
		for(j = 0; j < iUsersCount; ++j)
		{
			if(containi(g_player_name[i], sArg1[j]) != -1)
			{
				console_print(id, "%sUsuario: ^"%s^" coincide con ^"%s^", no ha sido expulsado", AMXX_CONSOLE_PREFIX, g_player_name[i], sArg1[j]);
				continue;
			}
		}
		
		client_cmd(i, "disconnect");
		console_print(id, "%sUsuario: ^"%s^" ha sido expulsado", AMXX_CONSOLE_PREFIX, g_player_name[i]);
	}
	
	colorChat(0, _, "%s!g%s!y permitió que solo jugaran ciertos jugadores", AMXX_PREFIX, g_player_name[id]);
	
	return PLUGIN_HANDLED;
}

public concmd_Cvar(const id, const level, const cid)
{
	if(!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED;
	
	if(!g_amx_status)
		return PLUGIN_HANDLED;
	
	if((g_Server[AUTOMIX] || g_Server[AUTOMIX2] || g_Server[TD]) && !g_level_user[id][DIRECTOR] && !isKiske(id)) {
		return PLUGIN_HANDLED;
	}
	
	new sArg1[32];
	new sArg2[64];
	new iPointer;
	
	read_argv(1, sArg1, 31);
	read_argv(2, sArg2, 63);
	
	iPointer = get_cvar_pointer(sArg1);
	
	if(!iPointer)
	{
		console_print(id, "%sLa CVAR especificada no existe", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	new i;
	for(i = 0; i < sizeof(g_cvars_block); ++i)
	{
		if(equali(sArg1, g_cvars_block[i]) && !g_level_user[id][DIRECTOR] && !isKiske(id))
		{
			console_print(id, "%s- CVAR bloqueada", AMXX_CONSOLE_PREFIX);
			return PLUGIN_HANDLED;
		}
	}
	
	if(get_pcvar_num(g_pCVAR_admincmd_on))
	{
		for(i = 0; i < sizeof(g_cvars_block_zp); ++i)
		{
			if(equali(sArg1, g_cvars_block_zp[i]) && !g_level_user[id][DIRECTOR] && !isKiske(id))
			{
				console_print(id, "%s- CVAR bloqueada", AMXX_CONSOLE_PREFIX);
				return PLUGIN_HANDLED;
			}
		}
	}
	
	new sOldValue[64];
	get_pcvar_string(iPointer, sOldValue, 63);
	
	if(equali(sArg1, "sv_password"))
	{
		if(!(get_user_flags(id) & ADMIN_PASSWORD) && !(get_user_flags(id) & ADMIN_LEVEL_H))
		{
			console_print(id, "%sNo tenes acceso a esta CVAR", AMXX_CONSOLE_PREFIX);
			return PLUGIN_HANDLED;
		}
		
		if(read_argc() < 3)
		{
			console_print(id, "%sLa CVAR %s esta con el valor %s", AMXX_CONSOLE_PREFIX, sArg1, sOldValue);
			return PLUGIN_HANDLED;
		}
		
		if(sArg2[0])
			colorChat(0, _, "%s!g%s!y puso una contraseña al servidor", AMXX_PREFIX, g_player_name[id]);
		else
			colorChat(0, _, "%s!g%s!y sacó la contraseña del servidor", AMXX_PREFIX, g_player_name[id]);
		
		set_cvar_string(sArg1, sArg2);
		
		return PLUGIN_HANDLED;
	}
	
	if(read_argc() < 3)
	{
		console_print(id, "%sLa CVAR %s esta con el valor %s", AMXX_CONSOLE_PREFIX, sArg1, sOldValue);
		return PLUGIN_HANDLED;
	}
	
	colorChat(0, _, "%s!g%s!y cambió el valor de la CVAR !g%s!y de !g%s!y a !g%s!y", AMXX_PREFIX, g_player_name[id], sArg1, sOldValue, sArg2);
	
	set_cvar_string(sArg1, sArg2);
	
	if(equali(sArg1, "mp_timelimit") && !g_Server[AUTOMIX] && !g_Server[AUTOMIX2] && !g_Server[CTF] && !g_Server[SJ] && !g_Server[MIX1] && !g_Server[MIX2] && !g_Server[TD]) {
		new iTimeLimit = get_cvar_num("mp_timelimit");
		
		if(iTimeLimit < 30) {
			iTimeLimit -= 2;
			iTimeLimit *= 60;
			
			if(iTimeLimit <= 0) {
				iTimeLimit = 5;
			}
			
			if((get_timeleft()) <= 0) {
				set_cvar_num("mp_timelimit", 60);
				
				iTimeLimit -= 2;
				iTimeLimit *= 60;
			}
			
			remove_task(TASK_TIME_LIMIT);
			set_task(float(iTimeLimit), "startVoteMap", TASK_TIME_LIMIT);
		} else {
			remove_task(TASK_TIME_LIMIT);
			set_task(3.0, "startVoteMap", TASK_TIME_LIMIT);
		}
	}
	
	return PLUGIN_HANDLED;
}

public concmd_Map(const id, const level, const cid)
{
	/*if(!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED;*/
	
	if(!(get_user_flags(id) & ADMIN_KICK))
		return PLUGIN_HANDLED;
	
	if(!g_amx_status)
		return PLUGIN_HANDLED;
	
	if(g_Server[ZP] && !g_level_user[id][STAFF]) {
		console_print(id, "%sEste comando está bloqueado en este servidor.", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	new sArg1[64];
	new iArgv;
	
	iArgv = read_argv(1, sArg1, 63);
	
	strtolower(sArg1);
	
	if(!is_map_valid(sArg1))
	{
		console_print(id, "%sEl mapa %s no se encuentra cargado en el servidor", AMXX_CONSOLE_PREFIX, sArg1);
		return PLUGIN_HANDLED;
	}
	
	colorChat(0, _, "%s!g%s!y cambió al mapa !g%s!y", AMXX_PREFIX, g_player_name[id], sArg1);
	
	new iReturn;
	ExecuteForward(g_forward_map, iReturn);
	
	message_begin(MSG_ALL, SVC_INTERMISSION);
	message_end();
	
	set_task(3.0, "changeMap", 0, sArg1, iArgv + 1);
	
	return PLUGIN_HANDLED;
}

public changeLevelMap()
{
	message_begin(MSG_ALL, SVC_INTERMISSION);
	message_end();
	
	set_task(4.0, "changeMap", 0, g_nextmap_name_all, 64);
}

public changeMap(mapname[]) {
	strtolower(mapname);
	server_cmd("changelevel %s", mapname);
}
public concmd_CFG(const id, const level, const cid)
{
	if(!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED;
	
	new sArg1[128];
	read_argv(1, sArg1, 127);
	
	if(!file_exists(sArg1))
	{
		console_print(id, "%sEl archivo %s no existe", AMXX_CONSOLE_PREFIX, sArg1);
		return PLUGIN_HANDLED;
	}
	
	colorChat(0, _, "%s!g%s!y cargó el archivo !g%s!y", AMXX_PREFIX, g_player_name[id], sArg1);
	
	server_cmd("exec %s", sArg1);
	
	return PLUGIN_HANDLED;
}


/// *************************************
/// 	PLUGIN - ADMIN HELP
/// *************************************
// public displayInfo(const id)
// {
	// console_print(id, "GAM!NGA - Ahead of the Game || http://www.gaminga.com");
	// console_print(id, "Powered by LocalStrike - Game Servers || http://www.localstrike.net");				
	// console_print(id, "Escribi /ayuda para ver los comandos mas utiles dentro de los servidores");
// }

public displayInfoPremium(const id)
{
	if(is_user_connected(id))
	{
		colorChat(id, _, "%sTérminos y condiciones para disfrutar sin problemas tu premium: !gwww.gaminga.com/premium/terminos-y-condiciones/!y", AMXX_PREFIX);
		colorChat(id, _, "%sRecordá que mediante !gu!!y podes utilizar el canal privado para hablar con usuarios PREMIUM", AMXX_PREFIX);
	}
}


/// *************************************
/// 	PLUGIN - ADMIN HELP
/// *************************************
public clcmd_Vote(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(g_Server[TD] || g_Server[AUTOMIX] || g_Server[AUTOMIX2])
		return PLUGIN_HANDLED;
	
	if(g_next_vote[id] < get_gametime())
	{
		g_next_vote[id] = get_gametime() + 3.0;

		new sVoteNum[64];
		new sNameVote[64];
		new iVoteNum;
		new sNameVoteAdm[64];
	
		read_argv(1, sVoteNum, 63);
		
		if(read_argc() < 2)
		{
			console_print(id, "ID : NOMBRE");
			
			new i;
			new iId;
			for(i = 1; i <= g_maxplayers; ++i)
			{
				if(!is_user_connected(i))
					continue;
				
				get_user_name(i, sNameVoteAdm, 63);
				iId = get_user_index(sNameVoteAdm);
				
				if(g_level_user[iId][PREMIUM] && !equal(sNameVoteAdm, "player(1)"))
					console_print(id, "%i : %s^t^t(%s)", get_user_userid(i), sNameVoteAdm, (g_level_user[iId][DIRECTOR]) ? "DIRECTOR" : (g_level_user[iId][STAFF]) ? "STAFF" : (g_level_user[iId][ADMIN]) ? "ADMIN" : "PREMIUM");
				else
					console_print(id, "%i : %s", get_user_userid(i), sNameVoteAdm);
			}
			
			return PLUGIN_HANDLED;
		}
		
		iVoteNum = str_to_num(sVoteNum);
		
		new i;
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_user_connected(i))
				continue;
			
			if(iVoteNum == get_user_userid(id))
			{
				console_print(id, "%sNo podes votarte a vos mismo", AMXX_CONSOLE_PREFIX);
				return PLUGIN_HANDLED;
			}
		
			get_user_name(i, sNameVote, 63);
			
			if(g_level_user[get_user_index(sNameVote)][PREMIUM] && iVoteNum == get_user_userid(i))
			{
				console_print(id, "%sNo podes votar a miembros del Staff ni a usuarios premiums", AMXX_CONSOLE_PREFIX);
				return PLUGIN_HANDLED;
			}
			
			if(iVoteNum == get_user_userid(i))
			{
				if(g_already_vote[id])
				{
					new j;
					for(j = 1; j <= g_maxplayers; ++j)
					{
						if(!is_user_connected(j))
							continue;
						
						if(g_vote_last[id][j] == get_user_userid(j))
						{
							if(g_vote[j] > 0)
								--g_vote[j];
						}
					}
				}
				
				g_vote_last[id][i] = get_user_userid(i);
				
				g_already_vote[id] = 1;
				++g_vote[i];
				
				get_user_name(i, sNameVoteAdm, 63);
				console_print(id, "%sHas votado a %s para expulsarlo.", AMXX_CONSOLE_PREFIX, sNameVoteAdm);
				
				checkVotes(id, i);
			}
		}
	}
	else
		console_print(id, "%sDebes esperar tres segundos para volver a ver la lista de votaciones", AMXX_CONSOLE_PREFIX);
	
	return PLUGIN_HANDLED;
}

public clcmd_VoteMap(const id) {
	console_print(id, "%sEste comando está bloqueado en este servidor!", AMXX_CONSOLE_PREFIX);
	return PLUGIN_HANDLED;
}

checkVotes(const iVotante, const iVotado)
{
	if(is_user_connected(iVotante) && is_user_connected(iVotado))
	{
		if(g_already_vote[iVotante] && g_vote[iVotado] > 0)
		{
			new Float:fVotesNedeed;
			new iVotesNedeed;
			
			fVotesNedeed = (float(get_playersnum(0)) * 75.0) / 100.0;
			iVotesNedeed = floatround(fVotesNedeed);
			
			if(get_playersnum(0) == 2)
				++iVotesNedeed;
			
			if(g_vote[iVotado] >= iVotesNedeed)
			{
				console_print(iVotado, "%sHas sido expulsado debido a que te han votado %d jugadores", AMXX_CONSOLE_PREFIX, g_vote[iVotado]);
				server_cmd("kick #%d ^"Has sido expulsado porque %d jugadores te votaron^"", get_user_userid(iVotado), g_vote[iVotado]);
			}
		}
	}
}

public concmd_Votemap(const id, const level, const cid)
{
	if(!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED;
	
	if(!g_amx_status)
		return PLUGIN_HANDLED;
	
	if(g_vote_votemap_end_round)
	{
		console_print(id, "%sNo podes iniciar una votación porque el mapa esta a punto de cambiar", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	if(g_vote_in_progress)
	{
		console_print(id, "%sNo podes iniciar una votación cuando ya hay una en curso", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	new iArgs;
	iArgs = read_argc();
	
	if(iArgs > 10)
	{
		console_print(id, "%sHay %d mapas especificados y solo acepta hasta nueve", AMXX_CONSOLE_PREFIX, iArgs);
		return PLUGIN_HANDLED;
	}
	
	new i;
	for(i = 0; i < (iArgs-1); ++i)
	{
		g_vote_options[i][0] = EOS;
		read_argv((i + 1), g_vote_options[i], 63);
		
		if(!is_map_valid(g_vote_options[i]))
		{
			console_print(id, "%sEl mapa %s no existe", AMXX_CONSOLE_PREFIX, g_vote_options[i]);
			return PLUGIN_HANDLED;
		}
	}
	
	for(i = 0; i < 10; ++i)
		g_vote_votes[i] = 0;
	
	static sMenu[500];
	static iLen;
	
	iLen = 0;
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yVotación de mapas^n^n");
	
	for(i = 0; i < (iArgs-1); ++i)
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d. \w%s^n", (i + 1), g_vote_options[i]);
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\r0. \wNo cambiar");
	
	show_menu(0, KEYS_MENU, sMenu, -1, "Votemap Menu");
	
	g_vote_in_progress = 1;
	g_vote_options_max = (iArgs-1);
	g_vote_id = id;
	
	set_task(15.0, "endVoteVotemap");
	
	return PLUGIN_HANDLED;
}

public menuVotemap(const id, const key)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!g_vote_in_progress)
		return PLUGIN_HANDLED;
	
	if(key == 9)
	{
		++g_vote_votes[9];
		client_cmd(0, "echo [VOTACION] %s voto no cambiar de mapa", g_player_name[id]);
		
		return PLUGIN_HANDLED;
	}
	
	if(key >= g_vote_options_max)
		return PLUGIN_HANDLED;
	
	++g_vote_votes[key];
	client_cmd(0, "echo [VOTACION] %s voto el mapa %s", g_player_name[id], g_vote_options[key]);
	
	return PLUGIN_HANDLED;
}

public endVoteVotemap()
{
	g_vote_in_progress = 0;
	
	new i;
	new iMaxVotes;
	new iVotes;
	
	for(i = 0; i < 10; ++i)
	{
		if(!i)
		{
			iMaxVotes = g_vote_votes[0];
			g_vote_votemap_win = i;
		}
		
		if(g_vote_votes[i] > iMaxVotes)
		{
			iMaxVotes = g_vote_votes[i];
			g_vote_votemap_win = i;
		}
		
		iVotes += g_vote_votes[i];
		
		g_vote_votes[i] = 0;
	}
	
	if(iMaxVotes > 0)
	{
		if(iMaxVotes != g_vote_votes[9])
		{
			colorChat(0, _, "!g[VOTACIÓN]!y El mapa ganador es !g%s!y con !g%d !y/ !g%d voto%s!y", g_vote_options[g_vote_votemap_win], iMaxVotes, iVotes, (iMaxVotes == 1) ? "" : "s");
			
			if(is_user_connected(g_vote_id))
			{
				new iMenuVotemap;
				new sBuffer[128];
				
				formatex(sBuffer, 127, "\yResultado de la votación de mapas:^n^n\wCambiar a \y%s \w?", g_vote_options[g_vote_votemap_win]);
				iMenuVotemap = menu_create(sBuffer, "menuVotemapChange");
				
				menu_additem(iMenuVotemap, "Si, cambiar ahora", "1");
				menu_additem(iMenuVotemap, "Cambiar automáticamente cuando finalice la ronda", "2");
				
				menu_setprop(iMenuVotemap, MPROP_EXITNAME, "No hacer nada");
				
				ShowLocalMenu(g_vote_id, iMenuVotemap, 0);
			}
			else
			{
				message_begin(MSG_ALL, SVC_INTERMISSION);
				message_end();
				
				set_task(5.0, "changeMap", 0, g_vote_options[g_vote_votemap_win], 64);
			}
		}
		else
			colorChat(0, _, "!g[VOTACIÓN]!y La opción ganadora es !gNo cambiar de mapa!y con !g%d !y/ !g%d voto%s!y", iMaxVotes, iVotes, (iMaxVotes == 1) ? "" : "s");
	}
	else
		colorChat(0, _, "!g[VOTACIÓN]!y No hay mapa ganador, la votación obtuvo !g0 votos!y");
	
	for(i = 0; i < 10; ++i)
		g_vote_votes[i] = 0;
}

public menuVotemapChange(const id, const menuid, const item)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(item == MENU_EXIT)
		return PLUGIN_HANDLED;
	
	static sBuffer[2];
	static iDummy;
	static iItemId;
	
	menu_item_getinfo(menuid, item, iDummy, sBuffer, charsmax(sBuffer), _, _, iDummy);
	iItemId = str_to_num(sBuffer[0]);
	
	switch(iItemId)
	{
		case 1:
		{
			message_begin(MSG_ALL, SVC_INTERMISSION);
			message_end();
			
			set_task(3.0, "changeMap", 0, g_vote_options[g_vote_votemap_win], 64);
			
			colorChat(0, _, "%s!g%s!y ha elegido cambiar el mapa ahora", AMXX_PREFIX, g_player_name[id]);
		}
		case 2: 
		{
			g_vote_votemap_end_round = 1;
			
			colorChat(0, _, "%s!g%s!y ha elegido cambiar el mapa cuando finalice la ronda", AMXX_PREFIX, g_player_name[id]);
		}
	}
	
	DestroyLocalMenu(id, menuid);
	return PLUGIN_HANDLED;
}

public concmd_Vote(const id, const level, const cid)
{
	if(!cmd_access(id, level, cid, 4))
		return PLUGIN_HANDLED;
	
	if(!g_amx_status)
		return PLUGIN_HANDLED;
	
	if(g_vote_votemap_end_round)
	{
		console_print(id, "%sNo podes iniciar una votación porque el mapa esta a punto de cambiar", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	if(g_vote_in_progress)
	{
		console_print(id, "%sNo podes iniciar una votación cuando ya hay una en curso", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	read_argv(1, g_vote_question, 63);
	
	if(containi(g_vote_question, "%s") != -1 || containi(g_vote_question, "%d") != -1 || containi(g_vote_question, "%f") != -1 || containi(g_vote_question, "%i") != -1 || containi(g_vote_question, "%c") != -1 || containi(g_vote_question, "sv_password") != -1 ||
	containi(g_vote_question, "rcon_password") != -1 ||	containi(g_vote_question, "!g") != -1 || containi(g_vote_question, "!y") != -1 || containi(g_vote_question, "!t") != -1 || containi(g_vote_question, "^x04") != -1 || containi(g_vote_question, "^x01") != -1 || containi(g_vote_question, "^x03") != -1)
	{
		console_print(id, "%sLa pregunta de la votación tiene caracteres invalidos!", AMXX_CONSOLE_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	new iArgs;
	iArgs = read_argc();
	
	if(iArgs > 11)
	{
		console_print(id, "%sHay %d opciones especificadas y solo acepta hasta nueve", AMXX_CONSOLE_PREFIX, (iArgs-2));
		return PLUGIN_HANDLED;
	}
	
	new i;
	for(i = 0; i < (iArgs-2); ++i)
	{
		g_vote_options[i][0] = EOS;
		read_argv((i + 2), g_vote_options[i], 63);
		
		if(containi(g_vote_options[i], "%s") != -1 || containi(g_vote_options[i], "%d") != -1 || containi(g_vote_options[i], "%f") != -1 || containi(g_vote_options[i], "%i") != -1 || containi(g_vote_options[i], "%c") != -1 ||
		containi(g_vote_options[i], "!g") != -1 || containi(g_vote_options[i], "!y") != -1 || containi(g_vote_options[i], "!t") != -1 || containi(g_vote_options[i], "^x04") != -1 || containi(g_vote_options[i], "^x01") != -1 || containi(g_vote_options[i], "^x03") != -1)
		{
			console_print(id, "%sLa respuesta #%d tiene caracteres invalidos!", AMXX_CONSOLE_PREFIX, (i+1));
			return PLUGIN_HANDLED;
		}
	}
	
	for(i = 0; i < 10; ++i)
		g_vote_votes[i] = 0;
	
	static sMenu[500];
	static iLen;
	
	iLen = 0;
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yVotación: \r%s^n^n", g_vote_question);
	
	for(i = 0; i < (iArgs-2); ++i)
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d. \w%s^n", (i + 1), g_vote_options[i]);
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\r0. \wNo votar");
	
	show_menu(0, KEYS_MENU, sMenu, -1, "Vote Menu");
	
	g_vote_in_progress = 1;
	g_vote_options_max = (iArgs-2);
	
	set_task(15.0, "endVote");
	
	return PLUGIN_HANDLED;
}

public menuVote(const id, const key)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!g_vote_in_progress)
		return PLUGIN_HANDLED;
	
	if(key == 9)
	{
		++g_vote_votes[9];
		client_cmd(0, "echo [VOTACION] %s decidio no votar", g_player_name[id]);
		
		return PLUGIN_HANDLED;
	}
	
	if(key >= g_vote_options_max)
		return PLUGIN_HANDLED;
	
	++g_vote_votes[key];
	client_cmd(0, "echo [VOTACION] %s voto el mapa %s", g_player_name[id], g_vote_options[key]);
	
	return PLUGIN_HANDLED;
}

public endVote()
{
	g_vote_in_progress = 0;
	
	new i;
	new iWin;
	new iVotes = 0;
	new iMaxVotes;
	
	for(i = 0; i < 9; ++i)
	{
		if(!i)
		{
			iMaxVotes = g_vote_votes[0];
			iWin = i;
		}
		
		if(g_vote_votes[i] > iMaxVotes)
		{
			iMaxVotes = g_vote_votes[i];
			iWin = i;
		}
		
		iVotes += g_vote_votes[i];
		
		g_vote_votes[i] = 0;
	}
	
	iVotes += g_vote_votes[9];
	
	if(iMaxVotes < 1)
		colorChat(0, _, "!g[VOTACIÓN]!y No hay respuesta ganadora debido a que ningún jugador participó de la votación");
	else if(iMaxVotes != g_vote_votes[9])
		colorChat(0, _, "!g[VOTACIÓN]!y !t%s!y - !g%s!y con !g%d !y/!g %d voto%s!y", g_vote_question, g_vote_options[iWin], iMaxVotes, iVotes, (iMaxVotes == 1) ? "" : "s");
	
	for(i = 0; i < 10; ++i)
		g_vote_votes[i] = 0;
}


/// *************************************
/// 	PLUGIN - MAP CHOOSER
/// *************************************
public checkVoteMap() {
	new iTimeLimit = get_cvar_num("mp_timelimit");
	iTimeLimit -= 2;
	iTimeLimit *= 60;
	
	remove_task(TASK_TIME_LIMIT);
	set_task(float(iTimeLimit), "startVoteMap", TASK_TIME_LIMIT);
}

public startVoteMap()
{
	if(!g_Server[KZ] && !g_Server[SURF] && !g_Server[DR]) {
		new sMenu[512];
		new iRandom;
		new iKeys = (1 << g_SELECT_MAPS + 1);
		
		new iPosition = formatex(sMenu, 511, "\yElige el próximo mapa:^n^n");
		new iMax = (g_mapnums > g_SELECT_MAPS) ? g_SELECT_MAPS : g_mapnums;
		
		new Float:fTimeLimit = get_cvar_float("mp_timelimit");
		
		for(g_map_vote_num = 0; g_map_vote_num < iMax; ++g_map_vote_num)
		{
			iRandom = random_num(0, g_mapnums - 1);
			
			while(isInMenu(iRandom))
			{
				if(++iRandom >= g_mapnums)
					iRandom = 0;
			}
			
			g_nextmap_name[g_map_vote_num] = iRandom;
			
			iPosition += formatex(sMenu[iPosition], 511, "\r%d.\w %a^n", g_map_vote_num + 1, ArrayGetStringHandle(g_Array_mapname, iRandom));
			
			iKeys |= (1 << g_map_vote_num);
			
			g_votemap_count[g_map_vote_num] = 0;
		}
		
		sMenu[iPosition++] = '^n';
		g_votemap_count[g_SELECT_MAPS] = 0;
		g_votemap_count[g_SELECT_MAPS + 1] = 0;
		
		if(fTimeLimit < 90.0 && !g_Server[GG] && !g_Server[GGTP]) {
			iPosition += formatex(sMenu[iPosition], 511, "\r%d.\w Extender el mapa 15 minutos más^n", g_SELECT_MAPS + 1);
			iKeys |= (1 << g_SELECT_MAPS);
			
			remove_task(TASK_COUNTDOWN);
			set_task((float(get_timeleft()) - 10.0), "startCountDown__FIX", TASK_COUNTDOWN);
		}
		
		formatex(sMenu[iPosition], 511, "\r0.\w No Votar");
		
		show_menu(0, iKeys/*KEYS_MENU*/, sMenu, 15, "VoteMap Menu DEFAULT");
		
		set_task(15.1, "checkVotesVoteMap");
		
		colorChat(0, _, "%sEs momento de elegir el próximo mapa", AMXX_PREFIX);
		
		client_cmd(0, "spk gman/gman_choose1");
	} else {
		g_countdown_map = 5;
		startCountDown__PRE();
		
		set_task(5.0, "specialVoteMap__PRE");
	}
}

public specialVoteMap__PRE() {
	g_SVM_Init = 1;
	g_SVM_EndVote = 0;
	g_SVM_MaxVotes = 0;
	
	new i;
	for(i = 1; i <= g_maxplayers; ++i) {
		if(is_user_connected(i)) {
			g_SVM_Delay[i] = 16;
			specialVoteMap(i);
		}
	}
	
	set_task(15.1, "checkVotesVoteMap");
	
	colorChat(0, _, "%sEs momento de elegir el próximo mapa", AMXX_PREFIX);
	
	client_cmd(0, "spk gman/gman_choose1");
	
	remove_task(TASK_COUNTDOWN);
	set_task((float(get_timeleft()) - 10.0), "startCountDown__FIX", TASK_COUNTDOWN);
}

public specialVoteMap(const id) {
	if(!is_user_connected(id))
		return;
	
	new sItem[48];
	new sPercent[16];
	new sPosition[3];
	new iMenu;
	new iRandom;
	new i;
	new k;
	
	--g_SVM_Delay[id];
	
	formatex(sItem, 47, "Elige el próximo mapa^n\wResta%s \r%d segundo%s", (g_SVM_Delay[id] != 1) ? "n" : "", g_SVM_Delay[id], (g_SVM_Delay[id] != 1) ? "s" : "");
	iMenu = menu_create(sItem, "menu__SpecialVoteMap");
	
	for(i = 0; i < 8; ++i) {
		if(g_SVM_MapInMenu[i] == -1) {
			iRandom = random_num(0, g_mapnums - 1);
			
			for(k = 0; k < 9; ++k) {
				while(iRandom == g_SVM_MapInMenu[k]) {
					iRandom = random_num(0, g_mapnums - 1);
					k = 0;
					
					break;
				}
			}
			
			g_SVM_MapInMenu[i] = iRandom;
		}
		
		num_to_str((i + 1), sPosition, 2);
		
		formatex(sPercent, 15, "(%d%%)", g_SVM_MapPercent[i]);
		formatex(sItem, 47, "%a\d %s%s", ArrayGetStringHandle(g_Array_mapname, g_SVM_MapInMenu[i]), (!g_SVM_MapPercent[i]) ? "" : sPercent, (i != 7) ? "" : "^n");
		
		menu_additem(iMenu, sItem, sPosition);
	}
	
	if(!g_RTV_Init) {
		g_SVM_MapInMenu[8] = 8;
		
		formatex(sPercent, 15, "(%d%%)", g_SVM_MapPercent[8]);
		formatex(sItem, 47, "Extender el mapa 15m. más\d %s^n", (!g_SVM_MapPercent[8]) ? "" : sPercent);
		
		menu_additem(iMenu, sItem, "9", _, menu_makecallback("__checkAllowExtend"));
	} else {
		menu_addblank(iMenu);
	}
	
	menu_additem(iMenu, "No Votar", "0");
	
	menu_setprop(iMenu, MPROP_PERPAGE, 0);
	
	ShowLocalMenu(id, iMenu, 0);
	
	if(!g_Server[KZ]) {
		if(!g_SVM_Delay[id]) {
			// DestroyLocalMenu(id, iMenu);
			
			closeMenus(id);
			return;
		}
		
		set_task(1.0, "specialVoteMap", id);
	}
}

public __checkAllowExtend() {
	if(!g_Server[KZ] && g_SVM_AlreadyExtend == 2) {
		return ITEM_DISABLED;
	} else if(g_SVM_AlreadyExtend == 5) {
		return ITEM_DISABLED;
	}
	
	return ITEM_ENABLED;
}

public menu__SpecialVoteMap(const id, const menuId, const item) {
	if(!is_user_connected(id)) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	if(item < 0 || item > 9) {
		return PLUGIN_HANDLED;
	}
	
	if(g_SVM_EndVote) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	if(g_SVM_AlreadyVote[id]) {
		DestroyLocalMenu(id, menuId);
		
		colorChat(id, _, "%sYa has votado!", AMXX_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	g_SVM_AlreadyVote[id] = 1;
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[3];
	new iNothing;
	new iItem;
	
	menu_item_getinfo(menuId, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	iItem = str_to_num(sBuffer) - 1;
	
	if(iItem < 0 || iItem > 9) {
		return PLUGIN_HANDLED;
	}
	
	if(!g_Server[KZ]) {
		DestroyLocalMenu(id, menuId);
	}
	
	g_SVM_Vote[id] = iItem;
	
	++g_SVM_Votes[iItem];
	++g_SVM_MaxVotes;
	
	for(iItem = 0; iItem < 9; ++iItem) {
		g_SVM_MapPercent[iItem] = (g_SVM_Votes[iItem] * 100) / g_SVM_MaxVotes;
	}
	
	return PLUGIN_HANDLED;
}

public menu__SpecialVoteMap_Replay(const id, const menuId, const item) {
	if(!is_user_connected(id)) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	if(item < 0 || item > 9) {
		return PLUGIN_HANDLED;
	}
	
	if(g_SVM_EndVote) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	if(g_SVM_AlreadyVote[id]) {
		DestroyLocalMenu(id, menuId);
		
		colorChat(id, _, "%sYa has votado!", AMXX_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	g_SVM_AlreadyVote[id] = 1;
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[3];
	new iNothing;
	new iItem;
	
	menu_item_getinfo(menuId, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	iItem = str_to_num(sBuffer) - 1;
	
	if(iItem < 0 || iItem > 9) {
		return PLUGIN_HANDLED;
	}
	
	if(!g_Server[KZ]) {
		DestroyLocalMenu(id, menuId);
	}
	
	g_SVM_Vote[id] = iItem;
	
	++g_SVM_Votes[iItem];
	++g_SVM_MaxVotes;
	
	for(iItem = 0; iItem < 2; ++iItem) {
		g_SVM_MapPercent[iItem] = (g_SVM_Votes[iItem] * 100) / g_SVM_MaxVotes;
	}
	
	return PLUGIN_HANDLED;
}

public specialVoteMapReplay() {
	g_SVM_Votes[0] = 0;
	g_SVM_Votes[1] = 0;
	
	g_SVM_MaxVotes = 0;
	
	g_SVM_EndVote = 0;
	
	new i;
	for(i = 1; i <= g_maxplayers; ++i) {
		if(is_user_connected(i)) {
			g_SVM_Vote[i] = -1;
			g_SVM_AlreadyVote[i] = 0;
			g_SVM_Delay[i] = 16;
			
			specialVoteMapReplay__FIX(i);
		}
	}
	
	set_task(15.1, "checkVotesVoteMap__Replay");
	
	client_cmd(0, "spk gman/gman_choose1");
	
	remove_task(TASK_COUNTDOWN);
	set_task((float(get_timeleft()) - 10.0), "startCountDown__FIX", TASK_COUNTDOWN);
}

public specialVoteMapReplay__FIX(const id) {
	if(!is_user_connected(id))
		return;
	
	new sItem[48];
	new sPercent[16];
	new sPosition[3];
	new iMenu;
	new i;
	
	--g_SVM_Delay[id];
	
	formatex(sItem, 47, "Elige el próximo mapa^n\wResta%s \r%d segundo%s", (g_SVM_Delay[id] != 1) ? "n" : "", g_SVM_Delay[id], (g_SVM_Delay[id] != 1) ? "s" : "");
	iMenu = menu_create(sItem, "menu__SpecialVoteMap_Replay");
	
	for(i = 0; i < 2; ++i) {
		num_to_str((i + 1), sPosition, 2);
		
		formatex(sPercent, 15, "(%d%%)", g_SVM_MapPercent[i]);
		
		if(g_SVM_MapInMenu__FuckingFIX[i] == -1) {
			formatex(sItem, 47, "Extender el mapa 15m. más\d %s", (!g_SVM_MapPercent[i]) ? "" : sPercent);
			menu_additem(iMenu, sItem, sPosition);
			
			continue;
		}
		
		formatex(sItem, 47, "%a\d %s", ArrayGetStringHandle(g_Array_mapname, g_SVM_MapInMenu__FuckingFIX[i]), (!g_SVM_MapPercent[i]) ? "" : sPercent);
		
		menu_additem(iMenu, sItem, sPosition);
	}
	
	menu_setprop(iMenu, MPROP_EXITNAME, "No Votar");
	
	ShowLocalMenu(id, iMenu, 0);
	
	if(!g_Server[KZ]) {
		if(!g_SVM_Delay[id]) {
			// DestroyLocalMenu(id, iMenu);
			
			closeMenus(id);
			return;
		}
		
		set_task(1.0, "specialVoteMapReplay__FIX", id);
	}
}

public menuCountVote(id, key)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(key == 9)
		return PLUGIN_HANDLED;
	
	if(key == 7)
	{
		new Float:fTimeLimit = get_cvar_float("mp_timelimit");
		
		if(fTimeLimit < 90.0)
			++g_votemap_count[key];
		
		return PLUGIN_HANDLED;
	}
	
	++g_votemap_count[key];
	
	return PLUGIN_HANDLED;
}

public checkVotesVoteMap() {
	g_SVM_EndVote = 1;
	
	new i;
	
	if(!g_Server[KZ] && !g_Server[SURF] && !g_Server[DR]) {
		new j = 0;
		new iVotes;
		
		for(i = 0; i < g_map_vote_num; ++i)
		{
			if(g_votemap_count[j] < g_votemap_count[i])
				j = i;
		}
		
		for(i = 0; i <= g_SELECT_MAPS; ++i)
			iVotes += g_votemap_count[i];
		
		if(g_votemap_count[g_SELECT_MAPS] > g_votemap_count[j] && g_votemap_count[g_SELECT_MAPS] > g_votemap_count[g_SELECT_MAPS + 1])
		{
			set_cvar_float("mp_timelimit", get_cvar_float("mp_timelimit") + 15.0);
			colorChat(0, _, "%sEl mapa actual se extenderá !g15 minutos más!y con !g%d!y / !g%d!y voto%s", AMXX_PREFIX, g_votemap_count[g_SELECT_MAPS], iVotes, (g_votemap_count[g_SELECT_MAPS] != 1) ? "s" : "");
			
			remove_task(TASK_COUNTDOWN);
			remove_task(TASK_TIME_LIMIT);
			
			set_task(780.0, "startVoteMap", TASK_TIME_LIMIT);
			
			return;
		}
		
		new sMap[64];
		if(g_votemap_count[j] && g_votemap_count[g_SELECT_MAPS + 1] <= g_votemap_count[j])
		{
			ArrayGetString(g_Array_mapname, g_nextmap_name[j], sMap, charsmax(sMap));
			copy(g_nextmap_name_all, charsmax(g_nextmap_name_all), sMap);
			
			set_cvar_string("amx_gg_nextmap", sMap);
			
			if(!g_Server[GG] && !g_Server[GGTP]) {
				remove_task(TASK_TIME_LIMIT);
				set_task(float((get_timeleft() - 5)), "changeLevelMap", TASK_TIME_LIMIT);
			}
		}
		
		colorChat(0, _, "%sEl mapa ganador es !g%s!y con !g%d!y / !g%d!y voto%s", AMXX_PREFIX, sMap, g_votemap_count[j], iVotes, (g_votemap_count[j] != 1) ? "s" : "");
		
		if(!sMap[0])
		{
			if(iVotes != 0)
			{
				log_to_file("error_votemap.txt", "%sEl mapa ganador es !g%s!y con !g%d!y / !g%d!y voto%s", AMXX_PREFIX, sMap, g_votemap_count[j], iVotes, (g_votemap_count[j] != 1) ? "s" : "");
				log_to_file("error_votemap.txt", "j = %d^ng_votemap_count[j] = %d^ng_votemap_count[g_SELECT_MAPS + 1] = %d  <=  g_votemap_count[j] = %d^nsMap = %s", j, g_votemap_count[j], g_votemap_count[g_SELECT_MAPS + 1], g_votemap_count[j], sMap);
			}
			
			formatex(sMap, 63, "%a", ArrayGetStringHandle(g_Array_mapname, 1));
			
			copy(g_nextmap_name_all, charsmax(g_nextmap_name_all), sMap);
			
			set_cvar_string("amx_gg_nextmap", sMap);
			
			if(iVotes != 0)
				log_to_file("error_votemap.txt", "Cambiando a sMap = %s^n^n", sMap);
		}
	} else {		
		new iMaxVotes = 0;
		new iMaxVotesId = -1;
		new vecMaxVotesId[2];
		new iMenuVotesId[2];
		
		for(i = 0; i < 9; ++i) {
			if(g_SVM_Votes[i] > iMaxVotes) {
				iMaxVotes = g_SVM_Votes[i];
				iMaxVotesId = i;
				iMenuVotesId[0] = g_SVM_MapInMenu[i];
			}
		}
		
		if(iMaxVotesId == -1) {
			if(g_Server[KZ]) {
				copy(g_nextmap_name_all, charsmax(g_nextmap_name_all), "kz_longjumps2");
			} else if(g_Server[SURF]) {
				copy(g_nextmap_name_all, charsmax(g_nextmap_name_all), "surf_green");
			} else if(g_Server[DR]) {
				copy(g_nextmap_name_all, charsmax(g_nextmap_name_all), "deathrun_death");
			}
			
			remove_task(TASK_TIME_LIMIT);
			set_task(float((get_timeleft() - 5)), "changeLevelMap", TASK_TIME_LIMIT);
			
			return;
		} else if(iMaxVotesId == 8) {
			g_SVM_Init = 0;			
			++g_SVM_AlreadyExtend;
			
			set_cvar_float("mp_timelimit", get_cvar_float("mp_timelimit") + 15.0);
			colorChat(0, _, "%sEl mapa actual se extenderá !g15 minutos más!y con el !g%d%%!y de los votos!", AMXX_PREFIX, g_SVM_MapPercent[iMaxVotesId]);
			
			for(i = 0; i < 9; ++i) {
				g_SVM_MapPercent[i] = 0;
				g_SVM_MapInMenu[i] = -1;
				g_SVM_Votes[i] = 0;
			}
			
			for(i = 1; i <= g_maxplayers; ++i) {
				if(is_user_connected(i)) {
					g_SVM_AlreadyVote[i] = 0;
				}
			}
			
			remove_task(TASK_COUNTDOWN);
			remove_task(TASK_TIME_LIMIT);
			
			set_task(780.0, "startVoteMap", TASK_TIME_LIMIT);
			
			return;
		}
		
		if(g_SVM_MapPercent[iMaxVotesId] > 50) {
			new sMap[64];
			ArrayGetString(g_Array_mapname, g_SVM_MapInMenu[iMaxVotesId], sMap, charsmax(sMap));
			
			colorChat(0, _, "%sEl mapa ganador es !g%s!y con el !g%d%%!y de los votos!", AMXX_PREFIX, sMap, g_SVM_MapPercent[iMaxVotesId]);
			
			copy(g_nextmap_name_all, charsmax(g_nextmap_name_all), sMap);
			
			if(g_RTV_Init) {
				colorChat(0, CT, "%sSe cambiará el mapa en !tdos minutos!y!", AMXX_PREFIX);
				
				set_cvar_num("mp_timelimit", 0);
				set_task(120.0, "changeLevelMap", TASK_TIME_LIMIT);
			} else {
				set_task(float((get_timeleft() - 5)), "changeLevelMap", TASK_TIME_LIMIT);
			}
		} else {
			vecMaxVotesId[0] = iMaxVotesId;
			
			iMaxVotes = 0;
			iMaxVotesId = -1;
			
			for(i = 0; i < 9; ++i) {
				if(vecMaxVotesId[0] == i) {
					continue;
				}
				
				if(g_SVM_Votes[i] > iMaxVotes) {
					iMaxVotes = g_SVM_Votes[i];
					iMaxVotesId = i;
					iMenuVotesId[1] = g_SVM_MapInMenu[i];
				}
			}
			
			if(iMaxVotesId != -1) {
				vecMaxVotesId[1] = iMaxVotesId;
				
				if(vecMaxVotesId[1] == 8) {
					vecMaxVotesId[1] = -1;
				} else {
					vecMaxVotesId[1] = iMenuVotesId[1];
				}
			}
			
			if(vecMaxVotesId[0] == 8) {
				vecMaxVotesId[0] = -1;
			} else {
				vecMaxVotesId[0] = iMenuVotesId[0];
			}
			
			g_SVM_MapInMenu__FuckingFIX[0] = vecMaxVotesId[0];
			g_SVM_MapInMenu__FuckingFIX[1] = vecMaxVotesId[1];
			
			colorChat(0, _, "%sNingún mapa superó el !g50%% de los votos!y, siguiente votación en cinco segundos!", AMXX_PREFIX);
			
			for(i = 0; i < 9; ++i) {
				g_SVM_MapPercent[i] = 0;
				g_SVM_Votes[i] = 0;
			}
			
			for(i = 1; i <= g_maxplayers; ++i) {
				if(is_user_connected(i)) {
					g_SVM_AlreadyVote[i] = 0;
					g_SVM_Vote[i] = -1;
				}
			}
			
			g_countdown_map = 5;
			startCountDown__PRE();
			
			set_task(5.0, "specialVoteMapReplay");
		}
	}
}

public checkVotesVoteMap__Replay() {
	g_SVM_EndVote = 1;
	
	new i;
	new iMaxVotes = 0;
	new iMaxVotesId = -1;
	
	for(i = 0; i < 2; ++i) {
		if(g_SVM_Votes[i] > iMaxVotes) {
			iMaxVotes = g_SVM_Votes[i];
			iMaxVotesId = i;
		}
	}
	
	if(iMaxVotesId == -1) {
		if(g_Server[KZ]) {
			copy(g_nextmap_name_all, charsmax(g_nextmap_name_all), "kz_longjumps2");
		} else if(g_Server[SURF]) {
			copy(g_nextmap_name_all, charsmax(g_nextmap_name_all), "surf_green");
		} else if(g_Server[DR]) {
			copy(g_nextmap_name_all, charsmax(g_nextmap_name_all), "deathrun_death");
		}
		
		remove_task(TASK_TIME_LIMIT);
		set_task(float((get_timeleft() - 5)), "changeLevelMap", TASK_TIME_LIMIT);
		
		return;
	}
	
	if(g_SVM_MapPercent[iMaxVotesId] > 50) {
		if(g_SVM_MapInMenu__FuckingFIX[iMaxVotesId] == -1) {
			g_SVM_Init = 0;
			++g_SVM_AlreadyExtend;
			
			set_cvar_float("mp_timelimit", get_cvar_float("mp_timelimit") + 15.0);
			colorChat(0, _, "%sEl mapa actual se extenderá !g15 minutos más!y con el !g%d%%!y de los votos!", AMXX_PREFIX, g_SVM_MapPercent[iMaxVotesId]);
			
			for(i = 0; i < 9; ++i) {
				g_SVM_MapPercent[i] = 0;
				g_SVM_MapInMenu[i] = -1;
				g_SVM_Votes[i] = 0;
			}
			
			for(i = 1; i <= g_maxplayers; ++i) {
				if(is_user_connected(i)) {
					g_SVM_AlreadyVote[i] = 0;
				}
			}
			
			remove_task(TASK_COUNTDOWN);
			remove_task(TASK_TIME_LIMIT);
			
			set_task(780.0, "startVoteMap", TASK_TIME_LIMIT);
			
			return;
		}
		
		new sMap[64];
		ArrayGetString(g_Array_mapname, g_SVM_MapInMenu__FuckingFIX[iMaxVotesId], sMap, charsmax(sMap));
		
		colorChat(0, _, "%sEl mapa ganador es !g%s!y con el !g%d%%!y de los votos!", AMXX_PREFIX, sMap, g_SVM_MapPercent[iMaxVotesId]);
		
		copy(g_nextmap_name_all, charsmax(g_nextmap_name_all), sMap);
		
		if(g_RTV_Init) {
			colorChat(0, CT, "%sSe cambiará el mapa en !tdos minutos!y!", AMXX_PREFIX);
			
			set_cvar_num("mp_timelimit", 0);
			set_task(120.0, "changeLevelMap", TASK_TIME_LIMIT);
		} else {
			set_task(float((get_timeleft() - 5)), "changeLevelMap", TASK_TIME_LIMIT);
		}
	} else {
		new iRandom = random_num(0, 1);
		
		if(g_SVM_MapInMenu__FuckingFIX[iRandom] == -1) {
			++g_SVM_AlreadyExtend;
			
			set_cvar_float("mp_timelimit", get_cvar_float("mp_timelimit") + 15.0);
			
			colorChat(0, _, "%sNingún mapa superó el !g50%% de los votos!y por segunda vez, el mapa ganador al azar es: !gExtender el mapa 15m. más!y", AMXX_PREFIX);
			colorChat(0, _, "%sEl mapa actual se extenderá !g15 minutos más!y", AMXX_PREFIX);
			
			for(i = 0; i < 9; ++i) {
				g_SVM_MapPercent[i] = 0;
				g_SVM_MapInMenu[i] = -1;
				g_SVM_Votes[i] = 0;
			}
			
			for(i = 1; i <= g_maxplayers; ++i) {
				if(is_user_connected(i)) {
					g_SVM_AlreadyVote[i] = 0;
					g_SVM_Vote[i] = -1;
				}
			}
			
			remove_task(TASK_COUNTDOWN);
			remove_task(TASK_TIME_LIMIT);
			
			set_task(780.0, "startVoteMap", TASK_TIME_LIMIT);
			
			return;
		}
		
		new sMap[64];
		ArrayGetString(g_Array_mapname, g_SVM_MapInMenu__FuckingFIX[iRandom], sMap, charsmax(sMap));
		
		colorChat(0, _, "%sNingún mapa superó el !g50%% de los votos!y por segunda vez, el mapa ganador al azar es: !g%s!y", AMXX_PREFIX, sMap);
		
		copy(g_nextmap_name_all, charsmax(g_nextmap_name_all), sMap);
		
		remove_task(TASK_TIME_LIMIT);
		
		if(g_RTV_Init) {
			colorChat(0, CT, "%sSe cambiará el mapa en !tdos minutos!y!", AMXX_PREFIX);
			
			set_cvar_num("mp_timelimit", 0);
			set_task(120.0, "changeLevelMap", TASK_TIME_LIMIT);
		} else {
			set_task(float((get_timeleft() - 5)), "changeLevelMap", TASK_TIME_LIMIT);
		}
	}
}

loadLastMaps(file[])
{
	if(!file_exists(file))
		return;
	
	new iLine = -1;
	new sMap[2][128];
	new sBuffer[256];
	
	new iFile = fopen(file, "rt");
	
	while(!feof(iFile))
	{
		sBuffer[0] = EOS;
		fgets(iFile, sBuffer, charsmax(sBuffer));
		
		++iLine;
		
		if(iLine == 2)
			break;
		
		switch(iLine)
		{
			case 0:
			{
				formatex(sMap[0], 127, "%s", sBuffer[33]);
				formatex(sBuffer, 255, "L 00/00/0000 - 00:00:00: ULTIMO: %s", g_lastmap);
				
				write_file(file, "", 0);
				write_file(file, sBuffer, 0);
			}
			case 1:
			{
				formatex(sMap[1], 127, "%s", sBuffer[36]);
				formatex(g_last_last_lastmap, 63, "%s", sMap[1]);
				
				formatex(sBuffer, 255, "L 00/00/0000 - 00:00:00: PENULTIMO: %s", sMap[0]);
				
				write_file(file, "", 1);
				write_file(file, sBuffer, 1);
				
				formatex(g_last_lastmap, 63, "%s", sMap[0]);
			}
		}
	}
	
	fclose(iFile);
}

loadFile(file[]) {
	if(!file_exists(file))
		return 0;
	
	new sText[64];
	new sBuffer[256];
	
	new iFile = fopen(file, "r");
	
	while(!feof(iFile)) {
		sBuffer[0] = EOS;
		
		fgets(iFile, sBuffer, charsmax(sBuffer));
		
		parse(sBuffer, sText, charsmax(sText));
		
		if(validMap(sText)) {
			if(sText[0] != ';' && !equali(sText, g_lastmap) && !equali(sText, g_currentmap_name)) {
				ArrayPushString(g_Array_mapname, sText);
				
				++g_mapnums;
			}
		} else {
			log_to_file("mapas_invalidos.txt", "MAPA NO VALIDO : %s", sText);
		}
	}
	
	fclose(iFile);

	return g_mapnums;
}

stock validMap(mapname[]) {
	if(is_map_valid(mapname)) {
		return 1;
	}
	
	new iLen = strlen(mapname) - 4;
	
	if(iLen < 0) {
		return 0;
	}
	
	if(equali(mapname[iLen], ".bsp")) {
		mapname[iLen] = EOS;
		
		if(is_map_valid(mapname)) {
			return 1;
		}
	}
	
	return 0;
}

stock isInMenu(id)
{
	new i;
	for(i = 0; i < g_map_vote_num; ++i) {
		if(id == g_nextmap_name[i]) {
			return 1;
		}
	}
	
	return 0;
}

public event_TeamScore()
{
	new sTeam[2];
	read_data(1, sTeam, 1);
	
	g_team_score[(sTeam[0] == 'C') ? 0 : 1] = read_data(2);
}

public startCountDown__FIX()
{
	if(g_amx_status) {
		g_countdown_map = 10;
		startCountDown();
	}
}

public startCountDown() {
	if(!g_countdown_map)
		return;
	
	client_cmd(0, "spk ^"fvox/%s^"", COUNTDOWN_SOUNDS[g_countdown_map]);
	
	if((g_Server[ZP] || g_Server[JAILBREAK] || g_Server[DR]) && g_countdown_map == 10) {
		colorChat(0, _, "%sEl mapa cambiará cuando finalice la ronda!", AMXX_PREFIX);
		g_next_round_change_map = 1;
		
		remove_task(TASK_TIME_LIMIT);
		
		server_cmd("mp_timelimit 0");
		
		return;
	}
	
	--g_countdown_map;
	
	set_task(1.0, "startCountDown");
}

public startCountDown__PRE() {
	if(!g_countdown_map)
		return;
	
	client_cmd(0, "spk ^"fvox/%s^"", COUNTDOWN_SOUNDS[g_countdown_map]);
	client_print(0, print_center, "La votación comenzará en %d segundo%s", g_countdown_map, (g_countdown_map != 1) ? "s" : "");
	
	--g_countdown_map;
	
	set_task(1.0, "startCountDown__PRE");
}


/// *************************************
/// 	PLUGIN - NEXT MAP
/// *************************************
public event_HLTV() {
	if(g_next_round_change_map) {
		colorChat(0, _, "%sEl siguiente mapa será: !g%s!y", AMXX_PREFIX, g_nextmap_name_all);
		changeLevelMap();
	}
}

public clcmd_NextMap(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!g_nextmap_name_all[0])
		colorChat(id, _, "%sEl siguiente mapa todavía no se ha elegido", AMXX_PREFIX);
	else
		colorChat(id, _, "%sEl siguiente mapa será: !g%s!y", AMXX_PREFIX, g_nextmap_name_all);
	
	return PLUGIN_HANDLED;
}

public clcmd_LastMap(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!g_lastmap[0])
		colorChat(id, _, "%sNo se jugó ningún mapa anterior a este", AMXX_PREFIX);
	else
	{
		colorChat(id, _, "%sEl antepenúltimo mapa jugado fue: !g%s!y", AMXX_PREFIX, g_last_last_lastmap);
		colorChat(id, _, "%sEl ante último mapa jugado fue: !g%s!y", AMXX_PREFIX, g_last_lastmap);
		colorChat(id, _, "%sEl último mapa jugado fue: !g%s!y", AMXX_PREFIX, g_lastmap);
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_CurrentMap(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	colorChat(id, _, "%sEl mapa actual es: !g%s!y", AMXX_PREFIX, g_currentmap_name);
	
	return PLUGIN_HANDLED;
}

public clcmd_FFStatus(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	colorChat(id, _, "%sEl !gFuego Amigo!y está !g%s!y", AMXX_PREFIX, (get_cvar_num("mp_friendlyfire")) ? "ACTIVADO" : "DESACTIVADO");
	
	return PLUGIN_HANDLED;
}

public clcmd_ATStatus(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	colorChat(id, _, "%sEl !gAlltalk!y está !g%s!y", AMXX_PREFIX, (get_cvar_num("sv_alltalk")) ? "ACTIVADO" : "DESACTIVADO");
	
	return PLUGIN_HANDLED;
}


/// *************************************
/// 	PLUGIN - PAUSE CFG
/// *************************************
public concmd_PauseCFG(const id, const level, const cid)
{
	if(!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED;
	
	new sArgs[32];
	read_argv(1, sArgs, 31);
	
	if(equal(sArgs, "add"))
	{
		read_argv(2, sArgs, 31);
		if((g_system[g_system_num] = findPluginByTitle(sArgs)) != -1)
		{
			if(g_system_num < 32)
				++g_system_num;
		}
	}
	
	return PLUGIN_HANDLED;
}

public concmd_AmxON(const id, const level, const cid)
{
	if(cmd_access(id, level, cid, 1))
		amxON(id);
	
	return PLUGIN_HANDLED;
}

public concmd_AmxOFF(const id, const level, const cid)
{
	if(cmd_access(id, level, cid, 1))
		amxOFF(id);
	
	return PLUGIN_HANDLED;
}

amxON(id)
{
	new sFileName[32];
	new sTittle[32];
	new sStatus[2];
	new iCount = 0;
	new iMax = get_pluginsnum();
	new i;
	
	for(i = 0; i < iMax; ++i)
	{
		get_plugin(i, sFileName, 31, sTittle, 31, sStatus, 0, sStatus, 0, sStatus, 1);
		
		if(!isSystem(i) && sStatus[0] == 'p' && unpause("ac", sFileName))
			++iCount;
	}
	
	g_amx_status = 1;
	
	if(!g_Server[AUTOMIX] && !g_Server[AUTOMIX2] && !g_Server[CTF] && !g_Server[SJ] && !g_Server[MIX1] && !g_Server[MIX2] && !g_Server[TD]) {
		new iTimeLimit = get_cvar_num("mp_timelimit");
		iTimeLimit -= 2;
		iTimeLimit *= 60;
		
		if((iTimeLimit - get_timeleft()) <= 0)
			iTimeLimit = 5;
		
		remove_task(TASK_TIME_LIMIT);
		set_task(float(iTimeLimit), "startVoteMap", TASK_TIME_LIMIT);
	}
	
	console_print(id, "%sSe han despausado %d plugin%s", AMXX_CONSOLE_PREFIX, iCount + 1, (iCount != 1) ? "s" : "");
}

amxOFF(id)
{
	new sFileName[32];
	new sTittle[32];
	new sStatus[2];
	new iCount = 0;
	new iMax = get_pluginsnum();
	new i;
	
	for(i = 0; i < iMax; ++i)
	{
		get_plugin(i, sFileName, 31, sTittle, 31, sStatus, 0, sStatus, 0, sStatus, 1);
		
		if(!isSystem(i) && sStatus[0] == 'r' && pause("ac", sFileName))
			++iCount;
	}
	
	g_amx_status = 0;
	
	remove_task(TASK_TIME_LIMIT);
	
	console_print(id, "%sSe han pausado %d plugin%s", AMXX_CONSOLE_PREFIX, iCount, (iCount != 1) ? "s" : "");
}

isSystem(id)
{
	new i;
	for(i = 0; i < g_system_num; ++i)
	{
		if(g_system[i] == id)
			return 1;
	}
	
	return 0;
}

findPluginByTitle(name[])
{
	new sFileName[32];
	new sTittle[32];
	new sStatus[2];
	new iNum = get_pluginsnum();
	new i;
	
	for(i = 0; i < iNum; ++i)
	{
		get_plugin(i, sFileName, 31, sTittle, 31, sStatus, 1, sStatus, 1, sStatus, 1);
		
		if(equali(sTittle, name))
			return i;
	}
	
	return -1;
}

/// *************************************
/// 	PLUGIN - STATS
/// *************************************
public clcmd_Stats(const id)
{
	colorChat(id, _, "%sIngrese en !ghttp://www.gaminga.com/estadisticas/!y", AMXX_PREFIX);
	return PLUGIN_HANDLED;
}


/// *************************************
/// 	PLUGIN - TIMELEFT
/// *************************************
public clcmd_Timeleft(const id) {
	if(get_cvar_float("mp_timelimit")) {
		new iTimeleft = get_timeleft();
		colorChat(id, _, "%sTiempo restante: !g%d:%02d!y", AMXX_PREFIX, (iTimeleft / 60),  (iTimeleft % 60));
	}
	else {
		colorChat(id, _, "%sTiempo restante: !gInfinito!y", AMXX_PREFIX);
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_Thetime(const id) {
	new sTime[35];
	get_time("!g%d/%m/%Y!y - !g%H:%M:%S!y", sTime, 34);
	
	colorChat(id, _, "%sFecha y hora: %s", AMXX_PREFIX, sTime);
	
	return PLUGIN_HANDLED;
}

/// *************************************
/// 	PLUGIN - SPECIAL VOTE MAP
/// *************************************
public clcmd_RockTheVote(const id) {
	if(!is_user_connected(id)) {
		return PLUGIN_HANDLED;
	}
	
	if(g_RTV_Already[id]) {
		colorChat(id, _, "%sYa has pedido el RTV.", AMXX_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	if(!g_RTV_Allowed) {
		if(g_RTV_SysTime >= get_gametime()) {
			colorChat(id, _, "%sEs demasiado pronto para pedir RTV, debes esperar!", AMXX_PREFIX);
			return PLUGIN_HANDLED;
		} else {
			g_RTV_Allowed = 1;
		}
	}
	
	if(g_SVM_Init || g_RTV_Init) {
		return PLUGIN_HANDLED;
	}
	
	new iVotesNeeded;
	new iDiff;
	new iPlaying = getPlaying();
	
	g_RTV_Already[id] = 1;
	++g_RTV_Votes;
	
	if(iPlaying <= 2) {
		iVotesNeeded = 2;
	} else {
		iVotesNeeded = ((getPlaying() * 70) / 100);
	}
	
	iDiff = iVotesNeeded - g_RTV_Votes;
	
	if(iDiff > 0) {
		colorChat(0, CT, "%sEl usuario %s pidió RTV, falta%s !t%d voto%s!y para comenzar la votación!", AMXX_PREFIX, g_player_name[id], (iDiff != 1) ? "n" : "", iDiff, (iDiff != 1) ? "s" : "");
	} else {
		g_SVM_Init = 1;
		g_RTV_Init = 1;
		
		colorChat(0, CT, "%sDemasiados usuarios han pedido RTV, la votación comenzará en !t5 segundos!y!", AMXX_PREFIX);
		
		g_countdown_map = 5;
		startCountDown();
		
		remove_task(TASK_TIME_LIMIT);
		set_task(5.0, "startVoteMap", TASK_TIME_LIMIT);
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_SaySVM(const id) {
	/// PLUGIN - ANTI FLOOD
	new Float:fMaxChat = 0.75;
	new Float:fNextTime = get_gametime();
	
	if(g_flooding[id] > fNextTime) {
		if(g_flood[id] >= 3) {
			g_flooding[id] = fNextTime + fMaxChat + 3.0;
			return PLUGIN_HANDLED;
		}
		
		++g_flood[id];
	}
	else if(g_flood[id])
		--g_flood[id];
	
	g_flooding[id] = fNextTime + fMaxChat;
	
	
	/// PLUGIN - SPECIAL VOTE MAP
	new sMessage[191];
	
	read_args(sMessage, 190);
	remove_quotes(sMessage);
	
	replace_all(sMessage, 190, "%", "");
	
	if(!g_SVM_Init) {
		new sCommand1[32];
		new sCommand2[32];
		
		parse(sMessage, sCommand1, 31, sCommand2, 31);
		
		if(sCommand1[0] == 'n' && sCommand1[1] == 'o' && sCommand1[2] == 'm') {
			if(sCommand1[3] == 's' || (sCommand1[3] == 'i' && sCommand1[4] == 'n' && sCommand1[5] == 'a' && sCommand1[6] == 't' && sCommand1[7] == 'i' && sCommand1[8] == 'o' && sCommand1[9] == 'n' && sCommand1[10] == 's')) {
				viewNominations(id);
				return PLUGIN_HANDLED;
			}
		}
		
		if(!g_RTV_Init) {
			if(sCommand1[0] == 'c' && sCommand1[1] == 'a' && sCommand1[2] == 'n' && sCommand1[3] == 'c' && sCommand1[4] == 'e' && sCommand1[5] == 'l') {
				if(g_SVM_Nominate[id]) {
					replace_all(sCommand2, 31, "%", "");
					strtolower(sCommand2);
					
					new i;
					new sText[32];
					
					for(i = 0; i < 9; ++i) {
						if(g_SVM_MapInMenu[i] == -1) {
							continue;
						}
						
						if(g_SVM_MyNominate[id] != g_SVM_MapInMenu[i]) {
							continue;
						}
						
						formatex(sText, 31, "%a", ArrayGetStringHandle(g_Array_mapname, g_SVM_MapInMenu[i]));
						strtolower(sText);
						
						if(equal(sCommand2, sText)) {
							--g_SVM_Nominate[id];
							
							g_SVM_MapInMenu[i] = -1;
							g_SVM_MapName[i][0] = EOS;
							
							--g_SVM_Nominations;
							
							colorChat(id, _, "%sHas eliminado de las nominaciones el mapa %s", AMXX_PREFIX, sCommand2);
							
							break;
						}
					}
				}
				
				return PLUGIN_HANDLED;
			}
			
			if(g_SVM_Nominations < 9 && g_SVM_Nominate[id] < 2) {
				if(!sCommand2[0]) {
					replace_all(sCommand1, 31, "%", "");
					strtolower(sCommand1);
					
					new i;
					if(is_map_valid(sCommand1)) {
						new j;
						new sText[32];
						
						for(j = 0; j < 9; ++j) {
							if(equal(sCommand1, g_SVM_MapName[j])) {
								colorChat(id, CT, "%sEl mapa indicado ya fue nominado, escribe !tnoms!y para ver los mapas nominados!", AMXX_PREFIX);
								return PLUGIN_HANDLED;
							}
						}
						
						j = 0;
						while(j < 9) {
							if(g_SVM_MapInMenu[j] == -1) {
								for(i = 0; i < g_mapnums; ++i) {
									formatex(sText, 31, "%a", ArrayGetStringHandle(g_Array_mapname, i));
									strtolower(sText);
									
									if(equal(sCommand1, sText)) {
										++g_SVM_Nominate[id];
										
										g_SVM_MapInMenu[j] = i;
										g_SVM_MyNominate[id] = i;
										
										formatex(g_SVM_MapName[j], 31, sCommand1);
										
										++g_SVM_Nominations;
										
										colorChat(0, _, "%sEl usuario %s ha nominado el mapa %s", AMXX_PREFIX, g_player_name[id], sCommand1);
										
										return PLUGIN_HANDLED;
									}
								}
								
								break;
							}
							
							++j;
						}
					}
				}
				
				if(sCommand1[0] == 'n' && sCommand1[1] == 'o' && sCommand1[2] == 'm') {
					replace_all(sCommand2, 31, "%", "");
					strtolower(sCommand2);
					
					new i;
					if(is_map_valid(sCommand2)) {
						new j;
						new sText[32];
						
						for(j = 0; j < 9; ++j) {
							if(equal(sCommand2, g_SVM_MapName[j])) {
								colorChat(id, CT, "%sEl mapa indicado ya fue nominado, escribe !tnoms!y para ver los mapas nominados!", AMXX_PREFIX);
								return PLUGIN_HANDLED;
							}
						}
						
						j = 0;
						while(j < 9) {
							if(g_SVM_MapInMenu[j] == -1) {
								for(i = 0; i < g_mapnums; ++i) {
									formatex(sText, 31, "%a", ArrayGetStringHandle(g_Array_mapname, i));
									strtolower(sText);
									
									if(equal(sCommand2, sText)) {
										++g_SVM_Nominate[id];
										
										g_SVM_MapInMenu[j] = i;
										g_SVM_MyNominate[id] = i;
										
										formatex(g_SVM_MapName[j], 31, sCommand2);
										
										++g_SVM_Nominations;
										
										colorChat(0, _, "%sEl usuario %s ha nominado el mapa %s", AMXX_PREFIX, g_player_name[id], sCommand2);
										
										return PLUGIN_HANDLED;
									}
								}
								
								break;
							}
							
							++j;
						}
					}
					
					SVM_FoundMatch(id, sCommand2);
					
					return PLUGIN_HANDLED;
				}
				
				// new i;
				// if(is_map_valid(sMessage)) {
					// new sText[32];
					// for(i = 0; i < g_mapnums; ++i) {
						// formatex(sText, 31, "%a", ArrayGetStringHandle(g_Array_mapname, i));
						// strtolower(sText);
						
						// if(equal(sMessage, sText)) {
							// ++g_SVM_Nominate[id];
							
							// g_SVM_MapInMenu[g_SVM_Nominations] = i;
							// g_SVM_MyNominate[id] = i;
							
							// ++g_SVM_Nominations;
							
							// colorChat(0, _, "%sEl usuario %s ha nominado el mapa %s", AMXX_PREFIX, g_player_name[id], sMessage);
							
							// break;
						// }
					// }
				// } else {
					// SVM_FoundMatch(id, sMessage);
				// }
			}
		}
	}
	
	/// PLUGIN - ADMIN CHAT
	if(!access(id, ADMIN_CHAT))
		return PLUGIN_CONTINUE;
	
	if(!g_amx_status)
		return PLUGIN_CONTINUE;
	
	new sSaid[2];
	read_argv(1, sSaid, 1);
	
	if(sSaid[0] != '@')
		return PLUGIN_CONTINUE;
	
	if(g_hud_next == 4)
	{
		g_hud_next = 3;
		
		g_msg_hud[0][0] = EOS;
		
		copy(g_msg_hud[0], 225, g_msg_hud[1]);
		copy(g_msg_hud[1], 225, g_msg_hud[2]);
		copy(g_msg_hud[2], 225, g_msg_hud[3]);
	}
	
	set_hudmessage(255, 255, 255, 0.05, 0.5, 0, 6.0, 6.0, 0.45, 0.15, -1);
	
	formatex(g_msg_hud[g_hud_next], 225, "%s : %s^n^n", g_player_name[id], sMessage[1]);
	formatex(g_msg_hud_total, 904, "%s%s%s%s", g_msg_hud[0], g_msg_hud[1], g_msg_hud[2], g_msg_hud[3]);
	
	++g_hud_next;
	
	ShowSyncHudMsg(0, g_hud_00, "%s", g_msg_hud_total);
	client_print(0, print_console, "%s : %s", g_player_name[id], sMessage[1]);
	
	remove_task(TASK_CHAT);
	set_task(7.0, "finalChatAdmin", TASK_CHAT);

	return PLUGIN_HANDLED;
}

public SVM_FoundMatch(const id, const sMap[]) {
	if(!is_user_connected(id)) {
		return PLUGIN_HANDLED;
	}
	
	new i;
	new sText[60];
	new sTextTemp[60];
	new iMenu;
	new sPosition[6];
	new j = 0;
	
	formatex(sText, 59, "Mapas que coinciden con \r%s\y\R", sMap);
	iMenu = menu_create(sText, "menu__SVM_Nominations");
	
	for(i = 0; i < g_mapnums; ++i) {
		formatex(sText, 59, "%a", ArrayGetStringHandle(g_Array_mapname, i));
		strtolower(sText);
		
		if(contain(sText, sMap) != -1) {
			++j;
			
			copy(sTextTemp, 59, sText);
			
			num_to_str(j, sPosition, 5);
			menu_additem(iMenu, sText, sPosition);
		}
	}
	
	if(j == 1) {
		client_cmd(id, "say nom %s", sTextTemp);
		
		DestroyLocalMenu(id, iMenu);
		return PLUGIN_HANDLED;
	}
	
	if(menu_items(iMenu) <= 0) {
		colorChat(id, _, "%sNo hay ningún mapa que coincida con lo ingresado (%s)", AMXX_PREFIX, sMap);
		
		DestroyLocalMenu(id, iMenu);
		return PLUGIN_HANDLED;
	}
	
	menu_setprop(iMenu, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(iMenu, MPROP_BACKNAME, "Atrás");
	menu_setprop(iMenu, MPROP_EXITNAME, "Salir");
	
	ShowLocalMenu(id, iMenu, 0);
	
	return PLUGIN_HANDLED;
}

public menu__SVM_Nominations(const id, const menuId, const item) {
	if(!is_user_connected(id)) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	new sMapName[32];
	new sBuffer[6];
	new iNothing;
	
	menu_item_getinfo(menuId, item, iNothing, sBuffer, charsmax(sBuffer), sMapName, charsmax(sMapName), iNothing);
	
	DestroyLocalMenu(id, menuId);
	
	client_cmd(id, "say nom %s", sMapName);
	
	return PLUGIN_HANDLED;
}

public viewNominations(const id) {
	if(!is_user_connected(id)) {
		return PLUGIN_HANDLED;
	}
	
	if(g_SVM_Init || g_RTV_Init) {
		return PLUGIN_HANDLED;
	}
	
	new i;
	new iMenu;
	new sPosition[3];
	new j = 0;
	
	iMenu = menu_create("NOMINACIONES", "menu__SVM_ViewNominations");
	
	for(i = 0; i < 9; ++i) {
		if(g_SVM_MapName[i][0]) {
			++j;
			
			num_to_str(j, sPosition, 2);
			menu_additem(iMenu, g_SVM_MapName[i], sPosition);
		}
	}
	
	if(menu_items(iMenu) <= 0) {
		colorChat(id, _, "%sNo hay mapas nominados!", AMXX_PREFIX);
		
		DestroyLocalMenu(id, iMenu);
		return PLUGIN_HANDLED;
	}
	
	menu_setprop(iMenu, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(iMenu, MPROP_BACKNAME, "Atrás");
	menu_setprop(iMenu, MPROP_EXITNAME, "Salir");
	
	ShowLocalMenu(id, iMenu, 0);
	return PLUGIN_HANDLED;
}

public menu__SVM_ViewNominations(const id, const menuId, const item) {
	if(!is_user_connected(id)) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	DestroyLocalMenu(id, menuId);
	
	viewNominations(id);
	
	return PLUGIN_HANDLED;
}

/// *************************************
/// 	PLUGIN - ADMIN VOTE MAP MENU
/// *************************************
public concmd_VotemapMenu(const id, const level, const cid) {
	if(!cmd_access(id, level, cid, 1)) {
		return PLUGIN_HANDLED;
	}
	
	showMenu__VotemapMenu(id);
	
	return PLUGIN_HANDLED;
}

public showMenu__VotemapMenu(const id) {
	if(!g_amx_status) {
		return PLUGIN_HANDLED;
	}
	
	new iMenu;
	iMenu = menu_create("VOTEMAP MENU", "menu__VotemapMenu");
	
	menu_additem(iMenu, "Elegir mapas", "1");
	menu_additem(iMenu, "Ver mapas elegidos^n", "2");
	
	menu_additem(iMenu, "Comenzar la votación", "3");
	
	menu_setprop(iMenu, MPROP_EXITNAME, "Salir");
	
	ShowLocalMenu(id, iMenu, 0);
	return PLUGIN_HANDLED;
}

public menu__VotemapMenu(const id, const menuId, const item) {
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
	
	switch(iItem) {
		case 1: showMenu__ChooseMaps(id);
		case 2: showMenu__ViewMaps(id);
		case 3: {
			if(!g_amx_status) {
				return PLUGIN_HANDLED;
			}
			
			if(g_vote_votemap_end_round) {
				colorChat(id, _, "%sNo podes iniciar una votación porque el mapa esta a punto de cambiar", AMXX_PREFIX);
				
				showMenu__VotemapMenu(id);
				return PLUGIN_HANDLED;
			}
			
			if(g_vote_in_progress) {
				colorChat(id, _, "%sNo podes iniciar una votación cuando ya hay una en curso", AMXX_PREFIX);
				
				showMenu__VotemapMenu(id);
				return PLUGIN_HANDLED;
			}
			
			new sCommand[350];
			new iLenght = 0;
			new i;
			new j;
			
			iLenght += formatex(sCommand[iLenght], charsmax(sCommand) - iLenght, "amx_votemap ");
			
			for(i = 0; i < 9; ++i) {
				if(g_MenuChooseMaps_MapsId[id][i] >= 0) {
					iLenght += formatex(sCommand[iLenght], charsmax(sCommand) - iLenght, "^"%a^" ", ArrayGetStringHandle(g_Array_mapname, g_MenuChooseMaps_MapsId[id][i]));
					++j;
				}
			}
			
			if(j < 2) {
				colorChat(id, _, "%sTiene que haber dos o más mapas para comenzar la votación!", AMXX_PREFIX);
				
				showMenu__VotemapMenu(id);
				return PLUGIN_HANDLED;
			}
			
			client_cmd(id, sCommand);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__ChooseMaps(const id) {
	if(!g_amx_status) {
		return PLUGIN_HANDLED;
	}
	
	new i;
	new sText[60];
	new iMenu;
	new sPosition[6];
	
	iMenu = menu_create("MAPAS DEL SERVIDOR\R", "menu__ChooseMaps");
	
	for(i = 0; i < g_mapnums; ++i) {
		formatex(sText, 59, "%a", ArrayGetStringHandle(g_Array_mapname, i));
		strtolower(sText);
		
		num_to_str((i + 1), sPosition, 5);
		menu_additem(iMenu, sText, sPosition);
	}
	
	menu_setprop(iMenu, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(iMenu, MPROP_BACKNAME, "Atrás");
	menu_setprop(iMenu, MPROP_EXITNAME, "Salir");
	
	g_MenuChooseMaps_Page[id] = min(g_MenuChooseMaps_Page[id], menu_pages(iMenu) - 1);
	
	ShowLocalMenu(id, iMenu, g_MenuChooseMaps_Page[id]);
	return PLUGIN_HANDLED;
}

public menu__ChooseMaps(const id, const menuId, const item) {
	if(!is_user_connected(id)) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	new iNothing;
	player_menu_info(id, iNothing, iNothing, g_MenuChooseMaps_Page[id]);
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		
		showMenu__VotemapMenu(id);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[6];
	new iMap;
	new i;
	
	menu_item_getinfo(menuId, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	iMap = str_to_num(sBuffer) - 1;
	
	DestroyLocalMenu(id, menuId);
	
	for(i = 0; i < 9; ++i) {
		if(g_MenuChooseMaps_MapsId[id][i] >= 0) {
			if(i == 8) {
				colorChat(id, _, "%sTu lista de mapas está completa!", AMXX_PREFIX);
				break;
			}
			
			if(g_MenuChooseMaps_MapsId[id][i] == iMap) {
				colorChat(id, _, "%sEl mapa seleccionado ya está en tu lista!", AMXX_PREFIX);
				break;
			}
			
			continue;
		}
		
		g_MenuChooseMaps_MapsId[id][i] = iMap;
		colorChat(id, _, "%sSe agregó el mapa !g%a!y a tu lista!", AMXX_PREFIX, ArrayGetStringHandle(g_Array_mapname, iMap));
		
		break;
	}
	
	showMenu__ChooseMaps(id);
	return PLUGIN_HANDLED;
}

public showMenu__ViewMaps(const id) {
	if(!g_amx_status) {
		return PLUGIN_HANDLED;
	}
	
	new i;
	new sText[60];
	new iMenu;
	new sPosition[3];
	
	iMenu = menu_create("TU LISTA DE MAPAS^n\r* \wSelecciona un mapa para borrarlo de la lista.\R", "menu__ViewMaps");
	
	for(i = 0; i < 9; ++i) {
		if(g_MenuChooseMaps_MapsId[id][i] >= 0) {
			formatex(sText, 59, "%a", ArrayGetStringHandle(g_Array_mapname, g_MenuChooseMaps_MapsId[id][i]));
			strtolower(sText);
			
			num_to_str((i + 1), sPosition, 2);
			menu_additem(iMenu, sText, sPosition);
		}
	}
	
	if(menu_items(iMenu) < 1) {
		DestroyLocalMenu(id, iMenu);
		colorChat(id, _, "%sNo hay mapas en tu lista para ver.", AMXX_PREFIX);
		
		showMenu__VotemapMenu(id);
		return PLUGIN_HANDLED;
	}
	
	menu_setprop(iMenu, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(iMenu, MPROP_BACKNAME, "Atrás");
	menu_setprop(iMenu, MPROP_EXITNAME, "Salir");
	
	ShowLocalMenu(id, iMenu, 0);
	return PLUGIN_HANDLED;
}

public menu__ViewMaps(const id, const menuId, const item) {
	if(!is_user_connected(id)) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		
		showMenu__VotemapMenu(id);
		return PLUGIN_HANDLED;
	}
	
	new sBuffer[6];
	new iNothing;
	new sMapName[32];
	new sText[32];
	new iMap;
	new i;
	
	menu_item_getinfo(menuId, item, iNothing, sBuffer, charsmax(sBuffer), sMapName, charsmax(sMapName), iNothing);
	iMap = str_to_num(sBuffer) - 1;
	
	DestroyLocalMenu(id, menuId);
	
	for(i = 0; i < g_mapnums; ++i) {
		formatex(sText, 31, "%a", ArrayGetStringHandle(g_Array_mapname, i));
		strtolower(sText);
		
		if(equal(sMapName, sText)) {
			iMap = i;
			break;
		}
	}
	
	for(i = 0; i < 9; ++i) {
		if(g_MenuChooseMaps_MapsId[id][i] == iMap) {
			colorChat(id, _, "%sSe removió el mapa !g%a!y de tu lista!", AMXX_PREFIX, ArrayGetStringHandle(g_Array_mapname, g_MenuChooseMaps_MapsId[id][i]));
			
			g_MenuChooseMaps_MapsId[id][i] = -1;
			
			break;
		}
	}
	
	showMenu__ViewMaps(id);
	return PLUGIN_HANDLED;
}

/// *************************************
/// 	GLOBALES
/// *************************************
isKiske(const id) {
	if(!g_kiske[id]) {
		return 0;
	}
	
	return 1;
}

public fw_ClientUserInfoChanged(const id, const buffer) {
	if(!is_user_connected(id))
		return FMRES_IGNORED;
	
	new sNewName[32];
	new sOldName[32];
	
	entity_get_string(id, EV_SZ_netname, sOldName, 31);
	engfunc(EngFunc_InfoKeyValue, buffer, "name", sNewName, 31);
	
	if(containi(sNewName, "..") != -1) {
		engfunc(EngFunc_SetClientKeyValue, id, buffer, "name", "unnamed");
		client_cmd(id, "name unnamed; setinfo name unnamed");
		
		server_cmd("kick #%d ^"No podes usar ese nombre^"", get_user_userid(id));
		
		return FMRES_SUPERCEDE;
	}
	
	if(containi(sNewName, "%") != -1) {
		engfunc(EngFunc_SetClientKeyValue, id, buffer, "name", "unnamed");
		client_cmd(id, "name unnamed; setinfo name unnamed");
		
		console_print(id, "%sTu nombre no puede contener el simbolo porcentaje", AMXX_CONSOLE_PREFIX);
		
		// server_cmd("kick #%d ^"No podes usar ese nombre^"", get_user_userid(id));
		
		return FMRES_SUPERCEDE;
	}
	
	if(equal(sNewName, sOldName)) {
		return FMRES_IGNORED;
	}
	
	new sCheckName[32];
	get_user_name(id, sCheckName, 31);
	
	if(containi(sCheckName, "..") != -1 || containi(sCheckName, "%") != -1) {
		engfunc(EngFunc_SetClientKeyValue, id, buffer, "name", "unnamed");
		client_cmd(id, "name unnamed; setinfo name unnamed");
		
		server_cmd("kick #%d ^"No podes usar ese nombre^"", get_user_userid(id));
		
		return FMRES_SUPERCEDE;
	} else if(containi(sNewName, "!y") != -1 || containi(sNewName, "!g") != -1 || containi(sNewName, "!t") != -1 || containi(sNewName, "_label") != -1) {
		engfunc(EngFunc_SetClientKeyValue, id, buffer, "name", g_player_name[id]);
		client_cmd(id, "name ^"%s^"; setinfo name ^"%s^"", g_player_name[id], g_player_name[id]);
		
		console_print(id, "%sTu nombre no puede contener los siguiente conjuntos de caracteres: !y , !g, !t y/o _label", AMXX_CONSOLE_PREFIX);
		
		return FMRES_SUPERCEDE;
	} else if(!g_Server[MIX1] && !g_Server[MIX2] && !g_Server[TEST]) {
		strtolower(sCheckName);
		
		if(sCheckName[0] == '[' && sCheckName[1] == 'g' && sCheckName[2] == 'a' && sCheckName[3] == 'm' && sCheckName[4] == '!' && sCheckName[5] == 'n' && sCheckName[6] == 'g' && sCheckName[7] == 'a' && sCheckName[8] == ']') {
			engfunc(EngFunc_SetClientKeyValue, id, buffer, "name", g_player_name[id]);
			client_cmd(id, "name ^"%s^"; setinfo name ^"%s^"", g_player_name[id], g_player_name[id]);
			
			console_print(id, "%sSi querés logearte como administrador, debes desconectarte.", AMXX_CONSOLE_PREFIX);
			
			return FMRES_SUPERCEDE;
		} else if(g_level_user[id][ADMIN]) {
			engfunc(EngFunc_SetClientKeyValue, id, buffer, "name", g_player_name[id]);
			client_cmd(id, "name ^"%s^"; setinfo name ^"%s^"", g_player_name[id], g_player_name[id]);
			
			console_print(id, "%sSi querés cambiarte el nombre, debes desconectarte.", AMXX_CONSOLE_PREFIX);
			
			return FMRES_SUPERCEDE;
		}
	}
	
	// ZP, JB, AMIX1, AMIX2, TD ?
	if(g_Server[ZP] || g_Server[JAILBREAK] || g_Server[AUTOMIX] || g_Server[AUTOMIX2] || g_Server[TD]) {
		return FMRES_IGNORED;
	}
	
	if(g_Server[TEST]) {
		if(!zpAllowChangeName(id)) {
			return FMRES_IGNORED;
		}
	}
	
	/// PLUGIN - ADMIN
	if(g_case_sens_name[id]) {
		if(!equal(sNewName, sOldName))
			accessUser(id, sNewName);
	} else {
		if(!equali(sNewName, sOldName))
			accessUser(id, sNewName);
	}
	
	/// GLOBALES
	g_player_name[id][0] = EOS;
	copy(g_player_name[id], 31, sNewName);
	
	return FMRES_IGNORED;
}

public logeventRoundEnd()
{
	static Float:fLastEndTime;
	static Float:fCurrentTime;
	
	fCurrentTime = get_gametime();
	
	if (fCurrentTime - fLastEndTime < 0.5)
		return;
	
	fLastEndTime = get_gametime();
	
	if(g_vote_votemap_end_round)
	{
		g_vote_votemap_end_round = 0;
		
		message_begin(MSG_ALL, SVC_INTERMISSION);
		message_end();
		
		set_task(3.0, "changeMap", 0, g_vote_options[g_vote_votemap_win], 64);
	}
}

stock getUserTeam(const id)
{
	if(pev_valid(id) != 2)
		return 0;
	
	return get_pdata_int(id, 114, 5);
}

stock setUserTeam(const id, const team)
{
	if(pev_valid(id) != 2)
		return;
	
	set_pdata_int(id, 114, team, 5);
}

public loadMaps__WithAnnouncements(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(g_CheckMaps_UniqueTime)
		return PLUGIN_HANDLED;
	
	if(!(get_user_flags(id) & ADMIN_PASSWORD))
		return PLUGIN_HANDLED;
	
	g_CheckMaps_UniqueTime = 1;
	
	new sText[32];
	new sFile[80];
	new i;
	
	console_print(id, "[LIST=1]");
	
	for(i = 0; i < g_mapnums; ++i) {
		formatex(sText, 31, "%a", ArrayGetStringHandle(g_Array_mapname, i));
		strtolower(sText);
		
		formatex(sFile, 79, "addons/amxmodx/configs/anuncios/%s.txt", sText);
		
		if(!file_exists(sFile))
			console_print(id, "[*]%s", sText);
	}
	
	console_print(id, "[/LIST]");
	
	return PLUGIN_HANDLED;
}

stock getPlaying() {
	new iPlaying = 0;
	new i;
	
	for(i = 1; i <= g_maxplayers; ++i) {
		if(is_user_connected(i)) {
			++iPlaying;
		}
	}
	
	return iPlaying;
}

stock containLetters(const String[]) {
	new iLen = strlen(String);
	new i;
	
	for(i = 0; i < iLen; ++i) {
		if(isalpha(String[i]) && String[i] != '*') {
			return 1;
		}
	}
	
	return 0;
}

stock countNumbers(const String[], const iLen = sizeof(String)) {
	new iCount = 0;
	new i;
	
	for(i = 0; i < iLen; ++i) {
		if(isdigit(String[i]) || String[i] == '*') {
			++iCount;
		}
	}
	
	return iCount;
}


/// GG y GGTP
public __Forward_GG_GetHe() { // Se ejecuta cuando alguien llega a la granada!
	remove_task(TASK_TIME_LIMIT);
	startVoteMap();
}