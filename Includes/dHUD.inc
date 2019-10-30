/**
 * Dynamic HUD 
 * v1.02
 */
#if defined _dHUD_included
    #endinput
#endif

#define _dHUD_included



/**
 * Create new Dynamic HUD object
 *
 *	@param dhud		Build object as copy of given 
 *				-1 creates brand new object
 *	@return 		dhud handle
 *
 *	Example:
 *		new dhud1 = DHUD_create();//new, empty object
 *		//do sth with dhud1
 *		...
 *
 *		new dhud2 = DHUD_create(dhud1); //dhud2 has the same configuration like dhud1
 */
native DHUD_create(dhud = -1);



/**
 * Get total number of frames
 *
 *	@param	dhud		dhud handle
 *	@return			number of frames
 */
native DHUD_getFrames(dhud);

/**
 * Set configuration of choosen frame
 *
 *	@param	dhud		dhud handle
 *	@param	frame		id of frame, starts from 0, if frame > DHUD_getFrames(dhud) leak will be filled by empty frames
 *	@param	iColor		Color of message in frame
 *	@param	x		Position on x axis
 *	@param	y		Position on y axis
 *	@param  iLen		Duration of frame, iLen = 2 mean frame hold 2 times longer than frame with iLen = 1
 *				set iLen = 0 to remove frame
 *
 *	@return 		1 on success, 0 on failure
 */
native DHUD_setFrame(dhud, frame, iColor[3]={0,0,0}, Float:x=0.0, Float:y=0.0, iLen = 1);

/**
 * Get configuration of choosen frame
 *
 *	@param	dhud		dhud handle
 *	@param	frame		id of frame, starts from 0, frame > DHUD_getFrames(dhud) cause log error
 *	@param	iColor		Color of message in frame
 *	@param	x		Position on x axis
 *	@param	y		Position on y axis
 *	@param  iLen		Duration of frame, iLen = 2 mean frame hold 2 times longer than frame with iLen = 1
 *
 *	@return 		1 on success, 0 on failure
 */
native DHUD_getFrame(dhud, frame, iColor[3], &Float:x, &Float:y, &iLen);



/**
 * Display Dynamic HUD message
 *
 *	@param id		Index of player or 0 for all
 *	@param dhud		dhud handle
 *	@param fInterval 	Period of updating frames
 *	@param channel		Channel od HUD, from 1 to 4
 *	@param szMessage[]	Message to show
 *
 *	@return 		1 on success, 0 on failure
 */
native DHUD_display(id, dhud, Float:fInterval = 0.1, channel = 4, const szMessage[], any:...);

/**
 * Clear Dynamic HUD message from screen
 *
 *	@param id		Index of player or 0 for all
 *	@param dhud		dhud handle
 *
 *	@return 		1 on success, 0 on failure
 */
native DHUD_clear(id, dhud);



/**
 * Add new filter to DHUD interface
 *	
 *	@param szName		Name for applying
 *	@param szCallback	Public function which realize filter
 *	@param szDescription	Description of filter and arguments
 *
 *				Basic form is:
 *				public filterCallback(dhud, frame, startFrame, endFrame, Float:x, Float:y){}
 *				
 *				It is when filter do not use custom parameters.
 *				
 *				Every additional parameter is argument type from amxconst.inc
 *					FP_CELL, 
 *					FP_FLOAT, 
 *					FP_ARRAY (only array[3]), 
 *					FP_STRING (buffer for 128 chars)
 *		
 *				When filter need Float:a and Float:b multipliers should use pair:
 *					DHUD_registerFilter("MyFilter", "cbMyFilter", "<Float:a> <Float:b> - Do something", FP_FLOAT, FP_FLOAT);
 *					public cbMyFilter(dhud, frame, startFrame, endFrame, Float:x, Float:y, Float:a, Float:b){}
 *
 *				Now applying filter will require 2 additional Floats
 */
native DHUD_registerFilter(const szName[], const szCallback[], const szDescription[], ...);




/**
 * dx, dy values, but you can put custom ones, example: 0.04
 */
#define D_ZERO 0.0
#define D_SHORT 0.01
#define D_LONG 0.1


/**
 * startFrame endFrame help constants
 */
#define FRAME_FIRST 0
#define FRAME_LAST -1


/**
 * Apply filter on choosen frames
 *
 *	@param dhud		dhud handle
 *	@param szFilter		Filter name
 *	@param startFrame	First frame for apply
 *	@param endFrame		Last frame for apply
 *	@param dx		Increasing x 
 *	@param dy		Increasing y 
 *	
 *	@param ...		If filter has additional parameters this is place to put them
 *	
 *	@return			1 on success, 0 on failure
 */
native DHUD_applyFilter(dhud, const szFilter[], startFrame, endFrame, Float:dx=D_LONG, Float:dy=D_ZERO, any:...);


/**
 * Called when message animation is stoped
 *
 *	@param id		Target, player index or 0 for all
 *	@param dhud		dhud handle
 *	@param finished		true when every frame was displayed, false when message cleared or replaced 
 */
forward fwStopAnimation(id, dhud, bool:finished);


/**
 * Remove chosen frames
 *	@param dhud		dhud handle
 *	@param startFrame	First removed frame
 *	@param count		Number of frames to delete
 */
stock DHUD_removeFrames(dhud, startFrame, count){
	for(new i=0;i<count;i++)
		DHUD_setFrame(dhud, startFrame, _,_,_, 0);
}

/**
 * Remove all frames from dhud object
 *	@param dhud 		dhud handle
 */
stock DHUD_removeAllFrames(dhud){
	DHUD_removeFrames(dhud, 0, DHUD_getFrames(dhud));
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1045\\ f0\\ fs16 \n\\ par }
*/
