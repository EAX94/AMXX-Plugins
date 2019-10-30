
/*	
	   FTP
	  v0.3
	by bugsy
	
	http://forums.alliedmods.net/showthread.php?t=142850
*/

//#define TESTING

#if defined _ftp_included
	#endinput
#endif
#define _ftp_included

#if !defined _engine_included
	#include <engine>
#endif

#if !defined _socket_included
	#include <sockets>
#endif

const BUFFER_SIZE = 4096;

enum FTPStatus
{
	FTP_DISCONNECTED,
	FTP_CONNECTING,
	FTP_USER,
	FTP_PASS,
	FTP_READYFORDATA,
	FTP_IDLE
}

enum FTPTransType
{
	FTP_OPEN,
	FTP_STOR,
	FTP_RETR,
	FTP_LIST
}

enum FTPInfo
{
	UserName[ 64 ],
	Password[ 64 ],
	Server[ 128 ],
	Port,
	DataServer[ 16 ],
	DataPort,
	FileHandle,
	LocalFile[ 64 ],
	RemoteFile[ 64 ],
	FileSize,
	BytesTransferred,
	Socket_Cmd,
	Socket_Data,
	FTPTransType:TransType,
	FTPStatus:Status,
	FWDHandles[ FTPTransType ],
	bool:SentNoop
}

new FTP[ FTPInfo ] , g_iFTPEntity , g_DataBuffer[ BUFFER_SIZE ] , g_szCmdBuffer[ 128 ] , g_szCmd[ 128 ];

stock FTP_Open( const szServer[] , const iPort=21 , const szUser[] , const szPassword[] , const szForward[]="" )
{
	if ( !FTP[ FWDHandles ][ FTP_OPEN ] )
		FTP[ FWDHandles ][ FTP_OPEN ] = CreateMultiForward( szForward , ET_IGNORE , FP_CELL );
	
	copy( FTP[ Server ] , charsmax( FTP[ Server ] ) , szServer );
	FTP[ Port ] = iPort;
	formatex( FTP[ UserName ] , charsmax( FTP[ UserName ] ) , "USER %s^r^n" , szUser );
	formatex( FTP[ Password ] , charsmax( FTP[ Password ] ) , "PASS %s^r^n" , szPassword );

	FTP[ Status ] = _:FTP_CONNECTING;
	FTP[ TransType ] = _:FTP_OPEN;
	
	new iError;
	if ( ( FTP[ Socket_Cmd ] = socket_open( FTP[ Server ] , FTP[ Port ] , SOCKET_TCP , iError ) ) && !iError )
	{
		if ( !g_iFTPEntity )
			CreateFTPEntity();
		
		entity_set_float( g_iFTPEntity , EV_FL_nextthink , get_gametime() + 0.5 );
	}
}

stock FTP_Close()
{
	if ( FTP[ Status ] != FTP_IDLE )
		return 0;
		
	socket_send( FTP[ Socket_Cmd ] , "QUIT^r^n", 7 );  
	socket_close( FTP[ Socket_Cmd ] );
	socket_close( FTP[ Socket_Data ] );
	FTP[ Status ] = _:FTP_DISCONNECTED;
	
	return 1;
}

stock FTP_SendFile( szLocalFile[] , szRemoteFile[] , szForward[]="" )
{
	return FTP_Command( FTP_STOR , szLocalFile , szRemoteFile , szForward );
}

stock FTP_GetFile( szLocalFile[] , szRemoteFile[] , szForward[]="" )
{
	return FTP_Command( FTP_RETR , szLocalFile , szRemoteFile , szForward );
}

stock FTP_GetList( szLocalFile[] , szRemoteFile[] , szForward[]="" )
{
	return FTP_Command( FTP_LIST , szLocalFile , szRemoteFile , szForward );
}

stock FTP_Ready()
{
	return ( FTP[ Status ] == FTP_IDLE );
}

FTP_Command( FTPTransType:FTPTT , szLocalFile[] , szRemoteFile[] , szForward[] )
{
	if ( FTP[ Status ] != FTP_IDLE )
		return 0;
		
	if ( !FTP[ FWDHandles ][ FTPTT ] )
	{
		switch ( FTPTT )
		{
			case FTP_RETR , FTP_STOR: FTP[ FWDHandles ][ FTPTT ] = CreateMultiForward( szForward , ET_IGNORE , FP_STRING , FP_CELL , FP_CELL );
			case FTP_LIST: FTP[ FWDHandles ][ FTPTT ] = CreateMultiForward( szForward , ET_IGNORE , FP_STRING , FP_CELL );
		}
	}
	
	copy( FTP[ LocalFile ] , charsmax( FTP[ LocalFile ] ) , szLocalFile );
	copy( FTP[ RemoteFile ] , charsmax( FTP[ RemoteFile ] ) , szRemoteFile );
	
	FTP[ TransType ] = _:FTPTT;
	
	socket_send( FTP[ Socket_Cmd ] , "PASV^r^n" , 6 );
	
	return 1;	
}

public _FTP_Think( iEntity )
{
	if ( FTP[ Status ] != FTP_READYFORDATA )
	{
		if ( g_szCmdBuffer[ 0 ] || socket_change( FTP[ Socket_Cmd ] ) )
		{
			new szCode[ 4 ] , iPos ; 
				
			if ( !g_szCmdBuffer[ 0 ] )
				socket_recv( FTP[ Socket_Cmd ] , g_szCmdBuffer , charsmax( g_szCmdBuffer ) );
	
			parse( g_szCmdBuffer , szCode , charsmax( szCode ) );
			
			#if defined TESTING
			server_print( g_szCmdBuffer );
			#endif
			
			switch ( str_to_num( szCode ) )
			{
				case 150:  // Opening BINARY mode data connection
				{	
					if ( FTP[ TransType ] != FTP_LIST )
						FTP[ Status ] = _:FTP_READYFORDATA;
				}
				case 200: // Type set to I. & 200 MODE S ok.
				{
					switch ( FTP[ TransType ] )
					{
						case FTP_STOR:
						{
							formatex( g_szCmd , charsmax( g_szCmd ) , "STOR %s^r^n" , FTP[ RemoteFile ] );
							socket_send( FTP[ Socket_Cmd ] , g_szCmd , sizeof( g_szCmd ) );
							
							new iError;
							FTP[ Socket_Data ] = socket_open( FTP[ DataServer ] , FTP[ DataPort ] , SOCKET_TCP , iError );
							FTP[ FileHandle ] = fopen( FTP[ LocalFile ] , "rb" );
							FTP[ FileSize ] = file_size( FTP[ LocalFile ] );
							
							if ( !FTP[ FileHandle ] )
								set_fail_state( "FTP_STOR: File doesnt exist" );
						}
						case FTP_LIST:
						{	
							formatex( g_szCmd , charsmax( g_szCmd ) , "NLST %s^r^n" ,  FTP[ RemoteFile ] );
							socket_send( FTP[ Socket_Cmd ] , g_szCmd , sizeof( g_szCmd ) ); 
							FTP[ Status ] = _:FTP_READYFORDATA;	
							
							new iError;
							FTP[ Socket_Data ] = socket_open( FTP[ DataServer ] , FTP[ DataPort ] , SOCKET_TCP , iError );
							FTP[ FileHandle ] = fopen( FTP[ LocalFile ] , "wt" );
							
							if ( !FTP[ FileHandle ] )
								set_fail_state( "FTP_LIST: Error creating local file" );
						}
						case FTP_RETR:
						{
							formatex( g_szCmd , charsmax( g_szCmd ) , "SIZE %s^r^n" , FTP[ RemoteFile ] );
							socket_send( FTP[ Socket_Cmd ] , g_szCmd , sizeof( g_szCmd ) );
						}
					}
				}
				case 213: //For GetFile: 213 9545  (file size)
				{
					FTP[ FileSize ] = str_to_num( g_szCmdBuffer[ 4 ] );
					formatex( g_szCmd , charsmax( g_szCmd ) , "RETR %s^r^n" , FTP[ RemoteFile ] );
					socket_send( _:FTP[ Socket_Cmd ] , g_szCmd , sizeof( g_szCmd ) );
						
					new iError;
					FTP[ Socket_Data ] = socket_open( FTP[ DataServer ] , FTP[ DataPort ] , SOCKET_TCP , iError );
					FTP[ FileHandle ] = fopen( FTP[ LocalFile ] , "wb" );
					
					if ( !FTP[ FileHandle ] )
						set_fail_state( "FTP_RETR: Error creating local file" );
				}
				case 220: // Welcome
				{
					if ( FTP[ Status ] == FTP_CONNECTING )
					{
						socket_send( FTP[ Socket_Cmd ] , FTP[ UserName ] , sizeof( FTP[ UserName ] ) );
						FTP[ Status ] = _:FTP_USER;
					}
				}
				case 226: // Transfer complete.
				{
					if ( FTP[ TransType ] == FTP_LIST )
					{
						fclose( FTP[ FileHandle ] );
						socket_close( FTP[ Socket_Data ] );
							
						FTP[ Status ] = _:FTP_IDLE;
					}
				}
				case 227: // Entering Passive Mode (216,87,188,9,205,122)
				{
					new iStartPos = strfind( g_szCmdBuffer , "(" ) , iEndPos = strfind( g_szCmdBuffer , ")" );
				
					if ( ( iStartPos == -1 ) || ( iEndPos == -1 ) )
						return;
	
					new szDataSvr[ 6 ][ 4 ];
					g_szCmdBuffer[ iEndPos ] = EOS;
					ExplodeString( szDataSvr , 6 , 4 , g_szCmdBuffer[ iStartPos + 1 ] , ',' );
					
					formatex( FTP[ DataServer ] , charsmax( FTP[ DataServer ] ) , "%s.%s.%s.%s" , szDataSvr[ 0 ] , szDataSvr[ 1 ] , szDataSvr[ 2 ] , szDataSvr[ 3 ] );
					FTP[ DataPort ] = ( ( str_to_num( szDataSvr[ 4 ] ) * 256 ) + str_to_num( szDataSvr[ 5 ] ) );
					
					socket_send( FTP[ Socket_Cmd ] , "TYPE I^r^n" , 8 );
			
					FTP[ Status ] = _:FTP_IDLE;
				}
				case 230: // Logged on
				{
					new iRet;
					ExecuteForward( FTP[ FWDHandles ][ FTP[ TransType ] ] , iRet , 1 );
					FTP[ Status ] = _:FTP_IDLE;
				}
				case 331: // Password required for XX
				{
					if ( FTP[ Status ] < FTP_PASS )
					{				
						socket_send( FTP[ Socket_Cmd ] , FTP[ Password ] , sizeof( FTP[ Password ] ) );
						FTP[ Status ] = _:FTP_PASS;
					}
				}
				case 530: // Login incorrect
				{
					new iRet;
					ExecuteForward( FTP[ FWDHandles ][ FTP[ TransType ] ] , iRet , 0 );
					FTP[ Status ] = _:FTP_DISCONNECTED;	
					socket_close( FTP[ Socket_Cmd ] );
				}
				case 550: // File not found / Permission denied
				{
					FTP[ Status ] = _:FTP_IDLE;	
					socket_close( FTP[ Socket_Data ] );
					fclose( FTP[ FileHandle ] );
				}
			}
		
			if ( ( ( iPos = strfind( g_szCmdBuffer , "^r^n" ) ) != -1 ) && ( ( iPos + 2 ) < sizeof( g_szCmdBuffer ) ) && strlen( g_szCmdBuffer[ iPos + 2 ] ) )
			{
				copy( g_szCmdBuffer , charsmax( g_szCmdBuffer ) , g_szCmdBuffer[ iPos + 2 ] ); 
			}	
			else
			{
				g_szCmdBuffer[ 0 ] = EOS;
			}
		}
	}
	else
	{	
		switch ( FTP[ TransType ] )
		{
			case FTP_RETR , FTP_LIST:
			{
				if ( socket_change( FTP[ Socket_Data ] ) )
				{
					static iDataRecv , iRet;
					iDataRecv = socket_recv( FTP[ Socket_Data ] , g_DataBuffer , sizeof( g_DataBuffer ) );
					fwrite_blocks( FTP[ FileHandle ] , g_DataBuffer , iDataRecv , BLOCK_BYTE );
				
					FTP[ BytesTransferred ] += iDataRecv;
					
					if ( FTP[ TransType ] == FTP_LIST )
					{
						ExecuteForward( FTP[ FWDHandles ][ FTP_LIST ] , iRet , FTP[ LocalFile ] , FTP[ BytesTransferred ] );
						
						fclose( FTP[ FileHandle ] );
						socket_close( FTP[ Socket_Data ] );
						
						FTP[ BytesTransferred ] = 0;
						FTP[ Status ] = _:FTP_IDLE;	
					}
					else
					{
						ExecuteForward( FTP[ FWDHandles ][ FTP_RETR ] , iRet , FTP[ RemoteFile ] , FTP[ BytesTransferred ] , FTP[ FileSize ] );
					}
				}
			}
			case FTP_STOR:
			{
				static iBlocksRead , iRet;
				iBlocksRead = fread_blocks( FTP[ FileHandle ] , g_DataBuffer , BUFFER_SIZE , BLOCK_BYTE );
				socket_send2( FTP[ Socket_Data ] , g_DataBuffer , iBlocksRead );		
				
				FTP[ BytesTransferred ] += iBlocksRead;
				ExecuteForward( FTP[ FWDHandles ][ FTP[ TransType ] ] , iRet , FTP[ ( FTP[ TransType ] == FTP_STOR ) ? LocalFile : RemoteFile ] , FTP[ BytesTransferred ] , FTP[ FileSize ] );
			}
		}
	
		if ( ( FTP[ TransType ] != FTP_LIST ) && ( FTP[ FileSize ] && ( FTP[ BytesTransferred ] == FTP[ FileSize ] ) ) )
		{
			fclose( FTP[ FileHandle ] );
			socket_close( FTP[ Socket_Data ] );
			
			FTP[ BytesTransferred ] = 0;
			FTP[ Status ] = _:FTP_IDLE;
		}
	}
	
	if ( FTP[ Status ] != FTP_DISCONNECTED )
		entity_set_float( iEntity , EV_FL_nextthink , get_gametime() + ( ( FTP[ Status ] == FTP_READYFORDATA ) ? 0.01 : 0.5 ) );
}

CreateFTPEntity()
{
	g_iFTPEntity = create_entity( "info_target" );
	entity_set_string( g_iFTPEntity , EV_SZ_classname , "ftp_entity" );
	register_think( "ftp_entity" , "_FTP_Think" );	
}

ExplodeString( szOutput[][] , iNumOutputStrings , iOutputCharsMax , const szInput[] , cDelimiter )
{
	new iIndex , iPos , iLen = strlen( szInput );
	
	do
	{
		iPos += ( copyc( szOutput[ iIndex ] , iOutputCharsMax , szInput[ iPos ] , cDelimiter ) + 1 );
	}
	while( ( iPos < iLen ) && ( ++iIndex < iNumOutputStrings ) )
	
	return iIndex;
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1033\\ f0\\ fs16 \n\\ par }
*/
