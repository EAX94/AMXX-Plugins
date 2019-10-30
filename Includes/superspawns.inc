#if defined _superspawns_included
  #endinput
#endif
#define _superspawns_included

#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <engine>
#include <cellarray>
#include <xs>

#define SS_MIN_DISTANCE	500.0
#define SS_MAX_LOOPS	100000

new Array:g_vecSsOrigins
new Array:g_vecSsSpawns
new Array:g_vecSsUsed
new Float:g_flSsMinDist
new g_iSsTime

new const g_szStarts[][] = { "info_player_start", "info_player_deathmatch" }
new const Float:g_flOffsets[] = { 3500.0, 3500.0, 1500.0 }

public SsInit(Float:mindist)
{
	new cmd[32]
	format(cmd, 15, "_ss_dump%c%c%c%c", random_num('A', 'Z'), random_num('A', 'Z'), random_num('A', 'Z'), random_num('A', 'Z'))
	register_concmd(cmd, "SsDump")

	g_flSsMinDist = mindist
	g_vecSsOrigins = ArrayCreate(3, 1)
	g_vecSsSpawns = ArrayCreate(3, 1)
	g_vecSsUsed = ArrayCreate(3, 1)
}

stock SsClean()
{
	g_flSsMinDist = 0.0
	ArrayClear(g_vecSsOrigins)
	ArrayClear(g_vecSsSpawns)
	ArrayClear(g_vecSsUsed)
}

stock SsGetOrigin(Float:origin[3])
{
	new Float:data[3], size
	new ok = 1

	while((size = ArraySize(g_vecSsOrigins)))
	{
		new idx = random_num(0, size - 1)

		ArrayGetArray(g_vecSsOrigins, idx, origin)

		new used = ArraySize(g_vecSsUsed)
		for(new i = 0; i < used; i++)
		{
			ok = 0
			ArrayGetArray(g_vecSsUsed, i, data)
			if(get_distance_f(data, origin) >= g_flSsMinDist)
			{
				ok = 1
				break
			}
		}

		ArrayDeleteItem(g_vecSsOrigins, idx)
		if(ok)
		{
			ArrayPushArray(g_vecSsUsed, origin)
			return true
		}
	}
	return false
}

public SsDump()
{
	new Float:origin[3]
	new count = ArraySize(g_vecSsOrigins)
	server_print("-------------------------------------------------------")
	for(new i = 0; i < count; i++)
	{
		ArrayGetArray(g_vecSsOrigins, i, origin)
		server_print("Origin: %f %f %f", origin[0], origin[1], origin[2])
	}
	server_print("-------------------------------------------------------")
	server_print("Number of origins: %i", count)
	server_print("Time: %i", g_iSsTime)
	server_print("-------------------------------------------------------")
}

public SsScan()
{
	new start, Float:origin[3], starttime
	starttime = get_systime()
	for(start = 0; start < sizeof(g_szStarts); start++)
	{
		server_print("Searching for %s", g_szStarts[start])
		new ent
		if((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", g_szStarts[start])))
		{
			new counter
			pev(ent, pev_origin, origin)
			ArrayPushArray(g_vecSsSpawns, origin)
			while(counter < SS_MAX_LOOPS)
			{
				counter = GetLocation(origin, counter)
			}
		}
	}
	g_iSsTime = get_systime()
	g_iSsTime -= starttime
}

GetLocation(Float:start[3], &counter)
{
	new Float:end[3]
	for(new i = 0; i < 3; i++)
	{
		end[i] += random_float(0.0 - g_flOffsets[i], g_flOffsets[i])
	}

	if(IsValid(start, end))
	{
		start[0] = end[0]
		start[1] = end[1]
		start[2] = end[2]
		ArrayPushArray(g_vecSsOrigins, end)
	}
	counter++
	return counter
}

IsValid(Float:start[3], Float:end[3])
{
	SetFloor(end)
	end[2] += 36.0
	new point = engfunc(EngFunc_PointContents, end)
	if(point == CONTENTS_EMPTY)
	{
		if(CheckPoints(end) && CheckDistance(end) && CheckVisibility(start, end))
		{
			if(!trace_hull(end, HULL_LARGE, -1))
			{
				return true
			}
		}
	}
	return false
}

CheckVisibility(Float:start[3], Float:end[3])
{
	new tr
	engfunc(EngFunc_TraceLine, start, end, IGNORE_GLASS, -1, tr)
	return (get_tr2(tr, TR_pHit) < 0)
}

SetFloor(Float:start[3])
{
	new tr, Float:end[3]
	end[0] = start[0]
	end[1] = start[1]
	end[2] = -99999.9
	engfunc(EngFunc_TraceLine, start, end, DONT_IGNORE_MONSTERS, -1, tr)
	get_tr2(tr, TR_vecEndPos, start)
}

CheckPoints(Float:origin[3])
{
	new Float:data[3], tr, point
	data[0] = origin[0]
	data[1] = origin[1]
	data[2] = 99999.9
	engfunc(EngFunc_TraceLine, origin, data, DONT_IGNORE_MONSTERS, -1, tr)
	get_tr2(tr, TR_vecEndPos, data)
	point = engfunc(EngFunc_PointContents, data)
	if(point == CONTENTS_SKY && get_distance_f(origin, data) < 250.0)
	{
		return false
	}
	data[2] = -99999.9
	engfunc(EngFunc_TraceLine, origin, data, DONT_IGNORE_MONSTERS, -1, tr)
	get_tr2(tr, TR_vecEndPos, data)
	point = engfunc(EngFunc_PointContents, data)
	if(point < CONTENTS_SOLID)
		return false
	
	return true
}

CheckDistance(Float:origin[3])
{
	new Float:dist, Float:data[3]
	new count = ArraySize(g_vecSsSpawns)
	for(new i = 0; i < count; i++)
	{
		ArrayGetArray(g_vecSsSpawns, i, data)
		dist = get_distance_f(origin, data)
		if(dist < SS_MIN_DISTANCE)
			return false
	}

	count = ArraySize(g_vecSsOrigins)
	for(new i = 0; i < count; i++)
	{
		ArrayGetArray(g_vecSsOrigins, i, data)
		dist = get_distance_f(origin, data)
		if(dist < SS_MIN_DISTANCE)
			return false
	}

	return true
}
