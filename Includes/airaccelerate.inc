#if defined _airaccelerate_included
	#endinput
#endif

#define _airaccelerate_included

#if AMXX_VERSION_NUM >= 175
	#pragma reqlib airaccelerate
	#if !defined AMXMODX_NOAUTOLOAD
		#pragma loadlib airaccelerate
	#endif
#else
	#pragma library airaccelerate
#endif

/* 
 * Sets a player's personal value for airaccelerate
 * 
 * @param	id - The player index
 * @param	airaccelerate - The value for airaccelerate
 * 
 * @return	The value for airaccelerate before setting to new value
 * 
 * @note	Use 0 as id to set all players' airaccelerate
 * 
 */
native set_user_airaccelerate(id, const airaccelerate);

/* 
 * Gets a player's personal value for airaccelerate
 * 
 * @param	id - The player index
 * 
 * @return	The value for airaccelerate
 * 
 */
native get_user_airaccelerate(id);

/* 
 * Resets a player's personal value for airaccelerate
 * 
 * @param	id - The player index
 * 
 * @return	1
 * 
 * @note	Use 0 as id to reset all players' airaccelerate
 * 
 */
native reset_user_airaccelerate(id);
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1033\\ f0\\ fs16 \n\\ par }
*/
