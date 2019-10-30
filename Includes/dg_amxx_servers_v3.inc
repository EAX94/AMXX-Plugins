#if defined _dg_amxx_servers_v3_included
	#endinput
#endif
#define _dg_amxx_servers_v3_included

enum _:structIdServers {
	TEST = 0,
	ZOMBIE_ESCAPE_01,
	ZOMBIE_ESCAPE_02,
	HUNGER_GAMES,
	DEATHRUN,
	JAILBREAK,
	BASEBUILDER,
	TTT,
	ZOMBIE_PLAGUE,
	CAPTURE_THE_FLAG,
	CSGO_MOD,
	TOWER_DEFENSE,
	GUNGAME
};

enum _:structServer {
	serverName[64],
	serverIp[21],
	serverPort,
	serverMapInit[32],
	serverTimeLimit,
	serverSlotReservation
};

new const SERVERS[structIdServers][structServer] = {
	{"Test", 				"45.58.126.42",	27025,	"de_dust2",			30, 	0},
	{"Zombie Escape #1", 	"45.58.126.44", 27050, 	"ze_area51_b3", 	30, 	1},
	{"Zombie Escape #2", 	"45.58.126.44", 27051,	"ze_area51_b3", 	30, 	1},
	{"Hunger Games",		"45.58.126.44",	27052,	"hg_coliseo_b5", 	30, 	1},
	{"Deathrun", 			"45.58.126.44", 27053,	"deathrun_death", 	30, 	1},
	{"JailBreak", 			"45.58.126.44",	27054,	"jail_xmf", 		45, 	1},
	{"Base Builder", 		"45.58.126.44", 27055,	"bb_frozen", 		999, 	0},
	{"Atrapa al Traidor",	"45.58.126.44", 27056,	"de_rats_1337", 	30, 	1},
	{"Zombie Plague", 		"45.58.126.44",	27057,	"zm_kontrax_b5",	45, 	1},
	{"Capture The Flag", 	"45.58.126.44", 27058,	"de_dust2", 		30, 	1},
	{"CS:GO Publico", 		"45.58.126.44",	27059,	"de_inferno", 		25, 	1},
	{"Tower Defense", 		"45.58.126.44", 27060,	"td_kmid", 			999,	0},
	{"Gun Game", 			"44.58.126.44", 27061,	"gg_mini_dust2",	999,	1}
};

new g_Server = -1;

public loadServers() {
	new sIp[32];
	new sServerIp[32];
	new i;

	get_user_ip(0, sIp, 31);

	for(i = 0; i < structIdServers; ++i) {
		formatex(sServerIp, 31, "%s:%d", SERVERS[i][serverIp], SERVERS[i][serverPort]);

		if(equal(sIp, sServerIp)) {
			g_Server = i;
		}
	}

	if(g_Server == -1) {
		return;
	}

	server_print("%sServidor: %s", AMXX_CONSOLE_PREFIX, SERVERS[g_Server][serverName]);
	server_print("%sComunidad: %s - Proovedor: %s", AMXX_CONSOLE_PREFIX, PLUGIN_COMMUNITY_NAME, PLUGIN_PROVIDER_NAME);
	server_print("%sIP del Servidor: %s:%d", AMXX_CONSOLE_PREFIX, SERVERS[g_Server][serverIp], SERVERS[g_Server][serverPort]);
	server_print("%s%s %s - by %s", AMXX_CONSOLE_PREFIX, PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR);
}

public loadSettings() {
	set_cvar_num("sv_maxspeed", 500);
	set_cvar_num("sv_voiceenable", 1);
	set_cvar_num("sv_alltalk", 1);
	set_cvar_num("sv_voicequality", 5);
	set_cvar_string("sv_voicecodec", "voice_speex");

	set_cvar_num("mp_footsteps", 1);
	set_cvar_num("mp_friendlyfire", 0);
	set_cvar_num("mp_timelimit", SERVERS[g_Server][serverTimeLimit]);

	set_cvar_num("allow_spectators", 1);
}