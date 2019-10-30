#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <fakemeta_util>
#include <hamsandwich>
#include <engine>
#include <fun>
#include <xs>
#include <unixtime>
#include <dhudmsg>
#include <sqlx>
//#include <model_changer>
#include <dhudmessage>
#include <entity_maths>
#include <orpheu>
#include <orpheu_stocks>

#define EASY_MULT		1.0
#define EASY_MODS(%1)	(%1 - ((%1 * 70) / 100))

new g_block_weapons = 0;
new g_block_speed = 0;
new g_block_headz = 0;
new g_game_tejos = 0;
new Float:g_headz_origin[3];
new Float:g_distance_tejos[33];
new Float:g_distance_tejosid[33];
new g_pos_tejos = 0;
new g_game_race = 0;
new g_race_position = 1;
new g_block_habs = 0;
new g_game_bomba = 0;
new Float:g_game_bomba_radius;
new g_touch_cabeza[33]
new sRangoText[33][32];
new sLevelText[33][32];

new g_render_color;

new g_grab_player[33]
new Float:grab_totaldis[33]
new Float:g_grab_player_gravity[33];
new dotsprite;

new g_render[33];

new cvar[10]

new const g_sZombiePlagueName[] = "Zombie Plague";
new const g_sZombiePlagueVersion[] = "v4.3";

new g_leet[33];
new g_leet_mode = 0;

new g_chat[33];
new g_chat_mode = 0;

new g_bot_question[33];
new Float:g_bot_order[33];

new g_plata_gastada[33];

new g_weap_leg[33];
new g_weap_leg_choose[33];
new nadie_la_tiene = 0;
new nadie_la_tiene2 = 0;

new g_leg_lvl[33]
new g_leg_lvl_vex[33]
new g_leg_z_kills[33]
new g_leg_hits[33]
new g_leg_dmg[33]
new g_leg_dmg_nem[33]
new g_leg_dmg_aniq[33]
new g_leg_heads[33]
new g_leg_habs[33][5];

new g_camera[33]

new g_hardmode;
new const EMOTICONES[][] = {
	":)", ":(", ":D", ":S", ":|", ":cool:"
}
new const EMOTICONES_SPR[][] = {
	"1", "2", "3", "4", "5", "6"
}
new g_iSpirteIndex[6];

/*new g_erik_health
new g_one_time_erik;*/

//#define ZR_BETA
//#define AUTO_BHOP
//#define EVENT_NAVIDAD 				// 10/12 - 25/01
//#define EVENT_AMOR					// 12/02 - 25/02
//#define EVENT_SEMANA_INFECCION		// 13/06 - 20/06

#define SEMICLIP_INVIS
#define MAX_CLIP

#define PREMIOS_TORNEO

#define MODELS_CHANGE_DELAY 	1.3
/*
	TODO:
	
	CAMBIOS:
*/

/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ IMPORTANTES ]
=======================================================================================*/
#define TIME_THINK_HUD			get_gametime() + 0.5
#define TIME_THINK_LEADER 		get_gametime() + 600.0
#define TIME_THINK_TANTIME		get_gametime() + 60.0

#define UPDATE_XP_MULT_INFECT	(random_num(7, 13) + g_level[victim] + (g_range[victim] * 200))
#define UPDATE_XP_MULT_KILL		(random_num(11, 15) + g_level[victim] + (g_range[victim] * 200))

#define SQL_HOST		"127.0.0.1"
#define SQL_USER		""
#define SQL_PASS			""
#define SQL_TABLE		""

#define sub(%1,%2) 				(%2 |= (1<<(%1&31)))
#define cub(%1,%2) 				(%2 &= ~(1 <<(%1&31)))
#define hub(%1,%2) 				(%2 & (1<<(%1&31)))

#define set_bit(%1,%2) 			(%2 |= (1<<%1))
#define clear_bit(%1,%2) 		(%2 &= ~(1<<%1))
#define has_bit(%1,%2) 			(%2 & (1<<%1))

/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ VARIABLES GLOBALES - MEZCLADO ]
=======================================================================================*/
enum
{
	BIT_PREMIUM = 0,
	BIT_CONNECTED,
	BIT_ALIVE,
	BIT_MENU_ADMIN,
	//BIT_CHANGE_NAME,
	
	BIT_MAX
}
new g_data[BIT_MAX];
new g_iSelfKill[33];
new g_level[33];
new g_humanclass[33];
new g_humanclassnext[33];
new Float:g_mult_xp[33];
new Float:g_mult_aps[33];
new g_mult_point[33];
new g_ur = 0;
new g_super_ur = 0;
new g_antidote_count[33];
new g_madness_count[33];
new g_slowdown[33];
new Float:g_Flooding[33] = {0.0, ...}
new g_Flood[33] = {0, ...}
new g_dmg_nem[33];
new g_view[33];
new g_selected_model[33];
new g_one_anniq;
new g_one_duel;
new Float:g_fLastCommand[33];
new g_gk_num[33];
new OrpheuStruct:g_ppmove;
new g_total_logros;
new g_logros_completed[33];
new user_shoot[33]
new Float:user_shoot_speed = 0.1
new g_mapa_especial[2][64];
new g_mapa_esp = 0;
new g_dead_health[33];

/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ HATS ]
=======================================================================================*/
#if defined PREMIOS_TORNEO
enum
{
	HAT_AFRO = 0,
	HAT_AWESOME,
	HAT_CHEESEFACE,
	HAT_DARTHVADER2,
	HAT_DEVIL,
	HAT_EARTH,
	HAT_HALLOWEEN,
	HAT_NAVID1,
	HAT_NAVID2,
	HAT_JACKJACK,
	HAT_JS,
	HAT_MASTERCHIEF,
	HAT_PSYCHO,
	HAT_SASHA,
	HAT_SCREAM,
	HAT_SMILEY,
	HAT_SPARTAN,
	HAT_TYNO,
	HAT_YODA,
	HAT_ZIPPY,
	HAT_PHIZZ,
	HAT_RECCE,
	
	MAX_HATS
}
new const g_hat_name[][] = { "Afro", "Awesome", "Cheese", "Darth", "Devil", "Dust", "Halloween", "X-Mas",
"Noel", "Jack", "Java", "Chief", "Psycho", "Sasha", "Scream", "Smile", "Spartan", "Mau5", "Prevail", "Zippy", "Phizz", "ReCCe", "Ninguno" }

new const g_hat_mdl[][] = { "afro", "awesome", "cheeseface", "darth2_big", "devil", "earth", "halloween", "hat_navid",
"hat_navid2", "jackjack", "js", "masterchief", "psycho", "sasha", "scream", "smiley", "spartan", "tyno", "prevail", "zippy", "jackinbox", "clonetrooper", "ninguno" }

new const MAX_EFFECTS_HATS[][][] = {
	{"+2 a VIDA HUMANA", "", ""}, // AFRO -- []
	{"+5 a VIDA HUMANA", "+5 a VIDA ZOMBIE", ""}, // AWESOME -- []
	{"+3 a VELOCIDAD HUMANA", "+2 a DAÑO HUMANO", ""}, // CHEESE
	{"+5 a GRAVEDAD HUMANA", "+3 a VELOCIDAD ZOMBIE", "+2 a DAÑO HUMANO"}, // DARTH
	{"+3 a DAÑO HUMANO/ZOMBIE", "+3 a VELOCIDAD HUMANA/ZOMBIE", ""}, // DEVIL
	{"+3 a VELOCIDAD HUMANA", "+3 a VELOCIDAD ZOMBIE", "+2 a AURA DE LUZ"}, // DUST -- []
	{"ASUSTAS A LOS DEMÁS", "", ""}, // HALLOWEEN
	{"DISFRUTA LA NAVIDAD", "", ""}, // X-MAS -- []
	{"+1 a VIDA HUMANA", "+1 a VIDA ZOMBIE", "DISFRUTA LA NAVIDAD"}, // NOEL -- []
	{"+3 a GRAVEDAD ZOMBIE", "+2 a VIDA ZOMBIE", ""}, // JACK -- []
	{"+2 a DAÑO ZOMBIE", "+3 a VIDA ZOMBIE", ""}, // JAVA -- []
	{"+5 a VELOCIDAD HUMANA/ZOMBIE", "+5 a VIDA HUMANA/ZOMBIE", "+2 a DAÑO HUMANO"}, // CHIEF
	{"+4 a DAÑO HUMANO", "+3 a VELOCIDAD HUMANA", "LOCURA - A veces se transforma en zombie"}, // PSYCHO
	{"+3 a VELOCIDAD HUMANA", "+3 a GRAVEDAD HUMANA", "+2 a DAÑO HUMANO"}, // SASHA
	{"+3 a VIDA HUMANA/ZOMBIE", "+2 a GRAVEDAD HUMANA/ZOMBIE", "+3 a DAÑO HUMANO/ZOMBIE"}, // SCREAM
	{"+3 a DAÑO HUMANO/ZOMBIE", "+2 a VELOCIDAD HUMANA/ZOMBIE", ""}, // SMILEY
	{"+5 a VELOCIDAD HUMANA/ZOMBIE", "GUERRERO - Su daño con cuchillo es x5", ""}, // SPARTAN
	{"+1 a TODAS LAS HABILIDADES", "+5 a DAÑO HUMANO", "WOOW - Puede teletransportarse una vez"}, // MAU5 -- []
	{"+5 a VELOCIDAD HUMANA", "+5 a GRAVEDAD HUMANA", "+3 a DAÑO ZOMBIE"}, // YODA -- []
	{"+2 a TODAS LAS HABILIDADES", "+5 a DAÑO HUMANO/ZOMBIE", ":oktern3:"}, // ZIPPY -- []
	{"+1 a TODAS LAS HABILIDADES", "+3 a DAÑO HUMANO", "+x1 Experiencia"}, // PHIZZ -- []
	{"+2 a TODAS LAS HABILIDADES", "+3 a DAÑO HUMANO", "+x1 Experiencia"} // RECCE -- []
}
new const REQ_HATS[][] = {
	{"Matar a 5.000 zombies"}, // AFRO -- []
	{"Infectar a 5.000 humanos"}, // AWESOME -- []
	{"Tirar la bazooka siendo nemesis y no matar a nadie^n\rNOTA: \wSolo activo cuando hay 20 jugadores VIVOS o más"}, // CHEESE
	{"Matar a 20 zombies e infectar a 25 humanos en una ronda^n\rNOTA: \wSolo activo cuando hay 20 jugadores o más"}, // DARTH
	{"Ganar la ronda wesker sin utilizar ningún LASER y sin agacharte^n\rNOTA: \wSolo activo cuando hay 20 jugadores o más"}, // DEVIL
	{"Jugar 7 días"}, // DUST -- []
	{"Comprar el gorro calabaza"}, // HALLOWEEN
	{"Comprar el gorro navideño"}, // X-MAS -- []
	{"Conseguir el logro: \y¿ OTRO GORRO NAVIDEÑO ?"}, // NOEL -- []
	{"Matar a 100 nemesis"}, // JACK -- []
	{"Matar a 100 survivors"}, // JAVA -- []
	{"Subir la habilidad VELOCIDAD HUMANA al máximo y^nmatar a un FP con cuchillo^n\rNOTA: \wEl FP se debe matar luego de subir la habilidad al máximo"}, // CHIEF
	{"Conseguir el logro: \yBOMBA FALLIDA \wy \yVIRUS"}, // PSYCHO
	{"Matar a 400 humanos siendo aniquilador y sobrevivir"}, // SASHA
	{"Realizar 500.000 de daño con la pistola Glock 18C en un mapa^n\rNOTA: \wSolo activo cuando hay 20 jugadores o más"}, // SCREAM
	{"Jugar 3 rondas armageddon en un mismo mapa"}, // SMILEY
	{"Matar a 25 zombies con cuchillo en un mismo mapa^n\rNOTA: \wSolo activo cuando hay 18 jugadores o más"}, // SPARTAN
	{"Subir todas las habilidades zombie al máximo"}, // MAU5 -- []
	{"Subir al Rango Y"}, // YODA -- []
	{"Subir todas las habilidades zombies y humanas al máximo y^nsubir cualquier anillo hasta el Grado S"}, // ZIPPY -- []
	{"No podés conseguir este gorro"}, // PHIZZ -- []
	{"No podés conseguir este gorro"} // RECCE -- []
	
}
new const MAX_EFFECTS_HATS_HABS[][][] = {
	{{0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}},
	{{2, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}}, // AFRO
	{{5, 0, 0, 0, 0, 0, 0}, {5, 0, 0, 0, 0, 0, 0}}, // AWESOME
	{{0, 3, 0, 2, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}}, // CHEESE
	{{0, 0, 5, 2, 0, 0, 0}, {0, 3, 0, 0, 0, 0, 0}}, // DARTH
	{{0, 3, 0, 3, 0, 0, 0}, {0, 3, 0, 3, 0, 0, 0}}, // DEVIL
	{{0, 3, 0, 0, 0, 2, 0}, {0, 3, 0, 0, 0, 0, 0}}, // DUST
	{{0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}}, // HALLOWEEN
	{{0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}}, // X-MAS
	{{1, 0, 0, 0, 0, 0, 0}, {1, 0, 0, 0, 0, 0, 0}}, // NOEL
	{{0, 0, 0, 0, 0, 0, 0}, {2, 0, 3, 0, 0, 0, 0}}, // JACK
	{{0, 0, 0, 0, 0, 0, 0}, {3, 0, 0, 2, 0, 0, 0}}, // JAVA
	{{5, 5, 0, 2, 0, 0, 0}, {5, 5, 0, 0, 0, 0, 0}}, // CHIEF
	{{0, 3, 0, 4, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}}, // PSYCHO
	{{0, 3, 3, 2, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}}, // SASHA
	{{3, 0, 2, 3, 0, 0, 0}, {3, 0, 2, 3, 0, 0, 0}}, // SCREAM
	{{0, 2, 0, 3, 0, 0, 0}, {0, 2, 0, 3, 0, 0, 0}}, // SMILEY
	{{0, 5, 0, 0, 0, 0, 0}, {0, 5, 0, 0, 0, 0, 0}}, // SPARTAN
	{{1, 1, 1, 6, 1, 1, 0}, {1, 1, 1, 1, 0, 0, 0}}, // MAU5
	{{0, 5, 5, 0, 0, 0, 0}, {0, 0, 0, 3, 0, 0, 0}}, // YODA
	{{2, 2, 2, 7, 2, 2, 0}, {2, 2, 2, 7, 0, 0, 0}}, // ZIPPY
	{{1, 1, 1, 4, 1, 1, 0}, {1, 1, 1, 1, 0, 0, 0}}, // PHIZZ
	{{2, 2, 2, 5, 2, 2, 0}, {2, 2, 2, 2, 0, 0, 0}} // RECCE
}
#else
enum
{
	HAT_AFRO = 0,
	HAT_AWESOME,
	HAT_CHEESEFACE,
	HAT_DARTHVADER2,
	HAT_DEVIL,
	HAT_EARTH,
	HAT_HALLOWEEN,
	HAT_NAVID1,
	HAT_NAVID2,
	HAT_JACKJACK,
	HAT_JS,
	HAT_MASTERCHIEF,
	HAT_PSYCHO,
	HAT_SASHA,
	HAT_SCREAM,
	HAT_SMILEY,
	HAT_SPARTAN,
	HAT_TYNO,
	HAT_YODA,
	HAT_ZIPPY,
	
	MAX_HATS
}
new const g_hat_name[][] = { "Afro", "Awesome", "Cheese", "Darth", "Devil", "Dust", "Halloween", "X-Mas",
"Noel", "Jack", "Java", "Chief", "Psycho", "Sasha", "Scream", "Smile", "Spartan", "Mau5", "Prevail", "Zippy", "Ninguno" }

new const g_hat_mdl[][] = { "afro", "awesome", "cheeseface", "darth2_big", "devil", "earth", "halloween", "hat_navid",
"hat_navid2", "jackjack", "js", "masterchief", "psycho", "sasha", "scream", "smiley", "spartan", "tyno", "prevail", "zippy", "ninguno" }

new const MAX_EFFECTS_HATS[][][] = {
	{"+2 a VIDA HUMANA", "", ""}, // AFRO -- []
	{"+5 a VIDA HUMANA", "+5 a VIDA ZOMBIE", ""}, // AWESOME -- []
	{"+3 a VELOCIDAD HUMANA", "+2 a DAÑO HUMANO", ""}, // CHEESE
	{"+5 a GRAVEDAD HUMANA", "+3 a VELOCIDAD ZOMBIE", "+2 a DAÑO HUMANO"}, // DARTH
	{"+3 a DAÑO HUMANO/ZOMBIE", "+3 a VELOCIDAD HUMANA/ZOMBIE", ""}, // DEVIL
	{"+3 a VELOCIDAD HUMANA", "+3 a VELOCIDAD ZOMBIE", "+2 a AURA DE LUZ"}, // DUST -- []
	{"ASUSTAS A LOS DEMÁS", "", ""}, // HALLOWEEN
	{"DISFRUTA LA NAVIDAD", "", ""}, // X-MAS -- []
	{"+1 a VIDA HUMANA", "+1 a VIDA ZOMBIE", "DISFRUTA LA NAVIDAD"}, // NOEL -- []
	{"+3 a GRAVEDAD ZOMBIE", "+2 a VIDA ZOMBIE", ""}, // JACK -- []
	{"+2 a DAÑO ZOMBIE", "+3 a VIDA ZOMBIE", ""}, // JAVA -- []
	{"+5 a VELOCIDAD HUMANA/ZOMBIE", "+5 a VIDA HUMANA/ZOMBIE", "+2 a DAÑO HUMANO"}, // CHIEF
	{"+4 a DAÑO HUMANO", "+3 a VELOCIDAD HUMANA", "LOCURA - A veces se transforma en zombie"}, // PSYCHO
	{"+3 a VELOCIDAD HUMANA", "+3 a GRAVEDAD HUMANA", "+2 a DAÑO HUMANO"}, // SASHA
	{"+3 a VIDA HUMANA/ZOMBIE", "+2 a GRAVEDAD HUMANA/ZOMBIE", "+3 a DAÑO HUMANO/ZOMBIE"}, // SCREAM
	{"+3 a DAÑO HUMANO/ZOMBIE", "+2 a VELOCIDAD HUMANA/ZOMBIE", ""}, // SMILEY
	{"+5 a VELOCIDAD HUMANA/ZOMBIE", "GUERRERO - Su daño con cuchillo es x5", ""}, // SPARTAN
	{"+1 a TODAS LAS HABILIDADES", "+5 a DAÑO HUMANO", "WOOW - Puede teletransportarse una vez"}, // MAU5 -- []
	{"+5 a VELOCIDAD HUMANA", "+5 a GRAVEDAD HUMANA", "+3 a DAÑO ZOMBIE"}, // YODA -- []
	{"+2 a TODAS LAS HABILIDADES", "+5 a DAÑO HUMANO/ZOMBIE", ":oktern3:"} // ZIPPY -- []
}
new const REQ_HATS[][] = {
	{"Matar a 5.000 zombies"}, // AFRO -- []
	{"Infectar a 5.000 humanos"}, // AWESOME -- []
	{"Tirar la bazooka siendo nemesis y no matar a nadie^n\rNOTA: \wSolo activo cuando hay 20 jugadores VIVOS o más"}, // CHEESE
	{"Matar a 20 zombies e infectar a 25 humanos en una ronda^n\rNOTA: \wSolo activo cuando hay 20 jugadores o más"}, // DARTH
	{"Ganar la ronda wesker sin utilizar ningún LASER y sin agacharte^n\rNOTA: \wSolo activo cuando hay 20 jugadores o más"}, // DEVIL
	{"Jugar 7 días"}, // DUST -- []
	{"Comprar el gorro calabaza"}, // HALLOWEEN
	{"Comprar el gorro navideño"}, // X-MAS -- []
	{"Conseguir el logro: \y¿ OTRO GORRO NAVIDEÑO ?"}, // NOEL -- []
	{"Matar a 100 nemesis"}, // JACK -- []
	{"Matar a 100 survivors"}, // JAVA -- []
	{"Subir la habilidad VELOCIDAD HUMANA al máximo y^nmatar a un FP con cuchillo^n\rNOTA: \wEl FP se debe matar luego de subir la habilidad al máximo"}, // CHIEF
	{"Conseguir el logro: \yBOMBA FALLIDA \wy \yVIRUS"}, // PSYCHO
	{"Matar a 400 humanos siendo aniquilador y sobrevivir"}, // SASHA
	{"Realizar 500.000 de daño con la pistola Glock 18C en un mapa^n\rNOTA: \wSolo activo cuando hay 20 jugadores o más"}, // SCREAM
	{"Jugar 3 rondas armageddon en un mismo mapa"}, // SMILEY
	{"Matar a 25 zombies con cuchillo en un mismo mapa^n\rNOTA: \wSolo activo cuando hay 18 jugadores o más"}, // SPARTAN
	{"Subir todas las habilidades zombie al máximo"}, // MAU5 -- []
	{"Subir al Rango Y"}, // YODA -- []
	{"Subir todas las habilidades zombies y humanas al máximo y^nsubir cualquier anillo hasta el Grado S"} // ZIPPY -- []
}
new const MAX_EFFECTS_HATS_HABS[][][] = {
	{{0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}},
	{{2, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}}, // AFRO
	{{5, 0, 0, 0, 0, 0, 0}, {5, 0, 0, 0, 0, 0, 0}}, // AWESOME
	{{0, 3, 0, 2, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}}, // CHEESE
	{{0, 0, 5, 2, 0, 0, 0}, {0, 3, 0, 0, 0, 0, 0}}, // DARTH
	{{0, 3, 0, 3, 0, 0, 0}, {0, 3, 0, 3, 0, 0, 0}}, // DEVIL
	{{0, 3, 0, 0, 0, 2, 0}, {0, 3, 0, 0, 0, 0, 0}}, // DUST
	{{0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}}, // HALLOWEEN
	{{0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}}, // X-MAS
	{{1, 0, 0, 0, 0, 0, 0}, {1, 0, 0, 0, 0, 0, 0}}, // NOEL
	{{0, 0, 0, 0, 0, 0, 0}, {2, 0, 3, 0, 0, 0, 0}}, // JACK
	{{0, 0, 0, 0, 0, 0, 0}, {3, 0, 0, 2, 0, 0, 0}}, // JAVA
	{{5, 5, 0, 2, 0, 0, 0}, {5, 5, 0, 0, 0, 0, 0}}, // CHIEF
	{{0, 3, 0, 4, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}}, // PSYCHO
	{{0, 3, 3, 2, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}}, // SASHA
	{{3, 0, 2, 3, 0, 0, 0}, {3, 0, 2, 3, 0, 0, 0}}, // SCREAM
	{{0, 2, 0, 3, 0, 0, 0}, {0, 2, 0, 3, 0, 0, 0}}, // SMILEY
	{{0, 5, 0, 0, 0, 0, 0}, {0, 5, 0, 0, 0, 0, 0}}, // SPARTAN
	{{1, 1, 1, 6, 1, 1, 0}, {1, 1, 1, 1, 0, 0, 0}}, // MAU5
	{{0, 5, 5, 0, 0, 0, 0}, {0, 0, 0, 3, 0, 0, 0}}, // YODA
	{{2, 2, 2, 7, 2, 2, 0}, {2, 2, 2, 7, 0, 0, 0}} // ZIPPY
}
#endif

new g_hat_ent[33];
new g_hat[33][MAX_HATS];
new g_hat_equip[33];
new g_kill_zombie[33];
new g_infect_human[33];
new g_dmg_glock[33];
new g_happy[33];
new g_kill_knife[33];
new g_kill_knife_spartan[33];
new g_convert_zombie[33];
new Float:g_tp_save[33][3];
new g_tp_load[33];
new g_timeleft_rest = 20;


/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ LOTTERY ]
=======================================================================================*/
new g_bet[33];
new g_bet_num[33];
new g_bet_done[33];
new g_gamblers;
new g_well_acc;
/*new g_Lottery_sDate[32];
new g_Lottery_sName[32];
new g_Lottery_iBet;
new g_Lottery_sMenu;
new g_Lottery_sMenuDea;*/


/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ ANILLOS - COLLARES ]
=======================================================================================*/
new const g_ringsnecks_names[][][] = {
	{
		"Anillo de las rebajas",
		"Anillo de la experiencia",
		"Anillo de los ammo packs"
	},
	{
		"Collar del fuego",
		"Collar del frío",
		"Collar del daño"
	},
	{
		"Multiplicador de APs +x1.0",
		"Multiplicador de XP +x1.0",
		"Multiplicador de Puntos +x1.0"
	}
}
new const g_ringsnecks_names_pp[][][] = {
	{
		"De las rebajas",
		"De la experiencia",
		"De los ammo packs"
	},
	{
		"Del fuego",
		"Del frío",
		"Del daño"
	},
	{
		"Multiplicador de APs +x1.0",
		"Multiplicador de XP +x1.0",
		"Multiplicador de Puntos +x1.0"
	}
}
enum
{
	RING_COST_ITEM_EXTRA = 0,
	RING_XP_MULT,
	RING_APS_MULT,
	
	RING_LIST
}
enum
{
	NECK_FIRE = 0,
	NECK_FROST,
	NECK_DAMAGE,
	
	NECK_LIST
}
enum
{
	RING = 0,
	NECK,
	
	RN_MAX
}
new g_rn[33][RN_MAX][RING_LIST];
new g_rn_equip[33][RN_MAX][RING_LIST];

new g_artefactos_equipados[33][4];


/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ MODOS ]
=======================================================================================*/
new g_armageddon_round;

new g_wesker_round;
new g_wesker[33];
new g_wesker_laser[33];
new g_wesker_noduck[33];

new g_sniper_round;
new g_sniper[33];
new g_sniper_power[33];
new g_zombies_left;
new g_zombies_left_total;

new g_tribal_round;
new g_tribal_human[33];
new g_tribal_power;
new g_tribal_id[2];
new g_tribal_pos = 0;
new g_tribal_acomodado = 0;

new g_fp_round;
new g_fp[33];
new g_fp_power;
new g_fp_acomodado = 0;
new g_speed_reduced[33];
new g_fp_id;
new g_fp_min;

new g_alvspre_round;
new g_alien[33];
new Float:g_alien_origin[3];
new g_predator[33];
new g_power_invis;
new g_alvspred_id[2];
new g_alvspred_pos = 0;
new g_alvspred_acomodado = 0;
new g_pred_hat = -1;
new g_alien_power;
new Float:g_alien_push[3];

new g_annihilation_round;
new g_annihilator[33];
new g_anniq_kill;

new g_bazooka[33];
new g_bazooka_mode[33];
new g_bomb_aniq[33];
new g_surv_immunity[33];


/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ EVENTOS ]
=======================================================================================*/
new Float:g_flLastTouchTime[33];

enum
{
	box_red = 0,
	box_green,
	box_blue,
	box_yellow,
	
	max_box_color
}
const box_white = box_yellow + 1;
new g_box[33][max_box_color];
new g_head_zombie[33][max_box_color+1];

new Float:g_fLastCommandLove[33];
new g_love_count[33];
new g_love_count_rec[33];
new g_love_count_adm[33];
new g_love_count_staff[33];
new g_lover[33];
new g_candy[33][5];
new g_candy_count[33];

#if defined EVENT_AMOR
new const g_candy_cost[] = {50, 55, 60, 65, 100};
#endif

#if defined EVENT_SEMANA_INFECCION
new maxInfects[33];
new infectsInRound[33];
new maxInfectsInRound[33];
new infectsCombo[33];
new maxInfectsCombo[33];
#endif


/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ ITEMS EXTRAS ]
=======================================================================================*/
const ZP_TEAM_ZOMBIE = (1 << 0);
const ZP_TEAM_HUMAN = (1 << 1);
const ZP_TEAM_NEMESIS = (1 << 2);
const ZP_TEAM_SURVIVOR = (1 << 3);
enum
{
	EXTRA_NVISION = 0,
	EXTRA_ANTIDOTE,
	EXTRA_MADNESS,
	EXTRA_INFBOMB,
	EXTRA_LONGJUMP,
	EXTRA_UNLIMITED_CLIP,
	EXTRA_PIPE,
	EXTRA_HP_100,
	EXTRA_HP_500,
	EXTRA_ARMOR,
	EXTRA_HP_5000,
	EXTRA_HP_10000,
	EXTRA_HP_15000,
	EXTRA_HE,
	EXTRA_FL,
	EXTRA_SM,
	EXTRA_ANTBOMB,
	
	MAX_ITEMS_EXTRAS
};
new Float:g_iEXTRA_ITEMS_Costs[MAX_ITEMS_EXTRAS] = { 20.0, 22.0, 24.0, 30.0, 21.0, 22.0, 1000.0, 17.0, 27.0, 23.0, 27.0, 43.0, 58.0, 8.0, 7.0, 11.0, 100.0 };
new g_iEXTRA_ITEMS_Teams[MAX_ITEMS_EXTRAS] = { ZP_TEAM_HUMAN, ZP_TEAM_ZOMBIE, ZP_TEAM_ZOMBIE, ZP_TEAM_ZOMBIE, ZP_TEAM_HUMAN|ZP_TEAM_ZOMBIE, ZP_TEAM_HUMAN, ZP_TEAM_HUMAN,
ZP_TEAM_HUMAN, ZP_TEAM_HUMAN, ZP_TEAM_HUMAN, ZP_TEAM_ZOMBIE, ZP_TEAM_ZOMBIE, ZP_TEAM_ZOMBIE, ZP_TEAM_HUMAN, ZP_TEAM_HUMAN, ZP_TEAM_HUMAN, ZP_TEAM_ZOMBIE };

new g_antidotecount;
new g_unclip[33];
new g_longjump[33];
new g_bSuperJump;

#define GRENADE_LVL_REQUIRED	150
#define BUBBLE_LVL_REQUIRED		225


/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ RANGOS ]
=======================================================================================*/
#define MAX_CHARS	27
new const g_range_letters[MAX_CHARS][] = {"Z", "Y", "X", "W", "V", "U", "T", "S", "R", "Q", "P", "O", "Ñ",
"N", "M", "L", "K", "J", "I", "H", "G", "F", "E", "D", "C", "B", "A"};
new g_range[33];

new const g_range_req[] = {
	500,	// HUMANOS INFECTADOS
	1000,	// ZOMBIES MATADOS
	15000,	// AMMO PACKS
	50,		// PUNTOS HUMANOS
	50,		// PUNTOS ZOMBIES
	5000	// HEADSHOTS
}


/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ SEMICLIP - INVIS ]
=======================================================================================*/
#if defined SEMICLIP_INVIS
new g_player_team[33];
new g_player_solid[33];
new g_player_restore[33];
#endif
new g_invis[33];

/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ ESTADÍSTICAS ]
=======================================================================================*/
enum
{
	MINUTES = 0,
	HOURS,
	DAYS,
	
	ALL_DATES
}
enum
{
	DAMAGE = 0,
	HEADSHOTS,
	KILLS_ZOMBIES,
	KILLS_HUMANS,
	INFECTS,
	COMBO_MAX,
	KILLS_NEMESIS,
	KILLS_SURVIVOR,
	KILLS_WESKER,
	KILLS_TRIBAL,
	KILLS_ALIEN,
	KILLS_PREDATOR,
	KILLS_ANNIHILATOR,
	KILLS_SNIPER,
	KILLS_ZOMBIES_HEAD,
	
	ALL_STATS
}
enum
{
	DONE = 0,
	TAKEN,
	
	ALL_STATS_MIN
}
enum
{
	NONE = 0,
	NEMESIS = 6,
	SURVIVOR,
	WESKER,
	TRIBAL,
	ALIEN,
	PREDATOR,
	ANNIHILATOR,
	SNIPER
}
new g_time_playing[33][ALL_DATES]
new g_stats[33][ALL_STATS][ALL_STATS_MIN]
new g_mode[33]


/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ COMBOS ]
=======================================================================================*/
new g_combo[33]
new g_combo_damage[33]
new g_combo_leader
new g_combo_leader_text[15]
new g_combo_leader_name[32]


/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ MySQL ]
=======================================================================================*/
new Handle:g_sql_tuple;
new Handle:g_sql_connection;
new g_sql_errornum;
new g_sql_error[512];

new g_password[33][32];
new g_register[33];
new g_logged[33];
new g_zr_pj[33];
new sql_name_admin[32];
new sql_baneado_el[32];
new sql_expira_el[32];
new sql_reason[128];
new g_ban[33];
new g_vinc[33];

new g_leader_name[32];
new g_leader_xp;
//new g_leader_id;
new g_leader_level;
new g_leader_range;
new g_leader_xp_text[15]
new g_leader_vicius_name[32];
new g_leader_vicius_minutes;
new g_leader_vicius_days_t[64];

/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ ARMAS ]
=======================================================================================*/
new g_wpn_auto_on[33];
new g_grenade[33];
new g_bubble[33];
new g_bubble_cost[33];
//new g_bubble_eff[33];
new g_pipe[33];
new g_pipe_count[33];
new g_pipe_all;
new const g_level_grenades[] = {1, 25, 25, 75, 75, 150, 150, 225, 500};
new const g_amount_grenades[][] =
{
	{1, 1, 1},
	{1, 0, 2},
	{1, 2, 0},
	{2, 1, 1},
	{0, 2, 2},
	{1, 1, 1},
	{1, 0, 2},
	{1, 1, 1},
	{2, 1, 2}
};

new const Float:g_weapon_dmg[] = 
{
	-1.0,	// ---
	4.1,	// P228
	-1.0,	// ---
	1.0,	// SCOUT
	-1.0,	// ---
	4.0,	// XM1014
	-1.0,	// ---
	1.0,	// MAC10
	3.6,	// AUG_1
	-1.0,	// ---
	2.89,	// ELITE
	8.834,	// FIVESEVEN
	2.233,	// UMP45
	1.0,	// SG550
	3.5,	// GALIL
	3.2,	// FAMAS
	1.0,	// USP
	3.37,	// GLOCK18
	5.5,	// AWP
	2.810,	// MP5NAVY
	3.5,	// M249
	1.0,	// M3
	3.9,	// M4A1_1
	1.0,	// TMP
	13.4,	// G3SG1
	-1.0,	// ---
	8.2,	// DEAGLE
	3.7,	// SG552_1
	3.8,	// AK47
	-1.0,	// ---
	1.0,	// P90
	4.3,	// M4A1_2
	4.5,	// AUG_2
	4.7		// SG552_2
}
enum
{
	PRIMARY_WEAPON = 0,
	SECONDARY_WEAPON,
	
	FINAL_WEAPON
}
enum
{
	UMP45 = 13,
	NAVY,
	FAMAS,
	GALIL,
	AUG_1,
	SG552_1,
	AWP,
	G3SG1,
	M249,
	AK47,
	COLT_1,
	XM1014,
	COLT_2,
	AUG_2,
	SG552_2, // 27
	GLOCK = 6,
	DUAL,
	P228,
	FIVESEVEN,
	DEAGLE, // 10
	
	MAX_WEAPONS = SG552_2+1
}
new const WEAPONNAMES[][] = { "", "P228 Compact", "", "Schmidt Scout", "", "XM1014 M4", "", "Ingram MAC-10", "Steyr AUG A1", "", "Dual Elite Berettas", "FiveseveN",
"UMP 45", "SG-550 Auto-Sniper", "IMI Galil", "Famas", "USP .45 ACP Tactical", "Glock 18C", "AWP Magnum Sniper", "MP5 Navy", "M249 Para Machinegun", "M3 Super 90",
"M4A1 Carbine", "Schmidt TMP", "G3SG1 Auto-Sniper", "", "Desert Eagle .50 AE", "SG-552 Commando", "AK-47 Kalashnikov", "", "ES P90",

"", "Sphinx AT 380", "", "Schmidt Scout", "", "Tromix Saiga S12K", "", "Ingram MAC-10", "AUG A3 Camos", "", "Teh Snake's", "Internetial PX",
"HK UMP-45 SD", "SG-550 Auto-Sniper", "PINDAD SS1 R-5", "Enfield L85-A2", "USP .45 ACP Tactical", "Pock E33", "CheyTac M200", "MP5 Talken", "Stalker M60", "M3 Super 90",
"Heckler & Koch 416", "Schmidt TMP", "VSS Vintorez", "", "Flame Eagle .50", "HK G36K", "Corvalho's SR-3M", "", "ES P90",
"G36C SOPMOD"/*61 COLT*/, "OC-14 Groza"/*62 AUG*/, "LR300 S.T.A.L.K.E.R" /*63 COMMANDO*/ };
new g_weapon[33][FINAL_WEAPON][MAX_WEAPONS]
new g_weapons_edit[33][FINAL_WEAPON]
new g_primary_weapon[33]
new const g_weapon_v_models[][] = {
	"models/zp_tcs/v_ump45.mdl",
	"models/zp_tcs/v_mp5.mdl",
	"models/zp_tcs/v_famas_f.mdl",
	"models/zp_tcs/v_galil_f.mdl",
	"models/zp_tcs/v_aug_1.mdl",
	"models/zp_tcs/v_sg552_1.mdl",
	"models/zp_tcs/v_awp.mdl",
	"models/zp_tcs/v_g3sg1.mdl",
	"models/zp_tcs/v_m249.mdl",
	"models/zp_tcs/v_ak47.mdl",
	"models/zp_tcs/v_m4a1_1p.mdl",
	"models/zp_tcs/v_xm1014_ff.mdl",
	"models/zp_tcs/v_m4a1_2xc.mdl",
	"models/zp_tcs/v_aug_2.mdl",
	"models/zp_tcs/v_sg552_2.mdl",
	"models/zp_tcs/v_glock18.mdl",
	"models/zp_tcs/v_elite.mdl",
	"models/zp_tcs/v_p228.mdl",
	"models/zp_tcs/v_deagle.mdl",
	"models/zp_tcs/v_fiveseven.mdl"
}

/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ INTERFAZ ]
=======================================================================================*/
enum
{
	COLOR_NVG = 0,
	COLOR_HUD,
	COLOR_LIGHT,
	COLOR_BUBBLE,
	COLOR_HUD_COMBO,
	
	MAX_OPTIONS
}
enum
{
	WHITE = 0,
	RED,
	GREEN,
	BLUE,
	YELLOW,
	LTBLUE,
	ORANGE,
	VIOLET,
	
	MAX_COLORS
}
enum
{
	COLOR_RED = 0,
	COLOR_GREEN,
	COLOR_BLUE,
	
	RGB
}
new const COLORS_NAME[MAX_OPTIONS][MAX_COLORS][] =
{
	{ // NVG
		"Blanca",
		"Roja",
		"Verde",
		"Azul",
		"Amarilla",
		"Violeta",
		"Celeste",
		"Naranja"
	},
	{ // HUD
		"Blanco",
		"Rojo",
		"Verde",
		"Azul",
		"Amarillo",
		"Violeta",
		"Celeste",
		"Naranja"
	},
	{ // GRANADA LUZ
		"Blanca",
		"Roja",
		"Verde",
		"Azul",
		"Amarilla",
		"Violeta",
		"Celeste",
		"Naranja"
	},
	{ // GRANADA BUBBLE
		"Blanca",
		"Roja",
		"Verde",
		"Azul",
		"Amarilla",
		"Violeta",
		"Celeste",
		"Naranja"
	},
	{ // HUD COMBO
		"Blanco",
		"Rojo",
		"Verde",
		"Azul",
		"Amarillo",
		"Violeta",
		"Celeste",
		"Naranja"
	}
}
new const TABLET_COLORS[MAX_COLORS][RGB] =
{
	{255, 255, 255}, // BLANCO
	{255, 0, 0}, // ROJO
	{0, 255, 0}, // VERDE
	{0, 0, 255}, // AZUL
	{255, 255, 0}, // AMARILLO
	{255, 0, 255}, // VIOLETA
	{0, 255, 255}, // CELESTE
	{255, 165, 0} // NARANJA
}
new g_color[33][MAX_OPTIONS][3]
new Float:g_hud_pos[33][3]
new Float:g_hud_combo_pos[33][3]
new g_hud_combo_dmg_total[33]
new g_hud_eff[33]
new g_hud_min[33]
new g_hud_abv[33]
new g_hud_off[33]


/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ HABILIDADES ]
=======================================================================================*/
enum
{
	HUMAN_HP = 0,
	HUMAN_SPEED,
	HUMAN_GRAVITY,
	HUMAN_DAMAGE,
	HUMAN_ARMOR,
	HUMAN_AURA,
	HUMAN_TCOMBO,
	
	MAX_HUMAN_HABILITIES
}
enum
{
	ZOMBIE_HP = 0,
	ZOMBIE_SPEED,
	ZOMBIE_GRAVITY,
	ZOMBIE_DAMAGE,
	ZOMBIE_FROZEN,
	ZOMBIE_FIRE,
	
	MAX_ZOMBIE_HABILITIES
}
enum
{
	SURV_HP = 0,
	SURV_DMG,
	SURV_SPEED_WEAPON,
	SURV_EXTRA_BOMB,
	SURV_EXTRA_IMMUNITY,
	
	MAX_SURV_HABILITIES
}
enum
{
	NEM_HP = 0,
	NEM_DMG,
	NEM_BAZOOKA_FOLLOW,
	NEM_BAZOOKA_RADIUS,
	
	MAX_NEM_HABILITIES
}
enum
{
	OTHER_COMBO_WESKER = 0,
	OTHER_CINCO_BALAS,
	OTHER_ULTRA_LASER,
	
	MAX_OTHER_HABILITIES
}
enum
{
	HAB_HUMAN = 0,
	HAB_ZOMBIE,
	HAB_SURV,
	HAB_NEM,
	HAB_OTHER,
	
	MAX_HAB
}

new const MAX_HAB_LEVEL[MAX_HAB][MAX_HUMAN_HABILITIES] = // MAXIMOS NIVELES PARA LAS HABILIDADES
{
	{ // HUMANO
		50, // HP
		15, // SPEED
		15, // GRAV
		30, // DMG
		20, // ARMOR
		10, // AURA
		1
	},
	{ // ZOMBIE
		50, // HP
		15, // SPEED
		10, // GRAV
		10, // DMG
		3,	// FROZEN
		3,	// FIRE
	},
	{ // SURVIVOR
		5, // HP
		5, // DMG
		5, // SPEED WEAPON
		1, // EXTRA BOMB
		1 // EXTRA IMMUNITY
	},
	{ // NEMESIS
		5, // HP
		5, // DMG
		1, // BAZOOKA FOLLOW
		1 // BAZOOKA RADIUS
	},
	{ // OTRO
		1, // COMBO WESKER
		1, // 10 BALAS
		1 // ULTRA LASER
	}
}
new const MAX_HAB_PERCENT[MAX_HAB][MAX_HUMAN_HABILITIES] = // EL PORCENTAJE MAXIMO DE CADA HABILIDAD
{
	{ // HUMANO
		500, 	// HP
		30, 	// SPEED
		50, 	// GRAV
		300, 	// DMG
		200, 	// ARMOR
		10, 	// AURA
		100		// TCOMBO
	},
	{ // ZOMBIE
		500, 	// HP
		22,   	// SPEED
		45,	  	// GRAV
		30,   	// DMG
		99,		// FROZEN
		99		// FIRE
	},
	{ // SURVIVOR
		500, // HP
		100, // DMG
		100, // SPEED WEAPON
		100, // EXTRA BOMB
		100 // EXTRA IMMUNITY
	},
	{ // NEMESIS
		500, // HP
		100, // DMG
		100, // BAZOOKA FOLLOW
		100 // BAZOOKA RADIUS
	},
	{ // OTRO
		100, // COMBO WESKER
		125, // 10 BALAS
		100 // ULTRA LASER
	}
}

new g_points[33][MAX_HAB]
new g_hab[33][MAX_HAB][MAX_HUMAN_HABILITIES];
new g_points_lose[33][MAX_HAB]

new MAX_HABILITIES[MAX_HAB]
new const LANG_HAB[MAX_HAB][] = {"HUMANO", "ZOMBIE", "SURVIVOR", "NEMESIS", "OTROS"}
new const LANG_HAB_M[MAX_HAB][] = {"Humanos", "Zombies", "Survivor", "Nemesis", "Otro"}

new Array:A_HAB_MAX_LEVEL[MAX_HAB]
new Array:A_HAB_NAMES[MAX_HAB]
new Array:A_HAB_MAX_PERCENT[MAX_HAB]

new const LANG_HAB_DESCRIPTION[MAX_HAB][MAX_HUMAN_HABILITIES][] =
{
	{ // HUMANO
		"Vida",
		"Velocidad",
		"Gravedad",
		"Daño",
		"Chaleco",
		"Radio de luz",
		"" // TCombo
	},
	{ // ZOMBIE
		"Vida",
		"Velocidad",
		"Gravedad",
		"Daño",
		"Resistencia al frío:",
		"Resistencia al fuego:",
		""
	},
	{ // SURVIVOR
		"Vida",
		"Daño",
		"Velocidad de disparo:",
		"Bomba extra:",
		"Inmunidad mejorada (10 seg.):",
		"",
		""
	},
	{ // NEMESIS
		"Vida",
		"Daño",
		"Modo de Bazooka (seguimiento):",
		"Bazooka - Mayor radio de explosión:",
		"",
		"",
		""
	},
	{ // OTRO
		"Habilitar combo wesker:",
		"Aumentar 10 balas:",
		"Ultra LASER:^n\r- \wMejora tus LASER del wesker para que atraviesen a los zombies",
		"",
		"",
		"",
		""
	}
}
new const LANG_HAB_CLASS[MAX_HAB][MAX_HUMAN_HABILITIES][] =
{
	{ // HUMANO
		"VIDA",
		"VELOCIDAD",
		"GRAVEDAD",
		"DAÑO",
		"CHALECO",
		"AURA BOMBA DE LUZ",
		"DESBLOQUEAR TCOMBO"
	},
	{ // ZOMBIE
		"VIDA",
		"VELOCIDAD",
		"GRAVEDAD",
		"DAÑO",
		"RESISTENCIA AL FRÍO",
		"RESISTENCIA AL FUEGO",
		""
	},
	{ // SURVIVOR
		"VIDA",
		"DAÑO",
		"VELOCIDAD DE DISPARO",
		"BOMBA EXTRA",
		"INMUNIDAD MEJORADA (10 SEG.)",
		"",
		""
	},
	{ // NEMESIS
		"VIDA",
		"DAÑO",
		"MODO DE BAZOOKA (SEGUIMIENTO)",
		"BAZOOKA: MAYOR RADIO DE EXPLOSIÓN",
		"",
		"",
		""
	},
	{ // OTRO
		"HABILITAR COMBO WESKER",
		"AUMENTAR 10 BALAS",
		"ULTRA LASER",
		"",
		"",
		"",
		""
	}
}

get_cost_money(id, class, hab)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return -1;
	
	new cost;
	new hab_item = g_hab[id][class][hab] + 1;
	
	switch(class)
	{
		case HAB_SURV:
		{
			switch(hab)
			{
				case SURV_HP: cost = hab_item * 5;
				case SURV_DMG: cost = hab_item * 15;
				case SURV_SPEED_WEAPON: cost = hab_item * 15;
				case SURV_EXTRA_BOMB: cost = 75;
				case SURV_EXTRA_IMMUNITY: cost = 50;
			}
		}
		case HAB_NEM:
		{
			switch(hab)
			{
				case NEM_HP: cost = hab_item * 5;
				case NEM_DMG: cost = hab_item * 5;
				case NEM_BAZOOKA_FOLLOW: cost = 75;
				case NEM_BAZOOKA_RADIUS: cost = 100;
			}
		}
		case HAB_OTHER:
		{
			switch(hab)
			{
				case OTHER_COMBO_WESKER: cost = 50;
				case OTHER_CINCO_BALAS: cost = 99;
				case OTHER_ULTRA_LASER: cost = 50;
			}
		}
	}
	
	return cost;
}
get_percent_upgrade(id, class, hab)
{
	if(class == HAB_HUMAN || class == HAB_ZOMBIE)
		return ((g_hab[id][class][hab] + MAX_EFFECTS_HATS_HABS[g_hat_equip[id]+1][class][hab]) * ArrayGetCell(A_HAB_MAX_PERCENT[class], hab)) / ArrayGetCell(A_HAB_MAX_LEVEL[class], hab);

	return (g_hab[id][class][hab] * ArrayGetCell(A_HAB_MAX_PERCENT[class], hab)) / ArrayGetCell(A_HAB_MAX_LEVEL[class], hab);
}

Float:amount_upgrade_f(id, class, hab, Float:base, no_float, for_menu)
{
	new Float:fpercent
	new Float:ffpercent
	new Float:fffpercent
	
	fpercent = float(get_percent_upgrade(id, class, hab))
	ffpercent = ((base * 800.0) * fpercent) / 800.0
	
	if(hab == HUMAN_SPEED || hab == ZOMBIE_SPEED) fffpercent = (base * fpercent) / 100
	else if(hab == HUMAN_DAMAGE || hab == ZOMBIE_DAMAGE) fffpercent = (base * fpercent) / 7
	else fffpercent = (base * fpercent)
	
	if(!for_menu)
	{
		new Float:fsum
		new Float:rest
		
		if(no_float) rest = (base * 800.0) - ffpercent
		else if(hab == HUMAN_GRAVITY || hab == ZOMBIE_GRAVITY) rest = ((base * 800.0) - ffpercent) / 800.0
		else fsum = base + fffpercent
		
		return (no_float || ((hab == HUMAN_GRAVITY || hab == ZOMBIE_GRAVITY) && !no_float)) ? rest : fsum;
	}
	else return (hab == HUMAN_GRAVITY || hab == ZOMBIE_GRAVITY) ? ffpercent : fffpercent;
	
	return -1.0;
}
amount_upgrade(id, class, hab, base, for_menu)
{
	new percent
	new sum_pre
	new sum_post
	
	percent = get_percent_upgrade(id, class, hab)
	sum_pre = (base * percent) / 100
	
	if(!for_menu)
	{
		if(class == HAB_HUMAN && hab == HUMAN_ARMOR) sum_post = percent
		else sum_post = base + sum_pre
	}
	else sum_post = percent
	
	return sum_post;
}

#define next_point(%1)	(%1+1) * 6
#define cost_tcombo	50


/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ LOGROS ]
=======================================================================================*/
enum
{
	LOGRO_HUMAN = 0,
	LOGRO_ZOMBIE,
	LOGRO_SURV,
	LOGRO_NEM,
	LOGRO_OTHERS,
	LOGRO_EV_NAVIDAD,
	LOGRO_EV_HEAD_ZOMBIES,
	LOGRO_ANNIHILATOR,
	LOGRO_WESKER,
	LOGRO_EV_AMOR,
	LOGRO_SNIPER,
	LOGRO_SECRET,
	LOGRO_LEGENDARIO,
	
	MAX_CLASS
}
enum
{
	LOS_150_NEM = 0,
	EXTERMINADOR,
	CABECILLA,
	AFILANDO_CUCHILLOS,
	ESTOY_QUE_ARDO,
	A_DONDE_VAS,
	ME_HAGO_EL_JASON,
	SE_UN_LIDER,
	YO_TE_ANIQUILO,
	LIDER_EN_CABEZAS,
	BAN_LOCAL,
	LOS_50000,
	LOS_100000_Z,
	LOS_500000,
	LOS_1000000,
	COMBO_500,
	COMBO_1000,
	COMBO_2500,
	COMBO_5000,
	COMBO_10000,
	COMBO_15000,
	COMBO_20000,
	COMBO_30000,
	DMG_100K,
	DMG_500K,
	DMG_1KK,
	DMG_5KK,
	DMG_20KK,
}
enum
{
	DMG_50KK = 28,
	DMG_100KK,
	TCOMBO,
	ROMPIENDO_HEADS
}

const DMG_500KK_KK = 32;
const DMG_1000KK_KK = 33;
const DMG_FINAL = 34;
const PIPE_18 = 35;
const FACA_ROJA = 36;
const NINJA = 37;
const IMPARABLE = 38;
const THIS_IS_SPARTA = 39;
const DE_OTRO_MUNDO = 40;

const MAX_HUMANS_LOGROS = 41;

enum 
{
	VIRUS = 0,
	NO_SURVIVORS,
	NO_NEED_NONE,
	YO_NO_FUI,
	YO_NO_INFECTO,
	ME_DICEN_EL_ROJITO,
	LOS_5000,
	LOS_10000,
	LOS_30000,
	LOS_100000_H,
	BOMBA_FALLIDA,
	ME_ENCANTA_ESE_SOUND,
	LIMPIEZA,
	CLEAR_ZOMBIE,
	NO_WESKER,
	NO_PRED,
	NO_SNIPER,
	
	MAX_ZOMBIES_LOGROS
}
enum 
{
	SURV_AL_LIMITE = 0,
	LA_VICTORIA_ESTA_CERCA,
	EXPERTO_EN_BOMBAS,
	
	MAX_SURVIVOR_LOGROS
}
enum 
{
	SOY_NEMESIS = 0,
	BAZOOKASO,
	NEMERAP,
	
	MAX_NEMESIS_LOGROS
}
enum 
{
	WIN_ARMAGEDDON = 0,
	ENTRENANDO,
	V_FOR_VENDETTA,
	LA_PRIMERA_VEZ,
	COLECCIONISTA,
	ALHAJA,
	ANILLOS,
	COLLARES,
	SOY_DORADO,
	SOY_RE_CABEZA,
	SOY_MUY_VICIADO,
	YA_VOY_POR_LA_MITAD,
	ESTOY_MUY_SOLO,
	FOREVER_ALONE,
	GRAN_EQUIPO,
	MI_PODER_ES_INMENSO,
	
	MAX_OTHERS_LOGROS
}
enum 
{
	CAJA_ROJA = 0,
	CAJA_AZUL,
	CAJA_VERDE,
	CAJA_AMARILLA,
	CAJA_ROJA_50,
	CAJA_AZUL_50,
	CAJA_VERDE_50,
	CAJA_AMARILLA_25,
	COMPRAR_GORRO,
	CONSEGUIR_GORRO,
	
	MAX_EV_NAVIDAD_LOGROS
}
enum 
{
	HEADZ_R_25 = 0,
	HEADZ_B_25,
	HEADZ_G_25,
	HEADZ_Y_25,
	MULTICOLOR,
	
	MAX_EV_HEADZ_LOGROS
}
enum 
{
	BALAS_130 = 0,
	MISIL_5,
	BAZOOKA_80,
	MAC_100,
	KILL_400,
	INTACTO,
	
	MAX_ANNIHILATOR_LOGROS
}
enum 
{
	MIS_3_LASER = 0,
	ULTRA_LASER,
	ULTRA_LASER_5,
	NO_ME_TOQUES,
	A_MI_CABEZA_NO,
	COMBO_WESKER_10000,
	FACA_5,
	
	MAX_WESKER_LOGROS
}
enum 
{
	SON_AMORES = 0,
	AMORES_100,
	AMORES_500,
	AMOR_ADMIN,
	AMOR_STAFF,
	GOLOSINAS,
	GOLOSINAS_BOOM,
	GOLOSINA_ZOMBIE,
	AMOR_ODIO,
	SOY_AMADO_10,
	SOY_AMADO_50,
	
	MAX_EV_AMOR_LOGROS
}
enum
{
	YO_Y_MI_AWP = 0,
	BALA_4,
	SUPER_SPEED_30,
	SUPER_SPEED_WTF,
	YO_MI_AWP_Y_MI_PODER,
	
	MAX_SNIPER_LOGROS
}
enum
{
	TERRORISTA_1, 			// Mata 150 zombies con AK-47
	BALAS_1500, 			// Dispara 1500 balas sin morir y sin convertirte en zombie en una misma ronda, 500 balas tienen que haber sacado daño a los zombies
	RAPIDO_Y_FURIOSO, 		// Infecta a 5 humanos y utiliza 3 furias zombies en una misma ronda
	MI_MAMA_DISPARO,		// Hacerle mas daño al nemesis y sumar mas de 150k de daño
	CORTAMAMBO,				// Hacer que un combo dure 5 minutos sin cortarse
	CHUCK_NORRIS,			// Matar al aniquilador con cuchillo.
	T_VIRUS,				// Infectar a 24 en una sola ronda
	HITMAN,					// Realiza 500.000 headshots
	SURVIVOR_DEF,			// Fullear todas las habilidades del survivor
	MAS_ZOMBIES,			// Mata a 35 zombies en una ronda
	LETS_ROCK,				// Gana el modo survivor en 1 minuto o menos
	NICE_COMBO,				// Realiza un combo de 5000 exacto, ni mas ni menos.
	SALVADOR,				// Muere con una bomba de desinfección en tu poder
	MAXIMO_COMPRADOR,		// Compra todos los objetos disponibles tanto para zombie como para humano, en una sola ronda.
	JUGADOR_COMPULSIVO,		// Apuesta a la lotería mas de 75k de XP
	
	MILLONARIO,				// Consigue 10m de XP
	EL_TERROR_EXISTE,		// Matar a un total de 1000 humanos siendo nemesis.
	RESISTENCIA,			// Matar a un total de 1000 zombies siendo survivor.
	ALBERT_WESKER,			// Matar a 1000 zombies siendo wesker.
	ASESINO_DE_TURNO,		// Matar a 8 humanos en modo swarm
	APLASTA_ZOMBIES,		// Mata a 7 zombies en modo swarm
	ZANGANO_REAL,			// Matar a 10 humanos siendo alien en una ronda.
	DEPREDADOR_FINAL,		// Mata a 8 zombies siendo depredador en una ronda.
	DEPREDALIEN,			// Completa los logros secretos ZANGANO_REAL y DEPREDADOR_FINAL
	SUPER_AGENTE,			// Completa 90 logros
	
	MAX_SECRET_LOGROS
}

#define TOTAL_LOGROS 	MAX_HUMANS_LOGROS

new g_money[33]
new g_money_lose[33];
new g_logro[33][MAX_CLASS][TOTAL_LOGROS]
new gl_infects_round[33]
new gl_infects_no_dmg[33]
new gl_fz_in_round[33]
new gl_kill_head[33]
new g_leader_logros_name[32]
new g_leader_logros_count
new gl_kill_bazooka[33]
new gl_kill_mac10[33]
new gl_tantime[33];
new gl_wesker_health;
new gl_kill_knife[33];
new gl_kill_sniper;
new gl_time_nem;
new gl_bullets[33];
new gl_bullets_ok[33];
new gl_all_items[33][MAX_ITEMS_EXTRAS];
new gl_dmg_nem[33];
new gl_dmg_nem_ord[33];
new gl_kill_ak[33];
new gl_kill_h_nem[33];
new gl_kill_z_surv[33];
new gl_kill_z_wes[33];
new gl_kill_h_swarm[33];
new gl_kill_z_swarm[33];
new gl_kill_h_avd[33];
new gl_kill_z_avd[33];
new Float:gl_progress[33][7];
new gl_infect_users[33][33];
new Float:g_time_cortamambo[33];

new MAX_LOGROS_CLASS[MAX_CLASS]

new const LANG_CLASS_LOGROS[MAX_CLASS][] = { "HUMANO", "ZOMBIE", "SURVIVOR", "NEMESIS", "OTROS", "EVENTO: NAVIDAD", "CABEZAS DE ZOMBIE", "ANIQUILADOR", "WESKER", "EVENTO: AMOR EN EL AIRE", "SNIPER", "SECRETOS", "LEGENDARIOS" }
new const LANG_CLASS_LOGROS_MIN[MAX_CLASS][] = { "humanos", "zombies", "survivor", "nemesis", "otros", "navideños", "de cabezas zombie", "de aniquilador", "wesker", "amorosos", "sniper", "secretos", "legendarios" }
new const LANG_LOGROS_NAMES[MAX_CLASS][TOTAL_LOGROS][] =
{
	{ // HUMANO
		"LOS 150 NEMESIS",
		"EL EXTERMINADOR",
		"SOY EL CABECILLA",
		"AFILANDO CUCHILLOS",
		"ESTOY QUE ARDO",
		"¿ A DÓNDE VAS ?",
		"ME HAGO EL JASON",
		"SE UN LÍDER",
		"YO TE ANIQUILO",
		"LÍDER EN CABEZAS",
		"BAN LOCAL",
		"LOS 50.000 ZOMBIES",
		"LOS 100.000 ZOMBIES",
		"LOS 500.000 ZOMBIES",
		"MILLÓN DE ZOMBIES",
		"COMBO 500",
		"COMBO 1.000",
		"COMBO 2.500",
		"COMBO 5.000",
		"COMBO 10.000",
		"COMBO 15.000",
		"COMBO 20.000",
		"COMBO 30.000",
		"MIRA MI DAÑO",
		"MÁS Y MÁS DAÑO",
		"LLEGUÉ AL MILLÓN",
		"MI DAÑO CRECE Y CRECE",
		"VAMOS POR LOS 50 MILLONES",
		"CONTADOR DE DAÑOS",
		"YA PERDÍ LA CUENTA",
		"MI COMBO ES TARINGUERO",
		"ROMPIENDO CABEZAS",
		"MI DAÑO ES CATASTRÓFICO",
		"MI DAÑO ES NUCLEAR",
		"MI DAÑO LLEGÓ AL MÁXIMO",
		"PI... PI... PI.. PI.. PI BOOOOM!",
		"MI CUCHILLO ES ROJO",
		"NINJA",
		"IMPARABLE",
		"THIS, IS.. SPAARTAAAAAAAAAA !!",
		"DE OTRO MUNDO"
	},
	{ // ZOMBIE
		"VIRUS",
		"NO HAY SOBREVIVIENTES",
		"NO NECESITO A NADIE",
		"YO NO FUÍ",
		"YO NO INFECTO ... YO MATO",
		"ME DICEN EL ROJITO",
		"LOS 5.000 HUMANOS",
		"LOS 10.000 HUMANOS",
		"LOS 30.000 HUMANOS",
		"LOS 100.000 HUMANOS",
		"BOMBA FALLIDA",
		"ME ENCANTA ESE SONIDO",
		"Y LA LIMPIEZA ?",
		"YO USO CLEAR ZOMBIE",
		"TU PISTOLA NO SIRVE",
		"NI CELESTE, NI VERDE, ¡AMARILLO!",
		"¿ A ESO LE LLAMAS FRANCOTIRADOR ?", 
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // SURVIVOR
		"SOBREVIVIENTE AL LÍMITE",
		"LA VICTORIA ESTÁ CERCA (AJAM)",
		"EXPERTO EN BOMBAS",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // NEMESIS
		"YO SOY NEMESIS",
		"BAZOOKAASOOOO",
		"NEMERAP",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // OTROS
		"LA VICTORIA ES NUESTRA",
		"ENTRENANDO",
		"V FOR VENDETTA",
		"LA PRIMERA VEZ",
		"COLECCIONISTA",
		"COMPRA UNA ALHAJA",
		"EL SEÑOR DE LOS ANILLOS",
		"JOYERO",
		"SOY DORADO",
		"SOY RE CABEZA",
		"SOY MUY VICIADO",
		"YA ESTOY POR LA MITAD",
		"ESTOY MUY SOLO",
		"FOREVER ALONE",
		"EL GRAN EQUIPO",
		"NUESTRO PODER ES INMENSO",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // EVENTO: NAVIDAD
		"REGALO ROJO",
		"REGALO AZÚL",
		"REGALO VERDE",
		"REGALO AMARILLO",
		"100 REGALOS ROJOS",
		"100 REGALOS AZULES",
		"100 REGALOS VERDES",
		"100 REGALOS AMARILLOS",
		"GORRO NAVIDEÑO",
		"¿ OTRO GORRO NAVIDEÑO ?",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // CABEZAS DE ZOMBIE
		"25 CABEZAS ROJAS",
		"25 CABEZAS AZULES",
		"25 CABEZAS VERDES",
		"25 CABEZAS AMARILLAS",
		"MULTICOLOR",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // ANIQUILADOR
		"MI MAC-10 ESTÁ LLENA",
		"5 MISILES",
		"80 EXPLOSIONES",
		"TRAGUEN PLOMO",
		"MUCHA CARNE",
		"INTACTO",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // WESKER
		"MIS 3 LASER",
		"¿ WESKER AMARILLO ?",
		"ULTRA LASER",
		"¡ NO ME TOQUEN !",
		"PULVERIZAR",
		"COMBO 10.000",
		"WHISKAS",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // EVENTO: AMOR EN EL AIRE
		"SON AMOOREEEES",
		"AMO A MUCHAS PERSONAS",
		"AMO A TODOS",
		"AMOR ADMINISTRATIVO",
		"¿ AMOR MÁS ADMINISTRATIVO ?",
		"SOY GOLOSO",
		"¡ COMÍ MUCHO !",
		"GOLOSINA ZOMBIE",
		"TE AMO... SOLO PARA ODIARTE",
		"ALGUIEN ME AMA",
		"SOY MUY AMADO",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // SNIPER
		"YO Y MI AWP",
		"MI DISPARO VALE x3",
		"YO APROVECHO MI PODER",
		"SPEED AND RUN",
		"YO, MI AWP Y MI PODER",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // SECRETOS
		"TERRORISTA Nº 1",
		"AL INFINITO",
		"RÁPIDO Y FURIOSO",
		"MI MAMÁ ME DIJO QUE TE DISPARE",
		"CORTAMAMBO",
		"CHUCK NORRIS",
		"VIRUS-T",
		"HITMAN",
		"SOBREVIVIENTE DEFINITIVO",
		"MÁS ZOMBIES", 
		"LET'S ROCK",
		"EL COMBO PERFECTO", 
		"EL SALVADOR NO SALVADO",
		"MÁXIMO COMPRADOR",
		"JUGADOR COMPULSIVO",
		"MILLONARIO",
		"EL TERROR EXISTE",
		"RESISTENCIA",
		"ALBERT WESKER",
		"ASESINO DE TURNO",
		"APLASTA ZOMBIES",
		"ZÁNGANO REAL",
		"DEPREDADOR FINAL",
		"DEPREDALIEN",
		"SÚPER AGENTE",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // LEGENDARIOS
		"PRIMERO DEL SV: Rik'Thal",
		"PRIMERO DEL SV: Rik'Thal COMPLETA",
		"Rik'Thal",
		"Rik'Thal: NIVEL 5",
		"Rik'Thal: NIVEL 10",
		"Rik'Thal: NIVEL 15",
		"Rik'Thal: NIVEL VEX 1",
		"Rik'Thal: NIVEL VEX 3",
		"Rik'Thal: COMPLETA",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	}
}
enum
{
	PRIMERO_DEL_SV_RT = 0,
	PRIMERO_DEL_SV_RT_COMPLETA,
	RIK_THAL,
	RIK_THAL_LV_5,
	RIK_THAL_LV_10,
	RIK_THAL_LV_15,
	RIK_THAL_LV_VEX_1,
	RIK_THAL_LV_VEX_3,
	RIK_THAL_COMPLETA,
	
	MAX_LOGRO_LEGENDARIO
}
new const LANG_LOGROS_DESCRIPTION[MAX_CLASS][TOTAL_LOGROS][] =
{
	{ // HUMANO
		"Mata a 150 nemesis",
		"Mata a 5 aniquiladores",
		"Realiza 10.000 disparos en la cabeza",
		"Mata a un zombie con cuchillo",
		"Quema a 15 o más zombies con una granada de fuego o granada",
		"Congela a 15 o más zombies con una granada de hielo",
		"Aniquila a 5 zombies con una motosierra", // COMPLETAR
		"Conviertete en el líder de combo máximo",
		"Aniquila a un aniquilador con una motosierra", // COMPLETAR
		"Mata a 500 zombies con disparos en la cabeza",
		"Mata a un miembro del Staff de T! CS con cuchillo",
		"Mata a 50.000 zombies",
		"Mata a 100.000 zombies",
		"Mata a 500.000 zombies",
		"Mata a 1.000.000 de zombies",
		"Realiza un Combo de 500 XP",
		"Realiza un Combo de 1.000 XP",
		"Realiza un Combo de 2.500 XP",
		"Realiza un Combo de 5.000 XP",
		"Realiza un Combo de 10.000 XP",
		"Realiza un Combo de 15.000 XP",
		"Realiza un Combo de 20.000 XP",
		"Realiza un Combo de 30.000 XP",
		"Realiza 100.000 de daño",
		"Realiza 500.000 de daño",
		"Realiza 1.000.000 de daño",
		"Realiza 5.000.000 de daño",
		"Realiza 20.000.000 de daño",
		"Realiza 50.000.000 de daño",
		"Realiza 100.000.000 de daño",
		"Desbloquea el TCombo",
		"Mata a 10 zombies con disparos en la cabeza en una ronda",
		"Realiza 500.000.000 de daño",
		"Realiza un millardo de daño^n\yMillardo: 1.000.000.000",
		"Realiza el máximo daño posible (\y2.147.483.647\w)",
		"Lanza una Bomba Reloj y consigue atraer a 18 o más zombies",
		"Mata a un nemesis con cuchillo",
		"Mata a 25 zombies con cuchillo",
		"Mata a 100 zombies con cuchillo",
		"Mata a 300 zombies con cuchillo",
		"Mata a 25 aliens"
	},
	{ // ZOMBIE
		"Infecta a 20 personas en una misma ronda (sin bomba)^n\rNOTA:\w Logro activo solo cuando hay más de 20 jugadores^n\rNOTA 2:\wCada jugador cuenta 1 infección sola",
		"Mata a 150 survivors",
		"Infecta a todos los jugadores en una misma ronda (sin bomba)^n\rNOTA:\w Logro activo solo cuando hay 24 jugadores", // COMPLETAR
		"Infecta 5 humanos seguidos sin recibir daño (sin bomba)",
		"Mata a 500 humanos",
		"Compra 3 furia zombie en una misma ronda",
		"Infecta a 5.000 humanos",
		"Infecta a 10.000 humanos",
		"Infecta a 30.000 humanos",
		"Infecta a 100.000 humanos",
		"Lanzar una bomba de infección y no infectar a nadie",
		"Infecta a 15 humanos con una bomba de infección y^nescucha sus gritos",
		"Lanzar una bomba antidoto y no desinfectar a nadie", 
		"Desinfecta a 18 o más zombies con una bomba antidoto",
		"Mata a 25 weskers",
		"Mata a 25 depredadores",
		"Mata a 25 snipers",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // SURVIVOR
		"Gana la ronda survivor sin usar la bomba ni la inmunidad^n\rNOTA:\w Logro activo solo cuando hay más de 20 jugadores",
		"Se el último sobreviviente en modo armageddon contra todos^n\rNOTA:\w Logro activo solo cuando hay más de 20 jugadores",
		"Mata a 20 zombies con la bomba de aniquilación",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // NEMESIS
		"Gana la ronda nemesis sin usar bazooka^n\rNOTA:\w Logro activo solo cuando hay más de 20 jugadores",
		"Mata a 20 humanos con la bazooka",
		"Gana la ronda nemesis en menos de 1 minuto^n\rNOTA:\w Logro activo solo cuando hay más de 20 jugadores",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // OTROS
		"Gana el modo armageddon sin que ningún miembro de tu equipo muera^n\rNOTA:\w Logro activo solo cuando hay más de 20 jugadores",
		"Juega 24 horas",
		"Alcanza el Rango V",
		"Alcanza el Rango Y",
		"Completa 10 logros",
		"Compra cualquier anillo o collar",
		"Compra todos los anillos hasta el Grado S incluido",
		"Compra todos los collares hasta el Grado S incluido",
		"Se un usuario Premium",
		"Consigue 10 o más gorros",
		"Juega todo el TAN, o al menos intentalo",
		"Alcanza el nivel 280",
		"Juega 7 días", 
		"Juega 30 días",
		"Gana el modo tribal sin que tu compañero muera",
		"En el modo tribal, activa el poder y consigue^nque le haga daño a todos los jugadores^n\rNOTA:\w Logro activo solo cuando hay más de 20 jugadores",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // EVENTO: NAVIDAD
		"Consigue un regalo rojo",
		"Consigue un regalo azúl",
		"Consigue un regalo verde",
		"Consigue un regalo amarillo",
		"Consigue 100 regalos rojos",
		"Consigue 100 regalos azules",
		"Consigue 100 regalos verdes",
		"Consigue 100 regalos amarillos",
		"Compra un gorro navideño",
		"Consigue un nuevo gorro navideño abriendo una caja amarilla",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // CABEZAS DE ZOMBIE
		"Consigue 25 cabezas de zombie rojas",
		"Consigue 25 cabezas de zombie azules",
		"Consigue 25 cabezas de zombie verdes",
		"Consigue 25 cabezas de zombie amarillas",
		"Consigue 25 o más cabezas de zombie de cada color",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // ANIQUILADOR
		"Sobrevive el modo sin gastar una bala de tu MAC-10",
		"Sobrevive el modo sin gastar un misil de tu bazooka",
		"Mata a 80 humanos con tus misiles y sobrevive",
		"Mata a 100 humanos con tu MAC-10 y sobrevive",
		"Mata a más de 400 humanos y sobrevive",
		"Sobrevive el modo con 900.000 de vida o más",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // WESKER
		"Gana el modo wesker sin utilizar ningun LASER^n\rNOTA: \wLogro activo solo cuando hay más de 20 jugadores",
		"Desbloquea el ULTRA LASER",
		"Mata a 5 o más zombies con un solo ULTRA LASER^n\rNOTA: \wLogro activo solo cuando hay más de 20 jugadores",
		"Gana el modo wesker sin recibir daño^n\rNOTA: \wLogro activo solo cuando hay más de 20 jugadores",
		"Pulvoriza una cabeza de zombie de cualquier color^ndisparandole un ULTRA LASER",
		"Realiza un combo de 10.000 de XP",
		"Mata a 5 o más zombies con cuchillo",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // EVENTO: AMOR EN EL AIRE
		"Demuestra tu amor a 10 jugadores",
		"Demuestra tu amor a 100 jugadores",
		"Demuestra tu amor a 500 jugadores",
		"Demuestra tu amor a 5 administradores",
		"Demuestra tu amor a un miembro del Staff",
		"Degusta todas las golosinas disponibles",
		"Come golosinas hasta explotar!",
		"Prueba la deliciosa golosina zombie",
		"Ama al jugador líder",
		"Consigue que te amen 10 jugadores",
		"Consigue que te amen 50 jugadores", 
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // SNIPER
		"Gana el modo sniper",
		"Con una sola bala, mata a 3 zombies",
		"Mata a 35 zombies antes de que se acabe tu super velocidad",
		"No mates a nadie mientras tienes super velocidad",
		"Gana el modo sniper sin utilizar tu super velocidad",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // SECRETOS
		"\rLogro Secreto!",
		"\rLogro Secreto! \y- \wRequiere más de 15 jugadores",
		"\rLogro Secreto! \y- \wRequiere más de 15 jugadores",
		"\rLogro Secreto!",
		"\rLogro Secreto!",
		"\rLogro Secreto!",
		"\rLogro Secreto! \y- \wRequiere más de 18 jugadores",
		"\rLogro Secreto!",
		"\rLogro Secreto!",
		"\rLogro Secreto! \y- \wRequiere más de 20 jugadores",
		"\rLogro Secreto!",
		"\rLogro Secreto!",
		"\rLogro Secreto!",
		"\rLogro Secreto!",
		"\rLogro Secreto!",
		"\rLogro Secreto!",
		"\rLogro Secreto!",
		"\rLogro Secreto!",
		"\rLogro Secreto!",
		"\rLogro Secreto!",
		"\rLogro Secreto!",
		"\rLogro Secreto!",
		"\rLogro Secreto!",
		"\rLogro Secreto!",
		"\rLogro Secreto!",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	},
	{ // LEGENDARIOS
		"Se el primero en comprar el arma legendaria: \yRik'Thal",
		"Se el primero en completar el arma \yRik'Thal",
		"Compra el arma legendaria \yRik'Thal",
		"Sube a nivel 5 el arma \yRik'Thal",
		"Sube a nivel 10 el arma \yRik'Thal",
		"Sube a nivel 15 el arma \yRik'Thal",
		"Sube a nivel VEX 1 el arma \yRik'Thal",
		"Sube a nivel VEX 3 el arma \yRik'Thal",
		"Completa el arma \yRik'Thal",
		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
	}
}
new const LOGROS_REWARD_POINTS[MAX_CLASS][TOTAL_LOGROS] = 
{
	{
		15,
		5,
		10,
		2,
		5,
		5,
		15,
		5,
		5,
		10,
		5,
		20,
		30,
		40,
		50,
		2,
		5,
		10,
		15,
		20,
		25,
		30,
		50,
		5,
		10,
		15,
		20,
		30,
		50,
		100,
		5,
		5,
		110,
		120,
		150,
		10,
		20,
		5,
		10,
		20,
		20
	},
	{
		5,
		15,
		10,
		5,
		10,
		10,
		20,
		30,
		40,
		50,
		5,
		10,
		5,
		10,
		20,
		20,
		20,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	},
	{
		10,
		5,
		5,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	},
	{
		10,
		5,
		15,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	},
	{
		5,
		5,
		10,
		5,
		5, 
		10,
		100,
		100,
		10,
		15,
		15,
		10,
		15,
		30,
		5,
		10,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	},
	{
		5,
		5,
		5,
		5,
		10,
		10,
		10,
		10,
		15,
		20,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	},
	{
		5,
		5,
		5,
		5,
		30,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	},
	{
		10,
		10,
		20,
		25,
		40,
		15,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	},
	{
		10,
		5,
		15,
		15,
		5,
		5,
		10,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	},
	{
		5,
		10,
		15,
		5,
		5,
		5,
		5,
		5,
		5, 
		5,
		10,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	},
	{
		5,
		5,
		10,
		10,
		10,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	},
	{
		5,
		5,
		10,
		10,
		20,
		10,
		25,
		5,
		15,
		10,
		15, 
		20,
		5,
		10,
		5,
		10,
		20,
		20,
		20,
		15,
		15,
		15,
		15,
		10,
		30,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	},
	{
		25,
		100,
		10,
		10,
		10,
		10,
		10,
		10,
		25,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	}
}

new const A_LOGROS_REWARD[MAX_SECRET_LOGROS][] =
{
	"    \r- \w$5^n    \r- \w7.500 XP",
	"    \r- \w$5^n    \r- \w2p. H y Z",
	"    \r- \w$10^n    \r- \w1p. Z^n    \r- \w10.000 XP",
	"    \r- \w$10^n    \r- \w1p. H^n    \r- \w1.500 APs",
	"    \r- \w$20^n    \r- \w5p. H^n    \r- \w5.000 XP",
	"    \r- \w$10^n    \r- \w2p. H y Z^n    \r- \w15.000 XP",
	"    \r- \w$25^n    \r- \w5p. Z^n    \r- \w10.000 XP",
	"    \r- \w$5^n    \r- \w5p. H^n    \r- \w25.000 XP",
	"    \r- \w$15^n    \r- \w5p. H^n    \r- \w10.000 XP",
	"    \r- \w$10^n    \r- \w2p. H y Z^n    \r- \w15.000 XP",
	"    \r- \w$15^n    \r- \w10p. H y Z^n    \r- \w25.000 XP",
	"    \r- \w$20^n    \r- \w1p. Z^n    \r- \w1.000 APs",
	"    \r- \w$5^n    \r- \w2p. Z^n    \r- \w10.000 XP",
	"    \r- \w$10^n    \r- \w1p. H y Z^n    \r- \w15.000 XP",
	"    \r- \w$5^n    \r- \w5p. H y Z",
	"    \r- \w$10^n    \r- \w3p. H y Z",
	"    \r- \w$20^n    \r- \w5p. Z^n    \r- \w20.000 XP",
	"    \r- \w$20^n    \r- \w5p. H^n    \r- \w20.000 XP",
	"    \r- \w$20^n    \r- \w5p. H y Z^n    \r- \w20.000 XP",
	"    \r- \w$15^n    \r- \w3p. Z^n    \r- \w15.000 XP",
	"    \r- \w$15^n    \r- \w3p. H^n    \r- \w15.000 XP",
	"    \r- \w$15^n    \r- \w3p. Z^n    \r- \w15.000 XP",
	"    \r- \w$15^n    \r- \w3p. H^n    \r- \w15.000 XP",
	"    \r- \w$10^n    \r- \w5.000 APs",
	"    \r- \w$30^n    \r- \w10p. H y Z^n    \r- \w25.000 XP"
}

new const B_LOGROS_REWARD[MAX_SECRET_LOGROS][4] =
{ // XP , APS , PUNTOS H, PUNTOS Z
	{7500, 0, 0, 0},
	{0, 0, 2, 2},
	{10000, 0, 0, 1},
	{0, 1500, 1, 0},
	{5000, 0, 5, 0},
	{15000, 0, 2, 2},
	{10000, 0, 0, 5},
	{25000, 0, 5, 0},
	{10000, 0, 5, 0},
	{15000, 0, 2, 2},
	{25000, 0, 10, 10},
	{0, 1000, 0, 1},
	{10000, 0, 0, 2},
	{15000, 0, 1, 1},
	{0, 0, 5, 5},
	{0, 0, 3, 3},
	{20000, 0, 0, 5},
	{20000, 0, 5, 0},
	{20000, 0, 5, 5},
	{15000, 0, 0, 3},
	{15000, 0, 3, 0},
	{15000, 0, 0, 3},
	{15000, 0, 3, 0},
	{0, 5000, 0, 0},
	{25000, 0, 10, 10}
}

new Array:A_LOGROS_NAMES[MAX_CLASS];
new Array:A_LOGROS_DESCRIPTION[MAX_CLASS];
new Array:A_LOGROS_POINTS[MAX_CLASS];


/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ OTROS ]
=======================================================================================*/
new const g_sCustomizationFile[] = "zombieplague.ini"

new const g_sSky[] = "space";
new const g_sObjective_Ents[][] =
{
	"func_bomb_target", "info_bomb_target", "info_vip_start", "func_vip_safetyzone", "func_escapezone", "hostage_entity", "monster_scientist", "info_hostage_rescue",
	"func_hostage_rescue", "env_rain", "env_snow", "env_fog", "func_vehicle", "info_map_parameters", "func_buyzone", "armoury_entity", "game_text"
};


/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ NIVELES ]
=======================================================================================*/
#define MAX_LVL			560
#define MULT_PER_RANGE	(g_range[id] + 5)
#define MULT_PER_RANGE_SPEC(%1)	(g_range[%1] + 5)
#define MAX_XP			(25000000 * MULT_PER_RANGE)
new g_exp[33];
new const XPNeeded[MAX_LVL+1] =
{
	0, 5, 15, 21, 28, 36, 49, 60, 73, 86, 99, 114, 136, 171, 200, 248, 281, 361, 410, 500, // 20
	561, 630, 719, 820, 936, 1009, 1172, 1296, 1405, 1576, 1619, 1774, 1922, 2210, 2405, 2710, 3000, 3318, 3626, 4000, // 40
	4406, 4901, 5318, 5790, 6106, 6590, 7038, 7536, 8003, 8610, 9331, 9818, 10329, 10915, 11403, 11992, 12527, 13060, 13611, 14271, // 60
	14916, 15509, 16120, 16738, 17456, 18206, 19003, 19817, 20662, 21471, 22331, 23191, 24105, 25203, 26351, 27418, 28506, 29670, 30816, 32000, // 80
	33218, 34451, 35864, 37086, 38371, 39509, 40917, 42218, 43656, 44993, 46410, 47824, 49206, 50706, 52163, 54302, 56690, 58806, 61220, 63518, // 100
	70554, 79561, 87093, 95904, 103301, 111902, 119169, 126843, 135802, 143087, 151899, 159397, 168395, 175966, 184966, 193057, 200546, 209276, 217035, 225364, // 120
	233343, 240428, 248116, 255869, 264293, 271572, 280351, 288260, 296572, 305092, 312828, 321552, 329150, 336275, 344969, 352270, 360134, 368523, 377317, 385281, // 140
	392398, 400305, 408286, 416771, 425519, 434264, 443043, 450497, 459278, 466733, 474061, 482513, 490901, 499644, 508157, 516474, 525357, 534255, 541802, 549368, // 160
	557057, 565350, 572573, 580817, 588946, 597184, 604951, 612522, 621111, 629558, 636789, 644102, 651167, 658981, 667401, 675368, 683886, 692760, 701163, 709476, // 180
	716995, 725803, 734725, 742876, 751644, 760610, 768995, 776854, 784537, 792032, 800568, 808665, 816988, 825413, 834323, 842965, 851770, 860058, 867949, 875723, // 200
	883313, 890988, 898850, 907726, 915966, 923946, 932781, 940035, 948079, 956772, 965572, 973085, 980448, 987944, 995197, 1002791, 1020512, 1035877, 1053532, 1073636, // 220
	1089450, 1109092, 1125373, 1141332, 1161788, 1177971, 1193127, 1210844, 1230810, 1252066, 1267413, 1283904, 1302528, 1318935, 1336651, 1357726, 1374455, 1390621, 1411746, 1429585, // 240
	1447139, 1464403, 1480242, 1500940, 1527342, 1551915, 1576096, 1595492, 1618841, 1642749, 1663717, 1687885, 1709787, 1731657, 1752533, 1778415, 1800385, 1825693, 1848641, 1899057, // 260
	1917619, 1941576, 1964754, 1998212, 2022948, 2053029, 2081687, 2112195, 2138238, 2166319, 2192833, 2224969, 2258762, 2285081, 2313808, 2344280, 2370831, 2394393, 2422681, 2450959, // 280
	2494690, 2557693, 2608999, 2654701, 2703391, 2755039, 2815967, 2875692, 2926964, 2982553, 3044410, 3094628, 3147727, 3198458, 3241145, 3298148, 3340123, 3393765, 3455895, 3501135, // 300
	3557714, 3603357, 3647774, 3691484, 3739825, 3782478, 3834275, 3888494, 3940192, 3998008, 4045132, 4091284, 4150758, 4196574, 4256186, 4306114, 4369323, 4416281, 4470745, 4525243, // 320
	4582600, 4643013, 4695125, 4742078, 4788705, 4846492, 4894970, 4943240, 4991126, 5041423, 5101603, 5148308, 5203137, 5247820, 5303342, 5360975, 5411719, 5469041, 5513788, 5570357, // 340
	5632489, 5695667, 5748477, 5798930, 5859774, 5912722, 5955021, 6013663, 6072844, 6118590, 6181676, 6241557, 6295994, 6348985, 6397466, 6453313, 6496024, 6539431, 6588914, 6641979, // 360
	6696767, 6745168, 6797620, 6851047, 6904697, 6965652, 7019325, 7080541, 7141887, 7191458, 7238874, 7286550, 7349248, 7394009, 7452756, 7512097, 7563821, 7608152, 7670784, 7732655, // 380
	7789277, 7845870, 7892461, 7950693, 8011482, 8069259, 8130790, 8174332, 8226250, 8274471, 8337046, 8400035, 8450999, 8501377, 8558748, 8612242, 8655596, 8715700, 8776826, 8837800, // 400
	8900268, 8945012, 8993836, 9042160, 9088830, 9136229, 9190820, 9244253, 9294651, 9348497, 9408781, 9458477, 9502291, 9546167, 9588354, 9650364, 9700437, 9763686, 9823385, 9885063, // 420
	9935689, 9989025, 10051386, 10110041, 10168649, 10217923, 10275891, 10327238, 10380909, 10439012, 10488371, 10549574, 10602774, 10654121, 10702388, 10766188, 10823010, 10880330, 11000000, 11100000, // 440
	11197759, 11293348, 11390785, 11488551, 11581560, 11654424, 11720779, 11798321, 11877762, 11976341, 12068463, 12156897, 12230905, 12305282, 12384280, 12464100, 12558378, 12641160, 12730097, 12823301, // 460
	12912557, 12987250, 13051830, 13133927, 13199040, 13290889, 13356775, 13440207, 13515972, 13581682, 13665528, 13755707, 13838199, 13906673, 14001522, 14098735, 14183595, 14247831, 14332157, 14417483, // 480
	14499258, 14602397, 14669682, 14762607, 14853142, 14927439, 14992123, 15070820, 15166457, 15258675, 15332503, 15415605, 15513773, 15600026, 15686680, 15777887, 15872646, 15964356, 16063520, 16140617, // 500
	16233901, 16311576, 16414674, 16496103, 16580270, 16652365, 16748316, 16824116, 16899963, 16980678, 17059827, 17133685, 17200564, 17297818, 17368324, 17461775, 17561995, 17637968, 17705628, 17801721, // 520
	17879404, 17977606, 18062198, 18163464, 18265340, 18357391, 18458314, 18531873, 18607388, 18683361, 18755024, 18844625, 18943862, 19016307, 19086824, 19186299, 19285154, 19372684, 19465251, 19538877, // 540
	19615610, 19681275, 19779913, 19881325, 19959367, 20049102, 20119331, 20200383, 20300112, 20389292, 20844593, 21190969, 21570919, 21831759, 22101022, 22463443, 22806020, 23105056, 23718333, 25000000, // 560
	25000001
};


/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ ARCHIVOS - MODELOS, SONIDOS, SPRITES ]
=======================================================================================*/
new const g_iAccessAdminMenu = ADMIN_PASSWORD;
new const g_iAccessAdminCommand = ADMIN_PASSWORD;
new const g_iAccessAdminZpBan = ADMIN_LEVEL_H;
new const g_iAccessAdminZrCommand = ADMIN_RCON;

new const g_sModelNemesis[] = "tcs_nemesis_1";
new const g_sModelSurvivor[] = "tcs_survivor_1";
new const g_sModelWesker[] = "tcs_wesker_3";
new const g_sModelAnnihilator[] = "tcs_annihilator_1";
new const g_sModelPredator[] = "tcs_predator_1";
new const g_sModelAlien[] = "tcs_alien_1";
new const g_sModelTribal[] = "tcs_tribal_1";
new const g_sModelFP[] = "tcs_zombie_18";

new const g_sModelAlienKnife[] = "models/zombie_plague/v_alien_knife.mdl";
new const g_sModelNemesisKnife[] = "models/zombie_plague/tcs_garras_nem.mdl";
new const g_sModelGrenadeInfection[] = "models/zombie_plague/v_grenade_infect.mdl";
new const g_sModelGrenadeFire[] = "models/zombie_plague/v_grenade_fire.mdl";
new const g_sModelGrenadeFrost[] = "models/zombie_plague/v_grenade_frost.mdl";
new const g_sModelGrenadeFlare[] = "models/zombie_plague/v_grenade_flare.mdl";
new const g_sModel_BubbleNadeAura[] = "models/zp_tcs/bubble_aura.mdl";
new const g_sModel_vGrenadeBubble[] = "models/zp_tcs/v_grenade_bubble.mdl";
new const g_sModel_vGrenade[] = "models/zp_tcs/v_grenade.mdl";
new const g_sModel_AnnihilatorKnife[] = "models/zp_tcs/v_knife_anni.mdl";
new const g_model_vgrenade_pipe[] = "models/zp_tcs/v_pipe.mdl";
new const g_model_wgrenade_pipe[] = "models/zp_tcs/w_pipe.mdl";

#if defined EVENT_NAVIDAD
new const g_sModel_wGift[] = "models/zp_tcs/w_gift.mdl";
#else
new const g_sModel_wGift[] = "models/zp_tcs/head_z_big.mdl";
#endif

new const g_sModel_vBazooka[] = "models/zombie_plague/tcs_v_bazooka.mdl";
new const g_sModel_pBazooka[] = "models/zombie_plague/tcs_p_bazooka.mdl";
new const g_sModel_Rocket[] = "models/zombie_plague/tcs_rocket_1.mdl";

new const g_sSoundWinHumans[][] = { "zombie_plague/tcs_win_zombies_4.wav" };
new const g_sSoundWinZombies[][] = { "zombie_plague/tcs_win_humans_4.wav" };
new const g_sSoundWinNoOne[][] = { "ambience/3dmstart.wav" };
new const g_sSoundNemesisPain[][] = { "zombie_plague/nemesis_pain1.wav", "zombie_plague/nemesis_pain2.wav", "zombie_plague/nemesis_pain3.wav" };
new const g_sSoundZombiePain[][] = { "zombie_plague/zombie_pain1.wav", "zombie_plague/zombie_pain2.wav", "zombie_plague/zombie_pain_2_t.wav", "zombie_plague/zombie_pain3.wav", "zombie_plague/zombie_pain_1_t.wav",
"zombie_plague/zombie_pain4.wav", "zombie_plague/zombie_pain5.wav" };
new const g_sSoundZombieMissSlash[][] = { "zombie_plague/tcs_claw_slash_1.wav", "zombie_plague/tcs_claw_slash_2.wav" };
new const g_sSoundZombieMissWall[][] = { "zombie_plague/zombie_claw_wall_1.wav", "zombie_plague/zombie_claw_wall_2.wav" };
new const g_sSoundZombieHitNormal[][] = { "zombie_plague/tcs_claw_attack_1.wav", "weapons/knife_hit2.wav", "weapons/knife_hit3.wav", "weapons/knife_hit4.wav" };
new const g_sSoundZombieHitStab[][] = { "zombie_plague/tcs_claw_attack_2.wav" };
new const g_sSoundZombieDie[][] = { "zombie_plague/tcs_zombie_die_1.wav",
"zombie_plague/zombie_die1.wav",
"zombie_plague/zombie_die2.wav",
"zombie_plague/tcs_zombie_die_2.wav",
"zombie_plague/zombie_die3.wav",
"zombie_plague/zombie_die4.wav",
"zombie_plague/zombie_die5.wav" };
new const g_sSoundGrenadeFlare[][] = { "items/nvg_on.wav" };
new const g_sSoundZombieMadness[][] = { "zombie_plague/zombie_madness1.wav" };
new const g_sSoundModeSurvivor[][] = { "zombie_plague/survivor1.wav", "zombie_plague/survivor2.wav" };
new const g_sSoundModeSwarm[][] = { "ambience/the_horror2.wav" };
new const g_sSoundModeMulti[][] = { "ambience/the_horror2.wav" };
new const g_sSoundModePlague[][] = { "zombie_plague/nemesis1.wav", "zombie_plague/survivor1.wav", "zombie_plague/nemesis2.wav", "zombie_plague/survivor2.wav" };
new const g_sSoundModeNemesis[][] = { "zombie_plague/nemesis1.wav", "zombie_plague/nemesis2.wav" };
new const g_sSoundZombieInfect[][] = { "zombie_plague/tcs_zombie_infect_1.wav",
"zombie_plague/zombie_infec1.wav",
"zombie_plague/zombie_infec2.wav",
"zombie_plague/tcs_zombie_infect_2.wav",
"zombie_plague/zombie_infec3.wav",
"scientist/c1a0_sci_catscream.wav",
"zombie_plague/tcs_zombie_infect_3.wav",
"scientist/scream01.wav",
"zombie_plague/tcs_alert_1.wav" };
new const g_sSoundAntidote[][] = { "items/smallmedkit1.wav" };
new const g_sSoundGrenadeInfect[][] = { "zombie_plague/grenade_infect.wav" };
new const g_sSoundGrenadeInfectPlayer[][] = { "scientist/scream20.wav", "scientist/scream22.wav", "scientist/scream05.wav" };
new const g_sSoundGrenadeFire[][] = { "zombie_plague/grenade_explode.wav" };
new const g_sSoundGrenadeFirePlayer[][] = { "zombie_plague/zombie_burn3.wav", "zombie_plague/zombie_burn4.wav", "zombie_plague/zombie_burn5.wav", "zombie_plague/zombie_burn6.wav", "zombie_plague/zombie_burn7.wav" };
new const g_sSoundGrenadeFrost[][] = { "warcraft3/frostnova.wav" };
new const g_sSoundGrenadeFrostBreak[][] = { "warcraft3/impalelaunch1.wav" };
new const g_sSoundGrenadeFrostPlayer[][] = { "warcraft3/impalehit.wav" };
new const g_sSoundGrenadeSlowDownPlayer[][] = { "player/pl_duct2.wav" };
/*new const g_sSoundZombieIdleLast[][] = { "nihilanth/nil_thelast.wav" };
new const g_sSoundZombieIdle[][] = { "nihilanth/nil_now_die.wav",
"nihilanth/nil_slaves.wav",
"nihilanth/nil_alone.wav",
"zombie_plague/tcs_alert_2.wav",
"zombie_plague/zombie_brains1.wav",
"zombie_plague/zombie_brains2.wav",
"zombie_plague/tcs_alert_3.wav" };*/
new const g_sSoundGrenadeExplode[][] = { "misc/molotov_explosion.wav" };
new const g_sSoundArmageddonRound[][] = { "zombie_plague/tcs_sirena_2.wav" };
new const g_sSoundBazooka_1[] = "weapons/rocketfire1.wav";
new const g_sSoundBazooka_2[] = "weapons/mortarhit.wav";
new const g_sSoundBazooka_3[] = "weapons/c4_explode1.wav";
new const g_sound_pipebeep[] = "zombie_plague/pipet_beep2.wav";

new const g_sSpriteGrenadeTrail[] = "sprites/zp_tcs/laserbeam.spr";
new const g_sSpriteGrenadeRing[] = "sprites/shockwave.spr";
new const g_sSpriteGrenadeFire[] = "sprites/flame.spr";
new const g_sSpriteGrenadeSmoke[] = "sprites/black_smoke3.spr";
new const g_sSpriteGrenadeGlass[] = "models/glassgibs.mdl";
new const g_sSpriteGrenadeExplosion[] = "sprites/zp_tcs/molotov_explosion.spr";
new const g_sSpriteBeam[] = "sprites/zbeam6.spr";
new const g_sSpriteBazooka_1[] = "sprites/fexplo.spr";
new const g_sSpriteRedBall[] = "sprites/fireworks/rflare.spr";
new const g_sSpriteLightBlueBall[] = "sprites/fireworks/tflare.spr";
new const g_sSpriteYellowBall[] = "sprites/fireworks/yflare.spr";
new const g_sSprite_Anim[] = "sprites/animglow01.spr";

/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ OFFSETS, DEFINES y OTROS ]
=======================================================================================*/
enum
{
	SECTION_NONE = 0,
	SECTION_BUY_MENU_WEAPONS
};

enum(+= 236877)
{
	TASK_MODEL = 46919,
	TASK_TEAM,
	TASK_SPAWN,
	TASK_BLOOD,
	TASK_AURA,
	TASK_BURN,
	TASK_NVISION,
	TASK_MAKEZOMBIE,
	TASK_WELCOMEMSG,
	TASK_TIME_PLAYING,
	TASK_FINISHCOMBO,
	TASK_FROZEN,
	TASK_SLOWDOWN,
	TASK_MSG_SURV,
	TASK_CONVERT_ZOMBIE,
	TASK_SAVE1,
	TASK_SNIPER_ROUND
#if defined EVENT_SEMANA_INFECCION
	,TASK_FINISHCOMBO_INFECT
#endif
	,
	TASK_IMMUNITY
};

#define ID_MODEL		(taskid - TASK_MODEL)
#define ID_TEAM 		(taskid - TASK_TEAM)
#define ID_SPAWN 		(taskid - TASK_SPAWN)
#define ID_BLOOD 		(taskid - TASK_BLOOD)
#define ID_AURA 		(taskid - TASK_AURA)
#define ID_BURN 		(taskid - TASK_BURN)
#define ID_NVISION 		(taskid - TASK_NVISION)
#define ID_TIME_PLAYING	(taskid - TASK_TIME_PLAYING)
#define ID_FINISHCOMBO 	(taskid - TASK_FINISHCOMBO)
#define ID_FROZEN 		(taskid - TASK_FROZEN)
#define ID_SLOWDOWN 	(taskid - TASK_SLOWDOWN)
#define ID_MSG_SURV 	(taskid - TASK_MSG_SURV)
#define ID_CONVERT_ZOMBIE	(taskid - TASK_CONVERT_ZOMBIE)
#define ID_SAVE1			(taskid - TASK_SAVE1)
#define ID_IMMUNITY 		(taskid - TASK_IMMUNITY)

#if defined EVENT_SEMANA_INFECCION
	#define ID_FINISHCOMBO_INFECT 	(taskid - TASK_FINISHCOMBO_INFECT)
#endif

#define PL_ACTION 				g_menu_data[id][0]
#define MODE_ACTION 			g_menu_data[id][19]

#define WPN_STARTID 			g_menu_data[id][1]
#define WPN_MAXIDS 				ArraySize(g_primary_items)
#define WPN_SELECTION 			(g_menu_data[id][1] + key)
#define WPN_AUTO_PRI 			g_menu_data[id][2]

#define WPN_STARTID_2	 		g_menu_data[id][3]
#define WPN_MAXIDS_2 			ArraySize(g_secondary_items)
#define WPN_SELECTION_2 		(g_menu_data[id][3]+key)
#define WPN_AUTO_SEC 			g_menu_data[id][4]

#define WPN_AUTO_TER 			g_menu_data[id][5]

#define MENU_PAGE_ZCLASS 		g_menu_data[id][6]
#define MENU_PAGE_EXTRAS 		g_menu_data[id][7]
#define MENU_PAGE_PLAYERS 		g_menu_data[id][8]

#define MENU_PAGE_HCLASS 		g_menu_data[id][9]
#define MENU_FOR_CLASS_OR_HAB 	g_menu_data[id][10]

#define POINT_CLASS 			g_menu_data[id][11]
#define POINT_ITEM 				g_menu_data[id][12]

#define NVG_HUD					g_menu_data[id][13]
#define MENU_PAGE_OPT_HUD 		g_menu_data[id][14]

#define MENU_PAGE_LIST_LVLS		g_menu_data[id][15]

#define MENU_PAGE_BINDS			g_menu_data[id][16]

#define MENU_PAGE_LOGROS(%1)	g_page_logros[id][%1]
#define LOGRO_CLASS				g_menu_data[id][17]
#define LOGRO_ITEM				g_menu_data[id][18]

#define MENU_PAGE_HATS			g_menu_data[id][20]

#define RINGS_NECKS				g_menu_data[id][21]
#define RN						g_menu_data[id][22]

#define ZOMBIE_LEVEL_ACEPTED 	g_menu_data[id][23]
#define ZOMBIE_CLASS_ID 		g_menu_data[id][24]
#define MENU_PAGE_ZCLASS_COMP 	g_menu_data[id][25]

#define HUMAN_LEVEL_ACEPTED 	g_menu_data[id][26]
#define HUMAN_CLASS_ID 			g_menu_data[id][27]
#define MENU_PAGE_HCLASS_COMP 	g_menu_data[id][28]

#define ZOMBIE_RANGE_ACEPTED	g_menu_data[id][29]
#define HUMAN_RANGE_ACEPTED		g_menu_data[id][30]

#define HAT_ITEM				g_menu_data[id][31]
#define HAT_ITEM_SET			g_menu_data[id][32]

#define MENU_CHOOSE_MODE_A		g_menu_data[id][33]

#define MENU_STATS_PAGE			g_menu_data[id][34]

const MENU_KEY_AUTOSELECT = 7;
const MENU_KEY_BACK = 7;
const MENU_KEY_NEXT = 8;
const MENU_KEY_EXIT = 9;

enum(+=1)
{
	MODE_NONE = 0,
	MODE_INFECTION,
	MODE_NEMESIS,
	MODE_SURVIVOR,
	MODE_SWARM,
	MODE_MULTI,
	MODE_PLAGUE,
	MODE_ARMAGEDDON,
	MODE_WESKER,
	MODE_TRIBAL,
	MODE_ALVSPRED,
	MODE_ANNIHILATION,
	MODE_SNIPER,
	MODE_DUEL,
	MODE_FP,
	
	MODE_TOTALS
};
new g_modes_play[MODE_TOTALS];

const Float:HUD_EVENT_X = -1.0;
const Float:HUD_EVENT_Y = 0.17;

new Ham:Ham_Player_ResetMaxSpeed = Ham_Item_PreFrame;

const PDATA_SAFE 				= 2;
const OFFSET_LINUX_WEAPONS 		= 4;
const OFFSET_LINUX 				= 5;
const OFFSET_WEAPONOWNER 		= 41;
const OFFSET_ID					= 43;
const OFFSET_KNOWN				= 44;
const OFFSET_NEXT_PRIMARY_ATTACK = 46;
const OFFSET_NEXT_SECONDARY_ATTACK = 47;
const OFFSET_TIME_WEAPON_IDLE 	= 48;
const OFFSET_PRIMARY_AMMO_TYPE	= 49;
const OFFSET_CLIPAMMO 			= 51;
const OFFSET_IN_RELOAD 			= 54;
const OFFSET_IN_SPECIAL_RELOAD	= 55;
const OFFSET_SILENT				= 74;
const OFFSET_NEXT_ATTACK		= 83;
const OFFSET_PAINSHOCK 			= 108; // ConnorMcLeod
const OFFSET_CSTEAMS 			= 114;
const OFFSET_CSMENUCODE 		= 205;
const OFFSET_FLASHLIGHT_BATTERY = 244;
const OFFSET_CSDEATHS 			= 444;
const OFFSET_ACTIVE_ITEM 		= 373;
const OFFSET_AMMO_PLAYER_SLOT0	= 376;
const OFFSET_AWM_AMMO  			= 377;
const OFFSET_SCOUT_AMMO 		= 378;
const OFFSET_PARA_AMMO 			= 379;
const OFFSET_FAMAS_AMMO 		= 380;
const OFFSET_M3_AMMO 			= 381;
const OFFSET_USP_AMMO 			= 382;
const OFFSET_FIVESEVEN_AMMO 	= 383;
const OFFSET_DEAGLE_AMMO		= 384;
const OFFSET_P228_AMMO 			= 385;
const OFFSET_GLOCK_AMMO 		= 386;
const OFFSET_FLASH_AMMO 		= 387;
const OFFSET_HE_AMMO 			= 388;
const OFFSET_SMOKE_AMMO 		= 389;
const OFFSET_C4_AMMO 			= 390;


new const AMMOOFFSET[] = {-1, OFFSET_P228_AMMO, -1, OFFSET_SCOUT_AMMO, OFFSET_HE_AMMO, OFFSET_M3_AMMO, OFFSET_C4_AMMO, OFFSET_USP_AMMO, OFFSET_FAMAS_AMMO,
OFFSET_SMOKE_AMMO, OFFSET_GLOCK_AMMO, OFFSET_FIVESEVEN_AMMO, OFFSET_USP_AMMO, OFFSET_FAMAS_AMMO, OFFSET_FAMAS_AMMO, OFFSET_FAMAS_AMMO, OFFSET_USP_AMMO,
OFFSET_GLOCK_AMMO, OFFSET_AWM_AMMO, OFFSET_GLOCK_AMMO, OFFSET_PARA_AMMO, OFFSET_M3_AMMO, OFFSET_FAMAS_AMMO, OFFSET_GLOCK_AMMO, OFFSET_SCOUT_AMMO, OFFSET_FLASH_AMMO,
OFFSET_DEAGLE_AMMO, OFFSET_FAMAS_AMMO, OFFSET_SCOUT_AMMO, -1, OFFSET_FIVESEVEN_AMMO};

#if cellbits == 32
	#define OFFSET_BUYZONE 235
#else
	#define OFFSET_BUYZONE 268
#endif

enum
{
	FM_CS_TEAM_UNASSIGNED = 0,
	FM_CS_TEAM_T,
	FM_CS_TEAM_CT,
	FM_CS_TEAM_SPECTATOR
};
new const CS_TEAM_NAMES[][] = { "UNASSIGNED", "TERRORIST", "CT", "SPECTATOR" };

const HIDE_MONEY = (1 << 5)|(1 << 3);
const UNIT_SECOND = (1 << 12);
const DMG_HEGRENADE = (1 << 24);
const USE_USING = 2;
const USE_STOPPED = 0;
const STEPTIME_SILENT = 999;
const BREAK_GLASS = 0x01;
const FFADE_IN = 0x0000;
const FFADE_STAYOUT = 0x0004;
const EV_ENT_FLARE = EV_ENT_euser3

new const MAXBPAMMO[] = { -1, 52, -1, 90, 1, 32, 1, 100, 90, 1, 120, 100, 100, 90, 90, 90, 100, 120, 30, 120, 200, 32, 90, 120, 90, 2, 35, 90, 90, -1, 100 };
new const MAXCLIP[] = { -1, 13, -1, 10, -1, 7, -1, 30, 30, -1, 30, 20, 25, 30, 35, 25, 12, 20, 10, 30, 100, 8, 30, 30, 20, -1, 7, 30, 30, -1, 50 };
new const AMMOID[] = { -1, 9, -1, 2, 12, 5, 14, 6, 4, 13, 10, 7, 6, 4, 4, 4, 6, 10, 1, 10, 3, 5, 4, 10, 2, 11, 8, 4, 2, -1, 7 };
new const AMMOTYPE[][] = { "", "357sig", "", "762nato", "", "buckshot", "", "45acp", "556nato", "", "9mm", "57mm", "45acp", "556nato", "556nato", "556nato", "45acp",
"9mm", "338magnum", "9mm", "556natobox", "buckshot", "556nato", "9mm", "762nato", "", "50ae", "556nato", "762nato", "", "57mm" };
new const AMMOWEAPON[] = { 0, CSW_AWP, CSW_SCOUT, CSW_M249, CSW_AUG, CSW_XM1014, CSW_MAC10, CSW_FIVESEVEN, CSW_DEAGLE, CSW_P228, CSW_ELITE, CSW_FLASHBANG, CSW_HEGRENADE,
CSW_SMOKEGRENADE, CSW_C4 };
new const WEAPONENTNAMES[][] = { "", "weapon_p228", "", "weapon_scout", "weapon_hegrenade", "weapon_xm1014", "weapon_c4", "weapon_mac10",
"weapon_aug", "weapon_smokegrenade", "weapon_elite", "weapon_fiveseven", "weapon_ump45", "weapon_sg550", "weapon_galil", "weapon_famas", "weapon_usp", "weapon_glock18",
"weapon_awp", "weapon_mp5navy", "weapon_m249", "weapon_m3", "weapon_m4a1", "weapon_tmp", "weapon_g3sg1", "weapon_flashbang", "weapon_deagle", "weapon_sg552",
"weapon_ak47", "weapon_knife", "weapon_p90" };

new const sound_buyammo[] = "items/9mmclip1.wav";
new const sound_armorhit[] = "player/bhit_helmet-1.wav";
new const sound_electro[] = "weapons/electro5.wav";

const Float:NADE_EXPLOSION_RADIUS = 240.0;
const EV_ADDITIONAL_AMMO = EV_INT_iuser1;

const EV_NADE_TYPE = EV_INT_flTimeStepSound;
enum(+=64721)
{
	NADE_TYPE_INFECTION = 9784816,
	NADE_TYPE_NAPALM,
	NADE_TYPE_FROST,
	NADE_TYPE_FLARE,
	NADE_TYPE_GRENADE,
	NADE_TYPE_ANNIHILATION,
	NADE_TYPE_PIPE,
	NADE_TYPE_ANTIDOTE
};
const NADE_TYPE_BUBBLE = 5555;
const EV_FLARE_COLOR = EV_VEC_punchangle;
const EV_FLARE_DURATION = EV_INT_flSwimTime;
const EV_BUBBLE_ENT = EV_VEC_vuser4;

const PRIMARY_WEAPONS_BIT_SUM = (1 << CSW_SCOUT)|(1 << CSW_XM1014)|(1 << CSW_MAC10)|(1 << CSW_AUG)|(1 << CSW_UMP45)|(1 << CSW_SG550)|(1 << CSW_GALIL)|(1 << CSW_FAMAS)|
(1 << CSW_AWP)|(1 << CSW_MP5NAVY)|(1 << CSW_M249)|(1 << CSW_M3)|(1 << CSW_M4A1)|(1 << CSW_TMP)|(1 << CSW_G3SG1)|(1 << CSW_SG552)|(1 << CSW_AK47)|(1 << CSW_P90);
const SECONDARY_WEAPONS_BIT_SUM = (1 << CSW_P228)|(1 << CSW_ELITE)|(1 << CSW_FIVESEVEN)|(1 << CSW_USP)|(1 << CSW_GLOCK18)|(1 << CSW_DEAGLE);
const ZOMBIE_ALLOWED_WEAPONS_BITSUM = (1 << CSW_KNIFE)|(1 << CSW_HEGRENADE)|(1 << CSW_FLASHBANG)|(1 << CSW_SMOKEGRENADE)|(1 << CSW_C4)|(1 << CSW_SG550)|(1 << CSW_MAC10);

const KEYSMENU = MENU_KEY_1|MENU_KEY_2|MENU_KEY_3|MENU_KEY_4|MENU_KEY_5|MENU_KEY_6|MENU_KEY_7|MENU_KEY_8|MENU_KEY_9|MENU_KEY_0;

enum
{
	ACTION_ZOMBIEFY_HUMANIZE = 0,
	ACTION_MAKE_NEMESIS,
	ACTION_MAKE_SURVIVOR,
	ACTION_MAKE_WESKER,
	ACTION_MAKE_ANNIHILATOR,
	ACTION_MAKE_SNIPER,
	ACTION_RESPAWN_PLAYER,
	ACTION_MODE_SWARM = 0,
	ACTION_MODE_MULTI,
	ACTION_MODE_PLAGUE,
	ACTION_MODE_ARMAGEDDON,
	ACTION_MODE_TRIBAL,
	ACTION_MODE_ALVSPRED,
	ACTION_MODE_DUEL,
	ACTION_MODE_FP
};
enum
{
	ACTION_NEMESIS = 0,
	ACTION_SURVIVOR,
	ACTION_WESKER,
	ACTION_ANNIHILATION,
	ACTION_SNIPER
}


new g_zombie[33];
new g_nemesis[33];
new g_survivor[33];
new g_firstzombie[33];
new g_lastzombie[33];
new g_lasthuman[33];
new g_frozen[33];
new g_frozen_acc[33];
new Float:g_frozen_gravity[33];
new g_nodamage[33];
new g_respawn_as_zombie[33];
new g_nvision[33];
new g_nvisionenabled[33];
new g_zombieclass[33];
new g_zombieclassnext[33];
new g_buy[33];
new g_ammopacks[33];
new g_damagedealt[33];
new g_playermodel[33][32];
new g_menu_data[33][35];
new g_page_logros[33][MAX_CLASS];
new g_burning_duration[33];
new g_hclass_max[33];
new g_zclass_max[33];

new g_newround;
new g_endround;
new g_enround_forced;
new g_nemround;
new g_survround;
new g_swarmround;
new g_duel_final;
new g_duel_final_aps = 0;
new g_duel_cuartos;
new g_duel_semi;
new g_duel_rfinal;
new g_duel_humans[8];
new g_duel_win_xp[33];
new g_plagueround;
new g_scorezombies, g_scorehumans;
new g_spawnCount, g_spawnCount2;
new Float:g_spawns[128][3], Float:g_spawns2[128][3];
new Float:g_models_targettime;
new Float:g_teams_targettime;
new g_MsgSync, g_MsgSync2, g_MsgSync3;
new g_trailSpr, g_exploSpr, g_flameSpr, g_smokeSpr, g_glassSpr, g_grenadeSpr, g_beamSpr, g_explo2Spr, g_redballSpr, g_lightblueballSpr, g_yellowballSpr;
new g_maxplayers;
new g_fwSpawn, g_fwPrecacheSound;
new g_infbombcounter, g_antidotecounter, g_madnesscounter;
new g_switchingteam;

new g_msgNVGToggle, g_msgScoreAttrib, g_msgAmmoPickup, g_msgScreenFade,
g_msgDeathMsg, g_msgSetFOV, g_msgFlashlight, g_msgFlashBat, g_msgScoreInfo, g_msgTeamInfo,
g_msgHideWeapon, g_msgCrosshair, g_msgSayText, g_msgScreenShake, g_msgCurWeapon, g_msgStatusIcon, g_msgHostagePos;

new Array:g_zclass_name;
new Array:g_zclass_playermodel;
new Array:g_zclass_clawmodel;
new Array:g_zclass_hp;
new Array:g_zclass_spd;
new Array:g_zclass_grav;
new Array:g_zclass_dmg;
new Array:g_zclass_level;
new Array:g_zclass_range;
new Array:g_zclass_premium;
new g_zclass_i;

new Array:g_hclass_name;
new Array:g_hclass_playermodel;
new Array:g_hclass_hp;
new Array:g_hclass_spd;
new Array:g_hclass_grav;
new Array:g_hclass_dmg;
new Array:g_hclass_level;
new Array:g_hclass_range;
new Array:g_hclass_premium;
new g_hclass_i;

new Array:g_primary_items, Array:g_secondary_items,
Array:g_primary_weaponids, Array:g_secondary_weaponids

new Array:g_pri_weap_lvl, Array:g_pri_weap_range, Array:g_sec_weap_lvl

new cvar_warmup;

new g_currentweapon[33];
new g_playername[33][32];
new g_steamid[33][64];
new Float:g_zombie_spd[33];
new Float:g_zombie_dmg[33];
new g_zombie_classname[33][32];
new Float:g_human_spd[33];
new Float:g_human_dmg[33];
new g_human_classname[33][32];

#define is_user_valid_connected(%1) (1 <= %1 <= g_maxplayers && hub(%1, g_data[BIT_CONNECTED]))
#define is_user_valid_alive(%1) (1 <= %1 <= g_maxplayers && hub(%1, g_data[BIT_ALIVE]))
#define is_user_valid(%1) (1 <= %1 <= g_maxplayers)

/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ PRECACHE e INIT ]
=======================================================================================*/
new g_headspr
public plugin_precache()
{
	register_forward(FM_Sys_Error, "fw_SysError");
	
	/*register_forward(FM_PrecacheModel, "fw_Precache_Post", 1);
	register_forward(FM_PrecacheSound, "fw_Precache_Post", 1);
	register_forward(FM_PrecacheGeneric, "fw_Precache_Post", 1);*/
	
	register_plugin(g_sZombiePlagueName, g_sZombiePlagueVersion, "Kiske");
	
	new i;
	new j;
	new buffer[100];
	
	formatex(buffer, charsmax(buffer), "gfx/env/%sbk.tga", g_sSky);
	precache_generic(buffer);
	
	formatex(buffer, charsmax(buffer), "gfx/env/%sdn.tga", g_sSky);
	precache_generic(buffer);
	
	formatex(buffer, charsmax(buffer), "gfx/env/%sft.tga", g_sSky);
	precache_generic(buffer);
	
	formatex(buffer, charsmax(buffer), "gfx/env/%slf.tga", g_sSky);
	precache_generic(buffer);
	
	formatex(buffer, charsmax(buffer), "gfx/env/%srt.tga", g_sSky);
	precache_generic(buffer);
	
	formatex(buffer, charsmax(buffer), "gfx/env/%sup.tga", g_sSky);
	precache_generic(buffer);
	
	precache_generic("sound/zombie_plague/twd.mp3");
	
	precache_model("models/rpgrocket.mdl")
	
	dotsprite = precache_model("sprites/dot.spr")
	
	g_headspr = precache_model("sprites/zp_tcs/kill_headshot_gold_ffff.spr")
	
	for(i = 0; i < 6; ++i)
	{
		formatex(buffer, charsmax(buffer), "sprites/zp_tcs/%s.spr", EMOTICONES_SPR[i]); 
		g_iSpirteIndex[i] = precache_model(buffer);
	}

	g_primary_items = ArrayCreate(32, 1);
	g_secondary_items = ArrayCreate(32, 1);
	g_primary_weaponids = ArrayCreate(1, 1);
	g_secondary_weaponids = ArrayCreate(1, 1);
	
	g_pri_weap_lvl = ArrayCreate(1, 1);
	g_pri_weap_range = ArrayCreate(1, 1);
	g_sec_weap_lvl = ArrayCreate(1, 1);
	
	g_zclass_name = ArrayCreate(32, 1);
	g_zclass_playermodel = ArrayCreate(32, 1);
	g_zclass_clawmodel = ArrayCreate(32, 1);
	g_zclass_hp = ArrayCreate(1, 1);
	g_zclass_spd = ArrayCreate(1, 1);
	g_zclass_grav = ArrayCreate(1, 1);
	g_zclass_dmg = ArrayCreate(1, 1);
	g_zclass_level = ArrayCreate(1, 1);
	g_zclass_range = ArrayCreate(1, 1);
	g_zclass_premium = ArrayCreate(1, 1);
	
	g_hclass_name = ArrayCreate(32, 1);
	g_hclass_playermodel = ArrayCreate(32, 1);
	g_hclass_hp = ArrayCreate(1, 1);
	g_hclass_spd = ArrayCreate(1, 1);
	g_hclass_grav = ArrayCreate(1, 1);
	g_hclass_dmg = ArrayCreate(1, 1);
	g_hclass_level = ArrayCreate(1, 1);
	g_hclass_range = ArrayCreate(1, 1);
	g_hclass_premium = ArrayCreate(1, 1);
	
	// HABILITIES
	for(i = 0; i < MAX_HAB; i++)
	{
		A_HAB_NAMES[i] = ArrayCreate(64, 1)
		A_HAB_MAX_LEVEL[i] = ArrayCreate(1, 1)
		A_HAB_MAX_PERCENT[i] = ArrayCreate(1, 1)
	}
	
	MAX_HABILITIES[0] = MAX_HUMAN_HABILITIES
	MAX_HABILITIES[1] = MAX_ZOMBIE_HABILITIES
	MAX_HABILITIES[2] = MAX_SURV_HABILITIES
	MAX_HABILITIES[3] = MAX_NEM_HABILITIES
	MAX_HABILITIES[4] = MAX_OTHER_HABILITIES
	
	for(i = 0; i < MAX_HAB; i++)
	{
		for(j = 0; j < MAX_HABILITIES[i]; j++)
		{
			ArrayPushString(A_HAB_NAMES[i], LANG_HAB_CLASS[i][j])
			ArrayPushCell(A_HAB_MAX_LEVEL[i], MAX_HAB_LEVEL[i][j])
			ArrayPushCell(A_HAB_MAX_PERCENT[i], MAX_HAB_PERCENT[i][j])
		}			
	}
	
	// LOGROS
	for(i = 0; i < MAX_CLASS; i++)
	{
		A_LOGROS_NAMES[i] = ArrayCreate(64, 1)
		A_LOGROS_DESCRIPTION[i] = ArrayCreate(150, 1)
		A_LOGROS_POINTS[i] = ArrayCreate(1, 1)
	}
	
	MAX_LOGROS_CLASS[LOGRO_HUMAN] = MAX_HUMANS_LOGROS
	MAX_LOGROS_CLASS[LOGRO_ZOMBIE] = MAX_ZOMBIES_LOGROS
	MAX_LOGROS_CLASS[LOGRO_SURV] = MAX_SURVIVOR_LOGROS
	MAX_LOGROS_CLASS[LOGRO_NEM] = MAX_NEMESIS_LOGROS
	MAX_LOGROS_CLASS[LOGRO_OTHERS] = MAX_OTHERS_LOGROS
	MAX_LOGROS_CLASS[LOGRO_EV_NAVIDAD] = MAX_EV_NAVIDAD_LOGROS
	MAX_LOGROS_CLASS[LOGRO_EV_HEAD_ZOMBIES] = MAX_EV_HEADZ_LOGROS
	MAX_LOGROS_CLASS[LOGRO_ANNIHILATOR] = MAX_ANNIHILATOR_LOGROS
	MAX_LOGROS_CLASS[LOGRO_WESKER] = MAX_WESKER_LOGROS
	MAX_LOGROS_CLASS[LOGRO_EV_AMOR] = MAX_EV_AMOR_LOGROS
	MAX_LOGROS_CLASS[LOGRO_SNIPER] = MAX_SNIPER_LOGROS
	MAX_LOGROS_CLASS[LOGRO_SECRET] = MAX_SECRET_LOGROS
	MAX_LOGROS_CLASS[LOGRO_LEGENDARIO] = MAX_LOGRO_LEGENDARIO
	
	for(i = 0; i < MAX_CLASS; i++)
	{
		for(j = 0; j < MAX_LOGROS_CLASS[i]; j ++)
		{
			ArrayPushString(A_LOGROS_NAMES[i], LANG_LOGROS_NAMES[i][j])
			ArrayPushString(A_LOGROS_DESCRIPTION[i], LANG_LOGROS_DESCRIPTION[i][j])
			ArrayPushCell(A_LOGROS_POINTS[i], LOGROS_REWARD_POINTS[i][j])
		}
	}
	
	load_customization_from_files();
	
	/*precache_model("models/weapon_legends/v_colt_legend_00.mdl");
	precache_model("models/weapon_legends/v_colt_legend_01.mdl");
	precache_model("models/tcs_colt_2/v_tcs_colt_2.mdl");*/
	
	precache_model("models/player/zp_tcs_l4d_louis/zp_tcs_l4d_louis.mdl")

	// Player Models
	formatex(buffer, charsmax(buffer), "models/player/%s/%s.mdl", g_sModelNemesis, g_sModelNemesis);
	precache_model(buffer);
	
	// Precache modelT.mdl files too
	formatex(buffer, charsmax(buffer), "models/player/%s/%sT.mdl", g_sModelNemesis, g_sModelNemesis)
	precache_model(buffer);
	
	formatex(buffer, charsmax(buffer), "models/player/%s/%s.mdl", g_sModelSurvivor, g_sModelSurvivor);
	precache_model(buffer);
	
	// Precache modelT.mdl files too
	formatex(buffer, charsmax(buffer), "models/player/%s/%sT.mdl", g_sModelSurvivor, g_sModelSurvivor)
	precache_model(buffer);
	
	formatex(buffer, charsmax(buffer), "models/player/%s/%s.mdl", g_sModelWesker, g_sModelWesker);
	precache_model(buffer);
	
	// Precache modelT.mdl files too
	/*formatex(buffer, charsmax(buffer), "models/player/%s/%sT.mdl", g_sModelWesker, g_sModelWesker)
	if(file_exists(buffer)) precache_model(buffer);*/
	
	formatex(buffer, charsmax(buffer), "models/player/%s/%s.mdl", g_sModelAnnihilator, g_sModelAnnihilator);
	precache_model(buffer);
	
	formatex(buffer, charsmax(buffer), "models/player/%s/%s.mdl", g_sModelFP, g_sModelFP);
	precache_model(buffer);
	
	precache_model("models/zombie_plague/tcs_garras_fp.mdl");
	
	formatex(buffer, charsmax(buffer), "models/player/%s/%s.mdl", g_sModelPredator, g_sModelPredator);
	precache_model(buffer);
	
	formatex(buffer, charsmax(buffer), "models/player/%s/%s.mdl", g_sModelAlien, g_sModelAlien);
	precache_model(buffer);
	
	formatex(buffer, charsmax(buffer), "models/player/%s/%s.mdl", g_sModelTribal, g_sModelTribal);
	precache_model(buffer);
	
	// Precache modelT.mdl files too
	formatex(buffer, charsmax(buffer), "models/player/%s/%sT.mdl", g_sModelTribal, g_sModelTribal);
	precache_model(buffer);
	
	/*precache_model("models/player/tcs_zombie_199/tcs_zombie_199.mdl")
	precache_model("models/zombie_plague/zknife199.mdl")*/
	
	precache_sound( "buttons/button1.wav" )
	precache_sound("weapons/xbow_fire1.wav")
	
	// Weapon Models
	precache_model(g_sModelAlienKnife);
	precache_model(g_sModelNemesisKnife);
	precache_model(g_sModelGrenadeInfection);
	precache_model(g_sModelGrenadeFire);
	precache_model(g_sModelGrenadeFrost);
	precache_model(g_sModelGrenadeFlare);
	precache_model(g_sModel_BubbleNadeAura);
	precache_model(g_sModel_vGrenadeBubble);
	precache_model(g_sModel_vGrenade);
	precache_model(g_sModel_vBazooka);
	precache_model(g_sModel_pBazooka);
	precache_model(g_sModel_Rocket);
	precache_model(g_sModel_AnnihilatorKnife);
	precache_model(g_model_vgrenade_pipe);
	precache_model(g_model_wgrenade_pipe);
	
	precache_model(g_sModel_wGift);
	precache_sound("items/ammopickup1.wav");
	
	//precache_sound("zombie_plague/twd_2.wav");
	
	// HATS
	for(i = 0; i < sizeof(g_hat_mdl) - 1; i++)
	{
		formatex(buffer, charsmax(buffer), "models/zp_tcs/hats/%s.mdl", g_hat_mdl[i])
		precache_model(buffer);
	}
	
	for(i = 0; i < sizeof(g_weapon_v_models); i++)
		precache_model(g_weapon_v_models[i])
	
	// Sounds
	for(i = 0; i < sizeof(g_sSoundWinHumans); i++)
		precache_sound(g_sSoundWinHumans[i]);
	for(i = 0; i < sizeof(g_sSoundWinZombies); i++)
		precache_sound(g_sSoundWinZombies[i]);
	for(i = 0; i < sizeof(g_sSoundWinNoOne); i++)
		precache_sound(g_sSoundWinNoOne[i]);
	for(i = 0; i < sizeof(g_sSoundNemesisPain); i++)
		precache_sound(g_sSoundNemesisPain[i]);
	for(i = 0; i < sizeof(g_sSoundZombiePain); i++)
		precache_sound(g_sSoundZombiePain[i]);
	for(i = 0; i < sizeof(g_sSoundZombieMissSlash); i++)
		precache_sound(g_sSoundZombieMissSlash[i]);
	for(i = 0; i < sizeof(g_sSoundZombieMissWall); i++)
		precache_sound(g_sSoundZombieMissWall[i]);
	for(i = 0; i < sizeof(g_sSoundZombieHitNormal); i++)
		precache_sound(g_sSoundZombieHitNormal[i]);
	for(i = 0; i < sizeof(g_sSoundZombieHitStab); i++)
		precache_sound(g_sSoundZombieHitStab[i]);
	for(i = 0; i < sizeof(g_sSoundZombieDie); i++)
		precache_sound(g_sSoundZombieDie[i]);
	for(i = 0; i < sizeof(g_sSoundGrenadeFlare); i++)
		precache_sound(g_sSoundGrenadeFlare[i]);
	for(i = 0; i < sizeof(g_sSoundZombieMadness); i++)
		precache_sound(g_sSoundZombieMadness[i]);
	for(i = 0; i < sizeof(g_sSoundModeSurvivor); i++)
		precache_sound(g_sSoundModeSurvivor[i]);
	for(i = 0; i < sizeof(g_sSoundModeSwarm); i++)
		precache_sound(g_sSoundModeSwarm[i]);
	for(i = 0; i < sizeof(g_sSoundModeMulti); i++)
		precache_sound(g_sSoundModeMulti[i]);
	for(i = 0; i < sizeof(g_sSoundModePlague); i++)
		precache_sound(g_sSoundModePlague[i]);
	for(i = 0; i < sizeof(g_sSoundModeNemesis); i++)
		precache_sound(g_sSoundModeNemesis[i]);
	for(i = 0; i < sizeof(g_sSoundZombieInfect); i++)
		precache_sound(g_sSoundZombieInfect[i]);
	for(i = 0; i < sizeof(g_sSoundAntidote); i++)
		precache_sound(g_sSoundAntidote[i]);
	for(i = 0; i < sizeof(g_sSoundGrenadeInfect); i++)
		precache_sound(g_sSoundGrenadeInfect[i]);
	for(i = 0; i < sizeof(g_sSoundGrenadeInfectPlayer); i++)
		precache_sound(g_sSoundGrenadeInfectPlayer[i]);
	for(i = 0; i < sizeof(g_sSoundGrenadeFire); i++)
		precache_sound(g_sSoundGrenadeFire[i]);
	for(i = 0; i < sizeof(g_sSoundGrenadeFirePlayer); i++)
		precache_sound(g_sSoundGrenadeFirePlayer[i]);
	for(i = 0; i < sizeof(g_sSoundGrenadeFrost); i++)
		precache_sound(g_sSoundGrenadeFrost[i]);
	for(i = 0; i < sizeof(g_sSoundGrenadeFrostBreak); i++)
		precache_sound(g_sSoundGrenadeFrostBreak[i]);
	for(i = 0; i < sizeof(g_sSoundGrenadeFrostPlayer); i++)
		precache_sound(g_sSoundGrenadeFrostPlayer[i]);
	for(i = 0; i < sizeof(g_sSoundGrenadeSlowDownPlayer); i++)
		precache_sound(g_sSoundGrenadeSlowDownPlayer[i]);
	/*for(i = 0; i < sizeof(g_sSoundZombieIdleLast); i++)
		precache_sound(g_sSoundZombieIdleLast[i]);
	for(i = 0; i < sizeof(g_sSoundZombieIdle); i++)
		precache_sound(g_sSoundZombieIdle[i]);*/
	for(i = 0; i < sizeof(g_sSoundGrenadeExplode); i++)
		precache_sound(g_sSoundGrenadeExplode[i]);
	for(i = 0; i < sizeof(g_sSoundArmageddonRound); i++)
		precache_sound(g_sSoundArmageddonRound[i]);
	
	precache_sound(sound_buyammo);
	precache_sound(sound_armorhit);
	precache_sound(sound_electro);
	precache_sound(g_sSoundBazooka_1);
	precache_sound(g_sSoundBazooka_2);
	precache_sound(g_sSoundBazooka_3);
	precache_sound(g_sound_pipebeep);
	precache_sound("warcraft3/purgetarget1.wav");
	
	// Sprites
	g_trailSpr = precache_model(g_sSpriteGrenadeTrail);
	g_exploSpr = precache_model(g_sSpriteGrenadeRing);
	g_flameSpr = precache_model(g_sSpriteGrenadeFire);
	g_smokeSpr = precache_model(g_sSpriteGrenadeSmoke);
	g_glassSpr = precache_model(g_sSpriteGrenadeGlass);
	g_grenadeSpr = precache_model(g_sSpriteGrenadeExplosion);
	g_beamSpr = precache_model(g_sSpriteBeam);
	g_explo2Spr = precache_model(g_sSpriteBazooka_1);
	g_redballSpr = precache_model(g_sSpriteRedBall);
	g_lightblueballSpr = precache_model(g_sSpriteLightBlueBall);
	g_yellowballSpr = precache_model(g_sSpriteYellowBall);
	precache_model(g_sSprite_Anim);
	
	precache_model("models/zombie_plague/tcs_garras_1.mdl");
	precache_model("models/zombie_plague/tcs_garras_2.mdl");
	precache_model("models/zombie_plague/tcs_garras_3.mdl");
	precache_model("models/zombie_plague/tcs_garras_4.mdl");
	precache_model("models/zombie_plague/tcs_garras_5.mdl");
	precache_model("models/zombie_plague/tcs_garras_9.mdl");
	precache_model("models/zombie_plague/tcs_garras_10.mdl");
	precache_model("models/zombie_plague/tcs_garras_16.mdl");
	
	// Register zombie and human class
	native_register_zombie_class("Mooly", "zombie_source", "v_knife_zombie.mdl", 	23617, 230, 1.00, 10.00, 1, 	0, 0);
	native_register_zombie_class("Hat", "zombie_source", "v_knife_zombie.mdl", 		25689, 232, 0.9,  11.00, 14, 	0, 0);
	native_register_zombie_class("Miiak", "tcs_zombie_1", "tcs_garras_1.mdl", 		27973, 233, 0.87, 12.00, 34, 	0, 0);
	native_register_zombie_class("Paloord", "tcs_zombie_1", "tcs_garras_1.mdl", 	29137, 234, 0.86, 12.00, 56, 	0, 0);
	native_register_zombie_class("OC-3", "tcs_zombie_12", "tcs_garras_2.mdl",		35319, 237, 0.83, 14.00, 71, 	0, 1);
	native_register_zombie_class("Karko", "tcs_zombie_6", "tcs_garras_3.mdl", 		33642, 236, 0.84, 13.00, 99, 	0, 0);
	native_register_zombie_class("Seffel", "tcs_zombie_6", "tcs_garras_3.mdl", 		35647, 237, 0.82, 14.00, 156, 	0, 0);
	native_register_zombie_class("Boorm", "tcs_zombie_6", "tcs_garras_3.mdl", 		37210, 238, 0.81, 14.00, 223, 	0, 0);
	native_register_zombie_class("Vylk", "tcs_zombie_7", "tcs_garras_4.mdl", 		39279, 239, 0.79, 15.00, 301, 	0, 0);
	native_register_zombie_class("Rewttem", "tcs_zombie_7", "tcs_garras_4.mdl", 	41642, 240, 0.78, 15.00, 388, 	0, 0);
	native_register_zombie_class("Lacco", "tcs_zombie_3", "tcs_garras_5.mdl", 		43314, 241, 0.76, 16.00, 464, 	0, 0);
	native_register_zombie_class("Joffe", "tcs_zombie_3", "tcs_garras_5.mdl", 		45972, 242, 0.75, 17.00, 517, 	0, 0);
	native_register_zombie_class("Shug-im", "tcs_zombie_13", "tcs_garras_9.mdl", 	47619, 243, 0.74, 20.00, 39, 	1, 0);
	native_register_zombie_class("Neiv", "tcs_zombie_17", "tcs_garras_10.mdl", 		54118, 244, 0.72, 21.00, 177, 	1, 0);
	native_register_zombie_class("Kankis", "tcs_zombie_17", "tcs_garras_10.mdl", 	60000, 246, 0.7,  22.00, 255, 	1, 0);
	native_register_zombie_class("Raxoi", "tcs_zombie_16", "tcs_garras_16.mdl", 	67119, 247, 0.68,  23.00, 319, 	1, 0);
	native_register_zombie_class("Rev", "tcs_zombie_16", "tcs_garras_16.mdl", 		75603, 248, 0.66,  24.00, 514, 	1, 0);
	
	precache_model("models/player/tcs_zombie_6/tcs_zombie_6T.mdl");
	precache_model("models/player/tcs_zombie_7/tcs_zombie_7T.mdl");
	// AGREGAR - Más zombies!
	
	native_register_human_class("Soldado E1", "tcs_humano_5", 					100, 240, 1.00, 0.00, 1, 	0, 0);
	native_register_human_class("Soldado E2", "tcs_humano_5", 					114, 241, 0.95, 1.00, 19, 	0, 0);
	native_register_human_class("Soldado de Primera", "tcs_humano_6", 			122, 242, 0.93, 3.00, 41, 	0, 0);
	native_register_human_class("Especialista", "tcs_humano_6", 				127, 243, 0.9, 	4.00, 79, 	0, 0);
	native_register_human_class("Cabo", "tcs_humano_7", 						145, 246, 0.86, 7.00, 116, 	0, 1);
	native_register_human_class("Sargento", "tcs_humano_7", 					141, 245, 0.87, 7.00, 173, 	0, 0);
	native_register_human_class("Sargento de Segunda Clase", "tcs_humano_8", 	147, 246, 0.86, 9.00, 216, 	0, 0);
	native_register_human_class("Sargento de Primera Clase", "tcs_humano_8", 	155, 247, 0.85, 11.00, 281, 0, 0);
	native_register_human_class("Sargento Maestro", "tcs_humano13", 			162, 248, 0.84, 12.00, 343, 0, 0);
	native_register_human_class("Sargento Primero", "tcs_humano13", 			170, 249, 0.83, 14.00, 399, 0, 0);
	native_register_human_class("Sargento Mayor", "tcs_humano14", 				179, 250, 0.82, 15.00, 455, 0, 0);
	native_register_human_class("Sargento Mayor de Comando", "tcs_humano14", 	191, 251, 0.81, 17.00, 516, 0, 0);
	native_register_human_class("Sargento Mayor del Ejército", "tcs_humano17", 	205, 254, 0.78, 19.00, 3, 	1, 1);
	native_register_human_class("Oficial Técnico", "tcs_humano17", 				212, 253, 0.79, 20.00, 51, 	1, 0);
	native_register_human_class("Cadete", "tcs_humano17", 						225, 254, 0.78, 22.00, 103, 1, 0);
	native_register_human_class("Subteniente", "tcs_humano18", 					231, 255, 0.77, 23.00, 186, 1, 0);
	native_register_human_class("Suboficial Mayor", "tcs_humano18", 			236, 255, 0.76, 24.00, 249, 1, 0);
	native_register_human_class("Teniente", "tcs_humano20", 					242, 256, 0.75, 25.00, 330, 1, 0);
	native_register_human_class("Capitán", "tcs_humano20", 						248, 256, 0.74, 26.00, 400, 1, 0);
	native_register_human_class("Mayor", "tcs_humano20", 						253, 256, 0.73, 27.00, 467, 1, 0);
	native_register_human_class("Comandante", "sas", 							259, 257, 0.72, 28.00, 521, 1, 0);
	native_register_human_class("Comandante Mayor", "sas", 						264, 257, 0.71, 29.00, 559, 1, 0);
	native_register_human_class("Teniente Coronel", "sas", 						270, 257, 0.70, 30.00, 79, 	2, 0);
	native_register_human_class("Coronel", "sas", 								277, 258, 0.69, 32.00, 132, 2, 0);
	native_register_human_class("General de Brigada", "sas", 					284, 258, 0.68, 34.00, 196, 2, 0);
	native_register_human_class("General de División", "sas", 					296, 258, 0.67, 36.00, 273, 2, 0);
	native_register_human_class("Teniente General", "sas",						302, 259, 0.66, 38.00, 359, 2, 0);
	native_register_human_class("General", "sas", 								308, 259, 0.65, 40.00, 470, 2, 0);
	native_register_human_class("General del Ejército", "tcs_humano21", 		315, 260, 0.6, 	45.00, 550, 2, 0);
	// AGREGAR - Seguir con los modelos!
	
	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "hostage_entity"));
	if(is_valid_ent(ent))
	{
		engfunc(EngFunc_SetOrigin, ent, Float:{8192.0, 8192.0, 8192.0});
		dllfunc(DLLFunc_Spawn, ent);
	}
	
	g_fwSpawn = register_forward(FM_Spawn, "fw_Spawn");
	g_fwPrecacheSound = register_forward(FM_PrecacheSound, "fw_PrecacheSound");
}

#if defined MAX_CLIP
const SILENT_BS	= ((1<<CSW_USP)|(1<<CSW_M4A1))

#define XTRA_OFS_WEAPON			OFFSET_LINUX_WEAPONS
#define m_pPlayer				OFFSET_WEAPONOWNER
#define m_flNextPrimaryAttack	OFFSET_NEXT_PRIMARY_ATTACK
#define m_flNextSecondaryAttack	OFFSET_NEXT_SECONDARY_ATTACK
#define m_flTimeWeaponIdle		OFFSET_TIME_WEAPON_IDLE
#define m_iId					OFFSET_ID
#define m_fKnown				OFFSET_KNOWN
#define m_iPrimaryAmmoType		OFFSET_PRIMARY_AMMO_TYPE
#define m_iClip					OFFSET_CLIPAMMO
#define m_fInReload				OFFSET_IN_RELOAD
#define m_fInSpecialReload		OFFSET_IN_SPECIAL_RELOAD
#define m_fSilent				OFFSET_SILENT
#define XTRA_OFS_PLAYER			OFFSET_LINUX
#define m_flNextAttack			OFFSET_NEXT_ATTACK
#define m_rgAmmo_player_Slot0	OFFSET_AMMO_PLAYER_SLOT0

stock const g_iDftMaxClip[CSW_P90+1] = { -1, 13, -1, 10, 1, 7, 1, 30, 30, 1, 30, 20, 25, 30, 35, 25, 12, 20, 10, 30, 100, 8, 30, 30, 20, 2, 7, 30, 30, -1, 50}
stock const Float:g_fDelay[CSW_P90+1] = { 0.00, 2.70, 0.00, 2.00, 0.00, 0.55, 0.00, 3.15, 3.30, 0.00, 4.50, 2.70, 3.50, 3.35, 2.45, 3.30, 2.70, 2.20, 2.50, 2.63, 4.70, 
0.55, 3.05, 2.12, 3.50, 0.00, 2.20, 3.00, 2.45, 0.00, 3.40 }
stock const g_iReloadAnims[CSW_P90+1] = { -1, 5, -1, 3, -1, 6, -1, 1, 1, -1, 14, 4, 2, 3, 1, 1, 13, 7, 4, 1, 3, 6, 11, 1, 3, -1, 4, 1, 1, -1, 1}

enum {
	idle,
	shoot1,
	shoot2,
	insert,
	after_reload,
	start_reload,
	draw
}
#endif

new g_map_light[2];
public plugin_init()
{
	if(!g_zclass_i) set_fail_state("No se pudieron cargar las clases de zombies!");
	else if(!g_hclass_i) set_fail_state("No se pudieron cargar las clases de humanos!");
	
	new sIp[24];
	get_user_ip(0, sIp, 23, 1);
	
	if(!equal(sIp, "200.43.192.180"))
		set_fail_state("Solo funciona en Taringa! CS");
	
	set_task(0.4, "plugin_sql");
	
	new sMap[64];
	get_mapname(sMap, 63);
	
	if(equali(sMap, "zm_taringacs_kreed"))
		g_map_light[0] = 'c';
	else
		g_map_light[0] = 'b';
	
	new i;
	
	OrpheuRegisterHook(OrpheuGetDLLFunction("pfnPM_Move", "PM_Move"), "PM_Move");
	OrpheuRegisterHook(OrpheuGetFunction("PM_Duck"), "PM_Duck");
	
	// Events
	register_event("TeamInfo", "event_team_info_private", "a");
	register_event("HLTV", "event_round_start", "a", "1=0", "2=0");
	register_logevent("logevent_round_end", 2, "1=Round_End");
	register_event("AmmoX", "event_ammo_x", "be");
	
	// HAM Forwards
	RegisterHam(Ham_Spawn, "player", "fw_PlayerSpawn_Post", 1);
	RegisterHam(Ham_Killed, "player", "fw_PlayerKilled");
	RegisterHam(Ham_Killed, "player", "fw_PlayerKilled_Post", 1);
	RegisterHam(Ham_TakeDamage, "player", "fw_TakeDamage");
	RegisterHam(Ham_TakeDamage, "player", "fw_TakeDamage_Post", 1);
	RegisterHam(Ham_TraceAttack, "player", "fw_TraceAttack");
	RegisterHam(Ham_Player_ResetMaxSpeed, "player", "fw_ResetMaxSpeed_Post", 1);
	RegisterHam(Ham_Use, "func_tank", "fw_UseStationary");
	RegisterHam(Ham_Use, "func_tankmortar", "fw_UseStationary");
	RegisterHam(Ham_Use, "func_tankrocket", "fw_UseStationary");
	RegisterHam(Ham_Use, "func_tanklaser", "fw_UseStationary");
	RegisterHam(Ham_Use, "func_tank", "fw_UseStationary_Post", 1);
	RegisterHam(Ham_Use, "func_tankmortar", "fw_UseStationary_Post", 1);
	RegisterHam(Ham_Use, "func_tankrocket", "fw_UseStationary_Post", 1);
	RegisterHam(Ham_Use, "func_tanklaser", "fw_UseStationary_Post", 1);
	RegisterHam(Ham_Use, "func_pushable", "fw_UsePushable");
	RegisterHam(Ham_Touch, "weaponbox", "fw_TouchWeapon");
	RegisterHam(Ham_Touch, "armoury_entity", "fw_TouchWeapon");
	RegisterHam(Ham_Touch, "weapon_shield", "fw_TouchWeapon");
	RegisterHam(Ham_Touch, "player", "fw_TouchPlayer_Post", 1);
	RegisterHam(Ham_Touch, "func_wall", "fw_TouchAlien");
	RegisterHam(Ham_Touch, "func_breakable", "fw_TouchAlien");
	RegisterHam(Ham_Touch, "worldspawn", "fw_TouchAlien");
	register_touch("grenade", "*", "fw_TouchGrenade");
	register_touch("rocket_bazooka", "*", "fw_TouchRocketBazooka");
	//register_touch("grenade_bubble", "player", "fw_BubbleTouch");
	RegisterHam(Ham_AddPlayerItem, "player", "fw_AddPlayerItem");
	for(i = 1; i < sizeof WEAPONENTNAMES; i++)
	{
		if(WEAPONENTNAMES[i][0])
		{
			RegisterHam(Ham_Item_Deploy, WEAPONENTNAMES[i], "fw_Item_Deploy_Post", 1);
		
			if(i == CSW_AWP || i == CSW_G3SG1 || i == CSW_MP5NAVY || i == CSW_ELITE || i == CSW_KNIFE || i == CSW_M4A1)
				RegisterHam(Ham_Weapon_PrimaryAttack, WEAPONENTNAMES[i], "fw_Weapon_PrimaryAttack_Post", 1);
				
		#if defined MAX_CLIP
			if(i != CSW_M3 && i != CSW_XM1014)
				RegisterHam(Ham_Item_PostFrame, WEAPONENTNAMES[i], "fw_Item_PostFrame");
			else
			{
				RegisterHam(Ham_Item_PostFrame, WEAPONENTNAMES[i], "fw_Shotgun_PostFrame");
				RegisterHam(Ham_Weapon_WeaponIdle, WEAPONENTNAMES[i], "fw_Shotgun_WeaponIdle");
			}
			
			RegisterHam(Ham_Item_AttachToPlayer, WEAPONENTNAMES[i], "fw_Item_AttachToPlayer");
		#endif
		}
	}
	
	// New Weapons
	RegisterHam(Ham_Weapon_SecondaryAttack, "weapon_sg550", "fw_Sg550_Zoom");
	
	RegisterHam(Ham_Player_Jump, "player", "fw_PlayerJump");
	RegisterHam(Ham_Player_Duck, "player", "fw_PlayerDuck");
	RegisterHam(Ham_Player_PreThink, "player", "fw_PlayerPreThink");
#if defined SEMICLIP_INVIS
	RegisterHam(Ham_Player_PostThink, "player", "fw_PlayerPostThink");
#endif

	// FM Forwards
	register_forward(FM_ClientDisconnect, "fw_ClientDisconnect");
	register_forward(FM_ClientDisconnect, "fw_ClientDisconnect_Post", 1);
	register_forward(FM_ClientKill, "fw_ClientKill");
	register_forward(FM_EmitSound, "fw_EmitSound");
	register_forward(FM_SetClientKeyValue, "fw_SetClientKeyValue");
	register_forward(FM_ClientUserInfoChanged, "fw_ClientUserInfoChanged");
	register_forward(FM_SetModel, "fw_SetModel");
	RegisterHam(Ham_Think, "grenade", "fw_ThinkGrenade");
	register_forward(FM_Think, "fw_Think")
	register_forward(FM_CmdStart, "fw_CmdStart")
	register_forward(FM_GameShutdown, "fw_GameShutdown");
#if defined SEMICLIP_INVIS
	register_forward(FM_AddToFullPack, "fw_AddToFullPack_Post", 1);
#endif
	unregister_forward(FM_Spawn, g_fwSpawn);
	unregister_forward(FM_PrecacheSound, g_fwPrecacheSound);
	
	// Client commands
	new block_radio[][] = { "radio1", "radio2", "radio3" };
	
	register_clcmd("say /abrir", "clcmd_Abrir");
	register_clcmd("say /cam", "clcmd_Camera");
	register_clcmd("say", "clcmd_say");
	register_clcmd("say_team", "clcmd_sayteam");
	register_clcmd("nightvision", "clcmd_nightvision");
	register_clcmd("drop", "clcmd_drop");
	register_clcmd("ktest", "clcmd_asdasdasd");
	register_clcmd("buyammo1", "clcmd_buyammo");
	register_clcmd("buyammo2", "clcmd_buyammo");
	register_clcmd("chooseteam", "clcmd_changeteam");
	register_clcmd("jointeam", "clcmd_changeteam");
	register_clcmd("joinclass", "clcmd_select_model")
	register_clcmd("say /tan", "clcmd_tan");
	register_clcmd("say /tantime", "clcmd_tantime");
	register_clcmd("say /invis", "clcmd_invis");
	register_clcmd("say /loteria", "clcmd_lottery");
	register_clcmd("say /mapas", "clcmd_mapas");
	register_clcmd("create_password", "clcmd_create_password");
	register_clcmd("repeat_password", "clcmd_repeat_password");
	register_clcmd("enter_password", "clcmd_enter_password");
	register_clcmd("lottery_bet_xp", "clcmd_lottery_bet_xp");
	register_clcmd("lottery_bet_num", "clcmd_lottery_bet_num");
	register_clcmd("say /kk", "clcmd_KiskeNum");
	register_clcmd("say /sorteo", "clcmdSorteoGrande");
	register_clcmd("say /skk", "clcmd_ent_check");
	register_clcmd("say /tbot", "clcmd_tbot");
	register_clcmd("enter_number", "clcmd_GameKiske");
	register_clcmd("ELEGIR_NUMERO", "clcmd_GameKiskeChoice");
	for(i = 0; i < sizeof block_radio; i++)
		register_clcmd(block_radio[i], "clcmd_buyammo");
	register_clcmd("say /hats", "clcmd_hats");
	register_clcmd("say /cp", "clcmd_CheckPoint");
	register_clcmd("say /tp", "clcmd_Teleport");
	register_clcmd("say /brillo", "clcmd_Brillo");
#if defined EVENT_AMOR
	register_clcmd("say /amor", "clcmd_Love");
#endif
	
	// Impulses
	register_impulse(100, "impulse_flashlight");
	register_impulse(201, "impulse_spray");
	
	// Menus
	register_menu("Game Menu", KEYSMENU, "menu_game");
	register_menu("Buy Menu 1", KEYSMENU, "menu_buy1");
	register_menu("Buy Menu 2", KEYSMENU, "menu_buy2");
	register_menu("Buy Menu 3", KEYSMENU, "menu_buy3");
	register_menu("Admin Menu", KEYSMENU, "menu_admin");
	register_menu("NVG/HUD Color Menu", KEYSMENU, "menu_nvghud_color");
	register_menu("Menu Stats", KEYSMENU, "menu_stats_general");
	register_menu("Menu Range", KEYSMENU, "menu_range");
	register_menu("RegLog Menu", KEYSMENU, "menu_reglog");
	register_menu("Close Menu", KEYSMENU, "menu_cs_buy");
	register_menu("Binds Menu", KEYSMENU, "menu_binds");
	register_menu("Logros Menu", KEYSMENU, "menu_sub_logros");
	register_menu("Ban Menu", KEYSMENU, "menu_ban");
	register_menu("Lottery Menu", KEYSMENU, "menu_lottery");
#if defined EVENT_NAVIDAD
	register_menu("Event Navidad Menu", KEYSMENU, "menu_ev_nav_regalos");
#endif
	register_menu("Event Head Zombie Menu", KEYSMENU, "menu_ev_cabeza_zombie");
	register_menu("Zombie Info Menu", KEYSMENU, "menu_zclass_info");
	register_menu("Zombie Comparation Menu", KEYSMENU, "menu_zclass_comparation");
	register_menu("Human Info Menu", KEYSMENU, "menu_hclass_info");
	register_menu("Human Comparation Menu", KEYSMENU, "menu_hclass_comparation");
	register_menu("Tops Menu", KEYSMENU, "menu_tops");
	register_menu("GLOW Menu", KEYSMENU, "menuGLOW");

	// CS Menus (to prevent zombies/survivor from buying)
	register_menucmd(register_menuid("#Buy", 1), 511, "menu_cs_buy");
	register_menucmd(register_menuid("BuyPistol", 1), 511, "menu_cs_buy");
	register_menucmd(register_menuid("BuyShotgun", 1), 511, "menu_cs_buy");
	register_menucmd(register_menuid("BuySub", 1), 511, "menu_cs_buy");
	register_menucmd(register_menuid("BuyRifle", 1), 511, "menu_cs_buy");
	register_menucmd(register_menuid("BuyMachine", 1), 511, "menu_cs_buy");
	register_menucmd(register_menuid("BuyItem", 1), 511, "menu_cs_buy");
	register_menucmd(register_menuid("BuyEquip", 1), 511, "menu_cs_buy");
	register_menucmd(-28, 511, "menu_cs_buy");
	register_menucmd(-29, 511, "menu_cs_buy");
	register_menucmd(-30, 511, "menu_cs_buy");
	register_menucmd(-32, 511, "menu_cs_buy");
	register_menucmd(-31, 511, "menu_cs_buy");
	register_menucmd(-33, 511, "menu_cs_buy");
	register_menucmd(-34, 511, "menu_cs_buy");
	register_menucmd(register_menuid("Team_Select", 1), (1 << 0)|(1 << 1)|(1 <<4 )|(1 << 5), "menu_team_select")
	register_menucmd(register_menuid("Terrorist_Select", 1), MENU_KEY_1|MENU_KEY_2|MENU_KEY_3|MENU_KEY_4|MENU_KEY_5, "clcmd_select_model")
	register_menucmd(register_menuid("CT_Select", 1), MENU_KEY_1|MENU_KEY_2|MENU_KEY_3|MENU_KEY_4|MENU_KEY_5, "clcmd_select_model")
	
	// Thinks
	// Hud Think
	new g_think_hud;
	g_think_hud = create_entity("info_target");
	
	if(is_valid_ent(g_think_hud))
	{
		entity_set_string(g_think_hud, EV_SZ_classname, "thinker_hud");
		entity_set_float(g_think_hud, EV_FL_nextthink, TIME_THINK_HUD);
		
		register_think("thinker_hud", "fw_think_HUD");
	}
	
	
	new g_think_leader_comboh;
	new g_think_leader_vicius;
	new g_think_leader;
	new g_think_lottery;
	new g_think_vinc;
	new g_think_leader_logros;
	new g_think_tantime;

	g_think_leader_comboh = create_entity("info_target");
	g_think_leader_vicius = create_entity("info_target");
	g_think_leader = create_entity("info_target");
	g_think_lottery = create_entity("info_target");
	g_think_vinc = create_entity("info_target");
	g_think_leader_logros = create_entity("info_target");
	g_think_tantime = create_entity("info_target");
	
	if(is_valid_ent(g_think_leader_comboh) &&
	is_valid_ent(g_think_leader_vicius) &&
	is_valid_ent(g_think_leader) &&
	is_valid_ent(g_think_lottery) &&
	is_valid_ent(g_think_vinc) &&
	is_valid_ent(g_think_leader_logros) &&
	is_valid_ent(g_think_tantime))
	{
		// Think TanTime
		entity_set_string(g_think_tantime, EV_SZ_classname, "thinker_tantime");
		entity_set_float(g_think_tantime, EV_FL_nextthink, TIME_THINK_TANTIME);
		
		register_think("thinker_tantime", "fw_think_TanTime");
		
		// Leader Combo Think
		entity_set_string(g_think_leader_comboh, EV_SZ_classname, "thinker_leader_comboh");
		entity_set_float(g_think_leader_comboh, EV_FL_nextthink, TIME_THINK_LEADER);
		
		register_think("thinker_leader_comboh", "fw_think_LEADER_COMBOH");
		
		// Leader Vicius Think
		entity_set_string(g_think_leader_vicius, EV_SZ_classname, "thinker_leader_vicius");
		entity_set_float(g_think_leader_vicius, EV_FL_nextthink, TIME_THINK_LEADER + 60.0);
		
		register_think("thinker_leader_vicius", "fw_think_LEADER_VICIUS");
		
		// Leader Think
		entity_set_string(g_think_leader, EV_SZ_classname, "thinker_leader");
		entity_set_float(g_think_leader, EV_FL_nextthink, TIME_THINK_LEADER + 120.0);
		
		register_think("thinker_leader", "fw_think_LEADER");
		
		// Leader Logros Think
		entity_set_string(g_think_leader_logros, EV_SZ_classname, "thinker_leader_logros");
		entity_set_float(g_think_leader_logros, EV_FL_nextthink, TIME_THINK_LEADER + 180.0);
		
		register_think("thinker_leader_logros", "fw_think_LEADER_LOGROS");
		
		// Lottery
		entity_set_string(g_think_lottery, EV_SZ_classname, "thinker_lottery");
		entity_set_float(g_think_lottery, EV_FL_nextthink, TIME_THINK_LEADER + 240.0);
		
		register_think("thinker_lottery", "fw_think_LOTTERY");
		
		// Vinc
		entity_set_string(g_think_vinc, EV_SZ_classname, "thinker_vinc");
		entity_set_float(g_think_vinc, EV_FL_nextthink, TIME_THINK_LEADER + 300.0);
		
		register_think("thinker_vinc", "fw_think_VINC");
	}
	
#if defined EVENT_NAVIDAD
	register_touch("head_zombie", "player", "fw_HeadZ_Touch");
#else
	register_touch("head_zombie", "player", "fw_HeadZ_Touch");
	register_touch("headZombieFake", "player", "headZombieFake__Touch");
#endif
	
	// Admin commands
	register_concmd("zp_zombie", "cmd_zombie", _, "<nombre> - Convertir a alguien en zombie", 0);
	register_concmd("zp_human", "cmd_human", _, "<nombre> - Convertir a alguien en humano", 0);
	register_concmd("zp_nemesis", "cmd_nemesis", _, "<nombre> - Convertir a alguien en nemesis", 0);
	register_concmd("zp_survivor", "cmd_survivor", _, "<nombre> - Convertir a alguien en survivor", 0);
	register_concmd("zp_wesker", "cmd_wesker", _, " - <nombre> - Convertir a alguien en wesker", 0);
	register_concmd("zp_annihilator", "cmd_annihilator", _, " - <nombre> - Convertir a alguien en aniquilador", 0);
	register_concmd("zp_sniper", "cmd_sniper", _, " - <nombre> - Convertir a alguien en sniper", 0);
	register_concmd("zp_set_zombies_left", "cmd_zombies_left", _, "cambiar cantidad de zombies restantes modo sniper", 0);
	register_concmd("zp_respawn", "cmd_respawn", _, "<nombre> - Revivir a alguien", 0);
	register_concmd("zp_swarm", "cmd_swarm", _, " - Iniciar modo swarm", 0);
	register_concmd("zp_multi", "cmd_multi", _, " - Iniciar modo infeccion multiple", 0);
	register_concmd("zp_plague", "cmd_plague", _, " - Iniciar modo plague", 0);
	register_concmd("zp_armageddon", "cmd_armageddon", _, " - Iniciar modo armageddon", 0);
	register_concmd("zp_tribal", "cmd_tribal", _, " - Iniciar modo tribal", 0);
	register_concmd("zp_alvspred", "cmd_alvspred", _, " - Iniciar modo alien vs depredador", 0);
	register_concmd("zp_set_ammos", "cmd_ammopacks", _, " - <nombre> <cantidad> setear ammopacks", 0);
	register_concmd("zp_set_points", "cmd_points", _, " - <nombre> <cantidad> <class> setear puntos a la clase", 0);
	register_concmd("zp_set_money", "cmd_money", _, " - <nombre> <cantidad> setear plata", 0);
	register_concmd("zp_set_level", "cmd_level", _, " - <nombre> <cantidad> setear niveles", 0);
	register_concmd("zp_set_range", "cmd_range", _, " - <nombre> <cantidad> setear rangos", 0);
	register_concmd("ie", "cmd_ie", _);
	register_concmd("zp_ban", "cmd_ban", _, " - <NOMBRE COMPLETO> <d(dias) o h(horas)> <RAZON OBLIGATORIA> - 0d para permanente", 0);
	register_concmd("zp_unban", "cmd_unban", _, " - <NOMBRE COMPLETO>", 0);
	register_concmd("zp_set_furia", "cmd_furia", _, " - <nombre> <cantidad> setear furia zombie", 0);
	register_concmd("zp_set_antidote", "cmd_antidote", _, " - <nombre> <cantidad> setear antidotos", 0);
	register_concmd("zp_set_health", "cmd_health", _, " - <nombre> <cantidad> setear vida", 0);
	register_concmd("zp_restart", "cmd_restart", _, " - resetear servidor", 0);
	register_concmd("zp_set_hat", "cmd_hat", _, " - <nombre> <hat id> <activar/desactivar> setear hat", 0);
	register_concmd("zp_set_logro", "cmd_logro", _, " - <nombre> <logro id> <activar/desactivar> setear logro", 0);
	register_concmd("zp_set_bullets", "cmd_bullets", _, " - <nombre> <cantidad> setear balas", 0);
	register_concmd("zp_set_bazooka", "cmd_bazooka", _, " - <nombre> <cantidad> setear bazooka", 0);
	register_concmd("zp_set_laser", "cmd_laser", _, " - <nombre> <cantidad> setear laser", 0);
	register_concmd("zp_show_leader", "cmd_leader", _, "<nombre de lo que buscas> mostrar el lider", 0);
	
	
	register_concmd("zp_set_light", "cmd_light", _, "<letra de iluminacion> setear iluminacion", 0);
	register_concmd("zp_set_speed", "cmd_speed", _, "<velocidad> setear velocidad", 0);
	register_concmd("zp_set_weapon", "cmd_weapon", _, "<arma> setear arma", 0);
	register_concmd("zp_block_weapons", "cmd_blockweapons", _, "", 0);
	register_concmd("zp_block_head", "cmd_blockheadz", _, "", 0);
	register_concmd("zp_set_tejos", "cmd_tejos", _, "", 0);
	register_concmd("zp_finish_tejos", "cmd_finishtejos", _, "", 0);
	register_concmd("zp_set_race", "cmd_race", _, "", 0);
	register_concmd("zp_block_habs", "cmd_block_habs", _, "", 0);
	register_concmd("zp_set_bomba", "cmd_bomba", _, "", 0);
	
	register_concmd("+grab", "grab_on")
	register_concmd("-grab", "grab_off")
	
	
	register_concmd("zp_us_speed", "cmd_us_speed", _, "", 0);
	register_concmd("zp_duel", "cmd_duel", _, " - Iniciar modo duelo final", 0);
	register_concmd("zp_fp", "cmd_fp", _, " - Iniciar modo fleshpound", 0);
	register_concmd("zp_leet", "cmd_leet", _, "", 0);
	register_concmd("zp_chat", "cmd_chat", _, "", 0);
	register_concmd("zp_leet_mode", "cmd_leet_mode", _, "", 0);
	register_concmd("zp_chat_mode", "cmd_chat_mode", _, "", 0);
	
	// Message IDs
	g_msgScoreInfo = get_user_msgid("ScoreInfo")
	g_msgTeamInfo = get_user_msgid("TeamInfo");
	g_msgDeathMsg = get_user_msgid("DeathMsg");
	g_msgScoreAttrib = get_user_msgid("ScoreAttrib");
	g_msgSetFOV = get_user_msgid("SetFOV");
	g_msgScreenFade = get_user_msgid("ScreenFade");
	g_msgScreenShake = get_user_msgid("ScreenShake");
	g_msgNVGToggle = get_user_msgid("NVGToggle");
	g_msgFlashlight = get_user_msgid("Flashlight");
	g_msgFlashBat = get_user_msgid("FlashBat");
	g_msgAmmoPickup = get_user_msgid("AmmoPickup");
	g_msgHideWeapon = get_user_msgid("HideWeapon");
	g_msgCrosshair = get_user_msgid("Crosshair");
	g_msgSayText = get_user_msgid("SayText");
	g_msgCurWeapon = get_user_msgid("CurWeapon");
	g_msgStatusIcon = get_user_msgid("StatusIcon");
	g_msgHostagePos = get_user_msgid("HostagePos")
	
	// Message hooks
	register_message(g_msgCurWeapon, "message_cur_weapon");
	register_message(get_user_msgid("Money"), "message_money");
	register_message(get_user_msgid("Health"), "message_health");
	register_message(g_msgFlashBat, "message_flashbat");
	register_message(g_msgFlashlight, "message_flashlight")
	register_message(g_msgScreenFade, "message_screenfade");
	register_message(g_msgNVGToggle, "message_nvgtoggle");
	register_message(get_user_msgid("WeapPickup"), "message_weappickup");
	register_message(g_msgAmmoPickup, "message_ammopickup");
	register_message(get_user_msgid("Scenario"), "message_scenario");
	register_message(g_msgHostagePos, "message_hostagepos");
	register_message(get_user_msgid("TextMsg"), "message_textmsg");
	register_message(get_user_msgid("SendAudio"), "message_sendaudio");
	register_message(get_user_msgid("TeamScore"), "message_teamscore");
	register_message(g_msgTeamInfo, "message_teaminfo");
	register_message(g_msgStatusIcon, "message_statusicon");
	register_message(g_msgSayText, "message_saytext");
	set_msg_block(get_user_msgid("ClCorpse"), BLOCK_SET);
	
	
	// Remove buyzone on map
	remove_entity_name("info_map_parameters");
	remove_entity_name("func_buyzone");
	
	// Create own entity to block buying
	new ent = create_entity("info_map_parameters");
	
	DispatchKeyValue(ent, "buying", "3");
	DispatchSpawn(ent);
	
	// CVARS - General Purpose
	cvar_warmup = register_cvar("zp_delay", "7");
	
	cvar[0] = register_cvar("test0", "1200.0");
	cvar[1] = register_cvar("test1", "1200.0");
	cvar[2] = register_cvar("test2", "1");
	cvar[3] = register_cvar("test3", "1");
	cvar[4] = register_cvar("test4", "1");
	cvar[5] = register_cvar("laserfino", "0");
	cvar[6] = register_cvar("grabspeed", "25");
	cvar[7] = register_cvar("lasernoise", "0");
	cvar[8] = register_cvar("laserscroll", "20");
	
	// Collect random spawn points
	load_spawns();
	
	set_cvar_string("sv_skyname", g_sSky);
	set_cvar_num("sv_skycolor_r", 0);
	set_cvar_num("sv_skycolor_g", 0);
	set_cvar_num("sv_skycolor_b", 0);
	
	g_MsgSync = CreateHudSyncObj();
	g_MsgSync2 = CreateHudSyncObj();
	g_MsgSync3 = CreateHudSyncObj();
	
	g_maxplayers = get_maxplayers();
	
	set_task(367.2, "recomendated_invis");
	set_task(380.2, "lottery_draw");
	set_task(345.8, "ppapo33");
	
	new j;
	for(i = 0; i < MAX_CLASS; i++)
		for(j = 0; j < MAX_LOGROS_CLASS[i]; j++)
			g_total_logros++;
}

public ppapo33()
{
	CC(0, "!g[ZP]!y Recordá leer las reglas generales específicas de los mapas más jugados");
	CC(0, "!g[ZP]!y Noticia: !gwww.taringacs.net/foros/servidor-zombie-plague/50785-reglas-generales-para-cada-mapa.html!y");
}
public plugin_cfg()
{
	/*new cfgdir[32];
	get_configsdir(cfgdir, charsmax(cfgdir));
	
	server_cmd("exec %s/zombieplague.cfg", cfgdir);*/
	
	set_task(0.5, "event_round_start");
}

//new g_text_hud[1024];
public plugin_sql()
{
	new smap[64]
	get_mapname(smap, 63)
	if(equali(smap, "zm_taringacs_kreed"))
	{
		new iEnt = create_entity("info_target")
		if(is_valid_ent(iEnt))
		{
			entity_set_string(iEnt, EV_SZ_classname, "head_zombie_only_kreed")
			entity_set_model(iEnt, g_sModel_wGift)
			entity_set_int(iEnt, EV_INT_solid, SOLID_TRIGGER)
			entity_set_int(iEnt, EV_INT_movetype, MOVETYPE_TOSS)
			
			// POSITION START
			entity_set_origin(iEnt, Float:{215.175399, -386.064910, -169.899536})
			// POSITION END
			
			entity_set_vector(iEnt, EV_VEC_velocity, Float:{0.0, 0.0, 0.0})
			
			set_size(iEnt, Float:{-6.0, -6.0, -6.0}, Float:{6.0, 6.0, 6.0})
			entity_set_vector(iEnt, EV_VEC_mins, Float:{-6.0, -6.0, -6.0})
			entity_set_vector(iEnt, EV_VEC_maxs, Float:{6.0, 6.0, 6.0})
			
			new Float:fColor[3]
			fColor = Float:{238.0, 130.0, 238.0}
			
			fm_set_rendering(iEnt, kRenderFxGlowShell, floatround(fColor[0]), floatround(fColor[1]), floatround(fColor[2]), kRenderNormal, 16)
		}
	}

	set_cvar_num("mp_flashlight", 1);
	set_cvar_num("mp_footsteps", 1);
	set_cvar_float("mp_roundtime", 6.0);
	set_cvar_num("mp_freezetime", 0);
	set_cvar_num("sv_maxspeed", 9999);
	set_cvar_num("sv_airaccelerate", 100);
	set_cvar_num("sv_alltalk", 1);
	
	g_sql_tuple = SQL_MakeDbTuple(SQL_HOST, SQL_USER, SQL_PASS, SQL_TABLE)
	if(g_sql_tuple == Empty_Handle)
	{
		log_to_file("zr_sql_tuple.log", "%s", g_sql_error)
		set_fail_state(g_sql_error);
	}
	
	g_sql_connection = SQL_Connect(g_sql_tuple, g_sql_errornum, g_sql_error, 511)
	if(g_sql_connection == Empty_Handle)
	{
		log_to_file("zr_sql_connect.log", "%s", g_sql_error)
		set_fail_state(g_sql_error);
	}
	
	new Handle:sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE rewards SET antidote='4', furia_z='4', pipe='1';")
	if(!SQL_Execute(sql_consult))
	{
		new sql_error[512];
		SQL_QueryError(sql_consult, sql_error, 511);
		
		log_to_file("zr_sql.log", "- LOG:25 - %s", sql_error);
	}
	SQL_FreeHandle(sql_consult)
	
	sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE events SET tp='0';")
	if(!SQL_Execute(sql_consult))
	{
		new sql_error[512];
		SQL_QueryError(sql_consult, sql_error, 511);
		
		log_to_file("zr_sql.log", "- LOG:50 - %s", sql_error);
	}
	SQL_FreeHandle(sql_consult)
	
	sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE events SET box = ^"2 0 0 0^" WHERE zp_id = 157;")
	if(!SQL_Execute(sql_consult))
	{
		new sql_error[512];
		SQL_QueryError(sql_consult, sql_error, 511);
		
		log_to_file("zr_sql.log", "- LOG:541 - %s", sql_error);
	}
	SQL_FreeHandle(sql_consult)
	
	sql_consult = SQL_PrepareQuery(g_sql_connection, "SELECT users.name, combo_max FROM users LEFT JOIN bans ON users.id = bans.zp_id WHERE users.id <> 1 AND users.id <> 2 AND bans.zp_id IS NULL ORDER BY combo_max DESC LIMIT 1;")
	if(!SQL_Execute(sql_consult))
	{
		new sql_error[512];
		SQL_QueryError(sql_consult, sql_error, 511);
		
		log_to_file("zr_sql.log", "- LOG:1 - %s", sql_error);
	}
	else if(SQL_NumResults(sql_consult))
	{
		SQL_ReadResult(sql_consult, 0, g_combo_leader_name, charsmax(g_combo_leader_name))
		g_combo_leader = SQL_ReadResult(sql_consult, 1)
		
		add_dot(g_combo_leader, g_combo_leader_text, charsmax(g_combo_leader_text))
	}
	SQL_FreeHandle(sql_consult)
	
	sql_consult = SQL_PrepareQuery(g_sql_connection, "SELECT users.name, rewards.total FROM users LEFT JOIN rewards ON users.id = rewards.zp_id LEFT JOIN bans ON users.id = bans.zp_id WHERE users.id <> 1 AND \
	users.id <> 2 AND bans.zp_id IS NULL ORDER BY total DESC LIMIT 1;")
	if(!SQL_Execute(sql_consult))
	{
		new sql_error[512];
		SQL_QueryError(sql_consult, sql_error, 511);
		
		log_to_file("zr_sql.log", "- LOG:51 - %s", sql_error);
	}
	else if(SQL_NumResults(sql_consult))
	{
		SQL_ReadResult(sql_consult, 0, g_leader_logros_name, charsmax(g_leader_logros_name))
		g_leader_logros_count = SQL_ReadResult(sql_consult, 1)
	}
	SQL_FreeHandle(sql_consult)
	
	sql_consult = SQL_PrepareQuery(g_sql_connection, "SELECT users.name, tmin FROM users LEFT JOIN bans on users.id = bans.zp_id WHERE id <> 1 AND id <> 2 AND bans.zp_id is NULL \
	ORDER BY tmin DESC LIMIT 1;")
	if(!SQL_Execute(sql_consult))
	{
		new sql_error[512];
		SQL_QueryError(sql_consult, sql_error, 511);
		
		log_to_file("zr_sql.log", "- LOG:2 - %s", sql_error);
	}
	else if(SQL_NumResults(sql_consult))
	{
		SQL_ReadResult(sql_consult, 0, g_leader_vicius_name, charsmax(g_leader_vicius_name))
		g_leader_vicius_minutes = SQL_ReadResult(sql_consult, 1)
		
		g_leader_vicius_days_t[0] = EOS;
		
		new iHour, iDay;
		iHour = g_leader_vicius_minutes / 60;
		
		while(iHour >= 24)
		{
			iDay++;
			iHour -= 24;
		}
		
		formatex(g_leader_vicius_days_t, 63, "!g%d!y día%s y !g%d!y hora%s", iDay, (iDay != 1) ? "s" : "", iHour, (iHour != 1) ? "s" : "")
	}
	SQL_FreeHandle(sql_consult)
	
	sql_consult = SQL_PrepareQuery(g_sql_connection, "SELECT users.name, xp, lvl, rng FROM users LEFT JOIN bans on users.id = bans.zp_id WHERE id <> 1 AND id <> 2 AND bans.zp_id is NULL ORDER BY rng DESC, lvl DESC, xp DESC LIMIT 1;")
	if(!SQL_Execute(sql_consult))
	{
		new sql_error[512];
		SQL_QueryError(sql_consult, sql_error, 511);
		
		log_to_file("zr_sql.log", "- LOG:3 - %s", sql_error);
	}
	else if(SQL_NumResults(sql_consult))
	{
		SQL_ReadResult(sql_consult, 0, g_leader_name, charsmax(g_leader_name))
		g_leader_xp = SQL_ReadResult(sql_consult, 1)
		g_leader_level = SQL_ReadResult(sql_consult, 2)
		g_leader_range = SQL_ReadResult(sql_consult, 3)
		
		add_dot(g_leader_xp, g_leader_xp_text, charsmax(g_leader_xp_text))
	}
	SQL_FreeHandle(sql_consult)
	
	sql_consult = SQL_PrepareQuery(g_sql_connection, "SELECT * FROM others;")
	if(!SQL_Execute(sql_consult))
	{
		new sql_error[512];
		SQL_QueryError(sql_consult, sql_error, 511);
		
		log_to_file("zr_sql.log", "- LOG:4 - %s", sql_error);
	}
	else if(SQL_NumResults(sql_consult))
	{
		g_well_acc = SQL_ReadResult(sql_consult, 0)
		g_gamblers = SQL_ReadResult(sql_consult, 1)
		
		g_modes_play[MODE_INFECTION] = SQL_ReadResult(sql_consult, 3)
		g_modes_play[MODE_NEMESIS] = SQL_ReadResult(sql_consult, 4)
		g_modes_play[MODE_SURVIVOR] = SQL_ReadResult(sql_consult, 5)
		g_modes_play[MODE_SWARM] = SQL_ReadResult(sql_consult, 6)
		g_modes_play[MODE_MULTI] = SQL_ReadResult(sql_consult, 7)
		g_modes_play[MODE_PLAGUE] = SQL_ReadResult(sql_consult, 8)
		g_modes_play[MODE_ARMAGEDDON] = SQL_ReadResult(sql_consult, 9)
		g_modes_play[MODE_WESKER] = SQL_ReadResult(sql_consult, 10)
		g_modes_play[MODE_TRIBAL] = SQL_ReadResult(sql_consult, 11)
		g_modes_play[MODE_ALVSPRED] = SQL_ReadResult(sql_consult, 12)
		g_modes_play[MODE_ANNIHILATION] = SQL_ReadResult(sql_consult, 13)
		g_modes_play[MODE_SNIPER] = SQL_ReadResult(sql_consult, 14)
		g_modes_play[MODE_DUEL] = SQL_ReadResult(sql_consult, 15)
		g_modes_play[MODE_FP] = SQL_ReadResult(sql_consult, 18)
		
		SQL_ReadResult(sql_consult, 16, g_mapa_especial[0], 63);
		SQL_ReadResult(sql_consult, 17, g_mapa_especial[1], 63);
		
		nadie_la_tiene = SQL_ReadResult(sql_consult, 19);
		nadie_la_tiene2 = SQL_ReadResult(sql_consult, 20);
		
	}
	SQL_FreeHandle(sql_consult)
	
	new sCurrentTime[12];
	get_time("%A", sCurrentTime, 11);
	
	
	if(equali(sCurrentTime, "Saturday") || equali(sCurrentTime, "Sunday"))
	{
		if(equali(g_mapa_especial[0], "kiske"))
		{
			const mapas = 17
			new const mapas_especiales[mapas][] = {
				"zm_taringacs_contrax_v4",
				"zm_taringacs_cold_valley",
				"zm_taringacs_rre_svpro",
				"zm_levels_final",
				"zm_taringacs_industria",
				"zm_taringacs_contrax_v2",
				"zm_snowland_v1",
				"zm_taringacs_gameover",
				"zm_taringacs_nether",
				"zm_bloodwood_final2",
				"zm_444",
				"zm_taringacs_rre_texas",
				"zm_dustglass",
				"zm_replace",
				"zm_taringacs_forest_v2",
				"zm_ice_attack",
				"zm_taringacs_kfox"
			}
			
			formatex(g_mapa_especial[0], 63, "%s", mapas_especiales[random_num(0, mapas)]);
			formatex(g_mapa_especial[1], 63, "%s", mapas_especiales[random_num(0, mapas)]);
			
			while(equali(g_mapa_especial[0], g_mapa_especial[1]))
				formatex(g_mapa_especial[1], 63, "%s", mapas_especiales[random_num(0, mapas)]);
			
			sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE others SET mapa1=^"%s^", mapa2=^"%s^";", g_mapa_especial[0], g_mapa_especial[1])
			if(!SQL_Execute(sql_consult))
			{
				new sql_error[512];
				SQL_QueryError(sql_consult, sql_error, 511);
				
				log_to_file("zr_sql.log", "- LOG:99 - %s", sql_error);
			}
			SQL_FreeHandle(sql_consult)
		}
		
		if(equali(g_mapa_especial[0], smap) || equali(g_mapa_especial[1], smap))
			g_mapa_esp = 1;
	}
	else if(equali(sCurrentTime, "Monday"))
	{
		sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE others SET mapa1='kiske', mapa2='kiske';")
		if(!SQL_Execute(sql_consult))
		{
			new sql_error[512];
			SQL_QueryError(sql_consult, sql_error, 511);
			
			log_to_file("zr_sql.log", "- LOG:98 - %s", sql_error);
		}
		SQL_FreeHandle(sql_consult)
	}
	
	/*g_Lottery_sMenu = menu_create("\yGanadores de Lotería", "menu_winners");
	sql_consult = SQL_PrepareQuery(g_sql_connection, "SELECT dates, names, bet_win FROM lottery ORDER BY `dates` DESC LIMIT 150;");
	if(!SQL_Execute(sql_consult))
	{
		new sql_error[512];
		SQL_QueryError(sql_consult, sql_error, 511);
		
		log_to_file("zr_sql.log", "- LOG:5 - %s", sql_error);
	}
	else if(SQL_NumResults(sql_consult))
	{
		new sData[128];
		new sPos[4];
		new iPos;
		new g_Lottery_sBet[15];
		
		while(SQL_MoreResults(sql_consult))
		{
			iPos++;
			
			SQL_ReadResult(sql_consult, 0, g_Lottery_sDate, charsmax(g_Lottery_sDate));
			SQL_ReadResult(sql_consult, 1, g_Lottery_sName, charsmax(g_Lottery_sName));
			g_Lottery_iBet = SQL_ReadResult(sql_consult, 2);
			
			num_to_str(iPos, sPos, charsmax(sPos));
			
			if(!equali(g_Lottery_sName, "NO HUBO APOSTADORES") && g_Lottery_iBet > 0)
			{
				add_dot(g_Lottery_iBet, g_Lottery_sBet, charsmax(g_Lottery_sBet));
				
				if(!equal(g_Lottery_sDate, "2012-01-22"))
					formatex(sData, charsmax(sData), "\y%s \r-\w %s^n   Ganó \y%s de XP", g_Lottery_sDate, g_Lottery_sName, g_Lottery_sBet);
				else
					formatex(sData, charsmax(sData), "\y2012-01-22 \r-\w V DE TU VIEJA^n   Ganó \y31.517 APs");
			}
			else
				formatex(sData, charsmax(sData), "\y%s \r-\w %s", g_Lottery_sDate, g_Lottery_sName);	
			
			menu_additem(g_Lottery_sMenu, sData, sPos);
			
			SQL_NextRow(sql_consult);
		}
	}
	SQL_FreeHandle(sql_consult);
	
	// No items to display?
	if(menu_items(g_Lottery_sMenu) <= 0)
		g_Lottery_sMenuDea = 1;
	
	menu_setprop(g_Lottery_sMenu, MPROP_NEXTNAME, "Siguiente");
	menu_setprop(g_Lottery_sMenu, MPROP_BACKNAME, "Atrás");
	menu_setprop(g_Lottery_sMenu, MPROP_EXITNAME, "Salir");*/
	
	/*new file;
	new string_file[256];
	
	get_datadir(string_file, charsmax(string_file));
	format(string_file, charsmax(string_file), "%s/hud_zr.txt", string_file);
	
	file = fopen(string_file, "r");
	fgets(file, g_text_hud, charsmax(g_text_hud));
	fclose(file);*/
}

public plugin_end()
{
	new Handle:sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE others SET primer_zombie='%d', nemesis='%d', survivor='%d', swarm='%d', multi='%d', plague='%d', armageddon='%d',\
	wesker='%d', tribal='%d', alien_vs_pred='%d', annihilator='%d', sniper='%d', duel='%d', fp='%d', leg00='%d', leg01='%d';", g_modes_play[MODE_INFECTION], g_modes_play[MODE_NEMESIS], g_modes_play[MODE_SURVIVOR],
	g_modes_play[MODE_SWARM], g_modes_play[MODE_MULTI], g_modes_play[MODE_PLAGUE], g_modes_play[MODE_ARMAGEDDON], g_modes_play[MODE_WESKER],
	g_modes_play[MODE_TRIBAL], g_modes_play[MODE_ALVSPRED], g_modes_play[MODE_ANNIHILATION], g_modes_play[MODE_SNIPER], g_modes_play[MODE_DUEL], g_modes_play[MODE_FP], nadie_la_tiene, nadie_la_tiene2);
	if(!SQL_Execute(sql_consult))
	{
		new sql_error[512];
		SQL_QueryError(sql_consult, sql_error, 511);
		
		log_to_file("zr_sql.log", "- LOG:26 - %s", sql_error);
	}
	SQL_FreeHandle(sql_consult)

	SQL_FreeHandle(g_sql_connection)
	SQL_FreeHandle(g_sql_tuple)
}

/*================================================================================
 [Main Events]
=================================================================================*/

public event_team_info_private()
{
	new id = read_data(1);
	
	if(!is_user_alive(id) && is_user_connected(id))
	{
		new pTeam = get_pdata_int(id, 114, 5)
		if(pTeam != get_user_team(id))
		{
			emessage_begin(MSG_BROADCAST, g_msgScoreInfo);
			ewrite_byte(id);
			ewrite_short(get_user_frags(id));
			ewrite_short(get_pdata_int(id, 444, 5) );
			ewrite_short(0);
			ewrite_short(pTeam);
			emessage_end();
		}
	}
}

public event_round_start()
{
	g_hardmode = 0;
	
	//fn_remove_ents();
	
	set_cvar_num("pbk_afk_time", 60);
	set_cvar_num("pbk_spec_time", 60);
	set_cvar_num("pbk_join_time", 60);
	
	set_cvar_num("mp_friendlyfire", 0)
	
	set_task(0.1, "remove_stuff");
	
	set_lights("p");
	
	new value = get_cvar_num("mp_timelimit");
	if((get_timeleft() / 60) >= (value - 2)) 
		set_cvar_num("mp_timelimit", (value - (value - g_timeleft_rest)));
	
	g_newround = 1;
	
	g_endround = g_survround = g_nemround = g_swarmround = g_duel_final = g_duel_cuartos = g_duel_semi = g_duel_rfinal = g_plagueround = g_armageddon_round = g_wesker_round = g_tribal_round = g_tribal_power = g_alvspre_round =g_annihilation_round = g_anniq_kill = g_enround_forced = g_sniper_round =
	gl_time_nem = g_fp_round = g_fp_power = g_antidotecounter = g_madnesscounter = 0;
	
	remove_task(TASK_WELCOMEMSG);
	set_task(2.0, "welcome_msg", TASK_WELCOMEMSG);
	
	remove_task(TASK_MAKEZOMBIE);
	set_task(get_pcvar_float(cvar_warmup), "make_zombie_task", TASK_MAKEZOMBIE);
	
	new i;
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!is_user_connected(i))
			continue;
		
		g_dead_health[i] = 0;
	}
	
	// TAN
	static ymd[3], ttu[3]
	date(ymd[0], ymd[1], ymd[2])
	
	ttu[0] = time_to_unix(ymd[0], ymd[1], ymd[2], 00, 00, 00)
	ttu[1] = time_to_unix(ymd[0], ymd[1], ymd[2], 06, 00, 00)
	ttu[2] = time_to_unix(ymd[0], ymd[1], ymd[2], 04, 00, 00)
	
	if(arg_time() >= ttu[0] && arg_time() < ttu[1])
	{
		g_ur = 1
		
		if(arg_time() >= ttu[2])
			g_super_ur = 1
	}
	else
	{
		if(g_ur)
		{
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!hub(i, g_data[BIT_CONNECTED]))
					continue;
				
				gl_tantime[i] = 0;
			}
			
			// SQL - 1
			new Handle:sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE events SET tantime='0';")
			if(!SQL_Execute(sql_consult))
			{
				new sql_error[512];
				SQL_QueryError(sql_consult, sql_error, 511);
				
				log_to_file("zr_sql.log", "- LOG:56 - %s", sql_error);
			}
			SQL_FreeHandle(sql_consult)
		}
		
		g_ur = 0
		g_super_ur = 0
	}
}

public logevent_round_end()
{
	static Float:lastendtime;
	static Float:current_time;
	
	current_time = get_gametime();
	
	if (current_time - lastendtime < 0.5)
		return;
		
	//set_task(0.1, "fn_remove_ents");
	
	lastendtime = current_time;
	
	g_endround = 1;
	//set_round_end(1);
	
	remove_task(TASK_WELCOMEMSG);
	remove_task(TASK_MAKEZOMBIE);
	remove_task(TASK_SNIPER_ROUND);
	
	if(g_armageddon_round)
		client_cmd(0, "mp3 stop; stopsound")
	
	new i;
	if(!fnGetZombies()) // Ganaron los humanos
	{
		set_hudmessage(0, 0, 255, HUD_EVENT_X, HUD_EVENT_Y, 0, 0.0, 3.0, 2.0, 1.0, -1);
		ShowSyncHudMsg(0, g_MsgSync, "¡GANARON LOS HUMANOS!");
		
		PlaySound(g_sSoundWinHumans[random_num(0, charsmax(g_sSoundWinHumans))]);
		g_scorehumans++;
		
		if(g_enround_forced && (g_survround || g_wesker_round || g_tribal_round || g_sniper_round))
		{
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!hub(i, g_data[BIT_ALIVE]) || g_zombie[i]) continue;
				
				if(g_survivor[i] || g_wesker[i] || g_sniper[i] || g_tribal_human[i])
				{
					g_points[i][HAB_HUMAN] += g_mult_point[i];
					CC(0, "!g[ZP]!t %s!y ganó !g%d punto%s humano%s!y", g_playername[i], g_mult_point[i], (g_mult_point[i] == 1) ? "" : "s", (g_mult_point[i] == 1) ? "" : "s");
					
					if(g_survivor[i] && gl_time_nem && fnGetPlaying() >= 20)
						fn_update_logro(i, LOGRO_SECRET, LETS_ROCK)
				}
			}
		}
		
		if(fnGetPlaying() >= 20)
		{
			if(g_survround)
			{
				for(i = 1; i <= g_maxplayers; i++)
				{
					if(!g_survivor[i]) continue;
					
					if(g_bomb_aniq[i] && !g_surv_immunity[i])
					{
						fn_update_logro(i, LOGRO_SURV, SURV_AL_LIMITE);
						break;
					}
				}
			}
			else if(g_wesker_round)
			{
				for(i = 1; i <= g_maxplayers; i++)
				{
					if(!g_wesker[i]) continue;
					if(fnGetPlaying() >= 20)
					{
						if(g_wesker_laser[i] == 3 && !g_wesker_noduck[i])
						{
							fn_update_logro(i, LOGRO_WESKER, MIS_3_LASER);
							fn_give_hat(i, HAT_DEVIL)
						}
					
						if(get_user_health(i) == gl_wesker_health)
							fn_update_logro(i, LOGRO_WESKER, NO_ME_TOQUES);
					}
					break;
				}
			}
			else if(g_armageddon_round && fnGetHumans() >= 10)
			{
				for(i = 1; i <= g_maxplayers; i++)
				{
					if(!g_survivor[i] || !hub(i, g_data[BIT_ALIVE])) continue;
					fn_update_logro(i, LOGRO_OTHERS, WIN_ARMAGEDDON);
				}
			}
		}
	}
	else if(!fnGetHumans()) // Ganaron los zombies
	{
		set_hudmessage(255, 0, 0, HUD_EVENT_X, HUD_EVENT_Y, 0, 0.0, 3.0, 2.0, 1.0, -1);
		ShowSyncHudMsg(0, g_MsgSync, "¡GANARON LOS ZOMBIES!");
		
		PlaySound(g_sSoundWinZombies[random_num(0, charsmax(g_sSoundWinZombies))]);
		g_scorezombies++;
		
		if(g_enround_forced && g_nemround)
		{
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!hub(i, g_data[BIT_ALIVE]) || !g_zombie[i]) continue;
				
				if(g_nemesis[i])
				{
					g_points[i][HAB_ZOMBIE] += g_mult_point[i];
					CC(0, "!g[ZP]!t %s!y ganó !g%d punto%s zombie!y", g_playername[i], g_mult_point[i], (g_mult_point[i] == 1) ? "" : "s", (g_mult_point[i] == 1) ? "" : "s");
					
					if(fnGetPlaying() >= 20 && gl_time_nem)
						fn_update_logro(i, LOGRO_NEM, NEMERAP)
				}
			}
		}
		
		if(fnGetPlaying() >= 20)
		{
			if(g_nemround)
			{
				for(i = 1; i <= g_maxplayers; i++)
				{
					if(!g_nemesis[i]) continue;
					if(g_bazooka[i])
					{
						fn_update_logro(i, LOGRO_NEM, SOY_NEMESIS);
						break;
					}
				}
			}
			else if(g_armageddon_round && fnGetZombies() >= 10)
			{
				for(i = 1; i <= g_maxplayers; i++)
				{
					if(!g_nemesis[i] || !hub(i, g_data[BIT_ALIVE])) continue;
					fn_update_logro(i, LOGRO_OTHERS, WIN_ARMAGEDDON);
				}
			}
		}
	}
	else // Nadie ganó
	{
		set_hudmessage(0, 255, 0, HUD_EVENT_X, HUD_EVENT_Y, 0, 0.0, 3.0, 2.0, 1.0, -1);
		ShowSyncHudMsg(0, g_MsgSync, "¡NO GANÓ NADIE!");
		
		PlaySound(g_sSoundWinNoOne[random_num(0, charsmax(g_sSoundWinNoOne))]);
		
		if(g_annihilation_round)
		{
			new annihilator;
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!hub(i, g_data[BIT_CONNECTED])) continue;
				
				if(g_combo[i])
				{
					remove_task(i+TASK_FINISHCOMBO);
					set_task(random_float(0.7, 5.0), "fnFinishCombo_Human", i+TASK_FINISHCOMBO);
				}
				
				if(g_annihilator[i]) annihilator = i;
			}
			
			gl_kill_bazooka[annihilator] = 0;
			
			if(get_user_health(annihilator) >= 900000)
				fn_update_logro(annihilator, LOGRO_ANNIHILATOR, INTACTO)
			
			if(gl_kill_mac10[annihilator] >= 100)
				fn_update_logro(annihilator, LOGRO_ANNIHILATOR, MAC_100)
			
			gl_kill_mac10[annihilator] = 0;
			
			new iAps;
			new sAps[15];
			
			iAps = g_anniq_kill * ((g_anniq_kill >= 400) ? 100 : (g_anniq_kill >= 300) ? 75 : (g_anniq_kill >= 150) ? 50 : 25);
			add_dot(iAps, sAps, 14);
			
			new sWeaponName[32];
			new iWeaponEntId;
			
			get_weaponname(CSW_MAC10, sWeaponName, 31);
			iWeaponEntId = fm_find_ent_by_owner(-1, sWeaponName, annihilator);
			
			if(get_pdata_int(iWeaponEntId, OFFSET_CLIPAMMO, OFFSET_LINUX_WEAPONS) >= 30 && get_pdata_int(annihilator, AMMOOFFSET[CSW_MAC10], OFFSET_LINUX) == 100)
				fn_update_logro(annihilator, LOGRO_ANNIHILATOR, BALAS_130)
			
			if(g_bazooka[annihilator] == 5)
				fn_update_logro(annihilator, LOGRO_ANNIHILATOR, MISIL_5)
			
			if(g_anniq_kill < 400) CC(0, "!g[ZP]!y El aniquilador ganó !g%s APs!y, !g%s de XP!y, !g5p. H!y, !g5p. Z!y y !g$5!y", sAps, sAps);
			else
			{
				fn_update_logro(annihilator, LOGRO_ANNIHILATOR, KILL_400)
				CC(0, "!g[ZP]!y El aniquilador ganó !g%s APs!y, !g%s de XP!y, !g5p. H!y, !g5p. Z!y y !g$5!y", sAps, sAps);
				
				new iRand = random_num(1, 3)
				new maxlevel;
				
				switch(iRand)
				{
					case 1:
					{
						maxlevel = MAX_HAB_LEVEL[HAB_ZOMBIE][ZOMBIE_HP] + MAX_EFFECTS_HATS_HABS[g_hat_equip[annihilator]+1][HAB_ZOMBIE][ZOMBIE_HP]
						if(maxlevel != g_hab[annihilator][HAB_ZOMBIE][ZOMBIE_HP])
						{
							CC(0, "!g[ZP]!y El aniquilador ganó !g+1 a VIDA ZOMBIE!y por matar a más de !g400 humanos!y");
							g_hab[annihilator][HAB_ZOMBIE][ZOMBIE_HP]++;
						}
					}
					case 2:
					{
						maxlevel = MAX_HAB_LEVEL[HAB_ZOMBIE][ZOMBIE_SPEED] + MAX_EFFECTS_HATS_HABS[g_hat_equip[annihilator]+1][HAB_ZOMBIE][ZOMBIE_SPEED]
						if(maxlevel != g_hab[annihilator][HAB_ZOMBIE][ZOMBIE_SPEED])
						{
							CC(0, "!g[ZP]!y El aniquilador ganó !g+1 a VELOCIDAD ZOMBIE!y por matar a más de !g400 humanos!y");
							g_hab[annihilator][HAB_ZOMBIE][ZOMBIE_SPEED]++;
						}
					}
					case 3:
					{
						maxlevel = MAX_HAB_LEVEL[HAB_ZOMBIE][ZOMBIE_DAMAGE] + MAX_EFFECTS_HATS_HABS[g_hat_equip[annihilator]+1][HAB_ZOMBIE][ZOMBIE_DAMAGE]
						if(maxlevel != g_hab[annihilator][HAB_ZOMBIE][ZOMBIE_DAMAGE])
						{
							CC(0, "!g[ZP]!y El aniquilador ganó !g+1 a DAÑO ZOMBIE!y por matar a más de !g400 humanos!y");
							g_hab[annihilator][HAB_ZOMBIE][ZOMBIE_DAMAGE]++;
						}
					}
				}
			}
			
			update_xp(annihilator, iAps, iAps);
			
			g_points[annihilator][HAB_HUMAN] += 5;
			g_points[annihilator][HAB_ZOMBIE] += 5;
			
			g_money[annihilator] += 5;
			
			if(g_anniq_kill >= 400)
				fn_give_hat(annihilator, HAT_SASHA)
		}
	}
	
	new j;
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!hub(i, g_data[BIT_CONNECTED])) continue;
		
		if(g_logro[i][LOGRO_ZOMBIE][VIRUS] && g_logro[i][LOGRO_ZOMBIE][BOMBA_FALLIDA])
			fn_give_hat(i, HAT_PSYCHO)
		
		if(!g_annihilation_round)
		{
			for(j = 0; j < MAX_ITEMS_EXTRAS; j++)
				gl_all_items[i][j] = 0;
			
			if(g_kill_zombie[i] >= 20 && g_infect_human[i] >= 25)
				fn_give_hat(i, HAT_DARTHVADER2)
			
			if(g_kill_zombie[i] >= 35)
				fn_update_logro(i, LOGRO_SECRET, MAS_ZOMBIES)
			
			g_kill_zombie[i] = 0;
			g_infect_human[i] = 0;
			
		#if defined EVENT_SEMANA_INFECCION
			if(infectsInRound[i] > maxInfectsInRound[i])
				maxInfectsInRound[i] = infectsInRound[i];
			
			infectsInRound[i] = 0;
		#endif
			
			if(g_combo[i])
			{
				remove_task(i+TASK_FINISHCOMBO);
				set_task(random_float(0.7, 5.0), "fnFinishCombo_Human", i+TASK_FINISHCOMBO);
			}
		}
		
		if(g_dmg_glock[i] >= 500000 && fnGetPlaying() >= 20)
			fn_give_hat(i, HAT_SCREAM)
		
		if(gl_bullets[i] >= 1500 && gl_bullets_ok[i] >= 500)
			fn_update_logro(i, LOGRO_SECRET, BALAS_1500)
		
		if(g_stats[i][HEADSHOTS][DONE] >= 500000 && g_stats[i][HEADSHOTS][DONE] < 505000)
			fn_update_logro(i, LOGRO_SECRET, HITMAN)
		
		if(g_exp[i] >= 10000000 && !g_logro[i][LOGRO_SECRET][MILLONARIO])
			fn_update_logro(i, LOGRO_SECRET, MILLONARIO)
		
		if(gl_kill_ak[i] >= 150)
			fn_update_logro(i, LOGRO_SECRET, TERRORISTA_1)
	}
	
	if(g_nemround)
	{
		SortIntegers(gl_dmg_nem_ord, 32, Sort_Descending);
		
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(!hub(i, g_data[BIT_CONNECTED])) continue;
			
			/*if(g_hardmode && g_nemesis[i])
				util_p_killattachment(i);*/
			
			if(gl_dmg_nem_ord[0] >= 100000 && gl_dmg_nem_ord[0] == gl_dmg_nem[i])
				fn_update_logro(i, LOGRO_SECRET, MI_MAMA_DISPARO)
		}
	}
	
	balance_teams();
}

public event_ammo_x(id)
{
	if(g_zombie[id])
		return;
	
	static type;
	type = read_data(1);
	
	if(type >= sizeof AMMOWEAPON)
		return;
	
	static weapon;
	weapon = AMMOWEAPON[type];
	
	if(MAXBPAMMO[weapon] <= 2)
		return;
	
	static amount;
	amount = read_data(2);
	
	if(amount < MAXBPAMMO[weapon])
	{
		// The BP Ammo refill code causes the engine to send a message, but we
		// can't have that in this forward or we risk getting some recursion bugs.
		// For more info see: https://bugs.alliedmods.net/show_bug.cgi?id=3664
		
		static args[1];
		args[0] = weapon;
		
		set_task(0.1, "refill_bpammo", id, args, sizeof args);
	}
}

/*================================================================================
 [Main Forwards]
=================================================================================*/

public fw_SysError(const error[])
{
	new mapname[32]
	get_mapname(mapname, 31)
	
	new StringError[512]
	formatex( StringError, 511, "| FORWARD : FM_SysError : | Error: %s | MAPA: %s", (error[0]) ? error : "Ninguno", mapname )
	log_to_file( "zp_errores.log", StringError )
}

/*new g_iCounter = -1
new g_szLogFile[128]

public fw_Precache_Post(const szFile[])
{
    static iRetVal;
	
    iRetVal = get_orig_retval();
    if(iRetVal < g_iCounter)
        return FMRES_IGNORED;

    g_iCounter = iRetVal;

    formatex(g_szLogFile, charsmax(g_szLogFile), "<%i> <%s>", iRetVal, szFile);
    return FMRES_HANDLED;
}*/

// Entity Spawn Forward
public fw_Spawn(entity)
{
	if(!is_valid_ent(entity))
		return FMRES_IGNORED;
	
	new s_ClassName[32];
	entity_get_string(entity, EV_SZ_classname, s_ClassName, charsmax(s_ClassName));
	
	for(new a = 0; a < sizeof g_sObjective_Ents; a++)
	{
		if(equal(s_ClassName, g_sObjective_Ents[a]))
		{
			remove_entity(entity);
			return FMRES_SUPERCEDE;
		}
	}
	
	return FMRES_IGNORED;
}

// Sound Precache Forward
public fw_PrecacheSound(const sound[])
{
	if (equal(sound, "hostage", 7))
		return FMRES_SUPERCEDE;
	
	return FMRES_IGNORED;
}

public fw_PlayerSpawn_Post(id)
{
	if(!is_user_alive(id) || !fm_cs_get_user_team(id))
		return;
	
	set_pdata_int(id, 192, 0); // Block Radio
	
	sub(id, g_data[BIT_ALIVE])
	
	remove_task(id + TASK_SPAWN);
	remove_task(id + TASK_MODEL);
	remove_task(id + TASK_BLOOD);
	remove_task(id + TASK_AURA);
	remove_task(id + TASK_BURN);
	remove_task(id + TASK_NVISION);
	
	do_random_spawn(id);
	
	set_task(0.4, "task_hide_huds", id + TASK_SPAWN);
	set_task(2.0, "respawn_player_check_task", id + TASK_SPAWN);
	
	check_multiplier_ur(id, g_ur, g_super_ur)
	
	g_respawn_as_zombie[id] = 0;
	
	if(!g_newround && !g_endround)
	{
		if(g_armageddon_round)
			g_respawn_as_zombie[id] = 2;
		else if(!g_nemround && !g_annihilation_round && !g_fp_round)
			g_respawn_as_zombie[id] = 1;
	}
	else if(g_newround && !g_endround && g_armageddon_round)
	{
		reset_vars(id, 0);
		user_silentkill(id);
		
		CC(id, "!g[ZP]!y Has sido aniquilado por haber revivido cuando empezaba un armageddon!");
		
		return;
	}
	
	if(g_duel_final)
		g_respawn_as_zombie[id] = 0;
	
	if(g_respawn_as_zombie[id] && !g_newround)
	{
		if(g_respawn_as_zombie[id] > 1)
		{
			reset_vars(id, 0);
			zombieme(id, 0, 1, 0, 0, 0, 0, 0); // make him nemesis right away
		}
		else
		{
			reset_vars(id, 0);
			zombieme(id, 0, 0, 0, 0, 0, 0, 0); // make him zombie right away
		}
		
		return;
	}
	
	reset_vars(id, 0);
	
	if(HAT_ITEM_SET != g_hat_equip[id])
	{
		fn_set_hat(id, g_hat_mdl[HAT_ITEM_SET])
		g_hat_equip[id] = HAT_ITEM_SET;
	}
	
	set_task(0.3, "clear_weapons", id + TASK_SPAWN);
	
	if(!g_duel_final)
		set_task(0.4, "show_menu_buy1", id + TASK_SPAWN);
	
	// Set selected human class
	g_humanclass[id] = g_humanclassnext[id]
	
	// Get human name
	ArrayGetString(g_hclass_name, g_humanclass[id], g_human_classname[id], charsmax(g_human_classname[]))
	
	// Set human health, gravity, speed, damage and armor
	if(!g_duel_final && !g_fp_round) set_user_health(id, amount_upgrade(id, HAB_HUMAN, HUMAN_HP, ArrayGetCell(g_hclass_hp, g_humanclass[id]), 0))
	else if(g_duel_final) set_user_health(id, 100)
	else if(g_fp_round) set_user_health(id, 2500)
	
	set_user_gravity(id, amount_upgrade_f(id, HAB_HUMAN, HUMAN_GRAVITY, Float:ArrayGetCell(g_hclass_grav, g_humanclass[id]), 0, 0))
	g_human_spd[id] = amount_upgrade_f(id, HAB_HUMAN, HUMAN_SPEED, float(ArrayGetCell(g_hclass_spd, g_humanclass[id])), 0, 0)
	g_human_dmg[id] = amount_upgrade_f(id, HAB_HUMAN, HUMAN_DAMAGE, Float:ArrayGetCell(g_hclass_dmg, g_humanclass[id]), 0, 0)
	set_user_armor(id, amount_upgrade(id, HAB_HUMAN, HUMAN_ARMOR, 0, 0))
	
	if(g_block_habs && !check_access(id, 1))
	{
		set_user_gravity(id, 1.0)
		g_human_spd[id] = 240.0
	}
	
	ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
	
	// Switch to CT if spawning mid-round
	if(!g_newround && fm_cs_get_user_team(id) != FM_CS_TEAM_CT) // need to change team?
	{
		remove_task(id+TASK_TEAM)
		fm_cs_set_user_team(id, FM_CS_TEAM_CT)
		fm_user_team_update(id)
	}
	
	// Custom models stuff
	static currentmodel[32], tempmodel[32], already_has_model
	already_has_model = 0
	
	// Get current model for comparing it with the current one
	fm_cs_get_user_model(id, currentmodel, charsmax(currentmodel))
	
	// Set the right model, after checking that we don't already have it
	ArrayGetString(g_hclass_playermodel, g_humanclass[id], tempmodel, charsmax(tempmodel))
	if (equal(currentmodel, tempmodel)) already_has_model = 1
	
	if (!already_has_model)
	{
		ArrayGetString(g_hclass_playermodel, g_humanclass[id], g_playermodel[id], charsmax(g_playermodel[]))
		
		if(g_zr_pj[id] == 157)
			formatex(g_playermodel[id], charsmax(g_playermodel[]), "zp_tcs_l4d_louis")
	
		// Need to change the model?
		
		// An additional delay is offset at round start
		// since SVC_BAD is more likely to be triggered there
		if(g_newround) set_task(5.0 * MODELS_CHANGE_DELAY, "fm_user_model_update", id+TASK_MODEL)
		else fm_user_model_update(id+TASK_MODEL)
	}
	
	// Remove glow
	set_user_rendering(id)
	
	// Turn off his flashlight (prevents double flashlight bug/exploit)
	turn_off_flashlight(id)
	
	// Replace weapon models (bugfix)
	static weapon_ent
	weapon_ent = fm_cs_get_current_weapon_ent(id)
	if(is_valid_ent(weapon_ent)) replace_weapon_models(id, cs_get_weapon_id(weapon_ent))
	
	// Last Zombie Check
	fnCheckLastZombie()
}

// Ham Player Killed Forward
public fw_PlayerKilled(victim, attacker, shouldgib)
{
	// Player killed
	cub(victim, g_data[BIT_ALIVE])
	// Disable nodamage mode after we die to prevent spectator nightvision using zombie madness colors bug
	g_nodamage[victim] = 0
	
	if(g_tribal_human[victim])
	{
		new i;
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(!hub(i, g_data[BIT_CONNECTED])) continue;
			if(g_tribal_human[i])
				remove_task(i+TASK_AURA)
		}
	}
	
	// Remove semiclip
#if defined SEMICLIP_INVIS
	g_player_solid[victim] = 0;
	g_player_restore[victim] = 0;
#endif
	
	if(is_user_valid_connected(victim))
	{
		// Not glow
		set_user_rendering(victim)
	}
	
	// Not aura
	remove_task(victim+TASK_AURA)
	
	// Enable dead players nightvision
	set_task(0.1, "spec_nvision", victim)
	
	// Stop bleeding/burning/aura when killed
	if(g_zombie[victim])
	{
		remove_task(victim+TASK_BLOOD)
		remove_task(victim+TASK_BURN)
		
		// Nemesis explodes!
		if(g_nemesis[victim])
			SetHamParamInteger(3, 2)
	}
	else if(g_armageddon_round && fnGetHumans() == 1 && fnGetZombies() >= 10 && fnGetPlaying() >= 20)
	{
		new i;
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(!hub(i, g_data[BIT_ALIVE])) continue;
			if(g_zombie[i]) continue;
			
			fn_update_logro(i, LOGRO_SURV, LA_VICTORIA_ESTA_CERCA);
		}
	}
	
	// Determine whether the player killed himself
	g_iSelfKill[victim] = (victim == attacker || !is_user_valid_connected(attacker)) ? 1 : 0
	
	// Killed by a non-player entity or self killed
	if (g_iSelfKill[victim]) return;
	
	// Zombie/nemesis killed human, reward ammo packs
	if(g_zombie[attacker])
	{
		update_xp(attacker, UPDATE_XP_MULT_INFECT, 3)
		
		if(g_survivor[victim]) fn_set_points(attacker, 1, "survivor")
		else if(g_wesker[victim]) fn_set_points(attacker, 1, "wesker")
		else if(g_tribal_human[victim]) fn_set_points(attacker, 1, "tribal")
		else if(g_sniper[victim])
		{
			g_points[attacker][HAB_HUMAN] += (g_mult_point[attacker] * 2)
			g_points[attacker][HAB_ZOMBIE] += g_mult_point[attacker]
			CC(0, "!g[ZP] %s!y ganó !g%dp. H!y y !g%dp. Z!y por matar a un sniper", g_playername[attacker], (g_mult_point[attacker] * 2), g_mult_point[attacker])
			
			remove_task(TASK_SNIPER_ROUND)
		}
		else if(g_nemround && g_nemesis[attacker])
		{
			gl_kill_h_nem[attacker]++
			
			if(gl_kill_h_nem[attacker] == 1000)
				fn_update_logro(attacker, LOGRO_SECRET, EL_TERROR_EXISTE)
			
			if(g_lasthuman[victim])
			{
				g_points[attacker][HAB_ZOMBIE] += (g_mult_point[attacker] * (g_hardmode) ? 3 : 1)
				CC(0, "!g[ZP] %s!y ganó !g%d punto%s zombie!y por ganar el modo nemesis%s", g_playername[attacker], (g_mult_point[attacker] * (g_hardmode) ? 3 : 1), ((g_mult_point[attacker] * (g_hardmode) ? 3 : 1) == 1) ? "" : "s", g_hardmode ? " en !gHard Mode!y" : "")
				
				if(fnGetPlaying() >= 20 && gl_time_nem)
					fn_update_logro(attacker, LOGRO_NEM, NEMERAP)
			}
		}
		
		if(g_alvspre_round && (g_lasthuman[victim] || g_predator[victim]))
		{
			new i;
			new buff_xp[15];
			new random_xp = random_num(1000, 30000);
			new random_ap = random_num(1, 1000);
			
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!is_user_alive(i)) continue;
				if(!g_zombie[i])
				{
					user_silentkill(i)
					
					if(get_user_health(i) > 0)
						set_user_health(i, 0);
					
					continue;
				}
				
				update_xp(i, random_xp, random_ap)
			}
			
			if(g_predator[victim])
				fn_set_points(attacker, 1, "depredador")
			
			add_dot(random_xp, buff_xp, 14)
			CC(0, "!g[ZP]!y Todos los zombies vivos ganaron !g%s de XP!y y !g%d ammo packs!y por ganar el modo", buff_xp, random_ap)
		}
		else if(g_annihilation_round && g_annihilator[attacker])
		{
			g_anniq_kill++;
			
			if(g_lasthuman[victim])
			{
				new i;
				for(i = 1; i <= g_maxplayers; i++)
				{
					if(!hub(i, g_data[BIT_CONNECTED])) continue;
					if(!g_combo[i]) continue;
					
					remove_task(i+TASK_FINISHCOMBO);
					set_task(random_float(0.1, 0.7), "fnFinishCombo_Human", i+TASK_FINISHCOMBO);
				}
				
				new iAps;
				new sAps[15];
				
				iAps = g_anniq_kill * ((g_anniq_kill >= 400) ? 150 : (g_anniq_kill >= 300) ? 100 : (g_anniq_kill >= 150) ? 75 : 50);
				add_dot(iAps, sAps, 14);
				
				CC(0, "!g[ZP]!y El aniquilador ganó !g%s APs!y, !g%s de XP!y, !g5p. H!y, !g5p. Z!y y !g$5!y", sAps, sAps);
				update_xp(attacker, iAps, iAps);
				
				g_points[attacker][HAB_HUMAN] += 5;
				g_points[attacker][HAB_ZOMBIE] += 5;
				
				g_money[attacker] += 5;
			}
		}
		else if(g_swarmround)
		{
			gl_kill_h_swarm[attacker]++;
			
			if(gl_kill_h_swarm[attacker] == 8)
				fn_update_logro(attacker, LOGRO_SECRET, ASESINO_DE_TURNO)
		}
		else if(g_alvspre_round && g_alien[attacker])
		{
			gl_kill_h_avd[attacker]++;
			
			if(gl_kill_h_avd[attacker] == 7)
				fn_update_logro(attacker, LOGRO_SECRET, ZANGANO_REAL)
		}
		else if(g_fp_round && g_fp[attacker])
		{
			if(g_lasthuman[victim])
			{
				new aasmash[15];
				new smash = random_num(20000, 40000);
				add_dot(smash, aasmash, 14);
				
				g_points[attacker][HAB_HUMAN] += g_mult_point[attacker] * 2
				update_xp(attacker, smash, 0);
				
				CC(0, "!g[ZP] %s!y ganó !g%dp. H y Z!y y !g%s XP!y por ganar el modo fleshpound", g_playername[attacker], g_mult_point[attacker], aasmash)
				
				if(!g_fp_min)
					darRecomp(attacker);
			}
			else if(g_tribal_human[victim])
			{
				new trib = 0;
				for(new i = 1; i <= g_maxplayers; ++i)
				{
					if(is_user_alive(i) && g_tribal_human[i])
						trib++;
				}
				
				if(!trib)
				{
					for(new i = 1; i <= g_maxplayers; ++i)
					{
						if(is_user_alive(i) && !g_fp[i])
							user_silentkill(i)
					}
					
					new aasmash[15];
					new smash = random_num(20000, 40000);
					add_dot(smash, aasmash, 14);
					
					g_points[attacker][HAB_HUMAN] += g_mult_point[attacker] * 2
					update_xp(attacker, smash, 0);
					
					CC(0, "!g[ZP] %s!y ganó !g%dp. H y Z!y y !g%s XP!y por ganar el modo fleshpound", g_playername[attacker], g_mult_point[attacker], aasmash)
					
					if(!g_fp_min)
						darRecomp(attacker)
				}
			}
		}
		
		// -- Save Stats --
		g_stats[attacker][KILLS_HUMANS][DONE]++
		g_stats[victim][KILLS_HUMANS][TAKEN]++
		
		// -- Only Kills Special Modes --
		g_stats[attacker][g_mode[victim]][DONE]++
		
		fn_check_logros(attacker, victim, 0, 0, 1)
	}
	else if(g_zombie[victim])
	{
		if(g_weap_leg_choose[attacker] && g_currentweapon[attacker] == CSW_M4A1)
		{
			g_leg_z_kills[attacker]++;
			check_leg_lvl(attacker);
		}
		
		g_dead_health[victim]++;
		
		update_xp(attacker, UPDATE_XP_MULT_KILL, 2)
		
		if(g_nemesis[victim]) 
		{
			if(g_currentweapon[attacker] != CSW_KNIFE || g_survivor[attacker] || g_wesker[attacker] || g_sniper[attacker] || g_tribal_human[attacker] || g_predator[attacker])
				fn_set_points(attacker, 0, "nemesis")
			else
			{
				g_points[attacker][HAB_HUMAN] += (g_mult_point[attacker] * 2)
				CC(0, "!g[ZP] %s!y ganó !g%d puntos humanos!y por matar a un !gnemesis con cuchillo!y", g_playername[attacker], (g_mult_point[attacker] * 2))
				
				fn_update_logro(attacker, LOGRO_HUMAN, FACA_ROJA);
			}
		}
		else if(g_survround && g_survivor[attacker])
		{
			gl_kill_z_surv[attacker]++
			
			if(gl_kill_z_surv[attacker] == 1000)
				fn_update_logro(attacker, LOGRO_SECRET, RESISTENCIA)
		
			if(g_lastzombie[victim])
			{
				g_points[attacker][HAB_HUMAN] += g_mult_point[attacker]
				CC(0, "!g[ZP] %s!y ganó !g%d punto%s humano%s!y por ganar el modo survivor", g_playername[attacker], g_mult_point[attacker],
				(g_mult_point[attacker] == 1) ? "" : "s", (g_mult_point[attacker] == 1) ? "" : "s")
				
				if(fnGetPlaying() >= 20 && gl_time_nem)
					fn_update_logro(attacker, LOGRO_SECRET, LETS_ROCK)
			}
		}
		else if(g_wesker_round && g_wesker[attacker])
		{
			gl_kill_z_wes[attacker]++
			
			if(gl_kill_z_wes[attacker] == 1000)
				fn_update_logro(attacker, LOGRO_SECRET, ALBERT_WESKER)
		
			if(g_lastzombie[victim])
			{
				g_points[attacker][HAB_HUMAN] += g_mult_point[attacker]
				CC(0, "!g[ZP] %s!y ganó !g%d punto%s humano%s!y por ganar el modo wesker", g_playername[attacker], g_mult_point[attacker],
				(g_mult_point[attacker] == 1) ? "" : "s", (g_mult_point[attacker] == 1) ? "" : "s")
			}
		}
		else if(g_sniper_round && g_sniper[attacker] && (g_lastzombie[victim] || g_sniper_power[attacker]))
		{
			if(g_lastzombie[victim])
			{
				static buff[15]
				new finish = (g_zombies_left_total - g_zombies_left) * 150
				add_dot(finish, buff, 14)
				
				g_points[attacker][HAB_HUMAN] += (g_mult_point[attacker] * 2)
				CC(0, "!g[ZP] %s!y ganó !g%s XP!y , !g%s APs! y y!g%dp. H!y por ganar el modo sniper", g_playername[attacker], buff, buff, (g_mult_point[attacker] * 2))
				
				update_xp(attacker, finish, finish);
				
				fn_update_logro(attacker, LOGRO_SNIPER, YO_Y_MI_AWP)
				
				if(g_sniper_power[attacker] == 0)
					fn_update_logro(attacker, LOGRO_SNIPER, YO_MI_AWP_Y_MI_PODER)
				
				remove_task(TASK_SNIPER_ROUND)
			}
			else gl_kill_sniper++;
		}
		else if(g_swarmround)
		{
			gl_kill_z_swarm[attacker]++;
			
			if(gl_kill_z_swarm[attacker] == 10)
				fn_update_logro(attacker, LOGRO_SECRET, APLASTA_ZOMBIES)
		}
		else if(g_alvspre_round && g_predator[attacker])
		{
			gl_kill_z_avd[attacker]++;
			
			if(gl_kill_z_avd[attacker] == 8)
				fn_update_logro(attacker, LOGRO_SECRET, DEPREDADOR_FINAL)
		}
		else if(g_fp_round && g_fp[victim])
		{
			if(g_lastzombie[victim])
			{
				new aasmash[15];
				new smash = random_num(25000, 75000);
				add_dot(smash, aasmash, 14);
				
				g_points[attacker][HAB_HUMAN] += g_mult_point[attacker] * 4
				update_xp(attacker, smash, 0);
				
				CC(0, "!g[ZP] %s!y ganó !g%dp. H y Z!y y !g%s XP!y por matar al fleshpound", g_playername[attacker], (g_mult_point[attacker]*4), aasmash)
			}
			
			if(g_currentweapon[attacker] == CSW_KNIFE)
			{
				if(get_percent_upgrade(attacker, HAB_HUMAN, HUMAN_SPEED) == 100)
					fn_give_hat(attacker, HAT_MASTERCHIEF)
			}
		}
		
		if(g_tribal_round && g_lastzombie[victim])
		{
			new i, iTribals, iTribalId;
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!hub(i, g_data[BIT_ALIVE]) || g_zombie[i]) continue;
				g_points[i][HAB_HUMAN] += g_mult_point[i]
				CC(0, "!g[ZP] %s!y ganó !g%d punto%s humano%s!y por ganar el modo tribal", g_playername[i], g_mult_point[i],
				(g_mult_point[i] == 1) ? "" : "s", (g_mult_point[i] == 1) ? "" : "s")
				
				iTribals++;
				
				if(iTribals == 1)
					iTribalId = i;
				else if(iTribals == 2)
				{
					fn_update_logro(iTribalId, LOGRO_OTHERS, GRAN_EQUIPO)
					fn_update_logro(i, LOGRO_OTHERS, GRAN_EQUIPO)
				}
			}
			
		}
		else if(g_alvspre_round && (g_lastzombie[victim] || g_alien[victim]))
		{
			new i;
			new buff_xp[15];
			new random_xp = random_num(1000, 30000);
			new random_ap = random_num(1, 1000);
			
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!is_user_alive(i)) continue;
				if(g_zombie[i])
				{
					user_silentkill(i)
					
					if(get_user_health(i) > 0)
						set_user_health(i, 0);
					
					continue;
				}
				
				update_xp(i, random_xp, random_ap)
			}
			
			if(g_alien[victim])
				fn_set_points(attacker, 0, "alien")
			
			add_dot(random_xp, buff_xp, 14)
			CC(0, "!g[ZP]!y Todos los humanos vivos ganaron !g%s de XP!y y !g%d ammo packs!y por ganar el modo", buff_xp, random_ap)
		}
		else if(g_annihilation_round && g_annihilator[victim])
		{
			new i;
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!hub(i, g_data[BIT_CONNECTED])) continue;
				if(!g_combo[i]) continue;
				
				remove_task(i+TASK_FINISHCOMBO);
				set_task(random_float(0.1, 0.7), "fnFinishCombo_Human", i+TASK_FINISHCOMBO);
			}
			
			new iAps;
			new sAps[15];
			
			iAps = g_anniq_kill * ((g_anniq_kill >= 400) ? 150 : (g_anniq_kill >= 300) ? 100 : (g_anniq_kill >= 150) ? 75 : 50);
			add_dot(iAps, sAps, 14);
			
			CC(0, "!g[ZP] %s!y ganó !g5p. H!y, !g5. Z!y y !g$5!y por matar a un !ganiquilador!y", g_playername[attacker]);
			CC(0, "!g[ZP]!y El aniquilador ganó !g%s APs!y, !g%s de XP!y, !g5p. H!y, !g5p. Z!y y !g$5!y", sAps, sAps);
			update_xp(victim, iAps, iAps);
			
			g_points[victim][HAB_HUMAN] += 5;
			g_points[victim][HAB_ZOMBIE] += 5;
			
			g_points[attacker][HAB_HUMAN] += 5;
			g_points[attacker][HAB_ZOMBIE] += 5;
			
			g_money[victim] += 5;
			g_money[attacker] += 5;
			
			if(g_currentweapon[attacker] == CSW_KNIFE)
				fn_update_logro(attacker, LOGRO_SECRET, CHUCK_NORRIS)
		}
		
		// -- Save Stats --
		g_stats[attacker][KILLS_ZOMBIES][DONE]++
		g_stats[victim][KILLS_ZOMBIES][TAKEN]++
		
		if(get_pdata_int(victim, 75) == HIT_HEAD)
		{
			gl_kill_head[attacker]++;
			g_stats[attacker][KILLS_ZOMBIES_HEAD][DONE]++
			
			if(gl_kill_head[attacker] >= 10)
				fn_update_logro(attacker, LOGRO_HUMAN, ROMPIENDO_HEADS);
			
		#if !defined EVENT_NAVIDAD
			static Float:flPlayerPos[3]
			entity_get_vector(victim, EV_VEC_origin, flPlayerPos)
			
			static Float:flEndOrigin[3]
			get_drop_position(victim, flEndOrigin, 20)
			
			new iTraceResult = 0
			
			engfunc(EngFunc_TraceLine, flPlayerPos, flEndOrigin, IGNORE_MONSTERS, victim, iTraceResult)
			
			static Float:flFraction
			get_tr2(iTraceResult, TR_flFraction, flFraction)
			
			if(flFraction == 1.0)
				fn_drop_head(victim)
		#endif
		}
		else
		{
			new iRandom;
			iRandom = random_num(1, 10)
			if(iRandom == 1 || iRandom == 4 || iRandom == 5 || iRandom == 10)
			{
				static Float:flPlayerPos[3]
				entity_get_vector(victim, EV_VEC_origin, flPlayerPos)
				
				static Float:flEndOrigin[3]
				get_drop_position(victim, flEndOrigin, 20)
				
				new iTraceResult = 0
				
				engfunc(EngFunc_TraceLine, flPlayerPos, flEndOrigin, IGNORE_MONSTERS, victim, iTraceResult)
				
				static Float:flFraction
				get_tr2(iTraceResult, TR_flFraction, flFraction)
				
				if(flFraction == 1.0)
				{
				#if defined EVENT_NAVIDAD
					fn_drop_gift(victim)
				#else
					fn_drop_head(victim)
				#endif
				}
			}
		}
		
		if(fnGetPlaying() >= 10)
		{
			if(g_currentweapon[attacker] == CSW_KNIFE)
			{
				gl_kill_knife[attacker]++
				
				if(gl_kill_knife[attacker] == 25) fn_update_logro(attacker, LOGRO_HUMAN, NINJA);
				else if(gl_kill_knife[attacker] == 100) fn_update_logro(attacker, LOGRO_HUMAN, IMPARABLE);
				else if(gl_kill_knife[attacker] == 300) fn_update_logro(attacker, LOGRO_HUMAN, THIS_IS_SPARTA);
				
				if(fnGetPlaying() >= 18)
				{
					g_kill_knife_spartan[attacker]++;
					
					if(g_kill_knife_spartan[attacker] == 25)
						fn_give_hat(attacker, HAT_SPARTAN)
				}
				
				if(g_wesker[attacker])
				{
					g_kill_knife[attacker]++;
					if(g_kill_knife[attacker] == 5)
						fn_update_logro(attacker, LOGRO_WESKER, FACA_5);
				}
			}
			
			if(fnGetPlaying() >= 20)
				g_kill_zombie[attacker]++;
		}
		
		if(user_has_weapon(victim, CSW_SMOKEGRENADE))
			fn_update_logro(victim, LOGRO_SECRET, SALVADOR);
		
		if(g_currentweapon[attacker] == CSW_AK47)
			gl_kill_ak[attacker]++;
		
		// -- Only Kills Special Modes --
		g_stats[attacker][g_mode[victim]][DONE]++
		
		fn_check_logros(attacker, victim, 1, 0, 0)
	}
}

// Ham Player Killed Post Forward
public fw_PlayerKilled_Post(victim, attacker, shouldgib)
{
	// Last Zombie Check
	fnCheckLastZombie()
	
	if(g_duel_final && victim != attacker && is_user_connected(attacker))
	{
		g_duel_win_xp[attacker] += 5000;
		
		if(fnGetAl1ve() == 8)
		{
			new i;
			new j = 0;
			
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!is_user_alive(i))
					continue;
				
				g_duel_humans[j] = i;
				
				++j;
			}
		}
		else if(g_duel_cuartos && fnGetAl1ve() == 4)
		{
			new i;
			new j = 0;
			
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!is_user_alive(i))
					continue;
				
				g_duel_humans[j] = i;
				
				++j;
			}
		}
		else if(g_duel_semi && fnGetAl1ve() == 2)
		{
			new i;
			new j = 0;
			
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!is_user_alive(i))
					continue;
				
				g_duel_humans[j] = i;
				
				++j;
			}
		}
		
		if(fnGetAl1ve() == 1)
		{
			if(!g_duel_cuartos)
			{
				PlaySound(g_sSoundModeSwarm[random_num(0, charsmax(g_sSoundModeSwarm))]);
				
				set_dhudmessage(255, 0, 0, HUD_EVENT_X, 0.3, 0, 0.0, 4.9, 1.0, 1.0)
				show_dhudmessage(0, "¡ DUELO FINAL %s!^nCuartos de final", g_duel_final_aps ? "DE APS " : "")
				
				CC(0, "!g[ZP]!y DUELO FINAL %s!g-!y Cuartos de final!y", g_duel_final_aps ? "DE APS " : "")
				
				g_duel_cuartos = 1;
				
				new i;
				new j = 0;
				
				for(i = 1; i <= g_maxplayers; i++)
				{
					if(!is_user_connected(i))
						continue;
					
					if(j == 8)
						break;
					
					ExecuteHamB(Ham_CS_RoundRespawn, g_duel_humans[j])
					
					++j;
				}
			}
			else if(!g_duel_semi)
			{
				PlaySound(g_sSoundModeSwarm[random_num(0, charsmax(g_sSoundModeSwarm))]);
				
				set_dhudmessage(255, 0, 0, HUD_EVENT_X, 0.3, 0, 0.0, 4.9, 1.0, 1.0)
				show_dhudmessage(0, "¡ DUELO FINAL %s!^nSemifinal", g_duel_final_aps ? "DE APS " : "")
				
				CC(0, "!g[ZP]!y DUELO FINAL %s!g-!y Semifinal!y", g_duel_final_aps ? "DE APS " : "")
				
				g_duel_semi = 1;
				
				new i;
				new j = 0;
				
				for(i = 1; i <= g_maxplayers; i++)
				{
					if(!is_user_connected(i))
						continue;
					
					if(j == 4)
						break;
					
					ExecuteHamB(Ham_CS_RoundRespawn, g_duel_humans[j])
					
					++j;
				}
			}
			else if(!g_duel_rfinal)
			{
				PlaySound(g_sSoundModeSwarm[random_num(0, charsmax(g_sSoundModeSwarm))]);
				
				set_dhudmessage(255, 0, 0, HUD_EVENT_X, 0.3, 0, 0.0, 4.9, 1.0, 1.0)
				show_dhudmessage(0, "¡ DUELO FINAL %s!^nFinal", g_duel_final_aps ? "DE APS " : "")
				
				CC(0, "!g[ZP]!y DUELO FINAL %s!g-!y Final", g_duel_final_aps ? "DE APS " : "")
				
				g_duel_rfinal = 1;
				
				new i;
				new j = 0;
				
				for(i = 1; i <= g_maxplayers; i++)
				{
					if(!is_user_connected(i))
						continue;
					
					if(j == 2)
						break;
					
					ExecuteHamB(Ham_CS_RoundRespawn, g_duel_humans[j])
					
					++j;
				}
			}
			else if(g_duel_rfinal)
			{
				new iAps;
				new sAps[15];
				
				iAps = random_num(20000, 65000)
				add_dot(iAps, sAps, 14);
				
				new i;
				new sWinss[15];
				for(i = 1; i <= g_maxplayers; i++)
				{
					if(!is_user_connected(i))
						continue;
					
					add_dot(g_duel_win_xp[i], sWinss, 14)
					CC(i, "!g[ZP]!y DUELO FINAL%s: Ganaste !g%s de XP!y", g_duel_final_aps ? " DE APS" : "", sWinss);
					update_xp(i, g_duel_win_xp[i], 0);
					
					g_duel_win_xp[i] = 0;
				}
				
				CC(0, "!g[ZP] %s!y es el ganador del DUELO FINAL %s. Ganó !g%s de XP!y", g_playername[attacker], g_duel_final_aps ? "DE APS" : "", sAps)
				update_xp(attacker, iAps, 0);
				
				PlaySound(g_sSoundBazooka_3)
				
				g_timeleft_rest = (get_timeleft() / 60);
				
				i = 0;
				for(i = 1; i <= g_maxplayers; i++)
				{
					if(!is_user_alive(i))
						continue;
					
					remove_task(i+TASK_TEAM)
					fm_cs_set_user_team(i, FM_CS_TEAM_T)
					fm_user_team_update(i)
					
					user_silentkill(i)
				}
			}
		}
	}
	
	// Set the respawn task
	set_task(1.0, "respawn_player_task", victim+TASK_SPAWN)
}

// Ham Take Damage Forward
public fw_TakeDamage(victim, inflictor, attacker, Float:damage, damage_type)
{
	// Damage fall ?
	if(damage_type & DMG_FALL)
		return HAM_SUPERCEDE;
	
	// Non-player damage or self damage
	if(victim == attacker || !is_user_valid_connected(attacker))
		return HAM_IGNORED;
	
	// New round starting or round ended
	// Victim shouldn't take damage or attacker/victim is frozen
	// Prevent friendly fire
	if(g_newround || g_endround || g_frozen[attacker] || g_frozen[victim] || (!g_duel_final && g_zombie[attacker] == g_zombie[victim]))
		return HAM_SUPERCEDE;
	
	// Fix bubble problem
	/*if(g_bubble_eff[attacker])
		return HAM_SUPERCEDE;*/
	
	if(g_nodamage[victim] && !g_nodamage[attacker] && !g_nemesis[attacker] && !g_alien[attacker] && !g_annihilator[attacker] && !g_fp[attacker])
		return HAM_SUPERCEDE;
	
	if(g_nodamage[victim] && g_nodamage[attacker] && !g_zombie[attacker])
		return HAM_SUPERCEDE;
	
	if(g_convert_zombie[victim])
		return HAM_SUPERCEDE;
	
	// Attacker is human...
	if(!g_zombie[attacker])
	{
		if(g_duel_final)
		{
			if(g_duel_final_aps)
				damage *= 2;
			
			SetHamParamFloat(4, damage)
			return HAM_IGNORED;
		}
		
		if(g_unclip[attacker] && !g_survivor[attacker] && !g_sniper[attacker] && !g_tribal_human[attacker] && !g_wesker[attacker])
			gl_bullets_ok[attacker]++;
	
		if(g_sniper[attacker])
		{
			if(g_currentweapon[attacker] != CSW_AWP)
				return HAM_IGNORED;
			
			static iKill;
			iKill = 0;
			
			ExecuteHamB(Ham_Killed, victim, attacker, 2);
			g_zombies_left--;
			iKill++;
			
			if(iKill >= 3)
				fn_update_logro(attacker, LOGRO_SNIPER, BALA_4)
				
			/*if(g_zombies_left < 0)
			{
				static buff[15]
				add_dot((g_zombies_left_total - g_zombies_left) * 150, buff, 14)
				
				g_points[attacker][HAB_HUMAN] += (g_mult_point[attacker] * 2)
				CC(0, "!g[ZP] %s!y ganó !g%s XP!y , !g%s APs! y y!g%dp. H!y por ganar el modo sniper", g_playername[attacker], buff, buff, (g_mult_point[attacker] * 2))
				
				remove_task(TASK_SNIPER_ROUND)
			}*/
			
			return HAM_IGNORED;
		}
		
		static weapon_edit;
		if(g_weapons_edit[attacker][PRIMARY_WEAPON] && g_primary_weapon[attacker])
		{
			weapon_edit = (g_weapon[attacker][PRIMARY_WEAPON][COLT_2]) ? 31 :
			(g_weapon[attacker][PRIMARY_WEAPON][AUG_2]) ? 32 :
			(g_weapon[attacker][PRIMARY_WEAPON][SG552_2]) ? 33 :
			g_currentweapon[attacker]
		
			if(g_weapon_dmg[weapon_edit] > 0.0)
				damage *= g_weapon_dmg[weapon_edit]
		}
		else if(g_weapons_edit[attacker][SECONDARY_WEAPON] && !g_primary_weapon[attacker])
		{
			if(g_weapon_dmg[g_currentweapon[attacker]] > 0.0)
				damage *= g_weapon_dmg[g_currentweapon[attacker]]
		}
		else if(g_weap_leg_choose[attacker] && g_currentweapon[attacker] == CSW_M4A1)
		{
			damage *= 4.7
			damage += (20 * g_leg_habs[attacker][0])
		}
		
		if(g_wesker[attacker] && g_currentweapon[attacker] == CSW_DEAGLE)
		{
			new iHealth = get_user_health(victim);
			
			iHealth *= 20;
			iHealth /= 100;
			
			damage = float(iHealth < 20.0) ? 20.0 : float(iHealth);
		}
		
		if(g_survivor[attacker])
			damage += 100 * g_hab[attacker][HAB_SURV][SURV_DMG]
		
		// Increased for habilitie
		damage += g_human_dmg[attacker]
		
		// Special mode more damage ?
		if(g_predator[attacker]) damage *= 3.5
		
		if(g_rn_equip[victim][NECK][NECK_DAMAGE])
		{
			static Float:dmg_perc;
			dmg_perc = (damage * (5.0 * float(g_rn[victim][NECK][NECK_DAMAGE]))) / 100.0;
			
			damage -= dmg_perc;
		}
		
		if(g_currentweapon[attacker] == CSW_GLOCK18)
			g_dmg_glock[attacker] += floatround(damage)
		
		if(g_hat_equip[attacker] == HAT_SPARTAN && g_currentweapon[attacker] == CSW_KNIFE)
			damage *= 5.0;
		
		// Set damage
		SetHamParamFloat(4, damage)
		
		/*if(g_zr_pj[victim] == 1006 && (get_user_health(victim) - damage) <= 5 && !g_one_time_erik)
		{
			infection_effects(victim)
			
			static Float:flOrigin[3]
			entity_get_vector(victim, EV_VEC_origin, flOrigin);
			
			engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, flOrigin, 0)
			write_byte(TE_DLIGHT) // TE id
			engfunc(EngFunc_WriteCoord, flOrigin[0]) // x
			engfunc(EngFunc_WriteCoord, flOrigin[1]) // y
			engfunc(EngFunc_WriteCoord, flOrigin[2]) // z
			write_byte(40) // radius
			write_byte(255) // red
			write_byte(0) // green
			write_byte(0) // blue
			write_byte(10) // life
			write_byte(45) // decay rate
			message_end()
			
			set_user_health(victim, (g_erik_health / 2))
			
			g_one_time_erik = 1;
		}*/
		
		// -- Save Stats --
		if(get_pdata_int(victim, 75) == HIT_HEAD)
		{
			g_stats[attacker][HEADSHOTS][DONE]++
			g_stats[victim][HEADSHOTS][TAKEN]++
			
			if(g_weap_leg_choose[attacker] && g_currentweapon[attacker] == CSW_M4A1)
				g_leg_heads[attacker]++
			
			if(g_hardmode && g_nemesis[victim])
				damage *= 2.0;
		}
		
		if(!g_wesker[attacker])
		{
			if((g_stats[attacker][DAMAGE][DONE] + floatround(damage)) <= 2147483630)
				g_stats[attacker][DAMAGE][DONE] += floatround(damage)
			else g_stats[attacker][DAMAGE][DONE] = 2147483630;
			
			g_stats[victim][DAMAGE][TAKEN] += floatround(damage)
		}
		
		gl_infects_no_dmg[victim] = -1
		
		// Reward ammo packs
		// Store damage dealt
		g_damagedealt[attacker] += floatround(damage)
		g_combo_damage[attacker] += floatround(damage)
		
		gl_dmg_nem_ord[attacker] += floatround(damage)
		gl_dmg_nem[attacker] = gl_dmg_nem_ord[attacker]
		
		// Reward xp and ammopacks for every [ammo damage] dealt
		while(g_damagedealt[attacker] > 500)
		{
			update_xp(attacker, 3, 1)
			g_damagedealt[attacker] -= 500
		}
		
		if(g_weap_leg_choose[attacker] && g_currentweapon[attacker] == CSW_M4A1)
		{
			if(g_nemesis[victim])
				g_leg_dmg_nem[attacker] += floatround(damage);
			else if(g_annihilator[victim])
				g_leg_dmg_aniq[attacker] += floatround(damage);
			else
				g_leg_dmg[attacker] += floatround(damage);
			
			g_leg_hits[attacker]++;
		}
		
		if(g_wesker[attacker] && !g_hab[attacker][HAB_OTHER][OTHER_COMBO_WESKER])
			return HAM_IGNORED;
		
		// --- Combo System ---
		while(g_combo_damage[attacker] >= (((float(g_combo[attacker]) + 1.0) * 450.0) / g_mult_xp[attacker]))
			g_combo[attacker]++
		
		if(g_combo[attacker] > 0) fnShowCurrentCombo(attacker, floatround(damage))
		
		if(g_annihilation_round)
			return HAM_IGNORED;
		
		remove_task(attacker+TASK_FINISHCOMBO)
		set_task(5.5, "fnFinishCombo_Human", attacker+TASK_FINISHCOMBO)
		
		if(!g_time_cortamambo[attacker])
			g_time_cortamambo[attacker] = get_gametime();
		
		return HAM_IGNORED;
	}
	
	// Attacker is zombie...
	
	// Prevent infection/damage by HE grenade (bugfix)
	if (damage_type & DMG_HEGRENADE)
		return HAM_SUPERCEDE;
	
	if(g_alien[victim])
		entity_get_vector(victim, EV_VEC_velocity, g_alien_push);
	
	// Nemesis, alien or annihilator?
	if (g_nemesis[attacker] || g_alien[attacker] || g_annihilator[attacker] || g_fp[attacker])
	{
		// Ignore damage override if damage comes from a 3rd party entity
		// (to prevent this from affecting a sub-plugin's rockets e.g.)
		if(g_currentweapon[attacker] == CSW_KNIFE)
		{
			// Set damage
			if(g_annihilator[attacker])
			{
				ExecuteHamB(Ham_Killed, victim, attacker, 1)
				return HAM_IGNORED;
			}
			else if(get_user_button(attacker) & IN_ATTACK) damage = 350.0
			else if(get_user_button(attacker) & IN_ATTACK2) damage = 700.0
			
			damage += g_dmg_nem[attacker];
			
			if(g_alien[attacker] && !g_predator[victim])
				damage = 75.0;
			
			SetHamParamFloat(4, damage)
		}
		else if(g_annihilator[attacker] && g_currentweapon[attacker] == CSW_MAC10)
		{
			ExecuteHamB(Ham_Killed, victim, attacker, 1)
			gl_kill_mac10[attacker]++
		}
		
		return HAM_IGNORED;
	}
	
	// Get victim armor
	static armor
	armor = get_user_armor(victim)
	
	// If he has some, block the infection and reduce armor instead
	if(float(armor) > 0.0 && !g_firstzombie[attacker])
	{
		damage += g_zombie_dmg[attacker] - 10.0 // -10 para fixear un error del daño de la habilidad
	
		emit_sound(victim, CHAN_BODY, sound_armorhit, 1.0, ATTN_NORM, 0, PITCH_NORM)
		if (float(armor) - damage > 0.0)
			set_user_armor(victim, floatround(float(armor) - damage))
		else
			cs_set_user_armor(victim, 0, CS_ARMOR_NONE)
		
		return HAM_SUPERCEDE;
	}
	
	// Last human or not an infection round
	if(g_survround ||
	g_survivor[victim] ||
	g_nemround ||
	g_nemesis[attacker] ||
	g_swarmround ||
	g_duel_final ||
	g_plagueround ||
	g_armageddon_round ||
	g_wesker_round ||
	g_wesker[victim] ||
	g_tribal_round ||
	g_alvspre_round ||
	g_annihilation_round ||
	g_sniper_round ||
	g_sniper[victim] ||
	g_fp_round ||
	fnGetHumans() == 1)
		return HAM_IGNORED; // human is killed
	
	// Infection allowed
	zombieme(victim, attacker, 0, 0, 1, 0, 0, 0) // turn into zombie
	return HAM_SUPERCEDE;
}

// Ham Take Damage Post Forward
public fw_TakeDamage_Post(victim)
{
	// --- Check if victim should be Pain Shock Free ---
	
	// Check if proper CVARs are enabled
	if(g_zombie[victim])
	{
		if(g_nemesis[victim] || g_annihilator[victim]) return;
		else if(!g_lastzombie[victim]) return;
	}
	else if(!g_survivor[victim] && !g_predator[victim] && !g_tribal_human[victim]) return;
	
	// Prevent server crash if entity's private data not initalized
	if(pev_valid(victim) != PDATA_SAFE)
		return;
	
	// Set pain shock free offset
	set_pdata_float(victim, OFFSET_PAINSHOCK, 1.0, OFFSET_LINUX)
}

// Ham Trace Attack Forward
public fw_TraceAttack(victim, attacker, Float:damage, Float:direction[3], tracehandle, damage_type)
{
	// Non-player damage or self damage
	if(victim == attacker || !is_user_valid_connected(attacker))
		return HAM_IGNORED;
	
	// New round starting or round ended
	// Victim shouldn't take damage or victim is frozen
	// Prevent friendly fire
	if(g_newround || g_endround || g_frozen[victim] || g_frozen[attacker] || (!g_duel_final && g_zombie[attacker] == g_zombie[victim]))
		return HAM_SUPERCEDE;
	
	// Fix bubble problem
	/*if(g_bubble_eff[attacker])
		return HAM_SUPERCEDE;*/
	
	if(g_nodamage[victim] && !g_nodamage[attacker] && !g_nemesis[attacker] && !g_alien[attacker] && !g_annihilator[attacker] && !g_fp[attacker])
		return HAM_SUPERCEDE;
	
	if(g_nodamage[victim] && g_nodamage[attacker] && !g_zombie[attacker])
		return HAM_SUPERCEDE;
	
	return HAM_IGNORED;
}

// Ham Reset MaxSpeed Forward
public fw_ResetMaxSpeed_Post(id)
{
	// Player not alive
	if (!hub(id, g_data[BIT_ALIVE]))
		return;
	
	set_player_maxspeed(id)
}

// Ham Use Stationary Gun Forward
public fw_UseStationary(entity, caller, activator, use_type)
{
	// Prevent zombies from using stationary guns
	if (use_type == USE_USING && is_user_valid_connected(caller) && g_zombie[caller])
		return HAM_SUPERCEDE;
	
	return HAM_IGNORED;
}

// Ham Use Stationary Gun Post Forward
public fw_UseStationary_Post(entity, caller, activator, use_type)
{
	// Someone stopped using a stationary gun
	if (use_type == USE_STOPPED && is_user_valid_connected(caller))
		replace_weapon_models(caller, g_currentweapon[caller]) // replace weapon models (bugfix)
}

// Ham Use Pushable Forward
public fw_UsePushable()
{
	return HAM_SUPERCEDE; // Previene el bug de velocidad con las cajas
}

// Ham Weapon Touch Forward
public fw_TouchWeapon(weapon, id)
{
	// Not a player
	if (!is_user_valid_connected(id))
		return HAM_IGNORED;
	
	// Dont pickup weapons if zombie or survivor (+PODBot MM fix)
	if (g_zombie[id] || g_survivor[id] || g_wesker[id] || g_sniper[id] || g_tribal_human[id] || g_predator[id])
		return HAM_SUPERCEDE;
	
	return HAM_IGNORED;
}

// Ham Player Touch Forward
public fw_TouchPlayer_Post(touched, toucher)
{
	if(!is_user_valid_alive(touched) || !is_user_valid_alive(toucher) || !g_zombie[touched] || !g_zombie[toucher] || g_nemesis[touched] || g_nemesis[toucher])
		return HAM_IGNORED;
	
	if(g_hab[touched][HAB_ZOMBIE][ZOMBIE_FIRE] >= 3 || g_hab[toucher][HAB_ZOMBIE][ZOMBIE_FIRE] >= 3)
		return HAM_IGNORED;
	
	if((g_burning_duration[touched] && g_burning_duration[toucher]) || (!g_burning_duration[touched] && !g_burning_duration[toucher]))
		return HAM_IGNORED;
	
	new in_fire, not_fire;
	if(g_burning_duration[touched] && !g_burning_duration[toucher])
	{
		in_fire = touched;
		not_fire = toucher;
	}
	else if(!g_burning_duration[touched] && g_burning_duration[toucher])
	{
		in_fire = toucher;
		not_fire = touched;
	}
	
	g_burning_duration[not_fire] = g_burning_duration[in_fire];
	
	// Set burning task on victim if not present
	if(!task_exists(not_fire+TASK_BURN))
		set_task(0.2, "burning_flame", not_fire+TASK_BURN, _, _, "b")
	
	return HAM_IGNORED;
}

// Ham Player Touch Alien
public fw_TouchAlien(ent, id)
{
	if(!is_user_valid_alive(id) || !g_alien[id] || !pev_valid(id))
		return FMRES_IGNORED;
	
	entity_get_vector(id, EV_VEC_origin, g_alien_origin);
	
	return FMRES_IGNORED;
}

// Ham Grenade Touch Forward
public fw_TouchGrenade(grenade, ent)
{
	if(is_valid_ent(grenade) &&
	(entity_get_int(grenade, EV_NADE_TYPE) == NADE_TYPE_INFECTION ||
	entity_get_int(grenade, EV_NADE_TYPE) == NADE_TYPE_GRENADE ||
	entity_get_int(grenade, EV_NADE_TYPE) == NADE_TYPE_NAPALM ||
	entity_get_int(grenade, EV_NADE_TYPE) == NADE_TYPE_FROST ||
	entity_get_int(grenade, EV_NADE_TYPE) == NADE_TYPE_ANNIHILATION ||
	entity_get_int(grenade, EV_NADE_TYPE) == NADE_TYPE_ANTIDOTE) &&
	is_solid(ent))
		entity_set_float(grenade, EV_FL_dmgtime, get_gametime() + 0.001)
}

/*public fw_BubbleTouch(bubble, id)
{
	if(is_valid_ent(bubble) && is_user_valid_alive(id) && g_zombie[id] && !g_nemesis[id] && !g_alien[id] && !g_annihilator[id] && !g_nodamage[id])
	{
		static Float:fEntityOrigin[3];
		static Float:fDistance;
		static Float:fOrigin[3];
		
		entity_get_vector(bubble, EV_VEC_origin, fEntityOrigin);
		entity_get_vector(id, EV_VEC_origin, fOrigin);
		
		fDistance = get_distance_f(fEntityOrigin, fOrigin);
		
		xs_vec_sub(fOrigin, fEntityOrigin, fOrigin);
		xs_vec_normalize(fOrigin, fOrigin);
		xs_vec_mul_scalar(fOrigin, (fDistance - 180.0) * -10, fOrigin);
		
		entity_set_vector(id, EV_VEC_velocity, fOrigin);
	}
}*/

// Ham Rocket Bazooka Touch Forward
public fw_TouchRocketBazooka(rocket, toucher)
{
	if(is_valid_ent(rocket))
	{
		static iVictim, iAttacker, iKills
		static Float:flDamage, Float:flMaxDamage, Float:flDistance, Float:flFadeAlpha, Float:flRadius, Float:flVictimHealth
		static Float:flEntityOrigin[3]
		
		iAttacker = entity_get_edict(rocket, EV_ENT_owner)
		
		flRadius = (g_hab[iAttacker][HAB_NEM][NEM_BAZOOKA_RADIUS]) ? 750.0 : 500.0;
		flMaxDamage = 2500.0
		entity_get_vector(rocket, EV_VEC_origin, flEntityOrigin)
		
		iKills = 0
		iVictim = -1
		
		fn_rocket_blast(rocket, flEntityOrigin)
		
		if((toucher > 0) && is_valid_ent(toucher))
		{
			static szTchClass[32]
			entity_get_string(toucher, EV_SZ_classname, szTchClass, charsmax(szTchClass))
			
			if(equal(szTchClass, "func_breakable"))
				force_use(rocket, toucher)
			
			else if(equal(szTchClass, "player") && is_user_valid_alive(toucher))
			{
				if(!g_zombie[toucher])
					ExecuteHamB(Ham_Killed, toucher, iAttacker, 2)
			}
		}
		
		PlaySound(g_sSoundBazooka_3)
		
		while((iVictim = find_ent_in_sphere(iVictim, flEntityOrigin, flRadius)) != 0)
		{
			if(!is_user_valid_connected(iVictim))
				continue;
			
			if(!is_user_alive(iVictim) || (g_zombie[iVictim] && iVictim != iAttacker))
				continue;
			
			flDistance = entity_range(rocket, iVictim)
			
			flDamage = floatradius(flMaxDamage, flRadius, flDistance)
			flFadeAlpha = floatradius(255.0, flRadius, flDistance)
			flVictimHealth = entity_get_float(iVictim, EV_FL_health)
			
			if(flDamage > 0)
			{
				if(flVictimHealth <= flDamage)
				{
					ExecuteHamB(Ham_Killed, iVictim, iAttacker, 2)
					iKills++;
					//g_anniq_kill++;
				}
				else
				{
					ExecuteHam(Ham_TakeDamage, iVictim, rocket, iAttacker, flDamage, DMG_BLAST)
					message_begin(MSG_ONE_UNRELIABLE, g_msgScreenFade, _, iVictim)
					write_short(UNIT_SECOND*1) // duration
					write_short(UNIT_SECOND*1) // hold time
					write_short(FFADE_IN) // fade type
					write_byte(200) // r
					write_byte(0) // g
					write_byte(0) // b
					write_byte(floatround(flFadeAlpha)) // alpha
					message_end()
					
					message_begin(MSG_ONE_UNRELIABLE, g_msgScreenShake, _, iVictim)
					write_short(UNIT_SECOND*14) // amplitude
					write_short(UNIT_SECOND*3) // duration
					write_short(UNIT_SECOND*14) // frequency
					message_end()
				}
			}
		}
		
		if(g_nemesis[iAttacker])
		{
			if(iKills >= 20)
				fn_update_logro(iAttacker, LOGRO_NEM, BAZOOKASO)
			else if(!iKills && fnGetAlive() >= 20)
				fn_give_hat(iAttacker, HAT_CHEESEFACE)
		}
		else if(g_annihilator[iAttacker])
		{
			gl_kill_bazooka[iAttacker] += iKills;
			
			if(gl_kill_bazooka[iAttacker] >= 80)
				fn_update_logro(iAttacker, LOGRO_ANNIHILATOR, BAZOOKA_80)
		}
		
		if(is_user_valid_connected(iAttacker) && hub(iAttacker, g_data[BIT_ALIVE]) && iKills != 0 && (g_nemesis[iAttacker] || g_annihilator[iAttacker]))
		{
			// Get health value
			static iMultValue
			iMultValue = iKills * 500
			
			// Give Health
			set_user_health(iAttacker, get_user_health(iAttacker) + iMultValue)
		}
		
		fn_remove_rocket_flare(rocket)
		remove_entity(rocket)
	}
}

// Ham Weapon Pickup Forward
public fw_AddPlayerItem(id, weapon_ent)
{
	// HACK: Retrieve our custom extra ammo from the weapon
	static extra_ammo
	extra_ammo = entity_get_int(weapon_ent, EV_ADDITIONAL_AMMO)
	
	// If present
	if (extra_ammo)
	{
		// Get weapon's id
		static weaponid
		weaponid = cs_get_weapon_id(weapon_ent)
		
		// Add to player's bpammo
		ExecuteHamB(Ham_GiveAmmo, id, extra_ammo, AMMOTYPE[weaponid], MAXBPAMMO[weaponid])
		entity_set_int(weapon_ent, EV_ADDITIONAL_AMMO, 0)
	}
}

// Ham Weapon Deploy Forward
public fw_Item_Deploy_Post(weapon_ent)
{
	// Valid ent ?
	if(!pev_valid(weapon_ent))
		return;
	
	// Get weapon's owner
	static owner
	owner = fm_cs_get_weapon_ent_owner(weapon_ent)
	
	// Valid owner?
	if(!pev_valid(owner))
		return;
	
	// Get weapon's id
	static weaponid
	weaponid = cs_get_weapon_id(weapon_ent)
	
	// Store current weapon's id for reference
	g_currentweapon[owner] = weaponid
	
	g_primary_weapon[owner] = ((1 << weaponid) & PRIMARY_WEAPONS_BIT_SUM) ? 1 : ((1 << weaponid) & SECONDARY_WEAPONS_BIT_SUM) ? 0 : -1
	
	// Replace weapon models with custom ones
	replace_weapon_models(owner, weaponid)
	
	// Zombie not holding an allowed weapon for some reason
	if((g_zombie[owner] && !((1<<weaponid) & ZOMBIE_ALLOWED_WEAPONS_BITSUM)))
	{
		// Switch to knife
		g_currentweapon[owner] = CSW_KNIFE
		engclient_cmd(owner, "weapon_knife")
	}
}

// Ham Weapon Primary Attack Forward
public fw_Weapon_PrimaryAttack_Post(weapon_ent)
{
	// Valid ent ?
	if(!pev_valid(weapon_ent))
		return HAM_IGNORED;

	// Get weapon's owner
	static owner
	owner = fm_cs_get_weapon_ent_owner(weapon_ent)
	
	// Valid owner, zombie or survivor ?
	if(!pev_valid(owner) || !is_user_valid_alive(owner) || (g_zombie[owner] && !g_fp[owner]) || g_wesker[owner] || g_tribal_human[owner] || g_predator[owner])
		return HAM_IGNORED;
	
	if(g_fp[owner] && g_currentweapon[owner] == CSW_KNIFE)
	{
		static Float:speed
		speed = 0.08;
		
		set_pdata_float(weapon_ent, OFFSET_NEXT_PRIMARY_ATTACK, speed, 4)
		set_pdata_float(weapon_ent, OFFSET_NEXT_SECONDARY_ATTACK, speed, 4)
		set_pdata_float(weapon_ent, OFFSET_TIME_WEAPON_IDLE, speed, 4)
		
		return HAM_IGNORED;
	}
	
	switch(g_currentweapon[owner])
	{
		case CSW_AWP:
		{
			if(!g_weapon[owner][PRIMARY_WEAPON][AWP] && !g_sniper[owner])
				return HAM_IGNORED;
			
			entity_set_vector(owner, EV_FLARE_COLOR, Float:{0.0, 0.0, 0.0})
			
			if(g_sniper[owner] && g_sniper_power[owner] < 1)
				return HAM_IGNORED;
			
			static Float:speed;
			speed = 0.4;
			
			set_pdata_float(weapon_ent, OFFSET_NEXT_PRIMARY_ATTACK, speed, 4)
			set_pdata_float(weapon_ent, OFFSET_NEXT_SECONDARY_ATTACK, speed, 4)
			set_pdata_float(weapon_ent, OFFSET_TIME_WEAPON_IDLE, speed, 4)
		}
		case CSW_G3SG1:
		{
			if(!g_weapon[owner][PRIMARY_WEAPON][G3SG1]) return HAM_IGNORED;
			static Float:speed
			speed = 0.9
			
			set_pdata_float(weapon_ent, OFFSET_NEXT_PRIMARY_ATTACK, speed, 4)
			set_pdata_float(weapon_ent, OFFSET_NEXT_SECONDARY_ATTACK, speed, 4)
			set_pdata_float(weapon_ent, OFFSET_TIME_WEAPON_IDLE, speed, 4)
		}
		case CSW_MP5NAVY:
		{
			if(!g_survivor[owner])
				return HAM_IGNORED;
		
			if(!g_hab[owner][HAB_SURV][SURV_SPEED_WEAPON])
				return HAM_IGNORED;
		
			static Float:speed
			speed = 0.08 - (g_hab[owner][HAB_SURV][SURV_SPEED_WEAPON] * 0.008);
			
			set_pdata_float(weapon_ent, OFFSET_NEXT_PRIMARY_ATTACK, speed, 4)
			set_pdata_float(weapon_ent, OFFSET_NEXT_SECONDARY_ATTACK, speed, 4)
			set_pdata_float(weapon_ent, OFFSET_TIME_WEAPON_IDLE, speed, 4)
		}
		case CSW_ELITE:
		{
			if(check_access(owner, 1) && get_pdata_int(weapon_ent, OFFSET_CLIPAMMO, 4) > 0)
			{
				user_shoot[owner] = 1;
				
				set_pdata_float(weapon_ent, OFFSET_NEXT_PRIMARY_ATTACK, user_shoot_speed, 4)
				set_pdata_float(weapon_ent, OFFSET_NEXT_SECONDARY_ATTACK, user_shoot_speed, 4)
				set_pdata_float(weapon_ent, OFFSET_TIME_WEAPON_IDLE, user_shoot_speed, 4)
			}
		}
		case CSW_M4A1:
		{
			if(g_weap_leg_choose[owner])
			{
				static Float:def_recoil[3];
				entity_get_vector(owner, EV_VEC_punchangle, def_recoil);
				
				def_recoil[0] -= (0.02 * g_leg_habs[owner][2])
				
				static Float:def_speed[3];
				def_speed[0] = get_pdata_float(weapon_ent, OFFSET_NEXT_PRIMARY_ATTACK, OFFSET_LINUX_WEAPONS);
				def_speed[1] = get_pdata_float(weapon_ent, OFFSET_NEXT_SECONDARY_ATTACK, OFFSET_LINUX_WEAPONS);
				def_speed[2] = get_pdata_float(weapon_ent, OFFSET_TIME_WEAPON_IDLE, OFFSET_LINUX_WEAPONS);
				
				def_speed[0] -= (0.02 * g_leg_habs[owner][1])
				def_speed[1] -= (0.02 * g_leg_habs[owner][1])
				def_speed[2] -= (0.02 * g_leg_habs[owner][1])
				
				entity_set_vector(owner, EV_VEC_punchangle, def_recoil);
				
				set_pdata_float(weapon_ent, OFFSET_NEXT_PRIMARY_ATTACK, def_speed[0], OFFSET_LINUX_WEAPONS)
				set_pdata_float(weapon_ent, OFFSET_NEXT_SECONDARY_ATTACK, def_speed[1], OFFSET_LINUX_WEAPONS)
				set_pdata_float(weapon_ent, OFFSET_TIME_WEAPON_IDLE, def_speed[2], OFFSET_LINUX_WEAPONS)
			}
		}
	}
	
	return HAM_IGNORED;
}

public fw_Sg550_Zoom(sg550)
	return HAM_SUPERCEDE;

// Ham Player Jump Forward
public fw_PlayerJump(id)
{
	if(!hub(id, g_data[BIT_ALIVE]) || !g_longjump[id])
		return HAM_IGNORED;

	static iFlags; iFlags = entity_get_int(id, EV_INT_flags)

	if(iFlags & FL_WATERJUMP || entity_get_int(id, EV_INT_waterlevel) >= 2)
		return HAM_IGNORED;

	const XTRA_OFS_PLAYER = 5
	const m_afButtonPressed = 246
	
	static afButtonPressed; afButtonPressed = get_pdata_int(id, m_afButtonPressed, XTRA_OFS_PLAYER)

	if(!(afButtonPressed & IN_JUMP) || !(iFlags & FL_ONGROUND))
		return HAM_IGNORED;

	const m_fLongJump = 356

	if((entity_get_int(id, EV_INT_bInDuck) || iFlags & FL_DUCKING)
	&& get_pdata_int(id, m_fLongJump, XTRA_OFS_PLAYER)
	&& entity_get_int(id, EV_INT_button) & IN_DUCK
	&& entity_get_int(id, EV_INT_flDuckTime))
	{
		static Float:fVecTemp[3], iVelMin;
		entity_get_vector(id, EV_VEC_velocity, fVecTemp)
		if(g_zr_pj[id] == 1) iVelMin = 2;
		else iVelMin = 20
		
		if(vector_length(fVecTemp) > iVelMin) // MINIMA VELOCIDAD PARA EL LJ
		{
			const m_Activity = 73
			const m_IdealActivity = 74

			const PLAYER_SUPERJUMP = 7
			const ACT_LEAP = 8

			entity_get_vector(id, EV_FLARE_COLOR, fVecTemp)
			fVecTemp[0] = -5.0 // PUSH DEL LJ
			entity_set_vector(id, EV_FLARE_COLOR, fVecTemp)

			get_global_vector(GL_v_forward, fVecTemp)
			
			// VELOCIDAD DEL LJ
			static Float:flLongJumpSpeed, Float:flLongJumpAlture;
			
			flLongJumpSpeed = 360.0 * 1.6
			flLongJumpAlture = 310.0
			
			fVecTemp[0] *= flLongJumpSpeed
			fVecTemp[1] *= flLongJumpSpeed
			fVecTemp[2] = flLongJumpAlture // ALTURA DEL LJ

			entity_set_vector(id, EV_VEC_velocity, fVecTemp)

			set_pdata_int(id, m_Activity, ACT_LEAP, XTRA_OFS_PLAYER)
			set_pdata_int(id, m_IdealActivity, ACT_LEAP, XTRA_OFS_PLAYER)
			sub(id, g_bSuperJump)

			entity_set_int(id, EV_INT_oldbuttons, entity_get_int(id, EV_INT_oldbuttons) | IN_JUMP)

			entity_set_int(id, EV_INT_gaitsequence, PLAYER_SUPERJUMP)
			entity_set_float(id, EV_FL_frame, 0.0)

			set_pdata_int(id, m_afButtonPressed, afButtonPressed & ~IN_JUMP, XTRA_OFS_PLAYER)
			
			return HAM_SUPERCEDE;
		}
	}
	return HAM_IGNORED;
}

// Ham Player Duck Forward
public fw_PlayerDuck(id)
{
	if(hub(id, g_bSuperJump))
	{
		cub(id, g_bSuperJump)
		return HAM_SUPERCEDE;
	}

	return HAM_IGNORED;
}

// WeaponMod bugfix
//forward wpn_gi_reset_weapon(id);
public wpn_gi_reset_weapon(id)
{
	// Replace knife model
	replace_weapon_models(id, CSW_KNIFE)
}

// Client joins authorized ?
/*public client_authorized(id)
{
	new iUsers[33];
	new iCount = -1;
	new iRandomUser;
	new iMaxUsers;
	new iUsersConnected;
	
	iUsersConnected = get_playersnum(1);
	iMaxUsers = g_maxplayers - 1;
	
	if(iUsersConnected > iMaxUsers)
	{
		if(check_access(id, 1) || access(id, ADMIN_RESERVATION))
		{
			new i;
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(is_user_connecting(i))
					continue;
				
				if(!is_user_connected(i))
					continue;
				
				if(check_access(i, 1))
					continue;
				
				if(get_user_flags(i) & ADMIN_RESERVATION)
					continue;
				
				if(is_user_bot(i))
					continue;
				
				if(is_user_hltv(i))
					continue;
				
				iUsers[++iCount] = i;
			}
			
			iRandomUser = iUsers[random_num(0, iCount)];
			
			console_print(get_user_userid(iRandomUser), "Un usuario Premium ha ocupado tu lugar. Consegui tu cuenta en http://www.taringacs.net/premium/");
			server_cmd("kick #%d ^"Un usuario Premium ha ocupado tu lugar. Consegui tu cuenta en http://www.taringacs.net/premium/^"", get_user_userid(iRandomUser));
		}
		else
			server_cmd("kick #%d ^"El servidor esta lleno. Consegui tu cuenta premium ingresando en http://www.taringacs.net/premium/^"", get_user_userid(id));
	}
}*/

// Client joins the game
public client_putinserver(id)
{
	// Initialize player vars
	reset_vars(id, 1)
	
	g_camera[id] = 0
	
#if defined EVENT_SEMANA_INFECCION
	maxInfects[id] = infectsInRound[id] = maxInfectsInRound[id] = infectsCombo[id] = maxInfectsCombo[id] = 0;
#endif
	
	// Player joined
	sub(id, g_data[BIT_CONNECTED])
	
	// Cache steam id
	get_user_authid(id, g_steamid[id], charsmax(g_steamid[]))
	
	// Cache player's name
	get_user_name(id, g_playername[id], charsmax(g_playername[]))
	
	// Characters not acepted for the sql
	replace_all(g_playername[id], charsmax(g_playername[]), "\", "")
	replace_all(g_playername[id], charsmax(g_playername[]), "/", "")
	replace_all(g_playername[id], charsmax(g_playername[]), "DROP TABLE", "")
	replace_all(g_playername[id], charsmax(g_playername[]), "TRUNCATE", "")
	replace_all(g_playername[id], charsmax(g_playername[]), "INSERT INTO", "")
	replace_all(g_playername[id], charsmax(g_playername[]), "INSERT UPDATE", "")
	replace_all(g_playername[id], charsmax(g_playername[]), "UPDATE", "")
	if(equali(g_playername[id], "NO HUBO APOSTADORES"))
		formatex(g_playername[id], charsmax(g_playername[]), "player")
	
	set_task(0.2, "load", id)
	set_task(5.0, "disable_minmodels", id)
	set_task(20.0, "recomendated_resolution", id)
	set_task(360.0, "time_playing", id+TASK_TIME_PLAYING, _, _, "b")
	set_task(5.0, "lighting_effects");
}

// Client leaving
public client_disconnect(id)
{
	saveKK(id)
	remove_entity(g_hat_ent[id])
}
public fw_ClientDisconnect(id)
{
	// Check that we still have both humans and zombies to keep the round going
	if (hub(id, g_data[BIT_ALIVE])) check_round(id)
	
	// Remove previous tasks
	remove_task(id+TASK_TEAM)
	remove_task(id+TASK_MODEL)
	remove_task(id+TASK_SPAWN)
	remove_task(id+TASK_BLOOD)
	remove_task(id+TASK_AURA)
	remove_task(id+TASK_BURN)
	remove_task(id+TASK_NVISION)
	remove_task(id+TASK_TIME_PLAYING)
	remove_task(id+TASK_FINISHCOMBO)
	remove_task(id+TASK_FROZEN)
	remove_task(id+TASK_SLOWDOWN)
	remove_task(id+TASK_MSG_SURV)
	remove_task(id+TASK_SAVE1)
	remove_task(id+TASK_IMMUNITY)
	
#if defined EVENT_SEMANA_INFECCION
	remove_task(id+TASK_FINISHCOMBO_INFECT)
#endif
	
	// Player left, clear cached flags
	cub(id, g_data[BIT_CONNECTED]);
	cub(id, g_data[BIT_ALIVE]);
}

// Client left
public fw_ClientDisconnect_Post()
{
	// Last Zombie Check
	fnCheckLastZombie()
}

// Client Kill Forward
public fw_ClientKill()
{
	return FMRES_SUPERCEDE;
}

// Emit Sound Forward
public fw_EmitSound(id, channel, const sample[], Float:volume, Float:attn, flags, pitch)
{
	if(equal(sample[0], "hostage", 7) ||
	!is_user_valid_connected(id) ||
	equal(sample[10], "fall", 4))
		return FMRES_SUPERCEDE;
	
	if(!g_zombie[id])
		return FMRES_IGNORED;
	
	if(equal(sample[7], "bhit", 4))
	{
		if (g_nemesis[id] || g_annihilator[id]) emit_sound(id, channel, g_sSoundNemesisPain[random_num(0, charsmax(g_sSoundNemesisPain))], volume, attn, flags, pitch)
		else emit_sound(id, channel, g_sSoundZombiePain[random_num(0, charsmax(g_sSoundZombiePain))], volume, attn, flags, pitch)
		
		return FMRES_SUPERCEDE;
	}
	
	if(equal(sample[8], "kni", 3)) // knife
	{
		if(equal(sample[14], "sla", 3)) // slash
		{
			emit_sound(id, channel, g_sSoundZombieMissSlash[random_num(0, charsmax(g_sSoundZombieMissSlash))], volume, attn, flags, pitch)
			return FMRES_SUPERCEDE;
		}
		
		if(equal(sample[14], "hit", 3)) // hit
		{
			if(equal(sample[17], "w", 1)) emit_sound(id, channel, g_sSoundZombieMissWall[random_num(0, charsmax(g_sSoundZombieMissWall))], volume, attn, flags, pitch)
			else emit_sound(id, channel, g_sSoundZombieHitNormal[random_num(0, charsmax(g_sSoundZombieHitNormal))], volume, attn, flags, pitch)
			
			return FMRES_SUPERCEDE;
		}
		
		if(equal(sample[14], "sta", 3)) // stab
		{
			emit_sound(id, channel, g_sSoundZombieHitStab[random_num(0, charsmax(g_sSoundZombieHitStab))], volume, attn, flags, pitch)
			return FMRES_SUPERCEDE;
		}
	}
	
	if(equal(sample[7], "die", 3) || equal(sample[7], "dea", 3))
	{
		emit_sound(id, channel, g_sSoundZombieDie[random_num(0, charsmax(g_sSoundZombieDie))], volume, attn, flags, pitch)
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}

// Forward Set ClientKey Value -prevent CS from changing player models-
public fw_SetClientKeyValue(id, const infobuffer[], const key[])
{
	// Block CS model changes
	if(key[0] == 'm' && key[1] == 'o' && key[2] == 'd' && key[3] == 'e' && key[4] == 'l')
		return FMRES_SUPERCEDE;
	
	// Block CS name changes
	if(key[0] == 'n' && key[1] == 'a' && key[2] == 'm' && key[3] == 'e')
		return FMRES_SUPERCEDE;
	
	return FMRES_IGNORED;
}

// Forward Client User Info Changed -prevent players from changing models-
public fw_ClientUserInfoChanged(id, buffer)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return FMRES_IGNORED;
	
	// Get current model
	static currentmodel[32]
	fm_cs_get_user_model(id, currentmodel, charsmax(currentmodel))
	
	// If they're different, set model again
	if (!equal(currentmodel, g_playermodel[id]) && !task_exists(id+TASK_MODEL))
		fm_cs_set_user_model(id+TASK_MODEL)
	
	// Cache new player's name
	static new_name[32]
	engfunc(EngFunc_InfoKeyValue, buffer, "name", new_name, charsmax(new_name))
	
	if(equal(new_name, g_playername[id]))
		return FMRES_IGNORED;
	
	engfunc(EngFunc_SetClientKeyValue, id, buffer, "name", g_playername[id])
	client_cmd(id, "name ^"%s^"; setinfo name ^"%s^"", g_playername[id], g_playername[id])
	
	console_print(id, "No podes cambiarte el nombre dentro del servidor")
	
	/*if(hub(id, g_data[BIT_CHANGE_NAME]))
	{
		// Cache player's name
		get_user_name(id, g_playername[id], charsmax(g_playername[]))
	
		// Characters not acepted for the sql
		replace_all(g_playername[id], charsmax(g_playername[]), "\", "")
		replace_all(g_playername[id], charsmax(g_playername[]), "/", "")
		replace_all(g_playername[id], charsmax(g_playername[]), "DROP TABLE", "")
		replace_all(g_playername[id], charsmax(g_playername[]), "TRUNCATE", "")
		replace_all(g_playername[id], charsmax(g_playername[]), "INSERT INTO", "")
		replace_all(g_playername[id], charsmax(g_playername[]), "INSERT UPDATE", "")
		replace_all(g_playername[id], charsmax(g_playername[]), "UPDATE", "")
		
		if(equali(g_playername[id], "NO HUBO APOSTADORES"))
			formatex(g_playername[id], charsmax(g_playername[]), "player")
		
		return FMRES_SUPERCEDE;
	}
	else
	{
		engfunc(EngFunc_SetClientKeyValue, id, buffer, "name", g_playername[id])
		client_cmd(id, "name ^"%s^"; setinfo name ^"%s^"", g_playername[id], g_playername[id])
		
		console_print(id, "No podes cambiarte el nombre una vez identificado en el juego")
	}*/
	
	return FMRES_SUPERCEDE;
}

// Forward Set Model
public fw_SetModel(entity, const model[])
{
	if(strlen(model) < 8)
		return FMRES_IGNORED;
	
	static classname[10]
	entity_get_string(entity, EV_SZ_classname, classname, charsmax(classname))
	
	if(equal(classname, "weaponbox"))
	{
		entity_set_float(entity, EV_FL_nextthink, get_gametime() + 0.01)
		return FMRES_IGNORED;
	}
	
	// Narrow down our matches a bit
	if(model[7] != 'w' || model[8] != '_')
		return FMRES_IGNORED;
	
	// Get damage time of grenade
	static Float:dmgtime
	dmgtime = entity_get_float(entity, EV_FL_dmgtime)
	
	// Grenade not yet thrown
	if(dmgtime == 0.0)
		return FMRES_IGNORED;
	
	new id = entity_get_edict(entity, EV_ENT_owner);
	
	// Get whether grenade's owner is a zombie
	if(g_zombie[id])
	{
		if(model[9] == 'h' && model[10] == 'e') // Infection Bomb
		{
			// Give it a glow
			fm_set_rendering(entity, kRenderFxGlowShell, 0, 200, 0, kRenderNormal, 16);
			
			// And a colored trail
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_BEAMFOLLOW) // TE id
			write_short(entity) // entity
			write_short(g_trailSpr) // sprite
			write_byte(10) // life
			write_byte(10) // width
			write_byte(0) // r
			write_byte(200) // g
			write_byte(0) // b
			write_byte(200) // brightness
			message_end()
			
			// Set grenade type on the thrown grenade entity
			entity_set_int(entity, EV_NADE_TYPE, NADE_TYPE_INFECTION)
			entity_set_float(entity, EV_FL_dmgtime, get_gametime() + 9999.0)
		}
		else if (model[9] == 's' && model[10] == 'm') // Antidote Bomb
		{
			// Give it a glow
			fm_set_rendering(entity, kRenderFxGlowShell, 0, 255, 255, kRenderNormal, 16);
			
			// And a colored trail
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_BEAMFOLLOW) // TE id
			write_short(entity) // entity
			write_short(g_trailSpr) // sprite
			write_byte(10) // life
			write_byte(10) // width
			write_byte(0) // r
			write_byte(255) // g
			write_byte(255) // b
			write_byte(25) // brightness
			message_end()
			
			// Set grenade type on the thrown grenade entity
			entity_set_int(entity, EV_NADE_TYPE, NADE_TYPE_ANTIDOTE)
			entity_set_float(entity, EV_FL_dmgtime, get_gametime() + 9999.0)
		}
	}
	else if(model[9] == 'h' && model[10] == 'e') // Napalm Grenade
	{
		if(g_survivor[id] && g_bomb_aniq[id])
		{
			// Give it a glow
			fm_set_rendering(entity, kRenderFxGlowShell, 255, 255, 0, kRenderNormal, 16);
			
			// And a colored trail
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_BEAMFOLLOW) // TE id
			write_short(entity) // entity
			write_short(g_trailSpr) // sprite
			write_byte(4) // life
			write_byte(5) // width
			write_byte(255) // r
			write_byte(255) // g
			write_byte(0) // b
			write_byte(255) // brightness
			message_end()
			
			// Set grenade type on the thrown grenade entity
			g_bomb_aniq[id]--
			entity_set_int(entity, EV_NADE_TYPE, NADE_TYPE_ANNIHILATION)
			
			entity_set_float(entity, EV_FL_dmgtime, get_gametime() + 9999.0)
		}
		else if(g_pipe[id])
		{
			fm_set_rendering(entity, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 16);
			
			// And a colored trail
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_BEAMFOLLOW) // TE id
			write_short(entity) // entity
			write_short(g_trailSpr) // sprite
			write_byte(5) // life
			write_byte(1) // width
			write_byte(255) // r
			write_byte(0) // g
			write_byte(0) // b
			write_byte(255) // brightness
			message_end()
			
			set_task(1.0, "fn_EffectPipeSound", entity, _, _, "b")
			
			// Set grenade type on the thrown grenade entity
			g_pipe[id]--
			entity_set_int(entity, EV_NADE_TYPE, NADE_TYPE_PIPE)
			
			engfunc(EngFunc_SetModel, entity, g_model_wgrenade_pipe)
			
			replace_weapon_models(id, CSW_HEGRENADE)
			
			return FMRES_SUPERCEDE;
		}
		else
		{
			// Give it a glow
			fm_set_rendering(entity, kRenderFxGlowShell, 200, 0, 0, kRenderNormal, 16);
			
			// And a colored trail
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_BEAMFOLLOW) // TE id
			write_short(entity) // entity
			write_short(g_trailSpr) // sprite
			write_byte(10) // life
			write_byte(10) // width
			write_byte(200) // r
			write_byte(0) // g
			write_byte(0) // b
			write_byte(200) // brightness
			message_end()
			
			// Set grenade type on the thrown grenade entity
			if(g_grenade[id] >= 1)
			{
				g_grenade[id]--
				entity_set_int(entity, EV_NADE_TYPE, NADE_TYPE_GRENADE)
			}
			else entity_set_int(entity, EV_NADE_TYPE, NADE_TYPE_NAPALM)
			
			entity_set_float(entity, EV_FL_dmgtime, get_gametime() + 9999.0)
		}
	}
	else if(model[9] == 'f' && model[10] == 'l') // Frost Grenade
	{
		// Give it a glow
		fm_set_rendering(entity, kRenderFxGlowShell, 0, 100, 200, kRenderNormal, 16);
		
		// And a colored trail
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_BEAMFOLLOW) // TE id
		write_short(entity) // entity
		write_short(g_trailSpr) // sprite
		write_byte(10) // life
		write_byte(10) // width
		write_byte(0) // r
		write_byte(100) // g
		write_byte(200) // b
		write_byte(200) // brightness
		message_end()
		
		// Set grenade type on the thrown grenade entity
		entity_set_int(entity, EV_NADE_TYPE, NADE_TYPE_FROST)
		entity_set_float(entity, EV_FL_dmgtime, get_gametime() + 9999.0)
	}
	else if (model[9] == 's' && model[10] == 'm') // Flare
	{
		// Build flare's color
		static Float:rgb[3]
		
		// Set grenade type on the thrown grenade entity
		if(g_bubble[id] >= 1)
		{
			rgb[0] = float(g_color[id][COLOR_BUBBLE][0])
			rgb[1] = float(g_color[id][COLOR_BUBBLE][1])
			rgb[2] = float(g_color[id][COLOR_BUBBLE][2])
			
			// Give it a glow
			fm_set_rendering(entity, kRenderFxGlowShell, floatround(rgb[0]), floatround(rgb[1]), floatround(rgb[2]), kRenderNormal, 16);
			
			// And a colored trail
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_BEAMFOLLOW) // TE id
			write_short(entity) // entity
			write_short(g_trailSpr) // sprite
			write_byte(10) // life
			write_byte(10) // width
			write_byte(floatround(rgb[0])) // r
			write_byte(floatround(rgb[1])) // g
			write_byte(floatround(rgb[2])) // b
			write_byte(255) // brightness
			message_end()
			
			// Set flare color on the thrown grenade entity
			entity_set_vector(entity, EV_FLARE_COLOR, rgb)
			
			g_bubble[id]--
			
			//entity_set_int(entity, EV_NADE_TYPE, NADE_TYPE_FLARE)
			entity_set_int(entity, EV_NADE_TYPE, NADE_TYPE_BUBBLE)
		}
		else
		{
			rgb[0] = float(g_color[id][COLOR_LIGHT][0])
			rgb[1] = float(g_color[id][COLOR_LIGHT][1])
			rgb[2] = float(g_color[id][COLOR_LIGHT][2])
			
			// Give it a glow
			fm_set_rendering(entity, kRenderFxGlowShell, floatround(rgb[0]), floatround(rgb[1]), floatround(rgb[2]), kRenderNormal, 16);
			
			// And a colored trail
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_BEAMFOLLOW) // TE id
			write_short(entity) // entity
			write_short(g_trailSpr) // sprite
			write_byte(10) // life
			write_byte(10) // width
			write_byte(floatround(rgb[0])) // r
			write_byte(floatround(rgb[1])) // g
			write_byte(floatround(rgb[2])) // b
			write_byte(255) // brightness
			message_end()
			
			// Set flare color on the thrown grenade entity
			entity_set_vector(entity, EV_FLARE_COLOR, rgb)
			
			entity_set_int(entity, EV_NADE_TYPE, NADE_TYPE_FLARE)
		}
	}
	
	return FMRES_IGNORED;
}

// Ham Grenade Think Forward
public fw_ThinkGrenade(entity)
{
	// Invalid entity
	if(!is_valid_ent(entity)) return HAM_IGNORED;
	
	// Get damage time of grenade
	static Float:dmgtime, Float:current_time
	
	dmgtime = entity_get_float(entity, EV_FL_dmgtime)
	current_time = get_gametime()
	
	// Check if it's time to go off
	if (dmgtime > current_time)
		return HAM_IGNORED;
	
	// Check if it's one of our custom nades
	switch(entity_get_int(entity, EV_NADE_TYPE))
	{
		case NADE_TYPE_INFECTION: // Infection Bomb
		{
			infection_explode(entity)
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_NAPALM: // Napalm Grenade
		{
			fire_explode(entity)
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_FROST: // Frost Grenade
		{
			frost_explode(entity)
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_FLARE: // Flare
		{
			// Get its duration
			new duration
			duration = entity_get_int(entity, EV_FLARE_DURATION)
			
			// Already went off, do lighting loop for the duration of EV_FLARE_DURATION
			if (duration > 0)
			{
				// Check whether this is the last loop
				if (duration == 1)
				{
					// Get rid of the flare entity
					engfunc(EngFunc_RemoveEntity, entity)
					return HAM_SUPERCEDE;
				}
				
				// Light it up!
				flare_lighting(entity, duration, 25)
				
				// Set time for next loop
				entity_set_int(entity, EV_FLARE_DURATION, --duration)
				entity_set_float(entity, EV_FL_dmgtime, current_time + 2.0)
			}
			// Light up when it's stopped on ground
			else if ((get_entity_flags(entity) & FL_ONGROUND) && fm_get_speed(entity) < 10)
			{
				// Flare sound
				emit_sound(entity, CHAN_WEAPON, g_sSoundGrenadeFlare[random_num(0, charsmax(g_sSoundGrenadeFlare))], 1.0, ATTN_NORM, 0, PITCH_NORM)
				
				// Set duration and start lightning loop on next think
				entity_set_int(entity, EV_FLARE_DURATION, 30) // En segundos!
				entity_set_float(entity, EV_FL_dmgtime, current_time + 0.1)
				
				if(g_game_tejos)
				{
					static Float:vecOrigin[3];
					static iId;
					
					entity_get_vector(entity, EV_VEC_origin, vecOrigin);
					iId = entity_get_edict(entity, EV_ENT_owner);
					
					g_distance_tejosid[iId] = get_distance_f(vecOrigin, g_headz_origin);
					g_distance_tejos[g_pos_tejos] = g_distance_tejosid[iId];
					
					++g_pos_tejos;
				}
			}
			else
			{
				// Delay explosion until we hit ground
				entity_set_float(entity, EV_FL_dmgtime, current_time + 1.0)
			}
		}
		case NADE_TYPE_GRENADE: // Grenade
		{
			grenade_explode(entity)
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_BUBBLE: // Flare and Bubble
		{
			if ((get_entity_flags(entity) & FL_ONGROUND) && fm_get_speed(entity) < 10)
			{
				bubble_explode(entity)
				return HAM_SUPERCEDE;
			}
			else
				entity_set_float(entity, EV_FL_dmgtime, current_time + 1.0)
			
			/*static duration
			duration = entity_get_int(entity, EV_FLARE_DURATION)
			
			// Already went off, do lighting loop for the duration of EV_FLARE_DURATION
			if (duration > 0)
			{
				// Check whether this is the last loop
				if (duration == 1)
				{
					static Victima, Float:Origin[3], players[33], i;
					entity_get_vector( entity, EV_VEC_origin, Origin )
					
					Victima = -1
					i = 0
					
					while( ( Victima = find_ent_in_sphere( Victima, Origin, 205.0 ) ) != 0 )
					{
						if(Victima <= g_maxplayers)
						{
							if(is_user_alive(Victima))
								players[i++] = Victima;
						}
					}
				
					// Get rid of the flare entity
					remove_entity(entity)
					
					for(new id; id < i; id++)
					{
						if(!g_zombie[players[id]])
							g_nodamage[players[id]] = 0
					}
					
					return HAM_SUPERCEDE;
				}
				
				// Force Push
				ForcePush(entity)
				
				if(duration % 20 == 0)
				{
					flare_lighting(entity, duration, 18)
				}
				
				// Set time for next loop
				entity_set_int(entity, EV_FLARE_DURATION, --duration)
				entity_set_float(entity, EV_FL_dmgtime, current_time + 0.1)
			}
			// Light up when it's stopped on ground
			else if ((get_entity_flags(entity) & FL_ONGROUND) && fm_get_speed(entity) < 5)
			{
				// Color
				static Float:color[3]
				entity_get_vector(entity, EV_FLARE_COLOR, color)
			
				// Flare sound
				emit_sound(entity, CHAN_BODY, g_sSoundGrenadeFlare[random_num(0, charsmax(g_sSoundGrenadeFlare))], 1.0, ATTN_NORM, 0, PITCH_NORM)
				
				engfunc(EngFunc_SetModel, entity, g_sModel_BubbleNadeAura)
				//entity_set_string(entity, EV_SZ_classname, "grenade_bubble")
				entity_set_vector(entity, EV_VEC_angles, Float:{0.0, 0.0, 0.0})
				fm_set_rendering(entity, kRenderFxGlowShell, floatround(color[0]), floatround(color[1]), floatround(color[2]), kRenderTransTexture, 32)
				
				// Set duration and start lightning loop on next think
				entity_set_int(entity, EV_FLARE_DURATION, 120)
				entity_set_float(entity, EV_FL_dmgtime, current_time + 0.1)
			}
			else
			{
				// Delay explosion until we hit ground
				entity_set_float(entity, EV_FL_dmgtime, get_gametime() + 0.5)
			}*/
		}
		case NADE_TYPE_ANNIHILATION:
		{
			annihilation_explode(entity)
			return HAM_SUPERCEDE;
		}
		case NADE_TYPE_PIPE:
		{
			// Get its duration
			static duration
			duration = entity_get_int(entity, EV_FLARE_DURATION)
			
			// Already went off, do lighting loop for the duration of EV_FLARE_DURATION
			if (duration > 0)
			{
				// Check whether this is the last loop
				if (duration == 1)
				{
					static attacker
					attacker = entity_get_edict(entity, EV_ENT_owner)
					
					if(!is_user_valid_connected(attacker))
					{
						// Get rid of the grenade
						engfunc(EngFunc_RemoveEntity, entity)
						return HAM_SUPERCEDE;
					}
					
					static Float:originF[3]
					entity_get_vector(entity, EV_VEC_origin, originF)
					
					// Make the explosion
					create_blast(originF, 200, 100, 0)
					
					// Sprite
					engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0)
					write_byte(TE_EXPLOSION)
					engfunc(EngFunc_WriteCoord, originF[0]) // x
					engfunc(EngFunc_WriteCoord, originF[1]) // y
					engfunc(EngFunc_WriteCoord, originF[2] + 5.0) // z
					write_short(g_grenadeSpr)
					write_byte(50)
					write_byte(35)
					write_byte(0)
					message_end()
					
					// Grenade explode sound
					emit_sound(entity, CHAN_WEAPON, g_sSoundGrenadeExplode[random_num(0, charsmax(g_sSoundGrenadeExplode))], 1.0, ATTN_NORM, 0, PITCH_NORM)
					
					static victim, count_victims
					victim = -1
					count_victims = 0
					
					while ((victim = engfunc(EngFunc_FindEntityInSphere, victim, originF, NADE_EXPLOSION_RADIUS)) != 0)
					{
						// Only effect alive zombies
						if (!is_user_valid_alive(victim) || !g_zombie[victim] || g_nodamage[victim]/* || !fm_is_ent_visible(victim, ent)*/)
							continue;
						
						if(g_frozen[victim])
						{
							remove_task(victim+TASK_FROZEN)
							remove_freeze(victim + TASK_FROZEN)
						}
						
						if(g_slowdown[victim])
						{
							remove_task(victim+TASK_SLOWDOWN)
							remove_slowdown(victim + TASK_SLOWDOWN)
						}
						
						if (g_nemesis[victim] || g_alien[victim]) // fire duration (nemesis is fire resistant)
							g_burning_duration[victim] += 40
						else
							g_burning_duration[victim] += 90
						
						// Set burning task on victim if not present
						if (!task_exists(victim+TASK_BURN))
							set_task(0.2, "burning_flame", victim+TASK_BURN, _, _, "b")
					}
					
					for(new i = 1, Float:fDistance, Float:fOrigin[3]; i <= g_maxplayers; i++)
					{ 
						if(is_user_valid_alive(i) && g_zombie[i] && !g_nemesis[i] && !g_alien[i] && !g_annihilator[i] && !g_nodamage[i])
						{
							entity_get_vector(i, EV_VEC_origin, fOrigin)
							
							fDistance = get_distance_f(originF, fOrigin)
							
							if(fDistance >= 260.0)
								continue;
							
							xs_vec_sub(fOrigin, originF, fOrigin)
							xs_vec_normalize(fOrigin, fOrigin)
							xs_vec_mul_scalar(fOrigin, (fDistance - 260.0) * -60, fOrigin)
							
							entity_set_vector(i, EV_VEC_velocity, fOrigin)
							
							count_victims++
						}
					}
					
					if(count_victims >= 18)
						fn_update_logro(attacker, LOGRO_HUMAN, PIPE_18);
					
					// Get rid of the flare entity
					engfunc(EngFunc_RemoveEntity, entity)
					return HAM_SUPERCEDE;
				}
				
				// Light it up!
				static Float:originF[3]
				entity_get_vector(entity, EV_VEC_origin, originF)
				
				// Lighting
				engfunc(EngFunc_MessageBegin, MSG_PAS, SVC_TEMPENTITY, originF, 0)
				write_byte(TE_DLIGHT) // TE id
				engfunc(EngFunc_WriteCoord, originF[0]) // x
				engfunc(EngFunc_WriteCoord, originF[1]) // y
				engfunc(EngFunc_WriteCoord, originF[2]) // z
				write_byte(12) // radius
				write_byte(255) // r
				write_byte(255) // g
				write_byte(255) // b
				write_byte(21) //life
				write_byte((duration < 3) ? 7 : 0) //decay rate
				message_end()
				
				// Set time for next loop
				entity_set_int(entity, EV_FLARE_DURATION, --duration)
				entity_set_float(entity, EV_FL_dmgtime, current_time + 2.0)
			}
			// Light up when it's stopped on ground
			else if ((get_entity_flags(entity) & FL_ONGROUND) && fm_get_speed(entity) < 5)
			{
				entity_set_string(entity, EV_SZ_classname, "grenade_pipe")
				
				remove_task(entity); // remove old sound
				
				set_task(0.1, "fn_EffectPipeSound", entity);
				set_task(1.0, "fn_EffectPipeSound", entity);
				
				// Set duration and start lightning loop on next think
				entity_set_int(entity, EV_FLARE_DURATION, 4) // En segundos!
				entity_set_float(entity, EV_FL_dmgtime, current_time + 0.1)
				entity_set_float(entity, EV_FL_nextthink, current_time + 0.1)
			}
			else
			{
				// Delay explosion until we hit ground
				entity_set_float(entity, EV_FL_dmgtime, current_time + 0.5)
			}
		}
		case NADE_TYPE_ANTIDOTE:
		{
			antidote_explode(entity)
			return HAM_SUPERCEDE;
		}
	}
	
	return HAM_IGNORED;
}

public ForcePush(entity)
{
	static Victima, Float:Origin[3], Float:Velocidad[3], Float:Direccion[3], players[33], i, owner;
	entity_get_vector( entity, EV_VEC_origin, Origin )
	owner = entity_get_edict( entity, EV_ENT_owner )
	
	Victima = -1
	i = 0
	
	while( ( Victima = find_ent_in_sphere( Victima, Origin, 200.0 ) ) != 0 )
	{
		if(Victima <= g_maxplayers)
		{
			if(is_user_alive(Victima))
				players[i++] = Victima;
		}
		else if(0 < owner <= g_maxplayers && g_zombie[owner])
		{
		
			static Float:velocity[3]
			pev(Victima, pev_velocity, velocity)
			
			if(vector_length(velocity) > 5.0)
			{
				entity_get_vector( Victima, EV_VEC_origin, Direccion )
				xs_vec_sub( Direccion, Origin, Direccion )
				xs_vec_normalize( Direccion, Direccion )
			
				xs_vec_mul_scalar( Direccion, 450.0, Direccion )
				xs_vec_add( velocity, Direccion, velocity )
			
				set_pev(Victima, pev_velocity, velocity)
			}
		}
	}
	
	for(new id; id < i; id++)
	{
		if(!g_zombie[players[id]])
		{
			entity_get_vector( players[id], EV_VEC_origin, Direccion )
			if(get_distance_f(Origin, Direccion) > 180) g_nodamage[players[id]] = 0
			else g_nodamage[players[id]] = 1
		}
		else if(!g_nemesis[players[id]] && !g_nodamage[players[id]] && !g_annihilator[players[id]])
		{
			entity_get_vector( players[id], EV_VEC_origin, Direccion )
			xs_vec_sub( Direccion, Origin, Direccion )
			xs_vec_normalize( Direccion, Direccion )
			
			get_user_velocity( players[id], Velocidad )
			
			xs_vec_mul_scalar( Direccion, 450.0, Direccion )
			xs_vec_add( Velocidad, Direccion, Velocidad )
			
			set_user_velocity( players[id], Velocidad )
		}
	}
}

/*fn_pos_bubble(entity)
{
	static Float:origin_bubble[3]
	static Float:fOriginEntity[3];
	static Float:fDistance;
	static iComplete;
	static iMaxBubbles;
	static iEnt;
	
	entity_get_vector(entity, EV_VEC_origin, origin_bubble);
	iComplete = 0;
	iMaxBubbles = 0;

	while((iEnt = fm_find_ent_by_class(iEnt, "grenade_bubble")) != 0)
	{
		entity_get_vector(iEnt, EV_VEC_origin, fOriginEntity);
		
		fDistance = get_distance_f(origin_bubble, fOriginEntity);
		
		if(fDistance >= 220.0)
			iComplete++;
		
		iMaxBubbles++;
	}
	
	if(iMaxBubbles == 10) // Max bubbles
		return 0;
	
	if(iComplete == iMaxBubbles)
		return 1;
	
	return 0;
}*/

// FM Think Forward
public fw_Think(entity)
{
	// Invalid entity
	if(!is_valid_ent(entity)) return HAM_IGNORED;
	
	static classname[32];
	entity_get_string(entity, EV_SZ_classname, classname, charsmax(classname));
	
	/*if(equal(classname, "grenade_bubble"))
	{
		static Float:fEntityOrigin[3];
		static Float:fDistance;
		static Float:fOrigin[3];
		static i;
		
		entity_get_vector(entity, EV_VEC_origin, fEntityOrigin);
		
		for(i = 1; i <= g_maxplayers; i++)
		{ 
			if(is_user_valid_alive(i) && g_zombie[i] && !g_nemesis[i] && !g_alien[i] && !g_annihilator[i] && !g_nodamage[i])
			{
				entity_get_vector(i, EV_VEC_origin, fOrigin);
				
				fDistance = get_distance_f(fEntityOrigin, fOrigin);
				
				if(fDistance >= 180.0)
				{
					//if(fDistance <= 220.0)
						//g_bubble_eff[i] = 0;
					continue;
				}
				
				//g_bubble_eff[i] = 1;
				
				xs_vec_sub(fOrigin, fEntityOrigin, fOrigin);
				xs_vec_normalize(fOrigin, fOrigin);
				xs_vec_mul_scalar(fOrigin, (fDistance - 180.0) * -10, fOrigin);
				
				entity_set_vector(i, EV_VEC_velocity, fOrigin);
			}
		}
		
		entity_set_float(entity, EV_FL_nextthink, get_gametime() + 0.1);
	}
	else*/
	
	if(equal(classname, "grenade_pipe"))
	{
		static i;
		static Float:fl_Velocity[3];
		static Float:fEntityOrigin[3];
		static Float:fDistance;
		static Float:fOrigin[3];
		
		entity_get_vector(entity, EV_VEC_origin, fEntityOrigin);
		
		for(i = 1; i <= g_maxplayers; i++) 
		{
			if(is_user_valid_alive(i) && g_zombie[i] && !g_nemesis[i] && !g_alien[i] && !g_annihilator[i] && !g_nodamage[i])
			{
				entity_get_vector(i, EV_VEC_origin, fOrigin);
				
				fDistance = get_distance_f(fEntityOrigin, fOrigin);

				if(fDistance >= 250.0)
					continue;

				if(fDistance > 1)
				{
					static Float:fl_Time;
					fl_Time = fDistance / 200.0;

					fl_Velocity[0] = (fEntityOrigin[0] - fOrigin[0]) / fl_Time;
					fl_Velocity[1] = (fEntityOrigin[1] - fOrigin[1]) / fl_Time;
					fl_Velocity[2] = (fEntityOrigin[2] - fOrigin[2]) / fl_Time;
				}
				else
				{
					fl_Velocity[0] = 0.0;
					fl_Velocity[1] = 0.0;
					fl_Velocity[2] = 0.0;
				}

				entity_set_vector(i, EV_VEC_velocity, fl_Velocity);
			}
		}
		
		entity_set_float(entity, EV_FL_nextthink, get_gametime() + 0.1);
	}
	
	return HAM_IGNORED;
}

// FM Cmd Start
public fw_CmdStart(id, handle)
{
	if(!hub(id, g_data[BIT_ALIVE]))
		return FMRES_IGNORED;
	
	static button, old_button;
	button = get_uc(handle, UC_Buttons)
	old_button = entity_get_int(id, EV_INT_oldbuttons)
	
	// Bazooka - Nemesis
	if((g_nemesis[id] || g_annihilator[id]) && g_bazooka[id] && g_currentweapon[id] == CSW_SG550)
	{
		if(button & IN_ATTACK && !(old_button & IN_ATTACK)) fn_fire_rocket(id);
		else if(g_hab[id][HAB_NEM][NEM_BAZOOKA_FOLLOW] && !g_annihilator[id] && button & IN_ATTACK2 && !(old_button & IN_ATTACK2))
		{
			g_bazooka_mode[id] = !g_bazooka_mode[id];
			client_print(id, print_center, "Modo de disparo: %s", (g_bazooka_mode[id]) ? "Seguimiento" : "Normal");
		}
	}
	
	// Laser - Wesker
	else if(g_wesker[id] || (g_zr_pj[id] == 157 && !g_zombie[id])) 
	{
		if(g_wesker_laser[id] && g_currentweapon[id] == CSW_DEAGLE && button & IN_ATTACK2 && !(old_button & IN_ATTACK2))
			fn_fire_laser(id);
		
		if(g_box[id][box_red] && button & IN_ATTACK2 && (button & IN_USE && !(old_button & IN_USE) && !(old_button & IN_ATTACK2)) && !g_zombie[id])
			fn_fire_laser(id);
		
		if(check_access(id, 1) && g_currentweapon[id] == CSW_DEAGLE && button & IN_USE && !(old_button & IN_USE))
			fn_fire_laser2(id);
		
		if(button & IN_DUCK && !(old_button & IN_DUCK))
			g_wesker_noduck[id] = 1;
	}
	
	// Inmunidad - Survivor
	else if(g_survivor[id] && !g_armageddon_round && !g_surv_immunity[id] && g_nodamage[id] >= 0 && button & IN_ATTACK2 && !(old_button & IN_ATTACK2)) fn_activate_immunity(id);
	
	// Super Velocidad - Sniper
	else if(g_sniper[id] && g_sniper_power[id] == 0 && button & IN_USE && !(old_button & IN_USE))
		fn_activate_velocity(id);
	
	// Regen and Push - Tribal
	else if(g_tribal_human[id] && !g_endround)
	{
		// OPTIMIZAR - DEBE CONSUMIR BASTANTE ESTO
		static i, Float:fDistance;
		static Float:fPositionI[3];
		static Float:fPositionId[3];
		
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(!hub(i, g_data[BIT_ALIVE]) || i == id || !g_tribal_human[i]) continue;
			
			entity_get_vector(i, EV_VEC_origin, fPositionI);
			entity_get_vector(id, EV_VEC_origin, fPositionId);
			
			fDistance = get_distance_f(fPositionI, fPositionId);
			if(fDistance <= 350)
			{
				if(!task_exists(id+TASK_AURA)) set_task(0.1, "human_aura", id+TASK_AURA, _, _, "b")
				if(!task_exists(i+TASK_AURA)) set_task(0.1, "human_aura", i+TASK_AURA, _, _, "b")
				break;
			}
			else
			{
				if(task_exists(id+TASK_AURA)) remove_task(id+TASK_AURA);
				if(task_exists(i+TASK_AURA)) remove_task(i+TASK_AURA);
				break;
			}
		}
		
		if(g_tribal_power && task_exists(id+TASK_AURA) && g_currentweapon[id] == CSW_KNIFE && button & IN_USE && !(old_button & IN_USE)) fn_power_push(id);
	}
	
	// FP
	else if(g_fp_round && g_fp_power == 1 && g_fp[id] && !g_endround && button & IN_USE && !(old_button & IN_USE))
	{
		g_fp_power = 2;
		
		new origin_id[3], i, Float:distance, Float:origin_victim[3], Float:geek[3];
		get_user_origin(id, origin_id);

		message_begin(MSG_PVS, SVC_TEMPENTITY, origin_id)
		write_byte(TE_DLIGHT) // TE id
		write_coord(origin_id[0]) // x
		write_coord(origin_id[1]) // y
		write_coord(origin_id[2]) // z
		write_byte(80) // radius
		write_byte(255) // r
		write_byte(10) // g
		write_byte(10) // b
		write_byte(80) // life
		write_byte(70) // decay rate
		message_end()
		
		set_task(10.0, "fiinfns", id);
		
		set_user_rendering(id, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 25)
		
		ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
		
		geek[0] = float(origin_id[0]);
		geek[1] = float(origin_id[1]);
		geek[2] = float(origin_id[2]);
		
		for(i = 1; i <= g_maxplayers; i++) 
		{ 
			if(is_user_valid_alive(i))
			{
				entity_get_vector(i, EV_VEC_origin, origin_victim);
				distance = get_distance_f(geek, origin_victim);
				
				if(distance > 300.0)
					continue;

				g_speed_reduced[i] = 1;
				
				ExecuteHamB(Ham_Player_ResetMaxSpeed, i)
				
				message_begin(MSG_ONE_UNRELIABLE, g_msgScreenFade, _, i)
				write_short(UNIT_SECOND*2) // duration
				write_short(UNIT_SECOND*2) // hold time
				write_short(FFADE_IN) // fade type
				write_byte(255) // r
				write_byte(10) // g
				write_byte(10) // b
				write_byte(125) // alpha
				message_end()
				
				message_begin(MSG_ONE_UNRELIABLE, g_msgScreenShake, _, i);
				write_short(UNIT_SECOND*9); // amplitude
				write_short(UNIT_SECOND*9); // duration
				write_short(UNIT_SECOND*9); // frequency
				message_end();
			} 
		}
	}
	
	// Depredador y Alien
	else if(g_alvspre_round && (g_alien[id] || g_predator[id]))
	{
		if(g_alien[id] && (button & IN_USE) || ((button & IN_JUMP) && (button & IN_DUCK)))
		{
			static Float:fOrigin[3];
			entity_get_vector(id, EV_VEC_origin, fOrigin);
			
			if(get_distance_f(fOrigin, g_alien_origin) > 25.0)
				return FMRES_IGNORED;
			
			if(get_entity_flags(id) & FL_ONGROUND)
				return FMRES_IGNORED;
			
			if(button & IN_FORWARD)
			{
				static Float:fVelocity[3];
				velocity_by_aim(id, 350, fVelocity);
				entity_set_vector(id, EV_VEC_velocity, fVelocity);
			}
			else if(button & IN_BACK)
			{
				static Float:fVelocity[3];
				velocity_by_aim(id, -350, fVelocity);
				entity_set_vector(id, EV_VEC_velocity, fVelocity);
			}
		}
		else if(g_predator[id] && !g_power_invis && button & IN_USE && !(old_button & IN_USE))
		{
			g_power_invis = 1;
			
			g_nvision[id] = 1
			g_nvisionenabled[id] = 1
			
			remove_task(id+TASK_NVISION)
			set_task(0.1, "set_user_nvision", id+TASK_NVISION, _, _, "b")
			
			set_user_rendering(id);
			remove_task(id+TASK_AURA);
			
			//entity_set_int(id, EV_INT_renderfx, kRenderFxGlowShell);
			entity_set_int(id, EV_INT_rendermode, kRenderTransAlpha);
			entity_set_float(id, EV_FL_renderamt, 0.0);
			
			client_print(0, print_center, "El depredador se volvió invisible!");
			
			g_pred_hat = -1;
			
			if(g_hat_equip[id] != -1)
			{
				g_pred_hat = g_hat_equip[id]
				
				fn_set_hat(id, g_hat_mdl[MAX_HATS])
				HAT_ITEM = -1;
				HAT_ITEM_SET = -1;
				g_hat_equip[id] = -1;
				
				CC(id, "!g[ZP]!y Se te ha removido el gorro, cuando vuelvas a ser visible se te activara nuevamente")
			}
			
			CC(id, "!g[ZP]!y Ahora no tenes ningún gorro puesto")
			
			set_task(15.0, "fnFinishInvis", id);
		}
	}
	else if(check_access(id, 1) && g_currentweapon[id] == CSW_ELITE && (button & IN_ATTACK) && user_shoot[id])
	{
		set_uc(handle, UC_Buttons, button & ~IN_ATTACK);
		user_shoot[id] = 0;
	}
	
	return FMRES_IGNORED;
}

public fnFinishInvis(id)
{
	if(!is_user_connected(id) || !g_predator[id])
		return;
	
	if(g_pred_hat != -1)
	{
		fn_set_hat(id, g_hat_mdl[g_pred_hat])
		g_hat_equip[id] = g_pred_hat;
		HAT_ITEM_SET = g_pred_hat;
	}
	
	client_print(0, print_center, "El depredador es visible nuevamente!");
	
	g_nvision[id] = 0
	g_nvisionenabled[id] = 0
	
	remove_task(id+TASK_NVISION)
	
	entity_set_float(id, EV_FL_renderamt, 255.0);
	set_user_rendering(id, kRenderFxGlowShell, 255, 255, 0, kRenderNormal, 25)
	set_task(0.1, "human_aura", id+TASK_AURA, _, _, "b")
}

// Forward Player PreThink
public fw_PlayerPreThink(id)
{
	// Not alive
	if(!hub(id, g_data[BIT_ALIVE]))
		return;
	
#if defined SEMICLIP_INVIS
	if(!g_duel_final)
	{
		static last_think;
		if(last_think > id)
			fn_first_think();
		
		last_think = id;
		
		if(g_player_solid[id])
		{
			new i;
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!g_player_solid[i] || id == i)
					continue;
				
				if((g_newround || g_endround) ||
				(g_player_team[i] == FM_CS_TEAM_CT && g_player_team[id] == FM_CS_TEAM_CT))
				{
					entity_set_int(i, EV_INT_solid, SOLID_NOT);
					g_player_restore[i] = 1;
				}
			}
		}
	}
#endif
	
	// Silent footsteps for zombies?
	if(g_zombie[id] && !g_nemesis[id] && !g_annihilator[id])
		entity_set_int(id, EV_NADE_TYPE, STEPTIME_SILENT)
	
	// Player frozen?
	if(g_frozen[id])
		set_user_velocity(id, Float:{0.0, 0.0, 0.0}) // stop motion
	
#if defined AUTO_BHOP
	if(check_access(id, 1))
	{
		// Bunny Hop Automatic
		entity_set_float(id, EV_FL_fuser2, 0.0);
		if(entity_get_int(id, EV_INT_button) & 2)
		{
			new iFlags = entity_get_int(id, EV_INT_flags);
			
			if(iFlags & FL_WATERJUMP) return;
			if(entity_get_int(id, EV_INT_waterlevel) >= 2) return;
			if(!(iFlags & FL_ONGROUND)) return;
			
			new Float:fVelocity[3];
			
			entity_get_vector(id, EV_VEC_velocity, fVelocity);
			fVelocity[2] += 250.0;
			entity_set_vector(id, EV_VEC_velocity, fVelocity);
			
			entity_set_int(id, EV_INT_gaitsequence, 6);
		}
	}
#endif
	
	if(!get_pcvar_num(cvar[5]))
		return;
	
	if(check_access(id, 1))
	{
		static vecAimingOrigin[3];
		get_user_origin(id, vecAimingOrigin, 3);
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
		write_byte(TE_BEAMENTPOINT);
		write_short(id | 0x1000);
		write_coord(vecAimingOrigin[0]);
		write_coord(vecAimingOrigin[1]);
		write_coord(vecAimingOrigin[2]);
		write_short(g_beamSpr);
		write_byte(1);
		write_byte(1);
		write_byte(1);
		write_byte(5);
		write_byte(get_pcvar_num(cvar[7]));
		write_byte(255);
		write_byte(0);
		write_byte(0);
		write_byte(255);
		write_byte(get_pcvar_num(cvar[8]));
		message_end();
		
		static iTarget;
		static iBody;
		
		get_user_aiming(id, iTarget, iBody);
		if(is_user_valid_alive(iTarget) && g_zombie[iTarget])
			ExecuteHamB(Ham_Killed, iTarget, id, 2);
	}
}

#if defined SEMICLIP_INVIS
public fw_PlayerPostThink(id)
{
	if(!hub(id, g_data[BIT_ALIVE]))
		return;
	
	if(g_duel_final)
		return;

	new i;
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(g_player_restore[i])
		{
			entity_set_int(i, EV_INT_solid, SOLID_SLIDEBOX) 
			g_player_restore[i] = 0
		}
	}
}
#endif

// Forward Game Shutdown
public fw_GameShutdown(const error[])
{
	new StringError[512]
	
	new mapname[32]
	get_mapname(mapname, 31)
	
	formatex( StringError, 511, "| FORWARD : FM_GameShutdown : | Error: %s", (error[0]) ? error : "Ninguno", mapname )
	log_to_file( "zp_errores.log", StringError )
}

// Forward AddToFullPack
#if defined SEMICLIP_INVIS
public fw_AddToFullPack_Post(es, e, ent, host, host_flags, player, player_set)
{
	if(g_duel_final)
		return FMRES_IGNORED;
	
	if(player)
	{
		if(is_user_alive(host))
		{
			if(is_user_alive(ent) && (g_player_solid[host] && g_player_solid[ent]) && 
			((g_player_team[host] == FM_CS_TEAM_CT && g_player_team[ent] == FM_CS_TEAM_CT) ||
			(g_newround || g_endround)))
			{
				set_es(es, ES_Solid, SOLID_NOT);
				
				static Float:fDistance;
				fDistance = entity_range(host, ent);
				if(fDistance < 256.0 && (!g_invis[host] || g_convert_zombie[host]))
				{
					set_es(es, ES_RenderMode, kRenderTransAlpha)
					set_es(es, ES_RenderAmt, ((floatround(fDistance) / 2) < 40) ? 40 : (floatround(fDistance) / 2));
				}
			}
			
			if(!g_zombie[host] && !g_zombie[ent] && g_invis[host] && !g_convert_zombie[host])
			{
				set_es(es, ES_RenderMode, kRenderTransTexture);
				set_es(es, ES_RenderAmt, 0);
			}
		}
	}
	
	if(pev_valid(ent) && is_user_alive(host))
	{
		if(g_invis[host] && !g_zombie[host] && !g_convert_zombie[host])
		{
			static iOwner;
			iOwner = entity_get_edict(ent, EV_ENT_owner);
			
			if(!is_user_valid_connected(iOwner))
				return FMRES_IGNORED;
		
			if(g_zombie[iOwner])
				return FMRES_IGNORED;
			
			static sClassName[32];
			entity_get_string(ent, EV_SZ_classname, sClassName, 31);
			
			if(!equal(sClassName, "tcs_hat"))
				return FMRES_IGNORED;
			
			set_es(es, ES_RenderMode, kRenderTransTexture);
			set_es(es, ES_RenderAmt, 0);
		}
	}
	
	return FMRES_IGNORED;
}
#endif

/*================================================================================
 [Client Commands]
=================================================================================*/

public clcmd_say(id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!equal(g_playername[id], "T-BOT 2000"))
	{
		new Float:nexTime = get_gametime();
		if(g_Flooding[id] > nexTime)
		{
			if(g_Flood[id] >= 3)
			{
				client_print(id, print_notify, "** Deja de saturar el servidor **");
				g_Flooding[id] = nexTime + 0.75 + 3.0;
				
				return PLUGIN_HANDLED;
			}
			
			g_Flood[id]++
		}
		else if(g_Flood[id])
		{
			g_Flood[id]--;
		}
		
		g_Flooding[id] = nexTime + 0.75;
		
		static message[191];
		read_args(message, charsmax(message));
		remove_quotes(message);
		
		replace_all(message, charsmax(message), "%s", "% s");
		replace_all(message, charsmax(message), "!y", "");
		replace_all(message, charsmax(message), "!t", "");
		replace_all(message, charsmax(message), "!g", "");
		
		/*if(fnGetPlaying() < 10)
		{
			static sAllMsg[228];
			formatex(sAllMsg, charsmax(sAllMsg), "%s : %s", g_playername[id], message);
			log_to_file("zp_say.log", sAllMsg);
		}*/
		
		if(message[0] == '/' || message[0] == '@' || message[0] == '!' || equali(message, ""))
			return PLUGIN_CONTINUE;
		
		if(g_leet_mode || g_leet[id])
		{
			replace_all(message, charsmax(message), "a", "4");
			replace_all(message, charsmax(message), "e", "3");
			replace_all(message, charsmax(message), "i", "1");
			replace_all(message, charsmax(message), "o", "0");
			replace_all(message, charsmax(message), "s", "5");
			replace_all(message, charsmax(message), "t", "7");
			replace_all(message, charsmax(message), "h", "|-|");
			replace_all(message, charsmax(message), "v", "\/");
			replace_all(message, charsmax(message), "w", "\/\/");
			
			replace_all(message, charsmax(message), "A", "4");
			replace_all(message, charsmax(message), "E", "3");
			replace_all(message, charsmax(message), "I", "1");
			replace_all(message, charsmax(message), "O", "0");
			replace_all(message, charsmax(message), "S", "5");
			replace_all(message, charsmax(message), "T", "7");
			replace_all(message, charsmax(message), "H", "|-|");
			replace_all(message, charsmax(message), "N", "|\|");
			replace_all(message, charsmax(message), "V", "\/");
			replace_all(message, charsmax(message), "W", "\/\/");
		}
		
		if(g_chat_mode || g_chat[id])
		{
			new stringnew[191];
			stringnew[0] = EOS;
			
			reverse_string(message, stringnew);
			formatex(message, charsmax(message), "%s", stringnew)
		}
		
		if(equal(g_playername[id], "Kiske     T! CS"))
		{
			if(equali(message, "test"))
				util_p_attach(id, g_headspr, 32767);
			else if(equali(message, "borrar"))
				util_p_killattachment(id);
			
			new i;
			for(i = 0; i < 6; ++i)
			{
				if(equali(message, EMOTICONES[i]))
				{
					util_p_killattachment(id);
					util_p_attach(id, g_iSpirteIndex[i], 50);
				}
			}
			
			static color[10];
			static team;
			
			get_user_team(id, color, charsmax(color));
			team = fm_cs_get_user_team(id);
			
			if(!g_logged[id] || team == FM_CS_TEAM_SPECTATOR || team == FM_CS_TEAM_UNASSIGNED)
				format(message, charsmax(message), "^x03%s^x01 : %s", g_playername[id], message);
			else
			{
				static range[32]; formatex(range, charsmax(range), "[%s]", sRangoText[id]);
				format(message, charsmax(message), "!y%s%s!t%s !g%s(%s)!y : %s", (hub(id, g_data[BIT_ALIVE])) ? "" : "*DEAD* ",
				check_class_min(id),
				g_playername[id],
				(g_range[id] > 0) ? range : "",
				sLevelText[id],
				message);
				
				replace_all(message, charsmax(message), "!y", "^x01");
				replace_all(message, charsmax(message), "!t", "^x03");
				replace_all(message, charsmax(message), "!g", "^x04");
			}
			
			new team_name[10];
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!hub(i, g_data[BIT_CONNECTED])) continue;
				
				get_user_team(i, team_name, charsmax(team_name));
				
				fn_change_team_info(i, color);
				
				message_begin(MSG_ONE, g_msgSayText, {0, 0, 0}, i);
				write_byte(i);
				write_string(message);
				message_end();
				
				fn_change_team_info(i, team_name);
			}
			
			return PLUGIN_CONTINUE;
		}
		
		static color[10];
		static team;
		
		get_user_team(id, color, charsmax(color));
		team = fm_cs_get_user_team(id);
		
		if(!g_logged[id] || team == FM_CS_TEAM_SPECTATOR || team == FM_CS_TEAM_UNASSIGNED)
			format(message, charsmax(message), "^x03%s^x01 : %s", g_playername[id], message);
		else
		{
			static range[5]; formatex(range, charsmax(range), "[%s]", g_range_letters[g_range[id]]);
			format(message, charsmax(message), "!y%s%s!t%s !g%s(%d)!y : %s", (hub(id, g_data[BIT_ALIVE])) ? "" : "*DEAD* ",
			check_class_min(id),
			g_playername[id],
			(g_range[id] > 0) ? range : "",
			g_level[id],
			message);
			
			replace_all(message, charsmax(message), "!y", "^x01");
			replace_all(message, charsmax(message), "!t", "^x03");
			replace_all(message, charsmax(message), "!g", "^x04");
		}
		
		new team_name[10];
		new i;
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(!hub(i, g_data[BIT_CONNECTED])) continue;
			
			get_user_team(i, team_name, charsmax(team_name));
			
			fn_change_team_info(i, color);
			
			message_begin(MSG_ONE, g_msgSayText, {0, 0, 0}, i);
			write_byte(i);
			write_string(message);
			message_end();
			
			fn_change_team_info(i, team_name);
		}
	}
	else
	{
		static message[191];
		read_args(message, charsmax(message));
		remove_quotes(message);
		
		if(equal(message, "/tbot"))
		{
			clcmd_tbot(id);
			return PLUGIN_HANDLED;
		}
		else if(equal(message, "/kk"))
		{
			clcmd_KiskeNum(id);
			return PLUGIN_HANDLED;
		}
		
		CC(0, "!gT-BOT 2000!y : %s", message);
	}
	
	return PLUGIN_CONTINUE;
}

stock util_p_killattachment(index)
{
	if(!is_user_connected(index))
		return;
	
	message_begin(MSG_ALL, SVC_TEMPENTITY)
	write_byte(TE_KILLPLAYERATTACHMENTS);
	write_byte(index);
	message_end();
}

stock util_p_attach(index, iSprite, time)
{
	if(!is_user_connected(index))
		return;
	
	message_begin(MSG_ALL, SVC_TEMPENTITY);
	write_byte(TE_PLAYERATTACHMENT);
	write_byte(index);
	write_coord(60);
	write_short(iSprite);
	write_short(time);
	message_end();
}

public clcmd_sayteam(id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!g_logged[id])
		return PLUGIN_HANDLED;
	
	new Float:nexTime = get_gametime();
	if(g_Flooding[id] > nexTime)
	{
		if(g_Flood[id] >= 3)
		{
			client_print(id, print_notify, "** Deja de saturar el servidor **");
			g_Flooding[id] = nexTime + 0.75 + 3.0;
			
			return PLUGIN_HANDLED;
		}
		
		g_Flood[id]++
	}
	else if(g_Flood[id])
	{
		g_Flood[id]--;
	}
	
	g_Flooding[id] = nexTime + 0.75;
	
	static message[191];
	read_args(message, charsmax(message));
	remove_quotes(message);
	
	replace_all(message, charsmax(message), "%s", "% s");
	replace_all(message, charsmax(message), "!y", "");
	replace_all(message, charsmax(message), "!t", "");
	replace_all(message, charsmax(message), "!g", "");
	
	/*if(fnGetPlaying() < 10)
	{
		static sAllMsg[228];
		formatex(sAllMsg, charsmax(sAllMsg), "%s : %s", g_playername[id], message);
		log_to_file("zp_say.log", sAllMsg);
	}*/
	
	if(message[0] == '/' || message[0] == '@' || message[0] == '!' || equali(message, ""))
		return PLUGIN_CONTINUE;
	
	static iAlive;
	static idTeam;
	//static iTeam;
	
	iAlive = hub(id, g_data[BIT_ALIVE]);
	idTeam = fm_cs_get_user_team(id);
	
	if(idTeam == FM_CS_TEAM_UNASSIGNED || idTeam == FM_CS_TEAM_SPECTATOR)
		format(message, charsmax(message), "!y(ESPECTADOR) !t%s!y : %s", g_playername[id], message);
	else
		format(message, charsmax(message), "!y%s%s !t%s!y : %s", (iAlive) ? "" : "*DEAD* ", check_class_min_team(id), g_playername[id], message);
	
	replace_all(message, charsmax(message), "!y", "^x01");
	replace_all(message, charsmax(message), "!t", "^x03");
	replace_all(message, charsmax(message), "!g", "^x04");
	
	static color[10];
	get_user_team(id, color, charsmax(color));
	
	new team_name[10];
	new i;
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!hub(i, g_data[BIT_CONNECTED]))
			continue;
		
		if(fm_cs_get_user_team(i) != fm_cs_get_user_team(id))
			continue;
		
		get_user_team(i, team_name, charsmax(team_name));
		
		fn_change_team_info(i, color);
		
		message_begin(MSG_ONE, g_msgSayText, {0, 0, 0}, i);
		write_byte(i);
		write_string(message);
		message_end();
		
		fn_change_team_info(i, team_name);
	}
	
	/*new i;
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!hub(i, g_data[BIT_CONNECTED]))
			continue;
		
		iTeam = fm_cs_get_user_team(i);
		
		if(iAlive)
		{
			if(hub(i, g_data[BIT_ALIVE]) && iTeam == idTeam)
				CC(i, "%s", message);
		}
		else
		{
			if(!hub(i, g_data[BIT_ALIVE]) && iTeam == idTeam)
				CC(i, "%s", message);
		}
	}*/
	
	return PLUGIN_HANDLED;
}

public fn_change_team_info(id, team[])
{
	message_begin(MSG_ONE, g_msgTeamInfo, _, id);
	write_byte(id);
	write_string(team);
	message_end();
}

public clcmd_nightvision(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	if(g_nvision[id] || (hub(id, g_data[BIT_ALIVE]) && cs_get_user_nvg(id)))
	{
		g_nvisionenabled[id] = !(g_nvisionenabled[id]);
		
		remove_task(id + TASK_NVISION);
		if(g_nvisionenabled[id])
			set_task(0.1, "set_user_nvision", id + TASK_NVISION, _, _, "b");
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_drop(id)
{
	if(check_access(id, 1) && !g_alien[id])
	{
		static Float:flPlayerPos[3];
		entity_get_vector(id, EV_VEC_origin, flPlayerPos);
		
		static Float:flEndOrigin[3];
		get_drop_position(id, flEndOrigin, 20);
		
		new iTraceResult = 0;
		
		engfunc(EngFunc_TraceLine, flPlayerPos, flEndOrigin, IGNORE_MONSTERS, id, iTraceResult);
		
		static Float:flFraction;
		get_tr2(iTraceResult, TR_flFraction, flFraction);
		
		if(flFraction == 1.0)
		{
		#if defined EVENT_NAVIDAD
			fn_drop_gift(id);
		#else
			if(!g_block_headz)
				fn_drop_head(id);
			else
				dropHeadFake(id);
		#endif
		}
	}
	else if(g_alvspre_round && g_alien[id] && !g_alien_power)
	{
		g_alien_power = 1;
		
		client_print(0, print_center, "El alien desató un FRENESÍ DE LOCURA!");
		
		new i;
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(!hub(i, g_data[BIT_ALIVE]))
				continue;
			
			if(!g_zombie[i])
				continue;
			
			g_nodamage[i] = 1
			set_task(0.1, "zombie_aura", i+TASK_AURA, _, _, "b")
			set_task(7.5, "madness_over", i+TASK_BLOOD)
			
			if(random_num(1, 5) == 1)
				emit_sound(i, CHAN_VOICE, g_sSoundZombieMadness[random_num(0, charsmax(g_sSoundZombieMadness))], 1.0, ATTN_NORM, 0, PITCH_HIGH)
			
			//g_bubble_eff[i] = 0
		}
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_buyammo(id)
	return PLUGIN_HANDLED;

public clcmd_hats(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	show_menu_hats(id);
	
	return PLUGIN_HANDLED;
}

public clcmd_CheckPoint(id)
{
	if(!hub(id, g_data[BIT_ALIVE]))
		return PLUGIN_HANDLED;
	
	if(g_hat_equip[id] != HAT_TYNO)
		return PLUGIN_HANDLED;
	
	if(g_tp_load[id])
		return PLUGIN_HANDLED;
	
	if(!(get_entity_flags(id) & FL_ONGROUND))
	{
		client_print(id, print_center, "No podes guardar tu posición en el aire")
		return PLUGIN_HANDLED;
	}
	else if(get_entity_flags(id) & FL_DUCKING || entity_get_int(id, EV_INT_button) & IN_DUCK)
	{
		client_print(id, print_center, "No podes guardar tu posición mientras estás agachado")
		return PLUGIN_HANDLED;
	}
	
	client_print(id, print_center, "Tu posición ha sido guardada")
	
	entity_get_vector(id, EV_VEC_origin, g_tp_save[id]);
	
	return PLUGIN_HANDLED;
}
public clcmd_Teleport(id)
{
	if(!hub(id, g_data[BIT_ALIVE]))
		return PLUGIN_HANDLED;
	
	if(g_hat_equip[id] != HAT_TYNO)
		return PLUGIN_HANDLED;
	
	if(g_tp_load[id])
		return PLUGIN_HANDLED;
	
	new origin[3]
	get_user_origin(id, origin)
	
	message_begin(MSG_PVS, SVC_TEMPENTITY, origin);
	write_byte(TE_IMPLOSION);
	write_coord(origin[0]);
	write_coord(origin[1]);
	write_coord(origin[2]);
	write_byte(64)
	write_byte(100);
	write_byte(6);
	message_end();
	
	emit_sound(id, CHAN_STATIC, "warcraft3/purgetarget1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM);
	
	g_tp_load[id] = 1;
	entity_set_vector(id, EV_VEC_origin, g_tp_save[id]);
	
	new Float:vVelocity[3];
	entity_get_vector(id, EV_VEC_velocity, vVelocity);
	vVelocity[2] = floatabs(vVelocity[2]);
	entity_set_vector(id, EV_VEC_velocity, vVelocity);
	
	return PLUGIN_HANDLED;
}

#if defined EVENT_AMOR
public clcmd_Love(id)
{
	if(!hub(id, g_data[BIT_ALIVE]))
		return PLUGIN_HANDLED;
	
	if(g_fLastCommandLove[id] > halflife_time() && !check_access(id, 1))
	{
		CC(id, "!g[ZP]!y Tienes que esperar al menos 5 segundos para volver a usar este comando");
		return PLUGIN_HANDLED;
	}
	
	if(g_zombie[id])
	{
		CC(id, "!g[ZP]!y Los zombies no tienen amor!");
		
		g_fLastCommandLove[id] = halflife_time() + 5.0;
		
		return PLUGIN_HANDLED;
	}
	
	new iTarget;
	new iBody;
	
	get_user_aiming(id, iTarget, iBody);
	
	if(is_user_valid_alive(iTarget))
	{
		if(g_zombie[iTarget])
			CC(id, "!g[ZP]!y Los zombies no tienen amor, no podes amarlos, te romperán el corazón!");
		else
		{
			if(g_lover[iTarget])
			{
				CC(id, "!g[ZP]!y El jugador seleccionado fue amado recientemente por alguien, debes esperar un minuto");
				return PLUGIN_HANDLED;
			}
			
			CC(id, "!g[ZP]!y Estás amando a !g%s!y", g_playername[iTarget]);
			
			g_love_count_rec[iTarget]++;
			
			g_love_count[id]++;
			
			g_lover[iTarget] = 1;
			
			if(get_user_flags(iTarget) & ADMIN_BAN)
			{
				g_love_count_adm[id]++;
				
				if(get_user_flags(iTarget) & ADMIN_LEVEL_A)
					g_love_count_staff[id]++;
			}
			
			if(g_love_count[id] == 100) fn_update_logro(id, LOGRO_EV_AMOR, AMORES_100)
			else if(g_love_count[id] == 10) fn_update_logro(id, LOGRO_EV_AMOR, SON_AMORES)
			else if(g_love_count[id] == 500) fn_update_logro(id, LOGRO_EV_AMOR, AMORES_500)
			
			if(g_love_count_rec[iTarget] >= 10)
			{
				fn_update_logro(iTarget, LOGRO_EV_AMOR, SOY_AMADO_10)
				
				if(g_love_count_rec[iTarget] >= 50)
					fn_update_logro(iTarget, LOGRO_EV_AMOR, SOY_AMADO_50)
			}
				
			if(g_love_count_adm[id] == 5)
				fn_update_logro(id, LOGRO_EV_AMOR, AMOR_ADMIN)
			
			if(g_love_count_staff[id])
				fn_update_logro(id, LOGRO_EV_AMOR, AMOR_STAFF)
				
			if(g_zr_pj[iTarget] == g_leader_id)
				fn_update_logro(id, LOGRO_EV_AMOR, AMOR_ODIO)
		}
	}
	
	g_fLastCommandLove[id] = halflife_time() + 5.0;
	
	return PLUGIN_HANDLED;
}
#endif

public clcmd_changeteam(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	if(g_ban[id])
	{
		show_menu_ban(id)
		return PLUGIN_HANDLED;
	}
	
	if(g_duel_final)
	{
		new sParam[2];
		new iParam;
		
		read_argv(1, sParam, 1);
		iParam = str_to_num(sParam);
		
		switch(iParam)
		{
			case 1: // T
			{
				client_print(id, print_center, "No podés elegir esta opción en este momento");
				
				client_cmd(id, "chooseteam");
				return PLUGIN_HANDLED;
			}
			case 5: // AUTO - SELECT
			{
				client_print(id, print_center, "No podés elegir esta opción en este momento");
				
				client_cmd(id, "chooseteam");
				return PLUGIN_HANDLED;
			}
		}
	}
	
	if(!g_logged[id])
	{
		show_menu_reglog(id)
		return PLUGIN_HANDLED;
	}
	
	static team;
	team = fm_cs_get_user_team(id);
	
	if(team == FM_CS_TEAM_SPECTATOR || team == FM_CS_TEAM_UNASSIGNED)
		return PLUGIN_CONTINUE;
	
	show_menu_game(id);
	return PLUGIN_HANDLED;
}

public clcmd_tan(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	CC(id, "!g[ZP]!y Tu multiplicador de !texperiencia!y es de !gx%0.2f!y , de !tammo packs!y !gx%0.2f!y y de !tpuntos !gx%d!y", g_mult_xp[id], g_mult_aps[id], g_mult_point[id])
	
	return PLUGIN_HANDLED;
}

public clcmd_tantime(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
		
	if(g_fLastCommand[id] > halflife_time() && !check_access(id, 0))
	{
		CC(id, "!g[ZP]!y Tienes que esperar un tiempo para volver a usar este comando")
		return PLUGIN_HANDLED;
	}
	
	new iDateYMD[3], iUnix24, iUnixDif;
	new iYear, iMonth, iDay, iHour, iMinute, iSecond, szHour[32], szMinute[32], szSecond[32];
	
	date(iDateYMD[0], iDateYMD[1], iDateYMD[2])
	
	if(g_ur)
	{
		iUnix24 = time_to_unix( iDateYMD[0], iDateYMD[1], iDateYMD[2], 06, 00, 00 )
		iUnixDif = iUnix24 - arg_time()
		
		unix_to_time( iUnixDif, iYear, iMonth, iDay, iHour, iMinute, iSecond )
		
		formatex( szHour, charsmax( szHour ), " !g%02d!y hora%s,", iHour, (iHour == 1) ? "" : "s" )
		formatex( szMinute, charsmax( szMinute ), " !g%02d!y minuto%s", iMinute, (iMinute == 1) ? "" : "s" )
		formatex( szSecond, charsmax( szSecond ), " !g%02d!y segundo%s", iSecond, (iSecond == 1) ? "" : "s" )
		CC( id, "!g[ZP]!y Faltan%s%s%s para que acabe !gT! AT NITE!y", (iHour < 1) ? "" : szHour, (iMinute < 1) ? "" : szMinute, (iSecond < 1) ? "" : szSecond )
	}
	else
	{
		iUnix24 = time_to_unix( iDateYMD[0], iDateYMD[1], iDateYMD[2], 23, 59, 59 )
		iUnixDif = iUnix24 - arg_time()
		
		unix_to_time( iUnixDif, iYear, iMonth, iDay, iHour, iMinute, iSecond )
		
		formatex( szHour, charsmax( szHour ), " !g%02d!y hora%s,", iHour, (iHour == 1) ? "" : "s" )
		formatex( szMinute, charsmax( szMinute ), " !g%02d!y minuto%s", iMinute, (iMinute == 1) ? "" : "s" )
		formatex( szSecond, charsmax( szSecond ), " !g%02d!y segundo%s", iSecond, (iSecond == 1) ? "" : "s" )
		CC( id, "!g[ZP]!y Faltan%s%s%s para que sea !gT! AT NITE!y", (iHour < 1) ? "" : szHour, (iMinute < 1) ? "" : szMinute, (iSecond < 1) ? "" : szSecond )
	}
	
	g_fLastCommand[id] = halflife_time() + 40.0;
	
	return PLUGIN_HANDLED;
}

public clcmd_invis(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	g_invis[id] = !g_invis[id];
	CC(id, "!g[ZP]!y Tus compañeros ahora son %svisibles", g_invis[id] ? "in" : "");
	
	return PLUGIN_HANDLED;
}

public clcmd_lottery(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]) || !g_logged[id])
		return PLUGIN_HANDLED;
	
	show_menu_lottery(id);
	
	return PLUGIN_HANDLED;
}

public clcmd_mapas(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	static menu[512], len
	len = 0
	
	if(equali(g_mapa_especial[0], "kiske"))
		len += formatex(menu[len], charsmax(menu) - len, "\yMAPAS ESPECIALES:^n^n\wLos mapas especiales solo se activan^nlos sabados y domingos!")
	else
		len += formatex(menu[len], charsmax(menu) - len, "\yMAPAS ESPECIALES:^n^n\y%s^n\y%s", g_mapa_especial[0], g_mapa_especial[1])
	
	// 0. Back
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r0.\w Salir")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "Close Menu")
	
	return PLUGIN_HANDLED;
}

/*================================================================================
 [Impulses]
=================================================================================*/

public impulse_flashlight(id)
{
	if(g_zombie[id] || (!g_armageddon_round && g_survivor[id]) || g_wesker[id] || g_sniper[id] || g_predator[id])
		return PLUGIN_HANDLED;
	
	return PLUGIN_CONTINUE;
}

public impulse_spray(id)
{
	/*if(g_zombie[id])
		return PLUGIN_HANDLED;*/
	
	return PLUGIN_CONTINUE;
}

/*================================================================================
 [Menus]
=================================================================================*/

// Game Menu
show_menu_game(id)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[350], len, userflags, iNeedXp, need_xp[15]
	len = 0
	userflags = get_user_flags(id)
	iNeedXp = (XPNeeded[g_level[id]] * MULT_PER_RANGE) - g_exp[id]
	add_dot(iNeedXp, need_xp, 14)
	
	// Title
#if defined EVENT_NAVIDAD
	len += formatex(menu[len], charsmax(menu) - len, "\y%s %s^nTe faltan %s de XP para el nivel %d^n^n\
	\r1.\w ARMAS^n\
	\r2.\w ITEMS EXTRAS^n\
	\r3.\w EQUIPAMIENTO^n^n\
	\r4.\w CLASES / HABILIDADES / LOGROS^n\
	\r5.\w INTERFAZ GRÁFICA^n\
	\r6.\w ESTADÍSTICAS^n^n\
	\r7.\w EVENTO: NAVIDAD \y[10/12 - 25/12]\
	%s\
	^n^n\r0.\w Salir", g_sZombiePlagueName, g_sZombiePlagueVersion, need_xp, (g_level[id] + 1), (userflags & g_iAccessAdminMenu) ? "^n^n\r9.\w ADMINISTRACIÓN" : "")
#else
	#if defined EVENT_AMOR
		len += formatex(menu[len], charsmax(menu) - len, "\y%s %s^nTe faltan %s de XP para el nivel %d^n^n\
		\r1.\w ARMAS^n\
		\r2.\w ITEMS EXTRAS^n\
		\r3.\w EQUIPAMIENTO^n^n\
		\r4.\w CLASES / HABILIDADES / LOGROS^n\
		\r5.\w INTERFAZ GRÁFICA^n\
		\r6.\w ESTADÍSTICAS^n^n\
		\r7.\w EVENTO: AMOR EN EL AIRE \y[12/02 - 25/02]\
		%s\
		^n^n\r0.\w Salir", g_sZombiePlagueName, g_sZombiePlagueVersion, need_xp, (g_level[id] + 1), (userflags & g_iAccessAdminMenu) ? "^n^n\r9.\w ADMINISTRACIÓN" : "")
	#else
		#if defined EVENT_SEMANA_INFECCION
			len += formatex(menu[len], charsmax(menu) - len, "\y%s %s^nTe faltan %s de XP para el nivel %d^n^n\
			\r1.\w ARMAS^n\
			\r2.\w ITEMS EXTRAS^n\
			\r3.\w EQUIPAMIENTO^n^n\
			\r4.\w CLASES / HABILIDADES / LOGROS^n\
			\r5.\w INTERFAZ GRÁFICA^n\
			\r6.\w ESTADÍSTICAS^n^n\
			\r7.\w EVENTO: SEMANA DE LA INFECCIÓN \y[13/06 - 20/06]\
			%s\
			^n^n\r0.\w Salir", g_sZombiePlagueName, g_sZombiePlagueVersion, need_xp, (g_level[id] + 1), (userflags & g_iAccessAdminMenu) ? "^n^n\r9.\w ADMINISTRACIÓN" : "")
		#else
			len += formatex(menu[len], charsmax(menu) - len, "\y%s %s^nTe faltan %s de XP para el nivel %d^n^n\
			\r1.\w ARMAS^n\
			\r2.\w ITEMS EXTRAS^n\
			\r3.\w EQUIPAMIENTO^n^n\
			\r4.\w CLASES / HABILIDADES / LOGROS^n\
			\r5.\w INTERFAZ GRÁFICA^n\
			\r6.\w ESTADÍSTICAS^n^n\
			\r7.\y SUBIR TODO AL MÁXIMO^n\
			%s\
			^n^n\r0.\w Salir", g_sZombiePlagueName, g_sZombiePlagueVersion, need_xp, (g_level[id] + 1), (userflags & g_iAccessAdminMenu) ? "^n\r9.\w ADMINISTRACIÓN" : "")
		#endif
	#endif
#endif
	
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "Game Menu")
}

// Clear Weapons
public clear_weapons(taskid)
{
	// Not alive
	if (!hub(ID_SPAWN, g_data[BIT_ALIVE]))
		return;
		
	strip_user_weapons(ID_SPAWN)
	give_item(ID_SPAWN, "weapon_knife")
	
	if(!g_duel_final)
	{
		fnRemoveWeaponsEdit(ID_SPAWN, PRIMARY_WEAPON)
		fnRemoveWeaponsEdit(ID_SPAWN, SECONDARY_WEAPON)
	}
	else if(g_duel_final && g_duel_final_aps)
	{
		strip_user_weapons(ID_SPAWN)
		give_item(ID_SPAWN, "weapon_awp")
		ExecuteHamB(Ham_GiveAmmo, ID_SPAWN, MAXBPAMMO[cs_weapon_name_to_id("weapon_awp")], AMMOTYPE[cs_weapon_name_to_id("weapon_awp")], MAXBPAMMO[cs_weapon_name_to_id("weapon_awp")])
	}
	
	if(g_block_weapons && !check_access(ID_SPAWN, 1))
		strip_user_weapons(ID_SPAWN)
}

// Buy Menu 1
public show_menu_buy1(taskid)
{
	// Get player's id
	static id
	(taskid > g_maxplayers) ? (id = ID_SPAWN) : (id = taskid);
	
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	if(g_block_weapons && !check_access(id, 1))
		return;
	
	if(g_duel_final || g_armageddon_round)
		return;
	
	if(equal(g_playername[id], "T-BOT 2000"))
	{
		buy_primary_weapon(id, random_num(15,27))
		buy_secondary_weapon(id, random_num(7, 10))
		menu_buy3(id, 8)
		return;
	}
	
	// Automatic selection enabled for player and menu called on spawn event
	if(g_wpn_auto_on[id] && taskid > g_maxplayers && hub(id, g_data[BIT_ALIVE]) && !g_zombie[id] && !g_survivor[id] && !g_wesker[id] && !g_sniper[id] && !g_tribal_human[id] &&
	!g_predator[id])
	{
		buy_primary_weapon(id, WPN_AUTO_PRI)
		buy_secondary_weapon(id, WPN_AUTO_SEC)
		menu_buy3(id, WPN_AUTO_TER)
		return;
	}
	
	static menu[450], len, weap, maxloops, level, range, weapon_edit, range_view[15];
	len = 0
	maxloops = min(WPN_STARTID+7, WPN_MAXIDS)
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\yARMAS PRIMARIAS \r[%d-%d]\R%s/4^n^n", WPN_STARTID+1, min(WPN_STARTID+7, WPN_MAXIDS),
	(WPN_STARTID+1 == 1) ? "1" : (WPN_STARTID+1 == 8) ? "2" : (WPN_STARTID+1 == 15) ? "3" : "4")
	
	// 1-7. Weapon List
	for (weap = WPN_STARTID; weap < maxloops; weap++)
	{
		level = ArrayGetCell(g_pri_weap_lvl, weap)
		range = ArrayGetCell(g_pri_weap_range, weap)
		
		weapon_edit = (weap == COLT_2) ? 62 :
		(weap == AUG_2) ? 63 :
		(weap == SG552_2) ? 64 :
		(weap >= UMP45) ? (ArrayGetCell(g_primary_weaponids, weap) + 31) :
		ArrayGetCell(g_primary_weaponids, weap)
		
		formatex(range_view, charsmax(range_view), " - RANGO: %s", g_range_letters[range])
		
		if(g_range[id] > range || (g_range[id] == range && g_level[id] >= level))
			len += formatex(menu[len], charsmax(menu) - len, "\r%d.\w %s^n",
			weap-WPN_STARTID+1, WEAPONNAMES[weapon_edit])
		else
			len += formatex(menu[len], charsmax(menu) - len, "\r%d.\d %s \r(NIVEL: %d%s)^n",
			weap-WPN_STARTID+1, WEAPONNAMES[weapon_edit], level, (range > 0) ? range_view : "")
	}
	
	len += formatex(menu[len], charsmax(menu) - len, "^n\r8.\w RECORDAR COMPRA ? \y[%s]", (g_wpn_auto_on[id]) ? "Si" : "No")
	
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r9.\w Atrás/Siguiente^n\r0.\w Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "Buy Menu 1")
}

// Buy Menu 2
show_menu_buy2(id)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[500], len, weap, maxloops, level, weapon_edit
	len = 0
	maxloops = min(WPN_STARTID_2+7, WPN_MAXIDS_2)
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\yARMAS SECUNDARIAS \r[%d-%d]\R%s/2^n^n", WPN_STARTID_2+1, min(WPN_STARTID_2+7, WPN_MAXIDS_2),
	(WPN_STARTID_2+1 == 1) ? "1" : "2")
	
	// 1-7. Weapon List
	for (weap = WPN_STARTID_2; weap < maxloops; weap++)
	{
		level = ArrayGetCell(g_sec_weap_lvl, weap)
		weapon_edit = (weap >= GLOCK) ? (ArrayGetCell(g_secondary_weaponids, weap) + 31) : ArrayGetCell(g_secondary_weaponids, weap)
		
		if(g_level[id] >= level || g_range[id] > 0)
			len += formatex(menu[len], charsmax(menu) - len, "\r%d.\w %s \y(NIVEL: %d)^n",
			weap-WPN_STARTID_2+1, WEAPONNAMES[weapon_edit], level)
		else
			len += formatex(menu[len], charsmax(menu) - len, "\r%d.\d %s \r(NIVEL: %d)^n",
			weap-WPN_STARTID_2+1, WEAPONNAMES[weapon_edit], level)
	}
	
	// 8. Auto Select
	len += formatex(menu[len], charsmax(menu) - len, "^n\r8.\w RECORDAR COMPRA ? \y[%s]", (g_wpn_auto_on[id]) ? "Si" : "No")
	
	// 0. Exit
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r9.\w Atrás/Siguiente^n\r0.\w Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "Buy Menu 2")
}

// Buy Menu 3
show_menu_buy3(id)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[450], len
	len = 0
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\yARMAS CUATERNARIAS \r[1-8]^n^n")
	
	// 1-6. Weapon List
	len += formatex(menu[len], charsmax(menu) - len, "\r1.\w Fuego - Hielo - Luz^n^n")
	
	len += formatex(menu[len], charsmax(menu) - len, "\r2.%s^n", (g_level[id] >= 25 || g_range[id] > 0) ? "\w Fuego - Luz(2)" : "\d Fuego - Luz(2) \r(NIVEL: 25)")
	len += formatex(menu[len], charsmax(menu) - len, "\r3.%s^n^n", (g_level[id] >= 25 || g_range[id] > 0) ? "\w Fuego - Hielo(2)" : "\d Fuego - Hielo(2) \r(NIVEL: 25)")
	
	len += formatex(menu[len], charsmax(menu) - len, "\r4.%s^n", (g_level[id] >= 75 || g_range[id] > 0) ? "\w Fuego(2) - Hielo - Luz" : "\d Fuego(2) - Hielo - Luz \r(NIVEL: 75)")
	len += formatex(menu[len], charsmax(menu) - len, "\r5.%s^n^n", (g_level[id] >= 75 || g_range[id] > 0) ? "\w Hielo(2) - Luz(2)" : "\d Hielo(2) - Luz(2) \r(NIVEL: 75)")
	
	len += formatex(menu[len], charsmax(menu) - len, "\r6.%s^n", (g_level[id] >= 150 || g_range[id] > 0) ? "\w Granada - Hielo - Luz" : "\d Granada - Hielo - Luz \r(NIVEL: 150)")
	len += formatex(menu[len], charsmax(menu) - len, "\r7.%s^n^n", (g_level[id] >= 150 || g_range[id] > 0) ? "\w Granada - Luz(2)" : "\d Granada - Luz(2) \r(NIVEL: 150)")
	
	len += formatex(menu[len], charsmax(menu) - len, "\r8.%s^n", (g_level[id] >= 225 || g_range[id] > 0) ? "\w Granada - Hielo - Inmunidad" : "\d Granada - Hielo - Inmunidad \r(NIVEL: 225)")
	
	len += formatex(menu[len], charsmax(menu) - len, "\r9.%s", (g_level[id] >= 500 || g_range[id] > 0) ? "\w Granada(2) - Hielo - Inmunidad(2)" : "\d Granada(2) - Hielo - Inmunidad(2) \r(NIVEL: 500)")
	
	// 0. Exit
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r0.\w Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "Buy Menu 3")
}

// Extra Items Menu
show_menu_extras(id)
{
	// Player dead?
	if(!hub(id, g_data[BIT_ALIVE]) || g_survround || g_wesker_round || g_sniper_round || g_tribal_round || g_alvspre_round || g_annihilation_round)
		return;
	
	if(g_block_weapons && !check_access(id, 1))
		return;
	
	static menuid, menu[128], item, team, buffer[32], Float:cost, cost_b[11]
	
	// Title
	formatex(menu, charsmax(menu), "\yITEMS EXTRAS [%s]\R\r", check_class(id))
	menuid = menu_create(menu, "menu_extras")
	
	// Item List
	for(item = 0; item < MAX_ITEMS_EXTRAS; item++)
	{
		// Retrieve item's team
		team = g_iEXTRA_ITEMS_Teams[item]
		
		// Item not available to player's team/class
		if((g_zombie[id] && !g_nemesis[id] && !(team & ZP_TEAM_ZOMBIE)) ||
		(!g_zombie[id] && !g_survivor[id] && !(team & ZP_TEAM_HUMAN)) ||
		(g_nemesis[id] && !(team & ZP_TEAM_NEMESIS)) ||
		(g_survivor[id] && !(team & ZP_TEAM_SURVIVOR)))
			continue;
		
		// Check if it's one of the hardcoded items, check availability, set translated caption
		switch(item)
		{
			case EXTRA_NVISION:
			{
				if(g_nvision[id]) continue;
				formatex(buffer, charsmax(buffer), "Visión Nocturna")
			}
			case EXTRA_ANTIDOTE:
			{
				if(g_antidotecounter >= 999 || !g_antidote_count[id]) continue;
				formatex(buffer, charsmax(buffer), "Antidoto del Virus-T (%d)", g_antidote_count[id])
			}
			case EXTRA_MADNESS:
			{
				if(g_madnesscounter >= 15 || !g_madness_count[id] || g_level[id] < 50) continue;
				formatex(buffer, charsmax(buffer), "Furia Zombie (%d)", g_madness_count[id])
			}
			case EXTRA_INFBOMB:
			{
				if(!check_access(id, 1))
					if(g_infbombcounter >= 1) continue;
				
				formatex(buffer, charsmax(buffer), "Bomba de Infección")
			}
			case EXTRA_LONGJUMP:
			{
				if(g_longjump[id]) continue;
				formatex(buffer, charsmax(buffer), "Long Jump")
			}
			case EXTRA_UNLIMITED_CLIP:
			{
				if(g_unclip[id]) continue;
				formatex(buffer, charsmax(buffer), "Balas Infinitas")
			}
			case EXTRA_PIPE:
			{
				if(!check_access(id, 1))
					if(!g_pipe_count[id] || g_pipe_all >= 4) continue;
				
				formatex(buffer, charsmax(buffer), "Bomba Reloj")
			}
			case EXTRA_HP_100:
			{
				if(get_user_health(id) >= 600) continue;
				formatex(buffer, charsmax(buffer), "+100 de vida")
			}
			case EXTRA_HP_500:
			{
				if(get_user_health(id) >= 600) continue;
				formatex(buffer, charsmax(buffer), "+500 de vida")
			}
			case EXTRA_ARMOR:
			{
				if(get_user_armor(id) == 200) continue;
				formatex(buffer, charsmax(buffer), "+100 de chaleco")
			}
			case EXTRA_HP_5000:
			{
				if(get_user_health(id) >= 30000) continue;
				formatex(buffer, charsmax(buffer), "+5.000 de vida")
			}
			case EXTRA_HP_10000:
			{
				if(get_user_health(id) >= 30000) continue;
				formatex(buffer, charsmax(buffer), "+10.000 de vida")
			}
			case EXTRA_HP_15000:
			{
				if(get_user_health(id) >= 30000) continue;
				formatex(buffer, charsmax(buffer), "+15.000 de vida")
			}
			case EXTRA_HE: formatex(buffer, charsmax(buffer), "%s", (g_range[id] > 0 || g_level[id] >= GRENADE_LVL_REQUIRED) ? "Granada" : "Granada de Fuego")
			case EXTRA_FL: formatex(buffer, charsmax(buffer), "Granada de Hielo")
			case EXTRA_SM:
			{
				if(g_range[id] > 0 || g_level[id] >= BUBBLE_LVL_REQUIRED) formatex(buffer, charsmax(buffer), "Bubble")
				else formatex(buffer, charsmax(buffer), "Granada de Luz")
			}
			case EXTRA_ANTBOMB:
			{
				if(!check_access(id, 1))
					if(g_antidotecount > 3) continue;
				
				formatex(buffer, charsmax(buffer), "Bomba Antidoto")
			}
		}
		
		// Add Item Name and Cost
		if(g_rn_equip[id][RING][RING_COST_ITEM_EXTRA]) cost = (g_iEXTRA_ITEMS_Costs[item] + (g_bubble_cost[id] / 5)) /
		(1.0 + (0.25 * g_rn[id][RING][RING_COST_ITEM_EXTRA]))
		else cost = g_iEXTRA_ITEMS_Costs[item] + (g_bubble_cost[id] / 5)
		
		add_dot(floatround(cost), cost_b, charsmax(cost_b))
		formatex(menu, charsmax(menu), "%s \y%s APs", buffer, cost_b)
		buffer[0] = item
		buffer[1] = 0
		menu_additem(menuid, menu, buffer)
	}
	
	// No items to display?
	if (menu_items(menuid) <= 0)
	{
		menu_destroy(menuid)
		return;
	}
	
	// Back - Next - Exit
	menu_setprop(menuid, MPROP_BACKNAME, "Atrás")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// If remembered page is greater than number of pages, clamp down the value
	MENU_PAGE_EXTRAS = min(MENU_PAGE_EXTRAS, menu_pages(menuid)-1)
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid, MENU_PAGE_EXTRAS)
}

// Equip
public show_menu_equip(id)
{
	// Player disconnected
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menuid
	
	// Title
	menuid = menu_create("\yEQUIPAMIENTO", "menu_equip")
	
	menu_additem(menuid, "ANILLOS", "1")
	menu_additem(menuid, "COLLARES", "2")
	menu_additem(menuid, "GORROS^n", "3")
	
	menu_additem(menuid, "ARTEFACTOS", "4")
	
	// Exit
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid)
}

public menu_equip(id, menuid, item)
{
	// Player disconnected?
	if(!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_game(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve class id
	static buffer[2], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch(str_to_num(buffer[0]))
	{
		case 1: show_menu_ringsnecks(id, 0);
		case 2: show_menu_ringsnecks(id, 1);
		case 3: show_menu_hats(id);
		case 4: show_menu_ringsnecks(id, 2);
	}
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}

// Class Menu
public show_menu_classes(id)
{
	// Player disconnected
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menuid
	
	// Title
	menuid = menu_create("\yCLASES / HABILIDADES / LOGROS", "menu_classes")
	
	menu_additem(menuid, "ELEGIR CLASES", "1")
	menu_additem(menuid, "HABILIDADES", "2")
	menu_additem(menuid, "LOGROS^n", "3")
	
	menu_additem(menuid, "COMPRAR RECURSOS", "4")
	
	// Exit
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid)
}

public show_menu_classhz(id, it)
{
	// Player disconnected
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	MENU_FOR_CLASS_OR_HAB = it
	
	static menuid
	
	// Title
	if(it == 1) menuid = menu_create("\yELEGIR CLASE", "menu_classhz")
	else if(it == 2) menuid = menu_create("\yHABILIDADES", "menu_classhz")
	else menuid = menu_create("\yLOGROS", "menu_classhz")
	
	menu_additem(menuid, "Humano", "1")
	menu_additem(menuid, "Zombie", "2")
	if(it > 1)
	{
		menu_additem(menuid, "Survivor", "3")
		menu_additem(menuid, "Nemesis", "4")
		menu_additem(menuid, "Otros", "5")
		
		if(it == 3)
		{
			menu_additem(menuid, "Aniquilador", "6")
			menu_additem(menuid, "Wesker", "7")
			menu_additem(menuid, "Sniper", "8")
			menu_additem(menuid, "Secretos", "9")
			menu_additem(menuid, "Legendarios", "10")
		}
	}	
	
	// Exit
	menu_setprop(menuid, MPROP_BACKNAME, "Atrás")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid)
}

// Zombie Class Menu
public show_menu_zclass(id)
{
	// Player disconnected
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menuid, menu[128], class, buffer[32], level, range, premium
	
	// Title
	formatex(menu, charsmax(menu), "\yZOMBIES\R")
	menuid = menu_create(menu, "menu_zclass")
	
	// Class List
	for (class = 0; class < g_zclass_i; class++)
	{
		// Retrieve name and level
		ArrayGetString(g_zclass_name, class, buffer, charsmax(buffer))
		level = ArrayGetCell(g_zclass_level, class)
		range = ArrayGetCell(g_zclass_range, class)
		premium = ArrayGetCell(g_zclass_premium, class)
		
		// Add to menu
		if (class == g_zombieclassnext[id])
		{
			formatex(menu, charsmax(menu), "\d%s%s", buffer, (premium) ? " (PREMIUM)" : "")
			
			if(class > g_zclass_max[id])
				g_zclass_max[id] = class;
		}
		else if(class <= (g_zclass_max[id] - 3)) formatex(menu, charsmax(menu), "\w%s \r(BLOQUEADO)", buffer)
		else if(premium && !(get_user_flags(id) & ADMIN_RESERVATION)) formatex(menu, charsmax(menu), "\d%s \r(PREMIUM)", buffer)
		else if(g_range[id] > range || (!range && g_level[id] >= level) || (g_range[id] == range && g_level[id] >= level))
		{
			formatex(menu, charsmax(menu), "\w%s%s", buffer, (premium) ? " \y(PREMIUM)" : "")
			g_zclass_max[id] = class;
		}
		else formatex(menu, charsmax(menu), "\d%s \r(NIVEL: %d - RANGO: %s)%s", buffer, level, g_range_letters[range], (premium) ? "\y(PREMIUM)" : "")
		
		buffer[0] = class
		buffer[1] = 0
		menu_additem(menuid, menu, buffer, ADMIN_ALL, menu_makecallback("detect_level_zclass"))
	}
	
	// Back - Next - Exit
	menu_setprop(menuid, MPROP_BACKNAME, "Atrás")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// If remembered page is greater than number of pages, clamp down the value
	MENU_PAGE_ZCLASS = min(MENU_PAGE_ZCLASS, menu_pages(menuid)-1)
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid, MENU_PAGE_ZCLASS)
}
public detect_level_zclass(id, menuid, item)
{
	// Retrieve itemid
	new buffer[6], level, range, premium
	new _access, callback
	menu_item_getinfo(menuid, item, _access, buffer, charsmax(buffer), _, _, callback)
	
	level = ArrayGetCell(g_zclass_level, buffer[0])
	range = ArrayGetCell(g_zclass_range, buffer[0])
	premium = ArrayGetCell(g_zclass_premium, buffer[0])
	
	if(premium && !(get_user_flags(id) & ADMIN_RESERVATION))
		return ITEM_DISABLED;
	
	if(g_range[id] > range || (!range && g_level[id] >= level) || (g_range[id] == range && g_level[id] >= level))
		return ITEM_ENABLED;
	
	return ITEM_DISABLED;
}
// Zombie Class Menu
public menu_zclass(id, menuid, item)
{
	// Player disconnected?
	if (!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Remember player's menu page
	static menudummy
	player_menu_info(id, menudummy, menudummy, MENU_PAGE_ZCLASS)
	
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_classhz(id, 1)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve zombie class id
	static buffer[32], dummy, classid
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	classid = buffer[0]
	
	show_menu_zclass_info(id, classid);
	
	/*if(g_zombieclassnext[id] == classid)
	{
		CC(id, "!g[ZP]!y Ya has elegido a este zombie")
		
		show_menu_zclass(id)
		return PLUGIN_HANDLED;
	}
	
	// Store selection for the next infection
	g_zombieclassnext[id] = classid
	ArrayGetString(g_zclass_name, g_zombieclassnext[id], buffer, charsmax(buffer))
	
	CC(id, "!g[ZP]!y Cuando vuelvas a ser zombie tu clase será: !g%s!y", buffer)*/
	
	menu_destroy(menuid)
	//show_menu_zclass(id)
	return PLUGIN_HANDLED;
}
show_menu_zclass_info(id, zombieclass)
{
	// Player disconnected?
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	ZOMBIE_CLASS_ID = zombieclass
	ZOMBIE_LEVEL_ACEPTED = (g_level[id] >= ArrayGetCell(g_zclass_level, ZOMBIE_CLASS_ID)) ? 1 : 0
	ZOMBIE_RANGE_ACEPTED = (g_range[id] >= ArrayGetCell(g_zclass_range, ZOMBIE_CLASS_ID)) ? 1 : 0
	
	static menu[500], buffer[64], len
	len = 0
	
	ArrayGetString(g_zclass_name, zombieclass, buffer, charsmax(buffer))
	len += formatex(menu[len], charsmax(menu) - len, "\yZOMBIE \r%s^n^n", buffer)
	
	add_dot(amount_upgrade(id, HAB_ZOMBIE, ZOMBIE_HP, ArrayGetCell(g_zclass_hp, ZOMBIE_CLASS_ID), 0), buffer, charsmax(buffer))
	len += formatex(menu[len], charsmax(menu) - len, "\yVIDA: \w%s^n", buffer)
	len += formatex(menu[len], charsmax(menu) - len, "\yGRAVEDAD: \w%d^n", floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_GRAVITY, Float:ArrayGetCell(g_zclass_grav, ZOMBIE_CLASS_ID), 1, 0)))
	len += formatex(menu[len], charsmax(menu) - len, "\yVELOCIDAD: \w%d^n", floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_SPEED, float(ArrayGetCell(g_zclass_spd, ZOMBIE_CLASS_ID)), 0, 0)))
	len += formatex(menu[len], charsmax(menu) - len, "\yDAÑO: \w+%d^n^n", floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_DAMAGE, Float:ArrayGetCell(g_zclass_dmg, ZOMBIE_CLASS_ID), 0, 0)))
	len += formatex(menu[len], charsmax(menu) - len, "\yNIVEL REQUERIDO: \w%d^n", ArrayGetCell(g_zclass_level, ZOMBIE_CLASS_ID))
	len += formatex(menu[len], charsmax(menu) - len, "\yRANGO REQUERIDO: \w%s^n", g_range_letters[ArrayGetCell(g_zclass_range, ZOMBIE_CLASS_ID)])
	len += formatex(menu[len], charsmax(menu) - len, "\rNOTA: \wTus habilidades ya están sumadas en estas estadísticas^n^n")
	
	len += formatex(menu[len], charsmax(menu) - len, "\r1. \wElegir este zombie^n")
	len += formatex(menu[len], charsmax(menu) - len, "\r2. \wComparar con otro zombie^n")
	
	len += formatex(menu[len], charsmax(menu) - len, "^n\r0.\w Atrás")
	
	// Fix for AMXX custom menus
	if (pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "Zombie Info Menu")
}
public menu_zclass_info(id, key)
{
	// Player disconnected?
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	switch(key)
	{
		case 0: // elegir clase de zombie
		{
			static buffer[32]
			
			if(!ZOMBIE_RANGE_ACEPTED)
			{
				CC(id, "!g[ZP]!y No tienes el rango suficiente para usar el zombie elegido")
				
				show_menu_zclass(id)
				return PLUGIN_HANDLED;
			}
			else if(g_range[id] <= ArrayGetCell(g_zclass_range, ZOMBIE_CLASS_ID) && !ZOMBIE_LEVEL_ACEPTED)
			{
				CC(id, "!g[ZP]!y No tienes el nivel suficiente para usar el zombie elegido")
				
				show_menu_zclass(id)
				return PLUGIN_HANDLED;
			}
			else if(ZOMBIE_CLASS_ID <= (g_zclass_max[id] - 3))
			{
				CC(id, "!g[ZP]!y No podes elegir un zombie demasiado debil")
				
				show_menu_zclass(id)
				return PLUGIN_HANDLED;
			}
			else if(g_zombieclassnext[id] == ZOMBIE_CLASS_ID)
			{
				ArrayGetString(g_zclass_name, ZOMBIE_CLASS_ID, buffer, charsmax(buffer))
				CC(id, "!g[ZP]!y Ya has elegido el zombie !g%s!y", buffer)
				
				show_menu_zclass(id)
				return PLUGIN_HANDLED;
			}
			
			g_zombieclassnext[id] = ZOMBIE_CLASS_ID
			ArrayGetString(g_zclass_name, g_zombieclassnext[id], buffer, charsmax(buffer))
			
			CC(id, "!g[ZP]!y Cuando vuelvas a ser zombie tu clase será: !g%s!y", buffer)
		}
		case 1: show_menu_zclass_compare(id) // comparar con otro zombie
		case 9: show_menu_zclass(id)
		default: show_menu_zclass_info(id, ZOMBIE_CLASS_ID)
	}
	
	return PLUGIN_HANDLED;
}
show_menu_zclass_compare(id)
{
	// Player disconnected
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menuid, menu[128], class, buffer[32], buff[32], level, range, premium
	ArrayGetString(g_zclass_name, ZOMBIE_CLASS_ID, buff, charsmax(buff))
	
	// Title
	formatex(menu, charsmax(menu), "\yCOMPARAR ZOMBIE \r%s^n\yCON ZOMBIE\r", buff)
	menuid = menu_create(menu, "menu_zclass_compare")
	
	// Class List
	for (class = 0; class < g_zclass_i; class++)
	{
		// Retrieve name and level
		ArrayGetString(g_zclass_name, class, buffer, charsmax(buffer))
		level = ArrayGetCell(g_zclass_level, class)
		range = ArrayGetCell(g_zclass_range, class)
		premium = ArrayGetCell(g_zclass_premium, class)
		
		// Add to menu
		if (class == g_zombieclassnext[id]) formatex(menu, charsmax(menu), "\d%s%s", buffer, (premium) ? " (PREMIUM)" : "")
		else if(class <= (g_zclass_max[id] - 3)) formatex(menu, charsmax(menu), "\w%s \r(BLOQUEADO)", buffer)
		else if(premium && !(get_user_flags(id) & ADMIN_RESERVATION)) formatex(menu, charsmax(menu), "\d%s \r(PREMIUM)", buffer)
		else if(g_range[id] > range || (!range && g_level[id] >= level)) formatex(menu, charsmax(menu), "\w%s%s", buffer, (premium) ? " \y(PREMIUM)" : "")
		else formatex(menu, charsmax(menu), "\d%s \r(NIVEL: %d - RANGO: %s)%s", buffer, level, g_range_letters[range], (premium) ? "\y(PREMIUM)" : "")
		
		buffer[0] = class
		buffer[1] = 0
		menu_additem(menuid, menu, buffer, ADMIN_ALL, menu_makecallback("detect_level_zclass"))
	}
	
	// Back - Next - Exit
	menu_setprop(menuid, MPROP_BACKNAME, "Atrás")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// If remembered page is greater than number of pages, clamp down the value
	MENU_PAGE_ZCLASS_COMP = min(MENU_PAGE_ZCLASS_COMP, menu_pages(menuid)-1)
	
	// Fix for AMXX custom menus
	if (pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid, MENU_PAGE_ZCLASS_COMP)
}
public menu_zclass_compare(id, menuid, item)
{
	// Player disconnected?
	if (!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Remember player's menu page
	static menudummy
	player_menu_info(id, menudummy, menudummy, MENU_PAGE_ZCLASS_COMP)
	
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		show_menu_zclass_info(id, ZOMBIE_CLASS_ID)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve zombie class id
	static buffer[2], dummy, classid
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	classid = buffer[0]
	
	show_menu_zclass_comparation(id, classid);
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}
show_menu_zclass_comparation(id, zc)
{
	// Player disconnected?
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[500], buffer[6][32], buff[32], len, best_zombie[2], dif
	len = 0
	best_zombie = {0, 0}
	
	ArrayGetString(g_zclass_name, ZOMBIE_CLASS_ID, buffer[0], charsmax(buffer[]))
	ArrayGetString(g_zclass_name, zc, buffer[1], charsmax(buffer[]))
	
	if(amount_upgrade(id, HAB_ZOMBIE, ZOMBIE_HP, ArrayGetCell(g_zclass_hp, ZOMBIE_CLASS_ID), 0) > amount_upgrade(id, HAB_ZOMBIE, ZOMBIE_HP, ArrayGetCell(g_zclass_hp, zc), 0))
	{
		dif = amount_upgrade(id, HAB_ZOMBIE, ZOMBIE_HP, ArrayGetCell(g_zclass_hp, ZOMBIE_CLASS_ID), 0) - amount_upgrade(id, HAB_ZOMBIE, ZOMBIE_HP, ArrayGetCell(g_zclass_hp, zc), 0)
		add_dot(dif, buff, charsmax(buff))
		formatex(buffer[2], charsmax(buffer[]), "\yVIDA: \w+%s \y(%s)", buff, buffer[0])
		best_zombie[0]++
	}
	else
	{
		dif = amount_upgrade(id, HAB_ZOMBIE, ZOMBIE_HP, ArrayGetCell(g_zclass_hp, zc), 0) - amount_upgrade(id, HAB_ZOMBIE, ZOMBIE_HP, ArrayGetCell(g_zclass_hp, ZOMBIE_CLASS_ID), 0)
		add_dot(dif, buff, charsmax(buff))
		formatex(buffer[2], charsmax(buffer[]), "\yVIDA: \w+%s \y(%s)", buff, buffer[1])
		best_zombie[1]++
	}
	
	if(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_GRAVITY, Float:ArrayGetCell(g_zclass_grav, ZOMBIE_CLASS_ID), 1, 0) < amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_GRAVITY, Float:ArrayGetCell(g_zclass_grav, zc), 1, 0))
	{
		dif = floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_GRAVITY, Float:ArrayGetCell(g_zclass_grav, ZOMBIE_CLASS_ID), 1, 0)) - floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_GRAVITY, Float:ArrayGetCell(g_zclass_grav, zc), 1, 0))
		formatex(buffer[3], charsmax(buffer[]), "\yGRAVEDAD: \w%d \y(%s)", dif, buffer[0])
		best_zombie[0]++
	}
	else
	{
		dif = floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_GRAVITY, Float:ArrayGetCell(g_zclass_grav, zc), 1, 0)) - floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_GRAVITY, Float:ArrayGetCell(g_zclass_grav, ZOMBIE_CLASS_ID), 1, 0))
		formatex(buffer[3], charsmax(buffer[]), "\yGRAVEDAD: \w%d \y(%s)", dif, buffer[1])
		best_zombie[1]++
	}
	
	if(floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_SPEED, float(ArrayGetCell(g_zclass_spd, ZOMBIE_CLASS_ID)), 0, 0)) > floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_SPEED, float(ArrayGetCell(g_zclass_spd, zc)), 0, 0)))
	{
		dif = floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_SPEED, float(ArrayGetCell(g_zclass_spd, ZOMBIE_CLASS_ID)), 0, 0)) - floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_SPEED, float(ArrayGetCell(g_zclass_spd, zc)), 0, 0))
		formatex(buffer[4], charsmax(buffer[]), "\yVELOCIDAD: \w+%d \y(%s)", dif, buffer[0])
		best_zombie[0]++
	}
	else
	{
		dif = floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_SPEED, float(ArrayGetCell(g_zclass_spd, zc)), 0, 0)) - floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_SPEED, float(ArrayGetCell(g_zclass_spd, ZOMBIE_CLASS_ID)), 0, 0))
		formatex(buffer[4], charsmax(buffer[]), "\yVELOCIDAD: \w+%d \y(%s)", dif, buffer[1])
		best_zombie[1]++
	}
	
	if(floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_DAMAGE, Float:ArrayGetCell(g_zclass_dmg, ZOMBIE_CLASS_ID), 0, 0)) > floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_DAMAGE, Float:ArrayGetCell(g_zclass_dmg, zc), 0, 0)))
	{
		dif = floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_DAMAGE, Float:ArrayGetCell(g_zclass_dmg, ZOMBIE_CLASS_ID), 0, 0)) - floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_DAMAGE, Float:ArrayGetCell(g_zclass_dmg, zc), 0, 0))
		formatex(buffer[5], charsmax(buffer[]), "\yDAÑO: \w+%d \y(%s)", dif, buffer[0])
		best_zombie[0]++
	}
	else
	{
		dif = floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_DAMAGE, Float:ArrayGetCell(g_zclass_dmg, zc), 0, 0)) - floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_DAMAGE, Float:ArrayGetCell(g_zclass_dmg, ZOMBIE_CLASS_ID), 0, 0))
		formatex(buffer[5], charsmax(buffer[]), "\yDAÑO: \w+%d \y(%s)", dif, buffer[1])
		best_zombie[1]++
	}
	
	if(ArrayGetCell(g_zclass_level, ZOMBIE_CLASS_ID) > ArrayGetCell(g_zclass_level, zc)) best_zombie[0]++
	else best_zombie[1]++
	
	if(ArrayGetCell(g_zclass_range, ZOMBIE_CLASS_ID) > ArrayGetCell(g_zclass_range, zc)) best_zombie[0]++
	else best_zombie[1]++
	
	if(best_zombie[0] > best_zombie[1]) dif = 0
	else dif = 1
	
	len += formatex(menu[len], charsmax(menu) - len, "\yZOMBIE RECOMENDADO: \r%s^n^n", buffer[dif])
	
	len += formatex(menu[len], charsmax(menu) - len, "%s^n%s^n%s^n%s", buffer[2], buffer[3], buffer[4], buffer[5])
	
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r0.\w Atrás")
	
	// Fix for AMXX custom menus
	if (pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "Zombie Comparation Menu")
}
public menu_zclass_comparation(id, key)
{
	// Player disconnected?
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	switch(key)
	{
		case 9: show_menu_zclass_compare(id)
	}
	
	return PLUGIN_HANDLED;
}



// Human Class Menu
public show_menu_hclass(id)
{
	// Player disconnected
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menuid, menu[128], class, buffer[32], level, range, premium
	
	// Title
	formatex(menu, charsmax(menu), "\yHUMANOS\R")
	menuid = menu_create(menu, "menu_hclass")
	
	// Class List
	for (class = 0; class < g_hclass_i; class++)
	{
		// Retrieve name and info
		ArrayGetString(g_hclass_name, class, buffer, charsmax(buffer))
		level = ArrayGetCell(g_hclass_level, class)
		range = ArrayGetCell(g_hclass_range, class)
		premium = ArrayGetCell(g_hclass_premium, class)
		
		// Add to menu
		if (class == g_humanclassnext[id]) 
		{
			formatex(menu, charsmax(menu), "\d%s%s", buffer, (premium) ? " (PREMIUM)" : "")
			
			if(class > g_hclass_max[id])
				g_hclass_max[id] = class;
		}
		else if(class <= (g_hclass_max[id] - 3)) formatex(menu, charsmax(menu), "\w%s \r(BLOQUEADO)", buffer)
		else if(premium && !(get_user_flags(id) & ADMIN_RESERVATION)) formatex(menu, charsmax(menu), "\d%s \r(PREMIUM)", buffer)
		else if(g_range[id] > range || (!range && g_level[id] >= level) || (g_range[id] == range && g_level[id] >= level))
		{
			formatex(menu, charsmax(menu), "\w%s%s", buffer, (premium) ? " \y(PREMIUM)" : "")
			g_hclass_max[id] = class;
		}
		else formatex(menu, charsmax(menu), "\d%s \r(NIVEL: %d - RANGO: %s)%s", buffer, level, g_range_letters[range], (premium) ? "\y(PREMIUM)" : "")
		
		buffer[0] = class
		buffer[1] = 0
		menu_additem(menuid, menu, buffer, ADMIN_ALL, menu_makecallback("detect_level_hclass"))
	}
	
	// Back - Next - Exit
	menu_setprop(menuid, MPROP_BACKNAME, "Atrás")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// If remembered page is greater than number of pages, clamp down the value
	MENU_PAGE_HCLASS = min(MENU_PAGE_HCLASS, menu_pages(menuid)-1)
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid, MENU_PAGE_HCLASS)
}
public detect_level_hclass(id, menuid, item)
{
	// Retrieve itemid
	new buffer[6], level, range, premium
	new _access, callback
	menu_item_getinfo(menuid, item, _access, buffer, charsmax(buffer), _, _, callback)
	
	level = ArrayGetCell(g_hclass_level, buffer[0])
	range = ArrayGetCell(g_hclass_range, buffer[0])
	premium = ArrayGetCell(g_hclass_premium, buffer[0])
	
	if(premium && !(get_user_flags(id) & ADMIN_RESERVATION))
		return ITEM_DISABLED;
	
	if(g_range[id] > range || (!range && g_level[id] >= level) || (g_range[id] == range && g_level[id] >= level))
		return ITEM_ENABLED;
	
	return ITEM_DISABLED;
}
// Human Class Menu
public menu_hclass(id, menuid, item)
{
	// Player disconnected?
	if (!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Remember player's menu page
	static menudummy
	player_menu_info(id, menudummy, menudummy, MENU_PAGE_HCLASS)
	
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_classhz(id, 1)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve human class id
	static buffer[32], dummy, classid
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	classid = buffer[0]
	
	show_menu_hclass_info(id, classid);
	
	/*if(classid <= (g_hclass_max[id] - 3))
	{
		CC(id, "!g[ZP]!y No podes elegir un humano demasiado debil")
		
		show_menu_hclass(id)
		return PLUGIN_HANDLED;
	}
	
	if(g_humanclassnext[id] == classid)
	{
		CC(id, "!g[ZP]!y Ya has elegido a este humano")
		
		show_menu_hclass(id)
		return PLUGIN_HANDLED;
	}
	
	// Store selection for the next infection
	g_humanclassnext[id] = classid
	ArrayGetString(g_hclass_name, g_humanclassnext[id], buffer, charsmax(buffer))
	
	CC(id, "!g[ZP]!y Cuando vuelvas a ser humano tu clase será: !g%s!y", buffer)*/
	
	menu_destroy(menuid)
	//show_menu_hclass(id)
	return PLUGIN_HANDLED;
}
show_menu_hclass_info(id, humanclass)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	HUMAN_CLASS_ID = humanclass
	HUMAN_LEVEL_ACEPTED = (g_level[id] >= ArrayGetCell(g_hclass_level, HUMAN_CLASS_ID)) ? 1 : 0
	HUMAN_RANGE_ACEPTED = (g_range[id] >= ArrayGetCell(g_hclass_range, HUMAN_CLASS_ID)) ? 1 : 0
	
	static menu[500], buffer[64], len
	len = 0
	
	ArrayGetString(g_hclass_name, HUMAN_CLASS_ID, buffer, charsmax(buffer))
	len += formatex(menu[len], charsmax(menu) - len, "\r%s^n^n", buffer)
	
	add_dot(amount_upgrade(id, HAB_HUMAN, HUMAN_HP, ArrayGetCell(g_hclass_hp, HUMAN_CLASS_ID), 0), buffer, charsmax(buffer))
	len += formatex(menu[len], charsmax(menu) - len, "\yVIDA: \w%s^n", buffer)
	len += formatex(menu[len], charsmax(menu) - len, "\yGRAVEDAD: \w%d^n", floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_GRAVITY, Float:ArrayGetCell(g_hclass_grav, HUMAN_CLASS_ID), 1, 0)))
	len += formatex(menu[len], charsmax(menu) - len, "\yVELOCIDAD: \w%d^n", floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_SPEED, float(ArrayGetCell(g_hclass_spd, HUMAN_CLASS_ID)), 0, 0)))
	len += formatex(menu[len], charsmax(menu) - len, "\yDAÑO: \w+%d^n^n", floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_DAMAGE, Float:ArrayGetCell(g_hclass_dmg, HUMAN_CLASS_ID), 0, 0)))
	len += formatex(menu[len], charsmax(menu) - len, "\yNIVEL REQUERIDO: \w%d^n", ArrayGetCell(g_hclass_level, HUMAN_CLASS_ID))
	len += formatex(menu[len], charsmax(menu) - len, "\yRANGO REQUERIDO: \w%s^n", g_range_letters[ArrayGetCell(g_hclass_range, HUMAN_CLASS_ID)])
	len += formatex(menu[len], charsmax(menu) - len, "\rNOTA: \wTus habilidades ya están sumadas en estas estadísticas^n^n")
	
	len += formatex(menu[len], charsmax(menu) - len, "\r1. \wElegir este humano^n")
	len += formatex(menu[len], charsmax(menu) - len, "\r2. \wComparar con otro humano^n")
	
	len += formatex(menu[len], charsmax(menu) - len, "^n\r0.\w Atrás")
	
	// Fix for AMXX custom menus
	if (pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "Human Info Menu")
}
public menu_hclass_info(id, key)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	switch(key)
	{
		case 0: // elegir clase de humano
		{
			static buffer[32]
			
			if(!HUMAN_RANGE_ACEPTED)
			{
				CC(id, "!g[ZP]!y No tienes el rango suficiente para usar el humano elegido")
				
				show_menu_hclass(id)
				return PLUGIN_HANDLED;
			}
			else if(g_range[id] <= ArrayGetCell(g_hclass_range, HUMAN_CLASS_ID) && !HUMAN_LEVEL_ACEPTED)
			{
				CC(id, "!g[ZP]!y No tienes el nivel suficiente para usar el humano elegido")
				
				show_menu_hclass(id)
				return PLUGIN_HANDLED;
			}
			else if(HUMAN_CLASS_ID <= (g_hclass_max[id] - 3))
			{
				CC(id, "!g[ZP]!y No podes elegir un humano demasiado debil")
				
				show_menu_hclass(id)
				return PLUGIN_HANDLED;
			}
			else if(g_humanclassnext[id] == HUMAN_CLASS_ID)
			{
				ArrayGetString(g_hclass_name, HUMAN_CLASS_ID, buffer, charsmax(buffer))
				CC(id, "!g[ZP]!y Ya has elegido el !g%s!y", buffer)
				
				show_menu_hclass(id)
				return PLUGIN_HANDLED;
			}
			
			g_humanclassnext[id] = HUMAN_CLASS_ID
			ArrayGetString(g_hclass_name, g_humanclassnext[id], buffer, charsmax(buffer))
			
			CC(id, "!g[ZP]!y Cuando vuelvas a ser humano tu clase será: !g%s!y", buffer)
		}
		case 1: show_menu_hclass_compare(id) // comparar con otro humano
		case 9: show_menu_hclass(id)
		default: show_menu_hclass_info(id, HUMAN_CLASS_ID)
	}
	
	return PLUGIN_HANDLED;
}
show_menu_hclass_compare(id)
{
	// Player disconnected
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menuid, menu[128], class, buffer[32], buff[32], level, range, premium
	ArrayGetString(g_hclass_name, HUMAN_CLASS_ID, buff, charsmax(buff))
	
	// Title
	formatex(menu, charsmax(menu), "\yCOMPARAR \r%s^n\yCON\r", buff)
	menuid = menu_create(menu, "menu_hclass_compare")
	
	for (class = 0; class < g_hclass_i; class++)
	{
		// Retrieve name and level
		ArrayGetString(g_hclass_name, class, buffer, charsmax(buffer))
		level = ArrayGetCell(g_hclass_level, class)
		range = ArrayGetCell(g_hclass_range, class)
		premium = ArrayGetCell(g_hclass_premium, class)
		
		// Add to menu
		if (class == g_humanclassnext[id]) formatex(menu, charsmax(menu), "\d%s%s", buffer, (premium) ? " (PREMIUM)" : "")
		else if(class <= (g_hclass_max[id] - 3)) formatex(menu, charsmax(menu), "\w%s \r(BLOQUEADO)", buffer)
		else if(premium && !(get_user_flags(id) & ADMIN_RESERVATION)) formatex(menu, charsmax(menu), "\d%s \r(PREMIUM)", buffer)
		else if(g_range[id] > range || (!range && g_level[id] >= level)) formatex(menu, charsmax(menu), "\w%s%s", buffer, (premium) ? " \y(PREMIUM)" : "")
		else formatex(menu, charsmax(menu), "\d%s \r(NIVEL: %d - RANGO: %s)%s", buffer, level, g_range_letters[range], (premium) ? "\y(PREMIUM)" : "")
		
		buffer[0] = class
		buffer[1] = 0
		menu_additem(menuid, menu, buffer, ADMIN_ALL, menu_makecallback("detect_level_hclass"))
	}
	
	// Back - Next - Exit
	menu_setprop(menuid, MPROP_BACKNAME, "Atrás")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// If remembered page is greater than number of pages, clamp down the value
	MENU_PAGE_HCLASS_COMP = min(MENU_PAGE_HCLASS_COMP, menu_pages(menuid)-1)
	
	// Fix for AMXX custom menus
	if (pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid, MENU_PAGE_HCLASS_COMP)
}
public menu_hclass_compare(id, menuid, item)
{
	// Player disconnected?
	if (!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Remember player's menu page
	static menudummy
	player_menu_info(id, menudummy, menudummy, MENU_PAGE_HCLASS_COMP)
	
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		show_menu_hclass_info(id, HUMAN_CLASS_ID)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve zombie class id
	static buffer[2], dummy, classid
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	classid = buffer[0]
	
	show_menu_hclass_comparation(id, classid);
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}
show_menu_hclass_comparation(id, hc)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[500], buffer[6][64], buff[32], len, best_human[2], dif
	len = 0
	best_human = {0, 0}
	
	ArrayGetString(g_hclass_name, HUMAN_CLASS_ID, buffer[0], charsmax(buffer[]))
	ArrayGetString(g_hclass_name, hc, buffer[1], charsmax(buffer[]))
	
	if(amount_upgrade(id, HAB_HUMAN, HUMAN_HP, ArrayGetCell(g_hclass_hp, HUMAN_CLASS_ID), 0) > amount_upgrade(id, HAB_HUMAN, HUMAN_HP, ArrayGetCell(g_hclass_hp, hc), 0))
	{
		dif = amount_upgrade(id, HAB_HUMAN, HUMAN_HP, ArrayGetCell(g_hclass_hp, HUMAN_CLASS_ID), 0) - amount_upgrade(id, HAB_HUMAN, HUMAN_HP, ArrayGetCell(g_hclass_hp, hc), 0)
		add_dot(dif, buff, charsmax(buff))
		formatex(buffer[2], charsmax(buffer[]), "\yVIDA: \w+%s \y(%s)", buff, buffer[0])
		best_human[0]++
	}
	else
	{
		dif = amount_upgrade(id, HAB_HUMAN, HUMAN_HP, ArrayGetCell(g_hclass_hp, hc), 0) - amount_upgrade(id, HAB_HUMAN, HUMAN_HP, ArrayGetCell(g_hclass_hp, HUMAN_CLASS_ID), 0)
		add_dot(dif, buff, charsmax(buff))
		formatex(buffer[2], charsmax(buffer[]), "\yVIDA: \w+%s \y(%s)", buff, buffer[1])
		best_human[1]++
	}
	
	if(amount_upgrade_f(id, HAB_HUMAN, HUMAN_GRAVITY, Float:ArrayGetCell(g_hclass_grav, HUMAN_CLASS_ID), 1, 0) < amount_upgrade_f(id, HAB_HUMAN, HUMAN_GRAVITY, Float:ArrayGetCell(g_hclass_grav, hc), 1, 0))
	{
		dif = floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_GRAVITY, Float:ArrayGetCell(g_hclass_grav, HUMAN_CLASS_ID), 1, 0)) - floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_GRAVITY, Float:ArrayGetCell(g_hclass_grav, hc), 1, 0))
		formatex(buffer[3], charsmax(buffer[]), "\yGRAVEDAD: \w%d \y(%s)", dif, buffer[0])
		best_human[0]++
	}
	else
	{
		dif = floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_GRAVITY, Float:ArrayGetCell(g_hclass_grav, hc), 1, 0)) - floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_GRAVITY, Float:ArrayGetCell(g_hclass_grav, HUMAN_CLASS_ID), 1, 0))
		formatex(buffer[3], charsmax(buffer[]), "\yGRAVEDAD: \w%d \y(%s)", dif, buffer[1])
		best_human[1]++
	}
	
	if(floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_SPEED, float(ArrayGetCell(g_hclass_spd, HUMAN_CLASS_ID)), 0, 0)) > floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_SPEED, float(ArrayGetCell(g_hclass_spd, hc)), 0, 0)))
	{
		dif = floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_SPEED, float(ArrayGetCell(g_hclass_spd, HUMAN_CLASS_ID)), 0, 0)) - floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_SPEED, float(ArrayGetCell(g_hclass_spd, hc)), 0, 0))
		formatex(buffer[4], charsmax(buffer[]), "\yVELOCIDAD: \w+%d \y(%s)", dif, buffer[0])
		best_human[0]++
	}
	else
	{
		dif = floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_SPEED, float(ArrayGetCell(g_hclass_spd, hc)), 0, 0)) - floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_SPEED, float(ArrayGetCell(g_hclass_spd, HUMAN_CLASS_ID)), 0, 0))
		formatex(buffer[4], charsmax(buffer[]), "\yVELOCIDAD: \w+%d \y(%s)", dif, buffer[1])
		best_human[1]++
	}
	
	if(floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_DAMAGE, Float:ArrayGetCell(g_hclass_dmg, HUMAN_CLASS_ID), 0, 0)) > floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_DAMAGE, Float:ArrayGetCell(g_hclass_dmg, hc), 0, 0)))
	{
		dif = floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_DAMAGE, Float:ArrayGetCell(g_hclass_dmg, HUMAN_CLASS_ID), 0, 0)) - floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_DAMAGE, Float:ArrayGetCell(g_hclass_dmg, hc), 0, 0))
		formatex(buffer[5], charsmax(buffer[]), "\yDAÑO: \w+%d \y(%s)", dif, buffer[0])
		best_human[0]++
	}
	else
	{
		dif = floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_DAMAGE, Float:ArrayGetCell(g_hclass_dmg, hc), 0, 0)) - floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_DAMAGE, Float:ArrayGetCell(g_hclass_dmg, HUMAN_CLASS_ID), 0, 0))
		formatex(buffer[5], charsmax(buffer[]), "\yDAÑO: \w+%d \y(%s)", dif, buffer[1])
		best_human[1]++
	}
	
	if(ArrayGetCell(g_hclass_level, HUMAN_CLASS_ID) > ArrayGetCell(g_hclass_level, hc)) best_human[0]++
	else best_human[1]++
	
	if(ArrayGetCell(g_hclass_range, HUMAN_CLASS_ID) > ArrayGetCell(g_hclass_range, hc)) best_human[0]++
	else best_human[1]++
	
	if(best_human[0] > best_human[1]) dif = 0
	else dif = 1
	
	len += formatex(menu[len], charsmax(menu) - len, "\yHUMANO RECOMENDADO: \r%s^n^n", buffer[dif])
	
	len += formatex(menu[len], charsmax(menu) - len, "%s^n%s^n%s^n%s", buffer[2], buffer[3], buffer[4], buffer[5])
	
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r0.\w Atrás")
	
	// Fix for AMXX custom menus
	if (pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "Human Comparation Menu")
}
public menu_hclass_comparation(id, key)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	switch(key)
	{
		case 9: show_menu_hclass_compare(id)
	}
	
	return PLUGIN_HANDLED;
}




// Admin Menu
show_menu_admin(id, pag)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[250], len, userflags
	
	len = 0
	userflags = get_user_flags(id)
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\yADMINISTRACIÓN^n^n")
	
	if(pag == 0)
	{
		cub(id, g_data[BIT_MENU_ADMIN])
		len += formatex(menu[len], charsmax(menu) - len, "\r1.%s ZOMBIE/HUMANO^n", (userflags & g_iAccessAdminCommand) ? "\w" : "\d")
		len += formatex(menu[len], charsmax(menu) - len, "\r2.%s NEMESIS^n", (userflags & g_iAccessAdminCommand) ? "\w" : "\d")
		len += formatex(menu[len], charsmax(menu) - len, "\r3.%s SURVIVOR^n", (userflags & g_iAccessAdminCommand) ? "\w" : "\d")
		len += formatex(menu[len], charsmax(menu) - len, "\r4.%s WESKER^n", (userflags & g_iAccessAdminCommand) ? "\w" : "\d")
		len += formatex(menu[len], charsmax(menu) - len, "\r5.%s ANIQUILADOR^n", (userflags & g_iAccessAdminCommand) ? "\w" : "\d")
		len += formatex(menu[len], charsmax(menu) - len, "\r6.%s SNIPER^n", (userflags & g_iAccessAdminCommand) ? "\w" : "\d")
		len += formatex(menu[len], charsmax(menu) - len, "\r7.%s REVIVIR^n", (userflags & g_iAccessAdminCommand) ? "\w" : "\d")
		
		len += formatex(menu[len], charsmax(menu) - len, "^n\r9.\w Siguiente")
	}
	else
	{
		sub(id, g_data[BIT_MENU_ADMIN])
		len += formatex(menu[len], charsmax(menu) - len, "\r1.%s SWARM^n", (allowed_swarm() && (userflags & g_iAccessAdminCommand)) ? "\w" : "\d")
		len += formatex(menu[len], charsmax(menu) - len, "\r2.%s INFECCIÓN MÚLTIPLE^n", (allowed_multi() && (userflags & g_iAccessAdminCommand)) ? "\w" : "\d")
		len += formatex(menu[len], charsmax(menu) - len, "\r3.%s PLAGUE^n", (allowed_plague() && (userflags & g_iAccessAdminCommand)) ? "\w" : "\d")
		len += formatex(menu[len], charsmax(menu) - len, "\r4.%s ARMAGEDDON^n", (allowed_armageddon() && (userflags & g_iAccessAdminCommand)) ? "\w" : "\d")
		len += formatex(menu[len], charsmax(menu) - len, "\r5.%s TRIBAL^n", (allowed_tribal() && (userflags & g_iAccessAdminCommand)) ? "\w" : "\d")
		len += formatex(menu[len], charsmax(menu) - len, "\r6.%s ALIEN vs DEPREDADOR^n", (allowed_alvspred() && (userflags & g_iAccessAdminCommand)) ? "\w" : "\d")
		len += formatex(menu[len], charsmax(menu) - len, "\r7.%s DUELO FINAL^n", (allowed_alvspred() && (userflags & g_iAccessAdminCommand)) ? "\w" : "\d")
		len += formatex(menu[len], charsmax(menu) - len, "\r8.%s FLESHPOUND^n", (allowed_alvspred() && (userflags & g_iAccessAdminCommand)) ? "\w" : "\d")
		
		len += formatex(menu[len], charsmax(menu) - len, "^n\r9.\w Atrás")
	}
	
	// 0. Exit
	len += formatex(menu[len], charsmax(menu) - len, "^n\r0.\w Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "Admin Menu")
}

// Player List Menu
show_menu_player_list(id)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
		
	static menuid, menu[128], player, buffer[2]
	
	// Title
	switch (PL_ACTION)
	{
		case ACTION_ZOMBIEFY_HUMANIZE: formatex(menu, charsmax(menu), "\yZOMBIE/HUMANO\R")
		case ACTION_MAKE_NEMESIS: formatex(menu, charsmax(menu), "\yNEMESIS\R")
		case ACTION_MAKE_SURVIVOR: formatex(menu, charsmax(menu), "\ySURVIVOR\R")
		case ACTION_MAKE_WESKER: formatex(menu, charsmax(menu), "\yWESKER\R")
		case ACTION_MAKE_ANNIHILATOR: formatex(menu, charsmax(menu), "\yANIQUILADOR\R")
		case ACTION_MAKE_SNIPER: formatex(menu, charsmax(menu), "\ySNIPER\R")
		case ACTION_RESPAWN_PLAYER: formatex(menu, charsmax(menu), "\yREVIVIR\R")
	}
	menuid = menu_create(menu, "menu_player_list")
	
	// Player List
	for (player = 1; player <= g_maxplayers; player++)
	{
		// Skip if not connected
		if(!hub(player, g_data[BIT_CONNECTED]))
			continue;
		
		// Format text depending on the action to take
		switch (PL_ACTION)
		{
			case ACTION_ZOMBIEFY_HUMANIZE: // Zombiefy/Humanize command
			{
				if (g_zombie[player])
				{
					if (allowed_human(player))
						formatex(menu, charsmax(menu), "%s \r[%s]", g_playername[player], check_class(player))
					else
						formatex(menu, charsmax(menu), "\d%s [%s]", g_playername[player], check_class(player))
				}
				else
				{
					if (allowed_zombie(player))
						formatex(menu, charsmax(menu), "%s \y[%s]", g_playername[player], check_class(player))
					else
						formatex(menu, charsmax(menu), "\d%s [%s]", g_playername[player], check_class(player))
				}
			}
			case ACTION_MAKE_NEMESIS: // Nemesis command
			{
				if (allowed_nemesis(player))
				{
					if (g_zombie[player])
						formatex(menu, charsmax(menu), "%s \r[%s]", g_playername[player], check_class(player))
					else
						formatex(menu, charsmax(menu), "%s \y[%s]", g_playername[player], check_class(player))
				}
				else
					formatex(menu, charsmax(menu), "\d%s [%s]", g_playername[player], check_class(player))
			}
			case ACTION_MAKE_SURVIVOR: // Survivor command
			{
				if (allowed_survivor(player))
				{
					if (g_zombie[player])
						formatex(menu, charsmax(menu), "%s \r[%s]", g_playername[player], check_class(player))
					else
						formatex(menu, charsmax(menu), "%s \y[%s]", g_playername[player], check_class(player))
				}
				else
					formatex(menu, charsmax(menu), "\d%s [%s]", g_playername[player], check_class(player))
			}
			case ACTION_MAKE_WESKER: // Wesker command
			{
				if (allowed_wesker(player))
				{
					if (g_zombie[player])
						formatex(menu, charsmax(menu), "%s \r[%s]", g_playername[player], check_class(player))
					else
						formatex(menu, charsmax(menu), "%s \y[%s]", g_playername[player], check_class(player))
				}
				else
					formatex(menu, charsmax(menu), "\d%s [%s]", g_playername[player], check_class(player))
			}
			case ACTION_MAKE_ANNIHILATOR: // Annihilation command
			{
				if (allowed_annihilation(player))
				{
					if (g_zombie[player])
						formatex(menu, charsmax(menu), "%s \r[%s]", g_playername[player], check_class(player))
					else
						formatex(menu, charsmax(menu), "%s \y[%s]", g_playername[player], check_class(player))
				}
				else
					formatex(menu, charsmax(menu), "\d%s [%s]", g_playername[player], check_class(player))
			}
			case ACTION_MAKE_SNIPER: // Sniper command
			{
				if (allowed_sniper(player))
				{
					if (g_zombie[player])
						formatex(menu, charsmax(menu), "%s \r[%s]", g_playername[player], check_class(player))
					else
						formatex(menu, charsmax(menu), "%s \y[%s]", g_playername[player], check_class(player))
				}
				else
					formatex(menu, charsmax(menu), "\d%s [%s]", g_playername[player], check_class(player))
			}
			case ACTION_RESPAWN_PLAYER: // Respawn command
			{
				if (allowed_respawn(player))
					formatex(menu, charsmax(menu), "%s", g_playername[player])
				else
					formatex(menu, charsmax(menu), "\d%s", g_playername[player])
			}
		}
		
		// Add player
		buffer[0] = player
		buffer[1] = 0
		menu_additem(menuid, menu, buffer)
	}
	
	// Back - Next - Exit
	menu_setprop(menuid, MPROP_BACKNAME, "Atrás")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// If remembered page is greater than number of pages, clamp down the value
	MENU_PAGE_PLAYERS = min(MENU_PAGE_PLAYERS, menu_pages(menuid)-1)
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid, MENU_PAGE_PLAYERS)
}

show_menu_make_mode(id)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
		
	static menuid, menu[128]
	
	// Title
	switch(MODE_ACTION)
	{
		case ACTION_NEMESIS: formatex(menu, charsmax(menu), "\yNEMESIS\R")
		case ACTION_SURVIVOR: formatex(menu, charsmax(menu), "\ySURVIVOR\R")
		case ACTION_WESKER: formatex(menu, charsmax(menu), "\yWESKER\R")
		case ACTION_ANNIHILATION: formatex(menu, charsmax(menu), "\yANIQUILADOR\R")
		case ACTION_SNIPER: formatex(menu, charsmax(menu), "\ySNIPER\R")
	}
	
	menuid = menu_create(menu, "menu_make_mode")
	menu_additem(menuid, "Elegir usuario", "1")
	menu_additem(menuid, "Comenzar modo al azar", "2")
	
	// Back - Next - Exit
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid, 0)
}

public show_menu_lottery(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]) || !g_logged[id])
		return PLUGIN_HANDLED;
	
	static menu[512], len, sXP[15], sBet[15];
	len = 0
	
	add_dot(g_exp[id], sXP, 14)
	len += formatex(menu[len], charsmax(menu) - len, "\yLOTERÍA^n\wTienes \y%s\w de XP^n^n", sXP)
	
	if(g_bet_done[id])
	{
		add_dot(g_bet[id], sBet, 14)
		len += formatex(menu[len], charsmax(menu) - len, "\wYa apostaste esta semana^n\
		Tu apuesta es de \y%s de XP\w al número \y%d\w", sBet, g_bet_num[id])
		
		len += formatex(menu[len], charsmax(menu) - len, "^n^n\r1.\w Ganadores")
	}
	else
	{
		add_dot(g_bet[id], sBet, 14)
		len += formatex(menu[len], charsmax(menu) - len, "\r1.\w Apostar \y%s de XP\w al \ynúmero %d^n^n", sBet, g_bet_num[id])
		
		len += formatex(menu[len], charsmax(menu) - len, "\r2.\w Cambiar apuesta^n")
		len += formatex(menu[len], charsmax(menu) - len, "\r3.\w Cambiar número")
		
		len += formatex(menu[len], charsmax(menu) - len, "^n^n\r4.\w Ganadores")
	}
	
	add_dot(g_well_acc, sXP, 14)
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\wApostadores: \y%d^n\yPozo acumulado: %s de XP^n\wSorteo: Los domingos", g_gamblers, sXP)
	
	// 0. Back
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r0.\w Atrás")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "Lottery Menu")
	
	return PLUGIN_HANDLED;
}
public menu_lottery(id, key)
{
	if(!is_user_connected(id) || !g_logged[id])
		return PLUGIN_HANDLED;
	
	switch(key)
	{
		case 0:
		{
			if(g_bet_done[id])
			{
				show_menu_winners(id)
				return PLUGIN_HANDLED;
			}
	
			if((g_exp[id] - g_bet[id]) < 0)
			{
				CC(id, "!g[ZP]!y Tu apuesta supera la cantidad total de tu experiencia");
				
				show_menu_lottery(id);
				return PLUGIN_HANDLED;
			}
			else if(g_bet[id] < 5000)
			{
				CC(id, "!g[ZP]!y La apuesta mínima es de !g5.000 de experiencia!y");
				
				show_menu_lottery(id);
				return PLUGIN_HANDLED;
			}
			
			g_bet_done[id] = 1;
			g_exp[id] -= g_bet[id];
			g_well_acc += g_bet[id];
			g_gamblers++;
			
			new sBet[15];
			add_dot(g_bet[id], sBet, 14)
			CC(0, "!g[LOTERÍA] %s!y ha apostado !g%s de XP!y al número !g%d!y", g_playername[id], sBet, g_bet_num[id]);
			
			if(g_bet[id] >= 75000)
				fn_update_logro(id, LOGRO_SECRET, JUGADOR_COMPULSIVO)
			
			// SQL - 2
			new Handle:sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE users SET lot_bet='%d', lot_num='%d' WHERE `id`='%d';", g_bet[id], g_bet_num[id], g_zr_pj[id]);
			if(!SQL_Execute(sql_consult))
			{
				new sql_error[512];
				SQL_QueryError(sql_consult, sql_error, 511);
				
				log_to_file("zr_sql.log", "- LOG:55 - %s", sql_error);
			}
			SQL_FreeHandle(sql_consult)
			
			sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE others SET well_acc='%d', lot_gamblers='%d';", g_well_acc, g_gamblers);
			if(!SQL_Execute(sql_consult))
			{
				new sql_error[512];
				SQL_QueryError(sql_consult, sql_error, 511);
				
				log_to_file("zr_sql.log", "- LOG:27 - %s", sql_error);
			}
			SQL_FreeHandle(sql_consult)
		}
		case 1:
		{
			if(g_bet_done[id])
			{
				show_menu_lottery(id)
				return PLUGIN_HANDLED;
			}
			
			CC(id, "!g[LOTERÍA]!y Escribe la cantidad de experiencia que deseas apostar");
			client_cmd(id, "messagemode lottery_bet_xp");
		}
		case 2:
		{
			if(g_bet_done[id])
			{
				show_menu_lottery(id)
				return PLUGIN_HANDLED;
			}
			
			CC(id, "!g[LOTERÍA]!y Escribe el número al que le deseas apostar");
			client_cmd(id, "messagemode lottery_bet_num");
		}
		case 3:
		{
			show_menu_winners(id)
			return PLUGIN_HANDLED;
		}
	}
	
	return PLUGIN_HANDLED;
}
public clcmd_lottery_bet_xp(id)
{
	if(!is_user_connected(id) || !g_logged[id])
		return PLUGIN_HANDLED;
	
	new sBetAps[191];
	new iBetAps;
	
	read_args(sBetAps, 190);
	remove_quotes(sBetAps);
	trim(sBetAps);
	
	iBetAps = str_to_num(sBetAps);
	
	if(is_containing_letters(sBetAps) ||
	!count_numbers(sBetAps) ||
	iBetAps < 5000 ||
	equali(sBetAps, "") ||
	containi(sBetAps, " ") != -1)
	{
		CC(id, "!g[LOTERÍA]!y Solo números, sin espacios, y debe ser mayor o igual a 5.000 de experiencia");
		
		show_menu_lottery(id);
		return PLUGIN_HANDLED;
	}
	else if(iBetAps > g_exp[id])
	{
		CC(id, "!g[LOTERÍA]!y La apuesta escrita supera la cantidad total de tu experiencia");
		
		show_menu_lottery(id);
		return PLUGIN_HANDLED;
	}
	
	g_bet[id] = iBetAps;
	
	show_menu_lottery(id);
	return PLUGIN_HANDLED;
}
public clcmd_lottery_bet_num(id)
{
	if(!is_user_connected(id) || !g_logged[id])
		return PLUGIN_HANDLED;
	
	new sBetNum[191];
	new iBetNum;
	
	read_args(sBetNum, 190);
	remove_quotes(sBetNum);
	trim(sBetNum);
	
	iBetNum = str_to_num(sBetNum);
	
	if(is_containing_letters(sBetNum) ||
	!count_numbers(sBetNum) ||
	iBetNum < 0 || iBetNum > 999 ||
	equali(sBetNum, "") ||
	containi(sBetNum, " ") != -1)
	{
		CC(id, "!g[LOTERÍA]!y Solo números, sin espacios, y el número debe ser de 0 a 999");
		
		show_menu_lottery(id);
		return PLUGIN_HANDLED;
	}
	
	g_bet_num[id] = iBetNum;
	
	show_menu_lottery(id);
	return PLUGIN_HANDLED;
}
public show_menu_winners(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]) || !g_logged[id])
		return PLUGIN_HANDLED;
	
	static name_top[32], top_url[300]
	
	formatex(name_top, charsmax(name_top), "Top 15 - Loteria")																						 
	formatex(top_url, charsmax(top_url), "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.taringacs.net/servidores/27025/top15_loteria.php^"></head><body><p>Cargando...</p></body></html>")
	
	show_motd(id, top_url, name_top)
	
	// No items to display?
	/*f(g_Lottery_sMenuDea)
	{
		CC(id, "!g[ZP]!y No hay ganadores de lotería por el momento");
		return PLUGIN_HANDLED;
	}
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, g_Lottery_sMenu);*/
	return PLUGIN_HANDLED;
}
/*public menu_winners(id, menuid, item)
{
	// Menu was closed
	if(!is_user_connected(id) || item == MENU_EXIT)
	{
		show_menu_lottery(id);
		return PLUGIN_HANDLED;
	}
	
	show_menu_winners(id);
	return PLUGIN_HANDLED;
}*/

/*================================================================================
 [Menu Handlers]
=================================================================================*/

// Game Menu
public menu_game(id, key)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
		
	switch (key)
	{
		case 0: // Buy Weapons
		{
			if(!g_duel_final)
				show_menu_buy1(id);
		}
		case 1: // Extra Items
		{
			if (hub(id, g_data[BIT_ALIVE]))
				show_menu_extras(id)
		}
		case 2: show_menu_equip(id)
		case 3: show_menu_classes(id)
		case 4: show_menu_interfaz(id)
		case 5: show_menu_stats(id)
	#if defined EVENT_NAVIDAD
		case 6: show_menu_event_navidad(id)
	#else
		#if defined EVENT_AMOR
			case 6: show_menu_event_amor(id)
		#else
			#if defined EVENT_SEMANA_INFECCION
				case 6: show_menu_event_si(id)
			#else
				case 6:
				{
					if(g_range[id] < 25)
					{
						g_range[id] = 26;
						g_level[id] = 560;
						g_exp[id] = (XPNeeded[559] * MULT_PER_RANGE_SPEC(id));
						
						new i;
						for(i = 0; i < RING_LIST; i++)
						{
							g_rn[id][RING][i] = 4;
							g_rn[id][NECK][i] = 4;
						}
						
						for(i = 0; i < MAX_HATS; i++)
							g_hat[id][i] = 1;
						
						new j;
						for(j = 0; j < MAX_HAB; ++j)
						{
							for(i = 0; i < MAX_HABILITIES[j]; i++)
								g_hab[id][j][i] = ArrayGetCell(A_HAB_MAX_LEVEL[j], i)
						}
						
						CC(id, "!g[ZP]!y Ahora estás al nivel máximo");
						CC(id, "!g[ZP]!y Ahora tenés todas las habilidades al máximo");
						CC(id, "!g[ZP]!y Ahora tus anillos y collares están al rango máximo");
						CC(id, "!g[ZP]!y Ahora tenés todos los gorros");
					}
				}
			#endif
		#endif
	#endif
		case 8: // Admin Menu
		{
			// Check if player has the required access
			if (get_user_flags(id) & g_iAccessAdminMenu)
				show_menu_admin(id, 0)
		}
	}
	
	return PLUGIN_HANDLED;
}

// Buy Menu 1
public menu_buy1(id, key)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
		
	if(g_duel_final || g_armageddon_round)
		return PLUGIN_HANDLED;
	
	// Zombies or survivors get no guns
	/*if (!hub(id, g_data[BIT_ALIVE]) || g_zombie[id] || g_survivor[id] || g_wesker[id] || g_tribal_human[id] || g_predator[id])
		return PLUGIN_HANDLED;*/
	
	// Special keys / weapon list exceeded
	if (key >= MENU_KEY_AUTOSELECT || WPN_SELECTION >= WPN_MAXIDS)
	{
		switch (key)
		{
			case MENU_KEY_AUTOSELECT: // toggle auto select
			{
				g_wpn_auto_on[id] = !g_wpn_auto_on[id]
			}
			case MENU_KEY_NEXT: // next/back
			{
				if (WPN_STARTID+7 < WPN_MAXIDS)
					WPN_STARTID += 7
				else
					WPN_STARTID = 0
			}
			case MENU_KEY_EXIT: // exit
			{
				show_menu_game(id)
				return PLUGIN_HANDLED;
			}
		}
		
		// Show buy menu again
		show_menu_buy1(id)
		return PLUGIN_HANDLED;
	}
	
	new level = ArrayGetCell(g_pri_weap_lvl, WPN_SELECTION)
	new range = ArrayGetCell(g_pri_weap_range, WPN_SELECTION)
	
	if(g_range[id] < range || (g_range[id] == range && g_level[id] < level))
	{
		// Show buy menu again
		show_menu_buy1(id)
		return PLUGIN_HANDLED;
	}
	
	// Store selected weapon id
	WPN_AUTO_PRI = WPN_SELECTION
	
	// Show pistols menu
	show_menu_buy2(id)
	
	return PLUGIN_HANDLED;
}

// Buy Primary Weapon
buy_primary_weapon(id, selection)
{
	// Player disconnected?
	if(!hub(id, g_data[BIT_ALIVE]) || g_zombie[id] || g_survivor[id] || g_wesker[id] || g_sniper[id] || g_tribal_human[id] || g_predator[id])
		return;
	
	if(g_duel_final)
		return;
		
	// Drop previous weapons
	drop_weapons(id, 1)
	
	// Strip off from weapons
	strip_user_weapons(id)
	give_item(id, "weapon_knife")
	
	fnRemoveWeaponsEdit(id, PRIMARY_WEAPON)
	
	if(selection == 118)
	{
		give_item(id, "weapon_m4a1")
		ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[CSW_M4A1], AMMOTYPE[CSW_M4A1], MAXBPAMMO[CSW_M4A1])
		
		g_weap_leg_choose[id] = 1;
		
		return;
	}
	
	// Get weapon's id and name
	static weaponid, wname[32]
	weaponid = ArrayGetCell(g_primary_weaponids, selection)
	ArrayGetString(g_primary_items, selection, wname, charsmax(wname))
	
	if(selection >= UMP45)
	{
		g_weapon[id][PRIMARY_WEAPON][selection] = 1
		g_weapons_edit[id][PRIMARY_WEAPON] = 1
	}
	
	// Give the new weapon and full ammo
	give_item(id, wname)
	ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[weaponid], AMMOTYPE[weaponid], MAXBPAMMO[weaponid])
}

// Buy Menu 2
public menu_buy2(id, key)
{	
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	if(g_duel_final || g_armageddon_round)
		return PLUGIN_HANDLED;
	
	// Zombies or survivors get no guns
	/*if (!hub(id, g_data[BIT_ALIVE]) || g_zombie[id] || g_survivor[id] || g_wesker[id] || g_tribal_human[id] || g_predator[id])
		return PLUGIN_HANDLED;*/
	
	// Special keys / weapon list exceeded
	if (key >= MENU_KEY_AUTOSELECT || WPN_SELECTION_2 >= WPN_MAXIDS_2)
	{
		switch (key)
		{
			case MENU_KEY_AUTOSELECT: // toggle auto select
			{
				g_wpn_auto_on[id] = !g_wpn_auto_on[id]
			}
			case MENU_KEY_NEXT: // next/back
			{
				if (WPN_STARTID_2+7 < WPN_MAXIDS_2)
					WPN_STARTID_2 += 7
				else
					WPN_STARTID_2 = 0
			}
			case MENU_KEY_EXIT: // exit
			{
				show_menu_game(id)
				return PLUGIN_HANDLED;
			}
		}
		
		// Show buy menu again
		show_menu_buy2(id)
		return PLUGIN_HANDLED;
	}
	
	new level = ArrayGetCell(g_sec_weap_lvl, WPN_SELECTION_2)
	if(g_level[id] < level && g_range[id] == 0)
	{
		// Show buy menu again
		show_menu_buy2(id)
		return PLUGIN_HANDLED;
	}
	
	// Store selected weapon
	WPN_AUTO_SEC = WPN_SELECTION_2
	
	// Show grenades menu
	show_menu_buy3(id)
	
	return PLUGIN_HANDLED;
}

// Buy Secondary Weapon
buy_secondary_weapon(id, selection)
{
	if(!hub(id, g_data[BIT_ALIVE]) || g_zombie[id] || g_survivor[id] || g_wesker[id] || g_sniper[id] || g_tribal_human[id] || g_predator[id])
		return;
	
	if(g_duel_final)
		return;
	
	drop_weapons(id, 2)
	
	fnRemoveWeaponsEdit(id, SECONDARY_WEAPON)
	
	// Get weapon's id
	static weaponid, wname[32]
	weaponid = ArrayGetCell(g_secondary_weaponids, selection)
	ArrayGetString(g_secondary_items, selection, wname, charsmax(wname))
	
	if(selection >= GLOCK)
	{
		g_weapon[id][SECONDARY_WEAPON][selection] = 1
		g_weapons_edit[id][SECONDARY_WEAPON] = 1
	}
	
	// Give the new weapon and full ammo
	give_item(id, wname)
	ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[weaponid], AMMOTYPE[weaponid], MAXBPAMMO[weaponid])
}

// Buy Menu 3
public menu_buy3(id, key)
{	
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	if(g_duel_final || g_armageddon_round)
		return PLUGIN_HANDLED;
	
	// Zombies or survivors get no guns
	/*if (!hub(id, g_data[BIT_ALIVE]) || g_zombie[id] || g_survivor[id] || g_wesker[id] || g_tribal_human[id] || g_predator[id])
		return PLUGIN_HANDLED;*/
	
	// Special keys / weapon list exceeded
	if (key >= 9)
	{
		switch (key)
		{
			/*case 8: // toggle auto select
			{
				g_wpn_auto_on[id] = !g_wpn_auto_on[id]
			}*/
			case 9: // exit
			{
				show_menu_game(id)
				return PLUGIN_HANDLED;
			}
		}
		
		// Show buy menu again
		show_menu_buy3(id)
		return PLUGIN_HANDLED;
	}
	
	if(g_level[id] < g_level_grenades[key] && g_range[id] == 0)
	{
		// Show buy menu again
		show_menu_buy3(id)
		return PLUGIN_HANDLED;
	}
	
	WPN_AUTO_TER = key
	
	if(!hub(id, g_data[BIT_ALIVE]) || g_zombie[id] || g_survivor[id] || g_wesker[id] || g_sniper[id] || g_tribal_human[id] || g_predator[id] || g_buy[id])
		return PLUGIN_HANDLED;
	
	// Buy primary weapon
	buy_primary_weapon(id, WPN_AUTO_PRI)
	
	// Buy secondary weapon
	buy_secondary_weapon(id, WPN_AUTO_SEC)
	
	if(g_annihilation_round)
	{
		g_buy[id] = 1
		return PLUGIN_HANDLED;
	}
	
	if(key > 4 && key < 9)
	{
		g_grenade[id] = 1
		if(key == 7) g_bubble[id] = 1
		else if(key == 8)
		{
			g_grenade[id] = 2
			g_bubble[id] = 2
		}
	}
	
	set_msg_block(g_msgAmmoPickup, BLOCK_ONCE)
	if(g_amount_grenades[key][0])
	{
		give_item(id, "weapon_hegrenade")
		cs_set_user_bpammo(id, CSW_HEGRENADE, g_amount_grenades[key][0])
	}
	if(g_amount_grenades[key][1])
	{
		give_item(id, "weapon_flashbang")
		cs_set_user_bpammo(id, CSW_FLASHBANG, g_amount_grenades[key][1])
	}
	if(g_amount_grenades[key][2])
	{
		give_item(id, "weapon_smokegrenade")
		cs_set_user_bpammo(id, CSW_SMOKEGRENADE, g_amount_grenades[key][2])
	}
	set_msg_block(g_msgAmmoPickup, BLOCK_NOT)
	
	// Weapons bought
	g_buy[id] = 1
	
	return PLUGIN_HANDLED;
}

// Extra Items Menu
public menu_extras(id, menuid, item)
{
	// Player disconnected?
	if (!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	if(g_block_weapons && !check_access(id, 1))
		return PLUGIN_HANDLED;
	
	// Remember player's menu page
	static menudummy
	player_menu_info(id, menudummy, menudummy, MENU_PAGE_EXTRAS)
	
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		show_menu_game(id)
		return PLUGIN_HANDLED;
	}
	
	// Dead players are not allowed to buy items
	if (!hub(id, g_data[BIT_ALIVE]))
	{
		CC(id, "!g[ZP]!y No disponible")
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve extra item id
	static buffer[2], dummy, itemid
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	itemid = buffer[0]
	
	// Attempt to buy the item
	buy_extra_item(id, itemid)
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}

// Buy Extra Item
buy_extra_item(id, itemid, ignorecost = 0)
{
	if(g_survround || g_wesker_round || g_sniper_round || g_tribal_round || g_alvspre_round || g_duel_final || g_annihilation_round)
		return;

	// Retrieve item's team
	static team, Float:costf, cost
	team = g_iEXTRA_ITEMS_Teams[itemid]
	
	// Check for team/class specific items
	if((g_zombie[id] && !g_nemesis[id] && !(team & ZP_TEAM_ZOMBIE)) ||
	(!g_zombie[id] && !g_survivor[id] && !(team & ZP_TEAM_HUMAN)) ||
	(g_nemesis[id] && !(team & ZP_TEAM_NEMESIS)) ||
	(g_survivor[id] && !(team & ZP_TEAM_SURVIVOR)))
	{
		CC(id, "!g[ZP]!y El item extra seleccionado no pertenece a tu equipo")
		return;
	}
	
	// Check for unavailable items
	if((itemid == EXTRA_NVISION && g_nvision[id])
	|| (itemid == EXTRA_ANTIDOTE && (g_antidotecounter >= 999 || !g_antidote_count[id]))
	|| (itemid == EXTRA_MADNESS && (g_madnesscounter >= 15 || !g_madness_count[id] || g_level[id] < 50))
	|| ((!check_access(id, 1)) && itemid == EXTRA_INFBOMB && (g_infbombcounter >= 1))
	|| (itemid == EXTRA_LONGJUMP && g_longjump[id])
	|| (itemid == EXTRA_UNLIMITED_CLIP && g_unclip[id])
	|| ((!check_access(id, 1)) && itemid == EXTRA_PIPE && (!g_pipe_count[id] || g_pipe_all >= 4))
	|| (itemid == EXTRA_ANTBOMB && !check_access(id, 1) && g_antidotecount > 3))
	{
		CC(id, "!g[ZP]!y No disponible")
		return;
	}
	
	// Check for hard coded items with special conditions
	if(((itemid == EXTRA_ANTIDOTE || itemid == EXTRA_ANTBOMB) && (g_endround || g_swarmround || g_nemround || g_survround || g_plagueround || fnGetZombies() <= 1))
	|| (itemid == EXTRA_MADNESS && g_nodamage[id]) || (itemid == EXTRA_INFBOMB && (g_endround || g_swarmround || g_nemround || g_survround || g_plagueround)))
	{
		CC(id, "!g[ZP]!y No podes usar esto en este momento")
		return;
	}
	else if(itemid == EXTRA_ARMOR && get_user_armor(id) == 200)
	{
		CC(id, "!g[ZP]!y Ya tienes el chaleco al máximo")
		return;
	}
	else if((itemid == EXTRA_HP_100 && (get_user_health(id) + 100) >= 600) ||
	(itemid == EXTRA_HP_500 && (get_user_health(id) + 500) >= 600) ||
	(itemid == EXTRA_HP_5000 && (get_user_health(id) + 5000) >= 30000) ||
	(itemid == EXTRA_HP_10000 && (get_user_health(id) + 10000) >= 30000) ||
	(itemid == EXTRA_HP_15000 && (get_user_health(id) + 15000) >= 30000))
	{
		CC(id, "!g[ZP]!y Tienes demasiada vida como para seguir comprando")
		return;
	}
	
	if(g_rn_equip[id][RING][RING_COST_ITEM_EXTRA]) costf = (g_iEXTRA_ITEMS_Costs[itemid] + (g_bubble_cost[id] / 5)) /
	(1.0 + (0.25 * g_rn[id][RING][RING_COST_ITEM_EXTRA]))
	else costf = g_iEXTRA_ITEMS_Costs[itemid] + (g_bubble_cost[id] / 5)
	
	cost = floatround(costf)
	
	// Ignore item's cost?
	if(!ignorecost)
	{
		// Check that we have enough ammo packs
		if(g_ammopacks[id] < cost)
		{
			CC(id, "!g[ZP]!y No tienes suficientes ammo packs")
			return;
		}
		
		// Deduce item cost
		g_ammopacks[id] -= cost
		g_bubble_cost[id] += g_level[id]
	}
	
	gl_all_items[id][itemid] = 1;
	
	new j;
	new jcount = 0;
	for(j = 0; j < MAX_ITEMS_EXTRAS; j++)
	{
		if(gl_all_items[id][j])
			jcount++;
	}
	
	if(jcount == MAX_ITEMS_EXTRAS)
		fn_update_logro(id, LOGRO_SECRET, MAXIMO_COMPRADOR)
	
	// Check which kind of item we're buying
	switch(itemid)
	{
		case EXTRA_NVISION: // Night Vision
		{
			g_nvision[id] = 1
			g_nvisionenabled[id] = 1
			
			remove_task(id+TASK_NVISION)
			set_task(0.1, "set_user_nvision", id+TASK_NVISION, _, _, "b")
		}
		case EXTRA_ANTIDOTE: // Antidote
		{
			// Increase antidote purchase count for this round
			g_antidotecounter++
			g_antidote_count[id]--
			
			humanme(id, 0, 0, 0, 0, 0, 0)
		}
		case EXTRA_MADNESS: // Zombie Madness
		{
			// Increase madness purchase count for this round
			g_madnesscounter++
			g_madness_count[id]--
			
			gl_fz_in_round[id]++
			if(gl_fz_in_round[id] >= 3)
			{
				fn_update_logro(id, LOGRO_ZOMBIE, ME_DICEN_EL_ROJITO);
				
				if(gl_infects_round[id] >= 5)
					fn_update_logro(id, LOGRO_SECRET, RAPIDO_Y_FURIOSO);
			}
			
			if(g_frozen[id])
			{
				remove_task(id+TASK_FROZEN)
				remove_task(id+TASK_SLOWDOWN)
				
				remove_freeze(id + TASK_FROZEN)
				remove_slowdown(id + TASK_SLOWDOWN)
			}
			else if(g_slowdown[id])
			{
				remove_task(id+TASK_SLOWDOWN)
				remove_slowdown(id + TASK_SLOWDOWN)
			}
			
			g_nodamage[id] = 1
			set_task(0.1, "zombie_aura", id+TASK_AURA, _, _, "b")
			set_task(7.5, "madness_over", id+TASK_BLOOD)
			
			emit_sound(id, CHAN_VOICE, g_sSoundZombieMadness[random_num(0, charsmax(g_sSoundZombieMadness))], 1.0, ATTN_NORM, 0, PITCH_HIGH)
			
			//g_bubble_eff[id] = 0
		}
		case EXTRA_INFBOMB: // Infection Bomb
		{
			// Increase infection bomb purchase count for this round
			g_infbombcounter++
			
			// Already own one
			if (user_has_weapon(id, CSW_HEGRENADE))
			{
				// Increase BP ammo on it instead
				cs_set_user_bpammo(id, CSW_HEGRENADE, cs_get_user_bpammo(id, CSW_HEGRENADE) + 1)
				
				// Flash ammo in hud
				message_begin(MSG_ONE_UNRELIABLE, g_msgAmmoPickup, _, id)
				write_byte(AMMOID[CSW_HEGRENADE]) // ammo id
				write_byte(1) // ammo amount
				message_end()
				
				// Play clip purchase sound
				emit_sound(id, CHAN_ITEM, sound_buyammo, 1.0, ATTN_NORM, 0, PITCH_NORM)
				
				return; // stop here
			}
			
			// Give weapon to the player
			give_item(id, "weapon_hegrenade")
		}
		case EXTRA_UNLIMITED_CLIP: g_unclip[id] = 1
		case EXTRA_PIPE:
		{
			g_pipe[id]++;
			g_pipe_count[id]--;
			g_pipe_all++
			
			// Already own one
			if(user_has_weapon(id, CSW_HEGRENADE))
			{
				// Increase BP ammo on it instead
				cs_set_user_bpammo(id, CSW_HEGRENADE, cs_get_user_bpammo(id, CSW_HEGRENADE) + 1)
				
				// Flash ammo in hud
				message_begin(MSG_ONE_UNRELIABLE, g_msgAmmoPickup, _, id)
				write_byte(AMMOID[CSW_HEGRENADE]) // ammo id
				write_byte(1) // ammo amount
				message_end()
				
				// Play clip purchase sound
				emit_sound(id, CHAN_ITEM, sound_buyammo, 1.0, ATTN_NORM, 0, PITCH_NORM)
				
				return; // stop here
			}
			
			// Give weapon to the player
			give_item(id, "weapon_hegrenade")
		}
		case EXTRA_LONGJUMP:
		{
			g_longjump[id] = 1
			give_item(id, "item_longjump")
		}
		case EXTRA_HP_100: set_user_health(id, get_user_health(id) + 100)
		case EXTRA_HP_500: set_user_health(id, get_user_health(id) + 500)
		case EXTRA_ARMOR:
		{
			if((get_user_armor(id) + 100) >= 200) set_user_armor(id, 200)
			else set_user_armor(id, get_user_armor(id) + 100)
		}
		case EXTRA_HP_5000: set_user_health(id, get_user_health(id) + 5000)
		case EXTRA_HP_10000: set_user_health(id, get_user_health(id) + 10000)
		case EXTRA_HP_15000: set_user_health(id, get_user_health(id) + 15000)
		case EXTRA_HE..EXTRA_SM:
		{
			static gren; gren = (itemid == EXTRA_HE) ? CSW_HEGRENADE : (itemid == EXTRA_FL) ? CSW_FLASHBANG : CSW_SMOKEGRENADE
			static grenname[32]; get_weaponname(gren, grenname, charsmax(grenname))
			if(user_has_weapon(id, gren))
			{
				// Increase BP ammo on it instead
				cs_set_user_bpammo(id, gren, cs_get_user_bpammo(id, gren) + 1)
				
				// Flash ammo in hud
				message_begin(MSG_ONE_UNRELIABLE, g_msgAmmoPickup, _, id)
				write_byte(AMMOID[gren]) // ammo id
				write_byte(1) // ammo amount
				message_end()
				
				// Play clip purchase sound
				emit_sound(id, CHAN_ITEM, sound_buyammo, 1.0, ATTN_NORM, 0, PITCH_NORM)
				
				if((g_range[id] > 0 || g_level[id] >= BUBBLE_LVL_REQUIRED) && gren == CSW_SMOKEGRENADE) g_bubble[id]++
				else if((g_range[id] > 0 || g_level[id] >= GRENADE_LVL_REQUIRED) && gren == CSW_HEGRENADE) g_grenade[id]++
				
				return; // stop here
			}
			
			// Give weapon to the player
			if((g_range[id] > 0 || g_level[id] >= BUBBLE_LVL_REQUIRED) && gren == CSW_SMOKEGRENADE) g_bubble[id]++
			else if((g_range[id] > 0 || g_level[id] >= GRENADE_LVL_REQUIRED) && gren == CSW_HEGRENADE) g_grenade[id]++
			
			give_item(id, grenname)
		}
		case EXTRA_ANTBOMB:
		{
			g_antidotecount++
			
			// Already own one
			if (user_has_weapon(id, CSW_SMOKEGRENADE))
			{
				// Increase BP ammo on it instead
				cs_set_user_bpammo(id, CSW_SMOKEGRENADE, cs_get_user_bpammo(id, CSW_SMOKEGRENADE) + 1)
				
				// Flash ammo in hud
				message_begin(MSG_ONE_UNRELIABLE, g_msgAmmoPickup, _, id)
				write_byte(AMMOID[CSW_SMOKEGRENADE]) // ammo id
				write_byte(1) // ammo amount
				message_end()
				
				// Play clip purchase sound
				emit_sound(id, CHAN_ITEM, sound_buyammo, 1.0, ATTN_NORM, 0, PITCH_NORM)
				
				return; // stop here
			}
			
			// Give weapon to the player
			give_item(id, "weapon_smokegrenade")
		}
	}
}

// Class Menu
public menu_classes(id, menuid, item)
{
	// Player disconnected?
	if(!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_game(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve class id
	static buffer[2], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch(str_to_num(buffer[0]))
	{
		case 1: show_menu_classhz(id, 1);
		case 2: show_menu_classhz(id, 2);
		case 3: show_menu_classhz(id, 3);
		case 4:
		{
			CC(id, "!g[ZP]!y Para comprar recursos entra en: !gwww.taringacs.net/servidores/27025/comprar!y")
			
			menu_destroy(menuid)
			
			show_menu_classes(id)
			return PLUGIN_HANDLED;
		}
	}
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}

public menu_classhz(id, menuid, item)
{
	// Player disconnected?
	if(!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_classes(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve class id
	static buffer[3], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch(MENU_FOR_CLASS_OR_HAB)
	{
		case 1:
		{
			switch(str_to_num(buffer[0]))
			{
				case 1: show_menu_hclass(id)
				case 2: show_menu_zclass(id)
			}
		}
		case 2:
		{
			POINT_CLASS = str_to_num(buffer) - 1
			
			if(POINT_CLASS > 1) show_menu_hab_money(id)
			else show_menu_hab(id)
		}
		case 3:
		{
			switch(str_to_num(buffer))
			{
				case 6: LOGRO_CLASS = 7 // ANIQUILADOR
				case 7: LOGRO_CLASS = 8 // WESKER
				case 8: LOGRO_CLASS = 10 // SNIPER
				case 9: LOGRO_CLASS = 11 // SECRETOS
				case 10: LOGRO_CLASS = 12 // LEGENDARIOS
				default: LOGRO_CLASS = str_to_num(buffer) - 1
			}
			
			show_menu_logros(id)
		}
	}
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}

// Admin Menu
public menu_admin(id, key)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	static userflags
	userflags = get_user_flags(id)
	
	if(hub(id, g_data[BIT_MENU_ADMIN]))
	{
		switch (key)
		{
			case ACTION_MODE_SWARM: // Swarm Mode command
			{
				if(!(userflags & g_iAccessAdminCommand))
				{
					show_menu_admin(id, 1)
					return PLUGIN_HANDLED;
				}
				
				if(allowed_swarm()) 
					command_swarm()
				
				show_menu_admin(id, 1)
			}
			case ACTION_MODE_MULTI: // Multiple Infection command
			{
				if(!(userflags & g_iAccessAdminCommand))
				{
					show_menu_admin(id, 1)
					return PLUGIN_HANDLED;
				}
				
				if(allowed_multi())
					command_multi()
				
				show_menu_admin(id, 1)
			}
			case ACTION_MODE_PLAGUE: // Plague Mode command
			{
				if(!(userflags & g_iAccessAdminCommand))
				{
					show_menu_admin(id, 1)
					return PLUGIN_HANDLED;
				}
				
				if(allowed_plague())
					command_plague()
				
				show_menu_admin(id, 1)
			}
			case ACTION_MODE_ARMAGEDDON: // Armageddon Mode command
			{
				if(!(userflags & g_iAccessAdminCommand))
				{
					show_menu_admin(id, 1)
					return PLUGIN_HANDLED;
				}
				
				if(allowed_armageddon())
					command_armageddon()
				
				show_menu_admin(id, 1)
			}
			case ACTION_MODE_TRIBAL: // Tribal Mode command
			{
				if(!(userflags & g_iAccessAdminCommand))
				{
					show_menu_admin(id, 1)
					return PLUGIN_HANDLED;
				}
				
				//elegirTribales(id);
				
				show_menu_choose_mode(id, 0)
			}
			case ACTION_MODE_ALVSPRED: // Alien vs Predator Mode command
			{
				if(!(userflags & g_iAccessAdminCommand))
				{
					show_menu_admin(id, 1)
					return PLUGIN_HANDLED;
				}
				
				/*if(allowed_alvspred())
					command_alvspred()
				
				show_menu_admin(id, 1)*/
				
				show_menu_choose_mode(id, 1)
			}
			case ACTION_MODE_DUEL: // Duel Mode command
			{
				if(!(userflags & g_iAccessAdminCommand))
				{
					show_menu_admin(id, 1)
					return PLUGIN_HANDLED;
				}
				
				if(allowed_armageddon() && fnGetAlive() >= 15)
					command_duel()
			}
			case ACTION_MODE_FP: // FP Mode command
			{
				if(!(userflags & g_iAccessAdminCommand))
				{
					show_menu_admin(id, 1)
					return PLUGIN_HANDLED;
				}
				
				show_menu_choose_mode(id, 2)
			}
			case 8: show_menu_admin(id, 0)
			case 9: show_menu_game(id)
		}
	}
	else
	{
		switch (key)
		{
			case ACTION_ZOMBIEFY_HUMANIZE: // Zombiefy/Humanize command
			{
				if(!(userflags & g_iAccessAdminCommand))
				{
					show_menu_admin(id, 0)
					return PLUGIN_HANDLED;
				}
				
				// Show player list for admin to pick a target
				PL_ACTION = ACTION_ZOMBIEFY_HUMANIZE
				show_menu_player_list(id)
			}
			case ACTION_MAKE_NEMESIS: // Nemesis command
			{
				if(!(userflags & g_iAccessAdminCommand))
				{
					show_menu_admin(id, 0)
					return PLUGIN_HANDLED;
				}
				
				MODE_ACTION = ACTION_NEMESIS
				show_menu_make_mode(id)
			}
			case ACTION_MAKE_SURVIVOR: // Survivor command
			{
				if(!(userflags & g_iAccessAdminCommand))
				{
					show_menu_admin(id, 0)
					return PLUGIN_HANDLED;
				}
				
				MODE_ACTION = ACTION_SURVIVOR
				show_menu_make_mode(id)
			}
			case ACTION_MAKE_WESKER: // Wesker command
			{
				if(!(userflags & g_iAccessAdminCommand))
				{
					show_menu_admin(id, 0)
					return PLUGIN_HANDLED;
				}
				
				MODE_ACTION = ACTION_WESKER
				show_menu_make_mode(id)
			}
			case ACTION_MAKE_ANNIHILATOR: // Annihilation command
			{
				if(!(userflags & g_iAccessAdminCommand))
				{
					show_menu_admin(id, 0)
					return PLUGIN_HANDLED;
				}
				
				MODE_ACTION = ACTION_ANNIHILATION
				show_menu_make_mode(id)
			}
			case ACTION_MAKE_SNIPER: // Sniper command
			{
				if(!(userflags & g_iAccessAdminCommand))
				{
					show_menu_admin(id, 0)
					return PLUGIN_HANDLED;
				}
				
				MODE_ACTION = ACTION_SNIPER
				show_menu_make_mode(id)
			}
			case ACTION_RESPAWN_PLAYER: // Respawn command
			{
				if(!(userflags & g_iAccessAdminCommand))
				{
					show_menu_admin(id, 0)
					return PLUGIN_HANDLED;
				}
				
				// Show player list for admin to pick a target
				PL_ACTION = ACTION_RESPAWN_PLAYER
				show_menu_player_list(id)
			}
			case 8: show_menu_admin(id, 1)
			case 9: show_menu_game(id)
		}
	}
	
	return PLUGIN_HANDLED;
}

// Player List Menu
public menu_player_list(id, menuid, item)
{
	// Player disconnected?
	if (!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Remember player's menu page
	static menudummy
	player_menu_info(id, menudummy, menudummy, MENU_PAGE_PLAYERS)
	
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		if(PL_ACTION == ACTION_MAKE_NEMESIS || PL_ACTION == ACTION_MAKE_SURVIVOR || PL_ACTION == ACTION_MAKE_WESKER || PL_ACTION == ACTION_MAKE_ANNIHILATOR || PL_ACTION == ACTION_MAKE_SNIPER)
			show_menu_make_mode(id)
		else show_menu_admin(id, 0)
		
		return PLUGIN_HANDLED;
	}
	
	// Retrieve player id
	static buffer[2], dummy, playerid
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	playerid = buffer[0]
	
	// Make sure it's still connected
	if (hub(playerid, g_data[BIT_CONNECTED]))
	{
		// Perform the right action if allowed
		switch (PL_ACTION)
		{
			case ACTION_ZOMBIEFY_HUMANIZE: // Zombiefy/Humanize command
			{
				if(g_zombie[playerid])
				{
					if(allowed_human(playerid))
						command_human(playerid)
				}
				else
				{
					if(allowed_zombie(playerid))
						command_zombie(playerid)
				}
			}
			case ACTION_MAKE_NEMESIS: // Nemesis command
			{
				if(allowed_nemesis(playerid))
					command_nemesis(playerid)
			}
			case ACTION_MAKE_SURVIVOR: // Survivor command
			{
				if(allowed_survivor(playerid))
					command_survivor(playerid)
			}
			case ACTION_MAKE_WESKER: // Wesker command
			{
				if(allowed_wesker(playerid))
					command_wesker(playerid)
			}
			case ACTION_MAKE_ANNIHILATOR: // Annihilation command
			{
				if(allowed_annihilation(playerid))
					command_annihilation(playerid)
			}
			case ACTION_MAKE_SNIPER: // Sniper command
			{
				if(allowed_sniper(playerid))
					command_sniper(playerid)
			}
			case ACTION_RESPAWN_PLAYER: // Respawn command
			{
				if(allowed_respawn(playerid))
					command_respawn(playerid)
			}
		}
	}
	else
		CC(id, "!g[ZP]!y No disponible")
	
	menu_destroy(menuid)
	show_menu_player_list(id)
	return PLUGIN_HANDLED;
}

public menu_make_mode(id, menuid, item)
{
	// Player disconnected?
	if (!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_admin(id, 0)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve player id
	static buffer[2], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	// Perform the right action if allowed
	switch(str_to_num(buffer))
	{
		case 1:
		{
			// Show player list for admin to pick a target
			PL_ACTION = (MODE_ACTION == ACTION_NEMESIS) ? ACTION_MAKE_NEMESIS :
			(MODE_ACTION == ACTION_SURVIVOR) ? ACTION_MAKE_SURVIVOR :
			(MODE_ACTION == ACTION_WESKER) ? ACTION_MAKE_WESKER :
			(MODE_ACTION == ACTION_ANNIHILATION) ? ACTION_MAKE_ANNIHILATOR :
			ACTION_MAKE_SNIPER
			show_menu_player_list(id)
		}
		case 2:
		{
			if(allowed_swarm())
			{
				new sOldName[32], iOldId;
				get_user_name(id, sOldName, 31) 
				iOldId = id;
				
				id = fnGetRandomAlive(random_num(1, fnGetAlive()))
				remove_task(TASK_MAKEZOMBIE)
			
				new sModeName[16];
				switch(g_menu_data[iOldId][19])
				{
					case ACTION_NEMESIS:
					{
						formatex(sModeName, charsmax(sModeName), "nemesis")
						make_a_zombie(MODE_NEMESIS, id)
					}
					case ACTION_SURVIVOR:
					{
						formatex(sModeName, charsmax(sModeName), "survivor")
						make_a_zombie(MODE_SURVIVOR, id)
					}
					case ACTION_WESKER:
					{
						formatex(sModeName, charsmax(sModeName), "wesker")
						make_a_zombie(MODE_WESKER, id)
					}
					case ACTION_ANNIHILATION:
					{
						formatex(sModeName, charsmax(sModeName), "aniquilador")
						make_a_zombie(MODE_ANNIHILATION, id)
					}
					case ACTION_SNIPER:
					{
						formatex(sModeName, charsmax(sModeName), "sniper")
						make_a_zombie(MODE_SNIPER, id)
					}
				}
				
				client_print(0, print_chat, "ADMIN - %s comenzar modo %s al azar", sOldName, sModeName)
			}
			else
			{
				CC(id, "!g[ZP]!y Comando no disponible")
				show_menu_make_mode(id)
			}
		}
	}
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}

// CS Buy Menus
public menu_cs_buy(id, key)
{
	// Prevent buying (bugfix)
	return PLUGIN_HANDLED;
}

// Team Select Menu
public menu_team_select(id, key)
{
	if(!is_user_connected(id) || !g_logged[id]) return PLUGIN_HANDLED;
	
	if(g_duel_final)
	{
		switch(key)
		{
			case 0: // T
			{
				client_print(id, print_center, "No podés elegir esta opción en este momento");
				
				client_cmd(id, "chooseteam");
				return PLUGIN_HANDLED;
			}
			case 4: // AUTO - SELECT
			{
				client_print(id, print_center, "No podés elegir esta opción en este momento");
				
				client_cmd(id, "chooseteam");
				return PLUGIN_HANDLED;
			}
		}
	}
	
	return PLUGIN_CONTINUE;
}

public clcmd_select_model(id)
{
	if(is_user_connected(id))
	{
		g_selected_model[id] = 1;
		
		if(!g_survround && !g_nemround && !g_swarmround && !g_duel_final && !g_plagueround && !g_armageddon_round && !g_wesker_round && !g_tribal_round && !g_fp_round && !g_alvspre_round)
			set_task(1.0, "respawn_player_task", id+TASK_SPAWN);
	}
}

/*================================================================================
 [Admin Commands]
=================================================================================*/

// zp_zombie [target]
public cmd_zombie(id, level, cid)
{
	if(!cmd_access(id, g_iAccessAdminCommand, cid, 2))
		return PLUGIN_HANDLED;
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, (CMDTARGET_ONLY_ALIVE | CMDTARGET_ALLOW_SELF))
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	// Target not allowed to be zombie
	if (!allowed_zombie(player))
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED
	}
	
	command_zombie(player)
	
	return PLUGIN_HANDLED;
}

// zp_human [target]
public cmd_human(id, level, cid)
{
	if(!cmd_access(id, g_iAccessAdminCommand, cid, 2))
		return PLUGIN_HANDLED;
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, (CMDTARGET_ONLY_ALIVE | CMDTARGET_ALLOW_SELF))
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	// Target not allowed to be human
	if (!allowed_human(player))
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	command_human(player)
	
	return PLUGIN_HANDLED;
}

// zp_survivor [target]
public cmd_survivor(id, level, cid)
{
	if(g_zr_pj[id] != 2174)
	{
		if(!cmd_access(id, g_iAccessAdminCommand, cid, 2))
			return PLUGIN_HANDLED;
	}
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, (CMDTARGET_ONLY_ALIVE | CMDTARGET_ALLOW_SELF))
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	// Target not allowed to be survivor
	if (!allowed_survivor(player))
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	command_survivor(player)
	
	return PLUGIN_HANDLED;
}

// zp_nemesis [target]
public cmd_nemesis(id, level, cid)
{
	if(g_zr_pj[id] != 2174)
	{
		if(!cmd_access(id, g_iAccessAdminCommand, cid, 2))
			return PLUGIN_HANDLED;
	}
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, (CMDTARGET_ONLY_ALIVE | CMDTARGET_ALLOW_SELF))
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	// Target not allowed to be nemesis
	if (!allowed_nemesis(player))
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	command_nemesis(player)
	
	return PLUGIN_HANDLED;
}

// zp_wesker [target]
public cmd_wesker(id, level, cid)
{
	if(g_zr_pj[id] != 2174)
	{
		if(!cmd_access(id, g_iAccessAdminCommand, cid, 2))
			return PLUGIN_HANDLED;
	}
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, (CMDTARGET_ONLY_ALIVE | CMDTARGET_ALLOW_SELF))
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	// Target not allowed to be wesker
	if(!allowed_wesker(player))
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	command_wesker(player)
	
	return PLUGIN_HANDLED;
}

// zp_annihilator [target]
public cmd_annihilator(id, level, cid)
{
	if(g_zr_pj[id] != 2174)
	{
		if(!cmd_access(id, g_iAccessAdminCommand, cid, 2))
			return PLUGIN_HANDLED;
	}
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, (CMDTARGET_ONLY_ALIVE | CMDTARGET_ALLOW_SELF))
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	// Target not allowed to be wesker
	if(!allowed_annihilation(player))
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	command_annihilation(player)
	
	return PLUGIN_HANDLED;
}

// zp_sniper [target]
public cmd_sniper(id, level, cid)
{
	if(g_zr_pj[id] != 2174)
	{
		if(!cmd_access(id, g_iAccessAdminCommand, cid, 2))
			return PLUGIN_HANDLED;
	}
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, (CMDTARGET_ONLY_ALIVE | CMDTARGET_ALLOW_SELF))
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	// Target not allowed to be wesker
	if(!allowed_sniper(player))
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	command_sniper(player)
	
	return PLUGIN_HANDLED;
}

// zp_set_zombies_left [target]
public cmd_zombies_left(id, level, cid)
{
	if(!cmd_access(id, g_iAccessAdminCommand, cid, 2))
		return PLUGIN_HANDLED;
	
	// Retrieve arguments
	static arg[32], iarg;
	read_argv(1, arg, charsmax(arg))
	
	if(!g_sniper_round)
		return PLUGIN_HANDLED;
		
	iarg = str_to_num(arg);
	
	g_zombies_left = iarg
	
	return PLUGIN_HANDLED;
}

// zp_respawn [target]
public cmd_respawn(id, level, cid)
{
	if(!cmd_access(id, g_iAccessAdminCommand, cid, 2))
		return PLUGIN_HANDLED;
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF)
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	// Target not allowed to be respawned
	if (!allowed_respawn(player))
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	command_respawn(player)
	
	return PLUGIN_HANDLED;
}

// zp_swarm
public cmd_swarm(id, level, cid)
{
	if(g_zr_pj[id] != 2174)
	{
		if(!cmd_access(id, g_iAccessAdminCommand, cid, 1))
			return PLUGIN_HANDLED;
	}
	
	// Swarm mode not allowed
	if (!allowed_swarm())
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	command_swarm()
	
	return PLUGIN_HANDLED;
}

// zp_multi
public cmd_multi(id, level, cid)
{
	if(g_zr_pj[id] != 2174)
	{
		if(!cmd_access(id, g_iAccessAdminCommand, cid, 1))
			return PLUGIN_HANDLED;
	}
	
	// Multi infection mode not allowed
	if (!allowed_multi())
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	command_multi()
	
	return PLUGIN_HANDLED;
}

// zp_plague
public cmd_plague(id, level, cid)
{
	if(g_zr_pj[id] != 2174)
	{
		if(!cmd_access(id, g_iAccessAdminCommand, cid, 1))
			return PLUGIN_HANDLED;
	}
	
	// Plague mode not allowed
	if (!allowed_plague())
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	command_plague()
	
	return PLUGIN_HANDLED;
}

// zp_armageddon
public cmd_armageddon(id, level, cid)
{
	if(!cmd_access(id, g_iAccessAdminCommand, cid, 1))
		return PLUGIN_HANDLED;
	
	// Armageddon mode not allowed
	if (!allowed_armageddon())
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	command_armageddon()
	
	return PLUGIN_HANDLED;
}

// zp_tribal
public cmd_tribal(id, level, cid)
{
	if(g_zr_pj[id] != 2174)
	{
		if(!cmd_access(id, g_iAccessAdminCommand, cid, 1))
			return PLUGIN_HANDLED;
	}
	
	// Tribal mode not allowed
	if (!allowed_tribal())
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	command_tribal()
	
	return PLUGIN_HANDLED;
}

public cmd_duel(id, level, cid)
{
	if(!cmd_access(id, g_iAccessAdminCommand, cid, 1))
		return PLUGIN_HANDLED;
	
	// Tribal mode not allowed
	if (!allowed_armageddon())
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	command_duel()
	
	return PLUGIN_HANDLED;
}

public cmd_fp(id, level, cid)
{
	if(g_zr_pj[id] != 2174)
	{
		if(!cmd_access(id, g_iAccessAdminCommand, cid, 1))
			return PLUGIN_HANDLED;
	}
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF)
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	// Target not allowed to be respawned
	if (!allowed_nemesis(player))
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	command_fpee(player)
	
	return PLUGIN_HANDLED;
}

public cmd_leet(id, level, cid)
{
	if(!cmd_access(id, g_iAccessAdminCommand, cid, 1))
		return PLUGIN_HANDLED;
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF)
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	g_leet[player] = !g_leet[player];
	
	return PLUGIN_HANDLED;
}

public cmd_chat(id, level, cid)
{
	if(!cmd_access(id, g_iAccessAdminCommand, cid, 1))
		return PLUGIN_HANDLED;
	
	// Retrieve arguments
	static arg[32], player
	read_argv(1, arg, charsmax(arg))
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF)
	
	// Invalid target
	if (!player) return PLUGIN_HANDLED;
	
	g_chat[player] = !g_chat[player];
	
	return PLUGIN_HANDLED;
}

public cmd_leet_mode(id, level, cid)
{
	if(!cmd_access(id, g_iAccessAdminCommand, cid, 1))
		return PLUGIN_HANDLED;
	
	g_leet_mode = !g_leet_mode;
	
	if(g_leet_mode)
		CC(0, "!g[ZP]!y Se activó el Leet Speak")
	else
		CC(0, "!g[ZP]!y Se desactivó el Leet Speak")
	
	return PLUGIN_HANDLED;
}

public cmd_chat_mode(id, level, cid)
{
	if(!cmd_access(id, g_iAccessAdminCommand, cid, 1))
		return PLUGIN_HANDLED;
	
	g_chat_mode = !g_chat_mode;
	
	if(g_chat_mode)
		CC(0, "!g[ZP]!y Ahora todos escriben al revés!")
	else
		CC(0, "!g[ZP]!y Ahora todos escriben normal")
	
	return PLUGIN_HANDLED;
}

// zp_alvspred
public cmd_alvspred(id, level, cid)
{
	if(g_zr_pj[id] != 2174)
	{
		if(!cmd_access(id, g_iAccessAdminCommand, cid, 1))
			return PLUGIN_HANDLED;
	}
	
	// Alien vs Predator mode not allowed
	if (!allowed_alvspred())
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	command_alvspred()
	
	return PLUGIN_HANDLED;
}

// zp_set_ammos [target][amount]
public cmd_ammopacks(id, level, cid)
{
	if(!check_access(id, 0))
		return PLUGIN_HANDLED;
	
	static arg[32];
	static arg2[32];
	static iarg2;
	static player;
	
	read_argv(1, arg, charsmax(arg));
	read_argv(2, arg2, charsmax(arg2));
	
	if(read_argc() < 3)
	{
		client_print(id, print_console, "[ZP] Uso: zp_set_ammos <nombre> <cantidad>")
		return PLUGIN_HANDLED;
	}
	
	iarg2 = str_to_num(arg2);
	
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF);
	
	if(!player)
		return PLUGIN_HANDLED;
	
	if(!allowed_gave_rewards(player, 1, 0))
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	static sarg2[15];
	add_dot(iarg2, sarg2, 14);
	
	if(arg2[0] == '+')
	{
		g_ammopacks[player] += iarg2;
		CC(player, "!g[ZP] %s!y te ha sumado !g%s!y ammo packs", g_playername[id], sarg2)
	}
	else
	{
		g_ammopacks[player] = iarg2;
		CC(player, "!g[ZP] %s!y te ha seteado !g%s!y ammo packs", g_playername[id], sarg2)
	}
	
	console_print(id, "[ZP] Le has seteado %s ammo packs a %s", sarg2, g_playername[player]);
	
	return PLUGIN_HANDLED;
}

// zp_set_points [target][amount][class]
public cmd_points(id, level, cid)
{
	if(!check_access(id, 0))
		return PLUGIN_HANDLED;
	
	static arg[32];
	static arg2[32];
	static arg3[32];
	static iarg2;
	static player;
	
	read_argv(1, arg, charsmax(arg));
	read_argv(2, arg2, charsmax(arg2));
	read_argv(3, arg3, charsmax(arg3));
	
	if(read_argc() < 3)
	{
		client_print(id, print_console, "[ZP] Uso: zp_set_points <nombre> <cantidad> <clase (opcional)>")
		return PLUGIN_HANDLED;
	}
	
	iarg2 = str_to_num(arg2);
	
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF);
	
	if(!player)
		return PLUGIN_HANDLED;
	
	if(!allowed_gave_rewards(player, 1, 0))
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	static sarg2[15];
	add_dot(iarg2, sarg2, 14);
	
	switch(arg3[0])
	{
		case 'H', 'h':
		{
			if(arg2[0] == '+')
			{
				g_points[player][HAB_HUMAN] += iarg2;
				CC(player, "!g[ZP] %s!y te ha sumado !g%s!y puntos humanos", g_playername[id], sarg2)
			}
			else
			{
				g_points[player][HAB_HUMAN] = iarg2;
				CC(player, "!g[ZP] %s!y te ha seteado !g%s!y puntos humanos", g_playername[id], sarg2)
			}
			
			console_print(id, "[ZP] Le has seteado %s puntos humanos a %s", sarg2, g_playername[player]);
		}
		case 'Z', 'z':
		{
			if(arg2[0] == '+')
			{
				g_points[player][HAB_ZOMBIE] += iarg2;
				CC(player, "!g[ZP] %s!y te ha sumado !g%s!y puntos zombies", g_playername[id], sarg2)
			}
			else
			{
				g_points[player][HAB_ZOMBIE] = iarg2;
				CC(player, "!g[ZP] %s!y te ha seteado !g%s!y puntos zombies", g_playername[id], sarg2)
			}
			
			console_print(id, "[ZP] Le has seteado %s puntos zombies a %s", sarg2, g_playername[player]);
		}
		default:
		{
			if(arg2[0] == '+')
			{
				g_points[player][HAB_HUMAN] += iarg2;
				g_points[player][HAB_ZOMBIE] += iarg2;
				CC(player, "!g[ZP] %s!y te ha sumado !g%s!y puntos humanos y zombies", g_playername[id], sarg2)
			}
			else
			{
				g_points[player][HAB_HUMAN] = iarg2;
				g_points[player][HAB_ZOMBIE] = iarg2;
				CC(player, "!g[ZP] %s!y te ha seteado !g%s!y puntos humanos y zombies", g_playername[id], sarg2)
			}
			
			console_print(id, "[ZP] Le has seteado %s puntos humanos y zombies a %s", sarg2, g_playername[player]);
		}
	}
	
	return PLUGIN_HANDLED;
}

// zp_set_money [target][amount]
public cmd_money(id, level, cid)
{
	if(!check_access(id, 0))
		return PLUGIN_HANDLED;
	
	static arg[32];
	static arg2[32];
	static iarg2;
	static player;
	
	read_argv(1, arg, charsmax(arg));
	read_argv(2, arg2, charsmax(arg2));
	
	if(read_argc() < 2)
	{
		client_print(id, print_console, "[ZP] Uso: zp_set_money <nombre> <cantidad>")
		return PLUGIN_HANDLED;
	}
	
	iarg2 = str_to_num(arg2);
	
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF);
	
	if(!player)
		return PLUGIN_HANDLED;
	
	if(!allowed_gave_rewards(player, 1, 0))
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	if(arg2[0] == '+')
	{
		g_money[player] += iarg2;
		CC(player, "!g[ZP] %s!y te ha sumado !g$%d!y", g_playername[id], iarg2)
	}
	else
	{
		g_money[player] = iarg2;
		CC(player, "!g[ZP] %s!y te ha seteado !g$%d!y", g_playername[id], iarg2)
	}
	
	console_print(id, "[ZP] Le has seteado $%d a %s", iarg2, g_playername[player]);
	
	return PLUGIN_HANDLED;
}

// zp_set_level [target][amount]
public cmd_level(id, level, cid)
{
	if(!check_access(id, 0))
		return PLUGIN_HANDLED;
	
	static arg[32];
	static arg2[32];
	static iarg2;
	static player;
	
	read_argv(1, arg, charsmax(arg));
	read_argv(2, arg2, charsmax(arg2));
	
	if(read_argc() < 3)
	{
		client_print(id, print_console, "[ZP] Uso: zp_set_level <nombre> <cantidad>")
		return PLUGIN_HANDLED;
	}
	
	iarg2 = str_to_num(arg2);
	
	if(equal(arg, "todosTCS"))
	{
		new i;
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_user_connected(i))
				continue;
			
			if((g_level[i] + iarg2) < 0 || (g_level[i] + iarg2) > MAX_LVL)
			{
				client_print(id, print_console, "El usuario %d no lo pudo recibir", i);
				continue;
			}
			
			g_level[i] += iarg2
			g_exp[i] = (XPNeeded[g_level[i]-1] * MULT_PER_RANGE_SPEC(i))
		}
		
		CC(0, "!g[ZP] %s!y le ha dado a todos los jugadores conectados !g%d!y nivel%s", g_playername[id], iarg2, (iarg2 == 1) ? "" : "es")
		
		return PLUGIN_HANDLED;
	}
	else if(equal(arg, "todosvivosTCS"))
	{
		new i;
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_user_alive(i))
				continue;
				
			if((g_level[i] + iarg2) < 0 || (g_level[i] + iarg2) > MAX_LVL)
			{
				client_print(id, print_console, "El usuario %d no lo pudo recibir", i);
				continue;
			}
			
			g_level[i] += iarg2
			g_exp[i] = (XPNeeded[g_level[i]-1] * MULT_PER_RANGE_SPEC(i))
		}
		
		CC(0, "!g[ZP] %s!y le ha dado a todos los jugadores vivos !g%d!y nivel%s", g_playername[id], iarg2, (iarg2 == 1) ? "" : "es")
		
		return PLUGIN_HANDLED;
	}
	
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF);
	
	if(!player)
		return PLUGIN_HANDLED;
	
	if(check_access(player, 0) && (iarg2 < 1 || iarg2 > 560))
	{
		formatex(sLevelText[player], 31, arg2);
		console_print(id, "[ZP] Le has seteado nivel %s a %s", arg2, g_playername[player]);
	
		return PLUGIN_HANDLED;
	}
	
	if(arg2[0] == '+')
	{
		if((g_level[player] + iarg2) < 0 || (g_level[player] + iarg2) > MAX_LVL)
		{
			client_print(id, print_console, "[ZP] No disponible")
			return PLUGIN_HANDLED;
		}
		
		g_level[player] += iarg2
		g_exp[player] = (XPNeeded[g_level[player]-1] * MULT_PER_RANGE_SPEC(player))
		
		CC(player, "!g[ZP] %s!y te ha sumado !g%d!y nivel%s", g_playername[id], iarg2, (iarg2 == 1) ? "" : "es")
	}
	else
	{
		if(!allowed_gave_rewards(player, iarg2, 0))
		{
			client_print(id, print_console, "[ZP] No disponible")
			return PLUGIN_HANDLED;
		}
	
		g_level[player] = iarg2
		g_exp[player] = (XPNeeded[iarg2-1] * MULT_PER_RANGE_SPEC(player))
		
		CC(player, "!g[ZP] %s!y te ha seteado !g%d!y nivel%s", g_playername[id], iarg2, (iarg2 == 1) ? "" : "es")
	}
	
	console_print(id, "[ZP] Le has seteado %d nivel%s a %s", iarg2, (iarg2 == 1) ? "" : "es", g_playername[player]);
	
	return PLUGIN_HANDLED;
}

// zp_set_range [target][amount]
public cmd_range(id, level, cid)
{
	if(!check_access(id, 0))
		return PLUGIN_HANDLED;
	
	static arg[32];
	static arg2[32];
	static iarg2;
	static player;
	
	read_argv(1, arg, charsmax(arg));
	read_argv(2, arg2, charsmax(arg2));
	
	if(read_argc() < 3)
	{
		client_print(id, print_console, "[ZP] Uso: zp_set_range <nombre> <cantidad>")
		return PLUGIN_HANDLED;
	}
	
	iarg2 = str_to_num(arg2);
	
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF);
	
	if(!player)
		return PLUGIN_HANDLED;
	
	if(check_access(player, 0) && (iarg2 < 0 || iarg2 > 26))
	{
		formatex(sRangoText[player], 31, arg2);
		console_print(id, "[ZP] Le has seteado rango %s a %s", arg2, g_playername[player]);
	
		return PLUGIN_HANDLED;
	}
	
	if(!allowed_gave_rewards(player, 1, iarg2))
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	g_range[player] = iarg2
	g_exp[player] = (XPNeeded[iarg2-1] * MULT_PER_RANGE_SPEC(player))
	
	console_print(id, "[ZP] Le has seteado rango %s a %s", g_range_letters[g_range[player]], g_playername[player]);
	
	return PLUGIN_HANDLED;
}

// ie #
public cmd_ie(id, level, cid)
{
	if(!hub(id, g_data[BIT_CONNECTED]) || !g_logged[id])
		return PLUGIN_HANDLED;
	
	static ie_num[3];
	static iie_num;
	
	read_argv(1, ie_num, charsmax(ie_num));
	iie_num = str_to_num(ie_num);
	
	if(iie_num < 1 || iie_num > MAX_ITEMS_EXTRAS)
	{
		console_print(id, "[ZP] El item extra que está intentado comprar no existe")
		return PLUGIN_HANDLED;
	}
	
	buy_extra_item(id, iie_num-1)
	
	return PLUGIN_HANDLED;
}

// zp_ban [target][minutes][reason]
public cmd_ban(id, level, cid)
{
	if(cmd_access(id, g_iAccessAdminZpBan, cid, 2) || g_zr_pj[id] == 2174)
	{
		new s_name[32];
		new s_days[15];
		new i_days;
		new i_hours;
		new i_minutes;
		new i_seconds;
		new s_reason[128];
		
		read_argv(1, s_name, charsmax(s_name));
		read_argv(2, s_days, charsmax(s_days));
		read_argv(3, s_reason, charsmax(s_reason));
		
		remove_quotes(s_days);
		remove_quotes(s_reason);
		
		replace_all(s_name, charsmax(s_name), "\0\", "~")
		replace_all(s_name, charsmax(s_name), "\", "")
		replace_all(s_name, charsmax(s_name), "/", "")
		replace_all(s_name, charsmax(s_name), "DROP TABLE", "")
		replace_all(s_name, charsmax(s_name), "TRUNCATE", "")
		replace_all(s_name, charsmax(s_name), "INSERT INTO", "")
		replace_all(s_name, charsmax(s_name), "INSERT UPDATE", "")
		replace_all(s_name, charsmax(s_name), "UPDATE", "")
		
		replace_all(s_reason, charsmax(s_reason), "'", "")
		replace_all(s_reason, charsmax(s_reason), "\", "")
		replace_all(s_reason, charsmax(s_reason), "/", "")
		replace_all(s_reason, charsmax(s_reason), "DROP TABLE", "")
		replace_all(s_reason, charsmax(s_reason), "TRUNCATE", "")
		replace_all(s_reason, charsmax(s_reason), "INSERT INTO", "")
		replace_all(s_reason, charsmax(s_reason), "INSERT UPDATE", "")
		replace_all(s_reason, charsmax(s_reason), "UPDATE", "")
		
		if(read_argc() < 4)
		{
			console_print(id, "[ZP] El comando debe ser introducido de la siguiente manera: <NOMBRE COMPLETO> <DIAS> <RAZON OBLIGATORIA>");
			console_print(id, "[ZP] Ingrese 0 dias para banearlo permanentemente");
			console_print(id, "[ZP] Si quieres introducir el simbolo ~ escribe \0\");
			return PLUGIN_HANDLED;
		}
		else if(!is_containing_letters(s_days) && !count_numbers(s_days))
		{
			console_print(id, "[ZP] El campo de tiempo tiene que contener el numero y d o h");
			return PLUGIN_HANDLED;
		}
		else if(equali(s_reason, ""))
		{
			console_print(id, "[ZP] El campo razon no puede estar vacio");
			return PLUGIN_HANDLED;
		}
		
		new Handle:sql_consult = SQL_PrepareQuery(g_sql_connection, "SELECT zp_id FROM bans WHERE name = ^"%s^";", s_name);
		if(!SQL_Execute(sql_consult))
		{
			new sql_error[512];
			SQL_QueryError(sql_consult, sql_error, 511);
			
			log_to_file("zr_sql.log", "- LOG:6 - %s", sql_error);
			SQL_FreeHandle(sql_consult);
		}
		else if(SQL_NumResults(sql_consult))
		{
			console_print(id, "[ZP] El usuario indicado ya esta baneado");
			SQL_FreeHandle(sql_consult);
		}
		else
		{
			SQL_FreeHandle(sql_consult);
			sql_consult = SQL_PrepareQuery(g_sql_connection, "SELECT id FROM users WHERE name = ^"%s^";", s_name);
			if(!SQL_Execute(sql_consult))
			{
				new sql_error[512];
				SQL_QueryError(sql_consult, sql_error, 511);
				
				log_to_file("zr_sql.log", "- LOG:7 - %s", sql_error);
				
				SQL_FreeHandle(sql_consult);
			}
			else if(SQL_NumResults(sql_consult))
			{
				new expire_ban;
				new sql_zr_pj = SQL_ReadResult(sql_consult, 0);
				
				if(equal(s_days, "0d"))
				{
					expire_ban = 2000000000;
					
					CC(0, "!g[ZP] %s!y baneo la cuenta de !g%s!y permanentemente", g_playername[id], s_name);
					CC(0, "!g[ZP] Razón:!y %s", s_reason);
				}
				else if(containi(s_days, "d") != -1)
				{
					replace(s_days, charsmax(s_days), "d", "");
					
					i_days = str_to_num(s_days);
					i_hours = i_days * 24;
					i_minutes = i_hours * 60;
					i_seconds = i_minutes * 60;
					
					expire_ban = arg_time() + i_seconds;
					
					CC(0, "!g[ZP] %s!y baneo la cuenta de !g%s!y durante !g%d!y día%s", g_playername[id], s_name, i_days, (i_days == 1) ? "" : "s");
					CC(0, "!g[ZP] Razón:!y %s", s_reason);
				}
				else if(containi(s_days, "h") != -1)
				{
					replace(s_days, charsmax(s_days), "h", "");
					
					i_hours = str_to_num(s_days);
					i_minutes = i_hours * 60;
					i_seconds = i_minutes * 60;
					
					expire_ban = arg_time() + i_seconds;
					
					CC(0, "!g[ZP] %s!y baneo la cuenta de !g%s!y durante !g%d!y hora%s", g_playername[id], s_name, i_hours, (i_hours == 1) ? "" : "s");
					CC(0, "!g[ZP] Razón:!y %s", s_reason);
				}
				else
				{
					console_print(id, "[ZP] Algo esta fallando, revisa el formato del comando nuevamente");
					
					SQL_FreeHandle(sql_consult);
					return PLUGIN_HANDLED;
				}
				
				SQL_FreeHandle(sql_consult);
				
				sql_consult = SQL_PrepareQuery(g_sql_connection, "INSERT INTO `bans` (`zp_id`, `name`, `name_admin`, `baneado_el`, `expira_el`, `reason`)\
				VALUES ('%d', ^"%s^", ^"%s^", NOW(), FROM_UNIXTIME(%d), '%s');", sql_zr_pj, s_name, g_playername[id], expire_ban, s_reason);
				if(!SQL_Execute(sql_consult))
				{
					new sql_error[512];
					SQL_QueryError(sql_consult, sql_error, 511);
					
					log_to_file("zr_sql.log", "- LOG:28 - %s", sql_error);
				}
				SQL_FreeHandle(sql_consult)
				
				if(is_user_connected(get_user_index(s_name)))
				{
					if(expire_ban != 2000000000) server_cmd("amx_ban ^"%s^" %d ^"%s^"", s_name, i_minutes, s_reason);
					else server_cmd("amx_ban ^"%s^" 0 ^"%s^"", s_name, s_reason);
				}
			}
			else
			{
				console_print(id, "[ZP] El usuario indicado no existe. Recuerda escribir su nombre completamente");
				SQL_FreeHandle(sql_consult);
			}
		}
	}
	
	return PLUGIN_HANDLED;
}

// zp_unban [target]
public cmd_unban(id, level, cid)
{
	if(cmd_access(id, g_iAccessAdminZpBan, cid, 2) || g_zr_pj[id] == 2174)
	{
		new s_name[32];
		read_argv(1, s_name, charsmax(s_name));
		
		replace_all(s_name, charsmax(s_name), "\0\", "~")
		replace_all(s_name, charsmax(s_name), "\", "")
		replace_all(s_name, charsmax(s_name), "/", "")
		replace_all(s_name, charsmax(s_name), "DROP TABLE", "")
		replace_all(s_name, charsmax(s_name), "TRUNCATE", "")
		replace_all(s_name, charsmax(s_name), "INSERT INTO", "")
		replace_all(s_name, charsmax(s_name), "INSERT UPDATE", "")
		replace_all(s_name, charsmax(s_name), "UPDATE", "")
		
		if(read_argc() < 2)
		{
			console_print(id, "[ZP] El comando debe ser introducido de la siguiente manera: <NOMBRE COMPLETO>");
			return PLUGIN_HANDLED;
		}
		
		new Handle:sql_consult = SQL_PrepareQuery(g_sql_connection, "SELECT zp_id FROM bans WHERE name = ^"%s^";", s_name);
		if(!SQL_Execute(sql_consult))
		{
			new sql_error[512];
			SQL_QueryError(sql_consult, sql_error, 511);
			
			log_to_file("zr_sql.log", "- LOG:8 - %s", sql_error);
			
			SQL_FreeHandle(sql_consult);
		}
		else if(SQL_NumResults(sql_consult))
		{
			console_print(id, "[ZP] El usuario indicado fue desbaneado");
			
			CC(0, "!g[ZP] %s!y desbaneo la cuenta de !g%s!y", g_playername[id], s_name);
			
			SQL_FreeHandle(sql_consult);
			
			sql_consult = SQL_PrepareQuery(g_sql_connection, "DELETE FROM bans WHERE name = ^"%s^";", s_name);
			if(!SQL_Execute(sql_consult))
			{
				new sql_error[512];
				SQL_QueryError(sql_consult, sql_error, 511);
				
				log_to_file("zr_sql.log", "- LOG:29 - %s", sql_error);
			}
			SQL_FreeHandle(sql_consult)
		}
		else
		{
			console_print(id, "[ZP] El usuario indicado no existe o no esta baneado");
			SQL_FreeHandle(sql_consult);
		}
	}
	
	return PLUGIN_HANDLED;
}

// zp_set_furia [target][amount]
public cmd_furia(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	static arg[32];
	static arg2[32];
	static iarg2;
	static player;
	
	read_argv(1, arg, charsmax(arg));
	read_argv(2, arg2, charsmax(arg2));
	
	if(read_argc() < 3)
	{
		client_print(id, print_console, "[ZP] Uso: zp_set_furia <nombre> <cantidad>")
		return PLUGIN_HANDLED;
	}
	
	iarg2 = str_to_num(arg2);
	
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF);
	
	if(!player)
		return PLUGIN_HANDLED;
	
	if(!allowed_gave_rewards(player, 1, 0))
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	g_madness_count[player] = iarg2;
	
	static sarg2[15];
	add_dot(iarg2, sarg2, 14);
	console_print(id, "[ZP] Le has seteado %s furia zombie a %s", sarg2, g_playername[player]);
	
	return PLUGIN_HANDLED;
}

// zp_set_antidote [target][amount]
public cmd_antidote(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	static arg[32];
	static arg2[32];
	static iarg2;
	static player;
	
	read_argv(1, arg, charsmax(arg));
	read_argv(2, arg2, charsmax(arg2));
	
	if(read_argc() < 3)
	{
		client_print(id, print_console, "[ZP] Uso: zp_set_antidote <nombre> <cantidad>")
		return PLUGIN_HANDLED;
	}
	
	iarg2 = str_to_num(arg2);
	
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF);
	
	if(!player)
		return PLUGIN_HANDLED;
	
	if(!allowed_gave_rewards(player, 1, 0))
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	g_antidote_count[player] = iarg2;
	
	static sarg2[15];
	add_dot(iarg2, sarg2, 14);
	console_print(id, "[ZP] Le has seteado %s antidotos a %s", sarg2, g_playername[player]);
	
	return PLUGIN_HANDLED;
}

// zp_set_health [target][amount]
public cmd_health(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	static arg[32];
	static arg2[32];
	static iarg2;
	static player;
	
	read_argv(1, arg, charsmax(arg));
	read_argv(2, arg2, charsmax(arg2));
	
	if(read_argc() < 3)
	{
		client_print(id, print_console, "[ZP] Uso: zp_set_health <nombre> <cantidad>")
		return PLUGIN_HANDLED;
	}
	
	iarg2 = str_to_num(arg2);
	
	if(equal(arg, "todosTCS"))
	{
		new i;
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_user_alive(i))
				continue;
			
			if(i == id)
				continue;
			
			set_user_health(i, iarg2);
		}
		
		CC(0, "!g[ZP]!y Todos los jugadores tienen !g%d de vida!y", iarg2)
		return PLUGIN_HANDLED;
	}
	
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF);
	
	if(!player)
		return PLUGIN_HANDLED;
	
	if(!allowed_gave_rewards(player, 1, 0))
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	if(!is_user_alive(player))
		return PLUGIN_HANDLED;
	
	set_user_health(player, iarg2);
	
	static sarg2[15];
	add_dot(iarg2, sarg2, 14);
	console_print(id, "[ZP] Le has seteado %s de vida a %s", sarg2, g_playername[player]);
	
	return PLUGIN_HANDLED;
}

// zp_restart
public cmd_restart(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	CC(0, "!g[ZP]!y El servidor se reiniciara en 5 segundos!");
	CC(0, "!g[ZP]!y El servidor se reiniciara en 5 segundos!");
	CC(0, "!g[ZP]!y El servidor se reiniciara en 5 segundos!");
	CC(0, "!g[ZP]!y El servidor se reiniciara en 5 segundos!");
	
	new i;
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!hub(i, g_data[BIT_CONNECTED]))
			continue;
		
		saveKK(i);
	}
	
	set_task(6.0, "fn_RestartServer");
	
	return PLUGIN_HANDLED;
}
public fn_RestartServer()
	server_cmd("restart");

// zp_set_hat [target][hat id][activate]
public cmd_hat(id, level, cid)
{
	if(!check_access(id, 0))
		return PLUGIN_HANDLED;
	
	static arg[32];
	static arg2[32];
	static arg3[32];
	static iarg2;
	static iarg3;
	static player;
	
	read_argv(1, arg, charsmax(arg));
	read_argv(2, arg2, charsmax(arg2));
	read_argv(3, arg3, charsmax(arg3));
	
	if(read_argc() < 4)
	{
		new i;
		
		client_print(id, print_console, "");
		client_print(id, print_console, "========== LISTA DE HATS ==========");
		client_print(id, print_console, "ID = NOMBRE");
		for(i = 0; i < MAX_HATS; i++)
			client_print(id, print_console, "%d = %s", i, g_hat_name[i]);
		client_print(id, print_console, "TODOS = *");
		client_print(id, print_console, "======== FIN LISTA DE HATS ========");
		client_print(id, print_console, "");
		client_print(id, print_console, "[ZP] Uso: zp_set_hat <nombre> <hat id> <activar/desactivar>");
		
		return PLUGIN_HANDLED;
	}
	
	iarg2 = str_to_num(arg2);
	iarg3 = str_to_num(arg3);
	
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF);
	
	if(!player)
		return PLUGIN_HANDLED;
	
	if(!allowed_gave_rewards(player, 1, 0))
	{
		client_print(id, print_console, "[ZP] No disponible");
		return PLUGIN_HANDLED;
	}
	
	if(arg2[0] == '*')
	{
		new i;
		for(i = 0; i < MAX_HATS; i++)
			g_hat[player][i] = iarg3;
		
		console_print(id, "[ZP] Le has activado todos los hats a %s", g_playername[player]);
		return PLUGIN_HANDLED;
	}
	if(iarg2 < 0 || iarg2 >= MAX_HATS)
	{
		client_print(id, print_console, "[ZP] El hat indicado no existe");
		return PLUGIN_HANDLED;
	}
	
	fn_give_hat(player, iarg2);
	
	return PLUGIN_HANDLED;
}

// zp_set_logro [target][logro class][logro id]
public cmd_logro(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	static arg[32];
	static arg2[32];
	static arg3[32];
	static iarg2;
	static iarg3;
	static player;
	
	read_argv(1, arg, charsmax(arg));
	read_argv(2, arg2, charsmax(arg2));
	read_argv(3, arg3, charsmax(arg3));
	
	if(read_argc() < 4)
	{
		new i;
		new j;
		
		client_print(id, print_console, "");
		client_print(id, print_console, "========== LISTA DE LOGROS ==========");
		client_print(id, print_console, "CLASE     ID   -   NOMBRE CLASE   -   NOMBRE LOGRO");
		set_task(1.0, "fnOtherList", id);
		for(i = 0; i < 4; i++)
		{
			for(j = 0; j < MAX_LOGROS_CLASS[i]; j++)
				client_print(id, print_console, "%d        %d   -   %s   -   %s", i, j, LANG_CLASS_LOGROS[i], LANG_LOGROS_NAMES[i][j]);
		}
		
		return PLUGIN_HANDLED;
	}
	
	iarg2 = str_to_num(arg2);
	iarg3 = str_to_num(arg3);
	
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF);
	
	if(!player)
		return PLUGIN_HANDLED;
	
	if(!allowed_gave_rewards(player, 1, 0))
	{
		client_print(id, print_console, "[ZP] No disponible");
		return PLUGIN_HANDLED;
	}
	
	if(iarg2 < 0 || iarg2 >= MAX_CLASS || iarg3 < 0 || iarg3 >= MAX_LOGROS_CLASS[iarg2])
	{
		client_print(id, print_console, "[ZP] El logro indicado no existe");
		return PLUGIN_HANDLED;
	}
	
	fn_update_logro(player, iarg2, iarg3);
	
	return PLUGIN_HANDLED;
}
public fnOtherList(id)
{
	if(!check_access(id, 1))
		return;
	
	new i;
	new j;
	
	set_task(0.5, "fnOtherList_2", id)
	for(i = 4; i < 7; i++)
	{
		for(j = 0; j < MAX_LOGROS_CLASS[i]; j++)
			client_print(id, print_console, "%d        %d   -   %s   -   %s", i, j, LANG_CLASS_LOGROS[i], LANG_LOGROS_NAMES[i][j]);
	}
}
public fnOtherList_2(id)
{
	if(!check_access(id, 1))
		return;
	
	new i;
	new j;
	
	for(i = 7; i < MAX_CLASS; i++)
	{
		for(j = 0; j < MAX_LOGROS_CLASS[i]; j++)
			client_print(id, print_console, "%d        %d   -   %s   -   %s", i, j, LANG_CLASS_LOGROS[i], LANG_LOGROS_NAMES[i][j]);
	}
	
	client_print(id, print_console, "======== FIN LISTA DE LOGROS ========");
	client_print(id, print_console, "");
	client_print(id, print_console, "[ZP] Uso: zp_set_logro <nombre> <logro class> <logro id>");
}

// zp_set_bullets [target][amount]
public cmd_bullets(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	static arg[32];
	static arg2[32];
	static iarg2;
	static player;
	
	read_argv(1, arg, charsmax(arg));
	read_argv(2, arg2, charsmax(arg2));
	
	if(read_argc() < 3)
	{
		client_print(id, print_console, "[ZP] Uso: zp_set_bullets <nombre> <cantidad>")
		return PLUGIN_HANDLED;
	}
	
	iarg2 = str_to_num(arg2);
	
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF);
	
	if(!player)
		return PLUGIN_HANDLED;
	
	if(!allowed_gave_rewards(player, 1, 0))
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	if(g_currentweapon[player] == CSW_KNIFE)
		return PLUGIN_HANDLED;
	
	new sWeaponName[32];
	new iWeaponEntId;
	
	get_weaponname(g_currentweapon[player], sWeaponName, 31);
	iWeaponEntId = fm_find_ent_by_owner(-1, sWeaponName, player);
	
	set_pdata_int(player, AMMOOFFSET[g_currentweapon[player]], iarg2, OFFSET_LINUX);
	set_pdata_int(iWeaponEntId, OFFSET_CLIPAMMO, iarg2, OFFSET_LINUX_WEAPONS);
	
	console_print(id, "[ZP] Le has seteado %d balas a %s", iarg2, g_playername[player]);
	
	return PLUGIN_HANDLED;
}

// zp_set_bazooka [target][amount]
public cmd_bazooka(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	static arg[32];
	static arg2[32];
	static iarg2;
	static player;
	
	read_argv(1, arg, charsmax(arg));
	read_argv(2, arg2, charsmax(arg2));
	
	if(read_argc() < 3)
	{
		client_print(id, print_console, "[ZP] Uso: zp_set_bazooka <nombre> <cantidad>")
		return PLUGIN_HANDLED;
	}
	
	iarg2 = str_to_num(arg2);
	
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF);
	
	if(!player)
		return PLUGIN_HANDLED;
	
	if(!g_nemesis[player] && !g_annihilator[player])
		return PLUGIN_HANDLED;
	
	if(!allowed_gave_rewards(player, 1, 0))
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	g_bazooka[player] = iarg2
	
	console_print(id, "[ZP] Le has seteado %d bazookas a %s", iarg2, g_playername[player]);
	
	return PLUGIN_HANDLED;
}

// zp_set_laser [target][amount]
public cmd_laser(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	static arg[32];
	static arg2[32];
	static iarg2;
	static player;
	
	read_argv(1, arg, charsmax(arg));
	read_argv(2, arg2, charsmax(arg2));
	
	if(read_argc() < 3)
	{
		client_print(id, print_console, "[ZP] Uso: zp_set_laser <nombre> <cantidad>")
		return PLUGIN_HANDLED;
	}
	
	iarg2 = str_to_num(arg2);
	
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF);
	
	if(!player)
		return PLUGIN_HANDLED;
	
	if(!g_wesker[player])
		return PLUGIN_HANDLED;
	
	if(!allowed_gave_rewards(player, 1, 0))
	{
		client_print(id, print_console, "[ZP] No disponible")
		return PLUGIN_HANDLED;
	}
	
	g_wesker_laser[player] = iarg2
	
	console_print(id, "[ZP] Le has seteado %d laser a %s", iarg2, g_playername[player]);
	
	return PLUGIN_HANDLED;
}

// zp_show_leader [name]
public cmd_leader(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	static arg[32];
	read_argv(1, arg, charsmax(arg));
	
	if(read_argc() < 2)
	{
		client_print(id, print_console, "[ZP] Uso: zp_show_leader <nombre de lo que buscas>")
		return PLUGIN_HANDLED;
	}
	
	if(equal(arg, "combo")) CC(0, "!g[ZP]!t %s!y es líder en combo con un máximo de !g%s combos!y", g_combo_leader_name, g_combo_leader_text)
	else if(equal(arg, "vicio")) CC(0, "!g[ZP]!t %s!y es el más viciado del servidor con: %s", g_leader_vicius_name, g_leader_vicius_days_t)
	else if(equal(arg, "general")) CC(0, "!g[ZP]!t %s!y está liderando en !gRango %s!y con !g%d niveles!y y !g%s XP!y", g_leader_name, g_range_letters[g_leader_range], g_leader_level, g_leader_xp_text)
	else if(equal(arg, "logro")) CC(0, "!g[ZP]!t %s!y es lider en logros con un máximo de !g%d logros!y", g_leader_logros_name, g_leader_logros_count)
	else if(equal(arg, "loteria")) CC(0, "!g[ZP]!y Recordá que podes jugar a la !g/lotería!y para ganar experiencia!")
	else if(equal(arg, "vinc"))
	{
		new i;
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(!hub(i, g_data[BIT_CONNECTED]))
				continue;
			
			if(g_vinc[i])
				continue;
			
			CC(i, "!g[ZP]!y Recordá vincular tu cuenta a la del foro para tener más opciones sobre tu cuenta")
			CC(i, "!g[ZP]!y Recordá también que si pierdes la contraseña, es la única manera de recuperarla")
		}
	}
	else if(equal(arg, "save"))
	{
		new i;
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(!hub(i, g_data[BIT_CONNECTED]))
				continue;
			
			saveKK(i);
		}
	}
	else if(equal(arg, "aps"))
	{
		g_duel_final_aps = !g_duel_final_aps;
	}
	
	return PLUGIN_HANDLED;
}

new roberto = 0;

// zp_set_light [letter]
public cmd_light(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	static arg[32];
	read_argv(1, arg, charsmax(arg));
	
	if(read_argc() < 2)
	{
		client_print(id, print_console, "[ZP] Uso: zp_set_light <letra de iluminacion>")
		return PLUGIN_HANDLED;
	}
	
	if(equal(arg, "SCREENFADE"))
	{
		new i;
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_user_alive(i))
				continue;
			
			set_task(0.1, "fn_ChangeScreens");
		}
		
		roberto = 1;
	}
	else if(equal(arg, "SCREENSHAKE"))
	{
		new i;
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_user_alive(i))
				continue;
			
			set_task(0.1, "setScreenShake");
		}
		
		roberto = 1;
	}
	else if(equal(arg, "RENDER"))
	{
		new i;
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_user_alive(i))
				continue;
			
			set_task(0.1, "setRender");
		}
		
		roberto = 1;
	}
	else if(equal(arg, "APAGAR"))
		roberto = 0
	else
	{
		g_map_light[0] = arg[0];
		set_lights(g_map_light[0]);
		
		roberto = 0
		
		CC(0, "!g[ZP] %s!y ha establecido la luz del mapa al grado de iluminación !g%s!y", g_playername[id], g_map_light[0])
	}
	
	return PLUGIN_HANDLED;
}

public cmd_speed(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	g_block_speed = !g_block_speed;
	CC(0, "!g[ZP]!y Todos los jugadores han sido %sparalizados!", g_block_speed ? "" : "des")
	
	new i;
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_alive(i))
			continue;
		
		if(i == id)
			continue;
		
		ExecuteHamB(Ham_Player_ResetMaxSpeed, i);
	}
	
	return PLUGIN_HANDLED;
}

public cmd_weapon(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	static arg[32];
	read_argv(1, arg, charsmax(arg));
	
	if(read_argc() < 2)
	{
		client_print(id, print_console, "[ZP] Uso: zp_set_weapon <arma>")
		return PLUGIN_HANDLED;
	}
	
	if(equal(arg, "weapon_hegrenade") || equal(arg, "weapon_flashbang") || equal(arg, "weapon_smokegrenade"))
	{
		new i;
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_user_alive(i))
				continue;
			
			if(i == id)
				continue;
			
			give_item(i, arg);
		}
	}
	
	return PLUGIN_HANDLED;
}

public cmd_blockweapons(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	g_block_weapons = !g_block_weapons;
	CC(id, "!g[ZP]!y block weapons %d", g_block_weapons)
	
	return PLUGIN_HANDLED;
}

public cmd_blockheadz(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	g_block_headz = !g_block_headz;
	CC(id, "!g[ZP]!y block head zombie %d", g_block_headz)
	
	return PLUGIN_HANDLED;
}

public cmd_tejos(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	g_game_tejos = !g_game_tejos;
	CC(id, "!g[ZP]!y game tejos %d", g_game_tejos)
	
	if(g_game_tejos)
	{
		g_pos_tejos = 0;
		
		new i;
		for(i = 0; i < 32; ++i)
		{
			g_distance_tejos[i] = 9999.9;
		}
	}
	
	return PLUGIN_HANDLED;
}

public cmd_finishtejos(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	if(g_game_tejos)
	{
		SortFloats(g_distance_tejos, 32, Sort_Ascending);
		
		new i;
		new j;
		new k;
		new l = 1;
		
		for(k = 0; k < 32; ++k)
		{
			if(g_distance_tejos[k] == 9999.9 || g_distance_tejos[k] == 0.0)
				continue;
			
			break;
		}
		
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_user_alive(i))
				continue;
			
			if(g_distance_tejosid[i] == g_distance_tejos[k])
				CC(0, "!g[ZP]!y La granada más cercana es la de !g%s!y a !g%f!y unidades", g_playername[i], g_distance_tejos[0]);
			else if(g_distance_tejosid[i] == g_distance_tejos[k+1])
				j = i;
		}
		
		if(is_user_alive(j))
			CC(0, "!g[ZP]!y La granada que le sigue es la de !g%s!y a !g%f!y unidades", g_playername[j], g_distance_tejos[1]);
		
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_user_alive(i))
				continue;
			
			if(g_distance_tejosid[i] == 9999.9 || g_distance_tejosid[i] == 0.0)
				continue;
			
			for(j = 0; j < 32; ++j)
			{
				if(g_distance_tejosid[i] == g_distance_tejos[j])
				{
					console_print(0, "%d. %s : %f", (j+1), g_playername[i], g_distance_tejosid[i]);
				}
			}
		}
	}
	
	g_game_tejos = !g_game_tejos;
	CC(id, "!g[ZP]!y game tejos %d", g_game_tejos)
	
	return PLUGIN_HANDLED;
}

new g_race_count;
public cmd_race(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	g_game_race = !g_game_race;
	CC(id, "!g[ZP]!y game race %d", g_game_race)
	
	if(g_game_race)
	{
		g_block_speed = 1
		
		new i;
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_user_alive(i))
				continue;
			
			g_touch_cabeza[i] = 0;
			
			if(i == id)
				continue;
			
			ExecuteHamB(Ham_Player_ResetMaxSpeed, i);
		}
		
		g_race_count = 10;
		set_task(1.0, "aaaaaaasdasda")
	}
	
	return PLUGIN_HANDLED;
}

public aaaaaaasdasda()
{
	if(!g_race_count)
	{
		g_race_position = 1;
		g_block_speed = 0
		
		new i;
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_user_alive(i))
				continue;
			
			if(check_access(i, 1))
				continue;
			
			ExecuteHamB(Ham_Player_ResetMaxSpeed, i);
		}
		
		CC(0, "!g¡GO!!y")
		return;
	}
	
	CC(0, "!g[ZP]!y EN %d SEGUNDOS COMIENZA LA CARRERA!", g_race_count)
	
	--g_race_count;
	set_task(1.0, "aaaaaaasdasda")
}

public cmd_bomba(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	static arg[32], arg2[32];
	static iarg;
	
	read_argv(1, arg, charsmax(arg));
	read_argv(2, arg2, charsmax(arg2));
	
	iarg = str_to_num(arg);
	g_game_bomba_radius = str_to_float(arg2);
	
	g_game_bomba = iarg;
	CC(id, "!g[ZP]!y game bomba %d", g_game_bomba)
	
	if(g_game_bomba)
	{
		give_item(id, "weapon_flashbang");
		cs_set_user_bpammo(id, CSW_FLASHBANG, 10);
	}
	
	return PLUGIN_HANDLED;
}

public cmd_block_habs(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	g_block_habs = !g_block_habs;
	CC(id, "!g[ZP]!y block habs %d", g_block_habs)
	
	return PLUGIN_HANDLED;
}

public fn_ChangeScreens()
{
	if(!roberto)
		return;
	
	new i;
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		message_begin(MSG_ONE_UNRELIABLE, g_msgScreenFade, _, i)
		write_short(UNIT_SECOND*4);
		write_short(UNIT_SECOND*4);
		write_short(0x0000);
		write_byte(random_num(0, 255));
		write_byte(random_num(0, 255));
		write_byte(random_num(0, 255));
		write_byte(random_num(150, 220));
		message_end();
	}
	
	set_task(0.15, "fn_ChangeScreens");
}

public setRender()
{
	if(!roberto)
		return;
	
	new i;
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_alive(i))
			continue;
		
		set_user_rendering(i, kRenderFxGlowShell, random_num(50, 255), random_num(50, 255), random_num(50, 255), kRenderNormal, 25);
	}
	
	set_task(0.15, "setRender");
}

public setScreenShake()
{
	if(!roberto)
		return;
	
	new i;
	for(i = 1; i <= g_maxplayers; ++i)
	{
		if(!is_user_connected(i))
			continue;
		
		message_begin(MSG_ONE_UNRELIABLE, g_msgScreenShake, _, i)
		write_short(UNIT_SECOND * 14) // amplitude
		write_short(UNIT_SECOND * 14) // duration
		write_short(UNIT_SECOND * 14) // frequency
		message_end()
	}
	
	set_task(3.0, "setScreenShake");
}

public cmd_us_speed(id, level, cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	static arg[32];
	read_argv(1, arg, charsmax(arg));
	
	user_shoot_speed = str_to_float(arg);
	
	return PLUGIN_HANDLED;
}

/*================================================================================
 [Message Hooks]
=================================================================================*/

// Current Weapon info
public message_cur_weapon(msg_id, msg_dest, msg_entity)
{
	// Not alive
	if (!hub(msg_entity, g_data[BIT_ALIVE]))
		return;
		
	// Zombie ?
	if (g_zombie[msg_entity])
		return;
	
	// Not an active weapon
	if (get_msg_arg_int(1) != 1)
		return;
	
	if(g_survivor[msg_entity] || g_wesker[msg_entity] || g_sniper[msg_entity] || g_tribal_human[msg_entity] || g_predator[msg_entity] || g_unclip[msg_entity])
	{
		// Get weapon's id
		static weapon
		weapon = get_msg_arg_int(2)
		
		// Unlimited Clip Ammo for this weapon?
		if (MAXBPAMMO[weapon] > 2)
		{
			// Max out clip ammo
			static weapon_ent
			weapon_ent = fm_cs_get_current_weapon_ent(msg_entity)
			if(is_valid_ent(weapon_ent)) cs_set_weapon_ammo(weapon_ent, MAXCLIP[weapon])
			
			// HUD should show full clip all the time
			set_msg_arg_int(3, get_msg_argtype(3), MAXCLIP[weapon])
			
			gl_bullets[msg_entity]++;
		}
	}
}

// Take off player's money
public message_money(msg_id, msg_dest, msg_entity)
{
	if(!is_user_connected(msg_entity))
		return PLUGIN_HANDLED;
	
	cs_set_user_money(msg_entity, 0, 0);
	return PLUGIN_HANDLED;
}

// Fix for the HL engine bug when HP is multiples of 256
public message_health(msg_id, msg_dest, msg_entity)
{
	if(!is_user_connected(msg_entity))
		return;
	
	// Get player's health
	static health
	health = get_msg_arg_int(1)
	
	// Don't bother
	if (health < 256) return;
	
	// Check if we need to fix it
	if (health % 256 == 0)
		set_user_health(msg_entity, get_user_health(msg_entity) + 1)
	
	// HUD can only show as much as 255 hp
	set_msg_arg_int(1, get_msg_argtype(1), 255)
}

// Block flashlight battery messages if custom flashlight is enabled instead
public message_flashbat(msg_id, msg_dest, msg_entity)
{
	if(get_msg_arg_int(1) < 100) 
	{
		set_msg_arg_int(1, ARG_BYTE, 100)
		fm_cs_set_user_batteries(msg_entity, 100)
	}
}

public message_flashlight(msg_id, msg_dest, msg_entity)
	set_msg_arg_int(2, ARG_BYTE, 100);

// Flashbangs should only affect zombies
public message_screenfade(msg_id, msg_dest, msg_entity)
{
	if (get_msg_arg_int(4) != 255 || get_msg_arg_int(5) != 255 || get_msg_arg_int(6) != 255 || get_msg_arg_int(7) < 200)
		return PLUGIN_CONTINUE;
	
	// Nemesis shouldn't be FBed
	if (g_zombie[msg_entity] && !g_nemesis[msg_entity] && !g_alien[msg_entity] && !g_annihilator[msg_entity])
	{
		// Set flash color to nighvision's
		set_msg_arg_int(4, get_msg_argtype(4), 0)
		set_msg_arg_int(5, get_msg_argtype(5), 200)
		set_msg_arg_int(6, get_msg_argtype(6), 0)
		return PLUGIN_CONTINUE;
	}
	
	return PLUGIN_HANDLED;
}

// Prevent spectators' nightvision from being turned off when switching targets, etc.
public message_nvgtoggle()
{
	return PLUGIN_HANDLED;
}

// Prevent zombies from seeing any weapon pickup icon
public message_weappickup(msg_id, msg_dest, msg_entity)
{
	if (g_zombie[msg_entity])
		return PLUGIN_HANDLED;
	
	return PLUGIN_CONTINUE;
}

// Prevent zombies from seeing any ammo pickup icon
public message_ammopickup(msg_id, msg_dest, msg_entity)
{
	if (g_zombie[msg_entity])
		return PLUGIN_HANDLED;
	
	return PLUGIN_CONTINUE;
}

// Block hostage HUD display
public message_scenario()
{
	if (get_msg_args() > 1)
	{
		static sprite[8]
		get_msg_arg_string(2, sprite, charsmax(sprite))
		
		if (equal(sprite, "hostage"))
			return PLUGIN_HANDLED;
	}
	
	return PLUGIN_CONTINUE;
}

// Block hostages from appearing on radar
public message_hostagepos()
{
	return PLUGIN_HANDLED;
}

// Block some text messages
public message_textmsg()
{
	static textmsg[22];
	get_msg_arg_string(2, textmsg, charsmax(textmsg));
	
	if(get_msg_args() == 5 && (get_msg_argtype(5) == ARG_STRING)) 
	{
		get_msg_arg_string(5, textmsg, charsmax(textmsg));
		
		if(equal(textmsg, "#Fire_in_the_hole"))
			return PLUGIN_HANDLED;
	}
	else if(get_msg_args() == 6 && (get_msg_argtype(6) == ARG_STRING)) 
	{
		get_msg_arg_string(6, textmsg, charsmax(textmsg));
		
		if(equal(textmsg, "#Fire_in_the_hole"))
			return PLUGIN_HANDLED;
	}
	
	if (equal(textmsg, "#Game_teammate_attack"))
		return PLUGIN_HANDLED;
	
	if(equal(textmsg, "#Game_Commencing"))
        return PLUGIN_HANDLED;
	
	// Game restarting, reset scores and call round end to balance the teams
	if (equal(textmsg, "#Game_will_restart_in"))
	{
		g_scorehumans = 0;
		g_scorezombies = 0;
		logevent_round_end();
	}
	// Block round end related messages
	else if (equal(textmsg, "#Hostages_Not_Rescued") || equal(textmsg, "#Round_Draw") || equal(textmsg, "#Terrorists_Win") || equal(textmsg, "#CTs_Win"))
		return PLUGIN_HANDLED;
	
	return PLUGIN_CONTINUE;
}

// Block CS round win audio messages, since we're playing our own instead
public message_sendaudio()
{
	static audio[25];
	get_msg_arg_string(2, audio, charsmax(audio));
	
	if(equali(audio[7], "terwin") || equali(audio[7], "ctwin") || equali(audio[7], "rounddraw") || equali(audio, "%!MRAD_FIREINHOLE"))
		return PLUGIN_HANDLED;
	
	return PLUGIN_CONTINUE;
}

// Send actual team scores (T = zombies // CT = humans)
public message_teamscore()
{
	static team[2]
	get_msg_arg_string(1, team, charsmax(team))
	
	switch (team[0])
	{
		// CT
		case 'C': set_msg_arg_int(2, get_msg_argtype(2), g_scorehumans)
		// Terrorist
		case 'T': set_msg_arg_int(2, get_msg_argtype(2), g_scorezombies)
	}
}

// Team Switch (or player joining a team for first time)
public message_teaminfo(msg_id, msg_dest)
{
	// Only hook global messages
	if (msg_dest != MSG_ALL && msg_dest != MSG_BROADCAST) return;
	
	// Don't pick up our own TeamInfo messages for this player (bugfix)
	if (g_switchingteam) return;
	
	// Get player's id
	static id
	id = get_msg_arg_int(1)
	
	// Invalid player id? (bugfix)
	if (!(1 <= id <= g_maxplayers)) return;
	
	// Enable spectators' nightvision if not spawning right away
	set_task(0.2, "spec_nvision", id)
	
	// Round didn't start yet, nothing to worry about
	if (g_newround) return;
	
	// Get his new team
	static team[2]
	get_msg_arg_string(2, team, charsmax(team))
	
	// Perform some checks to see if they should join a different team instead
	switch(team[0])
	{
		case 'C': // CT
		{
			if((g_survround || g_wesker_round || g_sniper_round || g_tribal_round || g_alvspre_round) && fnGetHumans()) // survivor alive --> switch to T and spawn as zombie
			{
				g_respawn_as_zombie[id] = 1;
				remove_task(id+TASK_TEAM)
				fm_cs_set_user_team(id, FM_CS_TEAM_T)
				set_msg_arg_string(2, "TERRORIST")
			}
			else if(!fnGetZombies() && !g_duel_final) // no zombies alive --> switch to T and spawn as zombie
			{
				g_respawn_as_zombie[id] = 1;
				remove_task(id+TASK_TEAM)
				fm_cs_set_user_team(id, FM_CS_TEAM_T)
				set_msg_arg_string(2, "TERRORIST")
			}
			else if(g_duel_final)
			{
				g_respawn_as_zombie[id] = 0;
				remove_task(id+TASK_TEAM)
				fm_cs_set_user_team(id, FM_CS_TEAM_CT)
				set_msg_arg_string(2, "CT")
			}
		}
		case 'T': // Terrorist
		{
			if((g_swarmround || g_survround || g_wesker_round || g_sniper_round || g_tribal_round || g_alvspre_round) && fnGetHumans()) // survivor alive or swarm round w/ humans --> spawn as zombie
			{
				g_respawn_as_zombie[id] = 1;
				remove_task(id+TASK_TEAM)
				fm_cs_set_user_team(id, FM_CS_TEAM_T)
				set_msg_arg_string(2, "TERRORIST")
			}
			else if(fnGetZombies() || g_duel_final) // zombies alive --> switch to CT
			{
				g_respawn_as_zombie[id] = 0;
				remove_task(id+TASK_TEAM)
				fm_cs_set_user_team(id, FM_CS_TEAM_CT)
				set_msg_arg_string(2, "CT")
			}
		}
	}
}

// Remove Buy Zone
public message_statusicon(msg_id, msg_dest, msg_entity)
{
	static icon[8]
	get_msg_arg_string(2, icon, charsmax(icon))
	
	if(equal(icon, "buyzone"))
	{
		set_pdata_int(msg_entity, OFFSET_BUYZONE, get_pdata_int(msg_entity, OFFSET_BUYZONE, OFFSET_LINUX) & ~(1 << 0), OFFSET_LINUX)
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_CONTINUE;
}

// Prevent duplicate message
public message_saytext(msg_id, msg_dest, msg_entity) return PLUGIN_HANDLED;
	
/*================================================================================
 [Main Functions]
=================================================================================*/

// Make Zombie Task
public make_zombie_task()
{
	if(g_tribal_acomodado) make_a_zombie(MODE_TRIBAL, 0)
	else if(g_alvspred_acomodado) make_a_zombie(MODE_ALVSPRED, 0)
	else if(g_fp_acomodado) make_a_zombie(MODE_FP, 0)
	else make_a_zombie(MODE_NONE, 0)
}

// Make a Zombie Function
make_a_zombie(mode, id) // make_a_zombie_f
{
	// Get alive players count
	static iPlayersnum
	iPlayersnum = fnGetAlive()
	
	// Not enough players, come back later!
	if(iPlayersnum < 2 && mode == MODE_NONE)
	{
		set_task(2.0, "make_zombie_task", TASK_MAKEZOMBIE)
		return;
	}
	
	// Set up some common vars
	static forward_id, iZombies, iMaxZombies
	
	if((mode == MODE_NONE && random_num(1, EASY_MODS(60)) == 1 && iPlayersnum >= 20) && !g_one_anniq || mode == MODE_ANNIHILATION)
	{
		set_lights("a");
		
		g_one_anniq = 1;
	
		// Message Mode
		fn_show_mode_msg(MODE_ANNIHILATION, g_modes_play[MODE_ANNIHILATION], "aniquilador");
		
		// Choose player randomly?
		if (mode == MODE_NONE)
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
		
		// Remember id for calling our forward later
		forward_id = id
		
		// Annihilation Mode
		g_annihilation_round = 1
		
		// Turn player into annihilator
		zombieme(id, 0, 0, 0, 0, 0, 1, 0)
		
		// Remaining players should be humans (CTs)
		for(id = 1; id <= g_maxplayers; id++)
		{
			// Not alive
			if(!hub(id, g_data[BIT_ALIVE]))
				continue;
			
			// First zombie/nemesis
			if(g_zombie[id])
				continue;
			
			ham_strip_weapons(id, "weapon_hegrenade")
			ham_strip_weapons(id, "weapon_flashbang")
			ham_strip_weapons(id, "weapon_smokegrenade")
			
			// Switch to CT
			if (fm_cs_get_user_team(id) != FM_CS_TEAM_CT) // need to change team?
			{
				remove_task(id+TASK_TEAM)
				fm_cs_set_user_team(id, FM_CS_TEAM_CT)
				fm_user_team_update(id)
			}
		}
		
		// Play Annihilation sound
		PlaySound(g_sSoundModeNemesis[random_num(0, charsmax(g_sSoundModeNemesis))]);
		
		// Show Annihilation HUD notice
		set_hudmessage(255, 255, 255, HUD_EVENT_X, HUD_EVENT_Y, 0, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ %s ES UN ANIQUILADOR !", g_playername[forward_id])
	}
	else if ((mode == MODE_NONE && random_num(1, EASY_MODS(50)) == 41) && iPlayersnum >= 15 && !g_one_duel || mode == MODE_DUEL)
	{
		set_lights("i");
		
		g_one_duel = 1;
		
		// Message Mode
		fn_show_mode_msg(MODE_DUEL, g_modes_play[MODE_DUEL], "Duelo Final");
		
		// Duel Mode
		g_duel_final = 1
		
		if(random_num(0, 1))
			g_duel_final_aps = 1;
		
		set_cvar_num("mp_friendlyfire", 1)
		
		set_cvar_num("pbk_afk_time", 900);
		set_cvar_num("pbk_spec_time", 9999);
		set_cvar_num("pbk_join_time", 9999);
		
		// Make sure there are alive players on both teams (BUGFIX)
		if (!fnGetAliveTs())
		{
			// Move random player to T team
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			remove_task(id+TASK_TEAM)
			fm_cs_set_user_team(id, FM_CS_TEAM_T)
			fm_user_team_update(id)
		}
		else if (!fnGetAliveCTs())
		{
			// Move random player to CT team
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			remove_task(id+TASK_TEAM)
			fm_cs_set_user_team(id, FM_CS_TEAM_CT)
			fm_user_team_update(id)
		}
		
		// Remaining players should be humans (CTs)
		for(id = 1; id <= g_maxplayers; id++)
		{
			// Not alive
			if(!hub(id, g_data[BIT_ALIVE]))
				continue;
			
			strip_user_weapons(id)
			give_item(id, "weapon_knife")
			
			ExecuteHamB(Ham_CS_RoundRespawn, id)
			
			// Switch to CT
			if (fm_cs_get_user_team(id) != FM_CS_TEAM_CT) // need to change team?
			{
				remove_task(id+TASK_TEAM)
				fm_cs_set_user_team(id, FM_CS_TEAM_CT)
				fm_user_team_update(id)
			}
		}
		
		// Play swarm sound
		
		PlaySound(g_sSoundModeSwarm[random_num(0, charsmax(g_sSoundModeSwarm))]);
		
		// Show Swarm HUD notice
		set_dhudmessage(255, 0, 0, HUD_EVENT_X, 0.3, 0, 0.0, 4.9, 1.0, 1.0)
		show_dhudmessage(0, "¡ DUELO FINAL %s!^nOctavos de final", g_duel_final_aps ? "DE APS" : "")
	}
	else if ((mode == MODE_NONE && random_num(1, EASY_MODS(24)) == 1 && iPlayersnum >= 5) || mode == MODE_SURVIVOR)
	{
		set_lights("a");
		
		// Message Mode
		fn_show_mode_msg(MODE_SURVIVOR, g_modes_play[MODE_SURVIVOR], "survivor");
		
		// Survivor Mode
		g_survround = 1
		
		if(fnGetPlaying() >= 20)
		{
			gl_time_nem = 1;
			
			remove_task(TASK_SNIPER_ROUND)
			set_task(60.0, "fnDeactivateAchievement", TASK_SNIPER_ROUND);
		}
		
		// Choose player randomly?
		if (mode == MODE_NONE)
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
		
		// Remember id for calling our forward later
		forward_id = id
		
		// Turn player into a survivor
		humanme(id, 1, 0, 0, 0, 0, 0)
		
		// Turn the remaining players into zombies
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Not alive
			if (!hub(id, g_data[BIT_ALIVE]))
				continue;
			
			do_random_spawn(id)
			
			// Survivor or already a zombie
			if (g_survivor[id] || g_zombie[id])
				continue;
			
			// Turn into a zombie
			zombieme(id, 0, 0, 1, 0, 0, 0, 0)
		}
		
		// Play survivor sound
		PlaySound(g_sSoundModeSurvivor[random_num(0, charsmax(g_sSoundModeSurvivor))]);
		
		// Show Survivor HUD notice
		set_hudmessage(20, 20, 255, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ %s ES SURVIVOR !", g_playername[forward_id])
	}
	else if ((mode == MODE_NONE && random_num(1, EASY_MODS(15)) == 1) || mode == MODE_SWARM)
	{
		set_lights(g_map_light[0]);
		
		// Message Mode
		fn_show_mode_msg(MODE_SWARM, g_modes_play[MODE_SWARM], "swarm");
		
		// Swarm Mode
		g_swarmround = 1
		
		// Make sure there are alive players on both teams (BUGFIX)
		if (!fnGetAliveTs())
		{
			// Move random player to T team
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			remove_task(id+TASK_TEAM)
			fm_cs_set_user_team(id, FM_CS_TEAM_T)
			fm_user_team_update(id)
		}
		else if (!fnGetAliveCTs())
		{
			// Move random player to CT team
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			remove_task(id+TASK_TEAM)
			fm_cs_set_user_team(id, FM_CS_TEAM_CT)
			fm_user_team_update(id)
		}
		
		// Turn every T into a zombie
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Not alive
			if (!hub(id, g_data[BIT_ALIVE]))
				continue;
			
			// Not a Terrorist
			if (fm_cs_get_user_team(id) != FM_CS_TEAM_T)
				continue;
			
			// Turn into a zombie
			zombieme(id, 0, 0, 1, 0, 0, 0, 0)
		}
		
		// Play swarm sound
		
		PlaySound(g_sSoundModeSwarm[random_num(0, charsmax(g_sSoundModeSwarm))]);
		
		// Show Swarm HUD notice
		set_hudmessage(20, 255, 20, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ SWARM !")
	}
	else if ((mode == MODE_NONE && random_num(1, EASY_MODS(15)) == 1 && floatround(iPlayersnum*0.3, floatround_ceil) >= 2 &&
	floatround(iPlayersnum*0.3, floatround_ceil) < iPlayersnum) || mode == MODE_MULTI)
	{
		set_lights(g_map_light[0]);
		
		// Message Mode
		fn_show_mode_msg(MODE_MULTI, g_modes_play[MODE_MULTI], "infección múltiple");
		
		// iMaxZombies is rounded up, in case there aren't enough players
		iMaxZombies = floatround(iPlayersnum*0.3, floatround_ceil)
		iZombies = 0
		
		// Randomly turn iMaxZombies players into zombies
		while (iZombies < iMaxZombies)
		{
			// Keep looping through all players
			if (++id > g_maxplayers) id = 1
			
			// Dead or already a zombie
			if (!hub(id, g_data[BIT_ALIVE]) || g_zombie[id])
				continue;
			
			// Random chance
			if (random_num(0, 1))
			{
				// Turn into a zombie
				zombieme(id, 0, 0, 1, 0, 0, 0, 0)
				iZombies++
			}
		}
		
		// Turn the remaining players into humans
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Only those of them who aren't zombies
			if (!hub(id, g_data[BIT_ALIVE]) || g_zombie[id])
				continue;
			
			// Switch to CT
			if (fm_cs_get_user_team(id) != FM_CS_TEAM_CT) // need to change team?
			{
				remove_task(id+TASK_TEAM)
				fm_cs_set_user_team(id, FM_CS_TEAM_CT)
				fm_user_team_update(id)
			}
		}
		
		// Play multi infection sound
		PlaySound(g_sSoundModeMulti[random_num(0, charsmax(g_sSoundModeMulti))]);
		
		// Show Multi Infection HUD notice
		set_hudmessage(200, 50, 0, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ INFECCIÓN MÚLTIPLE !")
	}
	else if((mode == MODE_NONE && random_num(1, EASY_MODS(45)) == 1) || mode == MODE_SNIPER)
	{
		set_lights("a");
		
		// Message Mode
		fn_show_mode_msg(MODE_SNIPER, g_modes_play[MODE_SNIPER], "sniper");
		
		// Sniper Mode
		g_sniper_round = 1
		
		// Choose player randomly?
		if (mode == MODE_NONE)
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
		
		// Remember id for calling our forward later
		forward_id = id
		
		// Turn player into a Sniper
		humanme(id, 0, 0, 0, 0, 0, 1)
		
		// Turn the remaining players into zombies
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Not alive
			if (!hub(id, g_data[BIT_ALIVE]))
				continue;
			
			do_random_spawn(id)
			
			// Sniper or already a zombie
			if(g_sniper[id] || g_zombie[id])
				continue;
			
			// Turn into a zombie
			zombieme(id, 0, 0, 1, 0, 0, 0, 0)
		}
		
		g_zombies_left_total = 10 * fnGetAlive();
		g_zombies_left = g_zombies_left_total;
		
		// Play Sniper sound
		PlaySound(g_sSoundModeSurvivor[random_num(0, charsmax(g_sSoundModeSurvivor))]);
		
		// Show Sniper HUD notice
		set_hudmessage(0, 255, 0, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ %s ES UN SNIPER !", g_playername[forward_id])
		
		remove_task(TASK_SNIPER_ROUND)
		set_task(2.0, "fn_ShowInfoMode", TASK_SNIPER_ROUND, _, _, "b")
	}
	else if ((mode == MODE_NONE && random_num(1, EASY_MODS(20)) == 1 && floatround((iPlayersnum-4)*0.5, floatround_ceil) >= 1
	&& iPlayersnum-(4+floatround((iPlayersnum-4)*0.5, floatround_ceil)) >= 1 && iPlayersnum >= 10) || mode == MODE_PLAGUE)
	{
		set_lights(g_map_light[0]);
		
		// Message Mode
		fn_show_mode_msg(MODE_PLAGUE, g_modes_play[MODE_PLAGUE], "plague");
		
		// Plague Mode
		g_plagueround = 1
		
		// Turn specified amount of players into Survivors
		static iSurvivors, iMaxSurvivors
		iMaxSurvivors = 2
		iSurvivors = 0
		
		while (iSurvivors < iMaxSurvivors)
		{
			// Choose random guy
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			
			// Already a survivor?
			if (g_survivor[id])
				continue;
			
			// If not, turn him into one
			humanme(id, 1, 0, 0, 0, 0, 0)
			iSurvivors++
			
			// Apply survivor health multiplier
			set_user_health(id, floatround(get_user_health(id) * 0.5))
		}
		
		// Turn specified amount of players into Nemesis
		static iNemesis, iMaxNemesis
		iMaxNemesis = 2
		iNemesis = 0
		
		while (iNemesis < iMaxNemesis)
		{
			// Choose random guy
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			
			// Already a survivor or nemesis?
			if (g_survivor[id] || g_nemesis[id])
				continue;
			
			// If not, turn him into one
			zombieme(id, 0, 1, 0, 0, 0, 0, 0)
			iNemesis++
			
			// Apply nemesis health multiplier
			set_user_health(id, floatround(get_user_health(id) * 0.5) * 2)
		}
		
		// iMaxZombies is rounded up, in case there aren't enough players
		iMaxZombies = floatround((iPlayersnum-4)*0.5, floatround_ceil)
		iZombies = 0
		
		// Randomly turn iMaxZombies players into zombies
		while (iZombies < iMaxZombies)
		{
			// Keep looping through all players
			if (++id > g_maxplayers) id = 1
			
			// Dead or already a zombie or survivor
			if (!hub(id, g_data[BIT_ALIVE]) || g_zombie[id] || g_survivor[id])
				continue;
			
			// Random chance
			if (random_num(0, 1))
			{
				// Turn into a zombie
				zombieme(id, 0, 0, 1, 0, 0, 0, 0)
				iZombies++
			}
		}
		
		// Turn the remaining players into humans
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Only those of them who arent zombies or survivor
			if (!hub(id, g_data[BIT_ALIVE]) || g_zombie[id] || g_survivor[id])
				continue;
			
			// Switch to CT
			if (fm_cs_get_user_team(id) != FM_CS_TEAM_CT) // need to change team?
			{
				remove_task(id+TASK_TEAM)
				fm_cs_set_user_team(id, FM_CS_TEAM_CT)
				fm_user_team_update(id)
			}
		}
		
		// Play plague sound
		PlaySound(g_sSoundModePlague[random_num(0, charsmax(g_sSoundModePlague))]);
		
		// Show Plague HUD notice
		set_hudmessage(0, 50, 200, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ PLAGUE !")
	}
	else if((mode == MODE_NONE && random_num(1, EASY_MODS(35)) == 1) || mode == MODE_WESKER)
	{
		set_lights("a");
		
		// Message Mode
		fn_show_mode_msg(MODE_WESKER, g_modes_play[MODE_WESKER], "wesker");
		
		// Wesker Mode
		g_wesker_round = 1
		
		// Choose player randomly?
		if (mode == MODE_NONE)
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
		
		// Remember id for calling our forward later
		forward_id = id
		
		// Turn player into a wesker
		humanme(id, 0, 0, 1, 0, 0, 0)
		
		// Turn the remaining players into zombies
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Not alive
			if (!hub(id, g_data[BIT_ALIVE]))
				continue;
			
			do_random_spawn(id)
			
			// Wesker or already a zombie
			if(g_wesker[id] || g_zombie[id])
				continue;
			
			// Turn into a zombie
			zombieme(id, 0, 0, 1, 0, 0, 0, 0)
		}
		
		// Play wesker sound
		PlaySound(g_sSoundModeSurvivor[random_num(0, charsmax(g_sSoundModeSurvivor))]);
		
		// Show Wesker HUD notice
		set_hudmessage(20, 200, 20, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ %s ES WESKER !", g_playername[forward_id])
	}
	else if((mode == MODE_NONE && random_num(1, 45) == 1 && iPlayersnum >= 10) || mode == MODE_ARMAGEDDON)
	{
		set_lights(g_map_light[0]);
		
		// Message Mode
		fn_show_mode_msg(MODE_ARMAGEDDON, g_modes_play[MODE_ARMAGEDDON], "armageddon");
		
		// Armageddon Mode
		g_armageddon_round = 1
		
		set_cvar_num("pbk_afk_time", 900);
		
		// Make sure there are alive players on both teams (BUGFIX)
		if(!fnGetAliveTs())
		{
			// Move random player to T team
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			remove_task(id+TASK_TEAM)
			fm_cs_set_user_team(id, FM_CS_TEAM_T)
			fm_user_team_update(id)
		}
		else if(!fnGetAliveCTs())
		{
			// Move random player to CT team
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			remove_task(id+TASK_TEAM)
			fm_cs_set_user_team(id, FM_CS_TEAM_CT)
			fm_user_team_update(id)
		}
		
		new i;
		for(i = 1; i <= g_maxplayers; i++)
		{
			// Not alive
			if(!hub(i, g_data[BIT_ALIVE]))
				continue;
			
			ham_strip_weapons(i, "weapon_hegrenade")
			ham_strip_weapons(i, "weapon_flashbang")
			ham_strip_weapons(i, "weapon_smokegrenade")
		}
		
		// Play armageddon sound
		//client_cmd(0, "mp3 play ^"sound/zombie_plague/twd.mp3^"");
		//PlaySound("sound/zombie_plague/twd_2.wav")
		//PlaySound(g_sSoundArmageddonRound[random_num(0, charsmax(g_sSoundArmageddonRound))]);
		
		client_cmd(0, "MP3Volume 1.7");
		client_cmd(0, "mp3 play ^"sound/zombie_plague/twd.mp3^"");
		
		set_task(30.1, "fn_Finish");
		
		// Start armageddon
		set_task(15.0, "fn_start_armageddon_mode")
		
		// Notices
		set_task(0.1, "fn_notice_1")
		set_task(4.99, "fn_notice_2")
		set_task(9.0, "fn_notice_3")
		
		// ScreenFade
		message_begin(MSG_BROADCAST, g_msgScreenFade, _, id)
		write_short(UNIT_SECOND*4) // duration
		write_short(floatround((UNIT_SECOND*15.0)+2.2)) // hold time
		write_short(0x0001) // fade type
		write_byte(0) // red
		write_byte(0) // green
		write_byte(0) // blue
		write_byte(255) // alpha
		message_end()
	}
	else if((mode == MODE_NONE && random_num(1, EASY_MODS(30)) == 1 && iPlayersnum >= 15) || mode == MODE_TRIBAL)
	{
		set_lights(g_map_light[0]);
		
		// Message Mode
		fn_show_mode_msg(MODE_TRIBAL, g_modes_play[MODE_TRIBAL], "tribal");
		
		// Tribal Mode
		g_tribal_round = 1
		g_tribal_power = 1
		
		// Turn specified amount of players into Tribals
		static iTribals, tribal_names[2][32]
		iTribals = 0
		
		while (iTribals < 2)
		{
			if(!g_tribal_acomodado)
				id = fnGetRandomAlive(random_num(1, iPlayersnum))
			else
			{
				if(!hub(g_tribal_id[iTribals], g_data[BIT_ALIVE])) id = fnGetRandomAlive(random_num(1, iPlayersnum))
				else id = g_tribal_id[iTribals];
				
				if(iTribals == 1)
					g_tribal_acomodado = 0;
			}
			
			// Already a tribal?
			if (g_tribal_human[id])
				continue;
			
			// If not, turn him into one
			humanme(id, 0, 0, 0, 1, 0, 0)
			get_user_name(id, tribal_names[iTribals], charsmax(tribal_names[]))
			iTribals++
		}
		
		// Turn the remaining players into zombies
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Not alive
			if (!hub(id, g_data[BIT_ALIVE]))
				continue;
			
			do_random_spawn(id)
			
			// Tribal or already a zombie
			if (g_tribal_human[id] || g_zombie[id])
				continue;
			
			// Turn into a zombie
			zombieme(id, 0, 0, 1, 0, 0, 0, 0)
		}
		
		// Play tribal sound
		PlaySound(g_sSoundModePlague[random_num(0, charsmax(g_sSoundModePlague))]);
		
		// Show Tribal HUD notice
		set_hudmessage(0, 50, 200, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ TRIBAL !^nLos tribales son:^n%s^n%s", tribal_names[0], tribal_names[1])
	}
	else if((mode == MODE_NONE && random_num(1, EASY_MODS(50)) == 3 && iPlayersnum >= 20) || mode == MODE_FP)
	{
		set_lights(g_map_light[0]);
		
		// Message Mode
		fn_show_mode_msg(MODE_FP, g_modes_play[MODE_FP], "fleshpound");
		
		g_fp_min = 0;
		set_task(60.0, "osiduv8s");
		
		// Tribal Mode
		g_fp_round = 1
		
		if(!g_fp_acomodado)
		{
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			
			g_fp_id = id;
			
			zombieme(id, 0, 0, 0, 0, 0, 0, 1)
		}
		else
		{
			if(!hub(g_fp_id, g_data[BIT_ALIVE])) id = fnGetRandomAlive(random_num(1, iPlayersnum))
			else id = g_fp_id;
			
			zombieme(id, 0, 0, 0, 0, 0, 0, 1)
		}
		
		// Turn specified amount of players into Tribals
		iTribals = 0
		
		while (iTribals < 2)
		{
			if(!g_fp_acomodado)
				id = fnGetRandomAlive(random_num(1, iPlayersnum))
			else
			{
				if(!hub(g_tribal_id[iTribals], g_data[BIT_ALIVE])) id = fnGetRandomAlive(random_num(1, iPlayersnum))
				else id = g_tribal_id[iTribals];
			}
			
			// Already a tribal?
			if (g_tribal_human[id] || g_fp[id])
				continue;
			
			// If not, turn him into one
			humanme(id, 0, 0, 0, 1, 0, 0)
			get_user_name(id, tribal_names[iTribals], charsmax(tribal_names[]))
			iTribals++
		}
		
		g_fp_acomodado = 0;
		
		// Turn the remaining players into zombies
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Not alive
			if (!hub(id, g_data[BIT_ALIVE]))
				continue;
			
			do_random_spawn(id)
			
			// Tribal or already a zombie
			if (g_tribal_human[id] || g_zombie[id] || g_fp[id])
				continue;
			
			// Turn into a zombie
			humanme(id, 0, 0, 0, 0, 0, 0)
		}
		
		// Play tribal sound
		PlaySound(g_sSoundModePlague[random_num(0, charsmax(g_sSoundModePlague))]);
		
		// Show Tribal HUD notice
		set_hudmessage(255, 20, 20, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ %s es un FleshPound !^n^nLos tribales son:^n%s^n%s", g_playername[g_fp_id], tribal_names[0], tribal_names[1])
		
		CC(0, "!g[ZP]!y Objetivo Humano: !gDefender a los Tribales!y")
		CC(0, "!g[ZP]!y Objetivo FleshPound: !gMatar a los Tribales!y")
	}
	else if((mode == MODE_NONE && random_num(1, EASY_MODS(30)) == 1 && iPlayersnum >= 20) || mode == MODE_ALVSPRED)
	{
		set_lights("a");
		
		// Message Mode
		fn_show_mode_msg(MODE_ALVSPRED, g_modes_play[MODE_ALVSPRED], "alien vs. depredador");
		
		// Alien Vs Predator Mode
		g_alvspre_round = 1
		
		// Make sure there are alive players on both teams (BUGFIX)
		if (!fnGetAliveTs())
		{
			// Move random player to T team
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			remove_task(id+TASK_TEAM)
			fm_cs_set_user_team(id, FM_CS_TEAM_T)
			fm_user_team_update(id)
		}
		else if (!fnGetAliveCTs())
		{
			// Move random player to CT team
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
			remove_task(id+TASK_TEAM)
			fm_cs_set_user_team(id, FM_CS_TEAM_CT)
			fm_user_team_update(id)
		}
		
		// Turn specified amount of players into Alien and Predator
		static iMonsters, monster_names[2][32]
		iMonsters = 0
		
		while (iMonsters < 2)
		{
			if(!g_alvspred_acomodado)
				id = fnGetRandomAlive(random_num(1, iPlayersnum))
			else
			{
				if(!hub(g_alvspred_id[iMonsters], g_data[BIT_ALIVE])) id = fnGetRandomAlive(random_num(1, iPlayersnum))
				else id = g_alvspred_id[iMonsters];
				
				if(iMonsters == 1)
					g_alvspred_acomodado = 0;
			}
			
			if(g_alien[id])
				continue;
			
			if(!iMonsters)
			{
				// If not, turn him into one
				zombieme(id, 0, 0, 0, 0, 1, 0, 0)
				get_user_name(id, monster_names[iMonsters], charsmax(monster_names[]))
			}
			else
			{
				// If not, turn him into one
				humanme(id, 0, 0, 0, 0, 1, 0)
				get_user_name(id, monster_names[iMonsters], charsmax(monster_names[]))
			}
			
			iMonsters++
		}
		
		// Turn every T into a zombie
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Not alive
			if (!hub(id, g_data[BIT_ALIVE]))
				continue;
			
			// Not a Terrorist
			if (fm_cs_get_user_team(id) != FM_CS_TEAM_T)
			{
				if(!g_predator[id]) set_user_health(id, 800)
				continue;
			}
			
			// Already a alien?
			if (g_alien[id])
				continue;
			
			// Turn into a zombie
			zombieme(id, 0, 0, 1, 0, 0, 0, 0)
		}
		
		// Play Alien Vs Predator sound
		PlaySound(g_sSoundModePlague[random_num(0, charsmax(g_sSoundModePlague))]);
		
		// Show Alien Vs Predator HUD notice
		set_hudmessage(255, 255, 0, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
		ShowSyncHudMsg(0, g_MsgSync, "¡ ALIEN vs DEPREDADOR !^nAlien: %s^nDepredador: %s", monster_names[0], monster_names[1])
	}
	else
	{
		// Single Infection Mode or Nemesis Mode
		
		// Choose player randomly?
		if (mode == MODE_NONE)
			id = fnGetRandomAlive(random_num(1, iPlayersnum))
		
		// Remember id for calling our forward later
		forward_id = id
		
		if ((mode == MODE_NONE && random_num(1, EASY_MODS(20)) == 1 && iPlayersnum >= 5) || mode == MODE_NEMESIS)
		{
			set_lights("a");
			
			// Message Mode
			fn_show_mode_msg(MODE_NEMESIS, g_modes_play[MODE_NEMESIS], "nemesis");
			
			if(fnGetPlaying() >= 20)
			{
				gl_time_nem = 1;
				
				remove_task(TASK_SNIPER_ROUND)
				set_task(60.0, "fnDeactivateAchievement", TASK_SNIPER_ROUND);
			}
			
			// Nemesis Mode
			g_nemround = 1
			
			// Turn player into nemesis
			zombieme(id, 0, 1, 0, 0, 0, 0, 0)
		}
		else
		{
			set_lights(g_map_light[0]);
			
			// Message Mode
			fn_show_mode_msg(MODE_INFECTION, g_modes_play[MODE_INFECTION], "primer zombie");
			
			// Turn player into the first zombie
			zombieme(id, 0, 0, 0, 0, 0, 0, 0)
		}
		
		// Remaining players should be humans (CTs)
		for (id = 1; id <= g_maxplayers; id++)
		{
			// Not alive
			if (!hub(id, g_data[BIT_ALIVE]))
				continue;
			
			// First zombie/nemesis
			if (g_zombie[id])
				continue;
			
			// Switch to CT
			if (fm_cs_get_user_team(id) != FM_CS_TEAM_CT) // need to change team?
			{
				remove_task(id+TASK_TEAM)
				fm_cs_set_user_team(id, FM_CS_TEAM_CT)
				fm_user_team_update(id)
			}
		}
		
		if (g_nemround)
		{
			// Play Nemesis sound
			PlaySound(g_sSoundModeNemesis[random_num(0, charsmax(g_sSoundModeNemesis))]);
			
			set_hudmessage(255, 20, 20, HUD_EVENT_X, HUD_EVENT_Y, 1, 0.0, 5.0, 1.0, 1.0, -1)
			
			// Show Nemesis HUD notice
			if(random_num(0, 1))
			{
				g_hardmode = 1;
				//util_p_attach(forward_id, g_headspr, 32767);
				
				ShowSyncHudMsg(0, g_MsgSync, "¡ %s ES NEMESIS !^n^nHard Mode:^nEl nemesis recibe daño x2 en la cabeza", g_playername[forward_id])
			}
			else ShowSyncHudMsg(0, g_MsgSync, "¡ %s ES NEMESIS !", g_playername[forward_id])
		}
		else
		{
			// Show First Zombie HUD notice
			set_hudmessage(255, 0, 0, HUD_EVENT_X, HUD_EVENT_Y, 0, 0.0, 5.0, 1.0, 1.0, -1)
			ShowSyncHudMsg(0, g_MsgSync, "¡ %s ES EL PRIMER ZOMBIE !", g_playername[forward_id])
		}
	}
}

// Zombie Me Function (player id, infector, turn into a nemesis, silent mode, deathmsg and rewards)
zombieme(id, infector, nemesis, silentmode, rewards, alien, annihilator, fp) // zombieme_f
{
	if(!is_user_alive(id))
		return;
	
	if(is_player_stuck(id, 1))
	{
		do_random_spawn(id)
		CC(id, "!g[ZP]!y Has sido teletransportado debido a que te habías trabado con un humano")
	}
	
	fn_check_logros(id, infector, 0, 1, 0)
	
	// Set selected zombie class
	g_zombieclass[id] = g_zombieclassnext[id]
	
	// Way to go...
	g_zombie[id] = 1
	g_nemesis[id] = 0
	g_survivor[id] = 0
	g_wesker[id] = 0
	g_tribal_human[id] = 0
	g_alien[id] = 0
	g_predator[id] = 0
	g_annihilator[id] = 0
	g_firstzombie[id] = 0
	g_sniper[id] = 0
	g_mode[id] = NONE
	
	// Remove spawn protection (bugfix)
	g_nodamage[id] = 0
	entity_set_int(id, EV_INT_effects, entity_get_int(id, EV_INT_effects) &~ EF_NODRAW)
	
	// Reset burning duration counter (bugfix)
	g_burning_duration[id] = 0
	
	/*if(HAT_ITEM_SET != g_hat_equip[id])
	{
		fn_set_hat(id, g_hat_mdl[HAT_ITEM_SET])
		g_hat_equip[id] = HAT_ITEM_SET;
	}*/
	
	// Show deathmsg and reward infector?
	if(rewards && infector)
	{
		// Send death notice and fix the "dead" attrib on scoreboard
		SendDeathMsg(infector, id)
		FixDeadAttrib(id)
		
		// Reward health and ammo packs
		new rew = (g_level[id] + ((g_range[id]+1) * 200));
		if(rew > 15000) rew = 15000;
		
		update_xp(infector, random_num((21 + rew), (33 + rew)), 3)
		set_user_health(infector, get_user_health(infector) + 600 + rew)
		
		// -- Save Stats --
		g_stats[infector][INFECTS][DONE]++
		g_stats[id][INFECTS][TAKEN]++
		
		if(fnGetPlaying() >= 20)
			g_infect_human[infector]++;
		
		if(rewards != 2)
		{
		#if defined EVENT_SEMANA_INFECCION
			++maxInfects[infector];
			++infectsInRound[infector];
			++infectsCombo[infector];
			
			remove_task(infector + TASK_FINISHCOMBO_INFECT);
			set_task(7.0, "fnFinishCombo_Zombie", infector + TASK_FINISHCOMBO_INFECT)
		#endif
			
			if(fnGetAlive() >= 20)
			{
				if(!gl_infect_users[infector][id])
					gl_infects_round[infector]++
				
				gl_infect_users[infector][id] = 1;
			}
			
			if(gl_infects_no_dmg[infector] != -1)
			{
				gl_infects_no_dmg[infector]++
				if(gl_infects_no_dmg[infector] >= 5) fn_update_logro(infector, LOGRO_ZOMBIE, YO_NO_FUI)
			}
			
			if(gl_infects_round[infector] == 5 && !g_logro[infector][LOGRO_ZOMBIE][VIRUS]) fn_PrintCenter(infector, "Logro: VIRUS^n^n5 INFECCIONES!");
			else if(gl_infects_round[infector] == 10 && !g_logro[infector][LOGRO_ZOMBIE][VIRUS]) fn_PrintCenter(infector, "Logro: VIRUS^n^n10 INFECCIONES!");
			else if(gl_infects_round[infector] == 15 && !g_logro[infector][LOGRO_ZOMBIE][VIRUS]) fn_PrintCenter(infector, "Logro: VIRUS^n^n15 INFECCIONES!");
			else if(gl_infects_round[infector] >= 20 && !g_logro[infector][LOGRO_ZOMBIE][VIRUS]) fn_update_logro(infector, LOGRO_ZOMBIE, VIRUS)
			
			if(gl_infects_round[infector] >= 24) fn_update_logro(infector, LOGRO_SECRET, T_VIRUS)
			
			if(gl_fz_in_round[infector] >= 3 && gl_infects_round[infector] == 5)
				fn_update_logro(infector, LOGRO_SECRET, RAPIDO_Y_FURIOSO);
		}
		
		// Remove Combo Human
		if(task_exists(id+TASK_FINISHCOMBO))
		{
			remove_task(id+TASK_FINISHCOMBO)
			set_task(0.1, "fnFinishCombo_Human", id+TASK_FINISHCOMBO)
		}
	}
	
	// Cache speed and name for player's class
	g_zombie_spd[id] = amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_SPEED, float(ArrayGetCell(g_zclass_spd, g_zombieclass[id])), 0, 0)
	g_zombie_dmg[id] = amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_DAMAGE, Float:ArrayGetCell(g_zclass_dmg, g_zombieclass[id]), 0, 0)
	ArrayGetString(g_zclass_name, g_zombieclass[id], g_zombie_classname[id], charsmax(g_zombie_classname[]))
	
	remove_task(id+TASK_AURA)
	
	// Set zombie attributes based on the mode
	if(!silentmode)
	{
		if (nemesis)
		{
			// Nemesis
			g_nemesis[id] = 1
			
			// Set health
			static health, percent
			if(!g_armageddon_round && !g_plagueround)
			{
				health = ArrayGetCell(g_zclass_hp, 0) * fnGetAlive()
				percent = health + ((health * (g_hab[id][HAB_NEM][NEM_HP] * 10)) / 100)
				
				set_user_health(id, percent * 2)
			}
			else
			{
				health = 92000 + ArrayGetCell(g_zclass_hp, 0)
				percent = health + ((health * (g_hab[id][HAB_NEM][NEM_HP] * 100)) / 100)
				
				set_user_health(id, percent * 2)
			}
			
			g_dmg_nem[id] = 30 * g_hab[id][HAB_NEM][NEM_DMG]
			
			// Set LJ
			g_longjump[id] = 1
			give_item(id, "item_longjump")
			
			if(!g_armageddon_round && !g_plagueround && fnGetAlive() > 8)
			{
				g_bazooka[id] = 1
				CC(id, "!g[ZP]!y Recordá que apretando !gel 1!y, sacas una bazooka");
			}
			
			// Set gravity, if frozen set the restore gravity value instead
			if (!g_frozen[id]) set_user_gravity(id, 0.5)
			g_frozen_gravity[id] = 0.5
			
			// Set nemesis maxspeed
			ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
			
			// Mode
			g_mode[id] = NEMESIS
		}
		else if (alien)
		{
			// Alien
			g_alien[id] = 1
			
			// Set health
			set_user_health(id, 350000*2)
			
			// Set LJ
			g_longjump[id] = 1
			give_item(id, "item_longjump")
			
			g_alien_power = 0;
			
			CC(id, "!g[ZP]!y Para activar el poder, aprieta la !gletra G!y");
			
			// Set gravity, if frozen set the restore gravity value instead
			if (!g_frozen[id]) set_user_gravity(id, 0.4)
			g_frozen_gravity[id] = 0.4
			
			// Set nemesis maxspeed
			ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
			
			// Mode
			g_mode[id] = ALIEN
		}
		else if (annihilator)
		{
			// Alien
			g_annihilator[id] = 1
			
			// Set health
			set_user_health(id, 8000000*2)
			
			// Set LJ
			g_longjump[id] = 1
			give_item(id, "item_longjump")
			
			// Set Bazooka
			g_bazooka[id] = 5
			CC(id, "!g[ZP]!y Recordá que apretando !gdos veces el 3!y, sacas una bazooka y !gcon el 1 una MAC-10!y");
			
			// Set gravity, if frozen set the restore gravity value instead
			if (!g_frozen[id]) set_user_gravity(id, 0.4)
			g_frozen_gravity[id] = 0.4
			
			// Set nemesis maxspeed
			ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
			
			// Mode
			g_mode[id] = ANNIHILATOR
		}
		else if (fp)
		{
			// Alien
			g_fp[id] = 1
			g_fp_power = 1;
			
			// Set health
			set_user_health(id, 2000000*2)
			
			// Set Bazooka
			CC(id, "!g[ZP]!y Recordá que apretando la !gletra E (+use)!y activas tu poder");
			
			// Set gravity, if frozen set the restore gravity value instead
			if (!g_frozen[id]) set_user_gravity(id, 0.5)
			g_frozen_gravity[id] = 0.5
			
			// Set nemesis maxspeed
			ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
		}
		else if (fnGetZombies() == 1)
		{
			// First zombie
			g_firstzombie[id] = 1
			
			// Set health
			set_user_health(id, amount_upgrade(id, HAB_ZOMBIE, ZOMBIE_HP, ArrayGetCell(g_zclass_hp, g_zombieclass[id]) * 2, 0)*2)
			
			// Set LJ
			g_longjump[id] = 1
			give_item(id, "item_longjump")
			
			// Set gravity, if frozen set the restore gravity value instead
			if (!g_frozen[id]) set_user_gravity(id, amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_GRAVITY, Float:ArrayGetCell(g_zclass_grav, g_zombieclass[id]), 0, 0))
			g_frozen_gravity[id] = amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_GRAVITY, Float:ArrayGetCell(g_zclass_grav, g_zombieclass[id]), 0, 0)
			
			// Set zombie maxspeed
			ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
			
			// Infection sound
			//emit_sound(id, CHAN_VOICE, g_sSoundZombieInfect[random_num(0, charsmax(g_sSoundZombieInfect))], 1.0, ATTN_NORM, 0, PITCH_NORM)
		}
		else
		{
			// Infected by someone
			
			// Set health
			/*if(g_zr_pj[id] == 1006)
				g_erik_health = amount_upgrade(id, HAB_ZOMBIE, ZOMBIE_HP, ArrayGetCell(g_zclass_hp, g_zombieclass[id]), 0)*/
			
			new iSum = 0;
			if(g_dead_health[id] > 0)
				iSum = (amount_upgrade(id, HAB_ZOMBIE, ZOMBIE_HP, ArrayGetCell(g_zclass_hp, g_zombieclass[id]), 0) * (g_dead_health[id] * 5)) / 100
			
			set_user_health(id, (amount_upgrade(id, HAB_ZOMBIE, ZOMBIE_HP, ArrayGetCell(g_zclass_hp, g_zombieclass[id]), 0) + iSum) * 2)
			
			if(iSum > 0)
				CC(id, "!g[ZP]!y Ahora tenés !g%d%% más de vida!y (hasta que finalice la ronda!)", (g_dead_health[id] * 5))
			
			// Set gravity, if frozen set the restore gravity value instead
			if (!g_frozen[id]) set_user_gravity(id, amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_GRAVITY, Float:ArrayGetCell(g_zclass_grav, g_zombieclass[id]), 0, 0))
			g_frozen_gravity[id] = amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_GRAVITY, Float:ArrayGetCell(g_zclass_grav, g_zombieclass[id]), 0, 0)
			
			if(g_block_habs && !check_access(id, 1))
			{
				set_user_gravity(id, 1.0)
				g_zombie_spd[id] = 240.0
			}
			
			// Set zombie maxspeed
			ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
			
			// Infection sound
			emit_sound(id, CHAN_VOICE, g_sSoundZombieInfect[random_num(0, charsmax(g_sSoundZombieInfect))], 1.0, ATTN_NORM, 0, PITCH_NORM)
		}
	}
	else
	{
		// Silent mode, no HUD messages, no infection sounds
		
		// Set health
		new iSum = 0;
		if(g_dead_health[id] > 0)
			iSum = (amount_upgrade(id, HAB_ZOMBIE, ZOMBIE_HP, ArrayGetCell(g_zclass_hp, g_zombieclass[id]), 0) * (g_dead_health[id] * 5)) / 100
		
		set_user_health(id, (amount_upgrade(id, HAB_ZOMBIE, ZOMBIE_HP, ArrayGetCell(g_zclass_hp, g_zombieclass[id]), 0) + iSum) * 2)
		
		if(iSum > 0)
			CC(id, "!g[ZP]!y Ahora tenés !g%d%% más de vida!y (hasta que finalice la ronda!)", (g_dead_health[id] * 5))
		
		// Set gravity, if frozen set the restore gravity value instead
		if (!g_frozen[id]) set_user_gravity(id, amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_GRAVITY, Float:ArrayGetCell(g_zclass_grav, g_zombieclass[id]), 0, 0))
		g_frozen_gravity[id] = amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_GRAVITY, Float:ArrayGetCell(g_zclass_grav, g_zombieclass[id]), 0, 0)
		
		if(g_block_habs && !check_access(id, 1))
		{
			set_user_gravity(id, 1.0)
			g_zombie_spd[id] = 240.0
		}
		
		// Set zombie maxspeed
		ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
	}
	
	/*if(g_zr_pj[id] == 1006)
		g_one_time_erik = 0;*/
	
	// Remove previous tasks
	remove_task(id+TASK_MODEL)
	remove_task(id+TASK_BLOOD)
	remove_task(id+TASK_BURN)
	
	// Switch to T
	if (fm_cs_get_user_team(id) != FM_CS_TEAM_T) // need to change team?
	{
		remove_task(id+TASK_TEAM)
		fm_cs_set_user_team(id, FM_CS_TEAM_T)
		fm_user_team_update(id)
	}
	
	// Custom models stuff
	static currentmodel[32], tempmodel[32], already_has_model
	already_has_model = 0
	
	// Get current model for comparing it with the current one
	fm_cs_get_user_model(id, currentmodel, charsmax(currentmodel))
	
	// Set the right model, after checking that we don't already have it
	if (g_nemesis[id])
	{
		if(equal(currentmodel, g_sModelNemesis))
			already_has_model = 1;
		
		if(!already_has_model)
			copy(g_playermodel[id], charsmax(g_playermodel[]), g_sModelNemesis);
	}
	else if(g_annihilator[id])
	{
		if(equal(currentmodel, g_sModelAnnihilator))
			already_has_model = 1;
		
		if(!already_has_model)
			copy(g_playermodel[id], charsmax(g_playermodel[]), g_sModelAnnihilator);
	}
	else if(g_fp[id])
	{
		if(equal(currentmodel, g_sModelFP))
			already_has_model = 1;
		
		if(!already_has_model)
			copy(g_playermodel[id], charsmax(g_playermodel[]), g_sModelFP);
	}

	else if(g_alien[id])
	{
		if(equal(currentmodel, g_sModelAlien))
			already_has_model = 1;
		
		if(!already_has_model)
			copy(g_playermodel[id], charsmax(g_playermodel[]), g_sModelAlien);
	}
	else
	{
		//if(g_zr_pj[id] != 1006)
		ArrayGetString(g_zclass_playermodel, g_zombieclass[id], tempmodel, charsmax(tempmodel))
		/*else
			formatex(tempmodel, charsmax(tempmodel), "tcs_zombie_199")*/
		
		if (equal(currentmodel, tempmodel)) already_has_model = 1
		
		if (!already_has_model)
		{
			//if(g_zr_pj[id] != 1006)
			ArrayGetString(g_zclass_playermodel, g_zombieclass[id], g_playermodel[id], charsmax(g_playermodel[]))
			/*else
				formatex(g_playermodel[id], charsmax(g_playermodel[]), "tcs_zombie_199")*/
		}
		
		if(g_firstzombie[id])
		{
			g_nodamage[id] = 1
			set_task(0.1, "zombie_aura", id+TASK_AURA, _, _, "b")
			set_task(7.5, "madness_over", id+TASK_BLOOD)
			
			emit_sound(id, CHAN_VOICE, g_sSoundZombieMadness[random_num(0, charsmax(g_sSoundZombieMadness))], 1.0, ATTN_NORM, 0, PITCH_HIGH)
			
			//g_bubble_eff[id] = 0
		}
	}
	
	// Need to change the model?
	if (!already_has_model)
	{
		// An additional delay is offset at round start
		// since SVC_BAD is more likely to be triggered there
		if(g_newround) set_task(5.0 * MODELS_CHANGE_DELAY, "fm_user_model_update", id+TASK_MODEL)
		else fm_user_model_update(id+TASK_MODEL)
	}
	
	// Nemesis glow / remove glow, unless frozen
	if (!g_frozen[id])
	{
		if (g_nemesis[id]) set_user_rendering(id, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 25)
		else if (g_annihilator[id]) set_user_rendering(id, kRenderFxGlowShell, 255, 255, 255, kRenderNormal, 25)
		else set_user_rendering(id)
	}
	
	// Remove any zoom (bugfix)
	cs_set_user_zoom(id, CS_RESET_ZOOM, 1)
	
	// Remove armor
	set_user_armor(id, 0)
	
	// Drop weapons when infected
	drop_weapons(id, 1)
	drop_weapons(id, 2)
	
	// Strip zombies from guns and give them a knife
	strip_user_weapons(id)
	give_item(id, "weapon_knife")
	
	fnRemoveWeaponsEdit(id, PRIMARY_WEAPON)
	fnRemoveWeaponsEdit(id, SECONDARY_WEAPON)
	
	// Fancy effects
	set_task(0.1, "infection_effects", id)
	
	if((g_nemesis[id] || g_annihilator[id]) && !g_alien[id] && !g_fp[id])
	{
		if(g_nemesis[id])
		{
			if(!g_armageddon_round && !g_plagueround && fnGetAlive() > 8)
			{
				give_item(id, "weapon_sg550")
				cs_set_user_bpammo(id, CSW_SG550, 0)
				cs_set_weapon_ammo(fm_find_ent_by_owner(-1, "weapon_sg550", id), 0)
				
				g_currentweapon[id] = CSW_KNIFE
				engclient_cmd(id, "weapon_knife")
			}
		}
		else
		{
			give_item(id, "weapon_mac10")
			ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[cs_weapon_name_to_id("weapon_mac10")], AMMOTYPE[cs_weapon_name_to_id("weapon_mac10")], MAXBPAMMO[cs_weapon_name_to_id("weapon_mac10")])
			
			give_item(id, "weapon_sg550")
			cs_set_user_bpammo(id, CSW_SG550, 0)
			cs_set_weapon_ammo(fm_find_ent_by_owner(-1, "weapon_sg550", id), 0)
			
			g_currentweapon[id] = CSW_KNIFE
			engclient_cmd(id, "weapon_knife")
		}
		
		// Nemesis aura task
		if(!g_armageddon_round) set_task(0.1, "zombie_aura", id+TASK_AURA, _, _, "b")
	}
	else if(g_fp[id])
		set_task(0.1, "zombie_aura", id+TASK_AURA, _, _, "b")
	
	// Remove CS nightvision if player owns one (bugfix)
	if (cs_get_user_nvg(id))
	{
		cs_set_user_nvg(id, 0)
		remove_task(id+TASK_NVISION)
	}
	
	g_nvision[id] = 1
	g_nvisionenabled[id] = 1
	
	remove_task(id+TASK_NVISION)
	set_task(0.1, "set_user_nvision", id+TASK_NVISION, _, _, "b")
	
	message_begin(MSG_ONE, g_msgSetFOV, _, id);
	write_byte(110);
	message_end();
	
	/*if(!g_nemesis[id] && !g_alien[id] && !g_annihilator[id])
		set_task(random_float(137.0, 219.0), "zombie_play_idle", id+TASK_BLOOD, _, _, "b")*/
	
	turn_off_flashlight(id)
	
	if(g_block_weapons && !check_access(id, 1))
		strip_user_weapons(id);
	
	fnCheckLastZombie()
}

// Function Human Me (player id, turn into a survivor, silent mode)
humanme(id, survivor, silentmode, wesker, tribal, predator, sniper) // humanme_f
{
	if(!is_user_alive(id))
		return;
	
	// Remove previous tasks
	remove_task(id+TASK_MODEL)
	remove_task(id+TASK_BLOOD)
	remove_task(id+TASK_AURA)
	remove_task(id+TASK_BURN)
	remove_task(id+TASK_NVISION)
	
	// Reset some vars
	g_zombie[id] = 0
	g_nemesis[id] = 0
	g_survivor[id] = 0
	g_wesker[id] = 0
	g_tribal_human[id] = 0
	g_alien[id] = 0
	g_predator[id] = 0
	g_annihilator[id] = 0
	g_sniper[id] = 0
	g_firstzombie[id] = 0
	g_buy[id] = 0
	g_mode[id] = NONE
	//g_bubble_eff[id] = 0;
	
	if(g_frozen[id])
	{
		remove_task(id+TASK_FROZEN)
		remove_task(id+TASK_SLOWDOWN)
		
		remove_freeze(id + TASK_FROZEN)
		remove_slowdown(id + TASK_SLOWDOWN)
	}
	else if(g_slowdown[id])
	{
		remove_task(id+TASK_SLOWDOWN)
		remove_slowdown(id + TASK_SLOWDOWN)
	}
	
	// Remove spawn protection (bugfix)
	g_nodamage[id] = 0
	entity_set_int(id, EV_INT_effects, entity_get_int(id, EV_INT_effects) &~ EF_NODRAW)
	
	// Reset burning duration counter (bugfix)
	g_burning_duration[id] = 0
	
	// Remove CS nightvision if player owns one (bugfix)
	if (cs_get_user_nvg(id))
	{
		cs_set_user_nvg(id, 0)
		remove_task(id+TASK_NVISION)
	}
	
	// Drop previous weapons
	drop_weapons(id, 1)
	drop_weapons(id, 2)
	
	// Strip off from weapons
	strip_user_weapons(id)
	give_item(id, "weapon_knife")
	
	fnRemoveWeaponsEdit(id, PRIMARY_WEAPON)
	fnRemoveWeaponsEdit(id, SECONDARY_WEAPON)
	
	/*if(HAT_ITEM_SET != g_hat_equip[id])
	{
		fn_set_hat(id, g_hat_mdl[HAT_ITEM_SET])
		g_hat_equip[id] = HAT_ITEM_SET;
	}*/
	
	// Set human attributes based on the mode
	if(survivor)
	{
		// Survivor
		g_survivor[id] = 1
		
		// Set health
		if(!g_armageddon_round && !g_plagueround) set_user_health(id, 100 * (fnGetAlive() + g_hab[id][HAB_SURV][SURV_HP]))
		else set_user_health(id, 10000 + (100 * (fnGetAlive() + g_hab[id][HAB_SURV][SURV_HP])))
		
		// Set gravity, if frozen set the restore gravity value instead
		if (!g_frozen[id]) set_user_gravity(id, 0.9)
		g_frozen_gravity[id] = 0.9
		
		// Set survivor maxspeed
		ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
		
		// Give survivor his own weapon
		give_item(id, "weapon_mp5navy")
		ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[cs_weapon_name_to_id("weapon_mp5navy")], AMMOTYPE[cs_weapon_name_to_id("weapon_mp5navy")], MAXBPAMMO[cs_weapon_name_to_id("weapon_mp5navy")])
		
		// Turn off his flashlight
		turn_off_flashlight(id)
		
		// Give the survivor a bright light
		if(!g_armageddon_round && !g_plagueround)
		{
			if(!g_hab[id][HAB_SURV][SURV_EXTRA_BOMB])
			{
				give_item(id, "weapon_hegrenade")
				g_bomb_aniq[id] = 1
			}
			else
			{
				give_item(id, "weapon_hegrenade")
				cs_set_user_bpammo(id, CSW_HEGRENADE, 2);
				g_bomb_aniq[id] = 2;
			}
			
			set_task(0.1, "human_aura", id+TASK_AURA, _, _, "b")
			
			CC(id, "!g[ZP]!y Recordá que tenes una !gbomba de aniquilación e inmunidad!y que podes activar presionando el clic derecho")
		}
		
		// Mode
		g_mode[id] = SURVIVOR
	}
	else if(wesker)
	{
		// Wesker
		g_wesker[id] = 1
		g_wesker_laser[id] = 3
		
		// Set health
		gl_wesker_health = 120 * fnGetAlive()
		set_user_health(id, gl_wesker_health)
		set_user_armor(id, 150)
		
		// Set gravity, if frozen set the restore gravity value instead
		if (!g_frozen[id]) set_user_gravity(id, 0.6)
		g_frozen_gravity[id] = 0.6
		
		// Set wesker maxspeed
		ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
		
		// Give wesker his own weapon
		give_item(id, "weapon_deagle")
		ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[cs_weapon_name_to_id("weapon_deagle")], AMMOTYPE[cs_weapon_name_to_id("weapon_deagle")], MAXBPAMMO[cs_weapon_name_to_id("weapon_deagle")])
		
		give_item(id, "weapon_flashbang")
		
		CC(id, "!g[ZP]!y Recordá que tenes !g3 LASER!y que podes disparar presionando el clic derecho")
		
		// Turn off his flashlight
		turn_off_flashlight(id)
		
		// Give the wesker a bright light
		set_task(0.1, "human_aura", id+TASK_AURA, _, _, "b")
		
		// Mode
		g_mode[id] = WESKER
	}
	else if(tribal)
	{
		// Tribal
		g_tribal_human[id] = 1
		
		// Set health
		set_user_health(id, 2000)
		
		// Set gravity, if frozen set the restore gravity value instead
		if (!g_frozen[id]) set_user_gravity(id, 0.5)
		g_frozen_gravity[id] = 0.5
		
		// Set wesker maxspeed
		ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
		
		// Give wesker his own weapon
		if(random_num(0, 1))
		{
			give_item(id, "weapon_ak47")
			ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[cs_weapon_name_to_id("weapon_ak47")], AMMOTYPE[cs_weapon_name_to_id("weapon_ak47")], MAXBPAMMO[cs_weapon_name_to_id("weapon_ak47")])
		}
		else
		{
			give_item(id, "weapon_m4a1")
			ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[cs_weapon_name_to_id("weapon_m4a1")], AMMOTYPE[cs_weapon_name_to_id("weapon_m4a1")], MAXBPAMMO[cs_weapon_name_to_id("weapon_m4a1")])
		}
		
		CC(id, "!g[ZP]!y Para activar el poder tribal !gdeben estar juntos!y, !gsacar el cuchillo!y y presionar la !gletra E!y")
		
		// Mode
		g_mode[id] = TRIBAL
	}
	else if(predator)
	{
		// Predator
		g_predator[id] = 1
		
		// Power
		g_power_invis = 0;
		
		// Set health
		set_user_health(id, 10000)
		
		// Set gravity, if frozen set the restore gravity value instead
		if (!g_frozen[id]) set_user_gravity(id, 0.6)
		g_frozen_gravity[id] = 0.6
		
		// Set predator maxspeed
		ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
		
		// Give predator his own weapon
		give_item(id, "weapon_m4a1")
		ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[cs_weapon_name_to_id("weapon_m4a1")], AMMOTYPE[cs_weapon_name_to_id("weapon_m4a1")], MAXBPAMMO[cs_weapon_name_to_id("weapon_m4a1")])
		
		// Turn off his flashlight
		turn_off_flashlight(id)
		
		// Give the survivor a bright light
		set_task(0.1, "human_aura", id+TASK_AURA, _, _, "b")
		
		CC(id, "!g[ZP]!y Para activar tu !ginvisibilidad!y, presiona la !gletra E!y")
		
		// Mode
		g_mode[id] = PREDATOR
	}
	else if(sniper)
	{
		// Sniper
		g_sniper[id] = 1
		
		// Set health
		set_user_health(id, 200 * fnGetAlive())
		set_user_armor(id, 100)
		
		// Set gravity, if frozen set the restore gravity value instead
		if (!g_frozen[id]) set_user_gravity(id, 0.6)
		g_frozen_gravity[id] = 0.6
		
		// Set Sniper maxspeed
		ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
		
		// Give Sniper his own weapon
		give_item(id, "weapon_awp")
		ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[cs_weapon_name_to_id("weapon_awp")], AMMOTYPE[cs_weapon_name_to_id("weapon_awp")], MAXBPAMMO[cs_weapon_name_to_id("weapon_awp")])
		
		CC(id, "!g[ZP]!y Recordá que tenes una !gSUPER VELOCIDAD!y que podes activar con la !gletra E!y")
		
		// Turn off his flashlight
		turn_off_flashlight(id)
		
		// Give the Sniper a bright light
		set_task(0.1, "human_aura", id+TASK_AURA, _, _, "b")
		
		gl_kill_sniper = 0;
		
		// Mode
		g_mode[id] = SNIPER
	}
	else
	{
		// Human taking an antidote
		
		// Set selected human class
		g_humanclass[id] = g_humanclassnext[id]
		
		// Get human name
		ArrayGetString(g_hclass_name, g_humanclass[id], g_human_classname[id], charsmax(g_human_classname[]))
		
		// Set health, speed, damage and armor
		if(!g_fp_round) set_user_health(id, amount_upgrade(id, HAB_HUMAN, HUMAN_HP, ArrayGetCell(g_hclass_hp, g_humanclass[id]), 0))
		else set_user_health(id, 2500)
		g_human_spd[id] = amount_upgrade_f(id, HAB_HUMAN, HUMAN_SPEED, float(ArrayGetCell(g_hclass_spd, g_humanclass[id])), 0, 0)
		g_human_dmg[id] = amount_upgrade_f(id, HAB_HUMAN, HUMAN_DAMAGE, Float:ArrayGetCell(g_hclass_dmg, g_humanclass[id]), 0, 0)
		set_user_armor(id, amount_upgrade(id, HAB_HUMAN, HUMAN_ARMOR, 0, 0))
		
		// Set gravity, if frozen set the restore gravity value instead
		if (!g_frozen[id]) set_user_gravity(id, amount_upgrade_f(id, HAB_HUMAN, HUMAN_GRAVITY, Float:ArrayGetCell(g_hclass_grav, g_humanclass[id]), 0, 0))
		g_frozen_gravity[id] = amount_upgrade_f(id, HAB_HUMAN, HUMAN_GRAVITY, Float:ArrayGetCell(g_hclass_grav, g_humanclass[id]), 0, 0)
		
		if(g_block_habs && !check_access(id, 1))
		{
			set_user_gravity(id, 1.0)
			g_human_spd[id] = 240.0
		}
		
		// Set human maxspeed
		ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
		
		if(!g_duel_final)
			set_task(0.2, "show_menu_buy1", id+TASK_SPAWN)
		
		// Silent mode = no HUD messages, no antidote sound
		if (!silentmode)
		{
			// Antidote sound
			emit_sound(id, CHAN_ITEM, g_sSoundAntidote[random_num(0, charsmax(g_sSoundAntidote))], 1.0, ATTN_NORM, 0, PITCH_NORM)
		}
	}
	
	if(g_block_weapons && !check_access(id, 1))
		strip_user_weapons(id);
	
	// Switch to CT
	if (fm_cs_get_user_team(id) != FM_CS_TEAM_CT) // need to change team?
	{
		remove_task(id+TASK_TEAM)
		fm_cs_set_user_team(id, FM_CS_TEAM_CT)
		fm_user_team_update(id)
	}
	
	// Custom models stuff
	static currentmodel[32], tempmodel[32], already_has_model
	already_has_model = 0
	
	// Get current model for comparing it with the current one
	fm_cs_get_user_model(id, currentmodel, charsmax(currentmodel))
	
	// Set the right model, after checking that we don't already have it
	if(g_survivor[id])
	{
		if(equal(currentmodel, g_sModelSurvivor))
			already_has_model = 1;
		
		if(!already_has_model)
			copy(g_playermodel[id], charsmax(g_playermodel[]), g_sModelSurvivor);
	}
	else if(g_wesker[id])
	{
		if(equal(currentmodel, g_sModelWesker))
			already_has_model = 1;
		
		if(!already_has_model)
			copy(g_playermodel[id], charsmax(g_playermodel[]), g_sModelWesker);
	}
	else if(g_predator[id])
	{
		if(equal(currentmodel, g_sModelPredator))
			already_has_model = 1;
		
		if(!already_has_model)
			copy(g_playermodel[id], charsmax(g_playermodel[]), g_sModelPredator);
	}
	else if(g_tribal_human[id])
	{
		if(equal(currentmodel, g_sModelTribal))
			already_has_model = 1;
		
		if(!already_has_model)
			copy(g_playermodel[id], charsmax(g_playermodel[]), g_sModelTribal);
	}
	else
	{
		ArrayGetString(g_hclass_playermodel, g_humanclass[id], tempmodel, charsmax(tempmodel))
		if (equal(currentmodel, tempmodel)) already_has_model = true
		
		if (!already_has_model)
			ArrayGetString(g_hclass_playermodel, g_humanclass[id], g_playermodel[id], charsmax(g_playermodel[]))
		
		if(g_zr_pj[id] == 157)
			formatex(g_playermodel[id], charsmax(g_playermodel[]), "zp_tcs_l4d_louis")
	}
	
	// Need to change the model?
	if (!already_has_model)
	{
		// An additional delay is offset at round start
		// since SVC_BAD is more likely to be triggered there
		if(g_newround) set_task(5.0 * MODELS_CHANGE_DELAY, "fm_user_model_update", id+TASK_MODEL)
		else fm_user_model_update(id+TASK_MODEL)
	}
	
	// Set survivor glow / remove glow, unless frozen
	if(!g_frozen[id])
	{
		if(g_survivor[id]) set_user_rendering(id, kRenderFxGlowShell, 0, 0, 255, kRenderNormal, 25)
		else if(g_wesker[id])
		{
			if(!g_hab[id][HAB_OTHER][OTHER_ULTRA_LASER]) set_user_rendering(id, kRenderFxGlowShell, 0, 255, 255, kRenderNormal, 25)
			else set_user_rendering(id, kRenderFxGlowShell, 255, 255, 0, kRenderNormal, 25)
		}
		else if(g_tribal_human[id]) set_user_rendering(id, kRenderFxGlowShell, 255, 0, 255, kRenderNormal, 25)
		else if(g_predator[id]) set_user_rendering(id, kRenderFxGlowShell, 255, 255, 0, kRenderNormal, 25)
		else if(g_sniper[id]) set_user_rendering(id, kRenderFxGlowShell, 0, 255, 0, kRenderNormal, 25)
		else set_user_rendering(id)
	}
	
	message_begin(MSG_ONE, g_msgSetFOV, _, id);
	write_byte(90);
	message_end();
	
	// Disable nightvision when turning into human/survivor (bugfix)
	if (g_nvision[id])
	{
		remove_task(id+TASK_NVISION)
		
		g_nvision[id] = 0
		g_nvisionenabled[id] = 0
	}
	
	// Last Zombie Check
	fnCheckLastZombie()
}

/*================================================================================
 [Other Functions and Tasks]
=================================================================================*/

load_customization_from_files()
{
	// Build customization file path
	new path[64]
	get_configsdir(path, charsmax(path))
	format(path, charsmax(path), "%s/%s", path, g_sCustomizationFile)
	
	// File not present
	if (!file_exists(path))
	{
		new error[100]
		formatex(error, charsmax(error), "No se pudo cargar el archivo: %s!", path)
		set_fail_state(error)
		return;
	}
	
	// Set up some vars to hold parsing info
	new linedata[1024], key[64], value[960], section
	
	// Open customization file for reading
	new file = fopen(path, "rt")
	
	while (file && !feof(file))
	{
		// Read one line at a time
		fgets(file, linedata, charsmax(linedata))
		
		// Replace newlines with a null character to prevent headaches
		replace(linedata, charsmax(linedata), "^n", "")
		
		// Blank line or comment
		if (!linedata[0] || linedata[0] == ';') continue;
		
		// New section starting
		if (linedata[0] == '[')
		{
			section++
			continue;
		}
		
		// Get key and value(s)
		strtok(linedata, key, charsmax(key), value, charsmax(value), '=')
		
		// Trim spaces
		trim(key)
		trim(value)
		
		switch (section)
		{
			case SECTION_BUY_MENU_WEAPONS:
			{
				if (equal(key, "PRIMARY"))
				{
					new weaponname[32], level[8], lvl, range
					
					// Parse weapons
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Parse resets
						strtok(key, weaponname, charsmax(weaponname), level, charsmax(level), ':')
						
						if(level[0])
						{
							trim(level)
							lvl = str_to_num(level)
							range = 0
							
							while(lvl > MAX_LVL)
							{
								lvl -= MAX_LVL
								range++
							}
							
							ArrayPushCell(g_pri_weap_lvl, lvl)
							if(range > 0) ArrayPushCell(g_pri_weap_range, range)
							else ArrayPushCell(g_pri_weap_range, 0)
						}
						else
						{
							ArrayPushCell(g_pri_weap_lvl, 1)
							ArrayPushCell(g_pri_weap_range, 0)
						}
						
						// Trim spaces
						trim(weaponname)
						
						// Add to weapons array
						ArrayPushString(g_primary_items, weaponname)
						ArrayPushCell(g_primary_weaponids, cs_weapon_name_to_id(weaponname))
					}
				}
				else if (equal(key, "SECONDARY"))
				{
					new weaponname[32], level[5]
					
					// Parse weapons
					while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
					{
						// Trim spaces
						trim(key)
						trim(value)
						
						// Parse resets
						strtok(key, weaponname, charsmax(weaponname), level, charsmax(level), ':')
						
						if(level[0])
						{
							trim(level)
							ArrayPushCell(g_sec_weap_lvl, str_to_num(level))
						}
						else ArrayPushCell(g_sec_weap_lvl, 1)
						
						// Trim spaces
						trim(weaponname)
						
						// Add to weapons array
						ArrayPushString(g_secondary_items, weaponname)
						ArrayPushCell(g_secondary_weaponids, cs_weapon_name_to_id(weaponname))
					}
				}
			}
		}
	}
	if (file) fclose(file)
}

// Disable minmodels task
public disable_minmodels(id)
{
	if (!hub(id, g_data[BIT_CONNECTED])) return;
	
	client_cmd(id, "cl_minmodels 0")
	/*client_cmd(id, "motdfile sprites/hud.txt")
	client_cmd(id, "motd_write %s", g_text_hud)
	client_cmd(id, "motdfile motd.txt")*/
}

// Refill BP Ammo Task
public refill_bpammo(const args[], id)
{
	// Player died or turned into a zombie
	if (!hub(id, g_data[BIT_ALIVE]) || g_zombie[id])
		return;
	
	set_msg_block(g_msgAmmoPickup, BLOCK_ONCE)
	ExecuteHamB(Ham_GiveAmmo, id, MAXBPAMMO[args[0]], AMMOTYPE[args[0]], MAXBPAMMO[args[0]])
}

// Balance Teams Task
balance_teams()
{
	// Get amount of players playing
	static iPlayersnum
	iPlayersnum = fnGetPlaying()
	
	// No players, don't bother
	if (iPlayersnum < 1) return;
	
	// Split players evenly
	static iTerrors, iMaxTerrors, id, team[33]
	iMaxTerrors = iPlayersnum/2
	iTerrors = 0
	
	// First, set everyone to CT
	for (id = 1; id <= g_maxplayers; id++)
	{
		// Skip if not connected
		if (!hub(id, g_data[BIT_CONNECTED]))
			continue;
		
		team[id] = fm_cs_get_user_team(id)
		
		// Skip if not playing
		if (team[id] == FM_CS_TEAM_SPECTATOR || team[id] == FM_CS_TEAM_UNASSIGNED)
			continue
		
		// Set team
		remove_task(id+TASK_TEAM)
		fm_cs_set_user_team(id, FM_CS_TEAM_CT)
		team[id] = FM_CS_TEAM_CT
	}
	
	// Then randomly set half of the players to Terrorists
	while (iTerrors < iMaxTerrors)
	{
		// Keep looping through all players
		if (++id > g_maxplayers) id = 1
		
		// Skip if not connected
		if (!hub(id, g_data[BIT_CONNECTED]))
			continue;
		
		// Skip if not playing or already a Terrorist
		if (team[id] != FM_CS_TEAM_CT)
			continue;
		
		// Random chance
		if (random_num(0, 1))
		{
			fm_cs_set_user_team(id, FM_CS_TEAM_T)
			team[id] = FM_CS_TEAM_T
			iTerrors++
		}
	}
}

// Welcome Message Task
public welcome_msg()
{
	// Show T-virus HUD notice
	set_hudmessage(0, 125, 200, HUD_EVENT_X, HUD_EVENT_Y, 0, 0.0, 3.0, 2.0, 1.0, -1)
	ShowSyncHudMsg(0, g_MsgSync, "EL VIRUS-T SE HA LIBERADO")
	
	if(g_super_ur)
		CC(0, "!gSÚPER TARINGA AT NITE!!y Tus ganancias se multiplican x3 y siendo premium x5")
	else if(g_ur)
		CC(0, "!gTARINGA AT NITE!!y Tus ganancias se multiplican x2 y siendo premium x4")
}

// Respawn Player Task (deathmatch)
public respawn_player_task(taskid)
{
	// Already alive or round ended
	if(hub(ID_SPAWN, g_data[BIT_ALIVE]) || g_endround)
		return;
	
	if(!g_selected_model[ID_SPAWN])
		return;
		
	// Get player's team
	static team
	team = fm_cs_get_user_team(ID_SPAWN)
	
	// Player moved to spectators
	if(team == FM_CS_TEAM_SPECTATOR || team == FM_CS_TEAM_UNASSIGNED)
		return;
	
	if(g_sniper_round && g_zombies_left < fnGetAlive() - 1)
		return;
	
	// Respawn player automatically if allowed on current round
	if((!g_survround && !g_swarmround && !g_duel_final && !g_nemround && !g_plagueround && !g_armageddon_round && !g_wesker_round && !g_tribal_round && !g_fp_round && !g_alvspre_round))
	{
		g_respawn_as_zombie[ID_SPAWN] = 0;
		
		if(!g_annihilation_round)
		{
			if(g_sniper_round)
				g_respawn_as_zombie[ID_SPAWN] = 1
			
			if((fnGetZombies() < fnGetAlive()/2) || g_iSelfKill[ID_SPAWN])
				g_respawn_as_zombie[ID_SPAWN] = 1
		}
		
		respawn_player_manually(ID_SPAWN)
	}
}

// Respawn Player Check Task (if killed by worldspawn)
public respawn_player_check_task(taskid)
{
	if(hub(ID_SPAWN, g_data[BIT_ALIVE]) || g_endround)
		return;
	
	if(!g_newround)
		return;
	
	static team
	team = fm_cs_get_user_team(ID_SPAWN)
	
	if(team == FM_CS_TEAM_SPECTATOR || team == FM_CS_TEAM_UNASSIGNED)
		return;
	
	g_respawn_as_zombie[ID_SPAWN] = 1
	
	respawn_player_manually(ID_SPAWN)
}

// Respawn Player Manually (called after respawn checks are done)
respawn_player_manually(id)
{
	// Set proper team before respawning, so that the TeamInfo message that's sent doesn't confuse PODBots
	if(g_respawn_as_zombie[id]) fm_cs_set_user_team(id, FM_CS_TEAM_T)
	else fm_cs_set_user_team(id, FM_CS_TEAM_CT)
	
	// Respawning a player has never been so easy
	ExecuteHamB(Ham_CS_RoundRespawn, id)
}

// Check Round Task -check that we still have both zombies and humans on a round-
check_round(leaving_player)
{
	// Round ended or make_a_zombie task still active
	if(g_endround || task_exists(TASK_MAKEZOMBIE))
		return;
	
	// Get alive players count
	static iPlayersnum, id
	iPlayersnum = fnGetAlive()
	
	if(g_duel_final && iPlayersnum < 3)
	{
		new iAps;
		new sAps[15];
		
		iAps = random_num(20000, 65000)
		add_dot(iAps, sAps, 14);
		
		new i;
		new sWinss[15];
		new ars;
		
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(!is_user_connected(i))
				continue;
			
			add_dot(g_duel_win_xp[i], sWinss, 14)
			CC(i, "!g[ZP]!y DUELO FINAL%s: Ganaste !g%s de XP!y", g_duel_final_aps ? " DE APS" : "", sWinss);
			update_xp(i, g_duel_win_xp[i], 0);
			
			g_duel_win_xp[i] = 0;
			
			if(is_user_alive(i))
				ars = i;
		}
		
		CC(0, "!g[ZP] %s!y es el ganador del DUELO FINAL %s. Ganó !g%s de XP!y", g_playername[ars], g_duel_final_aps ? "DE APS" : "", sAps)
		update_xp(ars, iAps, 0);
		
		PlaySound(g_sSoundBazooka_3)
		
		g_timeleft_rest = (get_timeleft() / 60);
		
		i = 0;
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(!is_user_alive(i))
				continue;
			
			remove_task(i+TASK_TEAM)
			fm_cs_set_user_team(i, FM_CS_TEAM_T)
			fm_user_team_update(i)
			
			user_silentkill(i)
		}
		
		return;
	}
	
	// Last alive player, don't bother
	if (iPlayersnum < 3)
	{
		g_enround_forced = 1;
		return;
	}
	
	if(g_alvspre_round)
	{
		if(g_alien[leaving_player] && fnGetZombies() > 1)
		{
			while((id = fnGetRandomAlive(random_num(1, iPlayersnum))) == leaving_player ) { /* keep looping */ }
			
			static poder;
			poder = g_alien_power;
			
			zombieme(id, 0, 0, 0, 0, 1, 0, 0)
			
			g_alien_power = poder;
			
			CC(0, "!g[ZP]!y El alien se ha ido, !g%s!y es el nuevo alien", g_playername[id])
			
			return;
		}
		else if(g_predator[leaving_player] && fnGetHumans() > 1)
		{
			while((id = fnGetRandomAlive(random_num(1, iPlayersnum))) == leaving_player ) { /* keep looping */ }
			
			static poder;
			poder = g_power_invis;
			
			humanme(id, 0, 0, 0, 0, 1, 0)
			
			g_power_invis = poder;
			
			CC(0, "!g[ZP]!y El depredador se ha ido, !g%s!y es el nuevo depredador", g_playername[id])
			
			return;
		}
	}
	
	// Last zombie disconnecting
	if(g_zombie[leaving_player] && fnGetZombies() == 1)
	{
		// Only one CT left, don't bother
		if(fnGetHumans() == 1 && fnGetCTs() == 1)
			return;
		
		if(g_tribal_round && fnGetHumans() == 2)
		{
			g_enround_forced = 1;
			return;
		}
		
		// Pick a random one to take his place
		while((id = fnGetRandomAlive(random_num(1, iPlayersnum))) == leaving_player ) { /* keep looping */ }
		
		// Turn into a Nemesis or just a zombie?
		if(g_nemesis[leaving_player])
		{
			CC(0, "!g[ZP]!y El nemesis se ha ido, !g%s!y es el nuevo nemesis", g_playername[id])
			
			zombieme(id, 0, 1, 0, 0, 0, 0, 0)
			g_bazooka[id] = g_bazooka[leaving_player];
			
			if(!g_bazooka[id])
			{
				strip_user_weapons(id)
				give_item(id, "weapon_knife")
			}
		}
		else if(g_annihilator[leaving_player])
		{
			CC(0, "!g[ZP]!y El aniquilador se ha ido, !g%s!y es el nuevo aniquilador", g_playername[id])
			
			zombieme(id, 0, 0, 0, 0, 0, 1, 0)	
			g_bazooka[id] = g_bazooka[leaving_player];
			
			if(!g_bazooka[id])
			{
				ham_strip_weapons(id, "weapon_sg550")
				give_item(id, "weapon_knife")
			}
			
			new sWeaponName[32];
			new iWeaponEntId;
			new iWeaponEntLeavingPlayer;
			
			get_weaponname(CSW_MAC10, sWeaponName, 31);
			iWeaponEntId = fm_find_ent_by_owner(-1, sWeaponName, id);
			iWeaponEntLeavingPlayer = fm_find_ent_by_owner(-1, sWeaponName, leaving_player);
			
			set_pdata_int(id, AMMOOFFSET[CSW_MAC10], get_pdata_int(leaving_player, AMMOOFFSET[CSW_MAC10], OFFSET_LINUX), OFFSET_LINUX);
			set_pdata_int(iWeaponEntId, OFFSET_CLIPAMMO, get_pdata_int(iWeaponEntLeavingPlayer, OFFSET_CLIPAMMO, OFFSET_LINUX_WEAPONS), OFFSET_LINUX_WEAPONS);
		}
		else
		{
			CC(0, "!g[ZP]!y El último zombie se ha ido, !g%s!y es el nuevo zombie", g_playername[id])
			zombieme(id, 0, 0, 0, 0, 0, 0, 0)
		}
	}
	// Last human disconnecting
	else if(!g_zombie[leaving_player] && fnGetHumans() == 1)
	{
		// Only one T left, don't bother
		if(fnGetZombies() == 1 && fnGetTs() == 1)
			return;
		
		// Pick a random one to take his place
		while((id = fnGetRandomAlive(random_num(1, iPlayersnum))) == leaving_player ) { /* keep looping */ }
		
		// Turn into a Survivor or just a human?
		if(g_survivor[leaving_player])
		{
			CC(0, "!g[ZP]!y El survivor se ha ido, !g%s!y es el nuevo survivor", g_playername[id])
			
			humanme(id, 1, 0, 0, 0, 0, 0)
			
			g_surv_immunity[id] = g_surv_immunity[leaving_player]
			if(!g_hab[id][HAB_SURV][SURV_EXTRA_BOMB] && g_bomb_aniq[leaving_player])
			{
				give_item(id, "weapon_hegrenade")
				g_bomb_aniq[id] = 1
			}
			else if(g_bomb_aniq[leaving_player])
			{
				give_item(id, "weapon_hegrenade")
				cs_set_user_bpammo(id, CSW_HEGRENADE, 2);
				g_bomb_aniq[id] = 2;
			}
			else g_bomb_aniq[id] = 0;
		}
		else if(g_wesker[leaving_player])
		{
			CC(0, "!g[ZP]!y El wesker se ha ido, !g%s!y es el nuevo wesker", g_playername[id])
			
			humanme(id, 0, 0, 1, 0, 0, 0)
			g_wesker_laser[id] = g_wesker_laser[leaving_player];
		}
		else if(g_sniper[leaving_player])
		{
			CC(0, "!g[ZP]!y El sniper se ha ido, !g%s!y es el nuevo sniper", g_playername[id])
			
			humanme(id, 0, 0, 0, 0, 0, 1)
			g_sniper_power[id] = g_sniper_power[leaving_player];
		}
		else
		{
			CC(0, "!g[ZP]!y El último humano se ha ido, !g%s!y es el nuevo humano", g_playername[id])
			humanme(id, 0, 0, 0, 0, 0, 0)
		}
	}
}

// Lighting Effects Task
public lighting_effects()
{
	if(g_duel_final) set_lights("i");
	else if(!g_alvspre_round && !g_nemround && !g_annihilation_round && !g_wesker_round && !g_sniper_round && !g_survround) set_lights(g_map_light[0]);
	else set_lights("a");
}

// Hide Player's Money Task
public task_hide_huds(taskid)
{
	// Not alive
	if (!hub(ID_SPAWN, g_data[BIT_ALIVE]))
		return;
	
	// Hide money
	message_begin(MSG_ONE, g_msgHideWeapon, _, ID_SPAWN)
	write_byte(HIDE_MONEY) // what to hide bitsum
	message_end()
	
	// Hide the HL crosshair that's drawn
	message_begin(MSG_ONE, g_msgCrosshair, _, ID_SPAWN)
	write_byte(0) // toggle
	message_end()
}

// Turn Off Flashlight and Restore Batteries
turn_off_flashlight(id)
{
	entity_set_int(id, EV_INT_effects, entity_get_int(id, EV_INT_effects) & ~EF_DIMLIGHT);
	
	message_begin(MSG_ONE_UNRELIABLE, g_msgFlashlight, _, id);
	write_byte(0);
	write_byte(100);
	message_end();
	
	entity_set_int(id, EV_INT_impulse, 0);
}

// Infection Bomb Explosion
infection_explode(ent)
{
	// Round ended (bugfix)
	if (g_endround) return;
	
	// Get origin
	static Float:originF[3]
	entity_get_vector(ent, EV_VEC_origin, originF)
	
	// Make the explosion
	create_blast(originF, 0, 200, 0)
	
	// Infection nade explode sound
	emit_sound(ent, CHAN_WEAPON, g_sSoundGrenadeInfect[random_num(0, charsmax(g_sSoundGrenadeInfect))], 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	// Get attacker
	static attacker
	attacker = entity_get_edict(ent, EV_ENT_owner)
	
	// Infection bomb owner disconnected? (bugfix)
	if(!is_user_valid_connected(attacker))
	{
		// Get rid of the grenade
		engfunc(EngFunc_RemoveEntity, ent)
		return;
	}
	
	// Collisions
	static victim, count_victims
	victim = -1
	count_victims = 0
	
	while ((victim = engfunc(EngFunc_FindEntityInSphere, victim, originF, NADE_EXPLOSION_RADIUS)) != 0)
	{
		// Only effect alive non-spawnprotected humans
		if (!is_user_valid_alive(victim) || g_zombie[victim] || g_nodamage[victim]/* || !fm_is_ent_visible(victim, ent)*/)
			continue;
		
		count_victims++
		
		// Last human is killed
		if (fnGetHumans() == 1)
		{
			ExecuteHamB(Ham_Killed, victim, attacker, 0)
			continue;
		}
		
		// Infected victim's sound
		emit_sound(victim, CHAN_VOICE, g_sSoundGrenadeInfectPlayer[random_num(0, charsmax(g_sSoundGrenadeInfectPlayer))], 1.0, ATTN_NORM, 0, PITCH_NORM)
		
		// Turn into zombie
		zombieme(victim, attacker, 0, 1, 2, 0, 0, 0)
	}
	
	if(count_victims == 0)
		fn_update_logro(attacker, LOGRO_ZOMBIE, BOMBA_FALLIDA);
	else if(count_victims >= 15)
		fn_update_logro(attacker, LOGRO_ZOMBIE, ME_ENCANTA_ESE_SOUND);
	
	// Get rid of the grenade
	engfunc(EngFunc_RemoveEntity, ent)
}

// Antidote Bomb Explosion
antidote_explode(ent)
{
	// Round ended (bugfix)
	if (g_endround) return;
	
	// Get origin
	static Float:originF[3]
	entity_get_vector(ent, EV_VEC_origin, originF)
	
	// Make the explosion
	create_blast(originF, 0, 255, 255)
	
	// Infection nade explode sound
	emit_sound(ent, CHAN_WEAPON, g_sSoundGrenadeInfect[random_num(0, charsmax(g_sSoundGrenadeInfect))], 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	// Get attacker
	static attacker
	attacker = entity_get_edict(ent, EV_ENT_owner)
	
	// Infection bomb owner disconnected? (bugfix)
	if(!is_user_valid_connected(attacker))
	{
		// Get rid of the grenade
		engfunc(EngFunc_RemoveEntity, ent)
		return;
	}
	
	// Collisions
	static victim, rew, count_victims
	victim = -1
	rew = 1;
	count_victims = 0
	
	while ((victim = engfunc(EngFunc_FindEntityInSphere, victim, originF, NADE_EXPLOSION_RADIUS)) != 0)
	{
		// Only effect alive non-spawnprotected humans
		if (!is_user_valid_alive(victim) || !g_zombie[victim] || g_nodamage[victim]/* || !fm_is_ent_visible(victim, ent)*/)
			continue;
		
		count_victims++
		
		// Last human is killed
		if(fnGetZombies() == 1)
			continue;
			
		SendDeathMsg(attacker, victim);
		FixDeadAttrib(victim);
		
		rew = (g_level[victim] + (g_range[victim] * 200));
		if(rew > 5000) rew = 5000;
		
		update_xp(attacker, rew, 3)
		
		// Turn into zombie
		humanme(victim, 0, 0, 0, 0, 0, 0)
	}
	
	if(!count_victims)
		fn_update_logro(attacker, LOGRO_ZOMBIE, LIMPIEZA);
	else if(count_victims >= 18)
		fn_update_logro(attacker, LOGRO_ZOMBIE, CLEAR_ZOMBIE);
	
	// Get rid of the grenade
	engfunc(EngFunc_RemoveEntity, ent)
}

// Fire Grenade Explosion
fire_explode(ent)
{
	// Get origin
	static Float:originF[3]
	entity_get_vector(ent, EV_VEC_origin, originF)
	
	if(get_entity_flags(ent) & FL_INWATER)
	{
		engfunc(EngFunc_RemoveEntity, ent)
		return;
	}
	
	// Collisions
	static attacker, victim, count_victims
	attacker = entity_get_edict(ent, EV_ENT_owner)
	victim = -1
	count_victims = 0
	
	if (!is_user_valid_connected(attacker))
	{
		// Get rid of the grenade
		engfunc(EngFunc_RemoveEntity, ent)
		return;
	}
	
	// Make the explosion
	create_blast(originF, 200, 100, 0)
	
	// Fire nade explode sound
	emit_sound(ent, CHAN_WEAPON, g_sSoundGrenadeFire[random_num(0, charsmax(g_sSoundGrenadeFire))], 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	while ((victim = engfunc(EngFunc_FindEntityInSphere, victim, originF, NADE_EXPLOSION_RADIUS)) != 0)
	{
		// Only effect alive zombies
		if (!is_user_valid_alive(victim) || !g_zombie[victim] || g_nodamage[victim]/* || !fm_is_ent_visible(victim, ent)*/)
			continue;
		
		if(g_hab[victim][HAB_ZOMBIE][ZOMBIE_FROZEN] >= 3 && g_frozen[victim])
			continue;
		
		count_victims++
		
		if (g_nemesis[victim] || g_alien[victim]) // fire duration (nemesis is fire resistant)
			g_burning_duration[victim] += 10
		else
			g_burning_duration[victim] += 50
		
		// Set burning task on victim if not present
		if (!task_exists(victim+TASK_BURN))
			set_task(0.2, "burning_flame", victim+TASK_BURN, _, _, "b")
	}
	
	if(count_victims >= 15) fn_update_logro(attacker, LOGRO_HUMAN, ESTOY_QUE_ARDO);
	
	// Get rid of the grenade
	engfunc(EngFunc_RemoveEntity, ent)
}

// Frost Grenade Explosion
frost_explode(ent)
{
	// Get origin
	static Float:originF[3]
	entity_get_vector(ent, EV_VEC_origin, originF)
	
	if(get_entity_flags(ent) & FL_INWATER)
	{
		engfunc(EngFunc_RemoveEntity, ent)
		return;
	}
	
	// Collisions
	static attacker, victim, victim_frozen, count_victims, Float:radius
	attacker = entity_get_edict(ent, EV_ENT_owner)
	victim = -1
	count_victims = 0
	
	if (!is_user_valid_connected(attacker))
	{
		// Get rid of the grenade
		engfunc(EngFunc_RemoveEntity, ent)
		return;
	}
	
	// Make the explosion
	create_blast(originF, 0, 100, 200)
	
	// Frost nade explode sound
	emit_sound(ent, CHAN_WEAPON, g_sSoundGrenadeFrost[random_num(0, charsmax(g_sSoundGrenadeFrost))], 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	if(!g_game_bomba)
		radius = 240.0;
	else
		radius = g_game_bomba_radius;
	
	while((victim = engfunc(EngFunc_FindEntityInSphere, victim, originF, radius)) != 0)
	{
		// Only effect alive unfrozen zombies
		if (!is_user_valid_alive(victim) || !g_zombie[victim] || g_nodamage[victim]/* || !fm_is_ent_visible(victim, ent)*/)
			continue;
		
		if(g_frozen_acc[victim] > 0)
			continue;
		
		if(g_rn_equip[victim][NECK][NECK_FROST] && g_frozen_acc[victim])
			continue;
		
		// Nemesis shouldn't be frozen
		if(g_nemesis[victim] || g_alien[victim] || g_annihilator[victim] || g_fp[victim])
		{
			// Get player's origin
			static origin2[3]
			get_user_origin(victim, origin2)
			
			// Broken glass sound
			emit_sound(victim, CHAN_BODY, g_sSoundGrenadeFrostBreak[random_num(0, charsmax(g_sSoundGrenadeFrostBreak))], 1.0, ATTN_NORM, 0, PITCH_NORM)
			
			// Glass shatter
			message_begin(MSG_PVS, SVC_TEMPENTITY, origin2)
			write_byte(TE_BREAKMODEL) // TE id
			write_coord(origin2[0]) // x
			write_coord(origin2[1]) // y
			write_coord(origin2[2]+24) // z
			write_coord(16) // size x
			write_coord(16) // size y
			write_coord(16) // size z
			write_coord(random_num(-50, 50)) // velocity x
			write_coord(random_num(-50, 50)) // velocity y
			write_coord(25) // velocity z
			write_byte(10) // random velocity
			write_short(g_glassSpr) // model
			write_byte(10) // count
			write_byte(25) // life
			write_byte(BREAK_GLASS) // flags
			message_end()
			
			continue;
		}
		
		count_victims++
		g_frozen_acc[victim]++
		
		// Light blue glow while frozen
		set_user_rendering(victim, kRenderFxGlowShell, 0, 100, 200, kRenderNormal, 25)
		
		// Freeze sound
		emit_sound(victim, CHAN_BODY, g_sSoundGrenadeFrostPlayer[random_num(0, charsmax(g_sSoundGrenadeFrostPlayer))], 1.0, ATTN_NORM, 0, PITCH_NORM)
		
		// Add a blue tint to their screen
		message_begin(MSG_ONE, g_msgScreenFade, _, victim)
		write_short(0) // duration
		write_short(0) // hold time
		write_short(FFADE_STAYOUT) // fade type
		write_byte(0) // red
		write_byte(50) // green
		write_byte(200) // blue
		write_byte(100) // alpha
		message_end()
		
		// Prevent from jumping
		if (get_entity_flags(victim) & FL_ONGROUND)
			set_user_gravity(victim, 999999.9) // set really high
		else
			set_user_gravity(victim, 0.000001) // no gravity
		
		// Set a task to remove the freeze
		victim_frozen = g_hab[victim][HAB_ZOMBIE][ZOMBIE_FROZEN]
		
		remove_task(victim+TASK_FROZEN)
		remove_task(victim+TASK_SLOWDOWN)
		
		g_frozen[victim] = 1;
		g_slowdown[victim] = 1
		
		set_task((victim_frozen >= 2) ? 2.0 : 4.0, "remove_freeze", victim + TASK_FROZEN)
		set_task((victim_frozen >= 1) ? 7.0 : 9.0, "remove_slowdown", victim + TASK_SLOWDOWN)
		
		if(victim_frozen >= 3) g_burning_duration[victim] = 0;
		
		// Prevent from moving
		ExecuteHamB(Ham_Player_ResetMaxSpeed, victim)
	}
	
	if(!g_game_bomba)
	{
		if(count_victims >= 15) fn_update_logro(attacker, LOGRO_HUMAN, A_DONDE_VAS);
		
		victim = -1;
		while((victim = engfunc(EngFunc_FindEntityInSphere, victim, originF, NADE_EXPLOSION_RADIUS + 20)) != 0)
		{
			// Only effect alive unfrozen zombies
			if (!is_user_valid_alive(victim) || !g_zombie[victim] || g_nemesis[victim] || g_alien[victim] || g_annihilator[victim] || g_nodamage[victim] || g_frozen[victim]
			/*|| !fm_is_ent_visible(victim, ent)*/)
				continue;
			
			// SlowDown Sound
			emit_sound(victim, CHAN_BODY, g_sSoundGrenadeSlowDownPlayer[random_num(0, charsmax(g_sSoundGrenadeSlowDownPlayer))], 1.0, ATTN_NORM, 0, PITCH_LOW)
			
			// Set slowdown and task to remove
			victim_frozen = g_hab[victim][HAB_ZOMBIE][ZOMBIE_FROZEN]
			
			remove_task(victim+TASK_SLOWDOWN)
			
			g_slowdown[victim] = 1
			
			set_task((victim_frozen >= 1) ? 4.0 : 6.0, "remove_slowdown", victim + TASK_SLOWDOWN)
			
			// Prevent from moving
			ExecuteHamB(Ham_Player_ResetMaxSpeed, victim)
		}
	}
	else
	{
		new i;
		for(i = 1; i <= g_maxplayers; ++i)
		{
			if(!is_user_alive(i))
				continue;
			
			if(g_frozen[i])
				continue;
			
			if(i == attacker)
				continue;
			
			ExecuteHamB(Ham_Killed, i, attacker, 2);
		}
	}
	
	// Get rid of the grenade
	engfunc(EngFunc_RemoveEntity, ent)
}

// Remove freeze task
public remove_freeze(taskid)
{
	new id = ID_FROZEN;
	
	// Not alive or not frozen anymore
	if(!hub(id, g_data[BIT_ALIVE]) || !g_frozen[id])
		return;
	
	// Unfreeze
	g_frozen[id] = 0;
	g_frozen_acc[id] = 0;
	
	// Restore gravity and maxspeed (bugfix)
	set_user_gravity(id, g_frozen_gravity[id])
	ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
	
	// Nemesis or Survivor glow / remove glow
	if(g_nemesis[id]) set_user_rendering(id, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 25)
	else if(g_annihilator[id]) set_user_rendering(id, kRenderFxGlowShell, 255, 255, 255, kRenderNormal, 25)
	else if(g_survivor[id]) set_user_rendering(id, kRenderFxGlowShell, 0, 0, 255, kRenderNormal, 25)
	else if(g_wesker[id])
	{
		if(!g_hab[id][HAB_OTHER][OTHER_ULTRA_LASER]) set_user_rendering(id, kRenderFxGlowShell, 0, 255, 255, kRenderNormal, 25)
		else set_user_rendering(id, kRenderFxGlowShell, 255, 255, 0, kRenderNormal, 25)
	}
	else if(g_tribal_human[id]) set_user_rendering(id, kRenderFxGlowShell, 255, 0, 255, kRenderNormal, 25)
	else if(g_predator[id]) set_user_rendering(id, kRenderFxGlowShell, 255, 255, 0, kRenderNormal, 25)
	else if(g_sniper[id]) set_user_rendering(id, kRenderFxGlowShell, 0, 255, 0, kRenderNormal, 25)
	else set_user_rendering(id)
	
	// Gradually remove screen's blue tint
	message_begin(MSG_ONE, g_msgScreenFade, _, id)
	write_short(UNIT_SECOND) // duration
	write_short(0) // hold time
	write_short(FFADE_IN) // fade type
	write_byte(0) // red
	write_byte(50) // green
	write_byte(200) // blue
	write_byte(100) // alpha
	message_end()
	
	// Broken glass sound
	emit_sound(id, CHAN_BODY, g_sSoundGrenadeFrostBreak[random_num(0, charsmax(g_sSoundGrenadeFrostBreak))], 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	// Get player's origin
	static origin2[3]
	get_user_origin(id, origin2)
	
	// Glass shatter
	message_begin(MSG_PVS, SVC_TEMPENTITY, origin2)
	write_byte(TE_BREAKMODEL) // TE id
	write_coord(origin2[0]) // x
	write_coord(origin2[1]) // y
	write_coord(origin2[2]+24) // z
	write_coord(16) // size x
	write_coord(16) // size y
	write_coord(16) // size z
	write_coord(random_num(-50, 50)) // velocity x
	write_coord(random_num(-50, 50)) // velocity y
	write_coord(25) // velocity z
	write_byte(10) // random velocity
	write_short(g_glassSpr) // model
	write_byte(10) // count
	write_byte(25) // life
	write_byte(BREAK_GLASS) // flags
	message_end()
}

// Remove slowdown task
public remove_slowdown(taskid)
{
	new id = ID_SLOWDOWN;
	
	// Not alive or not frozen anymore
	if(!hub(id, g_data[BIT_ALIVE]) || !g_slowdown[id])
		return;
	
	// Unfreeze
	g_slowdown[id] = 0;
	
	// Restore maxspeed
	ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
}

// Grenade Explosion
grenade_explode(ent)
{
	// Get origin
	static Float:originF[3]
	entity_get_vector(ent, EV_VEC_origin, originF)
	
	if(get_entity_flags(ent) & FL_INWATER)
	{
		engfunc(EngFunc_RemoveEntity, ent)
		return;
	}
	
	// Collisions
	static attacker, victim, health_min, count_victims
	attacker = entity_get_edict(ent, EV_ENT_owner)
	victim = -1
	count_victims = 0
	
	if(!is_user_valid_connected(attacker))
	{
		// Get rid of the grenade
		engfunc(EngFunc_RemoveEntity, ent)
		return;
	}
	
	// Make the explosion
	create_blast(originF, 200, 100, 0)
	
	// Sprite
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0)
	write_byte(TE_EXPLOSION)
	engfunc(EngFunc_WriteCoord, originF[0]) // x
	engfunc(EngFunc_WriteCoord, originF[1]) // y
	engfunc(EngFunc_WriteCoord, originF[2]) // z
	write_short(g_grenadeSpr)
	write_byte(40)
	write_byte(25)
	write_byte(0)
	message_end()	
	
	// Grenade explode sound
	emit_sound(ent, CHAN_WEAPON, g_sSoundGrenadeExplode[random_num(0, charsmax(g_sSoundGrenadeExplode))], 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	while ((victim = engfunc(EngFunc_FindEntityInSphere, victim, originF, NADE_EXPLOSION_RADIUS)) != 0)
	{
		// Only effect alive zombies
		if (!is_user_valid_alive(victim) || !g_zombie[victim] || g_nodamage[victim]/* || !fm_is_ent_visible(victim, ent)*/)
			continue;
		
		count_victims++
		
		if (g_nemesis[victim] || g_alien[victim]) // fire duration (nemesis is fire resistant)
			g_burning_duration[victim] += 10
		else
			g_burning_duration[victim] += 50
		
		// Set burning task on victim if not present
		if (!task_exists(victim+TASK_BURN))
			set_task(0.2, "burning_flame", victim+TASK_BURN, _, _, "b")
		
		health_min = (g_hab[victim][HAB_ZOMBIE][ZOMBIE_FIRE] >= 1) ? 3500 : 5500
		
		if ((get_user_health(victim) - health_min) > 0)
			set_user_health(victim, get_user_health(victim) - health_min)
	}
	
	if(count_victims >= 15) fn_update_logro(attacker, LOGRO_HUMAN, ESTOY_QUE_ARDO);
	
	// Get rid of the grenade
	engfunc(EngFunc_RemoveEntity, ent)
}

// Annihilation Explosion
annihilation_explode(ent)
{
	// Get origin
	static Float:originF[3]
	entity_get_vector(ent, EV_VEC_origin, originF)
	
	// Collisions
	static attacker, victim, count_victims
	attacker = entity_get_edict(ent, EV_ENT_owner)
	victim = -1
	count_victims = 0
	
	if (!is_user_valid_connected(attacker))
	{
		// Get rid of the grenade
		engfunc(EngFunc_RemoveEntity, ent)
		return;
	}
	
	// Make the explosion
	create_blast(originF, 255, 255, 0)
	
	// Frost nade explode sound
	emit_sound(ent, CHAN_WEAPON, g_sSoundModeSurvivor[random_num(0, charsmax(g_sSoundModeSurvivor))], 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	while((victim = engfunc(EngFunc_FindEntityInSphere, victim, originF, NADE_EXPLOSION_RADIUS)) != 0)
	{
		// Only effect alive zombies
		if(!is_user_valid_alive(victim) || !g_zombie[victim] || g_nodamage[victim]/* || !fm_is_ent_visible(victim, ent)*/)
			continue;
		
		if(g_nemesis[victim] || g_annihilator[victim] || g_alien[victim])
			continue;
		
		count_victims++
		
		if(g_lastzombie[victim] && gl_time_nem && fnGetPlaying() >= 20)
			fn_update_logro(attacker, LOGRO_SECRET, LETS_ROCK)
		
		ExecuteHamB(Ham_Killed, victim, attacker, 0)
	}
	
	if(count_victims >= 20) fn_update_logro(attacker, LOGRO_SURV, EXPERTO_EN_BOMBAS);
	
	// Get rid of the grenade
	engfunc(EngFunc_RemoveEntity, ent)
}

// Remove Stuff Task
public remove_stuff()
{
	static ent
	
	ent = -1;
	while ((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", "func_door_rotating")) != 0)
		engfunc(EngFunc_SetOrigin, ent, Float:{8192.0, 8192.0, 8192.0})
	
	remove_entity_name("headZombieFake");
}

// Set Custom Weapon Models
replace_weapon_models(id, weaponid) // rwm_f
{
	switch (weaponid)
	{
		case CSW_KNIFE: // Custom knife models
		{
			if (g_zombie[id])
			{
				if (g_nemesis[id]) // Nemesis
				{
					entity_set_string(id, EV_SZ_viewmodel, g_sModelNemesisKnife)
					entity_set_string(id, EV_SZ_weaponmodel, "")
				}
				else if(g_alien[id])
				{
					entity_set_string(id, EV_SZ_viewmodel, g_sModelAlienKnife)
					entity_set_string(id, EV_SZ_weaponmodel, "")
				}
				else if(g_annihilator[id])
				{
					entity_set_string(id, EV_SZ_viewmodel, g_sModel_AnnihilatorKnife)
					entity_set_string(id, EV_SZ_weaponmodel, "")
				}
				else if(g_fp[id])
				{
					entity_set_string(id, EV_SZ_viewmodel, "models/zombie_plague/tcs_garras_fp.mdl")
					entity_set_string(id, EV_SZ_weaponmodel, "")
				}
				else // Zombies
				{
					static clawmodel[100]
					
					//if(g_zr_pj[id] != 1006)
					ArrayGetString(g_zclass_clawmodel, g_zombieclass[id], clawmodel, charsmax(clawmodel))
					/*else
						formatex(clawmodel, charsmax(clawmodel), "zknife199.mdl")*/
						
					format(clawmodel, charsmax(clawmodel), "models/zombie_plague/%s", clawmodel)
					entity_set_string(id, EV_SZ_viewmodel, clawmodel)
					entity_set_string(id, EV_SZ_weaponmodel, "")
				}
			}
			else // Humans
			{
				entity_set_string(id, EV_SZ_viewmodel, "models/v_knife.mdl")
				entity_set_string(id, EV_SZ_weaponmodel, "models/p_knife.mdl")
			}
		}
		case CSW_HEGRENADE: // Infection bomb or fire grenade
		{
			if (g_zombie[id]) entity_set_string(id, EV_SZ_viewmodel, g_sModelGrenadeInfection)
			else if(!g_grenade[id] && !g_pipe[id]) entity_set_string(id, EV_SZ_viewmodel, g_sModelGrenadeFire)
			else if(g_pipe[id]) entity_set_string(id, EV_SZ_viewmodel, g_model_vgrenade_pipe)
			else if(g_grenade[id]) entity_set_string(id, EV_SZ_viewmodel, g_sModel_vGrenade)
		}
		case CSW_FLASHBANG: // Frost grenade
		{
			entity_set_string(id, EV_SZ_viewmodel, g_sModelGrenadeFrost)
		}
		case CSW_SMOKEGRENADE: // Flare grenade
		{
			if(g_bubble[id] || g_zombie[id]) entity_set_string(id, EV_SZ_viewmodel, g_sModel_vGrenadeBubble)
			else entity_set_string(id, EV_SZ_viewmodel, g_sModelGrenadeFlare)
		}
		case CSW_UMP45: if(g_weapon[id][PRIMARY_WEAPON][UMP45]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[0])
		case CSW_MP5NAVY: if(g_weapon[id][PRIMARY_WEAPON][NAVY]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[1])
		case CSW_FAMAS: if(g_weapon[id][PRIMARY_WEAPON][FAMAS]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[2])
		case CSW_GALIL: if(g_weapon[id][PRIMARY_WEAPON][GALIL]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[3])
		case CSW_AUG:
		{
			if(g_weapon[id][PRIMARY_WEAPON][AUG_1]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[4])
			else if(g_weapon[id][PRIMARY_WEAPON][AUG_2]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[13])
		}
		case CSW_SG552:
		{
			if(g_weapon[id][PRIMARY_WEAPON][SG552_1]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[5])
			else if(g_weapon[id][PRIMARY_WEAPON][SG552_2]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[14])
		}
		case CSW_AWP: if(g_weapon[id][PRIMARY_WEAPON][AWP] || g_sniper[id]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[6])
		case CSW_G3SG1: if(g_weapon[id][PRIMARY_WEAPON][G3SG1]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[7])
		case CSW_M249: if(g_weapon[id][PRIMARY_WEAPON][M249]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[8])
		case CSW_AK47: if(g_weapon[id][PRIMARY_WEAPON][AK47]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[9])
		case CSW_M4A1:
		{
			if(!g_weap_leg_choose[id])
			{
				if(g_weapon[id][PRIMARY_WEAPON][COLT_1]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[10])
				else if(g_weapon[id][PRIMARY_WEAPON][COLT_2]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[12])
			}
			else
			{
				if(!g_leg_lvl_vex[id]) entity_set_string(id, EV_SZ_viewmodel, "models/weapon_legends/v_colt_legend_00.mdl")
				else if(g_leg_lvl_vex[id] == 5) entity_set_string(id, EV_SZ_viewmodel, "models/weapon_legends/v_colt_legend_01.mdl")
				else entity_set_string(id, EV_SZ_viewmodel, "models/tcs_colt_2/v_tcs_colt_2.mdl")
			}
		}
		case CSW_XM1014: if(g_weapon[id][PRIMARY_WEAPON][XM1014]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[11])
		case CSW_GLOCK18: if(g_weapon[id][SECONDARY_WEAPON][GLOCK]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[15])
		case CSW_ELITE: if(g_weapon[id][SECONDARY_WEAPON][DUAL]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[16])
		case CSW_P228: if(g_weapon[id][SECONDARY_WEAPON][P228]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[17])
		case CSW_DEAGLE: if(g_weapon[id][SECONDARY_WEAPON][DEAGLE]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[18])
		case CSW_FIVESEVEN: if(g_weapon[id][SECONDARY_WEAPON][FIVESEVEN]) entity_set_string(id, EV_SZ_viewmodel, g_weapon_v_models[19])
		case CSW_SG550:
		{
			if((g_nemesis[id] || g_annihilator[id]) && g_bazooka[id])
			{
				entity_set_string(id, EV_SZ_viewmodel, g_sModel_vBazooka)
				entity_set_string(id, EV_SZ_weaponmodel, g_sModel_pBazooka)
				
				if(!g_annihilator[id])
					client_print(id, print_center, "Modo de disparo: %s", (g_bazooka_mode[id]) ? "Seguimiento" : "Normal");
				
				fn_set_animation(id, 3)
			}
		}
	}
}

// Reset Player Vars
reset_vars(id, resetall)
{
	g_zombie[id] = g_nemesis[id] = g_survivor[id] = g_wesker[id] = g_wesker_laser[id] = g_tribal_human[id] = g_alien[id] = g_predator[id] = g_annihilator[id] =
	g_firstzombie[id] = g_lastzombie[id] = g_lasthuman[id] = g_frozen[id] = g_slowdown[id] = g_nodamage[id] = g_respawn_as_zombie[id] = g_nvision[id] =
	g_nvisionenabled[id] = g_burning_duration[id] = g_unclip[id] = g_longjump[id] = g_grenade[id] = g_bubble[id] = g_bazooka[id] = gl_infects_round[id] =
	gl_infects_no_dmg[id] = gl_fz_in_round[id] = g_bomb_aniq[id] = g_surv_immunity[id] = gl_kill_head[id] = g_dmg_nem[id] = g_bazooka_mode[id] = g_iSelfKill[id] =
	g_buy[id] = g_frozen_acc[id] = g_convert_zombie[id] = g_sniper[id] = g_sniper_power[id] = g_mode[id] = gl_bullets_ok[id] = gl_bullets[id] = gl_dmg_nem_ord[id] = gl_dmg_nem[id] =
	gl_kill_h_swarm[id] = gl_kill_z_swarm[id] = gl_kill_h_avd[id] = gl_kill_z_avd[id] = g_fp[id] = g_speed_reduced[id] = g_wesker_noduck[id] = 0;
	
	g_render[id] = -1;
	
	g_distance_tejosid[id] = 9999.00
	
	g_time_cortamambo[id] = 0.00
	
	new i;
	for(i = 1; i <= g_maxplayers; ++i)
	{
		gl_infect_users[id][i] = 0;
	}
	
	if(!g_annihilation_round)
	{
		g_combo[id] = 0;
		g_combo_damage[id] = 0;
	}
	
	if(resetall)
	{
		g_ammopacks[id] = g_damagedealt[id] = WPN_STARTID = WPN_STARTID_2 = WPN_AUTO_PRI = WPN_AUTO_SEC = WPN_AUTO_TER = MENU_PAGE_EXTRAS = MENU_PAGE_PLAYERS =
		g_zombieclass[id] = g_zombieclassnext[id] = MENU_PAGE_ZCLASS = g_humanclass[id] = g_humanclassnext[id] = MENU_PAGE_HCLASS = MENU_FOR_CLASS_OR_HAB =
		POINT_CLASS = POINT_ITEM = NVG_HUD = MENU_PAGE_OPT_HUD = MENU_PAGE_LIST_LVLS = g_exp[id] = g_hud_eff[id] = g_hud_min[id] = g_hud_abv[id] = g_hud_off[id] =
		g_zr_pj[id] = g_range[id] = LOGRO_CLASS = LOGRO_ITEM = g_ban[id] = MENU_PAGE_HATS = g_register[id] = g_logged[id] = 
		g_bet[id] = g_bet_num[id] = g_bet_done[id] = g_bubble_cost[id] = g_invis[id] = g_wpn_auto_on[id] = g_money[id] = g_money_lose[id] = 
		g_hat_ent[id] = g_view[id] = g_selected_model[id] = RINGS_NECKS = RN = g_hclass_max[id] = g_zclass_max[id] = ZOMBIE_LEVEL_ACEPTED = ZOMBIE_CLASS_ID = MENU_PAGE_ZCLASS_COMP =
		HUMAN_LEVEL_ACEPTED = HUMAN_CLASS_ID = MENU_PAGE_HCLASS_COMP = ZOMBIE_RANGE_ACEPTED = HUMAN_RANGE_ACEPTED = g_pipe[id] = g_kill_zombie[id] = g_infect_human[id] =
		g_dmg_glock[id] = g_happy[id] = g_kill_knife[id] = g_combo[id] = g_combo_damage[id] = g_tp_load[id] = gl_kill_mac10[id] = gl_kill_bazooka[id] = gl_tantime[id] =
		MENU_CHOOSE_MODE_A = MENU_STATS_PAGE = gl_kill_knife[id] = gl_kill_ak[id] = gl_kill_h_nem[id] = gl_kill_z_surv[id] = gl_kill_z_wes[id] = g_logros_completed[id] = g_duel_win_xp[id] = g_bot_question[id] = g_kill_knife_spartan[id] =
		g_dead_health[id] = 0;
		
		sRangoText[id][0] = EOS;
		sLevelText[id][0] = EOS;
		
		g_leet[id] = 0;
		g_chat[id] = 0;
		
		g_weap_leg[id] = 0;
		g_weap_leg_choose[id] = 0;
		
		g_leg_lvl[id] = 1;
		g_leg_lvl_vex[id] = 0;
		g_leg_z_kills[id] = 0;
		g_leg_hits[id] = 0;
		g_leg_dmg[id] = 0;
		g_leg_dmg_nem[id] = 0;
		g_leg_dmg_aniq[id] = 0;
		g_leg_heads[id] = 0;
		
		g_leg_habs[id] = {0, 0, 0, 0, 0}
		
		g_artefactos_equipados[id] = {0, 0, 0, 0}
		
		g_plata_gastada[id] = 0;
		
		new j
		for(j = 0; j < MAX_ITEMS_EXTRAS; j++)
			gl_all_items[id][j] = 0;
		
		for(j = 0; j < 7; j++)
			gl_progress[id][j] = 0.00;
		
		g_gk_num[id] = 2147483646;

		g_fLastCommand[id] = 0.0
		g_fLastCommandLove[id] = 0.0
		g_love_count[id] = 0;
		g_love_count_rec[id] = 0;
		g_love_count_adm[id] = 0;
		g_love_count_staff[id] = 0;
		g_lover[id] = 0;
		g_candy[id] = {0, 0, 0, 0, 0};
		g_candy_count[id] = 0;
		
		g_box[id][box_red] = 0;
		g_box[id][box_green] = 0;
		g_box[id][box_blue] = 0;
		g_box[id][box_yellow] = 0;
		
		g_head_zombie[id][box_red] = 0;
		g_head_zombie[id][box_green] = 0;
		g_head_zombie[id][box_blue] = 0;
		g_head_zombie[id][box_yellow] = 0;
		g_head_zombie[id][box_white] = 0;
		
		g_hud_combo_dmg_total[id] = 1;
		
		new i;
		for(i = 0; i < MAX_CLASS; i++)
		{
			for(j = 0; j < MAX_LOGROS_CLASS[i]; j++)
				g_logro[id][i][j] = 0;
		}
		
		for(i = 0; i < MAX_HATS; i++)
			g_hat[id][i] = 0;
		
		g_hat_equip[id] = -1;
		HAT_ITEM = -1;
		HAT_ITEM_SET = -1;
		
		MENU_PAGE_LOGROS(0) = 0;
		MENU_PAGE_LOGROS(1) = 0;
		MENU_PAGE_LOGROS(2) = 0;
		MENU_PAGE_LOGROS(3) = 0;
		MENU_PAGE_LOGROS(4) = 0;
		
		g_level[id] = 1;
		
		for(i = 0; i < MAX_HAB; i++)
		{
			g_points[id][i] = 0;
			g_points_lose[id][i] = 0;
			
			for(j = 0; j < MAX_HUMAN_HABILITIES; j++)
				g_hab[id][i][j] = 0;
		}
		
		g_color[id][COLOR_NVG] = {255, 255, 255};
		g_color[id][COLOR_HUD] = {0, 0, 255};
		g_color[id][COLOR_LIGHT] = {255, 255, 255};
		g_color[id][COLOR_BUBBLE] = {255, 255, 255};
		g_color[id][COLOR_HUD_COMBO] = {0, 255, 0};
		
		g_hud_pos[id] = Float:{0.02, 0.12, 0.0};
		g_hud_combo_pos[id] = Float:{-1.0, 0.57, 1.0};
		
		g_mult_xp[id] = 1.0;
		g_mult_aps[id] = 1.0;
		g_mult_point[id] = 1;
		
		fnRemoveWeaponsEdit(id, PRIMARY_WEAPON);
		fnRemoveWeaponsEdit(id, SECONDARY_WEAPON);
		g_primary_weapon[id] = -1;
		
		g_time_playing[id] = {0, 0, 0};
		
		for(i = 0; i < ALL_STATS; i++)
			for(j = 0; j < ALL_STATS_MIN; j++)
				g_stats[id][i][j] = 0;
		
		g_mode[id] = NONE;
		
		g_password[id][0] = EOS;
		
		g_antidote_count[id] = 4;
		g_madness_count[id] = 4;
		g_pipe_count[id] = 1;
		
		for(i = 0; i < RING_LIST; i++)
		{
			g_rn[id][RING][i] = 0;
			g_rn_equip[id][RING][i] = 0;
			
			g_rn[id][NECK][i] = 0;
			g_rn_equip[id][NECK][i] = 0;
		}
		
		cub(id, g_data[BIT_PREMIUM]);
		//cub(id, g_data[BIT_CHANGE_NAME]);
	}
}

// Set spectators nightvision
public spec_nvision(id)
{
	// Not connected, alive
	if (!hub(id, g_data[BIT_CONNECTED]) || hub(id, g_data[BIT_ALIVE]))
		return;
	
	g_nvisionenabled[id] = 1
	
	remove_task(id+TASK_NVISION)
	set_task(0.1, "set_user_nvision", id+TASK_NVISION, _, _, "b")
}

// Think HUD
public fw_think_HUD(ent)
{
	new id;
	new id_spec;
	static class[32]
	static buff_hp[15]
	static buff_ap[15]
	static buff_xp[15]
	static Float:xp
	static Float:xp_need
	static Float:xp_need_m1
	static Float:buff_xp_percent
	static buff_min[256]
	static abrev[5]
	
	buff_min[0] = EOS;
	
	for(id = 1; id <= g_maxplayers; id++)
	{
		// Player disconnected?
		if(!hub(id, g_data[BIT_CONNECTED]) || g_hud_off[id]) continue;
		
		id_spec = id;
		
		if(!hub(id, g_data[BIT_ALIVE]))
		{
			id_spec = entity_get_int(id, EV_INT_iuser2);
			
			if(!hub(id_spec, g_data[BIT_ALIVE]))
				continue;
		}
		
		if(id_spec == id)
		{
			// Format classname
			if (g_zombie[id]) // zombies
			{
				if(g_nemesis[id]) formatex(class, charsmax(class), "Nemesis")
				else if(g_alien[id]) formatex(class, charsmax(class), "Alien")
				else if(g_annihilator[id]) formatex(class, charsmax(class), "Aniquilador")
				else copy(class, charsmax(class), g_zombie_classname[id])
			}
			else // humans
			{
				if(g_survivor[id]) formatex(class, charsmax(class), "Survivor")
				else if(g_wesker[id]) formatex(class, charsmax(class), "Wesker")
				else if(g_tribal_human[id]) formatex(class, charsmax(class), "Tribal")
				else if(g_predator[id]) formatex(class, charsmax(class), "Depredador")
				else if(g_sniper[id]) formatex(class, charsmax(class), "Sniper")
				else copy(class, charsmax(class), g_human_classname[id])
			}
			
			add_dot(get_user_health(id), buff_hp, 14)
			add_dot(g_ammopacks[id], buff_ap, 14)
			add_dot(g_exp[id], buff_xp, 14)
			xp = float(g_exp[id])
			xp_need = float((XPNeeded[g_level[id]] * MULT_PER_RANGE))
			xp_need_m1 = float((XPNeeded[g_level[id]-1] * MULT_PER_RANGE))
			buff_xp_percent = ((xp - xp_need_m1) * 100.0) / (xp_need - xp_need_m1)
			
			formatex(abrev, charsmax(abrev), "%s", (g_hud_abv[id]) ? " - " : "^n")
			
			if(g_hud_min[id])
			{
				formatex(buff_min, charsmax(buff_min), "HP: %s%sAP: %d%s%s%sAPs: %s^nXP: %s (%0.2f%%)%sLV: %d%sRNG: %s",
				buff_hp, abrev, get_user_armor(id), abrev, class, abrev, buff_ap, buff_xp, buff_xp_percent, abrev, g_level[id], abrev, g_range_letters[g_range[id]])
			}
			else
			{
				formatex(buff_min, charsmax(buff_min), "Vida: %s%sChaleco: %d%sClase: %s%sAmmo Packs: %s^nExperiencia: %s (%0.2f%%)%sNivel: %d%sRango: %s",
				buff_hp, abrev, get_user_armor(id), abrev, class, abrev, buff_ap, buff_xp, buff_xp_percent, abrev, g_level[id], abrev, g_range_letters[g_range[id]])
			}
			
			set_hudmessage(g_color[id][COLOR_HUD][0], g_color[id][COLOR_HUD][1], g_color[id][COLOR_HUD][2], g_hud_pos[id][0], g_hud_pos[id][1], g_hud_eff[id], 6.0, 1.1, 0.0, 0.0, -1)
		}
		else
		{
			// Format classname
			if (g_zombie[id_spec]) // zombies
			{
				if(g_nemesis[id_spec]) formatex(class, charsmax(class), "Nemesis")
				else if(g_alien[id_spec]) formatex(class, charsmax(class), "Alien")
				else if(g_annihilator[id_spec]) formatex(class, charsmax(class), "Aniquilador")
				else copy(class, charsmax(class), g_zombie_classname[id_spec])
			}
			else // humans
			{
				if(g_survivor[id_spec]) formatex(class, charsmax(class), "Survivor")
				else if(g_wesker[id_spec]) formatex(class, charsmax(class), "Wesker")
				else if(g_tribal_human[id_spec]) formatex(class, charsmax(class), "Tribal")
				else if(g_predator[id_spec]) formatex(class, charsmax(class), "Depredador")
				else if(g_sniper[id_spec]) formatex(class, charsmax(class), "Sniper")
				else copy(class, charsmax(class), g_human_classname[id_spec])
			}
			
			add_dot(get_user_health(id_spec), buff_hp, 14)
			add_dot(g_ammopacks[id_spec], buff_ap, 14)
			add_dot(g_exp[id_spec], buff_xp, 14)
			xp = float(g_exp[id_spec])
			xp_need = float((XPNeeded[g_level[id_spec]] * MULT_PER_RANGE_SPEC(id_spec)))
			xp_need_m1 = float((XPNeeded[g_level[id_spec]-1] * MULT_PER_RANGE_SPEC(id_spec)))
			buff_xp_percent = ((xp - xp_need_m1) * 100.0) / (xp_need - xp_need_m1)
			
			formatex(abrev, charsmax(abrev), "%s", (g_hud_abv[id]) ? " - " : "^n")
			
			if(g_hud_min[id])
			{
				formatex(buff_min, charsmax(buff_min), "HP: %s%sAP: %d%s%s%sAPs: %s^nXP: %s (%0.2f%%)%sLV: %d%sRNG: %s",
				buff_hp, abrev, get_user_armor(id_spec), abrev, class, abrev, buff_ap, buff_xp, buff_xp_percent, abrev, g_level[id_spec], abrev, g_range_letters[g_range[id_spec]])
			}
			else
			{
				formatex(buff_min, charsmax(buff_min), "Vida: %s%sChaleco: %d%sClase: %s%sAmmo Packs: %s^nExperiencia: %s (%0.2f%%)%sNivel: %d%sRango: %s",
				buff_hp, abrev, get_user_armor(id_spec), abrev, class, abrev, buff_ap, buff_xp, buff_xp_percent, abrev, g_level[id_spec], abrev, g_range_letters[g_range[id_spec]])
			}
			
			set_hudmessage(g_color[id][COLOR_HUD][1], g_color[id][COLOR_HUD][1], g_color[id][COLOR_HUD][2], 0.6, 0.7, g_hud_eff[id], 6.0, 1.1, 0.0, 0.0, -1)
		}
		
		ShowSyncHudMsg(id, g_MsgSync2, "%s", buff_min)
	}
	
	entity_set_float(ent, EV_FL_nextthink, TIME_THINK_HUD);
}

// Think Leader Combo Human
public fw_think_LEADER_COMBOH(ent)
{
	CC(0, "!g[ZP]!t %s!y es líder en combo con un máximo de !g%s combos!y", g_combo_leader_name, g_combo_leader_text)
	entity_set_float(ent, EV_FL_nextthink, TIME_THINK_LEADER);
}

public fw_think_TanTime(ent)
{
#if defined EVENT_AMOR
	new i;
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!hub(i, g_data[BIT_CONNECTED]))
			continue;
		
		if(fm_cs_get_user_team(i) == FM_CS_TEAM_SPECTATOR || fm_cs_get_user_team(i) == FM_CS_TEAM_UNASSIGNED)
			continue;
		
		g_lover[i] = 0;
		
		if(!g_ur)
			continue;
			
		gl_tantime[i]++; // 318 o más
		
		if(gl_tantime[i] == 318)
			fn_update_logro(i, LOGRO_OTHERS, SOY_MUY_VICIADO);
	}
#else
	if(g_ur)
	{
		new i;
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(!hub(i, g_data[BIT_CONNECTED]))
				continue;
			
			if(fm_cs_get_user_team(i) == FM_CS_TEAM_SPECTATOR || fm_cs_get_user_team(i) == FM_CS_TEAM_UNASSIGNED)
				continue;
			
			gl_tantime[i]++; // 318 o más
			
			if(gl_tantime[i] == 318)
				fn_update_logro(i, LOGRO_OTHERS, SOY_MUY_VICIADO);
		}
	}
#endif
	
	entity_set_float(ent, EV_FL_nextthink, TIME_THINK_TANTIME);
}

// Think Leader Vicius
public fw_think_LEADER_VICIUS(ent)
{
	CC(0, "!g[ZP]!t %s!y es el más viciado del servidor con: %s", g_leader_vicius_name, g_leader_vicius_days_t)
	entity_set_float(ent, EV_FL_nextthink, TIME_THINK_LEADER + 60.0);
}

// Think Leader
public fw_think_LEADER(ent)
{
	CC(0, "!g[ZP]!t %s!y está liderando en !gRango %s!y con !g%d niveles!y y !g%s XP!y", g_leader_name, g_range_letters[g_leader_range], g_leader_level, g_leader_xp_text)
	entity_set_float(ent, EV_FL_nextthink, TIME_THINK_LEADER + 120.0);
}

public fw_think_LEADER_LOGROS(ent)
{
	CC(0, "!g[ZP]!t %s!y es lider en logros con un máximo de !g%d logros!y", g_leader_logros_name, g_leader_logros_count)
	entity_set_float(ent, EV_FL_nextthink, TIME_THINK_LEADER + 180.0);
}

// Think Lottery
public fw_think_LOTTERY(ent)
{
	CC(0, "!g[ZP]!y Recordá que podes jugar a la !g/lotería!y para ganar experiencia!")
	entity_set_float(ent, EV_FL_nextthink, TIME_THINK_LEADER + 240.0);
}

// Think Vinc
public fw_think_VINC(ent)
{
	new i;
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!hub(i, g_data[BIT_CONNECTED]))
			continue;
		
		if(g_vinc[i])
			continue;
		
		CC(i, "!g[ZP]!y Recordá vincular tu cuenta a la del foro para tener más opciones sobre tu cuenta")
		CC(i, "!g[ZP]!y Recordá también que si pierdes la contraseña, es la única manera de recuperarla")
	}
	
	entity_set_float(ent, EV_FL_nextthink, TIME_THINK_LEADER + 300.0);
}

// Play idle zombie sounds
/*public zombie_play_idle(taskid)
{
	// Round ended/new one starting
	if (g_endround || g_newround)
		return;
	
	// Last zombie?
	if(g_lastzombie[ID_BLOOD])
		emit_sound(ID_BLOOD, CHAN_VOICE, g_sSoundZombieIdleLast[random_num(0, charsmax(g_sSoundZombieIdleLast))], 1.0, ATTN_NORM, 0, PITCH_NORM)
	else
		emit_sound(ID_BLOOD, CHAN_VOICE, g_sSoundZombieIdle[random_num(0, charsmax(g_sSoundZombieIdle))], 1.0, ATTN_NORM, 0, PITCH_NORM)
}*/

// Madness Over Task
public madness_over(taskid)
{
	g_nodamage[ID_BLOOD] = 0
}

// Place user at a random spawn
do_random_spawn(id, regularspawns = 0)
{
	static hull, sp_index, i
	
	// Get whether the player is crouching
	hull = (get_entity_flags(id) & FL_DUCKING) ? HULL_HEAD : HULL_HUMAN
	
	// Use regular spawns?
	if (!regularspawns)
	{
		// No spawns?
		if (!g_spawnCount)
			return;
		
		// Choose random spawn to start looping at
		sp_index = random_num(0, g_spawnCount - 1)
		
		// Try to find a clear spawn
		for (i = sp_index + 1; /*no condition*/; i++)
		{
			// Start over when we reach the end
			if (i >= g_spawnCount) i = 0
			
			// Free spawn space?
			if (is_hull_vacant(g_spawns[i], hull))
			{
				// Engfunc_SetOrigin is used so ent's mins and maxs get updated instantly
				engfunc(EngFunc_SetOrigin, id, g_spawns[i])
				break;
			}
			
			// Loop completed, no free space found
			if (i == sp_index) break;
		}
	}
	else
	{
		// No spawns?
		if (!g_spawnCount2)
			return;
		
		// Choose random spawn to start looping at
		sp_index = random_num(0, g_spawnCount2 - 1)
		
		// Try to find a clear spawn
		for (i = sp_index + 1; /*no condition*/; i++)
		{
			// Start over when we reach the end
			if (i >= g_spawnCount2) i = 0
			
			// Free spawn space?
			if (is_hull_vacant(g_spawns2[i], hull))
			{
				// Engfunc_SetOrigin is used so ent's mins and maxs get updated instantly
				engfunc(EngFunc_SetOrigin, id, g_spawns2[i])
				break;
			}
			
			// Loop completed, no free space found
			if (i == sp_index) break;
		}
	}
}

// Get Zombies -returns alive zombies number-
fnGetZombies()
{
	static iZombies, id
	iZombies = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (hub(id, g_data[BIT_ALIVE]) && g_zombie[id])
			iZombies++
	}
	
	return iZombies;
}

// Get Humans -returns alive humans number-
fnGetHumans()
{
	static iHumans, id
	iHumans = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (hub(id, g_data[BIT_ALIVE]) && !g_zombie[id])
			iHumans++
	}
	
	return iHumans;
}

fnGetAl1ve()
{
	static iHumans, id
	iHumans = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (is_user_alive(id))
			iHumans++
	}
	
	return iHumans;
}

// Get Nemesis -returns alive nemesis number-
/*fnGetNemesis()
{
	static iNemesis, id
	iNemesis = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (hub(id, g_data[BIT_ALIVE]) && g_nemesis[id])
			iNemesis++
	}
	
	return iNemesis;
}

// Get Survivors -returns alive survivors number-
fnGetSurvivors()
{
	static iSurvivors, id
	iSurvivors = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (hub(id, g_data[BIT_ALIVE]) && g_survivor[id])
			iSurvivors++
	}
	
	return iSurvivors;
}*/

// Get Alive -returns alive players number-
fnGetAlive()
{
	static iAlive, id
	iAlive = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (hub(id, g_data[BIT_ALIVE]))
			iAlive++
	}
	
	return iAlive;
}

// Get Random Alive -returns index of alive player number n -
fnGetRandomAlive(n)
{
	static iAlive, id
	iAlive = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if(hub(id, g_data[BIT_ALIVE]))
			iAlive++
		
		if(iAlive == n)
			return id;
	}
	
	return -1;
}

// Get Playing -returns number of players playing-
fnGetPlaying()
{
	static iPlaying, id, team
	iPlaying = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (hub(id, g_data[BIT_CONNECTED]))
		{
			team = fm_cs_get_user_team(id)
			
			if (team != FM_CS_TEAM_SPECTATOR && team != FM_CS_TEAM_UNASSIGNED)
				iPlaying++
		}
	}
	
	return iPlaying;
}

// Get CTs -returns number of CTs connected-
fnGetCTs()
{
	static iCTs, id
	iCTs = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (hub(id, g_data[BIT_CONNECTED]))
		{			
			if (fm_cs_get_user_team(id) == FM_CS_TEAM_CT)
				iCTs++
		}
	}
	
	return iCTs;
}

// Get Ts -returns number of Ts connected-
fnGetTs()
{
	static iTs, id
	iTs = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (hub(id, g_data[BIT_CONNECTED]))
		{			
			if (fm_cs_get_user_team(id) == FM_CS_TEAM_T)
				iTs++
		}
	}
	
	return iTs;
}

// Get Alive CTs -returns number of CTs alive-
fnGetAliveCTs()
{
	static iCTs, id
	iCTs = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (hub(id, g_data[BIT_ALIVE]))
		{			
			if (fm_cs_get_user_team(id) == FM_CS_TEAM_CT)
				iCTs++
		}
	}
	
	return iCTs;
}

// Get Alive Ts -returns number of Ts alive-
fnGetAliveTs()
{
	static iTs, id
	iTs = 0
	
	for (id = 1; id <= g_maxplayers; id++)
	{
		if (hub(id, g_data[BIT_ALIVE]))
		{			
			if (fm_cs_get_user_team(id) == FM_CS_TEAM_T)
				iTs++
		}
	}
	
	return iTs;
}

// Last Zombie Check -check for last zombie and set its flag-
fnCheckLastZombie()
{
	static id
	for(id = 1; id <= g_maxplayers; id++)
	{
		// Last zombie
		if(hub(id, g_data[BIT_ALIVE]) && g_zombie[id] && !g_nemesis[id] && !g_alien[id] && !g_annihilator[id] && fnGetZombies() == 1) g_lastzombie[id] = 1
		else g_lastzombie[id] = 0
		
		// Last human
		if(hub(id, g_data[BIT_ALIVE]) && !g_zombie[id] && !g_survivor[id] && !g_wesker[id] && !g_sniper[id] && !g_tribal_human[id] && !g_predator[id] && fnGetHumans() == 1) g_lasthuman[id] = 1
		else g_lasthuman[id] = 0
	}
}

// Checks if a player is allowed to be zombie
allowed_zombie(id)
{
	if (/*g_nemesis[id] || g_alien[id] || g_annihilator[id] || */g_endround || !hub(id, g_data[BIT_ALIVE]) || task_exists(TASK_WELCOMEMSG) || (!g_newround && !g_zombie[id] && fnGetHumans() == 1))
		return 0;
	
	return 1;
}

// Checks if a player is allowed to be human
allowed_human(id)
{
	if (/*g_survivor[id] || g_wesker[id] || g_sniper[id] || g_tribal_human[id] || g_predator[id] || */g_endround || !hub(id, g_data[BIT_ALIVE]) || task_exists(TASK_WELCOMEMSG) || (!g_newround && g_zombie[id] && fnGetZombies() == 1))
		return 0;
	
	return 1;
}

// Checks if a player is allowed to be survivor
allowed_survivor(id)
{
	if (g_endround || /*g_survivor[id] ||*/ !hub(id, g_data[BIT_ALIVE]) || task_exists(TASK_WELCOMEMSG) || (!g_newround && g_zombie[id] && fnGetZombies() == 1))
		return 0;
	
	return 1;
}

// Checks if a player is allowed to be nemesis
allowed_nemesis(id)
{
	if (g_endround || /*g_nemesis[id] ||*/ !hub(id, g_data[BIT_ALIVE]) || task_exists(TASK_WELCOMEMSG) || (!g_newround && !g_zombie[id] && fnGetHumans() == 1))
		return 0;
	
	return 1;
}

// Checks if a player is allowed to respawn
allowed_respawn(id)
{
	static team
	team = fm_cs_get_user_team(id)
	
	if (g_endround || team == FM_CS_TEAM_SPECTATOR || team == FM_CS_TEAM_UNASSIGNED || hub(id, g_data[BIT_ALIVE]))
		return 0;
	
	return 1;
}

// Checks if a player is allowed to be wesker
allowed_wesker(id)
{
	if (g_endround || /*g_wesker[id] ||*/ !hub(id, g_data[BIT_ALIVE]) || task_exists(TASK_WELCOMEMSG) || (!g_newround && g_zombie[id] && fnGetZombies() == 1))
		return 0;
	
	return 1;
}

// Checks if a player is allowed to be sniper
allowed_sniper(id)
{
	if (g_endround || /*g_sniper[id] ||*/ !hub(id, g_data[BIT_ALIVE]) || task_exists(TASK_WELCOMEMSG) || (!g_newround && g_zombie[id] && fnGetZombies() == 1))
		return 0;
	
	return 1;
}

// Checks if a player is allowed to be annihilator
allowed_annihilation(id)
{
	if (g_endround || /*g_annihilator[id] ||*/ !hub(id, g_data[BIT_ALIVE]) || task_exists(TASK_WELCOMEMSG) || (!g_newround && !g_zombie[id] && fnGetHumans() == 1))
		return 0;
	
	return 1;
}

// Checks if swarm mode is allowed
allowed_swarm()
{
	if (g_endround || !g_newround || task_exists(TASK_WELCOMEMSG))
		return 0;
	
	return 1;
}

// Checks if multi infection mode is allowed
allowed_multi()
{
	if (g_endround || !g_newround || task_exists(TASK_WELCOMEMSG) || floatround(fnGetAlive()*0.3, floatround_ceil) < 2 || floatround(fnGetAlive()*0.3, floatround_ceil) >= fnGetAlive())
		return 0;
	
	return 1;
}

// Checks if plague mode is allowed
allowed_plague()
{
	if (g_endround || !g_newround || task_exists(TASK_WELCOMEMSG) || floatround((fnGetAlive()-4)*0.5, floatround_ceil) < 1
	|| fnGetAlive()-(4+floatround((fnGetAlive()-4)*0.5, floatround_ceil)) < 1)
		return 0;
	
	return 1;
}

// Checks if armageddon mode is allowed
allowed_armageddon()
{
	if (g_endround || !g_newround || task_exists(TASK_WELCOMEMSG) || fnGetAlive() < 1)
		return 0;
	
	return 1;
}

// Checks if tribal mode is allowed
allowed_tribal()
{
	if (g_endround || !g_newround || task_exists(TASK_WELCOMEMSG) || fnGetAlive() < 3)
		return 0;
	
	return 1;
}

// Checks if alien vs predator mode is allowed
allowed_alvspred()
{
	if (g_endround || !g_newround || task_exists(TASK_WELCOMEMSG) || fnGetAlive() < 15)
		return 0;
	
	return 1;
}

// Checks if a player is allowed to recive rewards
allowed_gave_rewards(id, level, range)
{
	static team;
	team = fm_cs_get_user_team(id);
	
	if(level == 1 && range == 0)
		return 1;
	
	if(level < 1 || level > MAX_LVL || range < 0 || range > (MAX_CHARS-1))
		return 0;
	
	if(!hub(id, g_data[BIT_CONNECTED]) || !g_logged[id] || team == FM_CS_TEAM_SPECTATOR || team == FM_CS_TEAM_UNASSIGNED)
		return 0;
	
	return 1;
}

// Admin Command. zp_zombie
command_zombie(player)
{
	// New round?
	if (g_newround)
	{
		// Set as first zombie
		remove_task(TASK_MAKEZOMBIE)
		make_a_zombie(MODE_INFECTION, player)
	}
	else
	{
		// Just infect
		zombieme(player, 0, 0, 0, 0, 0, 0, 0)
	}
}

// Admin Command. zp_human
command_human(player)
{
	// Turn to human
	humanme(player, 0, 0, 0, 0, 0, 0)
}

// Admin Command. zp_survivor
command_survivor(player)
{
	// New round?
	if (g_newround)
	{
		// Set as first survivor
		remove_task(TASK_MAKEZOMBIE)
		make_a_zombie(MODE_SURVIVOR, player)
	}
	else
	{
		// Turn player into a Survivor
		humanme(player, 1, 0, 0, 0, 0, 0)
	}
}

// Admin Command. zp_nemesis
command_nemesis(player)
{
	// New round?
	if (g_newround)
	{
		// Set as first nemesis
		remove_task(TASK_MAKEZOMBIE)
		make_a_zombie(MODE_NEMESIS, player)
	}
	else
	{
		// Turn player into a Nemesis
		zombieme(player, 0, 1, 0, 0, 0, 0, 0)
	}
}

command_fpee(player)
{
	if (g_newround)
	{
		g_fp_id = player;
		g_fp_acomodado = 1;
		remove_task(TASK_MAKEZOMBIE)
		make_a_zombie(MODE_FP, 0)
	}
}

// Admin Command. zp_wesker
command_wesker(player)
{
	// New round?
	if (g_newround)
	{
		// Set as first wesker
		remove_task(TASK_MAKEZOMBIE)
		make_a_zombie(MODE_WESKER, player)
	}
	else
	{
		// Turn player into a Wesker
		humanme(player, 0, 0, 1, 0, 0, 0)
	}
}

// Admin Command. zp_annihilator
command_annihilation(player)
{
	// New round?
	if (g_newround)
	{
		// Set as first annihilator
		remove_task(TASK_MAKEZOMBIE)
		make_a_zombie(MODE_ANNIHILATION, player)
	}
	else
	{
		// Turn player into a Annihilator
		zombieme(player, 0, 0, 0, 0, 0, 1, 0)
	}
}

// Admin Command. zp_sniper
command_sniper(player)
{
	// New round?
	if (g_newround)
	{
		// Set as first wesker
		remove_task(TASK_MAKEZOMBIE)
		make_a_zombie(MODE_SNIPER, player)
	}
	else
	{
		// Turn player into a Wesker
		humanme(player, 0, 0, 0, 0, 0, 1)
	}
}

// Admin Command. zp_respawn
command_respawn(player)
{
	// Respawn as zombie?
	if(fnGetZombies() < fnGetAlive()/2)
		g_respawn_as_zombie[player] = 1
	
	// Override respawn as zombie setting on nemesis and survivor rounds
	if(g_survround || g_wesker_round || g_sniper_round ||g_tribal_round || g_alvspre_round) g_respawn_as_zombie[player] = 1
	else if(g_nemround || g_annihilation_round || g_fp_round) g_respawn_as_zombie[player] = 0
	else if(g_armageddon_round) g_respawn_as_zombie[player] = 2
	
	respawn_player_manually(player);
}

command_duel()
{
	// Call Swarm Mode
	remove_task(TASK_MAKEZOMBIE)
	make_a_zombie(MODE_DUEL, 0)
}

// Admin Command. zp_swarm
command_swarm()
{
	// Call Swarm Mode
	remove_task(TASK_MAKEZOMBIE)
	make_a_zombie(MODE_SWARM, 0)
}

// Admin Command. zp_multi
command_multi()
{
	// Call Multi Infection
	remove_task(TASK_MAKEZOMBIE)
	make_a_zombie(MODE_MULTI, 0)
}

// Admin Command. zp_plague
command_plague()
{
	// Call Plague Mode
	remove_task(TASK_MAKEZOMBIE)
	make_a_zombie(MODE_PLAGUE, 0)
}

// Admin Command. zp_armageddon
command_armageddon()
{
	// Call Armageddon Mode
	remove_task(TASK_MAKEZOMBIE)
	make_a_zombie(MODE_ARMAGEDDON, 0)
}

// Admin Command. zp_tribal
command_tribal()
{
	// Call Tribal Mode
	remove_task(TASK_MAKEZOMBIE)
	make_a_zombie(MODE_TRIBAL, 0)
}

command_fp()
{
	// Call Tribal Mode
	remove_task(TASK_MAKEZOMBIE)
	make_a_zombie(MODE_FP, 0)
}

// Admin Command. zp_alvspred
command_alvspred()
{
	// Call Alien vs Predator Mode
	remove_task(TASK_MAKEZOMBIE)
	make_a_zombie(MODE_ALVSPRED, 0)
}

// Set proper maxspeed for player
set_player_maxspeed(id)
{
	if(!is_user_connected(id))
		return;
	
	if(g_frozen[id] || (g_block_speed && !check_access(id, 1))) set_user_maxspeed(id, 1.0)
	else if(g_slowdown[id]) set_user_maxspeed(id, 170.0)
	else
	{
		if(g_zombie[id])
		{
			if(g_nemesis[id]) set_user_maxspeed(id, 275.0)
			else if(g_alien[id]) set_user_maxspeed(id, 500.0)
			else if(g_annihilator[id]) set_user_maxspeed(id, 300.0)
			else if(g_fp[id]) set_user_maxspeed(id, (g_fp_power == 2) ? 999.0 : 170.0)
			else if(g_burning_duration[id] > 0) set_user_maxspeed(id, (g_hab[id][HAB_ZOMBIE][ZOMBIE_FIRE] >= 2) ? 240.0 : 200.0)
			else set_user_maxspeed(id, g_zombie_spd[id])
		}
		else
		{
			if(g_survivor[id]) set_user_maxspeed(id, 275.0)
			else if(g_wesker[id]) set_user_maxspeed(id, 240.0)
			else if(g_speed_reduced[id]) set_user_maxspeed(id, 50.0)
			else if(g_tribal_human[id]) set_user_maxspeed(id, 300.0)
			else if(g_predator[id]) set_user_maxspeed(id, 350.0)
			else set_user_maxspeed(id, g_human_spd[id])
		}
	}
}

/*================================================================================
 [Custom Natives]
=================================================================================*/
// Function: zp_register_zombie_class (to be used within this plugin only)
native_register_zombie_class(const name[], const model[], const clawmodel[], hp, speed, Float:gravity, Float:damage, level, range, premium)
{
	// Add the class
	ArrayPushString(g_zclass_name, name)
	
	ArrayPushString(g_zclass_playermodel, model)
	
	ArrayPushString(g_zclass_clawmodel, clawmodel)
	ArrayPushCell(g_zclass_hp, hp)
	ArrayPushCell(g_zclass_spd, speed)
	ArrayPushCell(g_zclass_grav, gravity)
	ArrayPushCell(g_zclass_dmg, damage)
	ArrayPushCell(g_zclass_level, level)
	ArrayPushCell(g_zclass_range, range)
	ArrayPushCell(g_zclass_premium, premium)
	
	new prec_mdl[100]
	
	formatex(prec_mdl, charsmax(prec_mdl), "models/player/%s/%s.mdl", model, model)
	precache_model(prec_mdl)
	
	formatex(prec_mdl, charsmax(prec_mdl), "models/zombie_plague/%s", clawmodel)
	precache_model(prec_mdl)
	
	// Increase registered classes counter
	g_zclass_i++
}

// Function: zp_register_human_class (to be used within this plugin only)
native_register_human_class(const name[], const model[], hp, speed, Float:gravity, Float:damage, level, range, premium)
{
	// Add the class
	ArrayPushString(g_hclass_name, name)
	
	ArrayPushString(g_hclass_playermodel, model)
	
	ArrayPushCell(g_hclass_hp, hp)
	ArrayPushCell(g_hclass_spd, speed)
	ArrayPushCell(g_hclass_grav, gravity)
	ArrayPushCell(g_hclass_dmg, damage)
	ArrayPushCell(g_hclass_level, level)
	ArrayPushCell(g_hclass_range, range)
	ArrayPushCell(g_hclass_premium, premium)
	
	new prec_mdl[100]
	
	formatex(prec_mdl, charsmax(prec_mdl), "models/player/%s/%s.mdl", model, model)
	precache_model(prec_mdl)
	
	copy(prec_mdl[strlen(prec_mdl)-4], charsmax(prec_mdl) - (strlen(prec_mdl)-4), "T.mdl")
	if(file_exists(prec_mdl)) precache_model(prec_mdl)
	
	// Increase registered classes counter
	g_hclass_i++
}

/*================================================================================
 [Custom Messages]
=================================================================================*/

// Custom Night Vision
public set_user_nvision(taskid)
{
	// Get player's origin
	static origin[3]
	get_user_origin(ID_NVISION, origin)
	
	// Nightvision message
	message_begin(MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, _, ID_NVISION)
	write_byte(TE_DLIGHT) // TE id
	write_coord(origin[0]) // x
	write_coord(origin[1]) // y
	write_coord(origin[2]) // z
	write_byte(80) // radius
	
	// Nemesis / Madness / Spectator in nemesis round
	if(g_nemesis[ID_NVISION] || g_alien[ID_NVISION] || (g_zombie[ID_NVISION] && g_nodamage[ID_NVISION]) || (!hub(ID_NVISION, g_data[BIT_ALIVE]) && g_nemround))
	{
		write_byte(200) // r
		write_byte(0) // g
		write_byte(0) // b
	}
	else if(g_annihilator[ID_NVISION] || (!hub(ID_NVISION, g_data[BIT_ALIVE]) && g_annihilation_round))
	{
		write_byte(255) // r
		write_byte(255) // g
		write_byte(255) // b
	}
	// Human / Spectator in normal round
	else
	{
		write_byte(g_color[ID_NVISION][COLOR_NVG][0]) // r
		write_byte(g_color[ID_NVISION][COLOR_NVG][1]) // g
		write_byte(g_color[ID_NVISION][COLOR_NVG][2]) // b
	}
	write_byte(2) // life
	write_byte(0) // decay rate
	message_end()
}

// Infection special effects
public infection_effects(id)
{
	// Screen fade? (unless frozen)
	if(!g_frozen[id])
	{
		message_begin(MSG_ONE_UNRELIABLE, g_msgScreenFade, _, id)
		write_short(UNIT_SECOND) // duration
		write_short(0) // hold time
		write_short(FFADE_IN) // fade type
		write_byte(0) // r
		write_byte(200) // g
		write_byte(0) // b
		write_byte(255) // alpha
		message_end()
	}

	message_begin(MSG_ONE_UNRELIABLE, g_msgScreenShake, _, id)
	write_short(UNIT_SECOND*4) // amplitude
	write_short(UNIT_SECOND*2) // duration
	write_short(UNIT_SECOND*10) // frequency
	message_end()
	
	// Get player's origin
	new origin[3]
	get_user_origin(id, origin)
	
	/*message_begin(MSG_PVS, SVC_TEMPENTITY, origin)
	write_byte(TE_IMPLOSION) // TE id
	write_coord(origin[0]) // x
	write_coord(origin[1]) // y
	write_coord(origin[2]) // z
	write_byte(128) // radius
	write_byte(20) // count
	write_byte(3) // duration
	message_end()*/
	
	message_begin(MSG_PVS, SVC_TEMPENTITY, origin)
	write_byte(TE_PARTICLEBURST) // TE id
	write_coord(origin[0]) // x
	write_coord(origin[1]) // y
	write_coord(origin[2]) // z
	write_short(50) // radius
	write_byte(70) // color
	write_byte(3) // duration (will be randomized a bit)
	message_end()
	
	/*message_begin(MSG_PVS, SVC_TEMPENTITY, origin)
	write_byte(TE_DLIGHT) // TE id
	write_coord(origin[0]) // x
	write_coord(origin[1]) // y
	write_coord(origin[2]) // z
	write_byte(20) // radius
	write_byte(g_color[id][COLOR_NVG][0]) // r
	write_byte(g_color[id][COLOR_NVG][1]) // g
	write_byte(g_color[id][COLOR_NVG][2]) // b
	write_byte(2) // life
	write_byte(0) // decay rate
	message_end()*/
}

// Nemesis/madness aura task
public zombie_aura(taskid)
{
	// Not nemesis, not in zombie madness
	if(!g_nemesis[ID_AURA] && !g_nodamage[ID_AURA] && !g_annihilator[ID_AURA] && !g_fp[ID_AURA])
	{
		// Task not needed anymore
		remove_task(taskid);
		return;
	}
	
	// Get player's origin
	static origin[3]
	get_user_origin(ID_AURA, origin)
	
	// Colored Aura
	message_begin(MSG_PVS, SVC_TEMPENTITY, origin)
	write_byte(TE_DLIGHT) // TE id
	write_coord(origin[0]) // x
	write_coord(origin[1]) // y
	write_coord(origin[2]) // z
	if(g_annihilator[ID_AURA])
	{
		write_byte(35) // radius
		write_byte(255) // r
		write_byte(255) // g
		write_byte(255) // b
	}
	else if(g_fp[ID_AURA])
	{
		write_byte(15) // radius
		write_byte(255) // r
		write_byte(255) // g
		write_byte(255) // b
	}
	else
	{
		write_byte(30) // radius
		write_byte(255) // r
		write_byte(0) // g
		write_byte(0) // b
	}
	write_byte(2) // life
	write_byte(0) // decay rate
	message_end()
}

// Survivor/wesker aura task
public human_aura(taskid)
{
	// Not survivor and not wesker
	if (!hub(ID_AURA, g_data[BIT_ALIVE]) && !g_survivor[ID_AURA] && !g_wesker[ID_AURA] && !g_sniper[ID_AURA] && !g_tribal_human[ID_AURA] && !g_predator[ID_AURA])
	{
		// Task not needed anymore
		remove_task(taskid);
		return;
	}
	
	// Get player's origin
	static origin[3], rgb[3]
	get_user_origin(ID_AURA, origin)
	
	// Colored Aura
	message_begin(MSG_PVS, SVC_TEMPENTITY, origin)
	write_byte(TE_DLIGHT) // TE id
	write_coord(origin[0]) // x
	write_coord(origin[1]) // y
	write_coord(origin[2]) // z
	if(!g_predator[ID_AURA] && !g_wesker[ID_AURA] && !g_sniper[ID_AURA])
		write_byte(35) // radius
	else
		write_byte(50)
	if(g_survivor[ID_AURA])
	{
		if(!g_nodamage[ID_AURA]) rgb = {0, 0, 200}
		else rgb = {255, 255, 255}
	}
	else if(g_wesker[ID_AURA])
	{
		if(!g_hab[ID_AURA][HAB_OTHER][OTHER_ULTRA_LASER]) rgb = {0, 200, 200}
		else rgb = {200, 200, 0}
	}
	else if(g_tribal_human[ID_AURA]) rgb = {200, 0, 200}
	else if(g_predator[ID_AURA]) rgb = {255, 255, 0}
	else if(g_sniper[ID_AURA]) rgb = {0, 200, 0}
	write_byte(rgb[0]) // r
	write_byte(rgb[1]) // g
	write_byte(rgb[2]) // b
	write_byte(2) // life
	write_byte(0) // decay rate
	message_end()
	
	if(g_tribal_human[ID_AURA])
	{
		if(get_user_health(ID_AURA) < 2000)
			set_user_health(ID_AURA, get_user_health(ID_AURA) + 1);
	}
	else if(g_sniper[ID_AURA] && g_sniper_power[ID_AURA] == 1)
	{
		message_begin(MSG_PVS, SVC_TEMPENTITY, origin);
		write_byte(TE_IMPLOSION);
		write_coord(origin[0]);
		write_coord(origin[1]);
		write_coord(origin[2]);
		write_byte(128);
		write_byte(20);
		write_byte(3);
		message_end()
	}
}

// Flare Lighting Effects
flare_lighting(entity, duration, flaresize)
{
	// Get origin and color
	static Float:originF[3], Float:color[3], id
	
	entity_get_vector(entity, EV_VEC_origin, originF)
	entity_get_vector(entity, EV_FLARE_COLOR, color)
	id = entity_get_edict(entity, EV_ENT_owner)
	
	// Lighting
	engfunc(EngFunc_MessageBegin, MSG_PAS, SVC_TEMPENTITY, originF, 0)
	write_byte(TE_DLIGHT) // TE id
	engfunc(EngFunc_WriteCoord, originF[0]) // x
	engfunc(EngFunc_WriteCoord, originF[1]) // y
	engfunc(EngFunc_WriteCoord, originF[2]) // z
	write_byte(flaresize + g_hab[id][HAB_HUMAN][HUMAN_AURA]) // radius
	write_byte(floatround(color[0])) // r
	write_byte(floatround(color[1])) // g
	write_byte(floatround(color[2])) // b
	write_byte(21) //life
	write_byte((duration < 3) ? 10 : 0) //decay rate
	/*if(flaresize != 18) 
	else write_byte((duration < 23) ? 10 : 0) //decay rate*/
	message_end()
}

// Burning Flames
public burning_flame(taskid)
{
	// Get player origin and flags
	static origin[3], flags
	get_user_origin(ID_BURN, origin)
	flags = get_entity_flags(ID_BURN)
	
	// Madness mode - in water - burning stopped
	if(g_nodamage[ID_BURN] || (flags & FL_INWATER) || g_burning_duration[ID_BURN] < 1 || (g_frozen[ID_BURN] && g_hab[ID_BURN][HAB_ZOMBIE][ZOMBIE_FROZEN] >= 3) ||
	g_annihilator[ID_BURN])
	{
		// Smoke sprite
		message_begin(MSG_PVS, SVC_TEMPENTITY, origin)
		write_byte(TE_SMOKE) // TE id
		write_coord(origin[0]) // x
		write_coord(origin[1]) // y
		write_coord(origin[2]-50) // z
		write_short(g_smokeSpr) // sprite
		write_byte(random_num(15, 20)) // scale
		write_byte(random_num(10, 20)) // framerate
		message_end()
		
		// Set zombie not fire maxspeed
		ExecuteHamB(Ham_Player_ResetMaxSpeed, ID_BURN)
		
		// Task not needed anymore
		remove_task(taskid);
		return;
	}
	
	// Randomly play burning zombie scream sounds (not for nemesis)
	if (!g_nemesis[ID_BURN] && !g_alien[ID_BURN] && !random_num(0, 20))
		emit_sound(ID_BURN, CHAN_VOICE, g_sSoundGrenadeFirePlayer[random_num(0, charsmax(g_sSoundGrenadeFirePlayer))], 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	// Fire slow down, unless nemesis
	if(!g_nemesis[ID_BURN] && !g_alien[ID_BURN] && (flags & FL_ONGROUND))
	{
		// Set zombie fire maxspeed
		ExecuteHamB(Ham_Player_ResetMaxSpeed, ID_BURN)
	}
	
	// Flame sprite
	message_begin(MSG_PVS, SVC_TEMPENTITY, origin)
	write_byte(TE_SPRITE) // TE id
	write_coord(origin[0]+random_num(-5, 5)) // x
	write_coord(origin[1]+random_num(-5, 5)) // y
	write_coord(origin[2]+random_num(-10, 10)) // z
	write_short(g_flameSpr) // sprite
	write_byte(random_num(5, 10)) // scale
	write_byte(200) // brightness
	message_end()
	
	// Decrease burning duration counter
	g_burning_duration[ID_BURN]--
	
	if(g_rn_equip[ID_BURN][NECK][NECK_FIRE])
		return;
	
	// Get player's health
	static health, health_min
	health = get_user_health(ID_BURN)
	health_min = (g_hab[ID_BURN][HAB_ZOMBIE][ZOMBIE_FIRE] >= 1) ? 30 : 50
	
	// Take damage from the fire
	if ((health - health_min) > 0)
		set_user_health(ID_BURN, health - health_min)
}

// Color Blast
create_blast(const Float:originF[3], red, green, blue)
{
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0)
	write_byte(TE_BEAMCYLINDER) // TE id
	engfunc(EngFunc_WriteCoord, originF[0]) // x
	engfunc(EngFunc_WriteCoord, originF[1]) // y
	engfunc(EngFunc_WriteCoord, originF[2]) // z
	engfunc(EngFunc_WriteCoord, originF[0]) // x axis
	engfunc(EngFunc_WriteCoord, originF[1]) // y axis
	engfunc(EngFunc_WriteCoord, originF[2]+470.0) // z axis
	write_short(g_exploSpr) // sprite
	write_byte(0) // startframe
	write_byte(0) // framerate
	write_byte(4) // life
	write_byte(60) // width
	write_byte(0) // noise
	write_byte(red) // red
	write_byte(green) // green
	write_byte(blue) // blue
	write_byte(200) // brightness
	write_byte(0) // speed
	message_end()
}

// Fix Dead Attrib on scoreboard
FixDeadAttrib(id)
{
	message_begin(MSG_BROADCAST, g_msgScoreAttrib)
	write_byte(id) // id
	write_byte(0) // attrib
	message_end()
}

// Send Death Message for infections
SendDeathMsg(attacker, victim)
{
	message_begin(MSG_BROADCAST, g_msgDeathMsg)
	write_byte(attacker) // killer
	write_byte(victim) // victim
	write_byte(1) // headshot flag
	write_string("infection") // killer's weapon
	message_end()
	
	entity_set_float(attacker, EV_FL_frags, entity_get_float(attacker, EV_FL_frags) + 1)
	set_pdata_int(victim, OFFSET_CSDEATHS, cs_get_user_deaths(victim) + 1, OFFSET_LINUX)
	
	message_begin(MSG_BROADCAST, g_msgScoreInfo)
	write_byte(attacker) // id
	write_short(floatround(entity_get_float(attacker, EV_FL_frags))) // frags
	write_short(cs_get_user_deaths(attacker)) // deaths
	write_short(0) // class?
	write_short(fm_cs_get_user_team(attacker)) // team
	message_end()
	
	message_begin(MSG_BROADCAST, g_msgScoreInfo)
	write_byte(victim) // id
	write_short(floatround(entity_get_float(victim, EV_FL_frags))) // frags
	write_short(cs_get_user_deaths(victim)) // deaths
	write_short(0) // class?
	write_short(fm_cs_get_user_team(victim)) // team
	message_end()
}

// Plays a sound on clients
PlaySound(const sound[])
{
	client_cmd(0, "spk ^"%s^"", sound)
}

is_containing_letters( const String[] )
{
    new Len = strlen( String );
    
    for ( new i = 0 ; i < Len ; i++ )
        if ( isalpha( String[ i ] ) )  { return true; }
    
    return false;
}
count_numbers( const String[], const Len = sizeof( String ) )
{
    new Count = 0;
    
    for ( new i = 0 ; i < Len; i++ )
        if ( isdigit( String[ i ] ) )  { Count++; }
    
    return Count;
}

/*================================================================================
 [Stocks]
=================================================================================*/
/*stock get_weapon_ent(id, weapon_id)
{
	static weapon_name[24];
	
	if(weapon_id)
		get_weaponname(weapon_id, weapon_name, charsmax(weapon_name));
	
	// prefix it if we need to
	if(!equal(weapon_name, "weapon_", 7))
		format(weapon_name, charsmax(weapon_name), "weapon_%s", weapon_name);
	
	return fm_find_ent_by_owner(g_maxplayers, weapon_name, id);
}*/

stock Float:floatradius(Float:flMaxAmount, Float:flRadius, Float:flDistance)
	return floatsub(flMaxAmount, floatmul(floatdiv(flMaxAmount, flRadius), flDistance));

// Chat Color
stock CC(const id, const input[], any:...)
{
	static count; count = 1
	static users[32]
	static msg[191]
	vformat( msg, 190, input, 3 )
	
	replace_all( msg, 190, "!y" , "^1" )
	replace_all( msg, 190, "!t" , "^3" )
	replace_all( msg, 190, "!g" , "^4" ) 
	
	if( id ) users[0] = id; else get_players( users , count , "ch" )
	{
		for( new i = 0; i < count; i++ )
		{
			if(hub(users[i], g_data[BIT_CONNECTED]))
			{
				message_begin( MSG_ONE_UNRELIABLE, g_msgSayText, _, users[i] )
				write_byte( users[i] )
				write_string( msg )
				message_end( )
			}
		}
	}
}

stock fn_PrintCenter(id, input[], any:...)
{
    static sMessage[128];
    vformat(sMessage, 127, input, 3);
	
    engfunc(EngFunc_ClientPrintf, id, 1, sMessage);
}

// Is solid ent ?
stock is_solid(ent) return (ent ? ((entity_get_int(ent, EV_INT_solid) > SOLID_TRIGGER) ? true : false) : true)

// Collect random spawn points
stock load_spawns()
{
	// Check for CSDM spawns of the current map
	new cfgdir[32], mapname[32], filepath[100], linedata[64]
	get_configsdir(cfgdir, charsmax(cfgdir))
	get_mapname(mapname, charsmax(mapname))
	formatex(filepath, charsmax(filepath), "%s/csdm/%s.spawns.cfg", cfgdir, mapname)
	
	// Charge CSDM spawns if present
	if (file_exists(filepath))
	{
		new csdmdata[10][6], file = fopen(filepath,"rt")
		
		while (file && !feof(file))
		{
			fgets(file, linedata, charsmax(linedata))
			
			// invalid spawn
			if(!linedata[0] || str_count(linedata,' ') < 2) continue;
			
			// get spawn point data
			parse(linedata,csdmdata[0],5,csdmdata[1],5,csdmdata[2],5,csdmdata[3],5,csdmdata[4],5,csdmdata[5],5,csdmdata[6],5,csdmdata[7],5,csdmdata[8],5,csdmdata[9],5)
			
			// origin
			g_spawns[g_spawnCount][0] = floatstr(csdmdata[0])
			g_spawns[g_spawnCount][1] = floatstr(csdmdata[1])
			g_spawns[g_spawnCount][2] = floatstr(csdmdata[2])
			
			// increase spawn count
			g_spawnCount++
			if (g_spawnCount >= sizeof g_spawns) break;
		}
		if (file) fclose(file)
	}
	else
	{
		// Collect regular spawns
		collect_spawns_ent("info_player_start")
		collect_spawns_ent("info_player_deathmatch")
	}
	
	// Collect regular spawns for non-random spawning unstuck
	collect_spawns_ent2("info_player_start")
	collect_spawns_ent2("info_player_deathmatch")
}

// Collect spawn points from entity origins
stock collect_spawns_ent(const classname[])
{
	new ent = -1
	while ((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", classname)) != 0)
	{
		// get origin
		new Float:originF[3]
		entity_get_vector(ent, EV_VEC_origin, originF)
		g_spawns[g_spawnCount][0] = originF[0]
		g_spawns[g_spawnCount][1] = originF[1]
		g_spawns[g_spawnCount][2] = originF[2]
		
		// increase spawn count
		g_spawnCount++
		if (g_spawnCount >= sizeof g_spawns) break;
	}
}

// Collect spawn points from entity origins
stock collect_spawns_ent2(const classname[])
{
	new ent = -1
	while ((ent = engfunc(EngFunc_FindEntityByString, ent, "classname", classname)) != 0)
	{
		// get origin
		new Float:originF[3]
		entity_get_vector(ent, EV_VEC_origin, originF)
		g_spawns2[g_spawnCount2][0] = originF[0]
		g_spawns2[g_spawnCount2][1] = originF[1]
		g_spawns2[g_spawnCount2][2] = originF[2]
		
		// increase spawn count
		g_spawnCount2++
		if (g_spawnCount2 >= sizeof g_spawns2) break;
	}
}

// Drop primary/secondary weapons
stock drop_weapons(id, dropwhat)
{
	// Get user weapons
	static weapons[32], num, i, weaponid
	num = 0 // reset passed weapons count (bugfix)
	get_user_weapons(id, weapons, num)
	
	// Loop through them and drop primaries or secondaries
	for (i = 0; i < num; i++)
	{
		// Prevent re-indexing the array
		weaponid = weapons[i]
		
		if ((dropwhat == 1 && ((1<<weaponid) & PRIMARY_WEAPONS_BIT_SUM)) || (dropwhat == 2 && ((1<<weaponid) & SECONDARY_WEAPONS_BIT_SUM)))
		{
			// Get weapon entity
			static wname[32], weapon_ent
			get_weaponname(weaponid, wname, charsmax(wname))
			weapon_ent = fm_find_ent_by_owner(-1, wname, id)
			
			// Hack: store weapon bpammo on EV_ADDITIONAL_AMMO
			entity_set_int(weapon_ent, EV_ADDITIONAL_AMMO, cs_get_user_bpammo(id, weaponid))
			
			// Player drops the weapon and looses his bpammo
			engclient_cmd(id, "drop", wname)
			cs_set_user_bpammo(id, weaponid, 0)
		}
	}
}

// Stock by (probably) Twilight Suzuka -counts number of chars in a string
stock str_count(const str[], searchchar)
{
	new count, i, len = strlen(str)
	
	for (i = 0; i <= len; i++)
	{
		if(str[i] == searchchar)
			count++
	}
	
	return count;
}

// Checks if a space is vacant (credits to VEN)
stock is_hull_vacant(Float:origin[3], hull)
{
	engfunc(EngFunc_TraceHull, origin, origin, 0, hull, 0, 0)
	
	if (!get_tr2(0, TR_StartSolid) && !get_tr2(0, TR_AllSolid) && get_tr2(0, TR_InOpen))
		return 1;
	
	return 0;
}

// Check if a player is stuck (credits to VEN)
stock is_player_stuck(id, is_zombie)
{
	new Float:origin[3];
	pev( id, pev_origin, origin );

	if(is_zombie)
	{
		engfunc(EngFunc_TraceHull, origin, origin, 0, (pev(id, pev_flags) & FL_DUCKING) ? HULL_HEAD : HULL_HUMAN, id, 0)
		
		if(get_tr2(0, TR_StartSolid) || get_tr2(0, TR_AllSolid) || !get_tr2(0, TR_InOpen))
			return true;
	}
	else
	{
		engfunc( EngFunc_TraceHull, origin, origin, IGNORE_MONSTERS, pev( id, pev_flags ) & FL_DUCKING ? HULL_HEAD : HULL_HUMAN, id, 0 );
		return get_tr2( 0, TR_StartSolid );
	}
	
	return false;
}

// Simplified get_weaponid (CS only)
stock cs_weapon_name_to_id(const weapon[])
{
	static i
	for (i = 0; i < sizeof WEAPONENTNAMES; i++)
	{
		if (equal(weapon, WEAPONENTNAMES[i]))
			return i;
	}
	
	return 0;
}

// Get User Current Weapon Entity
stock fm_cs_get_current_weapon_ent(id)
{
	// Prevent server crash if entity's private data not initalized
	if(pev_valid(id) != PDATA_SAFE)
		return -1;
	
	return get_pdata_cbase(id, OFFSET_ACTIVE_ITEM, OFFSET_LINUX);
}

// Get Weapon Entity's Owner
stock fm_cs_get_weapon_ent_owner(ent)
{
	// Prevent server crash if entity's private data not initalized
	if(pev_valid(ent) != PDATA_SAFE)
		return -1;
	
	return get_pdata_cbase(ent, OFFSET_WEAPONOWNER, OFFSET_LINUX_WEAPONS);
}

// Get User Team
stock fm_cs_get_user_team(id)
{
	// Prevent server crash if entity's private data not initalized
	if(pev_valid(id) != PDATA_SAFE)
		return FM_CS_TEAM_UNASSIGNED;
	
	return get_pdata_int(id, OFFSET_CSTEAMS, OFFSET_LINUX);
}

// Set a Player's Team
stock fm_cs_set_user_team(id, team)
{
	// Prevent server crash if entity's private data not initalized
	if(pev_valid(id) != PDATA_SAFE)
		return;
	
	set_pdata_int(id, OFFSET_CSTEAMS, team, OFFSET_LINUX)
	//cs_set_team_id(id, team)
}

// Set User Flashlight Batteries
stock fm_cs_set_user_batteries(id, value)
{
	// Prevent server crash if entity's private data not initalized
	if(pev_valid(id) != PDATA_SAFE)
		return;
	
	set_pdata_int(id, OFFSET_FLASHLIGHT_BATTERY, value, OFFSET_LINUX)
}

// Update Player's Team on all clients (adding needed delays)
stock fm_user_team_update(id)
{
	static Float:current_time
	current_time = get_gametime()
	
	if (current_time - g_teams_targettime >= 0.1)
	{
		set_task(0.1, "fm_cs_set_user_team_msg", id+TASK_TEAM)
		g_teams_targettime = current_time + 0.1
	}
	else
	{
		set_task((g_teams_targettime + 0.1) - current_time, "fm_cs_set_user_team_msg", id+TASK_TEAM)
		g_teams_targettime = g_teams_targettime + 0.1
	}
}

// Send User Team Message
public fm_cs_set_user_team_msg(taskid)
{
	// Note to self: this next message can now be received by other plugins
	
	// Set the switching team flag
	g_switchingteam = 1
	
	// Tell everyone my new team
	emessage_begin(MSG_ALL, g_msgTeamInfo)
	ewrite_byte(ID_TEAM) // player
	ewrite_string(CS_TEAM_NAMES[fm_cs_get_user_team(ID_TEAM)]) // team
	emessage_end()
	
	// Done switching team
	g_switchingteam = 0
}

// Set User Model
public fm_cs_set_user_model(taskid)
	set_user_info(ID_MODEL, "model", g_playermodel[ID_MODEL])
	//set_user_model(ID_MODEL, g_playermodel[ID_MODEL])

// Get User Model -model passed byref-
stock fm_cs_get_user_model(player, model[], len)
	get_user_info(player, "model", model, len)
	//get_user_model(player, model, len)

// Update Player's Model on all clients (adding needed delays)
public fm_user_model_update(taskid)
{
	static Float:current_time
	current_time = get_gametime()
	
	if(current_time - g_models_targettime >= MODELS_CHANGE_DELAY)
	{
		fm_cs_set_user_model(taskid)
		g_models_targettime = current_time
	}
	else
	{
		set_task((g_models_targettime + MODELS_CHANGE_DELAY) - current_time, "fm_cs_set_user_model", taskid)
		g_models_targettime = g_models_targettime + MODELS_CHANGE_DELAY
	}
}

// Strip Weapons
stock ham_strip_weapons( Index, Arma[] )
{
	if( !equal( Arma, "weapon_", 7 ) ) 
		return 0;

	static wId; wId = get_weaponid( Arma )
	if( !wId ) return 0;

	static wEnt
	wEnt = -1;
	while( ( wEnt = engfunc( EngFunc_FindEntityByString, wEnt, "classname", Arma ) ) && entity_get_edict( wEnt, EV_ENT_owner ) != Index ) { }

	if( !wEnt ) return 0;

	if( g_currentweapon[Index] == wId ) 
		ExecuteHamB( Ham_Weapon_RetireWeapon, wEnt )

	if( !ExecuteHamB( Ham_RemovePlayerItem, Index, wEnt ) ) 
		return 0

	ExecuteHamB(Ham_Item_Kill, wEnt)

	set_pev( Index, pev_weapons, pev( Index, pev_weapons ) & ~( 1 << wId ) )

	return 1;
}

check_class(id)
{
	new s_Class[32];
	formatex(s_Class, charsmax(s_Class), "%s", g_zombie[id] ? g_nemesis[id] ? "NEMESIS" : g_alien[id] ? "ALIEN" : g_annihilator[id] ? "ANIQUILADOR" : "ZOMBIE" :
	g_survivor[id] ? "SURVIVOR" : g_wesker[id] ? "WESKER" : g_tribal_human[id] ? "TRIBAL" : g_predator[id] ? "DEPREDADOR" : g_sniper[id] ? "SNIPER" : "HUMANO");
	
	return s_Class;
}

check_class_min(id)
{
	new s_Class[32];
	
	if(!hub(id, g_data[BIT_ALIVE]))
	{
		s_Class[0] = EOS;
		return s_Class;
	}
	
	formatex(s_Class, charsmax(s_Class), "%s", g_zombie[id] ? g_nemesis[id] ? "(!gNemesis!y) " : g_alien[id] ? "(!gAlien!y) " : g_annihilator[id] ? "(!gAniquilador!y) " : "" :
	g_survivor[id] ? "(!gSurvivor!y) " : g_wesker[id] ? "(!gWesker!y) " : g_tribal_human[id] ? "(!gTribal!y) " : g_predator[id] ? "(!gDepredador!y) " : g_sniper[id] ? "(!gSniper!y)" : "");
	
	return s_Class;
}

check_class_min_team(id)
{
	new s_Class[32];
	
	if(!hub(id, g_data[BIT_ALIVE]))
	{
		s_Class[0] = EOS;
		return s_Class;
	}
	
	formatex(s_Class, charsmax(s_Class), "(%s)", g_zombie[id] ? g_nemesis[id] ? "!gNemesis!y" : g_alien[id] ? "!gAlien!y" : g_annihilator[id] ? "!gAniquilador!y" : "Zombie" :
	g_survivor[id] ? "!gSurvivor!y" : g_wesker[id] ? "!gWesker!y" : g_tribal_human[id] ? "!gTribal!y" : g_predator[id] ? "!gDepredador!y" : g_sniper[id] ? "!gSniper!y" : "Humano");
	
	return s_Class;
}

add_dot(Numero, szOutPut[], Longitud)
{
	new szTmp[ 15 ], iOutputPos, iNumPos, iNumLen; iNumLen = num_to_str( Numero, szTmp, 14 )

	while( ( iNumPos < iNumLen ) && ( iOutputPos < Longitud ) ) 
	{
		szOutPut[ iOutputPos++ ] = szTmp[ iNumPos++ ]

		if( ( iNumLen - iNumPos ) && !( ( iNumLen - iNumPos ) % 3 ) )
			szOutPut[ iOutputPos++ ] = '.'
	}

	szOutPut[ iOutputPos ] = EOS

	return iOutputPos;
}

check_multiplier_ur(id, tan, supertan)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static userflags, Float:rmult
	userflags = get_user_flags(id)
	rmult = 0.0
	
	g_mult_xp[id] = 1.0;
	g_mult_aps[id] = 1.0;
	g_mult_point[id] = 1;
	
	if(g_rn_equip[id][RING][RING_XP_MULT])
	{
		rmult = 0.5 * g_rn[id][RING][RING_XP_MULT]
		
		if(userflags & ADMIN_RESERVATION) // Admin o VIP
		{
			sub(id, g_data[BIT_PREMIUM])
			g_mult_xp[id] = (supertan && g_mapa_esp) ? (6.0 + rmult) : (supertan || (tan && g_mapa_esp)) ? (5.0 + rmult) : (tan) ? (4.0 + rmult) : (g_mapa_esp) ? (3.0 + rmult) : (2.0 + rmult)
			g_mult_point[id] = (supertan) ? 3 : 2
		}
		else // Usuario
		{
			g_mult_xp[id] = (supertan && g_mapa_esp) ? (4.0 + rmult) : (supertan || (tan && g_mapa_esp)) ? (3.0 + rmult) : (tan || g_mapa_esp) ? (2.0 + rmult) : (1.0 + rmult)
			g_mult_point[id] = (supertan) ? 2 : 1
		}
	}
	else
	{
		if(userflags & ADMIN_RESERVATION) // Admin o VIP
		{
			sub(id, g_data[BIT_PREMIUM])
			g_mult_xp[id] =  (supertan && g_mapa_esp) ? 6.0 : (supertan || (tan && g_mapa_esp)) ? 5.0 : (tan) ? 4.0 : (g_mapa_esp) ? 3.0 : 2.0
			g_mult_point[id] = (supertan) ? 3 : 2
		}
		else // Usuario
		{
			g_mult_xp[id] = (supertan && g_mapa_esp) ? 4.0 : (supertan || (tan && g_mapa_esp)) ? 3.0 : (tan || g_mapa_esp) ? 2.0 : 1.0
			g_mult_point[id] = (supertan) ? 2 : 1
		}
	}
	
	if(g_zr_pj[id] == 222 || g_zr_pj[id] == 3927 || g_zr_pj[id] == 5629 || g_zr_pj[id] == 1682 ||
	g_zr_pj[id] == 586 || g_zr_pj[id] == 588 || g_zr_pj[id] == 155 || g_zr_pj[id] == 5219)
		g_mult_xp[id] += 1.0;
	
	else if(g_hat_equip[id] == HAT_RECCE || g_hat_equip[id] == HAT_PHIZZ)
		g_mult_xp[id] += 1.0;
	
	if(g_rn_equip[id][RING][RING_APS_MULT])
		g_mult_aps[id] = 1.0 + (0.5 * g_rn[id][RING][RING_APS_MULT])
	
	if(g_artefactos_equipados[id][0])
		g_mult_aps[id] += 1.0
	if(g_artefactos_equipados[id][1])
		g_mult_xp[id] += 1.0;
	if(g_artefactos_equipados[id][2])
		g_mult_point[id] += 1
	
	g_mult_aps[id] += EASY_MULT
	g_mult_xp[id] += EASY_MULT
	
	if(EASY_MULT >= 2.0)
		g_mult_point[id] += 2
	else if(EASY_MULT >= 1.0)
		g_mult_point[id] += 1
}

fnRemoveWeaponsEdit(id, weapon)
{
	if(!hub(id, g_data[BIT_CONNECTED])) return;
	
	for(new weap = 0; weap < MAX_WEAPONS; weap++)
	{
		g_weapon[id][weapon][weap] = 0
		g_weapons_edit[id][weapon] = 0
	}
	
	if(weapon == 0)
		g_weap_leg_choose[id] = 0;
}

public time_playing(taskid)
{
	if(!hub(ID_TIME_PLAYING, g_data[BIT_CONNECTED]))
		return;

	
	g_time_playing[ID_TIME_PLAYING][MINUTES] += 6;
	
	if(g_time_playing[ID_TIME_PLAYING][MINUTES] >= 1440 && g_time_playing[ID_TIME_PLAYING][MINUTES] < 1448)
		fn_update_logro(ID_TIME_PLAYING, LOGRO_OTHERS, ENTRENANDO);
	else if(g_time_playing[ID_TIME_PLAYING][MINUTES] >= 10080 && g_time_playing[ID_TIME_PLAYING][MINUTES] < 10088)
	{
		fn_give_hat(ID_TIME_PLAYING, HAT_EARTH)
		fn_update_logro(ID_TIME_PLAYING, LOGRO_OTHERS, ESTOY_MUY_SOLO);
	}
	else if(g_time_playing[ID_TIME_PLAYING][MINUTES] >= 43200 && g_time_playing[ID_TIME_PLAYING][MINUTES] < 43208)
		fn_update_logro(ID_TIME_PLAYING, LOGRO_OTHERS, FOREVER_ALONE);
}

public recomendated_resolution(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	CC(id, "!g[ZP]!y Recomendamos usar una resolución !gmayor o igual a 1024x768!y para que no se superpongan los textos")
}
public recomendated_invis()	CC(0, "!g[ZP]!y Tienes pocos FPS, no te anda fluido? Probá con el comando !g/invis!y");
public lottery_draw()
{
	new sCurrentTime[4];
	new iLotteryDraw;
	get_time("%A", sCurrentTime, 3);
	
	new Handle:sql_consult = SQL_PrepareQuery(g_sql_connection, "SELECT lot_draw FROM others;");
	if(!SQL_Execute(sql_consult))
	{
		new sql_error[512];
		SQL_QueryError(sql_consult, sql_error, 511);
		
		log_to_file("zr_sql.log", "- LOG:9 - %s", sql_error);
		
		iLotteryDraw = 1;
	}
	else if(SQL_NumResults(sql_consult))
		iLotteryDraw = SQL_ReadResult(sql_consult, 0);
	
	SQL_FreeHandle(sql_consult);
	
	if(!iLotteryDraw && equali(sCurrentTime, "Sun"))
	{
		if(!g_gamblers)
		{
			sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE others SET lot_draw='1';");
			if(!SQL_Execute(sql_consult))
			{
				new sql_error[512];
				SQL_QueryError(sql_consult, sql_error, 511);
				
				log_to_file("zr_sql.log", "- LOG:30 - %s", sql_error);
			}
			SQL_FreeHandle(sql_consult)
			
			sql_consult = SQL_PrepareQuery(g_sql_connection, "INSERT INTO lottery (`dates`, `names`, `bet_win`) VALUES (now(), ^"NO HUBO APOSTADORES^", '0');");
			if(!SQL_Execute(sql_consult))
			{
				new sql_error[512];
				SQL_QueryError(sql_consult, sql_error, 511);
				
				log_to_file("zr_sql.log", "- LOG:47 - %s", sql_error);
			}
			SQL_FreeHandle(sql_consult)
			
			CC(0, "!g[LOTERÍA]!y La lotería no tiene ganadores ya que no hubo apostadores esta semana")
			
			return PLUGIN_HANDLED;
		}
		
		g_gamblers = 0;
		
		sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE others SET lot_draw='1', lot_gamblers='0';");
		if(!SQL_Execute(sql_consult))
		{
			new sql_error[512];
			SQL_QueryError(sql_consult, sql_error, 511);
			
			log_to_file("zr_sql.log", "- LOG:31 - %s", sql_error);
		}
		SQL_FreeHandle(sql_consult)
		
		new iNumDraw = random_num(0, 999);
		CC(0, "!g[LOTERÍA]!y El número sorteado es el: !g%d!y", iNumDraw);
		
		sql_consult = SQL_PrepareQuery(g_sql_connection, "SELECT id, users.name, xp, lot_bet FROM users LEFT JOIN bans ON users.id = bans.zp_id WHERE bans.zp_id IS NULL AND users.id <> 1 AND users.id <> 2 AND lot_num=%d AND lot_bet > 4999 ORDER BY xp DESC LIMIT 1;", iNumDraw);
		if(!SQL_Execute(sql_consult))
		{
			new sql_error[512];
			SQL_QueryError(sql_consult, sql_error, 511);
			
			log_to_file("zr_sql.log", "- LOG:10 - %s", sql_error);
			SQL_FreeHandle(sql_consult);
		}
		else if(SQL_NumResults(sql_consult))
		{
			new iId;
			new sName[32];
			new iLotBet;
			new sLotBet[15];
			new iWins;
			new sWins[15];
			new i;
			new iWinner = 0;
			
			iId = SQL_ReadResult(sql_consult, 0);
			SQL_ReadResult(sql_consult, 1, sName, charsmax(sName));
			iLotBet = SQL_ReadResult(sql_consult, 3);
			
			iWins = iLotBet * 70;
			
			add_dot(iWins, sWins, 14);
			add_dot(iLotBet, sLotBet, 14);
			
			if(iLotBet >= 50000)
			{
				CC(0, "!g[LOTERÍA]!y El jugador !g%s ganó el POZO ACUMULADO!y", sName);
				
				for(i = 1; i <= g_maxplayers; i++)
				{
					if(!hub(i, g_data[BIT_CONNECTED])) continue;
					if(iId == g_zr_pj[i])
					{
						update_xp(i, g_well_acc, 0);
						
						iWinner = 1;
						
						break;
					}
				}
				
				SQL_FreeHandle(sql_consult);
				
				if(!iWinner)
				{
					sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE users SET xp=xp+%d WHERE id='%d';", g_well_acc, iId);
					if(!SQL_Execute(sql_consult))
					{
						new sql_error[512];
						SQL_QueryError(sql_consult, sql_error, 511);
						
						log_to_file("zr_sql.log", "- LOG:32 - %s", sql_error);
					}
					SQL_FreeHandle(sql_consult)
				}
				
				sql_consult = SQL_PrepareQuery(g_sql_connection, "INSERT INTO lottery (`dates`, `names`, `bet_win`) VALUES (now(), ^"%s^", '%d');", sName, g_well_acc);
				if(!SQL_Execute(sql_consult))
				{
					new sql_error[512];
					SQL_QueryError(sql_consult, sql_error, 511);
					
					log_to_file("zr_sql.log", "- LOG:33 - %s", sql_error);
				}
				SQL_FreeHandle(sql_consult)
				
				g_well_acc = 0;
			}
			else
			{
				CC(0, "!g[LOTERÍA]!y El jugador !g%s!y ganó !g%s de XP!y por apostar !g%s de XP!y al número ganador", sName, sWins, sLotBet);
				if(iWins > g_well_acc)
				{
					iWins = g_well_acc;
					g_well_acc = 0;
				}
				else g_well_acc -= iWins;
				
				for(i = 1; i <= g_maxplayers; i++)
				{
					if(!hub(i, g_data[BIT_CONNECTED])) continue;
					if(iId == g_zr_pj[i])
					{
						update_xp(i, iWins, 0);
						
						iWinner = 1;
						
						break;
					}
				}
				
				SQL_FreeHandle(sql_consult)
				
				if(!iWinner)
				{
					sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE users SET xp=xp+%d WHERE id='%d';", iWins, iId);
					if(!SQL_Execute(sql_consult))
					{
						new sql_error[512];
						SQL_QueryError(sql_consult, sql_error, 511);
						
						log_to_file("zr_sql.log", "- LOG:34 - %s", sql_error);
					}
					SQL_FreeHandle(sql_consult)
				}
				
				sql_consult = SQL_PrepareQuery(g_sql_connection, "INSERT INTO lottery (`dates`, `names`, `bet_win`) VALUES (now(), ^"%s^", '%d');", sName, iWins);
				if(!SQL_Execute(sql_consult))
				{
					new sql_error[512];
					SQL_QueryError(sql_consult, sql_error, 511);
					
					log_to_file("zr_sql.log", "- LOG:35 - %s", sql_error);
				}
				SQL_FreeHandle(sql_consult)
			}
			
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!hub(i, g_data[BIT_CONNECTED])) continue;
				
				g_bet[i] = 0;
				g_bet_num[i] = 0;
				g_bet_done[i] = 0;
			}
			
			sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE others SET well_acc='%d';", g_well_acc);
			if(!SQL_Execute(sql_consult))
			{
				new sql_error[512];
				SQL_QueryError(sql_consult, sql_error, 511);
				
				log_to_file("zr_sql.log", "- LOG:36 - %s", sql_error);
			}
			SQL_FreeHandle(sql_consult)
			
			sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE users SET lot_bet='0', lot_num='0';");
			if(!SQL_Execute(sql_consult))
			{
				new sql_error[512];
				SQL_QueryError(sql_consult, sql_error, 511);
				
				log_to_file("zr_sql.log", "- LOG:48 - %s", sql_error);
			}
			SQL_FreeHandle(sql_consult)
			
			return PLUGIN_HANDLED;
		}
		else SQL_FreeHandle(sql_consult);
		
		sql_consult = SQL_PrepareQuery(g_sql_connection, "SELECT id, users.name, xp, lot_num, lot_bet FROM users LEFT JOIN bans ON users.id = bans.zp_id WHERE bans.zp_id IS NULL AND users.id <> 1 AND users.id <> 2 AND lot_bet > 4999 ORDER BY ABS(%d-lot_num) ASC, lot_bet DESC, xp DESC LIMIT 1;", iNumDraw);
		if(!SQL_Execute(sql_consult))
		{
			new sql_error[512];
			SQL_QueryError(sql_consult, sql_error, 511);
			
			log_to_file("zr_sql.log", "- LOG:11 - %s", sql_error);
			SQL_FreeHandle(sql_consult);
		}
		else if(SQL_NumResults(sql_consult))
		{
			new iId;
			new sName[32];
			new iLotNum;
			new iLotBet;
			new iWins;
			new sWins[15];
			new iWinner = 0;
			
			iId = SQL_ReadResult(sql_consult, 0);
			
			SQL_ReadResult(sql_consult, 1, sName, charsmax(sName));
			
			iLotNum = SQL_ReadResult(sql_consult, 3);
			iLotBet = SQL_ReadResult(sql_consult, 4);
			
			iWins = iLotBet * 10;
			
			if(iWins > g_well_acc)
			{
				iWins = g_well_acc;
				g_well_acc = 0;
			}
			else g_well_acc -= iWins;
			
			add_dot(iWins, sWins, 14);
			
			CC(0, "!g[LOTERÍA]!y El jugador !g%s!y tiene el número más cercano (!g%d!y). Ganó !g%s de XP!y", sName, iLotNum, sWins);
			
			SQL_FreeHandle(sql_consult);
			
			sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE others SET well_acc='%d';", g_well_acc);
			if(!SQL_Execute(sql_consult))
			{
				new sql_error[512];
				SQL_QueryError(sql_consult, sql_error, 511);
				
				log_to_file("zr_sql.log", "- LOG:37 - %s", sql_error);
			}
			SQL_FreeHandle(sql_consult)
			
			new i;
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!hub(i, g_data[BIT_CONNECTED])) continue;
				if(iId == g_zr_pj[i])
				{
					update_xp(i, iWins, 0);
					
					iWinner = 1;
					break;
				}
			}
			
			if(!iWinner)
			{
				sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE users SET xp=xp+%d WHERE id='%d';", iWins, iId);
				if(!SQL_Execute(sql_consult))
				{
					new sql_error[512];
					SQL_QueryError(sql_consult, sql_error, 511);
					
					log_to_file("zr_sql.log", "- LOG:38 - %s", sql_error);
				}
				SQL_FreeHandle(sql_consult)
			}
			
			sql_consult = SQL_PrepareQuery(g_sql_connection, "INSERT INTO lottery (`dates`, `names`, `bet_win`) VALUES (now(), ^"%s^", '%d');", sName, iWins);
			if(!SQL_Execute(sql_consult))
			{
				new sql_error[512];
				SQL_QueryError(sql_consult, sql_error, 511);
				
				log_to_file("zr_sql.log", "- LOG:39 - %s", sql_error);
			}
			SQL_FreeHandle(sql_consult)
		}
		else SQL_FreeHandle(sql_consult);
		
		new i;
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(!hub(i, g_data[BIT_CONNECTED])) continue;
			
			g_bet[i] = 0;
			g_bet_num[i] = 0;
			g_bet_done[i] = 0;
		}
		
		sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE others SET well_acc='%d';", g_well_acc);
		if(!SQL_Execute(sql_consult))
		{
			new sql_error[512];
			SQL_QueryError(sql_consult, sql_error, 511);
			
			log_to_file("zr_sql.log", "- LOG:40 - %s", sql_error);
		}
		SQL_FreeHandle(sql_consult)
		
		sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE users SET lot_bet='0', lot_num='0';");
		if(!SQL_Execute(sql_consult))
		{
			new sql_error[512];
			SQL_QueryError(sql_consult, sql_error, 511);
			
			log_to_file("zr_sql.log", "- LOG:49 - %s", sql_error);
		}
		SQL_FreeHandle(sql_consult)
		
		return PLUGIN_HANDLED;
	}
	else if(iLotteryDraw && !equali(sCurrentTime, "Sun"))
	{
		sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE others SET lot_draw='0';");
		if(!SQL_Execute(sql_consult))
		{
			new sql_error[512];
			SQL_QueryError(sql_consult, sql_error, 511);
			
			log_to_file("zr_sql.log", "- LOG:41 - %s", sql_error);
		}
		SQL_FreeHandle(sql_consult)
	}
	
	return PLUGIN_HANDLED;
}

public fnShowCurrentCombo(id, damage)
{
	if(!hub(id, g_data[BIT_CONNECTED])) return;
	
	static info_combo[32], info_dmg[32], info_tcombo[3], info_dmg_total[15], mult;

	mult = g_hab[id][HAB_HUMAN][HUMAN_TCOMBO];
	formatex(info_tcombo, 2, "%s", (mult) ? "T" : "")

	if(g_combo[id] < 1000) formatex(info_combo, 31, "%sCombo de %d XP", info_tcombo, g_combo[id])
	else
	{
		static s_combo[8]
		add_dot(g_combo[id], s_combo, 7)
	
		formatex(info_combo, 31, "%sCombo de %s XP", info_tcombo, s_combo)
	}
	
	if(damage < 999) formatex(info_dmg, 31, "%d", damage)
	else
	{
		static s_damage[8]
		add_dot(damage, s_damage, 7)
		
		formatex(info_dmg, 31, "%s", s_damage)
	}
	
	static dmg_total[30]
	if(g_hud_combo_dmg_total[id])
	{
		add_dot(g_combo_damage[id], info_dmg_total, 14)
		formatex(dmg_total, 29, " | Daño total: %s", info_dmg_total)
	}
	
	set_hudmessage(g_color[id][COLOR_HUD_COMBO][0], g_color[id][COLOR_HUD_COMBO][1], g_color[id][COLOR_HUD_COMBO][2], g_hud_combo_pos[id][0], g_hud_combo_pos[id][1], 0, 1.0, 8.0, 0.01, 0.01)
	ShowSyncHudMsg(id, g_MsgSync3, "%s^nDaño: %s%s", info_combo, info_dmg, (g_hud_combo_dmg_total[id]) ? dmg_total : "")
}
public fnFinishCombo_Human(taskid)
{
	static id
	id = ID_FINISHCOMBO
	
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static reward, mult;
	mult = (g_hab[id][HAB_HUMAN][HUMAN_TCOMBO]) ? 4 : 3;
	
	if(g_combo[id] > 500)
	{
		if(g_combo[id] > 1000)
		{
			if(g_combo[id] > 2500)
			{
				if(g_combo[id] > 5000)
				{
					if(g_combo[id] > 10000)
					{
						if(g_combo[id] > 20000)
						{
							if(g_combo[id] > 30000)
							{
								if(g_combo[id] > 50000) mult += 9
								else mult += 8
							}
							else mult += 7
						}
						else mult += 6
					}
					else mult += 5
				}
				else mult += 4
			}
			else mult += 3
		}
		else mult += 2
	}
	
	reward = g_combo[id] * mult
	
	if(reward > 0)
	{
		update_xp(id, reward, 0)
		
		static s_reward[8], s_damage[10]
		add_dot(reward, s_reward, 7)
		add_dot(g_combo_damage[id], s_damage, 9)

		set_hudmessage(255, 0, 0, -1.0, 0.57, 0, 1.0, 8.0, 0.01, 0.01)
		ShowSyncHudMsg(id, g_MsgSync3, "Ganaste %s de XP^nDaño hecho: %s", s_reward, s_damage)
		
		if(g_annihilation_round)
		{
			g_combo[id] = 0
			g_combo_damage[id] = 0
			
			return;
		}
		
		if(g_survivor[id] || g_wesker[id] || g_tribal_human[id] || g_predator[id])
		{
			if(g_combo[id] >= 10000 && g_wesker[id])
				fn_update_logro(id, LOGRO_WESKER, COMBO_WESKER_10000);
		
			g_combo[id] = 0
			g_combo_damage[id] = 0
			
			return;
		}
		
		if((get_gametime() - g_time_cortamambo[id]) >= 300.0)
		{
			g_time_cortamambo[id] = 0.00
			fn_update_logro(id, LOGRO_SECRET, CORTAMAMBO);
		}
		
		// -- Save Stats --
		if(g_combo[id] > g_stats[id][COMBO_MAX][DONE])
		{
			g_stats[id][COMBO_MAX][DONE] = g_combo[id];
			
			if(g_combo[id] >= 500)
			{
				fn_update_logro(id, LOGRO_HUMAN, COMBO_500);
				if(g_combo[id] >= 1000)
				{
					fn_update_logro(id, LOGRO_HUMAN, COMBO_1000);
					if(g_combo[id] >= 2500)
					{
						fn_update_logro(id, LOGRO_HUMAN, COMBO_2500);
						if(g_combo[id] >= 5000)
						{
							fn_update_logro(id, LOGRO_HUMAN, COMBO_5000);
							if(g_combo[id] >= 10000)
							{
								fn_update_logro(id, LOGRO_HUMAN, COMBO_10000);
								if(g_combo[id] >= 15000)
								{
									fn_update_logro(id, LOGRO_HUMAN, COMBO_15000);
									if(g_combo[id] >= 20000)
									{
										fn_update_logro(id, LOGRO_HUMAN, COMBO_20000);
										if(g_combo[id] >= 30000) fn_update_logro(id, LOGRO_HUMAN, COMBO_30000);
									}
								}
							}
						}
					}
				}
			}
			
			if(g_combo[id] > g_combo_leader && g_zr_pj[id] != 1 && g_zr_pj[id] != 2)
			{
				static lg_dot[15];
				add_dot(g_combo[id], lg_dot, charsmax(lg_dot))
			
				g_combo_leader = g_combo[id]
				copy(g_combo_leader_name, charsmax(g_combo_leader_name), g_playername[id])
				add_dot(g_combo_leader, g_combo_leader_text, charsmax(g_combo_leader_text))
				
				/*new sQuery[128];
				formatex(sQuery, charsmax(sQuery), "UPDATE users SET combo_max='%d' WHERE `id`='%d';", g_combo_leader, g_zr_pj[id]);
				
				SQL_ThreadQuery(g_sql_tuple, "QueryChecked", sQuery);*/
				
				// SQL - 3
				new Handle:sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE users SET combo_max='%d' WHERE `id`='%d';", g_combo_leader, g_zr_pj[id])
				if(!SQL_Execute(sql_consult))
				{
					new sql_error[512];
					SQL_QueryError(sql_consult, sql_error, 511);
					
					log_to_file("zr_sql.log", "- LOG:12 - %s", sql_error);
				}
				SQL_FreeHandle(sql_consult)
				
				fn_update_logro(id, LOGRO_HUMAN, SE_UN_LIDER);
				CC(0, "!g[ZP]!t %s!y consigió el liderazgo en combo máximo con !g%s combos!y", g_playername[id], lg_dot)
			}
		}
		
		if(g_combo[id] == 5000)
			fn_update_logro(id, LOGRO_SECRET, NICE_COMBO)
	}
	
	g_combo[id] = 0
	g_combo_damage[id] = 0
}
#if defined EVENT_SEMANA_INFECCION
public fnFinishCombo_Zombie(taskid)
{
	static id
	id = ID_FINISHCOMBO_INFECT
	
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	if(infectsCombo[id] > maxInfectsCombo[id])
		maxInfectsCombo[id] = infectsCombo[id];
	
	infectsCombo[id] = 0;
}
#endif

fn_reset_setinfo(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	client_cmd(id, "setinfo bottomcolor ^"^"")
	client_cmd(id, "setinfo cl_lc ^"^"")
	client_cmd(id, "setinfo model ^"^"")
	client_cmd(id, "setinfo topcolor ^"^"")
	client_cmd(id, "setinfo _9387 ^"^"")
	client_cmd(id, "setinfo _iv ^"^"")
	client_cmd(id, "setinfo _ah ^"^"")
	client_cmd(id, "setinfo _puqz ^"^"")
	client_cmd(id, "setinfo _ndmh ^"^"")
	client_cmd(id, "setinfo _ndmf ^"^"")
	client_cmd(id, "setinfo _ndms ^"^"")
	
	return PLUGIN_HANDLED;
}

public fn_start_armageddon_mode()
{
	// Show Armageddon HUD notice
	set_dhudmessage(200, 200, 200, HUD_EVENT_X, HUD_EVENT_Y, 0, 0.0, 4.9, 1.0, 1.0)
	show_dhudmessage(0, "¡ ARMAGEDDON !")
	
	g_newround = 0;
	
	new id;
	
	for(id = 1; id <= g_maxplayers; id++)
	{
		if(!hub(id, g_data[BIT_ALIVE]))
			continue;
		
		g_happy[id]++;
		
		if(g_happy[id] == 3)
			fn_give_hat(id, HAT_SMILEY)
		
		// Spawn at a random location?
		do_random_spawn(id)
		
		if(fm_cs_get_user_team(id) == FM_CS_TEAM_T)
			zombieme(id, 0, 1, 0, 0, 0, 0, 0)
		else if(fm_cs_get_user_team(id) == FM_CS_TEAM_CT)
		{
			humanme(id, 1, 0, 0, 0, 0, 0)
			
			message_begin(MSG_ONE_UNRELIABLE, g_msgScreenFade, _, id)
			write_short(UNIT_SECOND) // duration
			write_short(0) // hold time
			write_short(FFADE_IN) // fade type
			write_byte(g_color[id][COLOR_NVG][0])
			write_byte(g_color[id][COLOR_NVG][1])
			write_byte(g_color[id][COLOR_NVG][2])
			write_byte(0) // alpha
			message_end()
		}
	}
}
public fn_notice_1()
{
	// Show Armageddon HUD notice
	set_hudmessage(0, 0, 255, HUD_EVENT_X, HUD_EVENT_Y, 0, 0.0, 4.9, 1.0, 1.0, -1)
	ShowSyncHudMsg(0, g_MsgSync, "Durante décadas..")
}
public fn_notice_2()
{
	// Show Armageddon HUD notice
	set_hudmessage(255, 0, 0, HUD_EVENT_X, HUD_EVENT_Y, 0, 0.0, 4.9, 1.0, 1.0, -1)
	ShowSyncHudMsg(0, g_MsgSync, ".. se enfrentaron..")
}
public fn_notice_3()
{
	// Show Armageddon HUD notice
	set_hudmessage(200, 0, 200, HUD_EVENT_X, HUD_EVENT_Y, 0, 0.0, 4.9, 1.0, 1.0, -1)
	ShowSyncHudMsg(0, g_MsgSync, ".. y hoy llegó el final...")
}

fn_fire_rocket(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	g_bazooka[id]--;
	
	if(g_bazooka[id] < 1)
	{
		if(g_nemesis[id])
		{
			strip_user_weapons(id)
			give_item(id, "weapon_knife")
		}
		else ham_strip_weapons(id, "weapon_sg550")
	}
	
	entity_set_vector(id, EV_FLARE_COLOR, Float:{ -10.5, 0.0, 0.0 })
	
	fn_set_animation(id, 8)
	
	static Float:flOrigin[3], Float:flAngles[3], Float:flVelocity[3], Float:flViewOffs[3]
	
	entity_get_vector(id, EV_VEC_view_ofs, flViewOffs)
	entity_get_vector(id, EV_VEC_origin, flOrigin)
	
	xs_vec_add(flOrigin, flViewOffs, flOrigin)
	
	entity_get_vector(id, EV_VEC_v_angle, flAngles)
	
	new entity = create_entity("info_target")
	
	entity_set_string(entity, EV_SZ_classname, "rocket_bazooka")
	entity_set_model(entity, g_sModel_Rocket)
	
	set_size(entity, Float:{-1.0, -1.0, -1.0}, Float:{1.0, 1.0, 1.0})
	entity_set_vector(entity, EV_VEC_mins, Float:{-1.0, -1.0, -1.0})
	entity_set_vector(entity, EV_VEC_maxs, Float:{1.0, 1.0, 1.0})
	
	entity_set_origin(entity, flOrigin)
	
	flAngles[0] -= 30.0
	engfunc(EngFunc_MakeVectors, flAngles)
	flAngles[0] = -(flAngles[0] + 30.0)
	
	entity_set_vector(entity, EV_VEC_angles, flAngles)
	entity_set_int(entity, EV_INT_solid, SOLID_BBOX)
	entity_set_int(entity, EV_INT_movetype, MOVETYPE_FLY)
	entity_set_edict(entity, EV_ENT_owner, id)
	
	emit_sound(entity, CHAN_VOICE, g_sSoundBazooka_2, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	emit_sound(entity, CHAN_WEAPON, g_sSoundBazooka_1, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	
	VelocityByAim(id, get_pcvar_num(cvar[0]), flVelocity)
	entity_set_vector(entity, EV_VEC_velocity, flVelocity)
	
	set_rendering(entity, kRenderFxGlowShell, 255, 0, 0, kRenderNormal, 50)
	entity_set_edict(entity, EV_ENT_FLARE, fn_create_flare(entity))
	
	entity_set_int(entity, EV_INT_effects, entity_get_int(entity, EV_INT_effects) | EF_BRIGHTLIGHT)
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_BEAMFOLLOW) // TE id
	write_short(entity) // entity:attachment to follow
	write_short(g_trailSpr) // sprite index
	write_byte(30) // life in 0.1's
	write_byte(3) // line width in 0.1's
	write_byte(255) // r
	write_byte(0) // g
	write_byte(0) // b
	write_byte(200) // brightness
	message_end()
	
	if(g_bazooka_mode[id])
	{
		new sInfo[1];
		sInfo[0] = entity;
		
		set_task(0.1, "find_and_follow", 0, sInfo, 1);
	}
	
	if(get_pcvar_num(cvar[0]) == 1200)
		set_task(0.1, "spritetrail_rocket", entity)
}

public find_and_follow(sInfo[])
{
	new entity = sInfo[0];
	new Float:fShortDist = 9999.0;
	new iFindPlayer = 0;
	
	if(is_valid_ent(entity))
	{
		new sPlayers[32]
		new iCount;
		new iOwner = entity_get_edict(entity, EV_ENT_owner);
		new i;
		new iTarget;
		
		get_players(sPlayers, iCount)
		for(i = 0; i < iCount; i++)
		{
			iTarget = sPlayers[i];
			
			if(is_user_alive(iTarget) && 
			(iOwner != iTarget) &&
			(fm_cs_get_user_team(iTarget) != fm_cs_get_user_team(iOwner)))
			{
				new Float:fPlayerOrigin[3];
				new Float:fEntityOrigin[3];
				
				entity_get_vector(sPlayers[i], EV_VEC_origin, fPlayerOrigin);
				entity_get_vector(entity, EV_VEC_origin, fEntityOrigin);
				
				new Float:fDistance = vector_distance(fPlayerOrigin, fEntityOrigin);
				
				if(fDistance <= fShortDist)
				{
					fShortDist = fDistance;
					iFindPlayer = sPlayers[i];
				}
			}
		}
	}
	
	if(iFindPlayer > 0)
	{
		new sData[2]
		
		sData[0] = entity;
		sData[1] = iFindPlayer;
		
		set_task(0.1, "follow_and_catch", entity, sData, 2, "b");
	}
}
public follow_and_catch(sData[])
{
	new entity = sData[0];
	new iTarget = sData[1];
	
	if(is_user_alive(iTarget) && is_valid_ent(entity))
	{
		entity_set_follow(entity, iTarget, get_pcvar_float(cvar[1]));
		
		new Float:fVelocity[3];
		new Float:fNewAngle[3];
		
		entity_get_vector(entity, EV_VEC_velocity, fVelocity);
		vector_to_angle(fVelocity, fNewAngle);
		entity_set_vector(entity, EV_VEC_angles, fNewAngle);
	}
	else
	{
		remove_task(entity);
		set_task(0.1, "find_and_follow", 0, sData, 1);
	}
}

public spritetrail_rocket(entity)
{
	if(!is_valid_ent(entity))
		return;
	
	new Float:flOriginEnt[3], ent_origin[3]
	
	entity_get_vector(entity, EV_VEC_origin, flOriginEnt)
	ent_origin[0] = floatround(flOriginEnt[0])
	ent_origin[1] = floatround(flOriginEnt[1])
	ent_origin[2] = floatround(flOriginEnt[2])
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_SPRITETRAIL)
	write_coord(ent_origin[0])
	write_coord(ent_origin[1])
	write_coord(ent_origin[2]-20)
	write_coord(ent_origin[0])
	write_coord(ent_origin[1])
	write_coord(ent_origin[2]+20)
	write_short(g_redballSpr)
	write_byte(30)
	write_byte(2)
	write_byte(5)
	write_byte(random_num(5, 50))
	write_byte(40)
	message_end()
	
	set_task(0.2, "spritetrail_rocket", entity)
}

fn_create_flare(rocket)
{
	new entity = create_entity("env_sprite")
	
	if(!is_valid_ent(entity))
		return 0;
		
	entity_set_model(entity, g_sSprite_Anim);
	
	entity_set_float(entity, EV_FL_scale, 0.7)
	entity_set_int(entity, EV_INT_spawnflags, SF_SPRITE_STARTON)
	entity_set_int(entity, EV_INT_solid, SOLID_NOT)
	entity_set_int(entity, EV_INT_movetype, MOVETYPE_FOLLOW)
	entity_set_edict(entity, EV_ENT_aiment, rocket)
	entity_set_edict(entity, EV_ENT_owner, rocket)
	entity_set_float(entity, EV_FL_framerate, 25.0)
	
	set_rendering(entity, kRenderFxNone, 255, 0, 0, kRenderTransAdd, 255)
	
	DispatchSpawn(entity)

	return entity;
}

fn_rocket_blast(entity, Float:flOrigin[3])
{
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, flOrigin, 0)
	write_byte(TE_EXPLOSION) // TE id
	engfunc(EngFunc_WriteCoord, flOrigin[0]) // x
	engfunc(EngFunc_WriteCoord, flOrigin[1]) // y
	engfunc(EngFunc_WriteCoord, flOrigin[2]) // z
	write_short(g_explo2Spr)	// sprite index
	write_byte(120)	// scale in 0.1's	
	write_byte(10)	// framerate	
	write_byte(TE_EXPLFLAG_NOSOUND|TE_EXPLFLAG_NODLIGHTS) // flags
	message_end()
	
	emit_sound(entity, CHAN_WEAPON, g_sSoundBazooka_3, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	emit_sound(entity, CHAN_VOICE, g_sSoundBazooka_3, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	
	// World Decal
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, flOrigin, 0)
	write_byte(TE_WORLDDECAL) // TE id
	engfunc(EngFunc_WriteCoord, flOrigin[0]) // x
	engfunc(EngFunc_WriteCoord, flOrigin[1]) // y
	engfunc(EngFunc_WriteCoord, flOrigin[2]) // z
	write_byte(random_num(46, 48)) // texture index of precached decal texture name
	message_end()

	// Rings
	create_blast(flOrigin, 200, 200, 200)
	
	// Colored Dynamic Light
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, flOrigin, 0)
	write_byte(TE_DLIGHT) // TE id
	engfunc(EngFunc_WriteCoord, flOrigin[0]) // x
	engfunc(EngFunc_WriteCoord, flOrigin[1]) // y
	engfunc(EngFunc_WriteCoord, flOrigin[2]) // z
	write_byte(50) // radius
	write_byte(200) // red
	write_byte(200) // green
	write_byte(200) // blue
	write_byte(10) // life
	write_byte(45) // decay rate
	message_end()
	
	// Colored Dynamic Light
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, flOrigin, 0)
	write_byte(TE_DLIGHT) // TE id
	engfunc(EngFunc_WriteCoord, flOrigin[0]) // x
	engfunc(EngFunc_WriteCoord, flOrigin[1]) // y
	engfunc(EngFunc_WriteCoord, flOrigin[2]) // z
	write_byte(110) // radius
	write_byte(175) // red
	write_byte(30) // green
	write_byte(30) // blue
	write_byte(50) // life
	write_byte(30) // decay rate
	message_end()
}

fn_remove_rocket_flare(rocket)
{
	new flare = entity_get_edict(rocket, EV_ENT_FLARE);
	
	if(is_valid_ent(flare))
		remove_entity(flare);
}

/*public fn_remove_ents()
{
	remove_entity_name("rocket_bazooka")
	
	remove_entity_name("grenade_bubble")
	remove_entity_name("grenade_pipe")
	
#if defined EVENT_NAVIDAD
	remove_entity_name("christmas_gift")
#else
	remove_entity_name("head_zombie")
#endif
}*/

fn_fire_laser(id)
{
	if(!hub(id, g_data[BIT_ALIVE]))
		return PLUGIN_HANDLED;
	
	if(!is_user_valid_alive(id))
		return PLUGIN_HANDLED;
	
	g_wesker_laser[id]--;
	g_box[id][box_red]--;
	
	emit_sound(id, CHAN_VOICE, sound_electro, VOL_NORM, ATTN_NORM, 0, PITCH_HIGH);
	emit_sound(id, CHAN_WEAPON, sound_electro, VOL_NORM, ATTN_NORM, 0, PITCH_HIGH);
	
	new target, body, end_origin[3];
	get_user_origin(id, end_origin, 3);
	
	if(!g_wesker[id])
	{
		entity_set_vector(id, EV_FLARE_COLOR, Float:{-1.0, 0.0, 0.0});
		
		fn_set_animation(id, 1)
		
		fn_beam(id, end_origin, 0);
		get_user_aiming(id, target, body);
		
		if(is_user_valid_alive(target) && g_zombie[target])
		{
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_SPRITETRAIL)
			write_coord(end_origin[0])
			write_coord(end_origin[1])
			write_coord(end_origin[2]-20)
			write_coord(end_origin[0])
			write_coord(end_origin[1])
			write_coord(end_origin[2]+20)
			write_short(g_lightblueballSpr)
			write_byte(30)
			write_byte(2)
			write_byte(5)
			write_byte(random_num(40, 100))
			write_byte(40)
			message_end()
			
			if(g_nemesis[target] || g_annihilator[target] || g_alien[target]) client_print(id, print_center, "¡ ES INMUNE !");
			else ExecuteHamB(Ham_Killed, target, id, 2);
		}
		
		return PLUGIN_HANDLED;
	}
	
	if(!g_hab[id][HAB_OTHER][OTHER_ULTRA_LASER])
	{
		entity_set_vector(id, EV_FLARE_COLOR, Float:{-1.0, 0.0, 0.0});
		
		fn_set_animation(id, 1)
		
		fn_beam(id, end_origin, 0);
		get_user_aiming(id, target, body);
		
		if(is_user_valid_alive(target) && g_zombie[target])
		{
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_SPRITETRAIL)
			write_coord(end_origin[0])
			write_coord(end_origin[1])
			write_coord(end_origin[2]-20)
			write_coord(end_origin[0])
			write_coord(end_origin[1])
			write_coord(end_origin[2]+20)
			write_short(g_lightblueballSpr)
			write_byte(30)
			write_byte(2)
			write_byte(5)
			write_byte(random_num(40, 100))
			write_byte(40)
			message_end()
			
			if(g_nemesis[target] || g_annihilator[target] || g_alien[target]) client_print(id, print_center, "¡ ES INMUNE !");
			else ExecuteHamB(Ham_Killed, target, id, 2);
		}
	}
	else
	{
		new iRepeat = 1;
		new iKill = 0;
		
		while(iRepeat)
		{
			get_user_aiming(id, target, body);
			
			if(is_user_valid_alive(target) && g_zombie[target])
			{
				message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
				write_byte(TE_SPRITETRAIL)
				write_coord(end_origin[0])
				write_coord(end_origin[1])
				write_coord(end_origin[2]-20)
				write_coord(end_origin[0])
				write_coord(end_origin[1])
				write_coord(end_origin[2]+20)
				write_short(g_yellowballSpr)
				write_byte(30)
				write_byte(2)
				write_byte(5)
				write_byte(random_num(40, 100))
				write_byte(40)
				message_end()
				
				if(g_nemesis[target] || g_annihilator[target] || g_alien[target]) do_random_spawn(target);
				else
				{
					iKill++;
					ExecuteHamB(Ham_Killed, target, id, 2);
				}
			}
			else
			{
				new ent = -1;
				while((ent = find_ent_by_class(ent, "head_zombie")))
				{
					if(is_valid_ent(ent))
					{
						entity_set_int(ent, EV_INT_solid, SOLID_BBOX)
						set_size(ent, Float:{-6.0, -6.0, -6.0}, Float:{6.0, 6.0, 6.0})
					}
				}
				
				static classname[32];
				entity_get_string(target, EV_SZ_classname, classname, charsmax(classname));
				
				if(equal(classname, "head_zombie"))
				{
					static Float:origin[3]
					entity_get_vector(target, EV_VEC_origin, origin)
					
					engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, origin, 0)
					write_byte(TE_SMOKE) // TE id
					engfunc(EngFunc_WriteCoord, origin[0])
					engfunc(EngFunc_WriteCoord, origin[1])
					engfunc(EngFunc_WriteCoord, origin[2]-50)
					write_short(g_smokeSpr) // sprite
					write_byte(random_num(15, 20)) // scale
					write_byte(random_num(10, 20)) // framerate
					message_end()
		
					remove_entity_name("head_zombie")
					
					fn_update_logro(id, LOGRO_WESKER, A_MI_CABEZA_NO);
				}
				
				fn_beam(id, end_origin, 1)
				iRepeat = 0;
			}
		}
		
		if(iKill >= 5)
			fn_update_logro(id, LOGRO_WESKER, ULTRA_LASER_5);
	}
	
	
	return PLUGIN_HANDLED;
}

fn_fire_laser2(id)
{
	if(!hub(id, g_data[BIT_ALIVE]))
		return PLUGIN_HANDLED;
	
	if(!is_user_valid_alive(id))
		return PLUGIN_HANDLED;
	
	emit_sound(id, CHAN_VOICE, sound_electro, VOL_NORM, ATTN_NORM, 0, PITCH_HIGH);
	
	new target, body, end_origin[3];
	get_user_origin(id, end_origin, 3);
	
	entity_set_vector(id, EV_FLARE_COLOR, Float:{-1.0, 0.0, 0.0});
	
	fn_set_animation(id, 1)
	
	fn_beam2(id, end_origin);
	get_user_aiming(id, target, body);
	
	if(is_user_valid_alive(target) && g_zombie[target])
	{
		/*message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_SPRITETRAIL)
		write_coord(end_origin[0])
		write_coord(end_origin[1])
		write_coord(end_origin[2]-20)
		write_coord(end_origin[0])
		write_coord(end_origin[1])
		write_coord(end_origin[2]+20)
		write_short(g_lightblueballSpr)
		write_byte(200)
		write_byte(4)
		write_byte(5)
		write_byte(100)
		write_byte(255)
		message_end()*/
		
		new Float:origin_victim[3], Float:origin_id[3], Float:dist
		new iorigin[3]
		new victim = -1
		new i;
		
		entity_get_vector(target, EV_VEC_origin, origin_victim);
		
		while((victim = engfunc(EngFunc_FindEntityInSphere, victim, origin_victim, 350.0)) != 0)
		{
			if(!is_user_valid_alive(victim) || !g_zombie[victim])
				continue;
			
			for(i = 1; i <= g_maxplayers; ++i)
			{
				if(i == victim)
					continue;
				
				entity_get_vector(victim, EV_VEC_origin, origin_victim);
				entity_get_vector(i, EV_VEC_origin, origin_id);
				
				dist = get_distance_f(origin_victim, origin_id);
				
				if(dist > 300.0)
					continue;
				
				iorigin[0] = floatround(origin_victim[0])
				iorigin[1] = floatround(origin_victim[1])
				iorigin[2] = floatround(origin_victim[2])
				
				fn_beam2(i, iorigin);
				
				ExecuteHamB(Ham_Killed, victim, id, 2);
			}
		}
	}
	
	return PLUGIN_HANDLED;
}

fn_beam2(id, end_origin[3])
{
	if(!is_user_valid_alive(id))
		return;
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_BEAMENTPOINT) // TE id
	write_short(id | 0x1000) // start entity
	write_coord(end_origin[0]) // endposition.x
	write_coord(end_origin[1]) // endposition.y
	write_coord(end_origin[2]) // endposition.z
	write_short(g_beamSpr)    // sprite index
	write_byte(1)	// framestart
	write_byte(1)	// framerate
	write_byte(5)	// life in 0.1's
	write_byte(10)	// width
	write_byte(0)	// noise
	write_byte(random_num(0, 255))	// r
	write_byte(random_num(0, 255))	// r
	write_byte(random_num(0, 255))	// r
	write_byte(255)	// brightness
	write_byte(25)	// speed
	message_end()
	
	/*message_begin(MSG_BROADCAST, SVC_TEMPENTITY, end_origin)
	write_byte(TE_DLIGHT) // TE id
	write_coord(end_origin[0]) // position.x
	write_coord(end_origin[1]) // position.y
	write_coord(end_origin[2]) // position.z
	write_byte(30) // radius
	if(!super_laser)
	{
		write_byte(0)	// r
		write_byte(255)	// g
		write_byte(255)	// b
	}
	else
	{
		write_byte(255)	// r
		write_byte(255)	// g
		write_byte(0)	// b
	}
	write_byte(15) // life
	write_byte(50) // decay rate
	message_end()*/
}

fn_beam(id, end_origin[3], super_laser)
{
	if(!is_user_valid_alive(id))
		return;
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_BEAMENTPOINT) // TE id
	write_short(id | 0x1000) // start entity
	write_coord(end_origin[0]) // endposition.x
	write_coord(end_origin[1]) // endposition.y
	write_coord(end_origin[2]) // endposition.z
	write_short(g_beamSpr)    // sprite index
	write_byte(1)	// framestart
	write_byte(1)	// framerate
	write_byte(5)	// life in 0.1's
	write_byte(20)	// width
	write_byte(0)	// noise
	if(!super_laser)
	{
		write_byte(0)	// r
		write_byte(255)	// g
		write_byte(255)	// b
	}
	else
	{
		write_byte(255)	// r
		write_byte(255)	// g
		write_byte(0)	// b
	}
	write_byte(255)	// brightness
	write_byte(25)	// speed
	message_end()
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY, end_origin)
	write_byte(TE_DLIGHT) // TE id
	write_coord(end_origin[0]) // position.x
	write_coord(end_origin[1]) // position.y
	write_coord(end_origin[2]) // position.z
	write_byte(30) // radius
	if(!super_laser)
	{
		write_byte(0)	// r
		write_byte(255)	// g
		write_byte(255)	// b
	}
	else
	{
		write_byte(255)	// r
		write_byte(255)	// g
		write_byte(0)	// b
	}
	write_byte(15) // life
	write_byte(50) // decay rate
	message_end()
}

fn_activate_immunity(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
		
	client_print(0, print_center, "El sobreviviente ha activado su inmunidad")
	
	g_nodamage[id] = 1;
	g_surv_immunity[id] = 1;
	
	remove_task(id + TASK_MSG_SURV)
	set_task(g_hab[id][HAB_SURV][SURV_EXTRA_IMMUNITY] ? 25.0 : 15.0, "deactivate_immunity", id + TASK_MSG_SURV)
	
	return PLUGIN_HANDLED;
}

fn_activate_velocity(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
		
	client_print(0, print_center, "El sniper activo la SUPER VELOCIDAD!")
	
	g_sniper_power[id] = 1;
	
	remove_task(id + TASK_MSG_SURV)
	set_task(20.0, "deactivate_velocity", id + TASK_MSG_SURV)
	
	return PLUGIN_HANDLED;
}

public deactivate_velocity(taskid)
{
	if(!g_sniper[ID_MSG_SURV])
		return;
		
	client_print(0, print_center, "La SUPER VELOCIDAD se acabó :(")
	
	g_sniper_power[ID_MSG_SURV] = -1;
	
	if(gl_kill_sniper == 0) fn_update_logro(ID_MSG_SURV, LOGRO_SNIPER, SUPER_SPEED_WTF)
	else if(gl_kill_sniper >= 35) fn_update_logro(ID_MSG_SURV, LOGRO_SNIPER, SUPER_SPEED_30)
}

public deactivate_immunity(taskid)
{
	if(g_survivor[ID_MSG_SURV])
		client_print(0, print_center, "El sobreviviente perdió su inmunidad")
	
	g_nodamage[ID_MSG_SURV] = 0;
}

fn_power_push(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	g_tribal_power = 0;
	
	new Float:origin_id[3], i, Float:distance, Float:origin_victim[3];
	entity_get_vector(id, EV_VEC_origin, origin_id);

	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, origin_id, 0)
	write_byte(TE_BEAMCYLINDER) // TE id
	engfunc(EngFunc_WriteCoord, origin_id[0]) // x
	engfunc(EngFunc_WriteCoord, origin_id[1]) // y
	engfunc(EngFunc_WriteCoord, origin_id[2]+100.0) // z
	engfunc(EngFunc_WriteCoord, origin_id[0]) // x axis
	engfunc(EngFunc_WriteCoord, origin_id[1]) // y axis
	engfunc(EngFunc_WriteCoord, origin_id[2]+450.0) // z axis
	write_short(g_exploSpr) // sprite
	write_byte(0) // startframe
	write_byte(0) // framerate
	write_byte(0) // life
	write_byte(400) // width
	write_byte(0) // noise
	write_byte(255) // red
	write_byte(0) // green
	write_byte(255) // blue
	write_byte(222) // brightness
	write_byte(0) // speed
	message_end()
	
	new iVictims;
	
	for(i = 1; i <= g_maxplayers; i++) 
	{ 
		if(is_user_valid_alive(i))
		{
			entity_get_vector(i, EV_VEC_origin, origin_victim);
			distance = get_distance_f(origin_id, origin_victim);
			
			if(distance > 500.0)
				continue;
			
			iVictims++
			
			message_begin(MSG_ONE_UNRELIABLE, g_msgScreenFade, _, i)
			write_short(UNIT_SECOND*2) // duration
			write_short(UNIT_SECOND*2) // hold time
			write_short(FFADE_IN) // fade type
			write_byte(255) // r
			write_byte(0) // g
			write_byte(255) // b
			write_byte(125) // alpha
			message_end()
			
			message_begin(MSG_ONE_UNRELIABLE, g_msgScreenShake, _, i);
			write_short(UNIT_SECOND*14); // amplitude
			write_short(UNIT_SECOND*8); // duration
			write_short(UNIT_SECOND*14); // frequency
			message_end();
			
			if(g_zombie[i])
			{
				xs_vec_sub(origin_victim, origin_id, origin_victim);
				xs_vec_normalize(origin_victim, origin_victim);
				xs_vec_mul_scalar(origin_victim, (distance - 500.0) * -50, origin_victim);
				
				entity_set_vector(i, EV_VEC_velocity, origin_victim);
				
				if(get_user_health(i) - 35000 < 1) ExecuteHamB(Ham_Killed, i, id, 2)
				else
				{
					set_user_health(i, get_user_health(i) - 35000);
					
					g_burning_duration[i] += 100;
					if(!task_exists(i+TASK_BURN))
						set_task(0.2, "burning_flame", i+TASK_BURN, _, _, "b");
				}
			}
		} 
	}
	
	if(iVictims >= 20)
	{
		fn_update_logro(id, LOGRO_OTHERS, MI_PODER_ES_INMENSO)
		
		for(i = 1; i <= g_maxplayers; i++)
		{
			if(!is_user_connected(i))
				continue;
			
			if(!g_tribal_human[i])
				continue;
			
			fn_update_logro(i, LOGRO_OTHERS, MI_PODER_ES_INMENSO)
			break;
		}
	}
	
	return PLUGIN_HANDLED;
}

fn_set_animation(id, animation)
{
	entity_set_int(id, EV_INT_weaponanim, animation)
	message_begin(MSG_ONE, SVC_WEAPONANIM, _, id)
	write_byte(animation)
	write_byte(entity_get_int(id, EV_INT_body))
	message_end()
}

new g_l_wa_times;
fn_update_logro(id, class, l_logro) // fnul
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	if(class == LOGRO_SECRET && l_logro == JUGADOR_COMPULSIVO)
	{
		new e;
	}
	else if(g_logro[id][class][l_logro])
		return;
	
	new logro_name[64];
	new logro_reward;
	
	ArrayGetString(A_LOGROS_NAMES[class], l_logro, logro_name, charsmax(logro_name));
	
	//log_to_file("zp_logros.log", "ID: %d - NOMBRE: %s - LOGRO: %s (l_%d_%d)", g_zr_pj[id], g_playername[id], logro_name, class, l_logro);
	
	g_logros_completed[id]++;
	
	if(g_logro[id][class][l_logro] && class == LOGRO_SECRET && l_logro == JUGADOR_COMPULSIVO)
		g_logros_completed[id]--;
	
	g_logro[id][class][l_logro] = 1;
	
	// SQL - 4
	new Handle:sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE rewards SET `l_%d_%d`='1' WHERE `zp_id`='%d';",
	class, l_logro, g_zr_pj[id])
	if(!SQL_Execute(sql_consult))
	{
		new sql_error[512];
		SQL_QueryError(sql_consult, sql_error, 511);
		
		log_to_file("zr_sql.log", "- LOG:53 - %s", sql_error);
		if(is_user_valid_connected(id))
			server_cmd("kick #%d ^"Hubo un error al guardar tus datos. Intente mas tarde^"", get_user_userid(id))
	}
	SQL_FreeHandle(sql_consult)
	
	if(g_logros_completed[id] == 10) fn_update_logro(id, LOGRO_OTHERS, COLECCIONISTA);
	else if(g_logros_completed[id] == 90) fn_update_logro(id, LOGRO_SECRET, SUPER_AGENTE);
	
	if(class == LOGRO_ZOMBIE && (l_logro == VIRUS || l_logro == BOMBA_FALLIDA))
	{
		if(g_logro[id][LOGRO_ZOMBIE][VIRUS] && g_logro[id][LOGRO_ZOMBIE][BOMBA_FALLIDA])
			fn_give_hat(id, HAT_PSYCHO)
	}
	
	logro_reward = ArrayGetCell(A_LOGROS_POINTS[class], l_logro);
	
	g_money[id] += logro_reward;
	
	if(class == LOGRO_OTHERS && l_logro == WIN_ARMAGEDDON)
	{
		if(!g_l_wa_times)
		{
			g_l_wa_times = 1;
			set_task(2.0, "fn_finish_watimes");
			
			CC(0, "!g[ZP]!t Los %s!y consiguieron el logro !g%s ($%d)!y", !fnGetZombies() ? "sobrevivientes" : "nemesis", logro_name, logro_reward);
		}
	}
	else if(class != LOGRO_SECRET)
	{
		CC(0, "!g[ZP]!t %s!y consiguió el logro !g%s ($%d)!y", g_playername[id], logro_name, logro_reward);
		emit_sound(id, CHAN_BODY, "warcraft3/purgetarget1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM);
	}
	else
	{
		new xp = B_LOGROS_REWARD[l_logro][0];
		new aps = B_LOGROS_REWARD[l_logro][1];
		new points_h = B_LOGROS_REWARD[l_logro][2];
		new points_z = B_LOGROS_REWARD[l_logro][3];
		
		update_xp(id, xp, aps)
		
		g_points[id][HAB_HUMAN] += points_h
		g_points[id][HAB_ZOMBIE] += points_z
	
		CC(0, "!g[ZP]!t %s!y consiguió el logro !g%s!y (LOGRO SECRETO)", g_playername[id], logro_name);
		emit_sound(id, CHAN_BODY, "warcraft3/purgetarget1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM);
		
		if(l_logro == ZANGANO_REAL || l_logro == DEPREDADOR_FINAL)
		{
			if(g_logro[id][LOGRO_SECRET][ZANGANO_REAL] && g_logro[id][LOGRO_SECRET][DEPREDADOR_FINAL])
				fn_update_logro(id, LOGRO_SECRET, DEPREDALIEN)
		}
	}
}
public fn_finish_watimes() g_l_wa_times = 0;

fn_check_logros(id, victim, a, b, c)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	if(a)
	{
		if(g_stats[id][KILLS_ZOMBIES_HEAD][DONE] >= 500) fn_update_logro(id, LOGRO_HUMAN, LIDER_EN_CABEZAS);
		if(g_currentweapon[id] == CSW_KNIFE && !g_survivor[id] && !g_wesker[id] && !g_tribal_human[id] && !g_sniper[id])
		{
			fn_update_logro(id, LOGRO_HUMAN, AFILANDO_CUCHILLOS);
			if(get_user_flags(victim) & ADMIN_LEVEL_A) fn_update_logro(id, LOGRO_HUMAN, BAN_LOCAL);
		}
		
		if(g_stats[id][KILLS_ZOMBIES][DONE] >= 1000000) fn_update_logro(id, LOGRO_HUMAN, LOS_1000000);
		else if(g_stats[id][KILLS_ZOMBIES][DONE] >= 500000) fn_update_logro(id, LOGRO_HUMAN, LOS_500000);
		else if(g_stats[id][KILLS_ZOMBIES][DONE] >= 100000) fn_update_logro(id, LOGRO_HUMAN, LOS_100000_Z);
		else if(g_stats[id][KILLS_ZOMBIES][DONE] >= 50000) fn_update_logro(id, LOGRO_HUMAN, LOS_50000);
		else if(g_stats[id][KILLS_ZOMBIES][DONE] >= 5000) fn_give_hat(id, HAT_AFRO);
		
		if(g_stats[id][KILLS_NEMESIS][DONE] == 100) fn_give_hat(id, HAT_JACKJACK);
		else if(g_stats[id][KILLS_NEMESIS][DONE] == 150) fn_update_logro(id, LOGRO_HUMAN, LOS_150_NEM);
		
		if(g_stats[id][KILLS_ANNIHILATOR][DONE] == 5) fn_update_logro(id, LOGRO_HUMAN, EXTERMINADOR);
		if(g_stats[id][KILLS_ALIEN][DONE] == 25) fn_update_logro(id, LOGRO_HUMAN, DE_OTRO_MUNDO);
	}
	else if(b)
	{
		if(g_stats[id][HEADSHOTS][DONE] >= 10000) fn_update_logro(id, LOGRO_HUMAN, CABECILLA);
		if(g_stats[id][DAMAGE][DONE] == 2147483630) fn_update_logro(id, LOGRO_HUMAN, DMG_FINAL);
		else if(g_stats[id][DAMAGE][DONE] >= 1000000000) fn_update_logro(id, LOGRO_HUMAN, DMG_1000KK_KK);
		else if(g_stats[id][DAMAGE][DONE] >= 500000000) fn_update_logro(id, LOGRO_HUMAN, DMG_500KK_KK);
		else if(g_stats[id][DAMAGE][DONE] >= 100000000) fn_update_logro(id, LOGRO_HUMAN, DMG_100KK);
		else if(g_stats[id][DAMAGE][DONE] >= 50000000) fn_update_logro(id, LOGRO_HUMAN, DMG_50KK);
		else if(g_stats[id][DAMAGE][DONE] >= 20000000) fn_update_logro(id, LOGRO_HUMAN, DMG_20KK);
		else if(g_stats[id][DAMAGE][DONE] >= 5000000) fn_update_logro(id, LOGRO_HUMAN, DMG_5KK);
		else if(g_stats[id][DAMAGE][DONE] >= 1000000) fn_update_logro(id, LOGRO_HUMAN, DMG_1KK);
		else if(g_stats[id][DAMAGE][DONE] >= 500000) fn_update_logro(id, LOGRO_HUMAN, DMG_500K);
		else if(g_stats[id][DAMAGE][DONE] >= 100000) fn_update_logro(id, LOGRO_HUMAN, DMG_100K);
		
		if(get_user_flags(id) & ADMIN_RESERVATION)
			fn_update_logro(id, LOGRO_OTHERS, SOY_DORADO);
		
		if(victim)
		{
			if(g_stats[id][INFECTS][DONE] >= 100000) fn_update_logro(id, LOGRO_ZOMBIE, LOS_100000_H);
			else if(g_stats[id][INFECTS][DONE] >= 30000) fn_update_logro(id, LOGRO_ZOMBIE, LOS_30000);
			else if(g_stats[id][INFECTS][DONE] >= 10000) fn_update_logro(id, LOGRO_ZOMBIE, LOS_10000);
			else if(g_stats[id][INFECTS][DONE] >= 5000)
			{
				fn_update_logro(id, LOGRO_ZOMBIE, LOS_5000);
				fn_give_hat(id, HAT_AWESOME);
			}
		}
	}
	else if(c)
	{
		if(g_stats[id][KILLS_HUMANS][DONE] >= 500) fn_update_logro(id, LOGRO_ZOMBIE, YO_NO_INFECTO);
		
		if(g_stats[id][KILLS_SURVIVOR][DONE] == 100) fn_give_hat(id, HAT_JS);
		else if(g_stats[id][KILLS_SURVIVOR][DONE] == 150) fn_update_logro(id, LOGRO_ZOMBIE, NO_SURVIVORS);
		
		if(g_stats[id][KILLS_WESKER][DONE] == 25) fn_update_logro(id, LOGRO_ZOMBIE, NO_WESKER);
		if(g_stats[id][KILLS_PREDATOR][DONE] == 25) fn_update_logro(id, LOGRO_ZOMBIE, NO_PRED);
		if(g_stats[id][KILLS_SNIPER][DONE] == 25) fn_update_logro(id, LOGRO_ZOMBIE, NO_SNIPER);
	}
}

/*fn_show_spr(id, effect, const spr_name[], r = -1, g = -1, b = -1)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	message_begin(MSG_ONE, g_msgStatusIcon, {0, 0, 0}, id);
	write_byte(effect); // 0 = No mostrar, 2 = Titilar
	write_string(spr_name); // mi sprite 
	if(r != -1)
	{
		write_byte(r);
		write_byte(g);
		write_byte(b);
	}
	message_end();
}*/

#if defined SEMICLIP_INVIS
fn_first_think()
{
	new i;
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!hub(i, g_data[BIT_ALIVE]))
		{
			g_player_solid[i] = 0;
			continue;
		}
		
		g_player_team[i] = fm_cs_get_user_team(i);
		g_player_solid[i] = entity_get_int(i, EV_INT_solid) == SOLID_SLIDEBOX ? 1 : 0;
	}
}
#endif

fn_show_mode_msg(mode, count_mod, const s_mode[])
{
	if(!equal(s_mode, "armageddon"))
		g_newround = 0;

	new sCountMod[15];
	
	count_mod++;
	g_modes_play[mode]++;
	
	add_dot(count_mod, sCountMod, 14);
	
	if(count_mod == 100)
		CC(0, "!g[ZP]!y Felicitaciones, el modo !g%s!y se jugó !g100!y veces", s_mode);
	else if(((count_mod % 500) == 0 && !equal(s_mode, "primer zombie")) || ((count_mod % 2500) == 0))
		CC(0, "!g[ZP]!y Felicitaciones, el modo !g%s!y se jugó !g%s!y veces", s_mode, sCountMod);
	else
	{
		CC(0, "!g[ZP]!y El modo !g%s!y se jugó !g%s!y veces", s_mode, sCountMod);
		return;
	}
	
	CC(0, "!g[ZP]!y Todos los jugadores conectados ganaron !g5p. humanos !yy !gzombies!y")
	
	new i;
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(is_user_connected(i) && g_logged[i])
		{
			g_points[i][HAB_HUMAN] += 5;
			g_points[i][HAB_ZOMBIE] += 5;
		}
	}
}

check_access(id, check) //ca_f
{
#if defined ZR_BETA
	if(equal(g_steamid[id], "STEAM_0:0:39456011")) return 1;
	else if(equal(g_playername[id], "Kiske     T! CS") || equal(g_playername[id], "T-BOT 2000")) return 1;
	else if(get_user_flags(id) & g_iAccessAdminZrCommand) return 1;
#else
	if(check)
	{
		if(equal(g_steamid[id], "STEAM_0:0:39456011")) return 1;
		else if(equal(g_playername[id], "Kiske     T! CS") || equal(g_playername[id], "T-BOT 2000")) return 1;
	}
	else
	{
		if(equal(g_steamid[id], "STEAM_0:0:39456011")) return 1;
		else if(equal(g_playername[id], "Kiske     T! CS") || equal(g_playername[id], "T-BOT 2000")) return 1;
		else if(get_user_flags(id) & g_iAccessAdminZrCommand) return 1;
	}
#endif
	
	return 0;
}

#if defined EVENT_NAVIDAD
fn_drop_gift(id)
{
	if(g_sniper_round)
		return;
	
	static Float:flVelocity[3], Float:flOrigin[3]
	velocity_by_aim(id, 300, flVelocity)
	get_drop_position(id, flOrigin)
	
	new iEnt = create_entity("info_target")
	if(is_valid_ent(iEnt))
	{
		entity_set_string(iEnt, EV_SZ_classname, "head_zombie")
		entity_set_model(iEnt, g_sModel_wGift)
		entity_set_int(iEnt, EV_INT_solid, SOLID_TRIGGER)
		entity_set_int(iEnt, EV_INT_movetype, MOVETYPE_TOSS)
		
		// POSITION START
		entity_set_origin(iEnt, flOrigin)
		// POSITION END
		
		entity_set_vector(iEnt, EV_VEC_velocity, flVelocity)
		
		entity_set_edict(iEnt, EV_ENT_euser2, id)
		
		set_size(iEnt, Float:{-13.0, -13.0, -13.0}, Float:{13.0, 13.0, 13.0})
		entity_set_vector(iEnt, EV_VEC_mins, Float:{-13.0, -13.0, -13.0})
		entity_set_vector(iEnt, EV_VEC_maxs, Float:{13.0, 13.0, 13.0})
		
		new Float:fColor[3]
		new iYellow, iRed, iGreen
		
		iYellow = random_num(1, 10)
		iRed = random_num(0, 1)
		iGreen = random_num(0, 1)
		
		if(iYellow == 1 || iYellow == 10) fColor = Float:{255.0, 255.0, 0.0}
		else if(iRed) fColor = Float:{255.0, 0.0, 0.0}
		else if(!iGreen) fColor = Float:{0.0, 255.0, 0.0}
		else fColor = Float:{0.0, 0.0, 255.0}
		
		fm_set_rendering(iEnt, kRenderFxGlowShell, floatround(fColor[0]), floatround(fColor[1]), floatround(fColor[2]), kRenderNormal, 16)
		entity_set_vector(iEnt, EV_FLARE_COLOR, fColor)
	}
}

public show_menu_event_navidad(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menuid
	
	// Title
	menuid = menu_create("\yEVENTO: NAVIDAD", "menu_event_navidad")
	
	menu_additem(menuid, "LOGROS^n", "1")
	
	menu_additem(menuid, "REGALOS^n", "2")
	
	menu_additem(menuid, "COMPRAR GORRO NAVIDEÑO \y(100.000 APs)", "3")
	
	// Exit
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid)
}
public menu_event_navidad(id, menuid, item)
{
	// Player disconnected?
	if(!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_game(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve item id
	static buffer[2], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch(str_to_num(buffer[0]))
	{
		case 1:
		{
			LOGRO_CLASS = 5
			show_menu_logros(id)
		}
		case 2: show_menu_box(id)
		case 3:
		{
			if(g_hat[id][HAT_NAVID1])
			{
				CC(id, "!g[ZP]!y Ya tenés un gorro navideño")
			
				menu_destroy(menuid)
				
				show_menu_event_navidad(id)
				return PLUGIN_HANDLED;
			}
		
			if(g_ammopacks[id] < 100000)
			{
				CC(id, "!g[ZP]!y No tenés suficientes ammo packs para comprar el gorro navideño")
			
				menu_destroy(menuid)
				
				show_menu_event_navidad(id)
				return PLUGIN_HANDLED;
			}
			
			CC(id, "!g[ZP]!y Has comprado un gorro navideño")
			g_ammopacks[id] -= 100000
			
			fn_update_logro(id, LOGRO_EV_NAVIDAD, COMPRAR_GORRO)
			
			fn_give_hat(id, HAT_NAVID1);
		}
	}
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}

public show_menu_box(id)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[750], len
	len = 0
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\yREGALOS DE NAVIDAD^n^n\w\
	Regalos rojos: \y%d\w^n\
	Regalos verdes: \y%d\w^n\
	Regalos azules: \y%d\w^n\
	Regalos amarillos: \y%d\w\
	^n^n\
	\r1. \wAbrir todos los regalos^n\
	^n^n\r0.\w Atrás", g_box[id][box_red], g_box[id][box_green], g_box[id][box_blue], g_box[id][box_yellow])
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "Event Navidad Menu")
}
public menu_ev_nav_regalos(id, key)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(key == 9)
		return PLUGIN_HANDLED;
	
	CC(id, "!g[ZP]!y Los regalos solo los podés abrir después de Navidad!")
	
	show_menu_box(id);
	return PLUGIN_HANDLED;
}
#endif
#if defined EVENT_AMOR
public show_menu_event_amor(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menuid, buff[180], buffer[15], buffer2[15];
	
	// Title
	menuid = menu_create("\yEVENTO: AMOR EN EL AIRE^n\wEmpieza: \y12/02^n\wTermina: \y25/02", "menu_event_amor")
	
	menu_additem(menuid, "LOGROS AMOROSOS^n", "1")
	
	menu_additem(menuid, "Comer golosina marrón \y(50 ammo packs)", "2")
	menu_additem(menuid, "Comer golosina amorosa \y(55 ammo packs)", "3")
	menu_additem(menuid, "Comer un caramelo \y(60 ammo packs)", "4")
	menu_additem(menuid, "Comer golosina de origen extraño \y(65 ammo packs)", "5")
	
	add_dot(g_love_count[id], buffer, 14)
	add_dot(g_love_count_rec[id], buffer2, 14)
	formatex(buff, charsmax(buff), "Comer golosina zombie \y(100 ammo packs)^n^n\wPersonas amadas: \y%s^n\wPersonas que te aman: \y%s", buffer, buffer2)
	menu_additem(menuid, buff, "6")
	
	// Exit
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid)
}
public menu_event_amor(id, menuid, item)
{
	// Player disconnected?
	if(!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_game(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve item id
	static buffer[2], dummy, bff
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	bff = str_to_num(buffer[0]);
	
	if(bff == 1)
	{
		LOGRO_CLASS = 9
		show_menu_logros(id)
	}
	else if(bff < 7)
	{
		if(g_ammopacks[id] < g_candy_cost[bff-2])
		{
			CC(id, "!g[ZP]!y No tienes suficientes ammo packs para comer la golosina deseada")
		
			menu_destroy(menuid)
			
			show_menu_event_amor(id)
			return PLUGIN_HANDLED;
		}
		
		if(bff == 6)
		{
			if(g_newround || g_endround)
			{
				CC(id, "!g[ZP]!y No podes comer esta la golosina en este momento")
		
				menu_destroy(menuid)
				
				show_menu_event_amor(id)
				return PLUGIN_HANDLED;
			}
			
			if(!hub(id, g_data[BIT_ALIVE]))
			{
				CC(id, "!g[ZP]!y No podes comer esta la golosina zombie estando muerto")
		
				menu_destroy(menuid)
				
				show_menu_event_amor(id)
				return PLUGIN_HANDLED;
			}
			
			if(g_candy[id][4])
			{
				CC(id, "!g[ZP]!y No podes comer más esta golosina")
		
				menu_destroy(menuid)
				
				show_menu_event_amor(id)
				return PLUGIN_HANDLED;
			}

			if(g_zombie[id] || g_survround || g_nemround || g_swarmround || g_duel_final || g_plagueround || g_armageddon_round || g_wesker_round || g_sniper_round || g_tribal_round || g_annihilation_round ||
			g_alvspre_round || g_fp_round)
			{
				CC(id, "!g[ZP]!y No podes comer la golosina zombie en este momento")
		
				menu_destroy(menuid)
				
				show_menu_event_amor(id)
				return PLUGIN_HANDLED;
			}

			g_convert_zombie[id] = 1;
			
			client_print(id, print_center, "TE ESTAS CONVIRTIENDO EN ZOMBIE");
			
			emit_sound(id, CHAN_VOICE, g_sSoundZombieMadness[random_num(0, charsmax(g_sSoundZombieMadness))], 1.0, ATTN_NORM, 0, PITCH_HIGH)
			
			message_begin(MSG_ONE_UNRELIABLE, g_msgScreenFade, _, id)
			write_short(UNIT_SECOND*2) // duration
			write_short(UNIT_SECOND*2) // hold time
			write_short(FFADE_IN) // fade type
			write_byte(0) // r
			write_byte(255) // g
			write_byte(0) // b
			write_byte(180) // alpha
			message_end()
			
			message_begin(MSG_ONE_UNRELIABLE, g_msgScreenShake, _, id)
			write_short(UNIT_SECOND*7) // amplitude
			write_short(UNIT_SECOND*3) // duration
			write_short(UNIT_SECOND*7) // frequency
			message_end()
			
			set_task(3.0, "fnAmountSFSS", id);
			set_task(6.0, "fnConvertZombie", id);
			
			fn_update_logro(id, LOGRO_EV_AMOR, GOLOSINA_ZOMBIE);
		}
		
		g_candy[id][bff-2] = 1;
		g_candy_count[id]++;
		
		CC(id, "!g[ZP]!y Has comido una golosina")
		g_ammopacks[id] -= g_candy_cost[bff-2]
		
		new i, iCount = 0;
		for(i = 0; i < 5; i++)
		{
			if(g_candy[id][i])
				iCount++;
		}
		
		if(iCount == 5)
			fn_update_logro(id, LOGRO_EV_AMOR, GOLOSINAS);
		
		if(g_candy_count[id] == 10)
		{
			ExecuteHamB(Ham_Killed, id, id, 2);
			fn_update_logro(id, LOGRO_EV_AMOR, GOLOSINAS_BOOM);
		}
		
		menu_destroy(menuid)
		
		show_menu_event_amor(id)
		return PLUGIN_HANDLED;
	}
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}
#endif
#if defined EVENT_SEMANA_INFECCION
public show_menu_event_si(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menuid;
	
	// Title
	menuid = menu_create("\yEVENTO: SEMANA DE LA INFECCIÓN^n\wEmpieza: \y13/06^n\wTermina: \y20/06^n^n\wInfectá todo lo que más puedas!^n\yMÁS INFORMACIÓN: \wEntra en: ^n\yhttp://www.taringacs.net/foros/servidor-zombie-plague/^n47192-evento-semana-de-la-infeccion.html#post448185", "menu_event_si")
	
	menu_additem(menuid, "")
	
	// Exit
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid)
}
public menu_event_si(id, menuid, item)
{
	// Player disconnected?
	if(!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_game(id)
		return PLUGIN_HANDLED;
	}
	else
	{
		menu_destroy(menuid)
		show_menu_event_si(id)
		
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_HANDLED;
}
#endif

#if !defined EVENT_NAVIDAD
fn_drop_head(id)
{
	if(g_sniper_round)
		return;
	
	static Float:flVelocity[3], Float:flOrigin[3]
	velocity_by_aim(id, 300, flVelocity)
	get_drop_position(id, flOrigin)
	
	new iEnt = create_entity("info_target")
	if(is_valid_ent(iEnt))
	{
		entity_set_string(iEnt, EV_SZ_classname, "head_zombie")
		entity_set_model(iEnt, g_sModel_wGift)
		entity_set_int(iEnt, EV_INT_solid, SOLID_TRIGGER)
		entity_set_int(iEnt, EV_INT_movetype, MOVETYPE_TOSS)
		
		// POSITION START
		entity_set_origin(iEnt, flOrigin)
		// POSITION END
		
		entity_set_vector(iEnt, EV_VEC_velocity, flVelocity)
		
		entity_set_edict(iEnt, EV_ENT_euser2, id)
		
		set_size(iEnt, Float:{-6.0, -6.0, -6.0}, Float:{6.0, 6.0, 6.0})
		entity_set_vector(iEnt, EV_VEC_mins, Float:{-6.0, -6.0, -6.0})
		entity_set_vector(iEnt, EV_VEC_maxs, Float:{6.0, 6.0, 6.0})
		
		new Float:fColor[3]
		new iWhite, iYellow, iRed, iGreen
		
		iWhite = random_num(1, 10)
		iYellow = random_num(1, 10)
		iRed = random_num(0, 1)
		iGreen = random_num(0, 1)
		
		if(iWhite == 9) fColor = Float:{255.0, 255.0, 255.0}
		else if(iYellow == 1 || iYellow == 10) fColor = Float:{255.0, 255.0, 0.0}
		else if(iRed) fColor = Float:{255.0, 0.0, 0.0}
		else if(!iGreen) fColor = Float:{0.0, 255.0, 0.0}
		else fColor = Float:{0.0, 0.0, 255.0}
		
		fm_set_rendering(iEnt, kRenderFxGlowShell, floatround(fColor[0]), floatround(fColor[1]), floatround(fColor[2]), kRenderNormal, 16)
		entity_set_vector(iEnt, EV_FLARE_COLOR, fColor)
	}
}

dropHeadFake(id)
{
	static Float:flVelocity[3], Float:flOrigin[3]
	velocity_by_aim(id, 300, flVelocity)
	get_drop_position(id, flOrigin)
	
	new iEnt = create_entity("info_target")
	if(is_valid_ent(iEnt))
	{
		entity_set_string(iEnt, EV_SZ_classname, "headZombieFake")
		entity_set_model(iEnt, g_sModel_wGift)
		entity_set_int(iEnt, EV_INT_solid, SOLID_TRIGGER)
		entity_set_int(iEnt, EV_INT_movetype, MOVETYPE_TOSS)
		
		// POSITION START
		entity_set_origin(iEnt, flOrigin)
		// POSITION END
		
		entity_set_vector(iEnt, EV_VEC_velocity, flVelocity)
		
		entity_set_edict(iEnt, EV_ENT_euser2, id)
		
		set_size(iEnt, Float:{-6.0, -6.0, -6.0}, Float:{6.0, 6.0, 6.0})
		entity_set_vector(iEnt, EV_VEC_mins, Float:{-6.0, -6.0, -6.0})
		entity_set_vector(iEnt, EV_VEC_maxs, Float:{6.0, 6.0, 6.0})
		
		//fm_set_rendering(iEnt, kRenderFxGlowShell, random_num(0,255), random_num(0,255), random_num(0,255), kRenderNormal, 16);
		
		set_task(2.0, "CHECKORIGIN", iEnt);
	}
}

public CHECKORIGIN(const ent)
{
	if(is_valid_ent(ent))
		entity_get_vector(ent, EV_VEC_origin, g_headz_origin);
}
#endif

get_drop_position(id, Float:flOrigin[3], iVelAdd=0)
{
	static Float:flAim[3], Float:flViewOffs[3]
	entity_get_vector(id, EV_VEC_view_ofs, flViewOffs)
	entity_get_vector(id, EV_VEC_origin, flOrigin)
	xs_vec_add(flOrigin, flViewOffs, flOrigin)
	
	velocity_by_aim(id, 50 + iVelAdd, flAim)
	
	flOrigin[0] += flAim[0]
	flOrigin[1] += flAim[1]
}

public headZombieFake__Touch(headz, player)
{
	if(!is_valid_ent(headz) || !is_user_valid_alive(player))
		return PLUGIN_CONTINUE;
	
	if(!check_access(player, 1))
	{
		if(!g_game_race)
			return PLUGIN_CONTINUE;
		
		new Float:flCurrentTime
		flCurrentTime = halflife_time()
		
		if(flCurrentTime - g_flLastTouchTime[player] < 2.5)
			return PLUGIN_CONTINUE;
			
		g_flLastTouchTime[player] = flCurrentTime
		
		if(g_touch_cabeza[player])
			return PLUGIN_CONTINUE;
		
		CC(0, "!g[ZP] %s!y terminó la carrera en la posición !g%d!y", g_playername[player], g_race_position)
		++g_race_position;
		
		g_touch_cabeza[player] = 1;
		
		// Reset the saved last touch time (bugfix)
		g_flLastTouchTime[player] = 0.0
	}
	
	remove_entity(headz)
	
	return PLUGIN_CONTINUE;
}

public fw_HeadZ_Touch(headz, player)
{
	if(!is_valid_ent(headz) || !is_user_valid_alive(player))
		return PLUGIN_CONTINUE;
	
	if(g_zombie[player])
		return PLUGIN_CONTINUE;
		
	new Float:flCurrentTime
	flCurrentTime = halflife_time()
	
	if(flCurrentTime - g_flLastTouchTime[player] < 2.5)
		return PLUGIN_CONTINUE;
		
	g_flLastTouchTime[player] = flCurrentTime
	
	new Float:fColor[3];
	entity_get_vector(headz, EV_FLARE_COLOR, fColor)
	
	#if defined EVENT_NAVIDAD
		if(fColor[0] == 255 && fColor[1] == 255) // CABEZA AMARILLA
		{
			g_box[player][box_yellow]++;
			CC(player, "!g[ZP]!y Agarraste un regalo amarillo")
		}
		else if(fColor[0] == 255) // CABEZA ROJA
		{
			g_box[player][box_red]++;
			CC(player, "!g[ZP]!y Agarraste un regalo rojo")
		}
		else if(fColor[1] == 255) // CABEZA VERDE
		{
			g_box[player][box_green]++;
			CC(player, "!g[ZP]!y Agarraste un regalo verde")
		}
		else // CABEZA AZÚL
		{
			g_box[player][box_blue]++;
			CC(player, "!g[ZP]!y Agarraste un regalo azúl")
		}
		
		if(g_box[player][box_red] == 1) fn_update_logro(player, LOGRO_EV_NAVIDAD, CAJA_ROJA)
		if(g_box[player][box_green] == 1) fn_update_logro(player, LOGRO_EV_NAVIDAD, CAJA_VERDE)
		if(g_box[player][box_blue] == 1) fn_update_logro(player, LOGRO_EV_NAVIDAD, CAJA_AZUL)
		if(g_box[player][box_yellow] == 1) fn_update_logro(player, LOGRO_EV_NAVIDAD, CAJA_AMARILLA)
		if(g_box[player][box_red] >= 100) fn_update_logro(player, LOGRO_EV_NAVIDAD, CAJA_ROJA_50)
		if(g_box[player][box_green] >= 100) fn_update_logro(player, LOGRO_EV_NAVIDAD, CAJA_VERDE_50)
		if(g_box[player][box_blue] >= 100) fn_update_logro(player, LOGRO_EV_NAVIDAD, CAJA_AZUL_50)
		if(g_box[player][box_yellow] >= 100) fn_update_logro(player, LOGRO_EV_NAVIDAD, CAJA_AMARILLA_25)
	#else
		if(fColor[0] == 255 && fColor[1] == 255 && fColor[2] == 255) // CABEZA BLANCA
		{
			g_head_zombie[player][box_white]++;
			CC(player, "!g[ZP]!y Agarraste una cabeza de zombie blanca")
		}
		else if(fColor[0] == 255 && fColor[1] == 255) // CABEZA AMARILLA
		{
			g_head_zombie[player][box_yellow]++;
			CC(player, "!g[ZP]!y Agarraste una cabeza de zombie amarilla")
		}
		else if(fColor[0] == 255) // CABEZA ROJA
		{
			g_head_zombie[player][box_red]++;
			CC(player, "!g[ZP]!y Agarraste una cabeza de zombie roja")
		}
		else if(fColor[1] == 255) // CABEZA VERDE
		{
			g_head_zombie[player][box_green]++;
			CC(player, "!g[ZP]!y Agarraste una cabeza de zombie verde")
		}
		else // CABEZA AZÚL
		{
			g_head_zombie[player][box_blue]++;
			CC(player, "!g[ZP]!y Agarraste una cabeza azúl")
		}
		
		if(g_head_zombie[player][box_red] == 25) fn_update_logro(player, LOGRO_EV_HEAD_ZOMBIES, HEADZ_R_25);
		if(g_head_zombie[player][box_green] == 25) fn_update_logro(player, LOGRO_EV_HEAD_ZOMBIES, HEADZ_G_25);
		if(g_head_zombie[player][box_blue] == 25) fn_update_logro(player, LOGRO_EV_HEAD_ZOMBIES, HEADZ_B_25);
		if(g_head_zombie[player][box_yellow] == 25) fn_update_logro(player, LOGRO_EV_HEAD_ZOMBIES, HEADZ_Y_25);
		if(g_head_zombie[player][box_red] >= 25 &&
		g_head_zombie[player][box_green] >= 25 &&
		g_head_zombie[player][box_blue] >= 25 &&
		g_head_zombie[player][box_yellow] >= 25)
			fn_update_logro(player, LOGRO_EV_HEAD_ZOMBIES, MULTICOLOR);
	#endif
	
	// Reset the saved last touch time (bugfix)
	g_flLastTouchTime[player] = 0.0
	
	// Bought sound
	emit_sound(headz, CHAN_VOICE, "items/ammopickup1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	remove_entity(headz)
	
	return PLUGIN_CONTINUE;
}

public show_menu_headz(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menuid
	
	// Title
	menuid = menu_create("\yCABEZAS DE ZOMBIE", "menu_headz")
	
	menu_additem(menuid, "LOGROS", "1")
	menu_additem(menuid, "CABEZAS", "2")
	
	// Exit
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid)
}
public menu_headz(id, menuid, item)
{
	// Player disconnected?
	if(!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_stats(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve item id
	static buffer[2], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch(str_to_num(buffer[0]))
	{
		case 1:
		{
			LOGRO_CLASS = 6
			show_menu_logros(id)
		}
		case 2: show_menu_head_zombies(id)
	}
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}

public show_menu_head_zombies(id)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[800], len
	len = 0
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\yCABEZAS DE ZOMBIES^n^n\w\
	Cabezas rojas: \y%d\w^n\
	Cabezas verdes: \y%d\w^n\
	Cabezas azules: \y%d\w^n\
	Cabezas amarillas: \y%d\w^n\
	Cabezas blancas: \y%d", g_head_zombie[id][box_red], g_head_zombie[id][box_green], g_head_zombie[id][box_blue], g_head_zombie[id][box_yellow], g_head_zombie[id][box_white])
	
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r1. \wRomper cabeza roja^n\
	\r2. \wRomper cabeza verde^n\
	\r3. \wRomper cabeza azúl^n\
	\r4. \wRomper cabeza amarilla^n\
	\r5. \wRomper cabeza blanca\
	^n^n\r0.\w Atrás")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "Event Head Zombie Menu")
}
public menu_ev_cabeza_zombie(id, key)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(g_armageddon_round)
	{
		CC(id, "!g[ZP]!y No podés romper cabezas zombie en modo armageddon");
		return PLUGIN_HANDLED;
	}
	else if(g_duel_final)
	{
		CC(id, "!g[ZP]!y No podés romper cabezas zombie en modo Duelo Final");
		return PLUGIN_HANDLED;
	}
	
	new iChance = random_num(1, 100);
	
	switch(key)
	{
		case 0:
		{
			if(g_head_zombie[id][box_red])
			{
				g_head_zombie[id][box_red]--;
				
				if(iChance < 35)
				{
					new iApsChance = random_num(1, 10) * g_level[id];
					
					g_ammopacks[id] += iApsChance;
					CC(id, "!g[ZP]!y Bien, la cabeza del zombie tenía !g%d ammo packs!y", iApsChance);
				}
				else CC(id, "!g[ZP]!y La cabeza no tenía nada, mala suerte!");
			}
			else client_print(id, print_center, "No tenés cabezas rojas para romper");
		}
		case 1:
		{
			if(g_head_zombie[id][box_green])
			{
				g_head_zombie[id][box_green]--;
				
				if(iChance < 35)
				{
					new iXpChance = random_num(1, 150) * (g_level[id] + (g_range[id] * 560));
					
					update_xp(id, iXpChance, 0);
					CC(id, "!g[ZP]!y Bien, la cabeza del zombie tenía !g%d de experiencia!y", iXpChance);
				}
				else CC(id, "!g[ZP]!y La cabeza no tenía nada, mala suerte!");
			}
			else client_print(id, print_center, "No tenés cabezas verdes para romper");
		}
		case 2:
		{
			if(g_head_zombie[id][box_blue])
			{
				if(is_user_alive(id))
				{
					if(g_newround)
					{
						g_head_zombie[id][box_blue]--;
						
						if(iChance < 35)
						{
							new iItemExtra = random_num(1, 100);
							
							if(iItemExtra < 80)
							{
								new iItemExtraChance = random_num(1, 5);
								switch(iItemExtraChance)
								{
									case 1:
									{
										buy_extra_item(id, EXTRA_UNLIMITED_CLIP, 1)
										CC(id, "!g[ZP]!y La cabeza del zombie tenía !gbalas infinitas!y");
									}
									case 2:
									{
										buy_extra_item(id, EXTRA_LONGJUMP, 1)
										CC(id, "!g[ZP]!yLa cabeza del zombie tenía un !glong jump!y");
									}
									case 3:
									{
										set_user_armor(id, 200)
										CC(id, "!g[ZP]!y La cabeza del zombie tenía !g200 de chaleco!y");
									}
									case 4:
									{
										set_user_health(id, 1000)
										CC(id, "!g[ZP]!y La cabeza del zombie tenía !g1.000 de vida!y");
									}
									case 5:
									{
										if(user_has_weapon(id, CSW_SMOKEGRENADE))
										{
											cs_set_user_bpammo(id, CSW_SMOKEGRENADE, cs_get_user_bpammo(id, CSW_SMOKEGRENADE) + 1)
										}
										else
										{
											ham_strip_weapons(id, "weapon_smokegrenade")
											give_item(id, "weapon_smokegrenade");
										}
										
										CC(id, "!g[ZP]!y La cabeza del zombie tenía !g1 inmunidad!y");
									}
								}
							}
							else
							{
								CC(id, "!g[ZP]!y La cabeza del zombie tenía el !gVirus-T!y y te has infectado");
								
								remove_task(TASK_MAKEZOMBIE);
								make_a_zombie(MODE_INFECTION, id);
							}
						}
						else CC(id, "!g[ZP]!y La cabeza no tenía nada, mala suerte!");
					}
					else CC(id, "!g[ZP]!y Solo podes romper cabezas azules al principio de la ronda cuando no hay modo");
				}
				else CC(id, "!g[ZP]!y Tenés que estár vivo para romper cabezas azules, pueden tener item extras");
			}
			else client_print(id, print_center, "No tenés cabezas azules para romper");
		}
		case 3:
		{
			if(g_head_zombie[id][box_yellow])
			{
				g_head_zombie[id][box_yellow]--;
				
				if(iChance < 20)
				{
					new iYellowChance1 = random_num(1, 5);
					switch(iYellowChance1)
					{
						case 1:
						{
							if(g_level[id] < MAX_LVL)
							{
								g_level[id]++;
								g_exp[id] = (XPNeeded[g_level[id]-1] * MULT_PER_RANGE);
								
								CC(id, "!g[ZP]!y La cabeza del zombie tenía !gun nivel!y");
							}
							else CC(id, "!g[ZP]!y La cabeza del zombie tenía !gun nivel!y pero no lo pudiste obtener porque estás en el nivel máximo");
						}
						case 2:
						{
							g_money[id] += 5;
							CC(id, "!g[ZP]!y La cabeza del zombie tenía !g$5!y");
						}
						case 3:
						{
							g_points[id][HAB_HUMAN] += 4;
							CC(id, "!g[ZP]!y La cabeza del zombie tenía !g4p. humanos!y");
						}
						case 4:
						{
							g_money[id] += 10;
							CC(id, "!g[ZP]!y La cabeza del zombie tenía !g$10!y");
						}
						case 5:
						{
							g_points[id][HAB_ZOMBIE] += 4;
							CC(id, "!g[ZP]!y La cabeza del zombie tenía !g4p. zombie!y");
						}
					}
				}
				else CC(id, "!g[ZP]!y La cabeza no tenía nada, mala suerte!");
			}
			else client_print(id, print_center, "No tenés cabezas amarillas para romper");
		}
		case 4:
		{
			if(g_head_zombie[id][box_white])
			{
				if(is_user_alive(id))
				{
					if(g_newround)
					{
						g_head_zombie[id][box_white]--;
						
						if(iChance < 35)
						{
							new iFirstRandom = random_num(1, 20);
							if(iFirstRandom == 1)
							{
								new iSecondRandom = random_num(1, 10);
								if(iSecondRandom == 1)
								{
									new iThirdRandom = random_num(1, 5);
									if(iThirdRandom == 1)
									{
										new iFourRandom = random_num(1, 2);
										if(iFourRandom == 1)
										{
											new iFiveRandom = random_num(1, (MODE_TOTALS-1));
											if(iFiveRandom == MODE_ARMAGEDDON || MODE_DUEL)
											{
												remove_task(TASK_MAKEZOMBIE);
												make_a_zombie(MODE_MULTI, 0);
											}
											else if(iFiveRandom == MODE_SWARM || iFiveRandom == MODE_MULTI || iFiveRandom == MODE_PLAGUE || iFiveRandom == MODE_TRIBAL || iFiveRandom == MODE_ALVSPRED)
											{
												remove_task(TASK_MAKEZOMBIE);
												make_a_zombie(iFiveRandom, 0);
											}
											else
											{
												remove_task(TASK_MAKEZOMBIE);
												make_a_zombie(iFiveRandom, id);
											}
											
											CC(0, "!g[ZP]!y La cabeza blanca que abrió !g%s!y hizo comenzar el modo actual", g_playername[id]);
										}
										else CC(id, "!g[ZP]!y Aaah, casi conseguís un modo, llegaste hasta la !g3/4 parte!y");
									}
									else CC(id, "!g[ZP]!y Aaah, casi conseguís un modo, llegaste hasta la !g2/4 parte!y");
								}
								else CC(id, "!g[ZP]!y Aaah, casi conseguís un modo, llegaste hasta la !g1/4 parte!y");
							}
							else
							{
								if(iChance < 30)
								{
									new iApsChance = (random_num(1, 10) * g_level[id]) * 2;
								
									g_ammopacks[id] += iApsChance;
									CC(id, "!g[ZP]!y Bien, la cabeza del zombie tenía !g%d ammo packs!y", iApsChance);
								}
								
								if(iChance < 25)
								{
									new iXpChance = (random_num(1, 150) * (g_level[id] + (g_range[id] * 560))) * 2;
								
									update_xp(id, iXpChance, 0);
									CC(id, "!g[ZP]!y Bien, la cabeza del zombie tenía !g%d de experiencia!y", iXpChance);
								}
								
								if(iChance < 15)
								{
									new iWhiteChance = random_num(1, 5);
									switch(iWhiteChance)
									{
										case 1:
										{
											if(g_level[id] < MAX_LVL)
											{
												g_level[id]++;
												g_exp[id] = (XPNeeded[g_level[id]-1] * MULT_PER_RANGE);
												
												CC(id, "!g[ZP]!y La cabeza del zombie tenía !gun nivel!y");
											}
											else CC(id, "!g[ZP]!y La cabeza del zombie tenía !gun nivel!y pero no lo pudiste obtener porque estás en el nivel máximo");
										}
										case 2:
										{
											g_money[id] += 10;
											CC(id, "!g[ZP]!y La cabeza del zombie tenía !g$10!y");
										}
										case 3:
										{
											g_points[id][HAB_HUMAN] += 8;
											CC(id, "!g[ZP]!y La cabeza del zombie tenía !g8p. humanos!y");
										}
										case 4:
										{
											g_money[id] += 15;
											CC(id, "!g[ZP]!y La cabeza del zombie tenía !g$15!y");
										}
										case 5:
										{
											g_points[id][HAB_ZOMBIE] += 8;
											CC(id, "!g[ZP]!y La cabeza del zombie tenía !g8p. zombie!y");
										}
									}
								}
							}
						}
						else CC(id, "!g[ZP]!y Al parecer, la cabeza estaba poseida por un demonio del 5to subsuelo, buena suerte (?)");
					}
					else CC(id, "!g[ZP]!y Solo podes romper cabezas blancas al principio de la ronda cuando no hay modo");
				}
				else CC(id, "!g[ZP]!y Solo podes romper cabezas blancas cuando estás vivo");
			}
			else client_print(id, print_center, "No tenés cabezas blancas para romper");
		}
		
		case 9:
		{
			show_menu_headz(id);
			return PLUGIN_HANDLED;
		}
	}
	
	show_menu_head_zombies(id);
	return PLUGIN_HANDLED;
}

/*check_error(id, function_name[], failstate, errorcode, error[])
{
	new flag = 1;
	
	if(failstate == TQUERY_CONNECT_FAILED)
	{
		log_to_file("zr_sql.log", "ERROR en la funcion: %s   RAZON: No se pudo conectar a la base de datos", function_name);
		flag = 0;
	}
	else if (failstate == TQUERY_QUERY_FAILED)
	{
		log_to_file("zr_sql.log", "ERROR en la funcion: %s   RAZON: Fallo la consulta", function_name);
		flag = 0;
	}
	else if(errorcode)
	{
		log_to_file("zr_sql.log", "ERROR en la funcion: %s   SQL Error #%d   RAZON: %s", function_name, errorcode, error);
		flag = 0;
	}

	if(!flag)
	{
		if(is_user_valid_connected(id))
			server_cmd("kick #%d ^"ERROR_SQL: Intente mas tarde^"", get_user_userid(id));
	}
	
	return flag;
}*/
public fn_set_hat(id, const model_hat[])
{
	if(!is_user_connected(id))
		return;
	
	if(is_valid_ent(g_hat_ent[id]))
		remove_entity(g_hat_ent[id])
	
	if(equal(model_hat, "ninguno"))
	{
		remove_task(id + TASK_CONVERT_ZOMBIE);
		return;
	}
	
	new ent = g_hat_ent[id];
	if(!is_valid_ent(g_hat_ent[id]))
	{
		g_hat_ent[id] = ent = create_entity("info_target");
		
		entity_set_string(ent, EV_SZ_classname, "tcs_hat")
		entity_set_int(ent, EV_INT_movetype, MOVETYPE_FOLLOW);
		entity_set_edict(ent, EV_ENT_aiment, id);
		entity_set_edict(ent, EV_ENT_owner, id);
		
		if(equal(model_hat, "psycho"))
		{
			remove_task(id + TASK_CONVERT_ZOMBIE);
			set_task(60.0, "fnCheckConvertZombie", id + TASK_CONVERT_ZOMBIE, _, _, "b");
		}
		
		new buffer[64];
		formatex(buffer, charsmax(buffer), "models/zp_tcs/hats/%s.mdl", model_hat)
		entity_set_model(ent, buffer);
	}
}
public fn_give_hat(id, hat)
{
	if(!is_user_connected(id))
		return;
	
	if(g_hat[id][hat])
		return;
	
	//log_to_file("zp_hats.log", "ID: %d - NOMBRE: %s - GORRO: %s (h%d%s)", g_zr_pj[id], g_playername[id], g_hat_name[hat], hat+1, (hat==HAT_NAVID1) ? " - hat_navid" : "");
	
	g_hat[id][hat] = 1;
	
	new sQuery[32];
	if(hat != HAT_NAVID1)
		formatex(sQuery, charsmax(sQuery), "`h%d` = '1'", hat+1);
	else
		formatex(sQuery, charsmax(sQuery), "`hat_navid` = '1'");
	
	// SQL - 5
	new Handle:sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE events SET %s WHERE `zp_id`='%d';", sQuery, g_zr_pj[id]);
	if(!SQL_Execute(sql_consult))
	{
		new sql_error[512];
		SQL_QueryError(sql_consult, sql_error, 511);
		
		log_to_file("zr_sql.log", "- LOG:57 - %s", sql_error);
		if(is_user_valid_connected(id))
			server_cmd("kick #%d ^"Hubo un error al guardar un HAT tuyo. Intente mas tarde^"", get_user_userid(id))
	}
	SQL_FreeHandle(sql_consult)
	
	if(fn_hats_count(id) == 10)
		fn_update_logro(id, LOGRO_OTHERS, SOY_RE_CABEZA);
	
	if(hat != HAT_SMILEY)
		CC(0, "!g[ZP] %s!y ha conseguido el gorro: !g%s!y", g_playername[id], g_hat_name[hat])
	else if(!g_l_wa_times)
	{
		g_l_wa_times = 1;
		set_task(2.0, "fn_finish_watimes");
		
		CC(0, "!g[ZP]!y Varios jugadores han conseguido el gorro: !gSmiley!y")
	}
}
public fnCheckConvertZombie(taskid)
{
	if(!hub(ID_CONVERT_ZOMBIE, g_data[BIT_ALIVE]))
	{
		remove_task(taskid);
		return;
	}
	
	if(g_hat_equip[ID_CONVERT_ZOMBIE] != HAT_PSYCHO)
	{
		remove_task(taskid);
		return;
	}

	if(g_zombie[ID_CONVERT_ZOMBIE] || g_lasthuman[ID_CONVERT_ZOMBIE] || g_survround || g_nemround || g_swarmround || g_duel_final || g_plagueround || g_armageddon_round || g_wesker_round || g_sniper_round ||g_tribal_round || g_annihilation_round ||
	g_alvspre_round || g_fp_round)
	{
		remove_task(taskid);
		return;
	}

	if(random_num(1, 10) == 5 || random_num(1, 10) == 7)
	{
		g_convert_zombie[ID_CONVERT_ZOMBIE] = 1;
		
		client_print(ID_CONVERT_ZOMBIE, print_center, "TE ESTAS CONVIRTIENDO EN ZOMBIE");
		
		emit_sound(ID_CONVERT_ZOMBIE, CHAN_VOICE, g_sSoundZombieMadness[random_num(0, charsmax(g_sSoundZombieMadness))], 1.0, ATTN_NORM, 0, PITCH_HIGH)
		
		message_begin(MSG_ONE_UNRELIABLE, g_msgScreenFade, _, ID_CONVERT_ZOMBIE)
		write_short(UNIT_SECOND*2) // duration
		write_short(UNIT_SECOND*2) // hold time
		write_short(FFADE_IN) // fade type
		write_byte(0) // r
		write_byte(255) // g
		write_byte(0) // b
		write_byte(180) // alpha
		message_end()
		
		message_begin(MSG_ONE_UNRELIABLE, g_msgScreenShake, _, ID_CONVERT_ZOMBIE)
		write_short(UNIT_SECOND*7) // amplitude
		write_short(UNIT_SECOND*3) // duration
		write_short(UNIT_SECOND*7) // frequency
		message_end()
		
		set_task(3.0, "fnAmountSFSS", ID_CONVERT_ZOMBIE);
		set_task(6.0, "fnConvertZombie", ID_CONVERT_ZOMBIE);
	}
}
public fnAmountSFSS(id)
{
	if(!is_user_alive(id))
		return;
	
	new origin[3]
	get_user_origin(id, origin)
	
	message_begin(MSG_PVS, SVC_TEMPENTITY, origin)
	write_byte(TE_DLIGHT) // TE id
	write_coord(origin[0]) // x
	write_coord(origin[1]) // y
	write_coord(origin[2]) // z
	write_byte(17) // radius
	write_byte(0) // r
	write_byte(255) // g
	write_byte(0) // b
	write_byte(2) // life
	write_byte(0) // decay rate
	message_end()
	
	message_begin(MSG_ONE_UNRELIABLE, g_msgScreenFade, _, id)
	write_short(UNIT_SECOND*2) // duration
	write_short(UNIT_SECOND*2) // hold time
	write_short(FFADE_IN) // fade type
	write_byte(0) // r
	write_byte(255) // g
	write_byte(0) // b
	write_byte(235) // alpha
	message_end()
	
	message_begin(MSG_ONE_UNRELIABLE, g_msgScreenShake, _, id)
	write_short(UNIT_SECOND*14) // amplitude
	write_short(UNIT_SECOND*5) // duration
	write_short(UNIT_SECOND*14) // frequency
	message_end()
	
	set_user_rendering(id, kRenderFxGlowShell, 0, 255, 0, kRenderNormal, 25)
}
public fnConvertZombie(id)
{
	if(!is_user_alive(id))
		return;
	
	g_convert_zombie[id] = 0;
	zombieme(id, 0, 0, 0, 0, 0, 0, 0)
}
fn_set_points(id, mode, const text[])
{
	if(!is_user_connected(id))
		return;
	
	if(mode)
	{
		g_points[id][HAB_ZOMBIE] += g_mult_point[id]
		CC(0, "!g[ZP] %s!y ganó !g%d punto%s zombie!y por matar a un !g%s!y", g_playername[id], g_mult_point[id], (g_mult_point[id] == 1) ? "" : "s", text)
	}
	else
	{
		g_points[id][HAB_HUMAN] += g_mult_point[id]
		CC(0, "!g[ZP] %s!y ganó !g%d punto%s humano%s!y por matar a un !g%s!y", g_playername[id], g_mult_point[id], (g_mult_point[id] == 1) ? "" : "s",
		(g_mult_point[id] == 1) ? "" : "s", text)
	}
}

public show_menu_ringsnecks(id, mode)
{
	if(!is_user_connected(id))
		return;
	
	RINGS_NECKS = mode
	
	static menuid, item, buff_complete[50], buffer[32], pos[2];
	
	// Title
	if(RINGS_NECKS == 1) menuid = menu_create("\yCOLLARES", "menu_ringsnecks")
	else if(RINGS_NECKS == 2) menuid = menu_create("\yARTEFACTOS", "menu_ringsnecks")
	else menuid = menu_create("\yANILLOS", "menu_ringsnecks")
	
	for(item = 0; item < 3; item++)
	{
		formatex(buffer, charsmax(buffer), "%s", g_ringsnecks_names_pp[RINGS_NECKS][item])
		
		if(RINGS_NECKS == 2)
			formatex(buff_complete, charsmax(buff_complete), "%s%s", buffer, (g_artefactos_equipados[id][item]) ? " \y(EQUIPADO)" : "")
		else
			formatex(buff_complete, charsmax(buff_complete), "%s%s", buffer, (g_rn_equip[id][RINGS_NECKS][item]) ? " \y(EQUIPADO)" : "")
		
		num_to_str(item, pos, 1)
		menu_additem(menuid, buff_complete, pos)
	}
	
	if(RINGS_NECKS == 2)
	{
		formatex(buff_complete, charsmax(buff_complete), "Herradura de la Buena Suerte%s", (g_artefactos_equipados[id][item]) ? " \y(EQUIPADO)" : "")
		menu_additem(menuid, buff_complete, "4")
	}
	
	// Exit
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid)
}
public menu_ringsnecks(id, menuid, item)
{
	// Player disconnected?
	if (!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_equip(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve extra item id
	static buffer[2], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	RN = str_to_num(buffer)
	sub_menu_ringsnecks(id)
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}
public sub_menu_ringsnecks(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[256], lang[200], info[32], menuid, total, current[13], next_current[10], money, money_buff[15], cost, buff_eff[64];
	
	if(RINGS_NECKS == 1)
	{
		formatex(current, 12, "%s", (g_rn[id][NECK][RN] == 0) ? "" : (g_rn[id][NECK][RN] == 1) ? "\y(Grado C)" : (g_rn[id][NECK][RN] == 2) ? "\y(Grado B)" : (g_rn[id][NECK][RN] == 3) ? "\y(Grado A)" : "\y(Grado S)")
		formatex(next_current, 9, "%s", (g_rn[id][NECK][RN] == 0) ? "Grado C" : (g_rn[id][NECK][RN] == 1) ? "Grado B" : (g_rn[id][NECK][RN] == 2) ? "Grado A" : (g_rn[id][NECK][RN] == 3) ? "Grado S" : "Grado S")
		
		switch(g_rn[id][NECK][RN])
		{
			case 0: cost = 100
			case 1: cost = 250
			case 2: cost = 400
			case 3: cost = 750
			case 4: cost = -1
		}
		
		if(g_rn[id][NECK][RN] && RN != 2)
			cost = -1
		
		money = g_money[id]
		add_dot(money, money_buff, 14)
		total = money - cost
		
		if (total < 0) formatex(info, charsmax(info), "\d(\r$%d\d)", cost)
		else formatex(info, charsmax(info), "\y($%d)", cost)
		
		// Title
		if(RN == 2) formatex(menu, charsmax(menu), "%s %s^n\wPlata: \y$%s", g_ringsnecks_names[RINGS_NECKS][RN], current, money_buff)
		else formatex(menu, charsmax(menu), "%s^n\wPlata: \y$%s", g_ringsnecks_names[RINGS_NECKS][RN], money_buff)
		
		menuid = menu_create(menu, "menu_sub_neck")
		
		if(cost != -1)
		{
			if(RN == 2) formatex(menu, charsmax(menu), "Comprar %s \y%s %s", g_ringsnecks_names[RINGS_NECKS][RN], next_current, info)
			else formatex(menu, charsmax(menu), "Comprar %s %s", g_ringsnecks_names[RINGS_NECKS][RN], info)
		}
		else formatex(menu, charsmax(menu), "\wEl \y%s \westá en su máximo poder!", g_ringsnecks_names[RINGS_NECKS][RN])
		
		menu_additem(menuid, menu, "1", ADMIN_ALL, menu_makecallback("detect_menu_neck"))
		
		formatex(menu, charsmax(menu), "%s", (g_rn_equip[id][RINGS_NECKS][RN]) ? "Desequipar" : "Equipar")
		menu_additem(menuid, menu, "2", ADMIN_ALL, menu_makecallback("detect_menu_neck_eq"))
		
		formatex(menu, charsmax(menu), "^n%s", (g_rn_equip[id][RINGS_NECKS][RN]) ? "\yEQUIPADO" : "\rNO EQUIPADO")
		menu_addtext(menuid, menu)
		
		switch(RN)
		{
			case 0: formatex(buff_eff, charsmax(buff_eff), "El fuego que te afecta solo te reduce velocidad")
			case 1: formatex(buff_eff, charsmax(buff_eff), "El hielo que te afecta solo se puede acumular 1 vez")
			case 2: formatex(buff_eff, charsmax(buff_eff), "El daño recibido siendo zombie se reduce un %s%%",
			(g_rn[id][RINGS_NECKS][2] == 0) ? "0" : (g_rn[id][RINGS_NECKS][2] == 1) ? "5" : (g_rn[id][RINGS_NECKS][2] == 2) ? "10" : (g_rn[id][RINGS_NECKS][2] == 3) ? "15" : "20")
		}
		
		formatex(lang, charsmax(lang), "^n\yAL EQUIPAR EL COLLAR:^n\r- \w%s", buff_eff)
		menu_addtext(menuid, lang)
		
		menu_addtext(menuid, "^n\rNOTA: \wSolo podes tener un collar equipado")
	}
	else if(RINGS_NECKS == 2)
	{
		if(RN == 4)
			RN = 3;
			
		// Title
		if(RN == 3) formatex(menu, charsmax(menu), "Herradura de la Buena Suerte")
		else formatex(menu, charsmax(menu), "%s", g_ringsnecks_names[RINGS_NECKS][RN])
		
		menuid = menu_create(menu, "menu_sub_others")
		
		formatex(menu, charsmax(menu), "%s", (g_artefactos_equipados[id][RN]) ? "Desequipar" : "Equipar")
		menu_additem(menuid, menu, "1")
		
		formatex(menu, charsmax(menu), "^n%s", (g_artefactos_equipados[id][RN]) ? "\yEQUIPADO" : "\rNO EQUIPADO")
		menu_addtext(menuid, menu)
		
		switch(RN)
		{
			case 0: formatex(lang, charsmax(lang), "\wPara equipar este artefacto debe haber hecho o hacer^nuna compra de $100 (REALES) o superior")
			case 1: formatex(lang, charsmax(lang), "\wPara equipar este artefacto debe haber hecho o hacer^nuna compra de $150 (REALES) o superior")
			case 2: formatex(lang, charsmax(lang), "\wPara equipar este artefacto debe haber hecho o hacer^nuna compra de $200 (REALES) o superior")
			case 3: formatex(lang, charsmax(lang), "\wPara equipar este artefacto debe haber hecho o hacer^nuna compra de $100 (REALES) o superior^n^n\yEste artefacto da un 20%% de que^nhaga modo especial al que lo posee")
		}
		
		menu_addtext(menuid, lang)
	}
	else
	{
		formatex(current, 12, "%s", (g_rn[id][RING][RN] == 0) ? "" : (g_rn[id][RING][RN] == 1) ? "\y(Grado C)" : (g_rn[id][RING][RN] == 2) ? "\y(Grado B)" : (g_rn[id][RING][RN] == 3) ? "\y(Grado A)" : "\y(Grado S)")
		formatex(next_current, 9, "%s", (g_rn[id][RING][RN] == 0) ? "Grado C" : (g_rn[id][RING][RN] == 1) ? "Grado B" : (g_rn[id][RING][RN] == 2) ? "Grado A" : (g_rn[id][RING][RN] == 3) ? "Grado S" : "Grado S")
		switch(g_rn[id][RING][RN])
		{
			case 0: cost = 100
			case 1: cost = 250
			case 2: cost = 400
			case 3: cost = 750
			case 4: cost = -1
		}
		
		money = g_money[id]
		add_dot(money, money_buff, 14)
		total = money - cost
		
		if (total < 0) formatex(info, charsmax(info), "\d(\r$%d\d)", cost)
		else formatex(info, charsmax(info), "\y($%d)", cost)
		
		// Title
		formatex(menu, charsmax(menu), "%s %s^n\wPlata: \y$%s", g_ringsnecks_names[RINGS_NECKS][RN], current, money_buff)
		
		menuid = menu_create(menu, "menu_sub_ring")
		
		if(cost != -1) formatex(menu, charsmax(menu), "Comprar %s \y%s %s", g_ringsnecks_names[RINGS_NECKS][RN], next_current, info)
		else formatex(menu, charsmax(menu), "\wEl \y%s \westá en su máximo poder!", g_ringsnecks_names[RINGS_NECKS][RN])
		
		menu_additem(menuid, menu, "1", ADMIN_ALL, menu_makecallback("detect_menu_ring"))
		
		formatex(menu, charsmax(menu), "%s", (g_rn_equip[id][RINGS_NECKS][RN]) ? "Desequipar" : "Equipar")
		menu_additem(menuid, menu, "2", ADMIN_ALL, menu_makecallback("detect_menu_ring_eq"))
		
		formatex(menu, charsmax(menu), "^n%s", (g_rn_equip[id][RINGS_NECKS][RN]) ? "\yEQUIPADO" : "\rNO EQUIPADO")
		menu_addtext(menuid, menu)
		
		switch(RN)
		{
			case 0: formatex(buff_eff, charsmax(buff_eff), "Reduce un %s%% el costo de los items extras",
			(g_rn[id][RINGS_NECKS][0] == 0) ? "0" : (g_rn[id][RINGS_NECKS][0] == 1) ? "10" : (g_rn[id][RINGS_NECKS][0] == 2) ? "20" : (g_rn[id][RINGS_NECKS][0] == 3) ? "30" : "40")
			case 1: formatex(buff_eff, charsmax(buff_eff), "Tu multiplicador de experiencia sube un x%s",
			(g_rn[id][RINGS_NECKS][1] == 0) ? "0" : (g_rn[id][RINGS_NECKS][1] == 1) ? "0.5" : (g_rn[id][RINGS_NECKS][1] == 2) ? "1" : (g_rn[id][RINGS_NECKS][1] == 3) ? "1.5" : "2")
			case 2: formatex(buff_eff, charsmax(buff_eff), "Tu multiplicador de ammo packs sube un x%s",
			(g_rn[id][RINGS_NECKS][2] == 0) ? "0" : (g_rn[id][RINGS_NECKS][2] == 1) ? "0.5" : (g_rn[id][RINGS_NECKS][2] == 2) ? "1" : (g_rn[id][RINGS_NECKS][2] == 3) ? "1.5" : "2")
		}
		
		formatex(lang, charsmax(lang), "^n\yAL EQUIPAR EL ANILLO:^n\r- \w%s", buff_eff)
		menu_addtext(menuid, lang)
		
		menu_addtext(menuid, "^n\rNOTA: \wSolo podes tener hasta dos anillos equipados^nal mismo tiempo")
	}
	
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid)
}
public detect_menu_neck(id, menuid, item)
{
	new cost
	switch(g_rn[id][NECK][RN])
	{
		case 0: cost = 100
		case 1: cost = 250
		case 2: cost = 400
		case 3: cost = 750
		case 4: cost = -1
	}
	
	if(g_rn[id][NECK][RN] && RN != 2)
		cost = -1
	
	if(g_money[id] >= cost)
	{
		if(cost != -1)
			return ITEM_ENABLED;
	}
	
	return ITEM_DISABLED;
}
public detect_menu_ring(id, menuid, item)
{
	new cost
	switch(g_rn[id][RING][RN])
	{
		case 0: cost = 100
		case 1: cost = 250
		case 2: cost = 400
		case 3: cost = 750
		case 4: cost = -1
	}
	
	if(g_money[id] >= cost)
	{
		if(cost != -1)
			return ITEM_ENABLED;
	}
	
	return ITEM_DISABLED;
}
public detect_menu_neck_eq(id, menuid, item)
{
	if(g_rn[id][NECK][RN])
		return ITEM_ENABLED;
	
	return ITEM_DISABLED;
}
public detect_menu_ring_eq(id, menuid, item)
{
	if(g_rn[id][RING][RN])
		return ITEM_ENABLED;
	
	return ITEM_DISABLED;
}
public menu_sub_ring(id, menuid, item)
{
	// Menu was closed
	if (!is_user_connected(id) || item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_ringsnecks(id, RINGS_NECKS)
		return PLUGIN_HANDLED;
	}
	
	static buffer[3], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch(str_to_num(buffer))
	{
		case 1:
		{
			new cost
			new current[10]
			switch(g_rn[id][RING][RN])
			{
				case 0: cost = 100
				case 1: cost = 250
				case 2: cost = 400
				case 3: cost = 750
				case 4: cost = -1
			}
			
			g_money[id] -= cost
			g_money_lose[id] += cost
			g_rn[id][RING][RN]++
			
			formatex(current, 9, "%s", (g_rn[id][RING][RN] == 1) ? "Grado C" : (g_rn[id][RING][RN] == 2) ? "Grado B" : (g_rn[id][RING][RN] == 3) ? "Grado A" : "Grado S")
			
			CC(0, "!g[ZP] %s!y compro el !g%s [%s]!y por !g$%d!y", g_playername[id], g_ringsnecks_names[RINGS_NECKS][RN], current, cost)
			
			fn_update_logro(id, LOGRO_OTHERS, ALHAJA);
			
			if(g_rn[id][RING][0] == 4 && g_rn[id][RING][1] == 4 && g_rn[id][RING][2] == 4)
				fn_update_logro(id, LOGRO_OTHERS, ANILLOS);
			
			if(g_hat[id][HAT_TYNO])
			{
				new iCount = 1;
				new i;
				
				for(i = 0; i < MAX_HABILITIES[HAB_HUMAN]; i++)
				{
					if(POINT_ITEM != i)
					{
						if((g_hab[id][HAB_HUMAN][i] + MAX_EFFECTS_HATS_HABS[g_hat_equip[id]+1][HAB_HUMAN][i]) == 
						(MAX_HAB_LEVEL[HAB_HUMAN][i] + MAX_EFFECTS_HATS_HABS[g_hat_equip[id]+1][HAB_HUMAN][i]))
							iCount++;
					}
				}
				
				if(iCount == MAX_HABILITIES[HAB_HUMAN] && (g_rn[id][RING][0] == 4 || g_rn[id][RING][1] == 4 || g_rn[id][RING][2] == 4))
					fn_give_hat(id, HAT_ZIPPY)
			}
		}
		case 2:
		{
			new count = 0;
			
			if(g_rn_equip[id][RING][0]) count++
			if(g_rn_equip[id][RING][1]) count++
			if(g_rn_equip[id][RING][2]) count++
			
			if(count >= 2 && !g_rn_equip[id][RING][RN])
			{
				menu_destroy(menuid)
				sub_menu_ringsnecks(id)
				return PLUGIN_HANDLED;
			}
			
			g_rn_equip[id][RING][RN] = !g_rn_equip[id][RING][RN];
			CC(id, "!g[ZP]!y Has %sequipado el !g%s!y", (g_rn_equip[id][RING][RN]) ? "" : "des", g_ringsnecks_names[RINGS_NECKS][RN])
		}
	}
	
	menu_destroy(menuid)
	sub_menu_ringsnecks(id)
	return PLUGIN_HANDLED;
}
public menu_sub_neck(id, menuid, item)
{
	// Menu was closed
	if (!is_user_connected(id) || item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_ringsnecks(id, RINGS_NECKS)
		return PLUGIN_HANDLED;
	}
	
	static buffer[3], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch(str_to_num(buffer))
	{
		case 1:
		{
			new cost
			new current[10]
			switch(g_rn[id][NECK][RN])
			{
				case 0: cost = 100
				case 1: cost = 250
				case 2: cost = 400
				case 3: cost = 750
				case 4: cost = -1
			}
			
			g_money[id] -= cost
			g_money_lose[id] += cost
			g_rn[id][NECK][RN]++
			
			formatex(current, 9, "%s", (g_rn[id][NECK][RN] == 1) ? "Grado C" : (g_rn[id][NECK][RN] == 2) ? "Grado B" : (g_rn[id][NECK][RN] == 3) ? "Grado A" : "Grado S")
			
			if(RN == 2) CC(0, "!g[ZP] %s!y compro el !g%s [%s]!y por !g$%d!y", g_playername[id], g_ringsnecks_names[RINGS_NECKS][RN], current, cost)
			else CC(0, "!g[ZP] %s!y compro el !g%s!y por !g$%d!y", g_playername[id], g_ringsnecks_names[RINGS_NECKS][RN], cost)
			
			fn_update_logro(id, LOGRO_OTHERS, ALHAJA);
			
			if(g_rn[id][NECK][0] == 1 && g_rn[id][NECK][1] == 1 && g_rn[id][NECK][2] == 4)
				fn_update_logro(id, LOGRO_OTHERS, COLLARES);
		}
		case 2:
		{
			new count = 0;
			
			if(g_rn_equip[id][NECK][0]) count++
			if(g_rn_equip[id][NECK][1]) count++
			if(g_rn_equip[id][NECK][2]) count++
			
			if(count >= 1 && !g_rn_equip[id][NECK][RN])
			{
				menu_destroy(menuid)
				sub_menu_ringsnecks(id)
				return PLUGIN_HANDLED;
			}
			
			g_rn_equip[id][NECK][RN] = !g_rn_equip[id][NECK][RN];
			CC(id, "!g[ZP]!y Has %sequipado el !g%s!y", (g_rn_equip[id][NECK][RN]) ? "" : "des", g_ringsnecks_names[RINGS_NECKS][RN])
		}
	}
	
	menu_destroy(menuid)
	sub_menu_ringsnecks(id)
	return PLUGIN_HANDLED;
}
public menu_sub_others(id, menuid, item)
{
	// Menu was closed
	if (!is_user_connected(id) || item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_ringsnecks(id, RINGS_NECKS)
		return PLUGIN_HANDLED;
	}
	
	static buffer[3], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch(str_to_num(buffer))
	{
		case 1:
		{
			new nopodes = 0;
			new costooo = 0;
			
			switch(RN)
			{
				case 0: if((g_plata_gastada[id] - 100) < 0 && !g_artefactos_equipados[id][RN]) nopodes = 100
				case 1: if((g_plata_gastada[id] - 150) < 0 && !g_artefactos_equipados[id][RN]) nopodes = 150
				case 2: if((g_plata_gastada[id] - 200) < 0 && !g_artefactos_equipados[id][RN]) nopodes = 200
				case 3: if((g_plata_gastada[id] - 100) < 0 && !g_artefactos_equipados[id][RN]) nopodes = 100
			}
			
			if(nopodes > 0)
			{
				menu_destroy(menuid)
				sub_menu_ringsnecks(id)
				return PLUGIN_HANDLED;
			}
			
			switch(RN)
			{
				case 0: costooo = 100
				case 1: costooo = 150
				case 2: costooo = 200
				case 3: costooo = 100
			}
			
			g_artefactos_equipados[id][RN] = !g_artefactos_equipados[id][RN];
			if(RN == 3) CC(id, "!g[ZP]!y Has %sactivado la !gHerradura de la Buena Suerte!y", (g_artefactos_equipados[id][RN]) ? "" : "des")
			else CC(id, "!g[ZP]!y Has %sactivado el !g%s!y", (g_artefactos_equipados[id][RN]) ? "" : "des", g_ringsnecks_names[RINGS_NECKS][RN])
			
			if(g_artefactos_equipados[id][RN])
				g_plata_gastada[id] -= costooo
			else
				g_plata_gastada[id] += costooo
		}
	}
	
	menu_destroy(menuid)
	sub_menu_ringsnecks(id)
	return PLUGIN_HANDLED;
}

public show_menu_hats(id)
{
	if(!is_user_connected(id))
		return;
	
	static menuid, item, buffer[32], pos[3];
	menuid = menu_create("\yGorros, sombreros y cabezas", "menu_Sub_Hats");
	
	for(item = 0; item < MAX_HATS+1; item++)
	{
		if(item != MAX_HATS && !g_hat[id][item]) formatex(buffer, charsmax(buffer), "\d%s", g_hat_name[item])
		else if(item == g_hat_equip[id]) formatex(buffer, charsmax(buffer), "\d%s \y(EQUIPADO)", g_hat_name[item])
		else formatex(buffer, charsmax(buffer), "%s", g_hat_name[item])
		
		num_to_str(item+1, pos, 2)
		menu_additem(menuid, buffer, pos)
	}
	
	// Back - Next - Exit
	menu_setprop(menuid, MPROP_BACKNAME, "Atrás")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// If remembered page is greater than number of pages, clamp down the value
	MENU_PAGE_HATS = min(MENU_PAGE_HATS, menu_pages(menuid)-1)
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid, MENU_PAGE_HATS)
}
public menu_Sub_Hats(id, menuid, item)
{
	// Player disconnected?
	if (!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Remember player's menu page
	static menudummy
	player_menu_info(id, menudummy, menudummy, MENU_PAGE_HATS)
	
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_equip(id)
		return PLUGIN_HANDLED;
	}
	
	static buffer[3], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	HAT_ITEM = str_to_num(buffer) - 1
	
	if(HAT_ITEM == MAX_HATS)
	{
		if(g_hat_equip[id] != -1)
		{
			fn_set_hat(id, g_hat_mdl[HAT_ITEM])
			HAT_ITEM = -1;
			HAT_ITEM_SET = -1;
			g_hat_equip[id] = -1;
			
			CC(id, "!g[ZP]!y Ahora no tenes ningún gorro puesto")
		}
		
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	show_menu_choose_hats(id)
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}

public show_menu_choose_hats(id)
{
	// Player disconnected?
	if (!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	static menuid, buffer[256], menu[64], i;
	
	formatex(menu, charsmax(menu), "\y%s^n%s", g_hat_name[HAT_ITEM], (g_hat[HAT_ITEM] && HAT_ITEM == g_hat_equip[id]) ? "\wDISPONIBLE - EQUIPADO" :
	(g_hat[HAT_ITEM]) ? "\wDISPONIBLE" : "\rNO DISPONIBLE")
	menuid = menu_create(menu, "menu_Sub_Hats2");
	
	menu_additem(menuid, "Equipar", "1", ADMIN_ALL, menu_makecallback("detect_menu_hat_equip"))
	
	formatex(buffer, charsmax(buffer), "^n\yBeneficios del GORRO \w%s", g_hat_name[HAT_ITEM])
	menu_addtext(menuid, buffer)
	
	for(i = 0; i < 3; i++)
	{
		if(MAX_EFFECTS_HATS[HAT_ITEM][i][0])
		{
			formatex(buffer, charsmax(buffer), "\r - \w%s", MAX_EFFECTS_HATS[HAT_ITEM][i])
			menu_addtext(menuid, buffer)
		}
	}
	
	if(HAT_ITEM != HAT_SCREAM) formatex(buffer, charsmax(buffer), "^n\yREQUIERE:^n\r - \w%s", REQ_HATS[HAT_ITEM])
	else
	{
		static numb[15];
		add_dot(g_dmg_glock[id], numb, 14);
		formatex(buffer, charsmax(buffer), "^n\yREQUIERE:^n\r - \w%s^n\r - \wDaño hecho con Glock 18C: \y%s", REQ_HATS[HAT_ITEM], numb)
	}
	menu_addtext(menuid, buffer)
	
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid)
	return PLUGIN_HANDLED;
}
public detect_menu_hat_equip(id, menuid, item)
{
	if(g_hat[id][HAT_ITEM] && g_hat_equip[id] != HAT_ITEM)
		return ITEM_ENABLED;
	
	return ITEM_DISABLED;
}
public menu_Sub_Hats2(id, menuid, item)
{
	// Player disconnected?
	if (!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_hats(id)
		return PLUGIN_HANDLED;
	}
	
	static buffer[3], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	if(str_to_num(buffer) == 1)
	{
		if(g_hat[id][HAT_ITEM])
		{
			if(g_newround || g_endround)
			{
				fn_set_hat(id, g_hat_mdl[HAT_ITEM])
				g_hat_equip[id] = HAT_ITEM;
				HAT_ITEM_SET = HAT_ITEM;
				
				if(g_newround)
				{
					set_user_health(id, amount_upgrade(id, HAB_HUMAN, HUMAN_HP, ArrayGetCell(g_hclass_hp, g_humanclass[id]), 0))
					
					set_user_gravity(id, amount_upgrade_f(id, HAB_HUMAN, HUMAN_GRAVITY, Float:ArrayGetCell(g_hclass_grav, g_humanclass[id]), 0, 0))
					g_human_spd[id] = amount_upgrade_f(id, HAB_HUMAN, HUMAN_SPEED, float(ArrayGetCell(g_hclass_spd, g_humanclass[id])), 0, 0)
					g_human_dmg[id] = amount_upgrade_f(id, HAB_HUMAN, HUMAN_DAMAGE, Float:ArrayGetCell(g_hclass_dmg, g_humanclass[id]), 0, 0)
					set_user_armor(id, amount_upgrade(id, HAB_HUMAN, HUMAN_ARMOR, 0, 0))
					
					ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
				}
				
				CC(id, "!g[ZP]!y Ahora tenes el gorro !g%s!y", g_hat_name[HAT_ITEM])
			}
			else
			{
				HAT_ITEM_SET = HAT_ITEM;
				CC(id, "!g[ZP]!y Cuando vuelvas a renacer tendrás el gorro !g%s!y", g_hat_name[HAT_ITEM])
			}
		}
	}
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}
public fn_EffectPipeSound(ent)
{
	if(!is_valid_ent(ent))
	{
		remove_task(ent);
		return;
	}
	
	emit_sound(ent, CHAN_WEAPON, g_sound_pipebeep, VOL_NORM, ATTN_NORM, 0, PITCH_HIGH);
}
public fn_ShowInfoMode()
{
	if(!g_sniper_round)
		remove_task(TASK_SNIPER_ROUND)
	
	set_hudmessage(0, 255, 0, 0.8, 0.15, 0, 0.0, 5.0, 1.0, 1.0, -1)
	ShowSyncHudMsg(0, g_MsgSync3, "Zombies restantes: %d", abs(g_zombies_left))
}
public fnDeactivateAchievement()
	gl_time_nem = 0;
// functions_f

/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ HABILIDADES ]
=======================================================================================*/
show_menu_hab(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[256], lang[32], num[8], i, menuid, percent, lvl, maxlevel
	
	formatex(menu, charsmax(menu), "\y%s^n\wPuntos %s: \y%d\R\r", LANG_HAB[POINT_CLASS], LANG_HAB_M[POINT_CLASS], g_points[id][POINT_CLASS])
	menuid = menu_create(menu, "menu_hab")
	
	for(i = 0; i < MAX_HABILITIES[POINT_CLASS]; i++)
	{
		ArrayGetString(A_HAB_NAMES[POINT_CLASS], i, lang, charsmax(lang))
		
		percent = get_percent_upgrade(id, POINT_CLASS, i)
		
		lvl = g_hab[id][POINT_CLASS][i] + MAX_EFFECTS_HATS_HABS[g_hat_equip[id]+1][POINT_CLASS][i]
		maxlevel = ArrayGetCell(A_HAB_MAX_LEVEL[POINT_CLASS], i) + MAX_EFFECTS_HATS_HABS[g_hat_equip[id]+1][POINT_CLASS][i]
		
		if (percent)
			formatex(menu, charsmax(menu), "%s \y(%d de %d)(+%d%%)%s", lang, lvl, maxlevel, percent, (i == MAX_HABILITIES[POINT_CLASS]-1) ? "^n" : "")
		else
			formatex(menu, charsmax(menu), "%s \y(%d de %d)%s", lang, lvl, maxlevel, (i == MAX_HABILITIES[POINT_CLASS]-1) ? "^n" : "")
		
		num_to_str(i, num, charsmax(num))
		menu_additem(menuid, menu, num)
	}
	
	formatex(menu, charsmax(menu), "Resetear las habilidades \y(5p. %s)", LANG_HAB_M[POINT_CLASS])
	menu_additem(menuid, menu, (POINT_CLASS == HAB_HUMAN) ? "8" : "7", ADMIN_ALL, menu_makecallback("detect_menu_sub_hab1_ps"))
	
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_BACKNAME, "Atrás")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid)
}
public detect_menu_sub_hab1_ps(id, menuid, item)
{
	if(g_points[id][POINT_CLASS] >= 5 &&
	(g_hab[id][POINT_CLASS][0] > 0 ||
	g_hab[id][POINT_CLASS][1] > 0 ||
	g_hab[id][POINT_CLASS][2] > 0 ||
	g_hab[id][POINT_CLASS][3] > 0 ||
	g_hab[id][POINT_CLASS][4] > 0 ||
	g_hab[id][POINT_CLASS][5] > 0 ||
	g_hab[id][POINT_CLASS][6] > 0))
		return ITEM_ENABLED;
	
	return ITEM_DISABLED;
}
public menu_hab(id, menuid, item)
{
	// Menu was closed
	if (!is_user_connected(id) || item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_classhz(id, 2)
		return PLUGIN_HANDLED;
	}
	
	static buffer[3], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	POINT_ITEM = str_to_num(buffer)
	
	sub_menu_hab(id)
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}
public sub_menu_hab(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[256], lang[32], info[32], menuid, total, current, points, maxlevel, cost, buffer_only[22], buffer_hab[11], buffer[22];
	
	if(POINT_ITEM <= MAX_HABILITIES[POINT_CLASS])
	{
		current = g_hab[id][POINT_CLASS][POINT_ITEM] + MAX_EFFECTS_HATS_HABS[g_hat_equip[id]+1][POINT_CLASS][POINT_ITEM]
		if(POINT_CLASS == HAB_HUMAN && POINT_ITEM == HUMAN_TCOMBO)
			cost = cost_tcombo
		else
			cost = abs(next_point(current))
		maxlevel = ArrayGetCell(A_HAB_MAX_LEVEL[POINT_CLASS], POINT_ITEM) + MAX_EFFECTS_HATS_HABS[g_hat_equip[id]+1][POINT_CLASS][POINT_ITEM]
		
		points = g_points[id][POINT_CLASS]
		total = points - cost
		ArrayGetString(A_HAB_NAMES[POINT_CLASS], POINT_ITEM, lang, charsmax(lang))
		
		if (total < 0) formatex(info, charsmax(info), "(\r%d Punto%s\d)", cost, (cost != 1) ? "s" : "")
		else formatex(info, charsmax(info), "\y(%d Punto%s)", cost, (cost != 1) ? "s" : "")
		
		// Title
		formatex(menu, charsmax(menu), "%s (%d de %d)(+%d%%)^n\wPuntos %s: \y%d", lang, current, maxlevel, get_percent_upgrade(id, POINT_CLASS, POINT_ITEM), LANG_HAB_M[POINT_CLASS], points)
		
		menuid = menu_create(menu, "menu_sub_hab")
		
		if( current != maxlevel ) formatex(menu, charsmax(menu), "Subir habilidad al nivel %d %s", current+1, info)
		else formatex(menu, charsmax(menu), "Nivel máximo: %d", current)
		
		menu_additem(menuid, menu, "1", ADMIN_ALL, menu_makecallback("detect_menu_sub_hab1"))
		
		formatex(lang, charsmax(lang), "%s", LANG_HAB_DESCRIPTION[POINT_CLASS][POINT_ITEM])
		if(POINT_CLASS == HAB_ZOMBIE && (POINT_ITEM == ZOMBIE_FROZEN || POINT_ITEM == ZOMBIE_FIRE))
		{
			static parts[3][64];
			parts[0][0] = EOS;
			parts[1][0] = EOS;
			parts[2][0] = EOS;
			
			if(POINT_ITEM == ZOMBIE_FROZEN)
			{
				if(current >= 1) formatex(parts[0], charsmax(parts[]), "\r- \wLa reducción de velocidad no dura tanto")
				if(current >= 2) formatex(parts[1], charsmax(parts[]), "\r- \wMenos tiempo de congelamiento")
				if(current >= 3) formatex(parts[2], charsmax(parts[]), "\r- \wLas bombas de fuego no te afectan al estár congelado")
			}
			else
			{
				if(current >= 1) formatex(parts[0], charsmax(parts[]), "\r- \wEl fuego te quita menos vida")
				if(current >= 2) formatex(parts[1], charsmax(parts[]), "\r- \wLa reducción de velocidad no disminuye tanto")
				if(current >= 3) formatex(parts[2], charsmax(parts[]), "\r- \wNo te quemas al tocar un zombie que está en llamas")
			}
			formatex(menu, charsmax(menu), "^n\y%s^n%s^n%s^n%s", lang, parts[0], parts[1], parts[2])
		}
		else
		{
			switch(POINT_CLASS)
			{
				case HAB_HUMAN:
				{
					switch(POINT_ITEM)
					{
						case HUMAN_HP:
						{
							add_dot(ArrayGetCell(g_hclass_hp, g_humanclassnext[id]), buffer_only, charsmax(buffer_only))
							add_dot(amount_upgrade(id, HAB_HUMAN, HUMAN_HP, ArrayGetCell(g_hclass_hp, g_humanclassnext[id]), 1), buffer_hab, charsmax(buffer_hab))
							add_dot(amount_upgrade(id, HAB_HUMAN, HUMAN_HP, ArrayGetCell(g_hclass_hp, g_humanclassnext[id]), 0), buffer, charsmax(buffer))
						}
						case HUMAN_SPEED:
						{
							formatex(buffer_only, charsmax(buffer_only), "%d", floatround(float(ArrayGetCell(g_hclass_spd, g_humanclassnext[id]))))
							formatex(buffer_hab, charsmax(buffer_hab), "%d", floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_SPEED, float(ArrayGetCell(g_hclass_spd, g_humanclassnext[id])), 0, 1)))
							formatex(buffer, charsmax(buffer), "%d", floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_SPEED, float(ArrayGetCell(g_hclass_spd, g_humanclassnext[id])), 0, 0)))
						}
						case HUMAN_GRAVITY:
						{
							formatex(buffer_only, charsmax(buffer_only), "%d", floatround(Float:ArrayGetCell(g_hclass_grav, g_humanclassnext[id]) * 800))
							formatex(buffer_hab, charsmax(buffer_hab), "%d", floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_GRAVITY, Float:ArrayGetCell(g_hclass_grav, g_humanclassnext[id]), 1, 1)))
							formatex(buffer, charsmax(buffer), "%d", floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_GRAVITY, Float:ArrayGetCell(g_hclass_grav, g_humanclassnext[id]), 1, 0)))
						}
						case HUMAN_DAMAGE:
						{
							formatex(buffer_only, charsmax(buffer_only), "%d", floatround(Float:ArrayGetCell(g_hclass_dmg, g_humanclassnext[id])))
							formatex(buffer_hab, charsmax(buffer_hab), "%d", floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_DAMAGE, Float:ArrayGetCell(g_hclass_dmg, g_humanclassnext[id]), 0, 1)))
							formatex(buffer, charsmax(buffer), "%d", floatround(amount_upgrade_f(id, HAB_HUMAN, HUMAN_DAMAGE, Float:ArrayGetCell(g_hclass_dmg, g_humanclassnext[id]), 0, 0)))
						}
						case HUMAN_ARMOR:
						{
							formatex(buffer_only, charsmax(buffer_only), "0")
							formatex(buffer_hab, charsmax(buffer_hab), "%d", amount_upgrade(id, HAB_HUMAN, HUMAN_ARMOR, 0, 1))
							formatex(buffer, charsmax(buffer), "%d", amount_upgrade(id, HAB_HUMAN, HUMAN_ARMOR, 0, 0))
						}
						case HUMAN_AURA:
						{
							formatex(buffer_only, charsmax(buffer_only), "25 - Bubble: 18")
							formatex(buffer_hab, charsmax(buffer_hab), "%d", g_hab[id][HAB_HUMAN][HUMAN_AURA])
							formatex(buffer, charsmax(buffer), "%d - Bubble: %d", g_hab[id][HAB_HUMAN][HUMAN_AURA]+25, g_hab[id][HAB_HUMAN][HUMAN_AURA]+18)
						}
					}
				}
				case HAB_ZOMBIE:
				{
					switch(POINT_ITEM)
					{
						case ZOMBIE_HP:
						{
							add_dot(ArrayGetCell(g_zclass_hp, g_zombieclassnext[id]), buffer_only, charsmax(buffer_only))
							add_dot(amount_upgrade(id, HAB_ZOMBIE, ZOMBIE_HP, ArrayGetCell(g_zclass_hp, g_zombieclassnext[id]), 1), buffer_hab, charsmax(buffer_hab))
							add_dot(amount_upgrade(id, HAB_ZOMBIE, ZOMBIE_HP, ArrayGetCell(g_zclass_hp, g_zombieclassnext[id]), 0), buffer, charsmax(buffer))
						}
						case ZOMBIE_SPEED:
						{
							formatex(buffer_only, charsmax(buffer_only), "%d", floatround(float(ArrayGetCell(g_zclass_spd, g_zombieclassnext[id]))))
							formatex(buffer_hab, charsmax(buffer_hab), "%d", floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_SPEED, float(ArrayGetCell(g_zclass_spd, g_zombieclassnext[id])), 0, 1)))
							formatex(buffer, charsmax(buffer), "%d", floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_SPEED, float(ArrayGetCell(g_zclass_spd, g_zombieclassnext[id])), 0, 0)))
						}
						case ZOMBIE_GRAVITY:
						{
							formatex(buffer_only, charsmax(buffer_only), "%d", floatround(Float:ArrayGetCell(g_zclass_grav, g_zombieclassnext[id]) * 800))
							formatex(buffer_hab, charsmax(buffer_hab), "%d", floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_GRAVITY, Float:ArrayGetCell(g_zclass_grav, g_zombieclassnext[id]), 1, 1)))
							formatex(buffer, charsmax(buffer), "%d", floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_GRAVITY, Float:ArrayGetCell(g_zclass_grav, g_zombieclassnext[id]), 1, 0)))
						}
						case ZOMBIE_DAMAGE:
						{
							formatex(buffer_only, charsmax(buffer_only), "%d", floatround(Float:ArrayGetCell(g_zclass_dmg, g_zombieclassnext[id])))
							formatex(buffer_hab, charsmax(buffer_hab), "%d", floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_DAMAGE, Float:ArrayGetCell(g_zclass_dmg, g_zombieclassnext[id]), 0, 1)))
							formatex(buffer, charsmax(buffer), "%d", floatround(amount_upgrade_f(id, HAB_ZOMBIE, ZOMBIE_DAMAGE, Float:ArrayGetCell(g_zclass_dmg, g_zombieclassnext[id]), 0, 0)))
						}
					}
				}
			}
			
			formatex(menu, charsmax(menu), "^n\w%s base: \y%s^n\w%s %s: \y%s^n\w%s total: \y%s%s",
			lang, buffer_only, lang, (POINT_ITEM == HUMAN_GRAVITY) ? "disminuida" : "extra", buffer_hab, lang, buffer,
			(POINT_ITEM == HUMAN_DAMAGE) ? "^n^n\rNOTA:\w El daño total se suma al daño normal del arma" : "")
		}
		
		if(POINT_ITEM != HUMAN_TCOMBO)
			menu_addtext(menuid, menu)
	}
	else
	{
		menuid = menu_create("\y¿ESTÁS SEGURO?", "menu_sub_hab")
		menu_additem(menuid, "Si", "1")
		menu_additem(menuid, "No", "2")
	}
	
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid)	
}
public detect_menu_sub_hab1(id, menuid, item)
{
	new cost, curr, maxlevel;
	
	curr = g_hab[id][POINT_CLASS][POINT_ITEM] + MAX_EFFECTS_HATS_HABS[g_hat_equip[id]+1][POINT_CLASS][POINT_ITEM]
	if(POINT_CLASS == HAB_HUMAN && POINT_ITEM == HUMAN_TCOMBO)
		cost = cost_tcombo
	else
		cost = abs(next_point(curr))
	maxlevel = ArrayGetCell(A_HAB_MAX_LEVEL[POINT_CLASS], POINT_ITEM) + MAX_EFFECTS_HATS_HABS[g_hat_equip[id]+1][POINT_CLASS][POINT_ITEM]
	
	if(g_points[id][POINT_CLASS] >= cost)
	{
		if(curr < maxlevel)
			return ITEM_ENABLED;
	}
	
	return ITEM_DISABLED;
}
public menu_sub_hab(id, menuid, item)
{
	// Menu was closed
	if (!is_user_connected(id) || item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_hab(id)
		return PLUGIN_HANDLED;
	}
	
	static buffer[3], dummy, percent
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch(str_to_num(buffer))
	{
		case 1:
		{
			if(POINT_ITEM <= MAX_HABILITIES[POINT_CLASS])
			{
				static lang[32]
				new cost, newhab, maxlevel
				
				if(POINT_CLASS == HAB_HUMAN && POINT_ITEM == HUMAN_TCOMBO)
					fn_update_logro(id, LOGRO_HUMAN, TCOMBO);
				
				if(POINT_CLASS == HAB_HUMAN && POINT_ITEM == HUMAN_TCOMBO)
					cost = cost_tcombo
				else
					cost = abs(next_point(g_hab[id][POINT_CLASS][POINT_ITEM] + MAX_EFFECTS_HATS_HABS[g_hat_equip[id]+1][POINT_CLASS][POINT_ITEM]))
				
				g_hab[id][POINT_CLASS][POINT_ITEM]++
				
				newhab = g_hab[id][POINT_CLASS][POINT_ITEM] + MAX_EFFECTS_HATS_HABS[g_hat_equip[id]+1][POINT_CLASS][POINT_ITEM]
				maxlevel = ArrayGetCell(A_HAB_MAX_LEVEL[POINT_CLASS], POINT_ITEM) + MAX_EFFECTS_HATS_HABS[g_hat_equip[id]+1][POINT_CLASS][POINT_ITEM]
				
				g_points[id][POINT_CLASS] -= cost
				g_points_lose[id][POINT_CLASS] += cost
				ArrayGetString(A_HAB_NAMES[POINT_CLASS], POINT_ITEM, lang, charsmax(lang))
				percent = get_percent_upgrade(id, POINT_CLASS, POINT_ITEM)
				
				CC(id, "!g[ZP]!y Subiste la habilidad !g%s!y al nivel !g%d (+%d%%)!y", lang, newhab, percent)
				
				if(newhab == maxlevel)
				{
					new iCount = 1;
					new i;
					
					for(i = 0; i < MAX_HABILITIES[HAB_ZOMBIE]; i++)
					{
						if(POINT_ITEM != i)
						{
							if((g_hab[id][HAB_ZOMBIE][i] + MAX_EFFECTS_HATS_HABS[g_hat_equip[id]+1][HAB_ZOMBIE][i]) == 
							(MAX_HAB_LEVEL[HAB_ZOMBIE][i] + MAX_EFFECTS_HATS_HABS[g_hat_equip[id]+1][HAB_ZOMBIE][i]))
								iCount++;
						}
					}
					
					if(iCount == MAX_HABILITIES[HAB_ZOMBIE])
						fn_give_hat(id, HAT_TYNO)
					
					if(g_hat[id][HAT_TYNO])
					{
						iCount = 1;
						for(i = 0; i < MAX_HABILITIES[HAB_HUMAN]; i++)
						{
							if(POINT_ITEM != i)
							{
								if((g_hab[id][HAB_HUMAN][i] + MAX_EFFECTS_HATS_HABS[g_hat_equip[id]+1][HAB_HUMAN][i]) == 
								(MAX_HAB_LEVEL[HAB_HUMAN][i] + MAX_EFFECTS_HATS_HABS[g_hat_equip[id]+1][HAB_HUMAN][i]))
									iCount++;
							}
						}
						
						if(iCount == MAX_HABILITIES[HAB_HUMAN] && (g_rn[id][RING][0] == 4 || g_rn[id][RING][1] == 4 || g_rn[id][RING][2] == 4))
							fn_give_hat(id, HAT_ZIPPY)
					}
				}
			}
			else
			{
				g_points[id][POINT_CLASS] -= 5
				g_points[id][POINT_CLASS] += g_points_lose[id][POINT_CLASS]
				
				static points_wins[15]
				add_dot(g_points_lose[id][POINT_CLASS], points_wins, 14)
				CC(id, "!g[ZP]!y Habilidades reseteadas. Se te devolvieron !g%sp. %s!y", points_wins, LANG_HAB_M[POINT_CLASS])
				
				g_points_lose[id][POINT_CLASS] = 0
				
				for(new a = 0; a < MAX_HUMAN_HABILITIES; a++)
					g_hab[id][POINT_CLASS][a] = 0
				
				menu_destroy(menuid)
				show_menu_hab(id)
				return PLUGIN_HANDLED;
			}
		}
		case 2:
		{
			menu_destroy(menuid)
		
			show_menu_hab(id)
			return PLUGIN_HANDLED;
		}
	}
	
	menu_destroy(menuid)
	sub_menu_hab(id)
	return PLUGIN_HANDLED;
}


show_menu_hab_money(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[256], lang[64], num[8], i, menuid, percent, buff_money[15]
	add_dot(g_money[id], buff_money, 14)
	
	formatex(menu, charsmax(menu), "\y%s^n\wPlata: \y$%s", LANG_HAB[POINT_CLASS], buff_money)
	menuid = menu_create(menu, "menu_hab_money")
	
	for(i = 0; i < MAX_HABILITIES[POINT_CLASS]; i++)
	{
		ArrayGetString(A_HAB_NAMES[POINT_CLASS], i, lang, charsmax(lang))
		
		percent = get_percent_upgrade(id, POINT_CLASS, i)
		
		if (percent)
			formatex(menu, charsmax(menu), "%s \y(%d de %d)(+%d%%)%s", lang, g_hab[id][POINT_CLASS][i], ArrayGetCell(A_HAB_MAX_LEVEL[POINT_CLASS], i), percent, (i == MAX_HABILITIES[POINT_CLASS]-1) ? "^n" : "")
		else
			formatex(menu, charsmax(menu), "%s \y(%d de %d)%s", lang, g_hab[id][POINT_CLASS][i], ArrayGetCell(A_HAB_MAX_LEVEL[POINT_CLASS], i), (i == MAX_HABILITIES[POINT_CLASS]-1) ? "^n" : "")
		
		num_to_str(i, num, charsmax(num))
		menu_additem(menuid, menu, num)
	}
	
	/*formatex(menu, charsmax(menu), "Resetear las habilidades \y($10)")
	menu_additem(menuid, menu, (POINT_CLASS == HAB_SURV) ? "6" : (POINT_CLASS == HAB_NEM) ?"5" : "2", ADMIN_ALL, menu_makecallback("detect_menu_sub_hab1_ps_money"))*/
	
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_BACKNAME, "Atrás")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid)
}
/*public detect_menu_sub_hab1_ps_money(id, menuid, item)
{
	if(g_money[id] >= 10 &&
	(g_hab[id][POINT_CLASS][0] > 0 ||
	g_hab[id][POINT_CLASS][1] > 0 ||
	g_hab[id][POINT_CLASS][2] > 0 ||
	g_hab[id][POINT_CLASS][3] > 0 ||
	g_hab[id][POINT_CLASS][4] > 0 ||
	g_hab[id][POINT_CLASS][5] > 0 ||
	g_hab[id][POINT_CLASS][6] > 0))
		return ITEM_ENABLED;
	
	return ITEM_DISABLED;
}*/
public menu_hab_money(id, menuid, item)
{
	// Menu was closed
	if (!is_user_connected(id) || item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_classhz(id, 2)
		return PLUGIN_HANDLED;
	}
	
	static buffer[3], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	POINT_ITEM = str_to_num(buffer)
	
	sub_menu_hab_money(id)
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}
public sub_menu_hab_money(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[256], lang[128], info[32], menuid, total, current, money, money_buff[15], maxlevel, cost;
	
	if(POINT_ITEM <= MAX_HABILITIES[POINT_CLASS])
	{
		current = g_hab[id][POINT_CLASS][POINT_ITEM]
		cost = get_cost_money(id, POINT_CLASS, POINT_ITEM)
		money = g_money[id]
		add_dot(money, money_buff, 14)
		total = money - cost
		maxlevel = ArrayGetCell(A_HAB_MAX_LEVEL[POINT_CLASS], POINT_ITEM)
		ArrayGetString(A_HAB_NAMES[POINT_CLASS], POINT_ITEM, lang, charsmax(lang))
		
		if (total < 0) formatex(info, charsmax(info), "(\r$%d\d)", cost)
		else formatex(info, charsmax(info), "\y($%d)", cost)
		
		// Title
		formatex(menu, charsmax(menu), "%s (%d de %d)(+%d%%)^n\wPlata: \y$%s", lang, current, maxlevel, get_percent_upgrade(id, POINT_CLASS, POINT_ITEM), money_buff)
		
		menuid = menu_create(menu, "menu_sub_hab_money")
		
		if( current != maxlevel ) formatex(menu, charsmax(menu), "Subir habilidad al nivel %d %s", current+1, info)
		else formatex(menu, charsmax(menu), "Nivel máximo: %d", current)
		
		menu_additem(menuid, menu, "1", ADMIN_ALL, menu_makecallback("detect_menu_sub_hab1_money"))
		
		formatex(lang, charsmax(lang), "%s", LANG_HAB_DESCRIPTION[POINT_CLASS][POINT_ITEM])
		if(POINT_ITEM != SURV_HP && POINT_ITEM != SURV_DMG)
		{
			static parts[170];
			parts[0] = EOS;
			switch(POINT_CLASS)
			{
				case HAB_SURV:
				{
					switch(POINT_ITEM)
					{
						case SURV_SPEED_WEAPON: formatex(parts, charsmax(parts), "\r- \wAumenta la velocidad con la que disparas")
						case SURV_EXTRA_BOMB: formatex(parts, charsmax(parts), "\r- \wTe otorga una bomba de aniquilación extra")
						case SURV_EXTRA_IMMUNITY: formatex(parts, charsmax(parts), "\r- \wHace que tu inmunidad dure 10 segundos más")
					}
				}
				case HAB_NEM:
				{
					switch(POINT_ITEM)
					{
						case NEM_BAZOOKA_FOLLOW: formatex(parts, charsmax(parts), "\r- \wHace que tu bazooka tenga un nuevo modo^nPodes alternar el modo a través del clic derecho^n\rNOTA:\w También cuenta para la bazooka del aniquilador")
						case NEM_BAZOOKA_RADIUS: formatex(parts, charsmax(parts), "\r- \wHace que tu bazooka alcanze 250 unidades más^n\rNOTA:\w También cuenta para la bazooka del aniquilador")
					}
				}
			}
			
			formatex(menu, charsmax(menu), "^n\y%s^n%s", lang, parts)
			menu_addtext(menuid, menu)
		}
		else if(POINT_CLASS == HAB_OTHER)
		{
			static parts[128];
			parts[0] = EOS;
			switch(POINT_ITEM)
			{
				case OTHER_COMBO_WESKER: formatex(parts, charsmax(parts), "\r- \wHabilita el combo para que tu wesker pueda realizarlo^n\rNOTA:\w Este combo no cuenta para el combo máximo")
				case OTHER_CINCO_BALAS: formatex(parts, charsmax(parts), "\r- \wAumenta 10 balas a todas tus armas")
				case OTHER_ULTRA_LASER: formatex(parts, charsmax(parts), "")
			}
			
			formatex(menu, charsmax(menu), "^n\y%s^n%s", lang, parts)
			menu_addtext(menuid, menu)
		}
	}
	/*else
	{
		menuid = menu_create("\y¿ESTÁS SEGURO?", "menu_sub_hab_money")
		menu_additem(menuid, "Si", "1")
		menu_additem(menuid, "No", "2")
	}*/
	
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid)
}
public detect_menu_sub_hab1_money(id, menuid, item)
{
	new cost = get_cost_money(id, POINT_CLASS, POINT_ITEM);
	
	if(g_money[id] >= cost)
	{
		if(g_hab[id][POINT_CLASS][POINT_ITEM] < ArrayGetCell(A_HAB_MAX_LEVEL[POINT_CLASS], POINT_ITEM))
			return ITEM_ENABLED;
	}
	
	return ITEM_DISABLED;
}
public menu_sub_hab_money(id, menuid, item)
{
	// Menu was closed
	if (!is_user_connected(id) || item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_hab_money(id)
		return PLUGIN_HANDLED;
	}
	
	static buffer[3], dummy, percent
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch(str_to_num(buffer))
	{
		case 1:
		{
			if(POINT_ITEM <= MAX_HABILITIES[POINT_CLASS])
			{
				static lang[32]
				new cost = get_cost_money(id, POINT_CLASS, POINT_ITEM);
				
				g_money[id] -= cost
				g_money_lose[id] += cost
				g_hab[id][POINT_CLASS][POINT_ITEM]++
				ArrayGetString(A_HAB_NAMES[POINT_CLASS], POINT_ITEM, lang, charsmax(lang))
				percent = get_percent_upgrade(id, POINT_CLASS, POINT_ITEM)
				
				CC(id, "!g[ZP]!y Subiste la habilidad !g%s!y al nivel !g%d (+%d%%)!y", lang, g_hab[id][POINT_CLASS][POINT_ITEM], percent)
				
				if(POINT_CLASS == HAB_OTHER && POINT_ITEM == OTHER_ULTRA_LASER)
					fn_update_logro(id, LOGRO_WESKER, ULTRA_LASER);
				
				new newhab = g_hab[id][POINT_CLASS][POINT_ITEM]
				new maxlevel = ArrayGetCell(A_HAB_MAX_LEVEL[POINT_CLASS], POINT_ITEM)
				
				if(newhab == maxlevel)
				{
					new iCount = 1;
					new i;
					
					for(i = 0; i < MAX_HABILITIES[HAB_SURV]; i++)
					{
						if(POINT_ITEM != i)
						{
							if(g_hab[id][HAB_SURV][i] == MAX_HAB_LEVEL[HAB_SURV][i])
								iCount++;
						}
					}
					
					if(iCount == MAX_HABILITIES[HAB_SURV])
						fn_update_logro(id, LOGRO_SECRET, SURVIVOR_DEF)
				}
			}
			/*else
			{
				g_money[id] -= 10
				g_money[id] += g_money_lose[id]
				
				static money_wins[15]
				add_dot(g_money_lose[id], money_wins, 14)
				CC(id, "!g[ZP]!y Habilidades reseteadas. Se te devolvieron !g$%s!y", money_wins)
				
				g_money_lose[id] = 0
				
				for(new a = 0; a < MAX_HUMAN_HABILITIES; a++)
					g_hab[id][POINT_CLASS][a] = 0
				
				menu_destroy(menuid)
				show_menu_hab_money(id)
				return PLUGIN_HANDLED;
			}*/
		}
		/*case 2:
		{
			menu_destroy(menuid)
		
			show_menu_hab_money(id)
			return PLUGIN_HANDLED;
		}*/
	}
	
	menu_destroy(menuid)
	sub_menu_hab_money(id)
	return PLUGIN_HANDLED;
}
/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ LOGROS ]
=======================================================================================*/
show_menu_logros(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[770], lang[64], num[8], i, menuid, buff[32]
	formatex(buff, 31, "%s", (equal(LANG_CLASS_LOGROS_MIN[LOGRO_CLASS], "otros")) ? "logros" : LANG_CLASS_LOGROS_MIN[LOGRO_CLASS])
	
	formatex(menu, charsmax(menu), "\y%s^n\w%s%s completados: \y%d^n\wLogros totales completados: \y%d de %d\R",
	LANG_CLASS_LOGROS[LOGRO_CLASS], (equal(LANG_CLASS_LOGROS_MIN[LOGRO_CLASS], "otros")) ? "Otros " : "Logros ", buff,
	get_count_logros(id, LOGRO_CLASS), g_logros_completed[id], g_total_logros)
	
	menuid = menu_create(menu, "menu_logros")
	
	for(i = 0; i < MAX_LOGROS_CLASS[LOGRO_CLASS]; i++)
	{
		ArrayGetString(A_LOGROS_NAMES[LOGRO_CLASS], i, lang, charsmax(lang))
		
		if(LOGRO_CLASS == LOGRO_SECRET && i == JUGADOR_COMPULSIVO)
			formatex(menu, charsmax(menu), "%s%s \w(\yLOGRO REPETIBLE\w)", g_logro[id][LOGRO_CLASS][i] ? "\w" : "\d", lang)
		else
			formatex(menu, charsmax(menu), "%s%s (%s)", g_logro[id][LOGRO_CLASS][i] ? "\w" : "\d", lang,  g_logro[id][LOGRO_CLASS][i] ? "\yCOMPLETO\w" : "\rINCOMPLETO\d")
		
		num_to_str(i, num, charsmax(num))
		menu_additem(menuid, menu, num)
	}
	
	MENU_PAGE_LOGROS(LOGRO_CLASS) = min(MENU_PAGE_LOGROS(LOGRO_CLASS), menu_pages(menuid)-1)
	
	menu_setprop(menuid, MPROP_BACKNAME, "Anterior")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid, MENU_PAGE_LOGROS(LOGRO_CLASS))
}
public menu_logros(id, menuid, item)
{
	// Menu was closed
	if(!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Remember player's menu page
	static menudummy
	player_menu_info(id, menudummy, menudummy, MENU_PAGE_LOGROS(LOGRO_CLASS))
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
	#if defined EVENT_NAVIDAD
		if(LOGRO_CLASS == LOGRO_EV_NAVIDAD)
			show_menu_event_navidad(id)
		else
			show_menu_classhz(id, 3)
	#else
		#if defined EVENT_AMOR
			if(LOGRO_CLASS == LOGRO_EV_AMOR)
				show_menu_event_amor(id)
			else
				show_menu_classhz(id, 3)
		#endif
	#endif
		
		if(LOGRO_CLASS == LOGRO_EV_HEAD_ZOMBIES)
			show_menu_headz(id)
		else
			show_menu_classhz(id, 3)
	
		return PLUGIN_HANDLED;
	}
	
	new buffer[3], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	LOGRO_ITEM = str_to_num(buffer)
	
	menu_destroy(menuid)
	
	sub_menu_logros(id)
	return PLUGIN_HANDLED;
}
public sub_menu_logros(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[1024], len
	len = 0
	
	static lang[275], iAGC;
	
	ArrayGetString(A_LOGROS_NAMES[LOGRO_CLASS], LOGRO_ITEM, lang, charsmax(lang))
	len += formatex(menu[len], charsmax(menu) - len, "\yLOGRO %s^n\y%s (%s\y)^n^n", LANG_CLASS_LOGROS[LOGRO_CLASS], lang,
	g_logro[id][LOGRO_CLASS][LOGRO_ITEM] ? "\wCOMPLETADO" : "\rNO COMPLETADO")
	
	if(LOGRO_CLASS != LOGRO_SECRET)
	{
		iAGC = ArrayGetCell(A_LOGROS_POINTS[LOGRO_CLASS], LOGRO_ITEM)
		ArrayGetString(A_LOGROS_DESCRIPTION[LOGRO_CLASS], LOGRO_ITEM, lang, charsmax(lang))
		
		len += formatex(menu[len], charsmax(menu) - len, "\yDESCRIPCIÓN:^n\w%s^n^n\yRECOMPENSA:^n%4s\r- \w$%d", lang, "", iAGC)
	}
	else len += formatex(menu[len], charsmax(menu) - len, "\yDESCRIPCIÓN: %s^n^n\yRECOMPENSA:^n%s", LANG_LOGROS_DESCRIPTION[LOGRO_CLASS][LOGRO_ITEM], A_LOGROS_REWARD[LOGRO_ITEM])

	
	if(LOGRO_CLASS == LOGRO_OTHERS && LOGRO_ITEM == SOY_MUY_VICIADO)
		len += formatex(menu[len], charsmax(menu) - len, "^n^n\yTIEMPO JUGADO EN TAN: \w%d minutos^n\rNOTA: \wSe requieren 318 minutos para el logro", gl_tantime[id])
	else if(LOGRO_CLASS == LOGRO_SECRET)
	{
		switch(LOGRO_ITEM)
		{
			case TERRORISTA_1: len += formatex(menu[len], charsmax(menu) - len, "^n^n\yPROGRESO: \w%0.2f%%", gl_progress[id][0])
			case HITMAN: len += formatex(menu[len], charsmax(menu) - len, "^n^n\yPROGRESO: \w%0.2f%%", gl_progress[id][1])
			case MILLONARIO: len += formatex(menu[len], charsmax(menu) - len, "^n^n\yPROGRESO: \w%0.2f%%", gl_progress[id][2])
			case EL_TERROR_EXISTE: len += formatex(menu[len], charsmax(menu) - len, "^n^n\yPROGRESO: \w%0.2f%%", gl_progress[id][3])
			case RESISTENCIA: len += formatex(menu[len], charsmax(menu) - len, "^n^n\yPROGRESO: \w%0.2f%%", gl_progress[id][4])
			case ALBERT_WESKER: len += formatex(menu[len], charsmax(menu) - len, "^n^n\yPROGRESO: \w%0.2f%%", gl_progress[id][5])
			case SUPER_AGENTE: len += formatex(menu[len], charsmax(menu) - len, "^n^n\yPROGRESO: \w%0.2f%%", gl_progress[id][6])
		}
	}
	
	// 0. Exit
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r0.\w Atrás")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "Logros Menu")
}
public menu_sub_logros(id, key)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(key == 9) show_menu_logros(id)
	else sub_menu_logros(id)
	
	return PLUGIN_HANDLED;
}
get_count_logros(id, logro_class_1)
{
	new i_Count = 0;
	new i;
	
	for(i = 0; i < TOTAL_LOGROS; i++)
	{
		if(g_logro[id][logro_class_1][i])
			i_Count++;
	}
	
	return i_Count;
}
fn_hats_count(id)
{
	new i_Count = 0;
	new i;
	
	for(i = 0; i < MAX_HATS; i++)
	{
		if(g_hat[id][i])
			i_Count++;
	}
	
	return i_Count;
}


/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ NIVELES ]
=======================================================================================*/
update_xp(id, xp, aps) // uxp
{
	if(!hub(id, g_data[BIT_CONNECTED])) return PLUGIN_HANDLED;
	
	static Float:ap;
	ap = float(aps)
	
	ap *= g_mult_aps[id]
	
	g_ammopacks[id] += floatround(ap)
	
	if(g_level[id] >= MAX_LVL || (g_exp[id] + xp) > MAX_XP) return PLUGIN_HANDLED;
	
	g_exp[id] += xp
	
	static level, dif
	level = g_level[id]
	while(g_exp[id] >= (XPNeeded[level] * MULT_PER_RANGE)) level++
	
	if(level > g_level[id])
	{
		dif = level - g_level[id]
		client_print(id, print_center, "Enhorabuena! Avanzaste %d nivel%s", dif, (dif != 1) ? "es" : "")
		
		g_level[id] = level
		
		if(g_level[id] >= 280)
			fn_update_logro(id, LOGRO_OTHERS, YA_VOY_POR_LA_MITAD)
	}
	
	return PLUGIN_HANDLED;
}


/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ INTERFAZ ]
=======================================================================================*/
show_menu_interfaz(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menuid
	
	// Title
	menuid = menu_create("\yINTERFAZ GRÁFICA", "menu_interfaz")
	
	menu_additem(menuid, "Color Visión Nocturna", "1")
	menu_additem(menuid, "Color Granada Luz", "2")
	menu_additem(menuid, "Opciones del HUD", "3")
	
	if(!check_access(id, 1))
	{
		menu_additem(menuid, "Opciones del HUD del COMBO^n", "4")
		
		menu_additem(menuid, "Bindear items extras", "5")
	}
	else
	{
		menu_additem(menuid, "Opciones del HUD del COMBO", "4")
		menu_additem(menuid, "Color Granada Bubble^n", "5")
		
		menu_additem(menuid, "Bindear items extras", "6")
	}
	
	// Exit
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid)
}
public menu_interfaz(id, menuid, item)
{
	// Player disconnected?
	if(!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_game(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve item id
	static buffer[2], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch(str_to_num(buffer[0]))
	{
		case 1:
		{
			NVG_HUD = COLOR_NVG
			show_menu_nvghud_color(id)
		}
		case 2:
		{
			if(!hub(id, g_data[BIT_PREMIUM]))
			{
				CC(id, "!g[ZP]!y Solo los usuarios premium pueden modificar esta opción")
				
				menu_destroy(menuid)
				show_menu_interfaz(id)
				
				return PLUGIN_HANDLED;
			}
		
			NVG_HUD = COLOR_LIGHT
			show_menu_nvghud_color(id)
		}
		case 3:
		{
			show_menu_option_hud(id)
		}
		case 4:
		{
			show_menu_option_hud_combo(id)
		}
		case 5:
		{
			if(!check_access(id, 1))
				show_menu_binds(id, 0)
			else
			{
				NVG_HUD = COLOR_BUBBLE
				show_menu_nvghud_color(id)
			}
		}
		case 6:
		{
			if(check_access(id, 1))
				show_menu_binds(id, 0)
		}
	}
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}

// Option HUD Menu
show_menu_option_hud(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menuid, buffer[64]
	
	// Title
	menuid = menu_create("\yHEAD-UP DISPLAY\R", "menu_option_hud")
	
	menu_additem(menuid, "Posición del HUD", "1")
	menu_additem(menuid, "Color del HUD", "2")
	
	formatex(buffer, charsmax(buffer), "Titileo del HUD (%s\w)", (g_hud_eff[id]) ? "\yACTIVADO" : "\rDESACTIVADO")
	menu_additem(menuid, buffer, "3")
	
	formatex(buffer, charsmax(buffer), "HUD Abreviado (%s\w)", (g_hud_min[id]) ? "\yACTIVADO" : "\rDESACTIVADO")
	menu_additem(menuid, buffer, "4")
	
	formatex(buffer, charsmax(buffer), "HUD Minimizado (%s\w)", (g_hud_abv[id]) ? "\yACTIVADO" : "\rDESACTIVADO")
	menu_additem(menuid, buffer, "5")
	
	formatex(buffer, charsmax(buffer), "%s HUD^n", (!g_hud_off[id]) ? "Desactivar" : "Activar")
	menu_additem(menuid, buffer, "6")
	
	menu_additem(menuid, "Todo por defecto", "7")
	
	// Exit
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	MENU_PAGE_OPT_HUD = min(MENU_PAGE_OPT_HUD, menu_pages(menuid)-1)
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid, MENU_PAGE_OPT_HUD)
}
public menu_option_hud(id, menuid, item)
{
	// Player disconnected?
	if(!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Remember player's menu page
	static menudummy
	player_menu_info(id, menudummy, menudummy, MENU_PAGE_OPT_HUD)
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_interfaz(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve item id
	static buffer[6], dummy, itm
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	itm = str_to_num(buffer)
	
	switch(itm)
	{
		case 1: show_menu_position(id)
		case 2:
		{
			NVG_HUD = COLOR_HUD
			show_menu_nvghud_color(id)
		}
		case 3: g_hud_eff[id] = !g_hud_eff[id]
		case 4: g_hud_min[id] = !g_hud_min[id]
		case 5: g_hud_abv[id] = !g_hud_abv[id]
		case 6: g_hud_off[id] = !g_hud_off[id]
		case 7:
		{
			g_color[id][COLOR_HUD] = {0, 0, 255}
			g_hud_pos[id] = Float:{0.02, 0.12, 0.0}
			g_hud_eff[id] = 0
			g_hud_min[id] = 0
			g_hud_abv[id] = 0
			g_hud_off[id] = 0
		}
	}
	
	if(itm != 1 && itm != 2)
		show_menu_option_hud(id)
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}

// Position HUD Menu
show_menu_position(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menuid
	
	// Title
	menuid = menu_create("\yPOSICIÓN DEL HUD\R", "menu_position")
	
	menu_additem(menuid, "Mover hacia arriba", "1")
	menu_additem(menuid, "Mover hacia abajo", "2")
	menu_additem(menuid, "Mover hacia la izquierda", "3", ADMIN_ALL, menu_makecallback("detect_move_ok"))
	menu_additem(menuid, "Mover hacia la derecha^n", "4", ADMIN_ALL, menu_makecallback("detect_move_ok"))
	
	menu_additem(menuid, "Centrar HUD horizontalmente", "5")
	menu_additem(menuid, "Centrar HUD verticalmente^n", "6")
	
	menu_additem(menuid, "Posición por defecto", "7")
	
	// Exit
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid, 0)
}
public detect_move_ok(id, menuid, item)
{
	// Retrieve itemid
	new buffer[6]
	new _access, callback
	menu_item_getinfo(menuid, item, _access, buffer, charsmax(buffer), _, _, callback)
	
	if(!g_hud_pos[id][2])
		return ITEM_ENABLED;
	
	return ITEM_DISABLED;
}
public menu_position(id, menuid, item)
{
	// Player disconnected?
	if(!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}

	if(item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_option_hud(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve item id
	static buffer[6], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch(str_to_num(buffer))
	{
		case 1: g_hud_pos[id][1] -= 0.01
		case 2: g_hud_pos[id][1] += 0.01
		case 3:
		{
			g_hud_pos[id][0] -= 0.01
			g_hud_pos[id][2] = 0.00
		}
		case 4:
		{
			g_hud_pos[id][0] += 0.01
			g_hud_pos[id][2] = 0.00
		}
		case 5:
		{
			g_hud_pos[id][0] = 0.0
			g_hud_pos[id][2] = 0.0
		}
		case 6:
		{
			g_hud_pos[id][0] = -1.0
			g_hud_pos[id][2] = 1.0
		}
		case 7: g_hud_pos[id] = Float:{0.02, 0.12, 0.0}
	}
	
	menu_destroy(menuid)
	
	show_menu_position(id)
	return PLUGIN_HANDLED;
}

// Option HUD Combo Menu
show_menu_option_hud_combo(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menuid, buffer[64]
	
	// Title
	menuid = menu_create("\yHEAD-UP DISPLAY DEL COMBO\R", "menu_option_hud_combo")
	
	menu_additem(menuid, "Posición del HUD del combo", "1")
	menu_additem(menuid, "Color del HUD del combo^n", "2")
	
	formatex(buffer, 63, "%s el \y'Daño total'\w en el HUD del combo^n", g_hud_combo_dmg_total[id] ? "Desactivar" : "Activar")
	menu_additem(menuid, buffer, "3")
	
	menu_additem(menuid, "Todo por defecto", "4")
	
	// Exit
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid)
}
public menu_option_hud_combo(id, menuid, item)
{
	// Player disconnected?
	if(!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_interfaz(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve item id
	static buffer[6], dummy, itm
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	itm = str_to_num(buffer)
	
	switch(itm)
	{
		case 1: show_menu_position_combo(id)
		case 2:
		{
			NVG_HUD = COLOR_HUD_COMBO
			show_menu_nvghud_color(id)
		}
		case 3:
		{
			g_hud_combo_dmg_total[id] = !g_hud_combo_dmg_total[id]
			
			if(g_combo[id] < 1)
			{
				set_hudmessage(g_color[id][COLOR_HUD_COMBO][0], g_color[id][COLOR_HUD_COMBO][1], g_color[id][COLOR_HUD_COMBO][2], g_hud_combo_pos[id][0], g_hud_combo_pos[id][1], 0, 1.0, 8.0, 0.01, 0.01)
				ShowSyncHudMsg(id, g_MsgSync3, "%sCombo de 1.337 de XP^nDaño: 1.337%s", (g_hab[id][HAB_HUMAN][HUMAN_TCOMBO]) ? "T" : "",
				g_hud_combo_dmg_total[id] ? " | Daño total: 1.337" : "")
			}
			
			menu_destroy(menuid)
			show_menu_option_hud_combo(id)
			
			return PLUGIN_HANDLED;
		}
		case 4:
		{
			g_color[id][COLOR_HUD_COMBO] = {0, 255, 0}
			g_hud_combo_pos[id] = Float:{-1.0, 0.57, 1.0}
			g_hud_combo_dmg_total[id] = 1
			
			menu_destroy(menuid)
			show_menu_option_hud_combo(id)
			
			return PLUGIN_HANDLED;
		}
	}
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}

// Position HUD Combo Menu
show_menu_position_combo(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menuid
	
	// Title
	menuid = menu_create("\yPOSICIÓN DEL HUD DEL COMBO\R", "menu_position_combo")
	
	menu_additem(menuid, "Mover hacia arriba", "1")
	menu_additem(menuid, "Mover hacia abajo", "2")
	menu_additem(menuid, "Mover hacia la izquierda", "3", ADMIN_ALL, menu_makecallback("detect_move_ok_combo"))
	menu_additem(menuid, "Mover hacia la derecha^n", "4", ADMIN_ALL, menu_makecallback("detect_move_ok_combo"))
	
	menu_additem(menuid, "Centrar HUD horizontalmente", "5")
	menu_additem(menuid, "Centrar HUD verticalmente^n", "6")
	
	menu_additem(menuid, "Posición por defecto", "7")
	
	// Exit
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid, 0)
}
public detect_move_ok_combo(id, menuid, item)
{
	// Retrieve itemid
	new buffer[6]
	new _access, callback
	menu_item_getinfo(menuid, item, _access, buffer, charsmax(buffer), _, _, callback)
	
	if(!g_hud_combo_pos[id][2])
		return ITEM_ENABLED;
	
	return ITEM_DISABLED;
}
public menu_position_combo(id, menuid, item)
{
	// Player disconnected?
	if(!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}

	if(item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_option_hud_combo(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve item id
	static buffer[6], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch(str_to_num(buffer))
	{
		case 1: g_hud_combo_pos[id][1] -= 0.01
		case 2: g_hud_combo_pos[id][1] += 0.01
		case 3:
		{
			g_hud_combo_pos[id][0] -= 0.01
			g_hud_combo_pos[id][2] = 0.00
		}
		case 4:
		{
			g_hud_combo_pos[id][0] += 0.01
			g_hud_combo_pos[id][2] = 0.00
		}
		case 5:
		{
			g_hud_combo_pos[id][0] = 0.0
			g_hud_combo_pos[id][2] = 0.0
		}
		case 6:
		{
			g_hud_combo_pos[id][0] = -1.0
			g_hud_combo_pos[id][2] = 1.0
		}
		case 7: g_hud_combo_pos[id] = Float:{-1.0, 0.57, 1.0}
	}
	
	if(g_combo[id] < 1)
	{
		set_hudmessage(g_color[id][COLOR_HUD_COMBO][0], g_color[id][COLOR_HUD_COMBO][1], g_color[id][COLOR_HUD_COMBO][2], g_hud_combo_pos[id][0], g_hud_combo_pos[id][1], 0, 1.0, 8.0, 0.01, 0.01)
		ShowSyncHudMsg(id, g_MsgSync3, "%sCombo de 1.337 de XP^nDaño: 1.337 | Daño total: 1.337", (g_hab[id][HAB_HUMAN][HUMAN_TCOMBO]) ? "T" : "")
	}
	
	menu_destroy(menuid)
	
	show_menu_position_combo(id)
	return PLUGIN_HANDLED;
}

// NightVision/HUD Color Menu
show_menu_nvghud_color(id)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[350], len, loop
	len = 0
	
	// Title
	switch(NVG_HUD)
	{
		case COLOR_NVG: len += formatex(menu[len], charsmax(menu) - len, "\yCOLOR VISIÓN NOCTURNA^n^n")
		case COLOR_HUD: len += formatex(menu[len], charsmax(menu) - len, "\yCOLOR HEAD-UP DISPLAY^n^n")
		case COLOR_LIGHT: len += formatex(menu[len], charsmax(menu) - len, "\yCOLOR GRANADA LUZ^n^n")
		case COLOR_BUBBLE: len += formatex(menu[len], charsmax(menu) - len, "\yCOLOR GRANADA BUBBLE^n^n")
		case COLOR_HUD_COMBO: len += formatex(menu[len], charsmax(menu) - len, "\yCOLOR HEAD-UP DISPLAY DEL COMBO^n^n")
	}
	
	// Add Items
	for(loop = 0; loop < MAX_COLORS; loop++)
	{
		if((g_color[id][NVG_HUD][0] == TABLET_COLORS[loop][0]) && (g_color[id][NVG_HUD][1] == TABLET_COLORS[loop][1]) && (g_color[id][NVG_HUD][2] == TABLET_COLORS[loop][2]))
			len += formatex(menu[len], charsmax(menu) - len, "\r%d.\d %s^n", loop+1, COLORS_NAME[NVG_HUD][loop])
		else len += formatex(menu[len], charsmax(menu) - len, "\r%d.\w %s^n", loop+1, COLORS_NAME[NVG_HUD][loop])
	}
	
	if(NVG_HUD == COLOR_BUBBLE)
		len += formatex(menu[len], charsmax(menu) - len, "^n\rNOTA: \wEl color de la bubble también cambiara el color^nque emita la luz de la bubble^n")
	
	// 0. Exit
	len += formatex(menu[len], charsmax(menu) - len, "^n\r0.\w Ir a la interfaz")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "NVG/HUD Color Menu")
}
public menu_nvghud_color(id, key)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	if(key == 8)
	{
		show_menu_nvghud_color(id)
		return PLUGIN_HANDLED;
	}
	
	if(key == 9)
	{
		show_menu_interfaz(id)
		return PLUGIN_HANDLED;
	}
	
	g_color[id][NVG_HUD][0] = TABLET_COLORS[key][0]
	g_color[id][NVG_HUD][1] = TABLET_COLORS[key][1]
	g_color[id][NVG_HUD][2] = TABLET_COLORS[key][2]
	
	if(g_combo[id] < 1 && NVG_HUD == COLOR_HUD_COMBO)
	{
		set_hudmessage(g_color[id][COLOR_HUD_COMBO][0], g_color[id][COLOR_HUD_COMBO][1], g_color[id][COLOR_HUD_COMBO][2], g_hud_combo_pos[id][0], g_hud_combo_pos[id][1], 0, 1.0, 8.0, 0.01, 0.01)
		ShowSyncHudMsg(id, g_MsgSync3, "%sCombo de 1.337 de XP^nDaño: 1.337 | Daño total: 1.337", (g_hab[id][HAB_HUMAN][HUMAN_TCOMBO]) ? "T" : "")
	}
	
	show_menu_nvghud_color(id)
	return PLUGIN_HANDLED;
}

show_menu_binds(id, pag)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[800], len, buff_x[2][32], buff_2nd[350]
	len = 0
	
	MENU_PAGE_BINDS = pag
	
	formatex(buff_x[0], charsmax(buff_x[]), "%s", (g_level[id] >= GRENADE_LVL_REQUIRED) ? "Granada" : "Fuego")
	formatex(buff_x[1], charsmax(buff_x[]), "%s", (g_level[id] >= BUBBLE_LVL_REQUIRED) ? "Bubble" : "Luz")
	formatex(buff_2nd, charsmax(buff_2nd), "\w+500 HP: \yie 9^n\
	\w+100 Chaleco: \yie 10^n\
	\w+5.000 HP: \yie 11^n\
	\w+10.000 HP: \yie 12^n\
	\w+15.000 HP: \yie 13^n\
	\w%s: \yie 14^n\
	\wHielo: \yie 15^n\
	\w%s: \yie 16^n\
	\wBomba Antidoto: \yie 17^n\
	^n\r9. \wAtrás", buff_x[0], buff_x[1])
	
	len += formatex(menu[len], charsmax(menu) - len, "\yBINDEAR ITEMS EXTRAS^n\wSolo tienes que escribir en consola:^n\
	bind TECLA ^"ie num^"^n^n\
	\yLISTA DE ITEMS EXTRAS:^n\
	%s", (!pag) ? 
	"\wVisión Nocturna: \yie 1^n\
	\wAntidoto: \yie 2^n\
	\wFuria Zombie: \yie 3^n\
	\wBomba de infección: \yie 4^n\
	\wLong Jump: \yie 5^n\
	\wBalas Infinitas: \yie 6^n\
	\wBomba reloj: \yie 7^n\
	\w+100 HP: \yie 8^n\
	^n\r9. \wSiguiente" : buff_2nd)
	
	// 0. Exit
	len += formatex(menu[len], charsmax(menu) - len, "^n\r0.\w Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "Binds Menu")
}
public menu_binds(id, key)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	if(key == 9) show_menu_interfaz(id)
	else if(key == 8)
	{
		if(MENU_PAGE_BINDS) show_menu_binds(id, 0)
		else show_menu_binds(id, 1)
	}
	
	return PLUGIN_HANDLED;
}


/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ ESTADÍSTICAS ]
=======================================================================================*/
show_menu_stats(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menuid, buffer[2][32], buffer_finish[256]
	
	// Title
	menuid = menu_create("\yESTADÍSTICAS", "menu_stats")
	
	menu_additem(menuid, "Niveles^n", "1")
	
	menu_additem(menuid, "Tops", "2")
	menu_additem(menuid, "Estadísticas generales^n", "3"
	)
	menu_additem(menuid, "Cabezas de Zombie", "4")
	
	buffer[0][0] = EOS;
	buffer[1][0] = EOS;
	buffer_finish[0] = EOS;
	
	if(g_time_playing[id][DAYS] >= 1) formatex(buffer[0], 31, "\y%d\w día%s", g_time_playing[id][DAYS], (g_time_playing[id][DAYS] != 1) ? "s" : "")
	if(g_time_playing[id][HOURS] >= 1) formatex(buffer[1], 31, "\y%d\w hora%s", g_time_playing[id][HOURS], (g_time_playing[id][HOURS] != 1) ? "s" : "")
	
	format(buffer_finish, 255, "^n\yTIEMPO JUGADO:^n\w%s%s%s", buffer[0], (buffer[0][0] && buffer[1][0]) ? " con " : "", buffer[1])
	
	if(buffer[0][0] || buffer[1][0])
		menu_addtext(menuid, buffer_finish)
	else menu_addtext(menuid, "^n\yTIEMPO JUGADO:\r NADA")
	
	// Exit
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid)
}
public menu_stats(id, menuid, item)
{
	// Player disconnected?
	if(!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_game(id)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve item id
	static buffer[2], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch(str_to_num(buffer[0]))
	{
		case 1: show_menu_new_lvls(id)
		case 2: show_menu_tops(id)
		case 3: show_menu_stats_general(id)
		case 4: show_menu_headz(id)
	}
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}
show_menu_tops(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[300], len
	len = 0
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\yTOPS^n^n\r1. \wGeneral^n\r2. \wMuertes siendo humano^n\r3. \wMuertes siendo zombie^n\r4. \wHeadshots^n\
	\r5. \wInfecciones^n\r6. \wCombo^n\r7. \wDaño^n\r8. \wTiempo jugado^n\r9. \wLogros^n^n\rNOTA:\w Si quieres ver los tops completos ingresa en:^n\yhttp://www.taringacs.net/servidores/27025/tops/^n^n\r0. \wVolver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "Tops Menu")
}
public menu_tops(id, key)
{
	// Player disconnected?
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	static name_top[32], top_url[300]
	
	switch(key)
	{
		case 0:
		{
			formatex(name_top, charsmax(name_top), "Top 15 - General")																						 
			formatex(top_url, charsmax(top_url), "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.taringacs.net/servidores/27025/top15.php^"></head><body><p>Cargando...</p></body></html>")
		}
		case 1:
		{
			formatex(name_top, charsmax(name_top), "Top 15 - Muertes siendo humano")																						 
			formatex(top_url, charsmax(top_url), "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.taringacs.net/servidores/27025/top15_muertesh.php^"></head><body><p>Cargando...</p></body></html>")
		}
		case 2: 
		{
			formatex(name_top, charsmax(name_top), "Top 15 - Muertes siendo zombie")																						 
			formatex(top_url, charsmax(top_url), "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.taringacs.net/servidores/27025/top15_muertesz.php^"></head><body><p>Cargando...</p></body></html>")
		}
		case 3: 
		{
			formatex(name_top, charsmax(name_top), "Top 15 - Headshots")
			formatex(top_url, charsmax(top_url), "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.taringacs.net/servidores/27025/top15_headshot.php^"></head><body><p>Cargando...</p></body></html>")
		}
		case 4: 
		{
			formatex(name_top, charsmax(name_top), "Top 15 - Infecciones")
			formatex(top_url, charsmax(top_url), "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.taringacs.net/servidores/27025/top15_infeccion.php^"></head><body><p>Cargando...</p></body></html>")
		}
		case 5: 
		{
			formatex(name_top, charsmax(name_top), "Top 15 - Combo")																						 
			formatex(top_url, charsmax(top_url), "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.taringacs.net/servidores/27025/top15_combo.php^"></head><body><p>Cargando...</p></body></html>")
		}
		case 6:
		{
			formatex(name_top, charsmax(name_top), "Top 15 - Daño")																						 
			formatex(top_url, charsmax(top_url), "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.taringacs.net/servidores/27025/top15_danio.php^"></head><body><p>Cargando...</p></body></html>")
		}
		case 7:
		{
			formatex(name_top, charsmax(name_top), "Top 15 - Tiempo Jugado")																				 
			formatex(top_url, charsmax(top_url), "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.taringacs.net/servidores/27025/top15_tiempo.php^"></head><body><p>Cargando...</p></body></html>")
		}
		case 8:
		{
			formatex(name_top, charsmax(name_top), "Top 15 - Logros")																				 
			formatex(top_url, charsmax(top_url), "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.taringacs.net/servidores/27025/top15_logros.php^"></head><body><p>Cargando...</p></body></html>")
		}
		case 9:
		{
			show_menu_stats(id)
			return PLUGIN_HANDLED;
		}
		default:
		{
			show_menu_tops(id)
			return PLUGIN_HANDLED;
		}
	}
	
	show_motd(id, top_url, name_top)
	
	show_menu_tops(id)
	
	return PLUGIN_HANDLED;
}
show_menu_new_lvls(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menuid, buffer[128];
	
	// Title
	menuid = menu_create("\yNIVELES", "menu_new_lvls")
	
	menu_additem(menuid, "Lista de niveles", "1")
	menu_additem(menuid, "Subir de rango^n", "2")
	
	if(g_level[id] != 560) formatex(buffer, charsmax(buffer), "\wTe faltan \y%d nivel%s\w para llegar al 560", (560 - g_level[id]), ((560 - g_level[id]) != 1) ? "es" : "")
	else formatex(buffer, charsmax(buffer), "\wEstás en el nivel máximo")
	
	menu_addtext(menuid, buffer)
	
	if(g_level[id] != 560)
	{
		static bf3[15]
		add_dot((MAX_XP - g_exp[id]), bf3, 14)
		formatex(buffer, charsmax(buffer), "\wTe faltan \y%s de XP\w para llegar al nivel 560", bf3)
		menu_addtext(menuid, buffer)
	}
	
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid)
}
public menu_new_lvls(id, menuid, item)
{
	// Player disconnected?
	if(!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_stats(id)
		return PLUGIN_HANDLED;
	}
	
	static buffer[2], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch(str_to_num(buffer[0]))
	{
		case 1: show_menu_list_lvls(id);
		case 2:
		{
			if(g_range[id] >= 26)
			{
				CC(id, "!g[ZP]!y Eres rango A y no podes subir más")
			
				menu_destroy(menuid)
				show_menu_stats(id)
				
				return PLUGIN_HANDLED;
			}
			
			show_menu_range(id)
		}
	}
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}
show_menu_list_lvls(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menuid, buffer_lvl[64], buffer_req[25], buffer_item[2], lvl
	
	// Title
	menuid = menu_create("\yLISTA DE NIVELES\R", "menu_list_lvls")
	
	for(lvl = 0; lvl < MAX_LVL; lvl++)
	{
		add_dot((XPNeeded[lvl] * MULT_PER_RANGE), buffer_req, 24)
		formatex(buffer_lvl, 31, "%sNivel %d: %s%s XP", (g_level[id] > lvl) ? "\w" : "\d", lvl+1, (g_level[id] > lvl) ? "\y" : "\r", buffer_req)
		
		buffer_item[0] = lvl
		buffer_item[1] = 0
		menu_additem(menuid, buffer_lvl, buffer_item)
	}
	
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_BACKNAME, "Atrás")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	MENU_PAGE_LIST_LVLS = min(MENU_PAGE_LIST_LVLS, menu_pages(menuid)-1)
	if(MENU_PAGE_LIST_LVLS == 0) MENU_PAGE_LIST_LVLS = g_level[id] / 7
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid, MENU_PAGE_LIST_LVLS)
}
public menu_list_lvls(id, menuid, item)
{
	// Player disconnected?
	if(!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Remember player's menu page
	static menudummy
	player_menu_info(id, menudummy, menudummy, MENU_PAGE_LIST_LVLS)
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_new_lvls(id)
		return PLUGIN_HANDLED;
	}
	
	menu_destroy(menuid)
	show_menu_list_lvls(id)
	return PLUGIN_HANDLED;
}
show_menu_range(id)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[500], len, buffer[21], range, accepted[8]
	len = 0
	range = g_range[id]
	accepted = {0, 0, 0, 0, 0, 0, 0, 0}
	
	if(g_level[id] == MAX_LVL &&
	(g_stats[id][INFECTS][DONE] >= (g_range_req[0] * (range+1))) &&
	(g_stats[id][KILLS_ZOMBIES][DONE] >= (g_range_req[1] * (range+1))) &&
	(g_ammopacks[id] >= (g_range_req[2] * (range+1))) && 
	(g_points[id][HAB_HUMAN] >= (g_range_req[3] + (5 * range))) &&
	(g_points[id][HAB_ZOMBIE] >= (g_range_req[4] + (5 * range))) &&
	(g_stats[id][HEADSHOTS][DONE] >= (g_range_req[5] * (range+1))))
		accepted[7] = 1;
	
	if(g_level[id] == MAX_LVL) accepted[0] = 1;
	if(g_stats[id][INFECTS][DONE] >= (g_range_req[0] * (range+1))) accepted[1] = 1;
	if(g_stats[id][KILLS_ZOMBIES][DONE] >= (g_range_req[1] * (range+1))) accepted[2] = 1;
	if(g_ammopacks[id] >= (g_range_req[2] * (range+1))) accepted[3] = 1;
	if(g_points[id][HAB_HUMAN] >= (g_range_req[3] + (5 * range))) accepted[4] = 1;
	if(g_points[id][HAB_ZOMBIE] >= (g_range_req[4] + (5 * range))) accepted[5] = 1;
	if(g_stats[id][HEADSHOTS][DONE] >= (g_range_req[5] * (range+1))) accepted[6] = 1;
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\ySUBIR DE RANGO^n")
	len += formatex(menu[len], charsmax(menu) - len, "%s%s^n^n", (accepted[7]) ? "\r1. \wSubir al rango \y" :
	"\r1. \dNo podes subir al rango \r", g_range_letters[g_range[id]+1])
	
	len += formatex(menu[len], charsmax(menu) - len, "\yREQUISITOS:^n")
	len += formatex(menu[len], charsmax(menu) - len, "\r- %sNivel 560^n", (accepted[0]) ? "\w" : "\d")
	add_dot((g_range_req[0] * (range+1)), buffer, 20)
	len += formatex(menu[len], charsmax(menu) - len, "\r- %s%s humanos infectados^n", (accepted[1]) ? "\w" : "\d", buffer)
	add_dot((g_range_req[1] * (range+1)), buffer, 20)
	len += formatex(menu[len], charsmax(menu) - len, "\r- %s%s zombies matados^n", (accepted[2]) ? "\w" : "\d", buffer)
	add_dot((g_range_req[2] * (range+1)), buffer, 20)
	len += formatex(menu[len], charsmax(menu) - len, "\r- %s%s ammo packs^n", (accepted[3]) ? "\w" : "\d", buffer)
	len += formatex(menu[len], charsmax(menu) - len, "\r- %s%d puntos humanos^n", (accepted[4]) ? "\w" : "\d", (g_range_req[3] + (5 * range)))
	len += formatex(menu[len], charsmax(menu) - len, "\r- %s%d puntos zombies^n", (accepted[5]) ? "\w" : "\d", (g_range_req[4] + (5 * range)))
	add_dot((g_range_req[5] * (range+1)), buffer, 20)
	len += formatex(menu[len], charsmax(menu) - len, "\r- %s%s disparos en la cabeza", (accepted[6]) ? "\w" : "\d", buffer)
	
	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r0.\w Atrás")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "Menu Range")
}
public menu_range(id, key)
{
	// Player disconnected?
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(key == 0)
	{
		static accepted, range;
		accepted = 0;
		range = g_range[id];
		
		if(g_level[id] == MAX_LVL &&
		(g_stats[id][INFECTS][DONE] >= (g_range_req[0] * (range+1))) &&
		(g_stats[id][KILLS_ZOMBIES][DONE] >= (g_range_req[1] * (range+1))) &&
		(g_ammopacks[id] >= (g_range_req[2] * (range+1))) && 
		(g_points[id][HAB_HUMAN] >= (g_range_req[3] + (5 * range))) &&
		(g_points[id][HAB_ZOMBIE] >= (g_range_req[4] + (5 * range))) &&
		(g_stats[id][HEADSHOTS][DONE] >= (g_range_req[5] * (range+1))))
			accepted = 1;
		
		if(!accepted)
		{
			client_print(id, print_center, "No podes subir de rango! Algún requisito no está cumplido")
			
			show_menu_range(id)
			return PLUGIN_HANDLED;
		}
		
		g_ammopacks[id] -= (g_range_req[2] * (range+1))
		g_points[id][HAB_HUMAN] -= (g_range_req[3] + (5 * range))
		g_points[id][HAB_ZOMBIE] -= (g_range_req[4] + (5 * range))
		g_exp[id] = 0;
		g_level[id] = 1;
		
		g_range[id]++;
		
		if(g_range[id] == 1)
		{
			fn_give_hat(id, HAT_YODA)
			fn_update_logro(id, LOGRO_OTHERS, LA_PRIMERA_VEZ)
		}
		else if(g_range[id] == 4) fn_update_logro(id, LOGRO_OTHERS, V_FOR_VENDETTA)
		
		CC(0, "!g[ZP]!y Felicitaciones !g%s!y. Ha subido al !grango %s!y", g_playername[id], g_range_letters[g_range[id]])
	}
	else if(key == 9)
	{
		show_menu_new_lvls(id)
		return PLUGIN_HANDLED;
	}
	
	show_menu_range(id)
	return PLUGIN_HANDLED;
}
show_menu_stats_general(id)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menu[600], len, buffer[21]
	len = 0
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\yESTADÍSTICAS GENERALES^n^n")
	
	if(!MENU_STATS_PAGE)
	{
		add_dot(g_stats[id][DAMAGE][DONE], buffer, 20)
		len += formatex(menu[len], charsmax(menu) - len, "\wDaño hecho: \y%s^n", buffer)
		add_dot(g_stats[id][DAMAGE][TAKEN], buffer, 20)
		len += formatex(menu[len], charsmax(menu) - len, "\wDaño recibido: \y%s^n", buffer)
		add_dot(g_stats[id][HEADSHOTS][DONE], buffer, 20)
		len += formatex(menu[len], charsmax(menu) - len, "\wDisparos en la cabeza: \y%s^n", buffer)
		add_dot(g_stats[id][HEADSHOTS][TAKEN], buffer, 20)
		len += formatex(menu[len], charsmax(menu) - len, "\wDisparos en la cabeza recibidos: \y%s^n", buffer)
		add_dot(g_stats[id][KILLS_ZOMBIES][DONE], buffer, 20)
		len += formatex(menu[len], charsmax(menu) - len, "\wZombies matados: \y%s^n", buffer)
		add_dot(g_stats[id][KILLS_ZOMBIES][TAKEN], buffer, 20)
		len += formatex(menu[len], charsmax(menu) - len, "\wVeces muerto como zombie: \y%s^n", buffer)
		add_dot(g_stats[id][KILLS_HUMANS][DONE], buffer, 20)
		len += formatex(menu[len], charsmax(menu) - len, "\wHumanos Matados: \y%s^n", buffer)
		add_dot(g_stats[id][KILLS_HUMANS][TAKEN], buffer, 20)
		len += formatex(menu[len], charsmax(menu) - len, "\wVeces muerto como humano: \y%s^n", buffer)
		add_dot(g_stats[id][INFECTS][DONE], buffer, 20)
		len += formatex(menu[len], charsmax(menu) - len, "\wInfecciones hechas: \y%s^n", buffer)
		add_dot(g_stats[id][INFECTS][TAKEN], buffer, 20)
		len += formatex(menu[len], charsmax(menu) - len, "\wInfecciones recibidas: \y%s^n", buffer)
	}
	else
	{
		add_dot(g_stats[id][COMBO_MAX][DONE], buffer, 20)
		len += formatex(menu[len], charsmax(menu) - len, "\wCombo más grande: \y%s^n", buffer)
		add_dot(g_stats[id][KILLS_NEMESIS][DONE], buffer, 20)
		len += formatex(menu[len], charsmax(menu) - len, "\wNemesis matados: \y%s^n", buffer)
		add_dot(g_stats[id][KILLS_SURVIVOR][DONE], buffer, 20)
		len += formatex(menu[len], charsmax(menu) - len, "\wSurvivors matados: \y%s^n", buffer)
		len += formatex(menu[len], charsmax(menu) - len, "\wWesker matados: \y%d^n", g_stats[id][KILLS_WESKER][DONE])
		len += formatex(menu[len], charsmax(menu) - len, "\wTribales matados: \y%d^n", g_stats[id][KILLS_TRIBAL][DONE])
		len += formatex(menu[len], charsmax(menu) - len, "\wAliens matados: \y%d^n", g_stats[id][KILLS_ALIEN][DONE])
		len += formatex(menu[len], charsmax(menu) - len, "\wDepredadores matados: \y%d^n", g_stats[id][KILLS_PREDATOR][DONE])
		len += formatex(menu[len], charsmax(menu) - len, "\wAniquiladores matados: \y%d^n", g_stats[id][KILLS_ANNIHILATOR][DONE])
		len += formatex(menu[len], charsmax(menu) - len, "\wSniper matados: \y%d^n", g_stats[id][KILLS_SNIPER][DONE])
		add_dot(g_stats[id][KILLS_ZOMBIES_HEAD][DONE], buffer, 20)
		len += formatex(menu[len], charsmax(menu) - len, "\wZombies matados de headshot: \y%s^n", buffer)
	}
	
	len += formatex(menu[len], charsmax(menu) - len, "^n\r9.\w %s", MENU_STATS_PAGE ? "Atrás" : "Siguiente")
	len += formatex(menu[len], charsmax(menu) - len, "^n\r0.\w Atrás")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "Menu Stats")
}
public menu_stats_general(id, key)
{
	// Player disconnected?
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(key == 8) MENU_STATS_PAGE = !MENU_STATS_PAGE;
	else if(key == 9)
	{
		show_menu_stats(id)
		return PLUGIN_HANDLED;
	}
	
	show_menu_stats_general(id)
	return PLUGIN_HANDLED;
}


/*======= Z O M B I E   P L A G U E ===================================================
================================ K I S K E ============================================
============================================= T A R I N G A ===========================
	[ MySQL ]
=======================================================================================*/
// SQL - 6
public saveKK(id)
{
	if(!is_user_connected(id) || !g_logged[id])
		return PLUGIN_HANDLED;
	
	new ip[21], data[50], b[11], pito[128]
	static sql_parts[2][1024]
	get_user_ip(id, ip, 20, 1)
	
	data[0] = g_hab[id][HAB_HUMAN][0]
	data[1] = g_hab[id][HAB_HUMAN][1]
	data[2] = g_hab[id][HAB_HUMAN][2]
	data[3] = g_hab[id][HAB_HUMAN][3]
	data[4] = g_hab[id][HAB_HUMAN][4]
	data[5] = g_hab[id][HAB_HUMAN][5]
	data[6] = g_hab[id][HAB_ZOMBIE][0]
	data[7] = g_hab[id][HAB_ZOMBIE][1]
	data[8] = g_hab[id][HAB_ZOMBIE][2]
	data[9] = g_hab[id][HAB_ZOMBIE][3]
	data[10] = g_hab[id][HAB_ZOMBIE][4]
	data[11] = g_hab[id][HAB_ZOMBIE][5]
	data[12] = g_hab[id][HAB_SURV][0]
	data[13] = g_hab[id][HAB_SURV][1]
	data[14] = g_hab[id][HAB_SURV][2]
	data[15] = g_hab[id][HAB_SURV][3]
	data[16] = g_hab[id][HAB_SURV][4]
	data[17] = g_hab[id][HAB_NEM][0]
	data[18] = g_hab[id][HAB_NEM][1]
	data[19] = g_hab[id][HAB_NEM][2]
	data[20] = g_hab[id][HAB_NEM][3]
	data[21] = g_hab[id][HAB_OTHER][0]
	data[22] = g_rn[id][RING][RING_COST_ITEM_EXTRA]
	data[23] = g_rn[id][RING][RING_XP_MULT]
	data[24] = g_rn[id][RING][RING_APS_MULT]
	data[25] = g_rn_equip[id][RING][RING_COST_ITEM_EXTRA]
	data[26] = g_rn_equip[id][RING][RING_XP_MULT]
	data[27] = g_rn_equip[id][RING][RING_APS_MULT]
	data[28] = g_rn[id][NECK][NECK_FIRE]
	data[29] = g_rn[id][NECK][NECK_FROST]
	data[30] = g_rn[id][NECK][NECK_DAMAGE]
	data[31] = g_rn_equip[id][NECK][NECK_FIRE]
	data[32] = g_rn_equip[id][NECK][NECK_FROST]
	data[33] = g_rn_equip[id][NECK][NECK_DAMAGE]
	data[34] = g_hab[id][HAB_HUMAN][6]
	data[35] = g_hab[id][HAB_OTHER][1]
	data[36] = g_hab[id][HAB_OTHER][2]
	data[37] = g_stats[id][KILLS_SURVIVOR][DONE]
	data[38] = g_stats[id][KILLS_NEMESIS][DONE]
	data[39] = g_stats[id][KILLS_ANNIHILATOR][DONE]
	data[40] = g_stats[id][KILLS_WESKER][DONE]
	data[41] = g_stats[id][KILLS_TRIBAL][DONE]
	data[42] = g_stats[id][KILLS_ALIEN][DONE]
	data[43] = g_stats[id][KILLS_PREDATOR][DONE]
	data[44] = g_stats[id][KILLS_SNIPER][DONE]
	data[45] = g_stats[id][KILLS_ZOMBIES_HEAD][DONE]
	data[46] = g_artefactos_equipados[id][0]
	data[47] = g_artefactos_equipados[id][1]
	data[48] = g_artefactos_equipados[id][2]
	data[49] = g_artefactos_equipados[id][3]
	
	
	b[0] = g_stats[id][DAMAGE][DONE]
	b[1] = g_stats[id][HEADSHOTS][DONE]
	b[2] = g_stats[id][KILLS_ZOMBIES][DONE]
	b[3] = g_stats[id][KILLS_HUMANS][DONE]
	b[4] = g_stats[id][INFECTS][DONE]
	b[5] = g_stats[id][COMBO_MAX][DONE]
	b[6] = g_stats[id][DAMAGE][TAKEN]
	b[7] = g_stats[id][HEADSHOTS][TAKEN]
	b[8] = g_stats[id][KILLS_ZOMBIES][TAKEN]
	b[9] = g_stats[id][KILLS_HUMANS][TAKEN]
	b[10] = g_stats[id][INFECTS][TAKEN]
	
	static a[9][250];
	
	formatex(a[0], charsmax(a[]), "%d %d %d %d", g_box[id][box_red], g_box[id][box_green], g_box[id][box_blue], g_box[id][box_yellow])
	formatex(a[1], charsmax(a[]), "%d %d %d %d %d %d", data[22], data[23], data[24], data[25], data[26], data[27])
	formatex(a[2], charsmax(a[]), "%d %d %d %d %d %d", data[28], data[29], data[30], data[31], data[32], data[33])
	formatex(a[3], charsmax(a[]), "%d %d %d %d %d", g_head_zombie[id][box_red], g_head_zombie[id][box_green], g_head_zombie[id][box_blue], g_head_zombie[id][box_yellow], g_head_zombie[id][box_white])
	formatex(a[4], charsmax(a[]), "%d %d %d %d", g_points[id][HAB_HUMAN],	g_points[id][HAB_ZOMBIE], g_points_lose[id][HAB_HUMAN], g_points_lose[id][HAB_ZOMBIE])
	formatex(a[5], charsmax(a[]), "%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d", data[0], data[1], data[2], data[3], data[4], data[5], data[34], data[6], data[7], data[8], data[9], data[10], data[11], data[12], data[13], data[14], data[15], data[16], data[17],
	data[18], data[19], data[20], data[21], data[35], data[36])
	formatex(a[6], charsmax(a[]), "%d %d %d %d %d %d %d %d %d %d", g_color[id][COLOR_NVG][0], g_color[id][COLOR_NVG][1], g_color[id][COLOR_NVG][2], g_color[id][COLOR_HUD][0], g_color[id][COLOR_HUD][1], g_color[id][COLOR_HUD][2], g_hud_eff[id], g_hud_min[id], g_hud_abv[id], g_hud_off[id])
	formatex(a[7], charsmax(a[]), "%d %d %d %d", g_wpn_auto_on[id], g_menu_data[id][2], g_menu_data[id][4], g_menu_data[id][5])
	formatex(a[8], charsmax(a[]), "%d %d %d %d %d %d %d %d %d %d", g_color[id][COLOR_LIGHT][0], g_color[id][COLOR_LIGHT][1], g_color[id][COLOR_LIGHT][2], g_color[id][COLOR_BUBBLE][0], g_color[id][COLOR_BUBBLE][1], g_color[id][COLOR_BUBBLE][2], g_color[id][COLOR_HUD_COMBO][0],
	g_color[id][COLOR_HUD_COMBO][1], g_color[id][COLOR_HUD_COMBO][2], g_hud_combo_dmg_total[id])
	
	formatex(pito, 127, "%d %d %d %d", data[46], data[47], data[48], data[49])
	
	//
	formatex(sql_parts[1], charsmax(sql_parts[]), "tmin='%d',dmg_done='%d',head_done='%d',kill_z_done='%d',kill_h_done='%d',inf_done='%d',combo_max='%d',dmg_tak='%d',head_tak='%d',kill_z_tak='%d',kill_h_tak='%d',inf_tak='%d',\
	inv='%d' WHERE `id`='%d';", g_time_playing[id][MINUTES], b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7], b[8], b[9], b[10], g_invis[id], g_zr_pj[id])
	
	new soad8c3[500];
	formatex(soad8c3, 499, "%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d", g_weap_leg[id], g_weap_leg_choose[id], g_leg_lvl[id], g_leg_lvl_vex[id], g_leg_z_kills[id], g_leg_hits[id], g_leg_dmg[id], g_leg_dmg_nem[id], g_leg_dmg_aniq[id], g_leg_heads[id], g_leg_habs[id][0], g_leg_habs[id][1],
	g_leg_habs[id][2], g_leg_habs[id][3], g_leg_habs[id][4])
	
	formatex(sql_parts[0], charsmax(sql_parts[]), "hud_pos_x='%f',hud_pos_y='%f',hud_pos_fix='%f',hudc_pos_x='%f',hudc_pos_y='%f',hudc_pos_fix='%f',last_connect=now(),leg='%s'", g_hud_pos[id][0], g_hud_pos[id][1], g_hud_pos[id][2],g_hud_combo_pos[id][0],
	g_hud_combo_pos[id][1], g_hud_combo_pos[id][2], soad8c3)
	
	//
	new Handle:sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE users SET ip='%s',aps='%d',xp='%d',lvl='%d',rng='%d',zc='%d',hc='%d',points='%s',habs='%s',nvghud='%s',wpn='%s',luzbh='%s',%s,%s",ip, g_ammopacks[id], g_exp[id], g_level[id], g_range[id], g_zombieclassnext[id],
	g_humanclassnext[id], a[4], a[5], a[6], a[7], a[8], sql_parts[0], sql_parts[1])
	if(!SQL_Execute(sql_consult))
	{
		new sql_error[512];
		SQL_QueryError(sql_consult, sql_error, 511);
		
		log_to_file("zr_sql.log", "- LOG:42 - %s", sql_error);
		if(is_user_valid_connected(id))
		{
			g_logged[id] = 0;
			server_cmd("kick #%d ^"Hubo un error al guardar tus datos. Intente mas tarde^"", get_user_userid(id))
		}
	}
	SQL_FreeHandle(sql_consult)
	
	new Handle:sql_consult2 = SQL_PrepareQuery(g_sql_connection, "UPDATE rewards SET kill_s_done='%d',kill_n_done='%d',kill_a_done='%d',kill_w='%d',kill_t='%d',kill_alien='%d',kill_pred='%d',kill_sniper='%d',\
	kill_z_head='%d',antidote='%d',furia_z='%d',pipe='%d',money='%d',money_loose='%d',bubble='%d',total='%d' WHERE `zp_id`='%d';", data[37], data[38], data[39], data[40], data[41], data[42], data[43], data[44], data[45],
	g_antidote_count[id], g_madness_count[id], g_pipe_count[id], g_money[id], g_money_lose[id], g_bubble_cost[id],
	g_logros_completed[id], g_zr_pj[id])
	if(!SQL_Execute(sql_consult2))
	{
		new sql_error[512];
		SQL_QueryError(sql_consult2, sql_error, 511);
		
		log_to_file("zr_sql.log", "- LOG:43 - %s", sql_error);
		if(is_user_valid_connected(id))
		{
			g_logged[id] = 0;
			server_cmd("kick #%d ^"Hubo un error al guardar tus datos. Intente mas tarde^"", get_user_userid(id))
		}
	}
	SQL_FreeHandle(sql_consult2)
	
	new eventSI[45];
	eventSI[0] = EOS;
	
#if defined EVENT_SEMANA_INFECCION
	formatex(eventSI, 44, ", maxi=%d, maxiir=%d, maxic=%d", maxInfects[id], maxInfectsInRound[id], maxInfectsCombo[id]);
#endif
	
	// 
	new Handle:sql_consult3 = SQL_PrepareQuery(g_sql_connection, "UPDATE events SET box='%s',hequip='%d',loves='%d',loves_rec='%d',lover='%d',candy_z='%d',kill_z_knife='%d',rings='%s',necks='%s',artef='%s',tp='%d',\
	headz='%s',tantime='%d',kill_ak='%d',kill_h_nem='%d',kill_z_surv='%d',kill_z_wes='%d'%s WHERE `zp_id`='%d';", a[0], g_hat_equip[id], g_love_count[id], g_love_count_rec[id], g_lover[id], g_candy[id][4],
	gl_kill_knife[id], a[1], a[2], pito, g_tp_load[id], a[3], gl_tantime[id], gl_kill_ak[id], gl_kill_h_nem[id], gl_kill_z_surv[id], gl_kill_z_wes[id],eventSI, g_zr_pj[id])
	if(!SQL_Execute(sql_consult3))
	{
		new sql_error[512];
		SQL_QueryError(sql_consult3, sql_error, 511);
		
		log_to_file("zr_sql.log", "- LOG:44 - %s", sql_error);
		if(is_user_valid_connected(id))
		{
			g_logged[id] = 0;
			server_cmd("kick #%d ^"Hubo un error al guardar tus datos. Intente mas tarde^"", get_user_userid(id))
		}
	}
	SQL_FreeHandle(sql_consult3)
	
	return PLUGIN_HANDLED;
}

/*public QueryHandle(iFailState, Handle:hQuery, szError[], iErrnum, cData[], iSize, Float:fQueueTime)
{
	if(iFailState != TQUERY_SUCCESS)
		log_to_file("error_sql_guardado", "SQL Error #%d - %s", iErrnum, szError);
	
	return PLUGIN_CONTINUE;
}*/

public load(id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	new Handle:sql_consult_private = SQL_PrepareQuery(g_sql_connection, "SELECT id, pass, ip FROM users WHERE name = ^"%s^";", g_playername[id])
	if(!SQL_Execute(sql_consult_private))
	{
		new sql_error[512];
		SQL_QueryError(sql_consult_private, sql_error, 511);
		
		log_to_file("zr_sql.log", "- LOG:16 - %s", sql_error);
		if(is_user_valid_connected(id))
			server_cmd("kick #%d ^"Hubo un error al cargar tus datos. Intente mas tarde^"", get_user_userid(id))
		
		SQL_FreeHandle(sql_consult_private)
	}
	else if(SQL_NumResults(sql_consult_private)) // Registrado
	{
		new sql_ip[21]
		new pass[32], ip[21]
		
		g_zr_pj[id] = SQL_ReadResult(sql_consult_private, 0)
		SQL_ReadResult(sql_consult_private, 1, g_password[id], 31)
		SQL_ReadResult(sql_consult_private, 2, sql_ip, 31)
		
		get_user_info(id, "zp4", pass, 31)
		get_user_ip(id, ip, 20, 1)
		
		g_register[id] = 1
		
		SQL_FreeHandle(sql_consult_private)
		
		sql_consult_private = SQL_PrepareQuery(g_sql_connection, "SELECT * FROM bans WHERE zp_id = %d;", g_zr_pj[id])
		if(!SQL_Execute(sql_consult_private))
		{
			new sql_error[512];
			SQL_QueryError(sql_consult_private, sql_error, 511);
			
			log_to_file("zr_sql.log", "- LOG:17 - %s", sql_error);
			if(is_user_valid_connected(id))
				server_cmd("kick #%d ^"Hubo un error al cargar tus datos. Intente mas tarde^"", get_user_userid(id))
			
			SQL_FreeHandle(sql_consult_private)
		}
		else if(SQL_NumResults(sql_consult_private)) // Baneado
		{
			SQL_ReadResult(sql_consult_private, 2, sql_name_admin, 31)
			SQL_ReadResult(sql_consult_private, 3, sql_baneado_el, 31)
			SQL_ReadResult(sql_consult_private, 4, sql_expira_el, 31)
			SQL_ReadResult(sql_consult_private, 5, sql_reason, 127)
			
			SQL_FreeHandle(sql_consult_private)
			
			new sDate[16];
			new sTime[16];
			new sYear[5];
			new sMonth[3];
			new sDay[3];
			new sHour[3];
			new sMin[3];
			new sSec[3];
			new iYear;
			new iMonth;
			new iDay;
			new iHour;
			new iMin;
			new iSec;
			new iActualTime;
			new iBannedTo;
			
			iActualTime = arg_time();
			
			parse(sql_expira_el, sDate, charsmax(sDate), sTime, charsmax(sTime));
			
			replace_all(sDate, charsmax(sDate), "-", " ");
			replace_all(sTime, charsmax(sTime), ":", " ");
			
			parse(sDate, sYear, 4, sMonth, 2, sDay, 2);
			parse(sTime, sHour, 2, sMin, 2, sSec, 2);
			
			iYear = str_to_num(sYear);
			iMonth = str_to_num(sMonth);
			iDay = str_to_num(sDay);
			iHour = str_to_num(sHour);
			iMin = str_to_num(sMin);
			iSec = str_to_num(sSec);
			
			iBannedTo = time_to_unix(iYear, iMonth, iDay, iHour, iMin, iSec);
			
			if(iActualTime < iBannedTo)
				g_ban[id] = 1;
			else
			{
				sql_consult_private = SQL_PrepareQuery(g_sql_connection, "DELETE FROM bans WHERE zp_id = %d;", g_zr_pj[id]);
				if(!SQL_Execute(sql_consult_private))
				{
					new sql_error[512];
					SQL_QueryError(sql_consult_private, sql_error, 511);
					
					log_to_file("zr_sql.log", "- LOG:45 - %s", sql_error);
					if(is_user_valid_connected(id))
						server_cmd("kick #%d ^"Hubo un error al cargar tus datos. Intente mas tarde^"", get_user_userid(id))
				}
				
				SQL_FreeHandle(sql_consult_private)
				
				CC(0, "!g[ZP]!y El jugador !g%s!y ya no está baneado y puede volver a jugar", g_playername[id]);
				CC(0, "!g[ZP]!y Razón por la que había sido baneado: !g%s!y", sql_reason);
			}
			
			clcmd_changeteam(id)
		}
		else
		{
			SQL_FreeHandle(sql_consult_private)
			if(equal(sql_ip, ip) && equal(g_password[id], pass)) // Logeado automáticamente
			{
				g_logged[id] = 1
				load_all(id)
				
				remove_task(id + TASK_SAVE1)
				
				set_task(random_float(300.0, 500.0), "saveTask1", id + TASK_SAVE1, _, _, "b");
			}
			else clcmd_changeteam(id)
		}
	}
	else
	{
		SQL_FreeHandle(sql_consult_private)
		clcmd_changeteam(id)
	}
	
	return PLUGIN_HANDLED;
}
public load_all(id)
{
	if(!is_user_connected(id) || !g_logged[id])
		return PLUGIN_HANDLED;
	
	new Handle:sql_consult = SQL_PrepareQuery(g_sql_connection, "SELECT * FROM users LEFT JOIN rewards on rewards.zp_id = %d WHERE `id`='%d';",
	g_zr_pj[id], g_zr_pj[id])
	
	if(!SQL_Execute(sql_consult))
	{
		new sql_error[512];
		SQL_QueryError(sql_consult, sql_error, 511);
		
		log_to_file("zr_sql.log", "- LOG:19 - %s", sql_error);
		if(is_user_valid_connected(id))
		{
			g_logged[id] = 0;
			server_cmd("kick #%d ^"Hubo un error al cargar tus datos. Intente mas tarde^"", get_user_userid(id))
		}
		
		SQL_FreeHandle(sql_consult)
	}
	else if(SQL_NumResults(sql_consult))
	{
		const mC = 11;
		
		static a[10][450];
		static b[15][12];
		static c[25][12];
		
		g_ammopacks[id] = SQL_ReadResult(sql_consult, 4)
		g_exp[id] = SQL_ReadResult(sql_consult, 5)
		g_level[id] = SQL_ReadResult(sql_consult, 6)
		g_range[id] = SQL_ReadResult(sql_consult, 7)
		
		g_zombieclass[id] = SQL_ReadResult(sql_consult, 8)
		g_zombieclassnext[id] = g_zombieclass[id]
		g_humanclass[id] = SQL_ReadResult(sql_consult, 9)
		g_humanclassnext[id] = g_humanclass[id]
		
		SQL_ReadResult(sql_consult, 10, a[0], charsmax(a[]))
		parse(a[0], b[0], mC, b[1], mC, b[2], mC, b[3], mC)
		
		g_points[id][HAB_HUMAN] = str_to_num(b[0])
		g_points[id][HAB_ZOMBIE] = str_to_num(b[1])
		g_points_lose[id][HAB_HUMAN] = str_to_num(b[2])
		g_points_lose[id][HAB_ZOMBIE] = str_to_num(b[3])
		
		SQL_ReadResult(sql_consult, 11, a[1], charsmax(a[]))
		parse(a[1], c[0], mC, c[1], mC, c[2], mC, c[3], mC, c[4], mC, c[5], mC, c[6], mC, c[7], mC, c[8], mC, c[9], mC, c[10], mC, c[11], mC, c[12], mC, c[13], mC, c[14], mC, c[15], mC, c[16], mC, c[17], mC, c[18], mC, c[19], mC, c[20], mC, c[21], mC, c[22], mC, c[23], mC, c[24], mC)
		
		g_hab[id][HAB_HUMAN][0] = str_to_num(c[0])
		g_hab[id][HAB_HUMAN][1] = str_to_num(c[1])
		g_hab[id][HAB_HUMAN][2] = str_to_num(c[2])
		g_hab[id][HAB_HUMAN][3] = str_to_num(c[3])
		g_hab[id][HAB_HUMAN][4] = str_to_num(c[4])
		g_hab[id][HAB_HUMAN][5] = str_to_num(c[5])
		g_hab[id][HAB_HUMAN][6] = str_to_num(c[6])
		
		g_hab[id][HAB_ZOMBIE][0] = str_to_num(c[7])
		g_hab[id][HAB_ZOMBIE][1] = str_to_num(c[8])
		g_hab[id][HAB_ZOMBIE][2] = str_to_num(c[9])
		g_hab[id][HAB_ZOMBIE][3] = str_to_num(c[10])
		g_hab[id][HAB_ZOMBIE][4] = str_to_num(c[11])
		g_hab[id][HAB_ZOMBIE][5] = str_to_num(c[12])
		
		g_hab[id][HAB_SURV][0] = str_to_num(c[13])
		g_hab[id][HAB_SURV][1] = str_to_num(c[14])
		g_hab[id][HAB_SURV][2] = str_to_num(c[15])
		g_hab[id][HAB_SURV][3] = str_to_num(c[16])
		g_hab[id][HAB_SURV][4] = str_to_num(c[17])
		
		g_hab[id][HAB_NEM][0] = str_to_num(c[18])
		g_hab[id][HAB_NEM][1] = str_to_num(c[19])
		g_hab[id][HAB_NEM][2] = str_to_num(c[20])
		g_hab[id][HAB_NEM][3] = str_to_num(c[21])
		
		g_hab[id][HAB_OTHER][0] = str_to_num(c[22])
		g_hab[id][HAB_OTHER][1] = str_to_num(c[23])
		g_hab[id][HAB_OTHER][2] = str_to_num(c[24])
		
		g_bet[id] = SQL_ReadResult(sql_consult, 12)
		g_bet_num[id] = SQL_ReadResult(sql_consult, 13)
		
		SQL_ReadResult(sql_consult, 14, a[2], charsmax(a[]))
		parse(a[2], b[0], mC, b[1], mC, b[2], mC, b[3], mC, b[4], mC, b[5], mC, b[6], mC, b[7], mC, b[8], mC, b[9], mC)
		
		g_color[id][COLOR_NVG][0] = str_to_num(b[0])
		g_color[id][COLOR_NVG][1] = str_to_num(b[1])
		g_color[id][COLOR_NVG][2] = str_to_num(b[2])
		g_color[id][COLOR_HUD][0] = str_to_num(b[3])
		g_color[id][COLOR_HUD][1] = str_to_num(b[4])
		g_color[id][COLOR_HUD][2] = str_to_num(b[5])
		
		g_hud_eff[id] = str_to_num(b[6])
		g_hud_min[id] = str_to_num(b[7])
		g_hud_abv[id] = str_to_num(b[8])
		g_hud_off[id] = str_to_num(b[9])
		
		SQL_ReadResult(sql_consult, 15, Float:g_hud_pos[id][0])
		SQL_ReadResult(sql_consult, 16, Float:g_hud_pos[id][1])
		SQL_ReadResult(sql_consult, 17, Float:g_hud_pos[id][2])
		
		SQL_ReadResult(sql_consult, 18, a[3], charsmax(a[]))
		parse(a[3], b[0], mC, b[1], mC, b[2], mC, b[3], mC)
		
		g_wpn_auto_on[id] = str_to_num(b[0])
		g_menu_data[id][2] = str_to_num(b[1])
		g_menu_data[id][4] = str_to_num(b[2])
		g_menu_data[id][5] = str_to_num(b[3])
		
		SQL_ReadResult(sql_consult, 19, a[4], charsmax(a[]))
		parse(a[4], b[0], mC, b[1], mC, b[2], mC, b[3], mC, b[4], mC, b[5], mC, b[6], mC, b[7], mC, b[8], mC, b[9], mC)
		
		g_color[id][COLOR_LIGHT][0] = str_to_num(b[0])
		g_color[id][COLOR_LIGHT][1] = str_to_num(b[1])
		g_color[id][COLOR_LIGHT][2] = str_to_num(b[2])
		g_color[id][COLOR_BUBBLE][0] = str_to_num(b[3])
		g_color[id][COLOR_BUBBLE][1] = str_to_num(b[4])
		g_color[id][COLOR_BUBBLE][2] = str_to_num(b[5])
		g_color[id][COLOR_HUD_COMBO][0] = str_to_num(b[6])
		g_color[id][COLOR_HUD_COMBO][1] = str_to_num(b[7])
		g_color[id][COLOR_HUD_COMBO][2] = str_to_num(b[8])
		g_hud_combo_dmg_total[id] = str_to_num(b[9])
		
		SQL_ReadResult(sql_consult, 20, Float:g_hud_combo_pos[id][0])
		SQL_ReadResult(sql_consult, 21, Float:g_hud_combo_pos[id][1])
		SQL_ReadResult(sql_consult, 22, Float:g_hud_combo_pos[id][2])
		
		g_time_playing[id][MINUTES] = SQL_ReadResult(sql_consult, 23)
		
		static iHour, iDay;
		
		iHour = 0;
		iDay = 0;
		
		iHour = g_time_playing[id][MINUTES] / 60;
		
		while(iHour >= 24)
		{
			iDay++;
			iHour -= 24;
		}
		
		g_time_playing[id][HOURS] = iHour;
		g_time_playing[id][DAYS] = iDay;
		
		g_stats[id][DAMAGE][DONE] = SQL_ReadResult(sql_consult, 24)
		g_stats[id][HEADSHOTS][DONE] = SQL_ReadResult(sql_consult, 25)
		g_stats[id][KILLS_ZOMBIES][DONE] = SQL_ReadResult(sql_consult, 26)
		g_stats[id][KILLS_HUMANS][DONE] = SQL_ReadResult(sql_consult, 27)
		g_stats[id][INFECTS][DONE] = SQL_ReadResult(sql_consult, 28)
		g_stats[id][COMBO_MAX][DONE] = SQL_ReadResult(sql_consult, 29)
		
		g_stats[id][DAMAGE][TAKEN] = SQL_ReadResult(sql_consult, 30)
		g_stats[id][HEADSHOTS][TAKEN] = SQL_ReadResult(sql_consult, 31)
		g_stats[id][KILLS_ZOMBIES][TAKEN] = SQL_ReadResult(sql_consult, 32)
		g_stats[id][KILLS_HUMANS][TAKEN] = SQL_ReadResult(sql_consult, 33)
		g_stats[id][INFECTS][TAKEN] = SQL_ReadResult(sql_consult, 34)
		
		g_invis[id] = SQL_ReadResult(sql_consult, 35)
		
		g_vinc[id] = SQL_ReadResult(sql_consult, 36)
		
		if(g_bet[id] >= 5000) g_bet_done[id] = 1;
		
		SQL_ReadResult(sql_consult, 40, a[4], charsmax(a[]))
		parse(a[4], b[0], mC, b[1], mC, b[2], mC, b[3], mC, b[4], mC, b[5], mC, b[6], mC, b[7], mC, b[8], mC, b[9], mC, b[10], mC, b[11], mC, b[12], mC, b[13], mC, b[14], mC)
		
		g_weap_leg[id] = str_to_num(b[0])
		g_weap_leg_choose[id] = str_to_num(b[1])
		g_leg_lvl[id] = str_to_num(b[2])
		g_leg_lvl_vex[id] = str_to_num(b[3])
		g_leg_z_kills[id] = str_to_num(b[4])
		g_leg_hits[id] = str_to_num(b[5])
		g_leg_dmg[id] = str_to_num(b[6])
		g_leg_dmg_nem[id] = str_to_num(b[7])
		g_leg_dmg_aniq[id] = str_to_num(b[8])
		g_leg_heads[id] = str_to_num(b[9])
		g_leg_habs[id][0] = str_to_num(b[10])
		g_leg_habs[id][1] = str_to_num(b[11])
		g_leg_habs[id][2] = str_to_num(b[12])
		g_leg_habs[id][3] = str_to_num(b[13])
		g_leg_habs[id][4] = str_to_num(b[14])
		
		// 41 = zp_id
		new i, j, camps = 42
		
		for(i = 0; i < MAX_CLASS; i++)
		{
			for(j = 0; j < MAX_LOGROS_CLASS[i]; j++)
			{
				g_logro[id][i][j] = SQL_ReadResult(sql_consult, camps)
				camps++
			}
		}
		
		g_stats[id][KILLS_SURVIVOR][DONE] = SQL_ReadResult(sql_consult, camps)
		g_stats[id][KILLS_NEMESIS][DONE] = SQL_ReadResult(sql_consult, camps+1)
		g_stats[id][KILLS_ANNIHILATOR][DONE] = SQL_ReadResult(sql_consult, camps+2)
		g_stats[id][KILLS_WESKER][DONE] = SQL_ReadResult(sql_consult, camps+3)
		g_stats[id][KILLS_TRIBAL][DONE] = SQL_ReadResult(sql_consult, camps+4)
		g_stats[id][KILLS_ALIEN][DONE] = SQL_ReadResult(sql_consult, camps+5)
		g_stats[id][KILLS_PREDATOR][DONE] = SQL_ReadResult(sql_consult, camps+6)
		g_stats[id][KILLS_SNIPER][DONE] = SQL_ReadResult(sql_consult, camps+7)
		g_stats[id][KILLS_ZOMBIES_HEAD][DONE] = SQL_ReadResult(sql_consult, camps+8)
		g_antidote_count[id] = SQL_ReadResult(sql_consult, camps+9)
		g_madness_count[id] = SQL_ReadResult(sql_consult, camps+10)
		g_pipe_count[id] = SQL_ReadResult(sql_consult, camps+11)
		g_money[id] = SQL_ReadResult(sql_consult, camps+12)
		g_money_lose[id] = SQL_ReadResult(sql_consult, camps+13)
		g_bubble_cost[id] = SQL_ReadResult(sql_consult, camps+14)
		g_logros_completed[id] = SQL_ReadResult(sql_consult, camps+15)
		
		if(SQL_ReadResult(sql_consult, 39)) // compro
		{
			SQL_FreeHandle(sql_consult)
			sql_consult = SQL_PrepareQuery(g_sql_connection, "SELECT * FROM compras WHERE `zp_id`='%d' AND entregado <> 1;", g_zr_pj[id])
			if(!SQL_Execute(sql_consult))
			{
				new sql_error[512];
				SQL_QueryError(sql_consult, sql_error, 511);
				
				log_to_file("zr_sql.log", "- LOG:61 - %s", sql_error);
				if(is_user_valid_connected(id))
				{
					g_logged[id] = 0;
					server_cmd("kick #%d ^"Hubo un error al cargar tus datos. Intente mas tarde^"", get_user_userid(id))
				}
				
				SQL_FreeHandle(sql_consult)
			}
			else
			{
				if(SQL_NumResults(sql_consult) == 1)
				{
					new pavore = SQL_ReadResult(sql_consult, 0)
					new eirg = SQL_ReadResult(sql_consult, 5)
					
					if(eirg == 0)
					{
						g_money[id] += SQL_ReadResult(sql_consult, 2)
						g_points[id][HAB_HUMAN] += SQL_ReadResult(sql_consult, 3)
						g_points[id][HAB_ZOMBIE] += SQL_ReadResult(sql_consult, 4)
						
						SQL_FreeHandle(sql_consult)
						sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE compras SET entregado='1' WHERE `id`='%d';", pavore) // DELETE FROM compras WHERE `id`='%d'
						if(!SQL_Execute(sql_consult))
						{
							new sql_error[512];
							SQL_QueryError(sql_consult, sql_error, 511);
							
							log_to_file("zr_sql.log", "- LOG:62 - %s", sql_error);
							if(is_user_valid_connected(id))
							{
								g_logged[id] = 0;
								server_cmd("kick #%d ^"Hubo un error al cargar tus datos. Intente mas tarde^"", get_user_userid(id))
							}
						}
						
						SQL_FreeHandle(sql_consult)
						sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE users SET compro='0' WHERE `id`='%d';", g_zr_pj[id])
						if(!SQL_Execute(sql_consult))
						{
							new sql_error[512];
							SQL_QueryError(sql_consult, sql_error, 511);
							
							log_to_file("zr_sql.log", "- LOG:63 - %s", sql_error);
							if(is_user_valid_connected(id))
							{
								g_logged[id] = 0;
								server_cmd("kick #%d ^"Hubo un error al cargar tus datos. Intente mas tarde^"", get_user_userid(id))
							}
						}
						
						SQL_FreeHandle(sql_consult)
						
						set_task(3.0, "fnkakakad", id);
					}
				}
				else
				{
					new eirg;
					while(SQL_MoreResults(sql_consult))
					{
						eirg = SQL_ReadResult(sql_consult, 5)
						
						if(eirg == 0)
						{
							g_money[id] += SQL_ReadResult(sql_consult, 2)
							g_points[id][HAB_HUMAN] += SQL_ReadResult(sql_consult, 3)
							g_points[id][HAB_ZOMBIE] += SQL_ReadResult(sql_consult, 4)
						}
						
						SQL_NextRow(sql_consult);
					}
					
					SQL_FreeHandle(sql_consult)
					sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE compras SET entregado='1' WHERE `zp_id`='%d';", g_zr_pj[id]) // DELETE FROM compras WHERE `zp_id`='%d'
					if(!SQL_Execute(sql_consult))
					{
						new sql_error[512];
						SQL_QueryError(sql_consult, sql_error, 511);
						
						log_to_file("zr_sql.log", "- LOG:64 - %s", sql_error);
						if(is_user_valid_connected(id))
						{
							g_logged[id] = 0;
							server_cmd("kick #%d ^"Hubo un error al cargar tus datos. Intente mas tarde^"", get_user_userid(id))
						}
					}
					
					SQL_FreeHandle(sql_consult)
					sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE users SET compro='0' WHERE `id`='%d';", g_zr_pj[id])
					if(!SQL_Execute(sql_consult))
					{
						new sql_error[512];
						SQL_QueryError(sql_consult, sql_error, 511);
						
						log_to_file("zr_sql.log", "- LOG:65 - %s", sql_error);
						if(is_user_valid_connected(id))
						{
							g_logged[id] = 0;
							server_cmd("kick #%d ^"Hubo un error al cargar tus datos. Intente mas tarde^"", get_user_userid(id))
						}
					}
					
					SQL_FreeHandle(sql_consult)
					
					set_task(3.0, "fnkakakad", id);
				}
			}
		}
		else SQL_FreeHandle(sql_consult)
		
		sql_consult = SQL_PrepareQuery(g_sql_connection, "SELECT sum(dinero) as pesos, sum(puntosh) as ph, sum(puntosz) as pz FROM `compras` WHERE `zp_id` = '%d' AND entregado = 1 GROUP BY zp_id;", g_zr_pj[id])
		if(!SQL_Execute(sql_consult))
		{
			new sql_error[512];
			SQL_QueryError(sql_consult, sql_error, 511);
			
			log_to_file("zr_sql.log", "- LOG:61 - %s", sql_error);
			if(is_user_valid_connected(id))
			{
				g_logged[id] = 0;
				server_cmd("kick #%d ^"Hubo un error al cargar tus datos. Intente mas tarde^"", get_user_userid(id))
			}
		}
		else if(SQL_NumResults(sql_consult))
		{
			g_plata_gastada[id] += (SQL_ReadResult(sql_consult, 0) / 2)
			g_plata_gastada[id] += SQL_ReadResult(sql_consult, 1)
			g_plata_gastada[id] += SQL_ReadResult(sql_consult, 2)
		}
		SQL_FreeHandle(sql_consult)
		
		sql_consult = SQL_PrepareQuery(g_sql_connection, "SELECT * FROM events WHERE `zp_id`='%d';", g_zr_pj[id])
		if(!SQL_Execute(sql_consult))
		{
			new sql_error[512];
			SQL_QueryError(sql_consult, sql_error, 511);
			
			log_to_file("zr_sql.log", "- LOG:20 - %s", sql_error);
			if(is_user_valid_connected(id))
			{
				g_logged[id] = 0;
				server_cmd("kick #%d ^"Hubo un error al cargar tus datos. Intente mas tarde^"", get_user_userid(id))
			}
			
			SQL_FreeHandle(sql_consult)
		}
		else if(SQL_NumResults(sql_consult))
		{
			SQL_ReadResult(sql_consult, 1, a[5], charsmax(a[]))
			parse(a[5], b[0], mC, b[1], mC, b[2], mC, b[3], mC)
		
			g_box[id][box_red] = str_to_num(b[0])
			g_box[id][box_green] = str_to_num(b[1])
			g_box[id][box_blue] = str_to_num(b[2])
			g_box[id][box_yellow] = str_to_num(b[3])
			g_hat[id][HAT_NAVID1] = SQL_ReadResult(sql_consult, 2)
			
			camps = 3
			
			for(i = 0; i < MAX_HATS; i++)
			{
				if(i == HAT_NAVID1) continue;
				
				g_hat[id][i] = SQL_ReadResult(sql_consult, camps)
				camps++
			}
			
			g_hat_equip[id] = SQL_ReadResult(sql_consult, camps)
			if(g_hat_equip[id] != -1)
			{
				HAT_ITEM_SET = g_hat_equip[id]
				HAT_ITEM = g_hat_equip[id]
				fn_set_hat(id, g_hat_mdl[HAT_ITEM])
			}
			
			SQL_ReadResult(sql_consult, camps+1, a[6], charsmax(a[]))
			parse(a[6], b[0], mC, b[1], mC, b[2], mC, b[3], mC, b[4], mC, b[5], mC)
			
			g_rn[id][RING][RING_COST_ITEM_EXTRA] = str_to_num(b[0])
			g_rn[id][RING][RING_XP_MULT] = str_to_num(b[1])
			g_rn[id][RING][RING_APS_MULT] = str_to_num(b[2])
			
			g_rn_equip[id][RING][RING_COST_ITEM_EXTRA] = str_to_num(b[3])
			g_rn_equip[id][RING][RING_XP_MULT] = str_to_num(b[4])
			g_rn_equip[id][RING][RING_APS_MULT] = str_to_num(b[5])
			
			SQL_ReadResult(sql_consult, camps+2, a[7], charsmax(a[]))
			parse(a[7], b[0], mC, b[1], mC, b[2], mC, b[3], mC, b[4], mC, b[5], mC)
			
			g_rn[id][NECK][NECK_FIRE] = str_to_num(b[0])
			g_rn[id][NECK][NECK_FROST] = str_to_num(b[1])
			g_rn[id][NECK][NECK_DAMAGE] = str_to_num(b[2])
			
			g_rn_equip[id][NECK][NECK_FIRE] = str_to_num(b[3])
			g_rn_equip[id][NECK][NECK_FROST] = str_to_num(b[4])
			g_rn_equip[id][NECK][NECK_DAMAGE] = str_to_num(b[5])
			
			SQL_ReadResult(sql_consult, camps+3, a[9], charsmax(a[]))
			parse(a[9], b[0], mC, b[1], mC, b[2], mC, b[3])
			
			g_artefactos_equipados[id][0] = str_to_num(b[0])
			g_artefactos_equipados[id][1] = str_to_num(b[1])
			g_artefactos_equipados[id][2] = str_to_num(b[2])
			g_artefactos_equipados[id][3] = str_to_num(b[3])
			
			if(g_artefactos_equipados[id][0])
				g_plata_gastada[id] -= 100;
			if(g_artefactos_equipados[id][1])
				g_plata_gastada[id] -= 150;
			if(g_artefactos_equipados[id][2])
				g_plata_gastada[id] -= 200;
			if(g_artefactos_equipados[id][3])
				g_plata_gastada[id] -= 100;
			
			g_tp_load[id] = SQL_ReadResult(sql_consult, camps+4)
			
			SQL_ReadResult(sql_consult, camps+5, a[8], charsmax(a[]))
			parse(a[8], b[0], mC, b[1], mC, b[2], mC, b[3], mC, b[4], mC)
			
			g_head_zombie[id][box_red] = str_to_num(b[0])
			g_head_zombie[id][box_green] = str_to_num(b[1])
			g_head_zombie[id][box_blue] = str_to_num(b[2])
			g_head_zombie[id][box_yellow] = str_to_num(b[3])
			g_head_zombie[id][box_white] = str_to_num(b[4])
			
			gl_tantime[id] = SQL_ReadResult(sql_consult, camps+6)
			
			g_love_count[id] = SQL_ReadResult(sql_consult, camps+7)
			g_love_count_rec[id] = SQL_ReadResult(sql_consult, camps+8)
			g_lover[id] = SQL_ReadResult(sql_consult, camps+9)
			g_candy[id][4] = SQL_ReadResult(sql_consult, camps+10)
			
			gl_kill_knife[id] = SQL_ReadResult(sql_consult, camps+11)
			
			gl_kill_ak[id] = SQL_ReadResult(sql_consult, camps+12)
			gl_kill_h_nem[id] = SQL_ReadResult(sql_consult, camps+13)
			gl_kill_z_surv[id] = SQL_ReadResult(sql_consult, camps+14)
			gl_kill_z_wes[id] = SQL_ReadResult(sql_consult, camps+15)
			
		#if defined EVENT_SEMANA_INFECCION
			maxInfects[id] = SQL_ReadResult(sql_consult, camps+16)
			maxInfectsInRound[id] = SQL_ReadResult(sql_consult, camps+17)
			maxInfectsCombo[id] = SQL_ReadResult(sql_consult, camps+18)
		#endif
			
			gl_progress[id][0] = (gl_kill_ak[id] * 100.0) / 150.0;
			gl_progress[id][1] = (g_stats[id][HEADSHOTS][DONE] * 100.0) / 500000.0;
			gl_progress[id][2] = (g_exp[id] * 100.0) / 10000000.0;
			gl_progress[id][3] = (gl_kill_h_nem[id] * 100.0) / 1000.0;
			gl_progress[id][4] = (gl_kill_z_surv[id] * 100.0) / 1000.0;
			gl_progress[id][5] = (gl_kill_z_wes[id] * 100.0) / 1000.0;
			gl_progress[id][6] = (float(g_logros_completed[id]) * 100.0) / 90.0;
			
			for(i = 0; i < 7; i++)
			{
				if(gl_progress[id][i] > 100.0)
					gl_progress[id][i] = 100.00;
			}
			
			SQL_FreeHandle(sql_consult)
			clcmd_changeteam(id)
		}
		else
		{
			if(is_user_valid_connected(id))
			{
				g_logged[id] = 0;
				server_cmd("kick #%d ^"Hubo un error al cargar tus datos. Intente mas tarde^"", get_user_userid(id))
			}
			
			SQL_FreeHandle(sql_consult)
		}
	}
	
	return PLUGIN_HANDLED;
}
public fnkakakad(id)
{
	if(!is_user_connected(id))
		return;
	
	CC(id, "!g[ZP]!y Su compra de recursos ha sido acreditada. Se lo reconectará para finalizar el proceso")
	
	set_task(6.0, "fnksdkc33", id)
}
public fnksdkc33(id)
{
	if(!is_user_connected(id))
		return;
	
	client_cmd(id, "retry");
}
public show_menu_ban(id)
{
	// Player disconnected?
	if (!is_user_connected(id))
		return;
	
	static menu[350], len
	len = 0
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\yBienvenido a %s %s^n^n\
	\rSU CUENTA ESTÁ BANEADA!^n\
	\wAdministrador que lo baneo: \y%s^n\
	\wFecha del baneo: \y%s^n\
	\wFecha en la que expira: \y%s^n\
	\wRazón: \y%s", g_sZombiePlagueName, g_sZombiePlagueVersion, sql_name_admin, sql_baneado_el, sql_expira_el, sql_reason)
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "Ban Menu")
}
public menu_ban(id, key)
{
	// Player disconnected?
	if (!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	show_menu_ban(id);
	
	return PLUGIN_HANDLED;
}
public show_menu_reglog(id)
{
	// Player disconnected?
	if (!is_user_connected(id))
		return;
	
	static menu[250], len
	len = 0
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\yBienvenido a %s %s^n^n\
	\r1.%s REGISTRARSE^n\
	\r2.%s IDENTIFICARSE", g_sZombiePlagueName, g_sZombiePlagueVersion, (g_register[id]) ? "\d" : "\w", (g_register[id]) ? "\w" : "\d")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "RegLog Menu")
}
public menu_reglog(id, key)
{
	// Player disconnected?
	if(!is_user_connected(id) || g_logged[id])
		return PLUGIN_HANDLED;
		
	switch (key)
	{
		case 0:
		{
			if(g_register[id])
			{
				client_print(id, print_center, "Este nombre de usuario ya está registrado")
				
				show_menu_reglog(id)
				return PLUGIN_HANDLED;
			}
			
			client_cmd(id, "messagemode create_password")
			client_print(id, print_center, "Escribe tu contraseña")
		}
		case 1:
		{
			if(!g_register[id])
			{
				client_print(id, print_center, "No podes identificarte con un nombre de usuario que no está registrado")
				
				show_menu_reglog(id)
				return PLUGIN_HANDLED;
			}
			
			client_cmd(id, "messagemode enter_password")
			client_print(id, print_center, "Escribe la contraseña que protege esta cuenta para identificarte")
		}
		default: show_menu_reglog(id)
	}
	
	return PLUGIN_HANDLED;
}
public clcmd_create_password(id)
{
	if(!is_user_connected(id) || g_register[id]) return PLUGIN_HANDLED;
	
	new password[191]
	
	read_args(password, 190)
	remove_quotes(password)
	trim(password)
	
	new len = strlen(password)
	new len_name = strlen(g_playername[id])
	
	if(len_name < 3)
	{
		client_print(id, print_center, "Tu nombre debe superar los 3 caracteres")
		
		//sub(id, g_data[BIT_CHANGE_NAME]);
		show_menu_reglog(id)
		
		return PLUGIN_HANDLED;
	}
	if(len < 4)
	{
		client_print(id, print_center, "La contraseña debe tener al menos 4 caracteres")
		
		show_menu_reglog(id)
		return PLUGIN_HANDLED;
	}
	else if(len > 31)
	{
		client_print(id, print_center, "La contraseña no puede superar los 31 caracteres")
		
		show_menu_reglog(id)
		return PLUGIN_HANDLED;
	}
	
	/*if(hub(id, g_data[BIT_CHANGE_NAME]))
		cub(id, g_data[BIT_CHANGE_NAME]);*/
	
	copy(g_password[id], charsmax(g_password[]), password)
	
	client_cmd(id, "messagemode repeat_password")
	client_print(id, print_center, "Escribe la contraseña nuevamente para su confirmación")
	
	return PLUGIN_HANDLED;
}
public clcmd_repeat_password(id)
{
	if(!is_user_connected(id) || g_register[id]) return PLUGIN_HANDLED;
	
	new password[191]
	
	read_args(password, 190)
	remove_quotes(password)
	trim(password)
	
	if(!equal(g_password[id], password))
	{
		g_password[id][0] = EOS
		client_print(id, print_center, "La contraseña no coincide con la anterior")
	
		show_menu_reglog(id)
		return PLUGIN_HANDLED;
	}
	
	g_register[id] = 1
	g_logged[id] = 1
	
	client_cmd(id, "chooseteam")
	
	new ip[21], md5_pass[34]
	get_user_ip(id, ip, 20, 1)
	md5(password, md5_pass)
	md5_pass[6] = EOS
	
	new Handle:sql_consult = SQL_PrepareQuery(g_sql_connection, "INSERT INTO users (`name`, `pass`, `ip`, `register`, `last_connect`) \
	VALUES (^"%s^", '%s', '%s', now(), now());", g_playername[id], md5_pass, ip)
	if(!SQL_Execute(sql_consult))
	{
		new sql_error[512];
		SQL_QueryError(sql_consult, sql_error, 511);
		
		log_to_file("zr_sql.log", "- LOG:21 - %s", sql_error);
		if(is_user_valid_connected(id))
			server_cmd("kick #%d ^"Hubo un error al guardar tus datos. Intente mas tarde^"", get_user_userid(id))
		
		SQL_FreeHandle(sql_consult)
	}
	else
	{
		SQL_FreeHandle(sql_consult)
		sql_consult = SQL_PrepareQuery(g_sql_connection, "SELECT id FROM users WHERE name=^"%s^";", g_playername[id])
		if(!SQL_Execute(sql_consult))
		{
			new sql_error[512];
			SQL_QueryError(sql_consult, sql_error, 511);
			
			log_to_file("zr_sql.log", "- LOG:22 - %s", sql_error);
			if(is_user_valid_connected(id))
				server_cmd("kick #%d ^"Hubo un error al guardar tus datos. Intente mas tarde^"", get_user_userid(id))
			
			SQL_FreeHandle(sql_consult)
			return PLUGIN_HANDLED;
		}
		else if(SQL_NumResults(sql_consult))
		{
			g_zr_pj[id] = SQL_ReadResult(sql_consult, 0);
			SQL_FreeHandle(sql_consult)
			
			sql_consult = SQL_PrepareQuery(g_sql_connection, "INSERT INTO rewards (`zp_id`) VALUES ('%d');", g_zr_pj[id])
			if(!SQL_Execute(sql_consult))
			{
				new sql_error[512];
				SQL_QueryError(sql_consult, sql_error, 511);
				
				log_to_file("zr_sql.log", "- LOG:23 - %s", sql_error);
				if(is_user_valid_connected(id))
					server_cmd("kick #%d ^"Hubo un error al guardar tus datos. Intente mas tarde^"", get_user_userid(id))
				
				SQL_FreeHandle(sql_consult)
				return PLUGIN_HANDLED;
			}
			else
			{
				SQL_FreeHandle(sql_consult)
				
				sql_consult = SQL_PrepareQuery(g_sql_connection, "INSERT INTO events (`zp_id`) VALUES ('%d');", g_zr_pj[id])
				if(!SQL_Execute(sql_consult))
				{
					new sql_error[512];
					SQL_QueryError(sql_consult, sql_error, 511);
					
					log_to_file("zr_sql.log", "- LOG:46 - %s", sql_error);
					if(is_user_valid_connected(id))
						server_cmd("kick #%d ^"Hubo un error al guardar tus datos. Intente mas tarde^"", get_user_userid(id))
					
					SQL_FreeHandle(sql_consult)
					return PLUGIN_HANDLED;
				}
				else
				{
					SQL_FreeHandle(sql_consult)
					
					new sRegCount[10];
					add_dot(g_zr_pj[id], sRegCount, 9);
					
					if(g_zr_pj[id] != 1000)
						CC(0, "!g[ZP]!y Bienvenido !g%s!y, eres la cuenta registrada número !g%s!y", g_playername[id], sRegCount);
					else
					{
						CC(0, "!g[ZP]!y Bienvenido !g%s!y, eres la cuenta registrada número !g1.000!y", g_playername[id]);
						CC(0, "!g[ZP]!y Todos los jugadores conectados ganaron !g5p. humanos !yy !gzombies!y")
						
						g_points[id][HAB_HUMAN] += 5;
						g_points[id][HAB_ZOMBIE] += 5;
						
						new i;
						for(i = 1; i <= g_maxplayers; i++)
						{
							if(hub(i, g_data[BIT_CONNECTED]) && g_logged[i])
							{
								g_points[i][HAB_HUMAN] += 5;
								g_points[i][HAB_ZOMBIE] += 5;
							}
						}
					}
				}
			}
		}
		else
		{
			SQL_FreeHandle(sql_consult)
			return PLUGIN_HANDLED;
		}
		
		g_register[id] = 1
		g_logged[id] = 1
		
		remove_task(id + TASK_SAVE1)
		
		set_task(random_float(300.0, 500.0), "saveTask1", id + TASK_SAVE1, _, _, "b");
		
		fn_reset_setinfo(id)
		client_cmd(id, "setinfo zp4 ^"%s^"", md5_pass)
		
		client_cmd(id, "chooseteam")
		
		client_print(id, print_center, "Se ha registrado exitosamente!")
	}
	
	return PLUGIN_HANDLED;
}
public clcmd_enter_password(id)
{
	if(!is_user_connected(id) || !g_register[id] || g_logged[id]) return PLUGIN_HANDLED;
	
	new password[191], md5_pass[34]
	
	read_args(password, 190)
	remove_quotes(password)
	trim(password)
	
	md5(password, md5_pass)
	md5_pass[6] = EOS
	
	if(!equal(g_password[id], md5_pass))
	{
		client_print(id, print_center, "La contraseña no coincide con la registrada")
		
		show_menu_reglog(id)
		return PLUGIN_HANDLED;
	}
	
	g_logged[id] = 1
	client_print(id, print_center, "Bienvenido a Taringa! CS, %s", g_playername[id])
	
	remove_task(id + TASK_SAVE1)
	
	set_task(random_float(300.0, 500.0), "saveTask1", id + TASK_SAVE1, _, _, "b");
	
	fn_reset_setinfo(id)
	client_cmd(id, "setinfo zp4 ^"%s^"", md5_pass)
	
	load_all(id)
	client_cmd(id, "chooseteam")
	
	return PLUGIN_HANDLED;
}

public saveTask1(taskid)
{
	saveKK(ID_SAVE1);
}

/*public QueryChecked(failstate, Handle:query, error[], errcode, data[], datasize)
{
	if(!check_error(data[0], "QueryChecked", failstate, errcode, error))
		return PLUGIN_CONTINUE;
	
	return PLUGIN_CONTINUE;
}*/

#if defined MAX_CLIP
public fw_Item_AttachToPlayer(iEnt, id)
{
	if(!pev_valid(iEnt))
		return;

	if(!g_hab[id][HAB_OTHER][OTHER_CINCO_BALAS])
		return;
	
	if(get_pdata_int(iEnt, m_fKnown, XTRA_OFS_WEAPON))
		return;
	
	if(!g_weap_leg_choose[id])
		set_pdata_int(iEnt, m_iClip, g_iDftMaxClip[get_pdata_int(iEnt, m_iId, XTRA_OFS_WEAPON)] + 10, XTRA_OFS_WEAPON)
	else
	{
		static balas_extras;
		balas_extras = (3 * g_leg_habs[id][3])
		
		set_pdata_int(iEnt, m_iClip, g_iDftMaxClip[get_pdata_int(iEnt, m_iId, XTRA_OFS_WEAPON)] + 10 + balas_extras, XTRA_OFS_WEAPON)
	}
}

public fw_Item_PostFrame(iEnt)
{
	if(!pev_valid(iEnt))
		return;
	
	static id ; id = get_pdata_cbase(iEnt, m_pPlayer, XTRA_OFS_WEAPON)
	
	if(!pev_valid(id))
		return;
	
	if(!g_hab[id][HAB_OTHER][OTHER_CINCO_BALAS])
		return;

	static iId ; iId = get_pdata_int(iEnt, m_iId, XTRA_OFS_WEAPON)
	static iMaxClip ; iMaxClip = g_iDftMaxClip[iId] + 10
	static fInReload ; fInReload = get_pdata_int(iEnt, m_fInReload, XTRA_OFS_WEAPON)
	static Float:flNextAttack ; flNextAttack = get_pdata_float(id, m_flNextAttack, XTRA_OFS_PLAYER)

	static iAmmoType ; iAmmoType = m_rgAmmo_player_Slot0 + get_pdata_int(iEnt, m_iPrimaryAmmoType, XTRA_OFS_WEAPON)
	static iBpAmmo ; iBpAmmo = get_pdata_int(id, iAmmoType, XTRA_OFS_PLAYER)
	static iClip ; iClip = get_pdata_int(iEnt, m_iClip, XTRA_OFS_WEAPON)

	if(g_weap_leg_choose[id])
	{
		static balas_extras;
		balas_extras = (3 * g_leg_habs[id][3])
		
		iMaxClip += balas_extras
	}
	
	if( fInReload && flNextAttack <= 0.0 )
	{
		new j = min(iMaxClip - iClip, iBpAmmo)
		set_pdata_int(iEnt, m_iClip, iClip + j, XTRA_OFS_WEAPON)
		set_pdata_int(id, iAmmoType, iBpAmmo-j, XTRA_OFS_PLAYER)
		
		set_pdata_int(iEnt, m_fInReload, 0, XTRA_OFS_WEAPON)
		fInReload = 0
	}

	static iButton ; iButton = entity_get_int(id, EV_INT_button)
	if(	(iButton & IN_ATTACK2 && get_pdata_float(iEnt, m_flNextSecondaryAttack, XTRA_OFS_WEAPON) <= 0.0)
	||	(iButton & IN_ATTACK && get_pdata_float(iEnt, m_flNextPrimaryAttack, XTRA_OFS_WEAPON) <= 0.0)	)
		return;

	if( iButton & IN_RELOAD && !fInReload )
	{
		if( iClip >= iMaxClip )
		{
			entity_set_int(id, EV_INT_button, iButton & ~IN_RELOAD)
			if( SILENT_BS & (1<<iId) && !get_pdata_int(iEnt, m_fSilent, XTRA_OFS_WEAPON) )
			{
				SendWeaponAnim( id, iId == CSW_USP ? 8 : 7 )
			}
			else
			{
				SendWeaponAnim(id, 0)
			}
		}
		else if( iClip == g_iDftMaxClip[iId] )
		{
			if( iBpAmmo )
			{
				set_pdata_float(id, m_flNextAttack, g_fDelay[iId], XTRA_OFS_PLAYER)

				if( SILENT_BS & (1<<iId) && get_pdata_int(iEnt, m_fSilent, XTRA_OFS_WEAPON) )
				{
					SendWeaponAnim( id, iId == CSW_USP ? 5 : 4 )
				}
				else
				{
					SendWeaponAnim(id, g_iReloadAnims[iId])
				}
				set_pdata_int(iEnt, m_fInReload, 1, XTRA_OFS_WEAPON)

				set_pdata_float(iEnt, m_flTimeWeaponIdle, g_fDelay[iId] + 0.5, XTRA_OFS_WEAPON)
			}
		}
	}
}

SendWeaponAnim(id, iAnim)
{	
	entity_set_int(id, EV_INT_weaponanim, iAnim)

	message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM, _, id)
	write_byte(iAnim)
	write_byte(entity_get_int(id,EV_INT_body))
	message_end()
}

public fw_Shotgun_WeaponIdle( iEnt )
{
	if(!pev_valid(iEnt))
		return;
	
	static id ; id = get_pdata_cbase(iEnt, m_pPlayer, XTRA_OFS_WEAPON)
	
	if(!g_hab[id][HAB_OTHER][OTHER_CINCO_BALAS])
		return;

	if( get_pdata_float(iEnt, m_flTimeWeaponIdle, XTRA_OFS_WEAPON) > 0.0 )
		return;

	static iId ; iId = get_pdata_int(iEnt, m_iId, XTRA_OFS_WEAPON)
	static iMaxClip ; iMaxClip = g_iDftMaxClip[iId] + 10

	static iClip ; iClip = get_pdata_int(iEnt, m_iClip, XTRA_OFS_WEAPON)
	static fInSpecialReload ; fInSpecialReload = get_pdata_int(iEnt, m_fInSpecialReload, XTRA_OFS_WEAPON)

	if( !iClip && !fInSpecialReload )
		return;

	if( fInSpecialReload )
	{
		static iBpAmmo ; iBpAmmo = get_pdata_int(id, 381, XTRA_OFS_PLAYER)
		static iDftMaxClip ; iDftMaxClip = g_iDftMaxClip[iId]

		if( iClip < iMaxClip && iClip == iDftMaxClip && iBpAmmo )
		{
			Shotgun_Reload(iEnt, iId, iMaxClip, iClip, iBpAmmo, id)
			return
		}
		else if( iClip == iMaxClip && iClip != iDftMaxClip )
		{
			SendWeaponAnim( id, after_reload )

			set_pdata_int(iEnt, m_fInSpecialReload, 0, XTRA_OFS_WEAPON)
			set_pdata_float(iEnt, m_flTimeWeaponIdle, 1.5, XTRA_OFS_WEAPON)
		}
	}
	return
}

public fw_Shotgun_PostFrame( iEnt )
{
	if(!pev_valid(iEnt))
		return;
	
	static id ; id = get_pdata_cbase(iEnt, m_pPlayer, XTRA_OFS_WEAPON)	

	if(!g_hab[id][HAB_OTHER][OTHER_CINCO_BALAS])
		return;
	
	static iBpAmmo ; iBpAmmo = get_pdata_int(id, 381, XTRA_OFS_PLAYER)
	static iClip ; iClip = get_pdata_int(iEnt, m_iClip, XTRA_OFS_WEAPON)
	static iId ; iId = get_pdata_int(iEnt, m_iId, XTRA_OFS_WEAPON)
	static iMaxClip ; iMaxClip = g_iDftMaxClip[iId] + 10
	
	if( get_pdata_int(iEnt, m_fInReload, XTRA_OFS_WEAPON) && get_pdata_float(id, m_flNextAttack, 5) <= 0.0 )
	{
		new j = min(iMaxClip - iClip, iBpAmmo)
		set_pdata_int(iEnt, m_iClip, iClip + j, XTRA_OFS_WEAPON)
		set_pdata_int(id, 381, iBpAmmo-j, XTRA_OFS_PLAYER)
		
		set_pdata_int(iEnt, m_fInReload, 0, XTRA_OFS_WEAPON)
		return
	}

	static iButton ; iButton = entity_get_int(id, EV_INT_button)
	if( iButton & IN_ATTACK && get_pdata_float(iEnt, m_flNextPrimaryAttack, XTRA_OFS_WEAPON) <= 0.0 )
	{
		return
	}

	if( iButton & IN_RELOAD  )
	{
		if( iClip >= iMaxClip )
		{
			entity_set_int(id, EV_INT_button, iButton & ~IN_RELOAD)
			set_pdata_float(iEnt, m_flNextPrimaryAttack, 0.5, XTRA_OFS_WEAPON)
		}

		else if( iClip == g_iDftMaxClip[iId] )
		{
			if( iBpAmmo )
			{
				Shotgun_Reload(iEnt, iId, iMaxClip, iClip, iBpAmmo, id)
			}
		}
	}
}

Shotgun_Reload(iEnt, iId, iMaxClip, iClip, iBpAmmo, id)
{
	if(!g_hab[id][HAB_OTHER][OTHER_CINCO_BALAS])
		return;

	if(iBpAmmo <= 0 || iClip == iMaxClip)
		return

	if(get_pdata_int(iEnt, m_flNextPrimaryAttack, XTRA_OFS_WEAPON) > 0.0)
		return

	switch( get_pdata_int(iEnt, m_fInSpecialReload, XTRA_OFS_WEAPON) )
	{
		case 0:
		{
			SendWeaponAnim( id , start_reload )
			set_pdata_int(iEnt, m_fInSpecialReload, 1, XTRA_OFS_WEAPON)
			set_pdata_float(id, m_flNextAttack, 0.55, 5)
			set_pdata_float(iEnt, m_flTimeWeaponIdle, 0.55, XTRA_OFS_WEAPON)
			set_pdata_float(iEnt, m_flNextPrimaryAttack, 0.55, XTRA_OFS_WEAPON)
			set_pdata_float(iEnt, m_flNextSecondaryAttack, 0.55, XTRA_OFS_WEAPON)
			return
		}
		case 1:
		{
			if( get_pdata_float(iEnt, m_flTimeWeaponIdle, XTRA_OFS_WEAPON) > 0.0 )
			{
				return
			}
			set_pdata_int(iEnt, m_fInSpecialReload, 2, XTRA_OFS_WEAPON)
			emit_sound(id, CHAN_ITEM, random_num(0,1) ? "weapons/reload1.wav" : "weapons/reload3.wav", 1.0, ATTN_NORM, 0, 85 + random_num(0,0x1f))
			SendWeaponAnim( id, insert )

			set_pdata_float(iEnt, m_flTimeWeaponIdle, iId == CSW_XM1014 ? 0.30 : 0.45, XTRA_OFS_WEAPON)
		}
		default:
		{
			set_pdata_int(iEnt, m_iClip, iClip + 1, XTRA_OFS_WEAPON)
			set_pdata_int(id, 381, iBpAmmo-1, XTRA_OFS_PLAYER)
			set_pdata_int(iEnt, m_fInSpecialReload, 1, XTRA_OFS_WEAPON)
		}
	}
}
#endif

public elegirTribales(id)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
		
	static menuid, menu[128], player, buffer[2]
	
	formatex(menu, charsmax(menu), "\yELEGIR TRIBAL \r[\y%s\r]", (g_tribal_pos == 2) ? "1" : (!g_tribal_pos) ? "1" : "2")
	menuid = menu_create(menu, "menu_elegir_tribales")
	
	// Player List
	for (player = 1; player <= g_maxplayers; player++)
	{
		// Skip if not connected
		if(!hub(player, g_data[BIT_CONNECTED]))
			continue;
		
		formatex(menu, charsmax(menu), "%s", g_playername[player])
		
		// Add player
		buffer[0] = player
		buffer[1] = 0
		menu_additem(menuid, menu, buffer)
	}
	
	// Back - Next - Exit
	menu_setprop(menuid, MPROP_BACKNAME, "Atrás")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// If remembered page is greater than number of pages, clamp down the value
	MENU_PAGE_PLAYERS = min(MENU_PAGE_PLAYERS, menu_pages(menuid)-1)
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid, MENU_PAGE_PLAYERS)
}

public menu_elegir_tribales(id, menuid, item)
{
	// Player disconnected?
	if (!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Remember player's menu page
	static menudummy
	player_menu_info(id, menudummy, menudummy, MENU_PAGE_PLAYERS)
	
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_choose_mode(id, 0)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve player id
	static buffer[2], dummy, playerid
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	playerid = buffer[0]
	
	// Make sure it's still connected
	if(hub(playerid, g_data[BIT_CONNECTED]))
	{
		if(g_tribal_pos == 2)
		{
			g_tribal_pos = 0;
			g_tribal_acomodado = 0;
		}
		
		g_tribal_acomodado = 1;
		
		g_tribal_id[g_tribal_pos] = playerid;
		g_tribal_pos++
	}
	else
		CC(id, "!g[ZP]!y No disponible")
	
	menu_destroy(menuid)
	elegirTribales(id)
	return PLUGIN_HANDLED;
}

public elegirAlien(id)
{
	// Player disconnected?
	if (!hub(id, g_data[BIT_CONNECTED]))
		return;
		
	static menuid, menu[128], player, buffer[2]
	
	formatex(menu, charsmax(menu), "\yELEGIR %s", (g_alvspred_pos == 2) ? "ALIEN" : (!g_alvspred_pos) ? "ALIEN" : "DEPREDADOR")
	menuid = menu_create(menu, "menu_elegir_alien")
	
	// Player List
	for (player = 1; player <= g_maxplayers; player++)
	{
		// Skip if not connected
		if(!hub(player, g_data[BIT_CONNECTED]))
			continue;
		
		formatex(menu, charsmax(menu), "%s", g_playername[player])
		
		// Add player
		buffer[0] = player
		buffer[1] = 0
		menu_additem(menuid, menu, buffer)
	}
	
	// Back - Next - Exit
	menu_setprop(menuid, MPROP_BACKNAME, "Atrás")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// If remembered page is greater than number of pages, clamp down the value
	MENU_PAGE_PLAYERS = min(MENU_PAGE_PLAYERS, menu_pages(menuid)-1)
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid, MENU_PAGE_PLAYERS)
}
public menu_elegir_alien(id, menuid, item)
{
	// Player disconnected?
	if (!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Remember player's menu page
	static menudummy
	player_menu_info(id, menudummy, menudummy, MENU_PAGE_PLAYERS)
	
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_choose_mode(id, 1)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve player id
	static buffer[2], dummy, playerid
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	playerid = buffer[0]
	
	// Make sure it's still connected
	if(hub(playerid, g_data[BIT_CONNECTED]))
	{
		if(g_alvspred_pos == 2)
		{
			g_alvspred_pos = 0;
			g_alvspred_acomodado = 0;
		}
		
		g_alvspred_acomodado = 1;
		
		g_alvspred_id[g_alvspred_pos] = playerid;
		g_alvspred_pos++
	}
	else
		CC(id, "!g[ZP]!y No disponible")
	
	menu_destroy(menuid)
	elegirAlien(id)
	return PLUGIN_HANDLED;
}

public show_menu_choose_mode(id, mode)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return;
	
	static menuid, menu[128], mani[64];
	
	MENU_CHOOSE_MODE_A = mode
	
	// Title
	switch(MENU_CHOOSE_MODE_A)
	{
		case 0:
		{
			formatex(menu, charsmax(menu), "\yTRIBAL\R")
			formatex(mani, charsmax(mani), "Elegir Tribales")
		}
		case 1:
		{
			formatex(menu, charsmax(menu), "\yALIEN VS. DEPREDADOR\R")
			formatex(mani, charsmax(mani), "Elegir Alien y Depredador")
		}
		case 2:
		{
			formatex(menu, charsmax(menu), "\yFLESHPOUND\R")
			formatex(mani, charsmax(mani), "Elegir Tribales y Fleshpound")
		}
	}
	
	menuid = menu_create(menu, "menu_choose_mode")
	menu_additem(menuid, mani, "1")
	menu_additem(menuid, "Comenzar modo", "2")
	
	// Back - Next - Exit
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid, 0)
}
public menu_choose_mode(id, menuid, item)
{
	// Player disconnected?
	if (!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		
		show_menu_admin(id, 1)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve player id
	static buffer[2], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	// Perform the right action if allowed
	switch(str_to_num(buffer))
	{
		case 1:
		{
			if(!MENU_CHOOSE_MODE_A) elegirTribales(id)
			else if(MENU_CHOOSE_MODE_A == 1) elegirAlien(id)
			else if(MENU_CHOOSE_MODE_A == 2) elegirTribales(id)
		}
		case 2:
		{
			if(!MENU_CHOOSE_MODE_A && allowed_tribal())
				command_tribal()
			else if(MENU_CHOOSE_MODE_A == 1 && allowed_alvspred())
				command_alvspred()
			else if(MENU_CHOOSE_MODE_A == 2 && allowed_armageddon())
				command_fp()
			else
			{
				CC(id, "!g[ZP]!y Comando no disponible")
				show_menu_choose_mode(id, MENU_CHOOSE_MODE_A)
			}
		}
	}
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}

public clcmdSorteoGrande(id)
{
	/*if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	if(g_zr_pj[id] != 1)
		return PLUGIN_HANDLED;
	
	new i;
	new Handle:sql_consult
	
	for(i = 3; i < 8741; ++i)
	{
		sql_consult = SQL_PrepareQuery(g_sql_connection, "SELECT lvl, rng FROM `users` WHERE id = %d;", i)
		if(!SQL_Execute(sql_consult))
		{
			new sql_error[512];
			SQL_QueryError(sql_consult, sql_error, 511);
			
			log_to_file("zr_sql.log", "- LOG:782 - %s", sql_error);
		}
		else if(SQL_NumResults(sql_consult))
		{
			new leeevel, raaaaaange
			leeevel = SQL_ReadResult(sql_consult, 0)
			raaaaaange = SQL_ReadResult(sql_consult, 1)
			
			sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE users SET xp='%d' WHERE id = %d;", (XPNeeded[leeevel-1] * (raaaaaange + 5)), i)
			if(!SQL_Execute(sql_consult))
			{
				new sql_error[512];
				SQL_QueryError(sql_consult, sql_error, 511);
				
				log_to_file("zr_sql.log", "- LOG:631 - %s", sql_error);
			}
			
			SQL_FreeHandle(sql_consult)
		}
		else
			SQL_FreeHandle(sql_consult)
	}*/
	
	/*new i;
	new Handle:sql_consult
	
	for(i = 1; i < sizeof(premios_id); ++i)
	{
		sql_consult = SQL_PrepareQuery(g_sql_connection, "SELECT points FROM `users` WHERE id = %d;", premios_id[i])
		if(!SQL_Execute(sql_consult))
		{
			new sql_error[512];
			SQL_QueryError(sql_consult, sql_error, 511);
			
			log_to_file("zr_sql.log", "- LOG:782 - %s", sql_error);
		}
		else if(SQL_NumResults(sql_consult))
		{
			const mC = 11;
			
			static a[450];
			static b[4][12];
			
			new c[4];
			
			SQL_ReadResult(sql_consult, 0, a, charsmax(a))
			parse(a, b[0], mC, b[1], mC, b[2], mC, b[3], mC)
			
			c[0] = str_to_num(b[0])
			c[1] = str_to_num(b[1])
			c[2] = str_to_num(b[2])
			c[3] = str_to_num(b[3])
			
			c[0] += premios_ph[i]
			c[1] += premios_pz[i]
			
			SQL_FreeHandle(sql_consult)
			
			new ppalfcxd[128]
			formatex(ppalfcxd, 127, "%d %d %d %d", c[0], c[1], c[2], c[3])
			
			sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE users SET points='%s', lvl=lvl+%d WHERE id = %d;", ppalfcxd, premios_lvls[i], premios_id[i])
			if(!SQL_Execute(sql_consult))
			{
				new sql_error[512];
				SQL_QueryError(sql_consult, sql_error, 511);
				
				log_to_file("zr_sql.log", "- LOG:631 - %s", sql_error);
			}
			
			SQL_FreeHandle(sql_consult)
			
			sql_consult = SQL_PrepareQuery(g_sql_connection, "UPDATE rewards SET money=money+%d WHERE id = %d;", premios_money[i], premios_id[i])
			if(!SQL_Execute(sql_consult))
			{
				new sql_error[512];
				SQL_QueryError(sql_consult, sql_error, 511);
				
				log_to_file("zr_sql.log", "- LOG:3132 - %s", sql_error);
			}
			
			SQL_FreeHandle(sql_consult)
		}
		else
			SQL_FreeHandle(sql_consult)
	}*/
	
	return PLUGIN_HANDLED;
}

public clcmd_KiskeNum(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	if(!g_logged[id])
		return PLUGIN_HANDLED;
		
	new GK_Menu = menu_create("\yGAME KISKE", "menu_GK");
	
	menu_additem(GK_Menu, "Jugar un número^n", "1");
	
	if(check_access(id, 1))
	{
		menu_additem(GK_Menu, "Sortear número", "2");
		menu_additem(GK_Menu, "Elegir número", "3");
		menu_additem(GK_Menu, "Sortear tribales", "4");
		menu_additem(GK_Menu, "Sortear alien y depredador^n", "5");
	}
	
	menu_addtext(GK_Menu, "\yEl juego es GRATIS!^n^nSi le das al número exacto,^nautomáticamente podes ganar cosas increíbles");
	
	menu_setprop(GK_Menu, MPROP_EXITNAME, "Salir");
	
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, GK_Menu, 0)
	
	return PLUGIN_HANDLED;
}

public menu_GK(id, menuid, item)
{
	// Menu was closed
	if(!is_user_connected(id) || item == MENU_EXIT)
		return PLUGIN_HANDLED;
	
	static buffer[3], dummy
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	
	switch(str_to_num(buffer))
	{
		case 1: clcmd_GameKiskeNum(id)
		case 2:
		{
			if(!check_access(id, 1))
			{
				clcmd_KiskeNum(id)
				return PLUGIN_HANDLED;
			}
			
			clcmd_SorteoGameKiske(id, 0, 0)
		}
		case 3:
		{
			if(!check_access(id, 1))
			{
				clcmd_KiskeNum(id)
				return PLUGIN_HANDLED;
			}
			
			client_cmd(id, "messagemode ELEGIR_NUMERO")
		}
		case 4:
		{
			if(!check_access(id, 1))
			{
				clcmd_KiskeNum(id)
				return PLUGIN_HANDLED;
			}
			
			clcmd_SorteoGameKiske(id, 1, 0)
		}
		case 5:
		{
			if(!check_access(id, 1))
			{
				clcmd_KiskeNum(id)
				return PLUGIN_HANDLED;
			}
			
			clcmd_SorteoGameKiske(id, 2, 0)
		}
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_GameKiskeNum(id)
{
	if(!hub(id, g_data[BIT_CONNECTED]))
		return PLUGIN_HANDLED;
	
	if(!g_logged[id])
		return PLUGIN_HANDLED;
	
	if(g_gk_num[id] != 2147483646)
	{
		client_print(id, print_center, "Ya jugaste a un número!");
		return PLUGIN_HANDLED;
	}
	
	client_cmd(id, "messagemode enter_number");
	client_print(id, print_center, "Ingresa un número de 1 a 999");
	
	return PLUGIN_HANDLED;
}

public clcmd_GameKiske(id)
{
	if(!is_user_connected(id) || !g_logged[id])
		return PLUGIN_HANDLED;
	
	if(g_gk_num[id] != 2147483646)
	{
		client_print(id, print_center, "Ya jugaste a un número!");
		return PLUGIN_HANDLED;
	}
	
	new sBetNum[191];
	new iBetNum;
	
	read_args(sBetNum, 190);
	remove_quotes(sBetNum);
	trim(sBetNum);
	
	iBetNum = str_to_num(sBetNum);
	
	if(is_containing_letters(sBetNum) ||
	!count_numbers(sBetNum) ||
	iBetNum < 1 || iBetNum > 999 ||
	equali(sBetNum, "") ||
	containi(sBetNum, " ") != -1)
	{
		CC(id, "!g[GameKiske]!y Solo números, sin espacios, y el número debe ser de 1 a 999");
		return PLUGIN_HANDLED;
	}
	
	new i;
	for(i = 1; i <= g_maxplayers; i++)
	{
		if(!is_user_connected(i))
			continue;
		
		if(iBetNum == g_gk_num[i])
		{
			CC(id, "!g[GameKiske]!y Este número ya lo han jugado, no podes jugar el mismo que otro");
			return PLUGIN_HANDLED;
		}
	}
	
	g_gk_num[id] = iBetNum;
	CC(id, "!g[GameKiske]!y Jugaste al número !g%d!y", iBetNum);
	
	return PLUGIN_HANDLED;
}

public clcmd_GameKiskeChoice(id)
{
	if(!is_user_connected(id) || !g_logged[id])
		return PLUGIN_HANDLED;
	
	new sBetNum[191];
	new iBetNum;
	
	read_args(sBetNum, 190);
	remove_quotes(sBetNum);
	trim(sBetNum);
	
	iBetNum = str_to_num(sBetNum);
	
	if(is_containing_letters(sBetNum) ||
	!count_numbers(sBetNum) ||
	iBetNum < 1 || iBetNum > 999 ||
	equali(sBetNum, "") ||
	containi(sBetNum, " ") != -1)
	{
		CC(id, "!g[GameKiske]!y Solo números, sin espacios, y el número debe ser de 1 a 999");
		return PLUGIN_HANDLED;
	}
	
	clcmd_SorteoGameKiske(id, 0, iBetNum)
	
	return PLUGIN_HANDLED;
}

public clcmd_SorteoGameKiske(id, mode, no_azar)
{
	if(!is_user_connected(id) || !g_logged[id])
		return PLUGIN_HANDLED;
	
	new local_gk_num[33];
	new iGameNum;
	new i;
	
	if(!no_azar) iGameNum = random_num(1, 999);
	else iGameNum = no_azar;
	
	switch(mode)
	{
		case 0:
		{
			CC(0, "!g[GameKiske]!y El número ganador es el !g%d!y", iGameNum);
			
			for(i = 0; i < 33; i++)
				local_gk_num[i] = 2147483646;
			
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!is_user_connected(i) || !g_logged[i])
					continue;
				
				if(g_gk_num[i] == 2147483646)
					continue;
				
				if(g_gk_num[i] == iGameNum)
				{
					CC(0, "!g[GameKiske]!y El jugador !g%s!y tiene el número exacto. !gGANÓ!!y", g_playername[i]);
					
					fn_WinnerGK(i);
					
					for(new j = 1; j <= g_maxplayers; j++)
					{
						if(!is_user_connected(j) || !g_logged[j])
							continue;
						
						g_gk_num[j] = 2147483646;
					}
					
					return PLUGIN_HANDLED;
				}
				
				local_gk_num[i] = g_gk_num[i];
				local_gk_num[i] = abs(local_gk_num[i] - iGameNum);
			}
			
			SortIntegers(local_gk_num, 32, Sort_Ascending);
			
			for(i = 1; i <= g_maxplayers; i++)
			{
				if(!is_user_connected(i) || !g_logged[i])
					continue;
				
				if(g_gk_num[i] == 2147483646)
					continue;
				
				if(abs(g_gk_num[i] - iGameNum) == local_gk_num[0])
				{
					CC(0, "!g[GameKiske]!y El jugador !g%s!y tiene el número más cercano (!g%d!y). !gGANÓ!!y", g_playername[i], g_gk_num[i]);
					
					for(new j = 1; j <= g_maxplayers; j++)
					{
						if(!is_user_connected(j) || !g_logged[j])
							continue;
						
						g_gk_num[j] = 2147483646;
					}
					
					return PLUGIN_HANDLED;
				}
			}
		}
		case 1:
		{
			new iGameNum2 = random_num(1, 999);
			new pWin;
			new iWin = 0;
			new p = 0;
			
			if(iGameNum2 == iGameNum)
				iGameNum2 /= 2;
			
			CC(0, "!g[GameKiske]!y Los números ganadores son el !g%d!y y el !g%d!y", iGameNum, iGameNum2);
			
			while(p < 2)
			{
				if(!p) pWin = iGameNum;
				else
				{
					pWin = iGameNum2;
					
					g_tribal_acomodado = 1;
				}
				
				for(i = 0; i < 33; i++)
					local_gk_num[i] = 2147483646;
				
				for(i = 1; i <= g_maxplayers; i++)
				{
					if(!is_user_connected(i) || !g_logged[i])
						continue;
					
					if(g_gk_num[i] == 2147483646)
						continue;
					
					if(g_gk_num[i] == pWin)
					{
						CC(0, "!g[GameKiske]!y El jugador !g%s!y tiene el número exacto. !gGANÓ el %s TRIBAL!!y", g_playername[i], (!p) ? "primer" : "segundo");
						
						fn_WinnerGK(i);
						g_gk_num[i] = 2147483646;
						
						g_tribal_id[p] = i;
						
						if(p == 1)
						{
							for(new j = 1; j <= g_maxplayers; j++)
							{
								if(!is_user_connected(j) || !g_logged[j])
									continue;
								
								g_gk_num[j] = 2147483646;
							}
						}
						
						iWin = 1;
						break;
					}
					
					local_gk_num[i] = g_gk_num[i];
					local_gk_num[i] = abs(local_gk_num[i] - pWin);
				}
				
				if(iWin)
				{
					p++;
					continue; // Vuelve al while
				}
				
				SortIntegers(local_gk_num, 32, Sort_Ascending);
				
				for(i = 1; i <= g_maxplayers; i++)
				{
					if(!is_user_connected(i) || !g_logged[i])
						continue;
					
					if(g_gk_num[i] == 2147483646)
						continue;
					
					if(abs(g_gk_num[i] - pWin) == local_gk_num[0])
					{
						CC(0, "!g[GameKiske]!y El jugador !g%s!y tiene el número más cercano (!g%d!y). !gGANÓ el %s TRIBAL!!y", g_playername[i], g_gk_num[i], (!p) ? "primer" : "segundo");
						g_gk_num[i] = 2147483646;
						
						g_tribal_id[p] = i;
						
						if(p == 1)
						{
							for(new j = 1; j <= g_maxplayers; j++)
							{
								if(!is_user_connected(j) || !g_logged[j])
									continue;
								
								g_gk_num[j] = 2147483646;
							}
						}
						
						break;
					}
				}
				
				p++;
			}
		}
		case 2:
		{
			new iGameNum2 = random_num(1, 999);
			new pWin;
			new iWin = 0;
			new p = 0;
			
			if(iGameNum2 == iGameNum)
				iGameNum2 /= 2;
			
			CC(0, "!g[GameKiske]!y Los números ganadores son el !g%d!y y el !g%d!y", iGameNum, iGameNum2);
			
			while(p < 2)
			{
				if(!p) pWin = iGameNum;
				else
				{
					pWin = iGameNum2;
					
					g_alvspred_acomodado = 1;
				}
				
				for(i = 0; i < 33; i++)
					local_gk_num[i] = 2147483646;
				
				for(i = 1; i <= g_maxplayers; i++)
				{
					if(!is_user_connected(i) || !g_logged[i])
						continue;
					
					if(g_gk_num[i] == 2147483646)
						continue;
					
					if(g_gk_num[i] == pWin)
					{
						CC(0, "!g[GameKiske]!y El jugador !g%s!y tiene el número exacto. !gGANÓ el %s!!y", g_playername[i], (!p) ? "ALIEN" : "DEPREDADOR");
						
						fn_WinnerGK(i);
						g_gk_num[i] = 2147483646;
						
						g_alvspred_id[p] = i;
						
						if(p == 1)
						{
							for(new j = 1; j <= g_maxplayers; j++)
							{
								if(!is_user_connected(j) || !g_logged[j])
									continue;
								
								g_gk_num[j] = 2147483646;
							}
						}
						
						iWin = 1;
						break;
					}
					
					local_gk_num[i] = g_gk_num[i];
					local_gk_num[i] = abs(local_gk_num[i] - pWin);
				}
				
				if(iWin)
				{
					p++;
					continue; // Vuelve al while
				}
				
				SortIntegers(local_gk_num, 32, Sort_Ascending);
				
				for(i = 1; i <= g_maxplayers; i++)
				{
					if(!is_user_connected(i) || !g_logged[i])
						continue;
					
					if(g_gk_num[i] == 2147483646)
						continue;
					
					if(abs(g_gk_num[i] - pWin) == local_gk_num[0])
					{
						CC(0, "!g[GameKiske]!y El jugador !g%s!y tiene el número más cercano (!g%d!y). !gGANÓ el %s!!y", g_playername[i], g_gk_num[i], (!p) ? "ALIEN" : "DEPREDADOR");
						g_gk_num[i] = 2147483646;
						
						g_alvspred_id[p] = i;
						
						if(p == 1)
						{
							for(new j = 1; j <= g_maxplayers; j++)
							{
								if(!is_user_connected(j) || !g_logged[j])
									continue;
								
								g_gk_num[j] = 2147483646;
							}
						}
						
						break;
					}
				}
				
				p++;
			}
		}
	}
	
	return PLUGIN_HANDLED;
}

public fn_WinnerGK(i)
{
	new iRand = random_num(1, 8);
	new maxlevel;
	
	switch(iRand)
	{
		case 1:
		{
			maxlevel = MAX_HAB_LEVEL[HAB_ZOMBIE][ZOMBIE_HP] + MAX_EFFECTS_HATS_HABS[g_hat_equip[i]+1][HAB_ZOMBIE][ZOMBIE_HP]
			if(maxlevel != g_hab[i][HAB_ZOMBIE][ZOMBIE_HP])
			{
				CC(0, "!g[GameKiske]!y Por tener el número exacto también gano !g+1 a VIDA ZOMBIE!y");
				g_hab[i][HAB_ZOMBIE][ZOMBIE_HP]++;
			}
		}
		case 2:
		{
			maxlevel = MAX_HAB_LEVEL[HAB_ZOMBIE][ZOMBIE_SPEED] + MAX_EFFECTS_HATS_HABS[g_hat_equip[i]+1][HAB_ZOMBIE][ZOMBIE_SPEED]
			if(maxlevel != g_hab[i][HAB_ZOMBIE][ZOMBIE_SPEED])
			{
				CC(0, "!g[GameKiske]!y Por tener el número exacto también gano !g+1 a VELOCIDAD ZOMBIE!y");
				g_hab[i][HAB_ZOMBIE][ZOMBIE_SPEED]++;
			}
		}
		case 3:
		{
			maxlevel = MAX_HAB_LEVEL[HAB_ZOMBIE][ZOMBIE_DAMAGE] + MAX_EFFECTS_HATS_HABS[g_hat_equip[i]+1][HAB_ZOMBIE][ZOMBIE_DAMAGE]
			if(maxlevel != g_hab[i][HAB_ZOMBIE][ZOMBIE_DAMAGE])
			{
				CC(0, "!g[GameKiske]!y Por tener el número exacto también gano !g+1 a DAÑO ZOMBIE!y");
				g_hab[i][HAB_ZOMBIE][ZOMBIE_DAMAGE]++;
			}
		}
		case 4:
		{
			maxlevel = MAX_HAB_LEVEL[HAB_HUMAN][HUMAN_HP] + MAX_EFFECTS_HATS_HABS[g_hat_equip[i]+1][HAB_HUMAN][HUMAN_HP]
			if(maxlevel != g_hab[i][HAB_HUMAN][HUMAN_HP])
			{
				CC(0, "!g[GameKiske]!y Por tener el número exacto también gano !g+1 a VIDA HUMANA!y");
				g_hab[i][HAB_HUMAN][HUMAN_HP]++;
			}
		}
		case 5:
		{
			maxlevel = MAX_HAB_LEVEL[HAB_HUMAN][HUMAN_SPEED] + MAX_EFFECTS_HATS_HABS[g_hat_equip[i]+1][HAB_HUMAN][HUMAN_SPEED]
			if(maxlevel != g_hab[i][HAB_HUMAN][HUMAN_SPEED])
			{
				CC(0, "!g[GameKiske]!y Por tener el número exacto también gano !g+1 a VELOCIDAD HUMANA!y");
				g_hab[i][HAB_HUMAN][HUMAN_SPEED]++;
			}
		}
		case 6:
		{
			maxlevel = MAX_HAB_LEVEL[HAB_HUMAN][HUMAN_DAMAGE] + MAX_EFFECTS_HATS_HABS[g_hat_equip[i]+1][HAB_HUMAN][HUMAN_DAMAGE]
			if(maxlevel != g_hab[i][HAB_HUMAN][HUMAN_DAMAGE])
			{
				CC(0, "!g[GameKiske]!y Por tener el número exacto también gano !g+1 a DAÑO HUMANO!y");
				g_hab[i][HAB_HUMAN][HUMAN_DAMAGE]++;
			}
		}
		case 7:
		{
			if((g_level[i]+7) < MAX_LVL)
			{
				g_level[i] += 7;
				g_exp[i] = (XPNeeded[g_level[i]-1] * MULT_PER_RANGE_SPEC(i));
				g_money[i] += 10;
				
				CC(0, "!g[GameKiske]!y Por tener el número exacto también gano !g7 niveles!y y !g$10!y");
			}
		}
		case 8:
		{
			g_points[i][HAB_HUMAN] += 10;
			g_points[i][HAB_ZOMBIE] += 10;
			
			CC(0, "!g[GameKiske]!y Por tener el número exacto también gano !g10p H. !yy!g Z.!y");
		}
	}
}

public clcmd_ent_check(id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	new target, body;
	get_user_aiming(id, target, body);
	
	CC(id, "!g[ZP]!y EntId: %d", target);
	
	return PLUGIN_HANDLED;
}

public PM_Move(OrpheuStruct:ppmove, server)
	g_ppmove = ppmove;

public PM_Duck()
{
	new iPlayer = OrpheuGetStructMember(g_ppmove, "player_index") + 1;

	if(hub(iPlayer, g_data[BIT_ALIVE]) && (g_sniper[iPlayer] || g_grab_player[iPlayer]))
	{
		new OrpheuStruct:cmd = OrpheuStruct:OrpheuGetStructMember(g_ppmove, "cmd");
		OrpheuSetStructMember(cmd, "buttons", OrpheuGetStructMember(cmd, "buttons" ) & ~IN_DUCK);
	}
}

bubble_explode(ent)
{
	// Get origin
	static Float:originF[3]
	entity_get_vector(ent, EV_VEC_origin, originF)
	
	if(get_entity_flags(ent) & FL_INWATER)
	{
		engfunc(EngFunc_RemoveEntity, ent)
		return;
	}
	
	// Collisions
	static attacker, victim, count_victims, all
	attacker = entity_get_edict(ent, EV_ENT_owner)
	victim = -1
	count_victims = 0
	all = 0
	
	if(g_level[attacker] >= 500 || g_range[attacker] > 0)
		all = 1
	
	if (!is_user_valid_connected(attacker))
	{
		// Get rid of the grenade
		engfunc(EngFunc_RemoveEntity, ent)
		return;
	}
	
	// Make the explosion
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, originF, 0)
	write_byte(TE_DLIGHT) // TE id
	engfunc(EngFunc_WriteCoord, originF[0]) // x
	engfunc(EngFunc_WriteCoord, originF[1]) // y
	engfunc(EngFunc_WriteCoord, originF[2]) // z
	write_byte(25) // radius
	write_byte(255) // red
	write_byte(255) // green
	write_byte(255) // blue
	write_byte(10) // life
	write_byte(45) // decay rate
	message_end()
	
	// Frost nade explode sound
	emit_sound(ent, CHAN_WEAPON, g_sSoundGrenadeFrost[random_num(0, charsmax(g_sSoundGrenadeFrost))], 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	while((victim = engfunc(EngFunc_FindEntityInSphere, victim, originF, NADE_EXPLOSION_RADIUS)) != 0)
	{
		// Only effect alive unfrozen zombies
		if (!is_user_valid_alive(victim) || g_zombie[victim] || g_nodamage[victim])
			continue;
		
		if(!all)
		{
			if(attacker != victim)
				continue;
			
			if(count_victims)
				break;
		}
		else
		{
			if(count_victims == 1 && attacker != victim)
				continue;
			
			if(count_victims == 2)
				break;
		}
		
		client_print(victim, print_center, "Tenés inmunidad!");
		
		++count_victims
		
		g_nodamage[victim] = 1;
		
		// Light blue glow while frozen
		set_user_rendering(victim, kRenderFxGlowShell, 255, 255, 255, kRenderNormal, 25)
		
		remove_task(victim+TASK_IMMUNITY)
		set_task(12.0, "remove_immn", victim + TASK_IMMUNITY)
	}
	
	// Get rid of the grenade
	engfunc(EngFunc_RemoveEntity, ent)
}

public remove_immn(taskid)
{
	new id = ID_IMMUNITY;
	
	if(!is_user_alive(id))
		return;
	
	g_nodamage[id] = 0;
	
	set_user_rendering(id);
	
	client_print(id, print_center, "Tu inmunidad se acabó!");
}

public fiinfns(id)
{
	g_fp_power = 0;
	
	if(!is_user_alive(id))
		return;
	
	set_user_rendering(id)
}

public fn_Finish()
{
	client_cmd(0, "mp3 stop; stopsound");
}

public clcmd_tbot(id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!equal(g_playername[id], "T-BOT 2000"))
	{
		if(g_bot_question[id])
		{
			CC(id, "!g[T-BOT]!y Ya estás en cola para preguntarle algo al T-BOT, estate atento a su respuesta");
			return PLUGIN_HANDLED;
		}
		else if((get_gametime() - g_bot_order[id]) < 180.0)
		{
			CC(id, "!g[T-BOT]!y Debes esperar 3 minutos al menos para volver a escribir con el T-BOT");
			return PLUGIN_HANDLED;
		}
		
		g_bot_question[id] = 1;
		CC(id, "!g[T-BOT]!y Estás en cola para preguntarle algo al T-BOT");
	}
	else
	{
		static menuid, menu[128], player, buffer[2]
		
		// Title
		menuid = menu_create("\yT-BOT 2000", "menu_tbot")
		
		for (player = 1; player <= g_maxplayers; player++)
		{
			// Skip if not connected
			if(!hub(player, g_data[BIT_CONNECTED]))
				continue;
			
			if(!g_bot_question[player])
				continue;
			
			formatex(menu, charsmax(menu), "\d%s", g_playername[player])
			
			// Add player
			buffer[0] = player
			buffer[1] = 0
			menu_additem(menuid, menu, buffer)
		}
		
		// Back - Next - Exit
		menu_setprop(menuid, MPROP_BACKNAME, "Atrás")
		menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
		menu_setprop(menuid, MPROP_EXITNAME, "Salir")
		
		// Fix for AMXX custom menus
		if(pev_valid(id) == PDATA_SAFE)
			set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
		
		menu_display(id, menuid, 0)
	}
	
	return PLUGIN_HANDLED;
}

public menu_tbot(id, menuid, item)
{
	// Player disconnected?
	if (!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve player id
	static buffer[2], dummy, playerid
	menu_item_getinfo(menuid, item, dummy, buffer, charsmax(buffer), _, _, dummy)
	playerid = buffer[0]
	
	// Make sure it's still connected
	if (hub(playerid, g_data[BIT_CONNECTED]))
	{
		g_bot_question[playerid] = 0;
		g_bot_order[playerid] = get_gametime();
		
		CC(0, "!gT-BOT 2000!y : Qué pregunta deseas hacerme !g%s!y ?", g_playername[playerid])
	}
	
	menu_destroy(menuid)
	return PLUGIN_HANDLED;
}

darRecomp(i)
{
	new shab[64];
	new iRand = random_num(1, 8);
	new maxlevel;
	
	switch(iRand)
	{
		case 1:
		{
			maxlevel = MAX_HAB_LEVEL[HAB_ZOMBIE][ZOMBIE_HP] + MAX_EFFECTS_HATS_HABS[g_hat_equip[i]+1][HAB_ZOMBIE][ZOMBIE_HP]
			if(maxlevel != g_hab[i][HAB_ZOMBIE][ZOMBIE_HP])
			{
				formatex(shab, charsmax(shab), "!g+1 a VIDA ZOMBIE!y")
				g_hab[i][HAB_ZOMBIE][ZOMBIE_HP]++;
			}
		}
		case 2:
		{
			maxlevel = MAX_HAB_LEVEL[HAB_ZOMBIE][ZOMBIE_SPEED] + MAX_EFFECTS_HATS_HABS[g_hat_equip[i]+1][HAB_ZOMBIE][ZOMBIE_SPEED]
			if(maxlevel != g_hab[i][HAB_ZOMBIE][ZOMBIE_SPEED])
			{
				formatex(shab, charsmax(shab), "!g+1 a VELOCIDAD ZOMBIE!y")
				g_hab[i][HAB_ZOMBIE][ZOMBIE_SPEED]++;
			}
		}
		case 3:
		{
			maxlevel = MAX_HAB_LEVEL[HAB_ZOMBIE][ZOMBIE_DAMAGE] + MAX_EFFECTS_HATS_HABS[g_hat_equip[i]+1][HAB_ZOMBIE][ZOMBIE_DAMAGE]
			if(maxlevel != g_hab[i][HAB_ZOMBIE][ZOMBIE_DAMAGE])
			{
				formatex(shab, charsmax(shab), "!g+1 a DAÑO ZOMBIE!y")
				g_hab[i][HAB_ZOMBIE][ZOMBIE_DAMAGE]++;
			}
		}
		case 4:
		{
			maxlevel = MAX_HAB_LEVEL[HAB_HUMAN][HUMAN_HP] + MAX_EFFECTS_HATS_HABS[g_hat_equip[i]+1][HAB_HUMAN][HUMAN_HP]
			if(maxlevel != g_hab[i][HAB_HUMAN][HUMAN_HP])
			{
				formatex(shab, charsmax(shab), "!g+1 a VIDA HUMANA!y")
				g_hab[i][HAB_HUMAN][HUMAN_HP]++;
			}
		}
		case 5:
		{
			maxlevel = MAX_HAB_LEVEL[HAB_HUMAN][HUMAN_SPEED] + MAX_EFFECTS_HATS_HABS[g_hat_equip[i]+1][HAB_HUMAN][HUMAN_SPEED]
			if(maxlevel != g_hab[i][HAB_HUMAN][HUMAN_SPEED])
			{
				formatex(shab, charsmax(shab), "!g+1 a VELOCIDAD HUMANA!y")
				g_hab[i][HAB_HUMAN][HUMAN_SPEED]++;
			}
		}
		case 6:
		{
			maxlevel = MAX_HAB_LEVEL[HAB_HUMAN][HUMAN_DAMAGE] + MAX_EFFECTS_HATS_HABS[g_hat_equip[i]+1][HAB_HUMAN][HUMAN_DAMAGE]
			if(maxlevel != g_hab[i][HAB_HUMAN][HUMAN_DAMAGE])
			{
				formatex(shab, charsmax(shab), "!g+1 a DAÑO HUMANO!y")
				g_hab[i][HAB_HUMAN][HUMAN_DAMAGE]++;
			}
		}
		case 7:
		{
			if((g_level[i]+7) < MAX_LVL)
			{
				g_level[i] += 7;
				g_exp[i] = (XPNeeded[g_level[i]-1] * MULT_PER_RANGE_SPEC(i));
				g_money[i] += 15;
				
				formatex(shab, charsmax(shab), "!g7 niveles y $15!y")
			}
		}
		case 8:
		{
			g_points[i][HAB_HUMAN] += 15;
			g_points[i][HAB_ZOMBIE] += 15;
			
			formatex(shab, charsmax(shab), "!g15p H. !yy!g Z.!y")
		}
	}
	
	CC(0, "!g[ZP]!y Además, ganó %s por ganar el modo en !gmenos de un minuto!y!", shab)
}

public osiduv8s()
{
	if(g_fp_round)
		g_fp_min = 1;
}

public show_menu_armas(id)
{
	new iMenuMain = menu_create("ELIGE QUE ARMAS DESEAS VER", "menuArmas");
	
	menu_additem(iMenuMain, "ARMAS", "1");
	menu_additem(iMenuMain, "ARMAS LEGENDARIAS", "2");
	
	menu_setprop(iMenuMain, MPROP_EXITNAME, "Salir");
	
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	
	menu_display(id, iMenuMain);
}

public menuArmas(id, menuid, item)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid);
		return PLUGIN_HANDLED;
	}
	
	static sBuffer[2];
	static iDummy;
	
	menu_item_getinfo(menuid, item, iDummy, sBuffer, charsmax(sBuffer), _, _, iDummy);
	
	switch(str_to_num(sBuffer[0]))
	{
		case 1: show_menu_buy1(id);
		case 2: show_menu_weapons_legends(id);
	}
	
	menu_destroy(menuid);
	return PLUGIN_HANDLED;
}

public show_menu_weapons_legends(id)
{
	new iMenuMain = menu_create("ARMAS LEGENDARIAS", "menuLegendarias");
	
	if(g_weap_leg[id])
		menu_additem(iMenuMain, "\yRik'Thal \r- \wFuria de las Bestias^n", "1");
	else if(g_money[id] >= 350 && g_logros_completed[id] >= 100)
		menu_additem(iMenuMain, "\yRik'Thal \r- \wFuria de las Bestias \y[$350]^n", "1");
	else
		menu_additem(iMenuMain, "\dRik'Thal \r- \dFuria de las Bestias \r[$350]^n", "1");
	
	new sme[64];
	
	formatex(sme, 63, "DAÑO \w(\y%d \r/ \y10\w)", g_leg_habs[id][0])
	menu_additem(iMenuMain, sme, "2");
	
	formatex(sme, 63, "VELOCIDAD DE DISPARO \w(\y%d \r/ \y10\w)", g_leg_habs[id][1])
	menu_additem(iMenuMain, sme, "3");
	
	formatex(sme, 63, "PRECISIÓN \w(\y%d \r/ \y10\w)", g_leg_habs[id][2])
	menu_additem(iMenuMain, sme, "4");
	
	formatex(sme, 63, "BALAS \w(\y%d \r/ \y10\w)^n", g_leg_habs[id][3])
	menu_additem(iMenuMain, sme, "5");
	
	menu_addtext(iMenuMain, "\rNOTA: \wEn el foro se explica absolutamente todo^nlo que necesitás saber sobre estas armas!")
	
	menu_setprop(iMenuMain, MPROP_EXITNAME, "Salir");
	
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX);
	
	menu_display(id, iMenuMain);
}

public menuLegendarias(id, menuid, item)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(item == MENU_EXIT)
	{
		menu_destroy(menuid);
		return PLUGIN_HANDLED;
	}
	
	static sBuffer[2];
	static iDummy;
	
	menu_item_getinfo(menuid, item, iDummy, sBuffer, charsmax(sBuffer), _, _, iDummy);
	
	switch(str_to_num(sBuffer[0]))
	{
		case 1:
		{
			if(g_weap_leg[id])
			{
				WPN_AUTO_PRI = 118
				
				menu_destroy(menuid);
				
				show_menu_buy2(id)
				return PLUGIN_HANDLED;
			}
			else if(g_money[id] >= 350 && g_logros_completed[id] >= 100)
			{
				g_money[id] -= 350;
				
				fn_update_logro(id, LOGRO_LEGENDARIO, RIK_THAL);
				
				if(!nadie_la_tiene)
				{
					nadie_la_tiene = 1;
					fn_update_logro(id, LOGRO_LEGENDARIO, PRIMERO_DEL_SV_RT);
				}
				
				g_weap_leg[id] = 1;
				
				g_leg_habs[id][4] = 1;
			}
			else if(g_money[id] < 350)
				CC(id, "!g[ZP]!y No tenés suficiente dinero para comprar esta arma, vos tenés !g$%d!y", g_money[id]);
			else if(g_logros_completed[id] < 100)
				CC(id, "!g[ZP]!y Necesitás tener 100 o más logros completados para tener esta arma, vos tenés !g%d!y", g_logros_completed[id]);
		}
		case 2:
		{
			if(g_leg_habs[id][0] < 10 && g_leg_habs[id][4])
			{
				g_leg_habs[id][0]++
				g_leg_habs[id][4]--
			}
		}
		case 3:
		{
			if(g_leg_habs[id][1] < 10 && g_leg_habs[id][4])
			{
				g_leg_habs[id][1]++
				g_leg_habs[id][4]--
			}
		}
		case 4:
		{
			if(g_leg_habs[id][2] < 10 && g_leg_habs[id][4])
			{
				g_leg_habs[id][2]++
				g_leg_habs[id][4]--
			}
		}
		case 5:
		{
			if(g_leg_habs[id][3] < 10 && g_leg_habs[id][4])
			{
				g_leg_habs[id][3]++
				g_leg_habs[id][4]--
			}
		}
	}
	
	menu_destroy(menuid);
	
	show_menu_weapons_legends(id);
	return PLUGIN_HANDLED;
}

public check_leg_lvl(id)
{
	if(!is_user_connected(id))
		return;
	
	if(g_leg_lvl[id] < 15)
	{
		if(g_leg_z_kills[id] >= (100 * g_leg_lvl[id]) && g_leg_dmg[id] >= (100000 * g_leg_lvl[id]))
		{
			g_leg_lvl[id]++;
			
			if(g_leg_lvl[id] == 15) fn_update_logro(id, LOGRO_LEGENDARIO, RIK_THAL_LV_15);
			else if(g_leg_lvl[id] == 10) fn_update_logro(id, LOGRO_LEGENDARIO, RIK_THAL_LV_10);
			else if(g_leg_lvl[id] == 5) fn_update_logro(id, LOGRO_LEGENDARIO, RIK_THAL_LV_5);
			
			CC(id, "!g[ZP]!y Has subido tu arma legendaria !gRik'Thal!y al !gnivel %d!y", g_leg_lvl[id])
			
			g_leg_habs[id][4]++;
		}
		
		if(g_leg_lvl[id] == 15)
			g_leg_z_kills[id] = 0;
	}
	else
	{
		switch(g_leg_lvl_vex[id])
		{
			case 0:
			{
				if(g_leg_z_kills[id] >= 5000 && g_head_zombie[id][box_red] >= 250 && g_head_zombie[id][box_green] >= 250)
				{
					g_leg_lvl_vex[id] = 1;
					
					g_head_zombie[id][box_red] -= 250;
					g_head_zombie[id][box_green] -= 250;
					
					g_leg_heads[id] = 0;
					g_leg_hits[id] = 0;
					
					CC(id, "!g[ZP]!y Has subido tu arma legendaria !gRik'Thal!y al !gnivel VEX 1!y")
					
					fn_update_logro(id, LOGRO_LEGENDARIO, RIK_THAL_LV_VEX_1);
				}
			}
			case 1:
			{
				if(g_leg_heads[id] >= 500000 && g_leg_hits[id] >= 1000000)
				{
					g_leg_lvl_vex[id] = 2;
					
					g_leg_dmg_nem[id] = 0;
					g_leg_dmg_aniq[id] = 0;
					
					CC(id, "!g[ZP]!y Has subido tu arma legendaria !gRik'Thal!y al !gnivel VEX 2!y")
				}
			}
			case 2:
			{
				if(g_leg_dmg_nem[id] >= 10000000 && g_leg_dmg_aniq[id] >= 25000000)
				{
					g_leg_lvl_vex[id] = 3;
					
					g_leg_dmg_nem[id] = 0;
					g_leg_heads[id] = 0;
					
					CC(id, "!g[ZP]!y Has subido tu arma legendaria !gRik'Thal!y al !gnivel VEX 3!y")
					
					fn_update_logro(id, LOGRO_LEGENDARIO, RIK_THAL_LV_VEX_3);
				}
			}
			case 3:
			{
				if(g_leg_dmg_nem[id] >= 20000000 && g_leg_heads[id] >= 1000000 && g_head_zombie[id][box_blue] >= 250)
				{
					g_leg_lvl_vex[id] = 4;
					
					g_head_zombie[id][box_blue] -= 250;
					
					g_leg_z_kills[id] = 0;
					g_leg_hits[id] = 0;
					g_leg_dmg_aniq[id] = 0;
					g_leg_dmg_nem[id] = 0;
					g_leg_heads[id] = 0;
					
					CC(id, "!g[ZP]!y Has subido tu arma legendaria !gRik'Thal!y al !gnivel VEX 4!y")
				}
			}
			case 4:
			{
				if(g_leg_z_kills[id] >= 10000 && g_leg_hits[id] >= 5000000 && g_leg_dmg_aniq[id] >= 25000000 && g_leg_dmg_nem[id] >= 25000000 && g_leg_heads[id] >= 1500000 &&	g_head_zombie[id][box_red] >= 1000 && g_head_zombie[id][box_green] >= 1000 && g_head_zombie[id][box_blue] >= 1000 && g_head_zombie[id][box_yellow] >= 750 && g_head_zombie[id][box_white] >= 500)
				{
					g_leg_lvl_vex[id] = 5;
					
					g_head_zombie[id][box_red] -= 1000;
					g_head_zombie[id][box_green] -= 1000;
					g_head_zombie[id][box_blue] -= 1000;
					g_head_zombie[id][box_yellow] -= 750;
					g_head_zombie[id][box_white] -= 500;
					
					CC(id, "!g[ZP]!y Has !gCOMPLETADO!y tu arma legendaria !gRik'Thal!y")
					
					fn_update_logro(id, LOGRO_LEGENDARIO, RIK_THAL_COMPLETA);
					
					if(!nadie_la_tiene2)
					{
						nadie_la_tiene2 = 1;
						fn_update_logro(id, LOGRO_LEGENDARIO, PRIMERO_DEL_SV_RT_COMPLETA);
					}
				}
			}
		}
	}
}

stock reverse_string( const string[] = "" , Output[ ] )
{
    static len; len = strlen( string ) - 1
    
    for(new i ; i <= len; i++ )
        Output[i] = string[ len - i ]
}

public clcmd_Camera(id)
{
	if(is_user_connected(id))
	{
		g_camera[id] = !g_camera[id]
		set_view(id, g_camera[id] ? CAMERA_3RDPERSON : CAMERA_NONE);
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_asdasdasd(id)
{
	if(is_user_connected(id) && check_access(id, 1))
	{
		new iOrigin[3];
		new iRand = random_num(1, 3)
		get_user_origin(id, iOrigin, 3);
		
		switch(iRand)
		{
			case 1:
			{
				message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
				write_byte(TE_SPRITETRAIL);
				write_coord(iOrigin[0]);
				write_coord(iOrigin[1]);
				write_coord(iOrigin[2] - 20);
				write_coord(iOrigin[0]);
				write_coord(iOrigin[1]);
				write_coord(iOrigin[2] + 20);
				write_short(g_redballSpr);
				write_byte(get_pcvar_num(cvar[0]));
				write_byte(get_pcvar_num(cvar[1]));
				write_byte(get_pcvar_num(cvar[2]));
				write_byte(get_pcvar_num(cvar[3]));
				write_byte(get_pcvar_num(cvar[4]));
				message_end();
			}
			case 2:
			{
				message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
				write_byte(TE_SPRITETRAIL);
				write_coord(iOrigin[0]);
				write_coord(iOrigin[1]);
				write_coord(iOrigin[2] - 20);
				write_coord(iOrigin[0]);
				write_coord(iOrigin[1]);
				write_coord(iOrigin[2] + 20);
				write_short(g_lightblueballSpr);
				write_byte(get_pcvar_num(cvar[0]));
				write_byte(get_pcvar_num(cvar[1]));
				write_byte(get_pcvar_num(cvar[2]));
				write_byte(get_pcvar_num(cvar[3]));
				write_byte(get_pcvar_num(cvar[4]));
				message_end();
			}
			case 3:
			{
				message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
				write_byte(TE_SPRITETRAIL);
				write_coord(iOrigin[0]);
				write_coord(iOrigin[1]);
				write_coord(iOrigin[2] - 20);
				write_coord(iOrigin[0]);
				write_coord(iOrigin[1]);
				write_coord(iOrigin[2] + 20);
				write_short(g_yellowballSpr);
				write_byte(get_pcvar_num(cvar[0]));
				write_byte(get_pcvar_num(cvar[1]));
				write_byte(get_pcvar_num(cvar[2]));
				write_byte(get_pcvar_num(cvar[3]));
				write_byte(get_pcvar_num(cvar[4]));
				message_end();
			}
		}
	}
	
	return PLUGIN_HANDLED;
}

public clcmd_Abrir(id)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	new red = 0;
	new green = 0;
	new blue = 0;
	new yellow[2] = {0, 0};
	
	if(g_box[id][box_red] <= 0 && g_box[id][box_green] <= 0 && g_box[id][box_blue] <= 0 && g_box[id][box_yellow] <= 0)
	{
		CC(id, "!g[ZP]!y No tenes regalos para abrir");
		return PLUGIN_HANDLED;
	}
	
	if(g_box[id][box_red])
	{
		new iApsChance = random_num(50, 100) * ((g_range[id] * 560) + g_level[id]);
		iApsChance *= g_box[id][box_red];
		
		if(iApsChance > 20000000)
			iApsChance = 20000000;
		
		red = iApsChance;
		
		g_ammopacks[id] += iApsChance;
		
		g_box[id][box_red] = 0;
	}
	
	if(g_box[id][box_blue])
	{
		new iApsChance = random_num(2, 3);
		iApsChance *= g_box[id][box_blue];
		
		if(iApsChance > 1000)
			iApsChance = 1000;
		
		iApsChance /= 2;
		
		blue = iApsChance;
		
		g_points[id][HAB_HUMAN] += iApsChance;
		g_points[id][HAB_ZOMBIE] += iApsChance;
		
		g_box[id][box_blue] = 0;
	}
	
	if(g_box[id][box_yellow])
	{
		new i;
		for(i = 0; i < g_box[id][box_yellow]; ++i)
		{
			if(random_num(0, 5) == 0)
			{
				if(g_level[id] < MAX_LVL)
				{
					g_level[id]++;
					g_exp[id] = (XPNeeded[g_level[id]-1] * MULT_PER_RANGE);
					
					++yellow[0];
				}
				else
				{
					g_money[id] += 3;
					yellow[1] += 3
				}
			}
			else
			{
				g_money[id] += 3;
				yellow[1] += 3
			}
		}
		
		g_box[id][box_yellow] = 0;
	}
	
	if(g_box[id][box_green])
	{
		new iXpChance = random_num(500, 1000) * (g_level[id] + (g_range[id] * 560));
		iXpChance *= g_box[id][box_green]
		
		if(iXpChance > 100000000)
			iXpChance = 100000000;
		
		if((g_exp[id] + iXpChance) > MAX_XP)
		{
			CC(id, "!g[ZP]!y Tus regalos sobrepasan la experiencia que te pide el nivel 559 por lo que no se han podido abrir");
			green = -50;
		}
		else
		{
			green = iXpChance;
			
			update_xp(id, iXpChance, 0);
			
			g_box[id][box_green] = 0;
		}
	}
	
	console_print(id, "");
	console_print(id, "");
	console_print(id, "**** Taringa! CS ****");
	console_print(id, "  Tus regalos rojos te dieron %d APs", red);
	if(green == -50) console_print(id, "  Tus regalos verdes no se pudieron abrir");
	else console_print(id, "  Tus regalos verdes te dieron %d XP", green);
	console_print(id, "  Tus regalos azules te dieron %d puntos humanos y zombies", blue);
	console_print(id, "  Tus regalos amarillos te dieron %d niveles y $%d", yellow[0], yellow[1]);
	console_print(id, "**** Taringa! CS ****");
	
	client_cmd(id, "toggleconsole");
	
	return PLUGIN_HANDLED;
}

public clcmd_Brillo(const id)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED;
	
	static menu[350], len, loop
	len = 0
	
	// Add Items
	for(loop = 0; loop < MAX_COLORS; loop++)
		len += formatex(menu[len], charsmax(menu) - len, "\r%d.\w %s^n", loop+1, COLORS_NAME[COLOR_HUD][loop])
	
	// 0. Exit
	len += formatex(menu[len], charsmax(menu) - len, "^n\r0.\w Salir")
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	show_menu(id, KEYSMENU, menu, -1, "GLOW Menu")
	
	return PLUGIN_HANDLED;
}

public menuGLOW(id, key)
{
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;
	
	if(!check_access(id, 1))
		return PLUGIN_HANDLED
	
	if(key >= 8)
		return PLUGIN_HANDLED;
	
	g_render_color = key;
	
	showMenuPLAYERS_GLOW(id)
	
	return PLUGIN_HANDLED;
}

public showMenuPLAYERS_GLOW(id)
{
	new menuid, menu[128], player, buffer[3], j
	
	menuid = menu_create("- BRILLO", "menuPLAYER_GLOW")
	
	j = 1;
	for (player = 1; player <= g_maxplayers; player++)
	{
		if(!is_user_alive(player))
			continue;
		
		formatex(menu, charsmax(menu), "%s", g_playername[player])
		
		// Add player
		num_to_str(j, buffer, 2);
		menu_additem(menuid, menu, buffer)
		
		++j
	}
	
	// Back - Next - Exit
	menu_setprop(menuid, MPROP_BACKNAME, "Atrás")
	menu_setprop(menuid, MPROP_NEXTNAME, "Siguiente")
	menu_setprop(menuid, MPROP_EXITNAME, "Volver")
	
	// If remembered page is greater than number of pages, clamp down the value
	//MENU_PAGE_PLAYERS = min(MENU_PAGE_PLAYERS, menu_pages(menuid)-1)
	
	// Fix for AMXX custom menus
	if(pev_valid(id) == PDATA_SAFE)
		set_pdata_int(id, OFFSET_CSMENUCODE, 0, OFFSET_LINUX)
	
	menu_display(id, menuid)
}

public menuPLAYER_GLOW(id, menuid, item)
{
	// Player disconnected?
	if (!is_user_connected(id))
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Remember player's menu page
	/*static menudummy
	player_menu_info(id, menudummy, menudummy, MENU_PAGE_PLAYERS)*/
	
	// Menu was closed
	if (item == MENU_EXIT)
	{
		menu_destroy(menuid)
		return PLUGIN_HANDLED;
	}
	
	// Retrieve player id
	static sBuffer[4];
	static iDummy;
	static iItem;
	
	menu_item_getinfo(menuid, item, iDummy, sBuffer, charsmax(sBuffer), _, _, iDummy);
	
	iItem = str_to_num(sBuffer);
	
	if(is_user_connected(iItem))
	{
		if(g_render[iItem] == -1)
		{
			g_render[iItem] = g_render_color;
			
			set_user_rendering(iItem, kRenderFxGlowShell, TABLET_COLORS[g_render_color][0], TABLET_COLORS[g_render_color][1], TABLET_COLORS[g_render_color][2], kRenderNormal, 25)
			CC(0, "!g[ZP] %s!y tiene brillo !g%s!y", g_playername[iItem], COLORS_NAME[1][g_render_color]);
		}
		else
		{
			set_user_rendering(iItem)
			CC(0, "!g[ZP] %s!y no tiene ningún brillo", g_playername[iItem]);
		}
	}
	else
		CC(id, "!g[ZP]!y No disponible")
	
	menu_destroy(menuid)
	showMenuPLAYERS_GLOW(id)
	return PLUGIN_HANDLED;
}

public grab_on(id,level,cid)
{
	if(!check_access(id, 1))
		return PLUGIN_HANDLED
	
	if(g_grab_player[id])
		return PLUGIN_HANDLED
	
	g_grab_player[id] = -1
	
	static target, trash
	target=0
	
	get_user_aiming(id,target,trash)
	if(target && is_user_alive(target) && target != id)
	{
		if(target <= g_maxplayers)
		{
			if(is_user_alive(target))
				grabem(id,target)
		}
		else if(entity_get_int(target,EV_INT_solid) !=4)
			grabem(id,target)
	}
	else
		set_task(0.1,"grab_on2",id)
		
	return PLUGIN_HANDLED
}

public grab_on2(id)
{
	if(is_user_connected(id))
	{
		static target, trash
		target=0
		
		get_user_aiming(id,target,trash)
		
		if(target && is_user_alive(target) && target != id)
		{
			if(target <= g_maxplayers)
			{
				if(is_user_alive(target))
					grabem(id,target)
			}
			else if(entity_get_int(target,EV_INT_solid) != 4)
				grabem(id,target)
		}
		else
			set_task(0.1,"grab_on2",id)
	}
}

public grabem(id,target)
{
	g_grab_player[id]=target
	
	if(!g_survivor[target] && !g_wesker[target] && !g_nemesis[target] && !g_tribal_human[target] && !g_sniper[target] && g_render[target] == -1)
		set_user_rendering(target, kRenderFxGlowShell, 255, 0, 0, kRenderTransAlpha, 70)
	
	if(target <= g_maxplayers)
	{
		g_grab_player_gravity[target] = get_user_gravity(target);
		set_user_gravity(target, 0.0)
	}
	
	grab_totaldis[id] = 0.0
	
	set_task(0.1,"grab_prethink",id+291678,"",0,"b")
	
	grab_prethink(id+291678)
	
	emit_sound(id,CHAN_VOICE,"weapons/xbow_fire1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
}

public grab_off(id)
{
	if(is_user_connected(id))
	{
		if(g_grab_player[id]==-1)
		{
			g_grab_player[id]=0
			ExecuteHamB(Ham_Player_ResetMaxSpeed, id)
		}
		else if(g_grab_player[id])
		{
			if(!g_survivor[g_grab_player[id]] && !g_wesker[g_grab_player[id]] && !g_nemesis[g_grab_player[id]] && !g_tribal_human[g_grab_player[id]] && !g_sniper[g_grab_player[id]] && g_render[g_grab_player[id]] == -1)
				set_user_rendering(g_grab_player[id])
			
			if(g_grab_player[id] <= g_maxplayers && is_user_alive(g_grab_player[id]))
				set_user_gravity(g_grab_player[id], g_grab_player_gravity[g_grab_player[id]])
			
			g_grab_player[id]=0
		}
	}
	return PLUGIN_HANDLED
}

public grab_prethink(id)
{
	id -= 291678
	if(!is_user_connected(id) && g_grab_player[id]>0)
	{
		if(!g_survivor[g_grab_player[id]] && !g_wesker[g_grab_player[id]] && !g_nemesis[g_grab_player[id]] && !g_tribal_human[g_grab_player[id]] && !g_sniper[g_grab_player[id]] && g_render[g_grab_player[id]] == -1)
			set_user_rendering(g_grab_player[id])
		
		if(g_grab_player[id] <= g_maxplayers && is_user_alive(g_grab_player[id]))
			set_user_gravity(g_grab_player[id], g_grab_player_gravity[g_grab_player[id]])
		
		g_grab_player[id]=0
	}
	
	if(!g_grab_player[id] || g_grab_player[id]==-1)
	{
		remove_task(id+291678)
		return PLUGIN_HANDLED
	}

	static origin1[3]
	get_user_origin(id,origin1)
	static Float:origin2_F[3], origin2[3]
	entity_get_vector(g_grab_player[id],EV_VEC_origin,origin2_F)
	origin2[0] = floatround(origin2_F[0])
	origin2[1] = floatround(origin2_F[1])
	origin2[2] = floatround(origin2_F[2])
	static origin3[3]
	get_user_origin(id,origin3,3)

	//Create red beam
	message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
	write_byte(1)		//TE_BEAMENTPOINT
	write_short(id)		// start entity
	write_coord(origin2[0])
	write_coord(origin2[1])
	write_coord(origin2[2])
	write_short(dotsprite)
	write_byte(1)		// framestart
	write_byte(1)		// framerate
	write_byte(1)		// life in 0.1's
	write_byte(5)		// width
	write_byte(0)		// noise
	write_byte(255)		// red
	write_byte(0)		// green
	write_byte(0)		// blue
	write_byte(200)		// brightness
	write_byte(0)		// speed
	message_end()

	//Convert to floats for calculation
	static Float:origin1_F[3]
	static Float:origin3_F[3]
	origin1_F[0] = float(origin1[0])
	origin1_F[1] = float(origin1[1])
	origin1_F[2] = float(origin1[2])
	origin3_F[0] = float(origin3[0])
	origin3_F[1] = float(origin3[1])
	origin3_F[2] = float(origin3[2])

	//Calculate target's new velocity
	static Float:distance[3]

	if(!grab_totaldis[id])
	{
		distance[0] = floatabs(origin1_F[0] - origin2_F[0])
		distance[1] = floatabs(origin1_F[1] - origin2_F[1])
		distance[2] = floatabs(origin1_F[2] - origin2_F[2])
		
		grab_totaldis[id] = floatsqroot(distance[0]*distance[0] + distance[1]*distance[1] + distance[2]*distance[2])
	}
	
	distance[0] = origin3_F[0] - origin1_F[0]
	distance[1] = origin3_F[1] - origin1_F[1]
	distance[2] = origin3_F[2] - origin1_F[2]

	static Float:grab_totaldis2
	grab_totaldis2 = floatsqroot(distance[0]*distance[0] + distance[1]*distance[1] + distance[2]*distance[2])

	static Float:que
	que = grab_totaldis[id] / grab_totaldis2

	static Float:origin4[3]
	origin4[0] = ( distance[0] * que ) + origin1_F[0]
	origin4[1] = ( distance[1] * que ) + origin1_F[1]
	origin4[2] = ( distance[2] * que ) + origin1_F[2]

	static Float:velocity[3]
	velocity[0] = (origin4[0] - origin2_F[0]) * (get_pcvar_float(cvar[6]) / 1.666667)
	velocity[1] = (origin4[1] - origin2_F[1]) * (get_pcvar_float(cvar[6]) / 1.666667)
	velocity[2] = (origin4[2] - origin2_F[2]) * (get_pcvar_float(cvar[6]) / 1.666667)

	set_user_velocity(g_grab_player[id],velocity)

	return PLUGIN_CONTINUE
}