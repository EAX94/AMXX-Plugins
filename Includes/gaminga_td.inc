#include <amxmodx>
#include <amxmisc>
#include <engine>
#include <fakemeta_util>
#include <cstrike>
#include <hamsandwich>
#include <fun>
#include <orpheu>
#include <orpheu_memory>
#include <orpheu_stocks>
#include <dhudmessage>
#include <safemenu>
#include <cc>
#include <sqlx>
#include <unixtime>

#pragma semicolon					1

#define SQL_HOST					"127.0.0.1"
#define SQL_USER					"td"
#define SQL_PASS						"iq0wixEddYcPjoHz"
#define SQL_TABLE					"td"

enum _:bossCoords {
	__X = 0,
	__Y,
	__Z
};

enum _:mapStruct {
	mapName[32],
	mapDesc[32],
	mapBlock,
	mapAchievement,
	mapBossCoord
};