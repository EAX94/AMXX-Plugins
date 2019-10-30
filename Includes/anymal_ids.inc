#if defined __INCLUDED_AnyMAL_IDS
	#endinput
#endif

#define __INCLUDED_AnyMAL_IDS

/*
----------------
@ about
----------------

AnyMAL (Any-Mod Abstraction Layer)
IDS (Indirect Data Sharing) subsystem.

by Shadows In Rain (aka SiR)
shadowsinrain@ya.ru

This mechanism allows share some values and be sure that many plugins can access values without
overwriting or conflicts. Each client's plugin stores some intermediate values, that
provider plugin collects and combines to make one final resulting value, following defined
(into .inc file) conventions.

With this current tool, you may share single cell or fixed size arrays.

----------------
@ notes
----------------

Any handles starts from 1.
Zero indicates unitialized cell or invalid handle.
Unlike hanles, value and array indexes starts from 0.
Shared values may be of any single-cell type (cell, bool, Float, Array, etc.)
How resulting value is calculated depends on provider plugin (values may be added, multiplied, etc.)
IDS sets providers must also provide IPM hooks to guarantee right initialization order.

----------------
@ depedencies
----------------

This plugin uses AnyMAL IPM

----------------
*/

// IPM
#define IPM_ANYMAL_IDS "anymal/ids"

//--------------------------------
// Constants
//--------------------------------

// buffer capacity for IDS set name
const anymal_ids_name_len = 50

//--------------------------------
// Normal plugins
//--------------------------------

/*
Get IDS handle, registered by IDS provider.
With this handle you can read actual value.
Handle will be zero, if IDS is not registered.
*/
native IDSH:anymal_ids_find(const name[])

/*
Connect to data set and get access handle.
One layer of values will be dedicated after this operation.
With this handle you can access intermediate values inside associated layer.
*/
native IDSAH:anymal_ids_connect(IDSH:handle)

/*
Set intermediate value.
Provider will be notified.
*/
native anymal_ids_set(IDSAH:access_handle, index, value)

/*
Get resulting value. It may be cached (recalculated with delay when changed), consult provider plugin to be sure.
This function returns just cell, it's real type depends on conventions with provider.
*/
native anymal_ids_get(IDSH:handle, index)

//--------------------------------
// Provider plugins
//--------------------------------

/*
Register new IDS set and get it's handle.
With this handle you'll catch update notifications, collect intermediate values and set resulting one.
All values in set initializes with %initial%.
*/
native IDSH:anymal_ids_register(const name[], numvalues = 1, initial = 0)

/*
Client plugin changed value.
Probably you must recalculate result.
*/
forward anymal_ids_changed(IDSH:handle, index)

/*
Count layers of intermediate values, connected to specified set.
*/
native anymal_ids_count(IDSH:handle)

/*
Get intermediate value directly, using it's layer index.
*/
native anymal_ids_collect(IDSH:handle, index, layer)

/*
Update cached resulting value.
*/
native anymal_ids_update(IDSH:handle, index, value)