#if defined _nades_api_included
  #endinput
#endif
#define _nades_api_included

#pragma reqlib nades_api

// Returns TumbleThink index		// FLASH	// HE
native Get_Nade_TumbleThink();

// Returns BounceTouch index		// FLASH	// HE	// SMOKE
native Get_Nade_BounceTouch();

// Returns Detonate index			// FLASH
native Get_Nade_Detonate();

// Returns Smoke index				// FLASH
native Get_Nade_Smoke();

// Returns Detonate3 index			// HE
native Get_Nade_Detonate3();

// Returns Smoke3_C index			// HE
native Get_Nade_Smoke3_C();

// Returns SG_TumbleThink index		// SMOKE
native Get_Nade_SG_TumbleThink();

// Returns SG_Detonate index		// SMOKE
native Get_Nade_SG_Detonate();

// Returns SG_Smoke index			// SMOKE
native Get_Nade_SG_Smoke();

// Flash forwards
forward OnFlashNadenadeBounceTouch(ent, pOther);
forward OnFlashNadeTumbleThink(ent);
forward OnFlashNadeDetonate(ent);
forward OnFlashNadeSmoke(ent);

// HeGrenade forwards
forward OnHeNadenadeBounceTouch(ent, pOther);
forward OnHeNadeTumbleThink(ent);
forward OnHeNadeDetonate(ent);
forward OnHeNadeSmoke(ent);

// SmokeGrenade forwards
forward OnSmokeNadenadeBounceTouch(ent, pOther);
forward OnSmokeNadeTumbleThink(ent);
forward OnSmokeNadeDetonate(ent);
forward OnSmokeNadeSmoke(ent);