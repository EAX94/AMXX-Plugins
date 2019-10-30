/*
*		INCLUDE FILE FOR REMEMBER THE SCORE 
*
*	by Nextra
*	
*	version 1.0.810
*
*	This file is provided as is (no warranties).
*/

#if defined _rts_included
	#endinput
#endif

#define _rts_included

#if AMXX_VERSION_NUM >= 175
	#pragma reqlib rememberthescore
	#if !defined AMXMODX_NOAUTOLOAD
		#pragma loadlib rememberthescore
	#endif
#else
	#pragma library rememberthescore
#endif

/* Informs plugins about rememberthescore being paused or setting
 * itself failed. Passes _type = 0 when pausing, _type = 1 when setting failed. 
 * Return values are ignored. */
 
forward rts_plugin_inactive( _type );


/* Informs plugins about rememberthescore being unpaused. All users will be re-authorized.
 * Return values are ignored. */
 
forward rts_plugin_active( );


/* Informs plugins when the user has been allocated an unique id and the score 
 * was set from the database. After this the players score can be updated and
 * saved. Return values are ignored. */

forward rts_user_authorized( _index );


/**
 * Gets the current state of authorization.
 *
 *
 * @param	_index		The index of the player.
 *
 * @return				0 if not authorized or the player is invalid.
 *						1 if authorized.
*/

native rts_is_authorized( _index );


/**
 * Forces an update of the internal score tracking of the player.
 *
 *
 * @note	If you choose to update the scoreboard through emessages
 * 			in your plugin, calling this native is NOT required.
 *			RTS catches the ScoreInfo message to keep track of the
 *			players scores, thus emessages achieve the same as
 *			calling this native does.
 *
 * @param	_index		The index of the player
 * 
 * @return				Returns 0/false if a false id was submitted.
*/

native rts_update_score( _index );


/**
 * Forces an instant save of the players score into the database.
 *
 *
 * @note	You should call rts_update_score before saving
 *			data through this native if you manually 
 *			changed the score of the player.
 *
 * @note	You do not necessarily have to call this native
 *			after rts_update_score as the internal update
 *			will be considered on the next plugin internal
 *			saving process.
 *			
 * @param	_index		The index of the player
 * 
 * @return				Returns 0/false if a false id was submitted.
 */
 
native rts_save_score( _index );