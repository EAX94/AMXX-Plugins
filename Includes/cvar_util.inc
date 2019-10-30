/*
    AMX Mod X include file.

    ¦ Author  : Arkshine
    ¦ Name    : Cvar Utilities
    ¦ Version : v1.3

    (!) Support : http://forums.alliedmods.net/showthread.php?t=147286

    This include is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    This include is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this include. If not, see http://www.gnu.org/licenses/.
*/

#if defined _cvar_util_included
    #endinput
#endif
#define _cvar_util_included

#if AMXX_VERSION_NUM >= 175
    #pragma reqlib cvar_util
    #if !defined AMXMODX_NOAUTOLOAD
        #pragma loadlib cvar_util
    #endif
#else
    #pragma library cvar_util
#endif

enum
{
    CvarReturn_DuplicatedCache = -5,  /* Cvar is already being cached in a variable for a same plugin                                        */
    CvarReturn_AlreadyBounded  = -4,  /* Cvar has already a min/max bound defined in another plugin.                                         */
    CvarReturn_AlreadyLocked   = -3,  /* Cvar is locked, though a new hook/bound would be still registered.                                  */
    CvarReturn_DuplicatedHook  = -2,  /* Hook already exists in a same plugin with a same callback.                                          */
    CvarReturn_AlreadySet      = -1   /* Either a hook/lock is already set with the provided status/value or cvar has already min/max bound. */
};

enum CvarStatus ( <<= 1 )
{
    CvarStatus_HookRegistered = 1,  // 1<<0 - 1
    CvarStatus_HookActive,          // 1<<1 - 2
    CvarStatus_LockRegistered,      // 1<<2 - 4
    CvarStatus_LockActive,          // 1<<3 - 8
    CvarStatus_HasMinValue,         // 1<<4 - 16
    CvarStatus_HasMaxValue,         // 1<<5 - 32
    CvarStatus_NewCvar,             // 1<<6 - 64    
    CvarStatus_WasOutOfBound        // 1<<7 - 128
};

enum CvarBounds
{
    CvarBound_Lower = 0,
    CvarBound_Upper
};

enum
{
    CvarType_Int,
    CvarType_Float,
    CvarType_String,
    CvarType_Flags   
};

/**
 * Called when a cvar's value is changed.
 *
 * @note  Returning PLUGIN_HANDLED will block the change.
 *
 * @param handleCvar    Handle to the cvar that was changed.
 * @param oldValue      String containing the value of the cvar before it was changed.
 * @param newValue      String containing the new value of the cvar.
 */
forward CvarHookChanged( handleCvar, const oldValue[], const newValue[], const cvarName[] );

/**
 * Creates a hook for when a cvar's value is changed.
 *
 * @note  Example of callback : OnCvarChange( handleCvar, const oldValue[], const newValue[], const cvarName[] )
 *        Returning PLUGIN_HANDLED in the callback function will block the change.
 * 
 * @note  Once the hook has been registered, it will call right away the forward with an empty 'oldValue'.
 *        If you don't like this behavior, use ignoreFirstCall to true.
 *
 * @param handleCvar    Handle to the cvar.
 * @param callback      The forward to call.
 *
 * @return              The number of registered hooks on the cvar on success, otherwise :
 *                          - CvarReturn_DuplicatedHook
 *                          - CvarReturn_AlreadyLocked
 *
 * @return error        Throw a log error with :
 *                          - An invalid cvar pointer.
 *                          - An invalid callback name.
 */
native CvarHookChange( handleCvar, const callback[], bool:ignoreFirstCall = false );

/**
 * Same functionnality as CvarHookChange.
 * A hook is created for all the registered cvars of the current plugin.
 * 
 * @note  Useful when you have a bunch of cvars in your plugin and you want to hook all
 *        with the same callback. It will avoid to use individually CvarHookChange.
 * 
 * @note  It works only with CvarRegister !
 * 
 * @note  Example of callback : OnCvarChange( handleCvar, const oldValue[], const newValue[], const cvarName[] )
 *        Returning PLUGIN_HANDLED in the callback function will block the change.
 * 
 * @note  Once the hook has been registered, it will call right away the forward with an empty 'oldValue'.
 *        If you don't like this behavior, use ignoreFirstCall to true.
 *
 * @param callback      The forward to call.
 *
 * @return              The number of registered cvars hooked on success, otherwise :
 *                          - CvarReturn_DuplicatedHook
 *
 * @return error        Throw a log error with :
 *                          - An invalid callback name.
 */
native CvarHookChangeAll( const callback[] );

/**
 * Hook a cvar's value change and cache the new value into the provided global variable.
 * 
 * @note  Useful if purpose is to cache only a cvar value. 
 * @note  It avoids the creation of hook and the call of get_*car_*() natives.
 * @note  It works only with integer, float, string and flags.
 *
 * @param handleCvar      Handle to the cvar.
 * @param type            The type of the variable passed. (See CvarType_* constants)
 * @param ...             The global variable to pass by reference. 
 *                        If a string, the buffer length must be provided too.
 * 
 * @return              1 on success, otherwise :
 *                          - CvarReturn_DuplicatedCache
 *
 * @return error        Throw a log error with :
 *                          - An invalid cvar pointer.
 *                          - An invalid buffer size for string.
 *                          - A missing buffer size argument for string.
 */
native CvarCache( handleCvar, const type, any:... );

/**
 * Starts a forward back up.
 *
 * @note  If a cvar is hooked more than one time with differents callbacks in a same plugin,
 *        all the registered hooks for this cvar will be enabled, unless you provide a callback
 *        to enable a specific hook.
 *
 * @param handleCvar    The forward to re-enable.
 * @param callback      (optional) The forward to check. See the note above.
 *
 * @return              The number of registered hooks enabled on success.
 *
 * @return error        Throw a log error with :
 *                          - An invalid cvar pointer.
 *                          - A no-active hook.
 *                          - An invalid callback name.
 */
native CvarEnableHook( handleCvar, const callback[] = "" );

/**
 * Starts a forward back up for all the registered cvars of the current plugin.
 *
 * @return              The number of registered cvars enabled on success.
 */
native CvarEnableHookAll();

/**
 * Stops a forward from triggering.
 *
 * @note  If a cvar is hooked more than one time with differents callbacks in a same plugin,
 *        all the registered hooks for this cvar will be disabled, unless you provide a callback
 *        to disable a specific hook.
 *
 * @param handleCvar    Handle to the cvar.
 * @param callback      (optional) The forward to check. See the note above.
 *
 * @return              The number of registered hooks disabled on success.
 *
 * @return error        Throw a log error with :
 *                          - An invalid cvar pointer.
 *                          - A no-active hook.
 *                          - An invalid callback name.
 */
native CvarDisableHook( handleCvar, const callback[] = "" );

/**
 * Stops a forward from triggering for all the registered cvars of the current plugin.
 *
 * @return              The number of registered cvars disabled on success.
 */
native CvarDisableHookAll();

/**
 * Returns the number of registered hooks of a cvar.
 *
 * @param handleCvar    Handle to the cvar.
 *
 * @return              The number of registered hooks of a cvar on success.
 *
 * @return error        Throw a log error with :
 *                          - An invalid cvar pointer.
 *                          - A no-active hook.
 */
native CvarHookNum( handleCvar );

/**
 * Gives information about a plugin-registered hook of a cvar.
 *
 * @param index         The position in the list.
 * @param handleCvar    Handle to the cvar.
 * @param pluginId      The plugin id where the hook has been registered.
 * @param forwardId     The forward id of the hook.
 * @param callback      The buffer to store the callback used by the hook.
 * @param callbackLen   The size of the buffer.
 *
 * @return              Whether the forward is active or not on success.
 *
 * @return error        Throw a log error with :
 *                          - An invalid cvar pointer.
 *                          - A no-active hook.
 *                          - An invalid index.
 */
native CvarHookInfo( index, handleCvar, &pluginId, &forwardId = -1, callback[] = "", callbackLen = 0 );

/**
 * Force a cvar to be locked to a provided value.
 * Value which can be either a string or a float.
 *
 * @note  If you want to provide a float value, you can do that for example : CvarLockValue( handle, .fvalue = 10.0 );
 * @note  A lock can not be overwritten unless it's done in a same plugin.
 *
 * @param handleCvar    Handle to the cvar.
 * @param value         The value to lock as string.
 * @param fvalue        The value to lock as float.
 *
 * @return              1 on success, otherwise :
 *                          - CvarReturn_AlreadyLocked
 *                          - CvarReturn_AlreadySet
 *
 * @return error        Throw a log error with :
 *                          - An invalid cvar pointer.
 */
native CvarLockValue( handleCvar, const value[] = "", Float:fvalue = 0.0 );

/** 
 * Enable a registered lock.
 *
 * @note  A lock can be enable only in the same plugin where it's registered.
 *
 * @param handleCvar    Handle to the cvar.
 *
 * @return              1 on success, otherwise :
 *                          - CvarReturn_AlreadySet
 *
 * @return error        Throw a log error with :
 *                          - An invalid cvar pointer.
 *                          - A no-registered lock.
 */
native CvarEnableLock( handleCvar );

/** 
 * Disable a registered lock.
 *
 * @note  A lock can be disable only in the same plugin where it's registered.
 *
 * @param handleCvar    Handle to the cvar.
 *
 * @return              1 on success, otherwise :
 *                          - CvarReturn_AlreadySet
 *
 * @return error        Throw a log error with :
 *                          - An invalid cvar pointer.
 *                          - A no-registered lock.
 */
native CvarDisableLock( handleCvar );

/**
 * Gives information about a registered lock of a cvar.
 *
 * @param handleCvar    Handle to the cvar.
 * @param pluginId      The plugin id where the lock has been registered.
 * @param callback      The buffer to store the value locked.
 * @param callbackLen   The size of the buffer.
 *
 * @return              Whether the lock is active or not on success.
 *
 * @return error        Throw a log error with :
 *                          - An invalid cvar pointer.
 *                          - A no-active lock.
 */
native CvarLockInfo( handleCvar, &pluginId = 0, value[] = "", valueLen = 0 );

/**
 * Sets the specified bound of a cvar.
 *
 * @note  A bound already defined can not be overwritten, except it has been defined in a same plugin.
 * @note  It's possible to set a minimum bound in a plugin A and a maximum bound in plugin B.
 *
 * @param handleCvar    Handle to the cvar.
 * @param type          The type of bound to set, CvarBound_Lower or CvarBound_Upper.
 * @param set           If set to true, cvar will use specified bound. If false, bound will be removed. 
 * @param value         Floating point value to use as the specified bound.
 * @param forceInterval (optional) Whether value should be inside the interval between min and max values (min <= value <= max)
 *                      or value should be equal to min or max (value == min or value == max).
 *
 * @return              1 on success if bound is registered and active, 0 if registered and a lock is active. Otherwise :  
 *                          - CvarReturn_AlreadyBounded
 *                          - CvarReturn_AlreadySet
 *
 * @return error        Throw a log error with :
 *                          - An invalid cvar pointer.
 */
native CvarSetBounds( handleCvar, CvarBounds:type, bool:set, Float:value = 0.0, bool:forceInterval = true );

/**
 * Retrieves the specified bound of a cvar.
 *
 * @param handleCvar    Handle to the cvar.
 * @param type          The type of bound to retrieve, CvarBound_Lower or CvarBound_Upper.
 * @param value         The floating point bound value.
 * @param pluginId      The plugin id where the bound has been registered.
 *
 * @return              1 on success.
 *
 * @return error        Throw a log error with :
 *                          - An invalid cvar pointer.
 *                          - A no-active min/max bound.
 */
native CvarGetBounds( handleCvar, CvarBounds:type, &Float:value, &pluginId = 0, &bool:forceInterval = true );

/**
 * Creates a new cvar.
 *
 * @param name           The name of the new cvar.
 * @param string         The string containing the default value of new cvar.
 * @param description    (optional) The description of the cvar.
 * @param flags          (optional) The flags determining how the cvar should be handled. See FCVAR_* constants for more details.
 * @param hasMin         (optional) Boolean that determines if the cvar has a minimum value.
 * @param minValue       (optional) Minimum floating point value that the cvar can have if hasMin is true.
 * @param hasMax         (optional) Boolean that determines if the cvar has a maximum value.
 * @param maxValue       (optional) Maximum floating point value that the cvar can have if hasMax is true.
 * @param forceInterval  (optional) Whether value should be inside the interval between min and max values (min <= value <= max)
 *                       or value should be equal to min or max (value == min or value == max).
 *
 * @return               A handle to the newly created cvar. If the cvar already exists, a handle to it will still be returned.
 */
native CvarRegister( const name[], const string[], const description[] = "", flags = 0, bool:hasMin = false, Float:minValue = 0.0, bool:hasMax = false, Float:maxValue = 0.0, bool:forceInterval = true );

/**
 * Get the current status of the cvar.
 *
 * @param handleCvar    Handle to the cvar.
 *
 * @return              Flags value on success.
 *
 * @return error        Throw a log error with :
 *                          - An invalid cvar pointer.
 */
native CvarStatus:CvarGetStatus( handleCvar );

/**
 * Get the number of registered cvars by the module.
 *
 * @return              The number of registered cvars.
 */
native CvarNum();

/**
 * Gives information about a cvar.
 *
 * @param index             The position in the list.
 * @param handleCvar        Handle to the cvar.
 * @param pluginId          (optional) The plugin id where the cvar is registered by the module. 
 * @param name              (optional) The buffer to store the cvar name.
 * @param nameLen           (optional) The size of the buffer.
 * @param value             (optional) The buffer to store the cvar value.
 * @param valueLen          (optional) The size of the buffer.
 * @param description       (optional) The buffer to store the cvar description.
 * @param descriptionLen    (optional) The size of the buffer.
 * @param flags             (optional) The flags determining how the cvar should be handled. See FCVAR_* constants for more details.
 *
 * @return                  The cvar status. See CvarStatus_* contants.
 *
 * @return error            Throw a log error with :
 *                              - An invalid index.
 */
native CvarStatus:CvarInfo( index, &handleCvar, &pluginId = -1, name[] = "", nameLen = 0, value[] = "", valueLen = 0, description[] = "", descriptionLen = 0, &flags = 0 );

/**
 * Get the cvar name from it's handle.
 *
 * @param handleCvar    Handle to the cvar.
 * @param cvar          The buffer to store the string in.
 * @param len           The size of the buffer.
 *
 * @return              The length of the cvar name.
 *
 * @return error        Throw a log error with :
 *                          - An invalid cvar pointer.
 */
native CvarGetName( handleCvar, cvar[], len );

/**
 * Set the cvar description from it's handle.
 *
 * @note  For a new cvar, see CvarRegister, it includes a description.
 *
 * @param handleCvar    Handle to the cvar.
 * @param description   The buffer to store the string in.
 *
 * @return              The length of the description string.
 *
 * @return error        Throw a log error with :
 *                          - An invalid cvar pointer.
 */
native CvarSetDescription( handleCvar, const description[] );

/**
 * Get the cvar name from it's handle.
 *
 * @param handleCvar    Handle to the cvar.
 * @param description   The buffer to store the string in.
 * @param len           The string size of the buffer.
 *
 * @return              The length of the description string.
 *
 * @return error        Throw a log error with :
 *                          - An invalid cvar pointer.
 */
native CvarGetDescription( handleCvar, description[], len );

/**
 * Returns information from a given plugin id.
 *
 * @param pluginId      The plugin id where the hook has been registered.
 * @param name          The buffer to store the plugin name.
 * @param nameLen       The size of the buffer.
 * @param title         The buffer to store the plugin title.
 * @param titleLen      The size of the buffer.
 *
 * @return              1 on success.
 *
 * @return error        Throw a log error with :
 *                          - An invalid plugin index.
 */
native CvarPluginInfo( pluginId, name[], nameLen, title[] = "", titleLen = 0 );


/**
 * Creates a new cvar where value is a boolean.
 *
 * @param name           The name of the new cvar.
 * @param string         The string containing the default value of new cvar.
 * @param description    (optional) The description of the cvar.
 * @param flags          (optional) The flags determining how the cvar should be handled. See FCVAR_* constants for more details.
 *
 * @return               A handle to the newly created cvar. If the cvar already exists, a handle to it will still be returned.
 */
stock CvarRegisterBoolean( const name[], const string[], const description[] = "", flags = 0 )
{
    return CvarRegister( name, string, description, flags, .hasMin = true, .minValue = 0.0, .hasMax = true, .maxValue = 1.0, .forceInterval = false );
}