#if defined _cbaseanimating_included
  #endinput
#endif
#define _cbaseanimating_included

#tryinclude "cstrike_pdatas/cbasedelay_offsets.inc"

// CBaseEntity -> CBaseDelay -> CBaseAnimating
// Linux +4
stock const XO_CBASEANIMATING = 4;

stock const m_flFrameRate = 36;
stock const m_flGroundSpeed = 37;
stock const m_flLastEventCheck = 38;
stock const m_fSequenceFinished = 39;
stock const m_fSequenceLoops = 40;