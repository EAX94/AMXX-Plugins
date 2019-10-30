#if defined __INCLUDED_AnyMAL_IDS_C
	#endinput
#endif

#define __INCLUDED_AnyMAL_IDS_C

/*
----------------
@ about
----------------

AnyMAL's IDS's common presets.

Shadows In Rain (aka SiR), 2010
shadowsinrain@ya.ru

----------------
@ notes
----------------

Pass this consts to anymal_ds_find(...)

----------------
@ depedencies
----------------

This plugin uses AnyMAL IPM
Initialization depends on AnyMAL IDS

----------------
*/

// IPM
#define IPM_ANYMAL_IDS_C "anymal/ids/presets/common"

// user max speed
// float, multiplied, default 1.0
// final is resulting speed, not just multiplier
#define IDS_SPEED		"user/speed"

// user gravity
// float, multiplied, default 1.0
#define IDS_GRAVITY	"user/gravity"

// visibility (1/transparency)
// float, multiplied, default 1.0
#define IDS_VISIBLITY	"user/visibility"

// damage dealed to others players
// float, multiplied, default 1.0
// 0.0 makes player useless
// lesser than 0.0 gives antidamage (healing), may (must!) cause bugs
#define IDS_DMG_D		"user/damage/dealing"

// damage taked from any natural source (via TakeDamage, not via direct health changing)
// float, multiplied, default 1.0
// 0.0 gives physical invullnerability
// lesser than 0.0 gives antidamage (healing), may (must!) cause bugs
#define IDS_DMG_T		"user/damage/taking"

// volume of hearthbeat
// float, max from many, default 0.0
// lesser than 0.1 snapped to zero
#define IDS_HEARTBEAT	"user/heartbeat/volume"

// default normal health
// float, multiplied, default 1.0
// final is resulting health clamped to range 1 - 250, not just multiplier
#define IDS_HEALTH	"user/health"
