/* Flashbang Remote Control Include File
*  Author: OT
*  
*  This include file will only work if the plugin named as flashbang_remote_control is placed in your server and it is working!
*/

#if defined _frc_included
  #endinput
#endif
#define _frc_included

#include <amxmodx>

#pragma reqlib "frc_lib"

/* Constants */

enum Amnt
{
	AMOUNT_BLIND_PARTIALLY 	= 200,
	AMOUNT_BLIND_FULLY		= 255
}

enum
{
	FRC_CONTINUE 			= 0,
	FRC_MAKE_PARTIALLY 		= 200,
	FRC_MAKE_FULLY			= 255,
	FRC_BLOCK 				= 300
}

enum Punish
{
	PUNISH_ATTACK = 0,
	PUNISH_KILL,
	PUNISH_FLASH
}

/* Forwards */

/*
* This forward is called before the flash message is sent to the player.
* Will execute in all plugins, even if it is blocked!
* 
* Arguments:
* flasher - the owner of the flashbang
* flashed - the person who was flashed
* flashbang - the flashbang entity | this entity will be equal with flasher if called with FRC_flash_player
* amount - the alpha of the screenfade
* 
* Return:
* - FRC_CONTINUE - do nothing
* - FRC_MAKE_PARTIALLY - make the flashbang partial
* - FRC_MAKE_FULLY - make the flashbang fully
* - FRC_BLOCK - block it
* 
* Notes: Will work even if plugin is turned off!
* Notes: Here you can manipulate also the duration of the screenfade with [g|s]et_FRC_duration() native
*/

forward fw_FRC_preflash(flasher, flashed, flashbang, amount)

/*
* This forward is called after the flash message is sent to the player.
* This forward can not be blocked and will not execute if preflash is blocked!
* 
* Arguments:
* flasher - the owner of the flashbang
* flashed - the person who was flashed
* flashbang - the flashbang entity | this entity will be equal with flasher if called with FRC_flash_player
* amount - the alpha of the screenfade
* 
* Return:
* No return!
* 
* Notes: Will work even if plugin is turned off!
*/

forward fw_FRC_postflash(flasher, flashed, flashbang, amount)

/*
* This forward is called when the flashbang begins searching for players, aka explodes.
* Before this forward the plugin registers all the
* It can't be blocked.
* 
* Arguments:
* flashbang_entity - the flashbang entity
* owner - the entity owner
* 
* Return:
* No return!
* 
* Notes: Will work even if plugin is turned off!
*/

forward fw_FRC_flashbang_explosion(flashbang_entity, owner)

/*
* This forward is called when the plugin free the data such as flasher entity and flash owner
* 
* Return:
* No return!
* 
* Notes: Will work even if plugin is turned off!
*/

forward fw_FRC_free_plugin_data()

/*
* This forward is called when the plugin punished a player!
* Warning it punish_type is equal to PUNISH_ATTACK then this forward will be extremely often called!
* 
* Arguments:
* flasher - the person that needs to be punished
* punish_type - type of punishment use the Punish enum!
* 
* Return:
* FRC_CONTINUE - continue the punishment
* FRC_BLOCK - block the punishment
* 
* Notes: Will work only when the plugin has the punish system on and the plugin itself is turned on!
*/

forward fw_FRC_punish(flasher, punish_type)

/*
* This forward is called when the plugin does the special check to block flashing players if one teammate is flashed!
* 
* Arguments:
* start - start position of the trace
* end - end position of the trace
* conditions - this should normally be DONT_IGNORE_MONSTERS, this acts as the conditions of TraceLine
* ignore_ent - entity that is to be ignored
* trace_handle - use get_tr2() from fakemeta, here we have the info that we need! 
*              - This is the tracehandle of the plugin, any modifications will be seen!
* 
* Return:
* No return!
* 
* Notes: Will work when the plugin is on and has the special block feature on!
*/

forward fw_FRC_trace(Float:start[3], Float:end[3], conditions, ignore_ent, trace_handle)

/*
* This forward is called when the plugin does the bug check to see if a player is flashable through a trace!
* 
* Arguments:
* start - start position of the trace
* end - end position of the trace
* conditions - this should normally be DONT_IGNORE_MONSTERS, this acts as the conditions of TraceLine
* ignore_ent - entity that is to be ignored
* trace_handle - use get_tr2() from fakemeta, here we have the info that we need! 
*              - This is the tracehandle of the plugin, any modifications will be seen!
* 
* Return:
* No return!
* 
* Notes: Will work when the plugin is on and has the bugfix feature on!
*/

forward fw_FRC_trace_bug(Float:start[3], Float:end[3], conditions, ignore_ent, trace_handle)

/*
* This forward is called when the counter is reseted.
* This happens normally when client connects or the punish period has finished!
* 
* Return:
* No return!
* 
* Notes: Will work only when the plugin has the punish system on and the plugin itself is turned on!
*/

forward fw_FRC_counter_reset(player)

/*
* This forward is called when the flashbang searches for the players that can be flashed!
* This takes place after fw_FRC_flashbang_explosion forward.
* If this will be blocked none of the punish/flash/trace forwards will work!
* 
* Params:
* - player - player id
* - flash_entity - flashbang entity
* 
* Return:
* - FRC_CONTINUE - do not do anything
* - FRC_BLOCK - block the client from beeing searched
* 
* Notes: Will work even if plugin is turned off!
*/

forward fw_FRC_flash_find_in_sphere(player, flash_entity)

/*
* This forward is called when the plugin finishes regitering all the forwards.
* 
* Return:
* None!
* 
* Notes: Will work even if plugin is turned off!
*/
forward fw_FRC_extention_init()

/* Natives */
/*
* Gets the number of times a player has flashed his teammates
*/
native get_FRC_counter(id)

/*
* Sets the number of times a player has flashed his teammates
*/
native set_FRC_counter(id, quantity)

/*
* This will set the duration of the flash [Use this in fw_FRC_preflash forward!]
* Return is in 0.1 seconds!
* Will return -1 on invalid call!
*/
native get_FRC_duration(flashed)

/*
* This will set the duration of the flash [Use this in fw_FRC_preflash forward!]
* Duration is in 0.1 seconds!
* Will return -1 on invalid call!
*/
native set_FRC_duration(flashed, duration)

/*
* This will set the hold time of the flash [Use this in fw_FRC_preflash forward!]
* Return is in 0.1 seconds!
* Will return -1 on invalid call!
*/
native get_FRC_holdtime(flashed)

/*
* This will set the hold time of the flash [Use this in fw_FRC_preflash forward!]
* Duration is in 0.1 seconds!
* Will return -1 on invalid call!
*/
native set_FRC_holdtime(flashed, duration)

/*
* Gets the number of time a player can flash his teammates
*/
native get_FRC_flash_limit()

/*
* Gets the exploding flashbang entity
*/
native get_FRC_exploding_flash()

/*
* Gets the owner of the exploding flashbang
*/
native get_FRC_exploding_owner()

/*
* If flasher != 0 then this function will be hookable with fw_FRC_preflash and fw_FRC_postflash, and the flash entity will be equal with flasher!
* If flasher == 0 then this function will be unhookable
* 
* Params:
* holdtime: Time that the screenfade maintains its color before fading
* duration: The time the entire screenfade message will last.
* Both duration and holdtime are in 0.1 seconds!!!
* 
* Example usage:
* FRC_flash_player(id, id, 1000, 900, AMOUNT_BLIND_FULLY)
* This will seem like an autoflash to the plugin, it will not be blocked by selfflash cvar!
* The screenfade will act like this: 90 seconds the screen will be total white and after that in the las 10 seconds it will fade out,
*/
native FRC_flash_player(flasher = 0, flashed, duration, holdtime, Amnt:ammount)

/*
* This we use to check whether the plugin is on.
* -1 - plugin does not exist!
*  0 - plugin exists but it is turned off!
*  1 - plugin is turned on!
*/
stock is_FRC_on()
{
	if (!cvar_exists("frc_enable"))
		return -1
	
	return (!!get_cvar_num("frc_enable"))
}