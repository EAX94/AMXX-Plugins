#if defined _cweaponbox_included
  #endinput
#endif
#define _cweaponbox_included

#tryinclude "cstrike_pdatas/cbaseentity_offsets.inc"

// CBaseEntity -> CWeaponBox
// Linux +4
stock const XO_CWEAPONBOX = 4;

stock const m_rgpPlayerItems_CWeaponBox[6] = { 34 , 35 , ... };
// Usage get_pdata_cbase(weaponbox, m_rgpPlayerItems_CWeaponBox[ SLOT_INDEX ], XO_CWEAPONBOX)

stock const m_rgiszAmmo[32] = { 40 , 41 , ... };
stock const m_rgAmmo_CWeaponBox[32] = { 72 , 73 , ... };
stock const m_cAmmoTypes = 104;
