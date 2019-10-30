

// * creation / destruction
//	Remember: If the is_static flag isn't set, these are dynamically allocated; you must delete them manually.
//	is_static flagged creations don't need to be deleted, but be careful with them.

native iterator_destroy ( Iterator:me )

// * Conversion

native iterator_copy ( Iterator:dsg, Iterator:src )

// * Comparison
//	comp is ==, lex is <
//	Just use the simpler tag comparisons | Iterator:one == Iterator:two will work fine.

native bool:iterator_comp ( Iterator:one, Iterator:two )
native bool:iterator_lex ( Iterator:one, Iterator:two )

// * Math
//	Iterators can be moved around the structure. Please use the overloaded functions though!

native iterator_add( Iterator:one, amount = 1 )
native iterator_sub( Iterator:one, amount = 1 )

// * Get / Set
//	These don't mess with the iterator; they mess with the structure the iterator points to!

native Any:iterator_get ( Iterator:one )
native Raw:iterator_get_raw ( Iterator:one )

native bool:iterator_get_bool ( Iterator:one )
native iterator_get_int ( Iterator:one )
native Float:iterator_get_float ( Iterator:one )
native Ptr:iterator_get_ptr ( Iterator:one )

native iterator_get_vector ( Iterator:one, Float:vec[3] )
native iterator_get_array ( Iterator:one, vec[], len )
native iterator_get_string ( Iterator:one, vec[], len )

native iterator_set ( Iterator:one, Any:set )
native iterator_set_none ( Iterator:one )

native iterator_set_bool ( Iterator:one, bool:set )
native iterator_set_int ( Iterator:one, set )
native iterator_set_float ( Iterator:one, Float:set )
native iterator_set_ptr ( Iterator:one, Ptr:set )

native iterator_set_vector ( Iterator:one, Float:vec[3] )
native iterator_set_array ( Iterator:one, set[], len )
native iterator_set_string ( Iterator:one, set[] )

// Rukia: Key retrieval
//	Unfortunately, I couldn't finish key retreival. Sorry. I'll try for it next time.

// Rukia: We can, of course, do comparisons.
stock bool:operator==(Iterator:oper1, Iterator:oper2)
	return iterator_comp(oper1, oper2) == 0;

stock bool:operator!=(Iterator:oper1, Iterator:oper2)
	return iterator_comp(oper1, oper2) != 0;

// Flip em around, and lex em.
stock bool:operator>(Iterator:oper1, Iterator:oper2)
	return iterator_lex(oper2, oper1)

stock bool:operator>=(Iterator:oper1, Iterator:oper2)
	return (iterator_lex(oper2, oper1) ) || (iterator_comp(oper1, oper2) ) 

stock bool:operator<(Iterator:oper1, Iterator:oper2)
	return iterator_lex(oper1, oper2)

stock bool:operator<=(Iterator:oper1, Iterator:oper2)
	return (iterator_lex(oper1, oper2) ) || (iterator_comp(oper1, oper2) ) 

// Rukia: This syntax makes it a little easier to scroll through containers.
stock Iterator:operator++(Iterator:oper)
{ iterator_add(oper,1); return oper; }

stock Iterator:operator--(Iterator:oper)
{ iterator_sub(oper,1); return oper; }

stock Iterator:operator+(Iterator:oper1, oper2)
{ iterator_add(oper1,oper2); return oper1; }

stock Iterator:operator-(Iterator:oper1, oper2)
{ iterator_sub(oper1,oper2); return oper1; }


// Rukia: Add these in later
forward Iterator:operator*(Iterator:oper1, Iterator:oper2);
forward Iterator:operator/(Iterator:oper1, Iterator:oper2);
forward Iterator:operator+(Iterator:oper1, Iterator:oper2);
forward Iterator:operator-(Iterator:oper1, Iterator:oper2)

// Rukia: None of this shit.
forward Iterator:operator-(Iterator:oper)
forward Iterator:operator*(Iterator:oper1, oper2)
forward Iterator:operator/(Iterator:oper1, oper2)
forward Iterator:operator/(oper1, Iterator:oper2)
forward Iterator:operator-(oper1, Iterator:oper2)
forward bool:operator>=(Iterator:oper1, oper2)
forward bool:operator>=(oper1, Iterator:oper2)
forward bool:operator==(Iterator:oper1, oper2)
forward bool:operator!=(Iterator:oper1, oper2)
forward bool:operator>(Iterator:oper1, oper2)
forward bool:operator>(oper1, Iterator:oper2)
forward bool:operator<(Iterator:oper1, oper2)
forward bool:operator<(oper1, Iterator:oper2)
forward bool:operator<=(Iterator:oper1, oper2)
forward bool:operator<=(oper1, Iterator:oper2)
forward bool:operator!(Iterator:oper)
forward operator%(Iterator:oper1, Iterator:oper2);
forward operator%(Iterator:oper1, oper2);
forward operator%(oper1, Iterator:oper2);