#if defined _cbasetoggle_included
  #endinput
#endif
#define _cbasetoggle_included

#tryinclude "cstrike_pdatas/cbaseanimating_offsets.inc"

// CBaseEntity -> CBaseDelay -> CBaseAnimating -> CBaseToggle
// Linux + 4
stock const XO_CBASETOGGLE1 = 4;

stock const m_toggle_state = 41;
stock const m_flActivateFinished = 42;
stock const m_flMoveDistance = 43;
stock const m_flWait = 44;
stock const m_flLip = 45;
stock const m_flTWidth = 46;
stock const m_flTLength = 47;
stock const m_vecPosition1[3] = {48,49,50};
stock const m_vecPosition2[3] = {51,52,53};
stock const m_vecAngle1[3] = {54,55,56};
stock const m_vecAngle2[3] = {57,58,59};
stock const m_cTriggersLeft = 60;
stock const m_flHeight = 61;
stock const m_hActivator_pent = 248;		// linux + 16	// get_pdata_ent is (char) based		// 62
stock const m_hActivator_serialnumber = 63;		// 63
stock const m_pfnCallWhenMoveDone = 64;

// Linux +5
stock const XO_CBASETOGGLE2 = 5;

stock const m_pfnCallWhenMoveDone_Flag_LIN = 69;	// linux only, diff 0
stock const m_vecFinalDest[3] = {65,66,67};
stock const m_vecFinalAngle[3] = {68,69,70};
stock const m_bitsDamageInflict = 71;
stock const m_sMaster = 72;