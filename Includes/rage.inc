
#if defined _rage_included
	#endinput
#endif
#define _rage_included

#include <rage_const>
 
 /**
 * Retrieves a function based on a function name
 * The name must be the same as the one in the file where the function is defined
 *
 * @param libFunctionName	The name of the function as it is in the file where the function is defined
 *
 * @return 					A handler to the function
 */
native RageFunc:RageGetFunction(const libFunctionName[])

 /**
 * Retrieves a virtual function based on a function name and a class of half life entities
 * The name must be the same as the one in the file where the function is defined
 *
 * @param libFunctionName	The name of the function as it is in the file where the function is defined
 * @param className	 		The classname where the function lies. Ex: "player"
 *
 * @return 					A handler to the function
 */
native RageFunc:RageGetFunctionFromClass(const libFunctionName[],const className[])

 /**
 * Retrieves a virtual function based on a function name and an entity
 * The name must be the same as the one in the file where the function is defined
 *
 * @param libFunctionName	The name of the function as it is in the file where the function is defined
 * @param entity	 		An entity with a relationship to that function
 *
 * @return 					A handler to the function
 */
native RageFunc:RageGetFunctionFromEntity(const libFunctionName[],const entity)

 /**
 * Retrieves a virtual function based on a function name and an object
 * The name must be the same as the one in the file where the function is defined
 *
 * @param libFunctionName	The name of the function as it is in the file where the function is defined
 * @param object	 		An object with a relationship to that function
 *
 * @return 					A handler to the function
 */
native RageFunc:RageGetFunctionFromObject(const libFunctionName[],const object)

/**
 * Tries to retrieve a function based on a function name
 * If it doesn't find one it returns invalid function instead of failing
 * The name must be the same as the one in the file where the function is defined
 *
 * @param libFunctionName	The name of the function as it is in the file where the function is defined
 *
 * @return 					A handler to the function
 */
native RageFunc:RageTryGetFunction(const libFunctionName[])

/**
 * Hooks a function
 *
 * @param function			A handler to the function
 * @param hookFunctionName	The function name in the plugin that shall be called upon interception of the original function
 * @param phase				The phase of the hook. It can have two values. Pre means "right before the original function is called". Post means "right after the original function is called"
 *
 * @return 					A handler to the hook
 */
native RageHook:RageCreateHook(RageFunc:function,const hookFunctionName[],RageHookPhase:phase = RageHookPre)

/**
 * Removes a hook
 *
 * @param hook			A handler to the hook
 */
native RageRemoveHook(&RageHook:hook)

/**
 * Sets the value of an argument of the hook
 * 
 * @param num 			The number of the argument. The first argument is the number 1
 * @param any			The value that will be set as argument for the hooked function. 
 */
native RageSetParam(num,any:...)

/**
 * Gets the return value of a function (to be used in post hooks)
 *
 * @param any			In case the value is multi cell (string or vector), an holder to receive them by ref
 * @return				In case the value is uni cell, the value itself
 */
native any:RageGetReturn(any:...)

/**
 * Sets the return value of a function
 *
 * @param any			Depending on the type of the return of the function, a value to be used as the return as the original hooked function
 */
native any:RageSetReturn(any:...)

/**
 * Calls a function and triggers its hooks
 * 
 * @param function		A handler to the function
 * @param any			The arguments of the function
 */
native RageCall(RageFunc:function,any:...)


