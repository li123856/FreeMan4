new ServerID;
new ServerRunTime;
new ServerModeText[80];
new ORM:ServerOrm;
PLC::Server_OnGameModeInit()
{
    ServerID=1;
    new ORM:ormid = ServerOrm = orm_create(SQL_SERVER_DATABASE);
    orm_addvar_int(ormid, ServerID, "ID");
    orm_addvar_int(ormid, ServerRunTime, "RUNTIME");
    orm_addvar_string(ormid, ServerModeText,80, "MODETEXT");
    orm_setkey(ormid, "ID");
    orm_select(ormid, "OnSeverDataLoad", "d", 1);
	return 1;
}
PLC::OnSeverDataLoad(playerid)
{
	switch(orm_errno(ServerOrm))
	{
		case ERROR_OK:
		{
            SetGameModeText(ServerModeText);
		}
		case ERROR_NO_DATA:
		{

		}
	}
	return 1;
}
PLC::SeverUpdate()
{
    ServerRunTime++;
    orm_update(ServerOrm);
    UpdateSeverRunModeTexT();
}
stock UpdateSeverRunModeTexT()
{
    new line[128],rday,rhour,rmin;
    ConvertMinTime(ServerRunTime,rday,rhour,rmin);
	format(line, sizeof(line),"gamemodetext 运行时间:%i天%i小时%i分钟",rday,rhour,rmin);
	SendRconCommand(line);
    return 1;
}
stock GetServerRuningTime()
{
    new line[128],rday,rhour,rmin;
    ConvertMinTime(ServerRunTime,rday,rhour,rmin);
	format(line, sizeof(line),"%i天%i小时%i分钟",rday,rhour,rmin);
    return line;
}
stock ConvertMinTime(Min,&rDay,&rHour,&rMin)
{
	rDay			=	Min 	/ 	1440;
	Min	-=	rDay			*	1440;
	rHour			=	Min 	/ 	60;
	Min	-=	rHour			*	60;
	rMin				=	Min	;
}

