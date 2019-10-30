/**
 * Humans VS Monsters include file
 *
 * 	by Sam Tsuki
 */

/**
 * Returns a player's level.
 *
 * @param id		Player index.
 * @return		Level.
 */
native hvm_get_user_level(id)

/**
 * Returns a player's XP.
 *
 * @param id		Player index.
 * @return		XP.
 */
native hvm_get_user_xp(id)

/**
 * Returns a player's HP+ skill level.
 *
 * @param id		Player index.
 * @return		HP+ Skill Level.
 */
native hvm_get_user_skill1_level(id)

/**
 * Returns a player's Speed+ skill level.
 *
 * @param id		Player index.
 * @return		Speed+ Skill Level.
 */
native hvm_get_user_skill2_level(id)

/**
 * Returns a player's Gravity- skill level.
 *
 * @param id		Player index.
 * @return		Gravity- Skill Level.
 */
native hvm_get_user_skill3_level(id)

/**
 * Returns a player's Start Pistol skill level.
 *
 * @param id		Player index.
 * @return		Start Pistol Skill Level.
 */
native hvm_get_user_skill4_level(id)

/**
 * Returns a player's Mid-Kit skill level.
 *
 * @param id		Player index.
 * @return		Mid-Kit Skill Level.
 */
native hvm_get_user_skill5_level(id)

/**
 * Returns a player's Vanish skill level.
 *
 * @param id		Player index.
 * @return		Vanish Skill Level.
 */
native hvm_get_user_skill6_level(id)

/**
 * Returns a player's Kills.
 *
 * @param id		Player index.
 * @return		Kills.
 */
native hvm_get_user_kills(id)

/**
 * Returns a player's Wins.
 *
 * @param id		Player index.
 * @return		Wins.
 */
native hvm_get_user_wins(id)

/**
 * Returns a player's (monster) Kills.(use model name from monster.ini file)
 *
 * @param id		Player index.
 * @param monster[]	Monster model.
 * @return		(monster) Kills.
 */
native hvm_get_user_monkills(id, monster[])

/**
 * Gives XP to a player.
 *
 * @param id		Player index.
 * @param xp		XP.
 */
native hvm_give_user_xp(id, xp)

/**
 * Sets a player's wins.
 *
 * @param id		Player index.
 * @param wins		Wins.
 */
native hvm_set_user_wins(id, wins)

/**
 * Returns a monster's name.(use the first model name for the monster from monster.ini file)
 *
 * @param monster[]	Monster model.
 * @return monstername[]Monster name.
 */
native hvm_get_monster_name(monster[], monstername[], len)

/**
 * Called when the game ends.
 *
 * @param winner	Player who has won the round.
 */
forward hvm_game_ended(winner)