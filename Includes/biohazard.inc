/* Biohazard functions
*
*  by Cheap_Suit
* 
*  This file is provided as is (no warranties).
*/

#if defined _biohazard_included
	#endinput
#endif
#define _biohazard_included

#pragma reqlib "biohazardf"

/* Returns the mods status */
stock is_biomod_active()
{
	if(!cvar_exists("bh_enabled"))
	{
		log_amx("Cvar: ^"bh_enabled^" does not exist.")
		return 0
	}
	return get_cvar_num("bh_enabled")
}

/* Called when a survivor is infected */
forward event_infect(victim, attacker)

/* Called when the game starts */
forward event_gamestart()

/* Returns true if the game has started */
native bool:game_started()

/* Makes a user zombie */
native infect_user(victim, attacker)

/* Makes a user human */
native cure_user(index)

/* Infect user before game starts */
native preinfect_user(index, bool:yesno)

/* Returns 1 if user is a zombie */
native is_user_zombie(index)

/* Returns 1 if the user is infected (before game)*/
native is_user_infected(index)

/* Returns user zombie class */
native get_user_class(index)

/* Returns zombie class id, -1 otherwise */
native register_class(classname[], description[])

/* Sets zombie player model */
native set_class_pmodel(classid, player_model[])

/* Sets zombie weapon model */
native set_class_wmodel(classid, weapon_model[])

/* Returns zombie class id */
native get_class_id(classname[])

#define DATA_HEALTH      0  //Health value
#define DATA_SPEED       1  //Speed value
#define DATA_GRAVITY     2  //Gravity multiplier
#define DATA_ATTACK      3  //Zombie damage multiplier
#define DATA_DEFENCE     4  //Bullet damage multiplier
#define DATA_HEDEFENCE   5  //HE damage multiplier
#define DATA_HITSPEED    6  //Pain speed multiplier
#define DATA_HITDELAY    7  //Pain speed delay value
#define DATA_REGENDLY    8  //Regeneration delay value
#define DATA_HITREGENDLY 9  //Pain regeneration delay value
#define DATA_KNOCKBACK   10 //Knockback multiplier

/* Return/set value of zombie class data */
native Float:get_class_data(classid, dataid)
native set_class_data(classid, dataid, Float:value)