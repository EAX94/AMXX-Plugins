/** Array:AStar(Float:Start[3], Float:Goal[3], StepSize = 30, Ignore = IGNORE_MONSTERS, IgnoreID = 0, GroundDistance = 35, Heuristic = 50);
 *
 * Finds a path between Start and Goal.
 *
 *
 * Parameters:
 *
 *	Float:Start[3]
 *		Starting position.
 *
 *	Float:Goal[3]
 *		Hopefully ending position.
 *
 *	(Optional) StepSize = 30
 *		Defines how far between each step to take in a pattern of -X + X in all three dimensions. This means that diagonally, the step will be longer.
 *
 *	(Optional) Ignore = IGNORE_MONSTERS
 *		Flags for the traceline check.
 *
 *	(Optional) IgnoreID = 0
 *		id of the calling player if IGNORE_MONSTERS is not set. Again, this is for the traceline.
 *
 *	(Optional) GroundDistance = 35
 *		Set the maximum distance from the ground for the point to be accepted as valid. If set to 0 this check is disabled, meaning pathfinding for flying entities.
 *
 *	(Optional) Heuristic = 50
 *		Optimization parameter. Decides how much importance the distance from the target has.
 *		Higher values might result in a faster execution but may also result in a suboptimal path.
 *
 * Returns a handle to a dynamic array that will contain each step between start and goal.
 * On failure it will return Invalid_Array.
**/
native Array:AStar(Float:Start[3], Float:Goal[3], StepSize = 30, Ignore = IGNORE_MONSTERS, IgnoreID = 0, GroundDistance = 35, Heuristic = 50);

/**
 * AStar_GetDistance()
 *
 * Returns the distance of the last path created.
**/
native Float:AStar_GetDistance();

/**
 * AStar_GetNodesAdded()
 *
 * Returns the ammount of nodes that were created from the last session.
**/
native AStar_GetNodesAdded();

/**
 * AStar_GetNodesValidated()
 *
 * Returns the ammount of nodes that were validated from the last session.
**/
native AStar_GetNodesValidated();

/**
 * AStar_GetNodesValidated()
 *
 * Returns the ammount of nodes that were cleared from the last session.
**/
native AStar_GetNodesCleared();