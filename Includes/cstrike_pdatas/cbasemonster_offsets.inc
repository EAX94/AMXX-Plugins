#if defined _cbasemonster_included
  #endinput
#endif
#define _cbasemonster_included

#tryinclude "cstrike_pdatas/cbasetoggle_offsets.inc"

// CBaseEntity -> CBaseDelay -> CBaseAnimating -> CBaseToggle -> CBaseMonster
// Linux +5
stock const XO_CBASEMONSTER = 5;

stock const m_Activity = 73;
stock const m_IdealActivity = 74;
stock const m_LastHitGroup = 75;
stock const m_bitsDamageType = 76;


// NOT OFFSETS LOL
enum {
	itbd_Paralyze,		
	itbd_NerveGas,
	itbd_Poison,
	itbd_Radiation,
	itbd_DrownRecover,
	itbd_Acid,
	itbd_SlowBurn,
	itbd_SlowFreeze,
	CDMG_TIMEBASED
}
stock const m_rgbTimeBasedDamage[CDMG_TIMEBASED] = {308,309,...};
// Usage get_pdata_char(id, m_rgbTimeBasedDamage[ itbd_DrownRecover ] )
// set_pdata_char(id, m_rgbTimeBasedDamage[ itbd_Poison ] , 200)

stock const m_MonsterState = 79;
stock const m_IdealMonsterState = 80;
stock const m_afConditions = 81;
stock const m_afMemory = 82;
stock const m_flNextAttack = 83;
stock const m_hEnemy_pent = 336;	// linux +20	// get_pdata_ent is (char) based		// 84
stock const m_hEnemy_serialnumber = 85;
stock const m_hTargetEnt_pent = 344;	// linux +20	// get_pdata_ent is (char) based		// 86
stock const m_hTargetEnt_serialnumber = 87;
stock const m_flFieldOfView = 88;
stock const m_bloodColor = 89;
stock const m_HackedGunPos[3] = {90,91,92};
stock const m_vecEnemyLKP[3] = {93,94,95};