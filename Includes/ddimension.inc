/*

	dDimension ( Definition Dimension )
	Version 1.1

	Copyright © 2010 SnoW

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 2 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see http://www.gnu.org/licenses/.

*/

#if defined _ddimension_included
	#endinput
#endif

#define _ddimension_included

#pragma tabsize 0

stock dGetArrayDimension( ArrayIndex[ ], any: ... )
{
	new Args = numargs( ), Arg = 1, DimensionValue;

	DimensionValue += getarg( Arg++ );

	while( Arg < Args )
	{
		DimensionValue *= ArrayIndex[ Arg + 1 ];
		DimensionValue += getarg( Arg++ );
	}

	return DimensionValue;
}

#define c{%1:%2[%3][%4][%5]%6} enum{ %6 }; %1: %2[ %3 ][ %4 ][ _:( %5 ) ], %2@[ ] = { _:( %3 ), _:( %4 ), _: ( %5 ) }
#define enum{[%1]%2};%3[%4][%5][%6],%7[]={%8} enum{%2};%3[%4][%5][%6*_:(%1)],%7[]={%8,_:(%1)}

#define d{%1[%2][%3][%4]%5} %1[ %2 ][ %3 ][ dGetArrayDimension( %1@ [%4]%5 ) ]
#define dGetArrayDimension(%1[%2]%3) dGetArrayDimension( %1, %2 %3 )

#define p{%1} %1, %1@
#define g{%1} %1[ ][ ][ ], %1@[ ]