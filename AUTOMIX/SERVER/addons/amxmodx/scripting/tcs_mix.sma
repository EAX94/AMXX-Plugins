#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <fakemeta>
#include <hamsandwich>
#include <engine>
#include <sqlx>
#include <fun>
#include <cs_team_changer>
#include <model_changer>
#include <csx>
#include <unixtime>

#define TASK_START_MIX		93512821

#define MIN_PLAYERS			10
#define MIN_PLAYERS_HALF	MIN_PLAYERS / 2
#define MAX_ROUND_FOR_WIN	16
#define ROUND_DRAW			30
#define ROUND_HALF			15

new const g_plugin_name[] = "Automatic Mix";
new const g_plugin_version[] = "v1.2.0";
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

#define STATS_KILLS             0
#define STATS_DEATHS            1
#define STATS_HS                2
#define STATS_TKS               3
#define STATS_SHOTS             4
#define STATS_HITS              5
#define STATS_DAMAGE            6

#include <orpheu>
#include <orpheu_memory>

#define set_mp_pdata(%1,%2)  (OrpheuMemorySetAtAddress(g_pGameRules, %1, 1, %2))
#define get_mp_pdata(%1)     (OrpheuMemoryGetAtAddress(g_pGameRules, %1))

new g_pGameRules;

#define SQL_HOST	"127.0.0.1"
#define SQL_USER	"user"
#define SQL_PASS		"password"
#define SQL_TABLE	"table"
new Handle:g_sql_tuple;
new Handle:g_sql_connection;
new g_sql_errornum;
new g_sql_error[512];

new g_MESSAGE_OTHER_SERVER[150];

#define is_user_valid_connected(%1) (1 <= %1 <= g_maxplayers && is_user_connected(%1))
public plugin_precache()
{
	OrpheuRegisterHook(OrpheuGetFunction("InstallGameRules"), "OnInstallGameRules", OrpheuHookPost);
}
public OnInstallGameRules()
{
	g_pGameRules = OrpheuGetReturn();
}
public plugin_init()
{
	register_plugin(g_plugin_name, g_plugin_version, g_plugin_author);
	
	register_event("HLTV", "event_HLTV", "a", "1=0", "2=0");
	register_event("TeamInfo", "event_TeamInfo", "a");
	register_event("SendAudio", "event_SendAudio", "a", "2=%!MRAD_terwin", "2=%!MRAD_ctwin", "2=%!MRAD_rounddraw");
	
	register_forward(FM_ClientUserInfoChanged, "fw_ClientUserInfoChanged");
	register_forward(FM_ClientKill, "fw_ClientKill");
	
	RegisterHam(Ham_Killed, "player", "fw_PlayerKilled");
	RegisterHam(Ham_Spawn, "player", "fw_PlayerSpawn_Post", 1);
	RegisterHam(Ham_TakeDamage, "player", "fw_PlayerTakeDamage");
	RegisterHam(Ham_TraceAttack, "player", "fw_PlayerTraceAttack");
	
	register_clcmd("radio1", "clcmd_Block__NoMix");
	register_clcmd("radio2", "clcmd_Block__NoMix");
	register_clcmd("radio3", "clcmd_Block__NoMix");
	register_clcmd_all("listo", "clcmd_Ready");
	register_clcmd("say /maplist", "clcmd_Maps");
	register_clcmd("say_team /maplist", "clcmd_Maps");
	register_clcmd("say /estadisticas", "clcmd_Stats");
	register_clcmd("say_team /estadisticas", "clcmd_Stats");
	register_clcmd("say", "clcmd_Say");
	register_clcmd("say_team", "clcmd_SayTeam");
	register_clcmd("jointeam", "clcmd_ChangeTeam");
	register_clcmd("chooseteam", "clcmd_ChangeTeam");
	register_clcmd("timeleft", "clcmd_Block");
	
	register_menucmd(register_menuid("#Buy", 1), 511, "clcmd_Block__NoMix");
	register_menucmd(register_menuid("BuyPistol", 1), 511, "clcmd_Block__NoMix");
	register_menucmd(register_menuid("BuyShotgun", 1), 511, "clcmd_Block__NoMix");
	register_menucmd(register_menuid("BuySub", 1), 511, "clcmd_Block__NoMix");
	register_menucmd(register_menuid("BuyRifle", 1), 511, "clcmd_Block__NoMix");
	register_menucmd(register_menuid("BuyMachine", 1), 511, "clcmd_Block__NoMix");
	register_menucmd(register_menuid("BuyItem", 1), 511, "clcmd_Block__NoMix");
	register_menucmd(register_menuid("BuyEquip", 1), 511, "clcmd_Block__NoMix");
	register_menucmd(-28, 511, "clcmd_Block__NoMix");
	register_menucmd(-29, 511, "clcmd_Block__NoMix");
	register_menucmd(-30, 511, "clcmd_Block__NoMix");
	register_menucmd(-32, 511, "clcmd_Block__NoMix");
	register_menucmd(-31, 511, "clcmd_Block__NoMix");
	register_menucmd(-33, 511, "clcmd_Block__NoMix");
	register_menucmd(-34, 511, "clcmd_Block__NoMix");
	
	register_menu("Stats Menu", KEYSMENU, "topsHandler");
	
	register_concmd("amx_teamscore", "ClientCommand_SetTeamScore", ADMIN_RCON, "- <Team> <Score>");
	
	register_menucmd(register_menuid("Menu_Are_You_Ready"), (1 << 0) | (1 << 1), "MENU_AreYouReady");
	register_menucmd(register_menuid("Menu_Choose_Team_Name"), (1 << 0) | (1 << 1) | (1 << 2) | (1 << 3), "MENU_ChooseTeamName");
	register_menucmd(register_menuid("Menu_Kick_For_TA"), (1 << 0) | (1 << 1), "MENU_KickForTA");
	
	g_messageid_saytext = get_user_msgid("SayText");
	g_messageid_teaminfo = get_user_msgid("TeamInfo");
	
	register_message(get_user_msgid("SendAudio"), "message_SendAudio");
	register_message(get_user_msgid("ShowMenu"), "message_ShowMenu");
	register_message(get_user_msgid("VGUIMenu"), "message_VGUIMenu");
	register_message(get_user_msgid("TextMsg"), "Message_TextMsg");
	
	g_hud1 = CreateHudSyncObj();
	g_hud2 = CreateHudSyncObj();
	g_hud3 = CreateHudSyncObj();
	
	g_maxplayers = get_maxplayers();
	
	set_task(1.0, "fn_change_cvars");
	set_task(0.2, "fn_task_hud", TASK_HUD_REST_FOR_MIX, _, _, "b");
	
	loadMaps();
}
public plugin_cfg()
{
	server_cmd("amx_pausecfg add ^"%s^"", g_plugin_name);
	server_cmd("amx_pausecfg add ^"GAM!NGA^""); // Contiene todos los plugins de mi servidor, pero ustedes no lo tienen, deberían descomentar los que están debajo!
	
	//server_cmd("amx_pausecfg add ^"Admin Base (SQL)^"");
	//server_cmd("amx_pausecfg add ^"Admin Base^"");
	//server_cmd("amx_pausecfg add ^"Admin Commands^"");
	//server_cmd("amx_pausecfg add ^"Slots Reservation^"");
	//server_cmd("amx_pausecfg add ^"Admin Votes^"");
	//server_cmd("amx_pausecfg add ^"Anti Flood^"");
	//server_cmd("amx_pausecfg add ^"Info. Messages^"");
	//server_cmd("amx_pausecfg add ^"Restrict Weapons^"");
	//server_cmd("amx_pausecfg add ^"Scrolling Message^"");
	//server_cmd("amx_pausecfg add ^"StatsX^"");
}
	

public client_putinserver(id)
{
	fn_reset_vars(id);
	
	g_seconds[id] = 10;
	fn_showmenu_ready(id, g_seconds[id]);
	
	set_task(0.2, "fn_show_hud", id + TASK_HUD, _, _, "b");
	set_task(0.4, "fn_show_hud_spec", id + TASK_HUD_SPEC, _, _, "b");
	set_task(1.0, "fn_play_time", id + TASK_PLAY_TIME, _, _, "b");
	
	get_user_name(id, g_playername[id], charsmax(g_playername[]));
	
	replace_all(g_playername[id], charsmax(g_playername[]), "\", "");
	replace_all(g_playername[id], charsmax(g_playername[]), "!y", "");
	replace_all(g_playername[id], charsmax(g_playername[]), "!t", "");
	replace_all(g_playername[id], charsmax(g_playername[]), "!g", "");
	
	replace_all(g_playername[id], charsmax(g_playername[]), "ELEGIR AL AZAR", "unnamed");
	
	get_user_ip(id, g_local_ip[id], 20, 1);
}
public client_disconnect(id)
{	
	if(g_ready[id])
		g_count_ready--;
	
	new iTeamID = g_teamid[id];
	new iCaptain = g_captain[id];
	new iId = id;
	
	if(iCaptain)
	{
		if(g_duel)
		{
			new sName[32];
			new iTeam = get_user_team(id);
			get_user_name(id, sName, 31);
			
			if(fn_get_user_premiums_spec() > 0) id = fn_get_user_spec(1);
			else id = fn_get_user_spec(0);
			
			if(id)
			{
				set_pdata_int(id, 125, (get_pdata_int(id, 125, 5) & ~(1<<8)), 5);
				
				new sTeam[2];
				num_to_str(iTeam, sTeam, charsmax(sTeam));
				
				engclient_cmd(id, "jointeam", sTeam);
				engclient_cmd(id, "joinclass", "5");
				
				fn_close_menus(id);
				
				g_ready[id] = 1;
				g_teamid[id] = 0;
				g_captain[id] = 1;
				
				remove_task(id + TASK_HUD);
				remove_task(id + TASK_MENU_READY);
				remove_task(id + TASK_READY_REPEAT);
				
				CC(0, "!g[MIX]!y El capitán !g%s!y se fue y el nuevo capitán es: !g%s!", sName, g_playername[id]);
				
				new i;
				for(i = 1; i <= g_maxplayers; i++)
				{
					if(!is_user_connected(i)) continue;
					
					if(g_captain[i])
					{
						if(!is_user_alive(i))
							ExecuteHamB(Ham_CS_RoundRespawn, i)
						
						set_task(0.4, "fn_charge_captains", i);
					}
				}
			}
			else fn_reset_mix();
		}
		else if(g_chosing)
			fn_reset_mix();
	}
	
	fn_reset_vars(iId);
	fn_reset_tasks(iId);
	
	if(get_user_team(id) == 1 || get_user_team(id) == 2)
	{
		if(g_mix_valid || g_chosing_team)
		{
			new sTeamName[12];
			formatex(sTeamName, charsmax(sTeamName), "%s", (iTeamID == 1) ? "PUBEROS" : "MIXEROS");
			
			new iTeam = get_user_team(id);
			new sName[32];
			new sTeam[2];
			
			num_to_str(iTeam, sTeam, charsmax(sTeam));
			get_user_name(id, sName, 31);
			
			if(fn_get_user_premiums_spec() > 0) id = fn_get_user_spec(1);
			else id = fn_get_user_spec(0);
			
			if(!id)
			{
				if(fn_get_ts(1) < 3 || fn_get_cts(1) < 3)
				{
					CC(0, "!g[MIX]!y El equipo !g%s!y perdió por falta de jugadores", sTeamName);
					fn_final_mix(1);
				}
				else CC(0, "!g[MIX]!y El jugador !g%s!y se ha ido del equipo !g%s!y y si queda con menos de 3 jugadores perderá el mix", sName, sTeamName);
			}
			else
			{
				set_pdata_int(id, 125, (get_pdata_int(id, 125, 5) & ~(1<<8)), 5);
				
				engclient_cmd(id, "jointeam", sTeam);
				engclient_cmd(id, "joinclass", "5");
				
				fn_close_menus(id);
				
				if(!g_ready[id]) g_count_ready++;
				g_ready[id] = 1;
				g_teamid[id] = iTeamID;
				g_captain[id] = iCaptain;
				
				remove_task(id + TASK_HUD);
				remove_task(id + TASK_MENU_READY);
				remove_task(id + TASK_READY_REPEAT);
				
				CC(0, "!g[MIX]!y El jugador !g%s!y se ha ido del equipo !g%s!y y en su lugar se incorporó a: !g%s!y", sName, sTeamName, g_playername[id]);
			}
		}
	}
	
	if(g_mix_valid)
	{
		new i;
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(!is_user_connected(i)) continue;
			if(get_user_team(i) != 3) continue;
			
			g_pos[i] = 0;
			g_pos[i] = fn_get_user_position(i);
		}
	}
}


public event_HLTV()
{
	if(g_mix)
	{
		if(!g_captains_choosen)
		{
			fn_choose_captains();
			g_duel = 1;
		}
		
		if(g_duel)
		{
			new i;
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!is_user_connected(i)) continue;
				
				if(g_captain[i])
					set_task(0.4, "fn_charge_captains", i);
			}
		}
	}
	
	if(g_mix_valid)
	{
		if(!g_ab[1] && (g_score[0] + g_win_ts + g_score[1] + g_win_cts) == ROUND_HALF)
		{
			g_ab[1] = 1;
			
			g_score[0] = g_win_cts;
			g_score[1] = g_win_ts;
			
			g_win_cts = 0;
			g_win_ts = 0;
			
			new i;
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(is_user_connected(i) && (get_user_team(i) == 1 || get_user_team(i) == 2))
				{
					g_frags[i] = get_user_frags(i);
					g_deaths[i] = cs_get_user_deaths(i);
				}
			}
			
			fn_set_teams(1, 2);
		}
		
		if(g_ab[1] == 2 && (g_score[0] + g_win_ts + g_score[1] + g_win_cts) == ROUND_HALF)
		{
			g_ab[1] = 999;
			
			new i;
			new iEqual;
			new iTeam;
			
			set_hudmessage(23, 125, 54, -1.00, 0.17, 0, 0.0, 16.0, 1.0, 1.0, -1);
			
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!is_user_connected(i)) continue;
				if(get_user_team(i) == 0 || get_user_team(i) == 3) continue;
				
				iEqual = g_teamid[i];
				iTeam = get_user_team(i);
				
				ShowSyncHudMsg(i, g_hud2, "Equipos cambiados...^nResultado parcial:^n^n\
				%s: %d^n\
				%s: %d", (iEqual == 1) ? "PUBEROS" : "MIXEROS", (iTeam == 1) ? g_score[0] : g_score[1],
				(iEqual == 1) ? "MIXEROS" : "PUBEROS", (iTeam == 1) ? g_score[1] : g_score[0]);
			}
			
			server_cmd("amx_teamscore T %d", g_score[0]);
			server_cmd("amx_teamscore CT %d", g_score[1]);
		}
		else if(((g_win_cts + g_score[1]) == MAX_ROUND_FOR_WIN) ||
		((g_win_ts + g_score[0]) == MAX_ROUND_FOR_WIN) ||
		((g_score[0] + g_win_ts + g_score[1] + g_win_cts) == ROUND_DRAW))
			fn_final_mix(0);
		
		if(g_ab[1] == 1)
		{
			g_ab[1] = 2;
			set_cvar_num("sv_restart", 1);
		}
		
		new i;
		new Float:j;
		
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(!is_user_connected(i)) continue;
			if(g_dmg_ta[i] >= 100)
			{
				j++;
				set_task((j * 9.0), "fn_kick_for_ta", i);
			}
		}
	}
}
public event_TeamInfo()
{
	new id = read_data(1);
	new sTeam[32];
	new iTeam;
	new i;
	
	read_data(2, sTeam, charsmax(sTeam));
	
	for(i = 0; i < MAX_TEAMS; i++)
	{
		if(g_cTeamChars[i] == sTeam[0])
		{
			iTeam = i;
			break;
		}
	}
	
	if(g_team[id] != iTeam)
	{
		g_players[g_team[id]]--;
		g_team[id] = iTeam;
		g_players[iTeam]++;
	}
	
	if(!is_user_alive(id) && is_user_connected(id))
	{
		new pTeam = get_pdata_int(id, 114, 5)
		if(pTeam != get_user_team(id))
		{
			emessage_begin(MSG_BROADCAST, get_user_msgid("ScoreInfo"));
			ewrite_byte(id);
			ewrite_short(get_user_frags(id));
			ewrite_short(get_pdata_int(id, 444, 5) );
			ewrite_short(0);
			ewrite_short(pTeam);
			emessage_end();
		}
	}
}
public event_SendAudio()
{
	set_task(1.0, "fn_task_ev", 997);
	return PLUGIN_CONTINUE;
}


public fw_ClientUserInfoChanged(id, buffer)
{
	if(!is_user_connected(id))
		return FMRES_IGNORED;

	static sNewName[32];
	
	engfunc(EngFunc_InfoKeyValue, buffer, "name", sNewName, charsmax(sNewName));
	get_user_name(id, g_playername[id], charsmax(g_playername[]));
	
	replace_all(g_playername[id], charsmax(g_playername[]), "\", "")
	replace_all(g_playername[id], charsmax(g_playername[]), "!y", "");
	replace_all(g_playername[id], charsmax(g_playername[]), "!t", "");
	replace_all(g_playername[id], charsmax(g_playername[]), "!g", "");
	
	replace_all(g_playername[id], charsmax(g_playername[]), "ELEGIR AL AZAR", "unnamed");
	
	if(equal(sNewName, g_playername[id]))
		return FMRES_IGNORED;
	
	if(g_mix)
	{
		engfunc(EngFunc_SetClientKeyValue, id, buffer, "name", g_playername[id]);
		client_cmd(id, "name ^"%s^"; setinfo name ^"%s^"", g_playername[id], g_playername[id]);
		
		console_print(id, "No puedes cambiarte el nombre con el mix en progreso");
		
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}
public fw_ClientKill()
{
	if(g_mix)
		return FMRES_SUPERCEDE;
	
	return FMRES_IGNORED;
}



public fw_PlayerKilled(victim, attacker, shouldgib)
{
	if(g_mix && g_duel && g_captain[attacker] && g_captain[victim])
	{
		g_chosing = 1;
		g_duel = 0;
		
		if(get_user_weapon(attacker) == CSW_KNIFE)
		{
			g_captain_winner = attacker;
			
			if((fn_get_ts(0) + fn_get_cts(0)) != MIN_PLAYERS)
			{
				g_turn[g_captain_winner] = 1;
				g_seconds[g_captain_winner] = 20;
				fn_showmenu_choose(g_captain_winner, g_seconds[g_captain_winner]);
			}
			else
			{
				g_turn[g_captain_winner] = 1;
				g_seconds[g_captain_winner] = 11;
				g_chosing_team = 1;
				fn_showmenu_teamname(g_captain_winner, g_seconds[g_captain_winner], 1);
			}
		}
		else
		{
			CC(0, "!g[MIX]!y El atacante usó un arma que no es el cuchillo y por eso perdió")
			
			g_captain_winner = victim;
			
			if((fn_get_ts(0) + fn_get_cts(0)) != MIN_PLAYERS)
			{
				g_turn[g_captain_winner] = 1;
				g_seconds[g_captain_winner] = 20;
				fn_showmenu_choose(g_captain_winner, g_seconds[g_captain_winner]);
			}
			else
			{
				g_turn[g_captain_winner] = 1;
				g_seconds[g_captain_winner] = 11;
				g_chosing_team = 1;
				fn_showmenu_teamname(g_captain_winner, g_seconds[g_captain_winner], 1);
			}
		}
	}
	
	fn_stats_save(victim);
}
public fw_PlayerSpawn_Post(id)
{
	if(!is_user_alive(id) || !get_user_team(id))
		return;
	
	g_dmg_ta[id] = 0;
	g_round_echoe[id] = 0;
	
	if(g_frags[id] != 0 || g_deaths[id] != 0)
	{
		if(g_ab[1] == 999)
		{
			set_user_frags(id, g_frags[id]);
			cs_set_user_deaths(id, g_deaths[id]);
			
			g_frags[id] = 0;
			g_deaths[id] = 0;
		}
	}
	
	if(g_mix_valid)
		client_cmd(id, "say_team $%d", cs_get_user_money(id));
}
public fw_PlayerTakeDamage(victim, inflictor, attacker, Float:damage, damage_type)
{
	if(g_mix && g_duel && ((damage_type & DMG_FALL) || (is_user_alive(attacker) && get_user_weapon(attacker) != CSW_KNIFE)))
	{
		damage *= 0.0;
		SetHamParamFloat(4, damage);
		
		return HAM_SUPERCEDE;
	}
	
	if(damage_type == 64) // C4
		return HAM_IGNORED;
	
	if(g_mix_valid && victim != attacker && is_user_valid_connected(attacker))
	{
		if(get_user_team(attacker) == get_user_team(victim))
		{
			set_user_health(attacker, get_user_health(attacker) - (floatround(damage) / 3));
			return HAM_SUPERCEDE;
		}
	}
	
	return HAM_IGNORED;
}
public fw_PlayerTraceAttack(victim, attacker, Float:damage, Float:direction[3], tracehandle, damage_type)
{
	if(victim == attacker || !is_user_valid_connected(attacker))
		return HAM_IGNORED;
	
	if(g_mix && g_duel && is_user_alive(attacker) && get_user_weapon(attacker) != CSW_KNIFE)
		return HAM_SUPERCEDE;
	
	return HAM_IGNORED;
}



public clcmd_Ready(id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!g_ready[id])
	{
		g_ready[id] = 1;
		g_count_ready++;
		
		CC(id, "!g[MIX]!y Ya estás listo para jugar.");
		
		if(g_count_ready >= MIN_PLAYERS && !g_mix && !task_exists(TASK_START_MIX))
		{
			CC(0, "!g[MIX]!y 10 jugadores listos. En !g10 segundos!y se elegirán los capitanes!");
			
			remove_task(TASK_START_MIX);
			set_task(10.0, "startMIX", TASK_START_MIX);
			//fn_start_mix();
		}
		
		if(g_mix_valid)
		{
			new i;
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!is_user_connected(i)) continue;
				if(get_user_team(i) != 3) continue;
				
				g_pos[i] = 0;
				g_pos[i] = fn_get_user_position(i);
			}
		}
	}
	
	return PLUGIN_HANDLED;
}
public clcmd_Say(id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(g_duel || g_chosing)
		return PLUGIN_HANDLED;
	
	if(g_mix_valid)
	{
		new Float:nexTime = get_gametime();
		if(g_Flooding[id] > nexTime)
		{
			if(g_Flood[id] >= 3)
			{
				client_print(id, print_console, "** Deja de saturar el servidor **");
				g_Flooding[id] = nexTime + 0.75 + 3.0;
				
				return PLUGIN_HANDLED;
			}
			
			g_Flood[id]++
		}
		else if(g_Flood[id]) g_Flood[id]--;
		
		g_Flooding[id] = nexTime + 0.75;

		static sMessage[191];
		read_args(sMessage, charsmax(sMessage));
		remove_quotes(sMessage);
		
		replace_all(sMessage, charsmax(sMessage), "%", "% ");
		replace_all(sMessage, charsmax(sMessage), "!y", "");
		replace_all(sMessage, charsmax(sMessage), "!t", "");
		replace_all(sMessage, charsmax(sMessage), "!g", "");
		
		if(equali(sMessage, ""))
			return PLUGIN_HANDLED;
		
		new iAlive = is_user_alive(id);
		new iTeam = get_user_team(id);
		new iColor = DONT_CHANGE;
		
		if(iTeam == 0 || iTeam == 3)
		{
			format(sMessage, charsmax(sMessage), "!y(ESPECTADOR) !t%s!y : %s", g_playername[id], sMessage);
			
			iColor = SPECTATOR;
		}
		else
		{
			format(sMessage, charsmax(sMessage), "!y%s(%s) !t%s!y : %s", (iAlive) ? "" : "*DEAD* ", (g_teamid[id] == 1) ? "PUBEROS" : "MIXEROS", g_playername[id], sMessage);
			
			if(iTeam == 1) iColor = TERRORIST;
			else iColor = CT;
		}
		
		replace_all(sMessage, charsmax(sMessage), "!y", "^x01");
		replace_all(sMessage, charsmax(sMessage), "!t", "^x03");
		replace_all(sMessage, charsmax(sMessage), "!g", "^x04");
		
		new i;
		
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(!(get_user_flags(i) & ADMIN_PASSWORD))
			{
				if(get_user_team(i) != iTeam)
					continue;
				
				if(iAlive && !is_user_alive(i))
					continue;
				
				if(!iAlive && is_user_alive(i))
					continue;
			}
			
			fn_CC(i, iColor, sMessage);
		}
		
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_CONTINUE;
}
public clcmd_SayTeam(id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(g_duel || g_chosing)
		return PLUGIN_CONTINUE;
	
	if(g_mix_valid)
	{
		static sMessage[191];
		read_args(sMessage, charsmax(sMessage));
		remove_quotes(sMessage);
		
		replace_all(sMessage, charsmax(sMessage), "%", "% ");
		replace_all(sMessage, charsmax(sMessage), "!y", "");
		replace_all(sMessage, charsmax(sMessage), "!t", "");
		replace_all(sMessage, charsmax(sMessage), "!g", "");
		
		if(equali(sMessage, ""))
			return PLUGIN_HANDLED;
		
		new iAlive = is_user_alive(id);
		new iTeam = get_user_team(id);
		new iColor = DONT_CHANGE;
		
		if(iTeam == 0 || iTeam == 3)
		{
			format(sMessage, charsmax(sMessage), "!y(ESPECTADOR) !t%s!y : %s", g_playername[id], sMessage);
			
			iColor = SPECTATOR;
		}
		else
		{
			format(sMessage, charsmax(sMessage), "!y%s(%s) !t%s!y : %s", (iAlive) ? "" : "*DEAD* ", (g_teamid[id] == 1) ? "PUBEROS" : "MIXEROS", g_playername[id], sMessage);
			
			if(iTeam == 1) iColor = TERRORIST;
			else iColor = CT;
		}
		
		replace_all(sMessage, charsmax(sMessage), "!y", "^x01");
		replace_all(sMessage, charsmax(sMessage), "!t", "^x03");
		replace_all(sMessage, charsmax(sMessage), "!g", "^x04");
		
		new i;
		
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(!(get_user_flags(i) & ADMIN_PASSWORD))
			{
				if(get_user_team(i) != iTeam)
					continue;
				
				if(iAlive && !is_user_alive(i))
					continue;
				
				if(!iAlive && is_user_alive(i))
					continue;
			}
			
			fn_CC(i, iColor, sMessage);
		}
		
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_CONTINUE;
}
public clcmd_ChangeTeam(id)
{
	return PLUGIN_HANDLED;
}
public clcmd_Block(id) return PLUGIN_HANDLED;
public clcmd_Stats(id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(get_user_team(id) != 3)
	{
		CC(id, "!g[MIX]!y Solo disponible para espectadores");
		return PLUGIN_HANDLED;
	}
	
	static sMenu[600];
	static iLen;
	
	iLen = 0;
	
	if(!g_stats_page[id])
	{
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yTOPS^n^n\r1. \wGanadores que terminaron primeros^n\r2. \wGanadores (histórico)^n\r3. \wMatados en un mapa^n\r4. \wMatados en total^n\
		\r5. \wDaño en un mapa^n\r6. \wDaño en total^n\r7. \wHeadshots en un mapa^n\r8. \wHeadshots en total^n^n\r9. \wSiguiente^n\r0. \wSalir");
	}
	else
	{
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yTOPS^n^n\r1. \wTKs en un mapa^n\r2. \wTKs en total^n\r3. \wMix jugados^n^n\
		\rNOTA:\w Si quieres ver los records completos ingresa en:^n\yhttp://www.gaminga.com/servidores/counter-strike/automix/records/^n^n\r9. \wAtrás^n\r0. \wSalir");
	}
	
	set_pdata_int(id, 205, 0, 5);
	show_menu(id, KEYSMENU, sMenu, -1, "Stats Menu");
	
	return PLUGIN_HANDLED;
}
public topsHandler(id, key)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(key != 9)
	{
		if(g_stats_cd[id] > halflife_time())
		{
			CC(id, "!g[MIX]!y Tienes que esperar unos segundos antes de poder ver otra estadística");
			
			clcmd_Stats(id);
			return PLUGIN_HANDLED;
		}
	}
	
	static name_top[32];
	static top_url[300];
	
	if(!g_stats_page[id])
	{
		switch(key)
		{
			case 0:
			{
				formatex(name_top, charsmax(name_top), "Top 15 - Ganadores que terminaron primeros")
				
			}
			case 1:
			{
				formatex(name_top, charsmax(name_top), "Top 15 - Ganadores (histórico)")
				
			}
			case 2:
			{
				formatex(name_top, charsmax(name_top), "Top 15 - Matados en un mapa")
			}
			case 3: 
			{
				formatex(name_top, charsmax(name_top), "Top 15 - Matados en total");
			}
			case 4: 
			{
				formatex(name_top, charsmax(name_top), "Top 15 - Daño en un mapa");
			}
			case 5: 
			{
				formatex(name_top, charsmax(name_top), "Top 15 - Daño en total");
			}
			case 6: 
			{
				formatex(name_top, charsmax(name_top), "Top 15 - Headshots en un mapa");
			}
			case 7:
			{
				formatex(name_top, charsmax(name_top), "Top 15 - Headshots en total");
			}
			case 8:
			{
				g_stats_page[id] = !g_stats_page[id];
				
				clcmd_Stats(id);
				return PLUGIN_HANDLED;
			}
			case 9: return PLUGIN_HANDLED;
		}
	}
	else
	{
		switch(key)
		{
			case 0:
			{
				formatex(name_top, charsmax(name_top), "Top 15 - TKs en un mapa");
			}
			case 1:
			{
				formatex(name_top, charsmax(name_top), "Top 15 - TKs en total");
			}
			case 2:
			{
				formatex(name_top, charsmax(name_top), "Top 15 - Mix jugados")
			}
			case 8:
			{
				g_stats_page[id] = !g_stats_page[id];
				
				clcmd_Stats(id);
				return PLUGIN_HANDLED;
			}
			case 9: return PLUGIN_HANDLED;
			default:
			{
				clcmd_Stats(id);
				return PLUGIN_HANDLED;
			}
		}
	}
	
	if(key != 8 && key != 9)
	{
		g_stats_cd[id] = halflife_time() + 3.00;
		show_motd(id, top_url, name_top);
	}
	
	clcmd_Stats(id);
	
	return PLUGIN_HANDLED;
}


public ClientCommand_SetTeamScore(const player, const level, const cid)
{
	if(!cmd_access(player, level, cid, 3))
		return PLUGIN_HANDLED;

	new team [2];
	new score[6];
	
	read_argv(1, team, charsmax(team));
	read_argv(2, score, charsmax(score));
	
	new signedShort = 32768;
	new scoreToGive = clamp( str_to_num( score ), -signedShort, signedShort );
	
	switch(team[0])
	{
		case 'C', 'c': set_mp_pdata( "m_iNumCTWins", scoreToGive );
		case 'T', 't': set_mp_pdata( "m_iNumTerroristWins", scoreToGive );
		default: return PLUGIN_HANDLED;
	}
	
	UpdateTeamScores(.notifyAllPlugins = true);
	UpdateTeamScores(.notifyAllPlugins = true);
	
	return PLUGIN_HANDLED;
}


public MENU_AreYouReady(id, key)
{
	if(!is_user_connected(id)) 
		return PLUGIN_HANDLED;
	
	if(key == 0) clcmd_Ready(id);
	else if(key == 1)
	{
		g_choosen_no[id]++;
		if(g_choosen_no[id] == 3)
		{
			server_cmd("kick #%d ^"3 veces no estuviste listo para jugar^"", get_user_userid(id));
			return PLUGIN_HANDLED;
		}
		
		if(g_mix)
		{
			new i;
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!is_user_connected(i)) continue;
				if(get_user_team(i) != 3) continue;
				
				CC(i, "!g[MIX]!y El jugador !g%s!y no está listo para jugar", g_playername[id]);
			}
		}
		else CC(0, "!g[MIX]!y El jugador !g%s!y no está listo para jugar", g_playername[id]);
		
		remove_task(id + TASK_MENU_READY);
		remove_task(id + TASK_READY_REPEAT);
		set_task(120.0, "fn_menu_ready_repeat", id + TASK_READY_REPEAT);
	}
	
	fn_close_menus(id);
	return PLUGIN_HANDLED;
}
public MENU_ChooseTeamName(id, key)
{
	if(!is_user_connected(id)) 
		return PLUGIN_HANDLED;
	
	switch(key)
	{
		case 0: // Terrorista
		{
			if(g_mode == 3)
			{
				CC(id, "!g[MIX]!y El otro capitán ha elegido el equipo en donde empezar");
				return PLUGIN_HANDLED;
			}
			
			g_mode = 3;
			g_seconds[id] = -1;
			g_turn[id] = 0;
			g_count_mode++;
			
			remove_task(id + TASK_MENU_CHOOSE_TEAM_NAME);
			
			fn_set_teams(get_user_team(id), 1);
			fn_showmenu_for_captain(id, g_mode);
			
			copy(g_cname[g_count_mode-1], charsmax(g_cname[]), g_playername[id]);
			g_cmode[g_count_mode-1] = 1;
		}
		case 1: // Anti-Terrorista
		{
			if(g_mode == 3)
			{
				CC(id, "!g[MIX]!y El otro capitán ha elegido el equipo en donde empezar");
				return PLUGIN_HANDLED;
			}
			
			g_mode = 3;
			g_seconds[id] = -1;
			g_turn[id] = 0;
			g_count_mode++;
			
			remove_task(id + TASK_MENU_CHOOSE_TEAM_NAME);
			
			fn_set_teams(get_user_team(id), 2);
			fn_showmenu_for_captain(id, g_mode);
			
			copy(g_cname[g_count_mode-1], charsmax(g_cname[]), g_playername[id]);
			g_cmode[g_count_mode-1] = 2;
		}
		case 2: // Poringueros!
		{
			if(g_mode == 2)
			{
				CC(id, "!g[MIX]!y El otro capitán ha elegido el nombre del equipo");
				return PLUGIN_HANDLED;
			}
			
			g_mode = 2;
			g_seconds[id] = -1;
			g_turn[id] = 0;
			g_count_mode++;
			
			remove_task(id + TASK_MENU_CHOOSE_TEAM_NAME);
			
			fn_set_names(get_user_team(id), 1);
			fn_showmenu_for_captain(id, g_mode);
			
			copy(g_cname[g_count_mode-1], charsmax(g_cname[]), g_playername[id]);
			g_cmode[g_count_mode-1] = 3;
		}
		case 3: // Taringueros!
		{
			if(g_mode == 2)
			{
				CC(id, "!g[MIX]!y El otro capitán ha elegido el nombre del equipo");
				return PLUGIN_HANDLED;
			}
			
			g_mode = 2;
			g_seconds[id] = -1;
			g_turn[id] = 0;
			g_count_mode++;
			
			remove_task(id + TASK_MENU_CHOOSE_TEAM_NAME);
			
			fn_set_names(get_user_team(id), 2);
			fn_showmenu_for_captain(id, g_mode);
			
			copy(g_cname[g_count_mode-1], charsmax(g_cname[]), g_playername[id]);
			g_cmode[g_count_mode-1] = 4;
		}
	}
	
	fn_close_menus(id);
	return PLUGIN_HANDLED;
}
public MENU_KickForTA(id, key)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	switch(key)
	{
		case 0: g_votes[0]++;
		case 1: g_votes[1]++;
	}
	
	fn_close_menus(id);
	return PLUGIN_HANDLED;
}



public register_clcmd_all(const command[], function[])
{
	new sFormatCommand[32];
	
	formatex(sFormatCommand, charsmax(sFormatCommand), "say /%s", command);
	register_clcmd(sFormatCommand, function);
	
	formatex(sFormatCommand, charsmax(sFormatCommand), "say .%s", command);
	register_clcmd(sFormatCommand, function);
	
	formatex(sFormatCommand, charsmax(sFormatCommand), "say_team /%s", command);
	register_clcmd(sFormatCommand, function);
	
	formatex(sFormatCommand, charsmax(sFormatCommand), "say_team .%s", command);
	register_clcmd(sFormatCommand, function);
}
public fn_showmenu_ready(id, seconds)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(seconds == 0)
	{
		fn_close_menus(id);
		
		g_choosen_no[id]++;
		if(g_choosen_no[id] == 3)
		{
			server_cmd("kick #%d ^"3 veces no estuviste listo para jugar^"", get_user_userid(id));
			return PLUGIN_HANDLED;
		}
		
		CC(id, "!g[MIX]!y No has elegido ninguna opción y por defecto se te eligió que no estás listo para jugar");
		if(g_mix)
		{
			new i;
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!is_user_connected(i)) continue;
				if(get_user_team(i) != 3) continue;
				
				CC(i, "!g[MIX]!y El jugador !g%s!y no está listo para jugar", g_playername[id]);
			}
		}
		else CC(0, "!g[MIX]!y El jugador !g%s!y no está listo para jugar", g_playername[id]);
		
		remove_task(id + TASK_READY_REPEAT);
		set_task(120.0, "fn_menu_ready_repeat", id + TASK_READY_REPEAT);
		
		return PLUGIN_HANDLED;
	}
	
	static sMenu[512];
	formatex(sMenu, charsmax(sMenu), "\rEstás listo para jugar?    %d/3\R\y%d^n^n1. \wSi^n\y2. \wNo", (g_choosen_no[id]+1), seconds);
	show_menu(id, (1 << 0) | (1 << 1), sMenu, seconds, "Menu_Are_You_Ready");
	
	remove_task(id + TASK_MENU_READY);
	set_task(1.0, "fn_showmenu_ready_repeat", id + TASK_MENU_READY);
	
	return PLUGIN_HANDLED;
}
public fn_showmenu_ready_repeat(taskid)
{
	if(!is_user_connected(ID_MENU_READY))
		return PLUGIN_HANDLED;
	
	if(g_ready[ID_MENU_READY])
		return PLUGIN_HANDLED;
	
	g_seconds[ID_MENU_READY]--;
	fn_showmenu_ready(ID_MENU_READY, g_seconds[ID_MENU_READY]);
	
	return PLUGIN_HANDLED;
}
public fn_menu_ready_repeat(taskid)
{
	if(!g_ready[ID_READY_REPEAT] && (get_user_team(ID_READY_REPEAT) == 1 || get_user_team(ID_READY_REPEAT) == 2))
	{
		g_seconds[ID_READY_REPEAT] = 10;
		fn_showmenu_ready(ID_READY_REPEAT, g_seconds[ID_READY_REPEAT]);
	}
}
public fn_show_hud(taskid)
{
	if(is_user_connected(ID_HUD) && ((get_user_team(ID_HUD) == 3 && g_mix) || !g_mix))
	{
		static buffer[32];
		formatex(buffer, charsmax(buffer), "Hay %d jugadores delante tuyo", g_pos[ID_HUD]);
		
		set_hudmessage(g_ready[ID_HUD] ? 000 : 255, g_ready[ID_HUD] ? 255 : 000, 000, -1.00, 0.17, 0, 6.0, 1.1, 0.0, 0.0, -1);
		ShowSyncHudMsg(ID_HUD, g_hud1, "ESTADO: %s^n%s%s",
		g_ready[ID_HUD] ? "ESTÁS LISTO" :
		(g_choosen_no[ID_HUD] >= 2) ? "NO ESTÁS LISTO^nESCRIBÍ /LISTO CUANDO LO ESTÉS^n^nSI LA PRÓXIMA VEZ NO ESTÁS LISTO, SERÁS EXPULSADO" :
		"NO ESTÁS LISTO^nESCRIBÍ /LISTO CUANDO LO ESTÉS",
		(g_mix_valid && g_ready[ID_HUD]) ? buffer : "", g_MESSAGE_OTHER_SERVER);
	}
}
public fn_change_cvars()
{
	set_cvar_num("mp_limitteams", 0);
	set_cvar_num("pbk_join_min_players", 33);
	
	set_cvar_string("sv_password", "");
}
public fn_close_menus(id)
{
	message_begin(MSG_ONE, get_user_msgid("ShowMenu"), .player=id);
	{ 
		write_short(0);
		write_char(0);
		write_byte(0);
		write_string("");
	} 
	message_end();
}
public fn_task_hud(taskid)
{
	set_hudmessage(255, 255, 255, 0.01, 0.25, 0, 6.0, 1.1, 0.0, 0.0, -1);
	ShowSyncHudMsg(0, g_hud2, "Listos %d - Falta%s %d", g_count_ready, (10-g_count_ready != 1) ? "n" : "", clamp((10-g_count_ready), 0, 10));
	
	if(g_mix)
	{
		remove_task(taskid);
		return;
	}
}
public fn_task_autojoin(iParam[], id)
{
	new iTeam = fn_get_new_team();
	if(iTeam != -1)
		fn_handle_join(id, iParam[0], iTeam);
}
public fn_showmenu_choose(id, seconds)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!g_turn[id])
		return PLUGIN_HANDLED;
	
	if(seconds == 0)
	{
		fn_close_menus(id);
		
		new i;
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(is_user_connected(i) && g_ready[i] && get_user_team(i) == 3)
			{
				g_turn[id] = 0;
				remove_task(id + TASK_MENU_CHOOSE);
				
				if((get_user_team(id) == 1 && fn_get_ts(0) == 5) || (get_user_team(id) == 2 && fn_get_cts(0) == 5))
				{
					CC(id, "!g[MIX]!y No puede haber más de 5 jugadores en tu equipo");
					
					new i;
					for(i = 1; i <= g_maxplayers; i++)
					{
						if(g_captain[i] && get_user_team(i) != get_user_team(id))
						{
							if((fn_get_ts(0) + fn_get_cts(0)) != MIN_PLAYERS)
							{
								g_turn[i] = 1;
								g_seconds[i] = 20;
								fn_showmenu_choose(i, g_seconds[i]);
							}
							else
							{
								g_turn[g_captain_winner] = 1;
								g_seconds[g_captain_winner] = 11;
								g_chosing_team = 1;
								fn_showmenu_teamname(g_captain_winner, g_seconds[g_captain_winner], 1);
							}
							
							break;
						}
					}
				
					return PLUGIN_HANDLED;
				}
				
				CC(0, "!g* %s!y tardó demasiado en elegir a un compañero, se eligió automaticamente a: !g%s!y", g_playername[id], g_playername[i]);
				
				new iTeam = get_user_team(id);
				new sTeam[2];
				num_to_str(iTeam, sTeam, charsmax(sTeam));
				
				set_pdata_int(i, 125, (get_pdata_int(id, 125, 5) & ~(1<<8)), 5);
				
				engclient_cmd(i, "jointeam", sTeam);
				engclient_cmd(i, "joinclass", "5");
				
				fn_close_menus(i);
				
				remove_task(i + TASK_HUD);
				remove_task(i + TASK_MENU_READY);
				remove_task(i + TASK_READY_REPEAT);
				
				new j;
				for(j = 1; j <= g_maxplayers; j++)
				{
					if(g_captain[j] && get_user_team(j) != get_user_team(id))
					{
						if((fn_get_ts(0) + fn_get_cts(0)) != MIN_PLAYERS)
						{
							g_turn[j] = 1;
							g_seconds[j] = 20;
							fn_showmenu_choose(j, g_seconds[j]);
						}
						else
						{
							g_turn[g_captain_winner] = 1;
							g_seconds[g_captain_winner] = 11;
							g_chosing_team = 1;
							fn_showmenu_teamname(g_captain_winner, g_seconds[g_captain_winner], 1);
						}
						
						break;
					}
				}
				
				break;
			}
		}
		
		return PLUGIN_HANDLED;
	}
	
	new sMenuName[64];
	formatex(sMenuName, charsmax(sMenuName), "\rElige a tu compañero de equipo:\R\y%d seg.", seconds);
	new iMenu = menu_create(sMenuName, "MENU_ChoosePlayer");
	
	new sPlayers[32];
	new sPosition[3];
	new iPlayers;
	new iId;
	new i;
	new j = 1;
	
	get_players(sPlayers, iPlayers);
	for(i = 0; i < iPlayers; i++)
	{ 
		iId = sPlayers[i];
		
		if(!is_user_connected(iId)) continue;
		if(!g_ready[iId]) continue;
		if(get_user_team(iId) != 3) continue;
		
		num_to_str(iId, sPosition, charsmax(sPosition));
		menu_additem(iMenu, g_playername[iId], sPosition);
		
		++j
	}
	
	num_to_str(j, sPosition, charsmax(sPosition));
	menu_additem(iMenu, "ELEGIR AL AZAR", sPosition);
	
	if(menu_items(iMenu) <= 1)
	{
		menu_destroy(iMenu);
		
		CC(0, "!g[MIX]!y No hay jugadores validos para elegir.");
		
		g_turn[id] = 0;
		remove_task(id + TASK_MENU_CHOOSE);
		
		g_turn[g_captain_winner] = 1;
		g_seconds[g_captain_winner] = 11;
		g_chosing_team = 1;
		fn_showmenu_teamname(g_captain_winner, g_seconds[g_captain_winner], 1);
	
		return PLUGIN_HANDLED;
	}
	
	menu_setprop(iMenu, MPROP_BACKNAME, "Anterior");
	menu_setprop(iMenu, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(iMenu, MPROP_EXIT, MEXIT_NEVER);
	
	g_menu_page[id] = min(g_menu_page[id], menu_pages(iMenu)-1);
	
	menu_display(id, iMenu, g_menu_page[id]);
	
	remove_task(id + TASK_MENU_CHOOSE);
	set_task(20.0, "fn_showmenu_choose_repeat", id + TASK_MENU_CHOOSE);
	
	return PLUGIN_HANDLED;
}
public fn_showmenu_choose_repeat(taskid)
{
	if(!is_user_connected(ID_MENU_CHOOSE))
		return PLUGIN_HANDLED;
	
	if(!g_turn[ID_MENU_CHOOSE])
		return PLUGIN_HANDLED;
	
	//g_seconds[ID_MENU_CHOOSE]--;
	fn_showmenu_choose(ID_MENU_CHOOSE, 0/*g_seconds[ID_MENU_CHOOSE]*/);
	
	return PLUGIN_HANDLED;
}
public MENU_ChoosePlayer(id, menu, item)
{
	if(!is_user_connected(id))
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED;
	}
	
	static iMenuDummy;
	player_menu_info(id, iMenuDummy, iMenuDummy, g_menu_page[id]);
	
	if(item == MENU_EXIT || !g_mix)
	{ 
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	} 
	
	new sData[6];
	new sName[64];
	new iAccess;
	new iCallBack;
	new iSelected;
	
	menu_item_getinfo(menu, item, iAccess, sData, charsmax(sData), sName, charsmax(sName), iCallBack);
	
	if(equal(sName, "ELEGIR AL AZAR"))
	{
		new i;
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(is_user_connected(i) && g_ready[i] && get_user_team(i) == 3)
			{
				g_turn[id] = 0;
				remove_task(id + TASK_MENU_CHOOSE);
				
				if((get_user_team(id) == 1 && fn_get_ts(0) == 5) || (get_user_team(id) == 2 && fn_get_cts(0) == 5))
				{
					CC(id, "!g[MIX]!y No puede haber más de 5 jugadores en tu equipo");
					
					new i;
					for(i = 1; i <= g_maxplayers; i++)
					{
						if(g_captain[i] && get_user_team(i) != get_user_team(id))
						{
							if((fn_get_ts(0) + fn_get_cts(0)) != MIN_PLAYERS)
							{
								g_turn[i] = 1;
								g_seconds[i] = 20;
								fn_showmenu_choose(i, g_seconds[i]);
							}
							else
							{
								g_turn[g_captain_winner] = 1;
								g_seconds[g_captain_winner] = 11;
								g_chosing_team = 1;
								fn_showmenu_teamname(g_captain_winner, g_seconds[g_captain_winner], 1);
							}
							
							break;
						}
					}
				
					return PLUGIN_HANDLED;
				}
				
				CC(0, "!g* %s!y eligió un compañero al azar, se eligió a: !g%s!y", g_playername[id], g_playername[i]);
				
				new iTeam = get_user_team(id);
				new sTeam[2];
				num_to_str(iTeam, sTeam, charsmax(sTeam));
				
				set_pdata_int(i, 125, (get_pdata_int(id, 125, 5) & ~(1<<8)), 5);
				
				engclient_cmd(i, "jointeam", sTeam);
				engclient_cmd(i, "joinclass", "5");
				
				fn_close_menus(i);
				
				remove_task(i + TASK_HUD);
				remove_task(i + TASK_MENU_READY);
				remove_task(i + TASK_READY_REPEAT);
				
				new j;
				for(j = 1; j <= g_maxplayers; j++)
				{
					if(g_captain[j] && get_user_team(j) != get_user_team(id))
					{
						if((fn_get_ts(0) + fn_get_cts(0)) != MIN_PLAYERS)
						{
							g_turn[j] = 1;
							g_seconds[j] = 20;
							fn_showmenu_choose(j, g_seconds[j]);
						}
						else
						{
							g_turn[g_captain_winner] = 1;
							g_seconds[g_captain_winner] = 11;
							g_chosing_team = 1;
							fn_showmenu_teamname(g_captain_winner, g_seconds[g_captain_winner], 1);
						}
						
						break;
					}
				}
				
				break;
			}
		}
		
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	iSelected = str_to_num(sData);
	
	if(!is_user_connected(iSelected))
	{
		CC(id, "!g[MIX]!y El jugador seleccionado no está conectado en el servidor");
		return PLUGIN_HANDLED;
	}
	else if(get_user_team(iSelected) != 3)
	{
		CC(id, "!g[MIX]!y El jugador seleccionado no está de espectador");
		return PLUGIN_HANDLED;
	}
	else if(!g_ready[iSelected])
	{
		CC(id, "!g[MIX]!y El jugador seleccionado no está listo y no puede ser elegido");
		return PLUGIN_HANDLED;
	}
	else if((get_user_team(id) == 1 && fn_get_ts(0) == 5) || (get_user_team(id) == 2 && fn_get_cts(0) == 5))
	{
		g_turn[id] = 0;
		remove_task(id + TASK_MENU_CHOOSE);
		
		CC(id, "!g[MIX]!y No puede haber más de 5 jugadores en tu equipo");
		menu_destroy(menu);
		
		new i;
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(g_captain[i] && get_user_team(i) != get_user_team(id))
			{
				if((fn_get_ts(0) + fn_get_cts(0)) != MIN_PLAYERS)
				{
					g_turn[i] = 1;
					g_seconds[i] = 20;
					fn_showmenu_choose(i, g_seconds[i]);
				}
				else
				{
					g_turn[g_captain_winner] = 1;
					g_seconds[g_captain_winner] = 11;
					g_chosing_team = 1;
					fn_showmenu_teamname(g_captain_winner, g_seconds[g_captain_winner], 1);
				}
				
				break;
			}
		}
	
		return PLUGIN_HANDLED;
	}
	
	CC(0, "!g* %s!y eligió como compañero a !g%s!y", g_playername[id], g_playername[iSelected]);
	
	g_turn[id] = 0;
	remove_task(id + TASK_MENU_CHOOSE);
	
	new iTeam = get_user_team(id);
	new sTeam[2];
	num_to_str(iTeam, sTeam, charsmax(sTeam));
	
	set_pdata_int(iSelected, 125, (get_pdata_int(id, 125, 5) & ~(1<<8)), 5);
	
	engclient_cmd(iSelected, "jointeam", sTeam);
	engclient_cmd(iSelected, "joinclass", "5");
	
	fn_close_menus(iSelected);
	
	remove_task(iSelected + TASK_HUD);
	remove_task(iSelected + TASK_MENU_READY);
	remove_task(iSelected + TASK_READY_REPEAT);
	
	new i;
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(g_captain[i] && get_user_team(i) != get_user_team(id))
		{
			if((fn_get_ts(0) + fn_get_cts(0)) != MIN_PLAYERS)
			{
				g_turn[i] = 1;
				g_seconds[i] = 20;
				fn_showmenu_choose(i, g_seconds[i]);
			}
			else
			{
				g_turn[g_captain_winner] = 1;
				g_seconds[g_captain_winner] = 11;
				g_chosing_team = 1;
				fn_showmenu_teamname(g_captain_winner, g_seconds[g_captain_winner], 1);
			}
			
			break;
		}
	}
	
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public fn_showmenu_teamname(id, seconds, mode)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(seconds == -1 || !g_turn[id])
	{
		fn_close_menus(id);
		return PLUGIN_HANDLED;
	}
	else if(seconds == 0)
	{
		fn_close_menus(id);
		
		switch(mode)
		{
			case 1: MENU_ChooseTeamName(id, random_num(0, 3));
			case 2: MENU_ChooseTeamName(id, random_num(0, 1));
			case 3: MENU_ChooseTeamName(id, random_num(2, 3));
		}
		
		return PLUGIN_HANDLED;
	}
	
	static sMenu[512];
	
	switch(mode)
	{
		case 1: formatex(sMenu, charsmax(sMenu), "\rElige el equipo...: \R\y%d^n1. \wTerrorista^n\y2. \wAnti-Terrorista^n^n\r.. o elige el nombre:^n\y3. \wPUBEROS^n\y4. \wMIXEROS", seconds);
		
		case 2: formatex(sMenu, charsmax(sMenu), "\rElige el equipo...: \R\y%d^n1. \wTerrorista^n\y2. \wAnti-Terrorista^n^n\r.. o elige el nombre:^n\y3. \dPUBEROS^n\y4. \dMIXEROS", seconds);
		
		case 3: formatex(sMenu, charsmax(sMenu), "\rElige el equipo...: \R\y%d^n1. \dTerrorista^n\y2. \dAnti-Terrorista^n^n\r.. o elige el nombre:^n\y3. \wPUBEROS^n\y4. \wMIXEROS", seconds);
	}
	
	show_menu(id, (1 << 0) | (1 << 1) | (1 << 2) | (1 << 3), sMenu, seconds, "Menu_Choose_Team_Name");
	
	remove_task(id + TASK_MENU_CHOOSE_TEAM_NAME);
	set_task(1.0, "fn_showmenu_teamname_repeat", id + TASK_MENU_CHOOSE_TEAM_NAME);
	
	return PLUGIN_HANDLED;
}
public fn_showmenu_teamname_repeat(taskid)
{
	if(!is_user_connected(ID_MENU_CHOOSE_TEAM_NAME))
		return PLUGIN_HANDLED;
	
	if(!g_turn[ID_MENU_CHOOSE_TEAM_NAME])
		return PLUGIN_HANDLED;
	
	g_seconds[ID_MENU_CHOOSE_TEAM_NAME]--;
	fn_showmenu_teamname(ID_MENU_CHOOSE_TEAM_NAME, g_seconds[ID_MENU_CHOOSE_TEAM_NAME], g_mode);
	
	return PLUGIN_HANDLED;
}
public fn_charge_captains(id)
{
	if(!is_user_alive(id))
		return;
	
	cs_set_user_money(id, 0);
	
	strip_user_weapons(id);
	give_item(id, "weapon_knife");
	
	new sMapName[64];
	get_mapname(sMapName, charsmax(sMapName));
	
	new j;
	for(j = 0; j < sizeof(g_MAPS_NAME); j++)
	{
		if(equali(sMapName, g_MAPS_NAME[j]))
		{
			set_pev(id, pev_velocity, Float:{0.0, 0.0, 0.0});
			
			if(cs_get_user_team(id) == CS_TEAM_T) set_pev(id, pev_origin, g_fPOSITION_MAPS_TT[j]);
			else if(cs_get_user_team(id) == CS_TEAM_CT) set_pev(id, pev_origin, g_fPOSITION_MAPS_CT[j]);
		}
	}
}
public fn_message_captains()
{
	switch(g_cmode[0])
	{
		case 1: CC(0, "!g[MIX]!y El capitán !g%s!y ha elegido empezar en el lado terrorista", g_cname[0]);
		case 2: CC(0, "!g[MIX]!y El capitán !g%s!y ha elegido empezar en el lado anti-terrorista", g_cname[0]);
		case 3: CC(0, "!g[MIX]!y El capitán !g%s!y ha elegido el nombre !gPUBEROS!y para su equipo", g_cname[0]);
		case 4: CC(0, "!g[MIX]!y El capitán !g%s!y ha elegido el nombre !gMIXEROS!y para su equipo", g_cname[0]);
	}
	
	switch(g_cmode[1])
	{
		case 1: CC(0, "!g[MIX]!y El capitán !g%s!y ha elegido empezar en el lado terrorista", g_cname[1]);
		case 2: CC(0, "!g[MIX]!y El capitán !g%s!y ha elegido empezar en el lado anti-terrorista", g_cname[1]);
		case 3: CC(0, "!g[MIX]!y El capitán !g%s!y ha elegido el nombre !gPUBEROS!y para su equipo", g_cname[1]);
		case 4: CC(0, "!g[MIX]!y El capitán !g%s!y ha elegido el nombre !gMIXEROS!y para su equipo", g_cname[1]);
	}
}
public fn_kick_for_ta(id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	new sMenu[512];
	new iTeam = get_user_team(id);
	
	formatex(sMenu, charsmax(sMenu), "\rQuieres expulsar a \y%s^n\rpor realizar demasiado daño a sus compañeros?^n^n\y1. \wSi^n\y2. \wNo", g_playername[id]);
	
	new i;
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!is_user_connected(i) || (get_user_team(i) != iTeam) || id == i)
			continue;
		
		show_menu(i, (1 << 0) | (1 << 1), sMenu, -1, "Menu_Kick_For_TA");
	}
	
	set_task(8.0, "fn_check_votes", id);
	
	return PLUGIN_HANDLED;
}
public fn_check_votes(id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	g_votes[1]++;
	
	new i;
	if(g_votes[0] >= g_votes[1])
	{
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(!is_user_connected(i) || (get_user_team(i) != get_user_team(id)))
				continue;
			
			CC(i, "!g[MIX]!y El jugador !g%s!y ha sido expulsado ya que lo han votado demasiadas personas", g_playername[id]);
		}
		
		server_cmd("kick #%d ^"Has sido expulsado por realizar mucho daño a tus compañeros^"", get_user_userid(id));
	}
	else
	{
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(!is_user_connected(i) || (get_user_team(i) != get_user_team(id)))
				continue;
			
			CC(i, "!g[MIX]!y El jugador !g%s!y no ha sido expulsado ya que no lo han votado demasiadas personas", g_playername[id]);
		}
	}
	
	for(i = 1; i <= g_maxplayers; i++)
		if(is_user_connected(i)) fn_close_menus(i);
	
	g_votes = {0, 0};
	
	return PLUGIN_HANDLED;
}
public fn_show_hud_spec(taskid)
{
	if(!g_mix_valid)
		return;
	
	static id;
	id = ID_HUD_SPEC;
	
	if(!is_user_alive(id))
	{
		id = pev(id, pev_iuser2);
		
		if(!is_user_alive(id))
			return;
	}
	
	if(id != ID_HUD_SPEC)
	{
		static name[32];
		static health;
		static armor;
		new Float:accuracy = fn_get_accuracy(id);
		
		get_user_name(id, name, charsmax(name));
		health = get_user_health(id);
		armor = get_user_armor(id);
	
		set_hudmessage(255, 255, 255, 0.01, 0.25, 0, 6.0, 1.1, 0.0, 0.0, -1);
		ShowSyncHudMsg(ID_HUD_SPEC, g_hud3, "Nombre: %s - Vida: %d^nChaleco: %d - Puntería: %0.2f%%", name, health, armor, accuracy);
	}
}
public fn_task_ev()
{
	new i;
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!is_user_connected(i)) continue;
		if(g_round_echoe[i]) continue;
		
		fn_stats_save(i); 
	}
}
public fn_change_map()
{
	server_cmd("changelevel %s", g_nextmap);
}
public fn_play_time(taskid)
{
	g_play_time[ID_PLAY_TIME]++;
}


fn_reset_vars(id)
{
	new i;
	for(i = 0; i < 7; i++)
		g_stats[id][i] = 0;
	
	g_pos[id] = 0;
	g_menu_page[id] = 0;
	g_play_time[id] = 0;
	g_round_echoe[id] = 0;
	g_dmg_ta[id] = 0;
	g_frags[id] = 0;
	g_deaths[id] = 0;
	g_teamid[id] = 0;
	g_turn[id] = 0;
	g_captain[id] = 0;
	g_choosen_no[id] = 0;
	g_seconds[id] = 0;
	g_ready[id] = 0;
	g_stats_cd[id] = 0.00;
	g_stats_page[id] = 0;
	g_iUsed[id] = 0;
}
fn_reset_tasks(id)
{
	remove_task(id);
	remove_task(id + TASK_HUD);
	remove_task(id + TASK_READY_REPEAT);
	remove_task(id + TASK_HUD_REST_FOR_MIX);
	remove_task(id + TASK_MENU_READY);
	remove_task(id + TASK_MENU_CHOOSE);
	remove_task(id + TASK_MENU_CHOOSE_TEAM_NAME);
	remove_task(id + TASK_HUD_SPEC);
	remove_task(id + TASK_PLAY_TIME);
}
fn_start_mix()
{
	server_cmd("amx_cfg cerrado.cfg");
	server_exec();
	
	set_task(0.5, "fn_change_cvars");
	set_cvar_num("sv_restart", 1);
	
	g_mix = 1;
}
fn_start_valid_mix()
{
	g_chosing = 0;
	g_chosing_team = 0;
	g_mix_valid = 1;
	
	set_task(8.0, "fn_message_captains");

	server_cmd("amx_cfg vale.cfg"); // PONGAN UN SOLO sv_restart 1 AL FINAL DE LA CFG, DE LO CONTRARIO VA A ROMPER TODO, PORQUE EN CUANTO EMPIEZA LA PRÓXIMA RONDA YA COMIENZA EL MIX.
	server_cmd("amx_off");
	server_exec();
	
	set_task(0.5, "fn_change_cvars");
}
fn_final_mix(no_results)
{
	g_mix = 0;
	g_mix_valid = 0;
	g_duel = 0;
	g_chosing = 0;
	g_captains_choosen = 0;
	g_count_ready = -1000;
	
	set_cvar_num("sv_restart", 1);
	
	server_cmd("amx_on");
	server_cmd("amx_cfg server.cfg");
	server_exec();
	
	if(no_results)
	{
		new sCurrentMap[64];
		get_mapname(sCurrentMap, charsmax(sCurrentMap));
		
		if(equali(g_nextmap, sCurrentMap))
		{
			while(equali(g_nextmap, sCurrentMap))
				formatex(g_nextmap, charsmax(g_nextmap), "%s", g_MAPS_VALID_NAME[random_num(0, MAX_MAP_VALID)]);
		}
		
		CC(0, "!g[MIX]!y El próximo mapa será !g%s!y", g_nextmap);
		
		set_task(10.0, "fn_change_map");
		
		return;
	}
	
	new iWin = ((g_win_ts + g_score[0]) == MAX_ROUND_FOR_WIN) ? 1 : ((g_win_cts + g_score[1]) == MAX_ROUND_FOR_WIN) ? 2 : 3;
	new iWinScore = (iWin == 1) ? (g_win_ts + g_score[0]) : (iWin == 2) ? (g_win_cts + g_score[1]) : 15;
	new iLooseScore = (iWin == 1) ? (g_win_cts + g_score[1]) : (iWin == 2) ? (g_win_ts + g_score[0]) : 15;
	new sWinner[15];
	new sLooser[15];
	new i;
	new l[2];
	new sName[2][5][32];
	new iFrags[2][5];
	new iDeaths[2][5];
	new iHeads[2][5];
	new iDmg[2][5];
	new iTKs[2][5];
	
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!is_user_connected(i))
			continue;
		
		if(iWin == 3)
		{
			formatex(sWinner, charsmax(sWinner), "MIXEROS");
			formatex(sLooser, charsmax(sLooser), "PUBEROS");
			
			break;
		}
		
		if(get_user_team(i) == iWin)
		{
			formatex(sWinner, charsmax(sWinner), "%s", (g_teamid[i] == 1) ? "PUBEROS" : "MIXEROS");
			formatex(sLooser, charsmax(sLooser), "%s", (g_teamid[i] == 1) ? "MIXEROS" : "PUBEROS");
			
			break;
		}
	}
	
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!is_user_connected(i))
			continue;
		
		if(get_user_team(i) == 0 || get_user_team(i) == 3)
			continue;
		
		if(iWin != 3)
		{
			if(get_user_team(i) == iWin)
			{
				if(l[0] > 4) // No puede haber más de 5 jugadores en un team
					continue;
				
				copy(sName[0][l[0]], charsmax(sName[][]), g_playername[i]);
				iFrags[0][l[0]] = get_user_frags(i);
				iDeaths[0][l[0]] = get_user_deaths(i);
				iHeads[0][l[0]] = g_stats[i][STATS_HS];
				iDmg[0][l[0]] = g_stats[i][STATS_DAMAGE];
				iTKs[0][l[0]] = g_stats[i][STATS_TKS];
				
				l[0]++;
			}
			else
			{
				if(l[1] > 4) // No puede haber más de 5 jugadores en un team
					continue;
				
				copy(sName[1][l[1]], charsmax(sName[][]), g_playername[i]);
				iFrags[1][l[1]] = get_user_frags(i);
				iDeaths[1][l[1]] = get_user_deaths(i);
				iHeads[1][l[1]] = g_stats[i][STATS_HS];
				iDmg[1][l[1]] = g_stats[i][STATS_DAMAGE];
				iTKs[1][l[1]] = g_stats[i][STATS_TKS];
				
				l[1]++;
			}
		}
		else
		{
			if(g_teamid[i] == 2)
			{
				if(l[0] > 4) // No puede haber más de 5 jugadores en un team
					continue;
				
				copy(sName[0][l[0]], charsmax(sName[][]), g_playername[i]);
				iFrags[0][l[0]] = get_user_frags(i);
				iDeaths[0][l[0]] = get_user_deaths(i);
				iHeads[0][l[0]] = g_stats[i][STATS_HS];
				iDmg[0][l[0]] = g_stats[i][STATS_DAMAGE];
				iTKs[0][l[0]] = g_stats[i][STATS_TKS];
				
				l[0]++;
			}
			else
			{
				if(l[1] > 4) // No puede haber más de 5 jugadores en un team
					continue;
				
				copy(sName[1][l[1]], charsmax(sName[][]), g_playername[i]);
				iFrags[1][l[1]] = get_user_frags(i);
				iDeaths[1][l[1]] = get_user_deaths(i);
				iHeads[1][l[1]] = g_stats[i][STATS_HS];
				iDmg[1][l[1]] = g_stats[i][STATS_DAMAGE];
				iTKs[1][l[1]] = g_stats[i][STATS_TKS];
				
				l[1]++;
			}
		}
	}
	
	g_sql_tuple = SQL_MakeDbTuple(SQL_HOST, SQL_USER, SQL_PASS, SQL_TABLE);
	g_sql_connection = SQL_Connect(g_sql_tuple, g_sql_errornum, g_sql_error, 511);
	
	if(g_sql_connection == Empty_Handle)
	{
		log_to_file("mix_sql.txt", "%s", g_sql_error);
		set_task(1.0, "fn_change_map");
		
		return;
	}
	
	static sConsult[4][512];
	formatex(sConsult[0], charsmax(sConsult[]), "INSERT INTO amix_partidos (w_n, l_n, w_p, l_p,\
	w_pj_1, w_pj_1_k, w_pj_1_d, w_pj_1_hs, w_pj_1_dmg, w_pj_1_tks,\
	w_pj_2, w_pj_2_k, w_pj_2_d, w_pj_2_hs, w_pj_2_dmg, w_pj_2_tks,\
	w_pj_3, w_pj_3_k, w_pj_3_d, w_pj_3_hs, w_pj_3_dmg, w_pj_3_tks,\
	w_pj_4, w_pj_4_k, w_pj_4_d, w_pj_4_hs, w_pj_4_dmg, w_pj_4_tks,\
	w_pj_5, w_pj_5_k, w_pj_5_d, w_pj_5_hs, w_pj_5_dmg, w_pj_5_tks, ");
	
	formatex(sConsult[1], charsmax(sConsult[]), "l_pj_1, l_pj_1_k, l_pj_1_d, l_pj_1_hs, l_pj_1_dmg, l_pj_1_tks,\
	l_pj_2, l_pj_2_k, l_pj_2_d, l_pj_2_hs, l_pj_2_dmg, l_pj_2_tks,\
	l_pj_3, l_pj_3_k, l_pj_3_d, l_pj_3_hs, l_pj_3_dmg, l_pj_3_tks,\
	l_pj_4, l_pj_4_k, l_pj_4_d, l_pj_4_hs, l_pj_4_dmg, l_pj_4_tks,\
	l_pj_5, l_pj_5_k, l_pj_5_d, l_pj_5_hs, l_pj_5_dmg, l_pj_5_tks)");
	
	formatex(sConsult[2], charsmax(sConsult[]), " VALUES ('%s', '%s', '%d', '%d',\
	^"%s^", '%d', '%d', '%d', '%d', '%d',\
	^"%s^", '%d', '%d', '%d', '%d', '%d',\
	^"%s^", '%d', '%d', '%d', '%d', '%d',\
	^"%s^", '%d', '%d', '%d', '%d', '%d',\
	^"%s^", '%d', '%d', '%d', '%d', '%d', ", sWinner, sLooser, iWinScore, iLooseScore,
	sName[0][0], iFrags[0][0], iDeaths[0][0], iHeads[0][0], iDmg[0][0], iTKs[0][0],
	sName[0][1], iFrags[0][1], iDeaths[0][1], iHeads[0][1], iDmg[0][1], iTKs[0][1],
	sName[0][2], iFrags[0][2], iDeaths[0][2], iHeads[0][2], iDmg[0][2], iTKs[0][2],
	sName[0][3], iFrags[0][3], iDeaths[0][3], iHeads[0][3], iDmg[0][3], iTKs[0][3],
	sName[0][4], iFrags[0][4], iDeaths[0][4], iHeads[0][4], iDmg[0][4], iTKs[0][4])
	
	formatex(sConsult[3], charsmax(sConsult[]), "^"%s^", '%d', '%d', '%d', '%d', '%d',\
	^"%s^", '%d', '%d', '%d', '%d', '%d',\
	^"%s^", '%d', '%d', '%d', '%d', '%d',\
	^"%s^", '%d', '%d', '%d', '%d', '%d',\
	^"%s^", '%d', '%d', '%d', '%d', '%d');", sName[1][0], iFrags[1][0], iDeaths[1][0], iHeads[1][0], iDmg[1][0], iTKs[1][0],
	sName[1][1], iFrags[1][1], iDeaths[1][1], iHeads[1][1], iDmg[1][1], iTKs[1][1],
	sName[1][2], iFrags[1][2], iDeaths[1][2], iHeads[1][2], iDmg[1][2], iTKs[1][2],
	sName[1][3], iFrags[1][3], iDeaths[1][3], iHeads[1][3], iDmg[1][3], iTKs[1][3],
	sName[1][4], iFrags[1][4], iDeaths[1][4], iHeads[1][4], iDmg[1][4], iTKs[1][4]);
	
	new Handle:sql_consult = SQL_PrepareQuery(g_sql_connection, "%s%s%s%s", sConsult[0], sConsult[1], sConsult[2], sConsult[3]);
	if(!SQL_Execute(sql_consult))
	{
		new sError[512];
		SQL_QueryError(sql_consult, sError, charsmax(sError));
		
		log_to_file("error_sql.txt", "%s", sError);
		
		SQL_FreeHandle(sql_consult);
		SQL_FreeHandle(g_sql_connection);
		SQL_FreeHandle(g_sql_tuple);
		
		set_task(10.0, "fn_change_map");
		
		return;
	}
	
	SQL_FreeHandle(sql_consult);
	SQL_FreeHandle(g_sql_connection);
	SQL_FreeHandle(g_sql_tuple);
	
	new iDateYMD[3];
	new iTimeHMS[3];
	new TTU;
	
	date(iDateYMD[0], iDateYMD[1], iDateYMD[2]);
	time(iTimeHMS[0], iTimeHMS[1], iTimeHMS[2]);
	TTU = time_to_unix(iDateYMD[0], iDateYMD[1], iDateYMD[2], iTimeHMS[0], iTimeHMS[1], iTimeHMS[2]);
	
	new sMenu[512];
	new iLen = 0;
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "http://www.gaminga.com/servidores/counter-strike/automix/mix.php?r=%d", TTU); // Este .php mostraba todos los resultados del mix de forma linda en un motd, no lo tengo más, haganlo a su manera.
	show_motd(0, sMenu, "GAM!NGA");
	
	set_task(25.0, "fn_change_map");
}
fn_reset_mix()
{
	CC(0, "!g[MIX]!y Uno de los capitanes se ha ido cuando estaban eligiendo jugadores. Mix reiniciado");
	CC(0, "!g[MIX]!y Uno de los capitanes se ha ido cuando estaban eligiendo jugadores. Mix reiniciado");
	
	g_mix = 0;
	g_duel = 0;
	g_chosing = 0;
	g_chosing_team = 0;
	g_mode = 1;
	g_captains_choosen = 0;
	g_captain_choosen = {0, 0};
	g_count_mode = 0;
	g_count_ready = 0;
	g_captain_winner = 0;
	
	new i;
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!is_user_connected(i)) continue;
		g_teamid[i] = 0;
		g_seconds[i] = 0;
		g_captain[i] = 0;
		g_turn[i] = 0;
		g_ready[i] = 0;
		g_choosen_no[i] = 0;
		
		remove_task(i + TASK_HUD);
		set_task(0.2, "fn_show_hud", i + TASK_HUD, _, _, "b");
		
		remove_task(i + TASK_READY_REPEAT);
		remove_task(i + TASK_MENU_READY);
		remove_task(i + TASK_MENU_CHOOSE);
		remove_task(i + TASK_MENU_CHOOSE_TEAM_NAME);
		
		if(get_user_team(i) == 3)
		{
			new iTCount = g_players[TEAM_T];
			new iCTCount = g_players[TEAM_CT];
			
			if(iTCount < iCTCount)
			{
				engclient_cmd(i, "jointeam", "1");
				engclient_cmd(i, "joinclass", "5");
				
				fn_close_menus(i);
			}
			else if(iTCount > iCTCount)
			{
				engclient_cmd(i, "jointeam", "2");
				engclient_cmd(i, "joinclass", "5");
				
				fn_close_menus(i);
			}
			else
			{
				new iRandom = random_num(1, 2);
				new sRandom[2];
				num_to_str(iRandom, sRandom, 1);
				
				engclient_cmd(i, "jointeam", sRandom);
				engclient_cmd(i, "joinclass", "5");
				
				fn_close_menus(i);
			}
		}
	}
	
	remove_task(TASK_HUD_REST_FOR_MIX);
	set_task(0.2, "fn_task_hud", TASK_HUD_REST_FOR_MIX, _, _, "b");
}
fn_choose_captains()
{
	g_captains_choosen = 1;
	
	new i;
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(is_user_connected(i) && g_captain[i])
			g_captain[i] = 0;
	}
	
	new g_captain_name[2][32];
	
	new sPlayers[32]
	new iCount;
	new iUser;
	new l = 0;

	get_players(sPlayers, iCount, "ch");
	
	if(!iCount)
		return;
	
	while(l != 2)
	{
		for(i = 0; i < iCount; i++)
		{
			iUser = sPlayers[random_num(0, (iCount-1))];
			
			if(!is_user_connected(iUser))
				continue;
			
			if(g_captain[iUser])
				continue;
			
			if(!g_ready[iUser])
				continue;
			
			if(get_user_team(iUser) == 1 && !g_captain_choosen[0])
			{
				g_captain[iUser] = 1;
				g_captain_choosen[0] = 1;
				
				remove_task(iUser + TASK_HUD);
				
				formatex(g_captain_name[0], charsmax(g_captain_name[]), "%s", g_playername[iUser]);
				
				++l;
			}
			else if(get_user_team(iUser) == 2 && !g_captain_choosen[1])
			{
				g_captain[iUser] = 1;
				g_captain_choosen[1] = 1;
				
				remove_task(iUser + TASK_HUD);
				
				formatex(g_captain_name[1], charsmax(g_captain_name[]), "%s", g_playername[iUser]);
				
				++l;
			}
		}
	}
	
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(is_user_connected(i) && (get_user_team(i) == 1 || get_user_team(i) == 2) && !g_captain[i])
		{
			if(is_user_alive(i))
				dllfunc(DLLFunc_ClientKill, i);
			
			cs_set_team(i, CSTEAM_SPECTATOR);
		}
	}
	
	CC(0, "!g[MIX]!y Los capitanes son: !g%s!y , !g%s!y", g_captain_name[0], g_captain_name[1]);
}
fn_set_teams(team_captain, team_final)
{
	if(team_captain == team_final)
		return;
	
	new i;
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!is_user_connected(i)) continue;
		if(get_user_team(i) == 1)
		{
			cs_set_team(i, CSTEAM_CT);
		}
		else if(get_user_team(i) == 2)
		{
			cs_set_team(i, CSTEAM_TERRORIST);
		}
	}
}
fn_showmenu_for_captain(id, mode)
{
	if(g_count_mode == 2)
	{
		fn_start_valid_mix();
		return;
	}
	
	new i;
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(g_captain[i] && get_user_team(i) != get_user_team(id))
		{
			g_turn[i] = 1;
			g_seconds[i] = 11;
			g_chosing_team = 1;
			fn_showmenu_teamname(i, g_seconds[i], mode);
			
			break;
		}
	}
}
fn_set_names(team_captain, name_final)
{
	new i;
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!is_user_connected(i)) continue;
		if(get_user_team(i) == 0 || get_user_team(i) == 3) continue;
		
		if(get_user_team(i) == team_captain) g_teamid[i] = name_final;
		else g_teamid[i] = (name_final == 1) ? 2 : 1;
	}
}
fn_get_user_premiums_spec()
{
	new iPremiumsSpec = 0;
	new i;
	
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!is_user_connected(i)) continue;
		if((get_user_flags(i) & ADMIN_RESERVATION) && get_user_team(i) == 3 && g_ready[i])
			iPremiumsSpec++;
	}
	
	return iPremiumsSpec;
}
fn_get_user_spec(premium)
{
	new iBest;
	new iPlayers[32];
	new iNum;
	new id;
	new i;
	new iFirst = 0;
	
	get_players(iPlayers, iNum, "e", "SPECTATOR");

	if(!iNum)
		return 0;

	for(i = 0; i < iNum; i++)
	{
		id = iPlayers[i];
		if(!is_user_connected(id)) continue;
		if(get_user_team(id) != 3) continue;
		if(!g_ready[id]) continue;
		
		if(premium)
		{
			if(!(get_user_flags(id) & ADMIN_RESERVATION))
				continue;
		}
		
		if(!iFirst)
		{
			iFirst = 1;
			iBest = id;
		}
		
		if(g_play_time[id] > g_play_time[iBest])
			iBest = id;
	}
	
	return iBest;
}
fn_get_ts(negative)
{
	new iTs = (negative) ? -1 : 0;
	new i;
	
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!is_user_connected(i)) continue;
		if(get_user_team(i) == 1)
			iTs++;
	}
	
	return iTs;
}
fn_get_cts(negative)
{
	new iCTs = (negative) ? -1 : 0;
	new i;
	
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!is_user_connected(i)) continue;
		if(get_user_team(i) == 2)
			iCTs++;
	}
	
	return iCTs;
}
UpdateTeamScores(const bool:notifyAllPlugins = false)
{
	static OrpheuFunction:handleFuncUpdateTeamScores;

	if(!handleFuncUpdateTeamScores)
		handleFuncUpdateTeamScores = OrpheuGetFunction("UpdateTeamScores", "CHalfLifeMultiplay");

	(notifyAllPlugins) ? OrpheuCallSuper(handleFuncUpdateTeamScores, g_pGameRules) : OrpheuCall(handleFuncUpdateTeamScores, g_pGameRules);
}
fn_stats_save(id)
{
	if(!is_user_connected(id) || g_round_echoe[id])
		return;
	
	if(!g_mix_valid)
		return;
	
	g_round_echoe[id] = 1;
	
	new iStats[8];
	new iBody[8];
	
	get_user_rstats(id, iStats, iBody);
	
	new i;
	for(i = 0; i < 7; i++)
		g_stats[id][i] += iStats[i];
}
Float:fn_get_accuracy(id)
{
	if(!is_user_connected(id))
		return 0.0;
	
	new iStats[8];
	new iBody[8];
	new iShots;
	new iHits;
	
	get_user_vstats(id, 0, iStats, iBody);
	
	iShots = g_stats[id][STATS_SHOTS] + iStats[4];
	iHits = g_stats[id][STATS_HITS] + iStats[5];
	
	if(!iShots)
		return 0.0;
	
	return ((100.0 * float(iHits)) / float(iShots));
}
fn_get_user_position(id)
{ 
	new iPosition;
	new i;
	new iPremiumId = (get_user_flags(id) & ADMIN_RESERVATION);
	new iPremiumI;
	
	if(iPremiumId) iPosition = fn_get_user_specs(1) - 1;
	else iPosition = fn_get_user_specs(0) - 1;
	
	for(i = 1; i <= g_maxplayers; i++)
	{ 
		if(!is_user_connected(i)) continue;
		if(get_user_team(i) != 3) continue;
		if(!g_ready[i]) continue;
		if(id == i) continue;
		
		iPremiumI = (get_user_flags(i) & ADMIN_RESERVATION);
		
		if((iPremiumId && !iPremiumI) || (!iPremiumId && iPremiumI)) continue;
		
		if(g_play_time[id] > g_play_time[i])
			iPosition--;
	} 
	
	return iPosition;
}
fn_get_user_specs(premium)
{
	new iSpecs = 0;
	new i;
	
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!is_user_connected(i)) continue;
		if(get_user_team(i) != 3) continue;
		if(!g_ready[i]) continue;
		
		if(premium)
		{
			if((get_user_flags(i) & ADMIN_RESERVATION))
				iSpecs++;
		}
		else
			iSpecs++;
	}
	
	return iSpecs;
}



public message_SendAudio()
{
	if(g_mix_valid)
	{
		static sAudio[32];
		get_msg_arg_string(2, sAudio, charsmax(sAudio));
		
		if(equali(sAudio[7], "terwin"))
		{
			g_win_ts++;
			server_cmd("amx_teamscore T %d", g_score[0] + g_win_ts);
		}
		else if(equali(sAudio[7], "ctwin"))
		{
			g_win_cts++;
			server_cmd("amx_teamscore CT %d", g_score[1] + g_win_cts);
		}
		
		if((((g_win_cts + g_score[1]) == MAX_ROUND_FOR_WIN) || 
		((g_win_ts + g_score[0]) == MAX_ROUND_FOR_WIN) ||
		((g_score[0] + g_win_ts + g_score[1] + g_win_cts) == ROUND_DRAW)) && !g_ab[0])
		{
			g_ab[0] = 1;
			
			new sCurrentMap[64];
			get_mapname(sCurrentMap, charsmax(sCurrentMap));
			
			if(equali(g_nextmap, sCurrentMap))
			{
				while(equali(g_nextmap, sCurrentMap))
					formatex(g_nextmap, charsmax(g_nextmap), "%s", g_MAPS_VALID_NAME[random_num(0, MAX_MAP_VALID)]);
			}
			
			CC(0, "!g[MIX]!y Ha finalizado el mix, cargando estadísticas...");
			CC(0, "!g[MIX]!y El próximo mapa será !g%s!y", g_nextmap);
		}
		
	}
}
public message_ShowMenu(msg_id, msg_dest, id)
{
	static sMenuCode[iMaxLen];
	get_msg_arg_string(4, sMenuCode, charsmax(sMenuCode));
	
	if(equal(sMenuCode, "#Team_Select") || equal(sMenuCode, "#Team_Select_Spect"))
	{
		if(fn_should_autojoin(id))
		{
			fn_set_autojoin_task(id, msg_id);
			return PLUGIN_HANDLED;
		}
	}
	return PLUGIN_CONTINUE;
}
public message_VGUIMenu(msg_id, msg_dest, id)
{
	if(get_msg_arg_int(1) != 2)
		return PLUGIN_CONTINUE;
	
	if(fn_should_autojoin(id))
	{
		fn_set_autojoin_task(id, msg_id);
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_CONTINUE;
}

public Message_TextMsg(const msgid, const MSG_DEST, const id)
{ 
	if(MSG_DEST == MSG_ONE)
	{
		if(!is_user_alive(id))
		{
			if(get_msg_arg_int(1) == 4)
			{
				static szMessage[35];
				get_msg_arg_string(2, szMessage, 34);
				
				if(equal(szMessage, "#Spec_Mode3"))
				{
					client_cmd(id, "spec_mode 4");
					return PLUGIN_HANDLED;
				}
			}
		}
	}
	
	return PLUGIN_CONTINUE;
}


stock CC(const Index, const input[], any:...)
{
	static i_Count; i_Count = 1;
	static sz_Players[32];
	static sz_Msg[191];
	
	vformat(sz_Msg, charsmax(sz_Msg), input, 3);
	
	replace_all(sz_Msg, charsmax(sz_Msg), "!y" , "^1");
	replace_all(sz_Msg, charsmax(sz_Msg), "!t" , "^3");
	replace_all(sz_Msg, charsmax(sz_Msg), "!g" , "^4");
	
	if(Index) sz_Players[0] = Index;
	else get_players(sz_Players, i_Count, "ch");
	
	for(new i = 0; i < i_Count; i++)
	{
		if(is_user_connected(sz_Players[i]))
		{
			message_begin(MSG_ONE_UNRELIABLE, g_messageid_saytext, _, sz_Players[i]);
			write_byte(sz_Players[i]);
			write_string(sz_Msg);
			message_end();
		}
	}
}
stock bool:fn_should_autojoin(id)
	return (is_user_connected(id) && !(TEAM_NONE < g_team[id] < TEAM_SPEC) && !task_exists(id));
stock fn_set_autojoin_task(id, msg_id)
{
	new iParam[2];
	iParam[0] = msg_id;
	
	set_task(0.1, "fn_task_autojoin", id, iParam, sizeof(iParam));
}
stock fn_get_new_team()
{
	new iTCount = g_players[TEAM_T];
	new iCTCount = g_players[TEAM_CT];
	
	if((g_mix || g_count_ready >= MIN_PLAYERS) &&
	((iTCount >= MIN_PLAYERS_HALF && iCTCount >= MIN_PLAYERS_HALF)
	|| g_duel ||
	(g_chosing && !g_chosing_team)))
		return TEAM_SPEC;
	
	if(iTCount < iCTCount) return TEAM_T;
	else if(iTCount > iCTCount) return TEAM_CT;
	else return random_num(TEAM_T, TEAM_CT);
	
	return TEAM_SPEC;
}
stock fn_handle_join(id, msg_id, team)
{
	new iMsgBlock = get_msg_block(msg_id);
	set_msg_block(msg_id, BLOCK_SET);
	
	if(!team)
		team = TEAM_SPEC;
	
	engclient_cmd(id, "jointeam", g_sTeamNums[team]);
	
	new iClass = fn_get_team_class(team);
	if(1 <= iClass <= 4)
	{
		if(g_mix_valid)
		{
			remove_task(id + TASK_HUD);
			remove_task(id + TASK_MENU_READY);
		}
		
		engclient_cmd(id, "joinclass", g_sClassNums[iClass - 1]);
		fn_close_menus(id);
	}
	
	set_msg_block(msg_id, iMsgBlock);
	
	new CsTeams:iCS = cs_get_user_team(id);
	new iGET = get_user_team(id);
	new iOFF;
	
	if(pev_valid(id) != 2)
		iOFF = -1;
	
	iOFF = get_pdata_int(id, 114, 5);
	
	if(!iCS && !iGET && !iOFF)
	{
		set_pdata_int(id, 125, (get_pdata_int(id, 125, 5) & ~(1<<8)), 5);
		
		engclient_cmd(id, "jointeam", g_sTeamNums[TEAM_SPEC]);
	}
}
stock fn_get_team_class(team)
{
	new iClass;
	if(TEAM_NONE < team < TEAM_SPEC)
		iClass = random_num(1, 4);
	
	return iClass;
}

public fn_change_team_info(id, team[])
{
	message_begin(MSG_ONE, g_messageid_teaminfo, _, id);
	write_byte(id);
	write_string(team);
	message_end();
}

stock fn_CC(id, COLOR=DONT_CHANGE, fmt[], any:...)
{
	new szMsg[192]
	szMsg[0] = 0x04
	vformat(szMsg[1], charsmax(szMsg)-1, fmt, 4)
	
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

public clcmd_Block__NoMix(const id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(g_mix && !g_mix_valid)
		return PLUGIN_HANDLED;
	
	return PLUGIN_CONTINUE;
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

public startMIX()
{
	if(g_count_ready >= MIN_PLAYERS && !g_mix)
	{
		CC(0, "!g[MIX]!y Eligiendo capitanes...");
		fn_start_mix();
	}
}