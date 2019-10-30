
#if defined _nfvault_included
	#endinput
#endif
#define _nfvault_included

#if !defined NFV_WILDCARD
	#define NFV_WILDCARD "*"
#endif

#if !defined NFV_TAKEALL
	#define NFV_TAKEALL -1
#endif

#if !defined NFV_SAVETYPE
	#define NFV_SAVETYPE 0 // 0 - steamid ; 1 - name
#endif



/* This is an example script for using the basic nfvault stocks

	new filename[128];
	copy( filename, charsmax(filename), nfv_file("file.txt") );
	nfv_set_data( filename, "key", "name", "data" );
	nfv_set_data( filename, "key", "name2", "data2" );
	nfv_set_data( filename, "key", "name2", "data_2" );
	nfv_set_data( filename, "key", "name3", "data3" );
	nfv_set_data( filename, "key", "name4", "data4" );
	new take_string[10];
	nfv_take_data( filename, "key", "name4", take_string, 9 );
	// take_string == "data4"

	nfv_set_data( filename, "key2", "other_name", "even_more_data" );
	nfv_set_data( filename, "key2", "other_name", "even_more_data2", false );

	nfv_set_data( filename, "key3", "name", "more_data" );
	new get_string[10];
	nfv_get_data( filename, "key3", NFV_WILDCARD, get_string, 9 );
	// get_string == "more_data"

// This is an example of the file for the preceding script

"TimeStamp" "1234567890"
;key
"name" "data"
"name2" "data_2"
"name3" "data3"
;key2
"other_name" "even_more_data"
"other_name" "even_more_data2"
;key3
"name" "more_data"

*/

enum NFV_TYPE
{
	NFVT_INT,
	NFVT_BOOL,
	NFVT_FLOAT,
	NFVT_ARRAY,
	NFVT_VECTOR,
	NFVT_STRING,
	NFVT_CELLARRAY,
	NFVT_CELLARRAY2,
}

enum NFV_PROP ( <<= 1 )
{
	NFV_NONE = 0,
	NFV_OVERWRITE = 1,
	NFV_NO_QUOTES,
	NFV_NO_REPLACE_QUOTE,
	NFV_IF_NOT_EXIST,
}

stock const quote_char = '"'; 			//this can mess up NFV
stock const quote_replace_char = 30; 	//an unused character, in notepad it is a square
stock const temp_file_name[] = "temp_data_file.txt";
stock DataDir[128];

/**
 * Sets multiple datas in file under key and name.
 *
 * @param filename		The file location for the data.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param nfv_prop		Properties to apply to the saved data in a bitsum.
 * @param identifier	The character used to identify different keys.
 *
 * @note				The optional parameters are to add names and datas. They should be provided in the form:
 *							NFVT_*, name[], data
 *						The type NFVT_ARRAY needs a size provided after the data:
 *							NFVT_ARRAY, name[], data[], size
 *
 * @param ...			NFVT_* constant for what type of data it is.
 * @param ...			The name under key to look for.
 * @param ...			The data to write that matches with the NFV_* constant.
 *
 * @example				nfv_add_key( filename[], key[], NFV_NO_QUOTES|NFV_IF_NOT_EXIST, ';',
 *							NFVT_INT, int_name[], 1,
 *							NFVT_BOOL, bool_name[], true,
 *							NFVT_FLOAT, float_name[], 1.0,
 *							NFVT_ARRAY, array_name[], any:array[], sizeof array,
 *							NFVT_VECTOR, vector_name[], Float:vec[3],
 *							NFVT_STRING, string_name[], string[],
 *							NFVT_CELLARRAY, cellarray_name[], Array:cellarray,
 *							NFVT_CELLARRAY2, cellarray2_name[], Array:cellarray2
 *						)
 *
 * @return				1 if successful.
 */
stock nfv_add_key(const filename[], const key[], const NFV_PROP:nfv_prop=NFV_OVERWRITE, const identifier=';', any:...)
{
	new argnum = numargs();
	if( argnum == 4 )
	{
		nfv_set_data(filename, key, "", "", nfv_prop, identifier);
	}
	else
	{
		new tempname[64], tempdata[128], Float:vec[3], tempsize;
		for( new i=4, j=0; i<argnum; i+=3 )
		{
			j=0;
			do tempname[j] = getarg(i+1, j);
			while( tempname[j++] != '^0' && j < 64 );
			switch( getarg(i) )
			{
				case NFVT_INT:
				{
					nfv_set_num(filename, key, tempname, getarg(i+2), nfv_prop, identifier);
				}
				case NFVT_BOOL:
				{
					nfv_set_bool(filename, key, tempname, bool:getarg(i+2), nfv_prop, identifier);
				}
				case NFVT_FLOAT:
				{
					nfv_set_float(filename, key, tempname, Float:getarg(i+2), nfv_prop, identifier);
				}
				case NFVT_ARRAY:
				{
					tempsize = min( 128, getarg(i+3) );
					for( j=0; j < tempsize; j++ )
						tempdata[j] = getarg(i+2, j);
					nfv_set_array(filename, key, tempname, tempdata, tempsize, nfv_prop, identifier);
					i++;	//increase by an extra one for the size
				}
				case NFVT_VECTOR:
				{
					for( j=0; j<3; j++ )
						vec[j] = Float:getarg(i+2, j);
					nfv_set_vec(filename, key, tempname, vec, nfv_prop, identifier);
				}
				case NFVT_STRING:
				{
					j=0;
					do tempdata[j] = getarg(i+2, j);
					while( tempdata[j++] != '^0' && j < 128 );
					nfv_set_data(filename, key, tempname, tempdata, nfv_prop, identifier);
				}
				case NFVT_CELLARRAY:
				{
					nfv_set_cellarray(filename, key, tempname, Array:getarg(i+2), nfv_prop, identifier);
				}
				case NFVT_CELLARRAY2:
				{
					nfv_set_cellarray2(filename, key, tempname, Array:getarg(i+2), nfv_prop, identifier);
				}
			}
		}
	}
}

/**
 * Sets data in file under key and name.
 *
 * @param filename		The file location for the data.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param name			The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data			The data to write.
 * @param nfv_prop		Properties to apply to the saved data in a bitsum.
 * @param identifier	The character used to identify different keys.
 * @return				1 if successful.
 */
stock nfv_set_data(const filename[], const key[], name[], data[], const NFV_PROP:nfv_prop=NFV_OVERWRITE, const identifier=';')
{
	new g = fopen(temp_file_name, "wt");
	new f = fopen(filename, "rt");

	// lets put a time stamp
	fprintf(g, "^"TimeStamp^" ^"%d^"^n", get_systime() );

	new _data[512], _name[64], _other[3];

	new bool:wrote_data = false, bool:found_key = false, bool:found_time = false;

	if( !(nfv_prop&NFV_NO_REPLACE_QUOTE) )
	{
		nfv_replace_quote( name );
		nfv_replace_quote( data );
	}

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		fgets(f, _data, charsmax(_data));

		if( !found_time )
		{
			if( equal(_data, "^"TimeStamp^"", 11) )
			{
				found_time = true;
				continue;
			}
		}
		if( _data[0] == identifier )
		{
			//if found key and wrote data continue and copy to g
			//    if didnt copy data, write data before copying to g
			if( found_key )
			{
				if( !wrote_data )
				{
					fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %s^n" : "^"%s^" ^"%s^"^n", name, data);
					wrote_data = true;
				}
			}
			//else check if correct key, copy to g
			else
			{
				//Make sure we get something parsed
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( _name, key ) )
						found_key = true;
				}
			}

			fputs(g, _data);
		}
		else
		{
			if( !wrote_data )
			{
				if( nfv_prop&NFV_OVERWRITE )
				{
					//Make sure we get something parsed
					if( parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
					{
						//if name matches, write data to g, skip copy
						if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
						{
							fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %s^n" : "^"%s^" ^"%s^"^n", name, data);
							wrote_data = true;
							continue;
						}
					}
				}
				else if( nfv_prop&NFV_IF_NOT_EXIST )
				{
					//Make sure we get something parsed
					if( parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
					{
						//if name matches, stop, close files, delete temp file, return 0
						if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
						{
							fclose(g);
							fclose(f);

							delete_file(temp_file_name);

							return 0;
						}
					}
				}
			}

			//else copy to g
			fputs(g, _data);
		}
	}

	if( !found_key )
	{
		fprintf(g, "%c%s^n", identifier, key);
	}
	if( !wrote_data )
	{
		fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %s^n" : "^"%s^" ^"%s^"^n", name, data);
	}

	fclose(g);
	fclose(f);

	delete_file(filename);

	while( !rename_file(temp_file_name, filename, 1) ) { }

	return 1;
}

/**
 * Sets data as number in file under key and name.
 *
 * @param filename		The file location for the data.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param name			The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data			The number to write.
 * @param nfv_prop		Properties to apply to the saved data in a bitsum.
 * @param identifier	The character used to identify different keys.
 * @return				1 if successful.
 */
stock nfv_set_num(const filename[], const key[], name[], const data, const NFV_PROP:nfv_prop=NFV_OVERWRITE, const identifier=';')
{
	new g = fopen(temp_file_name, "wt");
	new f = fopen(filename, "rt");

	// lets put a time stamp
	fprintf(g, "^"TimeStamp^" ^"%d^"^n", get_systime() );

	new _data[512], _name[64], _other[3];

	new bool:wrote_data = false, bool:found_key = false, bool:found_time = false;

	if( !(nfv_prop&NFV_NO_REPLACE_QUOTE) )
	{
		nfv_replace_quote( name );
	}

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		fgets(f, _data, charsmax(_data));

		if( !found_time )
		{
			if( equal(_data, "^"TimeStamp^"", 11) )
			{
				found_time = true;
				continue;
			}
		}
		if( _data[0] == identifier )
		{
			//if found key and wrote data continue and copy to g
			//    if didnt copy data, write data before copying to g
			if( found_key )
			{
				if( !wrote_data )
				{
					fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %d^n" : "^"%s^" ^"%d^"^n", name, data);
					wrote_data = true;
				}
			}
			//else check if correct key, copy to g
			else
			{
				//Make sure we get something parsed
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( _name, key ) )
						found_key = true;
				}
			}

			fputs(g, _data);
		}
		else
		{
			if( !wrote_data )
			{
				if( nfv_prop&NFV_OVERWRITE )
				{
					//Make sure we get something parsed
					if( parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
					{
						//if name matches, write data to g, skip copy
						if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
						{
							fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %d^n" : "^"%s^" ^"%d^"^n", name, data);
							wrote_data = true;
							continue;
						}
					}
				}
				else if( nfv_prop&NFV_IF_NOT_EXIST )
				{
					//Make sure we get something parsed
					if( parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
					{
						//if name matches, stop, close files, delete temp file, return 0
						if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
						{
							fclose(g);
							fclose(f);

							delete_file(temp_file_name);

							return 0;
						}
					}
				}
			}

			//else copy to g
			fputs(g, _data);
		}
	}

	if( !found_key )
	{
		fprintf(g, "%c%s^n", identifier, key);
	}
	if( !wrote_data )
	{
		fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %d^n" : "^"%s^" ^"%d^"^n", name, data);
	}

	fclose(g);
	fclose(f);

	delete_file(filename);

	while( !rename_file(temp_file_name, filename, 1) ) { }

	return 1;
}

/**
 * Adds to a pre-existing data number in file under key and name.
 *
 * @param filename		The file location for the data.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param name			The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data			The number to add.
 * @param nfv_prop		Properties to apply to the saved data in a bitsum.
 * @param identifier	The character used to identify different keys.
 *
 * @note				Will assume NFV_OVERWRITE is in nfv_prop and ignore NFV_IF_NOT_EXIST
 *
 * @return				Returns new data.
 */
stock nfv_add_num(const filename[], const key[], name[], const data, const NFV_PROP:nfv_prop=NFV_OVERWRITE, const identifier=';')
{
	new g = fopen(temp_file_name, "wt");
	new f = fopen(filename, "rt");

	// lets put a time stamp
	fprintf(g, "^"TimeStamp^" ^"%d^"^n", get_systime() );

	new _data[512], _name[64], _other[64], _value = data;

	new bool:wrote_data = false, bool:found_key = false, bool:found_time = false;

	if( !(nfv_prop&NFV_NO_REPLACE_QUOTE) )
	{
		nfv_replace_quote( name );
	}

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		fgets(f, _data, charsmax(_data));

		if( !found_time )
		{
			if( equal(_data, "^"TimeStamp^"", 11) )
			{
				found_time = true;
				continue;
			}
		}
		if( _data[0] == identifier )
		{
			//if found key and wrote data continue and copy to g
			//    if didnt copy data, write data before copying to g
			if( found_key )
			{
				if( !wrote_data )
				{
					fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %d^n" : "^"%s^" ^"%d^"^n", name, data);
					wrote_data = true;
				}
			}
			//else check if correct key, copy to g
			else
			{
				//Make sure we get something parsed
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( _name, key ) )
						found_key = true;
				}
			}

			fputs(g, _data);
		}
		else
		{
			if( found_key && !wrote_data )
			{
				//Make sure we get something parsed
				if( parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
				{
					//if name matches, write data to g, skip copy
					if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
					{
						_value = data + str_to_num(_other);
						fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %d^n" : "^"%s^" ^"%d^"^n", name, _value );
						wrote_data = true;
						continue;
					}
				}
			}
			//else copy to g
			fputs(g, _data);
		}
	}

	if( !found_key )
	{
		fprintf(g, "%c%s^n", identifier, key);
	}
	if( !wrote_data )
	{
		fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %d^n" : "^"%s^" ^"%d^"^n", name, data);
	}

	fclose(g);
	fclose(f);

	delete_file(filename);

	while( !rename_file(temp_file_name, filename, 1) ) { }

	return _value;
}

/**
 * Sets data as a floating point in file under key and name.
 *
 * @param filename		The file location for the data.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param name			The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data			The floating point to write.
 * @param nfv_prop		Properties to apply to the saved data in a bitsum.
 * @param identifier	The character used to identify different keys.
 * @return				1 if successful.
 */
stock nfv_set_float(const filename[], const key[], name[], const Float:data, const NFV_PROP:nfv_prop=NFV_OVERWRITE, const identifier=';')
{
	new g = fopen(temp_file_name, "wt");
	new f = fopen(filename, "rt");

	// lets put a time stamp
	fprintf(g, "^"TimeStamp^" ^"%d^"^n", get_systime() );

	new _data[512], _name[64], _other[3];

	new bool:wrote_data = false, bool:found_key = false, bool:found_time = false;

	if( !(nfv_prop&NFV_NO_REPLACE_QUOTE) )
	{
		nfv_replace_quote( name );
	}

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		fgets(f, _data, charsmax(_data));

		if( !found_time )
		{
			if( equal(_data, "^"TimeStamp^"", 11) )
			{
				found_time = true;
				continue;
			}
		}
		if( _data[0] == identifier )
		{
			//if found key and wrote data continue and copy to g
			//    if didnt copy data, write data before copying to g
			if( found_key )
			{
				if( !wrote_data )
				{
					fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %f^n" : "^"%s^" ^"%f^"^n", name, data);
					wrote_data = true;
				}
			}
			//else check if correct key, copy to g
			else
			{
				//Make sure we get something parsed
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( _name, key ) )
						found_key = true;
				}
			}

			fputs(g, _data);
		}
		else
		{
			if( !wrote_data )
			{
				if( nfv_prop&NFV_OVERWRITE )
				{
					//Make sure we get something parsed
					if( parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
					{
						//if name matches, write data to g, skip copy
						if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
						{
							fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %f^n" : "^"%s^" ^"%f^"^n", name, data);
							wrote_data = true;
							continue;
						}
					}
				}
				else if( nfv_prop&NFV_IF_NOT_EXIST )
				{
					//Make sure we get something parsed
					if( parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
					{
						//if name matches, stop, close files, delete temp file, return 0
						if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
						{
							fclose(g);
							fclose(f);

							delete_file(temp_file_name);

							return 0;
						}
					}
				}
			}

			//else copy to g
			fputs(g, _data);
		}
	}

	if( !found_key )
	{
		fprintf(g, "%c%s^n", identifier, key);
	}
	if( !wrote_data )
	{
		fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %f^n" : "^"%s^" ^"%f^"^n", name, data);
	}

	fclose(g);
	fclose(f);

	delete_file(filename);

	while( !rename_file(temp_file_name, filename, 1) ) { }

	return 1;
}

/**
 * Adds to pre-existing floating point data in file under key and name.
 *
 * @param filename		The file location for the data.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param name			The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data			The floating point to add.
 * @param nfv_prop		Properties to apply to the saved data in a bitsum.
 * @param identifier	The character used to identify different keys.
 *
 * @note				Will assume NFV_OVERWRITE is in nfv_prop and ignore NFV_IF_NOT_EXIST
 *
 * @return				Returns new data.
 */
stock Float:nfv_add_float(const filename[], const key[], name[], const Float:data, const NFV_PROP:nfv_prop=NFV_OVERWRITE, const identifier=';')
{
	new g = fopen(temp_file_name, "wt");
	new f = fopen(filename, "rt");

	// lets put a time stamp
	fprintf(g, "^"TimeStamp^" ^"%d^"^n", get_systime() );

	new _data[512], _name[64], _other[64], Float:_value=data;

	new bool:wrote_data = false, bool:found_key = false, bool:found_time = false;

	if( !(nfv_prop&NFV_NO_REPLACE_QUOTE) )
	{
		nfv_replace_quote( name );
	}

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		fgets(f, _data, charsmax(_data));

		if( !found_time )
		{
			if( equal(_data, "^"TimeStamp^"", 11) )
			{
				found_time = true;
				continue;
			}
		}
		if( _data[0] == identifier )
		{
			//if found key and wrote data continue and copy to g
			//    if didnt copy data, write data before copying to g
			if( found_key )
			{
				if( !wrote_data )
				{
					fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %f^n" : "^"%s^" ^"%f^"^n", name, data);
					wrote_data = true;
				}
			}
			//else check if correct key, copy to g
			else
			{
				//Make sure we get something parsed
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( _name, key ) )
						found_key = true;
				}
			}

			fputs(g, _data);
		}
		else
		{
			if( found_key && !wrote_data )
			{
				//Make sure we get something parsed
				if( parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
				{
					//if name matches, write data to g, skip copy
					if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
					{
						_value = data + str_to_float(_other);
						fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %f^n" : "^"%s^" ^"%f^"^n", name, _value );
						wrote_data = true;
						continue;
					}
				}
			}
			//else copy to g
			fputs(g, _data);
		}
	}

	if( !found_key )
	{
		fprintf(g, "%c%s^n", identifier, key);
	}
	if( !wrote_data )
	{
		fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %f^n" : "^"%s^" ^"%f^"^n", name, data);
	}

	fclose(g);
	fclose(f);

	delete_file(filename);

	while( !rename_file(temp_file_name, filename, 1) ) { }

	return _value;
}

/**
 * Sets data as bool in file under key and name.
 *
 * @param filename		The file location for the data.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param name			The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data			The boolean value to write.
 * @param nfv_prop		Properties to apply to the saved data in a bitsum.
 * @param identifier	The character used to identify different keys.
 * @return				1 if successful.
 */
stock nfv_set_bool(const filename[], const key[], name[], const bool:data, const NFV_PROP:nfv_prop=NFV_OVERWRITE, const identifier=';')
{
	new g = fopen(temp_file_name, "wt");
	new f = fopen(filename, "rt");

	// lets put a time stamp
	fprintf(g, "^"TimeStamp^" ^"%d^"^n", get_systime() );

	new _data[512], _name[64], _other[3];

	new bool:wrote_data = false, bool:found_key = false, bool:found_time = false;

	if( !(nfv_prop&NFV_NO_REPLACE_QUOTE) )
	{
		nfv_replace_quote( name );
	}

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		fgets(f, _data, charsmax(_data));

		if( !found_time )
		{
			if( equal(_data, "^"TimeStamp^"", 11) )
			{
				found_time = true;
				continue;
			}
		}
		if( _data[0] == identifier )
		{
			//if found key and wrote data continue and copy to g
			//    if didnt copy data, write data before copying to g
			if( found_key )
			{
				if( !wrote_data )
				{
					if( nfv_prop&NFV_NO_QUOTES )
						fprintf(g, data ? "%s true^n" : "%s false^n", name);
					else
						fprintf(g, data ? "^"%s^" ^"true^"^n" : "^"%s^" ^"false^"^n", name);
					wrote_data = true;
				}
			}
			//else check if correct key, copy to g
			else
			{
				//Make sure we get something parsed
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( _name, key ) )
						found_key = true;
				}
			}

			fputs(g, _data);
		}
		else
		{
			if( !wrote_data )
			{
				if( nfv_prop&NFV_OVERWRITE )
				{
					//Make sure we get something parsed
					if( parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
					{
						//if name matches, write data to g, skip copy
						if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
						{
							if( nfv_prop&NFV_NO_QUOTES )
								fprintf(g, data ? "%s true^n" : "%s false^n", name);
							else
								fprintf(g, data ? "^"%s^" ^"true^"^n" : "^"%s^" ^"false^"^n", name);
							wrote_data = true;
							continue;
						}
					}
				}
				else if( nfv_prop&NFV_IF_NOT_EXIST )
				{
					//Make sure we get something parsed
					if( parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
					{
						//if name matches, stop, close files, delete temp file, return 0
						if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
						{
							fclose(g);
							fclose(f);

							delete_file(temp_file_name);

							return 0;
						}
					}
				}
			}

			//else copy to g
			fputs(g, _data);
		}
	}

	if( !found_key )
	{
		fprintf(g, "%c%s^n", identifier, key);
	}
	if( !wrote_data )
	{
		if( nfv_prop&NFV_NO_QUOTES )
			fprintf(g, data ? "%s true^n" : "%s false^n", name);
		else
			fprintf(g, data ? "^"%s^" ^"true^"^n" : "^"%s^" ^"false^"^n", name);
	}

	fclose(g);
	fclose(f);

	delete_file(filename);

	while( !rename_file(temp_file_name, filename, 1) ) { }

	return 1;
}

/**
 * Sets data to the opposite of what it was in file under key and name.
 *
 * @param filename		The file location for the data.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param name			The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param nfv_prop		Properties to apply to the saved data in a bitsum.
 * @param identifier	The character used to identify different keys.
 *
 * @note				Will assume NFV_OVERWRITE is in nfv_prop and ignore NFV_IF_NOT_EXIST
 *
 * @return				Returns new data.
 */
stock bool:nfv_xor_bool(const filename[], const key[], name[], const NFV_PROP:nfv_prop=NFV_OVERWRITE, const identifier=';')
{
	new g = fopen(temp_file_name, "wt");
	new f = fopen(filename, "rt");

	// lets put a time stamp
	fprintf(g, "^"TimeStamp^" ^"%d^"^n", get_systime() );

	new _data[512], _name[64], _other[64], bool:_value = true;

	new bool:wrote_data = false, bool:found_key = false, bool:found_time = false;

	if( !(nfv_prop&NFV_NO_REPLACE_QUOTE) )
	{
		nfv_replace_quote( name );
	}

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		fgets(f, _data, charsmax(_data));

		if( !found_time )
		{
			if( equal(_data, "^"TimeStamp^"", 11) )
			{
				found_time = true;
				continue;
			}
		}
		if( _data[0] == identifier )
		{
			//if found key and wrote data continue and copy to g
			//    if didnt copy data, write data before copying to g
			if( found_key )
			{
				if( !wrote_data )
				{
					if( nfv_prop&NFV_NO_QUOTES )
						fprintf(g, "%s true^n", name);
					else
						fprintf(g, "^"%s^" ^"true^"^n", name);
					wrote_data = true;
				}
			}
			//else check if correct key, copy to g
			else
			{
				//Make sure we get something parsed
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( _name, key ) )
						found_key = true;
				}
			}

			fputs(g, _data);
		}
		else
		{
			if( found_key && !wrote_data )
			{
				//Make sure we get something parsed
				if( parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
				{
					//if name matches, write data to g, skip copy
					if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
					{
						_value = !str_to_bool( _other );
						if( nfv_prop&NFV_NO_QUOTES )
							fprintf(g, _value ? "%s true^n" : "%s false^n", name);
						else
							fprintf(g, _value ? "^"%s^" ^"true^"^n" : "^"%s^" ^"false^"^n", name);
						wrote_data = true;
						continue;
					}
				}
			}
			//else copy to g
			fputs(g, _data);
		}
	}

	if( !found_key )
	{
		fprintf(g, "%c%s^n", identifier, key);
	}
	if( !wrote_data )
	{
		if( nfv_prop&NFV_NO_QUOTES )
			fprintf(g, "%s true^n", name);
		else
			fprintf(g, "^"%s^" ^"true^"^n", name);
	}

	fclose(g);
	fclose(f);

	delete_file(filename);

	while( !rename_file(temp_file_name, filename, 1) ) { }

	return _value;
}

/**
 * Sets data as a vector in file under key and name.
 *
 * @param filename		The file location for the data.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param name			The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data			The vector to write.
 * @param nfv_prop		Properties to apply to the saved data in a bitsum.
 * @param identifier	The character used to identify different keys.
 * @return				1 if successful.
 */
stock nfv_set_vec(const filename[], const key[], name[], const Float:data[3], const NFV_PROP:nfv_prop=NFV_OVERWRITE, const identifier=';')
{
	new g = fopen(temp_file_name, "wt");
	new f = fopen(filename, "rt");

	// lets put a time stamp
	fprintf(g, "^"TimeStamp^" ^"%d^"^n", get_systime() );

	new _data[512], _name[64], _other[3];

	new bool:wrote_data = false, bool:found_key = false, bool:found_time = false;

	if( !(nfv_prop&NFV_NO_REPLACE_QUOTE) )
	{
		nfv_replace_quote( name );
	}

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		fgets(f, _data, charsmax(_data));

		if( !found_time )
		{
			if( equal(_data, "^"TimeStamp^"", 11) )
			{
				found_time = true;
				continue;
			}
		}
		if( _data[0] == identifier )
		{
			//if found key and wrote data continue and copy to g
			//    if didnt copy data, write data before copying to g
			if( found_key )
			{
				if( !wrote_data )
				{
					fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %f,%f,%f^n" : "^"%s^" ^"%f,%f,%f^"^n", name, data[0], data[1], data[2]);
					wrote_data = true;
				}
			}
			//else check if correct key, copy to g
			else
			{
				//Make sure we get something parsed
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( _name, key ) )
						found_key = true;
				}
			}

			fputs(g, _data);
		}
		else
		{
			if( !wrote_data )
			{
				if( nfv_prop&NFV_OVERWRITE )
				{
					//Make sure we get something parsed
					if( parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
					{
						//if name matches, write data to g, skip copy
						if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
						{
							fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %f,%f,%f^n" : "^"%s^" ^"%f,%f,%f^"^n", name, data[0], data[1], data[2]);
							wrote_data = true;
							continue;
						}
					}
				}
				else if( nfv_prop&NFV_IF_NOT_EXIST )
				{
					//Make sure we get something parsed
					if( parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
					{
						//if name matches, stop, close files, delete temp file, return 0
						if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
						{
							fclose(g);
							fclose(f);

							delete_file(temp_file_name);

							return 0;
						}
					}
				}
			}

			//else copy to g
			fputs(g, _data);
		}
	}

	if( !found_key )
	{
		fprintf(g, "%c%s^n", identifier, key);
	}
	if( !wrote_data )
	{
		fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %f,%f,%f^n" : "^"%s^" ^"%f,%f,%f^"^n", name, data[0], data[1], data[2]);
	}

	fclose(g);
	fclose(f);

	delete_file(filename);

	while( !rename_file(temp_file_name, filename, 1) ) { }

	return 1;
}

/**
 * Sets data as an array in file under key and name.
 *
 * @param filename		The file location for the data.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param name			The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data			The array to write.
 * @param array_size	The size of the array.
 * @param nfv_prop		Properties to apply to the saved data in a bitsum.
 * @param identifier	The character used to identify different keys.
 *
 * @note				This will save each element as the integer form
 *
 * @return				1 if successful.
 */
stock nfv_set_array(const filename[], const key[], name[], const any:data[], const array_size, const NFV_PROP:nfv_prop=NFV_OVERWRITE, const identifier=';')
{
	new g = fopen(temp_file_name, "wt");
	new f = fopen(filename, "rt");

	// lets put a time stamp
	fprintf(g, "^"TimeStamp^" ^"%d^"^n", get_systime() );

	new _data[512], _name[64], _other[3], i;

	new bool:wrote_data = false, bool:found_key = false, bool:found_time = false;

	if( !(nfv_prop&NFV_NO_REPLACE_QUOTE) )
	{
		nfv_replace_quote( name );
	}

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		fgets(f, _data, charsmax(_data));

		if( !found_time )
		{
			if( equal(_data, "^"TimeStamp^"", 11) )
			{
				found_time = true;
				continue;
			}
		}
		if( _data[0] == identifier )
		{
			//if found key and wrote data continue and copy to g
			//    if didnt copy data, write data before copying to g
			if( found_key )
			{
				if( !wrote_data )
				{
					fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %d" : "^"%s^" ^"%d", name, data[0]);
					for( i=1; i<array_size; i++ )
						fprintf(g, ",%d", data[i]);
					fputs(g, nfv_prop&NFV_NO_QUOTES ? "^n" : "^"^n");
					wrote_data = true;
				}
			}
			//else check if correct key, copy to g
			else
			{
				//Make sure we get something parsed
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( _name, key ) )
						found_key = true;
				}
			}

			fputs(g, _data);
		}
		else
		{
			if( !wrote_data )
			{
				if( nfv_prop&NFV_OVERWRITE )
				{
					//Make sure we get something parsed
					if( parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
					{
						//if name matches, write data to g, skip copy
						if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
						{
							fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %d" : "^"%s^" ^"%d", name, data[0]);
							for( i=1; i<array_size; i++ )
								fprintf(g, ",%d", data[i]);
							fputs(g, nfv_prop&NFV_NO_QUOTES ? "^n" : "^"^n");
							wrote_data = true;
							continue;
						}
					}
				}
				else if( nfv_prop&NFV_IF_NOT_EXIST )
				{
					//Make sure we get something parsed
					if( parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
					{
						//if name matches, stop, close files, delete temp file, return 0
						if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
						{
							fclose(g);
							fclose(f);

							delete_file(temp_file_name);

							return 0;
						}
					}
				}
			}

			//else copy to g
			fputs(g, _data);
		}
	}

	if( !found_key )
	{
		fprintf(g, "%c%s^n", identifier, key);
	}
	if( !wrote_data )
	{
		fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %d" : "^"%s^" ^"%d", name, data[0]);
		for( i=1; i<array_size; i++ )
			fprintf(g, ",%d", data[i]);
		fputs(g, nfv_prop&NFV_NO_QUOTES ? "^n" : "^"^n");
	}

	fclose(g);
	fclose(f);

	delete_file(filename);

	while( !rename_file(temp_file_name, filename, 1) ) { }

	return 1;
}

/**
 * Sets data as an array in file under key and name.
 *
 * @param filename		The file location for the data.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param name			The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data			The cell array to write.
 * @param array_size	The size of the array.
 * @param nfv_prop		Properties to apply to the saved data in a bitsum.
 * @param identifier	The character used to identify different keys.
 *
 * @note				This will save each element as the integer form
 *
 * @return				1 if successful.
 */
stock nfv_set_cellarray(const filename[], const key[], name[], const Array:data, const NFV_PROP:nfv_prop=NFV_OVERWRITE, const identifier=';')
{
	new g = fopen(temp_file_name, "wt");
	new f = fopen(filename, "rt");

	// lets put a time stamp
	fprintf(g, "^"TimeStamp^" ^"%d^"^n", get_systime() );

	new _data[512], _name[64], _other[3], i;

	new bool:wrote_data = false, bool:found_key = false, bool:found_time = false;
	new array_size = ArraySize(data);

	if( !(nfv_prop&NFV_NO_REPLACE_QUOTE) )
	{
		nfv_replace_quote( name );
	}

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		fgets(f, _data, charsmax(_data));

		if( !found_time )
		{
			if( equal(_data, "^"TimeStamp^"", 11) )
			{
				found_time = true;
				continue;
			}
		}
		if( _data[0] == identifier )
		{
			//if found key and wrote data continue and copy to g
			//    if didnt copy data, write data before copying to g
			if( found_key )
			{
				if( !wrote_data )
				{
					fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %d" : "^"%s^" ^"%d", name, ArrayGetCell(data,0));
					for( i=1; i<array_size; i++ )
						fprintf(g, ",%d", ArrayGetCell(data,i));
					fputs(g, nfv_prop&NFV_NO_QUOTES ? "^n" : "^"^n");
					wrote_data = true;
				}
			}
			//else check if correct key, copy to g
			else
			{
				//Make sure we get something parsed
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( _name, key ) )
						found_key = true;
				}
			}

			fputs(g, _data);
		}
		else
		{
			if( !wrote_data )
			{
				if( nfv_prop&NFV_OVERWRITE )
				{
					//Make sure we get something parsed
					if( parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
					{
						//if name matches, write data to g, skip copy
						if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
						{
							fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %d" : "^"%s^" ^"%d", name, ArrayGetCell(data,0));
							for( i=1; i<array_size; i++ )
								fprintf(g, ",%d", ArrayGetCell(data,i));
							fputs(g, nfv_prop&NFV_NO_QUOTES ? "^n" : "^"^n");
							wrote_data = true;
							continue;
						}
					}
				}
				else if( nfv_prop&NFV_IF_NOT_EXIST )
				{
					//Make sure we get something parsed
					if( parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
					{
						//if name matches, stop, close files, delete temp file, return 0
						if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
						{
							fclose(g);
							fclose(f);

							delete_file(temp_file_name);

							return 0;
						}
					}
				}
			}

			//else copy to g
			fputs(g, _data);
		}
	}

	if( !found_key )
	{
		fprintf(g, "%c%s^n", identifier, key);
	}
	if( !wrote_data )
	{
		fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %d" : "^"%s^" ^"%d", name, ArrayGetCell(data,0));
		for( i=1; i<array_size; i++ )
			fprintf(g, ",%d", ArrayGetCell(data,i));
		fputs(g, nfv_prop&NFV_NO_QUOTES ? "^n" : "^"^n");
	}

	fclose(g);
	fclose(f);

	delete_file(filename);

	while( !rename_file(temp_file_name, filename, 1) ) { }

	return 1;
}

/**
 * Sets data as array of strings in file under key and name.
 *
 * @param filename		The file location for the data.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param name			The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data			The cell array to write.
 * @param array_size	The size of the array.
 * @param nfv_prop		Properties to apply to the saved data in a bitsum.
 * @param identifier	The character used to identify different keys.
 *
 * @note				This will save in the form: "first","second","third","etc."
 *
 * @return				1 if successful.
 */
stock nfv_set_cellarray2(const filename[], const key[], name[], const Array:data, const NFV_PROP:nfv_prop=NFV_OVERWRITE, const identifier=';')
{
	new g = fopen(temp_file_name, "wt");
	new f = fopen(filename, "rt");

	// lets put a time stamp
	fprintf(g, "^"TimeStamp^" ^"%d^"^n", get_systime() );

	new _data[512], _name[64], _other[3], i;
	new temp_string[64];

	new bool:wrote_data = false, bool:found_key = false, bool:found_time = false;
	new array_size = ArraySize(data);

	if( !(nfv_prop&NFV_NO_REPLACE_QUOTE) )
	{
		nfv_replace_quote( name );
	}

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		fgets(f, _data, charsmax(_data));

		if( !found_time )
		{
			if( equal(_data, "^"TimeStamp^"", 11) )
			{
				found_time = true;
				continue;
			}
		}
		if( _data[0] == identifier )
		{
			//if found key and wrote data continue and copy to g
			//    if didnt copy data, write data before copying to g
			if( found_key )
			{
				if( !wrote_data )
				{
					ArrayGetString(data, 0, temp_string, charsmax(temp_string));
					nfv_replace_quote( temp_string );
					fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %s" : "^"%s^" ^"%s", name, temp_string);
					for( i=1; i<array_size; i++ )
					{
						ArrayGetString(data, i, temp_string, charsmax(temp_string));
						nfv_replace_quote( temp_string );
						fprintf(g, nfv_prop&NFV_NO_QUOTES ? ",%s" : "^",^"%s^"", temp_string);
					}
					fputs(g, nfv_prop&NFV_NO_QUOTES ? "^n" : "^"^n");
					wrote_data = true;
				}
			}
			//else check if correct key, copy to g
			else
			{
				//Make sure we get something parsed
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( _name, key ) )
						found_key = true;
				}
			}

			fputs(g, _data);
		}
		else
		{
			if( !wrote_data )
			{
				if( nfv_prop&NFV_OVERWRITE )
				{
					//Make sure we get something parsed
					if( parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
					{
						//if name matches, write data to g, skip copy
						if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
						{
							ArrayGetString(data, 0, temp_string, charsmax(temp_string));
							nfv_replace_quote( temp_string );
							fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %s" : "^"%s^" ^"%s", name, temp_string);
							for( i=1; i<array_size; i++ )
							{
								ArrayGetString(data, i, temp_string, charsmax(temp_string));
								nfv_replace_quote( temp_string );
								fprintf(g, nfv_prop&NFV_NO_QUOTES ? ",%s" : "^",^"%s^"", temp_string);
							}
							fputs(g, nfv_prop&NFV_NO_QUOTES ? "^n" : "^"^n");
							wrote_data = true;
							continue;
						}
					}
				}
				else if( nfv_prop&NFV_IF_NOT_EXIST )
				{
					//Make sure we get something parsed
					if( parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
					{
						//if name matches, stop, close files, delete temp file, return 0
						if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
						{
							fclose(g);
							fclose(f);

							delete_file(temp_file_name);

							return 0;
						}
					}
				}
			}

			//else copy to g
			fputs(g, _data);
		}
	}

	if( !found_key )
	{
		fprintf(g, "%c%s^n", identifier, key);
	}
	if( !wrote_data )
	{
		ArrayGetString(data, 0, temp_string, charsmax(temp_string));
		nfv_replace_quote( temp_string );
		fprintf(g, nfv_prop&NFV_NO_QUOTES ? "%s %s" : "^"%s^" ^"%s", name, temp_string);
		for( i=1; i<array_size; i++ )
		{
			ArrayGetString(data, i, temp_string, charsmax(temp_string));
			nfv_replace_quote( temp_string );
			fprintf(g, nfv_prop&NFV_NO_QUOTES ? ",%s" : "^",^"%s^"", temp_string);
		}
		fputs(g, nfv_prop&NFV_NO_QUOTES ? "^n" : "^"^n");
	}

	fclose(g);
	fclose(f);

	delete_file(filename);

	while( !rename_file(temp_file_name, filename, 1) ) { }

	return 1;
}

/**
 * Retrieves data in file under key and name.
 *
 * @param filename			The file location to search for the data.
 * @param key				The key within the file to look for. Set to "" for no key. Set to NFV_WILDCARD for any key.
 * @param name				The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data				The string that will contain the data retrieved.
 * @param len				The size of the data string.
 * @param identifier		The character used to identify different keys.
 * @param key_tell_start	Where to start searching for key.
 * @param key_tell_find		Where the key was found.
 * @param name_tell_start	Where to start searching for name.
 * @param name_tell_find	Where the name was found.
 * @param key_copy			The string that will contain the key of the data retrieved. Only used with NFV_WILDCARD for key.
 * @param key_len			If specified, the size of the key found to copy. Only used with NFV_WILDCARD for key.
 * @param name_copy			The string that will contain the name of the data retrieved. Only used with NFV_WILDCARD for name.
 * @param name_len			If specified, the size of the name found to copy. Only used with NFV_WILDCARD for name.
 * @return					1 if data found.
 */
stock nfv_get_data(const filename[], const key[], name[], data[]="", len=0, const identifier=';', const key_tell_start=0, &key_tell_find=0, const name_tell_start=0, &name_tell_find=0, key_copy[]="", const key_len=0, name_copy[]="", const name_len=0)
{
	//Haven't found anything yet
	key_tell_find = name_tell_find = -1;

	if( key_tell_start <= -1 || name_tell_start <= -1 || !file_exists(filename) )
		return 0;

	new f = fopen(filename, "rt");

	new bool:found_key = false;
	new _data[512], _name[64], _other[2], _temp_tell;

	nfv_replace_quote( name );

	//Seek to key_tell_start
	if( key_tell_start )
		fseek(f, key_tell_start, SEEK_SET);

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		_temp_tell = ftell(f);
		fgets(f, _data, charsmax(_data));

		if( _data[0] == identifier )
		{
			if( found_key )
			{
				break;
			}
			else
			{
				//Make sure we get something parsed
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( key, _name ) || equal( key, NFV_WILDCARD ) )
					{
						if( key_len > 0 )
							copy( key_copy, key_len, _name );

						found_key = true;

						//Seek to name_tell_start
						if( name_tell_start )
							fseek(f, name_tell_start, SEEK_SET);

						key_tell_find = _temp_tell;
					}
				}
			}
		}
		else
		{
			if( found_key && parse(_data, _name, charsmax(_name), data, len) )
			{
				if( equal(_name, name) || equal( name, NFV_WILDCARD ) )
				{
					if( name_len > 0 )
					{
						copy( name_copy, name_len, _name );
						nfv_return_quote( name_copy );
					}

					name_tell_find = _temp_tell;
					nfv_return_quote( data );

					fclose(f);
					return 1;
				}
			}
		}
	}
	
	fclose(f);
	data[0] = '^0';
	return 0;
}

/**
 * Retrieves data as number form in file under key and name.
 *
 * @param filename			The file location to search for the data.
 * @param key				The key within the file to look for. Set to "" for no key. Set to NFV_WILDCARD for any key.
 * @param name				The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param identifier		The character used to identify different keys.
 * @param key_tell_start	Where to start searching for key.
 * @param key_tell_find		Where the key was found.
 * @param name_tell_start	Where to start searching for name.
 * @param name_tell_find	Where the name was found.
 * @param key_copy			The string that will contain the key of the data retrieved. Only used with NFV_WILDCARD for key.
 * @param key_len			If specified, the size of the key found to copy. Only used with NFV_WILDCARD for key.
 * @param name_copy			The string that will contain the name of the data retrieved. Only used with NFV_WILDCARD for name.
 * @param name_len			If specified, the size of the name found to copy. Only used with NFV_WILDCARD for name.
 * @return					Numeric value of data found. 0 if no data.
 */
stock nfv_get_num(const filename[], const key[], name[], const identifier=';', const key_tell_start=0, &key_tell_find=0, const name_tell_start=0, &name_tell_find=0, key_copy[]="", const key_len=0, name_copy[]="", const name_len=0)
{
	//Haven't found anything yet
	key_tell_find = name_tell_find = -1;

	if( key_tell_start <= -1 || name_tell_start <= -1 || !file_exists(filename) )
		return 0;

	new f = fopen(filename, "rt");

	new bool:found_key = false;
	new _data[512], _name[64], _other[64], _temp_tell;

	nfv_replace_quote( name );

	//Seek to key_tell_start
	if( key_tell_start )
		fseek(f, key_tell_start, SEEK_SET);

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		_temp_tell = ftell(f);
		fgets(f, _data, charsmax(_data));

		if( _data[0] == identifier )
		{
			if( found_key )
			{
				break;
			}
			else
			{
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( key, _name ) || equal( key, NFV_WILDCARD ) )
					{
						if( key_len > 0 )
							copy( key_copy, key_len, _name );

						found_key = true;

						//Seek to name_tell_start
						if( name_tell_start )
							fseek(f, name_tell_start, SEEK_SET);

						key_tell_find = _temp_tell;
					}
				}
			}
		}
		else
		{
			if( found_key && parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
			{
				if( equal(_name, name) || equal( name, NFV_WILDCARD ) )
				{
					if( name_len > 0 )
					{
						copy( name_copy, name_len, _name );
						nfv_return_quote( name_copy );
					}

					name_tell_find = _temp_tell;

					fclose(f);
					return str_to_num(_other);
				}
			}
		}
	}

	fclose(f);
	return 0;
}

/**
 * Retrieves data as floating point form in file under key and name.
 *
 * @param filename			The file location to search for the data.
 * @param key				The key within the file to look for. Set to "" for no key. Set to NFV_WILDCARD for any key.
 * @param name				The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param identifier		The character used to identify different keys.
 * @param key_tell_start	Where to start searching for key.
 * @param key_tell_find		Where the key was found.
 * @param name_tell_start	Where to start searching for name.
 * @param name_tell_find	Where the name was found.
 * @param key_copy			The string that will contain the key of the data retrieved. Only used with NFV_WILDCARD for key.
 * @param key_len			If specified, the size of the key found to copy. Only used with NFV_WILDCARD for key.
 * @param name_copy			The string that will contain the name of the data retrieved. Only used with NFV_WILDCARD for name.
 * @param name_len			If specified, the size of the name found to copy. Only used with NFV_WILDCARD for name.
 * @return					Floating point value of data found. 0.0 if no data.
 */
stock Float:nfv_get_float(const filename[], const key[], name[], const identifier=';', const key_tell_start=0, &key_tell_find=0, const name_tell_start=0, &name_tell_find=0, key_copy[]="", const key_len=0, name_copy[]="", const name_len=0)
{
	//Haven't found anything yet
	key_tell_find = name_tell_find = -1;

	if( key_tell_start <= -1 || name_tell_start <= -1 || !file_exists(filename) )
		return 0.0;

	new f = fopen(filename, "rt");

	new bool:found_key = false;
	new _data[512], _name[64], _other[64], _temp_tell;

	nfv_replace_quote( name );

	//Seek to key_tell_start
	if( key_tell_start )
		fseek(f, key_tell_start, SEEK_SET);

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		_temp_tell = ftell(f);
		fgets(f, _data, charsmax(_data));

		if( _data[0] == identifier )
		{
			if( found_key )
			{
				break;
			}
			else
			{
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( key, _name ) || equal( key, NFV_WILDCARD ) )
					{
						if( key_len > 0 )
							copy( key_copy, key_len, _name );

						found_key = true;

						//Seek to name_tell_start
						if( name_tell_start )
							fseek(f, name_tell_start, SEEK_SET);

						key_tell_find = _temp_tell;
					}
				}
			}
		}
		else
		{
			if( found_key && parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
			{
				if( equal(_name, name) || equal( name, NFV_WILDCARD ) )
				{
					if( name_len > 0 )
					{
						copy( name_copy, name_len, _name );
						nfv_return_quote( name_copy );
					}

					name_tell_find = _temp_tell;

					fclose(f);
					return str_to_float(_other);
				}
			}
		}
	}
	
	fclose(f);
	return 0.0;
}

/**
 * Retrieves data as boolean form in file under key and name.
 *
 * @param filename			The file location to search for the data.
 * @param key				The key within the file to look for. Set to "" for no key. Set to NFV_WILDCARD for any key.
 * @param name				The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param identifier		The character used to identify different keys.
 * @param key_tell_start	Where to start searching for key.
 * @param key_tell_find		Where the key was found.
 * @param name_tell_start	Where to start searching for name.
 * @param name_tell_find	Where the name was found.
 * @param key_copy			The string that will contain the key of the data retrieved. Only used with NFV_WILDCARD for key.
 * @param key_len			If specified, the size of the key found to copy. Only used with NFV_WILDCARD for key.
 * @param name_copy			The string that will contain the name of the data retrieved. Only used with NFV_WILDCARD for name.
 * @param name_len			If specified, the size of the name found to copy. Only used with NFV_WILDCARD for name.
 * @return					Boolean value of data found. False if no data.
 */
stock bool:nfv_get_bool(const filename[], const key[], name[], const identifier=';', const key_tell_start=0, &key_tell_find=0, const name_tell_start=0, &name_tell_find=0, key_copy[]="", const key_len=0, name_copy[]="", const name_len=0)
{
	//Haven't found anything yet
	key_tell_find = name_tell_find = -1;

	if( key_tell_start <= -1 || name_tell_start <= -1 || !file_exists(filename) )
		return false;

	new f = fopen(filename, "rt");

	new bool:found_key = false;
	new _data[512], _name[64], _other[64], _temp_tell;

	nfv_replace_quote( name );

	//Seek to key_tell_start
	if( key_tell_start )
		fseek(f, key_tell_start, SEEK_SET);

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		_temp_tell = ftell(f);
		fgets(f, _data, charsmax(_data));

		if( _data[0] == identifier )
		{
			if( found_key )
			{
				break;
			}
			else
			{
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( key, _name ) || equal( key, NFV_WILDCARD ) )
					{
						if( key_len > 0 )
							copy( key_copy, key_len, _name );

						found_key = true;

						//Seek to name_tell_start
						if( name_tell_start )
							fseek(f, name_tell_start, SEEK_SET);

						key_tell_find = _temp_tell;
					}
				}
			}
		}
		else
		{
			if( found_key && parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
			{
				if( equal(_name, name) || equal( name, NFV_WILDCARD ) )
				{
					if( name_len > 0 )
					{
						copy( name_copy, name_len, _name );
						nfv_return_quote( name_copy );
					}

					if( len )
					{
						copy( data, len, _other );
						nfv_return_quote( data );
					}

					name_tell_find = _temp_tell;

					fclose(f);

					return str_to_bool(_other);
				}
			}
		}
	}
	
	fclose(f);
	data[0] = '^0';
	return false;
}

/**
 * Retrieves data as array form in file under key and name.
 *
 * @param filename			The file location to search for the data.
 * @param key				The key within the file to look for. Set to "" for no key. Set to NFV_WILDCARD for any key.
 * @param name				The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data				The array that will contain the data retrieved.
 * @param size				The size of the data array.
 * @param identifier		The character used to identify different keys.
 * @param key_tell_start	Where to start searching for key.
 * @param key_tell_find		Where the key was found.
 * @param name_tell_start	Where to start searching for name.
 * @param name_tell_find	Where the name was found.
 * @param key_copy			The string that will contain the key of the data retrieved. Only used with NFV_WILDCARD for key.
 * @param key_len			If specified, the size of the key found to copy. Only used with NFV_WILDCARD for key.
 * @param name_copy			The string that will contain the name of the data retrieved. Only used with NFV_WILDCARD for name.
 * @param name_len			If specified, the size of the name found to copy. Only used with NFV_WILDCARD for name.
 * @return					Whether or not data was found.
 */
stock nfv_get_array(const filename[], const key[], name[], any:data[], const size, const identifier=';', const key_tell_start=0, &key_tell_find=0, const name_tell_start=0, &name_tell_find=0, key_copy[]="", const key_len=0, name_copy[]="", const name_len=0)
{
	//Haven't found anything yet
	key_tell_find = name_tell_find = -1;

	if( key_tell_start <= -1 || name_tell_start <= -1 || !file_exists(filename) )
		return false;

	new f = fopen(filename, "rt");

	new bool:found_key = false;
	new _data[512], _name[64], _other[64], _temp_tell;

	nfv_replace_quote( name );

	//Seek to key_tell_start
	if( key_tell_start )
		fseek(f, key_tell_start, SEEK_SET);

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		_temp_tell = ftell(f);
		fgets(f, _data, charsmax(_data));

		if( _data[0] == identifier )
		{
			if( found_key )
			{
				break;
			}
			else
			{
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( key, _name ) || equal( key, NFV_WILDCARD ) )
					{
						if( key_len > 0 )
							copy( key_copy, key_len, _name );

						found_key = true;

						//Seek to name_tell_start
						if( name_tell_start )
							fseek(f, name_tell_start, SEEK_SET);

						key_tell_find = _temp_tell;
					}
				}
			}
		}
		else
		{
			if( found_key && parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
			{
				if( equal(_name, name) || equal( name, NFV_WILDCARD ) )
				{
					if( name_len > 0 )
					{
						copy( name_copy, name_len, _name );
						nfv_return_quote( name_copy );
					}

					name_tell_find = _temp_tell;

					fclose(f);

					str_to_array(_other, data, size);

					return true;
				}
			}
		}
	}
	
	fclose(f);
	for( new i; i<size; i++ )
		data[i] = 0;
	return false;
}

/**
 * Retrieves data as vector form in file under key and name.
 *
 * @param filename			The file location to search for the data.
 * @param key				The key within the file to look for. Set to "" for no key. Set to NFV_WILDCARD for any key.
 * @param name				The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data				The vector that will contain the data retrieved.
 * @param identifier		The character used to identify different keys.
 * @param key_tell_start	Where to start searching for key.
 * @param key_tell_find		Where the key was found.
 * @param name_tell_start	Where to start searching for name.
 * @param name_tell_find	Where the name was found.
 * @param key_copy			The string that will contain the key of the data retrieved. Only used with NFV_WILDCARD for key.
 * @param key_len			If specified, the size of the key found to copy. Only used with NFV_WILDCARD for key.
 * @param name_copy			The string that will contain the name of the data retrieved. Only used with NFV_WILDCARD for name.
 * @param name_len			If specified, the size of the name found to copy. Only used with NFV_WILDCARD for name.
 * @return					Whether or not data was found.
 */
stock nfv_get_vec(const filename[], const key[], name[], Float:data[3], const identifier=';', const key_tell_start=0, &key_tell_find=0, const name_tell_start=0, &name_tell_find=0, key_copy[]="", const key_len=0, name_copy[]="", const name_len=0)
{
	//Haven't found anything yet
	key_tell_find = name_tell_find = -1;

	if( key_tell_start <= -1 || name_tell_start <= -1 || !file_exists(filename) )
		return false;

	new f = fopen(filename, "rt");

	new bool:found_key = false;
	new _data[512], _name[64], _other[64], _temp_tell;

	nfv_replace_quote( name );

	//Seek to key_tell_start
	if( key_tell_start )
		fseek(f, key_tell_start, SEEK_SET);

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		_temp_tell = ftell(f);
		fgets(f, _data, charsmax(_data));

		if( _data[0] == identifier )
		{
			if( found_key )
			{
				break;
			}
			else
			{
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( key, _name ) || equal( key, NFV_WILDCARD ) )
					{
						if( key_len > 0 )
							copy( key_copy, key_len, _name );

						found_key = true;

						//Seek to name_tell_start
						if( name_tell_start )
							fseek(f, name_tell_start, SEEK_SET);

						key_tell_find = _temp_tell;
					}
				}
			}
		}
		else
		{
			if( found_key && parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
			{
				if( equal(_name, name) || equal( name, NFV_WILDCARD ) )
				{
					if( name_len > 0 )
					{
						copy( name_copy, name_len, _name );
						nfv_return_quote( name_copy );
					}

					name_tell_find = _temp_tell;

					fclose(f);

					str_to_vector(_other, data);

					return true;
				}
			}
		}
	}
	
	fclose(f);
	for( new i; i<3; i++ )
		data[i] = 0.0;
	return false;
}

/**
 * Retrieves data as cellarray form in file under key and name.
 *
 * @param filename			The file location to search for the data.
 * @param key				The key within the file to look for. Set to "" for no key. Set to NFV_WILDCARD for any key.
 * @param name				The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data				The cell array that will contain the data retrieved.
 * @param identifier		The character used to identify different keys.
 * @param key_tell_start	Where to start searching for key.
 * @param key_tell_find		Where the key was found.
 * @param name_tell_start	Where to start searching for name.
 * @param name_tell_find	Where the name was found.
 * @param key_copy			The string that will contain the key of the data retrieved. Only used with NFV_WILDCARD for key.
 * @param key_len			If specified, the size of the key found to copy. Only used with NFV_WILDCARD for key.
 * @param name_copy			The string that will contain the name of the data retrieved. Only used with NFV_WILDCARD for name.
 * @param name_len			If specified, the size of the name found to copy. Only used with NFV_WILDCARD for name.
 *
 * @note					If an existing cell array is provided, it will push new data to the end of it.
 *
 * @return					The cell array handle. Invalid_Array if no data.
 */
stock Array:nfv_get_cellarray(const filename[], const key[], name[], &Array:data=Invalid_Array, const identifier=';', const key_tell_start=0, &key_tell_find=0, const name_tell_start=0, &name_tell_find=0, key_copy[]="", const key_len=0, name_copy[]="", const name_len=0)
{
	//Haven't found anything yet
	key_tell_find = name_tell_find = -1;

	if( key_tell_start <= -1 || name_tell_start <= -1 || !file_exists(filename) )
		return Invalid_Array;

	new f = fopen(filename, "rt");

	new bool:found_key = false;
	new _data[512], _name[64], _other[64], _temp_tell;

	nfv_replace_quote( name );

	//Seek to key_tell_start
	if( key_tell_start )
		fseek(f, key_tell_start, SEEK_SET);

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		_temp_tell = ftell(f);
		fgets(f, _data, charsmax(_data));

		if( _data[0] == identifier )
		{
			if( found_key )
			{
				break;
			}
			else
			{
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( key, _name ) || equal( key, NFV_WILDCARD ) )
					{
						if( key_len > 0 )
							copy( key_copy, key_len, _name );

						found_key = true;

						//Seek to name_tell_start
						if( name_tell_start )
							fseek(f, name_tell_start, SEEK_SET);

						key_tell_find = _temp_tell;
					}
				}
			}
		}
		else
		{
			if( found_key && parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
			{
				if( equal(_name, name) || equal( name, NFV_WILDCARD ) )
				{
					if( name_len > 0 )
					{
						copy( name_copy, name_len, _name );
						nfv_return_quote( name_copy );
					}

					name_tell_find = _temp_tell;

					fclose(f);

					return str_to_cellarray(_other, data);
				}
			}
		}
	}
	
	fclose(f);
	return Invalid_Array;
}

/**
 * Retrieves data as cellarray string form in file under key and name.
 *
 * @param filename			The file location to search for the data.
 * @param key				The key within the file to look for. Set to "" for no key. Set to NFV_WILDCARD for any key.
 * @param name				The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data				The cell array that will contain the data retrieved.
 * @param identifier		The character used to identify different keys.
 * @param key_tell_start	Where to start searching for key.
 * @param key_tell_find		Where the key was found.
 * @param name_tell_start	Where to start searching for name.
 * @param name_tell_find	Where the name was found.
 * @param key_copy			The string that will contain the key of the data retrieved. Only used with NFV_WILDCARD for key.
 * @param key_len			If specified, the size of the key found to copy. Only used with NFV_WILDCARD for key.
 * @param name_copy			The string that will contain the name of the data retrieved. Only used with NFV_WILDCARD for name.
 * @param name_len			If specified, the size of the name found to copy. Only used with NFV_WILDCARD for name.
 *
 * @note					If an existing cell array is provided, it will push new strings to the end of it.
 *
 * @return					The cell array handle. Invalid_Array if no data.
 */
stock Array:nfv_get_cellarray2(const filename[], const key[], name[], &Array:data=Invalid_Array, const identifier=';', const key_tell_start=0, &key_tell_find=0, const name_tell_start=0, &name_tell_find=0, key_copy[]="", const key_len=0, name_copy[]="", const name_len=0)
{
	//Haven't found anything yet
	key_tell_find = name_tell_find = -1;

	if( key_tell_start <= -1 || name_tell_start <= -1 || !file_exists(filename) )
		return Invalid_Array;

	new f = fopen(filename, "rt");

	new bool:found_key = false;
	new _data[512], _name[64], _other[64], _temp_tell;

	nfv_replace_quote( name );

	//Seek to key_tell_start
	if( key_tell_start )
		fseek(f, key_tell_start, SEEK_SET);

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		_temp_tell = ftell(f);
		fgets(f, _data, charsmax(_data));

		if( _data[0] == identifier )
		{
			if( found_key )
			{
				break;
			}
			else
			{
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( key, _name ) || equal( key, NFV_WILDCARD ) )
					{
						if( key_len > 0 )
							copy( key_copy, key_len, _name );

						found_key = true;

						//Seek to name_tell_start
						if( name_tell_start )
							fseek(f, name_tell_start, SEEK_SET);

						key_tell_find = _temp_tell;
					}
				}
			}
		}
		else
		{
			if( found_key && parse(_data, _name, charsmax(_name), _other, charsmax(_other)) )
			{
				if( equal(_name, name) || equal( name, NFV_WILDCARD ) )
				{
					if( name_len > 0 )
					{
						copy( name_copy, name_len, _name );
						nfv_return_quote( name_copy );
					}

					name_tell_find = _temp_tell;

					fclose(f);

					return str_to_cellarray2(_other, data);
				}
			}
		}
	}
	
	fclose(f);
	return Invalid_Array;
}

/**
 * Removes data in file under key and name.
 *
 * @param filename		The file location to search for the data.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param name			The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data			The string that will contain the data removed.
 * @param len			The size of the data string.
 * @param take_times	How many times to take out of the file. Set to NFV_TAKEALL for all.
 * @param identifier	The character used to identify different keys.
 * @param name_copy		The string that will contain the name of the data retrieved. Only used with NFV_WILDCARD for name.
 * @param name_len		If specified, the size of the name found to copy. Only used with NFV_WILDCARD for name.
 * @return				How many datas were removed.
 */
stock nfv_take_data(const filename[], const key[], name[], data[]="", len=0, const take_times=1, const identifier=';', name_copy[]="", const name_len=0)
{
	if( !file_exists(filename) )
		return 0;

	new g = fopen(temp_file_name, "wt");
	new f = fopen(filename, "rt");

	// lets put a time stamp
	fprintf(g, "^"TimeStamp^" ^"%d^"^n", get_systime() );

	new _data[512], _name[64], _other[3];

	nfv_replace_quote( name );

	new took_data, bool:found_key = false, bool:found_time = false;

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	while( !feof(f) )
	{
		fgets(f, _data, charsmax(_data));

		if( !found_time )
		{
			if( equal(_data, "^"TimeStamp^"", 11) )
			{
				found_time = true;
				continue;
			}
		}
		if( _data[0] == identifier )
		{
			//if found key and wrote data continue and copy to g
			//    if didnt copy data, write data before copying to g
			if( found_key )
			{
				//if we took the data, we still need to copy all the data
				if( !took_data )
				{
					break;
				}
			}
			//else check if correct key, copy to g
			else
			{
				//Make sure we get something parsed
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( _name, key ) )
					{
						found_key = true;
						//If taking all, don't put the key in
						if( take_times == NFV_TAKEALL )
							continue;
					}
				}
			}

			fputs(g, _data);
		}
		else
		{
			//only need to check the data to take if we havent taken anything
			if( found_key && ( took_data < take_times || take_times == NFV_TAKEALL ) )
			{

				//Make sure we get something parsed
				if( parse(_data, _name, charsmax(_name), data, len) )
				{
					//if name matches, save data, skip copy
					if( equal( _name, name ) || equal( name, NFV_WILDCARD ) )
					{
						if( name_len > 0 )
						{
							copy( name_copy, name_len, _name );
							nfv_return_quote( name_copy );
						}

						nfv_return_quote( data );
						took_data++;

						continue;
					}
				}
			}

			//else copy to g
			fputs(g, _data);
		}
	}

	fclose(g);
	fclose(f);

	if( took_data )
	{
		delete_file(filename);
		while( !rename_file(temp_file_name, filename, 1) ) { }
	}
	else
	{
		delete_file(temp_file_name);
		data[0] = '^0';
	}

	return took_data;
}

/**
 * Retrieves data in file under key and name with reference to line numbers.
 *
 * @param filename			The file location to search for the data.
 * @param key				The key within the file to look for. Set to "" for no key.
 * @param name				The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data				The string that will contain the data retrieved.
 * @param len				The size of the data string.
 * @param identifier		The character used to identify different keys.
 * @param key_line_start	Where to start searching for key.
 * @param key_line_find		Where the key was found.
 * @param name_line_start	Where to start searching for name.
 * @param name_line_find	Where the name was found.
 * @param name_copy			The string that will contain the name of the data retrieved. Only used with NFV_WILDCARD for name.
 * @param name_len			If specified, the size of the name found to copy. Only used with NFV_WILDCARD for name.
 * @return					1 if successful, 0 on failure.
 */
stock nfv_get_linedata(const filename[], const key[], name[], data[]="", len=0, const identifier=';', const key_line_start=0, &key_line_find=0, const name_line_start=0, &name_line_find=0, name_copy[], const name_len=0)
{
	if( key_line_start <= -1 || name_line_start <= -1 || !file_exists(filename) )
		return 0;

	new f = fopen(filename, "rt");

	new bool:found_key = false;
	new _data[512], _name[64], _other[2], _line = -1;

	//If using a blank key, detect it already
	if( !key[0]  )
		found_key = true;

	//Haven't found anything yet
	key_line_find = name_line_find = -1;

	while( !feof(f) )
	{
		fgets(f, _data, charsmax(_data));
		_line++;

		if( _data[0] == identifier && _line > key_line_start )
		{
			if( found_key )
			{
				break;
			}
			else
			{
				//Make sure we get something parsed
				if( parse(_data[1], _name, charsmax(_name), _other, charsmax(_other)) )
				{
					if( equal( key, _name ) )
					{
						found_key = true;

						key_line_find = _line;
					}
				}
			}
		}
		else if( _line > name_line_start )
		{
			//Make sure we get something parsed
			if( parse(_data, _name, charsmax(_name), data, len) )
			{
				if( found_key )
				{
					if( equal(_name, name) || equal( name, NFV_WILDCARD ) )
					{
						if( name_len > 0 )
						{
							copy( name_copy, name_len, _name );
							nfv_return_quote( name_copy );
						}

						name_line_find = _line;
						nfv_return_quote( data );

						fclose(f);
						return 1;
					}
				}
			}
		}
	}
	
	fclose(f);
	data[0] = '^0';
	return 0;
}

/**
 * Removes data from all files in the NFVault folder.
 *
 * @param key			The key within the file to remove data.
 * @param name			The name within the key to remove data. Set to NFV_WILDCARD to prune all names.
 * @param start			Checks if last TimeStamp is after this UnixTime. Set to -1 to prune all.
 * @param end			Checks if last TimeStamp is before this UnixTime. Set to -1 to prune all.
 * @param identifier	The character used to identify different keys.
 * @noreturn
 */
stock nfv_prune(const key[], name[], const start=-1, const end=-1, const identifier=';')
{
	new directory[128], filename[128], fullfile[128];

	get_localinfo( "amxx_datadir", directory, charsmax(directory) );
	add( directory, charsmax(directory), "/nfvault/" );

	new dir = open_dir( directory, filename, charsmax(filename) );

	if( !dir )
		return;

	new bool:prune_all;
	if( start == -1 && end == -1 )
		prune_all = true;

	do
	{
		formatex( fullfile, charsmax(fullfile), "%s%s", directory, filename );
		if( !file_exists(fullfile) )
			break;

		if( prune_all )
		{
			while( nfv_take_data( filename, key, name, _, _, NFV_TAKEALL, identifier ) ) {}
		}
		else if( start < nfv_get_num( filename, "", "TimeStamp" ) < end )
		{
			while( nfv_take_data( filename, key, name, _, _, NFV_TAKEALL, identifier ) ) {}
		}
	}
	while( next_file(dir, filename, charsmax(filename)) )

	close_dir(dir);
}

/**
 * Updates a file's TimeStamp
 *
 * @param filename		The file to be touched.
 * @param new_time		Timestamp to set for the file in Unix time. Set to -1 for current time.
 * @return				1 if successful.
 */
stock nfv_touch(const filename[], const new_time=-1)
{
	new g = fopen(temp_file_name, "wt");
	new f = fopen(filename, "rt");

	// lets update the time stamp
	if( new_time == -1 )
		fprintf(g, "^"TimeStamp^" ^"%d^"^n", get_systime() );
	else
		fprintf(g, "^"TimeStamp^" ^"%d^"^n", new_time );

	new _data[512];

	new bool:found_time = false;

	while( !feof(f) )
	{
		fgets(f, _data, charsmax(_data));

		if( !found_time )
		{
			if( equal(_data, "^"TimeStamp^"", 11) )
			{
				found_time = true;
				continue;
			}
		}
		fputs(g, _data);
	}

	fclose(g);
	fclose(f);

	delete_file(filename);

	while( !rename_file(temp_file_name, filename, 1) ) { }

	return 1;
}

/**
 * Finds a player's unique save key
 *
 * @param id			The index of the client.
 * @return				Returns string containing the key.
 */
stock PlayerSaveKey(id)
{
	new player_key[35];

	#if NFV_SAVETYPE == 0
	if( is_user_bot(id) )
	{
		new botname[32];
		get_user_name(id,botname,31);

		//Get Rid of BOT Tag

		//PODBot
		replace(botname,31,"[POD]","");
		replace(botname,31,"[P*D]","");
		replace(botname,31,"[P0D]","");

		//CZ Bots
		replace(botname,31,"[BOT] ","");

		//Attempt to get rid of the skill tag so we save with bots true name
		new lastchar = strlen(botname) - 1;
		if( equal(botname[lastchar],")",1) )
		{
			for( new x = lastchar - 1; x > 0; x-- )
			{
				if ( equal(botname[x],"(",1) )
				{
					botname[x - 1] = 0;
					break;
				}
				if ( !isdigit(botname[x]) )
					break;
			}
		}
		if( strlen(botname) > 0 )
			formatex( player_key, 34, "[BOT]%s", botname );
	}
	//Hack for STEAM's retardedness with listen servers
	else if( !is_dedicated_server() && id == 1 )
		copy( player_key, 34, "loopback" );
	else
	{
		static sv_lan;
		if( !sv_lan )
			sv_lan = get_cvar_pointer("sv_lan");
		if( get_pcvar_num(sv_lan) == 1 )
		{
			get_user_ip( id, player_key, 34, 1 );		// by ip without port
		}
		else
		{
			get_user_authid( id, player_key, 34 );		// by steamid
			if( equali(player_key,"STEAM_ID_LAN") || equali(player_key,"4294967295") )
				get_user_ip( id, player_key, 34, 1 );		// by ip without port
		}
	}
	#else
	get_user_name( id, player_key, 34 );
	#endif

	if( strlen(player_key) > 0 )
	{
		nfv_string_clean(player_key, player_key, 34);
	}

	//Check to make sure we got something useable
	if( equali(player_key, "STEAM_ID_PENDING") )
	{
		player_key[0] = '^0';
	}

	return player_key;
}

/**
 * Cleans a filename of invalid characters
 *
 * @param string		The string to clean.
 * @param output		The cleaned string.
 * @param len			The length of output to fill.
 * @return				Returns 1 on success.
 */
stock nfv_string_clean( const string[], output[], len )
{
	new i, j;
	while( i<len && j<len )
	{
		switch( string[i] )
		{
			case '/', '\', '*', ':', '?', '"', '<', '>', '|':
			{
				i++;
			}
			case ' ':
			{
				output[j++] = '_';
				i++;
			}
			case '^0':
			{
				output[j++] = string[i++];
				break;
			}
			default:
			{
				output[j++] = string[i++];
			}
		}
	}
	return 1;
}

/**
 * Replaces quotation marks with the replacement character.
 *
 * @param string		The string to clean.
 * @noreturn
 */
stock nfv_replace_quote( string[] )
{
	for( new i; string[i] != '^0'; i++ )
	{
		if( string[i] == quote_char )
			string[i] = quote_replace_char;
	}
}

/**
 * Replaces replacement characters with a quotation mark.
 *
 * @param string		The string to clean.
 * @noreturn
 */
stock nfv_return_quote( string[] )
{
	for( new i; string[i] != '^0'; i++ )
	{
		if( string[i] == quote_replace_char )
			string[i] = quote_char;
	}
}

/**
 * Returns a file in the nfvault folder
 *
 * @param filename		The filename and extension of the file.
 * @param filepath		The entire path, filename and extension of the file is returned if size is > 0.
 * @param size			The size to fill filepath with. Set to 0 to ignore.
 * @return				Returns string containing the nfvault file.
 */
stock nfv_file(const filename[], filepath[]="", const size=0)
{
	new file[128], _filename[128];
	if( !DataDir[0] )
	{
		get_localinfo( "amxx_datadir", DataDir, charsmax(DataDir) );
		add( DataDir, charsmax(DataDir), "/nfvault" );
		if( !dir_exists(DataDir) )
			mkdir(DataDir);
	}
	nfv_string_clean( filename, _filename, 127 );
	formatex( file, charsmax(file), "%s/%s", DataDir, _filename );

	if( size )
		copy( filepath, size, file );

	return file;
}
/**
 * Creates a file with a TimeStamp.
 *
 * @param filename		The file location for the data.
 * @param new_time		Timestamp to set for the file in Unix time. Set to -1 for current time.
 * @return				1 if created, -1 on existing, 0 on failure.
 */
stock nfv_create_file(const filename[], const new_time=-1)
{
	if( file_exists( filename ) )
		return -1;

	new f = fopen(filename, "wt");

	// lets put a time stamp
	if( new_time == -1 )
		fprintf(f, "^"TimeStamp^" ^"%d^"^n", get_systime() );
	else
		fprintf(f, "^"TimeStamp^" ^"%d^"^n", new_time );

	fclose(f);

	return 1;
}

/**
 * Finds a player's unique save file
 *
 * @param id			The index of the client.
 * @return				Returns string containing the file.
 */
stock nfv_player_file(const id)
{
	new file[128];
	if( !DataDir[0] )
	{
		get_localinfo( "amxx_datadir", DataDir, charsmax(DataDir) );
		add( DataDir, charsmax(DataDir), "/nfvault" );
		if( !dir_exists(DataDir) )
			mkdir(DataDir);
	}
	formatex( file, charsmax(file), "%s/%s.txt", DataDir, PlayerSaveKey(id) );
	return file;
}

/**
 * Sets data for a player under key and name.
 *
 * @param id			The index of the client.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param name			The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data			The data to write.
 * @param nfv_prop		Properties to apply to the saved data in a bitsum.
 * @param identifier	The character used to identify different keys.
 * @return				1 if successful.
 */
stock player_set_data(const id, const key[], name[], data[], const NFV_PROP:nfv_prop=NFV_OVERWRITE, const identifier=';')
	return nfv_set_data(nfv_player_file(id), key, name, data, nfv_prop, identifier);

/**
 * Sets number for a player under key and name.
 *
 * @param id			The index of the client.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param name			The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data			The number to write.
 * @param nfv_prop		Properties to apply to the saved data in a bitsum.
 * @param identifier	The character used to identify different keys.
 * @return				1 if successful.
 */
stock player_set_num(const id, const key[], name[], const data, const NFV_PROP:nfv_prop=NFV_OVERWRITE, const identifier=';')
	return nfv_set_num(nfv_player_file(id), key, name, data, nfv_prop, identifier);

/**
 * Adds number for a player under key and name.
 *
 * @param id			The index of the client.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param name			The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data			The number to write.
 * @param nfv_prop		Properties to apply to the saved data in a bitsum.
 * @param identifier	The character used to identify different keys.
 * @return				1 if successful.
 */
stock player_add_num(const id, const key[], name[], const data, const NFV_PROP:nfv_prop=NFV_OVERWRITE, const identifier=';')
	return nfv_add_num(nfv_player_file(id), key, name, data, nfv_prop, identifier);

/**
 * Sets float for a player under key and name.
 *
 * @param id			The index of the client.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param name			The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data			The floating point to write.
 * @param nfv_prop		Properties to apply to the saved data in a bitsum.
 * @param identifier	The character used to identify different keys.
 * @return				1 if successful.
 */
stock player_set_float(const id, const key[], name[], const Float:data, const NFV_PROP:nfv_prop=NFV_OVERWRITE, const identifier=';')
	return nfv_set_float(nfv_player_file(id), key, name, data, nfv_prop, identifier);

/**
 * Adds a float for a player under key and name.
 *
 * @param id			The index of the client.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param name			The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data			The floating point to write.
 * @param nfv_prop		Properties to apply to the saved data in a bitsum.
 * @param identifier	The character used to identify different keys.
 * @return				1 if successful.
 */
stock player_add_float(const id, const key[], name[], const Float:data, const NFV_PROP:nfv_prop=NFV_OVERWRITE, const identifier=';')
	return nfv_add_float(nfv_player_file(id), key, name, data, nfv_prop, identifier);

/**
 * Retrieves data for a player under key and name.
 *
 * @param id			The index of the client.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param name			The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data			The string that will contain the data retrieved.
 * @param len			The size of the data string.
 * @param identifier	The character used to identify different keys.
 * @return				1 if successful.
 */
stock player_get_data(const id, const key[], name[], data[]="", len=0, const identifier=';')
	return nfv_get_data(nfv_player_file(id), key, name, data, len, identifier);

/**
 * Retrieves data as a number for a player under key and name.
 *
 * @param id				The index of the client.
 * @param key				The key within the file to look for. Set to "" for no key.
 * @param name				The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param identifier		The character used to identify different keys.
 * @return					Numeric value of data found. 0 if no data.
 */
stock player_get_num(const id, const key[], name[], const identifier=';')
	return nfv_get_num(nfv_player_file(id), key, name, identifier);

/**
 * Retrieves data as a float for a player under key and name.
 *
 * @param id				The index of the client.
 * @param key				The key within the file to look for. Set to "" for no key.
 * @param name				The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param identifier		The character used to identify different keys.
 * @return					Floating point value of data found. 0.0 if no data.
 */
stock Float:player_get_float(const id, const key[], name[], const identifier=';')
	return nfv_get_float(nfv_player_file(id), key, name, identifier);

/**
 * Removes data for a player under key and name.
 *
 * @param id			The index of the client.
 * @param key			The key within the file to look for. Set to "" for no key.
 * @param name			The name under key to look for. Set to NFV_WILDCARD for any name.
 * @param data			The string that will contain the data removed.
 * @param len			The size of the data string.
 * @param take_times	How many times to take out of the file. Set to NFV_TAKEALL for all.
 * @param identifier	The character used to identify different keys.
 * @return				How many datas were removed.
 */
stock player_take_data(const id, const key[], name[], data[]="", len=0, const take_times=1, const identifier=';')
	return nfv_take_data(nfv_player_file(id), key, name, data, len, take_times, identifier);

/**
 * Switches two key's in a file.
 *
 * @param filename		The file location for the data.
 * @param key1			The first key to switch.
 * @param key2			The second key to switch.
 * @param identifier	The character used to identify different keys.
 *
 * @note				Data under key1 will switch to key2. Data under key2 will switch to key1.
 *
 * @return				1 if successful.
 */
stock nfv_switch_keys(const filename[], const key1[], const key2[], const identifier=';')
{
	new g = fopen(temp_file_name, "wt");
	new f = fopen(filename, "rt");

	// lets put a time stamp
	fprintf(g, "^"TimeStamp^" ^"%d^"^n", get_systime() );

	new _data[512], _key[64], _other[3];

	new bool:found_time = false;

	while( !feof(f) )
	{
		fgets(f, _data, charsmax(_data));

		if( !found_time )
		{
			if( equal(_data, "^"TimeStamp^"", 11) )
			{
				found_time = true;
				continue;
			}
		}
		if( _data[0] == identifier )
		{
			//Make sure we get something parsed
			if( parse(_data[1], _key, charsmax(_key), _other, charsmax(_other)) )
			{
				if( equal( _key, key1 ) )
				{
					fprintf(g, "%c%s^n", identifier, key2);
					continue;
				}
				if( equal( _key, key2 ) )
				{
					fprintf(g, "%c%s^n", identifier, key1);
					continue;
				}
			}
		}
		fputs(g, _data);
	}

	fclose(g);
	fclose(f);

	delete_file(filename);

	while( !rename_file(temp_file_name, filename, 1) ) { }

	return 1;
}

/**
 * Changes data from one key to another in a file.
 *
 * @param filename		The file location for the data.
 * @param key1			The key to change from. 
 * @param key2			The key to change to.
 * @param nfv_prop		Properties to apply to the saved data in a bitsum.
 * @param identifier	The character used to identify different keys.
 *
 * @note				Data under key1 will change to key2.
 *
 * @return				Returns how many keys were switched.
 */
stock nfv_change_key(const filename[], const key1[], const key2[], const NFV_PROP:nfv_prop=NFV_OVERWRITE, const identifier=';')
{
	new name[32], data[128], i;

	while( nfv_take_data( filename, key1, NFV_WILDCARD, data, 127, 1, identifier, name, 31) )
	{
		nfv_set_data( filename, key2, name, data, nfv_prop, identifier);
		i++;
	}

	return i;
}

/**
 * Removes all data under a key in a file.
 *
 * @param filename		The file location for the data.
 * @param key			The key to remove from. 
 * @param identifier	The character used to identify different keys.
 * @return				Returns how many datas were removed with the key.
 */
stock nfv_remove_key(const filename[], const key[], const identifier=';')
{
	return nfv_take_data( filename, key, NFV_WILDCARD, _, _, NFV_TAKEALL, identifier );
}

/**
 * Returns whether a string should be true or false
 *
 * @param string		The string to look at. 
 * @return				Returns true or false.
 */
stock bool:str_to_bool( const string[] )
{
	//Numeric values are true
	if( str_to_float( string ) != 0.0 )
		return true;

	//False, No, 0, "" are false
	//0.0 will be detected as 0
	switch( string[0] )
	{
		case 'F','f','N','n','0','^0':
			return false;
	}

	//Everything else is true
	return true;
}

/**
 * Fills an array with numbers from a string
 *
 * @param string		The string to look at.
 * @param array			The array to fill.
 * @param size			The size of the array.
 * @noreturn
 */
stock str_to_array( const string[], array[], const size )
{
	new left[32], right[128], i;
	copy(right, charsmax(right), string);

	while( i<size )
	{
		strtok(right, left, charsmax(left), right, charsmax(right), ',', 1);
		array[i++] = str_to_num( left );
	}
}

/**
 * Fills a vector with numbers from a string
 *
 * @param string		The string to look at.
 * @param vec			The vector to fill.
 * @noreturn
 */
stock str_to_vector( const string[], Float:vec[3] )
{
	new left[32], right[128], i;
	copy(right, charsmax(right), string);

	while( i<3 )
	{
		strtok(right, left, charsmax(left), right, charsmax(right), ',', 1);
		array[i++] = str_to_float( left );
	}
}

/**
 * Pushes cells into a cell array with numbers from a string
 *
 * @param string		The string to look at.
 * @param array			The cell array to push into. If none provided, it creates one.
 * @return				Returns the cell array handle.
 */
stock Array:str_to_cellarray( const string[], &Array:array=Invalid_Array )
{
	if( array == Invalid_Array )
		array = ArrayCreate(1,1);

	new left[32], right[128];
	copy(right, charsmax(right), string);

	while( strtok(right, left, charsmax(left), right, charsmax(right), ',', 1) )
	{
		ArrayPushCell(array, str_to_num( left ) );
	}

	return array;
}

/**
 * Pushes strings into a cell array with substrings from a string
 *
 * @param string		The string to look at.
 * @param array			The cell array to push into. If none provided, it creates one.
 * @return				Returns the cell array handle.
 */
stock Array:str_to_cellarray2( const string[], &Array:array=Invalid_Array )
{
	if( array == Invalid_Array )
		array = ArrayCreate(32,1);

	new left[128], right[256];
	copy(right, charsmax(right), string);
	replace_all( right, charsmax(right), ",", " " );

	while( strbreak(right, left, charsmax(left), right, charsmax(right)) )
	{
		nfv_return_quote( left );
		ArrayPushString(array, left );
	}

	return array;
}

