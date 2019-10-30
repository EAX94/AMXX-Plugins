#if defined _pdatas_stocks_included
  #endinput
#endif
#define _pdatas_stocks_included

#include <fakemeta>

#define SHORT_BYTES	2
#define INT_BYTES		4
#define BYTE_BITS		8

stock get_pdata_char(ent, charbased_offset, intbase_linuxdiff = 5)
{
	return ( get_pdata_int(ent, charbased_offset / INT_BYTES, intbase_linuxdiff)>>>((charbased_offset % INT_BYTES) * BYTE_BITS) ) & 0xFF;
}

stock bool:get_pdata_bool(ent, charbased_offset, intbase_linuxdiff = 5)
{
	return !!( get_pdata_int(ent, charbased_offset / INT_BYTES, intbase_linuxdiff) & (0xFF<<((charbased_offset % INT_BYTES) * BYTE_BITS)) );
}

stock set_pdata_char(ent, charbased_offset, value, intbase_linuxdiff = 5)
{
	value &= 0xFF;
	new int_offset_value = get_pdata_int(ent, charbased_offset / INT_BYTES, intbase_linuxdiff);
	new bit_decal = (charbased_offset % INT_BYTES) * BYTE_BITS;
	int_offset_value &= ~(0xFF<<bit_decal); // clear byte
	int_offset_value |= value<<bit_decal;
	set_pdata_int(ent, charbased_offset / INT_BYTES, int_offset_value, intbase_linuxdiff);
	return 1;
}

stock set_pdata_bool(ent, charbased_offset, bool:value, intbase_linuxdiff = 5)
{
	set_pdata_char(ent, charbased_offset, _:value, intbase_linuxdiff);
}

stock get_pdata_short(ent, shortbased_offset, intbase_linuxdiff = 5)
{
	return ( get_pdata_int(ent, shortbased_offset / SHORT_BYTES, intbase_linuxdiff)>>>((shortbased_offset % SHORT_BYTES) * BYTE_BITS) ) & 0xFFFF;
}

stock set_pdata_short(ent, shortbased_offset, value, intbase_linuxdiff = 5)
{
	value &= 0xFFFF;
	new int_offset_value = get_pdata_int(ent, shortbased_offset / SHORT_BYTES, intbase_linuxdiff);
	new bit_decal = (shortbased_offset % SHORT_BYTES) * BYTE_BITS;
	int_offset_value &= ~(0xFFFF<<bit_decal); // clear byte
	int_offset_value |= value<<bit_decal;
	set_pdata_int(ent, shortbased_offset / SHORT_BYTES, int_offset_value, intbase_linuxdiff);
	return 1;
}

stock get_pdata_vector(ent, const vec_offsets[3], Float:dest[3], intbase_linuxdiff=5)
{
	static i;
	for(i=0; i<3; i++)
	{
		dest[i] = get_pdata_float(ent, vec_offsets[i], intbase_linuxdiff);
	}
}

stock set_pdata_vector(ent, const vec_offsets[3], const Float:vec[3], intbase_linuxdiff=5)
{
	static i;
	for(i=0; i<3; i++)
	{
		set_pdata_float(ent, vec_offsets[i], vec[i], intbase_linuxdiff);
	}
}

// If you pass only 1st offset of a vec :
stock get_pdata_vec2(ent, vec_offset, Float:dest[3], intbase_linuxdiff=5)
{
	static i;
	for(i=0; i<3; i++)
	{
		dest[i] = get_pdata_float(ent, vec_offsets + i, intbase_linuxdiff);
	}
}

stock set_pdata_vec2(ent, vec_offsets, const Float:vec[3], intbase_linuxdiff=5)
{
	static i;
	for(i=0; i<3; i++)
	{
		set_pdata_float(ent, vec_offsets + i, vec[i], intbase_linuxdiff);
	}
}

stock get_pdata_ehandle(ent, iOffset, &serial=0, intbased_linuxdiff=5)
{
	if( serial )
	{
		serial = get_pdata_int(ent, iOffset+1, intbased_linuxdiff)
	}
	return get_pdata_ent(ent, iOffset * INT_BYTES, intbased_linuxdiff * INT_BYTES)
}

stock set_pdata_ehandle(ent, iOffset, handle, intbased_linuxdiff=5)
{
	set_pdata_ent(
	if( serial )
	{
		serial = get_pdata_int(ent, iOffset+1, intbased_linuxdiff)
	}
	return get_pdata_int(ent, iOffset * INT_BYTES, intbased_linuxdiff * INT_BYTES)
}