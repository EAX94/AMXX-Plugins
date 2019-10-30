/*

// Number Conversions
// by Exolent

stock HexToDecimal( const szHex[ ] )

stock DecimalToHex( const iDecimal, szHexResult[ ], const iHexLen )

stock BinaryToDecimal( const szBinary[ ] )

stock DecimalToBinary( const iDecimal, szBinary[ ], const iBinaryLen )

stock BinaryToHex( const szBinary[ ], szHexResult[ ], const iHexLen )

stock HexToBinary( const szHex[ ], szBinaryResult[ ], const iBinaryLen )

// Retrives digits from a given value and returns the number of digits
// 
// @param	iValue - The value from which to get the digits
// @param	iDigits[ ] - The array to store the digits in (optional)
// @param	iDigitSize - The size of the array (optional)
// @param	iBase - The base of the number to find digits by (default is 10 for base 10 (decimal)) (optional)
// @param	bKeepDigitOrder - Decides to start from the right side of the decimal or left (default is false) (optional) (see post for more details)
// 
// @return	The total number of digits found
// 
stock GetDigits( const iValue, iDigits[ ] = "", const iDigitSize = 0, const iBase = 10, bool:bKeepDigitOrder = false )

stock ReverseArray( iArray[ ], const iSize )

*/

#include < amxmodx >

#if cellbits == 32
#define MAX_DECIMAL_DIGITS 10
#define MAX_BINARY_DIGITS 31
#define MAX_HEXADECIMAL_DIGITS 8
#else
#define MAX_DECIMAL_DIGITS 19
#define MAX_BINARY_DIGITS 63
#define MAX_HEXADECIMAL_DIGITS 16
#endif

stock const __HEXCHARS[ ] = "0123456789ABCDEF";

stock HexToDecimal( const szHex[ ] )
{
	new iLen = strlen( szHex );
	new iPos = 0;
	new cChar;
	new iValue;
	new iResult = 0;
	
	while( --iLen >= 0 )
	{
		cChar = szHex[ iLen ];
		
		switch( cChar )
		{
			case '0' .. '9':
			{
				iValue = cChar - '0';
			}
			case 'a' .. 'f':
			{
				iValue = 10 + cChar - 'a';
			}
			case 'A' .. 'F':
			{
				iValue = 10 + cChar - 'A';
			}
			default:
			{
				return -1;
			}
		}
		
		iResult += ( power( 16, iPos++ ) * iValue );
	}
	
	return iResult;
}

stock DecimalToHex( const iDecimal, szHexResult[ ], const iHexLen )
{
	new iTotal = GetDigits( iDecimal, szHexResult, iHexLen, 16, true );
	
	for( new i = 0; i < iTotal; i++ )
	{
		szHexResult[ i ] = __HEXCHARS[ szHexResult[ i ] ];
	}
	
	szHexResult[ iTotal ] = 0;
	
	return iTotal;
}

/*stock BinaryToDecimal( const iBinary )
{
	new iResult = 0;
	new iTemp = iBinary;
	new iValue;
	new iPos;
	
	while( iTemp > 0 )
	{
		iValue = iTemp % 10;
		
		if( iValue )
		{
			iResult |= ( 1 << iPos++ );
		}
		
		iTemp /= 10;
	}
	
	return iResult;
}

stock DecimalToBinary( const iDecimal )
{
	new iResult = 0;
	
	for( new i = MAX_BINARY_DIGITS - 1, iBit = 1 << i; i >= 0; iBit = 1 << ( --i ) )
	{
		if( iDecimal & iBit )
		{
			iResult += power( 10, i );
		}
	}
	
	return iResult;
}*/

stock BinaryToDecimal( const szBinary[ ] )
{
	new cChar;
	new iPos = 0;
	new iResult = 0;
	
	while( ( cChar = szBinary[ iPos ] ) )
	{
		if( cChar == '1' )
		{
			iResult |= ( 1 << iPos );
		}
		else if( cChar != '0' )
		{
			return -1;
		}
		
		iPos++;
	}
	
	return iResult;
}

stock DecimalToBinary( const iDecimal, szBinary[ ], const iBinaryLen )
{
	new iLen = 0;
	
	for( new i = min( MAX_BINARY_DIGITS - 1, iBinaryLen ), iBit = 1 << i; i >= 0; iBit = 1 << ( --i ) )
	{
		if( iDecimal & iBit )
		{
			szBinary[ iLen++ ] = '1';
		}
		else if( iLen )
		{
			szBinary[ iLen++ ] = '0';
		}
	}
	
	szBinary[ iLen ] = 0;
	
	return iLen;
}

/*stock BinaryToHex( const iBinary, szHexResult[ ], const iHexLen )
{
	new iByteDigits[ MAX_BINARY_DIGITS / 4 ];
	new iTotal = GetDigits( iBinary, iByteDigits, sizeof( iByteDigits ), 10000, true );
	
	new iPos;
	
	for( new i = 0; i < iTotal && iPos < iHexLen; i++ )
	{
		iPos += DecimalToHex( BinaryToDecimal( iByteDigits[ i ] ), szHexResult[ iPos ], iHexLen - iPos );
	}
	
	szHexResult[ iPos ] = 0;
	
	return iPos;
}

stock HexToBinary( const szHex[ ] )
{
	new iLen = strlen( szHex );
	new iPos;
	new cChar;
	new iValue;
	new iResult = 0;
	
	while( --iLen >= 0 )
	{
		cChar = szHex[ iLen ];
		
		switch( cChar )
		{
			case '0' .. '9':
			{
				iValue = cChar - '0';
			}
			case 'a' .. 'f':
			{
				iValue = 10 + cChar - 'a';
			}
			case 'A' .. 'F':
			{
				iValue = 10 + cChar - 'A';
			}
			default:
			{
				return -1;
			}
		}
		
		iResult += DecimalToBinary( power( 16, iPos++ ) * iValue );
	}
	
	return iResult;
}*/

stock BinaryToHex( const szBinary[ ], szHexResult[ ], const iHexLen )
{
	new iBinaryLen = strlen( szBinary );
	new szByte[ 5 ], iLen;
	new iByteValue;
	new iHexPos;
	
	for( new iPos = iBinaryLen - 1; iPos >= 0 && iHexPos < iHexLen; )
	{
		iLen = 0;
		
		while( iLen < 4 && iPos >= 0 )
		{
			szByte[ 4 - ( ++iLen ) ] = szBinary[ iPos-- ];
		}
		
		copy( szByte, iLen, szByte[ 4 - iLen ] );
		
		iByteValue = BinaryStringToDecimal( szByte );
		
		szHexResult[ iHexPos++ ] = __HEXCHARS[ iByteValue ];
	}
	
	ReverseArray( szHexResult, iHexPos );
	
	szHexResult[ iHexPos ] = 0;
	
	return iHexPos;
}

stock HexToBinary( const szHex[ ], szBinaryResult[ ], const iBinaryLen )
{
	new iHexPos;
	new cChar;
	new iValue;
	new iByteIndex;
	new iBinaryPos;
	
	while( ( cChar = szHex[ iHexPos ] ) && iBinaryPos < iBinaryLen )
	{
		switch( cChar )
		{
			case '0' .. '9':
			{
				iValue = cChar - '0';
			}
			case 'a' .. 'f':
			{
				iValue = 10 + cChar - 'a';
			}
			case 'A' .. 'F':
			{
				iValue = 10 + cChar - 'A';
			}
			default:
			{
				return -1;
			}
		}
		
		for( iByteIndex = 0; iByteIndex < 4 && iBinaryPos < iBinaryLen; iByteIndex++ )
		{
			szBinaryResult[ iBinaryPos++ ] = ( iValue & ( 1 << iByteIndex ) ) ? '1' : '0';
		}
		
		iHexPos++;
	}
	
	szBinaryResult[ iBinaryPos ] = 0;
	
	return iBinaryPos;
}

stock GetDigits( const iValue, iDigits[ ] = "", const iDigitSize = 0, const iBase = 10, bool:bKeepDigitOrder = false )
{
	new iDigitCount;
	new iTemp = iValue;
	
	while( iTemp > 0 && iDigitCount < iDigitSize )
	{
		iDigits[ iDigitCount++ ] = iTemp % iBase;
		iTemp /= iBase;
	}
	
	if( bKeepDigitOrder )
	{
		ReverseArray( iDigits, iDigitCount );
	}
	
	return iDigitCount;
}

stock ReverseArray( iArray[ ], const iSize )
{
	new iMiddle = iSize / 2;
	new iTemp;
	
	for( new i = 0, iOpposite = iSize - 1; i < iMiddle; i++, iOpposite-- )
	{
		iTemp = iArray[ i ];
		iArray[ i ] = iArray[ iOpposite ];
		iArray[ iOpposite ] = iTemp;
	}
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang11274\\ f0\\ fs16 \n\\ par }
*/
