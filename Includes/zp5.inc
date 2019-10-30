#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <fakemeta_util>
#include <hamsandwich>
#include <engine>
#include <fun>
#include <xs>
#include <cc>
#include <unixtime>
#include <sqlx>
#include <dhudmessage>
#include <entity_maths>
#include <safemenu>

#define USE_ORPHEU

#if defined USE_ORPHEU
	#include <orpheu>
	#include <orpheu_stocks>
#endif

enum _:top15Struct {
	top15Name[32],
	top15URL[256]
};

new const TOPS15[][top15Struct] = {
	{"GENERAL", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15.php^"></head><body><p>Cargando...</p></body></html>"},
	{"ZOMBIES MATADOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_kill_zombies.php^"></head><body><p>Cargando...</p></body></html>"},
	{"HUMANOS MATADOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_kill_humans.php^"></head><body><p>Cargando...</p></body></html>"},
	{"HUMANOS INFECTADOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_infects.php^"></head><body><p>Cargando...</p></body></html>"},
	{"DISPAROS EN LA CABEZA", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_heads.php^"></head><body><p>Cargando...</p></body></html>"},
	{"DANYO", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_damage.php^"></head><body><p>Cargando...</p></body></html>"},
	{"COMBOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_combo.php^"></head><body><p>Cargando...</p></body></html>"},
	{"MAYOR COMBO", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_combo_max.php^"></head><body><p>Cargando...</p></body></html>"},
	{"NEMESIS MATADOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_nem_d.php^"></head><body><p>Cargando...</p></body></html>"},
	{"SURVIVOR MATADOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_surv_d.php^"></head><body><p>Cargando...</p></body></html>"},
	{"WESKER MATADOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_wesker_d.php^"></head><body><p>Cargando...</p></body></html>"},
	{"JASON MATADOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_jason_d.php^"></head><body><p>Cargando...</p></body></html>"},
	{"CABEZONES MATADOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_cabezon_d.php^"></head><body><p>Cargando...</p></body></html>"},
	{"ALIENS MATADOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_alien_d.php^"></head><body><p>Cargando...</p></body></html>"},
	{"DEPREDADORES MATADOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_pred_d.php^"></head><body><p>Cargando...</p></body></html>"},
	{"ANIQUILADORES MATADOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_anni_d.php^"></head><body><p>Cargando...</p></body></html>"},
	{"SNIPER MATADOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_sniper_d.php^"></head><body><p>Cargando...</p></body></html>"},
	{"ZOMBIES MATADOS CON HS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_kill_zombies_heads.php^"></head><body><p>Cargando...</p></body></html>"},
	{"ZOMBIES MATADOS CON CUCHILLO", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_kill_zombies_knife.php^"></head><body><p>Cargando...</p></body></html>"},
	{"TIEMPO JUGADO", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_time.php^"></head><body><p>Cargando...</p></body></html>"},
	{"AMULETOS CREADOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_am_crea.php^"></head><body><p>Cargando...</p></body></html>"},
	{"BALAS INFINITAS COMPRADAS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_count_unclip.php^"></head><body><p>Cargando...</p></body></html>"},
	{"CHALECO DESGARRADO", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_dmg_armor.php^"></head><body><p>Cargando...</p></body></html>"},
	{"LOGROS DESBLOQUEADOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_ach.php^"></head><body><p>Cargando...</p></body></html>"},
	{"DESAFYOS HECHOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_chall.php^"></head><body><p>Cargando...</p></body></html>"},
	{"DUELOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_duels.php^"></head><body><p>Cargando...</p></body></html>"},
	{"MEJORES AMULETOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_am.php^"></head><body><p>Cargando...</p></body></html>"},
	{"MEJOR HERMANDAD", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_guild.php^"></head><body><p>Cargando...</p></body></html>"},
	{"MODOS ESPECIALES MATADOS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_modos_esp_matados.php^"></head><body><p>Cargando...</p></body></html>"},
	{"ARMAS", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_weapons.php^"></head><body><p>Cargando...</p></body></html>"},
	{"MAYOR COMBO POR MAPA", "<html><head><style>body {background:#000;color:#FFF;</style><meta http-equiv=^"Refresh^" content=^"0;url=http://www.gaminga.com/servidores/counter-strike/27025/top15_combopermap.php^"></head><body><p>Cargando...</p></body></html>"}
};