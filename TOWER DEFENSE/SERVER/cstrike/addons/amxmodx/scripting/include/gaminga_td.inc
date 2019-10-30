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
#define SQL_USER					"user"
#define SQL_PASS						"password"
#define SQL_TABLE					"table"

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