#if defined _profiler_included
  #endinput
#endif
#define _profiler_included

/**
 * These natives are provided independantly of the profiling done with plugins in the $amxmodx/data/profiles folder.
 * This means, a plugin does not need to be in profile mode for these natives to be usable.
 */

/**
 * Starts a custom profile for a block of code.
 *
 * @return	a handle to a profiler object.
 */
native Profile:StartProfile();

/**
 * Stops the custom profile for a block of code.
 * @note This also DESTROYS the profiler object, so do not use it again!
 *
 * @param what		The profile to stop, the profile object will be destroyed, and the value for what will be reset.
 * @param buffer	Optional buffer, if provided, the native will set a string to the double value of the time elapsed.  This will be slightly more accurate than the float value, due to float restrictions.
 * @param size		The length of the buffer.
 * @return			The float value for the time (in seconds) elapsed since the profile started.
 */
native Float:StopProfile(&Profile:what, const buffer[] = "", size = 0);
