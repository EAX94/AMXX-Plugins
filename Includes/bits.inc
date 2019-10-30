#if defined _bits_included
	#endinput
#endif
#define _bits_included
/*
	Bits manipulation Zefir<zefir-cs@ukr.net>
		developed for Cerberus project
		http://cerberus.cstrike.in.ua/
	spring 2008 (c) Zefir

*/

/*
	bits manipulation
	predefine bit numbers as:

		enum e_flags {
			FLAG_1,
			FLAG_2,
			FLAG_3,
			FLAG_4
		}

	and use as:

		new flag
		set_bit(flag, FLAG_2)
		get_bit(flag, FLAG_3)
*/
#define set_bit(%1,%2)	(%1 |= (1<<%2))
#define get_bit(%1,%2)	(%1 & (1<<%2))
#define clr_bit(%1,%2)	(%1 &= ~(1<<%2))

/*
	bitmask manipulation
	predefine bits as:

		#define CLIENT_FLAG_1	(1<<0)
		#define CLIENT_FLAG_2	(1<<1)
		#define CLIENT_FLAG_3	(1<<2)
		#define CLIENT_FLAG_4	(1<<3)

	and use it:

		new flag[32]
		//set both flags
		set_bits(flag[1], CLIENT_FLAG_1 | CLIENT_FLAG_3)
		// clear bits
		clr_bits(flag[1], CLIENT_FLAG_1 | CLIENT_FLAG_4 | CLIENT_FLAG_2)
*/
#define set_bits(%1,%2)	(%1 |= %2)
#define get_bits(%1,%2)	(%1 & %2)
#define clr_bits(%1,%2)	(%1 &= ~%2)

/*
	big count bits manipulation
	define bits container as array
	new flags[4]
	possible 4 * 32 = 128 bit stored
	
	Big thanks ConnorMcLeod for optimization
*/
#define set_big_bit(%1,%2)	(%1[%2>>5] |= 1<<(%2 & 31))
#define get_big_bit(%1,%2)	(%1[%2>>5] & 1<<(%2 & 31))
#define clr_big_bit(%1,%2)	(%1[%2>>5] &= ~(1 << (%2 & 31)))