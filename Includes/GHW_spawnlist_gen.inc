/* GHW Spawnlist Generator - v1.0
*
* by GHW_Chronic
*   06/2008 - 08/2008
*
* This file is provided as is (no warranties).
*
*
*
*
*	//This fills in the array (Float:origins[MAX_ORIGINS][3])
*	//Methods: 1=Normal 2=Extensive 3=Exhaustive
*	//num_origins - number of origins to find (Max is MAX_ORIGINS)
*	genspawnlist(method,num_origins)
*
*	//This checks to see if a player is inside the map (Some maps may give broken random spawn points)
*	In_Map(id)
*
*	//This stops the current search
*	save_locations()
*
*
*	Tests (Windows - AMD 64-bit 2.6 Ghz Dual-Core Processor):
*
*	Map		Method		# Found		Time (sec)	# Broken
*	de_dust2	1		27		60		0
*	de_dust2	2		30		93		0
*	de_dust2	3		30		97		0
*	de_train	1		20		60		1
*	de_train	2		30		70		0
*	de_train	3		30		120		0
*	de_nuke		1		30		41		0
*	de_nuke		2		30		65		0
*	de_nuke		3		30		122		0
*
*
*
*/

#if defined _GHW_spawnlist_gen_included
  #endinput
#endif
#define _GHW_spawnlist_gen_included



//Number of origins to find
#define MAX_ORIGINS	30





#include <amxmodx>
#include <fakemeta>

//Suggested that you figure out what these do before changing
#define MIN_DISTANCE		300.0

#define TIMEOUT			60.0
#define TIMEOUT_EXTENSIVE	120.0
#define TIMEOUT_EXHAUSTIVE	300.0

#define XY_RANGE		1250.0
#define Z_RANGE			200.0

#define XY_RANGE_EXTENSIVE	2000.0
#define Z_RANGE_EXTENSIVE	500.0

#define XY_RANGE_EXHAUSTIVE	2000.0
#define Z_RANGE_EXHAUSTIVE	750.0

#define CONSTANT_ENTITY1	"info_player_deathmatch"
#define CONSTANT_ENTITY2	"info_player_start"

new Float:max_origin[3]
new Float:min_origin[3]
new Float:origins[MAX_ORIGINS][3]

static const Float:max_size[3] = {16.0,16.0,36.0}
static const Float:min_size[3] = {-16.0,-16.0,-36.0}
static const Float:size[6] = {-16.0,-16.0,-36.0,16.0,16.0,36.0}

new num_origins, num_find_origins, j
new test_ent

new Float:starttime
new Float:timelimit

public In_Map(id)
{
	new Float:llevel
	pev(id,pev_light_level,llevel)

	if(!llevel)
		return 0;
	return 1;
}

public genspawnlist(method,num_origins_to_find)
{
	if(starttime)
	{
		return ;
	}

	num_find_origins = num_origins_to_find
	if(num_find_origins>MAX_ORIGINS) num_find_origins = MAX_ORIGINS

	starttime = get_gametime()

	test_ent = engfunc(EngFunc_CreateNamedEntity,engfunc(EngFunc_AllocString,"info_target"))
	set_pev(test_ent,pev_classname,"Origin_Finder")
	set_pev(test_ent,pev_movetype,MOVETYPE_FLY)
	set_pev(test_ent,pev_solid,SOLID_BBOX)
	set_pev(test_ent,pev_maxs,max_size)
	set_pev(test_ent,pev_mins,min_size)
	set_pev(test_ent,pev_size,size)
	engfunc(EngFunc_SetSize,test_ent,min_size,max_size)

	switch(method)
	{
		case 2:
		{
			timelimit = TIMEOUT_EXTENSIVE + starttime
			find_minmax(XY_RANGE_EXTENSIVE,Z_RANGE_EXTENSIVE)
		}
		case 3:
		{
			timelimit = TIMEOUT_EXHAUSTIVE + starttime
			find_minmax(XY_RANGE_EXHAUSTIVE,Z_RANGE_EXHAUSTIVE)
		}
		default:
		{
			timelimit = TIMEOUT + starttime
			find_minmax(XY_RANGE,Z_RANGE)
		}
	}

	if(max_origin[0]>4800.0) max_origin[0] = 4800.0
	if(min_origin[0]<-4800.0) min_origin[0] = 4800.0
	if(max_origin[1]>4800.0) max_origin[1] = 4800.0
	if(min_origin[1]<-4800.0) min_origin[1] = 4800.0
	if(max_origin[2]>4800.0) max_origin[2] = 4800.0
	if(min_origin[2]<-4800.0) min_origin[2] = 4800.0

	num_origins = 0
	find_location()

	return ;
}

public find_minmax(Float:xyrange,Float:zrange)
{
	max_origin[0] = 1337.1337

	new ent = engfunc(EngFunc_FindEntityByString,0,"classname",CONSTANT_ENTITY1)
	if(ent)
	{
		new Float:origin[3]
		pev(ent,pev_origin,origin)
		max_origin[0] = origin[0] + xyrange
		min_origin[0] = origin[0] - xyrange
		max_origin[1] = origin[1] + xyrange
		min_origin[1] = origin[1] - xyrange
		max_origin[2] = origin[2] + zrange
		min_origin[2] = origin[2] - zrange
	}

	ent = engfunc(EngFunc_FindEntityByString,0,"classname",CONSTANT_ENTITY2)
	if(ent)
	{
		new Float:origin[3]
		pev(ent,pev_origin,origin)
		if(max_origin[0] != 1337.1337)
		{
			max_origin[0] = (max_origin[0] + origin[0] + xyrange) / 2
			min_origin[0] = (min_origin[0] + origin[0] - xyrange) / 2
			max_origin[1] = (max_origin[1] + origin[1] + xyrange) / 2
			min_origin[1] = (min_origin[1] + origin[1] - xyrange) / 2
			max_origin[2] = (max_origin[2] + origin[2] + zrange) / 2
			min_origin[2] = (min_origin[2] + origin[2] - zrange) / 2
		}
		else
		{
			max_origin[0] = origin[0] + xyrange
			min_origin[0] = origin[0] - xyrange
			max_origin[1] = origin[1] + xyrange
			min_origin[1] = origin[1] - xyrange
			max_origin[2] = origin[2] + zrange
			min_origin[2] = origin[2] - zrange
		}
	}
}

public find_location()
{
	origins[num_origins][0] = random_float(min_origin[0],max_origin[0])
	origins[num_origins][1] = random_float(min_origin[1],max_origin[1])
	origins[num_origins][2] = random_float(min_origin[2],max_origin[2])
	for(j=0;j<num_origins;j++)
	{
		if(floatsqroot(((origins[num_origins][0] - origins[j][0]) * (origins[num_origins][0] - origins[j][0])) + ((origins[num_origins][1] - origins[j][1]) * (origins[num_origins][1] - origins[j][1])))<MIN_DISTANCE)
		{
			find_location()
			return ;
		}
	}

	if(get_gametime()>timelimit)
	{
		save_locations()
		return ;
	}

	engfunc(EngFunc_SetOrigin,test_ent,origins[num_origins])
	set_pev(test_ent,pev_velocity,Float:{0.0,0.0,0.0})
	engfunc(EngFunc_DropToFloor,test_ent)

	set_task(0.1,"check_location")

	return ;
}

public check_location()
{
	static Float:origin[3]
	pev(test_ent,pev_origin,origin)
	origins[num_origins][2] = origin[2]

	origin[2] += 10.0
	set_pev(test_ent,pev_origin,origin)
	set_pev(test_ent,pev_velocity,Float:{0.0,0.0,-2000.0})

	set_task(0.1,"check_location2")
}

public check_location2()
{
	static Float:origin[3]
	pev(test_ent,pev_origin,origin)
	if(origins[num_origins][2] == origin[2])
	{
		num_origins++
	}

	if(num_origins<num_find_origins) find_location()
	else save_locations()
}

public save_locations()
{
	server_print("[AMXX] Found %d spawn locations in %f seconds.",num_origins,get_gametime() - starttime)
	starttime = 0.0
	timelimit = 0.0
	engfunc(EngFunc_RemoveEntity,test_ent)
	test_ent = 0
}