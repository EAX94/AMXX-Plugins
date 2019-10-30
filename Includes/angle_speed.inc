#if defined _angle_speed_included
	#endinput
#endif

#define _angle_speed_included

/**
 * Returns the number of elements in the array.
 *
 * @param ent			Ent id which we check angle speed
 * @param fAngleSpeed 	Array 
 * @return				0 if failed, 1 if success
 */
native angle_get_speed(ent, Float:fAngleSpeed[3])

/**
 * Returns the number of elements in the array.
 *
 * @param ent			Id of entity which we want to set angle speed.
 * @param fAngleSpeed 	Array in which we put angle speed (Pitch, Yaw, Roll).
 * @return				0 - invalid entity, 1 - succesfully set angle speed
 */
native angle_set_speed(ent, Float:fAngleSpeed[3]);