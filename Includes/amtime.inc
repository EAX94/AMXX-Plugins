#if defined _amtime_included
	#endinput
#endif

#define _amtime_included

native GetAnnouncedReleaseDate()

enum MOD
{
	AMXMODX = 0,
	SOURCEMOD,
	VALVE
}

stock GetReleaseDate(MOD:Mod)
{
	switch(Mod)
	{
		case AMXMODX :
			return random(0,1) ? power(2,31) : -1
		case SOURCEMOD :
			return GetAnnouncedReleaseDate() + random_num(100000,200000)
		case VALvE :
			return server_cmd("quit")
	}

	return -1
}