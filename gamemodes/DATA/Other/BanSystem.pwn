enum baninfo
{
    ORM:_orm,
    _id,
    _pid,
    _makeman,
	_join,
	_limit,
	_createtime[40],
	_reason[128]
}
new ban[MAX_PLAYERS][baninfo];
PLC::Ban_OnPlayerCome(playerid)
{
    ban[playerid][_pid]=pdate[playerid][_uid];
    new ORM:ormid = ban[playerid][_orm] = orm_create(SQL_BAN_DATABASE);
    orm_addvar_int(ormid, ban[playerid][_id], "ID");
    orm_addvar_int(ormid, ban[playerid][_pid], "PID");
    orm_addvar_int(ormid, ban[playerid][_makeman], "MAKEMAN");
    orm_addvar_int(ormid, ban[playerid][_join], "JOIN");
    orm_addvar_int(ormid, ban[playerid][_limit], "LIMIT");
    orm_addvar_string(ormid, ban[playerid][_createtime],40,"CREATETIME");
    orm_addvar_string(ormid, ban[playerid][_reason],128,"REASON");
    orm_setkey(ormid, "PID");
    orm_select(ormid, "OnBanDataLoad", "d",playerid);
	return 1;
}
PLC::Ban_OnPlayerDisconnect(playerid, reason)
{
    orm_destroy(ban[playerid][_orm]);
    return 1;
}
PLC::OnBanDataLoad(playerid)
{
    orm_setkey(ban[playerid][_orm],"ID");
	switch(orm_errno(ban[playerid][_orm]))
	{
		case ERROR_NO_DATA:
		{
		    ban[playerid][_pid]=pdate[playerid][_uid];
		    ban[playerid][_join]=NOTHING;
		    ban[playerid][_limit]=0;
		    orm_insert(ban[playerid][_orm]);
		}
	}
	return 1;
}
PLC::GetPlayerBanDate(playerid)
{
	if(ban[playerid][_join]!=NOTHING)
	{
	    if(ban[playerid][_limit]-(ServerRunTime-ban[playerid][_join])>0)return 1;
		else
		{
		    ban[playerid][_limit]=NOTHING;
		    ban[playerid][_makeman]=NOTHING;
		    ban[playerid][_join]=NOTHING;
		   	format(ban[playerid][_createtime],40, " ");
		   	format(ban[playerid][_reason],128," ");
		   	orm_update(ban[playerid][_orm]);
		   	return 0;
		}
	}
	return 0;
}
stock BanStr(playerid)
{
	new body[1024],line[256];
	format(line, sizeof(line),"封锁日期:%s\n",ban[playerid][_createtime]);
	strcat(body,line);
	format(line,sizeof(line),"封锁理由:%s\n",ban[playerid][_reason]);
	strcat(body,line);
	format(line,sizeof(line),"执行人:%s\n",GetPidName(ban[playerid][_makeman]));
	strcat(body,line);
	format(line,sizeof(line),"剩余封锁时间:%s\n",GetTimeStr(ban[playerid][_limit]-(ServerRunTime-ban[playerid][_join])));
	strcat(body,line);
	return body;
}
PLC::BanPlayer(playerid,baner,minute,reason[])
{
    ban[playerid][_limit]=minute;
    ban[playerid][_makeman]=pdate[baner][_uid];
    ban[playerid][_join]=ServerRunTime;
	new date[3];
	new time[3];
	getdate(date[0], date[1], date[2]);
	gettime(time[0], time[1], time[2]);
   	format(ban[playerid][_createtime],40, "%d/%d/%d %02d:%02d:%02d",date[0],date[1],date[2],time[0],time[1],time[2]);
   	format(ban[playerid][_reason],128,reason);
   	orm_update(ban[playerid][_orm]);
   	Dialog_Show(playerid,_BAN_MTO,DIALOG_STYLE_MSGBOX,"你被封锁了",BanStr(playerid), "呃", "");
   	KickEx(playerid);
	return 1;
}
PLC::UnBanPlayer(pid)
{
	new query[256];
	format(query, sizeof(query),"UPDATE `"SQL_BAN_DATABASE"` SET  `MAKEMAN` =  '%i',`JOIN` =  '%i',`LIMIT` =  '%i',`REASON` =  '%s',`CREATETIME` =  '%s' WHERE  `"SQL_BAN_DATABASE"`.`PID` ='%i'",NOTHING,NOTHING,NOTHING," "," ",pid);
	mysql_query(1,query,false);
	return 1;
}
