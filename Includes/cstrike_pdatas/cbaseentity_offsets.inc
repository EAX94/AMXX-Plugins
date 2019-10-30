#if defined _cbaseentity_included
  #endinput
#endif
#define _cbaseentity_included

// CBaseEntity // LINUX DIFF 0

stock const vtbl = 0;

stock const _pev = 1;
stock const m_pGoalEnt = 2;
stock const m_pLink = 3;

stock const m_pfnThink = 4;				// linux diff 0

stock const m_pfnThink_Flag_LINUX = 5;	// linux only, diff 0

stock const m_pfnTouch = 5;				// LINUX DIFF 1

stock const m_pfnTouch_Flag_LINUX = 7;	// linux only, diff 0

stock const m_pfnUse = 6;				// LINUX DIFF 2

stock const m_pfnUse_Flag_LINUX = 9;	// linux only, diff 0

stock const m_pfnBlocked = 7;	// LINUX DIFF 3

stock const m_pfnBlocked_Flag_LINUX = 11;	// linux only, diff 0

// LINUX DIFF 4
stock const ammo_buckshot_TAB = 11;
stock const ammo_9mm_TAB = 13;
stock const ammo_556nato_TAB = 15;
stock const ammo_556natobox_TAB = 17;
stock const ammo_762nato_TAB = 19;
stock const ammo_45acp_TAB = 21;
stock const ammo_50ae_TAB = 23;
stock const ammo_338magnum_TAB = 25;
stock const ammo_57mm_TAB = 27;
stock const ammo_357sig_TAB = 29;

stock const m_flStartThrow = 30;
stock const m_flReleaseThrow = 31;
stock const m_chargeReady = 32;
stock const m_fInAttack = 33;


// CBaseEntity -> CArmoury
// Linux + 4
stock const XO_CARMOURY = 4;

stock const m_iItem = 34;		// weapon ID defined in fgd
stock const m_iCount = 35;		// item count before entity desappear
stock const m_iSaveCount = 36;		// saved m_iCount value at Spawn
stock const m_bRestoreCount = 148;		// if true [g/s]et_pdata_bool

// CBaseEntity -> CPointEntity -> CMapInfo
stock const XO_CMAPINFO = 4;

stock const m_ibuying = 34;
stock const m_flBombRadius = 35;
