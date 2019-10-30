/* Headcrab AI - v1.1
*
* by GHW_Chronic
*   04/2007 - 05/2007
*
* This file is provided as is (no warranties).
*
*/

#if defined headcrab_included
  #endinput
#endif
#define headcrab_included


/**************
*             *
*  Variables  *
*             *
**************/

/*
*
*  Custom flags for the headcrab ents.
*
*/
#define FL_PSYCHIC	(1<<32)		//Finds an enemy even if it isn't in the headcrab's viewcone.
#define FL_FRIENDLY	(1<<33)		//Headcrab doesn't attempt to attack players.
#define FL_IN_JUMP	(1<<34)		//Is set when the headcrab is in the middle of attacking a player.
#define FL_IN_RIGHT	(1<<35)		//Is set when the headcrab is piviting right. When set, headcrab pivits right.
#define FL_IN_LEFT	(1<<36)		//Is set when the headcrab is piviting left. When set, headcrab pivits left.
#define FL_IN_FORWARD	(1<<37)		//Is set when the headcrab is moving forward. When set, headcrab moves forward.
#define FL_IN_BACK	(1<<38)		//When set, headcrab moves backwards.
#define FL_STOPPED	(1<<39)		//Headcrab AI plugin does not deal with the headcrab. Think for that headcrab is skipped.
#define FL_WANDER	(1<<40)		//If set, headcrab will wander around when it doesnt have an enemy.
#define FL_EXPLODE	(1<<42)		//If set, headcrab will explode after dieing.
#define FL_KAMIKAZE	(1<<43)		//If set, headcrab will explode and die after attacking (like HL Squeek).
#define FL_FROZEN2	(1<<44)		//If set, headcrab is frozen completely. No plugin can affect it except by removing it.
#define FL_FRIENDLY_1	(1<<45)		//If set, friendly to players on team 1
#define FL_FRIENDLY_2	(1<<46)		//If set, friendly to players on team 2
#define FL_FRIENDLY_3	(1<<47)		//If set, friendly to players on team 3
#define FL_FRIENDLY_4	(1<<48)		//If set, friendly to players on team 4

/*
*
*  The sequences for the headcrabs.
*
*/
#define SQ_IDLE		0
#define SQ_TURNLEFT	9
#define SQ_TURNRIGHT	8
#define SQ_RUN		3
#define SQ_DIE		7
#define SQ_IN_AIR	13
#define SQ_IN_JUMP	5

/*
*
*  The framerates for all of the headcrab
*  sequences.
*
*/
#define FR_IDLE		1.0
#define FR_TURNLEFT	0.5
#define FR_TURNRIGHT	0.5
#define FR_RUN		1.5
#define FR_DIE		1.0
#define FR_IN_AIR	1.0
#define FR_IN_JUMP	1.0

/*
*
*  The color of the headcrab's blood.
*
*/
#define BLOOD_COLOR	204

/*
*
*  Technical information for use with
*  dealing with headcrab damage and death.
*  This doesn't need to be changed for
*  any reason.
*
*/
#define HEALTH_OFFSET	100000.0

/*
*
*  This number plus the amount of time it
*  takes to do the think equals the delay
*  from the beginning of one think to another.
*
*/
#define THINK_DELAY	0.000000




/**************
*             *
*  Functions  *
*             *
**************/

/*
*
*  This function returns the created entity's
*  number. The spawned entity has a few keys
*  filled in including:
*    health 	- 100.0
*    takedamage - 1.0
*    maxspeed	- 20.0
*    dmg	- 1.0
*    flags	- FL_WANDER
*
*  Do not fear to mess with any variable set
*  by this function. These keys have all been
*  programmed to be read as variable in the
*  headcrab's think.
*
*/
native create_headcrab()

/*
*
*  Sets a headcrab's health. Use this instead
*  of setting the health / max_health keys.
*
*/
native set_headcrab_health(ent,Float:health)

/*
*
*  Kills a headcrab. Reads the headcrab's flags
*  for more information.
*
*/
native kill_headcrab(ent)




/*************
*            *
*  Forwards  *
*            *
*************/

/*
*
*  This forward is called right before
*  a headcrab is killed.
*
*  Returning PLUGIN_HANDLED will stop
*  the headcrab ent from being deleted.
*
*/
forward headcrab_killed(ent)