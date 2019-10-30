/*
	  Boolean functions
	
	  by  Lulu the hero
	(m_lajos@hotmail.com)

https://forums.alliedmods.net/showthread.php?t=144645
	
Last update(dd.mm.yyyy): 22.12.2010.

These set of stocks/defines ease up bit manipulations.

This file is provided as is (no warranties).
*/

#if defined _boolean_included
	#endinput
#endif

#define _boolean_included

#if cellbits==32
	#define cellbytes	4
	#define player_to_flag(%1)		(1<<(%1&31))
#else
	#define cellbytes	8
	#define player_to_flag(%1)		(1<<%1)
#endif

new const HEXCHARS[] = "0123456789ABCDEF";

/* ----- in the functions below %1 is the integer, %2 is the player's id ----- */

// Negate a bit - with XOR
#define toggle_player_flag(%1,%2)	(%1 = %1 ^ player_to_flag(%2))

// Clear a bit - set it to 0 with NAND
#define clear_player_flag(%1,%2)	(%1 = %1 & ~player_to_flag(%2))

// Set a bit - set is to 1 with OR
#define set_player_flag(%1,%2)		(%1 = %1 | player_to_flag(%2))

// Returns a bit's value - with AND
#define is_player_flag_set(%1,%2)	(%1 & player_to_flag(%2))

// Converts the integer to a binary number string
stock num_to_binstr(num, dest[], len=32)
{
	static i;
	if(len>cellbits)
	{
		len = cellbits;
	}
	len--;
	for(i=0; i<=len; i++)
	{
		dest[len-i] = ((num>>i) & 1) + '0';
	}
	dest[len+1] = 0;
	return len;
}

// Converts the integer to a hexadecimal number string
stock num_to_hexstr(num, dest[], len=4)
{
	static i;
	if(len>cellbytes)
	{
		len = cellbytes;
	}
	len--;
	for(i=0; i<=len; i++)
	{
		dest[len-i] = HEXCHARS[((num>>(i<<2)) & 15)];
	}
	dest[len+1] = 0;
	return len;
}

// Rotates an integer's bits to left
stock rol(integer, step=1)
{
	if(step>=cellbits)
	{
		step = step % cellbits;
	}
	if(!step)
	{
		return integer;
	}
	
	static overflow;
	
	overflow = integer;
	integer <<= step;
	
	overflow >>= (cellbits-step);
	
	return integer | overflow;
}

// Rotates an integer's bits to right
stock ror(integer, step=1)
{
	if(step>=cellbits)
	{
		step = step % cellbits;
	}
	if(!step)
	{
		return integer;
	}
	
	static overflow;
	
	overflow = integer;
	integer >>= step;
	
	overflow <<= (cellbits-step);
	
	return integer | overflow;
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1038\\ f0\\ fs16 \n\\ par }
*/
