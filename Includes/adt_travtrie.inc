#if defined _adt_travtrie_included
 #endinput
#endif
#define _adt_travtrie_included

#include <adt_array>
#include <adt_trie>

stock Handle:CreateTravTrie(keylength = 64, startsize = 0)
{
	new Handle:tmp = Handle:CreateTrie();
	SetTrieValue(tmp, "", CreateArray(keylength, startsize));
	return tmp;
}

stock bool:SetTravTrieValue(Handle:trie, const String:key[], any:value, bool:replace=true)
{
	if(key[0] == '\n') return false;
	
	new any:val;
	if(!GetTravTrieValue(trie, key, val) )
	{
		new Handle:inter;
		if(!GetTrieValue(trie,"",any:inter)) return false;
	
		PushArrayString(inter,key);
		
	}
	return (key[0] == '\n') ? false : SetTrieValue(trie,key,value,replace);
}

stock bool:SetTravTrieArray(Handle:trie, const String:key[], const array[], num_items, bool:replace=true)
{                                       
	if(key[0] == '\n') return false;
	
	new val[2];
	if(!GetTravTrieArray(trie, key, val,sizeof(val)) )
	{
		new Handle:inter;
		if(!GetTrieValue(trie,"",any:inter)) return false;
	
		PushArrayString(inter,key);
	}
	
	return (key[0] == '\n') ? false : SetTrieArray(trie,key,array,num_items,replace);
}

stock bool:SetTravTrieString(Handle:trie, const String:key[], String:value[], bool:replace=true)
{
	if(key[0] == '\n') return false;
	
	new String:val[4];
	if(!GetTravTrieString(trie, key, val,sizeof(val)) )
	{
		new Handle:inter;
		if(!GetTrieValue(trie,"",any:inter)) return false;
	
		PushArrayString(inter,key);
	}
	
	return (key[0] == '\n') ? false : SetTrieString(trie,key,value,replace);
}

stock bool:GetTravTrieValue(Handle:trie, const String:key[], &any:value)
{
	return (key[0] == '\n') ? false : GetTrieValue(trie,key,value);
}

stock bool:GetTravTrieArray(Handle:trie, const String:key[], const array[], num_items, &size=0)
{
	return (key[0] == '\n') ? false : GetTrieArray(trie,key,array,num_items,size);
}

stock bool:GetTravTrieString(Handle:trie, const String:key[], String:value[], max_size, &size=0)
{
	return (key[0] == '\n') ? false : GetTrieString(trie,key,value,max_size,size);
}

stock bool:RemoveFromTravTrie(Handle:trie, const String:key[])
{
	if(key[0] != '\n' && RemoveFromTrie(trie,key) )
	{
		new Handle:inter;
		if(!GetTrieValue(trie,"",any:inter)) return;
	
		new index = FindStringInArray(inter, key);
		return RemoveFromArray(inter, index);
	}
	return false;
}

stock ClearTravTrie(Handle:trie)
{
		new Handle:inter;
		if(!GetTrieValue(trie,"",any:inter)) { ClearTrie(trie); return; }

		ClearArray(inter);
		ClearTrie(trie);
}

stock GetTravTrieSize(Handle:trie) return GetTrieSize(trie) - 1;

// Rukia: Use this to prepare the TravTrie for SORTED traversal
//	If you do not use this, it will be traversed in FIFO order
stock bool:PrepareTravTrie(Handle:trie) 
{
	new Handle:inter;
	if(!GetTrieValue(trie,"",any:inter)) { ClearTrie(trie); return; }

	SortADTArray(inter, Sort_Descending, Sort_String);
}

// Rukia: Get a mutable iterator to the travtrie
//	This Handle MUST be closed using CloseHandle, and delete/insert will invalidate iterator
stock Handle:GetTravTrieIterator(Handle:trie)
{
	new Handle:dp = CreateDataPack();
	WritePackCell(dp,_:trie);
	WritePackCell(dp,0);
	return dp;
}

// Rukia: Read the string key that the iterator points to.
//	WILL NOT INCREMENT ITERATOR
stock ReadTravTrieKey(Handle:dp,String:key[],len)
{
	ResetPack(dp);
	new Handle:trie = Handle:ReadPackCell(dp);
	
	new Handle:inter;
	if(!GetTrieValue(trie,"",any:inter)) return;
	
	new index = ReadPackCell(dp);
	GetArrayString(inter,index,key,len);
}

// Rukia: These functions read from the travtrie via the iterator
//	They WILL INCREMENT THE ITERATOR

stock bool:ReadTravTrieValue(Handle:dp,&any:value)
{
	decl String:tmp[1024];
	new Handle:trie = TraveTrieIteratorHandler(dp,tmp,sizeof(tmp));
	
	return GetTrieValue(trie,tmp,value);
}

stock bool:ReadTravTrieArray(Handle:dp, value[], max_num, &size = 0)
{
	decl String:tmp[1024];
	new Handle:trie = TraveTrieIteratorHandler(dp,tmp,sizeof(tmp));
	
	return GetTrieArray(trie,tmp,value,max_num,size);
}

stock bool:ReadTravTrieString(Handle:dp, String:value[], max_num, &size = 0)
{
	decl String:tmp[1024];
	new Handle:trie = TraveTrieIteratorHandler(dp,tmp,sizeof(tmp));
	
	return GetTrieString(trie,tmp,value,max_num,size);
}

stock Handle:TraveTrieIteratorHandler(Handle:dp,String:pos[],len)
{
	ResetPack(dp);
	new Handle:trie = Handle:ReadPackCell(dp);
	
	new Handle:inter;
	if(!GetTrieValue(trie,"",any:inter)) return INVALID_HANDLE;
	
	new index = ReadPackCell(dp);
	GetArrayString(inter,index,pos,len);
	
	ResetPack(dp);
	WritePackCell(dp,_:trie);
	WritePackCell(dp,index + 1);
	
	return trie;
}

// Rukia: Returns true if there is more to read from the iterator

stock bool:MoreTravTrie(Handle:dp)
{
	ResetPack(dp);
	new Handle:trie = Handle:ReadPackCell(dp);
	
	new Handle:inter;
	if(!GetTrieValue(trie,"",any:inter)) return false;
	
	new index = ReadPackCell(dp);
	if(GetArraySize(inter) <= index) return false;
	
	return true;
}
	
	