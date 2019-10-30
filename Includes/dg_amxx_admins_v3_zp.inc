#if defined _dg_amxx_admins_v3_zp_included
	#endinput
#endif
#define _dg_amxx_admins_v3_zp_included

enum _:structIdRanges {
	RANGE_STAFF = 0,
	RANGE_SUPERMOD,
	RANGE_MOD,
	RANGE_CAPTAIN,
	RANGE_DRUNK_GAMER,
	RANGE_DONADOR,
	RANGE_PLATINIUM,
	RANGE_PREMIUM
};

enum _:structRanges {
	rangePrefixName[24],
	rangeAccess[32],
	rangeFlag[8],
	rangeLevelFlag
};

new const RANGES[structIdRanges][structRanges] = {
	{"STAFF",			"abcdefghijklmnopqrstu",	"ab",		ADMIN_LEVEL_H},
	{"SUPERMOD",		"abcdefgijkmnopqrsu",		"ab",		ADMIN_LEVEL_G},
	{"MOD",				"abcdefgijkmnopqru",		"ab", 		ADMIN_LEVEL_F},
	{"CAPITAN",			"abcdefijmnopqu",			"ab",		ADMIN_LEVEL_E},
	{"DRUNK GAMER",		"abcdefijmnopu",			"a",		ADMIN_LEVEL_D},
	{"DONADOR",			"abcdefijmnou",				"a",		ADMIN_LEVEL_C},
	{"PLATINIUM",		"bmn",						"a",		ADMIN_LEVEL_B},
	{"VIP",				"bm",						"a",		ADMIN_LEVEL_A}
};