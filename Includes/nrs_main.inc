/* Npc Register System functions
*
*  by Good_Hash
*
*  This file is provided as is (no warranties).
*/

#if defined _nrs_main_included
	#endinput
#endif
#define _nrs_main_included

//#pragma reqlib "npc_register_system"

/* Called when a survivor kills npc */
forward event_npc_death(dead_ent, killer)

/* Called when npc loses casting range */
forward event_npc_casting_outrange(ent_id)

/* Called when npc reaches 150.0 units to owner */
forward event_npc_casting_range(npc_id, owner_id, Float:distance)

forward event_missile_catch(ent, owner, target)
forward event_hook_catch(npc_id, target_id, Float:distance)

/* Called when npc is damaged */
forward event_npc_damage(npc_id, attacker_id, Float:damage)

/* Called when npc is going to attack */
forward event_npc_damage_start(npc_id)

/* Called when npc damage is done after attack animation */
forward event_npc_damage_delayed(npc_id)


/* Called when a survivor is infected */
forward event_npc_init(ent_id)

/* Called when npc kills a player */
forward event_npc_kills(ent_id, target)


/* Called when the game starts */
forward event_gamestarted()

/* Called when the round ends */
forward event_round_ended()

/* Returns true if the game has started */
native bool:npc_game_started()

/* Returns zombie class id, -1 otherwise */
native register_npc(classname[], description[])

/* Sets zombie player model */
native set_npc_model(classid, npc_model[])

/* All classes registered.. */
native get_npc_classum()

/* Returns zombie class id */
native get_npc_id(ent_id)

native get_npc_target(ent_id)

/* Returns zombie classname id */
native get_npc_classname_id(classname[])

native create_npc(Float:fOrigin[3], class_id)

/* Calls %counter% zombie(s) for thetime seconds */
native npc_timecall(caster, Float:fOrigin[3],  class, counter, iTime)


/* Set npc think! */
native set_npc_think(ent_id, value)

/* Set npc events! */
native set_npc_events(ent_id, Float:value)

/* Set npc mage! ( Can casting ) */
native set_npc_mage(ent_id, bool:value)

/* Set npc boss! ( Just for npc_ maps ) */
native set_npc_boss(ent_id, bool:value)

/* Set npc custom foes */
native set_npc_foes(ent_id, Float:value)

/* Set npc custom targets */
native set_npc_targets(ent_id, Float:value)

/* Order to instant damage from NPC ( good for spells ) */
native npc_do_damage(npc, victim, Float:damage)

/* Order to drag to npc target */
native npc_do_drag(npc, victim)
native npc_do_dragend(npc)

native npc_shoot(ent_id, Float:fOrigin[3])

native npc_set_animation(ent, value, Float:lenght)
native npc_reset_animation(ent)
native npc_set_berserker(ent, value)
native npc_set_move(ent, Float:fOrigin[3])
native npc_reset_move(ent)

/* Get npc events! */
native Float:get_npc_events(ent_id);

/* Reset NPC mode! ( remove all npc ) */
native npc_reset();
forward  event_npc_reset();

native npc_set_custom_heeting(ent_id, owner, Float:EVENT, Float:SPEED)


/* Return/set value of zombie class data */
native Float:get_npc_data(classid, dataid)
native set_npc_data(classid, dataid, Float:value)