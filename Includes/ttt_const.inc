#if defined _ttt_const_included
  #endinput
#endif
#define _ttt_const_included

#if AMXX_VERSION_NUM < 183
	#define client_print_color client_print
	#define print_team_default print_chat
	#define print_team_grey print_chat
	#define print_team_red print_chat
	#define print_team_blue print_chat
	#define print_team_green print_chat

	stock HamHook:RegisterHamPlayer(Ham:function, const Callback[], Post=0)
		return RegisterHam(function, "player", Callback, Post);

	#if defined _fakemeta_included
		#define write_coord_f(%0) engfunc(EngFunc_WriteCoord, %0)
		stock message_begin_f(dest, msg_type, const Float:origin[3] = {0.0,0.0,0.0}, player=0)
			engfunc(EngFunc_MessageBegin, dest, msg_type, origin, player);
	#endif
#endif

#define TTT_VERSION_INT		250
#define TTT_VERSION			"2.5.0"
#define TTT_AUTHOR			"GuskiS"
#define TTT_TAG				"^3[^4TTT^3]^1"

#define TTT_DEADBODY		"ttt_dead_body"
#define TTT_HPSTATION		"ttt_hp_station"
#define TTT_DEATHSTATION	"ttt_death_station"
#define TTT_C4_SUB			"ttt_c4_subent"

#define TTT_ITEMLENGHT		64 // Max length of items name.
#define TTT_FILELENGHT		64 // Max length of files name.
#define TTT_MAXSHOP			25 // Max items in shop.
#define TTT_MAXBACKPACK		20 // Max items in backpack.
#define TTT_SETTINGSFILE	"ttt_mod.ini"
#define TTT_CONFIGFILE		"ttt_mod.cfg"

#pragma semicolon 1

stock const g_iTeamColors[][] =
{
	{0, 255, 0},
	{255, 50, 0},
	{0, 50, 255},
	{0, 255, 0},
	{0, 255, 0},
	{0, 0, 0}
};

enum _:PLAYER_STATS
{
	STATS_GWK,			// Game winning kills
	STATS_KILLS_I,		// Kills as Innocent // Right ones
	STATS_KILLS_D,		// Kills as Detective
	STATS_KILLS_T,		// Kills as Traitor
	STATS_RDM,			// Team kills
	STATS_INN,			// Times innocent
	STATS_DET,			// Times detective
	STATS_TRA,			// Times traitor
	STATS_BOMBP,		// Bomb planted
	STATS_BOMBE,		// Bomb exploded
	STATS_BOMBD,		// Bomb defused
	STATS_POINTS		// Total points
}

enum _:LOG_MESSAGES(<<= 1)
{
	LOG_DEFAULT = 1,
	LOG_ERROR,
	LOG_GAMETYPE,
	LOG_ITEM,
	LOG_KILL,
	LOG_DAMAGE,
	LOG_MISC
}

enum _:BODY_DATA
{
	BODY_TIME,		// DNA active time
	BODY_KILLER,	// ID who killed
	BODY_TRACER,	// ID who is tracing killer
	BODY_ACTIVE,	// Is actually tracing happening
	BODY_ENTID,		// Bodies entid
	BODY_CALLD		// Does this body calls Detective to inspect it?
}

enum _:SETUP_DATA
{
	SETUP_ITEMID,		// Item ID obviously
	SETUP_ITEMENT,		// Set up items entid
	SETUP_ITEMTIME,		// Time for DNA, I think
	SETUP_ITEMOWNER,	// Items owner ID
	SETUP_ITEMTRACER,	// Tracers ID
	SETUP_ITEMACTIVE,	// Is tracing active
	SETUP_ITEMNAME[TTT_ITEMLENGHT]	// Items name
}

enum _:PLAYER_DATA
{
	PD_KILLEDBY,		// Killers ID
	PD_KILLEDWEAP,		// Weapons ID
	PD_KILLEDTIME,		// Some time, get_roundtime I guess
	PD_KILLEDSTATE,		// Killed state
	PD_KILLEDDEATHS,	// Players death count
	PD_KILLCOUNT,		// Players kill count
	PD_IDENTIFIED,		// Is he identified?
	PD_KARMA,			// Players karma, the one used in damge calculations
	PD_KARMATEMP,		// Temporary karma, the one actually being changed all the time
	PD_CREDITS,			// Players credits
	PD_C4EXPLODED,		// Did he explode C4 :O
	PD_SCOREBOARD,		// Holds info about scoreboard (1 means cant change)
	PD_PLAYERSTATE,		// Why the fuck is this last one? ;o
	PD_KILLEDBYITEM,	// If killed by item, stores that item ID
	PD_HOLDINGITEM,		// Is holding any item?
	PD_ITEMSTATE,		// If is holding item, what state this item has?
	PD_HIDENAME			// Should his name be hidden?
}

enum _:PLAYER_CLASS
{
	PC_NONE,
	PC_TRAITOR,
	PC_DETECTIVE,
	PC_INNOCENT,
	PC_DEAD,
	PC_SPECIAL
}

enum _:GAME_MODE
{
	GAME_UNSET,
	GAME_OFF,
	GAME_PREPARING,
	GAME_RESTARTING,
	GAME_STARTED,
	GAME_ENDED
}

enum _:GLOBAL_INFO
{
	GI_GAMEMODE
}

enum _:PLAYER_DEATHS(+= 1)
{
	DEATHS_SUICIDE = 3000,
	DEATHS_GENERIC,
	DEATHS_SLASH,
	DEATHS_BURN,
	DEATHS_FREEZE,
	DEATHS_FALL,
	DEATHS_BLAST,
	DEATHS_SHOCK,
	DEATHS_DROWN,
	DEATHS_NERVEGAS,
	DEATHS_POISON,
	DEATHS_RADIATION,
	DEATHS_ACID
}

enum _:TTT_WARNINGS
{
	WARN_SPECIAL,
	WARN_INNOCENT,
	WARN_CONTINUED,
	WARN_BANNED,
	WARN_PUNISH,
	WARN_BADAIM
}

enum _:BOMB_STATUS
{
	BS_PLANTED,
	BS_DEFUSED,
	BS_FAILED,
	BS_BOMBED
}