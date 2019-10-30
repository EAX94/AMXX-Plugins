/*
	Trie (HashX) abstraction layer
	by Zefir<zefir-cs@ukr.net>
	developed for Cerberus project
	http://cerberus.cstrike.in.ua/
	5 december 2009 (c) Zefir

	HashXKeyType return 
		HASH_X_TYPE_STRING for string
		HASH_X_TYPE_CELL for cell
		other value > 0 is size of array


	'L' - array of keys for enumerate and traverse
	'S' - position keys in array 'L'
	'T' - type of cell
*/

#if defined _hashX_included
  #endinput
#endif
#define _hashX_included

#include <hash>

// Size of key in hash
#define		HASH_KEY_SIZE		64

// Types of item
// if Type >= HASH_X_TYPE_ARRAY, item ined Array with this size
#define		HASH_X_TYPE_NONE	-3
#define		HASH_X_TYPE_STRING	-2
#define		HASH_X_TYPE_CELL	-1
#define		HASH_X_TYPE_ARRAY	0


#define HashX						Hash
#define HashXCreate()				HashCreate()

#define HashXKeyExists(%1,%2)		HashKeyExists(%1, %2)


#define HashXGetCell(%1,%2,%3)		HashGetCell(%1, %2, %3)
#define HashXGetString(%1,%2,%3)	HashGetString(%1, %2, %3)
#define HashXGetArray(%1,%2,%3,%4)	HashGetArray(%1, %2, %3, %4)

stock HashXClear(HashX:handle) {
	new Array:arr, Trie:hash, Trie:types;
	if(HashGetCell(handle, {10, 30, 'L', 0}, arr) && arr)
		ArrayClear(arr);
	if(HashGetCell(handle, {10, 30, 'S', 0}, hash) && hash)
		TrieClear(hash);
	if(HashGetCell(handle, {10, 30, 'T', 0}, types) && types)
		TrieClear(types);
	new rtv = HashClear(handle);
	HashSetCell(handle, {10, 30, 'L', 0}, arr);
	HashSetCell(handle, {10, 30, 'S', 0}, hash);
	HashSetCell(handle, {10, 30, 'T', 0}, types);
	return rtv;
}

stock HashXDestroy(&HashX:handle) {
	new Array:arr, Trie:hash;
	if(HashGetCell(handle, {10, 30, 'L', 0}, arr))
		ArrayDestroy(arr);
	if(HashGetCell(handle, {10, 30, 'S', 0}, hash))
		TrieDestroy(hash);
	if(HashGetCell(handle, {10, 30, 'T', 0}, hash))
		TrieDestroy(hash);

	return HashDestroy(handle);
}

stock bool:HashXDeleteKey(HashX:handle, const key[]) {

	new Array:arr, Trie:hash, pos;
	if(HashGetCell(handle, {10, 30, 'S', 0}, hash)
	&& HashGetCell(handle, {10, 30, 'L', 0}, arr)
	&& TrieGetCell(hash, key, pos))
	{
		ArrayDeleteItem(arr, pos);
		TrieDeleteKey(hash, key);

		new key[HASH_KEY_SIZE], size = ArraySize(arr);
		for(new i = pos; i < size; i++) {
			ArrayGetString(arr, i, key, charsmax(key));
			TrieSetCell(hash, key, i);
		}
	}
	if(HashGetCell(handle, {10, 30, 'T', 0}, hash))
		TrieDeleteKey(hash, key);

	return HashDeleteKey(handle, key);
}

stock __HashXSetKey(HashX:handle, const key[], type) {
	new Array:arr, Trie:hash, Trie:types, pos;
	if (!HashGetCell(handle, {10, 30, 'S', 0}, hash)) {
		hash = TrieCreate();
		HashSetCell(handle, {10, 30, 'S', 0}, hash);
	}

	if (!HashGetCell(handle, {10, 30, 'T', 0}, types)) {
		types = TrieCreate();
		HashSetCell(handle, {10, 30, 'T', 0}, types);
	}

	if (!HashGetCell(handle, {10, 30, 'L', 0}, arr)) {
		arr = ArrayCreate(HASH_KEY_SIZE);
		HashSetCell(handle, {10, 30, 'L', 0}, arr);
	}


	TrieSetCell(types, key, type);
	if (!TrieKeyExists(hash, key)) {
		TrieSetCell(hash, key, ArraySize(arr));
		ArrayPushString(arr, key);
	} else {
		TrieGetCell(hash, key, pos);
		ArraySetString(arr, pos, key);
	}

}

stock HashXSetCell(HashX:handle, const key[], any:value) {
	__HashXSetKey(handle, key, HASH_X_TYPE_CELL);
	return HashSetCell(handle, key, value);
}

stock HashXSetString(HashX:handle, const key[], const value[]) {
	__HashXSetKey(handle, key, HASH_X_TYPE_STRING);
	return HashSetString(handle, key, value);
}

stock HashXSetArray(HashX:handle, const key[], const any:buffer[], size) {
	__HashXSetKey(handle, key, size);
	return HashSetArray(handle, key, buffer, size);
}

stock HashXKeyType(HashX:handle, key[]) {
	new Trie:types, type;
	if(HashGetCell(handle, {10, 30, 'T', 0}, types) && TrieGetCell(types, key, type))
		return type;
	return HASH_X_TYPE_NONE;
}

/*
	callback function get 2 or 3 parameters
	1 - HashX handle
	2 - key
	3 - type if call HashXForEach with  hashx_types > 0

	example:

		new HaxhX:trie_cells

		my_func(id, key[]) {
			new value
			HashXGetCell(trie_cells, key, value)
			server_print("Key: %s, Value: %s", key, value)
		}

		HashXForEach(trie_cells, "my_func")

	or

		new HaxhX:trie

		my_func(id, key[], type) {
			new value, string[512], Array:arr
			switch (type) {
				case HASH_X_TYPE_NONE: {
					server_print("Key: %s is EMPTY", key)
				}
				case HASH_X_TYPE_CELL: {
					HashXGetCell(trie, key, value)
					server_print("Key: %s, Value: %d", key, value)
				}
				case HASH_X_TYPE_STRING: {
					HashXGetString(trie, key, string)
					server_print("Key: %s, Value: %s", key, string)
				}
				default: {
					HashXGetArray(trie, key, arr)
					server_print("Key: %s, ArraySize: %d", key, type)
				}
			}
		}

		HashXForEach(0, "my_func", 1)
*/

stock HashXForEach({HashX,_}:id, HashX:handle, func[], hashx_types = 0) {
	new Array:arr, arr_size = 0, key[HASH_KEY_SIZE];
	new Trie:types, type;
	new func_id = get_func_id(func);

	if (hashx_types)
		HashGetCell(handle, {10, 30, 'T', 0}, types);

	if (func_id > -1 && HashGetCell(handle, {10, 30, 'L', 0}, arr) && arr && (arr_size = ArraySize(arr))) {
		for (new i = 0; i < arr_size; i++) {
			ArrayGetString(arr, i, key, charsmax(key));
			if (callfunc_begin_i(func_id) > -1) {
				callfunc_push_int(int:id);
				callfunc_push_str(key);
				if (hashx_types) {
					TrieGetCell(types, key, type);
					callfunc_push_int(type);
				}
				if (callfunc_end()) break;
			}
		}
	}
}

stock Array:HashXGetKeys(HashX:handle) {
	new Array:arr, Array:new_arr, arr_size, key[HASH_KEY_SIZE], i;
	if (HashGetCell(handle, {10, 30, 'L', 0}, arr) && arr && (arr_size = ArraySize(arr))) {
		new_arr = ArrayCreate(HASH_KEY_SIZE, arr_size);
		for (i = 0; i < arr_size; i++) {
			ArrayGetString(arr, i, key, charsmax(key));
			ArrayPushString(new_arr, key);
		}
	} else
		new_arr = ArrayCreate(HASH_KEY_SIZE);

	return new_arr;
}

stock HashXSize(HashX:handle) {
	new Array:arr;
	if (HashGetCell(handle, {10, 30, 'L', 0}, arr))
		return ArraySize(arr)
}