#if defined _cbaseplayerweapon_included
  #endinput
#endif
#define _cbaseplayerweapon_included

#tryinclude "cstrike_pdatas/cbaseanimating_offsets.inc"

// CBaseEntity -> CBaseDelay -> CBaseAnimating -> CBasePlayerItem
// Linux +4
stock const XO_CBASEPLAYERITEM = 4;

// CBasePlayerItem
stock const m_pPlayer = 41;
stock const m_pNext = 42;
stock const m_iId = 43;

// CBaseEntity -> CBaseDelay -> CBaseAnimating -> CBasePlayerItem -> CBasePlayerWeapon
// Linux +4
stock const XO_CBASEPLAYERWEAPON = 4;

// CBasePlayerWeapon	
stock const m_iPlayEmptySound = 44;
stock const m_fFireOnEmpty = 45;  // True when the gun is empty and the player is still holding down the attack key
stock const m_flNextPrimaryAttack = 46;	// soonest time ItemPostFrame will call PrimaryAttack
stock const m_flNextSecondaryAttack = 47;	// soonest time ItemPostFrame will call SecondaryAttack
stock const m_flTimeWeaponIdle = 48;	// soonest time ItemPostFrame will call WeaponIdle
stock const m_iPrimaryAmmoType = 49;	// "primary" ammo index into players m_rgAmmo[]
stock const m_iSecondaryAmmoType = 50;	// "secondary" ammo index into players m_rgAmmo[]
stock const m_iClip = 51;	// number of shots left in the primary weapon clip, -1 it not used
stock const m_iClientClip = 52;	// the last version of m_iClip sent to hud dll
stock const m_iClientWeaponState = 53;	// the last version of the weapon state sent to hud dll (is current weapon, is on target)
stock const m_fInReload = 54;	// Are we in the middle of a reload;
stock const m_fInSpecialReload = 55;	// Are we in the middle of a reload for the shotguns
stock const m_iDefaultAmmo = 56;	// how much ammo you get when you pick up this weapon as placed by a level designer.
stock const m_iShellLate = 57;
stock const m_flWeaponSpeed = 58;	// used for guns to restore after shield
stock const m_bDelayFire = 236;

stock const m_iDirection = 60;	// The current lateral kicking direction ; 1 = right, 0 = left.

stock const m_flAccuracy = 62;
stock const m_flLastFire = 63;
stock const m_iShotFired = 64;

stock const m_iszViewModel = 68;
stock const m_flGlock18Shoot = 69;
stock const m_iGlock18ShotsFired = 70;
stock const m_flFamasShoot = 71;
stock const m_iFamasShotsFired = 72;
stock const m_flFamasBurstSpread = 73;
stock const m_fWeaponState = 74;
enum ( <<=1 )
{
	WEAPONSTATE_USP_SILENCED = 1,
	WEAPONSTATE_GLOCK18_BURST_MODE,
	WEAPONSTATE_M4A1_SILENCED,
	WEAPONSTATE_ELITE_LEFT,
	WEAPONSTATE_FAMAS_BURST_MODE,
	WEAPONSTATE_SHIELD_DRAWN
}

stock const m_flNextReload = 75;
stock const m_flDecreaseShotsFired = 76;
stock const m_usGlock18Event = 154;	// [g/s]et_pdata_short
stock const m_usFamasEvent = 155;	// [g/s]et_pdata_short

// Weapon Specific :
// Linux +4

// CC4
stock const m_bArming = 312;					// offset 82 linux		
stock const m_bInArmingAnimation = 313;	// offset 82
	// bool					_dummy_bool_330;
	// bool					_dummy_bool_331;

stock const m_flArmedTime = 79;		// offset 83 linux
	// int					_dummy_80;				// offset 84 linux // set to 1 when deployed and player has shield ?

// CHEGrenade
stock const m_usExplo_HEGREN = 156;

// CAK47
stock const m_iShell_AK47 = 78;
stock const m_fIsDeployed_AK47 = 79;
stock const m_usEvent_AK47 = 160;

// CAUG
stock const m_iShell_AUG = 78;
stock const m_fIsDeployed_AUG = 79;
stock const m_usEvent_AUG = 160;

// CDEAGLE
stock const m_iShell_DEAGLE = 78;
stock const m_usEvent_DEAGLE = 158;

// CELITE
stock const m_iShell_ELITE = 78;
stock const m_usEventLeft_ELITE = 158;
stock const m_usEventRigth_ELITE = 159;
	
// CFiveSeven
stock const m_iShell_FiveSeven = 78;
stock const m_usEvent_FiveSeven = 158;
	
// CM249
stock const m_iShell_CM249 = 78;
stock const m_fIsDeployed_CM249 = 79;
stock const m_usEvent_CM249 = 160;

// CM4A1
stock const m_iShell_M4A1 = 78;
stock const m_fIsDeployed_M4A1 = 79;
stock const m_usEvent_M4A1 = 160;

// CMAC10
stock const m_iShell_MAC10 = 78;
stock const m_fIsDeployed_MAC10 = 79;
stock const m_usEvent_MAC10 = 160;

// CMP5N
stock const m_iShell_CMP5N = 78;
stock const m_fIsDeployed_CMP5N = 79;
stock const m_usEvent_CMP5N = 160;

// CP228
stock const m_iShell_P228 = 78;
stock const m_usEvent_P228 = 158;
	
// CP90
stock const m_iShell_P90 = 78;
stock const m_fIsDeployed_P90 = 79;
stock const m_usEvent_P90 = 160;

// CSG552
stock const m_iShell_SG552 = 78;
stock const m_fIsDeployed_SG552 = 79;
stock const m_usEvent_SG552 = 160;

// CTMP
stock const m_iShell_TMP = 78;
stock const m_fIsDeployed_TMP = 79;
stock const m_usEvent_TMP = 160;

// CUMP45
stock const m_iShell_UMP45 = 78;
stock const m_fIsDeployed_UMP45 = 79;
stock const m_usEvent_UMP45 = 160;

// CUSP
stock const m_iShell_USP = 78;
stock const m_usEvent_USP = 158;
	
// CGalil
stock const m_iShell_Galil = 78;
stock const m_fIsDeployed_Galil = 79;
stock const m_usEvent_Galil = 160;

// CFamas
stock const m_iShell_Famas = 78;
stock const m_fIsDeployed_Famas = 79;
	
// CGLOCK18
stock const m_iShell_GLOCK18 = 78;
stock const m_fIsDeployed_GLOCK18 = 79;
	
// CSmokeGrenade
stock const m_usSmokeExplo = 156;
	
// CSCOUT
stock const m_iShell_SCOUT = 78;
stock const m_usEvent_SCOUT = 158;
	
// CAWP
stock const m_iShell_AWP = 78;
stock const m_usEvent_AWP = 158;
	
// CSG550
stock const m_iShell_SG550 = 78;
stock const m_usEvent_SG550 = 158;
	
// CG3SG1
stock const m_iShell_G3SG1 = 78;
stock const m_usEvent_G3SG1 = 158;
	
// CFlashbang // no private data

// CXM1014
stock const m_iShell_XM1014 = 78;
stock const m_flPumpTime_XM1014 = 79;
stock const m_usEvent_XM1014 = 160;
	
// CM3
stock const m_iShell_CM3 = 78;
stock const m_flPumpTime_CM3 = 79;
stock const m_usEvent_CM3 = 160;
	
// CC4
stock const m_bArming_C4 = 312;
stock const m_bInArmingAnimation_C4 = 313;
stock const m_flArmedTime_C4 = 79;

// CKnife
stock const m_fAllSolid_CKnife = 78;
stock const m_fStartSolid_CKnife = 79;
stock const m_fInOpen_CKnife = 80;
stock const m_fInWater_CKnife = 81;
stock const m_flFraction_CKnife = 82;
stock const m_vecEndPos_CKnife = {83,84,85};
stock const m_flPlaneDist_CKnife = 86;
stock const m_vecPlaneNormal_CKnife[3] = {87,88,89};
stock const m_pHit_CKnife = 90;
stock const m_iHitgroup_CKnife = 91;
stock const m_usEvent_CKnife = 184;
	
// CWeaponCycler
stock const m_iszModel_WeaponCycler = 78;
stock const m_iModel_WeaponCycler = 79;
