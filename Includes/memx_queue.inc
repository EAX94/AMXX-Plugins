/* Queue Container
 * (C)2007 Kuchiki Rukia
 * Licensed under the GNU General Public License.
 * No warranties of any kind.
 */

#if defined _queue_included
  #endinput
#endif
#define _queue_included

// Queue creation / destruction
//	Remember: You MUST destroy what you create, or a leak will occur.

native Queue:queue_create ( Queue:cpy = Queue:0, is_static = 0 )
native queue_destroy ( Queue:me )

// Queue Conversion

native queue_clear ( Queue:me )
native queue_copy ( Queue:dsg, Queue:src )

// Queue Comparison
//	comp is ==, lex is <
//	Just use the simpler tag comparisons | Queue:one == Queue:two will work fine.

native bool:queue_comp ( Queue:one, Queue:two )
native bool:queue_lex ( Queue:one, Queue:two )

// Queue Information

native bool:queue_empty ( Queue:one )
native queue_size ( Queue:one )
native queue_memory ( Queue:one )

// Queue Push/Pop/Peek
//	Queues are FIFO, First In : First Out
//	Think of a line of people waiting to get on a roller coaster.

native queue_pop ( Queue:one )

native Any:queue_peek ( Queue:one )
native Raw:queue_peek_raw ( Queue:one )

native bool:queue_peek_bool ( Queue:one )
native queue_peek_int ( Queue:one )
native Float:queue_peek_float ( Queue:one )
native Ptr:queue_peek_ptr ( Queue:one )

native queue_peek_vector ( Queue:one, Float:vec[3] )
native queue_peek_array ( Queue:one, vec[], len )
native queue_peek_string ( Queue:one, vec[], len )

native queue_push ( Queue:one, Any:set )
native queue_push_none ( Queue:one )

native queue_push_bool ( Queue:one, bool:set )
native queue_push_int ( Queue:one, set )
native queue_push_float ( Queue:one, Float:set )
native queue_push_ptr ( Queue:one, Ptr:set )

native queue_push_vector ( Queue:one, Float:vec[3] )
native queue_push_array ( Queue:one, set[], len )
native queue_push_string ( Queue:one, set[] )

// Queue Front
//	Gets the value on the front of the queue

native Any:queue_front ( Queue:one )
native Raw:queue_front_raw ( Queue:one )

native bool:queue_front_bool ( Queue:one )
native queue_front_int ( Queue:one )
native Float:queue_front_float ( Queue:one )
native Ptr:queue_front_ptr ( Queue:one )

native queue_front_vector ( Queue:one, Float:vec[3] )
native queue_front_array ( Queue:one, vec[], len )
native queue_front_string ( Queue:one, vec[], len )

// Queue Back
//	Gets the value on the back of the queue

native Any:queue_back ( Queue:one )
native Raw:queue_back_raw ( Queue:one )

native bool:queue_back_bool ( Queue:one )
native queue_back_int ( Queue:one )
native Float:queue_back_float ( Queue:one )
native Ptr:queue_back_ptr ( Queue:one )

native queue_back_vector ( Queue:one, Float:vec[3] )
native queue_back_array ( Queue:one, vec[], len )
native queue_back_string ( Queue:one, vec[], len ) 

// * Queue Type
//	This is to make comparisons easy, and to make it so people don't screw up our pointers.

stock bool:operator==(Queue:oper1, Queue:oper2)
	return queue_comp(oper1, oper2) == 0;

stock bool:operator!=(Queue:oper1, Queue:oper2)
	return queue_comp(oper1, oper2) != 0;

// Flip em around, and lex em.
stock bool:operator>(Queue:oper1, Queue:oper2)
	return queue_lex(oper2, oper1)

stock bool:operator>=(Queue:oper1, Queue:oper2)
	return (queue_lex(oper2, oper1) ) || (queue_comp(oper1, oper2) ) 

stock bool:operator<(Queue:oper1, Queue:oper2)
	return queue_lex(oper1, oper2)

stock bool:operator<=(Queue:oper1, Queue:oper2)
	return (queue_lex(oper1, oper2) ) || (queue_comp(oper1, oper2) ) 

// Rukia: Our types can't do anything but comparisons.
forward Queue:operator*(Queue:oper1, Queue:oper2);
forward Queue:operator/(Queue:oper1, Queue:oper2);
forward Queue:operator+(Queue:oper1, Queue:oper2);
forward Queue:operator-(Queue:oper1, Queue:oper2)

forward Queue:operator++(Queue:oper)
forward Queue:operator--(Queue:oper)
forward Queue:operator-(Queue:oper)
forward Queue:operator*(Queue:oper1, oper2)
forward Queue:operator/(Queue:oper1, oper2)
forward Queue:operator/(oper1, Queue:oper2)
forward Queue:operator+(Queue:oper1, oper2)
forward Queue:operator-(Queue:oper1, oper2)
forward Queue:operator-(oper1, Queue:oper2)

forward bool:operator>=(Queue:oper1, oper2)
forward bool:operator>=(oper1, Queue:oper2)
forward bool:operator==(Queue:oper1, oper2)
forward bool:operator!=(Queue:oper1, oper2)
forward bool:operator>(Queue:oper1, oper2)
forward bool:operator>(oper1, Queue:oper2)
forward bool:operator<(Queue:oper1, oper2)
forward bool:operator<(oper1, Queue:oper2)
forward bool:operator<=(Queue:oper1, oper2)
forward bool:operator<=(oper1, Queue:oper2)
forward bool:operator!(Queue:oper)

forward operator%(Queue:oper1, Queue:oper2);
forward operator%(Queue:oper1, oper2);
forward operator%(oper1, Queue:oper2);