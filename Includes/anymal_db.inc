#if defined __INCLUDED_AnyMAL_DBD
	#endinput
#endif

#define __INCLUDED_AnyMAL_DBD

/*
----------------
@ about
----------------

AnyMAL (Any-Mod Abstraction Layer)
Abstract data base drivers rack subsystem.

by Shadows In Rain (aka SiR)
shadowsinrain@ya.ru

This plugin allows to connect to database via simple interface, without writing database-specific
code and without studying query language. This plugin is only rack, so it depends on other plugins,
called drivers. Since you added driver to server plugins list, any other plugins, that uses this
rack, can use that driver even know nothing about it. Drivers may write and read files, vaults,
remote databases, etc. Client plugins can open multiple connections via different drivers.
In most situations, info about connection must be stored outside plugin, in config or INI file.
Info about connection called initializer, and includes database driver name, so any driver may be
choosen without recompiling your plugin.
====================================================================================================
----------------
@ notes
----------------

Any handles starts from 1.
Zero indicates unitialized cell or invalid handle.
Drivers file naming convention: anymal_dbd_*

Fields typical usage:
- Owner: user auth string or "global", f.e.: "nickname teh Por", "ip 123.45.67.89", "global"
- Key: paths and names style, f.e.: "mymod/my_plugin/avesomesettings/cakeisalie", "my_plugin/presets/presetname/subpart1", etc

Connection initializer string begins with driver name, f.e.: "MySQL parameter1=abc parameter2=def parameter3=ghi"
You must read driver specific documentation to make valid initializer.

Drivers must hook anymal_db_ready_to_register() to initialize and register self, instead of using IPM.

----------------
@ depedencies
----------------

This plugin uses AnyMAL IPM

----------------
*/

// IPM
#define IPM_ANYMAL_DBD "anymal/dbd"


//--------------------------------
// Constants
//--------------------------------

// buffer capacity for o/k/v field
const anymal_db_field_len = 100

// buffer capacity for db connection inititalizer string
const anymal_db_initializer_len = 200

// buffer capacity for driver name
const anymal_dbdriver_name_len = 20

// predefined auth string for storing non-user data
// example: anymal_db_write(myconnection, ANYMAL_OWNER_GLOBAL, "myplugin/cheaters_left", "0")
#define ANYMAL_OWNER_GLOBAL "global"

//--------------------------------
// Normal plugins
//--------------------------------

/*
Open connection and get connection handle.
*/
native DBC:anymal_db_connect(const initializer[])

/*
Close previously opened connection
*/
native anymal_db_disconnect(DBC:connection)

/*
Read rows from database.
Use empty fields as wildcards. All fields can't be empty.
*/
native DBQ:anymal_db_read(DBC:connection, const owner[] = ANYMAL_OWNER_GLOBAL, const key[], const value[])

/*
Get number of rows.
*/
native anymal_db_count_rows(DBQ:query)

/*
Get row fields.
*/
native anymal_db_get_row(DBQ:query, index, owner[], key[], value[], len)
native anymal_db_get_row_owner(DBQ:query, index, owner[], len)
native anymal_db_get_row_key(DBQ:query, index, key[], len)
native anymal_db_get_row_value(DBQ:query, index, value[], len)

/*
Release allocated resources for query, when no more needed. Don't forget to forget!
*/
native anymal_db_forget(DBQ:query)

/*
Read value from first row only. Do not need to prepare query. Useful shortcut.
If nothing to read, false returned, and value don't changed.
*/
native bool:anymal_db_get_first(DBC:connection, const owner[] = ANYMAL_OWNER_GLOBAL, const key[], value[], len)
native bool:anymal_db_get_first_cell(DBC:connection, const owner[] = ANYMAL_OWNER_GLOBAL, const key[], &value)
native bool:anymal_db_get_first_float(DBC:connection, const owner[] = ANYMAL_OWNER_GLOBAL, const key[], &Float:value)

/*
Write one row into database.
Fields owner[] and key[] must contain valid values.
*/
native anymal_db_write(DBC:connection, const owner[] = ANYMAL_OWNER_GLOBAL, const key[], const value[] = "", bool:overwrite = true)
native anymal_db_write_cell(DBC:connection, const owner[] = ANYMAL_OWNER_GLOBAL, const key[], value = 0, bool:overwrite = true)
native anymal_db_write_float(DBC:connection, const owner[] = ANYMAL_OWNER_GLOBAL, const key[], Float:value = 0.0, bool:overwrite = true)

/*
Remove row or rows from database.
Use empty fields as wildcards. But you can't remove whole database, lol.
*/
native anymal_db_remove(DBC:connection, const owner[] = ANYMAL_OWNER_GLOBAL, const key[], const value[])

//--------------------------------
// Driver plugins
//--------------------------------

/*
This system initialized, and ready to register drivers.
Any driver registration and initialization must be done inside this event.
*/
forward anymal_db_ready_to_register()

/*
Register new driver plugin and get handle.
*/
native DBDriver:anymal_db_register_driver(const name[])

/*
Client plugin want connect to database
Buffer for initializer[] copy must be enough big to hold %anymal_db_initializer_len% symbols.
*/
forward anymal_db_connecting(const initializer[])

// ...disconnect
forward anymal_db_disconnecting(DBC:connection)

/*
Call this if that initializer provided for your driver, and get connection handle.
So you must call this after connection established successfully.
Ignore, if any errors occurs during connection initialization.
*/
native DBC:anymal_db_accept()

/*
Client plugin want read values from db.
Driver, that accepted connection, must respond.
This forward is redirection from anymal_db_read, so see also corresponding suggestions.
*/
forward anymal_db_reading(DBC:connection, const owner[], const key[], const value[], &Array:out_owner, &Array:out_key, &Array:out_value)

// ...write
forward  anymal_db_writing(DBC:connection, const owner[], const key[], const value[])
// ...remove
forward  anymal_db_removing(DBC:connection, const owner[], const key[], const value[])

