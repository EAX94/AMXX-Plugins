/*
	Trie (Hash) abstraction layer
	by Zefir<zefir-cs@ukr.net>
	developed for Cerberus project
	http://cerberus.cstrike.in.ua/
	12 jule 2009 (c) Zefir

	Big tnx Exolent :)
*/

#if defined _hash_included
  #endinput
#endif
#define _hash_included



// Default, builtin variant
//#define HASH_NATIVE

#if !defined HASH_NATIVE
	#define HASH_EMULATE
#endif


#if defined HASH_NATIVE
	#define Hash						Trie
	#define HashCreate()				TrieCreate()
	#define HashClear(%1)				TrieClear(%1)
	#define HashDestroy(%1)				TrieDestroy(%1)

	#define HashKeyExists(%1,%2)		TrieKeyExists(%1, %2)
	#define HashDeleteKey(%1,%2)		TrieDeleteKey(%1, %2)

	#define HashSetCell(%1,%2,%3)		TrieSetCell(%1, %2, %3)
	#define HashSetString(%1,%2,%3)		TrieSetString(%1, %2, %3)
	#define HashSetArray(%1,%2,%3,%4)	TrieSetArray(%1, %2, %3, %4)

	#define HashGetCell(%1,%2,%3)		TrieGetCell(%1, %2, %3)
	#define HashGetString(%1,%2,%3,%4)	TrieGetString(%1, %2, %3, %4)
	#define HashGetArray(%1,%2,%3,%4)	TrieGetArray(%1, %2, %3, %4)
#endif

#if defined HASH_EMULATE 
	#define Hash						Trie
	#define HashCreate()				TrieCreate()

	#define HashKeyExists(%1,%2)		TrieKeyExists(%1, %2)

	#define HashSetCell(%1,%2,%3)		TrieSetCell(%1, %2, %3)
	#define HashSetString(%1,%2,%3)		TrieSetString(%1, %2, %3)

	#define HashGetCell(%1,%2,%3)		TrieGetCell(%1, %2, %3)
	#define HashGetString(%1,%2,%3,%4)	TrieGetString(%1, %2, %3, %4)

stock HashClear(Hash:handle) {
	__HashDeleteAllKeys(handle)

	return TrieClear(handle)
}

stock HashDestroy(&Hash:handle) {
	__HashDeleteAllKeys(handle)

	return TrieDestroy(handle)
}

stock __HashDeleteAllKeys(Hash:handle) {
	if (!handle) return

	new Array:keys, Trie:pos
	if(TrieGetCell(handle, {10, 30, 'k', 0}, keys) && TrieGetCell(handle, {10, 30, 'p', 0}, pos)) {
		TrieDestroy(pos)

		new array_key[64], size = ArraySize(keys), Array:arr
		for(new i = 0; i < size; i++) {
			ArrayGetString(keys, i, array_key, charsmax(array_key))
			TrieGetCell(handle, array_key, arr)
			ArrayDestroy(arr)
		}

		ArrayDestroy(keys)
	}
}

stock bool:HashDeleteKey(Hash:handle, const key[]) {
	if(!handle || !TrieKeyExists(handle, key))
		return false

	new Array:keys, Trie:pos, index
	if(TrieGetCell(handle, {10, 30, 'k', 0}, keys)
	&& TrieGetCell(handle, {10, 30, 'p', 0}, pos)
	&& TrieGetCell(pos, key, index))
	{

		ArrayDeleteItem(keys, index)

		new array_key[64], size = ArraySize(keys)
		for(new i = index; i < size; i++) {
			ArrayGetString(keys, i, array_key, charsmax(array_key))
			TrieSetCell(pos, array_key, i)
		}

		new Array:arr
		TrieGetCell(handle, key, arr)
		ArrayDestroy(arr)
	}
	return TrieDeleteKey(handle, key)
}

stock HashSetArray(Hash:handle, const key[], const any:buffer[], size) {
	if (!handle) return false

	new Array:arr
	if (!TrieGetCell(handle, key, arr)) {
		arr = ArrayCreate(size, 1)
		ArrayPushArray(arr, buffer)

		new Array:keys, Trie:pos
		if(!TrieGetCell(handle, {10, 30, 'k', 0}, keys)) {
			keys = ArrayCreate(64)
			TrieSetCell(handle, {10, 30, 'k', 0}, keys)
		}
		if(!TrieGetCell(handle, {10, 30, 'p', 0}, pos)) {
			pos = TrieCreate()
			TrieSetCell(handle, {10, 30, 'p', 0}, pos)
		}

		new size = ArraySize(keys)
		ArrayPushString(keys, key)
		TrieSetCell(pos, key, size)
	} else
		ArraySetArray(arr, 0, buffer)

	return TrieSetCell(handle, key, arr)
}

stock bool:HashGetArray(Hash:handle, const key[], any:output[], outputsize) { 
	outputsize++
	new Array:arr

	if (!handle || !TrieGetCell(handle, key, arr))
		return false

	ArrayGetArray(arr, 0, output)

	return true
}
#endif