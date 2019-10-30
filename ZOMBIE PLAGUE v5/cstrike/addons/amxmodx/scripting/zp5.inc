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
	{"GENERAL", "url"}
};