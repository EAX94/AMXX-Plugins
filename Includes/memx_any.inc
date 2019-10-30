/* Any Container
 * (C)2007 Kuchiki Rukia
 * Licensed under the GNU General Public License.
 * No warranties of any kind.
 */

#if defined _any_included
  #endinput
#endif
#define _any_included

// Any creation / destruction
//	Remember: You MUST destroy what you create, or a leak will occur.

native Any:any_create ( Any:cpy = Any:0, is_static = 0);
native any_destroy ( Any:me )

// Any Conversion

native any_clear ( Any:me )
native any_copy ( Any:dsg, Any:src )

// Any Comparison
//	comp is ==, lex is <
//	Just use the simpler tag comparisons | Any:one == Any:two will work fine.

native bool:any_comp ( Any:one, Any:two )
native bool:any_lex ( Any:one, Any:two )

// Any Information

native any_empty ( Any:one )

// Use the type enum 
native any_type ( Any:one )

// Any Set/Get
//	Anys just hold one value.
//	Think of it like a black box

native Raw:any_get_raw ( Any:one )

native bool:any_get_bool ( Any:one )
native any_get_int ( Any:one )
native Float:any_get_float ( Any:one )
native Ptr:any_get_ptr ( Any:one )

native any_get_vector ( Any:one, Float:vec[3] )
native any_get_array ( Any:one, vec[], len )
native any_get_string ( Any:one, vec[], len )

native any_set_none ( Any:one )

native any_set_bool ( Any:one, bool:set )
native any_set_int ( Any:one, set )
native any_set_float ( Any:one, Float:set )
native any_set_ptr ( Any:one, Ptr:set )

native any_set_vector ( Any:one, Float:vec[3] )
native any_set_array ( Any:one, set[], len )
native any_set_string ( Any:one, set[] )



// Type enumeration
// None = NULL, Custom is for OOP objects, Pointer is for pointers (such as to other any's)

	enum { ANY_TYPE_NONE = 0, ANY_TYPE_BOOL, ANY_TYPE_INT, ANY_TYPE_FLOAT, 
		ANY_TYPE_VECTOR, ANY_TYPE_ARRAY, ANY_TYPE_STRING,
			ANY_TYPE_POINTER, ANY_TYPE_CUSTOM };


// * any Type
//	This is to make comparisons easy, and to make it so people don't screw up our pointers.

stock bool:operator==(Any:oper1, Any:oper2)
	return any_comp(oper1, oper2) == 0;

stock bool:operator!=(Any:oper1, Any:oper2)
	return any_comp(oper1, oper2) != 0;

// Flip em around, and lex em.
stock bool:operator>(Any:oper1, Any:oper2)
	return any_lex(oper2, oper1)

stock bool:operator>=(Any:oper1, Any:oper2)
	return (any_lex(oper2, oper1) ) || (any_comp(oper1, oper2) ) 

stock bool:operator<(Any:oper1, Any:oper2)
	return any_lex(oper1, oper2)

stock bool:operator<=(Any:oper1, Any:oper2)
	return (any_lex(oper1, oper2) ) || (any_comp(oper1, oper2) ) 

// Rukia: Our types can't do anything but comparisons.
forward Any:operator*(Any:oper1, Any:oper2);
forward Any:operator/(Any:oper1, Any:oper2);
forward Any:operator+(Any:oper1, Any:oper2);
forward Any:operator-(Any:oper1, Any:oper2)

forward Any:operator++(Any:oper)
forward Any:operator--(Any:oper)
forward Any:operator-(Any:oper)
forward Any:operator*(Any:oper1, any:oper2)
forward Any:operator/(Any:oper1, any:oper2)
forward Any:operator/(any:oper1, Any:oper2)
forward Any:operator+(Any:oper1, any:oper2)
forward Any:operator-(Any:oper1, any:oper2)
forward Any:operator-(any:oper1, Any:oper2)
forward bool:operator>=(Any:oper1, any:oper2)
forward bool:operator>=(any:oper1, Any:oper2)
forward bool:operator==(Any:oper1, any:oper2)
forward bool:operator!=(Any:oper1, any:oper2)
forward bool:operator>(Any:oper1, any:oper2)
forward bool:operator>(any:oper1, Any:oper2)
forward bool:operator<(Any:oper1, any:oper2)
forward bool:operator<(any:oper1, Any:oper2)
forward bool:operator<=(Any:oper1, any:oper2)
forward bool:operator<=(any:oper1, Any:oper2)
forward bool:operator!(Any:oper)
forward operator%(Any:oper1, Any:oper2);
forward operator%(Any:oper1, any:oper2);
forward operator%(any:oper1, Any:oper2);