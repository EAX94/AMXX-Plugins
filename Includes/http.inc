/*	
	  HTTP
	  v0.4
	by bugsy
*/

#if defined _http_included
	#endinput
#endif
#define _http_included

#if !defined _engine_included
	#include <engine>
#endif

#if !defined _socket_included
	#include <sockets>
#endif

const MAX_DOWNLOAD_SLOTS = 10;
const BUFFER_SIZE = 4096;
const Float:THINK_INTERVAL = 0.01;

enum DownloadInfo
{
	Server[ 64 ],
	RemoteFile[ 128 ],
	LocalFile[ 128 ],
	FileHandle,
	Socket,
	PacketNum,
	BytesTransferred,
	FileSize,
	DownloadID
}

stock HTTP[ MAX_DOWNLOAD_SLOTS ][ DownloadInfo ] , g_HTTPEntity , g_Forward , g_iDownloadID , g_iPluginID = INVALID_PLUGIN_ID , g_DataBuffer[ BUFFER_SIZE ];

stock HTTP_DownloadFile( const szRemoteFile[] , const szLocalFile[] )
{
	new iSlot;
	for ( iSlot = 0 ; iSlot < MAX_DOWNLOAD_SLOTS ; iSlot++ )
	{
		if ( !HTTP[ iSlot ][ DownloadID ] )
			break;
		else if ( iSlot == ( MAX_DOWNLOAD_SLOTS - 1 ) ) 
			return 0;
	}

	strtok( szRemoteFile[ ( equali( szRemoteFile , "http://" , 7 ) ? 7 : 0 ) ] , 
			HTTP[ iSlot ][ Server ] , charsmax( HTTP[][ Server ] ) , 
			HTTP[ iSlot ][ RemoteFile ] , charsmax( HTTP[][ RemoteFile ] ) , '/' );
	trim( HTTP[ iSlot ][ Server ] );
	
	copy( HTTP[ iSlot ][ LocalFile ] , charsmax( HTTP[][ LocalFile ] ) , szLocalFile );
	if ( !( HTTP[ iSlot ][ FileHandle ] = fopen( HTTP[ iSlot ][ LocalFile ] , "wb" ) ) )
	{
		log_amx( "HTTP: Error creating local file" );
		return 0;
	}
	
	new iError;
	if ( ( HTTP[ iSlot ][ Socket ] = socket_open( HTTP[ iSlot ][ Server ] , 80 , SOCKET_TCP , iError ) ) && !iError )
	{
		new szRequest[ 27 + charsmax( HTTP[][ Server ] ) + charsmax( HTTP[][ RemoteFile ] ) ];
		
		if ( g_iPluginID == INVALID_PLUGIN_ID )
		{
			new szFile[ 64 ] , szTmp[ 1 ];
			get_plugin( -1 , szFile , charsmax( szFile ) , szTmp , 0 , szTmp , 0, szTmp , 0 , szTmp , 0 );
			g_iPluginID = find_plugin_byfile( szFile , 0 );
		}

		if ( !g_HTTPEntity )
		{
			g_HTTPEntity = create_entity( "info_target" );
			entity_set_string( g_HTTPEntity , EV_SZ_classname , "http_entity" );
			entity_set_float( g_HTTPEntity , EV_FL_nextthink , get_gametime() + THINK_INTERVAL );

			if ( !g_iDownloadID )
				register_think( "http_entity" , "_HTTP_EntityThink" );

			g_Forward = CreateOneForward( g_iPluginID , "HTTP_Download" , FP_STRING , FP_CELL , FP_CELL , FP_CELL , FP_CELL );
		}

		HTTP[ iSlot ][ PacketNum ] = 0;
		HTTP[ iSlot ][ BytesTransferred ] = 0;
		HTTP[ iSlot ][ FileSize ] = 0;
		
		formatex( szRequest , charsmax( szRequest ) , "GET /%s HTTP/1.1^r^nHost: %s^r^n^r^n" , HTTP[ iSlot ][ RemoteFile ] , HTTP[ iSlot ][ Server ] );
		socket_send( HTTP[ iSlot ][ Socket ] , szRequest , sizeof( szRequest ) );
	}
	else
	{
		log_amx( "HTTP: Error creating socket [Error=%d]" , iError );
		return 0;
	}

	return ( ( HTTP[ iSlot ][ DownloadID ] = ++g_iDownloadID ) );
}

stock HTTP_AbortTransfer( iDownloadID , bool:bDeleteLocalFile=true )
{
	new iSlot , bool:bSuccess;
	for ( iSlot = 0 ; iSlot < MAX_DOWNLOAD_SLOTS ; iSlot++ )
	{
		if ( iDownloadID == HTTP[ iSlot ][ DownloadID ] )
		{
			HTTP[ iSlot ][ DownloadID ] = 0;
			fclose( HTTP[ iSlot ][ FileHandle ] );
			socket_close( HTTP[ iSlot ][ Socket ] );
			
			if ( bDeleteLocalFile )
				delete_file( HTTP[ iSlot ][ LocalFile ] );
			
			bSuccess = true;
			break;
		}
	}
	return bSuccess;
}

public _HTTP_EntityThink( iEntity )
{	
	static iSlot , iDataBlocks , iDataStart , iActiveSlots , iRet;

	if ( iEntity != g_HTTPEntity )
		return;
		
	iActiveSlots = 0;
	for ( iSlot = 0 ; iSlot < MAX_DOWNLOAD_SLOTS ; iSlot++ )
	{
		if ( HTTP[ iSlot ][ DownloadID ] )
		{
			iActiveSlots++;

			if ( socket_change( HTTP[ iSlot ][ Socket ] , 0 ) )
			{
				if ( ( iDataBlocks = socket_recv( HTTP[ iSlot ][ Socket ] , g_DataBuffer , sizeof( g_DataBuffer ) ) ) )
				{
					if ( ( ++HTTP[ iSlot ][ PacketNum ] == 1 ) && ( ( iDataStart = strfind( g_DataBuffer , "^r^n^r^n" ) ) > -1 ) )
					{
						new iContentLength = strfind( g_DataBuffer , "Content-Length: " );
						if ( iContentLength > -1 )
						{
							new iSizeEnd = strfind( g_DataBuffer[ iContentLength + 16 ] , "^r^n" );
							if ( iSizeEnd > -1 )
							{
								g_DataBuffer[ iSizeEnd ] = EOS;
								HTTP[ iSlot ][ FileSize ] = str_to_num( g_DataBuffer[ iContentLength + 16 ] );
							}
						}
						iDataStart += 4;
					}
					else
					{
						iDataStart = 0;
					}
					
					HTTP[ iSlot ][ BytesTransferred ] += fwrite_blocks( HTTP[ iSlot ][ FileHandle ] , g_DataBuffer[ iDataStart ] , ( iDataBlocks - iDataStart ) , BLOCK_BYTE );
					ExecuteForward( g_Forward , iRet , HTTP[ iSlot ][ LocalFile ] , HTTP[ iSlot ][ DownloadID ] , HTTP[ iSlot ][ BytesTransferred ] , HTTP[ iSlot ][ FileSize ] , false );
				}
				else
				{
					ExecuteForward( g_Forward , iRet , HTTP[ iSlot ][ LocalFile ] , HTTP[ iSlot ][ DownloadID ] , HTTP[ iSlot ][ BytesTransferred ] , HTTP[ iSlot ][ FileSize ] , true );
					
					fclose( HTTP[ iSlot ][ FileHandle ] );
					socket_close( HTTP[ iSlot ][ Socket ] );
					iActiveSlots--;
					
					HTTP[ iSlot ][ DownloadID ] = 0;
				}
			}
		}
	}
	
	if ( iActiveSlots )
	{
		entity_set_float( g_HTTPEntity , EV_FL_nextthink , get_gametime() + THINK_INTERVAL );
	}	
	else
	{
		entity_set_int( g_HTTPEntity , EV_INT_flags , FL_KILLME );
		call_think( g_HTTPEntity );
		g_HTTPEntity = 0;

		DestroyForward( g_Forward );
		g_Forward = 0;
	}
}