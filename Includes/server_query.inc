#if defined _server_query_included
	#endinput
#endif

#define _server_query_included

#if AMXX_VERSION_NUM >= 175
	#pragma reqlib server_query
	#if !defined AMXMODX_NOAUTOLOAD
		#pragma loadlib server_query
	#endif
#else
	#pragma library server_query
#endif

#include < amxmodx >

/*
 * Queries a server for information
 * 
 * @param		ip - IP of the server without port
 * @param		port - The port number of the server
 * @param		type - The type of query to perform (matches SQ_* constants)
 * @param		function - The callback function to be executed when the query is finished
 * @param		error - The error code given when there was a problem with the query (matches SQError_* constants)
 * 
 * @note		Only 1 query can be performed on the same ip:port combination at a time.
 * 			Trying to use a different query type on the same ip:port while another is already taking place will throw an error.
 * 
 * @return		Returns unique SQuery ID (integer) on success, 0 on failure (and passes error code to param)
 * 
 * 
 * Structure for callback function:
 * 
 * sq_query("127.0.0.1", 27015, SQ_Server, "SQueryResults", errcode)
 * 
 * public SQueryResults(squery_id, type, buffer[], buffer_len, Float:query_time, bool:failed)
 * 
 * @param		squery_id - The unique SQuery ID (integer) return value from sq_query()
 * @param		type - The type of query performed (matches SQ_* constants)
 * @param		buffer - The buffer containing the server info
 * @param		buffer_len - The length of the buffer
 * @param		query_time - The time in seconds it took for the query to finish
 * @param		failed - false if results were found, true otherwise
 * 
 * @note		There are 2 functions to read from the buffer, depending on the type:
 * 				sq_readbuffer_server()
 *				sq_readbuffer_players()
 * 
 * @return		Return value is ignored
 * 
 */
enum _:ServerQueryType
{
	SQ_Server,
	SQ_Players
};
native sq_query(ip[],port,type,function[],&error);

/*
 * Gets a description of the errcode when sq_query() fails
 * 
 * @param		errcode - The error code from the sq_query() function (matches SQError_* constants)
 * @param		error - The output string to contain the description
 * @param		len - The max length of the result string
 * 
 * @return		The length of the result on success, 0 on failure
 * 
 */
enum _:ServerQueryErrors
{
	SQError_NoError,
	SQError_InvalidParams,
	SQError_MaxConnections,
	SQError_InvalidQueryType,
	SQError_InvalidIP,
	SQError_CouldNotConnect,
	SQError_InvalidFunction,
	SQError_AlreadyConnected
};
stock sq_error(const errcode,error[],const len)
{
	switch( errcode )
	{
		/*case SQError_NoError:
		{
			return copy( error, len, "No error" );
		}*/
		case SQError_InvalidParams:
		{
			return copy( error, len, "Invalid function parameter list." );
		}
		case SQError_MaxConnections:
		{
			return copy( error, len, "Too many server queries are already taking place." );
		}
		case SQError_InvalidQueryType:
		{
			return copy( error, len, "Invalid server query type." );
		}
		case SQError_InvalidIP:
		{
			return copy( error, len, "Invalid IP given." );
		}
		case SQError_CouldNotConnect:
		{
			return copy( error, len, "Could not connect to given IP." );
		}
		case SQError_InvalidFunction:
		{
			return copy( error, len, "Invalid function handle." );
		}
		case SQError_AlreadyConnected:
		{
			return copy( error, len, "Connection exists for given IP." );
		}
	}
	
	return 0;
}

/*
 * Reads the server info buffer from SQ_Server query into output variables
 * 
 * @param		buffer - The buffer containing the server info
 * @param		buffer_len - The length of the buffer
 * @param		hostname - The output string containing the hostname
 * @param		len1 - The max length of hostname
 * @param		map - The output string containing the map name
 * @param		len2 - The max length of map
 * @param		gamedir - The output string containing the game directory
 * @param		len3 - The max length of gamedir
 * @param		gamedesc - The output string containing the game description
 * @param		len4 - The max length of gamedesc
 * @param		appid - The Steam application ID for the game
 * @param		numplayers - The number of players in the server
 * @param		maxplayers - The maximum players the server can hold
 * @param		numbots - The number of bots in the server
 * @param		servertype - The type of the server (matches the SERVERTYPE_* constants) (use with sq_servertype() to get a description)
 * @param		windows - If the server is windows (true) or linux (false)
 * @param		password - If the server requires a password (true) or not (false)
 * @param		secure - If the server is VAC secured (true) or not (false)
 * 
 * @note		All arguments except for 'buffer' and 'buffer_len' are optional.
 * 
 * @return		true on success, false on failure
 * 
 */
stock bool:sq_readbuffer_server(const buffer[],const buffer_len,&version=0,hostname[]="",const len1=0,map[]="",const len2=0,gamedir[]="",const len3=0,gamedesc[]="",const len4=0,&appid=0,&numplayers=0,&maxplayers=0,&numbots=0,&servertype=0,&bool:windows=false,&bool:password=false,&bool:secure=false)
{
	if( sq_is_A2S_INFO_response( buffer, buffer_len ) )
	{
		new iPos = 5, iTemp;
		
        iPos = sq_readbyte( buffer, buffer_len, iPos, version );
		iPos = sq_readstring( buffer, buffer_len, iPos, hostname, len1 );
		iPos = sq_readstring( buffer, buffer_len, iPos, map, len2 );
		iPos = sq_readstring( buffer, buffer_len, iPos, gamedir, len3 );
		iPos = sq_readstring( buffer, buffer_len, iPos, gamedesc, len4 );
		iPos = sq_readshort( buffer, buffer_len, iPos, appid );
		iPos = sq_readbyte( buffer, buffer_len, iPos, numplayers );
		iPos = sq_readbyte( buffer, buffer_len, iPos, maxplayers );
		iPos = sq_readbyte( buffer, buffer_len, iPos, numbots );
		iPos = sq_readbyte( buffer, buffer_len, iPos, servertype );
		iPos = sq_readbyte( buffer, buffer_len, iPos, iTemp ); windows = ( iTemp == 'w' );
		iPos = sq_readbyte( buffer, buffer_len, iPos, iTemp ); password = ( iTemp == 0x01 );
		iPos = sq_readbyte( buffer, buffer_len, iPos, iTemp ); secure = ( iTemp == 0x01 );
		
		return true;
	}
	
	return false;
}

/*
 * Gets a description of the server type based on it's servertype info from the buffer
 * 
 * @param		servertype - The servertype retrieved from the server info buffer (matches SERVERTYPE_* constants)
 * @param		result - The output string to contain the description
 * @param		len - The max length of the result string
 * 
 * @return		The length of the result on success, 0 on failure
 * 
 */
#define SERVERTYPE_LISTEN    'l' // listen
#define SERVERTYPE_DEDICATED 'd' // dedicated
#define SERVERTYPE_HLTV      'p' // HLTV
stock sq_servertype(const servertype,result[],const len)
{
	switch( servertype )
	{
		case SERVERTYPE_LISTEN:
		{
			return copy( result, len, "Listen" );
		}
		case SERVERTYPE_DEDICATED:
		{
			return copy( result, len, "Dedicated" );
		}
		case SERVERTYPE_HLTV:
		{
			return copy( result, len, "HLTV" );
		}
	}
	
	return 0;
}

/*
 * Reads the server info buffer from SQ_Players query into output variables
 * 
 * @param		buffer - The buffer containing the server info
 * @param		buffer_len - The length of the buffer
 * @param		pnum - The number of players in the server
 * @param		names - The output string containing the all of the player names
 * @param		len - The max length of the player names
 * @param		frags - The frags of all of the players
 * @param		times - The time played of all of the players
 * 
 * @note		All arguments except for 'buffer' and 'buffer_len' are optional.
 * @note		'names', 'frags', and 'times' arrays must be of size 32!
 * 
 * @return		true on success, false on failure
 * 
 */
stock bool:sq_readbuffer_players(const buffer[],const buffer_len,&pnum=0,names[32][]={"","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""},const len=0,frags[32]={0,...},Float:times[32]={0.0,...})
{
	if( sq_is_A2S_PLAYER_response( buffer, buffer_len ) )
	{
		new iPos = 5;
		
		iPos = sq_readbyte( buffer, buffer_len, iPos, pnum );
		
		for( new i = 0; i < pnum; i++ )
		{
			iPos++; // skip index since it is always 0
			
			iPos = sq_readstring( buffer, buffer_len, iPos, names[ i ], len );
			iPos = sq_readlong( buffer, buffer_len, iPos, frags[ i ] );
			iPos = sq_readfloat( buffer, buffer_len, iPos, times[ i ] );
		}
		
		return true;
	}
	
	return false;
}

/*
 * Converts the time played in the server into a descriptive string
 * 
 * @param		time_played - The time played
 * @param		output - The output string
 * @param		output_len - The max length of the output string
 * @param		steam_format (optional) - If true, it will be in the Steam format of "View Game Info" (eg. 1h 59m 13s, or 12m 4s). If false, it will be in HH:MM:SS format (default: false)
 * 
 * @return		The length of the output string
 * 
 */
stock sq_timeplayed(const Float:time_played,output[],const output_len,bool:steam_format=false)
{
	new iSeconds = floatround(time_played, floatround_floor);
	new iMinutes = iSeconds / 60;
	new iHours = iMinutes / 60;
	
	iSeconds %= 60;
	iMinutes %= 60;
	
	new iLen;
	
	if( steam_format )
	{
		if( iHours )
		{
			iLen = formatex( output, output_len, "%dh ", iHours );
		}
		
		if( iMinutes || iLen )
		{
			iLen += formatex( output[ iLen ], output_len - iLen, "%dm ", iMinutes );
		}
		
		if( iSeconds || iLen )
		{
			iLen += formatex( output[ iLen ], output_len - iLen, "%ds", iSeconds );
		}
	}
	else
	{
		iLen = formatex( output, output_len, "%d:%02d:%02d", iHours, iMinutes, iSeconds );
	}
	
	return iLen;
}

/*
 * Checks if given buffer is the response of an A2S_INFO request
 * 
 * @param		buffer - The buffer to check
 * @param		buffer_len - The length of the buffer
 * 
 * @return		true if A2S_INFO response, false otherwise
 * 
 */
stock bool:sq_is_A2S_INFO_response(const buffer[],const buffer_len)
{
	return ( buffer_len > 5 && buffer[ 4 ] == 'I' );
}

/*
 * Checks if given buffer is the response of an A2S_PLAYER request
 * 
 * @param		buffer - The buffer to check
 * @param		buffer_len - The length of the buffer
 * 
 * @return		true if A2S_PLAYER response, false otherwise
 * 
 */
stock bool:sq_is_A2S_PLAYER_response(const buffer[],const buffer_len)
{
	return ( buffer_len > 5 && buffer[ 4 ] == 'D' );
}

/*
 * Checks if given buffer is the response of an A2S_SERVERQUERY_GETCHALLENGE request
 * 
 * @param		buffer - The buffer to check
 * @param		buffer_len - The length of the buffer
 * 
 * @return		true if A2S_SERVERQUERY_GETCHALLENGE response, false otherwise
 * 
 */
stock bool:sq_is_A2S_GETCHALLENGE_response(const buffer[],const buffer_len)
{
	return ( buffer_len > 5 && buffer[ 4 ] == 'A' );
}

/*
 * Reads the challenge number from a buffer reponse from A2S_SERVERQUERY_GETCHALLENGE request
 * 
 * @param		buffer - The buffer containing the server info
 * @param		buffer_len - The length of the buffer
 * @param		challenge - The output string to hold the challenge number
 * @param		len - The max length of the challenge string
 * 
 * @note		All arguments except for 'buffer' and 'buffer_len' are optional.
 * 
 * @return		true on success, false on failure
 * 
 */
stock bool:sq_readbuffer_challenge(const buffer[],const buffer_len,challenge[]="",const len=0)
{
	if( sq_is_A2S_GETCHALLENGE_response( buffer, buffer_len ) )
	{
		for( new i = 0, iPos = 5; i < 4 && i < len && iPos < buffer_len; i++, iPos++ )
		{
			challenge[ i ] = buffer[ iPos ];
		}
		
		return true;
	}
	
	return false;
}

/*
 * Reads a long from a buffer at a given start position
 * 
 * @param		buffer - The buffer to read from
 * @param		buffer_len - The length of the buffer
 * @param		start - The start position of the buffer
 * @param		result - The integer that is read is passed into that variable by reference
 * 
 * @return		Returns the end position in the buffer where the integer stops
 * 
 */
stock sq_readlong(const buffer[],const buffer_len,start,&result)
{
	return sq_readint( buffer, buffer_len, start, 4, result, true );
}

/*
 * Reads a short from a buffer at a given start position
 * 
 * @param		buffer - The buffer to read from
 * @param		buffer_len - The length of the buffer
 * @param		start - The start position of the buffer
 * @param		result - The integer that is read is passed into that variable by reference
 * 
 * @return		Returns the end position in the buffer where the integer stops
 * 
 */
stock sq_readshort(const buffer[],const buffer_len,start,&result)
{
	return sq_readint( buffer, buffer_len, start, 2, result, false );
}

/*
 * Reads a byte from a buffer at a given start position
 * 
 * @param		buffer - The buffer to read from
 * @param		buffer_len - The length of the buffer
 * @param		start - The start position of the buffer
 * @param		result - The integer that is read is passed into that variable by reference
 * 
 * @return		Returns the end position in the buffer where the integer stops
 * 
 */
stock sq_readbyte(const buffer[],const buffer_len,start,&result)
{
	return sq_readint( buffer, buffer_len, start, 1, result, false );
}

/*
 * Reads a float from a buffer at a given start position
 * 
 * @param		buffer - The buffer to read from
 * @param		buffer_len - The length of the buffer
 * @param		start - The start position of the buffer
 * @param		result - The float that is read is passed into that variable by reference
 * 
 * @return		Returns the end position in the buffer where the float stops
 * 
 */
stock sq_readfloat(const buffer[],const buffer_len,start,&Float:result)
{
	return sq_readint( buffer, buffer_len, start, 4, _:result, false );
}

/*
 * Reads an integer from a buffer at a given start position for a specific number of bytes
 * 
 * @param		buffer - The buffer to read from
 * @param		buffer_len - The length of the buffer
 * @param		start - The start position of the buffer
 * @param		bytes - The number of bytes to read
 * @param		result - The float that is read is passed into that variable by reference
 * @param		check_neg (optional) - If true, it checks if the integer is negative, otherwise it doesn't check (default: true)
 * 
 * @return		Returns the end position in the buffer where the integer stops
 * 
 */
stock sq_readint(const buffer[],const buffer_len,start,bytes,&result,bool:check_neg=true)
{
	result = 0;
	
	new iPos = start;
	
	if( ( iPos + bytes - 1 ) < buffer_len )
	{
		new bool:bNegative = ( check_neg && buffer[ iPos + bytes - 1 ] < 0 );
		new iTemp;
		
		for( new i = 0; i < bytes; i++ )
		{
			result = sq_fixedunsigned8( buffer[ iPos++ ] );
			
			if( bNegative )
			{
				result = 0xFF - result;
			}
			
			iTemp += ( result << ( 8 * i ) );
		}
		
		if( bNegative )
		{
			iTemp = ( iTemp + 1 ) * -1;
		}
		
		result = iTemp;
	}
	else
	{
		iPos += bytes;
	}
	
	return iPos;
}

/*
 * Reads a string from a buffer at given start position
 * 
 * @param		buffer - The buffer to read from
 * @param		buffer_len - The length of the buffer
 * @param		start - The start position of the buffer
 * @param		output - The output string
 * @param		output_len - The max length of the output string
 * 
 * @return		Returns the end position of where the string stops
 * 
 */
stock sq_readstring(const buffer[],const buffer_len,start,output[],const output_len)
{
	new iPos = start - 1;
	
	new cChar, iLen;
	while( ++iPos < buffer_len && ( cChar = buffer[ iPos ] ) != 0 )
	{
		if( iLen < output_len )
		{
			output[ iLen++ ] = cChar;
		}
	}
	
	return ( iPos + 1 );
}

/*
 * Fixes a value to an unsigned 8-bit integer
 * 
 * @param		value - The value to be fixed
 * 
 * @return		Returns the fixed unsigned 8-bit integer
 * 
 */
stock sq_fixedunsigned8(value)
{
	value = clamp( value, -0xFF, 0xFF );
	
	if( value < 0 )
	{
		value = 0xFF + value + 1;
	}
	
	return value;
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1033\\ f0\\ fs16 \n\\ par }
*/
