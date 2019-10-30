/*
	Model Changer Functions
	
	by Hattrick @ www.CsRedDevil.com
*/

#if defined _model_changer_included
	#endinput
#endif // _model_changer_included

#define _model_changer_included

#include "svn_version.inc"

#if AMXX_VERSION_NUM >= 175
	#pragma reqlib model_changer
	
	#if !defined AMXMODX_NOAUTOLOAD
		#pragma loadlib model_changer
	#endif
#else
	#pragma library model_changer
#endif // AMXX_VERSION_NUM

/*
	Sets a custom model at a player. If the player will reconnect he won't has any custom model anymore!
	If the model you want to set isn't precached, this function will set the first model from this team at player!
	If his team is TERRORIST his model will be Terror and if his team is CT his model will be Urban!
	
	@param	_index		The player's index ( INT )
	@param	_model		The player's model ( SZ )
	
	Example:	set_user_model( id, "guerilla" );
*/
native set_user_model( _index, _model[ ] );

/*
	Removes the custom model from a player.
	
	@param	_index		The player's index ( INT )
	
	Example:	reset_user_model( id );
*/
native reset_user_model( _index );

/*
	Gets the model's name from a player.
	
	@param	_index		The player's index ( INT )
	@param	_model		The model's name ( SZ )
	@param	_length		The model's name length ( INT )
	
	Example:	get_user_model( id, model, len );
*/
native get_user_model( _index, _model[ ], _length );
