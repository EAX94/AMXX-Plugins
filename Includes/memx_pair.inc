/* Pair Container
 * (C)2007 Kuchiki Rukia
 * Licensed under the GNU General Public License.
 * No warranties of pair kind.
 */

#if defined _pair_included
  #endinput
#endif
#define _pair_included

// Pair is two any's, strapped together.
//	Using pairs, and couplings of pairs, you can create extremely complex structures.

// pair creation / destruction
//	Remember: You MUST destroy what you create, or a leak will occur.

native Pair:pair_create ( Pair:cpy = Pair:0, is_static = 0 )
native pair_destroy ( Pair:me )

// pair Conversion

native pair_clear ( Pair:me )
native pair_copy ( Pair:dsg, Pair:src )

// pair Comparison
//	comp is ==, lex is <
//	Just use the simpler tag comparisons | Pair:one == Pair:two will work fine.

native bool:pair_comp ( Pair:one, Pair:two )
native bool:pair_lex ( Pair:one, Pair:two )

// pair Information

native pair_empty ( Pair:one )

// pair Set/Get
//	pairs just hold one value.
//	Think of it like a black box

native Any:pair_get_first ( Pair:one )
native Raw:pair_get_first_raw ( Pair:one )

native bool:pair_get_first_bool ( Pair:one )
native pair_get_first_int ( Pair:one )
native Float:pair_get_first_float ( Pair:one )
native Ptr:pair_get_first_ptr ( Pair:one )

native pair_get_first_vector ( Pair:one, Float:vec[3] )
native pair_get_first_array ( Pair:one, vec[], len )
native pair_get_first_string ( Pair:one, vec[], len )

native pair_set_first ( Pair:one, Any:newval )
native pair_set_first_none ( Pair:one )

native pair_set_first_bool ( Pair:one, bool:set )
native pair_set_first_int ( Pair:one, set )
native pair_set_first_float ( Pair:one, Float:set )
native pair_set_first_ptr ( Pair:one, Ptr:set )

native pair_set_first_vector ( Pair:one, Float:vec[3] )
native pair_set_first_array ( Pair:one, set[], len )
native pair_set_first_string ( Pair:one, set[] )

native Any:pair_get_second ( Pair:one )
native Raw:pair_get_second_raw ( Pair:one )

native bool:pair_get_second_bool ( Pair:one )
native pair_get_second_int ( Pair:one )
native Float:pair_get_second_float ( Pair:one )
native Ptr:pair_get_second_ptr ( Pair:one )

native pair_get_second_vector ( Pair:one, Float:vec[3] )
native pair_get_second_array ( Pair:one, vec[], len )
native pair_get_second_string ( Pair:one, vec[], len )

native pair_set_second ( Pair:one, Any:newval )
native pair_set_second_none ( Pair:one )

native pair_set_second_bool ( Pair:one, bool:set )
native pair_set_second_int ( Pair:one, set )
native pair_set_second_float ( Pair:one, Float:set )
native pair_set_second_ptr ( Pair:one, Ptr:set )

native pair_set_second_vector ( Pair:one, Float:vec[3] )
native pair_set_second_array ( Pair:one, set[], len )
native pair_set_second_string ( Pair:one, set[] )

// * pair Type
//	This is to make comparisons easy, and to make it so people don't screw up our pointers.

stock bool:operator==(Pair:oper1, Pair:oper2)
	return pair_comp(oper1, oper2) == 0;

stock bool:operator!=(Pair:oper1, Pair:oper2)
	return pair_comp(oper1, oper2) != 0;

// Flip em around, and lex em.
stock bool:operator>(Pair:oper1, Pair:oper2)
	return pair_lex(oper2, oper1)

stock bool:operator>=(Pair:oper1, Pair:oper2)
	return (pair_lex(oper2, oper1) ) || (pair_comp(oper1, oper2) ) 

stock bool:operator<(Pair:oper1, Pair:oper2)
	return pair_lex(oper1, oper2)

stock bool:operator<=(Pair:oper1, Pair:oper2)
	return (pair_lex(oper1, oper2) ) || (pair_comp(oper1, oper2) ) 

// Rukia: Our types can't do pairthing but comparisons.
forward Pair:operator*(Pair:oper1, Pair:oper2);
forward Pair:operator/(Pair:oper1, Pair:oper2);
forward Pair:operator+(Pair:oper1, Pair:oper2);
forward Pair:operator-(Pair:oper1, Pair:oper2)

forward Pair:operator++(Pair:oper)
forward Pair:operator--(Pair:oper)
forward Pair:operator-(Pair:oper)
forward Pair:operator*(Pair:oper1, oper2)
forward Pair:operator/(Pair:oper1, oper2)
forward Pair:operator/(oper1, Pair:oper2)
forward Pair:operator+(Pair:oper1, oper2)
forward Pair:operator-(Pair:oper1, oper2)
forward Pair:operator-(oper1, Pair:oper2)
forward bool:operator>=(Pair:oper1, oper2)
forward bool:operator>=(oper1, Pair:oper2)
forward bool:operator==(Pair:oper1, oper2)
forward bool:operator!=(Pair:oper1, oper2)
forward bool:operator>(Pair:oper1, oper2)
forward bool:operator>(oper1, Pair:oper2)
forward bool:operator<(Pair:oper1, oper2)
forward bool:operator<(oper1, Pair:oper2)
forward bool:operator<=(Pair:oper1, oper2)
forward bool:operator<=(oper1, Pair:oper2)
forward bool:operator!(Pair:oper)
forward operator%(Pair:oper1, Pair:oper2);
forward operator%(Pair:oper1, oper2);
forward operator%(oper1, Pair:oper2);

