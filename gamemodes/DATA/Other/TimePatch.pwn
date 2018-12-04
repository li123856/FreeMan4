new Text:Time, Text:Date;
PLC::Time_OnGameModeInit()
{
	Date = TextDrawCreate(547.000000,11.000000,"--");
	TextDrawFont(Date,3);
	TextDrawLetterSize(Date,0.399999,1.600000);
    TextDrawColor(Date,0xffffffff);
	Time = TextDrawCreate(547.000000,28.000000,"--");
	TextDrawFont(Time,3);
	TextDrawLetterSize(Time,0.399999,1.600000);
	TextDrawColor(Time,0xffffffff);
	return 1;
}
PLC::Time_OnPlayerLogin(playerid)
{
	TextDrawShowForPlayer(playerid, Time), TextDrawShowForPlayer(playerid, Date);
	return 1;
}

PLC::Time_OnPlayerDisconnect(playerid, reason)
{
	TextDrawHideForPlayer(playerid, Time);
	TextDrawHideForPlayer(playerid, Date);
	return 1;
}
PLC::Settime()
{
	new string[256],year,month,day,hours,minutes,seconds;
	getdate(year, month, day), gettime(hours, minutes, seconds);
	format(string, sizeof string, "%d/%s%d/%s%d", day, ((month < 10) ? ("0") : ("")), month, (year < 10) ? ("0") : (""), year);
	TextDrawSetString(Date, string);
	format(string, sizeof string, "%s%d:%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes, (seconds < 10) ? ("0") : (""), seconds);
	TextDrawSetString(Time, string);
	return 1;
}
