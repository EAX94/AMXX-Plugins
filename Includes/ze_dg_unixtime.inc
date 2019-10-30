#include <amxmodx>

stock const g_year_seconds[2] = 
{ 
	31536000,	// Normal year
	31622400 	// Leap year
}

stock const g_month_seconds[12] = 
{ 
	2678400, // January		31 
	2419200, // February	28
	2678400, // March		31
	2592000, // April		30
	2678400, // May			31
	2592000, // June		30
	2678400, // July		31
	2678400, // August		31
	2592000, // September	30
	2678400, // October		31
	2592000, // November	30
	2678400  // December	31
}

stock const g_day_seconds = 86400
stock const g_hour_seconds = 3600
stock const g_minute_seconds = 60

stock unix_to_time(time_stamp , &year , &month , &day , &hour , &minute , &second)
{
	new temp
	
	year = 1970
	month = 1
	day = 1
	hour = 0

	while(time_stamp > 0)
	{
		temp = is_leap_year(year)

		if((time_stamp - g_year_seconds[temp]) >= 0)
		{
			time_stamp -= g_year_seconds[temp]
			year++
		}
		else break;
	}

	while(time_stamp > 0)
	{
		temp = seconds_in_month(year, month)

		if((time_stamp - temp) >= 0) 
		{
			time_stamp -= temp
			month++
		}
		else break;
	}

	while(time_stamp > 0)
	{
		if((time_stamp - g_day_seconds) >= 0)
		{
			time_stamp -= g_day_seconds
			day++
		}
		else break;
	}
	
	while(time_stamp > 0)
	{
		if((time_stamp - g_hour_seconds) >= 0)
		{
			time_stamp -= g_hour_seconds;
			hour++;
		}
		else break;
	}
	
	minute = (time_stamp / 60)
	second = (time_stamp % 60)
}

stock time_to_unix(const year, const month, const day, const hour, const minute, const second)
{
	new i, time_stamp

	for(i = 1970; i < year; i++)
		time_stamp += g_year_seconds[is_leap_year(i)]

	for(i = 1; i < month; i++)
		time_stamp += seconds_in_month(year, i)

	time_stamp += ((day - 1) * g_day_seconds)
	time_stamp += (hour * g_hour_seconds)
	time_stamp += (minute * g_minute_seconds)
	time_stamp += second

	return time_stamp;
}

stock seconds_in_month(const year, const month) 
	return ((is_leap_year(year) && (month == 2)) ? (g_month_seconds[month - 1] + g_day_seconds) : g_month_seconds[month - 1]);

stock is_leap_year(const year) 
	return (((year % 4) == 0) && (((year % 100) != 0) || ((year % 400) == 0)));