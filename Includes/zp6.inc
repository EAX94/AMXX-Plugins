#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <fakemeta_util>
#include <hamsandwich>
#include <engine>
#include <fun>
#include <xs>
#include <cc> // Es el colorchat.
#include <unixtime>
#include <sqlx>
#include <dhudmessage>
#include <entity_maths>
#include <safemenu>
#include <orpheu>
#include <orpheu_stocks>
#include <cs_team_changer>

/*
	CHANGELOG:
	
	v6.0.05 (10/05/2015) :
		[FIX] Se arregló un problema con el combo que se cortaba cuando mataban a un miembro zombie del grupo.
		[FIX] Se arregló un problema relacionado con algunos logros.
		
	
	v6.0.03 (09/05/2015) :
		[FIX] El modo Alien vs Depredador ya funciona correctamente.
		
		[MOD] Ahora cuando haces combo grupal, tu combo individual se suma a tus estadísticas y al combo máximo, también aparece cuanto hiciste vos como guías.
		[MOD] Ahora la recompensa del combo grupal es el 100% para todos los integrantes, en vez de 50% y 33% como antes.
	
	v6.0 (08/05/2015) :
		Versión lanzada oficialmente!
	
	v6.0 BETA (12/04/2015) :
		[FIX] Algunos errores relacionados al Grupo.
		[FIX] Velocidad de disparo de las armas.
		[FIX] Algunos errores relacionados a la información del Clan.
		[FIX] El porcentaje de revivir como humano ahora funciona correctamente.
		[FIX] Los menúes gorros, clases zombie y clases humanas deberían mostrar correctamente que tenes elegido/equipado.
		[FIX] El Primer Zombie ya no debería tener inmunidad a las bombas luego de infectar un humano.
		[FIX] Errores varios relacionados al arma ES P90.
		[FIX] La bazooka del Nemesis ya no afecta a modos especiales.
		[FIX] La información del HUD cuando especteas a otro usuario.
		[FIX] Los zombies que no volvían a aparecer cuando estaban trabados con otro.
		[FIX] La posición del misil de la bazooka cuando está en el aire.
		[FIX] Aura roja de la furia zombie cuando comprás antidoto. 
		
		[MOD] Se bloqueó la radio y otros comandos similares.
		[MOD] Se aumentó el daño hecho por el Jason.
		[MOD] Se aumentó la ganancia de ammo packs por combo hecho desde los niveles 1 a 250 del reset 1.
		[MOD] Se movió de lugar el % del nivel completado en el menú de estadísticas de las armas para que se entienda mejor.
	
	v6.0 BETA (04/04/2015) :
		Versión lanzada!
*/

#pragma dynamic	131072
#pragma semicolon 1

#define SQL_HOST		"127.0.0.1"
#define SQL_USER		"user"
#define SQL_PASS		"password"
#define SQL_TABLE		"table"

new const g_MODEL_Nemesis_Knife[] = "models/zp5/gk_claws_nem.mdl";
new const g_MODEL_Bubble[] = "models/zp_tcs/bubble_aura.mdl";
new const g_MODEL_Nemesis[] = "tcs_nemesis_1";
new const g_MODEL_Survivor[] = "gk_survivor_01";
new const g_MODEL_Wesker[] = "gk_humano_05";
new const g_MODEL_Jason[] = "tcs_jason_1";
new const g_MODEL_Troll[] = "tcs_zombie_10";
new const g_MODEL_Alien[] = "tcs_alien_1";
new const g_MODEL_Predator[] = "tcs_predator_1";
new const g_MODEL_Combo_View[] = "models/zp6/gk_combo_v.mdl";
new const g_MODEL_Combo_World[] = "models/zp6/gk_combo_w.mdl";
new const g_MODEL_Frost[] = "models/zombie_plague/v_grenade_frost.mdl";
new const g_MODEL_Flare[] = "models/zombie_plague/v_grenade_flare.mdl";
new const g_MODEL_Bubble_View[] = "models/zp5/gk_sgbomb_pro.mdl";
new const g_MODEL_Bubble_World[] = "models/zp5/gk_w_sgbomb_pro.mdl";
new const g_MODEL_Infection[] = "models/zombie_plague/v_grenade_infect.mdl";
new const g_MODEL_Supernova_View[] = "models/zp6/gk_nova_v.mdl";
new const g_MODEL_Supernova_World[] = "models/zp6/gk_nova_w.mdl";
new const g_MODEL_Box[] = "models/zp6/w_box_l.mdl"; // Usarla en algún lado...
new const g_MODEL_Chainsaw[][] = {"models/zp5/v_chainsaw.mdl", "models/zp5/p_chainsaw.mdl"};
new const g_MODEL_Rocket[] = "models/zombie_plague/tcs_rocket_1.mdl";
new const g_MODEL_Troll_Knife[] = "models/zombie_plague/tcs_garras_8.mdl";
new const g_MODEL_Alien_Knife[] = "models/zombie_plague/tcs_garras_19.mdl";
new const g_MODEL_Bazooka_View[] = "models/zombie_plague/tcs_v_bazooka.mdl";
new const g_MODEL_Bazooka_Player[] = "models/zombie_plague/tcs_p_bazooka.mdl";

new const g_SOUND_ButtonOk[] = "buttons/button9.wav";
new const g_SOUND_ButtonBad[] = "buttons/button2.wav";
new const g_SOUND_BubbleOn[] = "buttons/button1.wav";
new const g_SOUND_Antidote[] = "items/smallmedkit1.wav";
new const g_SOUND_Grenade_Infection[] = "zombie_plague/grenade_infect.wav";
new const g_SOUND_Grenade_Explosion[] = "zombie_plague/grenade_explode.wav";
new const g_SOUND_Grenade_Frost[] = "warcraft3/frostnova.wav";
new const g_SOUND_Grenade_Frost_Break[] = "warcraft3/impalelaunch1.wav";
new const g_SOUND_Grenade_Frost_Player[] = "warcraft3/impalehit.wav";
new const g_SOUND_NewKnife[][] = {"weapons/knife_deploy1.wav", "zp6/strider_hit1.wav", "zp6/strider_hit2.wav", "zp6/strider_hit1.wav", "zp6/strider_hit2.wav", "zp6/strider_hitwall.wav", "zp6/strider_slash1.wav", "zp6/strider_slash2.wav", "zp6/strider_stab.wav"};
new const g_SOUND_Knife_Default[][] = {"weapons/knife_deploy1.wav", "weapons/knife_hit1.wav", "weapons/knife_hit2.wav", "weapons/knife_hit3.wav", "weapons/knife_hit4.wav", "weapons/knife_hitwall1.wav", "weapons/knife_slash1.wav", "weapons/knife_slash2.wav", "weapons/knife_stab.wav"};
new const g_SOUND_Hands[][] = {"weapons/knife_deploy1.wav", "hero/box_hand_hit_01.wav", "hero/box_hand_hit_02.wav", "hero/box_hand_hit_03.wav", "hero/box_hand_wall_00.wav", "hero/box_hand_wall_01.wav", "hero/box_hand_slash.wav", "hero/box_hand_slash.wav", "hero/box_hand_hit_02.wav"};
new const g_SOUND_Sword[][] = {"zp6/gk_sword_deploy.wav", "zp6/gk_sword_hit.wav", "zp6/gk_sword_hit.wav", "zp6/gk_sword_hit.wav", "zp6/gk_sword_hitwall.wav", "zp6/gk_sword_hitwall.wav", "zp6/gk_sword_slash.wav", "zp6/gk_sword_slash.wav", "zp6/gk_sword_stab.wav"};
new const g_SOUND_Axes[][] = {"weapons/knife_deploy1.wav", "zp6/gk_axe_hit1.wav", "zp6/gk_axe_hit1.wav", "zp6/gk_axe_hit1.wav", "zp6/gk_axe_hitwall.wav", "zp6/gk_axe_hitwall.wav", "zp6/gk_axe_slash.wav", "zp6/gk_axe_slash.wav", "zp6/gk_axe_hit1.wav"};
new const g_SOUND_Power_Start[] = "zp6/powerup_start.wav";
new const g_SOUND_Power_Finish[] = "zp6/powerup_finish.wav";
new const g_SOUND_Chainsaw[][] = {"zombie_plague/tcs_cs_deploy.wav", "zombie_plague/tcs_cs_hit1.wav", "zombie_plague/tcs_cs_hit2.wav", "zombie_plague/tcs_cs_hit1.wav", "zombie_plague/tcs_cs_hit2.wav", "zombie_plague/tcs_cs_hitwall.wav", "zombie_plague/tcs_cs_miss.wav",
"zombie_plague/tcs_cs_miss.wav", "zombie_plague/tcs_cs_stab.wav"};
new const g_SOUND_Bazooka[][] = {"weapons/rocketfire1.wav", "zombie_plague/bazooka_01.wav"};
new const g_SOUND_Electro[] = "weapons/electro5.wav";
new const g_SOUND_Level_Up[] = "zp6/gk_lvl_up.wav";
new const g_SOUND_Grenade_Flare[] = "zp5/flare_light.wav";
new const g_SOUND_Mode_Assassin[] = "zp5/gk_assasin.wav";
new const g_SOUND_Modes[][] = {"zp5/gk_mode_01.wav", "zp5/mode_00.wav", "zp6/gk_mode_03.wav", "zp6/gk_mode_09.wav", "zombie_plague/survivor1.wav", "zombie_plague/survivor2.wav"};
new const g_SOUND_Grenade_Pipe[] = "zp5/gk_pipe.wav";
new const g_SOUND_Mode_DuelFinal[] = "zp5/warning.wav";
new const g_SOUND_Zombie_Death[][] = {"zp5/zombie_death_00.wav", "zombie_plague/tcs_zombie_die_1.wav", "zombie_plague/zombie_die1.wav", "zombie_plague/zombie_die2.wav", "zombie_plague/zombie_die3.wav", "zombie_plague/zombie_die4.wav", "zombie_plague/zombie_die5.wav"};
new const g_SOUND_Zombie_Madness[] = "zombie_plague/zombie_madness1.wav";
new const g_SOUND_Zombie_Knife[][] = {"zombie_plague/tcs_claw_attack_1.wav", "zombie_plague/tcs_claw_attack_2.wav", "zombie_plague/tcs_claw_1.wav"};
new const g_SOUND_Zombie_Infect[][] = {"zp5/zombie_infect_04.wav", "zp5/zombie_infect_05.wav", "zombie_plague/tcs_zombie_infect_1.wav", "zombie_plague/tcs_zombie_infect_2.wav", "zombie_plague/tcs_zombie_infect_3.wav", "zombie_plague/zombie_infec1.wav",
"zombie_plague/zombie_infec2.wav", "zombie_plague/zombie_infec3.wav"};
new const g_SOUND_ArmageddonOP[] = "sound/zp6/gk_sound_op.mp3";
new const g_SOUND_Armageddon[] = "zombie_plague/tcs_sirena_2.wav";
new const g_SOUND_Zombie_Alert[][] = {"zombie_plague/tcs_alert_1.wav", "zombie_plague/tcs_alert_2.wav", "zombie_plague/tcs_alert_3.wav"};
new const g_SOUND_Zombie_Pain[][] = {"zombie_plague/zombie_pain_1.wav", "zombie_plague/zombie_pain_2.wav", "zombie_plague/zombie_pain1.wav", "zombie_plague/zombie_pain2.wav", "zombie_plague/zombie_pain3.wav", "zombie_plague/zombie_pain4.wav", "zombie_plague/zombie_pain5.wav"};
new const g_SOUND_SurvivorPlayer07[] = "zombie_plague/survivor_by_player07.wav";
new const g_SOUND_Mode_Nemesis[][] = {"zombie_plague/nemesis1.wav", "zombie_plague/nemesis2.wav", "zp6/gk_nemesis_player07.wav"};
new const g_SOUND_Win_Humans[] = "zombie_plague/tcs_win_humans_4.wav";
new const g_SOUND_Win_Zombies[] = "zombie_plague/tcs_win_zombies_4.wav";
new const g_SOUND_Win_NoOne[] = "ambience/3dmstart.wav";

new g_SPRITE_Regeneration;
new g_SPRITE_Trail;
new g_SPRITE_Shockwave;
new g_SPRITE_Glass;
new g_SPRITE_TrailBombs;
new g_SPRITE_NovaExplode;
new g_SPRITE_Explosion;
new g_SPRITE_Beam;
new g_SPRITE_ColorBall[8];

enum _:top15Struct {
	top15Name[32],
	top15URL[256]
};

enum _:mapsStruct {
	mapName[32],
	Float:mapMultAPs,
	mapExtraHealth
};

new const __MAPS[][mapsStruct] = {
	{"zm_kontrax_b6", 0.0, 15}
};

new const Float:g_WEAPONS_Damage_Needed[31][21] = {
	{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	{500.0, 1000.0, 2500.0, 50000.0, 100000.0, 250000.0, 500000.0, 1000000.0, 1500000.0, 2000000.0, 2500000.0, 3000000.0, 3500000.0, 4000000.0, 4500000.0, 5000000.0, 6000000.0, 7000000.0, 8000000.0, 10000000.0, 2100000000.0}, // P228
	{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	{5000.0, 6500.0, 8000.0, 100000.0, 250000.0, 400000.0, 600000.0, 1000000.0, 1400000.0, 2000000.0, 2800000.0, 3600000.0, 4400000.0, 5200000.0, 6000000.0, 7000000.0, 8500000.0, 10000000.0, 15000000.0, 20000000.0, 2100000000.0}, // XM1014
	{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	{500.0, 1000.0, 2500.0, 50000.0, 100000.0, 250000.0, 500000.0, 1000000.0, 1500000.0, 2000000.0, 2500000.0, 3000000.0, 3500000.0, 4000000.0, 4500000.0, 5000000.0, 6000000.0, 7000000.0, 8000000.0, 10000000.0, 2100000000.0}, // MAC10
	{6000.0, 12000.0, 25000.0, 450000.0, 650000.0, 1000000.0, 1350000.0, 1750000.0, 2500000.0, 3500000.0, 4500000.0, 6000000.0, 8000000.0, 10000000.0, 15000000.0, 30000000.0, 50000000.0, 100000000.0, 250000000.0, 500000000.0, 2100000000.0}, // AUG
	{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	{500.0, 1000.0, 2500.0, 50000.0, 100000.0, 250000.0, 500000.0, 1000000.0, 1500000.0, 2000000.0, 2500000.0, 3000000.0, 3500000.0, 4000000.0, 4500000.0, 5000000.0, 6000000.0, 7000000.0, 8000000.0, 10000000.0, 2100000000.0}, // ELITE
	{500.0, 1000.0, 2500.0, 50000.0, 100000.0, 250000.0, 500000.0, 1000000.0, 1500000.0, 2000000.0, 2500000.0, 3000000.0, 3500000.0, 4000000.0, 4500000.0, 5000000.0, 6000000.0, 7000000.0, 8000000.0, 10000000.0, 2100000000.0}, // FIVESEVEN
	{500.0, 1000.0, 2500.0, 50000.0, 100000.0, 250000.0, 500000.0, 1000000.0, 1500000.0, 2000000.0, 2500000.0, 3000000.0, 3500000.0, 4000000.0, 4500000.0, 5000000.0, 6000000.0, 7000000.0, 8000000.0, 10000000.0, 2100000000.0}, // UMP45
	{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}, // SG550
	{6000.0, 12000.0, 25000.0, 450000.0, 650000.0, 1000000.0, 1350000.0, 1750000.0, 2500000.0, 3500000.0, 4500000.0, 6000000.0, 8000000.0, 10000000.0, 15000000.0, 30000000.0, 50000000.0, 100000000.0, 250000000.0, 500000000.0, 2100000000.0}, // GALIL
	{6000.0, 12000.0, 25000.0, 450000.0, 650000.0, 1000000.0, 1350000.0, 1750000.0, 2500000.0, 3500000.0, 4500000.0, 6000000.0, 8000000.0, 10000000.0, 15000000.0, 30000000.0, 50000000.0, 100000000.0, 250000000.0, 500000000.0, 2100000000.0}, // FAMAS
	{500.0, 1000.0, 2500.0, 50000.0, 100000.0, 250000.0, 500000.0, 1000000.0, 1500000.0, 2000000.0, 2500000.0, 3000000.0, 3500000.0, 4000000.0, 4500000.0, 5000000.0, 6000000.0, 7000000.0, 8000000.0, 10000000.0, 2100000000.0}, // USP
	{500.0, 1000.0, 2500.0, 50000.0, 100000.0, 250000.0, 500000.0, 1000000.0, 1500000.0, 2000000.0, 2500000.0, 3000000.0, 3500000.0, 4000000.0, 4500000.0, 5000000.0, 6000000.0, 7000000.0, 8000000.0, 10000000.0, 2100000000.0}, // GLOCK18
	{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	{6000.0, 12000.0, 25000.0, 450000.0, 650000.0, 1000000.0, 1350000.0, 1750000.0, 2500000.0, 3500000.0, 4500000.0, 6000000.0, 8000000.0, 10000000.0, 15000000.0, 30000000.0, 50000000.0, 100000000.0, 250000000.0, 500000000.0, 2100000000.0}, // MP5NAVY
	{6000.0, 12000.0, 25000.0, 450000.0, 650000.0, 1000000.0, 1350000.0, 1750000.0, 2500000.0, 3500000.0, 4500000.0, 6000000.0, 8000000.0, 10000000.0, 15000000.0, 30000000.0, 50000000.0, 100000000.0, 250000000.0, 500000000.0, 2100000000.0}, // M249
	{500.0, 1000.0, 2500.0, 50000.0, 100000.0, 250000.0, 500000.0, 1000000.0, 1500000.0, 2000000.0, 2500000.0, 3000000.0, 3500000.0, 4000000.0, 4500000.0, 5000000.0, 6000000.0, 7000000.0, 8000000.0, 10000000.0, 2100000000.0}, // M3
	{6000.0, 12000.0, 25000.0, 450000.0, 650000.0, 1000000.0, 1350000.0, 1750000.0, 2500000.0, 3500000.0, 4500000.0, 6000000.0, 8000000.0, 10000000.0, 15000000.0, 30000000.0, 50000000.0, 100000000.0, 250000000.0, 500000000.0, 2100000000.0}, // M4A1
	{500.0, 1000.0, 2500.0, 50000.0, 100000.0, 250000.0, 500000.0, 1000000.0, 1500000.0, 2000000.0, 2500000.0, 3000000.0, 3500000.0, 4000000.0, 4500000.0, 5000000.0, 6000000.0, 7000000.0, 8000000.0, 10000000.0, 2100000000.0}, // TMP
	{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	{500.0, 1000.0, 2500.0, 50000.0, 100000.0, 250000.0, 500000.0, 1000000.0, 1500000.0, 2000000.0, 2500000.0, 3000000.0, 3500000.0, 4000000.0, 4500000.0, 5000000.0, 6000000.0, 7000000.0, 8000000.0, 10000000.0, 2100000000.0}, // DEAGLE
	{6000.0, 12000.0, 25000.0, 450000.0, 650000.0, 1000000.0, 1350000.0, 1750000.0, 2500000.0, 3500000.0, 4500000.0, 6000000.0, 8000000.0, 10000000.0, 15000000.0, 30000000.0, 50000000.0, 100000000.0, 250000000.0, 500000000.0, 2100000000.0}, // SG552
	{6000.0, 12000.0, 25000.0, 450000.0, 650000.0, 1000000.0, 1350000.0, 1750000.0, 2500000.0, 3500000.0, 4500000.0, 6000000.0, 8000000.0, 10000000.0, 15000000.0, 30000000.0, 50000000.0, 100000000.0, 250000000.0, 500000000.0, 2100000000.0}, // AK47
	{1000.0, 2500.0, 5000.0, 75000.0, 100000.0, 150000.0, 200000.0, 250000.0, 300000.0, 400000.0, 500000.0, 600000.0, 700000.0, 1000000.0, 1500000.0, 2000000.0, 2500000.0, 3000000.0, 5000000.0, 7500000.0, 2100000000.0}, // CUCHILLO
	{500.0, 1000.0, 2500.0, 50000.0, 100000.0, 250000.0, 500000.0, 1000000.0, 1500000.0, 2000000.0, 2500000.0, 3000000.0, 3500000.0, 4000000.0, 4500000.0, 5000000.0, 6000000.0, 7000000.0, 8000000.0, 10000000.0, 2100000000.0} // P90
};

enum _:weaponModelStruct {
	weaponModelLevel,
	weaponModelPath[64]
};

new const g_WEAPONS_Models[][][weaponModelStruct] = {
	{{99, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}},
	{{1, "models/zp5/gk_p228_00.mdl"}, {5, "models/zp6/gk_p228_00.mdl"}, {99, ""}, {99, ""}, {99, ""}, {99, ""}, {99, ""}, {99, ""}}, // P228
	{{99, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}}, // SHIELD
	{{99, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}}, // SCOUT
	{{99, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}}, // HEGRENADE
	{{1, "models/zp_tcs/v_xm1014_ff.mdl"}, {3, "models/tcs_xm1014_1/v_tcs_xm1014_1.mdl"}, {7, "models/zp6/gk_xm1014_00.mdl"}, {12, "models/zp6/gk_xm1014_01.mdl"}, {17, "models/zp6/gk_xm1014_02.mdl"}, {99, ""}, {99, ""}, {99, ""}}, // XM1014
	{{99, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}}, // C4
	{{1, "models/zp5/gk_mac10_00.mdl"}, {5, "models/zp6/gk_mac10_00.mdl"}, {99, ""}, {99, ""}, {99, ""}, {99, ""}, {99, ""}, {99, ""}}, // MAC10
	{{1, "models/zp5/gk_aug_01.mdl"}, {3, "models/zp5/gk_aug_00.mdl"}, {7, "models/zp6/gk_aug_00.mdl"}, {12, "models/zp6/gk_aug_01.mdl"}, {17, "models/zp6/gk_aug_02.mdl"}, {99, ""}, {99, ""}, {99, ""}}, // AUG
	{{99, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}}, // SMOKEGRENADE
	{{2, "models/zp5/gk_elite_00.mdl"}, {5, "models/zp6/gk_elite_01.mdl"}, {10, "models/zp6/gk_elite_00.mdl"}, {99, ""}, {99, ""}, {99, ""}, {99, ""}, {99, ""}}, // ELITE
	{{99, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}}, // FIVESEVEN
	{{5, "models/zp6/gk_ump45_00.mdl"}, {99, ""}, {99, ""}, {99, ""}, {99, ""}, {99, ""}, {99, ""}, {99, ""}}, // UMP45
	{{99, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}}, //  SG550 (AUTOMÁTICA)
	{{2, "models/zp5/gk_galil_01.mdl"}, {5, "models/zp6/gk_galil_02.mdl"}, {10, "models/zp6/gk_galil_00.mdl"}, {16, "models/zp6/gk_galil_01.mdl"}, {99, ""}, {99, ""}, {99, ""}, {99, ""}}, // GALIL
	{{2, "models/zp5/gk_famas_01.mdl"}, {4, "models/zp5/gk_famas_00.mdl"}, {10, "models/zp6/gk_famas_01.mdl"}, {14, "models/zp6/gk_famas_00.mdl"}, {18, "models/zp6/gk_famas_02.mdl"}, {99, ""}, {99, ""}, {99, ""}}, // FAMAS
	{{2, "models/zp5/gk_usp_00.mdl"}, {4, "models/zp5/gk_usp_01.mdl"}, {7, "models/zp6/gk_usp_00.mdl"}, {99, ""}, {99, ""}, {99, ""}, {99, ""}, {99, ""}}, // USP
	{{5, "models/zp6/gk_glock_00.mdl"}, {99, ""}, {99, ""}, {99, ""}, {99, ""}, {99, ""}, {99, ""}, {99, ""}}, // GLOCK18
	{{99, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}},  // AWP
	{{1, "models/zp_tcs/v_mp5.mdl"}, {5, "models/zp6/gk_mp5_00.mdl"}, {10, "models/zp6/gk_mp5_01.mdl"}, {99, ""}, {99, ""}, {99, ""}, {99, ""}, {99, ""}}, // MP5NAVY
	{{99, "models/zp_tcs/v_m249.mdl"}, {99, "models/zp6/gk_m249_00.mdl"}, {99, ""}, {99, ""}, {99, ""}, {99, ""}, {99, ""}, {99, ""}}, // M249
	{{1, "models/zp5/gk_m3_00.mdl"}, {4, "models/zp5/gk_m3_01.mdl"}, {7, "models/zp6/gk_m3_00.mdl"}, {12, "models/zp6/gk_m3_02.mdl"}, {17, "models/zp6/gk_m3_01.mdl"}, {99, ""}, {99, ""}, {99, ""}}, // M3
	{{2, "models/tcs_colt_2/v_tcs_colt_2.mdl"}, {4, "models/zp6/gk_m4a1_02.mdl"}, {7, "models/zp6/gk_m4a1_01.mdl"}, {10, "models/zp6/gk_m4a1_00.mdl"}, {13, "models/zp6/gk_m4a1_03.mdl"}, {17, "models/zp5/gk_m4a1_01.mdl"}, {99, ""}, {99, ""}}, // M4A1
	{{99, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}}, // TMP
	{{99, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}}, // G3SG1
	{{99, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}}, // FLASHBANG
	{{1, "models/zp5/gk_deagle_01.mdl"}, {4, "models/zp5/gk_deagle_02.mdl"}, {8, "models/zp6/gk_deagle_00.mdl"}, {99, ""}, {99, ""}, {99, ""}, {99, ""}, {99, ""}}, // DEAGLE
	{{1, "models/zp5/gk_sg552_00.mdl"}, {4, "models/zp_tcs/v_sg552_2.mdl"}, {7, "models/zp5/gk_sg552_01.mdl"}, {11, "models/zp6/gk_sg552_01.mdl"}, {15, "models/zp6/gk_sg552_00.mdl"}, {99, ""}, {99, ""}, {99, ""}}, // SG552
	{{1, "models/zp5/gk_ak47_00.mdl"}, {3, "models/zp_tcs/v_ak47.mdl"}, {5, "models/zp5/gk_ak47_02.mdl"}, {7, "models/zp5/gk_ak47_01.mdl"}, {10, "models/zp6/gk_ak47_02.mdl"}, {14, "models/zp6/gk_ak47_01.mdl"}, {18, "models/zp6/gk_ak47_00.mdl"}, {99, ""}}, // AK47
	{{0, "models/zp6/gk_knife_02.mdl"}, {2, "models/zp6/gk_knife_00.mdl"}, {4, "models/zp6/gk_knife_03.mdl"}, {7, "models/zp6/gk_knife_01.mdl"}, {11, "models/zp6/gk_knife_04.mdl"}, {16, "models/zp6/gk_knife_05.mdl"}, {99, ""}, {99, ""}}, // CUCHILLO
	{{99, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}, {0, ""}} // P90
};