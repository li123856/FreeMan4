PLC::OnTeleLoad()
{
    forex(r,cache_num_rows())
	{
		new ORM:ormid = tele[r][_orm] = orm_create(SQL_TELE_DATABASE);
		orm_addvar_string(ormid, tele[r][_cmd],40,"CMD");
		orm_addvar_string(ormid, tele[r][_name],80,"NAME");
		orm_addvar_string(ormid, tele[r][_createtime],40,"CREATETIME");
		orm_addvar_int(ormid, tele[r][_pid],"PID");
		orm_addvar_float(ormid, tele[r][_x],"X");
		orm_addvar_float(ormid, tele[r][_y],"Y");
		orm_addvar_float(ormid, tele[r][_z],"Z");
		orm_addvar_float(ormid, tele[r][_a],"A");
		orm_addvar_int(ormid, tele[r][_id], "ID");
		orm_addvar_int(ormid, tele[r][_interior],"INTERIOR");
		orm_addvar_int(ormid, tele[r][_world],"WORLD");
		orm_addvar_int(ormid, tele[r][_cost],"COST");
		orm_addvar_int(ormid, tele[r][_moneybox],"MONEYBOX");
		orm_addvar_int(ormid, tele[r][_rate],"RATE");
		orm_addvar_float(ormid, tele[r][_range1],"RANGE1");
		orm_addvar_float(ormid, tele[r][_range2],"RANGE2");
		orm_apply_cache(ormid, r);
		orm_setkey(ormid,"ID");
		Iter_Add(tele,r);
	}
	return 1;
}
stock addtele(playerid,cmd[],name[])
{
    if(Iter_Free(tele) == -1) return 0;
    new r = Iter_Free(tele);
    format(tele[r][_cmd],40,cmd);
    format(tele[r][_name],80,name);
    tele[r][_pid]=pdate[playerid][_uid];
    tele[r][_cost]=0;
    tele[r][_moneybox]=0;
    tele[r][_rate]=0;
    tele[r][_range1]=0;
    tele[r][_range2]=0;
	new date[3];
	new time[3];
	getdate(date[0], date[1], date[2]);
	gettime(time[0], time[1], time[2]);
   	format(tele[r][_createtime],40, "%d/%d/%d %02d:%02d:%02d",date[0],date[1],date[2],time[0],time[1],time[2]);
	GetPlayerPos(playerid,tele[r][_x],tele[r][_y],tele[r][_z]);
	tele[r][_interior]=GetPlayerInterior(playerid);
	tele[r][_world]=GetPlayerVirtualWorld(playerid);

	new ORM:ormid = tele[r][_orm] = orm_create(SQL_TELE_DATABASE);
	orm_addvar_string(ormid, tele[r][_cmd],40,"CMD");
	orm_addvar_string(ormid, tele[r][_name],80,"NAME");
	orm_addvar_string(ormid, tele[r][_createtime],40,"CREATETIME");
	orm_addvar_int(ormid, tele[r][_pid],"PID");
	orm_addvar_float(ormid, tele[r][_x],"X");
	orm_addvar_float(ormid, tele[r][_y],"Y");
	orm_addvar_float(ormid, tele[r][_z],"Z");
	orm_addvar_float(ormid, tele[r][_a],"A");
	orm_addvar_int(ormid, tele[r][_id], "ID");
	orm_addvar_int(ormid, tele[r][_interior],"INTERIOR");
	orm_addvar_int(ormid, tele[r][_world],"WORLD");
	orm_addvar_int(ormid, tele[r][_cost],"COST");
	orm_addvar_int(ormid, tele[r][_moneybox],"MONEYBOX");
	orm_addvar_int(ormid, tele[r][_rate],"RATE");
	orm_addvar_float(ormid, tele[r][_range1],"RANGE1");
	orm_addvar_float(ormid, tele[r][_range2],"RANGE2");
	orm_insert(ormid,"Tele_Create","ii",playerid,r);
	return 1;
}
PLC::Tele_Create(playerid,teleid)
{
	Iter_Add(tele,teleid);
	orm_setkey(tele[teleid][_orm],"ID");
	new line[128];
	format(line,sizeof(line),""CHAT_YELLOW"[传送] 你成功创建了传送 %s[/%s]",tele[teleid][_name],tele[teleid][_cmd]);
	SCM(playerid,line);
	return 1;
}
PLC::Tele_Delete(teleid)
{
	if(!Iter_Contains(tele,teleid))return 0;
    orm_delete(tele[teleid][_orm],true);
    Iter_Remove(tele,teleid);
	return 1;
}
stock ShowMyTeleList(playerid,pager)
{
    listarray[playerid]=1;
    for(new i=Iter_End(tele);(i=Iter_Prev(tele, i))!=Iter_Begin(tele);)
	{
	    if(tele[i][_pid]==pdate[playerid][_uid])
	    {
			totals[playerid][listarray[playerid]]=i;
	      	listarray[playerid]++;
      	}
	}
    new body[1024];
    pager = (pager-1)*MAX_DILOG_LIST;
    if(pager == 0)pager = 1;
	else pager++;
	new over=0;
	format(body,sizeof(body), "名称\t创建时间\n");
	strcat(body, "\t\t"CHAT_SERVER"上一页\n");
	Loop(i,pager,pager+MAX_DILOG_LIST)
	{
		new line[100],index=totals[playerid][i];
		if(i<listarray[playerid])format(line,sizeof(line),"%s\t%s\n",tele[index][_name],tele[index][_createtime]);
		if(i>=listarray[playerid])
		{
			over=1;
			break;
		}
		else strcat(body,line);
	}
	if(over==0)strcat(body, "\t\t"CHAT_SERVER"下一页\n");
    return body;
}
Dialog:_TELE_MY_LIST(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager=(page[playerid]-1)*MAX_DILOG_LIST;
		if(pager == 0)pager = 1;
		else pager++;
		switch(listitem)
		{
		    case 0:
		  	{
		    	page[playerid]--;
		    	if(page[playerid]<1)
		    	{
		    	    page[playerid]=1;
		    	    SCM(playerid,""CHAT_YELLOW"[传送] 没有上一页了");
		    	}
				Dialog_Show(playerid,_TELE_MY_LIST,DIALOG_STYLE_TABLIST_HEADERS,"我的传送/wdcs 创建传送/cs add",ShowMyTeleList(playerid,page[playerid]), "详情", "取消");
		    }
		    case MAX_DILOG_LIST+1:
		    {
	    		page[playerid]++;
				Dialog_Show(playerid,_TELE_MY_LIST,DIALOG_STYLE_TABLIST_HEADERS,"我的传送/wdcs 创建传送/cs add",ShowMyTeleList(playerid,page[playerid]), "详情", "取消");
		    }
			default:
			{
				new index=totals[playerid][pager+listitem-1];
                ReadMyTele(playerid,index);
			}
		}
	}
	return 1;
}
PLC::ReadMyTele(playerid,teleid)
{
	new caption[100];
	format(caption,sizeof(caption),"%s  /%s",tele[teleid][_name],tele[teleid][_cmd]);
	new body[1024],line[256];
	format(line, sizeof(line),"创建时间:%s\n",tele[teleid][_createtime]);
	strcat(body,line);
	format(line, sizeof(line),"收费:$%i\n",tele[teleid][_cost]);
	strcat(body,line);
	format(line, sizeof(line),"收入:$%i\n",tele[teleid][_moneybox]);
	strcat(body,line);
	format(line, sizeof(line),"流量:%i\n",tele[teleid][_rate]);
	strcat(body,line);
	Dialog_Show(playerid,_TELE_MY_READ,DIALOG_STYLE_MSGBOX,caption,body, "操作", "返回",ARRAY_MODE_TELE,teleid);
	SetPVarInt(playerid,"Tele_My_Index",teleid);
	return 1;
}
Dialog:_TELE_MY_READ(playerid, response, listitem, inputtext[])
{
    new index=GetPVarInt(playerid,"Tele_My_Index");
	if(response)Dialog_Show(playerid,_TELE_READ_DO, DIALOG_STYLE_LIST,"传送操作","调整收费\n提取收入\n传送偏移\n清空流量\n删除传送\n清空传送", "选择", "返回",ARRAY_MODE_TELE,index);
	else Dialog_Show(playerid,_TELE_MY_LIST,DIALOG_STYLE_TABLIST_HEADERS,"我的传送/wdcs 创建传送/add cs",ShowMyTeleList(playerid,page[playerid]), "详情", "取消",ARRAY_MODE_TELE,index);
	return 1;
}
Dialog:_TELE_READ_DO(playerid, response, listitem, inputtext[])
{
    new index=GetPVarInt(playerid,"Tele_My_Index");
    if(response)
    {
		switch(listitem)
		{
		    case 0:Dialog_Show(playerid,_TELE_MY_TELE_COST,DIALOG_STYLE_INPUT,"调整收费","请输入收费数值,范围 [0到100000000之间]", "确定", "返回",ARRAY_MODE_TELE,index);
		    case 1:
		    {
		        if(tele[index][_moneybox]<1)
		        {
		        	ReadMyTele(playerid,index);
		        	SCM(playerid,""CHAT_YELLOW"[传送] 该传送收入为 0,无法提取");
		        }
		        else
		        {
		            GiveCash(playerid,tele[index][_moneybox]);
		            tele[index][_moneybox]=0;
		            orm_update(tele[index][_orm]);
		        	ReadMyTele(playerid,index);
		        	SCM(playerid,""CHAT_YELLOW"[传送] 该传送提取成功");
		        }
		    }
		    case 2:Dialog_Show(playerid,_TELE_MY_TELE_RANG,DIALOG_STYLE_LIST,"偏移","上下偏移\n左右偏移", "选择", "返回",ARRAY_MODE_TELE,index);
		    case 3:
		    {
		        tele[index][_rate]=0;
		        orm_update(tele[index][_orm]);
		        SCM(playerid,""CHAT_YELLOW"[传送] 该传送流量已归0");
		        ReadMyTele(playerid,index);
		    }
		    case 4:
		    {
		        orm_delete(tele[index][_orm],true);
                Iter_Remove(tele,index);
                Dialog_Show(playerid,_TELE_MY_LIST,DIALOG_STYLE_TABLIST_HEADERS,"我的传送/wdcs 创建传送/add cs",ShowMyTeleList(playerid,page[playerid]), "详情", "取消");
                SCM(playerid,""CHAT_YELLOW"[传送] 该传送已被删除");
		    }
		    case 5:
		    {
				foreach(new i : tele)
			   	{
			   	    new	cur = i;
					if(tele[cur][_pid]==pdate[playerid][_uid])
					{
					    orm_delete(tele[i][_orm],true);
					    Iter_SafeRemove(tele,cur,i);
		     		}
				}
                SCM(playerid,""CHAT_YELLOW"[传送] 你的传送已被清空");
		    }
		}
    }
    else ReadMyTele(playerid,index);
    return 1;
}
Dialog:_TELE_MY_TELE_COST(playerid, response, listitem, inputtext[])
{
    new index=GetPVarInt(playerid,"Tele_My_Index");
    if(response)
    {
        if(strval(inputtext)<0||strval(inputtext)>100000000)return Dialog_Show(playerid,_TELE_MY_TELE_COST,DIALOG_STYLE_INPUT,"调整收费","请输入收费数值,范围 [0到100000000之间]", "确定", "返回",ARRAY_MODE_TELE,index);
        tele[index][_cost]=strval(inputtext);
        orm_update(tele[index][_orm]);
        ReadMyTele(playerid,index);
        SCM(playerid,""CHAT_YELLOW"[传送] 该传送收费调整成功");
    }
    else ReadMyTele(playerid,index);
    return 1;
}
Dialog:_TELE_MY_TELE_RANG(playerid, response, listitem, inputtext[])
{
    new index=GetPVarInt(playerid,"Tele_My_Index");
    if(response)
    {
        switch(listitem)
        {
            case 0:Dialog_Show(playerid,_TELE_MY_TELE_UPDOWN,DIALOG_STYLE_INPUT,"微调","请输入上下微调数值,范围 [-5.0到5.0之间]", "确定", "返回",ARRAY_MODE_TELE,index);
            case 1:Dialog_Show(playerid,_TELE_MY_TELE_LEFTRIGHT,DIALOG_STYLE_INPUT,"微调","请输入左右微调数值,范围 [-5.0到5.0之间]", "确定", "返回",ARRAY_MODE_TELE,index);
		}
    }
    else ReadMyTele(playerid,index);
    return 1;
}
Dialog:_TELE_MY_TELE_UPDOWN(playerid, response, listitem, inputtext[])
{
    new index=GetPVarInt(playerid,"Tele_My_Index");
    if(response)
    {
        if(floatstr(inputtext)<-5.0||strval(inputtext)>5.0)return Dialog_Show(playerid,_TELE_MY_TELE_UPDOWN,DIALOG_STYLE_INPUT,"微调","请输入上下微调数值,范围 [-5.0到5.0之间]", "确定", "返回",ARRAY_MODE_TELE,index);
        tele[index][_range1]=floatstr(inputtext);
        orm_update(tele[index][_orm]);
        ReadMyTele(playerid,index);
        SCM(playerid,""CHAT_YELLOW"[传送] 该传送上下微调成功");
    }
    else ReadMyTele(playerid,index);
    return 1;
}
Dialog:_TELE_MY_TELE_LEFTRIGHT(playerid, response, listitem, inputtext[])
{
    new index=GetPVarInt(playerid,"Tele_My_Index");
    if(response)
    {
        if(floatstr(inputtext)<-5.0||strval(inputtext)>5.0)return Dialog_Show(playerid,_TELE_MY_TELE_LEFTRIGHT,DIALOG_STYLE_INPUT,"微调","请输入左右微调数值,范围 [-5.0到5.0之间]", "确定", "返回",ARRAY_MODE_TELE,index);
        tele[index][_range2]=floatstr(inputtext);
        orm_update(tele[index][_orm]);
        ReadMyTele(playerid,index);
        SCM(playerid,""CHAT_YELLOW"[传送] 该传送左右微调成功");
    }
    else ReadMyTele(playerid,index);
    return 1;
}

stock ShowTeleList(playerid,pager)
{
    listarray[playerid]=1;
    for(new i=Iter_End(tele);(i=Iter_Prev(tele, i))!=Iter_Begin(tele);)
	{
		totals[playerid][listarray[playerid]]=i;
      	listarray[playerid]++;
	}
    new body[1024];
    pager = (pager-1)*MAX_DILOG_LIST;
    if(pager == 0)pager = 1;
	else pager++;
	new over=0;
	format(body,sizeof(body), "名称\t收费\t流量\t收入\n");
	strcat(body, "\t\t"CHAT_SERVER"上一页\n");
	Loop(i,pager,pager+MAX_DILOG_LIST)
	{
		new line[100],index=totals[playerid][i];
		if(i<listarray[playerid])format(line,sizeof(line),"%s\t$%i\t%i\t%i\n",tele[index][_name],tele[index][_cost],tele[index][_rate],tele[index][_moneybox]);
		if(i>=listarray[playerid])
		{
			over=1;
			break;
		}
		else strcat(body,line);
	}
	if(over==0)strcat(body, "\t\t"CHAT_SERVER"下一页\n");
    return body;
}
Dialog:_TELE_LIST(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager=(page[playerid]-1)*MAX_DILOG_LIST;
		if(pager == 0)pager = 1;
		else pager++;
		switch(listitem)
		{
		    case 0:
		  	{
		    	page[playerid]--;
		    	if(page[playerid]<1)
		    	{
		    	    page[playerid]=1;
		    	    SCM(playerid,""CHAT_YELLOW"[传送] 没有上一页了");
		    	}
				Dialog_Show(playerid,_TELE_LIST,DIALOG_STYLE_TABLIST_HEADERS,"玩家传送/llcs",ShowTeleList(playerid,page[playerid]), "支付传送", "取消");
		    }
		    case MAX_DILOG_LIST+1:
		    {
	    		page[playerid]++;
				Dialog_Show(playerid,_TELE_LIST,DIALOG_STYLE_TABLIST_HEADERS,"玩家传送/llcs",ShowTeleList(playerid,page[playerid]), "支付传送", "取消");
		    }
			default:
			{
				new index=totals[playerid][pager+listitem-1];
				if(!Iter_Contains(tele,index))
				{
				    SCM(playerid,""CHAT_YELLOW"[传送] 该传送已失效");
				    return Dialog_Show(playerid,_TELE_LIST,DIALOG_STYLE_TABLIST_HEADERS,"玩家传送/llcs",ShowTeleList(playerid,page[playerid]), "支付传送", "取消");
				}
				TeleHandle(playerid,index);
			}
		}
	}
	return 1;
}
PLC::TeleHandle(playerid,teleid)
{
	if(tele[teleid][_pid]==pdate[playerid][_uid])TeleMsgAndGo(playerid,teleid);
    else if(EnoughCash(playerid,tele[teleid][_cost]))
	{
	    TeleMsgAndGo(playerid,teleid);
	    GiveCash(playerid,-tele[teleid][_cost]);
    	tele[teleid][_moneybox]+=tele[teleid][_cost];
    	tele[teleid][_rate]++;
    	orm_update(tele[teleid][_orm]);
	}
	else
    {
        new line[128];
		format(line, sizeof(line),"%s\n传送费用:%s\n创建者:%s",tele[teleid][_name],tele[teleid][_cost],GetPidName(tele[teleid][_pid]));
        Dialog_Show(playerid,_TELE_NOMONEY,DIALOG_STYLE_MSGBOX,"错误",line, "呃..", "",ARRAY_MODE_TELE,teleid);
    }
	return 1;
}
PLC::TeleMsgAndGo(playerid,teleid)
{
	new line[128];
	format(line, sizeof(line),TELE_NOTICE,pdate[playerid][_name],tele[teleid][_name],tele[teleid][_cmd],tele[teleid][_rate],GetPidName(tele[teleid][_pid]));
	SendClientMessageToAll(COLOR_WHITE,line);
    TeleportPlayer(playerid,tele[teleid][_x]+tele[teleid][_range1],tele[teleid][_y]+tele[teleid][_range1],tele[teleid][_z]+tele[teleid][_range2],tele[teleid][_a],tele[teleid][_interior],tele[teleid][_world],true);
	return 1;
}

