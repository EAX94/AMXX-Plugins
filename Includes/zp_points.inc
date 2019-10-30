#if defined _zp_points_included
  #endinput
#endif
#define _zp_points_included


/**
 * Get user points
 *
 */
native zp_get_user_points( id );

/**
 * Set user points
 *
 */
native zp_set_user_points( id, amount );

/**
 * Add user points
 *
 */
native zp_add_user_points( id, amount );

/**
 * Delete user points
 *
 */
native zp_del_user_points( id, amount );