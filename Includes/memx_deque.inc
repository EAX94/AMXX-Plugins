/* Deque Container
 * (C)2007 Kuchiki Rukia
 * Licensed under the GNU General Public License.
 * No warranties of pair kind.
 */

#if defined _deque_x_included
  #endinput
#endif
#define _deque_x_included

// Deques are like vectors, but you can do operations on both ends quickly.
//	They are used to make queues, and they waste more space than vectors for their extra functionality.

// Deque creation / destruction
//	Remember: If the is_static flag isn't set, these are dynamically allocated; you must delete them manually.
//	is_static flagged creations don't need to be deleted, but be careful with them.

native Deque:deque_create ( Deque:cpy = Deque:0, is_static = 0 )
native deque_destroy ( Deque:me )

// Deque Conversion

native deque_clear ( Deque:me )
native deque_copy ( Deque:dsg, Deque:src )

// Deque Comparison
//	comp is ==, lex is <
//	Just use the simpler tag comparisons | Deque:one == Deque:two will work fine.

native bool:deque_comp ( Deque:one, Deque:two )
native bool:deque_lex ( Deque:one, Deque:two )

// Deque Iterators
//	Remember: If the is_static flag isn't set, these are dynamically allocated; you must delete them manually.

//	For faster, more effecient loops, and an easier to use syntax, set the is_static flag.
//	However, is_static flagged iterators are non-reentrant
//	What this means is, don't store these anywhere; treat them as temporary variables.
//	Also, don't call functions that use them while using them; you'll overwrite yourself.


native Iterator:deque_end ( Deque:one, is_static = 0 )
native Iterator:deque_begin ( Deque:one, is_static = 0 )
native Iterator:deque_at ( Deque:one, slot, is_static = 0 )

native Iterator:deque_rend ( Deque:one, is_static = 0 )
native Iterator:deque_rbegin ( Deque:one, is_static = 0 )
native Iterator:deque_rat ( Deque:one, slot, is_static = 0 )

// Deque Information

native bool:deque_empty ( Deque:one )
native deque_size ( Deque:one )
native deque_memory ( Deque:one )

// Deque Random Access

native Any:deque_get ( Deque:one, slot )
native Raw:deque_get_raw ( Deque:one, slot )

native bool:deque_get_bool ( Deque:one, slot )
native deque_get_int ( Deque:one, slot )
native Float:deque_get_float ( Deque:one, slot )
native Ptr:deque_get_ptr ( Deque:one, slot )

native deque_get_vector ( Deque:one, slot, Float:vec[3] )
native deque_get_array ( Deque:one, slot, vec[], len )
native deque_get_string ( Deque:one, slot, vec[], len )

native deque_set ( Deque:one, slot, Any:set )
native deque_set_none( Deque:one, slot )

native deque_set_bool ( Deque:one, slot, bool:set )
native deque_set_int ( Deque:one, slot, set )
native deque_set_float ( Deque:one, slot, Float:set )
native deque_set_ptr ( Deque:one, slot, Ptr:set )

native deque_set_vector ( Deque:one, slot, Float:vec[3] )
native deque_set_array ( Deque:one, slot, set[], len )
native deque_set_string ( Deque:one, slot, set[] )

// Deque Push/Pop/Peek


native deque_pop_front ( Deque:one )

native Any:deque_peek_front ( Deque:one )
native Raw:deque_peek_front_raw ( Deque:one )

native bool:deque_peek_front_bool ( Deque:one )
native deque_peek_front_int ( Deque:one )
native Float:deque_peek_front_float ( Deque:one )
native Ptr:deque_peek_front_ptr ( Deque:one )

native deque_peek_front_vector ( Deque:one, Float:vec[3] )
native deque_peek_front_array ( Deque:one, vec[], len )
native deque_peek_front_string ( Deque:one, vec[], len )

native deque_push_front ( Deque:one, Any:set )
native deque_push_front_none ( Deque:one )

native deque_push_front_bool ( Deque:one, bool:set )
native deque_push_front_int ( Deque:one, set )
native deque_push_front_float ( Deque:one, Float:set )
native deque_push_front_ptr ( Deque:one, Ptr:set )

native deque_push_front_vector ( Deque:one, Float:vec[3] )
native deque_push_front_array ( Deque:one, set[], len )
native deque_push_front_string ( Deque:one, set[] )


native deque_pop_back ( Deque:one )

native Any:deque_peek_back ( Deque:one )
native Raw:deque_peek_back_raw ( Deque:one )

native bool:deque_peek_back_bool ( Deque:one )
native deque_peek_back_int ( Deque:one )
native Float:deque_peek_back_float ( Deque:one )
native Ptr:deque_peek_back_ptr ( Deque:one )

native deque_peek_back_vector ( Deque:one, Float:vec[3] )
native deque_peek_back_array ( Deque:one, vec[], len )
native deque_peek_back_string ( Deque:one, vec[], len )

native deque_push_back ( Deque:one, Any:set )
native deque_push_back_none ( Deque:one )

native deque_push_back_bool ( Deque:one, bool:set )
native deque_push_back_int ( Deque:one, set )
native deque_push_back_float ( Deque:one, Float:set )
native deque_push_back_ptr ( Deque:one, Ptr:set )

native deque_push_back_vector ( Deque:one, Float:vec[3] )
native deque_push_back_array ( Deque:one, set[], len )
native deque_push_back_string ( Deque:one, set[] )

// Deque Front

native Any:deque_front ( Deque:one )
native Raw:deque_front_raw ( Deque:one )

native bool:deque_front_bool ( Deque:one )
native deque_front_int ( Deque:one )
native Float:deque_front_float ( Deque:one )
native Ptr:deque_front_ptr ( Deque:one )

native deque_front_vector ( Deque:one, Float:vec[3] )
native deque_front_array ( Deque:one, vec[], len )
native deque_front_string ( Deque:one, vec[], len )

// Deque Back

native Any:deque_back ( Deque:one )
native Raw:deque_back_raw ( Deque:one )

native bool:deque_back_bool ( Deque:one )
native deque_back_int ( Deque:one )
native Float:deque_back_float ( Deque:one )
native Ptr:deque_back_ptr ( Deque:one )

native deque_back_vector ( Deque:one, Float:vec[3] )
native deque_back_array ( Deque:one, vec[], len )
native deque_back_string ( Deque:one, vec[], len ) 

// * Deque Type
//	This is to make comparisons easy, and to make it so people don't screw up our pointers.

stock bool:operator==(Deque:oper1, Deque:oper2)
	return deque_comp(oper1, oper2) == 0;

stock bool:operator!=(Deque:oper1, Deque:oper2)
	return deque_comp(oper1, oper2) != 0;

// Flip em around, and lex em.
stock bool:operator>(Deque:oper1, Deque:oper2)
	return deque_lex(oper2, oper1)

stock bool:operator>=(Deque:oper1, Deque:oper2)
	return (deque_lex(oper2, oper1) ) || (deque_comp(oper1, oper2) ) 

stock bool:operator<(Deque:oper1, Deque:oper2)
	return deque_lex(oper1, oper2)

stock bool:operator<=(Deque:oper1, Deque:oper2)
	return (deque_lex(oper1, oper2) ) || (deque_comp(oper1, oper2) ) 

// Rukia: Our types can't do anything but comparisons.
forward Deque:operator*(Deque:oper1, Deque:oper2);
forward Deque:operator/(Deque:oper1, Deque:oper2);
forward Deque:operator+(Deque:oper1, Deque:oper2);
forward Deque:operator-(Deque:oper1, Deque:oper2)

forward Deque:operator++(Deque:oper)
forward Deque:operator--(Deque:oper)
forward Deque:operator-(Deque:oper)
forward Deque:operator*(Deque:oper1, oper2)
forward Deque:operator/(Deque:oper1, oper2)
forward Deque:operator/(oper1, Deque:oper2)
forward Deque:operator+(Deque:oper1, oper2)
forward Deque:operator-(Deque:oper1, oper2)
forward Deque:operator-(oper1, Deque:oper2)
forward bool:operator>=(Deque:oper1, oper2)
forward bool:operator>=(oper1, Deque:oper2)
forward bool:operator==(Deque:oper1, oper2)
forward bool:operator!=(Deque:oper1, oper2)
forward bool:operator>(Deque:oper1, oper2)
forward bool:operator>(oper1, Deque:oper2)
forward bool:operator<(Deque:oper1, oper2)
forward bool:operator<(oper1, Deque:oper2)
forward bool:operator<=(Deque:oper1, oper2)
forward bool:operator<=(oper1, Deque:oper2)
forward bool:operator!(Deque:oper)
forward operator%(Deque:oper1, Deque:oper2);
forward operator%(Deque:oper1, oper2);
forward operator%(oper1, Deque:oper2);