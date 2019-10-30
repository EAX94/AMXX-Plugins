#if defined __INCLUDED_AnyMAL_SFX
	#endinput
#endif

#define __INCLUDED_AnyMAL_SFX

/*
----------------
@ about
----------------

AnyMAL (Any-Mod Abstraction Layer)
SFX (special effects)

by Shadows In Rain (aka SiR)
shadowsinrain@ya.ru

Just a bunch of popular effects.

----------------
@ depedencies
----------------

This plugin uses AnyMAL IPM
Depends on AnyMAL IDS C.

----------------
*/

// IPM
#define IPM_ANYMAL_SFX "anymal/sfx"

/*
Set player on fire.
Subsequent calls increases burning duration, stacks damage, mixes slowndown.
Zero attacker stops burning.
*/
native anymal_sfx_burn(victim, attacker = 0, Float:duration = 1.0, Float:damage_total = 10.0, Float:slowdown_factor = 0.35)

/*
User is burning?
*/
native bool:anymal_sfx_burning(player)

/*
Freeze victims movement.
Zero duration unfreezes.
*/
native anymal_sfx_freeze(victim, Float:duration = 0.0)

/*
User is frozen?
*/
native bool:anymal_sfx_frozen(player)