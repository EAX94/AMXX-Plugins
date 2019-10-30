// ------------------------------------
// NST Wpn Include File
// ------------------------------------

//##############################################################
// INFO PLUGIN
//##############################################################
#define NST_WPN_VERSION "3.0"
#define NST_WPN_AUTHOR "NST"
#define NST_WPN_NAME_RIFLES "NST Wpn Rifles"
#define NST_WPN_NAME_PISTOLS "NST Wpn Pistols"
#define NST_WPN_NAME_KNIFE "NST Wpn Knife"
#define NST_WPN_NAME_HE "NST Wpn HeGrenade"
#define NST_WPN_SETTING_FILE "nst_wpn.ini"
#define NST_WPN_LANG_FILE "nst_wpn.txt"
#define NST_MYWPN_SETTING_FILE "nst_mywpn.ini"


//##############################################################
// ENUM MAIN VALUE
//##############################################################
// weapon type
enum
{
	NST_WPN_RIFLES = 1,
	NST_WPN_PISTOLS,
	NST_WPN_KNIFE,
	NST_WPN_HE
}
// menu type
enum
{
	NST_MENUWPN_MAIN = 0,
	NST_MENUWPN_SHOP,
	NST_MENUWPN_MYWPN
}
// ini file
enum
{
	NST_WPN_INI_READ = 0,
	NST_WPN_INI_SAVE
}
// mod run
enum
{
	NST_MOD_DEFAULT = 1,
	NST_MOD_CSDM_SINGLE,
	NST_MOD_CSDM_TEAM,
	NST_MOD_ZB3,
	NST_MOD_ZBU,
	NST_MOD_ZBS,
	NST_MOD_HMS,
	NST_MOD_GHOST
}
// weapon anim
enum
{
	NST_ANI_KNIFE_ATTACK,
	NST_ANI_LIGHT_ATTACK,
	NST_ANI_SHOTGUN_RELOAD,
	NST_ANI_LAUNCHER_CHANGE,
	NST_ANI_LAUNCHER_SHOOT,
	NST_ANI_LAUNCHER_SHOOT_LAST,
	NST_ANI_M134_FIRE_READY,
	NST_ANI_M134_FIRE_AFTER,
	NST_ANI_M134_IDLE_CHANGE,
	NST_ANI_M134_FIRE_CHANGE,
	NST_ANI_FASTRUN_BEGIN,
	NST_ANI_FASTRUN_IDLE,
	NST_ANI_FASTRUN_END,
	NST_ANI_SIGHT_BEGIN,
	NST_ANI_SIGHT_END	
}
// data value
enum
{
	NST_WPN_DATA_HASWEAPON = 1,
	NST_WPN_DATA_KNOCKBACK,
	NST_WPN_DATA_GRAVITY,
	NST_WPN_DATA_FASTRUN,
	NST_WPN_DATA_RELOAD,
	NST_WPN_DATA_DEPLOY,
	NST_WPN_DATA_DAMAGE,
	NST_WPN_DATA_SPEED,
	NST_WPN_DATA_RECOIL
}
// damage type
enum
{
	NST_WPN_TYPEDAMAGE_NONE = 0,
	NST_WPN_TYPEDAMAGE_NADE
}


//##############################################################
// MAIN NATIVES
//##############################################################
// Tra ve ID nhom cua vu khi
native nst_get_weapon_type(weapon_id)

// Bot co quyen su dung vu khi moi hay khong (1:co - 0:khong)
native nst_bot_use_weapons()

// vu khi ton tai tren mat dat bao lau
native nst_weapons_stay()

// Tra ve ID cua che do dang choi
native nst_get_mod_runing()

// Kiem tra xem co phai vi tri Mua vu khi hay khong (1 la dung - 0 la khong)
native nst_get_user_buyzone(id)

// show chat text
native nst_color_saytext(player, const message[], any:...)

// set money for user
native nst_set_user_money(id, money)

// is user admin ?
native nst_is_user_admin(id)


//##############################################################
// WEAPON NATIVES
//##############################################################
// get free wpn
native nst_wpn_free()

// send anim weapons
native nst_wpn_send_weapon_anim(player, anim)

// dang cua sound attack
native nst_wpn_get_sound_attack()

// hien hud weapon pickup
native nst_wpn_show_weaponpickup(id, const weapon[])

// fake take damage
native nst_wpn_take_damage(attacker, victim, Float:damage, damage_type)

// kiem tra xem co the mua vu khi khong phai cua doi minh theo cac che do choi hay ko
native nst_wpn_get_canbuy_team_mod()

// kiem tra freezetime
native nst_wpn_get_freezetime()

// kiem tra mod dang choi co dung HTT ko
native nst_wpn_get_mod_has_supplybox()

// kiem tra xem co su dung chuc nang Kho Do khong?
native nst_wpn_mywpn()

// set full ammo
native nst_wpn_set_fullammo(id)
native nst_wpn_set_fullammo1(id)
native nst_wpn_set_fullammo2(id)

// give weapon
native nst_wpn_give_weapon(id, const weapon[])
native nst_wpn_give_weapon1(id, const weapon[])
native nst_wpn_give_weapon2(id, const weapon[])
native nst_wpn_give_weapon3(id, const weapon[])
native nst_wpn_give_weapon4(id, const weapon[])

// get user fastrun
native nst_wpn_get_user_fastrun(id)

// get anim of weapon when fastrun
native nst_wpn_get_fastrunanim_weapon(id, type)
native nst_wpn_get_fastrunanim_weapon1(id, type)
native nst_wpn_get_fastrunanim_weapon2(id, type)

// get config of nst wpn
native nst_wpn_get_int(id, data)
native nst_wpn_get_int1(id, data)
native nst_wpn_get_int2(id, data)
native nst_wpn_get_int3(id, data)
native nst_wpn_get_int4(id, data)
native Float:nst_wpn_get_float(id, data)
native Float:nst_wpn_get_float1(id, data)
native Float:nst_wpn_get_float2(id, data)
native Float:nst_wpn_get_float3(id, data)
native Float:nst_wpn_get_float4(id, data)

// get user fastrun
native nst_wpn_get_user_sight(id)
native nst_wpn_get_user_sight1(id)
native nst_wpn_get_user_sight2(id)


/**
 * Called when player buy Pistols and current weapon is fifles
 *
 * @param id	Player index
 */
forward nst_wpn_weapon_draw(id)


//##############################################################
// MY WEAPONS
//##############################################################
#define nst_mywpn_res_url "resource/ui/NSTWpn_MyWeapons.res"
#define nst_mywpn_res_url_ct "resource/ui/NSTWpn_MyWeapons_CT.res"
#define nst_mywpn_res_url_ter "resource/ui/NSTWpn_MyWeapons_TER.res"
#define nst_mywpn_res_img_search "//%i-weapon%i-img"
#define nst_mywpn_res_img_set "		^"image^"				^"gfx/vgui/%s^""
#define nst_mywpn_res_img_none "		^"image^"				^"gfx/vgui/noimg^""
#define nst_mywpn_res_team_search "//%i-weapon%i-team"
#define nst_mywpn_res_team_set "		^"image^"				^"resource/control/team%i^""
#define nst_mywpn_res_team_none "		^"image^"				^"resource/control/noimg^""
#define nst_mywpn_res_name_search "//%i-weapon%i-name"
#define nst_mywpn_res_name_set "		^"labelText^"			^"%s - %i$^""
#define nst_mywpn_res_name_none "		^"labelText^"			^"^""
#define nst_mywpn_res_bottom_search "//%i-weapon%i-bottom"
#define nst_mywpn_res_bottom_set "		^"command^"				^"nst_buy_mywpn %s^""
#define nst_mywpn_res_bottom_none "	^"command^"				^"^""
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1034\\ f0\\ fs16 \n\\ par }
*/
