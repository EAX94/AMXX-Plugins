/*
*	RPGx AMX Mod X Plugin - Scripting Include File
*	Copyright (C) 2009 by roflmao456
*
*	This file is part of RPGx.
*
*	RPGx is free software: you can redistribute it and/or modify
*	it under the terms of the GNU General Public License as published by
*	the Free Software Foundation, either version 3 of the License, or
*	(at your option) any later version.
*
*	RPGx is distributed in the hope that it will be useful,
*	but WITHOUT ANY WARRANTY; without even the implied warranty of
*	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*	GNU General Public License for more details.
*
*	You should have received a copy of the GNU General Public License
*	along with RPGx.  If not, see <http://www.gnu.org/licenses/>.
*/

#if defined _rpgx_included
  #endinput
#endif
#define _rpgx_included

/**
 * Registers a new upgrade for usage in RPGx.
 * 
 * @param	name		Name of the upgrade
 * @param	maxlevel	Maximum level for the upgrade
 * @param	cost		Starting cost for the upgrade
 * @param	icost		Added to the starting cost every level
 * 
 * @return	A useful Upgrade ID to detect events.
*/
native RPGx_MakeUpgrade(const name[], maxlevel, cost, icost);

/**
 * Gets the player's spawn health.
 * 
 * @param	player	Player index
 *
 * @return	The player's spawn health
*/
native RPGx_GetSpawnHealth(player);

/**
 * Sets the player's spawn health.
 * 
 * @param	player	Player index
 * @param	health	Amount of health to set
*/
native RPGx_SetSpawnHealth(player, health = 100);

/**
 * Retrieves a player's upgrade level.
 * 
 * @param	player	Player index
 * @param	upgrade	Upgrade ID
 * 
 * @return	The player's upgrade level; If Upgrade ID is invalid, -1.
*/
native RPGx_GetUpgradeLevel(player, upgrade);

/**
 * Retrieves an upgrade's max level.
 * 
 * @param	upgrade	Upgrade ID
 * 
 * @return	The upgrade's max level; If Upgrade ID is invalid, -1.
*/
native RPGx_GetUpgradeMaxLevel(upgrade);

/**
 * Locks the player to their current position
 * 
 * @param	player	Player index
 * @param	freeze	True to freeze, False to unfreeze
*/
native RPGx_Freeze(player, bool:freeze = true);

/**
 * Retrieves a player's "frozen" state
 * 
 * @param	player	Player index
 * 
 * @return	True if the user is frozen; False otherwise.
*/
native bool:RPGx_IsFrozen(player);

/**
 * Retrieves the amount of the player's experience points
 * 
 * @param	player	Player index
 * 
 * @return	Amount of the player's experience points
*/
native RPGx_GetXP(player);

/**
* Retrieves the player's level
* 
* @param	player	Player index
* 
* @return	The player's current level based on their experience points
*/
native RPGx_GetLevel(player);

/**
* Retrieves the amount of credits a player has
* 
* @param	player	Player index
* 
* @return	The player's current amount of credits
*/
native RPGx_GetCredits(player);


/**
 * Called when RPGx is fully initialized.
 * 
 * @note This is where you should register your upgrades.
 */
forward RPGx_OnPluginReady();

/**
 * Called when a player's stats were loaded
 */
forward RPGx_OnPlayerAuth(id);

/**
 * Called when a player levels up
 */
forward RPGx_OnPlayerLevel(id, newlevel);

/**
 * Called when a player spawns
 */
forward RPGx_OnPlayerSpawn(id);

/**
 * Called when a player was killed
 */
forward RPGx_OnPlayerDeath(victim, killer, headshot);

/**
 * Called when a player was injured
 */
forward RPGx_OnPlayerHurt(victim, attacker, damage, weapon);

/**
 * Called when a player purchases an upgrade
 */
forward RPGx_OnUpgradePurchase(id, upgrade, newlevel);

/**
 * Called when a player sells an upgrade
 */
forward RPGx_OnUpgradeSell(id, upgrade, newlevel);