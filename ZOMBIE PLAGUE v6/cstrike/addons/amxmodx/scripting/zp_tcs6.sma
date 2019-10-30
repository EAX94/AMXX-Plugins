#include <zp6>

#define MAX_USERS 					27
#define MODELS_CHANGE_DELAY		0.5

new const PLUGIN_VERSION[] = "v6.0.05";

/*	
	Revisar multiplicador de maestría, no lo da
	
	Se puede mostrar en el chat los logros de "PRIMERO: ..." aunque no los tengas
*/

new g_IsConnected[MAX_USERS];
new g_IsAlive[MAX_USERS];
new g_Health[MAX_USERS];
new g_Zombie[MAX_USERS];
new g_Kiske[MAX_USERS];
new g_UserName[MAX_USERS][32];
new g_UserModel[MAX_USERS][32];
new g_SteamId[MAX_USERS][64];
new g_AccountPassword[MAX_USERS][32];
new g_AccountHID[MAX_USERS][64];
new g_DisconnectHID[MAX_USERS][64];
new g_AccountBan_Start[MAX_USERS][32];
new g_AccountBan_Finish[MAX_USERS][32];
new g_AccountBan_Admin[MAX_USERS][32];
new g_AccountBan_Reason[MAX_USERS][128];
new g_AccountBan_PJName[MAX_USERS][32];
new g_AccountLogged[MAX_USERS];
new g_AccountPJ_Logged[MAX_USERS];
new g_UserSelected[MAX_USERS];
new g_AccountBan[MAX_USERS];
new g_AccountName[MAX_USERS][32];
new g_AccountPJs[MAX_USERS][4];
new g_AccountId[MAX_USERS];
new g_AccountPJ_Name[MAX_USERS][4][32];
new g_AccountPJ_Level[MAX_USERS][4];
new g_AccountPJ_Reset[MAX_USERS][4];
new g_AccountBanned[MAX_USERS];
new g_SysTime_Connect[MAX_USERS];
new g_SysTime_Connect2[MAX_USERS];
new g_RespawnAsZombie[MAX_USERS];
new g_HumanClass[MAX_USERS];
new g_HumanClassNext[MAX_USERS];
new g_ClassName[MAX_USERS][32];
new g_Immunity[MAX_USERS];
new g_UserSolid[MAX_USERS];
new g_UserRestore[MAX_USERS];
new g_SpecialMode[MAX_USERS];
new g_LastHuman[MAX_USERS];
new g_LastZombie[MAX_USERS];
new g_FirstZombie[MAX_USERS];
new g_Frozen[MAX_USERS];
new g_InBubble[MAX_USERS];
new g_PrimaryWeapon[MAX_USERS];
new g_WeaponPrimaryActual[MAX_USERS];
new g_WeaponSecondaryActual[MAX_USERS];
new g_CurrentWeapon[MAX_USERS];
new g_ComboDamage[MAX_USERS];
new g_AmmosDamage[MAX_USERS];
new g_ComboNeedDamage[MAX_USERS];
new g_Combo[MAX_USERS];
new g_ComboReward[MAX_USERS];
new g_GroupComboReward[14];
new g_Vinc[MAX_USERS];
new g_WeaponPrimary_Selection[MAX_USERS];
new g_WeaponSecondary_Selection[MAX_USERS];
new g_WeaponTerciary_Selection[MAX_USERS];
new g_ZombieClass[MAX_USERS];
new g_ZombieClassNext[MAX_USERS];
new g_AllowChangeTeam[MAX_USERS];
new g_AllowChangeName[MAX_USERS];
new g_AllowChangeName_SPECIAL[MAX_USERS];
new g_LongJump[MAX_USERS];
new g_InJump[MAX_USERS];
new g_Nightvision[MAX_USERS];
new g_WeaponAutoBuy[MAX_USERS];
new g_CanBuy[MAX_USERS];
new g_Level[MAX_USERS];
new g_Reset[MAX_USERS];
new g_UnlimitedClip[MAX_USERS];
new g_Annihilation_Bomb[MAX_USERS];
new g_Antidote_Bomb[MAX_USERS];
new g_AmmoPacks_Rest_Dot[MAX_USERS][32];
new g_Bubble_Bomb[MAX_USERS];
new g_SuperNova_Bomb[MAX_USERS];
new g_NightvisionOn[MAX_USERS];
new g_HealthHud[MAX_USERS][11];
new g_AmmoPacksHud[MAX_USERS][32];
new g_Hab_Reset[MAX_USERS][2];
new g_InGroup[MAX_USERS];
new g_GroupInvitations[MAX_USERS];
new g_GroupInvitationsId[MAX_USERS][MAX_USERS]; // Si [YO][EL] está en uno, significa que me invitó al grupo!
new g_MyGroup[MAX_USERS];
new g_GroupId[14][4];
new g_InClan[MAX_USERS];
new g_ClanId[MAX_USERS];
new g_ClanName[MAX_USERS][32];
new g_ClanRank[MAX_USERS];
new g_ClanTulio[MAX_USERS];
new g_ClanOnline[MAX_USERS];
new g_ClanInPos[MAX_USERS];
new g_ClanMembers[MAX_USERS];
new g_ClanMemberName[MAX_USERS][16][32];
new g_Rank[MAX_USERS];
new g_ClanInvitations[MAX_USERS];
new g_ClanInvitationsId[MAX_USERS][MAX_USERS]; // Si [YO][EL] está en uno, significa que me invitó al clan!
new g_ClanInfoCreateDate[MAX_USERS][32];
new g_CreateClanName[MAX_USERS][15];
new g_RegisterSince[MAX_USERS][32];
new g_HatNext[MAX_USERS];
new g_HatId[MAX_USERS];
new g_Options_Invis[MAX_USERS];
new g_Bazooka_Sprite_Color[MAX_USERS];
new g_HatEnt[MAX_USERS];
new g_ImmunityBombs[MAX_USERS];
new g_DeadTimes[MAX_USERS];
new g_Bazooka[MAX_USERS];
new g_SurvivorImmunity[MAX_USERS];
new g_Wesker_LASER[MAX_USERS];
new g_Jason_Teleport[MAX_USERS];
new g_WeaponSave[MAX_USERS][31];
new g_WeaponModel[MAX_USERS][31];
new g_MultPoints[MAX_USERS];
new g_RealMultPoints[MAX_USERS];
new g_WeaponTime[MAX_USERS];
new g_LastWeapon[MAX_USERS];
new g_Mastery[MAX_USERS];
new g_VisitDays[MAX_USERS];
new g_DayNow[MAX_USERS];
new g_RandomRespawn[MAX_USERS];
new g_BestAPs_History[MAX_USERS];
new g_BestAPs[MAX_USERS];
new g_Induccion[MAX_USERS];
new g_VigorChance[MAX_USERS];
new g_Alien[MAX_USERS];
new g_Predator[MAX_USERS];
new g_Alien_Power[MAX_USERS];
new g_Predator_Power[MAX_USERS];
new g_Survivor_KillZombies[MAX_USERS];
new g_Nemesis_KillHumans[MAX_USERS];
new g_Wesker_LASER_Waste[MAX_USERS];
new g_AmmoPacks[MAX_USERS];
new g_AmmoPacks_Rest[MAX_USERS];
new g_ProxPrimaryWeapon[MAX_USERS];
new g_ProxSecondaryWeapon[MAX_USERS];
new g_HatDevil[MAX_USERS];
new g_InfectsWithSameFury[MAX_USERS];
new g_BuyAllFuryInSameRound[MAX_USERS];
new g_Troll_Power[MAX_USERS];
new g_ExtraCombo[MAX_USERS];
new g_AnotherUserInYourAccount[MAX_USERS];
new g_AnotherUserInYourAccount_Name[MAX_USERS][32];
new g_MaxHealth[MAX_USERS];
new g_Mercenario_Infects[MAX_USERS];
new g_Mercenario_Kills[MAX_USERS];
new g_MiSuerteEsUnica_Kills[MAX_USERS];
new g_LaSaludEsLoPrimero[MAX_USERS];
new g_Impecable[MAX_USERS];
new g_YElSurvivor[MAX_USERS];
new g_PumHeadshot[MAX_USERS];
new g_SinHacerDamage[MAX_USERS];
new g_AlvsPred_Kills[MAX_USERS];
new g_Alien_WithFury_HumanKills[MAX_USERS];
new g_YElNemesis[MAX_USERS];
new g_InfectsWithFury[MAX_USERS];
new g_InfectsWithMaxHealth[MAX_USERS];
new g_FuryConsecutive[MAX_USERS];
new g_Swarm_HumansKills[MAX_USERS];
new g_Armageddon_SurvivorKills[MAX_USERS];
new g_InfectsInRound[MAX_USERS];
new g_GroupHUD[14][128];
new g_BlockSound[MAX_USERS];
new g_RegisterDate[MAX_USERS];

new Float:g_Speed[MAX_USERS];
new Float:g_Level_Percent[MAX_USERS];
new Float:g_Reset_Percent[MAX_USERS];
new Float:g_FrozenGravity[MAX_USERS];
new Float:g_SpeedGravity[MAX_USERS];
new Float:g_NightvisionNoFlood[MAX_USERS];
new Float:g_MultAps[MAX_USERS];
new Float:g_ExtraMultAps[MAX_USERS];
new Float:g_Clan_QueryFlood[MAX_USERS];
new Float:g_SysTime_Tops[MAX_USERS];
new Float:g_SysTime_Link[MAX_USERS];
new Float:g_PlayedTime_PerDay[MAX_USERS];
new Float:g_HLTime_Combo[MAX_USERS];
new Float:g_HLTime_GroupCombo[14];
new Float:g_BonusDays[MAX_USERS];
new Float:g_Vigor[MAX_USERS];
new Float:g_DamageReduce[MAX_USERS];
new Float:g_Wesker_LastLASER[MAX_USERS];
new Float:g_KnockbackVelocity[MAX_USERS][3];
new Float:g_Legado_MultAps[MAX_USERS];
new Float:g_AlienOrigin[MAX_USERS][3];

new Float:g_Spawns[64][3];
new Float:g_TeamsTargetTime;
new Float:g_ModelsTargetTime;
new Float:g_LastMode_CD = 0.0;
new Float:g_MapExtraAPs;
new Float:g_LastInfectionExplosion;
new Float:g_CAN_Aps;

new g_Lights[1];
new g_SqlError[512];
new g_MessageHID[64];
new g_MapName[32];

new g_fwSpawn;
new g_fwPrecacheSound;
new g_fwUpdateClientData_Post;
new g_ScoreHumans;
new g_ScoreZombies;
new g_MaxUsers;
new g_SwitchingTeams;
new g_Message_ScoreInfo;
new g_Message_TeamInfo;
new g_Message_DeathMsg;
new g_Message_ScoreAttrib;
new g_Message_ScreenFade;
new g_Message_ScreenShake;
new g_Message_NVGToggle;
new g_Message_Flashlight;
new g_Message_FlashBat;
new g_Message_AmmoPickup;
new g_Message_HideWeapon;
new g_Message_Crosshair;
new g_Message_Money;
new g_Message_CurWeapon;
new g_Message_WeapPickup;
new g_Message_TextMsg;
new g_Message_SendAudio;
new g_Message_TeamScore;
new g_Message_Fov;
new g_Message_WeaponList;
new g_Message_ShowMenu;
new g_Message_VGUIMenu;
new g_Message_StatusIcon;
new g_NewRound;
new g_EndRound;
new g_CVAR_Delay;
new g_Hud_Notification;
new g_EndRound_Forced;
new g_FirstInfect;
new g_SpawnCount;
new g_Hud_General;
new g_Hud_Combo;
new g_Link_AchievementId;
new g_Bazooka_InAir;
new g_LastMode;
new g_Mode;
new g_TOP_MaxComboHPerMap;
new g_TOP_MaxComboZPerMap;
new g_MapExtraHealth;
new g_Nemesis_LongJump_Count;
new g_InfectionExplode_Count;
new g_InfectionExplode_Ids[3];
new g_MasteryType = -1;
new g_CAN_Points;
new g_LogSay;
new g_ModeStart_SysTime;
new g_FirstZombie_Consecutive;

new Trie:g_tArmageddonCant;

new Handle:g_SqlTuple;
new Handle:g_SqlConnection;

enum _:structAchievements {
	achievementName[64],
	achievementDesc[128],
	Float:achievementMult,
	achievementUut,
	achievementUsersNeed,
	achievementClass
};

enum _:achievementsClassIds {
	ACHIEVEMENT_HUMAN = 0,
	ACHIEVEMENT_ZOMBIE,
	ACHIEVEMENT_SURVIVOR,
	ACHIEVEMENT_NEMESIS,
	ACHIEVEMENT_WESKER,
	ACHIEVEMENT_JASON,
	ACHIEVEMENT_OTROS,
	ACHIEVEMENT_PRIMEROS,
	ACHIEVEMENT_BETA,
	ACHIEVEMENT_ITEMS_EXTRAS,
	ACHIEVEMENT_ALVSPRED,
	ACHIEVEMENT_WEAPONS
};

enum _:achievementsIds {
	BETA_TESTER = 0, BETA_TESTER_AVANZADO, PRIMERO_BETA_TESTER_AVANZADO, VISION_NOCTURNA_x10, LONG_JUMP_x10, BOMBA_DE_ANIQUILACION_x10, BALAS_INFINITAS_x10, BOMBA_ANTIDOTO_x10, INMUNIDAD_x10, ANTIDOTO_x10, FURIA_x10,
	BOMBA_DE_INFECCION_x10, VINCULADO, PETRIFICACION_x10, VISION_NOCTURNA_x50, LONG_JUMP_x50, BOMBA_DE_ANIQUILACION_x50, BALAS_INFINITAS_x50, BOMBA_ANTIDOTO_x50, INMUNIDAD_x50, ANTIDOTO_x50, FURIA_x50, BOMBA_DE_INFECCION_x50, CUENTA_PAR,
	PETRIFICACION_x50, VISION_NOCTURNA_x100, LONG_JUMP_x100, BOMBA_DE_ANIQUILACION_x100, BALAS_INFINITAS_x100, BOMBA_ANTIDOTO_x100, INMUNIDAD_x100, ANTIDOTO_x100, FURIA_x100, BOMBA_DE_INFECCION_x100, CUENTA_IMPAR, PETRIFICACION_x100,
	ITEMS_EXTRAS_x10, ITEMS_EXTRAS_x50, ITEMS_EXTRAS_x100, ITEMS_EXTRAS_x500, ITEMS_EXTRAS_x1000, ITEMS_EXTRAS_x5000,
	RESET_x1, RESET_x2, RESET_x3, RESET_x4, RESET_x5, RESET_x10, RESET_x20, RESET_x30, RESET_x40, RESET_x50, 
	ESTOY_MUY_SOLO,	FOREVER_ALONE, CREO_QUE_TENGO_UN_PROBLEMA, SOLO_EL_ZP_ME_ENTIENDE, MERCENARIO, LOS_PRIMEROS, VAMOS_POR_MAS, EXPERTO_EN_LOGROS, THIS_IS_SPARTA, SOY_DORADO, QUE_SUERTE, EASTER_EGG, PRIMERO_EASTER_EGG,
	LIDER_EN_CABEZAS, AGUJEREANDO_CABEZAS, MORTIFICANDO_ZOMBIES, CABEZAS_ZOMBIES,
	ZOMBIES_x100, ZOMBIES_x500, ZOMBIES_x1000, ZOMBIES_x2500, ZOMBIES_x5000, ZOMBIES_x10K, ZOMBIES_x25K, ZOMBIES_x50K, ZOMBIES_x100K, ZOMBIES_x250K, ZOMBIES_x500K, ZOMBIES_x1M, ZOMBIES_x5M,
	MIRA_MI_DANIO, MAS_Y_MAS_DANIO, LLEGUE_AL_MILLON, MI_DANIO_CRECE, MI_DANIO_CRECE_Y_CRECE, VAMOS_POR_LOS_50_MILLONES, CONTADOR_DE_DANIOS, YA_PERDI_LA_CUENTA, MI_DANIO_ES_CATASTROFICO, MI_DANIO_ES_NUCLEAR, MUCHOS_NUMEROS, SE_ME_BUGUEO_EL_DANIO,
	ME_ABURRO, NO_SE_LEER_ESTE_NUMERO, MI_CUCHILLO_ES_ROJO, AFILANDO_MI_CUCHILLO, ACUCHILLANDO, ME_ENCANTAN_LAS_TRIPAS, HUMMILACION, CLAVO_QUE_TE_CLAVO_LA_SOMBRILLA, ENTRA_CUCHILLO_SALEN_LAS_TRIPAS, HUMILIATION_DEFEAT, CUCHILLO_DE_COCINA, CUCHILLO_PARA_PIZZA,
	YOCUCHI, MI_SUERTE_ES_UNICA, ODIO_SER_ZOMBIE, NO_LA_NECESITO, LA_SALUD_ES_LO_PRIMERO, AFILATE_LAS_GARRAS, TENGO_BALAS_PARA_TODOS, SOLO_HAY_UNA_EXPLICACION, HASTA_ACA_LLEGARON, IMPECABLE,
	CABEZITA, A_PLENO, ROMPIENDO_CABEZAS, ABRIENDO_CEREBROS, PERFORANDO, DESCOCANDO, ROMPECRANEOS, DUCK_HUNT, AIMBOT, DIEZ_A_LA_Z, Y_EL_SURVIVOR, CIEN_NEMESIS, DONT_TOUCH_ME, SIN_BOMBA,
	SURVIVOR_PRINCIPIANTE, SURVIVOR_AVANZADO, SURVIVOR_EXPERTO, SURVIVOR_PRO, LEYENDA_SURVIVOR, CRATER_SANGRIENTO, LA_EXPLOSION_NO_MATA, NEMESIS_PRINCIPIANTE, NEMESIS_AVANZADO, NEMESIS_EXPERTO, NEMESIS_PRO, LEYENDA_NEMESIS, LA_EXPLOSION_SI_MATA,
	LA_BAZOOKA_MAS_RAPIDA, MI_DEAGLE_Y_YO, PUM_HEADSHOT, VOS_NO_PASAS, SUPER_LASER, DEAGLE_COMBERA, INTACTO, NO_ME_HACE_FALTA, DK_BUGUEADA, YO_Y_MI_MOTOSIERRA, JASON_EL_TRANSPORTADOR, MOTOSIERRA_COMBERA, CUCHILLO_QUE_NO_CORTA, PRIMERO_QUE_SUERTE,
	ALIENIGENA, DEPREDADOR, ALIEN_ENTRENADO, SUPER_ALIEN_86, RAPIDO_Y_ALIENOSO, FURIA, ROJO_BAH, NO_TE_VEO_PERO_TE_HUELO, ESTOY_RE_LOCO, SARGENTO_DEPRE, DEPREDADOR_007, AHORA_ME_VES_AHORA_NO_ME_VES, MI_HABILIDAD_ES_MEJOR, Y_EL_NEMESIS,
	ARE_YOU_FUCKING_KIDDING_ME, VI_MEJORES, JASON_LA_PELICULA, CAZADOR, PENSANDOLO_BIEN, YO_NO_FUI, YO_FUI, 
	HUMANOS_x100, HUMANOS_x500, HUMANOS_x1000, HUMANOS_x2500, HUMANOS_x5000, HUMANOS_x10K, HUMANOS_x25K, HUMANOS_x50K, HUMANOS_x100K, HUMANOS_x250K, HUMANOS_x500K, HUMANOS_x1M, HUMANOS_x5M, BOMBA_FALLIDA, ME_ESTA_GUSTANDO_ESTO,
	SACANDO_PROTECCION, ESO_NO_TE_SIRVE_DE_NADA, NO_ES_UN_PROBLEMA_PARA_MI, SIN_DEFENSAS, DESGARRANDO_CHALECO, TOTALMENTE_INDEFENSO, Y_LA_LIMPIEZA, YO_USO_CLEAR_ZOMBIE, ANTIDOTO_PARA_TODOS, YA_DE_ZOMBIE, APLICANDO_MAFIA,
	LA_MEJOR_OPCION, UNA_DE_LAS_MEJORES, MI_PREFERIDA, LA_MEJOR, PRIMERO_LA_MEJOR_OPCION, PRIMERO_UNA_DE_LAS_MEJORES, PRIMERO_MI_PREFERIDA, PRIMERO_LA_MEJOR,
	LA_MEJOR_OPCION_x5, UNA_DE_LAS_MEJORES_x5, MI_PREFERIDA_x5, LA_MEJOR_x5, LA_MEJOR_OPCION_x10, UNA_DE_LAS_MEJORES_x10, MI_PREFERIDA_x10, LA_MEJOR_x10,
	LA_MEJOR_OPCION_x15, UNA_DE_LAS_MEJORES_x15, MI_PREFERIDA_x15, LA_MEJOR_x15, LA_MEJOR_OPCION_x20, UNA_DE_LAS_MEJORES_x20, MI_PREFERIDA_x20, LA_MEJOR_x20,
	ROJO_Y_VIOLENTO, CIEN_SURVIVOR, QUE_ARMA_ES_ESA, VIRUS
};

new const __ACHIEVEMENTS[achievementsIds][structAchievements] = {
	{"BETA TESTER", "Participa en la BETA del ZP v6", 0.0066, 1, 0, ACHIEVEMENT_BETA},
	{"BETA TESTER AVANZADO", "Acumula cinco horas jugadas en la BETA del ZP v6", 0.0066, 2, 0, ACHIEVEMENT_BETA},
	{"PRIMERO: BETA TESTER AVANZADO", "Primero del servidor en acumular cinco horas jugadas^nen la BETA del ZP v6", 0.0066, 3, 0, ACHIEVEMENT_PRIMEROS},
	{"VISIÓN NOCTURNA x10", "Compra 10 veces el item extra Visión Nocturna", 0.0066, 1, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"LONG JUMP x10", "Compra 10 veces el item extra Long Jump", 0.0066, 1, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"BOMBA DE ANIQUILACIÓN x10", "Compra 10 veces el item extra Bomba de Aniquilación", 0.0066, 1, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"BALAS INFINITAS x10", "Compra 10 veces el item extra Balas Infinitas", 0.0066, 1, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"BOMBA ANTIDOTO x10", "Compra 10 veces el item extra Bomba Antidoto", 0.0066, 1, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"INMUNIDAD x10", "Compra 10 veces el item extra Inmunidad", 0.0066, 1, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"ANTIDOTO x10", "Compra 10 veces el item extra Antidoto", 0.0066, 1, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"FURIA x10", "Compra 10 veces el item extra Furia", 0.0066, 1, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"BOMBA DE INFECCIÓN x10", "Compra 10 veces el item extra Bomba de Infección", 0.0066, 1, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"VINCULADO", "Vincula tu cuenta del ZP v6 a la web CIMSP | \yzp.cimsp.net/panel", 0.2, 1, 0, ACHIEVEMENT_OTROS},
	{"PETRIFICACIÓN x10", "Compra 10 veces el item extra Petrificación", 0.0066, 1, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"VISIÓN NOCTURNA x50", "Compra 50 veces el item extra Visión Nocturna", 0.0066, 3, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"LONG JUMP x50", "Compra 50 veces el item extra Long Jump", 0.0066, 3, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"BOMBA DE ANIQUILACIÓN x50", "Compra 50 veces el item extra Bomba de Aniquilación", 0.0066, 3, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"BALAS INFINITAS x50", "Compra 50 veces el item extra Balas Infinitas", 0.0066, 3, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"BOMBA ANTIDOTO x50", "Compra 50 veces el item extra Bomba Antidoto", 0.0066, 3, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"INMUNIDAD x50", "Compra 50 veces el item extra Inmunidad", 0.0066, 3, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"ANTIDOTO x50", "Compra 50 veces el item extra Antidoto", 0.0066, 3, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"FURIA x50", "Compra 50 veces el item extra Furia", 0.0066, 3, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"BOMBA DE INFECCIÓN x50", "Compra 50 veces el item extra Bomba de Infección", 0.0066, 3, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"CUENTA PAR", "Tu cuenta es un número par", 0.0066, 1, 0, ACHIEVEMENT_OTROS},
	{"PETRIFICACIÓN x50", "Compra 50 veces el item extra Petrificación", 0.0066, 3, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"VISIÓN NOCTURNA x100", "Compra 100 veces el item extra Visión Nocturna", 0.0066, 5, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"LONG JUMP x100", "Compra 100 veces el item extra Long Jump", 0.0066, 5, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"BOMBA DE ANIQUILACIÓN x100", "Compra 100 veces el item extra Bomba de Aniquilación", 0.0066, 5, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"BALAS INFINITAS x100", "Compra 100 veces el item extra Balas Infinitas", 0.0066, 5, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"BOMBA ANTIDOTO x100", "Compra 100 veces el item extra Bomba Antidoto", 0.0066, 5, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"INMUNIDAD x100", "Compra 100 veces el item extra Inmunidad", 0.0066, 5, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"ANTIDOTO x100", "Compra 100 veces el item extra Antidoto", 0.0066, 5, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"FURIA x100", "Compra 100 veces el item extra Furia", 0.0066, 5, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"BOMBA DE INFECCIÓN x100", "Compra 100 veces el item extra Bomba de Infección", 0.0066, 5, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"CUENTA IMPAR", "Tu cuenta es un número impar", 0.0066, 1, 0, ACHIEVEMENT_OTROS},
	{"PETRIFICACIÓN x100", "Compra 100 veces el item extra Petrificación", 0.0066, 5, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"ITEMS EXTRAS x10", "Compra 10 veces todos los items extras", 0.0066, 1, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"ITEMS EXTRAS x50", "Compra 50 veces todos los items extras", 0.0066, 3, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"ITEMS EXTRAS x100", "Compra 100 veces todos los items extras", 0.0066, 5, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"ITEMS EXTRAS x500", "Compra 500 veces todos los items extras", 0.0066, 10, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"ITEMS EXTRAS x1.000", "Compra 1.000 veces todos los items extras", 0.0066, 25, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"ITEMS EXTRAS x5.000", "Compra 5.000 veces todos los items extras", 0.0066, 50, 0, ACHIEVEMENT_ITEMS_EXTRAS},
	{"RESET x1", "Alcanza el reset 1", 0.0066, 1, 0, ACHIEVEMENT_OTROS},
	{"RESET x2", "Alcanza el reset 2", 0.0066, 2, 0, ACHIEVEMENT_OTROS},
	{"RESET x3", "Alcanza el reset 3", 0.0066, 3, 0, ACHIEVEMENT_OTROS},
	{"RESET x4", "Alcanza el reset 4", 0.0066, 4, 0, ACHIEVEMENT_OTROS},
	{"RESET x5", "Alcanza el reset 5", 0.0066, 5, 0, ACHIEVEMENT_OTROS},
	{"RESET x10", "Alcanza el reset 10", 0.0066, 10, 0, ACHIEVEMENT_OTROS},
	{"RESET x20", "Alcanza el reset 20", 0.0066, 20, 0, ACHIEVEMENT_OTROS},
	{"RESET x30", "Alcanza el reset 30", 0.0066, 30, 0, ACHIEVEMENT_OTROS},
	{"RESET x40", "Alcanza el reset 40", 0.0066, 40, 0, ACHIEVEMENT_OTROS},
	{"RESET x50", "Alcanza el reset 50", 0.0066, 50, 0, ACHIEVEMENT_OTROS},
	{"ESTOY MUY SOLO", "Juega 7 días", 0.0066, 5, 0, ACHIEVEMENT_OTROS},
	{"FOREVER ALONE", "Juega 15 días", 0.0066, 5, 0, ACHIEVEMENT_OTROS},
	{"CREO QUE TENGO UN PROBLEMA", "Juega 30 días", 0.0066, 5, 0, ACHIEVEMENT_OTROS},
	{"SOLO EL ZP ME ENTIENDE", "Juega 50 días", 0.0066, 5, 0, ACHIEVEMENT_OTROS},
	{"MERCENARIO", "Mata a 10 zombies e infecta a 10 humanos en una ronda", 0.0066, 1, 0, ACHIEVEMENT_OTROS},
	{"LOS PRIMEROS", "Completa 25 logros", 0.0066, 0, 0, ACHIEVEMENT_OTROS},
	{"VAMOS POR MÁS", "Completa 75 logros", 0.0066, 0, 0, ACHIEVEMENT_OTROS},
	{"EXPERTO EN LOGROS", "Completa 150 logros", 0.0066, 0, 0, ACHIEVEMENT_OTROS},
	{"THIS IS SPARTA", "Completa 300 logros", 0.0066, 0, 0, ACHIEVEMENT_OTROS},
	{"SOY DORADO", "Ser usuario PREMIUM", 0.0066, 1, 0, ACHIEVEMENT_OTROS},
	{"QUE SUERTE", "Mata a un modo de cada tipo", 0.0066, 1, 0, ACHIEVEMENT_OTROS},
	{"EASTER EGG", "Descubre el \yEaster Egg\w del mapa \yzm_kontrax_b6", 0.0066, 25, 0, ACHIEVEMENT_OTROS}, // COMPLETAR
	{"PRIMERO: EASTER EGG", "Primero del servidor en descubrir el \yEaster Egg\w^n del mapa \yzm_kontrax_b6", 0.0066, 0, 0, ACHIEVEMENT_OTROS}, // COMPLETAR
	{"LÍDER EN CABEZAS", "Mata a 1.000 zombies con disparos en la cabeza", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"AGUJEREANDO CABEZAS", "Mata a 10.000 zombies con disparos en la cabeza", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"MORTIFICANDO ZOMBIES", "Mata a 50.000 zombies con disparos en la cabeza", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"CABEZAS ZOMBIES", "Mata a 100.000 zombies con disparos en la cabeza", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"100 ZOMBIES", "Mata a 100 zombies", 0.0066, 1, 0, ACHIEVEMENT_HUMAN},
	{"500 ZOMBIES", "Mata a 500 zombies", 0.0066, 3, 0, ACHIEVEMENT_HUMAN},
	{"1.000 ZOMBIES", "Mata a 1.000 zombies", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"2.500 ZOMBIES", "Mata a 2.500 zombies", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"5.000 ZOMBIES", "Mata a 5.000 zombies", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"10.000 ZOMBIES", "Mata a 10.000 zombies", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"25.000 ZOMBIES", "Mata a 25.000 zombies", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"50.000 ZOMBIES", "Mata a 50.000 zombies", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"100.000 ZOMBIES", "Mata a 100.000 zombies", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"250.000 ZOMBIES", "Mata a 250.000 zombies", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"500.000 ZOMBIES", "Mata a 500.000 zombies", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"1.000.000 DE ZOMBIES", "Mata a 1.000.000 de zombies", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"5.000.000 DE ZOMBIES", "Mata a 5.000.000 de zombies", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},	
	{"MIRA MI DAÑO", "Realiza 100.000 de daño", 0.0066, 1, 0, ACHIEVEMENT_HUMAN},
	{"MÁS Y MÁS DAÑO", "Realiza 500.000 de daño", 0.0066, 3, 0, ACHIEVEMENT_HUMAN},
	{"LLEGUÉ AL MILLÓN", "Realiza 1.000.000 de daño", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"MI DAÑO CRECE", "Realiza 5.000.000 de daño", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"MI DAÑO CRECE Y CRECE", "Realiza 25.000.000 de daño", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"VAMOS POR LOS 50 MILLONES", "Realiza 50.000.000 de daño", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"CONTADOR DE DAÑOS", "Realiza 100.000.000 de daño", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"YA PERDÍ LA CUENTA", "Realiza 500.000.000 de daño", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"MI DAÑO ES CATASTRÓFICO", "Realiza 1.000.000.000 de daño", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"MI DAÑO ES NUCLEAR", "Realiza 5.000.000.000 de daño", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"MUCHOS NÚMEROS", "Realiza 20.000.000.000 de daño", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"¿SE ME BUGUEO EL DAÑO? ... BAZINGA", "Realiza 50.000.000.000 de daño", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"ME ABURROOOOO", "Realiza 100.000.000.000 de daño", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"NO SÉ LEER ESTE NÚMERO", "Realiza 214.748.364.800 de daño", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"MI CUCHILLO ES ROJO", "Mata a un NEMESIS con cuchillo", 0.0066, 1, 0, ACHIEVEMENT_HUMAN},
	{"AFILANDO MI CUCHILLO", "Mata a un zombie con cuchillo", 0.0066, 1, 0, ACHIEVEMENT_HUMAN},
	{"ACUCHILLANDO", "Mata a 30 zombies con cuchillo", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"ME ENCANTAN LAS TRIPAS", "Mata a 50 zombies con cuchillo", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"HUMILLACIÓN", "Mata a 100 zombies con cuchillo", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"CLAVO QUE TE CLAVO LA SOMBRILLA", "Mata a 150 zombies con cuchillo", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"ENTRA CUCHILLO, SALEN LAS TRIPAS", "Mata a 200 zombies con cuchillo", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"HUMILIATION DEFEAT", "Mata a 250 zombies con cuchillo", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"CUCHILLO DE COCINA", "Mata a 500 zombies con cuchillo", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"CUCHILLO PARA PIZZA", "Mata a 1.000 zombies con cuchillo", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"YOCUCHI", "Mata a 5.000 zombies con cuchillo", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"MI SUERTE ES ÚNICA", "Mata 5 NEMESIS en un mismo modo ARMAGEDDON", 0.0066, 1, 0, ACHIEVEMENT_HUMAN},
	{"ODIO SER ZOMBIE", "Utiliza tres antidotos en un mismo mapa", 0.0066, 1, 0, ACHIEVEMENT_HUMAN},
	{"NO LA NECESITO", "Has explotar la bomba de aniquilación sin matar a nadie", 0.0066, 1, 18, ACHIEVEMENT_HUMAN},
	{"LA SALUD ES LO PRIMERO", "Juega cinco rondas PRIMER ZOMBIE sin ser infectado^npor otro zombie y sin desconectarte", 0.0066, 2, 15, ACHIEVEMENT_HUMAN},
	{"AFÍLATE LAS GARRAS", "Finaliza una ronda PRIMER ZOMBIE con tu chaleco al máximo (200)", 0.0066, 1, 15, ACHIEVEMENT_HUMAN},
	{"TENGO BALAS PARA TODOS", "Mata a 50 NEMESIS", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"SOLO HAY UNA EXPLICACIÓN LÓGICA... ALIENS", "Mata a 30 ALIENS", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"HASTA ACÁ LLEGARON", "Mata a 15+ zombies con una bomba de aniquilación", 0.0066, 1, 0, ACHIEVEMENT_HUMAN},
	{"IMPECABLE", "Mata a 50+ zombies en una misma ronda", 0.0066, 1, 15, ACHIEVEMENT_HUMAN},
	{"CABEZITA", "Realiza 5.000 disparos en la cabeza", 0.0066, 1, 0, ACHIEVEMENT_HUMAN},
	{"A PLENO", "Realiza 15.000 disparos en la cabeza", 0.0066, 1, 0, ACHIEVEMENT_HUMAN},
	{"ROMPIENDO CABEZAS", "Realiza 50.000 disparos en la cabeza", 0.0066, 1, 0, ACHIEVEMENT_HUMAN},
	{"ABRIENDO CEREBROS", "Realiza 150.000 disparos en la cabeza", 0.0066, 3, 0, ACHIEVEMENT_HUMAN},
	{"PERFORANDO", "Realiza 300.000 disparos en la cabeza", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"DESCOCANDO", "Realiza 500.000 disparos en la cabeza", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"ROMPECRANEOS", "Realiza 1.000.000 disparos en la cabeza", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"DUCK HUNT", "Realiza 5.000.000 disparos en la cabeza", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"AIMBOT", "Realiza 10.000.000 disparos en la cabeza", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"10 A LA Z", "Mata diez zombies en una ronda PRIMER ZOMBIE", 0.0066, 1, 0, ACHIEVEMENT_HUMAN},
	{"¿Y EL SURVIVOR?", "Mata dos NEMESIS en el modo PLAGUE siendo humano", 0.0066, 1, 0, ACHIEVEMENT_HUMAN},
	{"100 NEMESIS", "Mata a 100 NEMESIS", 0.0066, 5, 0, ACHIEVEMENT_HUMAN},
	{"DON'T TOUCH ME", "Gana el modo SURVIVOR sin recibir daño", 0.0066, 5, 15, ACHIEVEMENT_SURVIVOR},
	{"SIN BOMBA", "Gana el modo SURVIVOR sin usar la bomba de aniquilación", 0.0066, 5, 15, ACHIEVEMENT_SURVIVOR},
	{"SURVIVOR PRINCIPIANTE", "Gana el modo SURVIVOR en dificultad NORMAL", 0.0066, 1, 18, ACHIEVEMENT_SURVIVOR},
	{"SURVIVOR AVANZADO", "Gana el modo SURVIVOR en dificultad AVANZADO", 0.0066, 3, 18, ACHIEVEMENT_SURVIVOR},
	{"SURVIVOR EXPERTO", "Gana el modo SURVIVOR en dificultad ÉPICO", 0.0066, 5, 18, ACHIEVEMENT_SURVIVOR},
	{"SURVIVOR PRO", "Gana el modo SURVIVOR en dificultad LEYENDA", 0.0066, 5, 18, ACHIEVEMENT_SURVIVOR},
	{"LEYENDA SURVIVOR", "Gana el modo SURVIVOR en dificultad LEYENDA sin usar la bomba de aniquilación", 0.0066, 5, 18, ACHIEVEMENT_SURVIVOR},
	{"CRATER SANGRIENTO", "Gana el modo NEMESIS sin utilizar la bazooka", 0.0066, 5, 15, ACHIEVEMENT_NEMESIS},
	{"LA EXPLOSIÓN NO MATA", "Lanza la bazooka sin matar a nadie", 0.0066, 1, 15, ACHIEVEMENT_NEMESIS},
	{"NEMESIS PRINCIPIANTE", "Gana el modo NEMESIS en dificultad NORMAL", 0.0066, 1, 18, ACHIEVEMENT_NEMESIS},
	{"NEMESIS AVANZADO", "Gana el modo NEMESIS en dificultad AVANZADO", 0.0066, 3, 18, ACHIEVEMENT_NEMESIS},
	{"NEMESIS EXPERTO", "Gana el modo NEMESIS en dificultad ÉPICO", 0.0066, 5, 18, ACHIEVEMENT_NEMESIS},
	{"NEMESIS PRO", "Gana el modo NEMESIS en dificultad LEYENDA", 0.0066, 5, 18, ACHIEVEMENT_NEMESIS},
	{"LEYENDA NEMESIS", "Gana el modo NEMESIS en dificultad LEYENDA^nutilizando un máximo de 15 long jumps", 0.0066, 5, 18, ACHIEVEMENT_NEMESIS},
	{"LA EXPLOSIÓN SI MATA", "Mata veinte humanos con tu bazooka", 0.0066, 1, 0, ACHIEVEMENT_NEMESIS},
	{"LA BAZOOKA MÁS RÁPIDA", "Gana el modo NEMESIS en menos de un minuto", 0.0066, 1, 18, ACHIEVEMENT_NEMESIS},
	{"MI DEAGLE Y YO", "Gana el modo WESKER", 0.0066, 1, 15, ACHIEVEMENT_WESKER},
	{"¡PUM, HEADSHOT!", "Mata a 10 zombies con disparos en la cabeza siendo WESKER", 0.0066, 2, 0, ACHIEVEMENT_WESKER},
	{"VOS NO PASAS", "Mata a un zombie con tu LASER", 0.0066, 1, 0, ACHIEVEMENT_WESKER},
	{"SÚPER LASER", "Desbloquea el SÚPER LASER del WESKER", 0.0066, 1, 0, ACHIEVEMENT_WESKER},
	{"DEAGLE COMBERA", "Desbloquea el COMBO del WESKER", 0.0066, 1, 0, ACHIEVEMENT_WESKER},
	{"INTACTO", "Gana el modo WESKER sin recibir daño", 0.0066, 1, 15, ACHIEVEMENT_WESKER},
	{"NO ME HACE FALTA", "Utiliza todos tus LASER sin matar a nadie", 0.0066, 1, 0, ACHIEVEMENT_WESKER},
	{"DK BUGUEADA", "Finaliza el modo WEKSER sin haber realizado daño", 0.0066, 1, 18, ACHIEVEMENT_WESKER},
	{"YO Y MI MOTOSIERRA", "Gana el modo JASON", 0.0066, 1, 15, ACHIEVEMENT_JASON},
	{"JASON EL TRANSPORTADOR", "Desbloquea la TELETRANSPORTACIÓN del JASON", 0.0066, 1, 0, ACHIEVEMENT_JASON},
	{"MOTOSIERRA COMBERA", "Desbloquea el COMBO del JASON", 0.0066, 1, 0, ACHIEVEMENT_JASON},
	{"CUCHILLO QUE NO CORTA", "Finaliza el modo JASON sin haber realizado daño", 0.0066, 1, 0, ACHIEVEMENT_JASON},
	{"PRIMERO: QUE SUERTE", "Primero del servidor en matar a un modo de cada tipo", 0.0066, 1, 0, ACHIEVEMENT_PRIMEROS},
	{"ALIENÍGENA", "Mata al DEPREDADOR siendo ALIEN", 0.0066, 1, 0, ACHIEVEMENT_ALVSPRED},
	{"DEPREDADOR", "Mata al ALIEN siendo DEPREDADOR", 0.0066, 1, 0, ACHIEVEMENT_ALVSPRED},
	{"ALIEN ENTRENADO", "Mata a 8 humanos siendo ALIEN", 0.0066, 1, 0, ACHIEVEMENT_ALVSPRED},
	{"SUPER ALIEN 86", "Mata a 12 humanos siendo ALIEN", 0.0066, 1, 0, ACHIEVEMENT_ALVSPRED},
	{"RÁPIDO Y ALIENOSO", "Mata al DEPREDADOR siendo ALIEN y^n sobrevive con 80%+ de vida", 0.0066, 1, 0, ACHIEVEMENT_ALVSPRED},
	{"¡¡FURIAAAA!!", "Desata el FRENESÍ DE LOCURA siendo ALIEN y^n mata a 3 humanos antes que se acabe", 0.0066, 1, 0, ACHIEVEMENT_ALVSPRED},
	{"¿ROJO? BAH!", "Desata el FRENESÍ DE LOCURA siendo ALIEN y^n no mates a nadie hasta que se acabe", 0.0066, 1, 0, ACHIEVEMENT_ALVSPRED},
	{"¡NO TE VEO, PERO TE HUELO!", "Mata al DEPREDADOR mientras está invisible", 0.0066, 5, 0, ACHIEVEMENT_ALVSPRED},
	{"¡ESTOY RE LOCO!", "Mata al DEPREDADOR mientras estás bajo los efectos^ndel FRENESÍ DE LOCURA", 0.0066, 1, 0, ACHIEVEMENT_ALVSPRED},
	{"SARGENTO DEPRE", "Mata a 8 zombies siendo DEPREDADOR", 0.0066, 1, 0, ACHIEVEMENT_ALVSPRED},
	{"DEPREDADOR 007", "Mata a 12 zombies siendo DEPREDADOR", 0.0066, 1, 0, ACHIEVEMENT_ALVSPRED},
	{"AHORA ME VES.. AHORA NO ME VES", "Utiliza la invisibilidad siendo DEPREDADOR y^nno recibas daño mientras dure", 0.0066, 1, 0, ACHIEVEMENT_ALVSPRED},
	{"MI HABILIDAD ES MEJOR", "Mata al ALIEN siendo DEPREDADOR mientras estás invisible", 0.0066, 1, 0, ACHIEVEMENT_ALVSPRED},
	{"¿Y EL NEMESIS?", "Mata a los SURVIVORS del modo PLAGUE siendo zombie", 0.0066, 1, 0, ACHIEVEMENT_ZOMBIE},
	{"ARE YOU FUCKING KIDDING ME?", "Consigue ser el PRIMER ZOMBIE", 0.0066, 1, 15, ACHIEVEMENT_ZOMBIE},
	{"VI MEJORES", "Mata a 30 WESKER", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"JASON, LA PELÍCULA", "Mata a 30 JASON", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"CAZADOR", "Mata a 50 SURVIVOR", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"PENSANDOLO BIEN...", "Utiliza tres furia zombie en un mismo mapa sin infectar a nadie", 0.0066, 1, 0, ACHIEVEMENT_ZOMBIE},
	{"YO NO FUI", "Infecta a 5 humanos sin morir con tu vida al máximo^nsin tener furia zombie activa y sin bomba", 0.0066, 2, 0, ACHIEVEMENT_ZOMBIE},
	{"YO FUI", "Utiliza dos furia zombie en una misma ronda e infecta a 15 humanos mientras duren sin bomba", 0.0066, 2, 0, ACHIEVEMENT_ZOMBIE},
	{"100 HUMANOS", "Infecta a 100 humanos", 0.0066, 1, 0, ACHIEVEMENT_ZOMBIE},
	{"500 HUMANOS", "Infecta a 500 humanos", 0.0066, 3, 0, ACHIEVEMENT_ZOMBIE},
	{"1.000 HUMANOS", "Infecta a 1.000 humanos", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"2.500 HUMANOS", "Infecta a 2.500 humanos", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"5.000 HUMANOS", "Infecta a 5.000 humanos", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"10.000 HUMANOS", "Infecta a 10.000 humanos", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"25.000 HUMANOS", "Infecta a 25.000 humanos", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"50.000 HUMANOS", "Infecta a 50.000 humanos", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"100.000 HUMANOS", "Infecta a 100.000 humanos", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"250.000 HUMANOS", "Infecta a 250.000 humanos", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"500.000 HUMANOS", "Infecta a 500.000 humanos", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"1.000.000 DE HUMANOS", "Infecta a 1.000.000 de humanos", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"5.000.000 DE HUMANOS", "Infecta a 5.000.000 de humanos", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"BOMBA FALLIDA", "Has explotar una bomba de infección sin infectar a nadie", 0.0066, 1, 0, ACHIEVEMENT_ZOMBIE},
	{"ME ESTÁ GUSTANDO ESTO", "Infecta a 10 humanos en una misma ronda, sin utilizar bombas", 0.0066, 1, 15, ACHIEVEMENT_ZOMBIE},
	{"SACANDO PROTECCIÓN", "Desgarra 500 de chaleco humano", 0.0066, 1, 0, ACHIEVEMENT_ZOMBIE},
	{"ESO NO TE SIRVE DE NADA", "Desgarra 2.000 de chaleco humano", 0.0066, 3, 0, ACHIEVEMENT_ZOMBIE},
	{"NO ES UN PROBLEMA PARA MI", "Desgarra 5.000 de chaleco humano", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"SIN DEFENSAS", "Desgarra 30.000 de chaleco humano", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"DESGARRANDO CHALECO", "Desgarra 60.000 de chaleco humano", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"TOTALMENTE INDEFENSO", "Desgarra 100.000 de chaleco humano", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"¿Y LA LIMPIEZA?", "Has explotar una bomba de antidoto sin desinfectar a nadie", 0.0066, 1, 0, ACHIEVEMENT_ZOMBIE},
	{"YO USO CLEAR ZOMBIE", "Has explotar una bomba antidoto y desinfecta a 15+ zombies", 0.0066, 1, 0, ACHIEVEMENT_ZOMBIE},
	{"ANTIDOTO PARA TODOS", "Has explotar una bomba antidoto y desinfecta a 20+ zombies", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"¿YA DE ZOMBIE?", "Consigue ser el PRIMER ZOMBIE dos veces seguidas", 0.0066, 1, 15, ACHIEVEMENT_ZOMBIE},
	{"APLICANDO MAFIA", "Mata cinco humanos en modo SWARM", 0.0066, 1, 15, ACHIEVEMENT_ZOMBIE},
	{"LA MEJOR OPCIÓN", "Sube un arma al nivel 5", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"UNA DE LAS MEJORES", "Sube un arma al nivel 10", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"MI PREFERIDA", "Sube un arma al nivel 15", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"LA MEJOR", "Sube un arma al nivel 20", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"PRIMERO: LA MEJOR OPCIÓN", "Primero del servidor en subir un arma al nivel 5", 0.0066, 0, 0, ACHIEVEMENT_PRIMEROS},
	{"PRIMERO: UNA DE LAS MEJORES", "Primero del servidor en subir un arma al nivel 10", 0.0066, 0, 0, ACHIEVEMENT_PRIMEROS},
	{"PRIMERO: MI PREFERIDA", "Primero del servidor en subir un arma al nivel 15", 0.0066, 0, 0, ACHIEVEMENT_PRIMEROS},
	{"PRIMERO: LA MEJOR", "Primero del servidor en subir un arma al nivel 20", 0.0066, 0, 0, ACHIEVEMENT_PRIMEROS},
	{"LA MEJOR OPCIÓN x5", "Sube cinco armas al nivel 5", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"UNA DE LAS MEJORES x5", "Sube cinco armas al nivel 10", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"MI PREFERIDA x5", "Sube cinco armas al nivel 15", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"LA MEJOR x5", "Sube cinco armas al nivel 20", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"LA MEJOR OPCIÓN x10", "Sube diez armas al nivel 5", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"UNA DE LAS MEJORES x10", "Sube diez armas al nivel 10", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"MI PREFERIDA x10", "Sube diez armas al nivel 15", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"LA MEJOR x10", "Sube diez armas al nivel 20", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"LA MEJOR OPCIÓN x15", "Sube quince armas al nivel 5", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"UNA DE LAS MEJORES x15", "Sube quince armas al nivel 10", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"MI PREFERIDA x15", "Sube quince armas al nivel 15", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"LA MEJOR x15", "Sube quince armas al nivel 20", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"LA MEJOR OPCIÓN x20", "Sube veinte armas al nivel 5", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"UNA DE LAS MEJORES x20", "Sube veinte armas al nivel 10", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"MI PREFERIDA x20", "Sube veinte armas al nivel 15", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"LA MEJOR x20", "Sube veinte armas al nivel 20", 0.0066, 5, 0, ACHIEVEMENT_WEAPONS},
	{"ROJO Y VIOLENTO", "En modo ARMAGEDDÓN, mata a cinco SURVIVOR", 0.0066, 1, 0, ACHIEVEMENT_NEMESIS},
	{"100 SURVIVOR", "Mata a 100 SURVIVOR", 0.0066, 5, 0, ACHIEVEMENT_ZOMBIE},
	{"¿QUÉ ARMA ES ESA?", "Comprueba el nombre de un arma presionando clic derecho^nmás el nombre del arma en el menú de compra", 0.0066, 1, 0, ACHIEVEMENT_WEAPONS},
	{"VIRUS", "Infecta a 20 humanos en una misma ronda PRIMER ZOMBIE^nsin morir, sin utilizar furia zombie ni bomba de infección", 0.0066, 5, 20, ACHIEVEMENT_ZOMBIE}
};

new g_Achievement[MAX_USERS][achievementsIds];
new g_AchievementUnlocked[MAX_USERS][achievementsIds][32];
new g_AchievementsIn[MAX_USERS];

new g_MenuPage_Special[MAX_USERS][achievementsClassIds];

new const ACHIEVEMENTS_MENU_NAMES[achievementsClassIds][] = {"Humanos", "Zombies", "Survivor", "Nemesis", "Wesker", "Jason", "Otros", "Primeros", "Beta", "Items Extras", "Alien vs. Depredador", "Armas"};

enum _:challengesIds {
	CHALLENGE_COMBO_BOMB = 0
};

new g_Challenge[MAX_USERS][challengesIds];
new g_ChallengeIn[MAX_USERS];

enum _:structChallenges {
	challengeName[32],
	challengeDesc[64],
	challengeReq,
	challengeUp,
	Float:challengeMult,
	challengeUsersNeed
};

new const __CHALLENGES[challengesIds][structChallenges] = {
	{"COMBÍMANO", "Consigue que una bomba combo afecte a [I] zombies", 10, 2, 0.008, 0}
};

enum _:hatIds {
	HAT_NONE = 0,
	HAT_AFRO,
	HAT_AWESOME,
	HAT_DARTH_VADER,
	HAT_DEVIL,
	HAT_PUMPKIN, // COMPLETAR - EVENTO : HALLOWEEN
	HAT_XMAS, // COMPLETAR - EVENTO : NAVIDAD
	HAT_NOEL, // COMPLETAR - EVENTO : NAVIDAD
	HAT_JACK,
	HAT_JAVA,
	HAT_MASTER_CHIEF,
	HAT_PSYCHO,
	HAT_SPARTAN,
	HAT_SPARTAN_RELOADED,
	HAT_MAU5,
	HAT_ZIPPY,
	HAT_ANGEL,
	HAT_CAPTAIN_AMERICA_SHIELD,
	HAT_FOOTBALL_HELM,
	HAT_JACKET,
	HAT_HELMET,
	HAT_JAMIE,
	HAT_JASON,
	HAT_JOKER,
	HAT_GAARA,
	HAT_PANDA,
	HAT_ITACHI,
	HAT_KAKASHI,
	HAT_POLAR, // COMPLETAR
	HAT_KISAME,
	HAT_ZABUZA,
	HAT_MASTERY,
	HAT_PREMIUM
};

new g_Hat[MAX_USERS][hatIds];

enum _:structHats {
	hatName[32],
	hatReq[256],
	hatModel[36],
	hatUpgrade1, // VIDA H
	hatUpgrade2, // VELOCIDAD
	hatUpgrade3, // GRAVEDAD
	hatUpgrade4, // DAÑO H
	Float:hatUpgrade5, // APS
	hatUpgrade6, // CHANCE
	hatUpgrade7, // VIDA Z
	hatUpgrade8  // DAÑO Z
};

new const __HATS[hatIds][structHats] = {
	// NOMBRE				REQUERIMIENTOS																	MODEL										VIDA_H		VELOCIDAD	GRAVEDAD	DAÑO_H		APS			CHANCE		VIDA_Z		DAÑO_Z
	{"Ninguno", 				"",																				"",											0, 			0, 			0, 			0, 			0.0, 		0, 			0, 			0},
	{"Afro", 				"Mata un zombie",																	"models/zp_tcs/hats/afro.mdl",					1, 			0, 			0, 			0, 			0.0, 		0, 			1, 			0},
	{"Awesome", 			"Mata 10 zombies",																	"models/zp_tcs/hats/awesome.mdl",				2, 			1, 			0, 			0, 			0.0, 		5, 			2, 			1},
	{"Darth Vader", 			"Infecta 25 humanos",																"models/zp_tcs/hats/darth2_big.mdl",				2, 			1, 			0, 			0, 			0.0, 		5, 			3, 			2},
	{"Devil", 				"Consigue ser el último humano en una ronda Primer Zombie^n\
							sin comprar armas y sin comprar items extras^n^n\
							\rNOTA:\w Requiere 18 jugadores o más",												"models/zp_tcs/hats/devil.mdl",					3, 			2, 			1, 			1, 			0.1, 		5, 			2, 			2},
	{"Pumpkin", 				"Asusta a 100 humanos",															"models/zp_tcs/hats/halloween.mdl",				0, 			0, 			0, 			0, 			0.0, 		50, 		0, 			0},
	{"X-Mas", 				"Acumula 100 regalos",																"models/zp_tcs/hats/hat_navid.mdl",				0, 			0, 			0, 			0, 			0.25, 		0, 			0, 			0},
	{"Noel", 				"Acumula 500 regalos",																"models/zp_tcs/hats/hat_navid2.mdl",				0, 			0, 			0, 			0, 			0.50, 		0, 			0, 			0},
	{"Jack", 				"Mata 100 Nemesis",																"models/zp_tcs/hats/jackjack.mdl",				5, 			2, 			2, 			1, 			0.1, 		5, 			2, 			2},
	{"Java", 				"Mata 100 Survivor",																"models/zp_tcs/hats/js.mdl",						3, 			2, 			2, 			0, 			0.1, 		5, 			4, 			3},
	{"Master Chief", 			"Sube la habilidad humana VELOCIDAD al máximo nivel",									"models/zp_tcs/hats/masterchief.mdl",				5, 			0, 			5, 			3, 			0.1, 		5, 			3, 			2},
	{"Psycho", 				"Consigue los logros \yBOMBA FALLIDA\w y \yVIRUS",										"models/zp_tcs/hats/psycho.mdl",					5, 			2, 			2, 			2, 			0.1, 		10, 		5, 			3},
	{"Spartan", 				"Sube el cuchillo a nivel siete",														"models/zp_tcs/hats/spartan.mdl",					5, 			3, 			3, 			3, 			0.1, 		10, 		0, 			0},
	{"Spartan Reloaded", 		"Sube el cuchillo a nivel quince",														"models/zp6/hats/spartan1.mdl",					6, 			4, 			4, 			4, 			0.2, 		10, 		0, 			0},
	{"Mau5", 				"Alcanza el reset cinco",																"models/zp_tcs/hats/tyno.mdl",					0, 			0, 			0, 			5, 			0.0, 		0, 			10, 		5},
	{"Zippy", 				"Juega durante quince días",															"models/zp_tcs/hats/zippy.mdl",					3, 			3, 			3, 			3, 			0.2, 		5, 			3, 			3},
	{"Angel", 				"Mata 500 zombies con cuchillo",														"models/zp6/hats/angel2.mdl",					5, 			4, 			3, 			4, 			0.1, 		7, 			5, 			4},
	{"Captain America Shield", 	"Mata 100 humanos siendo Nemesis en modo Leyenda",									"models/zp6/hats/cashield.mdl",					4, 			2, 			2, 			3, 			0.25, 		10, 		5, 			3},
	{"Football Helm", 			"Consigue jugar tres modos Armageddón en un mismo mapa^n^n\
							\rNOTA:\w No cuentan los lanzados por administradores",									"models/zp6/hats/football_helm.mdl",				4, 			5, 			3, 			3, 			0.15, 		5, 			4, 			3},
	{"Jacket", 				"Desgarra 1.000 de chaleco",															"models/zp6/hats/goauldshoulders.mdl",			0, 			0, 			0, 			0, 			0.1, 		5, 			5, 			3},
	{"Helmet", 				"Siendo Wesker, gana la ronda sin utilizar el LASER^n^n\
							\rNOTA:\w Requiere 15 jugadores o más",												"models/zp6/hats/helmet.mdl",					3, 			3, 			3, 			2, 			0.1, 		5, 			3, 			2},
	{"Jamie", 				"Comprá diez veces todos los items extras",												"models/zp6/hats/jamacahat2.mdl",				2, 			2, 			2, 			2, 			0.15, 		5, 			3, 			3},
	{"Jason", 				"Mata un Jason",																	"models/zp6/hats/jason.mdl",					3, 			1, 			1, 			1, 			0.0, 		0, 			2, 			2},
	{"Joker", 				"Mata un Nemesis, un Survivor, un Jason y un Wesker",									"models/zp6/hats/joker.mdl",					3, 			2, 			2, 			2, 			0.1, 		5, 			3, 			2},
	{"Gaara", 				"Comprá cincuenta veces todos los items extras",											"models/zp6/hats/n_gaarahead.mdl",				5, 			4, 			3, 			3, 			0.2, 		10, 		4, 			3},
	{"Panda", 				"Sube todas las armas a nivel cinco",													"models/jb_hats/panda_face.mdl",					5, 			5, 			5, 			5, 			0.3, 		15, 		5, 			5},
	{"Itachi", 				"Infecta cinco humanos con una misma Furia Zombie",										"models/zp6/hats/n_itachihead.mdl",				0, 			0, 			0, 			0, 			0.1, 		5, 			5, 			5},
	{"Kakashi", 				"Mata un Nemesis con cuchillo",														"models/zp6/hats/n_kakashihead.mdl",				2, 			0, 			0, 			0, 			0.25, 		0, 			2, 			0},
	{"Polar", 				"Consigue ser Campeón con tu clan",													"models/jb_hats/polar_head.mdl",					1, 			2, 			3, 			4, 			0.15, 		10, 		5, 			4},
	{"Kisame", 				"Comprá las tres Furia Zombie en una misma ronda",										"models/zp6/hats/n_kisamehead.mdl",				0, 			0, 			0, 			0, 			0.1, 		20, 		0, 			0},
	{"Zabuza", 				"Consigue explotar tres bombas de infección con una diferencia^n\
							de un segundo o menos y que a su vez cada una^n\
							infecte un humano o más (necesitarás ayuda de otros)^n^n\
							\rNOTA:\w Requiere 15 jugadores o más",												"models/zp6/hats/n_zabuzahead.mdl",				3, 			3, 			3, 			3, 			0.2, 		15, 		5, 			5},
	{"Mastery Hat", 			"Elige una maestría",																"models/zp6/hats/sortinghat.mdl",					1, 			0, 			0, 			0, 			0.0, 		0, 			1, 			1},
	{"Premium Hat", 			"Ser usuario Premium",																"models/jb_hats/gold_head.mdl",					1, 			1, 			1, 			1, 			0.1, 		10, 		1, 			1}
};

new const __HATS_INFO[8][] = {
	" Vida H^t^t^t^t^t^t", " Velocidad", " Gravedad     ", " Daño H", " APs       ", "% Modo", " Vida Z^t^t^t^t^t^t", " Daño Z"
};

__MAX_APS_PER_RESET(const reset) {
	switch(reset) {
		case 0..4: {
			return ((reset+1) * 10000000);
		} case 5..6: {
			return (reset * 13000000);
		} case 7..8: {
			return (reset * 16000000);
		} case 9..10: {
			return (reset * 19000000);
		} case 11..12: {
			return (reset * 22000000);
		} case 13..14: {
			return (reset * 25000000);
		} case 15..16: {
			return (reset * 28000000);
		} case 17..18: {
			return (reset * 31000000);
		} default: {
			return (reset * 40000000); // Al reset 50 pide 2.000.000.000
		}
	}
	
	return 0;
}

#define __APS_THIS_LEVEL(%1)	(g_Level[%1] * (__MAX_APS_PER_RESET(g_Reset[%1]) / 299))
#define __APS_THIS_LEVEL_REST1(%1)	((g_Level[%1] - 1) * (__MAX_APS_PER_RESET(g_Reset[%1]) / 299))

enum _:masteryIds {
	MASTERY_MORNING = 1,
	MASTERY_AFTERNOON,
	MASTERY_NIGHT
};

enum _:structWeapons {
	weaponCSW,
	weaponEnt[54],
	weaponNames[32],
	weaponLevelReq,
	weaponReset,
	Float:weaponDamageMult
};

new const ARMAS_PRIMARIAS[][structWeapons] = {
	{CSW_MAC10, "weapon_mac10", "Ingram MAC-10", 1, 0, 1.0},			// 28
	{CSW_TMP, "weapon_tmp", "Schmidt TMP", 1, 0, 1.0},				// 19
	{CSW_M3, "weapon_m3", "M3 Super 90", 1, 0, 1.0},					// 176
	{CSW_UMP45, "weapon_ump45", "UMP 45", 1, 0, 1.0},				// 29
	{CSW_XM1014, "weapon_xm1014", "XM1014 M4", 1, 0, 1.0},			// 114
	{CSW_P90, "weapon_p90", "ES P90", 1, 0, 1.0},						// 20
	{CSW_MP5NAVY, "weapon_mp5navy", "MP5 Navy", 1, 0, 1.0},			// 25
	{CSW_FAMAS, "weapon_famas", "Famas", 1, 0, 1.0},					// 29
	{CSW_GALIL, "weapon_galil", "IMI Galil", 1, 0, 1.0},					// 29
	{CSW_AUG, "weapon_aug", "Steyr AUG A1", 1, 0, 1.0},				// 31
	{CSW_SG552, "weapon_sg552", "SG-552 Commando", 1, 0, 1.0},		// 32
	{CSW_AK47, "weapon_ak47", "AK-47 Kalashnikov", 1, 0, 1.0},			// 35
	{CSW_M4A1, "weapon_m4a1", "M4A1 Carbine", 1, 0, 1.0},				// 31
	
	{CSW_MAC10, "weapon_mac10", "FARA 83", 25, 0, 4.29},			 	// 120
	{CSW_TMP, "weapon_tmp", "Tavor TAR-21", 50, 0, 6.58},			 	// 125
	{CSW_M3, "weapon_m3", "HK G3", 75, 0, 1.23},			 			// 218
	{CSW_UMP45, "weapon_ump45", "IMBEL MD-2", 100, 0, 4.49},			// 130
	{CSW_XM1014, "weapon_xm1014", "EF88 / F90", 125, 0, 1.36},		// 155
	{CSW_P90, "weapon_p90", "Khaybar KH2002", 150, 0, 6.76},			// 135
	{CSW_MP5NAVY, "weapon_mp5navy", "MKb.42(H)", 175, 0, 5.61},		// 140
	{CSW_FAMAS, "weapon_famas", "Enfield EM-2", 200, 0, 5.01},			// 145
	{CSW_GALIL, "weapon_galil", "LAPA FA 03", 225, 0, 5.18},			// 150
	{CSW_AUG, "weapon_aug", "Steyr ACR", 250, 0, 5.01},			 	// 155
	{CSW_SG552, "weapon_sg552", "IWI X95", 275, 0, 5.01},			 	// 160
	{CSW_AK47, "weapon_ak47", "Pindad SS2", 300, 0, 4.72},			 	// 165
	{CSW_M4A1, "weapon_m4a1", "Madsen LAR", 25, 1, 5.49},			 	// 170
	
	{CSW_MAC10, "weapon_mac10", "IMBEL IA2 5.56", 50, 1, 6.26},		// 175
	{CSW_TMP, "weapon_tmp", "CQ M311", 75, 1, 9.48},			 		// 180
	{CSW_M3, "weapon_m3", "Diemaco C7A1", 100, 1, 1.35},			 	// 238
	{CSW_UMP45, "weapon_ump45", "HK G41", 125, 1, 6.38},			 	// 185
	{CSW_XM1014, "weapon_xm1014", "FN FAL", 150, 1, 1.53},			// 175
	{CSW_P90, "weapon_p90", "FX-05 Xiuhcoatl", 175, 1, 9.51},			// 190
	{CSW_MP5NAVY, "weapon_mp5navy", "CETME mod.T", 200, 1, 7.81},	// 195
	{CSW_FAMAS, "weapon_famas", "Gilboa Snake", 225, 1, 6.90},			// 200
	{CSW_GALIL, "weapon_galil", "Cristobal M2", 250, 1, 7.07},			// 205
	{CSW_AUG, "weapon_aug", "SA80 / L85", 275, 1, 6.78},			 	// 210
	{CSW_SG552, "weapon_sg552", "QBS-06", 300, 1, 6.72},				// 215
	{CSW_AK47, "weapon_ak47", "NAR-10", 25, 2, 6.29},			 		// 220
	{CSW_M4A1, "weapon_m4a1", "Type 86s", 50, 2, 7.26},			 	// 225
	
	{CSW_MAC10, "weapon_mac10", "OTs-12 Tiss", 75, 2, 8.22},			// 230
	{CSW_TMP, "weapon_tmp", "CIS SAR-80", 100, 2, 12.37},			 	// 235
	{CSW_M3, "weapon_m3", "Korobov TKB-408", 125, 2, 1.46},			// 258
	{CSW_UMP45, "weapon_ump45", "AS Val", 150, 2, 8.28},			 	// 240
	{CSW_XM1014, "weapon_xm1014", "Fedorov avtomat", 175, 2, 1.71},	// 195
	{CSW_P90, "weapon_p90", "TRW LMR", 200, 2, 12.26},			 	// 245
	{CSW_MP5NAVY, "weapon_mp5navy", "ADS dual medium", 225, 2, 10.01},// 250
	{CSW_FAMAS, "weapon_famas", "APS underwater", 250, 2, 8.80},		// 255
	{CSW_GALIL, "weapon_galil", "A-91M", 275, 2, 8.97},			 	// 260
	{CSW_AUG, "weapon_aug", "SA80 / L85", 300, 2, 8.55},			 	// 265
	{CSW_SG552, "weapon_sg552", "Armalite AR-10", 25, 3, 8.44},			// 270
	{CSW_AK47, "weapon_ak47", "AN-94 Abakan", 50, 3, 7.86},			// 275
	{CSW_M4A1, "weapon_m4a1", "ASh-12.7", 75, 3, 9.04},			 	// 280
	
	{CSW_MAC10, "weapon_mac10", "Ruger AC-556", 100, 3, 10.18},		// 285
	{CSW_TMP, "weapon_tmp", "SA Vz.58", 125, 3, 15.27},			 	// 290
	{CSW_M3, "weapon_m3", "T65", 150, 3, 1.57},			 			// 278
	{CSW_UMP45, "weapon_ump45", "XM29 OICW", 175, 3, 10.18},			// 295
	{CSW_XM1014, "weapon_xm1014", "Bushmaster M17s", 200, 3, 1.88},	// 215
	{CSW_P90, "weapon_p90", "Daewoo K11", 225, 3, 15.01},			 	// 300
	{CSW_MP5NAVY, "weapon_mp5navy", "M27 IAR", 250, 3, 12.21},		// 305
	{CSW_FAMAS, "weapon_famas", "RobArm M96 XCR", 275, 3, 10.69},		// 310
	{CSW_GALIL, "weapon_galil", "FN Mk.16", 300, 3, 10.87},			 	// 315
	{CSW_AUG, "weapon_aug", "SA80 / L85", 25, 4, 10.33},			 	// 320
	{CSW_SG552, "weapon_sg552", "CZ 805", 50, 4, 10.16},			 	// 325
	{CSW_AK47, "weapon_ak47", "APS-95", 75, 4, 9.43},			 		// 330
	{CSW_M4A1, "weapon_m4a1", "Valmet Sako Rk.62", 100, 4, 10.81},		// 335
	
	{CSW_MAC10, "weapon_mac10", "MKEK MPT-76", 125, 4, 12.15},		// 340
	{CSW_TMP, "weapon_tmp", "Mk.17 SCAR", 150, 4, 18.16},			 	// 345
	{CSW_M3, "weapon_m3", "HK 33", 175, 4, 1.69},			 		// 298
	{CSW_UMP45, "weapon_ump45", "FN CAL", 200, 4, 12.07},			// 350
	{CSW_XM1014, "weapon_xm1014", "MSBS Radon", 225, 4, 2.06},		// 235
	{CSW_P90, "weapon_p90", "T65", 250, 4, 17.76},			 		// 355
	{CSW_MP5NAVY, "weapon_mp5navy", "CS/LR-14", 275, 4, 14.40},		// 360
	{CSW_FAMAS, "weapon_famas", "Mp-43", 300, 4, 12.59},			 	// 365
	{CSW_GALIL, "weapon_galil", "MKb.42(W)", 25, 5, 12.76},			// 370
	{CSW_AUG, "weapon_aug", "SA80 / L85", 50, 5, 12.10},			 	// 375
	{CSW_SG552, "weapon_sg552", "SIG-Sauer 716", 75, 5, 11.88},		// 380
	{CSW_AK47, "weapon_ak47", "Z-M LR-300", 100, 5, 11.01},			// 385
	{CSW_M4A1, "weapon_m4a1", "Colt CAR-15", 125, 5, 12.59},			// 390
	
	{CSW_MAC10, "weapon_mac10", "Valmet M82", 150, 5, 14.11},			// 395
	{CSW_TMP, "weapon_tmp", "Beretta BM 59", 175, 5, 21.06},			// 400
	{CSW_M3, "weapon_m3", "Type 89", 200, 5, 1.80},			 		// 318
	{CSW_UMP45, "weapon_ump45", "Interdynamics MKS", 225, 5, 13.97},	// 405
	{CSW_XM1014, "weapon_xm1014", "Vepr", 250, 5, 2.23},			 	// 255
	{CSW_P90, "weapon_p90", "OTs-14 Groza", 275, 5, 20.51},			// 410
	{CSW_MP5NAVY, "weapon_mp5navy", "Daewoo K11", 300, 5, 16.61},	// 415
	{CSW_FAMAS, "weapon_famas", "Vektor CR-21", 25, 6, 14.49},			// 420
	{CSW_GALIL, "weapon_galil", "VHS", 50, 6, 14.66},			 		// 425
	{CSW_AUG, "weapon_aug", "BT APC-556", 75, 6, 13.88},			 	// 430
	{CSW_SG552, "weapon_sg552", "Type 95 QBZ-95", 100, 6, 13.60},		// 435
	{CSW_AK47, "weapon_ak47", "Bofors AK5", 125, 6, 12.58},			// 440
	{CSW_M4A1, "weapon_m4a1", "Colt XM-177", 150, 6, 14.36},			// 445
	
	{CSW_MAC10, "weapon_mac10", "Leader SAR", 175, 6, 16.08},			// 450
	{CSW_TMP, "weapon_tmp", "Remington 7600", 200, 6, 23.95},			// 455
	{CSW_M3, "weapon_m3", "Kel-tec SUB 2000", 225, 6, 1.91},			// 338
	{CSW_UMP45, "weapon_ump45", "BCM CM4 Storm", 250, 6, 15.87},		// 460
	{CSW_XM1014, "weapon_xm1014", "AIA M10", 275, 6, 2.41},			// 275
	{CSW_P90, "weapon_p90", "Rossi 92", 300, 6, 23.26},			 	// 465
	{CSW_MP5NAVY, "weapon_mp5navy", "Hi-Point Model 995", 25, 7, 18.80},// 470
	{CSW_FAMAS, "weapon_famas", "Vepr MA-9", 50, 7, 16.38},			// 475
	{CSW_GALIL, "weapon_galil", "KSO-9 Krechet", 75, 7, 16.56},			// 480
	{CSW_AUG, "weapon_aug", "Armalon PC", 100, 7, 15.65},			 	// 485
	{CSW_SG552, "weapon_sg552", "Ruger PC-4", 125, 7, 15.32},			// 490
	{CSW_AK47, "weapon_ak47", "Kel-tec RDB", 150, 7, 14.15},			// 495
	{CSW_M4A1, "weapon_m4a1", "Heckler-Koch SL-6", 175, 7, 16.13},		// 500
	
	{CSW_MAC10, "weapon_mac10", "Cobra", 200, 7, 18.04},			 	// 505
	{CSW_TMP, "weapon_tmp", "Ar-15", 225, 7, 26.85},			 		// 510
	{CSW_M3, "weapon_m3", "JR carbine", 250, 7, 2.03},			 		// 358
	{CSW_UMP45, "weapon_ump45", "Safir T15", 275, 7, 17.76},			// 515
	{CSW_XM1014, "weapon_xm1014", "Kommando LDP", 300, 7, 2.58},	// 295
	{CSW_P90, "weapon_p90", "Magpul MASADA", 25, 8, 26.01},			// 520
	{CSW_MP5NAVY, "weapon_mp5navy", "DRD Paratus", 50, 8, 21.01},		// 525
	{CSW_FAMAS, "weapon_famas", "MPAR-556", 75, 8, 18.28},			// 530
	{CSW_GALIL, "weapon_galil", "K&M M17S-556", 100, 8, 18.45},		// 535
	{CSW_AUG, "weapon_aug", "Taurus CT G2", 125, 8, 17.42},			// 540
	{CSW_SG552, "weapon_sg552", "TPD AXR", 150, 8, 17.04},			// 545
	{CSW_AK47, "weapon_ak47", "MSAR STG-556", 175, 8, 15.72},			// 550
	{CSW_M4A1, "weapon_m4a1", "Colt LE-901", 200, 8, 17.91},			// 555
	
	{CSW_MAC10, "weapon_mac10", "SMLE Lee-Enfield", 225, 8, 20.01},		// 560
	{CSW_TMP, "weapon_tmp", "Krag–Jorgensen", 250, 8, 29.74},			// 565
	{CSW_M3, "weapon_m3", "Winchester M1895", 275, 8, 2.14},			// 378
	{CSW_UMP45, "weapon_ump45", "Mauser 98", 300, 8, 19.66},			// 570
	{CSW_XM1014, "weapon_xm1014", "35M", 25, 9, 2.76},			 	// 315
	{CSW_P90, "weapon_p90", "Lebel M1886", 50, 9, 28.76},			 	// 575
	{CSW_MP5NAVY, "weapon_mp5navy", "Lee Navy M1895", 75, 9, 23.21},	// 580
	{CSW_FAMAS, "weapon_famas", "Madsen M1947", 100, 9, 20.18},		// 585
	{CSW_GALIL, "weapon_galil", "Gew.88", 125, 9, 20.35},			 	// 590
	{CSW_AUG, "weapon_aug", "De Lisle Commando", 150, 9, 19.20},		// 595
	{CSW_SG552, "weapon_sg552", "Carcano M91", 175, 9, 18.76},		// 600
	{CSW_AK47, "weapon_ak47", "SKS Simonov", 200, 9, 17.29},			// 605
	{CSW_M4A1, "weapon_m4a1", "M1903 Springfield", 225, 9, 19.68},		// 610
	
	{CSW_MAC10, "weapon_mac10", "Berthier 1890", 250, 9, 21.97},		// 615
	{CSW_TMP, "weapon_tmp", "VG.1-5", 275, 9, 32.64},			 		// 620
	{CSW_M3, "weapon_m3", "FG-42", 300, 9, 2.25},			 		// 398
	{CSW_UMP45, "weapon_ump45", "K31", 50, 10, 21.56},			 	// 625
	{CSW_XM1014, "weapon_xm1014", "MAS-36", 100, 10, 2.93},			// 335
	{CSW_P90, "weapon_p90", "AVS-36 Simonov", 150, 10, 31.51},		// 630
	{CSW_MP5NAVY, "weapon_mp5navy", "G.41(M)", 200, 10, 25.40},		// 635
	{CSW_FAMAS, "weapon_famas", "FN SAFN-49", 250, 10, 22.07},		// 640
	{CSW_GALIL, "weapon_galil", "Mauser M1889", 300, 10, 22.25},		// 645
	{CSW_AUG, "weapon_aug", "Arisaka 38", 50, 11, 20.97},			 	// 650
	{CSW_SG552, "weapon_sg552", "Hakim", 100, 11, 20.47},			 	// 655
	{CSW_AK47, "weapon_ak47", "Mondragon", 150, 11, 18.86},			// 660
	{CSW_M4A1, "weapon_m4a1", "AG-42 Ljungman", 200, 11, 21.46},		// 665
	
	{CSW_MAC10, "weapon_mac10", "M1 Garand", 250, 11, 23.93},			// 670
	{CSW_TMP, "weapon_tmp", "ZH-29", 300, 11, 35.53},			 	// 675
	{CSW_M3, "weapon_m3", "Meunier M1916", 50, 12, 2.37},			 	// 418
	{CSW_UMP45, "weapon_ump45", "Pedersen T1", 100, 12, 23.45},		// 680
	{CSW_XM1014, "weapon_xm1014", "SVT-38", 150, 12, 3.11},			// 355
	{CSW_P90, "weapon_p90", "Rasheed", 200, 12, 34.25},			 	// 685
	{CSW_MP5NAVY, "weapon_mp5navy", "MAS-1949", 250, 12, 27.61},		// 690
	{CSW_FAMAS, "weapon_famas", "RSC M1917", 300, 12, 23.97},			// 695
	{CSW_GALIL, "weapon_galil", "S&W Light 1940", 50, 13, 24.14},		// 700
	{CSW_AUG, "weapon_aug", "M1941 Johnson", 100, 13, 22.75},			// 705
	{CSW_SG552, "weapon_sg552", "Farquhar-Hill", 150, 13, 22.19},		// 710
	{CSW_AK47, "weapon_ak47", "SVT-40 Tokarev", 200, 13, 20.43},		// 715
	{CSW_M4A1, "weapon_m4a1", "Madsen M1896", 250, 13, 23.23},		// 720
	
	{CSW_MAC10, "weapon_mac10", "M1917 US Enfield", 300, 13, 25.90},	// 725
	{CSW_TMP, "weapon_tmp", "Korobov TKB-517", 50, 14, 38.43},		// 730
	{CSW_M3, "weapon_m3", "9A-91", 100, 14, 2.48},			 		// 438
	{CSW_UMP45, "weapon_ump45", "Vz.52/57", 150, 14, 25.35},			// 735
	{CSW_XM1014, "weapon_xm1014", "Mosin", 200, 14, 3.29},			// 375
	{CSW_P90, "weapon_p90", "ASh-12.7", 250, 14, 37.00},			 	// 740
	{CSW_MP5NAVY, "weapon_mp5navy", "ADS DualM", 300, 14, 29.80},		// 745
	{CSW_FAMAS, "weapon_famas", "G.41(W)", 50, 15, 25.87},			// 750
	{CSW_GALIL, "weapon_galil", "Breda", 100, 15, 26.04},			 	// 755
	{CSW_AUG, "weapon_aug", "Steyr Mannlicher M95", 150, 15, 24.52},		// 760
	{CSW_SG552, "weapon_sg552", "Baryshev AB-7", 200, 15, 23.91},		// 765
	{CSW_AK47, "weapon_ak47", "AKS-74U", 250, 15, 22.01},			 	// 770
	{CSW_M4A1, "weapon_m4a1", "OTs-14 Groza", 300, 15, 25.01},		// 775
	
	{CSW_MAC10, "weapon_mac10", "Armalite AR-18", 50, 16, 27.86},		// 780
	{CSW_TMP, "weapon_tmp", "FMK-3", 100, 16, 41.32},			 	// 785
	{CSW_M3, "weapon_m3", "APC-300", 150, 16, 2.60},			 		// 458
	{CSW_UMP45, "weapon_ump45", "Desert Tech MDR", 200, 16, 27.25},	// 790
	{CSW_XM1014, "weapon_xm1014", "ST Kinetics SAR-21", 250, 16, 3.46},	// 395
	{CSW_P90, "weapon_p90", "K6-92", 300, 16, 39.75},					// 795
	{CSW_MP5NAVY, "weapon_mp5navy", "Daewoo K1/K2", 50, 17, 32.00},	// 800
	{CSW_FAMAS, "weapon_famas", "Interdynamics MKR", 100, 17, 27.76},	// 805
	{CSW_GALIL, "weapon_galil", "SR-3M Vikhr", 150, 17, 27.94},			// 810
	{CSW_AUG, "weapon_aug", "SIG-Sauer 516", 200, 17, 26.30},			// 815
	{CSW_SG552, "weapon_sg552", "Halcon M/943", 250, 17, 25.63},		// 820
	{CSW_AK47, "weapon_ak47", "Bofors AK5", 300, 17, 23.58},			// 825
	{CSW_M4A1, "weapon_m4a1", "Korobov TKB-022", 50, 18, 26.78},		// 830
	
	{CSW_MAC10, "weapon_mac10", "Mekanika URU", 100, 18, 29.83},		// 835
	{CSW_TMP, "weapon_tmp", "K-50M", 150, 18, 44.22},			 	// 840
	{CSW_M3, "weapon_m3", "Sterling L2", 200, 18, 2.71},			 	// 478
	{CSW_UMP45, "weapon_ump45", "Shipka", 250, 18, 29.14},			// 845
	{CSW_XM1014, "weapon_xm1014", " Vigneron M2", 300, 18, 3.64},		// 415
	{CSW_P90, "weapon_p90", "Walther MPL", 50, 19, 42.50},			 	// 850
	{CSW_MP5NAVY, "weapon_mp5navy", "MCEM-2", 100, 19, 34.20},		// 855
	{CSW_FAMAS, "weapon_famas", "Lanchester Mk.1", 150, 19, 29.66},		// 860
	{CSW_GALIL, "weapon_galil", "Gevarm D4", 200, 19, 29.83},			// 865
	{CSW_AUG, "weapon_aug", "Steyr-Solothurn MP.34", 250, 19, 28.07},	// 870
	{CSW_SG552, "weapon_sg552", "EMP.35 Erma", 300, 19, 27.35},		// 875
	{CSW_AK47, "weapon_ak47", "Dux M53", 50, 20, 25.15},			 	// 880
	{CSW_M4A1, "weapon_m4a1", "Colt SCAMP", 100, 20, 28.55},			// 885
	
	{CSW_MAC10, "weapon_mac10", "Erma MP-56", 150, 20, 31.79},		// 890
	{CSW_TMP, "weapon_tmp", "FNA-B 43", 200, 20, 47.11},			 	// 895
	{CSW_M3, "weapon_m3", "Benelli CB-M2", 250, 20, 2.82},			 	// 498
	{CSW_UMP45, "weapon_ump45", "Hovea m/49", 300, 20, 31.04},		// 900
	{CSW_XM1014, "weapon_xm1014", "MK.36 Schmeisser", 50, 21, 3.81},	// 435
	{CSW_P90, "weapon_p90", "Star Z-84", 100, 21, 45.25},			 	// 905
	{CSW_MP5NAVY, "weapon_mp5navy", "CETME C2", 150, 21, 36.40},		// 910
	{CSW_FAMAS, "weapon_famas", "MSMC", 200, 21, 31.56},			 	// 915
	{CSW_GALIL, "weapon_galil", "Micro UZI", 250, 21, 31.73},			// 920
	{CSW_AUG, "weapon_aug", "Madsen m/45", 300, 21, 29.84},			// 925
	{CSW_SG552, "weapon_sg552", "SOCIMI 821", 50, 22, 29.07},			// 930
	{CSW_AK47, "weapon_ak47", "Zk-383", 100, 22, 26.72},			 	// 935
	{CSW_M4A1, "weapon_m4a1", "Spectre M4", 150, 22, 30.33},			// 940
	
	{CSW_MAC10, "weapon_mac10", "Armaguerra OG-43", 200, 22, 33.75},	// 945
	{CSW_TMP, "weapon_tmp", "Smith&Wesson M76", 250, 22, 50.00},		// 950
	{CSW_M3, "weapon_m3", "Mors wz.39", 300, 22, 2.94},			 	// 518
	{CSW_UMP45, "weapon_ump45", "Madsen m/46", 50, 23, 32.94},		// 955
	{CSW_XM1014, "weapon_xm1014", "TZ-45", 100, 23, 3.99},			// 455
	{CSW_P90, "weapon_p90", "Ruger MP9", 150, 23, 48.00},			 	// 960
	{CSW_MP5NAVY, "weapon_mp5navy", "Chang Feng", 200, 23, 38.60},	// 965
	{CSW_FAMAS, "weapon_famas", "Beretta MX4", 250, 23, 33.45},		// 970
	{CSW_GALIL, "weapon_galil", "Franchi LF-57", 300, 23, 33.63},		// 975
	{CSW_AUG, "weapon_aug", "Steyr MPi 69", 50, 24, 31.62},			 	// 980
	{CSW_SG552, "weapon_sg552", "Ares FMG", 100, 24, 30.79},			// 985
	{CSW_AK47, "weapon_ak47", "Kriss Super V", 150, 24, 28.29},			// 990
	{CSW_M4A1, "weapon_m4a1", "Colt mod.635", 200, 24, 32.10},		// 995
	
	{CSW_MAC10, "weapon_mac10", "Demro TAC-1", 250, 24, 35.72},		// 1000
	{CSW_TMP, "weapon_tmp", "Degtyarov PDM", 300, 24, 52.90},			// 1005
	{CSW_M3, "weapon_m3", "OTs-02 Kiparis", 50, 25, 3.05},			 	// 538
	{CSW_UMP45, "weapon_ump45", "CS/LS-5", 100, 25, 34.83},			// 1010
	{CSW_XM1014, "weapon_xm1014", "IMP-221", 150, 25, 4.16},			// 475
	{CSW_P90, "weapon_p90", "PPSh-2", 200, 25, 50.75},			 	// 1015
	{CSW_MP5NAVY, "weapon_mp5navy", "STK CPW", 250, 25, 40.80},		// 1020
	{CSW_FAMAS, "weapon_famas", "Korovin 1941", 300, 25, 35.35},		// 1025
	{CSW_GALIL, "weapon_galil", "PPSh-41", 50, 26, 35.52},			 	// 1030
	{CSW_AUG, "weapon_aug", "Steyr TMP", 100, 26, 33.39},			 	// 1035
	{CSW_SG552, "weapon_sg552", "Orita M1941", 150, 26, 32.50},		// 1040
	{CSW_AK47, "weapon_ak47", "AEK-919K Kashtan", 200, 26, 29.86},		// 1045
	{CSW_M4A1, "weapon_m4a1", "Reising M50", 250, 26, 33.88},			// 1050
	
	{CSW_MAC10, "weapon_mac10", "Tikkakoski M/44", 300, 26, 37.68},		// 1055
	{CSW_TMP, "weapon_tmp", "MGV-176", 50, 27, 55.79},			 	// 1060
	{CSW_M3, "weapon_m3", "MGV-176", 100, 27, 3.16},			 	// 558
	{CSW_UMP45, "weapon_ump45", "B&T APC", 150, 27, 36.73},			// 1065
	{CSW_XM1014, "weapon_xm1014", "Suomi M/31", 200, 27, 4.34},		// 495
	{CSW_P90, "weapon_p90", "SAR 109", 250, 27, 53.50},			 	// 1070
	{CSW_MP5NAVY, "weapon_mp5navy", "Carl Gustaf M/45", 300, 27, 43.00},// 1075
	{CSW_FAMAS, "weapon_famas", "CBJ-MS PDW", 50, 28, 37.25},			// 1080
	{CSW_GALIL, "weapon_galil", "Agram2000", 100, 28, 37.42},			// 1085
	{CSW_AUG, "weapon_aug", "Rexim Favor", 150, 28, 35.17},			// 1090
	{CSW_SG552, "weapon_sg552", "Skorpion vz.61", 200, 28, 34.22},		// 1095
	{CSW_AK47, "weapon_ak47", "Minebea M-9", 250, 28, 31.43},			// 1100
	{CSW_M4A1, "weapon_m4a1", "WF Lmg 41/44", 300, 28, 35.65},		// 1105
	
	{CSW_MAC10, "weapon_mac10", "FN P90", 50, 29, 39.65},			// 1110
	{CSW_TMP, "weapon_tmp", "Ingram M6", 100, 29, 58.69},			 	// 1115
	{CSW_M3, "weapon_m3", "SR-3 Veresk", 150, 29, 3.28},			 	// 578
	{CSW_UMP45, "weapon_ump45", "MP.18,I Schmeisser", 200, 29, 38.63},	// 1120
	{CSW_XM1014, "weapon_xm1014", "Halcon ML-63", 250, 29, 4.51},		// 515
	{CSW_P90, "weapon_p90", "SI-35", 300, 29, 56.25},			 		// 1125
	{CSW_MP5NAVY, "weapon_mp5navy", "Beretta M1918", 50, 30, 45.20},	// 1130
	{CSW_FAMAS, "weapon_famas", "Star RU-35", 100, 30, 39.14},			// 1135
	{CSW_GALIL, "weapon_galil", "HK MP7 PDW", 150, 30, 39.32},			// 1140
	{CSW_AUG, "weapon_aug", "Taurus MT-9", 200, 30, 36.94},			// 1145
	{CSW_SG552, "weapon_sg552", "American-180", 250, 30, 35.94},		// 1150
	{CSW_AK47, "weapon_ak47", "PP19 Vityaz", 300, 30, 33.00},			// 1155
	{CSW_M4A1, "weapon_m4a1", "UD M42", 50, 31, 37.42},			 	// 1160
	
	{CSW_MAC10, "weapon_mac10", "Ingram MAC M10", 100, 31, 41.61},	// 1165
	{CSW_TMP, "weapon_tmp", "Star Z-62", 150, 31, 61.58},			 	// 1170
	{CSW_M3, "weapon_m3", " SCK-65", 200, 31, 3.39},			 		// 598
	{CSW_UMP45, "weapon_ump45", "STA M 1922", 250, 31, 40.52},		// 1175
	{CSW_XM1014, "weapon_xm1014", "Thompson", 300, 31, 4.69},		// 535
	{CSW_P90, "weapon_p90", "K6-92 / Borz", 50, 32, 59.00},			// 1180
	{CSW_MP5NAVY, "weapon_mp5navy", "Nambu 1966", 100, 32, 47.40},	// 1185
	{CSW_FAMAS, "weapon_famas", "CZ Vz. 38", 150, 32, 41.04},			// 1190
	{CSW_GALIL, "weapon_galil", "Skorpion EVO III", 200, 32, 41.21},		// 1195
	{CSW_AUG, "weapon_aug", "SIG-Sauer MPX", 250, 32, 38.71},			// 1200
	{CSW_SG552, "weapon_sg552", "FBP m/948", 300, 32, 37.66},			// 1205
	{CSW_AK47, "weapon_ak47", "PP-19 Bizon", 50, 33, 34.58},			// 1210
	{CSW_M4A1, "weapon_m4a1", "MP.41 Schmeisser", 100, 33, 39.20}		// 1215
};

new const ARMAS_SECUNDARIAS[][structWeapons] = {
	{CSW_GLOCK18, "weapon_glock18", "Glock 18C", 1, 0, 1.0},				// 24
	{CSW_FIVESEVEN, "weapon_fiveseven", "FiveseveN", 150, 0, 1.5},			// 28 (19 default)
	{CSW_USP, "weapon_usp", "USP .45 ACP Tactical", 225, 0, 1.0},			// 33
	{CSW_P228, "weapon_p228", "P228 Compact", 300, 0, 1.2},				// 37 (31 default)
	{CSW_ELITE, "weapon_elite", "Dual Elite Berettas", 75, 1, 1.2},				// 42 (35 default)
	{CSW_DEAGLE, "weapon_deagle", "Desert Eagle .50 AE", 150, 1, 1.0},		// 52
	
	{CSW_GLOCK18, "weapon_glock18", "FN Browning M1900", 225, 1, 2.42},	// 58
	{CSW_FIVESEVEN, "weapon_fiveseven", "Steyr GB", 300, 1, 3.37},			// 64
	{CSW_USP, "weapon_usp", "Bergmann Bayard M1910", 75, 2, 2.13},			// 70
	{CSW_P228, "weapon_p228", "Bersa Thunder", 150, 2, 2.46},				// 76
	{CSW_ELITE, "weapon_elite", "Roth Steyr M1907", 225, 2, 2.35},			// 82
	{CSW_DEAGLE, "weapon_deagle", "Arcus 94 & 98DA", 300, 2, 1.70},			// 89
	
	{CSW_GLOCK18, "weapon_glock18", "FEG AP-63 PA-63", 75, 3, 3.92},		// 94
	{CSW_FIVESEVEN, "weapon_fiveseven", "Webley Scott", 150, 3, 5.27},		// 100
	{CSW_USP, "weapon_usp", "Frommer Stop", 225, 3, 3.22},			 	// 106
	{CSW_P228, "weapon_p228", "Taurus PT92", 300, 3, 3.62},			 	// 112
	{CSW_ELITE, "weapon_elite", "Arsenal P-M02", 75, 4, 3.38},			 	// 118
	{CSW_DEAGLE, "weapon_deagle", "Bergmann Mars", 150, 4, 2.39},			// 125
	
	{CSW_GLOCK18, "weapon_glock18", "FN Forty-Nine", 225, 4, 5.42},			// 130
	{CSW_FIVESEVEN, "weapon_fiveseven", "Steyr Hahn M1912", 300, 4, 7.16},	// 136
	{CSW_USP, "weapon_usp", "FN Browning HP", 75, 5, 4.31},			 	// 142
	{CSW_P228, "weapon_p228", "Ballester-Molina", 150, 5, 4.78},			 	// 148
	{CSW_ELITE, "weapon_elite", "Bersa Thunder 380", 225, 5, 4.41},			// 154
	{CSW_DEAGLE, "weapon_deagle", "FN FNP-45", 300, 5, 3.08},			 	// 161
	
	{CSW_GLOCK18, "weapon_glock18", "Luger 'Parabellum'", 75, 6, 6.92},		// 166
	{CSW_FIVESEVEN, "weapon_fiveseven", "FEMARU 29M", 150, 6, 9.06},		// 172
	{CSW_USP, "weapon_usp", "FEG P9M", 225, 6, 5.40},			 			// 178
	{CSW_P228, "weapon_p228", "Taurus 24/7", 300, 6, 5.94},			 	// 184
	{CSW_ELITE, "weapon_elite", "Welrod silent", 75, 7, 5.43},			 	// 190
	{CSW_DEAGLE, "weapon_deagle", "Mauser C-96", 150, 7, 3.77},			 	// 197
	
	{CSW_GLOCK18, "weapon_glock18", "HK VP9", 225, 7, 8.42},			 	// 202
	{CSW_FIVESEVEN, "weapon_fiveseven", "Walther P38", 300, 7, 10.95},		// 208
	{CSW_USP, "weapon_usp", "Korth", 75, 8, 6.49},			 			// 214
	{CSW_P228, "weapon_p228", "HK VP 70", 150, 8, 7.10},			 		// 220
	{CSW_ELITE, "weapon_elite", "Sauer 38H", 225, 8, 6.46},			 		// 226
	{CSW_DEAGLE, "weapon_deagle", "Jericho 941", 300, 8, 4.47},			 	// 233
	
	{CSW_GLOCK18, "weapon_glock18", "Astra A-80", 75, 9, 9.92},			 	// 238
	{CSW_FIVESEVEN, "weapon_fiveseven", "Viper JAWS", 150, 9, 12.85},		// 244
	{CSW_USP, "weapon_usp", "UZI pistol", 225, 9, 7.58},			 		// 250
	{CSW_P228, "weapon_p228", "Barak SP-21", 300, 9, 8.26},			 	// 256
	{CSW_ELITE, "weapon_elite", "Bul M5", 75, 10, 7.49},					// 262
	{CSW_DEAGLE, "weapon_deagle", "Llama M-82", 150, 10, 5.16},			// 269
	
	{CSW_GLOCK18, "weapon_glock18", "Tanfoglio T95", 225, 10, 11.42},		// 274
	{CSW_FIVESEVEN, "weapon_fiveseven", "Benelli B76", 300, 10, 14.74},		// 280
	{CSW_USP, "weapon_usp", "Bernardelli P-018", 75, 11, 8.67},			 	// 286
	{CSW_P228, "weapon_p228", "Bul Cherokee", 150, 11, 9.42},			 	// 292
	{CSW_ELITE, "weapon_elite", "Star 30M", 225, 11, 8.52},			 		// 298
	{CSW_DEAGLE, "weapon_deagle", "Para-Ordnance P14-45", 300, 11, 5.85},	// 305
	
	{CSW_GLOCK18, "weapon_glock18", "VIS wz.35", 75, 12, 12.92},			// 310
	{CSW_FIVESEVEN, "weapon_fiveseven", "QSZ-92", 150, 12, 16.64},			// 316
	{CSW_USP, "weapon_usp", "Obregon", 225, 12, 9.76},			 		// 322
	{CSW_P228, "weapon_p228", "Type 77", 300, 12, 10.59},			 		// 328
	{CSW_ELITE, "weapon_elite", "Model 77B", 75, 13, 9.55},			 		// 334
	{CSW_DEAGLE, "weapon_deagle", "P-64", 150, 13, 6.54},			 		// 341
	
	{CSW_GLOCK18, "weapon_glock18", "Stechkin APS", 225, 13, 14.42},		// 346
	{CSW_FIVESEVEN, "weapon_fiveseven", "Tokarev TT", 300, 13, 18.53},		// 352
	{CSW_USP, "weapon_usp", "Makarov PM", 75, 14, 10.85},			 		// 358
	{CSW_P228, "weapon_p228", "Wist-94", 150, 14, 11.75},			 		// 364
	{CSW_ELITE, "weapon_elite", "Korovin TK", 225, 14, 10.58},			 	// 370
	{CSW_DEAGLE, "weapon_deagle", "PSM", 300, 14, 7.24},			 		// 377
	
	{CSW_GLOCK18, "weapon_glock18", "MP-446", 75, 15, 15.92},			 	// 382
	{CSW_FIVESEVEN, "weapon_fiveseven", "OTs-23", 150, 15, 20.43},			// 388
	{CSW_USP, "weapon_usp", "SPP-1 underwater", 225, 15, 11.94},			// 394
	{CSW_P228, "weapon_p228", "APB silenced", 300, 15, 12.91},			 	// 400
	{CSW_ELITE, "weapon_elite", "GSh-18", 75, 16, 11.61},			 		// 406
	{CSW_DEAGLE, "weapon_deagle", "OTs-21", 150, 16, 7.93},			 	// 413
	
	{CSW_GLOCK18, "weapon_glock18", "K-100", 225, 16, 17.42},			 	// 418
	{CSW_FIVESEVEN, "weapon_fiveseven", "CZ-999", 300, 16, 22.32},			// 424
	{CSW_USP, "weapon_usp", "ASP", 75, 17, 13.04},			 			// 430
	{CSW_P228, "weapon_p228", "Strike One", 150, 17, 14.07},			 	// 436
	{CSW_ELITE, "weapon_elite", "M57", 225, 17, 12.63},			 		// 442
	{CSW_DEAGLE, "weapon_deagle", "FN Browning BDM", 300, 17, 8.62},		// 449
	
	{CSW_GLOCK18, "weapon_glock18", "Kahr K9", 75, 18, 18.92},			 	// 454
	{CSW_FIVESEVEN, "weapon_fiveseven", "S&W Sigma", 150, 18, 24.22},		// 460
	{CSW_USP, "weapon_usp", "Ruger SR9", 225, 18, 14.13},			 		// 466
	{CSW_P228, "weapon_p228", "Gyrojet", 300, 18, 15.23},			 		// 472
	{CSW_ELITE, "weapon_elite", "Colt Gov't / M1911", 75, 19, 13.66},			// 478
	{CSW_DEAGLE, "weapon_deagle", "Bren Ten", 150, 19, 9.31},			 	// 485
	
	{CSW_GLOCK18, "weapon_glock18", "LAR Grizzly", 225, 19, 20.42},			// 490
	{CSW_FIVESEVEN, "weapon_fiveseven", "AMP Auto Mag", 300, 19, 26.11},	// 496
	{CSW_USP, "weapon_usp", "Coonan", 75, 20, 15.22},			 			// 502
	{CSW_P228, "weapon_p228", "Goncz GA-9", 150, 20, 16.39},			 	// 508
	{CSW_ELITE, "weapon_elite", "Intratec DC-9", 225, 20, 14.69},			 	// 514
	{CSW_DEAGLE, "weapon_deagle", "Kel-tec P-11", 300, 20, 10.01},			// 521
	
	{CSW_GLOCK18, "weapon_glock18", "Yavuz 16", 75, 21, 21.92},			// 526
	{CSW_FIVESEVEN, "weapon_fiveseven", "MPA Defender", 150, 21, 28.01},	// 532
	{CSW_USP, "weapon_usp", "Ruger SR9", 225, 21, 16.31},			 		// 538
	{CSW_P228, "weapon_p228", "Boberg XR-9", 300, 21, 17.55},			 	// 544
	{CSW_ELITE, "weapon_elite", "FN FNP-45", 75, 22, 15.72},			 	// 550
	{CSW_DEAGLE, "weapon_deagle", "Akdal Ghost", 150, 22, 10.70},			// 557
	
	{CSW_GLOCK18, "weapon_glock18", "Mle. 1950", 225, 22, 23.42},			// 562
	{CSW_FIVESEVEN, "weapon_fiveseven", "Shevchenko PSh", 300, 22, 29.90},	// 568
	{CSW_USP, "weapon_usp", "Lahti L-35", 75, 23, 17.40},			 		// 574
	{CSW_P228, "weapon_p228", "Sarsilmaz K2-45", 150, 23, 18.71},			// 580
	{CSW_ELITE, "weapon_elite", "Fort 12", 225, 23, 16.75},			 		// 586
	{CSW_DEAGLE, "weapon_deagle", "MAB PA-15", 300, 23, 11.39},			// 593
	
	{CSW_GLOCK18, "weapon_glock18", "B+T VP-9", 75, 24, 24.92},			// 598
	{CSW_FIVESEVEN, "weapon_fiveseven", "SIG-Sauer P220", 150, 24, 31.79},	// 604
	{CSW_USP, "weapon_usp", "Sphinx 2000", 225, 24, 18.49},			 	// 610
	{CSW_P228, "weapon_p228", "IM Metal HS 2000", 300, 24, 19.88},			// 616
	{CSW_ELITE, "weapon_elite", "CZ-G 2000", 75, 25, 17.78},			 	// 622
	{CSW_DEAGLE, "weapon_deagle", "Husqvarna M/40", 150, 25, 12.08},		// 629
	
	{CSW_GLOCK18, "weapon_glock18", "Caracal", 225, 25, 26.42},			 	// 634
	{CSW_FIVESEVEN, "weapon_fiveseven", "Daewoo DP-51", 300, 25, 33.69},	// 640
	{CSW_USP, "weapon_usp", "Nambu Type 14", 75, 26, 19.58},			 	// 646
	{CSW_P228, "weapon_p228", "Vektor CP1", 150, 26, 21.04},			 	// 652
	{CSW_ELITE, "weapon_elite", "ADP", 225, 26, 18.80},			 		// 658
	{CSW_DEAGLE, "weapon_deagle", "Tara TM9", 300, 26, 12.77},			 	// 665
	
	{CSW_GLOCK18, "weapon_glock18", "Webley-Fosbery", 75, 27, 27.92},		// 670
	{CSW_FIVESEVEN, "weapon_fiveseven", "Webley", 150, 27, 35.58},			// 676
	{CSW_USP, "weapon_usp", "Enfield Mk 1", 225, 27, 20.67},			 	// 682
	{CSW_P228, "weapon_p228", "Nagant mle.1895", 300, 27, 22.20},			// 688
	{CSW_ELITE, "weapon_elite", "FN Barracuda", 75, 28, 19.83},			 	// 694
	{CSW_DEAGLE, "weapon_deagle", "FN Browning BDM", 150, 28, 13.47},		// 701
	
	{CSW_GLOCK18, "weapon_glock18", "Mauser HSc", 225, 28, 29.42},			// 706
	{CSW_FIVESEVEN, "weapon_fiveseven", "FEMARU 29M", 300, 28, 37.48},		// 712
	{CSW_USP, "weapon_usp", "FEG P9R", 75, 29, 21.76},			 		// 718
	{CSW_P228, "weapon_p228", "FN FNP-9 / PRO-9", 150, 29, 23.36},			// 724
	{CSW_ELITE, "weapon_elite", "Taurus PT111", 225, 29, 20.86},			// 730
	{CSW_DEAGLE, "weapon_deagle", "HK-4", 300, 29, 14.16},			 	// 737
	
	{CSW_GLOCK18, "weapon_glock18", "Walther P88", 75, 30, 30.92},			// 742
	{CSW_FIVESEVEN, "weapon_fiveseven", "Astra mod. 400 & 600", 150, 30, 39.37},	// 748
	{CSW_USP, "weapon_usp", "Star Ultrastar", 225, 30, 22.85},			 	// 754
	{CSW_P228, "weapon_p228", "HK P11 underwater", 300, 30, 24.52},		// 760
	{CSW_ELITE, "weapon_elite", "Beretta 93R", 75, 31, 21.89},			 	// 766
	{CSW_DEAGLE, "weapon_deagle", "Tanfoglio Force", 150, 31, 14.85},		// 773
	
	{CSW_GLOCK18, "weapon_glock18", "OTs-27", 225, 31, 32.42},			 	// 778
	{CSW_FIVESEVEN, "weapon_fiveseven", "PB silenced", 300, 31, 41.27},		// 784
	{CSW_USP, "weapon_usp", "PSS silent", 75, 32, 23.94},			 		// 790
	{CSW_P228, "weapon_p228", "Type 80", 150, 32, 25.68},			 		// 796
	{CSW_ELITE, "weapon_elite", "P-83", 225, 32, 22.92},			 		// 802
	{CSW_DEAGLE, "weapon_deagle", "MP-448", 300, 32, 15.54},			 	// 809
	
	{CSW_GLOCK18, "weapon_glock18", "Ruger P-series", 75, 33, 33.92},		// 814
	{CSW_FIVESEVEN, "weapon_fiveseven", "Colt SSP", 150, 33, 43.16},			// 820
	{CSW_USP, "weapon_usp", "S&W 39", 225, 33, 25.04},			 		// 826
	{CSW_P228, "weapon_p228", "M70", 300, 33, 26.84},			 		// 832
	{CSW_ELITE, "weapon_elite", "CZ-99", 75, 34, 23.95},			 		// 838
	{CSW_DEAGLE, "weapon_deagle", "Wildey", 150, 34, 16.24},			 	// 845
	
	{CSW_GLOCK18, "weapon_glock18", "Mle. 1935A", 225, 34, 35.42},			// 850
	{CSW_FIVESEVEN, "weapon_fiveseven", "Sarsilmaz Kilinc 2000", 300, 34, 45.06},	// 856
	{CSW_USP, "weapon_usp", "Fort 14", 75, 35, 26.13},			 			// 862
	{CSW_P228, "weapon_p228", "AMT Automag II-V", 150, 35, 28.01},			// 868
	{CSW_ELITE, "weapon_elite", "Kel-tec PF-9", 225, 35, 24.98},			 	// 874
	{CSW_DEAGLE, "weapon_deagle", "Colt Double Eagle", 300, 35, 16.93},		// 881
	
	{CSW_GLOCK18, "weapon_glock18", "Nambu Type 94", 75, 36, 36.92},		// 886
	{CSW_FIVESEVEN, "weapon_fiveseven", "Vektor SP1 & SP2", 150, 36, 46.95},	// 892
	{CSW_USP, "weapon_usp", "Colt 1873 SAA", 225, 36, 27.22},			 	// 898
	{CSW_P228, "weapon_p228", "CZ 110", 300, 36, 29.17},			 		// 904
	{CSW_ELITE, "weapon_elite", "Sphinx 3000", 75, 37, 26.01},			 	// 910
	{CSW_DEAGLE, "weapon_deagle", "Mle. 1935A", 150, 37, 17.62}			 	// 916
};

enum _:structGrenades {
	weaponEnt_HE,
	weaponEnt_FB,
	weaponEnt_SG,
	weaponGrenadesNames[36],
	weaponGrenadesLevel,
	weaponGrenadesReset,
	grenadeSupernova,
	grenadeBubble
};

new const ARMAS_TERCIARIAS[][structGrenades] = {	// NIVEL , RESET , SNOVA , BUBBLE
	{1, 1, 1, "Combo - Hielo - Luz", 						1, 		0, 		0, 		0},
	{1, 2, 1, "Combo - Hielo x2 - Luz", 					150, 	0, 		0, 		0},
	{1, 2, 2, "Combo - Hielo x2 - Luz x2", 					200, 	0, 		0, 		0},
	{2, 2, 2, "Combo x2 - Hielo x2 - Luz x2", 				300, 	0, 		0, 		0},
	
	{1, 1, 1, "Combo - Supernova - Luz", 					50, 	1, 		1, 		0},
	{1, 1, 2, "Combo - Supernova - Luz x2", 				100, 	1, 		1, 		0},
	{2, 1, 2, "Combo x2 - Supernova - Luz x2", 				200, 	1, 		1, 		0},
	{2, 2, 2, "Combo x2 - Supernova x2 - Luz x2", 			300, 	1, 		2, 		0},
	
	{1, 1, 1, "Combo - Hielo - Bubble", 					50, 	2, 		0, 		1},
	{1, 2, 1, "Combo - Hielo x2 - Bubble",		 			100, 	2, 		0, 		1},
	{2, 2, 1, "Combo x2 - Hielo x2 - Bubble", 				200, 	2, 		0, 		1},
	{2, 2, 2, "Combo x2 - Hielo x2 - Bubble x2", 				300, 	2, 		0, 		2},
	
	{1, 1, 1, "Combo - Supernova - Bubble", 				150, 	3, 		1, 		1},
	{2, 1, 1, "Combo x2 - Supernova - Bubble", 				300, 	3, 		1, 		1},
	{2, 2, 1, "Combo x2 - Supernova x2 - Bubble", 			150, 	4, 		2, 		1},
	{2, 2, 2, "Combo x2 - Supernova x2 - Bubble x2", 			300, 	4, 		2, 		2}
};

enum _:structItemsExtras {
	extraName[32],
	extraCost,
	extraTeam,
	extraMaxPerUser, // 0=INFINITO
	extraMaxPerMap // 0=INFINITO
};

enum _:structExtrasTeam {
	EXTRA_HUMAN = 0,
	EXTRA_ZOMBIE
};

enum _:extraItemsId {
	EXTRA_NIGHTVISION = 0,
	EXTRA_LONGJUMP_H,
	EXTRA_BOMBA_ANIQUILACION,
	EXTRA_BALAS_INFINITAS,
	EXTRA_BOMBA_ANTIDOTO,
	EXTRA_INMUNIDAD,
	EXTRA_ANTIDOTO,
	EXTRA_FURIA,
	EXTRA_BOMBA_INFECCION,
	EXTRA_LONGJUMP_Z,
	EXTRA_PETRIFICACION
};

new Trie:g_tExtra_BombaAniquilacion;
new Trie:g_tExtra_BombaAntidoto;
new Trie:g_tExtra_Inmunidad;
new Trie:g_tExtra_Antidoto;
new Trie:g_tExtra_Furia;
new Trie:g_tExtra_BombaInfeccion;
new Trie:g_tExtra_Petrificacion;

new const ITEMS_EXTRAS[extraItemsId][structItemsExtras] = {
	{"Visión Nocturna", 20, EXTRA_HUMAN, 0, 0},
	{"Long Jump", 20, EXTRA_HUMAN, 0, 0},
	{"Bomba de Aniquilación", 50, EXTRA_HUMAN, 1, 3},
	{"Balas Infinitas", 30, EXTRA_HUMAN, 0, 0},
	{"Bomba Antidoto", 50, EXTRA_HUMAN, 1, 5},
	{"Inmunidad (10 seg)", 50, EXTRA_HUMAN, 1, 3},
	{"Antidoto", 30, EXTRA_ZOMBIE, 3, 0},
	{"Furia", 25, EXTRA_ZOMBIE, 3, 12},
	{"Bomba de Infección", 50, EXTRA_ZOMBIE, 1, 3},
	{"Long Jump", 20, EXTRA_ZOMBIE, 0, 0},
	{"Petrificación", 50, EXTRA_ZOMBIE, 1, 3}
};

new g_ItemExtra_Cost[MAX_USERS][extraItemsId];
new g_ItemExtra_PerMap[extraItemsId];
new g_ItemExtra_Count[MAX_USERS][extraItemsId];

enum _:comboStruct {
	comboNeed,
	comboRed,
	comboGreen,
	comboBlue,
	comboName[35],
	comboSound[30], comboSound2[30],
	comboMult
};

new const __COMBOS[][comboStruct] = {
	{0, 255, 255, 255, "¡First Blood!", "zp5/gk_first_blood.wav", "", 1},
	{7500, 0, 255, 0, "¡Double Kill!", "zp5/gk_double_kill.wav", "", 2},
	{15000, 0, 255, 255, "¡Multi Kill!", "zp5/gk_multi_kill.wav", "zp6/gk_f_multi_kill.wav", 3},
	{30000, 0, 0, 255, "¡Mega Kill!", "zp5/gk_mega_kill.wav", "zp6/gk_f_mega_kill.wav", 4},
	{50000, 255, 0, 255, "¡Ultra Kill!", "zp5/gk_ultra_kill.wav", "zp6/gk_f_ultra_kill.wav", 5},
	{75000, 255, 0, 255, "¡Monster Kill!", "zp5/gk_monster_kill.wav", "zp6/gk_f_monster_kill.wav", 6},
	{150000, 255, 255, 0, "¡Ludicrous Kill!", "zp5/gk_ludicrouss_kill.wav", "zp6/gk_f_ludicrouss_kill.wav", 7},
	{500000, 255, 0, 0, "¡Holy Shit!", "zp5/gk_holy_shit.wav", "zp6/gk_f_holy_shit.wav", 8},
	
	{2000000000, 255, 0, 0, "¡Holy Shit!", "zp5/gk_holy_shit.wav", "zp6/gk_f_holy_shit.wav", 8}
};

new const __COMBOS_ZOMBIE[][comboStruct] = {
	{1, 255, 255, 255, "¡First Blood!", "zp5/gk_first_blood.wav", "", 1},
	{2, 255, 255, 255, "¡First Blood!", "zp5/gk_first_blood.wav", "", 2},
	{3, 255, 255, 255, "¡First Blood!", "zp5/gk_first_blood.wav", "", 3},
	
	{4, 0, 255, 0, "¡Double Kill!", "zp5/gk_double_kill.wav", "", 4},
	{5, 0, 255, 0, "¡Double Kill!", "zp5/gk_double_kill.wav", "", 5},
	{6, 0, 255, 0, "¡Double Kill!", "zp5/gk_double_kill.wav", "", 6},
	
	{7, 0, 255, 255, "¡Multi Kill!", "zp5/gk_multi_kill.wav", "zp6/gk_f_multi_kill.wav", 7},
	{8, 0, 255, 255, "¡Multi Kill!", "zp5/gk_multi_kill.wav", "zp6/gk_f_multi_kill.wav", 8},
	{9, 0, 255, 255, "¡Multi Kill!", "zp5/gk_multi_kill.wav", "zp6/gk_f_multi_kill.wav", 9},
	
	{10, 0, 0, 255, "¡Mega Kill!", "zp5/gk_mega_kill.wav", "zp6/gk_f_mega_kill.wav", 10},
	{11, 0, 0, 255, "¡Mega Kill!", "zp5/gk_mega_kill.wav", "zp6/gk_f_mega_kill.wav", 11},
	{12, 0, 0, 255, "¡Mega Kill!", "zp5/gk_mega_kill.wav", "zp6/gk_f_mega_kill.wav", 12},
	
	{13, 255, 0, 255, "¡Ultra Kill!", "zp5/gk_ultra_kill.wav", "zp6/gk_f_ultra_kill.wav", 13},
	{14, 255, 0, 255, "¡Ultra Kill!", "zp5/gk_ultra_kill.wav", "zp6/gk_f_ultra_kill.wav", 14},
	{15, 255, 0, 255, "¡Ultra Kill!", "zp5/gk_ultra_kill.wav", "zp6/gk_f_ultra_kill.wav", 15},
	
	{16, 255, 0, 255, "¡Monster Kill!", "zp5/gk_monster_kill.wav", "zp6/gk_f_monster_kill.wav", 16},
	{17, 255, 0, 255, "¡Monster Kill!", "zp5/gk_monster_kill.wav", "zp6/gk_f_monster_kill.wav", 17},
	{18, 255, 0, 255, "¡Monster Kill!", "zp5/gk_monster_kill.wav", "zp6/gk_f_monster_kill.wav", 18},
	
	{19, 255, 0, 0, "¡Ludicrous Kill!", "zp5/gk_ludicrouss_kill.wav", "zp6/gk_f_ludicrouss_kill.wav", 19},
	{20, 255, 0, 0, "¡Ludicrous Kill!", "zp5/gk_ludicrouss_kill.wav", "zp6/gk_f_ludicrouss_kill.wav", 20},
	{21, 255, 0, 0, "¡Ludicrous Kill!", "zp5/gk_ludicrouss_kill.wav", "zp6/gk_f_ludicrouss_kill.wav", 21},
	
	{22, 255, 0, 0, "¡Holy Shit!", "zp5/gk_holy_shit.wav", "zp6/gk_f_holy_shit.wav", 22},
	{23, 255, 0, 0, "¡Holy Shit!", "zp5/gk_holy_shit.wav", "zp6/gk_f_holy_shit.wav", 23},
	{24, 255, 0, 0, "¡Holy Shit!", "zp5/gk_holy_shit.wav", "zp6/gk_f_holy_shit.wav", 24},
	
	{2000000000, 255, 0, 0, "¡Holy Shit!", "zp5/gk_holy_shit.wav", "zp6/gk_f_holy_shit.wav", 24}
};

enum _:colorOptions {
	COLOR_NONE = 0,
	COLOR_NIGHTVISION,
	COLOR_HUD,
	COLOR_FLARE,
	COLOR_BAZOOKA,
	COLOR_LASER
};

enum _:colorIds {
	__R = 0,
	__G,
	__B
};

enum _:structColor {
	colorName[16],
	colorRed,
	colorGreen,
	colorBlue
};

new const __COLOR[19][structColor] = {
	{"Blanco", 255, 255, 255},
	{"Rojo", 255, 0, 0},
	{"Verde", 0, 255, 0},
	{"Azul", 0, 0, 255},
	{"Amarillo", 255, 255, 0},
	{"Violeta", 255, 0, 255},
	{"Celeste", 0, 255, 255},
	{"Naranja", 255, 165, 0},
	
	{"Grisáceo", 100, 100, 100},
	{"Rosa", 255, 50, 179},
	{"Verde amarillo", 153, 204, 50},
	{"Sienna", 139, 71, 38},
	{"Naranja oscuro", 139, 30, 0},
	{"Verde panda", 0, 255, 127},
	{"Chartreus", 127, 255, 0},
	{"Azul marino", 0, 127, 255},
	{"Chocolate dulce", 107, 66, 38},
	{"Rojo violeta", 199, 21, 133},
	{"Gris pizarra", 198, 226, 255}
};

new g_Options_Color[MAX_USERS][colorOptions][colorIds];

enum _:hudIds {
	HUD_GENERAL = 0,
	HUD_COMBO
};

new Float:g_Options_HUD_Position[MAX_USERS][hudIds][3];
new g_Options_HUD_Effect[MAX_USERS][hudIds];
new g_Options_HUD_Abrev[MAX_USERS][hudIds];

enum _:classPoints {
	P_HUMAN = 0,
	P_ZOMBIE,
	P_UUT,
	P_LEGADO,
	P_DIAMONDS
};

new g_Points[MAX_USERS][classPoints];
new g_PointsLost[MAX_USERS][classPoints];

enum _:classHabilities {
	CLASS_HUMAN = 0,
	CLASS_ZOMBIE,
	CLASS_SURVIVOR,
	CLASS_NEMESIS,
	CLASS_WESKER,
	CLASS_JASON,
	CLASS_SPECIAL,
	CLASS_LEGENDARIAS,
	CLASS_LEGADO
};

#define MAX_HABILITIES	6
enum _:structHabilities {
	// HUMANOS
	HAB_HEALTH = 0,
	HAB_SPEED,
	HAB_GRAVITY,
	HAB_DAMAGE,
	HAB_H_ARMOR,
	
	// ZOMBIES
	/** HAB_HEALTH = 0, **/
	/** HAB_SPEED = 1, **/
	/** HAB_GRAVITY = 2, **/
	/** HAB_DAMAGE = 3, **/
	HAB_Z_COMBO = 4,
	HAB_Z_RESPAWN,
	
	// SURVIVOR
	/** HAB_HEALTH = 0, **/
	HAB_S_WEAPON = 1,
	HAB_S_GRENADE,
	HAB_S_IMMUNITY,
	
	// NEMESIS
	/** HAB_HEALTH = 0, **/
	HAB_N_DAMAGE = 1,
	
	// WESKER
	HAB_W_SUPER_LASER = 0,
	HAB_W_COMBO,
	
	// JASON
	HAB_J_TELEPORT = 0,
	HAB_J_COMBO,
	
	// SPECIAL
	HAB_SPECIAL_BUBBLE_TIME = 0,
	HAB_SPECIAL_RESPAWN,
	HAB_SPECIAL_VIGOR,
	HAB_SPECIAL_FURIA,
	HAB_SPECIAL_FLARE,
	
	// LEGENDARIAS
	HAB_LEGENDARY_WEAPONS_LV15 = 0,
	HAB_LEGENDARY_RESPAWN,
	HAB_LEGENDARY_INDUCCION,
	
	// LEGADO
	HAB_LEGADO_MULT_APS = 0,
	HAB_LEGADO_RESPAWN,
	HAB_LEGADO_RESISTENCIA
};

enum _:struct__Habilities {
	menuHabName[32],
	habMaxLevel,
	habValue,
	habCost
};

new const __HABILITIES[classHabilities][MAX_HABILITIES][struct__Habilities] = {
	// HUMANOS pH
	{
		{"VIDA", 50, 5, 3},
		{"VELOCIDAD", 50, 1, 3}, // DIVIDIDO 2 (0.5 | 25 al nivel 50)
		{"GRAVEDAD", 50, 1, 3}, // DIVIDIDO 166,666666 (0.006 | 0.3 al nivel 50)
		{"DAÑO", 50, 5, 3},
		{"CHALECO", 50, 4, 3},
		{"", 0, 0, 0}
	},
	
	// ZOMBIES pZ
	{
		{"VIDA", 100, 20000, 3},
		{"VELOCIDAD", 50, 1, 3}, // DIVIDIDO 2 (0.5 | 25 al nivel 50)
		{"GRAVEDAD", 50, 1, 3}, // DIVIDIDO 166,666666 (0.006 | 0.3 al nivel 50)
		{"DAÑO", 50, 5, 3},
		{"COMBO ZOMBIE", 1, 0, 15},
		{"REVIVIR COMO HUMANO (+2%)", 5, 2, 10}
	},
	
	// SURVIVOR pH
	{
		{"VIDA", 10, 250, 5},
		{"ARMA", 2, 0, 15},
		{"BOMBA DE ANIQUILACIÓN", 1, 0, 10},
		{"INMUNIDAD", 1, 0, 10},
		{"", 0, 0, 0},
		{"", 0, 0, 0}
	},
	
	// NEMESIS pZ
	{
		{"VIDA", 10, 50000, 5},
		{"DAÑO", 5, 100, 5},
		{"", 0, 0, 0},
		{"", 0, 0, 0},
		{"", 0, 0, 0},
		{"", 0, 0, 0}
	},
	
	// WESKER pH
	{
		{"SÚPER LASER", 1, 0, 15},
		{"HABILITAR COMBO", 1, 0, 10},
		{"", 0, 0, 0},
		{"", 0, 0, 0},
		{"", 0, 0, 0},
		{"", 0, 0, 0}
	},
	
	// JASON pH
	{
		{"TELETRANSPORTACIÓN", 1, 0, 15},
		{"HABILITAR COMBO", 1, 0, 10},
		{"", 0, 0, 0},
		{"", 0, 0, 0},
		{"", 0, 0, 0},
		{"", 0, 0, 0}
	},
	
	// SPECIAL Uut
	{
		{"TIEMPO BUBBLE (+2 SEG)", 1, 20, 25},
		{"REVIVIR COMO HUMANO (+5%)", 1, 5, 50},
		{"FURIA PROLONGADA (+1 SEG)", 2, 1, 30},
		{"VIGOR (+2%)", 3, 2, 25},
		{"AURA DE LUZ", 10, 1, 2},
		{"", 0, 0, 0}
	},
	
	// LEGENDARIAS Diamantes
	{
		{"TODAS LAS ARMAS A NIVEL 15", 1, 0, 200},
		{"REVIVIR COMO HUMANO (+5%)", 1, 5, 5},
		{"INDUCCIÓN (+1%)", 3, 1, 5},
		{"", 0, 0, 0},
		{"", 0, 0, 0},
		{"", 0, 0, 0}
	},
	
	// LEGADO pL
	{
		{"MULTIPLICADOR DE APS (+x0.1)", 10, 0, 20},
		{"REVIVIR COMO HUMANO (+5%)", 1, 5, 75},
		{"RESISTENCIA (+1%)", 5, 1, 30},
		{"", 0, 0, 0},
		{"", 0, 0, 0},
		{"", 0, 0, 0}
	}
};

new g_Hab[MAX_USERS][classHabilities][MAX_HABILITIES];

enum _:structMenuHabilities {
	menuClassName[15],
	menuPointsName[20],
	menuPointsId
};

new const MENU_HABS_TITLE[][structMenuHabilities] = {
	{"HUMANO", "Puntos Humano", P_HUMAN},
	{"ZOMBIE", "Puntos Zombie", P_ZOMBIE},
	{"SURVIVOR", "Puntos Humano", P_HUMAN},
	{"NEMESIS", "Puntos Zombie", P_ZOMBIE},
	{"WESKER", "Puntos Humano", P_HUMAN},
	{"JASON", "Puntos Humano", P_HUMAN},
	{"ESPECIALES", "Puntos Uut", P_UUT},
	{"LENGDARIAS", "Diamantes", P_DIAMONDS},
	{"DE LEGADO", "Puntos de Legado", P_LEGADO}
};

new const MODELS_ZOMBIE_CLAWS[][] = {
	"models/zombie_plague/tcs_garras_4.mdl"
};

enum _:structHumans {
	humanName[32],
	humanModel[48],
	humanReset,
	humanLevel,
	humanHealth,
	Float:humanSpeed,
	Float:humanGravity,
	humanDamagePercent
};

new const CLASES_HUMANAS[][structHumans] = {
	{"Antoni", "gk_humano_00", 0, 0, 100, 239.9, 1.000, 0},
	{"Leslie", "gk_humano_00", 0, 50, 105, 240.3, 0.998, 1},
	{"Bryan", "gk_humano_00", 0, 100, 110, 240.6, 0.996, 2},
	{"Vicente", "gk_humano_00", 0, 150, 115, 240.9, 0.994, 3},
	{"Cody", "gk_humano_00", 0, 200, 120, 241.2, 0.992, 4},
	{"Colby", "gk_humano_00", 0, 250, 125, 241.5, 0.990, 5},
	{"Ethan", "gk_humano_00", 0, 300, 130, 241.8, 0.988, 6},
	{"Leny", "gk_humano_00", 1, 50, 135, 242.1, 0.986, 7},
	{"Edison", "gk_humano_00", 1, 100, 140, 242.4, 0.984, 8},
	{"Edwin", "gk_humano_00", 1, 150, 145, 242.7, 0.982, 9},
	{"Shane", "gk_humano_00", 1, 200, 150, 243.0, 0.980, 10},
	{"Albert", "gk_humano_00", 1, 250, 155, 243.3, 0.978, 11},
	{"Scott", "gk_humano_00", 1, 300, 160, 243.6, 0.976, 12},
	{"Donovan", "gk_humano_00", 2, 50, 165, 243.9, 0.974, 13},
	{"Tyler", "gk_humano_00", 2, 100, 170, 244.2, 0.972, 14},
	{"Kevin", "gk_humano_00", 2, 150, 175, 244.5, 0.970, 15},
	{"John", "gk_humano_00", 2, 200, 180, 244.8, 0.968, 16},
	{"Isaac", "gk_humano_00", 2, 250, 185, 245.1, 0.966, 17},
	{"Franco", "gk_humano_00", 2, 300, 190, 245.4, 0.964, 18},
	{"Bill", "tcs_humano_1", 3, 50, 195, 245.7, 0.962, 19},
	{"Richard", "tcs_humano_1", 3, 100, 200, 246.0, 0.960, 20},
	{"Joseph", "tcs_humano_1", 3, 150, 205, 246.3, 0.958, 21},
	{"Dane", "tcs_humano_1", 3, 200, 210, 246.6, 0.956, 22},
	{"Jimmy", "tcs_humano_1", 3, 250, 215, 246.9, 0.954, 23},
	{"Alfred", "tcs_humano_1", 3, 300, 220, 247.2, 0.952, 24},
	{"Ramon", "tcs_humano_1", 4, 50, 225, 247.5, 0.950, 25},
	{"Kraus", "tcs_humano_1", 4, 100, 230, 247.8, 0.948, 26},
	{"Alex", "tcs_humano_1", 4, 150, 235, 248.1, 0.946, 27},
	{"Smith", "tcs_humano_1", 4, 200, 240, 248.4, 0.944, 28},
	{"Elvin", "tcs_humano_1", 4, 250, 245, 248.7, 0.942, 29},
	{"Will", "tcs_humano_1", 4, 300, 250, 249.0, 0.940, 30},
	{"Jason", "tcs_humano_1", 5, 50, 255, 249.3, 0.938, 31},
	{"Ronald", "tcs_humano_1", 5, 100, 260, 249.6, 0.936, 32},
	{"Seth", "tcs_humano_1", 5, 150, 265, 249.9, 0.934, 33},
	{"Derrick", "tcs_humano_1", 5, 200, 270, 250.2, 0.932, 34},
	{"Hershel", "tcs_humano_1", 5, 250, 275, 250.5, 0.930, 35},
	{"Richie", "tcs_humano_1", 5, 300, 280, 250.8, 0.928, 36},
	{"Igor", "tcs_humano_1", 6, 50, 285, 251.1, 0.926, 37},
	{"Jean", "tcs_humano_1", 6, 100, 290, 251.4, 0.924, 38},
	{"Julian", "tcs_humano_1", 6, 150, 295, 251.7, 0.922, 39}
	// {"Fox", "tcs_humano_2", 6, 200, 300, 252.0, 0.920, 40},
	// {"Johnny", "tcs_humano_2", 6, 250, 305, 252.3, 0.918, 41},
	// {"Alex", "tcs_humano_2", 6, 300, 310, 252.6, 0.916, 42},
	// {"Dimitri", "tcs_humano_2", 7, 50, 315, 252.9, 0.914, 43},
	// {"Logan", "tcs_humano_2", 7, 100, 320, 253.2, 0.912, 44},
	// {"Connor", "tcs_humano_2", 7, 150, 325, 253.5, 0.910, 45},
	// {"Danny", "tcs_humano_2", 7, 200, 330, 253.8, 0.908, 46},
	// {"Tommy", "tcs_humano_2", 7, 250, 335, 254.1, 0.906, 47},
	// {"Wesley", "tcs_humano_2", 7, 300, 340, 254.4, 0.904, 48},
	// {"Cory", "tcs_humano_2", 8, 50, 345, 254.7, 0.902, 49},
	// {"Samuel", "tcs_humano_2", 8, 100, 350, 255.0, 0.900, 50},
	// {"Vladimir", "tcs_humano_2", 8, 150, 355, 255.3, 0.898, 51},
	// {"Van", "tcs_humano_2", 8, 200, 360, 255.6, 0.896, 52},
	// {"Brad", "tcs_humano_2", 8, 250, 365, 255.9, 0.894, 53},
	// {"Steve", "tcs_humano_2", 8, 300, 370, 256.2, 0.892, 54},
	// {"Jeremy", "tcs_humano_2", 9, 50, 375, 256.5, 0.890, 55},
	// {"Dillon", "tcs_humano_2", 9, 100, 380, 256.8, 0.888, 56},
	// {"Nick", "tcs_humano_2", 9, 150, 385, 257.1, 0.886, 57},
	// {"Tristan", "tcs_humano_2", 9, 200, 390, 257.4, 0.884, 58},
	// {"Socrates", "tcs_humano_2", 9, 250, 395, 257.7, 0.882, 59},
	// {"Toby", "tcs_humano_4", 9, 300, 400, 258.0, 0.880, 60},
	// {"Roman", "tcs_humano_4", 10, 50, 405, 258.3, 0.878, 61},
	// {"Gerald", "tcs_humano_4", 10, 100, 410, 258.6, 0.876, 62},
	// {"Keiran", "tcs_humano_4", 10, 150, 415, 258.9, 0.874, 63},
	// {"Bob", "tcs_humano_4", 10, 200, 420, 259.2, 0.872, 64},
	// {"Xander", "tcs_humano_4", 10, 250, 425, 259.5, 0.870, 65},
	// {"Eric", "tcs_humano_4", 10, 300, 430, 259.8, 0.868, 66},
	// {"Ivan", "tcs_humano_4", 11, 50, 435, 260.1, 0.866, 67},
	// {"Bautista", "tcs_humano_4", 11, 100, 440, 260.3, 0.864, 68},
	// {"Valentin", "tcs_humano_4", 11, 150, 445, 260.6, 0.862, 69},
	// {"Alan", "tcs_humano_4", 11, 200, 450, 260.9, 0.860, 70},
	// {"Spangler", "tcs_humano_4", 11, 250, 455, 261.2, 0.858, 71},
	// {"Omar", "tcs_humano_4", 11, 300, 460, 261.5, 0.856, 72},
	// {"Gilberto", "tcs_humano_4", 12, 50, 465, 261.8, 0.854, 73},
	// {"Harry", "tcs_humano_4", 12, 100, 470, 262.1, 0.852, 74},
	// {"Gaye", "tcs_humano_4", 12, 150, 475, 262.4, 0.850, 75},
	// {"Robert", "tcs_humano_4", 12, 200, 480, 262.7, 0.848, 76},
	// {"Calvin", "tcs_humano_4", 12, 250, 485, 263.0, 0.846, 77},
	// {"Joe", "tcs_humano_4", 12, 300, 490, 263.3, 0.844, 78},
	// {"Sergio", "tcs_humano_4", 13, 50, 495, 263.6, 0.842, 79},
	// {"Bruno", "tcs_humano_6", 13, 100, 500, 263.9, 0.840, 80},
	// {"Simon", "tcs_humano_6", 13, 150, 505, 264.2, 0.838, 81},
	// {"Oswald", "tcs_humano_6", 13, 200, 510, 264.5, 0.836, 82},
	// {"Brandon", "tcs_humano_6", 13, 250, 515, 264.8, 0.834, 83},
	// {"Ryder", "tcs_humano_6", 13, 300, 520, 265.1, 0.832, 84},
	// {"Edith", "tcs_humano_6", 14, 50, 525, 265.4, 0.830, 85},
	// {"Dexter", "tcs_humano_6", 14, 100, 530, 265.7, 0.828, 86},
	// {"Douglas", "tcs_humano_6", 14, 150, 535, 266.0, 0.826, 87},
	// {"Mick", "tcs_humano_6", 14, 200, 540, 266.3, 0.824, 88},
	// {"Dustin", "tcs_humano_6", 14, 250, 545, 266.6, 0.822, 89},
	// {"Chad", "tcs_humano_6", 14, 300, 550, 266.9, 0.820, 90},
	// {"Anthony", "tcs_humano_6", 15, 50, 555, 267.2, 0.818, 91},
	// {"Vlad", "tcs_humano_6", 15, 100, 560, 267.5, 0.816, 92},
	// {"Hudson", "tcs_humano_6", 15, 150, 565, 267.8, 0.814, 93},
	// {"Charles", "tcs_humano_6", 15, 200, 570, 268.1, 0.812, 94},
	// {"James", "tcs_humano_6", 15, 250, 575, 268.4, 0.810, 95},
	// {"Byron", "tcs_humano_6", 15, 300, 580, 268.7, 0.808, 96},
	// {"Ian", "tcs_humano_6", 16, 50, 585, 269.0, 0.806, 97},
	// {"Mike", "tcs_humano_6", 16, 100, 590, 269.3, 0.804, 98},
	// {"Keni", "tcs_humano_6", 16, 150, 595, 269.6, 0.802, 99},
	// {"William", "tcs_humano_7", 16, 200, 600, 269.9, 0.800, 100},
	// {"Dominick", "tcs_humano_7", 16, 250, 605, 270.2, 0.798, 101},
	// {"Paul", "tcs_humano_7", 16, 300, 610, 270.5, 0.796, 102},
	// {"Leslie", "tcs_humano_7", 17, 50, 615, 270.8, 0.794, 103},
	// {"Justin", "tcs_humano_7", 17, 100, 620, 271.1, 0.792, 104},
	// {"Jonhson", "tcs_humano_7", 17, 150, 625, 271.4, 0.790, 105},
	// {"Eduard", "tcs_humano_7", 17, 200, 630, 271.7, 0.788, 106},
	// {"Virgil", "tcs_humano_7", 17, 250, 635, 272.0, 0.786, 107},
	// {"Claudy", "tcs_humano_7", 17, 300, 640, 272.3, 0.784, 108},
	// {"Raymond", "tcs_humano_7", 18, 50, 645, 272.6, 0.782, 109},
	// {"Otto", "tcs_humano_7", 18, 100, 650, 272.9, 0.780, 110},
	// {"Ryan", "tcs_humano_7", 18, 150, 655, 273.2, 0.778, 111},
	// {"Donald", "tcs_humano_7", 18, 200, 660, 273.5, 0.776, 112},
	// {"George", "tcs_humano_7", 18, 250, 665, 273.8, 0.774, 113},
	// {"Spielberg", "tcs_humano_7", 18, 300, 670, 274.1, 0.772, 114},
	// {"Adam", "tcs_humano_7", 19, 50, 675, 274.4, 0.770, 115},
	// {"Arthur", "tcs_humano_7", 19, 100, 680, 274.7, 0.768, 116},
	// {"Kyler", "tcs_humano_7", 19, 150, 685, 275.0, 0.766, 117},
	// {"Keith", "tcs_humano_7", 19, 200, 690, 275.3, 0.764, 118},
	// {"Christian", "tcs_humano_7", 19, 250, 695, 275.6, 0.762, 119},
	// {"Spencer", "tcs_humano_8", 19, 300, 700, 275.9, 0.760, 120},
	// {"Wade", "tcs_humano_8", 20, 50, 705, 276.2, 0.758, 121},
	// {"Snake", "tcs_humano_8", 20, 100, 710, 276.5, 0.756, 122},
	// {"Rocco", "tcs_humano_8", 20, 150, 715, 276.8, 0.754, 123},
	// {"Francisco", "tcs_humano_8", 20, 200, 720, 277.1, 0.752, 124},
	// {"Mikey", "tcs_humano_8", 20, 250, 725, 277.4, 0.750, 125},
	// {"Joel", "tcs_humano_8", 20, 300, 730, 277.7, 0.748, 126},
	// {"Jessy", "tcs_humano_8", 21, 50, 735, 278.0, 0.746, 127},
	// {"Devis", "tcs_humano_8", 21, 100, 740, 278.3, 0.744, 128},
	// {"Billy", "tcs_humano_8", 21, 150, 745, 278.6, 0.742, 129},
	// {"Henry", "tcs_humano_8", 21, 200, 750, 278.9, 0.740, 130},
	// {"Manuel", "tcs_humano_8", 21, 250, 755, 279.2, 0.738, 131},
	// {"Tyce", "tcs_humano_8", 21, 300, 760, 279.5, 0.736, 132},
	// {"Ben", "tcs_humano_8", 22, 50, 765, 279.8, 0.734, 133},
	// {"Sterling", "tcs_humano_8", 22, 100, 770, 280.1, 0.732, 134},
	// {"Robin", "tcs_humano_8", 22, 150, 775, 280.4, 0.730, 135},
	// {"Patrick", "tcs_humano_8", 22, 200, 780, 280.7, 0.728, 136},
	// {"Dante", "tcs_humano_8", 22, 250, 785, 281.0, 0.726, 137},
	// {"Lucio", "tcs_humano_8", 22, 300, 790, 281.3, 0.724, 138},
	// {"Steeve", "tcs_humano_8", 23, 50, 795, 281.6, 0.722, 139},
	// {"Gary", "tcs_humano16", 23, 100, 800, 281.9, 0.720, 140},
	// {"Frankie", "tcs_humano16", 23, 150, 805, 282.2, 0.718, 141},
	// {"Tom", "tcs_humano16", 23, 200, 810, 282.5, 0.716, 142},
	// {"Kameron", "tcs_humano16", 23, 250, 815, 282.8, 0.714, 143},
	// {"Randy", "tcs_humano16", 23, 300, 820, 283.1, 0.712, 144},
	// {"Eddy", "tcs_humano16", 24, 50, 825, 283.4, 0.710, 145},
	// {"Marcus", "tcs_humano16", 24, 100, 830, 283.7, 0.708, 146},
	// {"Ron", "tcs_humano16", 24, 150, 835, 284.0, 0.706, 147},
	// {"Kris", "tcs_humano16", 24, 200, 840, 284.3, 0.704, 148},
	// {"Leopoldo", "tcs_humano16", 24, 250, 845, 284.6, 0.702, 149},
	// {"Steven", "tcs_humano16", 24, 300, 850, 284.9, 0.700, 150},
	// {"Matt", "tcs_humano16", 25, 50, 855, 285.2, 0.698, 151},
	// {"Michael", "tcs_humano16", 25, 100, 860, 285.5, 0.696, 152},
	// {"Chuck", "tcs_humano16", 25, 150, 865, 285.8, 0.694, 153},
	// {"Jeremiah", "tcs_humano16", 25, 200, 870, 286.1, 0.692, 154},
	// {"Marco", "tcs_humano16", 25, 250, 875, 286.4, 0.690, 155},
	// {"Joey", "tcs_humano16", 25, 300, 880, 286.7, 0.688, 156},
	// {"Andrew", "tcs_humano16", 26, 50, 885, 287.0, 0.686, 157},
	// {"Jeff", "tcs_humano16", 26, 100, 890, 287.3, 0.684, 158},
	// {"Bruce", "tcs_humano16", 26, 150, 895, 287.6, 0.682, 159},
	// {"Bobby", "tcs_humano22", 26, 200, 900, 287.9, 0.680, 160},
	// {"Mark", "tcs_humano22", 26, 250, 905, 288.2, 0.678, 161},
	// {"Enzo", "tcs_humano22", 26, 300, 910, 288.5, 0.676, 162},
	// {"Frank", "tcs_humano22", 27, 50, 915, 288.8, 0.674, 163},
	// {"Jordan", "tcs_humano22", 27, 100, 920, 289.1, 0.672, 164},
	// {"Oliver", "tcs_humano22", 27, 150, 925, 289.4, 0.670, 165},
	// {"Nikolai", "tcs_humano22", 27, 200, 930, 289.7, 0.668, 166},
	// {"Erik", "tcs_humano22", 27, 250, 935, 290.0, 0.666, 167},
	// {"Gabriel", "tcs_humano22", 27, 300, 940, 290.3, 0.664, 168},
	// {"Trevor", "tcs_humano22", 28, 50, 945, 290.6, 0.662, 169},
	// {"Rudy", "tcs_humano22", 28, 100, 950, 290.9, 0.660, 170},
	// {"Sam", "tcs_humano22", 28, 150, 955, 291.2, 0.658, 171},
	// {"Percy", "tcs_humano22", 28, 200, 960, 291.5, 0.656, 172},
	// {"George", "tcs_humano22", 28, 250, 965, 291.8, 0.654, 173},
	// {"Alexander", "tcs_humano22", 28, 300, 970, 292.1, 0.652, 174},
	// {"Edward", "tcs_humano22", 29, 50, 975, 292.4, 0.650, 175},
	// {"Bernie", "tcs_humano22", 29, 100, 980, 292.7, 0.648, 176},
	// {"Carlo", "tcs_humano22", 29, 150, 985, 293.0, 0.646, 177},
	// {"Clover", "tcs_humano22", 29, 200, 990, 293.3, 0.644, 178},
	// {"Brian", "tcs_humano22", 29, 250, 995, 293.6, 0.642, 179},
	// {"Oscar", "gk_human_v00", 29, 300, 1000, 293.9, 0.640, 180},
	// {"Chester", "gk_human_v00", 30, 50, 1005, 294.2, 0.638, 181},
	// {"Tony", "gk_human_v00", 30, 100, 1010, 294.5, 0.636, 182},
	// {"Kenedi", "gk_human_v00", 30, 150, 1015, 294.8, 0.634, 183},
	// {"David", "gk_human_v00", 30, 200, 1020, 295.1, 0.632, 184},
	// {"Dennis", "gk_human_v00", 30, 250, 1025, 295.4, 0.630, 185},
	// {"Parker", "gk_human_v00", 30, 300, 1030, 295.7, 0.628, 186},
	// {"Frederick", "gk_human_v00", 31, 50, 1035, 296.0, 0.626, 187},
	// {"Umberto", "gk_human_v00", 31, 100, 1040, 296.3, 0.624, 188},
	// {"Logan", "gk_human_v00", 31, 150, 1045, 296.6, 0.622, 189},
	// {"Peter", "gk_human_v00", 31, 200, 1050, 296.9, 0.620, 190},
	// {"Evan", "gk_human_v00", 31, 250, 1055, 297.2, 0.618, 191},
	// {"Matt", "gk_human_v00", 31, 300, 1060, 297.5, 0.616, 192},
	// {"Uriel", "gk_human_v00", 32, 50, 1065, 297.8, 0.614, 193},
	// {"Ivor", "gk_human_v00", 32, 100, 1070, 298.1, 0.612, 194},
	// {"Harold", "gk_human_v00", 32, 150, 1075, 298.4, 0.610, 195},
	// {"Dylan", "gk_human_v00", 32, 200, 1080, 298.7, 0.608, 196},
	// {"Jacob", "gk_human_v00", 32, 250, 1085, 299.0, 0.606, 197},
	// {"Kymber", "gk_human_v00", 32, 300, 1090, 299.3, 0.604, 198},
	// {"TONS", "gk_human_v00", 33, 50, 1095, 299.6, 0.602, 199}
};

enum _:structZombies {
	zombieName[32],
	zombieModel[48],
	zombieClawModel[48],
	zombieReset,
	zombieLevel,
	zombieHealth,
	Float:zombieSpeed,
	Float:zombieGravity
};

new const CLASES_ZOMBIE[][structZombies] = {
	{"Laisha", "tcs_zombie_5", "models/zombie_plague/tcs_garras_4.mdl", 0, 1, 20000, 249.9, 1.0000},
	{"Reabump", "tcs_zombie_5", "models/zombie_plague/tcs_garras_4.mdl", 0, 50, 40000, 250.3, 0.9975},
	{"Abel", "tcs_zombie_5", "models/zombie_plague/tcs_garras_4.mdl", 0, 100, 60000, 250.6, 0.9950},
	{"Brigid", "tcs_zombie_5", "models/zombie_plague/tcs_garras_4.mdl", 0, 150, 80000, 250.9, 0.9925},
	{"Izan", "tcs_zombie_5", "models/zombie_plague/tcs_garras_4.mdl", 0, 200, 100000, 251.2, 0.9900},
	{"Strein", "tcs_zombie_5", "models/zombie_plague/tcs_garras_4.mdl", 0, 250, 120000, 251.5, 0.9875},
	{"Atila", "tcs_zombie_5", "models/zombie_plague/tcs_garras_4.mdl", 0, 300, 140000, 251.8, 0.9850},
	{"Rykeir", "tcs_zombie_5", "models/zombie_plague/tcs_garras_4.mdl", 1, 50, 160000, 252.1, 0.9825},
	{"Ieshia", "tcs_zombie_5", "models/zombie_plague/tcs_garras_4.mdl", 1, 100, 180000, 252.4, 0.9800},
	{"Igniter", "tcs_zombie_5", "models/zombie_plague/tcs_garras_4.mdl", 1, 150, 200000, 252.7, 0.9775},
	{"P33L", "tcs_zombie_5", "models/zombie_plague/tcs_garras_4.mdl", 1, 200, 220000, 253.0, 0.9750},
	{"Masvindo", "tcs_zombie_5", "models/zombie_plague/tcs_garras_4.mdl", 1, 250, 240000, 253.3, 0.9725},
	{"Ander", "tcs_zombie_5", "models/zombie_plague/tcs_garras_4.mdl", 1, 300, 260000, 253.6, 0.9700},
	{"Oyane", "tcs_zombie_5", "models/zombie_plague/tcs_garras_4.mdl", 2, 50, 280000, 253.9, 0.9675},
	{"Anouk", "tcs_zombie_5", "models/zombie_plague/tcs_garras_4.mdl", 2, 100, 300000, 254.2, 0.9650},
	{"Jozef", "tcs_zombie_9", "models/zombie_plague/tcs_garras_4.mdl", 2, 150, 320000, 254.5, 0.9625},
	{"Wyat", "tcs_zombie_9", "models/zombie_plague/tcs_garras_4.mdl", 2, 200, 340000, 254.8, 0.9600},
	{"Kumiyo", "tcs_zombie_9", "models/zombie_plague/tcs_garras_4.mdl", 2, 250, 360000, 255.1, 0.9575},
	{"Eragdush", "tcs_zombie_9", "models/zombie_plague/tcs_garras_4.mdl", 2, 300, 380000, 255.4, 0.9550},
	{"Eros", "tcs_zombie_9", "models/zombie_plague/tcs_garras_4.mdl", 3, 50, 400000, 255.7, 0.9525},
	{"Kerry", "tcs_zombie_9", "models/zombie_plague/tcs_garras_2.mdl", 3, 100, 420000, 256.0, 0.9500},
	{"Orvall", "tcs_zombie_9", "models/zombie_plague/tcs_garras_2.mdl", 3, 150, 440000, 256.3, 0.9475},
	{"Felix", "tcs_zombie_9", "models/zombie_plague/tcs_garras_2.mdl", 3, 200, 460000, 256.6, 0.9450},
	{"Farrar", "tcs_zombie_9", "models/zombie_plague/tcs_garras_2.mdl", 3, 250, 480000, 256.9, 0.9425},
	{"Xicht", "tcs_zombie_9", "models/zombie_plague/tcs_garras_2.mdl", 3, 300, 500000, 257.2, 0.9400},
	{"Rewttem", "tcs_zombie_9", "models/zombie_plague/tcs_garras_2.mdl", 4, 50, 520000, 257.4, 0.9375},
	{"Dagoff", "tcs_zombie_9", "models/zombie_plague/tcs_garras_2.mdl", 4, 100, 540000, 257.7, 0.9350},
	{"Kalbeh", "tcs_zombie_9", "models/zombie_plague/tcs_garras_2.mdl", 4, 150, 560000, 258.0, 0.9325},
	{"Seraph", "tcs_zombie_9", "models/zombie_plague/tcs_garras_2.mdl", 4, 200, 580000, 258.3, 0.9300},
	{"Heshua", "tcs_zombie_9", "models/zombie_plague/tcs_garras_2.mdl", 4, 250, 600000, 258.6, 0.9275},
	{"Emerick", "tcs_zombie_9", "models/zombie_plague/tcs_garras_2.mdl", 4, 300, 620000, 258.9, 0.9250},
	{"Igor", "tcs_zombie_9", "models/zombie_plague/tcs_garras_2.mdl", 5, 50, 640000, 259.2, 0.9225},
	{"Keogh", "tcs_zombie_2", "models/zombie_plague/tcs_garras_2.mdl", 5, 100, 660000, 259.5, 0.9200},
	{"Jantel", "tcs_zombie_2", "models/zombie_plague/tcs_garras_2.mdl", 5, 150, 680000, 259.8, 0.9175},
	{"Anchraf", "tcs_zombie_2", "models/zombie_plague/tcs_garras_2.mdl", 5, 200, 700000, 260.1, 0.9150},
	{"SheKa", "tcs_zombie_2", "models/zombie_plague/tcs_garras_2.mdl", 5, 250, 720000, 260.4, 0.9125},
	{"Panby", "tcs_zombie_2", "models/zombie_plague/tcs_garras_2.mdl", 5, 300, 740000, 260.7, 0.9100},
	{"Xatila", "tcs_zombie_2", "models/zombie_plague/tcs_garras_2.mdl", 6, 50, 760000, 261.0, 0.9075},
	{"Keith", "tcs_zombie_2", "models/zombie_plague/tcs_garras_2.mdl", 6, 100, 780000, 261.3, 0.9050},
	{"Peylt", "tcs_zombie_2", "models/zombie_plague/tcs_garras_2.mdl", 6, 150, 800000, 261.6, 0.9025},
	{"Yago", "tcs_zombie_2", "models/zombie_plague/tcs_garras_1.mdl", 6, 200, 820000, 261.9, 0.9000},
	{"Lzyien", "tcs_zombie_2", "models/zombie_plague/tcs_garras_1.mdl", 6, 250, 840000, 262.2, 0.8975},
	{"Birger", "tcs_zombie_2", "models/zombie_plague/tcs_garras_1.mdl", 6, 300, 860000, 262.5, 0.8950},
	{"Hatzive", "tcs_zombie_2", "models/zombie_plague/tcs_garras_1.mdl", 7, 50, 880000, 262.8, 0.8925},
	{"Judith", "tcs_zombie_2", "models/zombie_plague/tcs_garras_1.mdl", 7, 100, 900000, 263.1, 0.8900},
	{"Farrel", "tcs_zombie_2", "models/zombie_plague/tcs_garras_1.mdl", 7, 150, 920000, 263.4, 0.8875},
	{"Owen", "tcs_zombie_2", "models/zombie_plague/tcs_garras_1.mdl", 7, 200, 940000, 263.7, 0.8850},
	{"Danton", "tcs_zombie_2", "models/zombie_plague/tcs_garras_1.mdl", 7, 250, 960000, 264.0, 0.8825}
	// {"Ditto", "gk_zombie_14", "models/zombie_plague/tcs_garras_1.mdl", 7, 300, 980000, 264.3, 0.8800},
	// {"Blazet", "gk_zombie_14", "models/zombie_plague/tcs_garras_1.mdl", 8, 50, 1000000, 264.6, 0.8775},
	// {"Hazari", "gk_zombie_14", "models/zombie_plague/tcs_garras_1.mdl", 8, 100, 1020000, 264.9, 0.8750},
	// {"Repko", "gk_zombie_14", "models/zombie_plague/tcs_garras_1.mdl", 8, 150, 1040000, 265.2, 0.8725},
	// {"Ish", "gk_zombie_14", "models/zombie_plague/tcs_garras_1.mdl", 8, 200, 1060000, 265.5, 0.8700},
	// {"Acacio", "gk_zombie_14", "models/zombie_plague/tcs_garras_1.mdl", 8, 250, 1080000, 265.8, 0.8675},
	// {"Mystic", "gk_zombie_14", "models/zombie_plague/tcs_garras_1.mdl", 8, 300, 1100000, 266.1, 0.8650},
	// {"Beat", "gk_zombie_14", "models/zombie_plague/tcs_garras_1.mdl", 9, 50, 1120000, 266.4, 0.8625},
	// {"Vylk", "gk_zombie_14", "models/zombie_plague/tcs_garras_1.mdl", 9, 100, 1140000, 266.7, 0.8600},
	// {"Artemis", "gk_zombie_14", "models/zombie_plague/tcs_garras_1.mdl", 9, 150, 1160000, 267.0, 0.8575},
	// {"Joffe" "gk_zombie_14", "models/zombie_plague/tcs_garras_1.mdl", 9, 200, 1180000, 267.3, 0.8550},
	// {"Mawuli", "gk_zombie_14", "models/zombie_plague/tcs_garras_1.mdl", 9, 250, 1200000, 267.6, 0.8525},
	// {"Karko", "gk_zombie_14", "models/zombie_plague/tcs_garras_5.mdl", 9, 300, 1220000, 267.9, 0.8500},
	// {"Glën", "gk_zombie_14", "models/zombie_plague/tcs_garras_5.mdl", 10, 50, 1240000, 268.2, 0.8475},
	// {"Percival", "gk_zombie_14", "models/zombie_plague/tcs_garras_5.mdl", 10, 100, 1260000, 268.5, 0.8450},
	// {"Opal", "gk_zombie_14", "models/zombie_plague/tcs_garras_5.mdl", 10, 150, 1280000, 268.8, 0.8425},
	// {"Rayén", "gk_zombie_13", "models/zombie_plague/tcs_garras_5.mdl", 10, 200, 1300000, 269.1, 0.8400},
	// {"Ixchel", "gk_zombie_13", "models/zombie_plague/tcs_garras_5.mdl", 10, 250, 1320000, 269.4, 0.8375},
	// {"Odette", "gk_zombie_13", "models/zombie_plague/tcs_garras_5.mdl", 10, 300, 1340000, 269.7, 0.8350},
	// {"Orvan", "gk_zombie_13", "models/zombie_plague/tcs_garras_5.mdl", 11, 50, 1360000, 270.0, 0.8325},
	// {"Jair", "gk_zombie_13", "models/zombie_plague/tcs_garras_5.mdl", 11, 100, 1380000, 270.3, 0.8300},
	// {"Kankis", "gk_zombie_13", "models/zombie_plague/tcs_garras_5.mdl", 11, 150, 1400000, 270.6, 0.8275},
	// {"Belzee", "gk_zombie_13", "models/zombie_plague/tcs_garras_5.mdl", 11, 200, 1420000, 270.9, 0.8250},
	// {"Jalap", "gk_zombie_13", "models/zombie_plague/tcs_garras_5.mdl", 11, 250, 1440000, 271.2, 0.8225},
	// {"Habib", "gk_zombie_13", "models/zombie_plague/tcs_garras_5.mdl", 11, 300, 1460000, 271.5, 0.8200},
	// {"Katso", "gk_zombie_13", "models/zombie_plague/tcs_garras_5.mdl", 12, 50, 1480000, 271.8, 0.8175},
	// {"Couture", "gk_zombie_13", "models/zombie_plague/tcs_garras_5.mdl", 12, 100, 1500000, 272.1, 0.8150},
	// {"Arcadip", "gk_zombie_13", "models/zombie_plague/tcs_garras_5.mdl", 12, 150, 1520000, 272.4, 0.8125},
	// {"Ildiko", "gk_zombie_13", "models/zombie_plague/tcs_garras_5.mdl", 12, 200, 1540000, 272.7, 0.8100},
	// {"Sharis", "gk_zombie_13", "models/zombie_plague/tcs_garras_5.mdl", 12, 250, 1560000, 273.0, 0.8075},
	// {"Jerhp 194", "gk_zombie_13", "models/zombie_plague/tcs_garras_5.mdl", 12, 300, 1580000, 273.3, 0.8050},
	// {"Saulios", "gk_zombie_13", "models/zombie_plague/tcs_garras_5.mdl", 13, 50, 1600000, 273.6, 0.8025},
	// {"Hipolit", "tcs_zombie_3", "models/zombie_plague/tcs_garras_9.mdl", 13, 100, 1620000, 273.9, 0.8000},
	// {"Pawiner", "tcs_zombie_3", "models/zombie_plague/tcs_garras_9.mdl", 13, 150, 1640000, 274.2, 0.7975},
	// {"Aldo", "tcs_zombie_3", "models/zombie_plague/tcs_garras_9.mdl", 13, 200, 1660000, 274.5, 0.7950},
	// {"Raxoi", "tcs_zombie_3", "models/zombie_plague/tcs_garras_9.mdl", 13, 250, 1680000, 274.8, 0.7925},
	// {"Elio", "tcs_zombie_3", "models/zombie_plague/tcs_garras_9.mdl", 13, 300, 1700000, 275.1, 0.7900},
	// {"Nicte", "tcs_zombie_3", "models/zombie_plague/tcs_garras_9.mdl", 14, 50, 1720000, 275.4, 0.7875},
	// {"Maurihl", "tcs_zombie_3", "models/zombie_plague/tcs_garras_9.mdl", 14, 100, 1740000, 275.7, 0.7850},
	// {"Harald", "tcs_zombie_3", "models/zombie_plague/tcs_garras_9.mdl", 14, 150, 1760000, 276.0, 0.7825},
	// {"Ridley", "tcs_zombie_3", "models/zombie_plague/tcs_garras_9.mdl", 14, 200, 1780000, 276.3, 0.7800},
	// {"Baltasar", "tcs_zombie_3", "models/zombie_plague/tcs_garras_9.mdl", 14, 250, 1800000, 276.6, 0.7775},
	// {"Kaxroi", "tcs_zombie_3", "models/zombie_plague/tcs_garras_9.mdl", 14, 300, 1820000, 276.9, 0.7750},
	// {"Boorm", "tcs_zombie_3", "models/zombie_plague/tcs_garras_9.mdl", 15, 50, 1840000, 277.2, 0.7725},
	// {"Miztlï", "tcs_zombie_3", "models/zombie_plague/tcs_garras_9.mdl", 15, 100, 1860000, 277.5, 0.7700},
	// {"Pugg3", "tcs_zombie_3", "models/zombie_plague/tcs_garras_9.mdl", 15, 150, 1880000, 277.8, 0.7675},
	// {"Mustif", "tcs_zombie_3", "models/zombie_plague/tcs_garras_9.mdl", 15, 200, 1900000, 278.1, 0.7650},
	// {"Stalph", "tcs_zombie_3", "models/zombie_plague/tcs_garras_9.mdl", 15, 250, 1920000, 278.4, 0.7625},
	// {"Villusto", "tcs_zombie_9", "models/zombie_plague/tcs_garras_9.mdl", 15, 300, 1940000, 278.7, 0.7600},
	// {"Kruked", "tcs_zombie_9", "models/zombie_plague/tcs_garras_9.mdl", 16, 50, 1960000, 279.0, 0.7575},
	// {"Rev", "tcs_zombie_9", "models/zombie_plague/tcs_garras_9.mdl", 16, 100, 1980000, 279.3, 0.7550},
	// {"Loïc", "tcs_zombie_9", "models/zombie_plague/tcs_garras_9.mdl", 16, 150, 2000000, 279.6, 0.7525},
	// {"Jabba", "tcs_zombie_9", "models/zombie_plague/tcs_garras_10.mdl", 16, 200, 2020000, 279.9, 0.7500},
	// {"Hat", "tcs_zombie_9", "models/zombie_plague/tcs_garras_10.mdl", 16, 250, 2040000, 280.2, 0.7475},
	// {"Quions", "tcs_zombie_9", "models/zombie_plague/tcs_garras_10.mdl", 16, 300, 2060000, 280.5, 0.7450},
	// {"Maplaco", "tcs_zombie_9", "models/zombie_plague/tcs_garras_10.mdl", 17, 50, 2080000, 280.8, 0.7425},
	// {"Hubbie", "tcs_zombie_9", "models/zombie_plague/tcs_garras_10.mdl", 17, 100, 2100000, 281.1, 0.7400},
	// {"Gael", "tcs_zombie_9", "models/zombie_plague/tcs_garras_10.mdl", 17, 150, 2120000, 281.4, 0.7375},
	// {"Ordalk", "tcs_zombie_9", "models/zombie_plague/tcs_garras_10.mdl", 17, 200, 2140000, 281.7, 0.7350},
	// {"Ñempo", "tcs_zombie_9", "models/zombie_plague/tcs_garras_10.mdl", 17, 250, 2160000, 282.0, 0.7325},
	// {"Lotuxo", "tcs_zombie_9", "models/zombie_plague/tcs_garras_10.mdl", 17, 300, 2180000, 282.3, 0.7300},
	// {"Eder", "tcs_zombie_9", "models/zombie_plague/tcs_garras_10.mdl", 18, 50, 2200000, 282.6, 0.7275},
	// {"Hoppom", "tcs_zombie_9", "models/zombie_plague/tcs_garras_10.mdl", 18, 100, 2220000, 282.9, 0.7250},
	// {"Sugan", "tcs_zombie_9", "models/zombie_plague/tcs_garras_10.mdl", 18, 150, 2240000, 283.2, 0.7225},
	// {"Jann", "tcs_zombie_12", "models/zombie_plague/tcs_garras_10.mdl", 18, 200, 2260000, 283.5, 0.7200},
	// {"Wattie", "tcs_zombie_12", "models/zombie_plague/tcs_garras_10.mdl", 18, 250, 2280000, 283.8, 0.7175},
	// {"Darest", "tcs_zombie_12", "models/zombie_plague/tcs_garras_10.mdl", 18, 300, 2300000, 284.1, 0.7150},
	// {"Jocal", "tcs_zombie_12", "models/zombie_plague/tcs_garras_10.mdl", 19, 50, 2320000, 284.4, 0.7125},
	// {"Torp", "tcs_zombie_12", "models/zombie_plague/tcs_garras_10.mdl", 19, 100, 2340000, 284.7, 0.7100},
	// {"Bossie", "tcs_zombie_12", "models/zombie_plague/tcs_garras_10.mdl", 19, 150, 2360000, 285.0, 0.7075},
	// {"Efim", "tcs_zombie_12", "models/zombie_plague/tcs_garras_10.mdl", 19, 200, 2380000, 285.3, 0.7050},
	// {"Calixto", "tcs_zombie_12", "models/zombie_plague/tcs_garras_10.mdl", 19, 250, 2400000, 285.6, 0.7025},
	// {"Cirilop", "tcs_zombie_12", "models/zombie_plague/tcs_garras_15.mdl", 19, 300, 2420000, 285.9, 0.7000},
	// {"Neiv", "tcs_zombie_12", "models/zombie_plague/tcs_garras_15.mdl", 20, 50, 2440000, 286.2, 0.6975},
	// {"Cedric", "tcs_zombie_12", "models/zombie_plague/tcs_garras_15.mdl", 20, 100, 2460000, 286.5, 0.6950},
	// {"Bophary", "tcs_zombie_12", "models/zombie_plague/tcs_garras_15.mdl", 20, 150, 2480000, 286.8, 0.6925},
	// {"Yannick", "tcs_zombie_12", "models/zombie_plague/tcs_garras_15.mdl", 20, 200, 2500000, 287.1, 0.6900},
	// {"Shelly", "tcs_zombie_12", "models/zombie_plague/tcs_garras_15.mdl", 20, 250, 2520000, 287.4, 0.6875},
	// {"Jalton", "tcs_zombie_12", "models/zombie_plague/tcs_garras_15.mdl", 20, 300, 2540000, 287.7, 0.6850},
	// {"Gunks", "tcs_zombie_12", "models/zombie_plague/tcs_garras_15.mdl", 21, 50, 2560000, 288.0, 0.6825},
	// {"Emireth", "tcs_zombie_12", "models/zombie_plague/tcs_garras_15.mdl", 21, 100, 2580000, 288.3, 0.6800},
	// {"Rawtol", "tcs_zombie_12", "models/zombie_plague/tcs_garras_15.mdl", 21, 150, 2600000, 288.6, 0.6775},
	// {"Rexoy", "tcs_zombie_12", "models/zombie_plague/tcs_garras_15.mdl", 21, 200, 2620000, 288.9, 0.6750},
	// {"Teya", "tcs_zombie_12", "models/zombie_plague/tcs_garras_15.mdl", 21, 250, 2640000, 289.2, 0.6725},
	// {"Nyklus", "tcs_zombie_12", "models/zombie_plague/tcs_garras_15.mdl", 21, 300, 2660000, 289.5, 0.6700},
	// {"Cullen", "tcs_zombie_12", "models/zombie_plague/tcs_garras_15.mdl", 22, 50, 2680000, 289.8, 0.6675},
	// {"Vicam", "tcs_zombie_13", "models/zombie_plague/tcs_garras_15.mdl", 22, 100, 2700000, 290.1, 0.6650},
	// {"Shug-im", "tcs_zombie_13", "models/zombie_plague/tcs_garras_15.mdl", 22, 150, 2720000, 290.4, 0.6625},
	// {"Katz", "tcs_zombie_13", "models/zombie_plague/tcs_garras_15.mdl", 22, 200, 2740000, 290.7, 0.6600},
	// {"Ayrton", "tcs_zombie_13", "models/zombie_plague/tcs_garras_15.mdl", 22, 250, 2760000, 291.0, 0.6575},
	// {"Gunter", "tcs_zombie_13", "models/zombie_plague/tcs_garras_15.mdl", 22, 300, 2780000, 291.3, 0.6550},
	// {"Evjen", "tcs_zombie_13", "models/zombie_plague/tcs_garras_15.mdl", 23, 50, 2800000, 291.6, 0.6525},
	// {"Creep", "tcs_zombie_13", "models/zombie_plague/tcs_garras_16.mdl", 23, 100, 2820000, 291.9, 0.6500},
	// {"Douglas", "tcs_zombie_13", "models/zombie_plague/tcs_garras_16.mdl", 23, 150, 2840000, 292.2, 0.6475},
	// {"Miiak", "tcs_zombie_13", "models/zombie_plague/tcs_garras_16.mdl", 23, 200, 2860000, 292.5, 0.6450},
	// {"AMMRax", "tcs_zombie_13", "models/zombie_plague/tcs_garras_16.mdl", 23, 250, 2880000, 292.8, 0.6425},
	// {"Akizon", "tcs_zombie_13", "models/zombie_plague/tcs_garras_16.mdl", 23, 300, 2900000, 293.1, 0.6400},
	// {"Wexar", "tcs_zombie_13", "models/zombie_plague/tcs_garras_16.mdl", 24, 50, 2920000, 293.4, 0.6375},
	// {"Kair", "tcs_zombie_13", "models/zombie_plague/tcs_garras_16.mdl", 24, 100, 2940000, 293.7, 0.6350},
	// {"Haydee", "tcs_zombie_13", "models/zombie_plague/tcs_garras_16.mdl", 24, 150, 2960000, 294.0, 0.6325},
	// {"Obrian", "tcs_zombie_13", "models/zombie_plague/tcs_garras_16.mdl", 24, 200, 2980000, 294.3, 0.6300},
	// {"Priam", "tcs_zombie_13", "models/zombie_plague/tcs_garras_16.mdl", 24, 250, 3000000, 294.6, 0.6275},
	// {"Dahl", "tcs_zombie_13", "models/zombie_plague/tcs_garras_16.mdl", 24, 300, 3020000, 294.9, 0.6250},
	// {"Heisel", "tcs_zombie_13", "models/zombie_plague/tcs_garras_16.mdl", 25, 50, 3040000, 295.2, 0.6225},
	// {"Yair", "tcs_zombie_13", "models/zombie_plague/tcs_garras_16.mdl", 25, 100, 3060000, 295.5, 0.6200},
	// {"Eliud", "tcs_zombie_13", "models/zombie_plague/tcs_garras_16.mdl", 25, 150, 3080000, 295.8, 0.6175},
	// {"Cebrian", "tcs_zombie_13", "models/zombie_plague/tcs_garras_16.mdl", 25, 200, 3100000, 296.1, 0.6150},
	// {"Esther", "tcs_zombie_13", "models/zombie_plague/tcs_garras_16.mdl", 25, 250, 3120000, 296.4, 0.6125},
	// {"Ziortz", "tcs_zombie_17", "models/zombie_plague/tcs_garras_16.mdl", 25, 300, 3140000, 296.7, 0.6100},
	// {"Palord", "tcs_zombie_17", "models/zombie_plague/tcs_garras_16.mdl", 26, 50, 3160000, 297.0, 0.6075},
	// {"Loopac", "tcs_zombie_17", "models/zombie_plague/tcs_garras_16.mdl", 26, 100, 3180000, 297.3, 0.6050},
	// {"Annick", "tcs_zombie_17", "models/zombie_plague/tcs_garras_16.mdl", 26, 150, 3200000, 297.6, 0.6025},
	// {"Yordonco", "tcs_zombie_17", "models/zombie_plague/tcs_garras_18.mdl", 26, 200, 3220000, 297.9, 0.6000},
	// {"Breyel", "tcs_zombie_17", "models/zombie_plague/tcs_garras_18.mdl", 26, 250, 3240000, 298.2, 0.5975},
	// {"Wolfox", "tcs_zombie_17", "models/zombie_plague/tcs_garras_18.mdl", 26, 300, 3260000, 298.5, 0.5950},
	// {"Bossax", "tcs_zombie_17", "models/zombie_plague/tcs_garras_18.mdl", 27, 50, 3280000, 298.8, 0.5925},
	// {"Mark", "tcs_zombie_17", "models/zombie_plague/tcs_garras_18.mdl", 27, 100, 3300000, 299.1, 0.5900},
	// {"Abalev", "tcs_zombie_17", "models/zombie_plague/tcs_garras_18.mdl", 27, 150, 3320000, 299.4, 0.5875},
	// {"Kirios", "tcs_zombie_17", "models/zombie_plague/tcs_garras_18.mdl", 27, 200, 3340000, 299.7, 0.5850},
	// {"Brad", "tcs_zombie_17", "models/zombie_plague/tcs_garras_18.mdl", 27, 250, 3360000, 300.0, 0.5825},
	// {"Gratin", "tcs_zombie_17", "models/zombie_plague/tcs_garras_18.mdl", 27, 300, 3380000, 300.3, 0.5800},
	// {"Mooly", "tcs_zombie_17", "models/zombie_plague/tcs_garras_18.mdl", 28, 50, 3400000, 300.6, 0.5775},
	// {"Damful", "tcs_zombie_17", "models/zombie_plague/tcs_garras_18.mdl", 28, 100, 3420000, 300.9, 0.5750},
	// {"Karl", "tcs_zombie_17", "models/zombie_plague/tcs_garras_18.mdl", 28, 150, 3440000, 301.2, 0.5725},
	// {"Fitsum", "tcs_zombie_17", "models/zombie_plague/tcs_garras_18.mdl", 28, 200, 3460000, 301.5, 0.5700},
	// {"Claito", "tcs_zombie_17", "models/zombie_plague/tcs_garras_18.mdl", 28, 250, 3480000, 301.8, 0.5675},
	// {"Kaled", "tcs_zombie_17", "models/zombie_plague/tcs_garras_18.mdl", 28, 300, 3500000, 302.1, 0.5650},
	// {"Seffel", "tcs_zombie_17", "models/zombie_plague/tcs_garras_18.mdl", 29, 50, 3520000, 302.4, 0.5625},
	// {"Forgn", "tcs_zombie_17", "models/zombie_plague/tcs_garras_18.mdl", 29, 100, 3540000, 302.7, 0.5600},
	// {"Baco", "tcs_zombie_17", "models/zombie_plague/tcs_garras_18.mdl", 29, 150, 3560000, 303.0, 0.5575},
	// {"Reptum-G", "gk_zombie_05", "models/zombie_plague/tcs_garras_18.mdl", 29, 200, 3580000, 303.3, 0.5550},
	// {"Wanshun", "gk_zombie_05", "models/zombie_plague/tcs_garras_18.mdl", 29, 250, 3600000, 303.6, 0.5525},
	// {"Cynta", "gk_zombie_05", "models/zp5/v_zombie_claw_02.mdl", 29, 300, 3620000, 303.9, 0.5500},
	// {"Urko", "gk_zombie_05", "models/zp5/v_zombie_claw_02.mdl", 29, 300, 3620000, 303.9, 0.5500},
	// {"Gerry", "gk_zombie_05", "models/zp5/v_zombie_claw_02.mdl", 30, 50, 3640000, 304.2, 0.5475},
	// {"OC-3", "gk_zombie_05", "models/zp5/v_zombie_claw_02.mdl", 30, 100, 3660000, 304.5, 0.5450},
	// {"Wald", "gk_zombie_05", "models/zp5/v_zombie_claw_02.mdl", 30, 150, 3680000, 304.8, 0.5425},
	// {"Henrik", "gk_zombie_05", "models/zp5/v_zombie_claw_02.mdl", 30, 200, 3700000, 305.1, 0.5400},
	// {"Abundie", "gk_zombie_05", "models/zp5/v_zombie_claw_02.mdl", 30, 250, 3720000, 305.4, 0.5375},
	// {"Luke", "gk_zombie_05", "models/zp5/v_zombie_claw_02.mdl", 30, 300, 3740000, 305.7, 0.5350},
	// {"Mutsio", "gk_zombie_05", "models/zp5/v_zombie_claw_02.mdl", 31, 50, 3760000, 306.0, 0.5325},
	// {"Urchat", "gk_zombie_05", "models/zp5/v_zombie_claw_02.mdl", 31, 100, 3780000, 306.3, 0.5300},
	// {"Kenai", "gk_zombie_05", "models/zp5/v_zombie_claw_02.mdl", 31, 150, 3800000, 306.6, 0.5275},
	// {"Xomat", "gk_zombie_05", "models/zp5/v_zombie_claw_08.mdl", 31, 200, 3820000, 306.9, 0.5250},
	// {"Retunciano", "gk_zombie_05", "models/zp5/v_zombie_claw_08.mdl", 31, 250, 3840000, 307.2, 0.5225},
	// {"Merrian", "gk_zombie_05", "models/zp5/v_zombie_claw_08.mdl", 31, 300, 3860000, 307.5, 0.5200},
	// {"Wirko", "gk_zombie_05", "models/zp5/v_zombie_claw_08.mdl", 32, 50, 3880000, 307.8, 0.5175},
	// {"Thiap", "gk_zombie_05", "models/zp5/v_zombie_claw_08.mdl", 32, 100, 3900000, 308.1, 0.5150},
	// {"Gamst", "gk_zombie_05", "models/zp5/v_zombie_claw_08.mdl", 32, 150, 3920000, 308.4, 0.5125},
	// {"Laru", "gk_zombie_05", "models/zp5/v_zombie_claw_08.mdl", 32, 200, 3940000, 308.7, 0.5100},
	// {"Batzabe", "gk_zombie_05", "models/zp5/v_zombie_claw_08.mdl", 32, 250, 3960000, 309.0, 0.5075},
	// {"Rilo", "gk_zombie_05", "models/zp5/v_zombie_claw_08.mdl", 32, 300, 3980000, 309.3, 0.5050},
	// {"Rogash", "gk_zombie_05", "models/zp5/v_zombie_claw_08.mdl", 33, 50, 4000000, 309.6, 0.5025}
};

enum _:modesIds {
	MODE_NONE = 0,
	MODE_INFECTION,
	MODE_SWARM,
	MODE_MULTI,
	MODE_PLAGUE,
	MODE_SURVIVOR,
	MODE_NEMESIS,
	MODE_WESKER,
	MODE_JASON,
	MODE_ARMAGEDDON,
	MODE_MEGA_NEMESIS,
	MODE_TROLL,
	MODE_PARANOIA,
	MODE_COOP,
	MODE_ASSASSIN,
	MODE_ALVSPRED,
	MODE_BOMBER,
	MODE_DUELO_FINAL
};

new const g_MODES_NAMES[modesIds][] = {
	"", "PRIMER ZOMBIE", "SWARM", "INFECCIÓN MÚLTIPLE", "PLAGUE", "SURVIVOR", "NEMESIS", "WESKER", "JASON", "ARMAGEDDÓN", "MEGA NEMESIS", "TROLL", "PARANOIA", "COOP", "ASSASSIN", "ALIEN VS DEPREDADOR", "BOMBER", "DUELO FINAL"
};

new g_Modes_Count[modesIds];

enum _:taskIds (+= 236877) {
	TASK_MODEL = 54276,
	TASK_TEAM,
	TASK_SPAWN,
	TASK_BLOOD,
	TASK_BURN,
	TASK_MAKE_MODE,
	TASK_WELCOMEMSG,
	TASK_SAVE,
	TASK_FROZEN,
	TASK_MESSAGE_VINC,
	TASK_IMMUNITY,
	TASK_REGENERATION,
	TASK_CHECK_ACCOUNT,
	TASK_IMMUNITY_BOMBS,
	TASK_TROLL_POWER,
	TASK_PREDATOR_POWER
};

#define ID_MODEL 				(taskid - TASK_MODEL)
#define ID_TEAM 					(taskid - TASK_TEAM)
#define ID_SPAWN 				(taskid - TASK_SPAWN)
#define ID_BLOOD 				(taskid - TASK_BLOOD)
#define ID_BURN 					(taskid - TASK_BURN)
#define ID_SAVE					(taskid - TASK_SAVE)
#define ID_FROZEN				(taskid - TASK_FROZEN)
#define ID_MESSAGE_VINC			(taskid - TASK_MESSAGE_VINC)
#define ID_IMMUNITY				(taskid - TASK_IMMUNITY)
#define ID_REGENERATION			(taskid - TASK_REGENERATION)
#define ID_CHECK_ACCOUNT		(taskid - TASK_CHECK_ACCOUNT)
#define ID_IMMUNITY_BOMBS		(taskid - TASK_IMMUNITY_BOMBS)
#define ID_TROLL_POWER			(taskid - TASK_TROLL_POWER)
#define ID_PREDATOR_POWER		(taskid - TASK_PREDATOR_POWER)

enum _:structStats {
	STAT_DONE = 0,
	STAT_TAKEN
};

new Float:g_Stats_Damage[MAX_USERS][2];

enum _:statsData {
	STAT_INFECTIONS = 0, // Humanos infectados | Veces infectado siendo humano
	STAT_COMBO,
	STAT_COMBO_MAX,
	STAT_HEADSHOTS,
	STAT_ZOMBIES, // Zombies matados | Veces muerto como zombie
	STAT_HUMANS, // Humanos matados | Veces muerto como humano
	STAT_NEMESIS,
	STAT_SURVIVOR,
	STAT_WESKER,
	STAT_JASON,
	STAT_NEMESIS_COUNT,
	STAT_SURVIVOR_COUNT,
	STAT_WESKER_COUNT,
	STAT_JASON_COUNT,
	STAT_FIRST_ZOMBIE_COUNT,
	STAT_ZOMBIES_HEADSHOTS, // Zombies matados con disparos en la cabeza | Veces muerto como zombie con disparos en la cabeza
	STAT_ZOMBIES_KNIFE, // Zombies matados con cuchillo | Veces muerto como zombie con cuchillo
	STAT_ARMOR, // Chaleco quitado | Chaleco que te quitaron
	STAT_ACHIEVEMENTS,
	STAT_CHALLENGES,
	STAT_NEMESIS_LEGEND_KILLS,
	STAT_TROLL,
	STAT_TROLL_COUNT,
	STAT_MEGA_NEMESIS,
	STAT_MEGA_NEMESIS_COUNT,
	STAT_ASSASSIN,
	STAT_ASSASSIN_COUNT,
	STAT_ALIEN,
	STAT_ALIEN_COUNT,
	STAT_PREDATOR,
	STAT_PREDATOR_COUNT
};

new g_Stats[MAX_USERS][structStats][statsData];


#define DIV_DAMAGE	100.0

enum _:menusName {
	MENU_PRINCIPAL = 0,
	MENU_ARMA_PRINCIPAL,
	MENU_ARMA_SECUNDARIA,
	MENU_ARMA_TERCIARIA,
	MENU_ITEMS_EXTRAS,
	MENU_HUMAN_CLASS,
	MENU_ZOMBIE_CLASS,
	MENU_DIFFICULTS,
	MENU_HABILITIES,
	MENU_GROUP_INFO,
	MENU_GROUP_INVITE,
	MENU_CLAN_MEMBERID,
	MENU_CLAN_INVITE,
	MENU_ACHIEVEMENTS_CCLASS,
	MENU_ACHIEVEMENTS_CLASS,
	MENU_CHALLENGES,
	MENU_STATS,
	MENU_WEAPON_STATS,
	MENU_WEAPON_STATS_IN,
	MENU_WEAPON_STATS_ID,
	MENU_HATS,
	MENU_SELECT_HATS,
	MENU_COLOR,
	MENU_COLOR_ALL,
	MENU_STATS_MODES,
	MENU_STATS_ITEMS_EXTRAS,
	MENU_MASTERY
};

new g_MenuPage[MAX_USERS][menusName];

enum _:grenadesId (+= 1111) {
	NADE_TYPE_INFECTION = 1111,
	NADE_TYPE_COMBO,
	NADE_TYPE_FROST,
	NADE_TYPE_FLARE,
	NADE_TYPE_ANTIDOTO,
	NADE_TYPE_ANIQUILACION,
	NADE_TYPE_SUPERNOVA,
	NADE_TYPE_BUBBLE
};

enum _:auraStruct {
	auraOn = 0,
	auraRed,
	auraGreen,
	auraBlue,
	auraRadius
};

new g_Aura[MAX_USERS][auraStruct];

enum _:maxClassDifficults {
	DIFF_SURVIVOR = 0,
	DIFF_NEMESIS
};

enum _:structDifficults {
	diffName[16],
	diffInfo[72],
	diffHealth,
	diffSpeed,
	diffSpecial1,
	diffSpecial2
};

enum _:diffIds {
	DIFF_NORMAL = 0,
	DIFF_AVANZADO,
	DIFF_EPICO,
	DIFF_LEYENDA
};

new g_Difficults[MAX_USERS][maxClassDifficults];

new const DIFFICULTS_MENU[maxClassDifficults][diffIds][structDifficults] = {
	{ // SURVIVOR
		{"NORMAL", "Estadísticas normales", 0, 0, 1, 1},
		{"AVANZADO", "Vida: \r-25%\w", 25, 0, 0, 1},
		{"ÉPICO", "Vida: \r-50%\w | Velocidad: \r-25%\w", 50, 25, 0, 1},
		{"LEYENDA", "Vida: \r-75%\w | Velocidad: \r-50%\w | Sin inmunidad", 75, 50, 0, 0}
	}, { // NEMESIS
		{"NORMAL", "Estadísticas normales", 0, 0, 1, 1},
		{"AVANZADO", "Vida: \r-25%\w", 25, 0, 0, 1},
		{"ÉPICO", "Vida: \r-50%\w | Velocidad: \r-25%\w | Sin bazooka", 50, 25, 0, 1},
		{"LEYENDA", "Vida: \r-75%\w | Velocidad: \r-50%\w | Sin bazooka", 75, 50, 0, 1}
	}
};

enum _:logosId {
	LOGO_NONE = 0,
	LOGO_CREAR_CUENTA,
	LOGO_CREAR_PASSWORD,
	LOGO_REPETIR_PASSWORD,
	LOGO_IDENTIFICAR_CUENTA,
	LOGO_IDENTIFICAR_PASSWORD
};

new const SPRITE_DIR[logosId][] = {
	"",
	"zp6/lcc", // LOGO_CREAR_CUENTA
	"zp6/lcp", // LOGO_CREAR_PASSWORD
	"zp6/lrp2", // LOGO_REPETIR_PASSWORD
	"zp6/lic2", // LOGO_IDENTIFICAR_CUENTA
	"zp6/lip2" // LOGO_IDENTIFICAR_PASSWORD
};

new g_Account_Logo[MAX_USERS];

enum _:structThreadQueryId {
	CHECK_PJ_NAME = 0,
	CHECK_ACCOUNT_NAME,
	CHECK_ACCOUNT_NAME_02
};

enum _:structClanMemberInfo {
	memberId = 0,
	memberPj,
	memberRange,
	memberRank,
	memberReset,
	memberLevel,
	memberTulio,
	memberTimePlayed[32],
	memberLastTimeD,
	memberLastTimeH,
	memberLastTimeM,
	memberSinceD,
	memberSinceH,
	memberSinceM
};

new g_ClanMemberInfo[MAX_USERS][16][structClanMemberInfo];

enum _:structClanInfo {
	clanVictory = 0,
	clanVictoryConsec,
	clanVictoryConsecHistory,
	clanChampion
};

new g_ClanInfo[MAX_USERS][structClanInfo];

enum _:structTime {
	TIME_SEC = 0,
	TIME_HOUR,
	TIME_DAY
};

new g_PlayedTime[MAX_USERS][structTime];

enum _:weaponSkillsIds {
	SKILL_POINTS = 0,
	SKILL_DAMAGE,
	SKILL_SPEED,
	SKILL_RECOIL,
	SKILL_MAXCLIP
};

new g_WeaponSkill[MAX_USERS][31][weaponSkillsIds];

enum _:structWeapon {
	weaponLevel,
	weaponKills,
	Float:weaponDamage,
	weaponTimePlayed,
	weaponTimeDays,
	weaponTimeHours,
	weaponTimeMinutes
};

new g_WeaponData[MAX_USERS][31][structWeapon];

new Ham:Ham_Player_ResetMaxSpeed = Ham_Item_PreFrame;

new HamHook:g_HamTouch_Wall;
new HamHook:g_HamTouch_Breakeable;
new HamHook:g_HamTouch_Worldspawn;
new g_Fw_CmdStart;

const PDATA_SAFE = 2;
const OFFSET_LINUX_WEAPONS = 4;
const OFFSET_LINUX = 5;
const OFFSET_LEAP = 8;
const OFFSET_WEAPONOWNER = 41;
const OFFSET_ID	= 43;
const OFFSET_KNOWN = 44;
const OFFSET_NEXT_PRIMARY_ATTACK = 46;
const OFFSET_NEXT_SECONDARY_ATTACK = 47;
const OFFSET_TIME_WEAPON_IDLE = 48;
const OFFSET_PRIMARY_AMMO_TYPE = 49;
const OFFSET_CLIPAMMO = 51;
const OFFSET_IN_RELOAD = 54;
const OFFSET_IN_SPECIAL_RELOAD = 55;
const OFFSET_ACTIVITY = 73;
const OFFSET_SILENT	= 74;
const OFFSET_LAST_FIRE_TIME = 79;
const OFFSET_NEXT_ATTACK = 83;
const OFFSET_PAINSHOCK = 108;
const OFFSET_CSTEAMS = 114;
const OFFSET_JOINSTATE = 121;
const OFFSET_CSMENUCODE = 205;
const OFFSET_FLASHLIGHT_BATTERY = 244;
const OFFSET_BUTTON_PRESSED = 246;
const OFFSET_LONG_JUMP = 356;
const OFFSET_ACTIVE_ITEM = 373;
const OFFSET_AMMO_PLAYER_SLOT0 = 376;
const OFFSET_AWM_AMMO = 377;
const OFFSET_SCOUT_AMMO = 378;
const OFFSET_PARA_AMMO = 379;
const OFFSET_FAMAS_AMMO = 380;
const OFFSET_M3_AMMO = 381;
const OFFSET_USP_AMMO = 382;
const OFFSET_FIVESEVEN_AMMO = 383;
const OFFSET_DEAGLE_AMMO = 384;
const OFFSET_P228_AMMO = 385;
const OFFSET_GLOCK_AMMO = 386;
const OFFSET_FLASH_AMMO = 387;
const OFFSET_HE_AMMO = 388;
const OFFSET_SMOKE_AMMO = 389;
const OFFSET_C4_AMMO = 390;
const OFFSET_CSDEATHS = 444;

const PRIMARY_WEAPONS_BIT_SUM = (1 << CSW_SCOUT)|(1 << CSW_XM1014)|(1 << CSW_MAC10)|(1 << CSW_AUG)|(1 << CSW_UMP45)|(1 << CSW_SG550)|(1 << CSW_GALIL)|(1 << CSW_FAMAS)|
(1 << CSW_AWP)|(1 << CSW_MP5NAVY)|(1 << CSW_M249)|(1 << CSW_M3)|(1 << CSW_M4A1)|(1 << CSW_TMP)|(1 << CSW_G3SG1)|(1 << CSW_SG552)|(1 << CSW_AK47)|(1 << CSW_P90);

const SECONDARY_WEAPONS_BIT_SUM = (1 << CSW_P228)|(1 << CSW_ELITE)|(1 << CSW_FIVESEVEN)|(1 << CSW_USP)|(1 << CSW_GLOCK18)|(1 << CSW_DEAGLE);
const ZOMBIE_ALLOWED_WEAPONS_BIT_SUM = (1<<CSW_KNIFE)|(1<<CSW_HEGRENADE)|(1<<CSW_FLASHBANG)|(1<<CSW_SMOKEGRENADE)|(1<<CSW_C4)|(1<<CSW_AK47);
const WEAPONS_SILENT_BIT_SUM = (1 << CSW_USP)|(1 << CSW_M4A1);

const KEYSMENU = MENU_KEY_1|MENU_KEY_2|MENU_KEY_3|MENU_KEY_4|MENU_KEY_5|MENU_KEY_6|MENU_KEY_7|MENU_KEY_8|MENU_KEY_9|MENU_KEY_0;

enum _:Teams {
	FM_CS_TEAM_UNASSIGNED = 0,
	FM_CS_TEAM_T,
	FM_CS_TEAM_CT,
	FM_CS_TEAM_SPECTATOR
};

new const CS_TEAM_NAMES[][] = { "UNASSIGNED", "TERRORIST", "CT", "SPECTATOR" };

const HIDE_HUDS = (1<<5)|(1<<3);
const HIDE_HUDS_FULL = (1<<6)|(1<<5)|(1<<3)|(1<<0);
const UNIT_SECOND = (1<<12);
const DMG_HEGRENADE = (1<<24);
const IMPULSE_FLASHLIGHT = 100;
const IMPULSE_SPRAY = 201;
const USE_USING = 2;
const USE_STOPPED = 0;
const STEPTIME_SILENT = 999;
const BREAK_GLASS = 0x01;
const FFADE_IN = 0x0000;
const FFADE_OUT = 0x0001;
const FFADE_STAYOUT = 0x0004;
const Float:NADE_EXPLOSION_RADIUS = 240.0;

const EV_ID_SPEC = EV_INT_iuser2;
const EV_ENT_FLARE = EV_ENT_euser3;
const EV_NADE_TYPE = EV_INT_flTimeStepSound;
const EV_FLARE_COLOR = EV_VEC_punchangle;
const EV_FLARE_DURATION = EV_INT_flSwimTime;

new const CLASSNAME_THINK_GENERAL[] = "think_General";

new const MAX_BPAMMO[] = {-1, 52, -1, 90, 1, 32, 1, 100, 90, 1, 120, 100, 100, 90, 90, 90, 100, 120, 30, 120, 200, 32, 90, 120, 90, 2, 35, 90, 90, -1, 100};
// new const MAX_CLIP[] = {-1, 13, -1, 10, -1, 7, -1, 30, 30, -1, 30, 20, 25, 30, 35, 25, 12, 20, 10, 30, 100, 8, 30, 30, 20, -1, 7, 30, 30, -1, 50};

new const Float:DEFAULT_DELAY[] = {0.00, 2.70, 0.00, 2.00, 0.00, 0.55, 0.00, 3.15, 3.30, 0.00, 4.50, 2.70, 3.50, 3.35, 2.45, 3.30, 2.70, 2.20, 2.50, 2.63, 4.70, 0.55, 3.05, 2.12, 3.50, 0.00, 2.20, 3.00, 2.45, 0.00, 3.40};
new const DEFAULT_MAX_CLIP[] = {-1, 13, -1, 10, 1, 7, 1, 30, 30, 1, 30, 20, 25, 30, 35, 25, 12, 20, 10, 30, 100, 8, 30, 30, 20, 2, 7, 30, 30, -1, 50};
new const DEFAULT_ANIMS[] = {-1, 5, -1, 3, -1, 6, -1, 1, 1, -1, 14, 4, 2, 3, 1, 1, 13, 7, 4, 1, 3, 6, 11, 1, 3, -1, 4, 1, 1, -1, 1};

// new const AMMO_OFFSET[] = {-1, OFFSET_P228_AMMO, -1, OFFSET_SCOUT_AMMO, OFFSET_HE_AMMO, OFFSET_M3_AMMO, OFFSET_C4_AMMO, OFFSET_USP_AMMO, OFFSET_FAMAS_AMMO, OFFSET_SMOKE_AMMO, OFFSET_GLOCK_AMMO, OFFSET_FIVESEVEN_AMMO, OFFSET_USP_AMMO, OFFSET_FAMAS_AMMO,
// OFFSET_FAMAS_AMMO, OFFSET_FAMAS_AMMO, OFFSET_USP_AMMO, OFFSET_GLOCK_AMMO, OFFSET_AWM_AMMO, OFFSET_GLOCK_AMMO, OFFSET_PARA_AMMO, OFFSET_M3_AMMO, OFFSET_FAMAS_AMMO, OFFSET_GLOCK_AMMO, OFFSET_SCOUT_AMMO, OFFSET_FLASH_AMMO, OFFSET_DEAGLE_AMMO, OFFSET_FAMAS_AMMO,
// OFFSET_SCOUT_AMMO, -1, OFFSET_FIVESEVEN_AMMO};

new const WEAPON_NAMES[][] = {"", "P228 Compact", "", "Schmidt Scout", "", "XM1014 M4", "", "Ingram MAC-10", "Steyr AUG A1", "", "Dual Elite Berettas", "FiveseveN", "UMP 45", "SG-550 Auto-Sniper", "IMI Galil", "Famas", "USP .45 ACP Tactical", "Glock 18C",
"AWP Magnum Sniper", "MP5 Navy", "M249 Para Machinegun", "M3 Super 90", "M4A1 Carbine", "Schmidt TMP", "G3SG1 Auto-Sniper", "", "Desert Eagle .50 AE", "SG-552 Commando", "AK-47 Kalashnikov", "Cuchillo", "ES P90"};

new const AMMO_TYPE[][] = {"", "357sig", "", "762nato", "", "buckshot", "", "45acp", "556nato", "", "9mm", "57mm", "45acp", "556nato", "556nato",
"556nato", "45acp", "9mm", "338magnum", "9mm", "556natobox", "buckshot", "556nato", "9mm", "762nato", "", "50ae", "556nato", "762nato", "", "57mm"};

new const g_CLASSNAME_BAZOOKA[] = "bazookaNemesis";

new const AMMO_WEAPON[] = {0, CSW_AWP, CSW_SCOUT, CSW_M249, CSW_AUG, CSW_XM1014, CSW_MAC10, CSW_FIVESEVEN, CSW_DEAGLE, CSW_P228, CSW_ELITE, CSW_FLASHBANG, CSW_HEGRENADE, CSW_SMOKEGRENADE, CSW_C4};

enum _:structDataWeapon {
	weaponDataName[32],
	weaponDataId
};

new const WEAPON_DATA[21][structDataWeapon] = {
	{"P228 Compact", CSW_P228},
	{"XM1014 M4", CSW_XM1014},
	{"Ingram MAC-10", CSW_MAC10},
	{"Steyr AUG A1", CSW_AUG},
	{"Dual Elite Berettas", CSW_ELITE},
	{"FiveseveN", CSW_FIVESEVEN},
	{"UMP 45", CSW_UMP45},
	{"IMI Galil", CSW_GALIL},
	{"Famas", CSW_FAMAS},
	{"USP .45 ACP Tactical", CSW_USP},
	{"Glock 18C", CSW_GLOCK18},
	{"MP5 Navy", CSW_MP5NAVY},
	{"M249 Para Machinegun", CSW_M249},
	{"M3 Super 90", CSW_M3},
	{"M4A1 Carbine", CSW_M4A1},
	{"Schmidt TMP", CSW_TMP},
	{"Desert Eagle .50 AE", CSW_DEAGLE},
	{"SG-552 Commando", CSW_SG552},
	{"AK-47 Kalashnikov", CSW_AK47},
	{"ES P90", CSW_P90},
	{"Cuchillo", CSW_KNIFE}
};

new const WEAPON_ENT_NAMES[][] = {"", "weapon_p228", "", "weapon_scout", "weapon_hegrenade", "weapon_xm1014", "weapon_c4", "weapon_mac10", "weapon_aug", "weapon_smokegrenade", "weapon_elite", "weapon_fiveseven", "weapon_ump45", "weapon_sg550", "weapon_galil",
"weapon_famas", "weapon_usp", "weapon_glock18", "weapon_awp", "weapon_mp5navy", "weapon_m249", "weapon_m3", "weapon_m4a1", "weapon_tmp", "weapon_g3sg1", "weapon_flashbang", "weapon_deagle", "weapon_sg552", "weapon_ak47", "weapon_knife", "weapon_p90"};

new const ZP_PREFIX[] = "!g[ZP]!y ";

#define is_user_valid_connected(%1) 	(1 <= %1 <= g_MaxUsers && g_IsConnected[%1])
#define is_user_valid_alive(%1) 		(1 <= %1 <= g_MaxUsers && g_IsAlive[%1])
#define is_user_valid(%1) 			(1 <= %1 <= g_MaxUsers)

public plugin_natives() {
	register_native("zpAllowChangeName", "native__AllowChangeName", 1);
	register_native("zpIsSpecialMode", "native__IsSpecialMode", 1);
}

public native__AllowChangeName(const id) {
	if(g_AllowChangeName[id] || g_AllowChangeName_SPECIAL[id]) {
		return 1;
	}
	
	return 0;
}

public native__IsSpecialMode(const id) {
	if(g_SpecialMode[id]) {
		return 1;
	}
	
	return 0;
}

public plugin_precache() {
	precache_model("models/rpgrocket.mdl");
	
	register_plugin("ZOMBIE PLAGUE", PLUGIN_VERSION, "KISKE");
	
	new i;
	new sFile[64];
	new iEnt;
	new j;
	
	g_fwSpawn = register_forward(FM_Spawn, "fw_Spawn");
	g_fwPrecacheSound = register_forward(FM_PrecacheSound, "fw_PrecacheSound");
	
	iEnt = create_entity("hostage_entity");
	
	if(is_valid_ent(iEnt)) {
		entity_set_origin(iEnt, Float:{8192.0, 8192.0, 8192.0});
		dllfunc(DLLFunc_Spawn, iEnt);
	}
	
	// MODELOS
	
	formatex(sFile, 63, "models/player/%s/%s.mdl", g_MODEL_Nemesis, g_MODEL_Nemesis);
	precache_model(sFile);
	
	formatex(sFile, 63, "models/player/%s/%sT.mdl", g_MODEL_Nemesis, g_MODEL_Nemesis);
	precache_model(sFile);
	
	formatex(sFile, 63, "models/player/%s/%s.mdl", g_MODEL_Survivor, g_MODEL_Survivor);
	precache_model(sFile);
	
	formatex(sFile, 63, "models/player/%s/%s.mdl", g_MODEL_Wesker, g_MODEL_Wesker);
	precache_model(sFile);
	
	formatex(sFile, 63, "models/player/%s/%s.mdl", g_MODEL_Jason, g_MODEL_Jason);
	precache_model(sFile);
	
	formatex(sFile, 63, "models/player/%s/%s.mdl", g_MODEL_Troll, g_MODEL_Troll);
	precache_model(sFile);
	
	formatex(sFile, 63, "models/player/%s/%sT.mdl", g_MODEL_Troll, g_MODEL_Troll);
	precache_model(sFile);
	
	precache_model(g_MODEL_Nemesis_Knife);
	precache_model(g_MODEL_Bubble);
	precache_model(g_MODEL_Combo_View);
	precache_model(g_MODEL_Combo_World);
	precache_model(g_MODEL_Frost);
	precache_model(g_MODEL_Flare);
	precache_model(g_MODEL_Bubble_View);
	precache_model(g_MODEL_Bubble_World);
	precache_model(g_MODEL_Infection);
	precache_model(g_MODEL_Supernova_View);
	precache_model(g_MODEL_Supernova_World);
	precache_model(g_MODEL_Box);
	precache_model(g_MODEL_Chainsaw[0]);
	precache_model(g_MODEL_Chainsaw[1]);
	precache_model(g_MODEL_Rocket);
	precache_model(g_MODEL_Troll_Knife);
	precache_model(g_MODEL_Alien_Knife);
	precache_model(g_MODEL_Bazooka_View);
	precache_model(g_MODEL_Bazooka_Player);
	
	new sLastModel[48];
	sLastModel[0] = EOS;
	
	for(i = 0; i < sizeof(CLASES_HUMANAS); ++i) {
		if(equal(sLastModel, CLASES_HUMANAS[i][humanModel])) { // Para que no precachee el mismo modelo veinte veces!
			continue;
		}
		
		copy(sLastModel, 47, CLASES_HUMANAS[i][humanModel]);
		
		formatex(sFile, 63, "models/player/%s/%s.mdl", CLASES_HUMANAS[i][humanModel], CLASES_HUMANAS[i][humanModel]);
		
		precache_model(sFile);
	}
	
	for(i = 0; i < sizeof(CLASES_ZOMBIE); ++i) {
		if(equal(sLastModel, CLASES_ZOMBIE[i][zombieModel])) { // Para que no precachee el mismo modelo veinte veces!
			continue;
		}
		
		copy(sLastModel, 47, CLASES_ZOMBIE[i][zombieModel]);
		
		formatex(sFile, 63, "models/player/%s/%s.mdl", CLASES_ZOMBIE[i][zombieModel], CLASES_ZOMBIE[i][zombieModel]);
		
		precache_model(sFile);
	}
	
	for(i = 0; i < sizeof(CLASES_ZOMBIE); ++i) {
		if(equal(sLastModel, CLASES_ZOMBIE[i][zombieClawModel])) { // Para que no precachee el mismo modelo veinte veces!
			continue;
		}
		
		copy(sLastModel, 47, CLASES_ZOMBIE[i][zombieClawModel]);
		
		precache_model(CLASES_ZOMBIE[i][zombieClawModel]);
	}
	
	for(i = 0; i < sizeof(MODELS_ZOMBIE_CLAWS); ++i) {
		precache_model(MODELS_ZOMBIE_CLAWS[i]);
	}
	
	for(i = 1; i < hatIds; ++i) {
		precache_model(__HATS[i][hatModel]);
	}
	
	for(i = 0; i < 31; ++i) {
		for(j = 0; j < 8; ++j) {
			if(g_WEAPONS_Models[i][j][weaponModelPath]) {
				precache_model(g_WEAPONS_Models[i][j][weaponModelPath]);
				
				continue;
			}
			
			break;
		}
	}
	
	
	// SONIDOS
	
	precache_sound(g_SOUND_ButtonOk);
	precache_sound(g_SOUND_ButtonBad);
	precache_sound(g_SOUND_BubbleOn);
	precache_sound(g_SOUND_Antidote);
	precache_sound(g_SOUND_Grenade_Infection);
	precache_sound(g_SOUND_Grenade_Explosion);
	precache_sound(g_SOUND_Grenade_Frost);
	precache_sound(g_SOUND_Grenade_Frost_Break);
	precache_sound(g_SOUND_Grenade_Frost_Player);
	precache_sound("zp6/strider_hit1.wav");
	precache_sound("zp6/strider_hit2.wav");
	precache_sound("zp6/strider_hitwall.wav");
	precache_sound("zp6/strider_slash1.wav");
	precache_sound("zp6/strider_slash2.wav");
	precache_sound("zp6/strider_stab.wav");
	precache_sound("hero/box_hand_hit_01.wav");
	precache_sound("hero/box_hand_hit_02.wav");
	precache_sound("hero/box_hand_hit_03.wav");
	precache_sound("hero/box_hand_wall_00.wav");
	precache_sound("hero/box_hand_wall_01.wav");
	precache_sound("hero/box_hand_slash.wav");
	precache_sound("zp6/gk_sword_deploy.wav");
	precache_sound("zp6/gk_sword_hit.wav");
	precache_sound("zp6/gk_sword_hitwall.wav");
	precache_sound("zp6/gk_sword_slash.wav");
	precache_sound("zp6/gk_sword_stab.wav");
	precache_sound("zp6/gk_axe_hit1.wav");
	precache_sound("zp6/gk_axe_hitwall.wav");
	precache_sound("zp6/gk_axe_slash.wav");
	precache_sound("zp6/gk_mode_03.wav");
	precache_sound(g_SOUND_Power_Start);
	precache_sound(g_SOUND_Power_Finish);
	precache_sound("zombie_plague/tcs_cs_deploy.wav");
	precache_sound("zombie_plague/tcs_cs_hit1.wav");
	precache_sound("zombie_plague/tcs_cs_hit2.wav");
	precache_sound("zombie_plague/tcs_cs_hitwall.wav");
	precache_sound("zombie_plague/tcs_cs_miss.wav");
	precache_sound("zombie_plague/tcs_cs_stab.wav");
	precache_sound(g_SOUND_Bazooka[0]);
	precache_sound(g_SOUND_Bazooka[1]);
	precache_sound(g_SOUND_Electro);
	precache_sound(g_SOUND_Level_Up);
	precache_sound(g_SOUND_Grenade_Flare);
	precache_sound(g_SOUND_Mode_Assassin);
	precache_sound(g_SOUND_Grenade_Pipe); // COMPLETAR - Crear PIPE
	precache_sound(g_SOUND_Mode_DuelFinal);
	precache_sound(g_SOUND_Zombie_Madness);
	precache_sound("zombie_plague/tcs_claw_attack_1.wav");
	precache_sound("zombie_plague/tcs_claw_attack_2.wav");
	precache_sound("zombie_plague/tcs_claw_1.wav");
	precache_generic(g_SOUND_ArmageddonOP);
	precache_sound(g_SOUND_Armageddon);
	precache_sound(g_SOUND_SurvivorPlayer07);
	precache_sound(g_SOUND_Win_Humans);
	precache_sound(g_SOUND_Win_Zombies);
	precache_sound(g_SOUND_Win_NoOne);
	
	for(i = 0; i < sizeof(g_SOUND_Zombie_Death); ++i) {
		precache_sound(g_SOUND_Zombie_Death[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_Zombie_Infect); ++i) {
		precache_sound(g_SOUND_Zombie_Infect[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_Zombie_Pain); ++i) {
		precache_sound(g_SOUND_Zombie_Pain[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_Mode_Nemesis); ++i) {
		precache_sound(g_SOUND_Mode_Nemesis[i]);
	}
	
	for(i = 0; i < sizeof(g_SOUND_Zombie_Alert); ++i) {
		precache_sound(g_SOUND_Zombie_Alert[i]);
	}

	for(i = 0; i < sizeof(g_SOUND_Modes); ++i) {
		precache_sound(g_SOUND_Modes[i]);
	}
	
	for(i = 0; i < (sizeof(__COMBOS) - 1); ++i) {
		precache_sound(__COMBOS[i][comboSound]);
		
		if(__COMBOS[i][comboSound2][0]) {
			precache_sound(__COMBOS[i][comboSound2]);
		}
	}
	
	
	// SPRITES
	
	new const SPRITE_COLORS[][] = {"sprites/glow04.spr", "sprites/fireworks/rflare.spr", "sprites/fireworks/gflare.spr", "sprites/fireworks/bflare.spr", "sprites/fireworks/yflare.spr", "sprites/fireworks/pflare.spr", "sprites/fireworks/tflare.spr", "sprites/hotglow.spr"};
	
	g_SPRITE_Regeneration = precache_model("sprites/gk_regen.spr");
	g_SPRITE_Trail = precache_model("sprites/laserbeam.spr");
	g_SPRITE_Shockwave = precache_model("sprites/shockwave.spr");
	g_SPRITE_Glass = precache_model("models/glassgibs.mdl");
	g_SPRITE_TrailBombs = precache_model("sprites/zp6/tb.spr");
	g_SPRITE_NovaExplode = precache_model("sprites/zp6/ne.spr");
	g_SPRITE_Explosion = precache_model("sprites/fexplo.spr");
	g_SPRITE_Beam = precache_model("sprites/zbeam6.spr");
	precache_model("sprites/animglow01.spr");
	
	for(i = 0; i < 8; ++i) {
		g_SPRITE_ColorBall[i] = precache_model(SPRITE_COLORS[i]);
	}
	
	for(i = 1; i < logosId; ++i) {
		formatex(sFile, 63, "sprites/%s.txt", SPRITE_DIR[i]);
		precache_generic(sFile);
		
		formatex(sFile, 63, "sprites/%s.spr", SPRITE_DIR[i]);
		precache_model(sFile);
	}
}

public plugin_init() {
	new i;
	
	get_mapname(g_MapName, 31);
	strtolower(g_MapName);
	
	for(i = 0; i < sizeof(__MAPS); ++i) {
		if(equal(g_MapName, __MAPS[i][mapName])) {
			g_MapExtraAPs = __MAPS[i][mapMultAPs];
			g_MapExtraHealth = __MAPS[i][mapExtraHealth];
			
			break;
		}
	}
	
	set_task(0.4, "task__PluginSQL");
	
	g_CVAR_Delay = register_cvar("zp_delay", "5");
	
	register_event("HLTV", "event__HLTV", "a", "1=0", "2=0");
	register_event("30", "event__Intermission", "a");
	register_event("AmmoX", "event__AmmoX", "be");
	register_event("Health", "event__Health", "be");
	
	register_logevent("logevent__RoundEnd", 2, "1=Round_End");
	
	RegisterHam(Ham_Spawn, "player", "fw_PlayerSpawn__Post", 1);
	RegisterHam(Ham_Killed, "player", "fw_PlayerKilled");
	RegisterHam(Ham_Killed, "player", "fw_PlayerKilled__Post", 1);
	RegisterHam(Ham_TakeDamage, "player", "fw_TakeDamage");
	RegisterHam(Ham_TakeDamage, "player", "fw_TakeDamage__Post", 1);
	RegisterHam(Ham_TraceAttack, "player", "fw_TraceAttack");
	RegisterHam(Ham_Player_ResetMaxSpeed, "player", "fw_ResetMaxSpeed__Post", 1);
	RegisterHam(Ham_Use, "func_tank", "fw_UseStationary");
	RegisterHam(Ham_Use, "func_tankmortar", "fw_UseStationary");
	RegisterHam(Ham_Use, "func_tankrocket", "fw_UseStationary");
	RegisterHam(Ham_Use, "func_tanklaser", "fw_UseStationary");
	RegisterHam(Ham_Use, "func_tank", "fw_UseStationary__Post", 1);
	RegisterHam(Ham_Use, "func_tankmortar", "fw_UseStationary__Post", 1);
	RegisterHam(Ham_Use, "func_tankrocket", "fw_UseStationary__Post", 1);
	RegisterHam(Ham_Use, "func_tanklaser", "fw_UseStationary__Post", 1);
	RegisterHam(Ham_Use, "func_pushable", "fw_UsePushable");
	RegisterHam(Ham_Touch, "weaponbox", "fw_TouchWeapon");
	RegisterHam(Ham_Touch, "armoury_entity", "fw_TouchWeapon");
	RegisterHam(Ham_Touch, "weapon_shield", "fw_TouchWeapon");
	RegisterHam(Ham_Think, "grenade", "fw_ThinkGrenade");
	// RegisterHam(Ham_Player_PostThink, "player", "fw_PlayerPostThink");
	RegisterHam(Ham_Player_Jump, "player", "fw_PlayerJump");
	RegisterHam(Ham_Player_Duck, "player", "fw_PlayerDuck");
	DisableHamForward(g_HamTouch_Wall = RegisterHam(Ham_Touch, "func_wall", "fw_TouchAlien"));
	DisableHamForward(g_HamTouch_Breakeable = RegisterHam(Ham_Touch, "func_breakable", "fw_TouchAlien"));
	DisableHamForward(g_HamTouch_Worldspawn = RegisterHam(Ham_Touch, "worldspawn", "fw_TouchAlien"));
	
	RegisterHam(Ham_Weapon_WeaponIdle, "weapon_flashbang", "fw_WeaponFireRate_Fix", 0);
	RegisterHam(Ham_Weapon_WeaponIdle, "weapon_hegrenade", "fw_WeaponFireRate_Fix", 0);
	RegisterHam(Ham_Weapon_WeaponIdle, "weapon_smokegrenade", "fw_WeaponFireRate_Fix", 0);
	
	RegisterHam(Ham_Weapon_SecondaryAttack, "weapon_flashbang", "fw_WeaponFireRate_Fix", 0);
	RegisterHam(Ham_Weapon_SecondaryAttack, "weapon_hegrenade", "fw_WeaponFireRate_Fix", 0);
	RegisterHam(Ham_Weapon_SecondaryAttack, "weapon_knife", "fw_WeaponFireRate_Fix", 0);
	RegisterHam(Ham_Weapon_SecondaryAttack, "weapon_m4a1", "fw_WeaponFireRate_Fix", 0);
	RegisterHam(Ham_Weapon_SecondaryAttack, "weapon_smokegrenade", "fw_WeaponFireRate_Fix", 0);
	RegisterHam(Ham_Weapon_SecondaryAttack, "weapon_usp", "fw_WeaponFireRate_Fix", 0);
	
	RegisterHam(Ham_Weapon_Reload, "weapon_m3", "fw_WeaponFireRate_Fix", 0);
	RegisterHam(Ham_Weapon_Reload, "weapon_xm1014", "fw_WeaponFireRate_Fix", 0);
	
	for(i = 1; i < 31; ++i) {
		if(WEAPON_ENT_NAMES[i][0]) {
			if(i != CSW_HEGRENADE && i != CSW_FLASHBANG && i != CSW_SMOKEGRENADE && i != CSW_G3SG1 && i != CSW_SG550) {
				RegisterHam(Ham_Weapon_PrimaryAttack, WEAPON_ENT_NAMES[i], "fw_WeaponFireRate_Fix", 0);
				RegisterHam(Ham_Weapon_PrimaryAttack, WEAPON_ENT_NAMES[i], "fw_Weapon_PrimaryAttack__Post", 1);
				
				if(i != CSW_KNIFE) {
					RegisterHam(Ham_Item_AttachToPlayer, WEAPON_ENT_NAMES[i], "fw_Item_AttachToPlayer");
					
					if(i != CSW_M3 && i != CSW_XM1014) {
						RegisterHam(Ham_Item_PostFrame, WEAPON_ENT_NAMES[i], "fw_Item_PostFrame");
					} else {
						RegisterHam(Ham_Item_PostFrame, WEAPON_ENT_NAMES[i], "fw_Shotgun_PostFrame");
						RegisterHam(Ham_Weapon_WeaponIdle, WEAPON_ENT_NAMES[i], "fw_Shotgun_WeaponIdle");
					}
				}
			}
			
			RegisterHam(Ham_Item_Deploy, WEAPON_ENT_NAMES[i], "fw_WeaponFireRate_Fix", 0);
			RegisterHam(Ham_Item_Deploy, WEAPON_ENT_NAMES[i], "fw_Item_Deploy__Post", 1);
		}
	}
	
	register_touch("grenade", "*", "touch__GrenadeAll");
	register_touch(g_CLASSNAME_BAZOOKA, "*", "touch__BazookaAll");
	
	unregister_forward(FM_Spawn, g_fwSpawn);
	unregister_forward(FM_PrecacheSound, g_fwPrecacheSound);
	
	register_forward(FM_ClientDisconnect, "fw_ClientDisconnect__Post", 1);
	register_forward(FM_ClientKill, "fw_ClientKill");
	register_forward(FM_EmitSound, "fw_EmitSound");
	register_forward(FM_SetClientKeyValue, "fw_SetClientKeyValue");
	register_forward(FM_ClientUserInfoChanged, "fw_ClientUserInfoChanged");
	register_forward(FM_SetModel, "fw_SetModel");
	// register_forward(FM_AddToFullPack, "fw_AddToFullPack__Post", 1);
	// register_forward(FM_GameShutdown, "fw_GameShutdown");
	
	g_Message_ScoreInfo = get_user_msgid("ScoreInfo");
	g_Message_TeamInfo = get_user_msgid("TeamInfo");
	g_Message_DeathMsg = get_user_msgid("DeathMsg");
	g_Message_ScoreAttrib = get_user_msgid("ScoreAttrib");
	g_Message_ScreenFade = get_user_msgid("ScreenFade");
	g_Message_ScreenShake = get_user_msgid("ScreenShake");
	g_Message_NVGToggle = get_user_msgid("NVGToggle");
	g_Message_Flashlight = get_user_msgid("Flashlight");
	g_Message_FlashBat = get_user_msgid("FlashBat");
	g_Message_AmmoPickup = get_user_msgid("AmmoPickup");
	g_Message_HideWeapon = get_user_msgid("HideWeapon");
	g_Message_Crosshair = get_user_msgid("Crosshair");
	g_Message_Money = get_user_msgid("Money");
	g_Message_CurWeapon = get_user_msgid("CurWeapon");
	g_Message_WeapPickup = get_user_msgid("WeapPickup");
	g_Message_TextMsg = get_user_msgid("TextMsg");
	g_Message_SendAudio = get_user_msgid("SendAudio");
	g_Message_TeamScore = get_user_msgid("TeamScore");
	g_Message_Fov = get_user_msgid("SetFOV");
	g_Message_WeaponList = get_user_msgid("WeaponList");
	g_Message_ShowMenu = get_user_msgid("ShowMenu");
	g_Message_VGUIMenu = get_user_msgid("VGUIMenu");
	g_Message_StatusIcon = get_user_msgid("StatusIcon");
	
	register_message(g_Message_Money, "message__Money");
	register_message(g_Message_CurWeapon, "message__CurWeapon");
	register_message(g_Message_FlashBat, "message__FlashBat");
	register_message(g_Message_Flashlight, "message__Flashlight");
	register_message(g_Message_NVGToggle, "message__NVGToggle");
	register_message(g_Message_WeapPickup, "message__WeapPickup");
	register_message(g_Message_AmmoPickup, "message__AmmoPickup");
	register_message(g_Message_TextMsg, "message__TextMsg");
	register_message(g_Message_SendAudio, "message__SendAudio");
	register_message(g_Message_TeamScore, "message__TeamScore");
	register_message(g_Message_TeamInfo, "message__TeamInfo");
	register_message(g_Message_StatusIcon, "message__StatusIcon");
	
	g_MaxUsers = get_maxplayers();
	
	register_impulse(100, "impulse__Flashlight");
	register_impulse(201, "impulse__Flashlight");
	
	new const BLOCK_COMMANDS[][] =	{
		"buy", "buyammo1", "buyammo2", "buyequip", "cl_autobuy", "cl_rebuy", "cl_setautobuy", "cl_setrebuy", "usp", "glock", "deagle", "p228", "elites", "fn57", "m3", "xm1014", "mp5", "tmp", "p90", "mac10", "ump45", "ak47", "galil", "famas", "sg552", "m4a1", "aug", "scout", "awp", "g3sg1",
		"sg550", "m249", "vest", "vesthelm", "flash", "hegren", "sgren", "defuser", "nvgs", "shield", "primammo", "secammo", "km45", "9x19mm", "nighthawk", "228compact", "fiveseven", "12gauge", "autoshotgun", "mp", "c90", "cv47", "defender", "clarion", "krieg552", "bullpup", "magnum",
		"d3au1", "krieg550", "smg", "coverme", "takepoint", "holdpos", "regroup", "followme", "takingfire", "go", "fallback", "sticktog", "getinpos", "stormfront", "report", "roger", "enemyspot", "needbackup", "sectorclear", "inposition", "reportingin", "getout", "negative", "enemydown", "radio1",
		"radio2", "radio3"
	};
	
	register_clcmd("CREAR_CUENTA", "clcmd__CreateAccount");
	register_clcmd("CREAR_CONTRASENIA", "clcmd__CreatePassword");
	register_clcmd("REPETIR_CONTRASENIA", "clcmd__RepeatPassword");
	register_clcmd("IDENTIFICAR_CUENTA", "clcmd__LoginAccount");
	register_clcmd("IDENTIFICAR_CONTRASENIA", "clcmd__LoginPassword");
	register_clcmd("CREAR_CLAN", "clcmd__CreateClan");
	
	register_clcmd("chooseteam", "clcmd__Changeteam");
	register_clcmd("jointeam", "clcmd__Changeteam");
	register_clcmd("nightvision", "clcmd__Nightvision");
	for(i = 0; i < sizeof(BLOCK_COMMANDS); ++i) {
		register_clcmd(BLOCK_COMMANDS[i], "menu__CSBuy");
	}
	register_clcmd("drop", "clcmd__Drop");
	
	register_clcmd("say /c", "clcmd__Camera");
	register_clcmd("say /test", "clcmd__Test");
	register_clcmd("say /invis", "clcmd__Invis");
	register_clcmd("say_team /invis", "clcmd__Invis");
	register_clcmd("say /can", "clcmd__ShowMultiplier");
	register_clcmd("say /tan", "clcmd__ShowMultiplier");
	register_clcmd("say /gan", "clcmd__ShowMultiplier");
	
	register_clcmd("say", "clcmd__Say");
	register_clcmd("say_team", "clcmd__SayTeam");
	
	register_clcmd("zp_ammos", "clcmd__Ammos");
	register_clcmd("zp_level", "clcmd__Level");
	register_clcmd("zp_reset", "clcmd__Reset");
	register_clcmd("zp_points", "clcmd__Points");
	register_clcmd("zp_achievement", "clcmd__Achievement");
	
	register_clcmd("zp_zombie", "clcmd__Mode");
	register_clcmd("zp_swarm", "clcmd__Mode");
	register_clcmd("zp_multi", "clcmd__Mode");
	register_clcmd("zp_plague", "clcmd__Mode");
	register_clcmd("zp_survivor", "clcmd__Mode");
	register_clcmd("zp_nemesis", "clcmd__Mode");
	register_clcmd("zp_wesker", "clcmd__Mode");
	register_clcmd("zp_jason", "clcmd__Mode");
	register_clcmd("zp_armageddon", "clcmd__Mode");
	register_clcmd("zp_meganemesis", "clcmd__Mode");
	register_clcmd("zp_troll", "clcmd__Mode");
	register_clcmd("zp_paranoia", "clcmd__Mode");
	register_clcmd("zp_coop", "clcmd__Mode");
	register_clcmd("zp_assassin", "clcmd__Mode");
	register_clcmd("zp_alvspred", "clcmd__Mode");
	register_clcmd("zp_bomber", "clcmd__Mode");
	register_clcmd("zp_duelo", "clcmd__Mode");
	
	register_menu("Register Login Menu", KEYSMENU, "menu__RegisterLogin");
	register_menu("Choose PJ", KEYSMENU, "menu__ChoosePJ");
	register_menu("Confirm Name", KEYSMENU, "menu__ConfirmName");
	register_menu("Game Menu", KEYSMENU, "menu__Game");
	register_menu("Buy Primary Weapons Menu", KEYSMENU, "menu__BuyPrimaryWeapons");
	register_menu("Buy Secondary Weapons Menu", KEYSMENU, "menu__BuySecondaryWeapons");
	register_menu("Buy Terciary Weapons Menu", KEYSMENU, "menu__BuyTerciaryWeapons");
	register_menu("1 Class Difficults Menu", KEYSMENU, "menu__Class_Difficults");
	register_menu("2 Human Class Menu", KEYSMENU, "menu__HumanClass");
	register_menu("3 Zombie Class Menu", KEYSMENU, "menu__ZombieClass");
	register_menu("4 Difficults Menu", KEYSMENU, "menu__Difficults");
	register_menu("1 Habilities Menu", KEYSMENU, "menu__Habilities");
	register_menu("2 Habilities Menu", KEYSMENU, "menu__Habilities_Class");
	register_menu("3 Habilities Menu", KEYSMENU, "menu__Habilities_ChooseModes");
	register_menu("4 Habilities Menu", KEYSMENU, "menu__Habilities_Modes");
	register_menu("5 Habilities Menu", KEYSMENU, "menu__Habilities_Reset");
	register_menu("1 Group Menu", KEYSMENU, "menu__Group");
	register_menu("2 Group Menu", KEYSMENU, "menu__Group_Info");
	register_menu("1 Clan Menu", KEYSMENU, "menu__Clan");
	register_menu("2 Clan Menu", KEYSMENU, "menu__Clan_MemberInfo");
	register_menu("3 Clan Menu", KEYSMENU, "menu__ClanInfo");
	register_menu("1 Achievements Menu", KEYSMENU, "menu__Achievements_Challenge");
	register_menu("2 Achievements Menu", KEYSMENU, "menu__Achievement_Desc");
	register_menu("1 Challenge Menu", KEYSMENU, "menu__Challenge_Desc");
	register_menu("1 Stats Menu", KEYSMENU, "menu__Stats");
	register_menu("2 Stats Menu", KEYSMENU, "menu__Stats_Time");
	register_menu("3 Stats Menu", KEYSMENU, "menu__Stats_WeaponIn");
	register_menu("4 Stats Menu", KEYSMENU, "menu__Stats_Modes");
	register_menu("5 Stats Menu", KEYSMENU, "menu__Stats_ItemsExtras");
	register_menu("1 Hats Menu", KEYSMENU, "menu__Hats_Info");
	register_menu("2 Hats Menu", KEYSMENU, "menu__Hats");
	register_menu("1 Color Menu", KEYSMENU, "menu__Color");
	register_menu("2 Color Menu", KEYSMENU, "menu__Choose_Color");
	register_menu("1 Mastery Menu", KEYSMENU, "menu__Mastery");
	register_menu("2 Mastery Menu", KEYSMENU, "menu__Mastery_Info");
	register_menu("Another User Menu", KEYSMENU, "menu__AnotherUser");
	register_menu("1 Rango Menu", KEYSMENU, "menu__Rango");
	
	register_menucmd(register_menuid("#Buy", 1), 511, "menu__CSBuy");
	register_menucmd(register_menuid("BuyPistol", 1), 511, "menu__CSBuy");
	register_menucmd(register_menuid("BuyShotgun", 1), 511, "menu__CSBuy");
	register_menucmd(register_menuid("BuySub", 1), 511, "menu__CSBuy");
	register_menucmd(register_menuid("BuyRifle", 1), 511, "menu__CSBuy");
	register_menucmd(register_menuid("BuyMachine", 1), 511, "menu__CSBuy");
	register_menucmd(register_menuid("BuyItem", 1), 511, "menu__CSBuy");
	register_menucmd(register_menuid("BuyEquip", 1), 511, "menu__CSBuy");
	register_menucmd(-28, 511, "menu__CSBuy");
	register_menucmd(-29, 511, "menu__CSBuy");
	register_menucmd(-30, 511, "menu__CSBuy");
	register_menucmd(-32, 511, "menu__CSBuy");
	register_menucmd(-31, 511, "menu__CSBuy");
	register_menucmd(-33, 511, "menu__CSBuy");
	register_menucmd(-34, 511, "menu__CSBuy");
	
	g_Hud_Notification = CreateHudSyncObj();
	g_Hud_General = CreateHudSyncObj();
	g_Hud_Combo = CreateHudSyncObj();
	
	new iEnt = create_entity("info_target");
	
	if(is_valid_ent(iEnt)) {
		entity_set_string(iEnt, EV_SZ_classname, CLASSNAME_THINK_GENERAL);
		entity_set_float(iEnt, EV_FL_nextthink, get_gametime() + 0.1);
		
		register_think(CLASSNAME_THINK_GENERAL, "think__General");
	}
	
	new const SPAWN_NAME_ENTS[][] = {"info_player_start", "info_player_deathmatch"};
	new Float:vecOrigin[3];
	
	for(i = 0; i < 2; ++i) {
		iEnt = -1;
		while((iEnt = engfunc(EngFunc_FindEntityByString, iEnt, "classname", SPAWN_NAME_ENTS[i])) != 0) {
			entity_get_vector(iEnt, EV_VEC_origin, vecOrigin);
			
			g_Spawns[g_SpawnCount][0] = vecOrigin[0];
			g_Spawns[g_SpawnCount][1] = vecOrigin[1];
			g_Spawns[g_SpawnCount][2] = vecOrigin[2];
			
			++g_SpawnCount;
			
			if(g_SpawnCount >= 64) {
				break;
			}
		}
		
		if(g_SpawnCount >= 64) {
			break;
		}
	}
	
	g_Lights[0] = 'a';
	
	g_LastInfectionExplosion = 0.0;
	g_InfectionExplode_Count = 0;
}

public plugin_end() {
	TrieDestroy(g_tExtra_BombaAniquilacion);
	TrieDestroy(g_tExtra_BombaAntidoto);
	TrieDestroy(g_tExtra_Inmunidad);
	TrieDestroy(g_tExtra_Antidoto);
	TrieDestroy(g_tExtra_Furia);
	TrieDestroy(g_tExtra_BombaInfeccion);
	TrieDestroy(g_tExtra_Petrificacion);
	
	TrieDestroy(g_tArmageddonCant);
	
	new Handle:sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE zp6_modes SET primer_zombie='%d', swarm='%d', infeccion_multiple='%d', plague='%d', survivor='%d', nemesis='%d', wesker='%d',\
	jason='%d', armageddon='%d', mega_nemesis='%d', troll='%d', paranoia='%d', coop='%d', assassin='%d', alien_vs_depredador='%d', bomber='%d', duelo_final='%d';", g_Modes_Count[MODE_INFECTION],
	g_Modes_Count[MODE_SWARM], g_Modes_Count[MODE_MULTI], g_Modes_Count[MODE_PLAGUE], g_Modes_Count[MODE_SURVIVOR], g_Modes_Count[MODE_NEMESIS], g_Modes_Count[MODE_WESKER],
	g_Modes_Count[MODE_JASON], g_Modes_Count[MODE_ARMAGEDDON], g_Modes_Count[MODE_MEGA_NEMESIS], g_Modes_Count[MODE_TROLL], g_Modes_Count[MODE_PARANOIA], g_Modes_Count[MODE_COOP],
	g_Modes_Count[MODE_ASSASSIN], g_Modes_Count[MODE_ALVSPRED], g_Modes_Count[MODE_BOMBER], g_Modes_Count[MODE_DUELO_FINAL]);
	
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(0, sqlQuery, 2120);
	} else {
		SQL_FreeHandle(sqlQuery);
	}
	
	SQL_FreeHandle(g_SqlConnection);
	SQL_FreeHandle(g_SqlTuple);
}

public plugin_cfg() {
	set_task(0.5, "event__HLTV");
}

public client_putinserver(id) {
	g_IsConnected[id] = 1;
	
	get_user_name(id, g_UserName[id], 31);
	get_user_authid(id, g_SteamId[id], 63);
	
	if(containi(g_UserName[id], "DROP TABLE") != -1 ||
	containi(g_UserName[id], "TRUNCATE") != -1 ||
	containi(g_UserName[id], "INSERT") != -1 ||
	containi(g_UserName[id], "UPDATE") != -1 ||
	containi(g_UserName[id], "DELETE") != -1 ||
	containi(g_UserName[id], "\\") != -1 ||
	containi(g_UserName[id], "NO HUBO APOSTADORES") != -1) {
		server_cmd("kick #%d ^"Tu nombre tiene palabras no permitidas!^"", get_user_userid(id));
		return;
	}
	
	resetVars(id, .all=1);
	
	if(equal(g_SteamId[id], "STEAM_0:0:39456011")) {
		g_Kiske[id] = 1;
	}
	
	remove_task(id + TASK_CHECK_ACCOUNT);
	
	set_task(0.2, "task__CheckAccount", id + TASK_CHECK_ACCOUNT);
	set_task(5.0, "task__ModifCommands", id);
}

public client_disconnect(id) {
	new i;
	
	remove_task(id + TASK_TEAM);
	remove_task(id + TASK_MODEL);
	remove_task(id + TASK_SPAWN);
	remove_task(id + TASK_BLOOD);
	remove_task(id + TASK_BURN);
	remove_task(id + TASK_SAVE);
	remove_task(id + TASK_FROZEN);
	remove_task(id + TASK_MESSAGE_VINC);
	remove_task(id + TASK_IMMUNITY);
	remove_task(id + TASK_REGENERATION);
	remove_task(id + TASK_CHECK_ACCOUNT);
	remove_task(id + TASK_IMMUNITY_BOMBS);
	remove_task(id + TASK_TROLL_POWER);
	remove_task(id + TASK_PREDATOR_POWER);
	
	if(is_valid_ent(g_HatEnt[id])) {
		remove_entity(g_HatEnt[id]);
	}
	
	if(g_IsAlive[id]) {
		if(!g_Zombie[id]) {
			finishComboHuman(id);
		} else {
			finishComboZombie(id);
		}
		
		checkRound(id);
	}
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(g_GroupInvitationsId[i][id]) {
			--g_GroupInvitations[i];
		}
		
		g_GroupInvitationsId[i][id] = 0;
		
		if(g_ClanInvitationsId[i][id]) {
			--g_ClanInvitations[i];
		}
		
		g_ClanInvitationsId[i][id] = 0;
	}
	
	if(g_InGroup[id]) {
		for(i = 1; i < 4; ++i) {
			if(g_GroupId[g_InGroup[id]][i] == id) {
				break;
			}
		}
		
		checkGroup(id, i, id);
	}
	
	saveInfo(id, .disconnect=1);
	
	g_IsConnected[id] = 0;
	g_IsAlive[id] = 0;
	
	new j = 0;
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(g_IsConnected[i]) {
			++j;
		}
	}
	
	if(j <= 6) {
		g_LogSay = 1;
		
		set_cvar_num("sv_voiceenable", 0);
	}
}

public event__HLTV() {
	set_task(0.1, "task__RemoveStuff");
	
	set_cvar_num("zp6_semiclip", 0);
	
	g_Mode = 0;
	
	g_Lights[0] = 'm';
	
	changeLights();
	
	g_NewRound = 1;
	g_EndRound = 0;
	
	remove_task(TASK_MAKE_MODE);
	set_task(get_pcvar_float(g_CVAR_Delay), "task__MakeMode", TASK_MAKE_MODE);
	
	g_CAN_Aps = 2.0;
	g_CAN_Points = 0;
	
	new sHour[3];
	new iHour;
	
	get_time("%H", sHour, 2); // Me parece absurdo utilizar unixtime cuando solamente me interesa la hora.
	
	iHour = str_to_num(sHour);
	
	if(iHour >= 22 || (iHour >= 0 && iHour < 6)) {
		++g_CAN_Aps;
		
		if(iHour >= 2 && iHour < 5) {
			++g_CAN_Aps;
			g_CAN_Points = 1;
			
			colorChat(0, TERRORIST, "%s!tSÚPER CIMSP AT NITE!!y Tu ganancia de ammo packs aumenta un !g+x2!y y tus puntos !g+x1!y", ZP_PREFIX);
		} else {
			colorChat(0, TERRORIST, "%s!tCIMSP AT NITE!!y Tu ganancia de ammo packs aumenta un !g+x1!y", ZP_PREFIX);
		}
	}
	
	if(!iHour) { // Si son las 00, poner que son las 24 para poder hacer las condiciones.
		iHour = 24;
	}
	
	if(iHour >= 8 && iHour < 16) {
		g_MasteryType = MASTERY_MORNING;
	} else if(iHour >= 16 && iHour < 24) {
		g_MasteryType = MASTERY_AFTERNOON;
	} else {
		g_MasteryType = MASTERY_NIGHT;
	}
	
	colorChat(0, TERRORIST, "%s!tBONUS DE APERTURA!!y Tu ganancia de ammo packs aumenta un !g+x2!y", ZP_PREFIX);
}

public logevent__RoundEnd() {
	if(g_Mode == MODE_ALVSPRED) {
		DisableHamForward(g_HamTouch_Wall);
		DisableHamForward(g_HamTouch_Breakeable);
		DisableHamForward(g_HamTouch_Worldspawn);
		
		unregister_forward(FM_CmdStart, g_Fw_CmdStart);
	}
	
	static Float:fLastEndTime;
	static Float:fCurrentTime;
	
	fCurrentTime = get_gametime();
	
	if((fCurrentTime - fLastEndTime) < 0.5) {
		return;
	}
	
	fLastEndTime = fCurrentTime;
	
	remove_task(TASK_MAKE_MODE);
	
	set_cvar_num("zp6_semiclip", 0);
	
	g_EndRound = 1;
	
	if(!getZombies()) {
		set_hudmessage(0, 0, 255, -1.0, 0.2, 0, 1.0, 7.0, 2.0, 1.0, -1);
		ShowSyncHudMsg(0, g_Hud_Notification, "=======================^n ¡ GANARON LOS HUMANOS !^n=======================");
		
		client_cmd(0, "spk ^"%s^"", g_SOUND_Win_Humans);
	} else if(!getHumans()) {
		set_hudmessage(255, 0, 0, -1.0, 0.2, 0, 1.0, 7.0, 2.0, 1.0, -1);
		ShowSyncHudMsg(0, g_Hud_Notification, "=======================^n ¡ GANARON LOS ZOMBIES !^n=======================");
		
		client_cmd(0, "spk ^"%s^"", g_SOUND_Win_Zombies);
	} else {
		set_hudmessage(0, 255, 0, -1.0, 0.2, 0, 1.0, 7.0, 2.0, 1.0, -1);
		ShowSyncHudMsg(0, g_Hud_Notification, "=================^n ¡ NO GANÓ NADIE !^n=================");
		
		client_cmd(0, "spk ^"%s^"", g_SOUND_Win_NoOne);
	}
	
	static i;
	static iUsersNum;
	
	iUsersNum = getPlaying();
	
	switch(g_Mode) {
		case MODE_NEMESIS: {
			unregister_forward(FM_UpdateClientData, g_fwUpdateClientData_Post, 1);
			
			new iEnt = find_ent_by_class(-1, g_CLASSNAME_BAZOOKA);
			while(is_valid_ent(iEnt)) {
				bazooka__RemoveRocket(iEnt);
				
				iEnt = find_ent_by_class(-1, g_CLASSNAME_BAZOOKA);
			}
		}
	}
	
	if(iUsersNum < 1) {
		return;
	}
	
	if(g_EndRound_Forced) {
		g_EndRound_Forced = 0;
		
		for(i = 1; i <= g_MaxUsers; ++i) {
			if(!g_IsAlive[i]) {
				continue;
			}
			
			if(!g_SpecialMode[i] && !g_LastZombie[i] && !g_LastHuman[i]) {
				continue;
			}
			
			if(g_SpecialMode[i]) {
				switch(g_SpecialMode[i]) {
					case MODE_SURVIVOR: {
						if(g_Survivor_KillZombies[i] >= 20) {
							switch(g_Difficults[i][DIFF_SURVIVOR]) {
								case DIFF_NORMAL: {
									setAchievement(i, SURVIVOR_PRINCIPIANTE);
								} case DIFF_AVANZADO: {
									setAchievement(i, SURVIVOR_AVANZADO);
								} case DIFF_EPICO: {
									setAchievement(i, SURVIVOR_EXPERTO);	
								} case DIFF_LEYENDA: {
									setAchievement(i, SURVIVOR_PRO);
									
									if(g_Annihilation_Bomb[i]) {
										setAchievement(i, LEYENDA_SURVIVOR);
									}
								}
							}
						}
						
						if(g_Annihilation_Bomb[i]) {
							setAchievement(i, SIN_BOMBA);
						}
						
						if(g_MaxHealth[i] == g_Health[i]) {
							setAchievement(i, DONT_TOUCH_ME);
						}
					} case MODE_WESKER: {
						if(g_Wesker_LASER[i] == 3 && iUsersNum >= 15) {
							giveHat(i, HAT_HELMET);
						}
						
						setAchievement(i, MI_DEAGLE_Y_YO);
						
						if(g_Health[i] == g_MaxHealth[i]) {
							setAchievement(i, INTACTO);
						}
					} case MODE_JASON: {
						setAchievement(i, YO_Y_MI_MOTOSIERRA);
					} case MODE_NEMESIS: {
						if(g_Nemesis_KillHumans[i] >= 20) {
							switch(g_Difficults[i][DIFF_NEMESIS]) {
								case DIFF_NORMAL: {
									setAchievement(i, NEMESIS_PRINCIPIANTE);
								} case DIFF_AVANZADO: {
									setAchievement(i, NEMESIS_AVANZADO);
								} case DIFF_EPICO: {
									setAchievement(i, NEMESIS_EXPERTO);	
								} case DIFF_LEYENDA: {
									setAchievement(i, NEMESIS_PRO);
									
									if(g_Nemesis_LongJump_Count <= 15) {
										setAchievement(i, LEYENDA_NEMESIS);
									}
								}
							}
						}
						
						if(g_Bazooka[i]) {
							setAchievement(i, CRATER_SANGRIENTO);
						}
						
						if(get_systime() <= g_ModeStart_SysTime) {
							setAchievement(i, LA_BAZOOKA_MAS_RAPIDA);
						}
					}
				}
				
				g_Points[i][(g_Zombie[i]) ? P_ZOMBIE : P_HUMAN] += g_RealMultPoints[i] + ((g_SpecialMode[i] == MODE_SURVIVOR) ? g_Difficults[i][DIFF_SURVIVOR] : (g_SpecialMode[i] == MODE_NEMESIS) ? g_Difficults[i][DIFF_NEMESIS] : 0);
				colorChat(0, (g_Zombie[i]) ? TERRORIST : CT, "%s!t%s!y ganó !t%d p%s!y por ganar el modo !t%s!y", ZP_PREFIX, g_UserName[i], g_RealMultPoints[i], (g_Zombie[i]) ? "Z" : "H", g_ClassName[i]);
			} else if(g_LastZombie[i]) {
				g_Points[i][P_ZOMBIE] += g_RealMultPoints[i];
				colorChat(0, TERRORIST, "%s!t%s!y ganó !t%d pZ!y porque el !gmodo especial!y se desconectó", ZP_PREFIX, g_UserName[i], g_RealMultPoints[i]);
			} else if(g_LastHuman[i]) {
				g_Points[i][P_HUMAN] += g_RealMultPoints[i];
				colorChat(0, CT, "%s!t%s!y ganó !t%d pH!y porque el !gmodo especial!y se desconectó", ZP_PREFIX, g_UserName[i], g_RealMultPoints[i]);
			}
			
			break;
		}
	}
	
	static iTerrors;
	static iMaxTerrors;
	static iTeam[MAX_USERS];
	
	iMaxTerrors = iUsersNum / 2;
	iTerrors = 0;
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(!g_IsConnected[i]) {
			continue;
		}
		
		// rVars
		g_Mercenario_Infects[i] = 0;
		g_Mercenario_Kills[i] = 0;
		g_Impecable[i] = 0;
		
		if(g_Mode == MODE_INFECTION) {
			if(!g_Zombie[i]) {
				++g_LaSaludEsLoPrimero[i];
				
				if(g_LaSaludEsLoPrimero[i] == 5) {
					setAchievement(i, LA_SALUD_ES_LO_PRIMERO);
				}
				
				if(get_user_armor(i) == 200) {
					setAchievement(i, AFILATE_LAS_GARRAS);
				}
			}
		}
		
		if(g_BestAPs[i] > g_BestAPs_History[i]) {
			g_BestAPs_History[i] = g_BestAPs[i];
			
			g_BestAPs[i] = 0;
		}
		
		iTeam[i] = getUserTeam(i);
		
		if(iTeam[i] == FM_CS_TEAM_SPECTATOR || iTeam[i] == FM_CS_TEAM_UNASSIGNED) {
			continue;
		}
		
		remove_task(i + TASK_TEAM);
		
		setUserTeam(i, FM_CS_TEAM_CT);
		iTeam[i] = FM_CS_TEAM_CT;
		
		if(!g_Zombie[i]) {
			finishComboHuman(i);
		} else {
			finishComboZombie(i);
		}
	}
	
	i = 0;
	
	while(iTerrors < iMaxTerrors) {
		if(++i > g_MaxUsers) {
			i = 1;
		}
		
		if(!g_IsConnected[i]) {
			continue;
		}
		
		if(iTeam[i] != FM_CS_TEAM_CT) {
			continue;
		}
		
		if(random_num(0, 1)) {
			setUserTeam(i, FM_CS_TEAM_T);
			iTeam[i] = FM_CS_TEAM_T;
			
			++iTerrors;
		}
	}
}

public event__Intermission() {
	
}

public event__AmmoX(const id) {
	if(g_Zombie[id]) {
		return;
	}
	
	static iType;
	iType = read_data(1);
	
	if(iType >= 15) { // sizeof(AMMO_WEAPON)
		return;
	}
	
	static iWeapon;
	iWeapon = AMMO_WEAPON[iType];
	
	if(MAX_BPAMMO[iWeapon] <= 2) {
		return;
	}
	
	static iAmount;
	iAmount = read_data(2);
	
	if(iAmount < MAX_BPAMMO[iWeapon]) {
		static sArgs[1];
		sArgs[0] = iWeapon;
		
		set_task(0.1, "task__RefillBPAmmo", id, sArgs, 1);
	}
}

public event__Health(const id) {
	g_Health[id] = get_user_health(id);
	
	if(g_Health[id] > 999) {
		addDot(g_Health[id], g_HealthHud[id], 10);
	} else {
		formatex(g_HealthHud[id], 10, "%d", g_Health[id]);
	}
}

public fw_Spawn(const entity) {
	if(!pev_valid(entity)) {
		return FMRES_IGNORED;
	}
	
	new const REMOVE_ENTS[][] = {
		"func_bomb_target", "info_bomb_target", "info_vip_start", "func_vip_safetyzone", "func_escapezone", "hostage_entity", "monster_scientist", "info_hostage_rescue", "func_hostage_rescue", "env_rain", "env_snow", "env_fog", "func_vehicle", "info_map_parameters", "func_buyzone", "armoury_entity",
		"game_text", "func_tank", "func_tankcontrols"
	};
	
	new i;
	new sClassName[32];
	
	entity_get_string(entity, EV_SZ_classname, sClassName, 31);
	
	for(i = 0; i < 19; ++i) {
		if(equal(sClassName, REMOVE_ENTS[i])) {
			remove_entity(entity);
			return FMRES_SUPERCEDE;
		}
	}
	
	return FMRES_IGNORED;
}

public fw_PrecacheSound(const sound[]) {
	if(equal(sound, "hostage", 7)) {
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}

public fw_PlayerSpawn__Post(const id) {
	if(!is_user_alive(id) || !getUserTeam(id)) {
		return;
	}
	
	g_IsAlive[id] = _:is_user_alive(id);
	
	remove_task(id + TASK_SPAWN);
	remove_task(id + TASK_MODEL);
	remove_task(id + TASK_BLOOD);
	remove_task(id + TASK_BURN);
	
	g_Aura[id][auraOn] = 0;
	
	randomSpawn(id);
	
	set_task(0.4, "task__HideHUDs", id + TASK_SPAWN);
	
	if(g_Mode != MODE_ARMAGEDDON) {
		set_task(2.0, "task__RespawnUserCheck", id + TASK_SPAWN);
	} else {
		user_silentkill(id);
		
		colorChat(id, TERRORIST, "%sNo podés revivir en mitad de un Armageddón", ZP_PREFIX);
		return;
	}
	
	// g_RespawnAsZombie[id] = 0;
	
	if(!g_NewRound && !g_EndRound) {
		if(g_Mode == MODE_NEMESIS || g_Mode == MODE_TROLL || g_Mode == MODE_MEGA_NEMESIS || g_Mode == MODE_ASSASSIN) {
			g_RespawnAsZombie[id] = 0;
		} else if(g_Mode == MODE_SURVIVOR || g_Mode == MODE_WESKER || g_Mode == MODE_JASON) {
			g_RespawnAsZombie[id] = 1;
		}
	}
	
	if(g_RespawnAsZombie[id] && !g_NewRound) {
		resetVars(id, .all=0);
		zombieMe(id);
		
		return;
	}
	
	g_DeadTimes[id] = 0;
	g_BestAPs[id] = 0;
	g_BuyAllFuryInSameRound[id] = 0;
	
	new sCurrentModel[32];
	new iAlreadyHasModel;
	
	resetVars(id, .all=0);
	
	g_HatDevil[id] = 0;
	
	if(!g_WeaponAutoBuy[id]) {
		set_task(0.19, "task__ClearWeapons", id + TASK_SPAWN);
	}
	
	set_task(0.2, "showMenu__BuyPrimaryWeapons", id + TASK_SPAWN);
	
	if(g_HatNext[id]) {
		setHat(id, g_HatNext[id]);
	} else if(g_HatId[id]) {
		if(is_valid_ent(g_HatEnt[id])) {
			entity_set_int(g_HatEnt[id], EV_INT_rendermode, kRenderNormal);
			entity_set_float(g_HatEnt[id], EV_FL_renderamt, 255.0);
		}
	}
	
	updateComboNeeded(id);
	
	g_RealMultPoints[id] = g_MultPoints[id] + g_CAN_Points;
	
	g_HumanClass[id] = g_HumanClassNext[id];
	
	if(g_Mode != MODE_TROLL) {
		set_user_gravity(id, Float:HUMAN_GRAVITY(id));
		g_Speed[id] = Float:HUMAN_SPEED(id);
	} else {
		set_user_gravity(id, 1.0);
		g_Speed[id] = 255.0;
	}
	
	iAlreadyHasModel = HUMAN_HEALTH(id);
	
	set_user_health(id, iAlreadyHasModel);
	set_user_armor(id, HUMAN_ARMOR(id));
	
	ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
	
	if(!g_NewRound && getUserTeam(id) != FM_CS_TEAM_CT) {
		remove_task(id + TASK_TEAM);
		
		setUserTeam(id, FM_CS_TEAM_CT);
		userTeamUpdate(id);
	}
	
	iAlreadyHasModel = 0;
	
	getUserModel(id, sCurrentModel, 31);
	
	if(equal(sCurrentModel, CLASES_HUMANAS[g_HumanClass[id]][humanModel])) {
		iAlreadyHasModel = 1;
	}
	
	if(!iAlreadyHasModel) {
		copy(g_UserModel[id], 31, CLASES_HUMANAS[g_HumanClass[id]][humanModel]);
		
		if(g_NewRound) {
			set_task((5.0 * MODELS_CHANGE_DELAY), "userModelUpdate", id + TASK_MODEL);
		} else {
			userModelUpdate(id + TASK_MODEL);
		}
	}
	
	set_user_rendering(id);
	
	turnOffFlashlight(id);
	
	new iWeaponEnt;
	iWeaponEnt = getCurrentWeaponEnt(id);
	
	if(pev_valid(iWeaponEnt)) {
		replaceWeaponModels(id, cs_get_weapon_id(iWeaponEnt));
	}
	
	checkLastZombie();
}

public fw_PlayerKilled(const victim, const killer, const shouldgib) {
	g_Aura[victim][auraOn] = 0;
	g_UnlimitedClip[victim] = 0; // Para que no devuelva error el CurWeapon
	
	if(g_Zombie[victim]) {
		remove_task(victim + TASK_BLOOD);
		remove_task(victim + TASK_BURN);
		remove_task(victim + TASK_IMMUNITY_BOMBS);
		
		if(g_SpecialMode[victim]) {
			SetHamParamInteger(3, 2);
		}
		
		++g_DeadTimes[victim];
		
		g_InfectsWithMaxHealth[victim] = 100;
		
		finishComboZombie(victim);
	} else {
		finishComboHuman(victim);
	}
	
	g_IsAlive[victim] = 0;
	g_Immunity[victim] = 0;
	g_UserSolid[victim] = 0;
	g_UserRestore[victim] = 0;
	
	set_task(0.1, "task__SpecNightvision", victim);
	
	if(g_Mode == MODE_ALVSPRED) {
		if(g_Alien[victim] || g_Predator[victim]) {
			giveReward_AlienVsPred();
		}
	}
	
	if(victim == killer || !is_user_valid_connected(killer)) {
		return;
	}
	
	static iConversion;
	static iReward;
	
	iConversion = __APS_THIS_LEVEL(killer) - __APS_THIS_LEVEL_REST1(killer);
	
	if(!g_Zombie[killer]) {
		++g_Stats[killer][STAT_DONE][STAT_ZOMBIES];
		++g_Stats[victim][STAT_TAKEN][STAT_ZOMBIES];
		
		if((g_Stats[killer][STAT_DONE][STAT_ZOMBIES] % 500) == 0) {
			switch(g_Stats[killer][STAT_DONE][STAT_ZOMBIES]) {
				case 500: {
					setAchievement(killer, ZOMBIES_x500);
				} case 1000: {
					setAchievement(killer, ZOMBIES_x1000);
				} case 2500: {
					setAchievement(killer, ZOMBIES_x2500);
				} case 5000: {
					setAchievement(killer, ZOMBIES_x5000);
				} case 10000: {
					setAchievement(killer, ZOMBIES_x10K);
				} case 25000: {
					setAchievement(killer, ZOMBIES_x25K);
				} case 50000: {
					setAchievement(killer, ZOMBIES_x50K);
				} case 100000: {
					setAchievement(killer, ZOMBIES_x100K);
				} case 500000: {
					setAchievement(killer, ZOMBIES_x500K);
				} case 1000000: {
					setAchievement(killer, ZOMBIES_x1M);
				} case 5000000: {
					setAchievement(killer, ZOMBIES_x5M);
				}
			}
		} else if(g_Stats[killer][STAT_DONE][STAT_ZOMBIES] <= 100) {
			switch(g_Stats[killer][STAT_DONE][STAT_ZOMBIES]) {
				case 1: {
					giveHat(killer, HAT_AFRO);
				} case 10: {
					giveHat(killer, HAT_AWESOME);
				} case 100: {
					setAchievement(killer, ZOMBIES_x100);
				}
			}
		}
		
		if(get_pdata_int(victim, 75) == HIT_HEAD) {
			++g_Stats[killer][STAT_DONE][STAT_ZOMBIES_HEADSHOTS];
			++g_Stats[victim][STAT_TAKEN][STAT_ZOMBIES_HEADSHOTS];
			
			if((g_Stats[killer][STAT_DONE][STAT_ZOMBIES_HEADSHOTS] % 1000) == 0) {
				switch(g_Stats[killer][STAT_DONE][STAT_ZOMBIES_HEADSHOTS]) {
					case 1000: {
						setAchievement(killer, LIDER_EN_CABEZAS);
					} case 10000: {
						setAchievement(killer, AGUJEREANDO_CABEZAS);
					} case 50000: {
						setAchievement(killer, MORTIFICANDO_ZOMBIES);
					} case 100000: {
						setAchievement(killer, CABEZAS_ZOMBIES);
					} 
				}
			}
			
			if(g_Mode == MODE_WESKER && g_SpecialMode[killer] == MODE_WESKER) {
				++g_PumHeadshot[killer];
				
				if(g_PumHeadshot[killer] == 10) {
					setAchievement(killer, PUM_HEADSHOT);
				}
			}
		}
		
		if(shouldgib == 1) { // Nos aseguramos de que no lo haya matado con una bomba como la aniquilación
			iReward = (iConversion * 2) / 100; // Ganas el 2% de tu nivel por cada zombie matado sin bomba!
			
			if(!g_SpecialMode[killer]) {
				++g_Impecable[killer];
				
				switch(g_Impecable[killer]) {
					case 10: {
						setAchievement(killer, DIEZ_A_LA_Z);
					} case 50: {
						setAchievement(killer, IMPECABLE);
					}
				}
				
				if(g_VigorChance[killer] && !g_Vigor[killer]) {
					if(random_num(1, 100) < g_VigorChance[killer]) {
						g_Vigor[killer] += 10.0;
					}
				}
				
				if(g_CurrentWeapon[killer] == CSW_KNIFE) {
					iReward = (iConversion * 5) / 100; // Ganas el 5% de tu nivel por matar con cuchillo!
					
					++g_Stats[killer][STAT_DONE][STAT_ZOMBIES_KNIFE];
					++g_Stats[victim][STAT_TAKEN][STAT_ZOMBIES_KNIFE];
					
					switch(g_Stats[killer][STAT_DONE][STAT_ZOMBIES_KNIFE]) {
						case 1: {
							setAchievement(killer, AFILANDO_MI_CUCHILLO);
						} case 30: {
							setAchievement(killer, ACUCHILLANDO);
						} case 50: {
							setAchievement(killer, ME_ENCANTAN_LAS_TRIPAS);
						} case 100: {
							setAchievement(killer, HUMMILACION);
						}  case 150: {
							setAchievement(killer, CLAVO_QUE_TE_CLAVO_LA_SOMBRILLA);
						}  case 200: {
							setAchievement(killer, ENTRA_CUCHILLO_SALEN_LAS_TRIPAS);
						}  case 250: {
							setAchievement(killer, HUMILIATION_DEFEAT);
						}  case 500: {
							giveHat(killer, HAT_ANGEL);
							setAchievement(killer, CUCHILLO_DE_COCINA);
						}  case 1000: {
							setAchievement(killer, CUCHILLO_PARA_PIZZA);
						}  case 5000: {
							setAchievement(killer, YOCUCHI);
						} 
					}
					
					g_Vigor[killer] += 10.0;
				}
				
				++g_WeaponData[killer][g_CurrentWeapon[killer]][weaponKills];
			} else {
				switch(g_SpecialMode[killer]) {
					case MODE_SURVIVOR: {
						++g_Survivor_KillZombies[killer];
					} case MODE_ALVSPRED: {
						if(g_Predator[killer]) {
							++g_AlvsPred_Kills[killer];
							
							if(g_AlvsPred_Kills[killer] == 8) {
								setAchievement(killer, SARGENTO_DEPRE);
							} else if(g_AlvsPred_Kills[killer] == 12) {
								setAchievement(killer, DEPREDADOR_007);
							}
						}
					}
				}
			}
			
			++g_Mercenario_Kills[killer];
			
			if(g_Mercenario_Kills[killer] == 10 && g_Mercenario_Infects[killer] >= 10) {
				setAchievement(killer, MERCENARIO);
			}
		}
	} else {
		iReward = (iConversion * 2) / 100; // Ganas el 2% de tu nivel por cada humano matado!
		
		++g_Stats[killer][STAT_DONE][STAT_HUMANS];
		++g_Stats[victim][STAT_TAKEN][STAT_HUMANS];
		
		if(g_Mode == MODE_SWARM) {
			++g_Swarm_HumansKills[killer];
			
			if(g_Swarm_HumansKills[killer] == 5) {
				setAchievement(killer, APLICANDO_MAFIA);
			}
		}
		
		switch(g_SpecialMode[killer]) {
			case MODE_NEMESIS: {
				++g_Nemesis_KillHumans[killer];
				
				if(g_Difficults[killer][DIFF_NEMESIS] == DIFF_LEYENDA) {
					++g_Stats[killer][STAT_DONE][STAT_NEMESIS_LEGEND_KILLS];
					
					if(g_Stats[killer][STAT_DONE][STAT_NEMESIS_LEGEND_KILLS] == 100) {
						giveHat(killer, HAT_CAPTAIN_AMERICA_SHIELD);
					}
				}
			} case MODE_ALVSPRED: {
				if(g_Alien[killer]) {
					++g_AlvsPred_Kills[killer];
					
					if(g_AlvsPred_Kills[killer] == 8) {
						setAchievement(killer, ALIEN_ENTRENADO);
					} else if(g_AlvsPred_Kills[killer] == 12) {
						setAchievement(killer, SUPER_ALIEN_86);
					}
					
					if(g_Immunity[killer]) {
						++g_Alien_WithFury_HumanKills[killer];
						
						if(g_Alien_WithFury_HumanKills[killer] == 3) {
							setAchievement(killer, FURIA);
						}
					}
				}
			}
		}
	}
	
	addAmmopacks(killer, iReward);
	
	if(g_SpecialMode[victim]) {
		static iClass;
		iClass = (!g_Zombie[killer]) ? P_HUMAN : P_ZOMBIE;
		
		switch(g_SpecialMode[victim]) {
			case MODE_NEMESIS: {
				++g_Stats[killer][STAT_DONE][STAT_NEMESIS];
				++g_Stats[victim][STAT_TAKEN][STAT_NEMESIS];
				
				++g_MiSuerteEsUnica_Kills[killer];
				
				switch(g_Stats[killer][STAT_DONE][STAT_NEMESIS]) {
					case 1: {
						if(g_Stats[killer][STAT_DONE][STAT_SURVIVOR] && g_Stats[killer][STAT_DONE][STAT_WESKER] && g_Stats[killer][STAT_DONE][STAT_JASON]) {
							giveHat(killer, HAT_JOKER);
							
							if(g_Stats[killer][STAT_DONE][STAT_TROLL] && g_Stats[killer][STAT_DONE][STAT_ASSASSIN] && g_Stats[killer][STAT_DONE][STAT_MEGA_NEMESIS]) {
								setAchievement__First(killer, PRIMERO_QUE_SUERTE);
								setAchievement(killer, QUE_SUERTE);
							}
						}
					} case 50: {
						setAchievement(killer, TENGO_BALAS_PARA_TODOS);
					} case 100: {
						setAchievement(killer, CIEN_NEMESIS);
						giveHat(killer, HAT_JACK);
					}
				}
				
				if(g_CurrentWeapon[killer] == CSW_KNIFE && !g_SpecialMode[killer]) {
					giveHat(killer, HAT_KAKASHI);
					
					setAchievement(killer, MI_CUCHILLO_ES_ROJO);
				}
				
				if(g_MiSuerteEsUnica_Kills[killer] == 5) {
					setAchievement(killer, MI_SUERTE_ES_UNICA);
				}
				
				if(g_Mode == MODE_PLAGUE) {
					if(!g_SpecialMode[killer]) {
						++g_YElSurvivor[killer];
						
						if(g_YElSurvivor[killer] == 2) {
							setAchievement(killer, Y_EL_SURVIVOR);
						}
					}
				}
			} case MODE_SURVIVOR: {
				++g_Stats[killer][STAT_DONE][STAT_SURVIVOR];
				++g_Stats[victim][STAT_TAKEN][STAT_SURVIVOR];
				
				switch(g_Stats[killer][STAT_DONE][STAT_SURVIVOR]) {
					case 1: {
						if(g_Stats[killer][STAT_DONE][STAT_NEMESIS] && g_Stats[killer][STAT_DONE][STAT_WESKER] && g_Stats[killer][STAT_DONE][STAT_JASON]) {
							giveHat(killer, HAT_JOKER);
							
							if(g_Stats[killer][STAT_DONE][STAT_TROLL] && g_Stats[killer][STAT_DONE][STAT_ASSASSIN] && g_Stats[killer][STAT_DONE][STAT_MEGA_NEMESIS]) {
								setAchievement__First(killer, PRIMERO_QUE_SUERTE);
								setAchievement(killer, QUE_SUERTE);
							}
						}
					} case 50: {
						setAchievement(killer, CAZADOR);
					} case 100: {
						setAchievement(killer, CIEN_SURVIVOR);
						giveHat(killer, HAT_JAVA);
					}
				}
				
				if(g_Mode == MODE_PLAGUE) {
					if(!g_SpecialMode[killer]) {
						++g_YElNemesis[killer];
						
						if(g_YElNemesis[killer] == 2) {
							setAchievement(killer, Y_EL_NEMESIS);
						}
					}
				} else if(g_Mode == MODE_ARMAGEDDON) {
					++g_Armageddon_SurvivorKills[killer];
					
					if(g_Armageddon_SurvivorKills[killer] == 5) {
						setAchievement(killer, ROJO_Y_VIOLENTO);
					}
				}
			} case MODE_WESKER: {
				++g_Stats[killer][STAT_DONE][STAT_WESKER];
				++g_Stats[victim][STAT_TAKEN][STAT_WESKER];
				
				switch(g_Stats[killer][STAT_DONE][STAT_WESKER]) {
					case 1: {
						if(g_Stats[killer][STAT_DONE][STAT_SURVIVOR] && g_Stats[killer][STAT_DONE][STAT_NEMESIS] && g_Stats[killer][STAT_DONE][STAT_JASON]) {
							giveHat(killer, HAT_JOKER);
							
							if(g_Stats[killer][STAT_DONE][STAT_TROLL] && g_Stats[killer][STAT_DONE][STAT_ASSASSIN] && g_Stats[killer][STAT_DONE][STAT_MEGA_NEMESIS]) {
								setAchievement__First(killer, PRIMERO_QUE_SUERTE);
								setAchievement(killer, QUE_SUERTE);
							}
						}
					} case 30: {
						setAchievement(killer, VI_MEJORES);
					}
				}
				
				if(!g_SinHacerDamage[victim]) {
					setAchievement(victim, DK_BUGUEADA);
				}
			} case MODE_JASON: {
				++g_Stats[killer][STAT_DONE][STAT_JASON];
				++g_Stats[victim][STAT_TAKEN][STAT_JASON];
				
				giveHat(killer, HAT_JASON);
				
				switch(g_Stats[killer][STAT_DONE][STAT_JASON]) {
					case 1: {
						if(g_Stats[killer][STAT_DONE][STAT_SURVIVOR] && g_Stats[killer][STAT_DONE][STAT_WESKER] && g_Stats[killer][STAT_DONE][STAT_NEMESIS]) {
							giveHat(killer, HAT_JOKER);
							
							if(g_Stats[killer][STAT_DONE][STAT_TROLL] && g_Stats[killer][STAT_DONE][STAT_ASSASSIN] && g_Stats[killer][STAT_DONE][STAT_MEGA_NEMESIS]) {
								setAchievement__First(killer, PRIMERO_QUE_SUERTE);
								setAchievement(killer, QUE_SUERTE);
							}
						}
					} case 30: {
						setAchievement(killer, JASON_LA_PELICULA);
					}
				}
				
				if(!g_SinHacerDamage[victim]) {
					setAchievement(victim, CUCHILLO_QUE_NO_CORTA);
				}
			} case MODE_TROLL: {
				++g_Stats[killer][STAT_DONE][STAT_TROLL];
				++g_Stats[victim][STAT_TAKEN][STAT_TROLL];
				
				if(g_Stats[killer][STAT_DONE][STAT_TROLL] == 1) {
					if(g_Stats[killer][STAT_DONE][STAT_SURVIVOR] && g_Stats[killer][STAT_DONE][STAT_WESKER] && g_Stats[killer][STAT_DONE][STAT_JASON] && g_Stats[killer][STAT_DONE][STAT_NEMESIS] &&
					g_Stats[killer][STAT_DONE][STAT_ASSASSIN] && g_Stats[killer][STAT_DONE][STAT_MEGA_NEMESIS]) {
						setAchievement__First(killer, PRIMERO_QUE_SUERTE);
						setAchievement(killer, QUE_SUERTE);
					}
				}
			} case MODE_ASSASSIN: {
				++g_Stats[killer][STAT_DONE][STAT_ASSASSIN];
				++g_Stats[victim][STAT_TAKEN][STAT_ASSASSIN];
				
				if(g_Stats[killer][STAT_DONE][STAT_ASSASSIN] == 1) {
					if(g_Stats[killer][STAT_DONE][STAT_SURVIVOR] && g_Stats[killer][STAT_DONE][STAT_WESKER] && g_Stats[killer][STAT_DONE][STAT_JASON] && g_Stats[killer][STAT_DONE][STAT_NEMESIS] &&
					g_Stats[killer][STAT_DONE][STAT_TROLL] && g_Stats[killer][STAT_DONE][STAT_MEGA_NEMESIS]) {
						setAchievement__First(killer, PRIMERO_QUE_SUERTE);
						setAchievement(killer, QUE_SUERTE);
					}
				}
			} case MODE_MEGA_NEMESIS: {
				++g_Stats[killer][STAT_DONE][STAT_MEGA_NEMESIS];
				++g_Stats[victim][STAT_TAKEN][STAT_MEGA_NEMESIS];
				
				if(g_Stats[killer][STAT_DONE][STAT_MEGA_NEMESIS] == 1) {
					if(g_Stats[killer][STAT_DONE][STAT_SURVIVOR] && g_Stats[killer][STAT_DONE][STAT_WESKER] && g_Stats[killer][STAT_DONE][STAT_JASON] && g_Stats[killer][STAT_DONE][STAT_NEMESIS] &&
					g_Stats[killer][STAT_DONE][STAT_TROLL] && g_Stats[killer][STAT_DONE][STAT_ASSASSIN]) {
						setAchievement__First(killer, PRIMERO_QUE_SUERTE);
						setAchievement(killer, QUE_SUERTE);
					}
				}
			} case MODE_ALVSPRED: {
				if(g_Alien[victim]) {
					++g_Stats[killer][STAT_DONE][STAT_ALIEN];
					++g_Stats[victim][STAT_TAKEN][STAT_ALIEN];
					
					if(g_Stats[killer][STAT_DONE][STAT_ALIEN] == 30) {
						setAchievement(killer, SOLO_HAY_UNA_EXPLICACION);
					}
					
					if(g_Predator[killer]) {
						setAchievement(killer, DEPREDADOR);
						
						if(task_exists(killer + TASK_PREDATOR_POWER)) {
							setAchievement(killer, MI_HABILIDAD_ES_MEJOR);
						}
					}
				} else if(g_Predator[victim]) {
					++g_Stats[killer][STAT_DONE][STAT_PREDATOR];
					++g_Stats[victim][STAT_TAKEN][STAT_PREDATOR];
					
					if(g_Alien[killer]) {
						setAchievement(killer, ALIENIGENA);
						
						if(g_MaxHealth[killer] >= ((g_MaxHealth[killer] * 80) / 100)) {
							setAchievement(killer, RAPIDO_Y_ALIENOSO);
						}
						
						if(task_exists(victim + TASK_PREDATOR_POWER)) {
							setAchievement(killer, NO_TE_VEO_PERO_TE_HUELO);
						}
						
						if(g_Immunity[killer]) {
							setAchievement(killer, ESTOY_RE_LOCO);
						}
					}
				}
			}
		}
		
		g_Points[killer][iClass] += g_RealMultPoints[killer];
		colorChat(0, (g_Zombie[killer]) ? TERRORIST : CT, "%s!t%s!y ganó !t%d p%s!y por matar a un !g%s!y", ZP_PREFIX, g_UserName[killer], g_RealMultPoints[killer], (iClass == P_HUMAN) ? "H" : "Z", g_ClassName[victim]);
	}
	
	if(g_Mode != MODE_ARMAGEDDON && g_Mode != MODE_PLAGUE && g_Mode != MODE_ALVSPRED && g_SpecialMode[killer] && (g_LastHuman[victim] || g_LastZombie[victim])) {
		static iUsersNum;
		static iClass;
		
		iUsersNum = getPlaying();
		iClass = 0;
		
		if(g_LastZombie[victim] && !g_Zombie[killer]) {
			iClass = P_HUMAN;
		} else if(g_LastHuman[victim] && g_Zombie[killer]) {
			iClass = P_ZOMBIE;
		}
		
		g_Points[killer][iClass] += g_RealMultPoints[killer] + ((g_SpecialMode[killer] == MODE_SURVIVOR) ? g_Difficults[killer][DIFF_SURVIVOR] :
		(g_SpecialMode[killer] == MODE_NEMESIS) ? g_Difficults[killer][DIFF_NEMESIS] : 0);
		colorChat(0, (g_Zombie[killer]) ? TERRORIST : CT, "%s!t%s!y ganó !t%d p%s!y por ganar el modo !t%s!y", ZP_PREFIX, g_UserName[killer], g_RealMultPoints[killer], (iClass == P_HUMAN) ? "H" : "Z", g_ClassName[killer]);
		
		switch(g_SpecialMode[killer]) {
			case MODE_SURVIVOR: {
				if(g_Survivor_KillZombies[killer] >= 20) {
					switch(g_Difficults[killer][DIFF_SURVIVOR]) {
						case DIFF_NORMAL: {
							setAchievement(killer, SURVIVOR_PRINCIPIANTE);
						} case DIFF_AVANZADO: {
							setAchievement(killer, SURVIVOR_AVANZADO);
						} case DIFF_EPICO: {
							setAchievement(killer, SURVIVOR_EXPERTO);	
						} case DIFF_LEYENDA: {
							setAchievement(killer, SURVIVOR_PRO);
							
							if(g_Annihilation_Bomb[killer]) {
								setAchievement(killer, LEYENDA_SURVIVOR);
							}
						}
					}
				}
				
				if(g_Annihilation_Bomb[killer]) {
					setAchievement(killer, SIN_BOMBA);
				}
				
				if(g_MaxHealth[killer] == g_Health[killer]) {
					setAchievement(killer, DONT_TOUCH_ME);
				}
			} case MODE_WESKER: {
				if(g_Wesker_LASER[killer] == 3 && iUsersNum >= 15) {
					giveHat(killer, HAT_HELMET);
				}
				
				setAchievement(killer, MI_DEAGLE_Y_YO);
				
				if(g_Health[killer] == g_MaxHealth[killer]) {
					setAchievement(killer, INTACTO);
				}
			} case MODE_JASON: {
				setAchievement(killer, YO_Y_MI_MOTOSIERRA);
			} case MODE_NEMESIS: {
				if(g_Nemesis_KillHumans[killer] >= 20) {
					switch(g_Difficults[killer][DIFF_NEMESIS]) {
						case DIFF_NORMAL: {
							setAchievement(killer, NEMESIS_PRINCIPIANTE);
						} case DIFF_AVANZADO: {
							setAchievement(killer, NEMESIS_AVANZADO);
						} case DIFF_EPICO: {
							setAchievement(killer, NEMESIS_EXPERTO);	
						} case DIFF_LEYENDA: {
							setAchievement(killer, NEMESIS_PRO);
							
							if(g_Nemesis_LongJump_Count <= 15) {
								setAchievement(killer, LEYENDA_NEMESIS);
							}
						}
					}
				}
				
				if(g_Bazooka[killer]) {
					setAchievement(killer, CRATER_SANGRIENTO);
				}
				
				if(get_systime() <= g_ModeStart_SysTime) {
					setAchievement(killer, LA_BAZOOKA_MAS_RAPIDA);
				}
			}
		}
	}
}

public fw_PlayerKilled__Post(victim, attacker, shouldgib) {
	checkLastZombie();
	
	set_task(random_float(0.7, 2.3), "task__RespawnUser", victim + TASK_SPAWN);
}

public fw_TakeDamage(const victim, const inflictor, const attacker, Float:damage, const damage_type) {
	if(damage_type & DMG_FALL) {
		return HAM_SUPERCEDE;
	}
	
	if(victim == attacker || !is_user_valid_connected(attacker)) {
		return HAM_IGNORED;
	}
	
	if(g_NewRound ||
	g_EndRound ||
	g_Zombie[attacker] == g_Zombie[victim] ||
	(g_FirstInfect && (g_InBubble[victim] && !g_Immunity[attacker]) && (g_InBubble[victim] && g_Zombie[attacker] && !g_SpecialMode[attacker])) ||
	g_Immunity[victim]) {
		return HAM_SUPERCEDE;
	}
	
	static iDamage;
	static iPercent;
	
	iPercent = 0;
	
	if(!g_Zombie[attacker]) {
		static iData;
		iData = 1;
		
		if(get_pdata_int(victim, 75) == HIT_HEAD) {
			++g_Stats[attacker][STAT_DONE][STAT_HEADSHOTS];
			++g_Stats[victim][STAT_TAKEN][STAT_HEADSHOTS];
		}
		
		switch(g_SpecialMode[attacker]) {
			case MODE_WESKER: {
				g_SinHacerDamage[attacker] = 1;
				
				static iHealth;
				iHealth = g_Health[victim];
				
				iHealth *= 15;
				iHealth /= 100;
				
				damage = (iHealth < 200) ? 200.0 : float(iHealth);
				
				iData = 0;
			} case MODE_JASON: {
				g_SinHacerDamage[attacker] = 1;
				
				damage *= (entity_get_int(attacker, EV_INT_button) & IN_ATTACK) ? 250.0 : 200.0;
				
				iData = 0;
			}
		}
		
		if(g_SpecialMode[victim] != MODE_TROLL) {
			// Multiplica el daño base por el del arma modificada
			damage *= ((g_PrimaryWeapon[attacker] == 1) ? ARMAS_PRIMARIAS[g_WeaponPrimaryActual[attacker]][weaponDamageMult] : (g_PrimaryWeapon[attacker] == 2) ? ARMAS_SECUNDARIAS[g_WeaponSecondaryActual[attacker]][weaponDamageMult] : 1.0);
			
			// Agrega al daño un 5% por cada nivel de DAÑO que tenga el arma y un 5% por cada nivel de DAÑO que tenga el humano más el hat puesto, más el % de daño que tenga la clase humana		
			iPercent = ((g_Hab[attacker][CLASS_HUMAN][HAB_DAMAGE] + g_WeaponSkill[attacker][g_CurrentWeapon[attacker]][SKILL_DAMAGE] + __HATS[g_HatId[attacker]][hatUpgrade4]) * 5) + CLASES_HUMANAS[g_HumanClass[attacker]][humanDamagePercent];
			damage += ((float(iPercent) * damage) / 100.0);
			
			// Agrega al daño el bonus de Vigor.
			damage += g_Vigor[attacker];
			
			if(g_Frozen[victim]) {
				if(g_Frozen[victim] == 2) {
					damage /= 2.0;
				} else {
					damage = 0.1;
				}
			}
			
			if(g_DamageReduce[victim]) {
				damage -= (damage * g_DamageReduce[victim]) / 100.0;
			}
			
			g_Stats_Damage[attacker][0] += damage / DIV_DAMAGE;
			g_Stats_Damage[victim][1] += damage / DIV_DAMAGE;
		} else {
			damage = 1.0;
		}
		
		SetHamParamFloat(4, damage);
		
		iDamage = floatround(damage);
		
		if(!g_SpecialMode[attacker]) {
			g_WeaponData[attacker][g_CurrentWeapon[attacker]][weaponDamage] += damage / DIV_DAMAGE;
			
			if(g_WeaponData[attacker][g_CurrentWeapon[attacker]][weaponDamage] >= g_WEAPONS_Damage_Needed[g_CurrentWeapon[attacker]][g_WeaponData[attacker][g_CurrentWeapon[attacker]][weaponLevel]]) {
				++g_WeaponData[attacker][g_CurrentWeapon[attacker]][weaponLevel];
				++g_WeaponSkill[attacker][g_CurrentWeapon[attacker]][SKILL_POINTS];
				
				colorChat(attacker, CT, "%sTu !t%s!y subió al !gnivel %d!y", ZP_PREFIX, WEAPON_NAMES[g_CurrentWeapon[attacker]], g_WeaponData[attacker][g_CurrentWeapon[attacker]][weaponLevel]);
				
				if(g_CurrentWeapon[attacker] == CSW_KNIFE) {
					if(g_WeaponData[attacker][g_CurrentWeapon[attacker]][weaponLevel] == 7) {
						giveHat(attacker, HAT_SPARTAN);
					} else if(g_WeaponData[attacker][g_CurrentWeapon[attacker]][weaponLevel] == 15) {
						giveHat(attacker, HAT_SPARTAN_RELOADED);
					}
				}
				
				new i;
				new j;
				
				if((g_WeaponData[attacker][g_CurrentWeapon[attacker]][weaponLevel] % 5) == 0) {
					checkAchievements_Weapons(attacker);
				}
				
				j = 0;
				while(!j) { // infinito hasta que llegue al break
					for(i = 0; i < 8; ++i) {
						if(g_WeaponData[attacker][g_CurrentWeapon[attacker]][weaponLevel] >= g_WEAPONS_Models[g_CurrentWeapon[attacker]][i][weaponModelLevel]) {
							g_WeaponModel[attacker][g_CurrentWeapon[attacker]] = i+1;
							
							continue;
						}
						
						break;
					}
					
					break;
				}
			}
		}
		
		g_AmmosDamage[attacker] += iDamage;
		
		while(g_AmmosDamage[attacker] >= 500) {
			addAmmopacks(attacker, 1);
			g_AmmosDamage[attacker] -= 500;
			
			++g_BestAPs[attacker];
		}
		
		if(iData) {
			g_ComboDamage[attacker] += iDamage;
			
			g_Combo[attacker] = (g_ComboDamage[attacker] / g_ComboNeedDamage[attacker]);
			
			showCurrentComboHuman(attacker, iDamage);
		}
		
		entity_get_vector(victim, EV_VEC_velocity, g_KnockbackVelocity[victim]);
		
		return HAM_IGNORED;
	}
	
	if(damage_type & DMG_HEGRENADE) {
		return HAM_SUPERCEDE;
	}
	
	if(g_CurrentWeapon[attacker] == CSW_KNIFE) {
		if(entity_get_int(attacker, EV_INT_bInDuck) || entity_get_int(attacker, EV_INT_flags) & FL_DUCKING) {
			static Float:vecAttackerOrigin[3];
			static Float:vecVictimOrigin[3];
			static Float:flDistance;
			
			entity_get_vector(attacker, EV_VEC_origin, vecAttackerOrigin);
			entity_get_vector(victim, EV_VEC_origin, vecVictimOrigin);
			
			flDistance = vector_distance(vecAttackerOrigin, vecVictimOrigin);
			
			if(flDistance < 0.0) {
				flDistance *= -1.0;
			}
			
			if(flDistance >= 55.0) {
				return HAM_SUPERCEDE;
			}
		}
		
		iPercent = (g_Hab[attacker][CLASS_ZOMBIE][HAB_DAMAGE] + __HATS[g_HatId[attacker]][hatUpgrade8]) * 5;
		
		damage += ((float(iPercent) * damage) / 100.0);
		
		iDamage = floatround(damage);
		
		switch(g_SpecialMode[attacker]) {
			case MODE_NEMESIS: {
				iDamage += (entity_get_int(attacker, EV_INT_button) & IN_ATTACK) ? 100 : 325;
				
				if(g_Hab[attacker][CLASS_NEMESIS][HAB_N_DAMAGE]) {
					iDamage += (g_Hab[attacker][CLASS_NEMESIS][HAB_N_DAMAGE] * __HABILITIES[CLASS_NEMESIS][HAB_N_DAMAGE][habValue]);
				}
				
				SetHamParamFloat(4, float(iDamage));
				
				return HAM_IGNORED;
			} case MODE_TROLL: {
				if(entity_get_int(attacker, EV_INT_button) & IN_ATTACK) {
					SetHamParamFloat(4, 200.0);
				} else {
					ExecuteHamB(Ham_Killed, victim, attacker, 2);
				}
				
				return HAM_IGNORED;
			}
		}
		
		static iArmor;
		iArmor = get_user_armor(victim);
		
		if(iArmor > 0 && !g_FirstZombie[attacker]) {
			static iRealDamage;
			iRealDamage = (iArmor - iDamage);
			
			g_Stats[attacker][STAT_DONE][STAT_ARMOR] += iDamage;
			g_Stats[victim][STAT_TAKEN][STAT_ARMOR] += iDamage;
			
			if(g_Stats[attacker][STAT_DONE][STAT_ARMOR] < 1200 && g_Stats[attacker][STAT_DONE][STAT_ARMOR] >= 1000) {
				giveHat(attacker, HAT_JACKET);
			}
			
			if(iRealDamage > 0) {
				set_user_armor(victim, iRealDamage);
			} else {
				cs_set_user_armor(victim, 0, CS_ARMOR_NONE);
			}
			
			return HAM_SUPERCEDE;
		}
		
		if(g_Mode == MODE_SWARM || g_Mode == MODE_PLAGUE || g_Mode == MODE_ALVSPRED || g_SpecialMode[attacker] || getHumans() == 1) {
			SetHamParamFloat(4, damage);
			return HAM_IGNORED;
		}
		
		zombieMe(victim, attacker);
	}
	
	return HAM_SUPERCEDE;
}

public fw_TakeDamage__Post(const victim) {
	if((g_Zombie[victim] && g_LastZombie[victim]) || g_SpecialMode[victim] == MODE_SURVIVOR) {
		if(pev_valid(victim) != PDATA_SAFE) {
			return;
		}
		
		entity_set_vector(victim, EV_VEC_velocity, g_KnockbackVelocity[victim]);
		
		set_pdata_float(victim, OFFSET_PAINSHOCK, 1.0, OFFSET_LINUX);
	}
}

public fw_TraceAttack(const victim, const attacker, const Float:damage, const Float:direction[3], const tracehandle, const damage_type) {
	if(victim == attacker || !is_user_valid_connected(attacker)) {
		return HAM_IGNORED;
	}
	
	if(g_NewRound ||
	g_EndRound ||
	g_Frozen[attacker] ||
	g_Zombie[attacker] == g_Zombie[victim] ||
	(g_FirstInfect && (g_InBubble[victim] && !g_Immunity[attacker]) && (g_InBubble[victim] && g_Zombie[attacker] && !g_SpecialMode[attacker])) || 
	g_Immunity[victim]) {
		return HAM_SUPERCEDE;
	}
	
	if(g_Zombie[attacker] && g_CurrentWeapon[attacker] == CSW_KNIFE) {
		if(entity_get_int(attacker, EV_INT_bInDuck) || entity_get_int(attacker, EV_INT_flags) & FL_DUCKING) {
			static Float:vecAttackerOrigin[3];
			static Float:vecVictimOrigin[3];
			static Float:flDistance;
			
			entity_get_vector(attacker, EV_VEC_origin, vecAttackerOrigin);
			entity_get_vector(victim, EV_VEC_origin, vecVictimOrigin);
			
			flDistance = vector_distance(vecAttackerOrigin, vecVictimOrigin);
			
			if(flDistance < 0.0) {
				flDistance *= -1.0;
			}
			
			if(flDistance >= 55.0) {
				g_BlockSound[attacker] = 1;
				return HAM_SUPERCEDE;
			}
		}
	}
	
	return HAM_IGNORED;
}

public fw_ResetMaxSpeed__Post(const id) {
	if(!g_IsAlive[id]) {
		return;
	}
	
	setUserMaxspeed(id);
}

public fw_UseStationary(const entity, const caller, const activator, const use_type) {
	if(use_type == USE_USING && is_user_valid_connected(caller) && g_Zombie[caller]) {
		return HAM_SUPERCEDE;
	}
	
	return HAM_IGNORED;
}

public fw_UseStationary__Post(const entity, const caller, const activator, const use_type) {
	if(use_type == USE_STOPPED && is_user_valid_connected(caller)) {
		replaceWeaponModels(caller, g_CurrentWeapon[caller]);
	}
}

public fw_UsePushable() {
	return HAM_SUPERCEDE;
}

public fw_TouchWeapon(const weapon, const id) {
	if(!is_user_valid_connected(id)) {
		return HAM_IGNORED;
	}
	
	if(g_Zombie[id] || g_SpecialMode[id]) {
		return HAM_SUPERCEDE;
	}
	
	return HAM_IGNORED;
}

public fw_Item_Deploy__Post(const weapon_ent) {
	new id;
	id = getWeaponEntId(weapon_ent);
	
	if(!pev_valid(id)) {
		return;
	}
	
	new iWeaponId;
	iWeaponId = cs_get_weapon_id(weapon_ent);
	
	g_CurrentWeapon[id] = iWeaponId;
	
	g_PrimaryWeapon[id] = ((1 << iWeaponId) & PRIMARY_WEAPONS_BIT_SUM) ? 1 : ((1 << iWeaponId) & SECONDARY_WEAPONS_BIT_SUM) ? 2 : 0;
	
	if(g_Zombie[id] && !((1<<iWeaponId) & ZOMBIE_ALLOWED_WEAPONS_BIT_SUM)) {
		g_CurrentWeapon[id] = CSW_KNIFE;
		engclient_cmd(id, "weapon_knife");
	}
	
	if(g_LastWeapon[id] != CSW_HEGRENADE && g_LastWeapon[id] != CSW_FLASHBANG && g_LastWeapon[id] != CSW_SMOKEGRENADE && g_LastWeapon[id]) {
		g_WeaponSave[id][g_LastWeapon[id]] = 1;
		
		if(!g_WeaponData[id][g_LastWeapon[id]][weaponTimePlayed]) {
			g_WeaponData[id][g_LastWeapon[id]][weaponTimePlayed] = 1; // Si cambias muy rápido de arma no llega a sumar un segundo y volvería a ejecutarse el INSERT (al menos lo intentaría), por eso lo ponemos en 1 al principio!
			
			new Handle:sqlQuery;
			sqlQuery = SQL_PrepareQuery(g_SqlConnection, "INSERT INTO zp6_weapons (`acc_id`, `pj_id`, `weapon_id`, `weapon_name`) VALUES ('%d', '%d', '%d', ^"%s^");",
			g_AccountId[id], g_AccountPJs[id][g_UserSelected[id]], g_LastWeapon[id], WEAPON_NAMES[g_LastWeapon[id]]);
			
			if(!SQL_Execute(sqlQuery)) {
				executeQuery(id, sqlQuery, 100);
			} else {
				SQL_FreeHandle(sqlQuery);
			}
		}
		
		g_WeaponData[id][g_LastWeapon[id]][weaponTimePlayed] += (get_systime() - g_WeaponTime[id]);
	}
	
	g_WeaponTime[id] = get_systime();
	
	g_LastWeapon[id] = g_CurrentWeapon[id];
	
	replaceWeaponModels(id, iWeaponId);
}

public fw_ClientDisconnect_Post() {
	checkLastZombie();
}

public fw_ClientKill() {
	return FMRES_SUPERCEDE;
}

public fw_EmitSound(const id, const channel, const sample[], const Float:volume, const Float:attn, const flags, const pitch) {
	if(sample[0] == 'h' && sample[1] == 'o' && sample[2] == 's' && sample[3] == 't' && sample[4] == 'a' && sample[5] == 'g' && sample[6] == 'e') { // HOSTAGE
		return FMRES_SUPERCEDE;
	}
	
	if(sample[10] == 'f' && sample[11] == 'a' && sample[12] == 'l' && sample[13] == 'l') { // FALL
		return FMRES_SUPERCEDE;
	}
	
	if(!is_user_valid_connected(id)) {
		return FMRES_IGNORED;
	}
	
	if(!g_Zombie[id]) {
		if(g_CurrentWeapon[id] == CSW_KNIFE) {
			static i;
			
			if(g_SpecialMode[id] != MODE_JASON) {
				switch(g_WeaponModel[id][CSW_KNIFE]) {
					case 1: {
						for(i = 0; i < 9; ++i) {
							if(equal(sample, g_SOUND_Knife_Default[i])) {
								emit_sound(id, channel, g_SOUND_Hands[i], 1.0, ATTN_NORM, 0, PITCH_NORM);
								return FMRES_SUPERCEDE;
							}
						}
					} case 2,3: {
						for(i = 0; i < 9; ++i) {
							if(equal(sample, g_SOUND_Knife_Default[i])) {
								emit_sound(id, channel, g_SOUND_NewKnife[i], 1.0, ATTN_NORM, 0, PITCH_NORM);
								return FMRES_SUPERCEDE;
							}
						}
					} case 4,6: {
						for(i = 0; i < 9; ++i) {
							if(equal(sample, g_SOUND_Knife_Default[i])) {
								emit_sound(id, channel, g_SOUND_Sword[i], 1.0, ATTN_NORM, 0, PITCH_NORM);
								return FMRES_SUPERCEDE;
							}
						}
					} case 5: {
						for(i = 0; i < 9; ++i) {
							if(equal(sample, g_SOUND_Knife_Default[i])) {
								emit_sound(id, channel, g_SOUND_Axes[i], 1.0, ATTN_NORM, 0, PITCH_NORM);
								return FMRES_SUPERCEDE;
							}
						}
					}
				}
			} else {
				for(i = 0; i < 9; ++i) {
					if(equal(sample, g_SOUND_Knife_Default[i])) {
						emit_sound(id, channel, g_SOUND_Chainsaw[i], 1.0, ATTN_NORM, 0, PITCH_NORM);
						return FMRES_SUPERCEDE;
					}
				}
			}
		}
		
		return FMRES_IGNORED;
	}

	if(sample[7] == 'b' && sample[8] == 'h' && sample[9] == 'i' && sample[10] == 't') { // BHIT
		emit_sound(id, channel, g_SOUND_Zombie_Pain[random_num(0, charsmax(g_SOUND_Zombie_Pain))], 1.0, ATTN_NORM, 0, PITCH_NORM);
		return FMRES_SUPERCEDE;
	}
	
	if(g_CurrentWeapon[id] == CSW_KNIFE) {
		if(!g_BlockSound[id]) {
			if(sample[8] == 'k' && sample[9] == 'n' && sample[10] == 'i') { // KNI
				if(sample[14] == 's' && sample[15] == 'l' && sample[16] == 'a') { // SLA
					emit_sound(id, channel, g_SOUND_Zombie_Knife[2], 1.0, ATTN_NORM, 0, PITCH_NORM);
					return FMRES_SUPERCEDE;
				}
				
				if(sample[14] == 'h' && sample[15] == 'i' && sample[16] == 't') { // HIT
					if(sample[17] == 'w') { // WALL
						emit_sound(id, channel, g_SOUND_Zombie_Knife[1], 1.0, ATTN_NORM, 0, PITCH_NORM);
						return FMRES_SUPERCEDE;
					} else {
						emit_sound(id, channel, g_SOUND_Zombie_Knife[0], 1.0, ATTN_NORM, 0, PITCH_NORM);
						return FMRES_SUPERCEDE;
					}
				}
				
				if(sample[14] == 's' && sample[15] == 't' && sample[16] == 'a') { // STAB
					emit_sound(id, channel, g_SOUND_Zombie_Knife[1], 1.0, ATTN_NORM, 0, PITCH_NORM);
					return FMRES_SUPERCEDE;
				}
			}
		} else {
			g_BlockSound[id] = 0;
		}
	}
	
	if(sample[7] == 'd' && ((sample[8] == 'i' && sample[9] == 'e') || (sample[8] == 'e' && sample[9] == 'a'))) { // DIE / DEAD
		emit_sound(id, channel, g_SOUND_Zombie_Death[random_num(0, charsmax(g_SOUND_Zombie_Death))], 1.0, ATTN_NORM, 0, PITCH_NORM);
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}

public fw_SetClientKeyValue(const id, const infobuffer[], const key[]) {
	if(key[0] == 'm' && key[1] == 'o' && key[2] == 'd' && key[3] == 'e' && key[4] == 'l') {
		return FMRES_SUPERCEDE;
	}
	
	if(!g_AllowChangeName[id] && !g_AllowChangeName_SPECIAL[id]) {
		if(key[0] == 'n' && key[1] == 'a' && key[2] == 'm' && key[3] == 'e') {
			return FMRES_SUPERCEDE;
		}
	}
	
	return FMRES_IGNORED;
}

public fw_ClientUserInfoChanged(const id, const buffer) {
	if(!g_IsConnected[id]) {
		return FMRES_IGNORED;
	}
	
	get_user_name(id, g_UserName[id], 31);
	
	static sCurrentModel[32];
	getUserModel(id, sCurrentModel, 31);
	
	if(!equal(sCurrentModel, g_UserModel[id]) && !task_exists(id + TASK_MODEL)) {
		setUserModel(id + TASK_MODEL);
	}
	
	static sNewName[32];
	engfunc(EngFunc_InfoKeyValue, buffer, "name", sNewName, 31);
	
	if(equal(sNewName, g_UserName[id])) {
		return FMRES_IGNORED;
	}
	
	if(!g_AllowChangeName[id] && !g_AllowChangeName_SPECIAL[id]) {
		engfunc(EngFunc_SetClientKeyValue, id, buffer, "name", g_UserName[id]);
		client_cmd(id, "name ^"%s^"; setinfo name ^"%s^"", g_UserName[id], g_UserName[id]);
		set_user_info(id, "name", g_UserName[id]);
		
		return FMRES_SUPERCEDE;
	} else if(g_AllowChangeName[id]) {
		g_AllowChangeName[id] = 0;
		
		engfunc(EngFunc_InfoKeyValue, buffer, "name", g_UserName[id], 31);
	} else if(g_AllowChangeName_SPECIAL[id]) {
		g_AllowChangeName_SPECIAL[id] = 0;
		
		engfunc(EngFunc_InfoKeyValue, buffer, "name", g_UserName[id], 31);
		
		showMenu__ConfirmName(id);
	}
	
	return FMRES_SUPERCEDE;
}

public fw_SetModel(const entity, const model[]) {
	if(strlen(model) < 8) {
		return FMRES_IGNORED;
	}
	
	static sClassName[10];
	entity_get_string(entity, EV_SZ_classname, sClassName, 9);
	
	if(equal(sClassName, "weaponbox")) {
		entity_set_float(entity, EV_FL_nextthink, get_gametime() + 0.01);
		return FMRES_IGNORED;
	}
	
	if(model[7] != 'w' || model[8] != '_') {
		return FMRES_IGNORED;
	}
	
	static Float:fDamageTime;
	fDamageTime = entity_get_float(entity, EV_FL_dmgtime);
	
	if(fDamageTime == 0.0) {
		return FMRES_IGNORED;
	}
	
	new id;
	id = entity_get_edict(entity, EV_ENT_owner);
	
	switch(model[9]) {
		case 'h': {
			if(!g_Zombie[id]) {
				if(!g_Annihilation_Bomb[id]) {
					effectGrenade(entity, 255, 0, 0, NADE_TYPE_COMBO);
					
					entity_set_model(entity, g_MODEL_Combo_World);
					return FMRES_SUPERCEDE;
				} else {
					effectGrenade(entity, 200, 100, 50, NADE_TYPE_ANIQUILACION);
					--g_Annihilation_Bomb[id];
				}
			} else {
				effectGrenade(entity, 0, 255, 0, NADE_TYPE_INFECTION);
			}
			
			replaceWeaponModels(id, CSW_HEGRENADE);
		} case 'f': {
			if(g_SuperNova_Bomb[id]) {
				effectGrenade(entity, 0, 100, 200, NADE_TYPE_SUPERNOVA);
				--g_SuperNova_Bomb[id];
				
				replaceWeaponModels(id, CSW_FLASHBANG);
				
				entity_set_model(entity, g_MODEL_Supernova_World);
				return FMRES_SUPERCEDE;
			} else {
				effectGrenade(entity, 0, 100, 200, NADE_TYPE_FROST);
			}
			
			replaceWeaponModels(id, CSW_FLASHBANG);
		} case 's': {
			if(!g_Antidote_Bomb[id]) {
				if(g_Bubble_Bomb[id]) {
					effectGrenade(entity, g_Options_Color[id][COLOR_FLARE][__R], g_Options_Color[id][COLOR_FLARE][__G], g_Options_Color[id][COLOR_FLARE][__B], NADE_TYPE_BUBBLE);
					--g_Bubble_Bomb[id];
					
					entity_set_model(entity, g_MODEL_Bubble_World);
					return FMRES_SUPERCEDE;
				} else {
					effectGrenade(entity, 255, 255, 255, NADE_TYPE_FLARE);
				}
			} else {
				effectGrenade(entity, 0, 255, 255, NADE_TYPE_ANTIDOTO);
				--g_Antidote_Bomb[id];
			}
			
			replaceWeaponModels(id, CSW_SMOKEGRENADE);
		}
	}
	
	return FMRES_IGNORED;
}

public fw_ThinkGrenade(const entity) {
	if(!pev_valid(entity)) {
		return HAM_IGNORED;
	}
	
	static Float:fDamageTime;
	static Float:fCurrentTime;
	
	fDamageTime = entity_get_float(entity, EV_FL_dmgtime);
	fCurrentTime = get_gametime();
	
	if(fDamageTime > fCurrentTime) {
		return HAM_IGNORED;
	}
	
	switch(entity_get_int(entity, EV_NADE_TYPE)) {
		case NADE_TYPE_COMBO: {
			comboExplode(entity);
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_FROST: {
			frostExplode(entity, 1);
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_SUPERNOVA: {
			frostExplode(entity, 2);
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_BUBBLE: {
			static iDuration;
			iDuration = entity_get_int(entity, EV_FLARE_DURATION);
			
			if(iDuration > 0) {
				static i;
				if(iDuration == 1) {
					static iVictim;
					static Float:vecOrigin[3];
					static iUsers[MAX_USERS];
					static j;
					
					entity_get_vector(entity, EV_VEC_origin, vecOrigin);
					
					iVictim = -1;
					j = 0;
					
					while((iVictim = find_ent_in_sphere(iVictim, vecOrigin, 125.0)) != 0) {
						if(is_user_alive(iVictim) && !g_Zombie[iVictim]) {
							iUsers[j++] = iVictim;
						}
					}
					
					remove_entity(entity);
					
					for(i = 0; i < j; ++i) {
						g_InBubble[iUsers[i]] = 0;
					}
					
					return HAM_SUPERCEDE;
				}
				
				if(!(iDuration % 20)) {
					i = entity_get_edict(entity, EV_ENT_owner);
					
					flareLighting(entity, iDuration, HUMAN_FLARE(i) - 7);
				}
				
				bubblePush(entity);
				
				entity_set_int(entity, EV_FLARE_DURATION, --iDuration);
				entity_set_float(entity, EV_FL_dmgtime, fCurrentTime + 0.1);
			} else if((get_entity_flags(entity) & FL_ONGROUND) && fm_get_speed(entity) < 10) {
				if(g_EndRound) {
					return HAM_SUPERCEDE;
				}
				
				emit_sound(entity, CHAN_WEAPON, g_SOUND_BubbleOn, 1.0, ATTN_NORM, 0, PITCH_NORM);
				
				entity_set_model(entity, g_MODEL_Bubble);
				
				entity_set_vector(entity, EV_VEC_angles, Float:{0.0, 0.0, 0.0});
				
				new Float:vecColor[3];
				entity_get_vector(entity, EV_FLARE_COLOR, vecColor);
				
				entity_set_int(entity, EV_INT_renderfx, kRenderFxPulseSlow);
				entity_set_vector(entity, EV_VEC_rendercolor, vecColor);
				entity_set_int(entity, EV_INT_rendermode, kRenderTransAlpha);
				entity_set_float(entity, EV_FL_renderamt, 60.0);
				
				new id;
				id = entity_get_edict(entity, EV_ENT_owner);
				
				entity_set_int(entity, EV_FLARE_DURATION, 120 + (g_Hab[id][CLASS_SPECIAL][HAB_SPECIAL_BUBBLE_TIME] * __HABILITIES[CLASS_SPECIAL][HAB_SPECIAL_BUBBLE_TIME][habValue]));
				entity_set_float(entity, EV_FL_dmgtime, fCurrentTime + 0.1);
			} else {
				entity_set_float(entity, EV_FL_dmgtime, fCurrentTime + 0.5);
			}
		}
		case NADE_TYPE_FLARE: {
			static iDuration;
			iDuration = entity_get_int(entity, EV_FLARE_DURATION);
			
			if(iDuration > 0) {
				if(iDuration == 1) {
					remove_entity(entity);
					return HAM_SUPERCEDE;
				}
				
				static id;
				id = entity_get_edict(entity, EV_ENT_owner);
				
				flareLighting(entity, iDuration, HUMAN_FLARE(id));
				
				entity_set_int(entity, EV_FLARE_DURATION, --iDuration);
				entity_set_float(entity, EV_FL_dmgtime, fCurrentTime + 2.0);
			} else if((get_entity_flags(entity) & FL_ONGROUND) && fm_get_speed(entity) < 10) {
				if(g_EndRound) {
					return HAM_SUPERCEDE;
				}
				
				emit_sound(entity, CHAN_WEAPON, g_SOUND_Grenade_Flare, 1.0, ATTN_NORM, 0, PITCH_NORM);
				
				entity_set_int(entity, EV_FLARE_DURATION, 30);
				entity_set_float(entity, EV_FL_dmgtime, fCurrentTime + 0.1);
			} else {
				entity_set_float(entity, EV_FL_dmgtime, fCurrentTime + 1.0);
			}
		}
		case NADE_TYPE_INFECTION: {
			infectionExplode(entity);
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_ANIQUILACION: {
			annihilationExplode(entity);
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_ANTIDOTO: {
			antidoteExplode(entity);
			return HAM_SUPERCEDE;
		}
	}
	
	return HAM_IGNORED;
}

public client_PreThink(id) {
	if(!g_IsAlive[id]) {
		return;
	}
	
	if(g_Frozen[id]) {
		set_user_velocity(id, Float:{0.0, 0.0, 0.0});
		
		return;
	}
	
	if(g_Zombie[id]) {
		entity_set_int(id, EV_NADE_TYPE, STEPTIME_SILENT);
	}
}

// public fw_PlayerPostThink(const id) {
	
// }

public message__Money(const msg_id, const msg_dest, const msg_entity) {
	if(g_IsConnected[msg_entity]) {
		cs_set_user_money(msg_entity, 0);
	}
	
	return PLUGIN_HANDLED;
}

public message__CurWeapon(const msg_id, const msg_dest, const msg_entity) {
	if(!g_UnlimitedClip[msg_entity]) {
		return;
	}
	
	if(get_msg_arg_int(1) != 1) {
		return;
	}
	
	static iWeapon;
	iWeapon = get_msg_arg_int(2);
	
	if(MAX_BPAMMO[iWeapon] > 2) {
		static iWeaponEnt;
		iWeaponEnt = getCurrentWeaponEnt(msg_entity);
		
		if(pev_valid(iWeaponEnt)) {
			set_pdata_int(iWeaponEnt, OFFSET_CLIPAMMO, 100, OFFSET_LINUX_WEAPONS);
		}
		
		set_msg_arg_int(3, get_msg_argtype(3), 100);
	}
}

public message__FlashBat(const msg_id, const msg_dest, const msg_entity) {
	if(get_msg_arg_int(1) < 100) {
		set_msg_arg_int(1, ARG_BYTE, 100);
		setUserBatteries(msg_entity, 100);
	}
}

public message__Flashlight() {
	set_msg_arg_int(2, ARG_BYTE, 100);
}

public message__NVGToggle(const msg_id, const msg_dest, const msg_entity) {	
	return PLUGIN_HANDLED;
}

public message__WeapPickup(const msg_id, const msg_dest, const msg_entity) {
	if(g_Zombie[msg_entity]) {
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_CONTINUE;
}

public message__AmmoPickup(const msg_id, const msg_dest, const msg_entity) {
	if(g_Zombie[msg_entity]) {
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_CONTINUE;
}

public message__TextMsg() {
	static sMsg[22];
	get_msg_arg_string(2, sMsg, 21);
	
	// #Game_teammate_attack
	if(sMsg[1] == 'G' && sMsg[2] == 'a' && sMsg[3] == 'm' && sMsg[4] == 'e' &&
	sMsg[6] == 't' && sMsg[7] == 'e' && sMsg[8] == 'a' && sMsg[9] == 'm' && sMsg[10] == 'm' && sMsg[11] == 'a' && sMsg[12] == 't' && sMsg[13] == 'e' &&
	sMsg[15] == 'a' && sMsg[16] == 't' && sMsg[17] == 't' && sMsg[18] == 'a' && sMsg[19] == 'c' && sMsg[20] == 'k') {
		return PLUGIN_HANDLED;
	}
	
	// #Game_Commencing
	else if(sMsg[1] == 'G' && sMsg[2] == 'a' && sMsg[3] == 'm' && sMsg[4] == 'e' &&
	sMsg[6] == 'C' && sMsg[7] == 'o' && sMsg[8] == 'm' && sMsg[9] == 'm' && sMsg[10] == 'e' && sMsg[11] == 'n' && sMsg[12] == 'c' && sMsg[13] == 'i' && sMsg[14] == 'n' && sMsg[15] == 'g') {
		return PLUGIN_HANDLED;
	}
	
	// #Game_will_restart_in
	else if(sMsg[1] == 'G' && sMsg[2] == 'a' && sMsg[3] == 'm' && sMsg[4] == 'e' &&
	sMsg[6] == 'w' && sMsg[7] == 'i' && sMsg[8] == 'l' && sMsg[9] == 'l' &&
	sMsg[11] == 'r' && sMsg[12] == 'e' && sMsg[13] == 's' && sMsg[14] == 't' &&	sMsg[15] == 'a' && sMsg[16] == 'r' && sMsg[17] == 't' &&
	sMsg[19] == 'i' && sMsg[20] == 'n') {
		g_ScoreHumans = 0;
		g_ScoreZombies = 0;
		
		logevent__RoundEnd();
	}
	
	// #Hostages_Not_Rescued
	else if(sMsg[1] == 'H' && sMsg[2] == 'o' && sMsg[3] == 's' && sMsg[4] == 't' &&	sMsg[5] == 'a' && sMsg[6] == 'g' && sMsg[7] == 'e' && sMsg[8] == 's' &&
	sMsg[10] == 'N' && sMsg[11] == 'o' && sMsg[12] == 't' &&
	sMsg[14] == 'R' &&	sMsg[15] == 'e' && sMsg[16] == 's' && sMsg[17] == 'c' && sMsg[18] == 'u' && sMsg[19] == 'e' && sMsg[20] == 'd') {
		return PLUGIN_HANDLED;
	}
	
	// #Round_Draw
	else if(sMsg[1] == 'R' && sMsg[2] == 'o' && sMsg[3] == 'u' && sMsg[4] == 'n' &&	sMsg[5] == 'd' &&
	sMsg[7] == 'D' && sMsg[8] == 'r' && sMsg[9] == 'a' && sMsg[10] == 'w') {
		return PLUGIN_HANDLED;
	}
	
	// #Terrorists_Win
	else if(sMsg[1] == 'T' && sMsg[2] == 'e' && sMsg[3] == 'r' && sMsg[4] == 'r' &&	sMsg[5] == 'o' && sMsg[6] == 'r' && sMsg[7] == 'i' && sMsg[8] == 's' && sMsg[9] == 't' && sMsg[10] == 's' &&
	sMsg[12] == 'W' && sMsg[13] == 'i' && sMsg[14] == 'n') {
		return PLUGIN_HANDLED;
	}
	
	// #CTs_Win
	else if(sMsg[1] == 'C' && sMsg[2] == 'T' && sMsg[3] == 's' &&
	sMsg[5] == 'W' && sMsg[6] == 'i' && sMsg[7] == 'n') {
		return PLUGIN_HANDLED;
	}
	
	// #Fire_in_the_hole
	if(get_msg_args() == 5 && (get_msg_argtype(5) == ARG_STRING)) {
		get_msg_arg_string(5, sMsg, 21);
		
		if(sMsg[1] == 'F' && sMsg[2] == 'i' && sMsg[3] == 'r' && sMsg[4] == 'e' &&
		sMsg[6] == 'i' && sMsg[7] == 'n' &&
		sMsg[9] == 't' && sMsg[10] == 'h' && sMsg[11] == 'e' &&
		sMsg[13] == 'h' && sMsg[14] == 'o' && sMsg[15] == 'l' && sMsg[16] == 'e') {
			return PLUGIN_HANDLED;
		}
	} else if(get_msg_args() == 6 && (get_msg_argtype(6) == ARG_STRING)) {
		get_msg_arg_string(6, sMsg, 21);
		
		if(sMsg[1] == 'F' && sMsg[2] == 'i' && sMsg[3] == 'r' && sMsg[4] == 'e' &&
		sMsg[6] == 'i' && sMsg[7] == 'n' &&
		sMsg[9] == 't' && sMsg[10] == 'h' && sMsg[11] == 'e' &&
		sMsg[13] == 'h' && sMsg[14] == 'o' && sMsg[15] == 'l' && sMsg[16] == 'e') {
			return PLUGIN_HANDLED;
		}
	}
	
	return PLUGIN_CONTINUE;
}

public message__SendAudio() {
	static sAudio[19];
	get_msg_arg_string(2, sAudio, 18);
	
	if((sAudio[7] == 't' && sAudio[8] == 'e' && sAudio[9] == 'r' && sAudio[10] == 'w' && sAudio[11] == 'i' && sAudio[12] == 'n') ||
	(sAudio[7] == 'c' && sAudio[8] == 't' && sAudio[9] == 'w' && sAudio[10] == 'i' && sAudio[11] == 'n') ||
	(sAudio[7] == 'r' && sAudio[8] == 'o' && sAudio[9] == 'u' && sAudio[10] == 'n' && sAudio[11] == 'd' && sAudio[12] == 'd' && sAudio[13] == 'r' && sAudio[14] == 'a' && sAudio[15] == 'w') ||
	(sAudio[7] == 'F' && sAudio[8] == 'I' && sAudio[9] == 'R' && sAudio[10] == 'E' && sAudio[11] == 'I' && sAudio[12] == 'N' && sAudio[13] == 'H' && sAudio[14] == 'O' && sAudio[15] == 'L' && sAudio[16] == 'E'))
		return PLUGIN_HANDLED;
	
	return PLUGIN_CONTINUE;
}

public message__TeamScore() {
	static sTeam[2];
	get_msg_arg_string(1, sTeam, 1);
	
	switch(sTeam[0]) {
		case 'C': set_msg_arg_int(2, get_msg_argtype(2), g_ScoreHumans);
		case 'T': set_msg_arg_int(2, get_msg_argtype(2), g_ScoreZombies);
	}
}

public message__TeamInfo(const msg_id, const msg_dest) {
	if(msg_dest != MSG_ALL && msg_dest != MSG_BROADCAST) {
		return;
	}
	
	if(g_SwitchingTeams) {
		return;
	}
	
	static id;
	id = get_msg_arg_int(1);
	
	if(!is_user_valid(id)) {
		return;
	}
	
	setLight(id, "b");
	
	set_task(0.2, "task__SpecNightvision", id);
	
	if(g_NewRound) {
		return;
	}
	
	static sTeam[2];
	get_msg_arg_string(2, sTeam, 1);
	
	switch(sTeam[0]) {
		case 'C': {
			if((g_Mode == MODE_SURVIVOR || g_Mode == MODE_WESKER) && getHumans()) {
				g_RespawnAsZombie[id] = 1;
				
				remove_task(id + TASK_TEAM);
				setUserTeam(id, FM_CS_TEAM_T);
				
				set_msg_arg_string(2, "TERRORIST");
			} else if(!getZombies()) {
				g_RespawnAsZombie[id] = 1;
				remove_task(id + TASK_TEAM);
				
				setUserTeam(id, FM_CS_TEAM_T);
				
				set_msg_arg_string(2, "TERRORIST");
			}
		} case 'T': {
			if((g_Mode == MODE_SWARM || g_Mode == MODE_SURVIVOR || g_Mode == MODE_WESKER) && getHumans()) {
				g_RespawnAsZombie[id] = 1;
				
				remove_task(id + TASK_TEAM);
				setUserTeam(id, FM_CS_TEAM_T);
				
				set_msg_arg_string(2, "TERRORIST");
			} else if(getZombies()) {
				remove_task(id + TASK_TEAM);
				setUserTeam(id, FM_CS_TEAM_CT);
				
				set_msg_arg_string(2, "CT");
			}
		}
	}
}

getHumans() {
	new i;
	new iHumans = 0;
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(g_IsAlive[i] && !g_Zombie[i]) {
			++iHumans;
		}
	}
	
	return iHumans;
}

getZombies() {
	new i;
	new iZombies = 0;
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(g_IsAlive[i] && g_Zombie[i]) {
			++iZombies;
		}
	}
	
	return iZombies;
}

getPlaying() {
	new iPlaying = 0;
	new iTeam;
	new i;
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(g_IsConnected[i]) {
			iTeam = getUserTeam(i);
			
			if(iTeam != FM_CS_TEAM_SPECTATOR && iTeam != FM_CS_TEAM_UNASSIGNED) {
				++iPlaying;
			}
		}
	}
	
	return iPlaying;
}

getCTs() {
	new iCTs;
	new id;
	
	iCTs = 0;
	
	for(id = 1; id <= g_MaxUsers; ++id) {
		if(g_IsConnected[id]) {			
			if(getUserTeam(id) == FM_CS_TEAM_CT) {
				++iCTs;
			}
		}
	}
	
	return iCTs;
}

getTs() {
	new iTs;
	new id;
	
	iTs = 0;
	
	for(id = 1; id <= g_MaxUsers; ++id) {
		if(g_IsConnected[id]) {			
			if(getUserTeam(id) == FM_CS_TEAM_T) {
				++iTs;
			}
		}
	}
	
	return iTs;
}

public isSolid(const entity) {
	return (entity ? ((entity_get_int(entity, EV_INT_solid) > SOLID_TRIGGER) ? 1 : 0) : 1);
}

public dropWeapons(const id, const dropwhat) {
	new sWeapons[32];
	new iWeaponId;
	new iNum;
	new i;
	
	iNum = 0;
	get_user_weapons(id, sWeapons, iNum);
	
	for(i = 0; i < iNum; ++i) {
		iWeaponId = sWeapons[i];
		
		if((dropwhat == 1 && ((1<<iWeaponId) & PRIMARY_WEAPONS_BIT_SUM)) || (dropwhat == 2 && ((1<<iWeaponId) & SECONDARY_WEAPONS_BIT_SUM))) {
			new sWeaponName[32];
			get_weaponname(iWeaponId, sWeaponName, 31);
			
			engclient_cmd(id, "drop", sWeaponName);
		}
	}
}

public isHullVacant(const Float:origin[3], const hull) {
	engfunc(EngFunc_TraceHull, origin, origin, 0, hull, 0, 0);
	
	if(!get_tr2(0, TR_StartSolid) && !get_tr2(0, TR_AllSolid) && get_tr2(0, TR_InOpen)) {
		return 1;
	}
	
	return 0;
}

public isUserStuck(const id) {
	new Float:vecOrigin[3];
	entity_get_vector(id, EV_VEC_origin, vecOrigin);
	
	engfunc(EngFunc_TraceHull, vecOrigin, vecOrigin, 0, (entity_get_int(id, EV_INT_flags) & FL_DUCKING) ? HULL_HEAD : HULL_HUMAN, id, 0);
	
	if(get_tr2(0, TR_StartSolid) || get_tr2(0, TR_AllSolid) || !get_tr2(0, TR_InOpen)) {
		return 1;
	}
	
	return 0;
}

public weaponNameId(const weapon[]) {
	new i;
	for(i = 1; i < 31; ++i) {
		if(equal(weapon, WEAPON_ENT_NAMES[i])) {
			return i;
		}
	}
	
	return 0;
}

public getCurrentWeaponEnt(const id) {
	if(pev_valid(id) != PDATA_SAFE) {
		return -1;
	}
	
	return get_pdata_cbase(id, OFFSET_ACTIVE_ITEM, OFFSET_LINUX);
}

public getWeaponEntId(const entity) {
	if(pev_valid(entity) != PDATA_SAFE) {
		return -1;
	}
	
	return get_pdata_cbase(entity, OFFSET_WEAPONOWNER, OFFSET_LINUX_WEAPONS);
}

public getUserTeam(const id) {
	if(pev_valid(id) != PDATA_SAFE) {
		return FM_CS_TEAM_UNASSIGNED;
	}
	
	return get_pdata_int(id, OFFSET_CSTEAMS, OFFSET_LINUX);
}

public setUserTeam(const id, const team) {
	if(pev_valid(id) != PDATA_SAFE) {
		return;
	}
	
	set_pdata_int(id, OFFSET_CSTEAMS, team, OFFSET_LINUX);
	
	cs_set_team_id(id, team);
}

public setUserBatteries(const id, const value) {
	if(pev_valid(id) != PDATA_SAFE) {
		return;
	}
	
	set_pdata_int(id, OFFSET_FLASHLIGHT_BATTERY, value, OFFSET_LINUX);
}

public userTeamUpdate(const id) {
	new Float:fCurrentTime;
	fCurrentTime = get_gametime();
	
	if(fCurrentTime - g_TeamsTargetTime >= 0.1) {
		set_task(0.1, "task__SetUserTeamMsg", id + TASK_TEAM);
		g_TeamsTargetTime = fCurrentTime + 0.1;
	} else {
		set_task((g_TeamsTargetTime + 0.1) - fCurrentTime, "task__SetUserTeamMsg", id + TASK_TEAM);
		g_TeamsTargetTime += 0.1;
	}
}

public task__SetUserTeamMsg(const taskid) {
	g_SwitchingTeams = 1;
	
	emessage_begin(MSG_ALL, g_Message_TeamInfo);
	ewrite_byte(ID_TEAM);
	ewrite_string(CS_TEAM_NAMES[getUserTeam(ID_TEAM)]);
	emessage_end();
	
	g_SwitchingTeams = 0;
}

public setUserModel(const taskid) {
	set_user_info(ID_MODEL, "model", g_UserModel[ID_MODEL]);
}

public getUserModel(const id, model[], const len) {
	get_user_info(id, "model", model, len);
}

public userModelUpdate(const taskid) {
	new Float:fCurrentTime;
	fCurrentTime = get_gametime();
	
	if((fCurrentTime - g_ModelsTargetTime) >= MODELS_CHANGE_DELAY) {
		setUserModel(taskid);
		g_ModelsTargetTime = fCurrentTime;
	} else {
		set_task((g_ModelsTargetTime + MODELS_CHANGE_DELAY) - fCurrentTime, "setUserModel", taskid);
		g_ModelsTargetTime += MODELS_CHANGE_DELAY;
	}
}

public task__ModifCommands(const id) {
	if(!g_IsConnected[id]) {
		return;
	}
	
	client_cmd(id, "cl_minmodels 0");
	client_cmd(id, "setinfo zp4 ^"^"");
	client_cmd(id, "setinfo jb1 ^"^"");
	client_cmd(id, "setinfo _pw ^"^"");
	
	new OrpheuHook:handlePrintF;
	handlePrintF = OrpheuRegisterHook(OrpheuGetFunction("Con_Printf"), "Con_Printf");
	
	server_cmd("sxe_userhid #%d", get_user_userid(id));
	server_exec();
	
	OrpheuUnregisterHook(handlePrintF);
	
	copy(g_DisconnectHID[id], 63, g_MessageHID);
	
	replace_all(g_DisconnectHID[id], 63, "sxei_userhid: ", "");
	replace_all(g_DisconnectHID[id], 63, "[", "");
	replace_all(g_DisconnectHID[id], 63, "]", "");
	replace_all(g_DisconnectHID[id], 63, "^n", "");
}

public task__CheckAccount(const taskid) {
	new id;
	id = (taskid > g_MaxUsers) ? ID_CHECK_ACCOUNT : taskid;
	
	if(!is_user_connected(id)) {
		return;
	}
	
	if(!g_AccountName[id][0]) {
		get_user_info(id, "zp6", g_AccountName[id], 31);
		strtolower(g_AccountName[id]);
	}
	
	// Fixea el formato de DATE_FORMAT() de MySQL porque usa %d , %i , %s para obtener datos y los confunde con parámetros de Pawn.
	new sFix1[3];
	new sFix2[3];
	new sFix3[5];
	new sFix4[3];
	new sFix5[3];
	new sFix6[3];
	
	formatex(sFix1, 2, "pa");
	formatex(sFix2, 2, "pe");
	formatex(sFix3, 4, "pi");
	formatex(sFix4, 2, "po");
	formatex(sFix5, 2, "pu");
	formatex(sFix6, 2, "pt");
	
	replace(sFix1, 2, "pa", "%d");
	replace(sFix2, 2, "pe", "%m");
	replace(sFix3, 4, "pi", "%Y");
	replace(sFix4, 2, "po", "%k");
	replace(sFix5, 2, "pu", "%i");
	replace(sFix6, 2, "pt", "%s");
	
	new Handle:sqlQuery;
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT id, password, INET_NTOA(ip), hid, vinc, DATE_FORMAT(FROM_UNIXTIME(register), ^"%s-%s-%s %s:%s:%s^"), visit_days, register FROM zp6_accounts WHERE acc_name = ^"%s^" LIMIT 1;", sFix1, sFix2, sFix3, sFix4, sFix5, sFix6, g_AccountName[id]);
	
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(id, sqlQuery, 200);
	} else if(SQL_NumResults(sqlQuery)) {
		new sIP[21];
		new sIPdb[21];
		new sPassword[32];
		new i;
		new j;
		
		j = SQL_ReadResult(sqlQuery, 0);
		
		for(i = 1; i <= g_MaxUsers; ++i) {
			if(!g_IsConnected[i]) {
				continue;
			}
			
			if(id == i) {
				continue;
			}
			
			if(j == g_AccountId[i] && g_AccountLogged[i]) { // Un usuario ya está logeado con esta cuenta!
				g_AnotherUserInYourAccount[id] = j;
				copy(g_AnotherUserInYourAccount_Name[id], 31, g_UserName[i]);
				
				clcmd__Changeteam(id);
				
				SQL_FreeHandle(sqlQuery);
				return;
			}
		}
		
		g_AccountId[id] = j;
		
		SQL_ReadResult(sqlQuery, 1, g_AccountPassword[id], 31);
		SQL_ReadResult(sqlQuery, 2, sIPdb, 20);
		SQL_ReadResult(sqlQuery, 3, g_AccountHID[id], 63);
		g_Vinc[id] = SQL_ReadResult(sqlQuery, 4);
		SQL_ReadResult(sqlQuery, 5, g_RegisterSince[id], 31);
		g_VisitDays[id] = SQL_ReadResult(sqlQuery, 6);
		g_RegisterDate[id] = SQL_ReadResult(sqlQuery, 7);
		
		copy(g_DisconnectHID[id], 63, g_AccountHID[id]);
		
		if(!g_Vinc[id]) {
			set_task(180.0, "task__RememberVinc", id + TASK_MESSAGE_VINC);
		}
		
		SQL_FreeHandle(sqlQuery);
		
		sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT pj_id, pj_name, level, reset FROM zp6_pjs WHERE acc_id = '%d' LIMIT 4;", g_AccountId[id]);
		
		if(!SQL_Execute(sqlQuery)) {
			executeQuery(id, sqlQuery, 300);
		} else if(SQL_NumResults(sqlQuery)) {
			while(SQL_MoreResults(sqlQuery)) {
				i = SQL_ReadResult(sqlQuery, 0) - 1;
				g_AccountPJs[id][i] = i+1;
				
				SQL_ReadResult(sqlQuery, 1, g_AccountPJ_Name[id][i], 31);
				
				g_AccountPJ_Level[id][i] = SQL_ReadResult(sqlQuery, 2);
				g_AccountPJ_Reset[id][i] = SQL_ReadResult(sqlQuery, 3);
				
				SQL_NextRow(sqlQuery);
			}
			
			SQL_FreeHandle(sqlQuery);
		} else {
			SQL_FreeHandle(sqlQuery);
		}
		
		// Fixea el formato de DATE_FORMAT() de MySQL porque usa %d , %i , %s para obtener datos y los confunde con parámetros de Pawn.
		new sFix1[3];
		new sFix2[3];
		new sFix3[5];
		new sFix4[3];
		new sFix5[3];
		new sFix6[3];
		
		formatex(sFix1, 2, "pa");
		formatex(sFix2, 2, "pe");
		formatex(sFix3, 4, "pi");
		formatex(sFix4, 2, "po");
		formatex(sFix5, 2, "pu");
		formatex(sFix6, 2, "pt");
		
		replace(sFix1, 2, "pa", "%d");
		replace(sFix2, 2, "pe", "%m");
		replace(sFix3, 4, "pi", "%Y");
		replace(sFix4, 2, "po", "%k");
		replace(sFix5, 2, "pu", "%i");
		replace(sFix6, 2, "pt", "%s");
		
		// Está baneada la cuenta ?
		sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT start, finish, DATE_FORMAT(FROM_UNIXTIME(start), ^"%s-%s-%s %s:%s:%s^"), DATE_FORMAT(FROM_UNIXTIME(finish), ^"%s-%s-%s %s:%s:%s^"), \
		name_admin, reason FROM zp6_bans WHERE (hid = ^"%s^" OR acc_id = '%d') AND activo = '1' LIMIT 1;", sFix1, sFix2, sFix3, sFix4, sFix5, sFix6, sFix1, sFix2, sFix3, sFix4, sFix5, sFix6, g_AccountHID[id], g_AccountId[id]);
		if(!SQL_Execute(sqlQuery)) {
			executeQuery(id, sqlQuery, 400);
		} else if(SQL_NumResults(sqlQuery)) {
			new iStart;
			new iFinish;
			
			iStart = SQL_ReadResult(sqlQuery, 0);
			iFinish = SQL_ReadResult(sqlQuery, 1);
			
			if(iFinish > iStart) { // Sigue baneado
				g_AccountBanned[id] = 1;
				
				SQL_ReadResult(sqlQuery, 2, g_AccountBan_Start[id], 31);
				SQL_ReadResult(sqlQuery, 3, g_AccountBan_Finish[id], 31);
				SQL_ReadResult(sqlQuery, 4, g_AccountBan_Admin[id], 31);
				SQL_ReadResult(sqlQuery, 5, g_AccountBan_Reason[id], 127);
			} else { // Finalizó su ban, desbanearlo!
				colorChat(0, TERRORIST, "%sEl usuario !t%s!y tenía !gban de cuenta!y pero ya puede volver a jugar!", ZP_PREFIX, g_UserName[id]);
				
				sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE zp6_bans SET activo = '0' WHERE (hid = ^"%s^" OR acc_id = '%d') AND activo = '1';", g_AccountHID[id], g_AccountId[id]);
				if(!SQL_Execute(sqlQuery)) {
					executeQuery(id, sqlQuery, 500);
				} else {
					SQL_FreeHandle(sqlQuery);
				}
			}
			
			SQL_FreeHandle(sqlQuery);
		} else {
			SQL_FreeHandle(sqlQuery);
		}
		
		get_user_info(id, "zp5", sPassword, 31);
		get_user_ip(id, sIP, 20, 1);
		
		if(equal(sIPdb, sIP) && equal(g_AccountPassword[id], sPassword)) {
			g_AccountLogged[id] = 1;
		}
		
		if(id != taskid) {
			clcmd__Changeteam(id);
		}
	} else {
		SQL_FreeHandle(sqlQuery);
		
		if(id != taskid) {
			clcmd__Changeteam(id);
		}
	}
}

// No creo que se frizee el servidor, pero como hay más querys que nunca, si llegamos a ver algún freeze, cambiar toda esta parte a ThreadQuery.
public loadInfo(const id, const pj) {
	static sInfoDB[512];
	static Handle:sqlQuery;
	static iClan;
	
	
	// ACCOUNT
	
	static sFix1[3];
	formatex(sFix1, 2, "pa");
	
	replace(sFix1, 2, "pa", "%j");
	
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT id FROM zp6_accounts WHERE id='%d' AND \
												((DATE_FORMAT(FROM_UNIXTIME(last_connect), ^"%s^")+1) = DATE_FORMAT(FROM_UNIXTIME(UNIX_TIMESTAMP()), ^"%s^")) OR \
												((DATE_FORMAT(FROM_UNIXTIME(last_connect), ^"%s^")+1) = 366 AND (DATE_FORMAT(FROM_UNIXTIME(UNIX_TIMESTAMP()), ^"%s^")+0) = 2) \
												LIMIT 1;", g_AccountId[id], sFix1, sFix1, sFix1, sFix1);
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(id, sqlQuery, 600);
	} else if(SQL_NumResults(sqlQuery)) {		
		++g_VisitDays[id];
	} else {
		g_VisitDays[id] = 0;
		
		SQL_FreeHandle(sqlQuery);
	}
	
	static sDay[3];
	
	get_time("%d", sDay, 2);
	g_DayNow[id] = str_to_num(sDay);
	
	g_BonusDays[id] = float(g_VisitDays[id]) * 0.012;
	
	
	// PJ STATS
	
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT * FROM zp6_pjs LEFT JOIN zp6_pjs_stats on (zp6_pjs_stats.acc_id='%d' AND zp6_pjs_stats.pj_id='%d') WHERE zp6_pjs.acc_id='%d' AND zp6_pjs.pj_id='%d' LIMIT 1;", g_AccountId[id], (pj+1), g_AccountId[id], (pj+1));
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(id, sqlQuery, 800);
	} else if(SQL_NumResults(sqlQuery)) {
		g_SysTime_Connect[id] = get_systime();
		g_SysTime_Connect2[id] = get_systime();
		
		remove_task(id + TASK_SAVE);
		set_task(random_float(300.0, 600.0), "task__Save", id + TASK_SAVE, _, _, "b");
		
		static iTime, iTime2;
		static iCDate_Unix;
		static Float:iPlayedTimePerDaySec;
		static i;
		
		static sPoints_Human[6], sPoints_Zombie[6], sPoints_Uut[6], sPoints_Legado[6], sPoints_Diamonds[6];
		static sHabs[32][4];
		static sOptionHUD[4][11];
		static sItemExtraCount[extraItemsId][11];
		static sItemExtraCost[extraItemsId][11];
		
		g_AllowChangeName[id] = 0;
		g_AllowChangeName_SPECIAL[id] = 0;
		
		if(!equali(g_AccountPJ_Name[id][pj], g_UserName[id])) {
			g_AllowChangeName[id] = 1;
			g_AllowChangeName_SPECIAL[id] = 0;
			
			copy(g_UserName[id], 31, g_AccountPJ_Name[id][pj]);
			
			client_cmd(id, "name ^"%s^"", g_AccountPJ_Name[id][pj]);
			set_user_info(id, "name", g_AccountPJ_Name[id][pj]);
		}
		
		// 0 = id
		// 1 = acc_id
		// 2 = pj_id
		// 3 = pj_name
		iCDate_Unix = SQL_ReadResult(sqlQuery, 4); // created_date
		g_Level[id] = g_AccountPJ_Level[id][pj]; // level
		g_Reset[id] = g_AccountPJ_Reset[id][pj]; // reset
		g_AmmoPacks[id] = SQL_ReadResult(sqlQuery, 7); // ammopacks
		iClan = SQL_ReadResult(sqlQuery, 8); // clan
		SQL_ReadResult(sqlQuery, 9, Float:g_MultAps[id]); // mult_aps
		iTime = iTime2 = SQL_ReadResult(sqlQuery, 10); // time_played
		g_BestAPs_History[id] = SQL_ReadResult(sqlQuery, 11); // best_aps
		// 12 = best_aps_date
		g_HumanClass[id] = g_HumanClassNext[id] = SQL_ReadResult(sqlQuery, 13); // hclass
		g_ZombieClass[id] = g_ZombieClassNext[id] = SQL_ReadResult(sqlQuery, 14); // zclass
		g_Difficults[id][DIFF_SURVIVOR] = SQL_ReadResult(sqlQuery, 15); // surv
		g_Difficults[id][DIFF_NEMESIS] = SQL_ReadResult(sqlQuery, 16); // nem
		
		SQL_ReadResult(sqlQuery, 17, sInfoDB, 511); // points
		parse(sInfoDB, sPoints_Human, 5, sPoints_Zombie, 5, sPoints_Uut, 5, sPoints_Legado, 5, sPoints_Diamonds, 5);
		
		g_Points[id][P_HUMAN] = str_to_num(sPoints_Human);
		g_Points[id][P_ZOMBIE] = str_to_num(sPoints_Zombie);
		g_Points[id][P_UUT] = str_to_num(sPoints_Uut);
		g_Points[id][P_LEGADO] = str_to_num(sPoints_Legado);
		g_Points[id][P_DIAMONDS] = str_to_num(sPoints_Diamonds);
		
		SQL_ReadResult(sqlQuery, 18, sInfoDB, 511); // points_lost
		parse(sInfoDB, sPoints_Human, 5, sPoints_Zombie, 5, sPoints_Uut, 5, sPoints_Legado, 5, sPoints_Diamonds, 5);
		
		g_PointsLost[id][P_HUMAN] = str_to_num(sPoints_Human);
		g_PointsLost[id][P_ZOMBIE] = str_to_num(sPoints_Zombie);
		g_PointsLost[id][P_UUT] = str_to_num(sPoints_Uut);
		g_PointsLost[id][P_LEGADO] = str_to_num(sPoints_Legado);
		g_PointsLost[id][P_DIAMONDS] = str_to_num(sPoints_Diamonds);
		
		SQL_ReadResult(sqlQuery, 19, sInfoDB, 511); // habilities
		parse(sInfoDB, sHabs[0], 3, sHabs[1], 3, sHabs[2], 3, sHabs[3], 3, sHabs[4], 3, sHabs[5], 3, sHabs[6], 3, sHabs[7], 3, sHabs[8], 3, sHabs[9], 3, sHabs[10], 3, sHabs[11], 3, sHabs[12], 3, sHabs[13], 3, sHabs[14], 3, sHabs[15], 3,
		sHabs[16], 3, sHabs[17], 3, sHabs[18], 3, sHabs[19], 3, sHabs[20], 3, sHabs[21], 3, sHabs[22], 3, sHabs[23], 3, sHabs[24], 3, sHabs[25], 3, sHabs[26], 3, sHabs[27], 3, sHabs[28], 3, sHabs[29], 3, sHabs[30], 3, sHabs[31], 3);
		
		g_Hab[id][CLASS_HUMAN][HAB_HEALTH] = str_to_num(sHabs[0]);
		g_Hab[id][CLASS_HUMAN][HAB_SPEED] = str_to_num(sHabs[1]);
		g_Hab[id][CLASS_HUMAN][HAB_GRAVITY] = str_to_num(sHabs[2]);
		g_Hab[id][CLASS_HUMAN][HAB_DAMAGE] = str_to_num(sHabs[3]);
		g_Hab[id][CLASS_HUMAN][HAB_H_ARMOR] = str_to_num(sHabs[4]);
		g_Hab[id][CLASS_SPECIAL][HAB_SPECIAL_FLARE] = str_to_num(sHabs[5]);
		
		g_Hab[id][CLASS_ZOMBIE][HAB_HEALTH] = str_to_num(sHabs[6]);
		g_Hab[id][CLASS_ZOMBIE][HAB_SPEED] = str_to_num(sHabs[7]);
		g_Hab[id][CLASS_ZOMBIE][HAB_GRAVITY] = str_to_num(sHabs[8]);
		g_Hab[id][CLASS_ZOMBIE][HAB_DAMAGE] = str_to_num(sHabs[9]);
		g_Hab[id][CLASS_ZOMBIE][HAB_Z_COMBO] = str_to_num(sHabs[10]);
		g_Hab[id][CLASS_ZOMBIE][HAB_Z_RESPAWN] = str_to_num(sHabs[11]);
		
		g_Hab[id][CLASS_SURVIVOR][HAB_HEALTH] = str_to_num(sHabs[12]);
		g_Hab[id][CLASS_SURVIVOR][HAB_S_WEAPON] = str_to_num(sHabs[13]);
		g_Hab[id][CLASS_SURVIVOR][HAB_S_GRENADE] = str_to_num(sHabs[14]);
		g_Hab[id][CLASS_SURVIVOR][HAB_S_IMMUNITY] = str_to_num(sHabs[15]);
		
		g_Hab[id][CLASS_NEMESIS][HAB_HEALTH] = str_to_num(sHabs[16]);
		g_Hab[id][CLASS_NEMESIS][HAB_N_DAMAGE] = str_to_num(sHabs[17]);
		
		g_Hab[id][CLASS_WESKER][HAB_W_SUPER_LASER] = str_to_num(sHabs[18]);
		g_Hab[id][CLASS_WESKER][HAB_W_COMBO] = str_to_num(sHabs[19]);
		
		g_Hab[id][CLASS_JASON][HAB_J_TELEPORT] = str_to_num(sHabs[20]);
		g_Hab[id][CLASS_JASON][HAB_J_COMBO] = str_to_num(sHabs[21]);
		
		g_Hab[id][CLASS_SPECIAL][HAB_SPECIAL_BUBBLE_TIME] = str_to_num(sHabs[22]);
		g_Hab[id][CLASS_SPECIAL][HAB_SPECIAL_RESPAWN] = str_to_num(sHabs[23]);
		g_Hab[id][CLASS_SPECIAL][HAB_SPECIAL_VIGOR] = str_to_num(sHabs[24]);
		g_Hab[id][CLASS_SPECIAL][HAB_SPECIAL_FURIA] = str_to_num(sHabs[25]);
		
		g_Hab[id][CLASS_LEGENDARIAS][HAB_LEGENDARY_WEAPONS_LV15] = str_to_num(sHabs[26]);
		g_Hab[id][CLASS_LEGENDARIAS][HAB_LEGENDARY_RESPAWN] = str_to_num(sHabs[27]);
		g_Hab[id][CLASS_LEGENDARIAS][HAB_LEGENDARY_INDUCCION] = str_to_num(sHabs[28]);
		
		g_Hab[id][CLASS_LEGADO][HAB_LEGADO_MULT_APS] = str_to_num(sHabs[29]);
		g_Hab[id][CLASS_LEGADO][HAB_LEGADO_RESPAWN] = str_to_num(sHabs[30]);
		g_Hab[id][CLASS_LEGADO][HAB_LEGADO_RESISTENCIA] = str_to_num(sHabs[31]);
		
		SQL_ReadResult(sqlQuery, 20, sInfoDB, 511); // options
		parse(sInfoDB, sHabs[0], 3, sHabs[1], 3, sHabs[2], 3, sHabs[3], 3, sOptionHUD[0], 10, sOptionHUD[1], 10, sHabs[6], 3, sHabs[7], 3, sHabs[8], 3, sOptionHUD[2], 10, sOptionHUD[3], 10, sHabs[11], 3, sHabs[12], 3, sHabs[13], 3, sHabs[14], 3, sHabs[15], 3,
		sHabs[16], 3, sHabs[17], 3, sHabs[18], 3, sHabs[19], 3, sHabs[20], 3, sHabs[21], 3, sHabs[22], 3, sHabs[23], 3, sHabs[24], 3, sHabs[25], 3);
		
		g_Options_Invis[id] = str_to_num(sHabs[0]);
		
		g_Options_Color[id][COLOR_HUD][__R] = str_to_num(sHabs[1]);
		g_Options_Color[id][COLOR_HUD][__G] = str_to_num(sHabs[2]);
		g_Options_Color[id][COLOR_HUD][__B] = str_to_num(sHabs[3]);
		
		g_Options_HUD_Position[id][HUD_GENERAL][0] = str_to_float(sOptionHUD[0]);
		g_Options_HUD_Position[id][HUD_GENERAL][1] = str_to_float(sOptionHUD[1]);
		g_Options_HUD_Position[id][HUD_GENERAL][2] = str_to_float(sHabs[6]);
		g_Options_HUD_Effect[id][HUD_GENERAL] = str_to_num(sHabs[7]);
		g_Options_HUD_Abrev[id][HUD_GENERAL] = str_to_num(sHabs[8]);
		
		g_Options_HUD_Position[id][HUD_COMBO][0] = str_to_float(sOptionHUD[2]);
		g_Options_HUD_Position[id][HUD_COMBO][1] = str_to_float(sOptionHUD[3]);
		g_Options_HUD_Position[id][HUD_COMBO][2] = str_to_float(sHabs[11]);
		g_Options_HUD_Effect[id][HUD_COMBO] = str_to_num(sHabs[12]);
		g_Options_HUD_Abrev[id][HUD_COMBO] = str_to_num(sHabs[13]);
		
		g_Options_Color[id][COLOR_NIGHTVISION][__R] = str_to_num(sHabs[14]);
		g_Options_Color[id][COLOR_NIGHTVISION][__G] = str_to_num(sHabs[15]);
		g_Options_Color[id][COLOR_NIGHTVISION][__B] = str_to_num(sHabs[16]);
		g_Options_Color[id][COLOR_FLARE][__R] = str_to_num(sHabs[17]);
		g_Options_Color[id][COLOR_FLARE][__G] = str_to_num(sHabs[18]);
		g_Options_Color[id][COLOR_FLARE][__B] = str_to_num(sHabs[19]);
		g_Options_Color[id][COLOR_BAZOOKA][__R] = str_to_num(sHabs[20]);
		g_Options_Color[id][COLOR_BAZOOKA][__G] = str_to_num(sHabs[21]);
		g_Options_Color[id][COLOR_BAZOOKA][__B] = str_to_num(sHabs[22]);
		g_Options_Color[id][COLOR_LASER][__R] = str_to_num(sHabs[23]);
		g_Options_Color[id][COLOR_LASER][__G] = str_to_num(sHabs[24]);
		g_Options_Color[id][COLOR_LASER][__B] = str_to_num(sHabs[25]);
		
		SQL_ReadResult(sqlQuery, 21, sInfoDB, 511); // weapon
		parse(sInfoDB, sHabs[0], 3, sHabs[1], 3, sHabs[2], 3, sHabs[3], 3);
		
		g_WeaponAutoBuy[id] = str_to_num(sHabs[0]);
		g_WeaponPrimary_Selection[id] = str_to_num(sHabs[1]);
		g_WeaponSecondary_Selection[id] = str_to_num(sHabs[2]);
		g_WeaponTerciary_Selection[id] = str_to_num(sHabs[3]);
		
		SQL_ReadResult(sqlQuery, 22, sInfoDB, 511); // items_extras
		parse(sInfoDB, sItemExtraCost[EXTRA_NIGHTVISION], 10, sItemExtraCount[EXTRA_NIGHTVISION], 10, sItemExtraCost[EXTRA_LONGJUMP_H], 10, sItemExtraCount[EXTRA_LONGJUMP_H], 10,
		sItemExtraCost[EXTRA_BOMBA_ANIQUILACION], 10, sItemExtraCount[EXTRA_BOMBA_ANIQUILACION], 10, sItemExtraCost[EXTRA_BALAS_INFINITAS], 10, sItemExtraCount[EXTRA_BALAS_INFINITAS], 10,
		sItemExtraCost[EXTRA_BOMBA_ANTIDOTO], 10, sItemExtraCount[EXTRA_BOMBA_ANTIDOTO], 10, sItemExtraCost[EXTRA_INMUNIDAD], 10, sItemExtraCount[EXTRA_INMUNIDAD], 10, sItemExtraCost[EXTRA_ANTIDOTO], 10, sItemExtraCount[EXTRA_ANTIDOTO], 10,
		sItemExtraCost[EXTRA_FURIA], 10, sItemExtraCount[EXTRA_FURIA], 10, sItemExtraCost[EXTRA_BOMBA_INFECCION], 10, sItemExtraCount[EXTRA_BOMBA_INFECCION], 10, sItemExtraCost[EXTRA_LONGJUMP_Z], 10, sItemExtraCount[EXTRA_LONGJUMP_Z], 10,
		sItemExtraCost[EXTRA_PETRIFICACION], 10, sItemExtraCount[EXTRA_PETRIFICACION], 10);
		
		for(i = 0; i < extraItemsId; ++i) {
			g_ItemExtra_Cost[id][i] = str_to_num(sItemExtraCost[i]);
			g_ItemExtra_Count[id][i] = str_to_num(sItemExtraCount[i]);
		}
		
		g_HatId[id] = g_HatNext[id] = SQL_ReadResult(sqlQuery, 23);
		g_Mastery[id] = SQL_ReadResult(sqlQuery, 24);
		
		i = 24;
		
		// i+1 = id
		// i+2 = acc_id
		// i+3 = pj_id
		
		SQL_ReadResult(sqlQuery, (i+4), Float:g_Stats_Damage[id][0]);
		SQL_ReadResult(sqlQuery, (i+5), Float:g_Stats_Damage[id][1]);
		
		g_Stats[id][STAT_DONE][STAT_INFECTIONS] = SQL_ReadResult(sqlQuery, (i+6));
		g_Stats[id][STAT_TAKEN][STAT_INFECTIONS] = SQL_ReadResult(sqlQuery, (i+7));
		g_Stats[id][STAT_DONE][STAT_ZOMBIES] = SQL_ReadResult(sqlQuery, (i+8));
		g_Stats[id][STAT_TAKEN][STAT_ZOMBIES] = SQL_ReadResult(sqlQuery, (i+9));
		g_Stats[id][STAT_DONE][STAT_HUMANS] = SQL_ReadResult(sqlQuery, (i+10));
		g_Stats[id][STAT_TAKEN][STAT_HUMANS] = SQL_ReadResult(sqlQuery, (i+11));
		g_Stats[id][STAT_DONE][STAT_HEADSHOTS] = SQL_ReadResult(sqlQuery, (i+12));
		g_Stats[id][STAT_TAKEN][STAT_HEADSHOTS] = SQL_ReadResult(sqlQuery, (i+13));
		g_Stats[id][STAT_DONE][STAT_ZOMBIES_HEADSHOTS] = SQL_ReadResult(sqlQuery, (i+14));
		g_Stats[id][STAT_TAKEN][STAT_ZOMBIES_HEADSHOTS] = SQL_ReadResult(sqlQuery, (i+15));
		g_Stats[id][STAT_DONE][STAT_ZOMBIES_KNIFE] = SQL_ReadResult(sqlQuery, (i+16));
		g_Stats[id][STAT_TAKEN][STAT_ZOMBIES_KNIFE] = SQL_ReadResult(sqlQuery, (i+17));
		g_Stats[id][STAT_DONE][STAT_COMBO] = SQL_ReadResult(sqlQuery, (i+18));
		g_Stats[id][STAT_DONE][STAT_COMBO_MAX] = SQL_ReadResult(sqlQuery, (i+19));
		g_Stats[id][STAT_DONE][STAT_ARMOR] = SQL_ReadResult(sqlQuery, (i+20));
		g_Stats[id][STAT_TAKEN][STAT_ARMOR] = SQL_ReadResult(sqlQuery, (i+21));
		g_Stats[id][STAT_DONE][STAT_ACHIEVEMENTS] = SQL_ReadResult(sqlQuery, (i+22));
		g_Stats[id][STAT_DONE][STAT_CHALLENGES] = SQL_ReadResult(sqlQuery, (i+23));
		g_Stats[id][STAT_DONE][STAT_NEMESIS_LEGEND_KILLS] = SQL_ReadResult(sqlQuery, (i+24));
		g_Stats[id][STAT_DONE][STAT_NEMESIS] = SQL_ReadResult(sqlQuery, (i+25));
		g_Stats[id][STAT_TAKEN][STAT_NEMESIS] = SQL_ReadResult(sqlQuery, (i+26));
		g_Stats[id][STAT_DONE][STAT_NEMESIS_COUNT] = SQL_ReadResult(sqlQuery, (i+27));
		g_Stats[id][STAT_DONE][STAT_SURVIVOR] = SQL_ReadResult(sqlQuery, (i+28));
		g_Stats[id][STAT_TAKEN][STAT_SURVIVOR] = SQL_ReadResult(sqlQuery, (i+29));
		g_Stats[id][STAT_DONE][STAT_SURVIVOR_COUNT] = SQL_ReadResult(sqlQuery, (i+30));
		g_Stats[id][STAT_DONE][STAT_WESKER] = SQL_ReadResult(sqlQuery, (i+31));
		g_Stats[id][STAT_TAKEN][STAT_WESKER] = SQL_ReadResult(sqlQuery, (i+32));
		g_Stats[id][STAT_DONE][STAT_WESKER_COUNT] = SQL_ReadResult(sqlQuery, (i+33));
		g_Stats[id][STAT_DONE][STAT_JASON] = SQL_ReadResult(sqlQuery, (i+34));
		g_Stats[id][STAT_TAKEN][STAT_JASON] = SQL_ReadResult(sqlQuery, (i+35));
		g_Stats[id][STAT_DONE][STAT_JASON_COUNT] = SQL_ReadResult(sqlQuery, (i+36));
		g_Stats[id][STAT_DONE][STAT_FIRST_ZOMBIE_COUNT] = SQL_ReadResult(sqlQuery, (i+37));
		g_Stats[id][STAT_DONE][STAT_TROLL] = SQL_ReadResult(sqlQuery, (i+38));
		g_Stats[id][STAT_TAKEN][STAT_TROLL] = SQL_ReadResult(sqlQuery, (i+39));
		g_Stats[id][STAT_DONE][STAT_TROLL_COUNT] = SQL_ReadResult(sqlQuery, (i+40));
		g_Stats[id][STAT_DONE][STAT_MEGA_NEMESIS] = SQL_ReadResult(sqlQuery, (i+41));
		g_Stats[id][STAT_TAKEN][STAT_MEGA_NEMESIS] = SQL_ReadResult(sqlQuery, (i+42));
		g_Stats[id][STAT_DONE][STAT_MEGA_NEMESIS_COUNT] = SQL_ReadResult(sqlQuery, (i+43));
		g_Stats[id][STAT_DONE][STAT_ASSASSIN] = SQL_ReadResult(sqlQuery, (i+44));
		g_Stats[id][STAT_TAKEN][STAT_ASSASSIN] = SQL_ReadResult(sqlQuery, (i+45));
		g_Stats[id][STAT_DONE][STAT_ASSASSIN_COUNT] = SQL_ReadResult(sqlQuery, (i+46));
		g_Stats[id][STAT_DONE][STAT_ALIEN] = SQL_ReadResult(sqlQuery, (i+47));
		g_Stats[id][STAT_TAKEN][STAT_ALIEN] = SQL_ReadResult(sqlQuery, (i+48));
		g_Stats[id][STAT_DONE][STAT_ALIEN_COUNT] = SQL_ReadResult(sqlQuery, (i+49));
		g_Stats[id][STAT_DONE][STAT_PREDATOR] = SQL_ReadResult(sqlQuery, (i+50));
		g_Stats[id][STAT_TAKEN][STAT_PREDATOR] = SQL_ReadResult(sqlQuery, (i+51));
		g_Stats[id][STAT_DONE][STAT_PREDATOR_COUNT] = SQL_ReadResult(sqlQuery, (i+52));
		
		SQL_FreeHandle(sqlQuery);
		
		addDot(g_AmmoPacks[id], g_AmmoPacksHud[id], 31);
		
		checkAPsEquation(id);
		
		if(g_Hab[id][CLASS_ZOMBIE][HAB_Z_RESPAWN]) {
			g_RandomRespawn[id] = (g_Hab[id][CLASS_ZOMBIE][HAB_Z_RESPAWN] * __HABILITIES[CLASS_ZOMBIE][HAB_Z_RESPAWN][habValue]);
		}
		
		if(g_Hab[id][CLASS_SPECIAL][HAB_SPECIAL_RESPAWN]) {
			g_RandomRespawn[id] += __HABILITIES[CLASS_SPECIAL][HAB_SPECIAL_RESPAWN][habValue];
		}
		
		if(g_Hab[id][CLASS_LEGENDARIAS][HAB_LEGENDARY_RESPAWN]) {
			g_RandomRespawn[id] += __HABILITIES[CLASS_LEGENDARIAS][HAB_LEGENDARY_RESPAWN][habValue];
		}
		
		if(g_Hab[id][CLASS_LEGADO][HAB_LEGADO_RESPAWN]) {
			g_RandomRespawn[id] += __HABILITIES[CLASS_LEGADO][HAB_LEGADO_RESPAWN][habValue];
		}
		
		if(g_Hab[id][CLASS_LEGADO][HAB_LEGADO_MULT_APS]) {
			g_Legado_MultAps[id] = (g_Hab[id][CLASS_LEGADO][HAB_LEGADO_MULT_APS] * 0.1);
		}
		
		if(g_Hab[id][CLASS_LEGENDARIAS][HAB_LEGENDARY_INDUCCION]) {
			g_Induccion[id] = (g_Hab[id][CLASS_LEGENDARIAS][HAB_LEGENDARY_INDUCCION] * __HABILITIES[CLASS_LEGENDARIAS][HAB_LEGENDARY_INDUCCION][habValue]);
		}
		
		if(g_Hab[id][CLASS_LEGADO][HAB_LEGADO_RESISTENCIA]) {
			g_DamageReduce[id] = float(g_Hab[id][CLASS_LEGADO][HAB_LEGADO_RESISTENCIA] * __HABILITIES[CLASS_LEGADO][HAB_LEGADO_RESISTENCIA][habValue]);
		}
		
		if(g_Hab[id][CLASS_SPECIAL][HAB_SPECIAL_VIGOR]) {
			g_VigorChance[id] = (g_Hab[id][CLASS_SPECIAL][HAB_SPECIAL_VIGOR] *__HABILITIES[CLASS_SPECIAL][HAB_SPECIAL_VIGOR][habValue]);
		}
		
		if(get_user_flags(id) & ADMIN_RESERVATION) {
			g_ExtraMultAps[id] += 1.0;
			g_MultPoints[id] = 2;
		}
		
		g_ExtraMultAps[id] += __HATS[g_HatId[id]][hatUpgrade5] + g_MapExtraAPs;
		
		updateComboNeeded(id);
		
		iPlayedTimePerDaySec = float((iCDate_Unix - get_systime())) / float(iTime);
		
		while(iTime >= 86400) {
			iTime -= 86400;
			
			++g_PlayedTime[id][TIME_DAY];
		}
		
		while(iTime >= 3600) {
			iTime -= 3600;
			
			++g_PlayedTime[id][TIME_HOUR];
		}
		
		g_PlayedTime_PerDay[id] = (iPlayedTimePerDaySec / 60.0) / 60.0;
		
		for(i = 0; i < sizeof(ARMAS_PRIMARIAS); ++i) {
			if(g_Reset[id] <= ARMAS_PRIMARIAS[i][weaponReset]) {
				if(g_Level[id] < ARMAS_PRIMARIAS[i][weaponLevelReq]) {
					g_ProxPrimaryWeapon[id] = ARMAS_PRIMARIAS[i][weaponCSW];
					
					break;
				}
			}
		}
		
		for(i = 0; i < sizeof(ARMAS_SECUNDARIAS); ++i) {
			if(g_Reset[id] <= ARMAS_SECUNDARIAS[i][weaponReset]) {
				if(g_Level[id] < ARMAS_SECUNDARIAS[i][weaponLevelReq]) {
					g_ProxSecondaryWeapon[id] = ARMAS_SECUNDARIAS[i][weaponCSW];
					
					break;
				}
			}
		}
		
		
		// CLAN
		
		if(iClan) {
			static j;
			
			// Chequeamos si ya hay un usuario dentro del servidor perteneciente al mismo clan, si es así, le asignamos el mismo ID sin necesidad de hacer la query.
			for(i = 1; i <= g_MaxUsers; ++i) {
				if(!g_IsConnected[i]) {
					continue;
				}
				
				if(g_ClanId[i] != iClan) {
					continue;
				}
				
				g_ClanId[id] = g_ClanId[i];
				g_InClan[id] = g_InClan[i];
				
				for(j = 0; j < 16; ++j) {
					if(g_AccountId[id] == g_ClanMemberInfo[g_InClan[id]][j][memberId] && g_AccountPJs[id][g_UserSelected[id]] == g_ClanMemberInfo[g_InClan[id]][j][memberPj]) {
						g_ClanInPos[id] = j;
						
						g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberLastTimeD] = 0;
						g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberLastTimeH] = 0;
						g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberLastTimeM] = 0;
						
						break;
					}
				}
				
				++g_ClanOnline[g_InClan[id]];
				
				i = 0;
				
				break;
			}
			
			if(i) {
				new sFix1[3];
				new sFix2[3];
				new sFix3[5];
				
				formatex(sFix1, 2, "pa");
				formatex(sFix2, 2, "pe");
				formatex(sFix3, 4, "pi");
				
				replace(sFix1, 2, "pa", "%d");
				replace(sFix2, 2, "pe", "%m");
				replace(sFix3, 4, "pi", "%Y");
				
				sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT name, tulio, DATE_FORMAT(FROM_UNIXTIME(created_date), ^"%s-%s-%s^"), victorias, victorias_consec, victorias_consec_history, campeon_actual FROM zp6_clanes WHERE id='%d' LIMIT 1;", sFix1, sFix2, sFix3, iClan);
				if(!SQL_Execute(sqlQuery)) {
					executeQuery(id, sqlQuery, 900);
				} else if(SQL_NumResults(sqlQuery)) {
					g_ClanId[id] = iClan;
					g_InClan[id] = clanFindId();
					
					for(i = 0; i < 16; ++i) { // Borramos todas las estadísticas previas que contengan las variables!
						for(j = 0; j < structClanMemberInfo; ++j) {
							g_ClanMemberInfo[g_InClan[id]][i][j] = 0;
						}
						
						g_ClanMemberInfo[g_InClan[id]][i][memberTimePlayed][0] = EOS;
					}
					
					SQL_ReadResult(sqlQuery, 0, g_ClanName[g_InClan[id]], 31);
					g_ClanTulio[g_InClan[id]] = SQL_ReadResult(sqlQuery, 1);
					
					SQL_ReadResult(sqlQuery, 2, g_ClanInfoCreateDate[g_InClan[id]], 31);
					
					g_ClanInfo[g_InClan[id]][clanVictory] = SQL_ReadResult(sqlQuery, 3);
					g_ClanInfo[g_InClan[id]][clanVictoryConsec] = SQL_ReadResult(sqlQuery, 4);
					g_ClanInfo[g_InClan[id]][clanVictoryConsecHistory] = SQL_ReadResult(sqlQuery, 5);
					g_ClanInfo[g_InClan[id]][clanChampion] = SQL_ReadResult(sqlQuery, 6);
					
					g_ClanRank[g_InClan[id]] = 0;
					
					g_ClanOnline[g_InClan[id]] = 1;
					
					SQL_FreeHandle(sqlQuery);
				} else {
					SQL_FreeHandle(sqlQuery);
				}
				
				sqlQuery = SQL_PrepareQuery(g_SqlConnection, "	SELECT \
																	zp6_clanes_miembros.acc_id,zp6_clanes_miembros.pj_id,zp6_clanes_miembros.name,zp6_clanes_miembros.range, \
																	zp6_pjs.reset,zp6_pjs.level,zp6_clanes_miembros.tulio,zp6_clanes_miembros.time_p,zp6_clanes_miembros.last_time,zp6_clanes_miembros.since \
																FROM \
																	zp6_clanes_miembros \
																LEFT JOIN \
																	zp6_pjs \
																ON \
																	zp6_clanes_miembros.acc_id=zp6_pjs.acc_id \
																AND \
																	zp6_clanes_miembros.pj_id=zp6_pjs.pj_id \
																WHERE \
																	clan_id='%d' \
																AND \
																	activo='1' \
																LIMIT 16;",
				iClan);
				
				if(!SQL_Execute(sqlQuery)) {
					executeQuery(id, sqlQuery, 1000);
				} else if(SQL_NumResults(sqlQuery)) {
					static iTimePlayed_Seconds;
					static iLastSee;
					static iSince;
					static iActualUnix;
					static iMinutes;
					static iHours;
					
					iActualUnix = get_systime();
					
					g_ClanMembers[g_InClan[id]] = 0;
					
					while(SQL_MoreResults(sqlQuery)) {
						g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberId] = SQL_ReadResult(sqlQuery, 0);
						g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberPj] = SQL_ReadResult(sqlQuery, 1);
						SQL_ReadResult(sqlQuery, 2, g_ClanMemberName[g_InClan[id]][g_ClanMembers[g_InClan[id]]], 31);
						g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberRange] = SQL_ReadResult(sqlQuery, 3);
						g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberReset] = SQL_ReadResult(sqlQuery, 4);
						g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberLevel] = SQL_ReadResult(sqlQuery, 5);
						g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberTulio] = SQL_ReadResult(sqlQuery, 6);
						iTimePlayed_Seconds = SQL_ReadResult(sqlQuery, 7);
						iLastSee = iActualUnix - SQL_ReadResult(sqlQuery, 8);
						iSince = iActualUnix - SQL_ReadResult(sqlQuery, 9);
						
						// Tiempo jugado
						iMinutes = (iTimePlayed_Seconds / 60);
						iHours = 0;
						
						if(iMinutes >= 60) {
							while(iMinutes >= 60) {
								++iHours;
								
								iMinutes -= 60;
							}
						}
						
						if(iHours) {
							formatex(g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberTimePlayed], 31, "%d hora%s %d minuto%s", iHours, (iHours != 1) ? "s" : "", iMinutes, (iMinutes != 1) ? "s" : "");
						} else {
							formatex(g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberTimePlayed], 31, "%d minuto%s", iMinutes, (iMinutes != 1) ? "s" : "");
						}
						
						// Última vez visto
						iMinutes = (iLastSee / 60);
						
						if(iMinutes >= 60) {
							while(iMinutes >= 60) {
								++g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberLastTimeH];
								
								if(g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberLastTimeH] >= 24) {
									++g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberLastTimeD];
									
									g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberLastTimeH] -= 24;
								}
								
								iMinutes -= 60;
							}
						} else {
							g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberLastTimeD] = 0;
							g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberLastTimeH] = 0;
							g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberLastTimeM] = iMinutes;
						}
						
						// Miembro desde
						iMinutes = (iSince / 60);
						
						if(iMinutes >= 60) {
							while(iMinutes >= 60) {
								++g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberSinceH];
								
								if(g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberSinceH] >= 24) {
									++g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberSinceD];
									
									g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberSinceH] -= 24;
								}
								
								iMinutes -= 60;
							}
						} else {
							g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberSinceD] = 0;
							g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberSinceH] = 0;
							g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberSinceM] = iMinutes;
						}
						
						if(g_AccountId[id] == g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberId] && g_AccountPJs[id][g_UserSelected[id]] == g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberPj]) {
							g_ClanInPos[id] = g_ClanMembers[g_InClan[id]];
							
							g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberLastTimeD] = 0;
							g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberLastTimeH] = 0;
							g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberLastTimeM] = 0;
						}
						
						++g_ClanMembers[g_InClan[id]];
						
						SQL_NextRow(sqlQuery);
					}
					
					SQL_FreeHandle(sqlQuery);
				} else {
					SQL_FreeHandle(sqlQuery);
				}
			}
		}
		
		// Estadisticas de las armas
		
		g_WeaponModel[id][CSW_KNIFE] = 1; // Los puños son el 1 y lo pones por si no está cargado en zp6_weapons
		
		sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT * FROM zp6_weapons WHERE acc_id='%d' AND pj_id='%d';", g_AccountId[id], (pj+1));
		
		if(!SQL_Execute(sqlQuery)) {
			executeQuery(id, sqlQuery, 1100);
		} else if(SQL_NumResults(sqlQuery)) {
			static iWeapon;
			static iSeconds;
			static iNot;
			
			while(SQL_MoreResults(sqlQuery)) {
				iWeapon = SQL_ReadResult(sqlQuery, 3);
				// 4 = weapon_name
				g_WeaponData[id][iWeapon][weaponLevel] = SQL_ReadResult(sqlQuery, 5);
				g_WeaponData[id][iWeapon][weaponKills] = SQL_ReadResult(sqlQuery, 6);
				SQL_ReadResult(sqlQuery, 7, Float:g_WeaponData[id][iWeapon][weaponDamage]);
				g_WeaponData[id][iWeapon][weaponTimePlayed] = SQL_ReadResult(sqlQuery, 8);
				
				g_WeaponSkill[id][iWeapon][SKILL_POINTS] = SQL_ReadResult(sqlQuery, 9);
				g_WeaponSkill[id][iWeapon][SKILL_DAMAGE] = SQL_ReadResult(sqlQuery, 10);
				g_WeaponSkill[id][iWeapon][SKILL_SPEED] = SQL_ReadResult(sqlQuery, 11);
				g_WeaponSkill[id][iWeapon][SKILL_RECOIL] = SQL_ReadResult(sqlQuery, 12);
				g_WeaponSkill[id][iWeapon][SKILL_MAXCLIP] = SQL_ReadResult(sqlQuery, 13);
				
				iNot = 0;				
				while(!iNot) { // infinito hasta que llegue al break
					for(i = 0; i < 8; ++i) {
						if(g_WeaponData[id][iWeapon][weaponLevel] >= g_WEAPONS_Models[iWeapon][i][weaponModelLevel]) {
							g_WeaponModel[id][iWeapon] = i+1;
							
							continue;
						}
						
						break;
					}
					
					break;
				}
				
				iSeconds = g_WeaponData[id][iWeapon][weaponTimePlayed];
				
				while(iSeconds >= 86400) {
					iNot = 1;
					iSeconds -= 86400;
					
					++g_WeaponData[id][iWeapon][weaponTimeDays];
				}
				
				while(iSeconds >= 3600) {
					iSeconds -= 3600;
					
					++g_WeaponData[id][iWeapon][weaponTimeHours];
				}
				
				if(!iNot) {
					while(iSeconds >= 60) {
						iSeconds -= 60;
						
						++g_WeaponData[id][iWeapon][weaponTimeMinutes];
					}
				}
				
				SQL_NextRow(sqlQuery);
			}
			
			SQL_FreeHandle(sqlQuery);
		} else {
			SQL_FreeHandle(sqlQuery);
		}
		
		
		// Logros y Desafíos
		
		if(g_Stats[id][STAT_DONE][STAT_ACHIEVEMENTS]) {
			sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT achievement_id, challenge_lvl, achievement_date FROM zp6_achievements WHERE acc_id='%d' AND pj_id='%d';", g_AccountId[id], (pj+1));
			
			if(!SQL_Execute(sqlQuery)) {
				executeQuery(id, sqlQuery, 1200);
			} else if(SQL_NumResults(sqlQuery)) {
				static iAchievement;
				static iChallenge;
				
				while(SQL_MoreResults(sqlQuery)) {
					iAchievement = SQL_ReadResult(sqlQuery, 0);
					iChallenge = SQL_ReadResult(sqlQuery, 1);
					
					if(!iChallenge) {
						g_Achievement[id][iAchievement] = 1;
						SQL_ReadResult(sqlQuery, 2, g_AchievementUnlocked[id][iAchievement], 31);
					} else {
						g_Challenge[id][iAchievement] = iChallenge;
					}
					
					SQL_NextRow(sqlQuery);
				}
				
				SQL_FreeHandle(sqlQuery);
			} else {
				SQL_FreeHandle(sqlQuery);
			}
		}
		
		
		// Hats
		
		sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT hat_id FROM zp6_hats WHERE acc_id='%d' AND pj_id='%d';", g_AccountId[id], (pj+1));
		
		if(!SQL_Execute(sqlQuery)) {
			executeQuery(id, sqlQuery, 4000);
		} else if(SQL_NumResults(sqlQuery)) {
			while(SQL_MoreResults(sqlQuery)) {
				g_Hat[id][SQL_ReadResult(sqlQuery, 0)] = 1;
				
				SQL_NextRow(sqlQuery);
			}
			
			SQL_FreeHandle(sqlQuery);
		} else {
			SQL_FreeHandle(sqlQuery);
		}
		
		g_AccountPJ_Logged[id] = 1; // Lo ponemos al final de todo, ya que si alguna query falla, lo desconectará, y no queremos que guarde la mitad de los datos mal!
		
		if(g_RegisterDate[id] < 1430693225) { // 1430693225 = 03-05-2015 19:47:05
			setAchievement(id, BETA_TESTER);
			
			if(iTime2 >= 18000) {
				setAchievement(id, BETA_TESTER_AVANZADO);
				// setAchievement__First(id, PRIMERO_BETA_TESTER_AVANZADO);
			}
		}
		
		switch(g_PlayedTime[id][TIME_DAY]) {
			case 7: {
				setAchievement(id, ESTOY_MUY_SOLO);
			} case 15: {
				setAchievement(id, FOREVER_ALONE);
				giveHat(id, HAT_ZIPPY);
			} case 30: {
				setAchievement(id, CREO_QUE_TENGO_UN_PROBLEMA);
			} case 50: {
				setAchievement(id, SOLO_EL_ZP_ME_ENTIENDE);
			}
		}
		
		if(g_AccountId[id] % 2) {
			setAchievement(id, CUENTA_IMPAR);
		} else {
			setAchievement(id, CUENTA_PAR);
		}
		
		if(get_user_flags(id) & ADMIN_RESERVATION) {
			setAchievement(id, SOY_DORADO);
			giveHat(id, HAT_PREMIUM);
		}
		
		if(g_Stats_Damage[id][0] >= 1000) { // Dividido 100 los daños
			setAchievement(id, MIRA_MI_DANIO);
			if(g_Stats_Damage[id][0] >= 5000) {
				setAchievement(id, MAS_Y_MAS_DANIO);
				if(g_Stats_Damage[id][0] >= 10000) {
					setAchievement(id, LLEGUE_AL_MILLON);
					if(g_Stats_Damage[id][0] >= 50000) {
						if(g_Stats_Damage[id][0] >= 250000) {
							if(g_Stats_Damage[id][0] >= 500000) {
								if(g_Stats_Damage[id][0] >= 1000000) {
									if(g_Stats_Damage[id][0] >= 5000000) {
										if(g_Stats_Damage[id][0] >= 10000000) {
											if(g_Stats_Damage[id][0] >= 50000000) {
												if(g_Stats_Damage[id][0] >= 200000000) {
													if(g_Stats_Damage[id][0] >= 500000000) {
														if(g_Stats_Damage[id][0] >= 1000000000) {
															if(g_Stats_Damage[id][0] >= 2100000000) {
																setAchievement(id, NO_SE_LEER_ESTE_NUMERO);
															} else {
																setAchievement(id, ME_ABURRO);
															}
														} else {
															setAchievement(id, SE_ME_BUGUEO_EL_DANIO);
														}
													} else {
														setAchievement(id, MUCHOS_NUMEROS);
													}
												} else {
													setAchievement(id, MI_DANIO_ES_NUCLEAR);
												}
											} else {
												setAchievement(id, MI_DANIO_ES_CATASTROFICO);
											}
										} else {
											setAchievement(id, YA_PERDI_LA_CUENTA);
										}
									} else {
										setAchievement(id, CONTADOR_DE_DANIOS);
									}
								} else {
									setAchievement(id, VAMOS_POR_LOS_50_MILLONES);
								}
							} else {
								setAchievement(id, MI_DANIO_CRECE_Y_CRECE);
							}
						} else {
							setAchievement(id, MI_DANIO_CRECE);
						}
					}
				}
			}
		}
		
		if(g_Stats[id][STAT_DONE][STAT_HEADSHOTS] < 10000000) {
			if(g_Stats[id][STAT_DONE][STAT_HEADSHOTS] < 5000000) {
				if(g_Stats[id][STAT_DONE][STAT_HEADSHOTS] < 1000000) {
					if(g_Stats[id][STAT_DONE][STAT_HEADSHOTS] < 500000) {
						if(g_Stats[id][STAT_DONE][STAT_HEADSHOTS] < 300000) {
							if(g_Stats[id][STAT_DONE][STAT_HEADSHOTS] < 150000) {
								if(g_Stats[id][STAT_DONE][STAT_HEADSHOTS] < 50000) {
									if(g_Stats[id][STAT_DONE][STAT_HEADSHOTS] < 15000) {
										if(g_Stats[id][STAT_DONE][STAT_HEADSHOTS] >= 5000) {
											setAchievement(id, CABEZITA);
										}
									} else {
										setAchievement(id, A_PLENO);
									}
								} else {
									setAchievement(id, ROMPIENDO_CABEZAS);
								}
							} else {
								setAchievement(id, ABRIENDO_CEREBROS);
							}
						} else {
							setAchievement(id, PERFORANDO);
						}
					} else {
						setAchievement(id, DESCOCANDO);
					}
				} else {
					setAchievement(id, ROMPECRANEOS);
				}
			} else {
				setAchievement(id, DUCK_HUNT);
			}
		} else {
			setAchievement(id, AIMBOT);
		}
		
		if(g_Stats[id][STAT_DONE][STAT_ARMOR] < 100000) {
			if(g_Stats[id][STAT_DONE][STAT_ARMOR] < 60000) {
				if(g_Stats[id][STAT_DONE][STAT_ARMOR] < 30000) {
					if(g_Stats[id][STAT_DONE][STAT_ARMOR] < 5000) {
						if(g_Stats[id][STAT_DONE][STAT_ARMOR] < 2000) {
							if(g_Stats[id][STAT_DONE][STAT_ARMOR] >= 500) {
								setAchievement(id, SACANDO_PROTECCION);
							}
						} else {
							setAchievement(id, ESO_NO_TE_SIRVE_DE_NADA);
						}
					} else {
						setAchievement(id, NO_ES_UN_PROBLEMA_PARA_MI);
					}
				} else {
					setAchievement(id, SIN_DEFENSAS);
				}
			} else {
				setAchievement(id, DESGARRANDO_CHALECO);
			}
		} else {
			setAchievement(id, TOTALMENTE_INDEFENSO);
		}
		
		event__Health(id);
		
		g_AllowChangeTeam[id] = 1;
		{
			set_pdata_int(id, 125, (get_pdata_int(id, 125, OFFSET_LINUX) & ~(1<<8)), OFFSET_LINUX);
			
			static iTeamMsgBlock;
			static iTeamMsgVGUIBlock;
			static iRestore;
			static iVGUI;
			
			iRestore = get_pdata_int(id, 510);
			iVGUI = iRestore & (1<<0);
			
			if(iVGUI) {
				set_pdata_int(id, 510, iRestore & ~(1<<0));
			}
			
			iTeamMsgBlock = get_msg_block(g_Message_ShowMenu);
			iTeamMsgVGUIBlock = get_msg_block(g_Message_VGUIMenu);
			
			set_msg_block(g_Message_ShowMenu, BLOCK_ONCE);
			set_msg_block(g_Message_VGUIMenu, BLOCK_ONCE);
			
			engclient_cmd(id, "jointeam", "5");
			engclient_cmd(id, "joinclass", "5");
			
			set_msg_block(g_Message_ShowMenu, iTeamMsgBlock);
			set_msg_block(g_Message_VGUIMenu, iTeamMsgVGUIBlock);
			
			if(iVGUI) {
				set_pdata_int(id, 510, iRestore);
			}
		}
		g_AllowChangeTeam[id] = 0;
		
		new j = 0;
		
		for(i = 1; i <= g_MaxUsers; ++i) {
			if(g_IsConnected[i]) {
				++j;
			}
		}
		
		if(j > 6) {
			g_LogSay = 0;
			
			set_cvar_num("sv_voiceenable", 1);
		}
		
		set_task(0.5, "task__RespawnUser", id + TASK_SPAWN);
	} else {
		SQL_FreeHandle(sqlQuery);
	}
}

public saveInfo(const id, const disconnect) {
	if(!g_AccountPJ_Logged[id]) {
		return;
	}
	
	new Handle:sqlQuery;
	new i;
	new j;
	
	if(disconnect) {
		g_PlayedTime[id][TIME_SEC] = (get_systime() - g_SysTime_Connect[id]);
		
		// Visitas diarias
		new sDay[3];
		new iDay;
		
		get_time("%d", sDay, 2);
		iDay = str_to_num(sDay);
		
		if(g_DayNow[id] != iDay) {
			++g_VisitDays[id];
		}
		
		// Clan
		if(g_ClanId[id]) {
			sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE zp6_clanes_miembros SET time_p=`time_p`+'%d', last_time=UNIX_TIMESTAMP() WHERE clan_id='%d' AND acc_id='%d' AND pj_id='%d' AND activo='1';",
			g_PlayedTime[id][TIME_SEC], g_ClanId[id], g_AccountId[id], g_AccountPJs[id][g_UserSelected[id]]);
			
			if(!SQL_Execute(sqlQuery)) {
				executeQuery(id, sqlQuery, 1300);
			} else {
				SQL_FreeHandle(sqlQuery);
			}
			
			g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberLastTimeM] = 2;
			
			for(i = 0; i <= g_MaxUsers; ++i) {
				if(g_ClanInvitationsId[i][id]) {
					--g_ClanInvitations[i];
				}
				
				g_ClanInvitationsId[i][id] = 0;
			}
			
			--g_ClanOnline[g_InClan[id]];
			
			for(i = 1; i <= g_MaxUsers; ++i) {
				if(!g_IsConnected[i]) {
					continue;
				}
				
				if(g_ClanId[id] != g_ClanId[i]) {
					continue;
				}
				
				++j;
			}
			
			if(j == 1) { // Se desconectó el último miembro del clan, actualizar tulio!
				new Handle:sqlQuery;
				sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE zp6_clanes SET tulio='%d' WHERE id='%d'", g_ClanTulio[g_InClan[id]], g_ClanId[id]);
				if(!SQL_Execute(sqlQuery)) {
					executeQuery(id, sqlQuery, 1400);
				} else {
					SQL_FreeHandle(sqlQuery);
				}
			}
			
			j = g_ClanId[id];
			
			g_ClanId[id] = 0;
			g_InClan[id] = 0;
		}
		
		// Estadísticas de la cuenta
		new sIp[21];
		get_user_ip(id, sIp, 20, 1);
		
		// Tiene el mismo HID que el registrado en su cuenta!
		if(equal(g_DisconnectHID[id], g_AccountHID[id]) || (g_DisconnectHID[id][0] == '!' || equali(g_DisconnectHID[id], "no HID present, try again.") || equali(g_DisconnectHID[id], "") || containi(g_DisconnectHID[id], " ") != -1)) {
			sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE zp6_accounts SET ip=INET_ATON(^"%s^"), last_connect=UNIX_TIMESTAMP(), visit_days='%d' WHERE id=%d;", sIp, g_VisitDays[id], g_AccountId[id]);
			
			if(!SQL_Execute(sqlQuery)) {
				executeQuery(id, sqlQuery, 1500);
			} else {
				SQL_FreeHandle(sqlQuery);
			}
		} else { // Tiene diferente HID del registrado, cambiarlo por ese y crear un log reportando que cambió
			sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE zp6_accounts SET hid=^"%s^", ip=INET_ATON(^"%s^"), last_connect=UNIX_TIMESTAMP(), visit_days='%d' WHERE id='%d';", g_DisconnectHID[id], sIp, g_VisitDays[id], g_AccountId[id]);
			if(!SQL_Execute(sqlQuery)) {
				executeQuery(id, sqlQuery, 1600);
			} else {
				SQL_FreeHandle(sqlQuery);
			}
			
			sqlQuery = SQL_PrepareQuery(g_SqlConnection, "INSERT INTO zp6_logs (`acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES ('%d', '%d', ^"%s^", ^"%s^", ^"%s^", UNIX_TIMESTAMP());", g_AccountId[id], g_AccountPJs[id][g_UserSelected[id]],
			g_UserName[id], g_AccountHID[id], g_DisconnectHID[id]);
			
			if(!SQL_Execute(sqlQuery)) {
				executeQuery(id, sqlQuery, 1700);
			} else {
				SQL_FreeHandle(sqlQuery);
			}
		}
	} else {
		g_PlayedTime[id][TIME_SEC] = (get_systime() - g_SysTime_Connect2[id]);
		
		g_SysTime_Connect[id] = get_systime();
		g_SysTime_Connect2[id] = get_systime();
	}
	
	// Estadísticas del personaje
	static sPoints[64];
	static sPointsLost[64];
	static sHabs[512];
	static sOptions[512];
	static sWeapons[64];
	static sItemsExtras[512];
	static iLen;
	
	iLen = 0;
	
	formatex(sPoints, 63, "%d %d %d %d %d", g_Points[id][P_HUMAN], g_Points[id][P_ZOMBIE], g_Points[id][P_UUT], g_Points[id][P_LEGADO], g_Points[id][P_DIAMONDS]);
	formatex(sPointsLost, 63, "%d %d %d %d %d", g_PointsLost[id][P_HUMAN], g_PointsLost[id][P_ZOMBIE], g_PointsLost[id][P_UUT], g_PointsLost[id][P_LEGADO], g_PointsLost[id][P_DIAMONDS]);
	
	formatex(sHabs, 511, "%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d",
	g_Hab[id][CLASS_HUMAN][HAB_HEALTH], g_Hab[id][CLASS_HUMAN][HAB_SPEED], g_Hab[id][CLASS_HUMAN][HAB_GRAVITY], g_Hab[id][CLASS_HUMAN][HAB_DAMAGE], g_Hab[id][CLASS_HUMAN][HAB_H_ARMOR], g_Hab[id][CLASS_SPECIAL][HAB_SPECIAL_FLARE],
	g_Hab[id][CLASS_ZOMBIE][HAB_HEALTH], g_Hab[id][CLASS_ZOMBIE][HAB_SPEED], g_Hab[id][CLASS_ZOMBIE][HAB_GRAVITY], g_Hab[id][CLASS_ZOMBIE][HAB_DAMAGE], g_Hab[id][CLASS_ZOMBIE][HAB_Z_COMBO], g_Hab[id][CLASS_ZOMBIE][HAB_Z_RESPAWN],
	g_Hab[id][CLASS_SURVIVOR][HAB_HEALTH], g_Hab[id][CLASS_SURVIVOR][HAB_S_WEAPON], g_Hab[id][CLASS_SURVIVOR][HAB_S_GRENADE], g_Hab[id][CLASS_SURVIVOR][HAB_S_IMMUNITY],
	g_Hab[id][CLASS_NEMESIS][HAB_HEALTH], g_Hab[id][CLASS_NEMESIS][HAB_N_DAMAGE],
	g_Hab[id][CLASS_WESKER][HAB_W_SUPER_LASER], g_Hab[id][CLASS_WESKER][HAB_W_COMBO],
	g_Hab[id][CLASS_JASON][HAB_J_TELEPORT], g_Hab[id][CLASS_JASON][HAB_J_COMBO],
	g_Hab[id][CLASS_SPECIAL][HAB_SPECIAL_BUBBLE_TIME], g_Hab[id][CLASS_SPECIAL][HAB_SPECIAL_RESPAWN], g_Hab[id][CLASS_SPECIAL][HAB_SPECIAL_VIGOR], g_Hab[id][CLASS_SPECIAL][HAB_SPECIAL_FURIA],
	g_Hab[id][CLASS_LEGENDARIAS][HAB_LEGENDARY_WEAPONS_LV15], g_Hab[id][CLASS_LEGENDARIAS][HAB_LEGENDARY_RESPAWN], g_Hab[id][CLASS_LEGENDARIAS][HAB_LEGENDARY_INDUCCION],
	g_Hab[id][CLASS_LEGADO][HAB_LEGADO_MULT_APS], g_Hab[id][CLASS_LEGADO][HAB_LEGADO_RESPAWN], g_Hab[id][CLASS_LEGADO][HAB_LEGADO_RESISTENCIA]);
	
	formatex(sOptions, 511, "%d %d %d %d %f %f %0.1f %d %d %f %f %0.1f %d %d %d %d %d %d %d %d %d %d %d %d %d %d", g_Options_Invis[id], g_Options_Color[id][COLOR_HUD][__R], g_Options_Color[id][COLOR_HUD][__G], g_Options_Color[id][COLOR_HUD][__B],
	g_Options_HUD_Position[id][HUD_GENERAL][0], g_Options_HUD_Position[id][HUD_GENERAL][1], g_Options_HUD_Position[id][HUD_GENERAL][2], g_Options_HUD_Effect[id][HUD_GENERAL], g_Options_HUD_Abrev[id][HUD_GENERAL],
	g_Options_HUD_Position[id][HUD_COMBO][0], g_Options_HUD_Position[id][HUD_COMBO][1], g_Options_HUD_Position[id][HUD_COMBO][2], g_Options_HUD_Effect[id][HUD_COMBO], g_Options_HUD_Abrev[id][HUD_COMBO],
	g_Options_Color[id][COLOR_NIGHTVISION][__R], g_Options_Color[id][COLOR_NIGHTVISION][__G], g_Options_Color[id][COLOR_NIGHTVISION][__B], g_Options_Color[id][COLOR_FLARE][__R], g_Options_Color[id][COLOR_FLARE][__G],
	g_Options_Color[id][COLOR_FLARE][__B], g_Options_Color[id][COLOR_BAZOOKA][__R], g_Options_Color[id][COLOR_BAZOOKA][__G], g_Options_Color[id][COLOR_BAZOOKA][__B], g_Options_Color[id][COLOR_LASER][__R],
	g_Options_Color[id][COLOR_LASER][__G], g_Options_Color[id][COLOR_LASER][__B]);
	
	formatex(sWeapons, 63, "%d %d %d %d", g_WeaponAutoBuy[id], g_WeaponPrimary_Selection[id], g_WeaponSecondary_Selection[id], g_WeaponTerciary_Selection[id]);
	
	for(i = 0; i < extraItemsId; ++i) {
		iLen += formatex(sItemsExtras[iLen], 511 - iLen, "%d %d ", g_ItemExtra_Cost[id][i], g_ItemExtra_Count[id][i]);
	}
	
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE zp6_pjs SET mult_aps='%f', time_played=`time_played`+%d, best_aps='%d', best_aps_date=UNIX_TIMESTAMP(), ammopacks='%d', level='%d', reset='%d', clan='%d',\
	hclass='%d', zclass='%d', surv='%d', nem='%d', points=^"%s^", points_lost=^"%s^", habilities=^"%s^", options=^"%s^", weapon=^"%s^", items_extras=^"%s^", hat_id='%d', mastery='%d' WHERE acc_id='%d' AND pj_id='%d';",
	g_MultAps[id], g_PlayedTime[id][TIME_SEC], g_BestAPs_History[id], g_AmmoPacks[id], g_Level[id], g_Reset[id], j,
	g_HumanClass[id], g_ZombieClass[id], g_Difficults[id][DIFF_SURVIVOR], g_Difficults[id][DIFF_NEMESIS], sPoints, sPointsLost, sHabs, sOptions, sWeapons, sItemsExtras, g_HatId[id], g_Mastery[id],
	g_AccountId[id], g_AccountPJs[id][g_UserSelected[id]]);
	
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(id, sqlQuery, 1800);
	} else {
		SQL_FreeHandle(sqlQuery);
	}
	
	formatex(sItemsExtras, 511, "UPDATE zp6_pjs_stats SET damage_d='%0.20f', damage_t='%0.20f', infects_d='%d', infects_t='%d', zombies_d='%d', zombies_t='%d',\
	humans_d='%d', humans_t='%d', headshots_d='%d', headshots_t='%d', zombies_hs_d='%d', zombies_hs_t='%d',\
	zombies_knife_d='%d', zombies_knife_t='%d', combo_d='%d', combo_max_d='%d', armor_d='%d', armor_t='%d',", g_Stats_Damage[id][0], g_Stats_Damage[id][1],
	g_Stats[id][STAT_DONE][STAT_INFECTIONS], g_Stats[id][STAT_TAKEN][STAT_INFECTIONS], g_Stats[id][STAT_DONE][STAT_ZOMBIES], g_Stats[id][STAT_TAKEN][STAT_ZOMBIES],
	g_Stats[id][STAT_DONE][STAT_HUMANS], g_Stats[id][STAT_TAKEN][STAT_HUMANS], g_Stats[id][STAT_DONE][STAT_HEADSHOTS], g_Stats[id][STAT_TAKEN][STAT_HEADSHOTS],
	g_Stats[id][STAT_DONE][STAT_ZOMBIES_HEADSHOTS], g_Stats[id][STAT_TAKEN][STAT_ZOMBIES_HEADSHOTS], g_Stats[id][STAT_DONE][STAT_ZOMBIES_KNIFE], g_Stats[id][STAT_TAKEN][STAT_ZOMBIES_KNIFE],
	g_Stats[id][STAT_DONE][STAT_COMBO], g_Stats[id][STAT_DONE][STAT_COMBO_MAX], g_Stats[id][STAT_DONE][STAT_ARMOR], g_Stats[id][STAT_TAKEN][STAT_ARMOR]);
	
	formatex(sOptions, 511, "achievements_d='%d', challenges_d='%d', nem_legend_kills_d='%d', nemesis_d='%d', nemesis_t='%d', nemesis_c='%d',\
	survivor_d='%d', survivor_t='%d', survivor_c='%d', wesker_d='%d', wesker_t='%d', wesker_c='%d', jason_d='%d', jason_t='%d', jason_c='%d',",
	g_Stats[id][STAT_DONE][STAT_ACHIEVEMENTS], g_Stats[id][STAT_DONE][STAT_CHALLENGES], g_Stats[id][STAT_DONE][STAT_NEMESIS_LEGEND_KILLS],
	g_Stats[id][STAT_DONE][STAT_NEMESIS], g_Stats[id][STAT_TAKEN][STAT_NEMESIS], g_Stats[id][STAT_DONE][STAT_NEMESIS_COUNT],
	g_Stats[id][STAT_DONE][STAT_SURVIVOR], g_Stats[id][STAT_TAKEN][STAT_SURVIVOR], g_Stats[id][STAT_DONE][STAT_SURVIVOR_COUNT],
	g_Stats[id][STAT_DONE][STAT_WESKER], g_Stats[id][STAT_TAKEN][STAT_WESKER], g_Stats[id][STAT_DONE][STAT_WESKER_COUNT],
	g_Stats[id][STAT_DONE][STAT_JASON], g_Stats[id][STAT_TAKEN][STAT_JASON], g_Stats[id][STAT_DONE][STAT_JASON_COUNT]);
	
	formatex(sHabs, 511, "first_zombie_c='%d', troll_d='%d', troll_t='%d', troll_c='%d', mega_nem_d='%d', mega_nem_t='%d', mega_nem_c='%d',\
	assassin_d='%d', assassin_t='%d', assassin_c='%d', alien_d='%d', alien_t='%d', alien_c='%d', predator_d='%d', predator_t='%d', predator_c='%d' \
	WHERE acc_id='%d' AND pj_id='%d';",
	g_Stats[id][STAT_DONE][STAT_FIRST_ZOMBIE_COUNT], g_Stats[id][STAT_DONE][STAT_TROLL], g_Stats[id][STAT_TAKEN][STAT_TROLL], g_Stats[id][STAT_DONE][STAT_TROLL_COUNT],
	g_Stats[id][STAT_DONE][STAT_MEGA_NEMESIS], g_Stats[id][STAT_TAKEN][STAT_MEGA_NEMESIS], g_Stats[id][STAT_DONE][STAT_MEGA_NEMESIS_COUNT],
	g_Stats[id][STAT_DONE][STAT_ASSASSIN], g_Stats[id][STAT_TAKEN][STAT_ASSASSIN], g_Stats[id][STAT_DONE][STAT_ASSASSIN_COUNT],
	g_Stats[id][STAT_DONE][STAT_ALIEN], g_Stats[id][STAT_TAKEN][STAT_ALIEN], g_Stats[id][STAT_DONE][STAT_ALIEN_COUNT],
	g_Stats[id][STAT_DONE][STAT_PREDATOR], g_Stats[id][STAT_TAKEN][STAT_PREDATOR], g_Stats[id][STAT_DONE][STAT_PREDATOR_COUNT],
	g_AccountId[id], g_AccountPJs[id][g_UserSelected[id]]);
	
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "%s%s%s", sItemsExtras, sOptions, sHabs);
	
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(id, sqlQuery, 1900);
	} else {
		SQL_FreeHandle(sqlQuery);
	}
	
	// Estadísticas de las armas
	for(i = 1; i < 31; ++i) {
		if(!g_WeaponSave[id][i]) {
			continue;
		}
		
		sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE zp6_weapons SET weapon_lvl='%d', weapon_kills='%d', weapon_dmg='%0.20f', weapon_time='%d', weapon_points='%d', wpn_skill_dmg='%d', wpn_skill_speed='%d', wpn_skill_recoil='%d',\
		wpn_skill_maxclip='%d' WHERE acc_id='%d' AND pj_id='%d' AND weapon_id='%d';", g_WeaponData[id][i][weaponLevel], g_WeaponData[id][i][weaponKills], g_WeaponData[id][i][weaponDamage], g_WeaponData[id][i][weaponTimePlayed],
		g_WeaponSkill[id][i][SKILL_POINTS], g_WeaponSkill[id][i][SKILL_DAMAGE],	g_WeaponSkill[id][i][SKILL_SPEED], g_WeaponSkill[id][i][SKILL_RECOIL], g_WeaponSkill[id][i][SKILL_MAXCLIP], g_AccountId[id], g_AccountPJs[id][g_UserSelected[id]], i);
		
		if(!SQL_Execute(sqlQuery)) {
			executeQuery(id, sqlQuery, 2000);
		} else {
			SQL_FreeHandle(sqlQuery);
		}
	}
}

public checkAPsEquation(const id) {
	g_AmmoPacks_Rest[id] = __APS_THIS_LEVEL(id) - g_AmmoPacks[id];
	
	if(g_AmmoPacks_Rest[id] <= 0) {
		if(g_Level[id] != 300) {
			static iCant;
			iCant = 0;
			
			while(g_AmmoPacks_Rest[id] <= 0) {
				++g_Level[id];
				++iCant;
				
				if(g_Level[id] == 300) {
					g_AmmoPacks_Rest[id] = 0;
					
					break;
				}
				
				g_AmmoPacks_Rest[id] = __APS_THIS_LEVEL(id) - g_AmmoPacks[id];
			}
			
			if(iCant) {
				client_cmd(id, "spk ^"%s^"", g_SOUND_Level_Up);
				
				set_dhudmessage(0, 0, 255, -1.0, 0.2, 0, 0.0, 5.0, 1.0, 1.0);
				show_dhudmessage(id, "Subiste %d nivel%s", iCant, (iCant != 1) ? "es" : "");
				
				new i;
				for(i = 0; i < sizeof(ARMAS_PRIMARIAS); ++i) {
					if(g_Reset[id] <= ARMAS_PRIMARIAS[i][weaponReset]) {
						if(g_Level[id] < ARMAS_PRIMARIAS[i][weaponLevelReq]) {
							g_ProxPrimaryWeapon[id] = ARMAS_PRIMARIAS[i][weaponCSW];
							
							break;
						}
					}
				}
				
				for(i = 0; i < sizeof(ARMAS_SECUNDARIAS); ++i) {
					if(g_Reset[id] <= ARMAS_SECUNDARIAS[i][weaponReset]) {
						if(g_Level[id] < ARMAS_SECUNDARIAS[i][weaponLevelReq]) {
							g_ProxSecondaryWeapon[id] = ARMAS_SECUNDARIAS[i][weaponCSW];
							
							break;
						}
					}
				}
			}
		} else {
			g_AmmoPacks_Rest[id] = 0;
		}
	}
	
	addDot(g_AmmoPacks_Rest[id], g_AmmoPacks_Rest_Dot[id], 31);
	
	if(g_Level_Percent[id] < 100.0) {
		g_Level_Percent[id] = ((float(g_AmmoPacks[id] - __APS_THIS_LEVEL_REST1(id))) * 100.0) / (float(__APS_THIS_LEVEL(id) - __APS_THIS_LEVEL_REST1(id)));
		
		if(g_Level_Percent[id] > 100.0) {
			g_Level_Percent[id] = 100.0;
		}
	}
	
	g_Reset_Percent[id] = (g_AmmoPacks[id] * 100.0) / __MAX_APS_PER_RESET(id);
	
	if(g_Reset_Percent[id] > 100.0) {
		g_Reset_Percent[id] = 100.0;
	}
}

public task__PluginSQL() {
	set_cvar_num("sv_alltalk", 1);
	set_cvar_num("sv_voicequality", 5);
	set_cvar_num("sv_airaccelerate", 100);
	set_cvar_num("sv_maxspeed", 9999);
	set_cvar_num("mp_flashlight", 1);
	set_cvar_num("mp_footsteps", 1);
	set_cvar_num("mp_freezetime", 0);
	set_cvar_num("mp_friendlyfire", 0);
	set_cvar_num("mp_limitteams", 0);
	set_cvar_num("mp_autoteambalance", 0);
	set_cvar_num("sv_voiceenable", 0);	
	
	set_cvar_float("mp_roundtime", 6.0);
	
	set_cvar_string("sv_voicecodec", "voice_speex");
	
	server_cmd("sv_restart 1");
	
	g_LogSay = 1;
	
	g_SqlTuple = SQL_MakeDbTuple(SQL_HOST, SQL_USER, SQL_PASS, SQL_TABLE);
	if(g_SqlTuple == Empty_Handle) {
		log_to_file("zp_sql_tuple.log", "%s", g_SqlError);
		set_fail_state(g_SqlError);
	}
	
	new iSql_ErrorNum;
	
	g_SqlConnection = SQL_Connect(g_SqlTuple, iSql_ErrorNum, g_SqlError, 511);
	if(g_SqlConnection == Empty_Handle) {
		log_to_file("zp_sql_connect.log", "%s", g_SqlError);
		set_fail_state(g_SqlError);
	}
	
	new Handle:sqlQuery;
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "(SELECT combo FROM zp6_combos WHERE type='0' AND mapname=^"%s^" ORDER BY combo DESC LIMIT 1) UNION ALL (SELECT combo FROM zp6_combos WHERE type='1' AND mapname=^"%s^" ORDER BY combo DESC LIMIT 1);",
	g_MapName, g_MapName);
	
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(0, sqlQuery, 2105);
	} else if(SQL_NumResults(sqlQuery)) {
		static iRepeat;
		iRepeat = 0;
		
		while(SQL_MoreResults(sqlQuery)) {
			if(!iRepeat) {
				g_TOP_MaxComboHPerMap = SQL_ReadResult(sqlQuery, 0);
			} else {
				g_TOP_MaxComboZPerMap = SQL_ReadResult(sqlQuery, 0);
			}
			
			++iRepeat;
			
			SQL_NextRow(sqlQuery);
		}
		
		SQL_FreeHandle(sqlQuery);
	} else {
		SQL_FreeHandle(sqlQuery);
	}
	
	if(g_TOP_MaxComboHPerMap < 1000) {
		g_TOP_MaxComboHPerMap = 1000;
	}
	
	if(g_TOP_MaxComboZPerMap < 5) {
		g_TOP_MaxComboZPerMap = 4;
	}
	
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT achievement_id, achievement_date FROM zp6_achievements WHERE achievement_first='1';");
	
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(0, sqlQuery, 2110);
	} else if(SQL_NumResults(sqlQuery)) {
		static iAchievement;
		
		while(SQL_MoreResults(sqlQuery)) {
			iAchievement = SQL_ReadResult(sqlQuery, 0);
			
			g_Achievement[0][iAchievement] = 1;
			SQL_ReadResult(sqlQuery, 1, g_AchievementUnlocked[0][iAchievement], 31);
			
			SQL_NextRow(sqlQuery);
		}
		
		SQL_FreeHandle(sqlQuery);
	} else {
		SQL_FreeHandle(sqlQuery);
	}
	
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT * FROM zp6_modes;");
	
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(0, sqlQuery, 2115);
	} else if(SQL_NumResults(sqlQuery)) {
		new i;
		for(i = 1; i < modesIds; ++i) {
			g_Modes_Count[i] = SQL_ReadResult(sqlQuery, i);
		}
		
		SQL_FreeHandle(sqlQuery);
	} else {
		SQL_FreeHandle(sqlQuery);
	}
	
	g_tExtra_BombaAniquilacion = TrieCreate();
	g_tExtra_BombaAntidoto = TrieCreate();
	g_tExtra_Inmunidad = TrieCreate();
	g_tExtra_Antidoto = TrieCreate();
	g_tExtra_Furia = TrieCreate();
	g_tExtra_BombaInfeccion = TrieCreate();
	g_tExtra_Petrificacion = TrieCreate();
	
	g_tArmageddonCant = TrieCreate();
}

executeQuery(const id, const Handle:query, const iQuery=0) { // eq_f
	SQL_QueryError(query, g_SqlError, 511);
	
	log_to_file("zp_sql.log", "- %d : %s", iQuery, g_SqlError);
	
	if(is_user_valid_connected(id)) {
		server_cmd("kick #%d ^"Hubo un error al guardar/cargar tus datos. Intente mas tarde^"", get_user_userid(id));
	}
	
	SQL_FreeHandle(query);
}

public task__KickReasonBan(const id) {
	if(g_IsConnected[id]) {
		console_print(id, "");
		console_print(id, "");
		console_print(id, "****** CIMSP ******");
		console_print(id, "");
		console_print(id, "TU CUENTA ESTÁ BANEADA");
		console_print(id, "");
		console_print(id, "Administrador que te baneo: %s", g_AccountBan_Admin[id]);
		console_print(id, "Razón: %s", g_AccountBan_Reason[id]);
		console_print(id, "El ban fue realizado en la fecha: %s", g_AccountBan_Start[id]);
		console_print(id, "El ban expira en la fecha: %s", g_AccountBan_Finish[id]);
		console_print(id, "Cuenta #%d", g_AccountId[id]);
		console_print(id, "");
		console_print(id, "****** CIMSP ******");
		console_print(id, "");
		console_print(id, "");
		
		set_task(1.0, "task__KickUser", id);
	}
}

public task__KickUser(const id) {
	if(g_IsConnected[id]) {
		server_cmd("kick #%d ^"Tu cuenta está baneada y no puedes permanecer en el servidor!^"", get_user_userid(id));
	}
}

public task__RemoveStuff() {
	new iEnt;
	iEnt = -1;
	
	while((iEnt = engfunc(EngFunc_FindEntityByString, iEnt, "classname", "func_door_rotating")) != 0) {
		entity_set_origin(iEnt, Float:{8192.0, 8192.0, 8192.0});
	}
}

public task__RefillBPAmmo(const args[], const id) {
	if(!g_IsAlive[id]) {
		return;
	}
	
	set_msg_block(g_Message_AmmoPickup, BLOCK_ONCE);
	ExecuteHamB(Ham_GiveAmmo, id, MAX_BPAMMO[args[0]], AMMO_TYPE[args[0]], MAX_BPAMMO[args[0]]);
}

public randomSpawn(const id) {
	new iHull;
	new iSpawnId;
	new i;
	
	iHull = (get_entity_flags(id) & FL_DUCKING) ? HULL_HEAD : HULL_HUMAN;
	
	if(!g_SpawnCount) {
		return;
	}
	
	iSpawnId = random_num(0, g_SpawnCount - 1);
	
	for(i = iSpawnId + 1; /*no condition*/; ++i) {
		if(i >= g_SpawnCount) {
			i = 0;
		}
		
		if(isHullVacant(g_Spawns[i], iHull)) {
			entity_set_vector(id, EV_VEC_origin, g_Spawns[i]);
			break;
		}
		
		if(i == iSpawnId) {
			break;
		}
	}
	
	set_task(0.5, "checkStuck", id);
}

public checkStuck(const id) {
	if(!g_IsConnected[id]) {
		return;
	}
	
	if(isUserStuck(id)) {
		randomSpawn(id);
	}
}

public task__HideHUDs(const taskid) {
	new id = ID_SPAWN;
	
	if(!g_IsAlive[id]) {
		return;
	}
	
	message_begin(MSG_ONE, g_Message_HideWeapon, _, id);
	write_byte(HIDE_HUDS);
	message_end();
	
	message_begin(MSG_ONE, g_Message_Crosshair, _, id);
	write_byte(0);
	message_end();
}

public task__RespawnUserCheck(const taskid) {
	new id = ID_SPAWN;
	
	if(g_IsAlive[id] || g_EndRound) {
		return;
	}
	
	new iTeam;
	iTeam = getUserTeam(id);
	
	if(iTeam == FM_CS_TEAM_SPECTATOR || iTeam == FM_CS_TEAM_UNASSIGNED) {
		return;
	}
	
	if(g_Zombie[id]) {
		g_RespawnAsZombie[id] = 1;
	} else {
		g_RespawnAsZombie[id] = 0;
	}
	
	respawnUserManually(id);
}

public task__RespawnUser(const taskid) {
	new id = ID_SPAWN;
	
	if(g_IsAlive[id] || g_EndRound) {
		return;
	}
	
	new iTeam;
	iTeam = getUserTeam(id);
	
	if(iTeam == FM_CS_TEAM_SPECTATOR || iTeam == FM_CS_TEAM_UNASSIGNED) {
		return;
	}
	
	if(g_NewRound || g_Mode == MODE_INFECTION || g_Mode == MODE_MULTI) {
		if(g_RandomRespawn[id]) {
			new iRandom = random_num(1, 100);
			
			if(iRandom <= g_RandomRespawn[id]) {
				g_RespawnAsZombie[id] = 0;
			} else {
				g_RespawnAsZombie[id] = 1;
			}
		} else {
			g_RespawnAsZombie[id] = 1;
		}
		
		respawnUserManually(id);
	}
}

public respawnUserManually(const id) {
	setUserTeam(id, (g_RespawnAsZombie[id]) ? FM_CS_TEAM_T : FM_CS_TEAM_CT);
	ExecuteHamB(Ham_CS_RoundRespawn, id);
}

public task__ClearWeapons(const taskid) {
	new id = ID_SPAWN;
	
	strip_user_weapons(id);
	
	g_WeaponPrimary_Selection[id] = 0;
	g_WeaponSecondary_Selection[id] = 0;
	g_WeaponTerciary_Selection[id] = 0;
	
	give_item(id, "weapon_knife");
}

turnOffFlashlight(const id) {
	entity_set_int(id, EV_INT_effects, entity_get_int(id, EV_INT_effects) & ~EF_DIMLIGHT);
	
	message_begin(MSG_ONE_UNRELIABLE, g_Message_Flashlight, _, id);
	write_byte(0);
	write_byte(100);
	message_end();
	
	entity_set_int(id, EV_INT_impulse, 0);
}

replaceWeaponModels(const id, const weaponId) { // rwm_f
	if(g_WeaponModel[id][weaponId] && !g_Zombie[id]) {
		entity_set_string(id, EV_SZ_viewmodel, g_WEAPONS_Models[weaponId][g_WeaponModel[id][weaponId] - 1][weaponModelPath]);
	}
	
	switch(weaponId) {
		case CSW_KNIFE: {
			if(g_Zombie[id]) {
				switch(g_SpecialMode[id]) {
					case MODE_NEMESIS: {
						entity_set_string(id, EV_SZ_viewmodel, g_MODEL_Nemesis_Knife);
					} case MODE_TROLL: {
						entity_set_string(id, EV_SZ_viewmodel, g_MODEL_Troll_Knife);
					} case MODE_ALVSPRED: {
						entity_set_string(id, EV_SZ_viewmodel, g_MODEL_Alien_Knife);
					} default: {
						entity_set_string(id, EV_SZ_viewmodel, CLASES_ZOMBIE[g_ZombieClass[id]][zombieClawModel]);
					}
				}
				
				entity_set_string(id, EV_SZ_weaponmodel, "");
			} else {
				if(g_SpecialMode[id] == MODE_JASON) {
					entity_set_string(id, EV_SZ_viewmodel, g_MODEL_Chainsaw[0]);
					entity_set_string(id, EV_SZ_weaponmodel, g_MODEL_Chainsaw[1]);
				}
			}
		} case CSW_HEGRENADE: {
			if(!g_Zombie[id]) {
				entity_set_string(id, EV_SZ_viewmodel, g_MODEL_Combo_View);
			} else {
				entity_set_string(id, EV_SZ_viewmodel, g_MODEL_Infection);
			}
		} case CSW_FLASHBANG: {
			if(g_SuperNova_Bomb[id]) {
				entity_set_string(id, EV_SZ_viewmodel, g_MODEL_Supernova_View);
			} else {
				entity_set_string(id, EV_SZ_viewmodel, g_MODEL_Frost);
			}
		} case CSW_SMOKEGRENADE: {
			if(g_Bubble_Bomb[id]) {
				entity_set_string(id, EV_SZ_viewmodel, g_MODEL_Bubble_View);
			} else {
				entity_set_string(id, EV_SZ_viewmodel, g_MODEL_Flare);
			}
		} case CSW_M249: {
			if(g_SpecialMode[id] == MODE_SURVIVOR) {
				if(g_Hab[id][CLASS_SURVIVOR][HAB_S_WEAPON]) {
					entity_set_string(id, EV_SZ_viewmodel, g_WEAPONS_Models[CSW_M249][g_Hab[id][CLASS_SURVIVOR][HAB_S_WEAPON] - 1][weaponModelPath]);
				}
			}
		} case CSW_AK47: {
			if(g_SpecialMode[id] == MODE_NEMESIS) {
				entity_set_string(id, EV_SZ_viewmodel, g_MODEL_Bazooka_View);
				entity_set_string(id, EV_SZ_weaponmodel, g_MODEL_Bazooka_Player);
			}
		}
	}
}

public getAliveTs() {
	static iTs;
	static id;
	
	iTs = 0;
	
	for(id = 1; id <= g_MaxUsers; ++id) {
		if(g_IsAlive[id]) {
			if(getUserTeam(id) == FM_CS_TEAM_T) {
				++iTs;
			}
		}
	}
	
	return iTs;
}

public getAliveCTs() {
	static iCTs;
	static id;
	
	iCTs = 0;
	
	for(id = 1; id <= g_MaxUsers; ++id) {
		if(g_IsAlive[id]) {
			if(getUserTeam(id) == FM_CS_TEAM_CT) {
				++iCTs;
			}
		}
	}
	
	return iCTs;
}

public checkLastZombie() {
	static id;
	static iZombies;
	static iHumans;
	
	iZombies = getZombies();
	iHumans = getHumans();
	
	for(id = 1; id <= g_MaxUsers; ++id) {
		if(g_IsAlive[id] && g_Zombie[id] && !g_SpecialMode[id] && iZombies == 1) {
			g_LastZombie[id] = 1;
		} else {
			g_LastZombie[id] = 0;
		}
		
		if(g_IsAlive[id] && !g_Zombie[id] && !g_SpecialMode[id] && iHumans == 1) {
			g_LastHuman[id] = 1;
			
			if(!g_HatDevil[id] && g_Mode == MODE_INFECTION && getUsersPlaying() >= 18) {
				giveHat(id, HAT_DEVIL);
			}
		} else {
			g_LastHuman[id] = 0;
		}
	}
}

public resetVars(const id, const all) {
	g_CanBuy[id] = 1;
	g_Zombie[id] = 0;
	g_RespawnAsZombie[id] = 0;
	g_Immunity[id] = 0;
	g_SpecialMode[id] = 0;
	g_LastHuman[id] = 0;
	g_LastZombie[id] = 0;
	g_FirstZombie[id] = 0;
	g_Frozen[id] = 0;
	g_InBubble[id] = 0;
	g_Nightvision[id] = 0;
	g_UnlimitedClip[id] = 0;
	g_Annihilation_Bomb[id] = 0;
	g_Antidote_Bomb[id] = 0;
	g_Bubble_Bomb[id] = 0;
	g_SuperNova_Bomb[id] = 0;
	g_NightvisionOn[id] = 0;
	g_SurvivorImmunity[id] = 0;
	g_Alien[id] = 0;
	g_Predator[id] = 0;
	g_Alien_Power[id] = 0;
	g_Predator_Power[id] = 0;
	g_Wesker_LASER_Waste[id] = 0;
	g_InfectsWithSameFury[id] = -9999;
	g_LongJump[id] = 0;
	g_InJump[id] = 0;
	g_MiSuerteEsUnica_Kills[id] = 0;
	g_YElSurvivor[id] = 0;
	g_YElNemesis[id] = 0;
	g_PumHeadshot[id] = 0;
	g_SinHacerDamage[id] = 0;
	g_AlvsPred_Kills[id] = 0;
	g_Alien_WithFury_HumanKills[id] = 0;
	g_InfectsWithMaxHealth[id] = 0;
	g_Swarm_HumansKills[id] = 0;
	g_Armageddon_SurvivorKills[id] = 0;
	g_InfectsInRound[id] = 0;
	
	set_pdata_int(id, OFFSET_LONG_JUMP, 0, OFFSET_LINUX);
	
	g_Vigor[id] = 0.0;
	
	if(all) {
		new i;
		new j;
		
		g_AccountPassword[id][0] = EOS;
		g_AccountName[id][0] = EOS;
		g_AccountHID[id][0] = '!';
		
		for(i = 0; i < 4; ++i) {
			g_AccountPJ_Name[id][i][0] = EOS;
			
			g_AccountPJs[id][i] = 0;
			g_AccountPJ_Level[id][i] = 0;
			g_AccountPJ_Reset[id][i] = 0;
		}
		
		g_AccountId[id] = 0;
		g_AccountBanned[id] = 0;
		g_HumanClass[id] = 0;
		g_HumanClassNext[id] = 0;
		g_PrimaryWeapon[id] = 0;
		g_WeaponPrimaryActual[id] = 0;
		g_WeaponSecondaryActual[id] = 0;
		g_AccountLogged[id] = 0;
		g_AccountPJ_Logged[id] = 0;
		g_UserSelected[id] = 0;
		g_AccountBan[id] = 0;
		g_ComboDamage[id] = 0;
		g_AmmosDamage[id] = 0;
		g_ComboNeedDamage[id] = 500;
		g_Combo[id] = 0;
		g_Kiske[id] = 0;
		g_Level[id] = 1;
		g_AmmoPacks[id] = 0;
		g_Account_Logo[id] = LOGO_NONE;
		g_Vinc[id] = 0;
		g_ZombieClass[id] = 0;
		g_ZombieClassNext[id] = 0;
		g_AllowChangeTeam[id] = 0;
		g_AllowChangeName[id] = 0;
		g_AllowChangeName_SPECIAL[id] = 0;
		g_AmmoPacks_Rest[id] = 0;
		g_WeaponAutoBuy[id] = 0;
		g_Reset[id] = 0;
		g_Hab_Reset[id][CLASS_HUMAN] = 0;
		g_Hab_Reset[id][CLASS_ZOMBIE] = 0;
		g_InGroup[id] = 0;
		g_GroupInvitations[id] = 0;
		g_ClanInvitations[id] = 0;
		g_MyGroup[id] = 0;
		g_InClan[id] = 0;
		g_ClanInPos[id] = 0;
		g_ClanId[id] = 0;
		g_Rank[id] = 0;
		g_HatNext[id] = HAT_NONE;
		g_HatId[id] = HAT_NONE;
		g_Options_Invis[id] = 0;
		g_Bazooka_Sprite_Color[id] = 0;
		g_HatEnt[id] = 0;
		g_Options_Color[id][COLOR_HUD] = {0, 255, 0};
		g_Options_HUD_Position[id][HUD_GENERAL] = Float:{0.02, 0.08, 0.0};
		g_Options_HUD_Effect[id][HUD_GENERAL] = 0;
		g_Options_HUD_Abrev[id][HUD_GENERAL] = 0;
		g_Options_HUD_Position[id][HUD_COMBO] = Float:{-1.0, 0.57, 0.0};
		g_Options_HUD_Effect[id][HUD_COMBO] = 0;
		g_Options_HUD_Abrev[id][HUD_COMBO] = 0;
		g_DeadTimes[id] = 0;
		g_Options_Color[id][COLOR_NIGHTVISION] = {100, 100, 100};
		g_Options_Color[id][COLOR_FLARE] = {255, 255, 255};
		g_Options_Color[id][COLOR_BAZOOKA] = {255, 0, 0};
		g_Options_Color[id][COLOR_LASER] = {255, 255, 255};
		g_MultPoints[id] = 1;
		g_RealMultPoints[id] = 0;
		g_LastWeapon[id] = 0;
		g_Mastery[id] = 0;
		g_VisitDays[id] = 0;
		g_RandomRespawn[id] = 0;
		g_BestAPs_History[id] = 0;
		g_BestAPs[id] = 0;
		g_Induccion[id] = 0;
		g_VigorChance[id] = 0;
		g_ProxPrimaryWeapon[id] = 0;
		g_ProxSecondaryWeapon[id] = 0;
		g_WeaponPrimary_Selection[id] = 0;
		g_WeaponSecondary_Selection[id] = 0;
		g_WeaponTerciary_Selection[id] = 0;
		g_HatDevil[id] = 0;
		g_ExtraCombo[id] = 0;
		g_ComboReward[id] = 0;
		g_AnotherUserInYourAccount[id] = 0;
		g_Mercenario_Infects[id] = 0;
		g_Mercenario_Kills[id] = 0;
		g_LaSaludEsLoPrimero[id] = 0;
		g_Impecable[id] = 0;
		g_InfectsWithFury[id] = 0;
		g_FuryConsecutive[id] = 0;
		g_BlockSound[id] = 0;
		
		g_MultAps[id] = 1.0;
		g_ExtraMultAps[id] = 0.0;
		g_Stats_Damage[id][0] = 0.0;
		g_Stats_Damage[id][1] = 0.0;
		g_Clan_QueryFlood[id] = 0.0;
		g_SysTime_Tops[id] = 0.0;
		g_SysTime_Link[id] = 0.0;
		g_BonusDays[id] = 0.0;
		g_DamageReduce[id] = 0.0;
		g_Legado_MultAps[id] = 0.0;
		
		addDot(g_AmmoPacks[id], g_AmmoPacksHud[id], 31);
		
		for(i = 0; i <= g_MaxUsers; ++i) {
			g_GroupInvitationsId[id][i] = 0;
			g_ClanInvitationsId[id][i] = 0;
		}
		
		for(j = 0; j < statsData; ++j) {
			g_Stats[id][0][j] = 0;
			g_Stats[id][1][j] = 0;
		}
		
		for(i = 0; i < extraItemsId; ++i) {
			g_ItemExtra_Cost[id][i] = ITEMS_EXTRAS[i][extraCost];
			g_ItemExtra_Count[id][i] = 0;
		}
		
		for(i = 0; i < classPoints; ++i) {
			g_Points[id][i] = 0;
			g_PointsLost[id][i] = 0;
		}
		
		for(i = 0; i < classHabilities; ++i) {
			for(j = 0; j < MAX_HABILITIES; ++j) {
				g_Hab[id][i][j] = 0;
			}
		}
		
		for(i = 0; i < structTime; ++i) {
			g_PlayedTime[id][i] = 0;
		}
		
		for(i = 0; i < 31; ++i) {
			g_WeaponSave[id][i] = 0;
			g_WeaponModel[id][i] = 0;
			
			g_WeaponData[id][i][weaponLevel] = 0;
			g_WeaponData[id][i][weaponKills] = 0;
			g_WeaponData[id][i][weaponDamage] = _:0.0;
			g_WeaponData[id][i][weaponTimePlayed] = 0;
			g_WeaponData[id][i][weaponTimeDays] = 0;
			g_WeaponData[id][i][weaponTimeHours] = 0;
			g_WeaponData[id][i][weaponTimeMinutes] = 0;
			
			for(j = 0; j < weaponSkillsIds; ++j) {
				g_WeaponSkill[id][i][j] = 0;
			}
		}
		
		for(i = 0; i < menusName; ++i) {
			g_MenuPage[id][i] = 0;
		}
		
		for(i = 0; i < auraStruct; ++i) {
			g_Aura[id][i] = 0;
		}
		
		for(i = 0; i < maxClassDifficults; ++i) {
			g_Difficults[id][i] = 0;
		}
		
		for(i = 0; i < achievementsIds; ++i) {
			g_Achievement[id][i] = 0;
			g_AchievementUnlocked[id][i][0] = EOS;
		}
	}
}

public clcmd__Changeteam(const id) {
	if(!g_IsConnected[id]) {
		return PLUGIN_HANDLED;
	}
	
	if(g_AnotherUserInYourAccount[id]) {
		showMenu__AnotherUser(id);
		return PLUGIN_HANDLED;
	}
	
	if(g_AccountBanned[id]) {
		return PLUGIN_HANDLED;
	}
	
	if(!g_AccountLogged[id]) {
		showMenu__Register_Login(id);
		return PLUGIN_HANDLED;
	}
	
	if(!g_AccountPJ_Logged[id]) {
		showMenu__ChoosePJ(id);
		return PLUGIN_HANDLED;
	}
	
	if(g_AllowChangeTeam[id]) {
		return PLUGIN_CONTINUE;
	}
	
	showMenu__Game(id);
	return PLUGIN_HANDLED;
}

public clcmd__Nightvision(const id) {
	if(!g_IsConnected[id]) {
		return PLUGIN_HANDLED;
	}
	
	if(g_Frozen[id] || ((g_NightvisionNoFlood[id] - get_gametime()) > 0.0)) {
		return PLUGIN_HANDLED;
	}
	
	g_NightvisionNoFlood[id] = get_gametime() + 0.7;
	
	if(g_Nightvision[id]) {
		if(g_NightvisionOn[id]) {
			g_NightvisionOn[id] = 0;
			
			setLight(id, "a");
			
			message_begin(MSG_ONE, g_Message_ScreenFade, _, id);
			write_short(0);
			write_short(0);
			write_short(FFADE_IN);
			write_byte(0);
			write_byte(0);
			write_byte(0);
			write_byte(0);
			message_end();
		} else {
			g_NightvisionOn[id] = 1;
			
			setLight(id, "i");
			
			message_begin(MSG_ONE, g_Message_ScreenFade, _, id);
			write_short(UNIT_SECOND);
			write_short(0);
			write_short(FFADE_STAYOUT);
			write_byte(g_Options_Color[id][COLOR_NIGHTVISION][__R]);
			write_byte(g_Options_Color[id][COLOR_NIGHTVISION][__G]);
			write_byte(g_Options_Color[id][COLOR_NIGHTVISION][__B]);
			write_byte(75);
			message_end();
		}
	}
	
	return PLUGIN_HANDLED;
}

public showCurrentComboHuman(const id, const damage) {
	if(g_InGroup[id]) {
		static sCombo[11];
		static sComboIndividual[11];
		static sReward[11];
		static sDamageTotal[11];
		static sDamage[11];
		static iCombo;
		static iDamageTotal;
		static iExtraCombo;
		static i;
		
		iCombo = 0;
		iDamageTotal = 0;
		iExtraCombo = 0;
		
		g_HLTime_GroupCombo[g_InGroup[id]] = halflife_time() + 5.0;
		
		for(i = 1; i < 4; ++i) {
			if(g_GroupId[g_InGroup[id]][i] && !g_Zombie[g_GroupId[g_InGroup[id]][i]] && g_IsAlive[g_GroupId[g_InGroup[id]][i]]) {
				iCombo += g_Combo[g_GroupId[g_InGroup[id]][i]];
				iDamageTotal += g_ComboDamage[g_GroupId[g_InGroup[id]][i]];
				iExtraCombo += g_ExtraCombo[g_GroupId[g_InGroup[id]][i]];
			}
		}
		
		while(id > 0) { // sin condicion, se repite hasta que llegue al break
			if(iCombo >= __COMBOS[g_GroupComboReward[g_InGroup[id]]][comboNeed] && iCombo < __COMBOS[g_GroupComboReward[g_InGroup[id]] + 1][comboNeed]) {
				break;
			}
			
			++g_GroupComboReward[g_InGroup[id]];
		}
		
		addDot(iCombo, sCombo, 10);
		addDot(iDamageTotal, sDamageTotal, 10);
		addDot(damage, sDamage, 10);
		addDot(((iCombo * __COMBOS[g_GroupComboReward[g_InGroup[id]]][comboMult]) + iExtraCombo), sReward, 10);
		
		for(i = 1; i < 4; ++i) {
			if(g_GroupId[g_InGroup[id]][i] && !g_Zombie[g_GroupId[g_InGroup[id]][i]] && g_IsAlive[g_GroupId[g_InGroup[id]][i]]) {
				set_hudmessage(__COMBOS[g_GroupComboReward[g_InGroup[id]]][comboRed], __COMBOS[g_GroupComboReward[g_InGroup[id]]][comboGreen], __COMBOS[g_GroupComboReward[g_InGroup[id]]][comboBlue],
				-1.0, g_Options_HUD_Position[g_GroupId[g_InGroup[id]][i]][HUD_COMBO][1], g_Options_HUD_Effect[g_GroupId[g_InGroup[id]][i]][HUD_COMBO], 0.0, 8.0, 0.0, 0.0, -1);
				
				addDot(g_Combo[g_GroupId[g_InGroup[id]][i]], sComboIndividual, 10);
				
				if(!g_Options_HUD_Abrev[g_GroupId[g_InGroup[id]][i]][HUD_COMBO]) {
					ShowSyncHudMsg(g_GroupId[g_InGroup[id]][i], g_Hud_Combo, "%s^nCombo x%s (%s) | + %s APs^nDaño total: %s | Daño: %s", __COMBOS[g_GroupComboReward[g_InGroup[id]]][comboName], sCombo, sComboIndividual, sReward, sDamageTotal, sDamage);
				} else {
					ShowSyncHudMsg(g_GroupId[g_InGroup[id]][i], g_Hud_Combo, "%s^nx%s (%s) | + %s APs^n%s | %s", __COMBOS[g_GroupComboReward[g_InGroup[id]]][comboName], sCombo, sComboIndividual, sReward, sDamageTotal, sDamage);
				}
			}
		}
	} else {
		static sCombo[11];
		static sReward[11];
		static sDamageTotal[11];
		static sDamage[11];
		
		g_HLTime_Combo[id] = halflife_time() + 5.0;
		
		while(id > 0) { // sin condicion, se repite hasta que llegue al break
			if(g_Combo[id] >= __COMBOS[g_ComboReward[id]][comboNeed] && g_Combo[id] < __COMBOS[g_ComboReward[id] + 1][comboNeed]) {
				break;
			}
			
			++g_ComboReward[id];
		}
		
		addDot(g_Combo[id], sCombo, 10);
		addDot(g_ComboDamage[id], sDamageTotal, 10);
		addDot(damage, sDamage, 10);
		addDot((g_Combo[id] * __COMBOS[g_ComboReward[id]][comboMult]) + g_ExtraCombo[id], sReward, 10);
		
		set_hudmessage(__COMBOS[g_ComboReward[id]][comboRed], __COMBOS[g_ComboReward[id]][comboGreen], __COMBOS[g_ComboReward[id]][comboBlue], -1.0, g_Options_HUD_Position[id][HUD_COMBO][1], g_Options_HUD_Effect[id][HUD_COMBO], 0.0, 8.0, 0.0, 0.0, -1);
		
		if(!g_Options_HUD_Abrev[id][HUD_COMBO]) {
			ShowSyncHudMsg(id, g_Hud_Combo, "%s^nCombo x%s | + %s APs^nDaño total: %s | Daño: %s", __COMBOS[g_ComboReward[id]][comboName], sCombo, sReward, sDamageTotal, sDamage);
		} else {
			ShowSyncHudMsg(id, g_Hud_Combo, "%s^nx%s | + %s APs^n%s | %s", __COMBOS[g_ComboReward[id]][comboName], sCombo, sReward, sDamageTotal, sDamage);
		}
	}
}

public finishComboHuman(const id) {
	static iReward;
	
	if(g_InGroup[id]) {
		static iCombo;
		static iDamageTotal;
		static iExtraCombo;
		static i;
		
		iCombo = 0;
		iDamageTotal = 0;
		iExtraCombo = 0;
		
		for(i = 1; i < 4; ++i) {
			if(g_GroupId[g_InGroup[id]][i] && !g_Zombie[g_GroupId[g_InGroup[id]][i]] && g_IsAlive[g_GroupId[g_InGroup[id]][i]]) {
				iCombo += g_Combo[g_GroupId[g_InGroup[id]][i]];
				iDamageTotal += g_ComboDamage[g_GroupId[g_InGroup[id]][i]];
				iExtraCombo += g_ExtraCombo[g_GroupId[g_InGroup[id]][i]];
				
				g_ComboDamage[g_GroupId[g_InGroup[id]][i]] = 0;
				g_ExtraCombo[g_GroupId[g_InGroup[id]][i]] = 0;
			}
		}
		
		if(iCombo) {
			iReward = (iCombo * __COMBOS[g_GroupComboReward[g_InGroup[id]]][comboMult]) + iExtraCombo;
			
			static sCombo[11];
			static sReward[11];
			static sDamageTotal[11];
			
			addDot(iReward, sReward, 10);
			addDot(iDamageTotal, sDamageTotal, 10);
			
			for(i = 1; i < 4; ++i) {
				if(g_GroupId[g_InGroup[id]][i] && !g_Zombie[g_GroupId[g_InGroup[id]][i]] && g_IsAlive[g_GroupId[g_InGroup[id]][i]]) {
					addAmmopacks(g_GroupId[g_InGroup[id]][i], iReward);
					
					set_hudmessage(__COMBOS[g_GroupComboReward[g_InGroup[id]]][comboRed], __COMBOS[g_GroupComboReward[g_InGroup[id]]][comboGreen], __COMBOS[g_GroupComboReward[g_InGroup[id]]][comboBlue],
					-1.0, g_Options_HUD_Position[g_GroupId[g_InGroup[id]][i]][HUD_COMBO][1], g_Options_HUD_Effect[g_GroupId[g_InGroup[id]][i]][HUD_COMBO], 1.0, 5.0, 0.1, 3.0, -1);
					
					ShowSyncHudMsg(g_GroupId[g_InGroup[id]][i], g_Hud_Combo, "%s^n+ %s APs^nDaño hecho: %s", __COMBOS[g_GroupComboReward[g_InGroup[id]]][comboName], sReward, sDamageTotal);
					
					if(g_GroupComboReward[g_InGroup[id]] > 1) {
						client_cmd(g_GroupId[g_InGroup[id]][i], "spk ^"%s^"", __COMBOS[g_GroupComboReward[g_InGroup[id]]][random_num(comboSound, comboSound2)]);
					} else {
						client_cmd(g_GroupId[g_InGroup[id]][i], "spk ^"%s^"", __COMBOS[g_GroupComboReward[g_InGroup[id]]][comboSound]);
					}
					
					if(g_Combo[g_GroupId[g_InGroup[id]][i]] > g_TOP_MaxComboHPerMap && !g_SpecialMode[g_GroupId[g_InGroup[id]][i]]) {
						g_TOP_MaxComboHPerMap = g_Combo[g_GroupId[g_InGroup[id]][i]];
						
						addDot(g_TOP_MaxComboHPerMap, sCombo, 10);
						
						colorChat(g_GroupId[g_InGroup[id]][i], CT, "%sConseguiste el !tcombo máximo humano!y (!gx%s!y) del mapa actual (!g%s!y)", ZP_PREFIX, sCombo, g_MapName);
						
						new Handle:sqlQuery;
						sqlQuery = SQL_PrepareQuery(g_SqlConnection, "INSERT INTO zp6_combos (`acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES ('%d', '%d', ^"%s^", ^"%s^", '0', '%d', UNIX_TIMESTAMP());",
						g_AccountId[g_GroupId[g_InGroup[id]][i]], g_AccountPJs[g_GroupId[g_InGroup[id]][i]][g_UserSelected[g_GroupId[g_InGroup[id]][i]]], g_UserName[g_GroupId[g_InGroup[id]][i]], g_MapName, g_TOP_MaxComboHPerMap);
						
						if(!SQL_Execute(sqlQuery)) {
							executeQuery(g_GroupId[g_InGroup[id]][i], sqlQuery, 10505);
						} else {
							SQL_FreeHandle(sqlQuery);
						}
					}
					
					g_Stats[g_GroupId[g_InGroup[id]][i]][STAT_DONE][STAT_COMBO] += g_Combo[g_GroupId[g_InGroup[id]][i]];
					
					if(g_Combo[g_GroupId[g_InGroup[id]][i]] > g_Stats[g_GroupId[g_InGroup[id]][i]][STAT_DONE][STAT_COMBO_MAX] && !g_SpecialMode[g_GroupId[g_InGroup[id]][i]]) {
						colorChat(g_GroupId[g_InGroup[id]][i], _, "%sHas superado tu viejo mayor combo de !gx%d!y por el recién hecho de !gx%d!y", ZP_PREFIX, g_Stats[g_GroupId[g_InGroup[id]][i]][STAT_DONE][STAT_COMBO_MAX], g_Combo[g_GroupId[g_InGroup[id]][i]]);
						g_Stats[g_GroupId[g_InGroup[id]][i]][STAT_DONE][STAT_COMBO_MAX] = g_Combo[g_GroupId[g_InGroup[id]][i]];
					}
					
					g_Combo[g_GroupId[g_InGroup[id]][i]] = 0;
				}
			}
		}
		
		g_GroupComboReward[g_InGroup[id]] = 0;
		g_HLTime_GroupCombo[g_InGroup[id]] = halflife_time() + 999999.9;
	} else {
		if(g_Combo[id]) {
			iReward = (g_Combo[id] * __COMBOS[g_ComboReward[id]][comboMult]) + g_ExtraCombo[id];
			
			if(iReward) {
				addAmmopacks(id, iReward);
				
				static sReward[11];
				static sDamage[11];
				static sCombo[11];
				
				addDot(iReward, sReward, 10);
				addDot(g_ComboDamage[id], sDamage, 10);
				addDot(g_Combo[id], sCombo, 10);
				
				set_hudmessage(__COMBOS[g_ComboReward[id]][comboRed], __COMBOS[g_ComboReward[id]][comboGreen], __COMBOS[g_ComboReward[id]][comboBlue], -1.0, g_Options_HUD_Position[id][HUD_COMBO][1], g_Options_HUD_Effect[id][HUD_COMBO], 1.0, 5.0, 0.1, 3.0, -1);
				ShowSyncHudMsg(id, g_Hud_Combo, "%s^n+ %s APs^nDaño hecho: %s", __COMBOS[g_ComboReward[id]][comboName], sReward, sDamage);
				
				if(g_ComboReward[id] > 1) {
					client_cmd(id, "spk ^"%s^"", __COMBOS[g_ComboReward[id]][random_num(comboSound, comboSound2)]);
				} else {
					client_cmd(id, "spk ^"%s^"", __COMBOS[g_ComboReward[id]][comboSound]);
				}
				
				if(g_Combo[id] > g_TOP_MaxComboHPerMap && !g_SpecialMode[id]) {
					g_TOP_MaxComboHPerMap = g_Combo[id];
					
					colorChat(id, CT, "%sConseguiste el !tcombo máximo humano!y (!gx%s!y) del mapa actual (!g%s!y)", ZP_PREFIX, sCombo, g_MapName);
					
					new Handle:sqlQuery;
					sqlQuery = SQL_PrepareQuery(g_SqlConnection, "INSERT INTO zp6_combos (`acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES ('%d', '%d', ^"%s^", ^"%s^", '0', '%d', UNIX_TIMESTAMP());",
					g_AccountId[id], g_AccountPJs[id][g_UserSelected[id]], g_UserName[id], g_MapName, g_TOP_MaxComboHPerMap);
					
					if(!SQL_Execute(sqlQuery)) {
						executeQuery(id, sqlQuery, 105);
					} else {
						SQL_FreeHandle(sqlQuery);
					}
				}
				
				g_Stats[id][STAT_DONE][STAT_COMBO] += g_Combo[id];
				
				if(g_Combo[id] > g_Stats[id][STAT_DONE][STAT_COMBO_MAX] && !g_SpecialMode[id]) {
					colorChat(id, _, "%sHas superado tu viejo mayor combo de !gx%d!y por el recién hecho de !gx%d!y", ZP_PREFIX, g_Stats[id][STAT_DONE][STAT_COMBO_MAX], g_Combo[id]);
					g_Stats[id][STAT_DONE][STAT_COMBO_MAX] = g_Combo[id];
				}
			}
		}
		
		g_Combo[id] = 0;
		g_ComboDamage[id] = 0;
		g_ComboReward[id] = 0;
		g_ExtraCombo[id] = 0;
	}
}

public showCurrentComboZombie(const id) {
	static iCombo;
	static iReward;
	static sReward[11];
	
	g_HLTime_Combo[id] = halflife_time() + 10.0;
	
	iCombo = g_Combo[id] - 1;
	
	iReward = comboZombie_CalculateReward(id);
	addDot(iReward, sReward, 10);
	
	set_hudmessage(__COMBOS_ZOMBIE[iCombo][comboRed], __COMBOS_ZOMBIE[iCombo][comboGreen], __COMBOS_ZOMBIE[iCombo][comboBlue], -1.0, g_Options_HUD_Position[id][HUD_COMBO][1], g_Options_HUD_Effect[id][HUD_COMBO], 0.0, 8.0, 0.0, 0.0, -1);
	
	if(!g_Options_HUD_Abrev[id][HUD_COMBO]) {
		ShowSyncHudMsg(id, g_Hud_Combo, "%s^nInfecciones x%d | + %s APs", __COMBOS_ZOMBIE[iCombo][comboName], g_Combo[id], sReward);
	} else {
		ShowSyncHudMsg(id, g_Hud_Combo, "%s^nx%d | + %s APs", __COMBOS_ZOMBIE[iCombo][comboName], g_Combo[id], sReward);
	}
}

public finishComboZombie(const id) {
	if(g_Combo[id]) {
		static iReward;
		iReward = comboZombie_CalculateReward(id);
		
		if(iReward) {
			addAmmopacks(id, iReward);
			
			static sReward[11];
			static iCombo;
			
			addDot(iReward, sReward, 10);
			
			iCombo = g_Combo[id] - 1;
			
			set_hudmessage(__COMBOS_ZOMBIE[iCombo][comboRed], __COMBOS_ZOMBIE[iCombo][comboGreen], __COMBOS_ZOMBIE[iCombo][comboBlue], -1.0, g_Options_HUD_Position[id][HUD_COMBO][1], g_Options_HUD_Effect[id][HUD_COMBO], 1.0, 5.0, 0.1, 3.0, -1);
			ShowSyncHudMsg(id, g_Hud_Combo, "%s^n+ %s APs^nInfecciones: %d", __COMBOS_ZOMBIE[iCombo][comboName], sReward, g_Combo[id]);
			
			if(g_Combo[id] > 6) {
				client_cmd(id, "spk ^"%s^"", __COMBOS_ZOMBIE[iCombo][random_num(comboSound, comboSound2)]);
			} else {
				client_cmd(id, "spk ^"%s^"", __COMBOS_ZOMBIE[iCombo][comboSound]);
			}
			
			if(g_Combo[id] > g_TOP_MaxComboZPerMap && !g_SpecialMode[id]) {
				g_TOP_MaxComboZPerMap = g_Combo[id];
				
				colorChat(id, TERRORIST, "%sConseguiste el !tcombo máximo zombie!y (!gx%d!y) del mapa actual (!g%s!y)", ZP_PREFIX, g_Combo[id], g_MapName);
				
				new Handle:sqlQuery;
				sqlQuery = SQL_PrepareQuery(g_SqlConnection, "INSERT INTO zp6_combos (`acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES ('%d', '%d', ^"%s^", ^"%s^", '1', '%d', UNIX_TIMESTAMP());",
				g_AccountId[id], g_AccountPJs[id][g_UserSelected[id]], g_UserName[id], g_MapName, g_TOP_MaxComboZPerMap);
				
				if(!SQL_Execute(sqlQuery)) {
					executeQuery(id, sqlQuery, 977019976);
				} else {
					SQL_FreeHandle(sqlQuery);
				}
			}
		}
	}
	
	g_Combo[id] = 0;
}

public comboZombie_CalculateReward(const id) {
	static Float:fCombo;
	static Float:fConversion;
	static Float:fReward;
	
	fConversion = float(__APS_THIS_LEVEL(id)) - float(__APS_THIS_LEVEL_REST1(id));
	fCombo = float(g_Combo[id]) * 0.25;
	
	fReward = (fConversion * fCombo) / 100.0;
	
	return (floatround(fReward) * g_Combo[id]);
}

humanMe(const id, survivor=0, wesker=0, jason=0, predator=0) { // hm_f
	if(g_HatId[id]) {
		if(is_valid_ent(g_HatEnt[id])) {
			entity_set_int(g_HatEnt[id], EV_INT_rendermode, kRenderNormal);
			entity_set_float(g_HatEnt[id], EV_FL_renderamt, 255.0);
		}
	}
	
	remove_task(id + TASK_MODEL);
	remove_task(id + TASK_BLOOD);
	
	g_SpecialMode[id] = MODE_NONE;
	
	g_Aura[id][auraOn] = 0;
	g_FirstZombie[id] = 0;
	g_Immunity[id] = 0;
	g_Zombie[id] = 0;
	g_CanBuy[id] = 1;
	
	if(g_Frozen[id]) {
		remove_task(id + TASK_FROZEN);
		task__RemoveFreeze(id + TASK_FROZEN);
	}
	
	strip_user_weapons(id);
	
	g_WeaponPrimaryActual[id] = 0;
	g_WeaponSecondaryActual[id] = 0;
	
	give_item(id, "weapon_knife");
	
	set_user_rendering(id);
	
	g_HumanClass[id] = g_HumanClassNext[id];
	
	static sCurrentModel[32];
	static iAlreadyHasModel;
	
	iAlreadyHasModel = 0;
	
	getUserModel(id, sCurrentModel, 31);
	
	if(survivor) {
		static Float:fHealth;
		static iHealth;
		
		g_SpecialMode[id] = MODE_SURVIVOR;
		
		iHealth = (100 * getUsersAlive()) + (g_Hab[id][CLASS_SURVIVOR][HAB_HEALTH] * __HABILITIES[CLASS_SURVIVOR][HAB_HEALTH][habValue]);
		g_Speed[id] = 275.0;
		
		give_item(id, "weapon_m249");
		// ExecuteHamB(Ham_GiveAmmo, id, MAX_BPAMMO[CSW_M249], AMMO_TYPE[CSW_M249], MAX_BPAMMO[CSW_M249]);
		
		g_UnlimitedClip[id] = 1;
		
		if(g_Mode != MODE_PLAGUE && g_Mode != MODE_ARMAGEDDON) {
			fHealth = float(iHealth);
			
			if(g_Difficults[id][DIFF_SURVIVOR] < DIFF_LEYENDA && g_Hab[id][CLASS_SURVIVOR][HAB_S_IMMUNITY]) {
				g_SurvivorImmunity[id] = 1;
				
				colorChat(id, _, "%sRecordá que tenes !ginmunidad!y, para activarla !gpresioná la tecla G!y", ZP_PREFIX);
			}
			
			g_Annihilation_Bomb[id] = 1;
			
			give_item(id, "weapon_hegrenade");
			
			g_Survivor_KillZombies[id] = 0;
			
			switch(g_Difficults[id][DIFF_SURVIVOR]) {
				case DIFF_AVANZADO: {
					fHealth *= 0.75;
				}
				case DIFF_EPICO: {
					fHealth *= 0.5;
					g_Speed[id] *= 0.75;
				}
				case DIFF_LEYENDA: {
					fHealth *= 0.25;
					g_Speed[id] *= 0.5;
				}
			}
			
			iHealth = floatround(fHealth);
		}
		
		set_user_health(id, iHealth);
		set_user_gravity(id, 1.0);
		
		g_MaxHealth[id] = iHealth;
		
		ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
		
		set_user_rendering(id, kRenderFxGlowShell, 0, 0, 255, kRenderNormal, 4);
		
		if(g_Mode != MODE_ARMAGEDDON) {
			g_Aura[id][auraOn] = 1;
			g_Aura[id][auraRed] = 0;
			g_Aura[id][auraGreen] = 0;
			g_Aura[id][auraBlue] = 255;
			g_Aura[id][auraRadius] = 45;
		}
		
		turnOffFlashlight(id);
		
		if(equal(sCurrentModel, g_MODEL_Survivor)) {
			iAlreadyHasModel = 1;
		}
		
		if(!iAlreadyHasModel) {
			copy(g_UserModel[id], 31, g_MODEL_Survivor);
		}
		
		copy(g_ClassName[id], 31, "Survivor");
	} else if(wesker) {
		static iHealth;
		
		g_SpecialMode[id] = MODE_WESKER;
		
		g_Wesker_LASER_Waste[id] = 0;
		g_Wesker_LASER[id] = 3;
		g_Wesker_LastLASER[id] = 0.0;
		
		colorChat(id, _, "%sRecordá que tenes !gtres LASER!y, para disparar, !gpresioná el clic secundario!y", ZP_PREFIX);
		
		iHealth = 60 * getUsersAlive();
		
		g_Speed[id] = 260.0;
		
		set_user_health(id, iHealth);
		set_user_gravity(id, 0.8);
		
		g_MaxHealth[id] = iHealth;
		
		ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
		
		set_user_rendering(id, kRenderFxGlowShell, 255, 255, 0, kRenderNormal, 4);
		
		g_Aura[id][auraOn] = 1;
		g_Aura[id][auraRed] = 255;
		g_Aura[id][auraGreen] = 255;
		g_Aura[id][auraBlue] = 0;
		g_Aura[id][auraRadius] = 45;
		
		strip_user_weapons(id);
		
		give_item(id, "weapon_deagle");
		// ExecuteHamB(Ham_GiveAmmo, id, MAX_BPAMMO[CSW_DEAGLE], AMMO_TYPE[CSW_DEAGLE], MAX_BPAMMO[CSW_DEAGLE]);
		
		g_UnlimitedClip[id] = 1;
		
		turnOffFlashlight(id);
		
		if(equal(sCurrentModel, g_MODEL_Wesker)) {
			iAlreadyHasModel = 1;
		}
		
		if(!iAlreadyHasModel) {
			copy(g_UserModel[id], 31, g_MODEL_Wesker);
		}
		
		copy(g_ClassName[id], 31, "Wesker");
	} else if(jason) {
		static iHealth;
		
		g_SpecialMode[id] = MODE_JASON;
		
		if(g_Hab[id][CLASS_JASON][HAB_J_TELEPORT]) {
			g_Jason_Teleport[id] = 1;
			
			colorChat(id, _, "%sRecordá que podés !gteletransportarte!y, para activarlo !gpresioná la tecla G!y", ZP_PREFIX);
		}
		
		iHealth = 80 * getUsersAlive();
		
		g_Speed[id] = 270.0;
		
		set_user_health(id, iHealth);
		set_user_gravity(id, 0.9);
		
		ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
		
		set_user_rendering(id, kRenderFxGlowShell, 255, 0, 255, kRenderNormal, 4);
		
		g_Aura[id][auraOn] = 1;
		g_Aura[id][auraRed] = 255;
		g_Aura[id][auraGreen] = 0;
		g_Aura[id][auraBlue] = 255;
		g_Aura[id][auraRadius] = 45;
		
		turnOffFlashlight(id);
		
		if(equal(sCurrentModel, g_MODEL_Jason)) {
			iAlreadyHasModel = 1;
		}
		
		if(!iAlreadyHasModel) {
			copy(g_UserModel[id], 31, g_MODEL_Jason);
		}
		
		copy(g_ClassName[id], 31, "Jason");
		
		replaceWeaponModels(id, CSW_KNIFE);
	} else if(predator) {
		g_Predator[id] = 1;
		g_Predator_Power[id] = 1;
		
		g_SpecialMode[id] = MODE_ALVSPRED;
		
		++g_Stats[id][STAT_DONE][STAT_PREDATOR_COUNT];
		
		colorChat(id, _, "%sRecordá que !gpresionando la G!y lanzás tu poder", ZP_PREFIX);
		
		static iHealth;
		iHealth = 200 * getUsersAlive();
		
		set_user_health(id, iHealth);
		set_user_gravity(id, 0.75);
		
		g_Speed[id] = 290.0;
		
		g_Aura[id][auraOn] = 1;
		g_Aura[id][auraRed] = 255;
		g_Aura[id][auraGreen] = 255;
		g_Aura[id][auraBlue] = 0;
		g_Aura[id][auraRadius] = 35;
		
		ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
		
		turnOffFlashlight(id);
		
		set_user_rendering(id, kRenderFxGlowShell, 255, 255, 0, kRenderNormal, 4);
		
		give_item(id, "weapon_m4a1");
		ExecuteHamB(Ham_GiveAmmo, id, MAX_BPAMMO[CSW_M4A1], AMMO_TYPE[CSW_M4A1], MAX_BPAMMO[CSW_M4A1]);
		
		g_UnlimitedClip[id] = 1;
		
		if(equal(sCurrentModel, g_MODEL_Predator)) {
			iAlreadyHasModel = 1;
		}
		
		if(!iAlreadyHasModel) {
			copy(g_UserModel[id], 31, g_MODEL_Predator);
		}
		
		copy(g_ClassName[id], 31, "Depredador");
	} else {
		static iHealth;
		
		iHealth = HUMAN_HEALTH(id);
		
		set_user_health(id, iHealth);
		set_user_armor(id, HUMAN_ARMOR(id));
		set_user_gravity(id, Float:HUMAN_GRAVITY(id));
		g_Speed[id] = Float:HUMAN_SPEED(id);
		
		ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
		
		set_task(0.2, "showMenu__BuyPrimaryWeapons", id + TASK_SPAWN);
		
		emit_sound(id, CHAN_ITEM, g_SOUND_Antidote, 1.0, ATTN_NORM, 0, PITCH_NORM);
		
		if(equal(sCurrentModel, CLASES_HUMANAS[g_HumanClass[id]][humanModel])) {
			iAlreadyHasModel = 1;
		}
		
		if(!iAlreadyHasModel) {
			copy(g_UserModel[id], 31, CLASES_HUMANAS[g_HumanClass[id]][humanModel]);
		}
	}
	
	if(getUserTeam(id) != FM_CS_TEAM_CT) {
		remove_task(id + TASK_TEAM);
		
		setUserTeam(id, FM_CS_TEAM_CT);
		userTeamUpdate(id);
	}
	
	if(!iAlreadyHasModel) {
		if(g_NewRound) {
			set_task(5.0 * MODELS_CHANGE_DELAY, "userModelUpdate", id + TASK_MODEL);
		} else {
			userModelUpdate(id + TASK_MODEL);
		}
	}
	
	message_begin(MSG_ONE, g_Message_Fov, _, id);
	write_byte(90);
	message_end();
	
	if(g_Nightvision[id]) {
		setNightvision(id, 0);
	}
	
	checkLastZombie();
}

zombieMe(const id, attacker=0, firstZombie=0, nemesis=0, bomb=0, alien=0, troll=0, assassin=0, megaNemesis=0) { // zm_f
	if(!g_IsAlive[id]) {
		return;
	}
	
	if(g_HatId[id]) {
		if(is_valid_ent(g_HatEnt[id])) {
			entity_set_int(g_HatEnt[id], EV_INT_rendermode, kRenderTransAlpha);
			entity_set_float(g_HatEnt[id], EV_FL_renderamt, 0.0);
		}
	}
	
	remove_task(id + TASK_MODEL);
	remove_task(id + TASK_BLOOD);
	remove_task(id + TASK_BURN);
	
	if(g_Immunity[attacker]) {
		randomSpawn(id);
		colorChat(id, _, "%sHas sido teletransportado porque te infectó un zombie bajo los efectos de la furia!", ZP_PREFIX); // Para que no tosqueen al zombie con furia cuando infectan en algún ducto o algo similar!
	} else if(isUserStuck(id)) {
		randomSpawn(id);
		colorChat(id, _, "%sHas sido teletransportado porque te habías trabado con un humano!", ZP_PREFIX);
	}
	
	if(attacker) {
		finishComboHuman(id);
	}
	
	g_SpecialMode[id] = MODE_NONE;
	
	g_ZombieClass[id] = g_ZombieClassNext[id];
	g_FirstZombie[id] = 0;
	g_Immunity[id] = 0;
	g_Zombie[id] = 1;
	
	set_user_rendering(id);
	
	cs_set_user_zoom(id, CS_RESET_ZOOM, 1);
	set_user_armor(id, 0);
	
	strip_user_weapons(id);
	
	g_WeaponPrimaryActual[id] = 0;
	g_WeaponSecondaryActual[id] = 0;
	
	give_item(id, "weapon_knife");
	
	copy(g_ClassName[id], 31, CLASES_ZOMBIE[g_ZombieClass[id]][zombieName]);
	
	if(attacker) { // Fue infectado por otra persona ?
		if(!bomb) { // Fue infectado por una persona ?
			static iConversion;
			static iReward;
			
			iConversion = __APS_THIS_LEVEL(attacker) - __APS_THIS_LEVEL_REST1(attacker);
			iReward = (iConversion * 2) / 100; // Ganas el 2% de tu nivel por cada infección!
			
			addAmmopacks(attacker, iReward);
			
			if(g_Immunity[attacker]) {
				++g_InfectsWithSameFury[attacker];
				
				if(g_InfectsWithSameFury[attacker] == 5) {
					giveHat(attacker, HAT_ITACHI);
				}
				
				++g_InfectsWithFury[attacker];
				
				if(g_FuryConsecutive[attacker] == 2) {
					if(g_InfectsWithFury[attacker] >= 15) {
						setAchievement(attacker, YO_FUI);
					}
				}
			} else {
				if(g_Health[attacker] >= g_MaxHealth[attacker]) {
					++g_InfectsWithMaxHealth[attacker];
					
					if(g_InfectsWithMaxHealth[attacker] == 5) {
						setAchievement(attacker, YO_NO_FUI);
					}
				}
				
				if(g_Mode == MODE_INFECTION) {
					++g_InfectsInRound[attacker];
					
					if(g_InfectsInRound[attacker] == 20) {
						setAchievement(attacker, VIRUS);
					}
				}
			}
			
			if(g_Induccion[attacker] && !g_Immunity[attacker]) {
				if(random_num(1, 100) <= g_Induccion[attacker]) {
					if(!g_Frozen[attacker]) {
						if(g_Mode == MODE_INFECTION || g_Mode == MODE_MULTI) {
							g_Immunity[attacker] = 1;
							
							g_Aura[attacker][auraOn] = 1;
							g_Aura[attacker][auraRed] = 255;
							g_Aura[attacker][auraGreen] = 0;
							g_Aura[attacker][auraBlue] = 0;
							g_Aura[attacker][auraRadius] = 25;
							
							emit_sound(attacker, CHAN_BODY, g_SOUND_Zombie_Madness, 1.0, ATTN_NORM, 0, random_num(50, 200));
							
							remove_task(attacker + TASK_BLOOD);
							set_task(4.0, "task__MadnessOver", attacker + TASK_BLOOD);
						}
					}
				}
			}
			
			++g_Mercenario_Infects[attacker];
			
			if(g_Mercenario_Infects[attacker] == 10) {
				setAchievement(attacker, ME_ESTA_GUSTANDO_ESTO);
				
				if(g_Mercenario_Kills[attacker] >= 10) {
					setAchievement(attacker, MERCENARIO);
				}
			}
			
			g_LaSaludEsLoPrimero[id] = 0;
			
			if(g_Hab[attacker][CLASS_ZOMBIE][HAB_Z_COMBO]) {
				++g_Combo[attacker];
				
				showCurrentComboZombie(attacker);
			}
		} else { // Fue infectado por una bomba ?
			
		}
		
		g_ImmunityBombs[attacker] = 0;
		
		++g_Stats[attacker][STAT_DONE][STAT_INFECTIONS];
		++g_Stats[id][STAT_TAKEN][STAT_INFECTIONS];
		
		if((g_Stats[attacker][STAT_DONE][STAT_INFECTIONS] % 500) == 0) {
			switch(g_Stats[attacker][STAT_DONE][STAT_INFECTIONS]) {
				case 500: {
					setAchievement(attacker, HUMANOS_x500);
				} case 1000: {
					setAchievement(attacker, HUMANOS_x1000);
				} case 2500: {
					setAchievement(attacker, HUMANOS_x2500);
				} case 5000: {
					setAchievement(attacker, HUMANOS_x5000);
				} case 10000: {
					setAchievement(attacker, HUMANOS_x10K);
				} case 25000: {
					setAchievement(attacker, HUMANOS_x25K);
				} case 50000: {
					setAchievement(attacker, HUMANOS_x50K);
				} case 100000: {
					setAchievement(attacker, HUMANOS_x100K);
				} case 250000: {
					setAchievement(attacker, HUMANOS_x250K);
				} case 500000: {
					setAchievement(attacker, HUMANOS_x500K);
				} case 1000000: {
					setAchievement(attacker, HUMANOS_x1M);
				} case 5000000: {
					setAchievement(attacker, HUMANOS_x5M);
				}
			}
		} else if(g_Stats[attacker][STAT_DONE][STAT_INFECTIONS] <= 100) {
			switch(g_Stats[attacker][STAT_DONE][STAT_INFECTIONS]) {
				case 25: {
					giveHat(attacker, HAT_DARTH_VADER);
				} case 100: {
					setAchievement(attacker, HUMANOS_x100);
				}
			}
		}
		
		emit_sound(id, CHAN_VOICE, g_SOUND_Zombie_Infect[random_num(0, charsmax(g_SOUND_Zombie_Infect))], 1.0, ATTN_NORM, 0, PITCH_NORM);
		
		static iHealth;
		
		iHealth = ZOMBIE_HEALTH(id);
		
		set_user_health(id, iHealth);
		set_user_gravity(id, Float:ZOMBIE_GRAVITY(id));
		g_Speed[id] = Float:ZOMBIE_SPEED(id);
		
		g_MaxHealth[id] = iHealth;
		
		sendDeathMsg(attacker, id);
		fixDeadAttrib(id);
	} else { // Fue infectado a través de un comando/modo o porque renació como zombie!
		static iHealth;
		
		if(nemesis) {
			setLight(id, "i");
			
			g_fwUpdateClientData_Post = register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", 1);
			
			static Float:fHealth;
			
			g_SpecialMode[id] = MODE_NEMESIS;
			
			set_pdata_int(id, OFFSET_LONG_JUMP, 1, OFFSET_LINUX);
			
			g_LongJump[id] = 1;
			g_InJump[id] = 0;
			
			iHealth = (15000 * getUsersAlive()) + (g_Hab[id][CLASS_NEMESIS][HAB_HEALTH] * __HABILITIES[CLASS_NEMESIS][HAB_HEALTH][habValue]);
			g_Speed[id] = 280.0;
			
			if(g_Mode != MODE_PLAGUE && g_Mode != MODE_ARMAGEDDON) {
				g_Nemesis_LongJump_Count = 0;
				g_Nemesis_KillHumans[id] = 0;
				
				if(g_Difficults[id][DIFF_NEMESIS] <= DIFF_AVANZADO) {
					g_Bazooka[id] = 1;
					give_item(id, "weapon_ak47");
					
					cs_set_user_bpammo(id, CSW_AK47, 0);
					set_pdata_int(findEntByOwner(id, "weapon_ak47"), OFFSET_CLIPAMMO, 0, OFFSET_LINUX_WEAPONS);
					
					colorChat(id, _, "%sRecordá que !gtenés una bazooka!y, para seleccionarla !gpresioná la tecla 1!y", ZP_PREFIX);
				}
				
				fHealth = float(iHealth);
				
				switch(g_Difficults[id][DIFF_NEMESIS]) {
					case DIFF_AVANZADO: {
						fHealth *= 0.75;
					}
					case DIFF_EPICO: {
						fHealth *= 0.5;
						g_Speed[id] *= 0.75;
					}
					case DIFF_LEYENDA: {
						fHealth *= 0.25;
						g_Speed[id] *= 0.5;
					}
				}
				
				iHealth = floatround(fHealth);
			}
			
			g_CurrentWeapon[id] = CSW_KNIFE;
			engclient_cmd(id, "weapon_knife");
			
			set_user_health(id, iHealth);
			set_user_gravity(id, 0.5);
			
			g_MaxHealth[id] = iHealth;
			
			ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
			
			set_user_rendering(id, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 4);
			
			copy(g_ClassName[id], 31, "Nemesis");
			
			if(g_Mode != MODE_ARMAGEDDON) {
				g_Aura[id][auraOn] = 1;
				g_Aura[id][auraRed] = 255;
				g_Aura[id][auraGreen] = 0;
				g_Aura[id][auraBlue] = 0;
				g_Aura[id][auraRadius] = 25;
			}
			
			replaceWeaponModels(id, CSW_KNIFE);
		} else if(alien) {
			g_Alien[id] = 1;
			g_Alien_Power[id] = 1;
			
			g_SpecialMode[id] = MODE_ALVSPRED;
			
			++g_Stats[id][STAT_DONE][STAT_ALIEN_COUNT];
			
			colorChat(id, _, "%sRecordá que !gpresionando la G!y lanzás tu poder", ZP_PREFIX);
			colorChat(id, _, "%sRecordá que !gpresionando la E!y podés escalar las paredes", ZP_PREFIX);
			
			static iHealth;
			iHealth = 50000 + (4560 * (getUsersAlive()));
			
			g_Speed[id] = 400.0;
			
			set_user_health(id, iHealth);
			set_user_gravity(id, 0.75);
			
			g_MaxHealth[id] = iHealth;
			
			g_CurrentWeapon[id] = CSW_KNIFE;
			engclient_cmd(id, "weapon_knife");
			
			ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
			
			copy(g_ClassName[id], 31, "Alien");
			
			replaceWeaponModels(id, CSW_KNIFE);
		} else if(troll) {
			g_SpecialMode[id] = MODE_TROLL;
			
			g_Troll_Power[id] = 1;
			
			colorChat(id, _, "%sRecordá que !gtenés un poder!y, para activarlo !gpresioná la tecla G!y", ZP_PREFIX);
			
			g_CurrentWeapon[id] = CSW_KNIFE;
			engclient_cmd(id, "weapon_knife");
			
			iHealth = (100 * getUsersAlive());
			g_Speed[id] = 250.0;
			
			set_user_health(id, iHealth);
			set_user_gravity(id, 1.0);
			
			g_MaxHealth[id] = iHealth;
			
			ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
			
			copy(g_ClassName[id], 31, "Troll");
			
			replaceWeaponModels(id, CSW_KNIFE);
		} else if(assassin) {
			
		} else if(megaNemesis) {
			
		} else if(firstZombie) {
			if(g_FirstZombie_Consecutive == id) {
				setAchievement(id, YA_DE_ZOMBIE);
			}
			
			g_FirstZombie_Consecutive = id;
			
			g_FirstZombie[id] = 1;
			g_ImmunityBombs[id] = 1;
			
			set_pdata_int(id, OFFSET_LONG_JUMP, 1, OFFSET_LINUX);
			
			g_LongJump[id] = 1;
			g_InJump[id] = 0;
			
			remove_task(id + TASK_IMMUNITY_BOMBS);
			set_task(20.0, "task__RemoveImmunityBombs", id + TASK_IMMUNITY_BOMBS);
			
			iHealth = ZOMBIE_HEALTH(id) * 2;
			
			set_user_health(id, iHealth);
			set_user_gravity(id, Float:ZOMBIE_GRAVITY(id));
			g_Speed[id] = Float:ZOMBIE_SPEED(id);
			
			g_MaxHealth[id] = iHealth;
			
			g_Immunity[id] = 1;
			
			g_Aura[id][auraOn] = 1;
			g_Aura[id][auraRed] = 255;
			g_Aura[id][auraGreen] = 0;
			g_Aura[id][auraBlue] = 0;
			g_Aura[id][auraRadius] = 25;
			
			g_InfectsWithFury[id] = -100; // Para evitar que la furia zombie gratuita del primer zombie le de ciertos logros!
			
			emit_sound(id, CHAN_BODY, g_SOUND_Zombie_Madness, 1.0, ATTN_NORM, 0, random_num(50, 200));
			
			remove_task(id + TASK_BLOOD);
			set_task(4.0, "task__MadnessOver", id + TASK_BLOOD);
			
			setAchievement(id, ARE_YOU_FUCKING_KIDDING_ME);
		} else {
			iHealth = ZOMBIE_HEALTH(id);
			
			if(g_DeadTimes[id] > 0) {
				static iExtraHealth;
				static sExtraHealth[11];
				
				iExtraHealth = (iHealth * (g_DeadTimes[id] * 5)) / 100;
				
				iHealth += iExtraHealth;
				
				addDot(iExtraHealth, sExtraHealth, 10);
				
				colorChat(id, _, "%sAhora tenés !g+%s!y de vida como zombie hasta que finalice la ronda!", ZP_PREFIX, sExtraHealth);
			}
			
			set_user_health(id, iHealth);
			set_user_gravity(id, Float:ZOMBIE_GRAVITY(id));
			g_Speed[id] = Float:ZOMBIE_SPEED(id);
			
			g_MaxHealth[id] = iHealth;
			
			emit_sound(id, CHAN_VOICE, g_SOUND_Zombie_Alert[random_num(0, charsmax(g_SOUND_Zombie_Alert))], 1.0, ATTN_NORM, 0, PITCH_NORM);
		}
	}
	
	ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
	
	if(getUserTeam(id) != FM_CS_TEAM_T) {
		remove_task(id + TASK_TEAM);
		
		setUserTeam(id, FM_CS_TEAM_T);
		userTeamUpdate(id);
	}
	
	static sCurrentModel[32];
	static iAlreadyHasModel;
	
	iAlreadyHasModel = 0;
	
	getUserModel(id, sCurrentModel, 31);
	
	switch(g_SpecialMode[id]) {
		case MODE_NEMESIS: {
			if(equal(sCurrentModel, g_MODEL_Nemesis)) {
				iAlreadyHasModel = 1;
			}
			
			if(!iAlreadyHasModel) {
				copy(g_UserModel[id], 31, g_MODEL_Nemesis);
			}
		} case MODE_TROLL: {
			if(equal(sCurrentModel, g_MODEL_Troll)) {
				iAlreadyHasModel = 1;
			}
			
			if(!iAlreadyHasModel) {
				copy(g_UserModel[id], 31, g_MODEL_Troll);
			}
		} case MODE_ALVSPRED: {
			if(equal(sCurrentModel, g_MODEL_Alien)) {
				iAlreadyHasModel = 1;
			}
			
			if(!iAlreadyHasModel) {
				copy(g_UserModel[id], 31, g_MODEL_Alien);
			}
		} default: {
			if(equal(sCurrentModel, CLASES_ZOMBIE[g_ZombieClass[id]][zombieModel])) {
				iAlreadyHasModel = 1;
			}
			
			if(!iAlreadyHasModel) {
				copy(g_UserModel[id], 31, CLASES_ZOMBIE[g_ZombieClass[id]][zombieModel]);
			}
		}
	}
	
	if(!iAlreadyHasModel) {
		if(g_NewRound) {
			set_task((5.0 * MODELS_CHANGE_DELAY), "userModelUpdate", id + TASK_MODEL);
		} else {
			userModelUpdate(id + TASK_MODEL);
		}
	}
	
	if(g_Mode != MODE_ARMAGEDDON && g_Mode != MODE_NEMESIS && g_Mode != MODE_TROLL) {
		message_begin(MSG_ONE_UNRELIABLE, g_Message_ScreenShake, _, id);
		write_short(UNIT_SECOND * 4);
		write_short(UNIT_SECOND * 2);
		write_short(UNIT_SECOND * 10);
		message_end();
		
		setNightvision(id, 1);
	}
	
	message_begin(MSG_ONE, g_Message_Fov, _, id);
	write_byte(110);
	message_end();
	
	turnOffFlashlight(id);
	
	checkLastZombie();
}

public setUserMaxspeed(const id) {
	set_user_maxspeed(id, g_Speed[id]);
}

public showMenu__Register_Login(const id) {
	if(!g_IsConnected[id]) {
		return;
	}
	
	showLogo(id, LOGO_NONE);
	
	static sMenu[100];
	formatex(sMenu, charsmax(sMenu), "\yBienvenido a Zombie Plague \r%s^n^n\r1.\w Crear nueva cuenta^n\r2.\w Identificarse^n^n", PLUGIN_VERSION);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Register Login Menu");
}

public menu__RegisterLogin(const id, const key) {
	if(!g_IsConnected[id] || g_AccountLogged[id]) {
		return PLUGIN_HANDLED;
	}
	
	switch(key) {
		case 0: {
			client_cmd(id, "messagemode CREAR_CUENTA");
			client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonOk);
			
			showLogo(id, LOGO_CREAR_CUENTA);
			
			// colorChat(id, CT, "%s!tEscribe el nombre de tu cuenta, este !gno será tu nick!t. Solo letras y sin espacios!", ZP_PREFIX);
		}
		case 1: {
			client_cmd(id, "messagemode IDENTIFICAR_CUENTA");
			client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonOk);
			
			showLogo(id, LOGO_IDENTIFICAR_CUENTA);
			
			// colorChat(id, CT, "%s!tEscribe el nombre de tu cuenta! Si olvidaste tus datos puedes recuperarlos a través del panel de control!", ZP_PREFIX);
		}
		default: {
			showMenu__Register_Login(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

public clcmd__CreateAccount(const id) {
	if(!g_IsConnected[id] || g_AccountLogged[id]) {
		return PLUGIN_HANDLED;
	}
	
	new sAccount[32];
	
	read_args(sAccount, 31);
	remove_quotes(sAccount);
	trim(sAccount);
	
	if(contain(sAccount, " ") != -1) {
		colorChat(id, TERRORIST, "%s!tEl nombre de tu cuenta no puede contener espacios!", ZP_PREFIX);
		
		client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonBad);
		
		showMenu__Register_Login(id);
		return PLUGIN_HANDLED;
	} else if(!containLetters(sAccount) || countNumbers(sAccount)) {
		colorChat(id, TERRORIST, "%s!tEl nombre de tu cuenta solo puede contener letras!", ZP_PREFIX);
		
		client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonBad);
		
		showMenu__Register_Login(id);
		return PLUGIN_HANDLED;
	}
	
	new iLenAccount = strlen(sAccount);
	
	if(iLenAccount < 3) {
		colorChat(id, TERRORIST, "%s!tEl nombre de tu cuenta debe tener al menos tres caracteres!", ZP_PREFIX);
		
		client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonBad);
		
		showMenu__Register_Login(id);
		return PLUGIN_HANDLED;
	}
	
	strtolower(sAccount);
	
	copy(g_AccountName[id], 31, sAccount);
	
	// Uso ThreadQuery por si algún pelotudo intenta floodear (aunque no se frizzea).
	new sQuery[90];
	new iData[2];
	
	iData[0] = id;
	iData[1] = CHECK_ACCOUNT_NAME;
	
	formatex(sQuery, 89, "SELECT id FROM zp6_accounts WHERE acc_name=^"%s^" LIMIT 1;", sAccount);
	SQL_ThreadQuery(g_SqlTuple, "sqlThread__CheckName", sQuery, iData, 2);
	
	return PLUGIN_HANDLED;
}

public clcmd__CreatePassword(const id) {
	if(!g_IsConnected[id] || g_AccountLogged[id]) {
		return PLUGIN_HANDLED;
	}
	
	new sPassword[32];
	
	read_args(sPassword, 31);
	remove_quotes(sPassword);
	trim(sPassword);
	
	if(contain(sPassword, "%") != -1) {
		colorChat(id, TERRORIST, "%s!tTu contraseña no puede contener el simbolo %%", ZP_PREFIX);
		
		client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonBad);
		
		showMenu__Register_Login(id);
		return PLUGIN_HANDLED;
	}
	
	new iLenPassword = strlen(sPassword);
	
	if(iLenPassword < 4) {
		colorChat(id, TERRORIST, "%s!tLa contraseña debe tener al menos cuatro caracteres!", ZP_PREFIX);
		
		client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonBad);
		
		showMenu__Register_Login(id);
		return PLUGIN_HANDLED;
	} else if(iLenPassword > 30) {
		colorChat(id, TERRORIST, "%s!tLa contraseña no puede superar los treinta caracteres!", ZP_PREFIX);
		
		client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonBad);
		
		showMenu__Register_Login(id);
		return PLUGIN_HANDLED;
	}
	
	copy(g_AccountPassword[id], 31, sPassword);
	
	client_cmd(id, "messagemode REPETIR_CONTRASENIA");
	client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonOk);
	
	showLogo(id, LOGO_REPETIR_PASSWORD);
	
	// colorChat(id, CT, "%s!tEscriba la contraseña nuevamente para su confirmación!", ZP_PREFIX);
	
	return PLUGIN_HANDLED;
}

public clcmd__RepeatPassword(const id) {
	if(!g_IsConnected[id] || g_AccountLogged[id]) {
		return PLUGIN_HANDLED;
	}
	
	new sPassword[32];
	
	read_args(sPassword, 31);
	remove_quotes(sPassword);
	trim(sPassword);
	
	if(!equal(g_AccountPassword[id], sPassword)) {
		g_AccountName[id][0] = EOS;
		g_AccountPassword[id][0] = EOS;
	
		showMenu__Register_Login(id);
		
		client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonBad);
		
		colorChat(id, TERRORIST, "%s!tLa contraseña escrita no coincide con la anterior!", ZP_PREFIX);
		return PLUGIN_HANDLED;
	}
	
	if(g_AccountHID[id][0] == '!') {
		new OrpheuHook:handlePrintF;
		handlePrintF = OrpheuRegisterHook(OrpheuGetFunction("Con_Printf"), "Con_Printf");
		
		server_cmd("sxe_userhid #%d", get_user_userid(id));
		server_exec();
		
		OrpheuUnregisterHook(handlePrintF);
		
		copy(g_AccountHID[id], 63, g_MessageHID);
		
		replace_all(g_AccountHID[id], 63, "sxei_userhid: ", "");
		replace_all(g_AccountHID[id], 63, "[", "");
		replace_all(g_AccountHID[id], 63, "]", "");
		replace_all(g_AccountHID[id], 63, "^n", "");
		
		if(g_AccountHID[id][0] == '!' || equali(g_AccountHID[id], "no HID present, try again.") || equali(g_AccountHID[id], "") || containi(g_AccountHID[id], " ") != -1) {
			server_cmd("kick #%d ^"No se pudo obtener tu HID. Error sXe-I^"", get_user_userid(id));
			return PLUGIN_HANDLED;
		}
	}
	
	// Fixea el formato de DATE_FORMAT() de MySQL porque usa %d , %i , %s para obtener datos y los confunde con parámetros de Pawn.
	new sFix1[3];
	new sFix2[3];
	new sFix3[5];
	new sFix4[3];
	new sFix5[3];
	new sFix6[3];
	
	formatex(sFix1, 2, "pa");
	formatex(sFix2, 2, "pe");
	formatex(sFix3, 4, "pi");
	formatex(sFix4, 2, "po");
	formatex(sFix5, 2, "pu");
	formatex(sFix6, 2, "pt");
	
	replace(sFix1, 2, "pa", "%d");
	replace(sFix2, 2, "pe", "%m");
	replace(sFix3, 4, "pi", "%Y");
	replace(sFix4, 2, "po", "%k");
	replace(sFix5, 2, "pu", "%i");
	replace(sFix6, 2, "pt", "%s");
	
	// Está baneado el HID ?
	new Handle:sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT start, finish, DATE_FORMAT(FROM_UNIXTIME(start), ^"%s-%s-%s %s:%s:%s^"), DATE_FORMAT(FROM_UNIXTIME(finish), ^"%s-%s-%s %s:%s:%s^"), \
	name_admin, reason, pj_name FROM zp6_bans WHERE (hid = ^"%s^") AND activo = '1' LIMIT 1;", sFix1, sFix2, sFix3, sFix4, sFix5, sFix6, sFix1, sFix2, sFix3, sFix4, sFix5, sFix6, g_AccountHID[id]);
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(id, sqlQuery, 2100);
	} else if(SQL_NumResults(sqlQuery)) {
		new iStart;
		new iFinish;
		
		iStart = SQL_ReadResult(sqlQuery, 0);
		iFinish = SQL_ReadResult(sqlQuery, 1);
		
		if(iFinish > iStart) { // Sigue baneado
			g_AccountBanned[id] = 1;
			
			SQL_ReadResult(sqlQuery, 2, g_AccountBan_Start[id], 31);
			SQL_ReadResult(sqlQuery, 3, g_AccountBan_Finish[id], 31);
			SQL_ReadResult(sqlQuery, 4, g_AccountBan_Admin[id], 31);
			SQL_ReadResult(sqlQuery, 5, g_AccountBan_Reason[id], 127);
			SQL_ReadResult(sqlQuery, 6, g_AccountBan_PJName[id], 31);
			
			return PLUGIN_HANDLED;
		} else { // Finalizó su ban, desbanearlo!
			colorChat(0, TERRORIST, "%sEl usuario !t%s!y tenía !gban de cuenta!y pero ya puede volver a jugar!", ZP_PREFIX, g_UserName[id]);
			
			sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE zp6_bans SET activo = '0' WHERE (hid = ^"%s^") AND activo = '1';", g_AccountHID[id]);
			if(!SQL_Execute(sqlQuery)) {
				executeQuery(id, sqlQuery, 2200);
			} else {
				SQL_FreeHandle(sqlQuery);
			}
		}
		
		SQL_FreeHandle(sqlQuery);
	} else {
		SQL_FreeHandle(sqlQuery);
	}
	
	
	new sIP[21];
	new sMD5_Password[34];
	
	get_user_ip(id, sIP, 20, 1);
	
	md5(sPassword, sMD5_Password);
	sMD5_Password[6] = EOS;
	
	client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonOk);
	
	g_AccountPJs[id] = {0, 0, 0, 0};
	
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "INSERT INTO zp6_accounts (`acc_name`, `password`, `ip`, `hid`, `register`, `last_connect`) VALUES (^"%s^", ^"%s^", INET_ATON(^"%s^"), ^"%s^", UNIX_TIMESTAMP(), UNIX_TIMESTAMP());",
	g_AccountName[id], sMD5_Password, sIP, g_AccountHID[id]);
	
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(id, sqlQuery, 2300);
	} else {
		SQL_FreeHandle(sqlQuery);
		
		resetInfo(id);
		
		client_cmd(id, "setinfo zp5 ^"%s^"", sMD5_Password);
		client_cmd(id, "setinfo zp6 ^"%s^"", g_AccountName[id]);
		
		set_user_info(id, "zp5", sMD5_Password);
		set_user_info(id, "zp6", g_AccountName[id]);
		
		task__CheckAccount(id);
		
		g_AccountLogged[id] = 1;
		
		showMenu__ChoosePJ(id);
	}
	
	return PLUGIN_HANDLED;
}

public clcmd__LoginAccount(const id) {
	if(!g_IsConnected[id] || g_AccountLogged[id]) {
		return PLUGIN_HANDLED;
	}
	
	new sAccount[32];
	
	read_args(sAccount, 31);
	remove_quotes(sAccount);
	trim(sAccount);
	
	if(contain(sAccount, " ") != -1) {
		colorChat(id, TERRORIST, "%s!tTu contraseña no puede contener espacios!", ZP_PREFIX);
		
		client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonBad);
		
		showMenu__Register_Login(id);
		return PLUGIN_HANDLED;
	} else if(!containLetters(sAccount) || countNumbers(sAccount)) {
		colorChat(id, TERRORIST, "%s!tEl nombre de tu cuenta solo puede contener letras!", ZP_PREFIX);
		
		client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonBad);
		
		showMenu__Register_Login(id);
		return PLUGIN_HANDLED;
	}
	
	strtolower(sAccount);
	
	copy(g_AccountName[id], 31, sAccount);
	
	// Uso ThreadQuery por si algún pelotudo intenta floodear (aunque no se frizzea).
	
	new sQuery[90];
	new iData[2];
	
	iData[0] = id;
	iData[1] = CHECK_ACCOUNT_NAME_02;
	
	formatex(sQuery, 89, "SELECT id FROM zp6_accounts WHERE acc_name=^"%s^" LIMIT 1;", sAccount);
	SQL_ThreadQuery(g_SqlTuple, "sqlThread__CheckName", sQuery, iData, 2);
	
	return PLUGIN_HANDLED;
}

public clcmd__LoginPassword(const id) {
	if(!g_IsConnected[id] || g_AccountLogged[id]) {
		return PLUGIN_HANDLED;
	}
	
	new sPassword[32];
	new sMD5_Password[34];
	
	read_args(sPassword, 31);
	remove_quotes(sPassword);
	trim(sPassword);
	
	md5(sPassword, sMD5_Password);
	sMD5_Password[6] = EOS;
	
	if(!equal(g_AccountPassword[id], sMD5_Password)) {
		showMenu__Register_Login(id);
		
		client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonBad);
		
		colorChat(id, TERRORIST, "%s!tLa contraseña ingresada no coincide con la de esta cuenta!", ZP_PREFIX);		
		return PLUGIN_HANDLED;
	}
	
	client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonOk);
	
	g_AccountLogged[id] = 1;
	
	client_cmd(id, "setinfo zp5 ^"%s^"", sMD5_Password);
	set_user_info(id, "zp5", sMD5_Password);
	
	showMenu__ChoosePJ(id);
	return PLUGIN_HANDLED;
}

public showMenu__ChoosePJ(const id) {
	if(!g_IsConnected[id]) {
		return;
	}
	
	g_AllowChangeName_SPECIAL[id] = 0;
	
	showLogo(id, LOGO_NONE);
	
	static sMenu[400];
	static iLen;
	static i;
	
	iLen = 0;
	
	if(g_AccountId[id] > 999) {
		static sItem[11];
		addDot(g_AccountId[id], sItem, 10);
		
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yBienvenido a Zombie Plague \r%s^n\wCuenta \y#%s^n\wVinculada a la web: %s^n^n", PLUGIN_VERSION, sItem, (!g_Vinc[id]) ? "\rNo" : "\ySi");
	} else {
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yBienvenido a Zombie Plague \r%s^n\wCuenta \y#%d^n\wVinculada a la web: %s^n^n", PLUGIN_VERSION, g_AccountId[id], (!g_Vinc[id]) ? "\rNo" : "\ySi");
	}
	
	for(i = 0; i < 4; ++i) {
		if(g_AccountPJs[id][i]) {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\w %s \y[R\r:\y %d][LV\r:\y %d]^n^n", (i + 1), g_AccountPJ_Name[id][i], g_AccountPJ_Reset[id][i], g_AccountPJ_Level[id][i]);
		} else {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\d Crear Personaje . . .^n^n", (i + 1));
		}
	}
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n^n^n\r6.\w Desloguearse");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Choose PJ");
}

public menu__ChoosePJ(const id, const key) {
	if(!g_IsConnected[id]) {
		return PLUGIN_HANDLED;
	}
	
	if(!g_AccountLogged[id]) {
		return PLUGIN_HANDLED;
	}
	
	switch(key) {
		case 0..3: {
			g_UserSelected[id] = key;
			
			if(g_AccountPJs[id][key]) {
				loadInfo(id, key);
			} else {
				showMenu__ConfirmName(id);
			} 
			// else {
				// colorChat(id, TERRORIST, "%s!tATENCIÓN:!y Vincula tu cuenta del ZP y !gsigue los pasos!y que se muestran en la web. !gzp.cimsp.net/panel!y", ZP_PREFIX);
				// colorChat(id, TERRORIST, "%sUna vez hecha la vinculación, el sistema cargará tus puntos de legado correspondientes.", ZP_PREFIX);
				
				// showMenu__ChoosePJ(id);
			// }
		}
		case 5: {
			g_AccountLogged[id] = 0;
			g_AccountPJ_Logged[id] = 0;
			
			client_cmd(id, "setinfo zp5 ^"^"");
			client_cmd(id, "setinfo zp6 ^"^"");
			
			set_user_info(id, "zp5", "");
			set_user_info(id, "zp6", "");
			
			showMenu__Register_Login(id);
		}
		default: {
			showMenu__ChoosePJ(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__ConfirmName(const id) {
	if(!g_IsConnected[id]) {
		return;
	}
	
	static sMenu[140];
	formatex(sMenu, charsmax(sMenu), "\yCREANDO PERSONAJE . . .^n^n\wQueres usar el nombre \y%s\w ?^n^n\r1.\w Si^n\r2.\w No, elegir otro nombre", g_UserName[id]);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Confirm Name");
}

public menu__ConfirmName(const id, const key) {
	if(!g_IsConnected[id]) {
		return PLUGIN_HANDLED;
	}
	
	if(!g_AccountLogged[id]) {
		return PLUGIN_HANDLED;
	}
	
	switch(key) {
		case 0: {
			if(!g_AccountPJs[id][g_UserSelected[id]]) {
				if(!equali(g_UserName[id], "unnamed")) {
					// Uso ThreadQuery por si algún pelotudo intenta floodear (aunque no se frizzea).
					
					new sQuery[90];
					new iData[2];
					
					iData[0] = id;
					iData[1] = CHECK_PJ_NAME;
					
					formatex(sQuery, 89, "SELECT id FROM zp6_pjs WHERE pj_name=^"%s^" LIMIT 1;", g_UserName[id]);
					SQL_ThreadQuery(g_SqlTuple, "sqlThread__CheckName", sQuery, iData, 2);
				} else {
					colorChat(id, TERRORIST, "%sEl nombre elegido (!gunnamed!y) ya está en uso!", ZP_PREFIX);
					showMenu__ChoosePJ(id);
				}
			} else {
				colorChat(id, TERRORIST, "%sLa posición elegida en el menú ya está ocupada por otro de tus personajes!", ZP_PREFIX);
				showMenu__ChoosePJ(id);
			}
		}
		case 1: {
			colorChat(id, CT, "%s!tCambia tu nombre desde tu consola o desde opciones y luego confirmá el nombre a través del menú.", ZP_PREFIX);
			
			g_AllowChangeName_SPECIAL[id] = 1;
		}
		default: {
			showMenu__ConfirmName(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

public createPJ(const id) {
	new Handle:sqlQuery;
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "INSERT INTO zp6_pjs (`acc_id`, `pj_id`, `pj_name`, `created_date`) VALUES ('%d', '%d', ^"%s^", UNIX_TIMESTAMP());", g_AccountId[id], (g_UserSelected[id]+1), g_UserName[id]);
	
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(id, sqlQuery, 2450);
	} else {
		SQL_FreeHandle(sqlQuery);
		
		g_AccountPJs[id][g_UserSelected[id]] = (g_UserSelected[id]+1);
		copy(g_AccountPJ_Name[id][g_UserSelected[id]], 31, g_UserName[id]);
		g_AccountPJ_Level[id][g_UserSelected[id]] = 1;
		g_AccountPJ_Reset[id][g_UserSelected[id]] = 0;
		
		sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT id FROM zp6_pjs WHERE acc_id='%d' AND pj_id='%d' LIMIT 1;", g_AccountId[id], (g_UserSelected[id]+1));
		if(!SQL_Execute(sqlQuery)) {
			executeQuery(id, sqlQuery, 2500);
		} else if(SQL_NumResults(sqlQuery)) {
			new iId;
			iId = SQL_ReadResult(sqlQuery, 0);
			
			SQL_FreeHandle(sqlQuery);
			
			sqlQuery = SQL_PrepareQuery(g_SqlConnection, "INSERT INTO zp6_pjs_stats (`acc_id`, `pj_id`) VALUES ('%d', '%d');", g_AccountId[id], (g_UserSelected[id]+1));
			if(!SQL_Execute(sqlQuery)) {
				executeQuery(id, sqlQuery, 2600);
			} else {
				SQL_FreeHandle(sqlQuery);
				
				new sRegisterCount[11];
				addDot(iId, sRegisterCount, 10);
				
				colorChat(0, CT, "%sBienvenido !t%s!y, eres el PJ !g#%s!y", ZP_PREFIX, g_UserName[id], sRegisterCount);
				
				showMenu__ChoosePJ(id);
				
				if(iId == 100 || iId == 500 || iId == 1000 || iId == 2500 || iId == 5000 || iId == 7500 || iId == 10000 || iId == 12500 || iId == 15000 || iId == 17500 || iId == 20000) {
					colorChat(0, _, "%sTodos los usuarios conectados ganaron !g25 pHZ!y", ZP_PREFIX);
					
					new i;
					for(i = 1; i <= g_MaxUsers; i++) {
						if(!g_IsConnected[i] || !g_AccountPJ_Logged[i]) {
							continue;
						}
						
						g_Points[i][P_HUMAN] += 25;
						g_Points[i][P_ZOMBIE] += 25;
					}
				}
			}
		} else {
			SQL_FreeHandle(sqlQuery);
		}
	}
}

public showMenu__Game(const id) { // smg_f
	if(!g_IsConnected[id]) {
		return;
	}
	
	static sMenu[350];
	
	if(g_MenuPage[id][MENU_PRINCIPAL] == 0) {
		formatex(sMenu, charsmax(sMenu), "\yZombie Plague %s\R1/2^n\wAmmo packs restantes \r:\y %s^n^n\r1.\w Comprar \yARMAS^n\r2.\w Comprar \yITEMS EXTRAS^n\r3.\w Elegir \yCLASE\w y \yDIFICULTAD^n^n\r4.\w Elegir \yHABILIDADES^n\r5.\y GRUPO^n\r6.\y CLAN\
		^n\r7.\w Ver \yLOGROS\w y \yDESAFÍOS^n^n\r8.\w Ver tus \yESTADÍSTICAS^n^n\r9.\w Siguiente^n\r0.\w Salir", PLUGIN_VERSION, g_AmmoPacks_Rest_Dot[id]);
	} else {
		formatex(sMenu, charsmax(sMenu), "\yZombie Plague %s\R2/2^n\wAmmo packs restantes \r:\y %s^n^n\r1.\w Subir de \yRANGO\w (%0.2f%%)^n^n\r2.\w Elegir \yGORROS^n\r3.\y DUELOS^n^n\r4.\y CONFIGURACIÓN^n^n\r5.\w Ver \yTOP's^n^n\r9.\w Atrás^n\r0.\w Salir",
		PLUGIN_VERSION, g_AmmoPacks_Rest_Dot[id], g_Reset_Percent[id]);
	}
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Game Menu");
}

public menu__Game(const id, const key) {
	if(!g_IsConnected[id]) {
		return PLUGIN_HANDLED;
	}
	
	if(!g_AccountPJ_Logged[id]) {
		return PLUGIN_HANDLED;
	}
	
	if(g_MenuPage[id][MENU_PRINCIPAL] == 0) {
		switch(key) {
			case 0: {
				g_WeaponAutoBuy[id] = 0;
				showMenu__BuyPrimaryWeapons(id);
			} case 1: {
				showMenu__BuyExtras(id);
			} case 2: {
				showMenu__Class_Difficults(id);
			} case 3: {
				showMenu__Habilities(id);
			} case 4: {
				showMenu__Group(id);
			} case 5: {
				showMenu__Clan(id);
			} case 6: {
				showMenu__Achievements_Challen(id);
			} case 7: {
				showMenu__Stats(id);
			} case 8: {
				g_MenuPage[id][MENU_PRINCIPAL] = 1;
				showMenu__Game(id);
			}
		}
	} else {
		switch(key) {
			case 0: {
				showMenu__Rango(id);
			} case 1: {
				showMenu__Hats(id);
			} case 2: {
				showMenu__Duels(id);
			} case 3: {
				showMenu__Options(id);
			} case 4: {
				showMenu__ViewTOPs(id);
			} case 8: {
				g_MenuPage[id][MENU_PRINCIPAL] = 0;
				showMenu__Game(id);
			}
		}
	}
	
	return PLUGIN_HANDLED;
}

public HUMAN_HEALTH(const id) {
	static iHealth;
	static iHab;
	
	iHealth = CLASES_HUMANAS[g_HumanClass[id]][humanHealth];
	iHab = g_Hab[id][CLASS_HUMAN][HAB_HEALTH] + __HATS[g_HatId[id]][hatUpgrade1];
	
	if(iHab) {
		iHealth += (__HABILITIES[CLASS_HUMAN][HAB_HEALTH][habValue] * iHab);
	}
	
	return iHealth;
}

public HUMAN_ARMOR(const id) {
	static iArmor;
	static iHab;
	
	iArmor = 0;
	iHab = g_Hab[id][CLASS_HUMAN][HAB_H_ARMOR];
	
	if(iHab) {
		iArmor += (__HABILITIES[CLASS_HUMAN][HAB_H_ARMOR][habValue] * iHab);
	}
	
	return iArmor;
}

public HUMAN_FLARE(const id) {
	static iFlare = 0;
	static iHab;
	
	iFlare = 0;
	iHab = g_Hab[id][CLASS_SPECIAL][HAB_SPECIAL_FLARE];
	
	if(iHab) {
		iFlare += (__HABILITIES[CLASS_SPECIAL][HAB_SPECIAL_FLARE][habValue] * iHab);
	}
	
	return iFlare;
}

public Float:HUMAN_GRAVITY(const id) {
	static Float:fGravity;
	static iHab;
	
	iHab = g_Hab[id][CLASS_HUMAN][HAB_GRAVITY] + __HATS[g_HatId[id]][hatUpgrade3];
	fGravity = CLASES_HUMANAS[g_HumanClass[id]][humanGravity];
	
	if(iHab) {
		fGravity -= ((float(__HABILITIES[CLASS_HUMAN][HAB_GRAVITY][habValue]) / 166.666666) * float(iHab));
	}
	
	return fGravity;
}

public Float:HUMAN_SPEED(const id) {
	static Float:fSpeed;
	static iHab;
	
	iHab = g_Hab[id][CLASS_HUMAN][HAB_SPEED] + __HATS[g_HatId[id]][hatUpgrade2];
	fSpeed = CLASES_HUMANAS[g_HumanClass[id]][humanSpeed];
	
	if(iHab) {
		fSpeed += ((float(__HABILITIES[CLASS_HUMAN][HAB_SPEED][habValue]) / 2.0) * float(iHab));
	}
	
	return fSpeed;
}

public ZOMBIE_HEALTH(const id) {
	static iHealth;
	static iHab;
	
	iHab = g_Hab[id][CLASS_ZOMBIE][HAB_HEALTH] + __HATS[g_HatId[id]][hatUpgrade7] ;
	iHealth = CLASES_ZOMBIE[g_ZombieClass[id]][zombieHealth];
	
	if(iHab) {
		iHealth += (__HABILITIES[CLASS_ZOMBIE][HAB_HEALTH][habValue] * iHab);
	}
	
	if(g_MapExtraHealth) {
		iHealth += ((iHealth * g_MapExtraHealth) / 100);
	}
	
	return iHealth;
}

public Float:ZOMBIE_GRAVITY(const id) {
	static Float:fGravity;
	fGravity = CLASES_ZOMBIE[g_ZombieClass[id]][zombieGravity];
	
	if(g_Hab[id][CLASS_ZOMBIE][HAB_GRAVITY]) {
		fGravity -= ((__HABILITIES[CLASS_ZOMBIE][HAB_GRAVITY][habValue] / 166.666666) * float(g_Hab[id][CLASS_ZOMBIE][HAB_GRAVITY]));
	}
	
	return fGravity;
}

public Float:ZOMBIE_SPEED(const id) {
	static Float:fSpeed;
	fSpeed = CLASES_ZOMBIE[g_ZombieClass[id]][zombieSpeed];
	
	if(g_Hab[id][CLASS_ZOMBIE][HAB_SPEED]) {
		fSpeed += ((__HABILITIES[CLASS_ZOMBIE][HAB_SPEED][habValue] / 2) * float(g_Hab[id][CLASS_ZOMBIE][HAB_SPEED]));
	}
	
	return fSpeed;
}

public containLetters(const String[]) {
	new const iLen = strlen(String);
	new i;
	
	for(i = 0; i < iLen; ++i) {
		if(!isalpha(String[i])) {
			return 0;
		}
	}
	
	return 1;
}

public countNumbers(const String[]) {
	new const iLen = strlen(String);
	new i;
	
	for(i = 0; i < iLen; ++i) {
		if(isdigit(String[i])) {
			return 1;
		}
	}
	
	return 0;
}

public OrpheuHookReturn:Con_Printf(const a[], const message[]) {
	copy(g_MessageHID, 63, message);
	return OrpheuSupercede;
}

public addDot(const number, sOutPut[], const len) {
	static sTemp[11];
	static iOutputPos;
	static iNumPos;
	static iNumLen;
	
	iOutputPos = 0;
	iNumPos = 0;
	iNumLen = num_to_str(number, sTemp, 10);
	
	while((iNumPos < iNumLen) && (iOutputPos < len)) {
		sOutPut[iOutputPos++] = sTemp[iNumPos++];
		
		if((iNumLen - iNumPos) && !((iNumLen - iNumPos) % 3)) {
			sOutPut[iOutputPos++] = '.';
		}
	}
	
	sOutPut[iOutputPos] = EOS;
	
	return iOutputPos;
}

public addDot__Special(const number[], sOutPut[], const len) {
	static iStop;
	static iOut;
	static i;
	
	iStop = contain(number, ".");
	iOut = 0;
	i = 0;
	
	if(iStop == -1) {
		iStop = strlen(number);
	}
	
	while(i < iStop && iOut < len) {
		sOutPut[iOut++] = number[i++];
		
		if(iOut < len && i < iStop && ((iStop - i) % 3) == 0) {
			sOutPut[iOut++] = '.';
		}
	}
	
	if(iOut < len) {
		iOut += copy(sOutPut[iOut], len - iOut, number[iStop]);
	}
	
	return iOut;
}

public resetInfo(const id) {
	if(!g_IsConnected[id]) {
		return;
	}
	
	client_cmd(id, "setinfo bottomcolor ^"^"");
	client_cmd(id, "setinfo cl_lc ^"^"");
	client_cmd(id, "setinfo model ^"^"");
	client_cmd(id, "setinfo topcolor ^"^"");
	client_cmd(id, "setinfo _9387 ^"^"");
	client_cmd(id, "setinfo _iv ^"^"");
	client_cmd(id, "setinfo _ah ^"^"");
	client_cmd(id, "setinfo _puqz ^"^"");
	client_cmd(id, "setinfo _ndmh ^"^"");
	client_cmd(id, "setinfo _ndmf ^"^"");
	client_cmd(id, "setinfo _ndms ^"^"");
	client_cmd(id, "setinfo zp4 ^"^"");
	client_cmd(id, "setinfo jb1 ^"^"");
	client_cmd(id, "setinfo _pw ^"^"");
}

public task__MakeMode() {
	chooseMode(0, MODE_NONE);
}

public chooseMode(const id, const modeId) {
	static iUsers;
	iUsers = getUsersAlive();
	
	if(iUsers < 4 && !id) {
		client_print(0, print_center, "Se necesitan 4+ usuarios para que comiencen los modos!");
		
		set_task(5.0, "task__MakeMode", TASK_MAKE_MODE);
		return;
	}
	
	if(modeId != 0) {
		setMode(modeId, id);
		return;
	}
	
	if(random_num(1, 8) == 1 && iUsers >= 10) {
		setMode(id, MODE_MULTI);
	} else if(random_num(1, 30) == 1) {
		setMode(id, MODE_SWARM);
	} else if(random_num(1, 20) == 1 && iUsers >= 15) {
		setMode(id, MODE_PLAGUE);
	} else if(random_num(1, 20) == 1 && iUsers >= 10 && g_LastMode != MODE_SURVIVOR) {
		setMode(id, MODE_SURVIVOR);
	} else if(random_num(1, 20) == 1 && iUsers >= 10 && g_LastMode != MODE_NEMESIS) {
		setMode(id, MODE_NEMESIS);
	} else if(random_num(1, 25) == 1 && iUsers >= 12 && g_LastMode != MODE_WESKER) {
		setMode(id, MODE_WESKER);
	} else if(random_num(1, 25) == 1 && iUsers >= 12 && g_LastMode != MODE_JASON) {
		setMode(id, MODE_JASON);
	} else if(random_num(1, 25) == 1 && iUsers >= 12 && g_LastMode != MODE_TROLL) {
		setMode(id, MODE_TROLL);
	} else if(random_num(1, 35) == 1 && iUsers >= 12 && g_LastMode != MODE_ALVSPRED) {
		setMode(id, MODE_ALVSPRED);
	} else if(random_num(1, 40) == 1 && iUsers >= 15 && g_LastMode != MODE_ARMAGEDDON) {
		setMode(id, MODE_ARMAGEDDON);
	} else {
		setMode(id, MODE_INFECTION);
	}
	
	// MODE_MEGA_NEMESIS,
	// MODE_PARANOIA,
	// MODE_COOP,
	// MODE_ASSASSIN,
	// MODE_BOMBER,
	// MODE_DUELO_FINAL
}

public setMode(id, const modeId) { // sm_f
	alertMode(modeId);
	
	remove_task(TASK_MAKE_MODE);
	
	static sText[32];
	static iUsers;
	static iMaxZombies;
	static iZombies;
	static i;
	
	iUsers = getUsersAlive();
	
	set_cvar_num("zp6_semiclip", 1);
	
	g_NewRound = 0;
	
	g_Mode = modeId;
	g_LastMode = modeId;
	
	sText[0] = EOS;
	g_Lights[0] = 'a';
	
	if(modeId == MODE_TROLL || modeId == MODE_ARMAGEDDON) {
		g_Lights[0] = 'm';
	}
	
	changeLights();
	
	switch(modeId) {
		case MODE_INFECTION: {
			if(!id) {
				id = getRandomUser(.userAlive=1, .withChance=0);
			}
			
			zombieMe(id, .firstZombie=1);
			
			++g_Stats[id][STAT_DONE][STAT_FIRST_ZOMBIE_COUNT];
			
			for(i = 1; i <= g_MaxUsers; ++i) {
				if(!g_IsAlive[i]) {
					continue;
				}
				
				if(g_Zombie[i]) {
					continue;
				}
				
				if(g_WeaponAutoBuy[i]) {
					buyTerciaryWeapon(i, g_WeaponTerciary_Selection[i]);
				}
				
				if(getUserTeam(i) != FM_CS_TEAM_CT) {
					remove_task(i + TASK_TEAM);
					
					setUserTeam(i, FM_CS_TEAM_CT);
					userTeamUpdate(i);
				}
			}
			
			for(i = 0; i < 32; ++i) {
				if(g_UserName[id][i]) {
					sText[i] = '=';
					
					continue;
				}
				
				break;
			}
			
			set_hudmessage(255, 0, 0, -1.0, 0.25, 1, 3.0, 7.0, 7.0, 3.0, -1);
			ShowSyncHudMsg(0, g_Hud_Notification, "%s==========================^n¡ %s ES EL PRIMER ZOMBIE !^n==========================%s", sText, g_UserName[id], sText);
		} case MODE_SWARM: {
			if(!getAliveTs()) {
				id = getRandomUser(.userAlive=1, .withChance=0);
				
				remove_task(id + TASK_TEAM);
				
				setUserTeam(id, FM_CS_TEAM_T);
				userTeamUpdate(id);
			} else if(!getAliveCTs()) {
				id = getRandomUser(.userAlive=1, .withChance=1);
				
				remove_task(id + TASK_TEAM);
				
				setUserTeam(id, FM_CS_TEAM_CT);
				userTeamUpdate(id);
			}
			
			for(i = 1; i <= g_MaxUsers; ++i) {
				if(!g_IsAlive[i]) {
					continue;
				}
				
				if(getUserTeam(i) != FM_CS_TEAM_T) {
					if(g_WeaponAutoBuy[i]) {
						buyTerciaryWeapon(i, g_WeaponTerciary_Selection[i]);
					}
					
					continue;
				}
				
				zombieMe(i);
			}
			
			set_hudmessage(0, 255, 0, -1.0, 0.25, 1, 3.0, 7.0, 7.0, 3.0, -1);
			ShowSyncHudMsg(0, g_Hud_Notification, "=========^n¡ SWARM !^n=========");
		} case MODE_MULTI: {
			iMaxZombies = iUsers / 3;
			iZombies = 0;
			id = 0;
			
			while(iZombies < iMaxZombies) {
				if(++id > g_MaxUsers) {
					id = 1;
				}
				
				if(!g_IsAlive[id] || g_Zombie[id]) {
					continue;
				}
				
				if(random_num(0, 1)) {
					zombieMe(id);
					++iZombies;
				}
			}
			
			for(i = 1; i <= g_MaxUsers; ++i) {
				if(!g_IsAlive[i] || g_Zombie[i]) {
					continue;
				}
				
				if(g_WeaponAutoBuy[i]) {
					buyTerciaryWeapon(i, g_WeaponTerciary_Selection[i]);
				}
				
				if(getUserTeam(i) != FM_CS_TEAM_CT) {
					remove_task(i + TASK_TEAM);
					
					setUserTeam(i, FM_CS_TEAM_CT);
					userTeamUpdate(i);
				}
			}
			
			set_hudmessage(0, 255, 0, -1.0, 0.25, 1, 3.0, 7.0, 7.0, 3.0, -1);
			ShowSyncHudMsg(0, g_Hud_Notification, "======================^n¡ INFECCIÓN MÚLTIPLE !^n======================");
		} case MODE_PLAGUE: {
			static iSurvivors;
			static iMaxSurvivors;
			static iNemesis;
			static iMaxNemesis;
			
			iMaxSurvivors = 2;
			iSurvivors = 0;
			
			while(iSurvivors < iMaxSurvivors) {
				id = getRandomUser(.userAlive=1, .withChance=1);
				
				if(g_SpecialMode[id] == MODE_SURVIVOR) {
					continue;
				}
				
				humanMe(id, .survivor = 1);
				++iSurvivors;
			}
			
			iMaxNemesis = 2;
			iNemesis = 0;
			
			while(iNemesis < iMaxNemesis) {
				id = getRandomUser(.userAlive=1, .withChance=1);
				
				if(g_SpecialMode[id] == MODE_SURVIVOR || g_SpecialMode[id] == MODE_NEMESIS) {
					continue;
				}
				
				zombieMe(id, .nemesis = 1);
				++iNemesis;
			}
			
			iMaxZombies = (iUsers - 2) / 3;
			iZombies = 0;
			id = 0;
			
			while(iZombies < iMaxZombies) {
				if(++id > g_MaxUsers) {
					id = 1;
				}
				
				if(!g_IsAlive[id] || g_Zombie[id] || g_SpecialMode[id] == MODE_SURVIVOR) {
					continue;
				}
				
				if(random_num(0, 1)) {
					zombieMe(id);
					++iZombies;
				}
			}
			
			for(i = 1; i <= g_MaxUsers; ++i) {
				if(!g_IsAlive[i] || g_Zombie[i] || g_SpecialMode[i] == MODE_SURVIVOR) {
					continue;
				}
				
				if(g_WeaponAutoBuy[i]) {
					buyTerciaryWeapon(i, g_WeaponTerciary_Selection[i]);
				}
				
				if(getUserTeam(i) != FM_CS_TEAM_CT) {
					remove_task(i + TASK_TEAM);
					
					setUserTeam(i, FM_CS_TEAM_CT);
					userTeamUpdate(i);
				}
			}
			
			set_hudmessage(255, 255, 255, -1.0, 0.25, 1, 3.0, 7.0, 7.0, 3.0, -1);
			ShowSyncHudMsg(0, g_Hud_Notification, "==========^n¡ PLAGUE !^n==========");
		} case MODE_SURVIVOR: {
			if(id == 0) {
				id = getRandomUser(.userAlive=1, .withChance=1);
			}
			
			humanMe(id, .survivor = 1);
			
			++g_Stats[id][STAT_DONE][STAT_SURVIVOR_COUNT];
			
			for(i = 1; i <= g_MaxUsers; ++i) {
				if(!g_IsAlive[i]) {
					continue;
				}
				
				if(id == i || g_Zombie[i]) {
					continue;
				}
				
				zombieMe(i);
			}
			
			for(i = 0; i < 32; ++i) {
				if(g_UserName[id][i]) {
					sText[i] = '=';
					
					continue;
				}
				
				break;
			}
			
			set_hudmessage(0, 0, 255, -1.0, 0.25, 1, 3.0, 7.0, 7.0, 3.0, -1);
			ShowSyncHudMsg(0, g_Hud_Notification, "%s================^n¡ %s ES SURVIVOR !^n================%s", sText, g_UserName[id], sText);
			
			if(random_num(0, 1)) {
				client_cmd(0, "spk ^"%s^"", g_SOUND_SurvivorPlayer07);
				
				return;
			}
		} case MODE_NEMESIS: {
			g_ModeStart_SysTime = get_systime() + 60;
			
			if(id == 0) {
				id = getRandomUser(.userAlive=1, .withChance=1);
			}
			
			zombieMe(id, .nemesis = 1);
			
			++g_Stats[id][STAT_DONE][STAT_NEMESIS_COUNT];
			
			for(i = 1; i <= g_MaxUsers; ++i) {
				if(!g_IsAlive[i]) {
					continue;
				}
				
				if(id == i) {
					continue;
				}
				
				if(getUserTeam(i) != FM_CS_TEAM_CT) {
					remove_task(i + TASK_TEAM);
					
					setUserTeam(i, FM_CS_TEAM_CT);
					userTeamUpdate(i);
				}
			}
			
			for(i = 0; i < 32; ++i) {
				if(g_UserName[id][i]) {
					sText[i] = '=';
					
					continue;
				}
				
				break;
			}
			
			set_hudmessage(255, 0, 0, -1.0, 0.25, 1, 3.0, 7.0, 7.0, 3.0, -1);
			ShowSyncHudMsg(0, g_Hud_Notification, "%s===============^n¡ %s ES NEMESIS !^n===============%s", sText, g_UserName[id], sText);
			
			client_cmd(0, "spk ^"%s^"", g_SOUND_Mode_Nemesis[random_num(0, charsmax(g_SOUND_Mode_Nemesis))]);
			
			return;
		} case MODE_WESKER: {
			if(id == 0) {
				id = getRandomUser(.userAlive=1, .withChance=1);
			}
			
			humanMe(id, .wesker = 1);
			
			++g_Stats[id][STAT_DONE][STAT_WESKER_COUNT];
			
			for(i = 1; i <= g_MaxUsers; ++i) {
				if(!g_IsAlive[i]) {
					continue;
				}
				
				if(id == i || g_Zombie[i]) {
					continue;
				}
				
				zombieMe(i);
			}
			
			for(i = 0; i < 32; ++i) {
				if(g_UserName[id][i]) {
					sText[i] = '=';
					
					continue;
				}
				
				break;
			}
			
			set_hudmessage(255, 255, 0, -1.0, 0.25, 1, 3.0, 7.0, 7.0, 3.0, -1);
			ShowSyncHudMsg(0, g_Hud_Notification, "%s==============^n¡ %s ES WESKER !^n==============%s", sText, g_UserName[id], sText);
		} case MODE_JASON: {
			if(id == 0) {
				id = getRandomUser(.userAlive=1, .withChance=1);
			}
			
			humanMe(id, .jason = 1);
			
			++g_Stats[id][STAT_DONE][STAT_JASON_COUNT];
			
			for(i = 1; i <= g_MaxUsers; ++i) {
				if(!g_IsAlive[i]) {
					continue;
				}
				
				if(id == i || g_Zombie[i]) {
					continue;
				}
				
				zombieMe(i);
			}
			
			for(i = 0; i < 32; ++i) {
				if(g_UserName[id][i]) {
					sText[i] = '=';
					
					continue;
				}
				
				break;
			}
			
			set_hudmessage(255, 0, 255, -1.0, 0.25, 1, 3.0, 7.0, 7.0, 3.0, -1);
			ShowSyncHudMsg(0, g_Hud_Notification, "%s=============^n¡ %s ES JASON !^n=============%s", sText, g_UserName[id], sText);
		} case MODE_TROLL: {
			if(id == 0) {
				id = getRandomUser(.userAlive=1, .withChance=1);
			}
			
			zombieMe(id, .troll = 1);
			
			++g_Stats[id][STAT_DONE][STAT_TROLL_COUNT];
			
			for(i = 1; i <= g_MaxUsers; ++i) {
				if(!g_IsAlive[i]) {
					continue;
				}
				
				if(id == i) {
					continue;
				}
				
				if(getUserTeam(i) != FM_CS_TEAM_CT) {
					remove_task(i + TASK_TEAM);
					
					setUserTeam(i, FM_CS_TEAM_CT);
					userTeamUpdate(i);
				}
			}
			
			for(i = 0; i < 32; ++i) {
				if(g_UserName[id][i]) {
					sText[i] = '=';
					
					continue;
				}
				
				break;
			}
			
			set_hudmessage(255, 0, 0, -1.0, 0.25, 1, 3.0, 7.0, 7.0, 3.0, -1);
			ShowSyncHudMsg(0, g_Hud_Notification, "%s===============^n¡ %s ES TROLL !^n===============%s", sText, g_UserName[id], sText);
		} case MODE_ALVSPRED: {
			EnableHamForward(g_HamTouch_Wall);
			EnableHamForward(g_HamTouch_Breakeable);
			EnableHamForward(g_HamTouch_Worldspawn);
			
			g_Fw_CmdStart = register_forward(FM_CmdStart, "fw_CmdStart");
			
			if(!getAliveTs()) {
				id = getRandomUser(.userAlive=1, .withChance=0);
				
				remove_task(id + TASK_TEAM);
				
				setUserTeam(id, FM_CS_TEAM_T);
				userTeamUpdate(id);
			} else if(!getAliveCTs()) {
				id = getRandomUser(.userAlive=1, .withChance=1);
				
				remove_task(id + TASK_TEAM);
				
				setUserTeam(id, FM_CS_TEAM_CT);
				userTeamUpdate(id);
			}
			
			static iIds[2];
			static iMonsters;
			
			iMonsters = 0;
			
			while(iMonsters < 2) {
				id = getRandomUser(.userAlive=1, .withChance=1);
				
				if(g_Alien[id]) {
					continue;
				}
				
				if(!iMonsters) {
					zombieMe(id, .alien = 1);
					iIds[0] = id;
				} else {
					humanMe(id, .predator = 1);
					iIds[1] = id;
				}
				
				++iMonsters;
			}
			
			for(id = 1; id <= g_MaxUsers; ++id) {
				if(!g_IsAlive[id]) {
					continue;
				}
				
				if(getUserTeam(id) != FM_CS_TEAM_T) {
					if(!g_Predator[id]) {
						set_user_health(id, random_num(350, 1000));
						
						if(g_WeaponAutoBuy[id]) {
							buyTerciaryWeapon(id, g_WeaponTerciary_Selection[id]);
						}
					}
					
					continue;
				}
				
				if(g_Alien[id]) {
					continue;
				}
				
				zombieMe(id);
			}
			
			static sText2[32];			
			sText2[0] = EOS;
			
			for(i = 0; i < 32; ++i) {
				if(g_UserName[iIds[0]][i]) {
					sText[i] = '=';
					
					continue;
				}
				
				break;
			}
			
			for(i = 0; i < 32; ++i) {
				if(g_UserName[iIds[1]][i]) {
					sText2[i] = '=';
					
					continue;
				}
				
				break;
			}
			
			set_hudmessage(255, 255, 255, -1.0, 0.25, 1, 3.0, 7.0, 7.0, 3.0, -1);
			ShowSyncHudMsg(0, g_Hud_Notification, "======================%s%s^n¡ ALIEN VS DEPREDADOR !^n======================%s%s^nALIEN: %s | DEPREDADOR: %s^n======================%s%s", sText[0], sText[1], sText[0], sText[1],
			g_UserName[iIds[0]], g_UserName[iIds[1]], sText[0], sText[1]);
		} case MODE_ASSASSIN: {
			client_cmd(0, "spk ^"%s^"", g_SOUND_Mode_Assassin);
			
			return;
		} case MODE_DUELO_FINAL: {
			client_cmd(0, "spk ^"%s^"", g_SOUND_Mode_DuelFinal);
			
			return;
		} case MODE_ARMAGEDDON: {
			new iValue;
			
			if(!getAliveTs()) {
				id = getRandomUser(.userAlive=1, .withChance=0);
				
				remove_task(id + TASK_TEAM);
				
				setUserTeam(id, FM_CS_TEAM_T);
				userTeamUpdate(id);
			} else if(!getAliveCTs()) {
				id = getRandomUser(.userAlive=1, .withChance=1);
				
				remove_task(id + TASK_TEAM);
				
				setUserTeam(id, FM_CS_TEAM_CT);
				userTeamUpdate(id);
			}
			
			if(random_num(1, 5) == 1) {
				client_cmd(0, "mp3volume 1.0");
				client_cmd(0, "mp3 play ^"%s^"", g_SOUND_ArmageddonOP);
				
				new i;
				new j;
				for(i = 1; i <= g_MaxUsers; ++i) {
					if(!g_IsAlive[i]) {
						continue;
					}
					
					if(!g_Hat[i][HAT_FOOTBALL_HELM]) {
						TrieGetCell(g_tArmageddonCant, g_AccountName[i], iValue);
						
						if(iValue < 0) {
							iValue = 0;
						}
						
						TrieSetCell(g_tArmageddonCant, g_AccountName[i], iValue + 1);
						
						if(iValue == 2) {
							giveHat(i, HAT_FOOTBALL_HELM);
						}
					}
					
					message_begin(MSG_BROADCAST, g_Message_ScreenFade, _, 0);
					write_short(UNIT_SECOND * 4);
					write_short(UNIT_SECOND * 3);
					write_short(FFADE_OUT);
					write_byte(0);
					write_byte(0);
					write_byte(0);
					write_byte(255);
					message_end();
					
					j = strlen(g_SteamId[i]);
					
					if(equali(g_SteamId[i], "STEAM_ID_PENDING") || equali(g_SteamId[i], "STEAM_ID_LAN") || j <= 16 || (g_SteamId[i][0] == 'V' && g_SteamId[i][1] == 'A' && g_SteamId[i][2] == 'L')) {
						set_task(3.4, "task__Armageddon_Effect", i); // TUM
						set_task(4.1, "task__Armageddon_Effect", i); // TUMM
						set_task(4.8, "task__Armageddon_Effect", i); // TUMMM
						
						set_task(7.0, "task__Armageddon_BlackFade", i);
						
						set_task(10.5, "task__Armageddon_Effect", i); // TUM
						set_task(11.2, "task__Armageddon_Effect", i); // TUMM
						set_task(11.9, "task__Armageddon_Effect", i); // TUMMM
					} else { // Estúpido fix para steam que el sonido de mp3 play empieza a reproducirse 1 segundo después de que se ejecuta
						set_task(4.4, "task__Armageddon_Effect", i); // TUM
						set_task(5.1, "task__Armageddon_Effect", i); // TUMM
						set_task(5.8, "task__Armageddon_Effect", i); // TUMMM
						
						set_task(8.0, "task__Armageddon_BlackFade", i);
						
						set_task(11.5, "task__Armageddon_Effect", i); // TUM
						set_task(12.2, "task__Armageddon_Effect", i); // TUMM
					}
				}
				
				set_task(12.8, "task__Armageddon_Start");
			} else {
				client_cmd(0, "spk ^"%s^"", g_SOUND_Armageddon);
				
				message_begin(MSG_BROADCAST, g_Message_ScreenFade, _, 0);
				write_short(UNIT_SECOND * 4);
				write_short(floatround(UNIT_SECOND * 15.0 + 2.2));
				write_short(FFADE_OUT);
				write_byte(0);
				write_byte(0);
				write_byte(0);
				write_byte(255);
				message_end();
				
				set_task(17.0, "task__Armageddon_Start");
			}
			
			return;
		}
	}
	
	client_cmd(0, "spk ^"%s^"", g_SOUND_Modes[random_num(0, charsmax(g_SOUND_Modes))]);
}

public task__RemoveImmunityBombs(const taskid) {
	g_ImmunityBombs[ID_IMMUNITY_BOMBS] = 0;
}

public fw_PlayerJump(const id) {
	if(!g_IsAlive[id] || !g_LongJump[id]) {
		return HAM_IGNORED;
	}
	
	static iFlags;
	iFlags = entity_get_int(id, EV_INT_flags);
	
	if(iFlags & FL_WATERJUMP || entity_get_int(id, EV_INT_waterlevel) >= 2) {
		return HAM_IGNORED;
	}
	
	static iButtonPressed;
	iButtonPressed = get_pdata_int(id, OFFSET_BUTTON_PRESSED, OFFSET_LINUX);
	
	if(!(iButtonPressed & IN_JUMP) || !(iFlags & FL_ONGROUND)) {
		return HAM_IGNORED;
	}
	
	if((entity_get_int(id, EV_INT_bInDuck) || iFlags & FL_DUCKING) && get_pdata_int(id, OFFSET_LONG_JUMP, OFFSET_LINUX) && entity_get_int(id, EV_INT_button) & IN_DUCK && entity_get_int(id, EV_INT_flDuckTime)) {
		new Float:vecVelocity[3];
		entity_get_vector(id, EV_VEC_velocity, vecVelocity);
		
		if(vector_length(vecVelocity) > ((g_AccountId[id] != 1) ? 20 : 1)) {
			entity_get_vector(id, EV_FLARE_COLOR, vecVelocity);
			vecVelocity[0] = -5.0;
			entity_set_vector(id, EV_FLARE_COLOR, vecVelocity);
			
			get_global_vector(GL_v_forward, vecVelocity);
			
			vecVelocity[0] *= 576.0;
			vecVelocity[1] *= 576.0;
			vecVelocity[2] = 310.0;
			
			entity_set_vector(id, EV_VEC_velocity, vecVelocity);
			
			set_pdata_int(id, OFFSET_ACTIVITY, OFFSET_LEAP, OFFSET_LINUX);
			set_pdata_int(id, OFFSET_SILENT, OFFSET_LEAP, OFFSET_LINUX);
			
			g_InJump[id] = 1;
			
			++g_Nemesis_LongJump_Count;
			
			entity_set_int(id, EV_INT_oldbuttons, entity_get_int(id, EV_INT_oldbuttons) | IN_JUMP);
			
			entity_set_int(id, EV_INT_gaitsequence, 7);
			entity_set_float(id, EV_FL_frame, 0.0);
			
			set_pdata_int(id, OFFSET_BUTTON_PRESSED, iButtonPressed & ~IN_JUMP, OFFSET_LINUX);
			
			return HAM_SUPERCEDE;
		}
	}
	
	return HAM_IGNORED;
}

public fw_PlayerDuck(const id) {
	if(g_InJump[id]) {
		g_InJump[id] = 0;
		return HAM_SUPERCEDE;
	}
	
	return HAM_IGNORED;
}

public task__SpecNightvision(const id) {
	if(!g_IsConnected[id] || g_IsAlive[id]) {
		return;
	}
	
	setNightvision(id, 1);
}

public task__RememberVinc(const taskid) {
	new id = ID_MESSAGE_VINC;
	
	if(!g_IsConnected[id] || g_Vinc[id]) {
		return;
	}
	
	colorChat(id, _, "%sTu cuenta no está vinculada a CiMSP, recordá vincularla lo más pronto posible: !gzp.cimsp.net/panel!y", ZP_PREFIX);
	colorChat(id, _, "%sVincular tu cuenta ofrece varias opciones/funciones, alguna de ellas muy importantes, además de un logro!", ZP_PREFIX);
	
	set_task(180.0, "task__RememberVinc", id + TASK_MESSAGE_VINC);
}

public task__Save(const taskid) {
	new id;
	id = ID_SAVE;
	
	saveInfo(id, .disconnect=0);
}

public showMenu__BuyPrimaryWeapons(const taskid) {
	static id;
	id = (taskid > g_MaxUsers) ? ID_SPAWN : taskid;
	
	if(g_WeaponAutoBuy[id] && taskid > g_MaxUsers) {
		if(!g_IsAlive[id] || g_Zombie[id] || g_SpecialMode[id] || !g_CanBuy[id]) {
			return;
		}
		
		buyPrimaryWeapon(id, g_WeaponPrimary_Selection[id]);
		buySecondaryWeapon(id, g_WeaponSecondary_Selection[id]);
		
		if(!task_exists(TASK_MAKE_MODE)) {
			buyTerciaryWeapon(id, g_WeaponTerciary_Selection[id]);
		}
		
		g_CanBuy[id] = 0;
		g_HatDevil[id] = 1;
		
		return;
	}
	
	static sMenu[500];
	static iStartLoop;
	static iEndLoop;
	static iLen;
	static i;
	static j;
	
	iLen = 0;
	j = 0;
	
	iStartLoop = (g_MenuPage[id][MENU_ARMA_PRINCIPAL] * 7);
	iEndLoop = clamp(((g_MenuPage[id][MENU_ARMA_PRINCIPAL] + 1) * 7), 0, sizeof(ARMAS_PRIMARIAS));
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yARMA PRIMARIA \r[%d - %d]^n^n", (iStartLoop + 1), iEndLoop);
	
	for(i = iStartLoop; i < iEndLoop; ++i) {
		++j;
		
		if(g_Reset[id] > ARMAS_PRIMARIAS[i][weaponReset] || (g_Reset[id] == ARMAS_PRIMARIAS[i][weaponReset] && g_Level[id] >= ARMAS_PRIMARIAS[i][weaponLevelReq])) {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\w %s \y(R\r:\y %d \r-\y LV\r:\y %d)^n", j, ARMAS_PRIMARIAS[i][weaponNames], ARMAS_PRIMARIAS[i][weaponReset], ARMAS_PRIMARIAS[i][weaponLevelReq]);
		} else {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\d %s (R: %d \r-\d LV: %d)^n", j, ARMAS_PRIMARIAS[i][weaponNames], ARMAS_PRIMARIAS[i][weaponReset], ARMAS_PRIMARIAS[i][weaponLevelReq]);
		}
	}
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\r8.\w Atrás^n\r9.\w Siguiente^n\r0. \wVolver");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Buy Primary Weapons Menu");
}

public menu__BuyPrimaryWeapons(const id, const key) {
	static iSelection;
	static iWeapons;
	
	iSelection = (g_MenuPage[id][MENU_ARMA_PRINCIPAL] * 7) + key;
	iWeapons = sizeof(ARMAS_PRIMARIAS);
	
	if(key >= 7 || iSelection >= iWeapons) {
		switch(key) {
			case 7: {
				if(((g_MenuPage[id][MENU_ARMA_PRINCIPAL] - 1) * 7) >= 0) {
					--g_MenuPage[id][MENU_ARMA_PRINCIPAL];
				}
			} case 8: {
				if(((g_MenuPage[id][MENU_ARMA_PRINCIPAL] + 1) * 7) < iWeapons) {
					++g_MenuPage[id][MENU_ARMA_PRINCIPAL];
				}
			} case 9: {
				showMenu__Game(id);
				return PLUGIN_HANDLED;
			}
		}
		
		showMenu__BuyPrimaryWeapons(id);
		return PLUGIN_HANDLED;
	}
	
	if(iSelection >= 13 && entity_get_int(id, EV_INT_button) & IN_ATTACK2) {
		setAchievement(id, QUE_ARMA_ES_ESA);
		
		colorChat(id, _, "%sEl arma !g%s!y ^"reemplaza^" a una !g%s!y", ZP_PREFIX, ARMAS_PRIMARIAS[iSelection][weaponNames], WEAPON_NAMES[ARMAS_PRIMARIAS[iSelection][weaponCSW]]);
		
		showMenu__BuyPrimaryWeapons(id);
		return PLUGIN_HANDLED;
	}
	
	if(g_Reset[id] > ARMAS_PRIMARIAS[iSelection][weaponReset] || (g_Reset[id] == ARMAS_PRIMARIAS[iSelection][weaponReset] && g_Level[id] >= ARMAS_PRIMARIAS[iSelection][weaponLevelReq])) {
		g_WeaponPrimary_Selection[id] = iSelection;
		
		showMenu__BuySecondaryWeapons(id);
	} else {
		showMenu__BuyPrimaryWeapons(id);
	}
	
	return PLUGIN_HANDLED;
}

showMenu__BuySecondaryWeapons(const id) {
	static sMenu[450];
	static iStartLoop;
	static iEndLoop;
	static iLen;
	static i;
	static j;
	
	iLen = 0;
	j = 0;

	iStartLoop = (g_MenuPage[id][MENU_ARMA_SECUNDARIA] * 7);
	iEndLoop = clamp(((g_MenuPage[id][MENU_ARMA_SECUNDARIA] + 1) * 7), 0, sizeof(ARMAS_SECUNDARIAS));
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yARMA SECUNDARIA \r[%d - %d]^n^n", (iStartLoop + 1), iEndLoop);
	
	for(i = iStartLoop; i < iEndLoop; ++i) {
		++j;
		
		if(g_Reset[id] > ARMAS_SECUNDARIAS[i][weaponReset] || (g_Reset[id] == ARMAS_SECUNDARIAS[i][weaponReset] && g_Level[id] >= ARMAS_SECUNDARIAS[i][weaponLevelReq])) {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\w %s \y(R\r:\y %d \r-\y LV\r:\y %d)^n", j, ARMAS_SECUNDARIAS[i][weaponNames], ARMAS_SECUNDARIAS[i][weaponReset], ARMAS_SECUNDARIAS[i][weaponLevelReq]);
		} else {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\d %s (R: %d \r-\d LV: %d)^n", j, ARMAS_SECUNDARIAS[i][weaponNames], ARMAS_SECUNDARIAS[i][weaponReset], ARMAS_SECUNDARIAS[i][weaponLevelReq]);
		}
	}
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\r8.\w Atrás^n\r9.\w Siguiente^n\r0. \wVolver");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Buy Secondary Weapons Menu");
}

public menu__BuySecondaryWeapons(const id, const key) {
	static iSelection;
	static iWeapons;
	
	iSelection = (g_MenuPage[id][MENU_ARMA_SECUNDARIA] * 7) + key;
	iWeapons = sizeof(ARMAS_SECUNDARIAS);
	
	if(key >= 7 || iSelection >= iWeapons) {
		switch(key) {
			case 7: {
				if(((g_MenuPage[id][MENU_ARMA_SECUNDARIA] - 1) * 7) >= 0) {
					--g_MenuPage[id][MENU_ARMA_SECUNDARIA];
				}
			} case 8: {
				if(((g_MenuPage[id][MENU_ARMA_SECUNDARIA] + 1) * 7) < iWeapons) {
					++g_MenuPage[id][MENU_ARMA_SECUNDARIA];
				}
			} case 9: {
				showMenu__Game(id);
				return PLUGIN_HANDLED;
			}
		}
		
		showMenu__BuySecondaryWeapons(id);
		return PLUGIN_HANDLED;
	}
	
	if(iSelection >= 6 && entity_get_int(id, EV_INT_button) & IN_ATTACK2) {
		setAchievement(id, QUE_ARMA_ES_ESA);
		
		colorChat(id, _, "%sEl arma !g%s!y ^"reemplaza^" a una !g%s!y", ZP_PREFIX, ARMAS_SECUNDARIAS[iSelection][weaponNames], WEAPON_NAMES[ARMAS_SECUNDARIAS[iSelection][weaponCSW]]);
		
		showMenu__BuySecondaryWeapons(id);
		return PLUGIN_HANDLED;
	}
	
	if(g_Reset[id] > ARMAS_SECUNDARIAS[iSelection][weaponReset] || (g_Reset[id] == ARMAS_SECUNDARIAS[iSelection][weaponReset] && g_Level[id] >= ARMAS_SECUNDARIAS[iSelection][weaponLevelReq])) {
		g_WeaponSecondary_Selection[id] = iSelection;
		
		g_WeaponAutoBuy[id] = 1;
		
		showMenu__BuyTerciaryWeapons(id);
	} else {
		showMenu__BuySecondaryWeapons(id);
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__BuyTerciaryWeapons(const id) {
	static sMenu[600];
	static iStartLoop;
	static iEndLoop;
	static iLen;
	static i;
	static j;
	
	j = 0;
	iLen = 0;
	iStartLoop = (g_MenuPage[id][MENU_ARMA_TERCIARIA] * 7);
	iEndLoop = clamp(((g_MenuPage[id][MENU_ARMA_TERCIARIA] + 1) * 7), 0, sizeof(ARMAS_TERCIARIAS));
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yGRANADAS \r[%d - %d]^n^n", (iStartLoop + 1), iEndLoop);
	
	for(i = iStartLoop; i < iEndLoop; ++i) {
		++j;
		
		if(g_Reset[id] > ARMAS_TERCIARIAS[i][weaponGrenadesReset] || (g_Reset[id] == ARMAS_TERCIARIAS[i][weaponGrenadesReset] && g_Level[id] >= ARMAS_TERCIARIAS[i][weaponGrenadesLevel])) {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\w %s \y(R\r:\y %d \r-\y LV\r:\y %d)^n", j, ARMAS_TERCIARIAS[i][weaponGrenadesNames], ARMAS_TERCIARIAS[i][weaponGrenadesReset], ARMAS_TERCIARIAS[i][weaponGrenadesLevel]);
		} else {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\d %s (R: %d \r-\d LV: %d)^n", j, ARMAS_TERCIARIAS[i][weaponGrenadesNames], ARMAS_TERCIARIAS[i][weaponGrenadesReset], ARMAS_TERCIARIAS[i][weaponGrenadesLevel]);
		}
	}
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\r8.\w ¿Recordar Compra? %s", (g_WeaponAutoBuy[id]) ? "\y[Si]" : "\r[No]");
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n^n\r9.\w Siguiente/Atrás^n\r0. \wVolver");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Buy Terciary Weapons Menu");
}

public menu__BuyTerciaryWeapons(const id, const key) {
	new iSelection;
	iSelection = (g_MenuPage[id][MENU_ARMA_TERCIARIA] * 7) + key;
	
	if(key >= 7 || iSelection >= sizeof(ARMAS_TERCIARIAS)) {
		switch(key) {
			case 7: {
				g_WeaponAutoBuy[id] = !g_WeaponAutoBuy[id];
			}
			case 8: {
				if(((g_MenuPage[id][MENU_ARMA_TERCIARIA] + 1) * 7) < sizeof(ARMAS_TERCIARIAS)) {
					++g_MenuPage[id][MENU_ARMA_TERCIARIA];
				} else {
					g_MenuPage[id][MENU_ARMA_TERCIARIA] = 0;
				}
			}
			case 9: {
				showMenu__Game(id);
				return PLUGIN_HANDLED;
			}
		}
		
		showMenu__BuyTerciaryWeapons(id);
		return PLUGIN_HANDLED;
	}
	
	if(g_Reset[id] > ARMAS_TERCIARIAS[iSelection][weaponGrenadesReset] || (g_Reset[id] == ARMAS_TERCIARIAS[iSelection][weaponGrenadesReset] && g_Level[id] >= ARMAS_TERCIARIAS[iSelection][weaponGrenadesLevel])) {
		g_WeaponTerciary_Selection[id] = iSelection;
		
		if(!g_IsAlive[id] || g_Zombie[id] || g_SpecialMode[id] || !g_CanBuy[id]) {
			return PLUGIN_HANDLED;
		}
		
		buyPrimaryWeapon(id, g_WeaponPrimary_Selection[id]);
		buySecondaryWeapon(id, g_WeaponSecondary_Selection[id]);
		
		if(!task_exists(TASK_MAKE_MODE)) {
			buyTerciaryWeapon(id, g_WeaponTerciary_Selection[id]);
		}
		
		g_CanBuy[id] = 0;
		g_HatDevil[id] = 1;
	} else {
		showMenu__BuyTerciaryWeapons(id);
	}
	
	return PLUGIN_HANDLED;
}

buyPrimaryWeapon(const id, const selection) {
	dropWeapons(id, 1);
	
	strip_user_weapons(id);
	give_item(id, "weapon_knife");
	
	new iWeaponId;
	iWeaponId = weaponNameId(ARMAS_PRIMARIAS[selection][weaponEnt]);
	
	g_WeaponPrimaryActual[id] = selection;
	
	give_item(id, ARMAS_PRIMARIAS[selection][weaponEnt]);
	ExecuteHamB(Ham_GiveAmmo, id, MAX_BPAMMO[iWeaponId], AMMO_TYPE[iWeaponId], MAX_BPAMMO[iWeaponId]);
}

buySecondaryWeapon(const id, const selection) {
	dropWeapons(id, 2);
	
	new iWeaponId;
	iWeaponId = weaponNameId(ARMAS_SECUNDARIAS[selection][weaponEnt]);
	
	g_WeaponSecondaryActual[id] = selection;
	
	give_item(id, ARMAS_SECUNDARIAS[selection][weaponEnt]);
	ExecuteHamB(Ham_GiveAmmo, id, MAX_BPAMMO[iWeaponId], AMMO_TYPE[iWeaponId], MAX_BPAMMO[iWeaponId]);
}

buyTerciaryWeapon(const id, const selection) {
	g_SuperNova_Bomb[id] = ARMAS_TERCIARIAS[selection][grenadeSupernova];
	g_Bubble_Bomb[id] = ARMAS_TERCIARIAS[selection][grenadeSupernova];
	
	if(ARMAS_TERCIARIAS[selection][weaponEnt_HE]) {
		give_item(id, "weapon_hegrenade");
		cs_set_user_bpammo(id, CSW_HEGRENADE, ARMAS_TERCIARIAS[selection][weaponEnt_HE]);
	}
	
	if(ARMAS_TERCIARIAS[selection][weaponEnt_FB]) {
		give_item(id, "weapon_flashbang");
		cs_set_user_bpammo(id, CSW_FLASHBANG, ARMAS_TERCIARIAS[selection][weaponEnt_FB]);
	}
	
	if(ARMAS_TERCIARIAS[selection][weaponEnt_SG]) {
		give_item(id, "weapon_smokegrenade");
		cs_set_user_bpammo(id, CSW_SMOKEGRENADE, ARMAS_TERCIARIAS[selection][weaponEnt_SG]);
	}
}

public showMenu__BuyExtras(const id) {
	static sPosition[3];
	static sItem[64];
	static sItemPerUser[14];
	static sItemPerMap[14];
	static sCost[11];
	static iMenuId;
	static iValue;
	static iCost;
	static i;
	
	iMenuId = menu_create("ITEMS EXTRAS", "menu__BuyExtras");
	
	for(i = 0; i < extraItemsId; ++i) {
		if((!g_Zombie[id] && ITEMS_EXTRAS[i][extraTeam] == EXTRA_ZOMBIE) || (g_Zombie[id] && ITEMS_EXTRAS[i][extraTeam] == EXTRA_HUMAN)) {
			continue;
		}
		
		iCost = g_ItemExtra_Cost[id][i];
		
		sItemPerUser[0] = EOS;
		sItemPerMap[0] = EOS;
		
		if(ITEMS_EXTRAS[i][extraMaxPerUser]) {
			switch(i) {
				case EXTRA_BOMBA_ANIQUILACION: {
					TrieGetCell(g_tExtra_BombaAniquilacion, g_AccountName[id], iValue);
				} case EXTRA_BOMBA_ANTIDOTO: {
					TrieGetCell(g_tExtra_BombaAntidoto, g_AccountName[id], iValue);
				} case EXTRA_INMUNIDAD: {
					TrieGetCell(g_tExtra_Inmunidad, g_AccountName[id], iValue);
				} case EXTRA_ANTIDOTO: {
					TrieGetCell(g_tExtra_Antidoto, g_AccountName[id], iValue);
				} case EXTRA_FURIA: {
					TrieGetCell(g_tExtra_Furia, g_AccountName[id], iValue);
				} case EXTRA_BOMBA_INFECCION: {
					TrieGetCell(g_tExtra_BombaInfeccion, g_AccountName[id], iValue);
				} case EXTRA_PETRIFICACION: {
					TrieGetCell(g_tExtra_Petrificacion, g_AccountName[id], iValue);
				}
			}
			
			if(iValue < 0) {
				iValue = 0;
			}
			
			formatex(sItemPerUser, 13, "\w[%d\r/\w%d]", iValue, ITEMS_EXTRAS[i][extraMaxPerUser]);
		}
		
		if(ITEMS_EXTRAS[i][extraMaxPerMap]) {
			formatex(sItemPerMap, 13, "\w[%d\r/\w%d]", g_ItemExtra_PerMap[i], ITEMS_EXTRAS[i][extraMaxPerMap]);
		}
		
		if(iCost > 999) {
			addDot(iCost, sCost, 10);
			formatex(sItem, charsmax(sItem), "%s \y(%s APs) %s%s", ITEMS_EXTRAS[i][extraName], sCost, sItemPerUser, sItemPerMap);
		} else {
			formatex(sItem, charsmax(sItem), "%s \y(%d APs) %s%s", ITEMS_EXTRAS[i][extraName], iCost, sItemPerUser, sItemPerMap);
		}
		
		num_to_str((i + 1), sPosition, 2);
		
		menu_additem(iMenuId, sItem, sPosition);
	}
	
	menu_setprop(iMenuId, MPROP_BACKNAME, "Atrás");
	menu_setprop(iMenuId, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(iMenuId, MPROP_EXITNAME, "Volver");
	
	g_MenuPage[id][MENU_ITEMS_EXTRAS] = min(g_MenuPage[id][MENU_ITEMS_EXTRAS], menu_pages(iMenuId) - 1);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, g_MenuPage[id][MENU_ITEMS_EXTRAS]);
}

public menu__BuyExtras(const id, const menuid, const item) {
	if(!g_IsAlive[id]) {
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	static iMenuDummy;
	player_menu_info(id, iMenuDummy, iMenuDummy, g_MenuPage[id][MENU_ITEMS_EXTRAS]);
	
	if(((g_SpecialMode[id] || g_NewRound || g_EndRound) && !g_Kiske[id]) || item == MENU_EXIT) {
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	static sItemId[3];
	static iValue;
	static iItemId;
	static iCost;
	
	menu_item_getinfo(menuid, item, iValue, sItemId, 2, _, _, iValue);
	
	iItemId = str_to_num(sItemId) - 1;
	
	iCost = g_ItemExtra_Cost[id][iItemId];
	
	if((g_AmmoPacks[id] - iCost) < 0.0) {
		colorChat(id, _, "%sNo tenés suficientes ammo packs", ZP_PREFIX);
		
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	switch(iItemId) {
		case EXTRA_NIGHTVISION: {
			checkAchievements_ItemsExtras(id, iItemId);
			
			setNightvision(id, 1);
		} case EXTRA_LONGJUMP_H: {
			if(g_LongJump[id]) {
				colorChat(id, _, "%sYa tenés long jump", ZP_PREFIX);
				
				DestroyLocalMenu(id, menuid);
				return PLUGIN_HANDLED;
			}
			
			checkAchievements_ItemsExtras(id, iItemId);
			
			set_pdata_int(id, OFFSET_LONG_JUMP, 1, OFFSET_LINUX);
			
			g_LongJump[id] = 1;
			g_InJump[id] = 0;
		} case EXTRA_BOMBA_ANIQUILACION: {
			TrieGetCell(g_tExtra_BombaAniquilacion, g_AccountName[id], iValue);
			
			if(iValue < 0) {
				iValue = 0;
			}
			
			if(!g_Kiske[id]) {
				if(iValue == ITEMS_EXTRAS[iItemId][extraMaxPerUser] || g_ItemExtra_PerMap[iItemId] == ITEMS_EXTRAS[iItemId][extraMaxPerMap]) {
					DestroyLocalMenu(id, menuid);
					return PLUGIN_HANDLED;
				} else if(g_Mode != MODE_INFECTION && g_Mode != MODE_MULTI) {
					colorChat(id, _, "%sSolo puede comprarse en modo primer zombie o infección múltiple", ZP_PREFIX);
					
					DestroyLocalMenu(id, menuid);
					return PLUGIN_HANDLED;
				}
				
				++g_ItemExtra_PerMap[iItemId];
			}
			
			TrieSetCell(g_tExtra_BombaAniquilacion, g_AccountName[id], iValue + 1);
			
			checkAchievements_ItemsExtras(id, iItemId);
			
			++g_Annihilation_Bomb[id];
			
			if(user_has_weapon(id, CSW_HEGRENADE)) {
				cs_set_user_bpammo(id, CSW_HEGRENADE, cs_get_user_bpammo(id, CSW_HEGRENADE) + 1);
			} else {
				give_item(id, "weapon_hegrenade");
			}
		} case EXTRA_BALAS_INFINITAS: {
			if(g_UnlimitedClip[id]) {
				colorChat(id, _, "%sYa tenés balas infinitas", ZP_PREFIX);
				
				DestroyLocalMenu(id, menuid);
				return PLUGIN_HANDLED;
			}
			
			checkAchievements_ItemsExtras(id, iItemId);
			
			g_UnlimitedClip[id] = 1;
		} case EXTRA_BOMBA_ANTIDOTO: {
			TrieGetCell(g_tExtra_BombaAntidoto, g_AccountName[id], iValue);
			
			if(iValue < 0) {
				iValue = 0;
			}
			
			if(!g_Kiske[id]) {
				if(iValue == ITEMS_EXTRAS[iItemId][extraMaxPerUser] || g_ItemExtra_PerMap[iItemId] == ITEMS_EXTRAS[iItemId][extraMaxPerMap]) {
					DestroyLocalMenu(id, menuid);
					return PLUGIN_HANDLED;
				} else if(g_Mode != MODE_INFECTION && g_Mode != MODE_MULTI) {
					colorChat(id, _, "%sSolo puede comprarse en modo primer zombie o infección múltiple", ZP_PREFIX);
					
					DestroyLocalMenu(id, menuid);
					return PLUGIN_HANDLED;
				}
				
				++g_ItemExtra_PerMap[iItemId];
			}
			
			TrieSetCell(g_tExtra_BombaAntidoto, g_AccountName[id], iValue + 1);
			
			checkAchievements_ItemsExtras(id, iItemId);
			
			++g_Antidote_Bomb[id];
			
			if(user_has_weapon(id, CSW_SMOKEGRENADE)) {
				cs_set_user_bpammo(id, CSW_SMOKEGRENADE, cs_get_user_bpammo(id, CSW_SMOKEGRENADE) + 1);
			} else {
				give_item(id, "weapon_smokegrenade");
			}
		} case EXTRA_INMUNIDAD: {
			TrieGetCell(g_tExtra_Inmunidad, g_AccountName[id], iValue);
			
			if(iValue < 0) {
				iValue = 0;
			}
			
			if(!g_Kiske[id]) {
				if(iValue == ITEMS_EXTRAS[iItemId][extraMaxPerUser] || g_ItemExtra_PerMap[iItemId] == ITEMS_EXTRAS[iItemId][extraMaxPerMap]) {
					DestroyLocalMenu(id, menuid);
					return PLUGIN_HANDLED;
				} else if(g_Mode != MODE_INFECTION && g_Mode != MODE_MULTI) {
					colorChat(id, _, "%sSolo puede comprarse en modo primer zombie o infección múltiple", ZP_PREFIX);
					
					DestroyLocalMenu(id, menuid);
					return PLUGIN_HANDLED;
				}
				
				++g_ItemExtra_PerMap[iItemId];
			}

			TrieSetCell(g_tExtra_Inmunidad, g_AccountName[id], iValue + 1);
			
			checkAchievements_ItemsExtras(id, iItemId);
			
			g_Immunity[id] = 1;
			g_SpeedGravity[id] = g_Speed[id];
			
			set_user_rendering(id, kRenderFxGlowShell, 255, 255, 255, kRenderNormal, 4);
			
			client_cmd(id, "spk ^"%s^"", g_SOUND_Power_Start);
			
			remove_task(id + TASK_IMMUNITY);
			set_task(10.0, "task__RemoveImmunity", id + TASK_IMMUNITY);
		} case EXTRA_ANTIDOTO: {
			// if(g_Frozen[id]) {
				// colorChat(id, _, "%sNo puede comprarse mientras estás congelado", ZP_PREFIX);
				
				// DestroyLocalMenu(id, menuid);
				// return PLUGIN_HANDLED;
			// }
			
			TrieGetCell(g_tExtra_Antidoto, g_AccountName[id], iValue);
			
			if(iValue < 0) {
				iValue = 0;
			}
			
			if(!g_Kiske[id]) {
				if(iValue == ITEMS_EXTRAS[iItemId][extraMaxPerUser]) {
					DestroyLocalMenu(id, menuid);
					return PLUGIN_HANDLED;
				} else if((g_Mode != MODE_INFECTION && g_Mode != MODE_MULTI) || getZombies() <= 1) {
					colorChat(id, _, "%sSolo puede comprarse en modo primer zombie o infección múltiple y debe haber 2+ zombies", ZP_PREFIX);
					
					DestroyLocalMenu(id, menuid);
					return PLUGIN_HANDLED;
				}
			}
			
			TrieSetCell(g_tExtra_Antidoto, g_AccountName[id], iValue + 1);
			
			if(iValue == 3) {
				setAchievement(id, ODIO_SER_ZOMBIE);
			}
			
			checkAchievements_ItemsExtras(id, iItemId);
			
			humanMe(id);
		} case EXTRA_FURIA: {
			if(g_Frozen[id]) {
				colorChat(id, _, "%sNo puede comprarse mientras estás congelado", ZP_PREFIX);
				
				DestroyLocalMenu(id, menuid);
				return PLUGIN_HANDLED;
			}
			
			TrieGetCell(g_tExtra_Furia, g_AccountName[id], iValue);
			
			if(iValue < 0) {
				iValue = 0;
			}
			
			if(!g_Kiske[id]) {
				if(iValue == ITEMS_EXTRAS[iItemId][extraMaxPerUser] || g_ItemExtra_PerMap[iItemId] == ITEMS_EXTRAS[iItemId][extraMaxPerMap]) {
					DestroyLocalMenu(id, menuid);
					return PLUGIN_HANDLED;
				} else if(g_Mode != MODE_INFECTION && g_Mode != MODE_MULTI) {
					colorChat(id, _, "%sSolo puede comprarse en modo primer zombie o infección múltiple", ZP_PREFIX);
					
					DestroyLocalMenu(id, menuid);
					return PLUGIN_HANDLED;
				}
				
				++g_ItemExtra_PerMap[iItemId];
			}
			
			TrieSetCell(g_tExtra_Furia, g_AccountName[id], iValue + 1);
			
			++g_FuryConsecutive[id];
			
			if(g_FuryConsecutive[id] == 3) {
				g_FuryConsecutive[id] = 1;
			}
			
			checkAchievements_ItemsExtras(id, iItemId);
			
			g_Immunity[id] = 1;
			
			g_Aura[id][auraOn] = 1;
			g_Aura[id][auraRed] = 255;
			g_Aura[id][auraGreen] = 0;
			g_Aura[id][auraBlue] = 0;
			g_Aura[id][auraRadius] = 25;
			
			g_InfectsWithSameFury[id] = 0;
			
			++g_BuyAllFuryInSameRound[id];
			
			if(g_BuyAllFuryInSameRound[id] == 3) {
				giveHat(id, HAT_KISAME);
			}
			
			emit_sound(id, CHAN_BODY, g_SOUND_Zombie_Madness, 1.0, ATTN_NORM, 0, random_num(50, 200));
			
			remove_task(id + TASK_BLOOD);
			set_task(6.0 + float(g_Hab[id][CLASS_SPECIAL][HAB_SPECIAL_FURIA] * __HABILITIES[CLASS_SPECIAL][HAB_SPECIAL_FURIA][habValue]), "task__MadnessOver", id + TASK_BLOOD);
		} case EXTRA_BOMBA_INFECCION: {
			TrieGetCell(g_tExtra_BombaInfeccion, g_AccountName[id], iValue);
			
			if(iValue < 0) {
				iValue = 0;
			}
			
			if(!g_Kiske[id]) {
				if(iValue == ITEMS_EXTRAS[iItemId][extraMaxPerUser] || g_ItemExtra_PerMap[iItemId] == ITEMS_EXTRAS[iItemId][extraMaxPerMap]) {
					DestroyLocalMenu(id, menuid);
					return PLUGIN_HANDLED;
				} else if(g_Mode != MODE_INFECTION && g_Mode != MODE_MULTI) {
					colorChat(id, _, "%sSolo puede comprarse en modo primer zombie o infección múltiple", ZP_PREFIX);
					
					DestroyLocalMenu(id, menuid);
					return PLUGIN_HANDLED;
				}
				
				++g_ItemExtra_PerMap[iItemId];
			}
			
			TrieSetCell(g_tExtra_BombaInfeccion, g_AccountName[id], iValue + 1);
			
			checkAchievements_ItemsExtras(id, iItemId);
			
			if(user_has_weapon(id, CSW_HEGRENADE)) {
				cs_set_user_bpammo(id, CSW_HEGRENADE, cs_get_user_bpammo(id, CSW_HEGRENADE) + 1);
			} else {
				give_item(id, "weapon_hegrenade");
			}
		} case EXTRA_LONGJUMP_Z: {
			if(g_LongJump[id]) {
				colorChat(id, _, "%sYa tenés long jump", ZP_PREFIX);
				
				DestroyLocalMenu(id, menuid);
				return PLUGIN_HANDLED;
			}
			
			checkAchievements_ItemsExtras(id, iItemId);
			
			set_pdata_int(id, OFFSET_LONG_JUMP, 1, OFFSET_LINUX);
			
			g_LongJump[id] = 1;
			g_InJump[id] = 0;
		} case EXTRA_PETRIFICACION: {
			TrieGetCell(g_tExtra_Petrificacion, g_AccountName[id], iValue);
			
			if(iValue < 0) {
				iValue = 0;
			}
			
			if(!g_Kiske[id]) {
				if(iValue == ITEMS_EXTRAS[iItemId][extraMaxPerUser] || g_ItemExtra_PerMap[iItemId] == ITEMS_EXTRAS[iItemId][extraMaxPerMap]) {
					DestroyLocalMenu(id, menuid);
					return PLUGIN_HANDLED;
				} else if(g_Mode != MODE_INFECTION && g_Mode != MODE_MULTI) {
					colorChat(id, _, "%sSolo puede comprarse en modo primer zombie o infección múltiple", ZP_PREFIX);
					
					DestroyLocalMenu(id, menuid);
					return PLUGIN_HANDLED;
				}
				
				++g_ItemExtra_PerMap[iItemId];
			}
			
			TrieSetCell(g_tExtra_Petrificacion, g_AccountName[id], iValue + 1);
			
			checkAchievements_ItemsExtras(id, iItemId);
			
			g_Immunity[id] = 1;
			g_SpeedGravity[id] = g_Speed[id];
			g_Speed[id] = 1.0;
			
			ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
			
			set_user_rendering(id, kRenderFxGlowShell, 64, 64, 64, kRenderNormal, 4);
			
			client_cmd(id, "spk ^"%s^"", g_SOUND_Power_Start);
			
			remove_task(id + TASK_IMMUNITY);
			remove_task(id + TASK_REGENERATION);
			
			set_task(0.5, "task__HealthRegeneration", id + TASK_REGENERATION, _, _, "a", 10);
			set_task(5.0, "task__RemoveImmunity", id + TASK_IMMUNITY);
		}
	}
	
	addAmmopacks(id, (iCost * -1));
	
	iCost = (g_Reset[id] * 300) + g_Level[id];
	
	g_ItemExtra_Cost[id][iItemId] += iCost;
	
	DestroyLocalMenu(id, menuid);
	return PLUGIN_HANDLED;
}

public task__RemoveImmunity(const taskid) {
	new id = ID_IMMUNITY;
	
	g_Speed[id] = g_SpeedGravity[id];
	
	ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
	
	g_Immunity[id] = 0;
	set_user_rendering(id);
	
	client_cmd(id, "spk ^"%s^"", g_SOUND_Power_Finish);
}

public task__HealthRegeneration(const taskid) {
	static id;
	id = ID_REGENERATION;
	
	static vecOrigin[3];
	get_user_origin(id, vecOrigin);
	
	message_begin(MSG_PVS, SVC_TEMPENTITY, vecOrigin);
	write_byte(TE_PROJECTILE);
	write_coord(vecOrigin[0] + random_num(-10, 10));
	write_coord(vecOrigin[1] + random_num(-10, 10));
	write_coord(vecOrigin[2] + random_num(0, 30));
	write_coord(0);
	write_coord(0);
	write_coord(15);
	write_short(g_SPRITE_Regeneration);
	write_byte(1);
	write_byte(id);
	message_end();
	
	static i35_Percent;
	i35_Percent = (g_MaxHealth[id] * 35) / 1000;
	
	set_user_health(id, g_Health[id] + i35_Percent);
}

public task__MadnessOver(const taskid) {
	g_Immunity[ID_BLOOD] = 0;
	
	g_Aura[ID_BLOOD][auraOn] = 0;
	
	if(g_Mode == MODE_ALVSPRED && g_Alien[ID_BLOOD]) {
		if(!g_Alien_WithFury_HumanKills[ID_BLOOD]) {
			setAchievement(ID_BLOOD, ROJO_BAH);
		}
	} else if(!g_InfectsWithFury[ID_BLOOD]) {
		new iValue;
		
		TrieGetCell(g_tExtra_Furia, g_AccountName[ID_BLOOD], iValue);
		
		if(iValue == 3) {
			setAchievement(ID_BLOOD, PENSANDOLO_BIEN);
		}
	}
}

public showMenu__Class_Difficults(const id) {
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, "\yELEGIR CLASE^n\r1.\w Humano^n\r2.\w Zombie^n^n\yELEGIR DIFICULTAD^n\r3.\w Survivor^n\r4.\w Nemesis^n^n^n\r0.\w Volver", -1, "1 Class Difficults Menu");
}

public menu__Class_Difficults(const id, const key) {
	switch(key) {
		case 0: {
			showMenu__Class(id, CLASS_HUMAN);
		}
		case 1: {
			showMenu__Class(id, CLASS_ZOMBIE);
		}
		case 2: {
			showMenu__Difficults(id, DIFF_SURVIVOR);
		}
		case 3: {
			showMenu__Difficults(id, DIFF_NEMESIS);
		}
		case 9: {
			showMenu__Game(id);
		}
		default: {
			showMenu__Class_Difficults(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__Class(const id, const class) {
	static sMenu[450];
	static iStartLoop;
	static iEndLoop;
	static iLen;
	static i;
	static j;
	
	if(class == CLASS_HUMAN) {
		iLen = 0;
		iStartLoop = (g_MenuPage[id][MENU_HUMAN_CLASS] * 8);
		iEndLoop = clamp(((g_MenuPage[id][MENU_HUMAN_CLASS] + 1) * 8), 0, sizeof(CLASES_HUMANAS));
		
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yELEGIR CLASE HUMANA \r[%d - %d]^n^n", (iStartLoop + 1), iEndLoop);
		
		for(i = iStartLoop; i < iEndLoop; ++i) {
			j = (i + 1 - (g_MenuPage[id][MENU_HUMAN_CLASS] * 8));
			
			if(g_HumanClassNext[id] == i) {
				iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\d %s \y(ELEGIDO)^n", j, CLASES_HUMANAS[i][humanName]);
			} else if(g_Reset[id] > CLASES_HUMANAS[i][humanReset] || (g_Reset[id] == CLASES_HUMANAS[i][humanReset] && g_Level[id] >= CLASES_HUMANAS[i][humanLevel])) {
				iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\w %s \y(R\r:\y %d \r-\y LV\r:\y %d)^n", j, CLASES_HUMANAS[i][humanName], CLASES_HUMANAS[i][humanReset], CLASES_HUMANAS[i][humanLevel]);
			} else {
				iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\d %s (R: %d \r-\d LV: %d)^n", j, CLASES_HUMANAS[i][humanName], CLASES_HUMANAS[i][humanReset], CLASES_HUMANAS[i][humanLevel]);
			}
		}
		
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\r9.\w Siguiente/Atrás^n\r0. \wVolver");
		
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
		show_menu(id, KEYSMENU, sMenu, -1, "2 Human Class Menu");
	} else {
		iLen = 0;
		iStartLoop = (g_MenuPage[id][MENU_ZOMBIE_CLASS] * 8);
		iEndLoop = clamp(((g_MenuPage[id][MENU_ZOMBIE_CLASS] + 1) * 8), 0, sizeof(CLASES_ZOMBIE));
		
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yELEGIR CLASE ZOMBIE \r[%d - %d]^n^n", (iStartLoop + 1), iEndLoop);
		
		for(i = iStartLoop; i < iEndLoop; ++i) {
			j = (i + 1 - (g_MenuPage[id][MENU_ZOMBIE_CLASS] * 8));
			
			if(g_ZombieClassNext[id] == i) {
				iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\d %s \y(ELEGIDO)^n", j, CLASES_ZOMBIE[i][zombieName]);
			} else if(g_Reset[id] > CLASES_ZOMBIE[i][zombieReset] || (g_Reset[id] == CLASES_ZOMBIE[i][zombieReset] && g_Level[id] >= CLASES_ZOMBIE[i][zombieLevel])) {
				iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\w %s \y(R\r:\y %d \r-\y LV\r:\y %d)^n", j, CLASES_ZOMBIE[i][zombieName], CLASES_ZOMBIE[i][zombieReset], CLASES_ZOMBIE[i][zombieLevel]);
			} else {
				iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\d %s (R: %d \r-\d LV: %d)^n", j, CLASES_ZOMBIE[i][zombieName], CLASES_ZOMBIE[i][zombieReset], CLASES_ZOMBIE[i][zombieLevel]);
			}
		}
		
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n^n\r9.\w Siguiente/Atrás^n\r0. \wVolver");
		
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
		show_menu(id, KEYSMENU, sMenu, -1, "3 Zombie Class Menu");
	}
}

public menu__HumanClass(const id, const key) {
	new iSelection;
	iSelection = (g_MenuPage[id][MENU_HUMAN_CLASS] * 8) + key;
	
	if(key >= 8 || iSelection >= sizeof(CLASES_HUMANAS)) {
		switch(key) {
			case 8: {
				if(((g_MenuPage[id][MENU_HUMAN_CLASS] + 1) * 8) < sizeof(CLASES_HUMANAS)) {
					++g_MenuPage[id][MENU_HUMAN_CLASS];
				} else {
					g_MenuPage[id][MENU_HUMAN_CLASS] = 0;
				}
			}
			case 9: {
				showMenu__Class_Difficults(id);
				return PLUGIN_HANDLED;
			}
		}
		
		showMenu__Class(id, CLASS_HUMAN);
		return PLUGIN_HANDLED;
	}
	
	if(g_Reset[id] >= CLASES_HUMANAS[iSelection][humanReset] && g_Level[id] >= CLASES_HUMANAS[iSelection][humanLevel]) {
		g_HumanClassNext[id] = iSelection;
		
		colorChat(id, CT, "%sTu próxima clase humana será !g%s!y", ZP_PREFIX, CLASES_HUMANAS[iSelection][humanName]);
		colorChat(id, CT, "%sVida: !t%d!y - Velocidad: !t%0.2f!y - Gravedad: !t%0.1f!y - Daño: !t+%d%%!y", ZP_PREFIX, CLASES_HUMANAS[iSelection][humanHealth],
		CLASES_HUMANAS[iSelection][humanSpeed], (CLASES_HUMANAS[iSelection][humanGravity] * 800.0), CLASES_HUMANAS[iSelection][humanDamagePercent]);
	}
	
	showMenu__Class(id, CLASS_HUMAN);
	
	return PLUGIN_HANDLED;
}

public menu__ZombieClass(const id, const key) {
	new iSelection;
	iSelection = (g_MenuPage[id][MENU_ZOMBIE_CLASS] * 8) + key;
	
	if(key >= 8 || iSelection >= sizeof(CLASES_ZOMBIE)) {
		switch(key) {
			case 8: {
				if(((g_MenuPage[id][MENU_ZOMBIE_CLASS] + 1) * 8) < sizeof(CLASES_ZOMBIE)) {
					++g_MenuPage[id][MENU_ZOMBIE_CLASS];
				} else {
					g_MenuPage[id][MENU_ZOMBIE_CLASS] = 0;
				}
			}
			case 9: {
				showMenu__Class_Difficults(id);
				return PLUGIN_HANDLED;
			}
		}
		
		showMenu__Class(id, CLASS_ZOMBIE);
		return PLUGIN_HANDLED;
	}
	
	if(g_Reset[id] >= CLASES_ZOMBIE[iSelection][zombieReset] && g_Level[id] >= CLASES_ZOMBIE[iSelection][zombieLevel]) {
		new sHealth[11];
		addDot(CLASES_ZOMBIE[iSelection][zombieHealth], sHealth, 10);
		
		g_ZombieClassNext[id] = iSelection;
		
		colorChat(id, TERRORIST, "%sTu próxima clase zombie será !g%s!y", ZP_PREFIX, CLASES_ZOMBIE[iSelection][zombieName]);
		colorChat(id, TERRORIST, "%sVida: !t%s!y - Velocidad: !t%0.2f!y - Gravedad: !t%0.1f!y", ZP_PREFIX, sHealth,
		CLASES_ZOMBIE[iSelection][zombieSpeed], (CLASES_ZOMBIE[iSelection][zombieGravity] * 800.0));
	}
	
	showMenu__Class(id, CLASS_ZOMBIE);
	
	return PLUGIN_HANDLED;
}

public showMenu__Difficults(const id, const class_diff) {
	g_MenuPage[id][MENU_DIFFICULTS] = class_diff;
	
	static sMenu[450];
	static iLen;
	static i;
	
	iLen = 0;
	
	switch(class_diff) {
		case DIFF_SURVIVOR: {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yELEGIR DIFICULTAD SURVIVOR^n^n");
		}
		case DIFF_NEMESIS: {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yELEGIR DIFICULTAD NEMESIS^n^n");
		}
	}
	
	for(i = 0; i < diffIds; ++i) {
		if(g_Difficults[id][class_diff] != i) {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\w %s^n    %s^n^n", (i + 1), DIFFICULTS_MENU[class_diff][i][diffName], DIFFICULTS_MENU[class_diff][i][diffInfo]);
		} else {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\d %s \y(ELEGIDO)^n\w    %s^n^n", (i + 1), DIFFICULTS_MENU[class_diff][i][diffName], DIFFICULTS_MENU[class_diff][i][diffInfo]);
		}
	}
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\r0. \wVolver");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "4 Difficults Menu");
}

public menu__Difficults(const id, const key) {
	if(g_SpecialMode[id] == MODE_SURVIVOR && g_MenuPage[id][MENU_DIFFICULTS] == DIFF_SURVIVOR) {
		colorChat(id, _, "%sNo podés cambiar la dificultad del Survivor siendo Survivor", ZP_PREFIX);
		
		showMenu__Difficults(id, g_MenuPage[id][MENU_DIFFICULTS]);
		return PLUGIN_HANDLED;
	} else if(g_SpecialMode[id] == MODE_NEMESIS && g_MenuPage[id][MENU_DIFFICULTS] == DIFF_NEMESIS) {
		colorChat(id, _, "%sNo podés cambiar la dificultad del Nemesis siendo Nemesis", ZP_PREFIX);
	
		showMenu__Difficults(id, g_MenuPage[id][MENU_DIFFICULTS]);
		return PLUGIN_HANDLED;
	}
	
	switch(key) {
		case DIFF_NORMAL..DIFF_LEYENDA: {
			g_Difficults[id][g_MenuPage[id][MENU_DIFFICULTS]] = key;
			
			if(g_MenuPage[id][MENU_DIFFICULTS] == DIFF_SURVIVOR) {
				colorChat(id, CT, "%sLa dificultad de tu modo !tSurvivor!y ahora es !t%s!y", ZP_PREFIX, DIFFICULTS_MENU[g_MenuPage[id][MENU_DIFFICULTS]][key][diffName]);
			} else {
				colorChat(id, TERRORIST, "%sLa dificultad de tu modo !tNemesis!y ahora es !t%s!y", ZP_PREFIX, DIFFICULTS_MENU[g_MenuPage[id][MENU_DIFFICULTS]][key][diffName]);
			}
		}
		case 9: {
			showMenu__Class_Difficults(id);
			return PLUGIN_HANDLED;
		}
	}
	
	showMenu__Difficults(id, g_MenuPage[id][MENU_DIFFICULTS]);
	
	return PLUGIN_HANDLED;
}

public showMenu__Habilities(const id) {
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, "\yHABILIDADES^n^n\r1.\w Humano^n\r2.\w Zombie^n^n\r3.\w Modos^n\r4.\w Especiales^n^n\r5.\w Legendarias^n\r6.\w Legado^n^n\r7.\w Elegir maestría^n^n\r9. \y¡COMPRAR PUNTOS!^n^n\r0.\w Volver", -1, "1 Habilities Menu");
}

public menu__Habilities(const id, key) {
	switch(key) {
		case 0..5: {
			if(key > 2) {
				key += 3;
			}
			
			showMenu__Habilities_Class(id, key);
		}
		case 6: {
			showMenu__Mastery(id, .masteryId=0);
		}
		case 8: {
			colorChat(id, _, "%sPara comprar recursos entra en: !gzp.cimsp.net/shop!y", ZP_PREFIX);
			
			showMenu__Habilities(id);
		}
		case 9: {
			showMenu__Game(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__Habilities_Class(const id, const class) {
	if(class == 2) {
		showMenu__Habs_ChooseModes(id);
	} else {
		g_MenuPage[id][MENU_HABILITIES] = class;
		
		static sMenu[450];
		static iCost;
		static iLen;
		static i;
		
		iLen = 0;
		
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\y%s^n\w%s\r: \y%d^n^n", MENU_HABS_TITLE[class][menuClassName], MENU_HABS_TITLE[class][menuPointsName], g_Points[id][MENU_HABS_TITLE[class][menuPointsId]]);
		
		for(i = 0; i < MAX_HABILITIES; ++i) {
			if(__HABILITIES[class][i][habMaxLevel]) {
				if(class == CLASS_SPECIAL || class == CLASS_LEGENDARIAS || class == CLASS_LEGADO) {
					iCost = __HABILITIES[class][i][habCost];
				} else {
					iCost = (g_Hab[id][class][i] + 1) * __HABILITIES[class][i][habCost];
				}
				
				if(g_Points[id][MENU_HABS_TITLE[class][menuPointsId]] >= iCost) {
					if(g_Hab[id][class][i] < __HABILITIES[class][i][habMaxLevel]) {
						iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\w %s\w [\y%d\r /\y %d\w][Costo\r:\y %d\w]^n", (i + 1), __HABILITIES[class][i][menuHabName], g_Hab[id][class][i], __HABILITIES[class][i][habMaxLevel], iCost);
					} else {
						iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\y %s\w [\y%d\r /\y %d\w]\y[FULL]^n", (i + 1), __HABILITIES[class][i][menuHabName], g_Hab[id][class][i], __HABILITIES[class][i][habMaxLevel]);
					}
				} else {
					iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\d %s [%d\r /\d %d][Costo\r:\d %d]^n", (i + 1), __HABILITIES[class][i][menuHabName], g_Hab[id][class][i], __HABILITIES[class][i][habMaxLevel], iCost);
				}
			}
		}
		
		if(class < 2) { // Solo Humano y Zombie
			iCost = (g_Hab_Reset[id][class]) * 3;
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\r8.\w Reiniciar habilidades [Costo\r:\y %d]^n", iCost);
		}
		
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\r0. \wVolver");
		
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
		show_menu(id, KEYSMENU, sMenu, -1, "2 Habilities Menu");
	}
	
	return PLUGIN_HANDLED;
}

public menu__Habilities_Class(const id, const key) {
	switch(key) {
		case 0..(MAX_HABILITIES-1): {
			if(g_Hab[id][g_MenuPage[id][MENU_HABILITIES]][key] != __HABILITIES[g_MenuPage[id][MENU_HABILITIES]][key][habMaxLevel]) {
				new iCost;
				
				if(g_MenuPage[id][MENU_HABILITIES] == CLASS_SPECIAL || g_MenuPage[id][MENU_HABILITIES] == CLASS_LEGENDARIAS || g_MenuPage[id][MENU_HABILITIES] == CLASS_LEGADO) {
					iCost = __HABILITIES[g_MenuPage[id][MENU_HABILITIES]][key][habCost];
				} else {
					iCost = (g_Hab[id][g_MenuPage[id][MENU_HABILITIES]][key] + 1) * __HABILITIES[g_MenuPage[id][MENU_HABILITIES]][key][habCost];
				}
				
				if(g_Points[id][MENU_HABS_TITLE[g_MenuPage[id][MENU_HABILITIES]][menuPointsId]] >= iCost) {
					if(g_Hab[id][g_MenuPage[id][MENU_HABILITIES]][key] < __HABILITIES[g_MenuPage[id][MENU_HABILITIES]][key][habMaxLevel]) {
						g_Points[id][MENU_HABS_TITLE[g_MenuPage[id][MENU_HABILITIES]][menuPointsId]] -= iCost;
						g_PointsLost[id][MENU_HABS_TITLE[g_MenuPage[id][MENU_HABILITIES]][menuPointsId]] += iCost;
						
						++g_Hab[id][g_MenuPage[id][MENU_HABILITIES]][key];
						
						if((g_MenuPage[id][MENU_HABILITIES] == CLASS_ZOMBIE && key == HAB_Z_RESPAWN) || 
						(g_MenuPage[id][MENU_HABILITIES] == CLASS_SPECIAL && key == HAB_SPECIAL_RESPAWN) ||
						(g_MenuPage[id][MENU_HABILITIES] == CLASS_LEGENDARIAS && key == HAB_LEGENDARY_RESPAWN) ||
						(g_MenuPage[id][MENU_HABILITIES] == CLASS_LEGADO && key == HAB_LEGADO_RESPAWN)) {
							g_RandomRespawn[id] += __HABILITIES[g_MenuPage[id][MENU_HABILITIES]][key][habValue];
						}
						
						else if(g_MenuPage[id][MENU_HABILITIES] == CLASS_LEGADO) {
							if(key == HAB_LEGADO_MULT_APS) {
								g_Legado_MultAps[id] += (g_Hab[id][g_MenuPage[id][MENU_HABILITIES]][key] * 0.1);
							}
						}
						
						else if(g_MenuPage[id][MENU_HABILITIES] == CLASS_LEGENDARIAS && key == HAB_LEGENDARY_INDUCCION) {
							g_Induccion[id] += __HABILITIES[g_MenuPage[id][MENU_HABILITIES]][key][habValue];
						}
						
						else if(g_MenuPage[id][MENU_HABILITIES] == CLASS_HUMAN && key == HAB_SPEED) {
							if(g_Hab[id][g_MenuPage[id][MENU_HABILITIES]][key] == __HABILITIES[g_MenuPage[id][MENU_HABILITIES]][key][habMaxLevel]) {
								giveHat(id, HAT_MASTER_CHIEF);
							}
						}
						
						else if(g_MenuPage[id][MENU_HABILITIES] == CLASS_WESKER) {
							if(key == HAB_W_SUPER_LASER) {
								setAchievement(id, SUPER_LASER);
							} else if(key == HAB_W_COMBO) {
								setAchievement(id, DEAGLE_COMBERA);
							}
						}
						
						else if(g_MenuPage[id][MENU_HABILITIES] == CLASS_JASON) {
							if(key == HAB_J_TELEPORT) {
								setAchievement(id, JASON_EL_TRANSPORTADOR);
							} else if(key == HAB_J_COMBO) {
								setAchievement(id, MOTOSIERRA_COMBERA);
							}
						}
					}
				}
			}
		} case 7: {
			if(g_MenuPage[id][MENU_HABILITIES] < 2) {
				showMenu__Habilities_Reset(id, g_MenuPage[id][MENU_HABILITIES]);
				return PLUGIN_HANDLED;
			}
		} case 9: {
			showMenu__Habilities(id);
			return PLUGIN_HANDLED;
		}
	}
	
	showMenu__Habilities_Class(id, g_MenuPage[id][MENU_HABILITIES]);
	
	return PLUGIN_HANDLED;
}

public showMenu__Habilities_Reset(const id, const class) {
	static sMenu[200];
	static iCost;
	
	iCost = (g_Hab_Reset[id][class]) * 3;
	
	formatex(sMenu, charsmax(sMenu), "\y%s^n\w%s\r: \y%d^n^n\wCosto\r:\y %d^n^n\r¿\yEstás seguro de reiniciar tus habilidades\r?^n\r1.\w Si^n\r2.\w No^n^n^n\r0. \wVolver",
	MENU_HABS_TITLE[class][menuClassName], MENU_HABS_TITLE[class][menuPointsName], g_Points[id][MENU_HABS_TITLE[class][menuPointsId]], iCost);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "5 Habilities Menu");
}

public menu__Habilities_Reset(const id, const key) {
	switch(key) {
		case 0: {
			new iCost;
			iCost = (g_Hab_Reset[id][g_MenuPage[id][MENU_HABILITIES]]) * 3;
			
			if(g_Points[id][MENU_HABS_TITLE[g_MenuPage[id][MENU_HABILITIES]][menuPointsId]] >= iCost) {
				new iHab;
				new i;
				
				iHab = 0;
				
				for(i = 0; i < MAX_HABILITIES; ++i) {
					if(__HABILITIES[g_MenuPage[id][MENU_HABILITIES]][i][habMaxLevel]) {
						if(g_Hab[id][g_MenuPage[id][MENU_HABILITIES]][i]) {
							g_Hab[id][g_MenuPage[id][MENU_HABILITIES]][i] = 0;
							iHab = 1;
						}
					}
				}
				
				if(iHab) {
					g_Points[id][MENU_HABS_TITLE[g_MenuPage[id][MENU_HABILITIES]][menuPointsId]] -= iCost;
					g_Points[id][MENU_HABS_TITLE[g_MenuPage[id][MENU_HABILITIES]][menuPointsId]] += g_PointsLost[id][MENU_HABS_TITLE[g_MenuPage[id][MENU_HABILITIES]][menuPointsId]];
					
					if(g_PointsLost[id][MENU_HABS_TITLE[g_MenuPage[id][MENU_HABILITIES]][menuPointsId]] < 1000) {
						colorChat(id, _, "%sTus habilidades fueron reiniciadas. Obtuviste !g%dp%c!y", ZP_PREFIX, g_PointsLost[id][MENU_HABS_TITLE[g_MenuPage[id][MENU_HABILITIES]][menuPointsId]], (g_MenuPage[id][MENU_HABILITIES] == CLASS_HUMAN) ? 'H' : 'Z');
					} else {
						new sPoints[11];
						addDot(g_PointsLost[id][MENU_HABS_TITLE[g_MenuPage[id][MENU_HABILITIES]][menuPointsId]], sPoints, 10);
						
						colorChat(id, _, "%sTus habilidades fueron reiniciadas. Obtuviste !g%sp%c!y", ZP_PREFIX, sPoints, (g_MenuPage[id][MENU_HABILITIES] == CLASS_HUMAN) ? 'H' : 'Z');
					}
					
					g_PointsLost[id][MENU_HABS_TITLE[g_MenuPage[id][MENU_HABILITIES]][menuPointsId]] = 0;
				} else {
					colorChat(id, _, "%sNo tenés habilidades para reiniciar!", ZP_PREFIX);
				}
			} else {
				colorChat(id, _, "%sNo tenés suficientes puntos!", ZP_PREFIX);
			}
			
			showMenu__Habilities_Class(id, g_MenuPage[id][MENU_HABILITIES]);
		}
		case 1: {
			showMenu__Habilities_Class(id, g_MenuPage[id][MENU_HABILITIES]);
		}
		case 9: {
			showMenu__Habilities_Class(id, g_MenuPage[id][MENU_HABILITIES]);
		}
		default: {
			showMenu__Habilities_Reset(id, g_MenuPage[id][MENU_HABILITIES]);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__Habs_ChooseModes(const id) {
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, "\yHABILIDADES^n^n\r1.\w Survivor^n\r2.\w Nemesis^n^n\r3.\w Wesker^n\r4.\w Jason^n^n^n\r0.\w Volver", -1, "3 Habilities Menu");
}

public menu__Habilities_ChooseModes(const id, const key) {
	switch(key) {
		case 0..3: {
			showMenu__Habilities_Modes(id, key + 2);
		}
		case 9: {
			showMenu__Habilities(id);
		}
		default: {
			showMenu__Habs_ChooseModes(id);
		}
	}

	
	return PLUGIN_HANDLED;
}

public showMenu__Habilities_Modes(const id, const class) {
	g_MenuPage[id][MENU_HABILITIES] = class;
	
	static sMenu[450];
	static iCost;
	static iLen;
	static i;
	
	iLen = 0;
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\y%s^n\w%s\r: \y%d^n^n", MENU_HABS_TITLE[class][menuClassName], MENU_HABS_TITLE[class][menuPointsName], g_Points[id][MENU_HABS_TITLE[class][menuPointsId]]);
	
	for(i = 0; i < MAX_HABILITIES; ++i) {
		if(__HABILITIES[class][i][habMaxLevel]) {
			if(class == CLASS_SPECIAL || class == CLASS_LEGENDARIAS || class == CLASS_LEGADO) {
				iCost = __HABILITIES[class][i][habCost];
			} else {
				iCost = (g_Hab[id][class][i] + 1) * __HABILITIES[class][i][habCost];
			}
			
			if(g_Points[id][MENU_HABS_TITLE[class][menuPointsId]] >= iCost) {
				if(g_Hab[id][class][i] < __HABILITIES[class][i][habMaxLevel]) {
					iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\w %s\w [\y%d\r /\y %d\w][Costo\r:\y %d\w]^n", (i + 1), __HABILITIES[class][i][menuHabName], g_Hab[id][class][i], __HABILITIES[class][i][habMaxLevel], iCost);
				} else {
					iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\y %s\w [\y%d\r /\y %d\w]\y[FULL]^n", (i + 1), __HABILITIES[class][i][menuHabName], g_Hab[id][class][i], __HABILITIES[class][i][habMaxLevel]);
				}
			} else {
				iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\d %s [%d\r /\d %d][Costo\r:\d %d]^n", (i + 1), __HABILITIES[class][i][menuHabName], g_Hab[id][class][i], __HABILITIES[class][i][habMaxLevel], iCost);
			}
		}
	}
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\r0. \wVolver");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "4 Habilities Menu");
}

public menu__Habilities_Modes(const id, const key) {
	switch(key) {
		case 0..(MAX_HABILITIES-1): {
			if(__HABILITIES[g_MenuPage[id][MENU_HABILITIES]][key][habMaxLevel]) {
				new iCost;
				
				if(g_MenuPage[id][MENU_HABILITIES] == CLASS_SPECIAL || g_MenuPage[id][MENU_HABILITIES] == CLASS_LEGENDARIAS || g_MenuPage[id][MENU_HABILITIES] == CLASS_LEGADO) {
					iCost = __HABILITIES[g_MenuPage[id][MENU_HABILITIES]][key][habCost];
				} else {
					iCost = (g_Hab[id][g_MenuPage[id][MENU_HABILITIES]][key] + 1) * __HABILITIES[g_MenuPage[id][MENU_HABILITIES]][key][habCost];
				}
				
				if(g_Points[id][MENU_HABS_TITLE[g_MenuPage[id][MENU_HABILITIES]][menuPointsId]] >= iCost) {
					if(g_Hab[id][g_MenuPage[id][MENU_HABILITIES]][key] < __HABILITIES[g_MenuPage[id][MENU_HABILITIES]][key][habMaxLevel]) {
						g_Points[id][MENU_HABS_TITLE[g_MenuPage[id][MENU_HABILITIES]][menuPointsId]] -= iCost;
						g_PointsLost[id][MENU_HABS_TITLE[g_MenuPage[id][MENU_HABILITIES]][menuPointsId]] += iCost;
						
						++g_Hab[id][g_MenuPage[id][MENU_HABILITIES]][key];
					}
				}
			}
		} case 9: {
			showMenu__Habs_ChooseModes(id);
			return PLUGIN_HANDLED;
		}
	}
	
	showMenu__Habilities_Modes(id, g_MenuPage[id][MENU_HABILITIES]);
	
	return PLUGIN_HANDLED;
}

public showMenu__Mastery(const id, const masteryId) {
	if(masteryId) {
		static sMenu[300];
		static iCost;
		static iOk;
		
		if(g_Mastery[id]) {
			iOk = (g_Points[id][P_DIAMONDS] < 10) ? 0 : 1;
			iCost = 10;
		} else {
			iOk = 1;
			iCost = 0;
		}
		
		g_MenuPage[id][MENU_MASTERY] = masteryId;
		
		if(!iCost) {
			switch(masteryId) {
				case 1: {
					formatex(sMenu, charsmax(sMenu), "\yMAÑANA^n^n\wEsta maestría proporciona un \y+x1.0 APs\w^nmientras juegues entre las \y08:00\w y \y15:59\w^n^n\rIMPORTANTE:^n\wUna vez elegida la maestría, necesitarás diamantes para volver a cambiar!^n^n\
					\r1.\w Elegir esta maestría [%s%d Diamantes\w]^n^n\r0.\w Volver", (!iOk) ? "\d" : "\y", iCost);
				}
				case 2: {
					formatex(sMenu, charsmax(sMenu), "\yTARDE^n^n\wEsta maestría proporciona un \y+x1.0 APs\w^nmientras juegues entre las \y16:00\w y \y23:59\w^n^n\rIMPORTANTE:^n\wUna vez elegida la maestría, necesitarás diamantes para volver a cambiar!^n^n\
					\r1.\w Elegir esta maestría [%s%d Diamantes\w]^n^n\r0.\w Volver", (!iOk) ? "\d" : "\y", iCost);
				}
				case 3: {
					formatex(sMenu, charsmax(sMenu), "\yNOCHE^n^n\wEsta maestría proporciona un \y+x1.0 APs\w^nmientras juegues entre las \y00:00\w y \y07:59\w^n^n\rIMPORTANTE:^n\wUna vez elegida la maestría, necesitarás diamantes para volver a cambiar!^n^n\
					\r1.\w Elegir esta maestría [%s%d Diamantes\w]^n^n\r0.\w Volver", (!iOk) ? "\d" : "\y", iCost);
				}
			}
		} else {
			switch(masteryId) {
				case 1: {
					formatex(sMenu, charsmax(sMenu), "\yMAÑANA^n^n\wEsta maestría proporciona un \y+x1.0 APs\w^nmientras juegues entre las \y08:00\w y \y15:59\w^n^n\r1.\w Elegir esta maestría [%s%d Diamantes\w]^n^n\r0.\w Volver", (!iOk) ? "\d" : "\y", iCost);
				}
				case 2: {
					formatex(sMenu, charsmax(sMenu), "\yTARDE^n^n\wEsta maestría proporciona un \y+x1.0 APs\w^nmientras juegues entre las \y16:00\w y \y23:59\w^n^n\r1.\w Elegir esta maestría [%s%d Diamantes\w]^n^n\r0.\w Volver", (!iOk) ? "\d" : "\y", iCost);
				}
				case 3: {
					formatex(sMenu, charsmax(sMenu), "\yNOCHE^n^n\wEsta maestría proporciona un \y+x1.0 APs\w^nmientras juegues entre las \y00:00\w y \y07:59\w^n^n\r1.\w Elegir esta maestría [%s%d Diamantes\w]^n^n\r0.\w Volver", (!iOk) ? "\d" : "\y", iCost);
				}
			}
		}
		
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
		show_menu(id, KEYSMENU, sMenu, -1, "2 Mastery Menu");
	} else {
		static sMenu[250];
		
		formatex(sMenu, charsmax(sMenu), "\yELIGE TU MAESTRÍA^n\wSelecciona una para más información^n^n\r1.%s Mañana \w[\y08:00 \wa\y 15:59\w]^n\r2.%s Tarde \w[\y16:00 \wa\y 23:59\w]^n\r3.%s Noche \w[\y00:00 \wa\y 07:59\w]^n^n\r0. \wVolver",
		(g_Mastery[id] == MASTERY_MORNING) ? "\y" : (!g_Mastery[id]) ? "\w" : "\d", (g_Mastery[id] == MASTERY_AFTERNOON) ? "\y" : (!g_Mastery[id]) ? "\w" : "\d", (g_Mastery[id] == MASTERY_NIGHT) ? "\y" : (!g_Mastery[id]) ? "\w" : "\d");
		
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
		show_menu(id, KEYSMENU, sMenu, -1, "1 Mastery Menu");
	}
}

public menu__Mastery(const id, const key) {
	switch(key) {
		case 0..2: {
			showMenu__Mastery(id, .masteryId=key+1);
		}
		case 9: {
			showMenu__Habilities(id);
			return PLUGIN_HANDLED;
		}
		default: {
			showMenu__Mastery(id, .masteryId=0);
		}
	}
	
	return PLUGIN_HANDLED;
}

public menu__Mastery_Info(const id, const key) {
	switch(key) {
		case 0: {
			if(g_Mastery[id]) {
				if(g_Points[id][P_DIAMONDS] < 10) {
					showMenu__Mastery(id, .masteryId=g_MenuPage[id][MENU_MASTERY]);
				} else {
					colorChat(id, _, "%sHas cambiado tu maestría!", ZP_PREFIX);
					
					g_Mastery[id] = g_MenuPage[id][MENU_MASTERY];
					
					g_Points[id][P_DIAMONDS] -= 10;
					g_PointsLost[id][P_DIAMONDS] += 10;
					
					saveInfo(id, .disconnect=0);
				}
			} else {
				colorChat(id, _, "%sHas elegido una maestría!", ZP_PREFIX);
				
				g_Mastery[id] = g_MenuPage[id][MENU_MASTERY];
				
				giveHat(id, HAT_MASTERY);
			}
		}
		case 9: {
			showMenu__Mastery(id, .masteryId=0);
			return PLUGIN_HANDLED;
		}
		default: {
			showMenu__Mastery(id, .masteryId=g_MenuPage[id][MENU_MASTERY]);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__Group(const id) {
	static sMenu[350];
	static iLen;
	static i;
	
	iLen = 0;
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yGRUPO^n^n");
	
	for(i = 1; i < 4; ++i) {
		if(g_InGroup[id] && g_GroupId[g_InGroup[id]][i]) {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\w %s \y[R\r:\y %d][LV\r:\y %d]^n", i, g_UserName[g_GroupId[g_InGroup[id]][i]], g_Reset[g_GroupId[g_InGroup[id]][i]], g_Level[g_GroupId[g_InGroup[id]][i]]);
		} else {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\dHueco libre . . .^n");
		}
	}
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\r4.\y Invitar usuarios^n\r5.\w Invitación a otros grupos\r: \y%d^n^n^n\r0.\w Volver", g_GroupInvitations[id]);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "1 Group Menu");
}

public menu__Group(const id, key) {
	switch(key) {
		case 0..2: {
			++key;
			
			if(g_MyGroup[id]) {
				if(g_GroupId[g_InGroup[id]][key]) {
					showMenu__GroupInfo(id, key);
				} else {
					showMenu__Group(id);
				}
			} else {
				if(g_GroupId[g_InGroup[id]][key] == id) {
					showMenu__GroupInfo(id, key);
				} else {
					showMenu__Group(id);
				}
			}
		}
		case 3: {			
			if((g_MyGroup[id] && groupFindSlot(g_InGroup[id])) || !g_InGroup[id]) {
				showMenu__GroupInvite(id);
			} else {
				showMenu__Group(id);
			}
		}
		case 4: {
			if(!g_GroupInvitations[id] || g_InGroup[id]) {
				showMenu__Group(id);
			} else {
				showMenu__GroupInvitations(id);
			}
		}
		case 9: {
			showMenu__Game(id);
		}
		default: {
			showMenu__Group(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__GroupInfo(const id, const user) {
	g_MenuPage[id][MENU_GROUP_INFO] = user;
	
	if(g_GroupId[g_InGroup[id]][user] != id) {
		static sMenu[140];
		formatex(sMenu, charsmax(sMenu), "\yGRUPO^n^n\r¿\w Deseas expulsar a \y%s\w de tu grupo \r?^n\r1.\w Si^n\r2.\w No^n^n^n\r0.\w Volver", g_UserName[g_GroupId[g_InGroup[id]][user]]);
		
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
		show_menu(id, KEYSMENU, sMenu, -1, "2 Group Menu");
	} else {
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
		show_menu(id, KEYSMENU, "\yGRUPO^n^n\r¿\w Deseas salir de este grupo \r?^n\r1.\w Si^n\r2.\w No^n^n^n\r0.\w Volver", -1, "2 Group Menu");
	}
}

public menu__Group_Info(const id, const key) {
	switch(key) {
		case 0: {
			if(g_InGroup[id]) {
				checkGroup(id, g_MenuPage[id][MENU_GROUP_INFO], g_GroupId[g_InGroup[id]][g_MenuPage[id][MENU_GROUP_INFO]]);
			}
			
			showMenu__Group(id);
		}
		case 1: {
			showMenu__Group(id);
		}
		case 9: {
			showMenu__Group(id);
		}
		default: {
			showMenu__GroupInfo(id, g_MenuPage[id][MENU_GROUP_INFO]);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__GroupInvite(const id) {
	static sText[64];
	static sItem[2];
	static iMenuId;
	static i;
	
	iMenuId = menu_create("INVITAR USUARIOS AL GRUPO\R", "menu__GroupInvite");
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(!g_IsConnected[i]) {
			continue;
		}
		
		if(id == i) {
			continue;
		}
		
		if(g_InGroup[i]) {
			continue;
		}
		
		if(g_GroupInvitationsId[i][id]) {
			continue;
		}
		
		sItem[0] = i;
		sItem[1] = 0;
		
		formatex(sText, 63, "%s \y[R\r:\y %d][LV\r:\y %d]", g_UserName[i], g_Reset[i], g_Level[i]);
		
		menu_additem(iMenuId, sText, sItem);
	}
	
	if(menu_items(iMenuId) < 1) {
		colorChat(id, _, "%sNo hay usuarios disponibles para mostrar en el menú!", ZP_PREFIX);
		
		DestroyLocalMenu(id, iMenuId);
		
		showMenu__Group(id);
		return;
	}
	
	menu_setprop(iMenuId, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(iMenuId, MPROP_BACKNAME, "Atrás");
	menu_setprop(iMenuId, MPROP_EXITNAME, "Volver");
	
	g_MenuPage[id][MENU_GROUP_INVITE] = min(g_MenuPage[id][MENU_GROUP_INVITE], menu_pages(iMenuId) - 1);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, 0);
}

public menu__GroupInvite(const id, const menuid, const item) {
	if(!g_IsConnected[id]) {
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	static iNothing;
	player_menu_info(id, iNothing, iNothing, g_MenuPage[id][MENU_GROUP_INVITE]);
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuid);
		
		showMenu__Group(id);
		return PLUGIN_HANDLED;
	}
	
	static sItem[2];
	static iUser;
	
	menu_item_getinfo(menuid, item, iNothing, sItem, 1, _, _, iNothing);
	iUser = sItem[0];
	
	if(g_IsConnected[iUser]) {
		if(!g_InGroup[iUser]) {
			colorChat(id, CT, "%sEnviaste una invitación a !t%s!y para que se una a tu grupo!", ZP_PREFIX, g_UserName[iUser]);
			colorChat(iUser, CT, "%sEl usuario !t%s!y te invitó a su grupo!", ZP_PREFIX, g_UserName[id]);
			
			++g_GroupInvitations[iUser];
			
			g_GroupInvitationsId[iUser][id] = 1;
		} else {
			colorChat(id, _, "%sEl usuario seleccionado acaba de entrar en un grupo!", ZP_PREFIX);
		}
	} else {
		colorChat(id, _, "%sEl usuario seleccionado se ha desconectado!", ZP_PREFIX);
	}
	
	DestroyLocalMenu(id, menuid);
	
	showMenu__GroupInvite(id);
	return PLUGIN_HANDLED;
}

public showMenu__GroupInvitations(const id) {
	static sText[64];
	static sItem[2];
	static iMenuId;
	static i;
	
	iMenuId = menu_create("INVITACIONES A GRUPOS^n\wTe enviaron solicitud\r:\R", "menu__GroupInvitations");
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(!g_IsConnected[i]) {
			continue;
		}
		
		if(!g_GroupInvitationsId[id][i]) {
			continue;
		}
		
		sItem[0] = i;
		sItem[1] = 0;
		
		formatex(sText, 63, "%s \y[R\r:\y %d][LV\r:\y %d]", g_UserName[i], g_Reset[i], g_Level[i]);
		
		menu_additem(iMenuId, sText, sItem);
	}
	
	if(menu_items(iMenuId) < 1) {
		colorChat(id, _, "%s!gNo tenés solicitudes AASIGAHSDJAHSFOPASJKDF!y", ZP_PREFIX);
		
		DestroyLocalMenu(id, iMenuId);
		return;
	}
	
	menu_setprop(iMenuId, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(iMenuId, MPROP_BACKNAME, "Atrás");
	menu_setprop(iMenuId, MPROP_EXITNAME, "Volver");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, 0);
}

public menu__GroupInvitations(const id, const menuid, const item) {
	if(!g_IsConnected[id]) {
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuid);
		
		showMenu__Group(id);
		return PLUGIN_HANDLED;
	}
	
	new iNothing;
	new sItem[2];
	new iUser;
	
	menu_item_getinfo(menuid, item, iNothing, sItem, 1, _, _, iNothing);
	iUser = sItem[0];
	
	if(g_IsConnected[iUser]) {
		if(g_GroupInvitationsId[id][iUser]) {
			new iSlot;
			new i;
			
			if(!g_InGroup[iUser]) { // Está en grupo el que te invitó? Si no es así, crear un grupo!
				iSlot = groupFindId();
				
				g_MyGroup[iUser] = 1;
				g_InGroup[iUser] = iSlot;
				
				iSlot = groupFindSlot(g_InGroup[iUser]);
				
				g_GroupId[g_InGroup[iUser]][iSlot] = iUser;
				g_GroupId[g_InGroup[iUser]][0] = 1;
				
				g_GroupInvitations[iUser] = 0;
				
				for(i = 0; i <= g_MaxUsers; ++i) {
					g_GroupInvitationsId[iUser][i] = 0;
				}
			}
			
			iSlot = groupFindSlot(g_InGroup[iUser]); // Buscar un slot para el usuario que está intentando entrar
			
			if(iSlot) {
				g_InGroup[id] = g_InGroup[iUser];
				g_GroupId[g_InGroup[iUser]][iSlot] = id;
				
				g_GroupHUD[g_InGroup[id]][0] = EOS;
				
				g_HLTime_GroupCombo[g_InGroup[id]] = halflife_time() + 999999.9;
				
				for(i = 1; i < 4; ++i) {
					if(g_GroupId[g_InGroup[iUser]][i]) {
						colorChat(g_GroupId[g_InGroup[iUser]][i], CT, "%s!t%s!y se unió a tu grupo!", ZP_PREFIX, g_UserName[id]);
						
						add(g_GroupHUD[g_InGroup[id]], 127, g_UserName[g_GroupId[g_InGroup[iUser]][i]]);
						add(g_GroupHUD[g_InGroup[id]], 127, "^n");
					}
				}
				
				g_GroupInvitations[id] = 0;
				
				for(i = 0; i <= g_MaxUsers; ++i) {
					g_GroupInvitationsId[id][i] = 0;
				}
			} else {
				colorChat(id, _, "%sEl grupo al que intentaste entrar está lleno!", ZP_PREFIX);
			}
		} else {
			colorChat(id, _, "%sLa invitación al grupo ha expirado!", ZP_PREFIX);
		}
	} else {
		colorChat(id, _, "%sEl usuario seleccionado se ha desconectado!", ZP_PREFIX);
	}
	
	DestroyLocalMenu(id, menuid);
	
	if(g_GroupInvitations[id] && !g_InGroup[id]) {
		showMenu__GroupInvitations(id);
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__Clan(const id) {
	static sMenu[350];
	
	if(g_ClanId[id]) {
		formatex(sMenu, charsmax(sMenu), "\yCLAN\r:\y %s^nRank\r:\y %d^nTulio\r:\y %d^n^n\r1.\w Ver miembros (\yOnline\r:\y %d\w / \y%d\w)^n\r2.%s Invitar usuarios^n^n\r3.\w Ver información del clan^n^n\r5.\w Ver mejores clanes^n^n\r0.\w Volver",
		g_ClanName[g_InClan[id]], g_ClanRank[g_InClan[id]], g_ClanTulio[g_InClan[id]], g_ClanOnline[g_InClan[id]], g_ClanMembers[g_InClan[id]], (g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberRange] > 1) ? "\w" : "\d");
		
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
		show_menu(id, KEYSMENU, sMenu, -1, "1 Clan Menu");
	} else {
		formatex(sMenu, charsmax(sMenu), "\yCLAN^n^n\r1.\w Crear clan^n\r2.\w Invitaciones a clanes\r:\y %d^n^n\r3.\y Ver mejores clanes^n^n\r0.\w Volver", g_ClanInvitations[id]);
		
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
		show_menu(id, KEYSMENU, sMenu, -1, "1 Clan Menu");
	}
}

public menu__Clan(const id, key) {
	switch(key) {
		case 0: {
			if(g_ClanId[id]) {
				showMenu__Clan_Members(id);
			} else {
				if(get_user_flags(id) & ADMIN_RESERVATION) {
					client_cmd(id, "messagemode CREAR_CLAN");
					client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonOk);
					
					colorChat(id, _, "%sEscribe el nombre de tu clan, se aceptan hasta 14 caracteres!", ZP_PREFIX);
				} else {
					client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonBad);
					
					colorChat(id, _, "%sNecesitás ser !gusuario premium!y para crear un clan!", ZP_PREFIX);
					
					showMenu__Clan(id);
				}
			}
		} case 1: {
			if(g_ClanId[id]) {
				if(g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberRange] > 1) {
					showMenu__Clan_Invite(id);
				} else {
					showMenu__Clan(id);
				}
			} else if(g_ClanInvitations[id]) {
				showMenu__ClanInvitations(id);
			} else {
				showMenu__Clan(id);
			}
		} case 2: {
			if(g_ClanId[id]) {
				showMenu__ClanInfo(id);
			} else {
				menu__BestClans(id);
			}
		} case 4: {
			if(g_ClanId[id]) {
				menu__BestClans(id);
			} else {
				showMenu__Clan(id);
			}
		} case 9: {
			showMenu__Game(id);
		} default: {
			showMenu__Clan(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

public clcmd__CreateClan(const id) {
	if(!g_IsConnected[id]) {
		return PLUGIN_HANDLED;
	} else if(!g_AccountPJ_Logged[id]) {
		return PLUGIN_HANDLED;
	} else if(g_ClanId[id]) {
		return PLUGIN_HANDLED;
	}
	
	new sClan[15];
	
	read_args(sClan, 14);
	remove_quotes(sClan);
	trim(sClan);
	
	if(contain(sClan, "\\") != -1 ||
	contain(sClan, "%") != -1 ||
	contain(sClan, "^"") != -1) {
		colorChat(id, TERRORIST, "%s!tNo podés utilizar el simbolo %% , ni \, ni ^"", ZP_PREFIX);
		
		client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonBad);
		
		showMenu__Clan(id);
		return PLUGIN_HANDLED;
	}
	
	new iLenClan = strlen(sClan);
	
	if(iLenClan < 1) {
		colorChat(id, TERRORIST, "%s!tEl nombre del clan debe tener al menos un caracter!", ZP_PREFIX);
		
		client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonBad);
		
		showMenu__Clan(id);
		return PLUGIN_HANDLED;
	} else if(iLenClan > 14) {
		colorChat(id, TERRORIST, "%s!tEl nombre del clan debe tener menos de 15 caracteres!", ZP_PREFIX);
		
		client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonBad);
		
		showMenu__Clan(id);
		return PLUGIN_HANDLED;
	}
	
	copy(g_CreateClanName[id], 14, sClan);
	
	// Uso ThreadQuery por si algún pelotudo intenta floodear (aunque no se frizzea).
	new sQuery[90];
	new iData[1];
	
	iData[0] = id;
	
	formatex(sQuery, 89, "SELECT id FROM zp6_clanes WHERE name=^"%s^" LIMIT 1;", sClan);
	SQL_ThreadQuery(g_SqlTuple, "sqlThread__CheckClanName", sQuery, iData, 2);
	
	return PLUGIN_HANDLED;
}

public showMenu__Clan_Members(const id) {
	static sText[64];
	static sItem[2];
	static iMenuId;
	static i;
	static j;
	static k;
	
	formatex(sText, 63, "CLAN\r:\y %s^n\wMiembros\r:\y %d \r/\y 16", g_ClanName[g_InClan[id]], g_ClanMembers[g_InClan[id]]);
	iMenuId = menu_create(sText, "menu__Clan_Members");
	
	for(i = 0; i < 16; ++i) {
		if(!g_ClanMemberInfo[g_InClan[id]][i][memberId]) {
			continue;
		}
		
		sItem[0] = i;
		sItem[1] = 0;
		k = 0;
		
		for(j = 1; j <= g_MaxUsers; ++j) {
			if(!g_IsConnected[j]) {
				continue;
			}
			
			if(g_AccountId[j] == g_ClanMemberInfo[g_InClan[id]][i][memberId] && g_AccountPJs[id][g_UserSelected[id]] == g_ClanMemberInfo[g_InClan[id]][i][memberPj]) {
				menu_additem(iMenuId, g_ClanMemberName[g_InClan[id]][i], sItem);
				
				k = 1;
				break;
			}
		}
		
		if(!k) {
			formatex(sText, 63, "\d%s", g_ClanMemberName[g_InClan[id]][i]);
			menu_additem(iMenuId, sText, sItem);
		}
	}
	
	menu_setprop(iMenuId, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(iMenuId, MPROP_BACKNAME, "Atrás");
	menu_setprop(iMenuId, MPROP_EXITNAME, "Volver");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, 0);
}

public menu__Clan_Members(const id, const menuid, const item) {
	if(!g_IsConnected[id]) {
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuid);
		
		showMenu__Clan(id);
		return PLUGIN_HANDLED;
	}
	
	new iNothing;
	new sItem[2];
	new iUser;
	
	menu_item_getinfo(menuid, item, iNothing, sItem, 1, _, _, iNothing);
	iUser = sItem[0];
	
	DestroyLocalMenu(id, menuid);
	
	if(g_ClanMemberInfo[g_InClan[id]][iUser][memberId]) {
		showMenu__Clan_MemberInfo(id, iUser);
	} else {
		colorChat(id, _, "%sEl usuario seleccionado se acaba de ir del clan!", ZP_PREFIX);
		showMenu__Clan_Members(id);
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__Clan_MemberInfo(const id, const member) {
	g_MenuPage[id][MENU_CLAN_MEMBERID] = member;
	
	static sMenu[400];
	static sLastTimeSee[32];
	static sSince[32];
	static iOk;
	
	iOk = 0;
	
	if(g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberId] == g_ClanMemberInfo[g_InClan[id]][member][memberId] && g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberPj] == g_ClanMemberInfo[g_InClan[id]][member][memberPj]) {
		iOk = 0;
	} else if(g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberRange] == 3) {
		iOk = 1;
	}
	
	if(g_ClanMemberInfo[g_InClan[id]][member][memberLastTimeD] || g_ClanMemberInfo[g_InClan[id]][member][memberLastTimeH] || g_ClanMemberInfo[g_InClan[id]][member][memberLastTimeM]) {
		formatex(sLastTimeSee, 31, "%d %s", (g_ClanMemberInfo[g_InClan[id]][member][memberLastTimeD]) ? g_ClanMemberInfo[g_InClan[id]][member][memberLastTimeD] :
		(g_ClanMemberInfo[g_InClan[id]][member][memberLastTimeH]) ? g_ClanMemberInfo[g_InClan[id]][member][memberLastTimeH] : g_ClanMemberInfo[g_InClan[id]][member][memberLastTimeM],
		(g_ClanMemberInfo[g_InClan[id]][member][memberLastTimeD]) ? "días" : (g_ClanMemberInfo[g_InClan[id]][member][memberLastTimeH]) ? "horas" : "minutos");
	} else {
		formatex(sLastTimeSee, 31, "Conectado");
	}
	
	formatex(sSince, 31, "%d %s", (g_ClanMemberInfo[g_InClan[id]][member][memberSinceD]) ? g_ClanMemberInfo[g_InClan[id]][member][memberSinceD] :
	(g_ClanMemberInfo[g_InClan[id]][member][memberSinceH]) ? g_ClanMemberInfo[g_InClan[id]][member][memberSinceH] : g_ClanMemberInfo[g_InClan[id]][member][memberSinceM],
	(g_ClanMemberInfo[g_InClan[id]][member][memberSinceD]) ? "días" : (g_ClanMemberInfo[g_InClan[id]][member][memberSinceH]) ? "horas" : "minutos");
	
	formatex(sMenu, charsmax(sMenu), "\y%s^n^n\wReset\r:\y %d \r- \wNivel\r:\y %d^n\wTulio\r:\y %d^n\wRango\r:\y %s^n\wTiempo invertido esta semana\r: \y%s^n\wÚltima vez visto hace\r: \y%s^n\wMiembro desde hace\r:\y %s^n^n\
	\r3.%s Degradar a \yMiembro^n\r4.%s Promover a \yVeterano^n^n\r5.%s Expulsar usuario^n^n\r0.\w Volver",
	g_ClanMemberName[g_InClan[id]][member], g_ClanMemberInfo[g_InClan[id]][member][memberReset], g_ClanMemberInfo[g_InClan[id]][member][memberLevel], g_ClanMemberInfo[g_InClan[id]][member][memberTulio],
	(g_ClanMemberInfo[g_InClan[id]][member][memberRange] == 1) ? "Miembro" : (g_ClanMemberInfo[g_InClan[id]][member][memberRange] == 2) ? "Veterano" : "Dueño", g_ClanMemberInfo[g_InClan[id]][member][memberTimePlayed],
	sLastTimeSee, sSince, (!iOk || g_ClanMemberInfo[g_InClan[id]][member][memberRange] == 1) ? "\d" : "\w",
	(!iOk || g_ClanMemberInfo[g_InClan[id]][member][memberRange] == 2) ? "\d" : "\w", (!iOk) ? "\d" : "\w");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "2 Clan Menu");
}

public menu__Clan_MemberInfo(const id, key) {
	switch(key) {
		case 2: {
			if(g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberRange] == 3 && g_ClanMemberInfo[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]][memberRange] == 2) {
				new Float:fGameTime = get_gametime();
				if(g_Clan_QueryFlood[id] <= fGameTime) {
					g_Clan_QueryFlood[id] = fGameTime + 5.0;
					
					new sQuery[128];
					new sData[2];
					
					sData[0] = id;
					sData[1] = 0;
					
					formatex(sQuery, 127, "UPDATE zp6_clanes_miembros SET `range`='1' WHERE clan_id='%d' AND acc_id='%d' AND pj_id='%d' AND activo='1';", g_ClanId[id], g_ClanMemberInfo[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]][memberId],
					g_ClanMemberInfo[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]][memberPj]);
					
					SQL_ThreadQuery(g_SqlTuple, "sqlThread__Updates", sQuery, sData, 2);
					
					return PLUGIN_HANDLED;
				} else {
					colorChat(id, _, "%sEspera unos segundos antes de volver a modificar los rangos!", ZP_PREFIX);
				}
			}
			
			showMenu__Clan_MemberInfo(id, g_MenuPage[id][MENU_CLAN_MEMBERID]);
		}
		case 3: {
			if(g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberRange] == 3 && g_ClanMemberInfo[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]][memberRange] == 1) {
				new Float:fGameTime = get_gametime();
				if(g_Clan_QueryFlood[id] <= fGameTime) {
					g_Clan_QueryFlood[id] = fGameTime + 5.0;
					
					new sQuery[128];
					new sData[2];
					
					sData[0] = id;
					sData[1] = 1;
					
					formatex(sQuery, 127, "UPDATE zp6_clanes_miembros SET `range`='2' WHERE clan_id='%d' AND acc_id='%d' AND pj_id='%d' AND activo='1';", g_ClanId[id], g_ClanMemberInfo[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]][memberId],
					g_ClanMemberInfo[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]][memberPj]);
					
					SQL_ThreadQuery(g_SqlTuple, "sqlThread__Updates", sQuery, sData, 2);
					
					return PLUGIN_HANDLED;
				} else {
					colorChat(id, _, "%sEspera unos segundos antes de volver a modificar los rangos!", ZP_PREFIX);
				}
			}
			
			showMenu__Clan_MemberInfo(id, g_MenuPage[id][MENU_CLAN_MEMBERID]);
		}
		case 4: {
			if(g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberRange] != 3) {
				showMenu__Clan_MemberInfo(id, g_MenuPage[id][MENU_CLAN_MEMBERID]);
			} else if(g_AccountId[id] == g_ClanMemberInfo[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]][memberId] && g_AccountPJs[id][g_UserSelected[id]] == g_ClanMemberInfo[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]][memberPj]) {
				colorChat(id, _, "%sNo te podés expulsar vos mismo del clan!", ZP_PREFIX);
				
				showMenu__Clan_MemberInfo(id, g_MenuPage[id][MENU_CLAN_MEMBERID]);
			} else {
				new Handle:sqlQuery;
				sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE zp6_clanes_miembros SET activo='0' WHERE clan_id='%d' AND acc_id='%d' AND pj_id='%d' AND activo='1';", g_ClanId[id],
				g_ClanMemberInfo[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]][memberId], g_ClanMemberInfo[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]][memberPj]);
				
				if(!SQL_Execute(sqlQuery)) {
					executeQuery(id, sqlQuery, 2700);
				} else {
					SQL_FreeHandle(sqlQuery);
					
					sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE zp6_pjs SET clan='0' WHERE acc_id='%d' AND pj_id='%d';", g_ClanMemberInfo[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]][memberId],
					g_ClanMemberInfo[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]][memberPj]);
					
					--g_ClanMembers[g_InClan[id]];
					
					if(!SQL_Execute(sqlQuery)) {
						executeQuery(id, sqlQuery, 2800);
					} else {
						new i;
						new j = 0;
						
						for(i = 1; i <= g_MaxUsers; ++i) {
							if(!g_IsConnected[i]) {
								continue;
							}
							
							if(g_ClanId[id] != g_ClanId[i]) {
								continue;
							}
							
							colorChat(i, CT, "%s!t%s!y ha sido expulsado del clan!", ZP_PREFIX, g_ClanMemberName[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]]);
							
							if(id == i) {
								continue;
							}
							
							if(!j) {
								if(g_AccountId[i] == g_ClanMemberInfo[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]][memberId] && g_AccountPJs[i][g_UserSelected[i]] == g_ClanMemberInfo[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]][memberPj]) {
									--g_ClanOnline[g_InClan[i]];
									
									g_InClan[i] = 0;
									g_ClanId[i] = 0;
									g_ClanInPos[i] = 0;
									
									j = 1;
								}
							}
						}
						
						for(i = 0; i < structClanMemberInfo; ++i) {
							g_ClanMemberInfo[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]][i] = 0;
						}
						
						g_ClanMemberInfo[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]][memberTimePlayed][0] = EOS;
						
						SQL_FreeHandle(sqlQuery);
					}
				}
				
				showMenu__Clan_Members(id);
			}
		}
		case 9: {
			showMenu__Clan_Members(id);
		}
		default: {
			showMenu__Clan_MemberInfo(id, g_MenuPage[id][MENU_CLAN_MEMBERID]);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__Clan_Invite(const id) {
	static sText[64];
	static sItem[2];
	static iMenuId;
	static i;
	
	iMenuId = menu_create("INVITAR USUARIOS AL CLAN\R", "menu__Clan_Invite");
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(!g_IsConnected[i]) {
			continue;
		}
		
		if(id == i) {
			continue;
		}
		
		if(g_ClanId[i]) {
			continue;
		}
		
		if(g_ClanInvitationsId[i][id]) {
			continue;
		}
		
		sItem[0] = i;
		sItem[1] = 0;
		
		formatex(sText, 63, "%s \y[R\r:\y %d][LV\r:\y %d]", g_UserName[i], g_Reset[i], g_Level[i]);
		
		menu_additem(iMenuId, sText, sItem);
	}
	
	if(menu_items(iMenuId) < 1) {
		colorChat(id, _, "%sNo hay usuarios disponibles para mostrar en el menú!", ZP_PREFIX);
		
		DestroyLocalMenu(id, iMenuId);
		
		showMenu__Clan(id);
		return;
	}
	
	menu_setprop(iMenuId, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(iMenuId, MPROP_BACKNAME, "Atrás");
	menu_setprop(iMenuId, MPROP_EXITNAME, "Volver");
	
	g_MenuPage[id][MENU_CLAN_INVITE] = min(g_MenuPage[id][MENU_CLAN_INVITE], menu_pages(iMenuId) - 1);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, 0);
}

public menu__Clan_Invite(const id, const menuid, const item) {
	if(!g_IsConnected[id]) {
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	static iNothing;
	player_menu_info(id, iNothing, iNothing, g_MenuPage[id][MENU_CLAN_INVITE]);
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuid);
		
		showMenu__Clan(id);
		return PLUGIN_HANDLED;
	}
	
	static sItem[2];
	static iUser;
	
	menu_item_getinfo(menuid, item, iNothing, sItem, 1, _, _, iNothing);
	iUser = sItem[0];
	
	if(g_IsConnected[iUser]) {
		if(!g_ClanId[iUser]) {
			colorChat(id, CT, "%sEnviaste una invitación a !t%s!y para que se una a tu clan!", ZP_PREFIX, g_UserName[iUser]);
			colorChat(iUser, CT, "%sEl usuario !t%s!y te invitó al clan !g%s!y!", ZP_PREFIX, g_UserName[id], g_ClanName[g_InClan[id]]);
			
			++g_ClanInvitations[iUser];
			
			g_ClanInvitationsId[iUser][id] = 1;
		} else {
			colorChat(id, _, "%sEl usuario seleccionado acaba de entrar en un clan!", ZP_PREFIX);
		}
	} else {
		colorChat(id, _, "%sEl usuario seleccionado se ha desconectado!", ZP_PREFIX);
	}
	
	DestroyLocalMenu(id, menuid);
	
	showMenu__Clan_Invite(id);
	return PLUGIN_HANDLED;
}

public showMenu__ClanInvitations(const id) {
	static sText[64];
	static sItem[2];
	static iMenuId;
	static i;
	
	iMenuId = menu_create("INVITACIONES A CLANES^n\wTe enviaron solicitud\r:\R", "menu__ClanInvitations");
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(!g_IsConnected[i]) {
			continue;
		}
		
		if(!g_ClanInvitationsId[id][i]) {
			continue;
		}
		
		sItem[0] = i;
		sItem[1] = 0;
		
		formatex(sText, 63, "%s \r-\y %s", g_UserName[i], g_ClanName[g_InClan[i]]);
		
		menu_additem(iMenuId, sText, sItem);
	}
	
	if(menu_items(iMenuId) < 1) {
		colorChat(id, _, "%s!gNo tenés solicitudes AASIGAHSDJAHSFOPASJKDF!y", ZP_PREFIX);
		
		DestroyLocalMenu(id, iMenuId);
		return;
	}
	
	menu_setprop(iMenuId, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(iMenuId, MPROP_BACKNAME, "Atrás");
	menu_setprop(iMenuId, MPROP_EXITNAME, "Volver");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	ShowLocalMenu(id, iMenuId, 0);
}

public menu__ClanInvitations(const id, const menuid, const item) {
	if(!g_IsConnected[id]) {
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuid);
		
		showMenu__Group(id);
		return PLUGIN_HANDLED;
	}
	
	new iNothing;
	new sItem[2];
	new iUser;
	
	menu_item_getinfo(menuid, item, iNothing, sItem, 1, _, _, iNothing);
	iUser = sItem[0];
	
	if(g_IsConnected[iUser]) {
		if(g_ClanId[iUser]) {
			if(g_ClanMembers[g_InClan[iUser]] < 16) {
				if(g_ClanInvitationsId[id][iUser]) {
					new Handle:sqlQuery;
					sqlQuery = SQL_PrepareQuery(g_SqlConnection, "INSERT INTO zp6_clanes_miembros (`clan_id`, `acc_id`, `pj_id`, `name`, `since`) VALUES ('%d', '%d', '%d', ^"%s^", UNIX_TIMESTAMP());",
					g_ClanId[iUser], g_AccountId[id], g_AccountPJs[id][g_UserSelected[id]], g_UserName[id]);
					
					if(!SQL_Execute(sqlQuery)) {
						executeQuery(id, sqlQuery, 2900);
					} else {
						SQL_FreeHandle(sqlQuery);
						
						sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE zp6_pjs SET clan='%d' WHERE acc_id='%d' AND pj_id='%d';", g_ClanId[iUser], g_AccountId[id], g_AccountPJs[id][g_UserSelected[id]]);
						if(!SQL_Execute(sqlQuery)) {
							executeQuery(id, sqlQuery, 3000);
						} else {
							SQL_FreeHandle(sqlQuery);
							
							new i;
							
							g_InClan[id] = g_InClan[iUser];
							g_ClanId[id] = g_ClanId[iUser];
							
							++g_ClanOnline[g_InClan[id]];
							
							for(i = 0; i < 16; ++i) {
								if(g_ClanMemberInfo[g_InClan[id]][i][memberId]) {
									continue;
								}
								
								g_ClanInPos[id] = i;
								
								break;
							}
							
							++g_ClanMembers[g_InClan[id]];
							
							copy(g_ClanMemberName[g_InClan[id]][g_ClanInPos[id]], 31, g_UserName[id]);
							
							g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberId] = g_AccountId[id];
							g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberPj] = g_AccountPJs[id][g_UserSelected[id]];
							g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberRange] = 1;
							g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberRank] = g_Rank[id];
							g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberReset] = g_Reset[id];
							g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberLevel] = g_Level[id];
							g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberTulio] = 0;
							g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberLastTimeD] = 0;
							g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberLastTimeH] = 0;
							g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberLastTimeM] = 0;
							g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberSinceD] = 0;
							g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberSinceH] = 0;
							g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberSinceM] = 0;
							
							formatex(g_ClanMemberInfo[g_InClan[id]][g_ClanInPos[id]][memberTimePlayed], 31, "Nada");
							
							--g_ClanInvitations[iUser];
							g_ClanInvitations[id] = 0;
							
							g_ClanInvitationsId[id][iUser] = 0;
							
							for(i = 0; i <= g_MaxUsers; ++i) {
								if(g_ClanId[id] == g_ClanId[i]) {
									colorChat(i, CT, "%s!t%s!y se unió al clan!", ZP_PREFIX, g_UserName[id]);
								}
							}
							
							showMenu__Clan(id);
						}
					}
				} else {
					colorChat(id, _, "%sLa invitación al clan ha expirado!", ZP_PREFIX);
					
					--g_ClanInvitations[id];
					g_ClanInvitationsId[id][iUser] = 0;
				}
			} else {
				colorChat(id, _, "%sEl clan está lleno!", ZP_PREFIX);
				
				--g_ClanInvitations[id];
				g_ClanInvitationsId[id][iUser] = 0;
			}
		} else {
			colorChat(id, _, "%sEl usuario no está en un clan!", ZP_PREFIX);
			
			--g_ClanInvitations[id];
			g_ClanInvitationsId[id][iUser] = 0;
		}
	} else {
		colorChat(id, _, "%sEl usuario seleccionado se ha desconectado!", ZP_PREFIX);
		
		--g_ClanInvitations[id];
		g_ClanInvitationsId[id][iUser] = 0;
	}
	
	DestroyLocalMenu(id, menuid);
	
	if(g_ClanInvitations[id] && !g_ClanId[id]) {
		showMenu__ClanInvitations(id);
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__ClanInfo(const id) {
	static sMenu[400];
	formatex(sMenu, charsmax(sMenu), "\y%s^n^n\wCreado el\r:\y %s^n\wVictorias\r:\y %d^n\wVictorias consecutivas\r:\y %d^n\wVictorias consecutivas en la historia\r:\y %d^n^n\w\r0.\w Volver", g_ClanName[g_InClan[id]], g_ClanInfoCreateDate[g_InClan[id]],
	g_ClanInfo[g_InClan[id]][clanVictory], g_ClanInfo[g_InClan[id]][clanVictoryConsec], g_ClanInfo[g_InClan[id]][clanVictoryConsecHistory]);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "3 Clan Menu");
}

public menu__ClanInfo(const id, key) {
	switch(key) {
		case 9: {
			showMenu__Clan(id);
		}
		default: {
			showMenu__ClanInfo(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

public menu__BestClans(const id) {
	colorChat(id, _, "%sEn construcción!", ZP_PREFIX);
	showMenu__Clan(id);
	
	return PLUGIN_HANDLED;
}

public showMenu__Achievements_Challen(const id) {
	static sMenu[400];
	formatex(sMenu, charsmax(sMenu), "\yLOGROS Y DESAFÍOS\R^n^n\r1.\w Logros^n\r2.\w Desafíos^n^n\w\r0.\w Volver");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "1 Achievements Menu");
}

public menu__Achievements_Challenge(const id, const key) {
	switch(key) {
		case 0: {
			showMenu__Achievements_Class(id);
		}
		case 1: {
			showMenu__Challenges(id);
		}
		case 9: {
			showMenu__Game(id);
		}
		default: {
			showMenu__Achievements_Challen(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__Achievements_Class(const id) {
	static sPosition[3];
	static iMenuId;
	static i;
	
	iMenuId = menu_create("LOGROS", "menu__Achievements_Class");
	
	for(i = 0; i < achievementsClassIds; ++i) {
		num_to_str((i + 1), sPosition, 2);
		menu_additem(iMenuId, ACHIEVEMENTS_MENU_NAMES[i], sPosition);
	}
	
	menu_setprop(iMenuId, MPROP_BACKNAME, "Atrás");
	menu_setprop(iMenuId, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(iMenuId, MPROP_EXITNAME, "Volver");
	
	g_MenuPage[id][MENU_ACHIEVEMENTS_CCLASS] = min(g_MenuPage[id][MENU_ACHIEVEMENTS_CCLASS], menu_pages(iMenuId) - 1);
	
	ShowLocalMenu(id, iMenuId, g_MenuPage[id][MENU_ACHIEVEMENTS_CCLASS]);
}

public menu__Achievements_Class(const id, const menuid, const item) {
	if(!g_IsConnected[id]) {
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	static iNothing;
	player_menu_info(id, iNothing, iNothing, g_MenuPage[id][MENU_ACHIEVEMENTS_CCLASS]);
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuid);
		
		showMenu__Achievements_Challen(id);
		return PLUGIN_HANDLED;
	}
	
	static sBuffer[3];
	static iDummy;
	
	menu_item_getinfo(menuid, item, iDummy, sBuffer, 2, _, _, iDummy);
	DestroyLocalMenu(id, menuid);
	
	g_MenuPage[id][MENU_ACHIEVEMENTS_CLASS] = str_to_num(sBuffer) - 1;
	
	showMenu__Achievements(id, g_MenuPage[id][MENU_ACHIEVEMENTS_CLASS]);
	
	return PLUGIN_HANDLED;
}

public showMenu__Achievements(const id, const class) {
	static sText[64];
	static sItem[5];
	static iMenuId;
	static i;
	static j;
	static k;
	
	formatex(sText, 63, "Logros %s", ACHIEVEMENTS_MENU_NAMES[class]);
	iMenuId = menu_create(sText, "menu__Achievements");
	
	j = 0;
	k = -1;
	
	sItem = {0, 0, 0, 0, 0};
	
	for(i = 0; i < achievementsIds; ++i) {
		++k;
		
		if(class != __ACHIEVEMENTS[i][achievementClass]) {
			continue;
		}
		
		while(k > 127) { // Todo este pequeño código es porque sItem[0] no almacena más de 127 en el handler...
			sItem[j] = 127;
			++j;
			
			k -= 127;
		}
		
		sItem[j] = k;
		sItem[4] = 0;
		
		formatex(sText, 63, "%s%s", (!g_Achievement[id][i]) ? "\d" : "\w", __ACHIEVEMENTS[i][achievementName]);
		menu_additem(iMenuId, sText, sItem);
	}
	
	menu_setprop(iMenuId, MPROP_BACKNAME, "Atrás");
	menu_setprop(iMenuId, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(iMenuId, MPROP_EXITNAME, "Volver");
	
	g_MenuPage_Special[id][class] = min(g_MenuPage_Special[id][class], menu_pages(iMenuId) - 1);
	
	ShowLocalMenu(id, iMenuId, g_MenuPage_Special[id][class]);
}

public menu__Achievements(const id, const menuid, const item) {
	if(!g_IsConnected[id]) {
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	static iNothing;
	player_menu_info(id, iNothing, iNothing, g_MenuPage_Special[id][g_MenuPage[id][MENU_ACHIEVEMENTS_CLASS]]);
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuid);
		
		showMenu__Achievements_Class(id);
		return PLUGIN_HANDLED;
	}
	
	static sItem[5];
	menu_item_getinfo(menuid, item, iNothing, sItem, 4, _, _, iNothing);
	
	g_AchievementsIn[id] = sItem[0] + sItem[1] + sItem[2] + sItem[3];
	
	DestroyLocalMenu(id, menuid);
	
	showMenu__Achievement_Desc(id, g_AchievementsIn[id]);
	return PLUGIN_HANDLED;
}

public showMenu__Achievement_Desc(const id, const achievement_id) {
	static sMenu[350];
	static sAchievementReq[52];
	static sAchievementUnlock[100];
	
	sAchievementUnlock[0] = EOS;
	
	if(g_Achievement[id][achievement_id]) {
		formatex(sAchievementUnlock, charsmax(sAchievementUnlock), "^n^n\wLogro conseguido el ^n\r%s", g_AchievementUnlocked[id][achievement_id]);
	}
	
	if(__ACHIEVEMENTS[achievement_id][achievementUsersNeed]) {
		formatex(sAchievementReq, charsmax(sAchievementReq), "\rRequisitos extras:\w %d usuarios conectados^n", __ACHIEVEMENTS[achievement_id][achievementUsersNeed]);
	}
	
	formatex(sMenu, charsmax(sMenu), "\y%s %s^n^n\yDescripción\r:^n\w%s^n%s^n\yRecompensa\r:^n    \y+\w %d\y Uut^n    \y+\w x%0.4f\y APs%s^n^n\r1.\%s Mostrar en el chat^n^n\r0.\w Volver", __ACHIEVEMENTS[achievement_id][achievementName],
	(!g_Achievement[id][achievement_id]) ? "\r(BLOQUEADO)" : "\y(DESBLOQUEADO)", __ACHIEVEMENTS[achievement_id][achievementDesc], (!__ACHIEVEMENTS[achievement_id][achievementUsersNeed]) ? "" : sAchievementReq,
	__ACHIEVEMENTS[achievement_id][achievementUut], __ACHIEVEMENTS[achievement_id][achievementMult], sAchievementUnlock, (!g_Achievement[id][achievement_id]) ? "d" : "w");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "2 Achievements Menu");
}

public menu__Achievement_Desc(const id, const key) {
	switch(key) {
		case 0: {
			if(g_Achievement[id][g_AchievementsIn[id]]) {
				if(g_SysTime_Link[id] < get_gametime() || g_Kiske[id]) {
					g_SysTime_Link[id] = get_gametime() + 30.0;
					
					colorChat(0, CT, "%s!t%s!y muestra su logro !g%s !t[G]!y, conseguido el !g%s!y", ZP_PREFIX, g_UserName[id], __ACHIEVEMENTS[g_AchievementsIn[id]][achievementName],
					g_AchievementUnlocked[id][g_AchievementsIn[id]]);
					
					g_Link_AchievementId = g_AchievementsIn[id];
				}
			}
			
			showMenu__Achievement_Desc(id, g_AchievementsIn[id]);
		} case 9: {
			showMenu__Achievements(id, g_MenuPage[id][MENU_ACHIEVEMENTS_CLASS]);
		} default: {
			showMenu__Achievement_Desc(id, g_AchievementsIn[id]);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__Challenges(const id) {
	static sText[64];
	static sItem[2];
	static iMenuId;
	static i;
	
	iMenuId = menu_create("DESAFÍOS", "menu__Challenges");
	
	for(i = 0; i < challengesIds; ++i) {
		sItem[0] = i;
		sItem[1] = 0;
		
		formatex(sText, 63, "%s \y[LV %d]", __CHALLENGES[i][challengeName], g_Challenge[id][i]);
		menu_additem(iMenuId, sText, sItem);
	}
	
	menu_setprop(iMenuId, MPROP_BACKNAME, "Atrás");
	menu_setprop(iMenuId, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(iMenuId, MPROP_EXITNAME, "Volver");
	
	g_MenuPage[id][MENU_CHALLENGES] = min(g_MenuPage[id][MENU_CHALLENGES], menu_pages(iMenuId) - 1);
	
	ShowLocalMenu(id, iMenuId, g_MenuPage[id][MENU_CHALLENGES]);
}

public menu__Challenges(const id, const menuid, const item) {
	if(!g_IsConnected[id]) {
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	static iNothing;
	player_menu_info(id, iNothing, iNothing, g_MenuPage[id][MENU_CHALLENGES]);
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuid);
		
		showMenu__Achievements_Challen(id);
		return PLUGIN_HANDLED;
	}
	
	static sItem[2];
	menu_item_getinfo(menuid, item, iNothing, sItem, 1, _, _, iNothing);
	g_ChallengeIn[id] = sItem[0];
	
	DestroyLocalMenu(id, menuid);
	
	showMenu__Challenge_Desc(id, g_ChallengeIn[id]);
	return PLUGIN_HANDLED;
}

public showMenu__Challenge_Desc(const id, const challenge_id) {
	static sMenu[350];
	static sChallengeReq[52];
	static sChallengeDesc[64];
	static sChallengeCant[5];
	
	if(__CHALLENGES[challenge_id][challengeUsersNeed]) {
		formatex(sChallengeReq, 51, "\rRequisitos extras:\w %d usuarios conectados^n^n", __CHALLENGES[challenge_id][challengeUsersNeed]);
	}
	
	formatex(sChallengeDesc, 63, __CHALLENGES[challenge_id][challengeDesc]);
	formatex(sChallengeCant, 4, "%d", (__CHALLENGES[challenge_id][challengeReq] + (g_Challenge[id][challenge_id] * __CHALLENGES[challenge_id][challengeUp])));
	
	replace(sChallengeDesc, 63, "[I]", sChallengeCant);
	
	formatex(sMenu, charsmax(sMenu), "\y%s^n^n\yDescripción\r:^n\w%s^n^n\yRecompensa\r:^n    \r-\w x%0.3f\y APs^n^n%s\r1.\%s Mostrar en el chat^n^n\r0.\w Volver", __CHALLENGES[challenge_id][challengeName],
	sChallengeDesc, __CHALLENGES[challenge_id][challengeMult], (!__CHALLENGES[challenge_id][challengeUsersNeed]) ? "" : sChallengeReq, (!g_Challenge[id][challenge_id]) ? "d" : "w");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "1 Challenge Menu");
}

public menu__Challenge_Desc(const id, const key) {
	switch(key) {
		case 0: {
			if(g_Challenge[id][g_ChallengeIn[id]]) {
				if(g_SysTime_Link[id] < get_gametime() || g_Kiske[id]) {
					g_SysTime_Link[id] = get_gametime() + 30.0;
					
					colorChat(0, CT, "%s!t%s!y muestra su desafío !g%s !t[LV %d]!y", ZP_PREFIX, g_UserName[id], __CHALLENGES[g_ChallengeIn[id]][achievementName], g_Challenge[id]);
				} else {
					showMenu__Challenge_Desc(id, g_ChallengeIn[id]);
				}
			} else {
				showMenu__Challenge_Desc(id, g_ChallengeIn[id]);
			}
		}
		case 9: {
			showMenu__Challenges(id);
		}
		default: {
			showMenu__Challenge_Desc(id, g_ChallengeIn[id]);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__Stats(const id) {
	static sMenu[500];
	static sInfo[11];
	static iLen;
	
	iLen = 0;
	
	switch(g_MenuPage[id][MENU_STATS]) {
		case 0: {
			addDot(g_Stats[id][STAT_DONE][STAT_INFECTIONS], sInfo, 10);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yESTADÍSTICAS\R1/3^n^n\r1.\w Armas^n\r2.\w Tiempo jugado^n\r3.\w Modos^n\r4.\w Items extras^n^nInfecciones hechas\r:\y %s", sInfo);
			
			addDot(g_Stats[id][STAT_TAKEN][STAT_INFECTIONS], sInfo, 10);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wInfecciones recibidas\r:\y %s", sInfo);
			
			addDot(g_Stats[id][STAT_DONE][STAT_ZOMBIES], sInfo, 10);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wZombies matados\r:\y %s", sInfo);
			
			addDot(g_Stats[id][STAT_TAKEN][STAT_ZOMBIES], sInfo, 10);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wVeces muerto siendo zombie\r:\y %s^n^n\r9.\w Siguiente/Atrás^n\r0.\w Volver", sInfo);
		}
		case 1: {
			addDot(g_Stats[id][STAT_DONE][STAT_HUMANS], sInfo, 10);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yESTADÍSTICAS\R2/3^n^n\wHumanos matados\r:\y %s", sInfo);
			
			addDot(g_Stats[id][STAT_TAKEN][STAT_HUMANS], sInfo, 10);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wVeces muerto siendo humano\r:\y %s", sInfo);
			
			addDot(g_Stats[id][STAT_DONE][STAT_HEADSHOTS], sInfo, 10);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wDisparos en la cabeza hechos\r:\y %s", sInfo);
			
			addDot(g_Stats[id][STAT_TAKEN][STAT_HEADSHOTS], sInfo, 10);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wDisparos en la cabeza recibidos\r:\y %s", sInfo);
			
			addDot(g_Stats[id][STAT_DONE][STAT_ZOMBIES_HEADSHOTS], sInfo, 10);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wZombies matados con disparos en la cabeza\r:\y %s", sInfo);
			
			addDot(g_Stats[id][STAT_TAKEN][STAT_ZOMBIES_HEADSHOTS], sInfo, 10);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wVeces muerto con disparos en la cabeza\r:\y %s", sInfo);
			
			addDot(g_Stats[id][STAT_DONE][STAT_ZOMBIES_KNIFE], sInfo, 10);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wZombies matados con cuchillo\r:\y %s", sInfo);
			
			addDot(g_Stats[id][STAT_TAKEN][STAT_ZOMBIES_KNIFE], sInfo, 10);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wVeces muerto con cuchillo\r:\y %s^n^n\r9.\w Siguiente/Atrás^n\r0.\w Volver", sInfo);
		}
		case 2: {
			static sDamage[64];
			static sOutputDamage[64];
			
			addDot(g_Stats[id][STAT_DONE][STAT_COMBO], sInfo, 10);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yESTADÍSTICAS\R3/3^n^n\wCombos hechos\r:\y %s", sInfo);
			
			addDot(g_Stats[id][STAT_DONE][STAT_COMBO_MAX], sInfo, 10);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wMayor combo\r:\y %s", sInfo);
			
			addDot(g_Stats[id][STAT_DONE][STAT_ARMOR], sInfo, 10);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wChaleco desgarrado hecho\r:\y %s", sInfo);
			
			addDot(g_Stats[id][STAT_TAKEN][STAT_ARMOR], sInfo, 10);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wChaleco desgarrado recibido\r:\y %s", sInfo);
			
			formatex(sDamage, 63, "%0.0f", (g_Stats_Damage[id][0] * DIV_DAMAGE));
			addDot__Special(sDamage, sOutputDamage, 63);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wDaño hecho\r:\y %s", sOutputDamage);
			
			formatex(sDamage, 63, "%0.0f", (g_Stats_Damage[id][1] * DIV_DAMAGE));
			addDot__Special(sDamage, sOutputDamage, 63);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wDaño recibido\r:\y %s^n^n\r9.\w Siguiente/Atrás^n\r0.\w Volver", sOutputDamage);
		}
	}
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "1 Stats Menu");
}

public menu__Stats(const id, const key) {
	switch(key) {
		case 0: {
			showMenu__Stats_Weapons(id, .weapon_id=0, .weapon_data_id=0);
		}
		case 1: {
			showMenu__Stats_Time(id);
		}
		case 2: {
			showMenu__Stats_Modes(id);
		}
		case 3: {
			showMenu__Stats_ItemsExtras(id);
		}
		case 8: {
			++g_MenuPage[id][MENU_STATS];
			
			if(g_MenuPage[id][MENU_STATS] == 3) {
				g_MenuPage[id][MENU_STATS] = 0;
			}
			
			showMenu__Stats(id);
		}
		case 9: {
			showMenu__Game(id);
		}
		default: {
			showMenu__Stats(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__Stats_Modes(const id) {
	static sMenu[500];
	static iLen;
	
	iLen = 0;
	
	switch(g_MenuPage[id][MENU_STATS_MODES]) {
		case 0: {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yESTADÍSTICAS DE MODOS\R1/3^n\yG = Ganadas \w|\r P = Perdidas^n");
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wFuiste primer zombie\y %d\w veces^n", g_Stats[id][STAT_DONE][STAT_FIRST_ZOMBIE_COUNT]);
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wFuiste nemesis\y %d\w veces [\yG: %d \w|\r P: %d\w]", g_Stats[id][STAT_DONE][STAT_NEMESIS_COUNT], (g_Stats[id][STAT_DONE][STAT_NEMESIS_COUNT] - g_Stats[id][STAT_TAKEN][STAT_NEMESIS]), g_Stats[id][STAT_TAKEN][STAT_NEMESIS]);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wNemesis matados\r:\y %d^n", g_Stats[id][STAT_DONE][STAT_NEMESIS]);
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wFuiste survivor\y %d\w veces [\yG: %d \w|\r P: %d\w]", g_Stats[id][STAT_DONE][STAT_SURVIVOR_COUNT], (g_Stats[id][STAT_DONE][STAT_SURVIVOR_COUNT] - g_Stats[id][STAT_TAKEN][STAT_SURVIVOR]), g_Stats[id][STAT_TAKEN][STAT_SURVIVOR]);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wSurvivor matados\r:\y %d^n", g_Stats[id][STAT_DONE][STAT_SURVIVOR]);
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wFuiste wesker\y %d\w veces [\yG: %d \w|\r P: %d\w]", g_Stats[id][STAT_DONE][STAT_WESKER_COUNT], (g_Stats[id][STAT_DONE][STAT_WESKER_COUNT] - g_Stats[id][STAT_TAKEN][STAT_WESKER]), g_Stats[id][STAT_TAKEN][STAT_WESKER]);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wWesker matados\r:\y %d", g_Stats[id][STAT_DONE][STAT_WESKER]);
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n^n\r9.\w Siguiente/Atrás^n\r0.\w Volver");
		} case 1: {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yESTADÍSTICAS DE MODOS\R2/3^n\yG = Ganadas \d|\r P = Perdidas^n");
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wFuiste jason\y %d\w veces [\yG: %d \w|\r P: %d\w]", g_Stats[id][STAT_DONE][STAT_JASON_COUNT], (g_Stats[id][STAT_DONE][STAT_JASON_COUNT] - g_Stats[id][STAT_TAKEN][STAT_JASON]), g_Stats[id][STAT_TAKEN][STAT_JASON]);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wJason matados\r:\y %d^n", g_Stats[id][STAT_DONE][STAT_JASON]);
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wFuiste troll\y %d\w veces [\yG: %d \w|\r P: %d\w]", g_Stats[id][STAT_DONE][STAT_TROLL_COUNT], (g_Stats[id][STAT_DONE][STAT_TROLL_COUNT] - g_Stats[id][STAT_TAKEN][STAT_TROLL]), g_Stats[id][STAT_TAKEN][STAT_TROLL]);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wTroll matados\r:\y %d^n", g_Stats[id][STAT_DONE][STAT_TROLL]);
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wFuiste mega nemesis\y %d\w veces [\yG: %d \w|\r P: %d\w]", g_Stats[id][STAT_DONE][STAT_MEGA_NEMESIS_COUNT], (g_Stats[id][STAT_DONE][STAT_MEGA_NEMESIS_COUNT] - g_Stats[id][STAT_TAKEN][STAT_MEGA_NEMESIS]), g_Stats[id][STAT_TAKEN][STAT_MEGA_NEMESIS]);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wMega Nemesis matados\r:\y %d^n", g_Stats[id][STAT_DONE][STAT_MEGA_NEMESIS]);
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n^n\r9.\w Siguiente/Atrás^n\r0.\w Volver");
		} case 2: {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yESTADÍSTICAS DE MODOS\R3/3^n\yG = Ganadas \d|\r P = Perdidas^n");
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wFuiste assassin\y %d\w veces [\yG: %d \w|\r P: %d\w]", g_Stats[id][STAT_DONE][STAT_ASSASSIN_COUNT], (g_Stats[id][STAT_DONE][STAT_ASSASSIN_COUNT] - g_Stats[id][STAT_TAKEN][STAT_ASSASSIN]), g_Stats[id][STAT_TAKEN][STAT_ASSASSIN]);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wAssassin matados\r:\y %d^n", g_Stats[id][STAT_DONE][STAT_ASSASSIN]);
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wFuiste alien\y %d\w veces [\yG: %d \w|\r P: %d\w]", g_Stats[id][STAT_DONE][STAT_ALIEN_COUNT], (g_Stats[id][STAT_DONE][STAT_ALIEN_COUNT] - g_Stats[id][STAT_TAKEN][STAT_ALIEN]), g_Stats[id][STAT_TAKEN][STAT_ALIEN]);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wAlien matados\r:\y %d^n", g_Stats[id][STAT_DONE][STAT_ALIEN]);
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wFuiste depredador\y %d\w veces [\yG: %d \w|\r P: %d\w]", g_Stats[id][STAT_DONE][STAT_PREDATOR_COUNT], (g_Stats[id][STAT_DONE][STAT_PREDATOR_COUNT] - g_Stats[id][STAT_TAKEN][STAT_PREDATOR]), g_Stats[id][STAT_TAKEN][STAT_PREDATOR]);
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\wDepredadores matados\r:\y %d^n", g_Stats[id][STAT_DONE][STAT_PREDATOR]);
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n^n\r9.\w Siguiente/Atrás^n\r0.\w Volver");
		}
	}
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "4 Stats Menu");
}

public menu__Stats_Modes(const id, const key) {
	switch(key) {
		case 8: {
			++g_MenuPage[id][MENU_STATS_MODES];
			
			if(g_MenuPage[id][MENU_STATS_MODES] == 3) {
				g_MenuPage[id][MENU_STATS_MODES] = 0;
			}
			
			showMenu__Stats_Modes(id);
		}
		case 9: {
			showMenu__Stats(id);
		}
		default: {
			showMenu__Stats_Modes(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__Stats_ItemsExtras(const id) {
	static sMenu[500];
	static iLen;
	static i;
	
	iLen = 0;
	
	switch(g_MenuPage[id][MENU_STATS_ITEMS_EXTRAS]) {
		case 0: {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yESTADÍSTICAS DE ITEMS EXTRAS\R1/2^nAcá podés ver la cantidad de items extras que compraste!^n");
			
			for(i = 0; i < 8; ++i) {
				iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\w%s\r:\y %d", ITEMS_EXTRAS[i][extraName], g_ItemExtra_Count[id][i]);
			}
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n^n\r9.\w Siguiente/Atrás^n\r0.\w Volver");
		}
		case 1: {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yESTADÍSTICAS DE ITEMS EXTRAS\R2/2^nAcá podés ver la cantidad de items extras que compraste!^n");
			
			for(i = 8; i < extraItemsId; ++i) {
				iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\w%s\r:\y %d", ITEMS_EXTRAS[i][extraName], g_ItemExtra_Count[id][i]);
			}
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n^n\r9.\w Siguiente/Atrás^n\r0.\w Volver");
		}
	}
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "5 Stats Menu");
}

public menu__Stats_ItemsExtras(const id, const key) {
	switch(key) {
		case 8: {
			++g_MenuPage[id][MENU_STATS_ITEMS_EXTRAS];
			
			if(g_MenuPage[id][MENU_STATS_ITEMS_EXTRAS] == 2) {
				g_MenuPage[id][MENU_STATS_ITEMS_EXTRAS] = 0;
			}
			
			showMenu__Stats_ItemsExtras(id);
		}
		case 9: {
			showMenu__Stats(id);
		}
		default: {
			showMenu__Stats_ItemsExtras(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__Stats_Weapons(const id, const weapon_id, const weapon_data_id) {
	if(!weapon_id) {
		static sMenu[64];
		static sItem[3];
		static iMenuId;
		static i;
		
		iMenuId = menu_create("ESTADÍSTICAS DE TUS ARMAS\R", "menu__Stats_Weapons");
		
		for(i = 0; i < 21; ++i) {
			sItem[0] = WEAPON_DATA[i][weaponDataId];
			sItem[1] = i;
			sItem[2] = 0;
			
			formatex(sMenu, charsmax(sMenu), "%s \y[Niv. %d]", WEAPON_DATA[i][weaponDataName], g_WeaponData[id][sItem[0]][weaponLevel]);
			
			menu_additem(iMenuId, sMenu, sItem);
		}
		
		menu_setprop(iMenuId, MPROP_BACKNAME, "Atrás");
		menu_setprop(iMenuId, MPROP_NEXTNAME, "Siguiente");
		menu_setprop(iMenuId, MPROP_EXITNAME, "Volver");
		
		if(pev_valid(id) == PDATA_SAFE) {
			set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
		}
		
		g_MenuPage[id][MENU_WEAPON_STATS] = min(g_MenuPage[id][MENU_WEAPON_STATS], menu_pages(iMenuId) - 1);
		
		ShowLocalMenu(id, iMenuId, g_MenuPage[id][MENU_WEAPON_STATS]);
	} else {
		static sMenu[600];
		static sDamage[32];
		static sOutputDamage[32];
		static sDamageReq[32];
		static sOutputDamageReq[32];
		static sTime[32];
		static Float:flLevelPercent;
		
		formatex(sDamage, 31, "%0.0f", (g_WeaponData[id][weapon_id][weaponDamage] * 100.0));
		addDot__Special(sDamage, sOutputDamage, 31);
		
		formatex(sDamageReq, 31, "%0.0f", ((g_WEAPONS_Damage_Needed[weapon_id][g_WeaponData[id][weapon_id][weaponLevel]] - g_WeaponData[id][weapon_id][weaponDamage]) * 100.0));
		addDot__Special(sDamageReq, sOutputDamageReq, 31);
		
		if(g_WeaponData[id][weapon_id][weaponTimeDays]) {
			formatex(sTime, 31, "%d día%s, %d hora%s", g_WeaponData[id][weapon_id][weaponTimeDays], (g_WeaponData[id][weapon_id][weaponTimeDays] != 1) ? "s" : "",
			g_WeaponData[id][weapon_id][weaponTimeHours], (g_WeaponData[id][weapon_id][weaponTimeHours] != 1) ? "s" : "");
		} else if(g_WeaponData[id][weapon_id][weaponTimeHours]) {
			formatex(sTime, 31, "%d hora%s, %d minuto%s", g_WeaponData[id][weapon_id][weaponTimeHours], (g_WeaponData[id][weapon_id][weaponTimeHours] != 1) ? "s" : "",
			g_WeaponData[id][weapon_id][weaponTimeMinutes], (g_WeaponData[id][weapon_id][weaponTimeMinutes] != 1) ? "s" : "");
		} else {
			formatex(sTime, 31, "%d minuto%s", g_WeaponData[id][weapon_id][weaponTimeMinutes], (g_WeaponData[id][weapon_id][weaponTimeMinutes] != 1) ? "s" : "");
		}
		
		flLevelPercent = (((g_WeaponData[id][weapon_id][weaponDamage] - ((g_WeaponData[id][weapon_id][weaponLevel]) ? g_WEAPONS_Damage_Needed[weapon_id][g_WeaponData[id][weapon_id][weaponLevel] - 1] : 0.0)) * 100.0) /
		(g_WEAPONS_Damage_Needed[weapon_id][g_WeaponData[id][weapon_id][weaponLevel]] - ((g_WeaponData[id][weapon_id][weaponLevel]) ? g_WEAPONS_Damage_Needed[weapon_id][g_WeaponData[id][weapon_id][weaponLevel] - 1] : 0.0)));
		
		if(weapon_id != CSW_KNIFE) {
			formatex(sMenu, charsmax(sMenu), "\y%s^n\wPuntos disponibles\r: \y%d^n^n\wNivel del arma\r: \y%d (%0.2f%%)^n\wTiempo jugado con esta arma\r: \y%s^n\wMatados con esta arma\r: \y%d^n\wDaño hecho con esta arma\r: \y%s^n^n\wDaño restante\r: \y%s^n^n\
			\r1.\w DAÑO \y[Niv. %d]^n\r2.\w VELOCIDAD \y[Niv. %d]^n\r3.\w PRECISIÓN \y[Niv. %d]^n\r4.\w BALAS \y[Niv. %d]^n^n\r6.\w Reiniciar puntos^n^n\r0.\w Volver",
			WEAPON_DATA[weapon_data_id][weaponDataName], g_WeaponSkill[id][weapon_id][SKILL_POINTS], g_WeaponData[id][weapon_id][weaponLevel],
			flLevelPercent, sTime, g_WeaponData[id][weapon_id][weaponKills], sOutputDamage,
			sOutputDamageReq, g_WeaponSkill[id][weapon_id][SKILL_DAMAGE], g_WeaponSkill[id][weapon_id][SKILL_SPEED], g_WeaponSkill[id][weapon_id][SKILL_RECOIL],
			g_WeaponSkill[id][weapon_id][SKILL_MAXCLIP]);
		} else {
			formatex(sMenu, charsmax(sMenu), "\y%s^n\wPuntos disponibles\r: \y%d^n^n\wNivel del arma\r: \y%d (%0.2f%%)^n\wTiempo jugado con esta arma\r: \y%s^n\wMatados con esta arma\r: \y%d^n\wDaño hecho con esta arma\r: \y%s^n^n\wDaño restante\r: \y%s^n^n\
			\r1.\w DAÑO \y[Niv. %d]^n\r2.\w VELOCIDAD \y[Niv. %d]^n^n\r6.\w Reiniciar puntos^n^n\r0.\w Volver",
			WEAPON_DATA[weapon_data_id][weaponDataName], g_WeaponSkill[id][weapon_id][SKILL_POINTS], g_WeaponData[id][weapon_id][weaponLevel],
			flLevelPercent, sTime, g_WeaponData[id][weapon_id][weaponKills], sOutputDamage,
			sOutputDamageReq, g_WeaponSkill[id][weapon_id][SKILL_DAMAGE], g_WeaponSkill[id][weapon_id][SKILL_SPEED]);
		}
		
		g_MenuPage[id][MENU_WEAPON_STATS_IN] = weapon_id;
		g_MenuPage[id][MENU_WEAPON_STATS_ID] = weapon_data_id;
		
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
		show_menu(id, KEYSMENU, sMenu, -1, "3 Stats Menu");
	}
}

public menu__Stats_Weapons(const id, const menuid, const item) {
	if(!g_IsConnected[id]) {
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	static iNothing;
	player_menu_info(id, iNothing, iNothing, g_MenuPage[id][MENU_WEAPON_STATS]);
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuid);
		
		showMenu__Stats(id);
		return PLUGIN_HANDLED;
	}
	
	static sItem[3];
	menu_item_getinfo(menuid, item, iNothing, sItem, charsmax(sItem), _, _, iNothing);
	
	DestroyLocalMenu(id, menuid);
	
	showMenu__Stats_Weapons(id, .weapon_id=sItem[0], .weapon_data_id=sItem[1]);
	return PLUGIN_HANDLED;
}

public menu__Stats_WeaponIn(const id, const key) {
	switch(key) {
		case 0..3: {
			if(g_WeaponSkill[id][g_MenuPage[id][MENU_WEAPON_STATS_IN]][SKILL_POINTS]) {
				if(g_MenuPage[id][MENU_WEAPON_STATS_IN] == CSW_KNIFE && (key == SKILL_RECOIL || key == SKILL_MAXCLIP)) {
					showMenu__Stats_Weapons(id, .weapon_id=g_MenuPage[id][MENU_WEAPON_STATS_IN], .weapon_data_id=g_MenuPage[id][MENU_WEAPON_STATS_ID]);
					return PLUGIN_HANDLED;
				}
				
				if((key == SKILL_SPEED && g_WeaponSkill[id][g_MenuPage[id][MENU_WEAPON_STATS_IN]][SKILL_SPEED] < 5) || g_WeaponSkill[id][g_MenuPage[id][MENU_WEAPON_STATS_IN]][key+1] < 10) {
					--g_WeaponSkill[id][g_MenuPage[id][MENU_WEAPON_STATS_IN]][SKILL_POINTS];
					++g_WeaponSkill[id][g_MenuPage[id][MENU_WEAPON_STATS_IN]][key+1];
				}
			}
		} case 5: {
			new iReturn;
			iReturn =
			g_WeaponSkill[id][g_MenuPage[id][MENU_WEAPON_STATS_IN]][SKILL_DAMAGE] +
			g_WeaponSkill[id][g_MenuPage[id][MENU_WEAPON_STATS_IN]][SKILL_RECOIL] +
			g_WeaponSkill[id][g_MenuPage[id][MENU_WEAPON_STATS_IN]][SKILL_SPEED] +
			g_WeaponSkill[id][g_MenuPage[id][MENU_WEAPON_STATS_IN]][SKILL_MAXCLIP];
			
			if(iReturn) {
				g_WeaponSkill[id][g_MenuPage[id][MENU_WEAPON_STATS_IN]][SKILL_DAMAGE] = 0;
				g_WeaponSkill[id][g_MenuPage[id][MENU_WEAPON_STATS_IN]][SKILL_RECOIL] = 0;
				g_WeaponSkill[id][g_MenuPage[id][MENU_WEAPON_STATS_IN]][SKILL_SPEED] = 0;
				g_WeaponSkill[id][g_MenuPage[id][MENU_WEAPON_STATS_IN]][SKILL_MAXCLIP] = 0;
				
				g_WeaponSkill[id][g_MenuPage[id][MENU_WEAPON_STATS_IN]][SKILL_POINTS] += iReturn;
			}
		} case 9: {
			showMenu__Stats_Weapons(id, .weapon_id=0, .weapon_data_id=0);
			return PLUGIN_HANDLED;
		}
	}
	
	showMenu__Stats_Weapons(id, .weapon_id=g_MenuPage[id][MENU_WEAPON_STATS_IN], .weapon_data_id=g_MenuPage[id][MENU_WEAPON_STATS_ID]);
	
	return PLUGIN_HANDLED;
}

public showMenu__Stats_Time(const id) {
	static sMenu[400];
	
	formatex(sMenu, charsmax(sMenu), "\yTIEMPO^n^n\wUsuario desde \y%s^n^n\wJugaste \y%d día%s y \y%d hora%s^n\wTiempo jugado por día\r: \y~%0.2f horas^n^n\wVisitas diarias\r: \y%d^n\wBonus de APs por visitas diarias\r: \yx%0.2f^n^n\r0.\w Volver",
	g_RegisterSince[id], g_PlayedTime[id][TIME_DAY], (g_PlayedTime[id][TIME_DAY] != 1) ? "s" : "", g_PlayedTime[id][TIME_HOUR], (g_PlayedTime[id][TIME_HOUR] != 1) ? "s" : "", g_PlayedTime_PerDay[id], g_VisitDays[id], g_BonusDays[id]);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "2 Stats Menu");
}

public menu__Stats_Time(const id, const key) {
	switch(key) {
		case 9: {
			showMenu__Stats(id);
		}
		default: {
			showMenu__Stats_Time(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__Hats(const id) {
	static sMenu[450];
	static iStartLoop;
	static iEndLoop;
	static iLen;
	static i;
	static j;
	
	iLen = 0;
	iStartLoop = (g_MenuPage[id][MENU_HATS] * 8);
	iEndLoop = clamp(((g_MenuPage[id][MENU_HATS] + 1) * 8), 0, sizeof(__HATS));
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yELEGIR GORRO \r[%d - %d]^n^n", (iStartLoop + 1), iEndLoop);
	
	for(i = iStartLoop; i < iEndLoop; ++i) {
		j = (i + 1 - (g_MenuPage[id][MENU_HATS] * 8));
		
		if(g_HatId[id] == i) {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\w %s \y(EQUIPADO)^n", j, __HATS[i][hatName]);
		} else if(g_HatNext[id] == i && i) {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\w %s \y(ELEGIDO)^n", j, __HATS[i][hatName]);
		} else if(g_Hat[id][i]) {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\w %s^n", j, __HATS[i][hatName]);
		} else {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.\d %s^n", j, __HATS[i][hatName]);
		}
	}
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\r9.\w Siguiente/Atrás^n\r0. \wVolver");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "1 Hats Menu");
}

public menu__Hats_Info(const id, const key) {
	new iSelection;
	iSelection = (g_MenuPage[id][MENU_HATS] * 8) + key;
	
	if(key >= 8 || iSelection >= sizeof(__HATS)) {
		switch(key) {
			case 8: {
				if(((g_MenuPage[id][MENU_HATS] + 1) * 8) < sizeof(__HATS)) {
					++g_MenuPage[id][MENU_HATS];
				} else {
					g_MenuPage[id][MENU_HATS] = 0;
				}
			}
			case 9: {
				showMenu__Game(id);
				return PLUGIN_HANDLED;
			}
		}
		
		showMenu__Hats(id);
		return PLUGIN_HANDLED;
	}
	
	if(!iSelection) {
		g_HatNext[id] = HAT_NONE;
		
		if(g_HatId[id]) {
			colorChat(id, _, "%sTu gorro ha sido removido!", ZP_PREFIX);
			
			if(is_valid_ent(g_HatEnt[id])) {
				remove_entity(g_HatEnt[id]);
			}
			
			g_ExtraMultAps[id] -= __HATS[g_HatId[id]][hatUpgrade5];
			
			updateComboNeeded(id);
			
			g_HatId[id] = HAT_NONE;
		}
		
		showMenu__Hats(id);
		return PLUGIN_HANDLED;
	}
	
	g_MenuPage[id][MENU_SELECT_HATS] = iSelection;
	
	showMenu__Hats_Info(id, iSelection);
	
	return PLUGIN_HANDLED;
}

public showMenu__Hats_Info(const id, const hatId) {
	static sMenu[500];
	static iLen;
	static i;
	static j;
	
	iLen = 0;
	j = 0;
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\y%s %s^n^n\yRequerimientos\r:^n\w%s^n^n\yBeneficios\r:^n", __HATS[hatId][hatName], (g_Hat[id][hatId]) ? "\y(DESBLOQUEADO)" : "\d(BLOQUEADO)", __HATS[hatId][hatReq]);
	
	for(i = 0; i < 8; ++i) {
		if(!i) {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^t^t^t^t");
		}
		
		if(j == 2) {
			j = 0;
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n^t^t^t^t");
		}
		
		if(__HATS[hatId][hatUpgrade1 + i]) {
			if(i != 4) {
				iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\y+\w %d\y%s", __HATS[hatId][hatUpgrade1 + i], __HATS_INFO[i]);
			} else {
				iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\y+\w x%0.2f\y%s", __HATS[hatId][hatUpgrade1 + i], __HATS_INFO[i]);
			}
		} else {
			if(i != 4) {
				iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\d+ 0%s", __HATS_INFO[i]);
			} else {
				iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\d+ x0.00%s", __HATS_INFO[i]);
			}
		}
		
		++j;
	}
	
	iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n^n\r1. %sEquipar gorro^n^n\r0.\w Atrás", (g_Hat[id][hatId]) ? "\w" : "\d");
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "2 Hats Menu");
}

public menu__Hats(const id, const key) {
	switch(key) {
		case 0: {
			if(g_Hat[id][g_MenuPage[id][MENU_SELECT_HATS]]) {
				g_HatNext[id] = g_MenuPage[id][MENU_SELECT_HATS];
				
				if(!g_NewRound) {
					colorChat(id, _, "%sCuando vuelvas a ser humano tendrás el gorro !g%s!y", ZP_PREFIX, __HATS[g_HatNext[id]][hatName]);
				} else {
					setHat(id, g_HatNext[id]);
				}
			}
			
			showMenu__Hats(id);
		}
		case 9: {
			showMenu__Hats(id);
		}
		default: {
			showMenu__Hats_Info(id, g_MenuPage[id][MENU_SELECT_HATS]);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__Duels(const id) {
	colorChat(id, _, "%sNo disponible!", ZP_PREFIX);
	showMenu__Game(id);
}

public showMenu__Options(const id) {
	static sBuffer[50];
	static iMenuId;
	
	iMenuId = menu_create("CONFIGURACIÓN", "menu__Options");
	
	menu_additem(iMenuId, "Configurar HUD general", "1");
	menu_additem(iMenuId, "Configurar HUD combo^n", "2");
	
	menu_additem(iMenuId, "Elegir colores^n", "3");
	
	formatex(sBuffer, 49, "Humanos visibles/invisibles^n");
	menu_additem(iMenuId, sBuffer, "4");
	
	menu_setprop(iMenuId, MPROP_EXITNAME, "Volver");
	
	if(pev_valid(id) == PDATA_SAFE) {
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	}
	
	ShowLocalMenu(id, iMenuId);
}

public menu__Options(const id, const menuid, const item) {
	if(!g_IsConnected[id]) {
		DestroyLocalMenu(id, menuid);
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuid);
		
		showMenu__Game(id);
		return PLUGIN_HANDLED;
	}
	
	static sBuffer[3];
	static iDummy;
	
	menu_item_getinfo(menuid, item, iDummy, sBuffer, charsmax(sBuffer), _, _, iDummy);
	DestroyLocalMenu(id, menuid);
	
	switch(str_to_num(sBuffer)) {
		case 1: {
			showMenu__Options_HUD_General(id);
		}
		case 2: {
			showMenu__Options_HUD_Combo(id);
		}
		case 3: {
			showMenu__Options_Color(id, COLOR_NONE);
		}
		case 4: {
			client_cmd(id, "say /invis"); // Una manera de mierda pero es la única que se me ocurre para que se ejecute el handler del módulo (archivo semiclip.cpp)
			
			showMenu__Options(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

public showMenu__Options_HUD_General(const id) {
	static sBuffer[32];
	static iMenuId;
	
	iMenuId = menu_create("CONFIGURACIÓN \r-\y HUD GENERAL", "menu__Options_HUD_General");
	
	menu_additem(iMenuId, "Elegir color", "1");
	
	formatex(sBuffer, 31, "Efecto del HUD %s^n", (g_Options_HUD_Effect[id][HUD_GENERAL]) ? "\y(Si)" : "\r(No)");
	menu_additem(iMenuId, sBuffer, "2");
	
	formatex(sBuffer, 31, "Abreviar HUD %s^n", (g_Options_HUD_Abrev[id][HUD_GENERAL]) ? "\y(Si)" : "\r(No)");
	menu_additem(iMenuId, sBuffer, "3");
	
	menu_additem(iMenuId, "Mover hacia arriba", "4");
	menu_additem(iMenuId, "Mover hacia abajo", "5");
	menu_additem(iMenuId, "Mover hacia la izquierda", "6", _, menu_makecallback("__checkMoveHUD_General"));
	menu_additem(iMenuId, "Mover hacia la derecha^n", "7", _, menu_makecallback("__checkMoveHUD_General"));
	
	formatex(sBuffer, 31, "%s HUD^n", (g_Options_HUD_Position[id][HUD_GENERAL][2]) ? "Descentrar" : "Centrar");
	menu_additem(iMenuId, sBuffer, "8");
	
	menu_additem(iMenuId, "Reiniciar posición^n", "9");
	
	menu_additem(iMenuId, "Atrás", "0");
	
	menu_setprop(iMenuId, MPROP_PERPAGE, 0);
	
	if(pev_valid(id) == PDATA_SAFE) {
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	}
	
	ShowLocalMenu(id, iMenuId);
}

public __checkMoveHUD_General(const id, const menuid, const item) {
	if(!g_Options_HUD_Position[id][HUD_GENERAL][2]) {
		return ITEM_ENABLED;
	}
	
	return ITEM_DISABLED;
}

public menu__Options_HUD_General(const id, const menuid, const item) {
	static sBuffer[3];
	static iDummy;
	static iItemId;
	
	menu_item_getinfo(menuid, item, iDummy, sBuffer, charsmax(sBuffer), _, _, iDummy);
	DestroyLocalMenu(id, menuid);
	
	iItemId = str_to_num(sBuffer);
	
	switch(iItemId) {
		case 0: {
			showMenu__Options(id);
			return PLUGIN_HANDLED;
		}
		case 1: {
			showMenu__Options_Color(id, COLOR_HUD);
			return PLUGIN_HANDLED;
		}
		case 2: {
			g_Options_HUD_Effect[id][HUD_GENERAL] = !g_Options_HUD_Effect[id][HUD_GENERAL];
		}
		case 3: {
			g_Options_HUD_Abrev[id][HUD_GENERAL] = !g_Options_HUD_Abrev[id][HUD_GENERAL];
		}
		case 4: {
			g_Options_HUD_Position[id][HUD_GENERAL][1] -= 0.01;
		}
		case 5: {
			g_Options_HUD_Position[id][HUD_GENERAL][1] += 0.01;
		}
		case 6: {
			g_Options_HUD_Position[id][HUD_GENERAL][0] -= 0.01;
			g_Options_HUD_Position[id][HUD_GENERAL][2] = 0.0;
		}
		case 7: {
			g_Options_HUD_Position[id][HUD_GENERAL][0] += 0.01;
			g_Options_HUD_Position[id][HUD_GENERAL][2] = 0.0;
		}
		case 8: {
			if(g_Options_HUD_Position[id][HUD_GENERAL][2]) {
				g_Options_HUD_Position[id][HUD_GENERAL][0] = 0.5;
				g_Options_HUD_Position[id][HUD_GENERAL][1] = 0.5;
				g_Options_HUD_Position[id][HUD_GENERAL][2] = 0.0;
			} else {
				g_Options_HUD_Position[id][HUD_GENERAL][0] = -1.0;
				g_Options_HUD_Position[id][HUD_GENERAL][1] = 0.5;
				g_Options_HUD_Position[id][HUD_GENERAL][2] = 1.0;
			}
		}
		case 9: g_Options_HUD_Position[id][HUD_GENERAL] = Float:{0.02, 0.08, 0.0};
	}
	
	showMenu__Options_HUD_General(id);
	
	return PLUGIN_HANDLED;
}

public showMenu__Options_HUD_Combo(const id) {
	static sBuffer[32];
	static iMenuId;
	
	iMenuId = menu_create("CONFIGURACIÓN - HUD COMBO", "menu__Options_HUD_Combo");
	
	formatex(sBuffer, 31, "Efecto del HUD %s^n", (g_Options_HUD_Effect[id][HUD_COMBO]) ? "\y(Si)" : "\r(No)");
	menu_additem(iMenuId, sBuffer, "1");
	
	formatex(sBuffer, 31, "Abreviar HUD %s^n", (g_Options_HUD_Abrev[id][HUD_COMBO]) ? "\y(Si)" : "\r(No)");
	menu_additem(iMenuId, sBuffer, "2");
	
	menu_additem(iMenuId, "Mover hacia arriba", "3");
	menu_additem(iMenuId, "Mover hacia abajo^n", "4");
	
	menu_additem(iMenuId, "Todo por defecto", "5");
	
	menu_setprop(iMenuId, MPROP_EXITNAME, "Volver");
	
	if(pev_valid(id) == PDATA_SAFE) {
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	}
	
	ShowLocalMenu(id, iMenuId);
}

public menu__Options_HUD_Combo(const id, const menuid, const item) {
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuid);
		
		showMenu__Options(id);
		return PLUGIN_HANDLED;
	}
	
	static sBuffer[3];
	static iDummy;
	static iItemId;
	
	menu_item_getinfo(menuid, item, iDummy, sBuffer, charsmax(sBuffer), _, _, iDummy);
	DestroyLocalMenu(id, menuid);
	
	iItemId = str_to_num(sBuffer);
	
	switch(iItemId) {
		case 1: {
			g_Options_HUD_Effect[id][HUD_COMBO] = !g_Options_HUD_Effect[id][HUD_COMBO];
		}
		case 2: {
			g_Options_HUD_Abrev[id][HUD_COMBO] = !g_Options_HUD_Abrev[id][HUD_COMBO];
		}
		case 3: {
			g_Options_HUD_Position[id][HUD_COMBO][1] -= 0.01;
		}
		case 4: {
			g_Options_HUD_Position[id][HUD_COMBO][1] += 0.01;
		}
		case 5: {
			g_Options_HUD_Effect[id][HUD_COMBO] = 0;
			g_Options_HUD_Abrev[id][HUD_COMBO] = 0;
			
			g_Options_HUD_Position[id][HUD_COMBO] = Float:{-1.0, 0.57, 0.0};
		}
	}
	
	if(iItemId >= 1 && iItemId < 6) {
		set_hudmessage(0, 255, 0, -1.0, g_Options_HUD_Position[id][HUD_COMBO][1], g_Options_HUD_Effect[id][HUD_COMBO], 1.0, 5.49, 0.01, 0.01);
		
		if(!g_Options_HUD_Abrev[id][HUD_COMBO]) {
			ShowSyncHudMsg(id, g_Hud_Combo, "¡¡ Ultra Kill !!^nCombo x6.000^nDaño total: 13.975 | Daño: 1.337");
		} else {
			ShowSyncHudMsg(id, g_Hud_Combo, "¡¡ Ultra Kill !!^nx6.000^n13.975 | 1.337");
		}
	}
	
	showMenu__Options_HUD_Combo(id);
	
	return PLUGIN_HANDLED;
}

public showMenu__Options_Color(const id, const colorId) {
	if(colorId == COLOR_NONE) {
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
		show_menu(id, KEYSMENU, "\yCONFIGURACIÓN - COLORES^n^n\r1.\w Visión nocturna^n\r2.\w HUD general^n\r3.\w Luz / Bubble^n\r4.\w Bazooka^n\r5.\w LASER^n^n\r0.\w Volver", -1, "1 Color Menu");
		
		return;
	}
	
	static sMenu[200];
	static iCheck;
	static iLen;
	static i;
	static iOk;
	
	iOk = 1;
	iLen = 0;
	
	g_MenuPage[id][MENU_COLOR] = colorId;
	
	switch(colorId) {	
		case COLOR_NIGHTVISION: {
			formatex(sMenu, charsmax(sMenu), "COLOR - VISIÓN NOCTURNA\R");
		} case COLOR_HUD: {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yCOLOR - HUD GENERAL\R^n^n");
			iOk = 0;
		} case COLOR_FLARE: {
			formatex(sMenu, charsmax(sMenu), "COLOR - LUZ / BUBBLE\R");
		} case COLOR_BAZOOKA: {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yCOLOR - BAZOOKA\R^n^n");
			iOk = 0;
		} case COLOR_LASER: {
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\yCOLOR - LASER\R^n^n");
			iOk = 0;
		}
	}
	
	if(iOk) {
		static iMenu;
		static sItem[48];
		static sPosition[3];
		
		iMenu = menu_create(sMenu, "menu__Options_Color");
		
		for(i = 0; i < sizeof(__COLOR); ++i) {
			iCheck = (g_Options_Color[id][colorId][__R] == __COLOR[i][colorRed] && g_Options_Color[id][colorId][__G] == __COLOR[i][colorGreen] && g_Options_Color[id][colorId][__B] == __COLOR[i][colorBlue]) ? 1 : 0;
			
			formatex(sItem, 47, "%s%s%s", (!iCheck) ? "\w" : "\d", __COLOR[i][colorName], (!iCheck) ? "" : " \y(ACTUAL)");
			
			num_to_str((i + 1), sPosition, 2);
			menu_additem(iMenu, sItem, sPosition);
		}
		
		menu_setprop(iMenu, MPROP_NEXTNAME, "Siguiente");
		menu_setprop(iMenu, MPROP_BACKNAME, "Atrás");
		menu_setprop(iMenu, MPROP_EXITNAME, "Volver");
		
		g_MenuPage[id][MENU_COLOR_ALL] = min(g_MenuPage[id][MENU_COLOR_ALL], menu_pages(iMenu) - 1);
		
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
		ShowLocalMenu(id, iMenu, g_MenuPage[id][MENU_COLOR_ALL]);
	} else {
		for(i = 0; i < 8; ++i) {
			iCheck = (g_Options_Color[id][colorId][__R] == __COLOR[i][colorRed] && g_Options_Color[id][colorId][__G] == __COLOR[i][colorGreen] && g_Options_Color[id][colorId][__B] == __COLOR[i][colorBlue]) ? 1 : 0;
			
			iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "\r%d.%s %s%s^n", (i+1), (!iCheck) ? "\w" : "\d", __COLOR[i][colorName], (!iCheck) ? "" : " \y(ACTUAL)");
		}
		
		iLen += formatex(sMenu[iLen], charsmax(sMenu) - iLen, "^n\r0.\w Volver");
		
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
		show_menu(id, KEYSMENU, sMenu, -1, "2 Color Menu");
	}
}

public menu__Color(const id, const key) {
	if(key >= 5) {
		if(key == 9) {
			showMenu__Options(id);
		} else {
			showMenu__Options_Color(id, g_MenuPage[id][MENU_COLOR]);
		}
		
		return PLUGIN_HANDLED;
	}
	
	showMenu__Options_Color(id, (key + 1));
	
	return PLUGIN_HANDLED;
}

public menu__Options_Color(const id, const menuId, const item) {
	if(!g_IsConnected[id]) {
		DestroyLocalMenu(id, menuId);
		return PLUGIN_HANDLED;
	}
	
	static iMenuDummy;
	player_menu_info(id, iMenuDummy, iMenuDummy, g_MenuPage[id][MENU_COLOR_ALL]);
	
	if(item == MENU_EXIT) {
		DestroyLocalMenu(id, menuId);
		
		if(g_MenuPage[id][MENU_COLOR] != COLOR_HUD) {
			showMenu__Options_Color(id, COLOR_NONE);
		} else {
			showMenu__Options_HUD_General(id);
		}
		
		return PLUGIN_HANDLED;
	}
	
	static sBuffer[3];
	static iNothing;
	static iItem;
	
	menu_item_getinfo(menuId, item, iNothing, sBuffer, charsmax(sBuffer), _, _, iNothing);
	iItem = str_to_num(sBuffer) - 1;
	
	DestroyLocalMenu(id, menuId);
	
	// NIGHTVISION - LUZ/BUBBLE
	
	g_Options_Color[id][g_MenuPage[id][MENU_COLOR]][__R] = __COLOR[iItem][colorRed];
	g_Options_Color[id][g_MenuPage[id][MENU_COLOR]][__G] = __COLOR[iItem][colorGreen];
	g_Options_Color[id][g_MenuPage[id][MENU_COLOR]][__B] = __COLOR[iItem][colorBlue];
	
	if(g_MenuPage[id][MENU_COLOR] == COLOR_NIGHTVISION && g_Nightvision[id]) {
		setNightvision(id, 1);
	}
	
	showMenu__Options_Color(id, g_MenuPage[id][MENU_COLOR]);
	
	return PLUGIN_HANDLED;
}

public menu__Choose_Color(const id, const key) {
	if(key >= 8) {
		if(key == 9) {
			showMenu__Options_Color(id, COLOR_NONE);
		} else {
			showMenu__Options_Color(id, g_MenuPage[id][MENU_COLOR]);
		}
		
		return PLUGIN_HANDLED;
	}
	
	if(g_MenuPage[id][MENU_COLOR] == COLOR_BAZOOKA) { // BAZOOKA
		if(g_Bazooka_InAir) {
			colorChat(id, _, "%sNo podés cambiar el color de tu bazooka mientras está en el aire", ZP_PREFIX);
		} else {
			g_Bazooka_Sprite_Color[id] = key;
			
			g_Options_Color[id][g_MenuPage[id][MENU_COLOR]][__R] = __COLOR[key][colorRed];
			g_Options_Color[id][g_MenuPage[id][MENU_COLOR]][__G] = __COLOR[key][colorGreen];
			g_Options_Color[id][g_MenuPage[id][MENU_COLOR]][__B] = __COLOR[key][colorBlue];
		}
	} else { // HUD - LASER
		g_Options_Color[id][g_MenuPage[id][MENU_COLOR]][__R] = __COLOR[key][colorRed];
		g_Options_Color[id][g_MenuPage[id][MENU_COLOR]][__G] = __COLOR[key][colorGreen];
		g_Options_Color[id][g_MenuPage[id][MENU_COLOR]][__B] = __COLOR[key][colorBlue];
	}
	
	showMenu__Options_Color(id, g_MenuPage[id][MENU_COLOR]);
	
	return PLUGIN_HANDLED;
}

public showMenu__ViewTOPs(const id) {
	
}

public setNightvision(const id, const nvg) { // sn_f
	g_Nightvision[id] = nvg;
	
	if(nvg) {
		g_NightvisionOn[id] = 1;
		
		setLight(id, "i");
		
		message_begin(MSG_ONE, g_Message_ScreenFade, _, id);
		write_short(UNIT_SECOND);
		write_short(0);
		write_short(FFADE_STAYOUT);
		if(g_SpecialMode[id] != MODE_NEMESIS) {
			write_byte(g_Options_Color[id][COLOR_NIGHTVISION][__R]);
			write_byte(g_Options_Color[id][COLOR_NIGHTVISION][__G]);
			write_byte(g_Options_Color[id][COLOR_NIGHTVISION][__B]);
		} else {
			write_byte(255);
			write_byte(0);
			write_byte(0);
		}
		write_byte(75);
		message_end();
	} else {
		g_NightvisionOn[id] = 0;
		
		setLight(id, g_Lights[0]);
		
		message_begin(MSG_ONE, g_Message_ScreenFade, _, id);
		write_short(0);
		write_short(0);
		write_short(FFADE_IN);
		write_byte(0);
		write_byte(0);
		write_byte(0);
		write_byte(0);
		message_end();
	}
}

public fw_WeaponFireRate_Fix(const __weaponEnt) {
	if(pev_valid(__weaponEnt) == PDATA_SAFE) {
		set_pdata_float(__weaponEnt, OFFSET_LAST_FIRE_TIME, 0.0, OFFSET_LINUX_WEAPONS);
	}
}

public fw_Weapon_PrimaryAttack__Post(const weapon) {
	if(!pev_valid(weapon)) {
		return HAM_IGNORED;
	}
	
	static id;
	id = get_pdata_cbase(weapon, OFFSET_WEAPONOWNER, OFFSET_LINUX_WEAPONS);
	
	if(!is_user_valid_alive(id)) {
		return HAM_IGNORED;
	}
	
	if(g_Zombie[id]) {
		if(g_SpecialMode[id] == MODE_NEMESIS && g_Bazooka[id] && g_CurrentWeapon[id] == CSW_AK47 && !g_EndRound) {
			bazooka__Fire(id);
		}
		
		return HAM_IGNORED;
	}
	
	if(g_SpecialMode[id] == MODE_JASON) {
		static Float:vecRecoil[3];
		vecRecoil[0] = -4.0;
		
		set_pdata_float(weapon, OFFSET_NEXT_PRIMARY_ATTACK, 0.05, OFFSET_LINUX_WEAPONS);
		set_pdata_float(weapon, OFFSET_NEXT_SECONDARY_ATTACK, 0.05, OFFSET_LINUX_WEAPONS);
		set_pdata_float(weapon, OFFSET_TIME_WEAPON_IDLE, 0.05, OFFSET_LINUX_WEAPONS);
		
		entity_set_vector(id, EV_VEC_punchangle, vecRecoil);
		
		return HAM_IGNORED;
	}
	
	if(g_WeaponSkill[id][g_CurrentWeapon[id]][SKILL_SPEED] || g_WeaponSkill[id][g_CurrentWeapon[id]][SKILL_RECOIL]) {
		if(cs_get_weapon_ammo(weapon) < 1) {
			return HAM_IGNORED;
		}
		
		static Float:vecRecoil[3];
		static Float:vecSpeed[3];
		
		if(g_WeaponSkill[id][g_CurrentWeapon[id]][SKILL_RECOIL]) {
			entity_get_vector(id, EV_VEC_punchangle, vecRecoil);
			
			vecRecoil[0] = vecRecoil[0] - (((vecRecoil[0] * (float(g_WeaponSkill[id][g_CurrentWeapon[id]][SKILL_RECOIL]) * 6.0))) / 100.0);
			vecRecoil[1] = vecRecoil[1] - (((vecRecoil[1] * (float(g_WeaponSkill[id][g_CurrentWeapon[id]][SKILL_RECOIL]) * 6.0))) / 100.0);
			vecRecoil[2] = vecRecoil[2] - (((vecRecoil[2] * (float(g_WeaponSkill[id][g_CurrentWeapon[id]][SKILL_RECOIL]) * 6.0))) / 100.0);
			
			entity_set_vector(id, EV_VEC_punchangle, vecRecoil);
		}
		
		if(g_WeaponSkill[id][g_CurrentWeapon[id]][SKILL_SPEED]) {
			vecSpeed[0] = get_pdata_float(weapon, OFFSET_NEXT_PRIMARY_ATTACK, OFFSET_LINUX_WEAPONS);
			vecSpeed[1] = get_pdata_float(weapon, OFFSET_NEXT_SECONDARY_ATTACK, OFFSET_LINUX_WEAPONS);
			vecSpeed[2] = get_pdata_float(weapon, OFFSET_TIME_WEAPON_IDLE, OFFSET_LINUX_WEAPONS);
			
			vecSpeed[0] = vecSpeed[0] - (((vecSpeed[0] * (float(g_WeaponSkill[id][g_CurrentWeapon[id]][SKILL_SPEED]) * 2.5))) / 100.0);
			vecSpeed[1] = vecSpeed[1] - (((vecSpeed[1] * (float(g_WeaponSkill[id][g_CurrentWeapon[id]][SKILL_SPEED]) * 2.5))) / 100.0);
			vecSpeed[2] = vecSpeed[2] - (((vecSpeed[2] * (float(g_WeaponSkill[id][g_CurrentWeapon[id]][SKILL_SPEED]) * 2.5))) / 100.0);
			
			set_pdata_float(weapon, OFFSET_NEXT_PRIMARY_ATTACK, vecSpeed[0], OFFSET_LINUX_WEAPONS);
			set_pdata_float(weapon, OFFSET_NEXT_SECONDARY_ATTACK, vecSpeed[1], OFFSET_LINUX_WEAPONS);
			set_pdata_float(weapon, OFFSET_TIME_WEAPON_IDLE, vecSpeed[2], OFFSET_LINUX_WEAPONS);
		}
	}
	
	return HAM_IGNORED;
}

public fw_Item_AttachToPlayer(const iEnt, const id) {
	if(!pev_valid(iEnt)) {
		return;
	}
	
	new iWeapon;
	iWeapon = get_pdata_int(iEnt, OFFSET_ID, OFFSET_LINUX_WEAPONS);
	
	if(g_WeaponSkill[id][iWeapon][SKILL_MAXCLIP]) {
		if(get_pdata_int(iEnt, OFFSET_KNOWN, OFFSET_LINUX_WEAPONS)) {
			return;
		}
		
		new iExtraClip;
		iExtraClip = (2 * g_WeaponSkill[id][iWeapon][SKILL_MAXCLIP]);
		
		set_pdata_int(iEnt, OFFSET_CLIPAMMO, DEFAULT_MAX_CLIP[iWeapon] + iExtraClip, OFFSET_LINUX_WEAPONS);
	}
}

public fw_Item_PostFrame(const iEnt) {
	if(!pev_valid(iEnt)) {
		return;
	}
	
	static id;
	id = get_pdata_cbase(iEnt, OFFSET_WEAPONOWNER, OFFSET_LINUX_WEAPONS);
	
	if(!is_user_valid_alive(id)) {
		return;
	}
	
	static iWeapon;
	iWeapon = get_pdata_int(iEnt, OFFSET_ID, OFFSET_LINUX_WEAPONS);
	
	if(g_SpecialMode[id] == MODE_WESKER) {
		static iButton;
		iButton = entity_get_int(id, EV_INT_button);
		
		if(iButton & IN_ATTACK2) {
			if(g_Wesker_LASER[id] && iWeapon == CSW_DEAGLE && !g_EndRound && get_gametime() >= g_Wesker_LastLASER[id]) {
				wesker__FireLASER(id);
			}
		}
	}
	
	if(g_WeaponSkill[id][iWeapon][SKILL_MAXCLIP]) {
		static iMaxClip;
		static iReload;
		static Float:fNextAttack;
		static iAmmoType;
		static iBPAmmo;
		static iClip;
		static iButton;
		
		iMaxClip = DEFAULT_MAX_CLIP[iWeapon] + (2 * g_WeaponSkill[id][iWeapon][SKILL_MAXCLIP]);
		iReload = get_pdata_int(iEnt, OFFSET_IN_RELOAD, OFFSET_LINUX_WEAPONS);
		fNextAttack = get_pdata_float(id, OFFSET_NEXT_ATTACK, OFFSET_LINUX);
		iAmmoType = OFFSET_AMMO_PLAYER_SLOT0 + get_pdata_int(iEnt, OFFSET_PRIMARY_AMMO_TYPE, OFFSET_LINUX_WEAPONS);
		iBPAmmo = get_pdata_int(id, iAmmoType, OFFSET_LINUX);
		iClip = get_pdata_int(iEnt, OFFSET_CLIPAMMO, OFFSET_LINUX_WEAPONS);
		iButton = entity_get_int(id, EV_INT_button);
		
		if(iReload && fNextAttack <= 0.0) {
			new i;
			i = min(iMaxClip - iClip, iBPAmmo);
			
			set_pdata_int(iEnt, OFFSET_CLIPAMMO, iClip + i, OFFSET_LINUX_WEAPONS);
			set_pdata_int(id, iAmmoType, iBPAmmo - i, OFFSET_LINUX);
			set_pdata_int(iEnt, OFFSET_IN_RELOAD, 0, OFFSET_LINUX_WEAPONS);
			
			iReload = 0;
		}
		
		if((iButton & IN_ATTACK && get_pdata_float(iEnt, OFFSET_NEXT_PRIMARY_ATTACK, OFFSET_LINUX_WEAPONS) <= 0.0) || (iButton & IN_ATTACK2 && get_pdata_float(iEnt, OFFSET_NEXT_SECONDARY_ATTACK, OFFSET_LINUX_WEAPONS) <= 0.0)) {
			return;
		}
		
		if((iButton & IN_RELOAD) && !iReload) {
			if(iClip >= iMaxClip) {
				entity_set_int(id, EV_INT_button, iButton & ~IN_RELOAD);
				
				if(((1<<iWeapon) & WEAPONS_SILENT_BIT_SUM) && !get_pdata_int(iEnt, OFFSET_SILENT, OFFSET_LINUX_WEAPONS)) {
					setAnimation(id, .animation=(iWeapon == CSW_USP) ? 8 : 7);
				} else {
					setAnimation(id, .animation=0);
				}
			} else if(iClip == DEFAULT_MAX_CLIP[iWeapon]) {
				if(iBPAmmo) {
					set_pdata_float(id, OFFSET_NEXT_ATTACK, DEFAULT_DELAY[iWeapon], OFFSET_LINUX);
					
					if(((1<<iWeapon) & WEAPONS_SILENT_BIT_SUM) && get_pdata_int(iEnt, OFFSET_SILENT, OFFSET_LINUX_WEAPONS)) {
						setAnimation(id, .animation=(iWeapon == CSW_USP) ? 5 : 4);
					} else {
						setAnimation(id, .animation=DEFAULT_ANIMS[iWeapon]);
					}
					
					set_pdata_int(iEnt, OFFSET_IN_RELOAD, 1, OFFSET_LINUX_WEAPONS);
					set_pdata_float(iEnt, OFFSET_TIME_WEAPON_IDLE, DEFAULT_DELAY[iWeapon] + 0.5, OFFSET_LINUX_WEAPONS);
				}
			}
		}
	}
}

public fw_Shotgun_WeaponIdle(const iEnt) {
	if(!pev_valid(iEnt)) {
		return;
	}
	
	static id;
	id = get_pdata_cbase(iEnt, OFFSET_WEAPONOWNER, OFFSET_LINUX_WEAPONS);
	
	if(!is_user_valid_alive(id)) {
		return;
	}
	
	static iWeapon;
	iWeapon = get_pdata_int(iEnt, OFFSET_ID, OFFSET_LINUX_WEAPONS);
	
	if(g_WeaponSkill[id][iWeapon][SKILL_MAXCLIP]) {
		if(get_pdata_float(iEnt, OFFSET_TIME_WEAPON_IDLE, OFFSET_LINUX_WEAPONS) > 0.0) {
			return;
		}
		
		static iMaxClip;
		static iClip;
		static iSpecialReload;
		
		iMaxClip = DEFAULT_MAX_CLIP[iWeapon] + (2 * g_WeaponSkill[id][iWeapon][SKILL_MAXCLIP]);
		iClip = get_pdata_int(iEnt, OFFSET_CLIPAMMO, OFFSET_LINUX_WEAPONS);
		iSpecialReload = get_pdata_int(iEnt, OFFSET_IN_SPECIAL_RELOAD, OFFSET_LINUX_WEAPONS);
		
		if(!iClip && !iSpecialReload) {
			return;
		}
		
		if(iSpecialReload) {
			static iBPAmmo;
			static iDefaultMaxClip;
			
			iBPAmmo = get_pdata_int(id, OFFSET_M3_AMMO, OFFSET_LINUX);
			iDefaultMaxClip = DEFAULT_MAX_CLIP[iWeapon];
			
			if(iClip < iMaxClip && iClip == iDefaultMaxClip && iBPAmmo) {
				shotgunReload(iEnt, iWeapon, iMaxClip, iClip, iBPAmmo, id);
				return;
			} else if(iClip == iMaxClip && iClip != iDefaultMaxClip) {
				setAnimation(id, .animation=4);
				
				set_pdata_int(iEnt, OFFSET_IN_SPECIAL_RELOAD, 0, OFFSET_LINUX_WEAPONS);
				set_pdata_float(iEnt, OFFSET_TIME_WEAPON_IDLE, 1.5, OFFSET_LINUX_WEAPONS);
			}
		}
	}
}

public fw_Shotgun_PostFrame(const iEnt) {
	if(!pev_valid(iEnt)) {
		return;
	}
	
	static id;
	id = get_pdata_cbase(iEnt, OFFSET_WEAPONOWNER, OFFSET_LINUX_WEAPONS);
	
	if(!is_user_valid_alive(id)) {
		return;
	}
	
	static iWeapon;
	iWeapon = get_pdata_int(iEnt, OFFSET_ID, OFFSET_LINUX_WEAPONS);
	
	if(g_WeaponSkill[id][iWeapon][SKILL_MAXCLIP]) {
		static iBPAmmo;
		static iClip;
		static iMaxClip;
		
		iBPAmmo = get_pdata_int(id, OFFSET_M3_AMMO, OFFSET_LINUX);
		iClip = get_pdata_int(iEnt, OFFSET_CLIPAMMO, OFFSET_LINUX_WEAPONS);
		iMaxClip = DEFAULT_MAX_CLIP[iWeapon] + (2 * g_WeaponSkill[id][iWeapon][SKILL_MAXCLIP]);
		
		if(get_pdata_int(iEnt, OFFSET_IN_RELOAD, OFFSET_LINUX_WEAPONS) && get_pdata_float(id, OFFSET_NEXT_ATTACK, OFFSET_LINUX) <= 0.0) {
			static i;
			i = min((iMaxClip - iClip), iBPAmmo);
			
			set_pdata_int(iEnt, OFFSET_CLIPAMMO, iClip + i, OFFSET_LINUX_WEAPONS);
			set_pdata_int(id, OFFSET_M3_AMMO, iBPAmmo - i, OFFSET_LINUX);
			set_pdata_int(iEnt, OFFSET_IN_RELOAD, 0, OFFSET_LINUX_WEAPONS);
			
			return;
		}
		
		static iButton;
		iButton = entity_get_int(id, EV_INT_button);
		
		if(iButton & IN_ATTACK && get_pdata_float(iEnt, OFFSET_NEXT_PRIMARY_ATTACK, OFFSET_LINUX_WEAPONS) <= 0.0) {
			return;
		}
		
		if(iButton & IN_RELOAD) {
			if(iClip >= iMaxClip) {
				entity_set_int(id, EV_INT_button, iButton & ~IN_RELOAD);
				set_pdata_float(iEnt, OFFSET_NEXT_PRIMARY_ATTACK, 0.5, OFFSET_LINUX_WEAPONS);
			} else if(iClip == DEFAULT_MAX_CLIP[iWeapon] && iBPAmmo) {
				shotgunReload(iEnt, iWeapon, iMaxClip, iClip, iBPAmmo, id);
			}
		}
	}
}

shotgunReload(const iEnt, const iWeapon, const iMaxClip, const iClip, const iBPAmmo, const id) {
	if(g_WeaponSkill[id][iWeapon][SKILL_MAXCLIP]) {
		if(iBPAmmo <= 0 || iClip == iMaxClip) {
			return;
		}
		
		if(get_pdata_int(iEnt, OFFSET_NEXT_PRIMARY_ATTACK, OFFSET_LINUX_WEAPONS) > 0.0) {
			return;
		}
		
		switch(get_pdata_int(iEnt, OFFSET_IN_SPECIAL_RELOAD, OFFSET_LINUX_WEAPONS)) {
			case 0: {
				setAnimation(id, .animation=5);
				
				set_pdata_int(iEnt, OFFSET_IN_SPECIAL_RELOAD, 1, OFFSET_LINUX_WEAPONS);
				set_pdata_float(id, OFFSET_NEXT_ATTACK, 0.55, OFFSET_LINUX);
				set_pdata_float(iEnt, OFFSET_TIME_WEAPON_IDLE, 0.55, OFFSET_LINUX_WEAPONS);
				set_pdata_float(iEnt, OFFSET_NEXT_PRIMARY_ATTACK, 0.55, OFFSET_LINUX_WEAPONS);
				set_pdata_float(iEnt, OFFSET_NEXT_SECONDARY_ATTACK, 0.55, OFFSET_LINUX_WEAPONS);
				
				return;
			}
			case 1: {
				if(get_pdata_float(iEnt, OFFSET_TIME_WEAPON_IDLE, OFFSET_LINUX_WEAPONS) > 0.0) {
					return;
				}
				
				setAnimation(id, .animation=3);
				
				emit_sound(id, CHAN_ITEM, (random_num(0, 1)) ? "weapons/reload1.wav" : "weapons/reload3.wav", 1.0, ATTN_NORM, 0, (85 + random_num(0, 0x1f)));
				
				set_pdata_int(iEnt, OFFSET_IN_SPECIAL_RELOAD, 2, OFFSET_LINUX_WEAPONS);
				set_pdata_float(iEnt, OFFSET_TIME_WEAPON_IDLE, (iWeapon == CSW_XM1014) ? 0.3 : 0.45, OFFSET_LINUX_WEAPONS);
			}
			default: {
				set_pdata_int(iEnt, OFFSET_CLIPAMMO, iClip + 1, OFFSET_LINUX_WEAPONS);
				set_pdata_int(id, OFFSET_M3_AMMO, iBPAmmo - 1, OFFSET_LINUX);
				set_pdata_int(iEnt, OFFSET_IN_SPECIAL_RELOAD, 1, OFFSET_LINUX_WEAPONS);
			}
		}
	}
}

public setAnimation(const id, const animation) {
	entity_set_int(id, EV_INT_weaponanim, animation);
	
	message_begin(MSG_ONE, SVC_WEAPONANIM, _, id);
	write_byte(animation);
	write_byte(entity_get_int(id, EV_INT_body));
	message_end();
}

effectGrenade(const entity, const red, const green, const blue, const nade_type) {
	new Float:vecColor[3];
	
	vecColor[0] = float(red);
	vecColor[1] = float(green);
	vecColor[2] = float(blue);
	
	entity_set_int(entity, EV_INT_renderfx, kRenderFxGlowShell);
	entity_set_vector(entity, EV_VEC_rendercolor, vecColor);
	entity_set_int(entity, EV_INT_rendermode, kRenderNormal);
	entity_set_float(entity, EV_FL_renderamt, 1.0);
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_BEAMFOLLOW);
	write_short(entity);
	switch(nade_type) {
		case NADE_TYPE_COMBO, NADE_TYPE_FLARE, NADE_TYPE_BUBBLE: {
			write_short(g_SPRITE_TrailBombs);
		}
		case NADE_TYPE_SUPERNOVA: {
			write_short(g_SPRITE_TrailBombs);
		}
		default: {
			write_short(g_SPRITE_TrailBombs);
		}
	}
	write_byte(10);
	write_byte(3);
	write_byte(red);
	write_byte(green);
	write_byte(blue);
	write_byte(200);
	message_end();
	
	entity_set_int(entity, EV_NADE_TYPE, nade_type);
	
	switch(nade_type) {
		case NADE_TYPE_FLARE: {
			entity_set_vector(entity, EV_FLARE_COLOR, vecColor);
		}
		case NADE_TYPE_BUBBLE: {
			entity_set_vector(entity, EV_FLARE_COLOR, vecColor);
		}
		default: {
			entity_set_float(entity, EV_FL_dmgtime, get_gametime() + 9999.0);
		}
	}
}

public bubblePush(const entity) {
	static iVictim;
	static Float:fInvSqrt;
	static Float:fScalar;
	static Float:vecOrigin[3];
	static Float:vecEntityOrigin[3];
	static iUsers[MAX_USERS];
	static i;
	static j;
	
	entity_get_vector(entity, EV_VEC_origin, vecEntityOrigin);
	
	iVictim = -1;
	j = 0;
	
	while((iVictim = find_ent_in_sphere(iVictim, vecEntityOrigin, 120.0)) != 0) {
		if(is_user_alive(iVictim)) {
			iUsers[j++] = iVictim;
		}
	}
	
	for(i = 0; i < j; ++i) {
		if(!g_Zombie[iUsers[i]]) {
			entity_get_vector(iUsers[i], EV_VEC_origin, vecOrigin);
			
			if(get_distance_f(vecEntityOrigin, vecOrigin) <= 100) {
				g_InBubble[iUsers[i]] = 1;
			} else {
				g_InBubble[iUsers[i]] = 0;
			}
		} else if(g_Zombie[iUsers[i]] && !g_SpecialMode[iUsers[i]] && !g_Immunity[iUsers[i]]) {
			entity_get_vector(iUsers[i], EV_VEC_origin, vecOrigin);
			
			if(get_distance_f(vecEntityOrigin, vecOrigin) > 100) {
				fScalar = 255.0;
			} else {
				fScalar = 2000.0;
			}
			
			vecOrigin[0] -= vecEntityOrigin[0];
			vecOrigin[1] -= vecEntityOrigin[1];
			vecOrigin[2] -= vecEntityOrigin[2];
			
			fInvSqrt = 1.0 / floatsqroot(((vecOrigin[0] * vecOrigin[0]) + (vecOrigin[1] * vecOrigin[1]) + (vecOrigin[2] * vecOrigin[2])));
			
			vecOrigin[0] *= fInvSqrt;
			vecOrigin[1] *= fInvSqrt;
			vecOrigin[2] *= fInvSqrt;
			
			vecOrigin[0] *= fScalar;
			vecOrigin[1] *= fScalar;
			vecOrigin[2] *= fScalar;
			
			entity_set_vector(iUsers[i], EV_VEC_velocity, vecOrigin);
		}
	}
}

public comboExplode(const entity) {
	if(g_EndRound) {
		return;
	}
	
	new iAttacker;
	iAttacker = entity_get_edict(entity, EV_ENT_owner);
	
	if(!is_user_valid_connected(iAttacker)) {
		remove_entity(entity);
		return;
	}
	
	new Float:vecOrigin[3];
	entity_get_vector(entity, EV_VEC_origin, vecOrigin);
	
	createExplosion(vecOrigin, 255, 0, 0);
	
	emit_sound(entity, CHAN_WEAPON, g_SOUND_Grenade_Explosion, 1.0, ATTN_NORM, 0, PITCH_NORM);
	
	new iVictim;
	new iCountVictims;
	
	iVictim = -1;
	iCountVictims = 0;
	
	while((iVictim = engfunc(EngFunc_FindEntityInSphere, iVictim, vecOrigin, NADE_EXPLOSION_RADIUS)) != 0) {
		if(!is_user_alive(iVictim) || !g_Zombie[iVictim] || g_SpecialMode[iVictim]) {
			continue;
		}
		
		++iCountVictims;
	}
	
	if(iCountVictims) {
		new Float:flPercent;
		
		flPercent = float((__APS_THIS_LEVEL(iAttacker) - __APS_THIS_LEVEL_REST1(iAttacker)));
		flPercent *= (float(iCountVictims) * 0.2);
		
		g_ExtraCombo[iAttacker] += floatround(flPercent) / 100;
		
		showCurrentComboHuman(iAttacker, 0);
		
		while(iCountVictims >= (__CHALLENGES[CHALLENGE_COMBO_BOMB][challengeReq] + (g_Challenge[iAttacker][CHALLENGE_COMBO_BOMB] * __CHALLENGES[CHALLENGE_COMBO_BOMB][challengeUp]))) {
			setChallenge(iAttacker, CHALLENGE_COMBO_BOMB);
		}
	}
	
	remove_entity(entity);
}

public frostExplode(const entity, const mode) {
	if(g_EndRound) {
		return;
	}
	
	new iAttacker;
	iAttacker = entity_get_edict(entity, EV_ENT_owner);
	
	if(!is_user_valid_connected(iAttacker)) {
		remove_entity(entity);
		return;
	}
	
	new Float:vecOrigin[3];
	entity_get_vector(entity, EV_VEC_origin, vecOrigin);
	
	createExplosion(vecOrigin, 0, 100, 200);
	
	emit_sound(entity, CHAN_WEAPON, g_SOUND_Grenade_Frost, 1.0, ATTN_NORM, 0, PITCH_NORM);
	
	new iVictim;
	new iCountVictims;
	
	iVictim = -1;
	iCountVictims = 0;
	
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, vecOrigin, 0);
	write_byte(TE_EXPLOSION);
	engfunc(EngFunc_WriteCoord, vecOrigin[0]);
	engfunc(EngFunc_WriteCoord, vecOrigin[1]);
	engfunc(EngFunc_WriteCoord, vecOrigin[2] + 5.0);
	write_short(g_SPRITE_NovaExplode);
	write_byte(20);
	write_byte(24);
	write_byte(TE_EXPLFLAG_NOSOUND);
	message_end();
	
	while((iVictim = engfunc(EngFunc_FindEntityInSphere, iVictim, vecOrigin, NADE_EXPLOSION_RADIUS)) != 0) {
		if(!is_user_alive(iVictim) || !g_Zombie[iVictim] || g_SpecialMode[iVictim] || g_Frozen[iVictim] || g_Immunity[iVictim] || g_ImmunityBombs[iVictim]) {
			continue;
		}
		
		set_user_rendering(iVictim, kRenderFxGlowShell, 0, 100, 200, kRenderNormal, 4);
		
		g_NightvisionOn[iVictim] = 0;
		
		setLight(iVictim, "b");
		
		message_begin(MSG_ONE_UNRELIABLE, g_Message_ScreenFade, _, iVictim);
		write_short(0);
		write_short(0);
		write_short(FFADE_STAYOUT);
		write_byte(0);
		write_byte(100);
		write_byte(200);
		write_byte(100);
		message_end();
		
		g_Frozen[iVictim] = mode;
		g_FrozenGravity[iVictim] = get_user_gravity(iVictim);
		
		if(get_entity_flags(iVictim) & FL_ONGROUND) {
			set_user_gravity(iVictim, 999999.9);
		} else {
			set_user_gravity(iVictim, 0.000001);
		}
		
		g_SpeedGravity[iVictim] = g_Speed[iVictim];
		g_Speed[iVictim] = 1.0;
		
		ExecuteHamB(Ham_Player_ResetMaxSpeed, iVictim);
		
		remove_task(iVictim + TASK_FROZEN);
		set_task(4.0, "task__RemoveFreeze", iVictim + TASK_FROZEN);
		
		emit_sound(iVictim, CHAN_BODY, g_SOUND_Grenade_Frost_Player, 1.0, ATTN_NORM, 0, PITCH_NORM);
		
		++iCountVictims;
	}
	
	remove_entity(entity);
}

public task__RemoveFreeze(const taskid) {
	new id = ID_FROZEN;
	
	if(!g_IsAlive[id] || !g_Frozen[id]) {
		return;
	}
	
	g_Frozen[id] = 0;
	g_Speed[id] = g_SpeedGravity[id];
	
	set_user_gravity(id, g_FrozenGravity[id]);
	ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
	
	set_user_rendering(id);
	
	setNightvision(id, 1);
	
	client_cmd(id, "spk ^"%s^"", g_SOUND_Grenade_Frost_Break);
	
	new vecOrigin[3];
	get_user_origin(id, vecOrigin);
	
	message_begin(MSG_PVS, SVC_TEMPENTITY, vecOrigin);
	write_byte(TE_BREAKMODEL);
	write_coord(vecOrigin[0]);
	write_coord(vecOrigin[1]);
	write_coord(vecOrigin[2] + 24);
	write_coord(16);
	write_coord(16);
	write_coord(16);
	write_coord(random_num(-50, 50));
	write_coord(random_num(-50, 50));
	write_coord(25);
	write_byte(10);
	write_short(g_SPRITE_Glass);
	write_byte(10);
	write_byte(25);
	write_byte(BREAK_GLASS);
	message_end();
}

public infectionExplode(const entity) {
	if(g_EndRound) {
		return;
	}
	
	new iAttacker;
	iAttacker = entity_get_edict(entity, EV_ENT_owner);
	
	if(!is_user_valid_connected(iAttacker)) {
		remove_entity(entity);
		return;
	}
	
	new Float:vecOrigin[3];
	entity_get_vector(entity, EV_VEC_origin, vecOrigin);
	
	createExplosion(vecOrigin, 0, 255, 0);
	
	emit_sound(entity, CHAN_WEAPON, g_SOUND_Grenade_Infection, 1.0, ATTN_NORM, 0, PITCH_NORM);
	
	new iVictim;
	new iCountVictims;
	
	iVictim = -1;
	iCountVictims = 0;
	
	while((iVictim = engfunc(EngFunc_FindEntityInSphere, iVictim, vecOrigin, NADE_EXPLOSION_RADIUS)) != 0) {
		if(!is_user_alive(iVictim) || g_Zombie[iVictim] || g_SpecialMode[iVictim] || g_Immunity[iVictim]) {
			continue;
		}
		
		if(getHumans() == 1) {
			ExecuteHamB(Ham_Killed, iVictim, iAttacker, 0);
			continue;
		}
		
		zombieMe(iVictim, iAttacker, .bomb=1);
		
		++iCountVictims;
	}
	
	remove_entity(entity);
	
	if(!iCountVictims) {
		setAchievement(iAttacker, BOMBA_FALLIDA);
	} else if(iCountVictims) {
		if(get_gametime() < g_LastInfectionExplosion) {
			++g_InfectionExplode_Count;
			
			g_InfectionExplode_Ids[g_InfectionExplode_Count] = iAttacker;
			
			if(g_InfectionExplode_Count == 2) {
				new i;
				for(i = 0; i < 3; ++i) {
					if(g_IsConnected[g_InfectionExplode_Ids[i]]) {
						giveHat(g_InfectionExplode_Ids[i], HAT_ZABUZA);
					}
				}
			}
		} else {
			g_InfectionExplode_Ids[0] = iAttacker;
			g_LastInfectionExplosion = get_gametime() + 0.5;
		}
	}
}

public annihilationExplode(const entity) {
	if(g_EndRound) {
		return;
	}
	
	new iAttacker;
	iAttacker = entity_get_edict(entity, EV_ENT_owner);
	
	if(!is_user_valid_connected(iAttacker)) {
		remove_entity(entity);
		return;
	}
	
	new Float:vecOrigin[3];
	entity_get_vector(entity, EV_VEC_origin, vecOrigin);
	
	createExplosion(vecOrigin, 200, 100, 50);
	
	new iVictim;
	new iCountVictims;
	
	iVictim = -1;
	iCountVictims = 0;
	
	while((iVictim = engfunc(EngFunc_FindEntityInSphere, iVictim, vecOrigin, NADE_EXPLOSION_RADIUS)) != 0) {
		if(!is_user_alive(iVictim) || !g_Zombie[iVictim] || g_SpecialMode[iVictim] || g_Immunity[iVictim] || g_ImmunityBombs[iVictim]) {
			continue;
		}
		
		ExecuteHamB(Ham_Killed, iVictim, iAttacker, 2);
		
		++iCountVictims;
	}
	
	remove_entity(entity);
	
	if(!iCountVictims) {
		setAchievement(iAttacker, NO_LA_NECESITO);
	} else if(iCountVictims >= 15) {
		setAchievement(iAttacker, HASTA_ACA_LLEGARON);
	}
}

public antidoteExplode(const entity) {
	if(g_EndRound) {
		return;
	}
	
	new iAttacker;
	iAttacker = entity_get_edict(entity, EV_ENT_owner);
	
	if(!is_user_valid_connected(iAttacker)) {
		remove_entity(entity);
		return;
	}
	
	new Float:vecOrigin[3];
	entity_get_vector(entity, EV_VEC_origin, vecOrigin);
	
	createExplosion(vecOrigin, 0, 255, 255);
	
	new iVictim;
	new iCountVictims;
	
	iVictim = -1;
	iCountVictims = 0;
	
	while((iVictim = engfunc(EngFunc_FindEntityInSphere, iVictim, vecOrigin, NADE_EXPLOSION_RADIUS)) != 0) {
		if(!is_user_alive(iVictim) || !g_Zombie[iVictim] || g_SpecialMode[iVictim] || g_Immunity[iVictim] || g_LastZombie[iVictim]) {
			continue;
		}
		
		humanMe(iVictim);
		
		++iCountVictims;
	}
	
	remove_entity(entity);
	
	if(!iCountVictims) {
		setAchievement(iAttacker, Y_LA_LIMPIEZA);
	} else if(iCountVictims >= 15) {
		setAchievement(iAttacker, YO_USO_CLEAR_ZOMBIE);
		
		if(iCountVictims >= 20) {
			setAchievement(iAttacker, ANTIDOTO_PARA_TODOS);
		}
	}
}

flareLighting(const entity, const duration, const flare_size) {
	static Float:vecOrigin[3];
	static Float:vecColor[3];
	
	entity_get_vector(entity, EV_VEC_origin, vecOrigin);
	entity_get_vector(entity, EV_FLARE_COLOR, vecColor);
	
	engfunc(EngFunc_MessageBegin, MSG_BROADCAST, SVC_TEMPENTITY, vecOrigin, 0);
	write_byte(TE_DLIGHT);
	engfunc(EngFunc_WriteCoord, vecOrigin[0]);
	engfunc(EngFunc_WriteCoord, vecOrigin[1]);
	engfunc(EngFunc_WriteCoord, vecOrigin[2]);
	write_byte(25 + flare_size);
	write_byte(floatround(vecColor[0]));
	write_byte(floatround(vecColor[1]));
	write_byte(floatround(vecColor[2]));
	write_byte(21);
	write_byte((duration < 3) ? 10 : 0);
	message_end();
}

new g_Camera;

public clcmd__Camera(const id) {
	if(!g_Kiske[id]) {
		return PLUGIN_HANDLED;
	}
	
	g_Camera = !g_Camera;
	
	set_view(id, (g_Camera) ? CAMERA_3RDPERSON : CAMERA_NONE);
	
	return PLUGIN_HANDLED;
}

public clcmd__Test(const id) {
	if(g_Kiske[id]) {
		// strip_user_weapons(id);
	}
	
	return PLUGIN_HANDLED;
}

public clcmd__Invis(const id) {
	g_Options_Invis[id] = !g_Options_Invis[id];
	
	colorChat(id, _, "%sAhora los humanos son %svisibles", ZP_PREFIX, (g_Options_Invis[id]) ? "in" : "");
	
	return PLUGIN_HANDLED;
}

public clcmd__ShowMultiplier(const id) {
	static Float:iMasteryMult;
	
	if(g_Mastery[id] == g_MasteryType) {
		iMasteryMult = 1.0;
	}
	
	colorChat(id, CT, "%sDaño necesario para realizar un combo: !g%d!y", ZP_PREFIX, g_ComboNeedDamage[id]);
	colorChat(id, CT, "%sTu multiplicador de !tammo packs!y es de !gx%0.2f!y", ZP_PREFIX, (g_MultAps[id] + g_ExtraMultAps[id] + g_CAN_Aps + iMasteryMult + g_Legado_MultAps[id]));
	colorChat(id, CT, "%sTu multiplicador de !tpuntos!y es de !gx%d!y", ZP_PREFIX, g_RealMultPoints[id]);
	
	return PLUGIN_HANDLED;
}

createExplosion(const Float:vecOrigin[3], const red, const green, const blue) {
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, vecOrigin, 0);
	write_byte(TE_BEAMCYLINDER);
	engfunc(EngFunc_WriteCoord, vecOrigin[0]);
	engfunc(EngFunc_WriteCoord, vecOrigin[1]);
	engfunc(EngFunc_WriteCoord, vecOrigin[2]);
	engfunc(EngFunc_WriteCoord, vecOrigin[0]);
	engfunc(EngFunc_WriteCoord, vecOrigin[1]);
	engfunc(EngFunc_WriteCoord, vecOrigin[2] + 555.0);
	write_short(g_SPRITE_Shockwave);
	write_byte(0);
	write_byte(0);
	write_byte(4);
	write_byte(60);
	write_byte(0);
	write_byte(red);
	write_byte(green);
	write_byte(blue);
	write_byte(255);
	write_byte(0);
	message_end();
	
	engfunc(EngFunc_MessageBegin, MSG_BROADCAST, SVC_TEMPENTITY, vecOrigin, 0);
	write_byte(TE_DLIGHT);
	engfunc(EngFunc_WriteCoord, vecOrigin[0]);
	engfunc(EngFunc_WriteCoord, vecOrigin[1]);
	engfunc(EngFunc_WriteCoord, vecOrigin[2]);
	write_byte(30);
	write_byte(red);
	write_byte(green);
	write_byte(blue);
	write_byte(15);
	write_byte(50);
	message_end();
}

public setLight(const id, const light[]) {
	message_begin(MSG_ONE, SVC_LIGHTSTYLE, _, id);
	write_byte(0);
	write_string(light);
	message_end();
}

public think__General(const entity) {
	static Float:vecOrigin[3];
	static Float:fTime;
	static iUser;
	static id;
	
	fTime = halflife_time();
	
	for(id = 1; id <= g_MaxUsers; ++id) {
		if(g_IsConnected[id]) {
			if(g_Aura[id][auraOn]) {
				entity_get_vector(id, EV_VEC_origin, vecOrigin);
				
				engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, vecOrigin, 0);
				write_byte(TE_DLIGHT);
				engfunc(EngFunc_WriteCoord, vecOrigin[0]);
				engfunc(EngFunc_WriteCoord, vecOrigin[1]);
				engfunc(EngFunc_WriteCoord, vecOrigin[2]);
				write_byte(g_Aura[id][auraRadius]);
				write_byte(g_Aura[id][auraRed]);
				write_byte(g_Aura[id][auraGreen]);
				write_byte(g_Aura[id][auraBlue]);
				write_byte(2);
				write_byte(0);
				message_end();
			}
			
			if(g_IsAlive[id]) {
				if(g_InGroup[id]) {
					if(fTime >= g_HLTime_GroupCombo[g_InGroup[id]]) {
						finishComboHuman(id);
					}
				} else if(fTime >= g_HLTime_Combo[id] && g_Combo[id]) {
					if(!g_Zombie[id]) {
						finishComboHuman(id);
					} else {
						finishComboZombie(id);
					}
				}
				
				set_hudmessage(g_Options_Color[id][COLOR_HUD][__R], g_Options_Color[id][COLOR_HUD][__G], g_Options_Color[id][COLOR_HUD][__B], g_Options_HUD_Position[id][HUD_GENERAL][0], g_Options_HUD_Position[id][HUD_GENERAL][1],
				g_Options_HUD_Effect[id][HUD_GENERAL], 6.0, 1.1, 0.0, 0.0, 3);
				
				switch(g_Options_HUD_Abrev[id][HUD_GENERAL]) {
					case 0: ShowSyncHudMsg(id, g_Hud_General, "Vida: %s^nChaleco: %d^nAmmo packs: %s^nReset: %d^nNivel: %d (%0.2f%%)^n^n%s", g_HealthHud[id], get_user_armor(id), g_AmmoPacksHud[id], g_Reset[id], g_Level[id], g_Level_Percent[id], g_GroupHUD[g_InGroup[id]]);
					case 1: ShowSyncHudMsg(id, g_Hud_General, "HP: %s^nAP: %d^nAPs: %s^nR: %d^nLV: %d (%0.2f%%)^n^n%s", g_HealthHud[id], get_user_armor(id), g_AmmoPacksHud[id], g_Reset[id], g_Level[id], g_Level_Percent[id], g_GroupHUD[g_InGroup[id]]);
					case 2: ShowSyncHudMsg(id, g_Hud_General, "Vida: %s - Chaleco: %d - Ammo packs: %s^nReset: %d - Nivel: %d (%0.2f%%)^n^n%s", g_HealthHud[id], get_user_armor(id), g_AmmoPacksHud[id], g_Reset[id], g_Level[id], g_Level_Percent[id], g_GroupHUD[g_InGroup[id]]);
					case 3: ShowSyncHudMsg(id, g_Hud_General, "HP: %s - AP: %d - APs: %s^nR: %d - LV: %d (%0.2f%%)^n^n%s", g_HealthHud[id], get_user_armor(id), g_AmmoPacksHud[id], g_Reset[id], g_Level[id], g_Level_Percent[id], g_GroupHUD[g_InGroup[id]]);
				}
			} else {
				iUser = entity_get_int(id, EV_ID_SPEC);
				
				if(!g_IsAlive[iUser]) {
					continue;
				}
				
				set_hudmessage(g_Options_Color[id][COLOR_HUD][__R], g_Options_Color[id][COLOR_HUD][__G], g_Options_Color[id][COLOR_HUD][__B], 0.2, 0.4, g_Options_HUD_Effect[id][HUD_GENERAL], 6.0, 1.1, 0.0, 0.0, 3);
				
				switch(g_Options_HUD_Abrev[id][HUD_GENERAL]) {
					case 0: ShowSyncHudMsg(id, g_Hud_General, "Vida: %s^nChaleco: %d^nAmmo packs: %s^nReset: %d^nNivel: %d (%0.2f%%)^n^n%s", g_HealthHud[iUser], get_user_armor(iUser), g_AmmoPacksHud[iUser], g_Reset[iUser], g_Level[iUser], g_Level_Percent[iUser], g_GroupHUD[g_InGroup[iUser]]);
					case 1: ShowSyncHudMsg(id, g_Hud_General, "HP: %s^nAP: %d^nAPs: %s^nR: %d^nLV: %d (%0.2f%%)^n^n%s", g_HealthHud[iUser], get_user_armor(iUser), g_AmmoPacksHud[iUser], g_Reset[iUser], g_Level[iUser], g_Level_Percent[iUser], g_GroupHUD[g_InGroup[iUser]]);
					case 2: ShowSyncHudMsg(id, g_Hud_General, "Vida: %s - Chaleco: %d - Ammo packs: %s^nReset: %d - Nivel: %d (%0.2f%%)^n^n%s", g_HealthHud[iUser], get_user_armor(iUser), g_AmmoPacksHud[iUser], g_Reset[iUser], g_Level[iUser], g_Level_Percent[iUser], g_GroupHUD[g_InGroup[iUser]]);
					case 3: ShowSyncHudMsg(id, g_Hud_General, "HP: %s - AP: %d - APs: %s^nR: %d - LV: %d (%0.2f%%)^n^n%s", g_HealthHud[iUser], get_user_armor(iUser), g_AmmoPacksHud[iUser], g_Reset[iUser], g_Level[iUser], g_Level_Percent[iUser], g_GroupHUD[g_InGroup[iUser]]);
				}
			}
		}
	}
	
	entity_set_float(entity, EV_FL_nextthink, get_gametime() + 0.1);
}

public addAmmopacks(const id, const value) { // add_aps
	g_AmmoPacks[id] += value;
	
	addDot(g_AmmoPacks[id], g_AmmoPacksHud[id], 31);
	
	checkAPsEquation(id);
}

public clcmd__Ammos(const id) {
	if(!g_Kiske[id]) {
		return PLUGIN_HANDLED;
	}
	
	new sTarget[11];
	new iTarget;
	
	read_argv(1, sTarget, 10);
	iTarget = cmd_target(id, sTarget, CMDTARGET_ALLOW_SELF);
	
	if(iTarget) {
		new sAmmos[11];
		read_argv(2, sAmmos, 10);
		
		if(read_argc() < 3) {
			client_print(id, print_console, "[ZP] Uso: zp_ammos <nombre> <factor, + o nada (setear)> <cantidad>");
			return PLUGIN_HANDLED;
		}
		
		new iAmmos;		
		iAmmos = str_to_num(sAmmos);
		
		switch(sAmmos[0]) {
			case '+': {
				addAmmopacks(iTarget, iAmmos);
				colorChat(iTarget, _, "%s!t%s!y te ha dado !g%d ammo packs!y", ZP_PREFIX, g_UserName[id], iAmmos);
			} default: {
				g_AmmoPacks[iTarget] = 0;
				
				addAmmopacks(iTarget, iAmmos);
				
				colorChat(iTarget, _, "%s!t%s!y te ha editado tus !gammo packs!y, ahora tenés !g%0d ammo packs!y", ZP_PREFIX, g_UserName[id], iAmmos);
			}
		}
		
		client_print(id, print_console, "[ZP] Los ammo packs de %s han sido modificados!", g_UserName[iTarget]);
	}
	
	return PLUGIN_HANDLED;
}

public clcmd__Level(const id) {
	if(!g_Kiske[id]) {
		return PLUGIN_HANDLED;
	}
	
	new sTarget[11];
	new iTarget;
	
	read_argv(1, sTarget, 10);
	iTarget = cmd_target(id, sTarget, CMDTARGET_ALLOW_SELF);
	
	if(iTarget) {
		new sLevel[11];
		read_argv(2, sLevel, 10);
		
		if(read_argc() < 3) {
			client_print(id, print_console, "[ZP] Uso: zp_level <nombre> <factor, + o nada (setear)> <cantidad>");
			return PLUGIN_HANDLED;
		}
		
		new iLevel;
		new iLastLevel;
		
		iLevel = str_to_num(sLevel);
		iLastLevel = g_Level[iTarget];
		
		switch(sLevel[0]) {
			case '+': {
				g_Level[iTarget] += iLevel;
				colorChat(iTarget, _, "%s!t%s!y te ha dado !g%d niveles!y", ZP_PREFIX, g_UserName[id], iLevel);
				
				fixAps(iTarget);
			}
			default: {
				g_Level[iTarget] = iLevel;
				colorChat(iTarget, _, "%s!t%s!y te ha editado tus !gniveles!y, ahora tenés !g%d niveles!y", ZP_PREFIX, g_UserName[id], iLevel);
				
				fixAps(iTarget);
			}
		}
		
		client_print(id, print_console, "[ZP] %s tenía %d niveles y ahora tiene %d", g_UserName[iTarget], iLastLevel, g_Level[iTarget]);
	}
	
	return PLUGIN_HANDLED;
}

public clcmd__Reset(const id) {
	if(!g_Kiske[id]) {
		return PLUGIN_HANDLED;
	}
	
	new sTarget[11];
	new iTarget;
	
	read_argv(1, sTarget, 10);
	iTarget = cmd_target(id, sTarget, CMDTARGET_ALLOW_SELF);
	
	if(iTarget) {
		new sReset[11];
		read_argv(2, sReset, 10);
		
		if(read_argc() < 3) {
			client_print(id, print_console, "[ZP] Uso: zp_reset <nombre> <factor, + o nada (setear)> <cantidad>");
			return PLUGIN_HANDLED;
		}
		
		new iReset;
		new iLastReset;
		
		iReset = str_to_num(sReset);
		iLastReset = g_Reset[iTarget];
		
		switch(sReset[0]) {
			case '+': {
				g_Reset[iTarget] += iReset;
				colorChat(iTarget, _, "%s!t%s!y te ha dado !g%d resets!y", ZP_PREFIX, g_UserName[id], iReset);
				
				fixAps(iTarget);
			}
			default: {
				g_Reset[iTarget] = iReset;
				colorChat(iTarget, _, "%s!t%s!y te ha editado tus !gniveles!y, ahora tenés !g%d resets!y", ZP_PREFIX, g_UserName[id], iReset);
				
				fixAps(iTarget);
			}
		}
		
		client_print(id, print_console, "[ZP] %s tenía %d resets y ahora tiene %d", g_UserName[iTarget], iLastReset, g_Reset[iTarget]);
	}
	
	return PLUGIN_HANDLED;
}

public fixAps(const id) {
	g_AmmoPacks[id] = __APS_THIS_LEVEL_REST1(id);
	
	addDot(g_AmmoPacks[id], g_AmmoPacksHud[id], 31);
	
	checkAPsEquation(id);
}

public clcmd__Points(const id) {
	if(!g_Kiske[id]) {
		return PLUGIN_HANDLED;
	}
	
	new sTarget[11];
	new iTarget;
	
	read_argv(1, sTarget, 10);
	iTarget = cmd_target(id, sTarget, CMDTARGET_ALLOW_SELF);
	
	if(iTarget) {
		new sPoints[11];
		new sClass[2];
		
		read_argv(2, sPoints, 10);
		read_argv(3, sClass, 1);
		
		if(read_argc() < 3) {
			client_print(id, print_console, "[ZP] Uso: zp_points <nombre> <factor, + o nada (setear)> <cantidad> <clase (H, Z, U, L, D)>");
			return PLUGIN_HANDLED;
		}
		
		new iPoints;
		new iClass;
		
		iPoints = str_to_num(sPoints);
		
		switch(sClass[0]) {
			case 'H': iClass = P_HUMAN;
			case 'Z': iClass = P_ZOMBIE;
			case 'U': iClass = P_UUT;
			case 'L': iClass = P_LEGADO;
			case 'D': iClass = P_DIAMONDS;
			default: iClass = -1;
		}
		
		new const TEXT_POINTS[][] = {
			"pH", "pZ", "Uut", "pL", "Diamantes"
		};
		
		switch(sPoints[0]) {
			case '+': {
				if(iClass >= P_HUMAN) {
					g_Points[iTarget][iClass] += iPoints;
					
					colorChat(iTarget, _, "%s!t%s!y te ha dado !g%d %s!y", ZP_PREFIX, g_UserName[id], iPoints, TEXT_POINTS[iClass]);
					return PLUGIN_HANDLED;
				}
				
				new i;
				for(i = 0; i < classPoints; ++i) {
					g_Points[iTarget][i] += iPoints;
				}
				
				colorChat(iTarget, _, "%s!t%s!y te ha dado !g%d pHZL, Uut y Diamantes!y", ZP_PREFIX, g_UserName[id], iPoints);
			}
			default: {
				if(iClass >= P_HUMAN) {
					g_Points[iTarget][iClass] = iPoints;
					
					colorChat(iTarget, _, "%s!t%s!y te ha dado !g%d %s!y", ZP_PREFIX, g_UserName[id], iPoints, TEXT_POINTS[iClass]);
					return PLUGIN_HANDLED;
				}
				
				new i;
				for(i = 0; i < classPoints; ++i) {
					g_Points[iTarget][i] = iPoints;
				}
				
				colorChat(iTarget, _, "%s!t%s!y te ha editado tus puntos, ahora tenés !g%d pHZL, Uut y Diamantes!y", ZP_PREFIX, g_UserName[id], iPoints);
			}
		}
		
		client_print(id, print_console, "[ZP] Puntos editados al usuario %s", g_UserName[iTarget]);
	}
	
	return PLUGIN_HANDLED;
}

new g_Temp_AchievementsIds;
public clcmd__Achievement(const id) {
	if(!g_Kiske[id]) {
		return PLUGIN_HANDLED;
	}
	
	new sTarget[11];
	new iTarget;
	
	read_argv(1, sTarget, 10);
	iTarget = cmd_target(id, sTarget, CMDTARGET_ALLOW_SELF);
	
	if(read_argc() < 3) {
		new i;
		g_Temp_AchievementsIds = 1;
		
		for(i = 0; i < (50*g_Temp_AchievementsIds); ++i) {
			console_print(id, "%d = %s", i, __ACHIEVEMENTS[i][achievementName]);
		}
		
		set_task(1.0, "sendInfo__Achievement", id);
		
		return PLUGIN_HANDLED;
	}
	
	if(iTarget) {
		new sAchievement[11];
		read_argv(2, sAchievement, 10);
		
		new iAchievement;
		iAchievement = str_to_num(sAchievement);
		
		if(contain(__ACHIEVEMENTS[iAchievement][achievementName], "PRIMERO:") == -1) {
			setAchievement(iTarget, iAchievement, .achievementFake=1);
		} else {
			setAchievement__First(iTarget, iAchievement, .achievementFake=1);
		}
	}
	
	return PLUGIN_HANDLED;
}

public sendInfo__Achievement(const id) {
	if(g_IsConnected[id]) {
		new i;
		new j = 50 * g_Temp_AchievementsIds;
		
		++g_Temp_AchievementsIds;
		
		new k = 50 * g_Temp_AchievementsIds;
		
		if(k > achievementsIds) {
			k = achievementsIds;
		}
		
		for(i = j; i < k; ++i) {
			console_print(id, "%d = %s", i, __ACHIEVEMENTS[i][achievementName]);
		}
		
		set_task(1.0, "sendInfo__Achievement", id);
	}
}

public clcmd__Say(const id) {
	static sMsg[191];
	
	read_args(sMsg, 190);
	remove_quotes(sMsg);
	
	replace_all(sMsg, 190, "%", "");
	replace_all(sMsg, 190, "!y", ""); 
	replace_all(sMsg, 190, "!t", "");
	replace_all(sMsg, 190, "!g", "");
	
	if(equal(sMsg, "") || sMsg[0] == '/' || sMsg[0] == '@' || sMsg[0] == '!') {
		return PLUGIN_HANDLED;
	}
	
	static iTeam;
	iTeam = getUserTeam(id);
	
	if(iTeam == FM_CS_TEAM_T || iTeam == FM_CS_TEAM_CT) {
		if(g_Reset[id]) {
			colorChat(0, iTeam, "%s!t%s!g [%d](%d)!y : %s", (g_IsAlive[id]) ? "" : "!y*DEAD* ", g_UserName[id], g_Reset[id], g_Level[id], sMsg);
		} else {
			colorChat(0, iTeam, "%s!t%s!g (%d)!y : %s", (g_IsAlive[id]) ? "" : "!y*DEAD* ", g_UserName[id], g_Level[id], sMsg);
		}
	} else {
		iTeam = 3;
		
		if(g_AccountLogged[id]) {
			colorChat(0, iTeam, "!y(SIN ELEGIR PJ)!t %s !y: %s", g_UserName[id], sMsg);
		} else {
			colorChat(0, iTeam, "!y(SIN IDENTIFICARSE)!t %s !y: %s", g_UserName[id], sMsg);
		}
	}
	
	if(g_LogSay) {
		log_to_file("log_say.txt", "%s [%d](%d) : %s  ~~ [HP=%d][APS=%d]", g_UserName[id], g_Reset[id], g_Level[id], sMsg, g_Health[id], g_AmmoPacks[id]);
	}
	
	return PLUGIN_HANDLED;
}

public clcmd__SayTeam(const id) {
	if(!g_ClanId[id]) {
		return PLUGIN_HANDLED;
	}
	
	
	
	return PLUGIN_HANDLED;
}

public sqlThread__CheckName(const failstate, const Handle:query, const error[], const error_num, const data[], const size, const Float:queuetime) {
	new id;
	id = data[0];
	
	if(!g_IsConnected[id]) {
		return;
	}
	
	switch(failstate) {
		case TQUERY_CONNECT_FAILED: {
			return;
		}
		case TQUERY_QUERY_FAILED: {
			log_to_file("zp_sql.log", "sqlThread__CheckName - %d - %s", error_num, error);
		}
		case TQUERY_SUCCESS: {
			switch(data[1]) {
				case CHECK_PJ_NAME: {
					if(!SQL_NumResults(query)) {
						createPJ(id);
					} else {
						colorChat(id, TERRORIST, "%sEl nombre elegido (!g%s!y) ya está en uso!", ZP_PREFIX, g_UserName[id]);
						
						g_AllowChangeName[id] = 1;
						
						client_cmd(id, "name ^"unnamed^"");
					}
				}
				case CHECK_ACCOUNT_NAME: {
					if(!SQL_NumResults(query)) {
						client_cmd(id, "messagemode CREAR_CONTRASENIA");
						client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonOk);
						
						showLogo(id, LOGO_CREAR_PASSWORD);
					} else {
						g_AccountName[id][0] = EOS;
						
						colorChat(id, TERRORIST, "%s!tEse nombre de cuenta ya existe, elija otro por favor!", ZP_PREFIX);
						
						client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonBad);
						
						showMenu__Register_Login(id);
					}
				}
				case CHECK_ACCOUNT_NAME_02: {
					if(!SQL_NumResults(query)) {
						g_AccountName[id][0] = EOS;
						
						client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonBad);
						
						colorChat(id, TERRORIST, "%s!tNo existe ninguna cuenta con ese nombre!", ZP_PREFIX);
						
						showMenu__Register_Login(id);
					} else {
						resetInfo(id);
						
						client_cmd(id, "setinfo zp5 ^"^"");
						client_cmd(id, "setinfo zp6 ^"%s^"", g_AccountName[id]);
						
						set_user_info(id, "zp5", "");
						set_user_info(id, "zp6", g_AccountName[id]);
						
						task__CheckAccount(id);
						
						if(!g_AnotherUserInYourAccount[id]) {
							client_cmd(id, "messagemode IDENTIFICAR_CONTRASENIA");
							client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonOk);
							
							showLogo(id, LOGO_IDENTIFICAR_PASSWORD);
						}
						
						// colorChat(id, CT, "%s!tEscriba la contraseña que protege esta cuenta!", ZP_PREFIX);
					}
				}
			}
		}
	}
}

public sqlThread__CheckClanName(const failstate, const Handle:query, const error[], const error_num, const data[], const size, const Float:queuetime) {
	new id;
	id = data[0];
	
	if(!g_IsConnected[id]) {
		return;
	}
	
	switch(failstate) {
		case TQUERY_CONNECT_FAILED: {
			return;
		}
		case TQUERY_QUERY_FAILED: {
			log_to_file("zp_sql.log", "sqlThread__CheckClanName - %d - %s", error_num, error);
		}
		case TQUERY_SUCCESS: {
			if(!SQL_NumResults(query)) {
				new Handle:sqlQuery;
				
				sqlQuery = SQL_PrepareQuery(g_SqlConnection, "INSERT INTO zp6_clanes (`name`, `created_date`) VALUES (^"%s^", UNIX_TIMESTAMP());", g_CreateClanName[id]);
				if(!SQL_Execute(sqlQuery)) {
					executeQuery(id, sqlQuery, 3100);
				} else {
					SQL_FreeHandle(sqlQuery);
				
					sqlQuery = SQL_PrepareQuery(g_SqlConnection, "SELECT id FROM zp6_clanes ORDER BY id DESC LIMIT 1;");
					if(!SQL_Execute(sqlQuery)) {
						executeQuery(id, sqlQuery, 3200);
					} else {
						new iClanId = SQL_ReadResult(sqlQuery, 0);
						
						SQL_FreeHandle(sqlQuery);
						
						sqlQuery = SQL_PrepareQuery(g_SqlConnection, "INSERT INTO zp6_clanes_miembros (`clan_id`, `acc_id`, `pj_id`, `name`, `range`, `since`) VALUES ('%d', '%d', '%d', ^"%s^", '3', UNIX_TIMESTAMP());",
						iClanId, g_AccountId[id], g_AccountPJs[id][g_UserSelected[id]], g_UserName[id]);
						
						if(!SQL_Execute(sqlQuery)) {
							executeQuery(id, sqlQuery, 3300);
						} else {
							SQL_FreeHandle(sqlQuery);
							
							g_ClanId[id] = iClanId;
							g_InClan[id] = clanFindId();
							
							copy(g_ClanName[g_InClan[id]], 31, g_CreateClanName[id]);
							g_ClanTulio[g_InClan[id]] = 0;
							
							get_time("%d/%m/%Y", g_ClanInfoCreateDate[g_InClan[id]], 31);
							
							g_ClanInfo[g_InClan[id]][clanVictory] = 0;
							g_ClanInfo[g_InClan[id]][clanVictoryConsec] = 0;
							g_ClanInfo[g_InClan[id]][clanVictoryConsecHistory] = 0;
							g_ClanInfo[g_InClan[id]][clanChampion] = 0;
							
							g_ClanRank[g_InClan[id]] = 0;
							
							g_ClanOnline[g_InClan[id]] = 1;
							
							g_ClanMembers[g_InClan[id]] = 0;
							
							g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberId] = g_AccountId[id];
							g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberPj] = g_AccountPJs[id][g_UserSelected[id]];
							copy(g_ClanMemberName[g_InClan[id]][g_ClanMembers[g_InClan[id]]], 31, g_UserName[id]);
							g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberRange] = 3;
							g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberReset] = g_Reset[id];
							g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberLevel] = g_Level[id];
							g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberTulio] = 0;
							g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberSinceD] = 0;
							g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberSinceH] = 0;
							g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberSinceM] = 0;
							
							g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberLastTimeD] = 0;
							g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberLastTimeH] = 0;
							g_ClanMemberInfo[g_InClan[id]][g_ClanMembers[g_InClan[id]]][memberLastTimeM] = 0;
							
							g_ClanInPos[id] = 0;
							
							++g_ClanMembers[g_InClan[id]];
							
							showMenu__Clan(id);
						}
					}
				}
			} else {
				g_CreateClanName[id][0] = EOS;
				
				colorChat(id, TERRORIST, "%s!tEse nombre de clan ya existe, elija otro por favor!", ZP_PREFIX);
				
				client_cmd(id, "spk ^"%s^"", g_SOUND_ButtonBad);
				
				showMenu__Clan(id);
			}
		}
	}
}

public sqlThread__Updates(const failstate, const Handle:query, const error[], const error_num, const data[], const size, const Float:queuetime) {
	new id;
	id = data[0];
	
	if(!g_IsConnected[id]) {
		return;
	}
	
	switch(failstate) {
		case TQUERY_CONNECT_FAILED: {
			return;
		}
		case TQUERY_QUERY_FAILED: {
			log_to_file("zp_sql.log", "sqlThread__Updates - %d - %s", error_num, error);
		}
		case TQUERY_SUCCESS: {
			switch(data[1]) {
				case 0: {
					colorChat(id, CT, "%s!t%s!y ha sido degradado a !tMiembro!y!", ZP_PREFIX, g_ClanMemberName[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]]);
					
					g_ClanMemberInfo[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]][memberRange] = 1;
				}
				case 1: {
					colorChat(id, CT, "%s!t%s!y ha sido promovido a !tVeterano!y!", ZP_PREFIX, g_ClanMemberName[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]]);
					
					g_ClanMemberInfo[g_InClan[id]][g_MenuPage[id][MENU_CLAN_MEMBERID]][memberRange] = 2;
				}
			}
		}
	}
	
	showMenu__Clan_MemberInfo(id, g_MenuPage[id][MENU_CLAN_MEMBERID]);
}

public touch__GrenadeAll(const grenade, const ent) {
	if(is_valid_ent(grenade) && isSolid(ent)) {
		static iNadeType;
		iNadeType = entity_get_int(grenade, EV_NADE_TYPE);
		
		if(iNadeType != NADE_TYPE_FLARE && iNadeType != NADE_TYPE_BUBBLE) {
			entity_set_float(grenade, EV_FL_dmgtime, get_gametime() + 0.001);
		}
	}
}

public checkGroup(const id, const user, const leave_id) {
	new i = g_InGroup[id];
	new j;
	new k = 0;
	
	g_GroupHUD[i][0] = EOS;
	
	if(id == leave_id) { // LA PERSONA SALIO DEL GRUPO POR SU CUENTA
		for(j = 1; j < 4; ++j) {
			if(g_GroupId[i][j]) {
				if(leave_id != g_GroupId[i][j]) {
					add(g_GroupHUD[i], 127, g_UserName[g_GroupId[i][j]]);
					add(g_GroupHUD[i], 127, "^n");
				}
				
				colorChat(g_GroupId[i][j], TERRORIST, "%s!t%s!y se ha ido del grupo!", ZP_PREFIX, g_UserName[leave_id]);
				++k;
			}
		}
	} else { // LO EXPULSARON
		for(j = 1; j < 4; ++j) {
			if(g_GroupId[i][j]) {
				if(leave_id != g_GroupId[i][j]) {
					add(g_GroupHUD[i], 127, g_UserName[g_GroupId[i][j]]);
					add(g_GroupHUD[i], 127, "^n");
				}
				
				colorChat(g_GroupId[i][j], TERRORIST, "%s!t%s!y ha sido expulsado del grupo!", ZP_PREFIX, g_UserName[leave_id]);
				++k;
			}
		}
	}
	
	if(!g_Zombie[leave_id]) {
		finishComboHuman(leave_id);
	}
	
	g_InGroup[leave_id] = 0;
	g_GroupId[i][user] = 0;
	
	if(k < 3) { // Si el grupo solo tenía 2 personas en total, disolver grupo!
		for(j = 1; j < 4; ++j) {
			if(g_GroupId[i][j]) {
				g_GroupHUD[i][0] = EOS;
				
				colorChat(g_GroupId[i][j], _, "%sTu grupo se ha disuelto!", ZP_PREFIX);
				
				g_InGroup[g_GroupId[i][j]] = 0;
				g_MyGroup[g_GroupId[i][j]] = 0;
				g_GroupId[i][j] = 0;
			}
		}
		
		g_GroupId[i][0] = 0; // Liberar id del grupo
	} else if(g_MyGroup[leave_id]) { // El que se fue era el dueño del grupo, darselo a otro!
		g_MyGroup[leave_id] = 0;
		
		k = 0;
		for(j = 1; j < 4; ++j) {
			if(g_GroupId[i][j]) {
				if(!k) {
					k = g_GroupId[i][j];
					g_MyGroup[k] = 1;
				}
				
				colorChat(g_GroupId[i][j], CT, "%sEl nuevo dueño del grupo es !t%s", ZP_PREFIX, g_UserName[k]);
			}
		}
	}
}

groupFindId() {
	new i;
	
	for(i = 1; i < 14; ++i) {
		if(!g_GroupId[i][0]) {
			return i;
		}
	}
	
	return 0;
}

groupFindSlot(const group) {
	new i;
	
	for(i = 1; i < 4; ++i) {
		if(!g_GroupId[group][i]) {
			return i;
		}
	}
	
	return 0;
}

clanFindId() {
	new i;
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(!g_ClanId[i]) {
			return i;
		}
	}
	
	return 0;
}

public setHat(const id, const hatId) {
	if(!g_IsAlive[id]) {
		return;
	}
	
	if(is_valid_ent(g_HatEnt[id])) {
		remove_entity(g_HatEnt[id]);
	}
	
	g_HatNext[id] = HAT_NONE;
	
	g_ExtraMultAps[id] -= __HATS[g_HatId[id]][hatUpgrade5];
	
	updateComboNeeded(id);
	
	g_HatId[id] = hatId;
	
	if(!hatId) {
		return;
	}
	
	g_ExtraMultAps[id] += __HATS[g_HatId[id]][hatUpgrade5];
	
	updateComboNeeded(id);
	
	g_HatEnt[id] = create_entity("info_target");
	
	if(is_valid_ent(g_HatEnt[id])) {
		entity_set_string(g_HatEnt[id], EV_SZ_classname, "entHat");
		
		entity_set_int(g_HatEnt[id], EV_INT_solid, SOLID_NOT);
		entity_set_int(g_HatEnt[id], EV_INT_movetype, MOVETYPE_FOLLOW);
		entity_set_edict(g_HatEnt[id], EV_ENT_aiment, id);
		entity_set_edict(g_HatEnt[id], EV_ENT_owner, id);
		
		entity_set_int(g_HatEnt[id], EV_INT_iuser3, 1337);
		
		entity_set_model(g_HatEnt[id], __HATS[hatId][hatModel]);
	}
}

public giveHat(const id, const hatId) {
	if(g_Hat[id][hatId]) {
		return;
	}
	
	g_Hat[id][hatId] = 1;
	
	static sDate[32];
	get_time("%d-%m-%Y - %H:%M", sDate, 31);
	
	new Handle:sqlQuery;
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "INSERT INTO zp6_hats (`acc_id`, `pj_id`, `hat_id`, `hat_name`, `hat_date`) VALUES ('%d', '%d', '%d', ^"%s^", ^"%s^");", g_AccountId[id], g_AccountPJs[id][g_UserSelected[id]], hatId, __HATS[hatId][hatName], sDate);
	
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(id, sqlQuery, 3500);
	} else {
		SQL_FreeHandle(sqlQuery);
	}
	
	colorChat(0, CT, "%s!t%s!y ganó el gorro !g%s!y", ZP_PREFIX, g_UserName[id], __HATS[hatId][hatName]);
	
	saveInfo(id, .disconnect=0);
}

setAchievement(const id, const achievementId, achievementFake=0) { // s_ach
	if(g_Achievement[id][achievementId]) {
		return;
	}
	
	if(__ACHIEVEMENTS[achievementId][achievementUsersNeed] && !achievementFake) {
		if(getUsersPlaying() < __ACHIEVEMENTS[achievementId][achievementUsersNeed]) {
			return;
		}
	}
	
	g_Achievement[id][achievementId] = 1;
	
	static sTime[32];
	
	get_time("%d-%m-%Y - %H:%M", sTime, 31);
	formatex(g_AchievementUnlocked[id][achievementId], 31, sTime);
	
	new Handle:sqlQuery;
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "INSERT INTO zp6_achievements (`acc_id`, `pj_id`, `user_name`, `achievement_id`, `achievement_name`, `achievement_date`) VALUES ('%d', '%d', ^"%s^", '%d', ^"%s^", ^"%s^");",
	g_AccountId[id], g_AccountPJs[id][g_UserSelected[id]], g_UserName[id], achievementId, __ACHIEVEMENTS[achievementId][achievementName], g_AchievementUnlocked[id][achievementId]);
	
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(id, sqlQuery, 3600);
	} else {
		SQL_FreeHandle(sqlQuery);
	}
	
	colorChat(0, CT, "%s!t%s!y ganó el logro !g%s !t[G]!y !t(%d Uut)!y", ZP_PREFIX, g_UserName[id], __ACHIEVEMENTS[achievementId][achievementName], __ACHIEVEMENTS[achievementId][achievementUut]);
	
	g_Link_AchievementId = achievementId;
	
	g_Points[id][P_UUT] += __ACHIEVEMENTS[achievementId][achievementUut];
	g_MultAps[id] += __ACHIEVEMENTS[achievementId][achievementMult];
	
	++g_Stats[id][STAT_DONE][STAT_ACHIEVEMENTS];
	
	if(!g_Hat[id][HAT_PSYCHO] && g_Achievement[id][VIRUS] && g_Achievement[id][BOMBA_FALLIDA]) {
		giveHat(id, HAT_PSYCHO);
	}
	
	switch(g_Stats[id][STAT_DONE][STAT_ACHIEVEMENTS]) {
		case 25: {
			setAchievement(id, LOS_PRIMEROS);
		} case 75: {
			setAchievement(id, VAMOS_POR_MAS);
		} case 150: {
			setAchievement(id, EXPERTO_EN_LOGROS);
		} case 300: {
			setAchievement(id, THIS_IS_SPARTA);
		} default: {
			saveInfo(id, .disconnect=0);
		}
	}
}

setAchievement__First(const id, const achievementId, achievementFake=0) {
	if(g_Achievement[0][achievementId]) {
		return;
	}
	
	if(__ACHIEVEMENTS[achievementId][achievementUsersNeed] && !achievementFake) {
		if(getUsersPlaying() < __ACHIEVEMENTS[achievementId][achievementUsersNeed]) {
			return;
		}
	}
	
	g_Achievement[0][achievementId] = 1;
	g_Achievement[id][achievementId] = 1;
	
	static sTime[32];
	
	get_time("%d-%m-%Y - %H:%M", sTime, 31);
	formatex(g_AchievementUnlocked[id][achievementId], 31, sTime);
	
	copy(g_AchievementUnlocked[0][achievementId], 31, g_AchievementUnlocked[id][achievementId]);
	
	new Handle:sqlQuery;
	sqlQuery = SQL_PrepareQuery(g_SqlConnection, "INSERT INTO zp6_achievements (`acc_id`, `pj_id`, `user_name`, `achievement_id`, `achievement_name`, `achievement_date`, `achievement_first`) VALUES ('%d', '%d', ^"%s^", '%d', ^"%s^", ^"%s^", '1');",
	g_AccountId[id], g_AccountPJs[id][g_UserSelected[id]], g_UserName[id], achievementId, __ACHIEVEMENTS[achievementId][achievementName], g_AchievementUnlocked[id][achievementId]);
	
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(id, sqlQuery, 3700);
	} else {
		SQL_FreeHandle(sqlQuery);
	}
	
	colorChat(0, CT, "%s!t%s!y ganó el logro !g%s !t[G]!y !t(%d Uut)!y", ZP_PREFIX, g_UserName[id], __ACHIEVEMENTS[achievementId][achievementName], __ACHIEVEMENTS[achievementId][achievementUut]);
	
	g_Link_AchievementId = achievementId;
	
	g_Points[id][P_UUT] += __ACHIEVEMENTS[achievementId][achievementUut];
	g_MultAps[id] += __ACHIEVEMENTS[achievementId][achievementMult];
	
	++g_Stats[id][STAT_DONE][STAT_ACHIEVEMENTS];
	
	saveInfo(id, .disconnect=0);
}

setChallenge(const id, const challengeId) { // s_cha
	if(__CHALLENGES[challengeId][challengeUsersNeed]) {
		if(getUsersPlaying() < __CHALLENGES[challengeId][challengeUsersNeed]) {
			return;
		}
	}
	
	++g_Challenge[id][challengeId];
	
	new Handle:sqlQuery;
	
	if(g_Challenge[id][challengeId] == 1) {
		sqlQuery = SQL_PrepareQuery(g_SqlConnection, "INSERT INTO zp6_achievements (`acc_id`, `pj_id`, `user_name`, `achievement_id`, `challenge_lvl`, `achievement_name`, `achievement_date`) VALUES ('%d', '%d', ^"%s^", '%d', '1', ^"%s^", ^"0^");",
		g_AccountId[id], g_AccountPJs[id][g_UserSelected[id]], g_UserName[id], challengeId, __CHALLENGES[challengeId][challengeName]);
	} else {
		sqlQuery = SQL_PrepareQuery(g_SqlConnection, "UPDATE zp6_achievements SET challenge_lvl='%d' WHERE acc_id='%d' AND pj_id='%d' AND achievement_id=^"%s^"", g_Challenge[id][challengeId], g_AccountId[id], g_AccountPJs[id][g_UserSelected[id]], challengeId);
	}
	
	if(!SQL_Execute(sqlQuery)) {
		executeQuery(id, sqlQuery, 3800);
	} else {
		SQL_FreeHandle(sqlQuery);
	}
	
	colorChat(0, CT, "%s!t%s!y ganó el desafío !g%s!y!t [NIV. !g%d!t] !t(+ x%0.3f Uut)!y", ZP_PREFIX, g_UserName[id], __CHALLENGES[challengeId][challengeName], (g_Challenge[id][challengeId] - 1), __CHALLENGES[challengeId][challengeMult]);
	
	g_MultAps[id] += __CHALLENGES[challengeId][challengeMult];
	
	++g_Stats[id][STAT_DONE][STAT_CHALLENGES];
	
	saveInfo(id, .disconnect=0);
}

getRandomUser(const userAlive, const withChance) {
	static iRandom;
	static iTeam;
	static i;
	
	if(withChance) {
		static iChance[33];
		static iTotalChance;
		static iSum;
		
		iTotalChance = 0;
		iSum = 0;
		
		for(i = 1; i <= g_MaxUsers; ++i) {
			iChance[i] = 0;
			
			if(userAlive && !g_IsAlive[i]) {
				continue;
			}
			
			iTeam = getUserTeam(i);
			
			if(iTeam != FM_CS_TEAM_T && iTeam != FM_CS_TEAM_CT) {
				continue;
			}
			
			iChance[i] = 100;
			
			iChance[i] += __HATS[g_HatId[i]][hatUpgrade6];
			iTotalChance += iChance[i];
		}
		
		iRandom = random_num(1, iTotalChance);
		
		for(i = 1; i <= g_MaxUsers; ++i) {
			if(userAlive && !g_IsAlive[i]) {
				continue;
			}
			
			iTeam = getUserTeam(i);
			
			if(iTeam != FM_CS_TEAM_T && iTeam != FM_CS_TEAM_CT) {
				continue;
			}
			
			iSum += iChance[i];
			
			if(iRandom <= iSum) {
				return i;
			}
		}
	} else {
		static j;
		static k[MAX_USERS];
		
		j = 0;
		
		for(i = 1; i <= g_MaxUsers; ++i) {
			if(userAlive && !g_IsAlive[i]) {
				continue;
			}
			
			iTeam = getUserTeam(i);
			
			if(iTeam != FM_CS_TEAM_T && iTeam != FM_CS_TEAM_CT) {
				continue;
			}
			
			k[j] = i;
			
			++j;
		}
		
		iRandom = random_num(0, (j - 1));
		
		return k[iRandom];
	}
	
	return -1;
}

public getUsersAlive() {
	static iUsers;
	static i;
	
	iUsers = 0;
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(!g_IsAlive[i]) {
			continue;
		}
		
		++iUsers;
	}
	
	return iUsers;
}

fixDeadAttrib(const id) {
	message_begin(MSG_BROADCAST, g_Message_ScoreAttrib);
	write_byte(id);
	write_byte(0);
	message_end();
}

sendDeathMsg(const attacker, const victim) {
	message_begin(MSG_BROADCAST, g_Message_DeathMsg);
	write_byte(attacker);
	write_byte(victim);
	write_byte(1);
	write_string("infection");
	message_end();
	
	set_user_frags(attacker, get_user_frags(attacker) + 1);
	set_pdata_int(victim, OFFSET_CSDEATHS, cs_get_user_deaths(victim) + 1, OFFSET_LINUX);
	
	message_begin(MSG_BROADCAST, g_Message_ScoreInfo);
	write_byte(attacker);
	write_short(get_user_frags(attacker));
	write_short(cs_get_user_deaths(attacker));
	write_short(0);
	write_short(getUserTeam(attacker));
	message_end();
	
	message_begin(MSG_BROADCAST, g_Message_ScoreInfo);
	write_byte(victim);
	write_short(get_user_frags(victim));
	write_short(cs_get_user_deaths(victim));
	write_short(0);
	write_short(getUserTeam(victim));
	message_end();
}

public menu__CSBuy() {
	return PLUGIN_HANDLED;
}

public clcmd__Mode(const id) {
	if(!g_Kiske[id]) {
		return PLUGIN_HANDLED;
	}
	
	// if(!(get_user_flags(id) & ADMIN_BAN)) {
		// return PLUGIN_HANDLED;
	// }
	
	new sMode[20];	
	read_argv(0, sMode, 19);
	
	new iMode;
	
	if(sMode[3] == 'z' && sMode[4] == 'o') { // zombie
		iMode = MODE_INFECTION;
	} else if(sMode[3] == 's' && sMode[4] == 'w') { // swarm
		iMode = MODE_SWARM;
	} else if(sMode[3] == 'm' && sMode[4] == 'u') { // multi
		iMode = MODE_MULTI;
	} else if(sMode[3] == 'p' && sMode[4] == 'l') { // plague
		iMode = MODE_PLAGUE;
	} else if(sMode[3] == 's' && sMode[4] == 'u') { // survivor
		iMode = MODE_SURVIVOR;
	} else if(sMode[3] == 'n' && sMode[4] == 'e') { // nemesis
		iMode = MODE_NEMESIS;
	} else if(sMode[3] == 'w' && sMode[4] == 'e') { // wesker
		iMode = MODE_WESKER;
	} else if(sMode[3] == 'j' && sMode[4] == 'a') { // jason
		iMode = MODE_JASON;
	} else if(sMode[3] == 'a' && sMode[4] == 'r') { // armageddon
		iMode = MODE_ARMAGEDDON;
	} else if(sMode[3] == 'm' && sMode[4] == 'e') { // meganemesis
		iMode = MODE_MEGA_NEMESIS;
	} else if(sMode[3] == 't' && sMode[4] == 'r') { // troll
		iMode = MODE_TROLL;
	} else if(sMode[3] == 'p' && sMode[4] == 'a') { // paranoia
		iMode = MODE_PARANOIA;
	} else if(sMode[3] == 'c' && sMode[4] == 'o') { // coop
		iMode = MODE_COOP;
	} else if(sMode[3] == 'a' && sMode[4] == 's') { // assassin
		iMode = MODE_ASSASSIN;
	} else if(sMode[3] == 'a' && sMode[4] == 'l') { // alvspred
		iMode = MODE_ALVSPRED;
	} else if(sMode[3] == 'b' && sMode[4] == 'o') { // bomber
		iMode = MODE_BOMBER;
	} else if(sMode[3] == 'd' && sMode[4] == 'u') { // duelo
		iMode = MODE_DUELO_FINAL;
	}
	
	// new iUsers;
	// iUsers = getUsersAlive();
	
	// new Float:flGameTime;
	// flGameTime = get_gametime();
	
	if(g_Kiske[id]) {
		// if((i == MODE_MULTI && iUsers < 10) || (i == MODE_PLAGUE && iUsers < 15) || (i == MODE_SURVIVOR && iUsers < 10) || (i == MODE_NEMESIS && iUsers < 10) || (i == MODE_WESKER && iUsers < 12) ||
		// (i == MODE_TROLL && iUsers < 12) || (i == MODE_JASON && iUsers < 12) || (i == MODE_ASSASSIN && iUsers < 12) || (i == MODE_MEGA_NEMESIS && iUsers < 15)) {
			// client_print(id, print_console, "[ZP] Se necesitan más usuarios para comenzar el modo indicado!");
			// return PLUGIN_HANDLED;
		// }
		
		// g_LastMode_CD = flGameTime + 480.0;
		
		switch(iMode) {
			case MODE_INFECTION, MODE_SURVIVOR, MODE_NEMESIS, MODE_WESKER, MODE_JASON, MODE_MEGA_NEMESIS, MODE_TROLL, MODE_ASSASSIN: {
				new sTarget[32];
				read_argv(1, sTarget, 31);
				
				if(!sTarget[0]) {
					if(task_exists(TASK_MAKE_MODE)) {
						setMode(0, iMode);
					}
				} else {
					new iTarget = cmd_target(id, sTarget, CMDTARGET_ALLOW_SELF);
					
					if(iTarget) {
						if(task_exists(TASK_MAKE_MODE)) {
							setMode(iTarget, iMode);
						} else {
							if(iMode == MODE_INFECTION) {
								zombieMe(iTarget);
							} else if(iMode == MODE_SURVIVOR) {
								humanMe(iTarget, .survivor=1);
							} else if(iMode == MODE_NEMESIS) {
								zombieMe(iTarget, .nemesis=1);
							} else if(iMode == MODE_WESKER) {
								humanMe(iTarget, .wesker=1);
							} else if(iMode == MODE_JASON) {
								humanMe(iTarget, .jason=1);
							} else if(iMode == MODE_MEGA_NEMESIS) {
								zombieMe(iTarget, .megaNemesis=1);
							} else if(iMode == MODE_TROLL) {
								zombieMe(iTarget, .troll=1);
							} else if(iMode == MODE_ASSASSIN) {
								zombieMe(iTarget, .assassin=1);
							}
						}
					}
				}
			} default: {
				if(task_exists(TASK_MAKE_MODE)) {
					setMode(0, iMode);
				}
			}
		}
	}
	
	return PLUGIN_HANDLED;
}

public checkAchievements_ItemsExtras(const id, const iItemId) {
	g_HatDevil[id] = 1;
	
	++g_ItemExtra_Count[id][iItemId];
	
	new iSum;
	new i;
	
	if(iItemId != EXTRA_LONGJUMP_H && iItemId != EXTRA_LONGJUMP_Z) {
		switch(g_ItemExtra_Count[id][iItemId]) {
			case 10: {
				setAchievement(id, VISION_NOCTURNA_x10 + iItemId);
			} case 50: {
				setAchievement(id, VISION_NOCTURNA_x50 + iItemId);
			} case 100: {
				setAchievement(id, VISION_NOCTURNA_x100 + iItemId);
			}
		}
	} else {
		iSum = g_ItemExtra_Count[id][EXTRA_LONGJUMP_H] + g_ItemExtra_Count[id][EXTRA_LONGJUMP_Z];
		
		switch(iSum) {
			case 10: {
				setAchievement(id, LONG_JUMP_x10);
			} case 50: {
				setAchievement(id, LONG_JUMP_x50);
			} case 100: {
				setAchievement(id, LONG_JUMP_x100);
			}
		}
	}
	
	new iMenor;
	
	iSum = 0;
	iMenor = g_ItemExtra_Count[id][0];
	
	for(i = 1; i < extraItemsId; ++i) {
		if(g_ItemExtra_Count[id][i] < iMenor) {
			iMenor = g_ItemExtra_Count[id][i];
		}
	}
	
	switch(iMenor) {
		case 10: {
			setAchievement(id, ITEMS_EXTRAS_x10);
			giveHat(id, HAT_JAMIE);
		} case 50: {
			setAchievement(id, ITEMS_EXTRAS_x50);
			giveHat(id, HAT_GAARA);
		} case 100: {
			setAchievement(id, ITEMS_EXTRAS_x100);
		} case 500: {
			setAchievement(id, ITEMS_EXTRAS_x500);
		} case 1000: {
			setAchievement(id, ITEMS_EXTRAS_x1000);
		} case 5000: {
			setAchievement(id, ITEMS_EXTRAS_x5000);
		} 
	}
}

public getUsersPlaying() {
	new iPlaying = 0;
	new i;
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(!g_IsConnected[i]) {
			continue;
		}
		
		++iPlaying;
	}
	
	return iPlaying;
}

checkRound(const leavingId) {
	if(g_EndRound || task_exists(TASK_MAKE_MODE)) {
		return;
	}
	
	static iUsersNum;
	static iId;
	
	iUsersNum = getUsersAlive();
	
	switch(g_Mode) {
		case MODE_ALVSPRED: {
			if(g_Alien[leavingId]) {
				if(getZombies() > 1) {
					while((iId = getRandomUser(.userAlive=1, .withChance=1)) == leavingId || !g_Zombie[iId]) { }
					
					colorChat(0, _, "%sEl ALIEN se ha desconectado, !g%s!y es el nuevo ALIEN", ZP_PREFIX, g_UserName[iId]);
					zombieMe(iId, .alien=1);
					
					g_Alien_Power[iId] = g_Alien_Power[leavingId];
					
					set_user_health(iId, g_Health[leavingId]);
					
					return;
				}
				
				giveReward_AlienVsPred();
				
				return;
			} else if(g_Predator[leavingId]) {
				if(getHumans() > 1) {
					while((iId = getRandomUser(.userAlive=1, .withChance=1)) == leavingId || g_Zombie[iId]) { }
					
					colorChat(0, _, "%sEl DEPREDADOR se ha desconectado, !g%s!y es el nuevo DEPREDADOR", ZP_PREFIX, g_UserName[iId]);
					humanMe(iId, .predator=1);
					
					g_Predator_Power[iId] = g_Predator_Power[leavingId];
					
					remove_task(iId + TASK_PREDATOR_POWER);
					
					set_user_health(iId, g_Health[leavingId]);
					
					return;
				}
				
				giveReward_AlienVsPred();
				
				return;
			}
		} case MODE_DUELO_FINAL: {
			if(getHumans() == 2) {
				
			}
		} case MODE_PARANOIA, MODE_COOP: {
			if((getHumans() == 1 || getZombies() == 1)) {
				if(g_Mode == MODE_PARANOIA) {
					
				} else {
					
				}
			}
		}
	}
	
	if(iUsersNum < 3) {
		if(g_Mode == MODE_INFECTION || g_Mode == MODE_SWARM || g_Mode == MODE_MULTI || g_Mode == MODE_PLAGUE || g_Mode == MODE_ARMAGEDDON) {
			return;
		}
		
		g_EndRound_Forced = 1;
		
		return;
	}
	
	if(g_Zombie[leavingId] && getZombies() == 1) {
		if(getHumans() == 1 && getCTs() == 1) {
			return;
		}
		
		while((iId = getRandomUser(.userAlive=1, .withChance=1)) == leavingId) { }
		
		switch(g_SpecialMode[leavingId]) {
			case MODE_NEMESIS: {
				colorChat(0, _, "%sEl NEMESIS se ha desconectado, !g%s!y es el nuevo NEMESIS", ZP_PREFIX, g_UserName[iId]);
				zombieMe(iId, .nemesis=1);
				
				if(!g_Bazooka[leavingId]) {
					g_Bazooka[iId] = 0;
					
					strip_user_weapons(iId);
					give_item(iId, "weapon_knife");
				}
				
				set_user_health(iId, g_Health[leavingId]);
			} case MODE_TROLL: {
				colorChat(0, _, "%sEl TROLL se ha desconectado, !g%s!y es el nuevo TROLL", ZP_PREFIX, g_UserName[iId]);
				zombieMe(iId, .troll=1);
				
				g_Troll_Power[iId] = g_Troll_Power[leavingId];
				
				remove_task(iId + TASK_TROLL_POWER);
				
				set_user_health(iId, g_Health[leavingId]);
			} case MODE_MEGA_NEMESIS: {
				
			} case MODE_ASSASSIN: {
				
			} default: {
				colorChat(0, _, "%sEl último zombie se ha desconectado, !g%s!y es el nuevo zombie", ZP_PREFIX, g_UserName[iId]);
				zombieMe(iId);
			}
		}
	} else if(!g_Zombie[leavingId] && getHumans() == 1) {
		if(getZombies() == 1 && getTs() == 1) {
			return;
		}
		
		while ((iId = getRandomUser(.userAlive=1, .withChance=1)) == leavingId) { }
		
		switch(g_SpecialMode[leavingId]) {
			case MODE_SURVIVOR: {
				colorChat(0, _, "%sEl SURVIVOR se ha desconectado, !g%s!y es el nuevo SURVIVOR", ZP_PREFIX, g_UserName[iId]);
				humanMe(iId, .survivor=1);
				
				if(!g_Annihilation_Bomb[leavingId]) {
					hamStripWeapons(iId, "weapon_hegrenade");
				}
				
				set_user_health(iId, g_Health[leavingId]);
			} case MODE_WESKER: {
				colorChat(0, _, "%sEl WESKER se ha desconectado, !g%s!y es el nuevo WESKER", ZP_PREFIX, g_UserName[iId]);
				humanMe(iId, .wesker=1);
				
				g_Wesker_LASER[iId] = g_Wesker_LASER[leavingId];
				
				set_user_health(iId, g_Health[leavingId]);
			} case MODE_JASON: {
				colorChat(0, _, "%sEl JASON se ha desconectado, !g%s!y es el nuevo JASON", ZP_PREFIX, g_UserName[iId]);
				humanMe(iId, .jason=1);
				
				if(g_Hab[iId][CLASS_JASON][HAB_J_TELEPORT]) {
					g_Jason_Teleport[iId] = g_Jason_Teleport[leavingId];
				}
				
				set_user_health(iId, g_Health[leavingId]);
			} default: {
				colorChat(0, _, "%sEl último humano se ha desconectado, !g%s!y es el nuevo humano", ZP_PREFIX, g_UserName[iId]);
				humanMe(iId);
			}
		}
	}
}

stock hamStripWeapons(const id, const weapon[]) {
	if(!equal(weapon, "weapon_", 7)) {
		return 0;
	}
	
	static iWeaponId;
	iWeaponId = get_weaponid(weapon);
	
	if(!iWeaponId) {
		return 0;
	}
	
	static iWeaponEnt;
	iWeaponEnt = -1;
	
	while((iWeaponEnt = engfunc(EngFunc_FindEntityByString, iWeaponEnt, "classname", weapon)) && entity_get_edict(iWeaponEnt, EV_ENT_owner) != id) { }
	
	if(!iWeaponEnt) {
		return 0;
	}
	
	if(g_CurrentWeapon[id] == iWeaponId) {
		ExecuteHamB(Ham_Weapon_RetireWeapon, iWeaponEnt);
	}
	
	if(!ExecuteHamB(Ham_RemovePlayerItem, id, iWeaponEnt)) {
		return 0;
	}
	
	ExecuteHamB(Ham_Item_Kill, iWeaponEnt);
	
	entity_set_int(id, EV_INT_weapons, entity_get_int(id, EV_INT_weapons) & ~(1 << iWeaponId));
	
	return 1;
}

public fw_UpdateClientData_Post(const id, const sendweapons, const handle) {
	if(!g_IsAlive[id]) {
		return FMRES_IGNORED;
	}
	
	if(g_SpecialMode[id] == MODE_NEMESIS && g_CurrentWeapon[id] == CSW_AK47) {
		set_cd(handle, CD_flNextAttack, get_gametime() + 0.001);
	}
	
	return FMRES_HANDLED;
}

bazooka__Fire(const id) {
	--g_Bazooka[id];
	
	if(!g_Bazooka[id]) {
		hamStripWeapons(id, "weapon_ak47");
	}
	
	entity_set_vector(id, EV_FLARE_COLOR, Float:{-10.5, 0.0, 0.0});
	
	setAnimation(id, .animation=8);
	
	new Float:vecOrigin[3];
	new Float:vecAngles[3];
	new Float:vecVelocity[3];
	new Float:vecViewOffset[3];
	new Float:vecColor[3];
	
	entity_get_vector(id, EV_VEC_view_ofs, vecViewOffset);
	entity_get_vector(id, EV_VEC_origin, vecOrigin);
	
	vecOrigin[0] += vecViewOffset[0];
	vecOrigin[1] += vecViewOffset[1];
	vecOrigin[2] += vecViewOffset[2];
	
	new iEnt = create_entity("info_target");
	
	if(!is_valid_ent(iEnt)) {
		return;
	}
	
	entity_set_string(iEnt, EV_SZ_classname, g_CLASSNAME_BAZOOKA);
	entity_set_model(iEnt, g_MODEL_Rocket);
	
	entity_set_size(iEnt, Float:{-1.0, -1.0, -1.0}, Float:{1.0, 1.0, 1.0});
	entity_set_vector(iEnt, EV_VEC_mins, Float:{-1.0, -1.0, -1.0});
	entity_set_vector(iEnt, EV_VEC_maxs, Float:{1.0, 1.0, 1.0});
	
	entity_set_origin(iEnt, vecOrigin);
	
	entity_set_int(iEnt, EV_INT_solid, SOLID_BBOX);
	entity_set_int(iEnt, EV_INT_movetype, MOVETYPE_FLY);
	entity_set_edict(iEnt, EV_ENT_owner, id);
	
	emit_sound(iEnt, CHAN_WEAPON, g_SOUND_Bazooka[0], 1.0, ATTN_NORM, 0, PITCH_NORM);
	
	velocity_by_aim(id, 1750, vecVelocity);
	entity_set_vector(iEnt, EV_VEC_velocity, vecVelocity);
	
	vector_to_angle(vecVelocity, vecAngles);
	
	entity_set_vector(iEnt, EV_VEC_angles, vecAngles);
	
	entity_set_int(iEnt, EV_INT_renderfx, kRenderFxGlowShell);
	
	vecColor[0] = float(g_Options_Color[id][COLOR_BAZOOKA][__R]);
	vecColor[1] = float(g_Options_Color[id][COLOR_BAZOOKA][__G]);
	vecColor[2] = float(g_Options_Color[id][COLOR_BAZOOKA][__B]);
	
	entity_set_vector(iEnt, EV_VEC_rendercolor, vecColor);
	entity_set_int(iEnt, EV_INT_rendermode, kRenderNormal);
	entity_set_float(iEnt, EV_FL_renderamt, 4.0);
	
	entity_set_edict(iEnt, EV_ENT_FLARE, bazooka__CreateFlare(iEnt, id));
	
	entity_set_int(iEnt, EV_INT_effects, entity_get_int(iEnt, EV_INT_effects) | EF_BRIGHTLIGHT);
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_BEAMFOLLOW);
	write_short(iEnt);
	write_short(g_SPRITE_Trail);
	write_byte(50);
	write_byte(3);
	write_byte(g_Options_Color[id][COLOR_BAZOOKA][__R]);
	write_byte(g_Options_Color[id][COLOR_BAZOOKA][__G]);
	write_byte(g_Options_Color[id][COLOR_BAZOOKA][__B]);
	write_byte(200);
	message_end();
	
	g_Bazooka_InAir = 1;
}

bazooka__CreateFlare(const rocket, const id) {
	new iEnt = create_entity("env_sprite");
	
	if(!is_valid_ent(iEnt)) {
		return 0;
	}
	
	new Float:vecColor[3];
	
	entity_set_model(iEnt, "sprites/animglow01.spr");
	
	entity_set_float(iEnt, EV_FL_scale, 0.4);
	entity_set_int(iEnt, EV_INT_spawnflags, SF_SPRITE_STARTON);
	entity_set_int(iEnt, EV_INT_solid, SOLID_NOT);
	entity_set_int(iEnt, EV_INT_movetype, MOVETYPE_FOLLOW);
	entity_set_edict(iEnt, EV_ENT_aiment, rocket);
	entity_set_edict(iEnt, EV_ENT_owner, rocket);
	entity_set_float(iEnt, EV_FL_framerate, 25.0);
	
	entity_set_int(iEnt, EV_INT_renderfx, kRenderFxNone);
	
	vecColor[0] = float(g_Options_Color[id][COLOR_BAZOOKA][__R]);
	vecColor[1] = float(g_Options_Color[id][COLOR_BAZOOKA][__G]);
	vecColor[2] = float(g_Options_Color[id][COLOR_BAZOOKA][__B]);
	
	entity_set_vector(iEnt, EV_VEC_rendercolor, vecColor);
	entity_set_int(iEnt, EV_INT_rendermode, kRenderTransAdd);
	entity_set_float(iEnt, EV_FL_renderamt, 255.0);
	
	DispatchSpawn(iEnt);

	return iEnt;
}

bazooka__RemoveRocket(const rocket) {
	if(is_valid_ent(rocket)) {
		new iEnt = entity_get_edict(rocket, EV_ENT_FLARE);
		
		if(is_valid_ent(iEnt)) {
			remove_entity(iEnt);
		}
		
		remove_entity(rocket);
	}
}

public touch__BazookaAll(const rocket, const ent) {
	if(is_valid_ent(rocket)) {
		new iAttacker;
		iAttacker = entity_get_edict(rocket, EV_ENT_owner);
		
		if(!g_IsConnected[iAttacker]) {
			bazooka__RemoveRocket(rocket);
			
			g_Bazooka_InAir = 0;
			
			return;
		}
		
		new iVictim;
		new Float:vecOrigin[3];
		new iCountVictims;
		
		entity_get_vector(rocket, EV_VEC_origin, vecOrigin);
		
		iVictim = -1;
		iCountVictims = 0;
		
		engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, vecOrigin, 0);
		write_byte(TE_EXPLOSION);
		engfunc(EngFunc_WriteCoord, vecOrigin[0]);
		engfunc(EngFunc_WriteCoord, vecOrigin[1]);
		engfunc(EngFunc_WriteCoord, vecOrigin[2]);
		write_short(g_SPRITE_Explosion);
		write_byte(90);
		write_byte(10);
		write_byte(TE_EXPLFLAG_NOSOUND | TE_EXPLFLAG_NODLIGHTS);
		message_end();
		
		engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, vecOrigin, 0);
		write_byte(TE_WORLDDECAL);
		engfunc(EngFunc_WriteCoord, vecOrigin[0]);
		engfunc(EngFunc_WriteCoord, vecOrigin[1]);
		engfunc(EngFunc_WriteCoord, vecOrigin[2]);
		write_byte(random_num(46, 48));
		message_end();
		
		engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, vecOrigin, 0);
		write_byte(TE_WORLDDECAL);
		engfunc(EngFunc_WriteCoord, vecOrigin[0] + 90.0);
		engfunc(EngFunc_WriteCoord, vecOrigin[1]);
		engfunc(EngFunc_WriteCoord, vecOrigin[2]);
		write_byte(random_num(46, 48));
		message_end();
		
		engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, vecOrigin, 0);
		write_byte(TE_DLIGHT);
		engfunc(EngFunc_WriteCoord, vecOrigin[0]);
		engfunc(EngFunc_WriteCoord, vecOrigin[1]);
		engfunc(EngFunc_WriteCoord, vecOrigin[2]);
		write_byte(150);
		write_byte(g_Options_Color[iAttacker][COLOR_BAZOOKA][__R]);
		write_byte(g_Options_Color[iAttacker][COLOR_BAZOOKA][__G]);
		write_byte(g_Options_Color[iAttacker][COLOR_BAZOOKA][__B]);
		write_byte(150);
		write_byte(15);
		message_end();
		
		client_cmd(0, "stopsound");
		client_cmd(0, "spk ^"%s^"", g_SOUND_Bazooka[1]);
		
		while((iVictim = find_ent_in_sphere(iVictim, vecOrigin, 600.0)) != 0) {
			if(!is_user_valid(iVictim)) {
				continue;
			}
			
			if(!g_IsAlive[iVictim]) {
				continue;
			}
			
			if(g_SpecialMode[iVictim]) {
				continue;
			}
			
			ExecuteHamB(Ham_Killed, iVictim, iAttacker, 2);
			
			++iCountVictims;
		}
		
		if(iCountVictims >= 20) {
			setAchievement(iAttacker, LA_EXPLOSION_SI_MATA);
		} else if(!iCountVictims) {
			setAchievement(iAttacker, LA_EXPLOSION_NO_MATA);
		}
		
		bazooka__RemoveRocket(rocket);
		
		g_Bazooka_InAir = 0;
		
		new i;
		for(i = 0; i <= g_MaxUsers; ++i) {
			if(!g_IsConnected[i]) {
				continue;
			}
			
			message_begin(MSG_ONE_UNRELIABLE, g_Message_ScreenFade, _, i);
			write_short(UNIT_SECOND * 5);
			write_short(UNIT_SECOND * 5);
			write_short(FFADE_IN);
			write_byte(g_Options_Color[iAttacker][COLOR_BAZOOKA][__R]);
			write_byte(g_Options_Color[iAttacker][COLOR_BAZOOKA][__G]);
			write_byte(g_Options_Color[iAttacker][COLOR_BAZOOKA][__B]);
			write_byte(200);
			message_end();
			
			message_begin(MSG_ONE_UNRELIABLE, g_Message_ScreenShake, _, i);
			write_short(UNIT_SECOND * 28);
			write_short(UNIT_SECOND * 28);
			write_short(UNIT_SECOND * 28);
			message_end();
		}
	}
}

wesker__FireLASER(const id) {
	g_Wesker_LastLASER[id] = get_gametime() + 0.75;
	
	--g_Wesker_LASER[id];
	
	emit_sound(id, CHAN_VOICE, g_SOUND_Electro, 1.0, ATTN_NORM, 0, PITCH_NORM);
	
	entity_set_vector(id, EV_FLARE_COLOR, Float:{-1.0, 0.0, 0.0});
	
	setAnimation(id, .animation=1);
	
	new iCheck;
	new i;
	
	for(i = 0; i < 8; ++i) {
		if(g_Options_Color[id][COLOR_LASER][__R] == __COLOR[i][colorRed] && g_Options_Color[id][COLOR_LASER][__G] == __COLOR[i][colorGreen] && g_Options_Color[id][COLOR_LASER][__B] == __COLOR[i][colorBlue]) {
			iCheck = i;
			break;
		}
	}
	
	if(g_Hab[id][CLASS_WESKER][HAB_W_SUPER_LASER]) {
		new Float:vecOrigin[3];
		new Float:vecPoint[3];
		new Float:vecViewOffset[3];
		new Float:vecStart[3];
		new Float:vecDest[3];
		new const iTrace = 0;
		new iTraceHit;
		new iEnt;
		new j = 0;
		
		entity_get_vector(id, EV_VEC_origin, vecOrigin);
		entity_get_vector(id, EV_VEC_view_ofs, vecViewOffset);
		
		vecOrigin[0] += vecViewOffset[0];
		vecOrigin[1] += vecViewOffset[1];
		vecOrigin[2] += vecViewOffset[2];
		
		entity_get_vector(id, EV_VEC_origin, vecStart);
		
		vecStart[0] += vecViewOffset[0];
		vecStart[1] += vecViewOffset[1];
		vecStart[2] += vecViewOffset[2];

		entity_get_vector(id, EV_VEC_v_angle, vecDest);
		engfunc(EngFunc_MakeVectors, vecDest);
		global_get(glb_v_forward, vecDest);
		
		vecDest[0] *= 9999.0;
		vecDest[1] *= 9999.0;
		vecDest[2] *= 9999.0;
		
		vecDest[0] += vecStart[0];
		vecDest[1] += vecStart[1];
		vecDest[2] += vecStart[2];

		engfunc(EngFunc_TraceLine, vecStart, vecDest, 0, id, 0);
		get_tr2(0, TR_vecEndPos, vecViewOffset);
		
		vecViewOffset[0] -= vecOrigin[0];
		vecViewOffset[1] -= vecOrigin[1];
		vecViewOffset[2] -= vecOrigin[2];
		
		vecViewOffset[0] *= 10.0;
		vecViewOffset[1] *= 10.0;
		vecViewOffset[2] *= 10.0;
		
		vecViewOffset[0] += vecOrigin[0];
		vecViewOffset[1] += vecOrigin[1];
		vecViewOffset[2] += vecOrigin[2];
		
		iEnt = id;
		i = 0;
		
		while(engfunc(EngFunc_TraceLine, vecOrigin, vecViewOffset, 0, iEnt, iTrace)) {
			++j;
			
			iTraceHit = get_tr2(iTrace, TR_pHit);
			
			if(j == 100) {
				break;
			}
			
			if(is_user_valid_alive(iTraceHit)) {
				if(g_Zombie[iTraceHit]) {
					if(!g_SpecialMode[iTraceHit]) {
						ExecuteHamB(Ham_Killed, iTraceHit, id, 2);
						
						setAchievement(id, VOS_NO_PASAS);
						
						i = 1;
					}
				}
			}
			
			iEnt = iTraceHit;
			get_tr2(iTrace, TR_vecEndPos, vecOrigin);
		}
		
		get_tr2(iTrace, TR_vecEndPos, vecPoint);
		
		free_tr2(iTrace);
		
		if(!i) {
			++g_Wesker_LASER_Waste[id];
			
			if(g_Wesker_LASER_Waste[id] == 3) {
				setAchievement(id, NO_ME_HACE_FALTA);
			}
		}
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
		write_byte(TE_BEAMENTPOINT);
		write_short(id | 0x1000);
		engfunc(EngFunc_WriteCoord, vecPoint[0]);
		engfunc(EngFunc_WriteCoord, vecPoint[1]);
		engfunc(EngFunc_WriteCoord, vecPoint[2]);
		write_short(g_SPRITE_Beam);
		write_byte(1);
		write_byte((1 / 100));
		write_byte(5);
		write_byte(3);
		write_byte(0);
		write_byte(g_Options_Color[id][COLOR_LASER][__R]);
		write_byte(g_Options_Color[id][COLOR_LASER][__G]);
		write_byte(g_Options_Color[id][COLOR_LASER][__B]);
		write_byte(255);
		write_byte(25);
		message_end();
		
		engfunc(EngFunc_MessageBegin, MSG_BROADCAST, SVC_TEMPENTITY, vecPoint, 0);
		write_byte(TE_DLIGHT);
		engfunc(EngFunc_WriteCoord, vecPoint[0]);
		engfunc(EngFunc_WriteCoord, vecPoint[1]);
		engfunc(EngFunc_WriteCoord, vecPoint[2]);
		write_byte(30);
		write_byte(g_Options_Color[id][COLOR_LASER][__R]);
		write_byte(g_Options_Color[id][COLOR_LASER][__G]);
		write_byte(g_Options_Color[id][COLOR_LASER][__B]);
		write_byte(15);
		write_byte(50);
		message_end();
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
		write_byte(TE_SPRITETRAIL);
		engfunc(EngFunc_WriteCoord, vecPoint[0]);
		engfunc(EngFunc_WriteCoord, vecPoint[1]);
		engfunc(EngFunc_WriteCoord, vecPoint[2] - 20.0);
		engfunc(EngFunc_WriteCoord, vecPoint[0]);
		engfunc(EngFunc_WriteCoord, vecPoint[1]);
		engfunc(EngFunc_WriteCoord, vecPoint[2] + 20.0);
		write_short(g_SPRITE_ColorBall[iCheck]);
		write_byte(200);
		write_byte(2);
		write_byte(5);
		write_byte(150);
		write_byte(255);
		message_end();
		
		return;
	}
	
	new iTarget;
	new iBody;
	new iAimOrigin[3];
	
	get_user_origin(id, iAimOrigin, 3);
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_BEAMENTPOINT);
	write_short(id | 0x1000);
	write_coord(iAimOrigin[0]);
	write_coord(iAimOrigin[1]);
	write_coord(iAimOrigin[2]);
	write_short(g_SPRITE_Beam);
	write_byte(1);
	write_byte((1 / 100));
	write_byte(5);
	write_byte(3);
	write_byte(0);
	write_byte(g_Options_Color[id][COLOR_LASER][__R]);
	write_byte(g_Options_Color[id][COLOR_LASER][__G]);
	write_byte(g_Options_Color[id][COLOR_LASER][__B]);
	write_byte(255);
	write_byte(25);
	message_end();
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY, iAimOrigin);
	write_byte(TE_DLIGHT);
	write_coord(iAimOrigin[0]);
	write_coord(iAimOrigin[1]);
	write_coord(iAimOrigin[2]);
	write_byte(30);
	write_byte(g_Options_Color[id][COLOR_LASER][__R]);
	write_byte(g_Options_Color[id][COLOR_LASER][__G]);
	write_byte(g_Options_Color[id][COLOR_LASER][__B]);
	write_byte(15);
	write_byte(50);
	message_end();
	
	get_user_aiming(id, iTarget, iBody);
	if(is_user_valid_alive(iTarget) && g_Zombie[iTarget]) {
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
		write_byte(TE_SPRITETRAIL);
		write_coord(iAimOrigin[0]);
		write_coord(iAimOrigin[1]);
		write_coord(iAimOrigin[2] - 20);
		write_coord(iAimOrigin[0]);
		write_coord(iAimOrigin[1]);
		write_coord(iAimOrigin[2] + 20);
		write_short(g_SPRITE_ColorBall[iCheck]);
		write_byte(200);
		write_byte(2);
		write_byte(5);
		write_byte(150);
		write_byte(255);
		message_end();
		
		if(g_SpecialMode[iTarget]) {
			client_print(id, print_center, "¡ ES INMUNE !");
		} else {
			ExecuteHamB(Ham_Killed, iTarget, id, 2);
			
			setAchievement(id, VOS_NO_PASAS);
		}
	} else {
		++g_Wesker_LASER_Waste[id];
		
		if(g_Wesker_LASER_Waste[id] == 3) {
			setAchievement(id, NO_ME_HACE_FALTA);
		}
	}
}

public clcmd__Drop(const id) {
	if(!g_IsConnected[id]) {
		return PLUGIN_HANDLED;
	}
	
	if(g_IsAlive[id]) {
		if(g_SpecialMode[id]) {
			switch(g_SpecialMode[id]) {
				case MODE_JASON: {
					if(g_Jason_Teleport[id]) {
						--g_Jason_Teleport[id];
						
						dllfunc(DLLFunc_Spawn, id);
					}
				} case MODE_TROLL: {
					if(g_Troll_Power[id]) {
						--g_Troll_Power[id];
						
						set_user_gravity(id, 0.7);
						g_Speed[id] = 350.0;
						
						ExecuteHamB(Ham_Player_ResetMaxSpeed, id);
						
						set_task(15.0, "task__TrollPower_End", id + TASK_TROLL_POWER);
						
						new Float:vecOrigin[3];
						new Float:vecVictimOrigin[3];
						new i;
						
						entity_get_vector(id, EV_VEC_origin, vecOrigin);
						
						for(i = 1; i <= g_MaxUsers; ++i) {
							if(g_IsAlive[i] && !g_Zombie[i]) {
								entity_get_vector(i, EV_VEC_origin, vecVictimOrigin);
								
								if(get_distance_f(vecVictimOrigin, vecOrigin) <= 700.0) {
									message_begin(MSG_ONE_UNRELIABLE, g_Message_ScreenShake, _, i);
									write_short(UNIT_SECOND * 14);
									write_short(UNIT_SECOND * 14);
									write_short(UNIT_SECOND * 14);
									message_end();
									
									set_user_gravity(i, 1.25);
									g_Speed[i] = 50.0;
									
									ExecuteHamB(Ham_Player_ResetMaxSpeed, i);
								}
							}
						}
						
						engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, vecOrigin, 0);
						write_byte(TE_BEAMCYLINDER);
						engfunc(EngFunc_WriteCoord, vecOrigin[0]);
						engfunc(EngFunc_WriteCoord, vecOrigin[1] + 25.0);
						engfunc(EngFunc_WriteCoord, vecOrigin[2] + 25.0);
						engfunc(EngFunc_WriteCoord, vecOrigin[0]);
						engfunc(EngFunc_WriteCoord, vecOrigin[1] + 50.0);
						engfunc(EngFunc_WriteCoord, vecOrigin[2] + 1000.0);
						write_short(g_SPRITE_Shockwave);
						write_byte(0);
						write_byte(0);
						write_byte(15);
						write_byte(60);
						write_byte(0);
						write_byte(255);
						write_byte(128);
						write_byte(50);
						write_byte(255);
						write_byte(0);
						message_end();
						
						engfunc(EngFunc_MessageBegin, MSG_BROADCAST, SVC_TEMPENTITY, vecOrigin, 0);
						write_byte(TE_DLIGHT);
						engfunc(EngFunc_WriteCoord, vecOrigin[0]);
						engfunc(EngFunc_WriteCoord, vecOrigin[1]);
						engfunc(EngFunc_WriteCoord, vecOrigin[2]);
						write_byte(100);
						write_byte(255);
						write_byte(128);
						write_byte(50);
						write_byte(50);
						write_byte(60);
						message_end();
					}
				} case MODE_ALVSPRED: {
					if(g_Alien[id]) {
						if(g_Alien_Power[id]) {
							--g_Alien_Power[id];
							
							client_print(0, print_center, "¡El ALIEN desató un FRENESÍ DE LOCURA!");
							
							new i;
							for(i = 1; i <= g_MaxUsers; ++i) {
								if(!g_IsAlive[i]) {
									continue;
								}
								
								if(!g_Zombie[i]) {
									continue;
								}
								
								if(g_Frozen[i]) {
									continue;
								}
								
								g_Immunity[i] = 1;
								
								emit_sound(i, CHAN_BODY, g_SOUND_Zombie_Madness, 1.0, ATTN_NORM, 0, random_num(50, 200));
								
								remove_task(i + TASK_BLOOD);
								set_task(6.0, "task__MadnessOver", i + TASK_BLOOD);
							}
						}
					} else {
						if(g_Predator_Power[id]) {
							--g_Predator_Power[id];
							
							g_MaxHealth[id] = g_Health[id];
							
							g_Aura[id][auraOn] = 0;
							
							set_user_rendering(id);
							
							entity_set_int(id, EV_INT_rendermode, kRenderTransAlpha);
							entity_set_float(id, EV_FL_renderamt, 0.0);
							
							if(g_HatId[id]) {
								if(is_valid_ent(g_HatEnt[id])) {
									entity_set_int(g_HatEnt[id], EV_INT_rendermode, kRenderTransAlpha);
									entity_set_float(g_HatEnt[id], EV_FL_renderamt, 0.0);
								}
							}
							
							client_print(0, print_center, "¡El DEPREDADOR se volvió invisible!");
							
							set_task(15.0, "task__PredatorPower_End", id + TASK_PREDATOR_POWER);
						}
					}
				}
			}
			
			return PLUGIN_HANDLED;
		}
	}
	
	if(!g_AccountPJ_Logged[id]) {
		return PLUGIN_HANDLED;
	}
	
	if(g_Link_AchievementId) {
		g_AchievementsIn[id] = g_Link_AchievementId;
		
		showMenu__Achievement_Desc(id, g_AchievementsIn[id]);
	}
	
	return PLUGIN_HANDLED;
}

public impulse__Flashlight(const id) {
	if(g_Zombie[id] || g_SpecialMode[id]) {
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_CONTINUE;
}

stock findEntByOwner(const owner, const className[]) {
	new id = -1;
	while((id = engfunc(EngFunc_FindEntityByString, id, "classname", className)) && entity_get_edict(id, EV_ENT_owner) != owner) {}
	
	return id;
}

public changeLights() {
	new i;
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(!g_IsConnected[i]) {
			continue;
		}
		
		setLight(i, g_Lights[0]);
	}
}

public task__TrollPower_End(const taskid) {
	if(g_SpecialMode[ID_TROLL_POWER] == MODE_TROLL) {
		set_user_gravity(ID_TROLL_POWER, 1.0);
		g_Speed[ID_TROLL_POWER] = 250.0;
		
		ExecuteHamB(Ham_Player_ResetMaxSpeed, ID_TROLL_POWER);
	}
}

public task__PredatorPower_End(const taskid) {
	if(g_Predator[ID_PREDATOR_POWER]) {
		g_Aura[ID_PREDATOR_POWER][auraOn] = 1;
		
		set_user_rendering(ID_PREDATOR_POWER, kRenderFxGlowShell, 255, 255, 0, kRenderNormal, 4);
		
		if(g_HatId[ID_PREDATOR_POWER]) {
			if(is_valid_ent(g_HatEnt[ID_PREDATOR_POWER])) {
				entity_set_int(g_HatEnt[ID_PREDATOR_POWER], EV_INT_rendermode, kRenderNormal);
				entity_set_float(g_HatEnt[ID_PREDATOR_POWER], EV_FL_renderamt, 255.0);
			}
		}
		
		if(g_MaxHealth[ID_PREDATOR_POWER] == g_Health[ID_PREDATOR_POWER]) {
			setAchievement(ID_PREDATOR_POWER, AHORA_ME_VES_AHORA_NO_ME_VES);
		}
	}
}

public giveReward_AlienVsPred() {
	new i;
	new iRandomPercent = random_num(5, 20);
	new iAmmoPacks;
	
	if(getZombies() > 1) {
		for(i = 1; i <= g_MaxUsers; ++i) {
			if(!g_IsAlive[i]) {
				continue;
			}
			
			if(!g_Zombie[i]) {
				ExecuteHamB(Ham_Killed, i, i, 2);
				continue;
			}
			
			iAmmoPacks = ((__APS_THIS_LEVEL(i) - __APS_THIS_LEVEL_REST1(i)) * iRandomPercent) / 100;
			
			colorChat(i, _, "%sGanaste !g%d ammo packs!y por ganar el modo", ZP_PREFIX, iAmmoPacks);
			
			addAmmopacks(i, iAmmoPacks);
		}
	} else {
		for(i = 1; i <= g_MaxUsers; ++i) {
			if(!g_IsAlive[i]) {
				continue;
			}
			
			if(g_Zombie[i]) {
				ExecuteHamB(Ham_Killed, i, i, 2);
				continue;
			}
			
			iAmmoPacks = ((__APS_THIS_LEVEL(i) - __APS_THIS_LEVEL_REST1(i)) * iRandomPercent) / 100;
			
			colorChat(i, _, "%sGanaste !g%d ammo packs!y por ganar el modo", ZP_PREFIX, iAmmoPacks);
			
			addAmmopacks(i, iAmmoPacks);
		}
	}
}

public task__Armageddon_Start() {
	set_dhudmessage(random_num(50, 255), random_num(50, 255), random_num(50, 255), -1.0, 0.4, 0, 0.0, 5.0, 3.0, 3.0);
	show_dhudmessage(0, "¡ ARMAGEDDON !");
	
	new i;
	new j = random_num(0, 1);
	
	for(i = 1; i <= g_MaxUsers; ++i) {
		if(!g_IsAlive[i]) {
			continue;
		}
		
		randomSpawn(i);
		
		message_begin(MSG_ONE_UNRELIABLE, g_Message_ScreenFade, _, i);
		write_short((UNIT_SECOND) * 2);
		write_short(0);
		write_short(FFADE_IN);
		write_byte(0);
		write_byte(0);
		write_byte(0);
		write_byte(255);
		message_end();
		
		if(j) {
			if(getUserTeam(i) == FM_CS_TEAM_T) {
				zombieMe(i, .nemesis = 1);
			} else {
				humanMe(i, .survivor = 1);
			}
		} else {
			if(getUserTeam(i) == FM_CS_TEAM_T) {
				humanMe(i, .survivor = 1);
			} else {
				zombieMe(i, .nemesis = 1);
			}
		}
	}
	
	client_cmd(0, "spk ^"%s^"", g_SOUND_Modes[random_num(0, charsmax(g_SOUND_Modes))]);
}

public task__Armageddon_Effect(const id) {
	if(g_IsAlive[id]) {
		message_begin(MSG_ONE_UNRELIABLE, g_Message_ScreenFade, _, id);
		write_short(UNIT_SECOND);
		write_short(0);
		write_short(FFADE_STAYOUT);
		write_byte(random_num(0, 255));
		write_byte(random_num(0, 255));
		write_byte(random_num(0, 255));
		write_byte(255);
		message_end();
	}
}

public task__Armageddon_BlackFade(const id) {
	if(g_IsAlive[id]) {
		message_begin(MSG_ONE_UNRELIABLE, g_Message_ScreenFade, _, id);
		write_short(UNIT_SECOND * 4);
		write_short(UNIT_SECOND * 3);
		write_short(FFADE_OUT);
		write_byte(0);
		write_byte(0);
		write_byte(0);
		write_byte(255);
		message_end();
	}
}

public updateComboNeeded(const id) {
	static Float:fMasteryMult;
	static Float:fNeed;
	
	fMasteryMult = 0.0;
	
	if(g_Mastery[id] == g_MasteryType) {
		fMasteryMult = 1.0;
	}
	
	fNeed = ((float(g_Reset[id]) * 300.0) + float(g_Level[id])) / (g_MultAps[id] + g_ExtraMultAps[id] + g_CAN_Aps + fMasteryMult + g_Legado_MultAps[id]);
	
	if(fNeed < 1.0) {
		fNeed = 1.0;
	}
	
	g_ComboNeedDamage[id] = floatround(fNeed);
	g_RealMultPoints[id] = g_MultPoints[id] + g_CAN_Points;
}

public alertMode(const modeId) {
	++g_Modes_Count[modeId];
	
	colorChat(0, _, "%sEl modo !g%s!y se jugó !g%d!y veces!", ZP_PREFIX, g_MODES_NAMES[modeId], g_Modes_Count[modeId]);
	
	if(g_Modes_Count[modeId] == 100 || g_Modes_Count[modeId] == 500 || g_Modes_Count[modeId] == 1000 || g_Modes_Count[modeId] == 2500 || g_Modes_Count[modeId] == 5000 || g_Modes_Count[modeId] == 7500 ||
	g_Modes_Count[modeId] == 10000 || g_Modes_Count[modeId] == 12500 || g_Modes_Count[modeId] == 15000 || g_Modes_Count[modeId] == 17500 || g_Modes_Count[modeId] == 20000 || g_Modes_Count[modeId] == 50000 ||
	g_Modes_Count[modeId] == 100000) {
		new iPoints = 15;
		
		if(g_Modes_Count[modeId] == 100000) {
			iPoints = 100;
		}
		
		colorChat(0, _, "%sTodos los usuarios conectados ganaron !g%d pHZ!y", ZP_PREFIX, iPoints);
		
		new i;
		for(i = 1; i <= g_MaxUsers; i++) {
			if(!g_IsConnected[i] || !g_AccountPJ_Logged[i]) {
				continue;
			}
			
			g_Points[i][P_HUMAN] += iPoints;
			g_Points[i][P_ZOMBIE] += iPoints;
		}
	}
}

public message__StatusIcon(const msg_id, const msg_dest, const id) {
	static sIcon[8];
	get_msg_arg_string(2, sIcon, 7);
	
	if(equal(sIcon, "buyzone") && get_msg_arg_int(1)) {
		set_pdata_int(id, 235, get_pdata_int(id, 235) & ~(1<<0));
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_CONTINUE;
}

public showMenu__AnotherUser(const id) {
	if(!g_IsConnected[id]) {
		return;
	}
	
	static sMenu[356];
	formatex(sMenu, charsmax(sMenu), "\y****** CIMSP ******^n^n\rYA HAY UN USUARIO LOGUEADO CON TU^nCUENTA DENTRO DEL SERVIDOR\w^n^nPJ que está en tu cuenta: \y%s\w^nCuenta \y#%d^n^n\r¿ No conoces a ésta persona ?^n^n\
	\wTe recomendamos cambiar YA tu contraseña^ndesde el panel de control: \yzp.cimsp.net/panel^n^n****** CIMSP ******", g_AnotherUserInYourAccount_Name[id], g_AnotherUserInYourAccount[id]);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "Another User Menu");
}

public menu__AnotherUser(const id, const key) {
	showMenu__AnotherUser(id);
	return PLUGIN_HANDLED;
}

public showMenu__Rango(const id) {
	static sMenu[250];
	static sAPs[11];
	static iPoints;
	
	iPoints = g_Reset[id];
	
	if(iPoints > 5) {
		iPoints = 5;
	}
	
	addDot(__MAX_APS_PER_RESET(g_Reset[id]), sAPs, 10);
	
	formatex(sMenu, charsmax(sMenu), "\ySUBIR DE RANGO^n^n\wPara subir al \yrango %d\w necesitás:^n\r - \wNivel 300^n\r - \w%s ammo packs^n\r - \w%d pH^n\r - \w%d pZ^n^n\rAl subir de rango se reiniciaran todos tus ammo packs^n^n\w\r1. \wSubir de rango!^n^n\r0. \wVolver",
	(g_Reset[id]+1), sAPs, iPoints, iPoints);
	
	set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	show_menu(id, KEYSMENU, sMenu, -1, "1 Rango Menu");
}

public menu__Rango(const id, const key) {
	switch(key) {
		case 0: {
			static iPoints;
			iPoints = g_Reset[id];
			
			if(iPoints > 5) {
				iPoints = 5;
			}
			
			if(g_Points[id][P_HUMAN] >= iPoints) {
				if(g_Points[id][P_ZOMBIE] >= iPoints) {
					if(g_Level[id] == 300) {
						if(g_AmmoPacks[id] >= __MAX_APS_PER_RESET(g_Reset[id])) {
							g_Points[id][P_HUMAN] -= iPoints;
							g_Points[id][P_ZOMBIE] -= iPoints;
							
							g_PointsLost[id][P_HUMAN] += iPoints;
							g_PointsLost[id][P_ZOMBIE] += iPoints;
							
							g_AmmoPacks[id] = 0;
							
							g_Level[id] = 1;
							++g_Reset[id];
							
							g_Level_Percent[id] = 0.0;
							
							fixAps(id);
							
							switch(g_Reset[id]) {
								case 1: {
									setAchievement(id, RESET_x1);
								} case 2: {
									setAchievement(id, RESET_x2);
								} case 3: {
									setAchievement(id, RESET_x3);
								} case 4: {
									setAchievement(id, RESET_x4);
								} case 5: {
									setAchievement(id, RESET_x5);
									giveHat(id, HAT_MAU5);
								}  case 10: {
									setAchievement(id, RESET_x10);
								}  case 20: {
									setAchievement(id, RESET_x20);
								}  case 30: {
									setAchievement(id, RESET_x30);
								}  case 40: {
									setAchievement(id, RESET_x40);
								}  case 50: {
									setAchievement(id, RESET_x50);
								}
							}
							
							colorChat(0, CT, "%sFelicitaciones a !t%s!y, subió al !grango %d!y!", ZP_PREFIX, g_UserName[id], g_Reset[id]);
						} else {
							colorChat(id, _, "%sTe faltan !gammo packs!y para poder subir de rango!", ZP_PREFIX);
						}
					} else {
						colorChat(id, _, "%sTe faltan !gniveles!y para poder subir de rango!", ZP_PREFIX);
					}
				} else {
					colorChat(id, _, "%sTe faltan !gpZ!y para poder subir de rango!", ZP_PREFIX);
				}
			} else {
				colorChat(id, _, "%sTe faltan !gpH!y para poder subir de rango!", ZP_PREFIX);
			}
		} case 9: {
			showMenu__Game(id);
		} default: {
			showMenu__Rango(id);
		}
	}
	
	return PLUGIN_HANDLED;
}

public checkAchievements_Weapons(const id) {
	new iWeapons = 0;
	new i;
	
	switch((g_WeaponData[id][g_CurrentWeapon[id]][weaponLevel] / 5)) {
		case 1: {
			for(i = 0; i < 21; ++i) {
				if(g_WeaponData[id][WEAPON_DATA[i][weaponDataId]][weaponLevel] >= 5) {
					++iWeapons;
				}
			}
			
			switch(iWeapons) {
				case 1: {
					setAchievement(id, LA_MEJOR_OPCION);
					setAchievement(id, PRIMERO_LA_MEJOR_OPCION);
				} case 5: {
					setAchievement(id, LA_MEJOR_OPCION_x5);
				} case 10: {
					setAchievement(id, LA_MEJOR_OPCION_x10);
				} case 15: {
					setAchievement(id, LA_MEJOR_OPCION_x15);
				} case 20: {
					setAchievement(id, LA_MEJOR_OPCION_x20);
				} case 21: {
					giveHat(id, HAT_PANDA);
				}
			}
		} case 2: {
			for(i = 0; i < 21; ++i) {
				if(g_WeaponData[id][WEAPON_DATA[i][weaponDataId]][weaponLevel] >= 10) {
					++iWeapons;
				}
			}
			
			switch(iWeapons) {
				case 1: {
					setAchievement(id, UNA_DE_LAS_MEJORES);
					setAchievement(id, PRIMERO_UNA_DE_LAS_MEJORES);
				} case 5: {
					setAchievement(id, UNA_DE_LAS_MEJORES_x5);
				} case 10: {
					setAchievement(id, UNA_DE_LAS_MEJORES_x10);
				} case 15: {
					setAchievement(id, UNA_DE_LAS_MEJORES_x15);
				} case 20: {
					setAchievement(id, UNA_DE_LAS_MEJORES_x20);
				}
			}
		} case 3: {
			for(i = 0; i < 21; ++i) {
				if(g_WeaponData[id][WEAPON_DATA[i][weaponDataId]][weaponLevel] >= 15) {
					++iWeapons;
				}
			}
			
			switch(iWeapons) {
				case 1: {
					setAchievement(id, MI_PREFERIDA);
					setAchievement(id, PRIMERO_MI_PREFERIDA);
				} case 5: {
					setAchievement(id, MI_PREFERIDA_x5);
				} case 10: {
					setAchievement(id, MI_PREFERIDA_x10);
				} case 15: {
					setAchievement(id, MI_PREFERIDA_x15);
				} case 20: {
					setAchievement(id, MI_PREFERIDA_x20);
				}
			}
		} case 4: {
			for(i = 0; i < 21; ++i) {
				if(g_WeaponData[id][WEAPON_DATA[i][weaponDataId]][weaponLevel] >= 20) {
					++iWeapons;
				}
			}
			
			switch(iWeapons) {
				case 1: {
					setAchievement(id, LA_MEJOR);
					setAchievement(id, PRIMERO_LA_MEJOR);
				} case 5: {
					setAchievement(id, LA_MEJOR_x5);
				} case 10: {
					setAchievement(id, LA_MEJOR_x10);
				} case 15: {
					setAchievement(id, LA_MEJOR_x15);
				} case 20: {
					setAchievement(id, LA_MEJOR_x20);
				}
			}
		}
	}
}

public fw_TouchAlien(const ent, const id) {
	if(!is_user_valid_alive(id) || !pev_valid(id) || !g_Alien[id]) {
		return FMRES_IGNORED;
	}
	
	entity_get_vector(id, EV_VEC_origin, g_AlienOrigin[id]);
	
	return FMRES_IGNORED;
}

public fw_CmdStart(const id, const handle) {
	if(!g_IsAlive[id]) {
		return FMRES_IGNORED;
	}
	
	if(!g_Alien[id]) {
		return FMRES_IGNORED;
	}
	
	static iButton;
	iButton = get_uc(handle, UC_Buttons);
	
	if(g_Alien[id] && (iButton & IN_USE)) {
		if(get_entity_flags(id) & FL_ONGROUND) {
			return FMRES_IGNORED;
		}
		
		static Float:vecOrigin[3];
		entity_get_vector(id, EV_VEC_origin, vecOrigin);
		
		if(get_distance_f(vecOrigin, g_AlienOrigin[id]) > 25.0) {
			return FMRES_IGNORED;
		}
		
		if(iButton & IN_FORWARD) {
			static Float:vecVelocity[3];
			
			velocity_by_aim(id, 350, vecVelocity);
			entity_set_vector(id, EV_VEC_velocity, vecVelocity);
		} else if(iButton & IN_BACK) {
			static Float:vecVelocity[3];
			
			velocity_by_aim(id, -350, vecVelocity);
			entity_set_vector(id, EV_VEC_velocity, vecVelocity);
		}
	}
	
	return FMRES_IGNORED;
}

public showLogo(const id, const logo) {
	if(logo != LOGO_NONE) {
		g_Account_Logo[id] = logo;
		
		message_begin(MSG_ONE, g_Message_WeaponList, _, id);
		write_string(SPRITE_DIR[logo]);
		write_byte(-1);
		write_byte(-1);
		write_byte(-1);
		write_byte(-1);
		write_byte(3);
		write_byte(3);
		write_byte(CSW_VEST);
		write_byte((1<<0));
		message_end();
		
		message_begin(MSG_ONE, g_Message_Fov, _, id);
		write_byte(89);
		message_end();
		
		message_begin(MSG_ONE, g_Message_CurWeapon, _, id);
		write_byte(1);
		write_byte(CSW_VEST);
		write_byte(1);
		message_end();
		
		message_begin(MSG_ONE, g_Message_Fov, _, id);
		write_byte(90);
		message_end();
	} else if(g_Account_Logo[id]) {
		g_Account_Logo[id] = logo;
		
		message_begin(MSG_ONE, g_Message_CurWeapon, _, id);
		write_byte(2);
		write_byte(CSW_VEST);
		write_byte(1);
		message_end();
	}
}