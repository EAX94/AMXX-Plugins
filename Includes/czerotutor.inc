#if defined _czerotutor_included
  #endinput
#endif
#define _czerotutor_included

enum
{
	RED = 1,
	BLUE,
	YELLOW,
	GREEN
}

/**
 * Create a tutor
 *
 * @param id		Player index.
 * @param text		Text to display in tutor.
 * @param color		Color of text.
 * @param sound		Sound to play when display tutor.
 * @param Time		Time to the tutor still alive.
 * @return			1 on success, 0 otherwise.
 */
native czerotutor_create(id, text[] = "", color = YELLOW, sound[] = "", Float:Time = 0.0)

/**
 * Check if a tutor is displaying to this player.
 *
 * @param id		Player index.
 * @return			1 if exists, 0 otherwise.
 */
native czerotutor_exists(id)

/**
 * Remove player tutor.
 *
 * @param id		Player index.
 * @return			1 on success, 0 otherwise.
 */
native czerotutor_remove(id)