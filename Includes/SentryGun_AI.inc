#if defined _sentrygunai_included
  #endinput
#endif
#define _sentrygunai_included

#include <fakemeta>

/*  Cvars	        name			defaultvalue	description
		"sentry_bulletdmg_min"		"10.0"		BulletDamageMin
		"sentry_bulletdmg_max"		"12.0"		BulletDamageMax
		"sentry_searchradius"		"1800.0"	Max distance if a sentrygun could find its target	
		"sentry_health_lv1"		"400.0"         DefaultHealth of level one sentrygun
		"sentry_health_lv2"		"400.0"		DefaultHealth of level two sentrygun
		"sentry_health_lv3"		"400.0"		DefaultHealth of level three sentrygun
		"sentry_detonation_dmg"		"200.0"		MaxDamage of detonation
		"sentry_detonation_radius"	"300.0"		Max distance if detonation could affects
		"sentry_dmgtoken_multiplier"	"0.2"		Multiplier of damage dealt to sentrygun
*/

// sentry_sethealth -  set the health of a sentrygun
// sentry       - could be the id of a sentrybase, or a sentrygun.
// health       - the health you want to set to.
native sentry_sethealth(sentry, Float:health)
// sentry_setorigin -  set the origin of a sentrygun (includes its base)
// sentry       - could be the id of a sentrybase, or a sentrygun.
// origin       - the origin you want to set to.
native sentry_setorigin(sentry, Float:origin[3])
// sentry_remove    -  removes a sentrygun
// sentry       - could be the id of a sentrybase, or a sentrygun.
native sentry_remove(sentry)
// sentry_detonate  -  detonates a sentrygun
// sentry       - could be the id of a sentrybase, or a sentrygun.
native sentry_detonate(sentry)
// sentry_setlevel  -  set the level of a sentrygun
// sentry       - could be the id of a sentrybase, or a sentrygun.
// level        - the level you want to set to. (1 - 3)
// playsound    - set to 1 to play a upgrade sound.
// sethealth    - set to 1 to set health to the default value(defined by cvar).
native sentry_setlevel(sentry, level, playsound, sethealh)
// sentry_build     -  This will return the id of sentrybase, and the sentrygun will be created in 2 seconds
// origin       - the origin of the sentrybase.
// dropToGround - set to 1 to drop the sentrybase to ground.
// owner        - the owner of the sentrygun.
// team         - the team of the sentrygun. (0 means no team) (player - get_user_team(), other - pev->team)
// level        - the level of the sentrygun
native sentry_build(Float:origin[3], dropToGround, owner, team, level)

// _couldBeTarget   -  whether the 'ent' could be the target of a sentrygun (default all 'breakable' could be the target)
// return -1    - pass to next plugin
//         0    - this 'ent' couldn't be the target of a sentrygun
//         1    - this 'ent' could be the target of a sentrygun
forward _couldBeTarget(ent)

// get the head of the sentrybase   - this wont affect on a head
stock sentry_getHead(ent)		{ return pev(ent, pev_euser1); }
// get the base of the sentrygun    - this wont affect on a base
stock sentry_getBase(ent)		{ return pev(ent, pev_euser2); }
// get the owner of the sentrygun   - this wont affect on a base
stock sentry_getOwner(ent)		{ return pev(ent, pev_euser3); }
// get the enemy of the sentrygun   - this wont affect on a base
stock sentry_getEnemy(ent)		{ return pev(ent, pev_euser4); }
// set the head of the sentrybase   - this wont affect on a head
stock sentry_setHead(ent, head)		{ set_pev(ent, pev_euser1, head); }
// set the base of the sentrygun    - this wont affect on a base
stock sentry_setBase(ent, base)		{ set_pev(ent, pev_euser2, base); }
// set the owner of the sentrygun   - this wont affect on a base
stock sentry_setOwner(ent, owner)	{ set_pev(ent, pev_euser3, owner); }
// set the enemy of the sentrygun   - this wont affect on a base
stock sentry_setEnemy(ent, enemy)	{ set_pev(ent, pev_euser4, enemy); }
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg936\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset134 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang2052\\ f0\\ fs16 \n\\ par }
*/
