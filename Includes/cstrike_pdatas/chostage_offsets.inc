#if defined _chostage_included
  #endinput
#endif
#define _chostage_included

#tryinclude "cstrike_pdatas/cbasemonster_offsets.inc"

// CBaseEntity -> CBaseDelay -> CBaseAnimating -> CBaseToggle -> CBaseMonster -> CHostage

const XO_CHOSTAGE = 5;

stock const m_LastActivity = 96;		// Activity
stock const m_fHasGivenUseBonus = 97;
// int		_hostage_dummy_98;
stock const m_flNextFlinch = 99;	
stock const m_flNextUse = 100;		// timebased m_flNextUse
// int		_hostage_dummy_101;
// int		_hostage_dummy_102;
// int		_hostage_dummy_103;
// int		_hostage_dummy_104;
stock const m_fShouldFollow = 105;		// seems to be a flag to tell if it should follow or not
stock const m_vecOrigOrigin[3] = {106,107,108};			// RestorePos
stock const m_vecOrigAngles[3] = {109,110,111};			// RestorePos
// int		_hostage_dummy_112;
// int		_hostage_dummy_113;
// int		_hostage_dummy_114;
// int		_hostage_dummy_115_171[58];
// CBasePlayer*		_hostage_dummy_173;
stock const m_iCurPathNode = 174;					// offset 178	// CLocalNav*
stock const m_iNextPathNode = 175;					// offset 179
stock const m_flNextPathOrig2D_X = 176;			// offset 180
stock const m_flNextPathOrig2D_Y = 177;			// offset 181
// int		_hostage_dummy_178_473[298];
// EHANDLE		_hostage_dummy_476_477;
// float		_hostage_dummy_478;
stock const m_flPathCheckDelay = 479;						// offset 483
stock const m_flLastPathCheckTime = 480;			// offset 484
// int		_hostage_dummy_481;					// offset 485
stock const m_fHasReachedPathNode = 482;	// BOOL			// offset 487
stock const m_flLastUse = 483;								// offset 488
// int		_hostage_dummy_489;
// int		_hostage_dummy_490;
// int		_hostage_dummy_491;
stock const m_iHostageId = 487;						// offset 492					// gmsgHostageK, gmsgHostagePos pfnWriteByte(this->_hostage_dummy_391);
// BOOL		_hostage_dummy_493;
// int		_hostage_dummy_494;
stock const m_hRescuer = 490;							// offset 495		// seems to be CHostageImprov*
stock const m_iCzHostageModelIndex = 491;		// offset 496
// int		_hostage_dummy_AFTER_end[5000];

// monster size 404 dword
// total size 1420 dword
// offsets size: 1016