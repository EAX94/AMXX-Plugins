#if defined __INCLUDED_BloodHunt
	#endinput
#endif

#define __INCLUDED_BloodHunt

/*
----------------
@ about
----------------

BloodHunt
Just another mod with experience levels and abilities.

by Shadows In Rain (aka SiR)
shadowsinrain@ya.ru

----------------
@ notes
----------------

Any handles starts from 1.
Zero indicates unitialized cell or invalid handle.

----------------
@ depedencies
----------------

This plugin uses AnyMAL.
Any AnyMAL feature NOT documented here, see AnyMAL includes for suggestions.

----------------
*/

#include <anymal>
#include <anymal_ids_c>

//==================================================================================================
// Primary integration
//==================================================================================================

// initialization order
#define IPM_BLOODHUNT "bloodhunt"

//==================================================================================================
// XP
//==================================================================================================

// Get/set total/collected player xp
native bh_xp_get(player, bool:total = false)
native bh_xp_set(player, xp, bool:total = false)

// Get player level.
native bh_xp_level_get(player, BHLVL:lvl)
const BHLVL:bh_c_lvl_current = BHLVL:0
const BHLVL:bh_c_lvl_min = BHLVL:1
const BHLVL:bh_c_lvl_max = BHLVL:2

// IDS: Experience multiplier, float.
#define IDS_BH_XP "bloodhunt/xp"

// IDS: Skills points bonus, integer.
#define IDS_BH_SP "bloodhunt/sp"

//==================================================================================================
// Abilities (skills)
//==================================================================================================

const bh_ability_name_len = 40

/*
Register new bility and get handle.
'botfriendly' is weight, not percentage. Zero indicates non-bot-friendly ability.
*/
native BHA:bh_ability_register(const name[], const description[], botfriendly = 100)

/*
Check ability is choosen by player or not.
*/
native bool:bh_ability_choosen(BHA:ability, player)

/*
Check ability is active for player or not.
*/
native bool:bh_ability_active(BHA:ability, player)

/*
Ability just activated or deactivated.
Activation possible when user alive only.
Actually abilities activated after respawn or forced (paid) reactivation.
*/
forward bh_ability_state_updated(BHA:ability, player, bool:active)

/*
Activate or deactivate ability.
*/
native bh_ability_state_change(BHA:ability, player, bool:active)

/*
Get total num of registered abilities.
Note: handles lies in range [1; count]
*/
native bh_abilities_count()

/*
Get name of registered ability.
*/
native bh_ability_get_name(BHA:ability, name[], len)

/*
Deactivate unchoosen abilities and activate choosen right now.
*/
native bh_abilities_reactivate(player)

//==================================================================================================
// Gold
//==================================================================================================

/*
Get/set amount of gold.
*/
native bh_gold_get(player)
native bh_gold_set(player, amount)

//==================================================================================================
// Database connection sharing and globals
//==================================================================================================

/*
Get AnyMAL database connection handle.
Avoid creating new connections, if your plugin is BH subplugin.
*/
native DBC:bh_dbc()

/*
Get current session id.
New session id generated each time server started.
*/
native bh_session()

/*
Any BH-related user data may be saved (via database).
Otherwise saving is strongly unrecommended.
*/
native bool:bh_user_saveable(player)

//==================================================================================================
// Menu sharing
//==================================================================================================

/*
Get BH menu handle.
See AnyMAL MB and MM for suggestions.
*/
native MBH:bh_menu_hook(BHM:menu)

/*
In this menu players can buy and sell something.
Consider using gold (10 000 $ in one, no max limit) rather than in-game money.
Injection type: single items.
*/
const BHM:bh_menu_shop = BHM:0

//==================================================================================================
// HUD sharing
//==================================================================================================

/*
Add your custom message to display now.
*/
forward bh_hud_processing(player)
native bh_hud_write(const text[])

//==================================================================================================
// Spawn control
//==================================================================================================

/*
Check current or set next respawn fake state.
On fake respawn, ability activation and xp consumation will be skipped, money will be frozen. After
respawn, state will be restored to normal. Returned always previous state.
*/
native bool:bh_fake_respawn(player, bool:activate = false)

//==================================================================================================