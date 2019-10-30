/* Stack Container
 * (C)2007 Kuchiki Rukia
 * Licensed under the GNU General Public License.
 * No warranties of any kind.
 */

#if defined _stack_included
  #endinput
#endif
#define _stack_included

// Stack creation / destruction
//	Remember: You MUST destroy what you create, or a leak will occur.

native Stack:stack_create ( Stack:cpy = Stack:0, is_static = 0 )
native stack_destroy ( Stack:me )

// Stack Conversion

native stack_clear ( Stack:me )
native stack_copy ( Stack:dsg, Stack:src )

// Stack Comparison
//	comp is ==, lex is <
//	Just use the simpler tag comparisons | Stack:one == Stack:two will work fine.

native bool:stack_comp ( Stack:one, Stack:two )
native bool:stack_lex ( Stack:one, Stack:two )

// Stack Information

native bool:stack_empty ( Stack:one )
native stack_size ( Stack:one )
native stack_memory ( Stack:one )

// Stack Push/Pop/Peek
//	Stacks are FILO, First In : Last Out
//	Think of a stack of dishes; can't take the bottom one off without taking the one on top of it first

native stack_pop ( Stack:one )

native Any:stack_peek ( Stack:one )
native Raw:stack_peek_raw ( Stack:one )

native bool:stack_peek_bool ( Stack:one )
native stack_peek_int ( Stack:one )
native Float:stack_peek_float ( Stack:one )
native Ptr:stack_peek_ptr ( Stack:one )

native stack_peek_vector ( Stack:one, Float:vec[3] )
native stack_peek_array ( Stack:one, vec[], len )
native stack_peek_string ( Stack:one, vec[], len )

native stack_push ( Stack:one, Any:set )
native stack_push_none ( Stack:one )

native stack_push_bool ( Stack:one, bool:set )
native stack_push_int ( Stack:one, set )
native stack_push_float ( Stack:one, Float:set )
native stack_push_ptr ( Stack:one, Ptr:set )

native stack_push_vector ( Stack:one, Float:vec[3] )
native stack_push_array ( Stack:one, set[], len )
native stack_push_string ( Stack:one, set[] )

// Stack Top
//	Gets the value on the top of the stack

native Any:stack_top ( Stack:one )
native Raw:stack_top_raw ( Stack:one )

native bool:stack_top_bool ( Stack:one )
native stack_top_int ( Stack:one )
native Float:stack_top_float ( Stack:one )
native Ptr:stack_top_ptr ( Stack:one )

native stack_top_vector ( Stack:one, Float:vec[3] )
native stack_top_array ( Stack:one, vec[], len )
native stack_top_string ( Stack:one, vec[], len )

// * Stack Type
//	This is to make comparisons easy, and to make it so people don't screw up our pointers.

stock bool:operator==(Stack:oper1, Stack:oper2)
	return stack_comp(oper1, oper2) == 0;

stock bool:operator!=(Stack:oper1, Stack:oper2)
	return stack_comp(oper1, oper2) != 0;

// Flip em around, and lex em.
stock bool:operator>(Stack:oper1, Stack:oper2)
	return stack_lex(oper2, oper1)

stock bool:operator>=(Stack:oper1, Stack:oper2)
	return (stack_lex(oper2, oper1) ) || (stack_comp(oper1, oper2) ) 

forward bool:operator>=(Stack:oper1, oper2)
forward bool:operator>=(oper1, Stack:oper2)

stock bool:operator<(Stack:oper1, Stack:oper2)
	return stack_lex(oper1, oper2)

stock bool:operator<=(Stack:oper1, Stack:oper2)
	return (stack_lex(oper1, oper2) ) || (stack_comp(oper1, oper2) ) 

// Rukia: Our types can't do anything but comparisons.
forward Stack:operator*(Stack:oper1, Stack:oper2);
forward Stack:operator/(Stack:oper1, Stack:oper2);
forward Stack:operator+(Stack:oper1, Stack:oper2);
forward Stack:operator-(Stack:oper1, Stack:oper2)

forward Stack:operator++(Stack:oper)
forward Stack:operator--(Stack:oper)
forward Stack:operator-(Stack:oper)
forward Stack:operator*(Stack:oper1, oper2)
forward Stack:operator/(Stack:oper1, oper2)
forward Stack:operator/(oper1, Stack:oper2)
forward Stack:operator+(Stack:oper1, oper2)
forward Stack:operator-(Stack:oper1, oper2)
forward Stack:operator-(oper1, Stack:oper2)
forward bool:operator==(Stack:oper1, oper2)
forward bool:operator!=(Stack:oper1, oper2)
forward bool:operator>(Stack:oper1, oper2)
forward bool:operator>(oper1, Stack:oper2)
forward bool:operator<(Stack:oper1, oper2)
forward bool:operator<(oper1, Stack:oper2)
forward bool:operator<=(Stack:oper1, oper2)
forward bool:operator<=(oper1, Stack:oper2)
forward bool:operator!(Stack:oper)
forward operator%(Stack:oper1, Stack:oper2);
forward operator%(Stack:oper1, oper2);
forward operator%(oper1, Stack:oper2);
