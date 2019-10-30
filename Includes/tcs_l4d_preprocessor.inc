/* ========================================
======== PREPROCESSOR =====================
======================================== */

#include <amxmodx>
#include <amxmisc>
#include <model_changer>
#include <dhudmessage>
#include <hamsandwich>
#include <unixtime>
#include <fakemeta_util>
#include <cstrike>
#include <engine>
#include <sqlx>
#include <fun>
#include <xs>
#include <orpheu>
#include <orpheu_memory>
#include <orpheu_stocks>

#pragma semicolon	1

#define AUTHOR		"Kiske"
#define VERSION		"v1.0"
#define PLUGIN_NAME	"Torneo ZP - L4D"

#define SQL_HOST		"127.0.0.1"
#define SQL_USER		"zp"
#define SQL_PASS		"zpg0g0tcs14!"
#define SQL_TABLE	"zp"

#define KEYS_MENU	MENU_KEY_1 | MENU_KEY_2 | MENU_KEY_3 | MENU_KEY_4 | MENU_KEY_5 | MENU_KEY_6 | MENU_KEY_7 | MENU_KEY_8 | MENU_KEY_9 | MENU_KEY_0

#define is_user_valid_connected(%1) (1 <= %1 <= g_maxplayers && is_user_connected(%1))
#define is_user_valid_alive(%1) (1 <= %1 <= g_maxplayers && is_user_alive(%1))

#define ID_SAVE			(taskid - TASK_SAVE)
#define ID_MODEL			(taskid - TASK_MODEL)
#define ID_SPAWN			(taskid - TASK_SPAWN)
#define ID_TEAM			(taskid - TASK_TEAM)
#define ID_SMOKER		(taskid - TASK_SMOKER)
#define ID_AURA			(taskid - TASK_AURA)
#define ID_SOUND			(taskid - TASK_SOUND)
#define ID_ADRENALINA	(taskid - TASK_ADRENALINA)

#define MODELS_DELAY		0.5

#define MAX_MODELS_ZOMBIES				sizeof(g_models_zombies) - 1
#define MAX_MODELS_ZOMBIES_T			sizeof(g_models_zombiesT) - 1
#define MAX_MODELS_SPECIAL_ZOMBIES	sizeof(g_models_special_zombies) - 1

#define MESSAGE_AA	"!g[TORNEO L4D]!y PresionÃ¡ !g+use!y (!gletra E!y) para vomitar"
#define MESSAGE_AB	"!g[TORNEO L4D]!y PresionÃ¡ !g+use!y (!gletra E!y) para tirar la lengua"
#define MESSAGE_AC	"!g[TORNEO L4D]!y TenÃ©s !gLongJump!y, recordÃ¡ que tu daÃ±o se multiplica x2"
#define MESSAGE_AD	"!g[TORNEO L4D]!y Ganaste 100 de vida por vomitar sobre un humano"
#define MESSAGE_AE	"!g[TORNEO L4D]!y PodrÃ¡s volver a vomitar en 20 segundos"
#define MESSAGE_AF	"!g[TORNEO L4D]!y PodrÃ¡s volver a lanzar tu lengua en 20 segundos"
#define MESSAGE_AG	"!g[TORNEO L4D]!y PodrÃ¡s usar tu longjump cada 7 segundos"
#define MESSAGE_AH	"!g[ZP]!y Bienvenido !g%s!y, eres la cuenta registrada nÃºmero !g%s!y"
#define MESSAGE_AI	"No podÃ©s cambiarte el nombre dentro del servidor"
#define MESSAGE_AJ	"No podÃ©s entrar como humano"
#define MESSAGE_AK	"No podÃ©s elegir la opcion auto-selecciÃ³n"
#define MESSAGE_AL	"No podÃ©s entrar de espectador"
#define MESSAGE_AM	"Tu nombre debe superar los 3 caracteres"
#define MESSAGE_AN	"La contraseÃ±a debe tener al menos 4 caracteres"
#define MESSAGE_AO	"La contraseÃ±a no puede superar los 31 caracteres"
#define MESSAGE_AP	"Escribe la contraseÃ±a nuevamente para su confirmaciÃ³n"
#define MESSAGE_AQ	"La contraseÃ±a no coincide con la anterior"
#define MESSAGE_AR	"Se ha registrado exitosamente!"
#define MESSAGE_AS	"La contraseÃ±a no coincide con la registrada"
#define MESSAGE_AT	"Bienvenido a Taringa! CS, %s"
#define MESSAGE_AU	"Este nombre de usuario ya estÃ¡ registrado"
#define MESSAGE_AV	"Escribe tu contraseÃ±a"
#define MESSAGE_AW	"No podÃ©s identificarte con un nombre de usuario que no estÃ¡ registrado"
#define MESSAGE_AX	"Escribe la contraseÃ±a que protege esta cuenta para identificarte"
#define MESSAGE_AY	"!g[TORNEO L4D]!y PresionÃ¡ !g+use!y (!gletra E!y) para escupir tu Ã¡cido"
#define MESSAGE_AZ	"!g[TORNEO L4D]!y Ganaste 100 de vida por escupir tu Ã¡cido sobre un humano"
#define MESSAGE_BA	"!g[TORNEO L4D]!y Salta a la cabeza de un humano para controlar sus movimientos"
#define MESSAGE_BB	"!g[TORNEO L4D]!y PodrÃ¡s volver a cargar en 20 segundos"
#define MESSAGE_BC	"!g[TORNEO L4D]!y PresionÃ¡ !g+use!y (!gletra E!y) para cargar contra alguien"
#define MESSAGE_BD	"!g[TORNEO L4D]!y Ahora estÃ¡s en la lista de espera para ser un zombie especial"
#define MESSAGE_BE	"!g[TORNEO L4D]!y Zombies reviven: !g%s!y"
#define MESSAGE_BF	"!g[!yAtaque Inminente!g]!y"
#define MESSAGE_BG	"!g[TORNEO L4D]!y PresionÃ¡ !g+use!y (!gletra E!y) para lanzar una roca"
#define MESSAGE_BH	"!g[TORNEO L4D]!y Eres una Witch, te volverÃ¡s furiosa cuando te disparen o esten cerca tuyo"
#define MESSAGE_BI	"!g[TORNEO L4D]!y Un compaÃ±ero tuyo esta en peligro, ve a salvarlo!"
#define MESSAGE_BJ	"!g[TORNEO L4D - KISKE]!y Se ha desconectado el tank"
#define MESSAGE_BK	"!g[TORNEO L4D - KISKE]!y Se ha desconectado la witch"
#define MESSAGE_BL	"!g[TORNEO L4D]!y La ronda comenzarÃ¡ en 5 segundos, preparados!"
#define MESSAGE_BM	"!g[TORNEO L4D]!y RecordÃ¡ que luego de empezar la ronda o comprar tus armas, no podrÃ¡s tirar las armas!"
#define MESSAGE_BN	"!g[TORNEO L4D]!y Asi que elegi tus armas con cuidado"
#define MESSAGE_BO	"No podÃ©s entrar como zombie"
#define MESSAGE_BP	"!g[TORNEO L4D]!y Escribi en el chat !g/weap!y para elegir tu arma secundaria"
#define MESSAGE_BQ	"!g[TORNEO L4D]!y El refugio se ha abierto y los humanos ya pueden entrar!"
#define MESSAGE_BR	"!g[TORNEO L4D]!y Has entrado en el refugio y estÃ¡s a salvo!"
#define MESSAGE_BS	"!g[TORNEO L4D]!y %s entrÃ³ en el refugio y estÃ¡ a salvo!"