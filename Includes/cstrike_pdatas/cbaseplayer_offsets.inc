#if defined _cbaseplayer_included
  #endinput
#endif
#define _cbaseplayer_included

#tryinclude "cstrike_pdatas/cbasemonster_offsets.inc"

// CBaseEntity -> CBaseDelay -> CBaseAnimating -> CBaseToggle -> CBaseMonster -> CBasePlayer
// Linux +5
stock const XO_CBASEPLAYER = 5;

stock const random_seed = 96;    //    See    that    is    shared    between    client    &    server    for    shared    weapons    code
//    97    unknown
stock const m_hSpectatedTarget = 98;
stock const m_hSpectatedTarget_pent = 392;    //    linux    +20    //    m_hSpectatedTarget    takes    98    and    99    normally    //    get_pdata_ent,    no    set
stock const m_hSpectatedTarget_serialnumber = 99;
stock const m_flNextSpecButtonTime = 100;
stock const m_iSpectatedPlayerWeaponId = 101;
stock const m_fHasSpectatedPlayerC4 = 102;
stock const m_fHasSpectatedPlayerDefuseKit = 103;
stock const m_iObserverMode = 104;
stock const m_flAnimationTimeDummy = 105;
//    106    unknown
stock const m_fHasTakenHighDamage = 107;        //    Last    damage    >    60    ?
stock const m_flPainShock = 108;
stock const m_iLastZoom = 109;
stock const m_fResumeZoom = 110;
stock const m_flEjectBrass = 111;
stock const m_iKevlarType = 112;
stock const m_fHasSurvivedLastRound = 113;
stock const m_iTeam = 114;
stock const m_iAccount = 115;
stock const m_fHasPrimary = 116;
//    int        _dummy_117        //    animation    //    117    unknown
stock const m_iAnimationInCaseDie = 118;    //    set    according    to    hitplace    and    random    values    //    used    when    dies    to    set    some    properties    (velocity,    that    kind    of    stuff)
stock const m_flNextChatTime = 119;                        
//    stock const m_bHasReceivedDefItems                    120    //    (1<<0)
stock const m_bHasReceivedDefItems = 480;    //    [g/s]et_pdata_bool
stock const m_iJoinedState = 121;
stock const m_pLastCamera = 122;
stock const m_flNextCameraTime = 123;
stock const m_flLastActivityTime = 124;
//    stock const m_bools125                                        125    //    m_bHasBeenShownBriefing    (1<<0)            //    m_bHasChangeTeamThisRound    (1<<8)
stock const m_bHasBeenShownBriefing = 500;    //    [g/s]et_pdata_bool
stock const m_bHasChangeTeamThisRound = 501;    //    [g/s]et_pdata_bool
stock const m_iInternalModel = 126;
stock const m_iTeamMateKills = 127;
stock const m_iIgnoreMessages = 128;
//    stock const m_boolsNVG                                        129    //    m_bGotNVG    (1<<0)        //    m_bIsNVGSwitchedOn    (1<<8)
stock const m_bGotNVG = 516;    //    [g/s]et_pdata_bool
stock const m_bIsNVGSwitchedOn = 517;    //    [g/s]et_pdata_bool
//    BIG    HOLE
stock const m_flNextIdleCheckTime = 190;
stock const m_flNextRadioGameTime = 191;
stock const m_iRadiosLeft = 192;
//    stock const m_bools193                                        193    //    m_bHasSilentRadio    (1<<0)    //    m_bHasC4    (1<<8)    //    m_bHasDefuser    (1<<16)        //    m_bBlastDamaged    (1<<24)
stock const m_bHasSilentRadio = 772;    //    [g/s]et_pdata_bool
stock const m_bHasC4 = 773;    //    [g/s]et_pdata_bool
stock const m_bHasDefuser = 774;    //    [g/s]et_pdata_bool
stock const m_bBlastDamaged = 775;    //    [g/s]et_pdata_bool
stock const m_vecRelativeInflictorOrigin[3] = {194,195,196};
stock const m_bTruOnHeDamage = 197;                //    CBasePlayer::SetAnimation
stock const m_fNextHudTextArgsGameTime = 198;
//    LITTLE    HOLE    HudTextArgs    RELATED
stock const m_bitHudTextArgsDontResend = 204;
stock const m_iMenu = 205;
//    206    unknown
//    207    unknown
stock const m_fIsVIPRescued = 208;
//    stock const m_boolsAsEscape                                209    //    m_bHasReachRescueEscapePoint    (1<<0)    //    m_bIsVip    (1<<8)
stock const m_bHasReachRescueEscapePoint = 836;        //    [g/s]et_pdata_bool
stock const m_bIsVip = 837;        //    [g/s]et_pdata_bool
stock const m_flNextRadarUpdateTime = 210;
stock const m_vecLastPosition[3] = {211,212,213};
stock const m_iVoteKickUserId = 214;
stock const m_flNextVote = 215;    //    votemap    votekick
stock const m_iTeamKills = 216;
stock const m_iHostageKills = 217;
stock const m_iVotedMapIndex = 218;
stock const m_bIsPrimaryFireAllowed = 219;
stock const m_flLastAttackTime = 220;    //    not    sure
stock const m_flNextTeammateAttackAlert = 221;
//    stock const m_boolsKilled                                    222    //    m_bKilledByHeadShot    (1<<0)    //    m_bKilledBecauseTeamKill    (1<<8)    //    m_bNotReceivingMoneyNextRound    (1<<16)
stock const m_bKilledByHeadShot = 888;    //    [g/s]et_pdata_bool
stock const m_bKilledBecauseTeamKill = 889;    //    [g/s]et_pdata_bool
stock const m_bNotReceivingMoneyNextRound = 890;    //    [g/s]et_pdata_bool
stock const m_flNextTimeleft = 223;
stock const m_boolChangeNameAtRespawn = 896;    //    [g/s]et_pdata_bool
stock const m_szNewName = 897;    //    (224*4    +    1)    [g/s]et_pdata_string    //    char    m_szNewName[32]
stock const m_fBombDefusing = 232;    //    m_bBombDefusing    (1<<8)
stock const m_bBombDefusing = 929;
stock const m_flNextMapZoneTime = 233;
stock const m_fMapZone = 234;
stock const m_fClientMapZone = 235;
stock const m_pentBombTarget = 236;
stock const m_iPlayerSound = 237;    //    the    index    of    the    sound    list    slot    reserved    for    this    player
stock const m_iTargetVolume = 238;    //    ideal    sound    volume.    
stock const m_iWeaponVolume = 239;    //    how    loud    the    player's    weapon    is    right    now.
stock const m_iExtraSoundTypes = 240;    //    additional    classification    for    this    weapon's    sound
stock const m_iWeaponFlash = 241;    //    brightness    of    the    weapon    flash
stock const m_flStopExtraSoundTime = 242;    //    
stock const m_flFlashLightTime = 243;    //    Time    until    next    battery    draw/Recharge
stock const m_iFlashBattery = 244;    //    Flashlight    Battery    Draw
stock const m_afButtonLast = 245;
stock const m_afButtonPressed = 246;
stock const m_afButtonReleased = 247;
stock const m_pentSndLast = 248;    //    last    sound    entity    to    modify    player    room    type
stock const m_flSndRoomtype = 249;    // last roomtype set by sound entity
stock const m_flSndRange = 250;    //    dist    from    player    to    sound    entity
stock const m_flFallVelocity = 251;

// constant items
enum {
	ITEM_HEALTHKIT = 1,
	ITEM_ANTIDOTE = 2,
	ITEM_SECURITY = 3,
	ITEM_BATTERY = 4,
	MAX_ITEMS = 5	// hard coded item types
}
stock const m_rgItems[MAX_ITEMS] = { 252 , 253 , ... };

stock const m_afPhysicsFlags = 257;    //    physics    flags    -    set    when    'normal'    physics    should    be    revisited    or    overriden
stock const m_fNextSuicideTime = 258;    //    the    time    after    which    the    player    can    next    use    the    suicide    command
stock const m_flTimeStepSound = 259;    //    when    the    last    stepping    sound    was    made
stock const m_flTimeWeaponIdle_PLAYER = 260;    //    when    to    play    another    weapon    idle    animation.
stock const m_flSwimTime = 261;    //    how    long    player    has    been    underwater
stock const m_flDuckTime = 262;    //    how    long    we've    been    ducking
stock const m_flWallJumpTime = 263;    //    how    long    until    next    walljump
stock const m_flSuitUpdate = 264;    //    when    to    play    next    suit    update
stock const m_rgSuitPlayList[4] = {265,266,...};	//[CSUITPLAYLIST]    //    next    sentencenum    to    play    for    suit    update
stock const m_iSuitPlayNext = 269;    //    next    sentence    slot    for    queue    storage
stock const m_rgiSuitNoRepeat[32] = {270,271,...};    //    [32]    //[CSUITNOREPEAT]        //    suit    sentence    no    repeat    list
stock const m_rgflSuitNoRepeatTime[32] = {302,303,...};                          //    [32]    //[CSUITNOREPEAT]    //    how    long    to    wait    before    allowing    repeat
stock const m_lastDamageAmount = 334;    //    Last    damage    taken
stock const m_tbdPrev = 335;    //    Time-based    damage    timer
stock const m_flgeigerRange = 336;    //    range    to    nearest    radiation    source
stock const m_flgeigerDelay = 337;    //    delay    per    update    of    range    msg    to    client
stock const m_igeigerRangePrev = 338;
stock const m_iStepLeft = 339;    //    alternate    left/right    foot    stepping    sound
stock const m_szTextureName = 1360;    //    440*4        m_szTextureName[19    char]    //HL    13    [CBTEXTURENAMEMAX]    //    current    texture    name    we're    standing    on
stock const m_chTextureType = 1379;    //    current    texture    type    //    may    be    use    344    instead
stock const m_idrowndmg = 345;    //    track    drowning    damage    taken
stock const m_idrownrestored = 346;    //    track    drowning    damage    restored
stock const m_bitsHUDDamage = 347;    //    Damage    bits    for    the    current    fame.    These    get    sent    to    
stock const m_fInitHUD = 348;    //    True    when    deferred    HUD    restart    msg    needs    to    be    sent
stock const m_fGameHUDInitialized = 349;
stock const m_iTrain = 350;    //    Train    control    position
stock const m_fWeapon = 351;    //    Set    this    to    FALSE    to    force    a    reset    of    the    current    weapon    HUD    info
stock const m_pTank = 352;
stock const m_pTank_pent = 1408;    //    linux    +    20    //    352    //    the    tank    which    the    player    is    currently    controlling,    NULL    if    no    tank
stock const m_pTank_serialnumber = 353;    //    the    tank    which    the    player    is    currently    controlling,    NULL    if    no    tank
stock const m_fDeadTime = 354;    //    the    time    at    which    the    player    died    (used    in    PlayerDeathThink())
stock const m_fNoPlayerSound = 355;    //    a    debugging    feature.    Player    makes    no    sound    if    this    is    true.    
stock const m_fLongJump = 356;    //    does    this    player    have    the    longjump    module?
stock const m_tSneaking = 357;
stock const m_iUpdateTime = 358;    //    stores    the    number    of    frame    ticks    before    sending    HUD    update    messages
stock const m_iClientHealth = 359;    //    the    health    currently    known    by    the    client.    If    this    changes,    send    a    new
stock const m_iClientBattery = 360;    //    the    Battery    currently    known    by    the    client.    If    this    changes,    send    a    new
stock const m_iHideHUD = 361;    //    the    players    hud    weapon    info    is    to    be    hidden
stock const m_iClientHideHUD = 362;
stock const m_iFOV = 363;    //    field    of    view
stock const m_iClientFOV = 364;    //    client's    known    FOV
stock const m_iSpawnCount = 365;
stock const m_pLinkedEntity = 366;
stock const m_rgpPlayerItems_CBasePlayer[6] = { 367 , 368 , ... };
stock const m_pActiveItem = 373;
stock const m_pClientActiveItem = 374;    //    client    version    of    the    active    item
stock const m_pLastItem = 375;
stock const m_rgAmmo_CBasePlayer[32] = {376,377,...};                    //   376    //    [MAX_AMMO_SLOTS]    
stock const m_rgAmmoLast[32] = {408,409,...};    //    [MAX_AMMO_SLOTS]    
stock const m_vecAutoAim[3] = {440,441,442};
stock const m_fOnTarget = 443;
stock const m_iDeaths = 444;
stock const m_iRespawnFrames = 445;    //    used    in    PlayerDeathThink()    to    make    sure    players    can    always    respawn
// stock const m_izSBarState_0 = 446;    //    [SBAR_END]
// stock const m_izSBarState_1 = 447;    //    [SBAR_END]
// stock const m_izSBarState_2 = 448;    //    [SBAR_END]
enum sbar_data
{
	SBAR_ID_TARGETCLASS = 1,
	SBAR_ID_TARGEINDEX,
	SBAR_ID_TARGETHEALTH,
	SBAR_END,
};
stock const m_izSBarState[SBAR_END] = {446,447,448}
stock const m_flNextSBarUpdateTime = 449;
stock const m_flStatusBarDisappearDelay = 450;
stock const m_SbarString0 = 1804; // 451*4   //    [SBAR_STRING_SIZE]    //    128 char // 32
stock const m_lastx = 483;
stock const m_lasty = 484;    //    483    484    //    These    are    the    previous    update's    crosshair    angles,    DON"T    SAVE/RESTORE
stock const m_nCustomSprayFrames = 485;    //    Custom    clan    logo    frames    for    this    player
stock const m_flNextDecalTime = 486;    //    next    time    this    player    can    spray    a    decal    //    382
stock const m_szTeamName = 1948;    //    m_szTeamName[16]
stock const g_szModelIndexPlayer = 491;    //    psz
stock const m_szShieldAnimExt = 1968;    //    m_szShieldAnimExt[32]    
stock const m_iGaitSequence = 500;
stock const m_flGaitFrame = 501;
stock const m_flGaitYaw = 502;
stock const m_flPrevGaitOrigin[3] = {503,504,505};
stock const m_flPitch = 506;
stock const m_flYaw = 507;
stock const m_flGaitMovement = 508;
stock const m_fAutoWeaponSwitch = 509;
//    stock const m_boolsUserPrefsAndShield                510    //    m_bHasVGUIMenus    (1<<0)    //    m_bHasAutoHelp    (1<<8)    //    m_bUsesShield    (1<<16)    //    m_bHasShield    (1<<24)
stock const m_bHasVGUIMenus = 2040;        //    [g/s]et_pdata_bool
stock const m_bHasAutoHelp = 2041;        //    [g/s]et_pdata_bool
stock const m_bUsesShield = 2042;        //    [g/s]et_pdata_bool
stock const m_bHasShield = 2043;        //    [g/s]et_pdata_bool

// stock const m_bObserverHasTarget = 2044; // to do, make sur this offset is not a bool
stock const m_fObserverHasTarget = 511;

stock const m_flFindNextPlayerTime = 512;
stock const m_flDtMultiplier = 513;
stock const m_flFlashedUntil = 514;
stock const m_flFlashedAt = 515;
stock const m_flFlashHoldTime = 516;
stock const m_flFlashDuration = 517;
stock const m_iFlashAlpha = 518;
stock const m_flNextAutoFollowTime = 519;
stock const m_szAutoBuyData = 2080;    //    m_szAutoBuyData[256] // stock const m_szAutoBuyData[256] = {2080,2081,...} ?
stock const m_pSomeRebuyPointer = 584;    //    Rebuy    stuff    CBasePlayer::Rebuy    CBasePlayer::RebuyInitData    ClientPutInServer
stock const m_iRebuyLastPrimaryItemId = 585;
stock const m_iRebuyLastPrimaryItemAmmo = 586;
stock const m_iRebuyLastSecondaryItemId = 587;
stock const m_iRebuyLastSecondaryItemAmmo = 588;
stock const m_iRebuyHEGrenadeAmmo = 589;
stock const m_iRebuyFlashbangAmmo = 590;
stock const m_iRebuySmokeGrenadeAmmo = 591;
stock const m_iRebuyDefuseKit = 592;
stock const m_iRebuyNVGoggles = 593;
stock const m_iRebuyKevlar = 594;
stock const m_bRebuyStructBuilt = 595;
stock const m_flNextLocationUpdateTime = 596;
stock const m_szLocation = 2388;                //    597-604    m_szLocation[28]    
stock const m_flProgressBarStartTime = 605;
stock const m_flProgressBarEndTime = 606;
// stock const m_boolsObserver607 = 607    //    m_bObserverAutoDirector    (1<<0)    //    m_bCanSwitchObserverModes    (1<<8)
stock const m_bObserverAutoDirector = 2428;    //    [g/s]et_pdata_bool
stock const m_bCanSwitchObserverModes = 2429;    //    [g/s]et_pdata_bool
//    608
stock const m_flIntense = 609;    // win    //    ?void?    CBasePlayer::Intense()    {    m_flIntense    =    gpGlobals->time    }
//    610
//    611
stock const m_flNextSayTime = 612;
stock const m_flNextSayTeamTime = 613;
stock const m_flNextFullUpdateTime = 614;
stock const m_flNextVoteTimeCmd = 615;
stock const m_flNextVoteMapTime = 616;
stock const m_flNextListMapsTime = 617;
stock const m_flNextListPlayersTime = 618;
stock const m_flNextNightVisionTime = 619; 