/* Fun Stock functions
*
* by Mel
*
* This file is provided as is (no warranties).
*/

#if defined _fun_included
  #endinput
#endif
#define _fun_included

#if defined _fakemeta_included
#else
#include <fakemeta>
#endif

#define set_client_listening(%1,%2,%3) engfunc(EngFunc_SetClientListening,%1,%2,%3)

#define get_client_listening(%1,%2) engfunc(EngFunc_GetClientListening,%1,%2)

#define set_user_godmode(%1,%2) set_pev(%1,pev_takedamage,%2*2)

#define get_user_godmode(%1) (pev(%1,pev_takedamage) )

#define get_user_health(%1) pev(%1,pev_health)

#define set_user_health(%1,%2) set_pev(%1,pev_health,%2)

#define get_user_frags(%1) pev(%1,pev_frags)

#define set_user_frags(%1,%2) set_pev(%1,pev_frags,%2)

#define get_user_armor(%1) pev(%1,pev_armorvalue)

#define set_user_armor(%1,%2) set_pev(%1,pev_armorvalue,%2)

#define set_user_origin(%1,%2) engfunc(EngFunc_SetOrigin,%1,%2)

#define get_user_maxspeed(%1) pev(%1,pev_maxspeed)

#define set_user_maxspeed(%1,%2) set_pev(%1,pev_maxspeed,%2)

#define get_user_gravity(%1) pev(%1,pev_gravity)

#define set_user_gravity(%1,%2) set_pev(%1,pev_gravity,%2)

#define get_user_noclip(%1) (pev(%1,pev_movetype) == 8)

stock set_user_noclip(id,num) {
	if(num) set_pev(id,pev_movetype,8)
	else set_pev(id,pev_movetype,3)
	
	return 1;
}

#define get_user_footsteps(%1) pev(%1,pev_flTimeStepSound)

stock set_user_footsteps(id,num) {
	if(num) set_pev(id,pev_flTimeStepSound,999)
	else set_pev(id,pev_flTimeStepSound,2)
	
	return 1;
}

#define spawn(%1) dllfunc(DLLFunc_Spawn,%1)


stock strip_user_weapons(id){
	new trigger = engfunc(EngFunc_CreateNamedEntity,"trigger_once")
	if(!trigger) return 0;

	set_pev(trigger,pev_target,"stripper")
	dllfunc(DLLFunc_Spawn,trigger)

	new stripper = engfunc(EngFunc_CreateNamedEntity,"player_weaponstrip")
	if(!stripper) return 0;

	set_pev(stripper,pev_targetname,"stripper")
	dllfunc(DLLFunc_Spawn,stripper)
	
	new Float:origin[3]
	pev(id,pev_origin,origin)
	set_pev(trigger,pev_origin,origin)

	dllfunc(DLLFunc_Touch,id,trigger)

	engfunc(EngFunc_RemoveEntity,trigger)
	engfunc(EngFunc_RemoveEntity,stripper)

	return 1;
}

stock set_user_rendering(id, fx = kRenderFxNone, r = 255, g = 255, b = 255, render = kRenderNormal, amount = 16) {
	new Float:color[3]
	color[0] = Float:r
	color[1] = Float:g
	color[2] = Float:b

	set_pev(id,pev_renderfx,fx)
	set_pev(id,pev_rendercolor,color)
	set_pev(id,pev_rendermode,render)
	set_pev(id,pev_renderamt,amount)

	return 1;
}