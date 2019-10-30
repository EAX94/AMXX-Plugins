/**
 * These stocks are meant to mimic Sourcemod's data packs functionality,
 * and complement CellTrie/CellArray, allowing heterogeneous data in the same container to be accessed by index.
 * Storage is done in nested CellArrays, and there are no size limits other than those imposed by them, if any.  
 * They'll be specially usefull to pass data to/from callbacks and forwards.
 
 * Changelog:
 * ----------
 * 22/03/2009 - Initial Release
 * 23/03/2009 - Fixed DataPack_GetString not returning the proper string length
 *				Fixed accidental removal of stock modifier from functions
 * ----------
 *
 * Discussion Thread:
 * [http://forums.alliedmods.net/showthread.php?t=88304]
 */

#if defined __DATAPACK_INCLUDED
	#endinput
#endif
#define __DATAPACK_INCLUDED

#include <string>
#include <cellarray>

/**
 * Creation / Destruction functions
 */
 
/**
 * Creates a datapack for use.
 * 
 * @param iReserve		[optional] How many entries to reserve beforehand (they're not usable though)
 * @return			Handle to the DataPack Array
**/
stock Array:DataPack_Create(iReserve = 1)
{
	return ArrayCreate(2, iReserve)
}
	
/**
 * Destroys a DataPack, freeing all of it's sub-arrays.
 * You MUST use this instead of ArrayDestroy or you'll end up with a memory leak
 *
 * @param hDataPack		DataPack Handle
 * @return			void, meaningless
**/
stock DataPack_Free(&Array:hDataPack)
{
	if(!hDataPack)
		return
	
	new iSize = ArraySize(hDataPack)
	new iArray[2]
	
	for(new i=0; i < iSize; i++)
	{
		if(ArrayGetArray(hDataPack, i, iArray) && iArray[0] != DPACK_CELL)
			ArrayDestroy(Array:iArray[1])
	}
	
	ArrayDestroy(hDataPack)
}

/**
 * Informational functions
 */

/**
 * Returns the number of entries in a DataPack.
 *
 * @param hDataPack		DataPack Handle
 * @return			Number of entries
**/
stock DataPack_GetSize(Array:hDataPack)
{
	return ArraySize(hDataPack)
}

/**
 * Returns the type of an entry on a DataPack.
 * Types are defined below, and are self-explanatory with one exception:
 * Anything higher than 0 corresponds to an array's size.
 *
 * @param hDataPack		DataPack handle
 * @param iIndex		Entry	 index
 * @return			Integer from the enum below, or > 0 for an array size.
**/
enum DataPack {DPACK_INVALID = -2, DPACK_CELL = -1, DPACK_STRING = 0}
stock DataPack_GetItemType(Array:hDataPack, iIndex)
{
	new iArray[2]
	if(	!hDataPack
		|| !(0 <= iIndex < ArraySize(hDataPack))
		|| !ArrayGetArray(hDataPack, iIndex, iArray) )
	{
		return DPACK_INVALID
	}	
	
	return iArray[0]
}

/**
 * Insertion Functions
 */

/**
 * Pushes a single cell into an DataPack
 *
 * @param hDataPack		DataPack handle
 * @param cCell			Cell holding the data
 * @return			Boolean: success/fail
 */
stock bool:DataPack_PushCell(Array:hDataPack, any:cCell)
{
	if(!hDataPack)
		return false
	
	new any:iArray[2]
	iArray[0] = DPACK_CELL
	iArray[1] = cCell
	
	ArrayPushArray(hDataPack, iArray)
	return true
}

/**
 * Pushes an array into a DataPack.
 * The array size WILL be enforced on retrieval and MUST match the one passed on insertion,
 * so make sure your array sizes match.
 *
 * @param hDataPack			DataPack handle
 * @param cArray[]			Array containing the datapack
 * @param iArraySize		Size of the data array. MUST BE MATCHED ON RETRIEVAL
 * @return				Boolean: success/fail
 */
stock bool:DataPack_PushArray(Array:hDataPack, any:cArray[], iArraySize)
{
	if(!hDataPack || iArraySize < 1)
		return false
	
	new Array:hDataArray = ArrayCreate(iArraySize)
	if(!hDataArray)
		return false
	
	ArrayPushArray(hDataArray, cArray)
	
	new iArray[2]
	iArray[0] = iArraySize
	iArray[1] = hDataArray
	
	ArrayPushArray(hDataPack, iArray)
	return true
}
/**
 * Push a string into a DataPack.
 * Be careful with your string sizes on retrieval to avoid data loss.
 *
 * @param hDataPack			DataPack handle
 * @param szString[]		String to instert
 * @param iLen				[optional] Max. length to read from the string
 * @return				Actual length of the inserted string, 0 on fail
 */
stock DataPack_PushString(Array:hDataPack, szString[], iLen=-1)
{
	if(hDataPack)
		return 0
	
	new iStrLen = iLen
	if(iStrLen < 0)
		iStrLen = strlen(szstring)
	
	new Array:hStringArray = ArrayCreate(iStrLen + 1)
	if(!hStringArray)
		return 0
	
	ArrayPushString(hStringArray, szString)

	new iArray[2]
	iArray[0] = DPACK_STRING
	iArray[1] = _:hStringArray
	
	ArrayPushArray(hDataPack, iArray)
	return iStrLen
}

/**
 * Retrieval Functions
 */

/**
 * Retrieve a cell from a DataPack.
 * Result passed byref to allow fail check.
 *
 * @param hDataPack		DataPack handle
 * @param iIndex		Entry index
 * @param &cResult		Cell to store the data into
 * @return 			Boolean: success/fail
 */
stock bool:DataPack_GetCell(Array:hDataPack, iIndex, &any:cResult)
{
	new iArray[2]
	if(	!hDataPack
		|| !(0 <= iIndex < ArraySize(hDataPack))
		|| (!ArrayGetArray(hDataPack, iIndex, iArray) || iArray[0] != DPACK_CELL)
	)
	{	
		return false
	}
	
	cResult = iArray[1]
	return true
}
/**
 * Retrieve an array from a DataPack.
 * Passed size MUST match with one used for insertion, or the function will fail 
 *
 * @param hDataPack			DataPack handle
 * @param iIndex			Entry index
 * @param cArray[]			Array to store the data into
 * @param iArraySize		Size of the data array. MUST MATCH INSERTION SIZE
 * @return 				Boolean: success/fail
 */
stock bool:DataPack_GetArray(Array:hDataPack, iIndex, any:cArray[], iArraySize)
{
	new iArray[2], _iArraySize
	if(	iArraySize < 1 || !hDataPack
		|| !(0 <= iIndex < ArraySize(hDataPack))
		|| (!ArrayGetArray(hDataPack, iIndex, iArray))
		|| (iArray[0] != iArraySize)
	)
	{
		return false
	}
	
	new Array:hArrayArray = Array:iArray[1]
	return ArraySize(hArrayArray) ? bool:ArrayGetArray(hArrayArray, 0, cArray) : false
}
/**
 * Retrieve a string from a DataPack.
 *
 * @param hDataPack			DataPack handle
 * @param iIndex			Entry index
 * @param szResult[]		String to store the data into
 * @param iMaxLen			Max. length of the result string
 * @return 				length of the retrieved string
 */
stock DataPack_GetString(Array:hDataPack, iIndex, szResult[], iMaxLen)
{
	new iArray[2]
	if(	!hDataPack
		|| !(0 <= iIndex < ArraySize(hDataPack))
		|| (!ArrayGetArray(hDataPack, iIndex, iArray) || iArray[0] != DPACK_STRING)
	)
	{
		return 0
	}
	
	new Array:hStringArray = Array:iArray[1]
	if(ArraySize(hStringArray))
	{
		ArrayGetString(hStringArray, 0, szResult, iMaxLen)
		return strlen(szResult)
	}
	return 0
}