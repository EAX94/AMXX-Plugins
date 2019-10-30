#include < SpecialGeoipConst >

#pragma library "SpecialGeoip"

/*
	Gets client geographic data taken by Special Geoip extension!

	Make sure you use this after at least 0.2 seconds after ClientPutInServer forward has been executed!

	For DataType, you should check SpecialGeoipConst file!
*/

native GetClientGeoData( Player, DataType, Data[ ], DataLength );