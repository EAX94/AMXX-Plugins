/* Vector Container
 * (C)2007 Kuchiki Rukia
 * Licensed under the GNU General Public License.
 * No warranties of pair kind.
 */

#if defined _vector_x_included
  #endinput
#endif
#define _vector_x_included

// Vectors are dynamic arrays; they can be resized, but work just like is_static arrays.
//	Unfortunately, PAWN doesn't allow me to overload [], so its a bit harder to use my vectors.

// Vector creation / destruction
//	Remember: If the is_static flag isn't set, these are dynamically allocated; you must delete them manually.
//	is_static flagged creations don't need to be deleted, but be careful with them.

native Vector:vector_create ( Vector:cpy = Vector:0, is_static = 0 )
native vector_destroy ( Vector:me )

// Vector Conversion

native vector_clear ( Vector:me )
native vector_copy ( Vector:dsg, Vector:src )

// Vector Comparison
//	comp is ==, lex is <
//	Just use the simpler tag comparisons | Vector:one == Vector:two will work fine.

native bool:vector_comp ( Vector:one, Vector:two )
native bool:vector_lex ( Vector:one, Vector:two )

// Vector Iterators
//	Remember: If the is_static flag isn't set, these are dynamically allocated; you must delete them manually.

//	For faster, more effecient loops, and an easier to use syntax, set the is_static flag.
//	However, is_static flagged iterators are non-reentrant
//	What this means is, don't store these anywhere; treat them as temporary variables.
//	Also, don't call functions that use them while using them; you'll overwrite yourself.


native Iterator:vector_end ( Vector:one, is_static = 0 )
native Iterator:vector_begin ( Vector:one, is_static = 0 )
native Iterator:vector_at ( Vector:one, slot, is_static = 0 )

native Iterator:vector_rend ( Vector:one, is_static = 0 )
native Iterator:vector_rbegin ( Vector:one, is_static = 0 )
native Iterator:vector_rat ( Vector:one, slot, is_static = 0 )

// Vector Information

native bool:vector_empty ( Vector:one )
native vector_size ( Vector:one )
native vector_memory ( Vector:one )

// Vector Random Access

native Any:vector_get ( Vector:one, slot )
native Raw:vector_get_raw ( Vector:one, slot )

native bool:vector_get_bool ( Vector:one, slot )
native vector_get_int ( Vector:one, slot )
native Float:vector_get_float ( Vector:one, slot )
native Ptr:vector_get_ptr ( Vector:one, slot )

native vector_get_vector ( Vector:one, slot, Float:vec[3] )
native vector_get_array ( Vector:one, slot, vec[], len )
native vector_get_string ( Vector:one, slot, vec[], len )

native vector_set ( Vector:one, slot, Any:set )
native vector_set_none ( Vector:one, slot )

native vector_set_bool ( Vector:one, slot, bool:set )
native vector_set_int ( Vector:one, slot, set )
native vector_set_float ( Vector:one, slot, Float:set )
native vector_set_ptr ( Vector:one, slot, Ptr:set )

native vector_set_vector ( Vector:one, slot, Float:vec[3] )
native vector_set_array ( Vector:one, slot, set[], len )
native vector_set_string ( Vector:one, slot, set[] )

// Vector Push/Pop/Peek

native vector_pop ( Vector:one )

native Any:vector_peek ( Vector:one )
native Raw:vector_peek_raw ( Vector:one )

native bool:vector_peek_bool ( Vector:one )
native vector_peek_int ( Vector:one )
native Float:vector_peek_float ( Vector:one )
native Ptr:vector_peek_ptr ( Vector:one )

native vector_peek_vector ( Vector:one, Float:vec[3] )
native vector_peek_array ( Vector:one, vec[], len )
native vector_peek_string ( Vector:one, vec[], len )

native vector_push ( Vector:one, Any:set )
native vector_push_none ( Vector:one )

native vector_push_bool ( Vector:one, bool:set )
native vector_push_int ( Vector:one, set )
native vector_push_float ( Vector:one, Float:set )
native vector_push_ptr ( Vector:one, Ptr:set )

native vector_push_vector ( Vector:one, Float:vec[3] )
native vector_push_array ( Vector:one, set[], len )
native vector_push_string ( Vector:one, set[] )

// Vector Front

native Any:vector_front ( Vector:one )
native Raw:vector_front_raw ( Vector:one )

native bool:vector_front_bool ( Vector:one )
native vector_front_int ( Vector:one )
native Float:vector_front_float ( Vector:one )
native Ptr:vector_front_ptr ( Vector:one )

native vector_front_vector ( Vector:one, Float:vec[3] )
native vector_front_array ( Vector:one, vec[], len )
native vector_front_string ( Vector:one, vec[], len )

// Vector Back

native Any:vector_back ( Vector:one )
native Raw:vector_back_raw ( Vector:one )

native bool:vector_back_bool ( Vector:one )
native vector_back_int ( Vector:one )
native Float:vector_back_float ( Vector:one )
native Ptr:vector_back_ptr ( Vector:one )

native vector_back_vector ( Vector:one, Float:vec[3] )
native vector_back_array ( Vector:one, vec[], len )
native vector_back_string ( Vector:one, vec[], len ) 

// * Vector Type
//	This is to make comparisons easy, and to make it so people don't screw up our pointers.

stock bool:operator==(Vector:oper1, Vector:oper2)
	return vector_comp(oper1, oper2) == 0;

stock bool:operator!=(Vector:oper1, Vector:oper2)
	return vector_comp(oper1, oper2) != 0;

// Flip em around, and lex em.
stock bool:operator>(Vector:oper1, Vector:oper2)
	return vector_lex(oper2, oper1)

stock bool:operator>=(Vector:oper1, Vector:oper2)
	return (vector_lex(oper2, oper1) ) || (vector_comp(oper1, oper2) ) 

forward bool:operator>=(Vector:oper1, oper2)
forward bool:operator>=(oper1, Vector:oper2)

stock bool:operator<(Vector:oper1, Vector:oper2)
	return vector_lex(oper1, oper2)

stock bool:operator<=(Vector:oper1, Vector:oper2)
	return (vector_lex(oper1, oper2) ) || (vector_comp(oper1, oper2) ) 

// Rukia: Our types can't do anything but comparisons.
forward Vector:operator*(Vector:oper1, Vector:oper2);
forward Vector:operator/(Vector:oper1, Vector:oper2);
forward Vector:operator+(Vector:oper1, Vector:oper2);
forward Vector:operator-(Vector:oper1, Vector:oper2)

forward Vector:operator++(Vector:oper)
forward Vector:operator--(Vector:oper)
forward Vector:operator-(Vector:oper)
forward Vector:operator*(Vector:oper1, oper2)
forward Vector:operator/(Vector:oper1, oper2)
forward Vector:operator/(oper1, Vector:oper2)
forward Vector:operator+(Vector:oper1, oper2)
forward Vector:operator-(Vector:oper1, oper2)
forward Vector:operator-(oper1, Vector:oper2)
forward bool:operator==(Vector:oper1, oper2)
forward bool:operator!=(Vector:oper1, oper2)
forward bool:operator>(Vector:oper1, oper2)
forward bool:operator>(oper1, Vector:oper2)
forward bool:operator<(Vector:oper1, oper2)
forward bool:operator<(oper1, Vector:oper2)
forward bool:operator<=(Vector:oper1, oper2)
forward bool:operator<=(oper1, Vector:oper2)
forward bool:operator!(Vector:oper)
forward operator%(Vector:oper1, Vector:oper2);
forward operator%(Vector:oper1, oper2);
forward operator%(oper1, Vector:oper2);
