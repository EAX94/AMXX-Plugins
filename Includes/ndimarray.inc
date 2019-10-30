#if defined _ndim_array_included
	#endinput
#endif

#define _ndim_array_included

#include <cellarray>

enum NDim
{
	Invalid_NDim = 0,
}
/**
 * These arrays are intended to be used for a form of global storage without 
 * limiting how many dimensions a person may need.
 * These are not designed to be used as a replacement for normal arrays, as
 * normal arrays are faster and should be used whenever possible.
 */

/**
 * Creates an N Dimensional Array
 *
 * @param cellsize		The cellsize for the last dimension.
 * @param ...			Each param is the size for a dimension.
 *
 * @note				The cellsize should only be changed if working with strings or arrays.
 * @note2				NDim Arrays start zeroed.
 *
 * @return				The NDim handle.
 */
stock NDim:NDimCreate( const cellsize=1, ... )
{
	new argnum = numargs();
	if( !argnum )
		return Invalid_NDim;

	new i, total_size = 1;
	for( i=1; i<argnum; i++ )
		total_size *= getarg(i);

	if( total_size <= 0 )
		return Invalid_NDim;

	new Array:actual_array = ArrayCreate(cellsize,1);
	for( i=0; i<total_size; i++ )
		ArrayPushCell( actual_array, 0 );

	new Array:tracker = ArrayCreate(1,1);
	ArrayPushCell( tracker, actual_array );
	for( i=1; i<argnum; i++ )
		ArrayPushCell( tracker, getarg(i) );

	return NDim:tracker;
}
/**
 * Destroys the NDim Array, and resets the handle to 0 to prevent accidental usage after it is destroyed.
 *
 * @param tracker		The array to destroy.
 */
stock NDimDestroy( &NDim:tracker )
{
	ArrayDestroy( Array:ArrayGetCell(Array:tracker, 0) );
	ArrayDestroy( Array:tracker );
	tracker = Invalid_NDim;
}

/**
 * Returns a single cell of data from an NDim Array.
 *
 * @param tracker		The array to retrieve the item from.
 * @param ...			Each param is the element for the corresponding dimension.
 *
 * @return				The value of the cell.
 */
stock any:NDimGetCell( const NDim:tracker, ... )
{
	new temp_position, position, Array:actual_array = Array:ArrayGetCell(Array:tracker, 0);
	new argnum = numargs()-1;
	for( new i=1,j; i<argnum; i++ )
	{
		temp_position = getarg(i);
		for( j=i; j<argnum; j++ )
			temp_position *= _:ArrayGetCell(Array:tracker, j+1);
		position += temp_position;
	}
	position += getarg(argnum);
	return ArrayGetCell(actual_array, position);
}
/**
 * Returns data within an NDim Array.  
 * Make sure the output buffer matches the size the array was created with!
 *
 * @param tracker		The array to retrieve the item from.
 * @param data			The output buffer to write.
 * @param ...			Each param is the element for the corresponding dimension.
 */
stock NDimGetArray( const NDim:tracker, data[], ... )
{
	new temp_position, position, Array:actual_array = Array:ArrayGetCell(Array:tracker, 0);
	new argnum = numargs()-1;
	for( new i=2,j; i<argnum; i++ )
	{
		temp_position = getarg(i);
		for( j=i; j<argnum; j++ )
			temp_position *= _:ArrayGetCell(Array:tracker, j);
		position += temp_position;
	}
	position += getarg(argnum);
	return ArrayGetArray(actual_array, position, data);
}
/**
 * Returns a string value from an NDim Array.
 *
 * @param tracker		The array to retrieve the item from.
 * @param output		The variable to store the value in.
 * @param size			Character size of the output buffer.
 * @param ...			Each param is the element for the corresponding dimension.
 */
stock NDimGetString( const NDim:tracker, output[], const size, ... )
{
	new temp_position, position, Array:actual_array = Array:ArrayGetCell(Array:tracker, 0);
	new argnum = numargs()-1;
	for( new i=3,j; i<argnum; i++ )
	{
		temp_position = getarg(i);
		for( j=i-1; j<argnum-1; j++ )
			temp_position *= _:ArrayGetCell(Array:tracker, j);
		position += temp_position;
	}
	position += getarg(argnum);
	return ArrayGetString(actual_array, position, output, size);
}

/**
 * Sets an NDim Array's single cell value.  Use this only on array that were created with a cellsize of 1!
 *
 * @param tracker		The array to set the item from within.
 * @param input			The value to set.
 * @param ...			Each param is the element for the corresponding dimension.
 */
stock NDimSetCell( const NDim:tracker, const any:input, ... )
{
	new temp_position, position, Array:actual_array = Array:ArrayGetCell(Array:tracker, 0);
	new argnum = numargs()-1;
	for( new i=2,j; i<argnum; i++ )
	{
		temp_position = getarg(i);
		for( j=i; j<argnum; j++ )
			temp_position *= _:ArrayGetCell(Array:tracker, j);
		position += temp_position;
	}
	position += getarg(argnum);
	return ArraySetCell(actual_array, position, input);
}
/**
 * Sets an item's data with that of a local buffer.  
 * The buffer size must match what the cellsize that the array was created with!
 *
 * @param tracker		The array to set the item from within.
 * @param input			The input buffer to store.
 * @param ...			Each param is the element for the corresponding dimension.
 */
stock NDimSetArray( const NDim:tracker, const any:input[], ... )
{
	new temp_position, position, Array:actual_array = Array:ArrayGetCell(Array:tracker, 0);
	new argnum = numargs()-1;
	for( new i=2,j; i<argnum; i++ )
	{
		temp_position = getarg(i);
		for( j=i; j<argnum; j++ )
			temp_position *= _:ArrayGetCell(Array:tracker, j);
		position += temp_position;
	}
	position += getarg(argnum);
	return ArraySetArray(actual_array, position, input);
}
/**
 * Sets a string value for an NDim Array.  
 * The stored string will be truncated if it is longer than the cellsize the array was created with!
 *
 * @param tracker		The array to set the item from within.
 * @param input			The string to set the item as.
 * @param ...			Each param is the element for the corresponding dimension.
 */
stock NDimSetString( const NDim:tracker, const input[], ... )
{
	new temp_position, position, Array:actual_array = Array:ArrayGetCell(Array:tracker, 0);
	new argnum = numargs()-1;
	for( new i=2,j; i<argnum; i++ )
	{
		temp_position = getarg(i);
		for( j=i; j<argnum; j++ )
			temp_position *= _:ArrayGetCell(Array:tracker, j);
		position += temp_position;
	}
	position += getarg(argnum);
	return ArraySetString(actual_array, position, input);
}

/**
 * Sets all of an NDim Array's single cell values.  Use this only on array that were created with a cellsize of 1!
 *
 * @param tracker		The array to set the item from within.
 * @param input			The value to set.
 */
stock NDimFillCell( const NDim:tracker, const any:input )
{
	new i, total_size = 1;
	new argnum = ArraySize(Array:tracker) - 1;
	for( i=0; i<argnum; i++ )
		total_size *= ArrayGetCell(Array:tracker, i+1);

	new Array:actual_array = ArrayGetCell(Array:tracker, 0);
	for( i=0; i<total_size; i++ )
		ArraySetCell(actual_array, i, input);
}
/**
 * Sets all items' data with that of a local buffer.  
 * The buffer size must match what the cellsize that the array was created with!
 *
 * @param tracker		The array to set the item from within.
 * @param input			The input buffer to store.
 */
stock NDimFillArray( const NDim:tracker, const any:input[] )
{
	new i, total_size = 1;
	new argnum = ArraySize(Array:tracker) - 1;
	for( i=0; i<argnum; i++ )
		total_size *= ArrayGetCell(Array:tracker, i+1);

	new Array:actual_array = ArrayGetCell(Array:tracker, 0);
	for( i=0; i<total_size; i++ )
		ArraySetArray(actual_array, i, input);
}
/**
 * Sets all string values for an NDim Array.  
 * The stored string will be truncated if it is longer than the cellsize the array was created with!
 *
 * @param tracker		The array to set the item from within.
 * @param input			The string to set the item as.
 */
stock NDimFillString( const NDim:tracker, const input[] )
{
	new i, total_size = 1;
	new argnum = ArraySize(Array:tracker) - 1;
	for( i=0; i<argnum; i++ )
		total_size *= ArrayGetCell(Array:tracker, i+1);

	new Array:actual_array = ArrayGetCell(Array:tracker, 0);
	for( i=0; i<total_size; i++ )
		ArraySetString(actual_array, i, input);
}
