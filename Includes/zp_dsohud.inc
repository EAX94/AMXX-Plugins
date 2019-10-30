#if defined _zp_dsohud_included
  #endinput
#endif
#define _zp_dsohud_included

/**
 * Allows you to display a sprite on a user's HUD display
 *
 * Note: The sprite which is to be displayed must be precached
 * in your sub-plugin
 * 
 * @param id			Player index.
 * @param sprite_name		The sprite's name which is to be displayed
 * @param sprite_scale		The sprite's scale/size, must be a float
 * @param sprite_stopframe	The frame at which to halt the sprite's animation
 * @param sprite_framerate	The framerate of the sprite's animation
 * @return			Index of the sprite's entity or -1 on failure
 * 
**/
native zp_display_hud_sprite(id, const sprite_name[], Float:sprite_scale = 0.03, sprite_stopframe = 0, Float:sprite_framerate = 0.0)

/**
 * Allows you to remove the sprite from a player's screen
 *
 * @param id		Player index.
 * @return		1 on success otherwise -1 on failure
 * 
**/
native zp_remove_hud_sprite(id)