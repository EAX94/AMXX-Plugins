/* Bot API
*
* Copyright © 2006, Space Headed Productions
*
* This file is provided as is (no warranties).
*
*/

#if defined _botapi_included
	#endinput
#endif
#define _botapi_included
#include <hlsdk_const>

#pragma reqlib botapi

enum bot_data {
	bot_int_start,
	bot_buttons,
	bot_impulse,
	bot_int_end,
	bot_float_start,
	bot_forward_move,
	bot_side_move,
	bot_up_move,
	bot_float_end
}

enum bot_chat {
	chat_all,
	chat_team,
	chat_radio
}

// Called when AMXX Bot connects
forward bot_connect(id);

// Called when AMXX Bot disconnects
forward bot_disconnect(id);

// Called when AMXX Bot takes damage
forward bot_damage(id, damage);

// Called when AMXX Bot dies
forward bot_death(id);

// Called when AMXX Bot spawns
forward bot_spawn(id);

// Called when AMXX Bot thinks
forward bot_think(id);

// Checks whether its AMXX Bot
native is_bot(id);

// Creates a bot by given name and joins a team if specified
native create_bot(const name[]);

// Removes a bot by id
native remove_bot(id);

// Retrieves & sets bot data
native get_bot_data(id, bot_data:member, {Float,_}:...);
native set_bot_data(id, bot_data:member, {Float,_}:...);

// Sets the bots angles to the given origin
native set_bot_angles(id, Float:origin[3]);

// Simulates microphone chatting for bots
native set_bot_voice(id, const wavefile[], pitch=100, Float:duration=1.0);

// Simulates text chatting for bots
native set_bot_chat(id, bot_chat:member, const text[]);