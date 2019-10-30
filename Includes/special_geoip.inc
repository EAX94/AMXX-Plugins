/** Special Geoip v1.0.0.1
 * by Hattrick (Claudiu HKS)
 */

#if defined _special_geoip_included
   #endinput
#endif

#define _special_geoip_included

#if AMXX_VERSION_NUM >= 175
   #pragma reqlib special_geoip

   #if !defined AMXMODX_NOAUTOLOAD
      #pragma loadlib special_geoip
   #endif
#else
   #pragma library special_geoip
#endif

/** Util functions.
 */
stock AddCommas(Num, Output[], Len)
{
   static Tmp[16], OutputPos = 0, NumPos = 0, NumLen = 0;

   OutputPos = NumPos = 0;

   if (Num < 0)
   {
      Output[OutputPos++] = '-';

      Num = abs(Num);
   }

   NumLen = num_to_str(Num, Tmp, charsmax(Tmp));

   if (NumLen <= 3)
      OutputPos += copy(Output[OutputPos], Len, Tmp);

   else
   {
      while (NumPos < NumLen && OutputPos < Len)
      {
         Output[OutputPos++] = Tmp[NumPos++];

         if (NumLen - NumPos && !((NumLen - NumPos) % 3))
            Output[OutputPos++] = ',';
      }

      Output[OutputPos] = '^0';
   }
}

stock GeoipStripAddress(Address[])
{
   static Iterator = 0;

   for (Iterator = strlen(Address) - 1; Iterator >= 0; Iterator--)
   {
      if (Address[Iterator] == ':')
      {
         Address[Iterator] = '^0';

         break;
      }
   }
}

stock GeoipFloatCommas(Float:Value, Buffer[], Size)
{
   AddCommas(floatround(Value), Buffer, Size);
}

stock GeoipNumCommas(Value, Buffer[], Size)
{
   AddCommas(Value, Buffer, Size);
}

/** Math predefinitions.
 */
#define F_Cos floatcos
#define F_Sin floatsin

stock Float:F_ACos(Float:Value)
{
   return floatacos(Value, radian);
}

stock Float:F_ASin(Float:Value)
{
   return floatasin(Value, radian);
}

/** Defines Geoip charsets.
 */
enum GeoCharset
{
   GC_ISO8859 =	0,	// Normal characters.
   GC_UTF8 =	1	// Special characters.
};

/** Defines Geoip informations.
 */
enum GeoInfo
{
   /** Some examples below.
    */
   GI_Country =		0,	// Romania		United States
   GI_CountryCode =	1,	// RO			US
   GI_CountryCode3 =	2,	// ROU			USA
   GI_Region =		3,	// Cluj			New York
   GI_TimeZone =		4,	// Europe/Bucharest	America/New_York
   GI_City =		5,	// Turda			New Rochelle
   GI_ContinentCode =	6,	// EU			NA
   GI_RegionCode =		7,	// 13			NY
   GI_Latitude =		8,	// 46.566700		40.911499
   GI_Longitude =		9,	// 23.783300		-73.782303
   GI_AreaCode =		10,	// 0			914
   GI_PostalCode =		11,	// N/A			N/A
   GI_MetroCode =		12,	// 0			501
   GI_DmaCode =		13,	// 0			501
   GI_NetMask =		14,	// 21			22
   GI_Continent =		15,	// Europe			North America
   GI_Charset =		16	// 1			1
};

/** Retrieves a result.
 *
 * @param Address		The IP address to retrieve information from.
 * @param Info		The information to retrieve.
 * @param Buffer		The variable to store result in.
 * @param Size		The variable that represents the buffer size.
 *
 * @return		True if success.
 */
native /* bool */		bool:GeoipInfo(const Address[], GeoInfo:Info, Buffer[], Size);

/** Changes charset.
 *
 * @param Charset		The charset to set.
 *
 * @return		True.
 */
native /* void */		GeoipCharset(GeoCharset:Charset);

/** Retrieves distance.
 *
 * Thanks Arkshine (@Forums.AlliedMods.Com) for this.
 * 0.017453 means PI / 180U and 3959U and 6371U means Earth radius both for imperial and metrical measurement systems.
 *
 * @param Address		The first IP address.
 * @param Other		The second IP address.
 * @param Imperial		Whether or not to use imperial measurement system.
 *
 * @return		The distance, if any. Otherwise, zero.
 */
stock /* long double */	Float:GeoipDistance(const Address[], const Other[], bool:Imperial = true)
{
   static AddressLatitude[16], AddressLongitude[16], OtherLatitude[16], OtherLongitude[16], \
      Float:fAddressLatitude = 0.0, Float:fAddressLongitude = 0.0, Float:fOtherLatitude = 0.0, Float:fOtherLongitude = 0.0;

   if (GeoipInfo(Address, GI_Latitude, AddressLatitude, charsmax(AddressLatitude)) && GeoipInfo(Other, GI_Latitude, OtherLatitude, charsmax(OtherLatitude)) && \
      GeoipInfo(Address, GI_Longitude, AddressLongitude, charsmax(AddressLongitude)) && GeoipInfo(Other, GI_Longitude, OtherLongitude, charsmax(OtherLongitude)))
      {
         fAddressLatitude = str_to_float(AddressLatitude) * 0.017453, fOtherLatitude = str_to_float(OtherLatitude) * 0.017453;
         fAddressLongitude = str_to_float(AddressLongitude) * 0.017453, fOtherLongitude = str_to_float(OtherLongitude) * 0.017453;

         return Imperial ? \
            F_ACos(F_Sin(fAddressLatitude) * F_Sin(fOtherLatitude) + F_Cos(fAddressLatitude) * F_Cos(fOtherLatitude) * F_Cos(fOtherLongitude - fAddressLongitude)) * 3959.0 : \
            F_ACos(F_Sin(fAddressLatitude) * F_Sin(fOtherLatitude) + F_Cos(fAddressLatitude) * F_Cos(fOtherLatitude) * F_Cos(fOtherLongitude - fAddressLongitude)) * 6371.0;
   }

   return 0.0;
}

/** Retrieves distance between client and server.
 *
 * Experimental function. This will only work whether server's IP address is the real one (not the local one).
 *
 * @param Client		Client to compare distance with.
 * @param Imperial		Whether or not to use imperial measurement system.
 *
 * @return		The distance, if any. Otherwise, zero.
 */
stock /* long double */	Float:GeoipClientDistance(Client, bool:Imperial = true)
{
   static ServerAddress[64], ClientAddress[64], \
      Float:Distance = 0.0;

   if (!is_user_connected(Client) || is_user_bot(Client))
   {
      return 0.0;
   }

   get_cvar_string("net_address", ServerAddress, charsmax(ServerAddress));

   GeoipStripAddress(ServerAddress);

   get_user_ip(Client, ClientAddress, charsmax(ClientAddress), 1);

   Distance = GeoipDistance(ClientAddress, ServerAddress, Imperial);

   if (Distance == 0.0)
   {
      get_cvar_string("ip", ServerAddress, charsmax(ServerAddress));

      GeoipStripAddress(ServerAddress);

      Distance = GeoipDistance(ClientAddress, ServerAddress, Imperial);
   }

   return Distance;
}
