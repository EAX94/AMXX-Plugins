#include <amxmodx>
#include <cstrike>
#include <engine>
#include <fakemeta>
#include <fun>
#include <amxmisc>
#include <hamsandwich>
#include <xs>

new const AUTHOR[] = "L//"
new const VERSION[] = "1.00"

new g_time_delay = 0;
new g_maxexp[33];
new g_timesp[2];
new g_sp = 0;
new g_namename[32];

new saca_el_team = 0;
new sj_basket_ell;

new EQUIPO_CT[32];
new EQUIPO_T[32];

new loasd[33]
new g_late_exp[33]
new g_roundteam[33];

new g_pCVAR_PossArea;
new g_pCVAR_PossArea_Distance;
new CVAR_DIFFERENCE_GOALS;

#define is_user_valid_alive(%1) (1 <= %1 <= maxplayers && is_user_alive(%1))

#define TASK_FSP_1	9848132
#define TASK_FSP_2	19696264

new const NOMBRE_EQUIPOS[][] = {
	"Banfield",
	"Boca",
	"Arsenal",
	"Belgrano",
	"Gimnasia y Esgrima La Plata",
	"Independiente",
	"Estudiantes",
	"Lanús",
	"Godoy Cruz",
	"Quilmes",
	"Newell's Old Boys",
	"Olimpo",
	"San Lorenzo",
	"Racing",
	"River",
	"Vélez",
	"Rosario Central",
	"Defensa y Justicia",
	"Tigre",
	"Atletico Rafaela"
}

new g_maps_poss[][] = 
{
	"sj_natureworld",
	"sj_spacejam",
	"sj_snow",
	"sj_indoorx_small",
	"sj_pro",
	"sj_mxsoccer",
	"sj_virusghost",
	"sj_gaminga_arena_small",
	"sj_gaminga_greengrass_v2"
}
enum
{
	ARQ_T = 0,
	ARQ_CT,
	
	T_DEF_CENTRAL_IZQ,
	T_DEF_CENTRAL_DER,
	T_DEF_LATERAL_IZQ,
	T_DEF_LATERAL_DER,
	T_MEDIO_CENTRAL,
	T_MEDIO_IZQ,
	T_MEDIO_DER,
	T_EXTREMO_IZQ,
	T_EXTREMO_DER,
	T_DELANTERO_IZQ,
	T_DELANTERO_DER,
	
	CT_DEF_CENTRAL_IZQ,
	CT_DEF_CENTRAL_DER,
	CT_DEF_LATERAL_IZQ,
	CT_DEF_LATERAL_DER,
	CT_MEDIO_CENTRAL,
	CT_MEDIO_IZQ,
	CT_MEDIO_DER,
	CT_EXTREMO_IZQ,
	CT_EXTREMO_DER,
	CT_DELANTERO_IZQ,
	CT_DELANTERO_DER,
	
	MAX_POSS
}

new g_poss_text[MAX_POSS][] = 
{
	"ARQUERO",
	"ARQUERO",
	
	"DEFENSOR CENTRAL IZQUIERDO",
	"DEFENSOR CENTRAL DERECHO",
	"DEFENSOR LATERAL IZQUIERDO",
	"DEFENSOR LATERAL DERECHO",
	"MEDIOCAMPISTA CENTRAL",
	"MEDIOCAMPISTA IZQUIERDO",
	"MEDIOCAMPISTA DERECHO",
	"EXTREMO IZQUIERDO",
	"EXTREMO DERECHO",
	"DELANTERO IZQUIERDO",
	"DELANTERO DERECHO",
	
	"DEFENSOR CENTRAL IZQUIERDO",
	"DEFENSOR CENTRAL DERECHO",
	"DEFENSOR LATERAL IZQUIERDO",
	"DEFENSOR LATERAL DERECHO",
	"MEDIOCAMPISTA CENTRAL",
	"MEDIOCAMPISTA IZQUIERDO",
	"MEDIOCAMPISTA DERECHO",
	"EXTREMO IZQUIERDO",
	"EXTREMO DERECHO",
	"DELANTERO IZQUIERDO",
	"DELANTERO DERECHO"
}

new g_actualized[33]
new g_error = 0
new g_poss[MAX_POSS]
new g_possid[33][MAX_POSS]
new g_upg[33][6]
new Float:g_positionsNATURE_WORLD[MAX_POSS][] =
{
	{2100.288818 , -3.011624 , 36.031249},
	{-2108.171386 , 3.595805 , 36.031249},

	{1586.566406 , -549.229492 , 36.031249},
	{1590.403930 , 552.046264 , 36.031249},
	{1489.356201 , -1499.008911 , 36.031249},
	{1503.234008 , 1385.388671 , 36.031249},
	{931.120666 , -23.037338 , 36.031249},
	{918.419616 , -657.850585 , 36.031249},
	{865.650024 , 455.293487 , 36.031249},
	{716.283386 , -1364.626464 , 36.031249},
	{685.517333 , 1403.887084 , 36.031249},
	{412.850555 , -354.340301 , 36.031249},
	{411.211456 , 370.499725 , 36.031249},
	
	{-1558.976806 , 553.304138 , 36.031249},
	{-1586.899902 , -553.142944 , 36.031249},
	{-1573.242553 , 1400.831054 , 36.031249},
	{-1512.055175 , -1408.137573 , 36.031249},
	{-792.078308 , 8.044735 , 36.031249},
	{-816.749816 , 541.351440 , 36.031249},
	{-798.344543 , -449.566680 , 36.031249},
	{-753.046569 , 1074.555786 , 36.031249},
	{-741.365722 , -1411.019653 , 36.031249},
	{-435.737457 , 383.283447 , 36.031249},
	{-433.903472 , -384.936035 , 36.031249}
}
new Float:g_positionsSNOW[MAX_POSS][] =
{
	{2048.544189 , -6.553479 , 36.031249},
	{-2024.771240 , 16.782369 , 36.031249},
	
	{1578.012939 , -546.930969 , 36.031249},
	{1583.716796 , 560.202697 , 36.031249},
	{1352.732666 , -1472.591552 , 36.031249},
	{1371.932983 , 1380.336181 , 36.031249},
	{942.393554 , -10.753696 , 36.031249},
	{944.850341 , -417.364776 , 36.031249},
	{778.898864 , 446.501037 , 36.031249},
	{613.947570 , -1401.797363 , 36.031249},
	{648.577148 , 1406.129272 , 36.031249},
	{397.741180 , -383.465118 , 36.031249},
	{400.781372 , 373.150268 , 36.031249},
	
	{-1581.860351 , 537.886718 , 36.031249},
	{-1581.985473 , -548.963684 , 36.031249},
	{-1247.624511 , 1401.686279 , 36.031249},
	{-1344.272338 , -1399.596557 , 36.031249},
	{-947.611206 , 4.482931 , 36.031249},
	{-846.826538 , 461.430206 , 36.031249},
	{-919.504943 , -432.387420 , 36.031249},
	{-683.307983 , 971.575561 , 36.031249},
	{-558.268371 , -1296.887573 , 36.031249},
	{-453.060333 , 355.097808 , 36.031249},
	{-430.696319 , -385.341064 , 36.031249}
}
new Float:g_positionsSPACEJAM[MAX_POSS][] =
{
	{2064.248046 , -10.396931 , 36.031249},
	{-2013.777099 , 2.744343 , 36.031249},
	
	{1567.812255 , -559.083618 , 36.031249},
	{1578.214355 , 539.798767 , 36.031249},
	{1355.512207 , -1408.710571 , 36.031249},
	{1390.005249 , 1383.690185 , 36.031249},
	{940.636108 , -10.481784 , 36.031249},
	{918.797851 , -470.669342 , 36.031249},
	{932.329467 , 485.802307 , 36.031249},
	{753.212463 , -1409.123657 , 36.031249},
	{702.231079 , 1305.375488 , 36.031249},
	{403.914764 , -394.560791 , 36.031249},
	{388.018157 , 382.865844 , 36.031249},
	
	{-1581.917846 , -553.197875 , 36.031249},
	{-1585.574707 , 548.120483 , 36.031249},
	{-1522.883544 , 1390.699829 , 36.031249},
	{-1582.589111 , -1407.790039 , 36.03124},
	{-870.655212 , -9.438704 , 36.031249},
	{-914.649475 , 671.185729 , 36.031249},
	{-875.818786 , -436.767822 , 36.031249},
	{-759.442871 , 914.455139 , 36.031249},
	{-804.983764 , -1410.347656 , 36.031249},
	{-393.618530 , 365.468597 , 36.031249},
	{-395.253051 , -393.389190 , 36.031249}
}
new Float:g_positionsINDOORXSMALL[MAX_POSS][] =
{
	{1881.184692 , -357.891693 , -300.968749},
	{-1380.899536 , -363.398101 , -300.968749},
	
	{1423.299804 , -645.555053 , -300.9687499},
	{1415.003051 , -72.058670 , -300.968749},
	{1383.944580 , -833.319030 , -300.968749},
	{1390.842285 , 126.661506 , -300.968749},
	{922.870117 , -377.453369 , -300.96874},
	{924.463806 , -827.345520 , -300.968749},
	{908.245361 , 133.495239 , -300.968749},
	{616.172058 , -889.947326 , -300.968749},
	{624.945434 , 132.461318 , -300.968749},
	{484.892456 , -618.318847 , -300.968749},
	{468.034240 , -115.005271 , -300.968749},
	
	{-1178.968383 , -77.459259 , -300.968749},
	{-1189.772949 , -642.559814 , -300.968749},
	{-1188.824462 , 107.377365 , -300.96874},
	{-1187.122314 , -844.167846 , -300.968749},
	{-773.406738 , -356.213165 , -300.96874},
	{-782.707458 , 103.891883 , -300.968749},
	{-803.199768 , -844.805908 , -300.968749},
	{-455.858917 , 370.196228 , -300.968749},
	{-450.857543 , -992.687377 , -300.968749},
	{-131.754409 , 39.792694 , -300.968749},
	{-117.301651 , -672.511413 , -300.968749}
}
new Float:g_positionsPRO[MAX_POSS][] =
{
	{1759.249267 , 216.637359 , -523.968749},
	{-1323.264038 , 214.901275 , -523.968749},
	
	{1511.316162 , -58.418853 , -523.968749},
	{1523.883544 , 496.367553 , -523.968749},
	{1519.009765 , -268.095794 , -523.968749},
	{1501.236938 , 699.547973 , -523.968749},
	{1070.647460 , 181.486862 , -523.968749},
	{1048.150146 , -256.426055 , -523.968749},
	{1080.950073 , 729.460632 , -523.968749},
	{783.440734 , -227.518844 , -523.968749},
	{800.138793 , 540.574401 , -523.968749},
	{541.727600 , -101.098640 , -523.96874},
	{531.147460 , 443.509094 , -523.968749},
	
	{-1074.818237 , 491.130767 , -523.968749},
	{-1091.881469 , -65.297477 , -523.968749},
	{-1084.704956 , 679.229919 , -523.968749},
	{-1079.788452 , -267.691375 , -523.968749},
	{-574.115966 , 226.694869 , -523.968749},
	{-574.526855 , 651.341308 , -523.96874},
	{-600.110839 , -154.322784 , -523.968749},
	{-276.212921 , 666.908935 , -523.968749},
	{-279.142395 , -236.582290 , -523.968749},
	{-126.629653 , 510.078796 , -523.968749},
	{138.157165 , -47.962539 , -523.968749}
}
new Float:g_positionsMXSOCCER[MAX_POSS][] =
{
	{1813.079833 , -459.732727 , -300.968749},
	{-1612.882324 , -471.921874 , -300.968749},
	
	{1420.696044 , -968.713256 , -300.968749},
	{1427.108764 , -149.102890 , -300.968749},
	{1397.112060 , -1250.939331 , -300.968749},
	{1463.466674 , 291.119995 , -300.968749},
	{1026.137695 , -461.622863 , -300.968749},
	{693.284301 , -784.001464 , -300.968749},
	{672.124267 , -137.540512 , -300.968749},
	{491.994689 , -1343.082885 , -300.968749},
	{427.206939 , 300.291168 , -300.968749},
	{436.336486 , -784.500488 , -300.968749},
	{384.995910 , -131.168029 , -300.968749},
	
	{-1181.521118 , -194.015960 , -300.968749},
	{-1174.364746 , -759.745117 , -300.968749},
	{-1123.753540 , 378.362335 , -300.968749},
	{-1167.875488 , -1219.487426 , -300.968749},
	{-841.402038 , -457.994079 , -300.968749},
	{-621.431091 , -128.523376 , -300.968749},
	{-582.819702 , -800.080444 , -300.968749},
	{-185.801467 , 373.976409 , -300.968749},
	{-200.379211 , -1204.744995 , -300.968749},
	{-213.606384 , -150.517196 , -300.968749},
	{-179.082641 , -753.341674 , -300.968749}
}
new Float:g_positionsVIRUSGHOST[MAX_POSS][] =
{
	{2091.449707 , 254.509155 , -473.968749},
	{-1634.749755 , 229.960693 , -473.968749},
	
	{1666.132446 , -24.337730 , -473.968749},
	{1656.330078 , 545.015808 , -473.968749},
	{1655.171630 , -497.498779 , -473.968749},
	{1671.399414 , 1032.510009 , -473.968749},
	{1296.880493 , 269.588775 , -473.968749},
	{1037.463745 , 35.911174 , -473.968749},
	{1122.988769 , 515.083007 , -473.968749},
	{570.675537 , -486.289764 , -473.968749},
	{631.877441 , 958.228759 , -473.968749},
	{462.841400 , 58.985977 , -473.968749},
	{524.744262 , 477.258514 , -473.968749},
	
	{-1216.294189 , 550.842346 , -473.968749},
	{-1219.451782 , -21.821348 , -473.968749},
	{-1192.718994 , 1048.633666 , -473.968749},
	{-1188.661254 , -539.069335 , -473.968749},
	{-704.006958 , 275.033081 , -473.968749},
	{-384.730895 , 700.080993 , -473.968749},
	{-403.414245 , -212.363449 , -473.968749},
	{-120.578765 , 1046.804931 , -473.968749},
	{-176.426773 , -411.971923 , -473.968749},
	{31.637180 , 454.301177 , -473.968749},
	{37.058296 , 26.456432 , -473.968749}
}
new Float:g_positionsARENASMALL[MAX_POSS][] =
{
	{136.672882 , 1634.731201 , -271.968749},
	{142.143524 , -1933.999999 , -271.968749},
	
	{308.604888 , 1275.367431 , -271.968749},
	{-35.510250 , 1270.636962 , -271.968749},
	{710.004699 , 1097.941894 , -271.968749},
	{-457.195220 , 1126.245483 , -271.968749},
	{144.944763 , 736.305847 , -271.968749},
	{427.374847 , 549.531372 , -271.968749},
	{-104.473411 , 580.376953 , -271.968749},
	{880.345764 , 169.206024 , -271.968749},
	{-549.837646 , 284.831634 , -271.968749},
	{429.362640 , 146.073104 , -271.968749},
	{-152.838806 , 166.155441 , -271.968749},
	
	{-32.225463 , -1593.608398 , -271.968749},
	{307.043701 , -1601.066528 , -271.968749},
	{-628.741760 , -1492.849975 , -271.968749},
	{751.590454 , -1371.562988 , -271.968749},
	{133.229873 , -1182.399536 , -271.968749},
	{-176.744400 , -945.478759 , -271.968749},
	{426.159362 , -951.114990 , -271.968749},
	{-590.261230 , -534.988098 , -271.968749},
	{825.875854 , -602.857543 , -271.968749},
	{-157.622436 , -446.430450 , -271.968749},
	{435.268310 , -460.662536 , -271.968749}
}
new Float:g_positionsGREENGRASS[MAX_POSS][] =
{
	{370.988220 , -1930.794921 , -155.968749},
	{358.884277 , 1832.968749 , -155.968749},

	{193.615814 , -1478.604858 , -155.968749},
	{536.634521 , -1506.181274 , -155.968749},
	{-103.626106 , -1453.706054 , -155.968749},
	{877.200500 , -1445.040771 , -155.968749},
	{354.382080 , -866.441711 , -155.968749},
	{-22.132230 , -850.533996 , -155.968749},
	{729.417907 , -873.602355 , -155.968749},
	{-464.007446 , -494.418670 , -155.968749},
	{1228.173339 , -500.823303 , -155.968749},
	{-25.275106 , -370.001373 , -155.968749},
	{755.315185 , -381.451019 , -155.968749},

	{539.379882 , 1410.662841 , -155.968749},
	{185.709014 , 1373.944702 , -155.968749},
	{853.761596 , 1087.299926 , -155.968749},
	{-121.088661 , 1034.319335 , -155.968749},
	{360.275970 , 977.160949 , -155.968749},
	{773.425720 , 737.882995 , -155.968749},
	{-9.480591 , 725.177368 , -155.968749},
	{1202.336791 , 431.224731 , -155.968749},
	{-462.116271 , 532.197082 , -155.968749},
	{765.379638 , 319.109619 , -155.968749},
	{-25.756988 , 314.725952 , -155.968749}
}
new g_upgrades[MAX_POSS][] =
{
	{0, 8, 0, 0, 3, 0},
	{0, 8, 0, 0, 3, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0}
}

///////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////  PERFECT SELECT	///////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
/* ------------------------------------------------------------------------- */
/* /----------------------- START OF CUSTOMIZATION  -----------------------/ */
/* ------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------- */
/* /------------  CUSTOM DEFINES  ------------ CUSTOM DEFINES  ------------/ */
/* ------------------------------------------------------------------------- */
#define MAX_LVL_POWERPLAY 	10
#define DISARM_MULTIPLIER 	2

#define TEAMS 				4

new g_change_teams = 0
new g_team_winner = 0
new g_time_rest_min = 30
new g_time_total = 30
new g_time_rest_sec = 1
new g_half_time = 0

new g_arquero[33]
new g_ballin[33]
new g_ball_none = 1
new g_ball_in_arc = 0

#define DEF_SELECTMAPS 	5
#define charsof(%1)		(sizeof(%1) - 1)

new Array:g_aMapName;

new sz_MapsIniFile[64] = { EOS, ... };
new g_LastMap[32] = { EOS, ... };

new g_MapNums = 0;
new g_NextMapName[DEF_SELECTMAPS] = { 0, ... };
new g_VoteCount[DEF_SELECTMAPS + 2] = { 0, ... };
new g_MapVoteNum = 0;
new g_Selected = 0;

const Float:gMODEL_CHANGE_DELAY = 0.3
new Float:g_models_targettime
new g_playermodel[33][32]

#define TASK_MODEL			1833616
#define TASK_FINISH			2649731
#define TASK_KEEPER			3164273
//#define TASK_REMOVE_BALL	4672160

#define ID_MODEL			(taskid - TASK_MODEL)
#define ID_FINISH			(taskid - TASK_FINISH)
#define ID_KEEPER			(taskid - TASK_KEEPER)
//#define ID_REMOVE_BALL		(taskid - TASK_REMOVE_BALL)

new const M_LEET[] = "leet" 
new const M_GIGN[] = "gign"

//new countdown_quitar[33], ok_quitar[33] = 0, last_bola

/* ------------------------------------------------------------------------- */
/* /----------------  MODELS  ---------------- MODELS  ----------------/ */
/* ------------------------------------------------------------------------- */
new ball[256]
new const TeamMascots[2][] = {
	"models/controller.mdl", //TERRORIST MASCOT
	"models/agrunt.mdl" //CT MASCOT
}
/* ------------------------------------------------------------------------- */
/* /----------------  SOUNDS  ---------------- SOUNDS  ----------------/ */
/* ------------------------------------------------------------------------- */

/* ------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------- */
/* /------------------------ END OF CUSTOMIZATION  ------------------------/ */
/* ------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------- */

#define MAX_PLAYER			32
#define POS_X 				-1.0
#define POS_Y 				0.85
#define HUD_CHANNEL			4

#define MAX_LINE_MODELS 	200

#define EXPLOSIONGOL 		"EXPLOSION_GOL"
#define EFECTOHUMO 			"EFECTO_HUMO"
#define POWERPLAY 			"POWER_PLAY"
#define RAYOMASCOTA 		"RAYO_MASCOTA"
#define FESTEJOGOL 			"FESTEJO_GOL"
#define FESTEJOGOLENCONTRA 	"FESTEJO_GOL_EN_CONTRA"
#define BOCHABEAM 			"BOCHA_BEAM"

#define GOL1 				"GOL_1"
#define GOL2 				"GOL_2"
#define GOL3 				"GOL_3"
#define GOL4				"GOL_4"
#define GOL5 				"GOL_5"
#define GOL6 				"GOL_6"
#define GOLENCONTRA1 		"GOL_EN_CONTRA_1"
#define GOLENCONTRA2 		"GOL_EN_CONTRA_2"
#define GOLENCONTRA3 		"GOL_EN_CONTRA_3"
#define GOLENCONTRA4		"GOL_EN_CONTRA_4"
#define GOLENCONTRA5 		"GOL_EN_CONTRA_5"
#define PUSSY				"PUSSY"
#define INICIORONDA 		"INICIO_RONDA"
#define BOCHAPIQUE 			"BOCHA_PIQUE"
#define BOCHARECIBIDA 		"BOCHA_RECIBIDA"
#define BOCHARESPAWN 		"BOCHA_RESPAWN"
#define GOLMARCADO 			"GOL_MARCADO"
#define BOCHAPASE 			"BOCHA_PASE"
#define FULLSKILL 			"FULL_SKILL"
#define VICTORIA 			"VICTORIA"
#define TELEPORTCABINA 		"TELEPORT_CABINA"
#define KILLCONBOCHA 		"KILL_CON_BOCHA"
#define TEDESARMAN 			"TE_DESARMAN"
#define DESARMAS 			"DESARMAS"
#define SERARQUERO 			"SER_ARQUERO"
#define NOSERARQUERO 		"NO_SER_ARQUERO"
#define SILBATO 			"SILBATO"

#define	MAXLVLSTAMINA 		"MAX_LVL_VIDA"
#define	MAXLVLSTRENGTH		"MAX_LVL_FUERZA"
#define	MAXLVLAGILITY		"MAX_LVL_AGILIDAD"
#define MAXLVLDEXTERITY		"MAX_LVL_DESTREZA"
#define	MAXLVLDISARM		"MAX_LVL_DISARM"

#define	EXPPRICESTAMINA		"EXP_PRECIO_VIDA"
#define	EXPPRICESTRENGTH	"EXP_PRECIO_FUERZA"
#define	EXPPRICEAGILITY		"EXP_PRECIO_AGILIDAD"
#define	EXPPRICEDEXTERITY	"EXP_PRECIO_DESTREZA"
#define	EXPPRICEDISARM		"EXP_PRECIO_DISARM"

#define EXPGOLEQUIPO		"EXP_GOL_EQUIPO"
#define EXPROBO				"EXP_ROBO"
#define EXPBALLKILL			"EXP_BALLKILL"
#define EXPASISTENCIA		"EXP_ASISTENCIA"
#define EXPGOL				"EXP_GOL"

#define BASEHP				"VIDA_INICIAL"
#define BASEDISARM			"DISARM_INICIAL"

#define CUENTAREGRESIVA		"CUENTA_REGRESIVA"
#define TIEMPOEXPCAMPEAR	"TIEMPO_EXP_CAMPEAR"

#define CURVEANGLE			"COMBA_ANGULO"
#define CURVECOUNT			"COMBA_VECES_CURVA"
#define DIRECTIONS			"COMBA_CUANTAS"
#define ANGLEDIVIDE			"COMBA_DIVISION"

#define AMOUNTLATEJOINEXP	"EXP_TARDE"
#define AMOUNTPOWERPLAY		"PP_AUMENTO_SKILL"
#define AMOUNTGOALY 		"EXP_CAMPEAR"

#define AMOUNTSTA			"CANT_VIDA_POR_LVL"
#define AMOUNTSTR			"CANT_FUERZA_POR_LVL"
#define AMOUNTAGI			"CANT_AGILIDAD_POR_LVL"
#define AMOUNTDEX			"CANT_DESTREZA_POR_LVL"
#define AMOUNTDISARM		"CANT_DISARM_POR_LVL"

new ConfigPro[21]

enum {
	UNASSIGNED = 0,
	T,
	CT,
	SPECTATOR
}

#define RECORDS 8
enum {
	GOAL = 1,
	ASSIST,
	STEAL,
	KILL,
	DISTANCE,
	DISARMS,
	ENCONTRA,
	GOALY
}

#define UPGRADES 5
enum {
	STA = 1,	//stamina
	STR,		//strength
	AGI,		//agility
	DEX,		//dexterity
	DISARM		//disarm
}

static const UpgradeTitles[UPGRADES+1][] =
{
	"NULL",
	"VIDA",
	"FUERZA",
	"AGILIDAD",
	"DESTREZA",
	"DESARMAR"
}

new UpgradeMax[UPGRADES+1]
new UpgradePrice[UPGRADES+1]

new PlayerUpgrades[MAX_PLAYER + 1][UPGRADES+1]
new GoalEnt[TEAMS]
new PressedAction[MAX_PLAYER + 1]
new seconds[MAX_PLAYER + 1]
new g_sprint[MAX_PLAYER + 1]
new SideJump[MAX_PLAYER + 1]
new Float:SideJumpDelay[MAX_PLAYER + 1]
new PlayerDeaths[MAX_PLAYER + 1]
new PlayerKills[MAX_PLAYER + 1]
new curvecount
new direction
new maxplayers
new Float:BallSpinDirection[3]
new ballspawncount
new Float:TeamBallOrigins[TEAMS][3]
new Float:TEMP_TeamBallOrigins[3]
new Mascots[TEAMS]
new Float:MascotsOrigins[3]
new Float:MascotsAngles[3]
new Float:fire_delay
new Float:GoalyCheckDelay[MAX_PLAYER + 1]
new GoalyCheck[MAX_PLAYER + 1]
new GoalyPoints[MAX_PLAYER + 1]
new Float:BallSpawnOrigin[5][3]
new TopPlayer[2][RECORDS+1]
new MadeRecord[MAX_PLAYER + 1][RECORDS+1]
new TopPlayerName[RECORDS+1][MAX_PLAYER + 1]
new g_Experience[MAX_PLAYER + 1]
new Float:testorigin[3]
new Float:velocity[3]
new score[TEAMS]
new scoreboard[1025]
new temp1[64], temp2[64]
new distorig[2][3] //distance recorder
new gmsgShake
new gmsgDeathMsg
new gmsgTextMsg
new bool:is_dead[MAX_PLAYER + 1]
new PowerPlay, powerplay_list[MAX_LVL_POWERPLAY+1]
new assist[16]
new iassist[TEAMS]
new gamePlayerEquip
new g_MsgHudFinal;
new g_MsgHudRecord;

new CVAR_KICK
new CVAR_GOLES_EN_CONTRA
new CVAR_AAA_FULL
new diidas = 0;
//new CVAR_DISTANCE_FOR_KILL

new BallColors[12]
new PlayerColors[31]
new SModel[7][256]
//new SSprite[8][128]
new SoundDirect[27][256]

new SpriteGol
new SpriteGolContra

new fire
new smoke
new beamspr
new g_fxBeamSprite
new Burn_Sprite

new ballholder
new ballowner
new aball
new bool:has_knife[MAX_PLAYER + 1]

// System Keeper
new bool:T_keeper[MAX_PLAYER + 1]
new bool:CT_keeper[MAX_PLAYER + 1]
new bool:user_is_keeper[MAX_PLAYER + 1]

/*new p_Classname[] = "arco_t"
new g_Classname[] = "arco_ct"
new y_Classname[] = "limite_t"
new z_Classname[] = "limite_ct"*/
new arqueroct
new arquerot

// Festejos
new T_sprite
new CT_sprite

// Spawns Maps Sj
new SpawnSjPro[256]

// Global Rank
new no_ball

//new FileCol[256], FileSpr[256], FileSounds[256], FileCfg[256]





new g_aaa = 0;
new g_cdc = 0;

enum ZONEMODE {
	ZM_NOTHING,
	ZM_CAMPING,
	ZM_CAMPING_T1,	// Team 1 -> e.g. Terrorist
	ZM_CAMPING_T2,	// Team 2 -> e.g. Counter-Terroris
	ZM_BLOCK_ALL,
	ZM_KILL,
	ZM_KILL_T1,	// DoD-Unterstützung
	ZM_KILL_T2
}

new cvars[2];

new zonemode[ZONEMODE][] = { "ZONE_MODE_NONE", "ZONE_MODE_CAMPER", "ZONE_MODE_CAMPER_T1", "ZONE_MODE_CAMPER_T2", "ZONE_MODE_BLOCKING",  "ZONE_MODE_CHEATER",  "ZONE_MODE_CHEATER_T1",  "ZONE_MODE_CHEATER_T2" }
new zonename[ZONEMODE][] = { "wgz_none", "wgz_camper", "wgz_camper_t1", "wgz_camper_t2", "wgz_block_all", "wgz_kill", "wgz_kill_t1", "wgz_kill_t2" }
new solidtyp[ZONEMODE] = { SOLID_NOT, SOLID_TRIGGER, SOLID_TRIGGER, SOLID_TRIGGER, SOLID_BBOX, SOLID_TRIGGER, SOLID_TRIGGER, SOLID_TRIGGER }
new zonecolor[ZONEMODE][3] = {
	{ 255, 0, 255 },		// nichts
	{ 0, 255, 0 },		// Camperzone
	{ 0, 255, 128 },		// Camperzone T1
	{ 128, 255, 0 },		// Camperzone T2
	{ 0, 255, 255 },	// alle Blockieren
	{ 255, 255, 255 },	// Kill
	{ 255, 0, 128 },	// Kill - T1
	{ 255, 128, 0 }	// Kill - T2
}

#define ZONEID pev_iuser1
#define CAMPERTIME pev_iuser2

new zone_color_aktiv[3] = { 0, 0, 255 }
new zone_color_red[3] = { 255, 0, 0 }
new zone_color_green[3] = { 255, 255, 0 }

// alle Zonen
#define MAXZONES 100
new zone[MAXZONES]
new maxzones		// soviele existieren
new index		// die aktuelle Zone

// Editier-Funktionen
new setupunits = 10	// Änderungen an der Größe um diese Einheiten
new directionWG = 0	// 0 -> X-Koorinaten / 1 -> Y-Koords / 2 -> Z-Koords
new koordinaten[3][] = { "TRANSLATE_X_KOORD", "TRANSLATE_Y_KOORD", "TRANSLATE_Z_KOORD" }

new spr_dot		// benötigt für die Lininen

new editor = 0		// dieser Spieler ist gerade am erstellen .. Menü verkraftet nur einen Editor

new camperzone[33]		// letzte Meldung der CamperZone
new Float:campertime[33]	// der erste Zeitpunkt des eintreffens in die Zone
new Float:camping[33]		// der letzte Zeitpunkt des campens

#define TASK_BASIS_CAMPER 2000
#define TASK_BASIS_SHOWZONES 1000
#define TASK_PMC	94812

// less CPU
new slap_direction
new slap_botdirection
new slap_damage
new slap_botdamage
new admin_immunity
new icon_damage		// Damage-Icon

enum ROUNDSTATUS {
	RS_UNDEFINED,
	RS_RUNNING,
	RS_FREEZETIME,
	RS_END,
}

new ROUNDSTATUS:roundstatus = RS_UNDEFINED

/*====================================================================================================
 [Precache]

 Purpose:	$$

 Comment:	$$

====================================================================================================*/
PrecacheSounds()
{
	/*new configDir[128]
	get_configsdir(configDir,127)
	formatex(FileSounds,255,"%s/sj_pro/pro-sounds.ini",configDir)

	new SoundNames[128]
	new prefijo[4], sufijo[26], Data[128], len
	for(new x = 0; x < MAX_LINE_MODELS; x++)
	{
		read_file(FileSounds, x, Data, 127, len)
		parse(Data, prefijo, 3, sufijo, 25)
		if(equali(prefijo,"##"))
		{
			for(new y = x + 1; y < x + 10; y++)
			{
				read_file(FileSounds, y, Data, 127, len)
				if(equali(Data,""))
					continue

				x = y - 1
				break;
			}

			parse(Data, SoundNames, 127)

			if(equali(sufijo,GOL1))
				formatex(SoundDirect[0], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,GOL2))
				formatex(SoundDirect[1], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,GOL3))
				formatex(SoundDirect[2], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,GOL4))
				formatex(SoundDirect[3], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,GOL5))
				formatex(SoundDirect[4], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,GOL6))
				formatex(SoundDirect[5], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,GOLENCONTRA1))
				formatex(SoundDirect[6], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,GOLENCONTRA2))
				formatex(SoundDirect[7], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,GOLENCONTRA3))
				formatex(SoundDirect[8], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,GOLENCONTRA4))
				formatex(SoundDirect[9], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,GOLENCONTRA5))
				formatex(SoundDirect[10], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,PUSSY))
				formatex(SoundDirect[11], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,INICIORONDA))
				formatex(SoundDirect[12], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,BOCHAPIQUE))
				formatex(SoundDirect[13], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,BOCHARECIBIDA))
				formatex(SoundDirect[14], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,BOCHARESPAWN))
				formatex(SoundDirect[15], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,GOLMARCADO))
				formatex(SoundDirect[16], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,BOCHAPASE))
				formatex(SoundDirect[17], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,FULLSKILL))
				formatex(SoundDirect[18], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,KILLCONBOCHA))
				formatex(SoundDirect[19], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,VICTORIA))
				formatex(SoundDirect[20], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,TELEPORTCABINA))
				formatex(SoundDirect[21], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,DESARMAS))
				formatex(SoundDirect[22], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,TEDESARMAN))
				formatex(SoundDirect[23], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,SERARQUERO))
				formatex(SoundDirect[24], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,NOSERARQUERO))
				formatex(SoundDirect[25], 255, "sj_pro/%s.wav", SoundNames)
			else if(equali(sufijo,SILBATO))
				formatex(SoundDirect[26], 255, "sj_pro/%s.wav", SoundNames)

		}
	}
	for(new x = 0; x < 27; x++)
		engfunc( EngFunc_PrecacheSound,	SoundDirect[x])*/
	
	formatex(SoundDirect[0], 255, "sj_pro/sound_b0.wav")
	formatex(SoundDirect[1], 255, "sj_pro/sound_b1.wav")
	formatex(SoundDirect[2], 255, "sj_pro/sound_b2.wav")
	formatex(SoundDirect[3], 255, "sj_pro/sound_b3.wav")
	formatex(SoundDirect[4], 255, "sj_pro/sound_b4.wav")
	formatex(SoundDirect[5], 255, "sj_prosound_b5.wav")
	
	formatex(SoundDirect[6], 255, "sj_pro/sound_c0.wav")
	formatex(SoundDirect[7], 255, "sj_pro/sound_c1.wav")
	formatex(SoundDirect[8], 255, "sj_pro/sound_c2.wav")
	formatex(SoundDirect[9], 255, "sj_pro/sound_c3.wav")
	formatex(SoundDirect[10], 255, "sj_pro/sound_c4.wav")
	
	formatex(SoundDirect[11], 255, "sj_pro/sound_a7.wav")
	formatex(SoundDirect[12], 255, "sj_pro/sound_a5.wav")
	formatex(SoundDirect[13], 255, "sj_pro/sound_a0.wav")
	formatex(SoundDirect[14], 255, "sj_pro/sound_a3.wav")
	
	formatex(SoundDirect[15], 255, "sj_pro/sound_a1.wav")
	formatex(SoundDirect[16], 255, "sj_pro/sound_a6.wav")
	formatex(SoundDirect[17], 255, "sj_pro/sound_a2.wav")
	formatex(SoundDirect[18], 255, "sj_pro/sound_a4.wav")
	formatex(SoundDirect[19], 255, "sj_pro/sound_a8.wav")
	formatex(SoundDirect[20], 255, "sj_pro/sound_a9.wav")
	formatex(SoundDirect[21], 255, "sj_pro/sound_a10.wav")
	formatex(SoundDirect[22], 255, "sj_pro/sound_a11.wav")
	formatex(SoundDirect[23], 255, "sj_pro/sound_a14.wav")
	formatex(SoundDirect[24], 255, "sj_pro/sound_a12.wav")
	formatex(SoundDirect[25], 255, "sj_pro/sound_a13.wav")
	formatex(SoundDirect[26], 255, "sj_pro/sound_a15.wav")

	for(new x = 0; x < 27; x++)
		engfunc( EngFunc_PrecacheSound,	SoundDirect[x])
}

PrecacheBall()
{
	BallColors[0] = 255
	BallColors[1] = 255
	BallColors[2] = 0
	BallColors[3] = 0
	BallColors[4] = 0
	BallColors[5] = 255
	BallColors[6] = 255
	BallColors[7] = 255
	BallColors[8] = 0
	BallColors[9] = 5
	BallColors[10] = 9
	BallColors[11] = 400
	
	new const sPlayerColors[] = { 0, 255, 255, 255, 255, 0, 25, 0, 255, 0, 255, 0, 0, 25, 255, 255, 255, 25, 0, 255, 0, 25, 52, 239, 254, 255, 255, 0, 0, 255, 255 }
	for(new x = 0; x < 31; x++)
		PlayerColors[x] = sPlayerColors[x]

	UpgradeMax[1] = 8
	UpgradeMax[2] = 10
	UpgradeMax[3] = 10
	UpgradeMax[4] = 10
	UpgradeMax[5] = 10
	
	UpgradePrice[1] = 220
	UpgradePrice[2] = 300
	UpgradePrice[3] = 300
	UpgradePrice[4] = 200
	UpgradePrice[5] = 200
	
	ConfigPro[0] = 100
	ConfigPro[1] = 300
	ConfigPro[2] = 100
	ConfigPro[3] = 300
	ConfigPro[4] = 300
	
	ConfigPro[5] = 100
	ConfigPro[6] = 5
	
	ConfigPro[7] = 10
	ConfigPro[8] = 10
	
	ConfigPro[9] = 15
	ConfigPro[10] = 6 // CURVECOUNT
	ConfigPro[11] = 2 // DIRECTIONS
	ConfigPro[12] = 6
	
	ConfigPro[13] = 200
	ConfigPro[14] = 5
	
	ConfigPro[15] = 50
	ConfigPro[16] = 15
	ConfigPro[17] = 17
	ConfigPro[18] = 12
	ConfigPro[19] = 18
	ConfigPro[20] = 1
	
	/*new prefijo[4], sufijo[26], Data[128], len
	for(new x = 0; x < MAX_LINE_MODELS; x++)
	{
		read_file(FileCol, x, Data, 127, len)
		parse(Data, prefijo, 3, sufijo, 25)
		if(equali(prefijo,"##"))
		{
			for(new y = x + 1; y < x + 10; y++)
			{
				read_file(FileCol, y, Data, 127, len)
				if(equali(Data,""))
					continue

				x = y - 1
				break;
			}
		}
	}
	
	BallColors[0] = 255
	BallColors[1] = 255
	BallColors[2] = 0
	BallColors[3] = 0
	BallColors[4] = 0
	BallColors[5] = 255
	BallColors[6] = 255
	BallColors[7] = 255
	BallColors[8] = 0
	BallColors[9] = 5
	BallColors[10] = 9
	BallColors[11] = 400
	
	new const sPlayerColors[] = { 0, 255, 255, 255, 255, 0, 25, 0, 255, 0, 255, 0, 0, 25, 255, 255, 255, 25, 0, 255, 0, 25, 52, 239, 254, 255, 255, 0, 0, 255, 255 }
	for(new x = 0; x < 31; x++)
		PlayerColors[x] = sPlayerColors[x]


	new configDir[128]
	get_configsdir(configDir,127)
	formatex(FileCfg,255,"%s/sj_pro/pro-cfg.ini",configDir)

	new cantidad[32]
	for(new x = 0; x < MAX_LINE_MODELS; x++)
	{
		read_file(FileCfg, x, Data, 127, len)
		parse(Data, prefijo, 3, sufijo, 25, cantidad, 31)
		if(equali(prefijo,"##"))
		{
			if(equali(sufijo,MAXLVLSTAMINA))
				UpgradeMax[1] = str_to_num(cantidad)
			else if(equali(sufijo,MAXLVLSTRENGTH))
				UpgradeMax[2] = str_to_num(cantidad)
			else if(equali(sufijo,MAXLVLAGILITY))
				UpgradeMax[3] = str_to_num(cantidad)
			else if(equali(sufijo,MAXLVLDEXTERITY))
				UpgradeMax[4] = str_to_num(cantidad)
			else if(equali(sufijo,MAXLVLDISARM))
				UpgradeMax[5] = str_to_num(cantidad)
			else if(equali(sufijo,EXPPRICESTAMINA))
				UpgradePrice[1] = str_to_num(cantidad)
			else if(equali(sufijo,EXPPRICESTRENGTH))
				UpgradePrice[2] = str_to_num(cantidad)
			else if(equali(sufijo,EXPPRICEAGILITY))
				UpgradePrice[3] = str_to_num(cantidad)
			else if(equali(sufijo,EXPPRICEDEXTERITY))
				UpgradePrice[4] = str_to_num(cantidad)
			else if(equali(sufijo,EXPPRICEDISARM))
				UpgradePrice[5] = str_to_num(cantidad)
			else if(equali(sufijo,EXPGOLEQUIPO))
				ConfigPro[0] = str_to_num(cantidad)
			else if(equali(sufijo,EXPROBO))
				ConfigPro[1] = str_to_num(cantidad)
			else if(equali(sufijo,EXPBALLKILL))
				ConfigPro[2] = str_to_num(cantidad)
			else if(equali(sufijo,EXPASISTENCIA))
				ConfigPro[3] = str_to_num(cantidad)
			else if(equali(sufijo,EXPGOL))
				ConfigPro[4] = str_to_num(cantidad)
			else if(equali(sufijo,BASEHP))
				ConfigPro[5] = str_to_num(cantidad)
			else if(equali(sufijo,BASEDISARM))
				ConfigPro[6] = str_to_num(cantidad)
			else if(equali(sufijo,CUENTAREGRESIVA))
				ConfigPro[7] = str_to_num(cantidad)
			else if(equali(sufijo,TIEMPOEXPCAMPEAR))
				ConfigPro[8] = str_to_num(cantidad)
			else if(equali(sufijo,CURVEANGLE))
				ConfigPro[9] = str_to_num(cantidad)
			else if(equali(sufijo,CURVECOUNT))
				ConfigPro[10] = str_to_num(cantidad)
			else if(equali(sufijo,DIRECTIONS))
				ConfigPro[11] = str_to_num(cantidad)
			else if(equali(sufijo,ANGLEDIVIDE))
				ConfigPro[12] = str_to_num(cantidad)
			else if(equali(sufijo,AMOUNTLATEJOINEXP))
				ConfigPro[13] = str_to_num(cantidad)
			else if(equali(sufijo,AMOUNTPOWERPLAY))
				ConfigPro[14] = str_to_num(cantidad)
			else if(equali(sufijo,AMOUNTGOALY))
				ConfigPro[15] = str_to_num(cantidad)
			else if(equali(sufijo,AMOUNTSTA))
				ConfigPro[16] = str_to_num(cantidad)
			else if(equali(sufijo,AMOUNTSTR))
				ConfigPro[17] = str_to_num(cantidad)
			else if(equali(sufijo,AMOUNTAGI))
				ConfigPro[18] = str_to_num(cantidad)
			else if(equali(sufijo,AMOUNTDEX))
				ConfigPro[19] = str_to_num(cantidad)
			else if(equali(sufijo,AMOUNTDISARM))
				ConfigPro[20] = str_to_num(cantidad)
		}
	}*/
}

PrecacheMonsters(team) {
	engfunc( EngFunc_PrecacheModel, TeamMascots[team-1])
}

PrecacheSprites()
{
	new DirectSprite[128]
	formatex(DirectSprite, 127, "sprites/sj_pro/sprite_02.spr")
	fire = engfunc( EngFunc_PrecacheModel, DirectSprite)
	
	formatex(DirectSprite, 127, "sprites/sj_pro/sprite_03.spr")
	smoke = engfunc( EngFunc_PrecacheModel, DirectSprite)
	
	formatex(DirectSprite, 127, "sprites/sj_pro/sprite_04.spr")
	Burn_Sprite = engfunc( EngFunc_PrecacheModel, DirectSprite)
	
	formatex(DirectSprite, 127, "sprites/sj_pro/sprite_05.spr")
	g_fxBeamSprite = engfunc( EngFunc_PrecacheModel, DirectSprite)
	
	formatex(DirectSprite, 127, "sprites/sj_pro/sprite_06.spr")
	SpriteGol = engfunc( EngFunc_PrecacheModel, DirectSprite)
	
	formatex(DirectSprite, 127, "sprites/sj_pro/sprite_07.spr")
	SpriteGolContra = engfunc( EngFunc_PrecacheModel, DirectSprite)
	
	formatex(DirectSprite, 127, "sprites/sj_pro/sprite_08.spr")
	beamspr = engfunc( EngFunc_PrecacheModel, DirectSprite)
	
	/*new configDir[128]
	new DirectSprite[128]
	get_configsdir(configDir,127)
	formatex(FileSpr,255,"%s/sj_pro/pro-sprites.ini",configDir)
	new prefijo[4], sufijo[26], Data[128], len
	for(new x = 0; x < MAX_LINE_MODELS; x++)
	{
		read_file(FileSpr, x, Data, 127, len)
		parse(Data, prefijo, 3, sufijo, 25)
		if(equali(prefijo,"##"))
		{
			for(new y = x + 1; y < x + 10; y++)
			{
				read_file(FileSpr, y, Data, 127, len)
				if(equali(Data,""))
					continue

				x = y - 1
				break;
			}

			if(equali(sufijo,EXPLOSIONGOL))
			{
				parse(Data, SSprite[0], 127)
				formatex(DirectSprite, 127, "sprites/sj_pro/sprite_02.spr", SSprite[0])
				fire = engfunc( EngFunc_PrecacheModel, DirectSprite)
			}
			else if(equali(sufijo,EFECTOHUMO))
			{
				parse(Data, SSprite[1], 127)
				formatex(DirectSprite, 127, "sprites/sj_pro/sprite_03.spr", SSprite[1])
				smoke = engfunc( EngFunc_PrecacheModel, DirectSprite)
			}
			else if(equali(sufijo,POWERPLAY))
			{
				parse(Data, SSprite[2], 127)
				formatex(DirectSprite, 127, "sprites/sj_pro/sprite_04.spr", SSprite[2])
				Burn_Sprite = engfunc( EngFunc_PrecacheModel, DirectSprite)
			}
			else if(equali(sufijo,RAYOMASCOTA))
			{
				parse(Data, SSprite[3], 127)
				formatex(DirectSprite, 127, "sprites/sj_pro/sprite_05.spr", SSprite[3])
				g_fxBeamSprite = engfunc( EngFunc_PrecacheModel, DirectSprite)
			}
			else if(equali(sufijo,FESTEJOGOL))
			{
				parse(Data, SSprite[4], 127)
				formatex(DirectSprite, 127, "sprites/sj_pro/sprite_06.spr", SSprite[4])
				SpriteGol = engfunc( EngFunc_PrecacheModel, DirectSprite)
			}
			else if(equali(sufijo,FESTEJOGOLENCONTRA))
			{
				parse(Data, SSprite[5], 127)
				formatex(DirectSprite, 127, "sprites/sj_pro/sprite_07.spr", SSprite[5])
				SpriteGolContra = engfunc( EngFunc_PrecacheModel, DirectSprite)
			}
			else if(equali(sufijo,BOCHABEAM))
			{
				parse(Data, SSprite[6], 127)
				formatex(DirectSprite, 127, "sprites/sj_pro/sprite_08.spr", SSprite[6])
				beamspr = engfunc( EngFunc_PrecacheModel, DirectSprite)
			}
		}
	}*/
}

#define is_user_valid_connected(%1) (1 <= %1 <= maxplayers && is_user_connected(%1))
public plugin_precache() // precache_f
{
	new mapname[64]
	get_mapname(mapname,63)

	new configDir[128]
	get_configsdir(configDir,127)
	
	precache_model("models/gib_skull.mdl")
	precache_model("models/gib_lung.mdl")
	spr_dot = precache_model("sprites/dot.spr")

	//formatex(FileCol,255,"%s/sj_pro/pro-colors.ini",configDir)

	if(equali(mapname,"soccerjam") || (containi(mapname, "sj_") != -1))
	{
		new spawndir[256]
		format(spawndir,255,"%s/sj_pro/spawns",configDir)
		if (!dir_exists(spawndir))
		{
			if (mkdir(spawndir)==0)
			{
				log_amx("Directorio [%s] creado",spawndir)
		    }
			else
			{
				log_error(AMX_ERR_NOTFOUND,"No se puede crear el directorio[%s], los spawns no han sido adaptados.",spawndir)
				pause("ad")
			}
		}

		format(SpawnSjPro, 255, "%s/%s.cfg",spawndir, mapname)

		set_task(6.0,"PossSpawnSjPro")
		
		
		copy(ball, sizeof ball - 1, "models/sj_pro/pelotas/t_ball.mdl")
		copy(SModel[0], charsmax(SModel[]), "t_ball")
		precache_model("models/sj_pro/pelotas/t_ball.mdl")
		
		copy(SModel[1], charsmax(SModel[]), "arquero_ct1")
		precache_model("models/player/arquero_ct1/arquero_ct1.mdl")
		
		copy(SModel[2], charsmax(SModel[]), "arquero_t1")
		precache_model("models/player/arquero_t1/arquero_t1.mdl")
		
		copy(SModel[3], charsmax(SModel[]), "v_arquero")
		precache_model("models/sj_pro/cuchillos/v_arquero.mdl")
		
		copy(SModel[4], charsmax(SModel[]), "p_arquero")
		precache_model("models/sj_pro/cuchillos/p_arquero.mdl")
		
		copy(SModel[5], charsmax(SModel[]), "v_knife")
		//precache_model("models/v_knife.mdl")
		
		copy(SModel[6], charsmax(SModel[]), "p_knife")
		//precache_model("models/p_knife.mdl")
		
		new SZ_Buff[256];
		formatex(SZ_Buff, charsmax(SZ_Buff), "models/player/%s/%s.mdl", M_LEET, M_LEET)
		precache_model(SZ_Buff)
		
		formatex(SZ_Buff, charsmax(SZ_Buff), "models/player/%s/%s.mdl", M_GIGN, M_GIGN)
		precache_model(SZ_Buff)
		
		precache_model("models/rpgrocket.mdl")
	}
	
	load_customization_from_files();
}

PrecacheOther()
{
	precache_model("models/chick.mdl")
	//engfunc( EngFunc_PrecacheModel, "models/chick.mdl")
}

/*====================================================================================================
 [Initialize]

 Purpose:	$$

 Comment:	$$

====================================================================================================*/
public plugin_init()
{
	new EQ = random_num(0, charsmax(NOMBRE_EQUIPOS));
	formatex(EQUIPO_CT, 31, "%s", NOMBRE_EQUIPOS[EQ]);
	
	new JQ = EQ;
	while(EQ == JQ)
	{
		JQ = random_num(0, charsmax(NOMBRE_EQUIPOS));
		formatex(EQUIPO_T, 31, "%s", NOMBRE_EQUIPOS[JQ]);
	}
	
	
	new mapname[64]
	get_mapname(mapname,63)

	PrecacheSprites()

	register_plugin("Soccerjam", VERSION, AUTHOR)

	gmsgTextMsg = get_user_msgid("TextMsg")
	gmsgDeathMsg = get_user_msgid("DeathMsg")
	gmsgShake = get_user_msgid("ScreenShake")

	maxplayers = get_maxplayers()

	if(equali(mapname,"soccerjam"))
	{
		PrecacheOther()
		CreateGoalNets()
		create_wall()
	}
	else if(equali(mapname, "sj_basket_click21") || equali(mapname, "sj_streetbasket")) sj_basket_ell = 1;

	register_event("CurWeapon", "CurWeapon", "be", "1=1")
	register_event("HLTV", "Event_StartRound", "a", "1=0", "2=0")
	register_event("Damage", "Event_Damage", "b", "2!0", "3=0", "4!0" )
	//register_event("DeathMsg", "Event_DeathMsg", "a")
	
	new const WEAPON_COMMANDS[][] =	{
		"buy", "buyammo1", "buyammo2", "cl_autobuy", "cl_rebuy", "cl_setautobuy", "cl_setrebuy", "usp", "glock", "deagle", "p228", "elites", "fn57", "m3", "xm1014", "mp5", "tmp", "p90", "mac10", "ump45", "ak47", "galil", "famas", "sg552", "m4a1", "aug", "scout", "awp", "g3sg1",
		"sg550", "m249", "vest", "vesthelm", "flash", "hegren", "sgren", "defuser", "nvgs", "shield", "primammo", "secammo", "km45", "9x19mm", "nighthawk", "228compact", "fiveseven", "12gauge", "autoshotgun", "mp", "c90", "cv47", "defender", "clarion", "krieg552", "bullpup", "magnum",
		"d3au1", "krieg550", "smg"
	};
	
	new i;
	for(i = 0; i < sizeof(WEAPON_COMMANDS); ++i) {
		register_clcmd(WEAPON_COMMANDS[i], "clcmd_BlockCommand");
	}

	register_clcmd("say /atajo", "cmdKeeper")
	register_clcmd("say_team /atajo", "cmdKeeper")
	
	register_clcmd("say /flash", "cmdFlash")
	register_clcmd("say_team /flash", "cmdFlash")

	register_clcmd("say /noatajo", "cmdUnKeeper")
	register_clcmd("say_team /noatajo", "cmdUnKeeper")
	
	register_clcmd("jointeam", "clcmd_changeteam")
	register_clcmd("chooseteam", "clcmd_changeteam")
	
	register_clcmd("say /pos", "clcmd_position")
	register_clcmd("buyequip", "show_menu_poss")
	
	register_impulse(201, "clcmd_Block");
	
	register_concmd("sj_give_xp", "cmd_give_xp")
	register_concmd("sj_start", "cmd_start_partido")
	register_concmd("sj_pause", "cmd_ppause")
	register_concmd("sj_unpause", "cmd_unpause")
	
	register_menucmd(register_menuid("Menu de cámaras"), 1023, "setview")
	register_clcmd("say /camara", "chooseview")
	register_clcmd("say_team /camara", "chooseview")
	register_clcmd("say /cam", "chooseview")
	register_clcmd("say_team /cam", "chooseview")
	
	register_concmd("records", "records")
	register_concmd("allrecords", "allrecords")
	
	register_concmd("sj_vote_arquero", "cmd_vote_keeper")
	register_menucmd(register_menuid("Menu_Vote_Keeper"), (1 << 0) | (1 << 1), "MENU_VoteKeeper");
	
	RegisterHam(Ham_Spawn, "player", "fw_PlayerSpawn_Post", 1)
	register_forward(FM_SetClientKeyValue, "fw_SetClientKeyValue")
	register_forward(FM_ClientUserInfoChanged, "fw_ClientUserInfoChanged")
	register_forward(FM_PlayerPreThink, "FW_PlayerPreThink")

	//CVAR_DISTANCE_FOR_KILL = register_cvar("sj_distance_for_kill", "1500")
	CVAR_KICK = register_cvar("sj_kick", "650")
	CVAR_GOLES_EN_CONTRA = register_cvar("sj_golesencontra", "0")
	CVAR_AAA_FULL = register_cvar("sj_aaa_full_exp", "0")
	CVAR_DIFFERENCE_GOALS = register_cvar("sj_golesdiferencia", "20")
	
	g_pCVAR_PossArea = register_cvar("sj_poss_area", "0");
	g_pCVAR_PossArea_Distance = register_cvar("sj_poss_area_distance", "500");
	
	register_clcmd("sj_arco_arco", "asdas3214xcxcxc", _, "")
	register_clcmd("sj_basket", "asdas3214xcxcxd", _, "")
	
	/*register_touch(y_Classname,"player",			"limitet")
	register_touch(z_Classname,"player",			"limitect")
	
	register_touch(p_Classname,"player",			"tocoarcot")
	register_touch(g_Classname,"player",			"tocoarcoct")*/

	register_touch("PwnBall", "player", 			"touchPlayer")
	register_touch("PwnBall", "soccerjam_goalnet",	"touchNet")

	register_touch("PwnBall", "worldspawn",			"touchWorld")
	register_touch("PwnBall", "func_wall",			"touchWorld")
	register_touch("PwnBall", "func_door",			"touchWorld")
	register_touch("PwnBall", "func_door_rotating", "touchWorld")
	register_touch("PwnBall", "func_wall_toggle",	"touchWorld")
	register_touch("PwnBall", "func_breakable",		"touchWorld")
	register_touch("PwnBall", "Blocker",			"touchBlocker")
	
	RegisterHam(Ham_Killed, "player", "fw_PlayerKilled");

	set_task(0.4,"meter",0,_,_,"b")
	set_task(0.5,"statusDisplay",7654321,"",0,"b")

	set_task(1.0, "AutoRestart")
	
	register_menu("Upgrades_ALL", MENU_KEY_1|MENU_KEY_2|MENU_KEY_3|MENU_KEY_4|MENU_KEY_5|MENU_KEY_6|MENU_KEY_7|MENU_KEY_8|MENU_KEY_9|MENU_KEY_0, "menu_upg")

	register_think("PwnBall","ball_think")
	register_think("Mascot", "mascot_think")

	register_clcmd("radio1", 		"LeftDirection",  0)
	register_clcmd("radio2",		"RightDirection", 0)
	register_clcmd("drop",			"Turbo")
	register_clcmd("lastinv",		"BuyUpgrade")
	register_clcmd("fullupdate",	"fullupdate")
	
	register_forward(FM_CmdStart, "fw_CmdStart")

	register_message(gmsgTextMsg, 	"editTextMsg")

	lConfig()
	
	g_MsgHudFinal = CreateHudSyncObj();
	g_MsgHudRecord = CreateHudSyncObj();
	
	register_menucmd(register_menuid("AMX Choose nextmap"), (-1 ^ (-1 << (DEF_SELECTMAPS + 2))), "MENU_CountVote");
	
	g_aMapName = ArrayCreate(32);
	
	get_localinfo("lastMap", g_LastMap, 31)
	set_localinfo("lastMap", "")
	
	set_task(1.0, "reduce_fat_fast", 987654, _, _, "a", (g_time_rest_min * 60) + 10)
	set_task(337.0, "check_this_out", _, _, _, "b")
	
	set_cvar_num("sj_kick", 650);
	set_cvar_num("sj_golesencontra", 0);
	set_cvar_num("sj_aaa_full_exp", 0);
	
	
	register_menu("MainMenu", -1, "MainMenuAction", 0)
	register_menu("EditMenu", -1, "EditMenuAction", 0)
	register_menu("KillMenu", -1, "KillMenuAction", 0)
	
	// Menu
	register_clcmd("walkguardmenu", "InitWalkGuard", _, " - open the WalkGuard-Menu")
	register_clcmd("sj_aaa", "InitSJAAA", _, "")
	
	cvars[0] = register_cvar("push", "240.0");
	cvars[1] = register_cvar("pushdiv", "10.0");

	// Sprache
	register_dictionary("walkguard.txt")

	// Einstelleungen der Variablen laden
	register_logevent("Event_RoundStart", 2, "1=Round_Start")
	register_logevent("Event_RoundEnd", 2, "1=Round_End")

	register_forward(FM_Touch, "fw_touch")
	register_forward(FM_Think, "fw_think")

	// Zonen nachladen
	set_task(1.0, "LoadWGZ")
}

public fw_CmdStart(id, handle)
{
	if(!is_user_alive(id))
		return;
	
	if(get_pcvar_num(CVAR_AAA_FULL))
		return;
	
	static button, old_button;
	button = get_uc(handle, UC_Buttons)
	old_button = entity_get_int(id, EV_INT_oldbuttons)
	
	if(button & IN_RELOAD && !(old_button & IN_RELOAD))
	{
		if(user_is_keeper[id] && (CT_keeper[id] || T_keeper[id]))
		{
			if(id != ballholder)
			{
				CC(id, "!g[SJ]!y Debes tener la pelota para poder usar SUPER FUERZA");
				return;
			}
			
			if(g_timesp[get_user_team(id)-1])
			{
				CC(id, "!g[SJ]!y Solo se puede usar este poder cada 5 minutos");
				return;
			}
			
			g_sp = 1;
			set_cvar_num("sj_kick", get_pcvar_num(CVAR_KICK) + 650);
			
			get_user_name(id, g_namename, 31);
			client_print(0, print_center, "%s ACTIVÓ LA SUPER FUERZA", g_namename);
			set_task(1.0, "peteeeroe", _, _, _, "a", 1);
			
			g_timesp[get_user_team(id)-1] = 1;
			
			if(get_user_team(id) == 1)
			{
				remove_task(TASK_FSP_1);
				set_task(300.0, "fn_final_sp1", TASK_FSP_1);
			}
			else
			{
				remove_task(TASK_FSP_2);
				set_task(300.0, "fn_final_sp2", TASK_FSP_2);
			}
		}
		else if((g_Experience[id] - 5639) < 0) CC(id, "!g[SJ]!y Necesitas más experiencia para usar la !gSUPER FUERZA!y");
		else
		{
			if(id != ballholder)
			{
				CC(id, "!g[SJ]!y Debes tener la pelota para poder usar SUPER FUERZA");
				return;
			}
			
			g_Experience[id] -= 5639;
			
			g_sp = 1;
			set_cvar_num("sj_kick", get_pcvar_num(CVAR_KICK) + 650);
			
			get_user_name(id, g_namename, 31);
			client_print(0, print_center, "%s ACTIVÓ LA SUPER FUERZA", g_namename);
			set_task(1.0, "peteeeroe", _, _, _, "a", 1);
		}
	}
}


public clcmd_position(id)
{
	new Float:Origin[3]
	pev(id, pev_origin, Origin);
	
	client_print(id, print_console, "%f , %f , %f", Origin[0], Origin[1], Origin[2])
	
	return PLUGIN_HANDLED;
}
public check_this_out() CC(0, "!g[SJ]!y Tu arquero no ataja bien? Inicia una votación con el comando: sj_vote_arquero ^"nombre o #id^"");

new g_new_score[TEAMS]
public soccer_finish()
{
	moveBall(0)
	
	saca_el_team = 0;
	
	g_time_rest_min = 0
	
	play_wav(0, SoundDirect[20])
	
	if((score[1] + g_new_score[1]) > (score[2] + g_new_score[2])) g_team_winner = 1
	else if((score[2] + g_new_score[2]) > (score[1] + g_new_score[1])) g_team_winner = 2
	else g_team_winner = -1
	
	set_cvar_num("sv_restart", 1)
	
	for(new i = 1; i <= maxplayers; i++)
	{
		if(!is_user_connected(i)) continue;
		set_task(0.2, "displayWinnerAwards", i + TASK_FINISH, _, _, "b")
	}
	
	get_configsdir(sz_MapsIniFile, charsmax(sz_MapsIniFile));
	format(sz_MapsIniFile, charsmax(sz_MapsIniFile), "%s/maps.ini", sz_MapsIniFile);
	
	if(!file_exists(sz_MapsIniFile))
		get_cvar_string("mapcyclefile", sz_MapsIniFile, charsmax(sz_MapsIniFile));
	
	if(fnLoadSetting(sz_MapsIniFile))
		set_task(0.1, "voteMaps");
}
public reduce_fat_fast()
{
	g_time_rest_sec--
	if(g_time_rest_sec == 0)
	{
		if((g_time_rest_min * 2) == g_time_total)
		{
			g_change_teams = 1
			g_half_time = 11
			set_task(1.0, "NOTICE_HEAD_SHOULDER", _, _, _, "a", 11)
			
			remove_task(TASK_FSP_1);
			remove_task(TASK_FSP_2);
			
			g_sp = 0;
			g_timesp = {0, 0};
			
			if(!get_pcvar_num(CVAR_AAA_FULL))
				set_cvar_num("sj_kick", 650)
			
			g_ball_in_arc = 0
			remove_task(99999)
			
			moveBall(0)
			
			change_poss()
			
			new buff_score
			buff_score = score[T]
			
			score[T] = score[CT]
			score[CT] = buff_score
			
			play_wav(0, SoundDirect[26])
			
			new i_IsOldCT[33];
			new i;
			new currentmodel[128], tempmodel[128], already_has_model	
			
			for(i = 1; i <= maxplayers; i++) // CT > TT
			{
				if(!is_user_connected(i)) continue;
				if(get_user_team(i) != 2) continue;
				
				if(CT_keeper[i] && user_is_keeper[i])
					cmdUnKeeper_TIME(i)
				
				cs_set_user_team(i, 1);
				
				remove_task(i+TASK_MODEL)
				fm_cs_get_user_model(i, currentmodel, charsmax(currentmodel))
				already_has_model = false
				
				copy(tempmodel, sizeof tempmodel - 1, M_LEET)
				if (equal(currentmodel, tempmodel)) already_has_model = true
				if (!already_has_model)
				{
					copy(g_playermodel[i], sizeof g_playermodel[] - 1, tempmodel)
					fm_user_model_update(i+TASK_MODEL)
				}
				
				i_IsOldCT[i] = 1;
			}
			for(i = 1; i <= maxplayers; i++) // TT > CT
			{
				if(!is_user_connected(i)) continue;
				if(get_user_team(i) != 1) continue;
				if(i_IsOldCT[i]) continue;
				
				if(T_keeper[i] && user_is_keeper[i])
					cmdUnKeeper_TIME(i)
				
				cs_set_user_team(i, 2);
				
				remove_task(i+TASK_MODEL)
				fm_cs_get_user_model(i, currentmodel, charsmax(currentmodel))
				already_has_model = false
				
				copy(tempmodel, sizeof tempmodel - 1, M_GIGN)
				if (equal(currentmodel, tempmodel)) already_has_model = true
				if (!already_has_model)
				{
					copy(g_playermodel[i], sizeof g_playermodel[] - 1, tempmodel)
					fm_user_model_update(i+TASK_MODEL)
				}
			}
			
			new sEquipName[32];
			copy(sEquipName, 31, EQUIPO_CT);
			
			copy(EQUIPO_CT, 31, EQUIPO_T);
			copy(EQUIPO_T, 31, sEquipName);
			
			set_cvar_num("sv_restart", 1)
		}
		
		new buff_gtrm = g_time_rest_min
		if(--buff_gtrm == -1)
		{
			soccer_finish()
			return;
		}
	
		g_time_rest_sec = 59
		g_time_rest_min--
	}
}

public NOTICE_HEAD_SHOULDER()
{
	g_half_time--
	g_time_rest_sec++
	if(g_half_time < 1) g_half_time = 0
	switch(g_half_time)
	{
		case 0:
		{
			g_half_time = 0
			client_print(0, print_center, "SEGUNDO TIEMPO... A JUGAR")
			
			moveBall(1)
			
			play_wav(0, SoundDirect[26])
		}
		default: client_print(0, print_center, "SEGUNDO TIEMPO EN %d SEGUNDO%s", g_half_time, (g_half_time != 1) ? "S" : "")
	}
}

public plugin_end()
{
	new sz_CurrentMap[32];

	get_mapname(sz_CurrentMap, charsmax(sz_CurrentMap));
	set_localinfo("lastMap", sz_CurrentMap);
}

/*====================================================================================================
 [Initialize Entities]

 Purpose:	Handles our custom entities, created with Valve Hammer, and fixes for soccerjam.bsp.

 Comment:	$$

====================================================================================================*/
public pfn_keyvalue(entid) {

	new classname[MAX_PLAYER + 1], key[MAX_PLAYER + 1], value[MAX_PLAYER + 1]
	copy_keyvalue(classname, MAX_PLAYER, key, MAX_PLAYER, value, MAX_PLAYER)

	new temp_origins[3][10], x, team
	new temp_angles[3][10]

	if(equal(key, "classname") && equal(value, "soccerjam_goalnet"))
		DispatchKeyValue("classname", "func_wall")

	if(equal(classname, "game_player_equip")){
		if(!gamePlayerEquip)
			gamePlayerEquip = entid
		else {
			remove_entity(entid)
		}
	}
	else if(equal(classname, "func_wall"))
	{
		if(equal(key, "team"))
		{
			team = str_to_num(value)
			if(team == 1 || team == 2) {
				GoalEnt[team] = entid
				set_task(1.0, "FinalizeGoalNet", team)
			}
		}
	}
	else if(equal(classname, "soccerjam_mascot"))
	{

		if(equal(key, "team"))
		{
			team = str_to_num(value)
			create_mascot(team)
		}
		else if(equal(key, "origin"))
		{
			parse(value, temp_origins[0], 9, temp_origins[1], 9, temp_origins[2], 9)
			for(x=0; x<3; x++)
				MascotsOrigins[x] = floatstr(temp_origins[x])
		}
		else if(equal(key, "angles"))
		{
			parse(value, temp_angles[0], 9, temp_angles[1], 9, temp_angles[2], 9)
			for(x=0; x<3; x++)
				MascotsAngles[x] = floatstr(temp_angles[x])
		}
	}
	else if(equal(classname, "soccerjam_teamball"))
	{
		if(equal(key, "team"))
		{
			team = str_to_num(value)
			for(x=0; x<3; x++)
				TeamBallOrigins[team][x] = TEMP_TeamBallOrigins[x]
		}
		else if(equal(key, "origin"))
		{
			parse(value, temp_origins[0], 9, temp_origins[1], 9, temp_origins[2], 9)
			for(x=0; x<3; x++)
				TEMP_TeamBallOrigins[x] = floatstr(temp_origins[x])
		}
	}
	else if(equal(classname, "soccerjam_ballspawn"))
	{
		if(equal(key, "origin")) {
			create_Game_Player_Equip()

			PrecacheBall()
			PrecacheSounds()

			if(ballspawncount < 5) {
				parse(value, temp_origins[0], 9, temp_origins[1], 9, temp_origins[2], 9)

				BallSpawnOrigin[ballspawncount][0] = floatstr(temp_origins[0])
				BallSpawnOrigin[ballspawncount][1] = floatstr(temp_origins[1])
				BallSpawnOrigin[ballspawncount][2] = floatstr(temp_origins[2]) + 10.0

				ballspawncount++
			}
		}
	}
}

createball() {

	new entity = create_entity("info_target")
	if (entity) {

		entity_set_string(entity,EV_SZ_classname,"PwnBall")
		entity_set_model(entity, ball)

		entity_set_int(entity, EV_INT_solid, SOLID_BBOX)
		entity_set_int(entity, EV_INT_movetype, MOVETYPE_BOUNCE)

		new Float:MinBox[3]
		new Float:MaxBox[3]
		MinBox[0] = -15.0
		MinBox[1] = -15.0
		MinBox[2] = 0.0
		MaxBox[0] = 15.0
		MaxBox[1] = 15.0
		MaxBox[2] = 12.0

		entity_set_vector(entity, EV_VEC_mins, MinBox)
		entity_set_vector(entity, EV_VEC_maxs, MaxBox)

		glow(entity,BallColors[0],BallColors[1],BallColors[2],10)


		entity_set_float(entity,EV_FL_framerate,0.0)
		entity_set_int(entity,EV_INT_sequence,0)
	}
	//save our entity ID to aball variable
	aball = entity
	entity_set_float(entity,EV_FL_nextthink,halflife_time() + 0.01) // CAMBIO IMPORTANTE(0.05)
	return PLUGIN_HANDLED
}

public cambiarmove(param)
{
	entity_set_int(aball,EV_INT_sequence,param)
}

public cambiarframe(Float:param)
{
	entity_set_float(aball,EV_FL_framerate,param)
}

CreateGoalNets() {

	new endzone, x
	new Float:orig[3]
	new Float:MinBox[3], Float:MaxBox[3]

	for(x=1;x<3;x++) {
		endzone = create_entity("info_target")
		if (endzone) {

			entity_set_string(endzone,EV_SZ_classname,"soccerjam_goalnet")
			entity_set_model(endzone, "models/chick.mdl")
			entity_set_int(endzone, EV_INT_solid, SOLID_BBOX)
			entity_set_int(endzone, EV_INT_movetype, MOVETYPE_NONE)

			MinBox[0] = -25.0;	MinBox[1] = -145.0;	MinBox[2] = -36.0
			MaxBox[0] =  25.0;	MaxBox[1] =  145.0;	MaxBox[2] =  70.0

			entity_set_vector(endzone, EV_VEC_mins, MinBox)
			entity_set_vector(endzone, EV_VEC_maxs, MaxBox)

			switch(x) {
				case 1: {
					orig[0] = 2110.0
					orig[1] = 0.0
					orig[2] = 1604.0
				}
				case 2: {
					orig[0] = -2550.0
					orig[1] = 0.0
					orig[2] = 1604.0
				}
			}

			entity_set_origin(endzone,orig)

			entity_set_int(endzone, EV_INT_team, x)
			set_entity_visibility(endzone, 0)
			GoalEnt[x] = endzone
		}
	}

}

create_wall() {
	new wall = create_entity("func_wall")
	if(wall)
	{
		new Float:orig[3]
		new Float:MinBox[3], Float:MaxBox[3]
		entity_set_string(wall,EV_SZ_classname,"Blocker")
		entity_set_model(wall, "models/chick.mdl")

		entity_set_int(wall, EV_INT_solid, SOLID_BBOX)
		entity_set_int(wall, EV_INT_movetype, MOVETYPE_NONE)

		MinBox[0] = -72.0;	MinBox[1] = -100.0;	MinBox[2] = -72.0
		MaxBox[0] =  72.0;	MaxBox[1] =  100.0;	MaxBox[2] =  72.0

		entity_set_vector(wall, EV_VEC_mins, MinBox)
		entity_set_vector(wall, EV_VEC_maxs, MaxBox)

		orig[0] = 2355.0
		orig[1] = 1696.0
		orig[2] = 1604.0
		entity_set_origin(wall,orig)
		set_entity_visibility(wall, 0)
	}
}

create_mascot(team)
{
	new Float:MinBox[3], Float:MaxBox[3]
	new mascot = create_entity("info_target")
	if(mascot)
	{
		PrecacheMonsters(team)
		entity_set_string(mascot,EV_SZ_classname,"Mascot")
		entity_set_model(mascot, TeamMascots[team-1])
		Mascots[team] = mascot

		entity_set_int(mascot, EV_INT_solid, SOLID_NOT)
		entity_set_int(mascot, EV_INT_movetype, MOVETYPE_NONE)
		entity_set_int(mascot, EV_INT_team, team)
		MinBox[0] = -16.0;	MinBox[1] = -16.0;	MinBox[2] = -72.0
		MaxBox[0] =  16.0;	MaxBox[1] =  16.0;	MaxBox[2] =  72.0
		entity_set_vector(mascot, EV_VEC_mins, MinBox)
		entity_set_vector(mascot, EV_VEC_maxs, MaxBox)
		//orig[2] += 200.0

		entity_set_origin(mascot,MascotsOrigins)
		entity_set_float(mascot,EV_FL_animtime,2.0)
		entity_set_float(mascot,EV_FL_framerate,1.0)
		entity_set_int(mascot,EV_INT_sequence,0)

		if(team == 2)
			entity_set_byte(mascot, EV_BYTE_controller1, 115)

		entity_set_vector(mascot,EV_VEC_angles,MascotsAngles)
		entity_set_float(mascot,EV_FL_nextthink,halflife_time() + 1.0)
	}
}

create_Game_Player_Equip() {
	gamePlayerEquip = create_entity("game_player_equip")
	if(gamePlayerEquip) {
		//DispatchKeyValue(gamePlayerEquip, "weapon_knife", "1")
		//DispatchKeyValue(entity, "weapon_scout", "1")
		DispatchKeyValue(gamePlayerEquip, "targetname", "roundstart")
		DispatchSpawn(gamePlayerEquip)
	}

}

public FinalizeGoalNet(team)
{
	new golnet = GoalEnt[team]
	entity_set_string(golnet,EV_SZ_classname,"soccerjam_goalnet")
	entity_set_int(golnet, EV_INT_team, team)
	set_entity_visibility(golnet, 0)
}

public RightDirection(id) 
{
	if(id == ballholder) {

		direction--
		if(direction < -(ConfigPro[11]))
			direction = -(ConfigPro[11])
		new temp = direction * ConfigPro[9]
		SendCenterText( id, temp );

	}
	else
		CC(id, "!g[SJ]!y Debes tener la pelota para poder darle efecto");
		
	return PLUGIN_HANDLED
}

public LeftDirection(id) 
{
	if(id == ballholder) {
		direction++
		if(direction > ConfigPro[11])
			direction = ConfigPro[11]
		new temp = direction * ConfigPro[9]
		SendCenterText( id, temp );

	}
	else
		CC(id, "!g[SJ]!y Debes tener la pelota para poder darle efecto");
		
	return PLUGIN_HANDLED
}


SendCenterText( id, dir )
{
	if(dir < 0)
		client_print(id, print_center, "%d grados a la derecha", (dir<0?-(dir):dir));
	else if(dir == 0)
		client_print(id, print_center, "0 grados");
	else if(dir > 0)
		client_print(id, print_center, "%d grados a la izquierda", (dir<0?-(dir):dir));
}

public plugin_cfg()
{
	lConfig()
}

public plugin_natives()
{
	// External additions natives
	register_native("sj_arquero", "native_sj_arquero", 1)
	register_native("sj_arquero_t", "native_sj_arquero_t", 1)
	register_native("sj_arquero_ct", "native_sj_arquero_ct", 1)
	register_native("sj_ballin", "native_sj_ballin", 1)
	register_native("sj_ball_in_arc", "native_sj_ball_in_arc", 1)
	register_native("sj_ball_none", "native_sj_ball_none", 1)
}

public native_sj_arquero(id) return user_is_keeper[id];
public native_sj_arquero_t(id) return T_keeper[id];
public native_sj_arquero_ct(id) return CT_keeper[id];
public native_sj_ballin(id) return g_ballin[id];
public native_sj_ball_in_arc() return g_ball_in_arc;
public native_sj_ball_none() return g_ball_none;

/*====================================================================================================
 [Ball Brain]

 Purpose:	These functions help control the ball and its activities.

 Comment:	$$

====================================================================================================*/
public ball_think() {

	if(is_valid_ent(aball))
	{
		new Float:gametime = get_gametime()
		if(PowerPlay >= MAX_LVL_POWERPLAY && gametime - fire_delay >= 0.3)
			on_fire()

		if(ballholder > 0)
		{

			new team = get_user_team(ballholder)
			entity_get_vector(ballholder, EV_VEC_origin,testorigin)
			if(!is_user_alive(ballholder)) {

				new tname[MAX_PLAYER + 1]
				get_user_name(ballholder,tname, MAX_PLAYER)

				remove_task(55555)
				set_task(30.0,"clearBall",55555)
				
				g_ball_in_arc = 0
				g_ball_none = 0
				
				remove_task(99999)

				if(!g_sprint[ballholder])
					set_speedchange(ballholder)

				format(temp1,63,"[%s] [%s] Fue desarmado!", team == 1 ? EQUIPO_T : EQUIPO_CT, tname)
				
				if(g_sp)
				{
					g_sp = 0;
					set_cvar_num("sj_kick", get_pcvar_num(CVAR_KICK) - 650);
				}

				//remove glow of owner and set ball velocity really really low
				glow(ballholder,0,0,0,0)

				ballowner = ballholder
				ballholder = 0

				testorigin[2] += 5
				entity_set_origin(aball, testorigin)

				new Float:vel[3], x
				for(x=0;x<3;x++)
					vel[x] = 1.0

				entity_set_vector(aball,EV_VEC_velocity,vel)
				entity_set_float(aball,EV_FL_nextthink,halflife_time() + 0.01) // CAMBIO IMPORTANTE(0.05)
				return PLUGIN_HANDLED
			}
			if(entity_get_int(aball,EV_INT_solid) != SOLID_NOT)
				entity_set_int(aball, EV_INT_solid, SOLID_NOT)

			//Put ball in front of player
			ball_infront(ballholder, 55.0)
			new i
			for(i=0;i<3;i++)
				velocity[i] = 0.0
			//Add lift to z axis
			new flags = entity_get_int(ballholder, EV_INT_flags)
			if(flags & FL_DUCKING)
				testorigin[2] -= 10
			else
				testorigin[2] -= 30

			entity_set_vector(aball,EV_VEC_velocity,velocity)
	  		entity_set_origin(aball,testorigin)
		}
		else {
			if(entity_get_int(aball,EV_INT_solid) != SOLID_BBOX)
				entity_set_int(aball, EV_INT_solid, SOLID_BBOX)
		}
	}
	entity_set_float(aball,EV_FL_nextthink,halflife_time() + 0.01) // CAMBIO IMPORTANTE(0.05)
	return PLUGIN_HANDLED
}

moveBall(where, team=0, set=0) {

	if(is_valid_ent(aball)) {
		if(team) {
			new Float:bv[3]
			bv[2] = 50.0
			entity_set_origin(aball, TeamBallOrigins[team])
			entity_set_vector(aball,EV_VEC_velocity,bv)
		}
		else if(set)
		{
			new i;
			new iUsers[33];
			new iCount = -1;
			new iRandomUser;
			
			for(i = 1; i <= maxplayers; i++)
			{
				if(!is_user_alive(i))
					continue;
				
				if(get_user_team(i) == 1 && set == 2)
					continue;
				
				if(get_user_team(i) == 2 && set == 1)
					continue;
				
				iUsers[++iCount] = i;
			}
			
			if(iCount != -1)
			{
				iRandomUser = iUsers[random_num(0, iCount)];
				
				new Float:vecOrigin[3];
				entity_get_vector(iRandomUser, EV_VEC_origin, vecOrigin);
				
				new Float:bv[3]
				bv[2] = 400.0
				entity_set_origin(aball, vecOrigin)
				entity_set_vector(aball,EV_VEC_velocity,bv)
				
				PowerPlay = 0
				ballholder = 0
				ballowner = 0
			}
			else
			{
				new Float:v[3], rand
				v[2] = 400.0
				if(ballspawncount > 1)
					rand = random_num(0, ballspawncount-1)
				else
					rand = 0

				entity_set_origin(aball, BallSpawnOrigin[rand])
				entity_set_vector(aball, EV_VEC_velocity, v)

				PowerPlay = 0
				ballholder = 0
				ballowner = 0
			}
		}
		else
		{
			switch(where) {
				case 0: { //outside map

					new Float:orig[3], x
					for(x=0;x<3;x++)
						orig[x] = -9999.9
					entity_set_origin(aball,orig)
					ballholder = -1
				}
				case 1: { //at middle

					new Float:v[3], rand
					v[2] = 400.0
					if(ballspawncount > 1)
						rand = random_num(0, ballspawncount-1)
					else
						rand = 0

					entity_set_origin(aball, BallSpawnOrigin[rand])
					entity_set_vector(aball, EV_VEC_velocity, v)

					PowerPlay = 0
					ballholder = 0
					ballowner = 0
				}
			}
		}
	}
}

public ball_infront(id, Float:dist) {

	new Float:nOrigin[3]
	new Float:vAngles[3] // plug in the view angles of the entity
	new Float:vReturn[3] // to get out an origin fDistance away

	entity_get_vector(aball,EV_VEC_origin,testorigin)
	entity_get_vector(id,EV_VEC_origin,nOrigin)
	entity_get_vector(id,EV_VEC_v_angle,vAngles)

//	set_change_ball(0, 0.0)

	vReturn[0] = floatcos( vAngles[1], degrees ) * dist
	vReturn[1] = floatsin( vAngles[1], degrees ) * dist

	vReturn[0] += nOrigin[0]
	vReturn[1] += nOrigin[1]

	testorigin[0] = vReturn[0]
	testorigin[1] = vReturn[1]
	testorigin[2] = nOrigin[2]

	/*
	//Sets the angle to face the same as the player.
	new Float:ang[3]
	entity_get_vector(id,EV_VEC_angles,ang)
	ang[0] = 0.0
	ang[1] -= 90.0
	ang[2] = 0.0
	entity_set_vector(aball,EV_VEC_angles,ang)
	*/

}


public CurveBall(id) {
	if(direction && get_speed(aball) > 5 && curvecount > 0) {

		new Float:dAmt = float((direction * ConfigPro[9]) / ConfigPro[12]);
		new Float:v[3], Float:v_forward[3];

		entity_get_vector(aball, EV_VEC_velocity, v);
		vector_to_angle(v, BallSpinDirection);

		BallSpinDirection[1] = normalize( BallSpinDirection[1] + dAmt );
		BallSpinDirection[2] = 0.0;

		angle_vector(BallSpinDirection, 1, v_forward);

		new Float:speed = vector_length(v)// * 0.95;
		v[0] = v_forward[0] * speed
		v[1] = v_forward[1] * speed

		entity_set_vector(aball, EV_VEC_velocity, v);

		curvecount--;
		set_task(0.14, "CurveBall", id);
	}
}

public clearBall()
{
//	play_wav(0, BALL_RESPAWN);
	play_wav(0, SoundDirect[15]);
	format(temp1,63,"La bocha RESPAWNEO en el centro de la cancha!")
	
	if(g_sp)
	{
		g_sp = 0;
		set_cvar_num("sj_kick", get_pcvar_num(CVAR_KICK) - 650);
	}
	
	moveBall(1)
}

/*====================================================================================================
 [Mascot Think]

 Purpose:	$$

 Comment:	$$

====================================================================================================*/
public mascot_think(mascot)
{
	new team = entity_get_int(mascot, EV_INT_team)
	
	new id, playerteam, dist
	for(id=1 ; id<=maxplayers ; id++)
	{
		if(is_user_alive(id) && !is_user_bot(id))
		{
			playerteam = get_user_team(id)
			if(playerteam != team)
			{
				dist = get_entity_distance(id, mascot)
				if(dist < 650) // CVAR_GOALSAFETY
					TerminatePlayer(id, mascot, team, ( ballholder == id ? 500.0 : random_float(5.0, 15.0) ) )
			}
			else if(get_pcvar_num(g_pCVAR_PossArea) && get_pcvar_num(g_pCVAR_PossArea_Distance) && !user_is_keeper[id])
			{
				dist = get_entity_distance(id, mascot)
				if(dist < get_pcvar_num(g_pCVAR_PossArea_Distance))
					TerminatePlayer(id, mascot, team, 1000.0)
			}
		}
	}
	
	entity_set_float(mascot,EV_FL_nextthink,halflife_time() + 1.0)
}

goaly_checker(id, Float:gametime, team) {
	if(!is_user_alive(id) || (gametime - GoalyCheckDelay[id] < ConfigPro[8]) )
		return PLUGIN_HANDLED

	new dist, gcheck
	new Float:pOrig[3]
	entity_get_vector(id, EV_VEC_origin, pOrig)
	dist = floatround(get_distance_f(pOrig, TeamBallOrigins[team]))

	//--/* Goaly Exp System */--//
	if(dist < 600 ) {

		gcheck = GoalyCheck[id]

		if(id == ballholder && gcheck >= 2)
		{
			/*countdown_quitar[id] = 0
			ok_quitar[id] = 0*/
			g_ballin[id] = 0
			g_ball_none = 1
			kickBall(id, 1)
		}
		
		GoalyPoints[id]++

		if(gcheck < 2)
		{
			g_Experience[id] += gcheck * ConfigPro[15]
			g_maxexp[id] += gcheck * ConfigPro[15] 
		}
		else
		{
			g_Experience[id] += gcheck * (ConfigPro[15] / 2)
			g_maxexp[id] += gcheck * (ConfigPro[15] / 2)
		}
		
		if(gcheck < 5)
			GoalyCheck[id]++

		GoalyCheckDelay[id] = gametime
	}
	else
		GoalyCheck[id] = 0
	return PLUGIN_HANDLED
}

/*====================================================================================================
 [Status Display]

 Purpose:	Displays the Scoreboard information.

 Comment:	$$

====================================================================================================*/

public statusDisplay()
{
	new id, team, bteam = get_user_team(ballholder>0?ballholder:ballowner)
	new score_t = (score[T] + g_new_score[T]), score_ct = (score[CT] + g_new_score[CT])

	set_hudmessage(PlayerColors[28], PlayerColors[29], PlayerColors[30], 0.95, 0.20, 0, 1.0, 1.5, 0.1, 0.1, HUD_CHANNEL)
	new Float:gametime = get_gametime()

	for(id=1; id<=maxplayers; id++) {
		if(is_user_connected(id) && !is_user_bot(id))
		{
			team = get_user_team(id)
			goaly_checker(id, gametime, team)
			if(!is_user_alive(id) && !is_dead[id] && (team == 1 || team == 2))
			{
				remove_task(id+1000)
				has_knife[id] = false;
				is_dead[id] = true
				new Float:respawntime = 2.0
				set_task(respawntime,"AutoRespawn",id)
				set_task((respawntime+0.2), "AutoRespawn2",id)
			}
			if(g_team_winner == 0)
			{
				new buffer[64]
				if(g_time_rest_min >= 1 || g_time_rest_sec >= 1)
				{
					formatex(buffer, 63, "Tiempo: %s%d:%s%d", (g_time_rest_min < 10) ? "0" : "", g_time_rest_min, (g_time_rest_sec < 10) ? "0" : "", g_time_rest_sec)
				}
				else formatex(buffer, 63, "FINAL DEL PARTIDO")
				
				format(scoreboard,1024,"%s^n%s - %d  |  %s - %d ^nExperiencia: %d ^n^n%s^n^n^n%s",
				buffer,EQUIPO_T,score_t,EQUIPO_CT,score_ct,g_Experience[id],temp1,team==bteam?temp2:"")
				ShowSyncHudMsg(id, g_MsgHudFinal, "%s",scoreboard)
			}
		}
	}
}


/*====================================================================================================
 [Touched]

 Purpose:	All touching stuff takes place here.

 Comment:	$$

====================================================================================================*/
public touchWorld(ball, world) {

	if(get_speed(ball) > 10)
	{
		new Float:v[3]

		new Float:r

		entity_get_vector(ball, EV_VEC_velocity, v)
		r = entity_get_float(ball, EV_FL_framerate)

		v[0] = (v[0] * 0.85)
		v[1] = (v[1] * 0.85)
		v[2] = (v[2] * 0.85)

		r = (r * 0.50)

		entity_set_float(ball,EV_FL_framerate,r)
		entity_set_int(ball,EV_INT_sequence,2)

		entity_set_vector(ball, EV_VEC_velocity, v)
		emit_sound(ball, CHAN_ITEM, SoundDirect[13], 1.0, ATTN_NORM, 0, PITCH_NORM)
	}
	else
	{
		entity_set_float(ball,EV_FL_framerate,0.0)
		entity_set_int(ball,EV_INT_sequence,0)
	}

	return PLUGIN_HANDLED
}

public set_change_ball(secuencia, Float:frame)
{
	entity_set_float(aball,EV_FL_framerate,frame)
	entity_set_int(aball,EV_INT_sequence,secuencia)
}

public touchPlayer(ball, player) {

	if(is_user_bot(player))
		return PLUGIN_HANDLED

	new playerteam = get_user_team(player)
	if((playerteam != 1 && playerteam != 2))
		return PLUGIN_HANDLED

	remove_task(55555)
	g_ball_in_arc = 0
	g_ball_none = 0
	
	new aname[64], stolen, x
	get_user_name(player,aname,63)
	new ballteam = get_user_team(ballowner)
	if(ballowner > 0 && playerteam != ballteam )
	{
		new speed = get_speed(aball)
		if(speed > 500)
		{
			//configure catching algorithm
			new rnd = random_num(0,100)
			new bstr = (((PlayerUpgrades[ballowner][STR] + g_upg[ballowner][STR]) * ConfigPro[17])) / 10
			new dex = ((PlayerUpgrades[player][DEX] + g_upg[player][DEX]) * ConfigPro[19])
			new pct = ( PressedAction[player] ? 40:20 ) + dex

			pct += ( g_sprint[player] ? 5 : 0 )		//player turboing? give 5%
			pct -= ( g_sprint[ballowner] ? 5 : 0 ) 	//ballowner turboing? lose 5%
			pct -= bstr						//ballowner has strength? remove bstr

			//will player avoid damage?
			if( rnd > pct ) {
				new Float:dodmg = (float(speed) / 13.0) + bstr

				CC(0, "!g[SJ] %s!y fue golpeado por !g%d!y de daño",aname, floatround(dodmg))

				set_msg_block(gmsgDeathMsg,BLOCK_ONCE)
				fakedamage(player,"AssWhoopin",dodmg,1)
				set_msg_block(gmsgDeathMsg,BLOCK_NOT)

				if(!is_user_alive(player))
				{
					message_begin(MSG_ALL, gmsgDeathMsg)
					write_byte(ballowner)
					write_byte(player)
					write_string("AssWhoopin")
					message_end()

					new frags = get_user_frags(ballowner)
					entity_set_float(ballowner, EV_FL_frags, float(frags + 1))
					setScoreInfo(ballowner)
					Event_Record(ballowner, KILL, -1, ConfigPro[2])

					play_wav(0, SoundDirect[19])

					CC(player,"!g[SJ]!y La pelota te golpeo a demasiada velocidad y te mató!")
					CC(ballowner,"!g[SJ]!y Ganaste !g%d!y de experiencia por matar a alguien con la pelota!", ConfigPro[2])
				}
				else
				{
					new Float:pushVel[3]
					pushVel[0] = velocity[0]
					pushVel[1] = velocity[1]
					pushVel[2] = velocity[2] + ((velocity[2] < 0)?random_float(-200.0,-50.0):random_float(50.0,200.0))
					entity_set_vector(player,EV_VEC_velocity,pushVel)
				}
				for(x=0;x<3;x++)
					velocity[x] = (velocity[x] * random_float(0.1,0.9))
				entity_set_vector(aball,EV_VEC_velocity,velocity)
				direction = 0
				return PLUGIN_HANDLED
			}
		}

		if(speed > 950)
		//	play_wav(0, STOLE_BALL_FAST)
			play_wav(0, SoundDirect[11])

		new Float:pOrig[3]
		entity_get_vector(player, EV_VEC_origin, pOrig)
		new dist = floatround(get_distance_f(pOrig, TeamBallOrigins[playerteam]))
		new gainedxp

		if(dist < 550) {
			gainedxp = ConfigPro[1] + ConfigPro[0] + (speed / 8)
			Event_Record(player, STEAL, -1, ConfigPro[1] + ConfigPro[0] + (speed / 8))
			GoalyPoints[player] += ConfigPro[0]/2
		}
		else {
			gainedxp = ConfigPro[1]
			Event_Record(player, STEAL, -1, ConfigPro[1])
		}

		format(temp1,63,"[%s] [%s] Robo la bocha!",playerteam == 1 ? EQUIPO_T : EQUIPO_CT,aname)
		//client_print(0,print_console,"%s",temp1)
		
		if(g_sp)
		{
			g_sp = 0;
			set_cvar_num("sj_kick", get_pcvar_num(CVAR_KICK) - 650);
		}

		stolen = 1

		message_begin(MSG_ONE, gmsgShake, {0,0,0}, player)
		write_short(255 << 12) //ammount
		write_short(1 << 11) //lasts this long
		write_short(255 << 10) //frequency
		message_end()

		CC(player,"!g[SJ]!y Ganaste !g%d!y de experiencia por robar la pelota!", gainedxp)
	}

	if(ballholder == 0)
	{
		emit_sound(aball, CHAN_ITEM, SoundDirect[14], 1.0, ATTN_NORM, 0, PITCH_NORM)
		new msg[64], check

		if(!has_knife[player])
			give_knife(player)

		if(stolen)
			PowerPlay = 0
		else
		{
			format(temp1,63,"[%s] [%s] Agarro la bocha!",playerteam == 1 ? EQUIPO_T : EQUIPO_CT,aname)
			if(g_sp)
			{
				g_sp = 0;
				set_cvar_num("sj_kick", get_pcvar_num(CVAR_KICK) - 650);
			}
		}

		if(((PowerPlay > 1 && powerplay_list[PowerPlay-2] == player) || (PowerPlay > 0 && powerplay_list[PowerPlay-1] == player)) && PowerPlay != MAX_LVL_POWERPLAY)
			check = true

		if(PowerPlay <= MAX_LVL_POWERPLAY && !check) {
			g_Experience[player] += (PowerPlay==2?10:25)
			g_maxexp[player] += (PowerPlay==2?10:25)
			powerplay_list[PowerPlay] = player
			PowerPlay++
		}
		curvecount = 0
		direction = 0
		GoalyCheck[player] = 0

		format(temp2, 63, "POWER PLAY! -- Nivel: %d", PowerPlay>0?PowerPlay-1:0)

		ballholder = player
		ballowner = 0

		if(!g_sprint[player])
			set_speedchange(player)


		set_hudmessage(255, 225, 128, POS_X, 0.4, 1, 1.0, 1.5, 0.1, 0.1, 2)
		format(msg,63,"TENES LA BOCHA!!!")
		show_hudmessage(player,"%s",msg)

		beam()
		
		g_ballin[player] = 1
		g_ball_none = 0
		
		/*countdown_quitar[last_bola] = 0;
		if(countdown_quitar[player] <= 0)
		{
			if(user_is_keeper[player]) countdown_quitar[player] = 15;
			else countdown_quitar[player] = 20;
		}
		
		ok_quitar[player] = 1
		
		bola_t(player)*/
	}

	return PLUGIN_HANDLED
}

public touchNet(ball, goalpost)
{
	remove_task(55555)
	g_ball_in_arc = 0
	g_ball_none = 1

	new team = get_user_team(ballowner)
	new golent[33]
	
	if(!is_user_valid_connected(ballowner))
		return PLUGIN_HANDLED;
	
	golent[ballowner] = GoalEnt[team]
	if (goalpost != golent[ballowner] && ballowner > 0)
	{
		new aname[64]
		new Float:netOrig[3]
		new netOrig2[3]

		entity_get_vector(ball, EV_VEC_origin,netOrig)

		new l
		for(l=0;l<3;l++)
		netOrig2[l] = floatround(netOrig[l])
		flameWave(netOrig2)
		get_user_name(ballowner,aname,63)
		new frags = get_user_frags(ballowner)
		entity_set_float(ballowner, EV_FL_frags, float(frags + 10))

	//	play_wav(0, SCORED_GOAL)
		play_wav(0, SoundDirect[16])

		/////////////////////ASSIST CODE HERE///////////

		new assisters[4] = { 0, 0, 0, 0 }
		new iassisters = 0
		new ilastplayer = iassist[ team ]

		// We just need the last player to kick the ball
		// 0 means it has passed 15 at least once
		if ( ilastplayer == 0 )
			ilastplayer = 15
		else
			ilastplayer--

		if ( assist[ ilastplayer ] != 0 ) {
			new i, x, bool:canadd, playerid
			for(i=0; i<16; i++) {
				// Stop if we've already found 4 assisters
				if ( iassisters == 3 )
					break
				playerid = assist[ i ]
				// Skip if player is invalid
				if ( playerid == 0 )
					continue
				// Skip if kicker is counted as an assister
				if ( playerid == assist[ ilastplayer ] )
					continue

				canadd = true
				// Loop through each assister value
				for(x=0; x<3; x++)
					// make sure we can add them
					if ( playerid == assisters[ x ] ) {
						canadd = false
						break
					}

				// Skip if they've already been added
				if ( canadd == false )
					continue
				// They didn't kick the ball last, and they haven't been added, add them
				assisters[ iassisters++ ] = playerid
			}
			// This gives each person an assist, xp, and prints that out to them
			new c, pass
			for(c=0; c<iassisters; c++) {
				pass = assisters[ c ]
				Event_Record(pass, ASSIST, -1, ConfigPro[3])
				CC( pass, "!g[SJ]!y Ganaste !g%d!y de experiencia por la asistencia hecha!",ConfigPro[3])
			}
		}
		iassist[ 0 ] = 0
		/////////////////////ASSIST CODE HERE///////////

		for(l=0; l<3; l++)
			distorig[1][l] = floatround(netOrig[l])
		new distshot = (get_distance(distorig[0],distorig[1])/12)
		new gainedxp = distshot + ConfigPro[4]

		format(temp1,63,"[%s] [%s] Metio la bocha desde los %d pies!!",team == 1 ? EQUIPO_T : EQUIPO_CT,aname,distshot)
		//client_print(0,print_console,"%s",temp1)
		
		if(g_sp)
		{
			g_sp = 0;
			set_cvar_num("sj_kick", get_pcvar_num(CVAR_KICK) - 650);
		}

		if(distshot > MadeRecord[ballowner][DISTANCE])
			Event_Record(ballowner, DISTANCE, distshot, 0)// record distance, and make that distance exp

		Event_Record(ballowner, GOAL, -1, gainedxp)	//zero xp for goal cause distance is what gives it.
		
		if(g_change_teams) g_new_score[team]++
		else score[team]++

		CC(ballowner,"!g[SJ]!y Ganaste !g%d!y de experiencia por meter un gol desde los !g%d!y pies!",gainedxp,distshot)
		Gol_Sprite(ballowner)

		new oteam = (team == 1 ? 2 : 1)
		increaseTeamXP(team, 75)
		increaseTeamXP(oteam, 50)
		moveBall(0)
		
		saca_el_team = (team == 1) ? 2 : 1;

		new x
		for(x=1; x<=maxplayers; x++) {
			if(is_user_connected(x))
			{
				Event_Record(x, GOALY, GoalyPoints[x], 0)
				new kills = get_user_frags(x)
				new deaths = cs_get_user_deaths(x)
				setScoreInfo(x)
				if( deaths > 0)
					PlayerDeaths[x] = deaths
				if( kills > 0)
					PlayerKills[x] = kills
			}
		}

		// CAMBIAR
		new r = random_num(0,5)
		play_wav(0, SoundDirect[r]);
		server_cmd("sv_restart 4")
		
		new iDif;
		
		if((score[1] + g_new_score[1]) > (score[2] + g_new_score[2]))
			iDif = (score[1] + g_new_score[1]) - (score[2] + g_new_score[2]);
		else if((score[2] + g_new_score[2]) > (score[1] + g_new_score[1]))
			iDif = (score[2] + g_new_score[2]) - (score[1] + g_new_score[1]);
		
		if(iDif >= get_pcvar_num(CVAR_DIFFERENCE_GOALS))
		{
			soccer_finish();
			CC(0,"!g[SJ]!y Borombombom Borombombom... es un afano... suspendanló!!")
			CC(0,"!g[SJ]!y Hay 20 goles de diferencia, el partido se da por finalizado")
		}
	}
	else if(goalpost == golent[ballowner] && get_pcvar_num(CVAR_GOLES_EN_CONTRA)) 
	{
		new aname[64]
		new Float:netOrig[3]
		new netOrig2[3]

		entity_get_vector(ball, EV_VEC_origin,netOrig)
		new l
		for(l=0;l<3;l++)
		netOrig2[l] = floatround(netOrig[l])
		flameWave(netOrig2)
		get_user_name(ballowner,aname,63)
		new frags = get_user_frags(ballowner)
		entity_set_float(ballowner, EV_FL_frags, float(frags - 10))

		for(l=0; l<3; l++)
			distorig[1][l] = floatround(netOrig[l])
		new distshot = (get_distance(distorig[0],distorig[1])/12)
		
		if(g_change_teams) g_new_score[team == 1 ? 2 : 1]++
		else score[team == 1 ? 2 : 1]++

		format(temp1,63,"[%s] [%s] Metio un gol en contra desde los %i pies!!",team == 1 ? EQUIPO_T : EQUIPO_CT,aname,distshot)
		
		saca_el_team = (team == 1) ? 1 : 2;
		
		if(g_sp)
		{
			g_sp = 0;
			set_cvar_num("sj_kick", get_pcvar_num(CVAR_KICK) - 650);
		}

		Event_Record(ballowner, ENCONTRA, -1, 0)

		CC(ballowner,"!g[SJ]!y Perdiste !g200!y de experiencia por hacer un gol en contra desde los !g%d!y pies!", distshot)
		Encontra_Sprite(ballowner)

		new oteam = (team == 1 ? 2 : 1)
		increaseTeamXP(team, -200)
		increaseTeamXP(oteam, 200)
		moveBall(0)

		new x
		for(x=1; x<=maxplayers; x++) 
		{
			if(is_user_connected(x))
			{
				new kills = get_user_frags(x)
				new deaths = cs_get_user_deaths(x)
				setScoreInfo(x)
				if( deaths > 0)
					PlayerDeaths[x] = deaths
				if( kills > 0)
					PlayerKills[x] = kills
			}
		}
		
		// CAMBIAR
		new p = random_num(6,10)
		play_wav(0, SoundDirect[p]);
		server_cmd("sv_restart 4")
	}
	else if(goalpost == golent[ballowner] && !get_pcvar_num(CVAR_GOLES_EN_CONTRA))
	{
		moveBall(0, team)
		set_task(10.0,"clearBall",99999)
		
		g_ball_in_arc = 1
	}

	return PLUGIN_HANDLED
}

//This is for soccerjam.bsp to fix locker room.
public touchBlocker(pwnball, blocker) {
	new Float:orig[3] = { 2234.0, 1614.0, 1604.0 }
	entity_set_origin(pwnball, orig)
}

/*====================================================================================================
 [Events]

 Purpose:	$$

 Comment:	$$

====================================================================================================*/

public Event_Damage()
{
	new victim = read_data(0)
	new attacker = get_user_attacker(victim)
	if(is_user_alive(attacker))
	{
		if(is_user_alive(victim))
		{
			if(victim == ballholder)
			{
				new upgrade = PlayerUpgrades[attacker][DISARM] + g_upg[attacker][DISARM]
				if(upgrade) {
					new disarm = upgrade * ConfigPro[20]
					new disarmpct = ConfigPro[6] + (victim==ballholder?(disarm*2):0)
					new rand = random_num(1,100)

					if(disarmpct >= rand)
					{
						new vname[MAX_PLAYER + 1], aname[MAX_PLAYER + 1]
						get_user_name(victim,vname, MAX_PLAYER)
						get_user_name(attacker,aname, MAX_PLAYER)

						if(victim == ballholder)
						{
							/*countdown_quitar[victim] = 0
							ok_quitar[victim] = 0*/
							
							g_ballin[victim] = 0
							g_ball_none = 1
							
							kickBall(victim, 1)
							Event_Record(attacker, DISARMS, -1, 0)

							CC(attacker,"!g[SJ]!y Hiciste que !g%s!y perdiera la pelota!",vname)
							CC(victim,"!g[SJ]!y Has sido desarmado por !g%s!y!",aname)

							play_wav(victim, SoundDirect[23]);
							play_wav(attacker, SoundDirect[22]);
						}
					}
				}
			}
		}
		else
		{
			g_Experience[attacker] += (ConfigPro[2]/2)
			g_maxexp[attacker] += (ConfigPro[2]/2)
		}
	}
}
/*public Event_DeathMsg()
{
	new victim = read_data(2);
	countdown_quitar[victim] = 0
	ok_quitar[victim] = 0
}*/

public PasarMitadCancha() {
	if(g_aaa)
	{
		CC(0, "!y* !gNo hay goles hace 20 segundos, se puede cruzar mitad de cancha!!y");
		g_cdc = 1;
		
		roundstatus = RS_END
	}
}

public Event_StartRound()
{
	roundstatus = RS_FREEZETIME
	g_cdc = 0;
	
	if(g_aaa)
	{
		remove_task(TASK_PMC);
		set_task(20.0, "PasarMitadCancha", TASK_PMC);
	}
	
	if(g_team_winner == 0)
	{
		iassist[ 0 ] = 0

		if(!is_valid_ent(aball))
			createball()
		
		if(!saca_el_team)
			moveBall(1)
		else
		{
			set_task(0.5, "asdasdasd213123")
			
		}
		
		
		new id
		for(id=1; id<=maxplayers; id++)
		{
			if(is_user_connected(id) && !is_user_bot(id))
			{
				is_dead[id] = false
				seconds[id] = 0
				g_sprint[id] = 0
				PressedAction[id] = 0
				glow(id,0,0,0,0)
			}
		}
		play_wav(0, SoundDirect[12])

		set_task(1.0, "PostSetupRound")
		set_task(2.0, "PostPostSetupRound")
	}
	/*else
	{
		set_task(0.5, "displayWinnerAwards", _, _, _, "a", 5)
	}*/
	
	if(get_pcvar_num(CVAR_AAA_FULL))
	{
		new i;
		new j;
		new k;
		for(i = 1; i <= maxplayers; i++)
		{
			if(!is_user_connected(i)) continue;
			
			k = 0;
			for(j = 0; j < 5; j++)
			{
				if(diidas && j == 2)
				{
					if(PlayerUpgrades[i][j] >= 1)
					{
						k++;
						continue;
					}
					
					PlayerUpgrades[i][j] = 1;
					continue;
				}
				
				if(PlayerUpgrades[i][j] == UpgradeMax[j])
				{
					k++;
					continue;
				}
				
				PlayerUpgrades[i][j] = UpgradeMax[j];
			}
			
			if(k != 5 && !diidas) CC(i, "!g[SJ]!y Estás FULL!");
		}
	}
}

public asdasdasd213123()
	moveBall(0, 0, saca_el_team)

public PostSetupRound() {
	new id
	for(id=1; id<=maxplayers; id++)
	{
		if(is_user_alive(id) && !is_user_bot(id))
			give_knife(id)
	}
}

public PostPostSetupRound() {
	new id, kills, deaths
	for(id=1; id<=maxplayers; id++) {
		if(is_user_connected(id) && !is_user_bot(id)) {
			kills = PlayerKills[id]
			deaths = PlayerDeaths[id]
			if(kills)
				entity_set_float(id, EV_FL_frags, float(kills))
			if(deaths)
				cs_set_user_deaths(id,deaths)

			setScoreInfo(id)
		}
	}
}

/*====================================================================================================
 [Client Commands]

 Purpose:	$$

 Comment:	$$

====================================================================================================*/
public Turbo(id)
{
	if(is_user_alive(id))
		g_sprint[id] = 1
	return PLUGIN_HANDLED
}

public client_PreThink(id)
{
	if(g_half_time > 0)
	{
		set_user_velocity(id, Float:{0.0, 0.0, 0.0});
		set_user_maxspeed(id, 1.0);
		
		return;
	}
	
	if( is_valid_ent(aball) && is_user_connected(id))
	{
		new button = entity_get_int(id, EV_INT_button)
		new relode = (button & IN_RELOAD)
		new usekey = (button & IN_USE)
		new up = (button & IN_FORWARD)
		new down = (button & IN_BACK)
		new moveright = (button & IN_MOVERIGHT)
		new moveleft = (button & IN_MOVELEFT)
		new jump = (button & IN_JUMP)
		new flags = entity_get_int(id, EV_INT_flags)
		new onground = flags & FL_ONGROUND
		if( (moveright || moveleft) && !up && !down && jump && onground && !g_sprint[id] && id != ballholder)
			SideJump[id] = 1

		if(ballholder > 0)
		{
			no_ball = 1
			entity_set_float(aball,EV_FL_framerate,0.0)
			entity_set_int(aball,EV_INT_sequence,0)
		}
		else
		{
			if(no_ball)
			{
				no_ball = 0
				entity_set_int(aball, EV_INT_sequence, 2);
				entity_set_float(aball, EV_FL_framerate, 22.0);
			}
		}
		
		if(relode)
		{
			entity_set_float(id, EV_FL_framerate, 0.0);    //FLY CHARGE
			entity_set_int(id, EV_INT_sequence, 54);
			entity_set_float(id, EV_FL_animtime, 1.0)
		}
		
		if(g_sprint[id])
			entity_set_float(id, EV_FL_fuser2, 0.0)

		if( id != ballholder )
			PressedAction[id] = usekey
		else
		{
			if( usekey && !PressedAction[id])
			{
				/*countdown_quitar[ballholder] = 0
				ok_quitar[ballholder] = 0
				last_bola = ballholder*/
				
				g_ballin[id] = 0
				g_ball_none = 1
				
				kickBall(ballholder, 0)
			}
			else if( !usekey && PressedAction[id])
				PressedAction[id] = 0
		}

		if( id != ballholder && (button & IN_ATTACK || button & IN_ATTACK2) )
		{
			static Float:maxdistance
			static ferencere
			/*static Float:maxdistancem
			static distancemax

			new fteam = get_user_team(id)

			distancemax = Mascots[fteam]
			maxdistancem = 700.0*/

			if(ballholder > 0)
			{
				ferencere = ballholder
				maxdistance = 96.0
			}
			else {
				ferencere = aball
				maxdistance = 200.0
			}

			if(!maxdistance)
				return

			if(entity_range(id, ferencere) > maxdistance/* && entity_range(id, distancemax) > maxdistancem*/)
				entity_set_int(id, EV_INT_button, (button & ~IN_ATTACK) & ~IN_ATTACK2)
		}
	}
}

public client_PostThink(id)
{
	if(is_user_connected(id)) {
		new Float:gametime = get_gametime()
		new button = entity_get_int(id, EV_INT_button)

		new up = (button & IN_FORWARD)
		new down = (button & IN_BACK)
		new moveright = (button & IN_MOVERIGHT)
		new moveleft = (button & IN_MOVELEFT)
		new jump = (button & IN_JUMP)
		new Float:vel[3]

		entity_get_vector(id,EV_VEC_velocity,vel)

		if( (gametime - SideJumpDelay[id] > 5.0) && SideJump[id] && jump && (moveright || moveleft) && !up && !down) {

			vel[0] *= 2.0
			vel[1] *= 2.0
			vel[2] = 300.0

			entity_set_vector(id,EV_VEC_velocity,vel)
			SideJump[id] = 0
			SideJumpDelay[id] = gametime
		}
		else
			SideJump[id] = 0
	}
}

public kickBall(id, velType)
{
	remove_task(55555)
	set_task(30.0,"clearBall",55555)
	g_ball_in_arc = 0
	g_ball_none = 1
	
	remove_task(99999)
	
	new team = get_user_team(id)
	new a,x

	//Give it some lift
	ball_infront(id, 55.0)

	testorigin[2] += 10

	new Float:tempO[3], Float:returned[3]
	new Float:dist2

	entity_get_vector(id, EV_VEC_origin, tempO)
	new tempEnt = trace_line( id, tempO, testorigin, returned )

	dist2 = get_distance_f(testorigin, returned)

	//ball_infront(id, 55.0)

	if( point_contents(testorigin) != CONTENTS_EMPTY || (!is_user_connected(tempEnt) && dist2 ) )//|| tempDist < 65)
		return PLUGIN_HANDLED
	else
	{
		//Check Make sure our ball isnt inside a wall before kicking
		new Float:ballF[3], Float:ballR[3], Float:ballL[3]
		new Float:ballB[3], Float:ballTR[3], Float:ballTL[3]
		new Float:ballBL[3], Float:ballBR[3]

		for(x=0; x<3; x++) {
				ballF[x] = testorigin[x];	ballR[x] = testorigin[x];
				ballL[x] = testorigin[x];	ballB[x] = testorigin[x];
				ballTR[x] = testorigin[x];	ballTL[x] = testorigin[x];
				ballBL[x] = testorigin[x];	ballBR[x] = testorigin[x];
			}

		for(a=1; a<=6; a++) {

			ballF[1] += 3.0;	ballB[1] -= 3.0;
			ballR[0] += 3.0;	ballL[0] -= 3.0;

			ballTL[0] -= 3.0;	ballTL[1] += 3.0;
			ballTR[0] += 3.0;	ballTR[1] += 3.0;
			ballBL[0] -= 3.0;	ballBL[1] -= 3.0;
			ballBR[0] += 3.0;	ballBR[1] -= 3.0;

			if(point_contents(ballF) != CONTENTS_EMPTY || point_contents(ballR) != CONTENTS_EMPTY ||
			point_contents(ballL) != CONTENTS_EMPTY || point_contents(ballB) != CONTENTS_EMPTY ||
			point_contents(ballTR) != CONTENTS_EMPTY || point_contents(ballTL) != CONTENTS_EMPTY ||
			point_contents(ballBL) != CONTENTS_EMPTY || point_contents(ballBR) != CONTENTS_EMPTY)
					return PLUGIN_HANDLED
		}

		new ent = -1
		testorigin[2] += 35.0

		while((ent = find_ent_in_sphere(ent, testorigin, 35.0)) != 0) {
			if(ent > maxplayers)
			{
				new classname[MAX_PLAYER + 1]
				entity_get_string(ent, EV_SZ_classname, classname, MAX_PLAYER)

				if((contain(classname, "goalnet") != -1 || contain(classname, "func_") != -1) &&
					!equal(classname, "func_water") && !equal(classname, "func_illusionary"))
					return PLUGIN_HANDLED
			}
		}
		testorigin[2] -= 35.0

	}

	new kickVel
	if(!velType)
	{
		new str = ((PlayerUpgrades[id][STR] + g_upg[id][STR]) * ConfigPro[17]) + (ConfigPro[14]*(PowerPlay*5))
		kickVel = get_pcvar_num(CVAR_KICK) + str
		kickVel += g_sprint[id] * 100

		if(direction) {
			entity_get_vector(id, EV_VEC_angles, BallSpinDirection)
			curvecount = ConfigPro[10]
		}
	}
	else {
		curvecount = 0
		direction = 0
		kickVel = random_num(100, 600)
	}

	new Float:ballorig[3]
	entity_get_vector(id,EV_VEC_origin,ballorig)
	for(x=0; x<3; x++)
		distorig[0][x] = floatround(ballorig[x])

	velocity_by_aim(id, kickVel, velocity)

	for(x=0; x<3; x++)
		distorig[0][x] = floatround(ballorig[x])

	/////////////////////WRITE ASSIST CODE HERE IF NEEDED///////////
	if ( iassist[ 0 ] == team ) {
		if ( iassist[ team ] == 15 )
			iassist[ team ] = 0
	}
	else {
		// clear the assist list
		new ind
		for(ind = 0; ind < 16; ind++ )
			assist[ ind ] = 0
		// clear the assist index
		iassist[ team ] = 0
		// set which team to track
		iassist[ 0 ] = team
	}
	assist[ iassist[ team ]++ ] = id
	/////////////////////WRITE ASSIST CODE HERE IF NEEDED///////////

	ballowner = id
	ballholder = 0
	entity_set_origin(aball,testorigin)
	entity_set_vector(aball,EV_VEC_velocity,velocity)

	set_task(0.14*2, "CurveBall", id)

	emit_sound(aball, CHAN_ITEM, SoundDirect[17], 1.0, ATTN_NORM, 0, PITCH_NORM)

	glow(id,0,0,0,0)

	beam()

	new aname[64]
	get_user_name(id,aname,63)

	if(!g_sprint[id])
		set_speedchange(id)

	format(temp1,63,"[%s] [%s] Pateo la bocha!",team == 1 ? EQUIPO_T : EQUIPO_CT,aname)
	
	g_sp = 0;
	
	if(!get_pcvar_num(CVAR_AAA_FULL))
		set_cvar_num("sj_kick", 650);
	
	if(CT_keeper[id] && user_is_keeper[id])
	{
		if( get_user_team(id) == 2 )
			set_user_rendering(id,kRenderFxGlowShell,0,0,255,kRenderNormal,25)
	}
	else if(T_keeper[id] && user_is_keeper[id] )
	{
		if( get_user_team(id) == 1 )
			set_user_rendering(id,kRenderFxGlowShell,255,0,0,kRenderNormal,25)
	}
	
	/*countdown_quitar[id] = 0
	ok_quitar[id] = 0*/
	
	g_ballin[id] = 0
	g_ball_none = 1

	return PLUGIN_HANDLED
}

/*====================================================================================================
 [Command Blocks]

 Purpose:	$$

 Comment:	$$

====================================================================================================*/
public client_kill(id) return PLUGIN_HANDLED
public client_command(id)
{
	new arg[13]
	read_argv( 0, arg , 12 )

	if ( equal("buy",arg) || equal("autobuy",arg) )
		return PLUGIN_HANDLED

	return PLUGIN_CONTINUE
}
public fullupdate(id) return PLUGIN_HANDLED
/*====================================================================================================
 [Upgrades]

 Purpose:	This handles the upgrade menu.

 Comment:	$$

====================================================================================================*/
public BuyUpgrade(id) {

	static menu[999], len;
	len = 0
	
	len += formatex(menu[len], charsmax(menu) - len, "\yHABILIDADES:^n^n")
	
	new x
	for(x=1; x<=UPGRADES; x++)
	{
		new price = ((PlayerUpgrades[id][x] * UpgradePrice[x]) / 2) + UpgradePrice[x]
		if((PlayerUpgrades[id][x] + 1) > UpgradeMax[x])
			len += formatex(menu[len], charsmax(menu) - len, "\r%d. \r%s (AL MAXIMO NIVEL: %d)^n", x, UpgradeTitles[x], UpgradeMax[x])
		else
			len += formatex(menu[len], charsmax(menu) - len, "\r%d. \w%s \r(Próximo nivel: %i) \y-- \w%i XP^n", x, UpgradeTitles[x], PlayerUpgrades[id][x]+1, price)
	}
	
	static porta[64];
	formatex(porta, 63, " \y-- \w %d XP", (5639 + g_late_exp[id]))
	len += formatex(menu[len], charsmax(menu) - len, "\r6. \wSUPER FUERZA (1 TIRO)%s^n", (user_is_keeper[id] && (CT_keeper[id] || T_keeper[id])) ? "" : porta)
	
	new jeta = 0
	for(x = 0; x < MAX_POSS; x++)
	{
		if(g_possid[id][x])
		{
			len += formatex(menu[len], charsmax(menu) - len, "^n\yESTADÍSTICAS DE %s^n", g_poss_text[x])
			for(new v = 1; v<=UPGRADES; v++)
			{
				if(g_upg[id][v] > 0 && g_actualized[id])
				{
					len += formatex(menu[len], charsmax(menu) - len, "\w+%d DE %s^n", g_upgrades[x][v], UpgradeTitles[v])
					jeta = 1
				}
			}
			
			if(jeta == 0)
			{
				len += formatex(menu[len], charsmax(menu) - len, "\wCuando vuelvas a revivir se cargaran tus estadísticas")
				jeta = 2
			}
			
			break;
		}
	}
	if(jeta == 0 && jeta != 2)
		len += formatex(menu[len], charsmax(menu) - len, "^n\wNinguna bonificación por posición^nRecordá que con la letra O poder elegir tu posición!")
		
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r0. \wSalir")
	show_menu(id, MENU_KEY_1|MENU_KEY_2|MENU_KEY_3|MENU_KEY_4|MENU_KEY_5|MENU_KEY_6|MENU_KEY_7|MENU_KEY_8|MENU_KEY_9|MENU_KEY_0, menu, -1, "Upgrades_ALL")
}

public menu_upg(id, key) 
{
	if(key >= 6)
		return PLUGIN_HANDLED
	
	if(key == 5)
	{
		if(id != ballholder)
		{
			CC(id, "!g[SJ]!y Debes tener la pelota para poder usar SUPER FUERZA");
			return PLUGIN_HANDLED;
		}
		
		if(!get_pcvar_num(CVAR_AAA_FULL))
		{
			if(user_is_keeper[id] && (CT_keeper[id] || T_keeper[id]))
			{
				if(g_timesp[get_user_team(id)-1])
				{
					CC(id, "!g[SJ]!y Solo se puede usar este poder cada 5 minutos por equipo");
					return PLUGIN_HANDLED;
				}
			
				g_sp = 1;
				set_cvar_num("sj_kick", get_pcvar_num(CVAR_KICK) + 650);
				
				get_user_name(id, g_namename, 31);
				client_print(0, print_center, "%s ACTIVÓ LA SUPER FUERZA", g_namename);
				set_task(1.0, "peteeeroe", _, _, _, "a", 1);
				
				g_timesp[get_user_team(id)-1] = 1;
				
				if(get_user_team(id) == 1)
				{
					remove_task(TASK_FSP_1);
					set_task(300.0, "fn_final_sp1", TASK_FSP_1);
				}
				else
				{
					remove_task(TASK_FSP_2);
					set_task(300.0, "fn_final_sp2", TASK_FSP_2);
				}
			}
			else if((g_Experience[id] - (5639 + g_late_exp[id])) < 0) CC(id, "!g[SJ]!y Necesitas más experiencia para usar la !gSUPER FUERZA!y"); 
			else
			{
				if(id != ballholder)
				{
					CC(id, "!g[SJ]!y Debes tener la pelota para poder usar SUPER FUERZA");
					return PLUGIN_HANDLED;
				}
				
				g_Experience[id] -= (5639 + g_late_exp[id]);
				
				g_sp = 1;
				set_cvar_num("sj_kick", get_pcvar_num(CVAR_KICK) + 650);
				
				get_user_name(id, g_namename, 31);
				client_print(0, print_center, "%s ACTIVÓ LA SUPER FUERZA", g_namename);
				set_task(1.0, "peteeeroe", _, _, _, "a", 1);
			}
		}
		return PLUGIN_HANDLED;
	}
	
	new upgrade = key+1

	new playerupgrade = PlayerUpgrades[id][upgrade]
	new price = ((playerupgrade * UpgradePrice[upgrade]) / 2) + UpgradePrice[upgrade]
	new maxupgrade = UpgradeMax[upgrade]

	if(playerupgrade != maxupgrade)
	{
		new needed = g_Experience[id] - price

		if( (needed >= 0) )
		{
			playerupgrade += 1

			g_Experience[id] -= price

			if(playerupgrade < maxupgrade)
				CC(id,"!g[SJ]!y Subiste al nivel !g%d!y de !g%s!y usando !g%d!y de experiencia",playerupgrade,UpgradeTitles[upgrade],price)
			else 
			{
				CC(id,"!g[SJ]!y Subiste al nivel !g%d!y de !g%s!y usando !g%d!y de experiencia",maxupgrade,UpgradeTitles[upgrade],price)
				CC(id,"!g[SJ]!y Ya has alcanzado el nivel máximo !g(%d)!y!",maxupgrade)
				
				play_wav(id, SoundDirect[18])
			}
			switch(upgrade) {
				case STA: {
					new stam = playerupgrade + g_upg[id][STA]
					entity_set_float(id, EV_FL_health, float(ConfigPro[5] + (stam * ConfigPro[16])))
				}
				case AGI: {
					if(!g_sprint[id])
						set_speedchange(id)
				}
			}
			PlayerUpgrades[id][upgrade] = playerupgrade
		}
		else
			CC(id,"!g[SJ]!y Faltan !g%d!y de experiencia para el nivel !g%d!y de !g%s!y",(needed * -1),(playerupgrade+1),UpgradeTitles[upgrade])
	}
	else {
		CC(id,"!g[SJ] %s!y ha sido maximizado a nivel !g%d!y!",UpgradeTitles[upgrade],maxupgrade)
	}
	
	//BuyUpgrade(id)
	return PLUGIN_HANDLED
}

public peteeeroe() client_print(0, print_center, "%s ACTIVÓ LA SUPER FUERZA", g_namename)

public fn_final_sp1()
{
	g_timesp[0] = 0;
	
	for(new i = 1; i <= maxplayers; i++)
	{
		if(!is_user_connected(i))
			continue;
			
		if(get_user_team(i) == 1)
			CC(i, "!g[SJ]!y El arquero de !g%s!y ya puede volver a usar !gSUPER FUERZA!y", EQUIPO_T)
	}
}
public fn_final_sp2()
{
	g_timesp[1] = 0;
	
	for(new i = 1; i <= maxplayers; i++)
	{
		if(!is_user_connected(i))
			continue;
			
		if(get_user_team(i) == 2)
			CC(i, "!g[SJ]!y El arquero de !g%s!y ya puede volver a usar !gSUPER FUERZA!y", EQUIPO_CT)
	}
}

/*====================================================================================================
 [Meters]

 Purpose:	This controls the turbo meter and curve angle meter.

 Comment:	$$

====================================================================================================*/
public meter()
{
	new id
	new turboTitle[MAX_PLAYER + 1]
	new sprintText[128], sec
	new r, g, b, team
	new len, x
	new ndir = -(ConfigPro[11])
	format(turboTitle, MAX_PLAYER,"[-TURBO-]");
	for(id=1; id<=maxplayers; id++)
	{
		if(!is_user_connected(id) || !is_user_alive(id) || is_user_bot(id))
			continue

		sec = seconds[id]
		team = get_user_team(id)
		if(team == 1)
		{
			r = PlayerColors[25]
			g = PlayerColors[26]
			b = PlayerColors[27]
		}
		else if(team == 2)
		{
			r = PlayerColors[22]
			g = PlayerColors[23]
			b = PlayerColors[24]
		}
		else
		{
			r = 0
			g = 0
			b = 0
		}

		if(id == ballholder)
		{

			set_hudmessage(r, g, b, POS_X, 0.75, 0, 0.0, 0.6, 0.0, 0.0, 1)

			len = format(sprintText, 127, "[-COMBA-]^n[")

			for(x=ConfigPro[11]; x>=ndir; x--)
				if(x==0)
					len += format(sprintText[len], 127-len, "%s%s",direction==x?"0":"+", x==ndir?"]":"  ")
				else
					len += format(sprintText[len], 127-len, "%s%s",direction==x?"0":"=", x==ndir?"]":"  ")

			show_hudmessage(id, "%s", sprintText)
		}

		set_hudmessage(r, g, b, POS_X, POS_Y, 0, 0.0, 0.6, 0.0, 0.0, 3)

		if(sec > 30)
		{
			sec -= 2
			format(sprintText, 127, "  %s ^n[==============]",turboTitle)

			set_speedchange(id)
			g_sprint[id] = 0
		}
		else if(sec >= 0 && sec < 30 && g_sprint[id])
		{
			sec += 2
			set_speedchange(id, 100.0)
		}

		switch(sec)
		{
			case 0:		format(sprintText, 127, "  %s ^n[||||||||||||||]",turboTitle)
			case 2:		format(sprintText, 127, "  %s ^n[|||||||||||||=]",turboTitle)
			case 4:		format(sprintText, 127, "  %s ^n[||||||||||||==]",turboTitle)
			case 6:		format(sprintText, 127, "  %s ^n[|||||||||||===]",turboTitle)
			case 8:		format(sprintText, 127, "  %s ^n[||||||||||====]",turboTitle)
			case 10:	format(sprintText, 127, "  %s ^n[|||||||||=====]",turboTitle)
			case 12:	format(sprintText, 127, "  %s ^n[||||||||======]",turboTitle)
			case 14:	format(sprintText, 127, "  %s ^n[|||||||=======]",turboTitle)
			case 16:	format(sprintText, 127, "  %s ^n[||||||========]",turboTitle)
			case 18:	format(sprintText, 127, "  %s ^n[|||||=========]",turboTitle)
			case 20:	format(sprintText, 127, "  %s ^n[||||==========]",turboTitle)
			case 22:	format(sprintText, 127, "  %s ^n[|||===========]",turboTitle)
			case 24:	format(sprintText, 127, "  %s ^n[||============]",turboTitle)
			case 26:	format(sprintText, 127, "  %s ^n[|=============]",turboTitle)
			case 28:	format(sprintText, 127, "  %s ^n[==============]",turboTitle)
			case 30:
			{
				format(sprintText, 128, "  %s ^n[==============]",turboTitle)
				sec = 92
			}
			case 32: sec = 0
		}
		seconds[id] = sec
		show_hudmessage(id,"%s",sprintText)
	}
}


/*====================================================================================================
 [Misc.]

 Purpose:	$$

 Comment:	$$

====================================================================================================*/
set_speedchange(id, Float:speed=0.0)
{
	new Float:agi = float( ((PlayerUpgrades[id][AGI] + g_upg[id][AGI]) * ConfigPro[18]) + (id==ballholder?(ConfigPro[14] * (PowerPlay*2)):0) )
	agi += (250.0 + speed)
	entity_set_float(id,EV_FL_maxspeed, agi)
}

public give_knife(id) {
	if(id > 1000)
		id -= 1000

	remove_task(id+1000)


	give_item(id, "weapon_knife")
	has_knife[id] = true;
}

Event_Record(id, recordtype, amt, exp) {
	if(amt == -1)
		MadeRecord[id][recordtype]++
	else
		MadeRecord[id][recordtype] = amt

	new playerRecord = MadeRecord[id][recordtype]
	if(playerRecord > TopPlayer[1][recordtype])
	{
		TopPlayer[0][recordtype] = id
		TopPlayer[1][recordtype] = playerRecord
		new name[MAX_PLAYER+1]
		get_user_name(id,name,MAX_PLAYER)
		format(TopPlayerName[recordtype],MAX_PLAYER,"%s",name)
	}
	g_Experience[id] += exp
	g_maxexp[id] += exp
}

Float:normalize(Float:nVel)
{
	if(nVel > 360.0) {
		nVel -= 360.0
	}
	else if(nVel < 0.0) {
		nVel += 360.0
	}

	return nVel
}

public editTextMsg()
{
	new string[64], radio[64]
	get_msg_arg_string(2, string, 63)

	if( get_msg_args() > 2 )
		get_msg_arg_string(3, radio, 63)

	if(containi(string, "#Game_will_restart") != -1 || containi(radio, "#Game_radio") != -1)
		return PLUGIN_HANDLED

	return PLUGIN_CONTINUE
}

public AutoRespawn(id)
	if(is_dead[id] && is_user_connected(id)) {
		new team = get_user_team(id)
		if(team == 1 || team == 2) {
			spawn(id)

		}
		else
			is_dead[id] = false
	}

public AutoRespawn2(id)
	if(is_dead[id] && is_user_connected(id)) {
		new team = get_user_team(id)
		if(team == 1 || team == 2) {
			spawn(id)
			if(!has_knife[id])
				give_knife(id)
		}
		//strip_user_weapons(id)
		is_dead[id] = false
	}

play_wav(id, wav[])
	client_cmd(id,"spk %s",wav)


increaseTeamXP(team, amt) {
	new id
	for(id=1; id<=maxplayers; id++)
		if(get_user_team(id) == team && is_user_connected(id))
		{
			g_Experience[id] += amt
			g_maxexp[id] += amt
		}
}

setScoreInfo(id) {
	message_begin(MSG_BROADCAST,get_user_msgid("ScoreInfo"));
	write_byte(id);
	write_short(get_user_frags(id));
	write_short(cs_get_user_deaths(id));
	write_short(0);
	write_short(get_user_team(id));
	message_end();
}

// Erase our current temps (used for ball events)
public eraser(num) {
	if(num == 3333)
		format(temp1,63,"")
	if(num == 4444)
		format(temp2,63,"")
	return PLUGIN_HANDLED
}
/*====================================================================================================
 [Cleanup]

 Purpose:	$$

 Comment:	$$

====================================================================================================*/
public client_disconnect(id)
{
	if (id == editor) HideAllZones()
	
	g_maxexp[id] = 0;
	g_actualized[id] = 0
	new x
	for(x = 0; x<MAX_POSS; x++)
	{
		if(g_possid[id][x])
		{
			g_possid[id][x] = 0
			g_poss[x] = 0
		}
	}

	for(x = 1; x<=RECORDS; x++)
		MadeRecord[id][x] = 0

	remove_task(id)
	if(ballholder == id )
	{
		ballholder = 0
		clearBall()
	}
	if(ballowner == id)
	{
		ballowner = 0
	}

	GoalyPoints[id] = 0
	PlayerKills[id] = 0
	PlayerDeaths[id] = 0
	is_dead[id] = false
	seconds[id] = 0
	g_sprint[id] = 0
	PressedAction[id] = 0
	has_knife[id] = false;
	g_Experience[id] = 0
	g_arquero[id] = 0
	/*ok_quitar[id] = 0
	countdown_quitar[id] = 0*/
	g_ballin[id] = 0
	
	for(x=1; x<=UPGRADES; x++)
	{
		PlayerUpgrades[id][x] = 0
		g_upg[id][x] = 0
	}
	
	cmdUnKeeper(id)
	
	remove_task(id + TASK_MODEL)
	remove_task(id+TASK_KEEPER)
	remove_task(id+TASK_FINISH)
	//remove_task(id+TASK_REMOVE_BALL)
}

/*====================================================================================================
 [Help]

 Purpose:	$$

 Comment:	$$

====================================================================================================*/
public client_putinserver(id) 
{
	g_roundteam[id] = 0;
	
	//new MapName[64]
	set_task(10.0,"LateJoinExp",id)
	
	loasd[id] = 0

	/*get_mapname(MapName,63)
	if(equali(MapName,"sj_indoorx_small"))
		set_task(2.0,"areas_indoorx",id)
	else if(equali(MapName,"sj_pro"))
		set_task(2.0,"areas_pro",id)
	else if(equali(MapName,"sj_pro_small"))
		set_task(2.0,"areas_pro_small",id)
	else if(equali(MapName,"soccerjam"))
		set_task(2.0,"areas_soccerjam",id)*/
	
	set_task(10.0, "Bindear", id)
}

public Bindear(id)
{
	if(is_user_connected(id))
	{
		client_cmd(id, "bind p records")
		client_cmd(id, "bind l allrecords")
		
		message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("ScreenFade"), _, id)
		write_short((1 << 12)) // duration
		write_short(0) // hold time
		write_short(0x0000) // fade type
		write_byte(0) // r
		write_byte(0) // g
		write_byte(0) // b
		write_byte(0) // alpha
		message_end()
	}
}

public records(id)
{
	set_hudmessage(255, 128, 0,  0.15, 0.15, 0, 0.2, 5.0, 0.2, 0.1, -1)
	ShowSyncHudMsg(id, g_MsgHudRecord, "Records^n^nGoles: %d^nRobos: %d^nAsistencias: %d^nMuertes con pelota: %d^nGol lejano: %d pies^nDesarmes: %d^n",
	MadeRecord[id][GOAL], MadeRecord[id][STEAL], MadeRecord[id][ASSIST], MadeRecord[id][KILL], MadeRecord[id][DISTANCE], MadeRecord[id][DISARMS])

	return PLUGIN_HANDLED
}
public allrecords(id)
{	
	new motd[1501],iLen;

	iLen = format(motd, sizeof motd - 1,"<body bgcolor=#000000><font color=#fff000><pre>");
	iLen += format(motd[iLen], (sizeof motd - 1) - iLen,"<center><h2>---- Todos los records ----</h2></center>^n^n");
	iLen += format(motd[iLen], (sizeof motd - 1) - iLen,"%-22.22s %8s %7s %6s %6s %6s %6s %6s^n", "Nick", "Goles", "Robos", "Asist", "En contra", "Disarms", "Bkills", "Lejano");
	
	for(new x=1; x<=maxplayers; x++) 
	{
		if(is_user_connected(x))
		{
			new elname[MAX_PLAYER + 1] 
			get_user_name(x, elname, MAX_PLAYER) 
			
			if(containi (elname, "<" ) != -1 )
				replace(elname, MAX_PLAYER, "<", "" )	

			iLen += format(motd[iLen], (sizeof motd - 1) - iLen,"%-22.22s %5i %8i %7i %10i %7i %6i %6i^n", elname, MadeRecord[x][1], MadeRecord[x][3], MadeRecord[x][2], MadeRecord[x][4], MadeRecord[x][6], MadeRecord[x][7], MadeRecord[x][5]);			
		}
	}
	
	show_motd(id,motd, "Todos los records");

	return PLUGIN_HANDLED
}

new g_Votes[2];
public cmd_vote_keeper(id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF)
	
	if (!player)
		return PLUGIN_HANDLED;
	
	if(!user_is_keeper[player])
	{
		client_print(id, print_console, "[SJ] Solo puedes votar al arquero")
		return PLUGIN_HANDLED
	}
	else if(cs_get_user_team(id) != cs_get_user_team(player))
	{
		client_print(id, print_console, "[SJ] Solo puedes votar al arquero de tu equipo")
		return PLUGIN_HANDLED
	}
	else if(g_time_delay)
	{
		client_print(id, print_console, "[SJ] Solo se puede usar este comando cada 5 minutos")
		return PLUGIN_HANDLED
	}
	
	g_time_delay = 1;
	set_task(180.0, "TimeDelayOff")
	
	new sz_Menu[512];
	new s_Name[32];
	new s_NameId[32];
	new CsTeams:i_Team = cs_get_user_team(player);
	new i;
	
	get_user_name(id, s_NameId, 31);
	get_user_name(player, s_Name, 31);
	
	for(i = 1; i <= maxplayers; i++)
	{
		if(!is_user_connected(i)) continue;
		
		if(get_user_team(i) == get_user_team(id))
			CC(i, "!g[SJ]!y El jugador !g%s!y ha iniciado una votación para sacar a su arquero", s_NameId);
	}
	
	formatex(sz_Menu, charsmax(sz_Menu), "\rQuieres sacar del arco a \y%s^n\rpor que no ataja correctamente?^n^n\y1. \wSi^n\y2. \wNo", s_Name);
	
	for(new i = 1; i <= maxplayers; i++)
	{
		if(!is_user_connected(i) || (cs_get_user_team(i) != i_Team)) continue;
		show_menu(i, (1 << 0) | (1 << 1), sz_Menu, 8, "Menu_Vote_Keeper");
	}
	
	set_task(10.00, "fnCheckVotesSS", player);
	
	return PLUGIN_HANDLED;
}
public TimeDelayOff() g_time_delay = 0;
public MENU_VoteKeeper(id, key)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	switch(key)
	{
		case 0: g_Votes[0]++;
		case 1: g_Votes[1]++;
	}
	
	return PLUGIN_HANDLED;
}
public fnCheckVotesSS(id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
		
	new s_Name[32];
	get_user_name(id, s_Name, 31);
	
	if(g_Votes[0] >= g_Votes[1])
	{
		CC(0, "!g[SJ]!y El jugador !g%s!y ya no es más arquero debido a que lo votaron suficientes personas", s_Name);
		client_cmd(id, "say /noatajo")
	}
	else CC(0, "!g[SJ]!y El jugador !g%s!y sigue siendo arquero debido a que no lo votaron suficientes personas", s_Name);
	
	g_Votes = {0, 0};
	
	return PLUGIN_HANDLED;
}

public LateJoinExp(id)
{
	if(!is_user_connected(id))
		return

	if(get_pcvar_num(CVAR_AAA_FULL))
	{
		new i;
		for(i = 0; i < 5; i++)
			PlayerUpgrades[id][i] = UpgradeMax[i];
	
		CC(id, "!g[SJ]!y No recibiste experiencia porque el arco a arco está activado. Estás FULL!")
		return;
	}
	
	g_late_exp[id] = 0;
	
	g_late_exp[id] = ((score[T] + g_new_score[T]) + (score[CT] + g_new_score[CT])) * ConfigPro[13]
	if(g_late_exp[id])
	{
		g_Experience[id] = g_late_exp[id]
		CC(id, "!g[SJ]!y Recibiste !g%d!y de experiencia por entrar tarde al partido!",g_late_exp[id])
	}
}

/*====================================================================================================
 [Post Game]

 Purpose:	$$

 Comment:	$$

====================================================================================================*/
public showhud_winner() {
	set_hudmessage(255, 0, 20, -1.0, 0.35, 1, 1.0, 1.5, 0.1, 0.1, HUD_CHANNEL)
	show_hudmessage(0,"%s",scoreboard)
}
public displayWinnerAwards(taskid)
{
	//If NO steal/assist was made, set name to Nobody
	new x
	for(x=1;x<=RECORDS;x++)
		if(!TopPlayer[0][x])
			format(TopPlayerName[x],MAX_PLAYER,"Nadie")
	
	new id = fn_check_max_xp();
	new sWinXPName[32];
	new rolling[48];
	
	get_user_name(id, sWinXPName, 31);
	
	if(g_team_winner == 1)
		formatex(rolling, 47, "GANÓ %s", EQUIPO_T);
	else if(g_team_winner == 2)
		formatex(rolling, 47, "GANÓ %s", EQUIPO_CT);
	else
		formatex(rolling, 47, "LOS EQUIPOS EMPATARON");
		
	set_hudmessage(250, 130, 20, 0.4, 0.35, 0, 6.0, 1.1, 0.0, 0.0, -1)
	ShowSyncHudMsg(ID_FINISH, g_MsgHudFinal, "¡¡¡ %s !!!^n%s - %d  |  %s - %d^n^n      -- Premios --^n%d Goles -- %s^n%d Robos -- %s^n\
	%d Asistencias -- %s^n%d Muertes con pelota -- %s^n%d Pies (Gol más lejano) -- %s^n%d Desarmes -- %s^nMayor experiencia ganada: %s (%d XP)", rolling, EQUIPO_T, (score[T] + g_new_score[T]),
	EQUIPO_CT,(score[CT] + g_new_score[CT]), TopPlayer[1][GOAL], TopPlayerName[GOAL], TopPlayer[1][STEAL], TopPlayerName[STEAL], TopPlayer[1][ASSIST], TopPlayerName[ASSIST],
	TopPlayer[1][KILL], TopPlayerName[KILL], TopPlayer[1][DISTANCE], TopPlayerName[DISTANCE], TopPlayer[1][DISARMS], TopPlayerName[DISARMS], sWinXPName, g_maxexp[id])
}

fn_check_max_xp()
{
	new sPlayers[32];
	new iPlayers;
	
	get_players(sPlayers, iPlayers, "ch"); 
	
	if(!iPlayers)
		return 0;
	
	new iUser;
	new id;
	new i;
	
	iUser = sPlayers[0];
	for(i = 1; i < iPlayers; i++)
	{ 
		id = sPlayers[i];
		
		if(!is_user_connected(id))
			continue;
		
		if(g_maxexp[id] > g_maxexp[iUser])
			iUser = id;
	} 
	
	return iUser;
}
/*====================================================================================================
 [Special FX]

 Purpose:	$$

 Comment:	$$

====================================================================================================*/
TerminatePlayer(id, mascot, team, Float:dmg) {
	new orig[3], Float:morig[3], iMOrig[3]

	get_user_origin(id, orig)
	entity_get_vector(mascot,EV_VEC_origin,morig)
	new x
	for(x=0;x<3;x++)
		iMOrig[x] = floatround(morig[x])


	/*
	message_begin(MSG_ONE,iconstatus,{0,0,0},id);
	write_byte(1); // status (0=hide, 1=show, 2=flash)
	write_string("dmg_shock"); // sprite name
	write_byte(255); // red
	write_byte(255); // green
	write_byte(0); // blue
	message_end();

	set_task(2.0,"ClearIcon",id)
	*/

	fakedamage(id,"Terminator",dmg,1)

	new hp = get_user_health(id)
	if(hp < 0)
		increaseTeamXP(team, 25)

	new loc = (team == 1 ? 100 : 140)
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(0)
	write_coord(iMOrig[0])			//(start positionx)
	write_coord(iMOrig[1])			//(start positiony)
	write_coord(iMOrig[2] + loc)			//(start positionz)
	write_coord(orig[0])			//(end positionx)
	write_coord(orig[1])		//(end positiony)
	write_coord(orig[2])		//(end positionz)
	write_short(g_fxBeamSprite) 			//(sprite index)
	write_byte(0) 			//(starting frame)
	write_byte(0) 			//(frame rate in 0.1's)
	write_byte(7) 			//(life in 0.1's)
	write_byte(120) 			//(line width in 0.1's)
	write_byte(25) 			//(noise amplitude in 0.01's)
	write_byte(255)			//r
	write_byte(255)			//g
	write_byte(255)			//b
	write_byte(400)			//brightness
	write_byte(1) 			//(scroll speed in 0.1's)
	message_end()
}


/*
public ClearIcon(id)
{
	message_begin(MSG_ONE,iconstatus,{0,0,0},id);
	write_byte(1); // status (0=hide, 1=show, 2=flash)
	write_string("dmg_shock"); // sprite name
	write_byte(0); // red
	write_byte(0); // green
	write_byte(0); // blue
	message_end();
}
*/

glow(id, r, g, b, on) {
	if(on == 1) {
		set_rendering(id, kRenderFxGlowShell, r, g, b, kRenderNormal, 16)
		entity_set_float(id, EV_FL_renderamt, 1.0)
	}
	else if(!on) {
		set_rendering(id, kRenderFxNone, r, g, b,  kRenderNormal, 16)
		entity_set_float(id, EV_FL_renderamt, 1.0)
	}
	else if(on == 10) {
		set_rendering(id, kRenderFxGlowShell, r, g, b, kRenderNormal, 16)
		entity_set_float(id, EV_FL_renderamt, 1.0)
	}
}

on_fire()
{
	new rx, ry, rz, Float:forig[3], forigin[3], x
	fire_delay = get_gametime()

	rx = random_num(-5, 5)
	ry = random_num(-5, 5)
	rz = random_num(-5, 5)
	entity_get_vector(aball, EV_VEC_origin, forig)
	for(x=0;x<3;x++)
		forigin[x] = floatround(forig[x])

	message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
	write_byte(17)
	write_coord(forigin[0] + rx)
	write_coord(forigin[1] + ry)
	write_coord(forigin[2] + 10 + rz)
	write_short(Burn_Sprite)
	write_byte(7)
	write_byte(235)
	message_end()
}

beam()
{
	if(get_user_team(ballholder) == 1 || get_user_team(ballowner) == 1)
	{
		if(T_sprite == 0)
		{
			message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
			write_byte(TE_KILLBEAM)
			write_short(aball)
			message_end()
			T_sprite = 1
			CT_sprite = 0
		}
		beam_T()
	}
	else if(get_user_team(ballholder) == 2 || get_user_team(ballowner) == 2)
	{
		if(CT_sprite == 0)
		{
			message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
			write_byte(TE_KILLBEAM)
			write_short(aball)
			message_end()
			CT_sprite = 1
			T_sprite = 0
		}
		beam_CT()
	}
}


beam_CT()
{
	message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
	write_byte(22) 		// TE_BEAMFOLLOW
	write_short(aball) 	// ball
	write_short(beamspr)// laserbeam

	write_byte(BallColors[10])	// life
	write_byte(BallColors[9])	// width

	write_byte(BallColors[3])	// R
	write_byte(BallColors[4])	// G
	write_byte(BallColors[5])	// B
	write_byte(BallColors[11])	// brightness

	message_end()
}

beam_T()
{
	message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
	write_byte(22) 		// TE_BEAMFOLLOW
	write_short(aball) 	// ball
	write_short(beamspr)// laserbeam

	write_byte(BallColors[10])	// life
	write_byte(BallColors[9])	// width

	write_byte(BallColors[6])	// R
	write_byte(BallColors[7])	// G	Perfect Select
	write_byte(BallColors[8])	// B
	write_byte(BallColors[11])	// brightness

	message_end()
}

flameWave(myorig[3]) {
    message_begin(MSG_BROADCAST, SVC_TEMPENTITY, myorig)
    write_byte( 21 )
    write_coord(myorig[0])
    write_coord(myorig[1])
    write_coord(myorig[2] + 16)
    write_coord(myorig[0])
    write_coord(myorig[1])
    write_coord(myorig[2] + 500)
    write_short( fire )
    write_byte( 0 ) // startframe
    write_byte( 0 ) // framerate
    write_byte( 15 ) // life 2
    write_byte( 50 ) // width 16
    write_byte( 10 ) // noise
    write_byte( 209 ) // r 255
    write_byte( 164 ) // g 0
    write_byte( 255 ) // b 0
    write_byte( 255 ) //brightness
    write_byte( 1 / 10 ) // speed
    message_end()

    message_begin(MSG_BROADCAST,SVC_TEMPENTITY,myorig)
    write_byte( 21 )
    write_coord(myorig[0])
    write_coord(myorig[1])
    write_coord(myorig[2] + 16)
    write_coord(myorig[0])
    write_coord(myorig[1])
    write_coord(myorig[2] + 500)
    write_short( fire )
    write_byte( 0 ) // startframe
    write_byte( 0 ) // framerate
    write_byte( 10 ) // life 2
    write_byte( 70 ) // width 16
    write_byte( 10 ) // noise
    write_byte( 0 ) // r 0
    write_byte( 0 ) // g 0
    write_byte( 255 ) // b 0
    write_byte( 200 ) //brightness
    write_byte( 1 / 8 ) // speed
    message_end()

    message_begin(MSG_BROADCAST,SVC_TEMPENTITY,myorig)
    write_byte( 21 )
    write_coord(myorig[0])
    write_coord(myorig[1])
    write_coord(myorig[2] + 16)
    write_coord(myorig[0])
    write_coord(myorig[1])
    write_coord(myorig[2] + 500)
    write_short( fire )
    write_byte( 0 ) // startframe
    write_byte( 0 ) // framerate
    write_byte( 10 ) // life 2
    write_byte( 90 ) // width 16
    write_byte( 10 ) // noise
    write_byte( 0 ) // r 255
    write_byte( 255 ) // g 100
    write_byte( 255 ) // b 0
    write_byte( 200 ) //brightness
    write_byte( 1 / 5 ) // speed
    message_end()

    //Explosion2
    message_begin( MSG_BROADCAST, SVC_TEMPENTITY)
    write_byte( 12 )
    write_coord(myorig[0])
    write_coord(myorig[1])
    write_coord(myorig[2])
    write_byte( 80 ) // byte (scale in 0.1's) 188
    write_byte( 10 ) // byte (framerate)
    message_end()

    //TE_Explosion
    message_begin( MSG_BROADCAST, SVC_TEMPENTITY )
    write_byte( 3 )
    write_coord(myorig[0])
    write_coord(myorig[1])
    write_coord(myorig[2])
    write_short( fire )
    write_byte( 65 ) // byte (scale in 0.1's) 188
    write_byte( 10 ) // byte (framerate)
    write_byte( 0 ) // byte flags
    message_end()

    //Smoke
    message_begin( MSG_BROADCAST,SVC_TEMPENTITY,myorig)
    write_byte( 5 ) // 5
    write_coord(myorig[0])
    write_coord(myorig[1])
    write_coord(myorig[2])
    write_short( smoke )
    write_byte( 50 )  // 2 50
    write_byte( 10 )  // 10
    message_end()

    return PLUGIN_HANDLED
}


/***************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
*************************************************************** TODOS MIS AGREGADOS by L// *********************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
***************************************************************************************************************************************************/

/******************************** PLUGINS DEL AREA **********************************/


/*public areas_soccerjam(id)
{
    if(!is_user_connected(id))
        return

    new Ent_t = create_entity("info_target")
    new Ent_c = create_entity("info_target")
    new Ent_tt = create_entity("info_target")
    new Ent_ct = create_entity("info_target")

    new Float:t_Origin[3] = {1912.0,0.0,1636.0}
    new Float:c_Origin[3] = {-2360.0,0.0,1636.0}
    new Float:tt_Origin[3] = {-295.0,-300.0,1970.0}
    new Float:ct_Origin[3] = {-159.0,-300.0,1970.0}

    entity_set_string(Ent_t,EV_SZ_classname,p_Classname)
    entity_set_string(Ent_c,EV_SZ_classname,g_Classname)
    entity_set_string(Ent_tt,EV_SZ_classname,y_Classname)
    entity_set_string(Ent_ct,EV_SZ_classname,z_Classname)

    entity_set_int(Ent_t,EV_INT_solid,SOLID_TRIGGER)
    entity_set_int(Ent_c,EV_INT_solid,SOLID_TRIGGER)
    entity_set_int(Ent_tt,EV_INT_solid,SOLID_TRIGGER)
    entity_set_int(Ent_ct,EV_INT_solid,SOLID_TRIGGER)

    entity_set_origin(Ent_t,t_Origin)
    entity_set_origin(Ent_c,c_Origin)
    entity_set_origin(Ent_tt,tt_Origin)
    entity_set_origin(Ent_ct,ct_Origin)

    entity_set_size(Ent_t,Float:{-156.5,-280.0,-68.0},Float:{156.5,280.0,68.0})
    entity_set_size(Ent_c,Float:{-156.5,-280.0,-68.0},Float:{156.5,280.0,68.0})
    entity_set_size(Ent_tt,Float:{-5.0,-6790.0,-402.0},Float:{5.0,6790.0,402.0})
    entity_set_size(Ent_ct,Float:{-5.0,-6790.0,-402.0},Float:{5.0,6790.0,402.0})

    entity_set_edict(Ent_t,EV_ENT_owner,id)
    entity_set_edict(Ent_c,EV_ENT_owner,id)
    entity_set_edict(Ent_tt,EV_ENT_owner,id)
    entity_set_edict(Ent_ct,EV_ENT_owner,id)
}

public areas_indoorx(id)
{
	if(!is_user_connected(id))
		return

	new Ent_t = create_entity("info_target")
	new Ent_c = create_entity("info_target")
	new Ent_tt = create_entity("info_target")
	new Ent_ct = create_entity("info_target")

	new Float:t_Origin[3] = {1789.0,-363.0,-215.0}
	new Float:c_Origin[3] = {-1557.0,-358.0,-215.0}
	new Float:tt_Origin[3] = {42.0,-360.0,-244.0}
	new Float:ct_Origin[3] = {180.0,-360.0,-244.0}

	entity_set_string(Ent_t,EV_SZ_classname,p_Classname)
	entity_set_string(Ent_c,EV_SZ_classname,g_Classname)
	entity_set_string(Ent_tt,EV_SZ_classname,y_Classname)
	entity_set_string(Ent_ct,EV_SZ_classname,z_Classname)

	entity_set_int(Ent_t,EV_INT_solid,SOLID_TRIGGER)
	entity_set_int(Ent_c,EV_INT_solid,SOLID_TRIGGER)
	entity_set_int(Ent_tt,EV_INT_solid,SOLID_TRIGGER)
	entity_set_int(Ent_ct,EV_INT_solid,SOLID_TRIGGER)

	entity_set_origin(Ent_t,t_Origin)
	entity_set_origin(Ent_c,c_Origin)
	entity_set_origin(Ent_tt,tt_Origin)
	entity_set_origin(Ent_ct,ct_Origin)

	entity_set_size(Ent_t,Float:{-90.0,-270.5,-117.5},Float:{90.0,270.5,117.5})
	entity_set_size(Ent_c,Float:{-90.0,-270.5,-117.5},Float:{90.0,270.5,117.5})
	entity_set_size(Ent_tt,Float:{-5.0,-995.0,-93.0},Float:{5.0,995.0,93.0})
	entity_set_size(Ent_ct,Float:{-5.0,-995.0,-93.0},Float:{5.0,995.0,93.0})

	entity_set_edict(Ent_t,EV_ENT_owner,id)
	entity_set_edict(Ent_c,EV_ENT_owner,id)
	entity_set_edict(Ent_tt,EV_ENT_owner,id)
	entity_set_edict(Ent_ct,EV_ENT_owner,id)
}

public areas_pro(id)
{
	if(!is_user_connected(id))
		return

	new Ent_t = create_entity("info_target")
	new Ent_c = create_entity("info_target")
	new Ent_tt = create_entity("info_target")
	new Ent_ct = create_entity("info_target")

	new Float:t_Origin[3] = {1892.0,215.0,-500.0}
	new Float:c_Origin[3] = {-1469.0,215.0,-500.0}
	new Float:tt_Origin[3] = {56.0,215.0,-430.0}
	new Float:ct_Origin[3] = {364.0,215.0,-430.0}

	entity_set_string(Ent_t,EV_SZ_classname,p_Classname)
	entity_set_string(Ent_c,EV_SZ_classname,g_Classname)
	entity_set_string(Ent_tt,EV_SZ_classname,y_Classname)
	entity_set_string(Ent_ct,EV_SZ_classname,z_Classname)

	entity_set_int(Ent_t,EV_INT_solid,SOLID_TRIGGER)
	entity_set_int(Ent_c,EV_INT_solid,SOLID_TRIGGER)
	entity_set_int(Ent_tt,EV_INT_solid,SOLID_TRIGGER)
	entity_set_int(Ent_ct,EV_INT_solid,SOLID_TRIGGER)

	entity_set_origin(Ent_t,t_Origin)
	entity_set_origin(Ent_c,c_Origin)
	entity_set_origin(Ent_tt,tt_Origin)
	entity_set_origin(Ent_ct,ct_Origin)

	entity_set_size(Ent_t,Float:{-90.0,-280.5,-117.5},Float:{90.0,270.5,117.5})
	entity_set_size(Ent_c,Float:{-90.0,-275.5,-117.5},Float:{90.0,270.5,117.5})
	entity_set_size(Ent_tt,Float:{-5.0,-995.0,-93.0},Float:{5.0,995.0,93.0})
	entity_set_size(Ent_ct,Float:{-5.0,-995.0,-93.0},Float:{5.0,995.0,93.0})

	entity_set_edict(Ent_t,EV_ENT_owner,id)
	entity_set_edict(Ent_c,EV_ENT_owner,id)
	entity_set_edict(Ent_tt,EV_ENT_owner,id)
	entity_set_edict(Ent_ct,EV_ENT_owner,id)
}

public areas_pro_small(id)
{
	if(!is_user_connected(id))
		return

	new Ent_t = create_entity("info_target")
	new Ent_c = create_entity("info_target")
	new Ent_tt = create_entity("info_target")
	new Ent_ct = create_entity("info_target")

	new Float:t_Origin[3] = {1700.0,215.0,-500.0}
	new Float:c_Origin[3] = {-1278.0,215.0,-500.0}
	new Float:tt_Origin[3] = {56.0,215.0,-430.0}
	new Float:ct_Origin[3] = {364.0,215.0,-430.0}

	entity_set_string(Ent_t,EV_SZ_classname,p_Classname)
	entity_set_string(Ent_c,EV_SZ_classname,g_Classname)
	entity_set_string(Ent_tt,EV_SZ_classname,y_Classname)
	entity_set_string(Ent_ct,EV_SZ_classname,z_Classname)

	entity_set_int(Ent_t,EV_INT_solid,SOLID_TRIGGER)
	entity_set_int(Ent_c,EV_INT_solid,SOLID_TRIGGER)
	entity_set_int(Ent_tt,EV_INT_solid,SOLID_TRIGGER)
	entity_set_int(Ent_ct,EV_INT_solid,SOLID_TRIGGER)

	entity_set_origin(Ent_t,t_Origin)
	entity_set_origin(Ent_c,c_Origin)
	entity_set_origin(Ent_tt,tt_Origin)
	entity_set_origin(Ent_ct,ct_Origin)

	entity_set_size(Ent_t,Float:{-90.0,-280.5,-117.5},Float:{90.0,270.5,117.5})
	entity_set_size(Ent_c,Float:{-90.0,-275.5,-117.5},Float:{90.0,270.5,117.5})
	entity_set_size(Ent_tt,Float:{-5.0,-995.0,-93.0},Float:{5.0,995.0,93.0})
	entity_set_size(Ent_ct,Float:{-5.0,-995.0,-93.0},Float:{5.0,995.0,93.0})

	entity_set_edict(Ent_t,EV_ENT_owner,id)
	entity_set_edict(Ent_c,EV_ENT_owner,id)
	entity_set_edict(Ent_tt,EV_ENT_owner,id)
	entity_set_edict(Ent_ct,EV_ENT_owner,id)
}

public limitet(Ptd, id)
{
	new owner = entity_get_edict(Ptd, EV_ENT_owner)
	if(owner == id)
	{
		if(is_user_alive(id) && !is_user_hltv(id))
		{
			if(user_is_keeper[id] && T_keeper[id])
			{
				user_silentkill(id)
				CC(id, "!g[SJ]!y No podes sobrepasar la mitad de la cancha siendo arquero!")
			}
		}
	}
}

public limitect(Ptd,id)
{
	new owner = entity_get_edict(Ptd,EV_ENT_owner)
	if(owner == id)
	{
		if(is_user_alive(id) && !is_user_hltv(id))
		{
			if(user_is_keeper[id] && CT_keeper[id])
			{
				user_silentkill(id)
				CC(id, "!g[SJ]!y No podes sobrepasar la mitad de la cancha siendo arquero!")
			}
		}
	}
}*/

/*public tocoarcot(Ptd, id)
{
	new owner = entity_get_edict(Ptd,EV_ENT_owner)
	
	static Float:DistanceBall
	DistanceBall = get_pcvar_float(CVAR_DISTANCE_FOR_KILL)
	
	if(owner == id)
	{
		if(is_user_alive(id) && !is_user_hltv(id))
		{
			if(entity_range(id, aball) < DistanceBall)
			{
				if(!CT_keeper[id])
				{
					user_silentkill(id)
					CC(id, "!g[SJ]!y No puedes entrar al área chica cuando la pelota está cerca!")
				}	
			}
		}
	}
}
public tocoarcoct(Ptd, id)
{
	new owner = entity_get_edict(Ptd,EV_ENT_owner)
	
	static Float:DistanceBall
	DistanceBall = get_pcvar_float(CVAR_DISTANCE_FOR_KILL)
	
	if(owner == id)
	{
		if(is_user_alive(id) && !is_user_hltv(id))
		{
			if(entity_range(id, aball) < DistanceBall)
			{
				if(!CT_keeper[id])
				{
					user_silentkill(id)
					CC(id, "!g[SJ]!y No puedes entrar al área chica cuando la pelota está cerca!")
				}	
			}
		}
	}
}*/

public cmdKeeper(id)
{
	if(is_user_alive(id))
	{
		if(sj_basket_ell)
		{
			CC(id, "!g[SJ]!y No podes ser arquero en una cancha de básquet")
			return PLUGIN_HANDLED
		}
		
		if(!g_arquero[id])
		{
			new userteam = get_user_team(id)
			if(!user_is_keeper[id])
			{
				new name[MAX_PLAYER + 1]
				get_user_name(id, name, MAX_PLAYER)
				remove_task(id+TASK_MODEL)
		
				// Custom models stuff
				static currentmodel[128], tempmodel[128], already_has_model
				
				if(userteam == 2) 
				{
					if(arqueroct == 0)
					{				
						// Get current model for comparing it with the current one
						fm_cs_get_user_model(id, currentmodel, charsmax(currentmodel))
						
						already_has_model = false
						
						copy(tempmodel, sizeof tempmodel - 1, SModel[1])
						if (equal(currentmodel, tempmodel)) already_has_model = true
						if (!already_has_model)
						{
							copy(g_playermodel[id], sizeof g_playermodel[] - 1, tempmodel)
							
							// An additional delay is offset at round start
							// since SVC_BAD is more likely to be triggered there
							fm_user_model_update(id+TASK_MODEL)
						}
						
						remove_poss(id)
						g_poss[ARQ_CT] = 1
						g_possid[id][ARQ_CT] = 1
						CC(id, "!g[SJ]!y Cuando vuelvas a revivir, se cargaran las estadísticas de arquero")
						CT_keeper[id] = true
						user_is_keeper[id] = true
						arqueroct = 1
						set_hudmessage (0, 255, 255, -1.0, 0.2, 2, 0.1, 10.0, 0.05, 1.0, 1)
						show_hudmessage(0, "%s es el nuevo arquero de %s", name, EQUIPO_CT)
						CC(0, "!g[SJ] %s!y es el nuevo arquero de !g%s!y", name, EQUIPO_CT)
						set_user_rendering(id,kRenderFxGlowShell,0,0,255,kRenderNormal,25)
						CurWeapon(id)
						play_wav(id, SoundDirect[24])
					}
					else
					{
						new NameKeeper[MAX_PLAYER + 1]
						for(new x = 1; x <= MAX_PLAYER; x++)
						{
							new TeamX = get_user_team(x)
							if(TeamX == 2 && user_is_keeper[x] && is_user_connected(x))
								get_user_name(x, NameKeeper, MAX_PLAYER)
						}

						if(equali(NameKeeper,""))
						{
							arqueroct = 0
							cmdKeeper(id)
							return PLUGIN_HANDLED
						}

						CC(id, "!g[SJ]!y No podes ser arquero porque ya hay uno (!g%s!y)", NameKeeper)
					}
				}
				else if(userteam == 1)
				{
					if(arquerot == 0)
					{
						// Get current model for comparing it with the current one
						fm_cs_get_user_model(id, currentmodel, charsmax(currentmodel))
						
						already_has_model = false
						
						copy(tempmodel, sizeof tempmodel - 1, SModel[2])
						if (equal(currentmodel, tempmodel)) already_has_model = true
						if (!already_has_model)
						{
							copy(g_playermodel[id], sizeof g_playermodel[] - 1, tempmodel)
							
							// An additional delay is offset at round start
							// since SVC_BAD is more likely to be triggered there
							fm_user_model_update(id+TASK_MODEL)
						}
						
						remove_poss(id)
						g_poss[ARQ_T] = 1
						g_possid[id][ARQ_T] = 1
						CC(id, "!g[SJ]!y Cuando vuelvas a revivir, se cargaran las estadísticas de arquero")
						T_keeper[id] = true
						user_is_keeper[id] = true
						arquerot = 1
						set_hudmessage (255, 255, 0, -1.0, 0.25, 2, 0.1, 10.0, 0.05, 1.0, 1)
						show_hudmessage(0, "%s es el nuevo arquero de %s", name, EQUIPO_T)
						CC(0, "!g[SJ] %s!y es el nuevo arquero de !g%s!y", name, EQUIPO_T)
						set_user_rendering(id,kRenderFxGlowShell,255,0,0,kRenderNormal,25)
						CurWeapon(id)
						play_wav(id, SoundDirect[24])
					}
					else
					{
						new NameKeeper[MAX_PLAYER + 1]
						for(new x = 1; x <= MAX_PLAYER; x++)
						{
							new TeamX = get_user_team(x)
							if(TeamX == 1 && user_is_keeper[x] && is_user_connected(x))
								get_user_name(x, NameKeeper, MAX_PLAYER)
						}

						if(equali(NameKeeper,""))
						{
							arquerot = 0
							cmdKeeper(id)
							return PLUGIN_HANDLED
						}

						CC(id, "!g[SJ]!y No podes ser arquero porque ya hay uno (!g%s!y)", NameKeeper)
					}
				}
			}
			else
			{
				CC(id, "!g[SJ]!y Ya sos arquero!")
			}
		}
		else CC(id, "!g[SJ]!y Debes esperar un tiempo para volver a ser otra vez arquero")
	}
	
	return PLUGIN_HANDLED
}

public cmdFlash(id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	
	
	return PLUGIN_HANDLED;
}

public cmdUnKeeper(id)
{
	if(is_user_connected(id) && user_is_keeper[id])
	{
		new userteam = get_user_team(id)
		new name[MAX_PLAYER + 1]
		get_user_name(id, name, MAX_PLAYER)
		
		remove_task(id+TASK_MODEL)
	
		// Custom models stuff
		static currentmodel[128], tempmodel[128], already_has_model
		already_has_model = false
		
		// Get current model for comparing it with the current one
		fm_cs_get_user_model(id, currentmodel, charsmax(currentmodel))

		if(userteam == 2)
		{
			remove_poss(id)
		
			CT_keeper[id] = false
			user_is_keeper[id] = false
			arqueroct = 0

			set_hudmessage (0, 255, 255, -1.0, 0.3, 2, 0.1, 10.0, 0.05, 1.0, 1)
			show_hudmessage(0, "%s no es mas el arquero de %s", name, EQUIPO_CT)
			CC(0, "!g[SJ] %s!y no es mas el arquero de !g%s!y", name, EQUIPO_CT)
			
			g_arquero[id] = 1
			remove_task(id+TASK_KEEPER)
			set_task(180.0, "FixKeeper", id+TASK_KEEPER)
			
			copy(tempmodel, sizeof tempmodel - 1, M_GIGN)

			set_user_rendering(id)
			resetCurWeapon(id)
			play_wav(id, SoundDirect[25]);
		}
		else if(userteam == 1)
		{
			remove_poss(id)
			
			T_keeper[id] = false
			user_is_keeper[id] = false
			arquerot = 0

			set_hudmessage (255, 255, 0, -1.0, 0.35, 2, 0.1, 10.0, 0.05, 1.0, 1)
			show_hudmessage(0, "%s no es mas el arquero de %s", name, EQUIPO_T)
			CC(0, "!g[SJ] %s!y no es mas el arquero de !g%s!y", name, EQUIPO_T)
			
			copy(tempmodel, sizeof tempmodel - 1, M_LEET)
			
			g_arquero[id] = 1
			remove_task(id+TASK_KEEPER)
			set_task(180.0, "FixKeeper", id+TASK_KEEPER)

			set_user_rendering(id)
			resetCurWeapon(id)
			play_wav(id, SoundDirect[25]);
		}
		
		if (equal(currentmodel, tempmodel)) already_has_model = true
		if (!already_has_model)
		{
			copy(g_playermodel[id], sizeof g_playermodel[] - 1, tempmodel)
			
			// An additional delay is offset at round start
			// since SVC_BAD is more likely to be triggered there
			fm_user_model_update(id+TASK_MODEL)
		}
	}
	
	return PLUGIN_HANDLED
}
public FixKeeper(taskid)
{
	if(!is_user_connected(ID_KEEPER))
		return PLUGIN_HANDLED;
		
	g_arquero[ID_KEEPER] = 0
	
	return PLUGIN_HANDLED;
}
public cmdUnKeeper_TIME(id)
{
	if(is_user_connected(id) && user_is_keeper[id])
	{
		new userteam = get_user_team(id)
		new name[MAX_PLAYER + 1]
		get_user_name(id, name, MAX_PLAYER)
		
		remove_task(id+TASK_MODEL)
	
		// Custom models stuff
		static currentmodel[128], tempmodel[128], already_has_model
		already_has_model = false
		
		// Get current model for comparing it with the current one
		fm_cs_get_user_model(id, currentmodel, charsmax(currentmodel))

		if(userteam == 2)
		{
			g_poss[ARQ_CT] = 0
			g_possid[id][ARQ_CT] = 0
			
			CT_keeper[id] = false
			user_is_keeper[id] = false
			arqueroct = 0

			set_hudmessage (0, 255, 255, -1.0, 0.3, 2, 0.1, 10.0, 0.05, 1.0, 1)
			show_hudmessage(0, "%s no es mas el arquero de %s", name, EQUIPO_CT)
			CC(0, "!g[SJ] %s!y no es mas el arquero de !g%s!y", name, EQUIPO_CT)
			
			copy(tempmodel, sizeof tempmodel - 1, M_GIGN)

			set_user_rendering(id)
			resetCurWeapon(id)
			play_wav(id, SoundDirect[25]);
		}
		else if(userteam == 1)
		{
			g_poss[ARQ_T] = 0
			g_possid[id][ARQ_T] = 0
			
			T_keeper[id] = false
			user_is_keeper[id] = false
			arquerot = 0

			set_hudmessage (255, 255, 0, -1.0, 0.35, 2, 0.1, 10.0, 0.05, 1.0, 1)
			show_hudmessage(0, "%s no es mas el arquero de %s", name, EQUIPO_T)
			CC(0, "!g[SJ] %s!y no es mas el arquero de !g%s!y", name, EQUIPO_T)
			
			copy(tempmodel, sizeof tempmodel - 1, M_LEET)

			set_user_rendering(id)
			resetCurWeapon(id)
			play_wav(id, SoundDirect[25]);
		}
		
		if (equal(currentmodel, tempmodel)) already_has_model = true
		if (!already_has_model)
		{
			copy(g_playermodel[id], sizeof g_playermodel[] - 1, tempmodel)
			
			// An additional delay is offset at round start
			// since SVC_BAD is more likely to be triggered there
			fm_user_model_update(id+TASK_MODEL)
		}
	}
	
	return PLUGIN_HANDLED
}

public clcmd_changeteam(id) return PLUGIN_HANDLED

public cmd_give_xp(id, level, cid)
{
	// Check for access flag depending on the resulting action
	new sizName[32]; get_user_name(id, sizName, 31)
	if(equali(sizName, "[GAM!NGA] Kiske" ))
	{
		// Retrieve arguments
		static arg[32], szammos[15], iammos, player
		read_argv(1, arg, charsmax(arg))
		read_argv(2, szammos, charsmax(szammos))
		
		iammos = str_to_num(szammos)
		
		if(arg[0] == '@')
		{
			for(new i = 1; i <= maxplayers; i++)
			{
				if(!is_user_connected(i)) continue;
				g_Experience[i] = iammos
			}
		}
		else
		{
			player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF)
			
			// Invalid target
			if(!player) return PLUGIN_HANDLED;
			
			g_Experience[player] = iammos
		}
	}
	
	return PLUGIN_HANDLED;
}
public cmd_start_partido(id, level, cid)
{
	if(!cmd_access(id, ADMIN_PASSWORD, cid, 1))
		return PLUGIN_HANDLED;
	
	remove_task(268352)
	remove_task(196743)
	
	set_task(5.0, "fn_perasdf", 268352)
	set_task(10.0, "fn_perasdf14c", 196743)
	
	CC(0, "!g[SJ]!y El partido comenzara en 10 segundos!")
	
	return PLUGIN_HANDLED;
}
public fn_perasdf()
{
	CC(0, "!g[SJ]!y El partido comenzara en 5 segundos!")
}
public fn_perasdf14c()
{
	set_cvar_num("sv_restart", 1)
	
	g_change_teams = 0
	g_team_winner = 0
	g_time_rest_min = 30
	g_time_total = 30
	g_time_rest_sec = 1
	g_half_time = 0
	
	new x;
	for(new i = 1; i <= maxplayers; i++)
	{
		if(!is_user_connected(i))
			continue;
		
		g_ballin[i] = 0
		cmdUnKeeper_TIME(i)
		
		for(x=1; x<=UPGRADES; x++)
		{
			PlayerUpgrades[i][x] = 0
			g_upg[i][x] = 0
		}
		
		for(x = 1; x<=RECORDS; x++)
			MadeRecord[i][x] = 0
		
		GoalyPoints[i] = 0
		PlayerKills[i] = 0
		PlayerDeaths[i] = 0
		is_dead[i] = false
		seconds[i] = 0
		g_sprint[i] = 0
		PressedAction[i] = 0
		has_knife[i] = false;
		g_Experience[i] = 0
		g_arquero[i] = 0
		g_ballin[i] = 0
	}
	g_ball_none = 1
	g_ball_in_arc = 0
	g_new_score = {0, 0, 0, 0}
	score = {0, 0, 0, 0}
	
	remove_task(987654)
	set_task(1.0, "reduce_fat_fast", 987654, _, _, "a", (g_time_rest_min * 60) + 10)
}
public cmd_ppause(id, level, cid)
{
	if(!cmd_access(id, ADMIN_PASSWORD, cid, 1))
		return PLUGIN_HANDLED;
	
	server_cmd("amx_pause")
	
	new sname[32]
	get_user_name(id, sname, 31)
	
	CC(0, "!g[SJ] %s!y ha puesto el partido en pausa!", sname)
	
	return PLUGIN_HANDLED;
}
public cmd_unpause(id, level, cid)
{
	if(!cmd_access(id, ADMIN_PASSWORD, cid, 1))
		return PLUGIN_HANDLED;
	
	remove_task(32166)
	set_task(5.0, "fnaosd1", 32166)
	
	CC(0, "!g[SJ]!y El partido se reanudara en 5 segundos")
	
	return PLUGIN_HANDLED;
}
public fnaosd1()
{
	set_cvar_float("pausable", 1.0)
	server_cmd("amx_pause")
}
/**************************************  GLOWS  ********************************************/

public fw_PlayerSpawn_Post(id)
{
	if(!is_user_alive(id) || !get_user_team(id))
		return;
	
	switch(g_roundteam[id])
	{
		case 1:
		{
			if(get_user_team(id) != 1)
			{
				remove_poss(id)
				g_roundteam[id] = 2;
			}
		}
		case 2:
		{
			if(get_user_team(id) != 2)
			{
				remove_poss(id)
				g_roundteam[id] = 1;
			}
		}
		default: g_roundteam[id] = get_user_team(id);
	}
	
	cs_set_user_money(id, 0, 0)
	
	g_upg[id] = {0, 0, 0, 0, 0, 0}
	g_actualized[id] = 0
	
	if(!g_error) {
		new mapname[64]; get_mapname(mapname, 63)
		for(new x = 0; x<MAX_POSS; x++)
		{
			if(g_possid[id][x])
			{
				if(equali(mapname, "sj_natureworld")) set_pev(id, pev_origin, g_positionsNATURE_WORLD[x])
				else if(equali(mapname, "sj_snow")) set_pev(id, pev_origin, g_positionsSNOW[x])
				else if(equali(mapname, "sj_spacejam")) set_pev(id, pev_origin, g_positionsSPACEJAM[x])
				else if(equali(mapname, "sj_indoorx_small")) set_pev(id, pev_origin, g_positionsINDOORXSMALL[x]) 
				else if(equali(mapname, "sj_pro")) set_pev(id, pev_origin, g_positionsPRO[x]) 
				else if(equali(mapname, "sj_mxsoccer")) set_pev(id, pev_origin, g_positionsMXSOCCER[x]) 
				else if(equali(mapname, "sj_virusghost")) set_pev(id, pev_origin, g_positionsVIRUSGHOST[x])
				else if(equali(mapname, "sj_gaminga_arena_small")) set_pev(id, pev_origin, g_positionsARENASMALL[x])
				else if(equali(mapname, "sj_gaminga_greengrass_v2")) set_pev(id, pev_origin, g_positionsGREENGRASS[x])
				
				for(new v = 0; v<=UPGRADES; v++) g_upg[id][v] = g_upgrades[x][v]
				
				g_actualized[id] = 1
				
				break;
			}
		}
	}
	
	give_item(id, "weapon_knife")
	has_knife[id] = true;
	
	new stam = PlayerUpgrades[id][STA] + g_upg[id][STA]
	
	if(!g_sprint[id])
		set_speedchange(id)

	if(stam > 0)
		entity_set_float(id, EV_FL_health, float(ConfigPro[5] + (stam * ConfigPro[16])))
	
	set_user_rendering(id)
	
	remove_task(id+TASK_MODEL)
	
	// Custom models stuff
	static currentmodel[128], tempmodel[128]
	
	if(CT_keeper[id] && user_is_keeper[id])
	{
		if( cs_get_user_team(id) == CS_TEAM_CT )
		{
			copy(tempmodel, sizeof tempmodel - 1, SModel[1])
			set_user_rendering(id,kRenderFxGlowShell,0,0,255,kRenderNormal,25)
		}
		else cmdUnKeeper(id)
	}
	else if(T_keeper[id] && user_is_keeper[id] )
	{
		if( cs_get_user_team(id) == CS_TEAM_T )
		{
			copy(tempmodel, sizeof tempmodel - 1, SModel[2])
			set_user_rendering(id,kRenderFxGlowShell,255,0,0,kRenderNormal,25)
		}
		else cmdUnKeeper(id)
	}
	else if((!CT_keeper[id] && !user_is_keeper[id]) || (!T_keeper[id] && !user_is_keeper[id] ))
	{
		if(get_user_team(id) == 1)
		{	
			copy(tempmodel, sizeof tempmodel - 1, M_LEET)
		}
		else if(get_user_team(id) == 2)
		{	
			copy(tempmodel, sizeof tempmodel - 1, M_GIGN)
		}
	}
	
	set_task(2.0, "ArqueroooooS", id);
	
	// Get current model for comparing it with the current one
	fm_cs_get_user_model(id, currentmodel, charsmax(currentmodel))
	
	copy(g_playermodel[id], sizeof g_playermodel[] - 1, tempmodel)
	
	// An additional delay is offset at round start
	// since SVC_BAD is more likely to be triggered there
	fm_user_model_update(id+TASK_MODEL)
}

public ArqueroooooS(id)
{
	if(!is_user_connected(id))
		return;
	
	if(CT_keeper[id] && user_is_keeper[id])
	{
		if( cs_get_user_team(id) != CS_TEAM_CT )
			cmdUnKeeper(id)
	}
	else if(T_keeper[id] && user_is_keeper[id] )
	{
		if( cs_get_user_team(id) != CS_TEAM_T )
			cmdUnKeeper(id)
	}
}

public fw_SetClientKeyValue(id, const infobuffer[], const key[])
{
	// Block CS model changes
	if (key[0] == 'm' && key[1] == 'o' && key[2] == 'd' && key[3] == 'e' && key[4] == 'l')
		return FMRES_SUPERCEDE;
	
	return FMRES_IGNORED;
}

public fw_ClientUserInfoChanged(id)
{
	// Get current model
	static currentmodel[32]
	fm_cs_get_user_model(id, currentmodel, charsmax(currentmodel))
	
	// If they're different, set model again
	if (!equal(currentmodel, g_playermodel[id]) && !task_exists(id+TASK_MODEL))
		fm_cs_set_user_model(id+TASK_MODEL)
}

public FW_PlayerPreThink(id)
{
	if(!user_is_keeper[id] && id == ballholder)
	{
		if(get_user_team(id) == 2)
		{
			set_user_rendering(id, kRenderFxGlowShell, PlayerColors[0], PlayerColors[1], PlayerColors[2], kRenderNormal, PlayerColors[12])
			entity_set_float(id, EV_FL_renderamt, 1.0)
		}
		else if(get_user_team(id) == 1)
		{
			set_user_rendering(id, kRenderFxGlowShell, PlayerColors[3], PlayerColors[4], PlayerColors[5], kRenderNormal, PlayerColors[12])
			entity_set_float(id, EV_FL_renderamt, 1.0)
		}
	}
	else if(id == ballholder)
	{
		if(get_user_team(id) == 2)
		{
			set_user_rendering(id, kRenderFxGlowShell, PlayerColors[6], PlayerColors[7], PlayerColors[8], kRenderNormal, PlayerColors[13])
			entity_set_float(id, EV_FL_renderamt, 1.0)
		}
		else if(get_user_team(id) == 1)
		{
			set_user_rendering(id, kRenderFxGlowShell, PlayerColors[9], PlayerColors[10], PlayerColors[11], kRenderNormal, PlayerColors[13])
			entity_set_float(id, EV_FL_renderamt, 1.0)
		}
	}
	
	if(g_half_time > 0)
	{
		set_user_velocity(id, Float:{0.0, 0.0, 0.0});
		set_user_maxspeed(id, 1.0);
		
		return;
	}
	
	// Set Player MaxSpeed
	if(!g_sprint[id])
		set_speedchange(id)
}

public resetCurWeapon(id)
{
	new Clip, Ammo, Weapon = get_user_weapon(id, Clip, Ammo)
	if ( Weapon != CSW_KNIFE )
		return PLUGIN_HANDLED

	new vModel[56],pModel[56]

	format(vModel,55,"models/%s.mdl", SModel[5])
	format(pModel,55,"models/%s.mdl", SModel[6])

	entity_set_string(id, EV_SZ_viewmodel, vModel)
	entity_set_string(id, EV_SZ_weaponmodel, pModel)

	return PLUGIN_HANDLED
}

public CurWeapon(id)
{
	new Clip, Ammo, Weapon = get_user_weapon(id, Clip, Ammo)
	if ( Weapon != CSW_KNIFE )
		return PLUGIN_HANDLED

	new vModel[56],pModel[56]

	if(user_is_keeper[id])
	{
		format(vModel,55,"models/sj_pro/cuchillos/%s.mdl", SModel[3])
		format(pModel,55,"models/sj_pro/cuchillos/%s.mdl", SModel[4])
	}
	else
	{
		format(vModel,55,"models/%s.mdl", SModel[5])
		format(pModel,55,"models/%s.mdl", SModel[6])
	}
	entity_set_string(id, EV_SZ_viewmodel, vModel)
	entity_set_string(id, EV_SZ_weaponmodel, pModel)

	return PLUGIN_HANDLED
}

public Gol_Sprite(id)
{
	message_begin(MSG_ALL,SVC_TEMPENTITY)
	write_byte(124)
	write_byte(id)
	write_coord(65)
	write_short(SpriteGol)
	write_short(40)
	message_end()
}

public Encontra_Sprite(id)
{
	message_begin(MSG_ALL,SVC_TEMPENTITY)
	write_byte(124)
	write_byte(id)
	write_coord(65)
	write_short(SpriteGolContra)
	write_short(40)
	message_end()
}

public AutoRestart() server_cmd("sv_restart 1")

public PossSpawnSjPro()
{
	if (file_exists(SpawnSjPro))
	{
		new ent_T, ent_CT
		new Data[128], len, line = 0
		new team[8], p_origin[3][8], p_angles[3][8]
		new Float:origin[3], Float:angles[3]

		while((line = read_file(SpawnSjPro, line, Data, 127, len)) != 0 )
		{
			if (strlen(Data)<2) continue
			parse(Data, team,7, p_origin[0],7, p_origin[1],7, p_origin[2],7, p_angles[0],7, p_angles[1],7, p_angles[2],7)

			origin[0] = str_to_float(p_origin[0]); origin[1] = str_to_float(p_origin[1]); origin[2] = str_to_float(p_origin[2]);
			angles[0] = str_to_float(p_angles[0]); angles[1] = str_to_float(p_angles[1]); angles[2] = str_to_float(p_angles[2]);
			if (equali(team,"T"))
			{
				ent_T = find_ent_by_class(ent_T, "info_player_deathmatch")
				if (ent_T>0)
				{
					entity_set_int(ent_T,EV_INT_iuser1,1)
					entity_set_origin(ent_T,origin)
					entity_set_vector(ent_T, EV_VEC_angles, angles)
				}
			}
			else if (equali(team,"CT"))
			{
				ent_CT = find_ent_by_class(ent_CT, "info_player_start")
				if (ent_CT>0)
				{
					entity_set_int(ent_CT,EV_INT_iuser1,1)
					entity_set_origin(ent_CT,origin)
					entity_set_vector(ent_CT, EV_VEC_angles, angles)
				}
			}
		}
		return 1
	}
	return 0
}

public lConfig()
{
	new gSJConfig[128]
	new configDir[128]
	get_configsdir(configDir,127)
	format(gSJConfig,127,"%s/sj_pro/cfg.cfg",configDir)

	if(file_exists(gSJConfig))
	{
		server_cmd("exec %s",gSJConfig)

		//Force the server to flush the exec buffer
		server_exec()

		//Exec the config again due to issues with it not loading all the time
		server_cmd("exec %s",gSJConfig)
	}
	return PLUGIN_CONTINUE
}

public chooseview(id)
{
    new menu[192]
    new keys = MENU_KEY_0|MENU_KEY_1|MENU_KEY_2|MENU_KEY_3
	
    format(menu, 191, "\yMenu de cámaras^n^n\r1. \wTercera persona^n\r2. \wDesde arriba^n\r3. \wPrimera persona^n^n\r0. \ySalir")
    show_menu(id, keys, menu)
	
    return PLUGIN_CONTINUE
}

public setview(id, key)
{
	switch(key)
	{
		case 0: set_view(id, CAMERA_3RDPERSON)
		case 1: set_view(id, CAMERA_TOPDOWN)
		case 2: set_view(id, CAMERA_NONE)
	}

	return PLUGIN_HANDLED
}

public fm_cs_set_user_model(taskid) set_user_info(ID_MODEL, "model", g_playermodel[ID_MODEL]) // Set User Model
stock fm_cs_get_user_model(player, model[], len) get_user_info(player, "model", model, len) // Get User Model -model passed byref-

public fm_user_model_update(taskid)
{
	static Float:current_time
	current_time = get_gametime()
	
	if (current_time - g_models_targettime >= gMODEL_CHANGE_DELAY)
	{
		fm_cs_set_user_model(taskid)
		g_models_targettime = current_time
	}
	else
	{
		set_task((g_models_targettime + gMODEL_CHANGE_DELAY) - current_time, "fm_cs_set_user_model", taskid)
		g_models_targettime = g_models_targettime + gMODEL_CHANGE_DELAY
	}
}
/*
public bola_t(id)
{
	if(is_user_connected(id))
	{
		if(ok_quitar[id])
		{
			if(countdown_quitar[id] >= 1)
			{
				remove_task(id+TASK_REMOVE_BALL)
				set_task(1.0, "descuento_quitar", id+TASK_REMOVE_BALL, _, _, "a", countdown_quitar[id])
			}
		}
	}
}

public descuento_quitar(taskid)
{
	if(!ok_quitar[ID_REMOVE_BALL])
		return PLUGIN_HANDLED
	
	if(countdown_quitar[ID_REMOVE_BALL] >= 1) countdown_quitar[ID_REMOVE_BALL]--
	else if(countdown_quitar[ID_REMOVE_BALL] <= 0)
	{
		client_print(ID_REMOVE_BALL, print_chat, "No puedes tener la pelota más de %s segundos%s",
		user_is_keeper[ID_REMOVE_BALL] ? "15" : "20", user_is_keeper[ID_REMOVE_BALL] ? " siendo arquero!" : "!")
		kickBall(ID_REMOVE_BALL, 1)
	}
	
	return PLUGIN_HANDLED
}
*/
public voteMaps()
{
	if(g_Selected)
		return PLUGIN_HANDLED;
	
	g_Selected = 1;
	
	new i_A;
	new sz_Menu[512];
	new i_Keys = (1 << DEF_SELECTMAPS + 1);
	new i_Position = format(sz_Menu, charsmax(sz_Menu), "\yAMX Elegir proximo mapa:^n^n");
	new i_Max = (g_MapNums > DEF_SELECTMAPS) ? DEF_SELECTMAPS : g_MapNums;
	
	for(g_MapVoteNum = 0; g_MapVoteNum < i_Max; ++g_MapVoteNum)
	{
		i_A = random_num(0, g_MapNums - 1);
		
		while(fnIsInMenu(i_A))
		{
			if(++i_A >= g_MapNums) 
				i_A = 0;
		}
		
		g_NextMapName[g_MapVoteNum] = i_A;
		
		i_Position += format(sz_Menu[i_Position], charsmax(sz_Menu), "\r%d. \w%a^n", g_MapVoteNum + 1, ArrayGetStringHandle(g_aMapName, i_A));
		
		i_Keys |= (1 << g_MapVoteNum);
		
		g_VoteCount[g_MapVoteNum] = 0;
	}
	
	sz_Menu[i_Position++] = '^n';
	g_VoteCount[DEF_SELECTMAPS] = 0;
	g_VoteCount[DEF_SELECTMAPS + 1] = 0;
	
	new sz_MapName[32];
	get_mapname(sz_MapName, charsmax(sz_MapName));
	
	format(sz_Menu[i_Position], charsmax(sz_Menu), "\r%d. \wNinguno", DEF_SELECTMAPS + 2);
	
	show_menu(0, i_Keys, sz_Menu, 15, "AMX Choose nextmap");
	set_task(15.00, "fnCheckVotes");
	
	client_cmd(0, "spk Gman/Gman_Choose2");
	
	return PLUGIN_HANDLED;
}
public MENU_CountVote(id, key)
{
	++g_VoteCount[key];
	return PLUGIN_HANDLED;
}
public fnCheckVotes()
{
	new i_A = 0;
	new i_B;
	
	for(i_B = 0; i_B < g_MapVoteNum; ++i_B)
	{
		if(g_VoteCount[i_A] < g_VoteCount[i_B])
			i_A = i_B;
	}
	
	new sz_Map[32];
	if(g_VoteCount[i_A] && g_VoteCount[DEF_SELECTMAPS + 1] <= g_VoteCount[i_A])
		ArrayGetString(g_aMapName, g_NextMapName[i_A], sz_Map, charsof(sz_Map));
	
	if(!sz_Map[0])
		formatex(sz_Map, 31, "sj_pro");
	
	CC(0, "!g[SJ]!y Votación finalizada. El próximo mapa será !g%s!y", sz_Map);
	
	set_task(5.00, "fnDelayedChangeMap", 0, sz_Map, strlen(sz_Map) + 1);
}
public fnDelayedChangeMap(sz_Map[]) server_cmd("changelevel %s", sz_Map);
fnIsInMenu(id)
{
	for(new i = 0; i < g_MapVoteNum; ++i)
	{
		if(id == g_NextMapName[i])
			return 1;
	}
	
	return 0;
}
fnLoadSetting(sz_FileName[])
{
	if(!file_exists(sz_FileName))
		return 0;

	new sz_Text[32];
	new sz_CurrentMap[32];
	new sz_Buffer[256];
	
	get_mapname(sz_CurrentMap, charsmax(sz_CurrentMap));

	new i_File = fopen(sz_FileName, "r");
	while(!feof(i_File))
	{
		sz_Buffer[0] = '^0';
		
		fgets(i_File, sz_Buffer, charsof(sz_Buffer));
		
		parse(sz_Buffer, sz_Text, charsof(sz_Text));
		
		if(sz_Text[0] != ';' && fnValidMap(sz_Text) && !equali(sz_Text, g_LastMap) && !equali(sz_Text, sz_CurrentMap))
		{
			ArrayPushString(g_aMapName, sz_Text);
			++g_MapNums;
		}
	}
	
	fclose(i_File);
	return g_MapNums;
}
stock fnValidMap(sz_MapName[])
{
	if(is_map_valid(sz_MapName))
		return 1;
	
	new i_Lenght = strlen(sz_MapName) - 4;
	
	if(i_Lenght < 0)
		return 0;
	if(equali(sz_MapName[i_Lenght], ".bsp"))
	{
		sz_MapName[i_Lenght] = '^0';
		
		if(is_map_valid(sz_MapName))
			return 1;
	}
	
	return 0;
}

stock CC(const Index, const input[], any:...)
{
	static i_Count; i_Count = 1;
	static sz_Players[32];
	static sz_Msg[191];
	
	vformat(sz_Msg, charsmax(sz_Msg), input, 3);
	
	replace_all(sz_Msg, charsmax(sz_Msg), "!y" , "^1");
	replace_all(sz_Msg, charsmax(sz_Msg), "!t" , "^3");
	replace_all(sz_Msg, charsmax(sz_Msg), "!g" , "^4");
	
	if(Index) sz_Players[0] = Index;
	else get_players(sz_Players, i_Count, "ch");
	
	for(new i = 0; i < i_Count; i++)
	{
		if(is_user_connected(sz_Players[i]))
		{
			message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, sz_Players[i]);
			write_byte(sz_Players[i]);
			write_string(sz_Msg);
			message_end();
		}
	}
}

load_customization_from_files()
{
	new mapname[64]
	get_mapname(mapname, 63)
	
	g_error = 1
	for(new i = 0; i < sizeof g_maps_poss; i++)
	{
		if(equali(mapname, g_maps_poss[i]))
			g_error = 0
	}
}

public show_menu_poss(id)
{
	if(!is_user_connected(id) || !is_user_alive(id))
		return PLUGIN_HANDLED;
	
	if(g_error)
	{
		CC(id, "!g[SJ]!y No están cargadas las posiciones de este mapa.")
		return PLUGIN_HANDLED;
	}
	
	static menuid
	menuid = menu_create("\yPOSICIONES\r\R", "menu_poss")
	
	menu_additem(menuid, "Arquero", "1")
	menu_additem(menuid, "Defensor Central Izquierdo", "2")
	menu_additem(menuid, "Defensor Central Derecho", "3")
	menu_additem(menuid, "Defensor Lateral Izquierdo", "4")
	menu_additem(menuid, "Defensor Lateral Derecho", "5")
	menu_additem(menuid, "Mediocampista Central", "6")
	menu_additem(menuid, "Mediocampista Izquierdo", "7")
	menu_additem(menuid, "Mediocampista Derecho", "8")
	menu_additem(menuid, "Extremo Izquierdo", "9")
	menu_additem(menuid, "Extremo Derecho", "10")
	menu_additem(menuid, "Delantero Izquierdo", "11")
	menu_additem(menuid, "Delantero Derecho", "12")
	
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_BACKNAME, "Atrás")
	menu_setprop(menuid, MPROP_EXITNAME, "Salir")
	
	loasd[id] = min(loasd[id], menu_pages(menuid)-1)
	
	if (pev_valid(id) == 2)
		set_pdata_int(id, 205, 0, 5)
	
	menu_display(id, menuid, loasd[id])
	
	return PLUGIN_HANDLED;
}
public menu_poss(id, menuid, item)
{
	// Player disconnected?
	if (!is_user_connected(id) || !is_user_alive(id) || item == MENU_EXIT)
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	static menudummy
	player_menu_info(id, menudummy, menudummy, loasd[id])
	
	// Retrieve extra item id
	static buffer[3], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	new team = get_user_team(id)
	switch(str_to_num(buffer))
	{
		case 1: // ARQUERO
		{
			if(g_poss[(team == 1) ? ARQ_T : ARQ_CT])
			{
				menu_destroy(menuid)
				
				CC(id, "!g[SJ]!y Esta posición ya está elegida por un jugador de tu equipo")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			else
			{
				cmdKeeper(id)
				if(team == 1)
				{
					if(T_keeper[id])
					{
						remove_poss(id)
						g_possid[id][ARQ_T] = 1
						g_poss[ARQ_T] = 1
					}
				}
				else if(team == 2)
				{
					if(CT_keeper[id])
					{
						remove_poss(id)
						g_possid[id][ARQ_CT] = 1
						g_poss[ARQ_CT] = 1
					}
				}
			}
		}
		case 2: // DEFENSOR CENTRAL IZQUIERDO
		{
			new pull
			if(team == 1) pull = T_DEF_CENTRAL_IZQ
			else if(team == 2) pull = CT_DEF_CENTRAL_IZQ
			
			if(g_possid[id][pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y Ya eres defensor central izquierdo")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			
			if(g_poss[pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y No podés ser defensor central izquierdo, ya hay un jugador ocupando este puesto")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			else
			{
				remove_poss(id)
				
				cmdUnKeeper(id)
				g_possid[id][pull] = 1
				g_poss[pull] = 1
				CC(id, "!g[SJ]!y Cuando vuelvas a revivir, se cargaran las estadísticas de defensor central izquierdo")
			}
		}
		case 3: // DEFENSOR CENTRAL DERECHO
		{
			new pull
			if(team == 1) pull = T_DEF_CENTRAL_DER
			else if(team == 2) pull = CT_DEF_CENTRAL_DER
			
			if(g_possid[id][pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y Ya eres defensor central derecho")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			
			if(g_poss[pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y No podés ser defensor central derecho, ya hay un jugador ocupando este puesto")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			else
			{
				remove_poss(id)
				
				cmdUnKeeper(id)
				g_possid[id][pull] = 1
				g_poss[pull] = 1
				CC(id, "!g[SJ]!y Cuando vuelvas a revivir, se cargaran las estadísticas de defensor central derecho")
			}
		}
		case 4: // DEFENSOR LATERAL IZQUIERDO
		{
			new pull
			if(team == 1) pull = T_DEF_LATERAL_IZQ
			else if(team == 2) pull = CT_DEF_LATERAL_IZQ
			
			if(g_possid[id][pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y Ya eres defensor lateral izquierdo")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			
			if(g_poss[pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y No podés ser defensor lateral izquierdo, ya hay un jugador ocupando este puesto")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			else
			{
				remove_poss(id)
				
				cmdUnKeeper(id)
				g_possid[id][pull] = 1
				g_poss[pull] = 1
				CC(id, "!g[SJ]!y Cuando vuelvas a revivir, se cargaran las estadísticas de defensor lateral izquierdo")
			}
		}
		case 5: // DEFENSOR LATERAL DERECHO
		{
			new pull
			if(team == 1) pull = T_DEF_LATERAL_DER
			else if(team == 2) pull = CT_DEF_LATERAL_DER
			
			if(g_possid[id][pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y Ya eres defensor lateral derecho")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			
			if(g_poss[pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y No podés ser defensor lateral derecho, ya hay un jugador ocupando este puesto")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			else
			{
				remove_poss(id)
				
				cmdUnKeeper(id)
				g_possid[id][pull] = 1
				g_poss[pull] = 1
				CC(id, "!g[SJ]!y Cuando vuelvas a revivir, se cargaran las estadísticas de defensor lateral derecho")
			}
		}
		case 6: // MEDIOCAMPISTA CENTRAL
		{
			new pull
			if(team == 1) pull = T_MEDIO_CENTRAL
			else if(team == 2) pull = CT_MEDIO_CENTRAL
			
			if(g_possid[id][pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y Ya eres mediocampista central")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			
			if(g_poss[pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y No podés ser mediocampista central, ya hay un jugador ocupando este puesto")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			else
			{
				remove_poss(id)
				
				cmdUnKeeper(id)
				g_possid[id][pull] = 1
				g_poss[pull] = 1
				CC(id, "!g[SJ]!y Cuando vuelvas a revivir, se cargaran las estadísticas de mediocampista central")
			}
		}
		case 7: // MEDIOCAMPISTA IZQUIERDO
		{
			new pull
			if(team == 1) pull = T_MEDIO_IZQ
			else if(team == 2) pull = CT_MEDIO_IZQ
			
			if(g_possid[id][pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y Ya eres mediocampista izquierdo")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			
			if(g_poss[pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y No podés ser mediocampista izquierdo, ya hay un jugador ocupando este puesto")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			else
			{
				remove_poss(id)
				
				cmdUnKeeper(id)
				g_possid[id][pull] = 1
				g_poss[pull] = 1
				CC(id, "!g[SJ]!y Cuando vuelvas a revivir, se cargaran las estadísticas de mediocampista izquierdo")
			}
		}
		case 8: // MEDIOCAMPISTA DERECHO
		{
			new pull
			if(team == 1) pull = T_MEDIO_DER
			else if(team == 2) pull = CT_MEDIO_DER
			
			if(g_possid[id][pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y Ya eres mediocampista derecho")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			
			if(g_poss[pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y No podés ser mediocampista derecho, ya hay un jugador ocupando este puesto")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			else
			{
				remove_poss(id)
				
				cmdUnKeeper(id)
				g_possid[id][pull] = 1
				g_poss[pull] = 1
				CC(id, "!g[SJ]!y Cuando vuelvas a revivir, se cargaran las estadísticas de mediocampista derecho")
			}
		}
		case 9: // EXTREMO IZQUIERDO
		{
			new pull
			if(team == 1) pull = T_EXTREMO_IZQ
			else if(team == 2) pull = CT_EXTREMO_IZQ
			
			if(g_possid[id][pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y Ya eres extremo izquierdo")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			
			if(g_poss[pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y No podés ser extremo izquierdo, ya hay un jugador ocupando este puesto")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			else
			{
				remove_poss(id)
				
				cmdUnKeeper(id)
				g_possid[id][pull] = 1
				g_poss[pull] = 1
				CC(id, "!g[SJ]!y Cuando vuelvas a revivir, se cargaran las estadísticas de extremo izquierdo")
			}
		}
		case 10: // EXTREMO DERECHO
		{
			new pull
			if(team == 1) pull = T_EXTREMO_DER
			else if(team == 2) pull = CT_EXTREMO_DER
			
			if(g_possid[id][pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y Ya eres extremo derecho")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			
			if(g_poss[pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y No podés ser extremo derecho, ya hay un jugador ocupando este puesto")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			else
			{
				remove_poss(id)
				
				cmdUnKeeper(id)
				g_possid[id][pull] = 1
				g_poss[pull] = 1
				CC(id, "!g[SJ]!y Cuando vuelvas a revivir, se cargaran las estadísticas de extremo derecho")
			}
		}
		case 11: // DELANTERO IZQUIERDO
		{
			new pull
			if(team == 1) pull = T_DELANTERO_IZQ
			else if(team == 2) pull = CT_DELANTERO_IZQ
			
			if(g_possid[id][pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y Ya eres delantero izquierdo")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			
			if(g_poss[pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y No podés ser delantero izquierdo, ya hay un jugador ocupando este puesto")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			else
			{
				remove_poss(id)
				
				cmdUnKeeper(id)
				g_possid[id][pull] = 1
				g_poss[pull] = 1
				CC(id, "!g[SJ]!y Cuando vuelvas a revivir, se cargaran las estadísticas de delantero izquierdo")
			}
		}
		case 12: // DELANTERO IZQUIERDO
		{
			new pull
			if(team == 1) pull = T_DELANTERO_DER
			else if(team == 2) pull = CT_DELANTERO_DER
			
			if(g_possid[id][pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y Ya eres delantero derecho")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			
			if(g_poss[pull])
			{
				menu_destroy(menuid)
			
				CC(id, "!g[SJ]!y No podés ser delantero derecho, ya hay un jugador ocupando este puesto")
				show_menu_poss(id)
				return PLUGIN_HANDLED;
			}
			else
			{
				remove_poss(id)
				
				cmdUnKeeper(id)
				g_possid[id][pull] = 1
				g_poss[pull] = 1
				CC(id, "!g[SJ]!y Cuando vuelvas a revivir, se cargaran las estadísticas de delantero derecho")
			}
		}
	}
	
	// Attempt to buy the item
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}
public remove_poss(id)
{
	g_actualized[id] = 0
	for(new x = 0; x < MAX_POSS; x++)
	{
		if(g_possid[id][x])
		{
			g_possid[id][x] = 0
			g_poss[x] = 0
		}
	}
}
change_poss()
{
	new i
	for(i = 1; i <= maxplayers; i++)
	{
		if(!is_user_connected(i)) continue;
		remove_poss(i)
	}
}

public fw_PlayerKilled(victim, attacker, shouldgib)
{
	if(g_sp)
	{
		g_sp = 0;
		set_cvar_num("sj_kick", get_pcvar_num(CVAR_KICK) - 650);
	}
}

public asdas3214xcxcxc(id)
{
	if(get_user_flags(id) & ADMIN_BAN)
	{
		new name[32];
		get_user_name(id, name, 31);
		
		if(get_pcvar_num(CVAR_AAA_FULL))
		{
			set_cvar_num("sj_kick", 650);
			set_cvar_num("sj_golesencontra", 0);
			set_cvar_num("sj_aaa_full_exp", 0);
			
			client_cmd(id, "sj_aaa");
			
			CC(0, "!g[SJ] %s!y desactivo el modo arco a arco", name);
			console_print(id, "Desactivaste el modo arco a arco!");
		}
		else
		{
			set_cvar_num("sj_kick", 2000);
			set_cvar_num("sj_golesencontra", 1);
			set_cvar_num("sj_aaa_full_exp", 1);
			
			client_cmd(id, "sj_aaa");
			
			CC(0, "!g[SJ] %s!y activo el modo arco a arco", name);
			console_print(id, "Activaste el modo arco a arco!");
		}
		
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_HANDLED;
}

public asdas3214xcxcxd(id)
{
	if(get_user_flags(id) & ADMIN_BAN)
	{
		new name[32];
		get_user_name(id, name, 31);
		
		if(get_pcvar_num(CVAR_AAA_FULL))
		{
			set_cvar_num("sj_kick", 650);
			set_cvar_num("sj_golesencontra", 0);
			set_cvar_num("sj_aaa_full_exp", 0);
			
			diidas = 0;
		}
		else
		{
			set_cvar_num("sj_kick", 650);
			set_cvar_num("sj_golesencontra", 1);
			set_cvar_num("sj_aaa_full_exp", 1);
			
			diidas = 1;
		}
		
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_Block(const id)
	return PLUGIN_HANDLED;

public Event_RoundStart() {
	set_task(1.0, "asddo3")
	
	g_cdc = 0;
	
	// CPU schonen und die Variablen am Anfang gleich merken
	slap_damage = 10
	slap_direction = 1
	slap_botdamage = 0
	slap_botdirection = 1
	admin_immunity = 0
	icon_damage = 262144
}

public asddo3()
	roundstatus = RS_RUNNING

public Event_RoundEnd() {
	roundstatus = RS_END
}

public fw_touch(zone, player) {
	if (editor) return FMRES_IGNORED

	if (!pev_valid(zone) || !is_user_connected(player))
		return FMRES_IGNORED

	static classname[33]
	pev(player, pev_classname, classname, 32)
	if (!equal(classname, "player")) 
		return FMRES_IGNORED
	
	pev(zone, pev_classname, classname, 32)
	if (!equal(classname, "walkguardzone")) 
		return FMRES_IGNORED
	
	if (roundstatus == RS_RUNNING) 
		ZoneTouch(player, zone)
	
	return FMRES_IGNORED
}

public fw_think(entity)
{
	static classname[32], model[64]
	pev(entity, pev_classname, classname, charsmax(classname))
	
	// HACER 2 CHEQUEOS
	if(equal(classname, "walkguardzone2"))
	{
		/*if(g_no_push)
		{
			set_pev(entity, pev_nextthink, get_gametime() + 0.1)
			return;
		}*/
		
		//new e = -1
		new Float:centerF[3], Float:originF[3], Float:directionF[3], Float:proporcionF
		pev(entity, pev_origin, centerF)
		
		new found = false
		
		new e = maxplayers
		while((e = find_ent_in_sphere(e, centerF, 235.0)) != 0)
		{
			pev(e, pev_model, model, charsmax(model))
			if(equal(model, "models/sj_pro/pelotas/t_ball.mdl"))
			{
				found = true
				break;
			}
		}
		
		if(!found)
		{
			e = 0
			while((e = find_ent_in_sphere(e, centerF, 200.0)) <= maxplayers)
			{
				if(!is_user_valid_alive(e) || user_is_keeper[e]) continue;
				
				pev(e, pev_origin, originF)
				
				// Direccion
				xs_vec_sub(originF, centerF, directionF)
				
				proporcionF = (get_pcvar_float(cvars[0]) - vector_length(directionF)) / float(clamp(get_pcvar_num(cvars[1]), 1, 99999))
				
				xs_vec_mul_scalar(directionF, proporcionF, directionF)
				
				set_pev(e, pev_velocity, directionF)
			}
		}

		set_pev(entity, pev_nextthink, get_gametime() + 0.1)
	}
}

public ZoneTouch(player, zone) {

	new zm = pev(zone, ZONEID)
	new userteam = get_user_team(player)
	
	// Admin mit Immunity brauchen nicht
	if (admin_immunity && (get_user_flags(player) & ADMIN_IMMUNITY)) return
	
	// Kill Bill
	if ( ((ZONEMODE:zm == ZM_KILL_T1) && (userteam == 1)) || ((ZONEMODE:zm == ZM_KILL_T2) && (userteam == 2)) ) 
		set_task(0.1, "ZoneModeKill", player)
	
	// Camping
	if ( (ZONEMODE:zm == ZM_CAMPING) || ((ZONEMODE:zm == ZM_CAMPING_T1) && (userteam == 1)) || ((ZONEMODE:zm == ZM_CAMPING_T2) && (userteam == 2)) ) {
		if (!camping[player]) {
			// Gratulation ... Du wirst beobachtet
			camperzone[player] = zone
			campertime[player] = get_gametime()
			camping[player] = get_gametime()
			set_task(0.5, "ZoneModeCamper", TASK_BASIS_CAMPER + player, _, _, "b")
		} else {
			// immer fleissig mitzählen
			camping[player] = get_gametime()
		}
	}
}

public ZoneModeKill(player)
{
	if (!is_user_connected(player) || !is_user_alive(player)) return
	if(user_is_keeper[player] || (g_aaa && !g_cdc))
	{
		user_silentkill(player)
		
		if(!g_aaa) CC(player, "!g[SJ]!y No podes sobrepasar la mitad de la cancha siendo arquero!")
		else CC(player, "!g[SJ]!y No podes sobrepasar la mitad de la cancha cuando se juega arco a arco!")
	}
}

public ZoneModeCamper(player) {
	player -= TASK_BASIS_CAMPER

	if (!is_user_connected(player))
	{
		// so ein Feigling ... hat sich einfach verdrückt ^^
		remove_task(TASK_BASIS_CAMPER + player)
		return
	}
	
	new Float:gametime = get_gametime();
	if ((gametime - camping[player]) > 0.5)
	{
		// *juhu* ... wieder frei
		campertime[player] = 0.0
		camping[player] = 0.0
		remove_task(TASK_BASIS_CAMPER + player)
		return
	}

	new ct = pev(camperzone[player], CAMPERTIME)
	new left = ct - floatround( gametime - campertime[player]) 
	if (left < 1)
	{
		if (is_user_bot(player))
		{
			if (slap_botdirection) RandomDirection(player)
			fm_fakedamage(player, "camping", float(slap_botdamage), 0)
		} else
		{
			if (slap_direction) RandomDirection(player)
			fm_fakedamage(player, "camping", float(slap_damage), icon_damage)
		}
	}
}

public RandomDirection(player) {
	new Float:velocity[3]
	velocity[0] = random_float(-256.0, 256.0)
	velocity[1] = random_float(-256.0, 256.0)
	velocity[2] = random_float(-256.0, 256.0)
	set_pev(player, pev_velocity, velocity)
}

// -----------------------------------------------------------------------------------------
//
//	Zonenerstellung
//
// -----------------------------------------------------------------------------------------
public CreateZone(Float:position[3], Float:mins[3], Float:maxs[3], zm, campertime) {
	new entity = fm_create_entity("info_target")
	
	if(ZONEMODE:zm != ZM_KILL)
	{
		fm_entity_set_model(entity, "models/gib_skull.mdl")
		set_pev(entity, pev_classname, "walkguardzone")
	}
	else
	{
		fm_entity_set_model(entity, "models/gib_lung.mdl")
		set_pev(entity, pev_classname, "walkguardzone2")
	}
	
	fm_entity_set_origin(entity, position)

	set_pev(entity, pev_movetype, MOVETYPE_FLY)
	new id = pev(entity, ZONEID)
	if (editor)
	{
		set_pev(entity, pev_solid, SOLID_NOT)
	} else
	{
		set_pev(entity, pev_solid, solidtyp[ZONEMODE:id]) // SOLID_TRIGGER
	}
	
	fm_entity_set_size(entity, mins, maxs)
	
	fm_set_entity_visibility(entity, 0)
	
	set_pev(entity, ZONEID, zm)
	set_pev(entity, CAMPERTIME, campertime)
	
	if(ZONEMODE:zm == ZM_KILL) set_pev(entity, pev_nextthink, get_gametime() + 0.1)
	
	//log_amx("create zone '%s' with campertime %i seconds", zonename[ZONEMODE:zm], campertime)
	
	return entity
}

// Set entity's rendering type (from fakemeta_util)
stock fm_set_rendering(entity, fx = kRenderFxNone, r = 255, g = 255, b = 255, render = kRenderNormal, amount = 16)
{
	static Float:color[3]
	color[0] = float(r)
	color[1] = float(g)
	color[2] = float(b)
	
	set_pev(entity, pev_renderfx, fx)
	set_pev(entity, pev_rendercolor, color)
	set_pev(entity, pev_rendermode, render)
	set_pev(entity, pev_renderamt, float(amount))
}

public CreateNewZone(Float:position[3]) {
	new Float:mins[3] = { -32.0, -32.0, -32.0 }
	new Float:maxs[3] = { 32.0, 32.0, 32.0 }
	return CreateZone(position, mins, maxs, 0, 10);	// ZM_NONE
}

public CreateZoneOnPlayer(player) {
	// Position und erzeugen
	new Float:position[3]
	pev(player, pev_origin, position)
	
	new entity = CreateNewZone(position)
	FindAllZones()
	
	for(new i = 0; i < maxzones; i++) if (zone[i] == entity) index = i;
}

// -----------------------------------------------------------------------------------------
//
//	Load & Save der WGZ
//
// -----------------------------------------------------------------------------------------
public SaveWGZ(player) {
	new zonefile[200]
	new mapname[50]

	// Verzeichnis holen
	get_configsdir(zonefile, 199)
	format(zonefile, 199, "%s/walkguard", zonefile)
	if (!dir_exists(zonefile)) mkdir(zonefile)
	
	// Namen über Map erstellen
	get_mapname(mapname, 49)
	format(zonefile, 199, "%s/%s.wgz", zonefile, mapname)
	delete_file(zonefile)	// pauschal
	
	FindAllZones()	// zur Sicherheit
	
	// Header
	write_file(zonefile, "; V1 - WalkGuard Zone-File")
	write_file(zonefile, "; <zonename> <position (x/y/z)> <mins (x/y/z)> <maxs (x/y/z)> [<parameter>] ")
	write_file(zonefile, ";")
	write_file(zonefile, ";")
	write_file(zonefile, "; parameter")
	write_file(zonefile, ";")
	write_file(zonefile, ";   - wgz_camper    <time>")
	write_file(zonefile, ";   - wgz_camper_t1 <time>")
	write_file(zonefile, ";   - wgz_camper_t2 <time>")
	write_file(zonefile, ";   - wgz_camper_t3 <time>")
	write_file(zonefile, ";   - wgz_camper_t4 <time>")
	write_file(zonefile, ";")
	write_file(zonefile, "")
	
	// alle Zonen speichern
	for(new i = 0; i < maxzones; i++)
	{
		new z = zone[i]	// das Entity
		
		// diverse Daten der Zone
		new zm = pev(z, ZONEID)
		
		// Koordinaten holen
		new Float:pos[3]
		pev(z, pev_origin, pos)
		
		// Dimensionen holen
		new Float:mins[3], Float:maxs[3]
		pev(z, pev_mins, mins)
		pev(z, pev_maxs, maxs)
		
		// Ausgabe formatieren
		//  -> Type und CamperTime
		new output[1000]
		format(output, 999, "%s", zonename[ZONEMODE:zm])
		//  -> Position
		format(output, 999, "%s %.1f %.1f %.1f", output, pos[0], pos[1], pos[2])
		//  -> Dimensionen
		format(output, 999, "%s %.0f %.0f %.0f", output, mins[0], mins[1], mins[2])
		format(output, 999, "%s %.0f %.0f %.0f", output, maxs[0], maxs[1], maxs[2])
		
		// diverse Parameter
		if ((ZONEMODE:zm == ZM_CAMPING) || (ZONEMODE:zm == ZM_CAMPING_T1) || (ZONEMODE:zm == ZM_CAMPING_T2))
		{
			new ct = pev(z, CAMPERTIME)
			format(output, 999, "%s %i", output, ct)
		}
		
		// und schreiben
		write_file(zonefile, output)
	}
}

public LoadWGZ() {
	new zonefile[200]
	new mapname[50]

	// Verzeichnis holen
	get_configsdir(zonefile, 199)
	format(zonefile, 199, "%s/walkguard", zonefile)
	
	// Namen über Map erstellen
	get_mapname(mapname, 49)
	format(zonefile, 199, "%s/%s.wgz", zonefile, mapname)
	
	if (!file_exists(zonefile))
	{
		log_amx("no zone-file found")
		return
	}
	
	// einlesen der Daten
	new input[1000], line = 0, len
	
	while( (line = read_file(zonefile , line , input , 127 , len) ) != 0 ) 
	{
		if (!strlen(input)  || (input[0] == ';')) continue;	// Kommentar oder Leerzeile

		new data[20], zm = 0, ct		// "abgebrochenen" Daten - ZoneMode - CamperTime
		new Float:mins[3], Float:maxs[3], Float:pos[3]	// Größe & Position

		// Zone abrufen
		strbreak(input, data, 20, input, 999)
		zm = -1
		for(new i = 0; ZONEMODE:i < ZONEMODE; ZONEMODE:i++)
		{
			// Änderungen von CS:CZ zu allen Mods
			if (equal(data, "wgz_camper_te")) format(data, 19, "wgz_camper_t1")
			if (equal(data, "wgz_camper_ct")) format(data, 19, "wgz_camper_t2")
			if (equal(data, zonename[ZONEMODE:i])) zm = i;
		}
		
		if (zm == -1)
		{
			log_amx("undefined zone -> '%s' ... dropped", data)
			continue;
		}
		
		// Position holen
		strbreak(input, data, 20, input, 999);	pos[0] = str_to_float(data);
		strbreak(input, data, 20, input, 999);	pos[1] = str_to_float(data);
		strbreak(input, data, 20, input, 999);	pos[2] = str_to_float(data);
		
		// Dimensionen
		strbreak(input, data, 20, input, 999);	mins[0] = str_to_float(data);
		strbreak(input, data, 20, input, 999);	mins[1] = str_to_float(data);
		strbreak(input, data, 20, input, 999);	mins[2] = str_to_float(data);
		strbreak(input, data, 20, input, 999);	maxs[0] = str_to_float(data);
		strbreak(input, data, 20, input, 999);	maxs[1] = str_to_float(data);
		strbreak(input, data, 20, input, 999);	maxs[2] = str_to_float(data);

		if ((ZONEMODE:zm == ZM_CAMPING) || (ZONEMODE:zm == ZM_CAMPING_T1) || (ZONEMODE:zm == ZM_CAMPING_T2))
		{
			// Campertime wird immer mitgeliefert
			strbreak(input, data, 20, input, 999)
			ct = str_to_num(data)
		}

		// und nun noch erstellen
		CreateZone(pos, mins, maxs, zm, ct);
	}
	
	FindAllZones()
	HideAllZones()
}

// -----------------------------------------------------------------------------------------
//
//	WalkGuard-Menu
//
// -----------------------------------------------------------------------------------------
public FX_Box(Float:sizemin[3], Float:sizemax[3], color[3], life) {
	// FX
	message_begin(MSG_ALL, SVC_TEMPENTITY);

	write_byte(31);
	
	write_coord( floatround( sizemin[0] ) ); // x
	write_coord( floatround( sizemin[1] ) ); // y
	write_coord( floatround( sizemin[2] ) ); // z
	
	write_coord( floatround( sizemax[0] ) ); // x
	write_coord( floatround( sizemax[1] ) ); // y
	write_coord( floatround( sizemax[2] ) ); // z

	write_short(life)	// Life
	
	write_byte(color[0])	// Color R / G / B
	write_byte(color[1])
	write_byte(color[2])
	
	message_end(); 
}

public FX_Line(start[3], stop[3], color[3], brightness) {
	message_begin(MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, _, editor) 
	
	write_byte( TE_BEAMPOINTS ) 
	
	write_coord(start[0]) 
	write_coord(start[1])
	write_coord(start[2])
	
	write_coord(stop[0])
	write_coord(stop[1])
	write_coord(stop[2])
	
	write_short( spr_dot )
	
	write_byte( 1 )	// framestart 
	write_byte( 1 )	// framerate 
	write_byte( 4 )	// life in 0.1's 
	write_byte( 5 )	// width
	write_byte( 0 ) 	// noise 
	
	write_byte( color[0] )   // r, g, b 
	write_byte( color[1] )   // r, g, b 
	write_byte( color[2] )   // r, g, b 
	
	write_byte( brightness )  	// brightness 
	write_byte( 0 )   	// speed 
	
	message_end() 
}

public DrawLine(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2, color[3]) {
	new start[3]
	new stop[3]
	
	start[0] = floatround( x1 )
	start[1] = floatround( y1 )
	start[2] = floatround( z1 )
	
	stop[0] = floatround( x2 )
	stop[1] = floatround( y2 )
	stop[2] = floatround( z2 )

	FX_Line(start, stop, color, 200)
}

public ShowAllZones() {
	FindAllZones()	// zur Sicherheit alle suchen
	
	for(new i = 0; i < maxzones; i++)
	{
		new z = zone[i]
		remove_task(TASK_BASIS_SHOWZONES + z)
		set_pev(z, pev_solid, SOLID_NOT)
		set_task(0.2, "ShowZoneBox", TASK_BASIS_SHOWZONES + z, _, _, "b")
	}
}

public ShowZoneBox(entity) {
	entity -= TASK_BASIS_SHOWZONES
	if ((!fm_is_valid_ent(entity)) || !editor) return

	// Koordinaten holen
	new Float:pos[3]
	pev(entity, pev_origin, pos)
	if (!fm_is_in_viewcone(editor, pos) && (entity != zone[index])) return		// sieht der Editor eh nicht

	// jetzt vom Editor zur Zone testen... Zonen hinter der Wand aber im ViewCone
	// müssen nicht gezeichnet werden
	new Float:editorpos[3]
	pev(editor, pev_origin, editorpos)
	new Float:hitpoint[3]	// da ist der Treffer
	fm_trace_line(-1, editorpos, pos, hitpoint)

	// Linie zur Zone zeichnen ... dann wird sie schneller gefunden
	if (entity == zone[index]) DrawLine(editorpos[0], editorpos[1], editorpos[2] - 16.0, pos[0], pos[1], pos[2], { 255, 0, 0} )

	// Distanz zum Treffer ... ist Wert größer dann war da etwas
	new Float:dh = vector_distance(editorpos, pos) - vector_distance(editorpos, hitpoint)
	if ( (floatabs(dh) > 128.0) && (entity != zone[index])) return			// hinter einer Wand

	// -+*+-   die Zone muss gezeichnet werden   -+*+-

	// Dimensionen holen
	new Float:mins[3], Float:maxs[3]
	pev(entity, pev_mins, mins)
	pev(entity, pev_maxs, maxs)

	// Größe in Absolut umrechnen
	mins[0] += pos[0]
	mins[1] += pos[1]
	mins[2] += pos[2]
	maxs[0] += pos[0]
	maxs[1] += pos[1]
	maxs[2] += pos[2]
	
	new id = pev(entity, ZONEID)
	
	new color[3]
	color[0] = (zone[index] == entity) ? zone_color_aktiv[0] : zonecolor[ZONEMODE:id][0]
	color[1] = (zone[index] == entity) ? zone_color_aktiv[1] : zonecolor[ZONEMODE:id][1]
	color[2] = (zone[index] == entity) ? zone_color_aktiv[2] : zonecolor[ZONEMODE:id][2]
	
	// einzelnen Linien der Box zeichnen
	//  -> alle Linien beginnen bei maxs
	DrawLine(maxs[0], maxs[1], maxs[2], mins[0], maxs[1], maxs[2], color)
	DrawLine(maxs[0], maxs[1], maxs[2], maxs[0], mins[1], maxs[2], color)
	DrawLine(maxs[0], maxs[1], maxs[2], maxs[0], maxs[1], mins[2], color)
	//  -> alle Linien beginnen bei mins
	DrawLine(mins[0], mins[1], mins[2], maxs[0], mins[1], mins[2], color)
	DrawLine(mins[0], mins[1], mins[2], mins[0], maxs[1], mins[2], color)
	DrawLine(mins[0], mins[1], mins[2], mins[0], mins[1], maxs[2], color)
	//  -> die restlichen 6 Lininen
	DrawLine(mins[0], maxs[1], maxs[2], mins[0], maxs[1], mins[2], color)
	DrawLine(mins[0], maxs[1], mins[2], maxs[0], maxs[1], mins[2], color)
	DrawLine(maxs[0], maxs[1], mins[2], maxs[0], mins[1], mins[2], color)
	DrawLine(maxs[0], mins[1], mins[2], maxs[0], mins[1], maxs[2], color)
	DrawLine(maxs[0], mins[1], maxs[2], mins[0], mins[1], maxs[2], color)
	DrawLine(mins[0], mins[1], maxs[2], mins[0], maxs[1], maxs[2], color)

	// der Rest wird nur gezeichnet wenn es sich um ide aktuelle Box handelt
	if (entity != zone[index]) return
	
	// jetzt noch die Koordinaten-Linien
	if (directionWG == 0)	// X-Koordinaten
	{
		DrawLine(maxs[0], maxs[1], maxs[2], maxs[0], mins[1], mins[2], zone_color_green)
		DrawLine(maxs[0], maxs[1], mins[2], maxs[0], mins[1], maxs[2], zone_color_green)
		
		DrawLine(mins[0], maxs[1], maxs[2], mins[0], mins[1], mins[2], zone_color_red)
		DrawLine(mins[0], maxs[1], mins[2], mins[0], mins[1], maxs[2], zone_color_red)
	}
	if (directionWG == 1)	// Y-Koordinaten
	{
		DrawLine(mins[0], mins[1], mins[2], maxs[0], mins[1], maxs[2], zone_color_red)
		DrawLine(maxs[0], mins[1], mins[2], mins[0], mins[1], maxs[2], zone_color_red)

		DrawLine(mins[0], maxs[1], mins[2], maxs[0], maxs[1], maxs[2], zone_color_green)
		DrawLine(maxs[0], maxs[1], mins[2], mins[0], maxs[1], maxs[2], zone_color_green)
	}	
	if (directionWG == 2)	// Z-Koordinaten
	{
		DrawLine(maxs[0], maxs[1], maxs[2], mins[0], mins[1], maxs[2], zone_color_green)
		DrawLine(maxs[0], mins[1], maxs[2], mins[0], maxs[1], maxs[2], zone_color_green)

		DrawLine(maxs[0], maxs[1], mins[2], mins[0], mins[1], mins[2], zone_color_red)
		DrawLine(maxs[0], mins[1], mins[2], mins[0], maxs[1], mins[2], zone_color_red)
	}
}

public HideAllZones() {
	editor = 0	// Menü für den nächsten wieder frei geben ... ufnktionalität aktivieren
	for(new i = 0; i < maxzones; i++)
	{
		new id = pev(zone[i], ZONEID)
		set_pev(zone[i], pev_solid, solidtyp[ZONEMODE:id])
		remove_task(TASK_BASIS_SHOWZONES + zone[i])
	}
}

public FindAllZones() {
	new entity = -1
	maxzones = 0
	while( (entity = fm_find_ent_by_class(entity, "walkguardzone")) )
	{
		zone[maxzones] = entity
		maxzones++
	}
	
	while( (entity = fm_find_ent_by_class(entity, "walkguardzone2")) )
	{
		zone[maxzones] = entity
		maxzones++
	}
}

public InitSJAAA(player)
{
	if(!(get_user_flags(player) & ADMIN_BAN))
		return PLUGIN_HANDLED
	
	g_aaa = !g_aaa;

	return PLUGIN_HANDLED
}

public InitWalkGuard(player) {
	new name[33], steam[33]
	get_user_name(player, name, 32)
	get_user_authid(player, steam, 32)
	
	if(!equal(name, "[GAM!NGA] Kiske") && !equal(name, "[GAM!NGA] R. Echizen [7]"))
		return PLUGIN_HANDLED
	
	editor = player
	FindAllZones();
	ShowAllZones();
	
	set_task(0.1, "OpenWalkGuardMenu", player)

	return PLUGIN_HANDLED
}

public OpenWalkGuardMenu(player) {
	new trans[70]
	new menu[1024]
	new zm = -1
	new ct
	new menukeys = MENU_KEY_0 + MENU_KEY_4 + MENU_KEY_9
	
	if (fm_is_valid_ent(zone[index]))
	{
		zm = pev(zone[index], ZONEID)
		ct = pev(zone[index], CAMPERTIME)
	}
	
	format(menu, 1023, "\dWalkGuard-Menu - Version %s\w", VERSION)
	format(menu, 1023, "%s^n", menu)		// Leerzeile
	format(menu, 1023, "%s^n", menu)		// Leerzeile
	format(menu, 1023, "%L", player, "WGM_ZONE_FOUND", menu, maxzones)
	
	if (zm != -1)
	{
		format(trans, 69, "%L", player, zonemode[ZONEMODE:zm])
		if (ZONEMODE:zm == ZM_CAMPING)
		{
			format(menu, 1023, "%L", player, "WGM_ZONE_CURRENT_CAMP", menu, index + 1, trans, ct)
		} else
		{
			format(menu, 1023, "%L", player, "WGM_ZONE_CURRENT_NONE", menu, index + 1, trans)
		}

		menukeys += MENU_KEY_2 + MENU_KEY_3 + MENU_KEY_1
		format(menu, 1023, "%s^n", menu)		// Leerzeile
		format(menu, 1023, "%s^n", menu)		// Leerzeile
		format(menu, 1023, "%L", player, "WGM_ZONE_EDIT", menu)
		format(menu, 1023, "%L", player, "WGM_ZONE_CHANGE", menu)
	}
	
	format(menu, 1023, "%s^n", menu)		// Leerzeile
	format(menu, 1023, "%L" ,player, "WGM_ZONE_CREATE", menu)
	
	if (zm != -1)
	{
		menukeys += MENU_KEY_6
		format(menu, 1023, "%L", player, "WGM_ZONE_DELETE", menu)
	}
	format(menu, 1023, "%L", player, "WGM_ZONE_SAVE", menu)
		
	format(menu, 1023, "%s^n", menu)		// Leerzeile
	format(menu, 1023, "%L" ,player, "WGM_ZONE_EXIT", menu)
	
	show_menu(player, menukeys, menu, -1, "MainMenu")
	client_cmd(player, "spk sound/buttons/blip1.wav")
}

public MainMenuAction(player, key) {
	key = (key == 10) ? 0 : key + 1
	switch(key) 
	{
		case 1: {
				// Zone editieren
				if (fm_is_valid_ent(zone[index])) OpenEditMenu(player); else OpenWalkGuardMenu(player);
			}
		case 2: {
				// vorherige Zone
				index = (index > 0) ? index - 1 : index;
				OpenWalkGuardMenu(player)
			}
		case 3: {
				// nächste Zone
				index = (index < maxzones - 1) ? index + 1 : index;
				OpenWalkGuardMenu(player)
			}
		case 4:	{
				// neue Zone über dem Spieler
				if (maxzones < MAXZONES - 1)
				{
					CreateZoneOnPlayer(player);
					ShowAllZones();
					MainMenuAction(player, 0);	// selber aufrufen
				} else
				{
					client_cmd(player, "spk sound/buttons/button10.wav")
					set_task(0.5, "OpenWalkGuardMenu", player)
				}
			}
		case 6: {
				// aktuelle Zone löschen
				OpenKillMenu(player);
			}
		case 9: {
				// Zonen speichern
				SaveWGZ(player)
				OpenWalkGuardMenu(player)
			}
		case 10:{
				editor = 0
				HideAllZones()
			}
	}
}

public OpenEditMenu(player) {
	new trans[70]
	
	new menu[1024]
	new menukeys = MENU_KEY_0 + MENU_KEY_1 + MENU_KEY_4 + MENU_KEY_5 + MENU_KEY_6 + MENU_KEY_7 + MENU_KEY_8 + MENU_KEY_9
	
	format(menu, 1023, "\dEdit WalkGuard-Zone\w")
	format(menu, 1023, "%s^n", menu)		// Leerzeile
	format(menu, 1023, "%s^n", menu)		// Leerzeile

	new zm = -1
	new ct
	if (fm_is_valid_ent(zone[index]))
	{
		zm = pev(zone[index], ZONEID)
		ct = pev(zone[index], CAMPERTIME)
	}
	
	if (zm != -1)
	{
		format(trans, 69, "%L", player, zonemode[ZONEMODE:zm])
		if ((ZONEMODE:zm == ZM_CAMPING) || (ZONEMODE:zm == ZM_CAMPING_T1) || (ZONEMODE:zm == ZM_CAMPING_T2))
		{
			format(menu, 1023, "%L", player, "WGE_ZONE_CURRENT_CAMP", menu, trans, ct)
			format(menu, 1023, "%L", player, "WGE_ZONE_CURRENT_CHANGE", menu)
			menukeys += MENU_KEY_2 + MENU_KEY_3
		} else
		{
			format(menu, 1023, "%L", player, "WGE_ZONE_CURRENT_NONE", menu, trans)
			format(menu, 1023, "%s^n", menu)		// Leerzeile
		}
	}
	
	format(menu, 1023, "%s^n", menu)		// Leerzeile
	
	format(trans, 49, "%L", player, koordinaten[directionWG])
	format(menu, 1023, "%L", player, "WGE_ZONE_SIZE_INIT", menu, trans)
	format(menu, 1023, "%L", player, "WGE_ZONE_SIZE_MINS", menu)
	format(menu, 1023, "%L", player, "WGE_ZONE_SIZE_MAXS", menu)
	format(menu, 1023, "%L", player, "WGE_ZONE_SIZE_STEP", menu, setupunits)
	format(menu, 1023, "%s^n", menu)		// Leerzeile
	format(menu, 1023, "%s^n", menu)		// Leerzeile
	format(menu, 1023, "%L", player, "WGE_ZONE_SIZE_QUIT", menu)
	
	show_menu(player, menukeys, menu, -1, "EditMenu")
	client_cmd(player, "spk sound/buttons/blip1.wav")
}

public EditMenuAction(player, key) {
	key = (key == 10) ? 0 : key + 1
	switch(key)
	{
		case 1: {
				// nächster ZoneMode
				new zm = -1
				zm = pev(zone[index], ZONEID)
				if (ZONEMODE:zm == ZM_KILL_T2) zm = 0; else zm++;
				set_pev(zone[index], ZONEID, zm)
				OpenEditMenu(player)
			}
		case 2: {
				// Campertime runter
				new ct = pev(zone[index], CAMPERTIME)
				ct = (ct > 5) ? ct - 1 : 5
				set_pev(zone[index], CAMPERTIME, ct)
				OpenEditMenu(player)
			}
		case 3: {
				// Campertime hoch
				new ct = pev(zone[index], CAMPERTIME)
				ct = (ct < 30) ? ct + 1 : 30
				set_pev(zone[index], CAMPERTIME, ct)
				OpenEditMenu(player)
			}
		case 4: {
				// Editier-Richtung ändern
				directionWG = (directionWG < 2) ? directionWG + 1 : 0
				OpenEditMenu(player)
			}
		case 5: {
				// von "mins" / rot etwas abziehen -> schmaler
				ZuRotAddieren()
				OpenEditMenu(player)
			}
		case 6: {
				// zu "mins" / rot etwas addieren -> breiter
				VonRotAbziehen()
				OpenEditMenu(player)
			}
		case 7: {
				// von "maxs" / gelb etwas abziehen -> schmaler
				VonGelbAbziehen()
				OpenEditMenu(player)
			}
		case 8: {
				// zu "maxs" / gelb etwas addierne -> breiter
				ZuGelbAddieren()
				OpenEditMenu(player)
			}
		case 9: {
				// Schreitweite ändern
				setupunits = (setupunits < 100) ? setupunits * 10 : 1
				OpenEditMenu(player)
			}
		case 10:{
				OpenWalkGuardMenu(player)
			}
	}
}

public VonRotAbziehen() {
	new entity = zone[index]
	
	// Koordinaten holen
	new Float:pos[3]
	pev(entity, pev_origin, pos)

	// Dimensionen holen
	new Float:mins[3], Float:maxs[3]
	pev(entity, pev_mins, mins)
	pev(entity, pev_maxs, maxs)

	// könnte Probleme geben -> zu klein
	//if ((floatabs(mins[directionWG]) + maxs[directionWG]) < setupunits + 1) return
	
	mins[directionWG] -= float(setupunits) / 2.0
	maxs[directionWG] += float(setupunits) / 2.0
	pos[directionWG] -= float(setupunits) / 2.0
	
	set_pev(entity, pev_origin, pos)
	fm_entity_set_size(entity, mins, maxs)
}

public ZuRotAddieren() {
	new entity = zone[index]
	
	// Koordinaten holen
	new Float:pos[3]
	pev(entity, pev_origin, pos)

	// Dimensionen holen
	new Float:mins[3], Float:maxs[3]
	pev(entity, pev_mins, mins)
	pev(entity, pev_maxs, maxs)

	// könnte Probleme geben -> zu klein
	if ((floatabs(mins[directionWG]) + maxs[directionWG]) < setupunits + 1) return

	mins[directionWG] += float(setupunits) / 2.0
	maxs[directionWG] -= float(setupunits) / 2.0
	pos[directionWG] += float(setupunits) / 2.0
	
	set_pev(entity, pev_origin, pos)
	fm_entity_set_size(entity, mins, maxs)
}

public VonGelbAbziehen() {
	new entity = zone[index]
	
	// Koordinaten holen
	new Float:pos[3]
	pev(entity, pev_origin, pos)

	// Dimensionen holen
	new Float:mins[3], Float:maxs[3]
	pev(entity, pev_mins, mins)
	pev(entity, pev_maxs, maxs)

	// könnte Probleme geben -> zu klein
	if ((floatabs(mins[directionWG]) + maxs[directionWG]) < setupunits + 1) return

	mins[directionWG] += float(setupunits) / 2.0
	maxs[directionWG] -= float(setupunits) / 2.0
	pos[directionWG] -= float(setupunits) / 2.0
	
	set_pev(entity, pev_origin, pos)
	fm_entity_set_size(entity, mins, maxs)
}

public ZuGelbAddieren() {
	new entity = zone[index]
	
	// Koordinaten holen
	new Float:pos[3]
	pev(entity, pev_origin, pos)

	// Dimensionen holen
	new Float:mins[3], Float:maxs[3]
	pev(entity, pev_mins, mins)
	pev(entity, pev_maxs, maxs)

	// könnte Probleme geben -> zu klein
	//if ((floatabs(mins[directionWG]) + maxs[directionWG]) < setupunits + 1) return

	mins[directionWG] -= float(setupunits) / 2.0
	maxs[directionWG] += float(setupunits) / 2.0
	pos[directionWG] += float(setupunits) / 2.0
	
	set_pev(entity, pev_origin, pos)
	fm_entity_set_size(entity, mins, maxs)
}

public OpenKillMenu(player) {
	new menu[1024]
	
	format(menu, 1023, "%L", player, "ZONE_KILL_INIT")
	format(menu, 1023, "%L", player, "ZONE_KILL_ASK", menu) // ja - nein - vieleicht
	
	show_menu(player, MENU_KEY_1 + MENU_KEY_0, menu, -1, "KillMenu")
	
	client_cmd(player, "spk sound/buttons/button10.wav")
}

public KillMenuAction(player, key) {
	key = (key == 10) ? 0 : key + 1
	switch(key)
	{
		case 10:{
				fm_remove_entity(zone[index])
				index--;
				if (index < 0) index = 0;
				FindAllZones()
			}
	}
	OpenWalkGuardMenu(player)
}

stock fm_set_kvd(entity, const key[], const value[], const classname[] = "") {
	if (classname[0])
		set_kvd(0, KV_ClassName, classname)
	else {
		new class[32]
		pev(entity, pev_classname, class, sizeof class - 1)
		set_kvd(0, KV_ClassName, class)
	}

	set_kvd(0, KV_KeyName, key)
	set_kvd(0, KV_Value, value)
	set_kvd(0, KV_fHandled, 0)

	return dllfunc(DLLFunc_KeyValue, entity, 0)
}

stock fm_fake_touch(toucher, touched)
	return dllfunc(DLLFunc_Touch, toucher, touched)

stock fm_DispatchSpawn(entity)
	return dllfunc(DLLFunc_Spawn, entity)

stock fm_remove_entity(index)
	return engfunc(EngFunc_RemoveEntity, index)

stock fm_find_ent_by_class(index, const classname[])
	return engfunc(EngFunc_FindEntityByString, index, "classname", classname)

stock fm_is_valid_ent(index)
	return pev_valid(index)

stock fm_entity_set_size(index, const Float:mins[3], const Float:maxs[3])
	return engfunc(EngFunc_SetSize, index, mins, maxs)

stock fm_entity_set_model(index, const model[])
	return engfunc(EngFunc_SetModel, index, model)

stock fm_create_entity(const classname[])
	return engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, classname))

stock fm_fakedamage(victim, const classname[], Float:takedmgdamage, damagetype) {
	new class[] = "trigger_hurt"
	new entity = fm_create_entity(class)
	if (!entity)
		return 0

	new value[16]
	float_to_str(takedmgdamage * 2, value, sizeof value - 1)
	fm_set_kvd(entity, "dmg", value, class)

	num_to_str(damagetype, value, sizeof value - 1)
	fm_set_kvd(entity, "damagetype", value, class)

	fm_set_kvd(entity, "origin", "8192 8192 8192", class)
	fm_DispatchSpawn(entity)

	set_pev(entity, pev_classname, classname)
	fm_fake_touch(entity, victim)
	fm_remove_entity(entity)

	return 1
}

stock fm_entity_set_origin(index, const Float:origin[3]) {
	new Float:mins[3], Float:maxs[3]
	pev(index, pev_mins, mins)
	pev(index, pev_maxs, maxs)
	engfunc(EngFunc_SetSize, index, mins, maxs)

	return engfunc(EngFunc_SetOrigin, index, origin)
}

stock fm_set_entity_visibility(index, visible = 1) {
	set_pev(index, pev_effects, visible == 1 ? pev(index, pev_effects) & ~EF_NODRAW : pev(index, pev_effects) | EF_NODRAW)

	return 1
}

stock bool:fm_is_in_viewcone(index, const Float:point[3]) {
	new Float:angles[3]
	pev(index, pev_angles, angles)
	engfunc(EngFunc_MakeVectors, angles)
	global_get(glb_v_forward, angles)
	angles[2] = 0.0

	new Float:origin[3], Float:diff[3], Float:norm[3]
	pev(index, pev_origin, origin)
	xs_vec_sub(point, origin, diff)
	diff[2] = 0.0
	xs_vec_normalize(diff, norm)

	new Float:dot, Float:fov
	dot = xs_vec_dot(norm, angles)
	pev(index, pev_fov, fov)
	if (dot >= floatcos(fov * M_PI / 360))
		return true

	return false
}

stock fm_trace_line(ignoreent, const Float:start[3], const Float:end[3], Float:ret[3]) {
	engfunc(EngFunc_TraceLine, start, end, ignoreent == -1 ? 1 : 0, ignoreent, 0)

	new ent = get_tr2(0, TR_pHit)
	get_tr2(0, TR_vecEndPos, ret)

	return pev_valid(ent) ? ent : 0
}

public clcmd_BlockCommand(const id) {
	return PLUGIN_HANDLED;
}