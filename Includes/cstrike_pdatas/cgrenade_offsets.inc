#if defined _cgrenade_included
  #endinput
#endif
#define _cgrenade_included

#tryinclude "cstrike_pdatas/cbasemonster_offsets.inc"

//    CBaseEntity    ->    CBaseDelay    ->    CBaseAnimating    ->    CBaseToggle    ->    CBaseMonster    ->    CGrenade
stock const XO_CGRENADE = 5;

stock const m_bStartDefuse = 384;    //    [g/s]et_pdata_bool
stock const m_bIsC4 = 385;    //    [g/s]et_pdata_bool
stock const m_hDefuser_pent = 388;    //    LINUX    +    20                    //    offset    97
stock const m_hDefuser_serial = 98;
stock const m_flDefuseCountDown = 99;
stock const m_flC4Blow = 100;
stock const m_flNextFreqInterval = 101;
stock const m_flNextBeep = 102;
stock const m_flNextFreq = 103;
stock const m_sBeepName = 104;
stock const m_fAttenu = 105;
stock const m_flNextBlink = 106;
stock const m_flNextDefuseCheck = 107;
stock const m_bJustBlew = 108;
stock const m_iGrenadeTeam = 109;
stock const m_iC4Hurry = 110;
stock const m_pentCurBombTarget = 444;    //    LINUX    +    20    get_pdata_ent
stock const m_SGSmoke = 112;

//    int                    _dummy_113;    //    unknown    offset

stock const m_usEvent_Grenade = 228;    //    [g/s]et_pdata_short
stock const m_bLightSmoke = 458;    //    [g/s]et_pdata_bool
//    bool                    m_b459;        //    set    to    1    on    smoke    explode

stock const m_vecAngles[3] = {115,116,117};

stock const m_iRebundsCount = 118;
stock const m_fSoundSet = 119;
