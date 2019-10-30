/*================================================================================================*/
/*********************************** [Create By ReymonARG] ****************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

#if defined _kzarg_included
	#endinput
#endif

#define _kzarg_included

#pragma library kzarg

/*================================================================================================*/
/***************************************** [Natives] **********************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

/**
 * Get the version of Kz-Arg Plugin
 *
 * @param		output[]		Output Value
 * @param		len			len of Output Value
 *
 */
native kz_get_plugin_version(output[], len)

/**
 * Get Player CheckPoints Nº
 *
 * @param		id			ID of Kz Player
 * 
 * @Return		CheckPoints		Integer
 *
 */
native kz_get_user_checkpoint(id)

/**
 * Get Player GoCheck Nº
 *
 * @param		id			ID of Kz Player
 * 
 * @Return		GoCheck			Integer
 *
 */
native kz_get_user_gocheck(id)

/**
 * Get Player RoundTime in Integer
 *
 * @param		id			ID of Kz Player
 * 
 * @Return		Player Time		Integer
 *
 */
native kz_get_user_roundtime(id)

/**
 * Get Player Start Weapon Nº
 *
 * @param		id			ID of Kz Player
 * 
 * @Return		Nº of Weapon		Integer
 *
 */
native kz_get_user_startweapon(id)

/**
 * Get Player Status
 *
 * @param		id			ID of Kz Player
 * 
 * @Return		True or False		True if player is climbing
 *
 */
native kz_get_user_status(id)

/**
 * Reset Player time, checkpoint, gocheck, etc..
 *
 * @param		id			ID of Kz Player
 * 
 */
native kz_reset_user_data(id)

/**
 * Get Player Vip
 *
 * @param		id			ID of Kz Player
 * 
 * @Return		true or false		Integer
 *
 */
native kz_get_user_vip(id)

/**
 * Set player OverTime Round Msg
 *
 * @param		id			ID of Kz Player
 * @param		message[]		Const Msg to show for the player
 * @param		any			Float, Sql, Integer, etc...
 *
 */
native kz_set_hud_overtime(id, const message[], {Float,Sql,Result,_}:...)

/**
 * Register new Item for the MainMenu of the plugin
 *
 * @param		itemname[]		Const Item Name to show in the menu
 * @param		itemaccess[]		Const Item Access
 * 
 * @Return		Nº of Item		Integer
 *
 */
native kz_mainmenu_item_register(const itemname[], const itemaccess[])

/**
 * Register new Item for the Rewards Menu when finish the map
 *
 * @param		itemname[]		Const Item Name to show in the menu
 * @param		itemaccess[]		Const Item Access
 * 
 * @Return		Nº of Item		Integer
 *
 */
native kz_rewards_item_register(const itemname[], const itemaccess[])

/**
 * Get Player Team
 *
 * @param		id			ID of Kz Player
 * 
 * @Return		N of Team		Integer
 *
 */
native kz_get_user_team(id)

/**
 * Set Player Team
 *
 * @param		id			ID of Kz Player
 * @param		team			Nº of Team
 * 
 * @Return		1			Is the team is correct
 *
 */
native kz_set_user_team(id, team)

/**
 * Open Player the Main Menu
 *
 * @param		id			ID of Kz Player
 * @param		page			Page of the menu
 *
 */
native kz_open_mainmenu(id, page=0)

/**
 * Open Player the Rewards Menu
 *
 * @param		id			ID of Kz Player
 * @param		page			Page of the menu
 *
 */
native kz_open_rewardsmenu(id, page=0)

/**
 * Cheat Deteccion
 *
 * @param		id			ID of Kz Player
 * @param		const Cheat[]		Set the name of the Cheat
 *
 */
native kz_cheat_detection(id, const Cheat[])


enum
{
	KZ_TD_DISABLED = 0,
	KZ_TD_ROUNDTIME = 1,
	KZ_TD_OVERSCREEN = 2,
	KZ_TD_STATUSTEXT = 3
}

/**
 * ShowTime In
 *
 * @param		id			ID of Kz Player
 *
 * Return 		Style of Timer
 */
native kz_get_user_showtimer(id)

/**
 *
 */
native kz_colorchat(id, const msg[], {Float,Sql,Result,_}:...)


/*================================================================================================*/
/**************************************** [Forwards] **********************************************/
/*=============================================================================R=E=Y=M=O=N==A=R=G=*/

/**
 * Pre Start Climb
 * This is Great for remove players Rewards or others thinks :P
 * 
 * @param		id			ID of Kz Player
 *
 */
forward kz_prestartclimb(id)

/**
 * Post Start Climb
 * This Exec then of player have weapons and Start the time
 * 
 * @param		id			ID of Kz Player
 *
 */
forward kz_startclimb(id)

/**
 * Finish Climb
 * This Exec when player finish the map.
 * 
 * @param		id			ID of Kz Player
 * @param		tiempo			Float and complete time
 * @param		CheckPoints		CheckPoints that player use in that climb
 * @param		GoChecks		GoChecks that player use in that climb
 * @param		Weapon			Nº of the weapon that player have
 *
 */
forward kz_finishclimb(id, Float:tiempo, CheckPoints, GoChecks, Weapon)


/**
 * Reset Start Climb
 * This Exec then the player type /reset
 * 
 * @param		id			ID of Kz Player
 *
 */
forward kz_resetclimb(id)

/**
 * Main Menu Item Choose
 * This Exec then the player choose a item of the Main Menu
 * 
 * @param		id			ID of Kz Player
 * @param		item			Nº of item
 * @param		page			Nº of the page that is the item
 *
 */
forward kz_itemmainmenu(id, item, page)

/**
 * Rewards Item Choose
 * This Exec then the player choose a item of the Rewards Menu
 * 
 * @param		id			ID of Kz Player
 * @param		item			Nº of item
 * @param		page			Nº of the page that is the item
 *
 */
forward kz_itemrewardsmenu(id, item, page)

/**
 * kz_pluginload
 * This Exec when all cvars and forwards was register
 * 
 */
forward kz_pluginload()
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang11274\\ f0\\ fs16 \n\\ par }
*/
