#if defined __INCLUDED_AnyMAL_IPM
	#endinput
#endif

#define __INCLUDED_AnyMAL_IPM

/*
----------------
@ about
----------------

AnyMAL (Any-Mod Abstraction Layer)
IPM (Initialization Priority Manager) subsystem.

by Shadows In Rain (aka SiR)
shadowsinrain@ya.ru

This plugin allows other plugins initialize in valid order, using simple depedencies mechanism. Managed initialization starts inside plugin_cfg() of this plugin, just after plugin_init(), so consider to move your code from plugin_cfg() to response to managed initialization.
*/

/*
Name buffer capacity.
*/
const anymal_ipm_name_len = 40

/*
Register managed position for your plugin.
*/
native IPMH:anymal_ipm_register(const name[])

/*
Add depedencies via this funcion.
Name must correspond existing depedencies provider.
*/
native anymal_ipm_add_depedency(IPMH:handle, const name[])

/*
All depedencies initialized.
So, if it's your handle, then it's your time to initialize.
*/
forward anymal_ipm_init(IPMH:handle)

/*
Plugin failed to initialize. Two reasons leads this way:
1. Not all depedencies providers exist or registered.
2. Some depedencies makes circle loop.
Watch your error log.
*/
forward anymal_ipm_failed(IPMH:handle)
