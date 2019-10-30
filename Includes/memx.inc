/* MemoryX
 * (C)2007 Kuchiki Rukia
 * Licensed under the GNU General Public License.
 * No warranties of any kind.
 */

#if defined _memx_included
  #endinput
#endif
#define _memx_included

#if AMXX_VERSION_NUM >= 175
 #pragma reqlib MemX
 #if !defined AMXMODX_NOAUTOLOAD
  #pragma loadlib MemX
 #endif
#else
 #pragma library MemX
#endif

// * STL/ArrayX

// Simple containers
#include <memx_any>
#include <memx_pair>

// Non-iterated containers
#include <memx_queue>
#include <memx_stack>
//#include <memx_prioqueue>

// Iterated containers
#include <memx_iterator>

// <int,val> Maps
#include <memx_vector>
#include <memx_deque>

// <string,val> Maps
//#include <memx_map>
//#include <memx_hashmap>
//#include <memx_triemap>

// Old trie-based types
//#include <memx_array>
//#include <memx_keytable>
//#include <memx_hashtable>

// * MemHack

//#include <memx_hack>

// * MemCall

//#include <memx_call>

// * OOP

//#include <memx_oop>