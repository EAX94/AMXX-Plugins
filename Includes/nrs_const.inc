/* Npc Register System functions
*
*  by Good_Hash
*
*  This file is provided as is (no warranties).
*/

#if defined _nrs_const_included
	#endinput
#endif
#define _nrs_const_included

#define DATA_HEALTH 0
#define DATA_SPEED 1
#define DATA_GRAVITY 2
#define DATA_ATTACK 3
#define DATA_DEFENCE 4
#define DATA_HEDEFENCE 5
#define DATA_HITSPEED 6
#define DATA_HITDELAY 7
#define DATA_REGENDLY 8
#define DATA_HITREGENDLY 9
#define DATA_KNOCKBACK 10
#define DATA_ANI_DEATH_HEADSHOT 11
#define DATA_ANI_DEATH_NORMAL_SIMPLE 12
#define DATA_ANI_DEATH_NORMAL_BACK 13
#define DATA_ANI_DEATH_NORMAL_FORWARD 14
#define DATA_ANI_DEATH_NORMAL_SPECIAL 15
#define DATA_ANI_ATTACKED 16
#define DATA_ANI_IDLE 17
#define DATA_ANI_MADNESS 18
#define DATA_ANI_ATTACK 19
#define DATA_ANI_RUN 20
#define DATA_ANI_WALK 21
#define DATA_ANI_JUMP 22
#define DATA_EVENT 23
#define DATA_ATTACK_RELOADING 24
#define DATA_MODEL_INDEX 25
#define DATA_ATTACK_WAITTIME 26
#define DATA_ANI_CASTING 27
#define DATA_MATERIAL 28
#define DATA_WEAPON_TYPE	29
#define DATA_ANI_IDLE_SHOOT 30
#define DATA_ANI_RELOAD	31
#define DATA_WEAPON_DAMAGE	32
#define DATA_WEAPON_CLIP	33 //
#define DATA_MADANI_ATTACK	34
#define DATA_MADANI_ATTACK_TIME	35
#define DATA_MADANI_ATTACK_WAIT	36
#define DATA_MADANI_IDLE		37
#define DATA_MADANI_WALK	38
#define DATA_MADANI_RUN		39
#define DATA_ATTACK_DISTANCE	40
#define DATA_MIN_MAX_XY_MIN		41
#define DATA_MIN_MAX_XY_MAX		42
#define DATA_MIN_MAX_Z_MIN		43
#define DATA_MIN_MAX_Z_MAX		44

// Weapon types

#define WEAPON_KNIFE		0.0
#define WEAPON_M4A1			1.0


// Material data

#define MATERIAL_BODY		0.0
#define MATERIAL_MISSILE		1.0
#define MATERIAL_VECHILE		2.0
#define MATERIAL_FVECHILE	3.0

// Behavior

#define EVENT_SLEEP			0.0
#define EVENT_ZOMBIE_VOID	1.0
#define EVENT_WAKEUP		2.0
#define EVENT_AGRESSION		3.0
#define EVENT_SUPPORT		4.0
#define EVENT_MISSILE			5.0
#define EVENT_CUSTOM		6.0
#define EVENT_POINT			7.0
#define EVENT_SHOOTER		8.0

// Behavior for custom targets

#define TARGET_ALL			0.0
#define TARGET_ZOMBIE		1.0
#define TARGET_HUMAN		2.0
#define TARGET_NPC			3.0

#define FOE_ALL				0.0
#define FOE_ZOMBIE			1.0
#define FOE_HUMAN			2.0
#define FOE_NPC				3.0


// Cutom npc : if u made npc & want it do something..

#define CUSTOM_OFF			0.0
#define CUSTOM_HOTSEEK		1.0