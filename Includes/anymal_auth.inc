#if defined __INCLUDED_AnyMAL_Auth
	#endinput
#endif

#define __INCLUDED_AnyMAL_Auth

/*
----------------
@ about
----------------

AnyMAL (Any-Mod Abstraction Layer)
Concurent authorization drivers queue subsystem.

by Shadows In Rain (aka SiR)
shadowsinrain@ya.ru

This mechanism lets authorize connected users using different ways, but calling only one function.
This plugin is manager, that uses satellite plugins, called drivers. When user connected, first
registered driver plugin is asked to authorize user. If it failed, next plugin in chain will be
asked, and so on. All plugins, that uses this one, don't need to care how server administrator
want authorize anyone. User can be authorized by steam-id, ip, nickname, or even by multiple
parameters (admin recognizing, for example). Consider using this module rather than calling
get_user_auth(...), get_user_ip(...), etc.

----------------
@ notes
----------------

Any handles starts from 1.
Zero indicates unitialized cell or invalid handle.
Convention about auth drivers file names: anymal_auth_*
Auth string includes driver/protocol prefix,
    e.g.: "name X_X", "steam-id STEAM_ID:9:98765432", "ip 127.0.0.1"
Auth update procedure automatically started as respoonse to client_putinserver()

Drivers must hook anymal_auth_ready_to_register() to initialize and register self instead of using IPM.

----------------
@ depedencies
----------------

This module uses AnyMAL IPM

----------------
*/

// IPM
#define IPM_ANYMAL_AUTH "anymal/auth"

//--------------------------------
// Constants
//--------------------------------

// buffer capacity for driver name
const anymal_authdriver_name_len = 20

// buffer capacity for auth string
const anymal_auth_len = 50

//--------------------------------
// Normal plugins
//--------------------------------

/*
User propertly authorized, so you can get auth string, if you need.
*/
forward anymal_auth_succeed(player)

/*
All drivers in chain can't recognize user.
Probably, server administrator forgot to add some drivers plugins.
*/
forward anymal_auth_failed(player)

/*
User auth is no more valid. Two reasons can lead this way:
- user disconnected
- this plugin is shutting down
*/
forward anymal_auth_dropped(player)

/*
Read user auth string.
If user not authorized, result will be empty.
auth[] size must be enough to hold %anymal_auth_len% symbols
*/
native anymal_auth_get(player, auth[])

//--------------------------------
// Driver plugins
//--------------------------------

/*
This module initialized, and ready to register drivers.
Any driver registration and initialization must be done inside this event.
*/
forward anymal_auth_ready_to_register()

/*
Register auth driver and get driver handle
Safe to call only inside plugin_init()
*/
native authdriver:anymal_auth_register_driver(const name[])

/*
Auth must be updated, because this plugin is next in chain, or direct authorization asked.
Corresponding driver must respond with anymal_auth_update or ignore this.
*/
forward anymal_auth_update_requested(authdriver:driver, player)

/*
Call this as response to anymal_auth_update_requested to update auth, but only if your driver can recognize user.
*/
native anymal_auth_update(const auth[])

//--------------------------------
// Advanced plugins
//--------------------------------

/*
Get auth directly from specified driver. Driver must be exist.
auth[] size must be enough to hold %anymal_auth_len% symbols.
If user not recognized, returned false.
*/
native bool:anymal_auth_get_custom(authdriver:driver, player, auth[])

/*
Count registered auth drivers.
*/
native anymal_auth_get_num_drivers()

/*
Get driver name.
name[] size must be enough to hold %anymal_authdriver_name_len% symbols
*/
native anymal_auth_get_driver_name(authdriver:driver, name[])
