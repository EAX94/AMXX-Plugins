#if defined _cruleentity_included
  #endinput
#endif
#define _cruleentity_included

#tryinclude "/cstrike_pdatas/cbaseentity_offsets.inc"

// CBaseEntity -> CRuleEntity
// Linux +4
stock const XO_CRULEENTITY = 4;

stock const m_iszMaster = 34;


//  CBaseEntity -> CRuleEntity -> CRulePointEntity
// No Pdatas

//  CBaseEntity -> CRuleEntity -> CRulePointEntity -> CGamePlayerEquip
stock const MAX_EQUIP = 32

stock const XO_CGAMEPLAYEREQUIP = 4;

stock const m_weaponNames[MAX_EQUIP] = {35,36,...};
stock const m_weaponCount[MAX_EQUIP] = {67,68,...};