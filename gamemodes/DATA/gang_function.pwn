PLC::OnGangLoad()
{
    forex(r,cache_num_rows())
	{
		new ORM:ormid = gang[r][_orm] = orm_create(SQL_TELE_DATABASE);
		orm_addvar_string(ormid, gang[r][_name],80,"NAME");
		orm_addvar_string(ormid, gang[r][_createtime],40,"CREATETIME");
		orm_addvar_int(ormid, gang[r][_pid],"PID");
		orm_addvar_float(ormid, gang[r][_x],"X");
		orm_addvar_float(ormid, gang[r][_y],"Y");
		orm_addvar_float(ormid, gang[r][_z],"Z");
		orm_addvar_float(ormid, gang[r][_a],"A");
		orm_addvar_int(ormid, gang[r][_id], "ID");
		orm_addvar_int(ormid, gang[r][_color],"COLOR");
		orm_addvar_int(ormid, gang[r][_exp],"EXP");
		orm_addvar_int(ormid, gang[r][_level],"LEVEL");
		orm_addvar_int(ormid, gang[r][_moneybox],"MONEYBOX");
        orm_addvar_string(ormid, gang[r][_rank1],40,"RANK1");
        orm_addvar_string(ormid, gang[r][_rank2],40,"RANK2");
		orm_addvar_string(ormid, gang[r][_rank3],40,"RANK3");
        orm_addvar_string(ormid, gang[r][_rank4],40,"RANK4");
		orm_apply_cache(ormid, r);
		orm_setkey(ormid,"ID");
		Iter_Add(gang,r);
	}
	return 1;
}
stock addgang(playerid,name[])
{
    if(Iter_Free(gang) == -1) return 0;
    new r = Iter_Free(gang);
    format(gang[r][_name],80,name);
    format(gang[r][_rank1],40,GANG_RANK1);
    format(gang[r][_rank2],40,GANG_RANK2);
    format(gang[r][_rank3],40,GANG_RANK3);
    format(gang[r][_rank4],40,GANG_RANK4);
	new date[3];
	new time[3];
	getdate(date[0], date[1], date[2]);
	gettime(time[0], time[1], time[2]);
   	format(gang[r][_createtime],40, "%d/%d/%d %02d:%02d:%02d",date[0],date[1],date[2],time[0],time[1],time[2]);
    gang[r][_color]=0;
    gang[r][_exp]=0;
	gang[r][_level]=0;
	gang[r][_moneybox]=0;
	GetPlayerPos(playerid,gang[r][_x],gang[r][_y],gang[r][_z]);
	gang[r][_pid]=pdate[playerid][_uid];

	new ORM:ormid = gang[r][_orm] = orm_create(SQL_TELE_DATABASE);
	orm_addvar_string(ormid, gang[r][_name],80,"NAME");
	orm_addvar_string(ormid, gang[r][_createtime],40,"CREATETIME");
	orm_addvar_int(ormid, gang[r][_pid],"PID");
	orm_addvar_float(ormid, gang[r][_x],"X");
	orm_addvar_float(ormid, gang[r][_y],"Y");
	orm_addvar_float(ormid, gang[r][_z],"Z");
	orm_addvar_float(ormid, gang[r][_a],"A");
	orm_addvar_int(ormid, gang[r][_id], "ID");
	orm_addvar_int(ormid, gang[r][_color],"COLOR");
	orm_addvar_int(ormid, gang[r][_exp],"EXP");
	orm_addvar_int(ormid, gang[r][_level],"LEVEL");
	orm_addvar_int(ormid, gang[r][_moneybox],"MONEYBOX");
    orm_addvar_string(ormid, gang[r][_rank1],40,"RANK1");
    orm_addvar_string(ormid, gang[r][_rank2],40,"RANK2");
	orm_addvar_string(ormid, gang[r][_rank3],40,"RANK3");
    orm_addvar_string(ormid, gang[r][_rank4],40,"RANK4");
	orm_insert(ormid,"Gang_Create","ii",playerid,r);
	return 1;
}
PLC::Gang_Create(playerid,gid)
{
	Iter_Add(gang,gid);
	orm_setkey(gang[gid][_orm],"ID");
	pGang(playerid)=gid;
	pGangLevel(playerid)=3;
	orm_update(pdate[playerid][_orm]);
	new line[128];
	format(line,sizeof(line),""CHAT_YELLOW"[公司] 你成功创建了公司 %s",gang[gid][_name]);
	SCM(playerid,line);
	return 1;
}
PLC::Join_Gang(playerid,gid)
{
	pGang(playerid)=gid;
	pGangLevel(playerid)=0;
	orm_update(pdate[playerid][_orm]);
	return 1;
}
PLC::Exit_Gang(playerid,gid)
{
	pGang(playerid)=NOTHING;
	pGangLevel(playerid)=0;
	orm_update(pdate[playerid][_orm]);
	return 1;
}
PLC::Gang_Delete(gid)
{
	if(!Iter_Contains(gang,gid))return 0;
	foreach(new i:Player)if(pGang(i)==gid)Exit_Gang(i,gid);
	new query[128];
	format(query, sizeof(query),"UPDATE `"SQL_ACCOUT_DATABASE"` SET  `GID` =  '%i',`RANK` =  '%i' WHERE  `"SQL_ACCOUT_DATABASE"`.`GID` ='%i'",-1,0,gid);
	mysql_query(1,query,false);
    orm_delete(gang[gid][_orm],true);
    Iter_Remove(gang,gid);
	return 1;
}
stock RankReturn(gid,rank)
{
	new line[40];
	switch(rank)
	{
	    case 0:format(line,sizeof(line),gang[gid][_rank1]);
	    case 1:format(line,sizeof(line),gang[gid][_rank2]);
	    case 2:format(line,sizeof(line),gang[gid][_rank3]);
	    case 3:format(line,sizeof(line),gang[gid][_rank4]);
	}
	return line;
}
stock GetGangName(gid)return gang[gid][_name];
stock GetGangRankName(gid,rank)return RankReturn(gid,rank);


